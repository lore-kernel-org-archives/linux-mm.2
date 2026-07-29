Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F04A5C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26C4D6B00BD; Wed, 29 Jul 2026 10:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 263466B00C0; Wed, 29 Jul 2026 10:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDEF26B00BE; Wed, 29 Jul 2026 10:03:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF6876B00BC
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:03:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 641E3806F1
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:06 +0000 (UTC)
X-FDA: 85041980772.30.6AE5CC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B4775100019
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YqCPUgWZ;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785333784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rsKOoYzf/dRz4aZ57YQorCEYYMXi515YQmVG5cvaY7Y=;
	b=L2SiE8cq1BJjYfoWbpXBVnJuk/vf2voCoGu8s6enakrUV/1DXg4mmWyeCU88x2cmdaR+YQ
	wHa1Fllc1b9+gxtS9M1ZYCy540ziVDRbnMINyZQlhBUtYBL2gQ/+oIlB1P3QgTMwscxDG2
	5zK8+Noo0Vs5t8rA357X6Du4bG3N3ac=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785333784;
	b=5UdrgwzNiTFfMuIabTYyoYhonmJRh6r49+T/DdcRDPD6hrW6d+Df1bNuaFON0KIRWCV2tn
	aIjChELQbCf0JXUQVA/BrkGUiQoxeTtbNqsmDTddHHs6pICMyD7u7Sd9AHFygX7hcfTJBS
	J2/wgOik6XFEtv8E1R6eIAC8hyFNTQg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YqCPUgWZ;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0694141993;
	Wed, 29 Jul 2026 14:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63DB1F00A3D;
	Wed, 29 Jul 2026 14:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785333783;
	bh=rsKOoYzf/dRz4aZ57YQorCEYYMXi515YQmVG5cvaY7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YqCPUgWZocGbcqlu//Eplon8O/n2ikX4zR58EXJgrot0DTLzs7hq7kWXfM/bvYSJm
	 SmAK2MPrgAP3HiIKlhCjIubS668OmphMod+BvoQl514xZ9Xpr117ULzJz6DxU/9EB9
	 lp5YwoN0zjW+UzxSPeb8ht2GJN3iucQoi5InyzrHyJF9aKPeLDf+64vRDR2yKMk/Jz
	 z8g4mH1Sx9XiBoeIIzHh/YoIqcV29f/2dYU/ijcXxLwu77MnTr6l6DHFJktSezoaWF
	 BPN1LtrZR9PGjbhAAA1q9G8GVqRbEibCutBp+/GNpiEyofcKyRp0bwwm9JQ95CJXRP
	 t5Y3hg2XMhiag==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 02/12] mm/damon/core: remove debug messages
