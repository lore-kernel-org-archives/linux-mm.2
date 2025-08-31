Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2940CA0FF2
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 12:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D2B58E0003; Sun, 31 Aug 2025 08:11:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AAD78E0001; Sun, 31 Aug 2025 08:11:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F02738E0003; Sun, 31 Aug 2025 08:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D9EB08E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 08:11:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7AB518559B
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 12:11:05 +0000 (UTC)
X-FDA: 83836936890.22.4F73617
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id 96407160007
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 12:11:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BZZ2GU5P;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756642263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JG9B+llAHV7LYg7nSulca8AjjzTpBy37d7vM3/vyiO0=;
	b=GlnJ8R5RFisDxgZosKH6EDddv8HCt7Rvh/jk8oETvkmeIpXaQguCmkY5+wulB2Qqv+OHnu
	hDjrcDu0PEqt1g3572QfX3gZvcBekkYV8YbeLlTzJ4VbmDezG4G+1lcSKvUfVPqy9l9zzr
	TANZiMWJ0x9LmFX5lzS0srA/H981ZyE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756642263; a=rsa-sha256;
	cv=none;
	b=WQq+eUnIXn3gCJd0is3VCq+A83r9Nusb8LQBeeUO3Cw76FQhQjnyp+QrQZw1sRj9IjBzZ6
	IxV7RnLmG0b5zdBIyl++CHL2KMVc1hg2E25ezbFxcm0i41Vgp3a03Tr4GgRNGmfaAWevRF
	/RTAniBsWvvk4YbDtbp/6j/GTyPUpjw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BZZ2GU5P;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-55f6bdcc195so1604209e87.0
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756642262; x=1757247062; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JG9B+llAHV7LYg7nSulca8AjjzTpBy37d7vM3/vyiO0=;
        b=BZZ2GU5PqRgtpb9QX1V7byAfLmzbHC9yRIh91z/LpTcuIlGLNdIA+hvKZzwJ6Qt14S
         Bu88gQ5YmsE5e6so3uFz2s7X1Dd2w5mtxYi2C8rktsbzCxNQ36dgNq/BnNuUvuhDPlsQ
         ukVpbRpk3znixLoFOH4wHYj4X2sCWdTOwbcGMRhCsVVFL3mY68BsnUQo3bAYKBe+8X4F
         rMY6JqoV7aBJJVh9DSUQWilQum/ff1C0o+0SOVqRbhooewKHgtnXKZkY+VV3vVkxeHns
         GIWE5/vraKGmpLwiEY4e/uK7z4jn2IackjgJ6FkIo84Jh9EJtuYv1yMw3PuwjESfcPoP
         XlFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756642262; x=1757247062;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JG9B+llAHV7LYg7nSulca8AjjzTpBy37d7vM3/vyiO0=;
        b=uhb1hzKcUaH8hmtlra/yeWmvAvZEgXLGWtl9YaF1LnIsZJ9HKAF4fj+twUWXJ2xpx6
         /uMyDdZ9IrZSPPrXFEnfQ907TK+zxxuXF+PS5I5TidshJjVtrSNXxNI40NFkbMdQZyNi
         qWnpFIy5t9kjFTkoLI2WSQnVNqYlIu2bhPcFIt8V2dBd4+lJY8xxxiEu7DASehNvlEZS
         6D97GUp463WxhqWrFZo7FIXpB1lypEySGrBHE0Ue2R7qkiX8uJSLpJRVHNE6CBzT6+DF
         4Wi9KNWlOf3MsqgD7e0WPSEuWVnbknSwkV73TyOSJc7zS/DW0AreRjVyzn77vInM17iL
         uEdA==
X-Gm-Message-State: AOJu0YzeAbzlSuMxSjW+6hnZQGWMGgElr9MQwnLQzlWgT7x6WmBnPgpx
	Z8SRRtK3jtkRcalWo0eYo/uJAO3dciNmuN14my3eic0Kgw7+IDU1mkSxDriS5fAD
