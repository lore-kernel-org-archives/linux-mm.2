Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F7B5FD3775
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C21D86B00BE; Wed, 25 Feb 2026 11:34:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE2E56B00BF; Wed, 25 Feb 2026 11:34:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEE626B00C0; Wed, 25 Feb 2026 11:34:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9062D6B00BE
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:34:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B51F140523
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:41 +0000 (UTC)
X-FDA: 84483527562.08.7A1861A
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6023B18000D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1wgtw+JD;
	spf=pass (imf16.hostedemail.com: domain of 3nSSfaQgKCLYfWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3nSSfaQgKCLYfWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VrqRFYhB7q55kvKhGXyA9CpUY7G4mfRc8hK/Uh4Zfu0=;
	b=l35kBDq//vp+khuyMyH7Mi1jg8rwpG3JhU9ccjYwO93w9nwE29y9tkyA0JYmM4w/o4Y4CQ
	/krmI0A8MrNLNvn0xQV4kgfISZ7kL4ulnjD4I16R2ucZo3oMFm9jJxO3nVlhH2uliYPrVv
	mQ214qaUUdTvwgp9SbQGiITO6HqxgrA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037279; a=rsa-sha256;
	cv=none;
	b=45BfRiY2tKI/sjVpYLaZ4GzED9imy2c7N606jT+Fk3oQcL2Cp4Z3dxQT6MNfBGrEnPQL96
	Pj42AKjzeoZRuMrWvZxeoeoU2XU9+KJdnN+jLeJiU3uU+nf+K7zNuoJklnB/fjylhNNOB8
	0l4Cl6REvux3OnYPD5FwDzxbmijual4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1wgtw+JD;
	spf=pass (imf16.hostedemail.com: domain of 3nSSfaQgKCLYfWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3nSSfaQgKCLYfWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b8f5bce308dso693174666b.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037278; x=1772642078; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VrqRFYhB7q55kvKhGXyA9CpUY7G4mfRc8hK/Uh4Zfu0=;
        b=1wgtw+JD5ffuxFHqy55hlkVkB4UaC9iAt66hwVhz9fqCfVKqN5JijuQpzMAcTwPWBl
         LxEXxfNYbctSyB8LfbNyMPETFy3T7E3gW9iSeJq1GkTZnh/6S/x48lrf0BtgvDST41u7
         m3caPRZBp4b8UHdlY204ubl2SoPzc7zikms6IKPAmPLzTVZPRu86JLlu8iVK6hSAUKGZ
         YyeEeAQVs0DUUd0yaerAmAF4HQ+pVQcpPelJ24ztCORh/tRt0cR83MXltnigooCsh5u+
         aQRsVZZpxxAypusB8MMRbnRnvcMxOU62ejoIc4qV14JGv1n7yVf5a8TMQikccz2zKL5T
         gDIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037278; x=1772642078;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VrqRFYhB7q55kvKhGXyA9CpUY7G4mfRc8hK/Uh4Zfu0=;
        b=Ygn25F8VFVMt08Lob6X7p21X3Bk7uCZV3UQKuad0hEn5HlOTpNP519489lol7LZbe7
         LV+mF3ebgWpumHqSgwy5EKVkYr3CSDA3yZCxXd6ui6+W++lWo5RcUlkUTnISCo/d0GYg
         Ve9Ch7YIjwC6ZoX5/VWGnV0ODCSmYHSorOZDoBmx4OeBqHeIOieOQMQoRntWWWUuV2TF
         Ql9kb8J6YIqwIE3Yw1Wl7mHkTUabNVESVRhzM4vItz1ci54/Hkmnl+ITdZ4S7ZS5VAt2
         uAowlOZt+moyzshrJeYG5+BM80SGjl/nu2NoE/w5HiEhH98BAxdKEdVxyuzz880RLjZ7
         aeSQ==
X-Gm-Message-State: AOJu0YxyYf1tATBa7PV1TFoBn6iwcMq2rlksu6pIJGtFWlQIGKFfUN/V
	8LN+XPfiIrzOKeQLzYVvEcetjVE6ne4AYVR+lAjfx3QOoB7q1Es78+cYTWmp2xOTsyM91TV5esa
	0IjuoCiRjSziDsg==
X-Received: from edge11-n2.prod.google.com ([2002:a05:6402:a54b:20b0:65a:3506:7e8])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3e05:b0:b83:95c8:15d0 with SMTP id a640c23a62f3a-b9081c1880bmr1179838266b.52.1772037277341;
 Wed, 25 Feb 2026 08:34:37 -0800 (PST)
Date: Wed, 25 Feb 2026 16:34:26 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260225-page_alloc-unmapped-v1-1-e8808a03cd66@google.com>
Subject: [PATCH RFC 01/19] x86/mm: split out preallocate_sub_pgd()
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: 7x6bg1kcpyjgr36j38ufxnsrtgp665po
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6023B18000D
X-HE-Tag: 1772037279-308230
X-HE-Meta: U2FsdGVkX18kQSYiMs2PlBRVuABxbKSqunshOd7HQYDZTcLUP71dZlfPXnmI85qoBF9Tg5gOml2vCW5Xu9qeC5Bd5hkUP0JS8Q1Az9q1k2bqs0+Lpv2NWh9cWzzmZ5K4mRVkzO24gepyoTDcRcDSSdsaCoU2fHN+NrDZTMSKDjpV26Z3bgtw9A7z665QzlB2p6Wwi2DoBDZVXiI+h0mTbYoekn7avXD2Oz/Rc50My0i5mdQraU3SgmEXG46pZEjI9oHzWAxmCzpX7S82mucb8XGSr1nYbgHJCO+AeCXPOOKiPiljab4Na+8ZI58kZriCAEhROby8UN94cfq2pB4ssu0VabXuCMjrimXU/zlOiUOeDUHuE71AY9sYX4BZmpsB66IdhSDe5Wd3/VADlIIZFmooBAHmkXXdhPjIHKJzOe81ovq9gZgIb51dGpuQMcPhRLtSgB91MWFNJLEqzbwerrv+hxU+TX15JRxtmB9fsY83/s7swf2UKmq0mvDt1/LDb/NC9YNZ9pDUoCNgrEpTrN0fwYcYyuRlUZDpEvoNIpm5WsHFfQaoO+FF9LjhGdR4xC6Vg26HxfN1AJ464PlAfQwsUot/dLVFs2d7ejOJlAiy+26Fo9WgYhslHhVj7YgH7cc2awiQfMTy9DD2siurt3cjSRHk/zxUa2xdaV31X+brJ6yxiVrgfzHwlp3Ns83FXYh60lNBN4m4bTjqK0aweoO1lNSVuN5nuM8VVi8d3dKOUWd+7OF7reGVD0zoHVoyT3SKBP4aNBfmvdtiAmZ/4m+63F3JQCh7AU0gv+E4FOCxRgw7IYKD6lorQ8gHEL933w3Apkd5sSH0qMuQ6z7Li6zwgr/PHbLx1sLy24J1zWrpbuY5o9LpaSI2NzfyzodlxQixdzjaXyFuToBZdebq+jqjbERj15kAGBKgJEGcq0uBAFfed84OsNXozMqg1ekYlBwjgsAGWLODkFAd5i/
 lvLexnl6
 T40JesKsAYKBjoz20rwqYbvGGlu/Vu44G5seXwM871bKBj3DGaWbPJ9E3Yckq8Aqk34qr22d/wTllqygvgRe3xk+FTRJJ9IdtsEoo4HaGG1wCkuYdWUnGOJz39kQij1RyJt//XHkdrkBkBxnjJBJtYsT0BlDIPdD9GjkttdHdAicW214/D1zfRC/K3Wm4osRAcDv2MoBVNiFUashXcgcOfY/tYjPYaEJHmC02KaTg6SV3txa2JVmQ6DAc09sB4P4O1Hpykftw0ZY4xNQ/DfmnjKEaxF5OpTlQRD6DfmtwILCN/Sy7GEiI2tjBOGsd3badL1GfW6eeCDRo3x9iox2DruaqPaJ2pzw4735UK/ZXPwyt5yTLlBG0A8PhRo5Ggyy7eE4E6JSb1Ein06lbzOCqj9Z6HXFfuvKv2s4k+GMCqIcJDDbBY8vwzWpPB8+7f6e7pRQVt0HQrhAbIq3b++AnMk2gqA38vQqdpiKGs+AeVx+in8ht1LvS7IE1fcsHX/0m1bwvK0Vbmon/9jnMtfuuwy1pj21Jgahsw3KVMogUIbJj6I4IA9I2+Ana+HUmuecxbUyyMAYrIeYUfgIRLc32Atja8Kxtz3jayVwT8iWFg9pGANM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This code will be needed elsewhere in a following patch. Split out the
trivial code move for easy review.

This changes the logging slightly: instead of panic() directly reporting
the level of the failure, there is now a generic panic message which
will be preceded by a separate warn that reports the level of the
failure. This is a simple way to have this helper suit the needs of its
new user as well as the existing one.

Other than logging, no functional change intended.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/include/asm/pgalloc.h | 33 +++++++++++++++++++++++++++++++
 arch/x86/mm/init_64.c          | 44 +++++++-----------------------------------
 2 files changed, 40 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index c88691b15f3c6..3541b86c9c6b0 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_X86_PGALLOC_H
 #define _ASM_X86_PGALLOC_H
 
+#include <linux/printk.h>
 #include <linux/threads.h>
 #include <linux/mm.h>		/* for struct page */
 #include <linux/pagemap.h>
@@ -128,6 +129,38 @@ static inline void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud,
 	___pud_free_tlb(tlb, pud);
 }
 
+/* Allocate a pagetable pointed to by the top hardware level. */
+static inline int preallocate_sub_pgd(struct mm_struct *mm, unsigned long addr)
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
+
 #if CONFIG_PGTABLE_LEVELS > 4
 static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, p4d_t *p4d)
 {
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index df2261fa4f985..79806386dc42f 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1318,46 +1318,16 @@ static void __init register_page_bootmem_info(void)
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

-- 
2.51.2


