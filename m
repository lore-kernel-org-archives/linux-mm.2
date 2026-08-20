Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE31CC5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 07:27:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35876B0098; Thu, 20 Aug 2026 03:27:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE5436B009B; Thu, 20 Aug 2026 03:27:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CADC06B009D; Thu, 20 Aug 2026 03:27:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A71BA6B0098
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:27:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1E1ED401C6
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:27:15 +0000 (UTC)
X-FDA: 85120816830.10.7DA4F67
Received: from mta1.migadu.com (out-109.mta1.migadu.com [95.215.58.109])
	by imf26.hostedemail.com (Postfix) with ESMTP id EE37C140005
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:27:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bA5LTkh0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.109 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787210833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=feXn9vdnC5bheeABHonzt64cz4IM+nL1fP1TXfxFU1U=;
	b=UDoi2ts+IWW5rZ3PUZQRZoAKo6XYK7uEopOpPYd+YNJMkVz1bdKPLhJC5QiFgbx37Fcid9
	NomMSY2Ddg7cNlPKkm8cZfSJesAFxlBwbDZXyKYgUGKEAXqb6NmoE9JmYCLL9rC+xdZMDt
	6o3Yh33txWZvnlUO+Fhcn3ahppNDqIM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bA5LTkh0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.109 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787210833;
	b=QHolEX5ZGmmH8O9Ize6qop3jYPdz+6mM0pIk6D5+pWEeswPa6Gaufg5ZzTkyBWeeckezNu
	jF7sbHCW1UiGZOitp4Lvs8MhbLG9Piyg0ep0h1DJC2O+V/fKifeFRnTK0Hkgj1crpqFSR4
	mIfZQn+RFNWeWZIK0l2KxNNcHrcEDoc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=T3OdxQvA2mkiYGw37MprnKiKHzYt+s6q7FUUCqndvrI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787210825; v=1; x=1787815625;
 b=bA5LTkh0J4EqhI25SNNg0dAx2Ho2Dg7Vy/RwhX+hSo1BeJcuTy8y4f0lmRg4dmaC2Hq8udOB
 shw4o19TlzRkE1tdPnWNsIo7cXp8KL2SFLU0yRiC/aMkL/Ow/9LusnLQgrG+N1V+3TIYXIWHFOP
 5ctFeDRqlKCFgwdRKrovqBgg=
X-Envelope-To: linux-mm@kvack.org
Received: from mi-ThinkCentre-M760t.mioffice.cn (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 5b40ec1e6038cfe3;
	Thu, 20 Aug 2026 07:27:05 +0000
X-Mizu-Trace-ID: 5b40ec1e6038cfe3
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Steven Barrett <steven@liquorix.net>,
	"Jan Alexander Steffens (heftig)" <heftig@archlinux.org>,
	Yu Zhao <yuzhao@google.com>,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH] mm/mglru: preserve inactive placement when enabling MGLRU
Date: Thu, 20 Aug 2026 15:26:41 +0800
Message-Id: <20260820072641.253591-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dzr6fxhjqhxjkqph8hes7cpn5c8mutgs
X-Rspamd-Queue-Id: EE37C140005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787210832-891193
X-HE-Meta: U2FsdGVkX1+f77KoYGy5kZhSvE1RUkcnqg+PyYJg57jk17TEQqwDAu2wTV0CQ/oSsaCWfGduEOh+t1rtUvO7kG2nMCqQTSZ8iSrrHEiY3JRRlCgnzsFvoXQatxz/Hne6lAiu/cJ2uNheYX4zFnixLT+tcXnZuqkEFodeYupuFIHjIRUCv8EJtJdkmNkoSZHwVQ4Zgq2/FOsQYTYBFH1e8C2mABjRdiqP0FpSaJADusk0q7EdshWvTuordpMFdedQvDnba5qWLkf8+vf6iVvR9yA2OFfllAVllgHA6dagEVwzZpwzfXGFN/7G6vO0a0Q9WKgk8MhQoE0Bb4AEZoVp4zulTKiYxnSxEfVAW2w1WLxdgk/V8goNYN7nQjLUAa6D1OOjYJr/0r1fQZT6sI5yr7v7fqd/ofDOpPFgU8gMsWqk1bAdHwtRPk4dfFq+XTS5rDsGKoDR/DUKFph75p4Fh1Zkia/F2VWrw3SIV9s3t9xgd/DMb6BdJsSk1dZqdmKKkne1eKCnAkjc+rk0KhNR/fWA0ErgKfTUCESYQ94cs3zEMRZJEaNqsMWfYDYgpok03f7WO6Qpp8N3jqJAS1odhhRy//e+j0jxDa42dnhV5tU0wdauWY3ZvqRxqhzMQQdG+1xnsHLQW7LN42EVsF6/9Ch7ruTatSGJqip4YoCn3P7OPjYHlm5G+0eAuWXXphwwacA2LalIG0phBPxMMzeAz4x6jpLRKqc43/w02XeW3X6TELYsjGiPns4hmglYZIeVCQyZr0hDAmr/hntD7VvtJvygoSET1SM3tZc/uOg4aEWcO/YRzPgtoCWlfnmiAhQo3dbIPWYWNWONIHtvvScyVJDktCb5dfjqOLtxwZJN71eW7ONAbC5n8WbbwoXOuVPiumOK168n4aOSlz/nRLmVhFFCF3jHtjL3tC57KhQ6FNj9eiHgAvpIX8DX72D4nWrSFH5osZxXyJWe1/pkx7b
 GZkl48Ik
 W9D8p1bL9t9MzicWV3gOsP2NW4wfVHPQVapC6Uvxp3stq/DME27bLhFnvBa+cZ8mx2GSLCFYc9jUB0eftsQcGs+qfClYSpTtrDywrM21ED5INvQGwCM/NFSVTZq4j5rzU8hPH0fclR8B0+es+NaDVwLMJ480yWyfT7OckSBL/fylnGWscRHE9d43f9oIHB0GpEIMo+pTZB0qR0xwU6tdMi2mCrGpc7XSDho9MYIvtiMd9A0IrENHzOWqP/ZqIXFEf9e4ZlTLxjd5gNQYBFj4uXNtgKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

