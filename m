Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4F39C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 097166B00A4; Wed, 16 Sep 2026 05:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0765A6B00A5; Wed, 16 Sep 2026 05:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E793C6B00A6; Wed, 16 Sep 2026 05:32:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B90876B00A4
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:32:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 408E41C2BFA
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:05 +0000 (UTC)
X-FDA: 85219109010.25.C813438
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	by imf30.hostedemail.com (Postfix) with ESMTP id 350F38000F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="l kTwwmg";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=IfHcTkeL;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="l kTwwmg";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=IfHcTkeL;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789551123;
	b=R5oAAhp3s+AdvzyrZCM3uk0isAzrTLnXH+dcV7KA7Epl+ymtegagzTHSr32mjYztRHuqPN
	v/tUPTc36FnUzpsVXY+suhYt4GVX5f2dsBYN8xrMPdfubEWCGRwOariOo8MDwaU0oe0MDt
	X6w0zCEKqQpQhnPZy1aK8EqAuCrMnDc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789551123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ICF9OPiue2yxmh8hP/ZUHQcKxFznzKsqrqQwWUt5ISk=;
	b=ArTfNKQuUZU42Zj8PNa6o5c/0qlyP1FGmf2MM/UenoQfIQVqMYJ6e54gJnfXLU73L/bd5o
	9QiH2mSgwcCQqU742e0KnivzPe3qXaYoXBDKl7o9RDZKlpoz66L+ljDujvx1THNbhjt9U+
	8IQldmdrG8gDfIjhwiI5bgy3xI1xf7E=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 28C0F1D00098;
	Wed, 16 Sep 2026 05:32:02 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 16 Sep 2026 05:32:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789551122; x=
	1789637522; bh=ICF9OPiue2yxmh8hP/ZUHQcKxFznzKsqrqQwWUt5ISk=; b=l
	kTwwmgmVxsBasNJphP2tCEw2dpkK2tdbDfRwh1Wn6LKKld4EuTVM8c1XZHRHkm+V
	THhHH3mh4DUAc1aBNuwdbcOzJDJqjZby1gn80iUHnDXsIm2zWN5kIYakLBKoDdci
	G9nzvooF83s2B0NlQG6jf62GaJ3DpFfRLOuY/cpCtlcz9Dv6ga7vax8DYx2DXHw5
	UcYxqUPBFlrx0bz9Kt6d+HIK+e7R2wy+jYmcNldvYpdpQONVo3tmCiEb6kTNcxlf
	SBb6Ay9yKpIGFVh5X85F5XzGjrxMKESmxWVofwEWbWJGZIDso9jMhB6xua0qOQkD
	YzgW0Vj8BKPrWdt6oYtOQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789551122; x=1789637522; bh=I
	CF9OPiue2yxmh8hP/ZUHQcKxFznzKsqrqQwWUt5ISk=; b=IfHcTkeLQ9ubDaRHX
	xvvXfbj63w4k4jOZQ31eTezzSh+0fKBJPJOlgqQqeFw1cvxCggrNRs1nnRMUVJlw
	c/woxe7Cmtp+y77D1khAQRBQG+D8eoVmW1PkmtCiRfaO0ihzKYVMrRnrnKCB06cE
	R+qVSjSxl0qCWJzjOOD0YUyh98deQRE57vo4upJuuUhT5Dk7gK5f4lIjQZlBK8eI
	KdrujaJTAXyl283MIN1FfRyLf3OwZJEy7xxvkzbaE6PloPGmNVAtQw4DO2J4Km92
	9Nh8yAawStltZzyoS91Er9RZPw+y9C5Cb7YPifrDMrpaXejNkkwhi7NxdxCsvaLY
	5qItA==
