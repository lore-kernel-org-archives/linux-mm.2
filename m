Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ACEBF3094F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:54:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1128F6B008C; Thu,  5 Mar 2026 06:54:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DB2E6B0092; Thu,  5 Mar 2026 06:54:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F15A16B0093; Thu,  5 Mar 2026 06:54:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1F076B008C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:54:13 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 937D18C665
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:54:13 +0000 (UTC)
X-FDA: 84511851186.07.E5837AC
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id E0B0E18000B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:54:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K94LyqzX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slvzxnQOZnGyEx6uyl7ed+CIq1Y9lBOT7LEWCAJSIOk=;
	b=z+WPL9kwYroTQ5Eem34z+ZcGTSApGRGWSWwpIHeB5ijnW+M8JU48QuNpY0lDIxidfg20GL
	sekLse+QmgW8R4JOpSZQK0DFFvDA50mG/Xkc6xRGMB3S26Hm20jro+6RezfsXhXSl0UBKT
	T5prqLrofv8bPz8IGX5vhP0Ho/gWXxE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K94LyqzX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711652; a=rsa-sha256;
	cv=none;
	b=RoVmQIQAseg9IlShde/HhLJlg886MIfjDus2nIer4eVgdbsDlSA09iD+ZmN1ZvU9UV8yBl
	PO3HWMLsK/D2bobeJN/NyA5p5u37Z+j4KI0P7ZIL1L613irtxgP0h5CYuPLaU+7naSzPdR
	aMligaA9jm7jEz6mJJJA4Gw3MrlfsZQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=slvzxnQOZnGyEx6uyl7ed+CIq1Y9lBOT7LEWCAJSIOk=;
	b=K94LyqzXS3gex8zFVnJgklSMCyl1mw39v9eFcSQDt3tLYoGbqG58fueQtSLfGedD0qbMWL
	IaWKIO1I3HWL/QISzw6kxwulQCi7W7F0VQ7rswv9IR110N0ONu0cttNUvLRj5hIkQZFpLY
	vQ7oRfBVai5yz3N4q7P3MJsT4Nr+388=
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
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH v6 01/33] mm: memcontrol: remove dead code of checking parent memory cgroup
Date: Thu,  5 Mar 2026 19:52:19 +0800
Message-ID: <f4481291bf8c6561dd8949045b5a1ed4008a6b63.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E0B0E18000B
X-Stat-Signature: bafpugm6owxsu4aqbd5eizc9pjie8o7j
X-Rspam-User: 
X-HE-Tag: 1772711651-473497
X-HE-Meta: U2FsdGVkX1+gFSWpIdfR52OVJ8kV5NWaJFKk+Dl5oYkaXmwcj5cB4ZqwxUjkx26Zvch4K/R+qc5esUWBQ2eHMJGAcxOCBzSZn/UheQapgPYZ6Hi9Euc2kn4plCRte6Zoi/0vo50YB2L0fU51sDFc6wD4uWL29oj7HuLBw/nOY/EKnPogpKzLLkAWkDlLvriWkJhHoz6TMVCdIYYzgbXhKtk+F6DaTFerUf9rrQK3szKC3pug5LXbhlirS2pRTOOwFCQXtW7w48OxEzjYxLsw2oeR8Ef+jQ5alGn18yDJx1gsEc0cugH0HQOUJUGwPvbUz3lIWOG7JcrBsXZ8LvwuWK/tf3COR5v9PwEbGVSJPMwuW5KeobovGGBnJB6Mpk3xOZsF0vODgmNMKKMHZ5Cifc8RE04e+zeJu3WlVAEhj9Ti15vfhcv4qH39lnvkGn55E2qm3nUEGaxbsRR/1taGrxsR2S+VOnaspWhXJC990S1PUYFEqJweMd2m++O2jOx8grWAynUmKtdCdWxYW/sNQrvay7+SPKXwpopnpMsYD2I6QlPYrGurB7NExh+NECSnr4OQZOOT7huCwgVZxeu+DyxmHyNoj3GlX/YXDE5LWmgO+CFA0stMg1nLiXxAah6E5knQIzc5nEaEIhZHwpMQEVikRu+774zz9tDyLajMv4yvfvQxzNJS0p+zS5lNj/1Rb6hScS/IqOuGvAaTHPvmIEjnWFhZmUzDfrhkIftDRiLZxIjqjen4+nQT6ZfI0fRnpWQene9j0t2WXF8Uafnx3czy/5SYwpz2E1v8Y/vsf8pkIM2CrLHRU6nlMiEowgF+u/2aKxUeqUpXYZAynx0hK0QGE6LF1jR1qNeFVevkTnOKGTcavt1HGv1DzbJN/UOferuBFagwY6LhCbudyQVU0NLdYXRZL3QOjtmuCR98bBA3gR8zvfylobb4i84w7ZMpsHbBAJYFoxT0nVIvynb
 WGLcpXIR
 1TVSh2TjAnAjCG0FD4I0+zGBm8nT1JrQdpT+61RoDRCJXhqYBAkUHychiVgkh4s+htl4ydqnK+oHfK0vHBWe/5JvuXH0DLsUHS5GC+elk+M2bBc55f2HSYdBxOOS/W1Ow/Zwgf3/ZOhXYp06kfNofmHo7beb2y9R2llc7Coe16yrwuU/OSmhfCd6oQTYNYlCI7EbdKVHAVQBmXO//j+Xgv23ctZOEOJ/304gzzBaIuDVhtseAydmLAb5NXrQJ87StPWvqEy44tAIjl+Gab0jbRcEfCWLtYmy3rhCC
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
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 5 -----
 mm/shrinker.c   | 6 +-----
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index db59fad3503f2..aab863e1822d4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3424,9 +3424,6 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
 		return;
 
 	parent = parent_mem_cgroup(memcg);
-	if (!parent)
-		parent = root_mem_cgroup;
-
 	memcg_reparent_list_lrus(memcg, parent);
 
 	/*
@@ -3706,8 +3703,6 @@ struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, un
 			break;
 		}
 		memcg = parent_mem_cgroup(memcg);
-		if (!memcg)
-			memcg = root_mem_cgroup;
 	}
 	return memcg;
 }
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 94646ee0af63b..4cd33222256ef 100644
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


