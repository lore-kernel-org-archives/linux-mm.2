Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9298BCAC593
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 11:15:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFC9B8E0017; Mon, 15 Sep 2025 07:15:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4718E0001; Mon, 15 Sep 2025 07:15:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3578E0017; Mon, 15 Sep 2025 07:15:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C89648E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:15:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BD311405EE
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:15:44 +0000 (UTC)
X-FDA: 83891229408.18.D994571
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7F517140004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:15:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="h C44NQl";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=k3XJlKRf;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757934942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IAndtAUsCCZ4OZ0O3J2t17ZV8RyUxpOpU+beMolgAwA=;
	b=zCcadZVxNjxS3ph11ZVt+XxohejzFkTtgi12kagOjHL3lmgR/zjj/sB5GdpJJgxnIy9f5U
	tJl5X7yNKdA57XmMYOYjWgA7sC7rjMco/vp3AkZ2MJJpvNk763HVqM11C0mYdogTEF/GdB
	SL/FwHpZFWmMAp4YLNNa7xEQfkzn+Qo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="h C44NQl";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=k3XJlKRf;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757934942; a=rsa-sha256;
	cv=none;
	b=HFO1ES4OWxh+EbzhvUbffy8xzAuMPD2loKlJ+FmB7cio+oCGq2RpVE6Rs+eSvC7GRY0vWa
	bxJftaCQDfGFutX+8EKzGmh6t8MDu44H6R12q1Ll6sVb+3fh8JfVICo11QdHmS37BhmW4A
	R+9UcGuH4QgoPT75UBbNVWPQwCI1r5Q=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 145651D00125;
	Mon, 15 Sep 2025 07:15:41 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 15 Sep 2025 07:15:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1757934940; x=
	1758021340; bh=IAndtAUsCCZ4OZ0O3J2t17ZV8RyUxpOpU+beMolgAwA=; b=h
	C44NQlcRgaO5C1gbFzTIB/cQATSaNmnUyYFHKP3zUvKw500CbP0GKAOHBsPanR8Z
	7BfVp1uc8BnszR7lz14CoV3NodQE5UGZrHdxHJZD/t6Hg/pJO5JFYAkdbPyGyWj0
	cNDmtpTzT0/O2qVzadbRtYr3Q068S7Y+6UGm6ayRKF7Q4APLDXg0/UB29lYPDjdW
	BRNPTyJq3B17H3enK5djdnZUEgOBWvz7m15yq0unGYru9fecqFfiuemoyzsQpLrH
	vYeDn9qCNTeKTOdOAMWHxyUKvPYRWynt2ElAVUSOniDqxEY6hJEQ0vYKEsr7foAd
	nqPTqDd3Gjo/fgfcEbVDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757934940; x=1758021340; bh=IAndtAUsCCZ4OZ0O3J2t17ZV8RyUxpOpU+b
	eMolgAwA=; b=k3XJlKRfvMlMnloZhUcGIiFOqwEzPSP3h96gDL9U0DdZUAoe7wA
	ds6pq+2umkMUVOVQPuR7P736pHGVkVHOrj6OU/TF4CfYlDWcbIE4E8Z/hUwICG2I
	CWJM8msxG+EDadSrb19BqHSWm0mI6tyaZsqq4nJkNyDhd3FjXkVmUZpXuy6pebX5
	jg+K/rzUH5acyxT2vtGrmcaH8/35Pz9S976F40/nLHMCgp7H7wAN5X5CRFqDc/Pq
	ArREyf4Cpqhkxi0VTck/8eWIsB/jHRVPGm1ehVZBNceMn3uL9vIXM75xaRfxlsLY
	aE+KAUxmQiX8N1zwA8BKFiBeQ2Lu2bwC/9w==
X-ME-Sender: <xms:W_XHaIiDK23ijgrb8XDIb1ol2dJAWnNIS7N-u-87wEwVtZGsG3VGhQ>
    <xme:W_XHaM5w0A3MlWeOJp6gvUrmAKoDDR3sN2vqvzhTplckPcs0xRHxnk8OFy5xG0pFX
    mRbAnsB1NVxO_1EONw>
X-ME-Received: <xmr:W_XHaI4s3TpC-L1ijhL35lCkJJPYGskiUisdFjnnMyyWhxNNzLcBqicB-WDSCg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdefjeehgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepvdeg
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopeguvghvrdhjrghinhesrghrmhdrtg
    homhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhg
    pdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtoheplhhorh
    gvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepiihihies
    nhhvihguihgrrdgtohhmpdhrtghpthhtohepsggrohhlihhnrdifrghngheslhhinhhugi
    drrghlihgsrggsrgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhr
    rggtlhgvrdgtohhmpdhrtghpthhtohepnhhprggthhgvsehrvgguhhgrthdrtghomhdprh
    gtphhtthhopehrhigrnhdrrhhosggvrhhtshesrghrmhdrtghomh
