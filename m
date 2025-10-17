Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4C33CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 166748E0052; Fri, 17 Oct 2025 04:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 116208E0016; Fri, 17 Oct 2025 04:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20978E0052; Fri, 17 Oct 2025 04:51:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D6F378E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:51:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 862F988412
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:51:32 +0000 (UTC)
X-FDA: 84006987624.07.B38E2AE
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id B591B40006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:51:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760691090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U4VzTJGwFWfbLsxw+5xqIYuZUN7cDkULCnpZc07/OhM=;
	b=VIyS28GaUNgpNjUeFk2IuKX1C1ZBBLVrmyIT5SNN0vRzmvDLKFHCTD5o5SEItu/z+2eIIB
	jYNvY7uEv4zZyuEMxJxDv1/DZgCmTGB9WJOWbA1/aU/hTPEK/MV0GRqJfDvopjrjPwXdpV
	tbmT7bhVuPKQdUml4ngqx6ygnSMvsCA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760691090; a=rsa-sha256;
	cv=none;
	b=kUtQqNobs4n8rFPCXtxRHRv1/hRo278kjE+gAp3eGJeLWyrax+MwFZ7jfcIJhjpk1Wesle
	hOfVWAAwZnWK7cdQZspy9s8WOe7WcF5S7rFT0Vumms8hc07DLYoCmBrFNTZ/QaT2Z0qL7u
	nuSNQnHwMSWVEmP6pF4/B9kzJ+nFn4g=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4711b95226dso3597495e9.0
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:51:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760691089; x=1761295889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U4VzTJGwFWfbLsxw+5xqIYuZUN7cDkULCnpZc07/OhM=;
        b=qMOi5iYQA8+t2IYRkQcwVXBDLpOr2U4Xj0Y4mlLnyEFuCG6PwKbD7ctVaHFMKfC4IN
         x/Zgdx2Um5BVL5qKMVFPg1o+irbWLcm4p/25yfCo7KyNY31X9mfJbhGMVNkqJMpOjedL
         9WtpmpxXjVD9CWSOvZYoAj0MxHiwvKQZPxNjWnIcnXfWnKE1kk47UK4MiPL/g+0fUzqT
         lzrubQ/BMWkMbQ5PbtdkVNAbHJFThXE2HFjmo2Yj2+9mbSDsPEj7paq4rWuzsRf3MPZd
         ULIYzYE/uo1lCX/46z0C4boPvLDw8+AcH7ST4HGEtTTBm65ZgorY49OhWMiIchVGkqSr
         6XGg==
X-Gm-Message-State: AOJu0YzyGqWblWwWwatdgnV7oQTQ6fyaEeb5NVplT4wdU9YVMnFl445q
	Ne5DEBFBEEGj/ww0DeymaCO4MpWGs0zrDTsNWh9uuFKbMFyCxNEShzgO
X-Gm-Gg: ASbGncvUyqapKz0ISVseMYNuOUryeL48oE5Pu5jA9j1Pi+xtLzuq1nUNSoJMI8x3YF4
	Wb4GHDtQtzIU4o1QScaHN5YsddbDm7kg0pHuse5OPDnMCuL7Vf7N1NwIqkmEJf/mlthCl9Id+ag
	VXSVXxXt/DpzDPHOjtxg3IovlrufF/iiWnGzYvx1povIpnCPmo8+Mb07MQd86FI6pS1oi6f9i4l
	bzI8AJTm2rcsFh+R4AuuQ5Sxop9Ir59CJDW3o3gIgpqUJUSdTwPABjoshuGKLPjsx2wBPlfxHJJ
	brG5sjjoo3nwMX0J5QuOlkgFBGsIz8YZdohZSGnH52IEbfncWwRQWZc2Jt0sM4xXG/eH/LyoNsM
	s78PsRflgOuR1esKTRi7ei6sgFJo8cWHoxg79Wu2M40IYHMMzzrOVS7Gt2hlZbH9nnw==
