Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09003C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:33:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DD226B00B7; Mon, 20 Jul 2026 05:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B50C6B00B9; Mon, 20 Jul 2026 05:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F34726B00BA; Mon, 20 Jul 2026 05:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF3006B00B7
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:33:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49070C077E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:33:02 +0000 (UTC)
X-FDA: 85008641004.03.218CED9
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 71FCF2000D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:33:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JQIorsCK;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=230YrAdIWpow2s7v8XUtsXYdB2VvrVwtnmY6omTo098=;
	b=1x55zhmgxS/B48gKFsqyKXk3hgb+a7gVpcLpd9oy3Z9GwecgkMVrsqvZGPiRPGK6s1ze4J
	wtGBLyCGG0hT9jkTGd/OqITyd8BMjvFLG1xQkU1IVUAgmG9tttCPES02j5GbC33l+uAlBD
	51tmQqxaor3zr5ER1iEnqHQHiaxMB/4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JQIorsCK;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539980;
	b=RDsaCYCTPetwldXBW7m6FzidcSIROngp0LNLGL8Ukn0Ns9RnEq6qzd3T5npX5LH9ugsnY5
	3bSfl2UwmtKVVUdBFPIuPiEsuIgKlLFsB/vBiJthxHQgV+WjqS1R6myuiXzRUOXP1wWtQT
	gXaUXTZuUwjaVh7Fq/u3kuGlqSGw9x0=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cace91f112so100152235ad.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784539979; x=1785144779; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=230YrAdIWpow2s7v8XUtsXYdB2VvrVwtnmY6omTo098=;
        b=JQIorsCKxIYFWcjS3Hxqi7GI2RMdu/S7adVjgnIZM0Li70fTRen/6Vou9tZFg0DjQp
         fA27Juc4vEVk7GoTnBlPc3K65lYl4NCWCSPn7tgzpHregosBtG6Tbv3cHiuSEbIaXcam
         J5eiwuht2FrVy98pVllMSQhG1WBmrsLiR5tSgR/LVP7UDnCJ+J5aXXcImBFEb7f0qRTz
         8ye8RNgOZ9BxhHfqXnE551EiJ3rxXdSvXmSBUa+d8tdIBv1n5nzrrpBmxUBkOxjuZR2L
         oK6jDdj9wRvyEC8FQXipnJUfX9N6Taa9oi0T5ywddF1TLc5lGjB0hn7J77BkW5TQOK/H
         dfnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539979; x=1785144779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=230YrAdIWpow2s7v8XUtsXYdB2VvrVwtnmY6omTo098=;
        b=C5kHgtGw18KEttp5xxmZqe9/s+JrYrFZJJQxZPI9RIUkoF0RjKbFutLayH0jjHEFse
         9Eeckdw/da2lcQbMIHQ2WclsB0ynpXK42KC4k+xVx0AAe8SLrRkOacyFrHUWqxJA82k2
         urx3rf+PV9L8l3hwdPXaNXYFwhuV6x+Fbkuj/sUWSjavKgT2p9Gh4diY2yZKid7pxIn0
         OdO4Ab3XW2lIhNLSaHSd1VNeTUD8L0Z5pFD/eVjWSS1YiFRQ5CSGVSORITE914pifnqR
         jw5HHdBW72/EV9Z9r9QEz+Q6TJ8UTXJ7HWZajluj5suU78XKJ+RvLgnF7iNl4h+YtrB4
         rtKA==
X-Forwarded-Encrypted: i=1; AHgh+RpR7w3otL06ijIwxPmHqNAVrKRlOv/7sxocSBsc2cYz3dhysza2Henf8UQLJ59fqQUj4mn2j91gkw==@kvack.org
X-Gm-Message-State: AOJu0YwGMhFUfdJKSIJSmUAKDm0hd6Y9Ma3P7tQ9Gt05LZYK/3ilxjUn
	eF0Eite6NdpqYWOezglUqZIa3ddvZ048iitiYuYASn+gfL3r8MOgYHGyn58PYj+iRPU=
