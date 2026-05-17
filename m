Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D539CD4F3D
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 21:12:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7483F6B0088; Sun, 17 May 2026 17:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71F736B008C; Sun, 17 May 2026 17:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C366B0092; Sun, 17 May 2026 17:12:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 56D806B0088
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:12:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E3DF160E03
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:12:37 +0000 (UTC)
X-FDA: 84778160754.12.6C96B1D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6DED1A0009
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:12:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=geQeZKjx;
	spf=pass (imf25.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779052355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9iWJAgQi4oKuW2SmCMvd6aV8Dovou08mStee+1kdn5E=;
	b=IsFG+C5CF0qvbtelV7HVDYEAuNWg6kvbwgkp8iOicfEE/2yZrVt3IHvG5sxLQKnv1ym3Kl
	GATovDp1xo5SNauGHab/ohT7JdDZ6ocQCf61mkGOV29Rh6JRuU55ewB4n2d5q+CECE3Ok+
	ycCHBOb42ZkUakbUIiWhLm31LIXPfhk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=geQeZKjx;
	spf=pass (imf25.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779052355; a=rsa-sha256;
	cv=none;
	b=UNQG+tMUP9uJ7c18FsX8eY+zvUYW5Ru7OlbZmJ7kKV3MHMcIAoQN9AsgbWNQrkk8tWSIIg
	i+54q17mRGgTvTYxO2nyeFxLCFIDYWr09XV9MvmVqgpNf27QrOs/v7Lrz/KQxim2I5XYtW
	onTSMVWlqtH/80I6AhYGJhMDFkrVNZc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BC8DA60125;
	Sun, 17 May 2026 21:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486A8C2BCB0;
	Sun, 17 May 2026 21:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779052354;
	bh=lZMt7EeGweQBM8J04DT8IEIlqL67jEh2Cou/ilga+x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=geQeZKjxEjS+TADDQiW3/Hk4Ib4ehBp1PEBUO0IfZ1T9bq8og/X2dB89Bm1k5WrpR
	 Czd0x03WoFAwbR/BB2nE6FNY6PZlzObFQI3cYSwRqipNQA6OJMCKHIsMq9v9Zl31Zb
	 Z4Jlpav0WehlNk3Fj3TIIFav3v4W0EF8O2ez0X5EYr4mSZuTCDB7YHwDtlqtKB+mwB
	 pqSQoPNyTZwQn6wf0w6i2KiStQ9K37NJkQMnV1+FR9G9thZbYQY+b1/sfLxk2Y9A3z
	 ZfJAqvLl8klQZvncSTNcOMZOfGj0cgLoB3bLzLNi5TY4/1huIi0sLWcEtkPGXt5Zj3
	 zXgu+kP27ilVg==
From: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
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
Subject: [PATCH 1/8] mm: Add ptep_try_install() for lockless empty-slot installs
Date: Sun, 17 May 2026 11:12:25 -1000
Message-ID: <20260517211232.1670594-2-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260517211232.1670594-1-tj@kernel.org>
References: <20260517211232.1670594-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6DED1A0009
X-Rspam-User: 
X-Stat-Signature: 8zotrdciykjjst1en39kp7ainxf6an45
X-HE-Tag: 1779052355-319205
X-HE-Meta: U2FsdGVkX19hTVxZWFelCQih2BN8phTWemvFlT4LJjtjeHANPmlnOM3LH9aLwGf2ANEdqSR2q2qdEDqqM9kyP73gqrYnNd/OH/LeT1np3h9Mcnl8UddnhMTL9FvvI5hWD9QwapAuZVO8qYY+6PTAqX5WG+gz01uismqJ8iWv4l52r86tsVsuLfz/sYgXxwWQDWnJSq8y+/BW1ZthME87dNvoEH01w+U83OKaGzscrTzm73CPkyj3+dmybbdTLtqsRPaR7BBIKvYHg/oDqMJLSAchvv3Bwkv9VT5RdWdn5r7n6oIfvQi4X1N4pSbfRYbhx8XYVnstekE1QH2wHngU/6XIFmN2cFPSwLILlv2dEv8SIHMSjvs3MhwT3AQ/hIvQ3KPZHC+hVRS9uhQ/cpav0AgRcoyB5xsoCtzD2xuLxfNDCIiJis39guWrvpifF2a8Tkg2eADc23J1skDwu2oDC8cZySgyfKAQNQH14U3xygIr7C9z95svKpcI9nDxSgw1zvkLWITvfe0KzL1gq5g0x8o5L41980gMt9yj1waQzHf7+/xiGHO66AHk/YFTNbuZKJfKTUnlsaJGAh9Pw2sfO/lIMnJRiKczodef/twTjbAdr3JcJGrad6DnqyWfzAKBUsxk7X77BRszuvuVcXIm2RMe5aXAEKpHteOdBwfA4eUAXQRUi3YmwNhfv33LOK+0ppA0Q/B4pudjWhGKG/nEGDBFp094DY01iJaOG14VnfjEavUkVEGJqGikP8d1ePsK9mptzvQ8+fvREgIhbp2MKez6ZrmrFe0b+MzMfdCLnHso+cVzyBUtRpMQ5mfnsqknHF8ZaxyPZHX0WqUJ5QPwm7FnlyjRWqlS7X8A1rP6IsxVXi6YMO64ombqwK14JDlY1JB6wNBYG7hpje9sG33dIbp5kNLkbuE8ABbN3/aczBOMUoq7HorJGb8sNqOqEjrH2sl2h5ibGEbBqu73Dw6
 8PzlfiSB
 VHbMjgcZMVWZm7DQm1joaJ9b7e0Lc2UC4nd8mzbmvhjBa0q8RqKjxQu8Ae+eQMAtuFWgewGiA+lt+piCwdkXirThHNax1Y8V+aNAJOxkuV4V/qDdxFUsqLWYfnImMluEch+O3LWZ2U3E8jI75yOp5gzcIVMJhTCuOAG8W9tLrBe2Hf7xETHf3D4sSaxOl3FaiZcCmUzQY4vL97+tn4EUNNZUPLPZUfh5rdTiCfKGlkcthtTQYBiVSzEoaL2uN1CETMnCYjZo0us+VnGC5L2NO5Pxizy68wgJTkEm/UOZraWHkCfM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add ptep_try_install(ptep, new_pte): atomically set *ptep to new_pte
iff it is currently pte_none(). Returns true on success, false if the
slot was already populated or the arch has no implementation.

The intended caller is the upcoming bpf_arena kernel-side fault
recovery path. The install runs from a page fault and may have to
contend with locks already held by the faulting kernel caller, so
keeping it lock-free via cmpxchg is the safe choice.

The generic version in <linux/pgtable.h> returns false. x86 and arm64
override with try_cmpxchg-based implementations on the underlying
pteval. Other architectures get the false stub - the callers there
already fall through to oops.

Suggested-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/arm64/include/asm/pgtable.h |  8 ++++++++
 arch/x86/include/asm/pgtable.h   |  8 ++++++++
 include/linux/pgtable.h          | 16 ++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 9029b81ccbe8..eb1dd59aaea3 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1830,6 +1830,14 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 	return __ptep_get_and_clear(mm, addr, ptep);
 }
 
+#define __HAVE_ARCH_PTEP_TRY_INSTALL
+static inline bool ptep_try_install(pte_t *ptep, pte_t new_pte)
+{
+	pteval_t old = 0;
+
+	return try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte));
+}
+
 #define test_and_clear_young_ptes test_and_clear_young_ptes
 static inline bool test_and_clear_young_ptes(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep, unsigned int nr)
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 13e3e9a054cb..afff54a77ffd 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1284,6 +1284,14 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm,
 	} while (!try_cmpxchg((long *)&ptep->pte, (long *)&old_pte, *(long *)&new_pte));
 }
 
+#define __HAVE_ARCH_PTEP_TRY_INSTALL
+static inline bool ptep_try_install(pte_t *ptep, pte_t new_pte)
+{
+	pte_t old_pte = __pte(0);
+
+	return try_cmpxchg((long *)&ptep->pte, (long *)&old_pte, *(long *)&new_pte);
+}
+
 #define flush_tlb_fix_spurious_fault(vma, address, ptep) do { } while (0)
 
 #define  __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index cdd68ed3ae1a..60a4afdc9131 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1036,6 +1036,22 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addres
 }
 #endif
 
+#ifndef __HAVE_ARCH_PTEP_TRY_INSTALL
+/**
+ * ptep_try_install - atomically install an empty PTE
+ * @ptep: page table entry
+ * @new_pte: value to install
+ *
+ * Atomically set *@ptep to @new_pte iff *@ptep is pte_none(). Return
+ * true on success. Architectures opt in by providing a cmpxchg-based
+ * override. The generic stub returns false.
+ */
+static inline bool ptep_try_install(pte_t *ptep, pte_t new_pte)
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