X-Gm-Gg: ASbGncsAZ1yuNZm2Qqt+l6UWX/1DIGEnOmmbaMn+S+ycTZzT3ozEfxMrZNAt/w/o787
	c7UcdxlryTpmGrs5WL1Q8JygDQax9Bc1MdJjgXJ9sD2X6n5a46nTLD90Z2D1mAPXa9rIQ9R3gRR
	c3EbpXfLyY08O6ZRcdR8QN5zBj8RgLscGkiSkapk5r74rt/K3CrvcKzTTCcFGiUMdWeV13OkVJW
	ob/F6Oumrk+27AvHxto6r8WpzrvavYLPrfnsW28DvdDIPY0p6EBaGH5poiQKqUyE5GU4n5l/acr
	vuE5YHnxR5dObF9Jf9yQsDb1JjoByLlc8rZyd2MyubJO9WRTFXfru9YlniSHvYQiCa+sxx1YF81
	xq7pgVOIoIRrzK5stYtLYYGye80VY
X-Google-Smtp-Source: AGHT+IFueuf2oZt8S2Uk0qkd9+oS33qtaqyqR6ss70d2dMC/0TmF2R5rYRs5z4E0tLgmfioWY9AQ/A==
X-Received: by 2002:a05:6512:3491:b0:55b:83cf:b260 with SMTP id 2adb3069b0e04-55f6f6c39b1mr927648e87.11.1756642261264;
        Sun, 31 Aug 2025 05:11:01 -0700 (PDT)
Received: from pc638.lan ([2001:9b1:d5a0:a500:2d8:61ff:fec9:d743])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55f7a3bf9b4sm279519e87.78.2025.08.31.05.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 05:11:00 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/vmalloc, mm/kasan: respect gfp mask in kasan_populate_vmalloc()
Date: Sun, 31 Aug 2025 14:10:58 +0200
Message-ID: <20250831121058.92971-1-urezki@gmail.com>
X-Mailer: git-send-email 2.47.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 96407160007
X-Stat-Signature: rkxau6hy6s95g7i3fq513n5wxght5gre
X-Rspam-User: 
X-HE-Tag: 1756642263-511185
X-HE-Meta: U2FsdGVkX1+H+uc8n8f13/nndflxRIJFGFOdbYEgrSGDLEdUVVz0K3W6wZIOwTWMDMDHc6aNlatisIrQWn5mur/y9DXQbSDxaKc5YV1hNjUgkgvQFJAjjWbhp1c8b4MhQWLI+fP2tJnclHEQvlF5is9pVij11i4XDCmrF/mgyef0zI3hPCAhN/xd2IflAJt21oZoUJgxII5t4H6GsjDAIUXyz0xV5aExgQOX/9WKCODbyfx893jI2UtuxmvuoBXgGVEqWGPxpdJJxhDSOPzXrJVLkMk0zFoICQ3YaQRkZLB+N81Wt2b6pfrjhwfPOKMiwHj8ttSPX7oYceq89BuZ5KspsEMFKUNHWO8m06/VzeWq5MeBLImX0Q7QkJTqfBwjl8E3CQbzkysoV24WlhJSGsKbmXwwQHTnQWRtrVG+Hipt9osDQzaoN6S9tssb7WTjktgknoX93dID7fE3aW+4Jv6Hc1Q9yMXRXaVUTDY/GUkmRZU3PgsgT7RErCnLv5IAO8D158U7KpRmwmVLuPIt01Ylnd7yCjwvFKtaH5hbdbmJDzXTaoAtth8SSSYZ/FnvhMNcteLV1TZqLXf0JT9M87euGRm1G13aUU6MXoErnU8+3+qzS0Kv7EqODGeFOtoQsjEVnKfNLF3EM+AcJxrCnZOle6CPhP2hxstsbA6hKkNQOENw3h2jI9P+J3H6VXxiSNiuMWJs1jIoWMJ062xZq11SrLZup2u6bSVucLy7QkOv6keJ1OzaLCDcoG04A2Oeuz5db+utV0g4VPGaZGx9M9tsUu0N8KeXFZv1T2bITwavkKTnYTc3a+GvT2eJJUjGRq7EWd3huHjMMoA8AjXsBiYDhF4zxe00euuLEoAJslRSZ+gM2nRAs/oi+WT0xHOn1kLDYjhgJ1lKYqCY67mSG0WMii4eLhrTmD30nubLK9cGFl7DnUItsaGTGUAWqfnzVmve6suZakus5JQTFp8
 3f1sfnj1
 0lu/I2TglWoU4MMBJRwYjaDP/8K2BQLOlI9Qa/fwuwFdwmd9yJ0XuykWpYWa07I5zn8dkoBtnnZevwcxVAdIDA86mV+GM32uRLuRAEl7wSzf3E8khsgKZKC31ITmkeqTsWMaas/Qxh56fU8QCp12CQLf/lywkp3s84EhoiD+v8yL8NTz3JC+Brh63RGFyxnuKkioFRwwZ79r0VITa+46cPRbDLWqKXYwIDlRu23Lw9GhIoSwpkPwe2P+wWYb4kfCgy/wMj3aVzGP/bRUaS07MQ+HylqTHQHj7aF2IN/zRShVob9c/+FUfuo5RKj959LMDEqlQNypA1UDi3anNTfOqidlVV4iHDcSQ4P0OqYilviuIwozSkFPAH1QHcO4syGU7qbo/TnNnflo8fIFxAEaSYHkkV9iBrWUapvNcIxNGI4eCQc+qXX01Nm4jM2iQIuaZfPH4RM/iSLeSfTaGgcFThz9OsLJA9yLyDu0gKelM8XoQTae8c0XX8bu93o6fZwO8GLDbVCddzaF1ly1io8DDBi+Fuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_populate_vmalloc() and its helpers ignore the caller's gfp_mask
