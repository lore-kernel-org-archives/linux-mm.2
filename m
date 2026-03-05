Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52DEDF30951
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFC8E6B00BF; Thu,  5 Mar 2026 06:58:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6D76B00C0; Thu,  5 Mar 2026 06:58:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC6D46B00C1; Thu,  5 Mar 2026 06:58:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A5CB6B00BF
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:58:38 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6AEEDC2A1D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:58:38 +0000 (UTC)
X-FDA: 84511862316.02.2E5B874
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id A8A90A000C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:58:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h3sQKY7Z;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=usUS7HG6u84XSS4hIIZlOhBunMjn2SlwVU6f8o31p/g=;
	b=KIosDO9FDShhjswNEDiWY16oxyNQeHOgmKq2H6sp4A7Y61KFLutCKAPffkHSU8nLuRWOW4
	b2DJf86NRGO0CPRn0Q7FSrtEoOlnamGX+6RMLMw1PAGtXjUIOQ5ZXIX63IKE+AhJbpKTHc
	VvEwDoDqpFyVWqC3U7/Pw3pAMhgyUto=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h3sQKY7Z;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711916; a=rsa-sha256;
	cv=none;
	b=NfML6dwDhOQLzX+Hgvg6KX8QCw7qiQZtwiqQasqejYUo93NpTeY2vgdZLJSs1/1BZFLqay
	sLKP2RNSPDiHpj9w25BTKnsc3vPulhxxxXe2/D0wDnnwmptMno3rZd9yS3Rboomf1A2ut7
	BJyLqy/HtJU4IAmSOKLILlfFY3znNEY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=usUS7HG6u84XSS4hIIZlOhBunMjn2SlwVU6f8o31p/g=;
	b=h3sQKY7ZYBCeKu/SV7widnxjYzrIiMVtKJE3hixVtQhv9zpuf5kpJtq2SQX6egs833WiZJ
	6270SI5L7rxFuGG+Q7w27N0RI8tLPlrU9+fpfgFRmF3CxaQcpCJnaAsBvOi/Nk/fhET4zH
	gOHt1l7Qs7IVBzi6unUAdGIE8RAG9eI=
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
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v6 25/33] mm: vmscan: prepare for reparenting traditional LRU folios
Date: Thu,  5 Mar 2026 19:52:43 +0800
Message-ID: <a92d217a9fc82bd0c401210204a095caaf615b1c.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A8A90A000C
X-Stat-Signature: jfwb1zuxammbohz4ihx4uabqa3g3trno
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772711916-489774
X-HE-Meta: U2FsdGVkX1/PKsHumFydwwcDng55TgEc6FjkGAFB8HrhuLptjlnZA9D8GGovWev1O07KZ0xIU4w/erjqewQ8Cfn+AkQdD2WcSiP5C/IgPC+cNrant53Wy3kYuilWt6/NC50RbwlZbHzk9DLidOsuCOkzK+vDkgI52TYb3+TzricZUI3NHR6KTVFnUjbUQ5BzPE0BLeyF8qSSD6y+8FpfDmUah21/L7Qjeck+ILHUTt9Jf8Bs6rrMfDqgw2mq+BKbIEAg099DzedFVhOVzXPMU15dmPm18vo9vAOtTVP4SZbTYCLW2ChCk27iMa3IocmiImJAPDIy3JguUzUWSgAhQCJZ2LDd1Fk/bD7Zpy5bQHNmVIuuqeau4/Wvk4fZDu8g1mIo8QBGzs0EeIZSakvU0IqKPHjalfr+iVTfuZLueLyul04l2RBHhaNglSm9786uwQskiFOyf3YpLv5XPiG4Vvypniwdu2IQTWiaWGhvefHUt5yXfxK7Mp2OMk11tIIxPOZEZp/MeJowfLqgMPN0dfeZ7Ny15eQudhPPiDs/QoCA7zLbX1ZuB1AmNKQGiwVkREix/XCYCYLWcLz5Y7fGqmmj+nwqlMtS57KSIiS7ouISGupYMnK4WBimyDmZozhl9/mr8NkK0P6eBEAhGqnDb/o6XkkaQGZ17Ynfq+/8zzjbpxt7G9JOd9eby+br3ENRDSSsrzofI1LKbNkhK/W5te1Tya88Ej1pGTBZ4yP/BwZ2fXarDcXd3Hg5Bs5nm8wpAJOOAfDaHt1760tTmkZuWzzwjNvTOgPb9FL9UfslQLky/YGRvyo4uIOXCyPhcxW2GWwy3eoVO6UlZTJs/B2gxuZt1miLmvF09n1Mwg/Q66yDTbFVv2Hb7+v1yKaIKbvFakTdyxeqvmT3e9NsRswxuE+44rzJrSpFpRlzeUJy248LLCBulzGPHgufKSuE7IZ+NrEvrWFVMFeJukR+Kht
 2FRaFDEj
 ZR+vg3d0Q/yOErTwEGmUKUKS8sPirVk7HGAQ0Sa9T3YORyqkR43LXFHvhsFM/Bkagi8tbrod44bgoNqilOSPMQRqx24MZdVRINWsEdMhNBfAZdtg5/NIsEGuNSk0L2sFvm4qv840F8zBgkmsTV1d8f8byb7uaP8oIOXpGQMA5D+8a+HsHUJeOZ8Xe/iZq4xaDrESLBbUzaO/N/1KZ/RWicX5lAEpk+NTpClkg2mwzUkk3qv8QiTyCDHaMtc9n/GysK4ubgdx9x1l4nLQ=
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
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/swap.h | 21 +++++++++++++++++++++
 mm/swap.c            | 33 +++++++++++++++++++++++++++++++++
 mm/vmscan.c          | 19 -------------------
 3 files changed, 54 insertions(+), 19 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 00ce4c5e6e714..64af9462ae8af 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -548,6 +548,8 @@ static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 
 	return READ_ONCE(memcg->swappiness);
 }
+
+void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
 #else
 static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
 {
@@ -612,5 +614,24 @@ static inline bool mem_cgroup_swap_full(struct folio *folio)
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
index d5bfe6a76ca45..e255be6a0f34f 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -1090,6 +1090,39 @@ void folio_batch_remove_exceptionals(struct folio_batch *fbatch)
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
+void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid)
+{
+	enum lru_list lru;
+	struct lruvec *child_lruvec, *parent_lruvec;
+
+	child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+	parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
+	parent_lruvec->anon_cost += child_lruvec->anon_cost;
+	parent_lruvec->file_cost += child_lruvec->file_cost;
+
+	for_each_lru(lru)
+		lruvec_reparent_lru(child_lruvec, parent_lruvec, lru, nid);
+}
+#endif
+
 static const struct ctl_table swap_sysctl_table[] = {
 	{
 		.procname	= "page-cluster",
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 08ed278115f70..606b4ecf77ef3 100644
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


