Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBEF2CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 09:19:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18EBC8E0070; Thu,  9 Oct 2025 05:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EFE38E0002; Thu,  9 Oct 2025 05:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED25C8E0070; Thu,  9 Oct 2025 05:19:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D58AC8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 05:19:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8096616065E
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 09:19:12 +0000 (UTC)
X-FDA: 83978026944.05.9940203
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 43CDC180005
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 09:19:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PLpDn2Tk;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760001550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ym+DdkcmRG4wvpfz5ykb6s+kf1elRde6oG+aT4Hjw8w=;
	b=j+vfscj/sA3wKdqoRpz1lbk3ru8mM8qXsV2yHhaaBeFrXaEjSf5PZDjjkLpNuwufMMsWkP
	Ph82YeRAalQB6ywpqXiVFie2v2XvNtSgPIKZVNv2luLYJcNWpBzmLcua5XMTqlJ7BzUsny
	JNquPFjEHDtgdEKMv2Y3XzfwFrAoS0k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PLpDn2Tk;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760001550; a=rsa-sha256;
	cv=none;
	b=ShjO6Knp0BoBqxeuhb7Jf1Ix92hN+NTw0GTsf44aBRQzr3F1X+1Z4nikTdxgcweYTzzcvh
	MArMmQsE5azX03kxJadxU4xgN0oJsD+JadJCJG8eTjZOB5qq4Y5REfT/H06U+0A1YvSNY5
	QhqJONTo9EYRAucLOMHSgDcAtzi2lK8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760001549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ym+DdkcmRG4wvpfz5ykb6s+kf1elRde6oG+aT4Hjw8w=;
	b=PLpDn2TkF0qR74dNg4w+tzTok33vhEtBc+D3bSiW9sQjBSq2nG0GQ26usONRw12kME0ON+
	gTDVvuONLHJCTHM4wpR2V1Pa/dDaRUh6omXllTfVh+RGleH61gG2iO8dB9eFiYFMqbz9k3
	Wv+zvwT0kZIBRdyij2BAeKpqme3+Jg8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523-Of3MlfCZNOGiIDFuAMUgSg-1; Thu, 09 Oct 2025 05:19:08 -0400
X-MC-Unique: Of3MlfCZNOGiIDFuAMUgSg-1
X-Mimecast-MFC-AGG-ID: Of3MlfCZNOGiIDFuAMUgSg_1760001547
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e44b9779eso3667635e9.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 02:19:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760001547; x=1760606347;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ym+DdkcmRG4wvpfz5ykb6s+kf1elRde6oG+aT4Hjw8w=;
        b=b7o7obFqd5RRAU/cDDaCUv0ul/0Z8f9T9mnScLWRb7Z10J1x6/rIxFvlDWxWfQ0cNW
         oAwnyK+hmhFOEo5GxTCZY+ZXPBcnsGr392yRZCO+fGxKwxek3AMlGUrKBsxQgQF0H7Ob
         AChSfisQti9aeiME6nv1ymsaRsn0DqmxbvcbH2szoIs30gdKrzJQ1jlkj3ABjfeYXQYS
         AIoNGMeykmGAVQMKDUcZEAsgdDtoOokzTPeye18e04rTLq3KMX5nnjWrjhqTLsgveb/V
         8qsy5LIbA4INyAOrbm6xSL/hkgNLdT3QWpcjvDr8xsLkpxD3vrvuNeGtC2jMXxP8LYy5
         VANw==
X-Forwarded-Encrypted: i=1; AJvYcCXpQkiXOVEUaPjLwJuIZ9f5S0NiNAXXd8ONsc0hTaox3lGW3aQdpOnIZaJiT3flBmDu9jQT/RWSzw==@kvack.org
X-Gm-Message-State: AOJu0YwBShO8WeE44E25nhscmvLvfcuHAt92vgKgSAha+8Vv3xDLekns
	8kceRippvZptCMIdKtYJr4qNmZ94xUbDixBAs+o3mrZ/sZrYlzMoRMpZx3/ASN3r9QG34vRD6+U
	p1mZK7X9a2bJvmlak7pgIJfidXqLwONnrw7GSGgUJW7ebBuMPUzMN
