Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D73CB606A336
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=V9eUbce+
Received: by kanga.kvack.org (Postfix)
	id 0629A6B05B8; Thu,  5 Nov 2026 07:07:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00BDD6B05BC; Thu,  5 Nov 2026 07:07:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D136B05BD; Thu,  5 Nov 2026 07:07:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD5E06B05B8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:07:00 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A95B1C4406
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:07:00 +0000 (UTC)
X-FDA: 85400939400.11.1F20A95
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5DDA8C0004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:06:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=V9eUbce+;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793880418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k7v8g50swJ0fV1u98xcgR1RwEaj2esaG3qBT6bQvvME=;
	b=k+FOCA4RJ1UTEnzAQVKeTZ4YvfcNGnpYHuoYfgZvG/CuxbkWfKrMt/LgL3AWmDdxJmFgoF
	D30dAuKS7PTpMDg5Aj3YZN9VL83kFILgs/pyzTB6schy11RlYe8yT4QJ8lgcBvhQJthDHu
	/iw38LS5+Seu1/6yEQH/lsUEKd0DLYg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793880418;
	b=R8HOijSjrasHQxQryu4861qrqmOJTcLNqmh90Xz9g9RkcKEyxD0AkeZrfLKZ8PwhE7htpz
	9+g6yCOs4EJC2AU0m525xJOaR7KcRdici+yi8rQEjPYMSXuI00+UxAy9J7+tBVIzavJPFg
	0jUJLh700PA+jz0CluTRfIkyDLhVVtU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=V9eUbce+;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793880413; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=k7v8g50swJ0fV1u98xcgR1RwEaj2esaG3qBT6bQvvME=;
 b=V9eUbce+GWGPfi9KzFFqtw7/Rb4BLPXSRNxdHLC8SCpF42DTmLIyW3Zydiys8C7oQ+/XOw
 fUO0kDC4jB4vOSRCMphDamIvC2Eujq1rYZDVrzgCWv6hJ+Ar9zCJpzCZkmwCPVrq0t8RUw
 cHLIinZQSdEKUJW1RSZtRCkpKRbvTyBBCHEdLDqfM50gXPv5ebOaRrdwwKdVvp+NyL8QDI
 Ms4+PUDenNlE2h3LERu3WA5DQSU5GiSxO4ylGVvRtL7PpFgNLargTUuwXHXrjtFSy2VnQW
 rzmLzO6bX3H3P3fgwutyS9hN5XgPT+r0zxWwTsDNGpK3PHRqeIDVMJ7bEl4BmQ==
Subject: [PATCH 1/2] mm/mm_init: factor out memmap_init_page_from_template()
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26aec715b+6c1afa+kvack.org+lizhe.67@bytedance.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <rppt@kernel.org>, <apopple@nvidia.com>, 
	<balbirs@nvidia.com>
Date: Thu,  5 Nov 2026 20:06:14 +0800
In-Reply-To: <20261105120615.16817-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Message-Id: <20261105120615.16817-2-lizhe.67@bytedance.com>
References: <20261105120615.16817-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
X-Stat-Signature: oei3e49nb7s439x3mx574dnbi3e5mu94
X-Rspamd-Queue-Id: 5DDA8C0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793880418-427096
X-HE-Meta: U2FsdGVkX18CB5/Gc030frLARk68ERzUv1FYLGs6OOezYrBZYKIRpXj+r/n5XwoWOddvqTZmFv53ari6befXRnyTK6Pe5eWX7H5D9ihAo+PrFIGjeISvHq5KUCCoeCDqVohlzOdVX4NXZ790Ki3BtvPZkVk4XXWk4cK9MoZUck9Q4w/SXjxqZ5IMbO6fSDFaYFGw8NNRndOLktbnYXL5tS5De2ioR5hR9hM2Et2f+9ugTnqbeXdJfgEUmfAHrK7BNYVoTBFp5SDgkjNBrBZBkeitYav5ulk3vcMMfr7bwFbRNO4Eu4BrZ/AagZ6sgCY8AvPQVSE4wP8akhepmBjoMw99sf2PZYJJ3dberTmRKD6hlVSzUBn8YaoexuFXdU1n4grHqSN3Fjf8N30n4Afv+yWaw52pYV2LUKjvJDgR+JKXeiKsbHtisH5Oh6dd0h0PnmFaDaTlV/khZ07XS1k2halXWw2VQolk9GhZ8WWQbeIn59MKodtDg0xV88hH0iYI3YNkbOzV6GTZwd0MFDzWhp+Foqwk7PYbQ7eVxvmdRCwIrrIRSR9au+bxicB6UZhXhS9v1zuyc6o3dyLiWQGeIpj27lcKfgTBWE4Cw1qfuz3lyYbsA/xE2D0UkFytEI1rBWpS7aFx9vUsf7XV1bxIsMDZGZwfCV3oibIS75pjdFqFlHnxA+ZfHQbs+I0a4YkJmcC5j2DKyFXymKKGbGEoOZce+WJssWnUYqSBFNLAAfXGW2esfKh1WtopZcHZhZkvKQC2as/rw/YjAwiNszqfWy5957EBI3N7C3Nwfqfz5XRJCFDJl0LPjv8f6UKg7yB9Uy7s9Ey5oo4Vky1n3kkfZthtp1uYBss+lLHWhe0IkwrHpDJJWBCX3aJJNsOgO/F4zC/0Ovu30hAHjjxk9JSs0cn1fVhTQahvHrvbRnAX9E7gqUbVHAN+9z2g4eXVSfHu/UWxtDL0yEHhUmLB0K1
 UKJ5j21B
 3fIi6NQPsWwI+vWdMOCZZUvDnqx4QAfSujMfaKuqMP+qNyHkH5EIT14Y9MA1naicUDSAdHaQDQJcgcLzhbyqjOcVBh5VV+Cs+/axq9TyU8rxi88EcYRzvE7XJLPM4d1IFURv/WDvkJmzT/wAyJHBjSDT0D5LSaHvwbsfbGu+60r6z7dQGXPeN3dQUPriWSIGET2DHGQ1FzeAE2av+6H7ep1XVRorZjZlhlVFUlloi2oNJEKAuGotxeLU/r/SHaj1DbLm8y7FxoeAS20FuSkfYZdhuL+TvKv9bwWIG9xsMEGA7J0i+CgsK1besuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ZONE_DEVICE memmap initialization already uses a reusable struct page
