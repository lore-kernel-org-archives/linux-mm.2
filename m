Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEF34C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:03:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B2B76B009E; Sat, 25 Jul 2026 17:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18B136B009F; Sat, 25 Jul 2026 17:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A0E26B00A1; Sat, 25 Jul 2026 17:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D324E6B009E
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:02:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 433B316037B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:41 +0000 (UTC)
X-FDA: 85028522922.18.B20E8A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id A6EFD160004
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Qz/g3ZxX";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5v3u710N58c3BJ9vFyK6txOeRAXwyATfa8JLFV4jnT8=;
	b=zpxqE/wSpnvf+6Ky+WSF09v2LTx63xMKUz2nV1tQlGmRCJpke/cMRbr4w+k/xRGMCw73b7
	1xhyawM1nSHXa5FnCD1McBSDn7Tn5Y9X+i5ZfCVKUmQN8zNUOJHD+fWiNGVHWZ7k1y+D1y
	Vk3La0YrL+qmc2YsmuKkntwa2X0VP7Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Qz/g3ZxX";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013359;
	b=AnAmIRSXtdZiAIMaJJKyisXaSPqCWsgK/HXZgiyQfFHUBf/Hd9SXHMhGpAYqBJrsjKcLEd
	v+zVsTMTI/nXQS3deYSlU51h9+auKPRw1/liSfg37xkmyWBYZmKFuYTWE9JwMQkn3NGlNs
	tNiIn4e4H2TXYz55vZh9wc1S4FU9Eo8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AE0160A97;
	Sat, 25 Jul 2026 21:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D301F00AC4;
	Sat, 25 Jul 2026 21:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013359;
	bh=5v3u710N58c3BJ9vFyK6txOeRAXwyATfa8JLFV4jnT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qz/g3ZxXZrDOSZEFWvkzLaEOGPtwpojxJbqoJ73uGD914LJGYs8uegJ8d8rWgy0bC
	 Sk0x2IerEWScVOg0Sr1xIRSCa9wCMc2O6jAA/Aibf5nQvF95ofcFwVDbeyhuhdRkeR
	 cQrdPU5f2bnNBpk+Oe1j6Buh2a1Rw6n9U/olXni0X7dSmcZZeGf8Ah7sNiJrrUCjkH
	 +BSVqFRIMNrCn31eHKJBnujLp2IkjaH0mwTGLaasHSnT9bkmUcSuxbn38+h7Jy4nr/
	 OJtBH3NKgjOoLfySBthJ6SemEUm+H+tUjrzzky7jhwIHFuvsbgkTx648B/nK0e+vHx
	 k2YfzOvKEt1IA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 13/17] mm/damon/sysfs: pass preps to DAMON core
Date: Sat, 25 Jul 2026 14:02:17 -0700
Message-ID: <20260725210225.129944-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260725210225.129944-1-sj@kernel.org>
References: <20260725210225.129944-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A6EFD160004
X-Rspam-User: 
X-Stat-Signature: qidwggdf54a6uhw76sgd7jug9yjjub5m
X-HE-Tag: 1785013359-875571
X-HE-Meta: U2FsdGVkX1+XYZpywx48NmV5oZXeN9OhUQxwD/QAtowVGFsGHcyPKH84J4sFoiH2y0hc3zfZd5KyC3Ao3+mR9mkdWzkKwMQ4N2DFlFz6FWpestKFMU2JcmE4d/97Gs8SflGxzpiTmJYTOKa2Fz/ltIkRHOe6kaBDtjg5D9N8/aLk6t61GZklrP0JuK6iScjK0cEKdhAd1CYRfzQWqKhcP0oRRbbW3ucx5KSAD9mUBVDWRfZR+Jv2OGMcSxjG7Uwv2rE8nI4pUzKRXkHKcndSFmc4N54t3oi1L421E7rGtpNK5kuKGzReq8yz1c78esl4WXd23mpH2JwBpPGNyKdjbSLZP/C1B3Ku847vVnpTzkaqE0MxU3qOz/vbjhp5qkJwsy5vNTUFPf+FxjQHd0lyed7vsHBRH3PvkxWIwJOgwfvyLD9xxEKXh1ZMjPexGhqYCHnEa8qNuyp0CjbQ1OflDdIh8QKVdI+v/dAoyWoJp/CUgOCN8PapUqQTWSDTPH9cKj4r4VZUIU/d9e1M++jTBvxPkkq6Z1R9sD4y7UXWpw1qCE/ZVcJQ5q4ltOZbrjcJ9Tiq9DYE+1E/n631T0Q6pBxZ7zRo3M+uRgnGpqoUeLDKOvb9K2jSS+7w8fww6H06ifj+uRv+2CB/43BYPbFpf7D3hPBIO/5erLZTrlTIYIhOx9acz3C3kZQ/g12kca0xNUMNqR2cRyenHuVOpx4Z7NURjGoKsDbJ7SoGfz2dJbYWilHBdbKY/QTcEOaaVBJqFGGqUcdC0fKGuZxiz2fCBK2LkrPbyEluFn0If0Ym/mGPhE+3vovc8dCEFv96XyGWKykMlXjtIhBrfBmuxG4E6lPz8v9okF6uKjTdiG7xL+HhFGY3CAnzVrZDCu1JznESLe9+79vfT7B+U3kEXv+CaCsrr58Je1rvQ/QvZLP0yYdXrBfEJ8F85NFgcHNbRIUknXxW2gnklQ2xj5SeHLn
 n6KfgkNh
 euX0Iw/wuCzJpLYd+tJgGa6BJ+9llTsMpemkuAdf2gpUoJmTKs+AAXekRlQmG/pz9Is7iA4DRRykHHN3/fejLbtcUtWvZvBwhLZMAR3VK3uwxWWOB1e4MXMNR7ehXdirG+eYIFI1s+s4XfdiQ9MEgSlwdaObRbeITCdAH9mAwQrON/K1wR9kmaHCwdYJdEtc9iJRjAKglmfs1s5Z0stYiM3y8pJA02fuw0Ugu4Ks3RTy87/4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface provides the files for setting DAMON probe preps.
But the underlying code is not really passing the user-set values to
DAMON core.  Pass those.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index f275a6f73eee1..d7a2b62322841 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2174,6 +2174,23 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
 	return damon_set_attrs(ctx, &attrs);
 }
 
+static int damon_sysfs_set_preps(struct damon_probe *probe,
+		struct damon_sysfs_preps *sys_preps)
+{
+	int i;
+
+	for (i = 0; i < sys_preps->nr; i++) {
+		struct damon_sysfs_prep *sys_prep = sys_preps->preps_arr[i];
+		struct damon_prep *prep;
+
+		prep = damon_new_prep(sys_prep->action);
+		if (!prep)
+			return -ENOMEM;
+		damon_add_prep(probe, prep);
+	}
+	return 0;
+}
+
 static int damon_sysfs_set_filters(struct damon_probe *probe,
 		struct damon_sysfs_filters *sys_filters)
 {
@@ -2209,7 +2226,15 @@ static int damon_sysfs_set_probe(struct damon_probe *probe,
 		struct damon_sysfs_probe *sys_probe)
 {
 	struct damon_sysfs_filters *sys_filters;
+	struct damon_sysfs_preps *sys_preps;
+	int err;
 
+	sys_preps = sys_probe->preps;
+	if (sys_preps) {
+		err = damon_sysfs_set_preps(probe, sys_preps);
+		if (err)
+			return err;
+	}
 	sys_filters = sys_probe->filters;
 	if (!sys_filters)
 		return 0;
-- 
2.47.3

