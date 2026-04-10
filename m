Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C966F44857
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0111C6B00CE; Fri, 10 Apr 2026 08:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2B0E6B00D0; Fri, 10 Apr 2026 08:44:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E40436B00D2; Fri, 10 Apr 2026 08:44:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D25A26B00CE
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:44:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 918CD5923B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:44:47 +0000 (UTC)
X-FDA: 84642615414.12.3B04A4E
Received: from outbound.st.icloud.com (p-east2-cluster5-host4-snip4-2.eps.apple.com [57.103.79.55])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6D6E54000B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:44:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=fdstTdwU;
	spf=pass (imf27.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.55 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775825085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qmoarnu2fjz9QcThGpQzSg55OCBVK8r4IXQdeVfdm94=;
	b=Iw6oQ2yZTPly36REyyGGS742xduPJQ9B+5H5dG75IpGM6EIWhtY9gWmPKKWvttyfE5qO6X
	90ExG09snAIgUl7Cj+iDO7Uy3nlmp2pR0YDx8NcpZ/cGWbVGfGEZfzNtKjvQ9cNkmRDeDy
	qpCqc2yKDUY8TQBtuh0cs1XqKJX6TdU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=fdstTdwU;
	spf=pass (imf27.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.55 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775825085; a=rsa-sha256;
	cv=none;
	b=RyRG2avg2fDKgrALFORTVmDTv3Wm2r8KSHJq2jjfzl/UECGQw41usL4IAGPvv+Tnrdrb7w
	64wm2825nu21oDPi+MguGfxz6AF8TdZXH5aCqMJOrqvM157aRbRiPPPz2xJFVxpeSnJj65
	+NwEynSubnMIHaySHj/bNRmPaTDi80M=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-0 (Postfix) with ESMTPS id AB8DD18001BC;
	Fri, 10 Apr 2026 12:44:41 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1775825084; x=1778417084; bh=qmoarnu2fjz9QcThGpQzSg55OCBVK8r4IXQdeVfdm94=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=fdstTdwUGP6oeoUNcImHxlaPOWSy2m8Md9l2vIg8ASn4eb+f5+4MIvRK0L47tyzltg/3qVmQLIQJ5aJtCFbp7DpzJjal3qR8sZFjs6zVkkVgkK22JsCUGJnQzCWTQNQufOoynnrV4w8qtglgSGm6/u4nqb2dTFGYEnAhqjQ4IxbK6PeAq2bkoFpNmJ1SlehiAD1WQrgOM5fxI2gILCsJ6WJLlu0DhanWnBzQJKGjCGNv6ZmgWCtZmp49PNVzYRWnrv3mOEh3bVmUMDWnlLNLGB2DBzmNtOx14ALlas/wRpKBXTOjD/NOY75NF5vrDQ18XuPRu4dfK+WQsqiSBaHCUg==
Received: from [21.6.122.162] (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-0 (Postfix) with ESMTPSA id 4B5071800371;
	Fri, 10 Apr 2026 12:44:35 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Fri, 10 Apr 2026 20:44:03 +0800
Subject: [PATCH v3 5/5] mm/vmscan: flush TLB for every 31 folios evictions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260410-batch-tlb-flush-v3-5-ff0b9d3a351a@icloud.com>
References: <20260410-batch-tlb-flush-v3-0-ff0b9d3a351a@icloud.com>
In-Reply-To: <20260410-batch-tlb-flush-v3-0-ff0b9d3a351a@icloud.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775825044; l=4434;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=IgHhHeddVtpb8e5HB29Ud1Cb4p7uaarC/SsI4SxrvPk=;
 b=coi4Y6VtXZfeKDBO8TUliE567FShmsMAgOmtlebee0aTx5oghQA/KKOtOzsvTdKWkc7SH58p7
 OndkCNYXkKtDYcJQ+XPzEE9N0COL+RlZ/TGpE6NhFmcdZpq3T5L/0AT
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Authority-Info-Out: v=2.4 cv=GOwF0+NK c=1 sm=1 tr=0 ts=69d8f0bb
 cx=c_apl:c_pps:t_out a=YrL12D//S6tul8v/L+6tKg==:117
 a=YrL12D//S6tul8v/L+6tKg==:17 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=6QAaJVoE38gftqD1B9gA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=R6HnoDE5lksTgPyyjrIf:22
X-Proofpoint-ORIG-GUID: Z71cGpqHke44Ul61rUpscVntrnPPnNZ8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDExOCBTYWx0ZWRfX05YzfSkSvbtj
 0IAzfoVHAhGIrDpFkaPrXZKkKPeZKagS4oobIsTib6TkHTyo3U3E6OuPzoTBiummaKDMO4upczb
 lG9RTsPgHrNJnBaS/CuQV/rmz4OEG9UzIIvMvfU7jLjsgdratuR0N2YzbErmDCIvm5lsnanTWP3
 sJNvI2+6+K1VymDlxmFThvxC5AstkN0nG0znciL4g/401HHKVIJLQuqcX0Jf4cVBEtN0X1yjIOU
 Jl1nCCGFnzamaIeMSObv107r6HkOR59raSlliQ7ksFRCwmtjTJYgZI377EiLHO27CwaJYTZjqqJ
 SjdG3M4JV6PIVMqUGJjZlpnnZHo30iLJSJHqRH92QkSvH/jEAl4ofC/+ORnS9w=
X-Proofpoint-GUID: Z71cGpqHke44Ul61rUpscVntrnPPnNZ8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_03,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 clxscore=1015 spamscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxscore=0 mlxlogscore=505 classifier=spam
 authscore=0 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2604100118
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6D6E54000B
X-Stat-Signature: u951oyre7tqysbqkets4eg7w6torxtq5
X-Rspam-User: 
X-HE-Tag: 1775825085-346131
X-HE-Meta: U2FsdGVkX1+kgIs3LqvX6G5VvUur0lQOoPF2lgpJfdembIl9gN/Q+a6sljQp+CvGeTEYQwkTPwltxBa1LWga50+O7DjGcvYZGMJCOmmj9h8ySYLmbS0yqITmue3qxcVep1enGaW3e1oneDKU8xmBI98cwT9rZT8QiieTeTAvpDvW0bKXs6sy7GF7fPEuDi/4IAE9zrqjXdeCyvrB/oOsl0XtLznzYo8Cxqz3gQ6Cb4okqRGbxRBes4kUL8eWoK1RjnAsAkJbQdkpksEyYbx6f1RuqvbOQ+G7Sho28xr9AOZ6THPzQdr4a/+3CaFT/cxcQYj1iWQKwb4+FbXbUbEpJe4WBDBXf5PBuiJBUs+SBlpTVV2S1tveqAPaGq8y8qWVZ35+8LYtvySidVtDtZxT1EPKjGGxU+kAmu2RXvfsYYCwY2jFqczeF+7a2Hza2kTjnAOe2dP4lFZ+tmY66ZpD9+pFjGBhuvxPFgdzaFnYaV5IDfW0MC5u7H/G04oeSzvciEUzWmgGFndy8h6dDD1qq0Iej/d5e4IwhQaHnN9egTEb68En1PfLxGpO5K3GBtaqw7cQEE07DpbnrsyAe2O1OadfxWZihoZj4Kvu3MtrciUhRKqEz2K/QC6tNMgtrsbI2s8yTaoS/Zx7Otx79/A1fQThlROJslY7YA3wfwD89Ed3iJSHtryOQ7JpYpddj6cUd2RMvmFBdVDFUlD8b6nDm32Itu/sYvXY/BPDY2Gj+N4oAE4O2UtD/4qmuCkdCI0OHNS254gAzHtVcO1ojQfAe2CjD/XduaJvOCdzbaY+muUhVozLxsjMRWX9IfX8YZCG3+Ti1vzw2mFiMJ7K/6hvYccY0FyB8THvzKP+r7oMJ/GK52G05EBnnUpuZvWTBv0uK37myFNA4hKcDtTFuwmO7eWqW2eTE8M5dIfVoAQKufcOAFnJgA5LTQFevUoBdObsE5beIHXjnfXJ8FwTjDt
 Xg5eN9uF
 pS182khoXUSYvsiL5C87LRwhuIimpJTwuBZnk85lTaJvzcULEazrF6N1uK89lMN3ocCsPNtW6yBitcMjIlVTWHOH2/pH9u0qnX8IBDy6wDLaEY05OSjjeLuM+wxLjG6cTRKciUUnK1swRyITPO+Wv/DJu9EZwckyqdzBSI8JbCDsyjyuZgqrX1X6sPBAKj7LTHJsX4HUan0KxgUvm5Kma98PCm1pDcq6iwQLQg42F9ACBOBD18mr4lxNbxWknfrfbmDZ0WUVooorSLpBXXAGiRPZT879KPZgMyHlNE4lnoJXmgm+yhqk/EiNX9freHaJORke31AftETnjYloeOehTAI+rzOW7mXYzJ+CwJRFaQD/kszRt67YZ4npHzukAUoDgIsBBBixPV/26/MfupLRBCvVUjQNasp3wgKKiHslt0hUhQW/q4SYhxVarGpEH/kimDrWJHac/j8k8NmN4FgL1ni51pw9ap6rdq1eHf6SPl5wY5TozU9s14X3d1ggO68suEEuZDoInk3RAxLmcMGJ/kJwNQA==
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

- For each folio: lock - check still evictable (writeback, mapped,
  dma_pinned)
  - If no longer evictable, put back to LRU
- Flush TLB once for the batch
- Pageout the folios

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 68 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 63cc88c875e8..8d18e1c5b53d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1217,6 +1217,55 @@ static void pageout_one(struct folio *folio, struct list_head *ret_folios,
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
+	/*
+	 * Reuse fbatch in-place: reinit only clears the count, the
+	 * underlying folios array is still accessible via saved count.
+	 * Filter and re-add valid folios back into the same batch.
+	 */
+	folio_batch_reinit(fbatch);
+	for (i = 0; i < count; ++i) {
+		folio = fbatch->folios[i];
+		if (!folio_trylock(folio)) {
+			list_add(&folio->lru, ret_folios);
+			continue;
+		}
+
+		VM_WARN_ON_FOLIO(folio_test_lru(folio), folio);
+
+		if (folio_test_writeback(folio) || folio_mapped(folio) ||
+		    folio_maybe_dma_pinned(folio)) {
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
+	/* Clear the batch for the caller's next use */
+	folio_batch_reinit(fbatch);
+}
+
 static bool folio_try_unmap(struct folio *folio, struct reclaim_stat *stat,
 			    unsigned int nr_pages)
 {
@@ -1264,6 +1313,8 @@ static void shrink_folio_list(struct list_head *folio_list,
 		struct mem_cgroup *memcg)
 {
 	struct folio_batch free_folios;
+	struct folio_batch flush_folios;
+
 	LIST_HEAD(ret_folios);
 	LIST_HEAD(demote_folios);
 	unsigned int nr_demoted = 0;
@@ -1272,6 +1323,8 @@ static void shrink_folio_list(struct list_head *folio_list,
 	struct swap_iocb *plug = NULL;
 
 	folio_batch_init(&free_folios);
+	folio_batch_init(&flush_folios);
+
 	memset(stat, 0, sizeof(*stat));
 	cond_resched();
 	do_demote_pass = can_demote(pgdat->node_id, sc, memcg);
@@ -1565,15 +1618,19 @@ static void shrink_folio_list(struct list_head *folio_list,
 				goto keep_locked;
 			if (!sc->may_writepage)
 				goto keep_locked;
-
 			/*
-			 * Folio is dirty. Flush the TLB if a writable entry
-			 * potentially exists to avoid CPU writes after I/O
-			 * starts and then write it out here.
+			 * Unlock while batching: holding the lock until the
+			 * batch fills would stall swap faults that find this
+			 * folio via swap cache lookup. pageout_batch() will
+			 * relock each folio and recheck its state before
+			 * writing it out.
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
 
@@ -1603,6 +1660,10 @@ static void shrink_folio_list(struct list_head *folio_list,
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


