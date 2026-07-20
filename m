Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65EF2C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BDE76B00B7; Mon, 20 Jul 2026 08:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6955C6B00B8; Mon, 20 Jul 2026 08:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ABBE6B00B9; Mon, 20 Jul 2026 08:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3435D6B00B7
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:08:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8AECA014A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:08:42 +0000 (UTC)
X-FDA: 85009033284.09.F100ADC
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf19.hostedemail.com (Postfix) with ESMTP id DB3A81A0006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:08:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Y3ADUwL8;
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784549320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8bUTrgrk6ymdv5ZLPK/ZcA1DiVAjVvBeifaSs352+I=;
	b=f0V3PCYOqMR9cdOEY0sPmGk0luIOin83ayou3kLAge6REdIo0orCSOijNv73IepOmfA6Ah
	LVHS8Wf5ZkvECE/YAyvTjCJYLTcNVQzjF8RuYVtGvR9vOw+2ZEW4IJXjgNbonbaOa6PsXp
	qt5qUKtXe5oUjRZaNBKZ6W9hx40c2WI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Y3ADUwL8;
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784549320;
	b=THFYjXNELwXiHQAt37cbU8TE4wTtnwUdaMY684O7raKeoAdTKKBMqffD4LjbG0DGqP31+3
	PWIrKUblpm6zNFpdicvLh49SHQUIfAJaKpiftjFwh14FcggXWMZzl/1uHibUKs2XcQEOhf
	NM5hF8IpDEs1sNbfhkzkkEk9ZCWKsxU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784549316; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=j8bUTrgrk6ymdv5ZLPK/ZcA1DiVAjVvBeifaSs352+I=;
 b=Y3ADUwL88UciMimN1WEiiFPPwgiVjrR2a0x2Eot/LtPBCXNdVcXDS3VBhUk/CFGzHOKs31
 98vng044HT5FYxQThZvPtq7b3O981oiTiERtxdrogTEtn/cPcFr31izfOCBUTDDkHEssvD
 TWYGbzgZ2i/W4tcI3zKo/9mFl8sdlEKLwab+kVPUtWKhCh3Xw68bma7N1EBsR1yEsoHxa7
 juLhiNqsywhrNiH1bjMi2naKzdBUqNOC90rIcDH0ajpPANuZJnFYe/JRq8SQOPRkyBIfrw
 3TSYvNJFg84seXQZXvXg9LFGg+jC9qP1d5S9k7Rg5VhDgBQHcn11ddbugSoPrg==
In-Reply-To: <20260720120259.1545-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a5e0fc2+5e5b76+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH v7 9/9] mm: always use the zone-device template init path
Message-Id: <20260720120259.1545-11-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>, <muchun.song@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
References: <20260720120259.1545-1-lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Date: Mon, 20 Jul 2026 20:02:59 +0800
X-Rspam-User: 
X-Rspamd-Queue-Id: DB3A81A0006
X-Rspamd-Server: rspam01
X-Stat-Signature: mhw85juhczr9kqmsdhz1p4yra6aptn8t
X-HE-Tag: 1784549320-640000
X-HE-Meta: U2FsdGVkX183wj9kxoiBXIU0RbQvGhuvrP4aKMM1Liq86aHq3J1rWT45eox586czD7+6F4smCbzJNcoA0ZrGTo5GOHOcmVBMHanrM9sk/RB/FxQQHI3z3Wg9lc1TzHOOGreutxJsHT0cOBVZ1iO5HRt8qz1tXb/OB7kdLIDC7rfTVQ33ElZvvjnss2vOQLKb7p3N1hdHqQFr0uSLfS6ZjJxW2Jx2w7xBSl1E4xo1vKEDGOGiEeKJmMfFUmFBRdYcVzsTCZ0NcDNF3/8/OikwYvcnexKChGV4C/9hEYCF/bEAsgM9coFBfLwLKwgnRJEiSNONk8dK0tg5EJM/RwIeHi9ZrrixY2/p+LnyuUrn2oJ68z4ml7Ofj0U/3/d7/ooXJbV+po+zbwLmWw7yVJMBsgSx0Rxbws8pjpwiUDyIu7nGhmchCVaHOvrDeB4HLuamnJGu67+/2AXquGrQ9o4yR90TorxoEgUv9URP4HjjesAaUbd4cznmU+JLcEx2kKgRAJHNWvBePnC7BztDM2erA67tn5DC1QRpdxOWaA+FwBjPmsCxYL3f+xmhDYjQUlncXmzx02eXZzGcWUs6tf1vRsMY3Sf3MJH3hQ3GSV3OEZdTo2gcIHe7CjEHweNhelPbAQiAbTdvlNu02vJ8E52SDZRz925K9sAN1baloau1VBFmWy9SCfX059Iw76HEQXiFzm1z6ENypHC9wEAH39I9D5Mv4Pyo/jAqUZ4a3OrEMhe9GOICX3YEaUo0e3G3uCHnF1SjWvlnO+PkvLRRZjnAb0eXfWuoMnCijMTUaU+j3eE+8a69TvOywEiD7OyXfUgcCbuMsiPI7K+2sl9z2dHsGk96hsPoGt1A9IU24JTm3YwF+MidUYmNMXqkXQQofbh1E5sP7uZSzv4NrgjHTzhtUGPtpnBpZ3kFGVvswV9FZfyj8tJCS3kRhqN0S0YCT34jJ28Y2VkACerXz9CyEmv
 pJOA2iaY
 Pf5EHEAQWJspmM2riqCAGbgJyRsvYhG3lQ2+s9q3KmihvKDsIjnQ6UGkIz+XUXQDpLM2yiIRoxHMdG1YqGxKwH7HkbzG9jvoP4HfcbOxTcoUpcOKI9odRA3WVN87P4yG7eKBbAGm9yVffooZN7KIO3x/jieh60xjqjDQXRMgmgXaE8rnVNjVRK9YJK2BkJ4/WzItwAk2SVT/NW82A07Nu81WI4cGI4aePaYk8rIIfl7gp6+Q0+mXQ9yFzLSd3zv61pqNR
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

