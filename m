Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C19DCAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 10:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5AE68E0008; Wed, 24 Sep 2025 06:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E327C8E0001; Wed, 24 Sep 2025 06:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D48148E0008; Wed, 24 Sep 2025 06:10:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C06258E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:10:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85D9511AD04
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:10:54 +0000 (UTC)
X-FDA: 83923725228.29.6FE7BC7
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8E72940009
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:10:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="d m4/F7f";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="JWM+b5/M";
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758708652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RGmbEfPLISQO1ROGSU6HyBBqnTTSfiwWmowUcjVsqq8=;
	b=bAAnfYMZznZFtBfF4qKGLEDC9Kz3qeTLrtk884Eb9MyAj3vV+Bfu+p133TLI00iInGjWMF
	w56zFRav1xnTg5HWLANZ3qpkfVSwnZXcT30qqB/sQtMFP0Y2z/oNWB47oOOusBD+Ua8HNq
	qhMN479ysyNlMsQlLWdL77HwZ1lfU1g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="d m4/F7f";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="JWM+b5/M";
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758708652; a=rsa-sha256;
	cv=none;
	b=HbCI+0z5k+D/fgPZmZcJrxyxXbtIMRSgElHCIFk8akaqD1b7asb00h6D9EwJ1HyIxDuRNX
	1mrKhjcorn/NmoniEKTGNYdJR250FTZKPTA1yA+1JIF6Mwq50eIipFS1B3nLsqTaohb9go
	uOn2hFgjXiEJWdzdonH9mmxmaYBJsyM=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.phl.internal (Postfix) with ESMTP id EA6A4EC00DC;
	Wed, 24 Sep 2025 06:10:51 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Wed, 24 Sep 2025 06:10:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758708651; x=
	1758795051; bh=RGmbEfPLISQO1ROGSU6HyBBqnTTSfiwWmowUcjVsqq8=; b=d
	m4/F7fczegdaq+vfCrcSLI6RlWak04aro4o4pJ3hHd7g8cWhkuFqIB5PJ7J3WuZG
	d98CpWhzWhJv/a1OPwljvPNpxKRDftvD+0mp4IELvxnD0TRw/mFD75yLPxHUwscP
	Ep5i5J3eNUBAdhPPJrVbItgllVeGWF4nCCGTjnT/gA/EPmC4/ELd8MjtHYupzI6p
	klPtlif59E6CuJ3Jhlz7yn34vB0y/oWmHpCoYxY1qALZdmzPk3rAiQsE4UW6rLJk
	UyHpvbkWPxUusAwDMxq/uMkqBU8KwAjOvu3JUlwMosLHuPm2bPrYy/evWmxpJq00
	IKMwHmUiiaUWzb3n8sZDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758708651; x=1758795051; bh=RGmbEfPLISQO1ROGSU6HyBBqnTTSfiwWmow
	UcjVsqq8=; b=JWM+b5/M7h6Ub6hNdu3gxmqIC1jTjwy77kKd8HlRY+jh9V02Xi6
	HtsGCAppxRudZx0XcT0MvGK9oTriaej7yT+Aq8zPigeYTzmr4lfQ/a6gNa27j+9d
	Lr4+waJvH0y1QVW9TJkOnpblfU7e27FE528Psafy6PhVq6QAYzS67jGilC2HNxLR
	2iLDONJGkamek+aJm+aB63wds5ZMCMGcNi5zHO+k3wfLmgrBYtfIv5Tc08wvMBf+
	r5G8Kdl1vsdXcP4uzgD3DRDT+NFd+W5mcsq3lHokalOmDwWhd01P2+8IeyXi0AHX
	IncKYmVprmphpqYBgrvY7XYBiAfvHdOsbLg==
X-ME-Sender: <xms:q8PTaP05_tH9GEeC4Ax089W-Of2D0GX4sXrfQd_7LLIFLarx9ojLNA>
    <xme:q8PTaI6QzHu1f_ZOgDLyaGZM-koNOz8hinxNLKTDR1wKx4Z_WRxrfZ8cf-RSONCph
    mPPaztdMjpotwTXndl47r3XZAJHVeB3oSMkOMvo2lg06fMv18Egc28>
