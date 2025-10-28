Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EAB6CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C97A8014D; Tue, 28 Oct 2025 10:02:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8532D8013F; Tue, 28 Oct 2025 10:02:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71B968014D; Tue, 28 Oct 2025 10:02:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 597628013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:02:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F0EA087D05
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:02:11 +0000 (UTC)
X-FDA: 84047687262.13.4E363CE
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id 226E0C0005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:02:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m5pB3ZWQ;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=moQWsyM34kheODhB4m6le5EmBuxmXNZC4RNHBl5yhm4=;
	b=bYmpBT9AO4VRAbar7mYvs6PgU4QoK6lNtmIU+bgC88K+IRIYohwR7VtCvOCFKYUf2/MN0e
	A3vYWnz+1g6kU7wXTP5z91661lEcp+JcciwC364GgkN/LOGfRIg+6bck82LvZtD7qQy2sr
	Eqv3A/yIPcA5kpPGDowhDedui9AR7pg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m5pB3ZWQ;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660130; a=rsa-sha256;
	cv=none;
	b=kzAN6VBH92gygdbkJwhJHhCz+WEZemRCChvSkFGXl9wFadRvlsaIVmnwqQT8l3K1Y3m9Po
	DAve2IZjeAQ8LAiiuxnTkgJ8T3iqwq9oHDR4JTNw1tcCD9rQh7kerMSGO7C2i+X84mTRYw
	F9heZ6gwZKV1Ie6ssMKuuwruxCKX5ZU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=moQWsyM34kheODhB4m6le5EmBuxmXNZC4RNHBl5yhm4=;
	b=m5pB3ZWQxP+sPvfEGsIWUd01+4Ud8CDRin+yJXxv+vXSeS/tvgW6+9V1cnAIEUEP3kL5MZ
	RaHdbjXmDsivF+rDsb1cYJID3SmV1vSRE9OWuD5IA/+/ky8Jp1kroJNOvTdF4t7i7+aH52
	RZkxvRVNH2wWtx9OLxFAJtiTkeNOIqU=
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
Subject: [PATCH v1 01/26] mm: memcontrol: remove dead code of checking parent memory cgroup
Date: Tue, 28 Oct 2025 21:58:14 +0800
Message-ID: <b13ff669bc3f52922e97fa0cc99e54df05585810.1761658310.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 226E0C0005
X-Stat-Signature: wmnj3jefn6u8a18aetssgidnxfeyacc7
X-Rspam-User: 
X-HE-Tag: 1761660129-36823
X-HE-Meta: U2FsdGVkX1+iWIS+yxAywo5esyQgV+mQC4jbirFh1Egcb4WpR0kQP36KCFWZgjzEHGlWxQlAwmyJKEDMzUVS5UXceSwriHkAmL1QvCrtAp07nIIElOdDmDjBG66DmcDQVc4VW6AQX6mk2HGh6InYjd0qj0igIwg98xncsHp4Ifw3oDrDi8/We4S/QGueVAjmNjUjY+1BwePInXZ5wJTabr2UC1qJhPMLX4D97jQ9TLqq2DpXuH7eS90qH5kpXZUMeROZXjhg8WdgaPFKOl5m9j95b/dgwbiTby3yO2w8YkpAn+oMv69aHr85/owPeI9gIaCs5yh1yfSZmsCzqSX+kuBKx2TewsieBAi5w8qbbtQzKrJoprwA91O+VY9DGvvRZGQBGWPG6n3MtiBswT3LOeuSSWXSfN+DF09Gix7RVB/LzmsTH5py6ccx7VCcXiPYJyO5VyMLSdTDzYkDHS3Ikk2iJe7OlQB1+Y4LMAzTaFZM7ANXj1psKDpaBNizxCRwypuO22IQQXAngRn22GlzL6gvBSO5170kOdX99MOyfiN5quWOeh/RrzKLS1+MjWpG+UmoPT866rpF6hAGLsUb43UmCQ/QfoF+VykOJrlCwGh63yo8dkt4Wkjdk+kS9gbKpj8OmHZIKzDLN9esZuk+QMSG6q9hMDI4B0e/SphvN60nZMQmHBwbG/20OWa2sqMrdLfRq65pQK/LAWvlEmLggRKJfquoAkfbSN52Mi659UZYUfrVx4PJGuk8m/yfyGSal9z8cJfpQ/+/X0ivn8yoSqxf47HDX5ZdKcawB8aNQcrWwqmul1Z2Bu1/oa65AgObskYDO/uuZac/UXDVaBIgCwtMJUAsgQHehoEA2Te+eRCTzAkzk17BuCTcL2sHxK6mV/MYY2VNElqvdFfreiMH1PxUu2WO5cQxqueWPHUDcE9HeEsw5zBeyJDh/bv9iyEU66TPmEmqvxl+tL7Nj23
 jbgM66VB
 2WNhxACd63Z/mYAqpwFi1hQ7qrrvCiBORmegaQcTcuR39Ou66UaU2rNZqrAAjmPXVhGaOs02wy1/yQLZnHbc1KI4jx4+G+eSC9bpf2QBCZSD2CvFp7t1OAxGO3cZPk64Bnylx6Hy9knEdDAfKSFtCNgo1uHJ36mfKFFGazZuniSJJxZP9qWEr7DgIXfTo36F/2dkmxwQomLZ9FoEh4fSIMB2CEY8plMYKLuRfVDqiT2T9ytjyTj++LyV7cA==
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
---
 mm/memcontrol.c | 5 -----
 mm/shrinker.c   | 6 +-----
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 93f7c76f0ce96..d5257465c9d75 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3339,9 +3339,6 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
 		return;
 
 	parent = parent_mem_cgroup(memcg);
-	if (!parent)
-		parent = root_mem_cgroup;
-
 	memcg_reparent_list_lrus(memcg, parent);
 
 	/*
@@ -3632,8 +3629,6 @@ struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg)
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


