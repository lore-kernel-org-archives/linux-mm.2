Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9741EF532F8
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 08:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C469E6B0005; Tue, 24 Mar 2026 04:53:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6956B0088; Tue, 24 Mar 2026 04:53:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABF236B0089; Tue, 24 Mar 2026 04:53:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 950806B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:53:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2396B91731
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:53:20 +0000 (UTC)
X-FDA: 84580342560.01.EBEE748
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6B5771C0016
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:53:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ehx+GvCQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774342398; a=rsa-sha256;
	cv=none;
	b=UiE8TuZyUb6t60AdS9ghJDzWI8Gagv981WJ4EBngK36DoBEKYiCA1zVVpCu09acQjvlXor
	xC7JVqk+Fg4k0cmRu1SGTxyaExn/ImB5Z/3i3LzKq1Pc0DHdtKi0gqf+ksIh8yZ3m4ON9o
	JE4Tiyx0BeJP7jK1FjzfCAJRXCaWXFM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ehx+GvCQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774342398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cooa/41xI7d+DZUvbghWmkV6GAOYjQWfhrGJsw3E+Hc=;
	b=CenJSgPapYBlYCA6wyYgLMS5viKeNUcI561KJNQkGFkUFE4EW8ewIjF+GzQ5uw2nsvC4xP
	8PExvSj1Spnzyif5nzp0S7uomXWM3c5NLPSj+yzbfjeUmcwLAOIe88Y+ECMJNZ8cUYJ658
	T0W6AEBPTAkbv1JV67v5W/yRFruciso=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774342395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cooa/41xI7d+DZUvbghWmkV6GAOYjQWfhrGJsw3E+Hc=;
	b=Ehx+GvCQR7JSE3G0Gcv67EFfJuYOYPtcS6CVJgMxW9nvVX1uHVU+O9ZtrvqPr1sZO9Vos8
	RZ8pygTVO30fZj+U9PODUBVQ4GmxXMmPvam/Z9FB2sPnjVwxAHx9+mYbDoG3O+ES6AekQF
	Rz7lQiIdgJAhpWLNyo2xOXvidlRKOE0=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org,
	david@kernel.org,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	ypodemsk@redhat.com,
	hughd@google.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	jgross@suse.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ioworker0@gmail.com
Subject: [PATCH v8 0/2] skip redundant sync IPIs when TLB flush sent them
Date: Tue, 24 Mar 2026 16:52:36 +0800
Message-ID: <20260324085238.44477-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: by76qnkhxk9dy517aknja6dttocf897m
X-Rspamd-Queue-Id: 6B5771C0016
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774342398-888517
X-HE-Meta: U2FsdGVkX1+YfBJJr7dQ6MSeHxe9GCcwteaBnhVvJswuT8dAmoR6gN50mumHZ+2aau/CkOJAnuvU7UgLnLFRFVit1QHEux8c26dAMqp3pUMwfSr22d2+OTMkQ6LgxXEo49Q0JUdZzYj7ATqqGJ6BwJBU8l12nb4HUDVHobYUlHqT+gp8ddqtKfkhZGTIdxmGpWm1ySfH9U8x8wNBsd+492rxvJHxOGEBztIYDzLpW4BiuSX85bIfzauI5R6iy95lj8OCKxj7M4UuPbvBJ2YcvcjJ7aytoOnrN1VWManeEyQf+FM6EJ6wTIuTYS/5cqmyKH5yyX0rky77dUYTD0CY4XzufFscoVrNLciMwl+xPDe5vHQ6ItRQyBYXgT0zSmt4DV2PuxD3fBhQppjZzqo0UvJeUCtltT+ieMD4Zu+q3bja2C/aieUFrypCcGZGttvj8EX25e8FkNC68+7bLGOKvoUdCeU0/o6DE/EgaQLcZXe7MdvqgCdp9lnVjTAw+JNr2TVjaQ0Z3f81tUXBc+S1J3Njvbr4XMOtnysIBf2d+9uTopowAMCMMO+4Rw2yX6O/kXo1gr6TURXNq+6kJV7VDRiJapE+bs6Hm1u8dM9EMkskzNRje6JwLgtEc7njSmD+KFFMIax6QlQ+0ddtN3w1EIY+7ASFiOX4pMAtAoLeMThaj4tIu6pHHaMnUbcRYFR97Urw+5pYKoxNkgctmGu9pK830YcESbHwMaJitzN/MzrTR+iDGraPQzXIG0EMr+F1i5c32yOW6qy3EYBDQE5ZW0opsPRvTOwYRrKfNNV94QXJ0dN7emSskqin8Ux+h/yypG4NaH2YkdCpxFHx+65JZCL4Ku50zAWPZGi69gYJQP3TfJj7h+mKXlA2LErj9wE4C/+qrN2AyvU3gj5o7dvMkoEZDq5RRhYOLJs6R590d2L2Ax+8iVtZ4wGKksMlv11uULacuG4UJXKuRdhuMod
 ggDopvmp
 ef18srkT9tN2LL7MR3ljd0nhWNwWCnZ7KSPj4+lK8gMLsXH9GQkqrqZBTSa09DTLoqOxHQtPb0l55yR1TMYI3fHnGtxfEEXN6jYcYdpJCopuAxXMr6uQBce1Ft3lNEJJqZzxIrn/u3nGpTpcFwZltXNLImuWwxilX81FCBPVUA62QR3e44u/Hok9690cI8x+yegzUhwx83JDc5CRDEqFiGABxbORSjb6tjTvgSBMtmGo1WPqQTdrBU66k2ZAjGmtKUdNoryrs8PNptW8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

