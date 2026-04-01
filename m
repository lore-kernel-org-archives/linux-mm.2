Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E86B610F9305
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 04:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 119F66B0089; Wed,  1 Apr 2026 00:17:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CB246B008A; Wed,  1 Apr 2026 00:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F22D76B0092; Wed,  1 Apr 2026 00:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E4A366B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:17:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 793E6B9B61
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:17:05 +0000 (UTC)
X-FDA: 84608676810.04.C428549
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id C7DCB1C000D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:17:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="R5gZIf/P";
	spf=pass (imf18.hostedemail.com: domain of ethan.yang.kernel@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=ethan.yang.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775017023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9uvuJacAw3jMb0IWkn6pjnEJfWKbd9mokrTdkvUS1kE=;
	b=GT8C34nn7QcRxlZ8yWrMp3rJsH1FM9FAyoapHhWejQXP39iZaNgUKbhCM5iMkPhTcqm6Rr
	cUr/yHDj3HxExM8Gi4sgZZ2AU26fH6bkfyURPtMODpzYISha262RCi0/uN/lE/WbQOdtur
	36+TKS69c2oL3ajfi42tJEgcV21xdcM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="R5gZIf/P";
	spf=pass (imf18.hostedemail.com: domain of ethan.yang.kernel@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=ethan.yang.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775017023; a=rsa-sha256;
	cv=none;
	b=xu4E0n9FyEgYqzpcJBTYJb1e/oJBVXy1koId9TyLc1z4g0a8mG2UM88D/saRlV+PdzsnE2
	ZVwapDoWsQUPIIiFWbzc+umErKAkUgXoQu1EDrQfTl3ogeloBPOZnzyDwtQVAqCcdet4q2
	iKCgRha9APoY/HSbDGW1p9bfv8G2ybY=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2b6b0500e06so8678714eec.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 21:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775017022; x=1775621822; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9uvuJacAw3jMb0IWkn6pjnEJfWKbd9mokrTdkvUS1kE=;
        b=R5gZIf/PwJjtrtglWPlSI1Fh4mgoc1k492Ymq5tPcPqs34WBlHGTxzdWydapXX+bZe
         /Crw7SrdmUo3t+pXQVMWlsbVCyZg5uoRJGJSF0EOT33o2K7AGS2qmKoRJgoMpUrEKq9q
         NFgB/x7446Koxn4fvPzZ9ShkULmbZa+6IDerEf+Ny44/usM6opLmhpXdIeAuOnEM2n+Q
         Hu0a1UuVocCBJIJH5H9mt3rAHY7D0W67uzOe5zZigNdUxqoEe/jz4UBdyU/b+lAMIi57
         GnT0D+bmyUfU8JtFi3wckXZsP3uY8sAztaCTjMjexoJKE/bjuHT4VbB3SZtGaLjdDF9v
         fe2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775017022; x=1775621822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9uvuJacAw3jMb0IWkn6pjnEJfWKbd9mokrTdkvUS1kE=;
        b=r8oxrHi9EhTUDZdLi69VsvDrEVLpcU7+Q63fvRvCVoJqR2xQ0WTBOu8GcJwt5Aa88x
         pi40Nc0lsLvd0M3Zt5aFHbsCd7DO8C1/zUdi9QYezuLOc/SRfNaSIQFL8R2fOOQ119Oj
         43rOynH8rl7cPTjj6YZOPzDUisvSB40jljOHyvJmIDZlWbbtLfjbom5VY+aIR+1nwgNU
         cbmDOZ1wFAhpNnwYlmkcxJYhUMu4ftx/Coah7mnwM1CckstncOG+TSdh2iNaWKmOaUKF
         Mk1DAbyF+ir0LozrOXeRiF2Vj3NzU6/QhCoCFRAVUmR5oUaMQJn3wPM7ZKLP9HIt/xV5
         A8Bw==
X-Forwarded-Encrypted: i=1; AJvYcCXONntkKbesNd5w6JkPV9G5z8ktof2lKTIcUs9d5wH4RDliVM12aicvZs15zNWBioh5McFidh4euw==@kvack.org
X-Gm-Message-State: AOJu0Yxe6awlPX+JZQOh6ujHoys7ANU5glTF8bviRDFnIgVzopAyslqj
	wUAQQUA3qToxgNq3W+ZEIg+1kGCJbe9PqvEzMqNBLUuNJ2rsVFLLpHnl
X-Gm-Gg: ATEYQzzRKqHvj4PuOQVGjeVuPvcbb/tLba0AfSr+KhS8pNMbJn34BU2DjrS9lsI8Yfe
	QqdKxOfEy0y5M3+u1gBhmQ+VCNRyqW/B/kM0eUPBpFqGEXltlI47Bvs1a55CKolGPt+KXcLE8Wi
	HMTzsp9UvMxqCtXyFq4ma09sA0yB6OVZa/GZx5UFJIE3LT8UKa+CmfYE4zNvim1dbBcl6t81wpk
	gXhxpZ1LR+ZF6TDguwoEW+Gq656jTBkLZQTHXMj0JiOH44SVSE4jVtDUnNuuCptYHu957FsZZKW
	pChSSdzMepuqmQcpj5AwBs9Mkg1p9p4304vkYHfqmWiTVgGLtH8EHTMfGRR6FpQzm4IuJ9FEotM
	JXJtnWPe51acMUHIVFiQXjEufEc3NjgryJc99tmcuFLAxxLNtoPPBvPDeuHCVmTGjdHINyldKmE
	sqqNxMchsTv3WmZ7A=
X-Received: by 2002:a05:7300:2213:b0:2ba:6978:2b4 with SMTP id 5a478bee46e88-2c9321b5d9cmr1075299eec.20.1775017022050;
        Tue, 31 Mar 2026 21:17:02 -0700 (PDT)
Received: from gmail.com ([52.161.55.196])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c45dfcc95fsm9876945eec.29.2026.03.31.21.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 21:17:01 -0700 (PDT)
From: Ethan Yang <ethan.yang.kernel@gmail.com>
To: chenhuacai@kernel.org
Cc: kernel@xen0n.name,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org
Subject: [PATCH v2] LoongArch: mm: fix FLATMEM ARCH_PFN_OFFSET for non-zero DRAM base
Date: Wed,  1 Apr 2026 04:17:00 +0000
Message-ID: <20260401041700.3260-1-ethan.yang.kernel@gmail.com>
X-Mailer: git-send-email @GIT_VERSION@
In-Reply-To: <CAKeWACY11_1JL_OagfxUhQckW4rkAjhwXxUnVHNPdHF60Uc81w@mail.gmail.com>
References: <CAKeWACY11_1JL_OagfxUhQckW4rkAjhwXxUnVHNPdHF60Uc81w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C7DCB1C000D
X-Stat-Signature: w91y9dudhghs31nhdig8s7xawxnx8uro
X-Rspam-User: 
X-HE-Tag: 1775017023-977690
X-HE-Meta: U2FsdGVkX1/O07hTj+M1FlqVN4MMdeSY9k2TAVz5u4lsBskAdSQmsaBk9qQEg8d5Re2y/P83flz/ROLWn0cXNVrHGzA9l8f7c60mxScTIL54KaFSYtRXZBuoAFIU6RPae9JoM1OeeE+MoSWO26fr+NySiN/3ddrjiOvqpdJlAlKRrc5s4OZEuLfkRYD3vPukAiCZEdvC+A3Aejajxfs1WXRQ0eGlmjmC4kcR9TP/HSdETaYQGbJLs8+Wwyn+KCOmMdNvggFYSjnzFRBsgNP2ZAJVMCt8SCimp0ZBi68iyB56S2+lq+dM6QbW0j23Uldfu088XRXPOWjcyXBFqn5WpXhZX7yurjf7hQhntIbddF5fWEKNoX1m7Gv/2ch4C/JvfJ4GZ7X/nA1INUxXJ4TBCHzwjusJWP/iYkpSR7MgIfmbhZen+4IYXwzzgMIXzx2Tr9FLIUc/3gHFy8OCJEE/GVYvgCYoQ0vpQQ+Xwk9AmANXBBA+NrkVWP2AtAdKfUbY+ddwtDzEUcPvacXWQhv9B8Gt+97yaHDqjmSFHOsD3PSVlGofPSOl/6bwpUDXFdRdYmg0dNpcOB07tejCrKprD5db+w71QxkWMPVMT4GeUE7ESYjvnwWextEB9RW5xmkgmvNJGUr4y74zYD0Yhc182cs+uikB1tIBEz5ynDFc5GWgHBc8Ck89Ry6C4B1yxP2uysSYguOX0u86SW4BFHe5aS3A8S2f8hQEaDYFbV5QUjzF6bSow85F68a9TmRgYK/RFJGhfiM30jW8P+H5Z8ItHkyvRC0gNE/gp+nY8u1gYwMNF1E25jmX2oK7sOfnB8Cp5JSap8NXFgB8gmYzOaYvGm3E4KslsW8nXaWhIky65Mm8m3p3F19zVvhqBPQ6SwWczA5UXob3OFi1hwVNV5IamUoQAKIbg5jHqbHO3tpH2qs9kqPmVFEmyUZLDszNbwq+8vt0oth3R4oFyKgJtYV
 x/ZHYIgg
 gSR5YNtWXnbAMm6QDw6x8JQn+qWBJRlJnbQiWGJWgCDk1gO0bAUvSqGLCZwXK9elDFk0DCLEwovIEx9VVSosi+6bBVmsx8BGb356rJR8PvkPr4iNIw4VzMSB+JJdtIfsJ3i2R5L+sY3fjXWwiLtFTSxTz5cm4FOV9LmzoQg3ZFOP7//5oYnPnaPx9DumpMxUnVLF25FBjebR8vOzM1gfJtbRqvsvFF8OgL+26B2O8fWINAdW31imPqaPhEIgfCbKrYls7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With CONFIG_FLATMEM, pfn_to_page() is computed as:

  mem_map + (pfn - ARCH_PFN_OFFSET)

LoongArch currently derives ARCH_PFN_OFFSET from PFN_UP(PHYS_OFFSET),
while PHYS_OFFSET defaults to 0. On systems whose first DRAM range does
not start at physical address 0, ARCH_PFN_OFFSET becomes smaller than
the real RAM base PFN.

As a result, pfn_to_page() points past the intended mem_map base during
early memmap initialization. This causes struct page initialization to
touch wrong entries and can lead to early boot failures in the
memmap_init_range() path.

Fix this by deriving ARCH_PFN_OFFSET from min_low_pfn, and initialize/
recalculate min_low_pfn from memblock_start_of_DRAM() in LoongArch
memory init so PFN-to-page translation matches the actual DRAM base.

This change only fixes the FLATMEM PFN base and does not alter the
existing VA/PA linear mapping scheme.

Signed-off-by: Ethan Yang <ethan.yang.kernel@gmail.com>
---
v2:
  - Fixed tab-to-space formatting.
---
 arch/loongarch/include/asm/page.h | 3 ++-
 arch/loongarch/kernel/mem.c       | 1 +
 arch/loongarch/kernel/setup.c     | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/page.h b/arch/loongarch/include/asm/page.h
index 327bf0bc9..80aea8b51 100644
--- a/arch/loongarch/include/asm/page.h
+++ b/arch/loongarch/include/asm/page.h
@@ -25,7 +25,8 @@
  * used in our early mem init code for all memory models.
  * So always define it.
  */
-#define ARCH_PFN_OFFSET	PFN_UP(PHYS_OFFSET)
+extern unsigned long min_low_pfn;
+#define ARCH_PFN_OFFSET	min_low_pfn
 
 extern void clear_page(void *page);
 extern void copy_page(void *to, void *from);
diff --git a/arch/loongarch/kernel/mem.c b/arch/loongarch/kernel/mem.c
index 8ab1ffedc..03835f8cb 100644
--- a/arch/loongarch/kernel/mem.c
+++ b/arch/loongarch/kernel/mem.c
@@ -46,6 +46,7 @@ void __init memblock_init(void)
 		}
 	}
 
+	min_low_pfn = PFN_UP(memblock_start_of_DRAM());
 	max_pfn = PFN_DOWN(memblock_end_of_DRAM());
 	max_low_pfn = min(PFN_DOWN(HIGHMEM_START), max_pfn);
 	memblock_set_current_limit(PFN_PHYS(max_low_pfn));
diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index 839b23ede..625be2494 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -394,6 +394,7 @@ static void __init check_kernel_sections_mem(void)
 static void __init arch_mem_init(char **cmdline_p)
 {
 	/* Recalculate max_low_pfn for "mem=xxx" */
+	min_low_pfn = PFN_UP(memblock_start_of_DRAM());
 	max_pfn = PFN_DOWN(memblock_end_of_DRAM());
 	max_low_pfn = min(PFN_DOWN(HIGHMEM_START), max_pfn);
 
-- 
2.47.3


