Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A910C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B6176B00A5; Mon, 27 Jul 2026 08:39:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38EFF6B00A7; Mon, 27 Jul 2026 08:39:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CE206B00AA; Mon, 27 Jul 2026 08:39:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B5536B00A5
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:39:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 956C4406E9
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:39:02 +0000 (UTC)
X-FDA: 85034511324.27.F88B26B
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf04.hostedemail.com (Postfix) with ESMTP id B1D6940008
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:39:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="i/ZIT7K9";
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785155940;
	b=NRKU7sJbs/IpjGAHll5l5dvvVS2B6PzSZpCzGtUudR7cw87vSmAWUtGRWqjiMQKDyReu9F
	pIW4ZwMDkd0Gyd5mU6HkRGyu7anYll4wNX2uNttQYvClt004g4rHYtdMcUDJLuE6sVCRbd
	U0sdmFWpIMLKCY1pitPP8Jqrl5jctbM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="i/ZIT7K9";
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785155940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8bUTrgrk6ymdv5ZLPK/ZcA1DiVAjVvBeifaSs352+I=;
	b=a9UqYXVkwugck8Y0A40otlFQnIglJ4pEDsHcnjrce7aIgwWUHjobtaRxmbxyD1Y7KvOgML
	dk4etj6veNW+6gFGDK9SR0xuDtKqLHfTAwLACfPK0vQJfLbTT9zWXoCo6jBjqyAxwThUNi
	9WBlf6FVmnlvxmGZwyUW1V77iDVGW8k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785155936; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=j8bUTrgrk6ymdv5ZLPK/ZcA1DiVAjVvBeifaSs352+I=;
 b=i/ZIT7K9AWdM6NeLqH7D243on8VjeaTkhMhJlFVCd3M3r+aHjOc5duwvNUuCmUVfakk4J7
 go0GaRFm6ZcNbE35tZEn9nEvVGzRz/dVfVHLExi2rn+UoPC774QCe0q1QR2uGzZzbViyaO
 CWX2NnmVddorxDapYQEwLtydu+zaJK28RG+LMMXNhElE5zc/HqQNTrOa+DTsgu5IjOXvbL
 O+2uxJyOQST0nenvI07DbKodnsiozggft2oJL0yVOiiWC1pdgqJ1UBgFa+yYL5/LHd3WZD
 sbLpmy/ZaV1hTZP34pt6Puj1YFnE6IfyfxldMMcQN0sVDTsbkb4o4ssB9sDXCg==
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Subject: [PATCH v8 9/9] mm: always use the zone-device template init path
References: <20260727123429.5673-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260727123429.5673-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a67515e+59bc8d+kvack.org+lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Mon, 27 Jul 2026 20:34:29 +0800
Message-Id: <20260727123429.5673-10-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Stat-Signature: owesoues88gym6nysuzn7a8o96iuno5f
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B1D6940008
X-Rspam-User: 
X-HE-Tag: 1785155940-258093
X-HE-Meta: U2FsdGVkX19lYLZUDjw1pRFajsyz5uZsvXgzCrG8y6rssPSnCZb9uZ9IzkvZ3Z2wz1In0EUSu15bj3TkniAsD5tm7tG2r3iXsyih1cLutI1hf6KNLHHVV9yLyM4ay6NhiaCj8mPeq2bpt9+ZyGTkV8XzvBV0CKV8cQtbl+qdUp+8sjbNgK8rhuFqLafFbqlXzuaqmoTgH+Rl23GK0EaiVwXRn3YNcful1VgpaoOSaoRsHiDqFwlle1VeXU/6U6NduiBSSnXTMXQXWR0QzAOhlAG4GoxMHHlwPxUNvRz3I/493xtWGIfZoUmsXZAMWK2vch9ob7zGxCMcCSpY768JzCGRktR/DGv/Z1TKLlheO1CCRcZSVgURxgKzeon/JjRTa1Lgm0Lr3h+q5+1lxw0ezQ/e44BNKCwZUxdZWkPsE8c/2SEtu2JM9WswfjrUF4UA0dvgA2fjKQ86Ae4GSmUs66L+wIaecJaWmQM5rDI7CbuXquv21RMlIKiclz8V4K2gwvUFefbYvwXG3vHQEsXrgJUtKP7lsfhM7YYLACMihzYjLixfvX86roq6pOih6uk7FG1V+hKSwxNtDLMDObh5jrFui7bO3cK9fLk4vstyEiBpRYyE9Yby+uNo6xz7QJLrKHN2cFSJDgOBhTmiXSJEbfGE6dADVXdQeztwv/n+mFdUyNi5WLdvz+FZ6m9IksAITKK1rclKDgCn+f/pE1RX0Or6KmWJGUEmt135nE3dZXKoXMdmnXerXwM40fyHsEFNuMe4I70WIq2Dk02oIDi6yJPrBFXNESjNRR9VBGk2P91i58fbKwXFVdN+ROhGIplgrwwnOWa32kqzHcwtp+kmeAWRI4lU7llGxH2kHXUItOW5scwBu6mRP3hxKE0rXVTmXROFj+ezGEiwknRnsyujSeKeo8Ss1m0dXSwygyloTyhYfJoc3cjRNoSKNkTPJfcuro2WT4Z0YwWbRtdAji8
 hfgNU0gE
 7SHA2VsLuaKPxpouBQLCymHyUVaud0UjY8i5apjrGiIR8Y54sRrhH154tCElnFxUan+VU0uMaxti3dLYKUcIiH4MMR0ucI3A8N2tzVS7nNfk3nzSu7yXKj1tApKPJoLVZZIgcF6gy/GrOq+c8XTnWxFn85XHXgG7Xkw26OQLS8fbEEE1Df+/MaugtgzP1EXdKbWkGmd2fOtqoT2vacha1jgQh7L+nfFbo+deBNSpPl3YdmbKxzKokZ+YTRTWC219/JEZBaKPBY+/33McuOacZ/5vakBDAmkmVl76uc39LxdtkGSzzmV5oH3/Q/GvHBXNI3wgHfJrCWxXO+vQDYRzgstpmjh1UOMq5bX+MIUUd8TCGDXnda843pRvUpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The template path still has a local opt-out predicate for the
