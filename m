Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 596BA1125892
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:52:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6D036B0099; Wed, 11 Mar 2026 15:52:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E10F46B009B; Wed, 11 Mar 2026 15:52:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB10A6B009D; Wed, 11 Mar 2026 15:52:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B57956B0099
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:52:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7F2EA140378
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:52:08 +0000 (UTC)
X-FDA: 84534828336.11.48CCFFE
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9928518000B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:52:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BzuUMR5a;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773258726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9uGTcZbp7r+H1UaYa68xNPMIKqxUKJCwYhvaf1Y6xf8=;
	b=V2h4P5NFvAfT6mrM9d5P9GQ7ER/NkDbgPMlOtMXCAQ3g53RQHBj5XYXc0sA7pY5RQMc3Ii
	9blteRIcVdXutbqaDmPDxcchC3PHIxheTnXdnIjFldFqCiQcgzLq5MblXH+o5HZh/QYxua
	rhIrd/dfsstCcwgxVkILQpn9cXegh2A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773258726; a=rsa-sha256;
	cv=none;
	b=tzOZyNNCbd0NaMXfUxDAfQT5YL6qb6Tyxenlvy2dBq3zK21MYz/KVMobcqY2RWgRwplkCo
	rCBwhtyHDShMThEdTalIzLN3K0sLJ8jzxcldgJrMvdE2n4NeHm/ZIBPiz7EL4vSJQaXrru
	SS3fHP/D1IBxFfd0aQwAyyEWiWvdsNY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BzuUMR5a;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-415b23dd6e5so120848fac.3
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773258725; x=1773863525; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9uGTcZbp7r+H1UaYa68xNPMIKqxUKJCwYhvaf1Y6xf8=;
        b=BzuUMR5aKMR2KECBsEdNLLhmm0tuItv/vwASXYNdNLdHoc7Hgwefe23Oc8nbWDActf
         OQm+/ryeBh4RDBIc4B+MdARW6fsMoELpJ80BQifSsL1RRctZYAvAlcPNIrnbSGM0QSP1
         U2ju6W2XgV5IDZLq4prwupybRg1EttiGkEmwoCSerrU+N0fJnu/r6EaVqpw0wcZKqcvH
         j0VEqzeyFZWy0pjj/+U0xztp3ugc++x88H1zJcCYSE/wSl6mO6yWvceq0CM+GX11Xi8l
         0wW33b0cy789DOHvlD7h33fimdjWcP0FEqYhTWDNCIUUmfe22EGrL00LZPkqC9Ae7zr4
         YwUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773258725; x=1773863525;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9uGTcZbp7r+H1UaYa68xNPMIKqxUKJCwYhvaf1Y6xf8=;
        b=SLjsmKHhzNpE9PMxQ4Ov7h3SrFCU3YTGpRISSFR9sNWEn5lT7TtFJxHRw25b8CrxWl
         XFSeANpFIbI/OuefEOmz9sUg9yQZuvEiNnnz2JMyxsKl3sTqC5H7bnKv5mM8BfN96XD0
         +Q/+ac3YePIXTm6bGBB82sZnV+jcY2sla0DA7mrHtbzRoN9sGVLsM6simmt7WpEztniH
         vv4ZbP8l7n8xtOGyw4XXoxL/iY//h6Be8P8zOkLt0T+tS1H2h6fKYuTKMUAVZwhm3nX+
         6q+OQ8ynVf3b/1jxLq6YQFSjMOCSvEw246Cx0IAc9jBsZyr3DtZIiDaiuVATeXm2VVfd
         7t1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVLqkleqmcD/oGdZig8O3wrJARWnzxhLBqQ9kzFNN690nGi0NEeykdJiL0pRlrXLBRVy5muldwy+Q==@kvack.org
X-Gm-Message-State: AOJu0YzjLQV6jVJtI4wbc56xnUIGsaWwAkBJXMIdH+3r5oJYoxg4Ymxm
	pBUCsmFFvZPXjkPuFLro0MprPKtnMA8zlMuSDvLFcp7bpVeh1rwtGJLk
