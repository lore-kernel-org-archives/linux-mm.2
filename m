Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEDDFD64086
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4439B6B0095; Wed, 17 Dec 2025 02:29:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40DFB6B0096; Wed, 17 Dec 2025 02:29:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3039F6B0098; Wed, 17 Dec 2025 02:29:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F0BE6B0095
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:29:59 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A135314092B
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:29:58 +0000 (UTC)
X-FDA: 84228138876.30.03C2CA6
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf04.hostedemail.com (Postfix) with ESMTP id DCFF640002
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:29:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wphsswng;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956597; a=rsa-sha256;
	cv=none;
	b=4qVnj53rv3Ta6jTS0kxYb8eOJeNXaPtwsALS/Glw7BnxsZSDSK34JiH1S3fAoPsdvnctHr
	bKLD1qbERcgczK7u1gtbVrRnttCf66nF6ATliKOW1uTcnMP0BxPJU7dHG9YqhOpwrTIkgm
	TOItiENE6+34rEP2GjiNLrSPr5Gpsww=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wphsswng;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4dfEcEvEfUWW7owlGocpCYghDEZ1Bptpjv9xHEdbhs=;
	b=B9C4cXwJ8bAciQmXZKv5yljYW/MJ5xKb4wGRHTH+kaTIFbCyoLef/rVf8zjiiCdHm/fPyU
	Q59JoGZDiqY5/4uuCiKt5/Rv3QH7hLgr1HLafrMsQuhA3CkiHWJWnAnJABcNxfmMCE8QMA
	oDDCc1VBn/CD6flA089qTe4ULPDnmYM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w4dfEcEvEfUWW7owlGocpCYghDEZ1Bptpjv9xHEdbhs=;
	b=Wphsswng/as3O4tABZ8G7iOBDRI+iGwrqKHsK8293bBW8/bK/AKP7cwvDUzYdHMl5pOdpp
	qE8F7Udp6woqzO9/M9NUloZqhwqogpco7PSNhaKAvVMLBGZlpiXaOyZ0reMDEzkdWujQb1
	kMIJLp2Ly4sVJ2ibeyQqjUuKFVtZZWQ=
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
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 06/28] mm: memcontrol: allocate object cgroup for non-kmem case
Date: Wed, 17 Dec 2025 15:27:30 +0800
Message-ID: <897be76398cb2027d08d1bcda05260ede54dc134.1765956025.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DCFF640002
X-Stat-Signature: somoeheewgowchxb7o8a7nkj513iqe5x
X-Rspam-User: 
X-HE-Tag: 1765956596-309310
X-HE-Meta: U2FsdGVkX18Al/iXAoIWmrGV6wDelZ9inSyiRd+IoiCiGo6RkaADzckZ1OK9dHC1g2VHhwjdqbp4KBYol0Q95KYTxHvKHRcrqcp4N74R+31CqGmkYpsmKStkW9BV2sjBReM0uglDxQHDP98jOlEy2BtUNinVtvB6znIb8KI5AkR6t78yw55j/n79jb3hhkEfF8vx31hNb/nE3v4rzOOQbWcdY0Nqrpk4dz6Qhs12ix0LZbRgFIXPpo04o93kF1QCeT4LS+RIlw3kE9KY8KNJFEec2HNgMKp2St56neVuVCD+Soa2zm2RZi0SXe1m0XRHJmfjsuzLQoWTA/elQ9DcfkuZvwjJSodoIISLdE57hwT3+Lrtsoc93cFwt5P9jcuzSZrXdcCfwzCujTmiPJ+Z30u0UEti/u9sUdUhq6yFBtXQrGRS186BmeQ4gFIXTaYrQxRuYCH4NbFPdJ/Iz/A9G8z9MEDCSStamYM3LEiFmXAmr48zsWPSJ4RErYRd9jALy19ZTcRFF9GiiPr2SbFISacJ6WPSmY4zjwW27NITrzeMK0kpw4rOzm4dJETr3KfKZp5NxP6JOaeb0iYuhosKbi7i8H3OSVVaRapt+X7tOHGUm7j2yfya3SMQmhQzxgWeya+nYaFvhQr/MXQMwoYdOsdUzXwu84ZLQaGr/iAi/DoxyOD86BR8d5n7CwQK6AwHPbcG+DznXbP9kI7OiDucMFW0vVe2pL3aB4eOg6yF6zu1X7qDbhDx1UW6Jj1DfRSixKpYJOm1sPUl987eowRAoQRIAwXhOH+8sr/9urDTDd7TVWdZWm7H4PLLZLtU4P2EYfJIh/Spskm5uUzDnKUDksixHj7PGIGWn7EyXRIhubtwPy4qUkudnFI4O+Ijkg9BZlkkkH0KTMSJp+yYKTwKynetnVaT2AGL58EBhloYwav+LnLazGxWJ+JNn7U1CFgWAJP8OZm4oCLI8aEpSi4
 2yAAg88v
 e4O9UqsySexluNJtXTrs3AWLwSFs9Ah8uQOKOSesQzOtiREnmC34OO17+ZsVgFsgcozq/J4pHoOH/gFct38eAGdbyhGY04hTtIbi4cJ7WH3jcGPpaAL9l1f23qVKKtA3RqqbbXYpEu2aV5o3zTSiUNJyWdrk2MMBbv45our/zbDb6o7IFOHK6FGor8f4slicjy49mmk5BsKu/YZM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

