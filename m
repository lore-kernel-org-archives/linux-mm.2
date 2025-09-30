Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38A4ACCA475
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 09:43:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AAD88E0006; Tue, 30 Sep 2025 05:43:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 582378E0002; Tue, 30 Sep 2025 05:43:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449FD8E0006; Tue, 30 Sep 2025 05:43:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A9208E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:43:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BBB171A05E1
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:43:28 +0000 (UTC)
X-FDA: 83945428896.06.9812ABF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5579840005
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:43:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y1mgO+FK;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759225406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qokv/laRH94AdQbGGOyg7Qkb85bGPaWxiKN12cykW2A=;
	b=XJCr8uDm5ClYcXslOwtDBwebF73uO4wxpeiUm91BkF5yis64+XTwpqp6Z+F9iy2qI+lQLc
	MXVDSQSm3yulAVoHJLoBlqsSDFEuGEpcOn5i41FFhBsFKb/47eATW4B+UD96iKydxjl+xi
	E1D5atjbW8C19D3npwBe0JGC8q+ZTv4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759225406; a=rsa-sha256;
	cv=none;
	b=Cn3xGW782nEG+PdKkBnfH9Fx2XTHJeskL9sBFniWoL51z/ipkV7BC/t18Fm9hgtKFKa8/o
	4twVUe5M9ybZTlrN6/L0P93vOVQgqxaXAB1K1xuxvRBrp/edvkDvYiVrBKt8ZZw4yRrIhi
	1PF1rAavyE8vJ+dBAuLoLgyvGjQ2N9I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y1mgO+FK;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759225405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qokv/laRH94AdQbGGOyg7Qkb85bGPaWxiKN12cykW2A=;
	b=Y1mgO+FKAzigHWcpFMRHpnbrG9szLmI2dSvvyrOtONX6B5eOS3XZvsS6ObNl3leLg8x5t8
	5K+x1z5kAzWpnYa6/xiICzU0epP6/ALpGFxKRZ/B/lKiRYrP/FDZOzeIEWDDMfvjQZ4x3u
	+qfJJuwe18AcOpKf/y65pQBoMHP0DQc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-4jARTkZIOJaC4XAnjGW7vw-1; Tue, 30 Sep 2025 05:43:24 -0400
X-MC-Unique: 4jARTkZIOJaC4XAnjGW7vw-1
X-Mimecast-MFC-AGG-ID: 4jARTkZIOJaC4XAnjGW7vw_1759225403
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e36f9c651so45230865e9.3
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:43:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759225403; x=1759830203;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qokv/laRH94AdQbGGOyg7Qkb85bGPaWxiKN12cykW2A=;
        b=MmrHGkyZYifywd4qA06E7XJiqSOZAs8o7sGFa/rVYOq63b57spuOT3dUWxs0zAapSI
         ihwMgUL38wqd/Y6azN2qidEZJsYEZlX20MSBvobkeBD3DWWFKTVW5XH9Bjf5qZT/lZ9A
         eO6CZ5AGIX+EVJsVFy4CarTkUePVRjEhZ5lQgTqFl5F7WzS1Ir30XFIEgzu+jWiLyoCH
         WpJhwKTy83RB8DlCHWuk2die63veoHoSj3Ua9dsh/dz1IR5m5lvwXsr7I/VAYA9+kC7e
         X27TDS4HJhWsDDf9s+9Rjp1GqCBGyzG62ArwivhVHmvzBRFmUVzROORyIWkhfmWvEbTX
         DERQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2K9d9Plo0NaE0pwJz9DaAsb9C9eBloQmP4rf0RXl4Xula9uZDYbpXQU4e8uYLFm9H2bKOtWCMTw==@kvack.org
X-Gm-Message-State: AOJu0Yy6TdKE1t2/kZQdQD7xUFJi2fmBe4MoheLCEGeko8NySPmr/bL+
	cv9mX4b2lv9fzVh3mnY2o8htT9dqvjyVo/5HW6eMDqvtuou1snTFX0D8e9NjtTI3TfDSRbUz8J8
	RtEQPcP1ouE6aA7IARNSNmEYXJle6CvFWoPFagY1uGvcW2GdJHMDd
