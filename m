Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FA67CCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A7176B0088; Wed, 29 Apr 2026 09:57:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87ED76B0093; Wed, 29 Apr 2026 09:57:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BBB06B0095; Wed, 29 Apr 2026 09:57:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B79D6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:57:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1965F1A02B2
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:57:10 +0000 (UTC)
X-FDA: 84711745020.23.77E2FB2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2B345C0013
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:57:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tKo7qpcU;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777471028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Q44WwHdu89tmf4cDVgIblgyW9em0HLuJhml19unNVI=;
	b=jZmHoEf4EyTpsJbKxyOmBcWLXfrqZDOTbPzvp78iPGWxouPljAv9ye5CUzFCHbFWfU/8W5
	H/pmZC+tZsx9s1XUtvaRYGLHNcClsDXuCNBdzE8rn6SsPPmlsa/QUiDbcbZYf5Kx5n1mhT
	J7Nj6gH6ckc4FLxg1jph0dZyLkEJnps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777471028; a=rsa-sha256;
	cv=none;
	b=c1jR0t98H2SjRibBKsTP2RR8yjzIaNI8LvdjdAN528YonbQbwhloU0UIIqxDTyJIlwVkRd
	Be+RzMQ9iHfVYfciLonaECEC62aE/3o+bmhWGG5rTaKE2h3sJdu0TE+87Ykp22N2N4/cGY
	v8tlqCQK3W+XiNQ7MKO8HOMpv+Sw+qs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tKo7qpcU;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4E251650;
	Wed, 29 Apr 2026 06:57:01 -0700 (PDT)
Received: from [10.57.62.76] (unknown [10.57.62.76])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2D89E3F62B;
	Wed, 29 Apr 2026 06:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777471027; bh=uCnIw3CR1viWizfBhTu1oz/vcz1koGemFdz8oEqehX4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tKo7qpcUs76IDv6e5R8HeijntK+tVAsQf3L1gGheC7KBuQnvLjzEHiTDybDxbZD8Z
	 PtAB4aUFl6moEHsC3wTckysjYxLPrEqXAKhGTICBGzpyQ8QAG/d2fCSGec37wtX7SN
	 2lIFCIl0BQq9yN+RECGiSkBoDunVzSNSdbxs6Lhk=
Message-ID: <961e9d06-1520-4176-ad76-3f0d8d5ab146@arm.com>
Date: Wed, 29 Apr 2026 15:57:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 14/15] arm64: mm: Generalize manipulation code of
 read-only descriptors
To: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com,
 mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>,
 Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-31-ardb+git@google.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260427153416.2103979-31-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2B345C0013
