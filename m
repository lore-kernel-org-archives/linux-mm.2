Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2567CA5FE5
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 20:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77DF86B0088; Fri,  2 Oct 2026 16:05:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708316B008A; Fri,  2 Oct 2026 16:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CFFB6B008C; Fri,  2 Oct 2026 16:05:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29CB46B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 16:05:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9E5C41C3377
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:05:34 +0000 (UTC)
X-FDA: 85278766188.06.6A3DCB0
Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	by imf10.hostedemail.com (Postfix) with ESMTP id D66B9C000B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:05:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eQTWHotr;
	spf=pass (imf10.hostedemail.com: domain of dmytrokoziuk68@gmail.com designates 74.125.229.204 as permitted sender) smtp.mailfrom=dmytrokoziuk68@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790971532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IVNK4JoiucBTLzRok4UL7M6qjfOQzVIKG+cDN0ZVD+8=;
	b=AnPaogFREOjVBu444LC2L7eT4yQwedbibLe2izMxabqv9ewSyGZDlizyeCtrdEjMopIVWs
	0ZjBFZPZ5nFaCQBofD0yH7vtnLC1LZkERCGzVWQ1WQVkDFiOa/UwkYF9s6+zOuPhx+WJh+
	QqAgeZpWgq4Vr3R7h864gUeWlsSiTL0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790971532;
	b=7+vt+s67bS/3iYCr6aC27O2qK4GkIRczG0MYDrJIvAtFdLEGIBmVUgifCLyOoxeUvj7APO
	7A9MPl42evJ7giY1sxZdg2YCGOfoNZoJ5D+V+SB+ijk4zAqaCszHNoAKpGdF+4yl4Le/Ky
	ZQbJNTbwDBeBGEGIircSyrL1K9r2xis=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eQTWHotr;
	spf=pass (imf10.hostedemail.com: domain of dmytrokoziuk68@gmail.com designates 74.125.229.204 as permitted sender) smtp.mailfrom=dmytrokoziuk68@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5ba3ce4795aso3937967e87.3
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 13:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790971531; x=1791576331; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IVNK4JoiucBTLzRok4UL7M6qjfOQzVIKG+cDN0ZVD+8=;
        b=eQTWHotrn5SvOYuuu7HM6nV9bB+tDZ+5fIA65tx4X4fr7Nx7fbTRbxLfBiKHOeng/3
         RDLZiMqagLlPHJ6Yhb3UDiJlZUFhuCuN248bZl2ato002fw7SLB3EtqEnOpgHe+YnQdh
         KGNFbXUa4+vSsJyOfrqBj2kr2s4+GTkgetqxPSK30TyYjcRaBaGlvjf2z6SWspw1jRyp
         o/9+2KFq3EJm1CFQo57vIfWF6PV87FUr0W9aDPbxAAvz3SZvr2f6roAc2K4TyShh48+1
         rPimKvgQcPtHHfbOOu3n8+3sjdtMTcYSD/VbvZopdWNOJ+2oAbdsHv199WRYxUpCiKRW
         yNeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790971531; x=1791576331;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IVNK4JoiucBTLzRok4UL7M6qjfOQzVIKG+cDN0ZVD+8=;
        b=lIXuCICZX0M6yGyp1qK0BeVaom3Oo0xGPMnn8PGtMF2CNswoQ7ZUDyrJ1CPHm3j+/Q
         UkbFw24TipQwOFch5mgSkfarPj0/upripjPaGm0QyYNFJxKMlZfDDEMY0E7P7Cob/MdY
         tEtWE9ie7FTIohyDEDVpCXCqe0XfMRDj7RD9noKESJr5Qj7eRsjn+MEzdpTypTcqRwO6
         ch/xY1uPmsbfeY3fCWKO231bUUTYibfdGnSXjHb6B8ohJAnz9qlFQtlqT1Gc7mbypY0T
         K5eaSJF0wFb+nWoL+IhD4/viMO1Iui/6gJ6kwPc6zvLCPkRYmCgD/BhJwWJWIr8APNsS
         diXA==
