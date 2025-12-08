Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D064CD3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFD0D6B0005; Mon,  8 Dec 2025 01:29:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD5C6B0007; Mon,  8 Dec 2025 01:29:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3B86B0008; Mon,  8 Dec 2025 01:29:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A75036B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:29:52 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F4EC160991
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:29:52 +0000 (UTC)
X-FDA: 84195328224.06.E867732
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 88CB8A000C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:29:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DdtWabQw;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175390; a=rsa-sha256;
	cv=none;
	b=41EOTtheNbxMGadhyZk95Y6qrwYdiQK3KJ6Dl08RD0X7H7VYc2DttLNsKR+jH/u6BKVEVU
	m60flxY2B1w66jJE1vKuOFZA/u7dnzn50xqvFFQWPKXLLZZkflQqjEXbzEjsCkZ5K0X4Ht
	f1Ha3z+8Wmtz3q+ahukK+m4EUKwvzDI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DdtWabQw;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=umfLUMglG6QfLnXEyia99eJU0+MbCYUCDMFQ7t+pdaY=;
	b=wi96V40dewNnue+r2adDxmWWuven0M5VTfWysQIRCG7cebct5xfXYqKkBVqom8eOcjDOaT
	8JhHpMBPI8sYHaVFEpo0NJ7exSEFNhiCPLan3lhCM7z31hIOuubxkCaVjmkhrvIZ28zRZu
	PgcmBeUn78rr2JBXsqUH1h6NmhBwWb0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 52C4442B7D;
	Mon,  8 Dec 2025 06:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCC6C4CEF1;
	Mon,  8 Dec 2025 06:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175389;
	bh=dU4XKsfKL+dM6+fZPeiCZeJLrbMck0nxcTaR4fYtTDI=;
	h=From:To:Cc:Subject:Date:From;
	b=DdtWabQwN7P16NrGnLi45ZmOOg/MYWM37RJNWQPy0obnEQ92Qx2CdY2aO7XIL8XMl
	 MGWSCwJKVIz51DY7h9AfMguUNcQo00ACeqjcixrQfc+LHHX4fxVO6+8/sVRHPzHEKC
	 NqGRd9kpPslYyl1Rft8cwLWuHd2+Wta479/xANLdawIBIPph7hxMrqFloZwUo8XKIJ
	 bkIQi+pfXakBYG+4jhA0kISI+WUFJlZeMiuwdBMh72oKdkn/vf/wvbTpYLtekzv2Mj
	 syTt8SP8FX7B3lYyg6hi3fq8nXeqJNimFfXLBfgYl1W7dFkXRVyJLdb8Ke0mbWeU6J
	 5bT1t/110L+VQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 00/37] mm/damon: introduce per-CPUs/threads/write/read monitoring
