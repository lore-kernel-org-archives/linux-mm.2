Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 046F5FEEF2D
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 249FC6B0092; Tue,  7 Apr 2026 08:04:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2AC6B0093; Tue,  7 Apr 2026 08:04:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF23E6B008C; Tue,  7 Apr 2026 08:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D96F76B0092
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:04:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BA1E13B9A4
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:54 +0000 (UTC)
X-FDA: 84631628508.23.755FDE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5FAAFC0011
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lJP8SWuI;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775563492;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=80l7G9HqcO9QO1QwVtrY38+Qx4dX+Um/VFNib5/fNWQ=;
	b=Pz8CX1VEP6Oz+mivaVFSLE6xn/xfWCGyty/4tUQliqRCbXy10/KWgBTuerWzShMyPRVsV0
	upj2AsnQzD1/1zhVbZyFC4D1xghpamhkbQz16J8Ww+91J+qa6KMdocdBxiIrpR3E4kiBEM
	/foelKCGKPGvvMZEXkBcFNeD22JCPs8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lJP8SWuI;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775563492; a=rsa-sha256;
	cv=none;
	b=rEuPHNBMXHCnPK6J1OM1E0GfugEoqTho58iCqWFS8+IvqRH25U8vl1JbNU9mMrFEcQonTO
	Amujk7B5p9CJ8XHznWRgh3TRFx8oZZnpQr68c9/0c6/i0boKWF7AWz9A+aJpLOC/gG7CU+
	3el5pJJuA6JmseJEoZ3wQJMOvoHuSlY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 40DC1444D5;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 137E2C19421;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775563491;
	bh=pu/4aSrd7KSa0bxFp6wbeBj72fjrUtTNvGBmWMpcIZ0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lJP8SWuI2Cxb/iDi1p5tTrrt6aGer2/k95f2VKEx3Guj+WT3u5roMCn9lWmCncpaJ
	 UmNJ1vdoZnp1t0xQoWb/vgmBfi2CPtMegug/i2wQxsSCog+3vyCykX4SizjJa5pZR5
	 MAvad6IKOnTkDiFx5J4T2lW2j1ymjwV9QuSlzlw9NIeAEzdYcb3754rFUHF9FJQbt7
	 LDcqSOfi3eKFBXL3r8LL2qGOiLuivjD0I9pkRzdF6rly9uL5p6DL4VUAur6sADgsGm
	 YLC9TcvgCTNZhAOcUmINwUijCOgrDvB+Vpxa6Rb7sn+IMd8Qh6pXv4AjuOn/O6LrzV
	 iqDfSXpw81t/A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 020BCFEEF2A;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 07 Apr 2026 19:57:30 +0800
