Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E0D1F99343
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 07:19:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5BF36B0095; Thu, 23 Apr 2026 03:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0CE46B0096; Thu, 23 Apr 2026 03:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFC106B0098; Thu, 23 Apr 2026 03:19:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AFCC86B0095
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 03:19:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 45201160499
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:19:45 +0000 (UTC)
X-FDA: 84688970730.30.C7B78A4
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5CF304000A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:19:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=i8DFKvYB;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776928783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hLTLnoewwRhtugCkWIDfQqYKu4KougM+msAio3RkTvg=;
	b=6knl05+AXzuBwSyggWZuRqkOsdtVprmP/NYTjk+rp1onI6sT3jifvt5cK9wX6nV2HN4Rm0
	nliW3k3O9r7FYaxXDeUhV4JWFJi1RGbQTOlCbNsFSNjtnRTxOFfxp+Qdsg+3pc3XkBgFCv
	3OshcxOhHL9Iptk3YXhMk7GxVjSPvQM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=i8DFKvYB;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776928783; a=rsa-sha256;
	cv=none;
	b=k+GtSBMm80bqbSlcfJk4odI6Lq5VTdP89cxIMNj6HVqvN7MAC7mD+2p7AlThTYqcIfCaPd
	qg4IfV5er4h2mPXHPF8Fmdos0yO9F7idfhYL1Fve+auoQGIDqNG9rD9g3dGw+MgXOf1+GV
	2BCCAoGh0ANT/w2PMxVjmM8rReQUFu4=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-362bb3260f1so2017611a91.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776928782; x=1777533582; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hLTLnoewwRhtugCkWIDfQqYKu4KougM+msAio3RkTvg=;
        b=i8DFKvYBKWBAuPFtRys51EJkBhw81RBuLC3kXF8111SzPxX1fNSYDyLJwINH4aIOJO
         4Vu+MJOA2ICyKLPFV3v+3RA3cD+/h9eq2FIBIAMDv+2AF39pTVxc1dUXV78QMRrR+xhh
         ZRNr2ihjSA0p8HCd/7B8UM/89fKE3iYXXqTmfnkBKZFRXA/EbETT26M9ISAc/yLucZ5d
         aMQl3CC2/SrMnPoQcKpBlnVn/W7MttDJvJ6VsX+ucpSFyCOcorACnhXcSXa+Zahxm7DG
         suxQE5Fss7eL7Rz0pifEgXC9PVfRdbWnUqoZpiJ7y/1JHuZoZw+WWQrwYdrOTA8F5CIC
         y2zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776928782; x=1777533582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hLTLnoewwRhtugCkWIDfQqYKu4KougM+msAio3RkTvg=;
        b=IM8QRq3QypySF7f1J+t7FycaUzSaQM8hLmgmv9cxJGRyGpj8+WUmAlQtmhGHOZhdpS
         /Ra0mGV6xSfIKqqNXVz8nbuBwXeEkRpY24QxNpgLD9asgRXP6MgY2yUIPAzJZV69RvbL
         r3afCZkxb6Pt4fxaO4W+QXcYp1gCmY4CpIXWnn/bW1ZjY+qgLOnfIpBOW++/az20P+8V
         xwKiGxSAlbbwaUaqQ8NZ3CLm8HhQleniMkqluJXL3Dy6DLcdKacPWZucUwTPmK4cL0+t
         XDiAGsO1rVE2DDA+O9A9egKuXm4+JFemI/1DiDnnmkFWPr4nxgtS+E1HDXd9/OAk+CbC
         IfVA==
X-Forwarded-Encrypted: i=1; AFNElJ9JQ9fvsO0bJT4xg2aud6Dy7xH02mnzvEZgW7MQSLn9His2di+nfvI0R3G9hY8Y8Pdn4ZoCvqVDBw==@kvack.org
X-Gm-Message-State: AOJu0YwPGI7uODAruzjhxQrqZAY9VPQ27xFhKmjYe0XCtXrQ5TD618jj
	ccHs+2hMnzK0Om4dBljGa99c6QXjxL0H3yDVfbfh3zrj0bNP69lQr3DhLW97Q+8O5nk=
X-Gm-Gg: AeBDieteTZJR4ZM1kzvNzX5Sy83/0S5rTSWQ0Fbr3QdeMT2PjO6o1iTsbN3Jj9BFAZI
	Xx1CusyT9MuaCELwaUJJVz05o6IA6uZWdG6HFteozYUkrC1JZlppyCK/BmK3ce/g8UecUEU4n7L
	W4Ux/ZN/7TqzcG4RViJNMLZcsuh6QyBN1B+i+JkusWput5BqcDkLzI5Mxi/+rV2d8kuga3fdpJw
	gM0GgZ0gLx/MSOqlFR8iWPwN1t1e85yQmNKdjBrWM1AquFi+aiTraM/37rZTF7w5Ou0ttxxrNC8
	1HV/s9mo/MJclfZ8J3bLxNFK80u35ffSZNdXS5HcXvIR75Dlg74uvazcrrSpnwYAmabFJli0SYg
	yiwcMsfcFgXs5crszuUc0jVHtbqqDVXqTrDd31mkdCd3WiMOebevUZKOEsMBPr2gpvsfDa+oogi
	gjbTFaFK2YwIm6yNoCCXZmANnF+pl6l2N3guGLi6JHdBwoz782lEGxbA==
