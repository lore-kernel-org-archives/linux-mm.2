Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14EB2D64087
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CBEB6B00AB; Wed, 17 Dec 2025 02:32:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79FCB6B00AD; Wed, 17 Dec 2025 02:32:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CCC36B00AE; Wed, 17 Dec 2025 02:32:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5B2756B00AB
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:32:13 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28DF013A7F9
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:32:13 +0000 (UTC)
X-FDA: 84228144546.14.4B25BAD
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9C622A000C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:32:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XUKaepUY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956731; a=rsa-sha256;
	cv=none;
	b=ZVyaqc6X8Fr8wZejRrbradQHwVCYQR8VBZseUXe1vXvLdeQexOM0S5iNxb/8ceHExFJ/Kw
	a5pfzytwDBYGyM0zVtINsvKP+c4z1Me2m+crjeDoy+wQd+gZcqEtIGWdH+Qh8AT+4cCstL
	KqR2nGtArTU+3+65Ga4fOR3f9vwO1ck=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XUKaepUY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vARDX0KlrHYxt2WGF2YuRlzAmZs3wCmu/kHd4dQ4hPc=;
	b=qCZIdaWOGsrwy5jVCqZKV+1NQ2ON84C+6jSJCa7LU1CFwzKtWjBicayD51M8242BW0TyMy
	iJFxW8nRA5gAuwfsFZ8VwM17AFI6XNzKvm9TFEBRWEDiZLtiQp0frOaJSSHhS9zjFJAe+p
	ErtE5nBiStNHZedncAzVDb4W4XfzOsM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vARDX0KlrHYxt2WGF2YuRlzAmZs3wCmu/kHd4dQ4hPc=;
	b=XUKaepUYVHa9QAIGaedmhA8z/fphq0IfY+wdqHSG9tqpDpuiKr7mrVJ5qM4Jr0q+YvluKS
	mB0P+UX+ymomQKAE70mACTXkZHOPx4AISxOk026ea+ZCNky3lbACkQHiu4x+s/cY2z19S5
	ky38UxpborhFk/pXqhAoVw/xPUwewxU=
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
Subject: [PATCH v2 16/28] mm: workingset: prevent memory cgroup release in lru_gen_eviction()
Date: Wed, 17 Dec 2025 15:27:40 +0800
Message-ID: <86b0573753db20e40315c61f5d6e01bdc6a8313a.1765956025.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9C622A000C
X-Rspamd-Server: rspam03
X-Stat-Signature: 8gmgdusa9y83o4t4xg36u954o7ha59qx
X-Rspam-User: 
X-HE-Tag: 1765956731-937386
X-HE-Meta: U2FsdGVkX18033Pipg0gb6wAMEq+k0ZTLikcXep+/TV3Oln3Eo5PyZE4y4GapbWsVVQWOufAPEW85hHeBh6HVyeOwDK6PUO6QoXFZLRPi7zoFD0j4LdB6GLkNqCV7EzTZi+6nt7b1SwrzuGbV22FJFKTZidbUDObqotRA/APrTavJFs1rjU0FJAqYHarM7knrnKs2Ml13OE8J3uuKKrw6CqbMFor6MpZX0fwNx3gz/BNoY1ZahSuu0pp/GLRXEDPoyILevaipCLMFC7zdVLkPuSwPUPFZxN+zeGsxMNn0FlxN+wv+Ozaauq5ldzwVbLnaWSuGM9FmtBp/EKuNfNyMVuYLBpeZgOcFJDhvJHkxnQVeFNC/PKXoCVYcNpmt0banZNhJgNS+tqHfVE/SG9AuaimPwu81RRfW3Gz/XCoHpAnLnF0d8cBByrYs/gOWPn60SeCnD7NKbCUTbnwX+KyoN6rAGkWrDT3Ij63FflAWW3cm5KAzASvmaoL+gr6tOHUxk84ZWj6qN0zu7oCsLe7mEA5jRIICuq+XDojMWH2uLU4lOaXERuMDOw+IM8/pj6jOJSTdbSj8vN5AOyDnZPVmT6iOlDFK5pZPjHu6kj2DlINLHiv8BRAPSnPXqzxIX6TvHSqP40Mb0sFVQU4+qj1zb7Ldb4+1gvR1kFo78nhh8fzbVUwNaR17wuVjRamjiSUlMkfI0RHXfRxhyQS5n+tWj/k6eGWc/claO06tCJMYmLxWPbAMbUVFYRhg0WX66RO3lljPHAFWuIoa0FYkAhiT+oWaq6qfBUvyHE44QsDzp4YSSb4OCvkRtaUysLSf7oxdkHh4MzvsGW5lzgfkuDU/UaZq4PCeUY8wjOhdpbEHFBWHwUI2HbMxmJ1ENnABixsG/00zl5A5iekIhSx05ijzp1IccbdJQtA
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
---
 mm/workingset.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index e41b44e29944b..445fc634196d8 100644
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
+	memcg_id = mem_cgroup_id(memcg);
+	rcu_read_unlock();
 
-	return pack_shadow(mem_cgroup_id(memcg), pgdat, token, workingset);
+	return pack_shadow(memcg_id, pgdat, token, workingset);
 }
 
 /*
-- 
2.20.1


