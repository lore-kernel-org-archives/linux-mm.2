Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1FECCAC59A
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2802F8E001C; Mon, 15 Sep 2025 09:53:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 230AC8E0008; Mon, 15 Sep 2025 09:53:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F88A8E001C; Mon, 15 Sep 2025 09:53:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC2348E0008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:53:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 97AD0C0698
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:53:00 +0000 (UTC)
X-FDA: 83891625720.19.7989BB3
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	by imf24.hostedemail.com (Postfix) with ESMTP id 92500180003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:52:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=TRQovllc;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="V 7XtVNN";
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757944378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gj2hpwBYG8Xyktyq6qkf//++RSuokJq1T7PZ0K0vVVc=;
	b=0f9nymqFfyBayIEBfEiwL2FyA260yefk8eQxuU3bUi7pRWi1sIwRUNkg2yNSnFHqQ9xPyX
	f42Gfsaa6+4zlqnRKSVetPZJs6Z2ozJzoZLAjae9a/gvNL/fyqCBXH89x04asEV2apSuLw
	A5Y9wFt4OTHO0+3JJfXOlMfnDmmbQh0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=TRQovllc;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="V 7XtVNN";
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757944378; a=rsa-sha256;
	cv=none;
	b=RUqX+w/QFdg04vHsb27s3uUMXdXLOpMafzEFDzHRZXqZRlqm/crtPjdRQ+gUVTBHLs3VSn
	QlQFix/EKtvYibOhPYo78qi3bK9eCJjdewYxMxS2Qq9eHwqxggN5uvGlsPqxnd6iPFGitQ
	qTihJihC5TWSu+CbKzgoJPumqe7g1EA=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id 40F3B1D00071;
	Mon, 15 Sep 2025 09:52:57 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Mon, 15 Sep 2025 09:52:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1757944377; x=1758030777; bh=gj2hpwBYG8Xyktyq6qkf/
	/++RSuokJq1T7PZ0K0vVVc=; b=TRQovllcP3cGfwvSIC32Fk7ufYxzgqSANa0Ww
	KVoU/WB3mM9Mws7u/QXn41isoeVvTe3tfWJ2xdaY0OpgznS6Z4mk7Pauo4qVtsWV
	sAr79oFJdyIPAKjM+Q/Se7odJmCNsAcAKKCK9Z2pJzxry1arQtUSXIi2nf5Lm6WU
	stPwHr/KxOzBiOVkah8EEOyzEWvLjx0ASIGEvaAExWQPVSi3B+zogBNBkzjMu04P
	mqFGQTrUinDu+5HsgunMNh4ufLnBXRrSpS8mQGZC6mZBAK7dcurRxGwPUWTPzpD7
	ReHUK+mQ3glKe29Ek8CJ9+b36XgfBQyV1SfrdVhtcqNbby8Jg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:message-id
	:mime-version:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1757944377; x=
	1758030777; bh=gj2hpwBYG8Xyktyq6qkf//++RSuokJq1T7PZ0K0vVVc=; b=V
	7XtVNNB2sTrMAJSaLx1ztdTaeabBuKRJwu2GKIvCAK9MdCU5w269OEfccx0RSier
	WAqkO+vPUtzunWYS42ieJSggYSECVCxgr+8mJDTePPnl4sm8+YxBeVDx7QHz0PQ4
	yhxppVL4Ogf/hm2qASWhuJlOnYS+M6CgM/LHBJluW7O10y3jTgebwbIOCOdipYsY
	bu4STeLlfIhcNREp12KWOuij7osEd4jE3vRJ/IcV52wLMNYGrasfjB4dlURAX7Sg
	UrZnhQ6U6VCnwJTsrh/Rt+6Oug8r+iuwAWDwc2Z48gmt7/7Ff+23zpT1mFvkgmQu
	dLFWIH04S95nY3pGGYaMA==
X-ME-Sender: <xms:OBrIaOXsPtx3oB2Q05aLiiP-CaURc1DLi7iX15vnfzWmOCWe_31rBw>
    <xme:OBrIaGfbeZHh7P3e7vJjtc_F88iTfucYKBIxRO-F5WXTKQ8ll8KqBeQln8AVbGYz5
    I1wBDRjbAwwRdcfPWo>