X-Forwarded-Encrypted: i=1; AKwUvBxYfwPbqwR5SFKkiK6l0SzR4sMKGfMKvm1+BHRIqvAdHj3mUJj66yAxGMOYHeE10dnxpVTPpHS9dQ==@kvack.org
X-Gm-Message-State: AFq9FYLiHvJnnhgOLPPrHWm1Fscuee3BKNt+YfrK1EUC7XYML3ZXqiw3
	RzsI8EB0QXRbRrani5NhNAHZm3qRgOL0pcKwvgfZ1thIQUKk3KChxZ2c
X-Gm-Gg: AYBFou01/n16ilBOZefxHKCaFTDdIJFBJNklO8noz2CMC0kXaOvF3hxTfEIqmRPEzXY
	9wvLARd0I8nYhR/h76up9AeuBbR+lXKa5DhPdM3U+vhUolDx5R/TCkMQLrQvLVdVfv8e2aEDkZD
	iEZ/wLhDcP6vqWloSLNLGO0f9Nn8iA8aeeAcl39TsIPcA2kI+h4pMClpaGoBNFtlTbE3BVWcIEe
	ea+bygbivHWEyj1NmVGxGTXXO0y548AZZIDdbwzVtUG4A39nfiYUvDoUQVq2Mr4g+i9eZX+UzOK
	5jfU/NRiMkutiUyO6lhvCTK8RY5SFkFxt9qGI2BMwM2wrJHdopbYTUWe31OCfYRIRCW+4RNaKoz
	A40YOTBhZS9EoRKfjd/tRigEFvAKFp/Ogd1Vkk1kqGdYCWvahCq/JnRyjQQeNZIkUNjO6ewHkDN
	kMlT7IX0jiuS9a5eLWw33A8UndpRbX2xmnpIw86eW3Fe026+xOyiPZWsA+g0n6OCuXCdv68tEIC
	GwxRUErJ4e2PfB7h49OwrIgGrrpUkwG3bxfCiDxxhhThkSpQ98J6whjknhiMLO4jkUBJcEnw3/d
	8JJcj+76RjBsfW/rwjWM8c34yRmtcIJEOn2/TI2wgVTflUfQsISEC4q/wNQ+1b8=
X-Received: by 2002:a05:6512:838e:b0:5ba:3fc3:d8cf with SMTP id 2adb3069b0e04-5bb9bc24242mr1151978e87.34.1790971530812;
        Fri, 02 Oct 2026 13:05:30 -0700 (PDT)
Received: from localhost.localdomain (2001-14ba-a052-b900-354c-f1dd-ffbd-a9f2.rev.dnainternet.fi. [2001:14ba:a052:b900:354c:f1dd:ffbd:a9f2])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bb7c78bcecsm1018388e87.15.2026.10.02.13.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 13:05:30 -0700 (PDT)
From: Dima Koziuk <dmytrokoziuk68@gmail.com>
To: glider@google.com,
	akpm@linux-foundation.org
Cc: dmytrokoziuk68@gmail.com,
	elver@google.com,
	dvyukov@google.com,
	urezki@gmail.com,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mm: kmsan: fix iounmap metadata teardown
