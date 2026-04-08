Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F9CF1073CBC
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 13:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08E2D6B0093; Wed,  8 Apr 2026 09:33:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0B9E6B0098; Wed,  8 Apr 2026 09:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D105A6B0095; Wed,  8 Apr 2026 09:33:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A4F0B6B0095
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:33:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3276516014F
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:33:45 +0000 (UTC)
X-FDA: 84635481210.18.267D09B
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf25.hostedemail.com (Postfix) with ESMTP id 51007A000E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:33:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=IvnRXoaO;
	spf=pass (imf25.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775655223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xTQqRfhvs/Tv/mhxkfDN3528xsH43ydxutA5GLZLSsM=;
	b=ViZK+AK9NdnxIn5PBpf9CUEQ4FvPLrqoOEv3qh0xjkiadshVTI6CTlWlkynW60xEc1Bwnd
	9A5ebesGW1Vk5nb8OChO8PZiPBgGAEZuapi9H0cGQ0Ub9YVq2IqYWb0GvxusIgw4fc/x3+
	Yo4wmc/yYVNAgA+YHbKH2cuHy3j39n8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=IvnRXoaO;
	spf=pass (imf25.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775655223; a=rsa-sha256;
	cv=none;
	b=Eu/pRxxs9yunE76prsYcvyEgZqXiiSfcxBl5CP836kW0f1DvTPk58wZMQBIX1d13N91C0N
	JYKkHJXRErrftWDtfaTvKuXKeLjwe/uEyGCGJr2wQb6O+CCisainYcu4GRt2fx8tfh7T3e
	VawA8umROBTMbyPVCjo+XIJw1HElqgg=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id D519EBE71C;
	Wed, 08 Apr 2026 13:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1775655220;
	bh=xTQqRfhvs/Tv/mhxkfDN3528xsH43ydxutA5GLZLSsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IvnRXoaObJirk2iWCAuDUuAZMp8JYZjmXaRXN3rlDRnLU6+WLTt2kcrnFPYJp1V4y
	 PAkcgMOX36lIBxcgF+4Jq1Xz71r4scavVF9rq59QbfDNM4yBABpfvjZjvn+/A20zXY
	 h5HDWLd+rHptqEZJJ5wzYcYACJvJeB3WM9aA1wZg=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [RESEND PATCH v2 5/8] mm: use zone lock guard in take_page_off_buddy()
Date: Wed,  8 Apr 2026 13:33:20 +0000
Message-ID: <37f14ad134e1e639f4b41c238b14e5a24e9115d5.1775654118.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775654118.git.d@ilvokhin.com>
References: <cover.1775654118.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 51007A000E
X-Stat-Signature: sxjhpxb5m5h17fhiimiz3qgknnus5f95
X-Rspam-User: 
X-HE-Tag: 1775655223-531481
X-HE-Meta: U2FsdGVkX18T32VA52H0Mm3OD0iVHKBPJM63ajzFFO3w1kMhblVh1aOr1JNu+7Iwrd93wtjKCxTPqP+x4RupXDi45vGTjGx+4ukLb7Rp5CdpuVLaDflJNGJ4U6hlCBwG+G1Jwuwuq5JwYeLU5xO3u0eWszsTgxAS0w0ouWcFl9WnnYYxu9d6SbRPKyujHeGhG6pM6ZtAomnKr0yVEF0NsQ4DnnyIvXmoiIZ5zOtWo7SfBbxFBxh9h2lZQ7Xsh6d5HRyqJu88CibKTJjdMLtOnhiLXzhxtkSqQuQH2RyUc3CO4TqKZ6KDbFdrKi7nPVY1cMB1n4Vq2+D8wqFR68h/Wl3HSnBC5/zwgBKch8Ztq6bHN0knASGU/WvXlRyiwi+2wowEUEj2ErvLASiyHhnPuTbYS723vL5kNIJT88ub+0TRhH55ly8kXPPg72llyPN8vWjmcBJQg8JxK0aPXsu8TWVT60Hbk42C1F4koF/00BMLHG9yrxpsh/MWnqQyPbXr1EKbPbRgnzYKvt5WUt9To2k3GnP9pnooqk4F2TR2xOXCHpWEwXccG4obByh2sOKwpfXeoSMC1ZGiswTBtsDETnTbSImKAHEIry949FILasqAXD3D9fBBXKT6Yy1TpnmpprIheJfE6EOmrk5/6NQtpr98MW7SpHXbsyM0XW6SlWZghv+w+25IZ9DbrLlvfiN3k5/FwrzVQWke+/nNNSQMfRXgoh2KGRzjBzg83DHp0l0uXOiIu6NgUDsHT1V7ZIJB5swqJz5QibzgJgpWVz3bvQugQJDCV4plX/GzFo311IpCWagtv6KW435yNXVgJHgotK1Y89OlgqGM2EGjtcImAaMGnk/lb6DPHBYfT2/lx/ca7ty38mPSro3Q4gi/mf9tmeibLljWXtGtnrJb6JMCfI+nreUBoY5Bfn3n/rRLuTeQHzPKjcjrXWNCfDfTifInOM+fhQIIbpkqglTUfDc
 TKyntMvL
 kKjMHDEDiilqN6W2o4XNfbBMkRjWQYZlPX92ZbSfWvBnBbflk6oHq2BtzvF4+Jz+je4w4DyVYVgfgRwQwUwtLF7NfBACPyCgo5MYV4PtPducEorbpk/f0hGPb0es03nJRL6pX23HZEXwQwlEYk5+5iCVZGYYm5Zf9T1fSsyW2wVXOhsPPNunTwQzXIY6iEFYXgMtdbUb6fsIR/zqje3Jg/Jm0bCpWbneX2FGg3DcKYQqsDYVpHBe8ztPljpCbyZ6FHDGlh2bQt+A+yAJSW/u2egxJH+dtDGKgH/PHrg2s6TZk3rmmhLIIXZcKVIN1hPC/ZMYMIxTFOGhfNeZvsg0IAW/hE+0zVyC3Y4Zd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use spinlock_irqsave zone lock guard in take_page_off_buddy() to replace
the explicit lock/unlock pattern with automatic scope-based cleanup.

This also allows to return directly from the loop, removing the 'ret'
variable.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/page_alloc.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0b9a423cbd24..4d074707c850 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7509,11 +7509,9 @@ bool take_page_off_buddy(struct page *page)
 {
 	struct zone *zone = page_zone(page);
 	unsigned long pfn = page_to_pfn(page);
-	unsigned long flags;
 	unsigned int order;
-	bool ret = false;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 	for (order = 0; order < NR_PAGE_ORDERS; order++) {
 		struct page *page_head = page - (pfn & ((1 << order) - 1));
 		int page_order = buddy_order(page_head);
@@ -7528,14 +7526,12 @@ bool take_page_off_buddy(struct page *page)
 			break_down_buddy_pages(zone, page_head, page, 0,
 						page_order, migratetype);
 			SetPageHWPoisonTakenOff(page);
-			ret = true;
-			break;
+			return true;
 		}
 		if (page_count(page_head) > 0)
 			break;
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
-	return ret;
+	return false;
 }
 
 /*
-- 
2.52.0