X-ME-Sender: <xms:EWKqauHyg-evVuJ8Okwc-jJGR6EVPH91wu2IxcNm76HsMJcv0P3p5Q>
    <xme:EWKqarROFW4K2rRiaPes6f5t8L3FiRzEMC6_BVu-hwNt7sUm1dA_16hiygsW3OIyJ
    YjN3ddklBlsy9rYZuXOlOpC7cKA0xwTl6mEL9cIZBclaFjq-ELCgs4>
X-ME-Received: <xmr:EWKqauTWmWw7hqhMwITq7z-WvnHkUxF57OtncPZqDe-IlMGVfg9dskINtJ4>
X-ME-Proxy-Cause: dmFkZTE31qL+uaIHQKQPvpaICSxxs7QGWvIquuW8cKaqYQWKvt9pKCqy5bgk//TApl3wTl
    ad4FQSRAknjhMkzVuMAZNh0T12ywqROLvU4AnUXGVwd2kiN78Ar+1NR+fesCkATu1LALh1
    4LvX/9qk4pAfO725ECjoAkI82P3z755hZxEkAV0An15e7Wr2vIbgLFM815SfkNmTU/eBmL
    ORNXO2IPaHkpkCtL9iOfg4dR3lpAdl3Xvq/Y35opAbs/zzbuDBIkBs44NTO3w5x5Bedurt
    thFl4kzzMjhv7UlAxOBz4vPRXQMYZm6skstaNA0N2ZkZEKrpjBUX5624wA8G4zEpHd89Vf
    9T6n7sacdOaicBHl0a9Aiw51JNeA9NYlEYhEhIDx9KYOW0onA68maUQsM43/Hp6DjkU+Nu
    72ekwCSo3DXmCWJ6wX+0Gd6ukbM49sUWHHNcWEe2Vr1f863dlft3DSoweFQ83vga9K0ojQ
    CYUQdYMItjRfsJ/xU+UsSJn4UiKGPcJsiAU3mczm9byTBs3kPOTyf/ZuA2Iqc3vN3ViBj6
    gO9wjuvLNdFVs/TsSWTql3QMRjAHfcVzbmQP16qMqIAuCI0bGGcqhqa5juTxSnna4X1a37
    vIlEH/Kvcys3ycZrZsrYEZ6/X0mz3FFd+rZMbzP7j/Xp40ENrkR1QO3B00FA