Pagecache pages are charged at allocation time and hold a reference
to the original memory cgroup until reclaimed. Depending on memory
pressure, page sharing patterns between different cgroups and cgroup
creation/destruction rates, many dying memory cgroups can be pinned
by pagecache pages, reducing page reclaim efficiency and wasting
memory. Converting LRU folios and most other raw memory cgroup pins
to the object cgroup direction can fix this long-living problem.

As a result, the objcg infrastructure is no longer solely applicable
to the kmem case. In this patch, we extend the scope of the objcg
infrastructure beyond the kmem case, enabling LRU folios to reuse
it for folio charging purposes.

It should be noted that LRU folios are not accounted for at the root
level, yet the folio->memcg_data points to the root_mem_cgroup. Hence,
the folio->memcg_data of LRU folios always points to a valid pointer.
However, the root_mem_cgroup does not possess an object cgroup.
Therefore, we also allocate an object cgroup for the root_mem_cgroup.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/memcontrol.c | 51 +++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ae234518d023c..544b3200db12d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -204,10 +204,10 @@ static struct obj_cgroup *obj_cgroup_alloc(void)
 	return objcg;
 }
 
-static void memcg_reparent_objcgs(struct mem_cgroup *memcg,
-				  struct mem_cgroup *parent)
+static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
 {
 	struct obj_cgroup *objcg, *iter;
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 
 	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
 
@@ -3294,30 +3294,17 @@ unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 	return val;
 }
 
-static int memcg_online_kmem(struct mem_cgroup *memcg)
+static void memcg_online_kmem(struct mem_cgroup *memcg)
 {
-	struct obj_cgroup *objcg;
-
 	if (mem_cgroup_kmem_disabled())
-		return 0;
+		return;
 
 	if (unlikely(mem_cgroup_is_root(memcg)))
-		return 0;
-
-	objcg = obj_cgroup_alloc();
-	if (!objcg)
-		return -ENOMEM;
-
-	objcg->memcg = memcg;
-	rcu_assign_pointer(memcg->objcg, objcg);
-	obj_cgroup_get(objcg);
-	memcg->orig_objcg = objcg;
+		return;
 
 	static_branch_enable(&memcg_kmem_online_key);
 
 	memcg->kmemcg_id = memcg->id.id;
-
-	return 0;
 }
 
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
@@ -3332,12 +3319,6 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
 
 	parent = parent_mem_cgroup(memcg);
 	memcg_reparent_list_lrus(memcg, parent);
-
-	/*
-	 * Objcg's reparenting must be after list_lru's, make sure list_lru
-	 * helpers won't use parent's list_lru until child is drained.
-	 */
-	memcg_reparent_objcgs(memcg, parent);
 }
 
 #ifdef CONFIG_CGROUP_WRITEBACK
@@ -3854,9 +3835,9 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	struct obj_cgroup *objcg;
 
-	if (memcg_online_kmem(memcg))
-		goto remove_id;
+	memcg_online_kmem(memcg);
 
 	/*
 	 * A memcg must be visible for expand_shrinker_info()
@@ -3866,6 +3847,15 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	if (alloc_shrinker_info(memcg))
 		goto offline_kmem;
 
+	objcg = obj_cgroup_alloc();
+	if (!objcg)
+		goto free_shrinker;
+
+	objcg->memcg = memcg;
+	rcu_assign_pointer(memcg->objcg, objcg);
+	obj_cgroup_get(objcg);
+	memcg->orig_objcg = objcg;
+
 	if (unlikely(mem_cgroup_is_root(memcg)) && !mem_cgroup_disabled())
 		queue_delayed_work(system_unbound_wq, &stats_flush_dwork,
 				   FLUSH_TIME);
@@ -3888,9 +3878,10 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	xa_store(&mem_cgroup_ids, memcg->id.id, memcg, GFP_KERNEL);
 
 	return 0;
+free_shrinker:
+	free_shrinker_info(memcg);
 offline_kmem:
 	memcg_offline_kmem(memcg);
-remove_id:
 	mem_cgroup_id_remove(memcg);
 	return -ENOMEM;
 }
@@ -3908,6 +3899,12 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	memcg_offline_kmem(memcg);
 	reparent_deferred_split_queue(memcg);
+	/*
+	 * The reparenting of objcg must be after the reparenting of the
+	 * list_lru and deferred_split_queue above, which ensures that they will
+	 * not mistakenly get the parent list_lru and deferred_split_queue.
+	 */
+	memcg_reparent_objcgs(memcg);
 	reparent_shrinker_deferred(memcg);
 	wb_memcg_offline(memcg);
 	lru_gen_offline_memcg(memcg);
-- 
2.20.1


