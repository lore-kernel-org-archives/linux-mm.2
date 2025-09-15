Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60A65CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 08:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4AD18E0002; Mon, 15 Sep 2025 04:51:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B223D8E0001; Mon, 15 Sep 2025 04:51:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A38078E0002; Mon, 15 Sep 2025 04:51:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F6EA8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:51:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 313141DF1A2
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:51:56 +0000 (UTC)
X-FDA: 83890867032.05.9E44E91
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id C179640003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:51:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KkAVZ0la;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757926314; a=rsa-sha256;
	cv=none;
	b=m1gTdYO1S3Iw8lkiRHSJYGmf+A6Ng2UgXCC7JYI+Uip9wol7s7DsEBzrc296i3vPrGGhUs
	3Acf05j4dLZzPrFY8soXuJqfekll5YMMK2+sOz/lfP9LMj9udfqa/XKzwq6OEYoXMX0g8f
	ndRCETSjlxGjIembEyeesfDsG8k/zgk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KkAVZ0la;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757926314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LbC9+HlZ3wYD+Tu6w1/ck3ndJOKoJRqAyUbt5dHckC0=;
	b=1jizEfrBsqHtYodg6HwaovqNpn82aowMZWoofuQyz6IbM0Xh0yRkXIlM16jdcM8Jos1UDZ
	KTG7G2HzLrsuDlbhSuMP0axrYBvYWNlRaRySq+A1lFl2bxdjX/WEpLDE+NnERwTel4jxOu
	FkYG+3xb3yWZbp5DKi4GJ2I9Mr8ygys=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757926313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LbC9+HlZ3wYD+Tu6w1/ck3ndJOKoJRqAyUbt5dHckC0=;
	b=KkAVZ0laM7AKv/UR6anU3lUhR/dSSzbyEtawFxDcBpNDGWTOBcLLtote58QiMjHPt3SGaW
	NiiR95PBIUMbrlfXDL4UePf9ozacG6hlSQiaWGowsJurRrvA9iB8T4aap6o5uVIkuO6SBd
	kcERiGO+F5GJpZVe1PxOzw0EQpzqF2Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-C34sdfQmMwa-3zUJoUx_-A-1; Mon, 15 Sep 2025 04:51:51 -0400
X-MC-Unique: C34sdfQmMwa-3zUJoUx_-A-1
X-Mimecast-MFC-AGG-ID: C34sdfQmMwa-3zUJoUx_-A_1757926310
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b98de0e34so30947435e9.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:51:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757926310; x=1758531110;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LbC9+HlZ3wYD+Tu6w1/ck3ndJOKoJRqAyUbt5dHckC0=;
        b=WkI653WwhqjeeCQBWeu3WHYmQ87bdCIA5BI7aRHj1cKEgVKmDPgT0yjI+IIH4XeZpk
         GtqNAJhPQ2CjjMdAYZ6Do4izN+FOP51lQYJq7Pz79UEBuBNeEY3SrFQPREx/kVj6lM0j
         a4husedQxcBh74FBVG18X1bBJg3uVvD7lc1N90nc8V2DEIUAmv4quoNxNGswGlWvKtHS
         tHYcCbn5YBrtmFzEeFIhvjGkJaNQ2OA2ARu25bsPeWPkqZE73vk1YlSZrxp4njOmXK2A
         +QQJskPdUyaJM15JWDqCL+ZnWFuipK+vzoEIHJL4ZPu7OWTn7V8pelpgZFUY3P0X7wSA
         MfRQ==
X-Gm-Message-State: AOJu0Yy+SBUEc+yLe6iyO+3okhYhPbquVVOSUHLCJlCJobpf4+FRoZvM
	F7BVVGAspkxmQO0q/ML1MbdBiboVhOcbBZENl8iaydorBmz+X47Mf5Smdt/fNCY3UH5Z94oKAdC
	W/1C35pSXcV1HSuPNNueS5+EGZRU1bwD97O5WQ6S4Hj0lJ/mtyBZP
