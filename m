Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B83BC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFE6B6B00BA; Wed,  1 Jul 2026 10:48:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7116B00BB; Wed,  1 Jul 2026 10:48:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12B16B00BC; Wed,  1 Jul 2026 10:48:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83B246B00BA
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:48:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0ECF01C5F4E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:48:28 +0000 (UTC)
X-FDA: 84940488696.09.86E22E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7E3AC20009
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:48:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CeHg43Rn;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782917306;
	b=AZ+UrEumfVRFRrw/MHl+1BsTKFcB8Hm+rWIo6jXwhjkurVYLbTw/lsXUh0QIJwg780cVWH
	r1M+DcDTVpwvJaFfqgUAa5PI6u4YRrlYwqgBD4UTxEUNGj2t9KmmmpNCFDh+BkuYS7oYsJ
	49k+b8mZ+sQMwH2iRCYHIMB3R98S9ZM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782917306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BLtPouv7eTzT2uQvAh/J7SZwGEEh8mUIs2EK62lyYMI=;
	b=S7BeF/7Be0/XlQScXUCktCRG7dotUGD8Ul8wgm7RQ6kYkb4sbqSKx4tekzHvu1h7KPnIds
	tWbDmlNl8w+iddLFZ2w76HOUaSlElUNQe65HRokhssYKi4drXeFOzx2GQNbKk6thSAzPJ1
	ud2X2rVL1pWcKc5wFbqERVFxGS7UWH8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CeHg43Rn;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 18FB260138;
	Wed,  1 Jul 2026 14:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9013B1F00A3E;
	Wed,  1 Jul 2026 14:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782917305;
	bh=BLtPouv7eTzT2uQvAh/J7SZwGEEh8mUIs2EK62lyYMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CeHg43RnI1LV8nyCsPHx9+XpeFcYyUIYoxkNve9MFbcxVkX79J0BOYHlUetIvE3Um
	 pSpNLNsRGtbarEsEhGHOBni6Ww9G+FLrAfpilTglDfCMjwS6LD7HkpwRrU+PyRo1/l
	 eCAlC0o9hsJxoHZPdUssVCF0p5rw1Bxn0YcqxdlMX3X8c/2DsRxNiqB/xGAskvadvh
	 zdNZYnRSwIrT4eNH5j/ZeAQzW167uLQgxmVu5VtwLN8Vh0EA2bIygyNdKbFmkDVjyP
	 roHdiliLKe5psBkOP42Hj0vlgzQTeQi4tcGrJMIuIyzw1Br3Cx/m51wISaJgvxkppo
	 fx2YzBbVZOqvQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/8] mm/damon/sysfs: remove duplicated commit input validity check
