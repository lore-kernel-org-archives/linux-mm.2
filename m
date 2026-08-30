Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD27EC61DE1
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 18:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B7626B0088; Sun, 30 Aug 2026 14:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4685D6B008A; Sun, 30 Aug 2026 14:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37E676B008C; Sun, 30 Aug 2026 14:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6DC6B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 14:04:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 84D1040339
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:04:21 +0000 (UTC)
X-FDA: 85158710322.10.40C9F79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id E3D4740005
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:04:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UgLTMhUa;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788113060;
	b=r57Ubah0RUhsWLbT76v3tFO8Nf1Hez7t60yme10CAppDUAz0xHHmeGIHtd+QVSFnfewjTf
	pG4QNp/IJem5TZMznySpooo86nRSJg4qyTQXbRaLiwR56HAz1zJLUC9MXEcnL/YEiWnNga
	EERswpMddTxTz+hbCq8KYBr1FhXVNTY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UgLTMhUa;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788113060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m88xwc8JeINQOcEmdlY5EvrRQoPq/hErRaBWIQ73IgI=;
	b=zaEnXnmYOoQEfGP8IHrviC9QFaS2N2gcHoql9zS99iupFicOyEmuXcGBq5z45uI5L19Qg4
	GPcAmL1XiRLo+8C5Url5upvVC2M8JHdZdqd/VZyZnyUGmQree2GRsR/YyEX+ko6DML66wX
	y4Sht6OHtFbM7NW4ks98fHN9e4hHxl4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AF58D40815;
	Sun, 30 Aug 2026 18:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A0E1F000E9;
	Sun, 30 Aug 2026 18:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788113058;
	bh=m88xwc8JeINQOcEmdlY5EvrRQoPq/hErRaBWIQ73IgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UgLTMhUaoy23cUFdrrSHJgkX2Cwez8f8AB4yxm3mRLGkgbS4p1BXJohv7il1iva2r
	 N4TGWinDnKGvt036jNZuSGnWiFMXi8AgBfQUXMwCbax3JLjk07r46g4BDK61rRkaCs
	 KoPX5sPgUyhzxv0IBwgut2ar2W/pG+squx+cImEx4ze8okE6J8m6dUAshbWf9Vlh1Y
	 r6RVDWIFuQ1xBDvQq+8piJApEeqFhieXfCLBJIA5acK3hx51/QzMCltO/TfMKotiVy
	 bEuJjPOgYxV6Wa5DvSRjvZYggCzFkPNE2C6xVYZKJhO+0IfbsWtaixl/6yKHqwUokL
	 efhpvsWNz11ww==
From: SJ Park <sj@kernel.org>
To: Krishna Iyer <kiyer@crusoe.ai>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] mm/damon: support access monitoring of hugetlb-backed memory
Date: Sun, 30 Aug 2026 11:04:11 -0700
Message-ID: <20260830180411.103772-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260830051407.50008-1-kiyer@crusoe.ai>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: bih8wjiceddwga6pragfthagqpqg9r3i
X-Rspamd-Queue-Id: E3D4740005
X-Rspamd-Server: rspam06
X-HE-Tag: 1788113059-1929
X-HE-Meta: U2FsdGVkX1/wcHwXX4+ucLKhhbb/5fyT9MjcYc3vStNxU1txw7wQiV5iK6OfXHgFYUlJg/cZlPVd9+wgRwfVzl+rDxn56fK/mF3sIWhnBaAfDLWfL43KHDk8eBDWqsV4JRrGfGArFNIh6DInCA7vIAQUA156ufH/9W+TqR6RPZJ5imzzfa3Mygks0bCyhlY8+s8B8Kt/WVG2KY3Blrppy+fzUGayyCujWazrC62+qWVlkh52VHwWcGJlmC7ztKP5/OGRqqVwPidvJX8OB/6bnWlPRl72inJzEgLOmUJvdhcs0pyOVcmsth9ygpPaj0oZrfD/FktD9romP8Y4+p5awKGGQGGeSCX0tjj2ht6wWLC1sK0a8/HDH4ij80JaiMSJEZuss+koHD8i5tbjrfbk1daMnnLzvJ41IjR4UZXVriY/75iKwHA7nAJeTBPjed1qq7Lvu3p08wbK1Sz/b9ZtR82jxKFpU4mpsHgZOtX1RbpsUkspCju3urRqYtPAo/QYBAKnDItwiHX6K18zgsE9FNru0/gf6TOwWoifXHlbpPZRzkGyM/h6wjDNtnOOewmLj3Wz9ju7lhEApyYb1gzouZytCLd5RnboHYgaWcAy8BcBnf3DLuMZwRm2Wg85hkdO22Bott1cgYTUL3Q4ResEJrXW0OI5KSvb5jsrL2eNCI2HQ5/Q7/f7IAJmNO3cz5dSMjRKq1cn6J+PtP6e6bCzxBNot+aem5+ZmW+bZih+37htauisAPxq2xXrviCrWM73M87KfBqb2lAGWFpEoEVuflpO0XqjL/OTJIUoo5XLPtrkrNyOuaWDRAbjBFtMmvHbK5sO1/yacvgWnbIVCu7uMbkZqYq/4lqlv86Nb0tEfpnRvLzQMdiGAu+PzxgJQqTrJMr1XPkl9LXkSu3nAySOE2oRmXh6B0YuOOIDqTxBelu3GU8JxaBBNnSbrP5LEeJIrI3mmnt4LHZRQST2J7o
 H3cYY9+T
 bulVCP9HGCdA9nhxspqDa/LYxz9drvir//GRB98lncACLNW+siffuA6djt+I7QTuD+/UfuZydeYfdemhIL5SoXZ1lBdC0eQEaZNm6HvWE9dhjSk0d1VncjRlxqxF2nWdGm56IDIzA04mFfvZE/4gpNPGrfsjZLGwlSxzL6DUs+FRB2e98GRoRKiBsiop3K+YRqwjVaIgy+kHZfOPIA/n5H6UElsJYscSpyiKVhlphOb5ahtqLO/vWhPUGcSHsF9CSaPkJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Krishna,


