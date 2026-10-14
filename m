Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EE54CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11CC46B009E; Wed, 14 Oct 2026 13:12:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CDAC6B009F; Wed, 14 Oct 2026 13:12:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFEF86B00A0; Wed, 14 Oct 2026 13:12:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCFD66B009E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:12:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 53E011C4001
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:12:09 +0000 (UTC)
X-FDA: 85321874778.30.B6EC534
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5EE9C40002
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:12:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q9DHl5j8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791997927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2jWu2bDBNbsJoqDuBXroh8IkfqrOqZyO6rRTdaUBLdw=;
	b=GFBkFU0+cMObUzhVhSlnOUpWJyianhMtZ3BRjxPA1rc693h8HXt5pDXO8w8xe1lDHtydgs
	LlG874fuMSYVuZ6qZ6/RRD0q7NhvJ8VsHJVmfTg17Cl0HF/j9A8iMQSNJ5WFcdP6alpCdv
	TtX+Bmhepu6YhuQdcE+zQGt4ibYGQ5M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q9DHl5j8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791997927;
	b=RBb0wcdWCSuyYUB6auTeNIJRH8wctpjg3l/ksxMfLEPT3/VyIlPSJo6k2b1099/w5/y/j+
	00ZMW1XHYahIwvhLtk1fhzANJAOXgbBsp6DOXsjr5d61329LOtDIHWkHyZabWPWqmffyHM
	DIgKW/EPfwXA6a0ZZX+MU+I4d9lKIqw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 76E1A60A64;
	Wed, 14 Oct 2026 17:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E521F000C4;
	Wed, 14 Oct 2026 17:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791997925;
	bh=2jWu2bDBNbsJoqDuBXroh8IkfqrOqZyO6rRTdaUBLdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9DHl5j8BvSoV4c9RY2f9gLsNwHp2sh3YbF6coUM5uZ537VFJ9gZFk9dy8mLp/Ggg
	 0/pQM97/mC3uQsJp9Uj+Fg31KY0mEKATqodypSQVqKMhfTpTOxuVPUKnoMydqpL9U2
	 92iTTpU9qDqoyKVHGX/0iC7zT3qYmvV5rR6dYu5oK5/MXG5e+1ofK5gN0c7ZowBh5O
	 z3RyYhNmU2rdy2SWm75GwtZR/KRaNy/xBGi8h2BJt8AvSfnaD1O1QIprloYYPo7jwN
	 2Tl+xuQNiDCoi0quQsAoT57onJ6VEHNBf/DhNrMzJxT/XaXdsd02ELi1qz+j0x8Xks
	 kvY2Z8EonHj+Q==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 3F6451980047;
	Wed, 14 Oct 2026 13:12:01 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 14 Oct 2026 13:12:02 -0400
X-ME-Sender: <xms:37fPauHsrXyCfiLXXVDMNICY4nODXpFLy2U3KjfV5VwdDD8ADf91dg>
    <xme:37fParTAkB9ilm3Vunj9HyXLeqO181bpuOak7WFfjpmo_HGxOUe3fS1fGKEPbVFlw
    1fxEkoRI-XZuYsZLrnUAhNMHEL52pmEqQh_cFx4XqlCuRdXZnjO4Xg>
X-ME-Received: <xmr:37fPauRglf4CNleC4zfwsdC9fIvI7AHOq5UoBext82Jrp3BxXC2NyNKbrkg>
X-ME-Proxy-Cause: dmFkZTEOl4NfFwPDLSBmMqKx+7N39IeMIni7MK/u+VvxaGQ1bs8GfI9RPH3ayDujSspKBR
    qyKM+cOOmgGIjV1p99esKFBZjBYm+2fZxsu+dp6kV/40GtAwNmLs0lveP2Nu4w+lTJFNGX
    +PHSDDgHqCL4KFJyfY61faoRzA0h8vW6kqyfQ8QWLAhZGC4dGYbGOPKI1Rz1FZYlfQX1qS
    ZyU+Kn8XAf7cjImjIHoCIXuQM1OjXWl7zezG3uHTMAWWFgZp5y0YQrE07Fctth46IOKxOe
    Y9yLqjV8DtTpJEgGM7OnnqWtPPljjv3Jg1+LTtq+j0gFbbCdpQA4+mOsItlGLpSNkwSLhJ
    v8F/Py/LpcbqpZCdQR7pJ0113yy+no2Q6VhctIySTMzofsXWhYbTIrbcsbIg0MD+1VR3CA
    QiBRYjFWMQFOeLQmkjnjx/76Lak0U3LKh0PJcL8dKvHteSIITDl9gabom9HeXwbr2Jr7GZ
    LWx2VvBPh17x1z7cJv8p6KH2+878kWtzLgYiNeACywHWjJDDLg5Ye/gCITBkM2E29BZ0p4
    7Yii5uNfTp10+GBk76FVC+Sb0asOJJwfHH/rPaWbTVBT2+Aoc/4BXAdCJ66iNexBcDhvYF
    TDFqnXrjT4DhRBGng+IzmyjBDGtRjKtRwRn8pbdFdM57E9rU++lJXrbnl/9A
