Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 503DED64086
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94A446B0089; Wed, 17 Dec 2025 02:28:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90A786B008A; Wed, 17 Dec 2025 02:28:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8094A6B008C; Wed, 17 Dec 2025 02:28:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 70C716B0089
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:28:46 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 221871A0932
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:28:46 +0000 (UTC)
X-FDA: 84228135852.09.D181C9F
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id 721DB80002
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:28:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="qFETWJ3/";
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PzAKpbiIZxa6n28+BpnjQ9tXWvyZHSCscw68X1Foo9A=;
	b=UZOcovoCKDvIy5gau6FteZK4C7jk46xavVYNFHSSUw9QXKH1ZYEVmqCHFINEcQXEldWqOu
	3TW67zTlq2K+OoJ9gnbBu8V50KvpYEnommdieNq3ESBBaJuDAHi9Z5xajUTXIq5s1pM9+D
	b0QFqvK3Iid/ykYrm05GA4Y7ru4wYLM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="qFETWJ3/";
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956524; a=rsa-sha256;
	cv=none;
	b=WRuCxMn69u4ysbWLm9uw6dX8adiTteYK1fYkElTU1fowW/SkR/Xb7zTniwxEMfOzA/4896
	aIln7rmZAjA5YsuX9HwNHsf9nyWImjckoAdvVpoyJ+RLyn4Gknkj9FDXtukf4l+2Phb3Dc
	1+XEX2YsA8etY6Kw0S97ZI7TP/26Sh8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PzAKpbiIZxa6n28+BpnjQ9tXWvyZHSCscw68X1Foo9A=;
	b=qFETWJ3/QbdSXlWUUX5sj/GLxv/uSjNALIuZ6SkUIGRjkqLuFad+gZwNeXXCVqqGKcwF8m
	Ph4pcxZJZGxxofIQxCgpMmaoeumjFkDPE/0ZabisZiaJrL0RllkrAspiKspyj++VDnh8vH
	ee7Bw8gYmx4i0tjC6dQoLoP21p+2XUk=
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
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH v2 01/28] mm: memcontrol: remove dead code of checking parent memory cgroup
Date: Wed, 17 Dec 2025 15:27:25 +0800
Message-ID: <f96258f164779363fa894d3b278254e352e39088.1765956025.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 721DB80002
X-Stat-Signature: 767y6tkuz3ycozgraxpakzgbdt9ebryx
X-HE-Tag: 1765956524-649100
X-HE-Meta: U2FsdGVkX1+R7Rgtvfv/kqEf5TVMtgrggpZmaBanNJT+pzAgd7XxkvRNoB9sIACFdVc0YbdrCTuFsGRd8/9Uagl6gMt740t1fFNF+eNRmvS8OT49kqyb04vpT2I51KTgTg3AGhsHOfY6a9bCzCYXA0wodeLwLv6tTQ2yvGNzaFmxGbJVPoh9FbhvoqWMKQw6oDbhOMeqw8I92RU8INO6evY0lCrKN+ExT7pqbeDA/XMWDSXJI6ziuofJRgPuxr6DouMIAVm7KuCnzR7icG2+7tOAFTy3qH/SidhyEOYacP1LcNjS7Le+dRvjM4f8WJ5YOtRAqQhexNiv9Ik7k6Gj9Ab3O7kIqSANlyJdz98NRZPjjZmpxpmCZzyQ1N9LqGhvwzJurgKCQBv+onK1qxukSdFz0C+qoOeP4qkiMvvSAc7xhZcjwet8LiYQNNRgPA+Cgr95XYQzL+ORYx5OIPXMtW+AQ80T+IxCBDJOVTefE9QKSklogTgOWrYDcF/aUclgds8Zckaw84WuRoGFs/i4UB3nmnLtjfi5ZkvalsgDA0kHxMO1e3Dn4xasVKW4HbT5r5J7H/TUBb/PVqCVUxYMnXiuWYBl4ZH5Iz3ERLSjE8QeSqHmhx7ZqPbA/jH6pf7PZHZZp6RHQXCFw/lvNiQx/rmBlwZupraDZX43xXTWs7qS2Rcqj1EsNUf1H2kCqd2/RBqy6bASOPRV81JwN73/t7njf1R91PzfYGTL6++6nCPRYitWLdaGrqKGFPpmU9+MyxA9okrtwVh/R9VHE1mlhtWd8WFsIT2LAbgztSS4cduUjR0HKcXMmEjgIr1X8HlaN4uK9kWGxCJXwvHdmV0wMvcLrqOWHSHfbKfq/XfR21iR01xJ5eXl8yqssKss86RINxXZn1uQqc6pQPHOzhKC2JIAzKYw9Nx1/xNeALpLzVZiISQ1x6NNCnP6FQQnej6mm6WyTkgKUgAmTlH/XQX
 JIpjBZzQ
 6NqjkTGH1GgkHCrMHECuuPaDSf5uBjLl+WwMiqCl/mmeAot86aICsd08dZBpPveuu+JgThvD3Pun7wm/rlaHQL5m7EVJjBdDKIK+FMdV8W5oiOaAwx+YtDbvYm7h/28rOEJfZ3LfCJ2UpYbhP0Z6eJ7XFsJiRX/FcSIHQZllHOu52LVzxpkf2e4KUwSu04xW6lwK2inS1ee5OGXX6T/t8yHRWdL80wkZ/xQXDn8UIjobi5l8b78SLnb/cffiPdDvH+z5LHauVLMneW+JPedbsNnX+wF+twtkfrNjy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

Since the no-hierarchy mode has been deprecated after the commit:

  commit bef8620cd8e0 ("mm: memcg: deprecate the non-hierarchical mode").

As a result, parent_mem_cgroup() will not return NULL except when passing
the root memcg, and the root memcg cannot be offline. Hence, it's safe to
remove the check on the returned value of parent_mem_cgroup(). Remove the
corresponding dead code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Chen Ridong <chenridong@huawei.com>
---
 mm/memcontrol.c | 5 -----
 mm/shrinker.c   | 6 +-----
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e2e49f4ec9e0e..ae234518d023c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3331,9 +3331,6 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
 		return;
 
 	parent = parent_mem_cgroup(memcg);
-	if (!parent)
-		parent = root_mem_cgroup;
-
 	memcg_reparent_list_lrus(memcg, parent);
 
 	/*
@@ -3624,8 +3621,6 @@ struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg)
 			break;
 		}
 		memcg = parent_mem_cgroup(memcg);
-		if (!memcg)
-			memcg = root_mem_cgroup;
 	}
 	return memcg;
 }
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 4a93fd433689a..e8e092a2f7f41 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -286,14 +286,10 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 {
 	int nid, index, offset;
 	long nr;
-	struct mem_cgroup *parent;
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 	struct shrinker_info *child_info, *parent_info;
 	struct shrinker_info_unit *child_unit, *parent_unit;
 
-	parent = parent_mem_cgroup(memcg);
-	if (!parent)
-		parent = root_mem_cgroup;
-
 	/* Prevent from concurrent shrinker_info expand */
 	mutex_lock(&shrinker_mutex);
 	for_each_node(nid) {
-- 
2.20.1


