Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD29E606A332
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=G3IVVpGF
Received: by kanga.kvack.org (Postfix)
	id EFEB56B0324; Mon, 19 Oct 2026 13:39:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED31C6B0322; Mon, 19 Oct 2026 13:39:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D529A6B0322; Mon, 19 Oct 2026 13:39:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACCFC6B0322
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:39:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2E53E1606D7
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:39:38 +0000 (UTC)
X-FDA: 85340088036.28.B5B3E73
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1F90640008
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:39:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=G3IVVpGF;
	spf=pass (imf27.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792431576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zHnuirrNc367IjZFH3zZ8z3xoT1TDeKZt/utz/QfB6Y=;
	b=BnWHDXzxLgdScIQUzubIRL7nZmIOxOUuaSqfAt0JXnUu2lILkb+q5MoltOgr8KiNyelMUr
	HUCnpSSIZhiecuXjKt0E+LKAvpnuCaLvof5WKos9drhDWAndOPtpwouoUyjtVDUfYZeuP6
	PBZzcti5axjqxBnjCoNdPHrRZeyn4KQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=G3IVVpGF;
	spf=pass (imf27.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792431576;
	b=g5QqtDpgvFdr5w93o7nHwwbcUDiX41fJoUBxU1YaLHp83qqsaHAxU0zpAmDpbuEBXHsu0w
	RhDVEPj45jKIAwrxSVBZ8X4v8CCpraL53QdbOv+zGvAiC2t8dNBQENEf9b3WbPeejvbb7l
	DNyTFQFZ/bQhb9PJKJKgF3iGzLAiWD4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=zHnuirrNc367IjZFH3zZ8z3xoT1TDeKZt/utz/QfB6Y=; b=G3IVVpGFIRL3x16xiaC
	AJCmECQhdU3tyI3V6M+0Exi6vEYgWYnsIVu7d6cTqFw5WyBJNRegzOizoZ7s7ytdzHcxUjzm/3tOk
	VfXNBi0XNQaRBK81emY9uPYv6pV+cd/PhhWtaogoaz6CbS+QNfu6sp3RItVnbCYfJWV03vTfHSwWb
	9uaoQnOQ/9DG4D6cnwk6O9StcwAjpezPEhfWLzyRD9hAiPYBk9n4rYJOIqHnvs4VYaEXjLgeJiyZD
	cOHtl1EIlFuARXyrBwYhnfBjK9F0SyK3RosamrqOxLTRTfQtdFnP1dU4fHIZG7wnVS6LKgwTjJ1Cj
	YMmdNjbcgLf3f5w==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xIrH1-007Chf-22;
	Mon, 19 Oct 2026 19:39:19 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Mon, 19 Oct 2026 19:39:23 +0200
Subject: [PATCH 1/2] mm/shrinker: keep the per-memcg shrinker units in an
 xarray
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261019-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v1-1-64ed1f7957c9@virtuozzo.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=16675;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=sVC4fMQqfY/qvO5GWprmSJ4HVz7x2/++1IMEmDe3khk=;
 b=owEBbAKT/ZANAwAKAVGWCkf5YVwqAcsmYgBq1lXOsD8QfSlcM8r4JnX/ukVApYPSKHrC4MzVs
 ZJzvXN4Y1KJAjIEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCatZVzgAKCRBRlgpH+WFc
 KphpD/dzinaPGl1PrmAjUuZDYRppu5Z+68vcdVDp00Fd80VuBT0vBTGMiiQJSjfj6QhpCVKCxEZ
 3IyfGE50GJff6+OxEXWZJ3/Hasn1jQW7327rOxjmWLvc1xMd9AY9csP/lwOhExEyrtMBBl9Txo1
 ETghvq75jCwF1LxJzjYW+i+4AtkFhPplKqtFShEYuRaS11lvEGsitO2mTgi8QLTadx8t5Ue60aK
 hOG1Ie/iJyMbE2kGBaSTmfZ5+e/IvAwBI+pIO/p30/jFtg5Np32h/+VIeEFD7ui3VJ+OVZAjUCq
 nsGBZCk8LOluqJJ5/tozeBsLWO0R5vADA7yzQ8bFo01NG5ukAhY+IMmCLUVSD7ec0lDFuxw73vu
 JvdiQeJZRafBwyoUxsZTu4ueNaxsGNVL6y7H+qnaDOez6RRuY60Hb54qzh6SslyQdVpsgKy5AI9
 HEvow81Xd4BOZfy1qOQyqOBkLWtCP2a/oEFU8ltvsYdt2rnwN5ifdvnsRqJTOfN5hCGJUQpsoBz
 cX7KF87H7iepz0RWJrMYkBSs/hSR+fbiPtYtbY+wNs/nB86lrikeBzQiYVHlFFkAjWeT1TYcyfG
 k1/WCyRaQZQrEdvXf+vOJ0HKCwrS8zyZVRPguPS8lePxor2y4PT5Dsn461g0xlx1dA949BYbim0
 KK3XcLaMe5L2U
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1F90640008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: e8e68ragtz97q89m1ouigmntyttimux5
X-HE-Tag: 1792431575-401394
X-HE-Meta: U2FsdGVkX183V/LvnO40TZb8jURUvXsgLrBD8j/meNeYi84/ZNQR9fl5QLPuUV4A+V3G5PU6mKk522sYiTJitFAWOP3tnFXPFlYj1wgrG+1HKqsoi+ZxUKh06I536/hHd9eRDiDlx2Lay2r2rKpn5hCHsrXfZbSjVotwvdAxT2baZ4GO/Yll3LE+P+AXLQfuMFdgm8rS7HtgYtlVaXyVjEryhUFYToMLZFdKayCPnvCQQrfhS7I0alvSCQrqyq5cthmqVyAltzlVdsHVNIXyp1hXBJ1KdGW0IJhJcpzg09slIqU18enAMh0dNXhfLGaIRoaHa4Y5fK+YJ+eexPutZ0z4yL57Eh1rfsXWG/4vvCZRj1f1fcKiC9cp8inYPwgDZs40/XVfmAp1LEQtpm9ky2k71b86NC+b85gJes8jCoTLersQlQwE5nYefUf38vEpo+csi3bFV801BifNfdO03xOXHJfc5kETDvTDYW0Utr9Ca2aJov4++pOr7SuEMsje7dzZYYIln9dTW83mCBauQ/92/xmRslUAmdpUrt0BzfBfWmgSCrGoTez/7+uyTg80l4z7BkRymcUUzzSk4WW+dC03YSvnZud98oNXMOoYTqNaoZE9Ot+TNGBXpSPV8nq55GQ13QwRG4rBPH8NoOlZ5RPz55i/0TNJLAmM5LFMzd+Ha/9v1p1HPUDdX69kjFL5grPZKFWRz8Ndn8ZLYmad1rzISlhknsnVaDt0N2fzkNn7uJX2DifvxNfv/HrDtcAEER7tg1P3icUjDtOKj2jTf+xWo2PZIqlqUaO7PCdxthKnfRZmraM3ldpYPrad9vRz8CK/XtsIe97PJWej1sDGRSL92JzMuxXaN3rrYQBcXTc17SKXKzTcsp7c1M18Y3i8s2VRWECNZiEljuAEoc8LmiP6uhiTg7hW+IaAvtbph195Lk/2puLLllU5sre9uTVjmZqlnv3pWEboIyAqfDr
 EKOQEeB6
 oG03VQOwOTzdrw59XX7TtYfFUpFl9nh5uNSgXFNz7pF3TJCXY05ybGt/tm4KOUeFdXn6ylirLO8gcZQpv71qnGpb8ax6xORu1OYo8k9wtMLvym+q4Pdsts/ag1RFXPQvIFZtQpkCF0hC+QY/OtZvXtzMRwlGUA35yW111vRGJ38KxV9kOKcNo1gB1RbsKbzDLnsd12j57ryHAqUJyfVgVJwMbWkq1LxJ5uPDCwcbncwyeENYBtJHCxC3k01MAJp/jqwS7QvyW+20xAo0l0OhxzINkRtvj317KhHAm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every memory cgroup keeps, per NUMA node, an array of pointers to its
shrinker_info_units, sized for shrinker_nr_max ids. shrinker_nr_max is
the highest memcg-aware shrinker id ever handed out; every superblock
takes one, and it never comes down.

Keep the units in an xarray per memcg and node instead. Every memcg
then holds just the units it has, not an array sized for the host,
and growing shrinker_nr_max touches nothing that already exists.

The units are still allocated for every memcg up front.

Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 include/linux/memcontrol.h |   3 +-
 include/linux/shrinker.h   |   6 -
 mm/memcontrol.c            |   1 +
 mm/shrinker.c              | 312 +++++++++++++++------------------------------
 4 files changed, 105 insertions(+), 217 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b5a89594c263c..52f3646e244ae 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -23,6 +23,7 @@
 #include <linux/writeback.h>
 #include <linux/page-flags.h>
 #include <linux/shrinker.h>
+#include <linux/xarray.h>
 
 struct mem_cgroup;
 struct obj_cgroup;
@@ -93,7 +94,7 @@ struct mem_cgroup_per_node {
 
 	struct lruvec_stats_percpu __percpu	*lruvec_stats_percpu;
 	struct lruvec_stats			*lruvec_stats;
-	struct shrinker_info __rcu	*shrinker_info;
+	struct xarray			shrinker_units;
 
 #ifdef CONFIG_MEMCG_V1
 	/*
diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 1a00be90d93a9..2eae68a7ff6c5 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -18,12 +18,6 @@ struct shrinker_info_unit {
 	DECLARE_BITMAP(map, SHRINKER_UNIT_BITS);
 };
 
-struct shrinker_info {
-	struct rcu_head rcu;
-	int map_nr_max;
-	struct shrinker_info_unit *unit[];
-};
-
 /*
  * This struct is used to pass information from page reclaim to the shrinkers.
  * We consolidate the values for easier extension later.
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7a817181168ed..a13f3984f0e09 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4110,6 +4110,7 @@ static bool alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 	INIT_LIST_HEAD(&pn->objcg_list);
 
 	lruvec_init(&pn->lruvec);
+	xa_init(&pn->shrinker_units);
 	pn->memcg = memcg;
 
 	memcg->nodeinfo[node] = pn;
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 4fb424e721bca..74fc6f64459f0 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -19,48 +19,66 @@ void __init shrinker_unit_cache_init(void)
 	shrinker_unit_cachep = KMEM_CACHE(shrinker_info_unit, SLAB_PANIC);
 }
 
-static inline int shrinker_unit_size(int nr_items)
+static inline int shrinker_id_to_index(int shrinker_id)
 {
-	return (DIV_ROUND_UP(nr_items, SHRINKER_UNIT_BITS) * sizeof(struct shrinker_info_unit *));
+	return shrinker_id / SHRINKER_UNIT_BITS;
 }
 
-static inline void shrinker_unit_free(struct shrinker_info *info, int start)
+static inline int shrinker_id_to_offset(int shrinker_id)
 {
-	struct shrinker_info_unit **unit;
-	int nr, i;
+	return shrinker_id % SHRINKER_UNIT_BITS;
+}
 
-	if (!info)
-		return;
+static inline int calc_shrinker_id(int index, int offset)
+{
+	return index * SHRINKER_UNIT_BITS + offset;
+}
 
-	unit = info->unit;
-	nr = DIV_ROUND_UP(info->map_nr_max, SHRINKER_UNIT_BITS);
+static struct shrinker_info_unit *shrinker_unit_get(struct mem_cgroup *memcg,
+						    int nid, int shrinker_id)
+{
+	return xa_load(&memcg->nodeinfo[nid]->shrinker_units,
+		       shrinker_id_to_index(shrinker_id));
+}
 
-	for (i = start; i < nr; i++) {
-		if (!unit[i])
-			break;
+/*
+ * A memcg is visible to expand_shrinker_info() before it goes online, so
+ * a unit may already be there from either side.
+ */
+static int shrinker_unit_install(struct mem_cgroup *memcg, int nid, int index)
+{
+	struct xarray *units = &memcg->nodeinfo[nid]->shrinker_units;
+	struct shrinker_info_unit *unit;
+	int ret;
 
-		kmem_cache_free(shrinker_unit_cachep, unit[i]);
-		unit[i] = NULL;
+	if (xa_load(units, index))
+		return 0;
+
+	unit = kmem_cache_alloc_node(shrinker_unit_cachep,
+				     GFP_KERNEL | __GFP_ZERO, nid);
+	if (!unit)
+		return -ENOMEM;
+
+	ret = xa_insert(units, index, unit, GFP_KERNEL);
+	if (ret) {
+		kmem_cache_free(shrinker_unit_cachep, unit);
+		if (ret == -EBUSY)
+			ret = 0;
 	}
+
+	return ret;
 }
 
-static inline int shrinker_unit_alloc(struct shrinker_info *new,
-				       struct shrinker_info *old, int nid)
+static int shrinker_units_install(struct mem_cgroup *memcg, int start, int end)
 {
-	struct shrinker_info_unit *unit;
-	int nr = DIV_ROUND_UP(new->map_nr_max, SHRINKER_UNIT_BITS);
-	int start = old ? DIV_ROUND_UP(old->map_nr_max, SHRINKER_UNIT_BITS) : 0;
-	int i;
-
-	for (i = start; i < nr; i++) {
-		unit = kmem_cache_alloc_node(shrinker_unit_cachep,
-					     GFP_KERNEL | __GFP_ZERO, nid);
-		if (!unit) {
-			shrinker_unit_free(new, start);
-			return -ENOMEM;
-		}
+	int nid, index, ret;
 
-		new->unit[i] = unit;
+	for_each_node(nid) {
+		for (index = start; index < end; index++) {
+			ret = shrinker_unit_install(memcg, nid, index);
+			if (ret)
+				return ret;
+		}
 	}
 
 	return 0;
@@ -68,18 +86,18 @@ static inline int shrinker_unit_alloc(struct shrinker_info *new,
 
 static void __free_shrinker_info(struct mem_cgroup *memcg)
 {
-	struct mem_cgroup_per_node *pn;
-	struct shrinker_info *info;
+	struct shrinker_info_unit *unit;
+	unsigned long index;
 	int nid;
 
 	lockdep_assert_held(&shrinker_mutex);
 
 	for_each_node(nid) {
-		pn = memcg->nodeinfo[nid];
-		info = rcu_dereference_protected(pn->shrinker_info, true);
-		shrinker_unit_free(info, 0);
-		kvfree(info);
-		rcu_assign_pointer(pn->shrinker_info, NULL);
+		struct xarray *units = &memcg->nodeinfo[nid]->shrinker_units;
+
+		xa_for_each(units, index, unit)
+			kmem_cache_free(shrinker_unit_cachep, unit);
+		xa_destroy(units);
 	}
 }
 
@@ -92,82 +110,22 @@ void free_shrinker_info(struct mem_cgroup *memcg)
 
 int alloc_shrinker_info(struct mem_cgroup *memcg)
 {
-	int nid, ret = 0;
-	int array_size = 0;
+	int ret;
 
 	mutex_lock(&shrinker_mutex);
-	array_size = shrinker_unit_size(shrinker_nr_max);
-	for_each_node(nid) {
-		struct shrinker_info *info = kvzalloc_node(sizeof(*info) + array_size,
-							   GFP_KERNEL, nid);
-		if (!info)
-			goto err;
-		info->map_nr_max = shrinker_nr_max;
-		if (shrinker_unit_alloc(info, NULL, nid)) {
-			kvfree(info);
-			goto err;
-		}
-		rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_info, info);
-	}
+	ret = shrinker_units_install(memcg, 0,
+				     shrinker_id_to_index(shrinker_nr_max));
+	if (ret)
+		__free_shrinker_info(memcg);
 	mutex_unlock(&shrinker_mutex);
 
 	return ret;
-
-err:
-	__free_shrinker_info(memcg);
-	mutex_unlock(&shrinker_mutex);
-	return -ENOMEM;
-}
-
-static struct shrinker_info *shrinker_info_protected(struct mem_cgroup *memcg,
-						     int nid)
-{
-	return rcu_dereference_protected(memcg->nodeinfo[nid]->shrinker_info,
-					 lockdep_is_held(&shrinker_mutex));
-}
-
-static int expand_one_shrinker_info(struct mem_cgroup *memcg, int new_size,
-				    int old_size, int new_nr_max)
-{
-	struct shrinker_info *new, *old;
-	struct mem_cgroup_per_node *pn;
-	int nid;
-
-	for_each_node(nid) {
-		pn = memcg->nodeinfo[nid];
-		old = shrinker_info_protected(memcg, nid);
-		/* Not yet online memcg */
-		if (!old)
-			return 0;
-
-		/* Already expanded this shrinker_info */
-		if (new_nr_max <= old->map_nr_max)
-			continue;
-
-		new = kvzalloc_node(sizeof(*new) + new_size, GFP_KERNEL, nid);
-		if (!new)
-			return -ENOMEM;
-
-		new->map_nr_max = new_nr_max;
-
-		memcpy(new->unit, old->unit, old_size);
-		if (shrinker_unit_alloc(new, old, nid)) {
-			kvfree(new);
-			return -ENOMEM;
-		}
-
-		rcu_assign_pointer(pn->shrinker_info, new);
-		kvfree_rcu(old, rcu);
-	}
-
-	return 0;
 }
 
 static int expand_shrinker_info(int new_id)
 {
 	int ret = 0;
 	int new_nr_max = round_up(new_id + 1, SHRINKER_UNIT_BITS);
-	int new_size, old_size = 0;
 	struct mem_cgroup *memcg;
 
 	if (!root_mem_cgroup)
@@ -175,13 +133,11 @@ static int expand_shrinker_info(int new_id)
 
 	lockdep_assert_held(&shrinker_mutex);
 
-	new_size = shrinker_unit_size(new_nr_max);
-	old_size = shrinker_unit_size(shrinker_nr_max);
-
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
-		ret = expand_one_shrinker_info(memcg, new_size, old_size,
-					       new_nr_max);
+		ret = shrinker_units_install(memcg,
+					     shrinker_id_to_index(shrinker_nr_max),
+					     shrinker_id_to_index(new_nr_max));
 		if (ret) {
 			mem_cgroup_iter_break(NULL, memcg);
 			goto out;
@@ -194,38 +150,20 @@ static int expand_shrinker_info(int new_id)
 	return ret;
 }
 
-static inline int shrinker_id_to_index(int shrinker_id)
-{
-	return shrinker_id / SHRINKER_UNIT_BITS;
-}
-
-static inline int shrinker_id_to_offset(int shrinker_id)
+void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
 {
-	return shrinker_id % SHRINKER_UNIT_BITS;
-}
+	struct shrinker_info_unit *unit;
 
-static inline int calc_shrinker_id(int index, int offset)
-{
-	return index * SHRINKER_UNIT_BITS + offset;
-}
+	if (shrinker_id < 0 || !memcg || mem_cgroup_is_root(memcg))
+		return;
 
-void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
-{
-	if (shrinker_id >= 0 && memcg && !mem_cgroup_is_root(memcg)) {
-		struct shrinker_info *info;
+	unit = shrinker_unit_get(memcg, nid, shrinker_id);
+	if (WARN_ON_ONCE(!unit))
+		return;
 
-		rcu_read_lock();
-		info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-		if (!WARN_ON_ONCE(shrinker_id >= info->map_nr_max)) {
-			struct shrinker_info_unit *unit;
-
-			unit = info->unit[shrinker_id_to_index(shrinker_id)];
-			/* Pairs with smp mb in shrink_slab() */
-			smp_mb__before_atomic();
-			set_bit(shrinker_id_to_offset(shrinker_id), unit->map);
-		}
-		rcu_read_unlock();
-	}
+	/* Pairs with smp mb in shrink_slab() */
+	smp_mb__before_atomic();
+	set_bit(shrinker_id_to_offset(shrinker_id), unit->map);
 }
 
 static DEFINE_IDR(shrinker_idr);
@@ -270,52 +208,44 @@ static void shrinker_memcg_remove(struct shrinker *shrinker)
 static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
 				   struct mem_cgroup *memcg)
 {
-	struct shrinker_info *info;
 	struct shrinker_info_unit *unit;
-	long nr_deferred;
 
-	rcu_read_lock();
-	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-	unit = info->unit[shrinker_id_to_index(shrinker->id)];
-	nr_deferred = atomic_long_xchg(&unit->nr_deferred[shrinker_id_to_offset(shrinker->id)], 0);
-	rcu_read_unlock();
+	unit = shrinker_unit_get(memcg, nid, shrinker->id);
+	if (WARN_ON_ONCE(!unit))
+		return 0;
 
-	return nr_deferred;
+	return atomic_long_xchg(&unit->nr_deferred[shrinker_id_to_offset(shrinker->id)], 0);
 }
 
 static long add_nr_deferred_memcg(long nr, int nid, struct shrinker *shrinker,
 				  struct mem_cgroup *memcg)
 {
-	struct shrinker_info *info;
 	struct shrinker_info_unit *unit;
-	long nr_deferred;
 
-	rcu_read_lock();
-	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-	unit = info->unit[shrinker_id_to_index(shrinker->id)];
-	nr_deferred =
-		atomic_long_add_return(nr, &unit->nr_deferred[shrinker_id_to_offset(shrinker->id)]);
-	rcu_read_unlock();
+	unit = shrinker_unit_get(memcg, nid, shrinker->id);
+	if (WARN_ON_ONCE(!unit))
+		return 0;
 
-	return nr_deferred;
+	return atomic_long_add_return(nr, &unit->nr_deferred[shrinker_id_to_offset(shrinker->id)]);
 }
 
 void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 {
-	int nid, index, offset;
-	long nr;
 	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
-	struct shrinker_info *child_info, *parent_info;
 	struct shrinker_info_unit *child_unit, *parent_unit;
+	unsigned long index;
+	int nid, offset;
+	long nr;
 
 	/* Prevent from concurrent shrinker_info expand */
 	mutex_lock(&shrinker_mutex);
 	for_each_node(nid) {
-		child_info = shrinker_info_protected(memcg, nid);
-		parent_info = shrinker_info_protected(parent, nid);
-		for (index = 0; index < shrinker_id_to_index(child_info->map_nr_max); index++) {
-			child_unit = child_info->unit[index];
-			parent_unit = parent_info->unit[index];
+		struct xarray *parent_units = &parent->nodeinfo[nid]->shrinker_units;
+
+		xa_for_each(&memcg->nodeinfo[nid]->shrinker_units, index, child_unit) {
+			parent_unit = xa_load(parent_units, index);
+			if (WARN_ON_ONCE(!parent_unit))
+				continue;
 			for (offset = 0; offset < SHRINKER_UNIT_BITS; offset++) {
 				nr = atomic_long_read(&child_unit->nr_deferred[offset]);
 				atomic_long_add(nr, &parent_unit->nr_deferred[offset]);
@@ -485,9 +415,9 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
 static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 			struct mem_cgroup *memcg, int priority)
 {
-	struct shrinker_info *info;
-	unsigned long ret, freed = 0;
-	int offset, index = 0;
+	struct shrinker_info_unit *unit;
+	unsigned long index, ret, freed = 0;
+	int offset;
 
 	if (!mem_cgroup_online(memcg))
 		return 0;
@@ -495,51 +425,17 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 	/*
 	 * lockless algorithm of memcg shrink.
 	 *
-	 * The shrinker_info may be freed asynchronously via RCU in the
-	 * expand_one_shrinker_info(), so the rcu_read_lock() needs to be used
-	 * to ensure the existence of the shrinker_info.
-	 *
-	 * The shrinker_info_unit is never freed unless its corresponding memcg
-	 * is destroyed. Here we already hold the refcount of memcg, so the
-	 * memcg will not be destroyed, and of course shrinker_info_unit will
-	 * not be freed.
+	 * A unit is only freed together with its memcg, and the caller holds
+	 * a reference to the memcg, so the units found by xa_for_each() stay
+	 * valid without the RCU lock and do_shrink_slab() may sleep.
 	 *
-	 * So in the memcg shrink:
-	 *  step 1: use rcu_read_lock() to guarantee existence of the
-	 *          shrinker_info.
-	 *  step 2: after getting shrinker_info_unit we can safely release the
-	 *          RCU lock.
-	 *  step 3: traverse the bitmap and calculate shrinker_id
-	 *  step 4: use rcu_read_lock() to guarantee existence of the shrinker.
-	 *  step 5: use shrinker_id to find the shrinker, then use
-	 *          shrinker_try_get() to guarantee existence of the shrinker,
-	 *          then we can release the RCU lock to do do_shrink_slab() that
-	 *          may sleep.
-	 *  step 6: do shrinker_put() paired with step 5 to put the refcount,
-	 *          if the refcount reaches 0, then wake up the waiter in
-	 *          shrinker_free() by calling complete().
-	 *          Note: here is different from the global shrink, we don't
-	 *                need to acquire the RCU lock to guarantee existence of
-	 *                the shrinker, because we don't need to use this
-	 *                shrinker to traverse the next shrinker in the bitmap.
-	 *  step 7: we have already exited the read-side of rcu critical section
-	 *          before calling do_shrink_slab(), the shrinker_info may be
-	 *          released in expand_one_shrinker_info(), so go back to step 1
-	 *          to reacquire the shrinker_info.
+	 * The shrinker is found by id under the RCU lock, and
+	 * shrinker_try_get() pins it before the lock is dropped;
+	 * shrinker_put() wakes up the waiter in shrinker_free() by calling
+	 * complete() when the last reference goes. The next shrinker comes
+	 * from the bitmap, not from this shrinker, so nothing else is needed.
 	 */
-again:
-	rcu_read_lock();
-	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-	if (unlikely(!info))
-		goto unlock;
-
-	if (index < shrinker_id_to_index(info->map_nr_max)) {
-		struct shrinker_info_unit *unit;
-
-		unit = info->unit[index];
-
-		rcu_read_unlock();
-
+	xa_for_each(&memcg->nodeinfo[nid]->shrinker_units, index, unit) {
 		for_each_set_bit(offset, unit->map, SHRINKER_UNIT_BITS) {
 			struct shrink_control sc = {
 				.gfp_mask = gfp_mask,
@@ -594,12 +490,8 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 			freed += ret;
 			shrinker_put(shrinker);
 		}
-
-		index++;
-		goto again;
 	}
-unlock:
-	rcu_read_unlock();
+
 	return freed;
 }
 #else /* !CONFIG_MEMCG */

-- 
2.43.0


