Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C2166076CFF
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 20:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=xOVKebtb
Received: by kanga.kvack.org (Postfix)
	id 01BF06B05B1; Wed,  4 Nov 2026 15:41:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE6A56B05B4; Wed,  4 Nov 2026 15:41:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9BA06B05B2; Wed,  4 Nov 2026 15:41:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 798C06B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:41:42 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 062A11A087C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:41:42 +0000 (UTC)
X-FDA: 85398607644.21.94C3AF0
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf08.hostedemail.com (Postfix) with ESMTP id 523CC160002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:41:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=xOVKebtb;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf08.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793824900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8NvaapzcaIzWq7uSJ2Dmb2kXv0T6bAtnj/aHzkzSaTg=;
	b=tBO/Fu3p5s2fWxYnGAlf/P8Fc0cf4g7zn1bxuQ21weul5fL2smCA78vZQdv3MjgDUzaMMg
	mmaMbYVFzvusNoPFxkRBSh9PrsZNhb4J1B+ohXTUODq1tHeKM6x5r1+cUaISxSQtlBSyMS
	/pzhVPsFoxVySN5YhreRsFK5n/9PigI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=xOVKebtb;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf08.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793824900;
	b=nGfOdJypRUT2HZdRlxH553NBShzmFDs7EKx+0kHubov90J9elYvgdPa0DuLrdIKiEGUAvZ
	t/84cLFMTmn/Q1xxSzsTvpNM3ZLiApsJ/RwQZuVXg0BvFE30NlV1+OwxJ5YSgrwguECG3a
	D14+KAkNdSoITmtNIllmZfVfqSaNj38=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=8NvaapzcaIzWq7uSJ2Dmb2kXv0T6bAtnj/aHzkzSaTg=; b=xOVKebtbd/EVZ7lZG6G
	8m0N9BIWb2IuyaQghh4TLmXRxLxz/MXauFib8S9ABq51e0GQptN8mnttoAgBsAvanC+trTeMr5nWY
	SfHMybSPUg2ATor/GYqmNcJc8xNHr+H2qciP20/61cF0efUIagIBsu1lmi1mfdX2jxFjX5Xgl4pUE
	K6T2MmUNy9fQXHtRdGWZ0vFv+aMeiYHJcDvBn6INkKKN7ITqsIeqIT1V8/sKCsC/RuaO5U1J1HcAd
	nKhzxOcXd9UNJkXg0zQcG5Hf5ADJ5bE6+Sm9Jw7nkiTM+jsE8fdduVPJk0tvHsoPivtBaSRKpe0l8
	yRhGpFonCnKyePA==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xOhj9-0018X2-0G;
	Wed, 04 Nov 2026 21:41:03 +0100
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Wed, 04 Nov 2026 21:40:55 +0100
Subject: [PATCH v5 1/4] mm/rmap: duplicate a PMD mapping as one in
 folio_dup_file_rmap_pmd()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-1-c56d0d26f970@virtuozzo.com>
References: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-0-c56d0d26f970@virtuozzo.com>
In-Reply-To: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-0-c56d0d26f970@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org, 
 =?utf-8?q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1295;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=iPYZJpAFEq5ph4FddJEQxBtKa8SgnHL269s4IuW5Tpk=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq65hcBG32k9kB2WWl8wXCX995WkhP71w2AQSsM
 B5MJ9jheT6JAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCauuYXAAKCRBRlgpH+WFc
 KjG3EACkdO7SpcAiJeF3qfGv/z8JO2DLU1rJOcZ6SnCgxtXjDTkNEPd3hDmxHcjtf9+GJyRpnND
 bd/KybasDP+Qa55evA+W5XG46E362tSI+80ly6JgX4ZJyi+1dVbAvi2L5v1vuG99SNqhC3HNfTj
 TeAtu64vAegOR5yW1V+mLBoGQbWXrBNEOv/W6fz3qAM5J6YZarwsmySzHjwZLZWVLRYvYrguMke
 Vy9sqAa1voB5JtAe12r1tqpSMoZAur9G55YIgiwjoxc/qKdBy8OENrQhd5mFh/Vi5PoDKwXrbEg
 v9OW/ZG0TnCRZKzCDWkfcOUx8XZ5hWNGi1ekVgS0EguNQ4HIzWlzshfRHnbRrT9DYcBg10zXcpQ
 dhXgOKvbDxkYzzxNMzt7bzqppgmnCsHzwc2O4X5kHtDtLVVY714S3Z6OWuGzLvyYR7Jl8weZlPu
 Har5Cb1McuXx8waVgTVEFo3TNc7ME9y0a6GmOw2iMw9Zox62sbKzRSbmVv7cJGypoQGwQmIoP81
 v9rOR/+btNakWwKECAHDi5apelwxkciYj/xLN8E1pgbBDrG4CXcr/euHuH5BShb3ssVDnnK14NO
 B3HEH6mQ8yzBLMc185k5pVVF4wN7d93B36XA38i0JzZ8QJmHCU4/9arvRr+cZHgRLdsp6l77GVr
 CTL7Lmh6wJ6XrnQ==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 523CC160002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 6e76xremy4sfodaxyiqc5hbkzrxzseig
