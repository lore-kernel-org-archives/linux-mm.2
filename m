Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98B89F4198B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 11:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 037176B0096; Wed, 15 Apr 2026 07:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00EA86B0098; Wed, 15 Apr 2026 07:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8D8B6B0099; Wed, 15 Apr 2026 07:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DB8C86B0096
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:14:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C42D58A7C
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:14:29 +0000 (UTC)
X-FDA: 84660531858.13.CB6D459
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id A81DCC000D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:14:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fBdblK7l;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776251667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t2IwsSjULj2cdQGLjgGLVnmP99rI03lQ3ndkxR63O5c=;
	b=CWTqOWYrLZNmejQg7RUQKwqiaAabt6n1KCpgD+z0/kH4twt1bK2ictFM4VlecOWGw6UP1o
	ywjNG2FF7/TZOmjBIVDbC/DtPp8Ji6A0FT4BMwFgLW79IKoLgaJ5C0jHnqrPx2pAPYW/NN
	nB6ViDR/87qPqUn0fAqqa5KkZiJB+bg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776251667; a=rsa-sha256;
	cv=none;
	b=Rw2dZ8N6mwU2HXdclzMketPPQ2Vvl7sLYTP4qeTLFLBobCazBgl35bAGY9wi2FdyTm9huy
	zqYnzTTdhZYepMuVDGG63/MvgV7b9L8h6Wqol4Y8pSlsfxICbqToFAwmX7WiDOKCXodcWI
	dy53qRs8br5AcWzQy/Bo32P7AaGmhuE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fBdblK7l;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35d9f68d011so4284095a91.2
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776251666; x=1776856466; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t2IwsSjULj2cdQGLjgGLVnmP99rI03lQ3ndkxR63O5c=;
        b=fBdblK7lxjf+pbgqMKxfC+72bWhyvQu8z9VNE6GLOoxVdHWIX5SbPrhQX5qx1SXkZc
         5g24JjNI+8QWjYvKlqU8FEWMgjTN28f4Ki3WJgGoml2mPyVTlJ+Oo9oH8rBerUmMeVUT
         Lyd6gvQPnjrhGWNRztLfxrErFetp8JHf1vNYgiuzdIqibt9KStcbeRy+YjXEcic6+cfn
         Sh6AZzywAzUsNTs8oQs527FZ/C39mde3QqptD6zL1LQyMc+JGkygiuJc+LKvstJIKNKh
         LSigwoo7ly3r2iF1K3j22xzD2xhlz5ufPvwKr62RIbdDu2tDoOVIYXtaZCGDSY02HlS2
         650g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776251666; x=1776856466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t2IwsSjULj2cdQGLjgGLVnmP99rI03lQ3ndkxR63O5c=;
        b=jfGzmdtfjX8d5QvFmVziab4v3yC0bogJ6uMUTEu1Ij+t8OmV7863X7kIFw9q/ExWch
         0t0MsCNXEJG8jEgvJXsSY46zPyLDiqhiDvVA9uy7554nyE7prLQT7uWV7lDUZnKbNlnI
         x2htK5Tgil0YF6ORo0/KrouI5TFvPE4YASLId1gHjYuG9XIpDp6TXHx063p0REmVobwD
         hESaaHgkFEPpKcAm4V2o1o+k58qGHwUAn+7klEMDcajgGaGS+XeDa3c1ggJjhAj9lh1h
         lrS2RvEhDrnFQGgVKaLDBy9gI0O1xdJ6nSj09ViaTcoVYJ+K2mhDki3WTefy2hNdI870
         wDUw==
X-Forwarded-Encrypted: i=1; AFNElJ800Q8UIPXCueu+RBkKBnjIuD4VsrZuv2Jsu5i9DIB10YLK0fkZa9NBgE1swk0BNbAeYAwfbNSi7g==@kvack.org
X-Gm-Message-State: AOJu0Yx/ShseHDy2Ui4LVNBj/EKJQ/+9n2oaEA017JiQuzHcy0O86v/6
	6sZ8mKKqlRnpEFBYmAbZmGF1XokAnFin+ruBXE4uBa9iYv4M6IisPVDztoo7MSRgimo=
X-Gm-Gg: AeBDievzFd8XSjOvC/XaWbnXtmsnWBx+wlpenFmOiyeyiafLLSo4yzaOtidjKTeQF0y
	MeoeLuM0QedsQO0tTmpQ8D0rfWvdROLhtEemej/mkynUptVU+fBB+GF4FeNP3E1NK1autMpzsvJ
	by+NEEX+Jn4GO+6d1b2/0vZ3rBSrQmqlAjI3hlwtzB9YUDhM3XWJgUUFoFgBpEFqGc+U8wmNC2d
	W+g224V1ndaV5f9w8m1lqc0nxHDDVLHexORNQGkmzvGU/y4YofacWINLX9MwY1Emil0CgqlrhUh
	HCKdUnT/8l4DcHE7lnicdd86RV5A8fFbtiAfb7PlVc1pj0hbaH5UZgMBgmI1J4UXv0BGmKSZWUw
	RjsOhjz9NhU1mauo871VahgfbbDVtiQgat3/8NXUikF/Nw5w+VvX/iCrBXi4jJOhed7XWI97KMI
	FJMIdQKbewpxKKpuSskeSKvaFbuBwCScTSl/H63GxODrI=
X-Received: by 2002:a17:90b:17cd:b0:35f:c1e1:a263 with SMTP id 98e67ed59e1d1-35fc1f0e974mr7643499a91.19.1776251666069;
        Wed, 15 Apr 2026 04:14:26 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b477fd3724sm19509485ad.0.2026.04.15.04.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 04:14:25 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 1/6] mm/sparse-vmemmap: Fix vmemmap accounting underflow
