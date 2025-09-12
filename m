Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FF9BCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 16:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600C18E0007; Fri, 12 Sep 2025 12:58:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D7148E0002; Fri, 12 Sep 2025 12:58:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 513858E0007; Fri, 12 Sep 2025 12:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 415858E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:58:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E241216089C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:58:18 +0000 (UTC)
X-FDA: 83881206276.25.BF303B2
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	by imf11.hostedemail.com (Postfix) with ESMTP id F09B440012
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:58:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=WXSLXHFz;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="B 3qsl0q";
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757696297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=upnrRYU6bn+uBt1fGKw3p6hAlWqFSwlxqJgEcP0xUEk=;
	b=8q48jCHAxfS8ph7AMV0EbOv89aUR7I3+91Wlm7huUbyyem1cPbcuVaCKp1UajRTDI3006o
	rcqNjfbUS8Yx8viV+CzvCw8QAoLKfjFIyoOrAqioCu7Lcv3V+mE/SvLOqzJf4nRxQGahAr
	gQtrZ2HLiqdjjN/yTfcHtNfarp3tSjw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=WXSLXHFz;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="B 3qsl0q";
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757696297; a=rsa-sha256;
	cv=none;
	b=w5xl8GqPwmxt1UzI2BiJc6gsjLrUgbI2vG3cxN/0qvvwkhc0DPmux9m4e21hPdAFJtf5r0
	eO4ECbVe3yiGAh+qld7c7hzFWtWLqZrG6oLf8Ssc+rjaLns0q0nfyALueUNlqAda5u54iu
	uqpxXxAN26r4nX06I4l1Y+gVcOMXaI4=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 8144F7A0145;
	Fri, 12 Sep 2025 12:58:15 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 12 Sep 2025 12:58:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1757696295; x=1757782695; bh=upnrRYU6bn+uBt1fGKw3p
	6hAlWqFSwlxqJgEcP0xUEk=; b=WXSLXHFz4Eg996BrG1TuO+hDbfjJsr5zmoaMu
	4OG24FCJ9ws3ZSuDRzFvBHNPzBwCqmyd6fUX1rkPLyD8jw2uMAxfHqDCg9+7pYXA
	1iePl57kOXkQUWHHq/VIX92Vakl5iGOsHmuVrZ0JeVQYsPOy4aSKfTuYHZlSpwrA
	hK/UNdCWxPr3WZwaFgFwkBaCLqOZHp56L0/oHzH53LqFha/yT0IpL5r4xZJrFt2e
	YiZt3/kVWJF1srsaWHf89AA6pQ/I1Spzzju+bLTyV60SfFIHjJKxrBvIXtFNCkAH
	2by37mMKosUtefuW02l3H5ZiQdj0SOYLRMJAnMo3TyARbh7FA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:message-id
	:mime-version:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1757696295; x=
	1757782695; bh=upnrRYU6bn+uBt1fGKw3p6hAlWqFSwlxqJgEcP0xUEk=; b=B
	3qsl0q33858qadPEzFXWKzd5k4TXP/gBqZ3s8rEIHdzjP6YegAEsgxiTNWec9RUa
	PMd85Zr7oXvzKNibN8A5jG1VlRLLagP9wbhRDxoOLjZAsHlm97Blkbj+l3BMgoNE
	VnUoZvvy0rin6xkHKLhyiZz97B7NyDjSesBWBDga8jpOn0R8h4BHYWL05GDDpORo
	jSzpDNl/Oam3+DDU9cynoUvHHs9jkC44T9cF89HeOBfRVuOhatCvmd6wJW48s8EY
	GQ2PvRryCEiMRwm/9OdhuE9cfDzLh+1NlJMEhLJNeO3Wt6wxfRh/L4Ym/PHLAfno
	m3KZeWpYHnghmOMEIKtWA==
X-ME-Sender: <xms:JlHEaNiLR-LMVhcfewzkaoYUsYkFo79QWAm1g7hsGxUzjqpfTIh-Gg>
    <xme:JlHEaN7a9yO4-00uoqEMsCOZ6VHt_0D7BNNgo71j4A1CsI9rYMVbH_mA_ZNtuFM42
    aK1EDjCvm7ryNQIWPI>
X-ME-Received: <xmr:JlHEaF61r7mHUYPFQXYPtDUEx0azbEjJLgVQRZQZ2oTcZ22DGkLvCoyLHryLuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvleehlecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:JlHEaLH_MnLrv7K_tzBlUdSsVroMe6YE7s7287G-Zcfpv6MlO0nmuA>
    <xmx:JlHEaDz25KXMEbRbN-HWsHgrLN68RP6YZhKZj7nG0ufAmcuNxfJsIg>
    <xmx:JlHEaL3l966TxlLzY-b_JuezyIin1hBw8MX8fl054bTs7xw56rhJ0Q>
    <xmx:JlHEaGPO0kAiiQsM5xbntXTe-uBltdCOx8_lNhFeL86bhh9lNbEebA>
    <xmx:J1HEaP0hCnFIs3xOnKUjvL3hHeaPCEad_K-hwv5brwN7MqostgwHUt6A>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 12 Sep 2025 12:58:13 -0400 (EDT)
Date: Fri, 12 Sep 2025 17:58:11 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm/khugepaged: Do not fail collapse_pte_mapped_thp() on
 SCAN_PMD_NULL