Date: Fri,  2 Oct 2026 23:05:07 +0300
Message-ID: <20261002200508.546-1-dmytrokoziuk68@gmail.com>
X-Mailer: git-send-email 2.45.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: azm89axqicxaxe51ppqq9sxzb9koqaa7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D66B9C000B
X-HE-Tag: 1790971532-43870
X-HE-Meta: U2FsdGVkX18y5eRNNh4O4jASsoCEITjtv2yhziWENC5RISu5RXrqpDEcMPtzPozYCUgjC6aAPu/Y+oUbBp1MeKvreOTBuplkAzNcrndu3VuIcw8+DXgLRg0DMrtKZ6aRzpR4XU8s+c5ASGPCC/AreMyewzIea+1OL7//joa0qmELdU127fgru7X6OPCj7oJQt5i4xZKAMNc3T7Wswlouy1Iti8TcKQQi+Yktem084QcdufWrupp9ewMD8nXQbAItLbxzUfaU8/7pA2wfOywfVihTCzhkxmvkkGg5Bva2BE6ENLjpF4j8U6qICW0gxBxl8zmEXrzPwBjuIoymk9CVJTwZziIP2GH4KX/4HtA3VNI0ndPme0SEbbdKUfsDZxtR0V68++N5GahWYjwn0MFOv6lMOndP3y/0C1nROMyAKJmoLu4HlJHti/pEBe03yFOLYX5S1fCiJzMY7ErNAlwLuykuLS8FsCcdNqhIF7einCZxhtclDW6h6nVoGn9wWCl1KdVfyfz+np4kML7cq3AkwQKkbA7vRHBSc1K/rZS7wXSI3qPGvHCn8MCNXCSZfrqeiMSNCRKTP19iGLgHIe9aiAN28fOfnZuaVcJ1wWdqah/zEzKqH0TtwBnXwBZXiCzQtf0LWNMqMskMG9Vci2Pug63MvAofZILpRa+9+9XTzwITC59/EL6Py7XlMua9BwspqSJWGc483RWJRDwvW9Bx1EveumtoVnFuXu/ePU/oHVOfa0ZlGU3SFoux2Y2a4Eg4TMAgn30rKHT4/BBm+ltTS+GoL6XoSjclw93n9Vl5TwdWydhmrBz0xkgkVeUT9LNGCzkHrHGMBy9L2t/f43TfQaoW3omhtBs9vOdcdDdLjOkK5gmhPJGP0Iyu6to56il0nqvrZ0pKAWaRoS/xxTZ23aOLKPYR7/yjfym99eZNiuPtvnb0+qE/E9xEVsCaiX5eHU2iHXYpVf7ILTiF1t1
 pHe/AKwy
 kg7MtBulLrvFNfGE6wZ5jCxoU0PHszsATKUqFBG2PxcvCHgKB/f1FW78HFI1rULQvgtlJ+oJXTvNsx3t2Tm2jgceFyfOCeDRAnpylYeSdyUnJSez7tJ/2H8UcerBsX7Wfh4jv8sZYVTh+52O66b1VkqyVlADUB9rk8czNX29fZdv8lmQ95Ho/NIHeJ2FfdVGMPPoOmmC022xihJ2VIX3nk12Pr6Budy5J5KyElPUk3vlPNsTQOknkjSFufsMm9/vmn2acaPe0/o+FLZPsaNbbuHqVNZA4c0HIW+DTFyWDYopPwib9EUmaScAvQGuPhTABzDPdgG24uW2viI4H+/sFejh4c8fzc6AMlrIDgZB9H7/b4FC0M6Va22j5K+nN00IZ25p6gq9+OKEC/5FcGcno//NmxUFipMwCiLgfVYCCnbljG+v7T1pSLSegieL3uyGS7EVDFxjXSEC6qxO6JUvezOvCHpUPSxBp17ZX+NrtaSuU168=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmsan_vmalloc_to_page_or_null() rejects addresses outside the regular
vmalloc and module ranges, including the shadow and origin addresses
passed by its callers. As a result, iounmap does not free the metadata
backing pages. Also, the first iteration of the teardown loop
unmaps the entire metadata range, preventing subsequent iterations from
finding their pages even if the address lookup is fixed.

Factor the page-table walk out of vmalloc_to_page() into
__vmalloc_to_page(), keeping the address check in the public wrapper.
Use the unchecked helper in kmsan_vmalloc_to_page_or_null() and check
for NULL before converting the returned page to a PFN. Mark
__vmalloc_to_page() as __always_inline to avoid an additional function
call in vmalloc_to_page().

