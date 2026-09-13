Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBA50C88E63
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 17:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5715C6B00AA; Sun, 13 Sep 2026 13:17:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 522636B00AC; Sun, 13 Sep 2026 13:17:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E90D6B00AD; Sun, 13 Sep 2026 13:17:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C63866B00AA
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 13:17:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 37FD84088B
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:17:18 +0000 (UTC)
X-FDA: 85209394956.07.91FEC52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A073A2000A
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:17:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OZqCBSZU;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789319836;
	b=x2QoC9Qc1uzNWyrgC2I6EvSdUoNkUWnJXU1406b002QHKP/5pdfhSSEMdouuA4XVWuLrTD
	x9FTSJxWp7eyHEP5r30X8jnuYRrLjdpYAXQpGbIts02elKWuY7LYXO9NkN5ydKBMdif93m
	UHGjUT2xQ1nkpPCKHWf8zza2xNqIGjQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OZqCBSZU;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789319836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPljEC41AE/9V3Eb7L+bcMCBYD4RAk8iJtQDR/e+uUw=;
	b=slKeBd90FUzbYHxTO+jNM0nUZpvR+3i+NCzYPPK3BW7eOZtUk0vFPApboiIdMCJvIyPlpY
	tuYKc8skqsq6BxlJ+Y778YxbkmxaUqfrZyfslUKtodH8iJYd7uvFgscjF6ygjn/igF5/Iz
	BNfOD5K34IBrR1HBrnhctMZliGKU7AY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D2462406D0;
	Sun, 13 Sep 2026 17:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9061F0089A;
	Sun, 13 Sep 2026 17:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789319835;
	bh=hPljEC41AE/9V3Eb7L+bcMCBYD4RAk8iJtQDR/e+uUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZqCBSZUf/wQ/7MYqIfkvWxbZ4LmvLyMBfTw8zz3VNihGmgE3PHX+t8GljC//GAtv
	 IXTqNmPCVRLj/0+JPAfXmbAJh3vqi1T5btpqHhI0y8l+FIc3vXJ903nUnY2JXNB0hd
	 FUL/VGgP+3+M1fo0Utf/5Ep3AAwJULWe7mL8QiHYjMoThnKWhtjazHkPLKvQ3DfLON
	 IvivD4wTgidbdYci5d9MkpedjdF+oR4gXwLeAsDi/HpiMdmAPQQ0v8ZH11RLIVjDm/
	 8e3Y3e3HTlUsLdiAPPpN0fAnCty1kx3IzL6JKcCvmW2OKLD8S69I3vuww+ObjQwaaS
	 a0we1B1eAtS1w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 3/8] mm/damon/core: return an error from damos_commit_filter_arg()
Date: Sun, 13 Sep 2026 10:17:00 -0700
Message-ID: <20260913171706.103052-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260913171706.103052-1-sj@kernel.org>
References: <20260913171706.103052-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A073A2000A
X-Stat-Signature: g6bey3db78pqw5xc74iofn6xqmht87b5
X-HE-Tag: 1789319836-381402
X-HE-Meta: U2FsdGVkX1/7PuO5gwaC1OoOBRU+UxSbKyPP6ri89d2sFu3NCcz3no83iF2NON2DuCmP+Ggex7g7MdovU299soH+U9A3RLCtQOplQiOur//bp8X/0AvOTs22PhZ/3rt0o2lAH1Vb+yYmNsYU5M5e3MIAHP6ezTZg88qrQPu6AGj6s7nIxpl1AgcJ2svkp1LTTnvQufKNm4XgLx1zOMLPSH4+FuyAG84O2dqTJQbFn+uHA4TBp8WltP9G6RFuDBrDlHTixrTiltDwEdv2FjTBb6MfYQAAQ71Cq7pQAZccgZKRq5ERlr6L+hMUTvQKODI/GO/MViDvUtBUUCvUsR030Tz+Z5esSHs55VP4wZE4kVOFpQEtT/ZhgH077GCW6q1D6RyXY9kh2CTmLA+UZhw1UZY2cPFAbK4vl7S6GcyzRk3vFvQUPC/nHFI41E96BcKKTsMsHURoOTQ3ncX1btE2lpgmmxJRIDtpjS03O8oGi8NnAI5lzJ3P7tOni/LewDK0Tcf7UpdjlF5a/XL1QMipytDZ4gt40+t9mhwaQvYyaH3Kbr04u+U4vfMR45gdjOYdBBmhqcUWyJhRY2ugruH6P3KcvUUM//UJdwCPrv2a4CQFaRgfz6Kth1WS6EtXavVHLnd7FPZDcotee0SqYtZ2ZL1mAch8i+PS7n+nO7zOdzZ1Rw3xSDjILa1AukKxbhAEZaExB4xsx0qhNaUzFSfaO4T3WBAY3sL52PRh2I5Eh67Dh77jVA1rO4Z5r8xazf8LRc9H8Z6/fkqDfOHro7jW+3xtfzG7X3kuC8ITQoG2m7PZWZcvFsdR9svX3W9z8Ie/Y5bBsq9uh3WHh8yvvCbaYB171pB7DoJYdI3lX7ZRTQgCY4BuROOI8PE+ScQAf4ZqRtMk6aLOejxckWm8Q0I4w6TfOI9mCbx9f8+7LwaTinIblKEdDXhbgaGagW5XXDkXQhP3IeBW0dvtpLjS5KZ
 barLUpls
 OUagACrBkNcDCE8vJGqKvgCtWHZ0zekcA/m2IjlCLgQ/PG4FIMzrWONZ8XGnjFXOXq+sy34VNrrMndemojeuoUlTpERjkdSiPIx7++wHjH4utIJKq/q/v+1Ce8wOBAB/8i6sd/su/uGd8+ym36k159I0dzRwiZ7z+p/gZt2gQj1GpBW5fd3tnWTaKhtGLTA3EwKpOyYvE6o4KVcWKjWSJG9gnww1KWqlQhUeNG2CsTaX4I5w3TBJmb2JKvmau0zM+wAyk96QDuqQGBDXTdD13eLWZXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_commit_filter_arg() is supposed to always succeed.  It may not in
