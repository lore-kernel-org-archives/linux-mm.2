Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56E40CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 13:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88F478E000B; Fri, 10 Oct 2025 09:03:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8195C8E0003; Fri, 10 Oct 2025 09:03:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9DB8E000B; Fri, 10 Oct 2025 09:03:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54E028E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 09:03:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E6534584BF
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 13:03:46 +0000 (UTC)
X-FDA: 83982221652.30.4DD4192
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6F195A002B
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 13:03:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SqZFx6l6;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760101424; a=rsa-sha256;
	cv=none;
	b=BYTfFsn94f05SzP/cQIv4Ixkd/PfCQoV/33YJ4cSrNDxQCc+qknSMef9g33yF701V+d9gQ
	1AQvV3XX1PxIpI74O1gnsGZasn6JXYhmaYDopQPvIWEMOWCawsCeFoqetBXfX6+x7+fEIe
	E4Vds3vuWX8cYs3bzhmT0467K7DKZS0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SqZFx6l6;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760101424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kLnJfjYIG2+S7xMFcE+UUjhAp4kmavKfu1V0DmDwxRU=;
	b=jbpu/+BkvnIDrwizaYg98XJaCFqxH+n4Ow01Wh7xYxa9SiM6Yaik15k4Rwx1LvO/6AUMwD
	UQ5kshkluqTOkabNavc7xjETprEm3iDUcpRbK0Cyd8MLK2kAzkfxPzkb73VgJQndqv27yI
	bMJuLiwH+me6wb6B5n2aeRs6akH++xg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760101423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kLnJfjYIG2+S7xMFcE+UUjhAp4kmavKfu1V0DmDwxRU=;
	b=SqZFx6l68WFoEs2PTTK9Va3tMZLh7cVTrEVsWAaksoWWRTFqJnEAesrI8mpqYOlXh8pxz4
	Knppltd+9PwZDwQWYDOrhVGw/69EHvEdC8phszbQaZ1DvTzIqjigvz42gLHQjms6DGIPrm
	FK84LDMtZQRkX2GnGH4k2fuUa/UIB1s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-BRJNhmjFNgiClZVUcZ8GhA-1; Fri, 10 Oct 2025 09:03:42 -0400
X-MC-Unique: BRJNhmjFNgiClZVUcZ8GhA-1
X-Mimecast-MFC-AGG-ID: BRJNhmjFNgiClZVUcZ8GhA_1760101419
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e4d34ff05so11249585e9.2
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 06:03:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760101419; x=1760706219;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kLnJfjYIG2+S7xMFcE+UUjhAp4kmavKfu1V0DmDwxRU=;
        b=HF6TvmYFGVPdYe7pjeTlbayMmcX8jMjTwYu5skf33xmVeCHPZxK/ultn9+DauSmrFP
         aHZhd4rclHzgP38VGl0AOgA+uNMFb4WdBmK2p8HuThuTulUjKFQsztaUeGgiUwTk7UsR
         wjrz4Jsbo8uP+5O6pKQUEIzk/ff1t7L/LifRm4OccRfFnJwUbDmZRMbj5KjgbitvEbQn
         pG+Og0jiscNrejzYGNgRJsOra0K3chKJN0EDnYBD735II0Q/iCIXJpOt/3qJ5PaYf1Sk
         kSw/uK4pQ1+GNDRNzoimvTtN1rXKwFidlLyyGsrw+X256rnK3xqBFjg0hr0TGzD++3hg
         u00A==
X-Forwarded-Encrypted: i=1; AJvYcCWkBGP1xR5WXrsO1l38PPvJAmj4VGesu/wwxQflTeHA2CV8OoEdcIGA+JzGpApUES+/JEPujs2sZA==@kvack.org
X-Gm-Message-State: AOJu0YySPT554YJ9tC10iIc8r3bzXPD2NGYoUu4m6d3Tim38x8XvtFES
	1l74kxqVvMEIR66LuYRCmlbJXrEj0WfrQCzYGiF07+nE/zkl4HvSeQqyFDKUTAmWcTFuq+H6+5b
	PnoYDRHSTxdi0B4HTgBRG4xoqr/+RVLm+AKqCuy3EiOF2iUcyGRIT
X-Gm-Gg: ASbGnctnW07IFlbEwsX+fyRbma656KhGQx1QCXyiRNCOSZm/4ZcfRBejlVqMmdvD0Y6
	E0waFI2rAMEen7mg2BhS0ibsxeBMGD5brzVQk6fG2NXBXXUn77Ui08JMtxzwyPASA8C6V0X86zg
	qqQ/LYc96RT4vLItVJ+V/NjEo0FXBOyJdJ35n8jPMUXvYchoHVCkF0LXD7zpFWBGTSB5RNeVqXH
	ELfimqrqC+7WQWxPIRtD+E14cv45ErVV5Uvf6CT5e1Mtc/V8zdLvxv88HCgEYqRz9UO226Ahpr9
	ME6WQ/FZ04FWD5Um5vlV8Kz+0WYzKHBDTJrsCyK4bSakSlRitUKrsyqUws9dfddPNEsKZMxMbTJ
	+sPM=
