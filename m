Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCC57FEEF2E
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EBA86B008A; Tue,  7 Apr 2026 08:04:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 074926B0092; Tue,  7 Apr 2026 08:04:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56426B0093; Tue,  7 Apr 2026 08:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB7CF6B0089
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:04:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E524BB163
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:54 +0000 (UTC)
X-FDA: 84631628508.10.A23DC75
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 86CD64000D
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RKPeu853;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775563492;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9onS38a/+xa4xtBFUcC9z1dNXkQev9YIZSMyQ0UjTKs=;
	b=fQokAFW//OI2AeUFH5Hu3M/mFK7NAw7+6qlZWFdE0anGi/FB79aK/ebDVKBfZ/hc0krdMS
	9NoaZ4jx/rVDblaqUNGZGWfBx5EzgYBc/H5Ivz4fuLLWZWOiJkcIHNrGmkmxVewv2YMmK0
	wTF3vufrAuKJAbXlavUc0Z6HYxsjSvY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RKPeu853;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775563492; a=rsa-sha256;
	cv=none;
	b=wIBn7ZZ4rBYRSWm67+HW8Pb3fcNrOUhbbeKXEFzbAjoZywBj9hMlDSg4BD/NCtpwSRvDTj
	zKoJ4Q3EG7oZBZ6OtO7N7NTiyxPYSyxCU8ID21uwzaZ8RSg/ahbiE/MHMjZQzeJ1cbkG9j
	MYDxJbtslg9mrYIwgon4i5lCYK1CYKY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5414344562;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 251BAC2BCB3;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775563491;
	bh=nf8UOchn9pxNiBANW4ySdYqzcmGuZiLDqUsnkRCZFnk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=RKPeu853k0VrejA7oYOHJJCF2KZTstUFBLKLaYKoYyb2nwRCpjsTFDFpm4Q/rGfFB
	 2u8TYjJfPmeBygzkb8fUOdlJBO38kE+8GyXi2tob6O0T3I08FxauthAH1DBNe+FQvC
	 IiZc2liThMLelbJ7yp6Bx2xh4SWV1tio4Ye8+NscS0QnMKOkzpmbEMByNI2dfPLlgG
	 jwN2r6rL5iEwRbrQqOm+H8LU5Qvxf2FAopmnP57UzndD8bB7TpZLYPVt/Gwt0fElXb
	 JfP+AJM/k7cGrP3IPOtbJSY1DqXequvD2mpjP34k5aAAA/texvizxMquIfkatpFjrQ
	 D1Qh1p2xyC/1Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 172AFFEEF29;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 07 Apr 2026 19:57:31 +0800
Subject: [PATCH v4 02/14] mm/mglru: rename variables related to aging and
 rotation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260407-mglru-reclaim-v4-2-98cf3dc69519@tencent.com>
References: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
In-Reply-To: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775563488; l=2994;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=uhTQOpFFZDYAXHD7SVVg5W6PNjRmTF38550AcmIU3G0=;
 b=Ehtr3Q47mha0PCMw1Dvi147XVFp9g1ZeA7WFCt4ArsMQbs2JOAtGPfshF73Pd3eRPypIYIlGh
 Vd0f1a1ow1EAUlU9O3KwKcgILPqwk+SdD8KrH6hbYvLMaHF0e3O1UVA
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 86CD64000D
X-Stat-Signature: qt9xwauwowctbkem9rrniot8jbqdfbw5
X-Rspam-User: 
X-HE-Tag: 1775563492-136680
X-HE-Meta: U2FsdGVkX19R2pREAWrLJLO2DbESUzdVXwPKkIZ5TMa5qP/VNik/eBdvXSippUz+mHKA4snAAL6ms3xZ6/ERxuMC8Iwq80Buek9Mnyyc+0rMahBAxwkuAZhIoVT6iqShck+TJ3gnVsRgiV7pE3M0lSNbqsru2n9jVHvRrhP8keIt2J+jFGOipBRIOScyyfpzLM8cAJFYa9JBnjyH4nXEUNCYq8En14GCsO2hPJWqn4MrrFraMZpcL44w0BYmSsKWXGklUESJ5XEK/8KU85fwyCRwHXG3qFeXlBLEB/5VQU/RpIN1kjl0kLSzFgn+CAR6/kQaR8qv1uB7FJ0F1CvoqUCptcraV4Q/sfvbj0Gl5bcJYjGRzXuYzI7OOoRqn4M1MzkRu+jgRmrYVI7366LB5ubHqcvL77tHLtMiIGuIT8+KGtifE9LuJS2KU+ERade2WbqHaCZd8u2UnQSZF9sMr5Z2RCcJI3JKhNJ5XKAge2r7CwTA6I+CiYcdurV8c4FL5BOiM46QK2BH2G4mm9xZKSBz62J1SKQaLF/Goed4PJKQeZ048fOHEyqi7ezIfW8u7pKKYE5UgVCGOgFduMz27i9HK9W/WTJ65Mp/zxxk2dc90/A/OfgKu2Q9uY9pJMlNH508giS3uORAH+loZ744fnSaIXgfD3zlcuDQOk8PnF4RSKV6XXs9yBGLDfEtOQ/IVpXSNsFA+9Bx2eJLRMFSlZAjpbKU5be8CI4yZmSGyMqMX64pnVS/TOA8Z0i4hfWBCyAjJlBQGOJr7Z0yGBb5WQW+iD7Cjz0VdseSO2rh53VGbMqgMRATcIEAHRnYIqRDBflZnZYMrX8Cd/g43f3AGK/1+ceMG8wjdSzmXr6D/29WAgagX6LQ9ty52AT9LBxe7Re2uxZZMWJeE/pM/uH+Rkyb/ex9lQEwTzGPUqqwqM8U4ilvBMCPJnVKL5v+C7baOJo9sXwiSNsCzSdEZvz
 TaG491qM
 B1wiji6Ag1uhuvcUN7JY5zzMJwqBeN8x2b+VJCe7GX/lh78T4VxlZWbXdaLvBOxTCHfjk+puY1SHS5qFv8wzaM8MBDZj6DPH0RG8akrN6A5c7E+95snLKIfM/iw==
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
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
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



