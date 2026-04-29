Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74FC6FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 12:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF2C06B009B; Wed, 29 Apr 2026 08:02:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8036B009E; Wed, 29 Apr 2026 08:02:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8FB6B009D; Wed, 29 Apr 2026 08:02:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9CDA16B0099
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:02:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4FC9614015A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:02:33 +0000 (UTC)
X-FDA: 84711456186.08.DBF6712
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9863640011
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:02:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="R150X/c2";
	spf=pass (imf27.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777464151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DPNfuYFXh3MO60WD+H/lFLrfvqe7g44VnNFXGNd28pc=;
	b=C8qnnEuhtYUlxQDECgfdpJbegROfAEJF1QegNoDADBIt+g1iw/obEk9JTT6a3Qhw/wVdAZ
	4PWdsM0KZdAwkBvBj7al3U7IksqjBQlMYVJuo7MQEpUOjEOvQ4indef0kzWwgRVjaYOILH
	w5B46unrLtBFwqqKvD/XzL6Glz2GPiM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="R150X/c2";
	spf=pass (imf27.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777464151; a=rsa-sha256;
	cv=none;
	b=eQkf/jyrFKBoLEvc/meBNAg6961kesgT6/00SkKYNLQySdw4zO6FKgQJVP68MOCqYS1AC3
	t6Jiwj0L+JppM5zXxAw6K/El6Gda0yRmGeo2RaCea2sPjP5CKy+JZ7jiKZpqgvVL1x+m4t
	0ZEo8izHu4V8dHHEpcgCuTeNSeA5PZM=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 26659C7A96;
	Wed, 29 Apr 2026 12:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1777464148;
	bh=DPNfuYFXh3MO60WD+H/lFLrfvqe7g44VnNFXGNd28pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R150X/c2mqcfSdbvV/5NKOJR6w3c+7naHl79UxHaWjHyWjg9S84FBodt4la+YBEQc
	 e5dQfdkDrap6Ts1dbG1sCOvMCIVwuxpvjNtdlqIC74VNGaU6hYT9EEfJbbJirD3Bpr
	 9OJFVb8w4VhNsEdA6UzEVgdBmZZ1xJvYY03jBJps=
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
Subject: [PATCH v3 8/8] mm: use zone lock guard in __offline_isolated_pages()
Date: Wed, 29 Apr 2026 12:02:13 +0000
Message-ID: <13149be4f8151e18eb5f1eb4f3241ab3cffb373e.1777462630.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777462630.git.d@ilvokhin.com>
References: <cover.1777462630.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9863640011
X-Rspam-User: 
X-Stat-Signature: o4qaru54rxc5eqfrfxfrdymoe797ximo
X-HE-Tag: 1777464151-46541
X-HE-Meta: U2FsdGVkX1/ntqkRw6tDf077agtGhx9UOooWImoN0XAKWnDmyaMpy/FrJ1anKSaY3KOY/mch8+m0vp5kvKLZxJn5QqDJAAQdCgsLtexxahJlkTHvUZgTCXzbGy3RZYijEl5byTf7aHJUJz4xsqub5Lw+OBsbvxJyHECzqrwA3kNym/t/ywPX3wiYRxQ18R+/Uea4knOWJkd3QU5zVALwoZSfhS43b0ZN/f5OERHgw5aGF4gwmu/ny7YsGR3IOrTIFofJx5fx8RIGkFnbt2O+LVVDg6B//7RSPxwy+fcu/UTnwquPU5PSXsY+YyGg8UsCKa/0Ef/FbThlJIBTPYcdSLvheg+mHinP6GL+nYyKdqw6p57WQUQKJYWqMZUx4ZvzISEiGyeJBmo1jqrMP107DMcONZAjrvD7+t5taPyR8BbPWrrYXLbkh71C8Pecqv3MGIF9Z1b3ZmbmQ7hYYk3szCzxf2NwgQZknPamHYI/vJGYFZp+2Dkg1MpQNGeGxoqGRJKv1qwZaKr+UU8tXhQCQ2qKFJnxoJ/3PRxkBcQsk4+XUqL8MY2LyVk5S7AzuX8yl6GOVjnk4pC5qasZo6/OcXfLYHFSLkqkTn7NcoV1VShKA9T8bj+stMT6fCIctvgJ4KbtOPgY6qRKFzDvptofPNgnIWyo+zNutzako2jGXTp/SNmCAgTrn6mVDRYDlhiKsvL3I0R4o2d7PLO3uz9Nd3X3jVtanIf16TwcHcdSleutfLiYCeiH+LwDJSKTBlceIqutlUO3QPpXzzxy9c6XdQWS9oac3+iK/qYKm6CrF/tPiIFF/Pg5H+aw4WfLyaycCEHIU2/TFSni+22YZIzJYDM+91zQZQUeTicBi1zkRba1oCQiQRt+AbKYvob9qQbrsl4Ak2vjJST93VckR2KjVHxf3PTRjCc8rSYN0XuzwsdWW4aulODCW6paZiDuX1opvbC81kpK14L4YCMxIso
 dZbBBxoq
 BLEm8jUpxBFH3pBEZLQvaigzQ8fO8dnBF94V36hAwfPkeF53j9ouQtYPHQc/PKnUk6eUFO1k36JxC1zZSrKEiVf69EoEYaqrOuX8u2T2NRVMbGsL0rKW4tRdZKpiluiS9OLlhwvjohg1thhciBjZ2jV2ZwJKn9H3ljcg37jC3L365uXIg5B4TpV3mpvZn/UAyvznA8sMFlM/2mDqrE7m9vk+bTnzi2dQVAJ8K6fyNN7/Ri8xs1po69lCmqC575GoIvzKAb56jx070phNXx4Pu6OYJ2gguxq9gh+EkF1yBjVLYg8E6+PcWsMy1uS2FqDoM5wYd7laWKuqmYzDrD4gHmRG/2RoSoBMonWocTNKuJduuTJdnOjuCh0Wqa60kWq7b6WaZUr83VxCADxsFZNEoY8lZTJ5QDd3rRnQ5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>
Message-ID: <20260429120213.G7GVxK8Y_kKPGJqulsjeg97mAf0QxwPYOjJ-wWpcEKw@z>

Use spinlock_irqsave zone lock guard in __offline_isolated_pages() to
replace the explicit lock/unlock pattern with automatic scope-based
cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/page_alloc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 27bd316e4453..8cfec846203f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7358,7 +7358,7 @@ void zone_pcp_reset(struct zone *zone)
 unsigned long __offline_isolated_pages(unsigned long start_pfn,
 		unsigned long end_pfn)
 {
-	unsigned long already_offline = 0, flags;
+	unsigned long already_offline = 0;
 	unsigned long pfn = start_pfn;
 	struct page *page;
 	struct zone *zone;
@@ -7366,7 +7366,7 @@ unsigned long __offline_isolated_pages(unsigned long start_pfn,
 
 	offline_mem_sections(pfn, end_pfn);
 	zone = page_zone(pfn_to_page(pfn));
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 	while (pfn < end_pfn) {
 		page = pfn_to_page(pfn);
 		/*
@@ -7396,7 +7396,6 @@ unsigned long __offline_isolated_pages(unsigned long start_pfn,
 		del_page_from_free_list(page, zone, order, MIGRATE_ISOLATE);
 		pfn += (1 << order);
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
 
 	return end_pfn - start_pfn - already_offline;
 }
-- 
2.52.0


