Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F27CDFDEE39
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2158F6B009F; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DF316B009E; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5AF6B00A3; Thu, 23 Apr 2026 13:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CEDAD6B009E
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:43:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98070A03D9
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:37 +0000 (UTC)
X-FDA: 84690542874.09.C902139
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7F7E520005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RGI/6S9m";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776966215;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DN56ac2XCJSKgbTlu8k/h7z8jRY1j5Ec7QKZKFZER3I=;
	b=egKqtO2jlaq7B0t7vZeWXcaPQ9iMsk6PPRWA1jS6sjo9dTaZYDvWCtuZHiBSAx32CtIiCS
	v0iCi0J5whSaTuDGUgYu8FzeBtFy6T0BsTSMMIowgsDzK+voPqdYBHhsLjgASzW1WVxbxs
	F21RPzl6svTdBX/6OmABelm0y8ClEjg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RGI/6S9m";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776966215; a=rsa-sha256;
	cv=none;
	b=DZp991RdQx3jkBNJldxgggG2kynq9UcsYKlHm/uVYI3vctHgz6EpwsA6TWbC6Wm54IB/kA
	34GFNdEiEdf+zqMRIX+u60ghcy8HxMzpdV1Ivylq2sJtiBFaBYrGmcFFHvJLtfC1Hwq0bI
	TuOfbhrKjTzy8sN/20M1rQPLzkuCAP8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 31D024475F;
	Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 05BF2C2BCC6;
	Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776966212;
	bh=otkLcnfNmla34NBzMgC0+6D9v1VkExJNUBcQ2Wftj58=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=RGI/6S9mSpIxMbkiCagH72OXlQJssfeH1wf+sRGWyR0fxeZixTtjkvy3uCuebcu5W
	 HqxJ6JDaKbMn/xlyv3zI7oZn0HzILtisQsI3rhqgnUyalIJJgfTy3d+HzM0YNbDolM
	 LUzG4EoB6ZEvVddaMZwMxJAgokOhT0ca3fdXQ4KxRDDIJ0ATYQCcNESuanEkqRSizu
	 jOm8yYXVOAGke89AXqcML8CuGzbvjmlWD6mXPddfdHfFdtffMUjyEOTA135AygKW38
	 QR3t9iQqesA2WfdehWTxoy+9NZIG/M6RNgxbSPyNxGK9ZUzQB+Hne50TiE5GIl+0Og
	 XeO7SUYdN2ROw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF7DCFDEE3B;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 24 Apr 2026 01:43:21 +0800
Subject: [PATCH v6 10/14] mm/mglru: simplify and improve dirty writeback
 handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260424-mglru-reclaim-v6-10-a57622d770c3@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776966208; l=4411;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=XPufkC5dGXzX8uV7Cj2QhJr/PISwcv22HaMg1KGzKUs=;
 b=83TwcM7l6VCtXPRMNnDwwLNV5hfrHNISGsC8sWWxi+9iy1qcXg9Q9qRnWrBQNQa7TKdb26nlN
 fKGr8fkJKhcBakUzQrLDsQHdXCIqeYk2EY2lRLhlLvYdoskYdlVmxAH
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7F7E520005
X-Stat-Signature: bt6fsyeu5hdmpqnc1z8ktnhz195dwu1q
X-Rspam-User: 
X-HE-Tag: 1776966215-294078
X-HE-Meta: U2FsdGVkX1/Wq2qqS7Z7HqH7HKPO+pLQZTjMx6b07bNlybCJLn1uBc9cZ2son67QVEEYp6KXsS9gTrkZVgdzL2GkFajEqpZy4RqtV3QtdLO8tkD7DD962AS4VeoP3B9F+7XwRim7E1wC6xlb3O5/x0HKNzeO/h4juuMHkai2A4b0Rh4DjoYM4zt3yyYNLNyEuysD4dnJepRoG9PtM3LZXuvLrUXB8BDq8XdiGoT6bCvwD9SKt437RJmFRWKjBhuhzNoiOizeogra2LIfc9+/CyhE0p5tDC+FYx4Fv/XWwkBFobnuwhi3LEasnssKhXBbYQy/dZBA9gjCUQW5Bl69WJLeup9tXN66f3S/FM0IEfYYS9ueqEbnoSE6S6naoKAL9EFsTQN5hW8Bc81OL8g4Htt1IU4XFDQuvKFuUkQPTcdcG+qgMyTkIP/D6MuT3cZAxMiON126FvRUi0jJ0vvMHjwIZG0xm8sxda5X9SZfiRoWpu+CBv+dXi54G+/jD6DrMlNucCX1PJ2SBwuccIHMjxHy/XCNz8XsGWJAFfy4wf9LIbz44OYblvl98TM/YNfWhcFoFToblJlwLqtW871nj9gVr1yUdeT6PtQbtSjBQiL+Nz/TstICSdgl4NCNNMUD9FZUzoXG95SHeEqPmlfUbmWBiy0RGAvWpw++k+uvyr8+3j20OKwivKfkHQhjI4Do9MIREa107FobVMSsPgbZhLpejl/yuFVLkmnEhfOoCYwlVHKgZu/T9nxOZQWoksSzyyye5Ne80UxW1A9zoEN+nBTHGi4zhRDxw9ZG12s+WNeLmy+c3I4WEGI6GQK6OV7ZFAql7Tn27PuJhqQQ519K1eZhbOC2Fnd47PK3o1fe9RZCtJbh9WgI4hefHP6hb9lA/d1WzBQJk/LN4fEdLlLoyQBA8jNylZDHrZztrhOwFZhCNi+NBbWahyplFJRI2gElWXVUwNm4Ao/wpzrtEc0
 9z44gsdW
 LPi2plwiJlGSXJeBFSNHHIo3JOQ0e0UL6EJ5YUzaoYyadqRWNN7iXewhBZIZ3L4lumXo0fsOGqoKGGoCvYqsdqHmsSdbuBBTA3N9vBx4M7uJ/TRWeSkgqMN7RFkMS7bJFyznhnkgu3/LSGPcXqXdW73wnKGmRw7gdDzeIy10aoim1lnhxbkUMPS6QwfCRMtJ0rZfSSmN+J28quqTT7hWeJ2R2dWmiZGks3h76f32KmnIJQpQxHGYMK4uvruYi2wn/UIyXITRFNZLFd/L2KR8w/Q5QdZJHMP0H9HyVain99ApSPLyzvSqq+6+jpgYby5g9hGFvAAj/cafffvo1FAj77hSmepvthqwh3fhh396zMCNq0qKNEXConTr8e2BC8FzJyNS3WDxmFsqhm8QoukkQySz/GURYuKs2UffluOjSA2uu9ZAFDge6z72RCfLMXTtc3KrpsjWpdvbOSiPl/8E4hjiLUgGRfRzY5CUgWjOf9w74uoyoxHgYUeN8q3BttzK919c1G9SoY8uxVoeHHaRAtoGiWnoeBEZFa6cs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Right now the flusher wakeup mechanism for MGLRU is less responsive