X-Gm-Gg: ATEYQzz8Dm8TURazK2VpEtYX2xuF2vM2WkII+EZjPoAebVNu6BDU0EuHW1/TWK992t9
	yH93AxIXOks3+LQvcqbvPCV/Z98qd0lcmhzvP5VRJJF8/SOS0uwlS4k22dGB/f5k4stzBp0NNUt
	GghCp7gUXC4b78Ro72gaNRsb2PIhlqnPxP42aTKjW8/Izc3OgLzsFI2+0+AOJjOdBOAWtee3jGx
	RjAdlo00JO6QDmV2tRAf+HFIwGlkdw4VkEHH7JqFCSg2mEDr8oOnhvYlKVM6AvCZxT6k9L4Eh4S
	ESXIm8dIKOY1EtqpNO20alGHM9Ng3gqQD8UJVHlI2j3p1nu+QtIqlRaqRUXfEm15h5ivezV3qbH
	FFbPzroqjyC13lDoEOxKQYr7Kiqw5uIzip1wAuk0ZIsCwDqGpUQO7IOjwqaK3ZNKrkZVlY6evVv
	iZRg4O5SpHvcJxQVapyWft5g==
X-Received: by 2002:a05:6870:3c8b:b0:417:31f3:5def with SMTP id 586e51a60fabf-4177ca59b45mr2303457fac.32.1773258725506;
        Wed, 11 Mar 2026 12:52:05 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:46::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e64a931sm3100861fac.14.2026.03.11.12.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 12:52:05 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 08/11] mm/memcontrol: Track MEMCG_ZSWAPPED in bytes
Date: Wed, 11 Mar 2026 12:51:45 -0700
Message-ID: <20260311195153.4013476-9-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ei6nwwewghsksw99o157ck7rf4ehss87
X-Rspam-User: 
X-Rspamd-Queue-Id: 9928518000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1773258726-883642
X-HE-Meta: U2FsdGVkX18b9Dmv35UbcJz3jrMffaSpq+F0nPd9n3NFcNXJWQ7xgZSwjiOkFS7NXVHX4FUIxQ3DIy7xv3Z9z6qXPI5icw6lCHmGnOi6SogosKE4B+XSG5Zx1c0mtdtdbruXMkR4Ny+vyftZA4GZcICntw6cTqGkpYDbGWnsnFNNliL27pwEZcAZCw4tVROToBmSG7QzJbLS4+1H82HYW8X7BAFX1LdbBbdxGOtAB/63c7DPrMSSCHpc6D2Khn5odY69wZUTSacu4XxBYucdnhbnxG+vu8Hi3DMeQUow9oFuoWivxJ2wTwHcXOdiLwFScB73vZlA5aJiuZIoLtF+Wtv95ADm3m5IdsuE/+ZOqJtnkk3o4tptYs6P8Cq0yNm4urvor1shqY9kblr7RJjkZ5+H7ApPgjsj06i9mEgT3B36+jt02YSHuoJHyK0GKXvv4eX6SYqsZ1eoaYkW1zC+/etOclpqy0TMn2l2HdUGBumxG/eXkVMmW6QRukGapI08s1X3HrJRL/DRGR9acWii/BUoFLHWSbTvrorhbUQr3XiJL592/Uk1GV8RxwTn+KVnID/jAr7jTmuQJhqeBGZWKNQXoYl8QEBq4/HKyADwpg4p6NhR9V2JeVDz2Fq4lZYXbIBhjFDdTX6PKezVAqfSU9ywQRTtLw/0Z3BtmCzlbK3dedamlZfbXBkHDk2Zy/7JhkrCTgblhUEs9jr4OwP8hJJ4sF3XJV+FK/138kotrZU/UQfXaq2t50D1N2r9p7QBupi70Bg2KToBmPUZdWRDjS6Udva59FMikZemnyiE6l5rI/YpkDwcVw/kn2MEwwfWtS8s9f45DvrCAINKtQ3Ypc4D5GnTsqeUvn5O5h6O438nef796VFl4eiKhpAHar80+fabCq78izpDj6xbIkTMsWAB+YNfmUIGY4erfAPIi1UkejSdwgT5j7TOaBYPXEAVsqhYXiQEpehuQv9KN1v
 CA692CN5
 zjYPTaZV325vPZC5f7yCcIYjuPUB+qNtEe+5+2Yzcj3GqfZfw6Npcn6691XDkeNMkVo+Ay7gxO7rLBPqzAvQw3zemt6h/R40QOL3V5qiiwMUSvtSTufZHpi/cvn9h6d0lFb3TWnLGUeJbaWMzr7GiDdsNQjRwzEWB6IRZrcHx21T/P6NJT943XTW8++ejB4T5YRN8/hESiiL8NDAouBH3nq4fIJ9iISA0LkNnYIezr2ZpnezmZ4r5hh+hpy/fN+xzO/nRqW0hbsucXOPjsNeYDsLS835b6GWwsTTLc6htXlS/VXDhkqBUuhXqRYocWcNJ0tj9r/2DPsG20N99yihIDHiMM2QfEolKitJJhub4xAeAXsOC+v+Dw5tFmGixGylns0y8zplqUkYVhCEcK08eoepggZu2wHv7mUXoaYRx11IkY/GpWIWG3pAFhc6pUIaWDhVAaSmWvKcfjHs1GTfO1S4Zoqb+f9KBgMCQB7Iv31eRnRSvQpS7z3n1Q1Dls9i8892cLJPVDok2M9xgQLMM3+EYt2vQQb7Y25G7eec89UXjl4TeGpr1ylVhRwNIHnCm6VeDOtVYdsu9ssU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Zswap compresses and uncompresses in PAGE_SIZE units, which simplifies
