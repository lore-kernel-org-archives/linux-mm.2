Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1149BF94CDF
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 08:15:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 681476B0092; Wed, 22 Apr 2026 04:15:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 632AB6B0093; Wed, 22 Apr 2026 04:15:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FA946B0095; Wed, 22 Apr 2026 04:15:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 400956B0092
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:15:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CAF4FE5647
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:15:03 +0000 (UTC)
X-FDA: 84685481286.03.356702A
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id F0E56120011
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:15:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JiPLSXot;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776845702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=guNzfHlKCo9CNY+Bza9mDTIoReNzZ+M+FnR7lRKuPVg=;
	b=3QZjLattBlQmcLPxvvzL332F0fRe96PduD2lcrizxxlxUWhXjSOQeUog+pEaZPoG/7UYPn
	ydrcHwCYHb1L0Rek+w8uhSVWzgpZ96d7fsqYnsim3hmzIcOBUjpIfM2RElVLbZ3E2mhKQO
	ExBC3giW0XgVKzCFhV4JxGbFwp0+5vg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JiPLSXot;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776845702; a=rsa-sha256;
	cv=none;
	b=bDzrbBBSCW415smdHw4Oq0yhLJ4RkL6NJZg+u78Zjhfr+WNW5gaigylfnqVFvArV9MgEuu
	AyfMlx011A+ZdvUC8HxsifJsiNtwcgGIk3vzN5hHQQn4UT4kRXRZ4IpE4ro8PMC7cE6XHQ
	MqcaSbgbG2BydGS3wKxzNDb/K4U4GbM=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-82cf636dac8so2193648b3a.3
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776845701; x=1777450501; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=guNzfHlKCo9CNY+Bza9mDTIoReNzZ+M+FnR7lRKuPVg=;
        b=JiPLSXotSg9NR+5CYlh8JnlCpccnmDNgYG9GgoGGeFDUYB4Xdnk9/ZuNrYnFRY9Thw
         wqLIXlog9rhTdrDgGOvhgvY3fXaPbDUr3C93EYl6LMYJPw4mijOhz4DR4OfbDvKSrDq+
         ZVYSTrLsFB6IC5v5usKglFHyc8ekz3q188WAqUaYJW94sXkykQJ2M/2k4ExqxMfzwydl
         xQ2C5xjH047o7lglvo2fqOZdYyL8Z4gJ1czTm6vXxozCZHZbe2TCxPbc792HmGaBfl3m
         VKrmB4lwnBDUZDitCSTFwI+IMN0A4O8TokVwkt1W1nvedIgptm3yl1NqT0ajKMHNoDv0
         kfXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776845701; x=1777450501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=guNzfHlKCo9CNY+Bza9mDTIoReNzZ+M+FnR7lRKuPVg=;
        b=s9J9xy9ts0IGHdH1pY+jmBrcaVgCrPenXGjoPIfTcF3ZYeIHdIv+bkL01LdggXFqd/
         VPNQE4aND+mhe9qD5xTqUtfko22JVMM5jrXS9aKmxpswnJ70jghffikEPF9hPFKMBXv5
         TlIkx6+Raewjs3MRimob/x/YXZpUadwcsklzm9y9r2fZX6bvB6+/95R2Q8p+B98Vql7F
         4VO6Dr1kRMFC8npwSkn7HzOMU3Sf4pxxZr42iVyXJUTGc3yx1zl1N47PhOkz/iNUGDNQ
         v+3F6KjbjDvt+YNBgU1mGF0gYUSUyQLShe7cSlHKhKLys/pFwgejZ8Gxfc2TpZEMB77S
         Hvcw==
X-Forwarded-Encrypted: i=1; AFNElJ/pG/6ev/XNy5ShH1ksbfbwFqfYimlRCbvcKsFj56TJYpcYk0mPkoykU0QzVhFYXq9/iWP+m1AXNw==@kvack.org
X-Gm-Message-State: AOJu0Yy76CDpnb2S/XRFH+rAsseR1dTCgcIoBpJoA6/MijmhBN/Zt7w1
	X+80HlmURvz78dtdR2fHBvwNGdA1pI+FmPAUneu+TvBrG6ee4WCUrHbV2MNu4wARy+A=
X-Gm-Gg: AeBDietma3sZpUKyluYcC1tZZJTRSGVR9y4ZmOj9CDwq+bGpY3qSJ6Li1NECWtHiK3N
	aYVRLIBOMkV10QFS0OPl+l4+KfVzKNoZJAG0BuMKM6/s5TFJNqQb6Ld3sfad8dRO430YgRJzCKz
	/MtYJ71zD0mVfRLjR+fNj9+VWALVBDGtZnP+V1LGnTLRjRRPdRwMJL/Ie7rWNLDWggZilorn/dX
	EWtkLmsnLUjSAhbRx0SpzII5PONUx+ZxHzyAz9gNRQIKe1VdAMDwgPxIC+FdTYNoVkMV9IZ3hds
	3S1ARqIzOtT6pKwnM2xcl7wFpjngXwjIqjWcCV4TRWASickjmG4Ps6ApSMHjXcSZ/qxUgy2WgzW
	e5LLf9cFRqh0cxB1L7BO5sKTArtRZQUrpHxh0MHW/bbOpZdoMcYpjV6DZmxJueNIh9162kr40/T
	j80w9HQ5MTl7nTpIUckIr4dUjAj6sK
