Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7355BC53209
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 760996B0098; Sun, 26 Jul 2026 18:23:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718766B0099; Sun, 26 Jul 2026 18:23:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64DAE6B0099; Sun, 26 Jul 2026 18:23:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BE976B0096
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31A971405CB
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:31 +0000 (UTC)
X-FDA: 85032355422.01.B7F0682
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9541920006
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L0y89ksw;
	spf=pass (imf31.hostedemail.com: domain of 34IhmaggKCOUQHJRTHUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jackmanb.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=34IhmaggKCOUQHJRTHUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x15ix7IWz4pwvtzNVrQxDVQH1foHe0j7v2jOQv7JDzE=;
	b=esVHsPNrHm0bi53VyuXrZdSU1NDfMQHnZlTE8NN3QsO1pi7asm+bd+F4Z9ZyU/T4uU0zFc
	hz60Lo3276rc6G58J4fLjvUgmHd2yIil+2en/5wrS4s/fBZ88el0UC8g8NX+/A7owuutK8
	cgGydA78XRE0Ol8Kgg+Ieb2X0Ac0BfQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L0y89ksw;
	spf=pass (imf31.hostedemail.com: domain of 34IhmaggKCOUQHJRTHUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jackmanb.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=34IhmaggKCOUQHJRTHUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104609;
	b=Q29Rp3rJMLWn8tadPu+w7F6N37J///LD/yRmq7wd4ItOIzvW6cVq/oL6VHqRwuFPFZQa4A
	MW+UU+1GZDTBV0m+RkRiCaKxd8xvA15ywEwushdGOe4B0MjYZXqt5Q6Rwj3UUTfBu+Tk0S
	N63srwprSsN59qoN/NaylcqTriSe8Bo=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4955fd77c18so13907025e9.2
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104608; x=1785709408; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x15ix7IWz4pwvtzNVrQxDVQH1foHe0j7v2jOQv7JDzE=;
        b=L0y89kswGq7SB/H5TFLJqEfYIlEPEtq+CosxGiAp2d1J0fZbdNulnpiPUYbiX1jORh
         dQdgEye2DATcJD288e2bR5g5gUrJo2EMC6mpZ/w/xmqMuL5SiBt5gF3om10bBbyD/r0b
         2QHNnWHa2T4kAJmEZxkrKkBG5mAG+IKNWXwBCeaNx7AoVugVOFtG3Rk5RG9vChdRzMTB
         lETBQxTkfyxmAdPSnb1XOjhWqBbE5yQ1H6KLqsFYDX86o5Kbomokrk75KzJz5XkyvskE
         L/Vy4RqHgjjT9AvCr1d+gT+CxDN9BQuX0FNElDirhJdHlegKb361I2rKaLNiukja2S5M
         3WxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104608; x=1785709408;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x15ix7IWz4pwvtzNVrQxDVQH1foHe0j7v2jOQv7JDzE=;
        b=QAMR0wbH7P6dcu5Qi4T1vSzOKG6SpT2vEOZ05RyscXfuBosHSRsY1wiz5G5/oQsnps
         ZPl8YG0f/nu4fLduP4kSUuR/XveksC7gIXavECvgfuI3R8OI8kPwTCXMyitoG9Umjowe
         WTmdLTE0aNKI3qYY79ICKsTe+iuMHA/nqSzS1pw4sQ87HhCHRG5XTFDBtPFa9UzWo3rg
         eywZm6/kt2WYAsRAA+vobdVVaNqCC4xxarrLl0CZfqRZf3CrNbGOV/pQLINO/bGt1G16
         8nzCh5KMNhhBGCmtgu93oIP0ER7ohEndap5umEKmrakO7wT571fNF5IKfPorR8mGAc4y
         WywQ==
X-Gm-Message-State: AOJu0YxbTVbP9Wdpc8MZvppWDEE5QwZUPQXZYNRXGU8zDedNRshOmDXn
	sWWgcbrJCbXAFJvcB57rqgwRR6XVLw22epAd2PYAmhzJRQ0C6NmowwZOc/BMU2At951TplUu5BC
	N1cE9VTBApNKSMA==
X-Received: from wmlv23.prod.google.com ([2002:a05:600c:2157:b0:495:5890:8f69])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6296:b0:494:282:106c with SMTP id 5b1f17b1804b1-496b56fb438mr72282275e9.16.1785104608079;
 Sun, 26 Jul 2026 15:23:28 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:38 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-5-6f5729aa9832@google.com>
Subject: [PATCH v3 05/26] x86: move PAE PMD preallocation defines to header
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9541920006
X-Stat-Signature: z348bj4ohz41ri5ueaanpuse8jjp9hew
X-HE-Tag: 1785104609-562106
X-HE-Meta: U2FsdGVkX1/ZdMfhT5X0c76NQbPtmHBcJguQZHgrjPFNkN0Pg4h1XjTrV05v989omrsuYSKAMBADZrYnkqc4VkKDjoeOiFeGNXC0nYAYNQveVUatgq60JeY3iyUTadKA3Gr5n8TDNmwaEM6vl6obQKd7JPqtlZ4KoY7nA/kkDB3GAP2anL6fBA+c981O9NCCRK0V0phZ+UzvW5kkJZNS0hUlllFjEf/yDVkkCk2X3cCaYnwjGmBVx7V8IS81hiPR09FmJW+VRDCf5OnzdAZ1VH7zlQAKzlqzw19QHXPP/0n89cL0NufodfhSqbw7b06lqGxCLL9kaveIlQw6qyS3F7zAk3N8DL5w77Q9+bao5FQJDqwQcrpBmHleqRXWjLuog2UnhFCsyYCaAfjHPWbjzPLHtyRSDYUAI4rvzXyfO2oiYDPXMxnyW2SHKfXdgJOV7Ml2o35dn258v1WyANUZLXH6PZ1I+1lqUWZ/6wDKodbOE1ZahZoIxQCoaHdfECG537DgaJw4LUdh7VUsWHIXSB2unfW+paVc0H1NdNogZv7wcZ9bQKS1OePH5qsTS5mvWOQkRKibTTqwwum4dp5ZAuwLfAQBRKzTzkCNKT5s0xRVmd893z+MOfx8z68V7pxFgjvF/Qe95DMshGTKJtpBZzS5AA+nX6u/xvaWkq+4s/Ib4zPLcSXCuc+YvPLMJBi7CnaQOQaZRwz0S2dzhush2xk4vaxY+xQuUSof5KVtgsMEdFGPYTOxuOdEuyAVUvLbduQQw7CUJ3SBzp4dqyLRkkmblQxAiFdk6HcPYIhmuAjTEb71rVHpt/+omZTSiYGd7NYiHJ5iS6NVnD3Nw2Xw0S9rlpJdkAifwSrsETR/LoceznLbfyYPo/YAusrC9p0lVzOf5Shv0gfte2BdKXegruiVRWCUjXRHCCChlILMos2VtxXp9P6PMqdOhl4Lk0Iy1xNnP6tEioxjzM5d4yB
 WKAeBFae
 CEHBiZbVoT4wd7jkvWe1m1Qq1WFiBEDNXLrO8AkL5g6CsBg5hJLUc9ulx83IwOGcoR7WvIUwHKHutMSPXx+Rcrpc7TrbgFbUWJ2JRRE8ofaxNfz/WNZp8F2bnxy/rbLA6EABYTZTw423vaIuVoxVe0vYvuDEhCw2thY5d9yTRDVQQU8HeXy3pNL7S+QtfIeawIehooWKQ6+ajezZM/RBjYjrHV13wfD6GhFhi4CVRzp7e/4fLSmE+uHB0r5AXqjS5/apLYlQqCKDCkDmsF/yFw7EXF417jpIodKr3ztI8lD3AgULty3oK46vEJ8yT4zyXX3kcwDkOxU36A3Uu0mpjaztS96tzw2VLbs29Imhw0H9VCB6FHMnm7QhI6tBf6B/CMHfXbpVBrgqy17tj3QGorkQMW91WJ/LBFMHVhLq6jT7Tx37KJTf16HJaXzL7f14NpDCMykUsAfH5VMhWngB7gTHXV4AevJyUbdZHFisKs4ZQvKv5yFSE5moKJ6nVPlK0TvQEN6sanPqM+lQaEXb+IcqyXnqj8GZsyfzcHDXn7a3SqevsopxZ5swie42JNrfQGq9UyBRL4EYOhwjxJeRiaagn8DCb5rZVDLop
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In a subsequent patch these defines will need to be referenced from a new
file, move them as a separate patch for easy review.

The comments have style violations (personal pronouns etc), do not fix
them as this is just code movement.

No functional change intended.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/include/asm/page.h | 32 ++++++++++++++++++++++++++++++++
 arch/x86/mm/pgtable.c       | 29 -----------------------------
 2 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 416dc88e35c15..4de4715c3b40f 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -78,6 +78,38 @@ static __always_inline u64 __is_canonical_address(u64 vaddr, u8 vaddr_bits)
 	return __canonical_address(vaddr, vaddr_bits) == vaddr;
 }
 
+#ifdef CONFIG_X86_PAE
+
+/*
+ * In PAE mode, we need to do a cr3 reload (=tlb flush) when
+ * updating the top-level pagetable entries to guarantee the
+ * processor notices the update.  Since this is expensive, and
+ * all 4 top-level entries are used almost immediately in a
+ * new process's life, we just pre-populate them here.
+ */
+#define PREALLOCATED_PMDS	PTRS_PER_PGD
+/*
+ * "USER_PMDS" are the PMDs for the user copy of the page tables when
+ * PTI is enabled. They do not exist when PTI is disabled.  Note that
+ * this is distinct from the user _portion_ of the kernel page tables
+ * which always exists.
+ *
+ * We allocate separate PMDs for the kernel part of the user page-table
+ * when PTI is enabled. We need them to map the per-process LDT into the
+ * user-space page-table.
+ */
+#define PREALLOCATED_USER_PMDS (boot_cpu_has(X86_FEATURE_PTI) ? KERNEL_PGD_PTRS : 0)
+#define MAX_PREALLOCATED_USER_PMDS KERNEL_PGD_PTRS
+
+#else  /* !CONFIG_X86_PAE */
+
+/* No need to prepopulate any pagetable entries in non-PAE modes. */
+#define PREALLOCATED_PMDS	0
+#define PREALLOCATED_USER_PMDS	0
+#define MAX_PREALLOCATED_USER_PMDS 0
+
+#endif	/* CONFIG_X86_PAE */
+
 #endif	/* __ASSEMBLER__ */
 
 #include <asm-generic/memory_model.h>
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index fdd3709509946..8f3505b1eefec 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -100,29 +100,6 @@ static void pgd_dtor(pgd_t *pgd)
 }
 
 #ifdef CONFIG_X86_PAE