X-Gm-Gg: ASbGncvLlRyLfNL5TbTCF6JNdLMjha7S/hVvR31r55IKg+p1aGerwgt/yxfYMkf4X84
	b/G8uN3F6IzmA76KKwXggV8Y4dqdGWGTbZIfeXBegsRB77M+ezapwjLoq4TdK+Mk6CrdscMmPJi
	Wmcq6FOlRsHStbSY52c+gmBVqL0J8z6GEkAqI4GbD5BcakOwRVY/+VoI6yACBiM0CExo7AQE0T8
	8LRSFk2e3qD1jeNGK5UBNwzedAQo7rgyXDSNh7ihiY8pFJU3FcDtuoCAmLIqfDGEhCNMgnXp76q
	ZwxFUWF8sKZbakQyMs+0eVTg61XzG8X+aePsKBZvIep69zkfe3KPV1CwANzaXm9pnbR+xsuYgtE
	Ht+qVqwxQ
X-Received: by 2002:a05:600c:310c:b0:46e:35a0:3587 with SMTP id 5b1f17b1804b1-46e35a037c8mr154073665e9.27.1759225403195;
        Tue, 30 Sep 2025 02:43:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTKL6gFqXI2rPmAGDrKYjABjcyUMbEcXwo+xNyca8w+iKnIU3LDs/srXyhSwlLdRFbWyQ4WQ==
X-Received: by 2002:a05:600c:310c:b0:46e:35a0:3587 with SMTP id 5b1f17b1804b1-46e35a037c8mr154073385e9.27.1759225402680;
        Tue, 30 Sep 2025 02:43:22 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e5c44bd75sm9846475e9.4.2025.09.30.02.43.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 02:43:22 -0700 (PDT)
Message-ID: <5d763fb0-b216-4b6c-ac93-510fa471575f@redhat.com>
Date: Tue, 30 Sep 2025 11:43:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/16] mm: define clear_pages(), clear_user_pages()
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
 <20250917152418.4077386-11-ankur.a.arora@oracle.com>
 <5ec85b0b-9848-4cee-98f4-37953d504773@redhat.com> <87y0q4ewzf.fsf@oracle.com>
 <6743ead5-4d61-4274-a24f-13a8a8265aee@redhat.com> <87frcbayt2.fsf@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <87frcbayt2.fsf@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: K3lzbZz8wsRVU1ipc9XY3bOz3PfVJ9Lc7rte8kndNmY_1759225403
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kaywqab78gz9jizw3brduxy19rgj8irb
X-Rspam-User: 
X-Rspamd-Queue-Id: 5579840005
X-Rspamd-Server: rspam10
X-HE-Tag: 1759225406-382160
X-HE-Meta: U2FsdGVkX1+cf/jk8O1Xo1wh88my300DHx0IbhuizmwcqvzlkOfBSzmqd/lPfPlwz8k6XRJcloEcWtspSJRLTaqKCQ7gnNx8j7c+sEh00lPIfrum8/TrdGMP1Quxb6IMbDVpRpuWL+ISHkafhZBb0DELIpIR8cOR0Bd6SSuTTrwvCbD/t6FgWoXIBKuI3/H70tCiy1ZMB6rrbfLUifbB5j7zNKPIQYDPj9KIjouAe3sQ6aWlzG3QcLjLwsAH/GGl1DIISUTfgVC8qYRmeDED79iL/QJL07BHy3trRxRJcpIn/zvyFNtVrFhLJpLFv8fz6p2eQsK5h6GAh8+gZk5HHdDClMTdkeqzovEIY37yjw2sCqgnz2pNnVczJaAPnb69aptlgI3K0KWWSoe4czpRGNL14aEdkDhXSvAeLCbwzEYKb1SU4BR8jvDeYTt1juBNnv7S5DqcavjypMP50mHZ3kmCALICii3y61JF9Jv4lP+Txp9fDPecgx2pNKAvcRC0FfmtAxFX+TMbnpL0yBROPZracLsaekVZS9A9tp8+OR2Inqyx9qGBP712eWoSFwoA7Lj+3Lmo939iF3oDYid38hRd56KxJ39o9/3iQ50X6WjxBBn9JsgBGC6QFmoKaWuFSWs+GK6FUSNvycRBBnKc3+r8frocN5jlz7hclsJiARgwNpdt7HG4hAMM+Ac8kphgP8ZvIFAtoA+qm7f3sZ2hys3rtiohe+GoTBBpart+ggnvNREb4TB0wkGOl27zJ9FeEjrrih9PTAEbuhQE69PCPbJnRr6eXhcvI25uGAh73RG2zToBaftsJkKpHyzJsZOwe+robx6gFvVm3y2zBNC7AF/Jam8c1Gj8r96F/um1+aDLkqvNjHFdI/VUVno2KdiafLnQjw+s5uW7TADbvQVYdp3MxNa7A1k6KsU2VAf0n4pPttIG6QtwTIN1dmvpCyygN1jCKB+To9oxHxPaz9I
 PG5dfcB9
 9nAZMvPo8n0cYrOX1V5aMvUS2Km6lC3GgxRjMPqwNqEz8AiFAtYRU7VQp8J113gVSqUelwYV4xIgdrPTMVOeOT7oQHGJwfZoGAX3nQKKwD9kWIX9/2dkGYWuEeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.09.25 07:25, Ankur Arora wrote:
