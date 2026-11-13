Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A60660A381E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=UGcAd/KO
Received: by kanga.kvack.org (Postfix)
	id 10C416B0676; Thu, 12 Nov 2026 22:36:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B8E06B0678; Thu, 12 Nov 2026 22:36:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F10186B0679; Thu, 12 Nov 2026 22:36:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C62636B0676
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:36:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 555FA140467
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:36:16 +0000 (UTC)
X-FDA: 85428682752.12.6831C2C
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6C01EA0009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:36:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="UGcAd/KO";
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794540974;
	b=14C0Q9/fJUHCMErCW0oZV4VCw4NFlDDL97qo5QLKnsAskUu39fGaa2KzeXpIutb27lZ8He
	brLltOmTuBWDLKdez1IlMB+1CSZBbl0yn0F/QlUieeT8iCiBQIA79JbvfzfVOV1C+XSzm9
	FQFpYsqXUNztVQBb/YkJ/nZnZXMShHE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="UGcAd/KO";
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794540974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MM3wjom5yAriymyNPmygQnv5oEj8oKEWZWmGqerfl0Q=;
	b=OnkHd+KPYontgCocZ+B3sAOz3lKlevyrklRVNLD5IOoHvnr65djOoVyS0OJiQEMQdifWpk
	O1W8406wEyUfOVSo78YTjAwuoCBYyct4mZkWY367PI/gehDHvL9x6MclXPaanfMyTbWnkG
	rCOOIRL9+PZcU4HSgD+ucDK9eHpxuj4=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-37071c0f42aso830400eec.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794540973; x=1795145773; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MM3wjom5yAriymyNPmygQnv5oEj8oKEWZWmGqerfl0Q=;
        b=UGcAd/KOCO0ZIVXmI4qWKDx14yaIJiw6SEOJlafTEXYE1Pbej3i+IjxQkT0g1dOzX7
         xYlw129RnQzgY4EXLIRHy3wK0FDK/YZ91CTS2qgtjApalNwUt1kBdibsFauVCI93Vhg8
         5cWiliwNx/eiaochJPO7gdh37Hj1JmoDj+Jw4DRWPxokQ5kYxvlu/mgzp7w5XjqTF1kq
         lkTcEpk6uMhKfZr/bxgu11OYy3l34qQOcXG7mdcJjrimyEj4XGlpTjFU2cOC7UQTmHwN
         3YB0x1Oc5lzwP6qn7rY4qqNSXtlhPHM0HEIYHjar//rcb9YuCygeHt+HjudoUl+V0nL3
         GXDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794540973; x=1795145773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MM3wjom5yAriymyNPmygQnv5oEj8oKEWZWmGqerfl0Q=;
        b=0gyDwb6Ki+vhnhNBjqjPTuy+OHvpGJ3FIPHjSTcT8TPPfT86OPSu3S9bY5RWJKFDon
         xLEwZeZJ5rNOh3cj6xK6XWU/kvbfppA5nkATGObl2Z7LwWg/rPJvQ5sBkuAx5/wmZnmQ
         mDz0V9koKSnsAelP0VVkllVZiYjZtWUBxxt0PbALBCWWWY9ON0Zto0dl8MgqsgZAntLN
         LMR1vzstHuXQ8mjR+flnPgj4y7FwrQ1hlxZIMj+Gtnr8SbpP54b7U19PYmJvbu+WH+Wm
         ixEolcMWlN6B1em7xlta/dVAK0Gj7dfdnt42RnKQ4hbERgu6ktkGbcoHqGDkFPf8f3Sr
         09ew==
X-Forwarded-Encrypted: i=1; AL+hErFSs0hp78MwhqHK6SHa3YIp22bLOKXEcWg6MvZrTXJwcoKP/NMmOeb4oinMYp878fltDkiDcfgOsA==@kvack.org
X-Gm-Message-State: APuU4Z/uwDTZnHQruilOB3iAuC9QIHD8dTke2+0kP/4A/YDZ4KYEjZTf
	AqH4ZTtipGzittKqLaLofJm+ZqLXG3YN5xd0vEPBfK+cvcT98jidl22pXtBpp9M2O+Q=
