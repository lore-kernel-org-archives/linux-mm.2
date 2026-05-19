Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AACBCD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 07:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7792D6B0005; Tue, 19 May 2026 03:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72A256B0088; Tue, 19 May 2026 03:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6178E6B008C; Tue, 19 May 2026 03:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 495B26B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 03:36:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21DD71C070B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:36:00 +0000 (UTC)
X-FDA: 84783360480.07.3EAF848
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 00C7D120003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:35:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UKVx6mfL;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779176158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fb4rd3JOH/XLICZnhoBqn+iZCHBwoI96tRV9BmMtHqY=;
	b=JecyW1mnHg7t0pVqYTOu2bFVhlwchr1eZ5YbnYqMkR8y98Ujf18BnaaSqntll+SiDsVeP8
	znpkEfPU1tpcuP5GRg/vLD2Zx/GK8T/TdSuv6aLu+SDfE5qtlud/62j4CPUWPDEdm85wRj
	0ThBEX5DvpJnlaGxWdwSNnfUkpvcgco=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UKVx6mfL;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779176158; a=rsa-sha256;
	cv=none;
	b=uFI1zmcx4tb95/uMQ/xgjELBNrgqhwo5MzSYNmuNw/ac62AMPFrjpK1W24GtmrUIu3g8t6
	MQV7lN5JVoLet+Li4kZMhsjLoaaAHk1tGqr8gzGy5LTQxxoXKxHkF9i+J2ltV5N11Rr5Nb
	4iJYo+lH8PpTJHhe7HxyblvmP4hW9jQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D46D34FC;
	Tue, 19 May 2026 00:35:51 -0700 (PDT)
Received: from [10.164.19.29] (unknown [10.164.19.29])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 478FF3F632;
	Tue, 19 May 2026 00:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779176156; bh=lrNkq8vPNhkoaGraKXb5A4V1Dd+fTMSHxiXMaQsexgo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UKVx6mfLx2RPQMAb+GC/xBVqDqFz2f6ViqSFuUy1fR5x94T8y/nE6RGjhqZfxhwOa
	 FkVpeLJLBFgnh3bNEdvdN4M1KdDq/pXOIz7TZZnUQp18CFoFQkSa4WV5INEGLn+ANv
	 DlRw6Wzj/ZrHHSEHczZN+SuXjvYH1JnIb1dcFDMU=
Message-ID: <fe2b977d-3a24-4322-a0e8-b91d67b15d26@arm.com>
Date: Tue, 19 May 2026 13:05:44 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] vmalloc: hw_tags: optimize vmalloc redzoning
To: akpm@linux-foundation.org, vbabka@kernel.org, harry@kernel.org,
 ryabinin.a.a@gmail.com
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, kasan-dev@googlegroups.com,
 ryan.roberts@arm.com, anshuman.khandual@arm.com, catalin.marinas@arm.com
References: <20260513105734.3380544-1-dev.jain@arm.com>
 <20260513105734.3380544-4-dev.jain@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260513105734.3380544-4-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 00C7D120003
