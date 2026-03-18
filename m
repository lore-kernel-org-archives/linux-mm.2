Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B17A5107761F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 21:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8C456B0342; Wed, 18 Mar 2026 17:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3D586B0344; Wed, 18 Mar 2026 17:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2BA76B0345; Wed, 18 Mar 2026 17:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BDD316B0342
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:56:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F6911A014E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:56:34 +0000 (UTC)
X-FDA: 84560543508.13.EC33BA0
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf10.hostedemail.com (Postfix) with ESMTP id 884F9C000C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:56:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gC9lhxSH;
	spf=pass (imf10.hostedemail.com: domain of 3jh-7aQgKCA8qx2vyxp3v33v0t.r310x29C-11zAprz.36v@flex--bingjiao.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3jh-7aQgKCA8qx2vyxp3v33v0t.r310x29C-11zAprz.36v@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773870992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ctmE5aFMWKkncy3sWCLL07LF9OqWa0rsovqCMz1tZkA=;
	b=6J6sg4MHfxxpu5KnU5OISfiOpp6+kDSbJIlNMoqORzQ79bPKyqQ33sn555eJ6eTMSkyzGs
	5Xz8GM6yGmfNasq+9GthNjJD2oKZixgRnkbGB6nWI8Oa26BmFyPqVkJjuYGhRXhEQSDRV6
	16Qe4LSVqTzRW5rS07sZUzIIvvoHiMI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gC9lhxSH;
	spf=pass (imf10.hostedemail.com: domain of 3jh-7aQgKCA8qx2vyxp3v33v0t.r310x29C-11zAprz.36v@flex--bingjiao.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3jh-7aQgKCA8qx2vyxp3v33v0t.r310x29C-11zAprz.36v@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773870992; a=rsa-sha256;
	cv=none;
	b=38OqLUOGlU9jBtZrwkIH0g9kzugY584ioE97Fa5G+jopRJwDGQ0OOiQn91NLLn5cQhmpf9
	tbZsYoyaKjSJqU2+hJ3Jv+72VMA8ViGgbJzzinCI2x3luX3xbcjCb1w2ff18WamAt07nYv
	4Hv1yd1i/s3noD8qF8WbXxO5Zklkpuc=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2c0f6593ef5so160829eec.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773870991; x=1774475791; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ctmE5aFMWKkncy3sWCLL07LF9OqWa0rsovqCMz1tZkA=;
        b=gC9lhxSH6IkFMudokeldpYyEyjHGk3TAWCz2AfkRjSqXJbNtyf7uhqQYu8VkMKW90U
         Qgt5IyhEN17PeByQ97ZmmT90dGRYbhgW0aYFQB/sQX8/z7rwJRlxTVJ967T5BnGJPzqI
         dzyQHYrcyYhiS1NUep55gqlWjkSnbbdoxsuj/Cl5mkWkyKUgmhUlwPc2RX6dr/ww+0Aq
         nC2Quebmx1w1gR1eePxbAOdkVT0zyLV5RVHPzAY20afOnb14q1eMO24sRL6IXzG2GtTM
         yDrZ+ZPIBr9nICgu/a2jHGT1jlDd2BWhs7ATcMTmNsK3jSgOmXA7IzV4AfCo1OdlrEkA
         z04A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773870991; x=1774475791;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ctmE5aFMWKkncy3sWCLL07LF9OqWa0rsovqCMz1tZkA=;
        b=ZZJwJ0wYW2sVk4F7BjEzAygHYszOUFnN4YF9QQ85pcEkGSVmdjj0AZzTuTANDYWmLU
         hh4Y2miao9LwS/Nsi53i35GcjrSMfoJco+wGcrnyeYsACzEYetVV0uZa3E+Jk9pUruIE
         Fww6iGcC0hBI2FwNfOR7KkI8NTp23QWgnhBToxAzteQtRaPumHpVGkLTOIhb8JwgGmaV
         PWtaq7551p3WLIRJpRyt5NfINzW9u1nQvfflyExQMQmuDfytCh+UGaTwdom5W5Xk/CaH
         YDu4XPQh81CbRpl/92DunP97v14qT/jL8qv5dDitQJndXjbWrNcITs66qqNYkRnjcU9P
         Mrqg==
X-Forwarded-Encrypted: i=1; AJvYcCXjO2Mdihna5SkkgrqTCSpp3fexHYPmk8gvrz6bGkyn98CsmutqukiL5LC38lu55710Tg1TWQTSRg==@kvack.org
X-Gm-Message-State: AOJu0YwY1mG06mbQIPuKmxODQAu36QI2ygXLVTOo6dBTVPUtbeA/RfYN
	l23384Jf5/3BCcVoJVYJY+/ggtua4oOOGV7gBXZUpU8uQcG1vHQoLHmWfv7Pc1T1FvWcrlV4ft1
	0HfCc6aj82pufog==
X-Received: from dybuh11.prod.google.com ([2002:a05:7301:750b:b0:2be:82ee:95dc])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:1285:b0:2c0:dd99:f0b with SMTP id 5a478bee46e88-2c0e5089246mr2321633eec.25.1773870990982;
 Wed, 18 Mar 2026 14:56:30 -0700 (PDT)
Date: Wed, 18 Mar 2026 21:56:05 +0000
In-Reply-To: <absRz4U_IMk0ofxl@google.com>
Mime-Version: 1.0
References: <absRz4U_IMk0ofxl@google.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260318215629.2849052-1-bingjiao@google.com>
Subject: [PATCH v2] mm/memcontrol: fix reclaim_options leak in try_charge_memcg()
From: Bing Jiao <bingjiao@google.com>
To: bingjiao@google.com
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, cgroups@vger.kernel.org, chrisl@kernel.org, david@kernel.org, 
	hannes@cmpxchg.org, joshua.hahnjy@gmail.com, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, muchun.song@linux.dev, nphamcs@gmail.com, 
	rientjes@google.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, weixugc@google.com, yosry@kernel.org, 
	youngjun.park@lge.com, yuanchu@google.com, zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8prr1kmhrd3zjwix84ykf18m4ki4pftt
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 884F9C000C
X-HE-Tag: 1773870992-460004
X-HE-Meta: U2FsdGVkX19Lbp921XxYl4uEOfLZY44WHtMBeA6jnVhqkaMNeWPnbbY7pVw+s9/aO8DWFBxgvbyPvM+p1zbcat65tvvZzi6b4Ty1GQQ6+MMz5Upc/Cg1rtw519Lmdxr4eU09e+7uxi6LjQuP4RAjxc2j3ZRWMASa4mNBNJ7kyGGE7PFP/v3m7RHH0/rQJ/2GoyCzSsT5EFWnRTHCB4hBXoXBmHSlihZ/OhY7B4nfia0ejd/7CvrZymFF90Dq047RicOfjWKbxtGh1q+e7u97/pNG0KNzyycYscvqmzsic+27uTI4POj2kraFa4R/KeMdHlqRRwU3dgnJlPPe1d6gNm+yLMm4gHhvjBeBpv9jHz/lRstubQT31Tr50fn4oinLrf366fAIiC7WPe87uZcwtrIaKVZ4z8k/0lWy6Q9hDnmDs9uP7g8+LS5Bjtu4dGgT5PQRmWHgOMvKhTNvQocG63hhXLJfANmwvhpu5OkkwzwdXHGNKfgJyIKlLiV2q3czd/DJ1NVt7JUZt6zQ9lm6o3H2hFivSk5Aeb4ZFoOdTmklBrTyCYVAV5UxKTr5sq9LPQTbQZDwNejs6LnskP0dgoFMQFRb1J/70RdM9U27DPOL7fJ48B3Ze9QRzEdGw2mjgZ4i+uvtVgd2T8QU2Tsp01s8Cd2c6PzvBKeBUAkTLsbj3SYxrfm42Xhh/L7iZF+mwaP1BQm/TXw07ZGPa+FXBnCsyKSKj+C98RH5tWy6vgJAZKUnnK5OW6bkBRdqwqyjIF9s4KJZMEfsRmV1yan3dJiGC/UQxZiIUfyFT+tmCc8O7Vj86zTMscm4Q1S3Q04zjRLT/PDdHoOJ45gCDE7WDR4FVFI64pTJG3tN/fMwAPUR1iKYTbzbABBc73qkZdilB1PyYetJ+0A9aN8fxO1x3SpnIG9hLCjRjbr5poy+GcDZjPl8mmIR0GfNrafjtysCU4jRUXE29QQRtym5p6N
 YHfB93Un
 u+IjMnHRMvBtdC5QIdOsFVW1d/8NpK527iX1eX2zinvY/T744Ws43iJhZSokEEN0C4+WbzH8buWiNqCgIQHaXKjH8D72ALXnnZXj7exDWmBAzlS8bpUZiupxVofhiv2N0+J/d8opf6wdKvmvQPowKhg85/5Yss9FW/wittICgfR/BMpausilXZxFZt79sS2vr8tYz7V0KLCEzi1me3RPSnQFjvvVW49Xxkvk1RSZbWlLVYt6uHYvGSL6enBpEFLv3SC00lZ9kAPifoyj4a+ztKHZzjOQSIOk8CICkvlp5g7e+qis38M8yLq9t/X2LrQQNOi5pP9X5UTIJRdd8XVxLr31esWAZEEoqAo0Wz8DDp3UtmAGXF6e0+oTgIMMlnSWMubwBw2JGrx+tiAnmbxASWxhMnmVRWDQ78SQyJ9rxgXOASZtctbdHwGB2Wkos18P1DDkBAZlIiK+BCWEqx7HJ5hTrsbIP/Z7nfVRRg/m0DDJKBiAQqJ+dUsQl4wuZ+/IaSgCQCpctt01HkXqWOu2vxuNkc8cW0rnJQv0QAt6WZf9hGULeJMFpugixYzJkI1zuZCz8/jL+5SvkECfeXW1d5CvFQEsETSep20fXfa5QabMqCIL2UdnAyX8vcu3c1eH509PjrytfphmZ7EM2+txWjriNOWriS83WvA/fON7RrXcL9uQkPtlmWzP4fTAanKYZFDrNt7nwd9YCkaz+B04Yw+OT6p57lK6qaAXQ9QCO/EVF/xOvwF8zIW5uwmzGYc759LpQX1Rf2do18VX3dbQ0HcA0lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In try_charge_memcg(), the 'reclaim_options' variable is initialized
once at the start of the function. However, the function contains a
retry loop. If reclaim_options were modified during an iteration
(e.g., by encountering a memsw limit), the modified state would
persist into subsequent retries.

This leads to incorrect reclaim behavior. Specifically,
MEMCG_RECLAIM_MAY_SWAP is cleared when the combined memcg->memsw limit
is reached. After reclaimation attemps, a subsequent retry may
successfully charge memcg->memsw but fail on the memcg->memory charge.
In this case, swapping should be permitted, but the carried-over state
prevents it.

Fix by moving the initialization of 'reclaim_options' inside the
retry loop, ensuring a clean state for every reclaim attempt.

Fixes: 73b73bac90d9 ("mm: vmpressure: don't count proactive reclaim in vmpressure")
Signed-off-by: Bing Jiao <bingjiao@google.com>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
---
v2:
- Dropped other patches.
- Refined commit message to clarify the impact of the leak (Yosry).
- Added Reviewed-by tag.

 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a47fb68dd65f..303ac622d22d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2558,7 +2558,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	struct page_counter *counter;
 	unsigned long nr_reclaimed;
 	bool passed_oom = false;
-	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
+	unsigned int reclaim_options;
 	bool drained = false;
 	bool raised_max_event = false;
 	unsigned long pflags;
@@ -2572,6 +2572,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		/* Avoid the refill and flush of the older stock */
 		batch = nr_pages;

+	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (!do_memsw_account() ||
 	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 		if (page_counter_try_charge(&memcg->memory, batch, &counter))
--
2.53.0.851.ga537e3e6e9-goog


