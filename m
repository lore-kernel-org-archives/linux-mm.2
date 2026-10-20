Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90F62606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 22:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HRIsqgUU
Received: by kanga.kvack.org (Postfix)
	id A238F6B0183; Tue, 20 Oct 2026 18:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D65D6B0579; Tue, 20 Oct 2026 18:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EA766B057A; Tue, 20 Oct 2026 18:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB7C6B0183
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:36:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F6991C3A90
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:36:06 +0000 (UTC)
X-FDA: 85344463932.05.B9BF2B1
Received: from mta1.migadu.com (out-207.mta1.migadu.com [95.215.58.207])
	by imf06.hostedemail.com (Postfix) with ESMTP id E89BE180010
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:36:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HRIsqgUU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.207 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792535764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HodTXsgPBzIPYL+ZGw+MXUWqV6VcazjbsVd6O07Sa00=;
	b=Iz7i/SBY+cQ48Z+YHm3bVJtPxDa3b9Alo1zYJ/vQBbwudgjN3Dl4Z6zI1wEC5zXqArCpZ+
	IKnO8wGMdaJoEbwZT1mT0sZ0A01ux0cBc0cPi5wbcZPNWwjGzpDvkS2cBI7362lXfAh2eH
	hAkDTVjUZ+9/dzWmI0dsVnFURzkrSAI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HRIsqgUU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.207 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792535764;
	b=BH4h12k0gQ8eq5Imc5w+l6ltedx4AxgtyIS2qc5JdocwOwfhILv3yf3S7S8CyKRG/cV3S0
	tFbOehNJERaqTAFALjF/o74CtB1TIVNwk3vS3kGk/CyCH/1WreJ92rIedGzJq+fltu/dxX
	BxHsud7xxU8XE1D91uMxmHaTKYyUNJk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HbWlWrJdZDODn99IUscfxlxDII0g4fQaUHUOuuxABQs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792535760; v=1; x=1793140560;
 b=HRIsqgUUXhHI+u1+mlBVDis39gAMNR/0IypEohlIqm1xcyaLokbn2llHgMu7mG5b3f2HXKQR
 PFL6gcADN0refJuy6Eu0VxX+JxKt+P0nzgV1ma6f5+wS3+9cXQUgUS+mdOZDCSC++c85QfTPvab
 BanTvTpRdD+j9U85DrdfTlpk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f1fdcb3e0d7c102c;
	Tue, 20 Oct 2026 22:36:00 +0000
X-Mizu-Trace-ID: f1fdcb3e0d7c102c
X-Migadu-Flow: FLOW_OUT
Date: Tue, 20 Oct 2026 15:35:59 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1] memcg: fix cacheline contention between lruvec stat
 updates and LRU lists
Message-ID: <atfrhsr6bft4t7SI@linux.dev>
References: <20261020200730.250189-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020200730.250189-1-joannelkoong@gmail.com>
X-Rspamd-Queue-Id: E89BE180010
X-Rspam-User: 
X-Stat-Signature: n7pspg3kq61esf8h8ih3csxft5ftj1yo
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792535763-479237
X-HE-Meta: U2FsdGVkX1+NEmEMNd3cDoi1X0Vs9JWMgvz/zGOr49IpRcKyoKkGYU1KxGLQfHms644L+GA3S0jQWd2Ezpy+up6sImKnZ4C6sZcsPESTr1ZN0XMPxUdMMhdStrmXgjSNOWQ6LeM4Mri7Cb9n2fPdEHvzCwK5Q503T+PYL+arSabnCyPQJXVSFElSOKp0VUpBHiQT1KcZJk6Y6eup87sJe2es9/zQFlLjrRoQcIUgTwp189+TdYwVfY0H7PHX5m93ZFYOR1fdAuCg9iwFhK/2sj6Wt/8fiY2nK50D29DRPrFXBA4Ax9CBFCmos1UGJpvyxQWtxpZNfBN9MrNQ9I6JAald4WYINv4/pbd/dtrv3T2KcMtdaKVOpsqjLy6gs21tua6maJL3BOQ5HRR695Lbl58SuvmtKfQhilO9kcZ66v/OsciWc0o5pUPgh1kihOnVg9Bwj7k5+weEXVZ0lfuvoL8Jgr9A1UouZB5pX8kHawMEwdyO3jW+JTS9/RZAx8aoMOMaJR5ACklcXcIgMlqt2M1fD1T15d5gaxlomkeRUKyu/GHOIhV5FeLOLpSUYmEjBo79cemHAnpVCvYEHfILsDTXDxrcZEeOGVhpzmVqNjuNPWDBjonG50UqrY5rvDvCLz4gefBhJqfE5v5GAqi8pVOC34FRjOehv2di/LezDRwju1BSFJkLH28WsNt6EGNcXQKvSyOu6PrD84SapT9p/lVL2xAq9udBkZaFPklq0W6jmvLLB0SmaDwYD7y06Gckb6LXT1sTVaoOwMm2LH3w/NGPBZTfyJBmfYlmp7FyaHR1NxFF18QW/+n/UCs76E3gdB1cATMzOHla8bb2TePlkkpLNv5SOIgTTTKMMydg1dTDvvn62Nhc2YpU1fHDCBoUztlyH5XOPuQ04GqWmfbMKxyDNSd0PD0ZSeFXI0UjDeI10xTPbaaZ9mJoCfOtvCe1ZO+oRRx/ETySXJqF2tG
 eqIobxFD
 r71D5DAcUf7r5Hq/Vc+yAw2NySScTBZDcmzpYpWaDwTAXOCNeIYFiszXk8qrIZC+igOJ80G+UYA7j/f4I9vfRGvS9Jr7xn4Kxxo4wQvQ3jISRn3TSkFK4HZt2CzccQ9nYGUk3+Hu1fn8DxhQrlhDL3AhsNZxyF+dCiVeSBUlrgTBwpWeXHvCFPfN9zvVh1Kkv/9l9pbmnlj5zV3ln90FyZm3BCruooS2rMVr/13CHSFcLymlcmvjhjMKqfpls1D5DmtPpArxYoOynPpk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 01:07:30PM -0700, Joanne Koong wrote:
