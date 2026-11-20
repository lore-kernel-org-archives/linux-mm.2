Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEDF2606A326
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=D7c/p4pa
Received: by kanga.kvack.org (Postfix)
	id E383E6B05BA; Fri, 20 Nov 2026 05:09:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0F196B05BB; Fri, 20 Nov 2026 05:09:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25246B05BC; Fri, 20 Nov 2026 05:09:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A649F6B05BA
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:09:46 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2784C40E47
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:09:46 +0000 (UTC)
X-FDA: 85455075972.09.C5A9D86
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1EC0B40007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:09:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="D7c/p4pa";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795169384;
	b=Ju1MZgfhOV3cPK5eFghTLLwKXIAS8Z3bvvpfX8f6FyXZ4giQX7bjvyQcvyr8RXdzv9+8Z9
	1Nis8WHK3XPRG4bdtsnNE3DCrJc68QbuDUsMihqZMfOfj2GOk2ALUdY3NlETP4jWTN2bqn
	5n3RKXvJj2G22NWYZb7/oJO/kBt6yCo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795169384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l3g3NXCa5Yy8bnm/1QaNvVaog3uFqXSNcnEfqktH+0w=;
	b=VgZC5RaMA8DEGl22cFmaUHf9sAY9iLiHkC4BRr0WKJJtRFwNLF5v0bFB//qytUdR+a8I2w
	+tO0K7zbryPY4QG39sf/G92gFFehcwqq2gF/Jh0pGOIi7soOtjgTskiNfcaD1C+5O/vV8Z
	nDmK065zu6Cx9LOTo/5RwTJ/5mgv1Bk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="D7c/p4pa";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cdb9f760337so1034571a12.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795169383; x=1795774183; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l3g3NXCa5Yy8bnm/1QaNvVaog3uFqXSNcnEfqktH+0w=;
        b=D7c/p4paLJFhL1PnBslBQo687YgEy+QrfC3zjhu86xx3pl1HORdlqB19RdrLmnhvW9
         1V2D9X5iImEMcCVmAOCbeCA9pcO/8c9LLuqN/pT0BizTzaP8MX8vbOF8IUDT2FHJCEpv
         U9MfwXadad5jc1aYWyY5dYeduEsfpUTmnfKAL+bU+YHZ2Dcpu5PcvDtaXBktrrIGFuPq
         c7JSpQoRQNVnFbsZpSGyI0DmfWZT/rPYDap1OWvZJqnTDmgzJqYOt4yltok++S9vyxe8
         G8ZI1+LdxDkRDdW90XHJJIhJxogDX5RVOWD8xMSHJC7y7mp8WmIqdlryxNo1o4VooF/W
         irrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795169383; x=1795774183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l3g3NXCa5Yy8bnm/1QaNvVaog3uFqXSNcnEfqktH+0w=;
        b=srwctKLKYvSwl6e+zLekGj3elBPEaX0kFbOBOf5XrDuWbPNhRA9inAw+J44a1VVces
         EhsccgkSdRUnfN52ywV7dJG3UURJGHB99AKmTA5dBhpeAL+nsCPvts1wy6NRALji4G/3
         aDD7uVx7bqKiyCuC/v3z5SImJ17wguSH5+OAGZaXD36YhI/tsGxi0wSUIQZN4OuGISk4
         KT7oTq/L6+iDPrhMU+ckw8qExCdmUg1/BbV0+Hu0JSTRh+c++zLntvCNxD+4Ooxp32V6
         YoESFiaXEFuQqW2uno2uUPwZYwFZwWacyrliJp2r5iW0oqij5cNoJXy3tidDyEdSDFIH
         p02w==
