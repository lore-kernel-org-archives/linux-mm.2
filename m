Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0257CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51E3E6B0101; Wed, 13 May 2026 09:21:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5C26B0103; Wed, 13 May 2026 09:21:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40B496B0104; Wed, 13 May 2026 09:21:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2AFDC6B0101
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:21:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E992B86D84
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:21:51 +0000 (UTC)
X-FDA: 84762459222.11.531ADDF
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id CB631140014
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:21:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Cj5MwVVG;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bX0eh9yAs1Ger4W6kkJzAbg+VRL/E8mjDpD877qpJLc=;
	b=8g0mKSMIngGEtdSWxb5NFb105fzpk33stTPS701JOdGJ1X2IUnEsGo8T1owiagrFlCp9Di
	J1bz85pqKaJtpCry6NzDw/PTqIhwaf/8phpAnlYvsmDNey4CMtTeUvpAfKrVhZO4q3IZI1
	IWlCQStXEIvu6fJCpnYHmfSdxtYPFvs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Cj5MwVVG;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678509; a=rsa-sha256;
	cv=none;
	b=Cb/cijffrmYvyO9skOTeCw1Jl31X91UldPkiKOGkoBrTKPMgOxHSbci+P7YBzgmLTuorjY
	7yzcXxnpEgaSYTT5S27CKr6KJkLNtLFrkRtnxQQmQ2Es4BZ2TptMiSN4qyOkZqeOLcUdnS
	Owlwof+00/ClHIlm+avs4oAAFBndlx4=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-36622412e97so4354679a91.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678508; x=1779283308; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bX0eh9yAs1Ger4W6kkJzAbg+VRL/E8mjDpD877qpJLc=;
        b=Cj5MwVVG67YoxrRviFZKwQbGBm+CkGZgAmHckdQvbTLJQ+iIFua+XIFqhBxmBqmPlI
         OBqeYAMzzv4ZViCtQ1iI2mObnCjOP98auan5cfslYO4onhvsuE8TLsrYZjX9qr5K4VJW
         DB4/IupLFr5cI10NsiivnFFHY5/GSrBj35BEshKo3PckhascM1N1YGoVDkgUBd7jFhuQ
         Cze4SK/TMFULq8ZN/uwQ4DoQ7KJI57IBWdBHNT44UCb9xIdpdmmLdbJsF+arLjZLw8o9
         BQkXdq/7VBUJr7qgUcD3WolP8BODwbrXu81OFmrAHWYbRpeoRbfpb5LKNZKkMAhK/+qW
         2pAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678508; x=1779283308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bX0eh9yAs1Ger4W6kkJzAbg+VRL/E8mjDpD877qpJLc=;
        b=epc9QjOydLlxtLeCoqEl+Y4G8astv2WBy2CEGqDw+gHHuYvwwY5v0qkkR4Gp1xf3Et
         osEtu2fTuqda66Cx063VjzSJKMaYciVGpcEvCZ3/rfszSloI9r4V6lki5ULpTOu1oVGz
         yRahiVrEXtrBxT8OtKbeBX1K05DlGyhZgBta92XQ7Bnf+sZ1pzYF6fvSjKfXqYBbt4MF
         ObS29PrLOfBMxOgMSwWPjwz4a2ttWQTsgXmyh4rXPV5yu8rSTbrZRS2QudRdOuHnlh9g
         S2UgeMtBNOk/QNzPCQzmOOgPMThPhoEj56fKWfaWabj8JUCBialMA0miopnwxWIUeSre
         mHUQ==
X-Forwarded-Encrypted: i=1; AFNElJ8boqR5l6gMTBNmFDP9mlLuNGYtMJeVM9YDqMhV3+5Jj/LxZUCypih5lpmqvfOaFdLcl8FLmaITLA==@kvack.org
X-Gm-Message-State: AOJu0YxKihu24ihd6F9zJ4Q29M3OcUO+B+a1AbTC6w72NWZaSvQBWwdz
	O8p6Y3YJJSV8VwYBKjmU2FlVL7Cn3zmGPl9zsmGgEVRZRghSuF47Ckv4cfZXeIBnFK0=
