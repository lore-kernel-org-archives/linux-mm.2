Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB982FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 12:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FBB06B009F; Wed, 29 Apr 2026 08:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70FF66B00A0; Wed, 29 Apr 2026 08:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64CB46B00A1; Wed, 29 Apr 2026 08:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 499046B009F
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:02:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D7C4514019D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:02:37 +0000 (UTC)
X-FDA: 84711456354.18.A721404
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf07.hostedemail.com (Postfix) with ESMTP id 445084000A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:02:27 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777464156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KGNhH3EjUaTQ7/DOs7LxTGRaC2rJZ5LfPVMVIRVko5s=;
	b=A4hY7PutiVQQ0IcFbxMpEJl3G4D1byNa4B5Xe60TrsBao2Vh/hvsti4+UFzCN0VgOXvZi5
	PfzRt5LLpUlg7Wt44xTCaAe+5ajEfTWMi6MhmlUOQH3iiOaLVD9cRbvizHGjUS38v4h8rc
	YpLXkEC6s9HoOsNxXGWzA/cqpXnBs4U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=IuG7wGao;
	spf=pass (imf07.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777464156; a=rsa-sha256;
	cv=none;
	b=sC5qy0g4qvXnKijOjrW9BBIveskzXVU72xcnK7m6UG/N2m9xZ3rfzaYjzljzgthBVRjWne
	Fej3bInVyzDJv58WEUUOaexXqpKlCze2L4ntSIyleY8OahmYRUavjSv5x8sZYXmK5R1la8
	mP2rQx4+6Vc3UcXy7W0XVDtaFeaN7t4=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 7E868C7A7C;
	Wed, 29 Apr 2026 12:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1777464146;
	bh=KGNhH3EjUaTQ7/DOs7LxTGRaC2rJZ5LfPVMVIRVko5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IuG7wGaoP3203s1PEB9g4mBAYThzg0IK8w0ePN4DjXVSDldHy5/yUMPqilCoIqo/t
	 8qfGLF/j1aCUkzQYJEl10NcBI7YI71ARhqPTgOdwwHtaUavcun0Lc+coVlGvN3XZyS
	 EzVboqauIlQOFOA6x0VgHQ1zZmVPbBxAM01w9Ebw=
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
Subject: [PATCH v3 1/8] mm: use zone lock guard in reserve_highatomic_pageblock()
Date: Wed, 29 Apr 2026 12:02:06 +0000
Message-ID: <3657e1144e2ffc1ca0eb57d57d89bfec4073d8c6.1777462630.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777462630.git.d@ilvokhin.com>
References: <cover.1777462630.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HE-Tag: 1777464147-127069
X-HE-Meta: U2FsdGVkX18fZYolqDkXG0JhARtPE6yO9H4FZBOI8ldpkZjIDPlvKA/ONIkMFR93wv3r9BgL+Kc26eVIFDqk6O93VBa/Xnz6E2clIPCc305rFP6HQJo8iWaa1e07AjGV5EQifw/rT8l2teejQRY8yrYHKE4wAn8ZYaD9JlqwcNWuJTT8Y1Dp9o1mRbf8rbb57Q2f8CkP045obZr6mfYDM+hM6KOOs6Ip+l0n4aB04lY2NHAv8AtZxuEW/UBakuvR+0js4s+4A3QsSXWM007lsQwrxkJNS0+bRmgM4En/pGNeqJdsaXJfHbZIyogkFeGqjUnQWwhfhg4UKqsZ0BcwXQ0BzOA9jlmFf6E5IOL05gmIetSZd3Xm4zfjqdU+QZaw77RxpIr1aFJvrlr+NoyHjK6JN/8+A32L1jn2C97qxIL0xERoWXOB7rY7c6lWVjuE0/gRlsE6MPxkclEV32ArWHdUYCmhnhJYHtvLTkE8D81xAZJwrtQSCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the spinlock_irqsave zone lock guard in
reserve_highatomic_pageblock() to replace the explicit lock/unlock and
goto out_unlock pattern with automatic scope-based cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/page_alloc.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 65e205111553..14c172c9b6c6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3429,7 +3429,7 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
 					 struct zone *zone)
 {
 	int mt;
-	unsigned long max_managed, flags;
+	unsigned long max_managed;
 
 	/*
 	 * The number reserved as: minimum is 1 pageblock, maximum is
@@ -3443,29 +3443,26 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
 	if (zone->nr_reserved_highatomic >= max_managed)
 		return;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 
 	/* Recheck the nr_reserved_highatomic limit under the lock */
 	if (zone->nr_reserved_highatomic >= max_managed)
-		goto out_unlock;
+		return;
 
 	/* Yoink! */
 	mt = get_pageblock_migratetype(page);
 	/* Only reserve normal pageblocks (i.e., they can merge with others) */
 	if (!migratetype_is_mergeable(mt))
-		goto out_unlock;
+		return;
 
 	if (order < pageblock_order) {
 		if (move_freepages_block(zone, page, mt, MIGRATE_HIGHATOMIC) == -1)
-			goto out_unlock;
+			return;
 		zone->nr_reserved_highatomic += pageblock_nr_pages;
 	} else {
 		change_pageblock_range(page, order, MIGRATE_HIGHATOMIC);
 		zone->nr_reserved_highatomic += 1 << order;
 	}
-
-out_unlock:
-	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
 /*
-- 
2.52.0