X-Received: by 2002:a05:600c:6487:b0:45f:2cd5:5086 with SMTP id 5b1f17b1804b1-46fa9a94548mr76553855e9.3.1760101418884;
        Fri, 10 Oct 2025 06:03:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1vPYT1e4Pl84EaZh3h4YINuvf3XpFlxQHnIAmrK+VMen6bKH4v9WgR8srSEe4ly5NpDoHJw==
X-Received: by 2002:a05:600c:6487:b0:45f:2cd5:5086 with SMTP id 5b1f17b1804b1-46fa9a94548mr76553295e9.3.1760101418297;
        Fri, 10 Oct 2025 06:03:38 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab5250ddsm58327435e9.6.2025.10.10.06.03.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 06:03:37 -0700 (PDT)
Message-ID: <5a98e3a4-287b-414f-801a-8054ece14662@redhat.com>
Date: Fri, 10 Oct 2025 15:03:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/16] mm: define clear_pages(), clear_user_pages()
From: David Hildenbrand <david@redhat.com>
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
 <1b4e3a1a-eeff-4d48-9b1b-d20af1d94be2@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <1b4e3a1a-eeff-4d48-9b1b-d20af1d94be2@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vy24TlyR2sK70BLSqxHcPDsRcdt22XV32t5sZTLf4yk_1760101419
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6F195A002B
X-Stat-Signature: 8f3dgngw5gmdbqfmhm3tem6kn356i848
X-HE-Tag: 1760101424-8585
X-HE-Meta: U2FsdGVkX1/zMzC8h2KnXhacniFpV6IW5WovHJ4UOG2ElFQb3YXvhez5C2t05WvQwzMbX8GTFjlQUhu3mo7PW6qwgtdxGBDkk2aDT4wfAuJytY7CDj6au7uUzrn4PsFeUcilpDjx1DSXfGXO0FjVKc9UuwF/Xtg/lXUDY5qyd0YWmahInukeWBdknHDr6IjVyWMuQYBHRkMN57EBR6TsnyvR7jq9ETR9KIEc9YWwPiZpnivdhvL6fa+pK1JdTVgm8D6QHh5mW5OtThftCmBaHdMYyL771IXMztcIDOuIfe3LUyqVIMmuk/neQ+jfS9wjCeWZohkBZdkFNhQXzNqj7Wj+sR1FsbUuvuJ9PpvRN61jPTKswkEJdy2ZswRTLFaMdlTmf3oYpgAVYpMjH6M3H2R9/2RFQxJgtFStmpRPnXSHiPXoCdG7rHocVhAXNg2ToaJLxE7Q55yNtQry0vmV2BDahFy3OcVgji8SBl7bVW814DIjmwysO72CMO5YlAlHbPEMDXTD89/jYUYDyzcka66U7j1EIS5iK30glSTfTFfDOqSGJG1SZ4pHGmMYLmwPc+rl1wj0mUVu80dAoUe4++4Xm4D6LHDNX3/j2Cz1YbVhroXSbE1i2GfC6MO2gwXvf8w5G46iIQ+l9f3fZCMmbQxiEA8rvg1BKzF01yJTn8ewDZbdKdECur11j4RAfPfdK6BeOQUaWiFnXAXBkeH/FFULOIyt6C+eDFk1peO3PdPnnzVGZjahBqNfsBtVyCDDo6aMybenI2d+y4kW69MM0l9LoASrD26lKZJTQ1b3Ld7u10e26NwOhjTmzQaMXuaYmtYg0hIknE+hncYeIV01gLOAqePmOtbJqyGrSTroQIG7qZYSdhSNfsOvYXByEiOosqXMHkeKQz4Xkeg/Opj4+n4QFtS+QHNlATvz88fsOdkBusvc1YFfS9gzBOxiarP1AsaPUuSbEYsdhaEkLqj
 Pli8MO8n
 c1XUrGDFkvLbfIbEDWo70502FIYeeJ7BsHqgMS15LzVTZhU7q47VRQB0/WgHQITn3t1eSQbgrVHySQp1XaCHGhO8fUvGcfpUPhwsnBVkfm3Vj8BtLiw2tCSEJe9S1U7CQCr7GftNbg3rSxnTCDBKolyzakO87RWHSv1lzeoIPHWP3aoYz7rFAN+VrLNL/9HJlePUzdSNl2Uc75Vc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.10.25 12:37, David Hildenbrand wrote:
