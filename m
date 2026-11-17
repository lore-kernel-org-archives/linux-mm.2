Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47E53606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 11:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fEjtek8B
Received: by kanga.kvack.org (Postfix)
	id 6C9026B00EF; Tue, 17 Nov 2026 06:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679916B05B0; Tue, 17 Nov 2026 06:37:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9376B05B1; Tue, 17 Nov 2026 06:37:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 324EB6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:37:17 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B94CC8040E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:37:16 +0000 (UTC)
X-FDA: 85444410072.06.84F6E55
Received: from mta1.migadu.com (out-161.mta1.migadu.com [95.215.58.161])
	by imf09.hostedemail.com (Postfix) with ESMTP id ABD2E140007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:37:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fEjtek8B;
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.161 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794915435;
	b=rJEsrWSOGjBCSPBIpo+SOZZZvjqheHbl1aHtqinHnXWm632bA4y1Q2YzrMfT2M7ksMuRAE
	kNg1EJ3UC1OdYP/vCCk8zjmxvcUHnJZyajs9Srp9LRzAr9/DZxmbxLiR79DzY3FeIbT9L5
	9ZdLl2xGKoVXbC1i3ZbnjXmyByJriaA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794915435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FIq/acdz95vjbYoS5MNj8HtOBDIDNoJ60+7a7u5rlJg=;
	b=8Bl738s/OVda9deEAd/Vm3zWrMdqhXJMIWOgodjnF+ydUpdMwP3nWRcsXjyRb/bwUlsQuK
	gGtXRLW4oDna7BssneDHvH3LjMZdMzYu2P88sAmzdxgsE2sjYtLfPVqKggcTwh/ROsgYtu
	+fuYqw54BIX3mJctvKQtlAA9Ezk49HY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fEjtek8B;
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.161 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1c0H7lzsrOLvPgIaEgNX/VBYlRpSEzqvqTJWZfntygs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794915433; v=1; x=1795520233;
 b=fEjtek8BsUI4xWPpUqbNZFhH/ighpcAaON8N8vgwoQDHr+DXcSZ/NtEr9kBvqsykxPpJDysS
 ny7ld8ldQvtiv3gU5NNkhI/AiXgwE8S1zS1MO3yh7d3oV9s0onqWDa/U4XAXTkLZy6foghdNcFs
 wamZ869X+UZmGjT5BYnmNquY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d92e4996c9b348da;
	Tue, 17 Nov 2026 11:37:13 +0000
X-Mizu-Trace-ID: d92e4996c9b348da
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] mm: mglru: reset the mm iteration cursor in try_to_inc_max_seq_nowalk()
Date: Tue, 17 Nov 2026 19:37:00 +0800
Message-ID: <20261117113700.453044-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ABD2E140007
X-Rspam-User:
X-Stat-Signature: onewoihjttt4hsymfo5fc7c1wna8h58p
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794915434-901456
X-HE-Meta: U2FsdGVkX18hshGoqOE/2mGxWWFhHI+77PJ/NOxhUnmp4vorI+sDxf18KpuCETZ+ybc93MZynWSlai2egQIHtHeHsUlTw87fKNbRB2eo/VgczuhLgYsSLHwoYk3hXcIb8rY0lMNxHyjDMRmv8a75Hx/c0RX/g7l4fUiDVsjNQfg8mPELXa+myl9RpTqu7M3IAwHdQVeRVwDxnbjFFWjvZlCSTJteqUEfFHRYTsA4l/SJn+qPeDcsam2AUijVVUX5giA1jVoVpHIVgfESG9RCyo5UkLoRFrsg73LhAUZvwFnCQpIDmYLlZm24PEBpG3Y3Fu0AQzcAmoCFdj3/r/dEnSoU1ZMCgH0eyUn/DPuvrDjfXmo0s+bkMzadlPDQpLnzyO5D2x8cU73rtIXDY5kIfAsbkiX2QQO0Ge5E72qpIXEnF1167appRguPb/DgxOoxrOUcE+nXKKYcwujr1/lEII4UmL/if1lla4MECPsn04jWgqvd8c6LwaZ0E9pFlyvew6MRTeYzOGBlrOgdbiakRV9j8aRnfdXDuzY5X8XJ0AjRXttpi3wMfObehyLd8aS2JoPyvLnOwMXNtUQV6UKRJ8/USyzccZq7mi9yesDl2svNLYRK8aGJcyVz1e2qN4fNdIY7aoMGbkao01/qDLOYAl2o9jOy/u4NawFZSjY7GQOXoWuue+qiQp5nIa4R5STxvZnccNMJtEtRPL0gHmoq5PQaIrXSXwBZIA8gSDRO2cOeioslprvW759D+rdqszP5OllTYyBP8YhrBUtUdmHqHve2PKKgrlUHnSfQ5iK6AXSiqz+S3y7aAKliUDhFB/0pK/E36uR302uWZw0oy9heUXQechEn1C7NAhab+tje/Pqwn9KODUWkKd+jKR7AGv7FYHeZcvdWc6repHWPV2W5ilsCsgFwfW/zJ+gh25VIS26rzSLWypYsFEP76+7WXM1XZJAJBebm6O21hXNMseC
 Enqie0Yw
 0M/+PjuF6LsndVXsgBWxpVbmdEfaI9PxSj30nIahLEQl9Te/EaUuV9cnV8hlzwUNWFAJncRwlJSqcD+3LZGKMlBwwAOp/bPIktaAArPF0XWZPFuv5tRXyHsm2jSC9MNFTtx4BVDrV4uTAKX1Ep6LIHmkBSy2Le5xsG0ZFT4kyu0dELHvE9zQc3DVgFZI6TDJ5TfVMEESaa/aTQHl4wsKBS4HET6Rpu+i8UPtROVUJC4vzk483tzg6w5dAxvFOpCIGYZkwyAWfKNTBr6ciaJXEvkxV81RYOhcQ2XWQsM8R05jZBitcMjiMXdNmw2TFdgL29ehmFWOS9f924PCxWYuVtkXvcDdQhcf5DBS9b7y43+ve26/T5PJHBsvXBK39rt9P9MrscDRTuifDHjUCIobD+4pvIl3Qx7bK6Lv4jq3Qx/WO5Zy8QsMuNqDamW4cIvtM4q5s7M8z4uswGcINLGGRP7+11Tc8AaKol+owgGIru6NUNxVrGAyf1tUHNcSwBzAmyCKs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hui Zhu <zhuhui@kylinos.cn>

