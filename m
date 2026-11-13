Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D704606A8A0
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=J9HGC6OX
Received: by kanga.kvack.org (Postfix)
	id 1CA3E6B066C; Thu, 12 Nov 2026 22:35:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A12C6B066E; Thu, 12 Nov 2026 22:35:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 069B16B066F; Thu, 12 Nov 2026 22:35:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D10AB6B066C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:35:55 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59B6EC0124
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:35:53 +0000 (UTC)
X-FDA: 85428681786.10.0039C65
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 58B28180005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:35:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=J9HGC6OX;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794540951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tH+sQfdDTDGWfh0zDLczcrbop696/ilbCo5M8/1+Vaw=;
	b=hR/hMhjYws3sBtKcTl06YAdflogIUcfPB4L4a84/oeV9vjT47dFK4aabd36NTSnbKxhSuB
	pMu19JAQhJMau81V/Z4I0dVBRJlTr8ybbBBgeLh1qbz7vFg8iEkO3N3m3drTmGq5xGxt4H
	cNxq/RvqTg5YaMZJo/ybaQ4EzVqMQvA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794540951;
	b=vzDd/36zIP68WtfPt2+x9kbO6Rmx1qrC+V+71/eqIvFaYPZ55MJR/dQUDV3yxbyy+CrJu5
	SeFI9aw6Oc7dexHS4fH48FUqDcNYzXtTLIg9iYUhgV2+GONwC5a72UJRNOBxY4XcPwisTe
	qahRULM6YNvF9vPLJIWV1rGnINpW0NQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=J9HGC6OX;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-36e99cf7bb3so683831eec.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794540950; x=1795145750; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tH+sQfdDTDGWfh0zDLczcrbop696/ilbCo5M8/1+Vaw=;
        b=J9HGC6OXrPwPU2wWTG6F3DA/+GMJyqVS2OtCZOTFY/fmETrFmbcCHB4uNKwze3Iqpp
         5vWK84rNAdUXbVRJv9832zG7J9zMHwTdHfE+7dyWEkCnWMAPRewQaOMxZ6kKxAR41YN9
         6x4UrU8bRYDjEH9rE8Um9QjBjNNyBMzT26V8edis6xwM/AQb0YxpbsA1tu24fTf00edV
         GSc37MVQVpLT633hZiFluZ2H2NbNvzudVNASsOmoGXSwI6oR0VgUrWx2vGMgdKcNX4mY
         OTRA/CrtU7GQfN1948gHtFSeIqoxz9lQJhLZNy9FgOI3gDMaApW6MKFrbE29B5PyzpgE
         oo+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794540950; x=1795145750;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tH+sQfdDTDGWfh0zDLczcrbop696/ilbCo5M8/1+Vaw=;
        b=JPlKxZi/YbPMhym5NlWUwZrHR4AVzr7pimDsIec/i2yi+Q97ewaXouvVltvYW3CDLf
         PpJjYEXFQZ3yotXZKgT1yupknlXpsGnaEWvQo65hJBenGNvij7o9SdWnWEdVPE2RNnpJ
         NSotVjxon2hWuvCHhvaAbMR5FOv0wrH/1LHsHsyHtbuiYcxc+yrDZlbWdqUp66B629MH
         eZ3rDcNIeYaLeDrEIBzTKKpHsjsRLkr/dhmQJCP4ZTeCCHFn84uf2lICpfCVLBz6Lc1o
         gucXqIo7tFUJw4lEOJbhKr2gbiKR3lnG0biKrUB8dxhvcomMfyHqevZhUizh/6M5jgfL
         AF4g==
X-Forwarded-Encrypted: i=1; AL+hErEjrVbFjf5pu2sEXfpV/2CWy8Fnx6U+8ZytkabE7QjKsPac/CYqMNiRNu77id6GK8aGgAbnN/HPaA==@kvack.org
X-Gm-Message-State: APuU4Z8Bl/n9PhWnB8wvkAG63N+pS8SNlnU54FYmM8Sq8M002+gT7ZgQ
	jypCVs0fItBk6DPjVTrENBESv7Ei4FmpUGRUzvG9Q0t6u26C6gbjab1fNcjJ1mo6Mv0=