X-Stat-Signature: 6zfbrp54rk3k5ysofdfapmdp7j6y6w9p
X-Rspam-User: 
X-HE-Tag: 1777471027-836601
X-HE-Meta: U2FsdGVkX1+sVwD8yQE7YdYSbY6kI0S3K+3RAmeA6xtYYYAfHvK/WL6rV6FRfg0X/ucEimmvlOo76AUUUDyVIh2h/PZzR84Eupvlezwg1hhbrhNvB0CnEHXhieB7mvOBThLlwWGu9vUbcZPx/u2UERLNWr+j1rnrAXt4RxKqZOBzZi0raRj4sQ3Mv/2z43Ey93+XgdDmGT2r9yv5MS4KTMwX74F10ZlF97jXjm1V9cBgqHMosuB/+IdlBaDN7SpCkoyumAZVEItUDpLyJpxegQyhpEa6HdyczQcjHMSW65TvOiGY4KvHMgncScQNAqXJ8woWJw8QY9mtiQC5TyaruQRU8JIMSjI9yqUtSeDEh27UAdK2D6ZgaFmstB90+2bzfvuHyqjKKXexOybykSARRm6jRtwBpPkbw8feBA6/vsyJOlyfnWjxxb8xOIJ+1LkEpywR5gyEcnjDrd/HoDRZKtSptDvbroCLs+ILBC3Ol9zrMeRowVT1Vnuy5/o+jTfJpEzZ7SLNR1vb2fLX1xZrmc/nZ6ZyvuzPS2EzCgq1kNTX9B3qBfZ366Lb+9oOzeonFJygGkMDgM0PBJhiGgrStsQ8VSBHLBUheBOjLDd8EDaxtmPgCndsv1dtEAfsdLVYtrHsBP3x81ob/h36h/2dYk9HFDg2Er0nl+uK7e/zCTf5WPHDbUzdULQwEJOmVS2ZIaX55l1M5TVZD1pARY7CNAudIFLB6gE9gtG6FeynCoeC+4meMQiqA7ZPnsdX2yOPU19k7l6Idn0b3nH+CAOFlmN0iGWV/sd8AdVv8s83NBt+l9bEly7X09OeUS0Y5mpV/YpoV1VZuh0uK1pnIGYio0Moj7GMiuQXZFnfSTGr/czODfg7Aw3GVY4BNrxzbVMdy1DVXqZPZ0rG+KQ0Fzq8VSyrNYrYl3+Erp0QOX+KUpsyK4jugRbgOI6JOl9MIbVNKoP0lnY9cKF/+SPbAKb
 iA50qYPt
 8WrWWE9WqynWi3IdFbzbHwb6Pw17h1C7j+nHtI68kZKGhElCh86JRFUVZ/+aertj5Mr51Z68Sgze9PYQgOaT0cp8hPRYeNF+t8t79vZweOVk1ENuIXFCOioWTq9ZrOtDPfOhDth8Woq0WcL0KN/MINSArLIgzApj7DoUKQGzQe31D9CvDLhJfmeESQevoVTO1bUmojdVCQyV7INOO3UxXxfVfYc6U52iiHg4ZUNA8tJzaHDqSXTL8olukOWpt39B1BrXdB0fM1/iGOfupIlZx81H6aXZ1xm+wlfrbeNjUNVo7D5QQ5vZ3p5Tbvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/04/2026 17:34, Ard Biesheuvel wrote:
> [...]
>
> -void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
> +void noinstr set_rodata_pte(pte_t *ptep, pte_t pte)
>  {
> -	pgd_t *fixmap_pgdp;
> +	pte_t *fixmap_ptep;
>  
>  	/*
> -	 * Don't bother with the fixmap if swapper_pg_dir is still mapped
> -	 * writable in the kernel mapping.
> +	 * Don't bother with the fixmap if rodata is still mapped
> +	 * writable in the kernel and linear mappings.
>  	 */
>  	if (rodata_is_rw) {
> -		WRITE_ONCE(*pgdp, pgd);
> +		WRITE_ONCE(*ptep, pte);
>  		dsb(ishst);
>  		isb();
>  		return;
>  	}
>  
> -	spin_lock(&swapper_pgdir_lock);
> -	fixmap_pgdp = pgd_set_fixmap(__pa_symbol(pgdp));
> -	WRITE_ONCE(*fixmap_pgdp, pgd);
> +	spin_lock(&rodata_pgdir_lock);
> +	fixmap_ptep = pte_set_fixmap(__pa_nodebug(ptep));

I don't know much about the fixmap but it strikes me as odd that we
would now use pte_set_fixmap() at all levels. I suppose the question is
whether swapper_pg_dir could be written concurrently with fixmap page
tables at PMD level or above? I'm also wondering if those fixmap page
tables are ever written to.

- Kevin

> +	WRITE_ONCE(*fixmap_ptep, pte);
>  	/*
>  	 * We need dsb(ishst) here to ensure the page-table-walker sees
>  	 * our new entry before set_p?d() returns. The fixmap's
>  	 * flush_tlb_kernel_range() via clear_fixmap() does this for us.
>  	 */
> -	pgd_clear_fixmap();
> -	spin_unlock(&swapper_pgdir_lock);
> +	pte_clear_fixmap();
> +	spin_unlock(&rodata_pgdir_lock);
>  }
>
> [...]

