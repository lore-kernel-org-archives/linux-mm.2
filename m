Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 699C0C83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 07:28:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC1798E0003; Tue, 22 Jul 2025 03:28:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D71C58E0001; Tue, 22 Jul 2025 03:28:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C39A28E0003; Tue, 22 Jul 2025 03:28:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B54AD8E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 03:28:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8A6CC1D954D
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:28:10 +0000 (UTC)
X-FDA: 83691071940.15.182E862
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2D0EB180002
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:28:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VB3zSBZT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753169288; a=rsa-sha256;
	cv=none;
	b=GBo08CZSaYkPg7zC5ZSenWW/TjeOeuVi4HWQGmEQvL1xuxvktT8TdeaKL8UO0MRd9jqI2P
	n3Vw4EJJqXRbLtM0hYEHrBh2UIAYohrjOvyt9oHCpJRioICckbnAaUYep6tKOYrsdX3L5r
	6zrVP3TJTLd1PCe7icNOuk8Kdo7eDSk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VB3zSBZT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753169288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LlcYhCh+mpdur8Xuec9Q8Rl7fYq3nesGug78KA8JyxA=;
	b=rDKEh38p2+awhYTRZ7O73Py4oHamvh+YK8dOevvfV8NT4c4LhMESkEWC4FxnVLfAb1QJgF
	GpzhAZCtlFvBA1ONm1DNKO452tkS8pPys/j6MSlY7t7+h2UnEcYGItvZnIhBWqn+SL5d29
	yiwvN+Wp+66Z2SUSAcziXPqfw5GFmfM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753169287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LlcYhCh+mpdur8Xuec9Q8Rl7fYq3nesGug78KA8JyxA=;
	b=VB3zSBZTSSPW/JNhcprHgP0WTY/9SZNPhIS8JJkViNgHD54e1c4WkJWxZSpGTYMeWn8D5D
	OVm40WNgxRgXMcYagbSw7S3rIqb5Qi4DryO0Ms1kKlosqXm6LXOKZoUhfunvDfcVuZWJWz
	Bx9YDyM4DrFvpsDU+Y+ipouzSkivXOU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-M7Av-0pWMlSZGixeSIvijg-1; Tue, 22 Jul 2025 03:28:06 -0400
X-MC-Unique: M7Av-0pWMlSZGixeSIvijg-1
X-Mimecast-MFC-AGG-ID: M7Av-0pWMlSZGixeSIvijg_1753169285
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43e9b0fd00cso30073195e9.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 00:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753169285; x=1753774085;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LlcYhCh+mpdur8Xuec9Q8Rl7fYq3nesGug78KA8JyxA=;
        b=T75buKFtQTFqRLCP7dkUyGISUTlvXhh+fvL13C7zTEMnK0yOkpO6iW89Es91zynGjo
         kZ76UcCBCQymU9P9px9j3pJIblfB46ivSK7vF5EU7x/Y8na12+135fU089avR165/3fx
         RW1nVk2aMWYIXYeywhHbUD8/JiNwXGJ/TwjktU0+PeND49kZCAt7MrgwOEGePwrV/tUg
         uaDY2nfq4n7X9gWgzdkAD//re7uOzsCMnPaN7TK/ycE8ZZAgyJNZ4VpkrXAB5coWY4A9
         6blkKRuGJhgLhBQtfqmb1aBGgaG6/jIWZrAba+aSNaDjRD8t+nLMynqPxKw93uOkc0QK
         J8NQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdeMOboDqVaDq/Zzdv3HIZ3/h3B+chgrnXavSuoZf7TjO/rN+57HzVLM+6OsLEA9TV4VmmdXePxw==@kvack.org
X-Gm-Message-State: AOJu0Ywgs+jg2kaZv8lIBc/V5LMYeLrqyEEFrbn98pLU1319t0P0WZhN
	nACKZEMRPDpeFdd+GniNzVgvYKsMcZaZsxZeI4MjZYiV0Wc0gTbM/TwgOF6JMHtgRls1qWP1CaL
	BLUNWzm0Yr4XgVCIyhIHw60h0fCO60TeOjyXg1Jb8mqg13O7cu8pB
X-Gm-Gg: ASbGncuA8SjH7E45IgQnuCumHJ0gMkIwnwkjtHd7xx/p6wQqo++kHAKZiQjdFcxM0Mu
	Up3LVrgsmAuDeMH2eoOBAMc7sfXN943cVAyRsdqkklg3ENPDk+YoOiHvi8HMudOZ0jakqOTZgGg
	9+TTwGfKnk/dyJPZlwaJG8HKfKvPae4pwIjDKvCe+/3IOgAtRi4jJMp5oM9553Cm4z9s31aGNfz
	/UGipMPdF3Mbp7dP12ChnnFkvW2zT5D0gz76aP3QK0gqCSKvD+ArU9/z3YIFpfg4IBY3xUk1vk2
	C/mPLIxnzed1bQSB67R+QtWwQyXO5FxghbUQrL4NXfubVd3s1cDscXfHHiDnLjjifcZEZMA=
