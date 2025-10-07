Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD4DCCA472
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 12:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46FD78E0016; Tue,  7 Oct 2025 08:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AAC38E0005; Tue,  7 Oct 2025 08:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225878E0016; Tue,  7 Oct 2025 08:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 07DC68E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:20:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA236160152
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:50 +0000 (UTC)
X-FDA: 83971227060.18.ACD5348
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id BB4E41C0006
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O64vol9w;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759839648; a=rsa-sha256;
	cv=none;
	b=PVIjB0X5L76eKLLqQWN7Veig4H5uOtoRd2lm/HN2cTmhpsteoLUH67+frYxbS8xWRQP/Pe
	XiNjnJPFCrIBpQCXigs3WAVaCbxKtIp6UHPXz0uDm1HePrCEzEBpbfBTCfDvoFfJ1/h5OF
	pGTXuDtUjx/ZwJ3wgT8pG7m9C/kcgFY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O64vol9w;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759839648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ynvmccn9zBZNQHviUDaoxb4f3kqsprve2CRTYJdnjMs=;
	b=KNIntNOM2B+t3c26dTpaamC0L5HHv3z5qww4GZPPU4W7coi+YYpMs5fp2QC7zzODaiolD1
	rX228xauhbmp0gsDFxHqvy7E5HXNQPvmFTHEvItlix/70ic3X+ikkVzhds6Bk3KnI04zaI
	ZbwH/qRS00RczUti+Ksv8wvMk2emvA4=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-57da66e0dc9so6118478e87.0
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 05:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759839647; x=1760444447; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ynvmccn9zBZNQHviUDaoxb4f3kqsprve2CRTYJdnjMs=;
        b=O64vol9weZIE+RHCvLmpZbBN10L8OfuddFHW46RRS/vW4+VlmnoaEw36wAnEkxPuVy
         lGBgd0lm2fS1U83xtIerH1hwypogMM9LWKJ9Y135HjHLnFKuO9M9Vf8+EqkMf/ud5ep8
         WdOJ5LB85LGjRAocvCMY0wTgDx5Z8i6JKduGVdBm1mCrPVgFQKpIOzM4+2AdrlnCxiY2
         xSBlL2+trvzlzZ8SyLvVtcykfNc3IYL41LhnR+jx2sFMH1bwaE77ZWj0FwNl1jwsXOT/
         ECCYJKpAxub5B1aGiIGaHKU34dsrHCsrXpiRXVW1Oy3nbcTo0cCf83e5Nr8/wXRK9hr4
         4bxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759839647; x=1760444447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ynvmccn9zBZNQHviUDaoxb4f3kqsprve2CRTYJdnjMs=;
        b=sRCvVFn54RY6AnlpLe9lA3Jn1NwHkjf9xZ0FwqW2t/i1ynhdllrLkuyJiWOc01Ywsr
         YLIXRzqoL0kaZzaJ9fluykVV7zM7zNfmwbF+XWN1RxkQ1z4ZPpoSQSGXBcAiMjBgEFlC
         yudYLQBvz71saXyhnzsXyfmD8igIlY/e7Y+E5e6JMC67x8rDUmXPYHVx7iDlF5DZCs2m
         MTA44n9GFGQr8IaazHufAgP0R8KXzBVAOR4VzZvbScF/AFuZWmQfFFbykTvyHUgQ0bZd
         8geL/Dda+uJoSs1ZLvCs/e0Vplm/u/4/1A9WJbvPOBm34IzvvWnl8nTqz5/y4YE4H2/G
         5usw==
X-Gm-Message-State: AOJu0YyizpizNYYhdbXq7G7BYIPayM7OUQxKFphhD3w87gfOc0pfiDMz
	B2bIXfHeAPf5FWfhgSiCnBWPg7cWkfaeovdlWAVgg7a+HObbycYJbB9X31Jbvqmd