X-Gm-Gg: ASbGncuEEw9mPHiN0Ede3pCHSsvpFF7TUfy+lc6srFqJxVXE8l0gN5hbuwY4bim+6ll
	KTT+NZ9NOBlxJMX2MZu3dT25epbgQnpc99WFXFj6swu48LessdiHl6PmT4mycfih+JcvOvoQsaG
	qbuscUKLKhNVdKRT7KIQlhwq8aQJduCYAeTc6XfNzSywF6xUAnjxiF+0ci8HAZJ/s643DbhPgrE
	23B+vyXiPlBPp0jrixmFBrvmQk1Fphmr/GSKUANzqJG9W8DQ17B82b0RzPzT99jtJ8/bFTNrPTv
	HcClbfwskzaIWWx+sZQOs2lOiZ40kmVwul4x6YzkBhoOFAI5Yq7NrwmAhUxBtjPpGWPAoELfsiQ
	mowf/4TgC
X-Received: by 2002:a05:600c:c4a3:b0:46e:1fc2:f9ac with SMTP id 5b1f17b1804b1-46fa9a98fc7mr50624105e9.10.1760001547015;
        Thu, 09 Oct 2025 02:19:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFReIJdkF3acFZPAnWeL0i3BOZQC/foYxEC2R8ZxnsgKIO/Vq2BUJi9cBf7+x2XtZK2O/u2OA==
X-Received: by 2002:a05:600c:c4a3:b0:46e:1fc2:f9ac with SMTP id 5b1f17b1804b1-46fa9a98fc7mr50623665e9.10.1760001546471;
        Thu, 09 Oct 2025 02:19:06 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6daasm34080730f8f.7.2025.10.09.02.19.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 02:19:05 -0700 (PDT)
Message-ID: <129379f6-18c7-4d10-8241-8c6c5596d6d5@redhat.com>
Date: Thu, 9 Oct 2025 11:19:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Alexei Starovoitov
 <alexei.starovoitov@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>, baolin.wang@linux.alibaba.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, usamaarif642@gmail.com,
 gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 David Rientjes <rientjes@google.com>, Jonathan Corbet <corbet@lwn.net>,
 21cnbao@gmail.com, Shakeel Butt <shakeel.butt@linux.dev>,
 Tejun Heo <tj@kernel.org>, lance.yang@linux.dev,
 Randy Dunlap <rdunlap@infradead.org>, bpf <bpf@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
