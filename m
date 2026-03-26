Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74522106F2FC
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF5CB6B0099; Thu, 26 Mar 2026 04:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7E8A6B009B; Thu, 26 Mar 2026 04:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94A16B009D; Thu, 26 Mar 2026 04:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8C9D6B0099
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:37:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4E04913C0FC
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:37:12 +0000 (UTC)
X-FDA: 84587559504.21.BE8940E
Received: from outbound.ci.icloud.com (ci-2005b-snip4-3.eps.apple.com [57.103.89.144])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4C27412000A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:37:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=Jz94qwq9;
	spf=pass (imf29.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.89.144 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774514230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2sE/Uo/jRYYdN0UWH7fbR2fadJhnGzJnFLpQ50tGmpY=;
	b=sYj1NDDJVEcKoo9rbBYI4cW2SgXwepjRU/CFct+WenQzDLmrQ/mPZN/1BhX8eqq8SR0Xuy
	DBlY04/SOVkzbCrkKtQN/upw3lbpDFHYvXVt62nChJ9yOziOEIpCagERFBR0akuwarMBj8
	oa+wJQ+UcvE6mISzLCQU6xDh/qFPj/U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=Jz94qwq9;
	spf=pass (imf29.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.89.144 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774514230; a=rsa-sha256;
	cv=none;
	b=qp5MRvEa/OlDFGwKSdTOw0aD5YPoylGhjX1PK4xbXJV9AWCnt1jK0sBx89SKggtFbe+qIo
	BFV8vl8xgLkIscVmH1biU1abOAIqI1I8Vkt3ewYW8OzfTD4gwm4E9RF8Wzz+FnQy3lvuil
	EH2aJgcncJGWj9nWzmO3QKQkw6G8gbE=
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-11 (Postfix) with ESMTPS id D9FC51800105;
	Thu, 26 Mar 2026 08:37:05 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1774514229; x=1777106229; bh=2sE/Uo/jRYYdN0UWH7fbR2fadJhnGzJnFLpQ50tGmpY=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=Jz94qwq9j0IHKu/N8vYm3ygq1sXR3Ajy0TlZzgzLOUAWHyR3teI5gaGC4wY4yY5KlXbGe9Ae89KuvUWsVRX8Ag0Ua+L/WullFjQZ4Nf4AVmjmN7RhDc0V/Fo7CgBEe+yQD1GjayM6ZQfSrMl0I6O0sIAjEQziDnmjNWaA40qQ8XSV+G/p7f9kYSR5dAzBa/zGf+Q8rLovd+G8RiwqJDOQBJZCgA1mDruLa9kLKyBYfc8joSmqrkWde3uXUSEg1KXI7z9YxtLplgKM3HBKGVGUyUjm1iR4zXmO3o9bLmySRBk3HWL/7LqQnbvsWzjKxcjJNnWezAAwEpVhSjm2m7MtQ==
Received: from [21.6.122.162] (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-11 (Postfix) with ESMTPSA id 989CA1800101;
	Thu, 26 Mar 2026 08:36:58 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Thu, 26 Mar 2026 16:36:21 +0800
Subject: [PATCH v2 5/5] mm/vmscan: flush TLB for every 31 folios evictions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260326-batch-tlb-flush-v2-5-403e523325c4@icloud.com>
References: <20260326-batch-tlb-flush-v2-0-403e523325c4@icloud.com>
In-Reply-To: <20260326-batch-tlb-flush-v2-0-403e523325c4@icloud.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774514187; l=4560;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=ktO5LArnI4nbf2Br6U60uWT52jrGYKbMW/1pY1vTAV4=;
 b=5HDL+iwXk5ZIHMD2sHDZce2sXUi1l4PSUe0l6Z5PfKPVYwRpMTMNrzp29VSjzU6qUn0ziUt7l
 ZVtcZRrpVWEAiuoZccoBfMD6hFBPZjSQoM334EkFcOWbefUOQX5gF14
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-ORIG-GUID: _StyBDbCn9ITzjn54h0Q8v7dkMDMWNON
X-Authority-Info-Out: v=2.4 cv=eNgeTXp1 c=1 sm=1 tr=0 ts=69c4f033
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=w1dcpSADNQsu10hy-bYA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=R6HnoDE5lksTgPyyjrIf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI2MDA2MiBTYWx0ZWRfX74mX4e3E0Qs+
 AnnwNDs5h3WWcSYEiAHYUKvuiXNNIc6kqJgw8JzJBm0DjJWKP4ECo76VV7f4iigCpLlQIpRyaFn
 7YDDHFr91e82VwTdIMW7/SX0iu/jWiAQiRXpDO0SnjQrkTAJAc5OjRARrOa0rJlYvAsO6tBnIKY
 nY79MDfovOsc3K8VcoxQiaS5D9HTVEmzS6eA1TRDTx/SO7p+gy6nr+9jJN2I2uM49P2p9vLbjy0
 bM1lqgPKKr0WPcRityaKZBufgraOtRFyCY1irxd8YwTSsqbTuIxDMlqE0IlQlnF8kG63ZuwHXlw
 s7rjjxI8mZCnuStdnR0mjOGJ0ukyw9c4a8wxC7JTyMoXa5wfR/eA/voZGFq8yc=
X-Proofpoint-GUID: _StyBDbCn9ITzjn54h0Q8v7dkMDMWNON
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_02,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=716 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 mlxscore=0 classifier=spam
 authscore=0 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2603260062
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C27412000A
X-Stat-Signature: 39mmrd8tmba1mwitj68a7s6hx9cussft
X-Rspamd-Server: rspam06
X-HE-Tag: 1774514230-214774
X-HE-Meta: U2FsdGVkX1+Umjg2GQjRcjKei5t/alI9xz0T4HTc7dvS0BFW39/PJZKcWLBReQhl9dkmdFKOfrh/8mIzg8WqkKYUcHBH7zkkiLKoZwNPVVL1P+5MwYtVSWDegPaqQuHD5U5XD2ou9zvDUiK7fZZPawKXvckoQd3EUPJhCkOwNezg5YdRtvTRFnmrHzJ0IKvKEKMPL5opfomPZPkx9dHoSy4ZPBcAD/ukyeJRkD/8PXubsV5aaFnXAwEeQBS+FfbBMwZQQ1lDsbUFcHPuQeRBN5U5i8tPPvor0FMwU51wWpjUcSGyhJ+OJXXPKHtcGan20ammzuj9/vRFbNtdKBparnnmBBDfcIxlQTFum3ocpwCiB8HE4E4RkR8PpgDectJAjgvIxODrZzfuS5N1FiXi6U1imKwnnNX424PU4IsGcTuZklKHKSE9JmUJdeOf90NNwLEdEmeDYmMqE53BuVyz8n69XpR1f5Ly3uEaZgY2UiSAoD8WQ05/Jz3FM7M3eUrRlUNzFvmibBNkyVdb9x2Yl41yqs9gxKyJoPqnPFqJRwdE0tD6SCDJ0MrvarfqrCrKXWkcujeDlse1ZE3BKCDhVA3FyOtbjOdT495+XOUVLh3wM2UEwrcAkwBDse95ONNM6Vipo0nBGNylrwKvI+0jxMz62uf2GHcCPO2YewVHLYsThsKtdNbnnNr6gDM69SGgpeBlIDp4oaaOL3QLZzoud6XP/9aZyaRNZOYbKmnEV019UjazHX66MTHmdqMeLTOtsgwfPkckGzMsGHDEdo14EMxTwO6LHNJd4EM+e+nGdxkf7twnHLaowOlImaWOTdWoASczHlR+k9WL+soqYBVwFfYIR4K1KdXkAJlDGCUOKzgLyGMM+GRdlCqZElos8j/1Zhm2Z55KYEgjGnmE+euHr/xYgyIsKvSbBikni/R0QKuelHJ8oDta/d5aL5U0J8XTl9qfC7cv8DcEpPk3JDC
 CT2kVhbQ
 z0TSGhNQSIwa2qBJsqbC5KV04jxd7iW+dWGETwsLOV0G8irD0lTOhfduRIKiHPJnLc5bnhJxFyliem4lCTbQhXdW6bCb4OY9HqHF2IzSmpPV28y4IjeZPIZcbJGqohcqnwNlo/dCKxJN0QYcrir94bZRCMGa+QuhbfTB/cLBofWu4xuDYfTXtMi/bfZ4Z9rX/RdiXYV4wdUOvHQJNG96JMY0iRhQghhmTDzAVz3eLcU5S87KmCs1sEZ3aN/Bc7IeDVhD0iEjvyPyzd/2tBhJJchXT+hg4bwDa4rKvYxSKuAbKwvGW/Z5DPF1lRJow7002jB4T2SWWV9cWpcQQp/CfBmvPd63zLV+rldfGsIYFfTwcSD9SsYRYlTO9a7H7v21lQ5eYPTAC8xoqDX6AiLMSUCxintWM4D730hrbnxJiDC1PE0504Cg/BJ+SVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhang Peng <bruzzhang@tencent.com>

Currently we flush TLB for every dirty folio, which is a bottleneck for
systems with many cores as this causes heavy IPI usage.

So instead, batch the folios, and flush once for every 31 folios (one
folio_batch). These folios will be held in a folio_batch releasing their
lock, then when folio_batch is full, do following steps:

- For each folio: lock - check still evictable (writeback, lru,  mapped,
  dma_pinned)
  - If no longer evictable, put back to LRU
- Flush TLB once for the batch
- Pageout the folios

Note we can't hold a frozen folio in folio_batch for long as it will
cause filemap/swapcache lookup to livelock. Fortunately pageout usually
won't take too long; sync IO is fast, and non-sync IO will be issued
with the folio marked writeback.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 62 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 63cc88c875e8..27de8034f582 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1217,6 +1217,47 @@ static void pageout_one(struct folio *folio, struct list_head *ret_folios,
 			folio_test_unevictable(folio), folio);
 }
 
+static void pageout_batch(struct folio_batch *fbatch,
+			  struct list_head *ret_folios,
+			  struct folio_batch *free_folios,
+			  struct scan_control *sc, struct reclaim_stat *stat,
+			  struct swap_iocb **plug, struct list_head *folio_list)
+{
+	int i, count = folio_batch_count(fbatch);
+	struct folio *folio;
+
+	folio_batch_reinit(fbatch);
+	for (i = 0; i < count; ++i) {
+		folio = fbatch->folios[i];
+		if (!folio_trylock(folio)) {
+			list_add(&folio->lru, ret_folios);
+			continue;
+		}
+
+		if (folio_test_writeback(folio) || folio_test_lru(folio) ||
+		    folio_mapped(folio) || folio_maybe_dma_pinned(folio)) {
+			folio_unlock(folio);
+			list_add(&folio->lru, ret_folios);
+			continue;
+		}
+
+		folio_batch_add(fbatch, folio);
+	}
+
+	i = 0;
+	count = folio_batch_count(fbatch);
+	if (!count)
+		return;
+	/* One TLB flush for the batch */
+	try_to_unmap_flush_dirty();
+	for (i = 0; i < count; ++i) {
+		folio = fbatch->folios[i];
+		pageout_one(folio, ret_folios, free_folios, sc, stat, plug,
+			    folio_list);
+	}
+	folio_batch_reinit(fbatch);
+}
+
 static bool folio_try_unmap(struct folio *folio, struct reclaim_stat *stat,
 			    unsigned int nr_pages)
 {
@@ -1264,6 +1305,8 @@ static void shrink_folio_list(struct list_head *folio_list,
 		struct mem_cgroup *memcg)
 {
 	struct folio_batch free_folios;
+	struct folio_batch flush_folios;
+
 	LIST_HEAD(ret_folios);
 	LIST_HEAD(demote_folios);
 	unsigned int nr_demoted = 0;
@@ -1272,6 +1315,8 @@ static void shrink_folio_list(struct list_head *folio_list,
 	struct swap_iocb *plug = NULL;
 
 	folio_batch_init(&free_folios);
+	folio_batch_init(&flush_folios);
+
 	memset(stat, 0, sizeof(*stat));
 	cond_resched();
 	do_demote_pass = can_demote(pgdat->node_id, sc, memcg);
@@ -1565,15 +1610,21 @@ static void shrink_folio_list(struct list_head *folio_list,
 				goto keep_locked;
 			if (!sc->may_writepage)
 				goto keep_locked;
-
 			/*
-			 * Folio is dirty. Flush the TLB if a writable entry
-			 * potentially exists to avoid CPU writes after I/O
-			 * starts and then write it out here.
+			 * For anon, we should only see swap cache (anon) and
+			 * the list pinning the page. For file page, the filemap
+			 * and the list pins it. The folio is unlocked while
+			 * held in the batch, so pageout_batch() relocks each
+			 * folio and rechecks its state. If the folio is under
+			 * writeback, on LRU, mapped, or DMA-pinned, it will
+			 * not be written out and is put back to LRU list.
 			 */
-			try_to_unmap_flush_dirty();
-			pageout_one(folio, &ret_folios, &free_folios, sc, stat,
-				&plug, folio_list);
+			folio_unlock(folio);
+			if (!folio_batch_add(&flush_folios, folio))
+				pageout_batch(&flush_folios,
+							&ret_folios, &free_folios,
+							sc, stat, &plug,
+							folio_list);
 			goto next;
 		}
 
@@ -1603,6 +1654,10 @@ static void shrink_folio_list(struct list_head *folio_list,
 next:
 		continue;
 	}
+	if (folio_batch_count(&flush_folios)) {
+		pageout_batch(&flush_folios, &ret_folios, &free_folios, sc,
+			      stat, &plug, folio_list);
+	}
 	/* 'folio_list' is always empty here */
 
 	/* Migrate folios selected for demotion */

-- 
2.43.7


