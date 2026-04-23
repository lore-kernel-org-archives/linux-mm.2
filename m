Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B342BFDEE38
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 593E36B009E; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549736B00A6; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED246B00A0; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E166D6B0096
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:43:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC2BB8B598
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:37 +0000 (UTC)
X-FDA: 84690542874.22.C046307
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id AB395A0002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qraQcFa8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776966215;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2HcGXowe0QGr9H4PhJw/3ZAWR/CuhYYE6v46iMHEzk4=;
	b=iRbcxErXntnhtao7NYf5I79DGvAiXE/mZh7U7ZFzFor9sx0sRM/GRQifPpHr3ooVTkOFqt
	Gop/g7mCwqbRzgePkfezRvRZv1aI15lAag6yxHO7ZgbCKj34YJj9P2TdfH92Bl/7ry9N2g
	aMlj6MtOZN+JK0w2O4zS3tusTqsMdpY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qraQcFa8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776966215; a=rsa-sha256;
	cv=none;
	b=56C4FBmQE91TibpwPYNWr/4eTPpjrbNy6xzsmvLbdQqjdcV9U8wc7h5nb4OeC2YSZOr0ry
	gJbo0ausoZxmtbtyAj96Eqx5HC1ii1zuoqbOUeoN4Puhybi68ZiSybBUChkvcUN7CdKAco
	D9l3KGEgHsNFKcBKdFPt+o9bpbuE9bE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CFB242DB5;
	Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 153C8C2BCB2;
	Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776966212;
	bh=Mz130fZwa+XHZtJ3YLUouCVz539YtPTQz+WXvFbHei0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qraQcFa8vX7Na1JOdwMzOnnNYh7b50AcGrGBN1JvKx2os/HWt/PQHFQqSiuvRsHQ5
	 oal4lTsXS8KDvjPeeKaRd73bKcPDGfbUgtygoznBrHcy21wkEdKTBqr9MJPBAUlSa8
	 vlQQArofU9PB7+KBnzt8n4K2DiOgIjywocOIy45PcW3GcGiT2yaNHbEY6h/Go9G3kv
	 1JO/mUOn+kvBTfZ/hmPUsaHmu4c8ThCAcmnIrHVOQs+0c1ZG0qHP0v0yAqrX2DPhir
	 S06fpvC6rbQge5JFm/H3DTn+rQyf8R30wOLB1b1QzO/p4KXNLdUD7U4xNIKMdfvjR5
	 9DJ6z4XTeI+sg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF89FDEE38;
	Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 24 Apr 2026 01:43:22 +0800
