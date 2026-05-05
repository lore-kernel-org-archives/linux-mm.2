Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E6AFF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5856B00A4; Tue,  5 May 2026 11:39:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67D2D6B00A5; Tue,  5 May 2026 11:39:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56CDE6B00A6; Tue,  5 May 2026 11:39:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3DB836B00A4
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:39:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7155C1E84
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:16 +0000 (UTC)
X-FDA: 84733775112.24.8997793
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id 03BD040002
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kRt73bs5;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777995555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iUDpmLgZqt3X5ZiWGGoaa0MqcSYAh7xQIoGoSWJ/lxg=;
	b=v0wwdTYYQnQRGwOMWN+SIm2v/X3naRdGarSEYNzOhgBfGPRJXBuV6vkdN2WuZv8TqbWaV8
	U36kUTcQtvBTHXOaq2LyFzzCsu+2sc+GrRroQToSg3IfKbGCrlcHW6gfVD1g37trUtR2aA
	25iVMG1REfZq/ZjsaSchB7+QubbqruY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kRt73bs5;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777995555; a=rsa-sha256;
	cv=none;
	b=2EWteJO5J1GLVujrOohxbBFb2nkcdcpW7WfdXExw4rj/DcN2IBivtB0W0NibHVm2+1b8Oc
	k3yAad2W6282eXzwis3pAs2xLtDxbA/eg/78XZWcGxV99gEKMcKomh6bcG5k3BoADicl5N
	Je6d4fcvv+JxEz4UzOoRiIaCXL3gZEs=
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7dca4debedaso4905283a34.2
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777995554; x=1778600354; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iUDpmLgZqt3X5ZiWGGoaa0MqcSYAh7xQIoGoSWJ/lxg=;
        b=kRt73bs5MizWQ9KljKTMBsh6AGDDK6oV2xTLqCaLwDii9UTiQ6igTjNxrWUXIbABsq
         29A9PXD12ihN2kVAMBB/OJ9WcOz2yuBERSP8xsX86f9aV2AVYp76scUJt5EVsxTICNrd
         Hq1UBtGhPoD/50mx4eDP948hMdEv+2xS1XCEjCskm6H27yWkdqNGyQ5o0jR2KkqM2vpT
         OQq2NS9Xm8EeFpthiFgV1ju58gT2caALQtpoX96jBl/BmMhteoq41kg/DBdTxdAvmcFr
         wDqCXDifz9uhI54BgBh6pYACW8QhyqqxgR7DttHZgkjVO/ZRyt9yGNJyaTYubOoMHBYF
         dQSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995554; x=1778600354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iUDpmLgZqt3X5ZiWGGoaa0MqcSYAh7xQIoGoSWJ/lxg=;
        b=Rxvll/TxiYA1iVZfOremnLgy8Jeuvjh7uvGZAPrYFm2VfPYA3w/kfSUjCwqMjFwHnH
         NPZsxi6kYJ5NiUXfQF+U7zGWs7DAwjxsuFueKj3cnR/j9fCt+YLkNbm1D+M4COWYu8tO
         rPxmjuJ+DDUSKJeD5IPsOD/dlb4AWxcKyMJhehrDHP1NRQyPFs1m7ByxXT1gSGyEtKgJ
         69zevn65hN/C50B7JnSPzPi/jPjUjm/675mKh5MERWPRiZX8WdnPQVmYI5UwrMD1jm+2
         +fA2MasRjrugk6uT30iNEWFeFfzIbVv3t1/TsULA7HkkDYXnOOLjvnKdbD3X/4uaWDT5
         s/VQ==
X-Forwarded-Encrypted: i=1; AFNElJ9ULcpM4tJiK7xPMZvUknLVMw6J7EudIT99AEb7bB0URcECBYRqAtQse+bxtuWDUxX4HUSGABPF5A==@kvack.org
X-Gm-Message-State: AOJu0YygHLmLUhV7AA4+6Ojth3QuNTIVJOQDD54bZtApBNOV09/Y8wrl
	/4NHCHwGEkRgRyQ3X7DVG/H+fU47v+b0fYprv5UW8N3ayRNnYKJtg5Ss