and always allocate memory using the hardcoded GFP_KERNEL flag. This
makes them inconsistent with vmalloc(), which was recently extended to
support GFP_NOFS and GFP_NOIO allocations.

Page table allocations performed during shadow population also ignore
the external gfp_mask. To preserve the intended semantics of GFP_NOFS
and GFP_NOIO, wrap the apply_to_page_range() calls into the appropriate
memalloc scope.

This patch:
 - Extends kasan_populate_vmalloc() and helpers to take gfp_mask;
 - Passes gfp_mask down to alloc_pages_bulk() and __get_free_page();
 - Enforces GFP_NOFS/NOIO semantics with memalloc_*_save()/restore()
   around apply_to_page_range();
 - Updates vmalloc.c and percpu allocator call sites accordingly.

To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: <stable@vger.kernel.org>
Fixes: 451769ebb7e7 ("mm/vmalloc: alloc GFP_NO{FS,IO} for vmalloc")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 include/linux/kasan.h |  6 +++---
 mm/kasan/shadow.c     | 31 ++++++++++++++++++++++++-------
 mm/vmalloc.c          |  8 ++++----
 3 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 890011071f2b..fe5ce9215821 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -562,7 +562,7 @@ static inline void kasan_init_hw_tags(void) { }
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 
 void kasan_populate_early_vm_area_shadow(void *start, unsigned long size);
-int kasan_populate_vmalloc(unsigned long addr, unsigned long size);
+int kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t gfp_mask);
 void kasan_release_vmalloc(unsigned long start, unsigned long end,
 			   unsigned long free_region_start,
 			   unsigned long free_region_end,
@@ -574,7 +574,7 @@ static inline void kasan_populate_early_vm_area_shadow(void *start,
 						       unsigned long size)
 { }
 static inline int kasan_populate_vmalloc(unsigned long start,
-					unsigned long size)
+					unsigned long size, gfp_t gfp_mask)
 {
 	return 0;
 }
@@ -610,7 +610,7 @@ static __always_inline void kasan_poison_vmalloc(const void *start,
 static inline void kasan_populate_early_vm_area_shadow(void *start,
 						       unsigned long size) { }
 static inline int kasan_populate_vmalloc(unsigned long start,
-					unsigned long size)
+					unsigned long size, gfp_t gfp_mask)
 {
 	return 0;
 }
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index d2c70cd2afb1..c7c0be119173 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -335,13 +335,13 @@ static void ___free_pages_bulk(struct page **pages, int nr_pages)
 	}
 }
 
