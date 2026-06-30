Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BADF7C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:30:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33906B00C9; Mon, 29 Jun 2026 21:30:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE3F16B00CA; Mon, 29 Jun 2026 21:30:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB556B00CB; Mon, 29 Jun 2026 21:30:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EBA56B00C9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:30:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F3D891402BB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:30:00 +0000 (UTC)
X-FDA: 84934847760.24.551C60E
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5A03340006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:29:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jszc46Un;
	spf=pass (imf11.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782782999;
	b=IwNzhIT8w3PfqbArK2IDzTchpZQHtSVMbaHVOHglH4LGChX7JrHkvC00Tk+Bq/WmFbhJEp
	uSmCJcbsj8povIzoHEHu9ycOi9S6WOMXuK2+O4KkFN72nc9pcsIQB5mSk1noKkytcqfBhR
	1qZRlfkn1+ymguNt6cCfq3NAmi566Fg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782782999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sNMKfSq2rmG4Tk4WWqhPVEGirGb4v0bYHt6h2drRT1Y=;
	b=M7hgjI68ZZ4x6TwwZzeRUgRDDroBVC7Fjv75u5fShwHikXEKqspXfV//FSNB56qQRIPT8v
	/7t6dv8HIq0hyVBkUwCOgSW+W9eZeBprRjcAphEtHnvGjKg56e58uww86stwqGqKJ6/dBQ
	bSZaljw3E8H1JIwQ7wc07ZLBQZcIiKc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jszc46Un;
	spf=pass (imf11.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782782997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sNMKfSq2rmG4Tk4WWqhPVEGirGb4v0bYHt6h2drRT1Y=;
	b=jszc46UnWBKJ802otRkO/5UZQNkUddnQJ9ptKfEgL1K0FluYSyc/NeY2+PMS5KLYXodKyE
	EKseZFhOVvRVUt3u1GyTV8gcFigA3N7nO9AhQ5ldaJ4KmbPdIfGuVAxHmzGMcDTYXjOXvX
	LJUoJ0SbQcQPsYoct3bDxCkxemu3efk=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: jiayuan.chen@shopee.com,
	yingfu.zhou@shopee.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] memcg-v1: bail out reclaim when memcg is dying
Date: Tue, 30 Jun 2026 09:29:04 +0800
Message-ID: <20260630012909.144372-5-jiayuan.chen@linux.dev>
In-Reply-To: <20260630012909.144372-1-jiayuan.chen@linux.dev>
References: <20260630012909.144372-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: xssfufnhpa1ijcxtuuqjkr8cstk3ajyu
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5A03340006
X-HE-Tag: 1782782999-812015
X-HE-Meta: U2FsdGVkX18CH3YBHMNgpG66OK0aZquFxkp9EnCxHlCzf3Ow2H2tfG5kjFwj5/D0Anb+QGl7gfWpbT2qtyPzGjVMXXS9O4JoKPgdMLM8IXlKGsAIjqppwz42zkPtQEhqu/TT9ifpsDmNt2DqpNnzRL5CNzP46ujPFaVIubUXpolPmknTYxBHSjVfBEkE9YciUBBOEONoiyXGhHnf1jo++g4KTTKTWi46SUctpZPwrVnH5vVDquy5x2pdxFkt1OOLDrhwuwAK2rLxdpbGm/lwFEWuMLyMUQU2nYdV86RsKPfN/+aK7hQSsHSqMP7leqQT4QImGa6oRCjDMoroAmnLLWQnuh9DscMpEkUjpQHV0R528XyKEiSbYoQhJAToILcu1X5lCk6Fja1ItAAPfBGB5VR/dlkNld/93yzr+U6FBAwqnxj3+V1ojjCxTK50ROYuQylW4KITeY19jKFgA/ZiLHCsNbjVER9BvLa/P6TBGpM5vvGg1bq1hO6Ulc1OBBZ0Hs/1sA5/25qJxAbfXeUq4/ZydNjpMTZxRaVzH0lKztq+XuyM7ZxclsVSrNwnmRU8xyDNckItlx4ICKRvX3hjVP5/bzdeundFJ6JqmcbPM+gcz3dCivmQ3r5dZ6szGrbfy6BVYrF8jPrB4fIWgnFWy+UijHepGZuHOWtqa+0w409A2L6Hn3RVdfHDkLCpgCk19wXQIKsc/4bPntOk+qi0F1FdeEJ47F8OBs36BqPOpsWYNSHtQdffkWsIAO5l8EVbxYJinQAraJCDe5HtjYIs7dknOrEfnrjO/3MpjG4y/321MRsWg0PndGd/g1AEXXLVZw7mGMaOcsnI8oYm3W+HHJxkmKWAs56/d2LAU+7s8Z1Sfyv+G828yrA4qKZDLRp1i2HzOEd/jIlWc744UE+1BoS0IKSkVgcUtKNYWHAKvPCcQb/z68tkBtcFDCA9cMcYMaGpSrXlneHNilT1uZQ
 Xr6QHIHv
 F9BcTqNwykoJz3xmqECnNjB4j/g3+SuMe1+Oa6eTrUxHCPYRxDI6h7DIMLWaSnSrJnrCGcwuf3l4aPGwM2s8riqsqo+wEsQ7io8rOeMnNtE88e2aUIFIAfFZLWNhDl1w8EvKJNkWPfcwX3oj/4PXdZi2pnH777qUj5jwYmcesjZOOnU22QrP7zzFvMAXWv3/IOtlf55V8HGuJ5q0N8yYwnSfOOJFXT7qZKlXyL6l8OJpP3PaBnTbmQH+JmDRqLV8N5+LqyWkbQoMIuWuH83/BlZrZ/Mx4i8El9eDMwEJ6qJesvRE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

The legacy memory.limit_in_bytes and memory.memsw.limit_in_bytes writers
retry page_counter_set_max() by reclaiming synchronously in the writer
context. memory.force_empty similarly loops in synchronous reclaim until
the cgroup is empty or reclaim stops making progress.

These writes hold a kernfs active reference on the file. If cgroup removal
starts in parallel, the remover sets CSS_DYING and then waits in
kernfs_drain() under cgroup_mutex for the active reference to drain.
Continuing reclaim after the memcg is dying can therefore delay cgroup
removal and keep cgroup_mutex held for a long time.

Stop the v1 reclaim loops once the memcg is dying. For limit resizing,
keep the existing -EBUSY semantics when the new limit could not be
installed. For memory.force_empty, keep the existing best-effort success
semantics.

Reported-by: Zhou Yingfu <yingfu.zhou@shopee.com>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 mm/memcontrol-v1.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 765069211567..ad23de985d9a 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1513,6 +1513,9 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 		if (!ret)
 			break;
 
+		if (memcg_is_dying(memcg))
+			break;
+
 		if (!drained) {
 			drain_all_stock(memcg);
 			drained = true;
@@ -1551,6 +1554,9 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 		if (signal_pending(current))
 			return -EINTR;
 
+		if (memcg_is_dying(memcg))
+			break;
+
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
 						  MEMCG_RECLAIM_MAY_SWAP, NULL))
 			nr_retries--;
-- 
2.43.0


