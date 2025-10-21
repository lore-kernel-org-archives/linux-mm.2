Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EA4DCCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77E0E8E0013; Tue, 21 Oct 2025 05:13:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72DF98E0002; Tue, 21 Oct 2025 05:13:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6428E0013; Tue, 21 Oct 2025 05:13:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 47A5C8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:13:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2253160420
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:13:40 +0000 (UTC)
X-FDA: 84021558600.03.99482A7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 415D580004
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:13:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M3uLgQV8;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761038018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bwq8Xk332uAhh4DKtFa1lxzzdC7yyx2jjgAy2lDmodA=;
	b=6UjiXQv07GR4D8adbw8EZhsetqHoDX0Q7UNQR8Nq+LQcya0j/xQGbRIKLMtrnxIB6iGQKr
	CMWniXgZy5WvMhpDA8FnVaYToR3qIAONdKkxWV6F10PGDOb3iqic9jZxxFel3g/kqprBTd
	7J/w9+50Ujlc6OBHd612QpK16XWm0Vk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761038018; a=rsa-sha256;
	cv=none;
	b=P787NXqZfTU9btExQ7QnIV1irtW2Wn12JG4kAC40JSrDP1AgNP1SGs5I4M1AA4SusRXzFT
	fns5OO3RoY9jo3qFDOFL2Np0XLZybe6pm8fwmn/4B5FsBD9jU7JU4qaVYhSx1JvOgyZLQG
	ez7wSkHbSpBm4Gle75fMH9p7nUo93TY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M3uLgQV8;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761038017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Bwq8Xk332uAhh4DKtFa1lxzzdC7yyx2jjgAy2lDmodA=;
	b=M3uLgQV8KWiP7juPxgzKKBXikDJkItLtG1aaszJatBjg1SHra4FinUECw2XoN246A0DN/r
	MOlrZpKtCWRpKF91629QCI0C2hRRAfO65JwGqaLm9Zxq6WI419QhUKfLaPUnhQtAbKdD3y
	Z5UqsWXDD6x/+adOZ3ENwKES8YAxejI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-0GxRriOLP_SweSKUweo0Ew-1; Tue, 21 Oct 2025 05:13:36 -0400
X-MC-Unique: 0GxRriOLP_SweSKUweo0Ew-1
X-Mimecast-MFC-AGG-ID: 0GxRriOLP_SweSKUweo0Ew_1761038015
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-471193dacffso34578585e9.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:13:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761038015; x=1761642815;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bwq8Xk332uAhh4DKtFa1lxzzdC7yyx2jjgAy2lDmodA=;
        b=o4sEyZoO5X1OPVHYKA8uvoeIvROkbpSTvIiJ8aGtbx6moP+JFz7+/hCuMCKVBlZxFw
         Gl/YQ6xM9DWeoqZ18sc9nLmhTSxACLz4eLCEy/SNrZ0sJjrzAaEBeSN6iuZ19bs0xsln
         8IKbS/N2nMxdiPJ4DrHZu8YfAzO84EjBt54NIBATSq3McpCPpCCFoiIK1eyuBFOEc9H1
         BkUUvDDSkgTqXhzDa5V/kXbq0MYualZ966ZfzpBBNi0yhhyw1jFv+9x3/56jYQVZgI4b
         WvezaJ7QOhUWm4R0dWMJopukgLmmrPXI2cUzsKW5Kj2jJeFmt8VuDp0z+84I56p8rq2l
         0qEg==
X-Forwarded-Encrypted: i=1; AJvYcCX6XwcsVgKy8wek4YtgWLA+QYK5+24sorsy67WX/uhlKmMJ7AQJAzA9WRnDjyTJAri3yhscLLqPDQ==@kvack.org
X-Gm-Message-State: AOJu0YzVB3J4684Qcuhv1HkTzb98PTxj5+k/gkCBgMBekQ00dy862qEP
	QHqA9cxG7odAZqft7KTm9/tlQdWMln4bETXjw2EsiAjVZrFyrACqMfeE4a9rDS3sS+5ndSq4mkr
	w88kJLKz607p979dmPr/b4G2LdMy6sgp3m3evCCd6JwHNHDBfg/dI
X-Gm-Gg: ASbGncsyC90BJqxhLzDiIDoqzn8CODSoY67MgYmHY+74untD3dD0LTTYvLn2FMSsNcq
	k9evzcQjEuFJSmBZI7jY+Wfd9HfuBETmLifpEre4hPnnXQjQqOfp05ErMSiyPk0oo2obzFW9Us7
	O0FunTY6R5tZR91pucenf9uSIVoBL3Zi4QWiF2ZgLdT/9OEX9nA9AlFS+1JQPsVk922Jl6aeQ9b
	AUfupS1XxYNpMVciQpAgBPdr2Pje+K7d4Ug2pb5F1+skpfqjvdqjh6rDroUMBjgq4hggbNyMOLo
	ZG4yib0wLl0Rv33YUZBrAb/4SBzpCEs4CaCPBKiYZ9OiGsVDrXdt8IdVhNxeiFJrmQb/B/y3ZTV
	XkMuwUk7fLoo/hQ2zGUk1uuVFCuvh3ky6c06Od9FIFE+8p0QVPGh+CIGEFu/p4R0VAy3NoiGs11
	LEZGpyVE/lfxDBjyE623g/Vf6mMaM=
