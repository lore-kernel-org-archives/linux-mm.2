Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95C69C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 21:55:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84B3F6B0092; Sun, 28 Jun 2026 17:54:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821D66B0095; Sun, 28 Jun 2026 17:54:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 588376B0092; Sun, 28 Jun 2026 17:54:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D0B16B0092
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 17:54:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7BEF5C239F
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:54:56 +0000 (UTC)
X-FDA: 84930676992.26.FFF608F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id EF974C0002
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:54:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eZH0JUwe;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782683694;
	b=c9rY5w2wgqteJzWLLisuNMcxTRPNeLfwRHb4/DyGdGUrxBIMhklciLvH3/6SDG41rVDLEx
	jYL5RIMqX8e0k/5pLSbIVAkMTEyyh9lw716UP5P3wgE5lwcHctQzfQrPl2OH5r7AfmNhOj
	V9ZqgkZNv485u544TJo9XXuBuqddUcg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782683694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qfAQcGY5mXPLuWlFWNsr+GYvFhReWhn1bTVwZS99dfE=;
	b=wESkY0l17LyTxxrjoHarRdZGzYBO+VM+0tI1TqAAgRBpe+RjNvFgy++VHnJ61/mz0v5jYL
	j851O4t3C9Q0OnOZ1J21Ys7Q4cFhHGZptGaXx+3FDqLtIIa8YOD9SBucKotQkg9qPvx6oR
	1x0M5/w+sj1xjHqrqj286arSKawov9Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eZH0JUwe;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96C9760054;
	Sun, 28 Jun 2026 21:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1711F1F00A3F;
	Sun, 28 Jun 2026 21:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782683694;
	bh=qfAQcGY5mXPLuWlFWNsr+GYvFhReWhn1bTVwZS99dfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eZH0JUwelV8LBYd/Rg5FEJMin2KD2M0Y2kTQ2yp7ak5sYnqHB7TuUNVBQ01CGCp+9
	 fQQxMSG6SRtWjZL08fNgx0rBrSJXcHHcsA3ENWFmrZeCTd8W/0KfE2BO9s4DiMB1U0
	 sHRRml1Ajg3GDeOF22vT7cGHUQug2tSkXzECdd1M3sbf+HkzW/YVbu57aCVAHaiwQT
	 SLIWTTpVk2+1L4uJUmGWBjQpovQcz/e+Y+9KMfWqjwExUesG5JLgC6UKxwAWGBgTgR
	 tW1mycjVi6bbZOZwm5ZiuRWVJ3sWF6yLGf6/DTRa40+aSjrPtHzvctDM5OkLsiVRYl
	 VKxdK++8+x/Sw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Subject: [PATCH 3/6] samples/damon/mtier: handle damon_start() failure