X-Gm-Gg: AeBDieuQTrkf11yOr0QniXwtfJRELA6dCSoQgc9K9LSOd7krzVEm57u3xuxFb1h6qYx
	6JOhSSN+eH3pQcgCa+UkUo9zj7lKEVcCLD+GUJfs8qTahzuEgFwk88J3nyL194Ce3MWokeA0op2
	IdpIHBs0R1XEsFZUo/EDMN/8cmKeO1JfFI1MBWmiDyG6Err05UqfJDiixJfFH8XP/BDLkbXC1zd
	XPF1Wp3pzQ1koORugX4/tDBIU1bpi3k7oJUyacQrM1AAZwfsNmgp87aosHfdC5BVsfQ2w92Ovmt
	3GrVTLT28LqmWICJJotT/0rfDVne5POpbioijfJxqE5TzdLh+ojhNqs7qFRIN395edB/SENf7T8
	DV4+AwtDIl8KJVoG9sOeq0CUXLVYFwn6ctXTtz3luc1Ny2pkVNFq2q3of6JFgaHoTyhczO4aOwS
	exmX/xr6uW2DLbX28eSAe89XMmqdFKWPupdodS7NwDknyiSoSzXXUVWqEY
X-Received: by 2002:a05:6830:83b7:b0:7dd:e032:3cdb with SMTP id 46e09a7af769-7dee1431d6fmr8694065a34.18.1777995553888;
        Tue, 05 May 2026 08:39:13 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:45::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7decae2be8dsm10220161a34.25.2026.05.05.08.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 08:39:13 -0700 (PDT)
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
	riel@surriel.com,
	haowenchao22@gmail.com
Subject: [PATCH v6 08/22] zswap: prepare zswap for swap virtualization
Date: Tue,  5 May 2026 08:38:37 -0700
Message-ID: <20260505153854.1612033-9-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260505153854.1612033-1-nphamcs@gmail.com>
References: <20260505153854.1612033-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4fpc8cpjgah9fgwii3h75tzk81opzf1y
X-Rspamd-Queue-Id: 03BD040002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777995554-15357
X-HE-Meta: U2FsdGVkX1+XXjsRfB+S3+CN6eLkTpL8naNPXvOzEl/7yQxKo9Kicv0AGlFjWVDIGTLIoDDg24Q3+39979+AUzfBuqAqjMgqv/f5eUtFoAVBAZhbATqzP5PKHxZOqSjXre9zab1h0C06TNeouTpMbaYweybo7OUwq2Md9rf9zPIrlsPU2B9NGA78pa3a8aoe3WubOkoyziYlssAQGkvE3J1riLQ6oZ44AiziMf2D+TxDuznfg2jq1RroI0AJ7PizzdZruRAeYL2Zy3QGYIen7g+EnZx6F8W2F7TFpaoPXsvEgrlA1r9pmlIqSn5RNJ8M2vg6yYUAqhvfcrm49dYQXwY7iyuceRLAbv4tvFCNNGQGFOGi12d8xBtl82/1QGUAoa5PQ/P9TiMyn7I0g0JPvFXAvBpTLMo2jDm4blFlFA6QgtGVZDKoZZXoJ1j1qSJwiCqMJzehcWAiB9o8b3uf5+7jCaxVE3k6uX5gQHSixcxUzQPcrRNX/uxVfPJzIpdKULkfc05LpQXFk3nfuAghCW4DJwcqUdIAQJSRnpeoOH5UhLasLG6MpAZQ3s2q7Vw6m/+yfz9Be+9ijHlhZsl/vksHHDMydLXENA1cyh+Ww/hHyV8TV3M+xo9ADp4tkxUeF7Bnnp0HbVGDBEaekcFBZvFPX7XwXX1hARwcqp2rqJVpg9Yq0qx7LBiqqw4XcxAIHivM/Phrwp8oP2hLxM10tLq1Iqd6m5s2dfqcpUKGRvShc6MdC2+Empg91ZdftcgRtMgb0uJUkldQ8xZkKEYcTB7GPNQeVNkoO3GULfZBrZPVg6dhytUA+f0KldAAriWpcI6AwWdQBArMHg8QEeqdWYRyGCWkx/7iqKzoHLAPhDjde47N3oBguqLD26yAruEFkRCw1KRx+2yh1eKtGLaUf4f53XWgLtZd/aw+SkCLAOIIk+CvIU3mi95NEwgbawukZoB3N80ICmWHx9fIih8
 h3rXvfAE
 MTFkUS/FT94pslzx39OhYBeoN4CqGCbgpBR0A3O/FCpJPC+J27Acp+rmXIqbnvINhHoJZLsQen1VutPQv8QQzABJYUwUDp4RpWZM4Dqt8kxEeOEpOUxB4tZzCJmYpV24NOoMKXKFe2WW7F6mAM7/5s+0jwIn7/7oKeg6jnC//1E/TMx8GjPFCa4IB1qHd2pGBKOrjF/40Fmk6SfbCYVeS8EUMUCsBJKZr0bwdz+1C/pkrVz1SuuvpCpQjXgDmPLBpRPMkWBUkBE1cCGDq4CJdN2c855OU92p5Yo1qk6PHoEN8/jUHh+9RicdRAt051mBs1l/rxweV4PEcn8UT/ZqxhK+VxSDcR5Lk/Pa1QDVdLJcKkAX2EhSQNtWNybzmFJ4yhIk/O+R7wcuG2hDCHtrAilrN8bX5FebLr0DKUIDJWneG+hrSiCxKfTJHOt0a3mkj8WBZdeb4Xmw+rK7kNvmTHEnO+QB9gP18EnFzjeFuUZS8vh/ZEkWX3Fe6S2k9eBerUvcAOf3C13Oo1rVmt5yhrKBmnRm6hSyqq/9jbpliSQXqeXenVcoZ4SGDG9tAQgdZb0V3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The zswap tree code, specifically the range partition logic, can no
