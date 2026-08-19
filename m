Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5E48C5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF9A56B00B7; Wed, 19 Aug 2026 05:54:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0246B00B8; Wed, 19 Aug 2026 05:54:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE5DD6B00B9; Wed, 19 Aug 2026 05:54:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C27D6B00B7
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:54:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E3B31404B0
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:54:02 +0000 (UTC)
X-FDA: 85117557924.26.5220801
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4E7F81A0003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:54:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kyI1pCIx;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787133240;
	b=AN46Bi3xhoJut8e767CpJqukcQyyxkxhagpjNN8mF2V2x2DUbfrIoJFonLY+APsfdGLRVf
	kWhRkOEPobEI2gbfcjR9Bht9kzFiPEtoVIMlW09ASYtgG3ciWQn3nqRMEDr8bjf/CAEfg3
	NsbqJ7dIjibxnkDqzxefE9d/m/iH3Gw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kyI1pCIx;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JaODolDH1UCHuAYQUYmSzn0eUVKO4ynwv1wpYt0umIM=;
	b=Q9Elg3UFuKzcla4jyQTd2tgn4WrXN2rabG7Q/Y3WYRewcy1DC7VIIq/tEkode1Ek3Qk0Es
	UNpn8EQ23/CjUF/2fLFpunOmDw/CdhLhab7uzVSTGgE8Rz3ON423LLZOAQg2p5kpwTfzto
	xXXPWyyTrlpt0cDBIQkNbLoOsvF/LJo=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d530328efbso7256705ad.0
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787133239; x=1787738039; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JaODolDH1UCHuAYQUYmSzn0eUVKO4ynwv1wpYt0umIM=;
        b=kyI1pCIxGSMtqW99HcejgvhN3sbZj+qmUcub6SUwh2tleAbhxIBQQ8Y0PjPoUi/oEw
         R+KjVdAINnR4K53MS53mpGLgQfeAyWsBjcPkKvuYVuyGcU9sg3bLpWnj8ifA8nsvpd51
         S4yhGXVR3RIK+AEy9dut1CTT+VMSEQdaTzMKwDPMZVcIwGSLc+C/RkhWBomx3+t7S+WL
         JYrDj/sJxeYdHVAVk67lQChA7v5suY9o0umIl5cy05otxRcbyPh+wwIY3EokljFTJgWg
         cithanr/7RCyN+rn7cpfkRgNF0tCD542hlC4kFIhSxMK7rYrRN1wa5dijyRYF+KcWY7A
         IjtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787133239; x=1787738039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JaODolDH1UCHuAYQUYmSzn0eUVKO4ynwv1wpYt0umIM=;
        b=HbBbYJZbm+D9dRrF8og/lpRbZOHLLIs1BrRiCxUjZLCoY6kCvKeXVSJ45SYOxQChq2
         rh1PCT/sJPyU9uRvi2NNs9g9GXt7yDWMha560LKUFP2U/Abv4btpi+eAKTiK9Tv2z4H2
         u+76RoUP4MBFJEFs48dD/XxZVPnfPpCb/flm17nkY7LeG3urQqciG8CyCvlGfQi2Q/6k
         ogOhR5Wx/W+6fU2Ac8BHqHYH8zwLFLs7OInacfL3XpZcOTeg5dGVcGFhV80kIzL2aEmf
         m0bC+flN1fg0ryDJeKtghXqkDWgcejdn3Nqe+N7j60K8J1OHbjhUNa9diiLowvqFnOdI
         jzAQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq0pniRkUZ+voEjLD+TIt1H7Y+rkmFGsMhEtUV05NxkM83jR1HFGwTlZ2MuYHauFSmLWik+i4LUCg==@kvack.org
X-Gm-Message-State: AFuF++kacHkhmpiXCjigE1uiV/buTZBCu/yDz/fj6C2rwO8RtFeEt6LB
	988kPWJ2vxKJCMHGtJODhOwDw5FX4M6KDEBnX5T5UVryTSmoeXuoZur0qO2sToRyYcg=