Date: Wed, 15 Apr 2026 19:14:07 +0800
Message-Id: <20260415111412.1003526-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260415111412.1003526-1-songmuchun@bytedance.com>
References: <20260415111412.1003526-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: fdejok95cj7s6uwwo4nq74uqaiib9d9r
X-Rspamd-Queue-Id: A81DCC000D
X-Rspam-User: 
X-HE-Tag: 1776251667-359620
X-HE-Meta: U2FsdGVkX1+HirsSImEcAfiqMO4ibxlZ6n2RlD8r2ygs6Q1oRF9cv4fqoueqGiAb3dDin26eoXmcdbfokhIeFd54UZLgF7tdOCBkxDuAyD8FuSPszHp/xX9qdNYc1TFnS4hhDkkxQOnF4qFIBdMQ6qTzQ3GZMfyzf6DlQ6Wfssjz9iyA0xn9yPbJJFoPvWHD+p+8aES/g5CY0rrCTbIHD5HutIV433gAN5A4+l4oyLrra/gwphiYXMmQl8mrxInVdby2nqxLNVC/KTn7vuPvAlnYjJDaZ3w0322NBavqqsOovPQqv/Ha+WEmrXJdDtoejCT27dsv9eoycW0Sk6ZPWQ99iw/HWLtkOBHxUlFi/8ROFc786pOZgi4Z3owaforPjPe77bnDZRBqml4/sh8oy1U6UEhhD98kjCaQhMMokmGU3WQ8G3/sXkAtI40g+4aVDa7GkGHLgeM0KrUllzE3idbfUesPs7mzYXNid+Lnmk9yX/c/Q3kKx7cauCIOK87SD6F0QMz97Qn2vM1SjBoP8yReYkEvEVhYtUZGanMIDa0jxOirZhSrv6+coZ3h1VFKVHM/sSRQJBnTlJSsySlm1rr+ZSxBGoemv8y9LVbMPn11Nw0NBU/MwWh64K3uu+4VK4oyP86QOPRDh/pDde1JsHgkyPzGMCHTJiPWXr13B2le0P7HJCdKLXsNI69d+fidd2mEU/Lp81xcmuw5mPceMon6VH8dS96GAChyH4qk7z7xEOxO0DJecIpmb2zDDi0xXCSinIoNNXlNHAAB/ZVo/dWSJsz/IZOLSPviI1IW8sfyJs0oseiWWFm5dSHLpcJ2RPHgWR2kKqAaW7+ObMl7V2J3U33fw79oV4N+McelLQDsZpef4WSwmUjZD9WzGDikDwMRnPnyZsSrqSZaazZTGa4SpDqNoymPnSFCCa2Lh7sFDaV+x7YVEd2yEOGeGjYFJRGbtRkk2Ur6wcninPl
 43RaznVu
 BvO4UVnIOsxke+Cfqtiev4tPIiNLFg7/PrqOxHlae2azsngAq3BHRDbOcf3FWUCLlQWNuDLjwKgGkwjuDyjNQCiD+koRag4t16wqh4u85SoWgrOVglsQ3g8HbrbFSAnZEZruWV0xDuiWbPTG62MRmzqU2h4RBZ6yKpFIWD50KRjM5/X9UGfN/x/4jhFlnaBCFFhxnpPXWevdKy71VCsjSHUqcmEBoXm0H5P23RDad1hJmx5sHiF+JqXRBUcT/3LGevqezZDUUDI594ypWI2OZWBLRqxXl35uV6i0J2DwvxIkvam1NSmXn7TvRaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In section_activate(), if populate_section_memmap() fails, the error
handling path calls section_deactivate() to roll back the state. This
causes a vmemmap accounting imbalance.

Since commit c3576889d87b ("mm: fix accounting of memmap pages"),
memmap pages are accounted for only after populate_section_memmap()
succeeds. However, the failure path unconditionally calls
section_deactivate(), which decreases the vmemmap count. Consequently,
a failure in populate_section_memmap() leads to an accounting underflow,
incorrectly reducing the system's tracked vmemmap usage.

Fix this more thoroughly by moving all accounting calls into the lower
level functions that actually perform the vmemmap allocation and freeing:

  - populate_section_memmap() accounts for newly allocated vmemmap pages
  - depopulate_section_memmap() unaccounts when vmemmap is freed
  - free_map_bootmem() handles early bootmem section accounting

This ensures proper accounting in all code paths, including error
handling and early section cases.

Fixes: c3576889d87b ("mm: fix accounting of memmap pages")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 6eadb9d116e4..a7b11248b989 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -656,7 +656,12 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
 {
-	return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
+	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
+						      pgmap);
+
+	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
+
+	return page;
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
@@ -665,13 +670,17 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
+	memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
 	vmemmap_free(start, end, altmap);
 }
+
 static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long start = (unsigned long)memmap;
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 
+	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
+						  PAGE_SIZE)));
 	vmemmap_free(start, end, NULL);
 }
 
@@ -774,14 +783,10 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	 * The memmap of early sections is always fully populated. See
 	 * section_activate() and pfn_valid() .
 	 */
-	if (!section_is_early) {
-		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
+	if (!section_is_early)
 		depopulate_section_memmap(pfn, nr_pages, altmap);
-	} else if (memmap) {
-		memmap_boot_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page),
-							  PAGE_SIZE)));
+	else if (memmap)
 		free_map_bootmem(memmap);
-	}
 
 	if (empty)
 		ms->section_mem_map = (unsigned long)NULL;
@@ -826,7 +831,6 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
 	}
-	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
 
 	return memmap;
 }
-- 
2.20.1


