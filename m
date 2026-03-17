Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FACAFEDA10
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 137E26B00A4; Tue, 17 Mar 2026 15:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10FA46B00A3; Tue, 17 Mar 2026 15:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB236B00A7; Tue, 17 Mar 2026 15:11:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD0626B00A2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:11:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68979140353
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:11:50 +0000 (UTC)
X-FDA: 84556499580.25.5B76B88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 55AA840015
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:11:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YmsgSrON;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773774708;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oHiwmi++mkU+2p/DZA7G5AgKZOV5iWqJLZMf90uw+fQ=;
	b=ZQLIApefOWDHg3w5pHChc427poxb+hqR1s63BrYUHi70gaKw7CqkXPo8t7Z2NQ49j2ZVtU
	qUHBMoQR/rM8KyOTGR40BCFxyl0Fj5IhlalmNXYPHrPn29MRdHrnuogEDaHB5/E23y9usI
	/H3chSouEFWn2MGIRxczGU2YL8oN6+Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YmsgSrON;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773774708; a=rsa-sha256;
	cv=none;
	b=a6Ck7l+DCYxvvgS6vIo0O/Qt2a2JkwJxCQUzEc0h0W9zYA9gbOYafenwj0ArV5mbzISfu0
	psixfjRW+LGSKIJXU2vAclz0Tx/CYYq63sO7EdcmUmb4i9HOgrz8G3zEn9qvBOTBZclwDI
	ONG4WJvzhjxyQtIz7mRXszk0Hf9t90U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F41B6441F5;
	Tue, 17 Mar 2026 19:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90C38C2BC86;
	Tue, 17 Mar 2026 19:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773774706;
	bh=CnIstUY5Q/01chAK/PuCysc+OIEgKv+HkD4lvTGxOcU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=YmsgSrONP54sX7S2MEcnV4BOHoKOPFoFqct6cUx/zDjSozDBCU6EIEYVw+wzhj+ze
	 3SIrvw9gPMpm/DPHqgVCUqrT5OM5fW5sjtiRHt8gC/i1gdGRTaaqPOC2o3zJowiPB+
	 +gDBrTBN9agKutXperhYZ9PKku7bQjS1a2GjbZKbzzFTgWgT0dr57IshHnGHig7FCg
	 ErTBJQfHSNpeZqARV5Hf8A0mqJ7sv1UmNtOAeLDti8fIg+aKT+2XXHSOZnqw3m2hHm
	 XKxQl+LtsEw3PilOZdQ1G7JxOtexBnBTtqlqEwYis2YbeG1BlZ7sfX2EhvGmFAJGGB
	 g6/LaKhGbxZtw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 825BDFEDA11;
	Tue, 17 Mar 2026 19:11:46 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 18 Mar 2026 03:08:58 +0800
