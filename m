Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CC00D2ECE9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 13:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FF436B0416; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85D5F6B040D; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E19D6B0411; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30D666B040D
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9491C153F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:57:57 +0000 (UTC)
X-FDA: 84352495794.01.D1CE612
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8F4DE40004
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:57:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768917476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4mmnPOtaa28UTH9JJoRsPy2Dakflpo4FsS225/lVVeE=;
	b=5hV4C7zu4O23bWiWyTVgdghKJfFbcXAPE2AzLRL88c5lJ+OEkClYiVwHyRRlq94G7y60s2
	uq43iF3v+LrKWZUFQfxxFNs+SQEqzzyifLUbq3CNPaoepjh/C3pgpbeyLdwzvu7/TeQQ0I
	hM/roQ8HiLiCZQCZcm18KVJsvBJ8XZU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768917476; a=rsa-sha256;
	cv=none;
	b=TZrLLmJ9HKly0Yr34j8lqLajje+9LQf7GnXqdorHFlSV7v39r+jKkVwwWfwWuBI8JyiOjW
	f7z+9dKksSsTcO70bZeD+/TJRv1bOjK/i4Io4W1IM9KVVoVJ2a5l3Gdjj+o2/UhwbdCbb1
	POl3SXAWYFi3JPCvyhNFIRSlUPVWaL0=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dwTR737QxzYQvJ3
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:57:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5302240576
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:57:47 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgCnCPnQiW9pwhTxEQ--.10691S8;
	Tue, 20 Jan 2026 21:57:47 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	zhengqi.arch@bytedance.com
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huaweicloud.com,
	ryncsn@gmail.com
Subject: [RFC PATCH -next 6/7] mm/mglru: remove memcg disable handling from lru_gen_shrink_node
Date: Tue, 20 Jan 2026 13:42:55 +0000
Message-Id: <20260120134256.2271710-7-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260120134256.2271710-1-chenridong@huaweicloud.com>
References: <20260120134256.2271710-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCPnQiW9pwhTxEQ--.10691S8
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar4ruFWfuFWDGryfGry8Krg_yoW8KFyfpF
	Z3GrWIy3yrJF1ag3ZaqF47uasxCw48tr1rJrWUtw4fAr1furyrKa4UCrW8Wry5Arykur13
	Jr9Ivr1rG3yjqF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0pRiF4iUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: 99dphfftuhsok3jaahi4weyd1d6nz4m8
X-Rspamd-Queue-Id: 8F4DE40004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768917471-478122
X-HE-Meta: U2FsdGVkX1/yQGK3NBBUzBKwT5KAVFK00SzRknrtiDp8zaKJk+h3N9CyRG1f8HHam4P7hx2xN+rUfFWNUpLUFLIRfzVoQarneIh5emGQsPskxHlRIg/A/mTeJkIUn6KHEzwW8VXg2VtiXfL3WCsiW0yGeEmAqyHwOzsxEOaaxeGjylhWAzrAEEUoxEq9c6sl/jNrEIWKIrt5K49hOLsWf+jphPGJNMZURH9viyS37UFyRNgwch/enCH5I39jkA0vgnhwG7LM+DE/9o/tPVK5kyh3QP6mJXnuhBFURlbLSi2/IX2B89iUDkN5IF0dTNaqOq6UpAavgFBldRKxbArUozrDkcGP/4PxxNzDsgVhj1obEEfwb34CqRUoo2ky5JIbKVaqVqiUgEsNl11ZSPbiCR1YmiKfnxXUERruh4p5ShOa7wTK6nxmAi0mPWMFPWacNCvF/2hlpc5D2Hh4SRo78ycxH71sLNBu2KhklE0xS06VMSl5l4V4p8pMZJnuJpFYmxZZPTFsGSVQe2HZxgXacrrNF8YIuvDW0YWwPM4War2Jh0ijskOtknGD06rGZaWZPY8eOk5QPKbwEFQjBJtKmNJI+MBlugPrLgkIBsWQLArxY6GB1zwJ1MwvNLwdEeiUIM+K6hi/2891Os3jucUuwVM7KrCXpAM8e3vqbFHCO2POSCZJq85QBipIIGU2DBPQBPBBDq2CqPe5kOWs5J7qsVg5xvMMPDP/nNJnWzCnU0LR/e3svEHNZ33f1wu2fq7iixzHqS8nbrDvi+9HqAroQ5tJFgFKFgySitPwagLFVVBwoniC1t9nuq4OshkBdduOVBE63nqX+KtmbdBNiurX2t6P0Gsx+XdvWqjXu0KUhgAQx1Cuosm+009DZ0GPoMedL/Se8smndl6sZtMRlRXoeJxnJkw5oxF0kJl/g4DngiG8EOOW7z4P7Ay6JCHMabXwrPRJrETcwjnoSLf2FgO
 SRNmu7vP
 Ap7CY+atB1CAPFkzBshbPmrfKjj2jproUqQHd/i8Ks5Wg89MPcHZuMY+hGjDexkQXKwD/6XCrbj0fkVj4kY/16VG55cyDLGpj/bh9ouV7MWEkzgqmM2Y6+Xlz/mj17TtpVn6xtPiGOq7rzMw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

Since shrink_node_memcgs already handles the memcg disabled case,
this special-case logic in lru_gen_shrink_node is unnecessary.
Remove it.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 mm/vmscan.c | 46 +---------------------------------------------
 1 file changed, 1 insertion(+), 45 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f806838c3cea..d4eaa8221174 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4924,47 +4924,6 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	return nr_to_scan < 0;
 }
 
-static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
-{
-	bool success;
-	unsigned long scanned = sc->nr_scanned;
-	unsigned long reclaimed = sc->nr_reclaimed;
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
-	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
-
-	/* lru_gen_age_node() called mem_cgroup_calculate_protection() */
-	if (mem_cgroup_below_min(NULL, memcg))
-		return MEMCG_LRU_YOUNG;
-
-	if (mem_cgroup_below_low(NULL, memcg)) {
-		/* see the comment on MEMCG_NR_GENS */
-		if (READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_TAIL)
-			return MEMCG_LRU_TAIL;
-
-		memcg_memory_event(memcg, MEMCG_LOW);
-	}
-
-	success = try_to_shrink_lruvec(lruvec, sc);
-
-	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
-
-	if (!sc->proactive)
-		vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
-			   sc->nr_reclaimed - reclaimed);
-
-	flush_reclaim_state(sc);
-
-	if (success && mem_cgroup_online(memcg))
-		return MEMCG_LRU_YOUNG;
-
-	if (!success && lruvec_is_sizable(lruvec, sc))
-		return 0;
-
-	/* one retry if offlined or too small */
-	return READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_TAIL ?
-	       MEMCG_LRU_TAIL : MEMCG_LRU_YOUNG;
-}
-
 static void lru_gen_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	struct blk_plug plug;
@@ -5021,10 +4980,7 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
 	if (current_is_kswapd())
 		sc->nr_reclaimed = 0;
 
-	if (mem_cgroup_disabled())
-		shrink_one(&pgdat->__lruvec, sc);
-	else
-		shrink_node_memcgs(pgdat, sc);
+	shrink_node_memcgs(pgdat, sc);
 
 	if (current_is_kswapd())
 		sc->nr_reclaimed += reclaimed;
-- 
2.34.1