X-Forwarded-Encrypted: i=1; AL+hErGlsu6JB1sbZhqbWWhYHgA6O/9/4NBZblUDVcZtRzyP3/CDXFk4vdxKkAXrQ6OYVUWBliKZRmCnpg==@kvack.org
X-Gm-Message-State: APuU4Z9bTNtlcgvo/AVsj16gWvwYOqCoqbik0bTUL4Ix6Vis0NryIGZ8
	zPUzHNJmm+cpjhjtV7oF3xWlmi7Fk5YuXWpXUrgn3+/1mizz9jUwsNkR/M+tPS//nSg=
X-Gm-Gg: AZFdTZeCDQx2jBsTrpZc3UGAtgaO0SJi08rJbJ8iDxqRcGzlI7l+EvsCUI7KaMVlJ2z
	nhitl3Ipvrbx/k74+bE0jv2aGFa+dn5NwDKB7Jo67AuMP1bj1qRLwYj9aZpke+CA3fHJNni67lX
	O4zn5of3skpjMU0gKBkswnNIv2WRW7FgUHQcNKMXJXctoqG+1tuJTWyC27rlrid9yEJawl5au9l
	QmYkbCxTqKORyrQ0OH78VOe6IJec3fjHMo9crueIZDgsz635c+3oEP4HOQxWgPwXi4nluonp0mb
	UizVbeHpY1nPpgZYoIIvbOT5D5Vc/h3VasgDetageIaOl46twP9XhoPucaOk0pmxaozFxgTJ6tn
	yltxNsKVtV4kKG9DntDxt4Vtxwo1ixgjDjh47nATsB87fq+fkQeK3uyzbfXWPmtNcJUwxSLQ2e1
	9/Z9i72XmtDnbe1nsBlOyaVVImcpJGL0kYh5mc7sr3bvaX+znA/oO+ink9i9cxW1OLcoiehWiOV
	Szz9ISTBSW8yF7RlOmZoiW2110m8k86mGmIyx26iy+Lx1EJKUeaTUD+9taUzZl9aEx0JWMHsZKV
	Y6c78/k41HXHpUdQhDi9d0s1eXtaafO8u9h6MjeXZ6jBEllYkfMUUdOj09LxupNp+Vq74Q==
X-Received: by 2002:a17:90b:39a7:b0:3b0:e388:d9c9 with SMTP id 98e67ed59e1d1-3b41c8e0cf0mr1533477a91.12.1795169382626;
        Fri, 20 Nov 2026 02:09:42 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([203.208.167.151])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe16sm3727321a91.17.2026.11.20.02.09.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 02:09:42 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 04/11] mm/mm_init: factor out compound page initialization
