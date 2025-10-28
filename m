Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37E2CCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E08180162; Tue, 28 Oct 2025 10:04:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0699D8013F; Tue, 28 Oct 2025 10:04:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E742D80162; Tue, 28 Oct 2025 10:04:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CF7388013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:04:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9601C12A7C8
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:04:46 +0000 (UTC)
X-FDA: 84047693772.02.23F0C64
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf07.hostedemail.com (Postfix) with ESMTP id D0BD640022
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:04:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WK8tb2Ee;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f58KJTzXSs4X+PWy8zQk6jO+YawoCWN3pSg57esT6X0=;
	b=OT/ZIZ8behup16X8Z89qzcK+k/yHs793TF1ywCiYAfyB+ImtUjIixRsLNOs11tkh75ozIs
	K4mOABrQgKH9Q/FK8axEgI3a2/hh5oFw2/PgHr3+yF+pwHs0yMhRlBbgGbviUhZz4fSbKb
	r1P7oTlIxy5/RARtY/rfrqJt9oS7/fs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WK8tb2Ee;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660285; a=rsa-sha256;
	cv=none;
	b=c3Irg4lqtSWBqb2fx3ZD3ZuBSonlf4iedE2kSn4FHywBXowVyg0v0f8qBIc1vEf8wkeAOD
	Vrp5P97VqhdhVpTy2KPA9KUR58G1hriC98INEnLDB/bhIpiA1B2Ra+gxp6ptBdKAgCaMu4
	5wytP5Ykx6lT8ou9RwJFe468InPJumc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f58KJTzXSs4X+PWy8zQk6jO+YawoCWN3pSg57esT6X0=;
	b=WK8tb2EePZkDDXUBHA8X88Oky6gXYUGXPse40fNXgFJHtOyOpwiA5y2uY/2VpOK8KvPNgg
	VlXvf/E84wkSoXZBGSZplP19r6Ar3cyL356W88MS4D4kSi6MltL6XLjkKUacyXhIf+LeFQ
	PdHFCQeViZJqPv2MfDtugYoYaxGFSEE=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v1 22/26] mm: vmscan: prepare for reparenting traditional LRU folios
Date: Tue, 28 Oct 2025 21:58:35 +0800
Message-ID: <77c64e29b70bad6ca303e0e591624f9cdf2a750b.1761658311.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D0BD640022
X-Stat-Signature: 347kqiufmxuddehfrp5ufbuxu899bkyo
X-Rspam-User: 
X-HE-Tag: 1761660284-149572
X-HE-Meta: U2FsdGVkX1+CDbyM/fn2F87yWIzXSy4LjtvTR3sjR9nzzri5URbxa0R1Vxk/QzGuJrNzYIfNIDrg9rr2HmzccnzAMBjbfL7qY4KeYmJC/M9HdgHKmYmZqrAda5/MpwZGpXfCm2xVlCy6ueL8+MNCgTwGum9oIdd+KtYixAyhTt4ZRYATymSrxuTw79cq1rPPYBQ+TD+Bqu0wCrZII/NXatc5GEBmvMP4KSW/X6KMCOuiLZC5AKvBznMLrYyxabWbcfI9kRWAVe1ooJyg2HyINFKLfUO9foEJ+xKs9lXdulIawwuuuKw3NJzFIie7/xdmnvN+A0Ba1PfnSKhbTSh46VhY2uB4eldepvSS+8Pdj9NyjzX3bd/lLbqPG4lh5gyCu+y0sQvy3u/FMV+G7Ix7Jre2wNLkTEWixxF8orJoWGo4uLn7iWug+I5x122rfAOtU7oeO5l+LHQ1dlGq21VYWFS6x1KlatU7AG2Dd7J5NWapUbe3tnaWxqT4Oame5wJwdxLNawcWFT1WUBHI9E0ljrcnHKYUMxNVONyS6EPauI/p43Um+G7ZWtt8MJ31UwjdPIpWrIYV65PAP/RBTvdv46/oM+ddF+oHelpWoc7+DA6UdKiBMXopBM9p6RBlAUwqf9qKYlXP2V78rDkddDYqIK/rO3nLwSF+qGh/tDHv6wz3URJZJdu1iYHgdS5UdYlHHsxALjstdGAjTXczU4agg2/SN59uC0lrL40CNKSxR5R0N4E/mJ7IsN5Gq2ahluXat/RzAjX8PIqmdKQlpUPL9j8X/3M1MgLqEdE88TqQZtSw/p+Xx8LkCnrkAVDdQJTHKGLhzjikJ8C15mKWk6Grarms77hEaNWg6oXZJ5frHr5GmrFeE0BYBbMtMyrGe63ZzUO9cxDn4acHE8oPiA7uA6NomGbYpvOyXQ+5N+qCAkxuYorcaF0aS2yHb8/17ahKpJd460KURDd+KSJsghY
 hwMcdb35
 LE/nMxhtKslddjY2IgPMutMb5YZ6x5GETFNFbEDmz8kP/9zcdQ3PUQ+fx9hhZH4+ULtsCYtS3meKQvZT+izWJsNOOaOAF01VznondvnAg/vikygySsTempNozKAmhP+P4uIVyHH1lB9OZM/fqmHShlR/WODwdw2fZ10nRmKbkUFcNJ6B1u2CIo+CVAUGZ9yDKL4GsG73TlyTdpygdBEjNIIH60lzXF6b/jGaBiQjL8j62beKHST185kIC7wVT7OzoUks9
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
---
 include/linux/mmzone.h |  4 ++++
 mm/vmscan.c            | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 4398e027f450e..0d8776e5b6747 100644
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
index 676e6270e5b45..7aa8e1472d10d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2649,6 +2649,45 @@ static bool can_age_anon_pages(struct lruvec *lruvec,
 			  lruvec_memcg(lruvec));
 }
 
+
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


