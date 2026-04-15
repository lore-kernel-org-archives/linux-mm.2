Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50CBAF41990
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 11:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B819A6B0099; Wed, 15 Apr 2026 07:14:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B32E66B009B; Wed, 15 Apr 2026 07:14:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48F16B009D; Wed, 15 Apr 2026 07:14:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 95B5A6B0099
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:14:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 35923E0263
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:14:42 +0000 (UTC)
X-FDA: 84660532404.24.08C9083
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4F95840013
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:14:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bTqbpM8O;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776251680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vC2b62MaZVNGL0bmie++eHoqVNtyAoC7qXucopPxUdw=;
	b=VKR4U9w+lpt3odYdVm25EOCJ7sdtCpS5yy8fYfK22bA5u8p9VfjvmlKKG5mJ+kf/hOdRVD
	RbNQXa6gkxLJhyGy1dB6l2+GZf/H0/p9ftn2tvl5gdR1PMAkTLUVeF1eWBdA2WsEm4asqG
	49/OxxrMOoVG5vKC9NEMx9RMPZOdZrc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776251680; a=rsa-sha256;
	cv=none;
	b=GG8aMcf66VtCN/KTs3m5QfZE2+QZwes6awBUWrW06q/asrtElCTL7/np+Aw58Umnv6NhXw
	g2p2FjAGEZpux1v0IiiSt/TjKD2PJvIZGeHRCm4SZxKnNHo4Yxur00s2P/0r0eQ7B/ZmM5
	4F1ZUdlQAya+xTzKcU3tqkgnx0fVBZo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bTqbpM8O;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-35fc0d7c310so1643584a91.1
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776251679; x=1776856479; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vC2b62MaZVNGL0bmie++eHoqVNtyAoC7qXucopPxUdw=;
        b=bTqbpM8Oi0ZvcrejkCxbmLRgutBcZRANY349kxy0Jri5XxUROj+dqb+ytecZ9QjFBY
         DA1q+hEL+MlnZyh6Scq9DvTACEgmwcF8ERTpKRpSK6GTCLiNoJB0IJoSHBWXLUxp4r71
         y5aLtWxO47vaJstLjuGFtsJzqeVl15sa8bnhXXJhpTOy66uKUHM5MhtJ42EwZhLeotGP
         7cyUKZRI3H9Qn61K+6cQhedhXT55s10cP0e6EI2AMY3xahYfB4NuAWxJcKrTZHnk5euA
         dZwyeKVhBwCHXmabgssWYTnLYj/xPKGNmmLrd+ulO8jSGu5tnsKDxfGKrp6XMtQ1y6dd
         gwYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776251679; x=1776856479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vC2b62MaZVNGL0bmie++eHoqVNtyAoC7qXucopPxUdw=;
        b=ERFo5uvFLwUH7W4n2mYwiI3a4CLBT/94DGgK2KLjmDzefLPnT0kjRAoYR7y+APCF8v
         vnax0+FBLQTI68TBP3sHMBhl8fRl5loovU9TCUN2e3aa4gTlOSFjcQG1eFEWXMGx7kO1
         1xHD66KJJiAHXZQDaGiZ8LvnU5AKTvyROAURoxGvhq5+08s37+21/wuOx5XqyNk3/exL
         D1ZX2wh8Tad9prCVNDqwdXFiKn5ImD5mjBUpizKf6KssMU+3BUaICjU7lxEYS286b6Kp
         dhCXtXd+ovbKk04f1U6mfA/esuuPnELY9xek8Poxp01eMAbgLq2J/XM3pmi/msWd4SoX
         5E+Q==
X-Forwarded-Encrypted: i=1; AFNElJ8tUiTG+zENcd+NTZyWEsLX/9eaFtbo/QMm2bhSIjAGvpPtlaanRJU/InHiPPDd1XcMLWyUp86NUg==@kvack.org
X-Gm-Message-State: AOJu0YwfpgDNtBkZCDcY4+J+yWENJNgix+O2epWYLfWUm9zDX2MFyIPF
	lPJuTOmy+tzfPJKdibVHSHEzm70HhADTHGvPJxXj7Gvf7Lhx8lYYvr2oj18Ljh1EcOM=
X-Gm-Gg: AeBDiestubl9bWgnjKvxvwtNSutYnOf7oGt0/Z9mibu1S7pyYpZ8FpBJSP0D37qSKII
	5jzWk8dUkmQ4eEU1bmZQeMTwjdtGyECcn4iKBEWKDKVni6Wbm5hDUQECwO/EYYpXlC/DN3ZezNy
	+zp1sMtpEB5IHlJLON0ndyHQdY722JanfpK4h3TCVcfhoxRDL83GJAkMVhD7o/GqH6g0mJ9H20A
	7Gld3rMF7XDJ4MzS+31uJNv1Ub9NRlTQtHBXQYuCLipreuXMrL0MQxg6U2Kb+d/oPtvIIIg4yiS
	A5aRZ6xjMXjlVTHQxDZ6SW8+7FzgfIfjYS+zTH0Hl5ejmLFfZrRNx5WCke8ebjdzJUfYXAhBSTE
	zVEkxP3k8FZ+tJboTV3CSnus0unKklOH5k+0xhwvlVIdXx32GMmpbnTGZ5aZN9nu5QIJh/+RKfG
	9ctUJllDkLaMewGdiJJkmowY5lUnn+oR+V0u1XwVg1J54=
