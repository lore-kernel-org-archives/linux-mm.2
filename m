Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB4EE1088E49
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEC0E6B035E; Wed, 18 Mar 2026 18:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B0A6B0360; Wed, 18 Mar 2026 18:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8D936B0361; Wed, 18 Mar 2026 18:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A04916B035E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:30:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69D49139A45
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:16 +0000 (UTC)
X-FDA: 84560628432.10.0D0DFB3
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id AB42F2000C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dco5Cnec;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773873014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXKD+ZPBl4vkSnE6k01eq304ZeGimzAEjHRoiYkG/+4=;
	b=RyIK+rUs5o6sNC6iU6/430gnes8W5dOVsQNkfl0F69y4FgquwprAjilftzd2BuA9Ytk0G/
	MxK8WTbceazUA6T/oKoulfStqz7WjCs/dhcGgZK81VfBTTQB4jzUI0Ks8ceAf3JXZ1nxAI
	A6OWZpeimANDXRN73pfwPvngiO/YC+8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dco5Cnec;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773873014; a=rsa-sha256;
	cv=none;
	b=0z68D6VOodiyFwf6woHLILdbwv6woApadusxsOabxdZUijQmKob46yXoo3gFI39v36tZHX
	trjkCzGFSxlMMKOJGupjdlfzmAEsYPhY4hyMRCAUOEmHLpwDeOwvISrfMjcll8fRVcezM1
	VnlrGQNbsvSAn5BaVd6s8Klf+hz4oZw=
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-463a0e14abfso54429b6e.2
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773873014; x=1774477814; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iXKD+ZPBl4vkSnE6k01eq304ZeGimzAEjHRoiYkG/+4=;
        b=Dco5CnecSDTY9JpDvgmdvHIUMfGAFLXh6r9Opvo/Ck31JpezU7dBnqQj8dkHORKavK
         QadbPjaTF97iHB7mfLItQRLnv49sk8foj1b5s1/yliv5A6EqOExRJak2Yb95lQLx3UPT
         rhaTp1FNDRBECusRzFPK6O2ZGIcTf/GqIzRkSbdxZeSCPOo9K5IZM8gpIZgCEYUPgp7O
         CxFpCiNO3SwY9yHF4fkjUpbvlSY6B29xfahNFX0MJbPB3JTgKzzN/5ptLA6Ot3NMoIwJ
         cZnRh8sICpVmh0OEO5FSQSq2mmCbwY5jSKeU+qxHKz4QzWYZeZ7mIwR5hrlU4kb8aoSe
         Rt/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773873014; x=1774477814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iXKD+ZPBl4vkSnE6k01eq304ZeGimzAEjHRoiYkG/+4=;
        b=Z3WK7U+EnSWYuQmQYTYaBEfBMt+weZ/I6zrGojav7ZSB6mfnZD0CG+HuQiODn/U4rL
         s6RgXl3I54sOlWB2Z5UuAVZ5RoSv6T9oh5jZUvFkfw8vn2lTzRuCfuOnRZzOi/jkn3n3
         W4ePQidi6W5lxnRmh6wSO2enSVz6ik/I3Fn4z38h0MP6xUzhs1esgi0SzDYRuccr5sbD
         7fu1dRRyIKruAygOMoIvVZ44Wz8PE+FI5tZC7vPzHxd1LOjPBIsG1alTvEc9JsRBYtsT
         /nkToMUYhX+BVGJh3tupmFthwZTIVzzqRMgJ5zhOmpcuEsYFHdtKIgGNwkFqdVwtXUB6
         GrUw==
X-Forwarded-Encrypted: i=1; AJvYcCWkeaq5Tk0edr9w05JNfHTkX5/wVZOE9X/P4D1mvQYfC+CZuIz3ZFIvoo9VGitOWRP2mvI/KCbzLg==@kvack.org
X-Gm-Message-State: AOJu0YzMBxTwORCJrtXYvsOM6E08Z/rYun6ONW1l5CXOa5Oi8w4i2Vsv
	JvdavgkBJ3kOqWXX5KWBgNqdFCXxKbBKoAOPUW61dku4rIsTH/ImTVHN