> On 25.09.25 07:25, Ankur Arora wrote:
>>
>> David Hildenbrand <david@redhat.com> writes:
>>
>>> On 23.09.25 22:26, Ankur Arora wrote:
>>>> David Hildenbrand <david@redhat.com> writes:
>>>>
>>>>> On 17.09.25 17:24, Ankur Arora wrote:
>>>>>> Define fallback versions of clear_pages(), clear_user_pages().
>>>>>> In absence of architectural primitives, we just clear pages
>>>>>> sequentially.
>>>>>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>>>>>> ---
>>>>>>      include/linux/mm.h | 38 ++++++++++++++++++++++++++++++++++++++
>>>>>>      1 file changed, 38 insertions(+)
>>>>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>>>>> index 1ae97a0b8ec7..0cde9b01da5e 100644
>>>>>> --- a/include/linux/mm.h
>>>>>> +++ b/include/linux/mm.h
>>>>>> @@ -3768,6 +3768,44 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>>>>>>      				unsigned int order) {}
>>>>>>      #endif	/* CONFIG_DEBUG_PAGEALLOC */
>>>>>>      +#ifndef clear_pages
>>>>>> +/**
>>>>>> + * clear_pages() - clear a page range using a kernel virtual address.
>>>>>
>>>>> I'd just call this "clear a page range for kernel-internal use"
>>>>>
>>>>>> + * @addr: start address
>>>>>> + * @npages: number of pages
>>>>>> + *
>>>>>> + * Assumes that (@addr, +@npages) references a kernel region.
>>>>>
>>>>> And say here simply that "Use clear_user_pages() instead for clearing a page
>>>>> range to be mapped to user space".
>>>> So, comments that actually speak to the use instead of technically
>>>> correct but unhelpful generalities :). Thanks, good lesson.
>>>>
>>>>>> + * Does absolutely no exception handling.
>>>>>> + */
>>>>>> +static inline void clear_pages(void *addr, unsigned int npages)
>>>>>> +{
>>>>>> +	do {
>>>>>> +		clear_page(addr);
>>>>>> +		addr += PAGE_SIZE;
>>>>>> +	} while (--npages);
>>>>>> +}
>>>>>> +#endif
>>>>>> +
>>>>>> +#ifndef clear_user_pages
>>>>>> +/**
>>>>>> + * clear_user_pages() - clear a page range mapped by the user.
>>>>>
>>>>> I'd call this then "clear a page range to be mapped to user space"
>>>>>
>>>>> Because it's usually called before we actually map it and it will properly flush
>>>>> the dcache if required.
>>>> Makes sense.
>>>>
>>>>>> + * @addr: kernel mapped address
>>>>>
>>>>> "start address"
>>>>>
>>>>>> + * @vaddr: user mapped address
>>>>>
>>>>> "start address of the user mapping" ?
>>>>>
>>>>>> + * @pg: start page
>>>>>
>>>>> Please just call it "page". I know, clear_user_page() has this weird page vs. pg
>>>>> thingy, but let's do it better here.
>>>>>
>>>>>> + * @npages: number of pages
>>>>>> + *
>>>>>> + * Assumes that the region (@addr, +@npages) has been validated
>>>>>> + * already so this does no exception handling.
>>>>>> + */
>>>>>> +#define clear_user_pages(addr, vaddr, pg, npages)	\
>>>>>> +do {							\
>>>>>> +	clear_user_page(addr, vaddr, pg);		\
>>>>>> +	addr += PAGE_SIZE;				\
>>>>>> +	vaddr += PAGE_SIZE;				\
>>>>>> +	pg++;						\
>>>>>> +} while (--npages)
>>>>>> +#endif
>>>>>
>>>>> Should indent with one tab.
>>>> Will do. Also acking to the ones above.
>>>>
>>>>> Any reason this is not a static inline function?
>>>> Alas yes. Most architecture code defines clear_user_page() as a macro
>>>> where, if they need a to flush the dcache or otherwise do something
>>>> special, they need access to some external primitive. And this primitive
>>>> which might not be visible in contexts that we include this header.
>>>> For instance this one on sparc:
>>>>      https://lore.kernel.org/lkml/202509030338.DlQJTxIk-lkp@intel.com/
>>>> Defining as a macro to get around that. But maybe there's a better
>>>> way?
>>>
>>> Can we just move it to mm/utils.c and not have it be an inline function?
>>
>> Thanks. Yeah, that's a good place for it.
> 
> So, I'm looking into this and I think we should fixup the arch if possible.
> 
> I now have
> 
> commit 0f90e18abec6b6080af9ee5583cbba28d483a87d (HEAD)
> Author: David Hildenbrand <david@redhat.com>
> Date:   Fri Oct 10 06:09:51 2025 -0400
> 
>       treewide: provide a generic clear_user_page() variant
> 
>       Let's drop all variants that effectively map to clear_page() and
>       provide it in a generic variant instead.
> 
>       We'll use __HAVE_ARCH_CLEAR_USER_PAGE, similar to
>       __HAVE_ARCH_COPY_USER_HIGHPAGE, to indicate whether an architecture
>       provides it's own variant.
> 
>       Maybe at some point these should be CONFIG_ options.
> 
>       Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> 
> To get started. Did you only run into the issue with sparc or was there
> another one problematic?
> 

Okay, m68k is nasty as well. Change of plans, let's keep a 
clear_user_pages() variant in mm/utils.c when the arch has special 
clear_user_page() needs.

-- 
Cheers

David / dhildenb