X-ME-Proxy: <xmx:37fPaufxfMeABLU3MONsanFzUU7GHARjRor1C8TsjoQH8P-G2Z2kgw>
    <xmx:37fPaic8PJE84ZhdMGTK1x-QmIj5gGvZNouw1MATXIwHZMXN3km1_Q>
    <xmx:37fPak9CzdfrL6F0661BijnRiJmSEl1VVHvmnUhPpsCZk-v2pOaejA>
    <xmx:37fPaiNVaznRL47Cwjod288nFyt8UZNeXwmpkz8qdl-t3TD1LGcO4Q>
    <xmx:37fPaiVJjxniS0tibohpu1NvsL53znIspCLgtu9xoELk2KWHMNfKj29a>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Oct 2026 13:11:59 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v5 3/9] mm/khugepaged: rename mthp_present_ptes bitmap to eligible_ptes
Date: Wed, 14 Oct 2026 18:11:36 +0100
Message-ID: <20261014171145.3292736-4-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261014171145.3292736-1-kas@kernel.org>
References: <20261014171145.3292736-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h4hu3zjzw8u6rut3oibd777c81fjk8wj
X-Rspam-User: 
X-Rspamd-Queue-Id: 5EE9C40002
X-Rspamd-Server: rspam08
X-HE-Tag: 1791997927-444421
X-HE-Meta: U2FsdGVkX19NFfOV1iacV6jNmAV6Tr4Q1rVKKG7d7Yhs0wQcanlod6OpofmirrMqbY51DqR2VAWcDr1HymukjDZpYp3cwbTn9OxEmgMbd9uvctGopnH+Nvf1ufhrLyJqBRlb1Mxfj0I2o1e+6GgiXe9VC5NG5sJw/jESKcVIAxQPVEquSH76+WDIcxi4ulySIAwYMb43ZgcoXfz91xlKzLsNBIwDPUsv2OvJCo+51Io45EOj0TPA7FLAg5kaly7S2N58Gj7V538LLnCl71bT+prTGKkZv5pj2/S39rdi/YE50uNq2CzCVL/vva/AWLudpzykwelgp6toRKri/gBKiWRlqk5HN3KsLpGDqtsEqbFaTH0YvnAx0Q1mywxvEIw6ZxqnH0Qj8PdGX7ExBQES/zMRg47SAJWK8JiaFAJpNoaJkZN0Djz8UjbPlevdCM85de6LphiG+joMZ8zfu2l1f5U+2S760O6AriNrKEljHsGc4yB6klmBfGjmjWKgpkdyPiO+KJUXPllbrmnqyzbSOHE481hO98IQjNP4ime0QH+QzANs23jMzbW1ADcYBX/uft6wVlSqw+LO4PMoLTi0EEyg3XbCyP4PtkiG/iXYs0kAQhTrJoJq2L5Da+jCbNUmsTT6Fs/zc7JhZKO76Wo+oPmrApmqrPzn3NL+GC7FI/sjHAXOHAdt2PXicv1mSLFyAm6URQLe8Haj+WXP31yNlo/rYNr9jKSDC5ZEx8nOZnrDc6md10L3nkCE06QfATIz+0ywSTA3Lre0So1QfnkuBV5F3UW+PCSJNrA2YtsMqoExORLu5LQFmEFxiDSCu9aJQ+sMf1bbCvGdUfrHwG8mQezBdOIkv+2alShV5tqf4CHTTbxh8O2BgJWFl2RScWToH/+rNouivqGowpLPNpb//+DotNwfJZLpQHzy6es6wUuXrMZ/2nRnv2mru9e2u5TsZwHDhE9z6G+91/CacOz
 3i4dJ3fL
 nJJqcS2ZDUapf4TZ6iF6ZHYkh2R19UV0eteux7gQClCd2p3uYM6YmGlF1tpGMqsP34ri+kSPD1kxvOL6klG00bA+dcn2KF9yPlEZD2wWrMvcBoJUQAIw5hrc5sSazOFQb5ZVbZLb3fHpd+gcAq/66qZ+ZzDjfWCoVSMhPJrRK/4VrSyQwj/VOnjmzbLeD509HTiuGmbcWdSr1vzdMtXrascm84nnbNCwKTe4cuYL1JHI6OGbYVnwERA+2cIJm7/6C0FhjIuoFqDolVV3Y0UJmWoAFf0rnKo3LfLXwJIf/3CGJp4c7t+qo9v8BTbBRaUmi8UG0Kq+IyDZ3KLR+0O6j6xIwYB/gWEcC+NrI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The name says less than the bit means.  A set bit means not only that the
