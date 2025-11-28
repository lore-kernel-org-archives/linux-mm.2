Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23DAAD111A8
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 03:12:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 820A16B0023; Thu, 27 Nov 2025 22:12:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1316B0024; Thu, 27 Nov 2025 22:12:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E73B6B0026; Thu, 27 Nov 2025 22:12:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E6476B0023
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 22:12:05 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A2201A0333
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:12:05 +0000 (UTC)
X-FDA: 84158541810.02.233B53D
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	by imf08.hostedemail.com (Postfix) with ESMTP id 32FCF160005
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:12:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hbo00aHr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.210.193 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764299523; a=rsa-sha256;
	cv=none;
	b=7JgmqHquHxSZIqzWs8Be9vLEoLBkkbaCtshJt1TeVsqP6Zpt8eIVuPiWjPGdd1rl4wYGmZ
	k5hJ1azWaCwTIaNruOFYJ652wiTxq/TGGqZr+ow4blw3TEFTGNX4rCIPNLPkVku0IypWNA
	5/HEyo8u7/l8IClXoaZrwxQ1CgBQRtM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hbo00aHr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.210.193 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764299523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UURN4qing9DSF3ysybnLESXjHzZIzZMUCK3v5bSZiLw=;
	b=BS0KgyiV7kbXRU/j6bQAilXi+9/YpF6IQt5sTaJKG2NHA5a//3X9IIiC0t77iGgUXyghxT
	qLYyB454SyM+ec5h3cKXFGZAfip3nRA+9e7tlkkYY9/YpECRKhv6vq5tCQEr46hQ0dbG+b
	uJTxauYLrwcxEeJLBxz+El/fe09QAFk=
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-7ade456b6abso1096922b3a.3
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764299522; x=1764904322; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UURN4qing9DSF3ysybnLESXjHzZIzZMUCK3v5bSZiLw=;
        b=Hbo00aHr91lUcxUzo7dOn9DYAUABkHrNLvd2puSZ8mYxxJReV0skkHTIieRSgJwTEl
         l3wkmYNyxAKkn2yp5tVFS1ESRQAalueZ0RodoYVQG14zwYXT6/Noq7I73+gUGwDTeVXV
         OjeKpn48mLZQyc3ObROe6ruyAzWpSveJxFXpWoICqSNnAmuFXCkHkJcH8bIIhk/pWBnD
         iRTntO1U3/p7Srij+kvIQv63BnGg1+m/k0W4FYhhD+nrr/RVR8rh1liT1b6eif/h6Cr3
         u+ZppSNa5HXTpOMfWT5WDA1lXf6mP4nNPfu9nbQqRtXtH75K0qepphWnYgXym/R6Zl5Q
         A9Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764299522; x=1764904322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UURN4qing9DSF3ysybnLESXjHzZIzZMUCK3v5bSZiLw=;
        b=c3X2JsTsbpjLVfO6N0GAHtHyMkBJso+D+f/5upMUs52lQGw2YmMxztplSnB+w9GGwO
         MDma8HcaQwJVKCCEOYbic8cXICcJbh5xDX3Ci+uZZUmYbSxpPYCE1kISj14VxuMGycBO
         zu9RWDl7LZxmR85ZAW+U4Dua5hC84N1DrrBx3ytMkDZMWs+5trO9IyBmUHifGAih68+5
         LfdXf5RCEZk18CViUrDZ/EsHynQL/G4MiHCXyxJOf9xCjgWamaOvjkj0lZHryRvGcDN2
         eF7vbkJ/aqaANfKGic/UgrqOAFlKzPUf78VcuFQea196kcTokW/g1WZE5Z7XWbdfmhQl
         Ch/A==
X-Gm-Message-State: AOJu0YzmkTky/kQ7c2cneWgUyJyp/ghZcZpwTsyoFe5a9iFhtYmD9jIs
	JFoK2sUBRvLro2RRkq4nqWddVtINtBqDGWSVYovB5jVuX5/S/Udbx9z2
X-Gm-Gg: ASbGncs0QErJavAMbzaznUYhovn+PGPLcmyw2/WI8sArtBBapA+8+6yf7G/Snij/BIW
	TkpBaVQMZ14OQdwWYPBwR7e+7+IaqhI4ykhghegpZW3uAwDRhVahB2h2y/SKXiCh2x1L7bBK1Xl
	R3wyhS3Zg+XEWFLzpjHJRTUJYrX1HjSl+KX4Zz4z8JoTMhWIDyT1lEdyDPUwEl/Ln8e4cT8Z0Dx
	ofv1ezKVmFJkK3fWTJ+kTBteeCbD/Bl/mh/6BzfwM9vvqE45304z8M2llrVguSLUEeM+4RjyNJh
	7UgZzsYbk9cpSyRq7kT4GkjXQ48OE9lz7l0P5/jNAEGT+0hy3jcs2PYnDqZKqosFFFV9P0pWJMT
	YNJwEAl7nezD4ui3lB7Z6iToK1xke3XI2N1jqP3TfQDbAU35A58nvWmcvKHbsZodNJECcwo3Q0G
	WMU3cZa9AikJYnZtrmqf6/djopI/mb0e66X32/Ig==
