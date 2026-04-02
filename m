Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E700D6AAF9
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD60D6B0005; Thu,  2 Apr 2026 14:53:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86606B0089; Thu,  2 Apr 2026 14:53:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26DD6B008C; Thu,  2 Apr 2026 14:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9C0F46B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:53:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4078014089A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:44 +0000 (UTC)
X-FDA: 84614514768.20.E8A9776
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 619DAA0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fi5d6JaY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775156022; a=rsa-sha256;
	cv=none;
	b=Y6IOlZRblNaVZh8yn5jMh6S1lqJz9LfsNcqNfAvv9toP43+2a/becCiR5kaN2dHP2EUwkM
	Re0Rxy61qdAjN/r59Ian+WzdUlB14VgAD2u9ucRoKDvA5F90qtfFvYjPbGe68/NMGgZGVU
	pAFORdB5/mVENfFcX8EjjqPCFH8pO6w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fi5d6JaY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775156022;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iBZP5adv7TPTf12V4bGE44b6rUZgl+AKQvr8UHnLUo8=;
	b=0QMA/jZ+ZRNcHA/XW1d9R9ed8/p7j7swCHxQfC4jjHOPuHAwJud0A7MdI3j2yf1zTDdK0/
	uuFx/s8mQQ4BdxYAwERnWY8e/1fOPmztPDa+KH+Q05i7rCOzT3zzI7aBsy2+xqABbXPmPj
	rtMjzviCjgl5ANITb8xMXGfgn2AeJrk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A3DB360125;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 314A5C2BC9E;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775156021;
	bh=DQicmTjn/9uIWRRyCuPoh78Bba+5rJExO8FhG4MsE2s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Fi5d6JaYWFGBWO7nqVVqxAFv84bvrJQqCq0Gl6as4ctb3GNE9XCTCs06kDNbSLNo7
	 bJeu60FZD1C41jcC7gsVI2bsKwgyjsVnMjvaRkyGAuT/inLpBadBM21/SEioIGS8tM
	 NuQ0fmSlO2AjXPYQ56JeQEu+1C31mzuaBg0cOiRowUN4TIH1zd3E+UI8QXN+CyrlHn
	 xna4pUwtDVDS0AwQhwbaqkPq9Ib61Na0zNmfKy8uoq3ptiGp6Mvr+ivhIGq5pxCY+f
	 CfG7ER7n5U4n/SSkvP2YfpLSQ4j7WF1KmGsE6KYFF7uszW+7BBaeM1c+nBw6v3Xegx
	 KGyq/yin8bw1A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E3BAD6AAFB;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 03 Apr 2026 02:53:28 +0800
Subject: [PATCH v3 02/14] mm/mglru: rename variables related to aging and
 rotation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260403-mglru-reclaim-v3-2-a285efd6ff91@tencent.com>
