Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94276CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 006CA8E000A; Fri, 12 Sep 2025 11:45:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF9998E0002; Fri, 12 Sep 2025 11:45:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC1C98E000A; Fri, 12 Sep 2025 11:45:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C7F308E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:45:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8A7C4C08B8
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:45:36 +0000 (UTC)
X-FDA: 83881023072.05.F16BCA9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 17CB94000B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:45:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OKB7xpoz;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757691934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JC2CI4cAHWKz4Z7OTnCt1fj8lUqXTuTETLUg+4Yqn58=;
	b=35lQVWvTjlI8fnWuoxile3r6BVZahErf5tgQl2DJ7D0ybNhqxw4spWwma33zV7jIx0N9vB
	xxrE2j3xScD3GGYi3/DXMH456/VXf4+I0RWm+3SEWN6YNFRBcbB5XaqT/LwIMlWLcRtsqN
	zCUHnUpA8cXXAfjkVPslcK53HbM9YYc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757691934; a=rsa-sha256;
	cv=none;
	b=6aqQlFB56iKg+MIC0KLHI/BVFU8aV7UR17LCv7kcEM5oenpPkvu/vSj8pS27SNHilaQOdr
	R9hnCrP3P55d7d5KQOADpvTLbiae1v+fgl8kfNPmhvqskL7OExqCAUC//4kxQP4Y3xSwmM
	HIonx/BS4x+/4tGto7ukH99VuGcGyDo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OKB7xpoz;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757691933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JC2CI4cAHWKz4Z7OTnCt1fj8lUqXTuTETLUg+4Yqn58=;
	b=OKB7xpozoAwtn3QYwOpD2Ugyi3MI1RWmaJh2a6H5+3icE4+QdC9YvCBe09MtRsMquz2YY2
	AaCHCi4g/v1wcGzcKd6ym5tmB/bMfbq842tb1wNCUJk/RZVI8Aw1H2E9reJhIMiXQDVtPp
	v3MGIvcYhhKkRgn5/HlZ2/jh2NZvjfI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-MZsdUUFDNuCIjbQDaKjEJQ-1; Fri, 12 Sep 2025 11:45:32 -0400
X-MC-Unique: MZsdUUFDNuCIjbQDaKjEJQ-1
X-Mimecast-MFC-AGG-ID: MZsdUUFDNuCIjbQDaKjEJQ_1757691931
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3e75fcdddbdso1027692f8f.2
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:45:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757691931; x=1758296731;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JC2CI4cAHWKz4Z7OTnCt1fj8lUqXTuTETLUg+4Yqn58=;
        b=gqPuy1vdyiGtfNebocLPGuqn2laQLEEwRf8MS8W9hIUc7DeteuZllb0vxtL0XEfrZM
         JRjyr44y2XyzHkzFEyZ9KyD98Pz5kvp+h8zT0GerKvbZgDFBodartEhnppSXZu6k/fdj
         pwnvgF/fzeLrfnq2F4Bmf2E79rTz1rYca1GTOUjLZq8vUGeTYDmBGcHtNBtDj1LMxhhm
         n/yt4VuCDj6lns0cQKtkeAv0MVTnq8xyUwq9b9930106n/TCJjd4BeJAiH+7JaWS6HBh
         eqit2l9/pdTEprDkMU1PMxVnIXuyTqOkyVyQdFKsJ3LWYvqst5q7Z5HPMq07bFWvhZmU
         62Jg==
X-Forwarded-Encrypted: i=1; AJvYcCVWqk3zRvWoj4/bC5+GIrM4Urge+TOCdmXJMjInJ1PhxWxZawRBAiX8F5MGQbJOOJWJwLg4G+ud5w==@kvack.org
X-Gm-Message-State: AOJu0Yyra81dd51PB5d+7H9E1aYx+hed9r5XOcUaIMDKIUhhIsZtt1QO
	3AL+Ed4c3qXa5UBm6xxOyPVuDhTQvX/NugSGMFwb54F4jaGKTm0Ay36QucfAgW7DpuHpL2IoJm8
	usJngpo5ONrGVplSSy2TFSyTHCsjxiAEOFkzQtJXZAgQXFVfUQDQv
X-Gm-Gg: ASbGncsI3wXVTCbfEUNbM7w7fh5WP3geKLUydJcVVydA4+WdPKD+j7cZAe9SvQheIUm
	WCn2St3xWryiO177HNJaC1HyUMQCHbRG3L6QdmgO4DQaG1NWAhlWKvvhBtlD4e+ERgqiNlquVjr
	ixzdJ+MGBtvm/OK3egjvYby5R1POGhTxORwPGwkcohA9XrO8co8LHXgFzSvo9gyQquy2bgMNmpe
	7BHpFd1Pq9Dj1bbax5YJDxC/EYFQ9xlX/R+MXCDNV3+CLJVB3tKQcaMgnJogtGEuUTQKEX3WtJE
	abp647iZfLGq/VldQCiEDlgTqW+JVcBoC3Y3htFtEKnzYq+BjY6vWbS39MLk+Z64vL/s2OZBSHY
	idBNlbxjpjB3XrihKEnBDPzincwL/WlhbGRoimp60PGFz0XcR9ld2UeWsjV2I8nGXQ5Q=
