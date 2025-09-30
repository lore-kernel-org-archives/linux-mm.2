Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 145A7CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63D408E0006; Tue, 30 Sep 2025 02:08:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EDF98E0002; Tue, 30 Sep 2025 02:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DD2A8E0006; Tue, 30 Sep 2025 02:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 349768E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:08:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D89651A05BF
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:08:12 +0000 (UTC)
X-FDA: 83944886424.02.5577E6A
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id 187AFC000A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:08:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759212491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=PeJ1hI+H1D/hmfkjwX/xQ5MOCbl8qf09bM4saMftPHU=;
	b=AxjTEczX3BGiVYjOUd+J8WTpowb44Fvhw3K+kJbTfYb6BtygpvNAkXe4kC/YcnVTlFZBAH
	f5h8Gk3kLobYzO5bhqtJUSOdx8rVvPyYl/PspRN6W60qQPFeNPPNu1N6JL7X1k4RjOJxFm
	I/KFCrxPdFjHuzQ3Mx/YsTZdmY6MaDs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759212491; a=rsa-sha256;
	cv=none;
	b=KhyzBBNvbvAVHqSo4wsrvHTAAOhvPRjHz4e/JZ5aVJXGf6RRN1dmtfm3UacFy4dDigG3Bm
	F6a9uFYnv8qS5dllU4SjVlWq8QV/pOd3mwtb1cN7T9fPaMY2FzH6ucez8SF3MhHvE2RSz0
	5sB+0Ef73MfjvmtqRcToXspmYE9Uu+s=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3ee130237a8so3925527f8f.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 23:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759212489; x=1759817289;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PeJ1hI+H1D/hmfkjwX/xQ5MOCbl8qf09bM4saMftPHU=;
        b=cxYWQLljE89TJ6NcLtWTOepssEeJeGHpcalSsjWqnzVsI+Ks9T2GdYauev+McEYPf9
         NahvWrCc7KCEDQryyjatEVtsS/Hm58zR1F/GZa0qV6OdtPrJN83rMwXhKOuJtYbzQwFB
         P8CQDvtBjxHzD3AZBt319890TXTzt/PMGrMymvNSLlfH6jArqeqmaSsWBCNWcZc5qBYe
         jSdRqNLotVTDgU6EfJsuChUV4SYGr+RmosbREmobgOgsbllKfL+8+0d9bVdfzksctJGm
         rQnhJ24EuYIWqZDbN7LBru7zJSsRhGZ9l2wML/BzKfSLvOfWC7OR89CF0jV+NHxQ71U1
         /Rcg==
X-Forwarded-Encrypted: i=1; AJvYcCWwJ3Bz97o+CZMiut6G/pQKSAThbd4H+JNZnZIEAj8y3GqGzmA/7jKq3A57iSsD+UN0cAlrrVXtPA==@kvack.org
X-Gm-Message-State: AOJu0YwIJvuY+x6Ep6Zp3TmyomS9gilMtszvWhFjKjSHwNLladSDY2GM
	68uMidH2pnGix6MCOB3CNbMGedKBt9Dhfp2sKfzXudMYqJh3So4VpEuk
X-Gm-Gg: ASbGncug8+8QDZels+alZDGFXj/CM7QtT+Y71IAi/bvL/Y400U1vX3taLCXKjuEqRLu
	I8d3JXlpzQhiF36c6lMgHcKmTT/4ru8Yb4HnvHHoBwYvIu+/c2IO+7JKedBE/OVcchiCNIpDmTv
	leFd5wjDpwGD1cFH/aWtr9n/uQXW228frwlh2C0SgCloPp1OHYSk+YZqkJ+q9OhN9glBUUeI+iD
	cBYYyHNG9bgdzMjuVvboZU0QaebzXz8CrGpt7dXyQBeOKmI7a8cDhn+3DnT2sEPhUP5WiP1uZN8
	W8pktLONpqeFQqKjp9D6GQ57VzUEZpc63PCiBGIUe1E7d2W1CgjPdO+VUWfGl94wSXCCDe4qDPk
	a/kvrL2bDCkjSi3eJsMKGmvqf0FyokFjekQlKHrI=
X-Google-Smtp-Source: AGHT+IHPnDFHgycvIIpRvpyKAjmZRopUiUot6cWIQicV70c4OwLebr3Y9E0pFRTisiPKYlM7bgtdTg==
X-Received: by 2002:a05:6000:2089:b0:3eb:2437:97c5 with SMTP id ffacd0b85a97d-40e468e7384mr17999022f8f.22.1759212489345;
        Mon, 29 Sep 2025 23:08:09 -0700 (PDT)
