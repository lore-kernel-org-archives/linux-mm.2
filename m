Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05E13CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 15:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B7966B02A1; Tue, 26 Aug 2025 11:29:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 367E06B02A2; Tue, 26 Aug 2025 11:29:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 256B46B02A3; Tue, 26 Aug 2025 11:29:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0FD826B02A1
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:29:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B9A21401B3
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:29:28 +0000 (UTC)
X-FDA: 83819292816.13.7FA8AB3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0B98F140003
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:29:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ScM4Zifz;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756222166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=do4WI3cnFIT5RXypWP+bXcW94By+P7ccCifFaWq58Zk=;
	b=2etaTtNhM7Co7Pyrxc4okSq18/QIBKPeOqjArcbfPZZBDkVcyGttcZyyhDMtCzPClMIZPT
	uQa+ZgVKlHIgMUQ5l0j1maRo5bWEsHzoivroGHjnynGmo7ExdJ4JSDMgT8CLLswvAVLkhS
	rjVwv/SVhKmnqg10yr3imeXcniPYXs4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ScM4Zifz;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756222166; a=rsa-sha256;
	cv=none;
	b=pbFidXqW1bX2JcvgoWrrvGAkc3nzUAj9CTX2UJBpjoUXdUTp2rUq6Vcv9CkpOupixacvd+
	lIlQsksx/iFdFsyR9J+PFrXuMcXMQBmzF8oP/TlzfudeyZ2hZ34rS6N+QcwWyR8gnPh0HU
	PcWHSS2C4MrvSO4Yz1nhcC8Wf9SOQU0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756222165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=do4WI3cnFIT5RXypWP+bXcW94By+P7ccCifFaWq58Zk=;
	b=ScM4Zifz6gI8u9YO6SsrLHJxD9jh7SZckxU/zjz1J2DG8R2Usce8OyWUeFyMQzXSnZ+e7m
	uUSnMnfQDiUZKJPJftWsSUwTkdJ7ub3vb5Hg+Vtj3OpKQeI3newbbRxp/w4BwgjtFJkl2+
	8VKVJugAKgcgqbktohMnU3bbotGRxl0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-wQ17IkOONhqscIkxJXri4Q-1; Tue, 26 Aug 2025 11:29:23 -0400
X-MC-Unique: wQ17IkOONhqscIkxJXri4Q-1
X-Mimecast-MFC-AGG-ID: wQ17IkOONhqscIkxJXri4Q_1756222162
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b05d8d0so40712925e9.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:29:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222162; x=1756826962;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=do4WI3cnFIT5RXypWP+bXcW94By+P7ccCifFaWq58Zk=;
        b=WBIKJoaRAH/U/prfNUEBRacfqbPOT6Q8JADFUhwFp5EyrDWjzKgiF8DG1DXam9kEvQ
         0IssYfuTpVA6pZU2MpNlujzujFJ4+1nidkIkYc7mII6gKVpffzYpOHFavjHv1aA3kCJt
         D2kibi/6FDKanwV7NCb1Awpk4n0PD30UoM9Ad7m4lDO9hERTfDB6h/UvYl9oO6AlpVLs
         fVCW0GFCYKM26exshkqkFnHHOg80Rbei0eTQPwW5FWDKyC87fdfPH7PAMZiCHy29PkV6
         cKvCkfGpb/tqA7in1tVBYyTjotTDm/VU0nD+K/ki6O250d4UQzzEf3dXbkLzx6M8440F
         tMEg==
X-Forwarded-Encrypted: i=1; AJvYcCU0FellkjNrd2E62Z0sZqiSlxQNUZY0ps4v9I5zXmgGj22vgUGtKvMd7RqXmz2O3hvlYBfLNZjvig==@kvack.org
X-Gm-Message-State: AOJu0YyPgM43E9URyw0fF0k+9o5gA6Q26ugGAGnTxfNvpHwFWiPUTEbe
	2ruIxkcuc1r3DClkPaNVdJViYOL7YfKsyN19Ser5PK8FHbR3sLhY+Zi3rMewfTgTdMxgLPaNoAM
	KVc48hanPlQFiFyD66h5czKUkDrhKhkTlDIqXGpO+RH8G4CZV7t2H
X-Gm-Gg: ASbGncudXQ3rhnfK7fPnpPuxeFugyf/Q705OS5Vd5XeUZvWH8h35+6lUJ6ttm54/gj+
	73t16AnPoTg9jiCoIl7yw/B289dmovAGxt1soq1owMfW57vkvG3IXsZLWjgIckwXL7E28jrtIW+
	DARDik0mLC+fWGgZRf6Kw9YtlYB9HKs/iBZQEf8KgBvFp5Kt3iv7nSd8dGe/J88ODtpOB9IfRBD
	BBCxk8ykHqvvdWq0pXN4p4JfXegQoZe+55V+KCsTrfw6jQvSADzOhfAp5XUzdEMW+wVDZUJiSTF
	ZyR8vXMTx/B8J6BD+JVGl3P74+3me1uNjj0fMT0/JfyZNtqvHyBWtdgasHNDVnvh53J4qt25CA=
	=