-/*
- * In PAE mode, we need to do a cr3 reload (=tlb flush) when
- * updating the top-level pagetable entries to guarantee the
- * processor notices the update.  Since this is expensive, and
- * all 4 top-level entries are used almost immediately in a
- * new process's life, we just pre-populate them here.
- */
-#define PREALLOCATED_PMDS	PTRS_PER_PGD
-
-/*
- * "USER_PMDS" are the PMDs for the user copy of the page tables when
- * PTI is enabled. They do not exist when PTI is disabled.  Note that
- * this is distinct from the user _portion_ of the kernel page tables
- * which always exists.
- *
- * We allocate separate PMDs for the kernel part of the user page-table
- * when PTI is enabled. We need them to map the per-process LDT into the
- * user-space page-table.
- */
-#define PREALLOCATED_USER_PMDS	 (boot_cpu_has(X86_FEATURE_PTI) ? \
-					KERNEL_PGD_PTRS : 0)
-#define MAX_PREALLOCATED_USER_PMDS KERNEL_PGD_PTRS
-
 void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd)
 {
 	paravirt_alloc_pmd(mm, __pa(pmd) >> PAGE_SHIFT);
@@ -139,12 +116,6 @@ void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd)
 	 */
 	flush_tlb_mm(mm);
 }
-#else  /* !CONFIG_X86_PAE */
-
-/* No need to prepopulate any pagetable entries in non-PAE modes. */
-#define PREALLOCATED_PMDS	0
-#define PREALLOCATED_USER_PMDS	 0
-#define MAX_PREALLOCATED_USER_PMDS 0
 #endif	/* CONFIG_X86_PAE */
 
 static void free_pmds(struct mm_struct *mm, pmd_t *pmds[], int count)

-- 
2.54.0


