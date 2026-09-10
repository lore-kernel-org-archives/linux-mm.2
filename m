Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03368C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5E716B00A0; Thu, 10 Sep 2026 08:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D362D6B00A1; Thu, 10 Sep 2026 08:02:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFE626B00A2; Thu, 10 Sep 2026 08:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 923576B00A0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:02:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07C9AC04A7
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:02:56 +0000 (UTC)
X-FDA: 85197716352.30.53F2FB5
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0FF2218000D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:02:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="D QYJaEK";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="OdIE7we/";
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789041774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4UhpKBn4QA7xtpBWtOXdoBNDcNab8zz8WQs3EPLY2Y=;
	b=Ckp1meEnm2gVRgljmlHnZM62GN3b3UCC0Qw7vK8/thAaKXVbf8q2H7cpPxTSOQk5oWEaUi
	e3/TwIv8IQLLriyVbeDD6uJg/WvV8jCzCxZLPqAFVyQiKxZmVBnQFc432dTBZPJUGY9Lcr
	GGHaF243OCWkNrnY6wv6tw6KZq6ucV8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789041774;
	b=HWkkDPXLuA3jXsLXD7B1jkxTI3oxg6SSVF7PnPQp6cLzu5zhakn8N0P8lsqbs7NnRtpx/y
	LXDefSrIRnabeoR6qaDX5xLZ/LoR+KnZc/+7KJHMRM3elRpr4FYQ1OpxryQouXEG0lxmmg
	k7luAwO1MSR2/uneJpBi+Wwi00Xj6Ew=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="D QYJaEK";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="OdIE7we/";
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id 139B41D0006F;
	Thu, 10 Sep 2026 08:02:53 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Thu, 10 Sep 2026 08:02:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789041772; x=
	1789128172; bh=n4UhpKBn4QA7xtpBWtOXdoBNDcNab8zz8WQs3EPLY2Y=; b=D
	QYJaEKcZ1hIz2XR/+D07PnV8T7gpBimlKksRiqPz4pu6xdZWOXgpt8di24rsf1GI
	2MeDZT7cKhgxtE0O3wDh/wCzIkeTkpJVt8WofzCNxeRLRmPAAYbWC03nWq27aTdh
	a4Ey0AucGzQyd+4vNmJrjye01jULfndzP37lAIQWBJBYlCcEgvHJ7gyGiWbK8BbJ
	c8iNLDIamxFBW3Xi+cKF+EiWAJ780GjR1YtTy6HBGF6XVHpeqr4zskiagoWOR/5z
	xkMx4G8QG7JmtC9/IC47GVHxiZNuH4f9KGrrbQnCEQyFpA7JhU2xclcCf26ebp86
	ONZkCThxCo6JoZZDET3kg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789041772; x=1789128172; bh=n
	4UhpKBn4QA7xtpBWtOXdoBNDcNab8zz8WQs3EPLY2Y=; b=OdIE7we/MnoC3LbWk
	9ukn3kVN+oHt3PLQ4LUZkGHYu55kH+PzyxRM2jCKqFF4EfLVNC+VF6XkozOMlC/L
	wtBwROAN1SYB9xmHiOULwSW9iAdJSMDr/nchR3jEbUDKl4K3QE61qOqgLDnZGcph
	D40XoopUbOm3ct8KvsTw4ruc86yCAIJgTbsMqR6ySJrZZ6QzgFRAMI6N+hQ6u99+
	I5xbLKDr0pEJOj2+4CufHwAiy4IEl+08V0wYwR1xkweYcDFNUmCyCYlQModpUeH+
	N7h3gcGQJjfEgisomcuqu8GFwneEYA2fzuLaKNjeCqV0kaVFDtD1jaAObsd3csMB
	W/r5Q==
X-ME-Sender: <xms:bJyiap7RTHzlypsaVP5FejHHlO4CXpAWrb-uSwI2LNepfnv65TdGWQ>
    <xme:bJyiai3z9XuiPFQtXji4HxOgqg52_2ZswNVgNY6hwyshtiQ-42BSmuy9SPkWJXyte
    g60e_7JEKhRb17Tkx6CHxTijNXC3UcvzSaPAbC68cvGP1swz1qvpLVe>
X-ME-Received: <xmr:bJyiammUkLZtIQQxLx947L4T4pYZsMtpvNb5_MYv5WqsLOim_-r1xNrFZEU>
X-ME-Proxy-Cause: dmFkZTEVCHaom43ud29NDpH2Ao3u7HJ/1ECQvA0KKWbvYxhttLa4TfzKR6zF5UuYx3UdSX
    No90AnuR4y57x1CX4a9AAsMV1JR4eQYCvRkfoTmW6C9Lc6lI8AZbTNwmqz4UTzT3vnk7qg
    ph+TCI1xI7srBtDO6Tg5MLzI4vqgzAzQGVqRHCjhPRmxizMOs2MvZfOp4fytB88FrNmNEM
    gORbCSjN6PT3vgIUt7WNrJZsAWFpVymtt3pMoPYb3jF9rU+m42uK7S67tVqaIc+biyrQXs
    /trDbiCnZfBDKlB4R/Y3z4EcguiWXCyuMp2o4aP4AZn5jbn1xeIsCoHcLAwPh3Pk2CuoWx
    8p4Y64DVzNe7hQUlN9olRsCMsh7I+2WdAMmvc4ZwWsdlHLbISDjGhTQqurtvg9FXVBrK6g
    hFWMxp+oNKj0WJ5sMz+bvWMo4a+Vq6h9DnxgfzlFTz0MXUKTFhYkWK1NX8H9A7Nn62zpk7
    xF3otauenLIWJw4+B/KeBQmo6JY/mOELVZxg6fKA59kIiWJk/1ZMgAMpkh8MAGV/oCJAD9
    lge/aTFbPneV6plNechjNgQD8OFPfJ+qKOGstpABLeEQsHjsO6ZdsAjJfQ+kHiJQfi91//
    8DGmvge6Lc9HhqMV+S+6Fywa+hq3IEjO22LnfnDXEqbkHvpCZNsllHyaVImA
