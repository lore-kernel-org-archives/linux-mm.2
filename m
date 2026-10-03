Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15590CA5FE9
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 825DC6B00A6; Fri,  2 Oct 2026 20:21:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FE186B00A7; Fri,  2 Oct 2026 20:21:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 713606B00A9; Fri,  2 Oct 2026 20:21:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4101C6B00A6
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE1901208BB
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:44 +0000 (UTC)
X-FDA: 85279411728.22.4BCC50F
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0EDE0140004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JkLW7soK;
	spf=pass (imf09.hostedemail.com: domain of 3lUrAagoKCIgv5t06st50zs00sxq.o0yxuz69-yyw7mow.03s@flex--jthoughton.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3lUrAagoKCIgv5t06st50zs00sxq.o0yxuz69-yyw7mow.03s@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FDpWehmyXZTuwNLpOmNryZ2PSD85lfcY7+uhsZatBYE=;
	b=CVcPmlE290rUpAtTTgvQeXvBsdQAQNu1KTO1Q8A0wqgt8RMtF+uqLsLsIduNaTHUHexCrF
	4cTVHKb3WmFShWT+JBI+quEZpRSFLgAG35LK+IJyqoXakex46xfOs5y2lsdkcuB6lzE9mH
	S2wlpY+aSekGeRbG+UtojKZYu8z/bBI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986903;
	b=w0LjndBvc1tColffR9POriOro5f+gU4XCpDfM8owreUzVyjnK2eRkGurezOFwY1VbnSNdT
	/7plKpYm6hOoL4LetusUa/VWLFQb76/Thq5LuYLWp+ycOPOWTawAH6f0+JXwsPj8Jf/t7c
	1HagxJ/VRU8VHPv+TkDeusMJr96CcC4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JkLW7soK;
	spf=pass (imf09.hostedemail.com: domain of 3lUrAagoKCIgv5t06st50zs00sxq.o0yxuz69-yyw7mow.03s@flex--jthoughton.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3lUrAagoKCIgv5t06st50zs00sxq.o0yxuz69-yyw7mow.03s@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-398dc3d8f0fso361990a91.0
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986902; x=1791591702; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FDpWehmyXZTuwNLpOmNryZ2PSD85lfcY7+uhsZatBYE=;
        b=JkLW7soKNFfDVx9xWlWqC5pOfnnsgpkYM35JdW3vGrkWCNtJexm0rG+1b+6JHhtXOJ
         mqaI7jUHa54Ig2vy+ma7RA5oM/aZOZeHQpssz5KWkRBJDvOtulnoW7I9xnfecMbodp3n
         wlHq1w3vCgX7V/QTKS6JiXrvHnBpe5Sux3lRzraMp4ObAgswiJkdfvBfB8cD73/G0+rL
         ZH9kF4YErj1OIpB1kgNA3+1IXwqSRQ0CQf50esKNfY5iqwQNzF8+T87FJreVcBBUIslj
         jhq5D9KZHCwiiGtE7TfsqJ5AWE7KiM7X4EFEec3176OGMVN7Fg4xE7ozZs3NeCrYovIb
         912g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986902; x=1791591702;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FDpWehmyXZTuwNLpOmNryZ2PSD85lfcY7+uhsZatBYE=;
        b=brDFmq35qNKoKPxDIEAstNI8KXj5+6ardA6a2iGazbsq6J4MPRMtDByJMt5+RtAR9e
         rR0ibiwSoTIKC/ntf+jvvmatbJktNo67+K24lDYsSPtaLRF9umbUzZur9FtAXpX1pR6H
         hjYP0zA/DmOyFeqrjKwgUc7JwvjNa5/q5cXWmeS+yrhKDOfTaWTI4j7VqcfO6x31+u3T
         7UwQ7ZiOOnXYVA2MSzFfSBA29MyN5LSolUEZBf6DhIWO1HChmLLjaekkIfYyLm4/xTzv
         JK2E0Yl5hijU6ha/HP9j0asMwwdNcekj0nHl2RSezpN8h4FyUeDL94FQmeJBEtI37fUL
         /lfQ==
X-Forwarded-Encrypted: i=1; AKwUvBwbX2ylEP4rv5lWwkPXP9c92cdSXIZrWdvlhmQNCHEmf9tys4UYa5DUfXAt7EYDKKSUZotbYbrbXg==@kvack.org
X-Gm-Message-State: AFq9FYLMWDLg8oLE9nZy2tXnYhFwT5fx1MI6+ktrw28LHXT6DRTvCDhi
	Zi6G/gWWrvuto9F7NrAHSMyH7Y2/W2iEtuqPT5N/HWvzaARzv9B912Lvcn8vdwugeLYzN3QbOba
	lJ/lICkDPA5XB9kqTJa6S2w==
X-Received: from pgbdn12.prod.google.com ([2002:a05:6a02:e0c:b0:cca:68cf:6f65])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4ac5:b0:3a0:ddef:3da3 with SMTP id 98e67ed59e1d1-3a4f32d94a2mr5433773a91.15.1790986901434;
 Fri, 02 Oct 2026 17:21:41 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:11 +0000
In-Reply-To: <20261003002123.505555-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-9-jthoughton@google.com>
Subject: [PATCH v2 08/20] hugetlb: Fully initialize tail struct pages of
 non-pre-HVOed bootmem folios
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: u96q5p7uk7foh6s5syc7cmf8gqgryaj8
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0EDE0140004
X-HE-Tag: 1790986902-553168
X-HE-Meta: U2FsdGVkX19b1dCHqk0LxMP8rNcTRHARV+nEI3I+eY2+qLzNgBefqoskz3hoAvj/jGzBnchb1wSNQkuMjCIHgiUQlmbfyB2wDv/tuxhe3g48y7lRagmbtTYCxSN81ZbbYkDFjEMAIgBI95qjTEYJtYg5sZuHYR/Vw8XPMNf1zg+8jWvG2W8V4Pd7bnbpFOoKhOwkKF2W0LjZZRsNvYqBy4NwIXMp0jHXSlUwgsaUXHh3hzQSTVXND0tH6RKhUnb7K3yNfm0G2kFE817yRMFTIYlL8ZipZmE+AWoN1EnBAsidVP1OJ/UayD+iwotuMeB+cj025YTX59oM0gtIn+iYq0/EJpQaOKyeQiv3HIhvJ06qwXIDmBp1zodxYTUQS0e/4vifDA3dl+hi5077GPZxNQ6bjJIhQhFsVLIfHjzQKh8if8V/cDxR/L0+hExHszUQwd5Gb6Q5wOG+i7xgwx9Q9W/IltIbJfpcjKRM+K+P7gXCIiXcjQmCnCL1FDEhwc8RhJmrjXwDzppluqnHb4JjX/y/GtE5qq9aHdjdyzkHCSJL3DPROljzwh6aQWqStIj6ncht5AfOEg7CbQaRwXIYjkCtG+a+j6mbXKb9RQk3BiG1qcvgSd+EfEZmKmY1vJT0xOKhzLfEE1mkMdIaw9SNKf+xAsmsuuuM8lxablDlg9g1zSD7R3Ptux4dku5Yd3HB5CWy//mWBjQ+JFnsLvuvK+D82GtPTlTrkJeEPgdJKPFn0CbQquycsVpQEAzZvAPcQaHcjY7NYJjafR1hQnZuwDpgNZXc22NfAOBWWctc1kmp3oOEWhKZEORXbLEehm7RlWQPyfTJIIqQ3YFXw2Yj8CWW14AXp7ldVPKimNjOG1wT7uhYkijOyb05cAQNr3EpEZQoqG376xCfVod4FjeyKnIdW1Za0h1AUp+kxW0LnuH4jDmbGVB9Z+2dgj31PiqDkDQui9P3TpLJqfrkSZv
 v3Cpmiwg
 HOB5LiGt9bvt+hqYxVBrd6hGh88KiNKc3W8FzxnCcQZ2hU3qDnTutgnBDgDM/myZFz4336KrvytaLk/TSc5amIiUpN4KBwFfdgdBu9+cg+yPi1EL9LV49TRtf554v6FAVM1519CkDJdVvMatInbMaZjhqmTnQpJW6ueWZcaqIrfvo0Q4sVqvZerKZpWuhqKfUPm4uxoEezu+/p/kcCFW1p/tj9KrJYg0nApqzfzqku5OSJ7ngJi08OY1dxc54eyF+mHMxAJGTbi7EbaPgOZKvu13MnU1jNInUzHrLLX2NXFBDTpbg21DWMowDApVNQBUc4T0DOXqjXeAQj3TyCraJMHqcmTOmeBqFJ7MrB6Ui7fbcfTtZZ19qqTpt8W2Tj1zD/LRQWtuKIYv8utmJ2Lkaeh3x10Sl77jFq21WDvBldhWjTtJrWBqmSX5thn5qdwt9gl4gg95389g479eErtHifW+gevnkLURVt4V2rPogCXbUlkd0TsCQ0kF8UWPLfeRe2ALqDXvvsol+I+JrLYhpkuG8YTg9qNamReJGMIK4Zgn/umgmGbw3ZPvah2REcvKYLuV8rbhETnjQ3+EdnEU4+fHkQ9kOX/kHclVGb1gHJEG6ygY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_bootmem() marks all but the head struct page of a bootmem gigantic
folio as noinit, and gather_bootmem_prealloc_node() then only
initializes the first HUGETLB_VMEMMAP_RESERVE_PAGES struct pages. The
remaining tail struct pages are initialized only if the folio ends up
not being HVOed.

This assumes that a bootmem folio is either pre-HVOed, or will not be
HVOed at all. However, hugetlb_vmemmap_optimize_bootmem_page() may skip
pre-HVO because arch_hugetlb_vmemmap_optimization_supported() does not
yet return true that early in boot (e.g. on arm64, where support depends
on a system-wide CPU capability), while it does return true by the time
hugetlb_vmemmap_optimize_bootmem_folios() runs. Such folios are then
HVOed through the regular remap path with uninitialized tail struct
pages, which trips the PageTail() WARN in vmemmap_remap_pte().

Avoid this by initializing all tail struct pages up front in
gather_bootmem_prealloc_node() for folios that were not pre-HVOed. This
makes the HVO-failure fallback in prep_and_add_bootmem_folios()
unnecessary, as pre-HVOed folios are never passed through the regular
remap path, and all other folios now already have initialized tail
struct pages. A failed optimization either leaves the original vmemmap
in place or restores the tail struct pages from the shared tail page.
Remove the fallback.

For folios that are not HVOed at all, this does not change the amount
of initialization work, only where it is done.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 mm/hugetlb.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4dac7ed1df57..e971e2362412 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3303,17 +3303,6 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 	hugetlb_vmemmap_optimize_bootmem_folios(h, folio_list);
 
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
-		if (!folio_test_hugetlb_vmemmap_optimized(folio)) {
-			/*
-			 * If HVO fails, initialize all tail struct pages
-			 * We do not worry about potential long lock hold
-			 * time as this is early in boot and there should
-			 * be no contention.
-			 */
-			hugetlb_folio_init_tail_vmemmap(folio, h,
-					HUGETLB_VMEMMAP_RESERVE_PAGES,
-					pages_per_huge_page(h));
-		}
 		hugetlb_bootmem_init_migratetype(folio, h);
 		/* Subdivide locks to achieve better parallel performance */
 		spin_lock_irqsave(&hugetlb_lock, flags);
@@ -3337,6 +3326,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		struct page *page = virt_to_page(m);
 		struct folio *folio = (void *)page;
 		const unsigned long pfn = folio_pfn(folio);
+		bool pre_hvo;
 
 		h = m->hstate;
 		/*
@@ -3350,11 +3340,23 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		VM_BUG_ON(!hstate_is_gigantic(h));
 		WARN_ON(folio_ref_count(folio) != 1);
 
+		pre_hvo = vmemmap_optimizable_order(pfn_to_section_compound_order(pfn));
+
+		/*
+		 * Pre-HVOed folios have their tail struct pages mirrored from
+		 * the shared tail page, so only the first vmemmap page needs
+		 * initializing. Otherwise, the tail struct pages (marked noinit
+		 * in alloc_bootmem()) must all be initialized now: the folio
+		 * may still be HVOed via the regular remap path (e.g. if the
+		 * architecture could not determine HVO support at bootmem
+		 * allocation time), which expects valid tail pages.
+		 */
 		hugetlb_folio_init_vmemmap(folio, h,
-					   HUGETLB_VMEMMAP_RESERVE_PAGES);
+					   pre_hvo ? HUGETLB_VMEMMAP_RESERVE_PAGES :
+						     pages_per_huge_page(h));
 		init_new_hugetlb_folio(folio);
 
-		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
+		if (pre_hvo)
 			folio_set_hugetlb_vmemmap_optimized(folio);
 		section_set_compound_order_range(pfn, folio_nr_pages(folio), 0);
 
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