page_ref_set tracepoint and keeps a non-template fallback path. This
makes the code more complex without a strong reason to keep the
separate path.

Use the template path unconditionally after the corresponding seed page
has been initialized: the first head page seeds the head template, and
the first tail page in each compound range seeds the tail template.

This keeps the first-page seeding logic unchanged, but removes the extra
non-template fallback from the main loops.

This also means sanitized builds no longer force this path back to the
per-page initialization stores, and an enabled page_ref_set tracepoint
will no longer observe every ZONE_DEVICE initialization-time refcount
assignment. That tradeoff is intentional: this code is still initializing
struct pages before they are handed out, and keeping those local debug
special cases would preserve a separate initialization-only path while
making the common code more complex.

Suggested-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 36 ++++--------------------------------
 1 file changed, 4 insertions(+), 32 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 2a723a518f41..ae42a1311e1d 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1065,25 +1065,6 @@ static void __ref zone_device_page_init_slow(struct page *page,
 		set_page_count(page, 0);
 }
 
-static inline bool zone_device_page_init_optimization_enabled(void)
-{
-	/*
-	 * Keep sanitized builds on the slow path so their stores stay
-	 * instrumented.
-	 */
-	if (IS_ENABLED(CONFIG_KASAN) || IS_ENABLED(CONFIG_KMSAN))
-		return false;
-
-	/*
-	 * The template fast path copies a preinitialized struct page image.
-	 * Skip it when the page_ref_set tracepoint is enabled.
-	 */
-	if (page_ref_tracepoint_active(page_ref_set))
-		return false;
-
-	return true;
-}
-
 static inline void zone_device_tail_page_init(struct page *page,
 		unsigned long pfn, unsigned long zone_idx, int nid,
 		struct dev_pagemap *pgmap, const struct page *head,
@@ -1151,8 +1132,7 @@ static void __ref memmap_init_compound(struct page *head,
 				       unsigned long head_pfn,
 				       unsigned long zone_idx, int nid,
 				       struct dev_pagemap *pgmap,
-				       unsigned long nr_pages,
-				       bool use_template)
+				       unsigned long nr_pages)
 {
 	unsigned long pfn, end_pfn = head_pfn + nr_pages;
 	unsigned int order = pgmap->vmemmap_shift;
@@ -1169,10 +1149,7 @@ static void __ref memmap_init_compound(struct page *head,
 	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
-		if (!use_template) {
-			zone_device_tail_page_init(page, pfn, zone_idx, nid,
-						   pgmap, head, order);
-		} else if (pfn == head_pfn + 1) {
+		if (pfn == head_pfn + 1) {
 			/*
 			 * All tails of the same compound page share the
 			 * state established by prep_compound_tail(). Reuse
@@ -1197,7 +1174,6 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				   unsigned long nr_pages,
 				   struct dev_pagemap *pgmap)
 {
-	bool use_template = zone_device_page_init_optimization_enabled();
 	unsigned long pfn, end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
@@ -1223,10 +1199,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		struct page *page = pfn_to_page(pfn);
 
-		if (!use_template) {
-			zone_device_page_init_slow(page, pfn, zone_idx,
-						   nid, pgmap);
-		} else if (pfn == start_pfn) {
+		if (pfn == start_pfn) {
 			/*
 			 * Seed the reusable head-page template from the
 			 * first real struct page, because the existing
@@ -1249,8 +1222,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(pfn, altmap, pgmap),
-				     use_template);
+				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
-- 
2.20.1

