Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E948EA854C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 02:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 342376B0088; Sun,  8 Mar 2026 22:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EF9A6B0089; Sun,  8 Mar 2026 22:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1B66B008A; Sun,  8 Mar 2026 22:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B26D6B0088
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 22:07:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 608A5598A5
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 02:07:49 +0000 (UTC)
X-FDA: 84524888658.21.84F018B
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5C8F3120006
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 02:07:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mU5bgyYM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773022067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=V0H52YA903E3VPzSWk0ElGaPEQ3BnLKOt5AjCSlodL8=;
	b=GM7eIlaeko7KpI+0FBf4QV1agFnfuyff+mzoWeG7YYZMbyzF49F3q9rxfTKCw/2yfw4sMI
	cjCiRNeVWmLGrIPu8aBdwGJza7m8P+5zDrbAJRJzMxEJ/vtzZwaa2+Mq2VShieXgImaZYx
	hw3Qbk6aD+JGxEYWwwrn056gRUntdTw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773022067; a=rsa-sha256;
	cv=none;
	b=BYjUEVfEPauPZNkYFgjBjmP+rq4fHHpZ7gql5R8YvccsCwX9mygkfRXBmJ/cQRroIxKz2r
	QVgBk+UCgBtc9oQHgbT/rMngIi4uABP5LQzmZPMqNBOnSlgXOMnDoANnAqW2H7pmP5onSw
	3byJ/zfXevsEA37t0CDlw/euWvPLdRQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mU5bgyYM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773022064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=V0H52YA903E3VPzSWk0ElGaPEQ3BnLKOt5AjCSlodL8=;
	b=mU5bgyYMTIDWyuGCnyCQ1uPPvPq/30emUstvkeG1T//llJzeNNwPtjj+rUk32K6puen+7W
	0JuSrvBzSMi6hqTNQousL2lZ3/j36zqFE3P+kUP73qRHv7xpXVqa475CZZlvDXlUcdUUWH
	+VHAjoHH5/vOvzs3B+c4vvFpKu53tNw=
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
Subject: [PATCH v7 0/2] skip redundant sync IPIs when TLB flush sent them
Date: Mon,  9 Mar 2026 10:07:09 +0800
Message-ID: <20260309020711.20831-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5C8F3120006
X-Stat-Signature: n83j15iqeh1w9ghhamt7s5dam4cbzobw
X-Rspam-User: 
X-HE-Tag: 1773022067-791022
X-HE-Meta: U2FsdGVkX1/RzSxgYIro9rC1JGvgdQY3Q3gaN2JiipRm80WIEyqv66iBy+Lpaf2wrPQSfrSwK7tCLnceXxji3JmoERrpFvle+GbnBVi69ODR2injjQg2VHNg98A7y97FqvB9ZAnmvSDRryzTG5R+sdsxf4ArojGIEARBY2TElCcPGBL/d0rQkvxpE+OtjefjAKLsIxhAkj34mXl7KO3MJrkFA+5G7LuVWmOzkNm5Ve0Llfvel14qk8v5Qodi75Ey0uEZdUUnTLPpxC8QTcp+4515xJ0bCKlYVeCh2pCCzobV9R1h0Rg+N/Lbv8L2NHMgtC/PSYXmy4EiVl/pyZq4js0cVUPctuWrSkV/L3drO09+7RL4+5FpoZNkhTGeToUz4Yt8I5muQ/ZgamsYVbbCy3P7IGaBAKs5JS9neGq9tPQVtQ7TZYJQZ2T66695W+Iekzy4zKqRojpf9CeqDE0QZMct4mmuXMG9g4OhHRnAdBTQxI9Bt7M1YVQG9trFplP3JesySSsK7VfOAUfVos1eEV4obnrmlo4RuqHYk8vWBFhm/rHbti0w/quFxZFSUh1FsIEo2pkAa1wbqyE9iZXg9wGK2o7mZnNWxyir0lAybxbRtRLZK5J4euwOxhxZ+wJvYFqXnayIzYLOEDl8l6iF/DsMLMuTV/UgDGg1z3DtT7tnHi2yZ4M2piv58Gx5J7kuDrDTQXBGFTF1KbRFlAyrEk4JVxht1pnCkcT7ww8/nkWB3lP3dhoLoZ7mWjxzydZM/B1vFFom5FZ2/feYR8jBPtlDFWD/As+OdANTLcSAjfphosZ0oONWnEE75fVvPP/eEYiMfiwStSaZ4oHyMatI3iIZkhuM14LHmSCjfp+HoGm5UBzd8JL+M4njxz0AcEUx3uvtIgefw5Vj9vQ6HEfoKA9RmHEpSXVyTgr/4q2cnoNJYlkasq2zkTUijOY/Cau2/pf5t1TXykiYzQ6fdN+
 H+KTMsJp
 M79+75tZFfKJo2YwsjaAeGvXt6PWSsGcxgpKz/pwFV6DSoei2UCuUyot2nSuhwqpiDQkWdfeK6xI8nTIXQ0QBHRIQvppGK6EDcnJTWpK33jdm7ZjIp93mE6VW6Byt3vSAgE/6F5TfRTKPMvM9JYmugweOCsAOyKKV+iW/BIqcH0bTqltHLp//YAaK8VTro8o7Zy287I7QOIvBE1DlGRHgdWyt7tHaLOaK1njIrHaXPkv3KWQRBDKdJlWe++icXxqF9a8iwlkl7NJ5Tkw=
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

 arch/x86/include/asm/tlb.h      | 17 ++++++++++++++++-
 arch/x86/include/asm/tlbflush.h |  2 ++
 arch/x86/kernel/smpboot.c       |  1 +
 arch/x86/mm/tlb.c               | 15 +++++++++++++++
 include/asm-generic/tlb.h       | 17 +++++++++++++++++
 mm/mmu_gather.c                 | 15 +++++++++++++++
 6 files changed, 66 insertions(+), 1 deletion(-)

-- 
2.49.0


