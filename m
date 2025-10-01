Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A01DCCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 19:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 291978E000F; Wed,  1 Oct 2025 15:26:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21C1E8E0003; Wed,  1 Oct 2025 15:26:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E35B8E000F; Wed,  1 Oct 2025 15:26:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1FB48E0003
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:26:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C4FFE1A0259
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:26:58 +0000 (UTC)
X-FDA: 83950528116.19.CC707C5
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id D7ADF140007
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:26:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h+CHSpE+;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759346817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ynvmccn9zBZNQHviUDaoxb4f3kqsprve2CRTYJdnjMs=;
	b=BDv4+9BLgjI+NaiwK2+E8/8d0cUCx1X5lVHLnCP93v2GA61s0aEGjtH9hMMsaR2QtZ2tfG
	hIx7F9Neze8iQNR1SyUFkh4F5ZDd1uvRUCkity8eWn2O57FocAH4DDFRVDGh1klRt/KAu5
	YdMCNZlfyZwrq/tlgh9jDPrdKeD7PaI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h+CHSpE+;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759346817; a=rsa-sha256;
	cv=none;
	b=hSVV7evJYhUsxbWbPnRgjpf8vFWjS7CsECOBKS95F/trlvxDNwwb4ugbwo+JnDnzAabNeE
	6p/FygTYILEID3P5U5gIbmv9p+HegM2KxCdxNAB39XAeyxBaLcJKo4k9GQZusbkh9m1ZRx
	Dr5PYyv8MvjTBqHQmdeR/rlrpnABszY=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5818de29d15so221703e87.2
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 12:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759346815; x=1759951615; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ynvmccn9zBZNQHviUDaoxb4f3kqsprve2CRTYJdnjMs=;
        b=h+CHSpE+MAwHXQKEuqjta8kKCFKZRGOJdCvqurAG8ZpdpJzin04a+xIsGSVtKzqWjV
         g5+767rMZpr7pCHgntJiLS69zbo4mkM/mmGaugtmiES2paegu0rxohdZrO9j0cQx6541
         KzKSos6l12HpkJngNJ7i/bRZffucoMWh5ujQQX6Vf9A/47GEGg7EMZ0oXpgirZTH3IfE
         /zKaqgKHbw7xclR74FFO3ds9Fk4lSLVin8/XfOMpJBWMskMIFwE8Mh/puMmPUGs2aN9d
         hDQamU4xreIkcy7SnFT8C+ZoDMs2sypB+6xQXK8wy1VxnRNc47C8KOSMg3KRRgIl2vgT
         5lzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759346815; x=1759951615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ynvmccn9zBZNQHviUDaoxb4f3kqsprve2CRTYJdnjMs=;
        b=adEc7AtynArIWTO+eJBnoUkltkPtUzHbqXyk8EdR2hYqI9xlBcRZwZsY13M9h6QLrM
         R2CnGda/DIdoWhcXqC71hp2aKmh55g2vmQ545JZRbbXUDpDxPOoGcOoSy0e+Y0dI0Jk0
         vmgU8vM+LIriUN1VPkVkOojlD4mPIAr0hQICWUCDgWUL4UVXtMfVJASEkkK/lNGL1Ktd
         jzWDyfnhTv1BUQppt9eupAlPf99k/P2up60EJzVeqJ7xn4BIPfsP7NTOt8UzfEXQaxjP
         +JYJ5sDPiZqjjtaBBa2HcOTOYzw4gqiXCatxG+z64J4qnZjevavrZMNq3keqLHHtyjFC
         kgVQ==
X-Gm-Message-State: AOJu0YyBE8DPwmnb6xlGXJ+sbpeF0KcoxOgQ70CDWBj97jbvM82Nh9Sh
	FFrRBn4WxwPOWAx9q/hlnY6lPhM3LNyOVbIOtTnHP8bSQnt4HovQrIlZfW4m6AcNR7s=
X-Gm-Gg: ASbGncujx2mo+PqehERFaDxpdWv095uLgYqeOKE6TEfuSEWK8gSBx4EUA9ynB51kViz
	Vv5NPuXZdlMVkRSl/90AJFI/8OyT5/+xjtRY9sHMFic2NmWVjtWNT/CMRAWqgwEwhoZVl9T8hxT
	EFTmlPnmR9FkMfiaFu9WG3z4t49BgvQAvC371KQjhYPz1ZQoCWY5vW7vpbYFRE52us21RxsldeZ
	VW+jqjZLQ/mhRdiof2B5UM0IT632HXnHwgq25z4aDDNArE5NXPpDogX0N8ng97+wC/WgAfImXvK
	mmPJRUn8Q/LUUvs6E0kXeZXNKVNlkBSwazeJ/XYWoGqLdhqfVCRw/H2WNGAiUsYyOfBcTKDceMp
	ihoRXTr2AtsPWr3Av+7lyRUE9yCrLrLgYrQL5msGG