X-Gm-Gg: ATEYQzwOCkZxZ7+C2PNcPFTNIwwzxbuxf8RM1SS0tJmK1+vU6vGuMAFN75qSieYpDQ1
	8ZO70vFXZpt1t5s8lXCLDx8IZ1y2RILh7ku8rcJx8U7qw98pCPx24fVxCWBc10cSbdp7GfVzLlA
	6AqvWM7fulvnKmDDXivvlj33wKgQXU/CMQDx53NMyuAXYeT464fjBeg5U97BtE+LPkj6gBndSIT
	1HMJp47dRpLdG2I7GRwT9aPbe6zjYv3Yu5KT0A03J1cVaN444W2fiWY//VUBNY8W+IDZceA4xti
	bz8h+RucZQ8ph052lrEMdwLappEIZtIayrC7uFbokGry3plWBrEeBO6NYvn1aeM3p9rF/FNHQgi
	eGVr2L4MWt6NTYwhCPQdLyb7kpasjCrKC7uby48kSm8mtacEZxovs6JlRdU5jV+mWL/QNT4q8Yv
	iltF9905+zQleZQ3Qx/eeWIsoB4WxIaiodltbMIwfswJvm
X-Received: by 2002:a05:6808:10cc:b0:467:11f6:917a with SMTP id 5614622812f47-467ba293991mr3007396b6e.38.1773873013609;
        Wed, 18 Mar 2026 15:30:13 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:3::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-467baa8db48sm2569039b6e.10.2026.03.18.15.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:30:13 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com
Subject: [PATCH v4 11/21] zswap: move zswap entry management to the virtual swap descriptor
Date: Wed, 18 Mar 2026 15:29:42 -0700
Message-ID: <20260318222953.441758-12-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318222953.441758-1-nphamcs@gmail.com>
References: <20260318222953.441758-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AB42F2000C
X-Stat-Signature: u6d1ty7rmst4n1ahscy1hau8e8fhcryg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773873014-701563
X-HE-Meta: U2FsdGVkX1+3NBDx0ROMApYGwVxBW6wYR5fD5Yj/P3BSLUl+3U/lVMmGHkI8wb2XZ0HiudxlodfWwShkq7s61Sfvqs8cVoPdw25/MYSgWdv9tLpHhUh+qH8VHkPBfU/Fe6V+VmQsa9zWP4gYaU4STRslUAP1fJZZcLrzab4yR4E04pUWrP7QsBkN+GCUWV50TzhnE16oic/cxwO8DOKqVrexnJH61ekhN/hxgwDk5oSk6+5UZi2/a04aQdjx5QjweMU6F3yxKTMhBY/sptd3xIDy7XpDzTz9+v+A1BeDxlbEFUgJHNGRMKxV28qroZHznjc5n+AIJSrR1gV/9W4GN49Ge6Wfae5PfQes8bNXXIv1hNHAiUyoWvWRNTKGRPJzzgldPMokxirHozoKdDjmXEUnId14Tf8xn7s+cFryFwIWHOCASbTuJUx6rRmmQHBYQQ7TGjA5b4ukNk0opGdO10xrbDnMPCWNrk5ZCr10I1coQIoEWuonSta1Qc7P8N/jXTFbk224lK6RRBDivRh11cD0aMSd+jgXoyhrOSlBF9xC/quzH5P1EFQ3izYkGP7GDnyxvkg82mrzgdxa6OqdPeIfhz7U/Upjljh9Y1sgm/nIKeRGHuk3LBVJUJImvG0VhGhMj1ZJXz+ds17byz+UJ47TqIcgli4nH5RAoKZZjV268E8dRToNlPl7Ny1PhQfz18aRDNNftLveMmt4Lg1rBI5qdGb0kJ+K/jkhdCW6Jj6prpn/mlvsfT/wnhVqogqE39HYZyajdSo8V+oEzdU3P99s0tTJ1oKgwFii2Wr4STnBX4u2L0+W3M+h6cWnYeSM0VJKK5ZoMNvXnM6bljHxLPvDbviJNryok2+TcLn6hpsVRuEIUrrUMJ+0rS7Y19dXnvQdba60K7Dh8Zs2tVjTLAgLMXW/iCwggUPaBLBZCiRMAt7rji1GjqTpUM7PkKsxchoVg9mkGh0yKmBOAKq
 dGzARkoM
 Bdwhz2D+p9ur/2H2Cy31C3T4Y2G2TJ+pXGHc3llJ/BzBkA9qmRIroNULnXGYJJco5OzIm2BlODp9epIghIL1cRLF+Fbn7FYTZ4vnHl3LNhySedCw+szRL0ESvv+EjqwSi55LklammmVMjJmRqd/t8nyKLQXLAmZYjFOM+KIiMCnynShAe18p8sE4AikwDriy1haFGtz6IGpJchbNMkFO6ZeJuOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the zswap tree and manage zswap entries directly
