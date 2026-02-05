Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7F52E91298
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 08:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F6CB6B0092; Thu,  5 Feb 2026 03:56:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A0846B0093; Thu,  5 Feb 2026 03:56:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B01A6B0096; Thu,  5 Feb 2026 03:56:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0922D6B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:56:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B17161C277
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:56:40 +0000 (UTC)
X-FDA: 84409797360.09.D2A5EC4
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0BBDFC0008
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:56:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LRkYdPgJ;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770281799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dwQ4ivLYmtr2b7Y96V9uq4Z1sJnMO6h/66mf7WpDnM=;
	b=jczaFeAZeEfmni432f6EdjAsdd/RTOLUI+n/wjE6dmyJf3wzLXE17NCLbQuP2orqpUTXgC
	XBtQnxvh1fTE8J0NmpFLEqHbqDi1nYdYXleUyGH2puEXkV4HEC6LWYrapf6KSgQ2GNi0b0
	8/W5bW/+qBo0uJhc8IBM145PEeTZ/+Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LRkYdPgJ;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770281799; a=rsa-sha256;
	cv=none;
	b=nd6yiP7l+iD4ntUNC0KAqUOufJ7WmfA7bBP5kAq4dojA5q/M4i8Isz7W9Sq+DiewR2laMt
	9Hcs6lpJlnQKD4oxrZCdoFwhOmeKTHEAAx6+iytu8wfLEsxYai37YDUD4z96jLbzPBbjVS
	VJeZvXZO0JQcU4iDCDqm0Hhusk+MZ10=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770281793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8dwQ4ivLYmtr2b7Y96V9uq4Z1sJnMO6h/66mf7WpDnM=;
	b=LRkYdPgJMCg2yjFaMTf80KajUiQErFG88Y0kog/cwdqa1bHO+OtW05ZgTqLE1/arPXY1+W
	aACjXS6lz59xu6WJtfOPo4K9uMb4WDVqi3NRU8Gi3mxXmwBi+NwA45b3uNgqLVAikdmjBH
	17tAzzirNBlIYG15ZnmxX0/A55Qm1o0=
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
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH v4 01/31] mm: memcontrol: remove dead code of checking parent memory cgroup
Date: Thu,  5 Feb 2026 16:54:30 +0800
Message-ID: <fb7411b67dc59eaecbbc1f769164d6786595f9de.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0BBDFC0008
X-Stat-Signature: 49hgrs88ox9dagajzkry465ukxbi1hgm
X-Rspam-User: 
X-HE-Tag: 1770281798-554471
X-HE-Meta: U2FsdGVkX187SkAon/e9HKYDJtGhOihPKdo6EAeoOzBnfKbVMjrp0bi//SucD0gvx0ui2RjqAkxfqIYMez+tR82JLaLOklSMC0eaWjDWa40GmiI0b/IktLutsPYeXX+EnWtI/xob4rldMV7TNz4DUSn0H3vUnhiEBhAoS7glDzLC2SfiDZHc6hmMGVM4YwF60cIUcjfND1NNaWL4Z7t935H8HbyXjTxaSHN+GmB9o05tUdBB6qXX47NugXMfcqnNZnv/SfgOPUAIYigVR6xNeGw+Ofxy/eml/88ZIWS8bEpNsiB5snxczBFvAjQjHc7dFbZ1Mm86ajDnShWhs4iUnDeYrkARlLRcAaoSy6HKdR82HmZdJpEVvBVLidD2G9IaGsoILeqzz5Cm7JQbCEXyKGXki3LS2kc+QdDUjMbUdKE6SSWxfIDRce5N58IbVR2XduO+SZdyQOKo4iHh/CyUr4lNYMDmh+iX5iSNiSAkTEpj7BDdF0Yh6jO8rDd6mhn3bsp6+iyZZZIkZyMqbHdQIt3Pz7JvzvByPjHxsoFMkZG9ntHJUpUAG+duixzAGSWQQBELUfzIfEoSi4PQpD7qEmh9WnFe29oa6iHbwNLF6Qp5U8x3ocbePi1fxdRq2olUCdWT0Gtz7FhkekuMGQAmNZ2/qL4oZs8jjNDjNv0550dMWw3EHe50dSy2RhTLK3eUwcDMWcFRrnrT8Dozq1KdqXOEgjzrsyZxM5Bts9KH39AKLoxWbsA2h9ubAEh85oAhT+6LQDl7XS3pxosdVlBEDHvHSw4/2XS/k/nedFpCLQcc/eBtUwttUknHm/kV1wQ3QUHhs89+KrtLVQAJ1ZTrQjBUkgAWfUVsBdBUyJLsFAlRE3421PZpEILcFoewCVXWklsT+fxZMLLcMzJ4wnUNebRYf8Qqyhscw90TG5plIt3YY4SGoMBeubr43jDVLL1lDGu9RlEsAxmnQUV2y0Z
 NDmiHkbl
 yG8eWJaTcSiH/Bm2eUQbXCg/D3dewT3DCKAOEXiWahU0D1OFieXHOb7UHubiAZLLf50hGltl/MdUSp6uc8kxxpHMVdoi/DbQVy2sWzCxtPl4u0mtGavbFEsefDIFqsabz9ZzpScOoRdSKYYhCoQQBP7ihrrrwIsGqvtUlRsUvesGnOc5VyFXicAxKu6r3P3eVZOxP9UgoB6xwphDLB43NrGCBEej509OoOjkhs/8UakjFHpnKCbquaHN9/Wx8mwIoaJHtco2kd+dYJl2znb/4x+YFT03lG6WyMSMO
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
index f2b87e02574e0..43dbd18150e97 100644
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


