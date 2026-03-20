Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3A091099B37
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F3456B015E; Fri, 20 Mar 2026 15:27:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CB356B0160; Fri, 20 Mar 2026 15:27:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9B86B0161; Fri, 20 Mar 2026 15:27:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 46AB26B015E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:27:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F26548AFAB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:27:55 +0000 (UTC)
X-FDA: 84567426510.22.7B3F7DA
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2A135180002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:27:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YY9bF0jc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774034874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KPp25151sWevMzEffEXxfQEZtCUw8Iu/6c7CfKgDuL4=;
	b=vKflBS/DVaLxyZuKoZ4gyIo0rp696nQUl7q1gLD3QBOnWoNuRqxFL43SK/jf8H2AdwLF2e
	wmXqNBd3vXTfXvnojqAAxip7mPAzWWSFZl8M6z0hkSYdwUpU8r7aBWqoliggkdULSvSx2J
	PvsvOc37kmaDo+crE80RfAkaNlIPuCI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YY9bF0jc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774034874; a=rsa-sha256;
	cv=none;
	b=MCpCl2wLhApdMzRuG9clCkfUP4GleeGcTTSzmyjvcrKK6gsrL0cwnCNQqS8EuOGGQikFki
	dwHNaIlxS9KgfDT9CCDdIWMWU1xGUZNwzWFAoTLElFupXYVEXmNyggGQnrR3Y4NvIYxnls
	YDr8wb19D1+un0+rl+dpAVoSaionlto=
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-41576c5c01cso1480125fac.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774034873; x=1774639673; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KPp25151sWevMzEffEXxfQEZtCUw8Iu/6c7CfKgDuL4=;
        b=YY9bF0jc3aFz8HC0mbJ3FztPgyg7JqWJ4BnsS3Fj+jUp+pQqJonlhQUTJ0QSN3DGCL
         WRSLFWBiZMX36+0V/SrgDKaC45RuG+gVmKNuoNxx+fCIcrZ3X+q/beRDFaBn9y+Pjxg7
         OCaJrZ6vrFPA4sw5f9UkVWStJBZj/BXePi940pECMphGZML32T+a5z2gUHsCNJuwaCtP
         uckODVWGKtsYkvkmAwO5H54nD/wKXy7kexxRxC3d1m7nR3jTof1RwFR5VFB1Q6n4+Hse
         E/TlsIir1S+//j71M4AXPquXv8jyNhdCZYsu8fmOBE6l8w+hlWLWCBnjgKrwe41nAV+E
         pfuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774034873; x=1774639673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KPp25151sWevMzEffEXxfQEZtCUw8Iu/6c7CfKgDuL4=;
        b=B8lYSy/FYigta8Tr0gH+9iAGPTJDK0GKS0v02ygBcqW2trXEcMIbJ6qbS7boUhf5Cd
         H4y7QpADNYc23rbAMU60NB/5WXk+qJ//ni46ush8bx1GmIaoh9ieo/Rcdnzk3Cv2w0qu
         lu4mcA2Eb+aWg4k3V45vVS29SEKq43nY9hRLx0Npda6S+2vEWMqiRvuaWWsc28SpmAvb
         2kCN8rxfe+G8rTkx1o8yU7LaXewJ1XZByI3dCTVLH+0ZIcb6LRii/AMqmzszsq753YCc
         wCwdl/uRfBWypr/xyIMFq4B1g8uVVna/Nz534ndAJqj78E3heyEg1IGWcauEHlOxAgXt
         nhjw==
X-Forwarded-Encrypted: i=1; AJvYcCV9IIjRXvzG2g5vorei2vv46qFIRP8PSAlnxBkMerh07Bvbd9XLUkQdwiDKfqCmwr0WvAKnDVNitg==@kvack.org
X-Gm-Message-State: AOJu0YxwVTpJL8eAJ7RkAKf2t3UerPqtxjOhOm9utTLdo/2feZkLuQwS
	11QXmMuiAwcY6jJkDXR5wpLqoP6dpQRAqg21lvuZL37LygV/HpB2nbFV
X-Gm-Gg: ATEYQzz5QiDB0UHdLNLTFrwPK8UxaEiz5UqDl4TD4jtSPwLKIeGbGHiN7Aupn8OaeO/
	32EDqll5SfS0WSMCwqtbZYvJvOdW3TWvIyJGzu4bV26NZBKYK4GeZ+daqZyczn1FRR9nc6WLO7n
	/yZD4yV6E27fngkLqZpNK1MJpVaicyQGq2GppUtzGR9+FTk8wG/k9a08i/sRCNFxk9BPqEhXIUx
	hsKZgWaOeFP9tJ3012zSx6OliWya+Hrfm/BvRt5LSA/lDBQnCh2GCOhTJAKFMIiiLK8Mu1Yf6G1
	55TXdl5TmsuwIGDoEkUgBMZEfop/xymKQyleOaPMxPpoyp8w36J40fUAI4nDWx3AK8XMLdmRmT0
	jPdLexw4fKw+HEd0fSSZy1r73T5WvEr4aUxjseA7DdmUOgtkeN2BglLOuW14Pcc1WaV4GLvryg5
	FirYDdpYWiqTJmRWsqNWLW46fjYToaoSBRKMP2LeKIpeXBUQ==