X-Received: by 2002:a17:903:249:b0:2ae:6192:8d78 with SMTP id d9443c01a7336-2b2d59411dbmr209611585ad.1.1776251679043;
        Wed, 15 Apr 2026 04:14:39 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b477fd3724sm19509485ad.0.2026.04.15.04.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 04:14:38 -0700 (PDT)
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
Subject: [PATCH v2 3/6] mm/sparse-vmemmap: Fix DAX vmemmap accounting with optimization
Date: Wed, 15 Apr 2026 19:14:09 +0800
Message-Id: <20260415111412.1003526-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260415111412.1003526-1-songmuchun@bytedance.com>
References: <20260415111412.1003526-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: s7yrkpru3eawhn3zy8kjn9zna9ptejm9
X-Rspamd-Queue-Id: 4F95840013
X-Rspam-User: 
X-HE-Tag: 1776251680-550413
X-HE-Meta: U2FsdGVkX1+qt4NgUQuWOkAqTHtVcWTbpFOHwRjEeRRTW0qN1UQmdWGC85aD0DuEnWGrM9kLJPOLNjxvA/iDQzHHYTgYATtMv1Q8/I3IBM1P7EBm3jdAHounWS1NrIbv68L8yse9F049IMQ9lnRcM4AXFa3LNwWdv04b81Ei9Vif2Fvw9P3ucbYKAHmaK7fhB9Dxz7vwl4ebFIA9SfPOZhmzzBm4JmZPUk0nglwj8nc6kHiY2IdcSvHupUIjYBNQl4TRw0Tw4I/heyeR+EaYhCzXHt9y8jBmnKv+S6SiljZTGMFaZgjqE97PEScmXYULs4gOr3SxxN6i9IFiOLHlmgc080zNtfPuMT+dA4DMUIQkWG11hEVZTsgScL5cd7VPFDDJGAuXsMJV8ioZjaTeo0RmeiRYZ/TaiClku5tKZEzdP/0XBFMu75AG7WEzRV3DbGMTJI3m1hCPMUpk7vr6wFotCvo4VFKweDO6K0m8vnRNkGcWY1nJPu4VzTZFUEXGd5GdeNTu+gKUjnjm+oO9ndutKx/LetlP5P7tPmV80ZTDsRtMZlLnxvehKeAeJW0qbVe6gI6kf91Mqvx+esvRMeDxI1snP1Cta812NtyWLUm/CCLxB+NjXeOujVpIvmhrxIaGh3YVhrq+lB/+nfxaFJFpFTGTKlyIqcMgUJmhDnf7wHiC48Qm8Fw0xoLXCMh+/i6YyW/pRR4Mk8SRJ1w6YpQwafQf9vllaBg+qGRgni5CQTTlPRVDVsfBLcJdW6xGJjhXeWeXLvAFAZn8C2kNHJBDl4k7n0qij9U79MpAqBy1X1WsSerS7HSE/b1Qm+FBY0/Tqn8BIqRCgFLUII77bkKV1hrf3qpNb6EH2RcazjxrwVdZVsNwzn84fz7RWbUA0pnlZbooZGViUwpB+pRDTqUNXMHo5ClupTpr6M+p97rb9vjvyshmT5MgjEpt6KZgzyoeeL6loH6HJ7cW5A7
 WT0go1CC
 vKOHw3Lf8CG9BXzw8IjrTY3ldZryHAQ0r2P64ijxNCP3oEyN/beKc7yO7LKJwLvLURFGfXpTX8MwtH+L68oATxq7iONM1LOV0N2BzEiZVWwHItQcOtW/fja34F1rZKKwavyguBCJsSsF9Lur6ri0PaB3X1adDIrU/bGvfNszNwHdlAVQROTLutMqJyl2j3zDOUpE8+PJE6+cbHki0o//lFbEz5PiGG9EgLCqWWpb/Cs5COxJGCObNuHa9hHSaTSDPajbBpE53GatLPQ/tSmRD7bGsFQ23rOHmnBwdM2x6PkLWDQ2C478dZhV4bTJkz4pXurn9
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
---
 mm/sparse-vmemmap.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 40290fbc1db4..05e3e2b94e32 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -652,6 +652,29 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 	}
 }
 
+static int __meminit section_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+					   struct vmem_altmap *altmap,
+					   struct dev_pagemap *pgmap)
+{
+	unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
+	unsigned long pages_per_compound = 1L << order;
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, min(pages_per_compound,
+							PAGES_PER_SECTION)));
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
@@ -659,7 +682,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
 						      pgmap);
 
-	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
+	memmap_pages_add(section_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
 
 	return page;
 }
@@ -670,7 +693,7 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
+	memmap_pages_add(-section_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
 	vmemmap_free(start, end, altmap);
 }
 
@@ -679,9 +702,10 @@ static void free_map_bootmem(struct page *memmap, struct vmem_altmap *altmap,
 {
 	unsigned long start = (unsigned long)memmap;
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
+	unsigned long pfn = page_to_pfn(memmap);
 
-	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
-						  PAGE_SIZE)));
+	memmap_boot_pages_add(-section_vmemmap_pages(pfn, PAGES_PER_SECTION,
+						     altmap, pgmap));
 	vmemmap_free(start, end, NULL);
 }
 
-- 
2.20.1


