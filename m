Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2C7CCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 05:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2295C8E0007; Mon, 10 Nov 2025 00:07:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 200FE8E0002; Mon, 10 Nov 2025 00:07:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E758E0007; Mon, 10 Nov 2025 00:07:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 01D778E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 00:07:52 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 92EB812D840
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:07:52 +0000 (UTC)
X-FDA: 84093515184.26.FBE0F72
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9B8E240005
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:07:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762751271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0CQ7HgwXARER3GZ9WZ/tj0+Lf8vpWEzacdk5ieRkxmw=;
	b=pL0xYlnWhJ+mWdcVsuEtDkSWe3btRyraG44Uj3cYyl1aFsOe9LbrvDrWATqsbb4MrFOCBh
	ym2XviBYkQ0yDbIYJkzbkiodE6siDlq3QOyqO39yssXu2rjc3mP/XrSL40ivaSyv70GLXE
	CfWRAHTbt/mYZFcyB2d6jvQRaD36xTw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762751271; a=rsa-sha256;
	cv=none;
	b=19ugvRxRmoLMIg7isfiVeoIXp5cSzBPmwrpvWQ2c/FGzLYsKFgDWaUp97+aycP4y5qk2Qd
	wbNZ5mVfB0WtD5J6hiRxq+dg6Y89TnIZhAxNz0CtM5x0ZdjfZMtpUrriIyDu63XqFCdGf7
	eziUvokffX4VKGuO6eJirJrxRBZ/12M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D1C78497;
	Sun,  9 Nov 2025 21:07:41 -0800 (PST)
