import argparse
import sys
from googleapiclient import sample_tools
from tabulate import tabulate


argparser = argparse.ArgumentParser(add_help=False)
argparser.add_argument('property_uri', type=str,
                       help=('Site or app URI to query data for (including '
                             'trailing slash).'))
argparser.add_argument('start_date', type=str,
                       help=('Start date of the requested date range in '
                             'YYYY-MM-DD format.'))
argparser.add_argument('end_date', type=str,
                       help=('End date of the requested date range in '
                             'YYYY-MM-DD format.'))


def main(argv):
  service, flags = sample_tools.init(
      argv, 'webmasters', 'v3', __doc__, __file__, parents=[argparser],
      scope='https://www.googleapis.com/auth/webmasters.readonly')


  request = {
      'startDate': flags.start_date,
      'endDate': flags.end_date,
      'dimensions': ['query', 'date', 'page', 'device'],
      'rowLimit': 5000
  }
  response = execute_request(service, flags.property_uri, request)
  print_table(response, 'Top Queries')

def execute_request(service, property_uri, request):
  return service.searchanalytics().query(
      siteUrl=property_uri, body=request).execute()

def print_table(response, title):
    print title + ':'
    if 'rows' not in response:
        print 'Empty response'
        return
        rows = response['rows']
        row_format = '{:<20}' + '{:>20}' * 4
        print row_format.format('Keys', 'Date', 'Landing Page', 'Device', 'Clicks', 'Impressions', 'CTR', 'Position')
        for row in rows:
            keys = ''
            # Keys are returned only if one or more dimensions are requested.
            if 'keys' in row:
                keys = u','.join(row['keys']).encode('utf-8')
                print row_format.format(
                keys, row['impressions'], row['ctr'], row['position'])

if __name__ == '__main__':
  main(sys.argv)