X-Received: by 2002:a05:6000:24c2:b0:3e7:6104:35a8 with SMTP id ffacd0b85a97d-3e7659c4153mr3161626f8f.35.1757691930965;
        Fri, 12 Sep 2025 08:45:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3wZ4FP/CUZoE6c9oKBRgdBnDwkqM4kZbzRp7EHTY0vrUtbsR9DPuabl9FDIIbmzQLuCApUw==
X-Received: by 2002:a05:6000:24c2:b0:3e7:6104:35a8 with SMTP id ffacd0b85a97d-3e7659c4153mr3161574f8f.35.1757691930442;
        Fri, 12 Sep 2025 08:45:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e01578272sm74377785e9.9.2025.09.12.08.45.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 08:45:29 -0700 (PDT)
Message-ID: <59641180-a0d9-400c-aaeb-0c9e93954bf5@redhat.com>
Date: Fri, 12 Sep 2025 17:45:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <43f42d9d-f814-4b54-91a6-3073f7c7cedf@redhat.com>
 <ab8c2e03-53fb-402c-a674-c2c6ab11f54e@redhat.com>
 <rapl4xr55zv2nq3jh5ulk4wvfyxa2kmbnnb4uram6q43y4cbwn@dv5m52ocyqne>
 <80c50bf4-27b1-483c-9977-2519369c2630@redhat.com>
 <7ri4u7uxsv6elyohqiq2w5oxv4yhk2tyniwglfxtiueiyofb3n@l4exlmlf5ty4>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <7ri4u7uxsv6elyohqiq2w5oxv4yhk2tyniwglfxtiueiyofb3n@l4exlmlf5ty4>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZtdgeN3WEy6PXSV-3kcMi3m9G15m-rNyGhIaH2W0rhw_1757691931
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rxro6ex9hg6qcz7qxfpu3qu1pd3tti87
X-Rspam-User: 
X-Rspamd-Queue-Id: 17CB94000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1757691933-701782
X-HE-Meta: U2FsdGVkX1+F1gXV7OP9EfH/RMJO6VzB+qpdEpgHe8iOxMYYXAIUUsTmiINu32DACRetYrW6JOti8JJgmEApvQi6+Hpio1xsfztcaizSZsaigkQefycz/LiMYeMmuxWDITLL9fvgZRacLqtWXViLAl4JBR3zj7n6fmJgv8N+yEPGu2Axke9E1dkDWbNGIer+lU7tGTetGZ9tJ4UycA4yTeRcHDlg1QlQOsi2EDA7w1SMEgEvrz0yOsw0Sbb/vs9VZC+eQyZkA2xQvCk6/W2KlGu5A2yzXzLyI/Ojd7ijdSsgv5P7af6HiOBA2wDqsz6uxlj/KzTGRhsgA0zocrKpl3h7w6/YrVV2Rp8pfjLcathFPPuPPTdsUoKuOFiixzN3uTDla1Y485dAGHcavkdBCpIUEjszrSQYfeyu9YO2KIBb5WtsYG5RrEkLu9E9OBVzSxKWhqu0GiDxWdNNl7ZJh3fjFUKrTFPmK6E6Ww/DwMdeDDbaKnK9WEshcMwfkC94yI8gR590ZO7XKY+TUG/NmYhosuJj+sJSc+8b3DMxRqCkezzwp4QrkD5ivPB7a3Q33jc/Jcwj04ZCyzCTXtMHbLMHcPzcB5Wk304qltdooZbLEOC9MzCNgvw/JpX7KhQICY+rOXGSVVxW2CdJC4HL2Fq7lrspQGFj8DWoJGTuqAIS0onHnZJ/XfWXmR8tHTV01GDUSGNDSRfUxuAphyutafAxCHfZHtOgwcPjnuhKFcxKN96pQ4zbenCZJu3fproe65KfmP8Ln07TSWDq2fv0SrErQHQnZX0YOnQeBUnHgcL/KXm7lxbrmqjUuEnD654HDTlxjAJkJ4Ll5h0a7ZpAu4yAfFr9duIw5azyabzo/K0IkrGUpzBsH2HVLzCZoU6Bw9mdOvNUFhIvg2jWocNkniVhgd1VKt0AyqRAMAX0+wtRcu6Q7mGVD5upurJ7q30jmd7Kqthm+PQ8Nh5uob9
 DO30B4B6
 1M6PRUObaEOUTo06x0q17NZorHZunkQ3bKjE8Pt8UlMzFd9Hisc00ZQu6upi5by++u6ltEVQQ9taD1OWIKLu/cOZ1UXW4dvE710RFAXgUeyisFPnBssrkyJiEB0oJec9YiW99yePojhf1YngUThaKiNUyWNd0Tex1KvdJooQTxG2xbueJa0oUq9vkWu7zIfdr6FEk80QKgAuoGLGuKXOCsmBPtn7Tjc/YlZ4IxZpS5tImRB4eoHLmMy10viH3359xbrHRgfuZFOeydpLO95caTybxcJ43dK3g9AQ8W0Uut5iWkJ2Mhrka/PIjNC9cMa94EU+nrNJ+35pijENARCv2ojwu1/h7mEC1NXLbEFYDEGse/IPcGrndUBX5NPfSHrpGDGZAb1nnbTnhv+FCFrss12R/l4GZsbKoaG1dqgstVNWOG8bPOUvWmkz3J9gkW7Zaz6ljtk2N0cxETAi2AISP/2k2WKuBkCyHOzd5MEKpwCt7gmPTQvNzGLFs8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 17:41, Kiryl Shutsemau wrote:
