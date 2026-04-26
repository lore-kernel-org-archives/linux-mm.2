Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F9D8FF8860
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 09:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 126456B0096; Sun, 26 Apr 2026 05:27:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D78E6B0098; Sun, 26 Apr 2026 05:27:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F08196B0099; Sun, 26 Apr 2026 05:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1E616B0096
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 05:27:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 70BC416056C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 09:27:37 +0000 (UTC)
X-FDA: 84700179354.20.8018E30
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id 97FE220003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 09:27:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=EaLSxbdd;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777195655; a=rsa-sha256;
	cv=none;
	b=Nli/s22jKsKQYb534XjW+1rhb5VmhdgPqj9M9MO19Y8wHjsRoR6JfXjz08DErdfgXrGtVa
	oIIgc8Itd67bUJ9pOs9vWZuudb67F5psPGK02C1MGXUNeQkrXC9L9KZRR89YNrB6ON5qC4
	UnqnTg9+tTBtmans3oLMyqkr1XBBP88=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=EaLSxbdd;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777195655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X8jAPi1Ug7YtuxDodtBim0VZYTDek6DS5vd5ro+n0/g=;
	b=d307b9MmSaZYEjDcNvN4fujnMhqYm5dBJBUl/6o0t3afGBuuGR+2JFXbTTtmC+TmvUyclv
	TDm5+UMBQJKvqqa4WdjrbjKTkDs1VvyWM/+TzINGtTqzkvy1zM9MbslvCqc5syXHtlOCjb
	1STA7Y31izVKLmP7Hyrje6pKl1TBJxk=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2b458ca2296so57287465ad.0
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 02:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777195654; x=1777800454; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X8jAPi1Ug7YtuxDodtBim0VZYTDek6DS5vd5ro+n0/g=;
        b=EaLSxbdd8/E/Xc55IH6hTGyhwQKwYckWlqM7RQLAS8tnJVNwvlCqXsWhZsP6OqN6jP
         fVaLCosdTNifnuGTofcBRthcF/Ba2k0rU7Zx/i3R5/k+U+oU/AdYuOSptJUW7pKcekGX
         M40+QNHwvDDPElFfGamBejobOKT93/z14v7ZSyBMb9OYc2QziK2VJIizLWCmj/CXLZE5
         aT2Cc+hbObLhWUXrdUvW17xVXS1D2vpWRMWUpjDOWo9gC6DOFVP0g/5//lwZwJfH0oMj
         fFPSgeXIWoN7X8vPewj/73LFrSq69+LPnfFszc0ODGvas63vw45thbHOAbAV/jvfFM5v
         KXSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777195654; x=1777800454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X8jAPi1Ug7YtuxDodtBim0VZYTDek6DS5vd5ro+n0/g=;
        b=rnTdtOQh35OIrmFzeZTCfHgUHkLKNgXbhWV6WzpU3Sk+gvYb7rYIDd70zn38RdV9NK
         VjJrCLSBtV8TF5kS1GyxukMu5tdqhMGZ1x5Tjv8dxAyak0mIMstSHZvlh1OrWPu2UX4U
         2xKgRqrMZE43uAdEmCgNqOI4mkhi7p5q0/b6BaI7EBZD7KoLStmr7h8f3Pw6iRMxPZKO
         2ZwyNKAaFQJ1fwc2Zq7A5VuH868X0xl3nmRd539HDhb0pYUncaZqBR30CkQHvkxgKlsD
         4ZdLpF4muz5uyOdUwTgG/H1+MFunNUYH5ZLxK+7mW5iLccCGtI/NUujjmrvLe3kgFKqb
         SDhg==
X-Forwarded-Encrypted: i=1; AFNElJ/F1Hb7J9qsI2TlTDttIRcGrYdSc+7BSLk+nhtSEhCxuTTU/sXjQUR4XoQtrT0gXIP23fhGDLg8/Q==@kvack.org
X-Gm-Message-State: AOJu0Yyr3Kx7YmQRdzC+qZpBi9DX1r/W3qdDbEfvOyXKbyBGC9iP2ktw
	byCMd9XCdv0f65uQBVkpUr99ExazXSo47eD12LtJlnxZ6oULR1UDjBhFdjzpXDyuIO0=
