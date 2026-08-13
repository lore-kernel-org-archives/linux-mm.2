Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC7E0C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 17:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 273716B02C2; Thu, 13 Aug 2026 13:54:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6F86B02C6; Thu, 13 Aug 2026 13:54:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04A666B02C4; Thu, 13 Aug 2026 13:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE00A6B02C3
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:54:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C86E16025D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:37:30 +0000 (UTC)
X-FDA: 85096953060.09.51E0347
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id AE3C718000F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:37:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="g87o/8Lw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786642648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mJPTehiXiSdt1BNIK6xJnSzDQS1j/lxnN+kNI1EurjI=;
	b=GNqBAPSh/8yXnGGsmZ7ShYZ9dj0KDqI6D72hi6h2ETMnjgC+vleV69arQvcrQ9hxo13k0r
	I/t0Nh85/pwGeXndFBfMUNuBGnJK3VBCNKoR/alRvj203XSVrmsoCLPJDReW0Kjg3AAvd5
	ixYPpofzZikaLYD8yPW9YiqH4y/Xoqc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="g87o/8Lw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786642648;
	b=eD4AaBkR3VIyOtsZ74RIT3m0v/8n8GPOWPRLH4cs3T4q3s1LAkCepxSuMZ4x+PtH1/HshV
	OMRcf4/1Pq2cgNiF5d21hZrt6kcjbdJBYxrf6yo31QyqHHTDIfdF70lNfJRTmsQ0MoSpce
	Ha7T2OOF2uDAlPKrj7JdfXphTTFaDs4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 08F0A4350C;
	Thu, 13 Aug 2026 17:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1700F1F000E9;
	Thu, 13 Aug 2026 17:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786642647;
	bh=mJPTehiXiSdt1BNIK6xJnSzDQS1j/lxnN+kNI1EurjI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=g87o/8LwPgowJqtU2bHG3Mufu+nohJlc3U6lun9oXAPmaBCwkixuTZDN7rXbdKakS
	 mXhifbZ1+rJrS/PCWRJsyf5c8BbMzX5pKEosCqVYUJYGMUEECrhrE+HsbfIOgBaKda
	 8MN2Hz2yijd7TM54oIuAh0fVtzMy5Tg2nV9eUqsGOegNPbXNuCITbdnv32FuFF7IuX
	 5Sbi/VYekz3di2IadYIzKl1LPsRv52IP2u4e/5/SRHMxZ4WS+lLSeL6YudyBGHQknB
	 U1iKaNCFQ95sTMI7Orqnpl+RFqOw+kW0Y0CDpbh0KewYLf91Zrz7qF+EK0CUGDKjHg
	 ZlOMTADzLm4Zg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 13 Aug 2026 18:32:30 +0100
Subject: [PATCH v5 13/16] mm/migrate: calculate large folio page index
 using PFN
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-b4-scalable-cow-virt-pgoff-v5-13-c21581c0c3c8@kernel.org>
References: <20260813-b4-scalable-cow-virt-pgoff-v5-0-c21581c0c3c8@kernel.org>
In-Reply-To: <20260813-b4-scalable-cow-virt-pgoff-v5-0-c21581c0c3c8@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2257; i=ljs@kernel.org;
 h=from:subject:message-id; bh=4CWJyPC33HnfZF8tYHNty46xzNZUZPa7yJy7Pu2iMAw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJq/69Rd/JoXfQxfUbOWnaZwqzqy/9jQmbvev5hzQFh0
 QVWb4wEOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRFccZfrMU3rB5/yarPODj
 V133utms9+Zaec2wdTwoXaIvX7lhMgvD/6j1bxLuvr0pu2920YVPrKcffZ8n/Vv10ffg3wWL+S9
 uY2YEAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: ioye1e1b1hc58pqp9pczo9i5g57ns47y
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AE3C718000F
X-HE-Tag: 1786642648-975961
X-HE-Meta: U2FsdGVkX1+x/DU3uGZ5IhnaPbN/LkKmqmjmqkAtXXA/Sbtr6nmgHjsycrqr8E5PSjE1wyLxtyTnLibHAcyDe2S4eTC5AcYtAdE5kwB5aTdD9ocweetcC4ilRIPxNYmt3RYXmEtHwWDWKSm49vK+3FfKa6abqCWThOXiPgFQtXi3AKCffcbzZoLFDiXx/Kl9gXDvB0unDaTl4DN0RYZI9DweEzVFwg4kEHQs3bDmjJlgpWau3Gvby7XmKH9uopZJrXcfKSFap8xWdERi/zZyb5vSGvhtazpMTlpdrNMN6sJx9DdFmS14OEQhfvtTaPXqd9ODu1nHImjNygH1xRUt2zjoxzqmwBvXHcsfI3YLX9sgGQ7N9XNkaIS3ybNRgVaSU9bHluNg2TSy1AFn1q08G1cmtcjwAmI6pXkowoNxRL2c5OiWi9TPI/JHVaxKfUkmpjiIyzmxlOgKDFvnE72fNgbfjVRKa3jdezLiQJgf0/cgvVeW1/Oz7jxJdeEMViapK4eXWf0v0OhWKV6ExOZdtSGIMj8wIxbZP4VxAsnQRir0SnYP8UrzuNbdKFqRUEbhwNEpKmc/3PDbSfB1wp8G1puKPflHs4uK2yoaVlFV4GZpRNqFNreUk6HKTQv8vMn02/Pyks9Gr14XjIHCCji+h53SIKRVBryBhy0mFv4CBTJ+MTYoTeseNQf6bc0MFf7oQRVNAsfwRAjpXEhy3kPRmKxT2Dv6WDiMQ4dedoY6Wb68u7Kpcwi/FO+8GVYj2e0RuKGhPiFRC0i4KSh8fS8CT93H+/dFTtNkAk7jgTjy8LNuxFTf95a1YYYzG1AkdgjyvNjGaNfvs00yQo+OqGaZnl+xgJF7m4K2V6VbcFxFrfHRBhrq0dMOoI4drur8MjHkIUoQPfaj+zqSdVJMjQgY2kzwxc7Zr2f/G9+/emMtv3LSPX+AA8HXDIf0/iwq054XmQxzTP6AhgDdMa2G+ei
 +W173aK3
 HrUZbKs0TaJi2n5ybKT4YRtr3M3aNExGieO9slsFgCbIMrzWgXNnlwKgNaAbj5jmc0bxIllYHe6zIDsf68CnmVD2Gx3iwpHFJP8ANWtm/FGdMNgX/W7bd1Wv8z/1rD0hNLi47wGUfq4ln3twulmZ64q2yMz+En82Zv7GTzezGRwzLgkQRkLvSL6/BBchziWBOE1p533v84F1Us8n5KQuEEkXylUxhD5HExci+7zs/oZ6WbGcwklnQ7jUHZW/wp4IAlkNHn+him0J/KqvQR8EQn6FWImBp0Z2wAQB6qmv0W8dCZ5aSOQb9d6r0+lfVmTHd10Oh
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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