and unlikely to trigger compared to classical LRU. The classical
LRU wakes the flusher if one batch of folios passed to shrink_folio_list
is unevictable due to under writeback. MGLRU instead check and handle
this after the whole reclaim loop is done.

We previously even saw OOM problems due to passive flusher, which were
fixed but still not perfect [1].

We have just unified the dirty folio counting and activation routine,
now just move the dirty flush into the loop right after shrink_folio_list.
This improves the performance a lot for workloads involving heavy
writeback and prepares for throttling too.

Test with YCSB workloadb showed a major performance improvement:

Before this series:
Throughput(ops/sec): 62485.02962831822
AverageLatency(us): 500.9746963330107
pgpgin 159347462
workingset_refault_file 34522071

After this commit:
Throughput(ops/sec): 80857.08510208207
AverageLatency(us): 386.653262968934
pgpgin 112233121
workingset_refault_file 19516246

The performance is a lot better with significantly lower refault. We also
observed similar or higher performance gain for other real-world workloads.

We were concerned that the dirty flush could cause more wear for SSD:
that should not be the problem here, since the wakeup condition is when
the dirty folios have been pushed to the tail of LRU, which indicates
that memory pressure is so high that writeback is blocking the workload
already.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Link: https://lore.kernel.org/linux-mm/20241026115714.1437435-1-jingxiangzeng.cas@gmail.com/ [1]
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 41 ++++++++++++++++-------------------------
 1 file changed, 16 insertions(+), 25 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 74255efc4ad9..d7a72a60c894 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4724,8 +4724,6 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
-	if (type == LRU_GEN_FILE)
-		sc->nr.file_taken += isolated;
 
 	*isolatedp = isolated;
 	return scanned;
@@ -4833,12 +4831,27 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		return scanned;
 retry:
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
-	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr_reclaimed += reclaimed;
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			type_scanned, reclaimed, &stat, sc->priority,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
+	/*
+	 * If too many file cache in the coldest generation can't be evicted
+	 * due to being dirty, wake up the flusher.
+	 */
+	if (stat.nr_unqueued_dirty == isolated) {
+		wakeup_flusher_threads(WB_REASON_VMSCAN);
+
+		/*
+		 * For cgroupv1 dirty throttling is achieved by waking up
+		 * the kernel flusher here and later waiting on folios
+		 * which are in writeback to finish (see shrink_folio_list()).
+		 */
+		if (!writeback_throttling_sane(sc))
+			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
+	}
+
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
 		DEFINE_MIN_SEQ(lruvec);
 
@@ -4999,28 +5012,6 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		cond_resched();
 	}
 
-	/*
-	 * If too many file cache in the coldest generation can't be evicted
-	 * due to being dirty, wake up the flusher.
-	 */
-	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken) {
-		struct pglist_data *pgdat = lruvec_pgdat(lruvec);
-
-		wakeup_flusher_threads(WB_REASON_VMSCAN);
-
-		/*
-		 * For cgroupv1 dirty throttling is achieved by waking up
-		 * the kernel flusher here and later waiting on folios
-		 * which are in writeback to finish (see shrink_folio_list()).
-		 *
-		 * Flusher may not be able to issue writeback quickly
-		 * enough for cgroupv1 writeback throttling to work
-		 * on a large system.
-		 */
-		if (!writeback_throttling_sane(sc))
-			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
-	}
-
 	return need_rotate;
 }
 

-- 
2.54.0



