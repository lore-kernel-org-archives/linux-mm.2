Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC67EC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4CF36B00D5; Mon,  6 Jul 2026 10:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF9606B00DC; Mon,  6 Jul 2026 10:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94B656B00D9; Mon,  6 Jul 2026 10:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63DA06B00D8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:06:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF8F41C28E0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:43 +0000 (UTC)
X-FDA: 84958527486.02.079E8DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 541DCC0013
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fbo1+XSl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783346802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3RIw27JTOSTlyfe8cMjSamOtT4EJIBcA1pGfiTgLcPw=;
	b=grEsPgKmAtK6kL0dXurNuiCttMLIeCgDqHfrwHi4F7pXYk49D09P+MCHlSrN8fR1advdFY
	YbFRl7tMJ/V/f5NC7s9sj2IqZj2rMZ6hSiQt5si/0KsNsRHXvA0OugkfzrwfFkrb4mnlen
	KJLU9MwMiEBz06MVVdGlpm7HznrdhFE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fbo1+XSl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783346802;
	b=c9q744Od+eYKe36/Ip73ECEv8m1UYrOB+DRzGWRov4ZrHT6rjMVfSwLQazcUvRAA9dNRUP
	YEGvrYKvApT2D0v8+h4C//lw0yFzTQWwh9A55nLhILrO+KxQ18FjPnc4xPI8xbpDlIqqkE
	w5mcuE9IQf+6Ml5fK6s1zkpAXOv0AXw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DFCAF600AE;
	Mon,  6 Jul 2026 14:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509A21F00A3F;
	Mon,  6 Jul 2026 14:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783346801;
	bh=3RIw27JTOSTlyfe8cMjSamOtT4EJIBcA1pGfiTgLcPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fbo1+XSlqvsC5wNxcRGB7fJ2IrKeLMrUvwyQ8FxRGAQaJxhTdhbSiZ4IvfwsD0UJq
	 NiYqLiFDd0QTPt/zoqZVjxpKRjOW4e2vHEgGFdZ+CeBTjkovHvxxoJouBDpDDdRUbg
	 GjXojLnQgN9fLEoty12+REDB6Fs9WTbG7Xq2EDs3NChteU0uh+2WvjhUS11b8Pp0lo
	 8gyDnBeboZ6wAjz+i+jw1FDLyLr1Zal+Gp0JHF0rKJCspRGdAiW6vBy/IV1K2lHgeo
	 o92uxG24BWmsEn/YXEQXK5tiIkhSFx0aa7Wnyel/7qLv3bTtqHvFZR6UyZrkJ0LIdZ
	 mHsEB8GAEDBlQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/11] mm/damon/core: wait ctx stop in damon_call() before reruning an error
Date: Mon,  6 Jul 2026 07:06:24 -0700
Message-ID: <20260706140628.87414-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706140628.87414-1-sj@kernel.org>
References: <20260706140628.87414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 541DCC0013
X-Stat-Signature: swnxpqbrsxhzw9drhnic89h5xj6eqmqg
X-HE-Tag: 1783346802-990414
X-HE-Meta: U2FsdGVkX1+awFBH1vn7jzqcbKz1NZWevDIAyHfZikntjum7pAop3xS9RwdYXBgQ+eDWaUOIG68zQQeWcyhQewnx/+QZNRadmyeyuA1hQ326V5yWWgvm3Q+PKB9ApMDbut+64A4I9Qi4rkhUalzZbQdBxi+GHalXzbF7AKIVHsw398Ts0JKEcQHn9fakkKn7s1AqIOF67aVvEP+vfdEwjYjG18b+hP4H34B55tI8s6sBTeaP/Cpnie9H5qsgynkuKI1Kr1/8w0hnPEy7mCoIZBmKm+KtyHPUsRn+8qRt+10EE+hVIhezSYwLJET5Yl7+BM5LF7g4d6oQ0trpiVSYbxwD1DnTyO2fa71o4bnpMGyPN6P3msP+oUGCQUs3qgcgnuW1Qut+xoBzdYUxyAW4um1fr9oGVCODpKLspy3LNEVoVgUHJL4qJyZq2ECC+RnLqnqS9nX4El124+y3hh5SiOth9n2x8v8NimzNLuLOgDckdoYAmFdyUKnjAhBBPtwUBsV1CkhdIPffs5CZJ8llEQ5ztXjE1xYfYKMoywcK194JnjKyfDBq/M2+v7Pbn4FKba3aB+bxLs+qJ1SDlR2Prws+jFRv8JvbNeBydmoJlBbiAb6dZrLvL/N8Q1a+XgeKXLIMXfSFeOXNOSOMfnlv7CARxRGIoBP8MiSeH+IyjpKeWr7MCr5MzQsD/s8UrmGZlWmP5IpDS3IQMBdo4Y6cBydbkWz3+9xkq9flZnySUiBfVHC2TOCkOIpVgOZMlM6NMC2L3rHS7hfvuW9rxPX2ziiPxe6FbnbNX9pyIs9dlw9ehDmUb8O1IbMLSlwM0GuDVNxh6Y6JcFDQhCwHLFEaXk7UQPowbTkd7lKYLWJg6JN/s6PuF/nSOs4sy52LPFOk3zjs7q/gguupBqRpE5IkQyxARDjbXH+r4I9fc3PhqdCIVfzA6JopCOGCYg/gBNGI5CYwWmRrS28lBRDtWZ9
 8GSBxbMl
 G/0CPYR44UL1Zm87d8U5Zu+3xbs5rcJmOjLRmQWUVVai1ygz984jLLZ/NNRJBmwDRpTlSKaq12QLr9kkdCx7C2tb4eYFjpgVWnmCqWwPf9HSoxsAfwnJbrBIcS6jQk6hs1W7mBgFsyqrcs8vpWr/DLdtE1hoMoh9WfhRj5zXmi8/DnXymDWyP5eK6oxG4k6HN0TeZE0BlTvPoEeoew8sP2F3/MtuqKfOJOBzcKhJW9MvBiZwKzc73zhh9y664/etbIawcA9MAVBr+Hs4TpgVNCehD7w==
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

