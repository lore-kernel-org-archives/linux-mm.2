Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48C1AEB28E5
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 08:18:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 305CE6B0089; Fri,  6 Feb 2026 03:18:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DDD66B0092; Fri,  6 Feb 2026 03:18:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2134F6B0093; Fri,  6 Feb 2026 03:18:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CDA56B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:18:57 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6EAEB140847
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:18:56 +0000 (UTC)
X-FDA: 84413331072.22.0DEC581
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 79D6340013
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:18:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rkm+DJ+n;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770365934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LXBByC5/KZduslF/XXgPcZ9d+pMMLE5CiBitFSTak2o=;
	b=xdhHmA0GgWHRH8o3pIzY9FqhevI27WKI784DiOkWZusWOk6fsleCwDjajH9fJinWc9s/ln
	c4ZhhUpN7qVKAeY2BP38vMRPyPUfU72SeuRaeW7NpLYTey9Th3Ysfv0TupSNsjz7zHDXo3
	0QVBvOb26wpQqeQGqbVMrtH1r3CAs2g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rkm+DJ+n;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770365934; a=rsa-sha256;
	cv=none;
	b=lvBe5v/b2M6ZVEZEWeX+ohfeui5/tE7KdxPRLRjqD229d+862uS/K6IyHuy/YdOu3JZuR3
	99Yw7JxEmRPMGcwUBCmW5IOn4Non2ucgvu+H3miwdrwfOIdmYP+xcKKKhn06seskgmuYs+
	PLO4NPbvdX+O6RPxs53Xg0m7lkFrFkE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B9B1408C2;
	Fri,  6 Feb 2026 08:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BF4C116C6;
	Fri,  6 Feb 2026 08:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770365933;
	bh=syvH/EQhTARDq0ntPLE1YxFDXePP+tcEqlK28YM5SKA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rkm+DJ+nul/EhvQz9DIjFMuvbWLKUMga0qkpo6yRynLo49ahf8C7xCbDruBozImLe
	 543u02WvzmVpgrM46UIs9g9E2qBfy9GchB+EpTDM/6e2z6WcTeTBIv5Blh6X10yyQH
	 j47lD2Ih0XpJBSYJr2DDGHRXqPsLLfhyqoN7+AdBpAP4dzkwJ8Ku0D5sC4OJC6kjz3
	 BVzC2HWM+MCTpta7hTpOf7gSPGFkQQpnCuocMKeJGzVHJu3a+UwZSd2r+2WzA9R7bB
	 7Ccl6k9mtDsml3l3qmmb20hzAy8p6T5tCEzrnmMF/o154D/1s8CQ3XcyEhcaG3pc60
	 fpj5Pa5yJ6JTA==
Message-ID: <a1d5bb75-3222-4863-a24a-4343b25ca6b7@kernel.org>
Date: Fri, 6 Feb 2026 09:18:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ksm: initialize rmap values directly and make them const
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev, hughd@google.com, wang.yaxin@zte.com.cn,
 yang.yang29@zte.com.cn, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <202602061522548871ohgXN8z0qq87sTSX-yZc@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <202602061522548871ohgXN8z0qq87sTSX-yZc@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 79D6340013