> 
> David Hildenbrand <david@redhat.com> writes:
> 
>> On 23.09.25 22:26, Ankur Arora wrote:
>>> David Hildenbrand <david@redhat.com> writes:
>>>
>>>> On 17.09.25 17:24, Ankur Arora wrote:
>>>>> Define fallback versions of clear_pages(), clear_user_pages().
>>>>> In absence of architectural primitives, we just clear pages
>>>>> sequentially.
>>>>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>>>>> ---
>>>>>     include/linux/mm.h | 38 ++++++++++++++++++++++++++++++++++++++
>>>>>     1 file changed, 38 insertions(+)
>>>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>>>> index 1ae97a0b8ec7..0cde9b01da5e 100644
>>>>> --- a/include/linux/mm.h
>>>>> +++ b/include/linux/mm.h
>>>>> @@ -3768,6 +3768,44 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>>>>>     				unsigned int order) {}
>>>>>     #endif	/* CONFIG_DEBUG_PAGEALLOC */
>>>>>     +#ifndef clear_pages
>>>>> +/**
>>>>> + * clear_pages() - clear a page range using a kernel virtual address.
>>>>
>>>> I'd just call this "clear a page range for kernel-internal use"
>>>>
>>>>> + * @addr: start address
>>>>> + * @npages: number of pages
>>>>> + *
>>>>> + * Assumes that (@addr, +@npages) references a kernel region.
>>>>
>>>> And say here simply that "Use clear_user_pages() instead for clearing a page
>>>> range to be mapped to user space".
>>> So, comments that actually speak to the use instead of technically
>>> correct but unhelpful generalities :). Thanks, good lesson.
>>>
>>>>> + * Does absolutely no exception handling.
>>>>> + */
>>>>> +static inline void clear_pages(void *addr, unsigned int npages)
>>>>> +{
>>>>> +	do {
>>>>> +		clear_page(addr);
>>>>> +		addr += PAGE_SIZE;
>>>>> +	} while (--npages);
>>>>> +}
>>>>> +#endif
>>>>> +
>>>>> +#ifndef clear_user_pages
>>>>> +/**
>>>>> + * clear_user_pages() - clear a page range mapped by the user.
>>>>
>>>> I'd call this then "clear a page range to be mapped to user space"
>>>>
>>>> Because it's usually called before we actually map it and it will properly flush
>>>> the dcache if required.
>>> Makes sense.
>>>
>>>>> + * @addr: kernel mapped address
>>>>
>>>> "start address"
>>>>
>>>>> + * @vaddr: user mapped address
>>>>
>>>> "start address of the user mapping" ?
>>>>
>>>>> + * @pg: start page
>>>>
>>>> Please just call it "page". I know, clear_user_page() has this weird page vs. pg
>>>> thingy, but let's do it better here.
>>>>
>>>>> + * @npages: number of pages
>>>>> + *
>>>>> + * Assumes that the region (@addr, +@npages) has been validated
>>>>> + * already so this does no exception handling.
>>>>> + */
>>>>> +#define clear_user_pages(addr, vaddr, pg, npages)	\
>>>>> +do {							\
>>>>> +	clear_user_page(addr, vaddr, pg);		\
>>>>> +	addr += PAGE_SIZE;				\
>>>>> +	vaddr += PAGE_SIZE;				\
>>>>> +	pg++;						\
>>>>> +} while (--npages)
>>>>> +#endif
>>>>
>>>> Should indent with one tab.
>>> Will do. Also acking to the ones above.
>>>
>>>> Any reason this is not a static inline function?
>>> Alas yes. Most architecture code defines clear_user_page() as a macro
>>> where, if they need a to flush the dcache or otherwise do something
>>> special, they need access to some external primitive. And this primitive
>>> which might not be visible in contexts that we include this header.
>>> For instance this one on sparc:
>>>     https://lore.kernel.org/lkml/202509030338.DlQJTxIk-lkp@intel.com/
>>> Defining as a macro to get around that. But maybe there's a better
>>> way?
>>
>> Can we just move it to mm/utils.c and not have it be an inline function?
> 
> Thanks. Yeah, that's a good place for it.

If the function call overhead is ever a problem, we can look into 
reworking that.

-- 
Cheers

David / dhildenb


