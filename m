Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AA8CEFD202
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EFDD6B00C0; Wed, 25 Feb 2026 02:55:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DAB16B00C2; Wed, 25 Feb 2026 02:55:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F1146B00C3; Wed, 25 Feb 2026 02:55:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 59D3C6B00C0
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:55:41 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 24EE21A03D4
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:55:41 +0000 (UTC)
X-FDA: 84482219682.26.BA55C91
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6476D120007
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:55:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IpubIlYh;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=usUS7HG6u84XSS4hIIZlOhBunMjn2SlwVU6f8o31p/g=;
	b=qvI5ZUHeXb4JEsbP2H4rveKpXDKedgdHM9uF96yuA+rTw8ADbNVc5gjZ2SyJ3cmlkhOPES
	EKf9/NbJUq2afKnbYvWVfnZrxs+CR3qmjLQyKSwSiiJ3u/DZOhxRTY7aKwTOVSI91lZpMU
	BKKGc9AN7NZXNr+7+OMO4VR9nbpyeV4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772006139; a=rsa-sha256;
	cv=none;
	b=z4Hl2xmb6MQWVd2oGaTEKMsRcJjM2tLjW1GX2JNTBmhFTu0uHgh1lqb36jyJmlyiGfwOB9
	bpYnt747JEfMa24C2bqZPVA65waSWh50h0inmnuXEVK9PrQwdMfFuQ0AjbNSiLcHA1qXv8
	RyFRuqG7byRBxvy4j2wihPKTAPbVYEU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IpubIlYh;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772006137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=usUS7HG6u84XSS4hIIZlOhBunMjn2SlwVU6f8o31p/g=;
	b=IpubIlYhjigKcK3fUF0wslp0L/Lefo6XL1eQEayR9vQxguxQSfZDmAH6pTJ/s66nKx2WGq
	q1mT6ANBMTp+DnET415ocamLaSfbShRy591hcqZqVXLbIatfxMTOcLJzUFef6YxlmcCCMr
	U3w30uTCFxiD4iRJSEooZU5S0eM3LUE=
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
Subject: [PATCH v5 25/32] mm: vmscan: prepare for reparenting traditional LRU folios
Date: Wed, 25 Feb 2026 15:53:08 +0800
Message-ID: <a92d217a9fc82bd0c401210204a095caaf615b1c.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Stat-Signature: y4g937wt96qx1xxgts57a3qbmft9rcz3
X-Rspamd-Queue-Id: 6476D120007
X-Rspam-User: 
X-HE-Tag: 1772006139-570002
X-HE-Meta: U2FsdGVkX1+etHWYA9bDmtXVgkf+WwCV+g1U6naqpb3lm83krcMY+dfSwcb26zG4kc5dFlt62Ysa+I/5pQIFVRU7KMYXwWcUoXxsYWvsnyIT3+/eeu+03qoq+v/HUt2zlPSx25/07pe7m3D0fzd1e3aAqRhPiy7egBuaHEsnphSGOJGT6q5i2kGYhzllxl782ehKez6k4qlajeIdKK7JO1KPmiOhcDJ/onusBHrWSC+py8h77kx7aC5jhnOKOxeqQ8dpMW7MG1VFFIABDgva7oWiPV1A0SYXEaE2T9tCk5DFQzRqFdyPgYFzBxQkcauYQ9DhNyEmHw8OI7GsSMNWz1F42Kp2GcBpp6usFGR2zzmtCceuVAVNlGBpz8wJB4IJRKjlT0DXBOUsYmIxA251OADcVQfbamxJsyn2eyjaCbrak+C/3dfDfOnxMCnUlEmrh2hbN5NFvDJ/5IAKLq0U7MkfTaAYT3KV6nrvWwzff7m8lRzponwQ9pMTLtWfsVQLBqnEjzKLCZ/3gyV+cXPZHtCayVPH+a70DmolvLKrs3zJ9HXBaCxz1UhsmVajrKzxnu73yglNk9RjxyCWlkanuHptFyHRk6Amz0wWwn5Ie4jqCGjN+gbyDFm6lW5o0BZZmp1x5WDN4dB/l1axP6LrSBC/+MJAuHlV0ISxUhw75QpDJ+paqIeOlvwDyPu+9zrE3MaSgnVX7OFVb1v/Eoa+WbebAjA3y1yB19mvFfPCNFp71i9lUQGpDewYOAPGqKXEFinTUGaKoQAfIHeszQcFSu2ymOOLCX7DIuq9G9OAXZS0IJPMrFDMO8hNYSf5jnrj97Nx7MrA3vuRowyrIpzXIlY4kungenjOtRiy/CHT0azl9ZDulDvSAdfoMqhEHyXjJTje9m6t2aE8HK2DJxZkdXWpPfIC+oDpcZ0IReeAy2vmFmBD7ejrqMXHLeMwdB7/+x2axFA6u2lzl8ayWqi
 ME4419eR
 eqIL4MoHNyPXM4DN6kw3OCthLzT8LsCOxH5/zqXak0dI+iE2XH2YlVzfFXQOscZ8ZfVrODB8RPSKxga/szULmzs3Ky2wnbu6YcgUEYCJR/zNX2AcqAQfHpVXtVBFf3UEMvIUd5HBqIsEn2Ljp7eqFO9hcGyqVwtsTGG04ZcRy9Y7c+4PATdD9xQqQd89e4vpOtzKcR6/I8Z/ogDTjW8gG9Fle9aAAQPsb4oc6PlzIYcE4CB6wHQYzTJpmw93g/D7bKScdITY5mAU8AEw=
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


