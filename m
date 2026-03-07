Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63BCBF55102
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 19:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 992326B0092; Sat,  7 Mar 2026 14:49:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 927C96B0096; Sat,  7 Mar 2026 14:49:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793FF6B0092; Sat,  7 Mar 2026 14:49:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45DC66B0093
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:49:26 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F27331BFE4
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:49:25 +0000 (UTC)
X-FDA: 84520306290.15.7D01567
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 53D66140005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:49:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PskDigiN;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772912964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4NUx9QnPfu7A1XYFmKydGIKExw4Y1qUCjrYJ0Ko3Khg=;
	b=3EH/BOteaTGHLoACyHdLDm5oyV3+d4+mUWjNMACzbQ3A7FmvxOypa8zEOm4ChDbawaHwAZ
	T+m+FQihFWFTEyuytJ7jCeNV5+3dUJKFxW54akKHHhXyBJF6395yAR+tlKhXLfSVfdF5gr
	NzxQIZjjdJbA7Y/YceMb51hiZyhYUTU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PskDigiN;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772912964; a=rsa-sha256;
	cv=none;
	b=QfoBLx9d4oD/SQpgGIjOvqduvWRTt1mL9Bxj4xBPADZ/xU+OxNHgozlXwZsvjKnNwZwmuC
	iL307LBheUenQLWdxCIcs5hAyaj7uY0jiEyBE5KComU+VHDIhgFLSHBYGMAzg0Gtt2tbdy
	WUuVKl6aWogDUVXsR4FsdCheLgqK+3o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 79BB0438F0;
	Sat,  7 Mar 2026 19:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CDDC2BCAF;
	Sat,  7 Mar 2026 19:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772912963;
	bh=OtrKrhHbMS6GUq0Sgqh0AHIPZbCzyKkgoS3Ue4fyc6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PskDigiNybIdsVjKPIaaT46RjG8CG/QpBCHY83fnwV4RI2agMJJLQNVxw5B70ZI/p
	 Hdgh90iIOArfgAFCwLU359T/DsTiFFZC52miEsz+JlE1RYpjtZA6guHv24fWB8B0Vd
	 PlRln5R3CxwV99oGaI1VVJg6mLxgtsDg6nIdK9I3ATBivnKX/P6F3hJ0n9m1XAzdgW
	 ByUAmaJ4/xKt3G1aivavVwZAZvol/JgwKP1qkphm0dQdxPJXVXrswYLHf8MS64OTZg
	 NfDXIocfEBPXBwB9bgN35T0cYXlBBa4T4HItwC7q2KTlRoFfJj6F4NAjP8tfblxCBI
	 oDqkN6aUhW72g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/3] mm/damon/core: use time_before() for next_apply_sis
Date: Sat,  7 Mar 2026 11:49:13 -0800
Message-ID: <20260307194915.203169-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260307194915.203169-1-sj@kernel.org>
References: <20260307194915.203169-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 53D66140005
X-Stat-Signature: mu3qpp4xfaqa4xbqgrrfe5uq1b1csy3h
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772912964-869672
X-HE-Meta: U2FsdGVkX1/XSh/AlYGAaO2DAxdkGBlvedHabp451975EsviPXKbrGO8jguPlkyJzFq6Z5UjvYz3XeuI4ZAdzmTZFNB1KJQunYdPHUJrxYYH/F05VI2O5bXycSIei2O9+5SxDFnW4AVjVYeGIo46h0XbQlB2C4u83Q2QCCsvn2qiU5RGGUTAXBZLELy5+4up258CB/qA1ArikRdIiAWOjrEPl+/jTpjMawzmVqkIcaVCxlTVag8oXAZulv4Kk9/b9XPCTFTwZhhJIePmqD0akeHRpkHrt9t1zwbs1A/0qPMr2enS+45D798dEMpr2uyXCaA0nHBeVzius5R4/8kHXgjwBjLfsAtSVW2wG/La1eC0X7SwsdUm8TPTBa+dTA8iZpqPU8TCzRyEnSebaFxKzukYzJouvDHZdjG67Mzxpj7KQeWK2Wsn5We4W8YjYUseVYs0wHuXzJRnKD1cikE+gV8OAFreIpx5dOIoMTBF6mfwUqZWDGWLyeD/PYS/VxA6J3YkDI4ETP47POOSfSeDwezEq5DPajgnHl1SLeoD6+v7UnXivfVCN8/kU51UH0lhwnnLku0YaQYffl7aTpKZdat9f6i86lQBrPYj25ub9oe70cN067URwF9rFz53T+cdZChtPYhVbP0NsBEFRJMSb+IZoyUqQxnp3N0ZEY95kIpRmVkG1d7eBEOIoBpDQ2e4fMhNMpcF+GnZyg5NmM3NIJmFx1NXI5T+Nv34BOQZ7HktuOBxkDrOC127NzN6Qsfh6cKJzmJlvfgxMKX3FCTzQHcriBN+h3BdPso4KxC5ySHMFNhsFdpBK3YdGWeDvlzGxVrAv5U6IATevNdBcc1ssbzdRX2AdlTlD5+JRbhn7hI45D6N8KTIZzJQ1ewhQX20/ToCxjAmx2+bUudKdaxCz7USqPkCYVZD2r8P/fC3ECFRYzX0QUUKUT2Vz+8vVc8g7n5a1do2Voeyo/s/WDk
 6WSpS/Fp
 upPTIbopmQ1cNfSxjkYiulk4ZAS4vSgIvfgLwhpKM2pTkirEe4CD46L0wcrtODS4cOxlI3jYkvKhptbHA7JwS4dgRKUCQSXf10tg2bVEkZPQXTzVee9N15SSA89NuvLcsKEMr1geE5C6mjY+dPkZ9gnoKwzpxYochZFMgBOXDZjCjnBWD0cD95EQMrbNaYeev0FbpzhvDBqfO7KY2t5uCIWWfHZptNNd9m70S8l4HCH8o2uV7aQkBjJz5j1MILfYCsS0ASEJs+pc0fbv9qTIginNpug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_ctx->passed_sample_intervals and damos->next_apply_sis are
unsigned long, and compared via normal comparison operators.  It is
unsafe from overflow.  Use time_before(), which is safe from overflow
when correctly used, instead.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index c4c30824465ee..4ede733a94cc0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2095,7 +2095,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 	damon_for_each_scheme(s, c) {
 		struct damos_quota *quota = &s->quota;
 
-		if (c->passed_sample_intervals < s->next_apply_sis)
+		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
 
 		if (!s->wmarks.activated)
@@ -2453,7 +2453,7 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 	bool has_schemes_to_apply = false;
 
 	damon_for_each_scheme(s, c) {
-		if (c->passed_sample_intervals < s->next_apply_sis)
+		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
 
 		if (!s->wmarks.activated)
@@ -2477,7 +2477,7 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 	}
 
 	damon_for_each_scheme(s, c) {
-		if (c->passed_sample_intervals < s->next_apply_sis)
+		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
 		damos_walk_complete(c, s);
 		damos_set_next_apply_sis(s, c);
-- 
2.47.3