X-Gm-Gg: AR+sD10F+/VlHN1hUT5IEw9pGRX6aFVYJC7/ZHsIzAMhtNIIS2xZw/Kg9xRLgrxnpLy
	3SAnQgLBGOtPuxKXoD8OjJcnwznJ2BEOWEqx+tmsxXqA+d2P4fHNiWALlab9K4FlKn1wYm+6dEz
	6dT8Yk72oA4HaEcjTXx6Duta4AiXoXQICQdSPX4TyNYG+04gIGhKbgkF2++KJYfy8C8V/EE8AcL
	I3xBXSoRTyABDEcjzNDFEUCCh150LbMFCZgooqATA/G6cfWCaYvGeGurJEjJ/B4lVWDalibTujw
	bfcQGQdkxleOtBmSYODMafg0vByE71mQ2zbLJG1+7yJVbDcbhtmtxyH6Fb/1ZopFoUPSh3kLuEc
	y02GsPPQIZScEn8HmKpOhoVcZOLsIUADVVpMIAah7p5ifB7XLV++RExsiwfEwzGQqFRRasoRiyc
	7lCXTiEwE1h14u0ro9hj2l5JmkAWUIoVo9cQ==
X-Received: by 2002:a17:902:f70d:b0:2c6:9f6a:9f6f with SMTP id d9443c01a7336-2cf349b8d41mr140942625ad.28.1784539979176;
        Mon, 20 Jul 2026 02:32:59 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347a7c9fsm53136455ad.84.2026.07.20.02.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:32:58 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v2 15/17] mm/hugetlb: remove HUGE_BOOTMEM_CMA
Date: Mon, 20 Jul 2026 17:31:25 +0800
Message-ID: <20260720093127.540540-16-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720093127.540540-1-songmuchun@bytedance.com>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 71FCF2000D
X-Stat-Signature: phqbfxzes98pgu9a7dzkgsoti5hya7no
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784539980-483615
X-HE-Meta: U2FsdGVkX18m4fQOKATMkfgiEVhqjPp04ql6pZ8UJv49bySrM3aIVQpIMra9o/sqs/TWKPK8R4wpcNs46UFaTTHcw1XBaHTIsqy/EH5LvQK2RZw9M8yH50uUEGB782d6nCGSmTWVb26xT+UKC3ZgUrBvMUMFqW8SdkNwEbLsRujiAi3u9tNHdtFyAQ5e1iP0F0kPcsqSD/O79rKuZ7CrBWvhnthkCQj04+jjCqD36luU+6NLIGSp6PhtXbB/S32dXDDQ+LOqWt3oJumpomAR2R0JPJv93WrOOn0LwbEoLmCpUolpHLEpa1a8a2k7AFxoKtpWJbtnDsEy/niCOcfrpfSE9J0e/Og07ii0p5pc8Qij27GRVzl8c8N14/vVZKFX/+wEjJSe4637nIUxlTpshjABjTbw7hzBEdXCgM8QoMyJtjKFb71csqWMBZxXqjCszxyb/ORTura44WIq6N2GB0snW/0Ujrw1/Po0Sjyo+FoWV0CHvL08+PVRModRilsgozmDt3IMgvn0Q6v8/HaQlOu7kaLjkDGz1DkXfpIsNnt1cvHmuqfAgKAHgpTbkBQgzbC8Q0j/iXtu7GxORZwdSJFboiGP8Wi9hE3pqCakWKtpawX19qjKa5d+gKATl7RMqEo47h95TSJk18RKYa/T76c+QUmQSrWguH3gjFQWAMS23OX0uyFC8RCSZJ644LZcA3vVjOfzrqkIw4TCTTiflihKbwPiq76/vtwyp0S2oazc5275Ej+jrJtAitmZk9ZlKPdnoYM+zlEjlB7d2PM7SNNEpTWiwjUpTJUL+sRhafWeZ9slZCIA/DFyNeJR4kwgNt6op6xlezrVtpfw7vF+ofTzyCjPMWUITtkbIVNY2JNrC2kFBoOAMcL+nkEWFZ7bcqrwALheffPmxEo0vHPWIX04gguODTkPYBRFi7vEFGhLQO7xhIJP6I2p6u+QkUrymlqKqDRoYJZAKmyrbxn
 lFe6BuJg
 vXE7/Ny7EZQ+OJ1WnBkrY8U+v5dfK78Vp2cuYdUyApCGgpUdczw3/5N+QEUIsvHPIslx99JzMGJyC0vKHJCuDI89uvt8y0IVZ2RkMted8DOHTfLRldWFSjrsEEk0qRaWBj97m3rr3+w7dPaj7XDKJ5ScwvpEf1tlDT7vxY7xqEYq+dQEsJWrXY07WgIV7/NKLdQNhPJ8T34G+BdM8O6FUVbTTk67GSPnZFV+4hF2o4oUoSNTQxkQJWIJd2jyIVqRSyX8M/G0rZzFaTpKYnUQbMFZ4g8q/Z3sHn7lhQl1Xxs9w4Uc5XHMZZGhLsCeRmdBF63JQBBf6mBUxQa+zrytH/RoNtuEnHILbARuBFC21sU9OkR3FbVUkSrEuSXaxz76hPhbWzIUf3xu74bE4XN0qZMZr/wgLFHPyldC1AIWo9IsGqLbQb2dUbNC7ynJt7Iirp0HUT4G1BhYfeTg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track early CMA hugetlb pages from the hstate instead of storing a