X-Received: by 2002:a05:600c:818f:b0:46f:b42e:e361 with SMTP id 5b1f17b1804b1-47117931c89mr109270755e9.41.1761038014869;
        Tue, 21 Oct 2025 02:13:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFUQsPt+UtOKlwJeIhscTXaPBm3U7nO4QPWFyJM7o7igJmoIaJnRCgNqm3INkYmhMnVYLQZpg==
X-Received: by 2002:a05:600c:818f:b0:46f:b42e:e361 with SMTP id 5b1f17b1804b1-47117931c89mr109270545e9.41.1761038014435;
        Tue, 21 Oct 2025 02:13:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711442dbaesm273673895e9.8.2025.10.21.02.13.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 02:13:33 -0700 (PDT)
Message-ID: <967f61db-0ee3-4257-a44e-69ef15ced012@redhat.com>
Date: Tue, 21 Oct 2025 11:13:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] mm: mprotect: convert to folio_needs_prot_numa()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Liam.Howlett@oracle.com
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
 <20251020061845.3347258-4-wangkefeng.wang@huawei.com>
 <335895bc-c2ef-4ee1-a423-06c673a67147@lucifer.local>
 <1a97f0e2-fc97-4257-8540-cff06a789e32@huawei.com>
 <5ff1ee06-375b-4d5b-b513-7b8cab4e8139@redhat.com>
 <f1d3d11b-6ac8-4747-b2e7-952d4fc3e09b@lucifer.local>
 <719c8df8-b4c9-4a6a-bedf-d62becdb09d2@redhat.com>
 <759578b3-d582-48cc-90af-491210ecd90f@lucifer.local>
 <3ee89484-9cdf-4c50-a5db-79b9f2ca6886@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <3ee89484-9cdf-4c50-a5db-79b9f2ca6886@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Mw3D_6SH9Qq5FyrjGmIrnCXNlqi_NbqQ2wEQG03ps3c_1761038015
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: cjbinqxnir6o8a4g1tjew7dt7bs4hfii
X-Rspam-User: 
X-Rspamd-Queue-Id: 415D580004
X-HE-Tag: 1761038018-240591
X-HE-Meta: U2FsdGVkX18YkpDlxebEGFAf/Wtp8ee4dL9/hXJkKH/Z44sdgMHHWGQpOvaGxnQ87xNE2zY9XFEV3gzmzyPgvrVkPISqgBelJQtjIdiUxhCfPU0N/4MlJnjJOkDKeCY76ajQGf4cWTMY/Ffc8CuUoJ3ioeoHgMYWDmLF1yWgmqKpmIvHEP1dLyo1xmnpMMqzGyrOE34BFQ5HEwoc4w6o+EJ+4qA72OVAGuAzYlQeJYgWqyUVrTTHup1xgSG91j7TW9QXoVKcRWc46/Wz10c9QfihtQe0x4sO56qSjJ3JiBIX6jyltGpsIvWVmx0CznIFd5Kvu98BKsYHBGBXYvgGhHSRsZSb8rXTt2HpR9y+th+NE7V6rS2r2t5L4TqyyzrsAtEJ468RiD1VkS6a1Q35MhXyTWNxCstjqLoJvEGRZZ+n12CNPUoIdOFVjq25z9nHLq8tUsJh9d1eQ9QPEIN/JrAeN7PXm49WXzIaBs62DZqy1aEBqR7g+z8IS+4PN3oSBpDDsflRW4J9Js1hZvycr/Av4mpEI1FhgQU0zVxsmj/uRnpyXREKvH/WAzp9zrLBMok791YjnbMZvb2VLrTxul9aJP9LtZoMzzHzAO9WPhMKb6aBXWQ9cpS3mwaW8P5S5WPXriJOesIvwVbidUzi9uc27OhRgI+6sckQmmIUYkq2aCWzmoSwInrDqtfz7lqEJo1lb7m3kbS8njsp3dC2N/ojhIba2JfGv+D5smspHFHkDZ2v9rJmhGbRLFxfQeHMjdDzUTCqf7Bdq25SngcbF9h5XzyXN1O2A8vG+8GV+jI8yXu5SG4kG7XFlRKivJi6kaJg6DoUkPD6ydGwuv6Zolz4A9rm6aGrNQnKILVhzamAzmiHcnEpOjaFR3PZm2LIhIHWIjUhumMyDLeICNVKS0IZVUUQNBszoY5Bl0aARL7TIxd9Z3Kl9l4TH91UNINiRK9Sm/aVfMM5PGYDxgb
 XVyHixk6
 wicATIjEpcak0Qiratg6hYgT4ODBOfQ4iYTNTVeT6864iWEBGdFAVVsaUx9ntsAQf007y5zJ+KlSvyWFR/igxTQrMocjCJk6CAJVH+41r07Anzbha1zFh+Ck45+ZG9/9xDPsqJ1wjhc7BKSx1QOyu0RCYVbXAJMGAHen6ZN4PxEx5Xpfxx7ZkEFPT4ZeR6gJBsG2jrRi9BOBj8Vl0b/7qkjvZSMF2wnNPqgSy5hxKM+gLu54QYnEvfuoKmXVeq4aCPgzQZwNDb1P054cOJXKV9tJ4w2NB3Zw6qm3+pcYODAmksDzLj36AV4bk2Szj85FF0RD68T5FYdKnRTK68+b4C4McKALvjnKjCaoPpttSsb+vr6oRNQbZsJBR+A5DwLtBjQBIX/CNGB1GylQYb003c4XRtMZmNACluOmmcLIv+qOuZfDnpodqWgCJcVnS+pWlzo5g/ZAdMPrg6oyWzgN/Iy71Gcqa2nv5n/jB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 10:41, Kefeng Wang wrote:
