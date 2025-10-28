Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE5B0CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28A9F80156; Tue, 28 Oct 2025 10:03:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23B648013F; Tue, 28 Oct 2025 10:03:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DCA080156; Tue, 28 Oct 2025 10:03:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA98A8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:03:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9881C13B128
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:03:20 +0000 (UTC)
X-FDA: 84047690160.28.629D6AB
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id CD17740014
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:03:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Keb41diP;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AQ5H2mz4dVXx5yLN5zTg1jKj+s12XH2F8FoyP4DTscE=;
	b=UMTuSidKHPcbMHrANlAkgHvGFbBFFYmgFBuXfvrsQgAXTg4K8YpyVRA2iP8v1LoUgqtLTY
	72h9HeNJKorPI2Amz4hMrJ8o8prFTVRALoRjMTOvez5JvO48FqhQSZJiXfI/M8j0BzvwCj
	g2aH7ivuBPuQsSTs2Pqjp2mYfD0zjn8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Keb41diP;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660199; a=rsa-sha256;
	cv=none;
	b=sdnmopS4OtM3yrrmoMWgYzEAEztehWf3kcGLYdkCCzW5W0uCjCzAP7gk2pUPjEHqTwfb3a
	CeJ8y5pK+0+2QTKwMqKRPKUEHLmLyr4WnVlwazZ/71Rn+kYkYotUqI2H9fBMWoOvYXnpHU
	85lYLVt8UHDKfyCPLf41YvPRPc9UZ18=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AQ5H2mz4dVXx5yLN5zTg1jKj+s12XH2F8FoyP4DTscE=;
	b=Keb41diPvx6YSmv3KjV5tfMFVwgCTvM3vVnU5B8tPPTriLp0WGiAeHuYMTVXp2SxD5lxBu
	33n4iaxgrmdpRj6MsPU9h3TczXEoHjcIiBgf6j5GU4SPKcdnBad+SPu7i363kDDpf4bSkC
	3R2eVAJrKlZIF4uljuyHmUYjf+6rNsw=
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
Subject: [PATCH v1 10/26] mm: memcontrol: prevent memory cgroup release in count_memcg_folio_events()
Date: Tue, 28 Oct 2025 21:58:23 +0800
Message-ID: <eddcfb8a49c915dd897a91ca5560553b2bed9623.1761658310.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: CD17740014
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: mxqwdr3jyyu3yi1jy7zbnf7g51xmg4xt
X-HE-Tag: 1761660198-657949
X-HE-Meta: U2FsdGVkX1/rn7iRKsIj/HWhO7Lg6aeCa80LliK/Ew2wzU4008psV1S8VzNNqKDhWI8ZKUhn5LEJX4GDA5BQGSLfo+EKOCDA2eZKDkWf2thWi8i22McjWYVC8kDT2yD7wAaOmiSC58pjSIRegP5kRqvSCxlewGO1+GteJjayTsIN++TGUIEFquQmqvMuufaBU0/wWmEdPSuJnc6nQXhfD7OEJl4rhDxJ59Knun2CUBiZ46o0MHAKuzdOB7qqq7jUyquafsAzxyDOrCPwMB8awirmNeVlpOf/ymyWC6oRx0SvyPUHeyq+PnKDmSzuz/JraSGRBMzH3z/zY3p1kYxl55TYvHhivKg+yBBkMRQBR9tLhWZWrqKMb10x6/koOqgw8b8FVZweioslkZ7sq6UT8kgrjJtip6WDForp89naiqCwEmpZWnGTtBhjrYLT2BM7ZdDrcIiamLFqavtHE29ORI21fTRC9hlBhFXcHA/BfkBR3Vuq+mNywU+uAG8G3+9QK0wRKCCeESHsC7mki3SiwfYaqRaOG6cHVPqJTLkMXYcM1JNZelXXgiRaCuLiYr30RDb1sWDsQskgc8v7v61NrDb0iRw2x3IjpNWgPkSWfl+IqU8fKLr/tfEO3tVuL2A5d8+aRzCF7mzGkOnNW/Wfu6iy5zgdgfIFSJGlArlBwZzeg9nrddy/VdAJo19jgtvyJb/k7rN5l6e4O1KkfeC2o4eEYwmZFuc/nxpmaBktbsZSriZz0g0q3jWdYKj76QmeW3IjPjGb+sYa8C64L3qis52rJzmzYBv7GEioLE4305aL0amhfnwWTOHYltit17q3ndMcCnFq8njsNDAS49REauZadXQi8LAhFk6kpElaanBekJuY8GLNa1Eo8rFecSyk75C1e3uqGdtqFzPzr311HjchrEC9vEDM5fDIhKt9Eg9gsYzGM1/AujwydeMZUyZJSkcBzh+Ub1eS4f4elb+
 mtS4JtSG
 NEV7MkijoIHQjI+pHv2ixKC4RFICR2BSHtALeiMNFpXy6TdIDH+ntmQD18sIUr87wo4Ao3KTKWnnyMmsE5Nt5k8CE38B4+CntxavS9lKg4VR5Ab+5tbR3hUsENv8tz1LRjLFwv1GJQ+BylSlugQ/XEByehCISC4WXcFKN+TZ0cmppTHdTR85IoK7csWtfjmGiwKu6DPAp/RW/6NTjO5mTBqJFCqTk10Ax7oEloa2st/C4RF/U8T+seGHtLDVHo34E6vlp+oi3HpGaLitSro+B4+TEOnlVo6kCfFX4CFPpUPFwjiA=
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
against the release of the memory cgroup in count_memcg_folio_events().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/memcontrol.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 174e52d8e7039..ca8d4e09cbe7d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -984,10 +984,15 @@ void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 static inline void count_memcg_folio_events(struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg;
 
-	if (memcg)
-		count_memcg_events(memcg, idx, nr);
+	if (!folio_memcg_charged(folio))
+		return;
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	count_memcg_events(memcg, idx, nr);
+	rcu_read_unlock();
 }
 
 static inline void count_memcg_events_mm(struct mm_struct *mm,
-- 
2.20.1