X-Gm-Gg: AeBDietHNjfescK36lrtIqQMPmaTPduSADd6ajhrjbjgSAXfFKqtpJirZ2Jxs+yoLDE
	N/MNfjxIEcbxYHmluGxBBkF2nVeYVtFGOJ/+2S0/8jILzG8nNo60+YsdvX5VoXxZ2dgJlJVVsdn
	lJSatP63fTLEFZjhmISLauNmEAIBprK171bqlFaVlawlIGS62VVNPKPcMeqUZLgdmmHO4yrDFQt
	Yzixsf7cLYZHvaRt9cz0QOEOGP8aKfuhxtHggAV6QKG6LV6MyZssqakkOCI5BzvEz+Sr1TfXOks
	GVgS3lQRgvM8ZL/nUUw5bRSECfyYrmEw+9x/dyeCNV6JZjy5NJcyaxUW1dIm3bUePlIjKlDzxw+
	K9Ea+cmQnmlvL0KGAXyO/sMWgmIV8HXwIFt9ydwF14gYSjlFjosPNdz7CnSKn7DjbgHwOOJ5eK2
	UyOH33KQAK6BgHNt8X913XW5IL0BlB
X-Received: by 2002:a17:902:da8b:b0:2b9:547d:ccc8 with SMTP id d9443c01a7336-2b9547dce05mr31133985ad.30.1777195654294;
        Sun, 26 Apr 2026 02:27:34 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::34a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab0caa9sm270352885ad.40.2026.04.26.02.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 02:27:33 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v7 5/6] mm/mm_init: Fix pageblock migratetype for ZONE_DEVICE compound pages
Date: Sun, 26 Apr 2026 17:26:39 +0800
Message-Id: <20260426092640.375967-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260426092640.375967-1-songmuchun@bytedance.com>
References: <20260426092640.375967-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3ehy97tbsx4y4bxstxpnn1j4s8r35sp8
X-Rspam-User: 
X-Rspamd-Queue-Id: 97FE220003
X-Rspamd-Server: rspam07
X-HE-Tag: 1777195655-947558
X-HE-Meta: U2FsdGVkX1+SQG2sSuZ3NEu4ByoVafYNlbvVPiYIZDQQErhfPmSLkeXKqSjADkpL/B9VBvufTTXRajyK4KQYh+FiIQYUMOdBQKOBk0cHiefM0KLiiMIS3fP494sopMEbivgr89GNDSryKnXtmVp0G0z0B1AFCr1JDUzb9R4wYBzSrtA8CMPR1yz3TDjbg1SggGdm6K8xYdTKAKpQW/yTZzWKmaKlyFcfw8jjouwNP87d9qDuEIX12q9ytoybe/Z1AQrqVqDiwpnx+9PrJX9BWCv5xkm4Mpf5pvXwDCuuTXKWEDPqa6w/NIdPJW/o+em90mo+i57lISMXGrAJS0qRBQI6wLG6eDRbiS6d/G8j9TyVACTbWmP+JhUUXknDr0/PCzCu1U12kyW4kzRFL+TfA901GFBTxUhMMBsoiFgzHP9woHHkNkwUNGqOsGd1V4ipCc05eFUH8VAmxsKp5YjNBZnmigt65OfGqMC/FJI76Fk2mMj0FYD57JTlkaX1hBwbivQltR+InZrp0CaosBdEwYr/SlWpNuwUeFPofjmkF3snnvvp+JbCBmJE2j4fuzRFdDXtML/frBILWEpGXZhBglHr3XHks7MzDs/V1381J48cyrOyUnbhL2ZG9fF5s/NLc/vLLkp/MAioDHDczHa4xM7r8neVne5+gHKCx0mduQEqgxECEvJCJS0E6EYFQL7eL79ACpvaxFbJb0t729XNixtxyI34mWUoa54k5fmQ+0pZJFi2VQZF7tVqqIGC8E8e8BXGGRCRmn98hTD28z3Yqo2uLfULtbc1MEPe2ipoY+KTmCIVkVYIrebjPd2QQR6e7ZiXT9BF44XcsCEZs6HYdCKDuK/IhfGn+0egEBC3uoFphga21jr7jZg5fggQ19E1Rh0gmNv/FI8AOZkxWJ9QozYL9C0PeVhZbLoe0OUQ6S+QJMxf5qr9h1TPXLp7tfDrGUMebQK8c494BSdrJsE
 k62oaCE9
 z+ng+b5U13zkbeMySDu4IJm1rkCnq5beEDIcCPbR98G5P19weduBR3i51dqP0/+F8oBGlga5eO2DYjqAArqXVb7vVOR+KQJLqRWv5UyElo5mmLbXBAo4GPlaSPTNkLa8qOyjkW6/rxKKTxvW1VHzI3A0fXu8Eo1R+P628/oGxtGSAIjKHYrPzFFXX1/XQeKvVWDc4A/Yqr/ILfiJLbHj2kx9nREH9xcmVwA8IFwLvd1wsfDljoDN/41utcnopfyDTDuPnzgc03ZIAxrrPO1JiIcZNOzeAhTW1nQDXBIk+xGUZEy9/DjrkXaTw4a1vAi61E3EuVjkJCh2myeLVnG4I+Gy+OU69Kccprn+YmT/q16XL1g94l4s1p1AxjzHw34GVCl+kysOS+88mhJ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memmap_init_zone_device() function only initializes the migratetype
