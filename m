Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB3EE606A33D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 23:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kwZh7PK9
Received: by kanga.kvack.org (Postfix)
	id 0D2BC6B05B5; Fri,  6 Nov 2026 18:59:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05D166B05B6; Fri,  6 Nov 2026 18:59:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E67886B05B7; Fri,  6 Nov 2026 18:59:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA9E16B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:59:14 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 576E9A79D3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:59:14 +0000 (UTC)
X-FDA: 85406363028.14.E46FA16
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf13.hostedemail.com (Postfix) with ESMTP id AC16220002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:59:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kwZh7PK9;
	spf=pass (imf13.hostedemail.com: domain of 3z2nuagkKCLoyorjwhnjwlttlqj.htrqnsz2-rrp0fhp.twl@flex--tjmercier.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3z2nuagkKCLoyorjwhnjwlttlqj.htrqnsz2-rrp0fhp.twl@flex--tjmercier.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794009552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QLxBnr2dWVF7awuaywn040Wg1Wa6I8q0xUXMqEWtl88=;
	b=r9BAgS3UwwPcM8eKTIpsfREj4LqhM5FX5e+jq9L3kcrFRnuip+YcPFvMxUvKFCDt+G6mEA
	/hjsFBZJtP0vzV08aQrqNDzFbOIMAhs5fOWAqGyRn510bYJf0kEoR0NR3i35i4ZmeKRcbg
	lnfkxZv1Yu8xxGTrBKKzlmhR1r72yrQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kwZh7PK9;
	spf=pass (imf13.hostedemail.com: domain of 3z2nuagkKCLoyorjwhnjwlttlqj.htrqnsz2-rrp0fhp.twl@flex--tjmercier.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3z2nuagkKCLoyorjwhnjwlttlqj.htrqnsz2-rrp0fhp.twl@flex--tjmercier.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794009552;
	b=3Tiyuu2pkzlrnqBpwm3q9prmtfotyYKmtwT31PIfExTuRN53fmH7Q3GfiyR3s9cvRIb7JQ
	iglNu9bNtK0DcqaDWSpyyt/IdyuQnZU0z8yDM1jVH3eqxbLCFab9LbfaUPHxB6pkuuB/sY
	gTC5/ECIGkucfZfoKZ/upDuhzAaAV80=
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4ab4f652f9bso844837b6e.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 15:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794009552; x=1794614352; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QLxBnr2dWVF7awuaywn040Wg1Wa6I8q0xUXMqEWtl88=;
        b=kwZh7PK9X3KyQaaerWR4SniGrcOBcME7UDYmTDMmpWFAilQqKEy+UyZ9jIbgYA+dTS
         yyn96G/qilWrhzFZyJjGzxJ1oXQOVUSdsO7qlWvpLdSEzQIEZb4tTXsnzC4UJcv6Cn47
         YvJ2KaTQ+sCKu5fZ+j8p4+aeYl7L63Zi43t+W+d+ibR5lcDhjajff4bZOzE9UV/2G7Vr
         FhVWSVUWmLyq5nP5dC2lCUFbMty22sXQPG3wL1NjO3rbX2PLmGhN67KOWTndvbbAopKB
         QTStl2P1WqYwj4VA+MTPKAjdMDFfOCYuu3NcFfF4Oh4Tuzy6Mez5uf9zAcMyuB398Fah
         YCeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794009552; x=1794614352;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QLxBnr2dWVF7awuaywn040Wg1Wa6I8q0xUXMqEWtl88=;
        b=Kirs30JFNn4dO26xF/2ZMDJO0R/jrH6c5cImaT9W05365l9h97jFtAf2U0PQ84UAys
         QhDxupaDM9F92tPyJK62A3wI5YBBtklhQX+dyBdlRrIMsS1IKSOcZ2vqTTH50C7nHYFG
         S8BtEXShGjIXEfq/JrO+C4uHCm+81x2Sggzoi8X0oeg7JVbly+YHQgkhDxH4eKNbfSRz
         87G6jYQRVcSr9tn/Vf2h9l9LKTfXri2T2VTmYSBLobBsjCPSjzwkbqx9lq9COLgCbahe
         YXXtuuT1p9YShqBsm/hsWa1u8s6fl2zqUyrNTNMFDYXKt5sp39FFyFIQxSU93QL+3T1J
         C0mA==
X-Forwarded-Encrypted: i=1; AKwUvBzkxb+SLisd/QWnqMGDPqg9Rveb2djzTCviayKydm0zm/vmlSLLEz1fnWt4GOYExoCPxk9lSfpvzA==@kvack.org
X-Gm-Message-State: APuU4Z8aZ3tpQMypmiOipF32iOiKHjFH+9FATyXEd+8IsOywtTKL7IvH
	PVh8IgnHSaKuGjSZeda323MdgS2PKiOt0+A1MfuUOoWuEJ9AQXVqRFvSw+ZZcGWmJbXdEWe+DRj
	EEYavwMC7/cnABKfZMw==
X-Received: from iokk25-n1.prod.google.com ([2002:a05:6602:8319:10b0:9c4:de2b:c40f])
 (user=tjmercier job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1985:b0:55c:8ee:a9c4 with SMTP id 5614622812f47-567e115e036mr3038381b6e.43.1794009551333;
 Fri, 06 Nov 2026 15:59:11 -0800 (PST)
Date: Fri,  6 Nov 2026 15:59:04 -0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106235904.1092712-1-tjmercier@google.com>
Subject: [PATCH] mm: workingset: compare shadow nodes node-wide without kmem accounting
From: "T.J. Mercier" <tjmercier@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "T.J. Mercier" <tjmercier@google.com>, 
	Jaewon Kim <jaewon31.kim@samsung.com>, Jaeseon Sim <jason.sim@samsung.com>, 
	Youngchan Kim <ycshark.kim@samsung.com>, Dmitry Skiba <dskiba@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ug7yspi1pyjxoamceu7oup611n17uoge
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: AC16220002
X-HE-Tag: 1794009552-23550
X-HE-Meta: U2FsdGVkX1/DIEblJ4QU/WOokPiKRjirPYuLFgDlHLuE8oRYU9jKrSPYzGQEP0aDLSLOV9h6+DWYJfETzo+jRiPOSIp03VIgIliZsw6/WhQyT1m3Q2iQQalje3a086kcYhPBp4ykWYfR1rCTemP92JbS3zaV+VXFuKvvOEdK92Hr4ElzsqKFKWzxVKbk9sVa/Rlr3VjRKk62JGVf+dQCSCsNbh40fzYMvwkf5W/MkzY0mpOJTdXH/MLNmXaAbjBy3YL+qkSsSSQGPrUnUCUJrqReGAVVrVgVtFseiExCZnOQhZFIYBAC+HnES1HUyWyS48j1Ve+PVVqrhuTK+1E9gZPoGoB4uvtmdqNERTpg5W/TSpZm2JMNxUIoIY1E8Gey7u2fPm3wG2qKzAd4X6xKl8bcpqmHY+iE3dxgyOJYWuMgMBK9p/u9ZDO1AEuFHpsx278JerSNzlF57Vu3oMni5ieEpx4qfGTsTPd4uiTEEvngkzc0x+rROyTqrvYxT/Rtd3hxYvEX+or6VkK7AxXKkWP0zzr4/5BcOhBLGGM2wYOc8VXPgwRb9rwb8S6N7ghVdoXmjNjaeOkY/kZ2xEMDShY6Pur/MBTKgkR17SKXEPRuQH0mXFYoMytBFg0Ml7V2vGH/K+JxpQmzLFR/ZyeXaWEX3CUVQXp74mADVu4LHA3SVb/pPz1BkmEfe3UovCvee3zjsy84bOfCJ8uUTEjvsuYs7pINa8ueDx1+X0FJQAc4QHLDmuJOz2ZDC4RiaRhl+KyA+cOLJkgTaFb3Lsj25dU5hbVsBeFI+pR7aJ0CtX0wte44B4sk+yRXYyKbbe0fPJ7RIlQ2Rcc5P90ugg/sbhqDOVDpRw6YxO3Bv9dCOIqKdLEkfc2LJB6ihgKBtwARgzZghBBtfOcKqD4h3iD93jMgtEkyTzx0MMeqOcaQNFD4mTd4ZzJpF7hSlDhvyQg2GUhiJzDUB6gC6ftOa8/
 yhRKkyKk
 RfBO2IThdDmFC4VkWj2ejU24y/XrnZZaVKJqF8zbqL5f3MTQ3rp+SHkC306Wvu+qBstmpuYNH+UE12NLGHAtnfc8u9zm336aSer6BrP0URwQfDcdwxisTo7LhUUfJ9y+zJqzNkCZwBvB0PlEmjFI2PKN2g5a7sjkTNSZjJf+pYSUTNNIQr1Mv/3Cg/JZXxqd9O9jucIJ8mQQ+FQcM52vBBdvBNM7oE4yTHw1sWdLh+X7d9UHI2oiaPA4YHDu0u1L+xJUpB5tRFDDZLbIt60wrTzYF12L3RuCSu0QvFomzmpuIIx697CrwElVVKbttaPtYBzIG0669kCrcAJtlqkvmB06pxm2kt/vJ3L/lFPjrFU/xs8LUpCYko97qI2LGKRABzaWmtkwkBg2k8zlSuVP2cq1u5+PYe9EGwJF5NLABtX9hm/hdOEKqqJ+wP/1Oz9cAgRSoIALL9oehHoQIyMi5KENvm0UJnSnsRC+tIwKyXP313GvUNfYwELqyl7UkDf7PxHQyXFDeMyqUI5mVV7xt7L7SfZ7i+SL4/nCnZ56r8ex9/MxacLgDjnTTRkw27/5s3J+Z2rTeVV0Sa3EUCXp96NyadYi2dIRHlDLPh3QriIp9+XCRuSwRXvEtgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

count_shadow_nodes() limits the number of xarray nodes holding shadow
entries to 1/8th of the pages that could be using them. For a memcg, it
counts the LRU and slab pages local to that memcg.

With kmem accounting disabled (cgroup.memory=nokmem), shadow nodes are
not charged to any memcg and __list_lru_init() makes the shadow_nodes
list_lru non-memcg-aware, so all shadow nodes of a NUMA node are on a
single list. shrinker_alloc() falls back to a non-memcg-aware shadow
node shrinker, which shrink_slab() only invokes for the root memcg.
count_shadow_nodes() therefore compares every shadow node on the NUMA
node against the pages local to the root memcg.

When most tasks run in child memcgs, the root memcg only holds a small
fraction of all pages, so the shadow node limit derived from the root
memcg page count is far below the number of shadow nodes on the NUMA
node. Since the shrinker has seeks == 0, every root shrink_slab() call
trims about half of the "excess" shadow nodes. Most refault information
is thrown away, so refaults of recently evicted file folios are not
detected. Refaulted folios lose PG_workingset and the workingset_refault
and workingset_restore stats drop.

In testing on devices with kmem accounting disabled, moving tasks from
the root memcg into per-application memcgs dropped workingset_nodes from
~37,000 to ~900 and raised workingset_nodereclaim 4.6x while
pgsteal_file rose by ~12%.

When kmem accounting is disabled, compare the shadow nodes against the
whole NUMA node, as is done without memcg. Behavior with kmem
accounting enabled is unchanged.

Cc: Jaewon Kim <jaewon31.kim@samsung.com>
Tested-by: Jaeseon Sim <jason.sim@samsung.com> # Galaxy A18 LTE
Tested-by: Youngchan Kim <ycshark.kim@samsung.com> # Galaxy S27
Tested-by: Dmitry Skiba <dskiba@google.com> # Pixel 10
Signed-off-by: T.J. Mercier <tjmercier@google.com>
---
 mm/workingset.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 1504f91cdca5..87d5e55dd684 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -682,7 +682,16 @@ static unsigned long count_shadow_nodes(struct shrinker *shrinker,
 	 * PAGE_SIZE / xa_nodes / node_entries * 8 / PAGE_SIZE
 	 */
 #ifdef CONFIG_MEMCG
-	if (sc->memcg) {
+	/*
+	 * Without kmem accounting the shadow_nodes list_lru is not
+	 * memcg-aware. So the count above covers the whole NUMA node, and the
+	 * shrinker only runs for the root memcg, whose local pages can be a
+	 * small fraction of the node's when most tasks run in child memcgs.
+	 * Compare the shadow node count against the memcg page count only when
+	 * the shadow_nodes list_lru is memcg-aware. Otherwise use the NUMA node
+	 * page count as is done without memcg.
+	 */
+	if (sc->memcg && shadow_nodes.memcg_aware) {
 		struct lruvec *lruvec;
 		int i;
 
-- 
2.56.0.455.g6c5a503b38-goog


