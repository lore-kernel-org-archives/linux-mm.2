Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE5CF606A325
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 02:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=baB3S6gF
Received: by kanga.kvack.org (Postfix)
	id 0C4896B0122; Mon, 19 Oct 2026 22:36:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 075EF6B03EC; Mon, 19 Oct 2026 22:36:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA6B86B03EE; Mon, 19 Oct 2026 22:36:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AEBE86B0122
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:36:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2B85D1205A9
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:36:05 +0000 (UTC)
X-FDA: 85341439890.16.61C1264
Received: from mta1.migadu.com (out-166.mta1.migadu.com [95.215.58.166])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4B40D1C0007
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:36:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=baB3S6gF;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.166 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792463763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xkGhnhY44K2J1OBQ/8hTDyBxqBV4vaK4wkgxii7kUUo=;
	b=OjYmkNOx+6N88TIwQkJ0gVFOos72cwS5DDtPojMBcnGIrUmsa1T7sjYgJ99hdcLZc2W68r
	mvapuV7Sk5Z+Q8X5G2jW7afECSpxZIEyEh2FF/WrYn22fiOHsj9EthOdX2XSckh6TVfOgL
	GnvtIWOf3W6hHDOdJcsDfoKUJCcsVp4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=baB3S6gF;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.166 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792463763;
	b=im1BYHAhSAnxVq2GNV6WBktNJLwom4OWBzKV9H08oP+ozFs6yjJSD38HhAnxjKkwpxWvwJ
	IJr5coUw+1eCYHih3IrST/eyWDPZXS5TPQp67YpwdV0ux3paDPi/qc80JynVAWIIZ1fTcd
	T6Rjgv+3y/FYQY9L1gCw391y+JlxTq4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VsTbGfpp4irBeMjTHpzRqpN9dSM7uDhmL47sNU/lgh8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792463761; v=1; x=1793068561;
 b=baB3S6gFMdIWH3TskBvOzxIYK54c7b7kgB9p0vLO6E6qpm5U3l6Q6Z5S2V4Lk8C60PBJDjmz
 xeVuQzpJmWm88LjuDtBmrVjaBUzRSyo5xykOx/Z0ix8Z6mu0bEg4M0hMsbUjDhPH36WCtx0uvA0
 J80nSEuu+E75QhqNty3KgotY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 72d5ed4ea47801f3;
	Tue, 20 Oct 2026 02:36:01 +0000
X-Mizu-Trace-ID: 72d5ed4ea47801f3
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH mm-new] mm/mglru: clarify the generation placement in lru_gen_folio_seq()
Date: Tue, 20 Oct 2026 10:35:48 +0800
Message-Id: <20261020023548.3242028-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4B40D1C0007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bmnu4kre9ns8ft5izhngn8xphy8fxx7w
X-HE-Tag: 1792463763-285109
X-HE-Meta: U2FsdGVkX18QCjJNV+xSmziosHxB3a5jszBNDyB4iiXi+2qlxAqglrBPimph16AsziW07UTnoJUgxiECMcxoFQmszt5OhiAfmQvhls4BsKx2z2GZ4apQ7J/pcoW/mjgLU+o06CK3/NEnOcaGMYj8KIyHE+Cd/haVDVsYbcW5OYfCd0rfxhSgHHaStPlvZ//vGdjCTK8YqRrPM8pY69v99SBQzjfw26Yw75DJm/Iu2AQ2qVBtUHjdWsBag+jG3Bh5A2J6TaPxE5PyuEnyT5PCFvJMy+JI5fidEyiEJ33kChKRdJZXDldiErcGTxtZT1c/MMofJYy/ubZ2Z/0cXmjQkv6UbfCeV1GvWg7MoncmErHgxRr5DpfuI7S9KPnfVVSvSYgG37CUDuGtwLj1d5h//5KlQnyxSy3Q4Rz0D8EHZO4S1v7yzetW6U+jfX+SeWvA2A3wUpBHqKxPITlgl/kv7GgJPuC3ZCfcJ+EvD39S7xCdfjaEOkjTaatCWKdRKwEB6zXmIBPYWJY19mN24NC3H5EPOQA1s/xj97bekVshOqfsgluArxbEkh4eskQ9fqPI6GnWcV1viR9Vdt24i6SrCHAYCZvSs5k1w+Fw9ou+IdGCqjqgX7ai8zWbay9guf73kgDEyoU2P1kEhOo9d3+fq74Y9eQX+4OUrPzwLUCboEwPKxAttxxkMaQfAuvnppxkiUDQX1XK9r6K2DDREfsKIfe2/YHqvgPASV3TZDCGYqvX7mUs5H2MgKiYfSXtMU9gP/KzvSStfCh5uSBnS4xV6lntZQgiacPUXyjmFFk+F0pySegHcAvCosuHiJyCMKDHi6WnvhSTe7RnjYKz986TFMSiSBr4VR6TEGgIyUkJ0DfUDPFKft/j8e75/aijW4DncWRjD6KJONGi0ew0bxaoHV/7IsHh6eWn6ALOcfnMaFL6Aqhl7N6Jw1KrfhsBzzFN044f94VBkjseR4ymfPP
 5GF8G0Lk
 +ekFU/jYwkKz3KONbkyhmO1s2zAZKmbw1DaOxChY1TP0MfMC+Ij2Tzf2A3rMgVJ4opMV57lu097EVCnHyKCUHxsOlR5OyMSZ7qQB/vvwNJD9O7uuNp1duH9yIkAevheQn9mQB7ZMQ3wGLjiwfE8teEmmnfMjBt0OPlvRzrdo/ty1CHQ65RVfQQEzDaA9p6XFi25RQCzhb0/tuFCjyU4safzpfzk8P+Bx6ilzUcrzzoLfI3omdERHWmN39QB768oieKGx9bO+0xRlhen6BoubTDirPpx72sgGA0VrwIVmWpO70PMntKi8PqZTMonmRN9vGgYNJm3rTa1W4vD/BH4gRkRtrWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

