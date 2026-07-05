Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35819C44500
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 20:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1FA26B00A5; Sun,  5 Jul 2026 16:57:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5A2B6B00A6; Sun,  5 Jul 2026 16:57:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B22256B00A7; Sun,  5 Jul 2026 16:57:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 76FBB6B00A5
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:57:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8A2DA01D2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:57 +0000 (UTC)
X-FDA: 84955934994.11.C17C38E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 58FAF120005
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d5ZpNRl6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783285076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWM9ulbAfG9bosKr1Xo0BbZMoQtsvPUcnEqaGbAY52s=;
	b=RQ6Jk9AaaWFVAHiDJcGIBmzS+kIbYmLAHzI1l6q5x3ZhPlci9BLGaKxg13dHaBvQBerBZJ
	1QVxsFaMG9kHK2Oe/Zie6DShY99tYdO1TTyhP18hmNMw4ahFunAoVg7GlJ68lIxBSKfS52
	6vz6hMyvWJFuUVAbQp6vPUoTmg5GBAc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d5ZpNRl6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783285076;
	b=7AIGHZ8HGn1LaTEqJkysVAn5iOBAVd8okvvugN2R4Lp+AUSrLSG+jadmvr++/WnIYT2LG5
	DJnN9KCbIVAqp+hkekpWIonu557yCnSxpUW8AtivpeRnfQxT5PtrW7J1c7GwOrtT1X3T3u
	2shhdABOQcNY3IAs15I50OsJpVqOA9c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9BDDD43C53;
	Sun,  5 Jul 2026 20:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4819D1F00A3D;
	Sun,  5 Jul 2026 20:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783285075;
	bh=HWM9ulbAfG9bosKr1Xo0BbZMoQtsvPUcnEqaGbAY52s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d5ZpNRl6fvmW83KKSXyUuTyE87rA/bXRA4wLjovZyHCnAYMuO8wFQksZ25hz4kabW
	 JH434phDAKXBga/SdAIN8rSmdTThwWYr3eLBKC7sef82/z3T50sE+puhGzbSemQwHx
	 sp4drReeE2DtOSUY3i5tDnSg79rzuD9TQyFiVJo0tmFzUWYs/OB4Z02B5ZujzRfT3P
	 jaz+8RZNTa80vqKB29hhVyF0wB8CYT/x9b81s+ZHtWOWB+lOt5B4GZMsng6ueqker/
	 wdg9HMPBBJC0es0q0Cl8cSxwt9+7nSjRgH2+znPUByyINF+3gPCFpp+w3kjZww82An
	 dpdymwrCpN1cg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 06/16] mm/damon/paddr: respect return_max_wsum
Date: Sun,  5 Jul 2026 13:57:28 -0700
Message-ID: <20260705205743.98656-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705205743.98656-1-sj@kernel.org>
References: <20260705205743.98656-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 58FAF120005
X-Stat-Signature: sucinp9wp15885onwgouwua4oco8uoaw
X-Rspam-User: 
X-HE-Tag: 1783285076-721834
X-HE-Meta: U2FsdGVkX18OaQ8olMzx0L/EuaKrv+t6Z0EG8nBcK1AXqnPhu8gGq5EfVrlp+f38Lk9Kd4m8d23ZmHJX5xDBekrRLIvV84ZCpuw2WMrQyB64haMs6HXbwFUx93BdD7l9H2W72O4yMlMpcs+z5XLL/l0US3ctZNAUxmpQr9eCRsbqLtDWM3OjT/CdnUtHkTGh65ToVxhY+GP6vrgJy+4BfvXPaQTEzhbXZ1IiwWBla/nDr9UW1XuEANs21AwFGoxKAfvGeYRaSe/JObXGLGSvQSF5h3WtlC6VReLjfl8jp4bbjiH6eyAnusLlE2xYLc0qMSi8iYFuKRA9gnoS9CA+7fwJgm0rAeqY2ddgYLgY/aKCbxWtMM+0lUVC9+pDWTQE9mkriH96r92q6XN509v3vtYxqDsJAqCTAXFlPJNVhbzk1XXDHHc2ZDRWggUiHE8K13Y/VTIUir4X6iD2i1E7kB0GWhSB7rRIggkIPO/RB6cjHirE0kpz3khp6EeYm9Wn+6LZmldCzkcTbkJJf05XP+glqznEKcxoMq/zsdgZKXTNbRAhHRhTvtqnd2GJ2YqbTc3WA/uSCy6c5qVWVtiACQYi4Jjf65bD8Hvtr2T8EG6f5v0u7LNtwZci8qzd2+jPvrD777gPMgyiJpmlO5UOy92ulwt4nkhltXPaiAMi05rZxsBFEnxOSocH5e3OlP7vVuiSXW4OGf/LBzhfRlOxaSALTkSu3are8VjyxNPBGgHnx/Lpwss1lCoeQoxaukanmlcCHonQBwcvtsfKaDEp9O2MDEZCHo11bn2EtxfiYWxHhgASjosWVyqP+rtGEIXxGw03LL60fpUIPLfBGFwfq2Msh5IMLyz/ANfcM/8ZsblC0KGngF4SbIXHcpn1Pn1tQv44Oyi5QqhexO21TAi6Bq8ubkxQS39qJppKMuojc8IWdNmlxB0aoMlJz5ZvH7IdDdnQndJ3i32ITjslard
 yWzQP8hn
 aIwr98uLvCd7ViJDWrZTqSxKEmiIO+9IKAyGOj8mHfRE3A0Mze677n/woOjnD9OXn99xLOGF/Hgn5jYISyRGEWhV96g8LFojVdPFCcU13xAxUZXZ2FSRd3PhQKdeGQ4FsdlFFm0BX09XdKtak0usmT4NSXEylXDV7t2EyESAu4ll7FGbsIQ3DOhW/w58ES8cQm+QLyQBJHXfBNkf7RmBcHhpP4PExZzxT9dp9WqJUbCGNJGrcEaAoXMwTYOzXGoofOfwkNLnvm6yycvIGLRsLdeuTVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

apply_probes() ops implementation in DAMON_PADDR is ignoring
return_max_wsum.  Respect it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 3eba3564a31fc..b85f88a7a38f4 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -172,6 +172,7 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 	struct damon_target *t;
 	struct damon_region *r;
 	struct damon_probe *p;
+	unsigned int max_wsum = 0;
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t) {
@@ -182,7 +183,6 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 			if (set_samples)
 				r->sampling_addr = damon_rand(ctx, r->ar.start,
 						r->ar.end);
-
 			pa = damon_pa_phys_addr(r->sampling_addr,
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
@@ -193,9 +193,12 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 			}
 			if (folio)
 				folio_put(folio);
+			if (return_max_wsum)
+				max_wsum = max(damon_probe_hits_wsum(r, false,
+							ctx), max_wsum);
 		}
 	}
-	return 0;
+	return max_wsum;
 }
 
 /*
-- 
2.47.3

