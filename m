Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D979BC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 10:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC61E6B00A7; Wed, 16 Sep 2026 06:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9BAB6B00A9; Wed, 16 Sep 2026 06:21:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDBB76B00AA; Wed, 16 Sep 2026 06:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A670A6B00A7
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:21:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 99EE01A0698
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:21:30 +0000 (UTC)
X-FDA: 85219233540.26.1B24709
Received: from mta0.migadu.com (out-120.mta0.migadu.com [91.218.175.120])
	by imf31.hostedemail.com (Postfix) with ESMTP id B112220004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:21:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.120 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.120 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789554088;
	b=6KKS67e6yKvGlxpru4FyTr5C5MACsdiFf7hJCgG6QAiWp0SWbt/ySt7TcGpm8OwUQyJi9Z
	jVvRj6d2cUbOD6/WTaXjRcqSmZjUlZcOH9G3IPkWnU8MozMhqyIiehEO2s2DMq2IQyuz2t
	+Au1KCMy2OMtL2KkS7zCqGB1qESgBuo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789554088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jO7Mslqz46+OMbBqU3sd8eyWIGUkg31OzWiHtF16w+I=;
	b=W5AK9czczeUDWtPmqy0SBYQNcUhZJa+RIwpXfk4AVrQHaJV/uVsA0qaZO41OlhH0kutUb7
	06M/NI/PFHnHzk/b2TBKsMAE4R9UoojAQ+DumEAposJyPyaXw+O8dxurmwATq3uUKJjN9M
	m0n0XFG/3ShIY4/hxb7Q0CbQuKo+mUE=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id c0bf29a0ffc9229e;
	Wed, 16 Sep 2026 10:21:27 +0000
X-Mizu-Trace-ID: c0bf29a0ffc9229e
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v3 14/14] mm, swap: shrink xswap to the ceiling when it drops
Date: Wed, 16 Sep 2026 18:19:21 +0800
Message-ID: <20260916101929.149106-15-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916101929.149106-1-hebaoquan@kylinos.cn>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B112220004
X-Stat-Signature: ihrr4ksshynrjxx5qop9qs6jac4enktz
X-Rspamd-Server: rspam01
X-HE-Tag: 1789554088-671844
X-HE-Meta: U2FsdGVkX1/5lrnWzwcH1nEY2/SSzJ5eV1SMNVJLMMHg++L6CNpUARY+JJUXm77beccXqOmyEUxv2i5q6taEaTauGg4q6GYGZIdqyLnW7hqbJLr5gquenvDSmG83xUkB5m2dCPNrZaqyFSv1IF//fDNK189Qpbs1tZqqOcUN5xP4EVwL1Bf06gx0aJej+pdn3z36qda9Lng/koeybtuFC5V27EVhddfR1FzjqBLL5QyMgGB/FR/0wFLeIRMEc11Ktv7tkcebAfqiyeP1G+B6RiH59s206sk2dLbpibosT4tV3RW6xNYti5BYeTmBMT21I9zTod79Rz+Sq4RTHCiuoldGQpfxIe6UkU3ddji2dL0TbPQZ++JC/2GRprT/z4BgvCHYf4JZKG6wPE2Fj11GmGWy4nC0jwi3m+aVJ4LwoqmaStIpTxXtIaG9EJqM/YZz4sfJM1egonBe51jtZS1hcIGbeNMeEf8yH+f6zsHzTHj1Toe/f2CeSFkfmSiRJC8mf5YNRj+TyHx+kra15EK5pKi/MZ0isTHA2gA2OS6F0asq4aSS3LQAIu7RduUuAjuoT75FMuCNrPbmHqo5yWkVlI5McVz+n5COL2Wp+UVzJlBf3tmMuu0humoeWsnPaGrGNDoe3FQdDX0ZXgViCzPmLLlJOQ8gU2s4+2TDMCw5rNWwOCHA/6ww/MDX0WJi51Zsb7wqZ7ftS+N2m4Pvrg7yNvONG1h6WqgpNZXFNFxCi9+QVy/0cWs0tz703Rv45Hi9TjcYMM/IGbqqTHpEmYdNz6f8RjTvC/jp1VxZOOS+zBmj6S7TmbvlnjR2jIf3n0oq65ISEzlj5fhTuPPtYtcAUzmCmHyvtELKQhFhScBEdkxac8MPkaAhkwdf/eJCv7rbNWTWVrJwGJeJXZ3v2FYMfOsbp19jOkfdjKP043W8AqD/xe/r6hT4C0b5eWh6sX6Eb7gFXgg75IpgmUjL9kS
 S3l+FlQ5
 U9It96WjkadVylQkofVB9EhAgawwn0Rm3/rQ5ip5bo5h54MEg5xtZ5XMO3fy2pbUxOSaJM6y7VnmtdNNIS3p5/M/bCNBYv1gzWQZ9YOV/mieRNwKcx8vEquDfo6+y7XyLIsYCqgX8r/pyHcmyP69wZ8tutPmeGk5xYfM4cfUSiFnzLKXgPrB8k+oCYn42xj89I8c1JZqMTJtSzuPWM/iCtpo56YHd53HKjy+I/ZmKWNpavptP+GcjtFrl07Go8XjiBEo/1Hf9wbcZAmw3kMy8XtXOG5zbiYuETcboWBD+LV9kYqY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make xswap_try_shrink() shrink down to the ceiling when the ceiling is