X-Google-Smtp-Source: AGHT+IEtQYJdK32nJhSmhKG1JaCoJOb22CNUuwkNfOdw4OZKvioNrRCDXGO5fiUSFcuRhqULndiX3g==
X-Received: by 2002:a05:600c:6290:b0:46e:2cfe:971c with SMTP id 5b1f17b1804b1-471177c0f91mr21229275e9.0.1760691088976;
        Fri, 17 Oct 2025 01:51:28 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a09:0:1:2::3086])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144516fasm76080615e9.16.2025.10.17.01.51.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 17 Oct 2025 01:51:28 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	ioworker0@gmail.com,
	Lance Yang <lance.yang@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Alistair Popple <apopple@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Jann Horn <jannh@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mariano Pache <npache@redhat.com>,
	Mathew Brost <matthew.brost@intel.com>,
	Peter Xu <peterx@redhat.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Rik van Riel <riel@surriel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12.y 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-filled mTHP subpage to shared zeropage
Date: Fri, 17 Oct 2025 16:51:06 +0800
Message-ID: <20251017085106.16330-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <2025101627-shortage-author-7f5b@gregkh>
References: <2025101627-shortage-author-7f5b@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B591B40006
X-Rspamd-Server: rspam03
X-Stat-Signature: wioddeebt9kkxir6xw1j3zeam66iixi6
X-HE-Tag: 1760691090-868863
X-HE-Meta: U2FsdGVkX18bnnJ5VeLKhDAWa7DN++QZJL0ZeXkgWi+MbGRIv1E1rhy3FIPusK6Qfp3Tj5tYjU/qCYrjZ/jPFm2bKuZBde21l8D0x3/bbQ8iCGLMtlAkH+ucA4tFoelurFMW68rDdmzkCwCnFdw1nEr9bpG0gZwYM9pQRkbyxknOwXW+VJXS03j2B7ef0Bg2hfW//ycpd2k1Yw0RK/vYJ6XI4QNy08RgBwBcdutR1pzy/iZ5F4MU38LJcLl/oP68bwfeKNOJ+rdR9NCDgnvl4/I90rHvraXZ+WPbVVadzpCgDiqBac6VoQqr0i0WQ5pRL1bpUjbINGnOODA5zWuOIci7eNqsi989nfO9853WOXT0mOp8L/Rkn36WOBqpurl4x2Vh5+4qsMxJmc/kK4BJEf0n4HUu9izI0xFTNeRayTPRz7K7qkF8AJDeZFKKNBA1lue2kr6iHKicTw4AKFZ6T3CR26qE4GtyIDms2U7SZls3uO1eGsSRoOyVksatKMmh7U71DGFHS6cRJe7YNQQ6HzjLkWxYZ8M4C+oMKp8A945WuT8VPLPzgo4Mx0BuzAlGmNKcA4RljusOqMRpYcvO2vp04eiOk1BaA/2DYut/qj6scoegR57/hjJlFxOduukj9YKuVU+hM+hCOsTSyRWEMkbp/wp3bgwCeOUx0T33XDPZfLL5atkjvsnq14Bp6rzl2KRXxhgmqdO7gJxD3ONpz8b29lKRN+mPr9jKlWWsUkaNbure1XCNHwvRxqJPNYBUDlwk1Aq04ftolWosL+99Sgm6K3bggWy82yFTvMg+Dq4az6v7nKKlgMxoq8OAnA8/Xrp3vJKQAkYafdjxRad2twdcWhPbx2R2qGU1wko2CfiC6uFpakdJUk1DG+P4Ixth2Sz6nygqhzOhCpzxip+Xq/mw+QpRyWRxC4K4MnkQ26BmO+q1YqSry+bLEE2EA31vhOd2dE1KbwGm5CbOQy4
 qGi8zr+T
 TnpQrxKrUCfN52lp2tBWDxZ3lsjy/2RYPlqHghxzGgolybltcpwy1eG9f2I6HsveKsEtnVghatT9abwtaORYrcirirL3e5OZY6OadPpiUNMKlVzkcohp+ED8EWnY5XYwHlTX7yrr6aoaY+tJYZab2l7kdgT6mfReKOwgDFhTMgO5K4kaxYlYF0RDWcq3tHl1JGNVR8V5X6KuOljfLYOZz9CXFl+hnPvtDyd0wbGLwcTX5juq2QNS0LNGczo54I5/RpGYLE2AueTsVa2xFGwz9tp0OUoY8SKpTk0BceCUF+38bQu15MjjvvIRlxaopbNZXtgcT9zHv+AMcRqfQvZd3mGDjlrXfjNjTu0/PJIaVMChoI0JABBpYO4mqAwHVdy4kHMIye0DuMjATOlBG/CQRmkE+jgG2W9wsxyg4wL714MVmike0S09QL7jaHnfUHtZFIVxP/uI+JBs0uzD7p5AqYXIPcGIBtW3i4BfER8O0JlE4mEK+WU1bNGQuo5BO5ZX8Ka7O65OXSxSmSnWzpAtOd7nhnyopEe5eMRQDRRh64krizMXRK5sQvP90b/TViZfp5uX0KUxcTlRuH3gv/iIr5T86hSWhy1Q5wTyowFj1lcx7B4orBb+ZulYnAvmw5dJOAvbJLKqJhNwQXWTjfTTAaoV5R9OcWeM7DRrN3odZpbqTrVyiNL8cUODmhbbaWLX1H59hH7m38NYo/0EEdJrBcQu8AQw3ZZOm0Q7xdWvCi8mFcJIho24+ZguoVaw95b1QB9LRHig5hHUA74In2sNt14DgPvt17hsTpMc03ad6R7OGTV2LmQzMbAQ3OcNeLNBa4qV//TewwceoNKzr9cOX1mwu65zL9oUV6YWL2YLJu9xuClI5gS/lKBx/PywNDuiofLGP0KqAaNyL10K2t6DhG+cClM0gnryRGwkl7CPhts7J/2xDGRWtAfW9x7GTdRD164mch/UnxQiFV0x7koWc1w+qL/xT
 oA0zVkFD
 tg/1qfWLKD/GpusTggnGgQCJzp70dJ1k6y/THpvNmk9o/xEBp/BOu4TQsaEDRrsgRtjy9tjE06A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