X-ME-Proxy: <xmx:EWKqaucvZ2mDR_VH9h0XC3vk381LQdgXXsbg5Z8uR14PYOL0U-aqpg>
    <xmx:EWKqaieirB0pYou9kF1jeq0AYGlnEckfM5rAS9WbH-X9zfrEuJTiPw>
    <xmx:EWKqak-wTKclTlOufwy8lSZevpTgrGaZvaCYxJUTrfMd1nca-ZXIyQ>
    <xmx:EWKqaiMrgXc2s-2Nua6XucVVBU2DcUt0frr2-s0PuzuH5Ef_tZJpeA>
    <xmx:EmKqavHyfwM2bEgGK4z1WoR7_Q9KQByfcNHxmbXIasB0B4B5KRTDGbuA>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 05:32:01 -0400 (EDT)
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
Subject: [PATCH v3 05/12] mm/collapse: state what a collapse may do in the policy
Date: Wed, 16 Sep 2026 10:31:32 +0100
Message-ID: <20260916093145.4022188-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916093145.4022188-1-kirill@shutemov.name>
References: <20260916093145.4022188-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 350F38000F
X-Stat-Signature: usmb4du4grqrjqgya9qoiai4dhgqa9d7
X-Rspamd-Server: rspam01
X-HE-Tag: 1789551123-834833
X-HE-Meta: U2FsdGVkX18EO8aEUB/thPOWz+JChs30fPG1xVVtIotAjrUasAAnYcmkACW6NEuTmFobjkuG41pCl9K/uyRd4jmGJka0Y4iF3/I3jbjJH0EtcsYuYR67evHwd9fxbOmZTcI2xAwJyoe2Wg/bhxEHmvXElMU4Z4bWzAwYa2gfYHrZqBf8X2WSzyTqdbEjhz+2In2pEaP3I+o07LHEzpuKnjPJ4oTvjQw9BrI164tJI7edDO86pbUdIiH76HcP78WXCTj1Q+F3TZI6H0Dfqyo/mJmLLcSKJwyNyRaexiKreG6aHRYWkNC2cPcg2aCKfJJ63G43lnLlVQzT7RPaPuNlhGrA83JFsZjwvwK1sQpmuvJHIAnN5jFlfa21wV41iaMGLn6BSm1Q6eR8gpjx/oZbDsrbwdJ8hQOAe5SBLguffKy1F1PhnqVb9YgjgASuRu9B8UTfzLQx7alfXNJscgYwp37jNYDO6i/8f3H7hDOyTv7JqWsbtcqiz1NEfxAK/D4EJACAQjqSrHN/fveh4YacPDOKpIyw2J4x0k9E4B2iCvAVLmSYVQTKrAvDAm3iDszKVc3FiiPf4BNBrZS17unc4xbiUhrz633vlnLlHrf3vKPSRpKSkK7uCdzYfg6ITfH6ObQ9kjtZbwhKdN30o+kMuL0A0ySyXxuOE+q2xZneM7GMVh463ELJyIxH0CkXoB7RBr5AZ2v8VBeSmagWbfOUA+6muKK72o9eahCDyPQWsvhp9i2UiVe7IIZJEerZqwYkpPwp7MDa8UVOxpgDdOKiVw3byz2XR12WWFiG/5rGaOgy5qLXME2KLA5pSL0Uzv4GdaaEoxUmX/mS/1y90OfpYgYtCpIZBu86ul9uijEPMszR/nZGenyr8Job9Wt2VZd/cbNAhd7b9OnTzK1get1ha2hUyoVsb188vtN52hK/nYXVh6NSldxRf7cL9vs+O5dPDbqNhOX5oGzhIsc0LJt
 4W/M2oTo
 R+6DVE7vMVQldkBkGO6lZ0CR/fUPyS86vlEosQ6UwlR4qtqFSTvfa2dyI/oZzLb7XNv9Vwjl58oANoi2Ovjj8QoiW8+xup7OnolnCnv7nkbLC6zC6QgIUOrZrUJVlAw2and+om3u7lwnK/nMSUwJe9PtWqkOVxufAJdZa7RyN+KRu97MLO+SjdgndJL0IQ5DmIP/gb6fSolzm7/s7224d/736ZOQAds9z6s3RV9Opoo7um9DT30QlvNaDgybl0RE+esgbIBDq6mcYy7pufwDc2sIOs8uL51KbXF9Hfd1OZIRm3KJJEalzsFbdi1Fc9u18tmxNTmovwxtQFpEgd44ViVLl2VYmcoVKdx8WKAZdc4SacHXSp29/y+xjhkEdoGZBc5Z5siRy/fZcTB2uyG93rRWKyePL5uBJU+pexinARe2sEhjG0ngBuLXV9VzgwmmNxsPqZUSi2/RUw+NlM77Or7FUXMTPngSiupMFSOe6Ht+w3IlK6pLqzZ922A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Tests scattered through the collapse path decide what a collapse is
allowed to do by asking whether khugepaged started it.  Between them they
settle:

 - which VMAs are eligible, and how hard to try for a folio;
 - how many empty, swapped-out or shared PTEs a window may contain, and
   whether a sub-PMD window is held to a stricter rule than a PMD;
 - whether a range has to look used, and whether a MADV_FREE'd page is
   left alone;
 - whether the PMD is mapped as part of the request, and whether dirty
   pages are worth writing back and retrying.

None of those is a fact about khugepaged.  Each is something the caller
decided before asking, and the collapse code should not have to look up
who called to find out.

