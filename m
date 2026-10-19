Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2761606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=vmanoCTZ
Received: by kanga.kvack.org (Postfix)
	id 820E46B0320; Mon, 19 Oct 2026 13:39:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D14D6B0322; Mon, 19 Oct 2026 13:39:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69A046B0323; Mon, 19 Oct 2026 13:39:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F5876B0320
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:39:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEC9BC06A6
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:39:37 +0000 (UTC)
X-FDA: 85340087994.18.E3D0E22
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf15.hostedemail.com (Postfix) with ESMTP id EA03DA000B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:39:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=vmanoCTZ;
	spf=pass (imf15.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792431576;
	b=h0J4UVlFhjLmXZXtlAXR/q/QoCvzcXFzjti9u3NlcE8Q4Iq4xlPrc5D2f/PPAdKeQF2wqG
	kZZ20V+fXenJc5aLN/WrKh/3hGXDs97ZlCfcF0sMt+XbRPYpu7d9+K/sQe60/tAPdFL3iB
	O8G7oXlBqJ7PaET6O2EF/mC0ZsEPi/U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=vmanoCTZ;
	spf=pass (imf15.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792431576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L564zTSbyW7RsQ72MGvk0hgr14JcFjENwmP8MEdxbFQ=;
	b=KFt+ftjLPe4lW3Zdv6uyPbzSDx5WaBEMZPvsJy6wRfmmDgEGpCH27y/IcUY4GNabVywl6+
	eFXmr24DzmClOoRa8MDAEGUj6PIYaXg2/cXDzyfTdxQHFFU29s5T+lsi3UBxNXNgaHfBEh
	jwx4httO/4Hq6rYiQvs8E71W/58vBzo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=L564zTSbyW7RsQ72MGvk0hgr14JcFjENwmP8MEdxbFQ=; b=vmanoCTZLSykPeQZOht
	UIzzTqhnlp9Dvheg7yDZHaUcJNRhXXUFedv6Pzil5NCweL918SkROF2iGIhpfH/VfePskLpBvCHbd
	1AhEkzUiPhVMgQOMjsaQfykeq2zE1xW+ZzAp8LejrA6wLCZDFY3Zqxlne7enIfkqZaJT2ZHfSlQpj
	zBoQJfniR3MPA4ZgaUb/MZ0o+X5t5g2RIsWyHDDHN4PJYlSWRpx9trrs8A3DwjvZoPH+oSKBnDcfq
	iSTiTOw+Xst0BD8ixRMj8Boq3+XN52iK+pH2IJnVf3FlwP1EwYJLTleO1v4UiJ3F++pkI+YkIqegU
	Wwr+GQgtkoWF9qQ==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xIrH2-007Chf-0H;
	Mon, 19 Oct 2026 19:39:20 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Mon, 19 Oct 2026 19:39:24 +0200
Subject: [PATCH 2/2] mm/shrinker: allocate the per-memcg shrinker units on
 demand
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v1-2-64ed1f7957c9@virtuozzo.com>
References: <20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v1-0-64ed1f7957c9@virtuozzo.com>
In-Reply-To: <20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v1-0-64ed1f7957c9@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9941;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=8uo6nmMfK1qRCkrTayzRsZZFLXg9ry/A/NIJpkUVam4=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq1lXPUfI/6sjDSwTkjjRqO/jqCNpkqD/v1yAaF
 wkBa66nkuuJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCatZVzwAKCRBRlgpH+WFc
 Khv8EACI13FKl26bLsJYggvCcjvmFoS/TptyzXRBL9LYsrzPtBtXsdLXs99WMwofIaQZgIOZmCC
 ALjUpX8BZebK5zCQbc7iaVLougI3YM5UmGy+VjHv01YUaU4BzdczUn2Oys62fXspLMRa5bNVzNJ
 GSPNghqASJ7ptVPGddeFTKAvbcaBkYCB8+bHd+7uglcf4ZK+pinhF4fZLtAy8vH+2QmsfuNd6oh
 Svtibcc3C2BMyrPMOyVnzaTv1MEOBjQhUbJZ0wrS/RTnDe+L98f5gkMDappAWW8diBLyMT9dqfd
 ywFgzU1+qiEmxflGkSsPz5Ptx9Y0ccEbcxRgyICZynDFEBNXSw8CCCRTMG9Yk4BRnIR91rLDnnv
 H0CxfyOUMIVyjqd4r6GkatGfTD09Ktv92tbyhZ5r6/oL0X1y7ti7Wso0bw8aLEvPqEj6p4Kn98h
 utEs2R3MoDzEPLkZmOX1BlZu1WVSIqemB+pbu7FWRPN/NNZvdf9ARKarGYhjo2Kyi0AWR+ryBz1
 6Go1aefBGKhaQu3BLgA9x5i2oOg4KFcs+s5SuiKXUTsrWRUtsDsRsoZrIQbmfhWvrfM5livqjzs
 O5t+DkPAgcDkmGuXGWe+FqbqY3ALVX5WvGD6PgkKdy0HFz1IkkBdw2q9xIW8dbqgnr+I0DmIFGe
 lGL+b3zu3il/PjQ==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspam-User: 
X-Rspamd-Queue-Id: EA03DA000B
X-Stat-Signature: cfy3nj6boosus558pbsambz8xe9w5dfn
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792431575-757299
X-HE-Meta: U2FsdGVkX19wjx3xiIc/61vHLGUDykn/1a1SxriU9+GOMRH1jzIKKDxncJ6tdLYecxKjU3HTnauMvUpuwvb0BRhyxURwnPF0Qv3C+EtahiOfyR20abLacBOXAtf/ntlAgoO3Khzqqi/w2HJnNWFpONRexio210UhCNYZWsJCoRxiRRErtSBRiQIQVmaeI1fpN0UH9PVGeFZmMfzc85reywBA/vxeFBwh/f30nRHh+XQMu7YTzm+gWCak3wqWSzFG/L3o3OtYkpMaD/y1nZBn8Av6IjpfAJMbjzNtfDw7J7wylh79O0b+8MLQ40vYF2TVywERXOwt31lbjfODnIb4Nbzk/5Tfv+UX7eMLtpMoV7a9wPUx8BaJoawVoct4XFWLQ05bKdI5KcBpwQfzbqzNV6BdBNl7GYozymBAbcwKZiFTVxQgNxsfsLb2zPthR+h8KsQCBKK8IlYPrPc6LPvSlVin5SETg+hXCBf+NxX/MwEKnoRBhLOShdv9ab9/GHfXbI++LxfLk93fOOvthIEI30XJilkKCnGsNxk/A8KXYUkaa293eptjnWzabbSVSC/volg7KIFGiAUQIVAhT4tHf9TD4AcIqczbBEoM/MiPe/Yy0gyUwhZQHUVZBAlrSxEFCs5eh2ICdF6TGQKPa1TX9Qx+Zp+jpXgjeJv0AtyXmqlyIhsfFdEyMLMsTI2T7EmI2ZHvUPWIOgznsHTVJq53PUl+cKvCp3nM8D2T1r1YiHZBgF9zRSm6gPJpMTkFcT44TkUWcD/DM7kEq9kTpVN1ggPOScj9/KZgOOeZOYZCM+KOig8mSMLec8GNSbTAws5C+w47UlVeFXd7u+9d30u6hq8jRcR+Pp95H+M10RAMa+qn0duYygoBQQcFARzst/CAlsoCs6NfMmNTIxkYLCLfIrpTGwc0aYfMdGWUdxMCSgcQ2DGvBAD4/M/KRagJ58q7gPZvo1o9vluZDL+O0jB
 ciY/tkxy
 Kivkf+ZElNb1G2oPNFsXO8nalBvDdX65uj0Qi6O5sSSsInxLEG+HQFYgePFSTdonVeYNEtV3RSlZ7U/v3+rixBjxqpigt8QaqVyKL9RA33I6EerAIX4DmGH+dYz9kjdBYRf6lMiq+Y4C8tWPt3EqOr0djkaTJQlgAfAyqhb8nTsCJl+gBJaP91sstVIYJmFHbf7gtUHYj9Aw7lN2s+63DhV9PgeBlQ0dBsLFEaUf99I/IKYfS3HWCQ0KJOSBecf52XA2YY2ktHsIgVzORq/Nc5jCzbyEv5XSTToZI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Instead of a shrinker_info_unit for every SHRINKER_UNIT_BITS ids up to
shrinker_nr_max on every NUMA node, give a memory cgroup only the units
of the shrinkers it holds a list_lru list of.

The rule the code relies on:

  A non-root memcg that has a list on a list_lru has the unit of that
  list's shrinker, on every node.

The unit is installed before the list is published and lives until the
memcg is freed, so set_shrinker_bit() always finds it. A reader that
finds none knows the memcg never held objects of that shrinker.

Two cases outside the rule:
- the root memcg, where global reclaim keeps the deferred work of
  memcg-aware shrinkers; it gets every unit up front and is the only
  memcg a shrinker registration still visits;
- under cgroup.memory=nokmem a list_lru is never per-memcg, so it gets
  no shrinker id either and no bit can be set.

The install runs with the gfp of the list allocation and can sit under
the i_pages lock, which is taken from interrupts, so the xarray lock is
irq-safe and a node it could not get under the lock is allocated
outside of it, as list_lru does for its own xarray.

The units of a memcg now scale with the shrinkers it and its
descendants hold objects of, not with shrinker_nr_max.

Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 include/linux/memcontrol.h |  2 +
 mm/list_lru.c              | 15 +++++--
 mm/memcontrol.c            |  7 +---
 mm/shrinker.c              | 98 +++++++++++++++++++++++++++++-----------------
 4 files changed, 77 insertions(+), 45 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 52f3646e244ae..91641cf082a4a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1678,6 +1678,8 @@ static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
 
 void shrinker_unit_cache_init(void);
 int alloc_shrinker_info(struct mem_cgroup *memcg);
+int memcg_shrinker_unit_alloc(struct mem_cgroup *memcg, int shrinker_id,
+			      gfp_t gfp);
 void free_shrinker_info(struct mem_cgroup *memcg);
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
 void reparent_shrinker_deferred(struct mem_cgroup *memcg);
diff --git a/mm/list_lru.c b/mm/list_lru.c
index 36662d02ff963..73480d8edf641 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -597,6 +597,12 @@ static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
 			parent = parent_mem_cgroup(pos);
 		}
 
+		if (!css_is_dying(&pos->css) &&
+		    memcg_shrinker_unit_alloc(pos, lru_shrinker_id(lru), gfp)) {
+			kfree(mlru);
+			return -ENOMEM;
+		}
+
 		if (!mlru) {
 			mlru = memcg_init_list_lru_one(lru, gfp);
 			if (!mlru)
@@ -666,13 +672,14 @@ int __list_lru_init(struct list_lru *lru, bool memcg_aware, struct shrinker *shr
 	int i;
 
 #ifdef CONFIG_MEMCG
-	if (shrinker)
+	if (mem_cgroup_kmem_disabled())
+		memcg_aware = false;
+
+	/* A list that is not per-memcg sets no memcg's shrinker bit. */
+	if (shrinker && memcg_aware)
 		lru->shrinker_id = shrinker->id;
 	else
 		lru->shrinker_id = -1;
-
-	if (mem_cgroup_kmem_disabled())
-		memcg_aware = false;
 #endif
 
 	lru->node = kzalloc_objs(*lru->node, nr_node_ids);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a13f3984f0e09..07075bb220719 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4110,7 +4110,7 @@ static bool alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 	INIT_LIST_HEAD(&pn->objcg_list);
 
 	lruvec_init(&pn->lruvec);
-	xa_init(&pn->shrinker_units);
+	xa_init_flags(&pn->shrinker_units, XA_FLAGS_LOCK_IRQ);
 	pn->memcg = memcg;
 
 	memcg->nodeinfo[node] = pn;
@@ -4277,11 +4277,6 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 
 	memcg_online_kmem(memcg);
 
-	/*
-	 * A memcg must be visible for expand_shrinker_info()
-	 * by the time the maps are allocated. So, we allocate maps
-	 * here, when mem_cgroup_iter() can't skip it.
-	 */
 	if (alloc_shrinker_info(memcg))
 		goto offline_kmem;
 
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 74fc6f64459f0..cd9441f149363 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -42,31 +42,40 @@ static struct shrinker_info_unit *shrinker_unit_get(struct mem_cgroup *memcg,
 }
 
 /*
- * A memcg is visible to expand_shrinker_info() before it goes online, so
- * a unit may already be there from either side.
+ * Installs run from the list_lru allocation path with the caller's gfp,
+ * possibly under the i_pages lock, which is taken from interrupts: the
+ * xarray lock is irq-safe and a node it could not get under the lock is
+ * allocated outside of it.
  */
-static int shrinker_unit_install(struct mem_cgroup *memcg, int nid, int index)
+static int shrinker_unit_install(struct mem_cgroup *memcg, int nid, int index,
+				 gfp_t gfp)
 {
-	struct xarray *units = &memcg->nodeinfo[nid]->shrinker_units;
+	XA_STATE(xas, &memcg->nodeinfo[nid]->shrinker_units, index);
 	struct shrinker_info_unit *unit;
-	int ret;
+	unsigned long flags;
 
-	if (xa_load(units, index))
+	if (xa_load(xas.xa, index))
 		return 0;
 
-	unit = kmem_cache_alloc_node(shrinker_unit_cachep,
-				     GFP_KERNEL | __GFP_ZERO, nid);
+	unit = kmem_cache_alloc_node(shrinker_unit_cachep, gfp | __GFP_ZERO,
+				     nid);
 	if (!unit)
 		return -ENOMEM;
 
-	ret = xa_insert(units, index, unit, GFP_KERNEL);
-	if (ret) {
+	do {
+		xas_lock_irqsave(&xas, flags);
+		if (!xas_load(&xas)) {
+			xas_store(&xas, unit);
+			if (!xas_error(&xas))
+				unit = NULL;
+		}
+		xas_unlock_irqrestore(&xas, flags);
+	} while (xas_nomem(&xas, gfp));
+
+	if (unit)
 		kmem_cache_free(shrinker_unit_cachep, unit);
-		if (ret == -EBUSY)
-			ret = 0;
-	}
 
-	return ret;
+	return xas_error(&xas);
 }
 
 static int shrinker_units_install(struct mem_cgroup *memcg, int start, int end)
@@ -75,7 +84,8 @@ static int shrinker_units_install(struct mem_cgroup *memcg, int start, int end)
 
 	for_each_node(nid) {
 		for (index = start; index < end; index++) {
-			ret = shrinker_unit_install(memcg, nid, index);
+			ret = shrinker_unit_install(memcg, nid, index,
+						    GFP_KERNEL);
 			if (ret)
 				return ret;
 		}
@@ -108,10 +118,17 @@ void free_shrinker_info(struct mem_cgroup *memcg)
 	mutex_unlock(&shrinker_mutex);
 }
 
+/*
+ * Global reclaim keeps the deferred work of memcg-aware shrinkers in the
+ * root's units, and root has no list_lru allocation to install them from.
+ */
 int alloc_shrinker_info(struct mem_cgroup *memcg)
 {
 	int ret;
 
+	if (!mem_cgroup_is_root(memcg))
+		return 0;
+
 	mutex_lock(&shrinker_mutex);
 	ret = shrinker_units_install(memcg, 0,
 				     shrinker_id_to_index(shrinker_nr_max));
@@ -124,26 +141,15 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
 
 static int expand_shrinker_info(int new_id)
 {
-	int ret = 0;
 	int new_nr_max = round_up(new_id + 1, SHRINKER_UNIT_BITS);
-	struct mem_cgroup *memcg;
-
-	if (!root_mem_cgroup)
-		goto out;
+	int ret = 0;
 
 	lockdep_assert_held(&shrinker_mutex);
 
-	memcg = mem_cgroup_iter(NULL, NULL, NULL);
-	do {
-		ret = shrinker_units_install(memcg,
+	if (root_mem_cgroup)
+		ret = shrinker_units_install(root_mem_cgroup,
 					     shrinker_id_to_index(shrinker_nr_max),
 					     shrinker_id_to_index(new_nr_max));
-		if (ret) {
-			mem_cgroup_iter_break(NULL, memcg);
-			goto out;
-		}
-	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
-out:
 	if (!ret)
 		shrinker_nr_max = new_nr_max;
 
@@ -211,7 +217,8 @@ static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
 	struct shrinker_info_unit *unit;
 
 	unit = shrinker_unit_get(memcg, nid, shrinker->id);
-	if (WARN_ON_ONCE(!unit))
+	/* No unit: this memcg never held objects of this shrinker. */
+	if (!unit)
 		return 0;
 
 	return atomic_long_xchg(&unit->nr_deferred[shrinker_id_to_offset(shrinker->id)], 0);
@@ -223,12 +230,35 @@ static long add_nr_deferred_memcg(long nr, int nid, struct shrinker *shrinker,
 	struct shrinker_info_unit *unit;
 
 	unit = shrinker_unit_get(memcg, nid, shrinker->id);
-	if (WARN_ON_ONCE(!unit))
+	if (!unit)
 		return 0;
 
 	return atomic_long_add_return(nr, &unit->nr_deferred[shrinker_id_to_offset(shrinker->id)]);
 }
 
+/*
+ * Called before @memcg gets a list on a list_lru of shrinker @shrinker_id:
+ * a map bit is only ever set on a memcg that has such a list.
+ */
+int memcg_shrinker_unit_alloc(struct mem_cgroup *memcg, int shrinker_id,
+			      gfp_t gfp)
+{
+	int nid, ret;
+
+	if (shrinker_id < 0 || mem_cgroup_is_root(memcg))
+		return 0;
+
+	for_each_node(nid) {
+		ret = shrinker_unit_install(memcg, nid,
+					    shrinker_id_to_index(shrinker_id),
+					    gfp);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
@@ -237,14 +267,13 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 	int nid, offset;
 	long nr;
 
-	/* Prevent from concurrent shrinker_info expand */
-	mutex_lock(&shrinker_mutex);
 	for_each_node(nid) {
 		struct xarray *parent_units = &parent->nodeinfo[nid]->shrinker_units;
 
 		xa_for_each(&memcg->nodeinfo[nid]->shrinker_units, index, child_unit) {
 			parent_unit = xa_load(parent_units, index);
-			if (WARN_ON_ONCE(!parent_unit))
+			/* Installed but never listed: nothing deferred in it. */
+			if (!parent_unit)
 				continue;
 			for (offset = 0; offset < SHRINKER_UNIT_BITS; offset++) {
 				nr = atomic_long_read(&child_unit->nr_deferred[offset]);
@@ -252,7 +281,6 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 			}
 		}
 	}
-	mutex_unlock(&shrinker_mutex);
 }
 #else
 static int shrinker_memcg_alloc(struct shrinker *shrinker)

-- 
2.43.0