X-Received: by 2002:a05:6870:f150:b0:409:7a01:6e2f with SMTP id 586e51a60fabf-41c10ffd393mr2670572fac.11.1774034872998;
        Fri, 20 Mar 2026 12:27:52 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:56::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41c14d73a19sm2659524fac.11.2026.03.20.12.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 12:27:52 -0700 (PDT)
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
Subject: [PATCH v5 11/21] zswap: move zswap entry management to the virtual swap descriptor
Date: Fri, 20 Mar 2026 12:27:25 -0700
Message-ID: <20260320192735.748051-12-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260320192735.748051-1-nphamcs@gmail.com>
References: <20260320192735.748051-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2A135180002
X-Stat-Signature: pmnzfjj9rkpbai959yfejxhik6qcoxe3
X-Rspam-User: 
X-HE-Tag: 1774034874-367048
X-HE-Meta: U2FsdGVkX18RR60D0Qeop0KwsQ155daf8NmNQOWLMTEGZqEEcmGrhF0qGb2ZJNnjO3R/yGgK7ijF7Fk1F45dQVI+WldJvZItIPg7YRVryNS1TycWx/fhpS+10Im+3AnwIAre3x8wXtXPmbI1IXrlZJiJ0oTnncJThFWZazgqXh5p1NOjg7P1+zd3P9qe3yGTgJYsSI+O7LdnvCzvOvTIMj76UbQVxSaLHVOE1OwjEOliW70J+dDULN4yRV+KKwcKKynqUDB5CPQ/cHgyJGmKFTh1mDO/G8xyrq5mLe/r8Wv7LRH0//sC10yzXQBcnF+QIDApvjg2pjo63OUBJjX0XybmF764S+aqGpNwkzpyzcsPTMJE4V6MDurub0wphdsdYClQrTRAlhzPRjC6IcnlSenjPgguMLCfX//RSe1lo6JTZWcCBjiJDnHO/JpkHYmVvQKnAlBBAmzs1Iul74rCKe65tEkVOGlAB5COy0gOu1jiHxWwr4Md8bUIAA9lK+m/exLac1Nn9PChIiz7lyQfgDl8LfSF3SCrx7PeA65nGyxEPACGn4R7Q6WrowAXIpwR0gwPNWOnfTRQvcRrl685k8HNOWGPLuqpYH6M460NA+GnbbLZAltsfTBcdXcrlJccJquARxF1hI1mk/vxLl7V4PTx/sKG6YkWCGQjyFqNvVdmc0Q53ePMHfuhTcyRTJUSa1i6ydm9OTYaL/DAQrvfgFc6gpU6vSjU1qxRSpiXcnyAck+N1/tu4PahJSnAih3E7d/o6Br+j473/Xozt6Cfc2MFXCYQvYJNP3uUtJK9hW+vue5dp/ADnHA9E6eF9Q6X2WE/2G96QwT2IcWNmZznte03l5C3pbhak07yha0iDPTSsVKq2I6ZQWnLBNye+LqNpNmmo7J9ABxggdbwJ0KXc+34VgbJE3fo5MKKsMZgjw7lDEfGd1rktAb8pGQXwg8FuBX7067tiszUNcQ6ndv
 kqPjrXh8
 igR0obFKqOIuwCJvJQY8O5qngPX4iGaAWNuLo3GmQs38vlUDncuD6Vf1ZlLq2RKbTMBuzhz1ouajGbpgaoNiDvfagWy8xn4kmTwlU6XjkBKmFGq3qgZtqTodFcGEN6cA2VEX2rTT456nf1a9RgnHn8PuuKdNQpUvik2DAloMB3w8/KEEjl4ALM+bz6KpSqLPM5AUKLMEclh5BNoFru8UvI0Lz0UCxq1GDLVCtsj5U5J6FaWAvXBN8360f/gap5xDErB9lGCrfquu0Vguifzc92Zr8HHjkaNkF3xo18GPngtCzGEj3YwuKEEj7VbFN2EPeuWIciC/lX4v2efwxjzGctTYthQ8LCEQuel+KwZcoQ8w+MgIWGub9SIFurmqF9WlmOImhFHPe7aansp4ZKybeFCIvOkmAP4huHaJ+YnUEnhD83vwCbhXUJsll//yyH5EvLOMCeDtRaI9e6z399XeXyyJ87iw3vG5bCuo5viCQQ0u2+7RN/7s/pNl/qHbb6s74zUn0UyZQtzLGGhiy2mbkkrFSHJUkk3MQk7XH1hm2zMokedWcmp7zvb6HKsBkz8A7cWwa
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
index 3027294cd872b..9b2122647b850 100644
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
@@ -1008,6 +1012,102 @@ void __swap_cache_replace_folio(struct folio *old, struct folio *new)
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


