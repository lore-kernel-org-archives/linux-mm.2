Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C24CC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:50:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33216B0095; Mon,  7 Sep 2026 10:50:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0A266B0099; Mon,  7 Sep 2026 10:50:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F8AE6B00A0; Mon,  7 Sep 2026 10:50:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DDFD6B0095
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:50:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 00B4A1C0B5E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:50:11 +0000 (UTC)
X-FDA: 85187251464.17.0E41B52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 266C1140005
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:50:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oBBZei8f;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788792610;
	b=5HITsuTSQaGz9bBrg/3gki3tCMETsVAHKiqTnXsXX5sAcF/hgkMg9dPJCAm6K1lZB8hPKn
	nhsrffy51w2Eeyn/p0b5bWxPXjxH4EZfo+Bpq+yh/AP8sn2FcZtBweO0F7Z70n8Jh4D33j
	JVdl2ghiPt/DkSI8wky0YlDEHx4+qA4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oBBZei8f;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788792610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0mIRzAim8Xm04hf6n5NB+NxEk+eE5bXm5v665dJOtpg=;
	b=k1ru0+YLyrt+MOe/ya+vyPP7O+QcpeEdtw0/y00SvWkL8jy3IZqwoc+4P6mVcJIWhYXJ49
	/SyCQryK6XrBPZjS4ud+0jZ5ahYQ1cIfJlmwPU10DBY/MCJgymUAINJnnnkoWmV5I9y2fc
	EP7Vcl4tla1PSAWNfKB8cOILU0hKi/Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EEAAF41AA3;
	Mon,  7 Sep 2026 14:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F42B1F00A3A;
	Mon,  7 Sep 2026 14:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788792608;
	bh=0mIRzAim8Xm04hf6n5NB+NxEk+eE5bXm5v665dJOtpg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oBBZei8fiHVJieUd7Lx21QpFtUu+KnLLeLIBYbntsp5gB1HSyOzJ2aCxPwQTrnzsR
	 ZAV5ezYF7K8Svj2yPyUBGosD9SRvb0Pk+1Bi9o1dFVWx2Tv/7jSjX6oi0HUYKze38r
	 ZkDapIB5ST8+zWkvJyYsQ1rbKV3Oh2LQJvhhfw4H+6HsGG5zQC0+FPDYOJBXL2FSk1
	 dj6BTOsA7RqNsT0El6XVcv6nydL4/FdBaq9zC3Oc0FOe5VSIZEu2+qjJDRuhMI+fyC
	 QMEJVhJUA/B5pP68gI7p3UQ4lFuzH1BYO9AcCR58lwusE8FgQzCK4yHGJmzAQfoGal
	 M+e2/iEYEUDDw==
