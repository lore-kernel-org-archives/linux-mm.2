Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6813CD6AAE7
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 15:57:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 717676B0088; Thu,  2 Apr 2026 11:57:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C7916B0089; Thu,  2 Apr 2026 11:57:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DD1C6B008A; Thu,  2 Apr 2026 11:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 514786B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:57:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 133631A07F5
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:57:48 +0000 (UTC)
X-FDA: 84614071416.05.786403C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 617C8140007
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:57:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OTULZxMf;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775145466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3H3BPlXmbNeqUaFJkuJ0xp02HizktWeZynKSIqmnX8=;
	b=oiHBKWYxmUEa67UhluDKagjxlbIZWMKM9s0LwAH61cg7JDAQwEZvphvFLV8dovoTqVOPVl
	wa4oprj7LKzo/tmihI9S3TM/7RgVO3aAsx9YYOO9wetiHpYqVIOE5h8Ccx6spj7FTbRKrA
	ComLIO8zdbMzRmn/b+5nM7Oo4JLOWzM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775145466; a=rsa-sha256;
	cv=none;
	b=5kyk32VQTY8mjLKaGv7jI17kACCsod6jc0BaT4PneB6k4dzh0umQ87zTYfWLbWg6w2S/p4
	E7UyNAGDEtSUrTGNOshW2N3HMPTFRBQTGV7ypcxj68+CtVUwrXZJsymyAPtWPH9lrwGp5j
	E23pgF3C5Rpa5JSADAHQNmDzM+3neTE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OTULZxMf;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ABC9060126;
	Thu,  2 Apr 2026 15:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D12C2BC9E;
	Thu,  2 Apr 2026 15:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775145465;
	bh=Cctzlt5Opg64VMqk24naaGYNSUhmoxomxZXKX5DKxok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTULZxMfEQn9PVoLW7K0LXBdrVffjx1gNhhyW3+NznKze+5HFUHJN2WkiZ88U3gNu
	 t/SgxHwrWR1J5EwcPtThlgYrTpcB6aFiZzf2uz6ai174I1mMRScq0U6Kk428/R+ycb
	 8xGIQ9fZHzrp5CNX74ystm9Eam57znEEi0KpgRTTbxvNeijCSWmAGu82ycX0722tat
	 WHd2SlmWWTTZY5VJRXhWyjecYFMv8uuczxDCFZe1/yYttOXiEgcFOS3ZUc2nU8Yt1Q
	 aG6vE5JxRAsCOS5eSgfaQJVg98ISJzs04KAwYQdbaz+urTkO0Hm3ZsQBUUC2xpt91i
	 56cNwutvguOpQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/3] mm/damon/ops-common: optimize damon_hot_score() using ilog2()
Date: Thu,  2 Apr 2026 08:57:28 -0700
Message-ID: <20260402155733.77050-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260402155733.77050-1-sj@kernel.org>
References: <20260402155733.77050-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 617C8140007
X-Stat-Signature: ph7x3c9mtisz1czrhz5ibne8agzxrpog
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775145466-890496
X-HE-Meta: U2FsdGVkX18WMojlKTVhCTx8+1gMyYRGBdizUrq/fvFcqtSqhm4vfKnlEdGQbkkRh0rDU9Qp7ORFMZfrksNFRnCb4Cn5Vh7Z4g5QUcrK1ly+xNugpvSzZCAlVzYgi/nTXBLe3GdsigAsoj1GERd8luPoN4tyMZc4r8sUM8B0//DsCQbccilGBiWCtl8nYbrV5iCnkcIjjKFw6zZSg1VPB5W6ZHtqQrbSndLpy4312PnOV081w8tzrczF7/X1YNIdqge6RHP8LkjIN3jhmLMssn5rctTDKCW+ys1moOW2Aj+1SOZThjoshZCE27EGAX46Rc+1+we7YukEmFj/PbLGT4yaBbwDk6cOEmiUvUZCcarMgxOfCUci9PO7eJ4EPLLTMCiEpmH4sbjC/xsFEk4vaBYFfuCoPDS5RanzYkQeuleW231wRnEPRdJPewWwr38//DU7OhUuV1OTwaL/NqqbuGhmUiW3uVLW18DqR38KUCtNYcXeOC3A1a4uNv60gDLXBo49wwx3Wu7BOP4bKm3Fpuv4gIZ2GfqpjIVpOYj4piIlJmF+i3pfyppDqISJGZLDh6r+BSJq28zBn7WF3dzlMYiEGSfd62flKMu9QtdC5U8IyT3sFD63anKccuOT+jwrrksq8cZCjiq8qSXCVQoa44rtqd2K+9WvrLFbFSPtvmT3XgrwkalWA0/oSKUt68wzb0UFfoNGwvbWvcy2iRSUhBkBuE4Xs03TG7oTTHfSvgnf3/KhZAIO2NzNguJN9ygE1N4mOjHYgv871ZLX/+Eq+yONVKdkIhC9LGFjbT2qOFTbIE3oORNoF8rRxDJTGcgNRcUNqc0yQo0CE7ym2wdVaw0MskyQEBlo0Vutz4kvTeL9TeWQqZO77fhLIxEqSM2sS3Yuj3F77yG6uX5geuT5qZkiwAqchbHues2kHa+6BAKpkj26qcnk8dIUXDkXrbJ1CGMmdzPiEQ796tVhXHM
 HUEJV1yK
 xPFfbQeCXpU+UgChJt/RHRP2ACrL5L4bm/1uTIPl0JO4sAYOKru7ZEGuEUgXqCx+SglX/GmR3QLx15z9mtW/Xo82qiUSw5YiL4gPD/o6h4XEMYk5kSDZRbyBPW/2N6JMB5Achb0kf49u+Pr3VR1CIBPVqLIBuF8UtbNy74VLl7zNzy6COdA6AaKVaIamCpOBIv1fcmdpsqAFdhZ3gO8C8eZz05mcjz1hlMgXKkjNT/g/AmgVKBHb0BNH13wLOvVfbIIckKdkzxQu7L1F5hceyRZueJDPnsCFIUygBKXVZY1ygx5p8rpLdgCgrfBGSs24vv7cR
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
- Rebased to latest mm-new.
Changes from v1 (actually it was RFC)
(https://lore.kernel.org/20260320072431.248235-1-aethernet65535@gmail.com)
- Replace fls() with ilog2() per SeongJae Park's suggestion for better
  semantic clarity.
- Move performance benchmark results into the commit message and add
  comparison between for-loop and ilog2.

 mm/damon/ops-common.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 8c6d613425c1..3a0ddc3ac719 100644
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