X-ME-Received: <xmr:q8PTaOLsCLn0Rq2WKnR6esW9mrFe0vTgH82W9dR7mPth1xgqkcwcaUXXjZfMPg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeifeefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeegfeehleevvdetffeluefftdffledvgfetheegieevtefgfefhieej
    heevkeeigeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhho
    vhdrnhgrmhgvpdhnsggprhgtphhtthhopeefgedpmhhouggvpehsmhhtphhouhhtpdhrtg
    hpthhtoheplhgrnhgtvgdrhigrnhhgsehlihhnuhigrdguvghvpdhrtghpthhtoheprghk
    phhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegurghvih
    gusehrvgguhhgrthdrtghomhdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghs
    sehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrg
    gtlhgvrdgtohhmpdhrtghpthhtohepsggrohhhuhgrsehkvghrnhgvlhdrohhrghdprhgt
    phhtthhopegsrgholhhinhdrfigrnhhgsehlihhnuhigrdgrlhhisggrsggrrdgtohhmpd
    hrtghpthhtohepuggvvhdrjhgrihhnsegrrhhmrdgtohhmpdhrtghpthhtohephhhughhh
    ugesghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:q8PTaEag3zPU9hQMoBWhbUQZ89gEjo6Go8GwG7QjAThN_A1ICvso3g>
    <xmx:q8PTaL2iTViXiU4WYpxe1CnvT4Z2ANjqZY-cnk5FqAJPqnysncGCpw>
    <xmx:q8PTaGNjXlDh0nPGzxmbcu8MyJukPRXFS-4jdmc90tBdUNWCoi1Xqw>
    <xmx:q8PTaFJfFDzdPe5bf7FlyljS49nOT-ZiC1_1OZ8GDZl9AXb2FLPWmg>
    <xmx:q8PTaC2_7J6WWMxSNIY78I4T6f58eWFlPPmxuGXg4kHJb2tPhxqQvql8>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 24 Sep 2025 06:10:50 -0400 (EDT)