X-HE-Tag: 1793824900-504027
X-HE-Meta: U2FsdGVkX185FK4FL/SkD0+pPq9ZX+ZHqCh2D6dik/TU+YHde+Epszf16pYn1BkufRdVYNDO6ipB34v/G2ZfiSjxLg5kqKbvL4KsNvslF6p2Spp2/26Y0K1XzF8T1MXnEUlNqSqDrXAuheDL9Flo4wtEatqOiEmebydyxuwD5vX+h/uRzyt2ezJBMwBHn8HWYn/hItimG6WhyH6gAdiH9wqjxuKopqVN/PnSo1C02SDBOotabf865dK7U1nmyuRh6SCwrJt0pJs8fTDxPZolLXZl0Qo5ySz78LV86jIgvREluPlYpGECrJ7MZJG1t5ifSXYrXIDKEOD5VxVTRWb8zzIIyCgvHNbKyBVDyBmDf1k/UfIfgTcpm+FEIXbq9SC/5h77qwdxIoLHQfKJYPXaheFokavOaF+hz46dOdktLSrSIOaiDAvFPEyKJJDiodgQ4biPXu7v7/xHfM+r+tBenTy8sTVVgnG9ri0c1IX1BrNh+Z4rSHKmhqR6zgyKfMA63+z9G/E5TL3MVYfggKTUXhlQVpa/D06qAB0fNwL3jsOhU2rIQN6Ap9/tY+7t9fxKDSPVStUQgdB7T+BuXVIhZGjNZOZAcwO2J0kddmZjL+K0FWRoAz3F/94qbxwQ18I6ZDq5O1r//tSAU4+VSdMlTRqxWZEnmVgBcq899rDdswzqSMrreirS1gXvHFcn3R9agoMnicoO0qzT10jqhU5U56YbS0j2gl979qFcRovzoCZUthnnrtfaKwBDlxuDcHp9grECIpPQocJPs3BxIbcUDFM5PPXLQYyTfLQ9MGBMZdqknOvOHoo6oD1/0AigKeaGILRaQIwUK2z7ov9yX+KXg17Ba/nqXcO1QVD3+yOXTD7hSl1o2nOLAbZrby9fM4STtO/8kVL1iKsJ/cHZy297aG/7cVtrW8tGNCn/OrC3JypvT6PB2jMcrJqSmCqSHxT8jycoyNN9sbZngSP40cD
 03s1x92U
 iqLbCnrColhe6MI+rix6Z5/iEMMuVLdTpGl8kMaRjb0h8iwDqQu1a9GeUTdQlf3XOPP+8y2QAzaYhnxk2SypmvMJgeDSK+J+fxXXSa8t/BUyysSG0SFpzd4MBwdhoo0/r/36AnEyQSU0/8tXErf0EGcNU973CvDKTYdU1wk7divyJA4SbEYAQf0/mUqH4a8H9t3PaUDtLoHbOMdSDHgwIWAlEuQKm9uLzcLQXOWrFI/+CWN39ungAphqIFY0dXoKJNSw1XwrAs4gfOmNvVBs8VI+JghKMt12tuVufozcXH72WUC4ylwZsqG/FNCh6rT5WZ/WpXZakv5a4jBW0LHfhkhtbzg3q+2Cqm4c/0ss9apqGCraxMjpRs0cPMAaqVKGGxnYRbFf09mzERcg86GeUP+yRLjSF/+u6SDDLWKQyva/L/wc6bcspZu8ybxtf50NZwaXDbmhSU4kPjkI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

folio_dup_file_rmap_pmd() passes PGTABLE_LEVEL_PTE to
__folio_dup_file_rmap() for HPAGE_PMD_NR pages, so it adds HPAGE_PMD_NR
PTE mappings to the folio instead of one PMD mapping.

The helper has no caller yet, the next patch adds the first one. Pass
PGTABLE_LEVEL_PMD, as folio_try_dup_anon_rmap_pmd() does.

Fixes: d8ef5e311d7b ("mm/rmap: convert page_dup_file_rmap() to folio_dup_file_rmap_[pte|ptes|pmd]()")
Cc: stable@vger.kernel.org
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 include/linux/rmap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 74cca0e3c7264..87c88a9811933 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -558,7 +558,7 @@ static inline void folio_dup_file_rmap_pmd(struct folio *folio,
 		struct page *page, struct vm_area_struct *dst_vma)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	__folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, dst_vma, PGTABLE_LEVEL_PTE);
+	__folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, dst_vma, PGTABLE_LEVEL_PMD);
 #else
 	WARN_ON_ONCE(true);
 #endif

-- 
2.43.0


