Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DCD7EDEBFF
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 02:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522766B0005; Tue,  3 Mar 2026 21:11:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D9AD6B0088; Tue,  3 Mar 2026 21:11:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 406086B008A; Tue,  3 Mar 2026 21:11:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2DCB76B0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 21:11:15 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7588B160132
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 02:11:14 +0000 (UTC)
X-FDA: 84506753268.08.2A5022E
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4E4FB80004
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 02:11:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TfoAoGf+;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772590272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7JM7KJg1oz9+GC4H9JC1/W5RywkkP5XIUmh+2MLnGSo=;
	b=y7TGAuVYPAnoYdZi81OxasiOJNCW/oMpfQ8aHi0ZzzNjsY/qP0tiGoGducmnPlSFcRL7/H
	vJ87E9ogTJWOEs8tsenX59oaLJsWKhJUhOCyZf74V2PPK/e3LWosos2d6M4PK9JhnQ9z6l
	oJQfSs1pVKS2vFeeZSJ7PmbnB1rvCoI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772590272; a=rsa-sha256;
	cv=none;
	b=mBaaTghJKWwCxKGP+MkERpIblskDZFQT7W2HP5j8Md80YnKhhzTUEMheshlA3IkL5pXTfm
	sCR5zMgzurFpW0UMubFMJbjutJmwdPEq0yHJOcPjOoizKHsMJshOhwOsxMDKLSvNJIIRyM
	7lOpVK2yi2396VagwjK/jKlQXNtyAYE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TfoAoGf+;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772590269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7JM7KJg1oz9+GC4H9JC1/W5RywkkP5XIUmh+2MLnGSo=;
	b=TfoAoGf+iMnRCMxJ8U+btPdh+IIPPGxbuJdCC7Bd8LNMgByq7FyGFJ8m239RpK7m8U7Er9
	ze4BIS3oQfjHrS/KLKbCq2w6tPQJZEG8QeCJFAm2gU8TVjN1SsvRtH/Oi+tGbYzvdufzn6
	WMUcrLp1nIb5jDKxp24nvmO9DVyhCd0=
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
Subject: [PATCH v6 0/2] skip redundant sync IPIs when TLB flush sent them
Date: Wed,  4 Mar 2026 10:10:42 +0800
Message-ID: <20260304021046.18550-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: kof5wuh7xbaoihgdi9cqmi18zcu6bspw
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E4FB80004
X-Rspamd-Server: rspam12
X-HE-Tag: 1772590272-306574
X-HE-Meta: U2FsdGVkX18mSYNQPCyDCxKv/PD4cieBZUCvR91Q+uGL98yuB8xg5KGQcWlFWo70mi90rajcMRXUS23iUUWLf8KBbwIjG7zz6vyY09E3Se333s3quYE3iQiw+1S77yGGPR49yW1NrKQENI4NSzQqXQs7142NAG0YuRIb0xUf3s3DqWxY1vEmQJRJJta2eRW7tDYzutVNItCPMJ+/9KUQ+71erSjV6XOd7JKQgDXDTEuK9h9Ma4mgJPSGDUfGCe4qYZhIH+Pd0nEJsss7RTMWQVwZybDswc/WJ94KQIhMNRkYNkvhZsyMcsJRB971zSmYYZhQp4EuSdX+jxUUmAqlApdncuFkvRm0kxNYb0jedtlEmr3lbI+vm7crgyDc+o9ao6SgJMWjpTlNQi0QsSXBWkTRWbELBm9GIE70DYdEVdWMdXlxnIixRFCcKt6I5w5+UuLbtoocp8bwklqps3m140/gA9jsi0/bWLraASgAl5h3hjfqCVb+dtkO3sxC91J5SUWw8T0fTjUqAynOoQdXv7XPO4EOzuVOPnAbkU/CrFCoGB0T20DyHSnGZbkGMub0oYRNU20uBHRvIx3Rm7VMcKyKlK30EKakZokJ7ETda+79mxkYsEaonJHbpYLGcpERc/fp1mfeC0utL8prn72gwy46rI1NRoDcjt+YK/7MEhC5TuywnF/tyiLMicRYU4wZbDvoh9GHQLoRfXg0LC5zWUUH8RwO1Jp5GziDXcmxlXF445vbtOs6VkDiypFfd4hxNR2I9ZQQrtlq0RytuOhH7PC3tA1vXhDq7/qmJS03w5IuYs6nDO/AeDYNXx/qRoPbNATRKxTBKAccWdnsn1ijBF8bTMO237V/UaxsRidaIkh5vSNIqoxW7AKVTN4fP2xSf4iRwlEmrw+0W+k21MZc6CcIqmtMpquKypW6b6zpsLJIYUijRBBBF9sZ5J4LMfbblc3wE8OYB12pOHXEILG
 Qed/Iudy
 6qI1e7nCMxAaUKgMvINIgxT4w0zprFbAbOw+cuYXvYUzR5cHnnepZMHD4R+ytE64QfF38b6WdoQiovWw3YUgU0mxQohqEXwQlTZ3phqRSPICrmFZQ0sJsOn1N29CeZ4o1eH4gCZnkUUezEa7+MuaDvuYsDIrifXquRB5CNVcVd+r6IZ5vnbNy19XQcYb7a4agRiYpp+UBIKFcqD8k1xrYyMnMdOyq6h4FJEg/bAjc+GVFtgfxXyejirmcGOF1J3uJgv+JBFquOHV9fsFpnLLyhx6L17dLuqE8uC2E5UgdT9KibGPwBj+KuNOk5g==
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

David Hildenbrand did the initial implementation. I built on his work and
relied on off-list discussions to push it further - thanks a lot David!

[1] https://lore.kernel.org/linux-mm/1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org/
[2] https://lore.kernel.org/linux-mm/6a364356-5fea-4a6c-b959-ba3b22ce9c88@kernel.org/
[3] https://lore.kernel.org/linux-mm/2cb4503d-3a3f-4f6c-8038-7b3d1c74b3c2@kernel.org/
[4] https://lore.kernel.org/linux-mm/bbfdf226-4660-4949-b17b-0d209ee4ef8c@kernel.org/

v5 -> v6:
- Use static_branch to eliminating the branch overhead (per Peter)
- https://lore.kernel.org/linux-mm/20260302063048.9479-1-lance.yang@linux.dev/

v4 -> v5:
- Drop per-CPU tracking (active_lockless_pt_walk_mm) from this series;
  defer to Step 2 as it adds ~3% GUP-fast overhead
- Keep pv_ops property false for PV backends like KVM: preempted vCPUs
  cannot be assumed safe（per Sean)
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

 arch/x86/include/asm/paravirt_types.h |  5 +++++
 arch/x86/include/asm/smp.h            |  3 +++
 arch/x86/include/asm/tlb.h            | 16 +++++++++++++++-
 arch/x86/include/asm/tlbflush.h       |  3 +++
 arch/x86/kernel/paravirt.c            | 20 ++++++++++++++++++++
 arch/x86/kernel/smpboot.c             |  1 +
 arch/x86/mm/tlb.c                     | 14 ++++++++++++++
 include/asm-generic/tlb.h             | 17 +++++++++++++++++
 mm/mmu_gather.c                       | 15 +++++++++++++++
 9 files changed, 93 insertions(+), 1 deletion(-)

-- 
2.49.0


