Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FCA3606A685
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jpFvmsm3
Received: by kanga.kvack.org (Postfix)
	id 275C16B0755; Tue, 24 Nov 2026 10:36:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 200606B0757; Tue, 24 Nov 2026 10:36:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 051106B0758; Tue, 24 Nov 2026 10:36:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5E8A6B0755
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:36:48 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 331F31C4694
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:47 +0000 (UTC)
X-FDA: 85470415254.20.6359081
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9FEA2A0007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jpFvmsm3;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534605;
	b=d0F70Jpdnfc4oK7TTwhNe9ToTxex3MaqmkWQ5BPwt0YXps5jIXe8+EhfaJpnF9K2gjlUXr
	CZ54CwU2bkCPwUmMZ14n1VtZpxJr6JfYPlbNb6oQBmCselU3sYIX4HvjsHO+smFeS6Oxeh
	1lvXQZCLjhecPpwKMqynkESycOgtOf0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hdajHxa9EcPKGfIZHE61KWcAuqEZ00JugbvcBD/6Hbs=;
	b=ODGzwlGErAI34rdTVuRwYehHLLRNoRiAWqAhDQPRe73/rufuN1Ie7ww9scJhoY1n5bPhUc
	8BgJcHEqP4cHbkrEJC5E8dgVxi4R7jHAM9ubCKECNrgcZa2g8sOMGxdiNn5x/dIZf0cjkN
	LMjQ9/1ZlV75LKe8sS5d9L5DMdfEzFo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jpFvmsm3;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1456462716;
	Tue, 24 Nov 2026 15:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF941F000CF;
	Tue, 24 Nov 2026 15:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534604;
	bh=hdajHxa9EcPKGfIZHE61KWcAuqEZ00JugbvcBD/6Hbs=;
	h=From:To:Cc:Subject:Date;
	b=jpFvmsm3Wa2YU93E0uL8xaVlxBqCxbK2c90uizAjQaP77UbRI99SK8rptmqa5bkOf
	 GWK2XnGtT8pmWMNm2MPz3Z9qwCmSnvShd7Eozf425YJhEBrZcvSpdUrdwufiJ5cKJf
	 wLeAxOy//ntag61CnbNN1QEFJUgCLKVR1/ecdj8u3uH/V5umEJzIERMSD2hALt4BG5
	 lYNc5l41tn0HkHJ2G4aBNsM7zW4GpeifoRYl252fMn8YSqd533ph+fw+ABZpWLeSTh
	 qW2RYiiVtp+dESbg2uV7l8kYrN7VjJiD7aBi5lyQdcwRYHHcXSPMbmlZSA8ERETEbR
	 kYJaLnIhDxq+w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 00/27] mm/damon: let users report their data attribute findings
Date: Tue, 24 Nov 2026 07:36:06 -0800
Message-ID: <20261124153636.91854-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9FEA2A0007
X-Stat-Signature: q6btks3x1fqa1mtrg36cmozb3ynzqgs4
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795534605-580867
X-HE-Meta: U2FsdGVkX1+GRuUl7IqFAjIdUNGxkfEvwLpoFe+oYGsnGzXfBC/mgOzFaDjJQX9jRwUqdlDOfSqQljUk0WhzizBzjA4Cai6aDn5G093sEBRLTBIK5n6OW/K35TXwbayqlQCLNRwGdcqDpWeftamHc57dI8ENo0raqqbFoLnoPlbFLIXeNWJJW+Sme8NovBNb/49dSsKPJ33Jp3PUrwQXG/9DtpmlqJ7O7rySoLLvtH88+nsSPS42tNd0hLG4SxRKLCdKEVd2+JMFxQCZWwenbyv01ZFdHut3qrvYDGIrujOTQZ/y9PB/q4uxQza4NmhZZwEClZ/npkYSF9kZ2MvTf28qOpFOu18h6HNecDgIarQEcAaRfEE5+Fykbvb9uOVE2w7k/cBQ9wWbbNzrg/7+BOA6LnlY1Bf/7Sg9WSVkIGPjr9RqjoLwjOGH9gDC1+VSm9Lr/4F+fOh4PBEmqOhKFhXuRYwMW50qkaK2nscCDRy7LUNlhSOhx3J8z/6r9nItvdBI7BlF4Xwg21aeL8jSaO1IO4d5gufV0Jxmde82oMktDhpbCfFFSLtSEYcNZzV5ii/Qb6zmozEESCF35lL0r+we2tXmd7KG6MOeXWUpsvrI8naFbpqWqUL4yQJt3l4MPQH9MIQA2xO/MGlFVhsYjQVrzsO9bd+tCsNubeyrgpPd9o98hNN7P+4B5iAE5LMwEYTeIRYhGHo9cVbat/RB95FCbcqIDWmMzHp9BnROTWIV4FnXkXmVPiEF89RsSP9O1A9HDPS1neOiSeRE7/4eGt+PL4Xn5OAiKTGCMjx5tn7RlkDqbxnazveh73avESeCGizDhPRYbbB1TFD4+ipwlxOF34uFaDydiX/toYc+eGHwz24n2kXSxY9HrVGdiGL0vUkm+0DDI2D9zak0e6lZS1LPRNdWqDQstkw7154rt1/NM/AQ0moPum4XpOz/BTwKK9b0D5aSv42++4CwChX
 NimQKp56
 f45S7/nTNecLJ0sMTYUACJd4ZR72eB4dlu2p8U6pHhY+VKge3atxkUDHlXEPWBJk/PoDL9KNUS/lz9FTsOP/U5PFdu1h8LR30Aao0M7D/lJrT/fP6O++ev6tnumDsb6OKMdthAJtOTDHWmZb8gIhHs8i/j9zzAsbaRcNyOo1j9TDoYIkZdE5y0DW8hxjohOe9VfM1QlSs2saJ692BaW7zJDlfljbDcY05QQu9imiPg6MsX8wtXfbTeU2Gqy8706EpjxEACJkMIZ7duetUm/dcacBz7WgygkCjwcI0nxbP96QQ9QmkFI+zrGGKKqCjblNh7XHPPvcwmLIa1i8ZoWOlDnGVHsm9gXtgq46poFk//oQ3izXZ1mqnWme1Jr2K1z7dj1/YjF2e2Pni+ieV4mRHns5mVx9ITpBu34LlChb1uPQQYSsyIBc5/R77WUvszD5Q/Q34f5HkIeywMuNIlPUPaAbr+YdfaRNgN/ohqGvpAjOfCpVk4QtwLDVk6uiUERVkXhmICGpMRX/4FLXKSl8u4TS1y0kn2QuwLCM1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

