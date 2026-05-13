Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90F71CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02D266B00EC; Wed, 13 May 2026 09:11:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 005816B00EE; Wed, 13 May 2026 09:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5CB76B00EF; Wed, 13 May 2026 09:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D56526B00EC
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:11:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4BB21C0011
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:11:42 +0000 (UTC)
X-FDA: 84762433644.04.36F70C0
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id DAAA680005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:11:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=b238QmuK;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cQTyOkGmfxy6eUFBRtUP+rZk74jFDbmzM0hnLmumWs8=;
	b=q29ygyVbxm+Uzk5AyJkvaJeJ/ymd2iQSd80KweZ/13Nm1o/4uSySIQgpGu4Ida/kJexlc1
	X+6GPePyeFwIYiL4trR4LxOeAjVITib/L5PitA1GHRNbx7dV7NEKyNRyKDcwH5eXiw84n1
	a/1qKsHvYVH1GQJSVUClJ6yRx7ibGy4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=b238QmuK;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677900; a=rsa-sha256;
	cv=none;
	b=moUl0zEsZK08rThQnAYFmmmn/MeADTqC+ZQbUrQD1PwSDtC/rLssfnLF6vlx+No8vAwBWW
	wEXTRJND6F1d5QV3XqgWoVreGiA9r9dzeMoKjM2nqeynWOE3oML3M95xmil5owc/NFxEaF
	VjULMk1oXij/5t18JNLZg2ee+e6DIGc=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2bc7b311e77so17545915ad.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677900; x=1779282700; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cQTyOkGmfxy6eUFBRtUP+rZk74jFDbmzM0hnLmumWs8=;
        b=b238QmuKFie4fkDLMlnZUUegifwQ3XqmSzYcjpmNduFry87ECvdbOs6InV/tAPU20N
         svyyvtHYzX2gAu2PZSZeRJKIh/jje+iv74CJl6ZcyK9AxguCXkBjKAfPi5CQPda6lcrH
         rGAUQTvPbtdIGQgvWjdwtL0ejL4tc9T8UD0EkDT8vVpnsEb6Xt0OWN8uts237VD3K6W6
         fvdBayv6PmSFtdhO2K3c+hZjKupOgzX7FKWGf9vlMPYn0/scOyQOK6nfxEID3kixswuU
         aWZcKWwnV7TXyi3uRB3ZarZzOd0MV8NAaR7yviINHI3U/lRm7PLEdNZdCMcXHc+OqTlg
         rAkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677900; x=1779282700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cQTyOkGmfxy6eUFBRtUP+rZk74jFDbmzM0hnLmumWs8=;
        b=s7+gLFIn02v9aW+Y7G2440AdpPZDVNwgJ5W/XB1IdkhPfyg/Ik+yla2ntjBSQKB8Fn
         BoyaYbUrNoRvcENoX/mFyx0bgAQlWCavzfqQo9uPLGPuH3YC1MkbuAYkYrvaX4w70Ek1
         OoMPn3UIfK/VuARAMA3Ex9c6ceLI5nhLPL7KnNe9on2q1jh7Zhlf7nDroxUFhIlX+cV4
         CvxU57w4nPfTUuqjej8sHo0Xt0tmfXyCAekJ8y8scAqE8qU9rsga51JpasBfY+ckL4e/
         AcaHcaDN1m+O0W+yy6R3W9T4LDp3RZqR3riDRNm5KKP9K5PpR5QrvQo/Qvv2//TlWgXk
         RoeQ==
X-Forwarded-Encrypted: i=1; AFNElJ+aflYKYLbP9brVSY7MjdVqfCfbmZRqWqW+ABohhZppcs7T2Vo0mw5C+rJ6z/uwjrwn4ePylYy00Q==@kvack.org
X-Gm-Message-State: AOJu0YxtGGjwLRzD8t12cf503kbo6zhR2avQRpLlSH1fz5vboK9WELup
	WPCZB8ljgv/oiMfPeNr6ORebcL8zCBgLAB/Zucd4V9DE8rdEk3YqrmKaK0rp/F+sHts=