Message-ID: <xhan2av3fyl7qpsl4bhjtds2zeegrl57ehtc5grtkua3c3v3nz@vain5s6gpycl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: b55dymf7rxgqe7szpo6udsm6tizn6scw
X-Rspam-User: 
X-Rspamd-Queue-Id: F09B440012
X-Rspamd-Server: rspam04
X-HE-Tag: 1757696296-672435
X-HE-Meta: U2FsdGVkX1+kxNqIBkmtTtuxGnyIzI45GYsiUV6ry9bMKgCeJ2PrlEuxYjdxtnS3Ew/GlItLqUEz10UxYUWbVBfOSHG+FdJ8UBH1lU4ZQkg6PZmKwKALBY9yIt0+0P74VQeIknZAaRpHZ11eOtQFLyEgNtoyKNAXK2yOqRjLxENX0yFimOeNSmrfoE3vGGNSK5CaX/R55CnLGt8GKc6V8bRQepF3rOoBSaqOiJK/agL945Gyt5gUpx2we26KM3Mq+FxiZkC8lI4OfG11hPGGT8+/vLuaW8tlRA9ddTItqrMHVcUIdASUBPCPhFahh1+S9mVoao428GQoY/19fog2xzc1WZJDkS5BPm6wIc1vYVvkQZxlOQ7FcyQBxOSTYwqx5AnseecnpbuVIfDQskU363nIBUV9wF19kmRu2xQQiEdWbvdy/f4NdXzzmRyOf0d9ZKHCVlNXQpvw7sf5SJX8SSOMj5Ld60LZh+/ZKZk87faVFh8qxzA3xrZQ9vicL0t4dnS3m5Fb0C4rIegb298S28sLNrXzqLGoRj7sQKWvCSTIKmCQTTfLrCir61bVgWqFpOZ4OXB5vYf24xiVzuLPFxtEU6PjklKKFEV0OknkgWT9DnoUN8lbrcfc0psfD0PrDPXCSHtihj8rOPQcDeec3I4uKBaekBl9lueNhnVs6r0t603idgpopO6wsfWvK2mSjq5fgMEznWdkLsWoHcVu2T/kQEdDjCPTot+eEC21O3uqwOXsgsQYUJDUWI08MdnFMSPVQlik4pfZ4XIhisFXhVQ2irAOCCl6MQ8PDhEbRzJBclUhFjCodTxzCwuHtxpM4/N+4LHvzZHeCU+y/b/Vdr3pAxUxEWAayhvhODt348grf7ZLE6DBDWCyo5e2VoYoo74ycjC6H5ICso0KJZ7bN7nsRSum8kiXjxQTPGRtzswo1LjX03kyAbCIhazkFW2Dt8o28+9A0xslK2k0cO6
 ZQ7i+pS3
 O0PCLt34+0g2PZSNJlu7qNvRs2/FOnFRobiBylJdUGSO/7nxvKHglIf0ptsksBxMcMcrFnmRy/Ep6hs9QX3QKWrJ5qhj4bmo6qVGuwOSjemTDD5cKXeXm4jS+fFum1Gvfpd+maIO3mPPuje6ZY72+Vnk+iLTIVknfwOXtuji0GNwpKdXjEY1Msnm2+nbNgP6NMFq0Lil5mV0JMGiRSeWexzru0nSRp/gNyybRY4cnF345j9UCtZhivMVFbJ/ULYZ/N7XdHMijrJZRa8y+44gar0SDTwftQcFJ26wqJzDaeMXBOgS3QhmNfep+h2lR7CkpwM0iDtiT/y+rsZFbJpEDBGVJ+KkecGTHsZkv0uxSkSN2N/F4jidvFulG7gsyrIgJQ3u4lSErdrbjnrKx8R65AVR61/DyjthzJx7ExzsTAWcDeSiDqFGaqDPI3rgDvovefXfE8yKEf1y8eM6ZIDn3XO8rxKmJ6a5rtZlWKN5L/ftg5yj6frYHe7vVMrSoDSp8pJbO
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
 mm/khugepaged.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b486c1d19b2d..9e76a4f46df9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1488,6 +1488,28 @@ static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
 	return SCAN_SUCCEED;
 }
 
+static int install_huge_pmd(struct vm_area_struct *vma, unsigned long haddr,
+			    pmd_t *pmd, struct folio *folio)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+
+	pgd = pgd_offset(mm, haddr);
+	p4d = p4d_alloc(mm, pgd, haddr);
+	if (!p4d)
+		return SCAN_FAIL;
+	pud = pud_alloc(mm, p4d, haddr);
+	if (!pud)
+		return SCAN_FAIL;
+	pmd = pmd_alloc(mm, pud, haddr);
+	if (!pmd)
+		return SCAN_FAIL;
+
+	return set_huge_pmd(vma, haddr, pmd, folio, &folio->page);
+}
+
 /**
  * collapse_pte_mapped_thp - Try to collapse a pte-mapped THP for mm at
  * address haddr.
@@ -1556,6 +1578,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	switch (result) {
 	case SCAN_SUCCEED:
 		break;
+	case SCAN_PMD_NULL:
 	case SCAN_PMD_NONE:
 		/*
 		 * All pte entries have been removed and pmd cleared.
@@ -1700,7 +1723,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 maybe_install_pmd:
 	/* step 5: install pmd entry */
 	result = install_pmd
-			? set_huge_pmd(vma, haddr, pmd, folio, &folio->page)
+			? install_huge_pmd(vma, haddr, pmd, folio)
 			: SCAN_SUCCEED;
 	goto drop_folio;
 abort:
-- 
2.50.1

