Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23974C83F17
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 10:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B76636B007B; Thu, 31 Jul 2025 06:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B273D6B0088; Thu, 31 Jul 2025 06:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A15C96B008A; Thu, 31 Jul 2025 06:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 914DC6B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:32:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 134FCC05A6
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 10:32:22 +0000 (UTC)
X-FDA: 83724195324.12.9E5A8AC
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0B9471C0006
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 10:32:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A2+Js8tQ;
	spf=pass (imf20.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753957940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P4QDe8KbBOKLJQJobc6zrBQ/jJOdEvFf9AqsfgSwuAE=;
	b=SyG02SEvo4MOcR3DZYx5xzAZvB/8H42GLvx/kqW2IetesxOLNi2veObqMAaHu5am3U+OwB
	z/+5dYplQ9goAUOBKFv9UijcrOc4qrLhC+/MxOaK5WBCqhy+pqp0dvvrDLx9cWoF07uMKi
	qWLslzo0GcFi+ARcUSElgzRluWTS6Ow=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753957940; a=rsa-sha256;
	cv=none;
	b=E/W2iELtWKGTDhYTBwjy3c1v9pcMyZ+7+iG4AQ3rsdXLmAoWSKrOZB9f2ezHdqBKi96MKa
	yL3fPalIjmm8o23U9z+qp2uwqrCwncOYoI6vktCgDhZl2NZRtx7cTqp47gHUetsag4p9lE
	ScPoGIpyqBXl5kw0IdxzrfYGDMFyqY4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A2+Js8tQ;
	spf=pass (imf20.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3b794a013bcso914299f8f.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 03:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753957938; x=1754562738; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P4QDe8KbBOKLJQJobc6zrBQ/jJOdEvFf9AqsfgSwuAE=;
        b=A2+Js8tQGesy1LL9rdWFl/J15f4iTqsk217lofHrmjWMHY204XzNNgT0IUTm9mckeX
         5kDlaBJO5UKTZVxdqmj8zjaT+X5Gs5NgJ4BTaD4ODdP3qZcO0GW5OO1FpCHgVw+xDFJ+
         273CyosoKLV5n1ClgEVq0WADcc03ScgKK5yD80hxu2RrmnEThpodFOA682GuEwF6vFdY
         zCPE5HYvaf7WuI9pl46rqVNa8muGkvi+8zL1b7IfTylrNuFzRPls1d5phFkSBz5KV36d
         xMnfmU0vuuUt/bUT3KlcR7+aH1Dn5G1ZxoeD9GBck6RHTNcjctX1JIiyU66rMkC7446z
         jXgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753957938; x=1754562738;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P4QDe8KbBOKLJQJobc6zrBQ/jJOdEvFf9AqsfgSwuAE=;
        b=X3R1SSEjc2nnvN1mwaEw5vxgg07Ql/q1id9bA76+dT/sh6k7eX40G+2fCDomu+we1n
         6V3JveOTTXVLTFYKjTrVXQaW8Q9Pc6XDyGIlzeHSmCWFRluZHcRYs1gPfvfLqWnUJ29O
         Uk802E4rCddlhevYcHozsOpMiotiCglwwxKxKfkxe/WKASDZVAEurAmL6OPSH7H73cJ0
         lho8/S5W0M8KgKdxGf+RGixUD5WqTRFR4w6h+SYQwCnat+9i/c1zn/2NORVjwdM/d0Va
         X3q+jqi/FpC/RsO8wPuC7jt2/DPaKY0Sq4y/Dyq9tybJS2Gwe9uTK+US2XC2DjXpo+VJ
         w9cA==
X-Forwarded-Encrypted: i=1; AJvYcCWiJXHuIdYf7xI6Hnt2/vr+LrUr6HAqNwQ/W/tBU3rHqbQ1ixPpW5tnhM1DEy6ejnZ/k3top21tUw==@kvack.org
X-Gm-Message-State: AOJu0YwGQXoxpywTylprAJX+a2IqRKVGyjJfk9JaxN4z+LfUv2T5PQvB
	izO8sFRa1IjfBB5BGjv5OabG9wGq4qs2puKwh+UVTB0nVyreGOXgDVvi
X-Gm-Gg: ASbGncvL0mBOxjMpkj32C/TtDFKTcCxZje4k73IpoOkTJWF85l4IEZObNXSOGiydvvM
	z9Ddb4/w8yXd885xlCbLEFqSdffxq4Y6IQezU5SR1nrX4O/UstCbr8zgibK0sgzHQjBLvjRPzxK
	YHNZulIy7jAvXyMTYPbd2n0HE3wggjRYfseOcw6xWXONd0azZOSH4N04WWFI81ObW5jjizpIHKL
	OLvu8h291WQukA+d+lMMpFlQzo9j9T2c7Ph/e6VZdpxN2IlSMu2km15ORIg6veZI53yTvnnLB6T
	3mh5ljwfrE0lAhoknCcc/pH0sh4L/g1K8lU6uVj0JK+3c8WtpeilIuT0w9IXc6dP8AKqwgoROli
	sybrzlTvwybEWNJRtAncmSGtLMuR1QcPu74F0yZs+P5dXIiWsqBtmoTYlNJPP6XcpdmY8dnN4iq
	Kv2lrgjw==
X-Google-Smtp-Source: AGHT+IFodhEvytOPDh6mSNjWVs7q0+m5DzyaOr1Qj+ffoHQglGyK9LooYmMshusN83lCfsEblfcqCw==
X-Received: by 2002:a05:6000:144b:b0:3b5:f8b3:d4fc with SMTP id ffacd0b85a97d-3b7950190e7mr6335576f8f.53.1753957938232;
        Thu, 31 Jul 2025 03:32:18 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::4:3f35])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589ee57922sm21572575e9.22.2025.07.31.03.32.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 03:32:17 -0700 (PDT)
