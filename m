Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40466C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CA2C6B0092; Wed,  2 Sep 2026 01:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23BDB6B0098; Wed,  2 Sep 2026 01:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B63B6B0096; Wed,  2 Sep 2026 01:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5D686B008A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:47:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6DCE7A4702
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:57 +0000 (UTC)
X-FDA: 85167740994.12.1DAF31F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id DDF3A100006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E5MjcTJw;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788328075;
	b=eAoDzRpE1ULNff14hZKPVFPOJg5WBXeUbSL7G/TFVBINTTNrdbIMHDkkkNlEYlr95d4FSq
	utgNHfL4XlSD4JD8yCvArbo1v8S2csmwGL+XfeSK9ZfMgddtT7JZYsJR8t129jjhl08Y8g
	bAfSYA5u3AvxbiWFgvEw8l3M1DTlM6o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E5MjcTJw;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788328075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yu+kT4VU1Q3i6GWtmiuhnaqb1nzKb+1ULapfSNKwafk=;
	b=7FIXx0gA8f26jksOFgUN36IdglQtTy0EG/Rax4FOU94uqnL7CiIdqnA8avG7PYWUFFMRYe
	/jwEclEyhMPJkrlfUhvDDlFCs7232Lr1aAbHo7J9mr1vtv/Mq2FYBYsnbyLpRYWbDueNDp
	QVx+AuFwztTy4DtUvhtDMV6oQOcxD/c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7847B602A8;
	Wed,  2 Sep 2026 05:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080841F00A3D;
	Wed,  2 Sep 2026 05:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328075;
	bh=Yu+kT4VU1Q3i6GWtmiuhnaqb1nzKb+1ULapfSNKwafk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E5MjcTJwwhXNehqyFOOBR5dL59vQgGiEePFKoIM3UBF501RxMgTX2frXPSBmDnsRt
	 JxaGVX44e6bMgyMMjtZPq1IZGPJoH/rfodeniXcXTM6iKFGCk6+TeT8rcnBt/Mf2Wi
	 2NZxQWYuwGxEmRNHT6sbv+qiRz1zwn5bB0j1obRDCmxwZybwerjxoYJx59uv3JSQ1o
	 DTWv5VKeulzi+NgJH392KdCLINF9B4zNWNXnMiib7YDxZsBkPFjQqLVrHaJgbF7U5I
	 btdZBZAdMDNEi+lfowYsQRsrsERQWG3OtppWdH051vAbEblAHcQ9J5fBt8M6BdpiF4
	 MtvqJActMDYFQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/12] mm/damon/core: remove debug messages
