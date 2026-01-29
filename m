Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06E97D73E83
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 18:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D956A6B0088; Thu, 29 Jan 2026 13:22:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D431A6B0089; Thu, 29 Jan 2026 13:22:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C45A76B008A; Thu, 29 Jan 2026 13:22:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B2FF76B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:22:35 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51DE9B7361
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 18:22:35 +0000 (UTC)
X-FDA: 84385821870.01.5A9A5AA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5CCC140007
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 18:22:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769710953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3INMSQtU8Wzky8Kr7Ft8lggZqVbamJ6pQ3F/X+7hSrs=;
	b=h8dq5iNCu9vFO88Md2zfJaWnylg4QILAsKSrB/Xnvwis2uMMopMmz7bLNpLhZLf2jDaENT
	Ng02wFbtPfieIqXj0dhlIUYpfoAwEOjucMVrcPE/oM2R8LSofNnHPauU3oAUv7oFHZJ+ZN
	VJ9eKJKF+6YDNElDKxGZkYDr/nqEAm0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769710953; a=rsa-sha256;
	cv=none;
	b=WRVwZT2K5IMBP9zCLL00wxd6KNzTa3LjYF5GjJTrDc4f1B6W9ezDj7BdbeNluN6R/DvHyq
	ip+WTsKAa6jxlilzBniwqDxv38xFZ+9NxUxZYCZATPth/N5+RZuFH9tfnpV4cWv/BS8jAy
	3T/BoS2DYnIAUaaYItMLUxeQEfP5buY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D45C2153B;
	Thu, 29 Jan 2026 10:22:25 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 772BB3F632;
	Thu, 29 Jan 2026 10:22:30 -0800 (PST)
Date: Thu, 29 Jan 2026 18:22:27 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, will@kernel.org,
	zengheng4@huawei.com, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, wangkefeng.wang@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] arm64: mm: fix pass user prot to ioremap_prot in
 generic_access_phys
Message-ID: <aXulY16Q16TYO06l@arm.com>
References: <20260127090129.412084-1-tujinjiang@huawei.com>
 <c78b76c5-8709-44d0-85c3-feccd41b2ddd@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c78b76c5-8709-44d0-85c3-feccd41b2ddd@huawei.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5CCC140007
X-Stat-Signature: uzxkhkg8ayrkto5pbhbhqh496uco3tdz
X-Rspam-User: 
X-HE-Tag: 1769710953-73229
X-HE-Meta: U2FsdGVkX1+0fSCiGRxm8+DPakeL3vRLlFMZB0U5f/y1mXXIbcpqpxP11FrTyvt8tKWsTlP5IBn6b83o3MXr973ulqSS5NqSl3We6nTtD8tcJOZ+hsntTwDqZSuqUml8nE5O7LzF6ig8ZKs363DBFUMxMWkZbNeHG4LYs9DDIigHZdhHU1ZpfrWRVcTgSvZmeHGUVL0zQ39NFMuYOSk/ECBA1raIVgRWnmvZWsbXxgKelkky9A9kK2wqIEqJSIpogGYdj2nkB34Iqeu0xWhzAIpjRMvXcHRF1GEJEhCW7jvKov6yq/7tS67shLlFNn8cDIEYsbiIBNdEYBFrDymVEE/2Upp4NVPyEsqbTumtzuDdG6dpkbwmfvOKwIoccx7JkaQPLphYK2vrZGG26b6JUp3v3Om0db/Fq0S4debD0dtZ0AK47T8f9Dht/h08R/ouIVTTCJQzVfJcECpgo4SPvcofBxICfAWFI8N8gUcN3VKducwKhWoO/gBqAk5Jswtn8Nac3Cgj/PBTANJn/8OQHsCPAir0TSMnnl1qm7VTW3Us2yNbx7o1Il/AQ3GgPg+bLmKxrO/wTIE3Vq9cPU1ZzYIL/uOQQm4LnBoeEtYcZ5c/I/WEH67ApYry9pENvWtZ4LypolccCXDjagxLJDaOpnyOqigNcWvXtShLTpa6EoOgwKlS7B5psuiprfphB2JS9cFwHxGSnPB5oAuEkkUuFt5EWiZshio5t1a5uNRx9unJcV2YdNA6sEHDlbok5zq1WHua8yR8t4JrkRI5eLVuQudeZ262QrQd8Ph1u9lSVulY1wzngPCht93IvejLU8u+/KjAb/02H93Ta4+u3pwAXixHnmsWT2ypTq6rTQCuHvq/0B0X1VsmPWWr8ui2Ykifw1lwyIJqjfuDFQQU9tArHX4jVgTQXDzhWegX9FVA8iIWGQUuqdQxQzEBMGxxMdT45wQ5++by5IqP7CLve63
 6mlWRtLm
 JMJ9KmD00Ad69opfWRDIDmePjwCQ9u+EOuchvQ4JakeAdOdLt9euzoozzgHYPQNrAIepa3q0jpyYrd8oxmdquFqKX4SmMENFq5e/dlw53SF2ebyxG3H96VC9DH1jlffSePV5oGj/uolFzMEg3knHvs0m+qcyYZdM0zvg/h2HKoj348rrDCeUPlcOjeSNGdfCXq8VOLJ4WGoKi5SMm0msUDF+Lqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 03:12:56PM +0800, Jinjiang Tu wrote:
> 在 2026/1/27 17:01, Jinjiang Tu 写道:
> > diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> > index 83e03abbb2ca..fe8607eafab6 100644
> > --- a/arch/arm64/include/asm/io.h
> > +++ b/arch/arm64/include/asm/io.h
> > @@ -267,6 +267,17 @@ int arm64_ioremap_prot_hook_register(const ioremap_prot_hook_t hook);
> >   #define ioremap_prot ioremap_prot
> > +#define arch_mk_kernel_prot arch_mk_kernel_prot
> > +static inline pgprot_t arch_mk_kernel_prot(pgprot_t user_prot)
> > +{
> > +	unsigned long kernel_prot_val;
> > +
> > +	kernel_prot_val = _PAGE_KERNEL & ~(PTE_WRITE | PTE_ATTRINDX_MASK);
> > +	kernel_prot_val |= pgprot_val(user_prot) & (PTE_WRITE | PTE_ATTRINDX_MASK);
> > +
> > +	return __pgprot(kernel_prot_val);
> > +}
> 
> I found I misunderstand the READ/WRITE permisson here.
> If the pte is writeale, the PTE_WRITE is 1, and PTE_RDONLY means dirty or not (With DBM).
> If the pte is read-only, the PTE_WRITE is 0, and PTE_RDONLY is 1.
> 
> Since generic_access_phys() have checked if the user can write with:
> 
> 		if ((write & FOLL_WRITE) && !pte_write(pte))
> 		return -EINVAL;
> 
> So, maybe we could always grant writable permission, just as x86's ioremap() does?

Yes, it gets tricky with the dirty/writeable bits and we may change this
in the future. We have follow_pfnmap_start() already checking the
permissions, so going for read/write access for the kernel mapping I
think makes sense. Just do something like:

	ptdesc_t mem_type = pgprot_val(user_prot) & PTE_ATTRINDX_MASK;

	return __pgprot_modify(PAGE_KERNEL, PTE_ATTRINDX_MASK, mem_type);

-- 
Catalin

