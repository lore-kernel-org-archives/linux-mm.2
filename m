Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 734D2F3D5E1
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D290C6B00E4; Sun,  5 Apr 2026 08:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D00966B00E6; Sun,  5 Apr 2026 08:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3D816B00E7; Sun,  5 Apr 2026 08:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B58526B00E4
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:58:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 82D661A0AF2
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:58:09 +0000 (UTC)
X-FDA: 84624505098.29.E45B53B
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id AE18640002
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:58:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JK7JFd4A;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KkFZynHuznCOlBtjfU13B+G62bbJJ2w/QApOyapvamc=;
	b=DV9sK2UchcPpq/7rtHcl949rcjyhTnIH3Jmdqwp4ksPWRVR7SV3cr8cqcqNETRQArDEYm0
	9vtj9edafAq4GDcOFvG3EaKnBiKtb0mliZyoFHfCot+vzDXjsKE+uOOVatoO2d3/hm+/aw
	bsd9IjnVFGauBCMlvdmpq4FNgm6f3hc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393887; a=rsa-sha256;
	cv=none;
	b=MPJDM3iQ5DAXAnGM7rT53bwSeNexG66iyxWTQE9WhwTfDZogzuVv1eqlm8NSUduy+TVa3I
	UFfma8yX5VFqMEHDITqrZ11HSscQ03HrOrEjYDZ5lsehWshXzIuWwuyx8/8yS/AmY98DCx
	mcey3OCtWZx1QcAQtmi9X/sCeZC3fJ8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JK7JFd4A;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35d965648a2so2430011a91.0
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393886; x=1775998686; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KkFZynHuznCOlBtjfU13B+G62bbJJ2w/QApOyapvamc=;
        b=JK7JFd4Aqg/rcyL9OvPIyPHjybgmG8YPqdCpBaZBvXpzL7HTpAqsdUGp7uHQS631zR
         zpFemLotrCAq+j8j/x8Zi54fRlrF+WtvC7JDovQxsBxErS3wo1z8y4lCNscMvEgDzCEb
         AILBtsjw4/glTv9hF5rcTU/hCn9VNkytt5MRROJbjCXySge2Tz2vhZmw+HuBTOZzW809
         rBdAja9lFH9ocyzsL72Y/XlprZsAf2+co6DPXvkZC3RBz75pnNo8bNDVRWzfpNRRn2Xv
         GqgWWSim2lv8ye+WgfZEebo7yq0dSWDObUeRxYKrsRWJqWtg27BdzFKIysiyXc0kxZrp
         hoVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393886; x=1775998686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KkFZynHuznCOlBtjfU13B+G62bbJJ2w/QApOyapvamc=;
        b=L+KNwwCQiERz7PLingYx7Cw1O06kYX3dQDQIKKgbVC1SI9DQdIEEqfka5H+2f9pQYF
         7vzEed4/LgiAsvKLUF6rAyZy6Ka/9pgai70Acn4B/jXA+XQ0WRtlyzCJLdjCl6kmT8Br
         +4bEDbyyReKnGfXTbpwG4Uq6mBdrYYqeVXptSmson58XEPBkcmQf27AGJsfZOxs0YQMa
         ekab5aimRBcWEPbhlu4mPbmKjue+I1xBXzK5xc1GB3kIUwSRg+pdo23zHh1S10ry9hvl
         b1tLyMVg/ooRAZywlYtXej+grf2AaH4jFQoQaAdD2Jpk0cg0b7bWOF3xg1/k/2vdaVBh
         dN/Q==
X-Forwarded-Encrypted: i=1; AJvYcCW4ErJfUOz0CSvSVTCfXbJMbtbW9P+WmDG16mOdJECZNU16kkQf6U5ubF4NU4GFu2+beCO0OF8tpA==@kvack.org
X-Gm-Message-State: AOJu0YytnbBorLyRHZ/8ASnGk2Td3UEKTV6Fsgu2Q/EtQ3dESbxf0QAX
	doh8pWqE72yqRcxeL25ZllLi7YEl/2qT6v/Xhv8NUJApW6bfp3i5PvUOSm+7R7ugC2Q=