X-Gm-Gg: ASbGnct/T0VtZfyjKZUXZorPwANxF2j0ZVBF2YwBTnBmX77Rkwd1JRiXG9y7/0hVvz8
	xcSbLaCKrh5NElUUi5KvyM00SQhMbM/2eMi5ZyOvwbIDx3PAX7t4EXbaht8TLYAOgvDkA0DZMoM
	YU0eFHQLIGXQQrOIe8CI1J3kEKFOskYzNLhbtgW19iJ8poIUDaFoCaknYmZ/wcQi1o+w6B2OErr
	lMMwdCnp1h6MAg4Qmof2cUfvgHab58ZP7SEOb4QO/Dij81R14GbNw8Y/bfuo1kylMNXpb9DW+gM
	e/sIzfr6mU/KH5WaiP95Xrw2M8X+mAEUOqX1hXuJfR6YfFNBp7w4Fj/anS9p/q6DoFF5Qons2bF
	iKJO1TIkND8IfAH8qZmFlqdjeBCgMA202wl50k21Ldq8w2wAePLRnGmoGuWM7jKSfKoc=
X-Received: by 2002:a05:600c:6288:b0:45d:d1b0:5fa2 with SMTP id 5b1f17b1804b1-45f211f9fb6mr91702995e9.19.1757926310278;
        Mon, 15 Sep 2025 01:51:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmehtCyxOr2v1ulJFD/llco5pkU8tfM63kgUUYxmqAqnpUwXE75+yd18OdpEGn1aaibMJcKg==
X-Received: by 2002:a05:600c:6288:b0:45d:d1b0:5fa2 with SMTP id 5b1f17b1804b1-45f211f9fb6mr91702725e9.19.1757926309820;
        Mon, 15 Sep 2025 01:51:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45f2ff61f2bsm6962095e9.12.2025.09.15.01.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 01:51:49 -0700 (PDT)
Message-ID: <fb322901-28d6-4f0f-8bc0-bcce165ca250@redhat.com>
Date: Mon, 15 Sep 2025 10:51:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/huge_memory: fix shrinking of all-zero THPs with
 max_ptes_none default
To: Dev Jain <dev.jain@arm.com>, Usama Arif <usamaarif642@gmail.com>,
 linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>