X-Received: by 2002:a17:90b:1d8a:b0:35f:b4c1:91f6 with SMTP id 98e67ed59e1d1-361403f2807mr27201547a91.10.1776928782107;
        Thu, 23 Apr 2026 00:19:42 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3613fbd970fsm7092372a91.14.2026.04.23.00.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 00:19:41 -0700 (PDT)
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
Subject: [PATCH v5 v5 4/6] mm/sparse-vmemmap: Fix DAX vmemmap accounting with optimization
Date: Thu, 23 Apr 2026 15:19:09 +0800
Message-Id: <20260423071911.1962859-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260423071911.1962859-1-songmuchun@bytedance.com>
References: <20260423071911.1962859-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5CF304000A
X-Stat-Signature: 3shbah9kwkoh8hqnghdmsdzxsngczhqx
X-Rspam-User: 
X-HE-Tag: 1776928783-197402
X-HE-Meta: U2FsdGVkX1/csorQxU0tYegZ9d+SuZzP9BroIpw1gfFO+UYF4Z/RqdCx3HxpqQZiWnbpTeVEukUhAmz2Uz+tMvT7inG/VTrf7E5mWctXfG9/tewoYl95dMcEG0TcpwDLgmVstPRqGgbMjwecjNkoRn1drl/JHNpyUhnDMOo+XTsEJmmgouVjJ2H4PD0jT9CHd1exC18vLGRFEEI93+H+mPh+h1aMscCUv1ynaCJMyNfnMOufzh9DM0FiPCxLbrdtJigbzaPMRVPpXByBslWsP8fSW6u02QGbVpKTr2isCVGMKPjuD4mypvUorswaqR5SSXUGoNEQwF0CWSPQ7flHqPcux1fLHiQCyL7x3dQnm3Hhf2sWkh7LRVffCCdzo++UPrMLgDY23J8LzmKICj921eofMu9pPOOI2F4U3tU+zmIXiPcx0VvOrCzXShzG+IxCv2ul3HVadWwuOI9GyAUL3iC9w8aXaL1i8d/UskS9BjJy3YH6/NuR4nQz1hz7x1E0mF0TFKkVSUXfdzob6TXKbM5tb1w1o4WmuG90OmJOylnL/vH7XVw+8Mb/kvCe0EvllE2cAURLQrucLQxIdYgGNicHFq1+X3lcchZrUZDx79ThDCEatMlrjYEpD+BumDkkCtPxqXQFFMY8BOJa+vI9clgfxULQ4qU6g3TJphZmzhN9IJG3wDkLOaFSS0bU/7PDz+Of23px6EPK4BIbsf5QMO2dNEMN3ErlSBpJn1Op7EKnQoQRcHCvApbnxwofEzx6GhQYQr0kEUWEAjYi5qGWtSD/887FQ/iyeANm7bskmUUuZPBnMVDIlJkuc2Am0P8DEjX+XK6UVYOc9Fno/YRDwpm5TA83R1qU/kdk8sRE9Kn28h7Vz6uJFmkrL6JT+ddpN/30aFit5i26O/maltoksgs4dDHTpcmyTHUm88JinU7W92KEeEVJAZxzo0+A24vaXcIbjjyHxeHb59C2/Pm
 8ACTOiMq
 5SfMoK9zLO/vVxYi6e94jH432pTeVSGcA0DJ5EXm99vwJajuv75lopvBLJMAr4a28jQE/OUNpZ9m6CDl1D+iTx9pxWU5UzK3ZAOn+JfGUnIfNdetu9ahwypM0sjuy0YDSu8Zu9hoMMVjXJkZFpA3VBpK3ZnncrMTXJhMP4YCEITf+MSKxFeh5pQ1nYyEpTf7mmAgLV7w8t2OLq+HEs7/aCGyx+HMfKzCfOsWqUVvUJmj5FMfqVLcodtGTcbrwoNaHiWhSH/yUozfc+SRLOImLIQ0mGz2xe6gnxpACm4rcZPsISTXTPd5NnMiu9ZyXV7x29rbB42Eyd1q5mA0=
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

Fix this by introducing section_vmemmap_pages(), which returns the exact
vmemmap page count for a given pfn range based on whether optimization
is in effect.

Fixes: 15995a352474 ("mm: report per-page metadata information")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
---
 mm/sparse-vmemmap.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 3340f6d30b01..979d71158c9b 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -652,6 +652,28 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 	}
 }
 
+static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+{
+	const unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
+	const unsigned long pages_per_compound = 1UL << order;
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
+	VM_WARN_ON_ONCE(pfn_to_section_nr(pfn) != pfn_to_section_nr(pfn + nr_pages - 1));
+
+	if (!vmemmap_can_optimize(altmap, pgmap))
+		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
+
+	if (order < PFN_SECTION_SHIFT)
+		return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
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
@@ -659,7 +681,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
 						      pgmap);
 
-	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
+	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
 
 	return page;
 }
@@ -670,7 +692,7 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
+	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
 	vmemmap_free(start, end, altmap);
 }
 
@@ -678,9 +700,10 @@ static void free_map_bootmem(struct page *memmap)
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


