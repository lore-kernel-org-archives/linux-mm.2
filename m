Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64D89CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 10:03:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A50AB8E000D; Wed, 24 Sep 2025 06:03:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A009E8E0001; Wed, 24 Sep 2025 06:03:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F0748E000D; Wed, 24 Sep 2025 06:03:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5848E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:03:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 28CAC11AC2D
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:03:08 +0000 (UTC)
X-FDA: 83923705656.28.B6992B9
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6AE6F100016
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:03:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ryywmcG1;
	spf=pass (imf05.hostedemail.com: domain of 32MHTaAYKCPcfkhcdqfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--glider.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=32MHTaAYKCPcfkhcdqfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--glider.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758708186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZjocDtApH+mYILuh2MoVR7BbFeZzIGZsGcmRz0O6aqA=;
	b=1MhJ0g2qj6muI8kmnFM0/tgJRP7DOjbWwkBMKFGoSFcv/TK8ZR0ErFcgiIWH4Iabecj97Q
	iasO4J2eADJlFYw+Uw87QW6P2qGe3lxmZj76awVj5GS6B138pfmyXTKEEfbVF2+Co2bjbg
	or4rOrwvE0w1WloYWdFWr2r/nsXHvt8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ryywmcG1;
	spf=pass (imf05.hostedemail.com: domain of 32MHTaAYKCPcfkhcdqfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--glider.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=32MHTaAYKCPcfkhcdqfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--glider.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758708186; a=rsa-sha256;
	cv=none;
	b=DwXwFhBMx8dDohcqKA1BY8UVB6qEZ9bR7byZwvt/TW4bXbTopJrPbCuOUXewcYydVJQF7w
	vSU6rNrIcWbpnWPFQOcs3Njc2kGlvWsSgFoLtntm73mQHJZOt1usFV+S+XESSYTM7aViv/
	L/qM3vujRzi7foVxwn5qd1zOENKDlGA=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3ed9557f976so5526027f8f.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758708185; x=1759312985; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZjocDtApH+mYILuh2MoVR7BbFeZzIGZsGcmRz0O6aqA=;
        b=ryywmcG1tZRvcGqXuATI/h4DUNDqITwPpK4TIhJRWcBcSYXX26mV2xZz4gV29wneLa
         sgcTj/6jkfgwEYceYzSnJitt4vtE3x0tQLju5p2PRrK5CfNKh7OM1idgfngU85WZONuM
         pP+j9uBoWVdCLTUV89cU3EVf3SBQB9YLJDFvRqSr6lEiIoshFD/HI4z1q+1KWPVdesOr
         iLxbBtTktVSAJbsHQHuCi44t3jj4vLdkLR0nkkUCP4jiNE3LIgC+Syzav5MIrZdiDnjq
         yqmDhKDRz5RpLAK2w7ml6x1NdEWKxpQL8x5ZP/qcbFZ1uhVgTDIaNaIUwxMOvkaPmBPW
         WzDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758708185; x=1759312985;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZjocDtApH+mYILuh2MoVR7BbFeZzIGZsGcmRz0O6aqA=;
        b=nfMGuqmHsPMEWSgbL0j2UFwQPFLRMvhi4h6+8E2GEL7xCpT8QydNbwHW4Cz/d/gH6M
         u7vMGkuzzWcIi06pqIaojfkF+zad8PRl5FqGWwfC7+f9UbLz8kGBqHeRwIyH4Ok8pljA
         RtttpcHrQfAI0xJjiaVokqA1Ym1amwM0R+9oBrdTbYojjGAfpL6y1WX/MoTurqYBIDEO
         oTO8HI2z1b4XeSNXzqQL7Ii2bdA4JZD/EH7u6Ifem58WTkd10k1qd5qhe5VAfvRWHvn2
         vkkqPtBoyuXFbBszx7CvjwpvJyepMBg2YIRwOOXmxY4Encq9iIde4R57TSAyMRpwnMLM
         9PQw==
X-Forwarded-Encrypted: i=1; AJvYcCUvzXIYD0Xz9tHYdSmZLXmlVs+/2UNwKeZ6UImkirIFr7VsD/GEr0zycyaOufGSexgCqY63CqXpOw==@kvack.org
X-Gm-Message-State: AOJu0Yzs1bjWjKbIr3OEFWmfGw015VU9il1mqbtUuFuaMvL8ZKlrnw0x
	8Y1VGZYGrUsFjs/LBrw8CVCDobttsegGV5EqjVxddkIaMT4lxpOhGIkVzIa2OZdHOtcbt/UTj8P
	AQA1n6w==
X-Google-Smtp-Source: AGHT+IHt24AXDuzRv8mfV0+Dd7gn9yVXlAssjjo5xVzAkMIAyKd0XpBQuf6DwkbGgm2mAJytPIKDsRe4zdo=
X-Received: from wrbet7.prod.google.com ([2002:a05:6000:2307:b0:3ed:665b:ec9d])
 (user=glider job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:288b:b0:3ee:1296:d9e6
 with SMTP id ffacd0b85a97d-405cdc1e751mr3789906f8f.61.1758708184637; Wed, 24
 Sep 2025 03:03:04 -0700 (PDT)
Date: Wed, 24 Sep 2025 12:03:01 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.534.gc79095c0ca-goog
Message-ID: <20250924100301.1558645-1-glider@google.com>
Subject: [PATCH v2] mm/memblock: Correct totalram_pages accounting with KMSAN
From: Alexander Potapenko <glider@google.com>
To: glider@google.com
Cc: akpm@linux-foundation.org, david@redhat.com, vbabka@suse.cz, 
	rppt@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	elver@google.com, dvyukov@google.com, kasan-dev@googlegroups.com, 
	Aleksandr Nogikh <nogikh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: fzunwjkd5hxf7h58kw1nxabqicpi7d3r
X-Rspam-User: 
X-Rspamd-Queue-Id: 6AE6F100016
X-Rspamd-Server: rspam04
X-HE-Tag: 1758708186-526320
X-HE-Meta: U2FsdGVkX19HjgH90ydpQrHFMnp9J0dsUTNPBORfWe7i8XWYx3PxbVGE8WL69pgdsxmr4XQBR/0lRsNRHzbudMjxrOIqmyu3+F/dZ/2Cso3W1XTbkuaEeWTquzVN38q10y5/OavskkJFDBOyoRyURtgLvL/N7Csi86xkIFxX5cYYE290kAnZ/5LGCjKk1r+BmLTjD8IM+gsQj58Lht0K8ricE+b0n8N5CoR3+/AmA+mAHj/bHd5ZeceVlBClRMRH535gwo+YOzmemwW36pr8LIHfn6azt5GNAheQMH0lF49CkA97qDqdcDur5I6cBx/ToMe7X7ZHXG5Fgf8O6fCZHIRxr6qVKUSPb9qGPsmKXB9RqVaVn8A5NFm/zjL4aefdNAVeHbioGolr48luzCxcVI7gu+GjhAG2MidafJes5LJnX1N2oXvRVAcLyq1jfxUGqY+I8Hyw3hgR5cRECkpaLDt4rTmsivP7k45qYR0ikhsjo+HnJBF7Ms6QaoCZhvtQWB6uIscTv+kxELHClLcnx6095Xqy9kAWY0Y1Ev7QGCrNHJn+nKcU2bu+KJ4Ykbh/8HhuQCy4frrBm2KU5W91EhsVaRpDLHBIhLz3JE0izgqeUodlWxOHxuZX3xoppcW1VE+6Cd8KXn7XA/t13S5Arffse9P7N0V98IOkHr8B7yyjv+KkfU48fyd3AO0MZZXCwkmho+8TKdsAILhTYxn7VOmAyiFfjVB0rvo7ODqCNqKvcAh7qfoe1f6+OwnnENZ4q9spYhGHDBmcWuCTsZZNyocd6FiYoe5m7lZShAqYWZ6zLCWSmF1e0EMp3Pbmtc0Yy5e6JJSKdKMp8ynyZWEoVUfGRNJ26FwI988IAxHiaJges5dC2EhW4+Uyd61J1xP8Yy98izl68I3vD9Xuq/ljU5hyul+GEvMSNg4jUVXtIVTVXGRHRALeM4y/v/dqGPgeuG+3qz1e/XQdwNAqCze
 u/agk/Vn
 p/PvyZ0wt3bAQ+mzXGj85roEf+9TAuoBxAMssdUV6Xy9w1J4eKrlrrIQWlRO0YeE8FIMKU/JO/fzg7WZfGBYLae5UbGzPOyn7mlMfY+yY2BcY3sqc4MoSxfiBV5PpPLLeEi0S826YNq8rY7gZ2VtdfFPtu88XZSdQxjQjeu+gebt5xSZfYXEptYhrZIjyd2In77MiYwtgJcBXvB/jf1tXg/tWc4pk6Wd73DQVLPdK0y5IGsXrthN0HYa0ykav/lixBqaHFCgrXgikVP3icegOcnxASYLgMgaWwC07m537ovr11jY/+8412BluyHTxwgKBm+fR9Ke/WgEJ0lOi5h9Un/etsQfyY3cV7WOSLg99LN7KG/TcXNG1mVYxqdRcQGCZhD0HQS6Yfsw9v6v1WeXHx7lgNrKO6CYMCx6IX14kZzxwgGymOy+kA0TvR87s2Scih2b1ZeP84O7E0S/IjiZDvQy/StHB1B9AdWSSvdVXqLgEVk0Bl4Jyuy8AXToZkAhPAJRmIXb42R5Bim6Sm0sgt0oeafwRY85XIBkJbzPArJElP4psFK9vX56lEnSkzGcFhOUHhAXs7KgOALURd+lMDDC9wU+rBtXYU09peggl09k0gKs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When KMSAN is enabled, `kmsan_memblock_free_pages()` can hold back pages
for metadata instead of returning them to the early allocator. The callers,
however, would unconditionally increment `totalram_pages`, assuming the
pages were always freed. This resulted in an incorrect calculation of the
total available RAM, causing the kernel to believe it had more memory than
it actually did.

This patch refactors `memblock_free_pages()` to return the number of pages
it successfully frees. If KMSAN stashes the pages, the function now
returns 0; otherwise, it returns the number of pages in the block.

The callers in `memblock.c` have been updated to use this return value,
ensuring that `totalram_pages` is incremented only by the number of pages
actually returned to the allocator. This corrects the total RAM accounting
when KMSAN is active.

Cc: Aleksandr Nogikh <nogikh@google.com>
Fixes: 3c2065098260 ("init: kmsan: call KMSAN initialization routines")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>

---
v2:
- Remove extern from the declaration of memblock_free_pages() in
  mm/internal.h as suggested by Mike Rapoport.
- Fix formatting in the definition of memblock_free_pages() in
  mm/mm_init.c as suggested by Mike Rapoport.
- Refactor memblock_free_late() to improve readability as suggested by
  David Hildenbrand.
---
 mm/internal.h |  4 ++--
 mm/memblock.c | 21 +++++++++++----------
 mm/mm_init.c  |  9 +++++----
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc030..ac841c53653eb 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -742,8 +742,8 @@ static inline void clear_zone_contiguous(struct zone *zone)
 extern int __isolate_free_page(struct page *page, unsigned int order);
 extern void __putback_isolated_page(struct page *page, unsigned int order,
 				    int mt);
-extern void memblock_free_pages(struct page *page, unsigned long pfn,
-					unsigned int order);
+unsigned long memblock_free_pages(struct page *page, unsigned long pfn,
+				  unsigned int order);
 extern void __free_pages_core(struct page *page, unsigned int order,
 		enum meminit_context context);
 
diff --git a/mm/memblock.c b/mm/memblock.c
index 117d963e677c9..9b23baee7dfe7 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1826,6 +1826,7 @@ void *__init __memblock_alloc_or_panic(phys_addr_t size, phys_addr_t align,
 void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
 {
 	phys_addr_t cursor, end;
+	unsigned long freed_pages = 0;
 
 	end = base + size - 1;
 	memblock_dbg("%s: [%pa-%pa] %pS\n",
@@ -1834,10 +1835,9 @@ void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
 	cursor = PFN_UP(base);
 	end = PFN_DOWN(base + size);
 
-	for (; cursor < end; cursor++) {
-		memblock_free_pages(pfn_to_page(cursor), cursor, 0);
-		totalram_pages_inc();
-	}
+	for (; cursor < end; cursor++)
+		freed_pages += memblock_free_pages(pfn_to_page(cursor), cursor, 0);
+	totalram_pages_add(freed_pages);
 }
 
 /*
@@ -2259,9 +2259,11 @@ static void __init free_unused_memmap(void)
 #endif
 }
 
-static void __init __free_pages_memory(unsigned long start, unsigned long end)
+static unsigned long __init __free_pages_memory(unsigned long start,
+						unsigned long end)
 {
 	int order;
+	unsigned long freed = 0;
 
 	while (start < end) {
 		/*
@@ -2279,14 +2281,15 @@ static void __init __free_pages_memory(unsigned long start, unsigned long end)
 		while (start + (1UL << order) > end)
 			order--;
 
-		memblock_free_pages(pfn_to_page(start), start, order);
+		freed += memblock_free_pages(pfn_to_page(start), start, order);
 
 		start += (1UL << order);
 	}
+	return freed;
 }
 
 static unsigned long __init __free_memory_core(phys_addr_t start,
-				 phys_addr_t end)
+					       phys_addr_t end)
 {
 	unsigned long start_pfn = PFN_UP(start);
 	unsigned long end_pfn = PFN_DOWN(end);
@@ -2297,9 +2300,7 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
 	if (start_pfn >= end_pfn)
 		return 0;
 
-	__free_pages_memory(start_pfn, end_pfn);
-
-	return end_pfn - start_pfn;
+	return __free_pages_memory(start_pfn, end_pfn);
 }
 
 static void __init memmap_init_reserved_pages(void)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 5c21b3af216b2..9883612768511 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2548,24 +2548,25 @@ void *__init alloc_large_system_hash(const char *tablename,
 	return table;
 }
 
-void __init memblock_free_pages(struct page *page, unsigned long pfn,
-							unsigned int order)
+unsigned long __init memblock_free_pages(struct page *page, unsigned long pfn,
+					 unsigned int order)
 {
 	if (IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT)) {
 		int nid = early_pfn_to_nid(pfn);
 
 		if (!early_page_initialised(pfn, nid))
-			return;
+			return 0;
 	}
 
 	if (!kmsan_memblock_free_pages(page, order)) {
 		/* KMSAN will take care of these pages. */
-		return;
+		return 0;
 	}
 
 	/* pages were reserved and not allocated */
 	clear_page_tag_ref(page);
 	__free_pages_core(page, order, MEMINIT_EARLY);
+	return 1UL << order;
 }
 
 DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);
-- 
2.51.0.534.gc79095c0ca-goog


