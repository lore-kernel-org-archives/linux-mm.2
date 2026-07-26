Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD3A8C53209
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D97A6B0095; Sun, 26 Jul 2026 18:23:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58AF16B0096; Sun, 26 Jul 2026 18:23:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7616B0098; Sun, 26 Jul 2026 18:23:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B0C06B0095
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 96CF2A168C
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:29 +0000 (UTC)
X-FDA: 85032355338.04.E1D408E
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	by imf18.hostedemail.com (Postfix) with ESMTP id F30E11C0010
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pATHm1Q5;
	spf=pass (imf18.hostedemail.com: domain of 33ohmaggKCOMOFHPRFSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jackmanb.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=33ohmaggKCOMOFHPRFSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104608;
	b=5iJVdbEg32t87KrkTFqTMbV5BXuGU/PsCszQgsQDA9a5XrpyS+0vpXLVBwSdPsmcjtu0m4
	RRUTErvfwJBidHWd+7sFvKoR86emNi3vfM+nzQmlGx3IpLhDMgJd+s0OyfBiSLiXtATyLH
	UXFGmCc6cY7FRfxtTbgWdyYXlnRxh+s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pATHm1Q5;
	spf=pass (imf18.hostedemail.com: domain of 33ohmaggKCOMOFHPRFSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jackmanb.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=33ohmaggKCOMOFHPRFSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6BiXc+2inU2lDJU0ldFQE+FFEl2R2e3zkQ3EIvc1jU4=;
	b=YDfjXtgMvPcac50tddd52k83M2R9SdxLoH7Zr2uUB8mg47jYubGgy3e6Ydc+D59y2V2NCR
	RstOgJyo416jcw3yhSM36qZmyAdQXZp/8CvnlkR9A+U8CueZqDLM97e5sW11NO3mT8VuNd
	60QWlMteUEp0K4aaXLwA5VVBNkMrY/Y=
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4954fe32d6eso10040875e9.1
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104607; x=1785709407; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6BiXc+2inU2lDJU0ldFQE+FFEl2R2e3zkQ3EIvc1jU4=;
        b=pATHm1Q5sU01hT70sCUTrRQSmF1FQdr8Ke5QjAEZAskjxi27jQcgQkHHP+GHtHpaga
         oHvabbybvx9BlOWLHLwlMRsa81UqxKrnQQmhp37ZY5IcDR2RkdEiMmZ+U/HgrpAcXHKI
         ClCJSkcVCzjir9SHkqAZEErPpUO+jMLevAnJgOBdfE76TKHayIVg97PM9pk7is29Do1E
         1KJdNoGLvr7bSQYGvUbZqBtaAu2Twch+bR9etqByz/06uLPVbs6yrUCZLpxSk/V9BYhz
         J90CFEHcYNvZU6lbE/BsDswZb2FvoBRxEgkjiqgP89cIcL3A9c1PM1VLnxOESBfeumX6
         xuNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104607; x=1785709407;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6BiXc+2inU2lDJU0ldFQE+FFEl2R2e3zkQ3EIvc1jU4=;
        b=IhFtS7MZKZKlGa/IRYJs673LPSHe8j4z5cffavF0ujNopZSkOY3Wg8r9EWWbA2trCK
         ZfgWKFLfHIDM29qTMrGv1Df2xlc49sZ39R3FyhFrzIm7CI4y7VeB1pGGHsuUJfuCaVvB
         6FfZPLAUGUtkqSX1eV1HoWxAw317YBCxGR8HyJzJPYYm2SQC47JnVBvTuCKYEFiG4MYz
         y+oi4/oDZcOfkrRVLYWRD3Fr/9STOAmg8EFYt8Y4ZJmHyacsvB11j6neK02KV0quNjJt
         earvOTzRYKS/KlmC+3nieC1Xhsym7pob6FaQPtxdBpUBjHe+eL7QR9kJXr9LiP5PDXgu
         xjtA==
X-Gm-Message-State: AOJu0Yy7uGUI8iqZNszrToUigyE7CHVrocg4FcilTk2MGuCGrAUDVu+e
	qCpcW5VzPGEX8wsRu4LHM2qK4gGYxG8FD5sFGa3lApNewJ4C4rqxLceAVQ6y+b+SopT0j/JW3Q+
	RmlUwUDWDSWP+uw==
X-Received: from wmog3.prod.google.com ([2002:a05:600c:3103:b0:495:56f8:8afd])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:35d5:b0:490:e5c1:b8bf with SMTP id 5b1f17b1804b1-496b56f385dmr81438395e9.13.1785104606288;
 Sun, 26 Jul 2026 15:23:26 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:37 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-4-6f5729aa9832@google.com>
Subject: [PATCH v3 04/26] x86/mm: split out preallocate_sub_pgd()
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
X-Stat-Signature: hosb3fsfkny8bxi7oohmtgmoqpsxrhpx
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F30E11C0010
X-Rspam-User: 
X-HE-Tag: 1785104607-129883
X-HE-Meta: U2FsdGVkX1++RYTeA1O9C1mRhUDHe3q645hHo2AoEFmBMIeUdiT2nVpmDOV34p5qUeLbyGee2X37QN5ivm6WLufmZpU7C2Z6wjaNKP98bkn5InVC1vVoGlIVN2FsVWFWeu7eu79v4Yd6LpMFyNRX8O0AdZj2rvi/1VBBvCjHy93guTX6Twn0pzOz6PDlfTtnIZzgczPqwotfU95D+EMeKGFn/qF3A3QyAceQcmuzr/mtltqzDslyfJyw6dsPUnhBo/OGNVEWEm0AexwImT3B5wM4sLbOFOWygQMl9PwKMmA9McEGxTlO6qQyvVX40duvBPdwgIl0ASgWTT9u3IfMDoPMiXG+blEaTxvXIn2Y6Smp3+y/uBUPVvcNGhbX41Eitkgj3ozz4LFphBCj/wJnhT82tS08kwtl8eTJcGuPO33dr+G7mkV/wMR4rlS4wMgrizGgKrbbJ6COLiXkRAsVFGBvAFtbqlpzHUTF1eo6Lp6brZwARbPhama+uGcPWo5wzK8Vbjn4tzjmorImwelhY9iWUnsvyM33KiMUbASTXOBM3cnDiwKMkuhf/V60FqVVOxcmo/a9rPIbM/3QKiwqoMxuOg2nWaFx2YSjO0WL6e5ejVm7kBXbu+ZnQyoZ3GWpnXRJfP5ZsQOIjjDGbgjifdOkUQVvut4hU1JX3YxbllXBSjSDtcqUHOGBofy8ginXEGqALwp//wZsCq1S6DCn8k9c4ARWt7J+eCctIQOVDdarmy1ovQuY41KRldyB/5Rf7i7r88aMv6enZO1WG6QWFRUFDFCeawUCxvbUAJNnouqPDb0dBIW99Ju7MefBHvCVHmZtlWiO0B9fqNuKPkNhialJNU60S0PDm7jbqldnhcGV14oKT6fySlmTit07GDrpiEBoq8dJ2xaYOVSm01k85qsE1fqQRo8Jg2O6HSmL9PNqTw08SLGes/hMTCC3qbMcV0+1a3V+P1PHVglKQHk
 hMUeJXPS
 BRnn0RSUrAn0X+sGwoLzfKP1At6/yW3OftXGUjQcYekjWeeKHpPbQ1NB6+HKg4iAycVladcAjymFMzrmDfYRz63Syw4gn/q80hIn2Bvb+JTRuF0GAjIVYotSVk8eumBViT2A6N4E5gvLkRGTbN++h1uNAE/oQu2YIHskff9cehgwPWVwc61jZGXvfDj8BMQjsaZocw1LN9X9kn3cojrmeuD+9J2OZiBY6p4NMbGtFTwEnWD+zX65RJ0XKpihhMpbyh5HUgzrFr7rJVYet2t07Px8RcLIABMvPB0fLhIeoW40sajDxYR417epROAnmKn0BCsfAhclpiwnmw/FtXoyfjfxEhOIXldwAABR7LSAz7RLvaErKEhaG3Bckm2WpEYGCh+R9kfUerI0yAargWm2nHJkR+9imb5eKdO/aPJDEf67Ee3LSsL3L/18NkIFmDNFAArx99z73m6HN9MdruXEd+P0aQIKCBot6AxFYMIJJOdoM4TNrIYASBSIEHP/GA20DB/RuMQcmDX6QmlgzbKBoEDtq+nMa2DSSUgtchGycVk6JqOPGwAIb4qrk8Mx2DclnB89q9Zb7kj0X78v2+FQgKhAvWJ8pFnGpaMc5edmVrTWJ9lGW+taLp92YU8rfm8lJovbmScepfMeoUNk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This code will be needed elsewhere in a following patch. Split out the
trivial code move for easy review.

As a side effect, change the logging slightly: instead of directly
reporting the level of the failure in panic(), show a generic panic
message, will be preceded by a separate warn that reports the level of
the failure. This is a simple way to have this helper suit the needs of
its new user as well as the existing one.

Other than logging, no functional change intended.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/include/asm/pgalloc.h |  3 +++
 arch/x86/mm/init_64.c          | 44 +++++++-----------------------------------
 arch/x86/mm/pgtable.c          | 38 ++++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index c88691b15f3c6..2aba6cfabf495 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_X86_PGALLOC_H
 #define _ASM_X86_PGALLOC_H
 
+#include <linux/printk.h>
 #include <linux/threads.h>
 #include <linux/mm.h>		/* for struct page */
 #include <linux/pagemap.h>
@@ -128,6 +129,8 @@ static inline void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud,
 	___pud_free_tlb(tlb, pud);
 }
 
+extern int preallocate_sub_pgd(struct mm_struct *mm, unsigned long addr);
+
 #if CONFIG_PGTABLE_LEVELS > 4
 static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, p4d_t *p4d)
 {
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index ab4c5a02326f7..ac6688c70872e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1293,46 +1293,16 @@ static struct kcore_list kcore_vsyscall;
 static void __init preallocate_vmalloc_pages(void)
 {
 	unsigned long addr;
-	const char *lvl;
 
 	for (addr = VMALLOC_START; addr <= VMEMORY_END; addr = ALIGN(addr + 1, PGDIR_SIZE)) {
-		pgd_t *pgd = pgd_offset_k(addr);
-		p4d_t *p4d;
-		pud_t *pud;
-
-		lvl = "p4d";
-		p4d = p4d_alloc(&init_mm, pgd, addr);
-		if (!p4d)
-			goto failed;
-
-		if (pgtable_l5_enabled())
-			continue;
-
-		/*
-		 * The goal here is to allocate all possibly required
-		 * hardware page tables pointed to by the top hardware
-		 * level.
-		 *
-		 * On 4-level systems, the P4D layer is folded away and
-		 * the above code does no preallocation.  Below, go down
-		 * to the pud _software_ level to ensure the second
-		 * hardware level is allocated on 4-level systems too.
-		 */
-		lvl = "pud";
-		pud = pud_alloc(&init_mm, p4d, addr);
-		if (!pud)
-			goto failed;
+		if (preallocate_sub_pgd(&init_mm, addr)) {
+			/*
+			 * The pages have to be there now or they will be
+			 * missing in process page-tables later.
+			 */
+			panic("Failed to pre-allocate pagetables for vmalloc area\n");
+		}
 	}
-
-	return;
-
-failed:
-
-	/*
-	 * The pages have to be there now or they will be missing in
-	 * process page-tables later.
-	 */
-	panic("Failed to pre-allocate %s pages for vmalloc area\n", lvl);
 }
 
 void __init arch_mm_preinit(void)
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index f32facdb30354..fdd3709509946 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -833,3 +833,41 @@ void arch_check_zapped_pud(struct vm_area_struct *vma, pud_t pud)
 	/* See note in arch_check_zapped_pte() */
 	VM_WARN_ON_ONCE(!(vma->vm_flags & VM_SHADOW_STACK) && pud_shstk(pud));
 }
+
+#if CONFIG_PGTABLE_LEVELS > 3
+/*
+ * Allocate all possibly required hardware page tables pointed to ths
+ * top hardware level. In other words, allocate a p4d on 5-level or a
+ * pud on 4-level.
+ */
+int preallocate_sub_pgd(struct mm_struct *mm, unsigned long addr)
+{
+	const char *lvl;
+	p4d_t *p4d;
+	pud_t *pud;
+
+	lvl = "p4d";
+	p4d = p4d_alloc(mm, pgd_offset_pgd(mm->pgd, addr), addr);
+	if (!p4d)
+		goto failed;
+
+	if (pgtable_l5_enabled())
+		return 0;
+
+	/*
+	 * On 4-level systems, the P4D layer is folded away and
+	 * the above code does no preallocation.  Below, go down
+	 * to the pud _software_ level to ensure the second
+	 * hardware level is allocated on 4-level systems too.
+	 */
+	lvl = "pud";
+	pud = pud_alloc(mm, p4d, addr);
+	if (!pud)
+		goto failed;
+	return 0;
+
+failed:
+	pr_warn_ratelimited("Failed to preallocate %s\n", lvl);
+	return -ENOMEM;
+}
+#endif

-- 
2.54.0