Message-ID: <85a85f3d-8c3e-4159-b186-d1f9f0c5530d@gmail.com>
Date: Thu, 31 Jul 2025 11:32:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] prctl: extend PR_SET_THP_DISABLE to optionally
 exclude VM_HUGEPAGE
To: David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com, Matthew Wilcox <willy@infradead.org>
References: <20250725162258.1043176-1-usamaarif642@gmail.com>
 <20250725162258.1043176-2-usamaarif642@gmail.com>
 <8c5d607d-498e-4a34-a781-faafb3a5fdef@lucifer.local>
 <6eab6447-d9cb-4bad-aecc-cc5a5cd192bb@gmail.com>
 <41d8154f-7646-4cca-8b65-218827c1e7e4@lucifer.local>
 <36cae7e8-97d0-4d53-968b-7f39b34fa5c0@redhat.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <36cae7e8-97d0-4d53-968b-7f39b34fa5c0@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0B9471C0006
X-Stat-Signature: ztr5npmdoun9qpkkwdniqqsii5yam91m
X-Rspam-User: 
X-HE-Tag: 1753957939-90994
X-HE-Meta: U2FsdGVkX19YjAtJeO0R8PwnPOq6JIZRea2GSd0uUbnGZh5nDyOLTxQSm7wzq724w2fHD+uBw7trQjsI/2nFeIH3uCX8lPxJPMIQwKVqvpqHSKS/+I5zhbDurQoc7GOP+x2pFyQuUtfRIsB8I1tSxJqJZ2e/FXbNLlBUinFOOmx0eVjiO4fyTCY6bLfIXDOqFcwVsjsJRTRT1ehfHbcGENKrJs6TM6ySdNS94Rr0uPWixMv+aeKfQ3FTap1ZfErxEZy6GQRgpy65fPzJUFstqVLXMVjVJEI74ChOR4S0jOvhUHUH5uROTxx/KFNZI7S6yXwwij+DPhT/OKX4icQkW9fwLNzjDTl7Edoa/Q4M6jAavSOcwbPauw0HBca8N01MKK4wB68G2mJUb5yyEzwcA17OJT1pLNxhdutMWpm7n1EbFfVRgXqxjhrUf+6vr4s78oDHwppQ+bhMiuYlEJDnmRHvhiRvHfsdTC9t05ZWupS/t9Ayfrum3eTDa6T+qJ7ZM+7Y3hPqUg9nFa6m0ayz00F9ifmF7H9KjG+0Nxbb81Z4h4KeMTGrVpSbmrmcFr2W7noS91l1gMIE2g0KHpNVH7NghHj+THH4CPiFSy3hvmX3UKInq31zvzX0ARLrAE6KW1RarGG+PoKDHVJoGOLsuLJqjiyPqN06Pf6ZTg0aF3eoDSoI/WSyhW9tJ/GDmDqsxUEKiL0hpDvrdUBVEha3nhnS7OeR0oDNJnfm9awL8zORakWqSJoVCloUg8GsM94h42+fEA/BgJ56Av5lWWCX8m2lzKaj+mKrgjVTqGnz1Bf5JmDgP5iciwa9+mKiPUc1YLyRrvl985hYsIRwTnJ7yiSlurSmK40AfOg3gBqzreTWSWA3R8v/ICrw4bwlTsnOlHjGM5HJHgJ7H9PDdbN5z7tu/ClsXQVIH/bDHdEiDifT3Anvk3p2GDOLjfGs0frgI4xpogkDdGOPVgebsrE
 kzs5cy5Z
 EVST1zCrIPR6nmU5OJ3X08B1wF9UE0CL4uoqWKL5mqrKh42yVT97f+Yp8v85XtgSFrwsnm3Qhf8Moj4P7ww7Tv2rmdujvqdXfRq1lqkGainiO40cTZdFc8+LyG3wL+oRaHrYVD2IahlF1q5jH00RjrzJLwZrnUWclnGGARoGduMFXgTOU7ndUdoARl6GpAv0L4Ys2Xz71Ti5HSvyQPnLQQB2KKv8lVtCGnGQq0ZTkzz5gW516mpWrJBBfAbrNqLpW7J4cR0tuILirofMpMhMv9hgWanZ7Tl2YbaeLg4IK1OLp/tqK4dHbjQ3vZk2Xy1FaudRsseNdqUsfQlM4qoXfSdppEWcHdCLpeMnXQc2R51HKu/iEEGuXI+NtsdlwAYbYnLVe+QxiR+Nk/2GvecQSaFUOLHeJH2+watOKrmoSp9HPD0I2/JdsbhrUycwNhM6mbQy7NgF3H4DsDo2z/Vsfrjg+ZWvwwdd1Inn9ujxv3GsONBo4hpTXZPGWVN4D9oY6posu8hU3Jf+glTlgSk0cra2fhkSct6vsOP/P+2l4U5HtOJ68PnoJxGpgAQEIG2QdlG9Y6Do5U5meh/BgrOtKSJAtrpKb3iSTid7vlP0IfRN6lwwLM/K7vjYZtw34NW9gkg4Thcw1JzwFo0HnmgO2foMulQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 31/07/2025 09:38, David Hildenbrand wrote:
