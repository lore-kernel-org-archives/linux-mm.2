Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB573C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8487B6B0092; Tue, 28 Jul 2026 23:38:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FC386B0093; Tue, 28 Jul 2026 23:38:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 735976B0095; Tue, 28 Jul 2026 23:38:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3926B0092
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:38:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CFE9B1205B6
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:02 +0000 (UTC)
X-FDA: 85040405604.24.7514DD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3E12F180003
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TQNiXv0y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785296281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RY+XUIrZiXuiiU/vLhDSc4ARUS4lqpakXQtTFBEewHU=;
	b=vio4MJsoYHSEPUMANnPEGUD7b3AermRevI+MBihOD6V+DDUI39I+YHB58K6lKdul/070TC
	pdofwycm7g/egCxrYjlSOKMXNH33ARUTuYlHiOy9QveFsGOdlBv6Uv5gK0dHDp2hltgbV4
	t81c+omktUmnlufDXrG5PXVXyWLqk5A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TQNiXv0y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785296281;
	b=r3lWHgqFSd2hegkC51dshcw5puaaYNF7zueVipjpgDQ4NgWoEUst3+4w26RJnmgP3/FDYX
	wHuQjCYboGIGZAv4RNuNSaARWGsUIgASt9uWzDjuHYmhd/DtcCF3J0IaEcWu2DpZaN9MTq
	wyzQwpGtW1lq5qB5W2sWKIBx6C54CT0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B90F44FFD;
	Wed, 29 Jul 2026 03:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CCB1F00A3E;
	Wed, 29 Jul 2026 03:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785296280;
	bh=RY+XUIrZiXuiiU/vLhDSc4ARUS4lqpakXQtTFBEewHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQNiXv0ycuYjmgNZqlyFpDkk3lQmMhdqw9P2NN4wGYy4xL5dlGWUZaLD0HdiEktfY
	 4HkbI6d4qxH1z/maHFy7d0I2x5AQAL2Ehc7t3qkTriqWjUf8coZgMLaAvcpceoZ325
	 va5qtQFhqJ8KLxDnWViuB5V5UjcBnIofg8CMe/7ayGeZBLvkdwV62S077ddlZW7qYI
	 fAy1JtsRc5kydWpZP+lfGPrcEt/1b3q0sXXwx+1DJ7ZxnlYjs2uitISaz9IzgH/lvH
	 crubnLcv2aEaIFGhPN+rnppvAY7lQu/uYyKuSdcIJddPhY1TLEYEmw98MoL235Nmfv
	 DTYJkzRodQWeA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 01/10] mm/damon/core: use damon_nr_samples_per_aggr() for max merge threshold
Date: Tue, 28 Jul 2026 20:37:41 -0700
Message-ID: <20260729033751.131213-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729033751.131213-1-sj@kernel.org>
References: <20260729033751.131213-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3E12F180003
X-Rspam-User: 
X-Stat-Signature: kuxmecnunp57wa4hippbiz5eug5npquo
X-HE-Tag: 1785296281-424023
X-HE-Meta: U2FsdGVkX1+to7KTRf1zkPmWn0ugnkABTSV+JzV06cErdiHmRhDXrUVvQYY/Ay6PondpXqa/Yg6VaZR4vChDD7sullH5QnN6FGvLgwwo624/nhmSSTJFtdIk+Og9wJUPP990eiEBY1+PQsrHl1yw1lYaKjJHAzrYmQrCzI5EXoCDG/1VkoeAprDzS0malzMxKhTIsMmcIZaG7BPYXbzeStTuW1OuIZJtQakjz+gwE4aMniRqdR9PeohuFIi+k2WKTuoWmvJh6p/gJL4i0uNEqG750beAHn7fpJ9OQwq+ZBxraT2ZH8K5wI9GaqFn4iSj2ZTSqL8CuPkrwATLlaNG79PedFcwd4+FJTRQZtm2QkjHbyS9NFf0JaIM2lxPhM3Hbir8B9XJkcNLR13awi4PDlz4ZALHaSLJgF3mu9f7A+u003zRxlf4l0SW84za0MWLqetJuTY4SM/Q2plL/q+dGi0Rf0eG7M258PGoP3SQLkM0GHpXl98zI9HBP+FAma742AtmIQQR3QD8OGejzjXbpJtc2JIG4z24+RxOmT9lvz/UDk3GYnmlmuB/Et8dLaHqP0SjbSUuAWJwfZ50+5+KORSgIVeGzLHEbOKoMnG0uXtgFNPjfRZ5Nr0K/QIiefgyCHE8u7fpX9AmtuugfdfZcHitNK1Gy+Xg8OVYxOnGZuGbFY0LBSMEdUck7FYLd5zBg6W1yMpasrH4clDeryuAbFhbwl9CpJ5QcGiphCqalfdu2ba0rM5mtt/Zh4DE9RQHjMwP2VtDxoxIuwsYt2FOE6n0bODj40zAe1o0F5E9SVJuqrUQj8oD7hRGGyaoOv2nyAsGs28aBfN0JYGIiyhtaQVQipXIToyMy+AwgLrr90NUV5V7/8hPWVCtYund3dRrDyyyb4AlWmQ5vhN3inR5XUBqvbvlXLlJD/NR+dIizXmCDrzaENvApbOyNKUfLMyOhCAvF8bZC6CbtSjbl6+
 d1pDprcT
 D2N4ny6mUBEysDMf/LeTnSKPwlBitlhXJiPR1+GrUVb6BsPRPC7MuCbN85FvhrDnnS0LPryEq7Ekqb/TmpqMBPpD0XkurCQhHFDDJgKGIoLUClOh51+UMjdQfQ8Dil/mQJjrwHPlk61DaKjB6YNjpgPn+TocFh/HCsh9cachpwluWJYFHxAgW1tVROyv+bG2mpzaLCi2XIedrsvhdlsNiFpGsAYi80sXTv9DxVcrnP305uOeLQ5leW6wm7fvY30grbZZOp79A4m0NS0s8/Q7CziVVrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kdamond_merge_regions() open-codes max region merge threshold
calculation.  What it does is fundamentally the same as
damon_nr_samples_per_aggr() but missing a few corner cases.  The
unhandled corner cases should be rare and make only a negligible level
of monitoring results degradation.  But having the inconsistency could
increase future maintenance burden.  Use the dedicated function.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f7c9b94b6436b..4169268d94416 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3470,8 +3470,7 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 	unsigned int max_thres;
 	bool count_age = true;
 
-	max_thres = c->attrs.aggr_interval /
-		(c->attrs.sample_interval ?  c->attrs.sample_interval : 1);
+	max_thres = damon_nr_samples_per_aggr(&c->attrs);
 	while (true) {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
-- 
2.47.3

