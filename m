Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B221CE91297
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25BF96B00B0; Thu,  5 Feb 2026 04:03:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247616B00B1; Thu,  5 Feb 2026 04:03:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1460A6B00B2; Thu,  5 Feb 2026 04:03:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 03DC46B00B0
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:03:26 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C69108B9E3
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:03:25 +0000 (UTC)
X-FDA: 84409814370.21.3A5D8B6
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 862EA1C0003
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:03:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hQCrR19f;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rymsx9n8FiJjOLGrnYBXKfgUUaI2hrPCz4qLX634Ge8=;
	b=nAwoi09oShZW+BTKRODTkNvzKTug1dqiqPSxMuA98a8ao/OhZjGIfcN07cH9GZxaBvyon+
	VmYE4I9LQqTYkUDOl2hz+0tmtR89KIm8bs4Du+IA9cXGm+JkQ0hv6qXtlD4cHIfY2ypYaC
	qt/2/sqMMlPt1t6J5O8DjCgr06olNqk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hQCrR19f;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282202; a=rsa-sha256;
	cv=none;
	b=F0yHnz6i4tP75w5VIiGaQbI5viFtk6st6qiQc1Ij0WYhKlO/jvA5mEeKpf2jVu0Ed+X8Lt
	AL7nBi5Yibj4Q/enUr2zBjTKlBClV1OU+1tubaG6Pwk9FuSZxq5co4j9olCxCuCxJjCldy
	GHzReCdHTUtbnhtKaVH5UNfaQvtG4jQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rymsx9n8FiJjOLGrnYBXKfgUUaI2hrPCz4qLX634Ge8=;
	b=hQCrR19f0i2Egt2nWZppGpBxNLvxWUCKjyg1PYtrd6EU711fFhmInF8q0TnUZhNORArIzB
	23EQ4PhTbsAnkUgYnyZIna5FnllNvjf4wqyUm5sFTAOQ64J4LX0JJS94XPIrJa5rdcaCf5
	RyJOeXjqDWc5gdZ1jDx2m6pxKYBnGSM=
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
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 16/31] mm: workingset: prevent memory cgroup release in lru_gen_eviction()
Date: Thu,  5 Feb 2026 17:01:35 +0800
Message-ID: <db6c6e1299496e53b85edc4e0d199b9d0c53f7c2.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 862EA1C0003
X-Stat-Signature: pz1r8gwmjeajwgkm8p7d1d99imrosk49
X-Rspam-User: 
X-HE-Tag: 1770282202-742415
X-HE-Meta: U2FsdGVkX1/QcLq3tGbp7fBd5MnzXN1TcTnKm985iQSCV4ZhJuH/5EswfdwmNBbrRDeUjezTO9z2Xvo15akMUNZnw7IrmaWQBmcGQzwKn/PvT+P0YFVde3fzemVqzq9Ku0RIKM8i3UG5lXRjXfh8z1xv+GeptSwLhauUh4HKpcvmeX4yLFjQy5GH+lwYH4CkO/vL/o3jDO9bfZZZWKId3oeagJDWhXd9XoaQ0aNvik10uQ1Q2glLmkX9Tgdk2eCYaLVd4Qm9Q/RrOgLIK0NoTsh/+Xx/ST37Xc/jsJV1+5ljva40xkjC8I/z9nXWxA92BJS5tby/a/ho/pO+396slDjo1o6j1uedL+BuXWbDJIDwF+P2qPVneWGiULQJ+EmyTipyFt7OUsVYPVcDOT+hv52jFK1v/TYBfTRw7ZuCdnou49XlSGRjZuW3djBIYXVtlyQLzkjTF1SEzpul9RQUBwqV7MYhB8hyuuzYH8tk4kCqoOI1wXEzp64BcOV2TxekntOt21wS0j7jael5mo6PSXgP4sw1H4Hw9nWyIrFTDH9tdpLIHRjcweweQrxxEtbgM1dNmsp849AUqFGpfJl4wAQ1p8qGDkVbS3hhVxaa18YklraugxBreWD3u+TKeg8eP8r0GfDmQ5Gbe37I04Cgb1OkE1b2nwyBJurRgtcXluwN1v9wWkOw8MNvMHpe/LyL8FUjqnwZdh5hl6xNqxaH/+4z8Y4qOsPOcy/XajNDplus7NcDbsQH768vHxhEtQG3iQYv4Mc2TQrmRqO3KbPtPjB4WX5XFW8mDY1RfaogiX92ErOMNchAy2MfCpsNatzmyTFaAW2NGcmCW1szoLpTNkYipwYlmZSnBwYS2nv1hDSbwQVgkVP8CClvfO6CNIuLw/HoET7reKlniMTIp3IfTQ9IbaL0+yg28taELCKAIx7KyttiyhFPkFWRR8raq0ct08JkrMLEWC6tTrgFw2c
 NUkKagj/
 7GxaibS5446chO+okuyJfPzCjoc2hXwluz2INd0Ed3k1OOZ+jK/3N7bNJC1Zv5/dtPrKvBHe7RNOF9MfB1ed1HA4RovqYzltUFVlDFiq3SWT3TYmfmDpGRphZWBXdvzIM4kpPdKA151VGEKbVkSOy1oy7dqPP45BT9VD4vouMTjR0SUSl81n6DNFgpXzNMGATHR81WzF/vCU2g1ANo+TlFhhNAcz54rJRbMfkUN9QGUdpwVpthNLe22PlTVynI2QR8gHFXC7lryfDlKx97dQebjXQUbet7bX0XaUFtI1fwx3LQMm1FPFMinR+Ew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard
against the release of the memory cgroup in lru_gen_eviction().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/workingset.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index ed12744d93a29..79b40f058cd48 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -241,11 +241,14 @@ static void *lru_gen_eviction(struct folio *folio)
 	int refs = folio_lru_refs(folio);
 	bool workingset = folio_test_workingset(folio);
 	int tier = lru_tier_from_refs(refs, workingset);
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg;
 	struct pglist_data *pgdat = folio_pgdat(folio);
+	unsigned short memcg_id;
 
 	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH > BITS_PER_LONG - EVICTION_SHIFT);
 
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	lrugen = &lruvec->lrugen;
 	min_seq = READ_ONCE(lrugen->min_seq[type]);
@@ -253,8 +256,10 @@ static void *lru_gen_eviction(struct folio *folio)
 
 	hist = lru_hist_from_seq(min_seq);
 	atomic_long_add(delta, &lrugen->evicted[hist][type][tier]);
+	memcg_id = mem_cgroup_private_id(memcg);
+	rcu_read_unlock();
 
-	return pack_shadow(mem_cgroup_private_id(memcg), pgdat, token, workingset);
+	return pack_shadow(memcg_id, pgdat, token, workingset);
 }
 
 /*
-- 
2.20.1