X-Gm-Gg: Acq92OFaPn9cW5I/HTsD5bySk0mN6W2cAFmitFKfeRCJLRcpRmykHJWTloZoyHRGvJO
	U2ks+lEj3yZK1LUI07+05RMt62vvH+lUgK8GsTAxOGb0lV6pp5NVx0E0O4nYCvOCNpIBbTVfHKq
	eaezf/nmQxD0Qx2HkldkvrqCzYLk2eeywo2W4hMwOBw+dN/xPPRWXqyATOsbQohY6hrOASKSkq5
	kehbLU0ADNljkHnx2Urf+cHyUz+NtUtgXFPDtUy1G4pzS7q0uORWvIWFqdHhjokwsilLeXpB4a/
	tSyktgoNwiG0hU63hXqpVx3Hh8Y3SwZcZ5kvwDBqEJJCH3XT+Zxufi1Ls5WfywEg9sk+3rCp8j3
	4ZfwAZm7EJ3E+hYjn1ofcTJHAJQxIvva4gdiJwciAnjW1bOgeCwVUnqASS95QkEZ49n6d2MKScE
	OuEX79j5sHjSDqOtRujEJQHNEprqZ63o1l+Oa943uD//fA93vhFkabscmvl28=
X-Received: by 2002:a17:902:da2d:b0:2bc:e299:4b3f with SMTP id d9443c01a7336-2bd272a16c6mr34476025ad.10.1778677899685;
        Wed, 13 May 2026 06:11:39 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.11.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:11:39 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 45/69] powerpc/mm: Make vmemmap_populate_compound_pages() static
Date: Wed, 13 May 2026 21:05:13 +0800
Message-ID: <20260513130542.35604-46-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DAAA680005
X-Rspamd-Server: rspam06
X-Stat-Signature: w41uuobxyimu3n93kfjiopgtorsu4e45
X-HE-Tag: 1778677900-9689
X-HE-Meta: U2FsdGVkX18+1vzZl8Ghrie9g0MZ+15NlUjzb4nOBkLKBs0aQ1gkZdwAnhyVHCC3imAsqHiEar9qOCHnWiXNhSRsC6dUQxFGvjaDZwSosCwX85yVVLGE3rS9lhXK5jVAlKLyBBq/cnuZqu2lUla2PN7DDh24CqVr247pwfeGsWgvQj6TPkSfqJudAiHt8nRAc9AQfl5WamIhME9uGe1IkyaJ0vluM6fhsHiysMfGM8EhKYD+1OPJ6907aVdBiXLnFp4VEHx8Z0bEIjEyM47Av2pZ+86sCx0tr1l+FMCl56Gh5FCOBq74cobEKB1G9K2DOw57tWrzdbVw/EHzsfGGCKBhDrwg6SI3FLi3bCGX6o1HIQ8x/NGhYpRsv8NVXpP4J2evRZe5DRwqHEsYN9xKDqi2TpdmERd04f/CzLgxLVDIQDQuBwjEH/NyyAUL2NbiEUaESa33zYDstMs9qolcyEViR09DqNeyNe/N+JF/QKmPd59O1Rc5kQqT8VC5XQtV80jPiUjRocnIiV0kjLTIDfODyA2jcPUKCme1TqFnreQFWzQy+p0rIXLIhxlQLjQ6n3lI/GRLckqWPtg9+KBFBtBxkP8ZjJvAKcsmsnhT5cGCHNtdYnMeNL5j9ED9gG5IgH1KlvssP7g56XUtITHtFEBYoBJTD4+XNMMsAagkgAL/UHOzV3Go6RSgh3IsnPYrh3MICmgeReoeSm+qteRj5ipSWgzTmT9Y/JtSxfOB8nTBGrDY61ayCV5kwrSr6vRVPQ5MTdDMSnxl3+DF9klDemIlH1DWfErT0sotvJAxW5qn7QMndEmfxRYKJh8haybhMRknJAdZbCML0pTbrLN+xr8wWD5Tb8UhCGL712toAALJqzPX/RLLaezm4W4aD0z3CEh++5LUcRYQORDkTi/VlUhxTFb4rxpPvqFbCHeXAeqK/UiAhtpfxCd2aMU0GHyUAUTaVJv5mONiQ3HvxMj
 NVQHuuyc
 G0NwvBIjtgU37IKwGOkqOhUnOqZHBJZrKCwikWw92v9jDgwPuTkXOuVv9HnfMAxk+1RR0YdcN/rV8lwBUcklxKagLIcGmwdUOSZcatBvXfXgQ79O3mYiyO7ZRUn8FbhuBchZeYpsSbbQ/PD7Cifu7u8wnFsikOA3kIEOcM71HtTARz1vl9mO8fOUlcRhuH/VC5PQb2II4HMNpYZQftdNrk3pMP+3vBCV4ZOHmteyU6jO8FV6oKqtEcpDqJzaOPfrMCY5/vgwjSXerGLSBKYRrv3pqClGibj8PUTAzSppO9shrlWmTjZnQ0qXfomKJB4shzlcqvYwBQd8sn1RuHYBaPNbS8hDl8loFpR821Jj12xFPIts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmemmap_populate_compound_pages() is no longer used outside