Subject: [PATCH v6 11/14] mm/mglru: remove no longer used reclaim argument
 for folio protection
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260424-mglru-reclaim-v6-11-a57622d770c3@tencent.com>
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
In-Reply-To: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776966208; l=2628;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ggpH/FNtPk2W1Wsd+xXOs+YPMpOI+Pw1GBWurcJoCJU=;
 b=vdiX8JIyABAYNQjG/5UYcBYje01VvS0VC1W76VRjdR8wjC32ug0Ukt+ddV7Yb+zh3uiFTTcG3
 N3/rubUYBm6Br8mWzz+F/dGn5Tk/NNOVjAkz1ZyI9A8lCmWyLcV78Nj
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AB395A0002
X-Stat-Signature: mbqj93u6t5cdhgnxam8csx343y4pc7oz
X-HE-Tag: 1776966215-715344
X-HE-Meta: U2FsdGVkX18haO1UXt9uNGI7yiyr5f2sFh2VMWuH+qFWHN8mc6Zxen3ielwJaQsG+ynRmiZ22dQTemywg9fhB419y932m8oozfOT0cGZALJhTWZ7jfc+NIXX+Hb5TILEHKbiv31sYFhTthOrl7Gr1qEZB5nz/hbf4hQPPcMBnGqlG3JDKvF1EKu7cXRKgVW6l1ugjPNoZnJ3hy591MQ7eA97Sm/8BpznYKi+XQ0qV1D6KewOgetgNef8zg58ZXtuV1TkwOvD8Ca9ItkaOpvs1Urxs34/+v2F2aweOJe2XxHKBEriiwem+4U6j0VZdXgyT1+hT0aZR78IwNzWoYA9z/L05NxQo99nA82IxVbu73hT0BKGtzndPiF770XZNsGzhWKE6VmNqA6Mlo140Pij3GICiJSESi1W1nSode2S79Zea0iGE97+fOBXA5t1fCUbjiwtNCp78QaQAKAqwQD55UyAWjGLQ1MkcAAnyf5eHN74Hel3hIhxUAkenmCo2Gv2v4GSQB4/PKWQv5sclMjSz7gxhJXHduUCOOZejv1BXJm1EVE6eLBORkzDK69fe9HyDq5oi15ZMfA2k/t5wWDxiuapVQy20zUNcmWCjs7+KV7tY/HcAlcMlM1skWNb1xmLaVh7R/PKjXw7g4k65chXId3xN3mGLfy/AUW/A7vq9J+SxEtvNv3B9m2DIARJcqgpTwaOSwafSfllabDyCZ4E008DQIHnziZ4HnvCWba3f/vQ6M08e8OydrMXL4gbgbj7aFP4+5orMjNFmczVVJbU207qcFGHRlsV0W992ioBFnU3WO2A1n7p6Bnx6CSAg152i3PpiNfeiQR5aoTsyCFM6iHRYzrbQZtXeaUdmJu5oLuIoZJMytXOiPjpMQgc0RiQ5Dl6XKK5N9rAKtoZqTsx/HpJwkY/eZZYd9ZlGNgLIHex0RMgPQuWGnEo37cgH0reQtPy3c8hD0daIxAvely
 /6FJRqUn
 hUys/WBiGs00Oq0Bn5Y5u6pnQ5gFvMdT9opQEI5YikffX8tfoZxmg5Zproe+OfaqhlIbbxFq6nIlECGfvZ23EfpWZgQMNRbUzeIdjrgKUVf++9DxMXkNa9T04vG5GqhJ2LInzrbPtAUqQhtS+M+9PgWjGIBrdj4EZETpm1jEO+Mi9cDL7mqtpmGHFpbDJM1g3Ye2R5oOiJH6tCMj5E4ODCtWX6EVgzgT7qhnKbTXOsWacP4L7eM9kDUap2f3NOK5TKR2UGMTgBk58oltP7EtHhP9C8Pb3dIGq8nCabCBGEmSPG9ARUjTqsgTKyq+9GKkN4xoV2+SdI1v6O5+aux+7YQINCSX2nRXLASJEf9H4aMkmC7HvONXk7sLC7+v9SIxrsHFCNcfZusZx0adu/RRPLXYvuoYY/jnWwZMNflsC5Mk2NJnXHUJ2ftkqi7+Xf4Wb6f/e4B8hkTefMP2mWnOpeZeMKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now dirty reclaim folios are handled after isolation, not before,
since dirty reactivation must take the folio off LRU first, and that
helps to unify the dirty handling logic.

So this argument is no longer needed. Just remove it.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d7a72a60c894..f6cb1a4b6a31 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3220,7 +3220,7 @@ static int folio_update_gen(struct folio *folio, int gen)
 }
 
 /* protect pages accessed multiple times through file descriptors */
-static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
+static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 {
 	int type = folio_is_file_lru(folio);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -3239,9 +3239,6 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, bool reclai
 
 		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
 		new_flags |= (new_gen + 1UL) << LRU_GEN_PGOFF;
-		/* for folio_end_writeback() */
-		if (reclaiming)
-			new_flags |= BIT(PG_reclaim);
 	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
 
 	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
@@ -3855,7 +3852,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
-			new_gen = folio_inc_gen(lruvec, folio, false);
+			new_gen = folio_inc_gen(lruvec, folio);
 			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
 
 			/* don't count the workingset being lazily promoted */
@@ -4607,7 +4604,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 
 	/* protected */
 	if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1) {
-		gen = folio_inc_gen(lruvec, folio, false);
+		gen = folio_inc_gen(lruvec, folio);
 		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
 
 		/* don't count the workingset being lazily promoted */
@@ -4622,7 +4619,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 
 	/* ineligible */
 	if (zone > sc->reclaim_idx) {
-		gen = folio_inc_gen(lruvec, folio, false);
+		gen = folio_inc_gen(lruvec, folio);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
 	}

-- 
2.54.0



