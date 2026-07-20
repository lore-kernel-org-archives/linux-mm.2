Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14673C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 06:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DE396B0093; Mon, 20 Jul 2026 02:55:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18FB26B0095; Mon, 20 Jul 2026 02:55:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CD166B0096; Mon, 20 Jul 2026 02:55:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7E796B0093
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:55:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 64C7140729
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 06:55:44 +0000 (UTC)
X-FDA: 85008244608.13.349B74A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9AC171C000A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 06:55:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=H0xKn+bn;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784530542;
	b=d45o+exTJkE04oUdBUVWA80KuYWFqexiwOmWN7voEM9ui2y3vtVLJrLstQ9O3P4j4e8rmm
	RHaUHG3Iiwx3+X7Xo1fBOyzlDxmaGH2AKT11RxP5Kj9b6LjhD+taOEKbvHXHDdWAx47uC/
	CQ4KUgJWTZvSg1zvA67/BOItYIosceQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=H0xKn+bn;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784530542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfjMHd5M81X7Qb2w2Vs0uzlhmtIz9CGSASy3b6Eft7o=;
	b=VF4+QzvfTfyR7aM6Pi3n2V3UnYPZgE2Ma0WY90SAyov4x5nQsnV8VTFPZFtQQIsIozDioo
	vsXg4li7O3AsUfX5xayJKomJzYY/drApBqT5smUz2nTjWO/4vcgLw4LizGcAHfESo2kVXH
	20/0LJdxxltk6MTmz7S+QqSRYCPJsDs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A21E1682;
	Sun, 19 Jul 2026 23:55:37 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id ADE583F66F;
	Sun, 19 Jul 2026 23:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784530541; bh=0uZCBLA/6tv50+Xe48dX0mngoeuzlIGQwQYeLrBh4lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0xKn+bngtg4BLC2D/vhC7e1XPwe1FrLhGweIhhaXrq2APRtiYOJ14I9r9//8gzcK
	 VUZh22RAI1Mvb8nWOKXE3O+LDiw4sx1GDF+N2MKUILSHon9gU06tmW5csVccIFD84P
	 2GFw2+TaofMRBayEIOFWiv0g5QJXEjDCFkhZEMnQ=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: Dev Jain <dev.jain@arm.com>,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v2 3/3] mm/rmap: batch unmap file folios belonging to uffd-wp VMAs
Date: Mon, 20 Jul 2026 06:55:07 +0000
Message-ID: <20260720065508.2695106-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260720065508.2695106-1-dev.jain@arm.com>
References: <20260720065508.2695106-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9AC171C000A
X-Stat-Signature: 3hqhaojxj94un1h8ibr8okrirpnwpxmy
X-HE-Tag: 1784530542-309337
X-HE-Meta: U2FsdGVkX1801y0xX35h3kN+TRuAPC/H2xBZtoWMvfSuKbSbKz9CxHYH5O96EGVxLSEmBRgMFVTsV//79kwqQ+5S6OpDrqFxca0nyyJ+w1er35/99nAyAZhqieFrCVa7Jd4rO+yKRppWe+fVgpEWBbjzkQ7aPGzAZb83zAUQSx5Bt12NLChHDXAo60BygUxgOEZkhiyLdD19nOLD5YJZ9BYP9AYEuURhNz285WKa8/c8z9CxQJvMAMqo/N2jRw+yN4DKeV0Q+ycQ5GrGnq00Fdh/JcF/BVjXQX44uDgDhNh9SSpIf1hONB1AlpOXJ5YqHorlTa0TPwGoPRWMcKEi8M7NQkctHkq0/Ufh/vr6s7xejJChesBwwQrTFkTl7Y+NpP0sGNAeCS7QO2WKmDEQ8/eoTjfE2xxy3CyRVLWyhONSEzzP8jutZtLBTejWd0I0yWmfPDT2Ip+RSBv/vwCgS5F6qRL6lmCv72DA040GljO6bGT4C1uFq5E5u+JLSaBEKP06DgaRSxd1BdmMbxiNrBw7CbmRD0s4FAhkyaqlkC+8xnaen7Pzg7epT74dsmo2CgrWqgfrvpyJF2jUvA9OOwo56Np2QX5eDvP+22o7MD9Y10wn3esSd8XbjuLtP9h3LZDsKUjXj+/QuZipdXcvl6iBgm82HIUT56HaQZ6v8eMdXu9hcD9l4OL/Ierm3kDAGY8EZuN2X3eEVTSJSuf/BjnNaWNbaqYSacf+/NSti+/p9oFXeeEZKodbllNFi9nuft7/j3JwtsktMdlHlkrIBVqpPmUatxcBGAjH/kQCQG5CkJttXbWHQQFnAm6x+V1K3js/51jkBaBjielAXbyjUxchI6fX4B1mKTAiEZSsfcslCKxbHdfClbDlryFuvblzoIxh4RjCR7Y8bVfwegEiTSw8xWLNV5vmihH6XmYA3OmMw1ltfY0oXu7HcIHQnMt3IWCqQmxYx6C15/0SVe+
 TguSY0BF
 P9oqx5tewO//xM9/2Mp0avzzjEL9vZcOP0mnae0H18Q4AYwW1Qy0JjeV00Y0NxPvrAE9GGCANYO6PCxRPowd0OGM34gK8+6Lo6/oPoz1dbd+mRN8kf2jLeq2i8kVbA5Z8aC+eSGI4ae8HrZlLeKeulmh32dqyqT6V75hhfAFo81BXAWp1VPh3BDJ4o+xRGaITrTLp9qJO4V4W4TFzZwcgT12jIOVSKLGMOUu3oV9gqe3U48ChsP9CtIWD7tM8typIrqC6eLc5xlOcUCGnV99CwdEd7iMBcaWiGvf854fCGNVp49znBkUMOxLQjolhH+no+FVn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit a67fe41e214f ("mm: rmap: support batched unmapping for file
large folios") extended batched unmapping for file folios. That also
required making pte_install_uffd_wp_if_needed() support batching, but
that was left out for the time being. Correctness was maintained by
stopping batching if the VMA the folio belongs to is marked uffd-wp.

Now that cond_install_uffd_wp_ptes() supports batching, call it with the
full batch length and allow folio_unmap_pte_batch() to batch file folios
belonging to uffd-wp VMAs.

For file folios, if the uffd-wp bit is set, unmapping converts present
PTEs into uffd-wp markers. We must ensure that the same PTE range is not
reprocessed by the try_to_unmap_one() loop.

The page_vma_mapped_walk API ensures this: check_pte() only returns true
if any PFN in [pvmw->pfn, pvmw->pfn + nr_pages) is mapped by the PTE.
There is no PFN underlying a uffd-wp marker PTE, so check_pte() returns
false and the walk skips ahead until it reaches a present entry again.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index abeb8e7ceba17..56eaddfc610b1 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1968,9 +1968,6 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 	if (pte_unused(pte))
 		return 1;
 
-	if (userfaultfd_protected(vma))
-		return 1;
-
 	/*
 	 * If unmap fails, we need to restore the ptes. To avoid accidentally
 	 * upgrading write permissions for ptes that were not originally
@@ -2348,7 +2345,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 * we may want to replace a none pte with a marker pte if
 		 * it's file-backed, so we don't lose the tracking info.
 		 */
-		cond_install_uffd_wp_ptes(vma, address, pvmw.pte, pteval, 1);
+		cond_install_uffd_wp_ptes(vma, address, pvmw.pte, pteval,
+					  nr_pages);
 
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
-- 
2.43.0


