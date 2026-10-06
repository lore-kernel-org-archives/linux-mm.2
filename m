Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CE5ACA5FFC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 06:52:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528B86B008C; Tue,  6 Oct 2026 02:52:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D9A26B0092; Tue,  6 Oct 2026 02:52:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8D16B0093; Tue,  6 Oct 2026 02:52:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0BDEB6B008C
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 02:52:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 934E61C3735
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:52:19 +0000 (UTC)
X-FDA: 85291282398.25.198F1DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 006941A0005
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:52:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g0hXNJjQ;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791269538;
	b=kxCtuMZ/RmQEm1Df0lc8ZZrGm8bMZbfpi0iCu2CHBbgcVt3h1j6b6P8Rq+UARcvz628oC4
	DoqC01C0ssQWKwCcVBAEfHrULn51zWfufTuvx5jRQ/rtETShTW+pCRwuP+4khLyRuduFRe
	ZJevyNLkWVJeUnhmqhBSOcK2ox5YS5k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g0hXNJjQ;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791269538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QPAjnO4sadYj3FVzedyJO8iaaP+d0ImiNneHLyndDTg=;
	b=ds+TJKWWSzTiNzjQwDNfgjtI/o0O6Yjd9mp/kV+JvL9EbmHHuPIXE1VI4Nixps/+es9FZY
	sBYxuJ+QLGeqpQF/fB94M71Qkql+Vxgjr8a/aNx/zb3zhkfmPGereC/zPlNxcJUC7nB4Pv
	wd1BdaQYZ5E3ugwY7dNie8DgfsEOC+o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8EB32602A8;
	Tue,  6 Oct 2026 06:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94FE1F00893;
	Tue,  6 Oct 2026 06:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791269537;
	bh=QPAjnO4sadYj3FVzedyJO8iaaP+d0ImiNneHLyndDTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g0hXNJjQsMh8I0I/vHbkxH6f0IQX1qlcvIqS5RV/VHxlfxmv6XedtSQhZ1HVxOsnF
	 puTIv8bE71Z77JRjEUgwZ4beFvyQu8Dt2q8HeWXiJZH2XVAx5snzwkPehZLJgwdVH3
	 GoSdnLE1/yfi3hoGTfwNTbQt3YF4/+KNloKBs22HiKymsD9hLlbKASvgV1VUIyhZJg
	 0zb0Hd1Go5GHMxoQA0fJLH2uy3mvvrtr5T/b3Pxev6LznQyfz2GZB4WqQ3fc9lH3Gk
	 rLVtM2nWhdRlFr+qIF7FHHQi0Ap4afM7nJectyWb5qXlPAf01v3wRWK/X7EiTnl0s8
	 qCmgk3VQcG6ZA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/3] mm/damon/ops-common: fix age_in_sec overflow on 32-bit
