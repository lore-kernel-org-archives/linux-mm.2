Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D83CC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBD9E6B00A2; Wed, 16 Sep 2026 05:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D66C66B00A3; Wed, 16 Sep 2026 05:32:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55D46B00A4; Wed, 16 Sep 2026 05:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0FE6B00A2
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:32:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF10840658
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:31:59 +0000 (UTC)
X-FDA: 85219108758.08.4E726A9
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	by imf04.hostedemail.com (Postfix) with ESMTP id EB0D140006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:31:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y JYr34C";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=F44WgGMx;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y JYr34C";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=F44WgGMx;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789551118;
	b=rmtfwuuXpKh/2+QZOocXwcWIxsa83p0K7iZLjlpM3+0xPyw6WR5CUlkYrvSC8pD70dBpzM
	LWSnLQjfalyqH6XIDGGMqQHmUm+VIOYNNr/aPi6YSEMoJRdP5ScTfC3YKBx++Li2qXWOZC
	LJJTaZC6ZrZvk0dycxskkOihhfCRcvw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789551118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4UhpKBn4QA7xtpBWtOXdoBNDcNab8zz8WQs3EPLY2Y=;
	b=QQuYwt8eetOdWmvf9Dw1UD5ARqbwR7h3yZLWjPta/r6I7lq/yWjHOEatvl7yoM/Q3nJ0/e
	T81IY1fy0dREn+qhABzeavm7zdcsw9pAAxjJA5I7ayyhmd4fT8NGIC33AzplzpXg68ADo5
	FUmTG0t89+dO3Mna7eMT+ndBf32ysvc=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.stl.internal (Postfix) with ESMTP id E0E381D000C6;
	Wed, 16 Sep 2026 05:31:56 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Wed, 16 Sep 2026 05:31:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789551116; x=
	1789637516; bh=n4UhpKBn4QA7xtpBWtOXdoBNDcNab8zz8WQs3EPLY2Y=; b=Y
	JYr34CCNqrZHl7Q6SppINXitbMkf1ZCY/c4ikwCXM4iDuFnpvAs6l1Rcr67jD9by
	/9ELVNnPHn+j/ziAVMCjQx6mO3ZCxGDn/bkYzgen3oQ4s2M72PP7VK8k6i6slmLQ
	zHu0wmqaj/TYs0UfOjibMDe5h4t5vULnlatOJu5s9ePMCwyjpnVl+Xr+E3kmW8zQ
	TNGpW6K26//aKsD7psRsslmfQ99KTRcCPj2NSEJFFLD3JQgoKxhFVrHS6yOIqiu1
	wxh5gNN17GmIO43KqQxbUQ6PxRuw59zZQP/t7ZlwfOjhigSnOuC+kXWgQT4viqMa
	WPPnRihMYKgVQltDDeGmg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789551116; x=1789637516; bh=n
	4UhpKBn4QA7xtpBWtOXdoBNDcNab8zz8WQs3EPLY2Y=; b=F44WgGMx9aAyFLuAd
	DX3sYkckpCW6T+iZKaJ30Vzo+fE5FCIrjlZ56ZuvLWYmxLGD05tCWXB9CwQJ++IK
	2iNQYh1Df0PlLP3UR2PN24AB6DRyY0BuqnmWVY6O851JgNjz2aDRMlDLmY1NYNDs
	WbzTSW7rdfay6p2B9Z4mipH6P2BjIg9zDu/TF9kaJG5KRr5owNTUKKy2ey1i7q6X
	QuwpHfjYbGxqoRrblImV//Ag340T4vmLd3FwkqiezJimnZvGs7c8ewFcwB6JpjaI
	T+7JCadGB1Ihcmsuta0c/UcuJzVJMQOGBNkwHZAiLMo8UeVjnEyv/yHXAL2FeQDR
	I4+wg==
