Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA79A606A89A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=jPUi0iB6
Received: by kanga.kvack.org (Postfix)
	id B40886B0670; Thu, 12 Nov 2026 22:36:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF0656B0672; Thu, 12 Nov 2026 22:36:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B8976B0673; Thu, 12 Nov 2026 22:36:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 78B6A6B0670
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:36:03 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6BD06A05F0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:36:02 +0000 (UTC)
X-FDA: 85428682164.29.DE40C09
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id 954DE180005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:36:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jPUi0iB6;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794540960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cbR+hSewc7EqaRywLF99e8RUZ/FL9vDU2C+TKhD5kQc=;
	b=sfEYM9rimgqaGo4/2qobRbrutroz0fWOFvPtGRXklMHfW4kF3JGpm5cmQrvV2FMGl9dXdW
	UtpUerB1Ng4maxDErsrrJgWAEk1c8lHVRdj++lGojwd2nZPtFVnXpZ7dO7Vf73w5c/Klii
	h/zCxLKeLnXLvT54poh++U6QGFPGBs0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jPUi0iB6;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794540960;
	b=va+daaypwKNAMzjuDHiaFsFsjmiSZ5RslXgAXQehsrE5bDNbFAo8HSuGZUpGLPalZx4RI8
	YvzIfPPM41kWNGSkeNxPl2heN6hzes7+MHjek24vE7hqdWj5WOPYcp9FJA1qkKMuLS6nrX
	392JWI5Wh6+xSNYZPmQqRY42eUjSZMc=
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-37198ed3727so1887040eec.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794540959; x=1795145759; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cbR+hSewc7EqaRywLF99e8RUZ/FL9vDU2C+TKhD5kQc=;
        b=jPUi0iB6OhLoGUoQuYye2mQ/M7uHo/LZ1QHQ7gntBSFG0N2bR8lMAaO14dVFxeiLnN
         Fn0gdCv9XfRN+aH+0uKQqo781tlG+XdRU3EPAQ3xUWL3FsnON1X3echipSaQtEUKujFL
         nlZd8RhPbV4QQXm+bo3NNoEuRk7/v0WKxSIFPfxJEIZYKQ7Vybd8snHgzk7lzL9uGEXE
         O2PANxs5SYhPwi/ltQ+L9QNlfwGqXps3y18U1AuV9b2MPrgDY5cyrVgUzLPv5xjprjIw
         yjmjdS7zLQ3zpzCqdstx9qcFcgqMvlL6RJ2IWJuf8HIKjTwN8QruAr4B2alxsdStnoqw
         PJqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794540959; x=1795145759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cbR+hSewc7EqaRywLF99e8RUZ/FL9vDU2C+TKhD5kQc=;
        b=Mm6HpaJ9Kug+3EBA7hjpKKTvM+wMxrleEYV3RZ02ydcXxBMum5g5CZj/ZjwZrgAQMt
         9REOzuADtyiCXmQ5/8oZnAkwwXf2NzELomqJZlwp2iLL10YXG2UgXjv1KYyun4x7fbWS
         tOTBNfyoKv5i7waFvjqUdyjGt8S2kO44RCNLgD5ni3Ii3WpBjF0/aI2VbFT/ZEmfiFnH
         bc0XITVT+AIZUywaD019KSxlIGnz4sAL2DM4g+1balQVFw5/DOtN0HbRHd9Sg4c6qLDq
         pzsT7FMj2jvF0flAgDIltkYBtkoYEgHMuFAmOLfMHLYIugS/xNq80j1ifgY+c8vwhKNF
         y0kA==
X-Forwarded-Encrypted: i=1; AL+hErFBUOoyY3UfDQE89afXFQtYvtbGERjyJsZVaE/4wWPODM3kqBZekOIIYpveusT5Dg1uvPjwRvSwvA==@kvack.org
X-Gm-Message-State: APuU4Z9lbXtcValczWa9/uF0fJI6MmjP98zutROkotPSYn3D78+IM6Xh
	aA4lbBqtIJ08ckOzNrBamSyzEL3+POErtuVB3xRoBSpQCDr7rzC+C+q+oQB+ljTMi5E=
