Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA7EFCCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 14:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C22F8E007E; Mon,  3 Nov 2025 09:41:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 372C78E005A; Mon,  3 Nov 2025 09:41:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2613B8E007E; Mon,  3 Nov 2025 09:41:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 114488E005A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:41:11 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3A52C016D
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:41:10 +0000 (UTC)
X-FDA: 84069558300.10.385983C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id DF351C0003
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:41:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JDHYLNBZ;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762180869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yOIN4al8o3hvby2tYjmv7154iKKH2/FeWfWDeE8Z1b4=;
	b=fxwFTtoM9V1bCiuXffGSNDGCZkkxoGBI0oBTv5PPQGt+unk/nLgtsUBdjl2EBX9ocmNrLO
	AZNcxiU5Z+czt2Aw8JrTpKhXGNCxtgaeXVSOhHP10hO8gW5F1Yiyk5vgt8uU0JGx0vHeAH
	If6dD44CfnyhiYHV6lI6Ekl1SLwHH2U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JDHYLNBZ;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762180869; a=rsa-sha256;
	cv=none;
	b=oZzQIbh9yJS2Z7bnyaPckg4e6VosppNAeG4OPZHDSpKq5JvR5QHlMPIrqbl6l1DthtR/kl
	vHlvybQoJP+fbQPrArxrWCOuDcR3cBt99/9w3VXwHOuboq3C+e8bubPr9OZZfPFNJsSjBC
	o978fZ1ejjaTbFgRRopFwHsFB9gv5/o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 90856439B7;
	Mon,  3 Nov 2025 14:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5CFC113D0;
	Mon,  3 Nov 2025 14:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762180867;
	bh=LjFjByiv2udyhbpyhBMDGQWMK+5W1S4rpccn8+FhmMU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JDHYLNBZtzPaNXVho2kDaLiARfyfnqFPnf9nfQ6EhFuKJtSRiOUtDhjFgeY/WYmAn
	 2YcV9Ima4gdxz6cuzyeN28w4y8xpgk+5Ly7cWdY/OlR5ff6W4eurh8O+6DXGuBSCTW
	 S2j+eMw/HHoN8UL7L718UMmeUmCy2S1K6SNGIqjFwGOUwxvFrVtIZFe8DJ2URkyBhZ
	 Tb92uq2SfYTN5KbWc24raM66iJwD5mL5Ozm4oD0p0h/1rzNSg62ZSWCLuf2SZM+3FT
	 4Rf8uDV0VWwRxE0K2MzM9oTB1Qk0vatyWHOVZX3p8H2Pd1dWTH1NsaUfAqBYnjUKXv
	 7/Y3vSsYDIfPQ==
Message-ID: <79a1f2dd-6752-426c-84c1-a38d300eb78c@kernel.org>
Date: Mon, 3 Nov 2025 15:41:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: Initialise the tags of the huge zero
 folio
To: Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>,
 Aishwarya.TCV@arm.com
References: <20251031170133.280742-1-catalin.marinas@arm.com>
 <aQiu-hU3x5V5drHF@finisterre.sirena.org.uk> <aQi8dA_QpXM8XqrE@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aQi8dA_QpXM8XqrE@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DF351C0003
X-Stat-Signature: kxg5igxpf7r3roqbot4e6rh9shoaawdd
X-Rspam-User: 
X-HE-Tag: 1762180868-116457
X-HE-Meta: U2FsdGVkX1+F67WpmQSwm+26ALYygOm6skQ0tnJKCurDz6QXbBLaBwq4in7aUDvNVjisfibQ1V+Iw9QUWm6iwMpOj0h5aiHxn8Fc3SrR6x209zfMi3z4rWtRcE+P1iMpcFJqLXsK9mbU7WN9um6zAUB49OCy8tjhq0UgugotVJLeJ/boSPfcht5fdC7ZDLf8roBvgcRwIPhDMvfgEGYjuHK457D4KIOMjj1sjAEXhHeMfohu4U3l8c7euRZ8/ETpiop5+SeSvty3ySURpPdbWps05R45plgFxulOejXVGA4LQVXFbt2w3CCpQOyezfmuKpdL8C7L0QEdRHvk6KYDI7sNxK/AluRDtVB9dtUYVGoGEl9E3APQJYOzAgf0Kyo6dLxN9SVl2rJYzWJK21sbzUfp+qMtmj1Ms9fqiew8kgEKM8cUY0l2J7/b0Z9T9utHzKaUy7bNANFmtfDmhQDQPm1AyrpR46XeHckHR+OmujfK87jEtNSz2AnFII8+Fxt4MBsQIEJpKOgoQhQ83+kKsBLXjwpAvwwwhzkLLCYPhL2cowdRGK6jvBbLQIYDl/1r07MPxWDybJ1z27bOUIBPjmxXbwlvZy5qVbFuPRznX9CkXBPV8zpgyI6DSeLtfYQ269lpzVuYDWbpZjCeMAk6f7t0d3tY4DHATE8VxN9OzOT7xNBv5AhKmtEw2C6Y6+saqWQ/QyxTyRGOaMRWiHDunME/1mGWXhLakWDxdUc2KWjC+iMzFfjG9tNwAVD8AOfar1yJ8NQs2zkmp/yjBNgPtxCd+pEpdFZho+jODB2o59wvv+rDX4fVn5NA5jX6xMzh12lJMr1I1InkOxaFhbnS/lVcZrNIeDxA4b5BTv+6cbQSjVWdAK5d5YCz3qdaCeJGSM+O4uLPmMohdrWs5r+MiNyUSGoEsZdxMO0FBiA5KtNUD8Jj0vddtS7bKJ0YBbUo3rDGFttmZjhE7qME6Q9
 3rkKYmh+
 6r3vo4FxOphTr8OBHm8xa/3PDIiqNmuCvDHx2Cn5Wmb7VsczMPGdPhHlEXq8uBjunzWx8an7UT2vLlgJWofOqC4lHaXA3BnnIm9WBuHkk5XX+7nHHyMecMvDZJ0a6+5KRETI2O/+1DX6rRIDj/VvEmWRd/SRWBHLDgMy4uXFvUlK+vmEAEOPW3v4ZXBU114Sy3BZU0W0cjHFcx9cmGmbFwiJh23iwdLjgpSxYVtGRgbzfV6wprMaTtUUrsLKfguCkgaGAMerSFHWBweOSGyCmVxHyeGnKRkeREzUPfxAI7PSzHvSbdbF35X8Zgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> -----------8<---------------------------------------------
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index d816ff44faff..125dfa6c613b 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -969,6 +969,16 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
>   
>   void tag_clear_highpage(struct page *page)
>   {
> +	/*
> +	 * Check if MTE is supported and fall back to clear_highpage().
> +	 * get_huge_zero_folio() unconditionally passes __GFP_ZEROTAGS and
> +	 * post_alloc_hook() will invoke tag_clear_highpage().
> +	 */
> +	if (!system_supports_mte()) {
> +		clear_highpage(page);
> +		return;
> +	}
> +

LGTM!

-- 
Cheers

David


