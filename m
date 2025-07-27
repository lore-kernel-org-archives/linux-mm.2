Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE75DC87FCE
	for <linux-mm@archiver.kernel.org>; Sun, 27 Jul 2025 20:18:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF2896B007B; Sun, 27 Jul 2025 16:18:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA32E6B0088; Sun, 27 Jul 2025 16:18:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B89E6B0089; Sun, 27 Jul 2025 16:18:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8ABB16B007B
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 16:18:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 04D7B134FDB
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 20:18:20 +0000 (UTC)
X-FDA: 83711156802.21.4A42A84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9DEDB140002
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 20:18:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cVXVjafE;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753647499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wIqUT4joDfyc5mcim/HE42PQnZXxR7R9VWQT1liVF14=;
	b=NmTqgDj2zU7By7h3fJxhTCoqXK64DuQ/EYVAXOMpuINzn2d+W4AqymrpFnSWkIRfLO3YqX
	knIBp+RuEuU7UktcfL91kAY/FrksPCr79qele2hqllEUuVShAmMTfAattOE5FBzOBxyek+
	BTamrLQVY1zxBoRJzjTFBsJbHohW7TE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753647499; a=rsa-sha256;
	cv=none;
	b=mep4OTZNURW3VdMF60fNJ3zwZxPrAbOJ0zYnG8+aTN9m4HFZwAQOtRVu2soblR/KVD+zP/
	24ta8CZgJgb5G9o9EEoqniHwChPcK8vVB5yP329dCpBoSL+Jj3RUfvs3YI9RmvI4AP+Ps8
	UQvw5ogrkGSSZTzWg5D7+telat9OTdc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cVXVjafE;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D19A2600B0;
	Sun, 27 Jul 2025 20:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16ACFC4CEEB;
	Sun, 27 Jul 2025 20:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753647498;
	bh=JZKBZYAEnD2JMnOJ6uq6sX/y3f6cA/dtZlHCa4J6zvU=;
	h=From:To:Cc:Subject:Date:From;
	b=cVXVjafEJPv6BzNl0EbQ0IqCszyCYQ84R7ltbogGB8Y/GEPyeXYPHtbRarX0U6rIR
	 z3j4sF1M+Matcp9hOxQn0Je7TkjiZVwX7RbGAQsVqP4y56jgqB6zvSNpYkjm0j5Y1/
	 WE1fWlay4b25Sr5/SY7T6r/sA8zydWGtqY1kSASgo7rGAofgp8rECrHNlvUJwd88w2
	 gyt9aSTXg8oRhv+786rMzOocQjBP7JwiubKRoBwKGaS1kdSSwu6N6CH3eN8Udtyml5
	 IkPIvTDuVt3wfL7V4GMoDrSETptqzC2SiuSej6q93dgGr79b+qHs0ZRgfge7HjcLfZ
	 untmLXiKvGIDg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Jann Horn <jannh@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC v2 0/7] mm/damon: extend for page faults reporting based access monitoring