Subject: [PATCH v4 01/14] mm/mglru: consolidate common code for retrieving
 evictable size
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260407-mglru-reclaim-v4-1-98cf3dc69519@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775563488; l=3179;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=lovGNHm1LZYPq5LXk6kp/WVa26J2TdTx/242vg8RH/A=;
 b=o2kzXPa3l3rIWSBfx1cPEZpYC4ATtY1m/W9nz18i0dGJN0b2YZIoBFQXGdQLISGwrD5Z7mZ9h
 qBjFhO53C3oB1syItjM0cdtI7OxaJJYEgNdygTWef8m5r1HqcVFNbU9
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 5FAAFC0011
X-Stat-Signature: 9ghpp9opnuqy34b46ptad68qfiz9a7uq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775563492-233617
X-HE-Meta: U2FsdGVkX191ZBzG7pF6ul+/okxnFRlOhleuEtG8xkrkCW1h/DrlFNmGRXlxvbykZfN4vKuyjJf9hCrmRZKL0ZxCMBZYhlqYNr5K5CNcnDJhQ17k3MYKe1PnxFT06PpNttuAli9eRHgRcr8KOUVZ1V+3azi5jgsuccwsSBsf5XfsCBC4mTfjp3I85DsqAmJOnByaDguoMcmEV9RdHoDJAdFIf83g4XxaeCOlFU4BNe9r2LvTy8WkNuHpKVqRvreyQsIMq0olvYV8FNGGqHi+nRCWOpIE4zuku2jVoCgw7hrcqxChXoad01eINdcdTaxZz6GR3A2at5t//TmVjcan8t8JOBXyjL4tjaPeVK3ab7ZHACoINuBFXZPDLrl/XrJseAnhfDHawXn4tyQ+UANXg7VJolzWKUIERTlQt8N8Hz824+ry1cSMOIZ3D9TYypyX6HzzLGgZfuMI0F83NNs+3JZAgokd+ASJOkJoe+Fe6u6nF6x+Feu1+9p1bfZDvXBqTBaZkFOHwa4hMlrslp0jHacUxFdtemOwV7MijmCP/zwkA+MecPLxC45r5gE/5h4OhsEJHYGl0plbgAelQlzTRPZPym7AL/YHe4hR0TV2hSkYLovupPxyKkpMe4iBwesmqvOh2tiQE5pAnuhDfxJFMeaMjghp3iyA4JBq3/dLkpflNrgH2KJ4BLyHu/YGWqzRAR5gZOzz33RDjQjuNOehME2tm0TwgxMYCpZ36zyyPGtgKgp6eSDyGF30IpaJCSTMKV2d9xrdgiSLi6MSs1Y1BWzPYiBUQof4UXl1k7NazYi9ZSltHAdu4n6AcbHUoghQKUyLF86l2ujSjK1CSTlqM/HKfcZJR7KpO63tZf+puzbg8YXWPTS7RlV2H1VTuikZQJKvFLaGRfJaRyNmpS8/nMVyrqxrxmoKJCxQG0AYWAVImWnncMwn3ybmDEdVN4cErDKsJJ1PmbdEcsxtfVL
 FsXfzoMq
 U2oo1qT9fVWuKTQ4QvXq4b+W739Y9ojKV62uQdzzlVw9ztft4xII+7Su8VsQSJlaiBIw4fzkMudiYGh08O/5iscJTeoIUSIjNiW+FT3FpnfGgWMfGcrq2FgwoMakhz/nJGUJd0wpSYjB91gmeFRGMbx3fbO+PTJ0I6GH32VcWQ9JCn1uvyMyBlpzOXazaOHcn+msor+7R7Ucha0gEOlntm0w3DeVcBKc2XssTcI9Kp4qB5//rAoT9Uyuiv+mJZxKQ+RN9QUAdIrbQDKUSde9ppp3WXLMuitA8fvgimt2nuw8tM+48NJcBotTrn4zwv7wqWi7noJiRpNCmdJldN8ILCoBA1VIMfeW7LgAjzR+vDOemznf1sqekOMPFkMCFUPPLwFbbvEpCa5m5BCnNMkPMRrLEx85VAbCCVHhHEj96//Jwvq1aFIoK7VvpLNAxkzrq0btYnX9IRnfmn1kv6VGYiVaosV6ITDx4zYyAIlZCUDWHbEk18qolKajgHVIuOs8/4n+XU9S453bdx5xvY2GuVdeSTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Merge commonly used code for counting evictable folios in a lruvec.

No behavior change.

Return unsigned long instead of long as suggested [ Axel Rasmussen ]

Acked-by: Yuanchu Xie <yuanchu@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5a8c8fcccbfc..adc07501a137 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4084,27 +4084,33 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
 	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
 }
 
-static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
+static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
 {
 	int gen, type, zone;
-	unsigned long total = 0;
-	int swappiness = get_swappiness(lruvec, sc);
+	unsigned long seq, total = 0;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
 	for_each_evictable_type(type, swappiness) {
-		unsigned long seq;
-
 		for (seq = min_seq[type]; seq <= max_seq; seq++) {
 			gen = lru_gen_from_seq(seq);
-
 			for (zone = 0; zone < MAX_NR_ZONES; zone++)
 				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
 		}
 	}
 
+	return total;
+}
+
+static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
+{
+	unsigned long total;
+	int swappiness = get_swappiness(lruvec, sc);
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+
+	total = lruvec_evictable_size(lruvec, swappiness);
+
 	/* whether the size is big enough to be helpful */
 	return mem_cgroup_online(memcg) ? (total >> sc->priority) : total;
 }
@@ -4909,9 +4915,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 			     int swappiness, unsigned long *nr_to_scan)
 {
-	int gen, type, zone;
-	unsigned long size = 0;
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MIN_SEQ(lruvec);
 
 	*nr_to_scan = 0;
@@ -4919,18 +4922,7 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
 		return true;
 
-	for_each_evictable_type(type, swappiness) {
-		unsigned long seq;
-
-		for (seq = min_seq[type]; seq <= max_seq; seq++) {
-			gen = lru_gen_from_seq(seq);
-
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
-		}
-	}
-
-	*nr_to_scan = size;
+	*nr_to_scan = lruvec_evictable_size(lruvec, swappiness);
 	/* better to run aging even though eviction is still possible */
 	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
 }

-- 
2.53.0



