Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96254C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 19:02:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3CC6B008C; Tue, 15 Sep 2026 15:02:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 784116B0092; Tue, 15 Sep 2026 15:02:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6721D6B0093; Tue, 15 Sep 2026 15:02:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3CD906B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:02:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35EC3A0535
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:02:24 +0000 (UTC)
X-FDA: 85216917408.28.9BD772F
Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6990A1A0003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:02:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mrLgaDUZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of dmytrokoziuk68@gmail.com designates 74.125.229.204 as permitted sender) smtp.mailfrom=dmytrokoziuk68@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789498942;
	b=q7o7fjTgYtnftHg6kJkFut6GzTSjjD7HDsoQVFbTMuORAcqidHFADOM58AlmP3rZe6g99N
	kDZMBy13he7in3vpaDjHBfcvjnj+ClLFk7CZCRxB8r739aT/8l+51xq7dFRfRvq0R4FpJE
	bVtgfe6/pF0qRPgHCGwjzSdueRczH0A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mrLgaDUZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of dmytrokoziuk68@gmail.com designates 74.125.229.204 as permitted sender) smtp.mailfrom=dmytrokoziuk68@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789498942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Blu3nD0TwZs02oT5Bhblb/0DYGCIMyHVEsoa4MDtnsA=;
	b=zcpKj+Q1r3h+UagDRRl0t8CG2STV519zOogJtpsr8z0fSku+RFy2fDHgM35X7iZwyeGgRr
	fiUUaZaDX750FUdDtHezyQ9mawx9kab4+X4PwV4rUmMcM13yVJfx/49vd0MlpCgG9UKTWn
	USxtw8pk4sm92bWjNBK5dO5vL3dH3gY=
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b5e4f16f12so104945e87.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789498941; x=1790103741; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Blu3nD0TwZs02oT5Bhblb/0DYGCIMyHVEsoa4MDtnsA=;
        b=mrLgaDUZgKrVqkXQnf3r/odx1UjIUxI3L3185JDrcJnxjakhZvQ25SRyXDREvQND5J
         4wYrGEIB3LwlQe+/TRu6p7oPUqAGpZTljm+eZE02fBiWZkkBU1m/6/2FAeiRplwAJwSh
         9bJ41QHAq9qBOiD1PK9cVjTEw5pGmqJUZFKATSWiHTsR3BWNIo4QIth98+XV6/o3g81i
         71hmk96NOzL0Fx8Cx8x2RqSuYT8nhnvPlffn1bJ7RP7yXyEJH7Lfbke1ZZLZDs1e3GYX
         DVvEdo6rphex2jjoKvSQfRpWhsnv9CE3Q/0ZdJhlOxbVZeY7A3/GQ4cJRjvMfR5a4Uty
         tr8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789498941; x=1790103741;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Blu3nD0TwZs02oT5Bhblb/0DYGCIMyHVEsoa4MDtnsA=;
        b=Ojxo50voQHHak6L06FG6AcH3blVN+fZ4IcD5NOXeG1ZejgUYYmNpLUdpkgz37RtHzt
         b/QxLxuBkg+kteaOsY0S6d84Zysom4a23TNjCo0cHFM4vq+ooUJG6CzMlgzONOV715Lp
         e3vlxqVpJK1RNTBFzcR0Wx9Q36iJAEK7GisYCS/2NxvwFz+Tcn9Ae8INK0oHuAtCaBaL
         +iGXhplw0tEBFMzVwT3+T7m6czfEuEaADz51xetWvAYuSRvQfTnABgnnSkpWldpAVgpj
         u7JbxfwA1Yq7yQQzl4gtdq9lHncYWheVLRaybkpVxFpRqv9t9SIrCd9AuyAUWkyugCcJ
         6KGQ==
