Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E91F6C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AE966B00BB; Thu,  6 Aug 2026 16:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0604D6B00BD; Thu,  6 Aug 2026 16:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6A1F6B00BE; Thu,  6 Aug 2026 16:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDA6D6B00BB
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:26:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E2F428017A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:26:42 +0000 (UTC)
X-FDA: 85071977844.15.F89DBD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0744A14000F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:26:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bz9YaJqm;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786048001;
	b=49cSY1kh3L+Yu123VdcRJCnyCQkh7zLdctVrIp4qwqYP7aOAnjMffwyJ794fe+Qt1ROFZU
	T3Myq4hwtrIPx0KLgBEzQ8na+KorelMQDhT/llPQEmewNC9ygt4kbM0mIePYklLd+h8EaW
	0gArkenDT4M//oJnAi2to02vbBNpoXc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bz9YaJqm;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786048001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mn4YT2ApRSaopzXET2AIgz+wXZFI9xEUztyKfd8FJpo=;
	b=cjRqXVT96suE0RodoE+cLxNI8y/2omZU07w0769FiPk0vqaSrrbf5ZKZvI1cZ2VeojoA5d
	Ierb0uwfiKy+5n3z1mNyEYzEUzZAP9t6POY9bkEupdGfQBcPdWERYG0CwlfN+hTd/oO/5Y
	yicsBZcifW2MxZGx7ZsJ6ps39GcsELo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F39F41513;
	Thu,  6 Aug 2026 20:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A611F00A3A;
	Thu,  6 Aug 2026 20:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786048000;
	bh=mn4YT2ApRSaopzXET2AIgz+wXZFI9xEUztyKfd8FJpo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Bz9YaJqmzlxB4WCv5/P0brr34RZLbO+nw7RKtFIuMtIXr1B23WLcGGfVbZws5JHDg
	 4W0kn5/MYFl5uOyKgkWovKIR5IoBwr9+SKhfM4P4019fElq3qbQSO5N9RxlRdB98Zd
	 dFccbeEQZ6D3yiweV2Uk8FBxCT7ingqNrMod9zl/Jd4+1vzyRBOi6ZHeHk/cEpObjG
	 cjTcZh6aV81dh3W646BTZoW3aNzM/uyXFcS428mV4apxTQH9uqQzr+8f6uBW3GpiPr
	 jkMDDx0NKuEkOo4Dr5IZx1YkmcvM9F7uFFuv7qetTFV0tBN0/Z0si4F93VwSRYe9lM
	 V2dwQkk8HKt8g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 06 Aug 2026 21:21:38 +0100
Subject: [PATCH v4 13/20] mm/migrate: calculate large folio page index
 using PFN
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-b4-scalable-cow-virt-pgoff-v4-13-ab318a350404@kernel.org>
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
In-Reply-To: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>, 
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
 linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2203; i=ljs@kernel.org;
 h=from:subject:message-id; bh=VU6CEEOG+lJfZQJv2x390tNJn50dr5hRnWobWlENiyQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJK3lwIeJB2srlfIsx5i0XEmznfF7X3dO30t4+XfDqPh
 WeebItfRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACbyj5GR4cmCVwrPdJPy3rfs
 3eN89PEFz+UFG88c4vOcMONUrdiM7BhGhnmzX6asljjyXeCF29OA97E6XqnzKu54/Lqf8L9X/c2
 fEDYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0744A14000F