Date: Sun, 27 Jul 2025 13:18:06 -0700
Message-Id: <20250727201813.53858-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9DEDB140002
X-Stat-Signature: f58s9harw3kho3afojq6ryme5zye851h
X-Rspam-User: 
X-HE-Tag: 1753647499-409246
X-HE-Meta: U2FsdGVkX1884ZJ1YMXolTIk48lqh8ImobzOp5ZSWAk9WTKzZBWXuplxMbSatRkeGTTrgJTn/xa4YRF2sGhUdjjK55Sw/H5ldqvlSG9K8XpdI7OlEByIVRs9I3la0EdLeN4pFQGSGO5p20tE1OWTtT1cYPCZhXoTc5Tvf56S/FaeaTDPm6ZS+mxR0aLTpot62xjkpMhGPn/Un4znZNBQpl0H0lKjRLsTyacV3a9uv20rEToa0/S5MW5emXeE7JMf6qrdTBnhUzFyffgWC7WE0bSNntLW2P+gx3D8sjebUKT8jy2YMUOBXluMIQKxaoKCt+VdFHphKU03DsWlk2C4xFzF2NEJv/Ydy9Zmo9aBFuuQDVqHj2BblZqoEFD65wvRRo8X6VQcB64AFXqkq3NHmsDpJOj0UtW/dG1wuVnqVtR78bUy66C574HtyVq4d3HrZ4o89YaA7eiX7FVjrTW2pgpXWK99yO2ny/aCyFDLIKBEJg97jLOkmWTM48xNksL1Eyizh3dDlddti04rEiOCGL+G0GrrAAyDhUKVT/b4UlUqHgbA2/20wYKSX1200m0P2ZY+slK9oVpY8XEzm3JuYwCduJBoU/99Z6XMqudMaBwMgX6tqpQG0pt623x4dnx+PzLOfdHZ5fT8H8neP/AdEnL6oUHQbMRav6iO+lNEV4/m1WXmw6EcoseI0DYlIR3+8KtNwdXBboo8Wu5pBkBFaON1guQsUfcJy3uOWG9V3P5fVx+58Rg9MkhdMxLWIMrDOeLYuSJCo2rJEp7Pbo9vYSJRZVpRyzA4sJTbooerpusdPmh5BEZMbBBLXbBTjpzjawDuS9o8t62NCeljiqXTdOXYO43tj/Fx0Xk0PJtlek7UHU5CTa0GOYOXEvRSyp4tsUDbLZTih4H+ypsLt1h0iGrWPTV0V/1bK/WU/XLUbLZ2Cm4FtvZHvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: Extend DAMON interface between core and operation sets for
operation set driven report-based monitoring such as per-CPU and
write-only access monitoring.  Further introduce an example physical
address space monitoring operation set that uses page faults as the
source of the information.

Background
----------

Existing DAMON operations set implementations, namely paddr, vaddr, and
fvaddr, use Accessed bits of page tables as the main source of the
access information.  Accessed bits has some restrictions, though.  For
example, it cannot tell which CPU or GPU made the access, whether the
access was read or write, and which part of the mapped entity was really
accessed.

Depending on the use case, the limitations can be problematic.  Because
the issue stems from the nature of page table Accessed bit, utilizing
access information from different sources can mitigate the issue.  Page
faults, memory access instructions sampling interrupts, system calls, or
any information from other kernel space friends such as subsystems or
device drivers of CXL or GPUs could be examples of the different
sources.

DAMON separates its core and operation set layer for easy extensions.
The operation set layer handles the low level access information
handling, and the core layer handles more high level work such as the
region-based overhead/accuracy control and access-aware system
operations.  Hence we can extend DAMON to use the different sources by
implementing and using another DAMON operations set.  The core layer
features will still be available with the new sources, without
additional changes.

Nevertheless, the current interface between the core and the operation
set layers is optimized for the Accessed bits case.  Specifically, the
interface asks the operations set if a given part of memory has been
accessed or not in a given time period (last sampling interval).  It is
easy for the Accessed bit use case, since the information is stored in
page tables.  Operation set can simply read the current value of the
Accessed bit.

For some sources other than Accessed bits, such as page faults or
instruction sampling interrupts, the operations set may need to collect
and keep the access information in its internal memory until the core
layer asks the access information.  Only after answering the question,
the information could be dropped.

Implementing such operation set internal memory management woudl be not
very trivial.  Also it could end up multiple similar operation set
implementations having their own internal memory management code that is
unnecessarily duplicated.

Core Layer Changes for Reporting-based Monitoring
-------------------------------------------------

Optimize such possible duplicated efforts, by updating DAMON core layer
to support real time access reporting.  The updated interface allows
operations set implementations to report (or, push) their information to
the core layer, on their preferred schedule.  DAMON core layer will
handle the reports by managing meta data and updating the final
monitoring results (DAMON regions) accordingly.

Also add another operations set callback to determine if a given access
report is eligible to be used for a given operations set.  For example,
if the operations set implementation is for monitoring only specific CPU
or writes, the operations set could ask the core layer to ignore
reported accesses that were made by other CPUs, or were made for reads.

paddr_fault: Page Faults-based Physical Address Space Access Monitoring
-----------------------------------------------------------------------

Using the core layer changes, implement a new DAMON operation set,
namely paddr_fault.  It is the same as the page table Accessed bits
based physical address space monitoring, but uses page faults as the
source of the access information.

Specifically, it installs PAGE_NONE protection to access sampling pages
on damon_operations->prepare_access_checks() callback.  Then, it
captures the following access to the page in the page fault handling
context, and directly reports the findings to DAMON, using
damon_report_access().