References: <20250905141137.3529867-1-david@redhat.com>
 <06874db5-80f2-41a0-98f1-35177f758670@gmail.com>
 <20e7f812-c1e7-455f-a523-08fc99024adb@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20e7f812-c1e7-455f-a523-08fc99024adb@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7INa71Rxqme19Si0qg0nYo-kRy2VdLyURaxG8tu8P58_1757926310
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C179640003
X-Stat-Signature: cngbhra4sjbraku357shwig887dkhzrj
X-Rspam-User: 
X-HE-Tag: 1757926313-632831
X-HE-Meta: U2FsdGVkX19+BR83OATZEd6h6jb3/i/mx4s2BBKy9fXHGDlV1XKT0xP0cAwQkNwVeXODljUwIVoVoVlZ8b+9RFLoOZcrPs8wW1btXGmfgwQzEkGsbUzgNgb0LNBsXsL992TE792hefN5IqbUnOMDtbEYQrxZDHTXLEZ9FLOtzq914zAsaTMuYQp8tYjVtsmgJfITSkFnDWDLqQtJ5HgkTtctTL6I+dKH5vGq86XMPLscdgqj4oFFdppBLu90Eq/rjxnVcYTSd5lXp1ELmb8xRpzpYFYI579GUHGhnyFBOz8IMF5xcvLzfo5wMgy59cLQSLPy2zi8k++h5imnakIQNSi4QJFrP5Op2e44xnyx/Qkz8VS9WerIDoS8jesA+n1PzRmfBP3bt+37wj4M6LMKBAwMhYADIsb8NljFfqFbuGedT3wWF0DrYwYLvShe/6z/3a/WIR59DiCM1tY6nQUyJpA+Ieq20itSPq5R/0KCWEyOO+2ltsWT70VgCH/OWEz9KNLkq4cBvi+V7N1ijXaJdNFrU9teW0FGWnbIn2cznhzTSHu5FAL7ZMcSX6CKUg3E/rKRZNCMo4sucjvfsFqi6t9m36P1X9Qls/aeYsK7gNDqvLdcbGlsBzmFTkjH6YcX0VGG+uAlWQsq8ai73HKyQB4WTJ+yRFgTcyFeGzabnr6ZX5zmnr4q8rM1hdlfGSkCRlbhAny3MHwTRTNbFC7lI9vBtHDM/trUMzLwx2ZlD5XIpBMc4c6/EacXApq2bSTQHSVh5CudwKNwfJQS5n8R3HsezYaN0LERPd/fgd/1hd+MGoNnIR4Y1X/XEk+Dp1oKwT7sSWD5YSLJq9cVa59PASk+Bk1ZtWAJ6jYnkKGQEkMVv//NdKCx+yBs82vBv9SfbYKQLlUOU++ieq9rVYkNTeQynOjFcrq2u1sFLOh3a3A/RM79kiGCQXn4kpvnp2aQra7qt4EHtV/baCA53Zw
 h3Y544rM
 KNSXUQkgS5PktXNeze/mBrDst1pBqHbqJaJMU3BDc3hAXrPslk6BLuxyYwRHLo7UeV9XfEkvxRsl1JaNxNk978/VoOs2jkjiUNcLr4tXxMXwSWnxZv6lbd74Ann58YT++wk8651xj0xmIjb4Y3y6a3IniPSIMJlMM1yh/H7ozAT/NORldE8X42++sml8fepkWwBiQsSujN4Z5SFpIbnXQn2RB9ke4P2w+GVaNCECcdAE+keozpXdB0t3T849Z2IYbR2j9xFn1R2gtNtEXEHk+SDjqgSsjAgAqDanGDjYUI43PL7JD6UyIwAoDiD9qRHvSW2E38pXDvwJDkysmJ3IJJYrM3xvP9lUiM4ObPTYeMbS8jbnrilWCixKahdggR9HVVRJR2afuY1+A/swBnxMfVDNjW1JvtSlWICOhr8nbC+aIxt3fEdHktcJEltdCg2Ehr+7XcqRYpEYPPVBdq9Yek6P6F8VK3489uOYN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.09.25 16:04, Dev Jain wrote:
>>> ---
>>>    mm/huge_memory.c | 3 ---
>>>    1 file changed, 3 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 26cedfcd74189..aa3ed7a86435b 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -4110,9 +4110,6 @@ static bool thp_underused(struct folio *folio)
>>>    	void *kaddr;
>>>    	int i;
>>>    
>>> -	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
>>> -		return false;
>>> -
>> I do agree with your usecase, but I am really worried about the amount of
>> work and cpu time the THP shrinker will consume when max_ptes_none is 511
>> (I dont have any numbers to back up my worry :)), and its less likely that
>> we will have these completely zeroed out THPs (again no numbers to back up
>> this statement). We have the huge_zero_folio as well which is installed on read.
> 

FWIW, I am still hesitant on this patch because I think the whole 
deferred split lists + interaction with the shrinker should be cleaned 
up along this patch.

> How about just doing a memcmp() between huge_zero_folio and folio? We know
> exactly how this folio looks like, in case of max_ptes_none == 511, if it
> is to be eligible for shrinking.

I wouldn't really want to optimize for this case, especially given that

(a) I want to remove all direct dependencies on max_ptes_none and any 
special values.

(b) The huge zero folio is not always around

(c) The kmap local prevents us from doing that (in particular on 32bit).


-- 
Cheers

David / dhildenb


