Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 244FACCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 05:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9248E001F; Mon,  3 Nov 2025 00:24:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA9A98E0015; Mon,  3 Nov 2025 00:24:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C714D8E001F; Mon,  3 Nov 2025 00:24:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE3148E0015
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 00:24:08 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EBAE3BC1DA
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 05:24:07 +0000 (UTC)
X-FDA: 84068154534.12.1AB0AAF
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2409212000A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 05:24:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ILjSwEEi;
	spf=pass (imf29.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762147446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=hxlaLhA1KNd3P6ts8pPE7iFrzEvkZDWndI4E+RtwM3c=;
	b=gqJ3y6mWsLxTSwODdi600d4dAmj1LkiYes6EdIvlxqEDFAD1FHP2QETRXmOq++i0g3lxH1
	8Uc7KRUqZXo7oErOsrTrsa/NpqyLzgzVVqzwPHkEuT/u92wlXQAEITYsbVdklLjzfwm3R8
	lD3gGz99Cvpl+ad9XjZzYaWU04/9TF8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ILjSwEEi;
	spf=pass (imf29.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762147446; a=rsa-sha256;
	cv=none;
	b=oS/+68zvBtHz0/isicVkvYsy0HBKa1DvOo2ek+SrDk4DZk/5WvyKQxxTNhSifRWug3bU/k
	XXXdrgmYCj8xZqMfPeYEjD1Ro6QvHPq/T02hYW8fXQ0r6zau/VSl0zFnY9Y5JOERepshfH
	ZAQubxpYHcS1YGLIsWl7QSO/0ssiV68=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7aae5f2633dso502549b3a.3
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 21:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762147445; x=1762752245; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hxlaLhA1KNd3P6ts8pPE7iFrzEvkZDWndI4E+RtwM3c=;
        b=ILjSwEEiKgc3VC3tvAGK5z5URLN4G939KIaV2TlPTyNV+2LgIlBNHXsQcGT9e73VWo
         2zzph2m6M+xzrxtHwMxWWP7qJB5vgEKUycmGAxDyPdasxp+pRLLbm2v408qXzwED+tem
         02UUvPewxccgKJbuBUqACM60uVcS0DJcRRWLRlFH1HP+W36Tm9iu/Ad/NJwrrY3o3evB
         dsxdDbseTMl7vs4smteyBxcxRdUSNlWz11cyBQ+7HpBd3nvd3GWTdlHNU/Bev72k6nB8
         Abnvj8Wr+xuJm5NUiw79lQQfV43LqtxxOH3whNUfQh6JHAGqFbuBrcl+xeAg1ZAUDgpz
         7fVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762147445; x=1762752245;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hxlaLhA1KNd3P6ts8pPE7iFrzEvkZDWndI4E+RtwM3c=;
        b=gY1fEwt49j/h3edgOuDYBqWVm4X+2rWFmIhaVgcFTAUBoOg1HX8FLln5v+p3gNJBnT
         xp4ui3uA2XTNJW5hsN1i3TB8P7S2NJWyuKf8J1lDFRgxVcw7e7sRlbx5E8m1GBmr0VZK
         +OCFMOScMzSY79tGZN3lVi7EdA2q7pE2rlq7N3RxzUpuHqGLw3eFFF8YmbJvFVnFi822
         7MPj95p5xPWDcIxoqmg0eU5diKqkqy5qXIqSuXucbwajoF4scjVz8ammZ9ygjFBnLNLn
         w/czjyiCVSs1SP00LfPCNvVWu0uskToFfV7GAuw0qPPCcNF4X/WxEaVZdNv9a/M3apkq
         ysBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwqLjdt9adPcLLVl02cDt4V2oJ8rs+odkJWGD+TUZEUjCYd6lSsg6bJWj7qu5NpbOfEkvwCgoreQ==@kvack.org
X-Gm-Message-State: AOJu0YzH1A3h9KCSCZkyg62Bs8bZUbiTdPvhMjHUhlCa6S95jzakzsFP
	Omcap/W/1NAIiSi0p0DKTYT0AbnL/7GIBt6RM5MAdBfn4FRdiMcsjQm1
X-Gm-Gg: ASbGncv5KlIc3LNpOhoDDPyBQ7TIkpRRSVgHjEy3rpuZ7ngT0DuSPZifpWf0wYIo2lL
	riut2h9a7N19OEIUDzySlCGf/lGUKK2HVz/+Aao+LF3GWH34U8X2AGbDrTs6MnC6rxaYNNl5zW0
	kP/9nd9c98Y9wVJDbsLGwcouzOfStNnmP50SZBhu9K0J+5cu5nBHvfixuWwSSsJ4iMCNC8ZzN5r
	jGCmyGLfi2G77Yv+xDlAlcv+FhURK6C3J2JlfMn4lID+k2cHNrvXtRXu6wYIBkkbHeuj6IOSUNt
	QxQ+9SzHjm4x+hanRnxQGIXbvns2gp6iEgKN/ISfGhBBzqt9m7GcweLmm3tDaEkjby77+t+hyox
	OM3pSm2eyIyYyC7eTp0zP3SNWjb8oeO1YFL2dCP7n7ycrH1LJUdeBoKiPy10dGS+2rFAmJt6Nt0
	0PrZSW
X-Google-Smtp-Source: AGHT+IGLt4dkwu/l/f8pyXhwZlNlKn0W2O0qaUgnRSLR4mLq5jyeTb1X/5S+ByPTtg2TX/kY2ScSqw==
X-Received: by 2002:a05:6a00:b87:b0:77d:6a00:1cd1 with SMTP id d2e1a72fcca58-7a777b47d9dmr14621942b3a.12.1762147444828;
        Sun, 02 Nov 2025 21:24:04 -0800 (PST)
Received: from dw-tp ([171.76.85.117])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a7db86f0fesm9646002b3a.60.2025.11.02.21.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 21:24:04 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Heiko Carstens <hca@linux.ibm.com>, Luiz Capitulino <luizcap@redhat.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>, David Hildenbrand <david@redhat.com>, osalvador@suse.de, aneesh.kumar@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH] s390: Disable ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
In-Reply-To: <20251030145505.2764038-1-hca@linux.ibm.com>
Date: Mon, 03 Nov 2025 10:29:29 +0530
Message-ID: <87zf934spa.ritesh.list@gmail.com>
References: <20251030145505.2764038-1-hca@linux.ibm.com>
X-Stat-Signature: 9t956kzuk13817t6kt41oeriawnb573x
X-Rspamd-Queue-Id: 2409212000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1762147445-154099
X-HE-Meta: U2FsdGVkX1/AyKCLuhNO7agDa/KrSn5WTbLSf7rRGJcDHk4OKnXBroP9ujtJ7gcBoXHMPRMLKn1A2jHn2l6KjYwB0PVkN/KJTv5AYVWT7RmEtYnbK7HcIDSvzeCoI1gFPfZwEEzmn4XZAmAubnOYcK3M+W/U7l0gkPb1S8gXJfACLPBR4K7tymZv3pitJhcK4z5tjY+suqNgL5PbH+y3Zdj9mTPx1GpT8/7d/tM+7ZwD+OVhjVnqbey3tZq03gA5lakr0IlvOltd3OU0H2ckoc9gWwGEOtdkunt7iaXiFZao7zwOF+rSn8NX/+yNoYcx3kBVKUHDCMmCPYnqpWl8Og5cPDbjXlrBjWQ0GOllpc9Bnu+hoPjasdNqj+iPuYlnqWOxYwLLaq1OURvtJJX7wzvtI5Kv3yEOte3vkXobNnjy7PiIhOhvMQQRXKkKxD0CZnkWoIAN5sajxJK6q2WfXdjDreNOdfTGDCffEA8rtQZZs87+3i4GfhZg3STxlqfwxNszwJ07krmcIbTPaHSKBqM2lSyJup081vj2qnyIWiu85bWq3vDFVQ1g2TaQ49S10NuOddchbUGnvnFp+iDsMFcTXsyeHojhecEjDSgEQhdsBbVojLNNgJJhf7a/rDjP6OTiUakJ4kwMApkiJv6XmLA55WM5bMm+DMaKJ6FT6bGQL8WALdoGbew6cH+yzV7o2JfiDkcv1Z/LrMKKn84AdRML3Lybdd7sWnTvS1ZFwT+u2W60PYO4PPVCEYKDJlM9Mho1nCmrhvhuKLPryKbDf7C67q6QqPqnW0iZYlADDmgpVp8MPdsFZ4ZD/yadzY3quhKV1EMNhVFkAFnQ19uds9m5OR6G0ffcXiiikJupWds72d5vJpvBjlTgv7m80W0ipMq/30NQ5fs1SqK3MlwCnYO8NVwTlprk2C78SBlcOzxaS1Jgiu9x0UlODzlGJ9uUaXSjQ37dW5wGnVyPpM6
 NjtqAXSN
 t3xJNK07FK3gkD0ssP5+l/8oV41Sw/QNEqMmxz6LnsY4xr3sybTu/j74L2mMemoN3A+OOd+necSN4khPLi2HFnaSTUgdlMVGwvirwYT1P9gAl3rm4ucD5Uu30iHBK557xC/egTylAK3WbFKXluYw61/ORI0Mss/7wVsN9KKSGj6IeITusbvNIk+HEnPdI7Fzp/x+1LKfUUBq2FttW+ZwNS9pyz2ujYAXaIDpM21+GtOTotZ6dceW06/fqQXusnA3B5CSCfxnMlBIwDr49xbwl2+IGF6AhzFVYyfDBV+1e2jV/KNSESmid4/ozTRSw6Pq/s369ajf6gNaVSIrCsjHEZRQFsP0WOviT+0Gz/PulhB4dWGZFUEaryXUDAIFxkI+X+ZVHjOObQg+6GTDMKYPZHLmmf31rygad+mPOm5sY9OaSAwlhu1RtFmZ7jYcH74eLVZvMcQd1bpMWtnb97sJY9UdqL7dgCsSm4ffOgRNbBxeDdwbqySjhNfzeywK/3EnrPosmn9R/vwRBjIG3PbAvSN1cuqyi7cHW3+iA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Heiko Carstens <hca@linux.ibm.com> writes:

> As reported by Luiz Capitulino enabling HVO on s390 leads to reproducible
> crashes. The problem is that kernel page tables are modified without
> flushing corresponding TLB entries.
>
> Even if it looks like the empty flush_tlb_all() implementation on s390 is
> the problem, it is actually a different problem: on s390 it is not allowed
> to replace an active/valid page table entry with another valid page table
> entry without the detour over an invalid entry. A direct replacement may
> lead to random crashes and/or data corruption.
>
> In order to invalidate an entry special instructions have to be used
> (e.g. ipte or idte). Alternatively there are also special instructions
> available which allow to replace a valid entry with a different valid
> entry (e.g. crdte or cspg).
>
> Given that the HVO code currently does not provide the hooks to allow for
> an implementation which is compliant with the s390 architecture
> requirements, disable ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP again, which is
> basically a revert of the original patch which enabled it.
>
> Reported-by: Luiz Capitulino <luizcap@redhat.com>
> Closes: https://lore.kernel.org/all/20251028153930.37107-1-luizcap@redhat.com/
> Fixes: 00a34d5a99c0 ("s390: select ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> ---
>  arch/s390/Kconfig | 1 -
>  1 file changed, 1 deletion(-)

Yup architectures like aarch64 and PPC64 keep it disable for the same
reason. However patch [1] allows for enabling similar optimization for
DAX vmemmap "ARCH_WANT_OPTIMIZE_DAX_VMEMMAP", if DAX is supported.

I see in 6.18-1 pull request s390 had "Add DAX support for DCSS memory
block devices".

[1]: https://lore.kernel.org/all/20230724190759.483013-8-aneesh.kumar@linux.ibm.com/T/#u

-ritesh

>
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index c4145672ca34..df22b10d9141 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -158,7 +158,6 @@ config S390
>  	select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
>  	select ARCH_WANT_KERNEL_PMD_MKWRITE
>  	select ARCH_WANT_LD_ORPHAN_WARN
> -	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
>  	select ARCH_WANTS_THP_SWAP
>  	select BUILDTIME_TABLE_SORT
>  	select CLONE_BACKWARDS2
> -- 
> 2.48.1