X-Stat-Signature: kktenhkszrn9mu8g61reta18jwkf6xx4
X-Rspam-User: 
X-HE-Tag: 1786048000-394167
X-HE-Meta: U2FsdGVkX19mc3sE72CgZOZ5tsV3JWXw9iQvAV3l0b0rnhBQkwPbRLe6ANAqr1VFOOFpIdKwLp008lT3RmEo/KfLXJ5kVX5YriVdyd/e6r6/ZP8jRjQLpo6+ftYucyKgQ/Z7mzUsC00e38Tq3biSn/IuxZSeBfDE+a4uraOc0KwhLjwf7KVm/FBRkJISKpkgsySYdx/q/+PHKPY2B9PqDLrDgsEd3V/6P6sBZ6bIuLuWgpOZCCPtAtaLGs59gI/HZRinmDRFSaRG2hgKj2eHxUQHbdcBdns+gioxsVQI2pgtSTQKohYV1E0YV5f81N7nEe7UdcfncSi9/6tG0Y2uPvU0HfnKQ76o2gJVhkpIdgRNmiJc8ZyM3233EWkEqAJDvDtUPfRWTaswcBTj/9ZL5XflrZWbNnRb8Wz2ap5hdpy3hlMBMm1zZ+1k7IEVOyMkH19cE8R3JkIa4UONQEjF+IpHOYzoQ308sDkc8tCEa5GG0C4TmKXbxWl6DX/BHSehpc4eDEvrNKrIvZNi4VSOggUE+UkeH6IDdl9UVF2MQTOJlHydkwWLHGOkS3at6qMFHTIy2L8O+ixN/o/zzmY1o6h85UdWWzY3l+OCssaq25JffjIXs+J18sdJgPuKHRLw+ii0SqjXlvciZ5kFE9V3KNSvq0lQmOmIjRi2k//P7ADqPBl4Dg1xavfHcb8w3fUWZ2xI4+b2jXr6x3JAU1m2lGkuxRbCX8YBo49LwxCf8D8HBFfs2EKEUXRjOcXcDRIFJuoNpEPpxuCbeZ4mnjUNeqFLcdzubohSVYB0pc/Tte6ZxiEcIAWv2FegkgJ3x5ToooPVHvq1vwztxLyvNyoyNF5Jn1g8OW9zlurhhAkPzpHhd571aekwsgFafrrANFjoONahFJWwEHeykW+nmaSsbG8QPZdckfX35kx7hlcTAG1DqUgb9/7eftGcoYDcLa7LQk2cOJs/K48k+1A9pbk
 amruoaUj
 W+o8SpkWstpKhjKW4I18hxLphYWC44SXNJYyv8caM1UxaQRVqMjIaC3ockaEKvSODSDzDgz3f9DJFcXVC9uv09i2NPl/lhxRlcQw/1K8x40kyh5KU/pASWEHRzjezQHQnnCnzP6Y/G4XDHMx1EW8Y2rMTNWK2r2iusK2/wvYZlVQX6ehaAnf/SbR4OtPU3cgA0qHT6PmF9F4TJG05sE6YeAmOxscGfN9pcYaEEpzy5IzGLiQFlqvIjbEJHGPsUF4d9hsWRG1Wop7B9n+1EQ7LffU4jSLVwVCWES6/L5yi06W1xtQxcATWsx5e0+374TNPAotS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than having to figure out the page index to use using
linear_page_index(), calculate it using PFN.

This is a more natural fit as the linear page index is immaterial to
determining the folio page index.

Derive the page index from the offset between migration entry PFN and folio
PFN - pvmw.pfn (set via DEFINE_FOLIO_VMA_WALK() which uses folio_pfn() to
obtain it).

Additionally remove a not so useful comment and clean the code layout up.

No functional change intended.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/migrate.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index d08eff028483..50d0b547bca3 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -356,16 +356,11 @@ static bool remove_migration_pte(struct folio *folio,
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		rmap_t rmap_flags = RMAP_NONE;
-		pte_t old_pte;
-		pte_t pte;
+		unsigned long idx = 0;
 		softleaf_t entry;
 		struct page *new;
-		unsigned long idx = 0;
-
-		/* pgoff is invalid for ksm pages, but they are never large */
-		if (folio_test_large(folio) && !folio_test_hugetlb(folio))
-			idx = linear_page_index(vma, pvmw.address) - pvmw.pgoff;
-		new = folio_page(folio, idx);
+		pte_t old_pte;
+		pte_t pte;
 
 #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 		/* PMD-mapped THP migration entry */
@@ -381,14 +376,18 @@ static bool remove_migration_pte(struct folio *folio,
 						pvmw.pte);
 		else
 			old_pte = ptep_get(pvmw.pte);
+
+		entry = softleaf_from_pte(old_pte);
+		if (folio_test_large(folio) && !folio_test_hugetlb(folio))
+			idx = softleaf_to_pfn(entry) - pvmw.pfn;
+
 		if (rmap_walk_arg->map_unused_to_zeropage &&
 		    try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
 			continue;
 
 		folio_get(folio);
+		new = folio_page(folio, idx);
 		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
-
-		entry = softleaf_from_pte(old_pte);
 		if (!softleaf_is_migration_young(entry))
 			pte = pte_mkold(pte);
 		if (folio_test_dirty(folio) && softleaf_is_migration_dirty(entry))

-- 
2.55.0