X-Received: by 2002:a05:6a00:3397:b0:82f:24e:6a50 with SMTP id d2e1a72fcca58-82f8c830359mr23157259b3a.10.1776845700663;
        Wed, 22 Apr 2026 01:15:00 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::34f])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ec0307esm16522874b3a.53.2026.04.22.01.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 01:15:00 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/5] mm/sparse-vmemmap: Fix DAX vmemmap accounting with optimization
Date: Wed, 22 Apr 2026 16:14:18 +0800
Message-Id: <20260422081420.4009847-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260422081420.4009847-1-songmuchun@bytedance.com>
References: <20260422081420.4009847-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tf939ib6gm5qatwtcd4tp9hwucunq359
X-Rspamd-Queue-Id: F0E56120011
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776845701-967605
X-HE-Meta: U2FsdGVkX18QHyrTB0I+TDPzA2K2CNoCbr0QIZfsFq1+Qs419zkadP0ntrd16aHMpucq9ZcPMtfVGx6jSxLo0P8tvmLKnprSp3R7QKbX+kMtivbzOcaikfpvxPo8aUec+C2l4rRfq3Ta9Bd9HG0PGTCnkqePaHASPjXZP2UgrGb2GGqHiL/FUCt5Crmx9dQT2T8wq39t/WJsAbovs1bsSoyEsOxsk69FIud5RKzyEiFIGkh0rEDZxvGAdJ02vrN/IjAD3GGkSbMR0pMVjBbX2HPF1hJRYTiu1qE5JAGpxNn+ekLYXOCj9iARcH+ZnZ558TaSYT0qxTO8SyGq1zgRHt2KKMFZcG6qcvl1RlDIXhpxk4wTDUJSbgr1KyugDsWA+SifVdEBA+fGTrqyqWCEmW8WF3g7w74gVBprTbbPKoduBfj0SP2u/eG19TozhwZ6bi4iWFQD+nEZk4isDpI6XtKn5AB3BOwLJcTwbnGDQGzxADQfyEMikymKHv3WYcECNL86kHiWGnEx1vL/w6mpVoB7IafEBWyBQnCKfBM55sJ8aA6GfT3nHrn4pk00el5bu5cU9e2YYgueQlNaIAmcc2wWJbxwo7aSMZzVx1nC3g6F3liqiPeNK1OKFNdYm8AvRW/c66oH1mU3ZHTjIrpHItsJ102kpL/wr9d9i9z6UTVIW8GUqpPGFLguXDqVj37HpE9h4DRwxT/hQ01HeGGZwCKj/kCzXYvRGpcnCR3sRo7FH4knMPO8vd7THLlEyuUugfCGKD585ZU1D9PUMbPGnk+tx1AhLAtXdPtm31TkRCwpe9lwcpSW/mPGhFi77thYM6kk7HGYMXyHZv43lFhkmGL2mvT4deiZI+7SeloZACb6JKK62+H44clHXacBxJk5NYN0AXidJuD01MF8CcZz+yDnFHVB/+07LrM6cGDm/zBzbtzga6N7HSOs56omufLklquTQ4c0V3AdO8OXUeu
 hZ673f/l
 qlQFwM0u1P6z2DujM4ado+nodaQ9FmoeM935c4M6Nr9K4W/PNOAWj4v3ty8Ld0yPoQQUqOFP//1t98LIL8Hhsa56YMmrmRZ+l/M1F6UxX+32X5YhNV+Fu647AAUpxyYscTfXxgDOpr+tlCWl0JFNQB+hcEx4oAs9hoolY2859ev6IP23gakW57vRJ1FJ1PZ4KJdjDDBU5PfSCSxOQH3RhIbHNuptsa79dXCupy0/HMy3/8rkmAIpgf8A6JjbhABP9Zo0yBFX/v6wNUR2JOZdNCqSleMkGTq6dDGffAFDP/cCUyV7UJN1FlTxPjVJUWYRtChdIPGIr6Nf0M4cJOhQ08T3syg==
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
 mm/sparse-vmemmap.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index c208187a4b00..fcc5e0eda9e7 100644
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
 
@@ -678,9 +701,10 @@ static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long start = (unsigned long)memmap;
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
+	unsigned long pfn = page_to_pfn(memmap);
 
-	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
-						  PAGE_SIZE)));
+	memmap_boot_pages_add(-section_vmemmap_pages(pfn, PAGES_PER_SECTION,
+						     NULL, NULL));
 	vmemmap_free(start, end, NULL);
 }
 
-- 
2.20.1


