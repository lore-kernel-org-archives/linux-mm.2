Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B4D7CD98E2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:47:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4895D6B00AB; Thu, 18 Jun 2026 04:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 412BE6B00AE; Thu, 18 Jun 2026 04:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32A866B00B0; Thu, 18 Jun 2026 04:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 09FC86B00AB
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:47:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9111E1A0694
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:47:52 +0000 (UTC)
X-FDA: 84892405584.10.08D06E9
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id BB329100012
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:47:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P+htYynp;
	spf=pass (imf05.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781772470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kLRuKvFhInROLg4Q8kC57ftYeHhuWOIlgmE1PN84SUM=;
	b=Ik52vwGxQCeJ45nlDBFHim7YukSvjm/xY+QwORfhd94AAPKeUGXPgNSKf6qg8OHHacPnE4
	oes7/29/soZbVHhY/byohf6HTAcKektaRGjrJ1mXRKjKFoCMLm4z3EvS3+eSOsJz4w6HJ3
	9EweOl4aWOp1eJOHjWRdNKro37El/Cg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P+htYynp;
	spf=pass (imf05.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781772470;
	b=cW/ggwZCXGB7S9YKXRUEdZmxXBAWxx9NPgY6HfmLmfnFgaCBsg34Rw7w/tHFn7zm4NYmkD
	AtweLVqgDUuIXNmRRsRUh9htYEQ1+VxRhe4oaohvz+Nb16AE1UEMtExOKcPf4oTllhKF3z
	sIVsKh6Mc+ZUHmyvGP+gdfuxCJ2+Gx0=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-36d98b68d68so361512a91.2
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781772470; x=1782377270; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kLRuKvFhInROLg4Q8kC57ftYeHhuWOIlgmE1PN84SUM=;
        b=P+htYynpShw1emELU8K8b5yL8BQMvcjW6azwEITAZKW5dgELxBhJ9RfOyqv12U6Wb7
         Vg5U7pGQvYgAyGuQfPcXlsZ+GIbUYKer2ymAO0hdd8+82PfFos/u5NDXZZNYsjwVOK7Z
         ZUq4GYIBas3Rrjy/LP2Ekr2Ga/KSMI0FDMeXrYpk3TxfkEdauuqUZm0pHvd/VEVGwbZU
         A+v1NfS8cREM/Mem92LEqWaLJDtluSRN8Jdf9FVoIE3UFX6wFf/DJlyV64d8O/T0KxRB
         XRFwhRChbsrEj3ekadFCLvN86nJ6VvSP2hTVNlHFCHTtOgMHwT/9MNPaju9jVSSNZG8c
         mkZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781772470; x=1782377270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kLRuKvFhInROLg4Q8kC57ftYeHhuWOIlgmE1PN84SUM=;
        b=GSzIbRTZl5fJuh0Mw8Z/4Gtl6mtT271bhpdvLTLY2XBrqIHflY5yvkpRMt0TX6jTPt
         u/xdTDKl9lmaNw8DToK+5u/LukXfbX/aexMfgl7rPbq5pitErpbiaGLRpLQRw1kgmRj/
         oBoE5JHcvG6Fw49UnaiZ+BnHbV9tg6h2c5dj2jo5fmSPIFm3+HXG9ec3IFXh+ssQaG5D
         qcZDTbsEHzClfZpUoHlCPlpoRw62xGQaCt3acwCzzguQ6MXu2LHjs8hzFOb1ZCeTF5nY
         boVLq7mm4enpyUpeZNJkLVoumeMYnxmOQ2aENNi67dNmsa1XfoCad/bBKsDJyRuWvpV1
         f4tA==
X-Gm-Message-State: AOJu0YxwxDi2pgSxEBNlxPahbzYFweTszSxYCYHCoK1CBRs5yQSiOkJX
	6fh5rwr9CtBQrXQTM0V//thVJK0E+IFdLRw2NpobEmSNGnGHZGP7WHL1i8F/gA==
X-Gm-Gg: AfdE7ck/lEiOEV3CP598acyJsYrz0BmrOnstW1oadJ+0649d3E/atrLklvi28GVhh6S
	Uu1P6kJn3Ofuq+Lw6YvKb8sVHCHDlZsBe0wxeEYSHUK2xMq09oQ3jvApBx6tG4NcD4ZpEGu0PzM
	r0r8d+En1B6WDDXkSNtbvi6hSNb/iH9bJfSNFRq8vNCKZoXxBX9IFXIyVnfuSBaYfN0LnDSidof
	CwJBOUR8voWmmHXKhy7+GAwpt6UyGO4gfLtw/Tmo8Gdo2yX+e6boJ7jPhj9QxTtUgwAzNAbmSqG
	18KSb4w5Gboud1QYGft6Uw+oFAuEblGln0/sboK3FUj05evgt9jjvAZz46AmcGvrw0EsrALafqb
	63Kmtzt+HgOSMyqLTIc0ubSP+ZtBD3ryGImnXVezUkT8TvSomYNnBRNs+CZ0dyK93KO7JPCSTSJ
	EaPwNEtI9MeA/DW7TQm13VuAjfU4QSyLFmnvg=
X-Received: by 2002:a17:90b:1344:b0:37c:607b:2cd9 with SMTP id 98e67ed59e1d1-37ce43c0ed0mr2690740a91.0.1781772469588;
        Thu, 18 Jun 2026 01:47:49 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37c521d8e7bsm8628856a91.5.2026.06.18.01.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 01:47:49 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: baohua@kernel.org,
	Xueyuan.chen21@gmail.com,
	dev.jain@arm.com,
	rppt@kernel.org,
	david@kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	ajd@linux.ibm.com,
	linux-kernel@vger.kernel.org,
	jiangwen6@xiaomi.com,
	shanghaoqiang@xiaomi.com
Subject: [PATCH v4 3/6] mm/vmalloc: Extract vmap_set_ptes() to consolidate PTE mapping logic
Date: Thu, 18 Jun 2026 16:47:23 +0800
Message-Id: <20260618084726.1070022-4-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
References: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB329100012
X-Stat-Signature: qye9au1cw1wjr9681doffcqcma9o5gi4
X-Rspam-User: 
X-HE-Tag: 1781772470-538861
X-HE-Meta: U2FsdGVkX1+CoKNtV0KXj/yv2pypWauIwufv0qVlZu1We/dsPvFpE3Ig3ULwAyeO2okzz0ZRq9vUOQS2kP12vx7nNj7BSdCgMcPEwLqhwx0WyPwGVUyUY/ixDPzIInL7Z5q7fsH0yI7JrleljhzqFwWR7DwUHY+FCPxv94BkHEsXRz8FJg/K+VzjufcKe94ovsCXCHdDZGQr0PC7hb+jV/Uu4Wygo1/9YTh+xccKeBO+ZRR40utB/q/I14EIShRidY1YTfpmkZKngGtohMVWvNSjIKQG1/Oz8i/dRZgroDiXU5vGWbJYZKqVvK1Mmk7QVrW+T56ZGQdMcPvmjzgsbDw3e87/gPq5TpvoPUH5KvWHl9xYnlXF60wbf3td7Lg5wCsgQv/Jw8eoVNab4o91ueAZThWDheznwUFLzE1byEaqFqV7MqOk2xVti9KHRcAuc5P4PLtTSgrriJa3kYBrD/Bh4PuUIMlMix0lzhw8asOqbZyoAz7i3uaKBYgqVCbG3eFF8RDgWKNo4m88RKAj6AUrGR9D+peQ2mGFVqS1IaEldLOJqwkdV3pMVJCzJ29HaoPpNtFrfxLvd9arC550gIq9U/hQVYfeCNDNDlx+NS87hYJg++oycj+Wa9jLkI8293xUOlwpthuRJP7wphI5DKgwympktVtZun9uUWlxwExYRtFQ1wNAtgLNiqT5/6xSX5y08i9qpX4R8lv1dfHkJEv7FQMRbj2a3ksyOevgNPctOwdDeu4DRdkzD/85zwETVT+MJKlSwcrVIbGZRQM2lBoTbZh3UQD3dOXOpbE7NkJhovdm4pmlonJK/MU1q+F1l1ty6aEjdhGVa0D2j8MK0bSJIxzhzOJASb3N+zvKK3dyEomx7MyHaapXaK7iABLHOPlsfL29mm66XGzlwPUm53KVuWn0esYCwLjS/V8lJk4I8wuXp53QKLi3aw7BE6aGhn+qxXsOFg7rdVL4ZPM
 kc56JW2R
 Z717FUkFBuoA/U7SD0K46wC52uUXWkT/paXZOwy0fcZ1UZnsALhouGaad2v9Q6pM9eP4ehrGMhpxH00KLTiZLU4uhOARsy9OZSgrghvdemgq29lgpH+l06FZ6Ikx8h0Au9NnvFwO0QSQ+jzbKq1ENMyZ6x9SbIamZkGT4jDPm4gfZJrBfXIgqplSXUIATfHGHXPbLbcd3LSr1SbsOqcleUBt5KpvLVjEA6gQI6ljMevyw1IX/hBXX1qHQHOSBZEgPGvKDBg2SA8RwJjRErauT5wHDH27I44GbWfdOsOQnewao3xitgUanxy1NW+tY6NcgCaIcIqOKBAT5OD3la63QN02v7JRT844STZyBoTeLLgdoU23sZP03BNrCYaFb9BaWdlzCN6AQUhymjRVZyA8c2Xp7fByn4zMtpibNpQ+B7JIaWa7wQyP6Of5YHNP8WjMXJ/uh65tpPzKCc3AfGv7xVPNtP0bDFVkpUZnZYPcgS9a2ldPIo/ATDo56fXRqds5B5OkQMU2hGlPW5Xo=
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
 mm/vmalloc.c | 44 +++++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 2c2f74a07f396..6660f240d27c9 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -91,6 +91,35 @@ struct vfree_deferred {
 static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);
 
 /*** Page table manipulation functions ***/
+
+/*
+ * Set PTE mappings for the given PFN. Try CONT_PTE mappings first when
+ * supported, otherwise fall back to PAGE_SIZE mappings.
+ *
+ * Return: mapping size.
+ */
+static __always_inline unsigned long vmap_set_ptes(pte_t *pte,
+		unsigned long addr, unsigned long end, u64 pfn,
+		pgprot_t prot, unsigned int max_page_shift)
+{
+#ifdef CONFIG_HUGETLB_PAGE
+	if (max_page_shift > PAGE_SHIFT) {
+		unsigned long size;
+
+		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
+		if (size != PAGE_SIZE) {
+			pte_t entry = pfn_pte(pfn, prot);
+
+			entry = arch_make_huge_pte(entry, ilog2(size), 0);
+			set_huge_pte_at(&init_mm, addr, pte, entry, size);
+			return size;
+		}
+	}
+#endif
+	set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
+	return PAGE_SIZE;
+}
+
 static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
 			unsigned int max_page_shift, pgtbl_mod_mask *mask)
@@ -119,19 +148,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
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