X-Received: by 2002:a05:600c:198e:b0:458:b068:777a with SMTP id 5b1f17b1804b1-45b517d2dcemr166931905e9.30.1756222161898;
        Tue, 26 Aug 2025 08:29:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHjuleVZkW2DNolLWkkCKtnMy1FO+l/+yq4s46DCO60Q2NyuR0T7hKxNuT4OlPeWKxwsUu72Q==
X-Received: by 2002:a05:600c:198e:b0:458:b068:777a with SMTP id 5b1f17b1804b1-45b517d2dcemr166931635e9.30.1756222161495;
        Tue, 26 Aug 2025 08:29:21 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b5753550esm156005865e9.5.2025.08.26.08.29.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 08:29:20 -0700 (PDT)
Message-ID: <01a9a40d-b19e-4730-8771-2a19a01f7788@redhat.com>
Date: Tue, 26 Aug 2025 17:29:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/pageblock-flags: simplify MIGRATETYPE_MASK
 definition
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, vbabka@suse.cz,
 linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>
References: <20250826093148.30190-1-richard.weiyang@gmail.com>
 <20250826093148.30190-3-richard.weiyang@gmail.com>
 <a78883c4-5b71-4880-8d6f-ebaebba7d1d6@redhat.com>
 <20250826151926.re6p3yemvgcycosy@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250826151926.re6p3yemvgcycosy@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: o7gzI7QUzzezt7HWoWo6lQaXCZfVLaHMZ4X0QkvC-oo_1756222162
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0B98F140003
X-Stat-Signature: sy6jdug6cjqhrrpmb9bjpiajkjxkootz
X-Rspam-User: 
X-HE-Tag: 1756222165-383967
X-HE-Meta: U2FsdGVkX1+FZRXlPKG03Hxb0xsmSEKZZ+kWOqRKocMq6gjGwnrHDrjExoC27k7xO+GVyaAnCTLn2s1UcrFAvUbNb7Z+bw1p6LBBmlWmPOelR/a0srM5PpF3fMfpSQZD5Op4zeuJtFBVQl4k/ZsornWrZ7OXH5bKUP0cHrYxSNHqqMpxAUv87SsB9S/7WmbpN9tNMqwYjxNuK6YsqgaIwyUJN7tdTbgvcJRCd7QCokK1dyZ6pSV4RO26nm7KD62hfUPiY/303vRMyWkEtQT4sRXmUt69SsnEjqboBfjQ7nEEkDEFu7b3Gnosb9XGyPwPEyxeEcLmC7jgA4XbTbxCgIdzMqM992BH+OuTwFX1gTkAeLNcVvoSdyX9iGFYC4ya4Sl9W6B0CNHguS/pTb+Zxiq8MvPhVxTqKS5owM56ZCZP5rSFz4kjdammEuWO/tgcW1bXgNRKDb1J+RcaCX/erIwJ46EpPkWhWiGHWi8RHQ0tfr3nHSHgWXsTVWbDbosWYshC8ZSdXCHZQsHs7GEbVIPiaVQZ5SrW2SQ6AJ0/a8AJ+ypmXlb6LGjqhWRNmlcUtgdQm37ClLkskXtqAw2wgJCIBiyV85ScXk8wV3+1ZAHL6Ty193kDZJjdh2nTQQ47SINRf1nVkFhyTlV1vH4M4D32zvNoTr3/QjWeEcLLM16zruO3kN2aBX6XC+mb2FrMwtJ6nKzVzm+U+ox5rS5T45fFCj3Bzn15CvsczenBAtjJwPMyIJnCT0ik6C/1Vw/jtop39tuGtSIjlIJPK9pl+W0rEnUHwIaGrIpQm5KOZm8djCOgnrLf6DtCrI76/qskSARKZfguXj4ew4++yDiclVWsBVWf5Neu3t9s0yOSIMWA9+TFiWWPMz+TeNAg/b+YO7mFMFV0z0nYF17aFtUmyjmwJRYG9e91y0qh20U5HPIBVdjfAqMjyfZ5thaHyENien444GTLjshrPyFoMGi
 Iqp/K2vP
 J9vZprHBrx5aXb+CM9W4+xAFU+8g3G8+KqVoJvJAXcW+Af+8w9VEeur3zkpp8V8fMUUDAREsGkGbjmVyg6qx/73Reuhd0fCrchC9BS5lvBq3tgZP2Lu5dgTtO8M4ke2k5IBqMyUPr6Ky8scKmNI3SS1BgZQ4foiVafR09exMJVIywNVPq3+Sbg8WXUfWqdFRRDJtWKsh327Rym9sdVnrbcRKy8//iYLpgfHmRz+HTqDJqmqXIVRX8SioQtsvZSwq7MD9C3gHGTv36gGNxBWJkUH76wPCHo22kRsEw1npxj/k1Lwz2mZU4M3Oc8cOcxd21vQjMZGHsIpD9uRrUSwXPJHfI2KBMzbAmnHe1lZzJkXwpqPP7MC1rQxZHW1Y5cv3+EsJmBXtM1OkNii6Ee/qYrpu+DljmbTsnwLOiEGvO7QHwsRvYAShdg0lKlMo8ORVJZkCSQFUF+OWBxaLf4yXtFdYyfszpoUbgmg396rhd+DxnkNwcQZWJlIs0HEO66oZxTEysmGeU0uP+OG+Q5pGhYa/VFCImiPvfGKSpf6BOtWoMzW0JAYksDwuPXiGzEmlac0bxmPqQiX/0Y95HxRXK+/JKteHvGB9MGIWGikNQ8unwLII=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.08.25 17:19, Wei Yang wrote:
