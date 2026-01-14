Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3C4AD29FEF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 167D86B0089; Wed, 14 Jan 2026 06:27:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13D926B008C; Wed, 14 Jan 2026 06:27:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05C7D6B0092; Wed, 14 Jan 2026 06:27:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E84C86B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:27:50 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A61BC1AD9A3
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:27:50 +0000 (UTC)
X-FDA: 84330344700.10.2A843A7
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0AE3A40003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:27:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SZlQyonb;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YuZ8qO/NM8znoBBhdw/uXBM5t31I/Z9zioYjWeQuJrs=;
	b=VoCu+TAHv4UFPL2J8a0qJosVdMzu5ZPsJzit/zYhoCqnMkb1LWer5H+A2GTAsNIEs7+Goi
	BoI021doIRRZLCRmsM+w6jSVjU8+Lq9AsXZN/Cxk8WSEDk1cAf74FalndtH3OnTijfem+r
	l+pzSuXPUUi/ShV+uy/MSfoPkdsoRxs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SZlQyonb;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390069; a=rsa-sha256;
	cv=none;
	b=y4dpD41V0ZOdLLZetXyga3uV65t6SVl4t/xWk58BrTE+Il+2yXpfJa6FHfDctO7QV/06Ob
	q2im9di+Tg9pCF4lTUGoIYa3sB0kYSUx3ITscLe32GND3vdtpj9+rnsS+HCFBkz21Q+c4L
	Q1i4A6R50Vq1ViipKSHmOHGAYJlohC4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YuZ8qO/NM8znoBBhdw/uXBM5t31I/Z9zioYjWeQuJrs=;
	b=SZlQyonb45fCebG0YQSYRpzD3FY/6UP6cIs/1wIrwWaMQbW2ihRA0cBTcI3QiMnOK88MFs
	BgFbkvVmyphkjYaouhv4utI+JLAKapBep2vbEbxCtcS+nM80eRo8L0Ma670qvEjvP7nBx1
	++6Z3C56HhaRTiG39atgCCDhVazg0Oc=
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
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH v3 01/30] mm: memcontrol: remove dead code of checking parent memory cgroup
Date: Wed, 14 Jan 2026 19:26:44 +0800
Message-ID: <290890d5739df2cb2d0e5a40e15f5e836fa65587.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0AE3A40003
X-Stat-Signature: usndzg9not4a33eau5sbq8q635164jk7
X-HE-Tag: 1768390068-430416
X-HE-Meta: U2FsdGVkX18w8cFOE2Hz6Lw8DfguDrWtqL7jeLFxuqjeqWEq0cJIHYKEZ6nplC79WHhlJUAhhpk7Et/otA8n/Sud7GjPGWDgTa9ZI9Xl1mbfcguIFZsmLidByRqHQl2J0Nx8GOKhhU56DMWTVsI0ec+IeMlWgIP/913DG2NGg2fI/8qO4Per2PCdxFcin08Sq23ZBhtpYlB1BhjYd39InQVEHxGubUzOYZZWjhRsRHnsFW6yPidRCjSmAduUdttiiPupaXTYgbCghhq1DD2G6uq10DcYGRwoK6B1krygZSnTMVD977AeAAnaZcjzKv+EGN3apglBEnwtkiJbBFTQ4B6A4qfu9O4cYtfameOcC21HZSyUhaG8qhsx+AHTfSJ7PbenqxqmInnymeCzh5xVixEq4yHKcDhgUriloK23dSJ16V1N1BqD45E+OQCD5MmOTqJimNWQrh0/e/0Yuy7p4oL0lld5d5GUO9Ta0tUZWUv8eJbCFxrqrxfTnP2m5Sl8IQ3qDywYR79h0Ssk0Dn7/u1sdgjKVujQBOIZ+DmyfsDS6NLRrl8uAEkeesOmCHaGNXZuqZGh3bcY0aw0lSghdclGWSEeXO2Co38J5TQTBzJcBefqSHfLc2IUnmcR8jpUw25IWAjsfbAFtIMfMwjXkRUVcWdXnqky2l/8+NMLxg4omdqmLukBIwRAtbPz2EW3ss2UVNlRcZbqEArFb20u+a4/IV5Xf0BDfhqTGnTfV8MA8YLOpM0RA7xYuReE8S2+apLv+Ozgsy3OcJP7hOkp2rVfbLg2o5yYWjkC7jX0igyJcC9ljTt3Q9a94psog5N68VtDrq+98+CYVPyqFga5moSshekTgTTv+rb7OXxQiDsaDQ5JsIy2ABb3kTwivsCIeTjNRZVmWA98buI1cXygw0jiOmvCDjoPm0dsUBTr7T8X5fbhNgXIDS/O2f1v0I1OahWV9ArOLSdTAiV0Pk0
 FSOwrJWg
 8RbToDlzkRJhW5uVd893TvYnqta+uGR2PRJi1P/nSTDRvSCsQxudo9EixNxnXLJnPwTpWwRp2dcIG6LYjSCfvYkWS4scgOMSeBe+FsVvcErot9Kg+Bij2e0uYWGHliunxXidsUA8X1FHNn9NJJIf7CYyjPBTsxKuu/sogRk8U+uARw94BQaJ14lW/tidO8mdVrD3XsODaABRbZFyDHrfHVIiEQrS9qhya54gd9e+BpqEnwbeh+QkbtTlYy0hGgbDkFT3brPYhJmLq7LDvO4Umxp5+1EW/BiJ1ZM9S
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
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 5 -----
 mm/shrinker.c   | 6 +-----
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f9455b4790ba5..c68af9fea0abd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3352,9 +3352,6 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
 		return;
 
 	parent = parent_mem_cgroup(memcg);
-	if (!parent)
-		parent = root_mem_cgroup;
-
 	memcg_reparent_list_lrus(memcg, parent);
 
 	/*
@@ -3645,8 +3642,6 @@ struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg)
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


