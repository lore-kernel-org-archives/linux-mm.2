Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 409FB606A890
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=fECuPcZu
Received: by kanga.kvack.org (Postfix)
	id CED2F6B0668; Thu, 12 Nov 2026 22:35:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC4366B066A; Thu, 12 Nov 2026 22:35:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDA936B066B; Thu, 12 Nov 2026 22:35:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 940656B0668
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:35:44 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1FB14160574
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:35:44 +0000 (UTC)
X-FDA: 85428681408.13.2CC2660
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id B9B8BC0006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:35:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fECuPcZu;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794540941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/EpJW4u8WbHMmv1aTon1aDhD2E0ZAU/gbjsg/EqSoho=;
	b=S+q41r+InwYNwfgJFdzPAJY83xr7wjUmIm6TLHn7Mf8W5eTvzIt5GfEsDsPGj87uECw14Q
	FmJu1fScWm1AnMud24i615CfVv05xyCtzugatZm7IvDMtujExXdUb0YXu99mlBNY7Z5ZHH
	qlwQg53IJOoSm2Ek1JKe79lLREMKVc4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794540941;
	b=6jqLo7gr6rNbOTfrPifiu0Ywte65DicuxKaupLkeqsxkDcaB+okGH2yrX9RJA+ybGPrcFD
	oWBpx04MIRJiv60AOOrwXSzQrZuv7eYN92juW5xjOslBhSbwsuKNlgn2vgCWUo1vKLXghN
	afqlPFBm4yM9hX9JX3CcpawZtcWWvrU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fECuPcZu;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-3704d30b84fso703014eec.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794540941; x=1795145741; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/EpJW4u8WbHMmv1aTon1aDhD2E0ZAU/gbjsg/EqSoho=;
        b=fECuPcZuBRmLiCtKbK7xzQnYvEXXGL+XNi+gbU2ZAU8MVM1crGiPBBvfdasv/euUzX
         qT6LqJYn3FRq4l4ob/PwlZNH4KDCOQ7DX2eqJG2uZhCC9kO5KYx+HU7w6/g5IU/IMQXP
         FlCraWe07WesAAKeYLkrWvPx/jOXawCQd0H4Kj2IwD+R+q3yjejrEB3v8KagzIcCa7RO
         pPB/vFubYEPYmouEeth7d7LPcNfG2O4EWnFqW325d86/tgGRN8ir0ye+tOsQsyGUzdP8
         3T79YBQAB5H9sLW0vZ8jmhtD3+F7RA3UXIAYMO7QAszz5CGXa/MewEAHd4+ojwqIdazO
         4Hbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794540941; x=1795145741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/EpJW4u8WbHMmv1aTon1aDhD2E0ZAU/gbjsg/EqSoho=;
        b=BJPrJ4KiW4asWb/qm9SgPd6WQK4A2ZuvOGai8GZak+yuV2dxeuMP5N9FsJRQ34KIUd
         awc9JW6kc2soGPcWnmnK+ubcM/n1N6p4IUyiZk6gtTqVIq3d0MSmeK0184M2yfshL3NB
         yA+o/4eCvauefAVOakTvt38XZbEhXHiyRhyPXBP759Hl3biAwI/ORgyquJglgC9PIbQQ
         Xw7/dx5uEgKFzSp+gl43GDm87sb1oqw43A6q/y8DY/FWYPUq0xWbyn2YAvSU+Mv0r4C8
         df4Iq0e1QEtlho9nUYBBvcLGtd5Su10oefYyjJnG0S5KQYS52WLJ/umQcW5IAg+Di5Hg
         fI4A==
X-Forwarded-Encrypted: i=1; AL+hErEAEEc8cLqNZjk8oXuPcGA7iDLuwRQ9lhb1PjaEPBiqA+39KEPBWGRR0SjdRgrbnfErn5+s/FyceA==@kvack.org
X-Gm-Message-State: APuU4Z+43OYkJS1Eg+d08lNT71Uwb2wJUQjY8OhWzY++rOqBiyQUIBxX
	qpmWvimXFUxem5Frj5A9LZSHZBv1MYG5KHRtfjmoHqkKMCusY3/aUNcO4ohgdAJHeR9ho8V2uZS
	9cT8A
