Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59287C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 340056B00A1; Thu, 30 Jul 2026 05:46:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0A16B00A5; Thu, 30 Jul 2026 05:46:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16A6B6B00A6; Thu, 30 Jul 2026 05:46:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC4876B00A1
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:46:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 303D8A091E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:46:24 +0000 (UTC)
X-FDA: 85044962688.11.B52A2A0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6CD58140002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:46:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=a8rlygMd;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785404782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EDHJMwsw4RV+E0nCHPsR8cYc7dWvqN92OxTAgjiIye8=;
	b=PZNOE2cWh+onZ4la6mg7vOFeF6PoV7ktYqToZ5OHEXPDMwZvwgXxrGm2+E8n6JgZsTUZtO
	Yqynxt81ewhUpgBVGFfc0hGaAjimuaQ2K73cjDSTHYQ0geYp8/8ATTkI1Ozv+uwHGY3yXr
	H2FdMqsEoKFUrhHLmFoxXyC5J15Sdm0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785404782;
	b=tl+Mw7SAOHvighIwYdx5DskMAZJu0qlwpILtbFORP2mA5C0L0TSdVXOoyFaB71EKUEqWC9
	N+MXRXIhG7oTVCjjFiPjtrHnOaeZIL+/0y5cRdjlsq+ud2D/ddibFnXe0OX+RG/c4Tqeds
	HcDclX5m9XJDatV4avwqMUzIdjNIhOU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=a8rlygMd;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C3241688;
	Thu, 30 Jul 2026 02:46:17 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4C0113F763;
	Thu, 30 Jul 2026 02:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785404781; bh=uvhE/tFT7Ldq689DpjcwVfkSIZmSWyixS8rBTZRMflU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8rlygMdOo1mh6AIf2sT1e2i0T/CI+npPbtTQfKJyNeJatDW9LJB4vHRocMvy2+16
	 dKHdjeGuxDsBoJywpsA0aEnmZ1VdbVSAimGdHd25OpiYfJU+KcsgFAuLfQomAPYrAZ
	 D0/yq0ujGZVHTvArQ8YtZNtoWf5dr2x5SRKxrMB0=
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
Subject: [PATCH v4 1/5] mm/rmap: convert page -> folio for hwpoison checks
Date: Thu, 30 Jul 2026 09:45:52 +0000
Message-ID: <20260730094559.418003-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260730094559.418003-1-dev.jain@arm.com>
References: <20260730094559.418003-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6CD58140002
X-Stat-Signature: 3jckudzzhwub11bby5gg96azc8u187rp
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785404782-120390
X-HE-Meta: U2FsdGVkX18itpDmJeA7FFz/4Tyu0Zke/BVSqptTL6X7pjsM/VXuuTSc3Jp/6376mQCo+f3i5muIRs+S1meo8nGZS/mDPd5J+Ys/BbiVUS5PFa/FQQW2seGJrnA1Z/UsY6kxKC7I84zgZKzd6v8Ka144+wG5QASPYYx8bOH0xMb/uwLE0OQ0OI0TN5sdLiPK4G5/XzLr97/CgNe1HmoOl46V7WUf7NdRG26DeQVfEysHFqX6j+S0tA+JJLxBQXmfLG6c9pwdL1c81+0iRnDE4JxbfroQmZ6t2VH7QDPHwH9VZ9uOuoxQ3gJWz6JHX92/FBcTneZDzijQudQ4XMK+gakvou7VgwZpMg1yLVTA5HBvfXOa6yJHkr5lvWYPBL2RXx+BApuQy+neQOEPyOflcntiF8DtH88jDGeOgwzdn1JT54HAd3+Ev79r5S8a5H2SP/zzoL+OmpgDSm5rNuC9R+IokkAPruGgYkKLDUBj/R3DQkFtcaEE3AvnSj0XFEoBDt1Dux8Rrl5905PQ04MwsqLvdMk+lhZeHgcSG6uCJMu8kIyRfer8XknPV6BUkgOLr3q5JuHdPzA7dSrcRwCRbcQfo1PXFcHrHKVsUcOUwVSyMd8Ag+Q4W0GYD0VHwHPy0wZM+Sv361+I4Hv8LNNF/4GywuPeEBDLWOxQv9pGtzHyAGMvrHcS55ZGq5yT5fFJVkbiKHBokqFcPVsRuZ5a0j09vSM6IyzfcfxVTgTFWr4F/3NQLFQ08BM8jRcQdMoz1vIW7e+frnb1MNO1STHSppw6VSdBDtRcyu36ncXiQwq8Y87hPbez33em3Wzr6mZ27O8aYqKWNZRAe18c4aVyxVTo71ic0DufC8HN1BTIOrlNXLuNXqyJakiA/LSs1jR/uYRLoY2Cea89ryypBATtQSYKwcCPyw57Ws4u+BpAYIYtFG/PTxP2PBj6Ii9oINDpbTE9oyuJwBFhzw5sPgh
 7L3RvJAo
 F23E9tMePdG/jU6byPiT2XOMe1/b3cXGPYamptg7c8yMwhutzBb/9lYy6jQrD4jhCiJp0Dqy+ehv/DX9TsFg5GVfv/ag3vMrbMrfOiPFGoMTRs4mXIXL8B/ZB5WkvMeOoNjE0soXga2HEEYaOFwt+acIO6PfWjSBF/uwvg13wvb77K5xVYus6ojPrXBfvjbFG+6InmZ9L2VUWapwq4lCrjoPAxkAwIx45bOPtVXNlQJsmWcc4DFB6ATVxyhEB1h1yx0indpDvSKs1S0w=
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

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index e854679553b9..77be9fcffa99 100644
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
@@ -2204,7 +2205,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
+		/* unmap_poisoned_folio() only refs order-0 or hugetlb folios */
+		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (folio_test_hugetlb(folio)) {
 				hugetlb_count_sub(folio_nr_pages(folio), mm);
-- 
2.43.0