> 
> 
> On 2025/10/21 2:56, Lorenzo Stoakes wrote:
>> On Mon, Oct 20, 2025 at 08:12:08PM +0200, David Hildenbrand wrote:
>>> On 20.10.25 19:49, Lorenzo Stoakes wrote:
>>>> On Mon, Oct 20, 2025 at 07:34:51PM +0200, David Hildenbrand wrote:
>>>>> On 20.10.25 17:14, Kefeng Wang wrote:
>>>>>>
>>>>>>
>>>>>> On 2025/10/20 21:10, Lorenzo Stoakes wrote:
>>>>>>> On Mon, Oct 20, 2025 at 02:18:44PM +0800, Kefeng Wang wrote:
>>>>>>>> The prot_numa_skip() naming is not good since it updates the folio
>>>>>>>> access time except checking whether to skip prot NUMA, so rename it
>>>>>>>> to folio_needs_prot_numa(), and cleanup it a bit, remove ret by
>>>>>>>
>>>>>>> Hmm not sure 'folio_needs_prot_numa()' is any better in terms of indicating
>>>>>>> that you're updating the access time to be honest.
>>>>>>>
>>>>>>> Also it seems to suggest that you're determining whether a mapping of the
>>>>>>> folio should be made a NUMA hint by the folio alone rather than the reality
>>>>>>> that the mapping is being considered for NUMA hinting and you're checking
>>>>>>> to see if you actually have to do it.
>>>>>
>>>>> ... because the folio doesn't need prot_none protection for NUMA hitning? :)
>>>>
>>>> folio_xxx() impliles to me that the folio independently has proeprty 'xxx'.
>>>>
>>>
>>> I would agree if it would be a folio_has_* or folio_test_*.
>>
>> folio_is_zone_device()
>> folio_is_zone_movable()
>> folio_needs_release()
>> folio_needs_cow_for_dma()
>> folio_memcg_kmem()
>> folio_memcg_charged()
>> folio_pgoff()
>> folio_pos()
>> folio_contains()
>> folio_mapcount()
>>
>> etc. etc. etc.
>>
>> All properties of the folio in particular, not folio_has_*() or folio_test_*().
>>
>> I mean the pattern is established in the kernel. Including folio_needs_*()!
>>
>> I honestly wonder if the original formulation was correct - check for exemptions.
>>
>> So something like folio_exempt_from_prot_numa()?
>>
>> Or this way around folio_suitable_prot_numa()?
>>
>> I think this is an English thing. 'folio needs prot numa' reads as 'this folio
>> _needs_ prot numa' right?
>>
>> Oh - folio_can_map_prot_numa()? Something like this?
>>
>>>
>>> To me the folio is really just the main entity we are querying information
>>> about. Not the VMA, not the target node, but the folio.
>>
>> OK, I guess folio_needs_cow_for_dma() does the same thing with MMF_HAS_PINNED.
>>
>>>
>>>> So it's like saying 'here's a folio, does it NEED prot numa?' right?
>>>
>>> I'd say: "here is a folio, does it need numa protection in this vma". So I
>>> still don't understand your point, unfortunately.
>>
>> Again I think it's an English thing. As I said above.
>>
>>>
>>> And keep disliking prot_numa_hint_needed() ;)
>>
>> Well you are very particular about naming :)
>>
>> I similarly dislike folio_needs_prot_numa()...
>>
> 
> Maybe folio_needs_protnone_mapping()?

I think prot_numa should be in the name one way or the other, because we 
also have ordinary PROT_NONE unrealted to NUMA faults.

-- 
Cheers

David / dhildenb