When page table operations require synchronization with software/lockless
walkers, they call tlb_remove_table_sync_{one,rcu}() after flushing the
TLB (tlb->freed_tables or tlb->unshared_tables).

On architectures where the TLB flush already sends IPIs to all target CPUs,
the subsequent sync IPI broadcast is redundant. This is not only costly on
large systems where it disrupts all CPUs even for single-process page table
operations, but has also been reported to hurt RT workloads[1].

This series introduces tlb_table_flush_implies_ipi_broadcast() to check if
the prior TLB flush already provided the necessary synchronization. When
true, the sync calls can early-return.

A few cases rely on this synchronization:

1) hugetlb PMD unshare[2]: The problem is not the freeing but the reuse
   of the PMD table for other purposes in the last remaining user after
   unsharing.

2) khugepaged collapse[3]: Ensure no concurrent GUP-fast before collapsing
   and (possibly) freeing the page table / re-depositing it.

Two-step plan as David suggested[4]:

Step 1 (this series): Skip redundant sync when we're 100% certain the TLB
flush sent IPIs. INVLPGB is excluded because when supported, we cannot
guarantee IPIs were sent, keeping it clean and simple.

Step 2 (future work): Send targeted IPIs only to CPUs actually doing
software/lockless page table walks, benefiting all architectures.

Regarding Step 2, it obviously only applies to setups where Step 1 does not
apply: like x86 with INVLPGB or arm64. Step 2 work is ongoing; early
attempts showed ~3% GUP-fast overhead. Reducing the overhead requires more
work and tuning; it will be submitted separately once ready.

On a 64-core Intel x86 server, the CAL interrupt count in
/proc/interrupts dropped from 646,316 to 785 when collapsing a 20 GiB
range with this series applied.

David Hildenbrand did the initial implementation. I built on his work and
relied on off-list discussions to push it further - thanks a lot David!

[1] https://lore.kernel.org/linux-mm/1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org/
[2] https://lore.kernel.org/linux-mm/6a364356-5fea-4a6c-b959-ba3b22ce9c88@kernel.org/
[3] https://lore.kernel.org/linux-mm/2cb4503d-3a3f-4f6c-8038-7b3d1c74b3c2@kernel.org/
[4] https://lore.kernel.org/linux-mm/bbfdf226-4660-4949-b17b-0d209ee4ef8c@kernel.org/

