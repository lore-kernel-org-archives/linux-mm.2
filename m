Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 950A1FDEE27
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 16:43:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A5666B008C; Thu, 23 Apr 2026 12:43:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0560B6B0092; Thu, 23 Apr 2026 12:43:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5A56B0093; Thu, 23 Apr 2026 12:43:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DDDB46B008C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:43:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9C8BA033F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:43:30 +0000 (UTC)
X-FDA: 84690391380.10.7194419
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id C40B6100006
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:43:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uiOc+nuX;
	spf=pass (imf05.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776962609; a=rsa-sha256;
	cv=none;
	b=VEuFyfW76LdemzV4SzZuMVSso7G3WpTKK4gnyW5eF474xqNdjUz0t5I5fdRML8MbN8TQ6U
	U0WxnZLMbOh2kbI8eAAbts3FDR/BSlIon1BdjfXhsxRNzUiAyfsbQDoVDlf/c+jiKGfzwF
	I0TlWxFf4nAMJxNOJ4yHSHPFqDfLH6w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uiOc+nuX;
	spf=pass (imf05.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776962609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YIEKJZNSJ9OeiPhU0FRTZ02fkQczRvgGzar+b8miLXs=;
	b=4D5WHqkLlfbZyOl0wGXtmy+S/bUAYjSAoYufULYqoPgIgMBDcCq1FZpyYdZutf6a4BHsck
	NFf6KK/Duo1xSIYo8wWsVhtTg4Ch5cgOHjhlNUg3F1wFJMaWRGnlhFxAnyPNtiLdNuIJPJ
	MBsHi95uA7FGqA4lA2fqKbrBUFfiB9M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776962606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YIEKJZNSJ9OeiPhU0FRTZ02fkQczRvgGzar+b8miLXs=;
	b=uiOc+nuXzSkMncpve1zOJ6r496DTBRy1/LeDDBTNkjhQpJo2WLQS+blMYN8XGaT3LahYpP
	hWqco+oyHmjT0KloyqDD2j/TW7JejM/aS+RULQ+E1dvoy822/ISmZPAg6AtWQBSsHYD7QI
	nssqrwS/t1gyYa2StGfPWMMWSBvuKWg=
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	mhocko@suse.com,
	willy@infradead.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] mm/lruvec: preemptively free dead folios during lru_add drain
Date: Thu, 23 Apr 2026 09:43:07 -0700
Message-ID: <20260423164307.29805-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C40B6100006
X-Stat-Signature: x3bpah14xs8xcnmbd8wg67ofqhmmzbtq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776962608-229857
X-HE-Meta: U2FsdGVkX18PCD32B3LlTLFOgbidEsbAG/1XvCZzCIneTjB/CsiUa/czJAGLFbvIEa7+HZtLzcPICnwW+fk29wU2wlH3iG3CCZ8JOV0Cl+0YJ2FfiqOiEqwkQu5V2+9H1wQF95YhVoou6k22FUQhgCCC18w8LCXK+uH3HzoFL3WUJvKlMV5MNU7QbZojlbF5CFXvdyKPMsUOeJRVm3qn/UXF8YS3kqkLoVHfaQ3LL4W8I5robr6xYPzntZ9jjMz1fRfBAWefuydl9BJmeGxScXclWCQnY8ltTRTBFr/w2fAvMAexIuVB28lKfkpPQTLKFw1qWxeNgq3RwfKdc8asvnEDv3InhqGhVyiVHKvWHD2GjKnveGSdjgmBkjq4mr2ZC5urd7BrlixCkzoZVVsCWgjF+aAvIZWxnvKC10mmjhulQ2nWbWD4YMsLjxitHW8f1U9qSHC3bOQ2N4oIczuCHF6EopxpQC1tDNsMWCBft7P3i2RODAlErXicL1PQ76A91243XT0RWLZzHNNgWXJwfR8ZUt8IZCN436dOm54ZyWcvT01OY3yxK5LLx/R4kM0gBqbdC/6rBaRJDXM6C4bZKsXoiijV5pIhsrRDqJZe/N972i3YkSl2ZscUii/SpRfK+336lzCuCs9WNPwvVdlMtiOCrrnwlP+lTKGRtQPfn9hzlgj/YKwiOYcpa08S99jwcDo7dJBOdGCkvRaOArgzoxyYX07cPGac+Z6Qy/Izq2xInIKVt9rt7vX06gc0OtAWc0yOcpwc74ZAGOZjZZ8n9+D8/prob1mWkcidCJBmgeRqRs/n9EnyFapTZWdgok+5ZUcTatRRVljM//rNLMXXwfKCUvvzHQt1sjutb/Vo3+mnzpsoAC6ghBs0YrNeuHQNR9ohYKWyGhfypMwc5V/VJINcHQX1XjIOTVvsggdBc08j6D3HyVGfWFWzhNMBz/PDQ9ve79V9URLpY2x9V5K
 mcSz8IPa
 ty4sd0WRzd+xNQHF6/0i14BhvXMGxJDKjVPvnlEFuKgV7WH2AXjsF9EngbRmK/doEnrbip/wholFzfeKQUw+9bKrGlV+tM72uHiKDLNMesuRGe9m1wFE8EYOAeOkQT53XywmAV1kdkSnIx74c4k1gvmOBSJo/r4MaJhpRtNQsPolpyj4UPgLAYo34OICVuqNkdjTIqcU4g6U8Mrd9lC1L6JFx0nu+O2Za9+28I/JGmpyN+cWpnY3IHs+63g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Of all observable lruvec lock contention in our fleet, we find that ~24%
occurs when dead folios are present in lru_add batches at drain time. This
is wasteful in the sense that the folio is added to the LRU just to be
immediately removed via folios_put_refs(), incurring two unnecessary lock
acquisitions.

Eliminate this overhead by preemptively cleaning up dead folios before they
make it into the LRU. Use folio_ref_freeze() to filter folios whose only
remaining refcount is the batch ref. When dead folios are found, move them
off the add batch and onto a temporary batch to be freed.

During A/B testing on one of our prod instagram workloads (high-frequency
short-lived requests), the patch intercepted almost all dead folios before
they entered the LRU. Data collected using the mm_lru_insertion tracepoint
shows the effectiveness of the patch:

Per-host LRU add averages at 95% CPU load
(60 hosts each side, 3 x 60s intervals)

            dead folios/min  total folios/min   dead %
unpatched:        1,297,785        19,341,986  6.7097%
patched:                 14        19,039,996  0.0001%

Within this workload, we save ~2.6M lock acquisitions per minute per host
as a result.

System-wide memory stats improved on the patched side also at 95% CPU load:
 - direct reclaim scanning reduced 7%
 - allocation stalls reduced 5.2%
 - compaction stalls reduced 12.3%
 - page frees reduced 4.9%

No regressions were observed in requests served per second or request tail
latency (p99). Both metrics showed directional improvement at higher CPU
utilization (comparing 85% to 95%).

Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
---
 mm/swap.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/mm/swap.c b/mm/swap.c
index 5cc44f0de9877..71607b0ce3d18 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -160,13 +160,36 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 	int i;
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
+	struct folio_batch free_fbatch;
+	bool is_lru_add = (move_fn == lru_add);
+
+	/*
+	 * If we're adding to the LRU, preemptively filter dead folios. Use
+	 * this dedicated folio batch for temp storage and deferred cleanup.
+	 */
+	if (is_lru_add)
+		folio_batch_init(&free_fbatch);
 
 	for (i = 0; i < folio_batch_count(fbatch); i++) {
 		struct folio *folio = fbatch->folios[i];
 
 		/* block memcg migration while the folio moves between lru */
-		if (move_fn != lru_add && !folio_test_clear_lru(folio))
+		if (!is_lru_add && !folio_test_clear_lru(folio))
+			continue;
+
+		/*
+		 * Filter dead folios by moving them from the add batch to the temp
+		 * batch for freeing after this loop.
+		 *
+		 * Since the folio may be part of a huge page, unqueue from
+		 * deferred split list to avoid a dangling list entry.
+		 */
+		if (is_lru_add && folio_ref_freeze(folio, 1)) {
+			folio_unqueue_deferred_split(folio);
+			fbatch->folios[i] = NULL;
+			folio_batch_add(&free_fbatch, folio);
 			continue;
+		}
 
 		folio_lruvec_relock_irqsave(folio, &lruvec, &flags);
 		move_fn(lruvec, folio);
@@ -176,6 +199,13 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 
 	if (lruvec)
 		lruvec_unlock_irqrestore(lruvec, flags);
+
+	/* Cleanup filtered dead folios. */
+	if (is_lru_add) {
+		mem_cgroup_uncharge_folios(&free_fbatch);
+		free_unref_folios(&free_fbatch);
+	}
+
 	folios_put(fbatch);
 }
 
@@ -964,6 +994,10 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 		struct folio *folio = folios->folios[i];
 		unsigned int nr_refs = refs ? refs[i] : 1;
 
+		/* Folio batch entry may have been preemptively removed during drain. */
+		if (!folio)
+			continue;
+
 		if (is_huge_zero_folio(folio))
 			continue;
 
-- 
2.52.0


