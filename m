Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 480F9CD4F5B
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 05:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3896B009B; Fri, 22 May 2026 01:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CBB56B009D; Fri, 22 May 2026 01:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1D26B009E; Fri, 22 May 2026 01:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 780296B009B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:32:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 23A3F1208A9
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:32:10 +0000 (UTC)
X-FDA: 84793934820.16.C38DC33
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 508AEA000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:32:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j+CP+HyG;
	spf=pass (imf25.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779427928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HydODzhJG5OH95FA088njE0U9Wx1Okn+yobhn9IOhgQ=;
	b=RMhgYgWzW3N/lR5sRGlIUJDmKmt+opxjBud6vuN4PDoQphK2cRTwEgTlmL1mznYK1jCygQ
	+A1p9Teb7cs7fc1PBazZDpq4OJAxPTfBHPwclyUyzg+/dTg3G3sPB+VqaTGVtczb/M2AKu
	EdP5MFst8dVYogOqDYkjnMkKoaWcXtQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j+CP+HyG;
	spf=pass (imf25.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779427928; a=rsa-sha256;
	cv=none;
	b=LGRweTmMrh1k7gm0MlR/vdgAETsemjQAZKTFFlcHOZCTs3dkqTiBFSrM42cR2VKHrvekQo
	x73FWDkT7g54P6klJ1WBSykXmnR00L6r/YwZ/01Cxu62uUy/ItAQAPsIEpcJ9KMuMO/5v+
	uqWQHHz1VNZzArd05nCt/T2b3U7jW7U=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2bd80b3aa13so44939535ad.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 22:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779427927; x=1780032727; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HydODzhJG5OH95FA088njE0U9Wx1Okn+yobhn9IOhgQ=;
        b=j+CP+HyGWID/xLld2aqHh95UQnKGqDPXMrF6rsSP4wlT7QVn/658NMGWAH8pCcpIHy
         u9X+hZaNUN2VQh+zwK+GlFnzINQeK/96p67TdGaYhXyleY4IA5NcmVTNgcaVnjovjrqT
         x7iJJolgV54k6J79RSzkm87XXUGE+mbEdtiuW7x74XmpBFcVaJmMwDIhOj7h67N2x177
         A55LdGs4O059CQzj68xQxmCUCgwhv6yGPKbN0APVeJEcBRG6N9Qj7ypA3UCBlmJmtifc
         IrTQR0dkJBYQar14xXcCZWnIfmXdqDL1LkHplM+zcXPdKN2CTkyOV0Kfw9GWmIFJCXTE
         cZJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779427927; x=1780032727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HydODzhJG5OH95FA088njE0U9Wx1Okn+yobhn9IOhgQ=;
        b=V2qIhWLAB9lG8aFE22jXF6F3c+BxClxfNUtds2CM3tDw2XYdwUeKBuY43pJARdPL/i
         JukZ2p2e0jBGiLcBSUsT1PcQAKSrCPtQJ6nIoJM8DW8rtS5+wFbU5AakECw8CtYT3pxD
         kZ8I/O/8RW8tSTx9b0mx0IsidXvHPIfgg2X3wgjVf0V34HJECOuY+O2bclUZLnX7+EMn
         yV2/nomUH3ep8ZbbO0iUS9i9RyTi97mYoK0lBKz+nnYBgN09ZfqLv5gJYXhx26QqO/eg
         kuyDpbwADm5cYu9EMcPj3vMntv+SrZYdCqTIpwr50WELkDcvMe0b+hjpFCyNd8kE7stw
         Y/kA==
X-Gm-Message-State: AOJu0Yy4jq7rbgRBO5p0gM89nRoGYuuzIhLV9p5OvNVPPee/m8WgBvjE
	HQUOfULp4Z3o4pw3h5AhQK68hMfiR0+gKiibUQR4vWg+Ay5Lr6EOy5eHCN2QG3nx
X-Gm-Gg: Acq92OG9DumFXS8UA9QkSo+fRdjUGlsaxGDdaALBjGPTnticvRB+DiUYQ4QW9uza3ij
	8tuUOggGwCqkNpkwRdfM5Q+lWxENCiIWEiCdtkIGiEGTzYDt+TzGB3iKDLD+f5tvZsoEfcIX8LZ
	6OsijCiN7PP11RZEyXvFEPR6uzauK9s6g5JldFKQmBu9ImLQr718YJenMqyf1rDt33AORJXYnYB
	wmZIxwg8WlAJuyPf6RVPV0caKUBi4C3mZPLVPpn1qQc/1XHWrE6lBm8e5p+SD5W6cMCCH8/gHDp
	pbV7mwEwy3M7t0JsqEN5BySC+dzzbx9zF3a5O6Uu9KOBN6H6nZQ8OhOwBzP6njnIxSp3rFNye4Q
	bZRPFil4paahvdNp5ABFBCCrVXVpQSbLlJ3vTZiHTkdSraucDM4xAYNuR5KJo+sLfvOT3CHj7wz
	CvoW0PI2OXkg7W79rRj7zJ0uc5PwvF/x2EuUFQjU1+tcSBVEd+YoU=
X-Received: by 2002:a17:903:f8b:b0:2bd:5026:ca11 with SMTP id d9443c01a7336-2beb06ea84cmr20575295ad.2.1779427926999;
        Thu, 21 May 2026 22:32:06 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56d68adsm4782665ad.32.2026.05.21.22.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 22:32:06 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
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
	jiangwen6@xiaomi.com
Subject: [PATCH v3 3/6] mm/vmalloc: Extract vmap_set_ptes() to consolidate PTE mapping logic
Date: Fri, 22 May 2026 13:31:43 +0800
Message-Id: <20260522053146.83209-4-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6pqqdgq9xtgd349pn4nxk3pz441rqrx9
X-Rspamd-Queue-Id: 508AEA000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779427928-268033
X-HE-Meta: U2FsdGVkX1/nohhS0q8n3EFdYwcepHnxqV6/DYAuARD1mWLxYWMu7eamLRNoQ5spE9rzomPRbUhXELSutOFtxU2cvygdMdo14rSb3cnAZeJC1TsFFu0JLgcmhzUZ4jlIcslZzhaqVvOBxLk982bdg18pDS0GC+PTDHIZNk27YSOsjva20y+0Mch0CD4IUQsr33BmWn24QM7Qkv0lVgJkWzyMuoFy52X0cMq7ULnYCzEWRcRfFQ0Qjb2V5O1/GGrypnJQgNlsuJ4YU5teLtjukVdK/4YpThAt8jdVKI6i4Sg/+f7xx4EyBSvZQRP2YkhopfgJKeXYQ++2YjXT7bdM19F1SPtVCS4lrxMe2fhnaDdwkZDKLw5GSvBjWGivXBLCTBPHngcReKZ5gMQW0m9DlcwbWys1S/6X4Pv1ejV3eXbt1EtGJXZTeQYahcRfR5KVz8Rpxx0qCuYdfvTkUXgCmPh8DM4Ah2xMe0gQ3xTH5LxXK6AFeKx61NTi5SRhSnZuJY56jo4koPRJWQfJFufVPsqQUoQAl7HoYPSdn8JsDLqz+FESD9Uz9y1HCwqj5rdwrk6w1BNyDB2PF7ptromuMb1xm/wmdvZT5W2c0dRrJczrpqnHCvdxogaCrsi1GS8mTw3rKil3aDx+dBL5j4pU0+q0pc2+QlbJny1YY1fLLFX2NAfLc9I5S8f8KaU63hpBAGwR/tAwf4A5eVESg8DsBnW2PTOR77UMxtHoVamHRnEq60rPMgHqOWTpEF25QbFgAWnvhnJnziPI6s9rrWCNZJ7GJRgDuQe7s34vf/qkSX+l+iE5SGe1GYTe4K0LJEuUjkRmpjfCunj5r85veKBJbkwBfeEVyNcyhM/4I1gJGdcngY+dfOf9mkN5WeIe7O04G8k3Kc5Q4Y4Udz4lpwV+gjWkcMADmTpc+VaUWoG/9DOtlgFbutknSp1/Ocz1A4hOHttmRuKMUVc1LiYpe1O
 DXP2s/tN
 Q6YpKfN81HUbzOk79tr7e46VPB0WAnitP68wpedk3u90wzICsZiWBpDrLTnsmDC8uTrFZZoc1ZLZMEiw+uNYaltnilQtJY0YTQOzl2Pl+DsZqa8icl5SupGU8jJfqRSo8emgLK/OSXYBrk/nExQB5qT4PghUt+qmsk7Mp7C4LU2NRWHoTWHWhuh4BECBIxUljuTz4jLt0aoChzRR0vRRYFsRvUloyfnocIZn8wLvH4TO6FDL9g/kwhnEutKymL+Tily0U7lm0TDwveT9IdKdA+7ZDaO06cCiMFzeY6TMzKdnSqPVhD1XujjILv0nLypKvtGz8Bh9bhyJhbBvmIV5uq2SDRxBc7DnZchF7EuOH9T+cAhIITAYUQfs0dNR5FosWS/dSh8qdR+ZyNQde3XbwT/laOIMIwUo2kMqO5vkvemyu6cR/z82yviae87lBBbhC+69vjJpRhnnNhxg+4vjLXBK/EjSzjGAMNJT9LEcKg/Sgi8HotqwE9rc6eo0ukI8Ysik9OIYjNo0UuY6u1ERO49KTdaiz376BmCJwF6aQfLeB6h4W7A1DxnQkBg==
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

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmalloc.c | 49 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 15 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 2c2f74a07f396..53fd4ee460ea4 100644
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
@@ -98,7 +127,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	pte_t *pte;
 	u64 pfn;
 	struct page *page;
-	unsigned long size = PAGE_SIZE;
+	unsigned long size;
+	unsigned int steps;
 
 	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
 		return -EINVAL;
@@ -119,20 +149,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
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
-	} while (pte += PFN_DOWN(size), addr += size, addr != end);
+		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
+		steps = PFN_DOWN(size);
+	} while (pte += steps, pfn += steps, addr += size, addr != end);
 
 	lazy_mmu_mode_disable();
 	*mask |= PGTBL_PTE_MODIFIED;
-- 
2.34.1