Thanks you for this great patch series.

On Sat, 29 Aug 2026 22:14:01 -0700 Krishna Iyer <kiyer@crusoe.ai> wrote:

> On virtualization hosts, most system memory is often backed by
> hugetlbfs.  On our production hosts, for example, ~95% of RAM is 1 GiB
> hugetlb pages backing guest memory.  DAMON's physical address space
> monitoring cannot produce a useful access signal for such memory, for
> two layered reasons.
> 
> First, it is blind to hugetlb folios.  Every access check starts at
> damon_get_folio(), which rejects folios that are not on the LRU lists,
> and hugetlb folios are managed outside of the LRU by design.  As a
> result, all hugetlb-backed memory is silently reported as never
> accessed.

Nice catch.  I admit DAMON is completely broken for your use case, and this
will effectively and completely fix it.  I want to get this fix as soon as
possible.

> 
> Second, even once hugetlb folios are visible, access-bit-based sampling
> under-reports hot memory.  DAMON deliberately clears accessed bits
> without TLB flushes to keep the overhead low, so accesses served from
> cached translations do not walk the page tables and never re-set the
> bit.  With 1 GiB mappings, translations effectively never leave the
> TLBs, pinning the observed access rate to the TLB-refill rate: a
> saturating guest is indistinguishable from a nearly idle one.

There were similar issue reports.  In most cases, it was because they were
running small test workloads on large systems.  It was unclear if the same
issue can happen on real production workloads.  That's because we expect real
workloads to intentionally access most of system memory, and therefore
naturally flush TLB entries.  On 1 TiB memory system utilizing 1 GiB huge tlb
pages, I can agree the issue can happen more frequently, even on real
workloads.  But, I'm still curious what is the real impact.

> 
> Patches 1-3 address the visibility problem.  The first patch moves
> damon_hugetlb_mkold() from vaddr to ops-common as a preparation.  The
> second patch teaches the folio mkold/young rmap walkers to handle
> hugetlb folios, aging the huge PTE and notifying secondary MMUs across
> the whole huge page size; the secondary MMU notification is what
> surfaces guest-side (e.g., KVM/EPT) accessed bits.  The third patch
> adds damon_get_folio_incl_hugetlb() and uses it from the paddr
> monitoring primitives only.  DAMOS action appliers such as
> DAMON_RECLAIM and DAMON_LRU_SORT keep the LRU-only lookup and are
> behaviorally unchanged.

I left a few trivial comments for names and comments to patches 2 and 3.  After
resolving the trivial things, these will be ready to be merged in my opinion.

Meanwhile, I have a few concerns and want to have sufficient discussions for
rest of this series.  Could you pleae split the first patches out of this
series, revision for the given comments and post as another series?  After
finishing it, we could take more time on the second part of this series.

> 
> Patches 4-6 address the intensity problem with a new default-off
> monitoring context option, 'aging_flush'.  When set, access bit
> clearing for monitoring uses the flushing primitives
> (mmu_notifier_clear_flush_young() and TLB-flushing PTE/PMD/hugetlb
> aging) so that the next access is guaranteed to re-set the accessed
> bit.  The option is exposed via the DAMON sysfs interface (patch 5) and
> as a DAMON_STAT module parameter (patch 6).  With the option unset, the
> behavior is identical to before this series.

I understand this is really needed for your use case.  But, I'd like to take
sufficient time here.  Two concerns stand out to me.  The maintenance of the
new interface, and the performance impact.