X-Gm-Gg: ASbGncvBPL87Q+J/L7415Rfhk63intmn0bT3tOsGTBfJaG6oTVnevI44vNKYdCoAWoz
	AqJq24wPeBQSjWLrrkNhD8yc7Ng1WLzUPsxYOMEiTBjgDlBBlmk1FA3kdkJX/iuMAgdQGQ3XZ5B
	8YIzVObin9TlwU5q0u4WGI43/Kww3iB4dROdCXBZHhuPoHzJYQ4yyMzqlo1AocGpSbEUbT5sIuP
	tyPcbatPfHVoTMCo8E7YReAQMOv9ow6PsxChjiFvGQWCj2S46rgXhArfWXxQEJmr+NanydNValS
	+K7que6rFwSnkb6tt7szCQAk6CT3JwDkGbo3mguizU+aa1LaFbntS9N+1bIh7g9til7M5duVFgw
	D5XOYFwIegjSsTKZrNn/vOqtHM5JBcPPVHIPr4Kb5IFfjYhWy+Lk=
X-Google-Smtp-Source: AGHT+IH105Fru7ZMF2Ka/VGHrM+Or9jg6datvNtRkYwVYlEhOQfeSumqPhNLqAFC6JxvJR07P3hoyQ==
X-Received: by 2002:a05:6512:3d10:b0:57b:234f:52ba with SMTP id 2adb3069b0e04-58cbbbee6d7mr4848584e87.39.1759839646916;
        Tue, 07 Oct 2025 05:20:46 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b01141151sm6061947e87.59.2025.10.07.05.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 05:20:46 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>
Subject: [PATCH v4 07/10] kmsan: Remove hard-coded GFP_KERNEL flags
Date: Tue,  7 Oct 2025 14:20:32 +0200
Message-ID: <20251007122035.56347-8-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251007122035.56347-1-urezki@gmail.com>
References: <20251007122035.56347-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB4E41C0006
X-Stat-Signature: fmceagj61wscs8kz6a8a4zy5a4k6tgze
X-HE-Tag: 1759839648-951422
X-HE-Meta: U2FsdGVkX18Z7xhroWNxU3w/U0WkOq7lMHHJHSXg9ij8oRvfYP9oz6z/s0QCX8QDlEyffLF9UzHgLaAsewbf3AmNTG8Zw9lFO06hv1S0/0T34s4vyhJCnc4t5zfAFiZQvQgMbvn5narEXCNFg5vutTASlt83o0lEgElmfqZ/9UPxqbLWPCwpns4oUDCX3JDHb9jQHo/q0XkXS2oFM4BWRQfvqBAwa67WOxWxpZZ2B71GGT/txycDsfDaPjQDt0LM6h1msvmgD+80LcD0dWI/FTvkZpeddYsI93yNqWH95He4Ppsvl/VS51Bi/NYP+YTxDxtcscO0rbZB8fYPeM3z8clwj2GTqW0v3UM/OoiK2zP36XN38YvaHdIotfYcBZdQrcEGV8YaYQsNiIOrAl1wYcJdbxp60UZiy9o65KkWDKN9cEaebDnJxvmeKg6Qbba+XKO6ZvKkAbxxR9Fp2Mpp1EXOAoVPmjb25S7wY0b2UJapoSMQFbyN0uSVTwOrrr5pVomjJBldWoJNlWPggv5O/Al2kJHYMT/jH62tWsDEd8SlvqiJr+QZIPoKyQaVwygwE/2qSROmCWahThG9tYNpkp99XPrf86kc67JwDu9x1xFr/qHUMv7q5kOpV2Hv3p1uaywfGqv1bna4hSkyBHEzgv3mE0kh3VIUlKcHJUtjzPnaBdd+FTu7JBqbQSdcA9VBTDjeYVdfNFstNjFyhEQLWcDjwdgpXwiOU5YKuWrgIFoDrE3d9OxTF19M+8X3j1AlrRoO3PVCyKsdYVZGC+t4Hnmmlv5fSlGPP6O3rPPGfX5pidP8A8Z0sVE3UT+Nbh4L7+kX3jXDDs37d+NSMf31w+0QDm0iRPiZkHGNVbG26ljqPQaA+28GEtu2uxmcIi5R9iHM/vgFFuEhB6bXkq9jM8UuefUOuyb/tWaRt+ZulJzn6/TH4IkCitD9VSJ4xbkZT2zGTap1Z5vn/o2xtu+
 eNg0YYjk
 FlObWxDSUm03qyR1tKhlEW6yGKfdzXg2jbvIdUmYddbLSRRYvxCU2rbszTC4NLcfFNuMwKVSvC1VbSgW0yW/VAY+zOaz0v/1N7Or6wDCQOUFNcgPLZpOf0XqUmOrLxpdWFDnfoHWZg7XHFOme+2J3TN2myww2GdewMpGfe/socyFj3Nyi+x8dGf5fCTuGxVG9wI52DuCEdwxrrJgRtjGubVFYz+wJa+TK60uPIGBAIRY8BdrVreE70g1qGDu0hlX9N8nWUyUuT8Y5Swfmn2hEtfyQrueCLpiOnfpQ7yMb069jctsO7oMfewgCns90vT7DUTsgAUEbFgQgHcCtINqgSrOsV1Xh3PG8YRvh/pEnRCWlNdNy+ZtyarKPj7yLgtEFqQ+tBCm67aosa1KeCiy6XOBgeX+N4L3SvgI5MBF5Zmu8kGeS7jIJ/ILu7cqaHuvwhnoowLOUOx0hGCU0Y1vrMG4cTDf0/FR2LTdBfA2XGitOjQKeObgoiJPcYDDeolvu8rF3wybei+L+vlFcEubU22F5Zw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmsan_vmap_pages_range_noflush() allocates its temp s_pages/o_pages