References: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
In-Reply-To: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775156018; l=2938;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=YopP967rKY4tLhCMH601exObOhC9opQifFAJV2p2rAQ=;
 b=6oMSdHXhw34r4i7royuF3rsQq+nRLzRJEu33doWBmrFDxJ2Th0GvQNX3FAHhrxQPU9YE17DNv
 SVU/XJObNf4BiXsS8RuQ7x2mhz3kGgFA0Omkzod7vXYBX0VkVdDD2Sc
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 619DAA0005
X-Stat-Signature: edpkh9nndn1szt8uj7hcqsu1d5kzo3eq
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775156022-59916
X-HE-Meta: U2FsdGVkX1+2wyvrAGk/rzJhuVZc9A7gbj2U5p6OViYPJKlfPs6S0JVMm45q3ZdiNxRMnboeV//wIlX/ePIsnagXfqPFAI/YNyYYHbsPniPQfX0BFtFU/XeumPQaEnzqsb1LXbBAJi9LkyaRjnsscKi6QEQySl697oOPVGqRBzNFn2ZJJoPoShohs9IQPIkFV3Es8JU37fJQmd/GK0tIcxYIOKLTUSszw5BlZJ3dU8wWGTx368CTCXRmUM6jf5U4lMbQuFi/4WNFFukqe+LsrkL+AFXVH0zEsV0Tduhkoo5cdJ2ixBMmu6e8fyP05O6YbW2NvxMldxd5dkoYo1yE0J9VkPmB3rOr6CvFnZ9HuLkTKssgEfHLaFjgV3k0TPZLohfD0KMEe8AduwKdcSV4GG97QmcmWOa2PakKz2+rrSPTw+/uksShhQ6Z/RYVmfm6GnN883ajSWlJ/3djfLb9XHbTxmmbAGwo/TZ/ooberCLFwgm5i9qZ3TE6Dp9ux2jYEOEf2gUaIA+OQmmy4GhzMsLrnPaoiPaV8T+HE40Jn8rtYkgrhAKyzEk7WENtax/9MXIksk0VdqnbGmNsYiGc3Jw0tq0F+W4OazXZWxW2ThwiACPrjPYilP2ymjTYWNpmgaz2ypwEcxlUwIJ0RLH31FmQ8rhq4zukARSgB+DY4pzJgLUVKWW+bvSj7qQXYxqI5ks1buSmtTjcJSvCNVM1FRow8I9rnS/nrsjKPws1oezRMauSXwAiabtCHdk9KFIu4/lOGVjE23J9rxfHexSbUivGgSiNIhkm3mTyPpP/uXlF7WKHZTTOSfqa7wgdjnhGbn/QI5aTkgX+fezBwdhsNAvP44EtrBkVZEcEBs16gp+ShVpNVerKoMHgfhV4+pYyb6OpBOu3NNqp8rdKuLlA7hOPw3irop021wAcXKI8aMyrQXSTSzKH1BOErnBKlx37otmTd937r3FUwb5xraF
 A6kZQx2y
 gLeBSQggnlqOimoQm2OHjgCmDi5AU1cyTCfVG9k7fJeWIAOC9xKIUJke+wglzVBF9d+C7fqYYYiJOho1NVmSkdtTcTSM5SmfIHXxBxiKRM+9VETffS9abH+yG0Wpt3UFjIih/lbd9o6oAXjnA7DjRYamIkLDdFY/ycbMBjXZ4TM41Uydw6Qr3PSGfynq0Y+KL43IyATdw5l+trZXpfAwRNaYZNt7YEgOem7vFyCx+8qLPC087IaO6EoylEwVe5c/PIfKhfGJG+FuUCxYaukLUv47DG6IkVLSvzcCrbZd5UK7QzJwAr+vjguAEnm9nTLw7IOD5kxkyWDC3J6Q42V4ycsFLCyBkJtsg6tCv1ltgkSCZampRmesvIWbagihIXqRDvHhMzX1F+E922sWODAIuSlXad5oKNMJ/6l3qrH07dxWkPy9ipolZjBB9jFBjy8Rqneh6qf0mnhVH7eEcET+edWqHJikdca3VxGMV1RILS/3R/GI77e9QHiek1J5yxh1yVJRM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The current variable name isn't helpful. Make the variable names more
meaningful.

Only naming change, no behavior change.

Suggested-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index adc07501a137..f336f89a2de6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4934,7 +4934,7 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
  */
 static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int swappiness)
 {
-	bool success;
+	bool need_aging;
 	unsigned long nr_to_scan;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
@@ -4942,7 +4942,7 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int s
 	if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
 		return -1;
 
-	success = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
+	need_aging = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
 
 	/* try to scrape all its memory if this memcg was deleted */
 	if (nr_to_scan && !mem_cgroup_online(memcg))
@@ -4951,7 +4951,7 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int s
 	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
 
 	/* try to get away with not aging at the default priority */
-	if (!success || sc->priority == DEF_PRIORITY)
+	if (!need_aging || sc->priority == DEF_PRIORITY)
 		return nr_to_scan >> sc->priority;
 
 	/* stop scanning this lruvec as it's low on cold folios */
@@ -5040,7 +5040,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 
 static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 {
-	bool success;
+	bool need_rotate;
 	unsigned long scanned = sc->nr_scanned;
 	unsigned long reclaimed = sc->nr_reclaimed;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -5058,7 +5058,7 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 		memcg_memory_event(memcg, MEMCG_LOW);
 	}
 
-	success = try_to_shrink_lruvec(lruvec, sc);
+	need_rotate = try_to_shrink_lruvec(lruvec, sc);
 
 	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
 
@@ -5068,10 +5068,10 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 
 	flush_reclaim_state(sc);
 
-	if (success && mem_cgroup_online(memcg))
+	if (need_rotate && mem_cgroup_online(memcg))
 		return MEMCG_LRU_YOUNG;
 
-	if (!success && lruvec_is_sizable(lruvec, sc))
+	if (!need_rotate && lruvec_is_sizable(lruvec, sc))
 		return 0;
 
 	/* one retry if offlined or too small */

-- 
2.53.0