X-ME-Sender: <xms:DGKqapEPfK4LX3w22w-oH3t7ANi5ausQ6cRn9x7gffdhyWVr5UAQuQ>
    <xme:DGKqaqSlvyG898IaonIaPYk0HCZvYgPh5Dra52XjkFe0RxNWCsZzTNs-k8LuaJ4rG
    Fq4xp5kr2BSe7ZpqMEf7uec3588R8xr2uYLmXmag4WaYCOu9O1jGVLE>
X-ME-Received: <xmr:DGKqahR7fDuqVlw5cQ-N0VydiiKM9d4ObQ-l6D8thT43dxYTMu1dmfObzHs>
X-ME-Proxy-Cause: dmFkZTEOpyDQEfQMjLyldXBPAs1OiAaYjuycA/zprc2XA0sZE/gLY53LzRl6wisjmJsNcj
    shXh7L3amtO3W7Dj4gJ1brhV8efHSvbbvvisq8qNCVrU/hVVqWW2fJ8EDoeL9EfJt8J4fa
    r63UA+S0A+UN3c16swmwWrTj5sK0gOy7RYH1CN+xe4D6TTQ1ncSXBFkweWqSBfk0S52Say
    Dntsl8DI3TlZwS0igZd1iO+ltDo9n3qHIbwcYcvcbVUlu6Rxag/XK6s48+7ZTTYlI2aJe4
    hkL/jN/KxntOAh39VLdXeraBW39brB+PkStvfnz0wMlwqVlAhF3nsCCzTv21LQWeSF/iAB
    j2t+mXQn775ggvsPtC4n/CdAcpez2fjdkufQ13BoA0ie4gIaTNYLvpt3LO3C6eCly80Oe+
    5R8zcSqP7U+gnF8pyUj+uxBT3U9ceWIQJP0IB2oB5XmmJ1JQkegWkF5kmptEc2b29KTCtv
    YjEWiAlQ0F9yfOMFkAl3mL0XjabDpETvdumd8hWbEDShtaI7+foqMekZsxpJfWYszrTzrB
    wgrjD2ilfIfDinaWQgOTVnD+2/QhvZcLmdHcrXaSkRhMjU7RBfePy3+Ur23kphaUVzlgBC
    moMrk23PR1LJaTeUfHPRh2RGi3a3ZnhUy9KuWiFHCdriFlphP8AnaSUI1ypg
