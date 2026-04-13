Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A47F9F531C4
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C01F6B00B7; Mon, 13 Apr 2026 14:52:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1975B6B00B9; Mon, 13 Apr 2026 14:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D50A6B00BA; Mon, 13 Apr 2026 14:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F204E6B00B7
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:52:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A7E1213A0C5
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:52:50 +0000 (UTC)
X-FDA: 84654429300.19.AF7C1B6
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id AD880C0012
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:52:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fMoTM8nA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776106368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oEitzkayqqpN7xkxJtZIQKvaOlaMuUzOnVvJxJq+UQo=;
	b=GdhsDGB7MKHDBInXl4XhANLBtdGocv9r1SIPg9YO0c1424nKmBNOJQe54d9MuZLC64EfYs
	VwqBdorKtW8Q5XaBmjuYIDZobMdV5NgINHviwDAVnF8vzIKznzOa7VtSyI4qcdOfOQakGC
	OR/dS5Zjbd6vbzSiAv+0VvTzUqlQZK4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776106368; a=rsa-sha256;
	cv=none;
	b=OoxwhAoZT/EtwH3/juHRIYralvFkEWstzuXxiVVV64mtlUh15pqc5MbrzmscPWp6CIsaMt
	EWQ/PCvT2mB+v+uKeBGsAv0k0oMTWTTdC6rHAnvoNTwRlIAsjA/KEQM6G5PKgpgcq2DUgv
	BbpqZUs7fBgVa0bdQ8zPxEXWTWRW7L0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fMoTM8nA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-35d971fb6f1so3991511a91.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776106367; x=1776711167; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oEitzkayqqpN7xkxJtZIQKvaOlaMuUzOnVvJxJq+UQo=;
        b=fMoTM8nA+3HE5OHCmWRuiL6KS2rVORJXFngoEPi6pH1K2YoeS7TJbAEdthbKrdVL/3
         xTvfdbTOyDEymK4HHbedKWf0aeqKlojBrjCpY/y6qI+yLy2QydcgWKY91SJnkiaXvAB/
         PkUNl0Sa5pnukN810/i7CP2N3+PJgLGVRmWTMPc1WA32RVBvOfBekgN6EuHF45nZSzWD
         FZSQ9ONrNZiB8Px7w3JVExxDtFThy22t8ipgKsAHdj8e8l6QS6zmEv9MIQIbJm4f3vL6
         zEesCJ3OCw1p27LUmtsvUvddcZlS1z1AIBQloFPsCa/b0F5xb8sv9LY+N2xSkgHardV+
         ZshQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776106367; x=1776711167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oEitzkayqqpN7xkxJtZIQKvaOlaMuUzOnVvJxJq+UQo=;
        b=sN+2F/OmvihZpj4DjKf1Rfx9fgrqfdPm29h6V+yR+H6JiEcKCUZxQSpILsCWDRdgC2
         v/lypS8BRnv+iJVx0Wq2vkBfV0ToKVuGgDA+x0nQ6+e8x4TKaDIKF21o9x1yp7uGHn0w
         NYTOy/HPr9HYc0lalE+kxgz32lCGeUzV0erFFwG4PJ2PvzVlRuUwvKz1CKFfvaTWZg8m
         ygd6hncaRza8PH/BbaLHeXRl4JiLMwhtrJofPBfeAHYG3VpZwXhthmlQmoI4L5jscrmM
         JkGzsAEn6pYKy2n8Cp82isPS6lfwbrziEDIN45U1aj/3TsYWmSwSMnOxh4+l6iGd6QIv
         wW+A==
X-Forwarded-Encrypted: i=1; AFNElJ8SKOE8w2zgfTNFczbl5RxIyc2m/f2NHP5YPJJ/o3mZW/ovmAWPFjkY+U2cVs5F0GhskNpEehSNkg==@kvack.org
X-Gm-Message-State: AOJu0YwUM5oT7Tzc8sf1Dh1/X/9ubvT1l9AuxPwDFNghJ2AQj2/v2YC8
	BtJda3kSu3YQJb1BdxW0o0h10+RJeFhYvcLOp6hWYbjI/S+Opdh1TJh8