Move metadata teardown into kmsan_iounmap_pages(). Free the backing
blocks while their mappings are still available, then unmap each
metadata range once and flush its TLB entries.

Fixes: b073d7f8aee4 ("mm: kmsan: maintain KMSAN metadata for page operations")
Suggested-by: Alexander Potapenko <glider@google.com>
Link: https://lkml.iu.edu/2609.3/12748.html
Signed-off-by: Dima Koziuk <dmytrokoziuk68@gmail.com>
---
Changes in v2:
- Share the vmalloc page-table walk instead of adding a KMSAN PTE walker.
- Keep kmsan_vmalloc_to_page_or_null() and handle absent mappings.

 mm/kmsan/core.c  |  8 +++-----
 mm/kmsan/hooks.c | 51 +++++++++++++++++++++++++++++++-----------------
 mm/vmalloc.c     | 21 ++++++++++++--------
 mm/vmalloc.h     |  1 +
 4 files changed, 50 insertions(+), 31 deletions(-)

diff --git a/mm/kmsan/core.c b/mm/kmsan/core.c
index 90f427b95a21..3ad5f31d56b6 100644
--- a/mm/kmsan/core.c
+++ b/mm/kmsan/core.c
@@ -27,6 +27,7 @@
 #include <linux/vmalloc.h>
 
 #include "../slab.h"
+#include "../vmalloc.h"
 #include "kmsan.h"
 
 bool kmsan_enabled __read_mostly;
@@ -240,11 +241,8 @@ struct page *kmsan_vmalloc_to_page_or_null(void *vaddr)
 {
 	struct page *page;
 
-	if (!kmsan_internal_is_vmalloc_addr(vaddr) &&
-	    !kmsan_internal_is_module_addr(vaddr))
-		return NULL;
-	page = vmalloc_to_page(vaddr);
-	if (pfn_valid(page_to_pfn(page)))
+	page = __vmalloc_to_page(vaddr);
+	if (page && pfn_valid(page_to_pfn(page)))
 		return page;
 	else
 		return NULL;
diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
index 5f1b8053f9fa..24f71bc65896 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -20,6 +20,8 @@
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 
+#include <asm/tlbflush.h>
+
 #include "../internal.h"
 #include "../vmalloc.h"
 #include "../slab.h"
@@ -142,6 +144,36 @@ void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end)
 	flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));
 }
 
