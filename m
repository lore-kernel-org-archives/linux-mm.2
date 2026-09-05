Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF992C624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 12:47:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C1C76B008C; Sat,  5 Sep 2026 08:47:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672186B0092; Sat,  5 Sep 2026 08:47:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 560866B0095; Sat,  5 Sep 2026 08:47:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F9086B008C
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 08:47:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C8BDC0339
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:47:16 +0000 (UTC)
X-FDA: 85179684072.08.6E9785C
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id DCDAD1C0007
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:47:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YJ5hxIUG;
	spf=pass (imf21.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788612434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ziQh4+EYTP4FJ/w1XHqXZYM290fo3MHX7d8c+O4yS34=;
	b=v7tritVpkXz3fF0H8qdt7ZnQxH9VsXZ34KWK60phCEwRD9/iGpcr1XzgoxZXlvhBRgjld5
	q266ezRe66WX28hWgo8VzV/xyLqDoRgaJqC6YbbVSaR1/iMtEPJ60MIrkNJ9Pck9OdMNwz
	gBcQ7r8uqVl1fzqoyxsYjtb+g1O3c5A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788612434;
	b=v687JR2e/OdJuU7ZwGb29LQfGQ+vnEJeBzrqEG5W+53SV/2dIc2wDX1ImZLjpdLZGU3dvt
	Kr2GjCy/1BhpAn8itrIvILEZoKavYyGgHY5YtTjxlbA99P0THcXUswe20n4Q3YTt71WzBG
	c4u24pNUJpdwjVpD6TOzL19B3KVOvaM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YJ5hxIUG;
	spf=pass (imf21.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-398c1101c1bso1910616a91.1
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 05:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788612434; x=1789217234; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ziQh4+EYTP4FJ/w1XHqXZYM290fo3MHX7d8c+O4yS34=;
        b=YJ5hxIUG4e9TnkIzOyEi/8kkjHIo/S/eVm8xwPXuBgkuU9fWHT9RkjSFWhSj7tiO2i
         Yt0QbfvOm9WMyk3ZB7T74FcaPYeaGdmq9K7uiOZTT9Sde5JTgc+RoEa23Y60NKyzaUlc
         +kAroJTnU0zDS3lqRrqZrIrjJIE/OWPvQ8pCBcqRwsK1IGo/IlZJLdH2KL/XNSmKmGMC
         wKZWZm5WUsvyxHkD3tBkeZ64nTvFFl1z1CzeyZMXWBM9wgYf17F/IQE/132xcbjg2XHC
         V0Dxe7uUj9AD00qsmwY9xUfMpwXYafRxhKG42kYh3OCavQmLfQ1rlfY9y02RXLgr+Coq
         G6Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788612434; x=1789217234;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ziQh4+EYTP4FJ/w1XHqXZYM290fo3MHX7d8c+O4yS34=;
        b=Zu1kwgAeLmxG5nSumoLZV3IvQ/Udb6ykbRq7taxVTGH+wia7FYAyxGFDtFLQH+x5yd
         HrZarBrZ0GdtQTD0cBWfGspVr3UYV5xA4LuNn31CjqOJ7Gcjbm8O1+Euy/njnFex44w9
         yue+QrH+pkOJL9/u/iITgfxkEPA3nVtVZ2ihuYmRqDkbiqqgtfsm4bHQV7j0Lh/lVln4
         2XMWfj5kMNz/sZ8cpEXq9JbdEOfFJQ9GyJJHxpOqrLl8EGRyN9q+bjJ7BLckN+XP8fYA
         Dham/8xwvE8QyC8ro8rHZK7wiPMlHg/rolunOAi8SHT78I4TH7gJ9w5EtAivpEbVJuGs
         Z1GQ==
X-Forwarded-Encrypted: i=1; AKwUvBzmQ7vTEw4t+zan7avewnvtlqYm4B3tXwId75MeSTsVD9oRNSBdsGL2nc/mk4m4V1iEf/RDLYsnGQ==@kvack.org
X-Gm-Message-State: AFuF++nNPn4lZ1AgvccFishYDjTbMaTgPq++kZqTm1IcyXpCrIU/l8Cu
	tz3SsYnLuKjq/nUVoAIipWzAWMsug7TDVYkx1ytmiRwh33JQ81snwwtI
X-Gm-Gg: AYBFou3edE/GnH5ftxSOFpLpK/AWZnQBaPHOp8fakrt1wP6UE26jJ8NJnXxEFUXCAi8
	bQmweRDY1GXB/2cWYda/KolLtw+XfJ+Exf9HoCluldLp8dQHE0imCberIkDJv2fc1+wOJ7CesJa
	eHF72QQpedL2LcSj2arZ4h1FyWgzwu9yNSCbjkfzYvgxgIa9O7si65SIcKf6WpEm7OntWTG5pNe
	16bcyU5KNx0sh7n+lnkdT1UwhcKvT1m9PpzfCpAY4hdozhzpay+bST7niO+O17PrQTGVyE5CEOq
	VnGrph7KPR4E6eZNvFUvsZ4iAHmZo+uduYxsg00Biu1V/axmf5EOz93/sUtH2ZtcKEOC/Q/C6RM
	Jp/e45/Kt/ZIhs7tJpsRoUVj90xsQHSAkade3/uOpOkBqtOdaalvpppOdfi/Y275+F2y3r5ki/S
	C6N68cW0IlwjbKxoFwVMs43M3ne+etXuIJcU2DlfIjlpQq8Dn1D5hri0z6Xk4uI59JIg==
X-Received: by 2002:a17:90b:534e:b0:398:ba0e:96f6 with SMTP id 98e67ed59e1d1-39b2624f0f4mr18020789a91.23.1788612433720;
        Sat, 05 Sep 2026 05:47:13 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([115.164.90.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b260cd15asm9929306a91.4.2026.09.05.05.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 05:47:12 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v3] mm/damon/core: allow esz to be set to zero
Date: Sat,  5 Sep 2026 20:44:58 +0800
Message-ID: <20260905124706.3398-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4jkq8mqcq4tagoi8bk6rmkejgmxtk5uy
X-Rspamd-Queue-Id: DCDAD1C0007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788612434-404966
X-HE-Meta: U2FsdGVkX184h2HPkkQO9ZmMHMr+BrA6tmiUX80UrmS90VBS+tvxtlmvwopEfXy8wLRtr1Et/wRPg1breACEOgSdxLkdH5Zlj+l4i2M2NKLuipDuwtlfCoFWgC5fSOiZIsWQjXg1vtV4aKS1A/MUYKauEza+bhCu4mu6IiTk2aoqawCTEe94hF1MW3beRz/DvaRGpOyh9UkE+lYZx5niX3nxDmIMmJRVsBl3HLzXQ7qxDAqoEW8m6h7z0oEZVV9B8u9YvZP32TD5DS5WjfA0C8ef32Ycbi/NLV0sMCiD8eNPmL30vQdYlGSFyislo5IPrdjB0/xjKS5J6oeWQnEmIRzLX7LywL+B4W/qRqmt8o21opj3u56LlssPRUYhZRSKGMfCYXfnQJcLAlbWcOmceMh/Wa10ihAa+xNYgdpUgKikyAiDKKC9jUUoYNjz10vvZcjFWgS0L+ysedxhLckwmd80z42YxNnhjcacPvKa+lbmu7lcwBnwbTamMr+OcCvuntITb1ioN8KI8+/vPxHzU84BPsp5e8TvhCGKBjay5hLxpV7wyzx/dsFBXM+QkD0lEf1U3eEBIkmjsBM8vKgADRHFHZaTfgxRCmF/NHXzXAa+3abywjQ7uWX8fb2qB05j1mErc+Kak569q+ZfakqYy5qt+3aJsPByGXKZj8XI2gnRqBaMUAXimwaulDqBHBFXJLcWm2Wty0I3mkFbvjW2BB0RVJDSw1tMgq8KbsZPygEIUGZKshgy5U49n9Dxif91Xt0UdySFPblCJGPkY952tCNbzbwSWduCp0wU1eUfeMiHUtQ5ia6AS0x2JWTSaE6veHdhYhwyi5Vh6n0VMXzTJrQ4HARIX44nOpJKzkdp3n9KipZr4OZjPHjtQBLSxlzwcsuBPJVeRR4AJq3NxTYXKmnhaKb1rGgP1LKlZDLettZHYRlnMfyUKGIhmY3styWdUdBvt1Cs0XPhVH4JXY2
 AENsSew8
 Yn+6Y6a16xpfy/OecOLJq5xYHcIDKzQgd8Th2kqRtpSEu2gKZ5q7GbK6pWsOQAug75MdMjxTq8AffqTm0vkjGW+he49gvkkbi+DMCGYDLA2ILhLQH6Q8YtA/LlxKPThjKLQ9wiT/x890SkND8xvErwSAfa+MKtGxoTXbbOH7Mb4VBFrrX/sKXWMvjop8OYYTmMu02pq3iwXTuphBBpvZmR63TscQ35QkOYxUwUcDCZHZL6LzdvaUNWxgHJ0oA+mi41DWmMJCalvDB59mPEm8nMI0K/Ves9t0yEchVDf7R60HvGl5C/6mPXO+JKPwNXlyLwhFG5A4GEBPtEDyk7fvxIN9XTEB4aOU5cB+1sYLAPhNRbb0CyDFSJVbLCBoMOvvKY1lL8ywe83f6oNG8CczK5FQOjBZrO0ZnHILVnjG1lhFqsBj8mv2HDzQ2fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the temporal quota goal tuner determines that the goal has been
achieved (score >= 10000), it sets esz_bp to zero so that the esz
becomes zero.  However, damos_set_effective_quota() clamps the esz to
min_region_sz when quota->ms is set.

This is a minor issue, the main problem is that it doesn't match the
description in the documentation, which state that if the goal has
already been [over-]achieved, the quota will be set to zero.

Fix this by set quota (esz) as minimum as possible.

Fixes: 8bbde987c2b8 ("mm/damon/core: disallow time-quota setting zero esz")
Cc: <stable@vger.kernel.org> # v7.1.x
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---

Changes from v2:
- v2: https://lore.kernel.org/damon/20260902082050.19566-1-aethernet65535@gmail.com
- Changed implementation, more general implementation provided by SJ. [1]

[1] https://lore.kernel.org/damon/20260902150301.88535-1-sj@kernel.org

Changes from v1:
- v1: https://lore.kernel.org/damon/20260901105951.106246-1-aethernet65535@gmail.com
- Changed implementation.  The initial solution skipped the
  min_region_sz clamping when esz was already zero.  However, this would
  revert the fix from commit 8bbde987c2b8 and cause a regression.  This
  revision fixes the issue by adding a specific check for a zero esz_bp.
- Changed patch title, original title: fix quota could not be set to
  zero

---
 mm/damon/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 644daf5a1656..2b294fb46648 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3091,6 +3091,7 @@ static void damos_set_effective_quota(struct damon_ctx *ctx, struct damos *s)
 	struct damos_quota *quota = &s->quota;
 	unsigned long throughput;
 	unsigned long esz = ULONG_MAX;
+	unsigned long esz_time;
 
 	if (!quota->ms && list_empty(&quota->goals)) {
 		quota->esz = quota->sz;
@@ -3111,8 +3112,8 @@ static void damos_set_effective_quota(struct damon_ctx *ctx, struct damos *s)
 					1000000, quota->total_charged_ns);
 		else
 			throughput = PAGE_SIZE * 1024;
-		esz = min(throughput * quota->ms, esz);
-		esz = max(ctx->min_region_sz, esz);
+		esz_time = max(throughput * quota->ms, ctx->min_region_sz);
+		esz = min(esz_time, esz);
 	}
 
 	if (quota->sz && quota->sz < esz)
-- 
2.55.0


