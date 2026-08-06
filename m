Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 471BDC56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 16:21:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75EFB6B0096; Thu,  6 Aug 2026 12:21:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70FBB6B0098; Thu,  6 Aug 2026 12:21:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 626996B0099; Thu,  6 Aug 2026 12:21:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 437C86B0096
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:21:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2967A013F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:21:31 +0000 (UTC)
X-FDA: 85071359982.29.FBCFEB2
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id EFA83100014
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:21:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G1WleL4l;
	spf=pass (imf05.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786033289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T6npjExn2aWGhVHz/W3QatfKtmyYiEDddeJgsZ3mtq8=;
	b=yWNR4Ak6AaXusUaKZQENG8YTcYDPvH3vIvsqUimLoda+ZSrzE53OxFgvfMhCSTxZXN3zqQ
	rQ8uWuV5Z0R1QpIThMYW8P3dUs0n9VcFwV/vUbupAfZS65VZ9s7DRtoJ3jty/yqZAIzqJR
	WYyloRVJ7yPk/jycv7XJwuI9rx+dKvw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G1WleL4l;
	spf=pass (imf05.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786033289;
	b=x9ovwkLSeRj0kif+AtyhRrDth94tP1tvS43uSn3l3QxY4eEpgFcKfHZzSgzNjL/j/DZYGC
	vWBgRgmQ8J8s8FLeUWE8wY+TDAf4IBAyt8RzYS2zy98EIh0cYNsb71EPKXnM9HpalPB/iZ
	eTvPb+CfLE29vNcLcDYB6rnLuReBFbw=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84a4d8fd6ecso2945515b3a.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 09:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786033289; x=1786638089; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T6npjExn2aWGhVHz/W3QatfKtmyYiEDddeJgsZ3mtq8=;
        b=G1WleL4lJCIlVDHxiVpqdrG5vPCoz1P4EK1DgNxjwUZN3Z2hTCovtc4nxdjLtHaFSm
         FCO56vMZDjOanFGQ5BUxocEiu20I8zOHnnsbJ2dLkU+Wxasbn49iX2ZsL+WI4sZ02KCQ
         OWJlYHzokxSie6dviglAoHuRo+85pC2jaFBAL5LJXH+x6YwhWliFZT/r0Gd5r3t5IWIl
         HYGp/9iQpglmC0e+vEDTI3hQ5XWoqjBjTPImKIbmNGyNA7VqnbLV8238MbongASWgPjf
         w5SXPktWrXij81FauGdYrEIEmmDiNy7IheVo92+wleu+V6DfA1ZLm0AhhtDZ9zV01nPy
         qTPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786033289; x=1786638089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T6npjExn2aWGhVHz/W3QatfKtmyYiEDddeJgsZ3mtq8=;
        b=qJHBenlsdMDyF+2wPqdSi2FowdnulDC0hsYKUcoBUv6TPrBJP0PXvSxooKPks5KsFb
         /cd9ltp5PpanfGyqTZdtXLAGZXpjEEylHQT2HHF8txk8M7fu3+WOsqLbw1zora0lSSSs
         wS9s9wI8eSktfSnZOKjVlb0OCzjC4mlaAakopxtqg+QRTwNUqEKWGfVw5dJejLERRcYH
         IOWnBfHn9VwGGSkJY82/gCBE8whag/+g3Tmb5g0c8J0nQPM4cAYYAJQ/f5tkJKY8Pr3Y
         TFmRex6KraYBKKZLytJ0tJIM22DLTxGIH6rvv3DXDmJpw1V3Qtf08P6PeO04W0GGouOY
         Yx+g==
X-Forwarded-Encrypted: i=1; AHgh+Royf0Vqe5F5R51DwK8/DPKRVB9Q+5H3QoT/MLP7G6tOHElJMFjM7k7IFw98lq4GzCwLM4p+B8eDFQ==@kvack.org
X-Gm-Message-State: AOJu0YzIHfnjiOZAte9Lua8/d04KR9OqRQiRZeA62zW3RE5QuRaO9fhn
	ILC6aGGBuYbQaquahbvbiQLXsQwPil6OTZGYYRWNvQqdLVX2A2V1OpP3
X-Gm-Gg: AR+sD12SdzgbSP/FdgDARAX/k4qwxrDgMmSNsZRpi1cwNenTa9RLHc9HD0dHv8JOzp6
	+0TZwrvzHHQImWlgvhlHr/zYu9wvYfjfyQxRdNCSIYzjJJYwVhFsDBfBomKnxaHfYwbe1zHRvtR
	IrG8xbjkiL7q4Kv7ceYVLnmQovkeMlvsqOueuDste74jwoe/4PN2yvRVkcuibgEqFxZwaIKl6wL
	QJbVf4nj7zZ2bMdMQe6R/oUQphwq048eMgb6NzMQe06BG0M5VY8s54MGJ/to8iUwim5xuNhtmEj
	WciwLkwgPxed/3euNSXlfuOUYnz46XFuaiVpygpnN9e9FHA7HH3Q8r3xz245e4P7PuBzfKbCZ5/
	BXozRYygZWhTZod4NfGrd7Znxx6OS0dG7GztoT70P1IVS1vjsUACVCraE7EgfAD3v1LGApxcCyb
	I41B7c4OtvmmXL/fkteiz2i2uhAIeJX/StczlliqhYfNIDqYa/xS4FPeY=
X-Received: by 2002:a05:6a00:1388:b0:845:dbdc:8652 with SMTP id d2e1a72fcca58-84f2e014143mr17907713b3a.2.1786033288591;
        Thu, 06 Aug 2026 09:21:28 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f459b66e6sm1662739b3a.40.2026.08.06.09.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:21:27 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 4/5] mm/mm_init: use min() when adjusting for ZONE_MOVABLE
Date: Fri,  7 Aug 2026 01:20:55 +0900
Message-ID: <20260806162100.313965-5-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806162100.313965-1-ekffu200098@gmail.com>
References: <20260806162100.313965-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EFA83100014
X-Stat-Signature: isio9d8kxxbsgptybkw3ws1ccs96q4n6
X-HE-Tag: 1786033289-924160
X-HE-Meta: U2FsdGVkX18F00kgc7W5HZIq81zsHtEe5N+/JOj6Saybc2SXSSfRzfx3RVS5nGxcSuBgfhVU88g13YX1Eq1Tr2WoIAjhbYoKcKKMbAI3hKvr5BGquXn8lVpuE/x1hsT3g+SqdnliH+UnBnM7MBi7MUzHZ3ocNMGEb4qO9eagFxkGjsP52p8JQe6+PyjRqx/ZNwyg7nNYH7mh/tJQ6Sbs7FLWT/etuIeet8qBBIOLdu0GQ9RRG8E9ih6ry2EfrLPOEzwYCVNBFNwTfY/zsL+eYvYlJEDBgFsF/OVo+UOwY2m6B6o3DpeIxqgBJ55t1uZyzfzQgdBsfCwZpxa/pmg35dS6cceTTVxDTVo3dNJn2SkOu9ANmx3AFydTeEZ83VA4C6bEQAU+vzrAHOlvO2FW773LJ5W26T8fBcKuH6m22oKAYzBrGW0FGDJqpGsrzp8d26KKAlNNBH2+JzNVFjwiAhmA7ffWFAyUsDEQbi1rW1MynUcdv3xmsGFvTmnnLQHkgmbVIlIxUlrGg15IyWlocldstJx6wtxwtuQi7U2QiXwE9Y8PL6i9qONv4R4KzzL/wT5nkPBbL2PYXqNlfOXqIiM8QzDVlyEQZoEsWJ1grD7Pb0KVUaSUoQeJcJaGtGoa/I6H1UvtKCBs4BUl4h9/W1O/XfYUdHRWVCePs2e3b3I89X1YNeByGC5syJajCv8YZW5ngZ60JRPT5BI1S8uFpkrFaneQfS64d0bDtJdXRFuDHnT3j5LBrA8l1tPrMzD370E/dMA7mye2DFw7simEiEQx6j4G+EO2gfCP/k4pXiNx1T0i3EcQBM1rXRK4Ok78+36wMFlN2lB05cljX8CDb1IcZt7Cck3ButsTsSOKHWo7/Hob1y6bxZE+UAYr/Cj0IflhqaCiLPZq+CVWwhBjOlgFXUwuZGVGhj7Vzh1tTGNaSgyZ5QcuwpWaCUFyZ4tSnN6LX4qqrnmcVzSTY8K
 A18LchxC
 oq+gPxXNbqBpLW95FkAEHs/7jXH6RkGKJ0fGrFZRCKSwt6SQMu7oerNTx0jtrAgJrgx/z50chfp7YsqNsbJjG33CJZGtNisrbLEA9Q3ffCvozMZUPXt9u4S3JLzofTiiMZQErzDxGhQnx6JINyTfp9biWaJbjRMyds7SCf92IUOd/aoqdjAZytimRf5jPGt6KRYT5ngg1FnknGyHoETXu84iE8kdMLTYXFgp6Qikz7uc/s+zSGcN3X4rJzwG1lLzdke8vKuhAxMHvy9cBGGqRkNUGEWoV5pW+FLMtqAlwhFhPJxkcX1JlGZdhIKhVVdpwFzztNMpCH8dajN/83Qkko9fnOH7IqJFQnG3Hlw+GKwB62T6ujLI0aOzJsF/s/0kU+dPArw8oIyyHvfNkWFYNtS0JOdu688MZBDk/76qcfltkq90Uxcd1QTzhsmmeo9La/q6sTPwLdBilyBM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Outside the ZONE_MOVABLE branch, the two branches set *zone_start_pfn
and *zone_end_pfn as follows.

1. If *zone_start_pfn < zone_movable_pfn[nid], *zone_end_pfn ends up as
   min(*zone_end_pfn, zone_movable_pfn[nid]).

   a. If *zone_end_pfn > zone_movable_pfn[nid], *zone_end_pfn =
      zone_movable_pfn[nid].

   b. If *zone_end_pfn <= zone_movable_pfn[nid], *zone_end_pfn is
      unchanged.

2. Else *zone_start_pfn >= zone_movable_pfn[nid] and the whole range is
   within ZONE_MOVABLE, so *zone_start_pfn = *zone_end_pfn.

So use min() to simplify the conditions.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/mm_init.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index fa6b5977261f..27f454edbebb 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1213,14 +1213,14 @@ static unsigned long __init zone_spanned_pages_in_node(int nid,
 			/* Move the zone start inside the node if necessary */
 			*zone_start_pfn = max(*zone_start_pfn, node_start_pfn);
 
-		/* Adjust for ZONE_MOVABLE starting within this range */
-		} else if (*zone_start_pfn < zone_movable_pfn[nid] &&
-			   *zone_end_pfn > zone_movable_pfn[nid]) {
-			*zone_end_pfn = zone_movable_pfn[nid];
+		/* This range starts below ZONE_MOVABLE */
+		} else if (*zone_start_pfn < zone_movable_pfn[nid]) {
+			*zone_end_pfn = min(*zone_end_pfn, zone_movable_pfn[nid]);
 
-		/* Check if this whole range is within ZONE_MOVABLE */
-		} else if (*zone_start_pfn >= zone_movable_pfn[nid])
+		/* This whole range is within ZONE_MOVABLE */
+		} else {
 			*zone_start_pfn = *zone_end_pfn;
+		}
 	}
 
 	/* Return the spanned pages */
-- 
2.43.0