Message-ID: <cc0fdb0e-ab6a-4095-b559-10e1d8a616d9@kernel.org>
Date: Mon, 7 Sep 2026 16:50:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/gup_test: safely calculate GUP batch size
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260903115033.162218-1-sarthak.sharma@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260903115033.162218-1-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: sa66w17ozmekd8k5968z15u6zong5sdi
X-Rspamd-Queue-Id: 266C1140005
X-Rspamd-Server: rspam06
X-HE-Tag: 1788792610-162240
X-HE-Meta: U2FsdGVkX19LMDEBAGKgc0eq7PSX4CGkE9MIoiEPsTWh1jq4Ttsk9sRmkq5I5539SnS0EfhlhnOFrzOfAC714H3NpWnPgnpBvG+E/EijMbE099xb6eHERFCjRDqicG06YTJjC1KxAnBOTjjw4PpU9sCBxBAfBiuZc6I6vOgvjtZkr/SyQXzzZaRTiC0PN1GG3hqQw+YFJWVyJ4k/46XgEjxecH7gDgAFEH2HKKXoPoE7Ialy/4vFDXQUkOhES8uKCL/jzXRms77NVbrqkN86yzTTKHL0BcWfzRP0aDRmIi3NKF/K9qGutotzyAiXbvbsXHATpcNhbel/q1RKwbx/ugnkAxIUvk02BnxecQxEq2UT4D0HSBQUr44Od6vTgFGBAG9+pjLlA8FONsaW+TeXi2NhkX8nB8cnaJV8WUIsL7iQUPlJj4g248/kQV1OYiA7ri4Xv74EwMpw44EFGXgaCg1iRmUNnIOunzNznowd39ik8xWkHOKLQtx9iuDDeQ8D/QXq3ifzfap96ejAJ3kUUcqLXH2JCtFQf2ZjfcIE33frEMapUfu62USPt5bniQ5TyKf4VHd3H3vQ5E0hvIzCsM7DE8CUAa+IZrQoH2KIHl4wuJLZSmB8CrdyIN0LB9oNIz6SBmXb5CbKsgMfnf3gn+33IZLx5iIhFecQra/zjGgI5oHRyqCf2pY0GWKcGZdYxAiddzJ/bx2EuakDoDz9FPAos3z9gXeBVisiUdgAU08IeFsvUXWLmFluvDI3ahzLItl7hIINNSau9k/WoejGtnHkPHh+hNNNRUNCttkj9ugtF+W42tUd8uhSlTOUmJfaE5E8GsGVFFeD9GNLv51qA7FnJfhVPIvgUwCokjI9N6eLbQnZBgwAX5MeVe9wn2sZfjU41Hwt1m8KDVYT+VhtFn8NYnDe4nQthbFGcfnvrw/fOjV3XoUAO6tXfkZwm+z1Qkn+r26xW1KQke8u++2
 bb4YDo34
 PDupmT5eWd5r/VgXB2T3ZRoHlzlpOASQ9CmlAOp56w27v5Kw2+V74C+LNxDOwGiWj/+v+tBJKaW2Bys8JuH5WX239NHzi1D6u26R9g9cmu1MgBudFAJ2VJfdfW7EZi8ZhUFcA4mXzftZtB+52LlcReuuI7cyXXiL1nBpa50s/5+PgQ0E4xx115HMtHuBpeUHQKmYpLZ9qNKFh0sb39sVjX175d7/TyhLEy6B5enAXhN++bCVKXOmD1LPiwj2unJ/2MLxPlW/gLiLygp+bAV2ZuR8dzDOtbYKK9L2mGgAQlUfjs0zWV2sSmjcMHPTUoJ2pWUQqnemILisDMxMaHstroerArMbv8OUY9zS1mB2jy7qHUMdh2PqQZokNgapohwb158GqGFY566nwzWQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 13:50, Sarthak Sharma wrote:
> __gup_test_ioctl() calculates the end of a GUP batch using:
> 
> next = addr + nr * PAGE_SIZE;
> 
> If nr is too large, it can cause next to overflow and wrap around.
> If it wraps, the next > end check is bypassed and a large value
> of nr is passed to the GUP call, even though the pages array was
> allocated according to gup->size. This can lead to out of bounds writes.
> 
> Also, when fewer than PAGE_SIZE bytes remain, the calculated batch
> contains zero pages. The code still calls GUP functions with pages + i,
> which can point past the allocated array.
> 
> Calculate nr by taking the minimum of the number of pages per call and
> the pages remaining in the address range. Stop processing when no
> pages remain and calculate the end of the batch using this bounded
> value of nr.
> 
> Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---
> Sashiko reported the issue fixed by this patch while reviewing the patch
> "mm/gup_test: report actual pinned bytes". That patch has been applied to
> mm-new. Since the two fixes are independent, this revision contains
> only the GUP batch size fix.
> 
> Changes in v4:
> - Simplify batch clamping logic as suggested by Kiryl
> - Don't call GUP functions for an empty batch
> - Drop the pinned byte reporting patch since it has been applied to mm-new
> 
> v3: https://lore.kernel.org/all/20260901083452.115365-1-sarthak.sharma@arm.com/
> 
>  mm/gup_test.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/gup_test.c b/mm/gup_test.c
> index 185ba3bb8ed1..1b64e932c4c5 100644
> --- a/mm/gup_test.c
> +++ b/mm/gup_test.c
> @@ -139,11 +139,12 @@ static int __gup_test_ioctl(unsigned int cmd,
>  		if (nr != gup->nr_pages_per_call)
>  			break;
>  
> +		nr = min_t(unsigned long, gup->nr_pages_per_call,
> +			   (end - addr) / PAGE_SIZE);
> +		if (!nr)
> +			break;

Can !nr actually happen?

-- 
Cheers,

David