of the first pageblock of a compound page. If the compound page size
exceeds pageblock_nr_pages (e.g., 1GB hugepages with 2MB pageblocks),
subsequent pageblocks in the compound page remain uninitialized.

Move the migratetype initialization out of __init_zone_device_page()
and into a separate pageblock_migratetype_init_range() function. This
iterates over the entire PFN range of the memory, ensuring that all
pageblocks are correctly initialized.

Also remove the stale confusing comment about MEMINIT_HOTPLUG above
the migratetype setting since it is an obsolete relic from commit
966cf44f637e ("mm: defer ZONE_DEVICE page initialization to the point
where we init pgmap") and no longer makes sense here.

Fixes: c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for compound pages")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mm_init.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..cfc76953e249 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -674,6 +674,20 @@ static inline void fixup_hashdist(void)
 static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
+#ifdef CONFIG_ZONE_DEVICE
+static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
+		unsigned long nr_pages, int migratetype)
+{
+	const unsigned long end = pfn + nr_pages;
+
+	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
+		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
+		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+			cond_resched();
+	}
+}
+#endif
+
 /*
  * Initialize a reserved page unconditionally, finding its zone first.
  */
@@ -1011,21 +1025,6 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	page_folio(page)->pgmap = pgmap;
 	page->zone_device_data = NULL;
 
-	/*
-	 * Mark the block movable so that blocks are reserved for
-	 * movable at startup. This will force kernel allocations
-	 * to reserve their blocks rather than leaking throughout
-	 * the address space during boot when many long-lived
-	 * kernel allocations are made.
-	 *
-	 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
-	 * because this is done early in section_activate()
-	 */
-	if (pageblock_aligned(pfn)) {
-		init_pageblock_migratetype(page, MIGRATE_MOVABLE, false);
-		cond_resched();
-	}
-
 	/*
 	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
 	 * directly to the driver page allocator which will set the page count
@@ -1122,6 +1121,9 @@ void __ref memmap_init_zone_device(struct zone *zone,
 
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
 
+		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+			cond_resched();
+
 		if (pfns_per_compound == 1)
 			continue;
 
@@ -1129,6 +1131,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				     compound_nr_pages(altmap, pgmap));
 	}
 
+	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
+
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
 }
-- 
2.20.1