X-Gm-Gg: AYBFou37H45HP7EUfdXw4ZsgHVao8DWEreipW+La1XYCVSxJBg81Qx4+bT9Xtt6Qvkg
	6y0EkZCgqj6Qkz0PWrNDI9ibvYwYurl9u5Xt9qPmMEeYZFmfk9esu21XLJ15mLsYRvLMmeS7GBR
	r6g1x+ELJucUjYx2bvHXHEbbNRtktHzOhudg+sNqfXNWYqca3DiL+49p/DvKr3adcDmu/UalvgL
	IXbtTVL8GWVwhCjSTIH4ZI8zJcjM5rAlT/8W23ijlZV/DWkCTOC1wmMYaLTYexhYYJLwb+XQeuC
	pmLV9OVq0+H/IVkd3E8x0rH+agKjTBRo6YwMV+f2+xt20BkrC08pE5UAORzz4/kkU4a/VnWaVsp
	8kW2rv/vB2VFSdeWZEI/DbpskOmrlH2ku3TZM9czGM4TPuqX4MYsuWzqlPM/JkJ7j7zAp9hXTw+
	VLwfLvFeeTyQmSoi5fYg9n0boyKk2M+bOrf8UuFqLJ3QPRM/wUq00ZxiSYaIFjs0opVawW9RJDz
	brCxJiUMbAXWovMf2m5uiryfKNP2ZGrPvpytpfjZcPCt/YZD+iTsbXeK8HNUIT6PcZ5FKCJc/YB
	mSgN3eaHkp1+P0dsJnVbBWaQpbGOcPaHsv3CiS5KOQq1D0xXe3xmiI2MFc4OuA==
X-Received: by 2002:a05:7301:182e:b0:367:a092:3c73 with SMTP id 5a478bee46e88-377e1016111mr3830599eec.12.1794540959040;
        Thu, 12 Nov 2026 19:35:59 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955e0d966sm2959426eec.15.2026.11.12.19.35.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 19:35:58 -0800 (PST)
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
Subject: [PATCH v2 09/14] mm/hugetlb: use common compound page initialization helper
Date: Fri, 13 Nov 2026 11:34:37 +0800
Message-ID: <20261113033442.62970-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261113033442.62970-1-songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k7fjk37waka6fwj7a1froqcrn3s78ag1
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 954DE180005
X-HE-Tag: 1794540960-856520
X-HE-Meta: U2FsdGVkX1/gljkRhdNlIrm7fs6u1bf0deJzSHwTyTZTyflKyxHvX6N5D/Q5t4To0FcJPw23O0FecOiZMW0eOjxty896WcgAjT8AZzXi+fkHmznmEAlbA/9AOID3iZGs9txZHJxcN46VDrjCfhMXpeh0qyrSSXmnK2H1RHtnSDha+uDswAjJuq21mnxeQMxsEOfsJXuygtNcGR+qEGOuxyFX9c/d1KPQKS2i1HlfuRID6hZGMDrYFwcsBrytyCN7pKj95XysQS6KWVVo5wyupbLfExlKUaKW2870SYRfEFbtah5fOLu1TktybF98PL3oSs9qlbwdZSicEDU1Slw+MRTDRSxuBTBjRGYngoIOjOqP+Cy04tBCPkH5aq0HLU0yjLCPurKfQR4znuU5YmGVMDL13tLBKf/6f8b51ke+GU/4RglHhGAn42K/LJ4AxsurWDQyrh+au4pfIRPoDOmoehzBCpmagfauQGPnDdsiVFyqR9WW3e8GANIUF+hZ6B0iqNqMxQLjCDyZERcNPBZ1d8FeQptP24ZKj4eg2E32pZ0sjbKlg525FXVrsmw/JVIDBzFsQs4mWMv6IyAjZiJqjDucOSzoc1sWKPBXtapsXvsWAcnJsRuuRjurlkPkaSvsTkzU48wsj6xmT7+f4iC+OwXgn4J0fPWF7l1SAfpvOkm6AC5Os4Duk8S7Ztb0pUjB6Qpjldy/Um2uWCr4Ch/F/a7NDzuxse34ECmP2viLphQ7PvtSqkCXaYdZzI9cpZ9yWUbT69C0EHymKTCBIPDkiHOdTT6HMGqX+TdZhtunELM0L8y9zd6OZqe+JL1Rii0MusDK5ynhArjr/kyGurFsnoiYH/2vBD0Xneacweg0GR8ruRD6Bv5BXCNgmtGHF8gQrG79jU9kX/YKvI9s9UdrqIkPba4LWmrQqYZX0YwM8TUttD1g+/Fg0DCOtguaPf/eZOrhw0LjgyD0AqgKtAt
 ZuJ4R0+j
 XAvqkYwjGlfFW7TVnvsiwan8ADctqAl1EDj2/5/rS878m/u9H/CI5R0DJqvMVRn7V4NPpmYGd/aJvAUspV+OGjOKBtyMbXbgtQlO6VtpQRACgY/GNtR5HxQHoIMW1Oc1axjbiaWmTYDF0fqfvAmwkvwsmE30Q8herWhZtufN4tGhR1N8QfILW3uLaKvYClGy3qwAowZomuoNDRQhycOiJIXMQ/2mPKKarrHz/i1XyWw14I+6OsjAxns7nS0nd/0Ev+wrE957C2CkSC6tEH5jzF0LDBkyp74r5eLe6rRrvb1Mmjv7X4FUCmyUajg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Boot-time gigantic hugetlb folios open-code the frozen compound
