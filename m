Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A537FB44B8
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 06:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83F056B0005; Fri, 24 Apr 2026 02:25:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C1B46B008A; Fri, 24 Apr 2026 02:25:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689526B008C; Fri, 24 Apr 2026 02:25:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 515D46B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:25:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D73F31A082E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:25:54 +0000 (UTC)
X-FDA: 84692463828.23.20F3D5C
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id E45DA20009
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:25:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XRmmqUrO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777011953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mFgoyKCdQiiWZt7LRrYUU2foyvCx7Vjp2N1i0zg6fIU=;
	b=kMMB77hvFdj9Zr79Xjea9591OEzzloSqzFweYnSn1KcpLPSrL/ATuH0T7XJ2YwYMXxXeUj
	+kP10CdFzyX5mVT8TgGfcPp9pdeY4nhrNAzP46CK2qZisRmUdbZbEnBDjXnTa5m1LuPMJB
	lfUHc7SbirwJcZ5PV1alm8BGJbmHg8E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XRmmqUrO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777011953; a=rsa-sha256;
	cv=none;
	b=raC0nSrqiqt3un6IHFbn6aoiRvmRknZeW5j2FvISYOmTcmFYnK2Fb2oBrHfWItmsQSimpv
	oJ0DylvutTvxjzyH8H6c3PZyRqpPvuh4LFIitzbJMsR9IImIxYyCYqU0Ph48GYxG70yyK4
	F4nGrq7TWNcbC/10IX4GeBD+kWByAB4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777011950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mFgoyKCdQiiWZt7LRrYUU2foyvCx7Vjp2N1i0zg6fIU=;
	b=XRmmqUrOYc9Gli+1BC9Spfy7SotfZohrpb28KWuYIvzVNN4enYEFRaa240/cV1Q5Qbaj5A
	koauctdWoE5TVodVLaAGCmKdLdYvkaVNO8Ix6UxhysIHCBtE3aI50U8qp3DfZ3rtcrfnBp
	K1iBIgJrUzhg6ABNqmFhDERVlj0oJUo=
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
Subject: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush sent them
Date: Fri, 24 Apr 2026 14:25:26 +0800
Message-ID: <20260424062528.71951-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E45DA20009
X-Stat-Signature: jhfz774dthqe1t81sm8rmtwxfpoy1hd5
X-Rspam-User: 
X-HE-Tag: 1777011952-82879
X-HE-Meta: U2FsdGVkX1+MaE78GQqwdhCFTb/27RhIGSyKoThFnBLsBG25dh/l4cE5LkWyt2UPcUYOdzBQUGZG4/ucVKtkoSeSvirKUuwHAeLczFurDmMnmCgPCv7wFyc/wpV89rKjiVuusTyB9PiPqFhu/S/GusLParPwnt/I48toikkJFwHwU5TCtleNqZibbvudE1yFHZFzuNH6AZ/8zo3wytfo5dnkJyFyWElHNkOvAnFFFB188PIMNSGn1hUCaNSmgzbjNefxjoUEVdmmuYPXzBPPKnkUufDRnaygGShBUd8UqgZipBO9Sz7mwwBJYIXnstwMopKbcERpxYJmEEZO3W+5/SOzjYiTaRmM0v/OLQb+mq56Byk76AACfW+y0N9jrQBSjtnMnNVITPap+P1mq8Bhar02MrZIvprpZ2cd1qi8DZ+3LBrz5eIZspp+ohC58twPI56qYRZEg+fOeeaYodQZdo66IpcwqyX4SV5rHko50m757uV3tokQLV3gf6UPhjfL5QM6GYMngPCeaoiQOqbYOucR/MRCMVvP25byGiSumfKDVTW6ZxrVdsjXRm/oDkbf6SP7ZC56Gv1wFxwvKjpgh345h/CY2ZJI6e8AiEgju00zkRpIlMSYwJMYINLUImZYOOSlXHBicrW0VHmhVpwirxcy/qwn/Hjw9Red1x7tho2OyPsO69vGgr7OdPdYJcBfPjjnDVhI81addnMQL7Cb84eiXmGLpzldni2cgvBvZtYEedf0OrGTHqB8fi4jKtRsbokG4vamWQV39+TXlGPTFb+98auim2OiX4DFHQw6k80KtJWqPaSGInHTQKKUhzCTjeswEVM+41GF0VPp57DgvC+y1FtyHMrqynDVAsZrt7dkh9L+jO8UBsFD7/40Ultxwrtg/CnIfPN0KOeuSyiq4nXR1Q3Z4lzC1GHEvJQI0jHyJxxZJIMFY21eFuSMjhLlQ92iMczf3GC5ymFcPOm
 JzaSrLSj
 UwbTgmMT/j2wKnj1fH08IRrA4HbiGsqKP0sFLVJobJgfZHUp2eVMy7+sYPhKx9mhlUanXn/mkTDwxWrXPHJ7rUsyRASY8ur823yYtjj1y2ZJv/nVFDEEolNym316pdl4HqwfF202zKgLiQpG6lrf1/IgxQPXNWDVR/+bkyfwrPdAuNIo7GvidJBeLW8MDZ+9KvXDb+Z1hP3gNBQjN4LoJaYwqGz+rchLEobIy86fMyWQGBMgBw7n1OMkA3PlbjxFlbFmN0eGXYLkBcW0=
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

v9 -> v10:
- Rename the x86 flush_tlb_info bit from freed_tables to wake_lazy_cpus,
  to make the lazy-TLB behavior explicit (per Dave, thanks!)
- https://lore.kernel.org/linux-mm/20260420030851.6735-1-lance.yang@linux.dev/

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

 arch/x86/hyperv/mmu.c           |  4 ++--
 arch/x86/include/asm/tlb.h      | 19 +++++++++++++++-
 arch/x86/include/asm/tlbflush.h |  6 +++--
 arch/x86/kernel/smpboot.c       |  1 +
 arch/x86/mm/tlb.c               | 39 +++++++++++++++++++++++----------
 include/asm-generic/tlb.h       | 17 ++++++++++++++
 mm/mmu_gather.c                 | 15 +++++++++++++
 7 files changed, 84 insertions(+), 17 deletions(-)

-- 
2.49.0