Date: Sun,  7 Dec 2025 22:29:04 -0800
Message-ID: <20251208062943.68824-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 88CB8A000C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: c7fhaxrmwscytgowjs645c45pxmunehe
X-HE-Tag: 1765175390-59634
X-HE-Meta: U2FsdGVkX1+thl6v598/08M3cG5qGbKMcC39tYUv/XuBiI5QzbUVephAgyAsYgLmBFuXBf6+XCfsRTrTJAI32PfxmalAL/AG0QgU/FH0vR8uYF38c86VwAMfvTvrLjUaQ1cEqW5w5nOoSjrmg7w7hJMfO+/BCdYkN3PepDFmzxDjBiVlxinQNlsgAq9TZkaWDEZlVPrCgbWYGu8QjektawphpBS3Ps4JZmQyzChyAnTtdD5CoKwMWiIjweRoBgwMP54AaPaZn44rzg0Fv5pqfVZX9zFKtlIZInovdS1hcS/Ow0XJg4P+VXxaamqHcAnFWTNIl1QDoId5pQtnRaV0+dvKaPxgtoJYs680iPz1L2pIUde7TezQSVInKgnIkrNhuPfCfecjGC1247sdmGuwmFTVaQACjxn7gSBwrXCWbHelyfnZUmdx+Q03aFLaPRtLQ5yyWERmz+qIJsYWcuHkjZ9s0hzYkO2IkEo3yBea2I49tQsybiq8lcdwCh7V9ib2XnskBJiUKjXkGN/2LzmtMP/lMA43L5QRaWuav8lI/tDfzjjccQT1KrcPuSg/S7l7cgOsM32U/hvQF1NoahrIz4D4WYJRznvkKp/yZ2ZKMUw0TMk8mDXCDjrYB3lLUb0VLlC4RdVNy5/SALsCh01yj7xQKOz3QIMpFMfgeNEVVPT+7lc6LNg+upinvZLyAOaQg8cGrYVzxWA4pwHs5EVybdMXuLXRARyPN733VZf9Mb9KlVXAjk6BhlUYQdTi+zQqePcn3meEd6Mmo+yAD/Eu+PP4XzKFZj1sXCI+gYX7FzL5vzOqKXQF0GN8BCh3IGl+9WSRLj0YF3yMOCsE+/sMrzTfssyDEbL1rbA9nzDO5OsMKf/RtZOxbNbQ5N3Pty4r9hJoypSO2L1z+ilcteCweEmXIpvgXzRErOAflecW396gV37V5pydcCudZI7y59CgGm1Z4sGujG9nwUufqQx
 LM2WFfGe
 u2wa1W8jpt7Qr2dgwv63OtLvsiD4wnk3dC9pFLjopeG611TAG+va1S+6a3yjmnfKThagtLQWaWk08YekZYxZkicYxbQadsBv8+CmP/lVWgXIEYlwf/fD5K3vQXrjaXG/Yiim2A8vmaLfJpRfg1nOe8cZQYgolO8o2jeSHJsvx8QeanpHoDkJFvne2Do+fmNkIMJq+UdY5xm4E7DkocTiZqAGIKiQfU2d88AEB5HwVZZ2JlCVupFh7n2a+8Msf65cx0kEfwRmxXv2CxOuZe/PmwOEnJpLZPq4jmsgODm9hQC2YsO8dqWb9ExvYbeDs6v5SNhdeHgAlB5r/iCD6Wy6oZgsemF1VYgJQEepRUM+tEtqBBa0f8yZya4i4dVK4ob1trPp6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON for monitoring accesses generated by given CPUs/threads
and/or for writes.  It is aimed to be used for general NUMA-aware page
migration, cache-aware scheduling and live migration target VM decision.
This lengthy patch series does that in three parts.

The first part extends DAMON API to let any kernel component report
their observed access events to DAMON.

The second part adds a hacky change to change_protection() and page
fault handler for reporting page faults on DAMON-specified sampling
pages to DAMON, using the report API that is implemented by the first
part.  Please read the "Hacks on NUMA Hinting Fault" section below for
my apology and clarification about why I'm doing this.

The third part extends DAMON on the page fault based sampling to allow
doing the monitoring for accesses generated by specific CPUs and/or
threads, or for writes.

Note that this RFC, especially the hack of page fault handler is not
aiming to be upstreamed as-is.  This RFC is shared rather for giving an
example of ideas that will be discussed in a session [0] of the special
purpose memory microconf at LPC'25, and a stable interface for early
testers.

Background
----------

Existing DAMON operations set implementations, namely paddr, vaddr, and
fvaddr, use Accessed bits of page tables as the main source of the
access information.  Accessed bits have some restrictions.  For example,
it cannot tell which CPU, GPU or thread made the access, whether the
access was read or write, and which part of the mapped entity was really
accessed.

Depending on the use case, the limitations can be problematic.  Because
the issue stems from the nature of the page table Accessed bit, utilizing
access information from different sources can mitigate the issue.  Page
faults, memory access instructions sampling interrupts, system calls, or
any information from other kernel space friends such as subsystems or
device drivers of CXL or GPUs could be examples of the different
sources.

DAMON separates its core and operation set layer for easy extensions.
The core layer handles high level work such as access information
sampling target setup and region-based overhead/accuracy control.  The
operation set layer executes the low level (sampling-purpose) access
information handling.  And DAMON API callers can implement and use their
operation set.  That is one of the ways to extend DAMON to use the
different sources.  The core layer features will still be available with
the new sources, without additional changes.

Nevertheless, the current interface between the core and the operation
set layers is optimized for the Accessed bits case.  Specifically, the
interface asks the operation set if a given part of memory has been
accessed or not in a given time period (last sampling interval).  It is
easy for the Accessed bit use case, since the information is stored in
page tables.  Operation set can simply read the current value of the
Accessed bit.