X-Gm-Gg: AeBDiet8U6PH8nfWfe803xL7ep8OFgteb2ETckMWUfjmHPDZ6agF5WwMgqjy7KrXuQT
	1LjVh+KD7zUF4WLeSTUfyadoFQm+qtFQWHGJVvKBSlqPfOxUbJRtu4cYBWS+MnsQ6p4GC+RVt0C
	MtvoektigLdfHi1K2wnAs9BvHGiwbsDf0IKNGeM9gBLncFG8n6KLRCYShPI6RZWSMlHNU6ToaaS
	Gf5WL8MdnsO0sDGrChPYrC/ECXlXveo0I/F4TsZI+LJEhTPTuzhP2v8Yua4hioDF6VRJubF8xYk
	9p0gaUz5MdBg29J9k87Jn84Gtjr3S8Ld0zvrzYJhNMKVqS8lM1C3at/hHGF6Bhqbz/lJPIzPORr
	t5k0KB4/K2lBaDQ9BjDQdspteezAWias8VyRG1MmN4yO3aOWglDQv9eV/BZlnaj4LNk7KmoQE9l
	75USi3U1Y6pw+WE7b4kXKJcsczGFcYfpARsYXxsnDBLn/ScsFN2tfkVA5yzM5AQw==
X-Received: by 2002:a17:90b:3d48:b0:35d:93ff:284f with SMTP id 98e67ed59e1d1-35e4282bdabmr14803992a91.15.1776106367321;
        Mon, 13 Apr 2026 11:52:47 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35fc2adae0dsm1225435a91.3.2026.04.13.11.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 11:52:47 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH v2 1/2] mm/damon/lru_sort: reset thread status parameters upon kdamond termination
Date: Tue, 14 Apr 2026 02:52:48 +0800
Message-ID: <20260413185249.5921-2-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413185249.5921-1-aethernet65535@gmail.com>
References: <20260413185249.5921-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AD880C0012
X-Stat-Signature: 799dap6fgrc1mwksygu8wdk1xzbtj3na
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776106368-964650
X-HE-Meta: U2FsdGVkX1/H03BhSONwU5SsiZ1IQATb4Njby2khV/o2MPq4SvgNNGDYjkUyRe/qbEz3c9mVnuv6sIEsWffMpJ+qWDQKjetBBqsgrKbX4//UtgtuSVei9V/jPA8jgstl5lWMU1nB4p3r1Vf/X5MqgZ1R40vyWI48T2MPB4EwInzvt9uUSbbJachI2jNGeB3ljpgTiBumhubr6csIxpztqLID8rsJz9mCafqIMpV7+wMaXpY9GmwlSHOG/clP5xxo75fdDcNh58MovBXWKFhehKrsti4z2hHji36o3d29WOJqgYm2qHDpROTAAPgaQu9aXgSE4oCN2SuJFsZVxuyF6Xb+aPUhGRbZd4YpPNK0GndG/9v5XGr5Wz2siTc//irQTC6K9aaywjD7FSPf17VG7VGGa0BJJdKDlELBv0bhKVCvymKsNMHb67hZUfdf7WySblE/HHKIP2MO/LqcNrHc8vN5r72GHNT23UNF/lT3vhiO+JYq3Gyq5iOaFfV2kbhMiHuuEHIvi59ZtWe5ku89ViH5zvTH07zHbJ2jgelf3b65vrtB0v+xPdZ0JlwEs9wVbXK3Q0WUVeGVmCei4LVQSU+5EcYPmPjmOu5X/6xjiHcjaY7czncDD4OxXFkPTJ1V1B0UErC9Sgts8bYAwOnZCQ28LmUgjHwgz6oiCPLEOdSc+jIQi4UEYPpQvZTJd7QBq6AGYTz1bq5B4YT0UuhEqLxwgalJE9bNniJrgNfQhRLsAbLgNgLtWI0tTBs9eOgGLU7Fr0ARgU4d4/bqeB3Q70ojH5UTsV/b4Fw4GD/rtZb17UpVc5x/BV9FmCYrCsAO+iO3yi0sSSji+YP0K9VU4iCPT0m2TS/+TNeux8ZjX43EnBjtvqq6j7UC+4kuDKKTfPFpsQEPBa2DAlRXHmwVkeUyIy6LHtLWKxErgTdNCMtBy1z11P/+1R3LKunssHqsThCnhueT+pLW729Qldr
 ESamTs2U
 7EzaOhJeKlQcVRQV9n/eLAuxctqvs8Yq5gFtmHjn1tvRGn/GnpfyRPXNmCQ+x63JAyawKttuRTpfPu13p1cKG2xSWR2lkerV8J7p6IuzA883FfEoUwVAAyo7nuVQrh15ZnusXuq0mxxNWL9qyp2onzQynZ7YQqoVihQkyGb8KsqFRlJ5UBgctq+1FJyErdz5P8FEgVJMFp5OSu7fzftcng90y3vP4CvM4JFsIjG+NzjOxwC4yImX2Lmi7sv3dVT/egbNE7D17w6IQnJzg7vhtyJCxSM3DT9fuKzLjGuMcllcKfLTKoaH9VCM6GJQHAw61CvXPjxL2HYTu06iGiltFTaw0isTRKr3Ny3arqsvtBgw340jYaEOEYqlufAfRoEvsq8AOmuv3Uz4OreXPvmy4cqzU/gpTnMXvCE2mypIZSx2cBmsuEnQTJfEoswS/QBn2uaBP+5S6ygtRoCmupPckx6jlWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem
