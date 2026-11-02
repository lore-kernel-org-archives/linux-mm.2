Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49422606A33F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 03:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=aVaUIr+O
Received: by kanga.kvack.org (Postfix)
	id 77C856B05BF; Sun,  1 Nov 2026 22:27:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706A56B05C0; Sun,  1 Nov 2026 22:27:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F69E6B05C1; Sun,  1 Nov 2026 22:27:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C60B6B05BF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:27:04 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 58B1DC0BE3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:27:03 +0000 (UTC)
X-FDA: 85388742726.18.89232EE
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 94DDA140005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:27:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aVaUIr+O;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793590021;
	b=VCpUjpYndNWV2EQX8L5FP9z4AezODIY3vLSOdrIC1ZS50eSgWx3D+cVZ5eNFputJaJbdZE
	br8nHJu01EUWGI1IppUAMLRFF3Ey0Dh1ItQN/UpCw/OJBF/prWDuIK9hFctu69wNiz2HBy
	Rxy0ut8wMFs7D4J8h7X79PiPeUZi2gw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aVaUIr+O;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793590021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rw0T/ADsdVtpjl5tZ0BGEEeHVd+MgRGP6vlaxN1BW00=;
	b=uXbUYck7yOzdlZyMAIkltQWFWnFkiRh11RDSY08kR81nspKQl+jAujnS7xO0PPQaWuvaUN
	j6DgntDmLtTeL/NZWa9R7ks+K286PRhM0Qt8iX5IgMVFMtuaKEXVnGIR1GYd5iXWtrGWkA
	Rtp0s0i6M3BJ1pVYOS11iBpegFwiROg=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3aded3c6103so1140767a91.0
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 19:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793590020; x=1794194820; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rw0T/ADsdVtpjl5tZ0BGEEeHVd+MgRGP6vlaxN1BW00=;
        b=aVaUIr+O+E7fa9OxfIWeAiAIt+UCc5pQiMAcNBzcyxnXa1JDv0gj4XyW5r55GokvOF
         0iSw/wvoB6u9TNI+ypSgVHLU/0sKEvfB9kvYnQucQzEOPMlUX4REgz7IYlXccFVU0sw3
         M9zbxlyJFc1W9teKTNqJiUJTTwplgOOKkYkfgz0FXn4UVJZyzwfVRXrs1nY0yHy2sOIu
         nMS+7kC39pb05czotH5osT8hjsLZSGp+tAYgY1Q1m3SwzY0jzfathMJDVwcASM42dEq6
         ANHsN0xVQIliTb/nhAIT/cTsj/62nmqtHh748lS/aFkTV3ulK6F5IbCYY87rFH8+tJe7
         +tJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793590020; x=1794194820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Rw0T/ADsdVtpjl5tZ0BGEEeHVd+MgRGP6vlaxN1BW00=;
        b=DJ0oE4WQKPMdbtvAazbAz1W5aaVLrVfjyiG5MEEhULEsPRF76i0fHcgLyMxlrn7/iu
         Wj6qzwc4oM4cORb0fp1GcKPmnWsZePiAF++J/CwXHqnuRm2CBgTKPg6RonmLq/CDSxL3
         0JIKJXlcLzsbrQGnxmlR/0KSGQNJRYE/XsydbovRDgQ547YTXhbRVdz4R3AzJEGZxjE+
         5VwL+/DZNkhIlaAZ6CGVx2gqvqRkIlMg1m/6O3YUbGk9bOAUME69I3Usgw9VNJhkxeyB
         asu/z8q3adJvKLiC+6H6LlnK65fg/oW+d8GLfwXlBvwGY0NeIHIzp74OSfkbM571lVOS
         0/Lg==
X-Forwarded-Encrypted: i=1; AKwUvBy04Npl7TjJnKBDwDHS/NSP2rdPjPG8VYIxJNR0swym8p1IRJDgItG3QQOkc41hm1iDWc4oHe//jg==@kvack.org
X-Gm-Message-State: APuU4Z81Icdgb/QKI2xt2feWKb1Fausz4Lk+VTYogZPBY4AcEhQekB76
	gfO8BQt32Wp2FjGI6yLbINJFavDClNL3Ad7/ij675tu18/gvjefras3zx8WTSSVyaut5JSVQOkj
	Pltbm
