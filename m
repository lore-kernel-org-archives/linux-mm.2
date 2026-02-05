Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61FD8E91299
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C22E46B00C1; Thu,  5 Feb 2026 04:04:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA3A16B00C3; Thu,  5 Feb 2026 04:04:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8EED6B00C4; Thu,  5 Feb 2026 04:04:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9495B6B00C1
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:04:47 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5FA8758A26
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:04:47 +0000 (UTC)
X-FDA: 84409817814.29.301B9B8
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf25.hostedemail.com (Postfix) with ESMTP id 817B9A0008
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:04:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZVJF0Fwy;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jTfeFoiOWKanJVNpyQKSbr5xD3ssBhK8sjdVQRQOZRo=;
	b=plqouSL4hXc/DH3m7rhFSfi0MJr7cZmKO3GljZxfCX50HjSgeSFl7JiIkBXOO7D7wEtTJR
	W0EFkWuMcaR7fe1gb/hXRBH1F+NXR+rxPrhaMe3+eLjVc0rs8jQ8lq5CJiUB/RIEuRcvpF
	moKUWyUUJJobfHrLiCoqNNN3M4x0q8A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZVJF0Fwy;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282285; a=rsa-sha256;
	cv=none;
	b=yikB3G8onDWa0oHEm7ZxMDL6fQH6mGGdQcAa2WknJB9qwFVjOKclXyzkyX3B3oGMIccpqW
	Qjf62QSigObzOF1GiF8NVcO2Mw4FpeqNnUntdmNjUjYeGYa1ECW5Wx61Tv5M8VwMsh4Kzd
	Z4LbnTuhN16ePsaOJPuWW4wWOoyCETA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jTfeFoiOWKanJVNpyQKSbr5xD3ssBhK8sjdVQRQOZRo=;
	b=ZVJF0Fwymc/rkiMwgln7PaopyjHGcLcIa3ikpBzHDWpDXjVQJd1Gh4viisuR4QEcK9hvtV
	3mTO93182LqTEtFyqPr1EpwzANkNAgLeVYgy07SLs/KIlTxDWv7vqQhHq22KSSKZ8H3iqp
	/Xzf/ZN8TEld+bNYXlclJRyrdEiPZCA=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 25/31] mm: vmscan: prepare for reparenting traditional LRU folios
Date: Thu,  5 Feb 2026 17:01:44 +0800
Message-ID: <26efe2997261631c951d326bef6a20fe0796c43c.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 817B9A0008
X-Rspamd-Server: rspam07
X-Stat-Signature: 5sdoua8oq4ysry8u5q9jfcg3ea6p6kka
X-HE-Tag: 1770282285-611863
X-HE-Meta: U2FsdGVkX19tGwPGRTYpooKXlrsT4XwP79XTTLIMuGjNx8FlVulF7WhfJrmc+j63Jx80txacdGNPXotTy/buh87cMofJeH7ALqacn3Gl3Quj/E3e9yA7DcI72vYuSwvMAX81AfAqnsj6XCu5+lwHzfhNkN7c+8W6807cQz1jdgI5biLJNoN8/xg4ml+3YbxonI2wMUiA/+eEnO8LShfaLVmFW0qO1H4KWSgXPzUI+RmWYfHB2YmfmfjG/JnaxdKXRkGNFbgXawbfMbSN67Ypo9rLDdpafQO2ETM0LgS0myNfN/yVAqW3vbu3Eh3MBZ59hX+rBsjs7APSz/nPqvRS+CU1uIBYtYQIFAsrfDj3PWrnCbrhK5KlO5857f5L52FsJsEq1uKXLKaGNw08iAgWXHfMff0LeaqOqlqsCl+ifRHHWk3ipjCQeiG1MInFIKxUvO3XJY3Y7AAZCV+apYPVn8LKOSIxqU8s3ByZg0aNBE7pAF266bBwotww1ZWl9YgG6lbIq9Z3vqpke9NvW/yPsOiM+12r7rNBRwKrc/IBnTdx4gyw9Sy11i0jz+TSUijoq5p6yqb0e2a9dwsIkv2bic2XN98BvTyNSwYiXOENKmPVl3MVbNhB9QsYqoYKHCtI7MdgYbEd3vB5S2ZRjCV7f0KCBsma347NElS9q4STzvT6xAydW4rMdfXulwP1TG0keCwmzFKj5U/tM9GQr7U+r6f83wTOOL0DR4Q/xDok9e1tml7CxLST5qSbwoMfTNl6aweOje+EzpgruegDOlc0/2gUUCKbl13YZ26/eGElulxjmwO745ZYS+kw2dsKdu0Og6nqL6kFbiRlJGt4ga1WLABfc9SbUWa59WNJgmFeim55layiMKAz92eNYw0G0bnPYMVTjJdLrFXRIBVopg7AheyuGqtivOGkKcHTfLPMCaEK3Lclwh7UIa2LIwX4U75jO8PZue2+OhJI7gYogbn
 MH25Tgz9
 K7eKUH7an7rLxeHPmesY6IhDB99c0oMRsJ3Wbal0g5IIv70AidmzOYmf0u01SFhtOUDUXB3RuOHQrhAG0aRiv1zZJApJ9M+Hz0Oi0xkPU1NCURCkE8ZvK1k8czIr8tm+ZYVlmWdJd8GalcnepdIR2SSGuJUgFHyE30MM9+T377QhpWyqv+HPIBQyQValxUfzS4DdmhFSKAK6M3pV4VjQCJX4Y0ue8vxpRM2TsuaQuuU9e8dSxGFYUhMajm8QRum/ptVJgvpMyXtt2cVE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

