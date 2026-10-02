Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 021E0CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE3C6B00A9; Fri,  2 Oct 2026 05:56:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9EAB6B00AA; Fri,  2 Oct 2026 05:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66916B00AB; Fri,  2 Oct 2026 05:56:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 802CC6B00A9
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:56:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 15E3E1A067F
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:32 +0000 (UTC)
X-FDA: 85277231424.10.4601E07
Received: from mta0.migadu.com (out-47.mta0.migadu.com [91.218.175.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0BD9F20006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G7ZL+Ulp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.47 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790934990;
	b=LEjjcodpCEiWKtgz9UZS37Vn2bzfB3UlyEZs1y7EafVWg/etJCUubX1wuoHDlCwu3a1u5V
	85QsWKEy9vRGb2sook/rcQNKBOlTaBfm4PwEo97gN3jHkTavR3Vom/HYDBa+KJMsBiC6fa
	nq0bpSsyM96gJMzOYhMikJNkXQ3xi/U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G7ZL+Ulp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.47 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790934990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sXxUeczxzic98uLqEn6HrX3oaqLkgnh1eK0WWTKzeCU=;
	b=azyDUNLrdvK3BdtDaHFNZeq20sIp19zCfI6eO/2kfxEKvRQkezzlyFGSCGUomqUK1kpS+R
	sDt98sQYW8w9XRNOLm2C8+4j/KWvQKk/FDaE3kuN6XeyZriuOsrbysiD1Yz33Kthm6pkUJ
	OxX0RvJOfQxpcCEBBTQNwi2kULk5teg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Gqph+pRQ2PnxiCPetGAbfk568P6MjZ14SuRBF6mfi6M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790934988; v=1; x=1791539788;
 b=G7ZL+UlpSifjKtqAiRJTFGbf48ABz6KgRtktOPvoiskDBir2qWuafQNQVKgXjD8NoAkfotIh
 TYFbBKdQBm5B5VDEtd6kAmeC0YnMSLLxlfaBDCde6Pa0o6oDWDbbnryckIdEHLXrvI3Y8Cb7hcY
 7px4BlphitXMWmQZ0MUunggQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 53404ca15399baf8;
	Fri, 02 Oct 2026 09:56:28 +0000
X-Mizu-Trace-ID: 53404ca15399baf8
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v8 11/30] mm: split PMD swap entries into PTE swap entries
Date: Fri,  2 Oct 2026 02:52:25 -0700
Message-ID: <20261002095503.3585565-12-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 679gm9fn9qyw8gj6nhasm7hsms5cfd8i
X-Rspam-User: 
X-Rspamd-Queue-Id: 0BD9F20006
X-HE-Tag: 1790934989-858010
X-HE-Meta: U2FsdGVkX19BtXlgnV2wFJ/rW690QJgXUPGhsdPT5ikga7TmkvePscIB8lonVWdzUfWbf28ldsraXpWk2RUMGpY3IoCMX+UoA1b6hfziAfRyVf+JNikNfwfm9EPhD3f5clpY6hE58qWFpNh173iDt/kQIDpg+eua4I5WGnkDfinGzQZKRixe4r0YiBsFuFkOipk6IvKwlCc4pcoaBAlgkBYuFU4fU1GcvFNq6U/n+vjqQI1rtxh9cmWKwoY4wEux2/QsR7RCVn/5mE3xjY5xPbWzss/EXuCVZG2cPgt/hXermuGoNmDIoHsJUKdrDf77XhbIaNEtdshRyt1tg5v28Qs+k23Z6X6mYVk8ZIvkH4B1k31ws0dnoGs3qNcnnsS/G/QrGL8Zhu2kETechIXDFPll9jGaRlrdiBGdmBPvaK6K3T08nS+dLPY84JKej892Ey8b3/AfCeeYoGDHWoI12eXDeW+lAqTrcXc9OP5yipFgGEuhobGrc5i9DLE9ErCZ+Er5ypEVhPnVAvfnacshdUM3tdLrGuP8uzsbjw041cFW7DLa4U6XSr8rGKOqeR4AwShxb/kjYKvazI+bzA9HBz0bfj5bDusZFk6lTVOstjcvCvTPXtPczviUiCeQE73vAmvGgLQMXypEmSL07WT1g1W5uArvkrKgjBfxY8SS+H215p9mh8WY6LXvtASlrcYnVGg7NUGmUfoVL0HtvfuS6W2n3RbIZljf8McLrbARSPk0HRpKsM8BQX04tO2kgRnOOKGe0QskscNd9S8/AUR259SR7YjbJDT2Iw/lPS31XgODknvbq0sSVFgix1eVA4l78uuPZnYqpijSPSlXpALf08p6JM7sKTCwcrxPnpfzrV5Zm5xFc+MDCaN0t7u+Yb8uVGwqR202HSJ9osUPkazw3ui8Z7ov8mAgT4cW1WM+tagzNBLOPwPkrt21z8z7uN/mG1/lMExGPiO7dtR693H
 cL0zKZL4
 RB7nYcX+N31hv41DZtmQ+UcrLfXewOSNPJPCDv0J56E5GMzedow6o0+5zITuGiFMszwfgYmczjyNfU/g5kMijUGcE2dqradgq7+560Hak/9GVqUglokVdgQuh1yiENcxc6Gx7w5IaoNeoTvzfA/00PyYePnbcQ8nMxsDjcX7UqAlTKkMoFZvcE69qeYyBjs9vSmsdTK/qMlCOejJ58cePHL2ld246qJKaAMR2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Once a PMD can hold a swap entry, everything that splits a PMD - mprotect()
or munmap() over part of the range, MADV_FREE, a pagewalk with no PMD
handler - has to be able to split that entry too. A swap PMD already passes
the pmd_is_valid_softleaf() gate, so without this it reaches
__split_huge_pmd_locked() and falls through to the present-PMD path, which
pmdp_invalidate()s it and calls pmd_page() on a non-present entry.

No reference counting is needed: a swap entry pins no folio, and swap_map
is already one per slot, so the PTEs simply take over what the PMD held.

The migration-only entry point cannot reach the new branch:
page_vma_mapped_walk() never hands back a swap PMD, and
__split_huge_pmd_locked() already asserts that to_migration_entries
implies a present or device-private PMD.

Test the pre-split old_pmd rather than re-reading *pmd in the trailing
folio_remove_rmap_pmd() gate, so every entry-type test in the function
interrogates the same snapshot. That part is cosmetic: pmdp_invalidate()
leaves the PMD present as far as software is concerned.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1df4f619620b4..24d116ae1fc30 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3306,6 +3306,11 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
 						 vma, haddr, rmap_flags);
 		}