X-Gm-Gg: AYBFou20ixeWjb3vSJmKoJQdYkuWyrY7oZw6l12/2c/7rJjONAZX+VcaGu+PuUiJNfz
	DbcvI/c5/R3AjUFWp++SoFLAht3auVqUPdj511U7caXGXt6NvmLGRl+Hg7zWej6lGJ12fbLV7RO
	UcnYhUIwlsRC+E9e6fHLDOpmmNgMboVU0gniPlrINk7IZqnNi9niW69UT7EEnizZH4mCkniQkOH
	7gqgC7tiKHhraPFuWkfrrEmdGAi3IxfFQv6JaGcWyGiq2YSU1cBL5dW/GAkMWFWS62DOhp7+rjG
	Ds0TGkFyegVD8kIqUDOXcfhZNt5KGv5yRVYqF/Zgyyt/vPclOHNjM1VWOXZczkdO2wsOuLbv4Qu
	Hy5UyohQDYmSjFGqUyXcq8UuqAVuQqxgEbTUVeGNEtF7Uh1X/6VdDKfB3pGmUk0KfV3YdI76KQo
	U9upBQl4HLl3pwwf1IBU1XBEEW9TOHWpy/588UBlelZcg4f2V4ju50+L4mQFu2d24K77IaJqzEr
	ZrZmSlCwhUgJyn0gtXQaRsfljhLglZot0OiXhQesuyLqQ9xSJLFf7gwpE/6BLLbPrsyDwa3G3JU
	lBp9ckzuyYc0o9oepAFu+ibtJJxaIGx0Qz3qcZyHD15ssvTfIQ8=
X-Received: by 2002:a17:90b:33ce:b0:3ac:ffb8:1809 with SMTP id 98e67ed59e1d1-3ae897e230bmr6793857a91.39.1793590020343;
        Sun, 01 Nov 2026 19:27:00 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae845984absm12303317a91.10.2026.11.01.19.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 19:26:59 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 10/12] mm: hugetlb_vmemmap: make vmemmap restoration folio-oriented
Date: Mon,  2 Nov 2026 11:25:23 +0800
Message-ID: <20261102032525.3597743-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102032525.3597743-1-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 94DDA140005
X-Stat-Signature: skmun8ys15k4ersuhj3euukrow16buon
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793590021-678191
X-HE-Meta: U2FsdGVkX1/SllLf/KlM/fb2Seqau5hZdN1Vc7HjpmzoRe0y5zVV7ZRKISLO/A0a2VzG2Paia8xbZv8yEHl9RvyE7Ljbf9i7LvunS7Dkz6sRIdmwy0nXslQYQBE+5wGO3CNiqOR5KqEZk0kup0jCtrYubzC37qbsLfsKztQ08XvRtTR3p5qPrbWoRz/byNyGzplCUm2xNYlTQBo7WeZh6vXtAhtV/J/Lr0sSd8izdnSOQlfhgDH9jiKtHJ4he/Y8QK8KW7ncydUtJy62XyXh4vrNKK3EvOhvEJpSYvn/5KzGkf5HyLTugxtjShAZnpm1xaGZILqIxcM0qz6KQmL2dLqKnm70zEOJPA3vYn/fy8poCCwkXspitTxuqShCwr/4C1nuVumVNaHIQ8GeW5Or9dsZVwZ/+r8SJuPo5thnfpJ4gTdoRDyidinq+av9pUu/RG8+ALuoEZUcXhrNXqb6dOl6MCh9MN+H/Dwq+onclG4FYYaK/Jkjkffx3p2J0cKdY8LuYcmJ+FbSzdaByRQp7MCZYmy/87kPTLWoEtHXR/D3yUEXoRQhNI5krg/rM566hUSidP+Rni785DNEUAGtIFkHVISmPkXG64Ocv3gcIdinPkanjKZFP0ZzKiosSa9UB6MR5f/FemEcu4WArFA89pKgOb3dpkvUvvArc6NosnYcxSk+fqkttI3OqhUem5y3apzOalFDBB7LtFIbbMoG3W9GlH7AYRkoWyb7BAImwe/oBziwQGfUdNCzpTtl+zkBvYwnMb3tUHsb007+5ifh4DHR/hYqv2W6G5jTyEt/mNQkkYKh+QBZYuiESKwQUplFxC+AQaY8fB5PE/rFnbu8wbVqtUEqDHXH7E8QtO+iGiQyslC25yfHGGqvsU8NSOL64hcDOOc2xGVZOhz5uh5b8zY5pP6W1X7YC9aT/2xK91AF28IGtba/84dJMLXXGV1DBu0B+PYqH4U7K7yzuHs
 wNqq3WBZ
 WW32YiB2DMJ9OJ+2w1jLTLLJJCzI1vFRKI6Rsf88sIshkNCV/KHo9L6n91sAG1NrVh0+8hXyz34yhbsmyXWSgyWAjA/w82LLhMVB8RzXFEenShNY4dAWYcbbJ0fNI1kgM0mSnrtEeVySnsv/DM5DKwYfGkPaWOdjN9TIGTrKzulDSI8qagn5vxv2oTdzPrvCn8tdWcMSJAeyadfwRPI67KBJnGK2Byr9U1UcNoCHY2iizYf/cp591hX2dNouT/iSHosfKFuQ+ChLHGip2ErtFDKN5r22eN8RA7yvRtH8ZYZSaN7mGJE0YNQoyZ0hzr5NN989DgI0VffMQkvLOABj+HlzzYxSzrKRrTOV7lO0/3BtV6ozEjZiWNAkFVVI7dP9p65did+KQ8+vdiwOhbiwH9ZAMhDSsbZk/uHs6IOuwBHy6lrgCwAz3kJmE0Z3jb0/ZCVf6gluprRSBHC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Like optimization, vmemmap restoration operates on one folio at a time,