> On Fri, Sep 12, 2025 at 04:56:47PM +0200, David Hildenbrand wrote:
>> On 12.09.25 16:35, Kiryl Shutsemau wrote:
>>> On Fri, Sep 12, 2025 at 04:28:09PM +0200, David Hildenbrand wrote:
>>>> On 12.09.25 15:47, David Hildenbrand wrote:
>>>>> On 12.09.25 14:19, Kiryl Shutsemau wrote:
>>>>>> On Thu, Sep 11, 2025 at 09:27:55PM -0600, Nico Pache wrote:
>>>>>>> The following series provides khugepaged with the capability to collapse
>>>>>>> anonymous memory regions to mTHPs.
>>>>>>>
>>>>>>> To achieve this we generalize the khugepaged functions to no longer depend
>>>>>>> on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
>>>>>>> pages that are occupied (!none/zero). After the PMD scan is done, we do
>>>>>>> binary recursion on the bitmap to find the optimal mTHP sizes for the PMD
>>>>>>> range. The restriction on max_ptes_none is removed during the scan, to make
>>>>>>> sure we account for the whole PMD range. When no mTHP size is enabled, the
>>>>>>> legacy behavior of khugepaged is maintained. max_ptes_none will be scaled
>>>>>>> by the attempted collapse order to determine how full a mTHP must be to be
>>>>>>> eligible for the collapse to occur. If a mTHP collapse is attempted, but
>>>>>>> contains swapped out, or shared pages, we don't perform the collapse. It is
>>>>>>> now also possible to collapse to mTHPs without requiring the PMD THP size
>>>>>>> to be enabled.
>>>>>>>
>>>>>>> When enabling (m)THP sizes, if max_ptes_none >= HPAGE_PMD_NR/2 (255 on
>>>>>>> 4K page size), it will be automatically capped to HPAGE_PMD_NR/2 - 1 for
>>>>>>> mTHP collapses to prevent collapse "creep" behavior. This prevents
>>>>>>> constantly promoting mTHPs to the next available size, which would occur
>>>>>>> because a collapse introduces more non-zero pages that would satisfy the
>>>>>>> promotion condition on subsequent scans.
>>>>>>
>>>>>> Hm. Maybe instead of capping at HPAGE_PMD_NR/2 - 1 we can count
>>>>>> all-zeros 4k as none_or_zero? It mirrors the logic of shrinker.
>>>>>
>>>>> BTW, I thought further about this and I agree: if we count zero-filled
>>>>> pages towards none_or_zero one we can avoid the "creep" problem.
>>>>>
>>>>> The scanning-for-zero part is rather nasty, though.
>>>>
>>>> Aaand, thinking again from the other direction, this would mean that just
>>>> because pages became zero after some time that we would no longer collapse
>>>> because none_or_zero would then be higher. Hm ....
>>>>
>>>> How I hate all of this so very very much :)
>>>
>>> This is not new. Shrinker has the same problem: it cannot distinguish
>>> between hot 4k that happened to be zero from the 4k that is there just
>>> because of we faulted in 2M a time.
>>
>> Right. And so far that problem is isolated to the shrinker.
>>
>> To me so far "none_or_zero" really meant "will I consume more memory when
>> collapsing". That's not true for zero-filled pages, obviously.
> 
> Well, KSM can reclaim these zero-filled memory until we collapse it.

KSM is used so rarely (for good reasons) that I would never ever build 
an argument based on its existence :P

But yes: during the very first shrinker discussion I raised that KSM can 
do the same thing. Obviously that was not good enough.

-- 
Cheers

David / dhildenb


