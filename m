Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32874EF06FA
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 21:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A13616B009D; Sun,  8 Feb 2026 16:59:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BD226B009E; Sun,  8 Feb 2026 16:59:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 855B56B009F; Sun,  8 Feb 2026 16:59:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 76B0D6B009D
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 16:59:01 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 34CA2140681
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:59:01 +0000 (UTC)
X-FDA: 84422655282.19.E3E4A89
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6E6F2140003
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:58:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="L/BUyNP+";
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770587939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Br8/Kp0dBiDnoT9vYl1sItOdYWaxT3y8ap5a4tIpuAg=;
	b=d9IO1Eyr9mu6/NvSIQ3Z5OCDbuKokBypmIscCGrAvDW6/3MIECY+0NEadX7jtFAMmqb1Rg
	yLeVzMC9i/z33hI5zBkEzgtjh1cf1Q3jXoenxjroQgWHghSym8F/DmDZADrm9EVtj7WWUk
	M5RRNKOYcxb/afgxxBqk29Ls6sZO8iY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="L/BUyNP+";
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770587939; a=rsa-sha256;
	cv=none;
	b=OQwfC8gVcSyodk6Y/AMebFVYMXE+Y1RS1MYm/XGzoW2wofwGLDk7/Us5/fXkpYcmplYFXe
	tUbKY0ZpWjtkHXrcTdR7N5YygGKqvHcWTAM9PhGdTqp1ccmxJACJRWHoCHwJ8Shuo1faU4
	Y8l4FmxTT2l+6RwAho43fepz8hErZ3o=
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-45eabce608dso2633088b6e.2
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 13:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770587938; x=1771192738; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Br8/Kp0dBiDnoT9vYl1sItOdYWaxT3y8ap5a4tIpuAg=;
        b=L/BUyNP+qtLZmqg+zSbapKc46nN1iH1lGNn+FPW4ygJoQXso8d8fx+sUzWYHoV+8dm
         dg5nIC4XnMfzqYZWVK5yNk24txC43T9LziaU8naf0MTXBmcwt+X8mjLhfayVJvlF51nv
         3bk6saXBrVhr5kzByuThHuVwyoOvadcXESDFQV7hVGSIx0PKMnREljOiEi9Tef5XBXmx
         g1wP1m4A2ZTQYodA7olsL0mxWbF6+6Fd1Shyv0HOF9CQBgvWgjtWCbxdRLamjDP0tEZT
         KL28UyFoRdChiavVtCRnXy5dQN5BOWZlmu4fbiKzT7SJx7JEAXtCUmI2CmFWxFt3mo4G
         o5Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770587938; x=1771192738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Br8/Kp0dBiDnoT9vYl1sItOdYWaxT3y8ap5a4tIpuAg=;
        b=O86IfJbsh5M0/hjULTHnRtXuWEDWIFd2dFp1N6M2JCtwsqCR10ml6kPubJ+sit1PZE
         vPIj7PUCJ5Adv1UNpcsUCtS4RS7FPczFuNQATRz/S5gOSX2DPFFNe+cf8ETBYR2V5rqh
         6M3e1dpMBT4Wc8VU45QLbPUJ4mxlHhBXTJgAeQ9vDRawGqwKOIKZGfyn3JIjESGEZmud
         N9VSdXNqQngdqtJlC7E+Iolx6LIZK/ciZgiaNZAHRdIoiX4kMmJG8UTy7XoOHfhFWdRf
         YduoiQcMt7S0FcGDbG4+lN7t8BPvfmLaiyNGKJ0OnZ0MKXakJYwwdrFEMgF7Gh6f2kDZ
         fGWw==
X-Gm-Message-State: AOJu0Yy2MYy0pv717keoffS0YdTbclYKSAcp/S0pYe1oonN1nCUutfWx
	BkOznZPN2KUpd8Ob3Nc3SWkNoQVl2a8aQimWUSvHZzBWuSOSiBO+BpJ1Z4OcnNDz0uM1qQ==