X-Forwarded-Encrypted: i=1; AKwUvBwTPypqQmVi1tcEl0cGmAcfwtlANzw0koua4TILjcOhe08Y7F2aEe5y4FbQfwKym4y8DpHazz/8rw==@kvack.org
X-Gm-Message-State: AFuF++mcVIkar3sc/LgBY3kwIlgjeLmCkJ7wDcEott/60tHSBeIck5yk
	KDRr3Y2wq9hFp0GA02Vx/gsc7oRvNplSnNvrya0+iYj1SouFuW9bt9gM
X-Gm-Gg: AYBFou1WPm4nCm/xTlywpm3Mx/RZ6vlxYskyUu3KBPoozCHKY1IHRqB4LCI3INs1+vT
	s8uFhjbM04Sg7YdQO7bblqLwuSFWwSTLx3CXElhWhODWHYTXWDkE9cQRROoVrx/esSnbGu8zqzn
	yPKE0XLrTanCcFsIGzRJXJfWPc6jQs/mv+/+JfmmF7eud1LRRYgOJZSVe/SoqC/fwMTiCtbTZ8Z
	hCLeLTlkD9ci4RtT4JIFHpAMH+ZP3EeCQDeNpYXiKcLVcIn1ih1tI5Z7NaOT1x7f8Wnud8rek2+
	75OMyiHzqluIXUuWYRhC22+zrM3lY0veeGt1uUxk+KaRylt3V+XWnr4XVCpOq0O3xE2N8Eum+LB
	VrUMqflb7yWF/oYYYTWJ8kBwDGICvJipbGVFCdRSkj0kxURFS83NCX6j2cYXXR3lzRKlV4JbARZ
	QBzgbXJGxUo9VtK56iGC2k+J35Nf9Ec5MEHRR+Veqp2xU19hhaUntqcXz30WgLJjz8WzKdFwoKU
	sTsb+OxJea3YT3iIr8FbSDNEldTGuvwxAKRSEVGkfWRzh/tG9xm3JUMZVYDRUNVaebw00h9dPTF
	8kyDrOqTTdrQASHtpMaUQWxGaCsuS2zxySuWuMWCGIc+Gjpq+D3L3wXYt9FtOTwJ1Q==
X-Received: by 2002:ac2:4c4e:0:b0:5b6:425:4bf0 with SMTP id 2adb3069b0e04-5b8ae8acdb4mr4205302e87.33.1789498940542;
        Tue, 15 Sep 2026 12:02:20 -0700 (PDT)
