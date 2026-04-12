Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48800E937EE
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:48:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58A836B009B; Sun, 12 Apr 2026 12:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5619F6B0096; Sun, 12 Apr 2026 12:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C94E6B009F; Sun, 12 Apr 2026 12:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D0176B0096
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:48:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD118E4029
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:23 +0000 (UTC)
X-FDA: 84650486886.12.A2B2248
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id AB06E1C0007
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="q0feVht/";
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776012501; a=rsa-sha256;
	cv=none;
	b=Q6DrLK0AnCcc/npUXMeyvRwT3obzLNM1FAsZKc3cY16uoCffr3gql1aGxynlIMvLDuGrvd
	NU7TWG1Z6ppC9aauDlirp16kBLqIr47z4wnJsHJtx48VUh2ul0OzMq92vW0cuW+kjNxgyW
	F2Lxv0zGLplhXfYq2tUPGZvlhYjTI0Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776012501;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZyhLp2QeAmgESsLVRclcYhejxLgfbvYz+TS0tWus8Oc=;
	b=xyXaRoOOviGOTprigWeseA11Z8Vdh6JoKd46qhqdXlCdQC0GFe4GscRRO1bB3r3KYIfWMZ
	kfIvfJd2BMS3dDP+cZLLGi1Si8kJKS4PydxH4XSco4d+uNIkwXQTJmEwBB8wjuwitcn57J
	871kCkS2wahr/u1qOMkrYEzBq13oCfs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="q0feVht/";
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D1A44459C;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0AEEC2BCB8;
	Sun, 12 Apr 2026 16:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776012499;
	bh=vGlaz9ZYHgWaT2xiL6hluWz9quld465IwkSQuDQSsOE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=q0feVht/ieYfQHfz9VRnXiJA/cAI0LUwjcnksJPb00cw7UPqPlhXrKJKv2uV/fPPZ
	 9bPtWlAG3Gj4B69O/K0yUH4+L83Vk5kWqiEEju43afbtaz10XT8AH5w2v05gaHgUja
	 LRieqtqXLAnABFOef8vkbLYcDjsZo4VKiy+7VFG4b9MoN8pqqNihDBg4Um6dXr2jcQ
	 LcuwcWWl6kkMgN6Ih3yxKpO2hQLFnlWbTZZ5MhyAtFzWvFQlmWMizWcIdwAHukisT5
	 TlO22329UC28IiNukLf5CvPu9UFTERX1fGDOMlrNfNVMlI6qqfteENuBWpAPpk2RO4
	 N90NQS0Pua5Zg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C48BEE937EE;
	Sun, 12 Apr 2026 16:48:19 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 13 Apr 2026 00:48:17 +0800
