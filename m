Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 254D4CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 17:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 635436B009B; Thu, 21 May 2026 13:37:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E55A6B009D; Thu, 21 May 2026 13:37:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FB1E6B00A1; Thu, 21 May 2026 13:37:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3DB326B009B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:37:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E30C71C1B2C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:37:45 +0000 (UTC)
X-FDA: 84792134490.14.D8E5C3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7F03B80002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:37:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xosnl8w4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779385064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=OTFgAI5+g/ZgVcx5rn1Gd2C4qroBObowYD4jATuhKq4=;
	b=kNfmQabbfw8ZWGXn8htqYF94bPtwVoXAoaps62Ic26js8FQxDpKLr0ZHyneTrchoPs6Oqc
	yBY2Wh3CpTD1IAWDXkQJsfWUipjFS+V2MrrWNNf9PM8dbzHyiUqcAeQOhQqSNqmJni8Q2z
	IeDDySx87kNJevcYFN6F36eaHOWXVOw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xosnl8w4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779385064; a=rsa-sha256;
	cv=none;
	b=h2qvU8Qbsv8uvnnwTZI6q/ifpuHbZ1V1SvRndmlPLOOd7J0IK6DjmHKlTVVxfZqVdFjK73
	L97bBnkDugE2g30x/Jyt4DBCZV8Gy0G7/YxBKalS8EubyMZnyDXsLXOzDp7IycgZpKQoMR
	MJ72QmDwdd491y0wITJ0WMN7l4YZg9Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D6DC360098;
	Thu, 21 May 2026 17:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9DA1F000E9;
	Thu, 21 May 2026 17:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779385063;
	bh=OTFgAI5+g/ZgVcx5rn1Gd2C4qroBObowYD4jATuhKq4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Xosnl8w4xqyXhUPK/Cb+MISPIwicQwhADito8BUh9dDkvfvpODxD9MTB8u70z+7wl
	 L3kr0hvYwL+Hf+1Sa+M1Q92nT9ciMgpQN2nCC9R956kEB23wmKIjav+lBJZvFMsRB+
	 ts91inVLZgtz7PZbCy4ip5gTktaIlB+m8FpohdSwZyO/S4HUJAEpXfxokKC5aOULBz
	 T+Yzo1MVYw4CPBTfY1CFYnLxpWvmsNxyZdhXmYJNqjG3y6lQFgQYjOLldBZkyhrN9k
	 Ywa8Ht93fLlJ7IYT3N9+mnNAzsYUn7nsBvBonKjBxjjv/T8sMG/95Lev5jvy20+pWB
	 DjjZr5uOA/igg==
Date: Thu, 21 May 2026 07:37:42 -1000
Message-ID: <8dc7b56d0f9ef4ef5b8c41f86ab97f3f@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	sched-ext@lists.linux.dev,
	bpf@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/8] mm: Add ptep_try_set() for lockless empty-slot installs
In-Reply-To: <20260520235052.4180316-2-tj@kernel.org>
References: <20260520235052.4180316-1-tj@kernel.org>
 <20260520235052.4180316-2-tj@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7F03B80002
X-Stat-Signature: i8zbkek5n5xrzx1tk1z6j8kcfkab3brw
X-Rspam-User: 
X-HE-Tag: 1779385064-715854
X-HE-Meta: U2FsdGVkX18Bzvzk0uZTcTnVuEThnYf5aEu5Wq3CsQV9XAbSaeX7wFwvLLr0glZ4lBbnmz4hAoosyabOr+XfTm1FO+AcMiLyUr0ejr+8E+b40sL2bbj0qFNoEXBuyc1C4sVSwz8fuqyGGZr4kY9GzxtIq3KtTjwsWAo941H/3fl3xgOpYEN+SN7xalUDcIeatVuiNzSMs7gKOPa/gzLLqgzKr75oEFwGM4GXnKo5XCVt3enL/CkW0HbohAqLpv04XCrL5gkO4qkXDrPygOadXOns5UiO7UXcBDx6xQokKmT3l5wgqm57yeiJd2jb0NxR7gJBB4nsh2Id9AGsXWt7qGiMDyAGDvgyQNcP1wNe6G1l9A3oWOuy+90M5sOTB9fzFlMavLp1zS0EaJTJEZbMnVMyMz2BUxmbl7L3M4nPi8OQoSs+b+vWdpH81fMRkHwdTnA+4TsXoKerpLbYB655tiR6ph1kvn7sZXFTencwws5sD31bgdzhEPoNL32jMitl+P5Say57EFTGQGQhPJcUPpRwwwBiHs9b+N91585Ma7gmyBsFh0R1C1i6mDDtF6teHD/t5xW8tYZcljX6B+Ed44YsYM3vxq9QP8F9Qo/ZFNJnoDk50/QsTRJNFY/NEQNCJG5oSN6tKIhWYJr+tH68QKHY8XQBOJjNd1wedLK+0tBCwg0Uo6TxKq7wSApe8MgVlhGGpDERwzR+oM46pYsbX2KhmLE8UaNG4OosUPTPG4TubtEvKxUx6kBushR7gBf5ZTpV8VFk2Pnhf15+2aFPc1bALrmKax2Fjh+C83K3aZjyHtlxfIYVfeCeYx+YJe+yZOp40dMWRh+Wesp4mXiW2U+FD0MjHyS1xO1lgU5+OhZPIbD56qrREemlulp2P7yIaEc5SxUKtQQsJAYvWXUBUe0FQzLhP/2wo1VTzxrrxc0sF5jAuY2CTcQ9yag2oaHdz7RdAuU0GhRJKv9Gb7V
 KvDE4kCu
 KnzEzIXynDpE712iZBAtsUMEKjSbmeEd1oOl3vqq699PuNKl/3b87j+evpI6rVFndjnFOwojThpwiB2lIK1dIIPqLNM2Oq4whY+uvUW1UthSucrdJPOz4sgexX8iCJRxVBD4cpsXQJtt3l2to6552PWBtyW+3nf96ZqzSTUYbp50/Eh6VVcB3FfGsl61xWz1F7zcUC7FQUwgN855WDvcCq1vabGIr/8Kdlt4/ct4NuwGuBMDdquOsUPDm5M2zaAmboo0kbpDUiYQpnn552QScr2gIaTiCAYFCF5XOBKEZGvT/t5L8DspuZOHIvztAqBB/Wlrx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add ptep_try_set(ptep, new_pte): atomically set *ptep to new_pte iff it is