Date: Wed,  1 Jul 2026 07:48:05 -0700
Message-ID: <20260701144815.113325-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260701144815.113325-1-sj@kernel.org>
References: <20260701144815.113325-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7E3AC20009
X-Stat-Signature: 39ecw3oy9j4ytxh5xqfqzpnu4q8kd637
X-HE-Tag: 1782917306-818757
X-HE-Meta: U2FsdGVkX1/q3R62HtbWZCYES/pcneTL59R5Nh14Ne0BKrT0bDO4h0aVIoHYjMpy5dKKNImQN7NI1aNmPLu/+rRANigkjKf49cdAwvEJq7dRmIIhwIFTpKFemmH6PnEJawRnTDOnd8DLPwt/UnbRyjxYbxuegslhXPnALRTmpG2m1limDaJA24k6NNcMJJwHEwc2FFktDLQFZh2SiUmj5gsBFgRO6mdlkt/kUTanMO4qeXsvZNgHKifFFTo7KcyxYaIvxprHIdeqnQyfAHhDETSxH8zZdcklOBkDbkftjydCJukqzxmFJ7JszoqXiZ4Hgh5Kx0WE+U91IgqJ5rXIppiUSO+Q/wTT7LNy3EtvcLVUuvIX1h1qDkxLwFtjD3s7iIIzF1DaQO83Xu73R8AlQDR6BmvGht2TeEnVIj0DpaV4w3YWV0u71I5ltOXXYlts+mnHvB5xNYQGMVzXxQcYXBGc/NkJS1EA9XnFwgo/eskO0OLGocrjO4LY8F3hk5iGwws3mdPanBs9G/jQ1jQwhfU8v7r5Vx0x/oza07TP1hcULB+FSNLG0MRbkN4LiiskSk1cOHmxpFC6FyE+3RjjztrUfVXvgEp9Lr1XIC4OKs05GzAw2qCvJeOQHu2KeHHmz1/fBWLlcyaXhZuLCi8O8dNJRVcnAQc44lH+UrWAzeHSDCj5+OIHiO1GP2VX75PPFxi4VKHbc6/lOY4qtNsZP5zCTI8AxGG1Fd0m26XWo7AzMu33nmsMToHeQQGOuisjz9f5Ah7cua1nJBdOpbELmMcEQCUf/O2Oi71BsID1CnLOw489IpGq4FEHMCXkgnLBKuRyhKh5AV+ptEnrxmI19RORn/1MjsNWaFB28pDJdXdspHgITmqqUrjDunnodAUVkhZnbDSS8jD8zq+VBbzdk1xe//o47WVNAktGzhIIfV9TYLxvnb2KdEQEzdZdWaUauY9sfw604WTl2BD/LFC
 QGiFUJiP
 zQQduAAkZTtwNxl+kghifqqrFJlmEZ7U7/inSvIAHX1NxLs99W8+2pniu3oYe1vIsKSWddQg8Cg5T1na5AibGWFCgrfIyVcn3a7ijKOrZQv6HiHK46FeyARMza2qXOHdK+pLp+nJ6/3mlUFIGeCMzlUl0yq1vsCbmmC83RTubXZ+lFuI3YtBpEud3b7loNWHiWVf7cAB9+HYoG72Dyf0schDhEd82sXzkDKGgLhpTRcqXiBc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface does parameters validation-purpose
damon_commit_ctx() calls for parameters update.  Now the same logic is
embedded inside damon_commit_ctx() itself.  Hence, the validation in
DAMON sysfs interface is just an unnecessary duplicate.  Remove it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 32 +-------------------------------
 1 file changed, 1 insertion(+), 31 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6710b6d019bf5..e666dddf1feba 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2098,26 +2098,6 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 static struct damon_ctx *damon_sysfs_build_ctx(
 		struct damon_sysfs_context *sys_ctx);
 
-/*
- * Return a new damon_ctx for testing new parameters to commit.
- */
-static struct damon_ctx *damon_sysfs_new_test_ctx(
-		struct damon_ctx *running_ctx)
-{
-	struct damon_ctx *test_ctx;
-	int err;
-
-	test_ctx = damon_new_ctx();
-	if (!test_ctx)
-		return NULL;
-	err = damon_commit_ctx(test_ctx, running_ctx);
-	if (err) {
-		damon_destroy_ctx(test_ctx);
-		return NULL;
-	}
-	return test_ctx;
-}
-
 /*
  * damon_sysfs_commit_input() - Commit user inputs to a running kdamond.
  * @kdamond:	The kobject wrapper for the associated kdamond.
@@ -2127,7 +2107,7 @@ static struct damon_ctx *damon_sysfs_new_test_ctx(
 static int damon_sysfs_commit_input(void *data)
 {
 	struct damon_sysfs_kdamond *kdamond = data;
-	struct damon_ctx *param_ctx, *test_ctx;
+	struct damon_ctx *param_ctx;
 	int err;
 
 	if (!damon_sysfs_kdamond_running(kdamond))
@@ -2139,17 +2119,7 @@ static int damon_sysfs_commit_input(void *data)
 	param_ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
-	test_ctx = damon_sysfs_new_test_ctx(kdamond->damon_ctx);
-	if (!test_ctx) {
-		damon_destroy_ctx(param_ctx);
-		return -ENOMEM;
-	}
-	err = damon_commit_ctx(test_ctx, param_ctx);
-	if (err)
-		goto out;
 	err = damon_commit_ctx(kdamond->damon_ctx, param_ctx);
-out:
-	damon_destroy_ctx(test_ctx);
 	damon_destroy_ctx(param_ctx);
 	return err;
 }
-- 
2.47.3