> On Tue, Aug 26, 2025 at 03:34:13PM +0200, David Hildenbrand wrote:
>> On 26.08.25 11:31, Wei Yang wrote:
>>> MIGRATETYPE_MASK is defined to be the mask of possible migratetype.
>>>
>>> Define it with PB_migratetype_bits directly would be more clear.
>>>
>>> Also, MIGRATETYPE_AND_ISO_MASK is MIGRATETYPE_MASK add isolation bit.
>>> Use MIGRATETYPE_MASK in the definition of MIGRATETYPE_AND_ISO_MASK looks
>>> cleaner.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Vlastimil Babka <vbabka@suse.cz>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> ---
>>>    include/linux/pageblock-flags.h | 5 ++---
>>>    1 file changed, 2 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
>>> index 6a44be0f39f4..1489c062a5a7 100644
>>> --- a/include/linux/pageblock-flags.h
>>> +++ b/include/linux/pageblock-flags.h
>>> @@ -37,11 +37,10 @@ enum pageblock_bits {
>>>    #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
>>> -#define MIGRATETYPE_MASK ((1UL << (PB_migrate_end + 1)) - 1)
>>> +#define MIGRATETYPE_MASK (BIT(PB_migratetype_bits) - 1)
>>>    #ifdef CONFIG_MEMORY_ISOLATION
>>> -#define MIGRATETYPE_AND_ISO_MASK \
>>> -	(((1UL << (PB_migrate_end + 1)) - 1) | BIT(PB_migrate_isolate))
>>> +#define MIGRATETYPE_AND_ISO_MASK (MIGRATETYPE_MASK | BIT(PB_migrate_isolate))
>>>    #else
>>>    #define MIGRATETYPE_AND_ISO_MASK MIGRATETYPE_MASK
>>>    #endif
>>
>>
>> Hm, I wonder if we can get rid of PB_migratetype_bits
>>
>> diff --git a/include/linux/pageblock-flags.h
>> b/include/linux/pageblock-flags.h
>> index 6a44be0f39f45..70c988dbdddc8 100644
>> --- a/include/linux/pageblock-flags.h
>> +++ b/include/linux/pageblock-flags.h
>> @@ -13,12 +13,11 @@
>>
>> #include <linux/types.h>
>>
>> -#define PB_migratetype_bits 3
>> /* Bit indices that affect a whole block of pages */
>> enum pageblock_bits {
>> -       PB_migrate,
>> -       PB_migrate_end = PB_migrate + PB_migratetype_bits - 1,
>> -                       /* 3 bits required for migrate types */
>> +       PB_migrate_0,
>> +       PB_migrate_1,
>> +       PB_migrate_2,
>>         PB_compact_skip,/* If set the block is skipped by compaction */
>>
>> #ifdef CONFIG_MEMORY_ISOLATION
>>
>> And then just work with the bits. No magical computations.
> 
> Something like this?
> 
> diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
> index 6a44be0f39f4..a09b79a1fb7d 100644
> --- a/include/linux/pageblock-flags.h
> +++ b/include/linux/pageblock-flags.h
> @@ -13,12 +13,11 @@
>   
>   #include <linux/types.h>
>   
> -#define PB_migratetype_bits 3
>   /* Bit indices that affect a whole block of pages */
>   enum pageblock_bits {
> -	PB_migrate,
> -	PB_migrate_end = PB_migrate + PB_migratetype_bits - 1,
> -			/* 3 bits required for migrate types */
> +	PB_migrate_0,
> +	PB_migrate_1,
> +	PB_migrate_2,
>   	PB_compact_skip,/* If set the block is skipped by compaction */
>   
>   #ifdef CONFIG_MEMORY_ISOLATION
> @@ -37,11 +36,10 @@ enum pageblock_bits {
>   
>   #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
>   
> -#define MIGRATETYPE_MASK ((1UL << (PB_migrate_end + 1)) - 1)
> +#define MIGRATETYPE_MASK (BIT(PB_migrate_2 + 1) - 1)

I'd just do PB_migrate_0|PB_migrate_1|PB_migrate_2 and have code that
is easier to parse.

-- 
Cheers

David / dhildenb


