Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E861606A334
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RV8Imet5
Received: by kanga.kvack.org (Postfix)
	id B7AA86B05B2; Sat, 21 Nov 2026 16:00:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B47EC6B05B5; Sat, 21 Nov 2026 16:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E9A46B05B3; Sat, 21 Nov 2026 16:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62F916B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:24 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D77EB405AB
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:23 +0000 (UTC)
X-FDA: 85460344326.29.5125BD7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 49158A000A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RV8Imet5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294822;
	b=llRUBRk7I41R4UpauxGWW4Lw9yS78WeqiQcGMihjGm47MMRqFsXYiryR9+0eXebWd1LOuE
	hrJPRNeX5gGRhcoTWIx1raNZLldkQARvK5WPL1QCxbQuzjsM7jfEnHwdhAYxLFRLpuKFFL
	k6n/CRjumoT1u987AkMfwvcQmBN6peY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zdUEUat7j9pUSbGlH4X0DruoE2B9UNxheDyAc9R5hyc=;
	b=U1AxIQnteXFfpDS7z3+pc40ZUM08pwlQA5RhSEwEb61k9C8M5RhFIGEQ/vazY86eC2pnq1
	E1/BN9ZDVrNcJNRr6+tnEByKfWDlIGQIefbFP5bSb5GidZy66h4nnK6QG5R68yY9O8ct5p
	Uv7ze+fy4IhUgWt78WBlxpKWXhqaZ90=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RV8Imet5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 932B261C67;
	Sat, 21 Nov 2026 21:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DA11F000D4;
	Sat, 21 Nov 2026 21:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294821;
	bh=zdUEUat7j9pUSbGlH4X0DruoE2B9UNxheDyAc9R5hyc=;
	h=From:To:Cc:Subject:Date;
	b=RV8Imet55YoYm/Q24IcP+f6IYmTruUVLB/zwnit9+4KriS7a+Tfd8/738BH9piWXo
	 6BDRXQs0/irTm2N7mgFq7RGV+N9zEK9FpB8j4jrnnsUSF28FccqaXdgu/ohKyxUbbM
	 RRAApXmjXUnhFh8pK/dNwkh5iCIN+KGr5MlwUDJjaxHiaasEHAAkO02Q7m/x36yjD0
	 UzXJGnZWYINaHU4yS24kou7GBC66l0Rvk+aoQL4Cg+SeweKE23x5Xxj49xRGQqHSVU
	 BKx1Ijg8v7Um1vOFcPI4N+B4+kldV/3mXgwnbWC9r2FxMEOJ1U5GcyFFiWUb5+3vdq
	 2JoYNLdNcEcrg==
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
Subject: [PATCH 00/27] mm/damon: let users report their data attribute findings
Date: Sat, 21 Nov 2026 12:59:44 -0800
Message-ID: <20261121210013.130397-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 49158A000A
X-Stat-Signature: y5ij7cedo5dy7whygq6eargtqcyb834s
X-HE-Tag: 1795294822-581930
X-HE-Meta: U2FsdGVkX18FyIP8C0/K+yOe6KwQ2H3Nr8ljggcGuHhYaf0nYa+Nu8Ls1AmadwDqI0FOXyUF0lvvXIueey2JTrRnqWkHRirToRP0e9rtgyqJB80G7fzbaqOia82KdjhSQi/kh3nkUWZtEW6PCApt+1peIlmMSyVA02ArkFpQ1fOXoyeQW03CpdDBwrtN+5zDNwUlH93xC7W8LkixZT0gu+FotQhUEmkPcxqcEEJ+KW01tFqkbZA48GPq6GP662iaXHyRwxZlZnJWEi2PlUUVRC5soodEo5kh7R5rVUNX5zTQEJ831dBTlp5plpi+uMCOW5ZD9O7Xwnh+59KIgt6sqkdmF3v9AONCGg3XzAHeiSBUQvadcjWTfk4m0JJdX9XGdObaIFdtSL0YT+OnNHmnyXuKpfkG61wjMJE0UxUCteUlJu0hpsqZ9MZcosm3XP0jljHGD55tXmyfry6F73VVsUGhKzjnw7MNoeR3rzh7nmH+RWsIgNSlRFdXDa7ETJLMnsi9daCH+x+DLl1hevaLl7SSSu6H4taqiieJvPNVkTiEVR/LzL8ABtxYhlZFkdFXl53w5p7Hi7pfeA5VpZwSJxBzkraabpatm5f4rNJrMRTPGZ+Je+5exNK1KyPCEiZ/e4zKnZ4GfzZZXPbV+9pG/SiOjbiDuJmrHPo9Vjwyf/yEN0WXNz/Irunk0q+LhLryFj3GonYyLeibMwnB6knDA4XAc4VYPeUk5ogIghAavP0j3UDAjyaD/Jjsypa0bMMWjbLKPI7ISfsIP1h3ukyu53DQ9oMWnCvVaaVGJIn9YEq8FydhN7pHfQPCTS+378a6zXNkKbx3P39J8Z0LR28Kqb3MBTF4emxWQHxHuCA8eZrzUneBNEGNXMY9ToOlKEpByMsUOQWxR72MGPJvQVNY1DLMgpkIIdEPeVktblvBqWC9mmJdfA1s31E+LvbehFXniNIV25cPV+ovekmQbLN
 F1aKeVCd
 AWH5S9p2TDdJOZmpRy0CIxSvrb1mtB7FTJRwlRTbDPJo3aiRgtCJpYqhsrbG8XPtubgHLl4C63yrMamL0spsLIsILa9fybwGYJO/1Q3Km7F/UbcJfWYyQShL/46RIp6QP6VY9ZPy3HSyATsCEOpp5XLmElYDEvlheyPWnsehwdusawnN4zz+WcjWyFj7xZRgKuUcgxBhmaidGCMCUbG3LGeYU5M1EGB9wZ2ykgPH7cGzbK9Zh/EEDiZIXXLb/7Zi5jYzjuG/RImjfaKRf+0jWdZ2+iZsv87OxjnVbktm5+NQE6SOAgmbfxRgeZfM9T9gBgUQzon9gGKYXHsOGEx/gGd+4j0fgJ8NUjXo4WEkuGJfLlWj2eX3YDUn0sqCrhtutSNY+V64BfNSQnG0rHj4po0HKSKuf03jeuJ2TUtshnjGf9tD1zdEtwZMuPQ8AFLIdTh8n/PcOk2u+mUGAenk1PaEOnBRbZ0ZhGjQtMVv8DHWYi+ic4YdaElz6qWdvFNRkJArqsQOzVyyFfDoNhBp94uqZKNKKPperfKJM
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


base-commit: 7493b6798c5353fded63c06768dc73ab63d65fac
-- 
2.47.3

