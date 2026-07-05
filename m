Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A92D8C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 16:02:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E907C6B00BA; Sun,  5 Jul 2026 12:01:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCA436B00B8; Sun,  5 Jul 2026 12:01:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6B5F6B00BB; Sun,  5 Jul 2026 12:01:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 823D66B00B7
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 12:01:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D3BBB8ACF5
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:57 +0000 (UTC)
X-FDA: 84955189074.07.00DF91B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 413AE100007
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UbbfNJdB;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783267316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3RIw27JTOSTlyfe8cMjSamOtT4EJIBcA1pGfiTgLcPw=;
	b=Q5CRpIppJWXn3WAJcIidZTZDnu0+wVdEhFymywxiVJwL5jewqSZLy+cFMtjykq7rqsqSf4
	ZSJ/AEf/HNxjOkSlaEQudD7HoZ6pobv/dbel+5V5/02pWA6s3tPYw8VuWJQvGW9O5C9Myn
	+jGbgHn3Jsb3msM3ODM5SVawWCj47nQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UbbfNJdB;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783267316;
	b=7DPZyXhxawbju3L2fnhazQd2BnQGeUqMKSLInBq2wa7O15DJVwHu5oh/mBGxD16mGGJU5R
	GMKu0e3+fVN4mbgHtgOKiB/zKCkfmEqK5LEtgjsrLyxbLTfHvj+Q3vD9I5RrZjdpVD09+b
	azyC/rTHXibioT3okqbNO7jHO/z+ZoU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E19743C19;
	Sun,  5 Jul 2026 16:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17A11F00A3A;
	Sun,  5 Jul 2026 16:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783267315;
	bh=3RIw27JTOSTlyfe8cMjSamOtT4EJIBcA1pGfiTgLcPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UbbfNJdB8QIuJ/3bBGJ0IeV1eniGxVgfpuuHEutH/bF1qVLpFVgwRADWGbOiqhvd7
	 1OB4UcSonjLJkmfzbGKdMsgu1d7yYjXDx7mDMkt95e6HY/0i4+2KwXAM/WuOPVHUEz
	 oiJJMoKYRt+FMz04uYPXox1egQGQ4uuJJuUWfCSDJoFnA3jbr6qxAyYFDOZEoloOpM
	 yjRHswNIM6iSr7WmPtoYCF7VMP0QvsV9ePlgaayEJMiRsw4pn07+6u2l5g6hUgDCAQ
	 WvC8lWeK1RQ8vyKzO2B36xFec8f7BeykQne1qV/Jb84Fx7/G39NhdtW4r7iarM5zyX
	 gIyX3xEttj95Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 09/11] mm/damon/core: wait ctx stop in damon_call() before reruning an error
Date: Sun,  5 Jul 2026 09:01:36 -0700
Message-ID: <20260705160142.97308-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705160142.97308-1-sj@kernel.org>
References: <20260705160142.97308-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qc8sxc874qn1p9d7iawgphwio5zz8tjn
X-Rspamd-Queue-Id: 413AE100007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783267316-931865
X-HE-Meta: U2FsdGVkX19zMcVfxK+pBNgN8SOhHmg2njaRwcksUubPzLMKLxK1VnlwKevQxfdwpSu5h3EHnsl3FbS5PylsVH8eNGjSbvLueP5nAPVumX0RFghmYZWYCVWNemFzotAXCi26eQvxaTU1FrguNERULzrdLmhAB0h5kymQze44oirNPlbvZkUhOAoUOJs5oCxbqlLJIvNL8FazaCSlLkNWGQVt7lDwzoEafd5a9Ya1exPlBUsLcEwb/u6BakPquMWwx6IZgi0V2drlAIyiymYdLniReA58ksXrEqg0DHUIf72YIsvyaKBEX3zce/tW1FreUEPwDJE6WSGY7nipMBx4mte32StPKNSGPZJbSYnqPXOWwZHlqPRVAG+vRgDMSwZrfYGLii6k1cvNNrPALw07Y0yD+lI4fhjXM38MQB2LI5XFMkqGpsorjHY8sd6d/wpCFUEOkttMoUhWzjpo2u4XZSxxwMqSMdLDHQx89sZNLobzP8T6oXdyrdVEJr1oJJsy97ScP53xybdNMujHfisw3R9hAVzUwrYUJMZN42+2Q3DQvpdvMd0ANVsDpD0+hXABbaMgENjVomMi6Pbsx4w89qcVPYkILFJMMbg8VaPuiSpzW2v2sBUjQwZRGgMg58CyvuSyXpxwPQz7V8IqY711xDfK32bPfVmcKwKbO+DV9lJ/iFADRAnJ91TwBQjYB9fwtfu9ZLhIf37316PpilrSsrJM4oBzA8w6aDUsOv5a4z18bugkXjtMzbByXeSe+A57GhIn+Whvjw0HaTH7zk0VEnXyXIc2TkbdOJRgPHIaecQ1LqoGh+J3QBKOzrC7nZvqetSWUiW51bdi+w/0DI9N/WXbD/9iQNy83chcFE4kRI6u3Iij+nfbtv/wJznEduIGQzZDNI2peSTOJa22FgJmQ+28AbcpymwJv3FoBShm8tUZORkPunze8h9M7qpLTfh+cd8ZOqUjqB+Pk+82Iyt
 Vdc0DTk8
 wEGQnn7JtwGORVYYg29JaKIz74RYHyf+AzQd58ifRhnRqx3mCh+FDglmnEAlBTBzjrVuv7O62hq23nfsy/iUFog2p8WVC7hkN8o395NIVKIXJM6mzf04C/JQnkt0Rue1ql26c7BMjH7SDqjHeqDCw5DRildlDIMiaEaouOvJEBMcrbuCIXegTdb0f5k4Xg5yzx1x4u0pKvLEkHzyrgx/v6E41KkzIZUJtQQMJVs1FeQTTzgHq/FaDterNsElbdiM/Pobr1/Fzw7dNzJrbxU5iidGuvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_call() failure means the DAMON context started its termination.
The termination is asynchronously done in kdamond thread.  The caller's
error handling should handle the race, too.  It is complicated and easy
to make mistakes.

Update damon_call() to ensure the context is stopped in the case, by
waiting until the completion is confirmed.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 08510bf9b38da..390e00b3685ef 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2010,6 +2010,8 @@ int damon_kdamond_pid(struct damon_ctx *ctx)
  * @ctx has succeeded.  Otherwise, this function could fall into an indefinite
  * wait.
  *
+ * When this function is failed, the @ctx is guaranteed to be stopped.
+ *
  * Return: 0 on success, negative error code otherwise.
  */
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
@@ -2022,7 +2024,7 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
 	mutex_lock(&ctx->call_controls_lock);
 	if (ctx->call_controls_obsolete) {
 		mutex_unlock(&ctx->call_controls_lock);
-		return -ECANCELED;
+		goto canceled;
 	}
 	list_add_tail(&control->list, &ctx->call_controls);
 	mutex_unlock(&ctx->call_controls_lock);
@@ -2030,8 +2032,14 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
 		return 0;
 	wait_for_completion(&control->completion);
 	if (control->canceled)
-		return -ECANCELED;
+		goto canceled;
 	return 0;
+
+canceled:
+	while (damon_is_running(ctx))
+		schedule_timeout_idle(msecs_to_jiffies(100));
+	return -ECANCELED;
+
 }
 
 /**
-- 
2.47.3