future, for example, if the given filter is invalid.  Prepare the case
by modifying its signature to return an error when it failed.  Also pipe
the return value to its callers and let them handle the error.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3d7a973ea8b6f..ea7d8d5a4abf6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1317,7 +1317,7 @@ static struct damos_filter *damos_nth_ops_filter(int n, struct damos *s)
 	return NULL;
 }
 
-static void damos_commit_filter_arg(
+static int damos_commit_filter_arg(
 		struct damos_filter *dst, struct damos_filter *src)
 {
 	switch (dst->type) {
@@ -1340,28 +1340,32 @@ static void damos_commit_filter_arg(
 	default:
 		break;
 	}
+	return 0;
 }
 
-static void damos_commit_filter(
+static int damos_commit_filter(
 		struct damos_filter *dst, struct damos_filter *src)
 {
 	dst->type = src->type;
 	dst->matching = src->matching;
 	dst->allow = src->allow;
-	damos_commit_filter_arg(dst, src);
+	return damos_commit_filter_arg(dst, src);
 }
 
 static int damos_commit_core_filters(struct damos *dst, struct damos *src)
 {
 	struct damos_filter *dst_filter, *next, *src_filter, *new_filter;
-	int i = 0, j = 0;
+	int i = 0, j = 0, err;
 
 	damos_for_each_core_filter_safe(dst_filter, next, dst) {
 		src_filter = damos_nth_core_filter(i++, src);
-		if (src_filter)
-			damos_commit_filter(dst_filter, src_filter);
-		else
+		if (src_filter) {
+			err = damos_commit_filter(dst_filter, src_filter);
+			if (err)
+				return err;
+		} else {
 			damos_destroy_filter(dst_filter);
+		}
 	}
 
 	damos_for_each_core_filter_safe(src_filter, next, src) {
@@ -1373,7 +1377,11 @@ static int damos_commit_core_filters(struct damos *dst, struct damos *src)
 				src_filter->allow);
 		if (!new_filter)
 			return -ENOMEM;
-		damos_commit_filter_arg(new_filter, src_filter);
+		err = damos_commit_filter_arg(new_filter, src_filter);
+		if (err) {
+			damos_destroy_filter(new_filter);
+			return err;
+		}
 		damos_add_filter(dst, new_filter);
 	}
 	return 0;
@@ -1382,14 +1390,17 @@ static int damos_commit_core_filters(struct damos *dst, struct damos *src)
 static int damos_commit_ops_filters(struct damos *dst, struct damos *src)
 {
 	struct damos_filter *dst_filter, *next, *src_filter, *new_filter;
-	int i = 0, j = 0;
+	int i = 0, j = 0, err;
 
 	damos_for_each_ops_filter_safe(dst_filter, next, dst) {
 		src_filter = damos_nth_ops_filter(i++, src);
-		if (src_filter)
-			damos_commit_filter(dst_filter, src_filter);
-		else
+		if (src_filter) {
+			err = damos_commit_filter(dst_filter, src_filter);
+			if (err)
+				return err;
+		} else {
 			damos_destroy_filter(dst_filter);
+		}
 	}
 
 	damos_for_each_ops_filter_safe(src_filter, next, src) {
@@ -1401,7 +1412,11 @@ static int damos_commit_ops_filters(struct damos *dst, struct damos *src)
 				src_filter->allow);
 		if (!new_filter)
 			return -ENOMEM;
-		damos_commit_filter_arg(new_filter, src_filter);
+		err = damos_commit_filter_arg(new_filter, src_filter);
+		if (err) {
+			damos_destroy_filter(new_filter);
+			return err;
+		}
 		damos_add_filter(dst, new_filter);
 	}
 	return 0;
-- 
2.47.3

