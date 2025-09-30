Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DE91CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 07:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C48D68E000B; Tue, 30 Sep 2025 03:13:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF8EB8E0002; Tue, 30 Sep 2025 03:13:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0E358E000B; Tue, 30 Sep 2025 03:13:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A052D8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:13:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 255381405F5
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:13:13 +0000 (UTC)
X-FDA: 83945050266.25.337B797
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id 52DA3C000C
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:13:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759216391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=RJg+MB8jkyhooYHl7VPWRbhLVwCzgwHPNjrxfT41vz8=;
	b=s71DqTqTs83grE/rqKJChuSNSmjEQi663PNM2Nh5b7Jbr6GasRM/cRoukOcbYur5/A5sa1
	trak8lQbJEumDOj2wMxQX2b0l4oW1AvHCRnzv2wRiqCr116/M6d+dMqoQThkr6XMityiXX
	m1Dif+N7GM7694ZFYozfN5tjv4VesR8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759216391; a=rsa-sha256;
	cv=none;
	b=0WYThD61mAHoTlaKGtyqouaXUNh9LPpav5WBi9NIJLwOkpf5nDSouvtgfLyTIhVcIckSMc
	G4KglJkGA6sJRfjP07YdeVttHAkR+VBYVNVKi6E+tefcuDj5r5URi5lh6vZI8sCJDBOm93
	GUbrp/yvRBC+ENOZkhFPeUD5/eBOfew=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46e504975dbso16175435e9.1
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 00:13:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759216390; x=1759821190;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RJg+MB8jkyhooYHl7VPWRbhLVwCzgwHPNjrxfT41vz8=;
        b=RPq4txpbkjoPRbPBEiKhCGri6tAmfnEXHD823Setx96l2yhdb+uLB5QSRTn5xiRaZW
         DHUsSB0AwxTqx/Gen9D1B3v5EVEby+1/JcCv3MifT9SwwVRjH2L1o4qPWNGUz0z8r6A0
         Ae4fQeaPOoZ+2n33CwACY8ut5TEboBijtngOTQ/ceNxCde5+wKUcrLSfw6+o8kKAexnG
         oifv890onHLLd77jgEI9zlawswzTbn+Bt8h9vJxUqnOKt1+jdH/kCEllpIhxvBMKjhDq
         Ec2N86c53Mv9NeeVet9KHlT0MwoLCcLiCZCHqrPpo6bJ1jwQ+pWBOqg5123xdw0Z7Gbz
         y5BQ==
X-Forwarded-Encrypted: i=1; AJvYcCWng1WHC4qTCBSUOFFjYwK5uCLvIIiQs/5YK/FEbnSA3mc6WngWJlUgNL4UlkAprbb8itwUM5IBog==@kvack.org
X-Gm-Message-State: AOJu0YwKXh/UK4yOoM2EO7rR0CIzggy+HaU+Bgp9rlB3QncgX9TyeQ94
	WZuqfezliwtwWOnKTUnwRy0V6LfoCAII1JwBiDsc6Q/OIGRgaM3qYkw4
X-Gm-Gg: ASbGnctFXFxqpwZUD9KeNX1S+9uZeekeYL3h9bPPXDjYKiluFAKNU7Ai5e0/1RJgjls
	eI22quDbKKvHBPVF05DxLeki79gMWChSPsMnh4xEXqd9zOIz1/YsMUfeLYeG4gqQSzgXZ8RkWs+
	gTVGrjoywp/sDIpjmAdSFYxr/z247yrvD5raIh7Ea06oyEDX410Bdqjklsy/964ruPHKjuHiLfw
	XujQBNYGUz/0Qo3eGYuayRCLQQsIJfUQ3+zIZ2m9dLzpLI5Ce1wQUwmBYd2oi10wiP/Atl/ep8q
	RRG9gJKedQAJqiAe9vAI3ThLHnJAnsLPMr82zoLaLavhyjhjWANfln/RzngtByl7vFZXIujeegq
	6qx9SmzoywhREHG07LhEHvPyi/AboTlc2aVvLdTLq2AuYwqz1Kg==
