Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFA18C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:26:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE2D96B00B9; Thu,  6 Aug 2026 16:26:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C939C6B00BB; Thu,  6 Aug 2026 16:26:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5C086B00BC; Thu,  6 Aug 2026 16:26:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7ED596B00B9
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:26:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0FF791A0222
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:26:22 +0000 (UTC)
X-FDA: 85071977004.28.9113720
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 406F6A0012
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:26:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lDrqZrNR;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786047980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yu2gHLRO/SRcmXO93obChsLu5SUfHnH/15hgrAMzxms=;
	b=xDkJ9ZONHvq1B30/JSJm/HsHIIIpZndt+1xoNOzzBfm6GeO2+0jA0Nc9kFKJCRUKRb2Tg7
	HHTuzsbfH8O3K9scQszT820XVsPVXIcD4sWII9zZvEURgSW9CMPcOMIeMOhe5YQosItRG5
	RHRuXzih3SVJKiulmV1wA3ClWsl/kSQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lDrqZrNR;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786047980;
	b=nYK2xHNXtABZnRPkKqbHC8OqNX623C7YWT5gl4RsVlXmc6Z7KUMPfBoMDWIBtOpXvmNXIQ
	J/Jn5PX6KqG3SxkwRW2TI5UjgFC9I041uj+wgduvy0I7M3deKKk3w3522VIQLiYsseG53l
	zw2dAes36i6/yqKKzGNPqCw6OT4MOUQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A728408AB;
	Thu,  6 Aug 2026 20:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F6A1F000E9;
	Thu,  6 Aug 2026 20:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786047979;
	bh=Yu2gHLRO/SRcmXO93obChsLu5SUfHnH/15hgrAMzxms=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lDrqZrNR/iyUmRO+7Z821lHEcT77036v+dj9GNHtUzgqrvxHacNZrqPcieg2kFf43
	 5HGbiuVs1H2Ve7zRIBdILvDZkIrcpocaVff5jnMAZzWLZg2YNb+Z9a82hwrlqDC179
	 2FNHNc8gt0ohZFRtnB8QeJLOtoCkiKBc8gkwVGHzQUQa7gedN8WTtjcgwQIMcY7nkb
	 LqD9qwm5KLRniYu3UF9X2g/XBoYniq5+YbWe49I4clFRHPT238KYlH8gr9XZ+5iekV
	 3lwQaZKSn1TWM+iyon8etePZojIgXmHbpASvl5XH+XGN2VM6Q28c+jxiu8cqLD8JVS
	 na0KUcOWeR8eA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 06 Aug 2026 21:21:37 +0100
Subject: [PATCH v4 12/20] mm/huge_memory: update remove_migration_pmd() to
 accept a folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-b4-scalable-cow-virt-pgoff-v4-12-ab318a350404@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3764; i=ljs@kernel.org;
 h=from:subject:message-id; bh=FQvfrIChtfCHHXCKi2iMmw+WlLObO/vvN/oq4qWGhM0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJK3lwoPfTn83L/Ct6FU6LefJ/nERIndmuDX9Mxs9Upq
 jzvj/3l6ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEHiszMnRONebz33Tm321v
 5aounvlauhNrJ3470nLLuK9hVaDcwypGhiPhRnsvn8m5/+K71JUYLtsNzQz8axce+Swm1FR37hj
 rDUYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: q8kizfa64mwit5dtc7pdaoay8cjuomij
X-Rspamd-Queue-Id: 406F6A0012
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786047980-137871
X-HE-Meta: U2FsdGVkX1+GfRcoY4e5diBzXrMahEg4SuxKwTiy5aPjKv77kh73vU5Gyglxr3dU8KGO+risGGhteNIEt2/gC8npCdeRqkENclgBKYCW0roEmpCtzAGsCOdPyNVix50iIWg7AcoQsUrJluhmcp8mIw06y/uUD6bF7oFKe/Ly+kVLwyOoVXSqlhcJmOolDgVUGA3ELJAb/jekPAjB8uAY4ZZXzeGjB5XZXxH/mWYu/gECnjhlJ/jbXaTP3axW7mfPljWxJvgJvF9LJFNn80DNdataDaOPqDzoNNbkJQqkFgy0Dhq9pQyZNE/f72EIgwJZ9DuUF0Hm75cIk7yb5Y6QhqG5oHMz3Qz1tx1/GbNEzulANksfyN4E1ZzpVENt+kbz+z3OUtidH6dqzHNV01V+ZPBU+LHLefx61lxtuBNXLfSvtzO8YdHkeWilu3QurVVaa0FTEtt7mxDItBDFPbX+S23X2kyO/GIQd7SUoWKVmXsT2ORrijAan0CDfvBL9hBD8PUAOmJgpvz6isCd9HvEbjf+0Bzj0gjhr2WO3VG1s5DkkrSuz+FQk92nrJXMM247p3mRMCECCQNQ+piVtmyJ+ivWz992Vre3AL5JJ/gs21Uz6tkgDRF86uPE7K7e0F1HBek1/qDdfUqdqCjtpGhCs0evTUUqIiRdnbHrPtxt/f6+EwSDPRB/vzuK6J/asVA8JkQQ6A2qbR4S++1tCT5yVeTQBDrOvmtfxS14+EvAtE62eZB/6QiUfC6mqb/o8SPeOsJRZY0EfE5RCsqaDMsOVtG8860zP+LnQfnrmMt7AXBWfReJP7WZrkb8xikwMgTpt9TQAbg28oyRtGgW61y+7N2HnrtVvVdv8hPnO8nwrmzK/PTMSjSW39JqZDhd7MqewjWLu6C9mVPBuEDO92UCHKKxK9ws49HHLugW+009mk30rhzxh/oUiAp1zR4wTpkH8r+/PjOycVgnkkVN1RG
 nVMEAxt6
 I8guRvIIIAthlXZVnMVAOSttsv/2aq4zFj+JBCeCAeGr/0BtGeCWM+FxhIHLbI5+cT1OOqxyAgqE5BRuozWl6BhbLsXPJQ9D37GC2jbptNKGvuzp3JQE2c1q+ipCcfkQ45LNzRVGp/UgxuYEDz9on0r/dcB7KBSIZqbmqU53VMS608yK3mWS9Ggj3sMRaLxGp4G8+HLGxW52L3VqhQbMU3v70dlsDYDIchsEJcKrn78GqkmFlY4429X+MIVbuKllLZZiN24c8jYyFesRF+As1qHaevfX77GLnPKHxzMmtlmajFk3PzDqEDabYOwvuKkU/mMwnSDIpwTVvW+0HqrUvL/YVEGPhFvP+QXmoM6ptCDBY2yoKAi+Yv4dFLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function does not need to accept a page and requiring it to is unnecessary
and misleading.

make_[writable, readable]_device_private_entry() must be passed a
PMD-aligned PFN as they immediately used to obtain a softleaf PMD entry and
the same argument applies to folio_add_[anon, file]_rmap_pmd().

While we are here, update a VM_BUG_ON() to a VM_WARN_ON_ONCE().

No functional change intended.

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