the accounting for how much memory it has compressed. However, when a
compressed object is stored at the boundary of two zspages, accounting
at a PAGE_SIZE granularity makes it difficult to fractionally charge
each backing zspage with the ratio of memory it backs for the
compressed object.

To make sub-PAGE_SIZE granularity charging possible for MEMCG_ZSWAPPED,
track the value in bytes and adjust its accounting accordingly.

No functional changes intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h | 2 +-
 mm/memcontrol.c            | 5 +++--
 mm/zsmalloc.c              | 4 ++--
 mm/zswap.c                 | 8 +++++---
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 701d9ab6fef1..ce2e598b5963 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -38,7 +38,7 @@ enum memcg_stat_item {
 	MEMCG_VMALLOC,
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
-	MEMCG_ZSWAPPED,
+	MEMCG_ZSWAPPED_B,
 	MEMCG_NR_STAT,
 };
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 68139be66a4f..1cb02d2febe8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -342,7 +342,7 @@ static const unsigned int memcg_stat_items[] = {
 	MEMCG_VMALLOC,
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
-	MEMCG_ZSWAPPED,
+	MEMCG_ZSWAPPED_B,
 };
 
 #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
@@ -1364,7 +1364,7 @@ static const struct memory_stat memory_stats[] = {
 	{ "shmem",			NR_SHMEM			},
 #ifdef CONFIG_ZSWAP
 	{ "zswap",			MEMCG_ZSWAP_B			},
-	{ "zswapped",			MEMCG_ZSWAPPED			},
+	{ "zswapped",			MEMCG_ZSWAPPED_B		},
 #endif
 	{ "file_mapped",		NR_FILE_MAPPED			},
 	{ "file_dirty",			NR_FILE_DIRTY			},
@@ -1412,6 +1412,7 @@ static int memcg_page_state_unit(int item)
 	switch (item) {
 	case MEMCG_PERCPU_B:
 	case MEMCG_ZSWAP_B:
+	case MEMCG_ZSWAPPED_B:
 	case NR_SLAB_RECLAIMABLE_B:
 	case NR_SLAB_UNRECLAIMABLE_B:
 		return 1;
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 291194572a09..24665d7cd4a9 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1047,7 +1047,7 @@ static void zs_charge_objcg(struct zs_pool *pool, struct obj_cgroup *objcg,
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	mod_memcg_state(memcg, pool->compressed_stat, size);
-	mod_memcg_state(memcg, pool->uncompressed_stat, 1);
+	mod_memcg_state(memcg, pool->uncompressed_stat, PAGE_SIZE);
 	rcu_read_unlock();
 }
 
@@ -1066,7 +1066,7 @@ static void zs_uncharge_objcg(struct zs_pool *pool, struct obj_cgroup *objcg,
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	mod_memcg_state(memcg, pool->compressed_stat, -size);
-	mod_memcg_state(memcg, pool->uncompressed_stat, -1);
+	mod_memcg_state(memcg, pool->uncompressed_stat, -(int)PAGE_SIZE);
 	rcu_read_unlock();
 }
 #else
diff --git a/mm/zswap.c b/mm/zswap.c
index bca29a6e18f3..d81e2db4490b 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -257,7 +257,7 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 	/* unique name for each pool specifically required by zsmalloc */
 	snprintf(name, 38, "zswap%x", atomic_inc_return(&zswap_pools_count));
 	pool->zs_pool = zs_create_pool(name, true, MEMCG_ZSWAP_B,
-				       MEMCG_ZSWAPPED);
+				       MEMCG_ZSWAPPED_B);
 	if (!pool->zs_pool)
 		goto error;
 
@@ -1214,8 +1214,10 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	 */
 	if (!mem_cgroup_disabled()) {
 		mem_cgroup_flush_stats(memcg);
-		nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B) >> PAGE_SHIFT;
-		nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
+		nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B);
+		nr_backing >>= PAGE_SHIFT;
+		nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED_B);
+		nr_stored >>= PAGE_SHIFT;
 	} else {
 		nr_backing = zswap_total_pages();
 		nr_stored = atomic_long_read(&zswap_stored_pages);
-- 
2.52.0