X-ME-Proxy: <xmx:W_XHaCHf48sToTGooULKQeoQMfXVYDFtvwqxTwsjhtuZkcYRDyiYYQ>
    <xmx:W_XHaOy4Mtreqw7ddoygYcWtbOAYX8rM5s-am4F-OBLk4FeBn4rGTw>
    <xmx:W_XHaK3qPesJv7xVvmvf16sMr-9pXxDUxoZLQldewGkCRN__H3bI2w>
    <xmx:W_XHaJOIUoAkR5WzlYktBzuHpb58CYeYtAclOrLSJMepA2xYoWCTuQ>
    <xmx:XPXHaNy3nS20Asj_b-1W3W2gegClHfquAwM2V7rlds2kCnZVaZyCxUMA>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Sep 2025 07:15:38 -0400 (EDT)
Date: Mon, 15 Sep 2025 12:15:36 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Dev Jain <dev.jain@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: Do not fail collapse_pte_mapped_thp() on
 SCAN_PMD_NULL
Message-ID: <3zfpaowb4owhpyseoiqj3vxo2e2nszynoun2ubsm2oqw67i6sr@hxtogb4t3npl>
References: <xhan2av3fyl7qpsl4bhjtds2zeegrl57ehtc5grtkua3c3v3nz@vain5s6gpycl>
 <a3ee891f-a025-4a71-8e7c-af5b52a8484f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3ee891f-a025-4a71-8e7c-af5b52a8484f@arm.com>
X-Rspamd-Queue-Id: 7F517140004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 4jk6cjbz1ytekbs164bzyq1daog3zenr
X-HE-Tag: 1757934942-891262
X-HE-Meta: U2FsdGVkX1+hi0GT/kGZR15qgzuCwbQKWDKjWaDgjN7vl6au905r5wnvBDkGnRn5rJsaq0shqmaxEm3qmBQ4vJ5P8Nj94U+GXHcsM2hZQV2A9SrxdOaT1v2dm+tfalXQo8oZTSBdBjq4zyOKU/IpnGXbNjSnhJpSvo+Ze7c3m2d0Pi+w89br76l+ta+fLdFaU1hl9YN9cd84+j0S0v8Yt5ikkdcVyFHU5TO3QhxAgA5EXFoCXpZ9LZbuDDGe9KI3yE3je0Jg3dWKnRwYQuNgUkFHyrFd1jyZOeR91818JYOE4hQmrqRFf29m+P3InsSw8bGUwFPku8UCAgub3ZC8d9Uz6UhEFiEHtOxoWfFJKcrhs3IviBtpPkPFhyTKjQvSi/aAt75M4mbz5sOVaJDnFC8UO3DaSE5EXWHpi80MDscp4xRnbL34z2Tgo+e2aGoga2iYKUObgZUh3Wf+TIXFkDBVMJJlH9DSFW5u05w6hEdUz6Dtneim3gsvKjLU2dVc6gXpBgEHjqPoS4M3X39vjwOl2Rh7nR935EVYoRefWSFf9mOlb85uWRMYoTDuJbZoiV+0cSDrmT7jDLFcdFyFCcG5xwLFaqmOhpvR24kNfDtjzfWEISfxqGTfkLNDRAmNqKubKiTx6MdW0oIUbjvvZQXFWGp1SE6o3w4uRb9FiLrT0qhGAjc3te1+fmGkw2n7M9MAe9DSm7BIIh06xjc+yzwebxWLE0hvcJhDG4sYbdu3YvrCij3RISAzcuyksUhTaHAkL9jF+Ad14TwffHg8YCFC6JFETJ0h+lS8ZOeUUxN3PFhhaReSz9Y+ZOuHHz+trdyvZHLxckH7Kk+OG9J0Vk1naakwwH6OutWh4u/7CpfCZKPt/gM0maH/RCMxNax7Rn2iA3ryZE0QK7mCZqWueDWaFFFgdYBAAD/byQN2sne+LUrj+fa81j24I3Gqx2GndnZQe2MpkhVgCWjq5Lt
 IxV9c6ZT
 YcUaeSnFvo7CZ36Jx9ewznm+7PMNVHlnbDLqF7zxc9VrGE8iyv+QMrfGoxoyJUaJMg1+9sHdgQ6TTCQ2NpSlmPoDBzG17vyNhiGG55S7MBcmO0ojJzJpOkJjLeGLLUloR1TG5pO5t+AsY0hM4gDR9JYxgwzDWsTvP8JZTtScZqgRHMwt1lZG6X8asxtzWCEvwx96ZiSseQlCpCXDQmLPMACEpaV5n0mkjiR5PBRpzqkVcXkIXzH+iCjd5eImpgJwtbkUGvCdiOBPX6Vqje9p/JlrmM1solGCom9yjytLYw2QE6Pm3v9XD3x2d7eA3uRY4IX7+7xueYnuyJMLaW7YsskoDPU28aWZ459b5BF13WZRvXJRa6l+bYk9/1Y02kr/AXT48FLWkKEBpzFfjKQfAlOhy2TdZdBcfo1L+hyGvprjL6jxVajVVJc5/BHEM5KyjcgX4kaponI/3UYR4t4YvAW4OnnDi8xpHxpkHqvNCePTeeUaeaZV1FCpKuzF0mD15x1Cz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 14, 2025 at 12:56:13PM +0530, Dev Jain wrote:
> 
> On 12/09/25 10:28 pm, Kiryl Shutsemau wrote:
> > From: Kiryl Shutsemau <kas@kernel.org>
> > 
> > MADV_COLLAPSE on a file mapping behaves inconsistently depending on if
> > PMD page table is installed or not.
> > 
> > Consider following example:
> > 
> > 	p = mmap(NULL, 2UL << 20, PROT_READ | PROT_WRITE,
> > 		 MAP_SHARED, fd, 0);
> > 	err = madvise(p, 2UL << 20, MADV_COLLAPSE);
> > 
> > fd is a populated tmpfs file.
> > 
> > The result depends on the address that the kernel returns on mmap().
> > If it is located in an existing PMD table, the madvise() will succeed.
> > However, if the table does not exist, it will fail with -EINVAL.
> > 
> > This occurs because find_pmd_or_thp_or_none() returns SCAN_PMD_NULL when
> > a page table is missing, which causes collapse_pte_mapped_thp() to fail.
> > 
> > SCAN_PMD_NULL and SCAN_PMD_NONE should be treated the same in
> > collapse_pte_mapped_thp(): install the PMD leaf entry and allocate page
> > tables as needed.
> 
> Thanks.
> 
> Besides this patch, the label maybe_install_pmd is misleading -
> SCAN_PMD_NONE means that the pmd table exists, just that the pmd
> entry is none, so the pmd is already installed.

That's never ending confusion between PTE/PMD/P?D entry and table.
Addressing it is out of scope of the patch :P

> Along with this,
> the argument bool install_pmd should likewise be install_huge_pmd.

Well, if you rename install_pmd to install_huge_pmd it will overshadow
the install_huge_pmd() function. And the label name is not a problem in
my view.

> 
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > ---
> >   mm/khugepaged.c | 25 ++++++++++++++++++++++++-
> >   1 file changed, 24 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index b486c1d19b2d..9e76a4f46df9 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1488,6 +1488,28 @@ static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
> >   	return SCAN_SUCCEED;
> >   }
> > +static int install_huge_pmd(struct vm_area_struct *vma, unsigned long haddr,
> > +			    pmd_t *pmd, struct folio *folio)
> > +{
> > +	struct mm_struct *mm = vma->vm_mm;
> > +	pgd_t *pgd;
> > +	p4d_t *p4d;
> > +	pud_t *pud;
> > +
> > +	pgd = pgd_offset(mm, haddr);
> > +	p4d = p4d_alloc(mm, pgd, haddr);
> > +	if (!p4d)
> > +		return SCAN_FAIL;
> > +	pud = pud_alloc(mm, p4d, haddr);
> > +	if (!pud)
> > +		return SCAN_FAIL;
> > +	pmd = pmd_alloc(mm, pud, haddr);
> > +	if (!pmd)
> > +		return SCAN_FAIL;
> > +
> > +	return set_huge_pmd(vma, haddr, pmd, folio, &folio->page);
> > +}
> > +
> 
> For the SCAN_PMD_NONE case, we are unconditionally traversing the pagetables
> now which is not needed. How about, in set_huge_pmd(), we pass a boolean install_pmd,
> and at the start of the function, call install_pmd() which will do the traversal
> and the pmd_alloc()? That will also make it crystal clear that in the SCAN_PMD_NULL
> case, we are first installing the PMD table and then setting it to huge. Right now
> the distinction between the two cases is not clear.

I just realized that my install_huge_pmd() doesn't use pmd that is pass
in. And looking at code again, I think it is better to integrate the
page table allocation directly into set_huge_pmd().

See the patch below. I will submit it as v2, if there's no objections.

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
  Kiryl Shutsemau / Kirill A. Shutemov