When the LRU is switched to MGLRU (echo y > /sys/kernel/mm/lru_gen/
enabled), fill_evictable() re-inserts every folio via
lru_gen_add_folio(..., false).  With reclaiming hardcoded to false, an
inactive anonymous folio (no PG_active, not in the swapcache) takes the
"gen = MIN_NR_GENS" branch in lru_gen_folio_seq() and is seeded at
seq = max_seq - 1, which lru_gen_is_active() treats as active.  Its
inactive placement is lost and NR_INACTIVE_ANON is folded into
NR_ACTIVE_ANON.

Pass reclaiming=!active so a folio from an inactive list is seeded into
an older generation.  Folios from the active list carry PG_active and
hit the first branch either way, so they are unchanged.

reclaiming also selects the insertion end in lru_gen_add_folio():
list_add_tail() for inactive folios, list_add() for active ones.  Both
the legacy LRU and a MGLRU generation keep the hottest folios at the
head and the coldest at the tail, and reclaim takes from the tail.  To
preserve that order the folio must be taken from the end matching the
insertion end, so take inactive folios from the head and active folios
from the tail; otherwise hot/cold would be reversed within the
generation.

Tested on x86_64, next-20260812, 2G VM + 1G swap, ~1.5G anon pushed onto
the inactive list before enabling MGLRU:

                         Active(anon)  Inactive(anon)
  before switch (legacy)        2952         1548792   kB
  after `echo y`, unpatched  1552052               0   kB
  after `echo y`, patched      15144         1536636   kB

Inactive file folios stay inactive either way (NR_INACTIVE_FILE is
preserved).

Fixes: 354ed5974429 ("mm: multi-gen LRU: kill switch")
Suggested-by: Barry Song <baohua@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 94fc4f25e99f..7be4cec9a838 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5311,7 +5311,23 @@ static bool fill_evictable(struct lruvec *lruvec)
 
 		while (!list_empty(head)) {
 			bool success;
-			struct folio *folio = lru_to_folio(head);
+			struct folio *folio;
+
+			/*
+			 * Both the legacy LRU and a MGLRU generation keep the
+			 * hottest folios at the head and the coldest at the
+			 * tail, and reclaim takes from the tail.  To preserve
+			 * that order, the end we take from must match the end
+			 * lru_gen_add_folio() inserts at: inactive folios use
+			 * reclaiming=true (list_add_tail), so take from the
+			 * head; active folios use reclaiming=false (list_add),
+			 * so take from the tail.  Taking from the wrong end
+			 * would reverse hot/cold within the generation.
+			 */
+			if (active)
+				folio = lru_to_folio(head);
+			else
+				folio = list_first_entry(head, struct folio, lru);
 
 			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio) != active, folio);
@@ -5319,7 +5335,16 @@ static bool fill_evictable(struct lruvec *lruvec)
 			VM_WARN_ON_ONCE_FOLIO(folio_lru_gen(folio) != -1, folio);
 
 			lruvec_del_folio(lruvec, folio);
-			success = lru_gen_add_folio(lruvec, folio, false);
+			/*
+			 * With reclaiming=false, lru_gen_folio_seq() would seed
+			 * an inactive folio near max_seq, which
+			 * lru_gen_is_active() reports as active, so its inactive
+			 * placement would be lost.  Pass reclaiming=!active to
+			 * seed it into the oldest generation instead.  This
+			 * reuses reclaiming beyond its folio_rotate_reclaimable()
+			 * meaning; it also picks list_add_tail() above.
+			 */
+			success = lru_gen_add_folio(lruvec, folio, !active);
 			VM_WARN_ON_ONCE(!success);
 
 			if (!--remaining)
-- 
2.34.1


