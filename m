Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24E0EFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 08:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C48D6B0095; Tue, 28 Apr 2026 04:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89CC06B0096; Tue, 28 Apr 2026 04:19:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B21E6B0098; Tue, 28 Apr 2026 04:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CB9F6B0095
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:19:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 04E65120504
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:19:27 +0000 (UTC)
X-FDA: 84707265216.29.67BD94A
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2F0DF8000B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:19:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TLOmhn9H;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777364366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rL183+C/B0Npg+SiHlF1+/ufB8oZmfwNupE6AmX40Ic=;
	b=XYmqYyn/IClk253Ayw8vMNcvYiv+AQ7gGuYt+wJxkPX9EvVTT5J1y8KpXd2+XK6Lq36w43
	DP6ngJrZ/F0dfklzh0efaVquVgNY24dJs2pe2HEqTx/BOm0cTya7linxzSyRkGA8igpf2F
	hvu859h3yAL1sN46u9aknxJpTs+mN8o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777364366; a=rsa-sha256;
	cv=none;
	b=PEJjxmzr/bLxch52M0tDTPdlhfzvw7v7ZoyenV3To2v3NXJQMfzPBFf1Tge6WwSBXj6iTS
	HAgsM3BVCEKhAiSvBfwm6DRkXa3TDC4HJhqkJdAIbqxsW4y9QUXWw0rQo+iNkZYxVXzyzM
	B0uwk9I2n/ov20IgMmzshtuT1loaTh4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TLOmhn9H;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3590042fa8eso8526967a91.1
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777364365; x=1777969165; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rL183+C/B0Npg+SiHlF1+/ufB8oZmfwNupE6AmX40Ic=;
        b=TLOmhn9HZ+s3LqwQLeOa4SRgcymL0qd6dJ5dcvUYJYFzHKSwURLhYiFUGYh58pZSHi
         c3H7H1dwGNWgudrNQnGXnLArJLODpB28wQUKtwK9n4VT6UnB6vHiYQgDFGzk9hb5OIrH
         Mbagua2M18sFRo7ubdGUjBLBTekpLQhOPlH+LA1AmQJrsrc5XKfJFGTfcDvB2S+t1wmE
         j4t01zws7wN/hgohOt2289jBzR2KGAccu9YJ/3fi2GrXJiGk2j8pIoLK+6wY64HUNj3b
         SeI1kWhjT7rEpSNCTF3MgUMA1vPPMjgSYbajHfX3emi6Ba3q8upVK1kJUZaXOqE8czxS
         sTRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777364365; x=1777969165;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rL183+C/B0Npg+SiHlF1+/ufB8oZmfwNupE6AmX40Ic=;
        b=q0jt1PtC9gWYWDC8sQxXmSK9huQ435g9inVgWpvZ/gDQRMUk0J7y2hcuyRTOEy+Fw9
         YUlJAqpE1mYNqWcto6wZGQkih936PKVKPybJ3ATMX8YlcTWFqoZP4qsPpbXLSKYMTh0+
         rpHI7GZpZx68KYr9RKCJYFeJ81KCSVmm5aKysJhaxYNPIBqqDk6dFtoYnaVxppnVogm8
         2Bpq9qVHnMGVl61GU9hecDBec3um6sbsrhGHQGC0YjlR2NHaOVsNaxXvwCXSH/ZfL4Z6
         2RbteLnM6XV9T3sHsIQEnWuN/VzygzbRy6TEUfZWgSaIdy0q/Sar+wxWrh3UxxAYUPNf
         l16Q==
X-Forwarded-Encrypted: i=1; AFNElJ9fEVegTjN8Kn9a3lRMLefvEvAL3Wxy7SqD9WsLtKCQNdkBEW5O3jTi+ZHh4zsxOxZuc+zLkTuyVw==@kvack.org
X-Gm-Message-State: AOJu0YwgI0CJudbOQFJEiQhVieWNUZoAzUwJMWUkSX8S6xev8ZaD+6qB
	Ek6wgOXWvapry9x2wglrVNcvdeAT5wo/tFHMD7tc9Y4aaoHpYipEoc4Uky1TEBT9U3c=
X-Gm-Gg: AeBDietI69Mq1xUEQG6qgidSDQVRm5JpzmWNOJLKnaKHTJSvHZAYZpctbaL7GRQRdE8
	vl7ITBcQnWtibTXc7XZNB/WVJdBVwbnhURz1h7SGgCzKlbLLrGLcyO+TRkAhs5k4nXn84qJZRrr
	3s3bJVoibI2qd1/8YFgXdZBViNj0oYCyE4dKjrSbbLm04U9qe9r1cNKY/rkzWx9O1PAhv8sZIDT
	9cI4hfnNMmpJYqfRBOnY/X38Oj6uKl0luULqmI1dRENayHO/l58UxYoyT3vmLVv/t3k6heEoWln
	VkkmmczYMa9YZ0qBvdMMkH+Ryq82YgTHh4KvN9ViMd351lm0XtZHrvCFo7Ecw/7EizHkRHRlluI
	i2hcCO4c4Y+hgkSwNokv4UEXTbwkBpve977J37xRb1Ua+fpCIUjyhDANQD4xAYZNvRQKRg1uvvk
	hABkngRquaZ9145+uat4qkre84GqyM6/oLBgxMC0WL5gD8jZYz0eVS3TinNsB/BcXx3w==