longer easily be reused for the new virtual swap space design. Use a
simple unified zswap tree in the new implementation for now.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/zswap.h |  7 -----
 mm/swapfile.c         |  9 +-----
 mm/zswap.c            | 69 +++++++------------------------------------
 3 files changed, 11 insertions(+), 74 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e..1a04caf283dc 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -28,8 +28,6 @@ unsigned long zswap_total_pages(void);
 bool zswap_store(struct folio *folio);
 int zswap_load(struct folio *folio);
 void zswap_invalidate(swp_entry_t swp);
-int zswap_swapon(int type, unsigned long nr_pages);
-void zswap_swapoff(int type);
 void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg);
 void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
@@ -50,11 +48,6 @@ static inline int zswap_load(struct folio *folio)
 }
 
 static inline void zswap_invalidate(swp_entry_t swp) {}
-static inline int zswap_swapon(int type, unsigned long nr_pages)
-{
-	return 0;
-}
-static inline void zswap_swapoff(int type) {}
 static inline void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg) {}
 static inline void zswap_lruvec_state_init(struct lruvec *lruvec) {}
 static inline void zswap_folio_swapin(struct folio *folio) {}
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6b155471941c..0372062743ef 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2972,7 +2972,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 	arch_swap_invalidate_area(p->type);
-	zswap_swapoff(p->type);
 	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
@@ -3615,10 +3614,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		}
 	}
 
-	error = zswap_swapon(si->type, maxpages);
-	if (error)
-		goto bad_swap_unlock_inode;
-
 	/*
 	 * Flush any pending IO and dirty mappings before we start using this
 	 * swap device.
@@ -3627,7 +3622,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	error = inode_drain_writes(inode);
 	if (error) {
 		inode->i_flags &= ~S_SWAPFILE;
-		goto free_swap_zswap;
+		goto bad_swap_unlock_inode;
 	}
 
 	mutex_lock(&swapon_mutex);
@@ -3650,8 +3645,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	error = 0;
 	goto out;
-free_swap_zswap:
-	zswap_swapoff(si->type);
 bad_swap_unlock_inode:
 	inode_unlock(inode);
 bad_swap:
diff --git a/mm/zswap.c b/mm/zswap.c
index a5a3f068bd1a..f7313261673f 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -197,8 +197,6 @@ struct zswap_entry {
 	struct list_head lru;
 };
 
-static struct xarray *zswap_trees[MAX_SWAPFILES];
-static unsigned int nr_zswap_trees[MAX_SWAPFILES];
 
 /* RCU-protected iteration */
 static LIST_HEAD(zswap_pools);