X-Gm-Gg: Acq92OGEQ9NsJWoXHwGtSyUe5qF8CG+YRCUCtsB27CQLePB3oUW/0qevrb6krfKVv+B
	V3fiWwIcwNpC+FO6OPaE5mVJWVf+ZajesumQ2tw2Xf8shnXcEVAXKn2XYhw40NKbtvvNMHx+xft
	/nzHIjmmQ1vdmaqadtHlEZXbe+wBHDEIh4fxgM7grvLtkL0XHrB3hPbj3tbrymnlwo3pXtGoQiY
	zJa7PfIwr0UWrAaqT2TmOePHWCG1vyMpxNyqzm38/ua4YRTompL3EkOwd2jgYyyuw23+QOW3sfN
	3SLcNQmdxHe84n/QkP3LYwXaEQ8j1OVYgDjXT+LFvmtJ2IQzoGmF5E50UeXdn6KE63FPuR4PqBw
	8zTjN4roFubMdEFiy48V0Upx+CDG6qjs9LdplOioy4qYDFcMVrUb8pS/Ood8G23OvQPmV9+OK3u
	m9/BriWgUsaaQP+li2y/Gz4uaOytj156Bl89VeK7eCy6q4YYkbuB+u5oRw0ZcQpyyF1cI0fN8=
X-Received: by 2002:a17:90b:3f86:b0:366:33a6:9921 with SMTP id 98e67ed59e1d1-368f3a909b4mr3551470a91.4.1778678508386;
        Wed, 13 May 2026 06:21:48 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.21.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:21:47 -0700 (PDT)
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
Subject: [PATCH v2 55/69] mm/sparse: Decouple section activation from ZONE_DEVICE
Date: Wed, 13 May 2026 21:20:20 +0800
Message-ID: <20260513132044.41690-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CB631140014
X-Stat-Signature: z5eocgw6tckpc7sp4zsm8kzy8ronutdh
X-HE-Tag: 1778678509-66794
X-HE-Meta: U2FsdGVkX1/DBdRhABMgKjRf+U2a88vNZEabsZobRrb5+1UXea51nBuI3xGnIoniHGqYlOIct1iz6bIkhclhxX9F/QPKpyhMW91vcpLGZvsnlMjPN8givf7fwrcmqPBHvgP7mueKLvKyaJMs9z0sCvNZZ0S2ylVQntHrVvOgNWOAVQ1TiO/7iwdH6PoBTsihvFMiZTzKAetk5IsYlYABwpxK6ZEpgdTBIQGaZeaRnln5yuSUxnS+3IdH069ZNR6Hhgp/bhKO0hm55Qn+F9bW5F/LA7QAHqvljUq9yfGNyE7OPplQ7mtu3aa3VqueifFN+BE0nN4wzAGnMbvOzL7MTQ4+Z+SrAEk5148s/JH5rjQ2ZyOKg0uJCqA8OGMjN47dSv/G2YmW6KtIpNjPMUty0OMpxFfqPhvdu7siXeV2V09yMz6vf+r6hUDnZry2u7IG5Opew4MHw1EVo7zjWJo0PAh9v/HAff92JFKLJzriLftVI9uyx5W/1xI8SABvH9wGnjOIHcG8mivI6nPNLA+l6S7e/7bvDzSNRh1wVsoHWPbr6VMAbx6/rkH4j3ii/HvcLwOJH3xhCMS36Ouy8SVCX/eD0nm29dJv0CZCC0lzNbmFS4GWq5RC4aHPMD/60Iiw/o4aqMRvfgObcy7DEdhhbm2Eumq6DjqzDpOEuDBhugDUmGzpJbj/MwiEHO+Wu0YOTR1u9icTIseamemTKHRPrzeSNKkPE5lvtD6AgmeJFR0KQLa4Kdpz1KIsbe6i41oEUVcJFH/diqCnmPN6NcZDyKjX7s76y5CiD9SPGtRpXi7lCaTaYWF+IYtsv2MS3UwaTQVLutGrCWQOzbWBJFWLSOleMMtStWRByr5eGCm71MP3Nx5HEXCaAREOmvhSMBqZVXWot+9QFN8W95yIUS0u/Pnl23Eo0dOXGk/D6QhorfoIwIJmxTwU53zCRxcB8tRxbSVEamR1OEtbHi024Ol
 4hXsE5Fa
 8iQBwlIwDrj8Afso1U+kcwIoTWxGmf42WzCOiVvaI8qnBgvvwXgbylnu9bZ6nPf5/t3u9v6Q1604s01FwuEizWaac1ovukUNaYhtaQJWm4P2ORQjcTUtYhxG6Xm6lDRB2XXciN8KHD8p+x4gUjtM2w14FeszVafluaNBu/iZWVYPC66OzXf+miZz7WSpYNmqbGVFKK+OoSOtOmls7j9k0tCwQ6AS0lUfHqBDTYpBFd0uqmEwwaPenRdT0XEyyUgN3tfTa91XXcPk64jx76fHlr1ZmdrHSVeuvPK03Ig9SULrxrYP8TQZdqwIdmDHgSfADxbaFidUV4NBjd4DgsHlV2Ih5rNlCgcL3hQ8pTI8NIQeMB6WyVFyS624lgb640D8/TpPTXe/tOIObHb0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sparse_add_section()/section_activate() currently takes struct