Add struct collapse_policy for the caller to fill: khugepaged from its
own settings, MADV_COLLAPSE from the fact that a user asked explicitly.
Every test becomes a read of a field, and cc->is_khugepaged goes, having
no reader left.

khugepaged fills the policy once per scan pass, MADV_COLLAPSE once per
call.  That is the one change in behaviour.  The max_ptes_* limits and the
defrag setting behind the allocation mask are sampled once per pass rather
than on every table.  A table scanned early in a pass and one scanned late
are then treated alike.

collapse_file() also drops a NULL check on the collapse_control.  It has
one call site, reached only from collapse_single_pmd(), which dereferences
cc unconditionally, so the check was already dead.

Assisted-by: LLM
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.h   |  31 ++++++++++++-
 mm/khugepaged.c | 114 ++++++++++++++++++++++++++----------------------
 2 files changed, 93 insertions(+), 52 deletions(-)

diff --git a/mm/collapse.h b/mm/collapse.h
index b115034d9018..7044dc71c7c2 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -45,8 +45,37 @@ enum scan_result {
 	SCAN_PAGE_DIRTY_OR_WRITEBACK,
 };
 
+/* What a collapse is allowed to do, decided by the caller that asks for it */
+struct collapse_policy {
+	/* Limits, stated per PMD; HPAGE_PMD_NR means "no limit" */
+	unsigned int max_ptes_none;
+	unsigned int max_ptes_swap;
+	unsigned int max_ptes_shared;
+
+	/* Take no swapped-out or shared PTE into a sub-PMD collapse */
+	bool strict_sub_pmd;
+
+	/* Leave clean lazyfree folios to reclaim rather than collapse them */
+	bool skip_lazyfree;
+
+	/* Refuse a range with no sign of use */
+	bool require_referenced;
+
+	/* Map the PMD over a file collapse instead of leaving it to a fault */
+	bool install_pmd;
+
+	/* Write dirty pages back and retry once instead of refusing them */
+	bool writeback_dirty;
+
+	/* How hard to try for a destination folio */
+	gfp_t gfp;
+
+	/* Which VMAs are eligible, as thp_vma_allowable_orders() spells it */
+	enum tva_type tva_type;
+};
+
 struct collapse_control {
-	bool is_khugepaged;
+	struct collapse_policy policy;
 
 	/* Num pages scanned per node */
 	u32 node_load[MAX_NUMNODES];
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 8889f75cf45f..cb08789b2d38 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -314,15 +314,12 @@ static bool pte_none_or_zero(pte_t pte)
 static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
 		struct vm_area_struct *vma, unsigned int order)
 {
-	const unsigned int max_ptes_none = khugepaged_max_ptes_none;
+	const unsigned int max_ptes_none = cc->policy.max_ptes_none;
 
 	if (vma && userfaultfd_armed(vma))
 		return 0;
-	/* for MADV_COLLAPSE, allow any empty/shared zeropage PTEs */
-	if (!cc->is_khugepaged)
-		return HPAGE_PMD_NR;
-	/* for PMD collapse, respect the user defined maximum */
-	if (is_pmd_order(order))
+	/* The limit as given, at the PMD order and wherever it is not capped */
+	if (is_pmd_order(order) || !cc->policy.strict_sub_pmd)
 		return max_ptes_none;
 	/*
 	 * for mTHP collapse with the sysctl value set to COLLAPSE_MAX_PTES_LIMIT,
@@ -354,19 +351,12 @@ static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
 		unsigned int order)
 {
 	/*
-	 * For MADV_COLLAPSE, do not restrict the number of PTEs that map shared
-	 * anonymous pages.
+	 * A sub-PMD window held to the strict rule takes no shared page at all:
+	 * an mTHP is not worth the CoW-breaking.
 	 */
-	if (!cc->is_khugepaged)
-		return HPAGE_PMD_NR;
-	/*
-	 * for mTHP collapse do not allow collapsing anonymous memory pages that
-	 * are shared between processes.
-	 */
-	if (!is_pmd_order(order))
+	if (!is_pmd_order(order) && cc->policy.strict_sub_pmd)
 		return 0;
-	/* for PMD collapse, respect the user defined maximum */
-	return khugepaged_max_ptes_shared;
+	return cc->policy.max_ptes_shared;
 }
 
 /**
@@ -382,16 +372,12 @@ static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
 		unsigned int order)
 {
 	/*
-	 * For MADV_COLLAPSE, do not restrict the number PTEs entries or
-	 * pagecache entries that are non-present.
+	 * A sub-PMD window held to the strict rule takes nothing non-present:
+	 * reading pages back to build an mTHP is not worth the latency.
 	 */