Received: from [10.164.18.45] (unknown [10.164.18.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 808A33F63F;
	Sun,  9 Nov 2025 21:07:46 -0800 (PST)
Message-ID: <b64cd9ba-e80f-4ac5-810c-97af053e4700@arm.com>
Date: Mon, 10 Nov 2025 10:37:43 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm: Remove unnecessary __GFP_HIGHMEM in
 __p*d_alloc_one_*()
To: Huacai Chen <chenhuacai@loongson.cn>, Huacai Chen
 <chenhuacai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Vishal Moola <vishal.moola@gmail.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>, Jan Kara <jack@suse.cz>,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251109021817.346181-1-chenhuacai@loongson.cn>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251109021817.346181-1-chenhuacai@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9B8E240005
X-Stat-Signature: zfbieuq31kting3jbbo8zb1jt1yn8odb
X-Rspam-User: 
X-HE-Tag: 1762751270-205290
X-HE-Meta: U2FsdGVkX19MLWybovCD8bHYlB1nqF1zCb4Cooq4+9PqRx2gjaZlIXG29DaHlRAuRtD9JGO1IxmtNuVG+/1ppAoFP2X7xToTRG3HUsInt1xI/+GoVph9H6F2Q2quL0q9bLQtd0ezQIRk10wjp/C5kjo039A/vZvDWP+r0JJp1cFw8oYG5Mh/yeWalK7U3u4rybTezyerAtpo4yrKvtH+povvFJ7EEVZ+w+9hsyUFcx/Yq3KU/rULBgaFBG3xa+Jezty6Cep6G0LHvEzTU2HL+HsC8fJWF/3clrUJeJFKdVeb/0BiK5GbCi5z4kLNfbGSnXywQsuSY57nyEvPC2j0qwmkN76hO3P/+lLC/EO8jUMU3HykDVuSHa+3gqeUrM5o4gpcvfLXZf3LnJpNKPdXSyi128lBALeA0kCnh6nEAB2pPFUVDkTKnr1dBwyYrE5C96Ix/xwcAciGzd2Z+YrdsbM5YZt6+QTpsITYjIUEI/P1AmEp5fZmyBhxsPEqGhpQsoVT95uSJt+/n/u0n3bRQ1VzUrI4Br3haovjplqUEyp6gIcLDT2LCTkcJ3lCvvF7PRiwaYJJmRxEnf1bA6MTUTvu/beBE6IqbQXopGQSsHX74T48xUv9TzVJUsidKQpScxWcLDy2+vZqZyFzpKx1sJWA1KS1+CO0KLEeOZsyGqVC3QZjWR187g7DosgI8Mlo4lYcZum2LS1tC5f9WzHd+UnOsa9NlmlrldGoA+sqT/LHXkzvWXqY4qZr9I8EFGc5DWeRRSDHIOOXRobdvvPIfyQlVQbj4qJCRIVc9ZUgOIpQcex/cuge7BZhbl2DOmXvOJ8HliPyydPy9iKk70F7eqsDr0brar5joZ/+8gDlteB0zEarDQd/nGnN3HQp7zZtkb5B8GRDolLovWHKeuopatnpGTvD39Xo5i09gA2iNl8raX6Qxl89QwABla+gczjyhzJck4IOmo268o7xq+j
 Fd4qwYbp
 a8LZYBWxJfVhzzDVuVUZHogu3adtXb4ZaNXJK9XchAMRxZHHuXD+HoTcpW2QcH3VfOLq7I+PxjLqtrL9zPdpBlfAbZbK/0zh38upuPVu05RfTDp+mxW8uoDroq4yLJpc86PgukCJmQcrktDWjpYR9I2Q2wpC/LgGar1W6nYCTb0/MJ9LNrdvZVgdV4wjfSAgOnVw1EfAyyPy881a9QH38c0LDP3hhNgeQi2cCuVCSURDhmE0exM56qzgah0Gkp6ZguSwwHm/jsTBeyKigaLlf7TI6xOnnHoAWwgcmIxybaezUNuNtmcAuexB5Kf8xUt3vHKYFBqI+fQeqdL5XPYJEORJgihO2OGCLKapr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/11/25 7:48 AM, Huacai Chen wrote:
> __{pgd,p4d,pud,pmd,pte}_alloc_one_*() always allocate pages with GFP
> flag GFP_PGTABLE_KERNEL/GFP_PGTABLE_USER. These two macros are defined
> as follows:
> 
>  #define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
>  #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
> 
> There is no __GFP_HIGHMEM in them, so we needn't to clear __GFP_HIGHMEM
> explicitly.
> 
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
> V2: Change the subject line as Vishal suggested.
> 
>  include/asm-generic/pgalloc.h | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
> index 3c8ec3bfea44..706e87b43b19 100644
> --- a/include/asm-generic/pgalloc.h
> +++ b/include/asm-generic/pgalloc.h
> @@ -18,8 +18,7 @@
>   */
>  static inline pte_t *__pte_alloc_one_kernel_noprof(struct mm_struct *mm)
>  {
> -	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL &
> -			~__GFP_HIGHMEM, 0);
> +	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL, 0);
>  
>  	if (!ptdesc)
>  		return NULL;
> @@ -172,7 +171,6 @@ static inline pud_t *__pud_alloc_one_noprof(struct mm_struct *mm, unsigned long
>  
>  	if (mm == &init_mm)
>  		gfp = GFP_PGTABLE_KERNEL;
> -	gfp &= ~__GFP_HIGHMEM;
>  
>  	ptdesc = pagetable_alloc_noprof(gfp, 0);
>  	if (!ptdesc)
> @@ -226,7 +224,6 @@ static inline p4d_t *__p4d_alloc_one_noprof(struct mm_struct *mm, unsigned long
>  
>  	if (mm == &init_mm)
>  		gfp = GFP_PGTABLE_KERNEL;
> -	gfp &= ~__GFP_HIGHMEM;
>  
>  	ptdesc = pagetable_alloc_noprof(gfp, 0);
>  	if (!ptdesc)
> @@ -270,7 +267,6 @@ static inline pgd_t *__pgd_alloc_noprof(struct mm_struct *mm, unsigned int order
>  
>  	if (mm == &init_mm)
>  		gfp = GFP_PGTABLE_KERNEL;
> -	gfp &= ~__GFP_HIGHMEM;
>  
>  	ptdesc = pagetable_alloc_noprof(gfp, order);
>  	if (!ptdesc)

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