For some sources other than Accessed bits, such as page faults or
instruction sampling interrupts, the operation set may need to collect
and keep the access information in its internal memory until the core
layer asks the access information.  Only after answering the question,
the information could be dropped.

Implementing such operation set internal memory management would be not
very trivial.  Also it could end up multiple similar operation set
implementations having their own internal memory management code that is
unnecessarily duplicated.

Core Layer Changes for Reporting-based Monitoring
-------------------------------------------------

Optimize such possible duplicated efforts, by updating DAMON core layer
to support real time access reporting.  The updated interface allows
operations set implementations to report their information to the core
layer, on their preferred schedule.  DAMON core layer will handle the
reports by managing meta data and updating the final monitoring results
(DAMON regions) accordingly.

For flexible control of the reports from different access check
primitives (or, sources), add a new data structure to DAMON core API,
namely damon_sample_control.  The data structure can be used to
selectively using the low level access check primitives (e.g., page
table accessed bit and page fault events), and filtering generated
samples based on additional information on the samples, including
access-generator CPU and/or thread, and whether the access was for write
or read.

Hacks on NUMA Hinting Faults
----------------------------

Hack NUMA hinting faults code in change_protection() and page fault
handler, to make the first DAMON access reporter.  Update
change_protection() to install the NUMA hinting faults-purpose
protection on arbitrary pages, and do the protection install for
DAMON-desired access check sample pages.  Update NUMA hinting faults
handling code to report the information to DAMON, when NUMA balancing is
turned off.

This is never upstreamable design and implementation.  Actually concerns
about this were raised in the previous version of this series.
Unfortunately I had no time to address those.  As a result, this version
is not addressing any of the concerns.  Please forgive me for polluting
your inbox with this immature patch.  But please know that I'm not
ignoring the previous concerns.  I'm sharing it as-is though, to get
feedback on DAMON-side changes first.  I will establish discussions with
all stakeholders including NUMA balancing and MM core maintainers, after
the DAMON-side changes discussion is more progressed.

Per-CPUs/threads/write/read Monitoring
--------------------------------------

Extend the data structure for access check samples filtering,
damon_sample_control, for filtering reported data access sample results
based on the source CPUs/threads of the access, and whether the access
was for write.  Expose the damon_sample_control to DAMON sysfs
interface, so that DAMON ABI users can also utilize the features.

Expected Users: NUMA Page Migrations, VM Live Migration and Scheduling
----------------------------------------------------------------------

We have ongoing public/private discussions of expected use cases of this
patch series.  We expect the per-CPUs monitoring can be useful for
NUMA-aware page migrations.  AWS has shown their interest in using
write-only monitoring for finding the best live migration target VM.
Some folks showed interest in per-threads monitoring for L3 cache
utilization-aware threads scheduling.

Also I believe this can be extended for not only per-CPU but any access
entities including GPU-like accelerators, who expose their memory as
NUMA nodes in some setups.  With that, I think we could make a holistic
and efficient access-aware NUMA pages migration system.

Patches Sequence
----------------

The first twelve patches (patches 1-12) are for the first (extending
DAMON for reporting-based access monitoring) and second (adding the
gross hack for stealing NUMA_HINT_FUALT on page fault handling) parts.
As a result, it makes DAMON be able to do page fault events based
monitoring.

The following thirteen patches (patches 13-25) are for implementing
per-CPUs access monitoring.  It implements the framework for doing
access reports filtering based on additional information such as
access-origin CPU, and implements it for the CPU information.

The next seven patches (patches 26-32) are for implementing per-threads
access monitoring.  It extends the access reports filtering for the
threads based information.

Final five patches (patches 33-37) are for implementing read/write-only
monitoring.  It again extends the access reports filtering for the
purpose.

Plan for Dropping RFC
---------------------

This RFC is having pretty immature and dirty hacks.  This is never
upstreamable as-is.  I'm sharing this, though, for the following
reasons.

Firstly, to discuss the overall idea and DAMON-side design.  The idea
was floating around for a long time, and recently has been more specific
with 'damon_report_access() API plan [1] that discussed at LSFMMBPF'25.
We will also discuss this focusing on NUMA-aware page migration use
case, on special purpose memory management microconf at LPC'25.

