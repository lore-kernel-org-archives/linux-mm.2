Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82CBEC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 04:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2882A6B0005; Mon, 13 Jul 2026 00:50:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 238DE6B0088; Mon, 13 Jul 2026 00:50:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14EDC6B008A; Mon, 13 Jul 2026 00:50:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E21B06B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 00:50:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 712B8169E96
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:50:29 +0000 (UTC)
X-FDA: 84982527378.04.AB30A53
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf21.hostedemail.com (Postfix) with ESMTP id 477BF1C000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:50:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783918227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=prN5SjNHBGcVKl0owdtnr/47J5ZN/L1i5v5brtwHJ2k=;
	b=Yk2HIyHsN2SQKwItaWu0FOat0gPhe51zgzpactzNTju3cGdlt0WUhoBoAwXuA4FCptJZ+M
	lBAWH/ej8Dbz6a1fAFPlVuiFR/Ov21ptJKLVihojtoZwE6OfTtWh6nDsLWTBzD+aYwRvgk
	dlnYM1EdDRluwVlB+7SkbHF6i7rmFv0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783918227;
	b=BGyk9+OM5nk4NboVXtYnhr+iSrFdx0q37rnz/Je94iC0DYHPNUb9b6HGJFCcrMzko4Jczk
	r7ZiPVXtMuAWr5cP33+FxIBHbiMqgav0wF9s0+U+MlML8RFtXghFJ1XhfkYJNtV5nQo+Of
	0RNyGIONjMvFg7oNyC5VRrgBOTc3Plg=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 13 Jul 2026 13:50:23 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: [PATCH] mm/swap: clarify unreachable cond_resched() in swap_reclaim_full_clusters
Date: Mon, 13 Jul 2026 13:50:14 +0900
Message-Id: <20260713045014.219653-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 477BF1C000A
X-Stat-Signature: w3htrh3thkqrjihf8x6u4dyinfxx3fpe
X-HE-Tag: 1783918226-486548
X-HE-Meta: U2FsdGVkX1+Ngw0vvZR2bkyidN6T9yf3VJLoz1dbwASYfE82bDlrJGI+BULfzL6+P1dqVqmIgvSzQ1vRnYU2FgYA1aWV1jYW6O79AlSnGoSm5Xcfw103T5zceTyRCh1+Wj1+P5NmUGp9CmgrT6T4S5952AJE5Yl9wtynuIpt13hs7FKPlHbsiP2CRVp0wh4loKaoIfHAZKpV6xAuyGyd+ckS4YaG7v60e085grEsstMmQYUT/o+3sSIWBEnRpZlxjO2ii7FtI80XcuTPJpVqaNjQHFbAkZXPTgO/GRaqA8VW4dDqagea3mgO/qu4ObqdtH5I+n9qzAUJuGM5czxq5UIg0IBUgknYqMN0CQuHq0begQaRsgF0mKudG8A2har6DjQwt2+10y0afNUrIUl82GsMtxL877Au5qcQm0A+7ASMrpFX8UMorWScJvTB+0SbtkX9beM+lVc6ucoikBhwt3A0P7LZ5BpvlF/gswaULW4MSqZMK9b1fyTPw9xqG1NWJhEr6CJIk6OlHn46SSakZfrO7btTqygm9Ug3A5u/kZG677+66KdlBFWqWHdneSzGxYWwInFWdx9ux4JaiMH1gMg1EQroBZYJI7vyCy8kmarQVPxEaMajXI8NkEFphjoO5DI5TzrS4MTt8p8ke6qeUHUSByivsS4/7kPu8e/qnOo1gzq1kyLwnD5Wvx674lI7qrBAGc95jtEyNjuj9SdKJ4HLdcxDsQtS+b9Vmo/8s+McZXuQ0Ld23vxByEYhM0oiFTme/UtN4dvNqlx1f87ipHtULcMxcp8zY9WNvyaiwzN8YaXF/R8wAMkcgdsM67CNUOTrukrqD/f99z3kSRun8K2ljfA57w2VuBomL8tMIsu8bh4NqJFi1HlIrqSYGNtJgiT41KHlbVmr2dz/V1yT9wY6weRHqazs1cYqEQwvJO5OLQcGFuuh6mi6iZ2KalVi7jFzEF2UmbpWMwJEjjF
 ETI1NI0j
 yDyKnGD5pcqe06+67kKetT65T0FwxDxaFjxLdjkS9mza1+qpAW/vXBA7uHdqpzcOpmg7wu+U8PefgyxsdyZlNMMhPOtbmV3j2SASboJFDD6MSijbA5DJfvzsRwmGsdjPmv4mXncpMFUMSc21iKjQmWe55Ue6v8wFFmxQl4DJzDSeq13qECn4EiMeadsaNXHS92+NXog6e1ssK05/wyVaf/xBcuhQmIaflI6RKnBXwQbkizSyJqoIJUlWmQvzmuT6JJyFb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 66366d291f66 ("mm/swap: add cond_resched() in
swap_reclaim_full_clusters to prevent softlockup") added cond_resched()
to prevent soft lockups during heavy swap reclaim.

Currently, there are two call sites for this function:
1. swap_reclaim_work(): called with force=true in a workqueue context.
2. cluster_alloc_swap_entry(): called with force=false, holding a
   local_lock and potentially a global cluster spinlock (atomic context).

In the second case, calling cond_resched() would normally cause a
"scheduling while atomic" bug. However, it is currently safe because
when force=false, 'to_scan' is initialized to 1. The loop decrements
it to 0 and breaks before ever reaching cond_resched().

This implicit dependency is hard to notice and recently triggered a
false positive in AI Sashiko review.

Add a comment to explicitly clarify that cond_resched() is unreachable
in atomic contexts. This improves readability and prevents future misuse
if the loop logic or 'to_scan' initialization is modified.

Link: https://sashiko.dev/#/patchset/20260713025644.170839-1-youngjun.park@lge.com?part=4
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 72952491e9cf..00b5fd8683e5 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1072,6 +1072,12 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 		swap_cluster_unlock(ci);
 		if (to_scan <= 0)
 			break;
+
+		/*
+		 * When 'force' is false, 'to_scan' is initialized to 1.
+		 * The loop breaks above, making this cond_resched() unreachable
+		 * in atomic contexts.
+		 */
 		cond_resched();
 	}
 }
-- 
2.34.1


