Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C12DCC9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 14:21:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF1926B0088; Tue, 29 Sep 2026 10:21:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA2D06B0095; Tue, 29 Sep 2026 10:21:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A43366B0096; Tue, 29 Sep 2026 10:21:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 745766B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:21:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 011F9120507
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:21:43 +0000 (UTC)
X-FDA: 85267013328.12.737AF8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4DCCF40011
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:21:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ik499Jek;
	spf=pass (imf17.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790691702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1reho69nUF+kdSehk4siYojJssv+Dw0ygWX/hVVwBmc=;
	b=embMaF2/tHlm0DxspssNsqp5bGfJWfLDAqbVGWscGF1AQhiEiBAdKkErsWjDQ2JWTNlm31
	GJC/5ahEVA9pGh6LCjwS5WG8luDmf6Ej1DbHOhZNvM8y+okeomRVKntMnzGUIr0J5+/L3L
	P8xBkeAnTzztejtwp1mXcQyJUc9Dcq8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790691702;
	b=ZAVQ0Fbb8G/F860LHOkTq52Wn2OzclzwHDQYpySXfthhB4jeRKNVY5bSJU4jbSWjZiIqVv
	kzBdQUPQpLDl7FpkXM+kROWO2EUHH6vfLN0gX95xDvIlDLmNZJdDOForz4GJ2a1pjSN3yJ
	cfLH5byAjslt2TPEeJMpI6gNbuxORSo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ik499Jek;
	spf=pass (imf17.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F3844403F;
	Tue, 29 Sep 2026 14:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3271F000FF;
	Tue, 29 Sep 2026 14:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790691701;
	bh=1reho69nUF+kdSehk4siYojJssv+Dw0ygWX/hVVwBmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ik499Jek/zqilrnYYC+EvqJwQBrSy6MYHjOwwTEhZvk9cxhOU0fVBL1jzHil2Ctmk
	 ZXANQlTwLWcQH4Z7CBSf51lnzpoxWZkVRymSm3AR1zv6S4/kSruSIZ0aoJgnPd03Mg
	 /sJOzDQo0hjKnq0dLUaQCleH+y6GnvJBa3YDHfMXWVncN/3Q63uEaYc49tssjC9MV4
	 YrlGfnqNOQ1PA6Igd2zHZxrJ3MOr4XEbTsCqqlnRCK3S3rReRRbnsM78yR3gOeAiNk
	 zzFE8erNTYp4rT9ItW9xbeljW1+o9Q4cNoPSAweosy34U2S6OnBIn2I7Nbd/ZmO+rl
	 nKhYg9U4pW7Lg==
Date: Tue, 29 Sep 2026 15:21:33 +0100
From: Will Deacon <will@kernel.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	usama.arif@linux.dev, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	kas@kernel.org, rppt@kernel.org, catalin.marinas@arm.com,
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	luto@kernel.org, peterz@infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/3] arm64/mm: add set_direct_map_ro()
Message-ID: <arvJbQmr9GwToA8R@willie-the-truck>
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-3-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901151818.3191443-3-xueyuan.chen21@gmail.com>
X-Rspam-User: 
X-Stat-Signature: nsmh755zejjabjkdazbx44kkmjq54wr9
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4DCCF40011
X-HE-Tag: 1790691702-114403
X-HE-Meta: U2FsdGVkX1+6dpmnWA8v9w6M8Uo1DrNEv7OcM4KS3vnntG6wkj5cchi9lfOmQlfalQFtCjGFwlqjspK+AFwP/IqTCVPFhpEhmruM7h+4aVj5rGTAivYIbW5qRQW3p4NhsM0TvcDnDkFvcOoX+8fFbGDrOMz+cvXf6ydlXRs7vueCbe+A9q1AYm+TpyQwtpFr+QzWrnCttpbOD4TCSzVVd3rGbtSNuAqM/8lstqm7/yoCBs0zlk04E8reiB96mKE0OB5Fmf2cdRICvU0O4Z+4ZbGHWS15chwjTdSLdTm7YY3pTfa9J332m5rC+dAYhz0cOuESXufSka8JHgg2m+PTT6p7NKH7q+35TtgsuiGcG2e62wDXwgP52zVEC62fdP2/YDQ4j3Z5a7OaGlTUSt+Q7c91C8gI34ISD2CXlihrh7ZD9/ksL77o3d5wRDxDdRYp0R+DZG0230zG0Ry+CQPXHg499wsBdw3+Q3/fPITgCLAQUSpu/OCA8BfldVf5lg4yYhzhr+il2jmIZQEf4y6t7lXVomJeGTrweOZmYxZu510OlMc0+UEf6qBTMb3faSFvzKUmrVOE3xmwcgUJnKNBmB/l3FxudhJIra/8Rs4kkyu+g8hirhkafINVoya/Xw0har7Ey7HrCr5UT/OVkhK6okSYzvDYKqmbo3+wusOUAR+sq+2O4CAjhniVWksg+kVNTe8/Z+rSlEB3pOudx/hlbL7NdLSLMwX6AM6H8x/a+7UEwmh4CTTaR7RTu4Y8XoRjWRBOuqUIEgtZJBPCtFsTRKxK3Wrxip2kijSkJ82frKM2J3Ha9doyAS8SqyxQ1F3mLWxFjqMc5S7BusHTWI8HZ92xMHmk8fHzbVyZMgpqrOdXFB0qOO0Yg5QEzAx0YAaSp73UxVYASXdT8S5YjtrgPyPejSGihaHNKudoVbypXkn27aEiqDCOIZqNiDgC1tg0jfbGlhu7iURcNZfnoVA
 AqX2CsxM
 c9WgT/qzwtZru34tqKpELMGmaiuntxMgSPlkwLaoxLwSzM85gIW67Pw+O87t79fwXJIRET/Nqa3eod1pLrt0wWowOEpiMF6SaXERZzAFMM8ybh3MfUU60r4KswBohN1XA5ZRMjrSlVl/e5Wf7fsNeG7Rtpv49FyPrJreNubcRYzWmvoffRf0VUCs3yEYSr9lkYmIb3sVqB3pGk339Fh6fLoF/hhuMh6PRxLTHf+M13OOPbCIQ8O9P/a65r9T+N48lhxStqaHUpVwlGvsSYxPQLRi2u6XccAo0Uaa1ewRPsly0LbNAxoNox28Qk/faOzS2Sxuhas+ZRRoDd1MkfLRNswRO4xz9F2ZK00h2shlzJAJa2sziQ6RHjZBHJS7iHcmmDSsoaXBH+xhCWvfiYFvpL1SBoPmJDiR9pjAGLlLwTZdzeVI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 11:18:17PM +0800, Xueyuan Chen wrote:
> Implement set_direct_map_ro() for arm64 and flush the TLB internally.
> 
> Co-developed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  arch/arm64/include/asm/set_memory.h |  2 ++
>  arch/arm64/mm/pageattr.c            | 12 ++++++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
> index 0091ba12200e..1be86dc11543 100644
> --- a/arch/arm64/include/asm/set_memory.h
> +++ b/arch/arm64/include/asm/set_memory.h
> @@ -13,6 +13,8 @@ int set_memory_valid(unsigned long addr, int numpages, int enable);
>  
>  int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages);
>  int set_direct_map_default_noflush(struct page *page, unsigned int numpages);
> +int set_direct_map_ro(struct page *page, unsigned int nr);
> +#define set_direct_map_ro set_direct_map_ro
>  bool kernel_page_present(struct page *page);
>  
>  int set_memory_encrypted(unsigned long addr, int numpages);
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index 132938b32eb1..0e95cd904ccb 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -355,6 +355,18 @@ int realm_register_memory_enc_ops(void)
>  	return arm64_mem_crypt_ops_register(&realm_crypt_ops);
>  }
>  
> +int set_direct_map_ro(struct page *page, unsigned int nr)
> +{
> +	unsigned long addr = (unsigned long)page_address(page);
> +
> +	if (!can_set_direct_map())
> +		return 0;
> +
> +	return __change_memory_common(addr, PAGE_SIZE * nr,
> +				      __pgprot(PTE_RDONLY),
> +				      __pgprot(PTE_WRITE));
> +}

I haven't quite followed whether or not you intend to send a v8
making set_memory_ro() handle linear addresses, but fwiw the
implementation you have here at least looks correct to me, so:

Acked-by: Will Deacon <will@kernel.org>

Will

