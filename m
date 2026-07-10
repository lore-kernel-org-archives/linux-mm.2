Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD087C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 05:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C277D6B008A; Fri, 10 Jul 2026 01:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFEB66B008C; Fri, 10 Jul 2026 01:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AED156B0092; Fri, 10 Jul 2026 01:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 938DA6B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:59:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2CD6A8D89C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:59:33 +0000 (UTC)
X-FDA: 84971815026.09.9D9F8AD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 82460100004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:59:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=m8MH6uHr;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783663171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kb7eBLHmx+Q5vZScHPyMO7vgFAG3IxHz7r9Hn2bQytA=;
	b=rXfp3ZKxeEIFgZjY673EjLSmPrWebgBb3Euj8wPBl5OEGJcnd+j7Ix22PrgqguZszovJ7D
	8xx+ybFaN89sGKUZUMLPPD28w2e5VNCvOIqeMWOYlp+fjeCEIRjs8yPlybQvnYA5R7C03o
	GiWJl1GQ0isNGOXGao4EB1LSgt6vUzU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=m8MH6uHr;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783663171;
	b=fYzVSgxJV9XvZzO9SSnImssmweo+3DLhVga6qmqI9d8IQioxokUzi9VqAS4wf91RIo3z3F
	eB0xMnYg+RQqBWp8psbKn6uWHPOHk/tO/kBMwP87HZv2pEcCi1OPsiebYUSWTp3M8kTZ4q
	eG+LFNv8snyC6Jqd7ZqfxlNXpOfXfKE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2D7721E7D;
	Thu,  9 Jul 2026 22:59:26 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2BE9B3F85F;
	Thu,  9 Jul 2026 22:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783663170; bh=74HpFWRFRTO3Ef08AiFl7DxF5dkmm6WMDaEm4lC7tlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8MH6uHr6tfyXXYzpTwtFTbAt9HftVJg17b7MOHYYx5/i1m3s5xfWGbo6deU1DvSF
	 0rceOxATmMECerhpnDm+D3ndcUnsYHzacEUENhw9iqNQK1Ky3d7EVpDf5ij2y/63yz
	 p3KD/1kdLi03SpQ1Ho1ShGAr48Kwhu0DZ74pLvwg=
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
Subject: [PATCH v2 1/5] mm/rmap: convert page -> folio for hwpoison checks
Date: Fri, 10 Jul 2026 05:59:10 +0000
Message-ID: <20260710055915.638659-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710055915.638659-1-dev.jain@arm.com>
References: <20260710055915.638659-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 82460100004
X-Stat-Signature: r615ht8bgm7gttdd9yypd8ndiqr3p9zq
X-HE-Tag: 1783663171-980283
X-HE-Meta: U2FsdGVkX18SFQtHKlHEyUlG8KgmWmVwP0ooInhcdmdGmLJk/dQdHCy+GuH6+bUmJyHUhHu1O6X9yjeLCfELDib87kQHa0WnI4GSR22usk2wJKOwU2wFIOGXE+KSwMQ0uAa0pZtD/KRnJEfVsl9lAaAH8deV9/KqsK/mmaI+i0O5ZTGI0YTPzf7KgNHH9xLtcwKIMYo6WJZWBz28ciPD9NDov+v+mA+uJXTsz0bbBKHWzAExmOgTFQWYbQe1jDCQVyqBsWqNA5R6Z3/osUhkXTBCj6HxNtvqQU6WYOFYZl7do5FMga2NcjoG2RkpJ6+O2svp+xRidwVXAQ42i6ty9A27d2aPICHxzftOqzwqnc0hLnSmoQ6CywUzZQLzTMoxp7Fh4gHxh0RA2P1kXYIc2NwJUFJGOWTMTx9fhWTkfdoYwugji+I6K5QfKp7u2UcGNQ1jLv0z76igS4SD07MdS1T0PxZSRvH7AOj+Goxlmx3vS0h4C3uuxsxKVVzeLA2coY9VvS8UEYemu7KV0QWB16Pp4RAVz+LBfzbmtKHrLtSu+J6zYYZgiJEBoksxr4UiCc6gyi6CtpUpE85TqDFOPRfC9edreUCCVwrWnm3WWoiadtjrMcH52KnSD10gW7EcJY2y9adE0y5L+6jbS5Om/BuROYn9U19AWGapTY3srnZudDVqorw/9xKeoiiaV8pGOcahpIhpEY0Uv9CSsKrT2FO1fCebILuPL7vON/qiFgXeupoOAQM6lbGEYW1VjtAZuB1lWQ6Gc1h9LLORnrRbZoWRgmhyD0xzQIaJgOmfGlvWa1L2sMxBn0pZcG6dAscH6VOEzEC+TeRX+JxoLyWKBBi9jYUPKeL+afheg0cbh7lo2jtkAtqzAbmG8hyVyphj1Rms1F4pTi4EZWUfdypPGs4J7bEhhvWKUGGuyQ0dKms3IaZSJCUkWcXb0l/kQ+sy91la/RChuP0mHBeBvTz
 UnfwHKWH
 yzUSsFZ0ljYiLSX7yY7W5Um+MX4tlKI+0wUQkFgqccwCnhZe17ho74LeYR+q1jdY1ElPrJjqZCFYEV8RWoE8GvhDhqfth/mGlroJ13j7pTT52fEB8DbQ1LoqqaZBitmlYkQ9xWf4xmv94GYOKXOl4Jz1S4jZJ+HampBSHHwZWC5ws4zWQFhos/svjF7HMqXu90MVBC5V8pexPaNxnA65UXRoHyuV/hah51wYgbATnAlELDW3AasZ/xynjk4gaI+DGg6+CAXMF8QuerEc=
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

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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