Subject: [PATCH v5 03/14] mm/mglru: relocate the LRU scan batch limit to
 callers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-mglru-reclaim-v5-3-8eaeacbddc44@tencent.com>
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
In-Reply-To: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
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
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776012497; l=3315;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=d+i0IK9czNinxb4Rr8UJfKR3t+PD4LIQm30TVC0a5qc=;
 b=lESOxzGvSKeWuGXwB306fB+1FmM/2Ymy05a3kDTMVQVruVdQxeiH/KjSYudYr9DXjVhQTlSMy
 w5OEQhOVtlHCXjdzqpUI78/2n8P/JyjJGot+EBThbLAFGbLn93L+LyB
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AB06E1C0007
X-Stat-Signature: p85whm58on1d8kfat3bd63hsouzbfn36
X-HE-Tag: 1776012501-457499
X-HE-Meta: U2FsdGVkX19WxRCaMPMuV5KPQ/Ki1qKdy1ASt1Sx5QJvdhEhc6YPSye0Gx6rojMFFGH5pcrXUlA5ZQYpInDw3ovgvHHe3HCNqRQqaoa8hsRHYTR+9Z7C/SECv3hsUT0tXKMcZ1MvZ5tMwcGqQQw/LnkfFURp39hMo0gRzOG1URkcubT2Ld9//FKTJ+5oaMpudZyO7oglG5XfhHLzdlM1WNP/NYVXkZ9EYJUbNY9ru4i7GCt06FhtPeIEb9N3dysbSXkNm8ING6ZHE0dgFNzZFcUgXruYXTVO80dV20tOb29E5Ncnv3wrkBkeJlEPW4kUxvTZotswJQQEGVP5TQivEUj2OkRsr9nRbKeSVMDBUw/NppVSTTYxsFh4kM1Uq64pKHp7DSSFQcNiGlPGZn0tWXutDdqsWhidwZfrH+tXZhgK11IKYm3dILGXYFHO69YNeD2NEhoCautHzQHNV0qicNhQc6Mtucbx7e8zOSUnUcN+mZXydEItrJ2BO1asU1UGKq0qP4kvLNpJ8NFgUUHzVPkRLv5Un93VKrdTgSpGfjaJWXF8DTTy0+fBYMmcd29NNlBSzMbeU4raqgOqCBASVYMQi1GsjnrE1P0n9FRQI3Hj14AVfpOt7XDU+tsZdCPp2euAfqFHcq0LNYzlOoIs/o+1GYyZ4qlRNUHDjXWvh3nF9yVd777RquAT7zGDkR+oaAueh7XY54mUSO5lqDNHQNViWZi5EG6H+bQy1C3t5gijP2mdv59mSzyn2pquAE/DJgNuqmizw0rWeyYg10KIIhCxBZMmFZvS1vM6JbmNbYmWP8uJLyaZ+ndMp3wHCa3gEdr9wHZkJEpZcBR1l6G3SGAlu/eUowQm4Udvd2DnsDXpOeGKXmYRNC/wIiNvo9AuKtM9Vsfdt80tXnW6BM1I7C63e70gmgKc+AJGxeN6ltvSREvsuWctVEp31njFKbu7cp7JWSJLxwdljGHHXiW
 ewfIxuPD
 ChqJaWUGugANQOhB127hA0SIY1MJnMVEkdWd60It/IBG4bbcpPqLOxSxO6QyK68D99hiTF89o23YFpHkTDXFxPuWQSpJJsgo1YnEqD3UKQKA3SEmMzGjex3p8AwxMPxc7LcO5eLnLR1Mqo7FzGqW9YIFGuTAueumfHvCfLvrDAxLhIBugeEMusPnpqc6iX/lkuvOPZ1iTr8llkjNxhh1dIuEgrhJB1dFlx2I1+LuV415yEoYpJl++E80Oxi9dJbJQvYBxIOY3Wjg6Jc0pvPxoeC9cLtnY3fkFWjJyiJzWhdYAEohr1F+kPP3c3WalOmYAaFkCXxEgVSQXsisqijPsURmqMc1MsU2EPzZSgxd1+LzGSMlPqjlauBiGooB8Vk9poKBLfsS5FopQ8fnFNcspGzwTaxXHO8KZ8h7+7awVZnGWqKUJm8snYejn2TY0rRTCPugJ9teBoafA/Ku3bW+6Js9cAX69iVFJssxQ93Ll8WBg0VQxdx1i0oJa+1yU2cRU3DO0/eRUEfGwQ9LSfJTclHpvZFkVZdb7oAnG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Same as active / inactive LRU, MGLRU isolates and scans folios in
batches.  The batch split is done hidden deep in the helper, which
makes the code harder to follow.  The helper's arguments are also
confusing since callers usually request more folios than the batch
size, so the helper almost never processes the full requested amount.

Move the batch splitting into the top loop to make it cleaner, there
should be no behavior change.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f336f89a2de6..963362523782 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4695,10 +4695,10 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	int scanned = 0;
 	int isolated = 0;
 	int skipped = 0;
-	int scan_batch = min(nr_to_scan, MAX_LRU_BATCH);
-	int remaining = scan_batch;
+	unsigned long remaining = nr_to_scan;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
+	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
 	VM_WARN_ON_ONCE(!list_empty(list));
 
 	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
@@ -4751,7 +4751,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	mod_lruvec_state(lruvec, item, isolated);
 	mod_lruvec_state(lruvec, PGREFILL, sorted);
 	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
-	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
+	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 	if (type == LRU_GEN_FILE)
@@ -4987,7 +4987,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
-	long nr_to_scan;
+	long nr_batch, nr_to_scan;
 	unsigned long scanned = 0;
 	int swappiness = get_swappiness(lruvec, sc);
 
@@ -4998,7 +4998,8 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (nr_to_scan <= 0)
 			break;
 
-		delta = evict_folios(nr_to_scan, lruvec, sc, swappiness);
+		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
+		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;
 
@@ -5623,6 +5624,7 @@ static int run_aging(struct lruvec *lruvec, unsigned long seq,
 static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_control *sc,
 			int swappiness, unsigned long nr_to_reclaim)
 {
+	int nr_batch;
 	DEFINE_MAX_SEQ(lruvec);
 
 	if (seq + MIN_NR_GENS > max_seq)
@@ -5639,8 +5641,8 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
 		if (sc->nr_reclaimed >= nr_to_reclaim)
 			return 0;
 
-		if (!evict_folios(nr_to_reclaim - sc->nr_reclaimed, lruvec, sc,
-				  swappiness))
+		nr_batch = min(nr_to_reclaim - sc->nr_reclaimed, MAX_LRU_BATCH);
+		if (!evict_folios(nr_batch, lruvec, sc, swappiness))
 			return 0;
 
 		cond_resched();

-- 
2.53.0



