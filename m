Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 391DEE91297
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:05:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98EB96B00C5; Thu,  5 Feb 2026 04:05:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945E66B00C7; Thu,  5 Feb 2026 04:05:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 824AD6B00C8; Thu,  5 Feb 2026 04:05:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 711A76B00C5
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:05:15 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 40DBE1C277
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:05:15 +0000 (UTC)
X-FDA: 84409818990.19.6ABCFA6
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id 956F6C000C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:05:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="L/Rz2kc9";
	spf=pass (imf22.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7jFcIOUDkaubEwGoEkC6bdzZiVFewkjmb3X6C6JzsWU=;
	b=nOdIqxLpQRd9te/jd9MZXQzz+0bCbHFqOM2Sp3ZDgaEhcrRQX2gAjcBZdI/EIFYnYoqSYg
	d9JdZJJSxJ18vffujatwPhKZPwrmYvV3ymdkjTB8Y91DaL0HFB8DTZewsySxodbCC3pZjY
	rKLaRJZjaC25+l8nxseSnH1aNUP6epk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="L/Rz2kc9";
	spf=pass (imf22.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282313; a=rsa-sha256;
	cv=none;
	b=pVTK+m0v/p/MCPFSde+8bfHzypYaLvfBEFiUjMGTCb51x28i0zustSTohkGzj5e/07X16p
	xNGaCTayR0WtL+CXPFSP7v+z6RdC1Ub+97JzKcXLJq/X9B1C5JJptvy8VOjMCSfNeGhh8F
	5NvYtLHZ/Mb7g1p+yaGqo0ZM70Csf5g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7jFcIOUDkaubEwGoEkC6bdzZiVFewkjmb3X6C6JzsWU=;
	b=L/Rz2kc9fJKMY4HAeVxQjkQaw3Edh1c2yjznQCkbPgqqJnRZBwP3keW1+58eGGGtZbvO5F
	B5Y7rnRT9NHvPuQuGfA4fc4QY+yQBYjoQSod+yNB7WjMoYC4oheokru1its0J/CZ0rmVg1
	yD37EFiDP+aRrOnZs3n3XUHncJmYgiQ=
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
Subject: [PATCH v4 27/31] mm: memcontrol: refactor memcg_reparent_objcgs()
Date: Thu,  5 Feb 2026 17:01:46 +0800
Message-ID: <47f00dba3dfa2481a7397d7049b6e8b8744766e8.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 956F6C000C
X-Stat-Signature: xrinjqcndtak8kgfyasbmf9ww38hcj8o
X-Rspam-User: 
X-HE-Tag: 1770282313-288054
X-HE-Meta: U2FsdGVkX183VSs7GByCK4R8pkJK7aBH+Mpgd0ze9bbcTQqqf8b3OwvfaCZRWA9VTZKyTN+BNvvfniDyfu/Vw/uMhb9W8XwXeGw6xOEFChmkRuXyaAl4Qfl3qilm4x91e/loDGcwjB8dmZQZkv6h8CzwDXAfeXfw9rCDJIyV6Mmy2jnu1wjY8ctNmUrir2zn5Ghb7ZeFTqBmR5Vv9Ec2VKNaBFMZqWdxdqCqr5FiPpSopmvUHzOzyw8dBDKJtMpHXtM4pWiwfunnZk3lc/kwJ/5sZk1hxZSjQ2j35akq0sOOAzwJe68OdUEDqfF+VgQwWZqYM+ZK+cwu+GZ1yUvk6BPfSkPjBH76/uAkK7zT+S2FLF18CUcAlO9vH6kO7hpzPKmIcSpDxGjrOPPBqIkG6PZm/fpkUVEO5DLk42GD04D7zH1AiRxjRdBNkmA/nBXSf+UZUlACeVu+q8MsErVpQArp1l1X2kOHir7b+upex7IuZHZZkk35/lBFRO6Aw08SLEvZeM897cokLTSyU/Tbc7u7dmX7Zb87fhtRwWOdZ0TvW9a8it2rwAgn8kOxXz4ZT4jyrnAc0v997SenknGy1Wa2Xoz+ebcCjw42LJ8q9i1qTmpGbPFjuEFY9Ogong+9nHtfUSQKqJu284zdLGtxO5nIYRn5KEn+VpYwXPGIhp95K7cBN9JYz7Ta18RNh+9WTqklw2Akb44xOaI1WWdCKcB7Cx4XH4Wradp2c5TZUHg6ddBEW4b80n3vGljxkFrgzMRJu/thMQjC2T3nZIKONhRJZToDxXnTcdPUCOzXbhcVqRwtMrTxaGgcjFCUN2ZMAvcjmPW2d8QMC9nNyX9FbCs/U7FiJHrLmJFOQ3s6nJvvdFJAbIgDetD63bSkgvwDAfdqnkg9Hv6SCtRWsFMtCq9nOFKM7MKlySGBhpukn+HpLDvDNIOvBTbGXfjogljg8ghigrZLcMIn1KDgTE4
 i6O+yDLB
 nxSv3ByLV4vLChggOiEhHYwqMDEnvABKJ7Rf6FJBKucbbAWmV4nIO9gZaHhUTJqR74vRwv4a+r10GVTgSKXw/mK9R8pxzGWaZBzJ8hcKjQjis8DplST3c2qmlW1MzKNeEylT/Aeuf8pT0+ACPa3ftJ7yDS2gQd0GIEqB06CA57NZ4j1QwPINwnLH7q2YWxdcoLXXS4wDhhELJpX8Jl41kYDrBZoIZG6TkITDtxvrNBj72fQN1v0X9UZZ+Ig/vhC8WIpd5iYFAWS7TTjrpmMocad4aNzus8I1qK5sen4x2q0i8YCTR0New3Li2JP8f5cSS6+4ehE4H2vMR9oNF5kvdtd5Fe0LuhEiht8Eh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Refactor the memcg_reparent_objcgs() to facilitate subsequent reparenting
LRU folios here.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 mm/memcontrol.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 115a1f34bcef9..c9b5dfd822d0a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -208,15 +208,12 @@ static struct obj_cgroup *obj_cgroup_alloc(void)
 	return objcg;
 }
 
-static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
+static inline struct obj_cgroup *__memcg_reparent_objcgs(struct mem_cgroup *memcg,
+							 struct mem_cgroup *parent)
 {
 	struct obj_cgroup *objcg, *iter;
-	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 
 	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
-
-	spin_lock_irq(&objcg_lock);
-
 	/* 1) Ready to reparent active objcg. */
 	list_add(&objcg->list, &memcg->objcg_list);
 	/* 2) Reparent active objcg and already reparented objcgs to parent. */
@@ -225,7 +222,29 @@ static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
 	/* 3) Move already reparented objcgs to the parent's list */
 	list_splice(&memcg->objcg_list, &parent->objcg_list);
 
+	return objcg;
+}
+
+static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
+	spin_lock_irq(&objcg_lock);
+}
+
+static inline void reparent_unlocks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
 	spin_unlock_irq(&objcg_lock);
+}
+
+static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
+{
+	struct obj_cgroup *objcg;
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
+
+	reparent_locks(memcg, parent);
+
+	objcg = __memcg_reparent_objcgs(memcg, parent);
+
+	reparent_unlocks(memcg, parent);
 
 	percpu_ref_kill(&objcg->refcnt);
 }
-- 
2.20.1


