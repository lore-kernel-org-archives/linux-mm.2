Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01FACCD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664606B0098; Thu, 11 Jun 2026 23:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63C5F6B0099; Thu, 11 Jun 2026 23:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52AAA6B009B; Thu, 11 Jun 2026 23:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 412A16B0098
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:59:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0FBF21A040F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:40 +0000 (UTC)
X-FDA: 84869906520.09.C2B8F64
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1E30F1C000F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jEY8H1vx;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236778;
	b=uvnTrUaM1hvbrKKmrg01jnnkYHgo6ra2YyYT86lKVnsNpPy/E1fKZmRW0E060CaeaH7tV9
	KwmdgjBv9LxFkhHNiZeBMz8134BGo/d9fojz/vxlbkGWtK5/r0Dv9AY5RSdPl4whqXs6Hg
	pibox6F9nwoDp9s0fqHeu7gkKk9CmYk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jEY8H1vx;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TPNP/s8YQi9s7EHLxOTbc3dEJlnMSCHwNqhJjmE6eW0=;
	b=BPSLlxTIggPgvj5kyfw6xS5DucH1ZQT+J8zH2Q9cz2uvGq3nEGxstn5KqT9ACWnNmOCUpP
	mo6Q4udxep7wafG4fO3JldLmd7IcpBa4lPcGUHdxWW8EUcNKWp0w8kkHJZHOgTgprJ2r8y
	KI7Cq29YVuk6S91RiicCg6Xnq5JsMnk=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-842358aaf36so237964b3a.2
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1781236777; x=1781841577; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TPNP/s8YQi9s7EHLxOTbc3dEJlnMSCHwNqhJjmE6eW0=;
        b=jEY8H1vxNxKvG6rtRtdx5HBzMAkKD2urDIEg4hZvEYG5W05Of8fblzDXaZ3fVnvpMj
         PhflR0zMnsz9zHYJ4Sx5+GHVWzEdiS8e8g9YHZfEYTHuJ0FUmi5Sxp57JQJtWzUvTKa7
         rTi9Ran9kLKE0ZpduzERaxDyOZci9vso3A2n1nQOca3L0bMvYbdQ5nl5iZnN2kJKFYkX
         W21u9k1kUZ6cedifc8rUFtB6bRZ8qJwgOavJ3GC0Niz3jlXgG0Gc0aKqxBj7zn8u40Q3
         DJfbBEGrIzfj5n5m55l8gYbhPbTO4U4DS2TlMdfJcQ6q4r167tzrzC69Ty/8iuWA0iMM
         Oqkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236777; x=1781841577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TPNP/s8YQi9s7EHLxOTbc3dEJlnMSCHwNqhJjmE6eW0=;
        b=jHA78RfcthNpk3WaZzGTL3bg+tKxlegsA0V2Fvy2Zb/krlKxCNkCKxrbdDX14EaTIY
         RYkENZShEy5NhrpCrPkMCsFE3DfMUdzQsZ8S94zzeu5lCbt1lCSSQq4zd5NtVth/DgEz
         mq5qHAcVZWyUMxLnu/Qt+hhV/LFt1xEs1ZkiEbaFg54NdL3PAnvG8Mj+qYbwA6xInaK6
         m1QoLYaKm+VDEsSCjkgrAjLGU4fBgf1jj5RgSIE0JsvNTOh++idtf6c0eTKGHA7Y9Td+
         Ulv5oY8OnM51FmIbFA2SHHpKoi37KIzJ3QUMsNUqSLrITkuitDjqRv+/zZtuMStC5O7c
         mV5Q==
X-Forwarded-Encrypted: i=1; AFNElJ90F9wPRXvkKN3aSZTBgasMevhOyp/7g48A3Wovvo5nXiH1LIfGD0K41If+0wG+eJCqaUtzAmDUpA==@kvack.org
X-Gm-Message-State: AOJu0YwskqjO40ci0mFqsm7/iBwEbY9Z9N4UwhYuQY8z1xskNzs6sa++
	EfswRH+NMq5PNjgpsv7t96NDyG8x/50b82M2nj5+LEUCjUBlkYnEi1ZJyFB233mcQ6Y=
