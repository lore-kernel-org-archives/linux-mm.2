Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DDD9C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8E376B00A6; Wed, 16 Sep 2026 02:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3E006B00A7; Wed, 16 Sep 2026 02:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92C5F6B00A9; Wed, 16 Sep 2026 02:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 541B96B00A6
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:44:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F31D120627
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:44:42 +0000 (UTC)
X-FDA: 85218687204.13.F122F03
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id E21DC1C0003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:44:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GDVyvUhc;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789541080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iM8j8Wu3fwHIWd8x6lR8eMq2Esw45qvi78c+WOmPzrM=;
	b=Dk8Y/4oBJhXa5Dv2OF21exE7qD/H0YoRnPhphBGGlo9en9pL/KIL0otkPB11XEOkDRkI1p
	wsaxUrK6py8NKrlNmz2kvj4REaIrfI49tgM/xM+WvkqJmN0kx7+TDwoZTqvVTygEuYjrS7
	7c6V/qczB20kYV6sY4qxA2blqIPzq3Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GDVyvUhc;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789541080;
	b=c14kjtiYmjtctur89wUqO7rXGkL0QZFagwo71zHVwMdV6qqYVxMy97Hc9rrvSNNwT7+jeW
	k/CmscqpoTOndTCNw7YGlAbnCGrJ/rq9AnWEKq9AnB1PlnlAqhUCFvw0VnUp+RuNH+Oukx
	Sz26mnW6ckRLS5nNQvx9NmY37lGzE2U=
Received: by mail-pj2-f43.google.com with SMTP id d9443c01a7336-2d747ee1f38so5615505ad.2
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789541080; x=1790145880; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iM8j8Wu3fwHIWd8x6lR8eMq2Esw45qvi78c+WOmPzrM=;
        b=GDVyvUhcVkIKf/1d+nCn7Cx7RVbbq0cvesjeSnT1GN8ilxqIr6zqaOEDA6wek9rc4p
         TwTFkS3EIgwRdjQfOUN1jIC5KeAJNwTrlHil0U/WIUENoWF0qrjASvXnfwEwig/7Q9xH
         W2oYok0giMkAOBPgg8dt8aNC4FTFnDhJLmbGJaGdIwQoiL+tYrJgc9rfFVbTwW6dE6/S
         4a048BJqd82429YGknJIq/BaCC8PJwJlHQLyS2ZQw83uCJvselM3RVnPzlEkijZ8y69C
         3m2y/VrWm7+y1gMrRPnIXfoAsXMS9E9cf2GifggBKPvl2vQMstNBJ0pRLICRCJGMZF2z
         K18Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789541080; x=1790145880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iM8j8Wu3fwHIWd8x6lR8eMq2Esw45qvi78c+WOmPzrM=;
        b=rHOVgMuNNrZHSUDu59Up6e3bTyd+X8KSbDIjB8N/8beqv4Uo3oIuQLI4rR6QZSJ4ps
         NGqYf+C4Wr94yhxyEiELdIa8dJgcCzhx714IUfY6cJ0YEmcc1kpa41iwxCJUuQtstbSp
         7Kdz/WHoUHKymRpdrUalkBwGv9SeYrsx16BxgxFcK4unvyzXyyJDf28dNYlp3IF/qVg2
         UjUpn17cuyDV/+LWLworawi0wf9XVO5v/zr3AuPz8qRsuXOtNjgR/9PAacYdXrmcFw2y
         bJkkgafJ4IUmu/i8cmumvEU9Mz1aSZqqO1/0FuYsnqdg5UoNJGISVxtMhSCh9gX+FRss
         2csw==
X-Gm-Message-State: AFuF++keCCTzf4A7+snhLMVt1ZQrMYWyPql2SVDfTXqL5lRc5fZVzBaK
	fxZJ2glmojA+LSWSRW7SB0VnxNvg5ERRqtOKDgiMeSUc+Xkj3W4aLyFQn+VegcE7+AA=
X-Gm-Gg: AYBFou1pxdjqI8Uq05gKJ2z7Gy6USDrcLp5LYN7WioXYxDsTUwcXsaFO6aW4J+7XnXQ
	JigCicqh7KbOFbOdtr//7Jz36cGrrHfbPZqu8Odw2Gt5C+q5FjDPZkR14zUOJBILRMQ49T9gagw
	zAQRENjd85upxeZFf6kYZGptlUZCBKZ651e+0GG/tpchcFKwXikTKa9d02uxEliv1bNTTaHZWWp
	5RhuXLPyM1vtMwfeaqJcApnp7XxACYVWmnl9l28bPG7U0kojcrbPMw4rmNRbBK+jAaFAvnCMTml
	AgHM8483gaiOKBQ9RugYaLFijYlHDvXUDy5gI/sd6M+QnL3aIQhWsqh6OBDkWxGmUruaIUwUQz3
	KZSdD7gmIZiW7lby8PfwkX/TUvRZkB1gw22PEGI9zeN1Sqblla0z8iJJd29TU1Nx/4wtgJvtGLw
	eFtoOhBq1mGj1s2izcYmuD7VeNSFJfljoONCgYUgck3WXX/NSckGRZG9sbO95FsHA5CYKgNPyWP
	G+Ml9nds8FsUXJC8Mq47szuozeYNg==
X-Received: by 2002:a17:902:c94a:b0:2d8:d4cc:be68 with SMTP id d9443c01a7336-2dd8e7b5ca2mr29021055ad.21.1789541079708;
        Tue, 15 Sep 2026 23:44:39 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f0592asm6074755ad.62.2026.09.15.23.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 23:44:39 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 10/11] mm/sparse-vmemmap: drop unused section_nr_vmemmap_pages() arguments