arrays with GFP_KERNEL, which may sleep. This is inconsistent with
vmalloc() as it will support non-blocking requests later.

Plumb gfp_mask through the kmsan_vmap_pages_range_noflush(), so it
can use it internally for its demand.

Please note, the subsequent __vmap_pages_range_noflush() still uses
GFP_KERNEL and can sleep. If a caller runs under reclaim constraints,
sleeping is forbidden, it must establish the appropriate memalloc
scope API.

Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 include/linux/kmsan.h |  6 ++++--
 mm/internal.h         |  4 ++--
 mm/kmsan/shadow.c     |  6 +++---
 mm/percpu-vm.c        |  2 +-
 mm/vmalloc.c          | 26 +++++++++++++++++---------
 5 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/include/linux/kmsan.h b/include/linux/kmsan.h
index f2fd221107bb..7da9fd506b39 100644
--- a/include/linux/kmsan.h
+++ b/include/linux/kmsan.h
@@ -133,6 +133,7 @@ void kmsan_kfree_large(const void *ptr);
  * @prot:	page protection flags used for vmap.
  * @pages:	array of pages.
  * @page_shift:	page_shift passed to vmap_range_noflush().
+ * @gfp_mask:	gfp_mask to use internally.
  *
  * KMSAN maps shadow and origin pages of @pages into contiguous ranges in
  * vmalloc metadata address range. Returns 0 on success, callers must check
