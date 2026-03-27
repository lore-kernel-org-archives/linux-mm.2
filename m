Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C54F010F284A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 258956B0099; Fri, 27 Mar 2026 12:15:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 160EF6B009B; Fri, 27 Mar 2026 12:15:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED9D86B009E; Fri, 27 Mar 2026 12:15:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1DC76B0099
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:15:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F3C514115F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:15:09 +0000 (UTC)
X-FDA: 84592342338.08.78B431C
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf28.hostedemail.com (Postfix) with ESMTP id B1F4DC0004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:15:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="rFprX9/c";
	spf=pass (imf28.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774628107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B7DEJ5+heQ7onPG4SiPavDH/m9STlxrOJvRAAYFCZmk=;
	b=l3TiS4q+A93Q7ViStqhOrqTqgwEL8FPqmft10mLj0O7ovGe9/lEcOritV9vuyH/mrBSNjS
	V4+LW9o9u+K3QECJM8IBKIQPlTPWVADew8g4nmiF/072YLNFtjrdIbNPd9zI7cvf7Is2Rf
	X9X9fWVQU+sevU2EgwjeHhWIXOrjSys=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="rFprX9/c";
	spf=pass (imf28.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774628107; a=rsa-sha256;
	cv=none;
	b=yLFTeTSsMD+dKiR4/kbZ0+FviwAlGOuUTbZVzp9u6d33ER9FXv1R56w+V9zf+CRk0VMFzU
	VIjod2hwJaEVHyIsQwrBgtsX21FTCs2AvL13gyJWQC/chl/D2nDnMJwCg+hemDiOAyFdEK
	3VOn9jzgGWnMn5LTvsZBUUjLdO52J2A=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 2BFB9BDFF4;
	Fri, 27 Mar 2026 16:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774628106;
	bh=B7DEJ5+heQ7onPG4SiPavDH/m9STlxrOJvRAAYFCZmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rFprX9/czIYpk1hi0PDIfJiYr9UDmrn01At0JPcx6PnxMzpApE1TGZp1DomGrZmq8
	 rkaNNNgC5R/FeDXomkyq1NQwRqI4xe/bYuOddaYm7vF7qdIyHiA7wtt3v685+c3Orr
	 /fKUPCEXglEytJEC6VCrWP6ng0RQfMukdSMt5h5Y=
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
Subject: [PATCH v2 2/8] mm: use zone lock guard in unset_migratetype_isolate()
Date: Fri, 27 Mar 2026 16:14:42 +0000
Message-ID: <7a35dde707776916c170c26f9124644228d346ce.1774627568.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774627568.git.d@ilvokhin.com>
References: <cover.1774627568.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ze6oy5gsfrakqhrponk1hyx7znmj6iai
X-Rspamd-Queue-Id: B1F4DC0004
X-Rspamd-Server: rspam09
X-HE-Tag: 1774628107-688797
X-HE-Meta: U2FsdGVkX1/z1kVUlH9xURFqCyp885dJMQlRh5xrcTuIH9jzaw6Ve3NfoL72Z0HD0ArzEloE+qgdX/t9nEqdmQsOIVqN2fPYiB6iNxjgRxgjMn6SrY9w9D6ZAHWspo/pbCcO7PmawVaB6H71glA/K236pctWZUJO5GQKo4jQZxn2CmFKnwFM2QDIK2Gm/BOYMTQyygDEdOS5g33vUunXBSN7jTb2GtTW+gwY1U8e7RJqHSrkmmmv86YSw3rQIVUKKp64tcJwG1efsYLQ1uOOf8mRpQm4IH4ITnLCMHHgmxWEMiFkOOPr71P8lsIr6/TchiZVbQ8ZSZSYjKxGIcVGnf3EFKq5ul+haCPGG2dDrUGcFz/90rnT1UJTNiRTk2kfL4Qj3w4LJNqlLmJPP6WhRQDwrkahGyu8ELPyN6rvWe8MTZ8u7ei7GtOeXebU+XeHCCXuEtILL4I8is2xsLA/cDmOxfgtYxLD2Fy2RsoVFm5LvOeBDQbCt/CpuOi8m5sJ6JBNqMeWXXJuH6yYetenAI0kkQ/ErlgoLwzkyVySzTi2XUYzf6Vz3ta9Y9hT4mSjM0aCDWfUNxjuJQUenNqvFG4lw9JGmb37MRmcaH47M6eO/okKGYkE807M6UyKHlFfZOu6Y90u4OqGVdRF2SY4adWW4F+R76u+ZLa0B4ycw4N4o07MQGmTqoi0pCPNp0WZCzBW9p3pyecO3t/EJvw3ddozKvymIVoa5IzlcRy+FjJytpmPhASyfeY/dnalqRvvt2XbP6FAhP2jxBvopfNTqzYZPwxcu3I0vxEn+9p/THTFryh1i/p2GDIk5j5U670qJBWYZrFY8khrPd3yFZjtFDn1YsCVtjmDMSFw0yuAbOcNmymerZNuH8E+82wbyp9HbNX3W5EZV8MGsg+q+zZ7tQpU4T6409LrXiNWs7j+qubFQM3r9HbDZf0+FWpMDTfcDqjiZUJEuY/TyzLr0nr
 BHjR4yri
 7saI0iNlXLBxPMvr0tE4Xx2P9GQBpm2gxVEDHv5rCBJUZ1yzbwAPGnJnsljOa8slebdfmSQ4F9qVb8FUlgAWjA/zd0gyAD54+9P4K72M6ghxAPi5dPE8Ppe8zQ2yqs/hB/luxZdOG9MEROn8AIPyaa2Ts1KSgvUeftrZ85ia5RUz0Q94gaLIClKeqhCE+wRMJ2hcYHkgqz76GF6xheSlo7zE52Hw5PGWBeZgA9fiyesH/4iRCnV8fKrSMCl4dmFLq7Cn59ThDicuMy90n3t9Rrs/TmadkBsXN/UdQkFvWsFDb0BCOH8A8SPQWxyfopU5bGOI8m84eSjl8XJL5aAlz44BRyga9pqA1gVOB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use spinlock_irqsave zone lock guard in unset_migratetype_isolate() to
replace the explicit lock/unlock and goto pattern with automatic
scope-based cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/page_isolation.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index c48ff5c00244..9d606052dd80 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -223,15 +223,14 @@ static int set_migratetype_isolate(struct page *page, enum pb_isolate_mode mode,
 static void unset_migratetype_isolate(struct page *page)
 {
 	struct zone *zone;
-	unsigned long flags;
 	bool isolated_page = false;
 	unsigned int order;
 	struct page *buddy;
 
 	zone = page_zone(page);
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 	if (!is_migrate_isolate_page(page))
-		goto out;
+		return;
 
 	/*
 	 * Because freepage with more than pageblock_order on isolated
@@ -279,8 +278,6 @@ static void unset_migratetype_isolate(struct page *page)
 		__putback_isolated_page(page, order, get_pageblock_migratetype(page));
 	}
 	zone->nr_isolate_pageblock--;
-out:
-	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
 static inline struct page *
-- 
2.52.0