When splitting an mTHP and replacing a zero-filled subpage with the shared
zeropage, try_to_map_unused_to_zeropage() currently drops several
important PTE bits.

For userspace tools like CRIU, which rely on the soft-dirty mechanism for
incremental snapshots, losing the soft-dirty bit means modified pages are
missed, leading to inconsistent memory state after restore.

As pointed out by David, the more critical uffd-wp bit is also dropped.
This breaks the userfaultfd write-protection mechanism, causing writes to
be silently missed by monitoring applications, which can lead to data
corruption.

Preserve both the soft-dirty and uffd-wp bits from the old PTE when
creating the new zeropage mapping to ensure they are correctly tracked.

Link: https://lkml.kernel.org/r/20250930081040.80926-1-lance.yang@linux.dev
Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 9658d698a8a83540bf6a6c80d13c9a61590ee985)
---
 mm/migrate.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 8619aa884eaa..603330ad8e0b 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -198,8 +198,7 @@ bool isolate_folio_to_list(struct folio *folio, struct list_head *list)
 }
 
 static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
-					  struct folio *folio,
-					  unsigned long idx)
+		struct folio *folio, pte_t old_pte, unsigned long idx)
 {
 	struct page *page = folio_page(folio, idx);
 	bool contains_data;
@@ -210,7 +209,7 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 		return false;
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(pte_present(*pvmw->pte), page);
+	VM_BUG_ON_PAGE(pte_present(old_pte), page);
 
 	if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags & VM_LOCKED) ||
 	    mm_forbids_zeropage(pvmw->vma->vm_mm))
@@ -230,6 +229,12 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 
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
@@ -272,13 +277,13 @@ static bool remove_migration_pte(struct folio *folio,
 			continue;
 		}
 #endif
+		old_pte = ptep_get(pvmw.pte);
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


