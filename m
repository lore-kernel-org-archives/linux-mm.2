Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EC55C61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AD356B00B1; Tue, 25 Aug 2026 04:50:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484D16B00B2; Tue, 25 Aug 2026 04:50:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FF056B00B3; Tue, 25 Aug 2026 04:50:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD29B6B00B1
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:50:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 606EB80370
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:50:05 +0000 (UTC)
X-FDA: 85139169570.15.05FCB91
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id 90A72A0005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:50:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZD8ZbtEy;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787647803;
	b=V0P2ZvhiDS3dNjKfrkegT7JqBbDa9gHFp0m8QIq+xwbYMiL2WSZQgFHgP5sF6ZNQ7kWNoC
	D+d33gjkUswM4dyx4wmm/diMOdhlnQRBSGHNgq7m3ljVpv94mYF1/pOool+nFJg89Tsm6D
	w6BfW3Xk7zGPU6VqHyLjjEfR3nQhf6k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZD8ZbtEy;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wvrg0bPIlMwg/Co6PQfYja34C6YJR4b4gHgQBVsm43s=;
	b=8ZSgRDgnGcRD0KDiG/57L/CqxsfW07FCrelkZAbBCHACH4oGbua5KCZysIQxhQnakffzKd
	xxMaeE1tshPx4Wi/TMj39ZiUZ8SUyeVCIrZiRsdQdMmEmVxlTlM5TmGwG2assHDR7/CVXz
	GqK/Q6phRwFd5QOuBOHVPnfs1uKv2Os=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3811f512167so6220083a91.3
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787647802; x=1788252602; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wvrg0bPIlMwg/Co6PQfYja34C6YJR4b4gHgQBVsm43s=;
        b=ZD8ZbtEydAHLkwv4329Ch5Uf7BEqCq3Vx8dz10s3jRAczExEn85b6elRArBI5wahmi
         xyMevRDjDP64Gc6JYxqs2vehBzwjZqqUSLrFa8OdFTaPwsDds86pBhHkOBVxS3ANKq1v
         ALNDE0NAxhRMBUtlblqvx1iZwjZFLGurEVSljivJCzfySZkCrBzLKjGkRCiL3mSh3NiJ
         JiV9uAdglHtTXRd1mUwb7INE/acrQCZMlmnOPupMr6tnAJLOLRMSKpbZukQcxTKa/Krw
         V9Ijwx+sg003gngvPtyDP3c45rQNwZSzY7PL25rnVedPECOhiJihaaOVNTc7eDU1z+Ug
         wCvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787647802; x=1788252602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Wvrg0bPIlMwg/Co6PQfYja34C6YJR4b4gHgQBVsm43s=;
        b=Uds1Semax43afbv0K5bxzaO+z13SShLtseHpgSi3DNSnqS12k1h1HERf56uzAy9ppH
         aqZK3XEl01fq2Nv687gwDAi8+4EJQAfX2D6xQ3xqpJ4EORkuc0fVT/mCpDeKofybee4j
         0OCm6/YxBs3YOwwqqZQIY2tpHlLaI31lBh8gApuyY/lciTqSXy42rv15ts2kDb96h2tC
         vew752KWrgDqwcf9kARu2rfa3s0FL2PVdqiJ4LXn/dj+O6NhDQrMkYQS+ahstynzoD8k
         JkR+nHBs01tQUhp4RmFC6P7eRT2t2J6kGJDYH/46W90V4utVhH46biDqChRjL7TJwCDV
         LnlA==
X-Forwarded-Encrypted: i=1; AHgh+RqLlvCHZ4bWvJ4RYBnyMajMHNTTwL9CUsWHkycFyZVhgNtNQrFz+mtsmcc+EGoEDOAJHxwmCvGyyg==@kvack.org
X-Gm-Message-State: AFuF++nhfXLZD0d+pmYCcPC0Nj/1XQbgSUCERWyY6yjMhm308Eob48c+
	kC3H8/Rhs9WXn3vV+FZoee2RYhanv7s7fSmkCmFzbQnxoBmKZZtP6H4wb1F/Y8Xwl+c=
X-Gm-Gg: AR+sD10VL+xtrVakBJdjiFrDBTrG/eE6YpUeMhMpxpgYQYu9vZLuJ0SXvInj6C4piSk
	P2VPSVxNnUm7377qrqcRiqu1dJKHGPvROev7yVxzdCU65ykpoXHl2pwzyX1qwQx8p9gbPfuA+l9
	CZJLxHJ/PwArS9ms+46suyK7swq3usnqp6nYwbms/60ZKAs5kOftfleCm6v4VVoQ+3pdfCPcOC4
	hdTM/RNR+nF3pzhRKvBLHdi8jl3zbX8ejGeavMgrizinbsMhjOvIdgEUu1obu4E18AOpMHjsKPX
	nSBIBlatAkxHyzvnE4ZjI1iy7LSRiyy0wExftluC+OIuEidF1Y+/PXO67SxzBWFwuDJ48fnRjDV
	CxQwnF2veZZbkYyOlqd/r2FKpyCEeaSym3FGHGFhXwpLHwEBSfQ4Olw2F0mt0TDneOb206qajFx
	6jGLKvN4fuL0GdK0p2XtPGr/2WH56+wgqRtASLrC+eSOu6pqtEAf/N/zWDs0NC29rFJ3moaWgK8
	qWYVRveJgrQQnAxvfdxfhP1sToS5TfFRK5L
