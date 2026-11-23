Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B66E3606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IxHGNC5s
Received: by kanga.kvack.org (Postfix)
	id 0FE796B05B3; Mon, 23 Nov 2026 13:53:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D50A6B05B5; Mon, 23 Nov 2026 13:53:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F06516B05B6; Mon, 23 Nov 2026 13:53:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C6B356B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:53:15 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B02D9A0A05
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:14 +0000 (UTC)
X-FDA: 85467281508.15.440BA39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id AA2B440004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IxHGNC5s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795459992;
	b=1mTDU3M+snRR2VJ1FWDLyUTlHOGnjg4dX9/yOIbRCwCnkP5gzwSQJBXNmMjTuwoH7GjCPy
	6kdZarFQgcjrb3ENNZkJzwvU14dMLkkgQ3cIawiQfqASZkfmcEUxLrPhSQC4hZ2hfDSvF+
	6nXflqn9/esToQcvephatvBxc1YJCRE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795459992;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1rCE3K77C597tnpDa8DpHCzRg0yY18+BUyGptbSaO8M=;
	b=RNc2rfc303sEWg/hTjlh6Z8GeK+G6U75mToNH/gNQbj2Vsi+onlcpAL3iAT/I2aUnhZbZd
	GV2LJTYXftZCS+TplkscgwG9XsWlbnjinO8xgfrRjNMszqqvAKC/aJIaofRVNhxW0eANfu
	3H5sAx8TnpoAcLmonyvBIFCfNN8aBUA=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IxHGNC5s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2ABC76182B;
	Mon, 23 Nov 2026 18:53:12 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795459991;
	b=VqrtkzsZpwbBWdhobgxDRWyp670zpJGkumwwk9EkRViasRFZj/SOs9LZPlpZD6s0mHl1
	 H+guxh9tTBSmp4OC2H/b26bIreOqyw2zBkFpZCocSjBoOECEgg23HZgqTew9a3vZQCBYd
	 YjQ/aEAspcZyABlkU6m4wY6aJKA9fuP41/V8720kRCei6IG8U6fdNQ6Y/4/P1/l8TnXPo
	 F2QoHBsq7ll4hNpTxtFOQXoCScXB3Eg/uvW24C2stiWoHtz1VlN+tZQU7lbIvvPOoQ5ex
	 ZG3OwO6+x+pmpBtRtUF9GHKgiPYbrkt3SkK9djjv+QKkW0mRR/RgHgErzIj+A3nrobw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795459991;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=1rCE3K77C597tnpDa8DpHCzRg0yY18+BUyGptbSaO8M=;
	b=OZA4yKs9aDhaFmswPuvdqx3O+nSR0PQLYo8887N3jlpJy987Z16FHdeQeaVihwSci4Ui
	 NoSJtPOiupvBBIFAmoNZfL//PrhvQJCmG7hMcF8IamJxEsnrBMwsJ/1n0lEV85sSomVVh
	 0LtIQbfk4EkwdEv8JtC3mAEVJlLYJsc3YrmIMFxu+7FHItVdH1Il+fOBaEDbU4JKogUxJ
	 yHhXvxDZ22H8QI8wY4uLeJ3Yld5LsnyEKODvQGs3VXBkGewuPv7e+ixLt5O26+MUOggp6
	 qeFp0gf0Yf4qEO/fGad/IwUKgRQN9qymlmVvU1UWl70s99/CBOuKantZbJac1jqGRIw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 93F8E1F000E6;
	Mon, 23 Nov 2026 18:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795459991;
	bh=1rCE3K77C597tnpDa8DpHCzRg0yY18+BUyGptbSaO8M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=IxHGNC5sragwBh5QGX0PyWQuWy0XARSCfuo41VfVYkmms46RobvrXqnAAqQ9QixYw
	 qvt7/43qhMi/9mtQnROfskTRnxYqKZJW0jwgRnSlnlDTGVxg16RYNDwB03Z7vPRuqZ
	 TiFzMuECZtVh7BzryNWZKFaBFrEgSf9SeI9X+wFA+zvPxI1nZiJNirD3vOQi99zvYv
	 5XuQYw/H/RPpXWrnLSIjYFCstERC52wkBcx8VLhxEaLFDp/ARAhyYk0zwlnAGkX4AY
	 dRPNtDnVSJ2bBEVx5vGiAgAuklHnzOWGqRnevLZ80AgSUlQycmtCUR74AHpVbghkwu
	 xX7BfYkkghwlQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 19F304C61E;
	Mon, 23 Nov 2026 18:53:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:52:53 +0800
Subject: [PATCH v6 01/18] mm/mglru: rename the generation offset in
 lru_gen_folio_seq()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-mglru-fg-v6-1-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
