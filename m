Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22BDECCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 06:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5498D8E0007; Mon,  6 Oct 2025 02:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 521248E0002; Mon,  6 Oct 2025 02:07:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4373A8E0007; Mon,  6 Oct 2025 02:07:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 319838E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 02:07:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B376213B0F3
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:07:56 +0000 (UTC)
X-FDA: 83966658552.11.B792405
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 05D41180005
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:07:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759730875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LoCoMpOCq90u104f6zGv1gR4WcLCVlei55HPay0nwpY=;
	b=HAxJ1VOR+gSb5nm9dnVrFrKjoWuUn4eDC7Bj5CNHKk60Tp17nncCIfSKsYJ5Df/3BmEkEl
	Z/DEb9eXr74s/9Dm2rREhY+yxJ/AXe6N/GibujNLLhdr0eZQt8a6vrPsEEAmIdo7TYFawY
	4e+DLTYY2GvbYJGqLYfEt5U+AWNecdE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759730875; a=rsa-sha256;
	cv=none;
	b=qKt6FNloLjGXFlKdZvbVll5hFEGclYQxtf/DnZlUU0aHaUEa3j1Q0oANvH2adNtmJoYZHa
	Bz9MX7jymk9sijXJsmcWDfxHgfIooPY5vcv2Rm7U7hKTMT+eE1oxWp4M52butQM/VLNaYl
	N9JJZOqrV/927gHoUqDBwG6cTcHKOww=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E8227150C;
	Sun,  5 Oct 2025 23:07:45 -0700 (PDT)
Received: from [10.163.66.9] (unknown [10.163.66.9])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EAE873F59E;
	Sun,  5 Oct 2025 23:07:51 -0700 (PDT)
Message-ID: <4b513d32-7795-4998-98df-d398c3d5462a@arm.com>
Date: Mon, 6 Oct 2025 11:37:48 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/dirty: Replace READ_ONCE() with pudp_get()
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
References: <20251006055214.1845342-1-anshuman.khandual@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251006055214.1845342-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 05D41180005
X-Stat-Signature: zqih9xzinuoybp1aeu151p8u7x5cwr4n
X-HE-Tag: 1759730874-442323
X-HE-Meta: U2FsdGVkX1/Tz8FPWLwBFfz2BQ5HBjqKvsQuZWKUMR0tmZDvZ/2OK2JSbbgvMWXkZ+PSQGkkqKAfREBe6fn1MwYZ7nuI8LTf/wgyo3X0ASupynPZOS3v5LXDt+FCGPml6YKnVD+KwvOfH5ESoRZxWVSnWD1N1ErAqp3auE/BFEj1+K2q9r8UrkPu1H9E+sGJ+Okgf2lYYofcAILKAHXjevia9Z6l7f/9wZPdGTsuKPN8SmK4yHiiSLLr/LDJAr4qm2NlGd58H/V1nM7IXVYR1dONPX7GfjgX4zTb1pFX4jk8bYUV0ptZQZZ/zL1K45u0fgJWbHKheCFBN2Vel6CQxMjyn9f3+7KuBqSWFbx5JFL2k1EuNjeFsVeXKoVYir056ct57zgyJSQzvKEI6fHdjRAfMjKI9JzzSQKR4a8gMpFZQ1aa8eDM/5plCLu67v/CVSsz/KqQDUJYdd8ZzGDAaBkyME3YY8vUW6a572oq2kDsYzDDKOLlsdw/Mn2OJit+S4FAeWRmWsdlQv8RPlk+O3MIt1vSdGDR+NJeCjuYpHpuuuAncfl7Ea0jvGxMkG6BJBjoZCHLQK9xtMYZTlaL9wTb1evXulFKRarswxDXVFyI+fstghPKzoDempA9nmoK+XVwXqL8G/i+BaWCV0H9fvEGoS0FAIu1iRAZgR8GFQiLX/HI9K9phmMWMup9T+xu1j9p05hiCHbgnenGQf1kPF467ZQ2SBZCX0na58DV9ACMa6FxQkLM4NlcfJXxH7Io1Chj2nq/KryO/SK/KPf6LdLaocRV7Pfc5CfHqw3XNhBiXpsudu1Xlq5Mo2jU5GdiqToH+OykBN+K9UTllqR3PTufVHlUo2BvRuwehcOPT3OR9G6IEfOK77OBTyzpBBo/IKc6gVOD2lk50VdKV2tyBkQ3rATdW5evfuNcmnNiq7xnPFZBDpFfHdkQJ/YTjrbJ9bJ5eMrELF7qfuvStox
 7Z9wVH9+
 UUJaHI1XyrPlwmWkBSAkTsWwLHNCTnemLnbTh5PCiRgwq7YPtDcP99SzYmGN2IljZKs7DdE0D9bAPNsaALIJMWcnvygrKJgxhlGxDCHh0RWtptoSUertfZGDS0H1J3GlfZtxvUfrcY+pO0ACAGsyj1QFJ4Erzjm7ARqDplOuMBGEwetdrx5w7H566Jum3RImZnZH+od8rpesKgD93zkLwOJH0m7HaEA91K/qJozP+OSFPo9TAqqetO41/2RozEwm2IiEeEanVgSsu3BseUWPbTpDZKHcFePNqtzq76NvjfjjWJ/oTMjiZc/NxkHMf5H3wX6JoJh+cQLaA8yn3uSRioDmZSgm39iEKMlBXbWyGIqsHRWXdgtCSChZUMMXQq7XjrvZgD8rDfnsloWJhjvDq+dsz2koRKVfXz7Fx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 06/10/25 11:22 am, Anshuman Khandual wrote:
> Replace READ_ONCE() with a standard page table accessor i.e pudp_get() that
> anyways defaults into READ_ONCE() in cases where platform does not override
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>   mm/mapping_dirty_helpers.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/mapping_dirty_helpers.c b/mm/mapping_dirty_helpers.c
> index c193de6cb23a..737c407f4081 100644
> --- a/mm/mapping_dirty_helpers.c
> +++ b/mm/mapping_dirty_helpers.c
> @@ -149,7 +149,7 @@ static int wp_clean_pud_entry(pud_t *pud, unsigned long addr, unsigned long end,
>   			      struct mm_walk *walk)
>   {
>   #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> -	pud_t pudval = READ_ONCE(*pud);
> +	pud_t pudval = pudp_get(pud);
>   
>   	/* Do not split a huge pud */
>   	if (pud_trans_huge(pudval)) {

Talking about mm, why not also make changes for these READ_ONCE accesses
in gup, hmm, memory, mprotect, sparse-vmemmap?