X-Received: by 2002:a17:90b:520c:b0:37f:ed7e:7e42 with SMTP id 98e67ed59e1d1-395c3867ac5mr63066803a91.14.1787647802366;
        Tue, 25 Aug 2026 01:50:02 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645da08desm2873386a91.17.2026.08.25.01.49.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 01:50:02 -0700 (PDT)
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
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v5 15/17] mm/hugetlb: remove HUGE_BOOTMEM_CMA
Date: Tue, 25 Aug 2026 16:46:06 +0800
Message-ID: <20260825084608.47437-16-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825084608.47437-1-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 90A72A0005
X-Stat-Signature: 3fi1e48zqkuf4ejiw5pa3pjazxri7hj6
X-HE-Tag: 1787647803-270187
X-HE-Meta: U2FsdGVkX192iD1qvWiOrHDZ/LDLrh/mggfmhlQYwpEGWDo0AA8AQNFYGBzglVay0clDqaJ9t3aPXSuNa9usKZQsOS1N30ZH7DhKZ7iFjIsot7jph5dmtjicT9xHCgs6DWqM8cDHDZlV0t7AoLEqtmol4ac+rOWxS7Qe1Unj6/m9ny1jrMFc5SjfWHIoAN3s515o2MqyuaVGPtPIn7ux8K2Ocq1ecpOcMOksy8vcYVHLYvPRIAx41xjyNHhEHNc1ylqp/gBB1VtvEs/9mr75a0ewCQyDRFaogOM50u3X50v/9aXJzQhrCpZuXNLfr3BML1u6BEoFxskpyzshLper58saJ0j9csqzyUi9ZG0XYofggCv0jNooe8lNr/YrqmqZtKMcXpHzwBUlW+DYRmy3Fa7E5NjEJ0U+679EOV5WkzYLQnHaRw94HbfNfFTnql6CGaqAx7nTMB5pZaxatgCA+w7v8zjx7OAxz6dPowSfmaUn2ePXvuWQ1eTHi66NM74LFeUy6bpLcxm4SakbLDk1ttOge2dimyLaDzoLoSR43XXY46bTonx8LioJnoxB61M5DEXGiNijkU4QIDBDSdPdPhd4uJfOw1uQFXpmKqROVf7g9aWFPL5tKhthAElmwpnMU8gE67jGDRxWECp8kxgaEMEjpBayIIEqUzhqerX+oyNSAsNkFxm+k2vBVRO5Lq4SJrFX6eW7QE+X/+lgK5zfUJ0zw7h0h33nifFRHgB2CZl9GPLGk3ZBH93TjfE1ynMukASwtN0Jh1IKVTssu3Rt1qEvkhkdfkkbARzI5cUYjzZsoggreTuFf5CBj0KNDp0oa4XXsSRSd4Tk6bgzJXBGUoodX25k+gfE026fNNQdiQT80cQMycPoPS+DmBaJmW3atBKEvxaEJ6xRegsPn3JAmbVIONZ7KKAxMpyk+3ZnKqteZ9j8QkOZs0y8S9NltdegnPkPvmQSTd+EI4ghgYC
 CXeT3xQ4
 WPMx6HnbgvVIxsAbvi/qM6N/ENMT003APCOBMR5jBTmlRx/14Hb/YV7fdV3fNj/eyxSnCWejOjH4izE4galLn7ey9c3zH+e0AzD7dMtJUryeFyxhDJGN3ANpvmcXV5nwwGd6dvczjNBcUZpawL20Yh3IqvfiosttFeOI/9pQSiJjkALm3t9iMh9P3qImD6QzT+b/m1M+w5DW0F5C4m0NUVHdreQBpc132+u5/7sSgW+Wmp5ZTE5MdgyCiYmVzFS3Wzjb/aA+jo+ShEyw7tdyX7XPOH/Cz+5wCULErn7zocKHPOoypC6xeOTslbWLKXhV7octIUToCHOejAgIogavPfRMRpdAd7+GJhs07tZBuhGlWVVJmMM9gN690Me4XbFV7EOVrlNAIq1wt70nMMw1SpB4Cimnxvn1/xNIyxKcR8P2WIxanKMAHYd3efF4AWitieIluXP4Pvg44dy4=
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
index 4bb5a25849b1..6822fb4159fb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3122,7 +3122,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	 */
 	INIT_LIST_HEAD(&m->list);
 	m->hstate = h;
-	m->flags = hugetlb_early_cma(h) ? HUGE_BOOTMEM_CMA : 0;
+	m->flags = 0;
 
 	/* CMA pages: zone-crossing is validated in hugetlb_cma_reserve(). */
 	if (!hugetlb_early_cma(h) &&
@@ -3198,11 +3198,6 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
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
@@ -3293,9 +3288,6 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 			folio_set_hugetlb_vmemmap_optimized(folio);
 		section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
 
-		if (hugetlb_bootmem_page_earlycma(m))
-			folio_set_hugetlb_cma(folio);
-
 		list_add(&folio->lru, &folio_list);
 
 		/*
@@ -3306,7 +3298,9 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
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


