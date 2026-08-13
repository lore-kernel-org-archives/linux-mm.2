Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3839AC5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 17:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE0D66B02AD; Thu, 13 Aug 2026 13:52:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B91D46B02B1; Thu, 13 Aug 2026 13:52:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 995EF6B02B0; Thu, 13 Aug 2026 13:52:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D2916B02AD
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:52:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46BA0A0241
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:37:10 +0000 (UTC)
X-FDA: 85096952220.29.1CFFEB1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7E16B1C0005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:37:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ixA7p747;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786642628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vaw3s6T/GSWhGIBxH9c44M6soIaJSA08keLAt3jySb4=;
	b=a11Y4y6XJAm5fE9da4qQsjU5pEItgZfDqa1x1kcE4e9UlTGjmjYTYLArLUZ4MlGGOD86NZ
	9jF1Z024j4b5YiKgFpT5zhxA3XLa4Dsi1DNz/u7N6eCHwTkesn7u+Gb2Np5krgT4OjtImd
	h5/kHmswo5wUMuUnulG26z3ftDdXwyQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ixA7p747;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786642628;
	b=VX1kph0B/bkwsKdRoJxgQHbowhIY4WQ+hY7kkOFHFQJHYOin+6n7Eie5I00vpbyhq2nOtr
	/LthKR2VHEcd0ZREokGB6x3Oc/hYV2FFkjZI0YS/Cbz42mvwKeybpVQ7h9FxXT1y07JiNn
	jDDOCdxff2e3fBYpTv+OMxCr2iNNme8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AACBE4178A;
	Thu, 13 Aug 2026 17:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A411F00A3E;
	Thu, 13 Aug 2026 17:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786642627;
	bh=vaw3s6T/GSWhGIBxH9c44M6soIaJSA08keLAt3jySb4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ixA7p747hccwgImJ59EcIdFEdSb9rc3LOw5kVbJpKoEo+0MrDfKmMlBaTs4ef7wRp
	 Y09zqNUCXL/Q1nXEnswtP39scxNB9QBcvSpkUWXqiJes3uks/0pES6sNqGYVl9zfIH
	 q1UdbZqJfKD2AjguBvWW/DtZR+cJY2l/Oa3RXrVhsaKxiZXggZapMoIY6l1WbpapBK
	 soW+xVWeTSY/FLuyemB/fTPfHP/6sgSHr5/1/K6gAGYMJccN3jC4vFXgCNgBT8mAwc
	 TAhftfuvaFfkEVyxyj0At3cGYA9N/gt8Q0gNTrFfMACpD2FzWDj1uimQe82B7+ml91
	 7mrNMhuTrg+7w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 13 Aug 2026 18:32:29 +0100
Subject: [PATCH v5 12/16] mm/huge_memory: update remove_migration_pmd() to
 accept a folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-b4-scalable-cow-virt-pgoff-v5-12-c21581c0c3c8@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3818; i=ljs@kernel.org;
 h=from:subject:message-id; bh=q0oMVyXXBC+siqfel45AxXFQKXhgvOdgu44yz/skNq4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJq/6/5F1G55rl8yiLzKSurYtcednm68v2b5LfO17iun
 E6r5tWz6ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBESq4x/E959/lG4ZRWo3vN
 /Px/yn09V2vV3/rQ2563THRvA/eG/t8Mf8VmWS7u+1xZK/v/296rxqzNa68cNXc6UXH325RilYd
 3s7kB
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E16B1C0005
X-Rspamd-Server: rspam07
X-Stat-Signature: eybnycn47qr8thwtnpispts8th3k1i3o
X-HE-Tag: 1786642628-131396
X-HE-Meta: U2FsdGVkX1/zX+n7SgZbNPINzW5Ny1h9E+sJOz10cyHMCCQwSUMdco+UjMzHCboTAt9W2Oc2P/RCZqnG+9qtXIbY/CWRSUdPUcP3NWmHeOgYb2GbjRhMIOOcFNmhanJPabg6QjpSIz7FsQVmplBbcLoOmU8R9Di8E2UhZfBVdz010qc6D1XlLSBGnB//nk4OdZsRP5qOzemMLZUY8/uXF58T0JQQlkidx7h4jiqrpzLoGwBFifNCgWc7YAu4Dy2G/pkD1gVOgS0Q+2NSZPkmTU8T3D3VAX2nFpMpQfa6QPKm5Go+i/H1+eS4IrdTJk+qfMg1wLzXi8InhJIDtUKJG6I6D6yWxuSbvkW8qc+Av3pwwa36EtLXJrSGmxE0LbHFVDYevDFaAd7CbrwGR+1VVsf6uPiHJhSa93pe2z5I5ADcxW8cqMDFqzdPK+fNaMGJGymY0dj9/w7akdrjOIzqSEntlv7ULLGSdSJLtpmrTT/rYP0pcLf4HFuobQ+YCFOhjogD/z2ug2Q8S8tswebsW06k5lGrTdHk1WrROJybmjarWvTuze05zHKkXbmUvKkzRGNrXmQHvUjxwAflnsHRJNAOhUh5rcbR+ARmOTp+ywVYBGlRRUACd4pex+TKZIWhfp46zEp2j7By+kFVaQldeMJH9GuIgaS+JONLXMwx3tP2O9unuuUSx5TgsWVOTIskWFfpN28nxDaY2td4TLrA054f81UinAgKJW2bQZB7SfJ+gT/WdYRGcFEJus1qqyNjTbMHEA1F7lPtLEjlQ/dAjyHIG1qzhqhf+c/mmJ7UxeNl1DQx3Q/wuwV477crFFB5Uczf4SNfPxCX7+YMGPcFqe09DJTm132mWom4i1wW2hX1Rsxup88Hpme75L4fEGo9o38eBrzOlan2xwTDj0QWsCqW4U5QnO9i/rf3nPwqequ3LvjlIOlWW7+Q3tT6sZ1hN22XX9oORsXYse650DX
 0KSNqaN3
 pjLOtaG5tvhOp6t/8ZaVqWNp3YFQn1xg4AcP7giaJGsLw1enlY6rE+LzAEYnCaGEMBqA/Gr6Ycas5KjwN2p1+7EoqidQpgwRr3izZET3cEiyB7Kr7OlG5Xd7+pVwSVycmJcvopIiYmdT7r3Ja3fWqeYxuyiHPqEaWppwA0Q8zwFaHQZ93aSZ3JZVbg8of4NFGhth5DVqNJ91PJE8pL2JSZF13E/ep1YmsfG9AIyhsOmHXUNr+l+aDMihywOohKZLO+nG5IhoPNG5SgnpUi+xjf7t9vSRGMNcF6fR4GcGGJdp6/4eGrDPhlpA4P4ZtA/Hhh40n23f3mARcDwKjoUT5/XwtBNyDGL+cFsTl1tiDHzt9zmUj2BEuiovYLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function does not need to accept a page and requiring it to is
