Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC4D9CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 10:31:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E20AD8E0011; Thu,  4 Sep 2025 06:31:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF86E8E0001; Thu,  4 Sep 2025 06:31:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0DE08E0011; Thu,  4 Sep 2025 06:31:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0E858E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:31:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A7D25C665
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:31:42 +0000 (UTC)
X-FDA: 83851201644.03.CB52B85
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id F1A5F80007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:31:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BVvLsySn;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756981900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNez6/M9s3PJsme5pRqUUeFXGJSz6E2jhwKDhn5HC94=;
	b=lZrgYOnfjLQOovx7FHkhP2ALHA8ktqaexM35Mqa7FZy+oUSMEbGV/vx1tCgyEe99r7Wqjd
	9an711BsUhp/AfRcYmqdohhOwFN6pXjsocM21fCRWDYTK2ExgPheRz0bYjrcTa3dwXIFXS
	0sTD0LyHKN4iGLb6L5ABqiu5Rcpg40o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BVvLsySn;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756981900; a=rsa-sha256;
	cv=none;
	b=3ifSc5HFTgX3h8C1LuT9MPdcL3sKaip9soLmVR0uUHEneoKcwsuewaRv3RCLkLBLRejxRV
	pjOFADnDfOsia/IFpBzdatQKz/b41+mUC+kpynXuzHnXQywKQT0D9d2rLNRWsfTu7K9oxM
	+GoyZkNrJuoqiFp+OyNqzk7MIjVxSTM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756981899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iNez6/M9s3PJsme5pRqUUeFXGJSz6E2jhwKDhn5HC94=;
	b=BVvLsySn2Hwf6rXwH2Z9ZUCK+yYkU+jYQ9gXbbCh3/Nk8Ypejf5Kh7m1VfKkkO+HRg6E93
	v4My+bik4rLAaLYIsGv9SshOZdmNau2OPOXRbn55FKvzLHytAGhD2cr5wBUhe4xYALx+UD
	s/KmnMzQ7QkcnlfhWV3x0xtPYz3TeEI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-kqroy2-7MvimJ40WgAf0bg-1; Thu, 04 Sep 2025 06:31:37 -0400
X-MC-Unique: kqroy2-7MvimJ40WgAf0bg-1
X-Mimecast-MFC-AGG-ID: kqroy2-7MvimJ40WgAf0bg_1756981897
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b80aecb97so7363365e9.3
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 03:31:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756981896; x=1757586696;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iNez6/M9s3PJsme5pRqUUeFXGJSz6E2jhwKDhn5HC94=;
        b=BOSEOkOOUTVcTKzgjYDii/RPajzOY+2ADAI/fTy+GmXaoVhUVVrcPPeZa+mb/tu0XM
         uORXUbgSDPRbYDCy0NP2i2u8sTliboYrd4uncvLiUYyZ0XcKQcszWarZO2H8D8AOAfkM
         z8aAbDN45WNKnCwxt0qGhT0MU7Q2l+RA5lD7zWZuAUf7d0oTaRzkap6RIYSxOmFx+LZM
         ujtD4a74B5Mq7aPcAHfOH7P8huK7AEqMIza+qG0uhun/iuvKUSn5qjHlSRY7BDmfpyiQ
         u02m30vUkhPXcmVd2FsguAkj408+SCWGvgum92quan3dfKpABMKHXHju+6znStbbQ1D3
         XCOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVOVaK5Sw8ol5uIc46LrVpa+GeiF4VtkO/snWge6MTnAgPg9XTj6ZxTYKt7ZGpqNy0ORxjX5cfcg==@kvack.org
X-Gm-Message-State: AOJu0YxDEaGiAw+G+sqmTZjDuXOfFJARWObS4z6HzahQb/b+AATfq2gp
	t+SsvbLhwBV5q9L09KBvZjA1ez0YJpYeWTRjtVMlxrH4ynUskfKL0U/UVy48GLTfKJqK/gtSCO1
	oXDwBw44ocsJIOZDqCNccQ+MZQDoJU91CMb1fT6x3eDC95I4m7IVW
X-Gm-Gg: ASbGncudM6srylhVlmNzL5fz3QvaFJetEz6+/pZ0sqnMoEgNy7ucmHzDO7IyBPeCBdW
	Xs/SOxdUfWOI41GARPcLlIm1lQGDRLreCyxeU3RpXBF5OKcp6UpYvCqbNSAVloObX+4PPQhTvKd
	1HkDs8fsl3MFTPPjQORps3kKhk2+gznZJZkGLYA+Wy6OYtXc0HeZhjS0sPyYtxS9Qy/bjxZOJEQ
	TCLWrdxLuQFgxdqsv/wR66SgXaBw1K/0asV2K2vLJmvUezae+/CXXWsRN0qrlJ2sFIb+VnfTRXl
	k9XqajeZ7Mm3U4xpwbmJWjALX/srQcCzE2/gLLsKHSKKX0qDH7cjUAfJMRT9tTe5B3o9qWodsYx
	zFqao+oR7TqX5nUqfqts5bndm8iDkTCCX5zqpG0OjFBWrWCYS3HHwfwiKrJYpEGui