X-Received: by 2002:a05:600c:1392:b0:456:1a79:49a0 with SMTP id 5b1f17b1804b1-45862727631mr20932335e9.8.1753169284859;
        Tue, 22 Jul 2025 00:28:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFal3h7GZrBj/9eVw08WSWj5annGF6W46P8sztgQLD9O5WNRuX2DX+rjlXbqp+Gv0of92Kivw==
X-Received: by 2002:a05:600c:1392:b0:456:1a79:49a0 with SMTP id 5b1f17b1804b1-45862727631mr20931865e9.8.1753169284295;
        Tue, 22 Jul 2025 00:28:04 -0700 (PDT)
Received: from [192.168.3.141] (p4fe0f597.dip0.t-ipconnect.de. [79.224.245.151])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca5cfb0sm12621679f8f.83.2025.07.22.00.28.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 00:28:03 -0700 (PDT)
Message-ID: <404de270-6d00-4bb7-b84b-ae3b1be1dba8@redhat.com>
Date: Tue, 22 Jul 2025 09:28:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 0/5] mm, bpf: BPF based THP adjustment
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com,
 gutierrez.asier@huawei-partners.com, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org
References: <20250608073516.22415-1-laoar.shao@gmail.com>
 <b2fc85fb-1c7b-40ab-922b-9351114aa994@redhat.com>
 <CALOAHbD2-f5CRXJy6wpXuCC5P9gqqsbVbjBzgAF4e+PqWv0xNg@mail.gmail.com>
 <9bc57721-5287-416c-aa30-46932d605f63@redhat.com>
 <CALOAHbBoZpAartkb-HEwxJZ90Zgn+u6G4fCC0_Wq-shKqnb6iQ@mail.gmail.com>
 <87a54cdb-1e13-4f6f-9603-14fb1210ae8a@redhat.com>
 <CALOAHbA5NUHXPs+DbQWaKUfMeMWY3SLCxHWK_dda9K1Orqi=WA@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <CALOAHbA5NUHXPs+DbQWaKUfMeMWY3SLCxHWK_dda9K1Orqi=WA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _jL1K9YjFv0me-8H3gcSr8Ni4qLFD0GuyjvCoC-GBaA_1753169285
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2D0EB180002
X-Stat-Signature: 9s8rygx1wjj8g6casebbq5tmghkwpg9b
X-Rspam-User: 
X-HE-Tag: 1753169288-656284
X-HE-Meta: U2FsdGVkX19RoROSXpwS+7Dlj9+Tb4HHRryIY5rtEYDuqFlx5buQ0SprVzmeC0OgQv43dWQ8jDsvzUFBuU8N1CKrBmLtEQOZrgUiKf2adL0fYmTTHMord5OkZEq6mQBfdO03chGgrlr1rmkFW9w6R4WB0nFT7iP7uubNYJSwe6xzT3mmMd18i6AU19hjiAstvUAMK6Um2/cc3G5tjHK+CdQFp4mAXHu/FPuSXVj38SsMeqX8QZ2p3WyVU+U77FzZStISHTB6oHTulBNK/nhFuPqvZQ4XmaOc273vvJkFCnBdtzg3cx4gFqeb3u3YG7yS54d4RI0FTzhi3QShtEbuCfARla7ICBQ5naEH0+Xg+OHayBQT0QebmmW2jS26vDs06DjoDidmo13GcL+96Np6HzFlaIoKmGOqIi1Ud1pSFSlGJ3ul9w+wPKCGAcUf8RvFmoq+duct9PswY3KLKVwRlZzBHF6Pfyc7z5ko1BUmISXjO4XKvxAblwKTIJV25yVK/an0dfA5QLkW9GsoZ+MDRaJJIhYpGoBcVBaj/lJV8MN18C0JGiqi6gg0JnUvS7e3isFO0XQD+Nx66g6FFMFpqFp6O3k21yWOlPHYV/AnhycC32AppQGjrJmbHxhhSBBoF8GUoC8lizfI4gCljDpWj32Cwcz3q+TVIS6g+DXkZ2lRlpxlkFHFyVXzywBTqPYFA6C4WMxtWEa7xpgq8COTZAzg4r1LS4iQeQqmpocupCKz83GZ09pgB+xAhHbwRYPN5c9MFkyzookJZEOkzg6d3U9EUmBVSrvNy8zc0Qtn5r4L0HAmHe6+RkNzUSc0TcQsjUOj6ZaighDGy2hnShOAA4qBhWx6J1Cpb/S/yrJpjuEHj+Z1PESSgWZlprHt6slmRnGA13Mw/4MYy7LVvWKHclO9uE2r3hS7EXVO+R+2BPLC6fmTnOKbPEZpjXmEZCxJTNmrzT9l12gEQ6re+nm
 q4gAkAZZ
 S3qm5Cnf30YZyMkopTHOphBrn5UKFLWZxUcqlhklF2ZB7hZATW4ZPwYSLc7lCm4yPmt04YMpW+6EKJqMFq+3fhSE8yzN0ykf+yFCo84HYY1s6lG3dTVdfKChlu1bligC7XC7vSQob+bTYsaUoOM9ZlzafgjTWmnlAEbghqG0+qZxMIGSIuMbtpy5KE1pv8kmMzKAX2nB7oYE9ffR6RE5XKE0S3iORGtWl0rHvUQe/lmTMqDC459GbShM5/AVpni3icva8iVjpCoRErN+YhZ9iG92fEOB6/pQ6voeB2/wFabtv4160g0MdG9N9z7stIDOiEvy+mqzAykZJt51cxOBZARS53IAv4+rOcdgLI/d6l+F/jGh2TWMsVFaCuC09hQHIzyy7GntH9nYLc1cRMDiNowQn86ZUHa3SFHkhEPSJFWqN4UqXW80hW5Zx/2RBVPqujYq6fz6T7eCDpTtsJghyZXbhhTulCG1bxXPeoEb8QBi8ZiO69/6PfGmzxWvkjQbbJyJ8YBXF5B56J84UtrRJ9QQJWMURdX8wqSWnMyBWM7F7XOYXO/ED2qhDQ+6TztrVxQWur+KJ78sb/fYNZCMPNC3azQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.07.25 04:40, Yafang Shao wrote:
