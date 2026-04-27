Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4050FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0EC76B0099; Mon, 27 Apr 2026 14:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B69416B009B; Mon, 27 Apr 2026 14:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7D816B009D; Mon, 27 Apr 2026 14:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 897B56B0099
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:07:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1FD054026E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:11 +0000 (UTC)
X-FDA: 84705117462.03.D0DA4B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D7785A0002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=akxen9tU;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777313228;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3APnXNhbIActoMLZgnpKqtRbG/xM8rwsSygLvzv1Zo=;
	b=C9dWPXhdoIJAZt57IpfaKyyukAy36zauKnCQp9kPyyMYrz6J1DASIAf0Xc2E13SIyph18h
	CxgGeFULM5snUJ+dCcCdCnfdh98xduKCC9gCeIVsaK5CyMrhyQ4iB2of08JOpXK6z3a5h6
	5vpMLDxSTo+qBC2THAg1yQFUDvxhbAs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=akxen9tU;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777313228; a=rsa-sha256;
	cv=none;
	b=yjixQ/b5h2BPAE3BG2kPpJSXhguEpLIjPWxlkwzQJmU69vfxDeAMkPlut72V+wjiu6pm8K
	ID8Y4qds4PEtRsmtbLOcc9zH+IpU2a6YxiGMUIm/rbIA4eTp6fsC2v8wcRvqfCR/h50Xm+
	5MPU+Db7TRmAioaikcTaMWI261Qd1KM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 817FE6183C;
	Mon, 27 Apr 2026 18:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72E69C4DDED;
	Mon, 27 Apr 2026 18:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777313220;
	bh=fqzS+yy4Zz4+CewbZmc3fyi0n4VbFRk8JdMTnpxI1hU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=akxen9tU4EByj85HgnE/ncmuVpWc4mxVqF4HknmOgIIZxGNmh1ZfqdGmp6mikegXn
	 P2KnQjH/3pyBnnXbqojjmXr7PRQp/A+uAeH135OHBNtz7/FXbZIDpLA9+lSuuv4c8q
	 3qgMXHdz+N3A0YuQ79ZqNQtss+eP/u0SzOCGZsaT8NfpfZ2HOkUMK2g+My/5LQgMuS
	 FO8G+jGFfh6fDDPpduTuEW/t5bGOQ18Ynlzz1IjYfkIaO/rEib53tIhxvEEbrDuwIZ
	 uQttiXzKlOye3Y4NX5Vtd2ac1jfH0D5ALsOFsA8z4FnRWLsJ7gxxGc489MZCWsyWax
	 Lqln4NcUkH/8A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69882FF886C;
	Mon, 27 Apr 2026 18:07:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 28 Apr 2026 02:07:02 +0800
Subject: [PATCH v7 11/15] mm/mglru: simplify and improve dirty writeback
 handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-mglru-reclaim-v7-11-02fabb92dc43@tencent.com>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
