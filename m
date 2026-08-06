Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB48CC55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 06:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAB9D6B008A; Thu,  6 Aug 2026 02:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C35606B0092; Thu,  6 Aug 2026 02:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD62B6B0093; Thu,  6 Aug 2026 02:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B4E66B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:18:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E81D31A0687
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:18:47 +0000 (UTC)
X-FDA: 85069841094.09.02496E6
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9095F20002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:18:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AQRwtam9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785997126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=P+ldPohuWQENIni4PGzfc5Oh7ThBEFWNMfFXg+P+C+o=;
	b=wceY70T86EH7zo0xj9zF9cwizMbMgKVVr7HsmN2D+BHxmPct9i+M8mkRDjoNa2kK664PtF
	2N4nI6sBY7odQcns+7Jn5cSpfz059R/qsSjGFr3TNKsqkmGV9n07NgYDXhVoiBIu4LefDq
	aFelDSZ7s7CCIVNkj0qtxY3+cwGU1K4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AQRwtam9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785997126;
	b=7CTqleXsQbpJgpQPAFIyG997XFjdkOsMbxbcoYvkVWeDWLh0QxrMPR8iyxiD6ryG3pkx4m
	Du8nn7QnxzoCxt3fzQa45EwWzBnMH6CylCjiNF/hns0iMoHoVTgtDpKOfhNL8nFTZ4RX2Q
	SVir07VZe/WRd+6BeUhxzP+a7kuvyik=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785997122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=P+ldPohuWQENIni4PGzfc5Oh7ThBEFWNMfFXg+P+C+o=;
	b=AQRwtam90kkDWgMb2odt6wcpqyfUKxMWoX9Vf7r6aS+bJeteNNI1oUoD9fT5pM8scVRXzb
	dldgiO58uE7+sjGs0S8NeJ+dkK+wCJRVMFGqqCg3FI0qWMk1UdGBitt+IvvJo9d4FQ5QHr
	m35uRuWc1EDZT1/STIfrFRsP5pBmYqk=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Karl Erik Hofseth <karl.e.hofseth@opoint.com>,
	stable@vger.kernel.org
Subject: [PATCH] memcg: keep folio's objcg same as its node
Date: Wed,  5 Aug 2026 23:18:30 -0700
Message-ID: <20260806061830.3294679-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: n9a1pozdqbq57zsbz14k4u7o3p6kgbim
X-Rspamd-Queue-Id: 9095F20002
X-HE-Tag: 1785997124-980995
X-HE-Meta: U2FsdGVkX19/gzP+eGnLZ3ntlsotJ1I2X2Jcy7euJP0iaezJLHNL0bMKhTYQ0WDWEdmjPPDSk93O4uaAsF3RL3Mh6EDKc0ayiuxslyzsCpDx6uGPWOglngieKvt3JNleJGqpPr3lj3AherTVUc6v+f3OqfmJwkia7mPxzOBt5OdI6Jst2ih8dvd6eVGQrfL53YdYjbk1gRGX4MidtT97toJQAGwJO1rVdrXYX8x2mZhc2I0fftL7QPfmlr254o+5Qhp5XDxe+S+NRzarXDdKeQsdi59IFHu2ssppQYmJF+E5QcEqPyZpS3zusSRm7WIZqv4JtwcEDzuAmsxjHF5sXF01h4gV+7hcfA/530OLk4wMAnK6PNjoSfyFKlHrrf/doEDeSA6LGtjYFKlMnyTRBnJnF21y/TiUZxjiPR0bc9wksYS8G90wQSRt5ovqQUHXPO8CRW5Ei10gQgVSMvlj5ysFF4g0lYD0bR/N4Y7noNmaN85XwMf9rUBtXxJ4spYEzwDPiWI33reovBBiX9y2xIClL1nN6iPXP0WLcwwPZMBbTIrvWozA82SveDQsE4IWukgbGEbREIawWrjCgARsfwyp0PbOhhQK0X9XfRunXOL5cgc1fHdHY09jV4jSZF8cg3yJZoIAqjJIUL8awHYal9poTixF69LaP5lFZKN9E85Lyz2QrRZ0Cx3l/xaRnjC71Xy6WORjjSrsFtuUHAgy+mWzyIMI4wSxa9dPtCDAZwRBI0NAkwmD6YBWh8ZEjrVLOwu2b9kNHVAB9ofY7+NykjO+eT7ugPWKR+WCUvZ4vFJAl5QwXslLj2cIUDYq9oQS/5jIimPQ5vm1BsywLt4nLwds+g8pMmfHrf/AfApLGLNNehHW/DuZcixylUPFwMcNn6OczB2UOxBfgIeTi41HgA+bToW4uRlmgifmX1EdHed8YEidUDDe5NO05luPDt1gR6GV7hQfapaNbQxgXqm
 HphFKyLT
 MQURsc+777TXBXs66JrtA6aGrgQdrtxojoBuh2PexLk8ODeBlGJ8SFCFOc8TndEZWrvVHWLvWKMMSHpAS4+lJqLa6cAMhyOAompvNeSWdrrsF9UJ2SFflz718CdEJ8bl2LiPyWhEYDGBiaDTKRj72YACvKvdmodQXhMH3o+bZh1McRFA+/MfOr3WGUpA5YQxvq9j0DBjuuavlvPBjdVfiHS1ilaQw+wxL2O3Y9VKSwQHtqPiaN35RouDyHNiX6BrKXTVpoT6YvPkzZr7tkSqlebnsyNstVF80bXa2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memcg_reparent_objcgs() has an inherent assumption that a folio's objcg