Received: from localhost.localdomain (2001-14ba-a052-b900-3da4-4f58-44df-c60c.rev.dnainternet.fi. [2001:14ba:a052:b900:3da4:4f58:44df:c60c])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8b57e0bd1sm157626e87.59.2026.09.15.12.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 12:02:19 -0700 (PDT)
From: Dima Koziuk <dmytrokoziuk68@gmail.com>
To: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dmytrokoziuk68@gmail.com
Subject: [PATCH 1/2] mm: kmsan: fix iounmap metadata teardown
Date: Tue, 15 Sep 2026 19:02:06 +0300
Message-ID: <20260915160207.2952-1-dmytrokoziuk68@gmail.com>
X-Mailer: git-send-email 2.45.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6990A1A0003
X-Stat-Signature: upwa6z58ifnfnmz6ocxo1kppqq9rqin7
X-HE-Tag: 1789498942-274199
X-HE-Meta: U2FsdGVkX1+YS9qXge8SjWkJ59vOYrLMYz+groK+5QhOEUR3GBt2hqf/QCvzZw36jbS/+Rs51tfPiua2o5/K5B7rsMMh3GjYt3yITeabOv6mkgDESBOrXcgcax2vz57Tv0tbM3NCywk9Gfd/xttoco/ULBFgrRRMozyLOG6RjiFLmH/bjoDG4a7GAcrJIUQyYH/BaXR7fEBoMc3klk6XYNPnossV9a4MSAlxQkEQApw9shvVxB+eJHTKt4nSLl4/vTPxuyhKkMrBc+e0w/0wjlh71oSRSlmFdeXkITJxL49oKge4cSTsrE79XgN8Rco73no5/vZrqdC6AR3W1F8ORYhCy0sPal68dJo0yHLBONQ1mRU53A+od0ZUHFUsyEHmysMrBgH4u1Ol55nR3IV10SglIBixBRMKb1i4nQveqv1RnX5leKG4uh7Q7/PeQIGceOnKe+mQbBer+4Y1kj4FFWb+9dNhJt/fb0ehbzkua/+F+RACYO4CP03ikgTyrqhzFmvgRW/2r+EjqLEkOcKxnjcZpq184ZVQ4OC5kKssdSH2ixx7aXIyvC4IkG0dSzKRgxTxgcgshcDESerExEllN3P1l58s/tfGkn8TuX5PwbPJDiKMsXUE01n0Gg/AWd3n9m1q45Q5QsWh/U8gwfefcJo8ZI7KNUs+kJHRtKcliEwE18lbTYW2Hm1jhEWRQ1EL5UUvWkXUJeqQJ51UDVrkOkOzqmj0yZxrILTyDSI7cX2i55H2s97MfQ9KCsNFJCcn+beJCMr14gBqiJbDucWSyZDO6He0IX4E/8l0B2dmRAv6ElaCFRH545V8XYUEJZHSHl5F0TqmNxdZUgiYiDwjyZpT47L8wyV3P4tCZuEj8cJc7ZgIORMDL4p0UDzY6ooISKYgVeo3FCb9zNhTYckPPfiX8P5aOlkvtycPsUD8Lu4xEWFGXJ5VmWRk8RjySPBzYUNtRYbmgNU/fT9mFQE
 a/q2uIbm
 qKKmkYodvrQ/ga4Y9XFyYbUr+DPyorpg5o1nBfVGluSU4krtci81UE6+28McAeOV+TPdjBGJ+IwSMRd3Eby4p1NSUASjcHWbkfVdpW7SPJ8MT/g2MBihfpwYdIJxmXMGD4NvaDlIB1kkCCdaWipRdiDj8D0iXl4WguktqaK0ntDIxiL3eq6qxthdzbPYccGAF5U7DcSr5an/s4GV9Q8UlvrCnoo0tW5iUXo+fjkkRm6KjxZsBJlHDNb9BLRSKSkA7y718lV6n97JZI3Y2Y+oRFSVLMNsCFwDQzulcZAfMhgzRZ7J+1t+4T9KYjEWbk/qe83rM8vNnsBcNdzTvXqDMsE3v076nYt+HT+gNm3jiiLcVBQBxjwqk5++h1xN0zC+juy/k3XFXpgEhBYUOhFkafIIxF9Oa+dhfhNCw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While studying the code, I noticed that kmsan_iounmap_page_range() calls
__vunmap_range_noflush(v_shadow, vmalloc_shadow(end)) inside its per-page
loop, and does the same for origin. The first iteration therefore unmaps
the entire metadata range, removing the PTEs for later pages before the
loop can recover their backing pages.

Looking at the page lookup, I found another problem. The only callers of
kmsan_vmalloc_to_page_or_null() pass shadow and origin addresses, but the
helper accepts only regular vmalloc and module addresses. KMSAN metadata
lies outside those ranges, so the helper returns NULL and the backing
blocks are never freed.

I considered extending the helper's range check, but vmalloc_to_page()
also checks is_vmalloc_or_module_addr() through VIRTUAL_BUG_ON() when
CONFIG_DEBUG_VIRTUAL is enabled. Supporting metadata addresses there
would bring KMSAN-specific information of the address layout into generic
vmalloc code. That seemed broader than necessary for this fix and would
make it harder to review and maintain, so I looked at how KASAN handles
metadata teardown.

Follow the existing KASAN approach: walk the existing metadata PTEs, clear
each mapping and free its backing block, then flush the metadata TLB
ranges. Put this in a private kmsan_iounmap_pages() helper and remove the
now-unused kmsan_vmalloc_to_page_or_null() and its declaration.