X-Gm-Gg: AeBDieunPd41G24IAeYmCrkUrb5K91B8sY3woAZxmXvpLTGuW+Uqh0LgewdLoXGPZlp
	Ew1T/hjDWJz267KvnYOBneC+tuHfOcrksBvEQbqQiJSCgmieo5dqFp9DYzQYloPCTKNmAV+mbqg
	7a/l/ZncYaFVzOCEThRUqjM0rssBjOjQgkpcyWP+N/6EWvXc/hsI8hPx0TmzfpCFbn+CY9GfPej
	SEoRl0VkgtAqm715ebiOQ70r8tugliqJEVGoBNPW+lTGT5SK7nIJ62+oZdeKwwBQGed+sp2pYIi
	WJYQayJR/S/pac3EgYnOAkDAt/aKeoLUimWELBFgyf797ffq5/H95ADg6sOGPgkV8qXE1S9T05E
	kC/PEWZ/+PDz2TSdE3/nGUIjWidfbjrwJMoo0W+8bdhQCSm3vL+mrIuX9VNxBZPlaNDmfSPTT8Q
	t8w1U7YMhtxVDQrjPok33/Xe3uTxbqY5HNyhSsK461/5Y=
X-Received: by 2002:a17:90a:d403:b0:359:3426:c60a with SMTP id 98e67ed59e1d1-35de67da841mr8355420a91.4.1775393886516;
        Sun, 05 Apr 2026 05:58:06 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:58:06 -0700 (PDT)
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
Subject: [PATCH 42/49] mm/sparse-vmemmap: introduce section_vmemmap_page_structs()
Date: Sun,  5 Apr 2026 20:52:33 +0800
Message-Id: <20260405125240.2558577-43-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AE18640002
X-Stat-Signature: 84k1mosf3mbm9fjo4s6fd89zaoscnrpq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775393887-403520
X-HE-Meta: U2FsdGVkX194Ne8OMjwjD80ZdBkAViQHAUfFuEXl7V5WFHwfw6uol9WOm/EuHqWjDrfWORAwyk1lvzb8bGhTjS2J2IS2dcDtt4DmJcjswLbPzelPvTbs8TEULkuBsNrBlehLZEHUmnoBYSAqYi/xNKuOtCpImZrT1LZ1a5YM1E0tSDKRoHdTOxXT1kJO2WoclEiwOjAed1/W1Jh0eyKKfKaYZapqjXYjlddAJLwAt5e9Rudin7BZp/wt23TL++Ix4XTdp2wNxtN+vOCJPcw+6PLpeLfh2aQQgvByi01cRydTjzsJkxeZI4PQ3KJ4+v0t3rSZVJAvxYFc9Wq/NoIh9ZE1p3fUj5Yv/aSr31IolELp4cSETIpiaSQxpT7EaNmTrla3y4lAuOcsYA8xdH4Lv+sSS+iCrajrZTrcQDVa5mU9yMrOPyuGVE7WxnYg7p9j0Ql2zSqHIjs6/sjbhQfqL33M2fmq6nMEqLikb+qRhajt6LZzxtHm/tvWaRSRtmbd2BbvAqPa3eRixcbr4VO3fBVVzo8zHgjE5qbCqXFhIgrJWVuVHb1gq7iKQiKjRNtZKXyW/fiTaAyMKhyOq/godxp3qzrFKKoUIvqQurcIXl33exuGDvV7/IqoGiU+akkJ8+HieCZxltwvfkUJadG2uuGtyAdmmu7CtDiL7CSxxejD3jt2DujyRhAkr1CiucC86u6MsXRHFyO2IqiDP4DRi80O5syza9E01YGO2E+v0nmeZKi4SQLTvUv4lD3zyldCz5uk3Ux86Q05WYpBtNQpxRn5i5tJR/3plMKFMdp5GfNRSdFi4O6uZ9BrZz9G+7Li2JX+kmsZj79770/87g4RXPuI+SiFLwhMSZHlraKfVT0ejzYrTLDmDiexARkwzmMYr7gvEmfVCispUQKBeXY/VFQzl0x1XdgL50CGzhNezQTYmZu+dhi+bXNS/GzqKMOm0NLlcuYUjFz5U2GwK6k
 7300gM2o
 qReaQoYr09gU6YhrabuAOzjqPICaCWB9uXT8aSvzoJBPSE2TFORjsaYAEvFwXOvGl7EeQL0Xi0zxGDfKGGH8GCVhaUNGK3NS9lQIEGtoADV8ZNTe3S3YDTB5ZKOtbOmtL53aGNs8wiXJraxasJW3NXkOSJ+A2REL9hvukTODQJmg5TvrxV6JGI2EbKZw60wRRMO6bepmqo+vvZwLlSfpxJAdl1MfzBaFG4808rnraqWk9wgRl3PYHYTvrV/XhWppTrzzhMaJRYEd3FTfmn2iiS6q4ZrXGF5ypVQLCd7K/lr7xxtst7zfkMmHtmeM0lxXiqlCY9mz738aBCSDhJk4XZD6e+Ei616Ic80cftN69AOszYwo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function compound_nr_pages() in mm_init.c was introduced to determine
