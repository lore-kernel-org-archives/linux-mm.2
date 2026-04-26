Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC87EFF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 23:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D53B26B0005; Sun, 26 Apr 2026 19:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04866B008A; Sun, 26 Apr 2026 19:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCCD46B0092; Sun, 26 Apr 2026 19:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A53586B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 19:16:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6EC881B71EA
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:16:31 +0000 (UTC)
X-FDA: 84702268182.12.CFE2E02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id DA3B440007
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:16:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=skzjHFp9;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777245389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BZ2GXuSVaqChp75PEXMbWxqOhP7yTvHhXrXFs8RjbgE=;
	b=gcIix9yIjufkQEdQow1L4gRdCQjqEoinVa83DL4bnyu5eKKRF+4rvRXRqKgkm5I7GMjio4
	jCVHmxoV/2bD3ldBnYjfMNabGHUbLDq1ot87+5mW/AfFlubUnC6PRUh+hNJWVbhXnKjUXP
	zHZubBC8iuc7I+QXiORZHVKvifBPy6g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=skzjHFp9;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777245389; a=rsa-sha256;
	cv=none;
	b=QdXeyIkK+GBGMp0txpo2G0nqnrzJ/Yltz5RQmKSbd6CIGznQWYhrD2qxnLrrzH8ATR8tMb
	8P+pzKZEQrkEHT9HSAI8bWJnE1CHZF14ZCIzChWQ5t8Z4+VSCkboIP4SrX5blMvaVO52a0
	jrMyiUWkcBN2M5fmzLs2OnNR5h11eBk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C8A76014B;
	Sun, 26 Apr 2026 23:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2938C2BCB4;
	Sun, 26 Apr 2026 23:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777245389;
	bh=T/rtKaW+eKFk9u31EesKB4EAeHDfVjDpSaLKG/xuO0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skzjHFp9vHqFSaoK85/avT28EYhWOljnnUy0mw4KWXm0pAy1IFAlmiTH/tst2LYf2
	 ZgW4dNHiP0uozx2R6Ip5VE+kJZB6yhe0eH3FO7kadd9KvK8d9rzOvV/N+PlQWgGZ7y
	 ca/l+jDNveyLvwNt53F7LuXtGPwPfqXEigWOVDB3pcsT+Yo+ugSAO7L9ls3y2BcysN
	 yMpBv89mFHBdW0uxHR5hVQ0HJAb+BPkt9JRYFOd5tTKinXShubbdJkNxk76WaburaE
	 gdqmjrONgPp7ytMBA2Tu+cCh6W1axX39Pe9CRJ/XGUaHwnowhIxinXSCZy7W2VpuX6
	 Qa1SFSjGAv2ng==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 1/4] mm/damon/ops-common: optimize damon_hot_score() using ilog2()
Date: Sun, 26 Apr 2026 16:16:14 -0700
Message-ID: <20260426231619.107231-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426231619.107231-1-sj@kernel.org>
References: <20260426231619.107231-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oeiwdty75gwc8qbwocbf4dh7oqaftheg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DA3B440007
X-Rspam-User: 
X-HE-Tag: 1777245389-603951
X-HE-Meta: U2FsdGVkX1+vNxYey3wKcLjpAOJlaKh5FsQu5NwHlxLC0IxnBoy8X4bZCUTUVqjPAyxOD5ffg4p/9bvXJiBp63V9wiWseu93i5BqtxlA4evkrDug8D0R8TfIATOnrLS6e1ZYARUVytBBwM+fh7DbEnDT+Z80XgTZyuiWF2YJQhR+6n2ESLtSa/bScbC2sAuQKLKc1x49XzkQPcPl3E/VlIISu5sa/hcOh8XQf9bBjL8Z+cMQfdhYRQP7vXJwVEgIwWdsRJoM6zG+2c3YHMPQX+6iZJQFrAJXaH31vDXclDtIDejoESEgQ60m6tSX4dXYUKR1hi8E5co9dUs9+DhwZpVSh8zn19lSUCCjNjdowLkBWuNdP3xP5lYSFyI19L/n7aXZrnqcsslCnhnlzGwF8Y9pXc9+FzlJdQQyLrbCJqZe5DKHwAY5vxwUk479P9f+dPZpn2vatOP5epg8bf4cMe0c17NBrmzFdkYcDce9js+iPS2a6djX7d74JVKvvjYzivkQUwPHhfd2JmtsgaunkuDIyULnwNpUCfvQY0hGZoHTNLoijjyPQJRfHgJ13FRybpymGHYEVfzMrvieObiO2p+wYUj3tB9vgoC5sTRP571fNoPgYbV3Td3nXt6e+B+7BZBOrc4KooBQ2XnVh7xGopNiK0It33vey9DkrVjP8yzqvhEjIzYjKBYh5Z1OruzlO1IVyJL4sAUx+9M6zJ00edyxUOGigWFwjEJEtqu+j6W8f1/KoCxhTFN46xsF0Hs5n9bxjbmvKQ0O63vnaH+YOjuzn1VhFD+0B6BG3SoV3gIMy2eZawTzNbS7lJKH6PDS66ez4e3h2wcGAYWPTL1MTNpSwL1l5IEzsS9U4iDDhTTAvUWWbnxtSQRhWY7zoVoIesymFnX3Rwy8Rp/PL32oI5fsJUk/rSOXnSGPjfWSEAICS+q00BllbmVgdZElEHoki+i3Nr6FZLFC6kBsICi
 2sKkmCfw
 6/8b7rORnf06uv3FKqbGv+GKZY/wJTWOjQ8JdBEmNhigACm++caE9iM0mudelRX6poSY5BGjo+D54j43hMDL/Yr3yzgdObDU6XldfcqIgac+eUWvv0nvgrtgdIPQZyqx8YlicOOuO5Jl1ku0uL2+9gs1vPDcbQG2NbcriCtNsnJ0vsuDG0CFlyttTy3hWgs+31lKzBDTUoKUSKEPa1dXHbgVmeBDT4L91MprYIoMvaewKC90HCHsIbG/HW8rqIe/dSZkjoiFzO391ivL1dy9ZQs+atVEjrSbkUiFXBnnT4BGPB6qr4/fGCUt0nPum20PkAXqs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Liew Rui Yan <aethernet65535@gmail.com>

