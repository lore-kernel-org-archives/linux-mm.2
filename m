Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0984F10ED651
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 10:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76AD56B0098; Fri, 27 Mar 2026 06:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F4B06B0099; Fri, 27 Mar 2026 06:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E34D6B009B; Fri, 27 Mar 2026 06:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0666B0098
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:17:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE595C48F6
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:17:15 +0000 (UTC)
X-FDA: 84591440430.29.8E2E86B
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2AC06120002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:17:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vG1/z7mg";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774606634; a=rsa-sha256;
	cv=none;
	b=dRGhI0t90I5ErVdwFjAH92lpMWqEkdUlS4SCcjI5fhELq4xi/8ldcZiWHgDLG4Ah7wh6/A
	P6yNbwvw4lPqf4PruX3TOHFdMNBjD7ZmY4HNtl7R3iTBDr/7ZhffsQ8NLLf4WhwZ9X0512
	dRhiKU+8JBm3OuJDU8CG0+HCnlbP9FQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vG1/z7mg";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774606634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UVKpbAnwCWHxI9guS/ESyy7LHjntk0mlIyxKMppd3m0=;
	b=o6L5IkLqRFl2WjImWeeKr3cyWGWjcJmgrSjlzwIvGdhCv2+3y2u1vWWgqFGCz/wk83ERYr
	uctGLHlYoye7PluxOfNOw92FBXpdLQLPrGaBCE+zp6ahg8GRiauD8da9LqfCB9hDWNulD/
	LMBFSFNM7hfmSUuj/vORcumUihkIaYI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774606632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UVKpbAnwCWHxI9guS/ESyy7LHjntk0mlIyxKMppd3m0=;
	b=vG1/z7mgViJzxOnjTjMlweyBjtVjOGYcuMOZjqWfkr6P8/tf07CfNHrnXxPLk5C6N4hFyl
	FcnTxboGuJtqhJ9mYyHn6PLQiAbEhTC/oQg6+L7LFCdzPPc5cUodzxymTzhqfR5KxZfOqo
	ExSJSjgAUd4gfH0mk3etG+8nkXQLeLI=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
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
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 3/3] mm: memcontrol: correct the nr_pages parameter type of mem_cgroup_update_lru_size()
Date: Fri, 27 Mar 2026 18:16:30 +0800
Message-ID: <fd4140de44fa0a3978e4e2426731187fe8625f0b.1774604356.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1774604356.git.zhengqi.arch@bytedance.com>
References: <cover.1774604356.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: pf736zuzu4iocwnbmj9usg9tbcd8ejdu
X-Rspamd-Queue-Id: 2AC06120002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774606633-856320
X-HE-Meta: U2FsdGVkX1+1K/IfMINvk2o3QF7kBQ3BOJ7VvLS4PolGIVWVjgs1eh5fVNzgNKixBEPh8+Koc2P3iyLCKZERjb5oGmlOSJQIsp1S1CFRXoyU6aMYVWShH+XNroVmuuSs9+B3KuZpdN2It60H4AHBf9hyJGoeJppyg5McJjiwkj3PdM6DIDYh8+yz8v0klRt5x/j/fZuxTpYfdZQqdfNFtTUT+uQD4LExQ66rROoUYF2mkQd3BP0+kf1I/db/XQ7fAALQN3ewl/BeQPaGw9CggAKhhaoRkBH2Ub6zgAx00RWSkln3MpTW3o3FTsjTWDk6AEwqmH9PjNG/nGqFJLBq25nHneYL7xLWLDMF6HZSOQar/1dqRUfYy95YLvfPPBg5gNi5ErKx6j6uNqXunT5Tyd2aKFrdkVTp57GA5Kq+XFRc2WUJxrFkmR+7W7uJ2uZm5q+XtazMUeaQ5kk1lNvqPddVtzBTUCm0QRsIAbakBQYu/2JK/pzUS6dSCuBDeSXrmtNbtivBffRWSDxLWqCebgUe5SalBXiS7YGA3jY33x2MHgXeghAGH841gdBO6MPYXA7qELOfMhta4VEmiQEqjqY221kVBJMkxAMQ3xnRVrSq6P+JcHI+cqxoXFsAk2E/N4ZZRrMzukKRL3zNKPMAeqd6Pd2At5Ic68VTPnbZdi0fo/7n14AzI/cyqaRKVzbANuWYRxWPYAbqwpQbfUvBeJX15d0nxUWr+3t0nI2rqk+dR0F5EPRBdtPCyV/S9QBpgXnUB7ww2cmMuzedYtm/XKoH3nC9ibfxsKI8V3h8K7CkeL+jVMnooogPJVMBh+wqrQrKA5CU7nxZLBR5bZD8A2ddvrbt6nyey6ZaPNYoTV5aACBiK0gaSrDYok3MGj120ci+SlI0DDbRxUtrgMDlVbvbWPqNd8j3TLK4tb/yj7sgjgjbZ4nlTVgyd/yDbWD9yjiBL97a+OKfpep42qO
 vlUTtS6A
 7cyeMl1j+eSbAVKSiaEoiUK+CCRvmkVBx7agCH0vxMRXVbvTuEEyDnUvDDpghlirKOs7WTGjR4ygUvfNLNwVVIVoWZMeeZZipqBqpJVlHkYhVSwUwjbQlm/R/Z50uvKEeTDyE3algoy/7bKG902cmDGwyvb0GMar+SlDqhk3LgJwwqnk8S42sD0H6dRUWPI9j+m/qwVDFAU7j2sCoppL03/9VipYqvzZHvm+lIn2h7djdQ8s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

The nr_pages parameter of mem_cgroup_update_lru_size() represents a page
count. During the reparenting of LRU folios, the value passed to it can
potentially exceed the maximum value of a 32-bit integer. It should be
declared as long instead of int to match the types used in lruvec size
accounting and to prevent possible overflow.

Update the parameter type to long to ensure correctness.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/memcontrol.h | 2 +-
 mm/memcontrol.c            | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0782c72a1997b..4a7d8c4f55b48 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -874,7 +874,7 @@ static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 }
 
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
-		int zid, int nr_pages);
+		int zid, long nr_pages);
 
 static inline
 unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 51d72ddf08119..bf74167d77c5b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1472,7 +1472,7 @@ struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
  * to or just after a page is removed from an lru list.
  */
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
-				int zid, int nr_pages)
+				int zid, long nr_pages)
 {
 	struct mem_cgroup_per_node *mz;
 	unsigned long *lru_size;
@@ -1489,7 +1489,7 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 
 	size = *lru_size;
 	if (WARN_ONCE(size < 0,
-		"%s(%p, %d, %d): lru_size %ld\n",
+		"%s(%p, %d, %ld): lru_size %ld\n",
 		__func__, lruvec, lru, nr_pages, size)) {
 		VM_BUG_ON(1);
 		*lru_size = 0;
-- 
2.20.1