Date: Wed, 16 Sep 2026 14:43:40 +0800
Message-ID: <20260916064341.1825793-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916064341.1825793-1-songmuchun@bytedance.com>
References: <20260916064341.1825793-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E21DC1C0003
X-Stat-Signature: 5odtup9bqjjsj7n4pkz9ae6fkzng9g8i
X-Rspam-User: 
X-HE-Tag: 1789541080-978841
X-HE-Meta: U2FsdGVkX1+REszuo8ymKBrrYAD7q3mPTf0lQZaR4X3APnmInMD51a76SrV1KIfEuQUy3rHy3vf305YFw0/bxfax0r4yV0TKsM6B/SqQBVP/2iOBpWy/jjP+dlOmtQ7Q6WidvONHM6Gi3INBJcgXvl26ONlrvHAk/1QD/SEPltsxyIApzys4PLgbtoV/T6FM7bEj+zLf7Trqi8hLZ42WtCjBJj8ty8faH377IQykqv3m1jfetJz3vkJ8wtiTMzcdWsxd9X+DLBKJacc6UVJBOUhU4qhh8pJeo5CaVOczbiKF3/rvSvitWOCCkT5+nfeHmolXc7YYGW4IbFr0zGboiFTyAVpTQIFt05n9pbZSt5NyUPwwWOC3xRDw6XkYV3R+sB6yhgM+HFDOmG6SxnrJw7OPaYQ0Mws5D2H9bAcsdfLwlijW/qVQ+rfCbg5QtptxHyY4kx1evpMjOiWrJqvPsZ5Y9wcd3g0lbQGw7egPE28JAY1a0oOEB/6qlBzVVWvp1UB9UXT+pcNSzhR8YTmLbe1JvmdgljgwyPNF8nH0AfneIs10cWYw+UMrpF/iH7rtotMi3y57ahKK4pJAQCOvIGKvt9L1jKK680EbLsuAoL7sYIpm5+KCe2aWvM15/RdsibPUC9/k5OvYzac5AOtDChuMQaM8TbOEat69IW47BZZbRafOWvCD/MTcJBauca4VxLecOIKG2pn1Z8kOaUMcPQQ/jfk2JBsEUZt1mjPtOLwQKilO7NBM/y0nXELc86V2hogFuh9xraf154/p8T+iGY7R8CyYalSO+JHi6Qf9WOQDhbbMCKj8Ud4su43d2kLEG7I9rj8YnGN0vKXWT3PBaqjkZTNBWR9vB0odpjOgOcY4OX9EgMfk+b7KKJtnFWHRYXtjBsmduQZao9Oh/PCHQhTqki9pOZYLYNugQHAcFKDShYEY5tLonNxAID9bgqP8ZTF4AcdIOTVZ4YTT7ji
 6TGzCSK6
 OU8WvnJR7Ixnc2FMYRa+LoxYwips56BYLY3xwc6fuHPG2rrymhPCv6b/IYCv/DbRKfi0YXNqDLpb75jBpS258B+WSvY2o0DQcKpX2d5gXOkgtBVxOGjLxl2C0wUxkQRHzb2lfIJurTQFZ9VHx+YIU5it6e9WwPXcMyMu+lHwgdmOWb2cfhymuAeQ76UyY2mYx1GKxYEmyeYmCwBMg4X5rDDeICLrZrRkGBdXWrAMkmI/v54dUuKlgU6ynTahasMkGapjzMdgZkvZQh+Y16s/vaU2G2XRgkEm7HzBtC2SbTngCE1NOgz1Bnm1GiiQILgPVv91HVAR7uvqUKha4rMuyGuxC5UAEFS7rmUeACE9mAyale5g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_nr_vmemmap_pages() no longer uses the altmap or pgmap
arguments, so drop them from the helper and its callers.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v3:
- Collect Acked-by from Qi Zheng
---
 mm/sparse-vmemmap.c | 10 ++++------
 mm/sparse.c         |  3 +--
 mm/sparse.h         |  6 ++----
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 39f0cfeefc6a..96506f594924 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -131,8 +131,7 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 			start, end - 1);
 }
 
-int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
 	const int order = section_compound_order(ms);
@@ -637,7 +636,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
 						      pgmap);
 
-	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages));
 
 	return page;
 }
@@ -648,7 +647,7 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages));
 	vmemmap_free(start, end, altmap);
 }
 
@@ -658,8 +657,7 @@ static void free_map_bootmem(struct page *memmap)
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 	unsigned long pfn = page_to_pfn(memmap);
 
-	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
-							NULL, NULL));
+	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 	vmemmap_free(start, end, NULL);
 }
 
diff --git a/mm/sparse.c b/mm/sparse.c
index cc28bb41fdb1..b75921c622ed 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -250,8 +250,7 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 						nid, NULL, NULL);
 		if (!map)
 			panic("Failed to allocate memmap for section %lu\n", pnum);
-		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
-							       NULL, NULL));
+		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
 					SECTION_IS_EARLY);
 		usage = (void *)usage + mem_section_usage_size();
diff --git a/mm/sparse.h b/mm/sparse.h
index a5111087ee3a..530692cdd516 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -70,12 +70,10 @@ static inline void sparse_sections_init(void) {}
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 void sparse_init_subsection_map(void);
-int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
+int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages);
 #else
 static inline void sparse_init_subsection_map(void) {}
-static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
 {
 	return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
 }
-- 
2.54.0