Date: Mon,  5 Oct 2026 23:52:05 -0700
Message-ID: <20261006065209.41507-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006065209.41507-1-sj@kernel.org>
References: <20261006065209.41507-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4qss3jdnx84p8fizpj9nnsy55tp5c1a4
X-Rspamd-Queue-Id: 006941A0005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791269537-944055
X-HE-Meta: U2FsdGVkX1+fe1l1BRFCXwvng8o7ShRSeou2r8nr3TkPnkEfCX9aWTVbxHs2AOSWgyoWBI1LyKOGc/zYzNWw/aiMth5riMF0PL5o4j+HuDDFGgKyZPV3OErBvjV1WyT+Sf2+NNIxWPM6PwQcizxsO33jso94oB8H/wC0pv+E3gqdTXwki5yknqQ1B2nIuoQCR5+6IPIFjVp50UuJ7kJPEhxpynsYg5np6IDa76gssUOB5JNtSTekH5/bG6RZjZC1bzwMT11jbDKMSFQaAKCTyT+5Xukew4Ynwzm3gYVfMJDK+FQpL3pAqXSL/FShcNm32ph2y/SrZ8zBxvC3XoIFOQ/JOPjanN7FFAJMytPRZWURAZ497uT9MInZlmS+akFFtAJl1laIDotdhrVrY83IuqBUE2c9pAA58AUzooX4VB1CkZ0m9GwJayK/2pCwq0HB8oLoeXQfmf/QlhN/XnQUstnG/52lGvAoCUNHdFkonSpL/ieHRiqbIF6L7scjFC7rU3N2AZIbY9+XXKkyPbWpSam2VpALTQJg+SM9gaLIZvOUj0ysoEA4i7CREhocalXwPhG8btb8p1Am6HixuM9TEeg56gO1AapQVmp90hBnxhmeqA0I3rrahhcQjYD9EAX03hUeQLoOy9MZ8bMG8/5vWk+Zdchyx1elu4zug0gPauzaEspIjNlnBx7hWMEBp6oFBbX7IkAXUHYZvCcrMVPg9XUQ2QM1qK7ievccnTw/UubKCDwVSbWZHTOJW1gHFFEJ0fIQDTuAY/VGhBgADQT5HAmRdr787+tpSVF9PcA1hxTsPjZI5g3kq0etCaQGgIh0AR0AVQXc2WqNk4BstReTilP6qduCUUu5noPQn/yy+rGCeUSXliCqFh+Fdc4fiZhY2mwXOY6sZ8QsHMe9PGnlawKP40pSW9GnwKZe69skGlRby7khoGYxcPtDNnqs4j0peD6kC7fEd8ve/+rCQLF
 uxT1JxD3
 mHuKPCnWkAdE0d9Z5PkpR7I2tLUusBQrHBaQOw7tWEqJ8agBbkAWYoTYo99EdIHvmd7x/6I00L7ZA8FFjljbO8may6g9s+BH4+GYpwUjAXvfozahXini/MsKTOnPHI5ToWctXS/j0y2YTYpfIPKkpVX6W0h8hnJmXTOr5jlpJ5ysaZGHtQsFYYC8/il2TBEkeOMYarICx/sihi9rFtI5eMitseed4gNyNyn/dJIu3q4C/Uye0BeaXCxJwF/+bsc+ElwAt2EuOQrgGW8QbGSdj5VEO90l4Cqkun+frEcwm6Ea+FBZcbHw7yVw4EHWRWqr7LnJCCrLlJs+8QnyYDJ/i36i2gFtdaztPADSfdv1bK3yd4phc3KJvTbXbw4QxQ4VoZFt/wNGGyIXsm0pa/1HAakK15ZLrzF+G4c503D0WUAF6ozApo8gYQ7UexQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>

damon_hot_score() calculates the age of a region by multiplying r->age
and the aggregation interval.  On 32-bit architectures, unsigned long
is 32 bits, so the multiplication overflows once the age exceeds about
4295 seconds.  Then old regions are scored as if they were young.

Fix it by doing the calculation in 64-bit arithmetic using div_u64().
Also make age_in_sec u64, so the result is not truncated back to 32
bits.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260623011652.1354-1-sj@kernel.org

Fixes: 198f0f4c58b9 ("mm/damon/vaddr,paddr: support pageout prioritization")
Cc: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260930115812.138864-1-jaeyeon.lee.dev@gmail.com
- Collect R-b: from SJ.
- Rebase to the latest mm-new.

 mm/damon/ops-common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 77366f42b3e5..7a7429359dc8 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -164,7 +164,7 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 			struct damos *s)
 {
 	int freq_subscore;
-	unsigned int age_in_sec;
+	u64 age_in_sec;
 	int age_in_log, age_subscore;
 	unsigned int freq_weight = s->quota.weight_nr_accesses;
 	unsigned int age_weight = s->quota.weight_age;
@@ -174,7 +174,8 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 			DAMON_MAX_SUBSCORE,
 			damon_nr_samples_per_aggr(&c->attrs));
 
-	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
+	age_in_sec = div_u64((u64)r->age * c->attrs.aggr_interval,
+			     USEC_PER_SEC);
 	if (age_in_sec)
 		age_in_log = min_t(int, ilog2(age_in_sec) + 1,
 				DAMON_MAX_AGE_IN_LOG);
-- 
2.47.3

