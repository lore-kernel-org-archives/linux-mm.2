Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B86606A33D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IJ+jBZKM
Received: by kanga.kvack.org (Postfix)
	id 17E806B05BF; Thu, 29 Oct 2026 16:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156B86B05C0; Thu, 29 Oct 2026 16:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06C7F6B05C1; Thu, 29 Oct 2026 16:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBC9D6B05BF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:35:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A7491C3CFE
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:35:46 +0000 (UTC)
X-FDA: 85376819892.23.22E8D2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6C7F318000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:35:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IJ+jBZKM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96TtEpSKdC/LfLy/tyx1VyuBrcl0jzn2JfhjMCHk15s=;
	b=J/3Ghedrcr5zlYdj8sfSWHsXFTWgNc1yygctX2WWoHKKHCE2uYHHFAznhe+P50Y1LqkOt3
	mWUkiBdNX/Zc39mMiU5x9I/eS/kk943s3/eL7rcyO4EIZlldTFQeR/dA6GoMmTcyRmiUjg
	o7cM7nsYNUZoJMnDrJd8AKSsD/QEe6s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IJ+jBZKM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306144;
	b=1D0C92U+s1d7ef+1NwIppsj+iOHP2UeDqoBms7k+AOAJfu9Yxq5BDNDDOifk+J6GPVgpnu
	AImVyr3EM4U9ngmFOydYc7Zn47O3ADeUtnA+mDyx1xJ/xvUYK3XwGvDqZbEZH587y4GCkb
	sYe1wOmbazQrUooO408lPJ6GqeiU7dE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F117C605CA;
	Thu, 29 Oct 2026 20:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273E21F01826;
	Thu, 29 Oct 2026 20:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306143;
	bh=96TtEpSKdC/LfLy/tyx1VyuBrcl0jzn2JfhjMCHk15s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IJ+jBZKMEaHA6DbBE07ZlAkm4HbB/m+XzRLXVZEMC1wvmXocloFyTi7T9sMwoPtAe
	 2Nw2Kryl/u1bPc6g6JtQHUGDfxYk6K6/efXnRWJh7SVIgjRW1QCLhk1AfjBL4NsJtU
	 ONCKT1TOxTu9I2GWiYIuklRqaKjAyXTHp6kBenM+lCB7MQcaWC5E+/F+ED/x+hYmqa
	 5KKH19Mszf+VdsguhV9hkgZBRrhsKUI3NnfTqVEP3aEDJ3dOSWqPgoHgv7SXk9h3gW
	 uW1rWwb8gPvo+hhFiVMcV4ZXrUi2frKbU8Pe6emWElcJ0sHugqGEAYXQW5P0REqau6
	 VxQataoTrZ1iA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:04 +0100
Subject: [PATCH v2 09/47] mm/rmap: handle device-exclusive entries in
 folio_referenced_one()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261029-fixes_core-v2-9-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3336; i=david@kernel.org;
 h=from:subject:message-id; bh=T2JIigC0ajwmaRTR6cbJfS4ZfpBrmSia86Sk4tbihtY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer20NXFUbFcxnPK/t2pZp63Kvi37c+M3g129eobauU
 /bS942UOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjIqfcM/51E636ILny4PcI7
 L7I2+YLnmfjG86nbO85PXigaOMv3qxAjQ2+10u04vzVbLgiGn54cmniPMz6OkVFV+lLdmY+b5TT
 rGQA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 6C7F318000A