X-Google-Smtp-Source: AGHT+IH01szTUvjUWPgozI/rwQ/A0QsBtn0PFJolC4W+66Z3l+siWZ7TigqC/fsl6tVQiWrY7nIbtw==
X-Received: by 2002:a05:6a00:8d6:b0:7ab:e844:1e76 with SMTP id d2e1a72fcca58-7c58c2b20b5mr23898778b3a.5.1764299522057;
        Thu, 27 Nov 2025 19:12:02 -0800 (PST)
Received: from zhr-ThinkStation-K.mioffice.cn ([2408:8607:1b00:8:3638:7863:b439:f5a7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15f080cf1sm3245651b3a.46.2025.11.27.19.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 19:12:01 -0800 (PST)
From: Hongru Zhang <zhanghongru06@gmail.com>
X-Google-Original-From: Hongru Zhang <zhanghongru@xiaomi.com>
To: akpm@linux-foundation.org,
	vbabka@suse.cz,
	david@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Hongru Zhang <zhanghongru@xiaomi.com>
Subject: [PATCH 1/3] mm/page_alloc: add per-migratetype counts to buddy allocator
Date: Fri, 28 Nov 2025 11:11:42 +0800
Message-ID: <37a6c6c35e029c3429f236d5895c898140d991eb.1764297987.git.zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764297987.git.zhanghongru@xiaomi.com>
References: <cover.1764297987.git.zhanghongru@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 32FCF160005
X-Stat-Signature: p9o8bezkuecd4cfg5yacce7b4f5ddnrn
X-Rspam-User: 
X-HE-Tag: 1764299523-148535
X-HE-Meta: U2FsdGVkX19shc/pxSp9D6DQ+J1zg0pA8PB5HrZIT1Z0099C3EN+cTNeHh/aqpciTGQPuWk0KluBwK2wRkM6F5g+saoH3I/MmEhydLgFVkfappgLX6JhUxXUek9XTMEoaCh0JwSNyt92QrmDxbTf5TZuG3AB38RXBTXPvwtsJbvrEEBEpcpcTJ+lR6W3lLDO0Ys14KVx6IpZjjQWLH5vQrfk7uO2lh9aoYPM/u9xdysNLl2pbLVaBTOLeIc1IfAyyaw+EsvPXFn2qXyTto5O505Td2faUg2Ujz1XW5irh5GT0OT/QeO7vbU6hREklJqnPoVqLJQ4kDqxZ1AfEpyajNrtft+hQBl8XklQiU9Lzu7FNaf9wCg1pAmB/y/VoaId7wdv6/LkTyMW43Qzy8DrbMeRbX4DiNhIujYtbLiLzi3kxftzCWnVSxK3+oi4eKbJ/UQkfdWBrSlMUgs2PPYD9YaW7RvC/0lo6VOKizoORMDd9fRgqyB7CE2pCRjgVtC53AtoOQmVdzS0eaR14qbq8/5cV32X5YgsejCFM/C4duf+RlFYsR8FEyyKCAyAWcmRMWxUt+E1t03tnUN+miGNd8trpHdcVpRH9ahw4l5IRs00No69YvSPgwd98SuRXmdJdMkdEBoQxDAurErHXaCfJwnrOEBwtdnIRwBbaCGK+4ehP8YQLDfxITfysChGfysBrjA6WRfDHbgiaR6mPoGfUsCFX0VCt+fXi31sktZP0o8iBec3G26BchCD2pPpWlNBQy+2nn7b1isakBFvnFRg5gQTKZvfvthMbI37LXhWjmwmmNr2V9u4vyzd614Dzg6dR5zv79RBo0KNXtB94CRjDCyv0HARbacMdWMw9bL3XWG7ZaACLFQTogMOW/AG9MRhkVcEM3S83hLi0shMhu0zpGowBHob00TtmANKY329c+Kqv2M92h2LPYCYjl8FwVTP+vG3uePhFikOTbEQ5/w
 4gDXcNoP
 +14YrGgEqZ0vIlefQWHuuON+MAOrnHE1ilmD5vVjKmbq+Y+vVqUOZuiLGDeE8ycV4q6uVH3kK5n09sEnOf+DsbGkCKEWVNHSsklrvKJh4qKPbGkzoQ1WvZ0bL2ONSkPxTtYzO+TL8bDoZTca/h6ZBgthokJrJgKb7MHlU/Fg2UoncVR79t2cfgzAskcpbCkNlOonIHMj0zQL84H+o3hSuwW7FFs5KRh4Mrliarp4/85i2uHWNxfxIOm0eQGTXqcgKnQEVCiUGQ+4lTpM77yIbiumI+mYldUsfBY5PtvpThWFqNKgYNiyxo5ozJeHGfB3SGuMDle+Rsmey2XdwPBkJNljynId7p4bpG51fOomlV3+LwPQ6sPZL2kqSt3Qr4lpVm1wrwRuvfUk6mGIlkGK/aqgu5psSdFFLuw9M381II5mv5ds1/8NCtsGO8t/xp6SKyNPLVygETje+15cu6XXLHBZvslOzb6ATLMojixBH5VJ/xgiekvoPbxcL+NG7ua8uRZuDyd9SeMb3auhdHvQaB0DYX/36F29zIG5i7mp4DMj/qLqGdH2GBjWSLUyMdfi6tog20PkKfL5HqLk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongru Zhang <zhanghongru@xiaomi.com>

On mobile devices, some user-space memory management components check
memory pressure and fragmentation status periodically or via PSI, and
take actions such as killing processes or performing memory compaction
based on this information.

Under high load scenarios, reading /proc/pagetypeinfo causes memory
management components or memory allocation/free paths to be blocked
for extended periods waiting for the zone lock, leading to the
following issues:
1. Long interrupt-disabled spinlocks - occasionally exceeding 10ms on
   Qcom 8750 platforms, reducing system real-time performance
2. Memory management components being blocked for extended periods,
   preventing rapid acquisition of memory fragmentation information for
   critical memory management decisions and actions
3. Increased latency in memory allocation and free paths due to prolonged
   zone lock contention

This patch adds per-migratetype counts to the buddy allocator in
preparation for optimizing /proc/pagetypeinfo access.

The optimized implementation:
- Make per-migratetype count updates protected by zone lock on the write
  side while /proc/pagetypeinfo reads are lock-free, which reduces
  interrupt-disabled spinlock duration and improves system real-time
  performance (addressing issue #1)
- Reduce blocking time for memory management components when reading
  /proc/pagetypeinfo, enabling more rapid acquisition of memory
  fragmentation information (addressing issue #2)
- Minimize the critical section held during /proc/pagetypeinfo reads to
  reduce zone lock contention on memory allocation and free paths
  (addressing issue #3)

The main overhead is a slight increase in latency on the memory
allocation and free paths due to additional per-migratetype counting,
with theoretically minimal impact on overall performance.

Signed-off-by: Hongru Zhang <zhanghongru@xiaomi.com>
---
 include/linux/mmzone.h | 1 +
 mm/mm_init.c           | 1 +
 mm/page_alloc.c        | 7 ++++++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7fb7331c5725..6eeefe6a3727 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -138,6 +138,7 @@ extern int page_group_by_mobility_disabled;
 struct free_area {
 	struct list_head	free_list[MIGRATE_TYPES];
 	unsigned long		nr_free;
+	unsigned long		mt_nr_free[MIGRATE_TYPES];
 };
 
 struct pglist_data;
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 7712d887b696..dca2be8cc3b1 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1439,6 +1439,7 @@ static void __meminit zone_init_free_lists(struct zone *zone)
 	for_each_migratetype_order(order, t) {
 		INIT_LIST_HEAD(&zone->free_area[order].free_list[t]);
 		zone->free_area[order].nr_free = 0;
+		zone->free_area[order].mt_nr_free[t] = 0;
 	}
 
 #ifdef CONFIG_UNACCEPTED_MEMORY
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ed82ee55e66a..9431073e7255 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -818,6 +818,7 @@ static inline void __add_to_free_list(struct page *page, struct zone *zone,
 	else
 		list_add(&page->buddy_list, &area->free_list[migratetype]);
 	area->nr_free++;
+	area->mt_nr_free[migratetype]++;
 
 	if (order >= pageblock_order && !is_migrate_isolate(migratetype))
 		__mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, nr_pages);
@@ -840,6 +841,8 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
 		     get_pageblock_migratetype(page), old_mt, nr_pages);
 
 	list_move_tail(&page->buddy_list, &area->free_list[new_mt]);
+	area->mt_nr_free[old_mt]--;
+	area->mt_nr_free[new_mt]++;
 
 	account_freepages(zone, -nr_pages, old_mt);
 	account_freepages(zone, nr_pages, new_mt);
@@ -855,6 +858,7 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
 static inline void __del_page_from_free_list(struct page *page, struct zone *zone,
 					     unsigned int order, int migratetype)
 {
+	struct free_area *area = &zone->free_area[order];
 	int nr_pages = 1 << order;
 
         VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
@@ -868,7 +872,8 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
 	list_del(&page->buddy_list);
 	__ClearPageBuddy(page);
 	set_page_private(page, 0);
-	zone->free_area[order].nr_free--;
+	area->nr_free--;
+	area->mt_nr_free[migratetype]--;
 
 	if (order >= pageblock_order && !is_migrate_isolate(migratetype))
 		__mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, -nr_pages);
-- 
2.43.0


