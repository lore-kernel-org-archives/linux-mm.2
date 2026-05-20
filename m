Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4C49CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 23:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C068A6B00A6; Wed, 20 May 2026 19:50:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E28A6B00A7; Wed, 20 May 2026 19:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85C076B00A8; Wed, 20 May 2026 19:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7622B6B00A6
	for <linux-mm@kvack.org>; Wed, 20 May 2026 19:50:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2BE4DC1B9F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:50:57 +0000 (UTC)
X-FDA: 84789446154.06.904E97A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 97F25A0002
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:50:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jedo725t;
	spf=pass (imf25.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779321055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=56EnKKPGuHgOKsaFa+NBa3ItADAq8xQmgeqKeYpg1Wk=;
	b=f+s4ecX6C6D2OKGSwm6GAc3bpoIPEqNOb2Q79VU0E7oGmZOig8yOu4ve17JTfDINS2M+WD
	/v140Fv40XBieS9e4hFXeKTzWp6RpUSogWYx+Jt5qf6oyR0jJT0ttZa+EB8A19eK9Cxsiz
	cqTM2DdG0qnUjjlqB2tsrbKmE7SQiYc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779321055; a=rsa-sha256;
	cv=none;
	b=YSYU+RcmqAQlOyUhUe26seB9zEBpLqZgH1iSQ+lCxufuK57d8Cx11YBbNaaoGkgBLo7dHh
	PAUu9l1TiDilMZM++PmyOlGtgSuvbmnMs9FBTuPpF47SNDpNyPdDuZsfhw7sx8/xG/wn9X
	YT14fjh8zzLgCD9HrCPHPLe7c+i2+Xc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jedo725t;
	spf=pass (imf25.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 03D17601E8;
	Wed, 20 May 2026 23:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A711F00A39;
	Wed, 20 May 2026 23:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779321054;
	bh=56EnKKPGuHgOKsaFa+NBa3ItADAq8xQmgeqKeYpg1Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jedo725tD9w9fyUlX7zQezS2ZSB3n+ZskPz+3Mb+FqMvFd/PIMwjl0If6Ax77QebN
	 ZT1wI3EVdktpOXzIPN5XXXl2zjXZ8Tau6DCWzkuGjPVby/qTofpt6Uu3rb7GdgU9x2
	 cmk51IRwSCvfi4soFAHWNCEqOqrAWcTlmzBUuY/wnuQN1vhABrYEAtApAjj19H/exp
	 4/ns2SP3KAnc+hYhP41YXcSXpMjCk8lpLcs8t1YSJivJkjtiqwrBlhRvNEnGMMKXyN
	 +3pF3iJn7jj6jt+fwnlzjY9U6N+pDznUJfr7K4M16E6a0Kud7AjC7jM9s+c3T6PweM
	 agyfd4ziUn0Xw==
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
	linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/8] mm: Add ptep_try_set() for lockless empty-slot installs
Date: Wed, 20 May 2026 13:50:45 -1000
Message-ID: <20260520235052.4180316-2-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520235052.4180316-1-tj@kernel.org>
References: <20260520235052.4180316-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 97F25A0002
X-Stat-Signature: xmuce7idq99skp84u5uy5dappxeo59mz
X-Rspamd-Server: rspam06
X-HE-Tag: 1779321055-513919
X-HE-Meta: U2FsdGVkX186yrJX89H8ouFNjMy9nB0gZvrGoknNdAtjYiC80beE1hPwRVdPmhCE2d8uMHafQIERzUtCeBa09AR1SncYYLuj4pkBpAdMLoTx26fbTRDHshOa98AiiNnRL6SgM6u0Bo8fsn57YXZbitBWPiQRMsDJG1wGiOeez0CWcTVKL/kxQ4CGdLKbpOiT7iGm8lInZz7y0Hf2KvO8WYpq5IYWdtgVp2k5GygkCT4eKvz2GPII9WX3kzXUk2yVy66E5v2Orb/ayvDh3p4rprQ/SsX6SzEiMmYgZ9UGnnUQ5c3bn+2mfREqxpdKzrpZy1oQ725fpd3uMOvlW9uG8vU0diolXENF3Zrau1W8AxdjpkgSyrGjCYAtB4I+mi4dLtkx5fJMc3ICjIszIhhkEJmvcAAIh7TGltl5oGlQIb6bBDLglgzTJ/rcDZ335VSx4Y6kfcyoVWLEmRBFj9H707huUagzDbjRnbaHuBq39+ksYSyNvqe41viIjR91UfkxSp2omvixP6Q0d9L8lq78zRZNl1d1IswakquYAWZhjO7haFhWvANh+U/kXhFYSlt+A7mukOwuLj10iUBZAe4C7HalhdxM35/Ntayl5GNU4gm1iLLKbHeAZNY6NXsyxRcyf0qxZqIkEs2e3RUoRtHcxkVRxJ1rzcZuc4Lpfx2Lsbu/m6TXw0MIrDNZZSypVW1oATnVTyJpkJX0lg4v87wTMlfgemgusqM6VTXaULCIbTnYJ+P9JyzXvZo6bGmCiM2WixbByfU9sfR7qErCnqKcIrXKEULEs0iObM8ETJLAeidrpnQG6tO4z+GwnEBviPL+mvcFHsPqdHTg6EwPt/UAOehb1ikNpNcMFi3Je2bM8j5B1Plg9Lln3NQIKSMvTy1GkJnH/r857hQxnvexu0lHQck0EcdiHcBsqoayki/F8btWOHbVOCvE/SnlJfCjnibwcogO0Q2Dca5RiK1sUOF
 4srrpe+x
 2xLNHN9hiRLjeRPlaUVTL04zc7xq6SJIz+NHGlSh2R2n+Nwu0K4EzdeLH5vwnhaLkDY0iYYJW8RkDzUJA7tZlGwJdRFZxWgk8hTi5PU+cYNRPPOuPInHJbH3xARy83FyNsrO6QEmyrp+lCL/oAdE/hY+r7LDXI7Kj3hYRVKtBtL2S/UpwwNGR90rJekiyJumEG31U2VuPPeA6GizqJ/U1AaAD9HU/eSNjaEz0fg5jrbhmlwFxvsBzm9jI7/PMsBHMnB9L9UtZlDjB6SyP0RErP/2m9zivPnVsFk4fdXy9kisPyu8=
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

v2: Rename to ptep_try_set(). Tighten kerneldoc for kernel-PTE use.
    (David, Alexei)

Suggested-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
---
 arch/arm64/include/asm/pgtable.h |  8 ++++++++
 arch/x86/include/asm/pgtable.h   |  8 ++++++++
 include/linux/pgtable.h          | 26 ++++++++++++++++++++++++++
 3 files changed, 42 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 9029b81ccbe8..a129be91ef2c 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1830,6 +1830,14 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
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
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 13e3e9a054cb..047e273a4eab 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1284,6 +1284,14 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm,
 	} while (!try_cmpxchg((long *)&ptep->pte, (long *)&old_pte, *(long *)&new_pte));
 }
 
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
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index cdd68ed3ae1a..d68374f404c1 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1036,6 +1036,32 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addres
 }
 #endif
 
+#ifndef ptep_try_set
+/**
+ * ptep_try_set - atomically set an empty kernel PTE
+ * @ptep: page table entry
+ * @new_pte: value to install
+ *
+ * Atomically set *@ptep to @new_pte iff *@ptep is pte_none(). Return
+ * true on success, false if the slot was already populated or the
+ * arch has no implementation.
+ *
+ * For special kernel page tables only - never user page tables. The
+ * caller must prevent concurrent teardown of @ptep and must accept
+ * that other writers may race. Concurrent clearers must use
+ * ptep_get_and_clear() so racing accesses agree on the outcome.
+ *
+ * Architectures opt in by providing a cmpxchg-based override and
+ * defining ptep_try_set as an identity macro. The generic stub
+ * returns false, which is correct for callers that fall through to
+ * oops on failure.
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
-- 
2.54.0