X-Gm-Gg: Acq92OFAjT4vIquG7XDAl3j95yvejkY+FXziUfM9o+kVDMn+FG0QfOarf5YT3qh/Owq
	YLBqUTIxou6ZtHSJOrsW8xLCxNU7lELAqd8+flne5SArS+W8qBvNRpS6U9bnM8eYwhFdOqlqpyK
	FJmehq2c85Ze2LX6dzV1B3LTOT/tm1Ex1MdsptYudF8gHC698Ff7FCOTLzdMaCc2bo/RWxBqkly
	bJsS5lRgcW+A7HwEwF/LRjxiL1OeJ0qqGkrZm7K6rzp3nY2EPaQTxKry1Jq6kdsepAIKquA6Zio
	QUOv3UFbXDfKTniDJD7m5lU1CM7qfYDQ51e4nmQ6WHeVTvvoHgozlN6jNCIuJuF38S84ra18elQ
	RkAtWbBZJL4MtZQSEomhvadxhtXn+D+dl/XwDAryEnmGAgOFHxkt0VumUDhnleCVDYwxrfAIs3m
	0+4GuaTI+Z9ZxOje3JrG+oA2tSjLUNoCzDFUhX+qPM+3k=
X-Received: by 2002:a05:6a00:148d:b0:842:6a3b:60d8 with SMTP id d2e1a72fcca58-8434ce0d4b4mr1113011b3a.30.1781236776918;
        Thu, 11 Jun 2026 20:59:36 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad03fdcsm643352b3a.24.2026.06.11.20.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 20:59:36 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 05/19] mm/mm_init: Simplify deferred_free_pages() migratetype init
Date: Fri, 12 Jun 2026 11:58:49 +0800
Message-ID: <20260612035903.2468601-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1E30F1C000F
X-Rspam-User: 
X-Stat-Signature: tin6c4o7ewcsjsapbj3k4tjc9gs3t4nc
X-HE-Tag: 1781236777-897798
X-HE-Meta: U2FsdGVkX19m/m9kBvyftgGpfdGiwBNH8OGOKISunSS52YLl7PjxXJKzwlNBqTqSYTE5Wcp+3j8zuTEQHGUaPDhsxqSqRqERWLExiCrjkx61O92kuFGOWDgmysHZYa5Mnt5ZPsR2FoIQ5UCdYpSyKwUAQcsUfY73h8ZK9IylMTUGKkSV2B3rp5ORx9rNnIwQ1fHM7PzkWY6neA1PQg9LWf8cpnZl6auWRoHqH+b1M8CuUDiYXy44DqPaBf5ze9pjByhRyfpWo3l6cfDMiuUNTWYgctWSUzmbBFCxV4qjXCkm3VTOuYs5EoFVNNqvZIlnFxdyMLeJInv4MF8GmzZQNE6UyyDHNh8GC3Mv8ZJYUB2d6Z9ZXbeMJaxCepTiwqRpV01Et201fwxBJTqcv8fOmGyfyKgFNns/QLl0QSDAErqinLAuJ6YjiHOebNyUhW6zVD8pValvWzNPC7Jjgc2d1/3TvcjruVi0GF8oP5HDwMVJSAb2tzmoG8X5SwPJr4LGWackNl48Cofoi1PAPopj3/1qcxBXSBQ+WfHUEENqIU/q96H+pU37VArS1FKNzE7xjjghd9g890exdKqt2KUsZBA35aTiWs3yPMzrJwO40tagoyE4HwhqijUHw+XYWz1IMKsGBx1cgM/99ftdlxKP/TUbcxDDaHQk9gck/ggdG4GGOQdYC9+ldP/KrbECRcdKWHYB+fTDFH3rmnB6guJcvXp87fHZzuTpO/3a+QaUyeSKD7iMXJ7ToZJVva6b/xika+JdpF815ZYVlq+/37UP+4yD4xjgbHgbsaOdzqH3DeO7+4Uei3JZ4L7yHExdJvo363hDYRgI6f7R60qzw/ArJtL/seDLySqltR/uxILOm1GMfYZXlJF2Vj3LO7z2OLuae2ydLn4wouKzHVOH+0x+Elgh33A8XsSc09AMrSxCTcI7sQKmtIqJrRdP/9Poq5w7IdfCYxsSCqP0QDpyOaP
 /TVjWOZG
 7q26mWYoHHVYLOIRIdP8vebSuh2cOPrSYEDVvMSI8JYC0p7CaNtHbsggUBMyrKoCfwrbT2TFhhNh5ByRbBnKH4Mm8cRENobqipazAUKdbbrdu+r6968rZSY5I/EQ2u48QNkhBIJ8me8g+7+zYfOkrgYapYhtwpuiMUt7xhDRiyYwEnHIvjLJXgk6jyDwir4WfUeI7ErOVSkmVl/GGU0holNtYlGGuWj51KulhXY8G9qjSSIeH+vjNuUPQc5fTiQt38gPfYbgPiqhs75eG4BCXvBIaLAAPfFwWKqXSQnGyCtZScsAd983p8LU+K8ahGARgrinEJLb7N6hzkRQNfmbPKX7wBlCFP3HmTxRfKg77R8NJK/FxjNd4reEbU7UINrP/gLbtOiGwgu0Qazuy+n6kHWaAowEqGjJ9zc8F37OUlNuOzqKbwKu5dxt4N12Z+ux3UQ/ACykJN3+5Hy8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

