Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4157FC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2A7A6B00A7; Mon, 14 Sep 2026 10:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D45F96B00AA; Mon, 14 Sep 2026 10:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDDD86B009E; Mon, 14 Sep 2026 10:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 923DB6B009F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:23:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A0C54005F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:23:38 +0000 (UTC)
X-FDA: 85212586116.28.698381F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0D876100003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:23:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xg1NrFwB;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789395817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IylFMzfsfQcR17Grot5+mj67UZj/L3bUEkgF2gj/ftI=;
	b=xBxAwloF1TOZjCnzaMHM2GyFqNCcEBKU9m7FjDpkzinmzEf05kme+SqptRYY4cWpxiPjN9
	tK3JXByflcgpTSGHiFMAwU+UOYKCxUxnlQDU2Jbo5C4UzMZzU+F1sdXFKoy5qtfZibPU1q
	TYZ4ia3kt7Foz4bmvbpz+VbRxu72PT4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789395817;
	b=39BZ0DHcVAinGbI++OetDdONZbym7UUIABos3QQU7+YWeOnIkVPeCz2sgUPwxh5bgipElU
	rLYMz9VcB+xXDwYrpQDXFBchL0vDImxbaPJglD8lVBcJPJlc83uzCnkQI8fPfs1nbNTXJp
	5Y7pLrdTuuLvnMSzK4V3pP+7ixj/BcU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xg1NrFwB;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9DF8E60218;
	Mon, 14 Sep 2026 14:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7681F00893;
	Mon, 14 Sep 2026 14:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789395816;
	bh=IylFMzfsfQcR17Grot5+mj67UZj/L3bUEkgF2gj/ftI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xg1NrFwB1YiQuae9W8eyekK7DWN6FL90M2yHBgePYlP/g6HCOFtpH7ktN0pmbj9I+
	 u98a3NTVNeBJBmwXFvzqTiDx8AWb6rvl56oWwlaKNcOKwAGeH5gSCKNHVPrWWrEzg3
	 8kM/QzQj0fG50L8/etXomiCEc32jfGYUkT2isU5DClyo0FYkL1pPtgUvzkznHhQP8E
	 7EmD2UzTkGlstsJDm0SS1TsFv/GuVLwpqAsuVuuPHo8Vy7OcW+B1H+A90tHpSX6b7f
	 bzLPY2QQSpQDR3Y6motIVexQNMf75iW8nWQouD8Aqk9nzLqNAyVHBeu6kchiWEYyyw
	 oFt95gSnHdTVA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/8] mm/damon/core: return an error from damos_commit_filter_arg()
Date: Mon, 14 Sep 2026 07:23:20 -0700
Message-ID: <20260914142327.92510-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914142327.92510-1-sj@kernel.org>
References: <20260914142327.92510-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: z4x5k6rzq9jsqsohisp3gy8e7r4q4a1c
X-Rspamd-Queue-Id: 0D876100003
X-HE-Tag: 1789395816-440155
X-HE-Meta: U2FsdGVkX18EhrOgf1YIIak4j1ut9PU3/pvKmSlk0nLvh48tIzpfumK7fJ2Xgxna6sEYucoOPT03v/z/IpKhBXd19jqiNhs7bwpaKcxK+A7iXEmtQVP1KMMfTBMNdnjetCqRlfaYgWH7ZwS37EAMaBWc2hgawTEEjfsEwMR08bvd+lC+E0w4V6zwEa8IJGPZR5M5FNtT3QHyCnX/2M28+AXmP7pvAgCtiJiBguqQGrhQFsG8huddtC9R7sbhgw8tM2uQdBb+TZa4rUtqit+az9gAWWBB6IJzKFjnmoEQd02BzE19H4TsVW8+UDirvYD5TENJ735LsEUVphfEy6oISmmZDEq1pUQln+YnbKo4j1iSjJMvszgP1pZVrPvj4wxzz5hEAcpvx5MmGTBqKVu3zJw5UVoHYqjCTIeLGF49rEBcpnIa5rJIRLqpyqiJ2z01n+0hNa06XaRdbHEKt08ch/eJRo8mNWKZ77nany0RnIQsJNwpm514StsQfGDUyTozGcYaw15eAJCR1uaZH0hXmiEYkgR26OQfUcysEYojkXyoK7wgw2KjkLaxea2At6SOHgCMQoEZaBLVyIVGNJu5SG9Nm6EEm8jlspgs7LnIy3rsim+LBXEUfZPi/dd8YIt7YEgGUAYlrvDqLq2AtgRyHj1MIXr40dZ4fCuCPoqKJXwPRa+x5IhtFz5vaEMFSwG6tRLbl8eRzVvR2WuT6beeGNnG1oagOTjsgIk97Cfdx/f0Y0FVENIbNSxzRQpD9n+leBCFsosQ7R4w5ENefjAXlSRIQ8n0XZOVc+avRQzqQoIvHdjvq3nNOOfeE0rHBqx0Mn7D1Qq7VhNjrAkd2AZS6qpD5lLxJ69FS6U1JR7Z6cl6SkppAQYvuTSHZwOK38SDu9Vur4cW8mzGfozBG6r610CMy3iwCivoJX37nKkqcCIvi/ZKoRFkGsmJwjd5ACf9YyvTLUZAz0RuqG24Li/
 V7+dfauu
 q3bqvQDfqij6r7dGKuoxl989U1qyBdk3z1aB/gpUb4FXJbUFXFM2cEJXNv2989P5MM/ESE75I1RqXDC266ByE5csHeUr/HXMJc3GmeQ4xr6PUVuaPCc02vF7tn7ESxhhd6xV+lSFIwfSMOU9xnRBXxTz6NjO8R4O7wFt3aPSmPUhlsrEXCG1m3mxSob9Z+ldy9NiNw7ZJpyl6SlChhz2oc8XXXqPhXnj8FAaVZnzl9a27AZlz+M4LKLkjkESTx/38ih43JXlOZbO4CH8aHWTmjhSo2Q==
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
index 0c98f7e267d07..94ea63084a24d 100644
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