Date: Tue,  1 Sep 2026 22:47:35 -0700
Message-ID: <20260902054747.99370-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902054747.99370-1-sj@kernel.org>
References: <20260902054747.99370-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DDF3A100006
X-Stat-Signature: 3upmupw6z3pen6483kotybat1z1t3qxw
X-Rspam-User: 
X-HE-Tag: 1788328075-558203
X-HE-Meta: U2FsdGVkX1+qZsuqtM7vSWccJHPjwkAPei/i078Iho+1ln7Z0H32iGoGq8Gm0WEB+u+XRGGrzwa2pyShYDGJ7er8jopxTdrkCZnRKljEK4xnD0yVRmVJuHPhS8ZV9Dk44gmbIXYv+WzPFJpbvsTVaJFHK94i1J0UNRZqqLnqRI52M0NqGYgHeqosYnoSwkpV1TLa0bPrBiVqIZEVJJ9/RFSViXdYNK2YIFzvNB/s1LgIJrPYtbmVnadnYLBJKBY7hDx63Ehg8HDe5q7KjutVKp99G+kBqSVf/W7ywpRA8AiMN+VKdANnzSMWf8hJ3ygHbxF+6avdAQSYf0iyGtADhedagQALG8dmaEEuLtoYgUKz/UQ4GkW8lDhGxvKix+wzbasj2ZHY/ZUwmP8C6phG7Q2umpdcoR07izjsXCzJG2IeGSxh/GryITj07xJcUd2koTUhYjYiPtxbIbnaW6LnSjS8r3MTBnszfvFqj8naJXbg1SEzBlcQYZlxNS3ym/MlQpvGW/jlWZpfh0rGnSKfhN9QlCdj4h16asQQ8DPCY+yTQ86pv0STllJpUvelQd6+VaZcUmLgux0MbNVxRV2318LHnL5h1dlw7EJ6M4UwBaU2xw+Ft2r7jv629XZlVNCkrY1UwP22cs51y+OKaNHUURzjJFPp0Il0IYI9JKy7VOKtRVnrKHhZ1AumPAARN/wxA/59zUBrLIfNmSSw48DsRKDSfR3MxAyEqnVLKL/8B4QZrJtMkuP2LOMB71HuBxciNXweNNcdqOmySbQio8KcfX5OXDtGqAVk92AwG/CnEQhmdggpfE6FckPeHTyBY69mGNaeDDdwfXFVHkZb9LXrkUG4OcfUjb5G8e+0zbt/NEzXlIOHfDGocEMwzCT3m950qwf0DbwF/OIqMYhYVefIWlgqcq3MugF4NMa/yruKbMZNZjU1vCUmWeRT4UiwrQnBxIBQoc+5BAqo3WtRgyI
 50699oQR
 XUG0+pg3h91jscNSnVcSHVDCFsOxaFj6mMjrd1UxoXT2B5bwH9EUo4RkRXwm0PHZSh5ZYOWVyy657AiieQFO2t/dKi8+i3NWXmNkk9T68KNlQm3rSx+orvMa8nrOzdluHC6vC/fK4bDbVv0AaRkYEJMMryimRbtv/cD/Bf1i8aJUyyfPL8JDi9AajJEM3nechq6/vXb5fCXaCQc1sxgo6VBwB7dhTFaUhEKnepetTtsFq1Kc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are a few debug messages in DAMON core.  Those have not really
been used in a meaningful way for the last few years, though.  Remove
those.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 846da6df5b552..4d28eb033fc4a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3732,10 +3732,6 @@ static unsigned long damos_wmark_wait_us(struct damos *scheme)
 
 	/* higher than high watermark or lower than low watermark */
 	if (metric > scheme->wmarks.high || scheme->wmarks.low > metric) {
-		if (scheme->wmarks.activated)
-			pr_debug("deactivate a scheme (%d) for %s wmark\n",
-				 scheme->action,
-				 str_high_low(metric > scheme->wmarks.high));
 		scheme->wmarks.activated = false;
 		return scheme->wmarks.interval;
 	}
@@ -3745,8 +3741,6 @@ static unsigned long damos_wmark_wait_us(struct damos *scheme)
 			!scheme->wmarks.activated)
 		return scheme->wmarks.interval;
 
-	if (!scheme->wmarks.activated)
-		pr_debug("activate a scheme (%d)\n", scheme->action);
 	scheme->wmarks.activated = true;
 	return 0;
 }
@@ -3889,8 +3883,6 @@ static int kdamond_fn(void *data)
 	struct damon_ctx *ctx = data;
 	unsigned long sz_limit = 0;
 
-	pr_debug("kdamond (%d) starts\n", current->pid);
-
 	mutex_lock(&ctx->call_controls_lock);
 	ctx->call_controls_obsolete = false;
 	mutex_unlock(&ctx->call_controls_lock);
@@ -4044,7 +4036,6 @@ static int kdamond_fn(void *data)
 	mutex_unlock(&ctx->walk_control_lock);
 	damos_walk_cancel(ctx);
 
-	pr_debug("kdamond (%d) finishes\n", current->pid);
 	mutex_lock(&ctx->kdamond_lock);
 	ctx->kdamond = NULL;
 	mutex_unlock(&ctx->kdamond_lock);
-- 
2.47.3