PTE is present, but also that it passed the other checks: uffd,
lazyfree, anonymity, sharing.  The PTE can be considered a collapse
source.

mthp_collapse() then reads the bitmap starting at the PMD order, so the
bitmap is not specific to mTHP either.

Name it for what a set bit means, and update the comments that named it.

No functional change.

Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4979a93e3648..081f705cfca2 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -115,8 +115,8 @@ struct collapse_control {
 	/* nodemask for allocation fallback */
 	nodemask_t alloc_nmask;
 
-	/* Each bit represents a single occupied (!none/zero) page. */
-	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
+	/* Each bit marks a PTE the scan accepted as a collapse source */
+	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
 };
 
 /**
@@ -627,7 +627,7 @@ static void collapse_control_init_scan(struct collapse_control *cc)
 {
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
-	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
+	bitmap_zero(cc->eligible_ptes, MAX_PTRS_PER_PTE);
 }
 
 static void release_pte_folio(struct folio *folio)
@@ -1482,15 +1482,15 @@ static unsigned int max_order_from_offset(unsigned int offset)
  * mthp_collapse() consumes the bitmap that is generated during
  * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
  *
- * Each bit in cc->mthp_present_ptes represents a single occupied (!none/zero)
- * page. We start at the PMD order and check if it is eligible for collapse;
+ * Each bit in cc->eligible_ptes marks a PTE the scan accepted as a collapse
+ * source. We start at the PMD order and check if it is eligible for collapse;
  * if not, we check the left and right halves of the PTE page table we are
  * examining at a lower order.
  *
- * For each of these, we determine how many PTE entries are occupied in the
- * range of PTE entries we propose to collapse, then we compare this to a
- * threshold number of PTE entries which would need to be occupied for a
- * collapse to be permitted at that order (accounting for max_ptes_none).
+ * For each of these, we count the eligible PTEs in the range we propose to
+ * collapse, then we compare this to the number of eligible PTEs the range
+ * would need for a collapse to be permitted at that order (accounting for
+ * max_ptes_none).
  *
  * If a collapse is permitted, we attempt to collapse the PTE range into a
  * mTHP.
@@ -1499,7 +1499,7 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 		unsigned long address, int referenced, int unmapped,
 		struct collapse_control *cc, unsigned long enabled_orders)
 {
-	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
+	unsigned int nr_eligible_ptes, nr_ptes, max_ptes_none;
 	enum scan_result last_result = SCAN_FAIL;
 	int collapsed = 0;
 	bool alloc_failed = false;
@@ -1514,18 +1514,18 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 			goto next_order;
 
 		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
-		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
+		nr_eligible_ptes = bitmap_weight_from(cc->eligible_ptes, offset,
 						      offset + nr_ptes);
 
 		/*
 		 * Swap PTEs accepted during the scan are counted in @unmapped,
-		 * not in the present-PTE bitmap. Account them for the PMD-order
+		 * not in cc->eligible_ptes. Account them for the PMD-order
 		 * candidate.
 		 */
 		if (is_pmd_order(order))
-			nr_occupied_ptes += unmapped;
+			nr_eligible_ptes += unmapped;
 
-		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
+		if (nr_eligible_ptes >= nr_ptes - max_ptes_none) {
 			enum scan_result ret;
 
 			collapse_address = address + offset * PAGE_SIZE;
@@ -1731,8 +1731,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			}
 		}
 
-		/* Set bit for occupied pages */
-		__set_bit(i, cc->mthp_present_ptes);
+		/* The scan accepted this PTE as a collapse source */
+		__set_bit(i, cc->eligible_ptes);
 		/*
 		 * Record which node the original page is from and save this
 		 * information to cc->node_load[].
-- 
2.54.0