X-Gm-Gg: AYBFou3qgS0O6JMjO50/U/IEHCVhvcVRReblQ7uqGv2vFtYzGFtlla6/9zlvCJZHzHW
	G8icHUhRAkmwOZpBT/h7G/qu6Zo1QhtOtKsiuCPL0FhED/FN/WQLELVXgX7aIM9BhU6+jqGERGd
	odL9Xvv/DZKzxbSpActKwaXHKBhQdp1885Fy3v40a7C5PnTACZPA28oAhI6jjxkWIkAjbf31eRb
	ikm0+Tr0f/c2Jn8Q0RQ8lul54BbjDrqv1MtQrsu40wHxcV8lmHG7XVrPuvAZCdhN7LInIv2PboW
	ejBQpHofvpQtqsZ5R3UTmISjybGEPVgaDixVdbTx1seJ5tqeazURUS+1GaI5+muZGxL2U53r013
	WlxdqrLU+YFi+EuqFMYqczknvAShu5YNmVuCawFpgt05q37+JkCxjBhcF94WmjvPdkwUTVl3lTE
	iV+qTpWlhnnBrbkaQk+HQ6wbA+NeTgi6w0NVUY6ztPB+9vW+9/3y/U9Ru2qPwILcBN+qKa7hfRO
	JfyCwmBwI6kzCVLSd6Fp8MJ8c+U9A5HIHK9JW/8ANOqOcmp8PXrIvTOwoTfyY1c5KbHLGeSnTzt
	sfZW5W67RAKOhXHWmRofQrP5e5GA8ryk13zCn/oat+mIWAc0w15lp9O5OzVHAg==
X-Received: by 2002:a05:7301:428f:b0:369:5583:bf4c with SMTP id 5a478bee46e88-379684ae79dmr990948eec.28.1794540949810;
        Thu, 12 Nov 2026 19:35:49 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955e0d966sm2959426eec.15.2026.11.12.19.35.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 19:35:49 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 07/14] mm/hugetlb: drop boot-time HVO handling for gigantic folios
Date: Fri, 13 Nov 2026 11:34:35 +0800
Message-ID: <20261113033442.62970-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261113033442.62970-1-songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 58B28180005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 9hjs5wdkqoim186hn3f3q7kma4p7w4zm
X-Rspam-User: 
X-HE-Tag: 1794540951-287348
X-HE-Meta: U2FsdGVkX18C1akPiY1zoYdETiB5YXvK49d+HyNKaBhtYuiWobgpkq8QHwzRcbisp297wCrGK8LO0PBM0WduQg4BBO+SxHsRGLfw+al2Cb66vT8LRA47I+zN8DhlT66DxpeWWI8WtL3GEkVTKT1q6brnDXb6YBoBO0VW+ZPbjK98UwDSDdeCMDTqDQbFQowumLfBRhux7V/KxCaTDtwpPtkIJrjhkldmQu4uL7shHu9hnmj/wTNkim8aIWxrnuVSQa+h3n8wqy0dfvQsksuaUh+gk09AYazSelDS2wHVX7+aMl/YB/sD65wyrpp+XhbS9zoWZza7Fj8YhTWuWON1YM8rGEF5bf7Blq1A+UhhLB6gwoO5iS2AyyFr7VOjsNflmOvk4n7hMMIGLQU2Q/BreAD74ghyBVd2I/krOKHH2mAxKEsfTgQxotD2Bb4rmf5dTUzmnvGb3nGTr1XV0l7juSZyND2vTc4dzZYbR17hPZS28NcdVe9HdBWuYbzo+JN9PEJkG0x4F9f08ltbiNSkYIjjUAJJHbEtE8etMxqHEyIhW/5BsSCziKiB0aab4cMG7XUWMe2oSJDm+DQh/7h5hgn3XFh6oMUev8bs5+QjcOXCsUHUfa2YJ2d3yAa3yHFysX72uNje7A1CheU8nH68ZhyxyyiQM5AOzuXa0E/LKau1iwgVAWz1BOjIALVTGdzUdRwws28dEv/x5HMJ8L4PiI2dQfQU6zFctSeYxA11/fT9LE00p5uutOV2ape3EuqYIOL84m5j8YHvqfxvdTNTo4wvNtmKMTMytSS8Oqpg2UvrVfnOlmOE19xuAe9GESoVgkWU9Qeor8DUp7yzT5e62mw1zFzDJ9r48MEbxbhicqGGWv5fpROkYtfMm+Xvgs2l6DweguGmawgv/xxSZV6s7shKpjJ4O2QKvh86EnX56b1yppRbs4aknob1023vgkQMrcd1hv9pfsZIqisBGXP
 z3Tsf2Lr
 AWWoln1WTfhv4Zuo1PpNyGqRJ+BNpPOfRnEczc8vMt13TBqQdWQN0+nEp3IxYdP87yfynzj6Ct1oZ3RKvwgk4Bq4DEE9ZafI3WSNMW0VYnkCfvYIRJyBN3MMg/OAd0Yx4IDO337W18AiJ4ssGAAWkoppatHPe92Id4qeQETBNb6clM7GA+OGixnR7byAK1FVwk7kVM/khVQmsbLieFcxkM+4uxRwcjyN+4Bv11EB8qYi6miocf15VmKvtPatKAL55jHL3x5Re46ctLmQ9cTrUiKmdXTD8wXoEAntRc4EDWtbzaB33HpCI4iLcOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