X-Gm-Gg: AYBFou0px21zg8cc7wEigd/34IdKB6odUYdcA2AW/sGNvroWikjLDI1ta9dRtnhXd2n
	aPmx9l7GYXXh9NrHLDHNNBwE1903Uvsi58EUVaG6nFLATWSoa7ax/4ysvMYCNMiqvZTrOljC8Nl
	c7FWG0TSr2Eg0ZsAX0wMQnRw5sfxv84DzPUE2wf8I59Vg4F6NDGGck/92MmunFPbW0TzfXj4XO5
	VCyiaLaJXAC0OdWJnomImKV4IgTI2DzTNNimCZczj4Ul07aW3Rxe7wFRTsYNlG/ss4SPkpU09q5
	1PGJ4AX56ZcHL01TzS5vikJ+Ov70kaxaFnYg8vKm2kas1HV9/EgBt+8tVsrs/IlREa8WHGRumg8
	Ycq4pm9Tzcv0nFZYvqpImphi3+mbYWlOjelp9L7hbMl4vq9kHCXsGPBbqAClkGV1hyKMC+GqS/l
	fSvYnbLW3KgYZrtS/UwwKxH4EbVwzAAQfOKPH5mK/HANKnIwqlBDN+rd66HGw3jX5PNaBBDQoTy
	SQLEXyVPVQMeWC2X01ofbjIx/yaRibd92q/QNAfzeJRDDJ6Mc7g9H7GX6Sw0Q6F4iVF5Iaw8A3w
	m1IPh6KevKA61GEW7ZFzi9UBZM2WMj2qoYUXefaiCnJ/9lGkFcdDGT6Uv7ggX88=
X-Received: by 2002:a05:7300:e9ce:10b0:368:7c2d:a612 with SMTP id 5a478bee46e88-37966c4738fmr1104966eec.10.1794540940323;
        Thu, 12 Nov 2026 19:35:40 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955e0d966sm2959426eec.15.2026.11.12.19.35.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 19:35:39 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 05/14] mm/mm_init: simplify zone device page initialization
Date: Fri, 13 Nov 2026 11:34:33 +0800
Message-ID: <20261113033442.62970-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261113033442.62970-1-songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f5igztqqj7gjubyo3uti416xmidnuciq
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B9B8BC0006
X-HE-Tag: 1794540941-11249
X-HE-Meta: U2FsdGVkX1+FiT/VG1FYMep4X4IfDk+tNnkamAj6Fwff0s+o8U+Z9Lo6HTyzVnXkrMlK/iXv5cpeEICL2cgoill+NaosJSgiKuLZK+O82oPQ6X41XW5bwaN6t8iTeLt9nSPEgHttLPtgl3wY/Gjz0yKKYmkVUe6PeTOHa0GJhgelmvV3luSZkbg1ksV9sE6kS+syiLVeyXgagDfb+SOfNKneSY2Hw+iNAXctzGusBBu8eZGCDYLGv/rZr8QlD0C6zChedLUV3M++yvcjszttrMgtPu53Oqvv205vUJef0YdI4NIVcFOGZTBClcEOx9cK1nasPaxxW5MEl37TZh3aRZ9+ya8LCXh8KgxUEfoS8bX6ikr6z/tUJCisCa+vGWMPciq8FdEW7s3e2hyVD3JXWCsEzj4iXlPQuF2qp3mgVMX/8cJUl7kmWdA1/XtRWsOHyubwJFT0EzbcZyQQdCjKpklKK49sDq0xEFLYEf2NiYlB8ydRajy85gjVltsrhjlNe/YItLRiAvqlqEwPNd17ZHQ4pZ864pBArrZBsfSQYWwP+oTajie+Veq/Dw4NMunIWxmPmg6Mw72QmEOyFzNhCQZEbzRHlJvYfir6+oGDGO6KkZulxBT1dCm8gypgaaN9gLttPi2kxtmLRC3o47blpqqiPC30a9HBmyuewUcwAWeQby20ot2KXyL2U7EudFzKGEdkHILUQRlDAuiLuPDkmMJZWNlKZsVP/rq5bTwOXrPiZ7M9EiMs5C81RH0dF7CEyedo4AHQQiSIOIiqISoYfefmtFuA8NLWzEPz4JUhwKONllt+YMn3UgVs8xwVIxpoN98+sTmnKRyaOrO7Ai+S7QcCCyIwhEPqzziKwqGZX/gvqWgxBAkUbb9zlT0HLiJ/Pc88ri9liGWppuzDRwzTniPj7iGr4gnx7N+UOc4PRvqPjBkFLPPrSSt0iZ2RTVHYndS2AAQ5YvIESd8OKYN
 SjfLqEoL
 8KQOEgMe08N12mcCCQip/3YBo9ajDtEySp02DmGRcR9JFGD6gdylI0tLiNSmTKu0U7+pr4kM+zb1GG6pvVWfsdhSBHKNp+WWQXGKBgz/OVWVwgv5lnRenXpmFKbRfpW3SFco1iYe/a80swWuoinjEY2Zk67fYHXBzt9sk6E+aFTCcYyw8ILIeJk1uWD1KTVFSpRQOs2dUKgrKAkYsdeJbxvtB0nxhDfowYv6TRefpvo5kjhPa+Qli/LVdf46qa9sNrE5xsDXyUvcgVKabbvUk7nqBiQaeMkqkhaV0eh838lOLpYgD9nK17nl9ajI05QHOTCItrQy3SdnM85X5K1nppZJnJwAsaUZ00HSVZmoLKp/EUoM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

memmap_init_zone_device() currently seeds its reusable head and tail
templates by fully initializing the first real struct page and copying
it back into a stack object. This keeps the first page outside the
common loops and leaves __init_zone_device_page() only for template
construction.

