Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31220C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72EB96B00B9; Wed,  1 Jul 2026 10:48:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705C66B00BA; Wed,  1 Jul 2026 10:48:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6428E6B00BB; Wed,  1 Jul 2026 10:48:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 395A86B00B9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:48:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF3C84027E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:48:27 +0000 (UTC)
X-FDA: 84940488654.29.D4027B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1E1C310000B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:48:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QLZIGe82;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782917306;
	b=lcvGs5RlydUPUwJClu36H8aFVVnKBgp0W8OQsiU3bfIYhykSf6hlCR5Pvn5HwxOcoRtYnB
	Y6gY7wHDcPaYFZLCZeNaj1uocYw/P5lmGGC6Ka+DF2DO57lvwPtQbB6fCGy+izeVu3cK5P
	0+IhSF2lpMnCgDzarhRPLfL/IiaPd2w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782917306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uB0wjQbyJXJs6+1FcBUr/5yMvVVNvbMcMX8+dR3IIh0=;
	b=wdo+qT9yaYeBVZ5LtPKCfZJTvbQbjfzYhFzLZWkbNBkMRs/MLTPcMLe8q5Ec9RHCtqQUvo
	yuP0zcngT4YTYFhmDjE1OAGlhl2DXvOzhvu/K+y+wPrQjb41T77a1Kq9d3W0U/JwcKjrim
	PuwTzk9mbJZ7YSaljTRUUK5fjVeYURM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QLZIGe82;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD898601DF;
	Wed,  1 Jul 2026 14:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FEB1F00A3D;
	Wed,  1 Jul 2026 14:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782917305;
	bh=uB0wjQbyJXJs6+1FcBUr/5yMvVVNvbMcMX8+dR3IIh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QLZIGe82b/josKxLiOhAusIeVZJoAGnTrd00a0d2IdpjQgIvJNp+is5Ssj6bOTZX4
	 LjNF6iqyVepf//2C8ENpA4PVGNynpwFKZSZ5g7gsaSj1Y8xX9JLsynz9U+pM+x4bV0
	 08c5TpAHmtrF36vG02rWE8O9rB7d0MSCieMtjqXH1I/SvhelHEmQDC1LQONDBmX8sr
	 E75iT+PPLEY5o4hKmETz8CDRggMeDQUC8avRVCIbJof2SOc2vbS/wliLfk3ro1qqpZ
	 0wi2TextAFx1jl1x0h4z5kqOYyvoFauHoHugdC+FSu+Wt+/0/AYSMAR5nUQj3zPJzy
	 L/nmZUT701chw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/8] mm/damon/core: do parameter testing commit on damon_start()
Date: Wed,  1 Jul 2026 07:48:04 -0700
Message-ID: <20260701144815.113325-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260701144815.113325-1-sj@kernel.org>
References: <20260701144815.113325-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 317gfuzgwjsizorwm1mh9mrj3eg4cd6s
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1E1C310000B
X-HE-Tag: 1782917305-637431
X-HE-Meta: U2FsdGVkX1/kUxRWvifYj5MBRSvEOpvE+nod66pXDM0KXsGO/2RN4ule0Dme8zqABd/q1uJCOFn8I8z0nZFNVGGVYqOQZoK14qY88crqISY6LJj+/Q+jvoBae9JwxpYEA6qD2NcpZp7l/PUmvhFF5rTN2accz/xEcftzHUw2l1OJ1e4n+lDcu4Xa9Y7FEcwNAR0TqhIN3ZjNw0aa/9j4IpLWI7Ygw1Z4KxrZK3/bDGWPCz+7vf+WC7Wm9JNxpiqpii4k6lHVIjgj9MQyuQzZgAmr9cLTxDxzNnmkkRK4TXYRBQVYC6bea+dWIXxJaVoD/1qiAxvIHVKxqR2WnTeqb6emqc/b3OtQXwSh2hD7GIDeDPjRJXMolJmBD/u9QwHAZn0hmLh0ftGZt4RjxUxRelJuPtV9eC9N4gVvYlj5p2/pSPoQO0KVNFOIM35OR/uzB9vLTJgsnZVvodILKJWVBfJLaZd1FK0/CK6GGdwxemw4plhkxqFU75Z3DnrS9J1EsohVGRW7ykFbp4eMxDOj9HEac913xSIeXr8qlvbvn3YTHHUkBn+AQrQ4RvcKU97mLVrKpJjeadT6DpMfxhlKiIvTGQqg8cZM2LCJUhWFVSx7eqa7eQUA0PGsXdHstsAfyaDdEYUSTQ9xg2aa0NEiZMgS18oO8J6H5AX8hlr1JOdyoz6OJo/70vi/Ur9OSWZR6HgRy3aMni6Jm3XXLIOXeihR7H3xUIC8pNLabsMx291uXFMTpjVW6DgnPe2FZwb49+XLS/yjr43SDMMCd0dys6Q+GBTkqbT52Uy/rXreQpdgF4QZJfNOFPaxpPy0WwIcbhHXphnIdbEY0/8Av3yj7IWgvuuE44kOB70HsvqQhg93nSDE1SpSoMrpUf32I9TxhlmDuGFYarTmDY4u4hw4HlHvDQq4NCRhzEUFdH85sLjPcWLFwKK2TGCQyuJ+JGNU2gORz8WOmMjEncofJKg
 qMI5pae+
 uN7XcCpQe1QvEGe0ZM4MldijPg9BnQyhWOCqBbz9YViwPsH2JbcgR36Wf/vtMaFdM4QkIeVovsJqISWG0oUs92Yb+ubGxmHI2acoaiFoG99RBgw13vM5EYByYHf5uNq3IItENawm4x6gRpT3nLXjHfoL2jowLtgTeoIZH6J4iSfqAE/HwpQSj9Qfh4IppHAhnSlFf74sTJyl84bZjDoAEnMW3XdmrvOiX0+yl1w+aCG9f+1XA7Y3ielRiWsHEzVYxq9kCokFDplsr4iibsKAyP1kJ9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_start() and damon_commit_ctx() are two main DAMON core API
functions for setting whole DAMON parameters.  While damon_commit_ctx()
does holistic parameters testing, damon_start() just believes the caller
validated the whole thing.  Embed the holistic parameter check that is
already in damon_commit_ctx() into damon_start().  After this change,
the callers can safely call damon_start() without validating the
parameters.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 62c27002219cd..6b30cb6007e54 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1865,6 +1865,8 @@ static int __damon_start(struct damon_ctx *ctx)
 	return err;
 }
 
+static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src);
+
 /**
  * damon_start() - Starts the monitorings for a given group of contexts.
  * @ctxs:	an array of the pointers for contexts to start monitoring
@@ -1882,13 +1884,22 @@ static int __damon_start(struct damon_ctx *ctx)
  */
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive)
 {
+	struct damon_ctx *test_ctx;
 	int i;
 	int err = 0;
 
+	test_ctx = damon_new_ctx();
+	if (!test_ctx)
+		return -ENOMEM;
+
 	for (i = 0; i < nr_ctxs; i++) {
-		if (!is_power_of_2(ctxs[i]->min_region_sz))
-			return -EINVAL;
+		err = __damon_commit_ctx(test_ctx, ctxs[i]);
+		if (err) {
+			damon_destroy_ctx(test_ctx);
+			return err;
+		}
 	}
+	damon_destroy_ctx(test_ctx);
 
 	mutex_lock(&damon_lock);
 	if ((exclusive && nr_running_ctxs) ||
-- 
2.47.3

