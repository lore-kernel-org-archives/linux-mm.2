Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E258DC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:44:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 928166B00A2; Mon,  6 Jul 2026 04:44:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815AD6B00A4; Mon,  6 Jul 2026 04:44:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72B3B6B00A5; Mon,  6 Jul 2026 04:44:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C9D96B00A2
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:44:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A747B12034C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:44:09 +0000 (UTC)
X-FDA: 84957714618.02.A887A08
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id D696A1C0009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:44:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ZSY1/+jS";
	spf=pass (imf20.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327447;
	b=1Qv8gWWL1NcH4M5M7IYb3nRLWrnxhyhH4tp5uzdamMMkEpO/RKyHR/o87ra7LI91OD5+tW
	D3wVt45yaBfA5Oc0xPjb5wgCwKz1eOiUOYvseKgqmzmLK+qiqIPOAtsTRQDxGYjZ5sNUYt
	da//blWx3rNqhHMXPtFmHqAeCKUWa8k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ZSY1/+jS";
	spf=pass (imf20.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LnGUu9KwPOjM9n0YvVm33uejfmZM7bns69qSuovH7P0=;
	b=MfDU0dFy/OOlT/nz6rG21qlC1GMpSf7K8EgYEuGblNrhNSFSPY+QXKRQYucwBy58FPC7PV
	42Ckcqxv5/0bFHKAgxu68XcZCUJMN4hNH7HSZVMK+BhW6e+HB2wA9Vv/rJC7bbe6DJwRW8
	vtaP8mPOPYvD6eSz3J/bpoHGSM9kMww=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-36b9d265355so1935410a91.2
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 01:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783327447; x=1783932247; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LnGUu9KwPOjM9n0YvVm33uejfmZM7bns69qSuovH7P0=;
        b=ZSY1/+jSKLNQjJoZMSkYyKmYSRvDcjEfyspRGsEbPOB8KtYlnJRuwjHSkbM8CV3Q6R
         129SkHTML0rCTQifCpI9h+9+OV3n6R85tpV+AK7citEHgF67lDHxTn39FRNQXKTXAx1V
         eLT5L4gae+ycNOi+FP4qFlx/2WnGmoXhGJeGoLovxe4bZMZOPIAbPodxGXWA90eX2iFn
         GzgEIZlK27pCGfQ0OQ+M6Epj609a5g//k70t8e6KYS2JG3FdoqHVyxjJQlviyMvv5h4U
         WpbrCVm+AyO52mE5cWeBF0TZt61WusMCllUkBZXwfXRNkBwbQdN87SYdmFU0O+rDBSDj
         2lRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783327447; x=1783932247;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LnGUu9KwPOjM9n0YvVm33uejfmZM7bns69qSuovH7P0=;
        b=cQC9pc8zM0MVGm9hebk7BeL8CKWWfJo+NkiS5szJspB2na7jf0FdX2TOthcKjLhRr6
         sq4p1px0K/RkDf0qFKoTSZBs1HGES3cv4T5pODY2gsXn59QP3fYW65wHSbg7k/2bh2y3
         H7gWDZbTa1AW0IU8CVRvYHCs+Nzyw48BMbqI8OK4lzmXzVMBufHXdpvJJdrG/PbzDL70
         EourMlhlITxYHWv0hbLh0r3wRddd2Xls70GlOog5MPBGuB+8Tr+eB4/wCezMLZn3hDYN
         H8j/h/SXE7sCG/Ui2Bt/q6yGjP27OWBHzw+AX0YKmGf71wU7s/KTtPPuHhYOSXKmw0p9
         316A==
X-Forwarded-Encrypted: i=1; AHgh+RohYj2eZAqzU9afhxlcXJmjNJeGByV6VCPaX5M4NuxhkLBqGBA066Xp7vbsECQTaA13KyN49HxNGw==@kvack.org
X-Gm-Message-State: AOJu0YwoI2FpOBH1iazdtcuuGhXnYPTKVHf5NZ9dLDTBFQwd8/C+HBmV
	iRIZzuoFSm+0RqICyRil0P78q/UOr4LnshVUeNY7ooB6bDxGZl4Oz/kv
X-Gm-Gg: AfdE7ckQm0cNa2kZK/K1YYbUhVLXIRdTwBCFChvCZCKxCmfiI+XtByLyEa63leagTxk
	b4WRBbvuMy74/XhXab0Nlvw4AHSn9W3SPuhKP0RiEJSQ6pWqdyLaz4NIPOigg47MAy/kGZuvzuC
	WVs7EuPnLRLgVAscFJpN1dG8RGFxmsjCp9XDVvgRl/NEPUtp4LS7baopZu1jGrqXIbkSzgLIttQ
	Tw9A81q7l5zSsJfbjYpl781OpcaQ0VSA8C0+b0Pj3afXG3vZGQ+JulnVziyPo+27yGZM4QYYqC5
	KVnEQVpkv9X3EjDsP5nC9QtpRE7LUP6cjvrnTdhvF7aTC1REqahhfFiRMThTqJZgPIb41mBlqHB
	eW9f+Yx2yORi5tZkWQrEkBRNdus8x9m1rX2rCKy/xekRNoxcWBAwXw5X476yqgXeuWoN4QB4nx8
	yESF9TC34eIdmrWkMx1SThFuVSly0k8amfP1fod3VyEc9JZw==
X-Received: by 2002:a17:90a:d44f:b0:36b:944b:fd81 with SMTP id 98e67ed59e1d1-382803b6538mr9020955a91.4.1783327445435;
        Mon, 06 Jul 2026 01:44:05 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3812815c10fsm4524635a91.13.2026.07.06.01.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 01:44:04 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shanghaoqiang@xiaomi.com,
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v5 3/6] mm/vmalloc: Extract vmap_set_ptes() to consolidate PTE mapping logic
Date: Mon,  6 Jul 2026 16:42:29 +0800
Message-Id: <20260706084232.177786-4-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260706084232.177786-1-jiangwen6@xiaomi.com>
References: <20260706084232.177786-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D696A1C0009
X-Stat-Signature: ey4bzbdxpc55cz516hhf69omyuw48fbe
X-HE-Tag: 1783327447-330263
X-HE-Meta: U2FsdGVkX19z3P8nHXe7y5qGNXpsH4eZJ5DLbiIflD+ev7wETjGh4aqfR5Qy2Gj/3l/6e6qTvn+p7FwfgH7sVDYPLyQBlv4Z4C+MpYCBNK+44RYJRo+rqt6X7T2yLausLRE4nSH3FAu0S9n0KqJqPEJWBxCWnBPxah0D8dqQyUApzjEfZV7AGr2S7u/lXLYsbEx9Sy2z6MOcrfH1t10Zl6hEtj1LUXI1NqF4Ex7YwFY4wobVCbxfc4mMyijcW5Dyuou4F6k8pH+67B1fTWvERYXdoX2QbtGo3sjVOkDKjxbkV0wnW4b/FZZ5311TDYu1/9ndZSHYfHpzvLg9IFZlrSehIj3cA+NTqPaTYCL7GxOXyWqSmAMJGsZyZ9rJPcRxFvmMq3Fm82teoSdblIKnbt8Olrn6mVkV5/+ZAYNz96XgkWO9ic5elFbuBo7229jke+uZ3fUeYvCXQB278PB3fB6wt4OPLvW0I/haq2qjd3+I1DkSp/uBm5AGEPYAQOqt9aGABWo79hPvEzBv7lBJJ0CqfYOvQdSfpUoqCdCHHUHhdword7eb7Sk4c/jM3GPPM/C5N5p+p/U+aIoiqJfwpBMV0TqhB77JsCBbcC4Wu8WKxYie6WlOTrcKgHOZpgKgxa9OL/zhZ+0A+e0wOZQw7mvp31p8E8OEg+4zJzDRVvOvKDwWKvsA4grHx3y4RpI1bCBk+oMvdGI5MIJ4rhWHmnZhaTJMUdZKLLnzRvANFupyJVlyYhkiIu1dB/bUSSz2K/X4PngYOezMAqeoAk7jUGdgD/hHzRe9mt46rWrTwNd9OnBzfW6+auGRB5FfpqqcVLaLKyRG0n9lzW9K2GC1cPgeYUI9vfFUbwPPLtTcVhr8jnzfFxlKgPl6Zezb1FTlvgYiSdTcfdIM6kvd9d7nSNuDpwxjaHa9TIWhj+6TtaPQRrXhhBgpBGrsIiNqZI5TSvHhZ1D2H/Z6fcnVzCO
 2+J2Ld2T
 PbXRpKhOShxDLnXKx6aGql8Cx470WtVGoH0tNIt4Y7fLV9BZlEOOqSgK1rScqhlmIWXqKp9pO9AzR5BSJF6HRVR8vJmi8ZprVlqhc8dzwc4zKTw0jXXFWRAj4zUa/yVp0+8OZaaqshn+uslCyqHP9zK58UH7ER8Rk7Arzp9tmPVTMl4o1vyqT2AFGZTY5b1NP7ACKZabY7fihRPREUi7gTCicuUzdKkxoaVYE5mH7hEmi6GSPYgOm7eaTG+S/MyteUrARcFGHsGcxlDFc2FnbYtCzYtnWCJh93bzwCCoWpmuPIs+QLvcpH0YvkcklzJiQtlH2eX/qMXRtVLCfSLWwRBIigCHZUm4Hz5t/CFhrElAPHeRygvEAEaTkHxFh5V5w21pWSRPTzzF5LnzKU/eHiXtc4MBVLuKP+RHmH5lCj1oHqKrHxr9igPCgJ/38UpYZ67Dryj1aXR3LkVczAulxV6ec8tYmVp6HRvmeMtyBQbPYuKOTToZ8J0Cot6ZfAYEFb28VyefT310g4Yw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the common PTE mapping logic from vmap_pte_range() into a
shared helper vmap_set_ptes(). This handles both CONT_PTE and regular
PTE mappings in a single function, preparing for the next patch which
will extend vmap_pages_pte_range() to also use this helper.

The #ifdef CONFIG_HUGETLB_PAGE guard is moved inside vmap_set_ptes(),
so callers no longer need to handle the conditional compilation.

No functional change.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmalloc.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 2c2f74a07f396..d7fef85b241c4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -91,6 +91,33 @@ struct vfree_deferred {
 static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);
 
 /*** Page table manipulation functions ***/
+
+/*
+ * Try contiguous mappings at the PTE level for arches which support them, and if
+ * requested by the caller. Fall back to PAGE_SIZE mappings otherwise.
+ *
+ * Return: mapping size.
+ */
+static __always_inline unsigned long vmap_set_ptes(pte_t *pte,
+		unsigned long addr, unsigned long end, u64 pfn,
+		pgprot_t prot, unsigned int max_page_shift)
+{
+#ifdef CONFIG_HUGETLB_PAGE
+	unsigned long size;
+
+	size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
+	if (size != PAGE_SIZE) {
+		pte_t entry = pfn_pte(pfn, prot);
+
+		entry = arch_make_huge_pte(entry, ilog2(size), 0);
+		set_huge_pte_at(&init_mm, addr, pte, entry, size);
+		return size;
+	}
+#endif
+	set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
+	return PAGE_SIZE;
+}
+
 static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
 			unsigned int max_page_shift, pgtbl_mod_mask *mask)
@@ -119,19 +146,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			BUG();
 		}
 
-#ifdef CONFIG_HUGETLB_PAGE
-		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
-		if (size != PAGE_SIZE) {
-			pte_t entry = pfn_pte(pfn, prot);
-
-			entry = arch_make_huge_pte(entry, ilog2(size), 0);
-			set_huge_pte_at(&init_mm, addr, pte, entry, size);
-			pfn += PFN_DOWN(size);
-			continue;
-		}
-#endif
-		set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
-		pfn++;
+		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
+		pfn += PFN_DOWN(size);
 	} while (pte += PFN_DOWN(size), addr += size, addr != end);
 
 	lazy_mmu_mode_disable();
-- 
2.34.1