through the virtual swap descriptor. This re-partitions the zswap pool
(by virtual swap cluster), which eliminates zswap tree lock contention.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/zswap.h |   6 +++
 mm/vswap.c            | 100 ++++++++++++++++++++++++++++++++++++++++++
 mm/zswap.c            |  40 -----------------
 3 files changed, 106 insertions(+), 40 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 1a04caf283dc8..7eb3ce7e124fc 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -6,6 +6,7 @@
 #include <linux/mm_types.h>
 
 struct lruvec;
+struct zswap_entry;
 
 extern atomic_long_t zswap_stored_pages;
 
@@ -33,6 +34,11 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
 bool zswap_never_enabled(void);
+void *zswap_entry_store(swp_entry_t swpentry, struct zswap_entry *entry);
+void *zswap_entry_load(swp_entry_t swpentry);
+void *zswap_entry_erase(swp_entry_t swpentry);
+bool zswap_empty(swp_entry_t swpentry);
+
 #else
 
 struct zswap_lruvec_state {};
diff --git a/mm/vswap.c b/mm/vswap.c
index 371dd147bf70d..f2ebd79854572 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -10,6 +10,7 @@
 #include <linux/swapops.h>
 #include <linux/swap_cgroup.h>
 #include <linux/cpuhotplug.h>
+#include <linux/zswap.h>
 #include "swap.h"
 #include "swap_table.h"
 
@@ -37,11 +38,13 @@
  * Swap descriptor - metadata of a swapped out page.
  *
  * @slot: The handle to the physical swap slot backing this page.
+ * @zswap_entry: The zswap entry associated with this swap slot.
  * @swap_cache: The folio in swap cache.
  * @shadow: The shadow entry.
  */
 struct swp_desc {
 	swp_slot_t slot;
+	struct zswap_entry *zswap_entry;
 	union {
 		struct folio *swap_cache;
 		void *shadow;
@@ -238,6 +241,7 @@ static void __vswap_alloc_from_cluster(struct vswap_cluster *cluster, int start)
 	for (i = 0; i < nr; i++) {
 		desc = &cluster->descriptors[start + i];
 		desc->slot.val = 0;
+		desc->zswap_entry = NULL;
 	}
 	cluster->count += nr;
 }
@@ -1009,6 +1013,102 @@ void __swap_cache_replace_folio(struct folio *old, struct folio *new)
 	rcu_read_unlock();
 }
 
