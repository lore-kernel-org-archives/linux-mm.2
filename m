Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8100CD6E63
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 14:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21B158E0014; Thu, 13 Nov 2025 09:04:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DE7F8E0015; Thu, 13 Nov 2025 09:04:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD9548E0016; Thu, 13 Nov 2025 09:04:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7778A8E0015
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:04:54 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 427DB13BF95
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:04:54 +0000 (UTC)
X-FDA: 84105754908.05.74A5157
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 830A0A0012
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:04:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rvkNwM0Y;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763042692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B2kwseG7VdP2CzTZFHkFX/MAmkO95iIJxly6opcfs9g=;
	b=0EamHhmTI0dsZrd94FADt8rPi+mRBVNjvWMrLt5e4ODF1YuC9g8DYASdkUP+bx9llRM9vQ
	YV1YX8uDessbA9U5M92b3IgfCuUZoyrqovuOQHgZ8NR7vvz/MZ3Hy2ntjdxnP+1hO2bR68
	BPodO+3Jbx4pRkf+QfgRqG/sHFEv8vg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rvkNwM0Y;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763042692; a=rsa-sha256;
	cv=none;
	b=S6PZKbrSJAqpI2SaoiJoZAb0PHbtTeujDBaL5yOkH1j77zojBO5V0ClqGzw4kKN1LhD0u7
	IeoeUSuoI5vqP8z9k2VbpZLwvtnG5Xryr3WqCGvMBdaF6xOsYjR52kc9tRyaa4oANZltVi
	WM+onw1/SefO6OYuADi+IvDwxtVpKV0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=B2kwseG7VdP2CzTZFHkFX/MAmkO95iIJxly6opcfs9g=; b=rvkNwM0YSscTJBw4suTx0GU2jj
	dhsuaXSZZ9XF2dws2eV5Ww093ovtutmeDdb49K+YwzxoeFAm6yDuJbRTritnleUK8wq2ZNHhyFzVd
	4f/AbM7oODObeyG3eG04FPffMzZ8DbE+VcP9izyyvG6Kxm4knq8J3wpzTbvaMLZ0PAPutKj5Y0BUw
	YKnzJFNmTsL3JLlZE7pOBVP7MF/CYfRSNeAsH7zs4bm1/dFvyuMxC2lunAtddtBSPFHzmVq9s6Sk+
	qOqghfTcgwDxlwwHCDHiaffOl/KLDBcRgndsG5UB0M56cgYuMmkGZ2gX0CZkYIgaCFtmNvsAFXZzS
	hsLZGa5A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJXwQ-00000007c8G-1Y9n;
	Thu, 13 Nov 2025 14:04:50 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Vishal Moola <vishal.moola@gmail.com>,
	linux-mm@kvack.org
Subject: [PATCH 2/4] mm: Account pagetable memory when allocated
Date: Thu, 13 Nov 2025 14:04:44 +0000
Message-ID: <20251113140448.1814860-3-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251113140448.1814860-1-willy@infradead.org>
References: <20251113140448.1814860-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 830A0A0012
X-Stat-Signature: icrmhhsji1cix5s4cqyeg4w7nognjx4b
X-Rspam-User: 
X-HE-Tag: 1763042692-830426
X-HE-Meta: U2FsdGVkX1+StVWIHa/tAXOXPrS3WXm+SFe3kL67rRByOsMsUYFc5gPO1GwsFkBjEiD0J5ZLnRz5T5pjE6qJY4m5hLXzN8eilK6uzIJ7Sq2d6Edkr1Ges8nXsbsI9VAkICpiPlbekMkYnSsErXPMzWKKX5gC7Kqb8vV8MdoCSnK8i+vC8qfgqxvk+No0tXkza2pT5MgmTlKWV22MRzpNfGdHFP2nzjUSozRsvANfZHPROIGEKcizWo+nFq+L3SBGK5lMgDXRO5qh79ZcLX1qsOBL3S1nI7jDcWQAa5Vhcwucp8vrusZQwNZj+p8iM1VkjSXIC0SE0XIRiOnZFT0DhAD0dAgwMQXT5KlIiHboJoLi2O6uJxErsBpGAE0pFFZwXHuMp8HfBYLaSb7pfn0oH6xe2A/eA/lCpRsjkJX9WroRK4sFUYb9FZdjAUi02u3gUBWBtGQMmvu+Z2AaZdKkCLb9HyMRcIr64l8PvCIx6HTdp+AJAan6dY0QlVk8BRCCE4LXFqYKYDEb61pc6vntjuR3AaZvDScQVVQPlnWbRSrfWTSLj2AWJPnoluGITnjg2SKqEBBfPe3fQrkkzBSyBspyUUpdStkNxRmVBH1/p+4bh3aeGIvMh53tRJNu+2teyGLFybR8i9B1QMlZSM3cVks7nROKub1vahN2K4C9hcj32+elL9isrP8J1fEChWVYg69RnyzjvrHRar3r11mpJotRwyI1HzZs2t7eKLx1bFXeXbPyQTYzZncGYRoaoJhiolFB8UNOYgvu7azt629K9esRKZol1t07TnCDX0UwdT83Vk+MtLfkwW0NXWEbnS5jO3/PiFGxB8DJkigjPbPLbgcpC8k/3B8mORKPT4aLRfet5+vVouvyp0eAoO/ic2N5Qp59e40fGgBmIAGSkhz/FNU9FMEuqP/i/uUdlG64kcKNdPSBTfK9XF2R/kEt8DOgmgg8SrVNWMj0vjSjPHo
 3FSq0YCd
 v3GYEZYCZe6QzPCzhqBsMwMV4QpedhP37bhTokIse5+dnjWvlHjmfAUSr1rcQUnTUVw0/vxdItwiYYXal8/MCk0Z4hGIPk1peAHPcO9HF8eaqU29GK17uo2zhg8PNAw1RQ4K77MdgfY7pJO6XmOzdXPViEHY6ctC/genDxBAJOMVFSjlJC9NofIQQYtqaPOfHLkXcK5KZ6AywSJVr9oxLQfwE12AbC5Om8Ov5b+0PU00cG7911AN26NO2MQttFokUfJW3CRhVBisdI1QDSRdk75h3UJvb9puVFwLjr381Wf18gcMiItlWimNQa1OE+0HG3Ec01ppsQ8lvNK3CLYjepPG8y4h2Dc5jzeaniiIjO45jFmg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the accounting from the constructor to the allocation site.