References: <20250930055826.9810-1-laoar.shao@gmail.com>
 <20250930055826.9810-4-laoar.shao@gmail.com>
 <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
 <27e002e3-b39f-40f9-b095-52da0fbd0fc7@redhat.com>
 <CALOAHbBFNNXHdzp1zNuD530r9ZjpQF__wGWyAdR7oDLvemYSMw@mail.gmail.com>
 <7723a2c7-3750-44f7-9eb5-4ef64b64fbb8@redhat.com>
 <CALOAHbD_tRSyx1LXKfFrUriH6BcRS6Hw9N1=KddCJpgXH8vZug@mail.gmail.com>
 <96AE1C18-3833-4EB8-9145-202517331DF5@nvidia.com>
 <f743cfcd-2467-42c5-9a3c-3dceb6ff7aa8@redhat.com>
 <CALOAHbAY9sjG-M=nwWRdbp3_m2cx_YJCb7DToaXn-kHNV+A5Zg@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CALOAHbAY9sjG-M=nwWRdbp3_m2cx_YJCb7DToaXn-kHNV+A5Zg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -ur1poZkSca5FTCaDHv8uuDt5zDogTnlMycZN_g6JHY_1760001547
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 43CDC180005
X-Stat-Signature: i8f9tcn1c6agun8o83bh9z9gxbto7fbu
X-Rspam-User: 
X-HE-Tag: 1760001550-777848
X-HE-Meta: U2FsdGVkX1+sWpj4LhwOn4/GVostbw2u04O096G3NvgqXrMKulyuz9O4Ow9KvPUvWiiD4ME4UtepoFIkRou3YvRYxoaKRYOM5+BFMI8svhNOrM0mFVMSSbVw8J5+KRsFKb9vykIRWgHrlE9igzAqAhOWFj6wjZ/O15mqrISzhzLZY5Y/lVNfNNYAop2f2t/hJKjZR6Nu0oRFoUK+rMIfUi/SWyPU/zYct5OAvWPLotIg08SsW4buOVzGg+HSTmmlCgKQcEUkpyS8PCp21/DRGOIAi/W66AUNUoPNjbHzETJZUbYF/+cQ/bDSYpD+aviUGYAUu51nlhnFlzHlywYh/795U7f0EBFJiCmzXcH9rNw0c/ynLbkL57qf78V8WkBrfXoKAJESY5+hBLmUD2A5gIo6n7qo4Vqlhoeqf5VUTao+KMOyRxvHJv9+UDa62i1DtaJJGwShaN8AMFiztTap9GrzveEL1oheNPG5F6W0UAX9QUtRB8hszJ/YfuJC1E9LYvZq4TZ8JK3bgAq8H2ynaitx03C6krToupB7qp+rukP7WNLHV2it2QRhKqBSKfbacNlbSFsr5CUSxhqBvCp0at5gJNsyKT+QLawTMjlPmS8o0glMr94OKPV8hGdDaK6aQ2eUrfvLqRh3LjNwFx4r/Yn+/uPAaVucY1v4W7IFhV1tc+EcmJvXc2mHPGIYQM2AL5Le4p8wcj0xUA6HpDbi9gjkgSoxollt6WfDqFBR3rLLrTHrjQ7DHNX9psvEnbWWJ6r5iXr8ZpMhngnWfb1JV6jWSWKz81Dkr2Aut+mHObXpXpvHbW5Xyuu6OU4XmsA2mlUlMJihiSu3xV0oe6uPK/d+P6sWEOFmDLiTICNA1XSKuXA7/1XF/rApAzFdzGEscVQWGtKtQdrGtJUmCXHP9PGQDJmoXw7wfBjdazoX5RiTbARBvbMWzaBw8deANw/r5EV7e9C647hctTgKnYo
 aH8yLCH9
 IlglhodzPjBd6Xqk8o7t036f6aOWf2B6QANw6REegVVTBjdNdqX0ZxAEkwAkdQtoIDepMQiuj11PM7BzIK/pJZq8SeYRtIZ1RKzfjAyxIrtwqTRO9Jtl5oK8R5FXsr7ECgOUDs58VnpbL6N6I9FaHNpTcdg7vur3qf3dWoeSSV7TK71nDTfKzczFNisANPDr1EFSKjOux8PZCVTs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.10.25 15:11, Yafang Shao wrote:
