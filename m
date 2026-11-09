Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08B9F606D812
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=dsl4r62d
Received: by kanga.kvack.org (Postfix)
	id 21D436B05C0; Mon,  9 Nov 2026 04:58:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 159376B05CD; Mon,  9 Nov 2026 04:58:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0207E6B05CF; Mon,  9 Nov 2026 04:58:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D134A6B05CD
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:58:42 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6117516060C
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:58:42 +0000 (UTC)
X-FDA: 85415131284.22.3855E5C
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8FB7940008
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:58:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dsl4r62d;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794218320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kx24bYSuwimQQDmmD1Ej+/DYmuScFRik6OAh3kEd/h8=;
	b=SHM3uqP5w1QJmAzriW/lmZPN+mXQ39Y7e0uQP0uuoHVqufC2PuRaLQSzW7jDUqvTLclitn
	vuUa5/7ZHeeNfYpXHqSkWmiDadQJyVF+4HWrXDF4brRah0smQ/zM7ykpsH2k+I4JZBygHS
	sjJXcIwYq9xQy8N3peFcYj3o7ATJGms=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dsl4r62d;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794218320;
	b=2krz9yV2CDMfC1cWH6+BlzbU5dyU2DuSI0mVaJJIdN8b1LX+4Wt2F2tBk6p1973QvOKBc0
	LrakXxEkuXBe2JYC8RDWGtVM0XDLfs6rwJaU7elVQUhCKlB7o/Z83cWfIJIAvPyf8IpVcN
	oLJ1oBVerep8/genfrTgOayEIrjlRrc=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-15dd124bbe7so84581c88.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794218319; x=1794823119; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kx24bYSuwimQQDmmD1Ej+/DYmuScFRik6OAh3kEd/h8=;
        b=dsl4r62dKhwjwAs8qGNb7ULRYKC8q1v8cMqmz4j32ydAT1z1qum9WJyozF9z/cZEgg
         68iaIDTgnprhTO7TqOgU7OF1OOY7a+lW3rCMKCyj/egQ8wbjdyGjr2YzwWbwF9LyF8E2
         GU7b7VylCUK7BPjjrti35B5tS9IK/LWlEWLm19bfcMXfDMYdTAxsbSmeXYcysNJIfq8+
         y6NA1DyR1nhiHOy5SRJJRhRI9KZheZzksQp4gj7+C3/x0ATAOljqe/g1qqoohlj3oAUS
         1yE4BPVBsrwt8+A5cw4ITHCz3j9L7LgyO9vxXkySTbku3J5kGM6NwtaWxKTFVGDAllVG
         sTvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794218319; x=1794823119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kx24bYSuwimQQDmmD1Ej+/DYmuScFRik6OAh3kEd/h8=;
        b=JbXJChZPkUNHaIByjJ1jZEX7TxpTRMxgV+OwQIPx04g6kByqHdpLyDj2XeWKmbnOtb
         FOoAYGm+EB6Ie+2y02gztiZMBUOJetTPK0eGa1KFUIyx9A7ld/BA04sa3RfABNX8O27o
         eLrUInnXFUq7ED+oYzZjqsoh+0Cu7jeB3V70HsccusGCFCoXLAMupoqD7ZBaklsOOEN7
         BYxHY0pDe1hYjk6UholNOw0Y1Ms9VIReJt8/lOz8/4PpOAgJn+6eUwKclnqicdxDrgRP
         p5Xevd5VftPozjth1XZOVFD1SgsByIpG1gWaDqZm7ctrk5bIABqwJqvPc1fSCvzo4fwq
         pm5A==
X-Forwarded-Encrypted: i=1; AL+hErFNoFZDLK2YXUDgwFn0QFWKBUOeqUtFZSw0zNrvDKfPCb8KOfXWfoZHUlxrk9q0p3qnXARrkbP2AQ==@kvack.org
X-Gm-Message-State: APuU4Z/JNBsln6i03jLpz6fbzfoqwNfCyXJRD6ru95TwWvV0n769jqLI
	N+p/7aR8Rp1hj0V2ieI0vyUPWTgwC4Sy6mmyX/pA3d9Op6kOx30Reffqgry//BWS/Tk=
X-Gm-Gg: AYBFou0nbc7thZLyTvEMT8p0WVmhGm+QMXp5JQ3xFT+4Efap3kZVYH460eDfHkotUPa
	rDjSB+tqeuFzQZgrhXBCMk1vjTjkwI1u4fffsX5eFYSKgP9O4E1YDRz2jS35+vvY92/rbNI7b6u
	PytZnLdPOAl7qRkst1xAH+f+tDxypqbklYz4y1qE0Juz1gm/Mwawirnmp7xMNbJXws1lydtaHIX
	Dx4BzvoJ4yP8KOR6h3eQnraeAOGGHRpCRX3cs83Z+q3MgX1xCse8dqwwAKzZRKZMRdAHJxDeY1X
	VU5UM22dsaM8A4cknxXc/kshrvx6K85voxYDq+QLNS/G3H8Hp+v9S2T22GhSMRck4D7qgnkgft4
	t9Cwqv5VPgED+Nh3/uap/6vFvtVYTRi9umM94oTaHR/yvb1IAcfj2sm3Ycx7/dGSg+jIp+eaMvD
	P9nsVZUwRLDBsgH1uY26sBt1QW4hhZicexpzL6yjALncx6QqorJp/Kuv1+/C5XmS2BNniCdf1Pv
	1VI0NrBfUdqXiEI1z2St+9wORSNcIp92ZeDXZLGShHxGsna/hahgkiE2mhVfxxnc9KJ+yuDdgl3
	j59CnGgd4elwR/r8qXelwiMBaFyE4Ccic5K5LhAIRIM4M4pIfGwk4Lr+ssTfckFmIvS8ZUPbj1F
	e4i8dcYZR