Some of the architecture code is a little complex to reason about,
but I think this is all correct (and slightly more efficient due
to having 'order' as an argument instead of having to retrieve it
from struct page again).

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm.h | 11 -----------
 mm/memory.c        | 16 +++++++++++++---
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e168ee23091e..17f783c04c87 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3082,26 +3082,15 @@ static inline bool ptlock_init(struct ptdesc *ptdesc) { return true; }
 static inline void ptlock_free(struct ptdesc *ptdesc) {}
 #endif /* defined(CONFIG_SPLIT_PTE_PTLOCKS) */
 
-static inline unsigned long ptdesc_nr_pages(const struct ptdesc *ptdesc)
-{
-	return compound_nr(ptdesc_page(ptdesc));
-}
-
 static inline void __pagetable_ctor(struct ptdesc *ptdesc)
 {
-	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
-
 	__SetPageTable(ptdesc_page(ptdesc));
-	mod_node_page_state(pgdat, NR_PAGETABLE, ptdesc_nr_pages(ptdesc));
 }
 
 static inline void pagetable_dtor(struct ptdesc *ptdesc)
 {
-	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
-
 	ptlock_free(ptdesc);
 	__ClearPageTable(ptdesc_page(ptdesc));
-	mod_node_page_state(pgdat, NR_PAGETABLE, -ptdesc_nr_pages(ptdesc));
 }
 
 static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
diff --git a/mm/memory.c b/mm/memory.c
index 781cd7f607f7..35886fde189c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7351,7 +7351,13 @@ long copy_folio_from_user(struct folio *dst_folio,
 struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
 {
 	struct page *page = alloc_frozen_pages_noprof(gfp | __GFP_COMP, order);
+	pg_data_t *pgdat;
 
+	if (!page)
+		return NULL;
+
+	pgdat = NODE_DATA(page_to_nid(page));
+	mod_node_page_state(pgdat, NR_PAGETABLE, 1 << order);
 	return page_ptdesc(page);
 }
 
@@ -7364,12 +7370,16 @@ struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
  */
 void pagetable_free(struct ptdesc *pt)
 {
+	pg_data_t *pgdat = NODE_DATA(memdesc_nid(pt->pt_flags));
 	struct page *page = ptdesc_page(pt);
+	unsigned int order = compound_order(page);
 
-	if (ptdesc_test_kernel(pt))
+	if (ptdesc_test_kernel(pt)) {
 		pagetable_free_kernel(pt);
-	else
-		free_frozen_pages(page, compound_order(page));
+		return;
+	}
+	mod_node_page_state(pgdat, NR_PAGETABLE, -(1L << order));
+	free_frozen_pages(page, order);
 }
 
 #if defined(CONFIG_SPLIT_PTE_PTLOCKS) && ALLOC_SPLIT_PTLOCKS
-- 
2.47.2