In-Reply-To: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Kairui Song <kasong@tencent.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777313217; l=4415;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=cckLEz79VV56ZiUG6KqsWF5FQTcZVMYl+1QmaOX61Aw=;
 b=Msq+P7v0Wqp375X++8WEZ0cAbRUha+ShxY+d+gfHvEzcaVzUnT+EYNvFKDbjwPUNYw4YUcDgw
 IwxsBmE1TjZDAfal83WdqP9VxTv/KDEZe5o9XxCvkeeMGhS7ofcfow6
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 3kj8ss51abufb99mxturzdyjtkepjtfh
X-Rspamd-Queue-Id: D7785A0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777313228-828021
X-HE-Meta: U2FsdGVkX18PwwNCgm7b4OY7/rQuFsmSLN8wgGTBHw71eCaTONbMihE5WF29nBwxpSsdufXeNEPekENOrHCtcxhRheYbFP/kaL3km8Yh7ZhrCSgwPdlIiWOgl4Etftj5amt8Qun8KXf1sH5YweAeqSFSgdY9AH0Q03WEL6lYMx1qMDpd+bprj0FgLbVbawKyvHDB/uv8hsT00IWty8R7xFaYW4WKaZNYkVs4fatsvkhHOwdOZJVERMcC8ha/NLB6KCdIrYgJjoO29+lgevRrRNDQrmP6rlmgmmqpBhreQGT151pgd+MzrdQfIzhhAukTi4N+GpTK3WQIma33MOEp95YAZ1vPu6f4cu7CELBVN6ZzH5Q0xVUJ+VtFh7wfZRpeRQG08GfoxfNdR2kQhm3uoRkG+CpS8HRqm/m0FjaqRkasC0WQBdg94FAwHmWYVLlDLB4C+tybnIDMtZmyL5n2W0YJht3aYY0KwhTQNDTqkwU7Xw+IPR7HRWhSpXRMlEfDmpH4wqjcfdnboyqSRh3sJ/oz2QuUrTtzqWFJ3HkN4A0DjL+wMaMKJqbHpAJrJoQWEAHVHJIFsI1QilY/0vqYJhRxg0y4sLK2BZlecA5qtyIj8vf+PsXho1dJ5oRSBkuo9qDp0LC/sJ4DWHYcAJhuT4o8LKdv1hh3z6w70BBQrnsnD4hN7hbgPD9X4K+w5GwmS8Wen5SX7uczZcp7/BvGt9iaa/Pw1FLOUi2S0dNiG63oV+bnBtiCoQMzup9bPlSITpHuVhgyqkGupqJ50Kq5saRdOg/3wt2CqI98cDEVJnXsB1ORqf9ciFdv6V9LQ4WeVm8dTjA0GpYTgZ/oMO3chAsNasw9QqnXlMzzYQ8c7v3kKa7CPAKqJDK9gcXjJpZvMMAInzD0uVgnoEMBulGhQcrQg6DCkbGhPJao0EzOeDMR9UUDinTMY3fWa7gOprwSP/lO6LfeV4tNpHaETTN
 1fwqiCh0
 zOfue5CnQIA3yj78yYNam8Tfx8DBnMPRp5s3An0KkRpzJIV1MngU3eXyt0LI173Z5YFFAyvqjFaOGuZWQwxVu4C0UYC0TTOEocOUE8RNJ888mCQo0He1XKdhw2b1P/yO/pp0DMB8vZK2SUvdVanydtFPh7K1Gvy9egVag/zxCF9/h/dO8obIrY2WqeF2IK9agPgfjNuKG2JPNDoCLJPLWyRa66po6JmqM0oPwEXZjojHD7OWspsbXYJtSygOHHewlriAASbnS36GkTJ/yJBFHpe8o3LMSGdPGB6W9kJU+EZhfah7evvrxjw7vjI9GFzVAY3Cn7G/UgedV030PmrzU8SQhlefDAtw021Bsfpn/QaEXXboGW8opmSVfcBHH+pVSdTSA34jE4FGJYDC+ctLrpQJZfXDkYcUz7Wnb44jlotHpV7tyMmLYUTKS33DMgw1v+3uFgnZ6rdruhnsujLMnLXflX9hkEbFPKNTgrIIfM6WpLfFxvo5M5g8lpmaogXXU8dJPdOTbvJYRpIBR3QiTtvgv5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Right now the flusher wakeup mechanism for MGLRU is less responsive and
unlikely to trigger compared to classical LRU.  The classical LRU wakes
the flusher if one batch of folios passed to shrink_folio_list is
unevictable due to under writeback.  MGLRU instead check and handle this
after the whole reclaim loop is done.

We previously even saw OOM problems due to passive flusher, which were
fixed but still not perfect [1].

We have just unified the dirty folio counting and activation routine, now
just move the dirty flush into the loop right after shrink_folio_list.
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

The performance is a lot better with significantly lower refault.  We also
observed similar or higher performance gain for other real-world
workloads.

We were concerned that the dirty flush could cause more wear for SSD: that
should not be the problem here, since the wakeup condition is when the
dirty folios have been pushed to the tail of LRU, which indicates that
memory pressure is so high that writeback is blocking the workload
already.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Link: https://lore.kernel.org/linux-mm/20241026115714.1437435-1-jingxiangzeng.cas@gmail.com/ [1]
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 41 ++++++++++++++++-------------------------
 1 file changed, 16 insertions(+), 25 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bb7e2cecf48e..244cdae99573 100644
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
@@ -4838,12 +4836,27 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
 
@@ -5000,28 +5013,6 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
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



