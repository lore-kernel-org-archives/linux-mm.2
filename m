Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F92410F284B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368FB6B009E; Fri, 27 Mar 2026 12:15:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CB5C6B009F; Fri, 27 Mar 2026 12:15:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E2356B00A0; Fri, 27 Mar 2026 12:15:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF71E6B009E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:15:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7EFFC2506
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:15:11 +0000 (UTC)
X-FDA: 84592342422.09.9FAA8C1
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf22.hostedemail.com (Postfix) with ESMTP id 20576C0010
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:15:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=gkjmX8xQ;
	spf=pass (imf22.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774628110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCId2zbix+QCFEZnLdcQLxRLUHjV8l04CxkNFJM13pM=;
	b=AG8TZ//yJMbbqk/uv3sggFXKauhfc1dkkm1KZ1TMHrad1uz5Sa8ltTJa53nCjUyiyYWrcp
	FBU55XLMbTwmDVmlJsG9qSF6Hwvm+OccbAZE4FTVdZdUF/FRTxh1hyeMMLy4UBXUUSxTjz
	vs3VbXbnPZdRy/JWTWu352MhYPp2BF4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774628110; a=rsa-sha256;
	cv=none;
	b=1k6RQ1jo9sLaaZyz3TrtZQJ9vx706e+f8PWybPTMEArwQtCcLALPiEI3eLo/QpygBNZJh3
	OIv+MX6h0yrSxXjvrhz1LfeCYW1PLvgY5KIquwHV4zE/4AxvEBDpzAdaq+lV5XjckCgtSq
	7baS6BCTsHOmQblboKjTQPBU6q2KgGc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=gkjmX8xQ;
	spf=pass (imf22.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id ECBD6BDFFE;
	Fri, 27 Mar 2026 16:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774628107;
	bh=XCId2zbix+QCFEZnLdcQLxRLUHjV8l04CxkNFJM13pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gkjmX8xQkBKFXycL5JAS21V0pRqS8HUCoMN2sUOGhAQQxV04kJzsO/ohT4zsQuunl
	 NmHvf6ni91o8J5lsA5bY9BPjuPE/y9UZFUP8Si/QeuuJq9Eo40B4uBSB2qvca9OWqZ
	 3jB2V4Aor8GvVmNs4pwBnzOoraJG24cDjvN4kyeo=
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
Subject: [PATCH v2 5/8] mm: use zone lock guard in take_page_off_buddy()
Date: Fri, 27 Mar 2026 16:14:45 +0000
Message-ID: <79d3acf242a3a56e55c6cacd60698f427292621d.1774627568.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774627568.git.d@ilvokhin.com>
References: <cover.1774627568.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: eq9nt99sh85kob97fada1styytwkkx8z
X-Rspamd-Queue-Id: 20576C0010
X-Rspam-User: 
X-HE-Tag: 1774628109-679220
X-HE-Meta: U2FsdGVkX18SyKzs/bwgNA070Zdvtfr7KfKzEo/iU84LGY7obOC5v769AYn/wWljD2S4BGkSvgGqOudChpnhG+5TVorl9E6/zHvqUk5DnS3cjkb7oYuPrZNpfH+m9cZdUpR47vPL0OUZZ99KviPq9/AKbJTsp5jat62UxKao5ffKEZzy91b9wZXarNbIx4J/I8DmFDG3UG9xSjbBZ2Nl9DUW2m+Yw91PquG2xwbpWw2zx9Od2BOdkC4cLGPh5Ia+PP4I6mQs4TkkQ7ANA3gLwKhQ1kGJRUjH09UT7vXa0KR+gM+LsuXJzcz730QlwgqqRuaqHQSwcS9yVg0gYiG3NcgxnDYpNIirppJ6ORQyIwI14eLJ4BMbOG+ywgPAlnXr/HKSUDkXf6IpVRdIqLAkxUfuNer6RcLdmYE0XAbMp12ndSbRVsgyMsWhyuIMFlxiTR3BhpJuCN5q3CEAqm3YerUtkItBwYTgA+cnbXwfTEO0qNw/fTVQYAfzUFmWNBzt7R3Zcg+0B3kp3YlycZswwS5Ppi+c+r0NpIyZa3f4qgRybhQIJOdQD2yAQz6BB232nqQM3K9EwqVSEiqgUayB5Bq3jqZSIW/pVG/1L8urhcDV4YNMnmjt7Sg0SqYlJ43q8BiIDQL4uEuAzk+NjVe5SOWW1q4+L3fwCL5Iaah+gmvqejxryELQsq6TuiIlvs402QRK+g9JGAx6aitaDLGmYscUyaesLHhgwBYPY5DaYnKg5/R84n+PMLn4zh0C4CVrX7+byIkRE9YaVOvVWWuoB9C4aI4JM5VhN2gOPDg/fIOD5wTWtV6UjycnBxRRA/Jwfxt2Wo1PCO8pwXAI5W4g+qR9KwvY8Vh438BLhiZKYsuuMqFzbSfVDZv5jAditUIk0x9VI2qFChEAp6IAVf8686NIaEsx+mp1fIBsx3PMMBevVm8n/khzDkXk2LvhL9z983t8vIooZwM=
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
index f06d8b5ffc88..a124e4eebda4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7488,11 +7488,9 @@ bool take_page_off_buddy(struct page *page)
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
@@ -7507,14 +7505,12 @@ bool take_page_off_buddy(struct page *page)
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