X-ME-Received: <xmr:OBrIaLMF0XJxw7PrE4aRI3i1GzlnlnzOR1jkK450bFXEZGo1R7AJOH-GM0htvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdefjeekhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfggtggusehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfuhhhu
    thhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrg
    htthgvrhhnpeefhfdugfeghfdvfeefvddujeeuueefvdefuddvfeejheevveeigfejteet
    teeiudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepvdegpdhm
    ohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnug
    grthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhr
    tghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtg
    hpthhtohepiihihiesnhhvihguihgrrdgtohhmpdhrtghpthhtohepsggrohhlihhnrdif
    rghngheslhhinhhugidrrghlihgsrggsrgdrtghomhdprhgtphhtthhopehlihgrmhdrhh
    hofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepnhhprggthhgvsehrvggu
    hhgrthdrtghomhdprhgtphhtthhopehrhigrnhdrrhhosggvrhhtshesrghrmhdrtghomh
    dprhgtphhtthhopeguvghvrdhjrghinhesrghrmhdrtghomh
X-ME-Proxy: <xmx:OBrIaOKR6veAbfhMTlXmK1rgBhnEJYsMEi5sGtMUTYhBzyt4Fs9iXg>
    <xmx:OBrIaBk7ksXO1fhgy2TyV9qwb9sjhUhBIim5B5iMjQ1yeJFxe-KqRA>
    <xmx:OBrIaNbFWPk34Px1VpvGRXYpq4YX-tIvlS1Qz52wKRg_HDZjiDOM4g>
    <xmx:OBrIaAivdDqldIpGlPoxonEfWth0BoAR8I_6dfN_9PNVNM119svYTQ>
    <xmx:ORrIaMo056VAA1hEZjRraCtU6B9R7QkHEtAd4TUVqwmcZN5DDQGlaAKr>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Sep 2025 09:52:55 -0400 (EDT)
Date: Mon, 15 Sep 2025 14:52:53 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2] mm/khugepaged: Do not fail collapse_pte_mapped_thp() on
 SCAN_PMD_NULL
Message-ID: <v5ivpub6z2n2uyemlnxgbilzs52ep4lrary7lm7o6axxoneb75@yfacfl5rkzeh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 92500180003
X-Rspamd-Server: rspam05
X-Stat-Signature: fow1jpuh1rf9rjduyxr4gg47ojq34eqh
X-Rspam-User: 
X-HE-Tag: 1757944378-331355
X-HE-Meta: U2FsdGVkX18pMcXpJVpsxh5hLkD5L2GgQjoWyojIEmuWUeefM/bQxVOZ0AUQzi4b0nNAzrKnva1HO6SwbAdGGHa11ZTj3LiB3T5b3UOc2b4BhfjpU2XAeaH1XS4gfDfnLcH40oCNux3ATiKiLCnjPjiB0ruUbpl5AdxUEWoUin/vIvyThdJnChvVcOSadDDyd77wBENx4I/SuVvUj2GuKG6ssNr7u0TLUP791KXdzAymrXSaiLskyhbFc68999B3/3ilfYBv/R1+f2ZmemV4au13uR/GXHAeHnFzLO8lVpnc7tl6naqh34OXBpFq4paHq3WO+vXziyVEdPkj5XQMwFWYp+F3iFjQC/XzTQ+CFj2AuSo/vGkdVCpVnq0um0v+frWL6rUjd/94JjUtbWD+YFYAHd0JHPbgwWcLh/3e+1+ynrmETIQgrkodP1+2X1Z6cgSi4BWGyPD5f+4H+RmtwLhU1y456j6MmRY+lmvnpXDqq8/vrKr36/KdOXesDVx4hKEAsDZaNlq1p6ig8DcWxnCXf0kdTk8Dd5TGNfO29KXDDddJJos7KGZf4bwoe9NJiyGkOsZtQ7ortaEcY8uXoSDceFVQhSlwAsVMVF1nZNquI5ViWF/ZiaH/cJ+j7qx3XtqsiEOQ/bWkFM9KEyCjzJEyJUhCWOHIVQjPnOu00ReRb5QbsSin+QQ9m7e6g8g3CnnrO8tjCnkwxvwhjvz+mco1gkhBGElNC2c8YdUqLVG+XNqB7+TD+I/FT22oblXA/F/zSZaVobrgckmzmsOfi2xntGcD10dKwhBDhA6Oc6+EtyE5VUp1w1FlGw3YUVlwf1EDdV7svAoqnjk1P258z01Wf41nSXy7h5g7D5JLw4gF9XzC8f7870FoZoQahTCGN+iIQlJBySDtKvo1IOTChO7Tkzjd/qiMMskcDH5FhN557tR3cJ6M/BBbU3wZM22rdv/P77qRhJ9T7syltey
 l6oovi5X
 yPE+2cgXpR5FZWs45zKlY+JpsKGWPnPffbjh8oD67zQgF4IIHXwScOI8Cs1nBcL1/a8rPU7Xu9TQpWLmbu8acc58ziw/jY3xEmpD4knnMx7rLeXJD4hg22lkIAydIgxJJVJcbbWFHaqrHOE3XrtXa2UiyENA8FVin/ld9XHELW7PuQTfftjkmwX8kaCySyCy8DUjiWUqkF0qqFpPqT/P6HFa0fYFaWADFyMV0wuKA4AKeSTlEtHcxZNqn6tyJ/99IERY3U3SGdkevF+G9u1MtS2Guai2OnCi/Q8jUvquOXvhkH1LIXBG/eTvkugjDmLf9OgGSjQ8asLPU/5xexFH1Rnh68yScmbGt/f/2+LWffO30OvjBbR6a6BcTEVpnXoSdjsGWJqIbOHzxHA8WTg2i6C/T9WYOMQhNYY7lJtUmQYB4C/HN6aTVuHr3q8kK98cH9ChJ55wXI2QHnfhJHpokdlXGj357e/1cbleoqFEQr0F7H4i35L27YzeMTfheDqFiO24f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