redundant bootmem flag. This removes the unused helper and keeps the
bootmem metadata minimal.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/hugetlb.h |  1 -
 mm/hugetlb.c            | 14 ++++----------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 3559041a5a57..255a258f11d1 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -676,7 +676,6 @@ struct hstate {
 };
 
 #define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
-#define HUGE_BOOTMEM_CMA		BIT(1)
 
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c03c5c805cd7..d0c726845fb9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3134,7 +3134,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	 */
 	INIT_LIST_HEAD(&m->list);
 	m->hstate = h;
-	m->flags = hugetlb_early_cma(h) ? HUGE_BOOTMEM_CMA : 0;
+	m->flags = 0;
 
 	/* CMA pages: zone-crossing is validated in hugetlb_cma_reserve(). */
 	if (!hugetlb_early_cma(h) &&
@@ -3210,11 +3210,6 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 	prep_compound_head(&folio->page, huge_page_order(h));
 }
 
-static bool __init hugetlb_bootmem_page_earlycma(struct huge_bootmem_page *m)
-{
-	return m->flags & HUGE_BOOTMEM_CMA;
-}
-
 /*
  * memblock-allocated pageblocks might not have the migrate type set
  * if marked with the 'noinit' flag. Set it to the default (MIGRATE_MOVABLE)
@@ -3305,9 +3300,6 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 			folio_set_hugetlb_vmemmap_optimized(folio);
 		section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
 
-		if (hugetlb_bootmem_page_earlycma(m))
-			folio_set_hugetlb_cma(folio);
-
 		list_add(&folio->lru, &folio_list);
 
 		/*
@@ -3318,7 +3310,9 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		 * For CMA pages, this is done in init_cma_pageblock
 		 * (via hugetlb_bootmem_init_migratetype), so skip it here.
 		 */
-		if (!folio_test_hugetlb_cma(folio))
+		if (hugetlb_early_cma(h))
+			folio_set_hugetlb_cma(folio);
+		else
 			adjust_managed_page_count(page, pages_per_huge_page(h));
 		cond_resched();
 	}
-- 
2.54.0