X-Received: by 2002:a05:600c:1386:b0:45b:81ad:336 with SMTP id 5b1f17b1804b1-45b855340e4mr168285035e9.16.1756981896476;
        Thu, 04 Sep 2025 03:31:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG3MLtM5QDjEU/zOfZe3S/gDem/oxe78HJp4IABGPJ9GtWj8bc+E5LqhZjiV2Kjt/XWKXc5aQ==
X-Received: by 2002:a05:600c:1386:b0:45b:81ad:336 with SMTP id 5b1f17b1804b1-45b855340e4mr168284645e9.16.1756981895992;
        Thu, 04 Sep 2025 03:31:35 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d7ac825b88sm14277593f8f.7.2025.09.04.03.31.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 03:31:35 -0700 (PDT)
Message-ID: <0ba60468-fc6d-4f07-a9ea-e16b8bcd5575@redhat.com>
Date: Thu, 4 Sep 2025 12:31:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: tag kernel stack pages
To: Matthew Wilcox <willy@infradead.org>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20250820202029.1909925-1-vishal.moola@gmail.com>
 <96148baf-f008-449b-988b-ea4f07d18528@redhat.com>
 <aLdLDEW2d3hK4gUV@casper.infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aLdLDEW2d3hK4gUV@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -p9goVbWpLeTOjH5QHOvC2kr9KM33nIik9LU2t3-bBc_1756981897
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F1A5F80007
X-Stat-Signature: enc1jj379fbf5g4oronb1gu1b41jdzd8
X-Rspam-User: 
X-HE-Tag: 1756981899-992244
X-HE-Meta: U2FsdGVkX1+VPpv4WwSFRuuTk9mmR+bnv/O1YLpVqEIEh3X0rrvaRNpB9SwSl6nouL6XheE9g/yrIvKP5EZ5sB829NZfZ7baMmmGdhHE1xwSfXchOTjT8rSAjU/ncXHBuDLGm0s5DqauUZRLc+BQIP9J7ZaV3reaIFvsKY+eSd5RvC8o7yx9H+NFQJzSVZ2kalh+t6YRNHJHTpgn6uLuXuf+91pkaEfHOPLT0AH3UbDos4RaVPiWsmIlKCmSc34JCaPcpMvozqsdIclaGMXxlHNvx1Bo3d2sx9HttAQYw61tp+NbYg5J5qwRQTWeB7NswjX4fVwTxKUU+TfMRpjqmB8Lfv/KFzqLnZ0Lq1FJ1xMnki7u6LI2UruCIY+ODhmFrpduQaTKAK1lUDwvxzFjQvrq9+PsKLEzKuxPjzGda+K4QAEDLO596Vzui2NIOYhHWeekynnwGx0q4yCBlrXHNx617f7OA/MTpwcyz3M5V2wqhgT+pUPymTrkVK1vc5nYYPOCWzuPCEDmp/SuS9FSnBrYbi6MJix8RfieeVkxFy4Y55v9Sw/gLd8JG4EI2WTxAV+xWVlDv9WTWkfHSSq1utbbOLCL7kHG0WZ5fYWNJW2sRJY7FLKWkWYVVjT2J+ZVWyTC8z8Gf7dGNPDM9O2KucjjNZGG4VZDo8OYEhiZ3QTr/7vmd34uxiMJYvq9wsfmsE11ssMu7jqc0NrV/6uBV0euOVA8mVqygG5T1lXyKe2feOT01eIbllbw8rMIJua4uoR0ESc403Pn4IKmeoXGYZwMB6EcqKi9mer8ndFlucHyG1+YNccMHvkWS4SEtAAAK+w43COd2f2l9YMDjXqVq6HFOf9dHWYq5KhACTVtdzNcZvp3qhV2O/JtwXcMeWIvIlH41gnuSnqrF2vTvFIzQvy2UtO8i5iFMNNgvKH6xtbt1XxswaCJWmqfR+hkksIJMSCzfoc7y0po7ipviHq
 uu/3Mds4
 n7txHQEnbqTkPwGbeBCC7oeb94eGXyPZF5Ezhgs0zk2fcEva2C8r72jKZ4YfPq5pywW+nvmwb/YiVjvw84fKJiMawWR39AhD9lEQbmxEBI2Ds8UgDuZ8iWM4qnrzBv5RN0eHSrlJfE5ExidHyOuj9ixKSu6aHus3yL09jkAD4L+UnL/BNT2amRXUEEU4nb234OaRb4SUjm6S47c+4PdK9U8GfytHx8LbF8UYsDUKDQhmIW4BlnN3iHR4KegJSzkQyun0f5HX4AmeFl+tFHVhkGMbBmvwVWEM+0jDrOaAtqOA+pmu+5q7sSuys++iFPe04OPkRJ4b+0HPKXWnQKwNn8TMTbm6v/c+6Bz7KWbe0FqBrb8NtzaoJ0b//SySYaifQ79BBS126rWrBX+hSAkkraBAGR7gnpZohTbSoXe6vvW1DTo15Ol9htBTaTE0+SbwVpKmQkQn2S0klRcZrgDLGgZreJdvf9t6GS59agHI7XBB16ngnb6/pPp55TMkrYXXohghaseDFN7HalyNdoKru3g+1oJSptax9g5ioEm9pPcdU2Zg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 21:52, Matthew Wilcox wrote:
