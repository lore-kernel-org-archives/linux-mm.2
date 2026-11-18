Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B0E606B54E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K6UXXAEu
Received: by kanga.kvack.org (Postfix)
	id EE0756B05B5; Tue, 17 Nov 2026 21:22:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E910E6B05BC; Tue, 17 Nov 2026 21:22:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCD066B05BD; Tue, 17 Nov 2026 21:22:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B370F6B05B5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B3281A0628
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:35 +0000 (UTC)
X-FDA: 85446641070.07.62D32EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 90AD21A000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K6UXXAEu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=X43bfUVIU4U5IfEMt1euy8/oc1PvYkfwsviremK5otk=;
	b=A9zOVuTrFTPjgkUixyh0AFx8QihmhwmJWmzWbeUg/+bdql44XMjYKIAH64/UZCCPcA3xXh
	sd3A6ZhUh75uVycXM2RGZohT/i6V9ETnJ6h59rd68TMh6OKykYrgv9L7Xqx4MjbxVu1dZc
	QkklUcfRfmFYviXMMELeMLyQTvLKLkQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K6UXXAEu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968553;
	b=Uve+bK5QYjSH2Vy4Vcyqj0IwTyVosQRC8jyiJ/JyrCpn1uYs2JJ4xuLDlYAz0fre4XEHWj
	W1DWEq/84adj/ArBtEaloHRkO36H8J8ve/B3sljONKZTZDbDPfnGHfTVmgumMvFGQ6nYao
	0XQx+MPHpCAM5x+exBXgGcCS/RW3r8w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D923C42AB8;
	Wed, 18 Nov 2026 02:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A691F000C4;
	Wed, 18 Nov 2026 02:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968552;
	bh=X43bfUVIU4U5IfEMt1euy8/oc1PvYkfwsviremK5otk=;
	h=From:To:Cc:Subject:Date;
	b=K6UXXAEurIkaYo7fXKkZiIRsL84E1zN7XIH1cz8BSiDgttabAhkkLkElutARAKRGI
	 CGhDkyI72c8dPaWFat4d8yErSwLI40sRfMR8brKq2AHstOu+1V92FijRF+Qvt1tifN
	 hy20EEg759LKfWXqlap5tGLr+Qg+fshjCkNa9Rp46BVm6rvNS8PaOGkH8wUWf7XI6e
	 9LIgwJ2SRy1KutoAduyBNZvBceiOsID0IZ4fpDJczzm9JbtUVY//ar7em3wVOuqN+R
	 dTQ00Zh1PyScsTAgT5KU5Crh8eH5WbnjDn4R/R1nPodYc/vl3y+okQGhEARSzVH2QK
	 A4xW3c9sDfnqA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 00/27] mm/damon: let users report their data attribute findings
Date: Tue, 17 Nov 2026 18:21:55 -0800
Message-ID: <20261118022225.100659-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 90AD21A000A
X-Stat-Signature: nda3o79bf6xgkx3rfwjrz1drm681m48m
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794968553-109922
X-HE-Meta: U2FsdGVkX1/DJDHHOARzBBWcwSL5qHey21yZDOqfp6jiAV9FVQMmX5qvSV3Ag9mDEFzfKj4G4C392wA71Dg+AmxlozGJSJjOBJ+0MCPsjdfQ76nVMatHBVsgTuYf8RW9+UjkPzUGf9hEeRep5uGshNUreUAp0Ob5K9P3jzMpyndQr1Lca0HMZc3ks5NOl3Cjtz5jBaT8WmsM1PlrpFe60nEYrDq9OkvYTLC5+IrgY1j4BTC0Wu8uuuQnPN3YTohPJfXSnhGaA3G1U8rDEND/HzOS1Qmt2CsD004xyN7Fg5mBEYae/RGsBgImsBWOrDXItiFaUia9eQlaMpn4GhQ2ql8UPobIaSe0cRY/jZ4YkwPFYY2+BgAgc3kZqm4Q6znJAcjlOkhSAvrni+gNkNVcgY4YPvIX+r4k/jmdittW8pzeqBosaUj0LycwR8j9XsOC/bBqVR7lW16SNG/cq7d3FJHn8T93Ab4ddsy7KZAP0i5Ac59q246BLHa64yjpxw7MJDH+Q5ol1KkK3j9EoSY4MdJF43PE81cKRjIaWCLsOjAGRRHPxa1Qhg9pYnOht4znxGfrYALsik3kuMK4P4xNXPXCh4YBi52H6230sts/HlF0PwHJ3MQ9/l0baFVJY37SjiDMS7RQGIqR5A0d+tdUSXTmyHIkBEbk7HFIdWlDro2akgeWz8IM421ArTRn8+5jL8EELiRk8/yerW5OPa0cdK5M0gTmDPDVzVeTnJPFtsg1YDHnURKo4N+ECukYtGZqwSr0/5YlxFC0JGvyXvXBY9tE1Y4Kqn6DlCEEWSa25rlsmlI1+IWedTpsG6AmceAYmv+n16O/rttTntOWz5kfvNmpDDDctBeJn/ivB97a1+HrqxGcmL5Xlx4ru9dCqqw8QPcLwPwa+DRaP7c9/1eSQ1HhmTdYSobmlkbKXLuYToVIxxaCKmvrTFCxol9KDwIhNdtu6/vXYKy/ejm7wH9
 vzaAGs21
 KbkEcZjMmG6F/P45N0CQR5aMGRKdpLz0sNu+P8z7BR9KRnVYAjWKwpfy8tBYA37t9UMwdaWVA4VOU38E5Fq/o4nsBKzgMb9tk7TVFqfPl6zhUeLzYtdf/TUmMNhlNWUxb3BsxfvJN1lIc7AJ0Qap+lZV11sI75lSJbxvgkB6IqYTuqoxgXEHQlADPDdkzJVVp6z6HSoLJjAZGgmdXEK2+kEC+LrPBJurh4DPlmjowZ+SHnXM=
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


base-commit: 595ae33ab080415771ec5707280ac89f40eeb75d
-- 
2.47.3