> Thanks Lorenzo for the review, I'll leave handling all that to Usama from this point :)
> 
> On 31.07.25 10:29, Lorenzo Stoakes wrote:
>> Just a ping on the man page stuff - you will do that right? :>)
>>
> 
> I'm hoping that Usama can take over that part. If not, I'll handle it (had planned it for once it's in mm-stable / going upstream).


Yes, plan to take care of man page, systemd, etc once the patch makes it to mm-stable. 

> 
> [ ... ]
> 
>>>>> +/*
>>>>> + * Don't disable THPs when explicitly advised (e.g., MADV_HUGEPAGE /
>>>>> + * VM_HUGEPAGE).
>>>>> + */
>>>>> +# define PR_THP_DISABLE_EXCEPT_ADVISED    (1 << 1)
>>>>
>>>> NO space after # please.
>>>>
>>>
>>> I think this is following the file convention, the space is there in other flags
>>> all over this file. I dont like the space as well.
>>
>> Yeah yuck. It's not a big deal, but ideally I'd prefer us to be sane even
>> if the rest of the header is less so here.
> 
> I'm afraid us doing something different here will not make prctl() any better as a whole, so let's keep it consistent in this questionable file.
> 
>>
>>>
>>>>>   #define PR_GET_THP_DISABLE    42
>>>>>
>>>>>   /*
>>>>> diff --git a/kernel/sys.c b/kernel/sys.c
>>>>> index b153fb345ada..b87d0acaab0b 100644
>>>>> --- a/kernel/sys.c
>>>>> +++ b/kernel/sys.c
>>>>> @@ -2423,6 +2423,50 @@ static int prctl_get_auxv(void __user *addr, unsigned long len)
>>>>>       return sizeof(mm->saved_auxv);
>>>>>   }
>>>>>
>>>>> +static int prctl_get_thp_disable(unsigned long arg2, unsigned long arg3,
>>>>> +                 unsigned long arg4, unsigned long arg5)
>>>>> +{
>>>>> +    unsigned long *mm_flags = &current->mm->flags;
>>>>> +
>>>>> +    if (arg2 || arg3 || arg4 || arg5)
>>>>> +        return -EINVAL;
>>>>> +
>>>>
>>>> Can we have a comment here about what we're doing below re: the return
>>>> value?
>>>>
>>>
>>> Do you mean add returning 1 for MMF_DISABLE_THP_COMPLETELY and 3 for MMF_DISABLE_THP_EXCEPT_ADVISED?
>>
>> Well more so something about we return essentially flags indicating what is
>> enabled or not, if bit 0 is set then it's disabled, if bit 1 is set then
>> it's that with the exception of VM_HUGEPAGE VMAs.
> 
> We have that documented above the defines for flags etc. Maybe simply here:
> 
> /* If disabled, we return "1 | flags", otherwise 0. */
> 

Thanks, will add this to next revision.