Date: Fri, 20 Nov 2026 18:08:49 +0800
Message-ID: <20261120100856.16929-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120100856.16929-1-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1EC0B40007
X-Stat-Signature: 4r7f13w11o3fqn85ucxqtr8dwbdhiyj8
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795169383-44004
X-HE-Meta: U2FsdGVkX1+s4X7Dah5YANjlIWGXqPB6sfCJdm906VrTRhFZpySmaSqBs6LaAlkbsIgS5GuCUHo9lNeMrtlpjxXN0ruExbBymiuVPNcG9Jj0lAU+KxzxcNI8iBwVVHfITjC4gyu/j0wtG//UxvWlVlzRzYrFpYJC10tE1S8RyQsnXKtSuCPfP2uPs8lM3DbqEy21ANxcp0FGBYtQ+uQFPjzOJWYJ9ConGaC/jdqUFufcL2mqlDxtSeKyjKEVtfwtVDmwmtl7hs+jIqmi5E6ql+oPvd9zRNE2jnsx1tyt54UOUbAPi6SOUZCDXWgyN0AWOgNM0DFGFVJQvkZcKp5jV+02HqGQnoW4ymmRpjDTwekebKB6GG3/gTB9dxJi3DyaqG4NqpgCL1FgYK9h/gviAufbW0K+DVKCIAGYP5YoUf/T7KVWbJ3gMCrkCtCvarXH4VLm3F5WhwWQH17bGZZS26U1w2HNw9rYeWZJcEUU3eioGihDlbHMqg74gznUX0RjHx3cm/M0DPoAL3BrKaLBf/K1cujglufv7wIFcbd3B1KNY7xHDPlyPI2jkU+4NLIexKKmr7Qy7pAYwKaFD/+GjJvG6B6W7i7BFW2PIj8iu5cUKnV43gUZ+BvxMC8OQH05p30+VV7Kdczk4rgtAXZkVx8MzNS7gXQixTFiGq1vVoblzWZ333aLNwZN3GL96vufi7Spb7FaXzjyPdrR4SaJq9l5XXuIrqH4aUhAVecm4xJTgxYFJJ7TsnATHf3yzCjj0+0m9gxmNBA8hcK0yWvu5jB+KaurqVjgdA3qg8rr42VZZnTM865QCdgsUtUaxfHnYPJDZu1sMl3BortuCELgsoLXrX8PmQkhDJe8hAtaabjNtvsq+poviDH0J+MXVRWkFCK6Wht+IjYc+IkbeOZ35jUjRgZs5NPUCvM3sV7x93D4uUpVDrf6hxIxPum58PxeNpR7V3rsJx+UZLT6WB2
 x5BPwL9m
 QnDcde+K5iAy9ze8htSYjN3nkuYCCjEBfQStWpTYyy6kbIuw29bD8j34m82BVhVEtGNzrxJw+3xtnQk3CY72Q40aa+EQj1/GQmVlWubu1n+8STxse2cxAzFIl5ys9ovA7eDEBHr6O7kmXeJR4pkECNPBgvBC9/iKWaieXeKuxH14c2WTQIQpYZjDwuXAqme0gvowhyoq14z2f9Smx1Rmwktx7KH41mYyZLPYl5juSoqIc2eyPj5lBxsYNJgW4k/2oBpvBOkCYNWUQPMxZr8/hMKkzRKwCcUZxFWIaoQA28pYndCkZM4V1uwT0iI2CDwDHp6/LB9TRKGU7RnAX5EvWL6whpCz8wZ+J5kGe0dl+k0CUB92WuKyXWh5LY/4mlN43Fgj1WWMNQqJ4p3xP/yjH8NKqIlFbRIcCYywZMdQnQtR/hHEbM83CsmobY9Pc/6ammlmzVfADjjyZjwi6uZZJMTf826SJ6qdM4q8P7jcN0UHCwzLOsFdQJTpjXZa6S7ATxk3/YRrLuUa2WjTdjr9S0aUstiXRNmbSD+6TZFCDKaLHHC940dZhnGMgMLxZGjMleYyy4WKIDbIQ9ZI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ZONE_DEVICE initializes compound struct pages while their refcounts remain
frozen. The setup is open-coded in memmap_init_compound(), including the
per-page initialization and compound tail preparation.

Factor the common setup into memmap_init_compound_page(). Keep the pgmap
association and MEMORY_DEVICE_GENERIC refcount handling in the
ZONE_DEVICE-specific path.

This provides an MM-internal helper for other early memmap users to
share.

No functional change is intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v3:
- Fold memmap_init_page_from_template() into this patch and make it
  static (suggested by Mike Rapoport)
- Remove the _frozen suffix from memmap_init_compound_page() (suggested
  by Mike Rapoport)
- Rename the ZONE_DEVICE head helper to
  memmap_init_zone_device_folio() and pass a folio (suggested by Mike
  Rapoport)
- Rename memmap_init_zone_device_basepages() to
  memmap_init_zone_device_pages() (suggested by Mike Rapoport)

v2:
- Rebase on memmap_init_page_from_template().
- Rename memmap_init_zone_device_head_page to memmap_init_zone_device_head_fields.
---
 mm/mm_init.c | 143 ++++++++++++++++++++++++++-------------------------
 mm/mm_init.h |   2 +
 2 files changed, 76 insertions(+), 69 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 75d8d17601ed..3e645302377e 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -718,6 +718,45 @@ static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
 	}
 }
 