X-Received: by 2002:a17:90b:56cf:b0:35b:96bb:47ba with SMTP id 98e67ed59e1d1-364921a915dmr2295268a91.26.1777364364837;
        Tue, 28 Apr 2026 01:19:24 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3649003650esm2181356a91.8.2026.04.28.01.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 01:19:24 -0700 (PDT)
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
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v8 4/6] mm/sparse-vmemmap: Fix DAX vmemmap accounting with optimization
Date: Tue, 28 Apr 2026 16:18:53 +0800
Message-Id: <20260428081855.1249045-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260428081855.1249045-1-songmuchun@bytedance.com>
References: <20260428081855.1249045-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2F0DF8000B
X-Stat-Signature: 46xek8oro81dsy6dj3ekcshk9cnx8ahh
X-Rspam-User: 
X-HE-Tag: 1777364365-707414
X-HE-Meta: U2FsdGVkX1/brVy3seqTBTgceMoQnrA/T4PGRALFPreWt7pvbBdI1I0HpJOfvI6XglvrbxZMWtmAph19RPtljWqso75Rl0tNxiUZSlbP12kPls1odt/FKfvO66dIAnz2sbaXD3x31LFcYljs1yej9bEtj90Rcqk9cC98KIJpBUUJl7k26wIX5qn6m5myYkn6LMU5eMmY1owDIKwyIErdHIR6LymifTdrwZlD6LAtmcAMa30dxVnhhM0jqzaUlrgbwzzPsCX4HkxsyGS0GVafmcQODLgj/qid1GRt/DwsJyC+XnvRvn6fSgZgUl8o7dMkFoQ6RIdRMHEj2FCxEdmC4hlLxpPIBg8jkxPlVc7JkbLjlxqkxratZwWVuoBuW8EMqHFIkhbnb9SHsK+yFAYXJXhouA1zevFpBNen0hIW3v9vNYooRSAT0kK9M4Ec8Hfrb+24lNQLfR4ZwGc0RYqx+hWrCU9sgrmWhoWslbmrVNc8tMHrn6spwPDKk8hGdUyYtMXuXzVPh6RVstAz4rLLC7vmGKcAthFbHbzL/bM5XizUFpjLog0HljAZNqKrgHaJdP+ztDRvZAj8ivvQqv6IXD4abfjgPLVcIJ8ele5RmOiH4q2K5w5vf5fXUw/Px3GK+YkvnV+rAu8PKutH3dJg4NObi0JRhw20XlYrqdE6dQJHZWCJH/0UgFjsyVkZlYnIhsm8VPTg4XphYt1FSjwEeW6ht4rxLgjEMTfTWwbvyM871HzaQ+4E0PUP6H1iWYFL+D+9pEFqICxXUzs7cb+JjyGQpgWvwDUjy6RF62NpWWsvbCMXFoLPSnO5oQVgwtqWlsPXb5aCeOfaFk1HQLwGBYjDSpqypLdF7LIM65YGjarGSu9j1TZv9dk+ogN+hTDf6ZF79O2BrlzolYirgWZahpAR0COUjrZ00NPD0TkeaLIqA+UdBAhUjYR6IW1Cp5+9ovvzr0vmsjPKTXHeBBd
 Gutw+GK4
 6MsdKTzhGUNNT84xg4ZcAtbHmguUZJtfweonz2KiKN7SRPeNphV3LJJNIC/vckQCj1Jfzkl/7I4gHvs3YeOp4Ww9n773be90kBKF+BRisTbB/oZHVXd0b2T8x9GvP8MGiYTpyej1o8NbE+A8hsKHreHNTFwdYnvMvdVwlM5Y5HUkwnCGK2/mT56B7TW+xlaPMM7+oSVvnHakHNT3X2f2cje5VbuYhbZ4i2bSKF1EJMLdi1omcwSNienAVQcuYRm7I2oyLdssVphDmiSdi6pCLRh7a+CuAqJuFRiKznXjjZg4Nq4l/WKEmOzm7DHowHlGna4oBS6D8wpzINNQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When vmemmap optimization is enabled for DAX, the nr_memmap_pages
counter in /proc/vmstat is incorrect. The current code always accounts
for the full, non-optimized vmemmap size, but vmemmap optimization
reduces the actual number of vmemmap pages by reusing tail pages. This
causes the system to overcount vmemmap usage, leading to inaccurate
page statistics in /proc/vmstat.

Fix this by introducing section_nr_vmemmap_pages(), which returns the exact
vmemmap page count for a given pfn range based on whether optimization
is in effect.

Fixes: 15995a352474 ("mm: report per-page metadata information")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v7-v8:
- Move VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION); to the top of
  section_nr_vmemmap_pages().
- Add Acked-by from David.
---
 mm/sparse-vmemmap.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 3340f6d30b01..932082296e8d 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -652,6 +652,31 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 	}
 }
 
+static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+{
+	const unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
+	const unsigned long pages_per_compound = 1UL << order;
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
+	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
+
+	if (!vmemmap_can_optimize(altmap, pgmap))
+		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
+
+	if (order < PFN_SECTION_SHIFT) {
+		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
+		return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
+	}
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
+
+	if (IS_ALIGNED(pfn, pages_per_compound))
+		return VMEMMAP_RESERVE_NR;
+
+	return 0;
+}
+
 static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
@@ -659,7 +684,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
 						      pgmap);
 
-	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
+	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
 
 	return page;
 }
@@ -670,7 +695,7 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
+	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
 	vmemmap_free(start, end, altmap);
 }
 
@@ -678,9 +703,10 @@ static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long start = (unsigned long)memmap;
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
+	unsigned long pfn = page_to_pfn(memmap);
 
-	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
-						  PAGE_SIZE)));
+	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
+							NULL, NULL));
 	vmemmap_free(start, end, NULL);
 }
 
-- 
2.20.1