> On Sun, Jul 20, 2025 at 11:56 PM David Hildenbrand <david@redhat.com> wrote:
>>
>>>>
>>>> We discussed this yesterday at a THP upstream meeting, and what we
>>>> should look into is:
>>>>
>>>> (1) Having a callback like
>>>>
>>>> unsigned int (*get_suggested_order)(.., bool in_pagefault);
>>>
>>> This interface meets our needs precisely, enabling allocation orders
>>> of either 0 or 9 as required by our workloads.
>>>
>>>>
>>>> Where we can provide some information about the fault (vma
>>>> size/flags/anon_name), and whether we are in the page fault (or in
>>>> khugepaged).
>>>>
>>>> Maybe we want a bitmap of orders to try (fallback), not sure yet.
>>>>
>>>> (2) Having some way to tag these callbacks as "this is absolutely
>>>> unstable for now and can be changed as we please.".
>>>
>>> BPF has already helped us complete this, so we don’t need to implement
>>> this restriction.
>>> Note that all BPF kfuncs (including struct_ops) are currently unstable
>>> and may change in the future.
>>   > > Alexei, could you confirm this understanding?
>>
>> Every MM person I talked to about this was like "as soon as it's
>> actively used out there (e.g., a distro supports it), there is no way
>> you can easily change these callbacks ever again - it will just silently
>> become stable."
>>
>> That is actually the biggest concern from the MM side: being stuck with
>> an interface that was promised to be "unstable" but suddenly it's
>> not-so-unstable anymore, and we have to support something that is very
>> likely to be changed in the future.
>>
>> Which guarantees do we have in the regard?
>>
>> How can we make it clear to anybody using this specific interface that
>> "if you depend on this being stable, you should learn how to read and
>> you are to blame, not the MM people" ?
> 
> As explained in the kernel document [0]:
> 
> kfuncs provide a kernel <-> kernel API, and thus are not bound by any
> of the strict stability restrictions associated with kernel <-> user
> UAPIs. This means they can be thought of as similar to
> EXPORT_SYMBOL_GPL, and can therefore be modified or removed by a
> maintainer of the subsystem they’re defined in when it’s deemed
> necessary.
> 
> [0] https://docs.kernel.org/bpf/kfuncs.html#bpf-kfunc-lifecycle-expectations
> 
> That said, users of BPF kfuncs should treat them as inherently
> unstable and take responsibility for verifying their compatibility
> when switching kernel versions. However, this does not imply that BPF
> kfuncs can be modified arbitrarily.
> 
> For widely adopted kfuncs that deliver substantial value, changes
> should be made cautiously—preferably through backward-compatible
> extensions to ensure continued functionality across new kernel
> versions. Removal should only be considered in exceptional cases, such
> as:
> - Severe, unfixable issues within the kernel
> - Maintenance burdens that block new features or critical improvements.

And that is exactly what we are worried about.

You don't know beforehand whether something will be "widely adopted".

Even if there is the "A kfunc will never have any hard stability 
guarantees." in there.

The concerning bit is:

"kfuncs that are widely used or have been in the kernel for a long time 
will be more difficult to justify being changed or removed by a 
maintainer. "

Just no. Not going to happen for the kfuncs we know upfront (like here) 
will stand in our way in the future at some point and *will* be changed 
one way or another.


So for these kfuncs I want a clear way of expressing "whatever the 
kfuncs doc says, this here is completely unstable even if widely used"

-- 
Cheers,

David / dhildenb