TL;DR
=====

Build a system for letting DAMON-external entities report their data
attribute findings to DAMON.  Let users report their data attribute
findings to DAMON using the report system.

When DAMON Extension Becomes Challenging
========================================

DAMON's probe based data attributes monitoring system allows flexible
extension of it for new types of information.  Such extensions are not
always easy, though.  That's because DAMON is collecting the information
on its own worker threads, kdamonds.  If the new information to extend
for is not already stored in a data structure that kdamonds can read,
the extension becomes difficult.

For example, extending DAMON for hugepage size of the given memory was
straightforward.  kdamonds can read that from folios.  Extending DAMON
for accessors or writes-only accesses is challenging because there is no
existing easy way to get that information from arbitrary threads like
kdamonds.

Extending DAMON for information that is not already available to
kdamonds requires two works.  Finding DAMON-external kernel components
that already have the information.  And modifying it to pass the
information to DAMON.  Finding and modifying the components inherently
need to be done for each of such extensions.  Building a universal way
to report the information to DAMON could make it much easier.

Modifying the component would be particularly challenging and even
controversial depending on each case.  Some components wouldn't want to
add a hacky change only for DAMON.  Having the universal report system
that is well maintained will be useful at convincing the component, too.

User Information
================

Users sometimes know some data attribute information more than what the
kernel can know.  They could know frequently accessed data.  They could
know that because they have access to the source code of the workload.
They could know that using non-DAMON kernel features.  They could know
that from some special tools and hardware.

DAMON is not only for monitoring but also operations.  DAMON finds
operation targets based on only its self monitoring results, though.
Letting users report their data attribute information allows more
flexible and effective control of the DAMON operations.  Users can make
DAMON to find operation targets based on both its self monitoring and
user-provided reports.

DAMON is not providing such ways to let users report their information,
though.

Report System and User Report Support
=====================================

DAMON lacks efficient DAMON-external information report system and user
report support.  Fill the gap.

Introduce a system to report information from kdamond-external entities
to DAMON.  Extend DAMON to monitor those reported information.  Build a
user interface for letting users report their findings.

Data Attribute Report System
============================

Introduce a system to report information from kdamond-external entities
to DAMON.  The report system let any kernel components in any context
including NMI context pass their data attribute finding to DAMON as a
report.

The system provides a data structure for such reports.  Using the report
data structure, a flexible data attribute information for a given memory
can be built.  The data structure also embeds a field for the type of
the report.  The report producer can specify what data attribute type
the report is providing, using the field.

The system exposes an API function, damon_submit_report(), for
submitting the report of the data type to DAMON.  The submit function
can be called from any context including NMI context.

DAMON Probe for Reports
=======================

Extend the DAMON probe filter to connect the report system with the
existing monitoring part of DAMON.  Introduce a new DAMON probe filter
type, report.  When the type is "report", it receives the report type
argument.  Filters of the type match to a given memory if a report of
the given type for the memory is made in the last sampling interval.
Update DAMON sysfs ABI for probe filters setup to support the new filter
type and the new argument for the report type.

