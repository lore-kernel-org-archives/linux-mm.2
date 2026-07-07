Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C648C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 12:11:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DC526B00A0; Tue,  7 Jul 2026 08:11:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78DB06B00A1; Tue,  7 Jul 2026 08:11:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C73D6B00A2; Tue,  7 Jul 2026 08:11:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4248A6B00A0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:11:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD863C2885
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:11:51 +0000 (UTC)
X-FDA: 84961866822.26.757AFFD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id E53164000B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:11:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RDDfbMhK;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783426310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o9t9Q6Kvk9LeaKFla87co3gQLnfC4fapY8lVNivs0V4=;
	b=spvUJlx9dt4hJZB7X4b7FyamkQ/G9tJdZr2ZGaLccapvzXkH79JukdIhhorTbGzrqk2Ihf
	2I+cLrBO0jiQyNnJ45xmebBkBPl4HhgqIgkj2txQO2qIuapLSwODLMMuA0pWLNVABE/2li
	UltCYH0rGZ/z6fi5v680BUu/HFaPqTA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RDDfbMhK;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783426310;
	b=qHiAZxmSPyBdlXFTeajjLi5OcRGPEguNejFghGq410QzxuPN6btVZw/mpMR3gjegt4MjdJ
	V2IEZUSv8+q4Zrnl4mOg5FPUHxNN4i0aHfV5Hq5hsWF7goG/aKd5PaUzXoLxELKEQVbhQx
	PyPxEiIcGy3j0PFtHIywHnn6KYTSkrs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D1FDB1A2D;
	Tue,  7 Jul 2026 05:11:44 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EB5053F7B4;
	Tue,  7 Jul 2026 05:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783426309; bh=sG8kuXUpuA3bXsCULrMf6aBnRcFdA5YshgzZNs3gKMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RDDfbMhKhCUcNWpBtfuzJuvj/2D0+DwL0pAugw5qs9KqoeI5Z2YF95UOostcjvRsD
	 sLgqwtT9pcyCQptuyXi4R2oTkDLwMkjT2NqkJFAhmlbtHpQhHCMUx5j39fFdGfNx1z
	 ypyQhW72HI/InrjqEE8zpYQGMDlsh09A5M7H2yn4=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH 1/5] mm/rmap: convert page -> folio for hwpoison checks
Date: Tue,  7 Jul 2026 12:11:19 +0000
Message-ID: <20260707121128.373192-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260707121128.373192-1-dev.jain@arm.com>
References: <20260707121128.373192-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: htt5h6y4diiffarj7fg14xy3u44h4xfw
X-Rspamd-Queue-Id: E53164000B
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783426309-859035
X-HE-Meta: U2FsdGVkX1/phtRvLagtL7Nc1B4i3uUFOGrUFCNWcx+wYpZuqRSQrr2WBRIskgrDNYS8atmdsPJCUlgrgGx3z5bRzphemJwFRDuaQmKNTQfNG7CYhsgKVNgPgTQCYQzE49jLfiVuVjufFZsV9LpAC+xQCDEXzCTzDdFjiY5lnlBIcTaQqxxoiyCxBI9W3Kz/jf/WfaTwxkB8UT34+V0aefU3S+YACYkaU2GFLHTtO9QyZ4WW6KW6GyfKwNBbud+oLlvIq90gpvDrbyHsW5DCf0ntUA+pVxpWm+MuP/J5b/vzRfVuIJhT2xJgdnems1OuIm6/I3V71zLM1D3seiNZuzs/Welr0ZsXw3zaddjeNhs4oQx3jJ3VVGHioicFlZ9g0Y/seOMxWIcnV1gDCSzrfHoJTqNTyC4aAp8c2BOvms5FnPB0hSmPVWvDnj1AT19j0D2IxpCp6t7VVhISc/k4Y2nFbnaDNhPj14Mc3dZWCSXISlNTn0x83BYlZ/DBnsIH53dqsJnG94z1zwJ4z7aRT04nBV+KpUZTu5ItgQeEH2L92wn/palLRPIkXYyCD2vxb/HMriAA2DbqCw3g+eG508nYps5UCxnQURRNKBnOgKbd5qM6oxEFZGk95kJCPdI2VspMdgkluiqYMp3S5YhFZD8XpDSgUpzS2kEyg8I30pYV36BHB6X3AXFtVZNJTtvYeKiKYu8xpg25P49SLOOd/UAXLuNe3QYk7UZYo4nKsBRM5BjcQtdlZRDJj0eNVC8I7+1vLTW/ghliKCQciw8/QDee5yAmrpho4deM1GqQhtWdp9tScoRvGkvGCh/Agil4JKC+RHF9z7FYz8Mx5ORo9kYtyAFI3QCNneVZWDcgfl9Ftwz9j8wHZzFC+1no7Y9P4gR3hukvQHllZK/Ee3gr4eqW8mvNRvxhYzY76X/6lNgka4f1/HQqWL+GzBOQkCV2ALlFQghb+ZaiS+qicAk
 /trk9OUK
 TtVzeRJRyniZEzZLZSrkigtxEb9VrNGKvpVNaZMoakPakugC1W9OdbrLcFugMfjRByEauFjV51JemuQxFaznpdmJ5Lqb6F25e+qpB0MAg52H9TJglVgIWWDzov4twGFpp+ElXO90SmtuZMu5UG1UyN7+vBG8ZgOBdjx63/QcWuH64P4chvaHu3KLaOXShaqA8XBjYdFJq5WdZ/IKBJRyit7UIBs+8AfrOSx/5reo8eKfPzcyDijwGKoifjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

try_to_unmap() receives hugetlb folios only from the hwpoison path.
hugetlb_update_hwpoison() sets the hugetlb folio's head-page
hwpoison bit, and page_vma_mapped_walk() reports the hugetlb mapping at
the head PFN, so the previous PageHWPoison(subpage) check happened to
work for hugetlb.

For non-hugetlb folios, unmap_poisoned_folio() currently rejects large
folios before calling try_to_unmap(). Hence it is always the case that
if try_to_unmap_one() handles an hwpoisoned folio, then the head page is
marked with the poison bit.

Therefore, convert the poisoned subpage checks to folio_test_hwpoison().

No functional change intended, except that, while at it,
convert VM_BUG_* to VM_WARN_*.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 9939400e77c79..dbb077f8443e3 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2122,10 +2122,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			bool anon = folio_test_anon(folio);
 
 			/*
-			 * The try_to_unmap() is only passed a hugetlb page
-			 * in the case where the hugetlb page is poisoned.
+			 * The try_to_unmap() is only passed a hugetlb folio
+			 * in the case where the hugetlb folio contains a
+			 * poisoned page.
 			 */
-			VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
+			VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
 			/*
 			 * huge_pmd_unshare may unmap an entire PMD page.
 			 * There is no way of knowing exactly which PMDs may
@@ -2204,7 +2205,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
+		/*
+		 * With TTU_HWPOISON, we only expect small folios or hugetlb
+		 * folios here for now.
+		 */
+		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (folio_test_hugetlb(folio)) {
 				hugetlb_count_sub(folio_nr_pages(folio), mm);
-- 
2.43.0


