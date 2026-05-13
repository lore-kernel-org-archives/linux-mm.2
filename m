Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35F03CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 12:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E75356B0095; Wed, 13 May 2026 08:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4CAD6B0096; Wed, 13 May 2026 08:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13566B0098; Wed, 13 May 2026 08:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C00C16B0095
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:35:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C77B160609
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:35:23 +0000 (UTC)
X-FDA: 84762342126.21.BF7E187
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf27.hostedemail.com (Postfix) with ESMTP id C793E40006
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:35:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aer0yHNE;
	spf=pass (imf27.hostedemail.com: domain of 3B3AEaggKCFA1su24s5ty66y3w.u64305CF-442Dsu2.69y@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3B3AEaggKCFA1su24s5ty66y3w.u64305CF-442Dsu2.69y@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778675721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQev7kNyu1JquEWKDjbbV4w/SlArzFcQsccQoFbUKmI=;
	b=JCM6ewtW9dg2SP2hbpZqI6y30r4lTHQ4mzQ+dtQZLBkQyDWmquNyBr8HyRXKP39jIAwoyO
	Z1lZ8j02wRLiq6XSqNfxOv3hCPLD2BQpmCUVw3VR1nnr1Ur4/hmTNXxquT0olOtnYQjLaX
	dKzh6oouQzck1yfRPerW95S6FVwan2A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778675721; a=rsa-sha256;
	cv=none;
	b=DvdlotfOEhTT6chU7eLGwvHL77vkGljyv1f6XknYlpmH9dg859/8zHzYEXBLVyEwUcL+cJ
	VjRZUc0gzwAx2PvPARnpDYY/ZU8bCUTWF/vC7dE+tSTDs6vJgIHejz1CBS5gFltIBL4oG1
	mkrMtxPE3sT4xE3empyyiJ3p/2FyobI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aer0yHNE;
	spf=pass (imf27.hostedemail.com: domain of 3B3AEaggKCFA1su24s5ty66y3w.u64305CF-442Dsu2.69y@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3B3AEaggKCFA1su24s5ty66y3w.u64305CF-442Dsu2.69y@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-44a122a5128so5129966f8f.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 05:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778675720; x=1779280520; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aQev7kNyu1JquEWKDjbbV4w/SlArzFcQsccQoFbUKmI=;
        b=aer0yHNEd5xSsISQnLGEwAMaV2ODsK7o/z1bF0Xi2wpWCG7t5/gjSFuKn97PZrpxm8
         oETLYCo+tTXZQe9j4vmyMYfUp4/weLy9LQqXHJksbXH2rCtMiBxnH7jDfKfKBD+Pxdy4
         MKLFWwcn3lqttpblnyaCYeRw498M+a67Isq+K1lb7XLzinjilxbR+S0x4feKhZjFS8Qk
         5HzuFw6PwU7rlSDyLgVTwx3IONDV5gTMLieFPmuttaBtwlzch4xcDmk8mkv5RoOsJJni
         bZ0uhlMHD8JakEDvznKco59SJETr0SEBLvfH74RDKHsZsT8mmuxoxi2lnEpEy0iHRFVz
         YG9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778675720; x=1779280520;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aQev7kNyu1JquEWKDjbbV4w/SlArzFcQsccQoFbUKmI=;
        b=mNcsohUfRpRvWy38tjejH8EW8peuPZ2igpBnSn424yIPK1UTbHMGhX0eFSNtCKQF15
         8c0Y3dOqc7j1yLMr8qJ7eFRNDQDW8JmsEnWLfWqoWW9qOYzwXD+n6RCSSWqvnCC/G7ha
         D9yVcCzzD6UkEZwqVrZ6hHBVBTCvY3QpjpDF6dPCfrjIk8TyN+uMB6wHFjjaOejHdg8n
         4eZpZDwh3538cliLbc+uyU3nGIP96gOpikvHicRCQ1a7HavaLwZU55JgJ4ozrX+fiNyJ
         w6EqcSlBChwJ51Zf0Zao6h6Pn9v87d6vEoP7/eXykjUpIhQKUWzmP9QlDVZrF5Z7raf3
         lswQ==
X-Gm-Message-State: AOJu0Yx8LA1jp53B9FVL3XL5u4d4JZVJxF+v7BtEsUV03g3Ed5qEzeuk
	KzafTz1AxytCN1t9pLZjW8bCizGYFbRzW9RFlUo62eByCbpHiZdORedubGtFoup/H4Q1ssK0yFU
	0At6FQtImCZUbcA==
X-Received: from wruh9.prod.google.com ([2002:a5d:6889:0:b0:444:bd72:fec6])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:144c:b0:44b:cd2f:a3c8 with SMTP id ffacd0b85a97d-45c580ce3abmr4261824f8f.4.1778675719914;
 Wed, 13 May 2026 05:35:19 -0700 (PDT)
Date: Wed, 13 May 2026 12:35:16 +0000
In-Reply-To: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
Mime-Version: 1.0
References: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20260513-page_alloc-unmapped-prep-v1-4-dacdf5402be8@google.com>
Subject: [PATCH 4/4] mm/page_alloc: remove ifdefs from pindex helpers
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C793E40006
X-Rspam-User: 
X-Stat-Signature: 3ycpbqf5udm7gh4xoc8oksywts5u5op8
X-HE-Tag: 1778675721-81888
X-HE-Meta: U2FsdGVkX18OhTWqnBoq7kmHSIlLhbItJvIGq58Fjuh7+nhlcCHMMX+YQstrF4VaxyC7SCt3HxFQeKIGgMwuYdRZuvZF41LQyOY5u6zWXfj83U7RAq099K8xgiY4kLQHMIz+M2hxWkb7qqIqs/uFyz9G/cGtKmqAZlQam45Rb+Y1MMknIYbfxfBlU+g1xwxT9y7IxFbgoTRNEaktKrNWdlXA6kgJiFpiAwHFSpFlBvfVstYBxVf9KyHwqiQuOqWDKpZu7RfJQxMxldMAOzRlQAydciUPkf6ZmucyHkXXU1bjCw3bLXIsP+c1DWcT5BRSP4n8cPr/h/CY9O1awXAg+OTPB0qMfXCvFGwOq3ngouOoJYnrYlrFoozlZFsnYFilf5iLqrXHXiyivmsZPOqeoETQgTilNhEUyYJmqdPv/A49yNgzDr7eUSvpGQyqfOnJklDwCmAj/FBBMr6nJSjwcaMBQrCH3BclXWpc/+7Ag2Dcpop+IoFufVZ+AxMCDiH6dX4kpffsn6p4ylf/dLMHmbH2pGPz9PZXRH1jJlVrIlw+5j9fRujHe4i0EVn0N3lmJGhtwe9+0LDk0C/dS/NgBScowIdRC/3tMQ4qeNWz1qXLK7YYchoq2pujrBqlpAa58Jk+i2eVRKEtTOvu9YB5hUWLwxm5fhA12VBBQSJhFseYh9NuzxK0AxutPcrNrmT9dfiKN/tFuDvZWqwizHaKHqbuk0ermaczqiaMYieIsHcnqN7q0yt5JP3e2avx4vGX3Qm0hh8hH4225t76f+oy4wwmasjuEkga/cMDB9qmNxUZrP8YpcP7y/ckfboPE1beZF2Mb5qr+JIzKy4vicvv4b2If9Q8tmJgqym2EAMZ6Pmr3oLC9nvfj3bjiOMTuIx5W/OYrm148tc7rfgwstY91tntiRgCQAa9sdUVkvvp/9+k5rBYo5/aSOV0r98nZ1m1HqCMQeL4tib6Wj9mlQC
 JG7IYWvu
 kSQsucTtCYWAAsSAnb6xETJhlIsEVna8dT58XYcMTK5kz4gZHo14uEbo36CMxU5tO/+nyg1WcLteLEmdOLYU+WtqayP0BUakJW+fN1n7kTCXL6DRNtF/k1hz2AAIM63Nofyw9Z64+CIp17QFRb47XxzT5s3M8si2RhPl5MtMshB03O7JcXhyQ+sg8l4ajkaieg3/hQe3Jo1gKNGQomYv67Tp2ve5VeV5iXYR1TRnDgryclMLYyJmyAJK2iy0k0uYT0W9c4MivwNJbX7XIC3muAaz1ebSsqIBMtfzi0xSDv2dKpqOAJv2cVfcqRvXlINBcnZi7Aw/sdngJCITHxuNcLedeEvb5yhLZB/7NkJu4V+Y892tyrK1AI96gL7G5njBfeBwm3N6u10pMW9AFqfTcsv8kaG8ZKh1yor6wZZm1TmNJpV79dNAzAuLDKEhVLTZSadnQb5+LDi45fq0lvDTHFqqSCI/wdSS5AHfPLKicRxHvofE3LOCd5NjNA46UO+cBNLNzF1plmMNb+Z7T4o1ep+znQ6LYFhEdiZcdyn01JzTVm4cVU82oPaWleyWNSJYfpGLE0cz718OaU571VoPmP2dXyr7E8T5zxoGNBFX//UwTIXIoOfPxUlIdb/6i+DEjB8HHj9YlLjrype1T8ICnrOeJN7PaaDo5iRxM19Rmwk2IEoBTb7tbsQV2urwnE2jDlzO7ZQ5HHPcmuM2duDo8JYWdAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ifdefs are not technically needed here, everything used here is
always defined.

Switching to IS_ENABLED() makes the code a bit less tiresome to read.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5d6144c8860ed10fd641184f389c4953465d5178..2985ad0ab1044bdfda8ccc7aaed2ded19b5ac7ed 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -650,19 +650,17 @@ static void bad_page(struct page *page, const char *reason)
 
 static inline unsigned int order_to_pindex(int migratetype, int order)
 {
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		bool movable = migratetype == MIGRATE_MOVABLE;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	bool movable;
-	if (order > PAGE_ALLOC_COSTLY_ORDER) {
-		VM_BUG_ON(!is_pmd_order(order));
+		if (order > PAGE_ALLOC_COSTLY_ORDER) {
+			VM_BUG_ON(!is_pmd_order(order));
 
-		movable = migratetype == MIGRATE_MOVABLE;
-
-		return NR_LOWORDER_PCP_LISTS + movable;
+			return NR_LOWORDER_PCP_LISTS + movable;
+		}
+	} else {
+		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
 	}
-#else
-	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
-#endif
 
 	return (MIGRATE_PCPTYPES * order) + migratetype;
 }
@@ -671,12 +669,12 @@ static inline int pindex_to_order(unsigned int pindex)
 {
 	int order = pindex / MIGRATE_PCPTYPES;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pindex >= NR_LOWORDER_PCP_LISTS)
-		order = HPAGE_PMD_ORDER;
-#else
-	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
-#endif
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		if (pindex >= NR_LOWORDER_PCP_LISTS)
+			order = HPAGE_PMD_ORDER;
+	} else {
+		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
+	}
 
 	return order;
 }

-- 
2.51.2