Date: Sun, 28 Jun 2026 14:54:42 -0700
Message-ID: <20260628215447.96166-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628215447.96166-1-sj@kernel.org>
References: <20260628215447.96166-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8k4177otqt69y7zru1odmpoeoi47fy93
X-Rspamd-Queue-Id: EF974C0002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782683694-153347
X-HE-Meta: U2FsdGVkX19himqkzGELgp6NU3XPZg7fC8kPO5pj8T0zye4jk6EJ4LPlF7Ozuo5nHEeNl8a4fFZQ/zV8BtkXf4aHl+MxGbxOJq4oNZhJGIkUvLS3dOdd6i00tsZOP0NPLDoTsbTg4bI+aL8P8rK9qnrKeiIx15ezIkyzAp1P3hcLdJYoLNaGTMZJ8mhbF4qdafPNYs+BjZCxD/lZo7RYSNpBzI7+U3Mzo5GDMlkO1LVNYWLeVpJsd+VN/EzNuvjrDXOFfhK8Ek63T2wiZXWlddB5qGUce6Rvvk6YPESTPgjevrZg3lxn6jhMHcWa4F9ytY5QakgZbEG9yWeZ8i4dOcuaTdCBKhfEA/HTfjwcBL/A1xkJxxP7ixWqKwZVAT6Nf9MLvCgtS5/lYsZJNcqIA+tIjCRUIb24dLBj86+VnR9R/afL93YBHJwCZK1X5nWUjlIBs+g3D0gvrcf2GquI1S+qy+vjQ6XI/Q8rkK50Qdwo/Rk0QXGGFcG3Ns2ml6KQJ7daavtEOhBeVYHkvlS5aieLmIdmjhVGHYoyYvzUfY6+d7tt6u3a5ambhwb9/OdOA3z7rATpkNiv2+DV11blr9Baj+JCDnwxlGFk/7bceAHiCk4cLj53LXVB2qveRddTs2ii0F4vc32dTr0Mj8BrI/epgLh/k4bg1fu+/03AKAs9bP+9eQwBTHDR8VgaDK9gY7NoGirGD/CGe9mUNEMHG013zwDP03HedB2MtKM9w4Y09ymQWgNPjN6lwXmO0b/h3KP6ZRUEnOoWPsZMw1u7pXbIWp1M84XyGAHuDMSnJg8IH13zMTzMPWN6U08waxp20Lm3mWs3YM+N+ydVL414p4OW2IHkRM8RLYHx7gnjYjEGxPjVWQonmzUu9rfLCmkitdXraycazJEnMXK2B3gatAcbzdyCOkocB6zWNgXBZaZn+xnLtLr8V3cOltJGqCiz1D6LHDmR8263UzqOkAz
 x6QUhOYu
 mf13iNuKQq0RKkfaTigfd69Ht+3tum6GPkzcfDLQtAZj3ul0XOY/B27sTcVUL88tKtqGoRO6csV9l/5yKvOplzTCnpdOfHazS7wF4/uYLi/GMLsz/Kpq/xjsdp5oi7wijkfkFhNqgW2mh7qYw4Djl+6TEBE+Rd3BotQIm0Ba3RZq+qhwqzRVA1nBtnQiFoVel9vhdAestcyVvZQAAJzNcMI4kKSIH0K3UA19MX5roT/A5fudyqXqh1suaBrk+X1DBZje5I5006hr5ODOFchPj6BRANz14bZDZf04e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sample_mtier_start() callers assume it will clean up resources
when it fails.  And the function does the cleanup for context buildup
failures.  However, it is not doing the cleanup for damon_start()
failure.

As a result, when damon_start() fails, it could leak the memory for
DAMON context.  Also, if damon_start() fails for only the second
context, the first context will indefinitely run, and avoid starting
other DAMON contexts since it is running in the exclusive mode.  Stop
possibly started DAMON context and free the contexts in case of the
failure to fix the issues.

Note that the issue can reliably be reproduced because the module calls
damon_start() in the exclusive mode.  For example,

    $ sudo damo start
    $ echo Y | sudo tee /sys/module/damon_sample_mtier/parameters/enabled
    $ sudo cat /proc/allocinfo | grep damon_new_ctx

Because the first command is running another DAMON instance, the second
command fails the damon_start() call because the new DAMON instance
cannot exclusively run.  And without this fix, by repeating the second
and the third commands above, we can show the memory consumption is only
increasing due to the leaks.  It requires the sudo permission though.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260608112455.274231F00893@smtp.kernel.org

Fixes: 82a08bde3cf7 ("samples/damon: implement a DAMON module for memory tiering")
Cc: <stable@vger.kernel.org> # 6.16.x
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Signed-off-by: SJ Park <sj@kernel.org>
---
 samples/damon/mtier.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index eb1143de8df17..66b591f2180fa 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -174,6 +174,7 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 static int damon_sample_mtier_start(void)
 {
 	struct damon_ctx *ctx;
+	int err;
 
 	ctx = damon_sample_mtier_build_ctx(true);
 	if (!ctx)
@@ -185,7 +186,15 @@ static int damon_sample_mtier_start(void)
 		return -ENOMEM;
 	}
 	ctxs[1] = ctx;
-	return damon_start(ctxs, 2, true);
+	err = damon_start(ctxs, 2, true);
+	if (!err)
+		return 0;
+
+	if (damon_is_running(ctxs[0]))
+		damon_stop(ctxs, 1);
+	damon_destroy_ctx(ctxs[0]);
+	damon_destroy_ctx(ctxs[1]);
+	return err;
 }
 
 static void damon_sample_mtier_stop(void)
-- 
2.47.3