> Every memcg lruvec (per-node) stat update reads the memcg and
> lruvec_stats_percpu pointers in the first 64 bytes of struct
> mem_cgroup_per_node, and the ones that go through mod_lruvec_state()
> (such as lruvec_stat_mod_folio()) also read lruvec->pgdat. These updates
> are extremely frequent (eg these updates happen several times for every
> page that's faulted in, freed, dirtied, or written back).
> 
> The memcg_pn_read_mostly cacheline group keeps those read-mostly fields
> on a different cacheline from the lruvec, but on CPUs that do spatial
> prefetching [1] (which is most Intel CPUs / modern CPUs), cachelines are
> fetched in 128-byte aligned pairs. Depending on where struct
> mem_cgroup_per_node lands in its slab, that cacheline can be paired with
> the cacheline holding the LRU list heads, and the lruvec->pgdat
> cacheline with the one holding lru_lock.
> 
> When this happens, every stat update also pulls in a copy of the LRU
> list heads and lru_lock cachelines, which are written to constantly by
> other CPUs under the lru_lock. The stat update has to fetch them from
> another CPU, which is unnecessary overhead since the stat update doesn't
> use the LRU list heads or lru_lock at all. But even worse, the lru_lock
> holder then has to invalidate those copies and wait for the
> acknowledgements to come back before it can do its next write, which
> makes the lru_lock critical section longer for everyone waiting on the
> lock.

Can you please reproduce on a non-intel machine?

Second, can you try the following patch instead of your on the intel
machine?

From a747ceeb4e3f10fb0c3e7daf5660076a49b77126 Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeel.butt@linux.dev>
Date: Tue, 20 Oct 2026 15:33:26 -0700
Subject: [PATCH] memcg: rearrage mem_cgroup_per_node

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 74110a324f9e..0e73f5c96e15 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -95,6 +95,17 @@ struct mem_cgroup_per_node {
 
 	__cacheline_group_end_aligned(memcg_pn_read_mostly);
 
+	/* Touched only when the memcg is reparented or freed. */
+	__cacheline_group_begin_aligned(memcg_pn_cold);
+	/*
+	 * orig_objcg preserves a pointer (and a reference) to the original
+	 * objcg until the end of life of memcg.
+	 */
+	struct obj_cgroup	*orig_objcg;
+	/* list of inherited objcgs, protected by objcg_lock */
+	struct list_head objcg_list;
+	__cacheline_group_end_aligned(memcg_pn_cold);
+
 	/*
 	 * Keep lruvec on its own lines. Sharing them with lru_zone_size[]
 	 * regressed, see commit f59adcf59332 ("mm: memcg: add cacheline
@@ -114,17 +125,6 @@ struct mem_cgroup_per_node {
 	atomic_t		slab_unreclaimable;
 #endif
 	__cacheline_group_end_aligned(memcg_pn_write_hot);
-
-	/* Touched only when the memcg is reparented or freed. */
-	__cacheline_group_begin_aligned(memcg_pn_cold);
-	/*
-	 * orig_objcg preserves a pointer (and a reference) to the original
-	 * objcg until the end of life of memcg.
-	 */
-	struct obj_cgroup	*orig_objcg;
-	/* list of inherited objcgs, protected by objcg_lock */
-	struct list_head objcg_list;
-	__cacheline_group_end_aligned(memcg_pn_cold);
 };
 
 struct mem_cgroup_threshold {
-- 
2.53.0-Meta


