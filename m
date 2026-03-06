Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8531FCB618
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07AA06B0098; Fri,  6 Mar 2026 10:29:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF58B6B009E; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D68656B0093; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3236B0096
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 609578BB52
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:26 +0000 (UTC)
X-FDA: 84516022332.12.4ED93D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B6267120006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i9X92hQs;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772810964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c732e8XaL3VPaykAXs7+eIum9q0sFTSfxWtm5rJcikk=;
	b=lKSjFQlGZVYkLGKOP2fFD6P4/FZe4jrkhvZy+oSsvKyX2zwxrsR6jsqdV949mEYM1u9/8E
	jM74dGZPvyzInD5uPCkUrFpfoK7Kl2oUDs+fhOarKxmPnlInGbbMuJ2peDoSatSUxnh4cO
	e2ODghD7RYP1/BYDRUnUYV6eZoDwcDo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i9X92hQs;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772810964; a=rsa-sha256;
	cv=none;
	b=viNRp1X5Wy55VDyOTqLyWDA7wvWt4ezj9ccAvC+CCIrOXGhHq8nx9gP6sv9tk1Bd/SpvAJ
	IgOQz6t4Ld6jJ68S8qSPLAwsks2DT3gmR7EyjurQLEukOMVm2X9BMGLFcVQrI/e5SaJypn
	Mpun/e3T/9Y+1X1OoR3EJGDwjmnUNw0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A807444412;
	Fri,  6 Mar 2026 15:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771F7C2BCB0;
	Fri,  6 Mar 2026 15:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772810963;
	bh=DbZTn4AVN3XfN74TG8oRW8P+LKBDP3hbPLRg+ZDBhJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9X92hQsj5ctbO2KCOOvIWvY64DUXlPEAbUFN1LaUjDwBtNz9naa62II0rGXIRJ+Q
	 6Ys9FlwbtiUTT/NSoXJcwPUl6bTCQqTmIN+ALXeeuWiBpz5UZoFmV3KHifGtvqNKgA
	 JihBLT8MavLFZaNFjR+XhDC5t4MP9lHi7X1AKWlEM1qVs6SArV8CbxOm/Z2p/QBsPk
	 ffCZGw1IGFtJFF7FW5XuFhTprMQkapZAxJYmDENKtq8a9IkeA2MIOc+LXmd1Oub1hk
	 K4SKuF4S9sSP+caqgo6/U+F2FuD9iuMJWl/4VpIS36Fyur59NAcNPHtSFVgRji30fC
	 id9RP/X8fmKfA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/10] mm/damon/core: add damon_split_region_at() debug_sanity check
Date: Fri,  6 Mar 2026 07:29:10 -0800
Message-ID: <20260306152914.86303-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260306152914.86303-1-sj@kernel.org>
References: <20260306152914.86303-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B6267120006
X-Stat-Signature: yijuxmi15onmr4sf7udtsk5ea1mrrmqw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772810964-384769
X-HE-Meta: U2FsdGVkX1+bdHTRfQxlyGG8WFOpJc6uHo5NoF6h67yVEXbTRaq7oW+Le4vhjFgttJDdXeeEwn4nOWeJyeUa8LZZOcGyfTx9PDXtcLJxmed8pWZxqLaILmrVTHxLsZ5zdRMQFN6DGHFkVQBEaT/egkgOUp3tX4UaTRG0wtmIpTO1wyRk0u4IvMWc5Qt86cDBWfdbUy+RP9AvjrDw26LvQscaM8/dL8AtevzheP+8n41x7aBXHdg97kkTHT8CXfO5GhMdgz+Or8VBKpZ6f+80+SnI1LWyfDpbnYV/8f3m63H6T6+likuw94iJDjf2LpzTojKb/FCrd9CAPxaX1e1ItGcVfVKTGRnIJo3p1sPWl0F11mc8v/PSE3hi2v7t8gC0eHHJ6DZ/o9gP+C9jG95pJ8QbPxXiSDDw9r1inKUp0kSsmTmRNvYvzbZDp54UPIOr5arktXFuvvXs5M9xxvFLyEKOeUAa3OAQmg84DJTgVA+ikYmDHDHkE3EM+ha2eDHhRROuUm16lg5koJ4fWbWAzx67g4auqsFfmhDaJ7juJxfddeyC1TF8g/jKj2t24X/1kD8V7FBILK58F75SQyK78QWtbXUjpd5oLLAZemjd6sSz+Zt9LKcxPLqydeoK6ZKYh94UIK7UQk9H6GPGLmc9rJfwwbjcN+1FNVpAP96CHVi7sbyybWfmko9kOUv6Mws7FkPkOqHykGGH/e0JFYGMuq2CVEdsmgukACikAdf3SFnK25C6KnOri4lepQNYYk3vdEuMMkCOYpu8g4cV9Lbx6DBHxvsnLx9I+DLNWdOB1IRiihbbiyzCYxrYxZ2e6VLYe655UJkKhrxw7nyFBfJu/HT35Cix61GYZ0vUFbHvxmRB35lde8YklbirYlTdvZ6DGPD2Qxbs/gZp5yabge6thxqwRVuXiyTKVpDkmZpcTcDS3Pq6td3ODGHnH6ZsZNO08gDjWSkhf4WJbl8RLnT
 bD5YFVIK
 b0O+ZMkqHfqhXsJHDPtWfzs3Zz8xMcK79HhC4HFIre+qVQebXVWeHj9LV1vSfpdWRKu6//E3eRnqAz5aXZELJgxW1NajzlxAkY/ZPm9Vr93Bdm3Q7xDS3a+Rd8tSfot3AvlafvY+NO7T6La6mEhk0bhEC3UmbmLAQ/uMsKaqKzPuYAueNZuv5dqOdpocais5vrHKp//lnaKnJWEeSm/nQmZ90cZ0awQ+CEIFzKl3P0bNNJKpOHyXNMDBvL0PVtqB/ovt5Vh/PhCsFRMy5r9MEHoffED8puyt7d4lHfdw3yKP7w8mbRct4C5y2RYbtv0RuP6ZY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_split_region_at() should be called with the correct address to
split on.  Add a sanity check for that under CONFIG_DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 93d1577b1ae07..be2300cf3aeae 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2586,6 +2586,21 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 			threshold / 2 < max_thres);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_split_region_at(struct damon_region *r,
+		unsigned long sz_r)
+{
+	WARN_ONCE(sz_r == 0 || sz_r >= damon_sz_region(r),
+			"sz_r: %lu r: %lu-%lu (%lu)\n",
+			sz_r, r->ar.start, r->ar.end, damon_sz_region(r));
+}
+#else
+static void damon_verify_split_region_at(struct damon_region *r,
+		unsigned long sz_r)
+{
+}
+#endif
+
 /*
  * Split a region in two
  *
@@ -2597,6 +2612,7 @@ static void damon_split_region_at(struct damon_target *t,
 {
 	struct damon_region *new;
 
+	damon_verify_split_region_at(r, sz_r);
 	new = damon_new_region(r->ar.start + sz_r, r->ar.end);
 	if (!new)
 		return;
-- 
2.47.3