X-Gm-Gg: AYBFou189bkSJewRS8jhKu+CRT5CPA5diXcSr17o0InU+5ZJrB6B38jxOLmJcFNs/f7
	0qddTCDmQsAlzmnv86lK0UF/oDamxaCEdKcxakrliUiIm+OdNeogrEUh3lhEMU7FHmg1hQv70wo
	6FX6Gw0FwBJJBppzebbnmSsrFh6id7bPc17xFBtG35a+8vpHC+PSxPHqldcfnWkxgUexpyf747O
	L7Qb3rOKrHz7hSfp4eloTCJEzARoQ/J/FCRH2eb12Ah9lnhrQ9n1kjBSFoH6gAoo2WFMDAAcqXw
	2N5aMoNzBajAJHNoW3A89tmD5up6BKWUJN32hcxPUPmEa58nfgyPeHVbxTuWQZFYz1t5b9UHoeO
	veMzjd/gj184Nx4SFQPJHmTF09NkjjVr/ETZDDHyiQgm1swJ3zTZ0gYN2H0LOlSh2X+UliC0OGw
	YQR+0/1B9LlQUs4Lw+F2aKpN13YYg3Qf7sk4TB3554GFPfKXaIMigRr8Q8lvRnMX5SqV/8NrL38
	kmHJPdJFNtWzGPMu7L3nMqOZmbm8iEdnhKrN3iZvI7qIYNQAbHBY0gWH5q30HYDll7pgk5+xwTJ
	4adGzKi0wG0LdblNUbUsolM51VkbcEgrGcFEVE1fpqWg5TugavRiwKjJ16OJgg==
X-Received: by 2002:a05:7300:f544:b0:36a:1788:3d1c with SMTP id 5a478bee46e88-3796879f0bemr1153458eec.34.1794540972998;
        Thu, 12 Nov 2026 19:36:12 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955e0d966sm2959426eec.15.2026.11.12.19.36.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 19:36:12 -0800 (PST)
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
Subject: [PATCH v2 12/14] mm/cma: centralize CMA pageblock initialization
Date: Fri, 13 Nov 2026 11:34:40 +0800
Message-ID: <20261113033442.62970-13-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261113033442.62970-1-songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wsd3wugg4af43ihspghn7mbf3myx3m4u
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6C01EA0009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794540974-862798
X-HE-Meta: U2FsdGVkX18mFhHeXAtvn98Ed/w4DtQX/c9HpR3RyIrIyRSJh3bw5locl2/tUSoCGnIUuOrfTIz7DgEJme3QHTfLy9/nNTgojHnhnwXLPNbKQqxA0OckN3wGHAv4tr1nBFczTTj523ze9PjQiiJRW6+RXK027+mB27EmKFXVQsKqWnKCOXT5wsQCQaO43SHiipOgVRwc6e44dScUgZYpuSLVjjEyKXCFcJt/4uNhENKq+pmxH3PFGelKWZq1j/OZjp0ty8TuasOiHbdDOMmR4s6g7LjirfEvacwFmMlLqOAnlIPtUnGs7ZGVAy2KfPmVxnlpqyNZPAe/4VZJyYLa8vEr4VXjQVm0E03EepP1ju0h4JD6NHtAbIsEcdH5knHk4dXYiQ6FU0P38St22OPd0V6waboYJKj6LzthUi4MLBmAaxEsIlyJFXSf8FLO/bXKB7ZnsPulXRbkZLDg8fj99DZ0mNhUM2bVY8ByyTlZAZ5hgXu0ZXKVVEdb236gldnD5WRlkHL5JhEOH2rjDDAM4W4cAU3EuuTJjJ+ffx6bpL4v0oRk3EM028j8VEc1BkI/lrxIVWvrZaAaAJvnJwlcuPD7t7MhyKMRRIfkqh/02obkG4QmEGxjbZdmTXp+++4WGAeZIbzwe6s1ct9vUcB9Uxx8dDmnabKTZM+LFG6npRhT8Glm318t9iyrzz5IQHb1CovDGw4y5/j+QJlvsVzqjpmU7SFjVdFLFszTjtX7ZXhzJbW84wvGixAf7IDtelAd2lZ5N2Ka0ASn+30Rure4qKEzj+3RFUelCK8HF4Dnp6+hfchH0pwcmE7S55nmyQp52ZYvbcLODKYOx1w4yuZ8+0RTypW6MhDkQ5OW2tJS0f1e17e63VUslkMO/DRlVU2ZuYDf7Mcd/2uud369Z+uKpc2uJmoltxiG6Icefp6S+GxEMa15nelzSl0h3lwx33HGp8t3jUFsGMeITU21oF3
 hIwRbfNS
 yn0smMFQ9iI/qxWVyhoNgduA36FtJPXL2zAZty7X2nh432itdSC7ItqHxtLGfvmhUafEzQ8RigEfZ1xdSSrr8T16q2E+sOQvWdyqe0jgrvrSPMNkR5Zls4+5/SzJu+9SIiL4yRJEVQMWUHbUgaMqXprhkd5Yv2PEuznLlY9Zwfv9s9SWl8fvACIPLG1Z7TKeJTp+EhW1nbLb5oJ46NkQHfiMizEnjZPb/v4Rzuom9g+JJg69u6utM47rPqwD9I3jej6CXL0FYPpMNs1ZueisC+3tK9iQpZBajDkZPbfx2gQlUhUWdSAQ20sctVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Early reservations made with cma_reserve_early() currently require callers
