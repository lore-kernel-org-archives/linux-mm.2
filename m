Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8761BFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 12:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C37A6B0098; Wed, 29 Apr 2026 08:02:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69A8D6B0099; Wed, 29 Apr 2026 08:02:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EC8A6B009B; Wed, 29 Apr 2026 08:02:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 341E86B0098
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:02:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DAA7B12018F
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:02:32 +0000 (UTC)
X-FDA: 84711456144.15.28627A8
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf24.hostedemail.com (Postfix) with ESMTP id E8E37180021
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:02:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Ob03iHLc;
	spf=pass (imf24.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777464151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=26qgDplv1OVuk6JmQ9HNGeF0qFso0TJsDc0jLQcXRoY=;
	b=Hb4/eFdakPOUffvPbXNC6NB9TK+QQO6t+mkVASi23dD9vMwcecyXjltoCgZ11seYfpmdy2
	k7CNOfedWh8Nq3Oa9AXYcNx0MMF8eB7ijUYBPJrfb08wdccGOwSbvST0wC35MU2OFCWtJg
	qHw2Z0jkEBKN4uxGZKEAiBoPRHuKBss=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Ob03iHLc;
	spf=pass (imf24.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777464151; a=rsa-sha256;
	cv=none;
	b=i0j6FHHAZw6Jf7wRnz+r76WPSBU7jS5ftQYA5Pw5+nL/4Ay+lzptXNZvCrCZAMNqVcrazi
	Xdm6zt2ZIuEKxuDlSJn1uS3Gt7273wXWrlFxzYgeid0rNDv6cPzjboGsKr5UaCRu63iiDC
	8xAYrd/WcVmV//2ne4EXNfnCjisHwrE=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 6C166C7A8B;
	Wed, 29 Apr 2026 12:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1777464147;
	bh=26qgDplv1OVuk6JmQ9HNGeF0qFso0TJsDc0jLQcXRoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ob03iHLccMdBpqwUG6vSr4L4KfbAuFvgGAF30Vcd4N2KBa8r+bWhO8kK+wrRuuc6y
	 pYbmfoOyikSnjfU7JGiLiGi2EGfE5cB1LkjSKLHsogoI+g0VO0kpXjoCwCVEvJt+eP
	 bf1FXLmVuhesdin0ftAVgc0t0ILPvQOEpMBPxS6s=
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
Subject: [PATCH v3 5/8] mm: use zone lock guard in take_page_off_buddy()
Date: Wed, 29 Apr 2026 12:02:10 +0000
Message-ID: <a981721632a981f148c63e3f7df3d1116a0c3f6d.1777462630.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777462630.git.d@ilvokhin.com>
References: <cover.1777462630.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E8E37180021
X-Rspam-User: 
X-Stat-Signature: m9rrnc5o4umhonpudruej67qx6pi88qs
X-HE-Tag: 1777464150-707290
X-HE-Meta: U2FsdGVkX19fG87Nn1Sy4eXfdIHchthgo/w90hXLotEykT4Y+Ial2Nnx4J/Gvs14LqOApZ5PnvivcRf6Qpv/B84kHqzZ34FE7KvRbPL7BKQ7sFKGi05OThd+nThr62D7fmcH//4+dJ8BjM121m0S9on/rZxGShnRj2wTduGN7SblIxEmQZSu13R5s4Wl9olynb8fVT+nGPopENdRzM4Pl0SftPc71IvblEKAKsJmoqB2W0ugABLyTBiJ1r0wwbtZ6vHsNLH8wDZF5L41P/46FuvOVTVzQc7hOnuucMJ6rxqhJQgHEF45gf5inJefi2JSBJpB3a9H+dGjPs0vA12x79rX5mmPx4pPOZGZfiInynOXibNSRX26mwnsu4FMnFCJrppkBaoP+xSZ8wCeXcDx90zRzqD2PxwXgMSJgjA3WDbv7GAH/8KzvWk5uUXC9AgOpKCbZZ9KF/J+Odl4U/yqLJB7b4baHnDc1C4C3fJa4SDSge6ymoyzpAw/yiafwTpnw90VsO6mBnTs8aqd3dL0EO4TNXcMFMAj9ok2zF7NIfXyyHuVGnpahDAxdphPSAyZP8pX8QOTQDi9wd6Glu+NBATtE72onP4NOBB+OVQuPzMymrxXaZz6gZg/IMrIR2XzUKUg5qf034vM8VlgTjujAUP2QJ7gJlrX348OvD0K/NyyRvaO1Ym9N/KEeY3vZieIMJu48Dpl2LJSK4znuAEigjGFvZ6IjEKSNyW2bNQC7elHqWo65U0UJIjEwZo+H6qrNhDgijYpJlgYHj+yrmo5jwtoM1VE+Cs06b9njvlMDCpObdm5eQ2cJvhyfFkvkJz9jTrbQnevDq8v0kE+7+tgc1X12HR37bf3/e4RZop9jqCTx6uk0erLmcfuxMLolU8//FUZUc86l6AxW05pL1uQO7WM0/ZlwBr6OuWCRkVuT6ONxwxGstUG2nidN7gjKrZSVzEMJ8TV70Tr3wgXsGq
 jqVR/eeG
 dzJjBbuIaDpQmywUO54OOajPiIrkTRITdPNb4PeWZygGdzRNJbCmsOKXENmVwnskmKSFLcTg6S1L5QaUxIpNJnpapzbeqMDOShGiFJBLskd8mOapuJUDzDT15hwWuukFoWOJAEDCP95jSsPp+Nje+/1smjfGYXBxOgDHZP7RmTNqUlqGDXxYS2WbvSufuU36Gwr8Bq5fGCHzRkTgghrx0qGdpYUGdYwqh5lSbgLtkblLIUNviM/NqTsNblFrGEZJLNbqNIkSUxKt65r87i255KW34re3ITr232BhkTCB7Br32O4+XN3wqoikPscBIs1iiKOiulodHIX3eVwGdmOttiYGvgnyvG+hcO+/NkvjSkeou43RxgsnVV4t5HqNGWX4tnAoP5bSUgWnHJLsNhl+Mkdbmkg==
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
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/page_alloc.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2f4170ae60f5..013c97a3db12 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7471,11 +7471,9 @@ bool take_page_off_buddy(struct page *page)
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
@@ -7490,14 +7488,12 @@ bool take_page_off_buddy(struct page *page)
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