Subject: [PATCH 2/8] mm/mglru: relocate the LRU scan batch limit to callers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260318-mglru-reclaim-v1-2-2c46f9eb0508@tencent.com>
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
In-Reply-To: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
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
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773774704; l=3426;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=fQOTRb1NWR0zmPJVNyY4mfywYbSd2CGKo+IRJ8AULGE=;
 b=mIJt8COJcbU+MtTkJSOMrRRP4ieSNiOL7KcyQ5FHr6Xc5vCR517gTft3XyzSKB1K6Nk7QbB+M
 A06MqUx0WHBBvYe+zdypVrrJKn6f+79LjqJlCgHq0gA0JpAYLbs8QhE
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 55AA840015
X-Stat-Signature: 4sm66xtitqtpgwwi5o6r68knxuwqng5g
X-Rspam-User: 
X-HE-Tag: 1773774708-498792
X-HE-Meta: U2FsdGVkX1+meS5Njk096lwO5s8kIdK00wDy5AXWY/B5V2xnWRegKl8QQI5Sl8n+hVXGdAvGa+8bs11zxlH8+8+CEM21jxhbFjU2PmjDAT43j2N7YGr5CeMq2j8BaKpfWmPP9QE/hMjGD982+fQVPiqXqw4x58oSQY9Et21dzjMTi2/XJh2JAbSiOWBrov2pOX+UeAQVSWe469RAquBEq/WZ5/MyBDPMB6+VZOHkD04iF/6AdXDQhYDJNEnCYf+lf+cYOrElnJg32r2Ali6TXqFxgRgIldUu6BiNiAusGYA+KbFTsTo2Mg9YXj87cPqm8CpS3KyAGeVWvrmioiT4v3YtmSqiU6apz7yznGuesP+UOAZZHYJJZUxmrw4nOtcyIZzpDqVtRlcdgNo35XnnYaiKhLPBcZnTIcmt2quCcCbCTvvtdkA+LtURFbhWFBl501cj6Kww+UN8h4aIduRxNgEcnJVB1QI4hsuOwCDZbIkyry5JucBMyrTnHwHVFdWNRZYzxg+AAIwj3NL4uSPUQIyCG4uciwh6bSfwwOgqCvBswBsXIfe8ZbowJCGPzvswhKsRqQZEFWqLJkLZzjYxv41qFd0V9vDePygRgCbYWc5OvXTAA+rrtTVX0ErLde2MHllxQS76lD4SP8Yim6P+a4sstNl2ywBdqit8XPhd/FY50PopIyvMHOImNpga2kBcgOwJd9qsKx7qbBFxLezcXvDxXKXSzMrBR9/r1/DT6WFT+6sbwgCuJvobi4czuFuugk2b17gePfQ3G+OjnbLWCqFbOorW1F2esA48vXB2YJLN03+ggbYjGKt6eu20SZrSZHiROxvBlei7RsTSccgDk2Yohbwn1JZ6quGSRSMITSU2eJezP2H7zMhmj7Di6WtYAH94UmdYpgxw4dHlYBUKGnYwENIQn3L5W/DCtqPnu4VkEZ8aLqCrrdHwew9S8lQ5ecQf/JFfJhu7VM0c1+l
 4pZZ0MAn
 C1KVyl1iNpbCTiOes+jdO2uGb3s4jfgJdbG/5e84RpM3aXU2WtR0KfQsiqB12urcJHDTPM2Ye6+Po8/hD/zb6T8H4qXRRoRNAuQ8mIIPssOtCLFDukjU0ZMfaR+OwL3QICx8rOexURpAwf/7dm8SKWce/033UTUVln/7Ups7B7pi3+SqRCLuW6Ltj+0GAjPZeuSUobp/LEdtVO2GQmX5DTip0DxkecA3iYXiMXGajrt6mWm8LdYlsziDvLQdsjWH0/F/FmeP8uerksF1Vv3E5+xvMm4LBm5Kv+PsUg8uYfVPyocTGqsPLI1WD3Lqrl0tM82p8cWoWo+p7p022A9NneqKcLSWeykJyNSeClI+i8luwZGwiiJC08shq7jnZ6scmGI51g2ah+acQWi0d6YQ8PdVvjmbWuu9voHtvQ5ObhFrSzlNA8gtZj4BX5CZUs+4VNrPY
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

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d7fc7f1fe06d..d48074f9bd87 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4689,10 +4689,10 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -4745,7 +4745,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	mod_lruvec_state(lruvec, item, isolated);
 	mod_lruvec_state(lruvec, PGREFILL, sorted);
 	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
-	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
+	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 	if (type == LRU_GEN_FILE)
@@ -4827,7 +4827,8 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 		*type_scanned = type;
 
-		scanned = scan_folios(nr_to_scan, lruvec, sc, type, tier, list);
+		scanned = scan_folios(nr_to_scan, lruvec, sc,
+				      type, tier, list);
 		if (scanned)
 			return scanned;
 
@@ -4999,7 +5000,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
-	long nr_to_scan;
+	long nr_batch, nr_to_scan;
 	unsigned long scanned = 0;
 	int swappiness = get_swappiness(lruvec, sc);
 
@@ -5010,7 +5011,8 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (nr_to_scan <= 0)
 			break;
 
-		delta = evict_folios(nr_to_scan, lruvec, sc, swappiness);
+		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
+		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;
 
@@ -5615,6 +5617,7 @@ static int run_aging(struct lruvec *lruvec, unsigned long seq,
 static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_control *sc,
 			int swappiness, unsigned long nr_to_reclaim)
 {
+	int nr_batch;
 	DEFINE_MAX_SEQ(lruvec);
 
 	if (seq + MIN_NR_GENS > max_seq)
@@ -5631,8 +5634,8 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
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