+#define KMSAN_IOREMAP_META_ORDER 1
+
+static void kmsan_iounmap_pages(unsigned long start, unsigned long end)
+{
+	unsigned long shadow_start = vmalloc_shadow(start),
+		      shadow_end = vmalloc_shadow(end);
+	unsigned long origin_start = vmalloc_origin(start),
+		      origin_end = vmalloc_origin(end);
+	unsigned long v_shadow, v_origin;
+	struct page *shadow, *origin;
+	int nr;
+
+	nr = (end - start) / PAGE_SIZE;
+	v_shadow = shadow_start;
+	v_origin = origin_start;
+	for (int i = 0; i < nr;
+	     i++, v_shadow += PAGE_SIZE, v_origin += PAGE_SIZE) {
+		shadow = kmsan_vmalloc_to_page_or_null((void *)v_shadow);
+		origin = kmsan_vmalloc_to_page_or_null((void *)v_origin);
+		if (shadow)
+			__free_pages(shadow, KMSAN_IOREMAP_META_ORDER);
+		if (origin)
+			__free_pages(origin, KMSAN_IOREMAP_META_ORDER);
+	}
+	__vunmap_range_noflush(shadow_start, shadow_end);
+	__vunmap_range_noflush(origin_start, origin_end);
+	flush_tlb_kernel_range(shadow_start, shadow_end);
+	flush_tlb_kernel_range(origin_start, origin_end);
+}
+
 /*
  * This function creates new shadow/origin pages for the physical pages mapped
  * into the virtual memory. If those physical pages already had shadow/origin,
@@ -219,28 +251,11 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
 
 void kmsan_iounmap_page_range(unsigned long start, unsigned long end)
 {
-	unsigned long v_shadow, v_origin;
-	struct page *shadow, *origin;
-	int nr;
-
 	if (!kmsan_enabled || kmsan_in_runtime())
 		return;
 
-	nr = (end - start) / PAGE_SIZE;
 	kmsan_enter_runtime();
-	v_shadow = (unsigned long)vmalloc_shadow(start);
-	v_origin = (unsigned long)vmalloc_origin(start);
-	for (int i = 0; i < nr;
-	     i++, v_shadow += PAGE_SIZE, v_origin += PAGE_SIZE) {
-		shadow = kmsan_vmalloc_to_page_or_null((void *)v_shadow);
-		origin = kmsan_vmalloc_to_page_or_null((void *)v_origin);
-		__vunmap_range_noflush(v_shadow, vmalloc_shadow(end));
-		__vunmap_range_noflush(v_origin, vmalloc_origin(end));
-		if (shadow)
-			__free_pages(shadow, 1);
-		if (origin)
-			__free_pages(origin, 1);
-	}
+	kmsan_iounmap_pages(start, end);
 	flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
 	flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));
 	kmsan_leave_runtime();
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bea9f76ed7e7..5fe37ad41f38 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -817,9 +817,10 @@ EXPORT_SYMBOL_GPL(is_vmalloc_or_module_addr);
 /*
  * Walk a vmap address to the struct page it maps. Huge vmap mappings will
  * return the tail page that corresponds to the base page address, which
- * matches small vmap mappings.
+ * matches small vmap mappings. Unlike vmalloc_to_page(), this also accepts
+ * addresses outside the vmalloc and module ranges, such as KMSAN metadata.
  */
-struct page *vmalloc_to_page(const void *vmalloc_addr)
+__always_inline struct page *__vmalloc_to_page(const void *vmalloc_addr)
 {
 	unsigned long addr = (unsigned long) vmalloc_addr;
 	struct page *page = NULL;
@@ -829,12 +830,6 @@ struct page *vmalloc_to_page(const void *vmalloc_addr)
 	pmd_t *pmd;
 	pte_t *ptep, pte;
 
-	/*
-	 * XXX we might need to change this if we add VIRTUAL_BUG_ON for
-	 * architectures that do not vmalloc module space
-	 */
-	VIRTUAL_BUG_ON(!is_vmalloc_or_module_addr(vmalloc_addr));
-
 	if (pgd_none(*pgd))
 		return NULL;
 	if (WARN_ON_ONCE(pgd_leaf(*pgd)))
@@ -873,6 +868,16 @@ struct page *vmalloc_to_page(const void *vmalloc_addr)
 
 	return page;
 }
+
+struct page *vmalloc_to_page(const void *vmalloc_addr)
+{
+	/*
+	 * XXX we might need to change this if we add VIRTUAL_BUG_ON for
+	 * architectures that do not vmalloc module space
+	 */
+	VIRTUAL_BUG_ON(!is_vmalloc_or_module_addr(vmalloc_addr));
+	return __vmalloc_to_page(vmalloc_addr);
+}
 EXPORT_SYMBOL(vmalloc_to_page);
 
 /*
diff --git a/mm/vmalloc.h b/mm/vmalloc.h
index 8866ddcff668..bce4c982c88b 100644
--- a/mm/vmalloc.h
+++ b/mm/vmalloc.h
@@ -8,6 +8,7 @@
 #include <linux/vmalloc.h>
 
 #ifdef CONFIG_MMU
+struct page *__vmalloc_to_page(const void *vmalloc_addr);
 void __init vmalloc_init(void);
 int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages,

base-commit: 587858367581b9c55c3690f4e63382ad622719d4

