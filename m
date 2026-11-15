Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EA3C606CC91
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fJiovDip
Received: by kanga.kvack.org (Postfix)
	id 095AA6B05B7; Sun, 15 Nov 2026 15:29:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06D476B05B8; Sun, 15 Nov 2026 15:29:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC5A76B05B9; Sun, 15 Nov 2026 15:29:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AEC686B05B7
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:05 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 249E8A07E8
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:05 +0000 (UTC)
X-FDA: 85438492650.22.B51C796
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 944F8100003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fJiovDip;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1gHoVlsoZdSXGaMomZB6hMkldBZ1l8ztHQoR+4c+loA=;
	b=4uawZMBUg8dpc4YJWrXwUHY8LGGcRn56x97CL4/fPGYgr9dSnCkR3khoeOqbxhddHs0F1M
	Mx9kTLOmaVrnbXf0XSLZUrAnRPCS/GDzIr+W0SQ3Ia4UU2poRvrU90yJwupHOkPMhVk0t8
	xcBsOLMZgN2zvMdCQ7FHv7sYMb6U/Zg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774543;
	b=tuqwy2oeqvkTilELvsUkgg6wCf3o1tnLL716Na3vFEBDy+eBbJd957j7YUHOvOfUVp6r9p
	IV1CYPpo1Keegp1MrwCDxbCaPlDL8rB090RlV99ErPU59NF3XtkeZdeb5Yn1XM2gAYL5ht
	ACaMeIUsksLAJgoBbO7bh0XFdqyx30o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fJiovDip;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE133601BE;
	Sun, 15 Nov 2026 20:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347FA1F000C4;
	Sun, 15 Nov 2026 20:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774542;
	bh=1gHoVlsoZdSXGaMomZB6hMkldBZ1l8ztHQoR+4c+loA=;
	h=From:To:Cc:Subject:Date;
	b=fJiovDipWYNedPsKgo37GsCLMdA8yhWJvyseESNgVzY6uglIn8o4fmoF20HYRLDEk
	 vEZinOpgBTEV7oU4cN0dHbM70w4r46hvK4/wKrKOQwwvGXtUOr9wrFcSitS14oKViL
	 UjTgjSkIEtCjQ+V5QmyqfQUuyeu6rIrJqPgcUpudoFDC+fCW9sMHouqONhNMNgCqwH
	 1W6ENqCmp7059kZ6pJ9qyM8as7W+FD2HXzt/4VEoOGMb0wNCWuTYZuJFgF/js/kowE
	 hnqXFyE6WjTzMBXj+zyuEJYyN3rhR7ePTtZuUbZ5758OcABrPjAYEOPKIHzdgAHE/x
	 b4y+nKI3j72yg==
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
Subject: [RFC PATCH 00/27] mm/damon: let users report their data attribute findings
Date: Sun, 15 Nov 2026 12:28:18 -0800
Message-ID: <20261115202849.99134-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 944F8100003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: prc5615tbnhqzzgxhs6j115398nae63z
X-Rspam-User: 
X-HE-Tag: 1794774543-504801
X-HE-Meta: U2FsdGVkX1+Woo34uKd1jcQdUb8RvpMPHc7GMXZ7nOvtff+vQDivDNhzKWjp+c2tvKA7bGWpfMsMQgyWIQPAoKrHnk1H3b+RVsoEilwm/TPXay+PeZsdb7IuAYZy5uV0q4WBCjxYNZAL2nZdL0Lsv9SP+g2UFc3IbDrSSMFAJQ3sSn/RnIYqw9UxXfKrp7CnDxwUsaEcBl20g1V0HQrVjfLo8vVoyMcr6DmrSeBsKHr/tikjLRe6o5+gODLtbRRajHLN7bSNdzNx8jrkPJQw/dufwSD3gdN2r/cnxfWZHv6pk72zd51GgZQOtN5djhb5+HqzC4bFdfNTqzg/mTrMesxGCSMCBBMmb27fdPIPi5yvcLdu1qp7ZDr/1XuTKnKsn53t2utpD/QG0dMU1Yw9kYLZLIKmtD/OTARrrKwQPEFUg5GfyCyMxJpd9mwHOoOnH7vfq0bOisT7FmkHMvoXnxrXVQiS0o4t7GZ4/9VbF/b37tK85MxxD6RrOHbcxCsmKtx5uAxzaCc+P1VufkLojhyIayj6kWy709Z4B5BK/MpnICXmUPTw1uwct8pCqPaNwqns1gVfkY94yrTXsMC2/E+NTT4A77yyQu6d0nwZitl7Coqs72RKKh9/VYiOvlvoFNVArrPLklT0C1YWISwqSWgj/4BahFseETvlfqkvL6QzfZvVC/ZjHEhiodvOnZ11yT6Tftafp9FpEKOUZLRMo6bD3huHIg9M5qdRC/mL4R2YIgaQZOmuIZhm4kco6Njf9hLsNKuDBQx7FOSkhnhXB0kjjgpAbMTGCfHNofr31lLtoJptxzH+uw2XfV2ul9ZbekeB57OSMh+mo1CzKK6cBac/K0PO/L3Xs0MUTRWaVDjj9aREa0mIrJd05jWDT0EcakXHnFJwM4Y908FrXF+CUGh421TzE5Vz6kMsIUfVwVLcC7ehyrMiw02crgV3Duj0Q7l/6P56dw1o3bVbJZy
 jOFNyqz6
 FQRQWsGGtYQMUFsY4KvgEDzz7KDl9ZpLvTaQd9zbcNQsOJqzBGUZKGf1oz5qMo0Y+cwgIeYNpVyamU86JFOPJCQtX7maIBqUZqFkKor8ZzVl8DwhPQa/tdLLHrhQjcGwpFBBQ2kG93hqxqVq2zq4RT+XcVCEkSmDX/03ta5NZtLBMtABuRWmg4zCv+xBQFcGxuYXZF9l9Cw52BnwO44bY0rs+xLggw/JigTJLaI1hCrlBmFQ=
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
project milestone 2.  This patch series provides the initial and
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
 mm/damon/core.c                               | 108 ++++-
 mm/damon/paddr.c                              |  17 +-
 mm/damon/sysfs.c                              | 420 +++++++++++++++++-
 tools/testing/selftests/damon/sysfs.sh        |  52 +++
 8 files changed, 758 insertions(+), 10 deletions(-)


base-commit: 3c8cd5232610d6035977619fbcdb7fe5aeda35ae
-- 
2.47.3

