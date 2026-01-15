Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83679D44C56
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 14:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C20986B0092; Thu, 15 Jan 2026 09:46:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B04A06B0093; Thu, 15 Jan 2026 09:46:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1D6D6B0095; Thu, 15 Jan 2026 09:46:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 903A36B0092
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:46:18 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 33BA61A02C5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:18 +0000 (UTC)
X-FDA: 84334473636.22.735F2EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5FF0340012
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Snk1xT7N;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768488376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oDh3YOC6eYeQyqydHIILE6IJ6ncZjyAJYijiByFrg54=;
	b=XH0JsXYf8dZCJq+DFSoJvv1CDaH2Z7btcgPofqL2fN/DupWaKcXSrWsDsZq3j5e+Vy0J/i
	rpA9hZWy0byoiZ/ranhZersXBzujjRIrYR5LIaBvGDPNkkj7xXSnBd32UaFqLAmJckeyYT
	BYHxmpf+ATMBZUOAa7zKp8t+ISs9QkA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Snk1xT7N;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768488376; a=rsa-sha256;
	cv=none;
	b=rkL9Z+n8StwOHTwBpaHr4hVtkGWeLA0VczcGpc+vK8LSXq5cuQ/IrRpYfpCyAxUHbhTsLF
	fSJNqN8X2jRZuMwodtrl/CvkWr5FVTvHbm6jPPZVxGXmtBMyTtyOuR90kVMyZO9C4SAKv3
	Ww//PslF2GUT+8XajIMBbkf4D79SrJk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D72C7601B4;
	Thu, 15 Jan 2026 14:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1151CC16AAE;
	Thu, 15 Jan 2026 14:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768488375;
	bh=ft4QB+pe2zfMyyeRxFmvFGapI2DJYfjteZFz/aCazm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Snk1xT7N/hAcSlG+429C+NoZs18+WxhsUMs5OQqWEz7O+khW6evtiM3B/f0WgUbvX
	 MliO4HtvbKbd1g6NqFtSyxmn6B4w6g5o7f+zwEdWyQdbAGsHLBzTg0OYgECs0t0Mhl
	 I5x0JVmwjqX2VZHqo2SrxmNf8LYWczfzhH6HBmqFxj1NB3taX35UH4pXWZl/yeJEDp
	 ldsWa2GFaZuRvisHiZkfj4s+6p1ewJsqd2J7QGdUzBgbql0hVkS2HLQFYMb781C9S0
	 yWwr69eijmzxhBuoCHldIUjMmlQa+hbgL1h/Y30Mvc1am1fzEiz3RtXwha2KHUV+7Z
	 aN3sXFg2NQMog==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 3DFC6F40068;
	Thu, 15 Jan 2026 09:46:14 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 15 Jan 2026 09:46:14 -0500
X-ME-Sender: <xms:tv1oaUpW6euEkHbmYS8DmMWHI1OvO7gIbOmIPkrKVtuJm0OCdlz_tw>
    <xme:tv1oaZ5xzvLqmL1V0rTmssaaH-N6USHdnZGEG4x4ulbRiEnnFKjlkV-ktT_afECjF
    0mEjeViTQuNUFCheIH7pm75XizbSDI2HrqYMA7gHZZRxRojR35CKyCW>
X-ME-Received: <xmr:tv1oacBIAbgk-zPrTBo78zNZwI9BK1eKp12LDNbJrWOjbrUEEyVaP2820xsVYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdeifeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:tv1oaTZRuo0VmTopKAC2ESPFcU1mNggOwtcAUB-rjFu9KEkjllmpKA>
    <xmx:tv1oaYJgX6Ihu4QbUKgzEDWZoPsK4QlRAUZDQKSquM7OStTDrz7mVw>
    <xmx:tv1oaUAyLGOxWNmPyXvzyM8drjo1c7egms4u621zP546U2acJsMtVw>
    <xmx:tv1oaUPMCsv7oPNJwzwg7NAnlWyN7ogu700DHHw3ozNaApNWaL38GQ>
    <xmx:tv1oaZUUVOJQC53OYrFO_DAmHvvzYIA3qTMiStSzEpUtz5hq61pJMZOU>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jan 2026 09:46:13 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv3 03/15] mm: Change the interface of prep_compound_tail()