X-Google-Smtp-Source: AGHT+IHG/vdhpkUdLGzDD/hQegsFD5o72BWBQNk08ly8bjkRBa9wOlUTaVnXFyckUgCALWtyUUhxsA==
X-Received: by 2002:a05:600c:8b58:b0:45d:e326:96fb with SMTP id 5b1f17b1804b1-46e32a17d2bmr190697065e9.30.1759216389605;
        Tue, 30 Sep 2025 00:13:09 -0700 (PDT)
Received: from localhost.localdomain ([2a09:0:1:2::301b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e56f64d06sm42221855e9.12.2025.09.30.00.13.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 00:13:09 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: peterx@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	npache@redhat.com,
	riel@surriel.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com,
	jannh@google.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	usamaarif642@gmail.com,
	yuzhao@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ioworker0@gmail.com,
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v4 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-filled mTHP subpage to shared zeropage
Date: Tue, 30 Sep 2025 15:10:53 +0800
Message-ID: <20250930071053.36158-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 52DA3C000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: guqnqqq7eh9a4y57pxsdffwtssrn9iup
X-HE-Tag: 1759216391-490112
X-HE-Meta: U2FsdGVkX19edzjJM2K31ywIXvTa8aPQtwp7ASr52OUYDqj8jxXW2sFztZ228EKio60ZFflg92sSLnNZd1InTQT5irEqVpy5C7fIXGPdLWDCmEAApFHYMIGKUcZMtOMxPF98ip5UlvNHrxgZFvCbuOABZd3MD7haQiRMydDrRKhe3ax7ZPUTP/Ts17AU2xi6sR/GU0CvEau3kW731EKVNOARaJU4+mtAPS5LB2KZ64u82WyHVTA1YAftoNkhUdgB9Z6nr/W/sLUWM/LoeyxqRJQBb4Pzakzx8/wmxV2847g0+uthYuvdlpbRgYeeBGpxN+I51AKzlQC6Pb8Eta7bRKuRrZDgBlMkoROXQUobuK3ZiKYjyWK2t7ts1Ywj5axbhJAeJlrURL6uMjiq1gWq2yheLb+HM2Ec3WMW4cfQ6H+NM73DIc4bgx1RzZs4qpcsf50jNaM8QaPOrmRb/Q3XBQQwIyd8FpGhMAm7ozCRiwAG8yxnu99fjcbvBezqfqjvsZL6B7W+e6wfSJw5d5zJX/WZ/Wno2LkMz0PdE543jcA9cAIQ/IP8twA7F7QKvhwD/NXsP1iOD4+EZrV3KejUiBXIAN2haVgwPRWT2JBd4JPJHBEuQU4ptZWVZhRoBx1I1bvk6Uuobfh+OwdRJktpFoIgkXd2mMgCoRVwkbN84xdYvMCwGDL82y4PcA+QiDXEm0aa/VHFasFVVNiiMtyXySE3ElWfggUh5dmwuccqKqMvVtYoY0Do5wvB/EiW0wVPzSUOd4POrenZ5dgCb45W2UucPySrtQg8CmgCH4yVMvGf8fO3YPJKZWfasNxdnQjmVpBqEVUVnpa7uVTheA/cVijmeMbqMAYanIBOZf4WJ/eNjrLSQgdGFkSmyBHuSHdMvE7Sj9ajBdFUdFktDcRX/cdtvguEEDKaeDi7unMumvn72lt1Ve2YdK8v3uKYF7LHxPy+zltlTmz+ymWFeR5
 bGQXvnVc
 mwn2bDXp63JT7NmQRawHAkboLGnBk/7OXfHDuSnWVOCVegRyF3+PwCxZjtf85KxSDiW7mzN42rhCJBMbuIeWr/OFlIQlRzMilNONnVxQp/WftQX4HowRUm4DDl2O1NL8/v8Zenbg2bQ5DbVo2tiA69Z65VIhpTHr5vqup61UlbGzdu0pWe71XTL0I6I/IRFj/0Rueav8x+inJe/FMkUKoL4QrppA1995mSecLCxa97E8eUS50uA2oZQYYYcNpDxLCnOmlk2oLeanob4moETOVtVnj6FRFhXXJEwtpIne+Nk5z5vvHUBoL7jFq1ZsLLJaxD/6W40X7PKc71AwQC5RzUNNm1GbhI59vUtlYrCKiG3akxhXtggLjzEimCp0Njg9hclsQkWGkyAX4U0ZTpjZNB11UJ3seD6kt7TLbR6+YY+NfXTAZbT0AVj1hkk/u1tTFrqIYABzMMglGUa7Q+ntBd1v1KCcTC7Fb1owyVXX1ZTuhefNA2dchDNLGwsWBzj4tCFKbNcLCNPORSojcbkuvcitdOOO3yjDQT1McGQtfm51sRtF/oW/x4NtnEou9Ypg+9i5in+eFbTW/r1QZ1Y6nwPLuXkH/TpG9fHbckdtMwvL0F8wEIluYU0XYug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

When splitting an mTHP and replacing a zero-filled subpage with the shared
zeropage, try_to_map_unused_to_zeropage() currently drops several important
PTE bits.

For userspace tools like CRIU, which rely on the soft-dirty mechanism for
incremental snapshots, losing the soft-dirty bit means modified pages are
missed, leading to inconsistent memory state after restore.

As pointed out by David, the more critical uffd-wp bit is also dropped.
This breaks the userfaultfd write-protection mechanism, causing writes
to be silently missed by monitoring applications, which can lead to data
corruption.

Preserve both the soft-dirty and uffd-wp bits from the old PTE when
creating the new zeropage mapping to ensure they are correctly tracked.

Cc: <stable@vger.kernel.org>
Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
v3 -> v4:
 - Minor formatting tweak in try_to_map_unused_to_zeropage() function
   signature (per David and Dev)
 - Collect Reviewed-by from Dev - thanks!
 - https://lore.kernel.org/linux-mm/20250930060557.85133-1-lance.yang@linux.dev/

v2 -> v3:
 - ptep_get() gets called only once per iteration (per Dev)
 - https://lore.kernel.org/linux-mm/20250930043351.34927-1-lance.yang@linux.dev/

v1 -> v2:
 - Avoid calling ptep_get() multiple times (per Dev)
 - Double-check the uffd-wp bit (per David)
 - Collect Acked-by from David - thanks!
 - https://lore.kernel.org/linux-mm/20250928044855.76359-1-lance.yang@linux.dev/

 mm/migrate.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index ce83c2c3c287..21a2a1bf89f7 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -296,8 +296,7 @@ bool isolate_folio_to_list(struct folio *folio, struct list_head *list)
 }
 
 static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
-					  struct folio *folio,
-					  unsigned long idx)
+		struct folio *folio, pte_t old_pte, unsigned long idx)
 {
 	struct page *page = folio_page(folio, idx);
 	pte_t newpte;
@@ -306,7 +305,7 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 		return false;
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
+	VM_BUG_ON_PAGE(pte_present(old_pte), page);
 
 	if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags & VM_LOCKED) ||
 	    mm_forbids_zeropage(pvmw->vma->vm_mm))
@@ -322,6 +321,12 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 
 	newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
 					pvmw->vma->vm_page_prot));
+
+	if (pte_swp_soft_dirty(old_pte))
+		newpte = pte_mksoft_dirty(newpte);
+	if (pte_swp_uffd_wp(old_pte))
+		newpte = pte_mkuffd_wp(newpte);
+
 	set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
 
 	dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
@@ -344,7 +349,7 @@ static bool remove_migration_pte(struct folio *folio,
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		rmap_t rmap_flags = RMAP_NONE;
-		pte_t old_pte;
+		pte_t old_pte = ptep_get(pvmw.pte);
 		pte_t pte;
 		swp_entry_t entry;
 		struct page *new;
@@ -365,12 +370,11 @@ static bool remove_migration_pte(struct folio *folio,
 		}
 #endif
 		if (rmap_walk_arg->map_unused_to_zeropage &&
-		    try_to_map_unused_to_zeropage(&pvmw, folio, idx))
+		    try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
 			continue;
 
 		folio_get(folio);
 		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
-		old_pte = ptep_get(pvmw.pte);
 
 		entry = pte_to_swp_entry(old_pte);
 		if (!is_migration_entry_young(entry))
-- 
2.49.0


