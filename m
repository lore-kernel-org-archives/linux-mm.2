Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5695CD6E51
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69BDB6B00CB; Fri, 29 May 2026 11:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 673CD6B00CD; Fri, 29 May 2026 11:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562D06B00CE; Fri, 29 May 2026 11:02:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31F0A6B00CB
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:02:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B6341A011E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:35 +0000 (UTC)
X-FDA: 84820773870.01.B994365
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id 19033100016
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hWp+sG4t;
	spf=pass (imf14.hostedemail.com: domain of 3hqoZaggKCJk3K64+9BM9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ardb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3hqoZaggKCJk3K64+9BM9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ic2DGsrtEHhUHaDXXEd0q4Y8zWmRk/iCag+la1hIg4=;
	b=yJCh8UXYid3uL3eE++XEFKpL0bD4kTOS+Sp6PsLrwgg0nA4zWOsZYH4I2Dh5Udrz85Ck83
	O7nLpG8t9qTeYtPMdc2euGGGcOh+h8VUq5HAOEQuzQqwuTnLraobQnOUIZHlU/UHmgf1SY
	6rcO/2e2F2XxgvytpCOmCt044cMpmOI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hWp+sG4t;
	spf=pass (imf14.hostedemail.com: domain of 3hqoZaggKCJk3K64+9BM9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ardb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3hqoZaggKCJk3K64+9BM9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066953; a=rsa-sha256;
	cv=none;
	b=y5As6+lWbsnhM2j3PwMR7PFV9f4icUVaTo96MdFv/HaLNbmBFPYK+qYB2enqsEmoRVaagP
	rXZozOdGKsma7E4aCML+Ps0iVHz9H/KsZIzKMVdCLz8M7OLo+svYUtok/z7v7s9SY4oZYd
	9oqOHOAmglbFH4bI3D+dGNaoZYLtBcQ=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-bd2a8eb9281so218494666b.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780066952; x=1780671752; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5ic2DGsrtEHhUHaDXXEd0q4Y8zWmRk/iCag+la1hIg4=;
        b=hWp+sG4tt8bnxdBHNtIjSvizEqWsqoTgvFbwhbLTEXKMfy2ZEmTfo+fSr0nG6NSXJG
         FX7ZkN6YF1V0TEusDfB1F4/38d92W+WPDag+sQvV1f5fVvk1flOgyuY3/LSurQ3sjIld
         o+hDMfnbAEQ1nEI7qiFGNeCOFWcRxtgr1WRPjDAWXzLT5NjkTIv0ZLSfsXXZJXiWJxjR
         CYedpUzauMkUumPudwiLQu5SeGfbreKSd3Xt0aXmzQZiY3Ij4YQMzPkxbOQNdPSjFykG
         CGbCbIjl5oWQ6Bjdtmuz+mYxypS6tPVSjFo6u34wJDVX8nEsnisRRVrSOZRTGrCBpEeG
         AhUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780066952; x=1780671752;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5ic2DGsrtEHhUHaDXXEd0q4Y8zWmRk/iCag+la1hIg4=;
        b=ZHv01L3eMtvgrn7LGMe7iZPtJNppbe8hUHvuw+gL/d8AkEvOLGUXjoT/k9hRhVvunW
         usiwV5xV5aOQaGPt6nAwrytl0WfkHNKXFNFeKM9M7Uv/Q143LmcDa4FDTuIekGExGcb+
         XlGp/hBcOO5jHkXBhzc/xYcHA4hWwueaydQcr7uI+J52NHAGCvD42tpPM+GdhPZ3Vd6B
         r3IKFAATmMF8VRBakYUE1fAacMT6ru4LrrpZHdowQEKGE8mPQEycPL/89Vn3JyQOlgtC
         tMoeCTNPSHFHl61V4RMvXyYft2U+f/N9zayNMH8DdbvUPv2Gg2b6yYaJjkb7dU/Z0I8y
         4VKw==
X-Forwarded-Encrypted: i=1; AFNElJ98ZEM3EDTLP//Hmv1HnTASPMBTLLGxER9tobZ/+HuDWVh2tVqmaXwzR1zRxHQNEwWv3worQiVjDQ==@kvack.org
X-Gm-Message-State: AOJu0YxyCoIYQkkruk9X+piEcJe6H1Nf1JkuH6pMKsivLBnTYj6zWJJU
	+Mdt5rYVdoqXxpj+3AXdgiY8vSdcQ/pf3+KLdWadxbVdUd9UFlFBaWNLgGEhrepF8g2VfB0diw=
	=
X-Received: from ejcdp16.prod.google.com ([2002:a17:906:c150:b0:bcc:71b:965d])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:846:b0:bd5:7c2:7622
 with SMTP id a640c23a62f3a-be9cce79583mr206170566b.49.1780066950536; Fri, 29
 May 2026 08:02:30 -0700 (PDT)
Date: Fri, 29 May 2026 17:02:02 +0200
In-Reply-To: <20260529150150.1670604-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260529150150.1670604-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3562; i=ardb@kernel.org;
 h=from:subject; bh=ubRBWkWn2UVZmjj/MlvsEvyHLMfMbEt4k4F760d5eRs=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUtyVY4k535dO+nZFlbOfzzdd/L8Kc16wKgvUGy0L8C+M
 NAkc31HKQuDGBeDrJgii8Dsv+92np4oVes8SxZmDisTyBAGLk4BmMji6YwM9xVOLdQXVDy63md1
 QcOOcqYQ72WntJ6eyrZNi+loev33MsP/3BPHG8Off7zik3rM8U/Y17jQr64tKe5X7+RwlEXo3Rb gAwA=
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260529150150.1670604-28-ardb+git@google.com>
Subject: [PATCH v7 11/15] powerpc/code-patching: Avoid r/w mapping of the zero page
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>, 
	Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ar89whprygqsy5kej1xmdk9wnfin9uyf
X-Rspamd-Queue-Id: 19033100016
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780066952-262286
X-HE-Meta: U2FsdGVkX18QGejLnPHx6sHpQ1w7jPSYqapaJI3SoyJvJ0bzZGo4LsF195OqlYLteJyABzVmluNa8zQ2xahjtKzqqQnB61+CEjDuXl6U1ttyyDUTAM/a+krRpmrcHgQBK7a87BR/Ewc8GLr5b3DeVvd+toXy/WMZr9Ip7waPiTDFLlYuIvpQzY2695iL5Q6tQBGoadNGhs0S6QRWOh6raOKdwGj9k0Sp8EU3omZYq8XZliqjDJmpGXEOp+uI8YeKcuTgkb1V2otWOe88AobcH7fUeBtywMasZTp8+h4xoDjo3Jch1GxPtwKs4O3fcuLz3/jn24Zq4j5lXMkznxDNpC3FG0mYj7A2lXkrSu8ua7NqcwM17lkjJ/HGkiUBI7SXS8VK0lP4brBFMgsDeSaPSPBo3Vijie1rJaLtVd5cHf8nsoU0qNJ0p2fdDB8oDLaIbC1BSuvXKpkIF3YzhQ9czmiug535aXld7BqXvUZalUsHvtKuVgxZXA+lVrrvFgLKKLZhP0Eth6Jtb1T7RqUne7E75IWKLslqqRQkcOC/52lqTrHf4t1yrv4TIeOxTJ2rSsNzHHa0hnb8rq2FEELhuzT0xgicjXE4RaE6GdW6dsE+acu2sPnb4JpMmjM1ttAZx8xt5p/9eTYt57yyJ2ZaglnBpZbnNmsGsQTp8s4AKS7oZ67TE9/DdZvWBxAJ2r4xJDfwMcBzBEB1jC4QhBJwEUjj5EmnBd3XP3zLo+TlFiMKjbgkBtWStTbg2whGF/8l3GWrEv1o8SGdYaUvtunfZYXD75tbGruSXd9EP4m9FwPppS3DlAHOuHYGqxI73EUew0TClfXVvwwBH6abO/InOVZ7LAh5YV1EoZP6Wm9w033eiprWJwpeTG+bT4GkWYPERHxQL5Rd63p8VkblVLlVFPwUWkWz9znV+LQwDTu54VXCarsjYfiuXpcBLId7RKQ5w3gpuwKVR8rR25if3fi
 zj72JqVY
 KV8RLpWQSf4WXesBN5uXACCz8dYnPaVqKGzOQFi2yz4CkJ84mqXHBmKDkY+yvwbrGVbZqpcBuDs00jMoxbyEl4yVd/NsnNMXixkj1xwqtAaYhp+KxpD76unJqBphkwmq3+u3vqU4RrFXEsO3uV+ieJQqEm4bGP5Ma8NARXmTLFDSuAD6YtA7QuGa87e0UF2bPKyLElKq+dXSCvZX3m7/dxOUdosrkYBr5QmrMzt+8xdcXatWPB0p+15fInT0ZsXV0efZxXC1RcKPUO9xI2AhY2Fke2P8X1N0pUW0HFatB+IhLq4fo6A55aGB6bZsO4iVnn+/8Dkwdr2nkYrx7D+qvSyrtuujqJ4v8ciMPfrPdyDYERk+apmNDcheDEePo8lm9wnEfZ4GtR66m8NtitjW5iA1e7Bo6vXStv1OW0k6/yp27emc+2DOaw0fZ0joCWosxTnjKIOD6nGMfmt583zT4qsvW8+RzxafYvFNFpL0DGUR6eznZWTSxvvqLy7PjUUoFnD6CpiLaJ1vjV8VUTDIatE/WHSrw4Hembh2DNhBXXD4nCrs0O1h+HsVWiJ2mi1t3HNPtDcxCc++xFY2m0yVS2mXGYeire5lWSBuaCmoQPccOCBM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

The only remaining use of map_patch_area() is mapping the zero page, and
immediately unmapping it again so that the intermediate page table
levels are all guaranteed to be populated.

The use of the zero page here is completely arbitrary, and not harmful
per se, but currently, it creates a writable mapping, and does so in a
manner that requires that the empty_zero_page[] symbol is not
const-qualified.

Given that this is about to change, and that map_patch_area() now never
maps anything other than the zero page, let's simplify the code and
- remove the helpers and call [un]map_kernel_page() directly
- take the PA of empty_zero_page directly
- create a read-only temporary mapping.

This allows empty_zero_page[] to be repainted as const u8[] in a
subsequent patch, without making substantial changes to this code
patching logic.

Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Link: https://lore.kernel.org/all/20260520085423.485402-1-ardb@kernel.org/
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/powerpc/lib/code-patching.c | 52 +-------------------
 1 file changed, 2 insertions(+), 50 deletions(-)

diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
index f84e0337cc02..44ff9f684bef 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -60,9 +60,6 @@ struct patch_context {
 
 static DEFINE_PER_CPU(struct patch_context, cpu_patching_context);
 
-static int map_patch_area(void *addr, unsigned long text_poke_addr);
-static void unmap_patch_area(unsigned long addr);
-
 static bool mm_patch_enabled(void)
 {
 	return IS_ENABLED(CONFIG_SMP) && radix_enabled();
@@ -117,11 +114,11 @@ static int text_area_cpu_up(unsigned int cpu)
 
 	// Map/unmap the area to ensure all page tables are pre-allocated
 	addr = (unsigned long)area->addr;
-	err = map_patch_area(empty_zero_page, addr);
+	err = map_kernel_page(addr, __pa_symbol(empty_zero_page), PAGE_KERNEL_RO);
 	if (err)
 		return err;
 
-	unmap_patch_area(addr);
+	unmap_kernel_page(addr);
 
 	this_cpu_write(cpu_patching_context.area, area);
 	this_cpu_write(cpu_patching_context.addr, addr);
@@ -233,51 +230,6 @@ static unsigned long get_patch_pfn(void *addr)
 		return __pa_symbol(addr) >> PAGE_SHIFT;
 }
 
-/*
- * This can be called for kernel text or a module.
- */
-static int map_patch_area(void *addr, unsigned long text_poke_addr)
-{
-	unsigned long pfn = get_patch_pfn(addr);
-
-	return map_kernel_page(text_poke_addr, (pfn << PAGE_SHIFT), PAGE_KERNEL);
-}
-
-static void unmap_patch_area(unsigned long addr)
-{
-	pte_t *ptep;
-	pmd_t *pmdp;
-	pud_t *pudp;
-	p4d_t *p4dp;
-	pgd_t *pgdp;
-
-	pgdp = pgd_offset_k(addr);
-	if (WARN_ON(pgd_none(*pgdp)))
-		return;
-
-	p4dp = p4d_offset(pgdp, addr);
-	if (WARN_ON(p4d_none(*p4dp)))
-		return;
-
-	pudp = pud_offset(p4dp, addr);
-	if (WARN_ON(pud_none(*pudp)))
-		return;
-
-	pmdp = pmd_offset(pudp, addr);
-	if (WARN_ON(pmd_none(*pmdp)))
-		return;
-
-	ptep = pte_offset_kernel(pmdp, addr);
-	if (WARN_ON(pte_none(*ptep)))
-		return;
-
-	/*
-	 * In hash, pte_clear flushes the tlb, in radix, we have to
-	 */
-	pte_clear(&init_mm, addr, ptep);
-	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
-}
-
 static int __do_patch_mem_mm(void *addr, unsigned long val, bool is_dword)
 {
 	int err;
-- 
2.54.0.823.g6e5bcc1fc9-goog