Firstly, the new interface.  We are changing DAMON for general data attributes
monitoring.  Memory access will be only one of the attributes that DAMON can
monitor.  For this, we introduced probes interface.  As soon as the new
interface is matured, we would discourage use of the old interface for access
monitoring.  We might even deprecate it over long time.  To make it easier, I
don't want to add more features for access monitoring only.  I'd like to make
this TLB flush interface as part of the new interface.

More specifically, I'm working [1] on introduce monitoring preparation actions
concept.  We could add TLB flushing as one of preparation actions and implement
interface on it.  For example,

    cd /sys/kernel/mm/damon/...
    echo tlb_flush > preps/0/prep_action

It could also later be extended for custom periodic TLB flush (we might not
want to flush TLB for every sampling but once per N samplings), like below.

    # do the given prep action once per 5 sampling intervals.
    echo 5 > preps/0/action_interval

I'm giving above as an example brain-storming ideas.  I'm not suggesting to do
exactly that.  But my point is, I think we need more thought about the
long-term sustainable and maintainable interface.

> 
> Evaluation on an Intel EPT host running a 944 GiB guest with an 842 GiB
> in-guest memory workload (masim):
> 
>   configuration          estimated access rate    idle -> load
>                          idle -> load (GB/s)      separation
>   stock                  0.08 -> 0.21             none (guest memory
>                                                   invisible)
>   patches 1-3            1.70 -> 1.96             1.2x
>   full series, flush on  1.21 -> 5.34             4.4x

So, you can show some of the guest access after patches 1-3, because TLB is
naturally flushed even in your setup.  But with explicit and periodic TLB
flush, you show definitely more and real access.  This makes sense to me, and
align with the theory.

> 
> With aging_flush set, the estimated hot footprint covers ~82% of the
> actual working set size, compared to ~40% without flushing, where the
> signal mostly reflects the ambient TLB-refill rate rather than guest
> accesses.

I think that makes sense, but having more details would be even nicer.  For
example, below questions are raised on my head.

How do you define and detect the actual working set size, and DAMON-found
working set size?

What is the size of TLB in your setup?

Could you share more details about your masim [2] run setup?

What is the estimated memory bandwidth if you run DAMON inside guest?

> kdamond CPU consumption stays approximately 0%, and the
> worst-case flush overhead measured is below 0.1%, which is acceptable
> for hosts that opt in.

Flushing TLB makes overhead in kdamond.  But it also makes performance
degradation to the running workloads.  Actually that's bigger concern.  Have
you had a chance to measure that?  If so, could you share that too?

> 
> Per Documentation/process/generated-content.rst, this series was
> developed with the assistance of an AI coding assistant (Anthropic
> Claude, via Claude Code).  The assistant helped draft the code and
> changelogs, and performed the rebase of the series from its original
> 6.17-based development tree onto mm-new, including merge conflict
> resolution against recent DAMON changes.  All changes were reviewed by
> the human submitter, who takes full responsibility for the
> contribution.
> 
> The series as posted here was regression-tested on its base commit
> with a full x86_64 kernel build (no new W=1 warnings in mm/damon), the
> DAMON kunit suite (41/41 passing) and the DAMON selftests (15/15
> passing) on a kernel booted with virtme-ng.  Functional validation
> (the evaluation above, ftrace verification that the flag switches the
> notifier variants, and enable/disable stress testing) was performed by
> the submitter on production-like hosts running the 6.17-based backport
> of this series.

This kind of transparent and detailed disclosures help reviewers.  Thank you
for doing this.

So, to summarize, I'd suggest reposting the first three patches as another
series and focus on it for now.  In parallel or after it is done, we could
further discuss about TLB flush change.

> 
> Krishna Iyer (6):
>   mm/damon: move damon_hugetlb_mkold() from vaddr to ops-common
>   mm/damon/ops-common: handle hugetlb folios in folio mkold/young rmap
>     walkers
>   mm/damon/paddr: support hugetlb folios in access monitoring
>   mm/damon: support flush-assisted access bit clearing for monitoring
>   mm/damon/sysfs: support aging_flush
>   mm/damon/stat: support aging_flush

Because there are high level things that I'd like to discuss first, I will hold
reviewing patches 4-6 for now.

> 
>  include/linux/damon.h |   2 +
>  mm/damon/core.c       |   2 +
>  mm/damon/ops-common.c | 154 ++++++++++++++++++++++++++++++++++++------
>  mm/damon/ops-common.h |  18 ++++-
>  mm/damon/paddr.c      |  11 +--
>  mm/damon/stat.c       |   6 ++
>  mm/damon/sysfs.c      |  29 ++++++++
>  mm/damon/vaddr.c      |  46 +++----------
>  8 files changed, 203 insertions(+), 65 deletions(-)
> 
> 
> base-commit: d2aad7fdcda7ae8a726926f2d6de7fe9e8ee7563
> -- 
> 2.54.0

[1] https://lore.kernel.org/20260728041242.187380-1-sj@kernel.org
[2] https://github.com/sjp38/masim


Thanks,
SJ