X-ME-Proxy: <xmx:DGKqalc4qhtbewyOYgDWM12k-J0rJkhTco5doz_bd_V7Nl3YH1BbGQ>
    <xmx:DGKqatfZCyUCXAxNUDSO5VyCm6vgQ3yfHzby8Fp3lEei3cLNpsa4_g>
    <xmx:DGKqaj-GH01q8h03LuDZ8FMEdWN6hdDvSNrWCGkSAl9-1GUasg-xFQ>
    <xmx:DGKqalPiu9fLV71tve3wVjsZMFoMpQVSa1aQpDq3oxF9Ou_0ksX21Q>
    <xmx:DGKqapmhdr_-A9_kMbcYSnVeYhASbz3-2LbkW0iZSNZJt2PsZcgD5yXx>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 05:31:56 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
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
Subject: [PATCH v3 03/12] mm/khugepaged: rename mthp_present_ptes bitmap to eligible_ptes
Date: Wed, 16 Sep 2026 10:31:30 +0100
Message-ID: <20260916093145.4022188-4-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916093145.4022188-1-kirill@shutemov.name>
References: <20260916093145.4022188-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EB0D140006
X-Stat-Signature: 79jzqpe7nsbkwhicbrcb8eb5ayyq6mqp
X-Rspamd-Server: rspam01
X-HE-Tag: 1789551117-39103
X-HE-Meta: U2FsdGVkX1/Y3p3dudYWCUwtNYPldaG6jgc1DoS69KXjgHyJLDN9v9UaM/tgAi1Gge2rizEXZdXsNSxLODUYvXwUaGSP0otMVvQcIx7sBwsGEN6k+PFjYfw9YkJ88mO4Gq35Qy389vHFFPFyXkfV16+z0FLM0UGCq5WkcqjbstIVDpzyc7j8+rplMynM7BupV1zN8mkZ1/KATyK76FnCSaO2IV5tnyp2GZlM3OLXZKxrm0MtSTZEZ+H444lK/fBj+UtzoKZUT24EFCiLrnds0/U31d3fYSU6igaIhHGM6Pn1ODHQMwI12IYx/wPkDfr0+vaN5VJRfRrRG34t+5Xfz3krXTEDBiQj++sispBazb6D/LRYn09Aa7IGO8lUN/q5H4PB1tgmLBRVzXCJDSth3rhsEpGIBkR5isRRhBe/eVQMejLssOixfdjFeP8ymuoJbVAKCDt43KFcEfG5RrGXaN3jxX20QWmqt8XlwhuuUjzEbqbd/ZDSzmAStzaI55auEnFb5wPLCn+wyma/U1lx0GVQZLknNRxL8+S1mlZhpO1wzXJwKuxp7dhf24A+9BaXHBGJh3FnKPm87ljPcFt2CNlBAZaEOTdRMhsYxzitTiF4vJOTrg3TOw+6YNAAIHI9gVhquNnQrAX/lknwkz1QLtARRN3HiTWndbAJSXB9HVe+OMDK/0miPeI39HPVmwcLvE3XWaRV3aMlF2Gxh5xWXKn9cE7K3a8hv0aKWa8tW/oiK7SgDsIpIz60iW7JVTURW/UG3fvaTJVgNsNwbS+856/+v6J5IBOKgHde5N1GIEFZuWCtrw4WlxhF3I8DrbDise0mC+3NoeOiBxeTlhtX36RzuVQ/fwNjfgsGqqfXgqgbuuOqqwmg2qmTmxNcLxyy8zR7cf0p02ZMigeS/f1I6DPh0WR9Gkz0AGLCj6/YVEiif30ZfNPG1ofD1eicobWoG8zKMIj8lolT+9lSCrr
 EqmRnZ7K
 sHGmDrDC00njFjfulgRA6xZW7NcfV1OtW/tFIbAS8PyBY+JwG0GQBdnpfqkALob0+hABSaAlOcsyqXsDvBMX0jgOfBeU6blBmFk/1aObtErwhvri4swd0cZXifV7u4Ln2GepYbcKGTE0M4igBYVtq93OhX7Or0gt19jUPL500fL1dpN4IyN5LUAxJF0OcaFYjENZsZsxbBM6Q7yeE1hLymXAa/Lm25MbymobeuqrVgAIGouH/FDNDCsCcWoV4dwZgcQSWUA67P6wgPlR3Rt2ptG7Zs6Y8O9YDT6dvnmcCYvwx0nbSyoh7Jk+o8rOizZYAbWkFnFybKhuIM5qtRyi+N6b/S+T5ECDf7cT2/6lxv/gRdTOwwophd3pu/2qM2Ps6GJC/+ehjMCVtkzSQVmG7xN7N916wNOLbtEO69miIZ7sRLBQS110UG2hHjSs3Zk9V1M4VDPI0F0HBeGZYw7KRWi61NhnvVeso8Yq6zZF+EnVwieWnno/agm4/kpTsZvQ+Lzvfx3TXvN7BHhf3ohDqptFjbZcKbTUPj1fAVEcL/mEQ2VU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The name says less than the bit means.  A set bit means not only that the
PTE is present, but also that it passed the other checks: uffd,
lazyfree, anonymity, sharing.  The PTE can be considered a collapse
source.

mthp_collapse() then reads the bitmap starting at the PMD order, so the
bitmap is not specific to mTHP either.

Name it for what a set bit means, and update the comments that named it.

No functional change.

Assisted-by: LLM
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