@@ -142,7 +143,8 @@ int __must_check kmsan_vmap_pages_range_noflush(unsigned long start,
 						unsigned long end,
 						pgprot_t prot,
 						struct page **pages,
-						unsigned int page_shift);
+						unsigned int page_shift,
+						gfp_t gfp_mask);
 
 /**
  * kmsan_vunmap_kernel_range_noflush() - Notify KMSAN about a vunmap.
@@ -347,7 +349,7 @@ static inline void kmsan_kfree_large(const void *ptr)
 
 static inline int __must_check kmsan_vmap_pages_range_noflush(
 	unsigned long start, unsigned long end, pgprot_t prot,
-	struct page **pages, unsigned int page_shift)
+	struct page **pages, unsigned int page_shift, gfp_t gfp_mask)
 {
 	return 0;
 }
diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..e623c8103358 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1355,7 +1355,7 @@ size_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
 #ifdef CONFIG_MMU
 void __init vmalloc_init(void);
 int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-                pgprot_t prot, struct page **pages, unsigned int page_shift);
+	pgprot_t prot, struct page **pages, unsigned int page_shift, gfp_t gfp_mask);
 unsigned int get_vm_area_page_order(struct vm_struct *vm);
 #else
 static inline void vmalloc_init(void)
@@ -1364,7 +1364,7 @@ static inline void vmalloc_init(void)
 
 static inline
 int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-                pgprot_t prot, struct page **pages, unsigned int page_shift)
+	pgprot_t prot, struct page **pages, unsigned int page_shift, gfp_t gfp_mask)
 {
 	return -EINVAL;
 }
diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
index 54f3c3c962f0..3cd733663100 100644
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -215,7 +215,7 @@ void kmsan_free_page(struct page *page, unsigned int order)
 
 int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
 				   pgprot_t prot, struct page **pages,
-				   unsigned int page_shift)
+				   unsigned int page_shift, gfp_t gfp_mask)
 {
 	unsigned long shadow_start, origin_start, shadow_end, origin_end;
 	struct page **s_pages, **o_pages;
@@ -230,8 +230,8 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
 		return 0;
 
 	nr = (end - start) / PAGE_SIZE;
-	s_pages = kcalloc(nr, sizeof(*s_pages), GFP_KERNEL);
-	o_pages = kcalloc(nr, sizeof(*o_pages), GFP_KERNEL);
+	s_pages = kcalloc(nr, sizeof(*s_pages), gfp_mask);
+	o_pages = kcalloc(nr, sizeof(*o_pages), gfp_mask);
 	if (!s_pages || !o_pages) {
 		err = -ENOMEM;
 		goto ret;
diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index cd69caf6aa8d..4f5937090590 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -194,7 +194,7 @@ static int __pcpu_map_pages(unsigned long addr, struct page **pages,
 			    int nr_pages)
 {
 	return vmap_pages_range_noflush(addr, addr + (nr_pages << PAGE_SHIFT),
-					PAGE_KERNEL, pages, PAGE_SHIFT);
+			PAGE_KERNEL, pages, PAGE_SHIFT, GFP_KERNEL);
 }
 
 /**
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d8bcd87239b5..d7e7049e01f8 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -671,16 +671,28 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 }
 
 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-		pgprot_t prot, struct page **pages, unsigned int page_shift)
+		pgprot_t prot, struct page **pages, unsigned int page_shift,
+		gfp_t gfp_mask)
 {
 	int ret = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
-						 page_shift);
+						page_shift, gfp_mask);
 
 	if (ret)
 		return ret;
 	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
 }
 
+static int __vmap_pages_range(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages, unsigned int page_shift,
+		gfp_t gfp_mask)
+{
+	int err;
+
+	err = vmap_pages_range_noflush(addr, end, prot, pages, page_shift, gfp_mask);
+	flush_cache_vmap(addr, end);
+	return err;
+}
+
 /**
  * vmap_pages_range - map pages to a kernel virtual address
  * @addr: start of the VM area to map
@@ -696,11 +708,7 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 int vmap_pages_range(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
-	int err;
-
-	err = vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
-	flush_cache_vmap(addr, end);
-	return err;
+	return __vmap_pages_range(addr, end, prot, pages, page_shift, GFP_KERNEL);
 }
 
 static int check_sparse_vm_area(struct vm_struct *area, unsigned long start,
@@ -3839,8 +3847,8 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	 */
 	flags = memalloc_apply_gfp_scope(gfp_mask);
 	do {
-		ret = vmap_pages_range(addr, addr + size, prot, area->pages,
-			page_shift);
+		ret = __vmap_pages_range(addr, addr + size, prot, area->pages,
+				page_shift, nested_gfp);
 		if (nofail && (ret < 0))
 			schedule_timeout_uninterruptible(1);
 	} while (nofail && (ret < 0));
-- 
2.47.3