dev_pagemap only to obtain the compound page order.

Pass the order explicitly instead of routing it through a ZONE_DEVICE
specific structure. This removes the dev_pagemap dependency from the
generic sparse memory population path and keeps the interface usable for
other callers (if possible).

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/memory_hotplug.h |  4 ++--
 mm/memory_hotplug.c            |  4 ++--
 mm/sparse-vmemmap.c            | 14 ++++++--------
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 815e908c4135..083f0abea62d 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -304,8 +304,8 @@ extern void remove_pfn_range_from_zone(struct zone *zone,
 				       unsigned long start_pfn,
 				       unsigned long nr_pages);
 extern int sparse_add_section(int nid, unsigned long pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap);
+		unsigned long nr_pages, unsigned int order,
+		struct vmem_altmap *altmap);
 extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
 				  struct vmem_altmap *altmap);
 extern struct zone *zone_for_pfn_range(enum mmop online_type,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 5c60533677a1..ef1595bdfd3a 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -385,6 +385,7 @@ int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 	unsigned long cur_nr_pages;
 	int err;
 	struct vmem_altmap *altmap = params->altmap;
+	unsigned int order = params->pgmap ? params->pgmap->vmemmap_shift : 0;
 
 	if (WARN_ON_ONCE(!pgprot_val(params->pgprot)))
 		return -EINVAL;
@@ -412,8 +413,7 @@ int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages = min(end_pfn - pfn,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
-		err = sparse_add_section(nid, pfn, cur_nr_pages, altmap,
-					 params->pgmap);
+		err = sparse_add_section(nid, pfn, cur_nr_pages, order, altmap);
 		if (err)
 			break;
 		cond_resched();
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index a807210fe9e1..667424aadd6b 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -613,16 +613,14 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 }
 
 static struct page * __meminit section_activate(int nid, unsigned long pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
+		unsigned long nr_pages, unsigned int order,
+		struct vmem_altmap *altmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 	struct mem_section_usage *usage = NULL;
 	struct page *memmap;
-	unsigned int order;
 	int rc;
 
-	order = pgmap ? pgmap->vmemmap_shift : 0;
 	/* All sub-sections within a section must share the same order. */
 	if (nr_pages < PAGES_PER_SECTION && section_order(ms) && section_order(ms) != order)
 		return ERR_PTR(-ENOTSUPP);
@@ -667,8 +665,8 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
  * @nid: The node to add section on
  * @start_pfn: start pfn of the memory range
  * @nr_pages: number of pfns to add in the section
+ * @order: section order
  * @altmap: alternate pfns to allocate the memmap backing store
- * @pgmap: alternate compound page geometry for devmap mappings
  *
  * This is only intended for hotplug.
  *
@@ -682,8 +680,8 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
  * * -ENOMEM	- Out of memory.
  */
 int __meminit sparse_add_section(int nid, unsigned long start_pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
+		unsigned long nr_pages, unsigned int order,
+		struct vmem_altmap *altmap)
 {
 	unsigned long section_nr = pfn_to_section_nr(start_pfn);
 	struct mem_section *ms;
@@ -694,7 +692,7 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 	if (ret < 0)
 		return ret;
 
-	memmap = section_activate(nid, start_pfn, nr_pages, altmap, pgmap);
+	memmap = section_activate(nid, start_pfn, nr_pages, order, altmap);
 	if (IS_ERR(memmap))
 		return PTR_ERR(memmap);
 
-- 
2.54.0


