Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 781F2D64087
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD3BA6B00BB; Wed, 17 Dec 2025 02:33:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9E5F6B00BD; Wed, 17 Dec 2025 02:33:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDEB36B00BE; Wed, 17 Dec 2025 02:33:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BB07D6B00BB
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:33:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E49214092B
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:33:55 +0000 (UTC)
X-FDA: 84228148830.23.3BF192E
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf03.hostedemail.com (Postfix) with ESMTP id 003AC20002
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:33:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fqyO8smi;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xOMfKFXTzfX2R2XpU+f1ml9Q+i3fk14KvQzSfKjMTSY=;
	b=c8/8AjDpY1nMPGQhQaHwZwSKW66q5Ziie2ymKNq2uCf8KxPlOYSYUs9JcUFIv0oHJHgh/9
	8l8wEXWkE1G94xqsnTOyppZ05pQwdPVMjE9SqW5T02lYVjeRoqqNVkRKpc9bMbuMwS9Twj
	MxjYOc38iOxs3Z7t3duPDpFzqjNW1To=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956834; a=rsa-sha256;
	cv=none;
	b=RUMivScVTyprFk5zSmK4f68I2aGsTMsR1QZbtjuTjNjPIE46hhn4Xoe1FukoR67AvDkCYM
	IoTDGEsup1i1nBnnC8O/VLsXnuUaDjbaL3cQ72xYaUU1Mc1V0/aF+RPYpmmtPM5SHV2idT
	OmJiF8I3VnpKQokbt5LFwuT+Tkap81o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fqyO8smi;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xOMfKFXTzfX2R2XpU+f1ml9Q+i3fk14KvQzSfKjMTSY=;
	b=fqyO8smiuddWbVlG0vZAYnu6k2elDEhHFJPXEaCWp6peGVZcY6pMReFkk9h4m3bVD6QPdn
	shz0rtopSn/vAxHqNv0DClGCEw4T5XSRRwgSQh5i2gVr6Kn3qlit2xtndhCGfKu2Siggu+
	Cy42Gx14dN+VV6cgtHLhEVoRabHM4vI=
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
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 24/28] mm: vmscan: prepare for reparenting traditional LRU folios
Date: Wed, 17 Dec 2025 15:27:48 +0800
Message-ID: <800faf905149ee1e1699d9fd319842550d343f43.1765956026.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 3npzts54f9dtt71rzxhj8ircfaucarjt
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 003AC20002
X-Rspam-User: 
X-HE-Tag: 1765956833-539382
X-HE-Meta: U2FsdGVkX18idUefNXJXQxSSx9exI5sxfHr0LiuA8svodxIE9NGfiMI6uWUnJKxoWSyVZ+70Uf6HzM7LdM/m77Sp4pBemv72tLJ+5De5DrKAJzsgI0O+QbGs3Z11vJFYgq01e/a49qlGvN+tvQoaVMB0Ex0Db9rqwZUOQqosdLTq+7Elu+H67VA9Krr8WcuIjahpp7rAKBB8vZ3oPpfdm/bamEsKETf0gyJ9+1pYrwD4Wyi+PM8V4lZ9W1qj64ZWFJy/p/231K23XqglwhHVrg9Pac0xXxHuRbhWf6m6OBvN9CnUTmrEBs9aCAyjI7kbtlYKPWgt9tk3jjH46+8D5gYse7dib+238oSqBURbRvjJwCR70WIuAC4PI1UCUkuIeKIR791oPvCu3EtG6oTUjec6oSGWlNAu7iXQFjHojd92o1JBd02QlKY0np64UYeN/fiOh/OWeKLgikLQOxE0opFEDIe0wc5iA7bwxUUsa4OFgSe2O4TkiCHp90NeNKd/DUWPIgk/LeCFG/aZrpzt6xBFJ2qCYMUrx6iCuQoyQGBtDvWkAqGN4ELc2YTLTpMRui2+yvBMDkzG2TrpY7aUdZZK1Ol+SQWP6jVpZCK+fS1yGYsPMV4+r++AVvlsvB2suVaLuxnYfpfw6LW9/lMF13OZzMQuupvlLh2YJlxKuKYLmHHIk3qbD6OH0AFtHWJ9s4JIMajpaPjic9Ey1vyBUi+N1eCWtS0p176myg8oRqDEpaGkYNBo5q7b3buChAD5VllxnAR2SVHZBXeGcHnpYAseBKcohB90H7dxVHWAApVSW59bIvopNwZBcwbHPuvzIlZeu+iVpnqzH/7jfxZkrD2wMK0gQ5LDrAntmqNw/dWYRsaQR7EEN3ugyZZ3JfC4pxyDgE0B1aKvHB8AA3u6SQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

To reslove the dying memcg issue, we need to reparent LRU folios of child
memcg to its parent memcg. For traditional LRU list, each lruvec of every
memcg comprises four LRU lists. Due to the symmetry of the LRU lists, it
is feasible to transfer the LRU lists from a memcg to its parent memcg
during the reparenting process.

This commit implements the specific function, which will be used during
the reparenting process.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 include/linux/mmzone.h |  4 ++++
 mm/vmscan.c            | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 75ef7c9f9307f..08132012aa8b8 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -366,6 +366,10 @@ enum lruvec_flags {
 	LRUVEC_NODE_CONGESTED,
 };
 
+#ifdef CONFIG_MEMCG
+void lru_reparent_memcg(struct mem_cgroup *src, struct mem_cgroup *dst);
+#endif /* CONFIG_MEMCG */
+
 #endif /* !__GENERATING_BOUNDS_H */
 
 /*
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 814498a2c1bd6..5fd0f97c3719c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2648,6 +2648,44 @@ static bool can_age_anon_pages(struct lruvec *lruvec,
 			  lruvec_memcg(lruvec));
 }
 
+#ifdef CONFIG_MEMCG
+static void lruvec_reparent_lru(struct lruvec *src, struct lruvec *dst,
+				enum lru_list lru)
+{
+	int zid;
+	struct mem_cgroup_per_node *mz_src, *mz_dst;
+
+	mz_src = container_of(src, struct mem_cgroup_per_node, lruvec);
+	mz_dst = container_of(dst, struct mem_cgroup_per_node, lruvec);
+
+	if (lru != LRU_UNEVICTABLE)
+		list_splice_tail_init(&src->lists[lru], &dst->lists[lru]);
+
+	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+		mz_dst->lru_zone_size[zid][lru] += mz_src->lru_zone_size[zid][lru];
+		mz_src->lru_zone_size[zid][lru] = 0;
+	}
+}
+
+void lru_reparent_memcg(struct mem_cgroup *src, struct mem_cgroup *dst)
+{
+	int nid;
+
+	for_each_node(nid) {
+		enum lru_list lru;
+		struct lruvec *src_lruvec, *dst_lruvec;
+
+		src_lruvec = mem_cgroup_lruvec(src, NODE_DATA(nid));
+		dst_lruvec = mem_cgroup_lruvec(dst, NODE_DATA(nid));
+		dst_lruvec->anon_cost += src_lruvec->anon_cost;
+		dst_lruvec->file_cost += src_lruvec->file_cost;
+
+		for_each_lru(lru)
+			lruvec_reparent_lru(src_lruvec, dst_lruvec, lru);
+	}
+}
+#endif
+
 #ifdef CONFIG_LRU_GEN
 
 #ifdef CONFIG_LRU_GEN_ENABLED
-- 
2.20.1