X-Stat-Signature: negqfpwmt165bgqx388u6ggiu1i4on5k
X-Rspam-User: 
X-HE-Tag: 1770365934-975534
X-HE-Meta: U2FsdGVkX1/9hNmDO/fjg731gSOAb1hlHZ8aLHm6ZafVxtv0elLlTHU7ZaDkMzhfSCR3toLuuUsZYU+PqxI7fef8vrkRmAaqjyGD/Rfg5B+9MZTGYho9ewx71yv7ml+2XfzH3L998iBXlmNlAIJ5g4NKpbkxMq9wPH7L1AZQvICb5YzmGHxANc6wsFzzEjjKzB3DpA2I2uxkZeGiZ8iEfh9CxxJvsnAr0tJap+IFYS+a+7E3s63pdIDsb+Y6MnCT/qf/TO3KM8vHBNGIzyFc0R04iFbcaNnCHh6PROb1r/bx0OGy6AoVO23nnnidrLop7UN4LLDpDthiOzK48DgI/T4r1aGeEyDDvhMuF0RqIxjvKb/y2EfeTuQVftCou7vEstL8c/pWbRbdjJ3CICHsErH62Ft0u0ch8xb5yLcZ8xEiPzvZHs+0VYzZJQl1mFqhEKvCbBaGmkoAFWEHVvMWK7Ge4SuaEHReTn2QOiu52Z9cTM82AySttO64xOI7GYTfg0BCx+faEozXOzt+gkzInDsopAGJLmc5obMDd7vHYWkH50QSrBbFOF3nFU4ZuMHm9IxSDg9u0qdbWGk67MaU6MTkdwcaNTvekgT/KY5izePXNpuYPsKRgZNyJq8604x/DLcDshQtmGKfNvT2cY4wRPrdNatoZfe5wmhTbwUx8Fy+XzluXXUzUklSwZ4oT/rK32uU09w1jQ5G0ybKW2wHdjg8gNeO6uZcYr64CGIc3s6K+KHL2oHs2eMVDqw7nmCVYE0dxXW7gIMTvSBcghsdKQpiUDfnwetMgOBmGjo6PRx9OHpLA4ztvNR+zwyebJz9zjk+T18iTyS1TPJeKktDSOF9l7isuJG5Datx77q3kItQitoLmmYlqMFfS7TL3QkJLCeC4gvfEI48XaYQHo6i+o5ARIlO5yV+UdY2DAUVYuNS0/20UJ6gPhJRZNefF/uVuFEGsUCCf+22/vSSL36
 FYCtDb8A
 RVuW7xLQ0YHDzqogtFrMLdVOs1xReKZ3KKsQhMWnHEClz9AE6FZ7jUs4xUZdOrBhpB561MXBYNH5ugaKIZ2QP5KkrG1/j6y3Hqlotj11/S70GXth/6Zn6lXySO9v+vz/kEVxIePffKUvX7sxkJLChyLus+KZVbdsii3L3lqu4/ur7y23eCZPGvnn1bns45uInUsdd7aE7LskGBJQJDYN2r0v8kiF6+GyIp7pvjbNKGpGBibtiT+Jg5nOuHjVqYexvtKx4eH7iKg9+AA8YAduqxeqyUS9ZARQFg9DryyCtpx187Aebbc5+4tgSn68PE9wk9rdKkFIUUN7Kio44x/CXSI/45g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 08:22, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> Considering that commit 06fbd555dea8 ("ksm: optimize rmap_walk_ksm by passing
> a suitable addressrange") seems to have already been merged, this new patch is
> proposed to address the issue raised by David at:
> 
> https://lore.kernel.org/all/ba03780a-fd65-4a03-97de-bc0905106260@kernel.org/
> 
> This initialize rmap values (addr, pgoff_start, pgoff_end) directly and
> make them const to make code more robust. Besides, since KSM folios are always
> order-0, so folio_nr_pages(KSM folio) is always 1, so the line:
> 
> 	"pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;"
> 
> becomes directly:
> 
> 	"pgoff_end = pgoff_start;"
> 
> The test reproducer of rmap_walk_ksm can be found at:
> https://lore.kernel.org/all/20260206151424734QIyWL_pA-1QeJPbJlUxsO@zte.com.cn/

Thanks!

> 
> Fixes: 06fbd555dea8 ("ksm: optimize rmap_walk_ksm by passing a suitable addressrange")
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>

The patch does not seem to be upstream / in mm-stable yet.

Can you resend the original patch with these changes included and the 
reproducer referenced in the updated patch description?

Thanks!

> ---
>   mm/ksm.c | 13 +++++--------
>   1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 031c17e4ada6..c7ca117024a4 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3171,8 +3171,11 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>   		struct anon_vma *anon_vma = rmap_item->anon_vma;
>   		struct anon_vma_chain *vmac;
>   		struct vm_area_struct *vma;
> -		unsigned long addr;
> -		pgoff_t pgoff_start, pgoff_end;
> +		/* Ignore the stable/unstable/sqnr flags */
> +		const unsigned long addr = rmap_item->address & PAGE_MASK;
> +		const pgoff_t pgoff_start = rmap_item->address >> PAGE_SHIFT;
> +		/* KSM folios are always order-0 normal pages */
> +		const pgoff_t pgoff_end = pgoff_start;

I would move them all the way up, above the "struct anon_vma *anon_vma = 
rmap_item->anon_vma;"

-- 
Cheers,

David