X-Received: by 2002:a05:701b:21c8:b0:194:3a84:e67d with SMTP id a92af1059eb24-1b39fed20femr5517051c88.44.1794218318953;
        Mon, 09 Nov 2026 01:58:38 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3755e8911sm12841684c88.5.2026.11.09.01.58.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 01:58:38 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
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
Subject: [PATCH 05/11] mm/hugetlb: drop boot-time HVO handling for gigantic folios
Date: Mon,  9 Nov 2026 17:58:00 +0800
Message-ID: <20261109095807.41547-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109095807.41547-1-songmuchun@bytedance.com>
References: <20261109095807.41547-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6tcdm7xaxj86aizuj117jm7wfqt7ctia
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8FB7940008
X-HE-Tag: 1794218320-910576
X-HE-Meta: U2FsdGVkX19ZR2hNSjAY04FiSrHp4B9rDGDX5f4fYyj4DLx3Vo9hPtkwgy1GArsLoUqhC764BxViWz7jk+JSoRG8+uxpt6ymWweJ/aJRzqTvBqlMgNwrTZ9xRK4k9pBFADJft8WlxGRpFha2rQhyJLlWjE5Wf32PvnsWJKgVeZe9mF1pRpo54oBXcFI7/EZRIG5157mCfHgTgdRfYdEzG9wAaibbIwB+2+onkNyhA5pyl6lkhBqO2rSdatuJyPw0iYMDxNtWJNssNDpHre4i2dJ7Q+1ghco1QwZ02jGH27IeExN6DhqTDu/lPgpzTwvYGqzVSnVQgkr7xLWmCdDMq47A2NpvL9M9zFg5mSbAt/rZj9/miOfjDgUQiJ4DGpuIKnTTpMeakMg4YtfD5768fAGoq62Z1kVQOhISG43SnmaN08l4x/rR/eDCSSrcijb57/4rY2+JMlebVvTshxd4Igpqs9OLBt109vo2+ZHtfmNEr1ID+Sfq/2WPyCyanjGlMB9kAEcIDgaBkq76Kml9HxnWF6UnfLKGyjL6Zwk6L2rdxfHlT4Y8r4sgmBIF7z8aEtmodXZ+em9fkvSg2pWtEJwOB2AVCYfgP+foVlXOyx7qcN/6s/zY9YHM1wUIun4DVADECgOcyrWEYTJsRtVPjpF9QUtzXoFFp0EJpAgyaS6tQeFX02XWhJpjnkbVrzos10zhZB92/kKIjhn4dyagA2gfoP/9mjVfDTsdftLnwrB+MlFpnY8pEMDD4r69iO1fs2Y1F8iFUW2Uu+kgaPk+d6vVFPVQQToOGdpZWsMeA4lLMKFnvOXYKtSZh/YMQp+mhPQ4yJU45UNkCjh6/pPaIsxtTcif9Q0O8NOpNuj4vPWe18/2G9Ak32+Y/lybLt0Q2ah9xzPYhqUC1zYijLqtBGTJbrJkSrAiRBBftRBRGR0ylNyces2nHmXXvDSDq4qs6FosqqzjHYfPiJ88dvg
 XrJsfEL6
 uwzUYK4lYb74k6stx71qFeUkrsHQkDDbSO4CjSo1gz7RbRKGqK/2sufvVFW9IndTtOv607XS/+UkFv4tqc83XXUXRO5tMAcT49EYDxmgVbVr7iHpIwgQDNDX+08qPNCzojug3u77KDmigcWkdn4341vAZ1V1Iydb43RYgvTau7EI7UFJeRigMCF15rHFBfWGPH6r6wTL8GENEGMfI0Lumz8B4w9Ro6VxhzpGTGJhOCljR5+qb4/7MY40Vhi3WOli/S6EUdPwUWW687PurKrUpLkD83Ny6IXRhpoayz+OStkexkz1PJ98XDI3iPw==
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
index da1c17f14a62..ff6f837b6df0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3305,21 +3305,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
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
@@ -3343,6 +3329,8 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		struct page *page = virt_to_page(m);
 		struct folio *folio = (void *)page;
 		const unsigned long pfn = folio_pfn(folio);
+		const unsigned long nr_pages = pages_per_huge_page(m->hstate);
+		unsigned long nr_struct_pages = nr_pages;
 
 		h = m->hstate;
 		/*
@@ -3356,13 +3344,14 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
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
 
@@ -3377,7 +3366,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
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