v7 -> v8:
- Pick up Acked-by tags from David, thanks!
- Add CAL interrupt numbers to the cover letter (per Andrew, thanks!)
- Rewrite the [2/2] changelog and reword the comment (per David, thanks!)
- https://lore.kernel.org/linux-mm/20260309020711.20831-1-lance.yang@linux.dev/

v6 -> v7:
- Simplify init logic and eliminate duplicated X86_FEATURE_INVLPGB checks
  (per Dave, thanks!)
- Remove flush_tlb_multi_implies_ipi_broadcast property because no PV
  backend sets it today.
- https://lore.kernel.org/linux-mm/20260304021046.18550-1-lance.yang@linux.dev/

v5 -> v6:
- Use static_branch to eliminate the branch overhead (per Peter, thanks!)
- https://lore.kernel.org/linux-mm/20260302063048.9479-1-lance.yang@linux.dev/

v4 -> v5:
- Drop per-CPU tracking (active_lockless_pt_walk_mm) from this series;
  defer to Step 2 as it adds ~3% GUP-fast overhead
- Keep pv_ops property false for PV backends like KVM: preempted vCPUs
  cannot be assumed safe (per Sean, thanks!)
  https://lore.kernel.org/linux-mm/aaCP95l-m8ISXF78@google.com/
- https://lore.kernel.org/linux-mm/20260202074557.16544-1-lance.yang@linux.dev/ 

v3 -> v4:
- Rework based on David's two-step direction and per-CPU idea:
  1) Targeted IPIs: per-CPU variable when entering/leaving lockless page
     table walk; tlb_remove_table_sync_mm() IPIs only those CPUs.
  2) On x86, pv_mmu_ops property set at init to skip the extra sync when
     flush_tlb_multi() already sends IPIs.
  https://lore.kernel.org/linux-mm/bbfdf226-4660-4949-b17b-0d209ee4ef8c@kernel.org/
- https://lore.kernel.org/linux-mm/20260106120303.38124-1-lance.yang@linux.dev/

v2 -> v3:
- Complete rewrite: use dynamic IPI tracking instead of static checks
  (per Dave Hansen, thanks!)
- Track IPIs via mmu_gather: native_flush_tlb_multi() sets flag when
  actually sending IPIs
- Motivation for skipping redundant IPIs explained by David:
  https://lore.kernel.org/linux-mm/1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org/
- https://lore.kernel.org/linux-mm/20251229145245.85452-1-lance.yang@linux.dev/

v1 -> v2:
- Fix cover letter encoding to resolve send-email issues. Apologies for
  any email flood caused by the failed send attempts :(

RFC -> v1:
- Use a callback function in pv_mmu_ops instead of comparing function
  pointers (per David)
- Embed the check directly in tlb_remove_table_sync_one() instead of
  requiring every caller to check explicitly (per David)
- Move tlb_table_flush_implies_ipi_broadcast() outside of
  CONFIG_MMU_GATHER_RCU_TABLE_FREE to fix build error on architectures
  that don't enable this config.
  https://lore.kernel.org/oe-kbuild-all/202512142156.cShiu6PU-lkp@intel.com/
- https://lore.kernel.org/linux-mm/20251213080038.10917-1-lance.yang@linux.dev/

Lance Yang (2):
  mm/mmu_gather: prepare to skip redundant sync IPIs
  x86/tlb: skip redundant sync IPIs for native TLB flush

 arch/x86/include/asm/tlb.h      | 18 +++++++++++++++++-
 arch/x86/include/asm/tlbflush.h |  2 ++
 arch/x86/kernel/smpboot.c       |  1 +
 arch/x86/mm/tlb.c               | 15 +++++++++++++++
 include/asm-generic/tlb.h       | 17 +++++++++++++++++
 mm/mmu_gather.c                 | 15 +++++++++++++++
 6 files changed, 67 insertions(+), 1 deletion(-)

-- 
2.49.0