User Report Support
===================

Let users report their findings.  Introduce a report type for the users
provided report.  Extend DAMON sysfs ABI to let users manually configure
and submit such reports one by one.  Users can specify for what memory
the report is made, with an arbitrary address range.

Using the new support, users can control DAMON using their own
information.  They can control DAMON using their information as only a
source, or an additional source to existing ones.  For example, they can
let DAMON do page table accessed-bit based access monitoring.  In
addition to that, if they know some hot data that might not be found by
the page table information, they can let DAMON know the hot data using
the report system.

Ongoing and Future Works
========================

This is a part of the "beyond page table accessed-bit DAMON extension"
project [1] milestone 2.  This patch series provides the initial and
essential part of the data attribute report system.

I will implement a cpu cycle sampling based extension based on the
report system that is implemented by this series.  It is for providing
accessor and type-aware access monitoring.  Using it, users will be able
to monitor access for given CPUs, tasks and types (read and/or write) of
accesses.

While doing that, the report system will also be advanced in a way that
can be used for reports that are not manually produced by the user but
by the kernel or hardware itself.  That will be the completion of the
second milestone of the parent project.  After that, people will be able
to build more extensions including AMD IBS-like hardware based
monitoring, using the advanced report system.

Patches Sequence
================

Introduce the data attribute report system with the first eleven patches
(patches 1-11).  Define the data structure for each report and expose
via DAMON core API, via patch 1.  Implement an internal data structure
for saving the reports, struct damon_report, via patch 2.  Introduce
another DAMON core API function for submitting each report,
damon_submit_report(), via patch 3.  Implement reports/producers/
sysfs directory next to the kdamonds/ directory, for controlling report
producers, via patches 4-8.  Update the design, the usage and the ABI
documents for the report system, with patches 9-11.

Extend the DAMON probe filter for the reports, with the following eight
patches (patches 12-19).  Introduce a new filter type, REPORT_MADE,
which matches if a report for the probing memory is made in last
sampling interval, via patch 12.  Implement and expose a DAMON core API
function, damon_report_exist(), that returns if a report of given
condition exist in the report queue, via patch 13.  Add support of the
new filter type in paddr operation set, via patch 14.  Implement sysfs
files for setting the new type of filter, via patches 15 and 16.  Update
the design, the usage and the ABI documents for the new filter type and
its user interface, via patches 17-19.

Finally, implement user report support with the subsequent eight patches
(patches 20-27).  Introduce a new report type DAMON core API,
USER_REPORT, via patch 20.  Add a user keyword for the new report type
to sysfs files, via patch 21.  Implement sysfs files for manually
generating and submitting user reports, via patches 22 and 23.  Add a
simple selftest for new sysfs files, via patch 24.  Update the design,
the usage and the ABI documents for the new report type and its user
interface, via patches 25-27.

References
==========

[1] Beyond page table accessed bits DAMON extension roadmap:
    https://lore.kernel.org/20260525225208.1179-1-sj@kernel.org/

Tests
=====

Confirmed the user report is working like below.

Submit report for [5 GiB, 6 GiB) address range for every 5 milliseconds.

    # cd /sys/kernel/mm/damon/admin/reports/producers/
    # echo 1 > nr_producers
    # echo $((5*1024*1024)) > 0/addr_start
    # echo $((6*1024*1024)) > 0/addr_end
    # echo on > 0/producer_state
    # while true; do echo submit > producer_state ; sleep 0.005; done

On another terminal session, start DAMON in the attribute only
monitoring mode, with user_report report_made probe filter type, using
DAMON user-space tool, damo [1].

    $ sudo ./damo start --probe \
            --probe_filter allow report_made user_report \
            --probe_weight 1

Show the user report for the [5 GiB, 6 GiB) address range is detected:

    $ sudo ./damo report attrs --sort_regions_by address
    heatmap:
    00000000000000000000000000000000000000000000000000069999999995111111100000000000
    # min/max temperatures: -790,000,000, 80,001,900, column size: 99.800
    MiB
    probe allow report_made user_report (weight: 1)
    intervals: sample 5 ms aggr 100 ms (max probe hits 20)
    #   size         address       age           probe_hits
    0   4.678 GiB    4.000 KiB     7.900 s       0
    1   329.582 MiB  4.678 GiB     7.400 s       0
    2   1024.000 MiB  5.000 GiB     800 ms        19
    3   792.809 MiB  6.000 GiB     6.900 s       0
    4   1.023 GiB    6.774 GiB     7.900 s       0
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

the region of index 2 is the region for the [5 GiB, 6 GiB) address
range.  DAMON received the user report for nearly all sampling
intervals, and therefore shows its probe_hits as 19.