Secondly, some people started testing the early version of the
implementation on my damon/next tree.  The implementation is hacky,
having only an experimental interface with no documentation at all.
This RFC is for giving a more stable interface and documentation to such
early testers.

I expect final upstreaming of this series will take a long time.  The
NUMA hinting fault part hack is the most challenging in my opinion.  And
this version is not addressing any concern about it that was raised to
the previous version.  Please know that I'm not ignoring the concerns,
but only having capacity limitations at the moment.  I will establish
discussions with all stakeholders including maintainers of NUMA
balancing and MM core, by LSFMMBPF'26.  Only after we make a good
alignment with all stakeholders, will this be able to be upstreamed.

Revision History
----------------

Changes from RFC v2
(https://lore.kernel.org/20250727201813.53858-1-sj@kernel.org)
- Use damon_sample_control instead of new ops (paddr_fault)
- Implement per-CPUs,threads, write-only monitoring.

Changes from RFC v1
(https://lore.kernel.org/20250629201443.52569-1-sj@kernel.org)
- Fixup report reading logic for access absence accounting.
- Implement page faults based operations set (paddr_fault).

[0] https://lpc.events/event/19/contributions/2066/
[1] https://lwn.net/Articles/1016525/

SeongJae Park (37):
  mm/damon/core: implement damon_report_access()
  mm/damon: define struct damon_sample_control
  mm/damon/core: commit damon_sample_control
  mm/damon/core: implement damon_report_page_fault()
  mm/{mprotect,memory}: (no upstream-aimed hack) implement MM_CP_DAMON
  mm/damon/paddr: support page fault access check primitive
  mm/damon/core: apply access reports to high level snapshot
  mm/damon/sysfs: implement monitoring_attrs/sample/ dir
  mm/damon/sysfs: implement sample/primitives/ dir
  mm/damon/sysfs: connect primitives directory with core
  Docs/mm/damon/design: document page fault sampling primitive
  Docs/admin-guide/mm/damon/usage: document sample primitives dir
  mm/damon: extend damon_access_report for origin CPU reporting
  mm/damon/core: report access origin cpu of page faults
  mm/damon: implement sample filter data structure for cpus-only
    monitoring
  mm/damon/core: implement damon_sample_filter manipulations
  mm/damon/core: commit damon_sample_filters
  mm/damon/core: apply sample filter to access reports
  mm/damon/sysfs: implement sample/filters/ directory
  mm/damon/sysfs: implement sample filter directory
  mm/damon/sysfs: implement type, matching, allow files under sample
    filter dir
  mm/damon/sysfs: implement cpumask file under sample filter dir
  mm/damon/sysfs: connect sample filters with core layer
  Docs/mm/damon/design: document sample filters
  Docs/admin-guide/mm/damon/usage: document sample filters dir
  mm/damon: extend damon_access_report for access-origin thread info
  mm/damon/core: report access-generated thread id of the fault event
  mm/damon: extend damon_sample_filter for threads
  mm/damon/core: support threads type sample filter
  mm/damon/sysfs: support thread based access sample filtering
  Docs/mm/damon/design: document threads type sample filter
  Docs/admin-guide/mm/damon/usage: document tids_arr file
  mm/damon: support reporting write access
  mm/damon/core: report whether the page fault was for writing
  mm/damon/core: support write access sample filter
  mm/damon/sysfs: support write-type access sample filter
  Docs/mm/damon/design: document write access sample filter type

 Documentation/admin-guide/mm/damon/usage.rst |  43 +-
 Documentation/mm/damon/design.rst            |  76 +++
 include/linux/damon.h                        | 133 ++++
 include/linux/mm.h                           |   1 +
 mm/damon/core.c                              | 339 +++++++++-
 mm/damon/paddr.c                             |  66 +-
 mm/damon/sysfs.c                             | 622 +++++++++++++++++++
 mm/memory.c                                  |  60 +-
 mm/mprotect.c                                |   5 +
 9 files changed, 1338 insertions(+), 7 deletions(-)


base-commit: 120d322d058f56f6cb92115b5a589ee9b4f07664
-- 
2.47.3