X-Stat-Signature: zbkrorwkxao3sqniro8oxnwa55g4hw3s
X-HE-Tag: 1779176157-853938
X-HE-Meta: U2FsdGVkX1+1kdPDnK4xEgsGZ5XodEpknwhMhBFBZ0Mq+DTUwiXhNO35EpI6AD2CuWWdSow3ryMLpe7zb+ZGMDqphF4ow1c+mhfOOHHzxxL1rbGyF52JmcVD0ljB5z98NuO0+G3nkH6BiijKURkFGYegfh8/Tq0rEdTkNNd5PRYTzY1NDUKfuHeHkhWXTpCnsFxPZTrIr8wGDC7zPWsV8Xp0ygomBmCErxEvomT7UpgyWkikqKA8petGMy82IWToHMpBZwR084a5GSrXrfgfFtKesb3wAwiQgG8PEFzwZdUKXRnf/FPklgLJ0qal3HzDpQw9baQc9qzQFekKXuCLGDlBWpor5vn0bUGGmH4Vx7dEzToreYhhTKuoPBOS6U556ocXMuk4TMIl8SMDpM0KHvaorMseGQOytvAbR0pO2Styw2JKP7UlyT/a5u+w5oW2Ohfere1M3ZBkLmpaW3C5x1cO/lnbu1+gQqLwANuzU6JEBDU1gVLjNO1KVzK2jU8vLahwmdyoGvsNhZV5t/UoZ49MH1rMiAXbQumeIFhYU/Nn3wu8TXzjn26uZU9XCEkcBHMFmxpXp03NKc6PXc2XPfoTZlUjemenHA5ngaMRAVwfN24ZGbwiObQrhNxo/daKvqOCRiRLhxrBA8Pv43tct5dypgZygIfZpu37olDltgpO4uEWlKL1UzLU7ShdGPZey84J7goKQicXjvUJTSSFoOt7rbA3/Dtf+yuINQIGu99Qn7SWpU6SYD5R2rhl9mzp5ZySe6hVZLn7coHYhJOPiqn1BV9TUR5yJyF1dFJBeqZ4/2YP54F2OWTHFUApoWVeVZvZpoG01C8Ptmm1eGiBLA8NbNpNKPaSOb+I8tZ/nEex+XTo+mJhXRL5lQcxvpzosMUZVmTHInA69W/b+JR2/lu7qcdNUrD1c86L62EayDqzD6cPKyMZ+fFhG44AuB4e4lgYQ8tZiS9or6qxNQK
 cc8UlyqZ
 49RtoZTjNUKNpiawmzav+q8/31biWj+LR9Rv/QR1WIumR+j3cRiLZkYBtIUFQDGgCvxHIMQGqzZndy7oszIpKWsc2e44kKBDbfHl76K6gRDf9fpmAeIuOWDOib6LNXVZ4Z47sIXT4toy4ZVOkUkxQnxY8RR5zPh0dHwzxL90piuqyl1qgdNFvxOUCE5SnoQ5lP+2jpVeR2yGTKUqK1TFS2JXTvCIhQiuCbdDmBKJZZTPjxnlDZqX5zkyHIVbpyxSjL26KBzs4jsDL8Y6TOAki5URcCmvHpYnnDylXEDkRxy+msrPwYGy6g/GnHz/GELGRgFq7xhFfRIQsuY6ccYJq83ochV05OX1KXcdesroYmqWdjAiwUNKy8PFY2C5tBrF6OBuUKlIJ6tY2MKn5lc2Pl2tPAxHsPKeHt0sa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/05/26 4:27 pm, Dev Jain wrote:
> If the allocation size is less than a page, vmalloc first unpoisons the
> entire page, then poisons the tail with KASAN_TAG_INVALID (for hw tags),
> to catch OOB.
> 
> Instead, unpoison the allocation length, and then poison the tail,
> saving some work.


My bad, I see that the actual allocation size (and not page-aligned size)
is passed down to kasan_unpoison_vmalloc, so this patch is a no-op.

I'll drop it.


> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/kasan/hw_tags.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> index cbef5e450954..7c94f71b5f12 100644
> --- a/mm/kasan/hw_tags.c
> +++ b/mm/kasan/hw_tags.c
> @@ -364,9 +364,6 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
>  	tag = (flags & KASAN_VMALLOC_KEEP_TAG) ? get_tag(start) : kasan_random_tag();
>  	start = set_tag(start, tag);
>  
> -	/* Unpoison and initialize memory up to size. */
> -	kasan_unpoison(start, size, flags & KASAN_VMALLOC_INIT);
> -
>  	/*
>  	 * Explicitly poison and initialize the in-page vmalloc() redzone.
>  	 * Unlike software KASAN modes, hardware tag-based KASAN doesn't
> @@ -375,8 +372,14 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
>  	redzone_start = round_up((unsigned long)start + size,
>  				 KASAN_GRANULE_SIZE);
>  	redzone_size = round_up(redzone_start, PAGE_SIZE) - redzone_start;
> -	kasan_poison((void *)redzone_start, redzone_size, KASAN_TAG_INVALID,
> -		     flags & KASAN_VMALLOC_INIT);
> +
> +	/* Unpoison and initialize memory before the redzone. */
> +	kasan_unpoison(start, redzone_start - (unsigned long)start,
> +		       flags & KASAN_VMALLOC_INIT);
> +
> +	if (redzone_size)
> +		kasan_poison((void *)redzone_start, redzone_size,
> +			     KASAN_TAG_INVALID, flags & KASAN_VMALLOC_INIT);
>  
>  	/*
>  	 * Set per-page tag flags to allow accessing physical memory for the