X-Gm-Gg: AZuq6aLZs9tG7mtXANUeQmHal6TRp/6Y0GMKdCgSnALCNSYxTtfR9uQbXpw1zqY9DP1
	IkW8mdN/UjuwFTAw+F/oy0jsV6v52yjmcjgewuydLk2W7xYgZSvF8b1RuyJ13Sv1IksgYFZ2oLP
	n7yoQpGdh4MfIiBc3R3++YB+xrIgiUEfHjFVxwMBPjAh9nLfpXRAdVdtM3MdUJ3FseI5htjBFSv
	n49TiPpvwjF2KjBj5ErlZEPEru6/0qKRpWljz544yNeJTllx88HOYwBtI1S4lZjKa+RipKfxQZ0
	6ojuGjlgrLu9bp2GutPrRG9iF9ifUISRXe4WVD/OeLnGGY5X3OSeITlq8P8yZfX25Roig0G5fM+
	qHgInvHgPOo2u/8VqJGkR7XgCnsDSfuih3Tgw5Zs5cflChzbiHwJmQc+QT+PEPBQi6cp/AO1ABp
	g7Bdex1qfaXBjMx5yq4qPqNfvzliHS2iiw
X-Received: by 2002:a05:6808:6b8e:b0:450:b215:8f22 with SMTP id 5614622812f47-462fcb81536mr4957989b6e.55.1770587938562;
        Sun, 08 Feb 2026 13:58:58 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:9::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4646fb89fsm6346818a34.1.2026.02.08.13.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 13:58:58 -0800 (PST)
From: Nhat Pham <nphamcs@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	hughd@google.com,
	yosry.ahmed@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	len.brown@intel.com,
	chengming.zhou@linux.dev,
	kasong@tencent.com,
	chrisl@kernel.org,
	huang.ying.caritas@gmail.com,
	ryan.roberts@arm.com,
	shikemeng@huaweicloud.com,
	viro@zeniv.linux.org.uk,
	baohua@kernel.org,
	bhe@redhat.com,
	osalvador@suse.de,
	lorenzo.stoakes@oracle.com,
	christophe.leroy@csgroup.eu,
	pavel@kernel.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-pm@vger.kernel.org,
	peterx@redhat.com,
	riel@surriel.com,
	joshua.hahnjy@gmail.com,
	npache@redhat.com,
	gourry@gourry.net,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rafael@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	zhengqi.arch@bytedance.com