X-Gm-Gg: AR+sD12h5gGpmYv+15SWPl0h6B3Dl83jg5n9CkbNkaTWJqBIgkC3kNeYuiCig4wHj+F
	15BayD6axg0z3H1PljGz3HBtq4FkGm5A13L8PWV/8bfC0Bks5x8028THiif43ZXJtVwAvSl/0RT
	unGm2DOSG5nRL0VfTJywntEF0+UXokHGKke7RG3pw13RP0QCzKzL8hwx8C/VFhMXoulYWPglXSe
	Z5PT+Gb/kGA94YP0ROOK+amxC1ywKTWQg8eXZSOvRFwaw+y0RiMwNGoxVN+a7juThZmTzB7ckar
	FPvkqMINGTNxQXwNfZ6tRMl6puX9CtJVu0SjqLXh0pe0YDc2OsGpWrzgSSiXDf+TPLtfMBvF8pz
	Ras77HCRPCQzxZ/T5tJdPdNEDj+Dyd5DM/eznG3UJRnfb/9z1fw3xWA3dcchkAbb/3qWcjNBq4V
	Gd+dbtZHdUkV/ens/oc9CwP/BSQyUPdKR8QK63ZIN3BESOJpfHVZ1f933cBAeZpRREeSzRDf8Rd
	1NgSBr1UKemGcyCrZKcG0wgBg==
X-Received: by 2002:a17:903:1987:b0:2ca:53e9:1277 with SMTP id d9443c01a7336-2d5fd7130edmr57180835ad.1.1787133239166;
        Wed, 19 Aug 2026 02:53:59 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e5434esm22504235ad.51.2026.08.19.02.53.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 02:53:58 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v4 15/17] mm/hugetlb: remove HUGE_BOOTMEM_CMA
Date: Wed, 19 Aug 2026 17:51:37 +0800
Message-ID: <20260819095140.17252-16-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260819095140.17252-1-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4E7F81A0003
X-Stat-Signature: 8t3ppjrsqcq3pn1q8kz4qwskk996t1tx
X-HE-Tag: 1787133240-818430
X-HE-Meta: U2FsdGVkX1/WYF+eR7UDVvxs2soGSr0mzzD0cqdmmYDzjqPLQSu+LJwCKFDsal+PgA99Szkri0ux8B+1YlF99YHIoHMSgIv/NEMTNE8x8Z8kIFdl15HLLEVP4I2a7zEpsxOS/rfsbtIsX84hbrZPHh/OuLkEP2vQwGqgdidhDq+0AKkzHDG+glBZ60W0OFKtIkFizzJLaL7eycsd/eeaWVi7B6GU6NhJh4b1COW2BRITFsbP6hHetD9pG4qjOJnyWrehK0gaUgVI615liPblhlvPv0z+dFXFOz5C84QFlIPTqmeyqvsO8U40v7GU1kefuao5ieqkbSJBuH+tt16IWkIVDE6Fj84w9spIAmUytln28832C0MLgymUtMQJScIEulDAyH0/tfdHZp1vZvZ7W8HWX6agVOiZRz3Kd6EmfGhM1peJgYdZjoSTIgzREYDecpWizdwcFfzuf9nJVAOuBFVS7f0iMmpCm0yOw895pipxK/16890sRNSPj0lYHHDAr7Xzw6QlkHo8H5CIc3eQiUiv/xCdpj6Rz4AXkN6A6zE10i+D1Lc6LVNHagmvzkMSrX8KhHFBB+DJgXPTvceJMzpqklJpGeiqI5LQRmImGkwaVDaX1ej8gqJJZ00XwwPXbuo3OhT0Oz9milVw8aHMbWrSkNR0veEdhy/D4Fe6XZSz0F/JsovaK/ZxsHxlGosfDYdeM4A76Do7pZ06IV+lXuAJGggpUOtwtpKpSD5Kb0Hlq28pbUUotcfIuNKY76Ib6FIzHkv8Im4UcMpbJ/StGh6Np0UDK4ZkCQih5myquMiPGkbQf5rmlsrzsP02N8PO/sOsxYqxjCQmM3NkmTpv15Q0eT3nj4ft7bgoeQBx8FZvBI8wlJhXIWf9bH+OHNT/90gki/OvfzwWQVfGkk2ZR95nJFallvF2Y+bRV8PF3elleWVscGMIRPWvlY5D3IbhLTzD5EUTJb2vm3BSjFA
 iT7QvBZD
 LYAJ2P+GkLcAvsga0gNx2FpX3c2bHdWpDzeD7sxlzcv7F5AKCWY0gu842NXGbPkmqeJHVtaBfXaaV93Dfi4PHKXxGHi0wTLpBmE4uSZWH3WWz2CHUJTxwpQfKAHIiezcooZTsIS0upX5Oc+CWqsUN/VapE6stSdly2Crxit63ndBb3qb/Pz1TfO32gKe2MIha8jQ3r4k5DmHLhkJcswPAxN2YRX+TG9FJQlh9gTO3OBjLsF9wcVbgQ6MbS/fitDjxgMGjaw1jB+RIcpOuCjDZm/+Bw/4++2cqy9sdHLX8qQ/8Z8xBZBWIalcVBjUIed+3Bd16SINjfaYMXfomWG73D3NBp9hxh+4oiO8K5nKexaG4ow2hntPqaBNh+s2541xNbPYTamJwfLl1pgfXOnOgKZAPb+teAwn9Cv90UjUTRVyMxoupu4a7CM+hg/LQml/pqjdofccfyZH0bd0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track early CMA hugetlb pages from the hstate instead of storing a