currently pte_none(). Returns true on success, false if the slot was already
populated or the arch has no implementation.

The intended caller is the upcoming bpf_arena kernel-side fault recovery
path. The install runs from a page fault that can be nested under locks
held by the faulting kernel caller (e.g. a BPF program holding
raw_res_spin_lock_irqsave on its arena's spinlock), so trylock-and-retry
would A-A deadlock. Lock-free cmpxchg is the only viable option, which
constrains this helper to special kernel page tables where concurrent
writers cooperate via atomic accessors.

The generic version in <linux/pgtable.h> returns false. x86 and arm64
override with try_cmpxchg-based implementations on the underlying pteval.
Other architectures get the false stub - the callers there already fall
through to oops.

v2: Rename to ptep_try_set(). Tighten kerneldoc. (David, Alexei)
v3: Note that strict-zero cmpxchg is narrower than pte_none(). (Andrea)

Suggested-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
---
 arch/arm64/include/asm/pgtable.h |    8 ++++++++
 arch/x86/include/asm/pgtable.h   |   12 ++++++++++++
 include/linux/pgtable.h          |   25 +++++++++++++++++++++++++
 3 files changed, 45 insertions(+)

--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1830,6 +1830,14 @@ static inline pte_t ptep_get_and_clear(s
 	return __ptep_get_and_clear(mm, addr, ptep);
 }
 
+static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
+{
+	pteval_t old = 0;
+
+	return try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte));
+}
+#define ptep_try_set ptep_try_set
+
 #define test_and_clear_young_ptes test_and_clear_young_ptes
 static inline bool test_and_clear_young_ptes(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep, unsigned int nr)
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1284,6 +1284,18 @@ static inline void ptep_set_wrprotect(st
 	} while (!try_cmpxchg((long *)&ptep->pte, (long *)&old_pte, *(long *)&new_pte));
 }
 
+/*
+ * Note: strictly-zero compare is narrower than pte_none(), but the gap is
+ * harmless: _PAGE_DIRTY and _PAGE_ACCESSED aren't set on untouched kernel PTEs.
+ */
+static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
+{
+	pte_t old_pte = __pte(0);
+
+	return try_cmpxchg((long *)&ptep->pte, (long *)&old_pte, *(long *)&new_pte);
+}
+#define ptep_try_set ptep_try_set
+
 #define flush_tlb_fix_spurious_fault(vma, address, ptep) do { } while (0)
 
 #define  __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1036,6 +1036,31 @@ static inline void ptep_set_wrprotect(st
 }
 #endif
 
+#ifndef ptep_try_set
+/**
+ * ptep_try_set - atomically set an empty kernel PTE
+ * @ptep: page table entry
+ * @new_pte: value to install
+ *
+ * Atomically set *@ptep to @new_pte iff *@ptep is pte_none(). Return true on
+ * success, false if the slot was already populated or the arch has no
+ * implementation.
+ *
+ * For special kernel page tables only - never user page tables. The caller must
+ * prevent concurrent teardown of @ptep and must accept that other writers may
+ * race. Concurrent clearers must use ptep_get_and_clear() so racing accesses
+ * agree on the outcome.
+ *
+ * Architectures opt in by providing a cmpxchg-based override and defining
+ * ptep_try_set as an identity macro. The generic stub returns false, which is
+ * correct for callers that fall through to oops on failure.
+ */
+static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
+{
+	return false;
+}
+#endif
+
 #ifndef wrprotect_ptes
 /**
  * wrprotect_ptes - Write-protect PTEs that map consecutive pages of the same