To resolve the dying memcg issue, we need to reparent LRU folios of child
memcg to its parent memcg. For traditional LRU list, each lruvec of every
memcg comprises four LRU lists. Due to the symmetry of the LRU lists, it
is feasible to transfer the LRU lists from a memcg to its parent memcg
during the reparenting process.

This commit implements the specific function, which will be used during
the reparenting process.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
---
 include/linux/swap.h | 21 +++++++++++++++++++++
 mm/swap.c            | 37 +++++++++++++++++++++++++++++++++++++
 mm/vmscan.c          | 19 -------------------
 3 files changed, 58 insertions(+), 19 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 39ecd25217178..62e124ec6b75a 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -570,6 +570,8 @@ static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 
 	return READ_ONCE(memcg->swappiness);
 }
+
+void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent);
 #else
 static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
 {
@@ -634,5 +636,24 @@ static inline bool mem_cgroup_swap_full(struct folio *folio)
 }
 #endif
 
+/* for_each_managed_zone_pgdat - helper macro to iterate over all managed zones in a pgdat up to
+ * and including the specified highidx
+ * @zone: The current zone in the iterator
+ * @pgdat: The pgdat which node_zones are being iterated
+ * @idx: The index variable
+ * @highidx: The index of the highest zone to return
+ *
+ * This macro iterates through all managed zones up to and including the specified highidx.
+ * The zone iterator enters an invalid state after macro call and must be reinitialized
+ * before it can be used again.
+ */
+#define for_each_managed_zone_pgdat(zone, pgdat, idx, highidx)	\
+	for ((idx) = 0, (zone) = (pgdat)->node_zones;		\
+	    (idx) <= (highidx);					\
+	    (idx)++, (zone)++)					\
+		if (!managed_zone(zone))			\
+			continue;				\
+		else
+
 #endif /* __KERNEL__*/
 #endif /* _LINUX_SWAP_H */
diff --git a/mm/swap.c b/mm/swap.c
index d5bfe6a76ca45..25f39d4263fb5 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -1090,6 +1090,43 @@ void folio_batch_remove_exceptionals(struct folio_batch *fbatch)
 	fbatch->nr = j;
 }
 
+#ifdef CONFIG_MEMCG
+static void lruvec_reparent_lru(struct lruvec *child_lruvec,
+				struct lruvec *parent_lruvec,
+				enum lru_list lru, int nid)
+{
+	int zid;
+	struct zone *zone;
+
+	if (lru != LRU_UNEVICTABLE)
+		list_splice_tail_init(&child_lruvec->lists[lru], &parent_lruvec->lists[lru]);
+
+	for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
+		unsigned long size = mem_cgroup_get_zone_lru_size(child_lruvec, lru, zid);
+
+		mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
+	}
+}
+
+void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
+	int nid;
+
+	for_each_node(nid) {
+		enum lru_list lru;
+		struct lruvec *child_lruvec, *parent_lruvec;
+
+		child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+		parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
+		parent_lruvec->anon_cost += child_lruvec->anon_cost;
+		parent_lruvec->file_cost += child_lruvec->file_cost;
+
+		for_each_lru(lru)
+			lruvec_reparent_lru(child_lruvec, parent_lruvec, lru, nid);
+	}
+}
+#endif
+
 static const struct ctl_table swap_sysctl_table[] = {
 	{
 		.procname	= "page-cluster",
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f904231e33ec0..e2d9ef9a5dedc 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -269,25 +269,6 @@ static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
 }
 #endif
 
-/* for_each_managed_zone_pgdat - helper macro to iterate over all managed zones in a pgdat up to
- * and including the specified highidx
- * @zone: The current zone in the iterator
- * @pgdat: The pgdat which node_zones are being iterated
- * @idx: The index variable
- * @highidx: The index of the highest zone to return
- *
- * This macro iterates through all managed zones up to and including the specified highidx.
- * The zone iterator enters an invalid state after macro call and must be reinitialized
- * before it can be used again.
- */
-#define for_each_managed_zone_pgdat(zone, pgdat, idx, highidx)	\
-	for ((idx) = 0, (zone) = (pgdat)->node_zones;		\
-	    (idx) <= (highidx);					\
-	    (idx)++, (zone)++)					\
-		if (!managed_zone(zone))			\
-			continue;				\
-		else
-
 static void set_task_reclaim_state(struct task_struct *task,
 				   struct reclaim_state *rs)
 {
-- 
2.20.1


