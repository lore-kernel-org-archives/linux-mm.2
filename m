Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E03FBCA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 12:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D0F58E0001; Wed, 17 Sep 2025 08:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A8838E0016; Wed, 17 Sep 2025 08:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC018E0001; Wed, 17 Sep 2025 08:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D2C18E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:32:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B1D91118542
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:32:58 +0000 (UTC)
X-FDA: 83898681636.03.10C2415
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id E358E14000B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:32:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="CJ/k4FBs";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3d6rKaAYKCEQmrojkxmuumrk.iusrot03-ssq1giq.uxm@flex--glider.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3d6rKaAYKCEQmrojkxmuumrk.iusrot03-ssq1giq.uxm@flex--glider.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758112377; a=rsa-sha256;
	cv=none;
	b=7HxoQlQdO1V/ScsdUhoX6BRzNblURueu17Ai1qDp4blsb7/sd0ax79YWad0psX7O20mrRD
	Z9g33gsjkAB2gO7VpLUD4EFHeO8w8GOl0mfrFRRVVAym69f+FM8+Vu6xVgSjwfHkSg/vam
	oluiZAQ1Y+iJEZm+b2+HAA9dLvcqqLg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="CJ/k4FBs";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3d6rKaAYKCEQmrojkxmuumrk.iusrot03-ssq1giq.uxm@flex--glider.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3d6rKaAYKCEQmrojkxmuumrk.iusrot03-ssq1giq.uxm@flex--glider.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758112377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gGExNynnqYK/ZqCJ7ukjmzItbcXmGcwmJziwMXpS7pE=;
	b=k1T5orkCmFxiLZittnS73DTRs44j6w7ztLyiFtQChRXRCEGnglY3YlEWWzAhuaFUt0BrmX
	XX51Kg75/3G8nP1Ivlw1tRNyPGc03bO0THTKTyt9vQBAoTDQ1gdrB3F4zwGcEtuel2M5sE
	JY4khtVXBIWKDzCFHd1vYA1yPAGNWQc=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3eb8215978aso2530363f8f.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758112375; x=1758717175; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gGExNynnqYK/ZqCJ7ukjmzItbcXmGcwmJziwMXpS7pE=;
        b=CJ/k4FBsFqXrKdvjwJtr6Oxdcamhs5evE66icELijJfaxBSs/EG6V5J6RNORG/5kjq
         s2bTDr5gwucs+sYuofZPYSaejK1My8LWhR4EvOV3OxdBptAZcIn/UoBScWJ/ReFJvvC/
         gC5qfOMKsBEwlT0e7jfkNHX408h/KMpUlDucS4VIGs9rItA9ZdqXN9ZclvyZS3Fkm/xs
         pWCMMKipX8XR9n5P3tDe2uMPF415jfTMEq9dj8c0hGrOB4frEhQkgZtbMLt8jy7uyX0d
         eiBZKWoltvQezXYMptFSCfvnv2so04VKeGzHCA1X6JNiGEYC1KjelaXk+Csrgrs2ycFq
         NW+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758112375; x=1758717175;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gGExNynnqYK/ZqCJ7ukjmzItbcXmGcwmJziwMXpS7pE=;
        b=dh1ApoY5k1QCL20CV31ArNQ1SUwEt0BwsS3X14pmkkapsnTsO+AP8bUadrJwODdJp0
         m/ZkWkz/MrfGE+xM4Y81kgLy4XRpcQOFy7boMR+9l5EkuJuun6ImBsLLtFiKIYuec9mZ
         50O7Wf3pc1cOC/2D8+aC93NoHjKC+2CG9pS/d9R3Hud8wLeBzo8h/2dhOz3nRMk8qbMn
         ieatt1AJpVaAdsQBy7SmBquhuGSxl+qURqTET35MVmR3NWv8JuZam1wHCXed69w6fjRH
         1W7Kx4mNThP4ZoAsic5qYNA7ikn22BGV+AxsPJUyqd5m/zw6aVKK/epCQdKF4F4hUmot
         /+kA==
