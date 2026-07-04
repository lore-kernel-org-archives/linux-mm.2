Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36131C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 18:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F1E66B00BD; Sat,  4 Jul 2026 14:11:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B9446B00BC; Sat,  4 Jul 2026 14:11:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46EEA6B00BE; Sat,  4 Jul 2026 14:11:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0E76B00BC
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 14:11:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 747741A055B
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:49 +0000 (UTC)
X-FDA: 84951887538.29.5CEC96C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E110D100004
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZxgyzLj+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783188707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h0Px2pc5d57ZghupeXW8ij/6164Zuz/qXDwibedUcL4=;
	b=lgcRGrL06aT9FBmFDHI9VOdc0BZcxIRcQ7fedJTMYwiHNogPqYmw5mC5C4BhN3ZIQVPMOD
	o5TjwvC4PwH1jBX5XEw7oRMS2ZhAKGopv70s90dJn/4tK4NiO6DeBmPd1ARh7TUy+sqP/q
	DftFOfCDmhIMfVHG5AIhBnYzrvdqTus=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZxgyzLj+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783188707;
	b=0aPkg2JXIzxkYOLuiWmIZcYnAamXN4hPx51iV/sxVfin4sUuiyXNL3k74KKqWSQ434n938
	oWrNazOGEHjNTKhDzv5DRL4B46F2Qp3xK0tRJzwsg7/2xvRhde3A4kmlfKQfjaFIvjUYfx
	CMfDbh1oDdCLo8Tsky7kxVToJ1fi/js=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 11D69435C5;
	Sat,  4 Jul 2026 18:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C427A1F00A3D;
	Sat,  4 Jul 2026 18:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783188707;
	bh=h0Px2pc5d57ZghupeXW8ij/6164Zuz/qXDwibedUcL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZxgyzLj+MBt/efF+VjBrUc09pF0OZcufMkNpkBjceDlB2aPG/3aJv3N8u4SE5Ek1e
	 DbPYt8ivSd2IZzrqKgLqbpsUFJzkC/cH+n7TIsPCaFXr+er+yTEYoQ+fErR6gxmmMx
	 Di0khw5Wa7d/HU01KjspUs56sOeUjeo9qGErnh/+tb/kasjjYUi7rqTiZWYkAjqWqN
	 YhDvgVQCgpzbsKfHh5D7He1YuZ8CS85dfQVkWPcaayYBgcpjFZ76edf/fmV9Ai7UfZ
	 guxxxpFXxZcVNK1qQrWN/p4Zxh/lwGxXiKqc3MqErD3V7v58o1zlpLruA7S6j07c1n
	 nMw9+NE8Fsf+g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 07/11] mm/damon/core: change damon_stop() return type to void
Date: Sat,  4 Jul 2026 11:11:30 -0700
Message-ID: <20260704181135.132956-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260704181135.132956-1-sj@kernel.org>
References: <20260704181135.132956-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E110D100004
X-Stat-Signature: ugidtkpmhpticcuu51kaks6woaq86niy
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783188707-598826
X-HE-Meta: U2FsdGVkX1/NzER/3ZPpO7yLU34WIV3CwFF+Nb2iBJO4NuUNAGrWb1c8Rs7fAPSnU/UQrxdWjP6m8e18JhMxjlHzi1m1RyQlTC0onP6xgPOKEjiAadRzbl6VxOD9LHBh13iaX6Q1kKCdgAtRewgbmclp7tONp2xBUPGF0rsg6VGwfDplRt5YYncUR5gRRlKShAl3SW8Zn8OcmzMU7mW9mMPr6vi/nY0JB6NoVR8IJ3JUDtyXki89ecF48JikNDNgsaj6V3tB1PY9VyqWoUZLEtE7ZyMZzRx+cGVfPgsLWs0wASkzPk1WKao1Oo0LpT/MLLRVHyuCeTGT8xmwX6pl3IVNFUG/aKPjUyjSpxRDxbYPRsO+tu1zqL2icKf8W4V5udh60fZbOmxV+GT1obKA+s9xY/HUYfSDC5ueb5iEQCqrygBBEZPXUbkrdlkr6xBjozI5nT5tXJA+1Rq/VlNdu274m9PS3PMqN5XWYWCKN0G+9p5y0xtUayoQEkkQuCGlJwo/jJA8pSeZsmiWuHOxV4GSe94FFqTgHaflqVI5XYK5QC/Go6z1I/XK/KB4drKS0vIXmXDFkWu2Yy/qx+Gf51snXck6Yj6JqToW6msawPFXUQBTVyTHnqf5kNXXTO3nxmTlJZsxQbKPRfjp+UplDCDfSZy5zWNz+BbkdFXn5xC1cj3eu0kOCA+V2vH9wVAkAwkUDLG5yTYxQ67mWTFJtv1u6eTG3slN80C0CXQG8HMQEHnkjPDdZkTWE1kNOfIVxEZBRc9BxX9oslB3CssjXDOigO0CftAl/6jovDKY+qdcqKGx6FWOSvmJXu7f3fdhnbjd5L9NlyaLy3qGsp488O85YnbeP0mnMOnjIyUIUiysX3i93wIesfL2vsz45C3NZY2uQrWXNhGrSkiFO0yHKQZ3++J7UXL2NeqL5iwqnTqVPc29aN5FPXs+m+wF47eYJaCE6DHtuin5Kuk4mRY
 mF+51T0c
 PsEdJhk+7Ak89cWU6ujkvxt/2zQHAAJyXZehsQ2/A3mPAYHEBMthcutjzGLm082Wx39lAJ0bp2S/a6jvQgtm63yKpXam4euOqRxebHPTdmnHwnIysVmoqhe11pk/Qx57P0R2WxA5OPxl13mZjW58T3fkCg/DFNq9rHiwy6P80fLUMi9Rd+cbu1fuXw5wS+M+2fv3NaWBTIOKJEHE5+ADr7Yjszu1Cpdaeju+K46FBNTXflBKKiJxkqpZ1cXxRqVdNkdvPJKhKotLg7VQK3QYJUrUJHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stop() always returns 0, and nobody cares.  Change the return type
to void.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 2 +-
 mm/damon/core.c       | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 2661231c0ae82..19b7e839bde0b 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1070,7 +1070,7 @@ static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs
 
 bool damon_initialized(void);
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
-int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
+void damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
 bool damon_is_running(struct damon_ctx *ctx);
 int damon_kdamond_pid(struct damon_ctx *ctx);
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index ef40aa44850ff..1a6c30ae91711 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1946,14 +1946,13 @@ static void __damon_stop(struct damon_ctx *ctx)
  * @ctxs:	an array of the pointers for contexts to stop monitoring
  * @nr_ctxs:	size of @ctxs
  */
-int damon_stop(struct damon_ctx **ctxs, int nr_ctxs)
+void damon_stop(struct damon_ctx **ctxs, int nr_ctxs)
 {
 	int i;
 
 	for (i = 0; i < nr_ctxs; i++)
 		/* nr_running_ctxs is decremented in kdamond_fn */
 		__damon_stop(ctxs[i]);
-	return 0;
 }
 
 /**
-- 
2.47.3

