Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BBA6103FF85
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 21:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759AB6B00CE; Fri, 27 Feb 2026 16:30:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71AA96B00D0; Fri, 27 Feb 2026 16:30:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62A666B00D1; Fri, 27 Feb 2026 16:30:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E4026B00CE
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:30:04 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB707C2CDC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 21:30:03 +0000 (UTC)
X-FDA: 84491529486.03.FEF2BB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 560BA40004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 21:30:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tsQtuSWO;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772227802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ULqTZdB0/nGOoIg6KszlUOBrfXiR0UHDwkyJvGZOfck=;
	b=TZBnPlND7CMguMp3pUnOZ16IXqc0/+zaqu+A/Y5TWahJXB6GDqmrOg28MyOCe2MP9vlW1Q
	SH89j02yPtEsfqi4cUKHOL0xx9Kxomgb6HAMdBTfNOIlwwogGTrC7Y0Rqg+I3oN9oHOfY2
	C4GfcEAihD2ZuH1ddWI6k1m2D/G4FuA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772227802; a=rsa-sha256;
	cv=none;
	b=fMeHtC4z0G8wiO2ypZAmb50OYEN/LY0zSUa5NiqX3PWvQ5as1BAMTIwLWKf850sxslfTek
	kZ2B68sEJJ94C6iION0tD6pXqfAQCnKNy+xuThXeUQ8Upq13yjIdAshCdCMhu+b7tEL934
	BZ5q3hbT1P6E4sjFZFv3487NFfQzCpY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tsQtuSWO;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B9A5860054;
	Fri, 27 Feb 2026 21:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E84C116C6;
	Fri, 27 Feb 2026 21:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772227801;
	bh=zVjBpLnJja3QRANNRPRIoj7Orn3a8Dd4CBkiZNiAtU8=;
	h=From:To:Cc:Subject:Date:From;
	b=tsQtuSWOQfT0oEOWSDSDL+itRJ8xcnqx/gR3rTblUm3Vc5/VBwRmGWBRQ1eVGVfE/
	 qrbf2SwGka7Z2SRQPq4jZC2HcPiyUDXG5I62FXkf5ec8RltuD2FoqkfIzcxlWE0wSj
	 Ekc4SASh/4ilFk/4CuCYCp+eJ2xvdV+f75hOWiSdoNvhggvySmV3q+qfC9EvtB9N/v
	 Uac0Y0r/TlouoT5nSr9xaKMhYvFKV1zN3TjxqQ4FvG2GY6hZrdl9+MDTSMBsCKoC4X
	 VFgKPKY1BujCfDmZ0W3UXFqWrwHUbq2weAec1YtVFAqFbV2afDG1qOuVk88bBWkQUd
	 /RmkfrhslNTIA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: "linux-mm @ kvack . org" <linux-mm@kvack.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v1] mm/pagewalk: drop FW_MIGRATION
