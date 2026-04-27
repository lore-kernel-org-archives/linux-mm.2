Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2C3BFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:53:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 107526B0095; Mon, 27 Apr 2026 11:53:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01B796B0098; Mon, 27 Apr 2026 11:53:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD7A06B0099; Mon, 27 Apr 2026 11:53:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C17A26B0095
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:53:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D2571BADCA
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:44 +0000 (UTC)
X-FDA: 84704735850.07.74CBCD8
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id E8D18C0014
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="u/eldyYj";
	spf=pass (imf10.hostedemail.com: domain of 3TILvaQgKCGUDUGE+JLWJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3TILvaQgKCGUDUGE+JLWJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPGO5NkKZbwBF89donUpo2WBB4phkcPD6/ayIGThuKs=;
	b=k7ihUAExwJPV0dcK59qEHtdJ2Ae3xwHHtj9qlqcrbuU4JTS2GxHa2ohin37xPsqdV1L9Nl
	EfAWNU/A48awxflvFBX5jW4rtPRzuUfu3QJJHut61oetvL3Iysu+grSvQldcRLmBCev1mO
	vZc0NixJrn0fQHm74rDGj8PYP9ozAGE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777304142; a=rsa-sha256;
	cv=none;
	b=dODOQ54nJQIJDwRX8O74olURaJkhwkq29lEnBlty+zUeCcuPUnxL7BK8Tg62imddXH2+Lj
	QFgeG/sbhzQ8cUvXyPR7tW8MLh6XoV1lHrpaKBIRO53XGa7qK5SkhvyFodbvnQmRMwwr+6
	uCk7P4ABzXe7AWbauLrDg/0POklFKrU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="u/eldyYj";
	spf=pass (imf10.hostedemail.com: domain of 3TILvaQgKCGUDUGE+JLWJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3TILvaQgKCGUDUGE+JLWJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-488c768a9a9so68411675e9.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777304140; x=1777908940; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XPGO5NkKZbwBF89donUpo2WBB4phkcPD6/ayIGThuKs=;
        b=u/eldyYjkO6YW3/uU6/Tmb3lTuGGFWvkZ2RVEi+1+BvbuBtngWTAOFLmx7GQVV/rJl
         aw+Gh4c/FBJUjBGeH2hJA5R9RDheOE2tGaPS3NSHUDTzBA9YWQBLQzeuspDFosk4qdTR
         y1hOyJslA+rEi28D7dpTJ8QaVRNdsQmZhW3S2Iq+9Y/HKkwsgtb+HMfRQylOq5IfAiSu
         AgUujZTUvdIDjAYIIUBM2nTqKOaNZ/Jw+18uUAsU8FbnbSfBGRk+i2YfpnUJBdxLHv9S
         rf2UNdhfLueoV2lFzStuIKbG5WOboc33ul/N0UhzKcSj7fR8O1CJEwE238R5XF6GTsha
         3NBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777304140; x=1777908940;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XPGO5NkKZbwBF89donUpo2WBB4phkcPD6/ayIGThuKs=;
        b=b8zIolYK+QA65cEF+u8pKqCYxlRMGzaH/ZMIG/S7qxoKgL08eJ+yVNXJyqzX8cdOlx
         yGe2vXv809lAxAX98FgvLMbFT+fA//rQ+eXCkVRB47GeGbcd12V42Qi4ELx3k9SlxhhL
         ws0lYJSMpK4socYwU1lOYVzXCoehV6k8LRMZIMZuEzX3NDA+EY1vnV6uwy/V8mpoH9wq
         g0XO0LnqyrZKKvquumKAll743/UDGfNhEepRZmTkPTEGWFBt92JZOD8fhcAUUvgzcc2T
         FCEkqetuaeqyjkHAx6HJYTt83C/Yxbcd23E/EAK7IIyMvKmrs/y1HkoqAn42E3Zbaa3X
         bSrw==
X-Forwarded-Encrypted: i=1; AFNElJ+yYPxmUe3SHwmTtAvSVa9EUMqq9YazeZL0caPGoKC/cAc6E9PHuI99pXN9ekvInGemDcAhLp+oBw==@kvack.org
X-Gm-Message-State: AOJu0Yz/N6j8X73jmfHZcQeabIUIPSR6GGLMR8bMG55V0fDH2Ufzm/H/
	k+EObVvXtYo/7VqraWV65sW69KcgdYPERKVZUim4lHeWjNAEApCqT8vazu9mXxKcPPxZ7bSCaQ=
	=
X-Received: from wmbjs21.prod.google.com ([2002:a05:600c:5655:b0:489:690:d5dd])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c04a:b0:487:12c:e7e1
 with SMTP id 5b1f17b1804b1-488fb750840mr434963185e9.11.1777304140187; Mon, 27
 Apr 2026 08:35:40 -0700 (PDT)
Date: Mon, 27 Apr 2026 17:34:23 +0200
In-Reply-To: <20260427153416.2103979-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260427153416.2103979-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3391; i=ardb@kernel.org;
 h=from:subject; bh=I2DZ4/UqDVyZEyJTtirGLkm2tY5dVwLgkN0d0TthFiQ=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN9E5Oz4cnQFbZz/ubvO6+x9N2e9y2fv818/K0644BF2
 uqMO09WdZSyMIhxMciKKbIIzP77bufpiVK1zrNkYeawMoEMYeDiFICJfP3FyNCv9vzcT50tV2ab
 tKs6rdmtmP+ZSdS8q2CHk5bVhmD/I6sZGe6dv55h+qD/YWdJV464V9y9yPhfLStb8rbUHZdcsCT 6KCcA
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260427153416.2103979-23-ardb+git@google.com>
Subject: [PATCH v4 06/15] arm64: mm: Drop redundant pgd_t* argument from map_mem()
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E8D18C0014
X-Rspam-User: 
X-Stat-Signature: pd4h3mqowrzn94koq6h1yyj8xkhmeh7b
X-HE-Tag: 1777304141-339763
X-HE-Meta: U2FsdGVkX1+EDxP1KYmMIjL8DzAHxx9BKDmfxAanAMlETLKtzVOeQdOWlCJXVTl62MzaMh9UiB8LW25PQwCx+KKgA4z67qbPeTzvxGrCQVHWrOWPUjDR6ZQvH7t9txiCBC80bxZP6YCBprWhm8PHNGNFZ5/nG6FP5pCbKnQkCdqQa+F00qQLBFRkcymE7zejyQUvo7uV4uCgXie45+J+ajOM/eU4JFvKagIC5TZtXnqtPmYr2uv9KEhoTlZDh3LwG5kYebUm2uDrLtyiMGlB/ufO6dTvVW+q7vG5D9bsiNJ5R0R7+jY0uXSRTZX0FNd+V7cppIW4KBty/+VbmVtVHmdDyqtuUO2CUfa3WvtrSHABMRohcGNduF5+awH6aIEXlxkqU860YaWtwXS9BJhLuH+pU/4xEy9lIBbv1VZaD7yv6iM1mENuqGGSRLGw1BZlWu4j5zbVtQn+lK9n2hNO9GF0J6LpRk42mdeRckIMcxm0Cr4uydYVCiakQzTnFTvdeOEar7cb17NWsz3F//+xx9mSPgY5Oeq2k5Gvt6SUrX8+Xri4yIv7UfsYnl0suSRnRAJu7XiBft6doqyGh+0hAhYVfHRnNyLivcjrNWbgWJt2MQO3KhkJFmX8+PGB9ZtPD88E3Gv0jHgLWjsuQMR0nvQXFl0QjCknsjQ6nyt9jM592meiFau+V1w3MgRq38n0AIIeCm0FCIxzsJZh41eyJfeWcJZYRmwDcxbz7Vhbnrlf6UUOSCKmZlfd52WZnO2r6WRz2pC5Z0CmBkMsiRIphCzradeskgc6LTWM6tKcXJL+LA13UITClwvRD7st5ZnB6nEC1iATFqQVajhHx2wQ6CNsy+DsKw/TpPNF2AJcmznGh0xzSS3ePN28pK7vKM6xOjMBqTbtdMV54IdWE+fcCFStiTfCpwGPxUEH0pLJU8ljcqoYvtqD/G7bUljzLX9YnMBwXsZiTasndN0yljY
 gO6KQ8D5
 Bz9GufFef6Ok/yQ67QlZZSpJ4zYYoWnKeEMpFBhLGpr+0Mr49ak0sdLn1daRYqsINb+TPqw13Xt8SR3v64Yze9xO1FvhklnLTmGVPE6+zqf6eM+KvUgOxXFdfZZtqluzIeoKRxMrfXHRiHr70WNeV1/00io94UorLenRiwExY4SdhFWfQQyf076P/d5jlgtapuXP3+KFgRi8qv/QOKVAqxX0WMz2sdQo+xafZha4qLotutc0MDyItRiRXQX9i7lVeDVY95Ci8E76l+1AIwQqGXRY1hT3yWYYNw3xuV4WXH5Zt2vqYAtfGU4nCkQjp8ebR680sCA/D/3VrEEDqxM7rUCpt3Q2BDXSA1loDWCCuBze+4HthTgR2vFczEA9qGuwyZ5RGsBcFfLAVtMV1Hczh61/XkjdWOtnlvakLhZAe//TDSSpI3HRmnRSu5oGF0K5QxJikjVNZ253YBh5sCHuSCGpTK6cuY7zUkQafgR5Vv4Mxfu60/lJhsjN7A7NGmp4cOIG8Mxne9XnzRx59CBamdvwfYJDz1ySanVPo41OvaXvrpZ42x7XloSrWCgLt7LlHEFWrHDlsgKceJ/n2tflvBidWuzbnQnQYTGPMz26HhazmOXd744loU9mQlVwEFq0Eo79tm2B4xSQ4R3+EXg6LMuyJJKyH5Y+pZBnwkExNN3gy9hJu+DKAuh3U75duC/9Ln027e46x5dlaqMZWJfbHV9rjF5Zm/V/DYUOat+/Y1TABMumeayd0RObiQinszEO6UrrCSDVPDWpOgiE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

__map_memblock() and map_mem() always operate on swapper_pg_dir, so
there is no need to pass around a pgd_t pointer between them.

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 25 ++++++++++----------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index bfbf3fe0d1be..9610dd2d7bd9 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1039,11 +1039,11 @@ static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
 	flush_tlb_kernel_range(virt, virt + size);
 }
 
-static void __init __map_memblock(pgd_t *pgdp, phys_addr_t start,
-				  phys_addr_t end, pgprot_t prot, int flags)
+static void __init __map_memblock(phys_addr_t start, phys_addr_t end,
+				  pgprot_t prot, int flags)
 {
-	early_create_pgd_mapping(pgdp, start, __phys_to_virt(start), end - start,
-				 prot, early_pgtable_alloc, flags);
+	early_create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
+				 end - start, prot, early_pgtable_alloc, flags);
 }
 
 void __init mark_linear_text_alias_ro(void)