X-Google-Smtp-Source: AGHT+IEdomr7Qvfls97HYRBk5Mx/YGp7v9+/XeOoVOqM7iGX9Gve8C9BG6twnSsknG3MVOR88kGX0g==
X-Received: by 2002:a05:6512:31d4:b0:578:9b92:75c7 with SMTP id 2adb3069b0e04-58af9ebced0mr1554547e87.7.1759346815008;
        Wed, 01 Oct 2025 12:26:55 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b0112414fsm136627e87.28.2025.10.01.12.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 12:26:54 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>
Subject: [PATCH v3 07/10] kmsan: Remove hard-coded GFP_KERNEL flags
Date: Wed,  1 Oct 2025 21:26:43 +0200
Message-ID: <20251001192647.195204-8-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251001192647.195204-1-urezki@gmail.com>
References: <20251001192647.195204-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D7ADF140007
X-Stat-Signature: gkwd1xq9ou3ykan8ibtwbr6myathh1nr
X-HE-Tag: 1759346816-905781
X-HE-Meta: U2FsdGVkX1/2brKNMxvvXSgjnVOQyYA8K6HuCgrA8/5jPg8O1YnW2nSCIgJvjxQ7ty42RIDUesVhhplfxCC90Y+NL4EcgUIcExaw6UiwKPN2xMUdDibDlVP7DggeRdqNxlXMDlwr2hDO/LZI6M0k9aORIoCCl2PArGof9ruP5R0+pcB9ANhAqB+mphT1FkWFAEOS/bIzI47F9FsSxKNTu5Uto1uLaHQpA+eHY82BiTvHn2gD+WxlXbGh2C1OzaPp/nr/fUX8o5b9pQIhC7fUIlb0V2SWhnzo7gkPe1sTncfC5nli71GPfQUr9VGyGpJP+KvK3qfROVHxssQvus5J4oUTq2dvs5CSf7C1voqUZnJ8GwA4LXzAJK61TGUn1tSLinDQfEiMwBs7F5aREh0NNAV3p4vlIsJ1kfUKmkunCBwW1hsv4NqrO8mSq9yKOCLSNl0k0IMY8A8XN90L6+uK7V57LuBBzo2gcNDPBIK9/N8PkzSFX4YFBRj9Lt3kravOQXjq+F4nvNhK09Bs5taGIdbYxxSJjIz+EcJENxopziKQtmYHPAJk9YBMHq570ekG/HiGhr5mn4aLGcDcbfenYCzuD9pRyvkAGPHVNpCaEUNpxOO53hPCnfIy6WE73cv+2qeA35M59VJUU9aEZv7K5K8TsotMVHTPgIfN3oHfgWkayue7uHZxBXnBTdrA8b9IJJMYIu27i5NEEomkJVRcMY2X+15VfNC1jD4KKXd3SIaGm0IEBkTOhtMYmtX/bCnDn6eJaxB8ULhWyLv1j5ISsyrT1zPZ2IlI/EXgASKFBn4zoWnFT4JLrvmpeyDiMFPrFimUUPjXWHvGPclaLphFSLevn3jNlzRNsFAzg0djh6jR7JU1FfA0jRMp0ODIkcvY6TtSq1xDmNAiefGDWIygOu0ESlduA6vkgnVl5t+OZeIsvSLUnLnx7drsgNotJ7rWEjj3I3vG6Zv24rninOh
 lH6zgyc/
 9eHApA56p1DtJopoAq7z1DXkYi/pdmD+YHK0UIhhnM12/5cN3O8WvrU6FcvJQ/eW2sTsT8XhBIQUMSkFYDhW9wr/jnheAlZbxItKJLc5/0YucYRHORcxRqWJVrRK3X5G6Q5y6/UM9YM4w0putt3u1e/cw9fIHjGLNLHhz0LZLhjZDYs/IxjTl4L02Z6PSzTZ34etqjknWHK3uUxC+z2UqzKc7Fyj+8AVBiCd0I3y8+re1Dz4fYzvInPuCRn1gv0nHHMVOKBx8w2FqhCVkonr/A1QkSknBSUV3aaJSRZ7AbT27p+f714bHUh81IiicWjmdyGRYKVkYeZrqWs1+y9fyibboDInaQu2fdCkoSXmMmsksfiOs1kJMguZlhhUJRiTuXnQ5jhImBT22Z4gCzpWvSjIDVeFgqgp1TlX7kvldJS47VZMBEmEga1VuClvW3fuHXM3sJpEIY96eYHCH1G5iqYamfBOHE+fdL8Y1AYSyS6haTdQ=
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