Received: from localhost.localdomain ([2a09:0:1:2::301b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e56f77956sm41935605e9.20.2025.09.29.23.08.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 23:08:09 -0700 (PDT)
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
Subject: [PATCH v3 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-filled mTHP subpage to shared zeropage
Date: Tue, 30 Sep 2025 14:05:57 +0800
Message-ID: <20250930060557.85133-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 187AFC000A
X-Stat-Signature: tiqf9zybcgkmm8tswwofnrn9uqpghs3r
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759212490-203234
X-HE-Meta: U2FsdGVkX1/InIz2OEZff8u2B/aA7FRna2Zufaom9mYaTIB1uXUR/Imkax64Dd3MGJage+iAydFzafSHCDG6IgowepWxe6iNaYVGY/a08C8QvWAB8Dzs1QurP+pyYMX8bCsc3nni4tdawOzBqeAy1MmcZqmfE2eJ3IGmmTYF4aw+yVdyXmOTfkhW9XC+eZQHbF2uKNCWtPpXq1AMOOAmes/zoQ7l1FApTYSvfIXlI+Ru5Rvb505s9ugdW85exVJjydG3RI320EcStjStwyarQFNu8n8bnGlv/FoNXhrnQUiYtNUva8/oc1hmSmE+wvweWLeEcotRqw320Fewb9zcE+O5qLdpjFKVRmY2ixK/rPV1yEQ+YlmGA+62Vp9UGVsEsPIn7muBVMUt+q21nAuoen/i7sthuEPBe/5E3xJomiYSqZ0EauXCQDvyv5HcAT0IoqVjGDHBiReuq1Ym/hbiD1UVwiH+XQE0wzsgD/uJNk4j6vChG25md84hIrvZx13af96ar84ezgBefL7G8FX1v1q2bE35mW8fAZTgBFmYEgq2cuzbNtiYSWOsXbLQrzJSgkBZzJM/RT8Cns/9EJN9fIWD99ttbClx1WSBsKpPsn9iOWCwm7IugBKiCkXuvqJIVuY7vZYsFbEi9veD2r1j/q2WJFMdB2gqclXBSCrChOWje5gGM3Hv4+ULNbyllFwCrbCXzf7kJ21DiVgOBo9f0zkmFxMdUvlEPn7+hTwdbmQ5wtTAKDfZzPVwH64OEnwPAvBTa6+HO79842JXDJNo3r9edYZR/tHu5sz0DPs/ulnp+nXjLDFqqGP4il66FKlRYm6/lY8FSwVhFKUvAT+DGYa6gtIXosJKs8buGt9z+YTSmWbC7MIJRHtcqWOYNyz7S0zfG5+vFnxlvSADVWhnwpKpKZksletW8+qSfvVDyEbGwbsTFMrSAmC4GfU8GlDYiepjDurbAILBBCvV/CJ
 N+4eJBgT
 zDUixlZvLh62JR5icYBSzRQgTGBt98w1pMwpap11tHkSM257roX0EqoGnlhbbF2todtoplvGXccUOPWQ7lyo0FMjULONIbOnqJDnl7Rd09BGTYLhFy/WnL0v9gm3/EdCCR9ygggQi0jqDxLbh1ZjiqscSVSML7hQ06lRekJyG8KH6CcN8ad9NfzVCVCvVRVihR96i/igx8WB30oeLwrxRB0brs6BUwwQwUmmPzdwlYKT6ARVf7mp9YBRCR3yOwHdqLaUPXXxjO1D7V/UIbeoK0odw+F4O96jOZnm0mrW9Q9OV3kxjj/cz325QIuTFAHzEtUalI5JDoixv1+jLywvGJYBLfj7HWvvA4WackEKDHMAAr1rk3PHcPtdnwhQYQcEdrp2Ck4yGrev7H1IZ3ENNmh5q+84+LzhTQz4Y47P0D9cmOtkzguFShVwjH8XrE4ok+WkABe7dUVXb8zienkjpnGaKDY0X8dWAiEG3Vh2yE90As8EfgmrP1IfB4zUvaT3PmUVM7IRCoRkDZOHFgzHh42C9aIkT8j9guvurZpUrgP3P8GnaLWLFKk7hH9ZFqwVfbVdZHsVO7PVNeJK7ZMi/Jqmd2jR2z3MJ0rObLPVUcRHPMSF9bgg2ds9FIU/ZpsyCautzDGVug6A3Zujtpq0I56pxBcYPzxFHvU4d
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
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
v2 -> v3:
 - ptep_get() gets called only once per iteration (per Dev)
 - https://lore.kernel.org/linux-mm/20250930043351.34927-1-lance.yang@linux.dev/

v1 -> v2:
 - Avoid calling ptep_get() multiple times (per Dev)
 - Double-check the uffd-wp bit (per David)
 - Collect Acked-by from David - thanks!
 - https://lore.kernel.org/linux-mm/20250928044855.76359-1-lance.yang@linux.dev/

 mm/migrate.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index ce83c2c3c287..bafd8cb3bebe 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -297,6 +297,7 @@ bool isolate_folio_to_list(struct folio *folio, struct list_head *list)
 
 static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 					  struct folio *folio,
+					  pte_t old_pte,
 					  unsigned long idx)
 {
 	struct page *page = folio_page(folio, idx);
@@ -306,7 +307,7 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 		return false;
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
+	VM_BUG_ON_PAGE(pte_present(old_pte), page);
 
 	if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags & VM_LOCKED) ||
 	    mm_forbids_zeropage(pvmw->vma->vm_mm))
@@ -322,6 +323,12 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 
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
@@ -344,7 +351,7 @@ static bool remove_migration_pte(struct folio *folio,
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		rmap_t rmap_flags = RMAP_NONE;
-		pte_t old_pte;
+		pte_t old_pte = ptep_get(pvmw.pte);
 		pte_t pte;
 		swp_entry_t entry;
 		struct page *new;
@@ -365,12 +372,11 @@ static bool remove_migration_pte(struct folio *folio,
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