template when initializing compound tail pages.  The template mostly
contains invariant state, but a few fields still depend on the target
PFN and must be refreshed before copying the template into each
destination struct page.

Factor that operation into memmap_init_page_from_template() so other
boot-time memmap initialization paths can reuse the same helper.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 29 +++++++++++++++--------------
 mm/mm_init.h |  2 ++
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 2a0e782a151d..495e20fbdec0 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -625,6 +625,17 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
 	vmemmap_optimization_verify_zone(page);
 }
 
+void __meminit memmap_init_page_from_template(struct page *page,
+		unsigned long pfn, unsigned long zone, struct page *template)
+{
+	set_page_section_from_pfn(template, pfn);
+#ifdef WANT_PAGE_VIRTUAL
+	if (!is_highmem_idx(zone))
+		set_page_address(template, __va(pfn << PAGE_SHIFT));
+#endif
+	memcpy_nontemporal(page, template, sizeof(*page));
+}
+
 #ifdef CONFIG_NUMA
 /*
  * During memory init memblocks map pfns to nids. The search is expensive and
@@ -1073,17 +1084,6 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	}
 }
 
-static void zone_device_page_init_from_template(struct page *page,
-		unsigned long pfn, struct page *template)
-{
-	set_page_section_from_pfn(template, pfn);
-#ifdef WANT_PAGE_VIRTUAL
-	if (!is_highmem_idx(ZONE_DEVICE))
-		set_page_address(template, __va(pfn << PAGE_SHIFT));
-#endif
-	memcpy_nontemporal(page, template, sizeof(*page));
-}
-
 /*
  * With compound page geometry and when struct pages are stored in ram most
  * tail pages are reused. Consequently, the amount of unique struct pages to
@@ -1136,8 +1136,8 @@ static void __ref memmap_init_compound(struct page *head,
 
 	/* Initialize the remaining tail pages from template. */
 	for (pfn = head_pfn + 2; pfn < end_pfn; pfn++)
-		zone_device_page_init_from_template(pfn_to_page(pfn), pfn,
-						    &template);
+		memmap_init_page_from_template(pfn_to_page(pfn), pfn,
+					       ZONE_DEVICE, &template);
 	prep_compound_head(head, order);
 }
 
@@ -1192,7 +1192,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	for (; pfn < end_pfn; pfn += pfns_per_compound) {
 		page = pfn_to_page(pfn);
 
-		zone_device_page_init_from_template(page, pfn, &template);
+		memmap_init_page_from_template(page, pfn, ZONE_DEVICE,
+					       &template);
 
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
diff --git a/mm/mm_init.h b/mm/mm_init.h
index 0034e37dbabd..22c465122b47 100644
--- a/mm/mm_init.h
+++ b/mm/mm_init.h
@@ -111,5 +111,7 @@ void memblock_free_all(void);
 
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
+void __meminit memmap_init_page_from_template(struct page *page,
+		unsigned long pfn, unsigned long zone, struct page *template);
 
 #endif /* __MM_MM_INIT_H */
-- 
2.20.1