unnecessary and misleading.

make_[writable, readable]_device_private_entry() must be passed a
PMD-aligned PFN as they immediately used to obtain a softleaf PMD entry and
the same argument applies to folio_add_[anon, file]_rmap_pmd().

While we are here, update a VM_BUG_ON() to a VM_WARN_ON_ONCE().

No functional change intended.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/swapops.h |  6 +++---
 mm/huge_memory.c        | 16 +++++++---------
 mm/migrate.c            |  2 +-
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index c956bc445ee0..1f3ff3b93e16 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -325,8 +325,8 @@ struct page_vma_mapped_walk;
 extern int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page);
 
-extern void remove_migration_pmd(struct page_vma_mapped_walk *pvmw,
-		struct page *new);
+void remove_migration_pmd(struct page_vma_mapped_walk *pvmw,
+		struct folio *folio);
 
 extern void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd);
 
@@ -346,7 +346,7 @@ static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 }
 
 static inline void remove_migration_pmd(struct page_vma_mapped_walk *pvmw,
-		struct page *new)
+		struct folio *folio)
 {
 	BUILD_BUG();
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6b0cabd45b2d..47c9c6e32eba 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -5020,9 +5020,8 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 	return 0;
 }
 
-void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
+void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct folio *folio)
 {
-	struct folio *folio = page_folio(new);
 	struct vm_area_struct *vma = pvmw->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address = pvmw->address;
@@ -5058,11 +5057,9 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 		swp_entry_t entry;
 
 		if (pmd_write(pmde))
-			entry = make_writable_device_private_entry(
-							page_to_pfn(new));
+			entry = make_writable_device_private_entry(folio_pfn(folio));
 		else
-			entry = make_readable_device_private_entry(
-							page_to_pfn(new));
+			entry = make_readable_device_private_entry(folio_pfn(folio));
 		pmde = softleaf_to_pmd(entry);
 
 		if (pmd_swp_soft_dirty(*pvmw->pmd))
@@ -5077,11 +5074,12 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 		if (!softleaf_is_migration_read(entry))
 			rmap_flags |= RMAP_EXCLUSIVE;
 
-		folio_add_anon_rmap_pmd(folio, new, vma, haddr, rmap_flags);
+		folio_add_anon_rmap_pmd(folio, &folio->page, vma, haddr, rmap_flags);
 	} else {
-		folio_add_file_rmap_pmd(folio, new, vma);
+		folio_add_file_rmap_pmd(folio, &folio->page, vma);
 	}
-	VM_BUG_ON(pmd_write(pmde) && folio_test_anon(folio) && !PageAnonExclusive(new));
+	VM_WARN_ON_ONCE(pmd_write(pmde) && folio_test_anon(folio) &&
+			!PageAnonExclusive(&folio->page));
 	set_pmd_at(mm, haddr, pvmw->pmd, pmde);
 
 	/* No need to invalidate - it was non-present before */
diff --git a/mm/migrate.c b/mm/migrate.c
index 222c8c15f782..d08eff028483 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -372,7 +372,7 @@ static bool remove_migration_pte(struct folio *folio,
 		if (!pvmw.pte) {
 			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
 					!folio_test_pmd_mappable(folio), folio);
-			remove_migration_pmd(&pvmw, new);
+			remove_migration_pmd(&pvmw, folio);
 			continue;
 		}
 #endif

-- 
2.55.0