> On Wed, Oct 8, 2025 at 8:07 PM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 08.10.25 13:27, Zi Yan wrote:
>>> On 8 Oct 2025, at 5:04, Yafang Shao wrote:
>>>
>>>> On Wed, Oct 8, 2025 at 4:28 PM David Hildenbrand <david@redhat.com> wrote:
>>>>>
>>>>> On 08.10.25 10:18, Yafang Shao wrote:
>>>>>> On Wed, Oct 8, 2025 at 4:08 PM David Hildenbrand <david@redhat.com> wrote:
>>>>>>>
>>>>>>> On 03.10.25 04:18, Alexei Starovoitov wrote:
>>>>>>>> On Mon, Sep 29, 2025 at 10:59 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>>>>>>>>>
>>>>>>>>> +unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
>>>>>>>>> +                                     enum tva_type type,
>>>>>>>>> +                                     unsigned long orders)
>>>>>>>>> +{
>>>>>>>>> +       thp_order_fn_t *bpf_hook_thp_get_order;
>>>>>>>>> +       int bpf_order;
>>>>>>>>> +
>>>>>>>>> +       /* No BPF program is attached */
>>>>>>>>> +       if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
>>>>>>>>> +                     &transparent_hugepage_flags))
>>>>>>>>> +               return orders;
>>>>>>>>> +
>>>>>>>>> +       rcu_read_lock();
>>>>>>>>> +       bpf_hook_thp_get_order = rcu_dereference(bpf_thp.thp_get_order);
>>>>>>>>> +       if (WARN_ON_ONCE(!bpf_hook_thp_get_order))
>>>>>>>>> +               goto out;
>>>>>>>>> +
>>>>>>>>> +       bpf_order = bpf_hook_thp_get_order(vma, type, orders);
>>>>>>>>> +       orders &= BIT(bpf_order);
>>>>>>>>> +
>>>>>>>>> +out:
>>>>>>>>> +       rcu_read_unlock();
>>>>>>>>> +       return orders;
>>>>>>>>> +}
>>>>>>>>
>>>>>>>> I thought I explained it earlier.
>>>>>>>> Nack to a single global prog approach.
>>>>>>>
>>>>>>> I agree. We should have the option to either specify a policy globally,
>>>>>>> or more refined for cgroups/processes.
>>>>>>>
>>>>>>> It's an interesting question if a program would ever want to ship its
>>>>>>> own policy: I can see use cases for that.
>>>>>>>
>>>>>>> So I agree that we should make it more flexible right from the start.
>>>>>>
>>>>>> To achieve per-process granularity, the struct-ops must be embedded
>>>>>> within the mm_struct as follows:
>>>>>>
>>>>>> +#ifdef CONFIG_BPF_MM
>>>>>> +struct bpf_mm_ops {
>>>>>> +#ifdef CONFIG_BPF_THP
>>>>>> +       struct bpf_thp_ops bpf_thp;
>>>>>> +#endif
>>>>>> +};
>>>>>> +#endif
>>>>>> +
>>>>>>     /*
>>>>>>      * Opaque type representing current mm_struct flag state. Must be accessed via
>>>>>>      * mm_flags_xxx() helper functions.
>>>>>> @@ -1268,6 +1281,10 @@ struct mm_struct {
>>>>>>     #ifdef CONFIG_MM_ID
>>>>>>                    mm_id_t mm_id;
>>>>>>     #endif /* CONFIG_MM_ID */
>>>>>> +
>>>>>> +#ifdef CONFIG_BPF_MM
>>>>>> +               struct bpf_mm_ops bpf_mm;
>>>>>> +#endif
>>>>>>            } __randomize_layout;
>>>>>>
>>>>>> We should be aware that this will involve extensive changes in mm/.
>>>>>
>>>>> That's what we do on linux-mm :)
>>>>>
>>>>> It would be great to use Alexei's feedback/experience to come up with
>>>>> something that is flexible for various use cases.
>>>>
>>>> I'm still not entirely convinced that allowing individual processes or
>>>> cgroups to run independent progs is a valid use case. However, since
>>>> we have a consensus that this is the right direction, I will proceed
>>>> with this approach.
>>>>
>>>>>
>>>>> So I think this is likely the right direction.
>>>>>
>>>>> It would be great to evaluate which scenarios we could unlock with this
>>>>> (global vs. per-process vs. per-cgroup) approach, and how
>>>>> extensive/involved the changes will be.
>>>>
>>>> 1. Global Approach
>>>>      - Pros:
>>>>        Simple;
>>>>        Can manage different THP policies for different cgroups or processes.
>>>>     - Cons:
>>>>        Does not allow individual processes to run their own BPF programs.
>>>>
>>>> 2. Per-Process Approach
>>>>       - Pros:
>>>>         Enables each process to run its own BPF program.
>>>>       - Cons:
>>>>         Introduces significant complexity, as it requires handling the
>>>> BPF program's lifecycle (creation, destruction, inheritance) within
>>>> every mm_struct.
>>>>
>>>> 3. Per-Cgroup Approach
>>>>       - Pros:
>>>>          Allows individual cgroups to run their own BPF programs.
>>>>          Less complex than the per-process model, as it can leverage the
>>>> existing cgroup operations structure.
>>>>       - Cons:
>>>>          Creates a dependency on the cgroup subsystem.
>>>>          might not be easy to control at the per-process level.
>>>
>>> Another issue is that how and who to deal with hierarchical cgroup, where one
>>> cgroup is a parent of another. Should bpf program to do that or mm code
>>> to do that? I remember hierarchical cgroup is the main reason THP control
>>> at cgroup level is rejected. If we do per-cgroup bpf control, wouldn't we
>>> get the same rejection from cgroup folks?
>>
>> Valid point.
>>
>> I do wonder if that problem was already encountered elsewhere with bpf
>> and if there is already a solution.
> 
> Our standard is to run only one instance of a BPF program type
> system-wide to avoid conflicts. For example, we can't have both
> systemd and a container runtime running bpf-thp simultaneously.

Right, it's a good question how to combine policies, or "who wins".

> 
> Perhaps Alexei can enlighten us, though we'd need to read between his
> characteristically brief lines. ;-)

There might be some insights to be had in the bpf OOM discussion at

https://lkml.kernel.org/r/CAEf4BzafXv-PstSAP6krers=S74ri1+zTB4Y2oT6f+33yznqsA@mail.gmail.com

I didn't completely read through that, but that discussion also seems to 
be about interaction between cgroups and bpd programs.

-- 
Cheers

David / dhildenb