> On Thu, Aug 21, 2025 at 02:44:31PM +0200, David Hildenbrand wrote:
>> On 20.08.25 22:20, Vishal Moola (Oracle) wrote:
>>> Currently, we have no way to distinguish a kernel stack page from an
>>> unidentified page. Being able to track this information can be
>>> beneficial for optimizing kernel memory usage (i.e. analyzing
>>> fragmentation, location etc.). Knowing a page is being used for a kernel
>>> stack gives us more insight about pages that are certainly immovable and
>>> important to kernel functionality.
>>
>> It's a very niche use case. Anything that's not clearly a folio or a special
>> movable_ops page is certainly immovable. So we can identify pretty reliable
>> what's movable and what's not.
>>
>> Happy to learn how you would want to use that knowledge to reduce
>> fragmentation. :)
>>
>> So this reads a bit hand-wavy.
> 
> I have a theory that we should always be attempting to do aligned
> allocations if we can, falling back to individual allocations if
> we can't.  This is an attempt to gather some data to inform us whether
> that theory is true, and to help us measure whether any effort we
> take to improve that situation is effective.
> 
> Eyeballing the output of tools/testing/page-types certainly lends
> some credence to this.  On x86-64 with its 16KiB stacks and 4KiB
> page size, we often see four consecutive pages allocated as type
> KernelStack, and as you'd expect only about 25% of the time are they
> aligned to a 16KiB boundary.  That is, at least 75% of the time they
> prevent _two_ order-2 pages from being available.

I assume, ideally, you'd also know whether all these stack pages belong 
to the same thread, not various ones, right? ("context" can matter as well)

> 
> As you say, they're not movable.  I'm not sure if it makes sense to
> go to the effort of making them movable; it'd require interacting
> with the scheduler (to prevent the task we're relocating from
> being scheduled), and I don't think the realtime people would be
> terribly keen on that idea.  So that isn't one of the ideas we
> have on the table for improving matters.

Yeah, while possible I am also not sure if we always want that.

> 
> Ideas we have been batting around:
> 
>   - Have kernel stacks try to do an order-N allocation and vmap()
>     the result, fall back to current implementation
>   - Have vmalloc try to do an order-N allocation, fall back down the
>     orders on failure to allocate
>   - Change the alloc_bulk implementation to do the order-N allocation
>     and fall back
> 
> I'm sure other possibilities also exist.
> 
>> staring at [1], we allocate from vmalloc, so I would assume that these will
>> be vmalloc-typed pages in the future and we cannot change the type later.
>>
>> [1] https://kernelnewbies.org/MatthewWilcox/Memdescs
> 
> I see the vmalloc subtype as being a "we don't know any better" type.

I guess this could get nasty once we would have metadata assigned to the 
vmalloc allocations (struct vmdesc).

> We could allocate another subtype of type 0 to mean "kernel stacks"
> and have it be implicit that kernel stacks are allocated from vmalloc.

Yes, that would work.

> This would probably require that we have a vmalloc interface that lets us
> specify a subtype, which I think is probably something we'd want anyway.

vmalloc subtypes don't sound like a bad idea.

> 
> I think it's fine to say "This doesn't add enough value to merge it
> upstream".  I will note one minor advantage which is that typing these
> pages as PGTY_kstack today prevents them from being inadvertently mapped
> to userspace (whether by malicious code or innocent bug).

Yes, as raised elsewhere, if we can do this consistently today (stack -> 
PGTY_kstack), fine with me.

-- 
Cheers

David / dhildenb