Date: Wed, 29 Jul 2026 07:02:42 -0700
Message-ID: <20260729140253.87753-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729140253.87753-1-sj@kernel.org>
References: <20260729140253.87753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B4775100019
X-Stat-Signature: huqnu58o4t9pxcfms4pxrnu73zkqgnwr
X-HE-Tag: 1785333784-336131
X-HE-Meta: U2FsdGVkX18FyCuDUc6Ps0zNp2YJuK6giImvRxulgfR29TfNlmqk1JpzUKjhq32AiZjb1dLh4KfGf3iO/CB4luG1JZ4Dv0PNVPZqFgmhr+VFqj9d3pghSMp+1gYIX0RBWh6zokIU2PVHQDiGX7EomvpGZ3F0/NhqZQAMFMXs0BTDit2byEj+maNK58SFMp0l+Y1BIzcbAE1T++3JzqhSqM/JtEVXHdUbDi//0kQt0A7Q6SIlXzTF23G2MF0F0Q8nrQK7K8LdfQpjtzXauHkoPce3PYWVz+WEkXc9Bn4eIaRVrZaROxShiBc4lyTJKijrxPBYA76BhxgX5AIkfX4HRT3ovIzsgRm82T/XxxPp4HPfWFyEdEFsdkm6Vp65fy/al0kzcHdUk2T1KwTx5jlYLusmKFNCJinmzDCLJDn83AgUdIyBs23j6KGXwu/TD94TNuBweXxTVXA93MJDljOScfwbHu0m9sHRJ9XaT0O/qvfnkLurQH4AxLVPx3aj6Qvp5UqfJYyNvKvATF8iCsB8zfRpBD8u0CAK6KUHu/5Q7fzJqm+bH9TyDE0a5efkik5IPC8XuhYRIh6YEz7tArxJW1M0dogtMcKlgw18KWA5nfDJGM0XhJOmaUIM9Zmax9qh4O4RzVSfTHbVd5pFqzgvOIoFb7DiXFMHwqQD6SIzg2dnEJM/UHx+2ctgCCQR0VmzixfI27AusVm47xfcb3RzmGAv/bibR7sS0gk8fxVYTucfO/iL9ZofLaVp0z1C38SrokfylkxyBRzusiozOBUiQETK95GXtuh5/WWgt0LZBOImWBu8s1nXFSCgNjV3SIbF2cyIdOoYoNXwSBfj2vUxfQzr4DPeBkX1oGRHSxqYzBVBgNYTIMwXQwkS8TfTJs/zA9t1sMGeYlAJymr8cphRPxYtESEQtV4JnrTvKdwmViLOZpLNKA0taNXeNUzaV2l8FBk2K7zZk04MOZfSFBi
 /chypeOB
 jB8U6YkaHXKHVJsda39zKDZSglns6sNSFUmW9c5SxQfFh0j8Nmhn6UUKzkgTyy+0A1TepwFQUASG/kbRS1O/vM51IY2AoES6S/kMTtMelKEoytlPxLbhRVcqKl0VFZt59UBynG0ixvsS8yK2JIjzFmMkZVEu++SqGJRH/JWR+aSR8pAYTtGpvvYeE9Y5fDOehDZoY7m9iK7JtyGhyxUOqqjwvooyofscvBqf0fLQAL8pkOZQ=
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
index 4169268d94416..1b0f12d17de3a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3693,10 +3693,6 @@ static unsigned long damos_wmark_wait_us(struct damos *scheme)
 
 	/* higher than high watermark or lower than low watermark */
 	if (metric > scheme->wmarks.high || scheme->wmarks.low > metric) {
-		if (scheme->wmarks.activated)
-			pr_debug("deactivate a scheme (%d) for %s wmark\n",
-				 scheme->action,
-				 str_high_low(metric > scheme->wmarks.high));
 		scheme->wmarks.activated = false;
 		return scheme->wmarks.interval;
 	}
@@ -3706,8 +3702,6 @@ static unsigned long damos_wmark_wait_us(struct damos *scheme)
 			!scheme->wmarks.activated)
 		return scheme->wmarks.interval;
 
-	if (!scheme->wmarks.activated)
-		pr_debug("activate a scheme (%d)\n", scheme->action);
 	scheme->wmarks.activated = true;
 	return 0;
 }
@@ -3850,8 +3844,6 @@ static int kdamond_fn(void *data)
 	struct damon_ctx *ctx = data;
 	unsigned long sz_limit = 0;
 
-	pr_debug("kdamond (%d) starts\n", current->pid);
-
 	mutex_lock(&ctx->call_controls_lock);
 	ctx->call_controls_obsolete = false;
 	mutex_unlock(&ctx->call_controls_lock);
@@ -4005,7 +3997,6 @@ static int kdamond_fn(void *data)
 	mutex_unlock(&ctx->walk_control_lock);
 	damos_walk_cancel(ctx);
 
-	pr_debug("kdamond (%d) finishes\n", current->pid);
 	mutex_lock(&ctx->kdamond_lock);
 	ctx->kdamond = NULL;
 	mutex_unlock(&ctx->kdamond_lock);
-- 
2.47.3