For the PAGE_NONE protection use case, introduce a new
change_protection() flag, namely MM_CP_DAMON.  To avoid interfering with
NUMA_BALANCING, the page fault handling invokes fault handling logic of
DAMON or NUMA_BALANCING, based on the NUMA_BALANCING enablement.

This operation set is only for giving examples of how the
damon_report_access() can be used for multiple sources of the
information, and easy testing.  It ain't be merged into the mainline as
is.  I'm currently planning to further develop it for per-CPU access
monitoring by the final version of this patch series.

How Per-CPU or Write-only Monitoring Can Be Implemented
-------------------------------------------------------

The paddr_fault can be extended for per-CPU or write-only monitoring.
We can get the access source CPU or whether it was write access from the
page fault information, and put that into the DAMON report (struct
damon_access_report).  Extending damon_access_report struct with a few
fields for storing the information would be needed.  Then we can make a
new DAMON operation set that is similar to paddr_fault, but checks the
eligibility of each access report, based on the CPU or write
information.  Of course, extending the existing operation set could also
be an option.  Then accesses made by CPUs of no interest or reads can be
ignored, and users can show the per-CPU or write-only accesses using
DAMON.

Expected Users: Scheduling, VM Live Migration and NUMA Page Migrations
----------------------------------------------------------------------

We have ongoing off-list discussions of expected use cases of this patch
series.  We expect this patch series can be used for implementing
per-CPU access monitoring, and it can be useful for L3 cache
utilization-aware threads/process scheduling.  Yet another expected use
case is write-only monitoring, for finding easier live migration target
VM instances.

Also I believe this can be extended for not only per-CPU but any access
entities including GPU-like accelerators, who expose their memory as
NUMA nodes in some setups.  With that, I think we could make a holistic
and efficient access-aware NUMA pages migration system.

Patches Sequence
----------------

The first patch introduces damon_report_access() that any kernel code
that can sleep can use, to report their access information on their
schedule.  The second patch adds DAMON core-operations set interface for
ignoring specific types of data access reports for the given operations
set configuration.  The third patch further implements the report
eligibility check logic for vaddr.  The fourth patch updates the core
layer to really use the reported access information for making the
monitoring results (DAMON regions).

The fifth patch implements a new change_protection() flag, MM_CP_DAMON,
and its fault handling logic for reporting the access to DAMON.  The
sixth patch implements a new page faults based physical address space
access monitoring operation set, namely paddr_fault, using MM_CP_DAMON.
Finally, the seventh patch updates DAMON sysfs interface to support
paddr_fault.

Plan for Dropping RFC
---------------------

This patch series is an RFC for early sharing of the idea that was also
shared on the last LSFMMBPF[1], as 'damon_report_access()' API plan.  We
will further optimize the core layer implementation and add one or more
real operations set implementations that utilize the report-based
interface, by the final version of this patch series.

Of course, concerns we find on RFCs should be addressed.

Revision History
----------------

Changes from RFC v1
(https://lore.kernel.org/20250629201443.52569-1-sj@kernel.org)
- Fixup report reading logic for access absence accounting
- Implement page faults based operations set (paddr_fault)

[1] https://lwn.net/Articles/1016525/

SeongJae Park (7):
  mm/damon/core: introduce damon_report_access()
  mm/damon/core: add eligible_report() ops callback
  mm/damon/vaddr: implement eligible_report()
  mm/damon/core: read received access reports
  mm/memory: implement MM_CP_DAMON
  mm/damon: implement paddr_fault operations set
  mm/damon/sysfs: support paddr_fault

 include/linux/damon.h |  34 ++++++++++++++
 include/linux/mm.h    |   1 +
 mm/damon/core.c       | 101 ++++++++++++++++++++++++++++++++++++++++++
 mm/damon/paddr.c      |  77 +++++++++++++++++++++++++++++++-
 mm/damon/sysfs.c      |   4 ++
 mm/damon/vaddr.c      |   7 +++
 mm/memory.c           |  53 +++++++++++++++++++++-
 mm/mprotect.c         |   5 +++
 8 files changed, 279 insertions(+), 3 deletions(-)


base-commit: 3452e05f01b2a3dd126bd08961cc0df8daa5beee
-- 
2.39.5