Date: Fri, 27 Feb 2026 22:29:52 +0100
Message-ID: <20260227212952.190691-1-david@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 560BA40004
X-Stat-Signature: ycaxmm4sx8n1dj75d3brtqwjyue3nump
X-Rspam-User: 
X-HE-Tag: 1772227802-530146
X-HE-Meta: U2FsdGVkX1/mhH1i1spYlhCgQvqgtPBj7krgClcPtXx26xbgXpsWXTu5iwxvp8xGVezLyrT+ud9b4Q7HPfNfVxMAcNvcrnL5L1xTr94+GNaK1n/3JPJpXux5/7Vft9fPee6GTohofawtD1G5yN8JKTLAp4mcxzIoTxfjYqoE4pxJMpWKeDWvtjDyEPa2fJLq0/ctoRSMzdrO80M57Joi6Kd7DZg2rj9+Bdh72TDYBN0jgAlGI1kG+SxHvYCyhJFz/UHmpbjVxBYf2TSgJZeIcdblFpbZNbZdFhYXPWXKs1LTUNzVnu5ctHl4t5SiN+ltgCAU90QEJ5MV4rY4bJQglryXb3L55DnQGlrJbOkZLDQZfDjrE+B5QkM7PV8/gkxVY7PUXTa6h97EGeAD7X3R39rpPthFOM7aiAhZMSFmuziHF8H7LBRV71SI45nAloKwd7veR98CyX8h08hn5P6YNXafZqWphAWmH313dqWacDRgG2EvkcHx5lIFblftSY/hblzgq9ZDpYR2hb9Ij6hGkqPsFctZpOJklEmZrcNSTM0JuZPZKnbJsPfynaiI7f1mfufn9o5rM2zM7phVKzP193ifRJ/d6xsDykMOAcMD89OB4SNJsL8xGISJghXOHDjdELEnRlCH9UPMB07nA311LE5tBU82TmDnn3dhclRblu+XB5Kl3NYC+k/8Do/ExgLQO9YKPZqFuM9lWrJILsng2OZ929XqTcJn1M6xVgPDsQcxImWctrTlHv6QcyTMa62+CdDdsUoXQBGmfCeXhvmo/RklI1QotNu4thvcYEghupw3ruN8asj9HWKo3rUMbzwEOEQ+RyMp3LkyF2d7OgSjlmgvnAq3h9EYeBdloV79CvXSocobFmJjpj2Q9pSSLb03SJ/g5yS3l16J1jqfWn6wGWzfnJa7yZV2pAsXL3uBdZCIj0Jrt7x6sGVrJHotx+QX4QeaSl6vzGOlCZ56uS+
 UzK6mbfq
 5eQoeOnjBxwl5fwyz72Snv3ubY6CPKFPZFJAEranMUNArTJ1PagLelZYvJq7pcTNqmpPMVvIZaxu89JkdPZfpQZ5pWL2oXoUlrjbHsGOXjW7YpOsrMEaa1j9No0sX938eb18/wm4fjRns3A8oSAJaQzmYzfP9PaWXkzZ788U5Ba1H5aZkMfuu3wIQ9hbhbBj4KpAyw5sy5ob5Nyq5DXID95o4Zi1EuuiNHGJrLMcDTKN/A7xWk7qSty19PN50zkj1Cip+wzMi5WZtpVDAJH7wSC0pb2u8jTZ+xppBe1K2z7P119hqydXcTk+hYGaGGZ3xMnnZdggFb4duO8hH7f7RMjDB1v5aBIJfAU7TtER2as8lME9Yb8DZ2pelzQYb1zE4i4oZuyJYmItXheP9kSAPZvl9giD2CiDvNdtQoKWywJq1Hjvgur3wZWkzQaHWnewipT99
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We removed the last user of FW_MIGRATION in commit 912aa825957f ("Revert
"mm/ksm: convert break_ksm() from walk_page_range_vma() to folio_walk"").

So let's remove FW_MIGRATION and assign FW_ZEROPAGE bit 0. Including
leafops.h is no longer required.

While at it, convert "expose_page" to "zeropage", as zeropages are now
the only remaining use case for not exposing a page.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/pagewalk.h |  8 +-------
 mm/pagewalk.c            | 40 ++++++++--------------------------------
 2 files changed, 9 insertions(+), 39 deletions(-)

diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
index 88e18615dd72..b41d7265c01b 100644
--- a/include/linux/pagewalk.h
+++ b/include/linux/pagewalk.h
@@ -148,14 +148,8 @@ int walk_page_mapping(struct address_space *mapping, pgoff_t first_index,
 
 typedef int __bitwise folio_walk_flags_t;
 
-/*
- * Walk migration entries as well. Careful: a large folio might get split
- * concurrently.
- */
-#define FW_MIGRATION			((__force folio_walk_flags_t)BIT(0))
-
 /* Walk shared zeropages (small + huge) as well. */
-#define FW_ZEROPAGE			((__force folio_walk_flags_t)BIT(1))
+#define FW_ZEROPAGE			((__force folio_walk_flags_t)BIT(0))
 
 enum folio_walk_level {
 	FW_LEVEL_PTE,
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index a94c401ab2cf..cb358558807c 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -5,7 +5,6 @@
 #include <linux/hugetlb.h>
 #include <linux/mmu_context.h>
 #include <linux/swap.h>
-#include <linux/leafops.h>
 
 #include <asm/tlbflush.h>
 
@@ -841,9 +840,6 @@ int walk_page_mapping(struct address_space *mapping, pgoff_t first_index,
  * VM as documented by vm_normal_page(). If requested, zeropages will be
  * returned as well.
  *
- * As default, this function only considers present page table entries.
- * If requested, it will also consider migration entries.
- *
  * If this function returns NULL it might either indicate "there is nothing" or
  * "there is nothing suitable".
  *
@@ -854,11 +850,10 @@ int walk_page_mapping(struct address_space *mapping, pgoff_t first_index,
  * that call.
  *
  * @fw->page will correspond to the page that is effectively referenced by
- * @addr. However, for migration entries and shared zeropages @fw->page is
- * set to NULL. Note that large folios might be mapped by multiple page table
- * entries, and this function will always only lookup a single entry as
- * specified by @addr, which might or might not cover more than a single page of
- * the returned folio.
+ * @addr. However, for shared zeropages @fw->page is set to NULL. Note that
+ * large folios might be mapped by multiple page table entries, and this
+ * function will always only lookup a single entry as specified by @addr, which
+ * might or might not cover more than a single page of the returned folio.
  *
  * This function must *not* be used as a naive replacement for
  * get_user_pages() / pin_user_pages(), especially not to perform DMA or
@@ -885,7 +880,7 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 		folio_walk_flags_t flags)
 {
 	unsigned long entry_size;
-	bool expose_page = true;
+	bool zeropage = false;
 	struct page *page;
 	pud_t *pudp, pud;
 	pmd_t *pmdp, pmd;
@@ -933,10 +928,6 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 			if (page)
 				goto found;
 		}
-		/*
-		 * TODO: FW_MIGRATION support for PUD migration entries
-		 * once there are relevant users.
-		 */
 		spin_unlock(ptl);
 		goto not_found;
 	}
@@ -970,16 +961,9 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 			} else if ((flags & FW_ZEROPAGE) &&
 				    is_huge_zero_pmd(pmd)) {
 				page = pfn_to_page(pmd_pfn(pmd));
-				expose_page = false;
+				zeropage = true;
 				goto found;
 			}
-		} else if ((flags & FW_MIGRATION) &&
-			   pmd_is_migration_entry(pmd)) {
-			const softleaf_t entry = softleaf_from_pmd(pmd);
-
-			page = softleaf_to_page(entry);
-			expose_page = false;
-			goto found;
 		}
 		spin_unlock(ptl);
 		goto not_found;
@@ -1004,15 +988,7 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 		if ((flags & FW_ZEROPAGE) &&
 		    is_zero_pfn(pte_pfn(pte))) {
 			page = pfn_to_page(pte_pfn(pte));
-			expose_page = false;
-			goto found;
-		}
-	} else if (!pte_none(pte)) {
-		const softleaf_t entry = softleaf_from_pte(pte);
-
-		if ((flags & FW_MIGRATION) && softleaf_is_migration(entry)) {
-			page = softleaf_to_page(entry);
-			expose_page = false;
+			zeropage = true;
 			goto found;
 		}
 	}
@@ -1021,7 +997,7 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 	vma_pgtable_walk_end(vma);
 	return NULL;
 found:
-	if (expose_page)
+	if (!zeropage)
 		/* Note: Offset from the mapped page, not the folio start. */
 		fw->page = page + ((addr & (entry_size - 1)) >> PAGE_SHIFT);
 	else

base-commit: df9c51269a5e2a6fbca2884a756a4011a5e78748
-- 
2.43.0