X-ME-Proxy: <xmx:bJyiaohfV6Lvrw-adKMy_uK2_UqND6m3Xc-_7xQ7EsSbgnKwtlTTdQ>
    <xmx:bJyiarSPJ63QSQCqV1pmjImVSNRRwhwzfoWUqBKnRK1eskc3F2dqrg>
    <xmx:bJyialiDDHQirEotdshd99UWNa_fc5CYLrAWj51h5-FoTVrzQVHTNg>
    <xmx:bJyiavgbFFeQP_j1c9wtaG9OQ9UmdVZlRYECHWoqs6eQ9Oe0o6EN0Q>
    <xmx:bJyiase3Uzyx1YKWqkLUf-h2LZz9gAIoTPgYGID_TeNVNfXVrtN1EmeA>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 08:02:51 -0400 (EDT)
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
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v2 03/12] mm/khugepaged: rename mthp_present_ptes bitmap to eligible_ptes
Date: Thu, 10 Sep 2026 13:02:23 +0100
Message-ID: <20260910120238.2529819-4-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910120238.2529819-1-kirill@shutemov.name>
References: <20260910120238.2529819-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0FF2218000D
X-Stat-Signature: qixopwxuytktyhjxqkary31bfhnbu6er
X-Rspam-User: 
X-HE-Tag: 1789041773-920184
X-HE-Meta: U2FsdGVkX1+fpU2zMgHwNMkjrBK69BYRaPBtBUNna0sjJRRFvpKCUDn9FsK1NzWrEv0myOFQpEt6zXGg8WR8Gz5QT9puyO54TIF8Lhv4okbw4ojOO172fMd0c3yNAHFwcjAg1MfR4oPtgJeDJ68b/dfFQbG7xlzHrGo/eJvVGc0GoIiUtjFBrNsIRd48rKb033SzW/qbfAXZj3YIIUM7TwL7jpL/W14ZOG+SBB2ysy8QkAtnUMgGCPnsUBOGq+fvSMGG9JBtC90VQjl/AGCCSLXfcHGQVxrrqeCu4+FD31uMlLRSvzVpbP3yQwAI9270hT/6ydcPsu6Rg8vaQDCUOlfAobAQzTVCOwC1o+J21lCXE+IwLGEto4VsI0vzm5B/PawfDnZzcnrgxkr0geEfmVugHuBWsTwS6vgoxADLBdA41M6HNLu5dwN6vVy6pyS/LIvq9UBWvKeFIxN3kyze3w5TH1Y4o5sukmy+ANzrtv+FtJcWVcIyAe61PCbRZSJ7O/m2E08Wl2euy5owmf5GoIigkImpgIiBucaktKqfNbhgFPJZ2VSfPSPfMPg7JbEAOaolsSiuqIz+ZZ5TA9sQLiLbWVsrexuKNyX9oaSTNJhx0XbgkmJPVG9bYBWfiR3gbhY6aDn/dpIMR1RTWHsnV5pnhflG58jts0QouL5zYam0cdRhhMHXfQIQntEc3ONp6sPslsWd72p9LX62QALpDqdQmGSmC81Iht7ChniXclbDBt7I4OwU95Q3Q2h+n6ClsfII6gVuzFJrwc9DgZyONekhL2Hi34RqZA8TSCcjsOSMknJMZBIZ6n4wQOkNO3V2heWHhnceOkJtDW0jJRiDPo13vqQtwFFiMVANEz6X+rYBWCxwhI2aos/iI9y7GS4Z5XKYihIK4yznDbg1maKJS9Ep2wc0G2fAfioIhOzjfvGVaF/pl41wEHOSkp6IP1dYm/mcTTlnq1HjQBn2oMn
 RRoXm2XY
 EFUmcs26aTLn1QpeV7MI916wPFRrPT6twYaaFn7wOOgmPaoYIkCiZrY4Y5WnmfL+b+X5o86dmqauW1j6xa2zSYLDJXBl8Yp1zjmHXUFESjxJdPuU954xjDgjwe9e5bTwRQ9QdVvpEqNj/iyOWxZ21fdoblzK9NlN1A/LEjUgnyjLLTr884BVf/u/h433UxAUgcIuoEuAexFGZc+eWt00+e1MkoISsGph94STPuYGrKNN7V0x8YFfx3pGGLQpTJMG+hhG9SoosgmF6GPEeCZWKxlSZGz23oGxSJKALx96bPJSYtANoHvBhCy5hgKALZZCaBV8ocU/ooQqT+9kHirV08avb6JrZYfZZoHn2rmBOhspl3CPDJvhBXScPcWziFoc29/xESLkh0FFnCPEDUoR54eDq4Hq9XIJB73cTa8ISJcHO6RajzpaCE3DvdAE11ICtU1+I2M7ewr0yNWRObwxj3NkJVnso2375FmH47aOlFmlD6vn3ymjtGlwqcUusPC+77Pwt2ws2L88m8Hk+5G1Ro3ym8sbrpcNvHEYW
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


