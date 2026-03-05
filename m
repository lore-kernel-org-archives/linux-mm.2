Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0088FF30951
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AA4A6B00C9; Thu,  5 Mar 2026 06:59:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6545A6B00CB; Thu,  5 Mar 2026 06:59:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56DA76B00CC; Thu,  5 Mar 2026 06:59:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 463146B00C9
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:59:21 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0227C268D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:59:20 +0000 (UTC)
X-FDA: 84511864080.05.8783815
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4D1591C0014
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:59:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VuMZBFmy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkkDq9fYZNwUQylXgNIXOLA+3SHN3gdrMA7iDR/pB7s=;
	b=s6zwryjkAmtiLDYnOIDqKccaQw8/9f/zcWh4fhhQGbJPwchqSUpxyLIs/QS+Eu6SLetjL9
	W+y/CnHXNxcR4AcMwHwbodpQY0ts3QU9KR0k8NaqCIXGtMCyohmaH4vPwKbCVaXUzw5wzV
	JhOsSdRCuRwRUp2z0JKIsaewmwcsq98=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711959; a=rsa-sha256;
	cv=none;
	b=dEt2q5POx6qTVUeHeSwa2jDTUgIOh8R1ZA1CIaFaHZZlunxu9i0n0UpBuZ8gYucZ4DYOnx
	8dzdbdy/ioP3i2WoJJ3H7Jxf5sLLvLJDB7DTCpXb7KVO9dgnOLtb+fgaQsIFWWTT7bQGPu
	ahBHAIXvXx+uWS9RVijS2y8mcoodB0Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VuMZBFmy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OkkDq9fYZNwUQylXgNIXOLA+3SHN3gdrMA7iDR/pB7s=;
	b=VuMZBFmyBkVgZzDvr//F8qLgETBTT0LZkc1dSfT2HpZqxQ3K/SW32urwpUT+jwMKE+XfX9
	+nfIk/2lc/8qOweHnZicjhtTr6/x0V5nC6dQN2K42J2ijNJUuZft24ZaWSwbP02ecM7Frd
	PWkv4pGGCJvB9u4BwbqTROdLTPndqlQ=
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
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v6 29/33] mm: memcontrol: refactor mod_memcg_state() and mod_memcg_lruvec_state()
Date: Thu,  5 Mar 2026 19:52:47 +0800
Message-ID: <7f8bd3aacec2270b9453428fc8585cca9f10751e.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4D1591C0014
X-Stat-Signature: symjfain6rgcnzqqm95ebz15jk1ymasy
X-Rspam-User: 
X-HE-Tag: 1772711959-730124
X-HE-Meta: U2FsdGVkX1+P/euYwzkOfedwOvPx1mPjUQuMoVzfFg93lIv19mZ+kA7uCSkupPOS66283tevqWqXUu3A3KDmhlTIkonszT4zVd/mk52fYHyBxFvOShcT7SsEPYEyICeBf0xFdG757ahirwkywWGQPNb7yfguii8IdkJp2GQd0T1z75PBRsk7DPNH+vDPupsHINVu60u5e5zs5rht3GTG8KtMTwckiw0gjQIPI8gbvKiEZwaFyMfcT2ILIbV91ipXiMLYo6uj/l4fojJsvvsnPrNBnTxfkyySgwwvNuC/pOQ+0cq3B/K8r9/mLi98PNKMeNNowV+ND+hFBAHqcdCPP3u+W969UyMV6fGtuNwU6fHqREfNRQLe6SGxhPZf+7WrnWEVOGRuBZZaMSyNKEux4rn+3EdEE4JFzx5rCruTWOG0BZUxc3lZZYJdd/0b93KFHiiLfPa8Nlz/mrGZHAnlbsGpdZeST0f897SMdvl7xKVUh/G2YfOdGi0s5+C2gf98+iF7l4+jEKvE9uQGLPHtZWONSgsvudXvHh64rQ2T1E2W2hMX1GbA4kr/xkkIGgKmzadc3bRI/6BEuxBz1HMpIRR+p1to/roHmdMEoQOILjh23mZS1q53wDGQNkzxHzy8QIxV0QiPZ68lLdeYEZWVmEaYKJ3vgrWY96r/80fDlFrYdrHS5CEcjPGpOPHNZbRla5ng1njKr5ug7p6CdofqJTOz52ipR9JF91Ca4cCpvNFiFYROQV9GYK+JO1sIUzvpyiNZlxs+mwsmsZ+fVNHzRI24F/DZyBqlVFVGBbwMoc9xUNSnSQypJOF3ppfbWDmRwBd5/NvLZIAv07NgvJQHUpoTFYikxvOhlJw3/2VJK4IWNpT38/KchnrewZuo9Ync54inzO7cStQcA7RotQL8bRIstR3xLJJxlOTv9pIpH7kwLie9oNuRXXCJQ9q9X12NiiEwZKTvFvz67dx6VIs
 g9h/kWwv
 P2am96uzCbslivp3VTJ2J2OB29wZyYdrNJefTrkYy/dAOzEE9+aloE+Fi6rGg7I5a+hkuJU1eEw6YuDdXpgGt/7j46K69ccqfMtLIpDlzOWFa+6Su882rUJKt8B5bRt4677a+qg/rqAZ1Epwh8Iy3egntGjskgNPtwImPJHtqaI/VpZXpasqh/LACrWIm4f0sSAeNh+1lJB9L8DSdm4ql3eZn3A05G5EuuUjQTrPP6EyeSXBZu2UrZ3eiqDUIY8OFvDD3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Refactor the memcg_reparent_objcgs() to facilitate subsequent reparenting
