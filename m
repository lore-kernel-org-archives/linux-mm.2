Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0DA8D58E62
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 06:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D719B6B00AA; Mon,  2 Mar 2026 01:31:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1F2C6B00AB; Mon,  2 Mar 2026 01:31:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF3F86B00AC; Mon,  2 Mar 2026 01:31:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AD2236B00AA
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 01:31:16 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F023C1405C1
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:31:15 +0000 (UTC)
X-FDA: 84500150910.26.F81147F
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 591994000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:31:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EL26oSKK;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772433074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PCkDc+/JIEZu8yTcReQK9/dfFOjWNIdEfBJjK1+JSGg=;
	b=O9zU20Rj2vEcuSJh2VuM5T3qy1zACMupUDyOCL8KoBlWg6q72V5tggDkkGLyVxdJDCZlmX
	idjf1DV0Z1OWoocUWT8Kx0X4hOXoHM8a76Ra/93FHro8SqsM4EppK9WqNJV+P0Z/aHbzzb
	Te0cZkIkZlCClsWFjbwclwxwpvpGKoE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772433074; a=rsa-sha256;
	cv=none;
	b=G96zPg/cGwN0Jb1+VnTmaN2k5jKgd4YeIS4J9GXHicB1uNlHkbo2t83ucfGRpO5FGYclRJ
	1pLKFPp97+J8icqfQgvdg6JVpVNsY9I/NploSLEuBjY0XDyF24KYifk6psBFCQSFYGMJUR
	fFWzlYLBMfEe4KnA7+amC2EosvXu5NU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EL26oSKK;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772433069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PCkDc+/JIEZu8yTcReQK9/dfFOjWNIdEfBJjK1+JSGg=;
	b=EL26oSKKMmfqMxpSyKc7zpY9NL6kI0FEY4XuALcQ+valkHz1ft+atfA9XnRxyG8VaUhdmG
	Xm6ekAWISZvCXUZJoNbLbOyxFkT5XdPoCY0xYHQlQoyhJeLbFoXB8QPFw0Y11xJopqgfpg
	YM0WFZFes1OAmsYJEedg0Mo+OUB5ON4=
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
Subject: [PATCH v5 0/2] skip redundant sync IPIs when TLB flush sent them
Date: Mon,  2 Mar 2026 14:30:34 +0800
Message-ID: <20260302063048.9479-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 591994000A
X-Stat-Signature: igxrni5a1m5w54iazktbao14jam5rtum
X-HE-Tag: 1772433072-111689
X-HE-Meta: U2FsdGVkX18xoXcTZBwt3ghRUOvZYC67Hg71w3eJ0tcPzJcGqYusMvegrECAsVxGOLH4PbzppxIOpMruZrttsTk9aJE6b1vNPTNsdVGV90IfRPR+yl7QUk2WDNNeoOhi5I1QLuuGYY1cFmx4EpjJgkUfQOdyDRwmygXIrtdnYr1i/xU5OI8UbEPkjqghVQD84LxF3+qXP1+qlgo7sSnWwYpW1f+8f2stdyToK/xMWEX94QP0cmhXSvVSEMSIyLGuoVz1tSFSIq4Wj8I5FKvV7u5/kNM/EkmJwEo01k67PKRM0AGKfygjUZlaZk+QUWUE6l0mTKVOQCJFw5QrUPBEQpEnAiD2UX2UlEtCIrZ3UX9nqBqhyjR9W4K+aZQztNWj5Om8rWnCN/oeyRY7+GYcZ1u48gMH35ebuBgBY7wrDVRmQYVzr8HLw37sqbbUSLtfEp5DSREAz/3QUaKzAk95omLJH9CRYb59dL2eKE+q9OqUqmuI0IHfLYBA07RTDUTmUUbnfFcn3Evv4USwgKQcSqZp0ampqEnHU++kgjl1V1XDzbbar3EV8imhaQ4IHK+vKiy929ptNHdBidea/sR9lA+Z+R3Sa+tWFkYHRv5baAooBdz4nW1u2Mmikn3ic74e878+Obflxqj61UNIq5Zn+7bLtU+p8ab55/Q+Dr1/xZeRhTbXdW5qBQBhTKlZ8ZcFD5BknL4JjlRrh+vugXxzyFRpf9UIhcbazkWhlon5RcQfVt/0OdAfHvnVmmOGNcK0CWl+Q/jB/ZmX8cnlwRLCecToJg+yemgSpTv31WM9T/IHFtE4xmW7S7/17CAgev1aWKJIbb3t7B5Hj1AE1a3glLFQ1tJ501YBbAJK0oVkg7NBp79+e+OeaTMPYzNIc2I4cllHk/KVS5L5lP0+Nsj+pn9nadtZbYm4w80cIVxEm3ZGzsa53FoHb/IVeOcjQWs7dkP82I/GlFTCFIlKAp1
 vQnNalZT
 sDqKbAb3vTlLd67NIvWBjy9CSRUet215GFU3tMxlRmJqm+EjNRk5P1O5ZroPT4rsWSKFKkEJ9CtcuJWGfGewIG/VtkD56gV3AMypxPBdoP+ixnwHTFXenEzYk8y1Qcut/R6SGKOhysGkwboSrAHmK2YhkrrC2RTzFMeFfjUZ+JakOcO9UsSjGGuy2MJLrpABsPXSrLbbp2Z6BIfD76vyqBGuhh5q6yTSiuiJa/YbWE0f50egUTOqgdwNlTZjDI+Xbxc8Nvb0T+kjr7DADgACL71AWWZyOTCmcDkflc9oaAgRd4XvN3bHGunNfWw==
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
 arch/x86/include/asm/smp.h            |  7 +++++++
 arch/x86/include/asm/tlb.h            | 20 +++++++++++++++++++-
 arch/x86/kernel/paravirt.c            | 16 ++++++++++++++++
 arch/x86/kernel/smpboot.c             |  1 +
 include/asm-generic/tlb.h             | 17 +++++++++++++++++
 mm/mmu_gather.c                       | 15 +++++++++++++++
 7 files changed, 80 insertions(+), 1 deletion(-)

-- 
2.49.0