In-Reply-To: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Tianyi Chen <hi@tychen.cc>, Kairui Song <kasong@tencent.com>, 
 Ridong Chen <ridong.chen@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=2457;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=on9PEefPrnrWULo5N6A+huTmLVTp8DOK4KQGDrtfCuk=;
 b=k5w2EsjoX/bzOEsAS9dWQMREbqipjNq4MTFKSvXR62sapovupL7OAfzxXHx/FEdKFSDvVsq/m
 LPR3LW9KAAICkw7ayuMLIbGlQoHMlZd+Jb96r6pjoa0gTwy/SGGSIPh
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: AA2B440004
X-Stat-Signature: sw5qywcugi5364yaq65b7bir7ys9yrku
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795459992-453849
X-HE-Meta: U2FsdGVkX18hf9N0YntuF9mWMQdtAMacbZ6aub4VrS67tRXJK9oULRHs8pqB8Y19RbTD/sfg46K/51j/IX3jhM3KCG65UWhzOH4Y4FPsdLcgpQqKrGk0lGpBgKjJJUkVWIFWh1uD5bpE0g24NZbb2O21sVcpQSuGJxZEw9ROTv0YiAeDJOTB1y6lmSYyW7ibOlJG2atLNRGvw2r69QOREhIzUReCOJG8XMXLK4WXZKjLA/62ebvX/B5NRlq9qudQ4eBec3XhM7dUXZLal1ZrfmafifkLHKj0eCce0FD64/INQwdSJiz9OMTiS2QcCH3bNw7mO/gwB3cY4qXen8lFwHjDfBe/lvlyzidAGLEbg+iG9iG5L8OR4Ebi23c/AwVgYUufH2pmclh0QCIaGxKP9dCNYhDhjKlIhkwqs9iLQSlfw8VTnlrFW26lmfjMh4TnwBAemlv70lQ0fGO/H3MeTHHt0GEupQOBSggGx+jXYTUGIGSon3LFLiKqqzP/ge/WOQ571DvVzbZ1Jv3jU/68Mo6VqTZswSdgzn4nnUqhReHg6OF4pRerLBbmdK4kYGl3gJmo1QWvWpedLCVJgYRvxZOOgvCTgp3aaukhglpiXTTKvLzjsNekxF8bnmSMPgcGKIfg3wso+ntAsrNpz/LXDYvCjwQNo8Q0TmeUXqa6X9tLErxBlcH1NLKDTob9yI/h7EhKCBDv5MTp3cEBi/LLWu5357Scoo9iUWFbPpraEFVvvv/N3DxtZ9pcjOsMoYjUwU9hm9AcTXB1RnT8qiDBudo+HhBtzlg5wsbvP2eYzDdaTdEDfVKwrdNmcmOnc0p8Know5a2C7IKsYG36djV2Kbq6MjtEbcr4fA76jvZkabzZsTibVpRt0ibZEbcpbzMlcQTIH6g4JNwm+fp3rzJ/djeucamLha/pqzJse8CWu3vHps07tySw/qDJWFzIziC6WL4VpJFO07eZcexwuKW
 uUJHnekI
 C/E+WKKEbDpFNgSk9c6xWz+YukXzX3AErhVJJ6/UHGfpFfgxaGhqEKBdlj1R65Rw94lFJK8yjmlse8VvQPBkjoVi6Qk2aw8Ht9REWorYy+NsY5t4EkM4p4ZiCaxCu1wCpKACVPuZgg9mlhWT6pW3DJJJ6sC3beRgrEjYf/cw8NfJUBudoEcZMEUDz8t+OSa+byus+MLjMIb6sHHK0ym5DSShMaMss8Zaob5w2t11v/lS4F0g+OfNmDPlVD8dQeB8YAUJco93hdtgMyImyIcGPN/IEdqsgJV5Yfq4je8heW+Jk/8uZLUQd1+pMxKA32rBczpmG11C5pDbhGicxNmP9x8XxA5ep+8VjOJPwjZJS4AMZLA4gBSBk/qFFF5g7OLi63uBGKddobES5VD0r12YmGM9QKxeyP06aGCEg91UZ1a1p+hARgCEWgi/DEQtM52RwQzw891onWj9siDubx3RnqFeNfRBMgyk+8eG1Rit56dihC4p46+waixT019k5DuuR9waRnXSb1fhAvUCxEsBmg7AYFHLqIT+f4Sq4zbtwI+5N/gGCEZubXWg/5pOwEr1NTwz+aM0wlmeSsmk2LBs6YB3g1CoyKOKxgAQcltzM2awCzGHxesQQRvrVsR0/NKZZL2vIbA19n6g8UhMQhRZby5iDJXDSUggc1RoUNWDj25OXK16vpLdqlfynDcxNeHl7NFbeuIpYjGTmzOHOp9INULkCgC1Th/DDBK8rQ1YRaMMdGuGnn2hBwVoDwIZ6GQEjrMlh4IKlwon68WlppJQMZLUeDcK8Q2IixdYwEmU0pZqAX/KDCJ5dNFEQRdF39R3ZyKSZVUDbRPOgbU+AefK2Rtkh/LPvgj+zd+xJ6zQcVdz041C5M0drOXIHZunHZTil08JC14n+cpim0U9EwV48O5i5GSaMTrUPP9td
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

lru_gen_folio_seq() computes how many generations below max_seq a folio
should be added to, but stores it in a variable named "gen". Elsewhere in
MGLRU "gen" means an index into lrugen->folios[], i.e. seq % MAX_NR_GENS,
so reusing the name for a relative offset is confusing.

Rename it to "age", which matches what the value means: the newest
generation is age 1, and a larger age is an older generation.

No functional change.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
[kasong: dropped the comment table part, the series rewrites it]
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index f6f4bc9a704f..2395ca8ee305 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -302,7 +302,7 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 					      const struct folio *folio,
 					      bool reclaiming)
 {
-	int gen;
+	int age;
 	int type = folio_is_file_lru(folio);
 	const struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
@@ -319,17 +319,17 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 	 * |<---------------------------- MAX_NR_GENS ---------------------------->|
 	 */
 	if (folio_test_active(folio))
-		gen = MIN_NR_GENS - folio_test_workingset(folio);
+		age = MIN_NR_GENS - folio_test_workingset(folio);
 	else if (reclaiming)
-		gen = MAX_NR_GENS;
+		age = MAX_NR_GENS;
 	else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(folio)) ||
 		 (folio_test_reclaim(folio) &&
 		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
-		gen = MIN_NR_GENS;
+		age = MIN_NR_GENS;
 	else
-		gen = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
+		age = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
 
-	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
+	return max(READ_ONCE(lrugen->max_seq) - age + 1, READ_ONCE(lrugen->min_seq[type]));
 }
 
 static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,

-- 
2.56.1