radix_pgtable.c.

Make it static and drop the unused dev_pagemap and start_pfn
argument from its only remaining caller.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/include/asm/book3s/64/radix.h |  6 ------
 arch/powerpc/mm/book3s64/radix_pgtable.c   | 14 +++++++-------
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index da954e779744..8452a2714cb1 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -356,11 +356,5 @@ int radix__remove_section_mapping(unsigned long start, unsigned long end);
 #define vmemmap_can_optimize vmemmap_can_optimize
 bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 #endif
-
-#define vmemmap_populate_compound_pages vmemmap_populate_compound_pages
-int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-					      unsigned long start,
-					      unsigned long end, int node,
-					      struct dev_pagemap *pgmap);
 #endif /* __ASSEMBLER__ */
 #endif
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index c7f2327681cc..18b24bb891b7 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1109,7 +1109,8 @@ static inline pte_t *vmemmap_pte_alloc(pmd_t *pmdp, int node,
 	return pte_offset_kernel(pmdp, address);
 }
 
-
+static int __meminit vmemmap_populate_compound_pages(unsigned long start,
+						     unsigned long end, int node);
 
 int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, int node,
 				      struct vmem_altmap *altmap)
@@ -1124,7 +1125,7 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	unsigned long pfn = page_to_pfn((struct page *)start);
 
 	if (section_vmemmap_optimizable(__pfn_to_section(pfn)))
-		return vmemmap_populate_compound_pages(pfn, start, end, node, NULL);
+		return vmemmap_populate_compound_pages(start, end, node);
 	/*
 	 * If altmap is present, Make sure we align the start vmemmap addr
 	 * to PAGE_SIZE so that we calculate the correct start_pfn in
@@ -1220,10 +1221,8 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	return 0;
 }
 
-int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-					      unsigned long start,
-					      unsigned long end, int node,
-					      struct dev_pagemap *pgmap)
+static int __meminit vmemmap_populate_compound_pages(unsigned long start,
+						     unsigned long end, int node)
 {
 	/*
 	 * we want to map things as base page size mapping so that
@@ -1238,8 +1237,9 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	pmd_t *pmd;
 	pte_t *pte;
 	struct page *tail_page;
-	const struct mem_section *ms = __pfn_to_section(start_pfn);
+	const struct mem_section *ms;
 
+	ms = __pfn_to_section(page_to_pfn((struct page *)start));
 	tail_page = vmemmap_shared_tail_page(section_order(ms), device_zone(node));
 	if (!tail_page)
 		return -ENOMEM;
-- 
2.54.0