-	if (!cc->is_khugepaged)
-		return HPAGE_PMD_NR;
-	/* for mTHP collapse do not allow any non-present PTEs or pagecache entries */
-	if (!is_pmd_order(order))
+	if (!is_pmd_order(order) && cc->policy.strict_sub_pmd)
 		return 0;
-	/* for PMD collapse, respect the user defined maximum */
-	return khugepaged_max_ptes_swap;
+	return cc->policy.max_ptes_swap;
 }
 
 int hugepage_madvise(struct vm_area_struct *vma,
@@ -678,7 +664,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		 * If the vma has the VM_DROPPABLE flag, the collapse will
 		 * preserve the lazyfree property without needing to skip.
 		 */
-		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
+		if (cc->policy.skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
 			goto out;
@@ -767,12 +753,12 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		if (folio_test_large(folio))
 			list_add_tail(&folio->lru, compound_pagelist);
 next:
-		if (cc->is_khugepaged &&
+		if (cc->policy.require_referenced &&
 		    folio_pte_referenced(folio, vma, addr, pteval))
 			referenced++;
 	}
 
-	if (unlikely(cc->is_khugepaged && !referenced)) {
+	if (unlikely(cc->policy.require_referenced && !referenced)) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -938,9 +924,7 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-static struct collapse_control khugepaged_collapse_control = {
-	.is_khugepaged = true,
-};
+static struct collapse_control khugepaged_collapse_control;
 
 static bool collapse_scan_abort(int nid, struct collapse_control *cc)
 {
@@ -976,6 +960,36 @@ static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
 	return khugepaged_defrag() ? GFP_TRANSHUGE : GFP_TRANSHUGE_LIGHT;
 }
 
+/* khugepaged collapses on its own initiative, so it obeys its own settings */
+static void collapse_policy_khugepaged(struct collapse_policy *p)
+{
+	p->max_ptes_none = READ_ONCE(khugepaged_max_ptes_none);
+	p->max_ptes_swap = READ_ONCE(khugepaged_max_ptes_swap);
+	p->max_ptes_shared = READ_ONCE(khugepaged_max_ptes_shared);
+	p->strict_sub_pmd = true;
+	p->skip_lazyfree = true;
+	p->require_referenced = true;
+	p->install_pmd = false;
+	p->writeback_dirty = false;
+	p->gfp = alloc_hugepage_khugepaged_gfpmask();
+	p->tva_type = TVA_KHUGEPAGED;
+}
+
+/* MADV_COLLAPSE was asked for explicitly, so it is not held to those */
+static void collapse_policy_forced(struct collapse_policy *p)
+{
+	p->max_ptes_none = HPAGE_PMD_NR;
+	p->max_ptes_swap = HPAGE_PMD_NR;
+	p->max_ptes_shared = HPAGE_PMD_NR;
+	p->strict_sub_pmd = false;
+	p->skip_lazyfree = false;
+	p->require_referenced = false;
+	p->install_pmd = true;
+	p->writeback_dirty = true;
+	p->gfp = GFP_TRANSHUGE;
+	p->tva_type = TVA_FORCED_COLLAPSE;
+}
+
 #ifdef CONFIG_NUMA
 static int collapse_find_target_node(struct collapse_control *cc)
 {
@@ -1013,8 +1027,7 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
 		struct collapse_control *cc, unsigned int order)
 {
 	struct vm_area_struct *vma;
-	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
-				 TVA_FORCED_COLLAPSE;
+	enum tva_type type = cc->policy.tva_type;
 
 	if (unlikely(collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
@@ -1197,8 +1210,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
 		struct collapse_control *cc, unsigned int order)
 {
-	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
-		     GFP_TRANSHUGE);
+	gfp_t gfp = cc->policy.gfp;
 	int node = collapse_find_target_node(cc);
 	struct folio *folio;
 
@@ -1551,7 +1563,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
 	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
-	enum tva_type tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
+	enum tva_type tva_flags = cc->policy.tva_type;
 	pmd_t *pmd;
 	pte_t *pte, *_pte, pteval;
 	int i;
@@ -1651,7 +1663,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		 * If the vma has the VM_DROPPABLE flag, the collapse will
 		 * preserve the lazyfree property without needing to skip.
 		 */
-		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
+		if (cc->policy.skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
 			failed_pfn = folio_pfn(folio);
@@ -1717,13 +1729,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			goto out_unmap;
 		}
 
-		if (cc->is_khugepaged &&
+		if (cc->policy.require_referenced &&
 		    folio_pte_referenced(folio, vma, addr, pteval))
 			referenced++;
 	}
-	if (cc->is_khugepaged &&
-		   (!referenced ||
-		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
+	if (cc->policy.require_referenced &&
+	    (!referenced ||
+	     (unmapped && referenced < HPAGE_PMD_NR / 2))) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -2582,11 +2594,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	xas_unlock_irq(&xas);
 
 	/*
-	 * Remove pte page tables, so we can re-fault the page as huge.
-	 * If MADV_COLLAPSE, adjust result to call try_collapse_pte_mapped_thp().
+	 * Remove pte page tables, so we can re-fault the page as huge.  A
+	 * caller that wants the PMD mapped now is told to go and do that.
 	 */
 	retract_page_tables(mapping, start);
-	if (cc && !cc->is_khugepaged)
+	if (cc->policy.install_pmd)
 		result = SCAN_PTE_MAPPED_HUGEPAGE;
 	folio_unlock(new_folio);
 
@@ -2773,11 +2785,8 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 retry:
 	result = collapse_scan_file(mm, addr, file, pgoff, cc);
 
-	/*
-	 * For MADV_COLLAPSE, when encountering dirty pages, try to writeback,
-	 * then retry the collapse one time.
-	 */
-	if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
+	/* Dirty pages are worth a writeback and one more try, if asked for */
+	if (cc->policy.writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
 	    !triggered_wb && mapping_can_writeback(file->f_mapping)) {
 		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
 		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
@@ -2794,7 +2803,7 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 			result = SCAN_ANY_PROCESS;
 		else
 			result = try_collapse_pte_mapped_thp(mm, addr,
-							     !cc->is_khugepaged);
+							cc->policy.install_pmd);
 		if (result == SCAN_PMD_MAPPED)
 			result = SCAN_SUCCEED;
 		mmap_read_unlock(mm);
@@ -2943,6 +2952,9 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 
 	lru_add_drain_all();
 
+	/* One policy for the whole pass, so every table is treated the same */
+	collapse_policy_khugepaged(&cc->policy);
+
 	cc->progress = 0;
 	while (true) {
 		cond_resched();
@@ -3170,7 +3182,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	cc = kmalloc_obj(*cc);
 	if (!cc)
 		return -ENOMEM;
-	cc->is_khugepaged = false;
+	collapse_policy_forced(&cc->policy);
 	cc->progress = 0;
 
 	lru_add_drain_all();
-- 
2.54.0