X-Stat-Signature: tcifjf9khswh9wkmjstwy8crntdk9xsr
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793306144-636705
X-HE-Meta: U2FsdGVkX1+UJWvLIRnQWSIC+sC3Bs2N9z5eic2jS2cdsW8DuX3IktXtW2H+B/tmcuY3FqPx3K09dqZGX/djA3evBhLZ6fGqqa4BrvvpfVpYYGbLEUr9aBC7YaILnu/jcojVKbiazCtqTJ13hNy9s8tAFxDifp/lnZE4qugVegLe+TIybIlhLAGbzMGU9WErTjd3Gi4xLA0B0YgrshR9foRUZy1Mjt1F7IXq+F7ktX+Bz7Xo6DkRzZLJEcj5b+CXvAaS9EeWikX5kbeoRHV73kMq01tQ90uij3mtzOGrAFo4gmFpsCiroQSOoomQaK74+mVhxiN+cS3gxjPOUL+f41wX6cqm42kpUFfMSwKgGYbq1OwJOnaq9chkeTi4qNfXk5c8jUD0y/n09AexgdMnyfjaNrIXrLQ90vpDQMbQSgxFVK7ObKZIRVglixJ/y9WXAOV5oNhHYuR3i1DeoGTpvBUwfp79gipOiVR+KRtLnIA4AL1hzgG8NalxqFy9hfMcNTAQIL6UTpYkdbYreuBPOgAXTtiOskUT50nhgfyCWd6i8oNXP+pKwKrvyTs1pO4B3dgCTfeRqx6LPS/pNy2hLoK5GyNgo6KGBO3VUrgnLthxFoNomSU3HpoHYka3KJ0d5vEgPH109E2uCrzg99Ga77OvMPBSqsRiYDUuIzeb/GKgmcnInpCagVHxpD7Vv2B3p284dhRsIwj4zoKp/m/uaDDWS/0rMTOXoE3g9gD6sKZ50NeKh+lovtY8VqF+HV9ePvEE0h2K0Idc6rgoXdOHw+OH8TzMoPTmlx/kSmKGbpA//qI6nGO2tKEPu+BlJOL43OvV7WSArcbU8EdjShyaTg8uXemPEKOJN88rmWhIqAGsmM4svbKSoU7lwT2a2F2HKi+bLubQb/YsK7uzder3ELucPDqd0OXpy8suk5Vjjf+YcAtkBwB/nv//IJqPwI6a6s574Tovj4H+bPEiWHR
 4Yd47qay
 T9ifaICRPx1b10gVjZIWnzmcJDReIfvc1R8ZF4lH3mDQxLVOKa7KzoajDX52m8eXLuy9ojubvJb9DTzSr8LNL9mZlMbtIZKV2NNdDD2cMhxCJfnVIJW67EPPO/rg7p7rJNUD+gI85gJJm49oL97KNwhCEGR3e8PFqLoOCJNt/W77v2dh45CBx4PaycobuGA76EOFHgZripibeEq+oK0fA1F3a32CGbmu69QfcZ0QJQ9ImDqT4bIwEwY2bHaTqd6sWzPeZwz0pkH25dApXNHBoN1hxK8KDX859xmJ+gZ/wwHDZKUyreqX0WZkcXOZDzbiKazN1WJfHGdh1skilkk3X9k1Q/WD6DPrEBU8uYtK9+NXiT4KUP8d7Lxs4OwlOcKeopM0CXQ+yuHlcVGQ4pX/IlT7U7M2iPHxU9jhugcP82xhNoH6QY9lJh8ULEm6lvoLiIZ3bOR0JVgJ5Pei/km+8Bz2zCEYOW6UPcvkEAlJXuCPHfDhL1VFtYUFjfpOgGRtDtPx9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

page_vma_mapped_walk() can return non-present device-exclusive entries,
but folio_referenced_one() passes them to PTE young-bit accessors that
require present PTEs.

We must neither call clear_flush_young_ptes_notify() nor
folio_pte_batch() with non-present entries. For example, clearing the
young bit on non-present PTEs can corrupt the entry: on arm64
PTE_AF overlaps the swap type, so clearing it turns a device-exclusive
entry into an ordinary swap entry.

folio_pte_batch() will VM_WARN_ON_FOLIO.

Apply the same approach as the previous fixes to e.g., damon_ptep_mkold():
treat these entries as old from the CPU's perspective and obtain their
young state through the MMU notifier.

Skip PTE batching and MGLRU look-around for non-present entries, and
don't modify non-present PTEs.

Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/rmap.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 1131b76bbbc2..0faef46806e5 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -924,6 +924,7 @@ static bool folio_referenced_one(struct folio *folio,
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
 	int ptes = 0, referenced = 0;
 	unsigned int nr;
+	pte_t pteval;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		address = pvmw.address;
@@ -968,10 +969,12 @@ static bool folio_referenced_one(struct folio *folio,
 			return false;
 		}
 
-		if (pvmw.pte && folio_test_large(folio)) {
+		if (pvmw.pte)
+			pteval = ptep_get(pvmw.pte);
+
+		if (pvmw.pte && pte_present(pteval) && folio_test_large(folio)) {
 			const unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
 			const unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
-			pte_t pteval = ptep_get(pvmw.pte);
 
 			nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);
 		}
@@ -981,11 +984,23 @@ static bool folio_referenced_one(struct folio *folio,
 		 * are. —they could be on active/inactive lists or on MGLRU. So the
 		 * simplest approach is to disable this look-around optimization.
 		 */
-		if (lru_gen_enabled() && !lru_gen_switching() && pvmw.pte) {
+		if (lru_gen_enabled() && !lru_gen_switching() && pvmw.pte &&
+		    pte_present(pteval)) {
 			if (lru_gen_look_around(&pvmw, nr))
 				referenced++;
 		} else if (pvmw.pte) {
-			if (clear_flush_young_ptes_notify(vma, address, pvmw.pte, nr))
+			bool young = false;
+
+			/*
+			 * PFN swap PTEs, such as device-exclusive ones, that
+			 * actually map pages are "old" from a CPU perspective.
+			 * The MMU notifier takes care of any device aspects.
+			 */
+			if (pte_present(pteval))
+				young = clear_flush_young_ptes(vma, address, pvmw.pte, nr);
+			young |= mmu_notifier_clear_flush_young(vma->vm_mm, address,
+								address + nr * PAGE_SIZE);
+			if (young)
 				referenced++;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_flush_young_notify(vma, address,

-- 
2.43.0