+static void __meminit memmap_init_page_from_template(struct page *page,
+		unsigned long pfn, const struct zone *zone, struct page *template)
+{
+	/*
+	 * Refresh PFN-dependent fields in the template before the non-temporal
+	 * copy, so the destination page does not need cached stores after
+	 * memcpy_nontemporal().
+	 */
+	set_page_section_from_pfn(template, pfn);
+#ifdef WANT_PAGE_VIRTUAL
+	if (!is_highmem_idx(zone_idx(zone)))
+		set_page_address(template, __va(pfn << PAGE_SHIFT));
+#endif
+	memcpy_nontemporal(page, template, sizeof(*page));
+	vmemmap_optimization_verify_zone(page);
+}
+
+void __meminit memmap_init_compound_page(struct page *head, unsigned long pfn,
+		const struct zone *zone, unsigned int order)
+{
+	unsigned long nr_pages = 1UL << order;
+	struct page template;
+
+	memmap_init_page(&template, zone_idx(zone), zone_to_nid(zone));
+	prep_compound_tail(&template, head, order);
+
+	/* Initialize the head page. */
+	__init_single_page(head, pfn, zone_idx(zone), zone_to_nid(zone));
+	set_page_count(head, 0);
+	__SetPageHead(head);
+
+	if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
+		nr_pages = VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
+	/* Initialize the tail pages from PFN-independent template page. */
+	for (unsigned long i = 1; i < nr_pages; i++)
+		memmap_init_page_from_template(head + i, pfn + i, zone, &template);
+	prep_compound_head(head, order);
+}
+
 struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
@@ -1036,56 +1075,39 @@ static void __init memmap_init(void)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static void zone_device_page_init_from_template(struct page *page,
-		unsigned long pfn, struct page *template)
+static void memmap_init_zone_device_folio(struct folio *folio,
+		struct dev_pagemap *pgmap)
 {
-	set_page_section_from_pfn(template, pfn);
-#ifdef WANT_PAGE_VIRTUAL
-	if (!is_highmem_idx(ZONE_DEVICE))
-		set_page_address(template, __va(pfn << PAGE_SHIFT));
-#endif
-	memcpy_nontemporal(page, template, sizeof(*page));
-	vmemmap_optimization_verify_zone(page);
-}
-
-/*
- * With compound page geometry and when struct pages are stored in ram most
- * tail pages are reused. Consequently, the amount of unique struct pages to
- * initialize is a lot smaller that the total amount of struct pages being
- * mapped. This is a paired / mild layering violation with explicit knowledge
- * of how the sparse_vmemmap internals handle compound pages in the lack
- * of an altmap.
- */
-static inline unsigned long compound_nr_pages(unsigned long pfn,
-					      struct dev_pagemap *pgmap)
-{
-	const struct mem_section *ms = __pfn_to_section(pfn);
-
-	if (!section_vmemmap_optimizable(ms))
-		return pgmap_vmemmap_nr(pgmap);
-
-	return VMEMMAP_OPTIMIZATION_PAGES * (PAGE_SIZE / sizeof(struct page));
+	/*
+	 * MEMORY_DEVICE_GENERIC pages start with a refcount of one; other
+	 * ZONE_DEVICE pages raise it when handed out. Use atomic_set() because
+	 * @folio may be a stack template, while init_page_count() expects a
+	 * memmap-backed page.
+	 */
+	if (pgmap->type == MEMORY_DEVICE_GENERIC)
+		atomic_set(&folio->_refcount, 1);
+	/*
+	 * ZONE_DEVICE pages union ->lru with a ->pgmap back pointer and
+	 * zone_device_data. It is a bug if a ZONE_DEVICE page is ever freed
+	 * or placed on a driver-private list.
+	 */
+	folio->pgmap = pgmap;
+	folio->page.zone_device_data = NULL;
 }
 