The current implementation of damon_hot_score() uses a manual for-loop
to calculate the value of 'age_in_log'. This can be efficiently replaced
by ilog2(), which is semantically more appropriate for calculating the
logarithmic value of age.

In a simulated-kernel-module performance test with 10,000,000 iterations,
this optimization showed a significant reduction in latency (average
latency reduced from ~12ns to ~1ns).

Test results from the simulated-kernel-module:
- ilog2:
    DAMON Perf Test: Starting 10000000 iterations
    =============================================
     Total Iterations : 10000000
     Average Latency  : 1 ns
     P95 Latency      : 41 ns
     P99 Latency      : 41 ns
    ---------------------------------------------
     Range (ns)      | Count        | Percent
    ---------------------------------------------
     0-19            | 0            |      0%
     20-39           | 2625000      |     26%
     40-59           | 7374000      |     73%
     60-79           | 0            |      0%
     80-99           | 0            |      0%
     100+            | 1000         |      0%
    =============================================

- for-loop:
    DAMON Perf Test: Starting 10000000 iterations
    =============================================
     Total Iterations : 10000000
     Average Latency  : 12 ns
     P95 Latency      : 51 ns
     P99 Latency      : 60 ns
    ---------------------------------------------
     Range (ns)      | Count        | Percent
    ---------------------------------------------
     0-19            | 0            |      0%
     20-39           | 0            |      0%
     40-59           | 9862000      |     98%
     60-79           | 135000       |      1%
     80-99           | 1000         |      0%
     100+            | 2000         |      0%
    =============================================

Full raw benchmark results can be found at [1].

[1] https://github.com/aethernet65535/damon-hot-score-fls-optimize/tree/master/result-raw

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from v2
(https://lore.kernel.org/20260320192020.33004-1-aethernet65535@gmail.com)
- Rebase to latest mm-new.
Changes from v1 (actually it was RFC)
(https://lore.kernel.org/20260320072431.248235-1-aethernet65535@gmail.com)
- Replace fls() with ilog2() per SeongJae Park's suggestion for better
  semantic clarity.
- Move performance benchmark results into the commit message and add
  comparison between for-loop and ilog2.

 mm/damon/ops-common.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 8c6d613425c13..3a0ddc3ac7196 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -117,9 +117,12 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 		damon_max_nr_accesses(&c->attrs);
 
 	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
-	for (age_in_log = 0; age_in_log < DAMON_MAX_AGE_IN_LOG && age_in_sec;
-			age_in_log++, age_in_sec >>= 1)
-		;
+	if (age_in_sec)
+		age_in_log = min_t(int, ilog2(age_in_sec) + 1,
+				DAMON_MAX_AGE_IN_LOG);
+	else
+		age_in_log = 0;
+
 
 	/* If frequency is 0, higher age means it's colder */
 	if (freq_subscore == 0)
-- 
2.47.3