X-Forwarded-Encrypted: i=1; AJvYcCVzabD1Cv0Ox1RRoddLavnFylOeQlL7IFXY7JhAEcWEwkuhO899PcUKaUTC4IoBAJ4/S87q/DqHSg==@kvack.org
X-Gm-Message-State: AOJu0YwkXd1T7x1fUHEZIB/EIjWbymqel/QeH0oLb4J7Intfc8g7Dt6y
	E7uVhhTVAtMa5IuOx4sJSPgFXHkqff+S3CzkUiadFpZxCsA5rf6BMBCLL1SMIx9qV7MuF2mUBT7
	KEmEkVw==
X-Google-Smtp-Source: AGHT+IGDr7/rZ8Lz2UDuNsmg0UK0rM+imdFAZEus6WN4w0ovnTMSdLLxblWDQmsHkKpeXcc+Eb+cvXvBIv0=
X-Received: from wroa6.prod.google.com ([2002:adf:ed06:0:b0:3e8:8959:563a])
 (user=glider job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2c0b:b0:3ec:d78d:8fd9
 with SMTP id ffacd0b85a97d-3ecdfa171eemr2138728f8f.36.1758112375451; Wed, 17
 Sep 2025 05:32:55 -0700 (PDT)
Date: Wed, 17 Sep 2025 14:32:50 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250917123250.3597556-1-glider@google.com>
Subject: [PATCH v1] mm/memblock: Correct totalram_pages accounting with KMSAN
From: Alexander Potapenko <glider@google.com>
To: glider@google.com
Cc: akpm@linux-foundation.org, david@redhat.com, vbabka@suse.cz, 
	rppt@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	elver@google.com, dvyukov@google.com, kasan-dev@googlegroups.com, 
	Aleksandr Nogikh <nogikh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E358E14000B
X-Stat-Signature: 5ex9z78e7mzqbnek9fhogtt1oi7cy3ej
X-Rspam-User: 
X-HE-Tag: 1758112376-223030
X-HE-Meta: U2FsdGVkX180EB+Iupi36RfX+gg4r5vdd/jEAchFyGknRPRzZXhwNzmwZ2ETsDpBqW6L4tjocPTmfk4mi+VSAt1KLWu90pTNWMWuSC7EWVA6v16RITL8BJzIUoklR+qsEDwg/vEoL9cPde2snDbRWbW7Z0KvDecuccfqlzJkLBxdiKKccsYaummrdldEAS/F2csbASRezpEwVok9ZjXc3/w0+eUORLrKvQi31C463/qIVWa7LoT+YZEG3peXV70hNnhuy6CFTVY2+LcXjCcxpAdfeVAjWYBbd+cRzIoomapFYzHAvS0gAJcyScmw89l2IAFngKRz2ho68HdyoBF4Tie5T5FmJKvfWwt7cBiDoK9iiApB1AcTTWhde7Hic+FGBVqqfRQykD/yqoykQQgZtVYOdn/XnazViseXXIaiaWV8LQnu5GBs7wmmM+BOu9JpCxAw/FUdJrE8yY39oevw87xvKi5f0fKwdmCzExZuGaP5Ym2+eI8AVFk0f7Ds94wyUMOLOl4NpA6o6EaZq/guwzFDVV09y9YmmpAq1+LIXL6srIAtliPKdShLgso9fbKq/A6OOYQdGAlmfZorsqEXDKmHAzr3Z1JYu7lqK8byjcze3Bd0nmu2jbwHIawcWN0D7wkrTd+QRNVcPwnRz41NPBWLEv8R602u0CvMS2Azw12d9YyCEkR5J8Zwt5zxs966YQLtXm1za5iSw449a2kR9eXI3na/kRferNqoq+xAzrTY0KZ4JDKflePpvWRBeRqFrzaOb1HZtpAmWfVIf1yK1AbL8yf+B+OAYfd4QIbtG0atqoqmgIqokknPOFx+HvvRDak77bBbpYCagVP/1Qy1mVQ28Rk6LGY1/al+zZFJbnouJ83A5nzYkjBHNw/xNpB/8OkvliSMBxKDV+t6l1M1OmIWvjvEYToWQQpPx5xRAaqePMzEtVeKkmZzarSra3MAOohcDnNrTKqZb5ROWOL
 IjexXu4g
 ZQ0KG6c8kh3JQuHBwDrb/tncaSWNvzVvw1KXgs3Ku8lkt9Fi0CKi4z04ivCPpU7y5PSbG2Ueq8KOeXeE6eX0H67WPb/aeVcwLBETwZ4M/srM80UZNX0p3fPbzQAihR7oAsO14hBG7Vdqou2mCsxKZoguOreidHJfQyxkq1/rLj+g3XJKbzLMC8KVOcS6grpzqabtMML9e7zAkdmVhCqpLmCo9EuYdIii58Vu9MdxF0+ZSShkuZOCbj5yne0c96V/F5BsP41kQRWLTUqHjdr5hn7MVzcQumHw0cPIFuFHnKe1A61pq1CiWSOdyMriMvcB+eH0HWAeh0txHo3qwT2K0FQooQ3OJjToilWqzMLHkUnIdWxhQL/FfIzTVf5MNx9z4Zb7L2xDcEA3xF+l4iSYAKlt0txImJVqN/nw5Ig+Qv4Xf+VMlKZ9nN3avfahlYMdY/AdsjBGM7XAJPoybX+puYBqbIh5RuCwIEL0yrdhRBtnpsyRLo5wlJspd/I+9FBLjGQoDeuEzAw1n21SybZ/oFrnxCzovru5OMzsy5szHVaBUv17hKCFp2ioN7u6ZF8aOwhQ1YHCa0+MW0f6DpmVy+yXHnJAE/aFH5x36WDE9dVd/A5G1Z9Qww84mONXUZhtOv3Jc
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
---
 mm/internal.h |  4 ++--
 mm/memblock.c | 18 +++++++++---------
 mm/mm_init.c  |  9 +++++----
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc030..ae1ee6e02eff9 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -742,8 +742,8 @@ static inline void clear_zone_contiguous(struct zone *zone)
 extern int __isolate_free_page(struct page *page, unsigned int order);
 extern void __putback_isolated_page(struct page *page, unsigned int order,
 				    int mt);
-extern void memblock_free_pages(struct page *page, unsigned long pfn,
-					unsigned int order);
+extern unsigned long memblock_free_pages(struct page *page, unsigned long pfn,
+					 unsigned int order);
 extern void __free_pages_core(struct page *page, unsigned int order,
 		enum meminit_context context);
 
diff --git a/mm/memblock.c b/mm/memblock.c
index 117d963e677c9..de7ff644d8f4f 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1834,10 +1834,9 @@ void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
 	cursor = PFN_UP(base);
 	end = PFN_DOWN(base + size);
 
-	for (; cursor < end; cursor++) {
-		memblock_free_pages(pfn_to_page(cursor), cursor, 0);
-		totalram_pages_inc();
-	}
+	for (; cursor < end; cursor++)
+		totalram_pages_add(
+			memblock_free_pages(pfn_to_page(cursor), cursor, 0));
 }
 
 /*
@@ -2259,9 +2258,11 @@ static void __init free_unused_memmap(void)
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
@@ -2279,10 +2280,11 @@ static void __init __free_pages_memory(unsigned long start, unsigned long end)
 		while (start + (1UL << order) > end)
 			order--;
 
-		memblock_free_pages(pfn_to_page(start), start, order);
+		freed += memblock_free_pages(pfn_to_page(start), start, order);
 
 		start += (1UL << order);
 	}
+	return freed;
 }
 
 static unsigned long __init __free_memory_core(phys_addr_t start,
@@ -2297,9 +2299,7 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
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
2.51.0.384.g4c02a37b29-goog


