Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1C53CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19EE880151; Tue, 28 Oct 2025 10:02:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 128A58013F; Tue, 28 Oct 2025 10:02:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 017CB80151; Tue, 28 Oct 2025 10:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC7CF8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:02:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A63FA140457
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:02:45 +0000 (UTC)
X-FDA: 84047688690.26.406A45C
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id BEAB14000D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:02:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W0fUHRG4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660164; a=rsa-sha256;
	cv=none;
	b=TxizA9bm+zmn7QFE2qFHL7nBmyXywMpV3D5AU+MQvQLBlaSHyDCUnCePYy4UWqdDPrcxwH
	PY6Z8RgiwIweN+t1ksVR91VyHSICoBLvV3PbrHSgN13egOmHcwbbcngWGve86GqIUYblnT
	7XfBl8Dns2EEM4nTyGmjhkDFZpnBb88=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W0fUHRG4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vADUOVCTUyanUbeGYLX+Ark3f6lRuzoYGyYZcLXZB20=;
	b=naIhcrsmXxSWdw+yRcx/b81TG2QWlhEhklKya/5G7OsZBCoLyQYNhmLmLuAk/NP+5ciU+5
	2SAzt1TzOe+n81IUhO54HU2h5sXpSoKlk+lic5bGcrS6bXqTIyCUohLrO6/SBkInW5Munn
	PLXVZnVWhcmRlW2QotOG1lcsFPUyImo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vADUOVCTUyanUbeGYLX+Ark3f6lRuzoYGyYZcLXZB20=;
	b=W0fUHRG4doPVJdPkNsUr8ClISjNAHVaM3dOSVPdYSnIpdNFSYC1KglRqk1Db2UqDqExsp7
	MzTNJEmVzy6i8fmBnDqH68d3HdsloQOgbmdRuHgAr5CIh9raIpJoGFDS4updR4s4ChTrpp
	h3UazzgIlv8YMEkBXpEcX3FkbEHAIMU=
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
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v1 05/26] mm: memcontrol: allocate object cgroup for non-kmem case
Date: Tue, 28 Oct 2025 21:58:18 +0800
Message-ID: <05ef300193bbe5bb7d2d97723efe928dab60429b.1761658310.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BEAB14000D
X-Stat-Signature: ds7o8in7j5daoz9kx49d5hne4g16zgra
X-HE-Tag: 1761660163-782975
X-HE-Meta: U2FsdGVkX1+Jo2BuigS+NhtfLvMcaXBjvAX10fjdEZBI8zsyzTNfVa8ibPxTmW7uG4Nt2MRsuktWHKsIyhpVfurC+2hs22ImALxl/EX9Ac95wxcTvmRaCAyYOFU0rVoXe+iHvAbHO8nudl1C17T3aTv7N+5BUBcqaskScX+IzA18pGLWmMR9aC2aqQqkM6uegbajOvnFFRn32WBAlc0QJMLr/RKesAn/+muJvxrar1qwu1NDM4pKdqCZox3qIb6YhUTBPwp+wm8v8hkzcMAcJUBF5pCkcCpJMxcPyTCOEkym1nyzgGDEQOisVepLwuEokEM2EGN+Wi4j5l875RsV/lkBacD8A3qQDgRXP6gxTjDjS20CYmKuluSZ5El2AUP49DLpXYPyQLJ6a2CLiYfuVfZqG5Or2X1jwvms3hFHFqaQjP1CNcHANBq6tkiod1cBW6oggIZjNINsjFjSOYY6pj26esN7VYYl0lCfabQPPMaNvklrZ7cbSNZ110Jy/n8BfrODdzfL6kL6hW3uUdvyaq8UQ4gEwcuJgsHM0RF9BXgbpwA9mEzmF3k1z0U45RiZedMl56sbmY1FETCktgFnhNJi4yoGjx+oJflZe3FQ2MBDcs9bCsAu/L7xCk6OmvJs/Ahroo07C88uhw7kAN8CwTv9eV+5S8JyjwZQMQ45eirSzz0EQBDQFS3MIYsiwCNqtCC3u2pE4BQomwjA8nfa6PWDIsDwaTOtEKm8OrigS6fJMNp/SX2LYNu/5ixVNGJ0tUKckEnl5TZb/ELrx9OiX+dBk/ewwkY/JBJe9ptklcDm7lfUM1mjQSomiAQhNOSqIdKOGw+Hq79WSvwNPrSn4VLPLSxoY+REiCtHnKbWmUljIZYPlqGvcD3iE7PTHYTUgpAU1A62+SVcxVIO2HRF4GnJ4tbes61eTsLGDynEjASQ53bZVqrIXFDh/e8gLo0NkvHXuw//4E8LpNSW8Mo
 b7kHUQVR
 2ZtGIgKmVHeNyxV5xB3mJzViVehI1UfKRvOkYrEy460+ULCGIqYB85yw9LfAXYK/2NFIBcoG3VaW+fArG7XOyJHmQ9QqsHXMfLLdrQPstzdyf/cjVh+sJUxg8AJDPX4HmUdwb8A2ciEiSRyQo+xXAaA2U5EIdN8124R2jaxzidg6g/y7zy6MsBDl8ag==
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
---
 mm/memcontrol.c | 51 +++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d5257465c9d75..2afd7f99ca101 100644
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
 
@@ -3302,30 +3302,17 @@ unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
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
@@ -3340,12 +3327,6 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
 
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
@@ -3862,9 +3843,9 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	struct obj_cgroup *objcg;
 
-	if (memcg_online_kmem(memcg))
-		goto remove_id;
+	memcg_online_kmem(memcg);
 
 	/*
 	 * A memcg must be visible for expand_shrinker_info()
@@ -3874,6 +3855,15 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
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
@@ -3896,9 +3886,10 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
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
@@ -3916,6 +3907,12 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
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