HugeTLB HVO is currently supported on x86-64, riscv64, and LoongArch.
On x86-64 and riscv64, gigantic HugeTLB pages are larger than the
section size, so the existing section-based vmemmap optimization
infrastructure is already sufficient to cover the whole folio.  On
LoongArch, HugeTLB HVO is supported without gigantic HugeTLB pages.

Therefore, boot-time HugeTLB HVO folios can rely on the section-based
vmemmap optimization infrastructure directly, without the extra bulk
optimization and fallback handling.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c         | 25 +++++++------------------
 mm/hugetlb_vmemmap.c | 17 +----------------
 2 files changed, 8 insertions(+), 34 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ed3af959f615..3a307bc6db17 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3345,21 +3345,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 	unsigned long flags;
 	struct folio *folio, *tmp_f;
 
-	/* Send list for bulk vmemmap optimization processing */
-	hugetlb_vmemmap_optimize_folios(h, folio_list);
-
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
-		if (!folio_test_hugetlb_vmemmap_optimized(folio)) {
-			/*
-			 * If HVO fails, initialize all tail struct pages
-			 * We do not worry about potential long lock hold
-			 * time as this is early in boot and there should
-			 * be no contention.
-			 */
-			hugetlb_folio_init_tail_vmemmap(folio, h,
-					VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES,
-					pages_per_huge_page(h));
-		}
 		hugetlb_bootmem_init_migratetype(folio, h);
 		/* Subdivide locks to achieve better parallel performance */
 		spin_lock_irqsave(&hugetlb_lock, flags);
@@ -3383,6 +3369,8 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		struct page *page = virt_to_page(m);
 		struct folio *folio = (void *)page;
 		const unsigned long pfn = folio_pfn(folio);
+		const unsigned long nr_pages = pages_per_huge_page(m->hstate);
+		unsigned long nr_struct_pages = nr_pages;
 
 		h = m->hstate;
 		/*
@@ -3396,13 +3384,14 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		VM_BUG_ON(!hstate_is_gigantic(h));
 		WARN_ON(folio_ref_count(folio) != 1);
 
-		hugetlb_folio_init_vmemmap(folio, h,
-					   VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES);
+		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
+			nr_struct_pages = VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
+		hugetlb_folio_init_vmemmap(folio, h, nr_struct_pages);
 		init_new_hugetlb_folio(folio);
 
 		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
 			folio_set_hugetlb_vmemmap_optimized(folio);
-		section_set_compound_order_range(pfn, folio_nr_pages(folio), 0);
+		section_set_compound_order_range(pfn, nr_pages, 0);
 
 		list_add(&folio->lru, &folio_list);
 
@@ -3417,7 +3406,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		if (hugetlb_early_cma(h))
 			folio_set_hugetlb_cma(folio);
 		else
-			adjust_managed_page_count(page, pages_per_huge_page(h));
+			adjust_managed_page_count(page, nr_pages);
 		cond_resched();
 	}
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index ba8e11e399b2..d73ceeef392e 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -552,7 +552,6 @@ static int hugetlb_vmemmap_pteify_folio(const struct hstate *h, struct folio *fo
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
 {
 	struct folio *folio;
-	unsigned long nr_to_optimize = 0;
 	LIST_HEAD(vmemmap_pages);
 	unsigned long flags = VMEMMAP_DEFER_TLB_FLUSH;
 
@@ -560,18 +559,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 		return;
 
 	list_for_each_entry(folio, folio_list, lru) {
-		int ret;
-
-		/*
-		 * Bootmem gigantic folios may already be marked optimized when
-		 * their vmemmap layout was prepared earlier, so skip them here.
-		 */
-		if (folio_test_hugetlb_vmemmap_optimized(folio))
-			continue;
-
-		nr_to_optimize++;
-
-		ret = hugetlb_vmemmap_pteify_folio(h, folio, flags);
+		int ret = hugetlb_vmemmap_pteify_folio(h, folio, flags);
 
 		/*
 		 * Splitting the PMD requires allocating a page, thus let's fail
@@ -583,9 +571,6 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 			break;
 	}
 
-	if (!nr_to_optimize)
-		return;
-
 	flush_tlb_all();
 
 	list_for_each_entry(folio, folio_list, lru) {
-- 
2.54.0