+#ifdef CONFIG_ZSWAP
+/**
+ * zswap_entry_store - store a zswap entry for a swap entry
+ * @swpentry: the swap entry
+ * @entry: the zswap entry to store
+ *
+ * Stores a zswap entry in the swap descriptor for the given swap entry.
+ * The cluster is locked during the store operation.
+ *
+ * Return: the old zswap entry if one existed, NULL otherwise
+ */
+void *zswap_entry_store(swp_entry_t swpentry, struct zswap_entry *entry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	void *old;
+
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, swpentry.val);
+	if (!desc) {
+		rcu_read_unlock();
+		return NULL;
+	}
+
+	old = desc->zswap_entry;
+	desc->zswap_entry = entry;
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+
+	return old;
+}
+
+/**
+ * zswap_entry_load - load a zswap entry for a swap entry
+ * @swpentry: the swap entry
+ *
+ * Loads the zswap entry from the swap descriptor for the given swap entry.
+ *
+ * Return: the zswap entry if one exists, NULL otherwise
+ */
+void *zswap_entry_load(swp_entry_t swpentry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	void *zswap_entry;
+
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, swpentry.val);
+	if (!desc) {
+		rcu_read_unlock();
+		return NULL;
+	}
+
+	zswap_entry = desc->zswap_entry;
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+
+	return zswap_entry;
+}
+
+/**
+ * zswap_entry_erase - erase a zswap entry for a swap entry
+ * @swpentry: the swap entry
+ *
+ * Erases the zswap entry from the swap descriptor for the given swap entry.
+ * The cluster is locked during the erase operation.
+ *
+ * Return: the zswap entry that was erased, NULL if none existed
+ */
+void *zswap_entry_erase(swp_entry_t swpentry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	void *old;
+
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, swpentry.val);
+	if (!desc) {
+		rcu_read_unlock();
+		return NULL;
+	}
+
+	old = desc->zswap_entry;
+	desc->zswap_entry = NULL;
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+
+	return old;
+}
+
+bool zswap_empty(swp_entry_t swpentry)
+{
+	return xa_empty(&vswap_cluster_map);
+}
+#endif /* CONFIG_ZSWAP */
+
 int vswap_init(void)
 {
 	int i;
diff --git a/mm/zswap.c b/mm/zswap.c
index f7313261673ff..72441131f094e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -223,37 +223,6 @@ static bool zswap_has_pool;
 * helpers and fwd declarations
 **********************************/
 
-static DEFINE_XARRAY(zswap_tree);
-
-#define zswap_tree_index(entry)	(entry.val)
-
-static inline void *zswap_entry_store(swp_entry_t swpentry,
-		struct zswap_entry *entry)
-{
-	pgoff_t offset = zswap_tree_index(swpentry);
-
-	return xa_store(&zswap_tree, offset, entry, GFP_KERNEL);
-}
-
-static inline void *zswap_entry_load(swp_entry_t swpentry)
-{
-	pgoff_t offset = zswap_tree_index(swpentry);
-
-	return xa_load(&zswap_tree, offset);
-}
-
-static inline void *zswap_entry_erase(swp_entry_t swpentry)
-{
-	pgoff_t offset = zswap_tree_index(swpentry);
-
-	return xa_erase(&zswap_tree, offset);
-}
-
-static inline bool zswap_empty(swp_entry_t swpentry)
-{
-	return xa_empty(&zswap_tree);
-}
-
 #define zswap_pool_debug(msg, p)			\
 	pr_debug("%s pool %s\n", msg, (p)->tfm_name)
 
@@ -1445,13 +1414,6 @@ static bool zswap_store_page(struct page *page,
 		goto compress_failed;
 
 	old = zswap_entry_store(page_swpentry, entry);
-	if (xa_is_err(old)) {
-		int err = xa_err(old);
-
-		WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
-		zswap_reject_alloc_fail++;
-		goto store_failed;
-	}
 
 	/*
 	 * We may have had an existing entry that became stale when
@@ -1498,8 +1460,6 @@ static bool zswap_store_page(struct page *page,
 
 	return true;
 
-store_failed:
-	zs_free(pool->zs_pool, entry->handle);
 compress_failed:
 	zswap_entry_cache_free(entry);
 	return false;
-- 
2.52.0