Build both templates directly from the PFN-independent state. Add the
head-specific pgmap and refcount state to the head template and the
compound metadata to the tail template, then initialize every page
through memmap_init_page_from_template().

This removes the special handling for the first head and tail pages
without changing their final state.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Rebase on memmap_init_page_from_template().
---
 mm/mm_init.c | 94 ++++++++--------------------------------------------
 1 file changed, 14 insertions(+), 80 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 8d0b8faf3938..69bbaf75f935 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1064,48 +1064,6 @@ static void __init memmap_init(void)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
-					  unsigned long zone_idx, int nid,
-					  struct dev_pagemap *pgmap)
-{
-
-	__init_single_page(page, pfn, zone_idx, nid);
-
-	/*
-	 * Mark page reserved as it will need to wait for onlining
-	 * phase for it to be fully associated with a zone.
-	 *
-	 * We can use the non-atomic __set_bit operation for setting
-	 * the flag as we are still initializing the pages.
-	 */
-	__SetPageReserved(page);
-
-	/*
-	 * ZONE_DEVICE pages union ->lru with a ->pgmap back pointer
-	 * and zone_device_data.  It is a bug if a ZONE_DEVICE page is
-	 * ever freed or placed on a driver-private list.
-	 */
-	page_folio(page)->pgmap = pgmap;
-	page->zone_device_data = NULL;
-
-	/*
-	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
-	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
-	 * the count again when the allocator or driver hands the page out.
-	 */
-	switch (pgmap->type) {
-	case MEMORY_DEVICE_FS_DAX:
-	case MEMORY_DEVICE_PRIVATE:
-	case MEMORY_DEVICE_COHERENT:
-	case MEMORY_DEVICE_PCI_P2PDMA:
-		set_page_count(page, 0);
-		break;
-
-	case MEMORY_DEVICE_GENERIC:
-		break;
-	}
-}
-
 /*
  * With compound page geometry and when struct pages are stored in ram most
  * tail pages are reused. Consequently, the amount of unique struct pages to
@@ -1134,30 +1092,13 @@ static void __ref memmap_init_compound(struct page *head,
 	unsigned long pfn, end_pfn = head_pfn + nr_pages;
 	unsigned int order = pgmap->vmemmap_shift;
 	struct page template;
-	struct page *page;
 
-	/*
-	 * We have to initialize the pages, including setting up page links.
-	 * prep_compound_page() does not take care of that, so instead we
-	 * open-code prep_compound_page() so we can take care of initializing
-	 * the pages in the same go.
-	 */
-	__SetPageHead(head);
-
-	/*
-	 * All tails of the same compound page share the state established by
-	 * prep_compound_tail(). Reuse one tail template for the whole range and
-	 * refresh only the PFN-dependent fields in that template before each copy.
-	 */
-	pfn = head_pfn + 1;
-	page = pfn_to_page(pfn);
-	__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
-	prep_compound_tail(page, head, order);
-	set_page_count(page, 0);
-	memcpy(&template, page, sizeof(*page));
+	memmap_init_page_common(&template, zone_idx, nid);
+	prep_compound_tail(&template, head, order);
 
-	/* Initialize the remaining tail pages from template. */
-	for (pfn = head_pfn + 2; pfn < end_pfn; pfn++)
+	__SetPageHead(head);
+	/* Initialize the tail pages from template. */
+	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++)
 		memmap_init_page_from_template(pfn_to_page(pfn), pfn,
 					       device_zone(nid), &template);
 	prep_compound_head(head, order);
@@ -1191,27 +1132,20 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		nr_pages = end_pfn - start_pfn;
 	}
 
-	if (!nr_pages)
-		return;
-
 	VM_WARN_ON(!IS_ALIGNED(start_pfn | nr_pages, pfns_per_compound));
 
+	memmap_init_page_common(&template, zone_idx, nid);
+	page_folio(&template)->pgmap = pgmap;
 	/*
-	 * Seed the reusable head-page template from the first real struct
-	 * page. The normal page-init and refcount helpers must operate on
-	 * a real memmap entry rather than a stack object.
+	 * MEMORY_DEVICE_GENERIC pages regain a refcount of one in the free
+	 * path. The remaining ZONE_DEVICE types start from zero here and raise
+	 * the count again when the allocator or driver hands the page out.
 	 */
-	pfn = start_pfn;
-	page = pfn_to_page(pfn);
-	__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
-	memcpy(&template, page, sizeof(*page));
-	if (pfns_per_compound != 1)
-		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(pfn, pgmap));
-	pfn += pfns_per_compound;
+	if (pgmap->type == MEMORY_DEVICE_GENERIC)
+		atomic_set(&template._refcount, 1);
 
-	/* Initialize the remaining head pages from template. */
-	for (; pfn < end_pfn; pfn += pfns_per_compound) {
+	/* Initialize the head pages from template. */
+	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		page = pfn_to_page(pfn);
 
 		memmap_init_page_from_template(page, pfn, zone, &template);
-- 
2.54.0