iterate_mm_list_nowalk() and try_to_inc_max_seq_nowalk() both advance
mm_state->seq without walking the mm_list, but only the former drops the
cursor. When the latter races with an ongoing page table walk, head is
left pointing into the middle of the fifo.

The next walker reads that as "this generation already started": it skips
reset_bloom_filter() and resumes after the cursor. Every mm before the
cursor is skipped, and none of them have bits in the filter being read, so
walk_pmd_range() descends into none of their PMDs and harvests no accessed
bits. try_to_shrink_lruvec() ignores the failed try_to_inc_max_seq() and
keeps evicting, so those hot folios become reclaim candidates and refault
in the parent memcg, until head wraps around a generation later.

Factor the pattern into skip_mm_iteration(), which carries the rationale
that used to sit in a comment in try_to_inc_max_seq_nowalk(), so the two
callers cannot drift apart again. The wrap-around in iterate_mm_list() is
left open-coded on purpose: there head is already back at the fifo, and
tail has to survive for the force_scan test. Dropping the cursor is safe:
get_next_mm() holds an mmgrab() reference, and a concurrent walker bails
out at "walk->seq <= mm_state->seq" before touching head again. The
unwalked part of the fifo restarts from the head next generation, as
iterate_mm_list_nowalk() already does.

Only reachable from memcg_reparent_objcgs() -> max_lru_gen_memcg(); not a
memory safety issue, since lru_gen_del_mm() repoints head and tail under
mm_list->lock.

Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/vmscan.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6a1af9b92349..0dc4017b87e4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3235,6 +3235,7 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
 	do {
 		mm_state->head = mm_state->head->next;
 		if (mm_state->head == &mm_list->fifo) {
+			/* head is back at the fifo; keep tail for force_scan below */
 			WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
 			last = true;
 			break;
@@ -3263,6 +3264,18 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
 	return last;
 }
 
+/*
+ * Advance mm_state->seq without walking the mm_list. The cursor must be
+ * dropped as well: iterate_mm_list() resumes from head, and resets the Bloom
+ * filter only when head == &mm_list->fifo.
+ */
+static void skip_mm_iteration(struct lru_gen_mm_state *mm_state)
+{
+	mm_state->head = NULL;
+	mm_state->tail = NULL;
+	WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
+}
+
 static bool iterate_mm_list_nowalk(struct lruvec *lruvec, unsigned long seq)
 {
 	bool success = false;
@@ -3275,9 +3288,7 @@ static bool iterate_mm_list_nowalk(struct lruvec *lruvec, unsigned long seq)
 	VM_WARN_ON_ONCE(mm_state->seq + 1 < seq);
 
 	if (seq > mm_state->seq) {
-		mm_state->head = NULL;
-		mm_state->tail = NULL;
-		WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
+		skip_mm_iteration(mm_state);
 		success = true;
 	}
 
@@ -4686,15 +4697,11 @@ static void try_to_inc_max_seq_nowalk(struct mem_cgroup *memcg,
 	DEFINE_MAX_SEQ(lruvec);
 	bool success = false;
 
-	/*
-	 * We are not iterating the mm_list here, updating mm_state->seq is just
-	 * to make mm walkers work properly.
-	 */
 	if (mm_state) {
 		spin_lock(&mm_list->lock);
 		VM_WARN_ON_ONCE(mm_state->seq + 1 < max_seq);
 		if (max_seq > mm_state->seq) {
-			WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
+			skip_mm_iteration(mm_state);
 			success = true;
 		}
 		spin_unlock(&mm_list->lock);
-- 
2.53.0


