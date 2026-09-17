Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7E54C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D00E56B0099; Thu, 17 Sep 2026 10:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD77D6B009D; Thu, 17 Sep 2026 10:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADAA96B0099; Thu, 17 Sep 2026 10:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86DB66B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:22:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 140B01A038E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:22 +0000 (UTC)
X-FDA: 85223469324.15.1021BD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 63CF2180009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h5ExFZPJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789654940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G4i9YVdly64+a304TiCv8nwcHkLss6xqStxGSND5/ec=;
	b=a8NLIJ/5K/4ktCGRi/SQAP1iyx8lFSMcF2OosN/8ljJXneyh2Hx8CwmRXBp/2TpVMPdfky
	1V8yb3xZ7Rp8oQuzMylo3NDQUaEJ+vaqNl6PWACkyLBnK186rX3RwlueOLPZisSkdj7gj4
	I4aNjQECipf9CRrFaymH8eBP8ZlrHmo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789654940;
	b=KAhpJuoViT1ZTpKOF0IH9c7sMc2SsB6Ce+cwyyyufH5dRpd6VNxC6LJBgt4fLMnU7EwRc7
	IONpI4kVp0yO6MJttKCUJ900Xirt9uy1AfaoetscejzI6Eur0Woj0jnhEq/1+11YJzlinQ
	nLbYgUwwGLPT44BNOVrwkGAV6pnBp24=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h5ExFZPJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC87743A2A;
	Thu, 17 Sep 2026 14:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698B91F0089A;
	Thu, 17 Sep 2026 14:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789654939;
	bh=G4i9YVdly64+a304TiCv8nwcHkLss6xqStxGSND5/ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h5ExFZPJQqiTePp/WDl73sof3pqfsr/hdjFIOJ3lWzZVKGNrtN2V8/Ojg3ODcNRq7
	 1paKZ44w7an5o/r95vLVQv0bk4qiUZukq79QAXR2ZqdBkofCE0xLAl9TJrzFwtvJcE
	 ijDZn/rSTZtXH+MW1Bw8sNSFaZU7VsiiLNetPjm+IJqzE6WxgjoKHkrTLSE/rm3pXW
	 xZNQB4GzoKlISfZh6wVJLLic5/78/BKiecMDKc6zrvcbYIsEA/EYPmWYxkhH+jgMFs
	 +y2OjyLKNf7NF9FLh586Wz6pPCalP5v6BapcLU3zT4nHbgz4f1xG0lXfaKpNmzQuSp
	 2Z7RIfsHMLVHQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 03/10] mm/damon/core: use mult_frac() in damon_feed_loop_next_input()
Date: Thu, 17 Sep 2026 07:22:01 -0700
Message-ID: <20260917142210.90829-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917142210.90829-1-sj@kernel.org>
References: <20260917142210.90829-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 63CF2180009
X-Stat-Signature: pbabgd15pfpo33jjp55fbdep56rjt33k
X-HE-Tag: 1789654940-291368
X-HE-Meta: U2FsdGVkX1/liUncoTaT8guqhshkHxqvxTnofEYPNzSG2ZLEu2RZddKJqqnmVj4Thg0t9SjZPkd47F4OilNzNH1gUfjZh1+63/7EilN5I8dyAkoGk2FJwBbKU+QvMKqSsLqaeGn6EAb+5GvZQCC2zD9MGxESqb2v9UX74r9KBA4jCHaI9yArvblN3o5Q+a1kEDoH6SAwKSCsG/zLCnsV4FbvDq6oHd+lSyUoyErJCcRTl+LL9emBYmyZtzHoeHl3a4srDhK2Su0O1RQckNpXGZzgZ8Tx7D/PhDVRolrBf77of8BFo70lXvULQIPIxjqkjnz4vVr03i0Sj3h7hRGNS9sLk9AWBakxdVXdOraygtK/wx1b7yhxISH5bdGOGIEyoOBGjzgGeBwVM8kiuACgHEqcOOTyy6jGmTJTXXIndyvosNLUKMcVnGnry2Q+j4LMGDs+rEatmhr4mPc/hSaLHbUDgYczlbC9K6JURowT37TeAeFmrtvONohuZUFmBQDNGpxMasRk7PYfjriyO/+oNaRE3WPhE632zYTjhTYwtBg3tVyh91BnGMnDJUMQj9kfqVvxlm/sf1o6k9siOSYos6HWQ1KyIGRVGw20m7Js1vEMeSSRy4W+TzyWc12kMO7CRAiwtoXLwlFNxgbtc9IL0XDAjcLAnjHPN+zqZgrQWAuIA2XwB7sJQNPPEVjFWOSddev6bk4oNAbTF7Im3EisxCsv8QVwZTi228fQHyVEEkUs733tYBnS3FbCpaCqepe0Dc+17WCG66+jxdpZdxAMxie1h3JuZPtlrpMmEZL7TvnFQnHr0/z8dnHlyX4RvxIalvQ0uIxYKczdjGo9RCpt0GU0D7rrOOJOcvHYbq+IDsF00xqZ5JUmlJcx6C0nuQCQkDuoe84o8q1UTjJ+qACmKIR9HanghaOdiduIeGqOFN0Yji1K2Vzp1hoFypfc4PgBhI6xTUSiyQwDU31vE3u
 sa9Z3Q+7
 AIy1WEBEn/K7BB4aAmkQIs/WUjW+nUymgYAttQrU6kugMN6HG4cUcBjBPqvdPoAPhMGHxfZvJ0jTdsGdTVH2yxIA7RgIb1eRFoLtiyZ14vt4QM/0icXPwY7mRKgPgEVfbGxiyTjhD+zPjID99+x0wTiL9zMXg35zk2NU8SlsVgT0/Dun/yYsDkGSKFDmi+ntETnHyYowqyz1pj8lQblsD4WHvWdYsGBOITTFupzpyBsjU8/uj7BlHhGV7ptI+v8aR3bG3kw13u0ny5789weSXoEATFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_feed_loop_next_input() does its best effort overflow protection.
score_goal_diff is always smaller than goal (10,000).  Hence the
calculation can be replaced to use mult_frac() without concerning the
overflow.  Use mult_frac().

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index de46072dc1a2f..bc41ac7ecca43 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2927,11 +2927,7 @@ static unsigned long damon_feed_loop_next_input(unsigned long last_input,
 		return min_input;
 
 	score_goal_diff = abs_diff(score, goal);
-
-	if (last_input < ULONG_MAX / score_goal_diff)
-		compensation = last_input * score_goal_diff / goal;
-	else
-		compensation = last_input / goal * score_goal_diff;
+	compensation = mult_frac(last_input, score_goal_diff, goal);
 
 	if (over_achieving)
 		return max(last_input - compensation, min_input);
-- 
2.47.3