struct page initialization across two helpers.

Use memmap_init_compound_page_frozen() and remove the open-coded
helpers. This keeps the initialization rules shared with ZONE_DEVICE
instead of maintaining two implementations.

No functional change is intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c | 65 ++--------------------------------------------------
 1 file changed, 2 insertions(+), 63 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2716a83a7386..6ee36ca5f435 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3249,63 +3249,6 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	return true;
 }
 
-/* Initialize [start_page:end_page_number] tail struct pages of a hugepage */
-static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
-					struct hstate *h,
-					unsigned long start_page_number,
-					unsigned long end_page_number)
-{
-	enum zone_type zone = folio_zonenum(folio);
-	int nid = folio_nid(folio);
-	struct page *page = folio_page(folio, start_page_number);
-	struct page template;
-	unsigned long head_pfn = folio_pfn(folio);
-	unsigned long pfn, end_pfn = head_pfn + end_page_number;
-	unsigned int order = huge_page_order(h);
-
-	/*
-	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
-	 * we must initialize them ourselves here.
-	 */
-	if (start_page_number >= end_page_number)
-		return;
-
-	pfn = head_pfn + start_page_number;
-
-	/*
-	 * Seed a template from the first real tail page and refresh only
-	 * PFN-dependent fields before copying it.
-	 */
-	__init_single_page(page, pfn, zone, nid);
-	prep_compound_tail(page, &folio->page, order);
-	set_page_count(page, 0);
-	memcpy(&template, page, sizeof(template));
-
-	for (pfn++; pfn < end_pfn; pfn++)
-		memmap_init_page_from_template(pfn_to_page(pfn), pfn,
-					       folio_zone(folio), &template);
-}
-
-static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
-					      unsigned long pfn,
-					      struct hstate *h,
-					      enum zone_type zone, int nid,
-					      unsigned long nr_pages)
-{
-	struct page *head = &folio->page;
-
-	/*
-	 * This is an open-coded prep_compound_page() whereby we avoid
-	 * walking pages twice by initializing/preparing+freezing them in the
-	 * same go.
-	 */
-	__init_single_page(head, pfn, zone, nid);
-	__folio_set_head(folio);
-	set_page_count(head, 0);
-	hugetlb_folio_init_tail_vmemmap(folio, h, 1, nr_pages);
-	prep_compound_head(head, huge_page_order(h));
-}
-
 /*
  * memblock-allocated pageblocks might not have the migrate type set
  * if marked with the 'noinit' flag. Set it to the default (MIGRATE_MOVABLE)
@@ -3363,8 +3306,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		struct folio *folio = (void *)page;
 		const unsigned long pfn = PHYS_PFN(__pa(m));
 		const unsigned long nr_pages = pages_per_huge_page(m->hstate);
-		const enum zone_type zone = zone_idx(pfn_to_zone(pfn, nid));
-		unsigned long nr_struct_pages = nr_pages;
+		const struct zone *zone = pfn_to_zone(pfn, nid);
 
 		h = m->hstate;
 		/*
@@ -3376,10 +3318,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		prev_h = h;
 
 		VM_BUG_ON(!hstate_is_gigantic(h));
-
-		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
-			nr_struct_pages = VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
-		hugetlb_folio_init_vmemmap(folio, pfn, h, zone, nid, nr_struct_pages);
+		memmap_init_compound_page_frozen(page, pfn, zone, huge_page_order(h));
 		init_new_hugetlb_folio(folio);
 
 		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
-- 
2.54.0