lowered below the mapped range, and trigger the shrink directly from a
limit write instead of waiting for the next free cluster.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 59 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 22 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0fcbaf1cf0e2..ab64bfc4e0f7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -4190,8 +4190,9 @@ static void xswap_shrink_work_fn(struct work_struct *work)
  */
 static void xswap_try_shrink(struct swap_info_struct *si)
 {
+	unsigned long nr_mapped, nr_ceiling, nr_tail, nr_unmap;
+	unsigned long start_idx, i;
 	struct swap_cluster_info *ci;
-	unsigned long nr_mapped, nr_tail, nr_unmap, start_idx, i;
 
 	if (!(si->flags & SWP_XSWAP))
 		return;
@@ -4203,35 +4204,45 @@ static void xswap_try_shrink(struct swap_info_struct *si)
 		goto out_unlock;
 
 	nr_mapped = READ_ONCE(si->nr_clusters_mapped);
+	nr_ceiling = READ_ONCE(si->nr_clusters);
+
 	if (nr_mapped <= 1)	/* keep cluster 0 */
 		goto out_unlock;
 
 	/*
-	 * Reclaim on our own, but only once the mapped range is at most
-	 * half in use: growth is demand driven, so reclaiming on a smaller
-	 * dip would only map the same clusters again, and every unmap costs
-	 * an RCU grace period.
+	 * A cap below the mapped range shrinks on its own.  Otherwise wait
+	 * until the range is at most half in use: growth follows demand, so
+	 * shrinking above that would only map the same clusters again.
 	 */
-	if (swap_usage_in_pages(si) * 2 > nr_mapped * SWAPFILE_CLUSTER)
+	if (nr_ceiling >= nr_mapped &&
+	    swap_usage_in_pages(si) * 2 > nr_mapped * SWAPFILE_CLUSTER)
 		goto out_unlock;
 
-	/*
-	 * Count the free clusters at the tail of the mapped range.  Scanned,
-	 * not tracked: the count must be exact to size the unmap, and an
-	 * incremental count falls behind on out-of-order frees.
-	 */
-	nr_tail = 0;
-	while (nr_mapped - nr_tail > 1) {
-		ci = &si->cluster_info[nr_mapped - nr_tail - 1];
-		if (READ_ONCE(ci->count) ||
-		    READ_ONCE(ci->flags) != CLUSTER_FLAG_FREE)
-			break;
-		nr_tail++;
-	}
-	if (nr_tail < XSWAP_SHRINK_SLACK + XSWAP_SHRINK_MIN)
-		goto out_unlock;
+	if (nr_ceiling < nr_mapped) {
+		/* Take the excess exactly; rounding could zero a small cap. */
+		nr_unmap = nr_mapped - nr_ceiling;
+		/*
+		 * Keep cluster 0: it always holds the header slot, so it is
+		 * never free and must not be unmapped.
+		 */
+		nr_unmap = min(nr_unmap, nr_mapped - 1);
+	} else {
+		/* Count the free tail; scanned, not tracked. */
+		nr_tail = 0;
+		while (nr_mapped - nr_tail > 1) {
+			ci = &si->cluster_info[nr_mapped - nr_tail - 1];
+			if (READ_ONCE(ci->count) ||
+			    READ_ONCE(ci->flags) != CLUSTER_FLAG_FREE)
+				break;
+			nr_tail++;
+		}
 
-	nr_unmap = rounddown(nr_tail - XSWAP_SHRINK_SLACK, XSWAP_GROW_CLUSTERS);
+		if (nr_tail < XSWAP_SHRINK_SLACK + XSWAP_SHRINK_MIN)
+			goto out_unlock;
+
+		nr_unmap = rounddown(nr_tail - XSWAP_SHRINK_SLACK,
+				     XSWAP_GROW_CLUSTERS);
+	}
 	if (!nr_unmap)
 		goto out_unlock;
 	start_idx = nr_mapped - nr_unmap;
@@ -4507,6 +4518,10 @@ static ssize_t xswap_limit_store(struct kobject *kobj,
 
 	spin_unlock(&swap_lock);
 
+	/* Enforce a lowered ceiling at once; raising needs no shrink. */
+	if (clusters < READ_ONCE(si->nr_clusters_mapped))
+		xswap_try_shrink(si);
+
 	return count;
 }
 
-- 
2.54.0


