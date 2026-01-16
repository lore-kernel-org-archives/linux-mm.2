Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D016DD4A609
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 08:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E40056B0089; Fri, 16 Jan 2026 03:27:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16EF6B008A; Fri, 16 Jan 2026 03:27:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D40106B008C; Fri, 16 Jan 2026 03:27:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C2E5B6B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:27:55 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 76CAD1BE9A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:27:55 +0000 (UTC)
X-FDA: 84337148910.24.1A6BAE6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id D522C1C0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:27:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768552074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=VnVC6SooFSK+UJcv41dC/krVfOPjsEdFt78/S0TwpPc=;
	b=vNu0BekpCVl/ynl3Qi3lKn/11HO7W12D8btcFr1sS9ncORVY05L0Jr1EXg/SZV4T09qnsi
	U6Fk3Op3zUiUfaOI4H8mXejEVfEZPHmpE+/Ppt56bN16mTjnrqvEg510PKkdOvp3YBMIQP
	iFYUkfc2/tNYc50lgPy+xtGk6SoYKkI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768552074; a=rsa-sha256;
	cv=none;
	b=h1d6i2fLxKNS9+CwtXkQd7wL5QFAFfU/Scn/IEiOVq4gc+9wcA5XAd2KE4jQDua98KeFhu
	4M69QuRXXI+EbmYd1aNFNb0y6NJqZoUB/LxZc0Ic7KyJ3L/OZqn3mde7SIiFCfdDncFAmT
	T7vboSRFtdPuMTbrLAInVonZwbzzjjw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 07186FEC;
	Fri, 16 Jan 2026 00:27:41 -0800 (PST)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 37D7D3F694;
	Fri, 16 Jan 2026 00:27:41 -0800 (PST)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org
Cc: axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH mm-unstable] mm: Fix uffd-wp bit loss when batching file folio unmapping
Date: Fri, 16 Jan 2026 13:57:21 +0530
Message-Id: <20260116082721.275178-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D522C1C0005
X-Rspam-User: 
X-Stat-Signature: 3h1453mcqh1j1p551y8ehe5fkx9jthr6
X-HE-Tag: 1768552073-522768
X-HE-Meta: U2FsdGVkX18WPSliXdRgZR1vaVLCunHRGR0U9W/+aqgWQu49cpJ/hghklg4YCGB5lOoPUOX1qD/M28MFc2Y5/idbD82/NO4ft5fk78JcCSS+D8oFFIPj+kQZixBQDkiZxS76SGfTBHSW+Enjhhg9tuuO9+aYOt4kg1xHKmFBe2WRNmzvlhb7M4GsRgRSN3MeIvsQmpzhavwibA7txWBtRQCgXhFrjBwKSM3iwRrark7qpzA/VTzTg+NVvkxFXnEdWr2ajGtIZ0y+TisAg29Bi1IzcYOl03VmkR3kEoIO1DMq1TISGYmajmjsWYu9z9MoTqlcAvw3n4Yz9kfFrHOBbVX2etNl8V2LqBmwOwrTqfU7WLgtDCKsBqpss3gwMOt/+qXF4F6ccTvFcMG1nwMxVxTANVYSGdUmtLcy4QI7MIz+v8xZ73Xemx6OkQa0dbMzYvt87EJ8BPsZdVbpf7973RrHJAy4b8AGMaGghociWRb6TceYzuHZM/79/9FNk3VwUnGz5/dgzAiZrQdqaIufHAqWJF2wbZUcVXzJUyolCBXvQAoE19dps35uyLGF5EVY5YwAs8zfULzT4RWY9jp3G78EwjTzRf1+ZfR0g18Ng9pipHzzz4dZNjuOoMPWv+8a9wVvRUO2vWVsO6QNIeFfDcETavbMlXx89tUqVaNutasOnXib60QnQCGLZCrhlZAnABESN4+/3Dam7i6MndS4TndDaWHZV/MmVRvZK5jCGcEOYThFLD84qy++8ytt0FRdF8XUKlnw1W3EZauvvRunhh4KpiFGX1AhXQmQZ3gtmBNd0dylaNInId5ZAuRhSSPumeFzxumEkTy4kl2fcmIBpqtE1xxBQurTMKr+hCSl+afsfJENvCxxAId+tvfKtEW2U61+ypYtO3xJ3wvyC6C8LZOFaFaeWui9Gts5sZvmb1NYb6BA23ju1FB0b80mFFk0jogH2koBjSzr6ZmE87o
 t5sSWpg4
 Izd5/R7N5SQugm12/vofR/ijJ5bxqJbW1+HTK1/guyKcgBClXrwNKztexTRgPKvCohf2NPcJh6dkfqxAx4eH5Vl25MTUu634khwqGjzzZ4PvBP6K5dltL2LcK/5wG6s2rirpFzkcedPpj5AAttjpY++YjjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The recently added file folio unmap batching support forgets to update