Fixes: b073d7f8aee4 ("mm: kmsan: maintain KMSAN metadata for page operations")
Signed-off-by: Dima Koziuk <dmytrokoziuk68@gmail.com>

---
 mm/kmsan/core.c  |   14 ------------
 mm/kmsan/hooks.c |   64 +++++++++++++++++++++++++++++++++++++++---------------
 mm/kmsan/kmsan.h |    1 -
 3 files changed, 46 insertions(+), 33 deletions(-)

diff --git a/mm/kmsan/core.c b/mm/kmsan/core.c
index 90f427b95a21..bf8c86fdcc5a 100644
--- a/mm/kmsan/core.c
+++ b/mm/kmsan/core.c
@@ -236,20 +236,6 @@ void kmsan_internal_set_shadow_origin(void *addr, size_t size, int b,
 	}
 }
 
-struct page *kmsan_vmalloc_to_page_or_null(void *vaddr)
-{
-	struct page *page;
-
-	if (!kmsan_internal_is_vmalloc_addr(vaddr) &&
-	    !kmsan_internal_is_module_addr(vaddr))
-		return NULL;
-	page = vmalloc_to_page(vaddr);
-	if (pfn_valid(page_to_pfn(page)))
-		return page;
-	else
-		return NULL;
-}
-
 void kmsan_internal_check_memory(void *addr, size_t size,
 				 const void __user *user_addr, int reason)
 {
diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
index 5f1b8053f9fa..084ba667cbf7 100644
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
@@ -142,6 +144,49 @@ void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end)
 	flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));
 }
 
+#define KMSAN_IOREMAP_META_ORDER 1
+
+static int kmsan_depopulate_vmalloc_pte(pte_t *ptep, unsigned long addr,
+					void *unused)
+{
+	pte_t pte;
+	int none;
+
+	lazy_mmu_mode_pause();
+
+	spin_lock(&init_mm.page_table_lock);
+	pte = ptep_get(ptep);
+	none = pte_none(pte);
+	if (likely(!none))
+		pte_clear(&init_mm, addr, ptep);
+	spin_unlock(&init_mm.page_table_lock);
+
+	if (likely(!none))
+		__free_pages(pfn_to_page(pte_pfn(pte)), KMSAN_IOREMAP_META_ORDER);
+
+	lazy_mmu_mode_resume();
+
+	return 0;
+}
+
+static void kmsan_iounmap_pages(unsigned long start, unsigned long end)
+{
+	unsigned long shadow_start = vmalloc_shadow(start),
+		      shadow_end = vmalloc_shadow(end);
+	unsigned long origin_start = vmalloc_origin(start),
+		      origin_end = vmalloc_origin(end);
+
+	apply_to_existing_page_range(&init_mm, shadow_start,
+				     shadow_end - shadow_start,
+				     kmsan_depopulate_vmalloc_pte, NULL);
+	apply_to_existing_page_range(&init_mm, origin_start,
+				     origin_end - origin_start,
+				     kmsan_depopulate_vmalloc_pte, NULL);
+
+	flush_tlb_kernel_range(shadow_start, shadow_end);
+	flush_tlb_kernel_range(origin_start, origin_end);
+}
+
 /*
  * This function creates new shadow/origin pages for the physical pages mapped
  * into the virtual memory. If those physical pages already had shadow/origin,
@@ -219,28 +264,11 @@ ret:
 
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
diff --git a/mm/kmsan/kmsan.h b/mm/kmsan/kmsan.h
index bc3d1810f352..681594186663 100644
--- a/mm/kmsan/kmsan.h
+++ b/mm/kmsan/kmsan.h
@@ -165,7 +165,6 @@ bool kmsan_metadata_is_contiguous(void *addr, size_t size);
 void kmsan_internal_check_memory(void *addr, size_t size,
 				 const void __user *user_addr, int reason);
 
-struct page *kmsan_vmalloc_to_page_or_null(void *vaddr);
 void kmsan_setup_meta(struct page *page, struct page *shadow,
 		      struct page *origin, int order);
 