-static void __ref memmap_init_compound(struct page *head,
-				       unsigned long head_pfn,
-				       unsigned long zone_idx, int nid,
-				       struct dev_pagemap *pgmap,
-				       unsigned long nr_pages)
+static void memmap_init_zone_device_pages(unsigned long start, unsigned long end,
+		const struct zone *zone, struct dev_pagemap *pgmap)
 {
-	unsigned long pfn, end_pfn = head_pfn + nr_pages;
-	unsigned int order = pgmap->vmemmap_shift;
 	struct page template;
 
-	memmap_init_page(&template, zone_idx, nid);
-	prep_compound_tail(&template, head, order);
+	memmap_init_page(&template, zone_idx(zone), zone_to_nid(zone));
+	memmap_init_zone_device_folio(page_folio(&template), pgmap);
 
-	__SetPageHead(head);
-	/* Initialize the tail pages from template. */
-	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++)
-		zone_device_page_init_from_template(pfn_to_page(pfn), pfn,
-						    &template);
-	prep_compound_head(head, order);
+	for (unsigned long pfn = start; pfn < end; pfn++) {
+		memmap_init_page_from_template(pfn_to_page(pfn), pfn, zone, &template);
+		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+			cond_resched();
+	}
 }
 
 void __ref memmap_init_zone_device(struct zone *zone,
@@ -1094,16 +1116,11 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				   struct dev_pagemap *pgmap)
 {
 	unsigned long pfn, end_pfn = start_pfn + nr_pages;
-	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
 	unsigned int pfns_per_compound = pgmap_vmemmap_nr(pgmap);
-	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
-	int nid = pgdat->node_id;
-	struct page template;
-	struct page *page;
 
-	if (WARN_ON_ONCE(!pgmap || zone_idx != ZONE_DEVICE))
+	if (WARN_ON_ONCE(!pgmap || !zone_is_zone_device(zone)))
 		return;
 
 	/*
@@ -1118,32 +1135,20 @@ void __ref memmap_init_zone_device(struct zone *zone,
 
 	VM_WARN_ON(!IS_ALIGNED(start_pfn | nr_pages, pfns_per_compound));
 
-	memmap_init_page(&template, zone_idx, nid);
-	page_folio(&template)->pgmap = pgmap;
-	/*
-	 * MEMORY_DEVICE_GENERIC pages regain a refcount of one in the free
-	 * path. The remaining ZONE_DEVICE types start from zero here and raise
-	 * the count again when the allocator or driver hands the page out.
-	 */
-	if (pgmap->type == MEMORY_DEVICE_GENERIC)
-		atomic_set(&template._refcount, 1);
+	if (pfns_per_compound == 1) {
+		memmap_init_zone_device_pages(start_pfn, end_pfn, zone, pgmap);
+		goto out;
+	}
 
-	/* Initialize the head pages from template. */
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
-		page = pfn_to_page(pfn);
-
-		zone_device_page_init_from_template(page, pfn, &template);
+		struct page *head = pfn_to_page(pfn);
 
+		memmap_init_compound_page(head, pfn, zone, pgmap->vmemmap_shift);
+		memmap_init_zone_device_folio(page_folio(head), pgmap);
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
-
-		if (pfns_per_compound == 1)
-			continue;
-
-		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(pfn, pgmap));
 	}
-
+out:
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE,
 					 /* isolate */ false, /* atomic */ false);
 
diff --git a/mm/mm_init.h b/mm/mm_init.h
index dec22844f41e..1e6d2f78afdd 100644
--- a/mm/mm_init.h
+++ b/mm/mm_init.h
@@ -112,5 +112,7 @@ void memblock_free_all(void);
 void memmap_init_page(struct page *page, enum zone_type zone, int nid);
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
+void __meminit memmap_init_compound_page(struct page *head, unsigned long pfn,
+		const struct zone *zone, unsigned int order);
 
 #endif /* __MM_MM_INIT_H */
-- 
2.54.0