-static int ___alloc_pages_bulk(struct page **pages, int nr_pages)
+static int ___alloc_pages_bulk(struct page **pages, int nr_pages, gfp_t gfp_mask)
 {
 	unsigned long nr_populated, nr_total = nr_pages;
 	struct page **page_array = pages;
 
 	while (nr_pages) {
-		nr_populated = alloc_pages_bulk(GFP_KERNEL, nr_pages, pages);
+		nr_populated = alloc_pages_bulk(gfp_mask, nr_pages, pages);
 		if (!nr_populated) {
 			___free_pages_bulk(page_array, nr_total - nr_pages);
 			return -ENOMEM;
@@ -353,25 +353,42 @@ static int ___alloc_pages_bulk(struct page **pages, int nr_pages)
 	return 0;
 }
 
-static int __kasan_populate_vmalloc(unsigned long start, unsigned long end)
+static int __kasan_populate_vmalloc(unsigned long start, unsigned long end, gfp_t gfp_mask)
 {
 	unsigned long nr_pages, nr_total = PFN_UP(end - start);
 	struct vmalloc_populate_data data;
+	unsigned int flags;
 	int ret = 0;
 
-	data.pages = (struct page **)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+	data.pages = (struct page **)__get_free_page(gfp_mask | __GFP_ZERO);
 	if (!data.pages)
 		return -ENOMEM;
 
 	while (nr_total) {
 		nr_pages = min(nr_total, PAGE_SIZE / sizeof(data.pages[0]));
-		ret = ___alloc_pages_bulk(data.pages, nr_pages);
+		ret = ___alloc_pages_bulk(data.pages, nr_pages, gfp_mask);
 		if (ret)
 			break;
 
 		data.start = start;
+
+		/*
+		 * page tables allocations ignore external gfp mask, enforce it
+		 * by the scope API
+		 */
+		if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
+			flags = memalloc_nofs_save();
+		else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
+			flags = memalloc_noio_save();
+
 		ret = apply_to_page_range(&init_mm, start, nr_pages * PAGE_SIZE,
 					  kasan_populate_vmalloc_pte, &data);
+
+		if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
+			memalloc_nofs_restore(flags);
+		else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
+			memalloc_noio_restore(flags);
+
 		___free_pages_bulk(data.pages, nr_pages);
 		if (ret)
 			break;
@@ -385,7 +402,7 @@ static int __kasan_populate_vmalloc(unsigned long start, unsigned long end)
 	return ret;
 }
 
-int kasan_populate_vmalloc(unsigned long addr, unsigned long size)
+int kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t gfp_mask)
 {
 	unsigned long shadow_start, shadow_end;
 	int ret;
@@ -414,7 +431,7 @@ int kasan_populate_vmalloc(unsigned long addr, unsigned long size)
 	shadow_start = PAGE_ALIGN_DOWN(shadow_start);
 	shadow_end = PAGE_ALIGN(shadow_end);
 
-	ret = __kasan_populate_vmalloc(shadow_start, shadow_end);
+	ret = __kasan_populate_vmalloc(shadow_start, shadow_end, gfp_mask);
 	if (ret)
 		return ret;
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6dbcdceecae1..5edd536ba9d2 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2026,6 +2026,8 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 	if (unlikely(!vmap_initialized))
 		return ERR_PTR(-EBUSY);
 
+	/* Only reclaim behaviour flags are relevant. */
+	gfp_mask = gfp_mask & GFP_RECLAIM_MASK;
 	might_sleep();
 
 	/*
@@ -2038,8 +2040,6 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 	 */
 	va = node_alloc(size, align, vstart, vend, &addr, &vn_id);
 	if (!va) {
-		gfp_mask = gfp_mask & GFP_RECLAIM_MASK;
-
 		va = kmem_cache_alloc_node(vmap_area_cachep, gfp_mask, node);
 		if (unlikely(!va))
 			return ERR_PTR(-ENOMEM);
@@ -2089,7 +2089,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 	BUG_ON(va->va_start < vstart);
 	BUG_ON(va->va_end > vend);
 
-	ret = kasan_populate_vmalloc(addr, size);
+	ret = kasan_populate_vmalloc(addr, size, gfp_mask);
 	if (ret) {
 		free_vmap_area(va);
 		return ERR_PTR(ret);
@@ -4826,7 +4826,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 
 	/* populate the kasan shadow space */
 	for (area = 0; area < nr_vms; area++) {
-		if (kasan_populate_vmalloc(vas[area]->va_start, sizes[area]))
+		if (kasan_populate_vmalloc(vas[area]->va_start, sizes[area], GFP_KERNEL))
 			goto err_free_shadow;
 	}
 
-- 
2.47.2