lru_gen_folio_seq() computes how many generations below max_seq a
folio should be added to, but stores it in a variable named "gen".
Elsewhere in MGLRU "gen" means an index into lrugen->folios[], i.e.
seq % MAX_NR_GENS, so reusing the name for a relative offset is
confusing.

The comment table above the code also no longer matches it. It only
covers the PG_active and the final branch, leaving out the reclaiming
and "can't evict yet" cases, and it lists LRU_REFS_FLAGS as an input
although lru_gen_folio_seq() never looks at it.

Rename the local variable to "age", redraw the table so that each
branch maps to the age and seq it produces, and note that the result
is clamped to min_seq[type].

No functional change.

Assisted-by: LLM
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/linux/mm_inline.h | 48 ++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ab69b9930893..a933d8c14558 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -302,34 +302,50 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 					      const struct folio *folio,
 					      bool reclaiming)
 {
-	int gen;
+	int age;
 	int type = folio_is_file_lru(folio);
 	const struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	/*
-	 * +-----------------------------------+-----------------------------------+
-	 * | Accessed through page tables and  | Accessed through file descriptors |
-	 * | promoted by folio_update_gen()    | and protected by folio_inc_gen()  |
-	 * +-----------------------------------+-----------------------------------+
-	 * | PG_active (set while isolated)    |                                   |
-	 * +-----------------+-----------------+-----------------+-----------------+
-	 * |  PG_workingset  |  PG_referenced  |  PG_workingset  |  LRU_REFS_FLAGS |
-	 * +-----------------------------------+-----------------------------------+
-	 * |<---------- MIN_NR_GENS ---------->|                                   |
-	 * |<---------------------------- MAX_NR_GENS ---------------------------->|
+	 *            +-----------------+-----------------+-----------------+-----------------+
+	 * age        |        1        |        2        |        3        |        4        |
+	 *            +-----------------+-----------------+-----------------+-----------------+
+	 * seq        |     max_seq     |    max_seq-1    |    max_seq-2    |    max_seq-3    |
+	 *            +-----------------------------------+-----------------------------------+
+	 *            |<---------- MIN_NR_GENS ---------->|                                   |
+	 *            |<---------------------------- MAX_NR_GENS ---------------------------->|
+	 *            +-----------------------------------+-----------------------------------+
+	 *            | Accessed through page tables and  | Accessed through file descriptors |
+	 *            | promoted by folio_update_gen()    | and protected by folio_inc_gen()  |
+	 *            +-----------------+-----------------+-----------------+-----------------+
+	 * PG_active  |  PG_workingset  | !PG_workingset  |                 |                 |
+	 *            +-----------------+-----------------+-----------------+-----------------+
+	 * reclaiming |                 |                 |                 |     always      |
+	 *            +-----------------+-----------------+-----------------+-----------------+
+	 * can't      |                 |  anon && not in |                 |                 |
+	 * evict yet  |                 |  swapcache, or  |                 |                 |
+	 *            |                 |  PG_reclaim &&  |                 |                 |
+	 *            |                 | dirty/writeback |                 |                 |
+	 *            +-----------------+-----------------+-----------------+-----------------+
+	 * else       |                 |                 |  PG_workingset  | !PG_workingset  |
+	 *            |                 |                 |       or        |       &&        |
+	 *            |                 |                 |  PG_referenced  | !PG_referenced  |
+	 *            +-----------------+-----------------+-----------------+-----------------+
+	 *
+	 * The resulting seq is clamped to min_seq[type].
 	 */
 	if (folio_test_active(folio))
-		gen = MIN_NR_GENS - folio_test_workingset(folio);
+		age = MIN_NR_GENS - folio_test_workingset(folio);
 	else if (reclaiming)
-		gen = MAX_NR_GENS;
+		age = MAX_NR_GENS;
 	else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(folio)) ||
 		 (folio_test_reclaim(folio) &&
 		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
-		gen = MIN_NR_GENS;
+		age = MIN_NR_GENS;
 	else
-		gen = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
+		age = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
 
-	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
+	return max(READ_ONCE(lrugen->max_seq) - age + 1, READ_ONCE(lrugen->min_seq[type]));
 }
 
 static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
-- 
2.34.1


