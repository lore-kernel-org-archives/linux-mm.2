Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AA0EEA71B9
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 03:09:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D026B035B; Sun, 19 Apr 2026 23:09:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDDED6B035C; Sun, 19 Apr 2026 23:09:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF40C6B035D; Sun, 19 Apr 2026 23:09:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AF7546B035B
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 23:09:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58F90160660
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 03:09:26 +0000 (UTC)
X-FDA: 84677453532.08.6BFFE0D
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id D9B9040006
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 03:09:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mx7mParP;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776654564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AKl1g17ICBm+Yhc31h7NqqZRHOYKzoDOhKe2BAK4Ft4=;
	b=oTLxgSGYTnEVlItPu+V+GqMeOdixEEZC5hBDtjSNLmZAvsYjssJd1p8Jaa4djz2boOMFNp
	8VR+guPdnqueVAIskgGyrOy+Whhfi+GTz6ttZftDcB7mu+KxwkYk1hT8dho/nO2LjHNNnd
	VoHS4iBV/H+2deFjeRpFF68ncXluF3g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mx7mParP;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776654564; a=rsa-sha256;
	cv=none;
	b=NcSoqh7vjF37qFyPeHEVojFWoMmr2HJB2JN4iE4XKNn1Z4bboyku1W7jlcAP+n4iM5UzlL
	mjomEbTCBSh6BZhri6t3zxRv2Ag2tnqXMaxKugQUBwq4nMKiHUdHuwNlyr9i/74jxWTYsE
	7nmOFpTB70swliAt+imvk+i3YDXUQk4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776654558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AKl1g17ICBm+Yhc31h7NqqZRHOYKzoDOhKe2BAK4Ft4=;
	b=Mx7mParPLpVFgaIsnwObBrva2C+5otUR/xdKuDFQn7DRs58EXi/S2SYJmUo/FlL/NI4bMz
	LVozt4FY9JRCCCV8dw4pPwmOiNy/p+R2L2M9aY7tIFFaB2w3gJK1ABztD7ngmnjP4QsJSy
	5icta9wZ9AzxQ8BVz01S6WNDN9u5CcE=
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
	ljs@kernel.org,
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
Subject: [PATCH 7.2 v9 0/2] skip redundant sync IPIs when TLB flush sent them
Date: Mon, 20 Apr 2026 11:08:49 +0800
Message-ID: <20260420030851.6735-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D9B9040006
X-Stat-Signature: muwtemcb5dbfwp8pe183cxi9jo9bnxh9
X-Rspam-User: 
X-HE-Tag: 1776654562-540351
X-HE-Meta: U2FsdGVkX19bBnFNjjiPkGYmeaF9tZRM4xOdoBqGq6befMvNUQWXW5SPG/J9rczmPQEg2ordjIDRGsHi2VYhDP7sNZaDXQ3cQcpl92eDbJw6MLGP8hVjpCXdtL57ezXrtA5Zf7PKHU1O4rzojyx0VcGpkZ7NMSIGlcd0VPjGXUNfUL5b+hA6GGMgfyo8VsUXE/N6KZC4evuBZuIB3IWO6Y/NrbtIDgeNQYu3aDawuICjUHHk8e9tPMVsGRkNpC1t7lCM+5j+6esaQX+RP0bxmZoBRREjuYskq0r7dgDKVfGVwn0i0BvY90YvP0MeNl5OyQsmGlZ7jAvw1QnBDCse0BPXxlXHiIdoGNz6l/eMu15icVZUY5s62YX1vOT1e5Yr7MJSPDWUruUiSr0aicKszhvHiqd3Kit+PUMUHoVTeKeHuLE7RAVz5incjmiX2dwpaRuO5xUu22FbjXHh+tSvQbjD7cuumMjvP3MrQuLnL8vHwvkmkUxJsdzLQ0I07o+TgmX5BNElQvPEMt/cGdqN2N7OPT5UPlDg+2DJWYRgrCdRa2POuzwnjtZkaTEW1JU6eHul96EBr6TT4f1xFOVWxWI2OUa5hYBCFm5K9VRAPo0ZbCHyanHum3eUuDE4BevVnHpYN+K+pccoMi8n5ffqCy0vf0ps1xaCHPckbBYahk+UectxtRF99lsJAh+N2zy5m5AsJbfdRm5VysVKML/fwPk2pnSgV758j9Bt+ytRH1eH19m+RM2gEgVRZ0I29t/wbUtFL5Xjt3vL/k5X2ZO/kWadyKBwYcJgOWNADYKWnU1KyJqySRBKV4X1ziWKKxpekz1Vjqhsgp7eH2K2Z+aT9dZEVNCE3J3vT5vgcQ0tqkW95CCyTETvbXrm+YKF7ONvB1JlYcWF8JnOUfWFIUeDhlt4l8lda235KJ1qqh8tyybi8iK/mmfos/ECAMhJf31WxzUMZRkm/kexsbnBHae
 zmjk3btt
 1lZEsBPl8jNbtq2ICUt+oDbZQV9nZPGKLUX1wSN2HTiI2kqA7Z1456JgznMJ6XYRiuiQAavbp9zS2ONn/JtzG/u7CHbrzmRhZRWx1kZMy9IhLN+M0moi4dLBt1l/2PvXFwTvKPb1Vcrb+4pbbPMq5mvkhXojYhu5OI9FOaoOw69kGz7tZsT0UgA9IbO7yny+SeQmMWeQ45trvAPvaYyvxUXCPPQ2E8IpecEf4F9yS6ScP21WqzjbAqGNaMjOFV9IU9uGhcVkGGmXE4dA=
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

v8 -> v9:
- Rebase on mm-new; re-tested, no code changes.
- https://lore.kernel.org/linux-mm/20260324085238.44477-1-lance.yang@linux.dev/

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

