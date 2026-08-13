Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74811C5DF65
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 06:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AF806B03B6; Thu, 13 Aug 2026 02:10:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1605C6B03B7; Thu, 13 Aug 2026 02:10:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04FF06B03B8; Thu, 13 Aug 2026 02:10:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D76316B03B6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:10:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 67A9080515
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:10:41 +0000 (UTC)
X-FDA: 85095222282.27.32959C4
Received: from mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf02.hostedemail.com (Postfix) with ESMTP id E4A7A80005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:10:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UTydLeYN;
	spf=pass (imf02.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786601439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CTT/eiRnnlerkP1sc4dEYlOnt1LK4ry+ImAkaWBPED0=;
	b=ion9D6CzHd+ERQO4peyQ+BseT0Y1Xb+SexktQyOB09S0ImmQnQOOEKG0hvb+VE9lCVjHpe
	ObYYrFIMghVVYIRi1M86+ZHHavyFvjR6zvxhGF7GZLm8vvb13feQLKP8+BYtGBl29dkhDk
	ghDqrVGvT6lTLCqRR+I+MCj13+gvuyc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786601439;
	b=apm1Gvlg/FvQ7on9Y8cj30BGHM7+biITQx8HGtAxWqHXHOpV129geVoZCviVZRy77OQG3F
	pZybNj86kQ9GZ+gnE+Pnk8fye9faJRStIFocqruQh/0cDyMTnyGpOSoBi41UZZHdRDQypq
	IsE1PZ0I6mYybypuF6lLQivCcK3JGRY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UTydLeYN;
	spf=pass (imf02.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=oGQy5myqwnPvsP3ZcmnRlv/Q66YHeU9GZFGDRa6no+Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786601436; v=1; x=1787206236;
 b=UTydLeYNcpkm67CWRmAteNLBEYLf6lKXxV8NsSMo0vUux24smCagWJBnzdbC9St6CHUSlq3f
 ih1F7cwTtJE89KU9IS+FTIcrNN4q+wSUiSogHVq0shyALQANr10WI1iLdYYVxpBQ4bEY9AW/tkm
 ub94iirH+aWJ3gzCr7E5bYlY=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id cfdb8185b516303f;
	Thu, 13 Aug 2026 06:10:36 +0000
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH v2] mm/mglru: Fix young counter undercount for large folios
Date: Thu, 13 Aug 2026 14:10:19 +0800
Message-ID: <20260813061019.49806-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5euxsotq1nx6wn6y81xrfs6eumg8rttj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E4A7A80005
X-HE-Tag: 1786601437-417787
X-HE-Meta: U2FsdGVkX1+Ap1OeUMCaRYJhOe+Y2A52u3D8Tj/ExCgiZY2A1FexSr50OenhoDofb7C55dyXassDZx8Go9zpUuetNMWC42tMGJpCuCjPDMHyP+VE2xmvERLJPQ4+dSxAL3zKsFw6fPWvPdsXDbbExPGz5R8fSht3w7ZBR1pjUwcqY/gXkoYRUEVVIx6Qp7w4fR9LEma8ebtio1FICkv0XvLted0SaWPVyM31D+BLrdUBnp+TU4KjHOjYMnlVxkvXWFsAZnTJUti3vXRPTwuUj1tg/wIQhjE9uTZM9PTLrSnlOtLOLQj3NZ0Tl3s39MZMs0c/0126p8sDei4PBxSd/3DV/+Bkx+fuGrpnU3m0z/ae7FxrrrMkehE4JOiS0pdnYWbWBfrqb1aZb2ATXhdCjPlTTSF94xXjO7zK90wuKIMNBBJDNpwvZBymbPN6B78lbrdroan+KJMhCQm9TssY3Z1K6mlf+UteB/uX8LqgqNgUYNF0A6XSzMeeA+vf3NzYZlvcj/ZEpGU5fUHFV1U0sP5CIcB/l9EeUiL2yTI4HRhsK0rD437amlq7VCQla2/Dxp8M5k7dFPaI4m9Je7Cqzl15dApGiCLqhju++wbV9I1OLPiMxSs4XBmS7ClvPPNSgu6retrpX4B4PzP3Mus1Adb80SIH/nGWwzHHWXpWRfbmgroWefLOokzkYcYhc44n4CMk6N884n5tf3jk54tWJc9/jdNWWBfC2rOHJBZMcZ9zj7uPuTARSmVb6p3jXEZZoqE4+a/pEgsIDdE/BV6h1RywBJVXEC7TpR5/Axjjgf9DbRlp0XwkCpb04ZMbABhapVwPRfb6JGBoecSGAL03NOhBixZFEnYDq9zSwufoG1c2qN+UvoteqmVBiekpF3Y7fUznYM+YytyB3rAi9WB12bf7+329u2PN+i/u7/mq67MXRBUMMClp8NmsM9JqbTfD74abOzEjPfQbb3IUJJ7
 MRPV8Wm1
 oR5obNFUfbBS/oKFV5MyIfrnxTGXb5UrCIiMG9gJhUxGaS9xAjhtrNrMuwgKg80VOw8asQsLYD62+byM7fzQqsGZBnuNHIHrUeLujiszhUbX7/55turRhOm+W4AL5H3glqWyTn6EGxBAAFnZVWhC8tRicoVrdmKeA+htAe1gCMTwCFVuSd+WavCtGqXJ5RljboEEuA/Cnhn9z+USkB6UKE702YemOQWxYeHoyiIiw4g/OKYfXKlUqoBU5WcZu+ZWVYt97
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

lru_gen_look_around() feeds its local 'young' counter into
suitable_to_scan(), which decides whether the current PMD is added to
the bloom filter and checked again on the next aging round.

The folio triggering the look-around is processed at function entry:
test_and_clear_young_ptes_notify() clears the accessed bits of the nr
PTEs it maps, and the function bails out if none of them is young.  The
loop that follows therefore never recounts this folio, since its
accessed bits are already cleared.  Every other young folio the loop
finds is accounted as a batch (young += nr), where nr is the number of
consecutive PTEs it maps.  The triggering folio, however, still
contributes a fixed young = 1 regardless of its size -- a leftover from
before PTE batching.  A large triggering folio is thus accounted
inconsistently with the rest of the window.

Initialize young to nr so the triggering folio is accounted the same way
as any other young folio batch in the loop.

Note this is a deliberate overestimate, not a measured value.  The
test-and-clear helper only reports whether any of the nr PTEs is young,
not how many were accessed, so the true number of accessed PTEs in a
large folio is unknown and can be smaller than nr.  Counting the full
batch is intentional: the mm core tracks accessed/dirty state per folio,
not per page, so a per-page count is neither obtainable nor meaningful.
The only consumer is suitable_to_scan(), and the bloom filter it feeds
tolerates error.  Overestimating is also the safe direction: at worst a
PMD that saw little access is rescanned, whereas underestimating could
skip rescanning a PMD whose folios are still hot and reclaim them
incorrectly.  (nr here is the PTE batch size, not necessarily
folio_nr_pages().)

Fixes: 56e5b60b2114 ("mm: support batched checking of the young flag for MGLRU")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Changelog:
v2:
According to the comments of Baolin and Barry, update git commit log.

 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bc324e37c5f1..264017850a55 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4192,7 +4192,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	unsigned long end;
 	struct lru_gen_mm_walk *walk;
 	struct folio *last = NULL;
-	int young = 1;
+	int young = nr;
 	pte_t *pte = pvmw->pte;
 	unsigned long addr = pvmw->address;
 	struct vm_area_struct *vma = pvmw->vma;
-- 
2.53.0