deferred_free_pages() open-codes two loops to initialize the pageblock
migratetype for a range of pages.

Replace them with pageblock_migratetype_init_range() to remove the
duplication and make the code clearer (Note that deferred_free_pages()
may be called from atomic context).

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
---
 mm/mm_init.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 92e88fca717f..5c7359693ba2 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -674,15 +674,15 @@ static inline void fixup_hashdist(void)
 static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
-#ifdef CONFIG_ZONE_DEVICE
+#if defined(CONFIG_ZONE_DEVICE) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
 static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
-		unsigned long nr_pages, int migratetype)
+		unsigned long nr_pages, int migratetype, bool atomic)
 {
 	const unsigned long end = pfn + nr_pages;
 
 	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
 		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
-		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+		if (!atomic && IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
 	}
 }
@@ -1142,7 +1142,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
-	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
+	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false);
 
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
@@ -1981,12 +1981,12 @@ static void __init deferred_free_pages(unsigned long pfn,
 	if (!nr_pages)
 		return;
 
+	pageblock_migratetype_init_range(pfn, nr_pages, mt, true);
+
 	page = pfn_to_page(pfn);
 
 	/* Free a large naturally-aligned chunk if possible */
 	if (nr_pages == MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
-		for (i = 0; i < nr_pages; i += pageblock_nr_pages)
-			init_pageblock_migratetype(page + i, mt, false);
 		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
 		return;
 	}
@@ -1994,11 +1994,8 @@ static void __init deferred_free_pages(unsigned long pfn,
 	/* Accept chunks smaller than MAX_PAGE_ORDER upfront */
 	accept_memory(PFN_PHYS(pfn), nr_pages * PAGE_SIZE);
 
-	for (i = 0; i < nr_pages; i++, page++, pfn++) {
-		if (pageblock_aligned(pfn))
-			init_pageblock_migratetype(page, mt, false);
-		__free_pages_core(page, 0, MEMINIT_EARLY);
-	}
+	for (i = 0; i < nr_pages; i++)
+		__free_pages_core(page + i, 0, MEMINIT_EARLY);
 }
 
 /* Completion tracking for deferred_init_memmap() threads */
-- 
2.54.0