how many unique struct pages need to be initialized when vmemmap optimization
is enabled. However, it exposes sparse_vmemmap internals to mm_init.c.

Now that DAX and HugeTLB vmemmap optimizations are unified and simplified,
we can expose a cleaner API from sparse.c to calculate the exact number
of struct page structures needed.

Introduce section_vmemmap_page_structs() which returns the number of
page structs that require initialization, rather than the number of physical
vmemmap pages to allocate. This perfectly aligns with the requirements
of memmap_init_zone_device().

As a result:
1. compound_nr_pages() is removed entirely.
2. The internal section_vmemmap_pages() in sparse.c is rewritten as
   a simple wrapper that calculates the number of physical pages based
   on section_vmemmap_page_structs().
3. A restrictive VM_BUG_ON spanning sections is removed, safely allowing
   compound pages (like 1G DAX pages) to cross section boundaries during
   device memory initialization.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/internal.h |  8 +++++++-
 mm/mm_init.c  | 21 +--------------------
 mm/sparse.c   |  9 ++++-----
 3 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 7f0731e5c84f..02064f21bfe1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -998,7 +998,13 @@ static inline void __section_mark_present(struct mem_section *ms,
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }
 
-int section_vmemmap_pages(unsigned long pfn, unsigned long nr_pages);
+int section_vmemmap_page_structs(unsigned long pfn, unsigned long nr_pages);
+
+static inline int section_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
+{
+	return DIV_ROUND_UP(section_vmemmap_page_structs(pfn, nr_pages) *
+			    sizeof(struct page), PAGE_SIZE);
+}
 #else
 static inline void memblocks_present(void) {}
 static inline void sparse_init(void) {}
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 6b23b5f02544..74ccc556bf6e 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1060,24 +1060,6 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	}
 }
 
-/*
- * With compound page geometry and when struct pages are stored in ram most
- * tail pages are reused. Consequently, the amount of unique struct pages to
- * initialize is a lot smaller that the total amount of struct pages being
- * mapped. This is a paired / mild layering violation with explicit knowledge
- * of how the sparse_vmemmap internals handle compound pages in the lack
- * of an altmap.
- */
-static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
-					      struct dev_pagemap *pgmap,
-					      const struct mem_section *ms)
-{
-	if (!section_vmemmap_optimizable(ms))
-		return pgmap_vmemmap_nr(pgmap);
-
-	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
-}
-
 static void __ref memmap_init_compound(struct page *head,
 				       unsigned long head_pfn,
 				       unsigned long zone_idx, int nid,
@@ -1141,8 +1123,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(altmap, pgmap,
-						       __pfn_to_section(pfn)));
+				     section_vmemmap_page_structs(pfn, pfns_per_compound));
 	}
 
 	/*
diff --git a/mm/sparse.c b/mm/sparse.c
index 163bb17bba96..400542302ad4 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -345,23 +345,22 @@ static void __init sparse_usage_fini(void)
 	sparse_usagebuf = sparse_usagebuf_end = NULL;
 }
 
-int __meminit section_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
+int __meminit section_vmemmap_page_structs(unsigned long pfn, unsigned long nr_pages)
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
 	unsigned int order = section_order(ms);
 	unsigned long pages_per_compound = 1L << order;
 
 	VM_BUG_ON(!IS_ALIGNED(pfn | nr_pages, min(pages_per_compound, PAGES_PER_SECTION)));
-	VM_BUG_ON(pfn_to_section_nr(pfn) != pfn_to_section_nr(pfn + nr_pages - 1));
 
 	if (!section_vmemmap_optimizable(ms))
-		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
+		return nr_pages;
 
 	if (order < PFN_SECTION_SHIFT)
-		return OPTIMIZED_FOLIO_VMEMMAP_PAGES * nr_pages / pages_per_compound;
+		return OPTIMIZED_FOLIO_VMEMMAP_PAGE_STRUCTS * nr_pages / pages_per_compound;
 
 	if (IS_ALIGNED(pfn, pages_per_compound))
-		return OPTIMIZED_FOLIO_VMEMMAP_PAGES;
+		return OPTIMIZED_FOLIO_VMEMMAP_PAGE_STRUCTS;
 
 	return 0;
 }
-- 
2.20.1