pte_install_uffd_wp_if_needed(), which still updates a single pte.
We end up jumping to the end of the folio in page_vma_mapped_walk(), thus
setting the uffd-wp marker only on a single pte in the batch. Fix this by
passing nr_pages into the function, and set the uffd-wp marker on all ptes.

Note that, since the nr_pages passed to this function is always derived by
some sort of batching, it is guaranteed that the set of old ptevals of the
batch have uffd-wp bit on all ptes or no ptes, therefore it is safe to derive
the value of the local variable "arm_uffd_pte" from only the particular
pteval passed to this function, but apply the result on all ptes of the batch.

Use set_pte_at() in a loop to set the markers - we cannot use set_ptes()
as that will increment the PFN, but we don't have any PFN to update here.

The userspace visible effect of the bug is inaccuracy observed by workloads
relying on uffd-wp regions to install their own pages.

Fixes: 8798e255b5ec ("mm: rmap: support batched unmapping for file large folios")
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
Patch applies on mm-unstable, commit f8ed52ac0cfb.

I observed this bug during code inspection, but it turns out that the uffd-wp-mremap
selftest will skip some tests with a bogus complain that "MADV_PAGEOUT didn't work,
is swap enabled?" even when swap is enabled. It first sets the region uffd-wp,
then swaps it out, then checks through pagemap whether it got swapped out. For
file folios, this check makes no sense since the ptes are simply cleared, but in
this particular case, because of uffd-wp preservation, we need to store PTE_MARKER_UFFD_WP,
which is stored as a swap entry, that is why the test works out on a non-buggy kernel.

 include/linux/mm_inline.h |  7 ++++---
 mm/memory.c               | 14 +-------------
 mm/rmap.c                 |  2 +-
 3 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index fa2d6ba811b5..adec1dcb8793 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -568,7 +568,7 @@ static inline pte_marker copy_pte_marker(
  */
 static inline bool
 pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
-			      pte_t *pte, pte_t pteval)
+			      pte_t *pte, pte_t pteval, unsigned int nr_pages)
 {
 	bool arm_uffd_pte = false;
 
@@ -599,8 +599,9 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
 		arm_uffd_pte = true;
 
 	if (unlikely(arm_uffd_pte)) {
-		set_pte_at(vma->vm_mm, addr, pte,
-			   make_pte_marker(PTE_MARKER_UFFD_WP));
+		for (int i = 0; i < nr_pages; ++i, ++pte, addr += PAGE_SIZE)
+			set_pte_at(vma->vm_mm, addr, pte,
+				make_pte_marker(PTE_MARKER_UFFD_WP));
 		return true;
 	}
 
diff --git a/mm/memory.c b/mm/memory.c
index 6b22dd72ebc8..35ac86d29e77 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1588,8 +1588,6 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
 			      unsigned long addr, pte_t *pte, int nr,
 			      struct zap_details *details, pte_t pteval)
 {
-	bool was_installed = false;
-
 	if (!uffd_supports_wp_marker())
 		return false;
 
@@ -1600,17 +1598,7 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
 	if (zap_drop_markers(details))
 		return false;
 
-	for (;;) {
-		/* the PFN in the PTE is irrelevant. */
-		if (pte_install_uffd_wp_if_needed(vma, addr, pte, pteval))
-			was_installed = true;
-		if (--nr == 0)
-			break;
-		pte++;
-		addr += PAGE_SIZE;
-	}
-
-	return was_installed;
+	return pte_install_uffd_wp_if_needed(vma, addr, pte, pteval, nr);
 }
 
 static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
diff --git a/mm/rmap.c b/mm/rmap.c
index f13480cb9f2e..d6ca002bf79c 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2171,7 +2171,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 * we may want to replace a none pte with a marker pte if
 		 * it's file-backed, so we don't lose the tracking info.
 		 */
-		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval);
+		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval, nr_pages);
 
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
-- 
2.34.1