+	} else if (pmd_is_swap_entry(*pmd)) {
+		old_pmd = *pmd;
+		soft_dirty = pmd_swp_soft_dirty(old_pmd);
+		uffd_wp = pmd_swp_uffd(old_pmd);
+		anon_exclusive = pmd_swp_exclusive(old_pmd);
 	} else {
 		/*
 		 * Up to this point the pmd is present and huge and userland has
@@ -3443,6 +3448,21 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 			set_pte_at(mm, addr, pte + i, entry);
 		}
+	} else if (pmd_is_swap_entry(old_pmd)) {
+		pte_t entry = softleaf_to_pte(softleaf_from_pmd(old_pmd));
+
+		if (soft_dirty)
+			entry = pte_swp_mksoft_dirty(entry);
+		if (uffd_wp)
+			entry = pte_swp_mkuffd(entry);
+		if (anon_exclusive)
+			entry = pte_swp_mkexclusive(entry);
+
+		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
+			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
+			set_pte_at(mm, addr, pte + i, entry);
+			entry = pte_next_swp_offset(entry);
+		}
 	} else {
 		pte_t entry;
 
@@ -3470,7 +3490,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	}
 	pte_unmap(pte);
 
-	if (!pmd_is_migration_entry(*pmd))
+	if (!pmd_is_migration_entry(old_pmd) && !pmd_is_swap_entry(old_pmd))
 		folio_remove_rmap_pmd(folio, page, vma);
 	if (to_migration_entries)
 		put_page(page);
-- 
2.53.0-Meta