Date: Thu, 15 Jan 2026 14:45:49 +0000
Message-ID: <20260115144604.822702-4-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260115144604.822702-1-kas@kernel.org>
References: <20260115144604.822702-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5FF0340012
X-Stat-Signature: 3xmjibano1t8hhthuyxisixfru6uqy5r
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768488376-492553
X-HE-Meta: U2FsdGVkX1+hW+eo5l2RKY7dTonX6wnKvokeG5t0fUcAnsgEnjkmLLQefnICvYiB9kdR49GiRV0iaKQ/nVx9CXOLVMccsdOq1u/yL3VsNtlZRLnttsVrmewXb9ouoBZHLd+jeqPzmi+aJgSIv+ksq0fIUyp/68tPW7mdI1QCLDO87S3HoH7MRXxStEZhkpAFk5qb33efR8Qxa1s9VvOqqFSGnTGDvx9zMc7aU7T2LedkVQzxba+lZzACVQZZq5QUW9yf/lLk5+zKEUo+xcxN+Cp9/lY6oSDbX/x6SGbmVnkbwcL69uyMMEwmt/myAed9GEeLwpWNYGPj9RNK4K0e1HTuakTTlsnKmsRwP4SkMyXGBM9PcgkLFoYO90Wl1DHZ7saC8psXcX5dK1QAGVCIB+ClqKCAq0BGCwDWwheGyoe2FJWXXqY75PNQnhh2sy9LnndzyzuL80GM6bIG43yzXW5TfyZvHHtG3cJ7/d+y78Dj+cFaR7qx6S+mgLfRWB6iN8Nk1fnP2gqDnYGJCFj1smpxgYVWhfK4td6DitUSvY3TD/bbEmpelzi0M4hqW7J72EhMLitThfOUpTiAjCEy4NmUXJng8/MIvz53QBRvApC0tgG4cAVSGI/LIZRFBVmH7Xck8Etq7KPVyhUtXemvm5pEbxzQEcBg1/pKqRBgrN2l59M8OHcwZ5gkQWCR1yu2C44AiCuUw4X2XzaqJW6tGbYa//h9oFYlSCzbOxLnhHcCvSmnzOouraOk3xUd5XQcsJScoKIfBRDfBi8Yz03aLrONVO47j/natgHLyzsV6QDWWmpD4ScoiSnZzy85abZebAa4XW5yygqQWejdsmkJS3YZCOeaa6hAudyEE+yxZ2WJCMC9pzoNV+2WyZiKih+bh4CGPbzsy9LzgiTjllsAfUFfE4I71ZDUjFpajN3UvjzGioWE19y8am/ZWtOuUZfDMGcVm7j4zy5tWcMVxRW
 e2XeXB6b
 KHRtuTQexzuCZCqQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of passing down the head page and tail page index, pass the tail
and head pages directly, as well as the order of the compound page.

This is a preparation for changing how the head position is encoded in
the tail page.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 include/linux/page-flags.h |  4 +++-
 mm/hugetlb.c               |  8 +++++---
 mm/internal.h              | 12 ++++++------
 mm/mm_init.c               |  2 +-
 mm/page_alloc.c            |  2 +-
 5 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0091ad1986bf..d4952573a4af 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -865,7 +865,9 @@ static inline bool folio_test_large(const struct folio *folio)
 	return folio_test_head(folio);
 }
 
-static __always_inline void set_compound_head(struct page *page, struct page *head)
+static __always_inline void set_compound_head(struct page *page,
+					      const struct page *head,
+					      unsigned int order)
 {
 	WRITE_ONCE(page->compound_head, (unsigned long)head + 1);
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0455119716ec..a55d638975bd 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3212,6 +3212,7 @@ int __alloc_bootmem_huge_page(struct hstate *h, int nid)
 
 /* Initialize [start_page:end_page_number] tail struct pages of a hugepage */
 static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
+					struct hstate *h,
 					unsigned long start_page_number,
 					unsigned long end_page_number)
 {
@@ -3220,6 +3221,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 	struct page *page = folio_page(folio, start_page_number);
 	unsigned long head_pfn = folio_pfn(folio);
 	unsigned long pfn, end_pfn = head_pfn + end_page_number;
+	unsigned int order = huge_page_order(h);
 
 	/*
 	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
@@ -3227,7 +3229,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 	 */
 	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
 		__init_single_page(page, pfn, zone, nid);
-		prep_compound_tail((struct page *)folio, pfn - head_pfn);
+		prep_compound_tail(page, &folio->page, order);
 		set_page_count(page, 0);
 	}
 }
@@ -3247,7 +3249,7 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 	__folio_set_head(folio);
 	ret = folio_ref_freeze(folio, 1);
 	VM_BUG_ON(!ret);
-	hugetlb_folio_init_tail_vmemmap(folio, 1, nr_pages);
+	hugetlb_folio_init_tail_vmemmap(folio, h, 1, nr_pages);
 	prep_compound_head((struct page *)folio, huge_page_order(h));
 }
 
@@ -3304,7 +3306,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 			 * time as this is early in boot and there should
 			 * be no contention.
 			 */
-			hugetlb_folio_init_tail_vmemmap(folio,
+			hugetlb_folio_init_tail_vmemmap(folio, h,
 					HUGETLB_VMEMMAP_RESERVE_PAGES,
 					pages_per_huge_page(h));
 		}
diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..f385370256b9 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -810,13 +810,13 @@ static inline void prep_compound_head(struct page *page, unsigned int order)
 		INIT_LIST_HEAD(&folio->_deferred_list);
 }
 
-static inline void prep_compound_tail(struct page *head, int tail_idx)
+static inline void prep_compound_tail(struct page *tail,
+				      const struct page *head,
+				      unsigned int order)
 {
-	struct page *p = head + tail_idx;
-
-	p->mapping = TAIL_MAPPING;
-	set_compound_head(p, head);
-	set_page_private(p, 0);
+	tail->mapping = TAIL_MAPPING;
+	set_compound_head(tail, head, order);
+	set_page_private(tail, 0);
 }
 
 void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 7712d887b696..87d1e0277318 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1102,7 +1102,7 @@ static void __ref memmap_init_compound(struct page *head,
 		struct page *page = pfn_to_page(pfn);
 
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
-		prep_compound_tail(head, pfn - head_pfn);
+		prep_compound_tail(page, head, order);
 		set_page_count(page, 0);
 	}
 	prep_compound_head(head, order);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ed82ee55e66a..fe77c00c99df 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -717,7 +717,7 @@ void prep_compound_page(struct page *page, unsigned int order)
 
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++)
-		prep_compound_tail(page, i);
+		prep_compound_tail(page + i, page, order);
 
 	prep_compound_head(page, order);
 }
-- 
2.51.2


