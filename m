Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DA4B10BA426
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C79396B0098; Fri, 27 Mar 2026 02:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C29CE6B00AE; Fri, 27 Mar 2026 02:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67BB6B00AF; Fri, 27 Mar 2026 02:26:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A89336B0098
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:26:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 503BD140FE6
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:26:37 +0000 (UTC)
X-FDA: 84590859234.04.8806736
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id 87CD81C0006
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:26:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="l46PY/4M";
	spf=pass (imf18.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774592795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UfeL5siJ6xe6Uo5hQEXOS6s+/4tbof4Lxqs1l9wyAMQ=;
	b=b+i7OsLAbj1d0nKofY86N0vkRzihFN8EkOdgGdBx1H/ozvXHJv3I6LegZn7r7fed++tERV
	KOgL3MiGP1EBUf4vwRtLS+1DVeb+6+jKfCmq7MncIcq/66uk2aj5YIi7Tewmitz0ajnvYq
	BKnttVu3/sQfgzr0L3E3wPn55AUc51U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="l46PY/4M";
	spf=pass (imf18.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774592795; a=rsa-sha256;
	cv=none;
	b=wnSkSXVdILO3GgbG+/T9plisdU6Dp3bf8+GA0oZcoyE5qro0PmSdao/0BMjsDNHd7HPz3v
	L5pX1SYEz1HEY1PECE0yONMgPtIrif0pfPkHKW8SOsxpZTsgUKEQ0ekmSJkj8+NbzDauKl
	tnKeodK10T4LAefPwA7gAUBwz85sYq8=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-354bc7c2c46so1104015a91.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774592794; x=1775197594; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UfeL5siJ6xe6Uo5hQEXOS6s+/4tbof4Lxqs1l9wyAMQ=;
        b=l46PY/4MyGHQv9UmyWiBxtSzobpYVwhScpfbeiF0S2uMSnt2WyWF9eNb51kLr3yPGd
         KpAH7oksSssN8O9eUs+EFIVB0gqhnDmoJ1IhmJyq79FpaSauhMCjr0SsRXtqJ+++UrHq
         71dUnEKG8kX2PoKkuXCBZFm6gZEH3rYsT3k80MY6VrhNQUf91NIt15R2Mky1MkTd3hB+
         f1t2R7QvJ3AWKZU866ZOd7jNX0PAMQOIlCwSKhgF82FblMzLwnnuA/Nixt/JvZyCCAKH
         yUeNF3LQN/BiyLgHYQGR10NXRON6BjhJfnxQYlbZLrCG8wB/aEzdY7uIlTIs0Kgu/flh
         InBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774592794; x=1775197594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UfeL5siJ6xe6Uo5hQEXOS6s+/4tbof4Lxqs1l9wyAMQ=;
        b=g+nU4aMlrzvcge6/rpuBFP1BGMOWdvTR4csSgYJuuWrFW3q6l3wvuM//ADlwO+x3KH
         +sJk0mJrOMxpW2XC3lJWwkI7oxUbbUnCkycruTpv08UfqxZbxVnoInsKItSG1jA0085I
         00+WNz3nY9ac1+QUBESnE6ZJWQGT+fx41p1cX5xnaiJZz9TYGqjBxBR2OQhkHpO0GuWZ
         ndtzRitrcF7b0G9KaaWoFX2IlHIk8dX4x6kN5JPATcj0GeQiV4SDvqizzLeR9VnVcn0E
         kvuO/azm5hxKVYy42oR4SWtuK5B/ZKIQumdnIV+N/HgYesf+nkH7hPYRkPHQqN5y3X7m
         6P7g==
X-Forwarded-Encrypted: i=1; AJvYcCUL436v2SS9TFYtRLGCoCFNBBqKprXitaFb0g9bAt7lrjqrsY5bUtrlW/D6cV9+0gLnwerGN4XGhg==@kvack.org
X-Gm-Message-State: AOJu0YycMPvBJIRAkyBPCZqGISwKQmp4bmwsxqVxviFV2ta0c1IztXqu
	R/hg1FCLHFh4zHK+KqLpslNwpopZ9CExa1rSDZp1mN/gzXInQeWpRwaX
X-Gm-Gg: ATEYQzyPIyPyNeg+8x67G0WdUVwo2uqETIQ6OYYeEGqi+2tTD1GS1blyBFNBeJ0ggeK
	e05krBA3TUyDs7PfoEU4fQCM8AOszYljCeo8YtPgVinLlyOzdqSVbjbn9A5q1IgnyZWPUhhPial
	EQLENQruoId1XwaRD2aeNEryMM+7d9W/j6gTdBwqwg2AN1IIgHZk78yiP26rJnvC6RwLYt99MCg
	gXHDlMZoM2zxM7d8ESrYXdKwGELQdXmPTKjFO0zsZpXTFGO7DxfhbPedx32DCW3KmlPzsDIprUZ
	wY3ZxWZGQUAVpEJLFLhjhvZX8ylSeD5wugy7OvxamUDKuhKW8Z7ZnJ1eW2zIcjRyKpwVqeJHuVP
	Vlo9aJdLgMrJAjc/xdgTeqa4SK40PJ+1jXSmGW777AcfrcThD+zcTwUEwq2+8T6J+4xVYk2OQwq
	2XqhjvhH3Cl6E6b7eznD48Vyy3eImUqSb21rGg5w==
X-Received: by 2002:a17:90b:3ec5:b0:359:9016:1e72 with SMTP id 98e67ed59e1d1-35c30076ea8mr1429306a91.19.1774592794262;
        Thu, 26 Mar 2026 23:26:34 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c22a4ee7esm3533241a91.1.2026.03.26.23.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 23:26:33 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Fri, 27 Mar 2026 14:26:27 +0800
Message-ID: <20260327062627.66426-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 87CD81C0006
X-Stat-Signature: d5mjtb1g7eijhi1w39i8u6guopixnk74
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774592795-833932
X-HE-Meta: U2FsdGVkX1+FtrRpVC35PsIPY16UfJeEk5Dr9ST2RRTy8iqic1VIVc5/zDO6CimW1A4uy4jiw8yE3kEIyr8mgc0dqYRhyDYkBZWi6syy6hGH6VQ1IVwMyBfllDh2rA0cAMQKeFuaXUyF/5RN6c24sLKQp4XYZiRXaMa55f79vv6Nj0H/M5VZKpssLWHHsi+8Hc4zNfiuivT9yOu0aG4HkD4Aj7aTbOB98VTcMQ1GVbRNplAbmogZWFRZ/YU9dtysaxX9O2p0pudxWBdM2Srs9WrjmRb5oVv0WR6NQstKHSVITPipGf3iaEKmSybTxdpgDqpNX1o48aWLV7/3GQhrK+ifrPa+84awMLnOT1w7IDJkv3yuqNRv4Zm5qcB3hhKsuicIrVmEH/7I4mT988Dja57RCGtwPWQPEXs5YEQym6/26zMhONnt5tJd8r1E1cJ7x8vPqUjzMWZt1rEZn2TLVSJXxoQs/pB5nD3t96yCBKIhMwkGXF00+3B/SPs5uDU9SCdFrPkCmkkJoUwTsCZhcsGUo2yg6GXgsigEIVK1rSnQtyDG8ACzV32iclczcNQEqXwUmgLqYvpStfE0shaZc39anlkjEAgkCUtvz86quq0g56IZcctxbyswm4D39PM8meIc+xpgEcxkwTP8VL+49ei46t+cqe8ohrl3NfacBPpMwc9QW2QZCJL5kL7kxCTms/yrz01DgIWHnCC+7A06xz7s0dx/dh64Vx8N1R4Q8AHbJyNV0XdfY6f08z7250uc34Y/eEEgpbJ0IzAIv0kb8qbdG7ijyrf2j4QwN9y5VpbfU/MBlsOWwaQBjnZy6oXYx4CGOn5L/YN7v1xS9fzpD/UH1RrBZleWCItb93lO6OjyYHfc5+LxDnHMbQr7AC7EZfpSamWDAIdXFzgzkFqx2PEqXXHYU5fuub+UzvKiN1bHyyzej/QsDn/XQigJHy6BV9ynKPFHZU0Zryd5xbt
 LevE4qJv
 wP1QrDN/Cb4XuqLx2JAmLxb/7N4D04CWHgnFSCN5LuKrWGsiAMo+bR62vVXij2A426h7JwGkiyq8BhHV0zdXuAATdLHPwMS7+WQe1LzfmJ9gkL7UMuBphgN1qK5VaGW4zbF/ZKqVyR2PX/RzO2c19ZXiBahV3TY7L5tL1mzBHadza6d2EPxkBxUsbq5k5+1ZtMuGCAtwyVeSqx508Pq3w/NPNX3Fwp+ZrQMNYCUDkETm0aO2hB/lqL7WhNIFju+Kk8UiEZWRI0Fw+/JlRx0nwKgfv9jvfH85/9+JAIyPlawjf8ZqJIzeZt0RwnRIOTULhw+7TinGjAmGbMbm3nlH7x7+tCp0p3S/KZqPJeKRzysfqDetZjAL9u2LXWF5lcD1rS5zF/5Th7gwM202Mm4aksy3RoOtwg3Pu+rDuOJiA3iCmCZ8ZdAbbtNZkfaMUrHxzJPTINwEyaFh2so03sMWkGF9V/g9Lnp/eP5ekSPQMGf+lk74=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem
=======
The 'addr_unit' must be a power of 2 for correct address alignment
calculations. Previously, writing a non-power-of-2 value
(e.g., addr_unit=3) would be accepted by the sysfs store callback, but
cause kdamond to exit unexpectedly during parameter application, failing
silently without returning an error to userspace.

Solution
========
Add an is_power_of_2() check in damon_commit_ctx() to reject invalid
inputs immediately with -EINVAL. 

When damon_commit_ctx() fails, the kdamond thread terminates as
designed.

The issue is found by sashiko [1].

[1] https://lore.kernel.org/20260325025317.86571-1-sj@kernel.org

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 mm/damon/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index db6c67e52d2b..6bad85a47a79 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1330,6 +1330,8 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 	dst->maybe_corrupted = true;
 	if (!is_power_of_2(src->min_region_sz))
 		return -EINVAL;
+	if (!src->addr_unit || !is_power_of_2(src->addr_unit))
+		return -EINVAL;
 
 	err = damon_commit_schemes(dst, src);
 	if (err)
-- 
2.53.0