@@ -225,45 +223,35 @@ static bool zswap_has_pool;
 * helpers and fwd declarations
 **********************************/
 
-/* One swap address space for each 64M swap space */
-#define ZSWAP_ADDRESS_SPACE_SHIFT 14
-#define ZSWAP_ADDRESS_SPACE_PAGES (1 << ZSWAP_ADDRESS_SPACE_SHIFT)
-static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
-{
-	return &zswap_trees[swp_type(swp)][swp_offset(swp)
-		>> ZSWAP_ADDRESS_SPACE_SHIFT];
-}
+static DEFINE_XARRAY(zswap_tree);
+
+#define zswap_tree_index(entry)	(entry.val)
 
 static inline void *zswap_entry_store(swp_entry_t swpentry,
 		struct zswap_entry *entry)
 {
-	struct xarray *tree = swap_zswap_tree(swpentry);
-	pgoff_t offset = swp_offset(swpentry);
+	pgoff_t offset = zswap_tree_index(swpentry);
 
-	return xa_store(tree, offset, entry, GFP_KERNEL);
+	return xa_store(&zswap_tree, offset, entry, GFP_KERNEL);
 }
 
 static inline void *zswap_entry_load(swp_entry_t swpentry)
 {
-	struct xarray *tree = swap_zswap_tree(swpentry);
-	pgoff_t offset = swp_offset(swpentry);
+	pgoff_t offset = zswap_tree_index(swpentry);
 
-	return xa_load(tree, offset);
+	return xa_load(&zswap_tree, offset);
 }
 
 static inline void *zswap_entry_erase(swp_entry_t swpentry)
 {
-	struct xarray *tree = swap_zswap_tree(swpentry);
-	pgoff_t offset = swp_offset(swpentry);
+	pgoff_t offset = zswap_tree_index(swpentry);
 
-	return xa_erase(tree, offset);
+	return xa_erase(&zswap_tree, offset);
 }
 
 static inline bool zswap_empty(swp_entry_t swpentry)
 {
-	struct xarray *tree = swap_zswap_tree(swpentry);
-
-	return xa_empty(tree);
+	return xa_empty(&zswap_tree);
 }
 
 #define zswap_pool_debug(msg, p)			\
@@ -1691,43 +1679,6 @@ void zswap_invalidate(swp_entry_t swp)
 		zswap_entry_free(entry);
 }
 
-int zswap_swapon(int type, unsigned long nr_pages)
-{
-	struct xarray *trees, *tree;
-	unsigned int nr, i;
-
-	nr = DIV_ROUND_UP(nr_pages, ZSWAP_ADDRESS_SPACE_PAGES);
-	trees = kvcalloc(nr, sizeof(*tree), GFP_KERNEL);
-	if (!trees) {
-		pr_err("alloc failed, zswap disabled for swap type %d\n", type);
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < nr; i++)
-		xa_init(trees + i);
-
-	nr_zswap_trees[type] = nr;
-	zswap_trees[type] = trees;
-	return 0;
-}
-
-void zswap_swapoff(int type)
-{
-	struct xarray *trees = zswap_trees[type];
-	unsigned int i;
-
-	if (!trees)
-		return;
-
-	/* try_to_unuse() invalidated all the entries already */
-	for (i = 0; i < nr_zswap_trees[type]; i++)
-		WARN_ON_ONCE(!xa_empty(trees + i));
-
-	kvfree(trees);
-	nr_zswap_trees[type] = 0;
-	zswap_trees[type] = NULL;
-}
-
 /*********************************
 * debugfs functions
 **********************************/
-- 
2.52.0