but the current interface exposes a raw address range and requires the
HugeTLB caller to prepare part of the operation.  This splits the common
mechanism across layers and obscures its natural unit of work.

Make the folio the unit of vmemmap restoration and move the common
mechanics behind a folio-oriented interface.  This keeps HugeTLB-specific
eligibility and state in the caller and gives both directions of HVO
consistent folio-level interfaces.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
---
v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 37 +++++++++++++------------------------
 1 file changed, 13 insertions(+), 24 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 14390ee59ba2..465a907620ab 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -363,28 +363,29 @@ static int vmemmap_optimize_folio(const struct folio *folio,
 }
 
 /**
- * vmemmap_remap_alloc - remap the vmemmap virtual address range [@start, end)
- *			 to the page which is from the @vmemmap_pages
- *			 respectively.
- * @start:	start address of the vmemmap virtual address range that we want
- *		to remap.
- * @end:	end address of the vmemmap virtual address range that we want to
- *		remap.
- * @flags:	modifications to vmemmap_remap_walk flags
+ * vmemmap_restore_folio - restore the vmemmap backing of a folio
+ * @folio:	folio whose vmemmap pages should be restored.
+ * @flags:	vmemmap remap control flags passed to vmemmap_remap_walk.
+ *
+ * Remap @folio's vmemmap so optimizable entries are restored from the shared
+ * tail page back to distinct backing pages allocated for @folio, while
+ * non-optimizable entries remain unchanged.
  *
  * Return: %0 on success, negative error code otherwise.
  */
-static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
-			       unsigned long flags)
+static int vmemmap_restore_folio(const struct folio *folio, unsigned long flags)
 {
 	LIST_HEAD(vmemmap_pages);
-	int nid = page_to_nid((struct page *)start);
+	int nid = folio_nid(folio);
+	unsigned long start = (unsigned long)folio_page(folio, 0);
+	unsigned long end = start + folio_vmemmap_size(folio);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_restore_pte,
 		.vmemmap_pages	= &vmemmap_pages,
 		.flags		= flags,
 	};
 
+	start += VMEMMAP_OPTIMIZATION_SIZE;
 	if (alloc_vmemmap_page_list(&vmemmap_pages, (end - start) / PAGE_SIZE, nid))
 		return -ENOMEM;
 
@@ -402,7 +403,6 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 					   struct folio *folio, unsigned long flags)
 {
 	int ret;
-	unsigned long vmemmap_start, vmemmap_end;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
@@ -410,18 +410,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
 		return 0;
 
-	vmemmap_start	= (unsigned long)&folio->page;
-	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-
-	vmemmap_start	+= VMEMMAP_OPTIMIZATION_SIZE;
-
-	/*
-	 * The pages which the vmemmap virtual address range [@vmemmap_start,
-	 * @vmemmap_end) are mapped to are freed to the buddy allocator.
-	 * When a HugeTLB page is freed to the buddy allocator, previously
-	 * discarded vmemmap pages must be allocated and remapping.
-	 */
-	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, flags);
+	ret = vmemmap_restore_folio(folio, flags);
 	if (!ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
 
-- 
2.54.0


