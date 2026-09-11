Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B51F2C88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8FCD6B00A9; Fri, 11 Sep 2026 04:01:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C67DE6B00AA; Fri, 11 Sep 2026 04:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA49B6B00AB; Fri, 11 Sep 2026 04:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 91AE86B00A9
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:01:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2107E12010C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:01:37 +0000 (UTC)
X-FDA: 85200737034.17.87FB660
Received: from mta0.migadu.com (out-202.mta0.migadu.com [91.218.175.202])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3C8051A0004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:01:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JwaaHBoe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.202 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113695;
	b=O/W4/l0ltOK+h/m7sVi7gTZ7ydlqZGmfHpiN9B/0Uzg3l/6Q9JzvXNdZIAJ6QaOLc36/DT
	dDz5MknqRUsm2HTmYzRPKhuIJuKLKknfzIS/v02Zm8dIcOv7nohhrd3zt7eWcjpTfDBHPn
	4rkYkkpihT2rYwx+BdIg8QO33Yl6+fM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JwaaHBoe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.202 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dlMr8ysiw1MQVlli9mPBpZcIDcHuzZcNn75rG1fxJ3Q=;
	b=awew3bwld8fQRHsqAjxqEX7nve/FpJvkurTGCiF5cLf8Hv1q5VoF8YP2T/jaY+3i+1NiSV
	lPw5m+V4sObujs7xQ2btyQ9pLmrAPpYrYIih8mY5KEoK8Ii6xK61QCjaDY4GImc3V60sk8
	qQrpyuvt8lApGys0fQTDSEmDwRvFme4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lG7+VxQE9zUCiUgD2bZJA+1KtHaOwgs94O/ucBNwUz8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113693; v=1; x=1789718493;
 b=JwaaHBoe1/bLgr4t6gry/zjeRGLDvxJiliF0GbPraunHrffeVZGPQqRHI+GW2pedNn8Fv8B3
 yf+ykhf1/f8XO3Txi096Nyell8+mV7I+Wsm7gd65l1E1Q4SU76q/QD9BxHS8UdCfUYQW2Dvmndc
 4bCPwT3tQ51MG0I9pC9fN7qQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 908157556f9f07d4;
	Fri, 11 Sep 2026 08:01:33 +0000
X-Mizu-Trace-ID: 908157556f9f07d4
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
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
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v5 2/4] mm: workingset: use lruvec_page_state_local() to count lru pages
Date: Fri, 11 Sep 2026 16:00:49 +0800
Message-ID: <2ed42f96aca124856ea30f774afb55cbe6d8ba58.1789096175.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789096175.git.zhuhui@kylinos.cn>
References: <cover.1789096175.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3C8051A0004
X-Stat-Signature: aay1uissh3n1uwcmdwtc7yob7efkoemm
X-HE-Tag: 1789113694-917648
X-HE-Meta: U2FsdGVkX189JoYDtvsKFT5rnU+l5gkfdnQ9/A29PJ7V01+YCVSUo+ZBwmkAdLAREFbE/gsBJ5DzSHtHH6IF6O7bmvreeCnzWW3t1hKMoSRIElUfg3JbYn/LCRW0l/sfHXK1iWIEt0/nSf4rhqHMEckUboFps8JMUrBJJXtvbuq8tuzvi5ZdGSkUOIp8vp9+wDZvao1l/L74GBpZEf/mIluXz02H8ukrlNOMpbwnC0Nri86WhF+raO1czgum5dwT4eGiZWTmE7NQrBM/slQKd5wi0fNJUgi5C5gdnw1LlQdU+oyWoo1WYojk/aRzrRfinFHBou5Ez4XrSkSMhEUIkMzqwbHIRGIh1sHrAy1mDKFI5ZjwvPqYq7ziKkOGQQCw1gNIfqPZkng6wSlFYMXCoFuAeRXyBqKOXFotugwYOwjxwTazau3RA6Wh8wtAJdZ588GlgZkOSOOjdKuYyC6qlshuog7j6hCbiVSRsLgagAuDZGnSyZzybMPLFXt5/brSzIKzM1vbNAc8b7LKdACcShbJtvBAkmevbU7XKf1ggIvVEXACfGsCZb+7zPaFrb4zUEeM3w9RgqpL8EEZebt0YgVDBfNp+NAZU/k1ijyRUVkl5Z5P0IoWYXa/mLydZD5XjtA7sSShBxS/l1TuaEUknQbGLStLLq9gdyqnJUnjYWBiFxXcZW3By9RAhTbntQkEGY80ma/FIlNixMMQIVIWzT7MKaez3G19DLiE0Kr+88HNfO9ZMQbdRckTm5+i8SpwJPwONx1LPR3I9rdcZP775ijKiBx8yI402La/AZk59wp8qysfzvFys6uy/ae7AbTCLHS3k2c1wLPoWVzFy7ZZjRy3hw+KvKndYDLQ0zT/wXHp01WYVcLAEALpwXCNUXPCtfRO+QqPpaH/MWtifOmZUueD6NpOia5uZvMT4ti+3rZUNHMDmNs5bNba0DPmqkugp+qlyT0HNCI5R2BjzKz
 4AREHoM1
 ABXXaXkudZxNKcSyA1ZpRbrTouLRZw4iDh8LTc7E7GYF0zpiekXRqXketQ80wwkG0GwVBtKQzU3NlqYPmnYk132OfwEerG+mIyqR/A5W4M8oKg3OdeIsLbIdXqi/05EKaKLlMf4LTvI2XTe7K5T95wkJfnTIU++loqCYtGL484PEUfcdLAmjAxR4l0fHoWKaeQpzPJV4LjyyZE3gHg/Wc8WviOR76vgbdJUbuMuiIAum4TEx4kHYeIjx+GgwSSfD5ZYdO3UPj3V07WiFfu323QwinxaVjmwM0yDiyyH/YgIV6GV0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
number of lru pages") switched count_shadow_nodes() to lruvec_lru_size().
With CONFIG_MEMCG enabled, lruvec_lru_size() reads mz->lru_zone_size,
which only the classic LRU paths maintain.  MGLRU accounts its pages
through __update_lru_size(), which skips that array, so with MGLRU on the
four evictable LRU lists are always seen as empty.  The shadow node budget
(pages >> 3) then collapses to slab plus unevictable pages, and the
workingset shadow shrinker reclaims eviction tokens almost as fast as they
are created, losing thrashing protection.

lruvec_page_state_local() reads lruvec_stats->state_local instead, which
both classic LRU and MGLRU maintain.  Switch back to it.  The reparenting
race this re-exposes on cgroup v2 is closed by the preceding patch that
redirects dying-memcg stat updates for all hierarchies.

Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the number of lru pages")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/workingset.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 7ac2b88c80ae5..8412f4840ae35 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -688,10 +688,9 @@ static unsigned long count_shadow_nodes(struct shrinker *shrinker,
 
 		mem_cgroup_flush_stats_ratelimited(sc->memcg);
 		lruvec = mem_cgroup_lruvec(sc->memcg, NODE_DATA(sc->nid));
-
 		for (pages = 0, i = 0; i < NR_LRU_LISTS; i++)
-			pages += lruvec_lru_size(lruvec, i, MAX_NR_ZONES - 1);
-
+			pages += lruvec_page_state_local(lruvec,
+							 NR_LRU_BASE + i);
 		pages += lruvec_page_state_local(
 			lruvec, NR_SLAB_RECLAIMABLE_B) >> PAGE_SHIFT;
 		pages += lruvec_page_state_local(
-- 
2.43.0