redundant bootmem flag. This removes the unused helper and keeps the
bootmem metadata minimal.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/hugetlb.h |  1 -
 mm/hugetlb.c            | 14 ++++----------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 3559041a5a57..255a258f11d1 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -676,7 +676,6 @@ struct hstate {
 };
 
 #define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
-#define HUGE_BOOTMEM_CMA		BIT(1)
 
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ef41b82493f5..03665ff92696 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3120,7 +3120,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	 */
 	INIT_LIST_HEAD(&m->list);
 	m->hstate = h;
-	m->flags = hugetlb_early_cma(h) ? HUGE_BOOTMEM_CMA : 0;
+	m->flags = 0;
 
 	/* CMA pages: zone-crossing is validated in hugetlb_cma_reserve(). */
 	if (!hugetlb_early_cma(h) &&
@@ -3196,11 +3196,6 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 	prep_compound_head(&folio->page, huge_page_order(h));
 }
 
-static bool __init hugetlb_bootmem_page_earlycma(struct huge_bootmem_page *m)
-{
-	return m->flags & HUGE_BOOTMEM_CMA;
-}
-
 /*
  * memblock-allocated pageblocks might not have the migrate type set
  * if marked with the 'noinit' flag. Set it to the default (MIGRATE_MOVABLE)
@@ -3291,9 +3286,6 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 			folio_set_hugetlb_vmemmap_optimized(folio);
 		section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
 
-		if (hugetlb_bootmem_page_earlycma(m))
-			folio_set_hugetlb_cma(folio);
-
 		list_add(&folio->lru, &folio_list);
 
 		/*
@@ -3304,7 +3296,9 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		 * For CMA pages, this is done in init_cma_pageblock
 		 * (via hugetlb_bootmem_init_migratetype), so skip it here.
 		 */
-		if (!folio_test_hugetlb_cma(folio))
+		if (hugetlb_early_cma(h))
+			folio_set_hugetlb_cma(folio);
+		else
 			adjust_managed_page_count(page, pages_per_huge_page(h));
 		cond_resched();
 	}
-- 
2.54.0