Subject: [PATCH v3 08/20] zswap: prepare zswap for swap virtualization
Date: Sun,  8 Feb 2026 13:58:21 -0800
Message-ID: <20260208215839.87595-9-nphamcs@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260208215839.87595-1-nphamcs@gmail.com>
References: <20260208215839.87595-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6E6F2140003
X-Stat-Signature: 116mz35zmogmgu6n451oep5ncyi8f6f7
X-Rspam-User: 
X-HE-Tag: 1770587939-365694
X-HE-Meta: U2FsdGVkX185mxBenLW6vLCaGn1M+B31VcFNK6bibiAdVqzsDFNuSPZ/oQLfEvYXXU1P5x54ikiEIf0see/BGEJqXiGyA3hY21xEJKnHoBstTFtmCBZr9wKFnrryOCepIyHWG9AZzLSfcp+PwylVJj2+6Eklq4jTf38/6MymUEzKwQ8NRW/2Fg1hvzJLSWzulPx7/LgtXPLle6b+JQohMjmdIQukg4il4JsieyjaOGcVcPmSW6EHYVnd5Yq4IbXT4n2nKHQI8WTTbzHaygh1XReCWKMi1WALj0VSis7F//sdEE0kMCHp/f73Ff5doTU1FjtFKlx3dkYXYOEp8K58zoWWKsao6zV3HUlHl/tZ65C8jpWpdUeIEeANXJyWxjf2aQwYOFXYgsugi5G4wv6HEjYkQCDElqBuFa20b/7Tr7psS2/w0JwUSy0ZcLqpflDIVkeVHTt96jj+6f1wGuaqhntDCAClxMw4NyHHxYCYRd+YNs6V7eB6vIt5LVdQHwfMhzmjblp+DWbkg79kec0G7vi0aghuXHaj67JF/hUAia4IBh2uNo0LQ6TQP/WsVDG53xgnnpGOc1mW92uMpRH4/ybXa6vwSttXraKrfHNBPh5HNo43n/GWuxC74C8VIrT85H3WUoY+Tz0RSuJ7oh4hLut0yI3jdtCvCshJ4I7c4ogHZlox7GeAcuNEyBQHkTUZKh5yhItjQF9jo4oVzrA7k3lyOTUDW/KYE5sGeyjPrc+A4tpBf7/Fw/qrdqYhGTvDJC4XzMef11POu0YkrJqbGvbGAABuvstPgbbLyhF7BjMZa0eQJOw7o8JtXJf/Tuzo0vHimEWuMlZBgLpPrTd8G8kjrYUO8F+qpJohQlKR8L3uVaIIfUQFaP2svCW6mOAIyW4MHsWuFujG0YJlziQMpDtEOcN4+hMi71iO8N0z7QdQrVs+zh9imh4+dVYypibCi9M59P1xsc6Ir6vNXx5
 reE+RW8j
 P36bT+KbkdPx8gIGkRnGfeKQAycPo1aAdpNLKHqQ/sOsHQhK4lDl5cHOladMeM3E5RYOw75kWjbcvy1TfAxiOMI+4DvZXyWaGX6X8H6zyp8XIhXBqjq3YX+wI5LwxHVLgsueBj+TRJg4hZbZoXyFqKvUmY4iw8LslvfX8gLwyJUo0ERhL0cgnXZllZZnB+ExGdcl0o6XcDnYo4dwMJ3JWVD/ltrS18qGoTgJPDRAhOR4gy33FyYovObCVmsYcfEeFxYrpG4PB8PU/gdMspKn4mTpFH5gsBX/HskW6kkTHWoPDzZAcT03F2+wt23bFqlHsi42DV52O9Hm4YhwEHVJGGehEK5RmUCQZLRaNqJA0Hs0GmJVo6tBVv6IyELUVTO5RvwKNhBur7g1v0C8P1GijN0InKl7kTe6HxhGVSKMkyfotJWBF43ca/nU5sV3SME1dwvg46/BcAZejlilyt3Hd54JczwEMN/y2qC6yefCcTFumpcFgiNiFny6GLHETrn/27iqyUAmnOJJE3WmvNI+mX3YKqLNe1rbN38LcoCry2oIHw8ek/usx3WIatqrT+RAX+bQO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 30c193a1207e1..1a04caf283dc8 100644
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
index 4b4126d4e2769..3f70df488c1da 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2970,7 +2970,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 	arch_swap_invalidate_area(p->type);
-	zswap_swapoff(p->type);
 	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
@@ -3613,10 +3612,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		}
 	}
 
-	error = zswap_swapon(si->type, maxpages);
-	if (error)
-		goto bad_swap_unlock_inode;
-
 	/*
 	 * Flush any pending IO and dirty mappings before we start using this
 	 * swap device.
@@ -3625,7 +3620,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	error = inode_drain_writes(inode);
 	if (error) {
 		inode->i_flags &= ~S_SWAPFILE;
-		goto free_swap_zswap;
+		goto bad_swap_unlock_inode;
 	}
 
 	mutex_lock(&swapon_mutex);
@@ -3648,8 +3643,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	error = 0;
 	goto out;
-free_swap_zswap:
-	zswap_swapoff(si->type);
 bad_swap_unlock_inode:
 	inode_unlock(inode);
 bad_swap:
diff --git a/mm/zswap.c b/mm/zswap.c
index a5a3f068bd1a6..f7313261673ff 100644
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
2.47.3