non-hierarchical stats.

Co-developed-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/memcontrol.c | 50 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5929e397c3c31..23b70bd80ddc9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -718,21 +718,12 @@ static int memcg_state_val_in_pages(int idx, int val)
 		return max(val * unit / PAGE_SIZE, 1UL);
 }
 
-/**
- * mod_memcg_state - update cgroup memory statistics
- * @memcg: the memory cgroup
- * @idx: the stat item - can be enum memcg_stat_item or enum node_stat_item
- * @val: delta to add to the counter, can be negative
- */
-void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
-		       int val)
+static void __mod_memcg_state(struct mem_cgroup *memcg,
+			      enum memcg_stat_item idx, int val)
 {
 	int i = memcg_stats_index(idx);
 	int cpu;
 
-	if (mem_cgroup_disabled())
-		return;
-
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
@@ -746,6 +737,21 @@ void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
 	put_cpu();
 }
 
+/**
+ * mod_memcg_state - update cgroup memory statistics
+ * @memcg: the memory cgroup
+ * @idx: the stat item - can be enum memcg_stat_item or enum node_stat_item
+ * @val: delta to add to the counter, can be negative
+ */
+void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
+		       int val)
+{
+	if (mem_cgroup_disabled())
+		return;
+
+	__mod_memcg_state(memcg, idx, val);
+}
+
 #ifdef CONFIG_MEMCG_V1
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
 unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
@@ -765,21 +771,16 @@ unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
 }
 #endif
 
-static void mod_memcg_lruvec_state(struct lruvec *lruvec,
-				     enum node_stat_item idx,
-				     int val)
+static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
+				     enum node_stat_item idx, int val)
 {
-	struct mem_cgroup_per_node *pn;
-	struct mem_cgroup *memcg;
+	struct mem_cgroup *memcg = pn->memcg;
 	int i = memcg_stats_index(idx);
 	int cpu;
 
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	memcg = pn->memcg;
-
 	cpu = get_cpu();
 
 	/* Update memcg */
@@ -795,6 +796,17 @@ static void mod_memcg_lruvec_state(struct lruvec *lruvec,
 	put_cpu();
 }
 
+static void mod_memcg_lruvec_state(struct lruvec *lruvec,
+				     enum node_stat_item idx,
+				     int val)
+{
+	struct mem_cgroup_per_node *pn;
+
+	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+
+	__mod_memcg_lruvec_state(pn, idx, val);
+}
+
 /**
  * mod_lruvec_state - update lruvec memory statistics
  * @lruvec: the lruvec
-- 
2.20.1