Date: Wed, 24 Sep 2025 11:10:49 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com, ioworker0@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mpenttil@redhat.com, npache@redhat.com, 
	ryan.roberts@arm.com, ziy@nvidia.com, richard.weiyang@gmail.com
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Message-ID: <bhkr4y5h2d254ba7eopsb44tqwdvb2h2ddfhwjjho7twomaqk7@4nqik57oxw3e>
References: <20250924100207.28332-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924100207.28332-1-lance.yang@linux.dev>
X-Stat-Signature: 985wh8mcxwezd7eq6gei41du6yh1jfhn
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E72940009
X-Rspamd-Server: rspam04
X-HE-Tag: 1758708652-319780
X-HE-Meta: U2FsdGVkX19aNmzLmYwU92TFm/o/hC7pqVJNfiXhYn58VZn4w09jNI2JVllCnqpHi3eViZnMtc+9+E9skBnD+NVlClAeKPaet1oY7hjwFBqEFcJXerqGkyMyEiRwBeK9ySf5pYQgCCdByTLRqV7M52mhYBC+k8v8d8dFbIdOb8T+u7UfmNUhudqzQkjjkmLCGqgyP1IzHclbe78wXcQxj9DdnGyhiwoub1e7gU4gxJe/PXAaPNdyWkMwyM9C8idwKV8iwWi8ZIT0gS/adrKPswNzEYaGTzXcrVLqSBDp/3jhnZxI4bboWbXo7IhIDg/xf4xILHw2SYHYnQ3yuB6tc1a76DRthVS8dsRZMYTWlH2uYJMC5aNbHLvG+IKKB2lSkK0AM6fztx8rZmDC0hhZ3Nz7xkiyt9ZHm1Hlo2lZe+WERQCHy8ta22VblciBLUrWMfApKDiZ2dQqmGsdlQ73Uznx+2Ctg/nh3G1PgbMQLN1A0KIIeRmOZzlfGeyATqcGeLpWQSo5FWt8YhGkm0El96sa3eeUlJmVhiDWt9QEdzOdRSPihftvvV4MrI7j/bQ+SJ98THP2cjlpZf866kfCP/G8QNSmZRA2yqcmBXMyR6XcQqGgMhRf/dOdLyRL7Pf8jokdeODKoaiFJhCR6mI8xygdJ/cNPyZ0HPSTg7xMux20Yxj6z5M05h2tXIstQy1E+TS+tw9bHPexBSUkIZybTzQYExhnYvNXc6swNC54EejaQ3PChsqS0xleeIRuIQ9ryhW8TFnHfXHVj2ryDNhAXYzyuPWggbpLd94BLmmJZ4KI98DVsR13gVh6jsa9Gae5UVSMfeCAyfn8ctBmPT2w5ewmA0SRcGrLmEcm0nXDcIN+MeZ18hQvc8coj32FeAT7T+9phjaSflD7GaQU1P2+BxwyKU119e3rkoWuyatM5Tv+XYL6yG7kLQ7YznxARWjAOAqyMSvk32JMzxSUNMc
 9P4OvWje
 czbt4YdqxG42wEAFV9a7sK8KduPWw5nQQdsgEyr6JGGlSXT4qS+5zH5fFYOjqXLFEPuAhVjr0xbQuNNnj+YuF+EDO4E15SCsHCHvkk9Fj9ZTHYop5f2fqaI+F3z868BqnJTNXgk+ecP5ifWfL01NOclQikcLMyFSsCXFDU4wvYkWudUS8fNhvsIh8tq3bF21heEZB/Yt7DeMyEioA1+l8lsuJ44sj0rBEASvQycfRKrXV6+QBhHLD/ZmBEezXNGuw2CvZqvVna4T2tRnasSXdJHOEVy59DzaDZUBCn3ZGiqEVDo0Z+VLy2uVI8eRSs3+n2xNdMKxj9oUJSaQFMaO5JsQY5sknYRmfq+X47jOJg0Bt5NSwdXq1RKPcDP1LpeUA2VP1TwZbPvtIxhXqwaaZXaYZ1tj6Z6d6UJXvBuWMJKEn0z0x+4Irs4S24iQrYi3aC82SdM8JbUwUoI94QDTDY7LJtfPI89/ZqoxoTU1RRjwppDnKRHQA4yOq5yOP6EIl4+t/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 06:02:07PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> The existing check in hpage_collapse_scan_pmd() is specific to uffd-wp
> markers. Other special markers (e.g., GUARD, POISONED) would not be caught
> early, leading to failures deeper in the swap-in logic.
> 
> hpage_collapse_scan_pmd()
>  `- collapse_huge_page()
>      `- __collapse_huge_page_swapin() -> fails!
> 
> As David suggested[1], this patch skips any such non-swap entries early.
> If a special marker is found, the scan is aborted immediately with the
> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
> work.
> 
> [1] https://lore.kernel.org/linux-mm/7840f68e-7580-42cb-a7c8-1ba64fd6df69@redhat.com
> [2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>  mm/khugepaged.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 7ab2d1a42df3..e9778e7734b5 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1285,16 +1285,19 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  	     _pte++, addr += PAGE_SIZE) {
>  		pte_t pteval = ptep_get(_pte);
>  		if (is_swap_pte(pteval)) {
> +			swp_entry_t swp = pte_to_swp_entry(pteval);
>  			++unmapped;
>  			if (!cc->is_khugepaged ||
>  			    unmapped <= khugepaged_max_ptes_swap) {
>  				/*
> -				 * Always be strict with uffd-wp
> -				 * enabled swap entries.  Please see
> -				 * comment below for pte_uffd_wp().
> +				 * Always be strict with PTE markers, which are
> +				 * special non-swap entries (e.g., for UFFD_WP,
> +				 * POISONED, GUARD). We cannot collapse over
> +				 * them, so just abort the scan here.
>  				 */
> -				if (pte_swp_uffd_wp_any(pteval)) {
> -					result = SCAN_PTE_UFFD_WP;
> +				if (is_pte_marker_entry(swp) &&
> +				    pte_marker_get(swp)) {

Hm. Can we have a marker that have zero pte_marker_get()?

> +					result = SCAN_PTE_NON_PRESENT;
>  					goto out_unmap;
>  				}
>  				continue;
> -- 
> 2.49.0
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