@@ -1091,13 +1091,13 @@ static phys_addr_t __init arm64_kfence_alloc_pool(void)
 	return kfence_pool;
 }
 
-static void __init arm64_kfence_map_pool(phys_addr_t kfence_pool, pgd_t *pgdp)
+static void __init arm64_kfence_map_pool(phys_addr_t kfence_pool)
 {
 	if (!kfence_pool)
 		return;
 
 	/* KFENCE pool needs page-level mapping. */
-	__map_memblock(pgdp, kfence_pool, kfence_pool + KFENCE_POOL_SIZE,
+	__map_memblock(kfence_pool, kfence_pool + KFENCE_POOL_SIZE,
 			pgprot_tagged(PAGE_KERNEL),
 			NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS);
 	memblock_clear_nomap(kfence_pool, KFENCE_POOL_SIZE);
@@ -1133,11 +1133,11 @@ bool arch_kfence_init_pool(void)
 #else /* CONFIG_KFENCE */
 
 static inline phys_addr_t arm64_kfence_alloc_pool(void) { return 0; }
-static inline void arm64_kfence_map_pool(phys_addr_t kfence_pool, pgd_t *pgdp) { }
+static inline void arm64_kfence_map_pool(phys_addr_t kfence_pool) { }
 
 #endif /* CONFIG_KFENCE */
 
-static void __init map_mem(pgd_t *pgdp)
+static void __init map_mem(void)
 {
 	static const u64 direct_map_end = _PAGE_END(VA_BITS_MIN);
 	phys_addr_t kernel_start = __pa_symbol(_text);
@@ -1182,7 +1182,7 @@ static void __init map_mem(pgd_t *pgdp)
 		 * if MTE is present. Otherwise, it has the same attributes as
 		 * PAGE_KERNEL.
 		 */
-		__map_memblock(pgdp, start, end, pgprot_tagged(PAGE_KERNEL),
+		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
 			       flags);
 	}
 
@@ -1196,10 +1196,9 @@ static void __init map_mem(pgd_t *pgdp)
 	 * Note that contiguous mappings cannot be remapped in this way,
 	 * so we should avoid them here.
 	 */
-	__map_memblock(pgdp, kernel_start, kernel_end,
-		       PAGE_KERNEL, NO_CONT_MAPPINGS);
+	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, NO_CONT_MAPPINGS);
 	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
-	arm64_kfence_map_pool(early_kfence_pool, pgdp);
+	arm64_kfence_map_pool(early_kfence_pool);
 }
 
 void mark_rodata_ro(void)
@@ -1421,7 +1420,7 @@ static void __init create_idmap(void)
 
 void __init paging_init(void)
 {
-	map_mem(swapper_pg_dir);
+	map_mem();
 
 	memblock_allow_resize();
 
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