to set the pageblock migratetype and update CMA statistics.  These
operations maintain CMA state and should be handled by the CMA core.

Move initialization of early-reserved pageblocks into cma_activate_area(),
alongside the remaining pageblocks.  If activation fails, restore the
managed-page accounting for early-reserved pages because they remain owned
by the caller and are not released by the CMA cleanup path.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/cma.c     | 16 ++++++++++------
 mm/hugetlb.c |  8 +++-----
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index 9ec1d1fd5dff..46e72734ba72 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -163,6 +163,10 @@ static void __init cma_activate_area(struct cma *cma)
 			count = early_pfn[r] - cmr->base_pfn;
 			bitmap_count = cma_bitmap_pages_to_bits(cma, count);
 			bitmap_set(cmr->bitmap, 0, bitmap_count);
+
+			for (pfn = cmr->base_pfn; pfn < early_pfn[r];
+			     pfn += pageblock_nr_pages)
+				init_cma_pageblock(pfn_to_page(pfn));
 		}
 
 		WARN_ON_ONCE(!pfn_valid(cmr->base_pfn));
@@ -191,12 +195,13 @@ static void __init cma_activate_area(struct cma *cma)
 	/* Expose all pages to the buddy, they are useless for CMA. */
 	if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
 		for (r = 0; r < cma->nranges; r++) {
-			unsigned long start_pfn;
-
 			cmr = &cma->ranges[r];
-			start_pfn = r <= allocrange ? early_pfn[r] : cmr->early_pfn;
+			end_pfn = r <= allocrange ? early_pfn[r] : cmr->early_pfn;
+			for (pfn = cmr->base_pfn; pfn < end_pfn; pfn++)
+				adjust_managed_page_count(pfn_to_page(pfn), 1);
+
 			end_pfn = cmr->base_pfn + cmr->count;
-			for (pfn = start_pfn; pfn < end_pfn; pfn++)
+			for (; pfn < end_pfn; pfn++)
 				free_reserved_page(pfn_to_page(pfn));
 		}
 	}
@@ -1110,8 +1115,7 @@ bool cma_intersects(struct cma *cma, unsigned long start, unsigned long end)
  *
  * The caller is responsible for initializing the page structures
  * in the area properly, since this just points to memblock-allocated
- * memory. The caller should subsequently use init_cma_pageblock to
- * set the migrate type and CMA stats  the pageblocks that were reserved.
+ * memory.
  *
  * If the CMA area fails to activate later, memory obtained through
  * this interface is not handed to the page allocator, this is
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6ee36ca5f435..f70c1373235f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3267,9 +3267,7 @@ static void __init hugetlb_bootmem_init_migratetype(struct folio *folio,
 	WARN_ON_ONCE(!pageblock_aligned(folio_pfn(folio)));
 
 	for (i = 0; i < nr_pages; i += pageblock_nr_pages) {
-		if (folio_test_hugetlb_cma(folio))
-			init_cma_pageblock(folio_page(folio, i));
-		else
+		if (!folio_test_hugetlb_cma(folio))
 			init_pageblock_migratetype(folio_page(folio, i),
 					  MIGRATE_MOVABLE, false);
 	}
@@ -3332,8 +3330,8 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		 * in order to fix confusing memory reports from free(1) and
 		 * other side-effects, like CommitLimit going negative.
 		 *
-		 * For CMA pages, this is done in init_cma_pageblock
-		 * (via hugetlb_bootmem_init_migratetype), so skip it here.
+		 * For CMA pages, this is done in cma_activate_area(), so skip
+		 * it here.
 		 */
 		if (hugetlb_early_cma(h))
 			folio_set_hugetlb_cma(folio);
-- 
2.54.0