MADV_COLLAPSE on a file mapping behaves inconsistently depending on if
PMD page table is installed or not.

Consider following example:

	p = mmap(NULL, 2UL << 20, PROT_READ | PROT_WRITE,
		 MAP_SHARED, fd, 0);
	err = madvise(p, 2UL << 20, MADV_COLLAPSE);

fd is a populated tmpfs file.

The result depends on the address that the kernel returns on mmap().
If it is located in an existing PMD table, the madvise() will succeed.
However, if the table does not exist, it will fail with -EINVAL.

This occurs because find_pmd_or_thp_or_none() returns SCAN_PMD_NULL when
a page table is missing, which causes collapse_pte_mapped_thp() to fail.

SCAN_PMD_NULL and SCAN_PMD_NONE should be treated the same in
collapse_pte_mapped_thp(): install the PMD leaf entry and allocate page
tables as needed.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---

v2:
 - Modify set_huge_pmd() instead of introducing install_huge_pmd();

---
 mm/khugepaged.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b486c1d19b2d..986718599355 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1472,15 +1472,32 @@ static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
 static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
 			pmd_t *pmdp, struct folio *folio, struct page *page)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	struct vm_fault vmf = {
 		.vma = vma,
 		.address = addr,
 		.flags = 0,
-		.pmd = pmdp,
 	};
+	pgd_t *pgdp;
+	p4d_t *p4dp;
+	pud_t *pudp;
 
 	mmap_assert_locked(vma->vm_mm);
 
+	if (!pmdp) {
+		pgdp = pgd_offset(mm, addr);
+		p4dp = p4d_alloc(mm, pgdp, addr);
+		if (!p4dp)
+			return SCAN_FAIL;
+		pudp = pud_alloc(mm, p4dp, addr);
+		if (!pudp)
+			return SCAN_FAIL;
+		pmdp = pmd_alloc(mm, pudp, addr);
+		if (!pmdp)
+			return SCAN_FAIL;
+	}
+
+	vmf.pmd = pmdp;
 	if (do_set_pmd(&vmf, folio, page))
 		return SCAN_FAIL;
 
@@ -1556,6 +1573,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	switch (result) {
 	case SCAN_SUCCEED:
 		break;
+	case SCAN_PMD_NULL:
 	case SCAN_PMD_NONE:
 		/*
 		 * All pte entries have been removed and pmd cleared.
-- 
2.50.1


