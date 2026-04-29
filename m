Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52EBAFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 12:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27C386B0095; Wed, 29 Apr 2026 08:02:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22CAF6B0096; Wed, 29 Apr 2026 08:02:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16A716B0098; Wed, 29 Apr 2026 08:02:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0098C6B0095
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:02:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC9EF1401CD
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:02:30 +0000 (UTC)
X-FDA: 84711456060.08.9B53273
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf08.hostedemail.com (Postfix) with ESMTP id C7C31160011
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:02:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=ozdWsuBP;
	spf=pass (imf08.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777464149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+vLfmbXqwXgmH4lNQcVgex9hhUeRXErkE3qPpie0uS8=;
	b=zSL/RAtxiJsyNKviUD/7XWxhil9JIdEPinrQ1xX+mBewJFYJdV4xOq/IsfdEMTGfeEHRc4
	X8Kd2lu8QP7HaMlO+5ejU8vSrsO56R9rNK6N1FtxVB6WG3P45IPOVSnLzYnC40tD93nh/w
	GrpXTg22lDYjFBFqeQO1f9bUFQ0JWlw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777464149; a=rsa-sha256;
	cv=none;
	b=RdQf6oaQrb5JaoPGem++jTPqZELTScrCmHm4xuFA9JEy1ZYLdzkQbz9YhL0gWgeIDQxVgz
	LOwviLSDc5qQF4akXFgnY3ZziJyvqyZoGi1r7gKv6WB1Sn89+zdB8ReQHtksuuAZRk5oNG
	Pv2+5wz8YZVFHeS6FE0CIa0A6dAVzfw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=ozdWsuBP;
	spf=pass (imf08.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id EF6EDC7A85;
	Wed, 29 Apr 2026 12:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1777464147;
	bh=+vLfmbXqwXgmH4lNQcVgex9hhUeRXErkE3qPpie0uS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ozdWsuBPqU6Jztn9hhnvmqTTqE6qoUYMX08hLW8Ko9MVXT4TuqfmBruXOi8BvQq8k
	 W6FiDx7J2RQN7vg+XLY+Cs6RcNnwWXimw5jPuaHgZk0/+t/PD5E4LQrD6Ib7YfdPMB
	 dwyBB8iYJTu3MRduuwvRjy4VGDr5BP6fS8vmrqCg=
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
Subject: [PATCH v3 3/8] mm: use zone lock guard in unreserve_highatomic_pageblock()
Date: Wed, 29 Apr 2026 12:02:08 +0000
Message-ID: <69db814cd178915cb5615334a29304678f960963.1777462630.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777462630.git.d@ilvokhin.com>
References: <cover.1777462630.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C7C31160011
X-Stat-Signature: 4wzarha3ikyhww35wmaik4ctdf9xi5ju
X-Rspam-User: 
X-HE-Tag: 1777464148-390376
X-HE-Meta: U2FsdGVkX19UeSj2gvM5/nX/a88uvkCyQ0bTx9IqJqT7JVjVIz86HV2YsI+ROWLUK4KJRtw0e1YXYI0k8w8jcjJjb97rM7G7jJhmAManWDDoGWAJtUgtD3C+7iIHn14B3g7MeOD/hkC7mORcG3hyOi7E0suXdIXBdwnObkeVyhc2HgJy/AKSpSQpQuLGrJ1KiDPa189XomrraKlCoLcepntime9+8ftyeYxKunnF2Mlvb/5D3mrKqXpqXV1GBz1BISbs5k433sWRgzf760IPvd+2ppn1pYJwFGIfNG6t5FYxXxAIafNmPH3KQ/o29RuMnCQNhQt2agoSV3bM60kMBLFg1XVrjZZoUPEeXwwqK5dS37NwR85b/zFPmLmR92gSkDZJHcZ6/jjpkAi0nE26unSG/tcQj7+IRyZBF7tEBaCZPBslwPl0Vbuzx5VUJfW9G/FSegKAyZOC+D5AeUko+CF80seQr0v/0sknjnEQohPls6cr0rFGdYlZZ1lhP43LbpjUd8MDAHr6+0HxXdAxJ/g4ret1y+epLWAMtBJldZkVJlSeGo54d8ZroWmAIweDKwvk2xMgfvnwzD3Z4/fkmsapfnM8vApERbaAGdY4k7pWHIQGFotWSHgpRxcgXN2MwRc8oe6PZeKmvjwGVhMzY4m0cn/YwQoHqW2g5STD9yRLIaPTKIufRlpAe9Ei/sDTRVdmzs0/TM+tdH4hNCQ7LsHtSGjy/WubOgR9oCwIqyi99C4zQb7djEwHu5X6YU2w8ObD4APGcpG/oj+4t17BiiDDjNkqUWpLFnrtzvq5LYpSOmyBfpDu2n7ZXNI+U2FRrfifwa8WyPGMeRsdXbZZ+CUVoVRT6xypqIaWY1V8r1Jn2tQ8k8JL1wmhiqAuoaPhpUNjkkdb2YI0QuftmuY+ANFqgbmnCiMi1gS4N+BVLAIcI0LX+D3GaYTfpwn7tnKPSC9xejlIfIMKAcU28Wm
 O0PrUhZO
 rqu2uOhmKM2Cex87067scnGTf6pg4f6QwSvxFnDmU+v4lkBTzDfBJFgt/srJzTJ/KiYAxr2ciTvCIDrf2B4wMWuW4D7FD1bZjAGoa1pyfasYrSqOqBis67Ti9iiyAwELqyXfXT9U4ClG6qShgQE3BY9VujzxbeW/VgDsW1EcG/JwyIWpHWQd/rfTcsd9KVq7YfNFO85fXl+1VtMG/lqSDu80SLkGqib+E64IB0KUWI6qdys9h3NGR0aCslMV3oUAM0dFljFuiYGirVPN9tQ9b+yVFLhqnih/pLizGKPCrG8YzfCjwvf72y6m3RbQCOI5wKIxoVIVWHzM7vhWfQjuem87W+4dFKVtu3miHGEMVBo9wsxzFiQBuHfsJeTSzWp6D4QT45UuHdzRuysH6LDSpboOk68VdtZE77vfq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use spinlock_irqsave zone lock guard in unreserve_highatomic_pageblock()
to replace the explicit lock/unlock pattern with automatic scope-based
cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/page_alloc.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 14c172c9b6c6..2f4170ae60f5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3478,7 +3478,6 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 						bool force)
 {
 	struct zonelist *zonelist = ac->zonelist;
-	unsigned long flags;
 	struct zoneref *z;
 	struct zone *zone;
 	struct page *page;
@@ -3495,7 +3494,7 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 					pageblock_nr_pages)
 			continue;
 
-		spin_lock_irqsave(&zone->lock, flags);
+		guard(spinlock_irqsave)(&zone->lock);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
 			struct free_area *area = &(zone->free_area[order]);
 			unsigned long size;
@@ -3542,12 +3541,9 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 			 * so this should not fail on zone boundaries.
 			 */
 			WARN_ON_ONCE(ret == -1);
-			if (ret > 0) {
-				spin_unlock_irqrestore(&zone->lock, flags);
+			if (ret > 0)
 				return ret;
-			}
 		}
-		spin_unlock_irqrestore(&zone->lock, flags);
 	}
 
 	return false;
-- 
2.52.0