is the objcg of the folio's node.  Folio migration across nodes breaks
that assumption: the new folio simply inherits the old folio's objcg
while living on a different node.

Once the assumption is broken, the reparenting of the folio's objcg and
the reparenting of the folio's LRU list are no longer atomic.
memcg_reparent_objcgs() handles one node per iteration and drops all the
locks in between, so the objcg gets reparented in the iteration for the
objcg's node while the LRU list gets spliced in the iteration for the
folio's node.  Any LRU operation on that folio in between resolves its
lruvec through the objcg, and thus takes the lru_lock of the wrong
memcg, not the lru_lock of the list the folio is actually on.

Fix this by selecting the objcg by folio_nid() at charge time, and by
re-deriving it for the destination node in mem_cgroup_migrate() and
mem_cgroup_replace_folio().

Reported-by: Karl Erik Hofseth <karl.e.hofseth@opoint.com>
Closes: https://lore.kernel.org/all/anMmd1ADrDVwMO6v@work/
Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios")
Cc: stable@vger.kernel.org
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3057396dda53..2e98788dc8bd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2966,10 +2966,9 @@ struct mem_cgroup *mem_cgroup_from_virt(void *p)
 	return folio_memcg_check(virt_to_folio(p));
 }
 
-static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
+static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg,
+						      int nid)
 {
-	int nid = numa_node_id();
-
 	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
 		struct obj_cgroup *objcg = rcu_dereference(memcg->nodeinfo[nid]->objcg);
 
@@ -2980,12 +2979,13 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
 	return NULL;
 }
 
-static inline struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
+static inline struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg,
+							   int nid)
 {
 	struct obj_cgroup *objcg;
 
 	rcu_read_lock();
-	objcg = __get_obj_cgroup_from_memcg(memcg);
+	objcg = __get_obj_cgroup_from_memcg(memcg, nid);
 	rcu_read_unlock();
 
 	return objcg;
@@ -3029,7 +3029,7 @@ static struct obj_cgroup *current_objcg_update(void)
 
 		rcu_read_lock();
 		memcg = mem_cgroup_from_task(current);
-		objcg = __get_obj_cgroup_from_memcg(memcg);
+		objcg = __get_obj_cgroup_from_memcg(memcg, numa_node_id());
 		rcu_read_unlock();
 
 		/*
@@ -5197,7 +5197,7 @@ static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
 	int ret = 0;
 	struct obj_cgroup *objcg;
 
-	objcg = get_obj_cgroup_from_memcg(memcg);
+	objcg = get_obj_cgroup_from_memcg(memcg, folio_nid(folio));
 	/* Do not account at the root objcg level. */
 	if (!obj_cgroup_is_root(objcg))
 		ret = try_charge_memcg(memcg, gfp, folio_nr_pages(folio));
@@ -5431,6 +5431,7 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
+
 	/* Force-charge the new page. The old one will be freed soon */
 	if (!obj_cgroup_is_root(objcg)) {
 		page_counter_charge(&memcg->memory, nr_pages);
@@ -5438,7 +5439,12 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 			page_counter_charge(&memcg->memsw, nr_pages);
 	}
 
-	obj_cgroup_get(objcg);
+	/* If replacing folio of different node, get objcg of that node. */
+	if (folio_nid(old) != folio_nid(new))
+		objcg = __get_obj_cgroup_from_memcg(memcg, folio_nid(new));
+	else
+		obj_cgroup_get(objcg);
+
 	commit_charge(new, objcg);
 	memcg1_commit_charge(new, memcg);
 	rcu_read_unlock();
@@ -5478,6 +5484,17 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
 	if (!objcg)
 		return;
 
+	/* If migrating to different node, get objcg of that node. */
+	if (folio_nid(old) != folio_nid(new)) {
+		struct obj_cgroup *old_objcg = objcg;
+
+		rcu_read_lock();
+		objcg = __get_obj_cgroup_from_memcg(obj_cgroup_memcg(old_objcg),
+						    folio_nid(new));
+		rcu_read_unlock();
+		obj_cgroup_put(old_objcg);
+	}
+
 	/* Transfer the charge and the objcg ref */
 	commit_charge(new, objcg);
 
-- 
2.53.0-Meta