Stop user report submissions using Ctrl-C on the report submit terminal
session. Show DAMON monitoring results showing no more reports are
submitted.

    $ sudo ./damo report attrs --sort_regions_by address
    heatmap:
    00000000000000000000000000000000000000000000000366666668999999822222221000000000
    # min/max temperatures: -1,740,000,000, -740,000,000, column size:
    99.800 MiB
    probe allow report_made user_report (weight: 1)
    intervals: sample 5 ms aggr 100 ms (max probe hits 20)
    #   size         address       age           probe_hits
    0   1.551 GiB    4.000 KiB     17.400 s      0
    1   1.536 GiB    1.551 GiB     17.300 s      0
    2   788.715 MiB  3.087 GiB     17.200 s      0
    3   797.793 MiB  3.857 GiB     16.800 s      0
    4   764.137 MiB  4.636 GiB     10.300 s      0
    5   768.867 MiB  5.382 GiB     7.400 s       0
    6   774.043 MiB  6.133 GiB     14.500 s      0
    7   797.250 MiB  6.889 GiB     17 s          0
    8   132.488 MiB  7.667 GiB     17.400 s      0
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

No more probe_hits for [5 GiB, 6 GiB) address range is shown, since the
user report is stopped..

[1] https://github.com/damonitor/damo

Changes from v1
- v1: https://lore.kernel.org/20261121210013.130397-1-sj@kernel.org
- Convert probing address from phys_addr_t to unsigned long, using
  addr_unit.
- Collect R-b: from Aveline and Lian.
- Rebase to the latest mm-new.
Changes from RFC v2
- RFC v2: https://lore.kernel.org/20261118022225.100659-1-sj@kernel.org
- Add test results to the cover letter.
- Rebase to the latest mm-new.
- Drop RFC tag.
Changes from RFC
- RFC: https://lore.kernel.org/20261115202849.99134-1-sj@kernel.org
- Add parent project roadmap link in the cover letter.
- Fixup kernel-doc comments.
- Mark damon_report_queue as static.
- Destroy damon_region_cache for queue setup failure.
- Fix out-of-bound writing in damon_submit_report().
- Setup damon_filter->report_type in damon_commit_filters() path, too.
- Fix wrong index referencing in damon_report_exist().
- Rebase to the latest mm-new.
Changes from RFC v0
- RFC v0: https://lore.kernel.org/20261017195747.89961-1-sj@kernel.org
- Implement the code.
- Update the documentation to be less like Cover letter.
- Rebase to the latest mm-new.

SJ Park (27):
  mm/damon/api: introduce struct damon_report
  mm/damon/core: implement data attribute report queue
  mm/damon/core: introduce damon_submit_report()
  mm/damon/sysfs: add admin/reports/ directory
  mm/damon/sysfs: add reports/producers/ directory
  mm/damon/sysfs: add producers/nr_producers file
  mm/damon/sysfs: implement report producer directory
  mm/damon/sysfs: implement report producer type and state files
  Docs/mm/damon/design: update for report system
  Docs/admin-guide/mm/damon/usage: update for report producer sysfs
  Docs/ABI/damon: update for report producer sysfs files
  mm/damon/core: introduce DAMON_FILTER_TYPE_REPORT_MADE
  mm/damon/core: introduce damon_report_exist()
  mm/damon/paddr: support REPORT_MADE type probe filter
  mm/damon/sysfs: add filter_report_type file under probe filter
    directory
  mm/damon/sysfs: support REPORT_MADE type probe filter setup
  Docs/mm/damon/design: update for report_made probe filter type
  Docs/admin-guide/mm/damon/usage: update for REPORT_MADE probe filter
  Docs/ABI/damon: update for REPORT_MADE probe filter
  mm/damon/api: introduce user_report report type
  mm/damon/sysfs: add user_report support for report type input
  mm/damon/sysfs: implement report producer addr_{start,end} files
  mm/damon/sysfs: implement submit command for report producer
  selftests/damon/sysfs.sh: add basic tests for admin/reports/
  Docs/mm/damon/design: update for user report support
  Docs/admin-guide/mm/damon/usage: update for user_report report support
  Docs/ABI/damon: update for user_report report support

 .../ABI/testing/sysfs-kernel-mm-damon         |  43 ++
 Documentation/admin-guide/mm/damon/usage.rst  |  50 ++-
 Documentation/mm/damon/design.rst             |  45 ++
 include/linux/damon.h                         |  33 ++
 mm/damon/core.c                               | 113 ++++-
 mm/damon/paddr.c                              |  17 +-
 mm/damon/sysfs.c                              | 420 +++++++++++++++++-
 tools/testing/selftests/damon/sysfs.sh        |  52 +++
 8 files changed, 763 insertions(+), 10 deletions(-)


base-commit: 8a564d37d55547b5884c310776de062e6add5ef3
-- 
2.47.3