========
When kdamond terminates unexpectedly, 'enabled' remains 'Y' and
'kdamond_pid' remains stale. This prevents user from restarting DAMON
because both writing 'Y' and 'N' to 'enabled' will fail.

"Unexpected termination" here means the kdamond exits without any user
request (e.g., not by writing 'N' to 'enabled').

User Impact
===========
Once kdamond terminates this way, it cannot be restarted via sysfs
because:

1. DAMON_LRU_SORT is built into the kernel, so it cannot be unloaded and
   reloaded at runtime.
2. Writing 'N' to 'enabled' fails because kdamond no longer exists;
   Writing 'Y' does nothing, as 'enabled' is already Y.

As a result, the only way to restore DAMON functionality is a full
system reboot.

Solution
========
damon_commit_ctx() sets 'maybe_corrupted=true' at the beginning and only
sets it to false upon successful completion. When 'maybe_corrupted'
remains true, kdamond will terminate eventually.

Therefore:
1. In damon_lru_sort_turn(): Add fallback logic to reset
   parameters when damon_stop() fails but kdamond is not running.
2. In damon_lru_sort_apply_parameters(): Reset parameters
   when damon_commit_ctx() fails, as kdamond will terminate due to
   maybe_corrupted mechanism.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 mm/damon/lru_sort.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 554559d72976..96c8d0dfcafd 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -344,6 +344,10 @@ static int damon_lru_sort_apply_parameters(void)
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
+	if (err) {
+		enabled = false;
+		kdamond_pid = -1;
+	}
 out:
 	damon_destroy_ctx(param_ctx);
 	return err;
@@ -388,8 +392,13 @@ static int damon_lru_sort_turn(bool on)
 
 	if (!on) {
 		err = damon_stop(&ctx, 1);
-		if (!err)
-			kdamond_pid = -1;
+		if (err) {
+			if (!damon_is_running(ctx))
+				err = 0;
+			else
+				return err;
+		}
+		kdamond_pid = -1;
 		return err;
 	}
 
-- 
2.53.0


