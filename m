Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 604E5CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 09:15:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAAB78E0007; Wed,  1 Oct 2025 05:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B80358E0006; Wed,  1 Oct 2025 05:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6EA68E0007; Wed,  1 Oct 2025 05:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 96A7D8E0006
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 05:15:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 55FAF11B131
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:15:47 +0000 (UTC)
X-FDA: 83948987934.09.7F47A18
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id F2012100004
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:15:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="L/wvFM5P";
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759310145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FXaeyfAqWaRA0FNceCpvAylAa01hDY/ZZeeh2yB8rj8=;
	b=Fo3KiC3mg59XjDSGMhALx/EI4HPyEJuqpoifgMDRMZ9vt2OZ/bY5Jef3bLxts0Q4hpEd7V
	Dq/CC5BKBL/cZYBPOzKwkFVxnoXbgAnxlxmggwCs1a7mcNblEc0i2v7xr6o3+eMBfUppr8
	MW2SxjloM2vkLkXYuF/HDUfQraaAARI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759310145; a=rsa-sha256;
	cv=none;
	b=ge60nK6+cByiDz0wnCiIb2ZJCF1aeoPp5IuDmqJCF0gv6cBhro735zjvIprO6/kPwJU0Lz
	kKUgc7+L94QEKaogpRzgxIUZL756ED/N9BS85I2lf+t8082a/k78bdhjm/vTLSAHTCvZGo
	n9OV5QPc4F+0uwRY3Dv7jpwP4jovkdQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="L/wvFM5P";
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759310144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FXaeyfAqWaRA0FNceCpvAylAa01hDY/ZZeeh2yB8rj8=;
	b=L/wvFM5PFOBAEcAr+Urt5hQgNXNehxyPy0kIiEY8rt6wFl6ZOIEEjHJtYHW4JIkxcnWYOH
	tglC4yfeHBaHERHopHWl8xvFTZB8SaOR0a40x6mA5pUmjuoorYln3CX5F0MAQ+5sRscIl8
	3ZsuZUQdk0y6cMd2beM85fQ0f806eaI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-zvaemXifOLOFq93A8td83g-1; Wed, 01 Oct 2025 05:15:43 -0400
X-MC-Unique: zvaemXifOLOFq93A8td83g-1
X-Mimecast-MFC-AGG-ID: zvaemXifOLOFq93A8td83g_1759310142
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3f7b5c27d41so411882f8f.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 02:15:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759310142; x=1759914942;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FXaeyfAqWaRA0FNceCpvAylAa01hDY/ZZeeh2yB8rj8=;
        b=ky9W5DwIC+JVpB8DP9x5MD/GNYJwOXlcMVnGPnYJolC9Ccq9UfSxjna5mgt49Qdq+h
         y82VukljPut4rsHOvsyQTrB6Esve+Sb5VqWgF5vG8AwXlLcrFtzSljK/nxhCc3gsPqaO
         bf4iv4PzpLZyq4JQ1vhDZEXSEWyQfiAsyXjyrHjLHBX9aWqQyaaRImmE7ZKcUfaj9qTH
         cKRO3gw+9zNG3MB+6a/rQWZFxKkv4guHycjLXNxycoUKCZmqkES7uW3zi6au/wVkuSOA
         AOnkv7n9VJDxGsWNF7CnKCrCeJArVTwIgS9cYCXD4fHAHy4RKaYvUhjaVDVZcdXO/btz
         srhg==
X-Forwarded-Encrypted: i=1; AJvYcCXFooXGresvIUHjcqiLI6lwutJFjmNUN0T+0bfjHDAbwmWu0pBKSqzUUbNR4FkcaeXBenEVCb/zLw==@kvack.org
X-Gm-Message-State: AOJu0YxC/IsrhlVcso3jbUGHjCmbCxDwjhKi9y/8wM3NR7bLqAje7jyl
	7eC7tnpaGAW3ZfJhrLzUMBpDk1Zkgmzy475d8hDpXazLiPkk89F/XsFMDNCywOIMrRGq2ygSWKZ
	Laeo3nY3VGt5Otq7KnoF5ZQEJoHfwev6zCpU7eZhGWzXmCyhuND7j
X-Gm-Gg: ASbGncvd5hVtE9KNKw4z3ovB0wVIOwmcFMIUArYlAWw1yszCrKpPHcSMsJKmJrRLbe9
	MMqLvUDnQFiwdZcnzis++F3QM06LEnSDSBs8GddhHRIvSEK9n0CaGayCIUN4VYqS/WbZCqqn3VD
	89y0Ch6XZh4kwzOAW52NUely+kfQFtbIKrDZWOLbojdBjCgeYc6fTbchB/syLgccFAKbCp0eANZ
	awcoK1Y1+ha80fljN54Qn8bqDlhmehexNku80zd1US7NwLLjPoL3ix9LxeyUzKQG52rguWeaWvc
	cFIFYbeFexgrws25ROvEEcmw3p1Qs4h2R0tTnGXK7ux57dvtH4Me4kfuo0BiIhtvvGjbONmhxtt
	hTkBgDuiT
X-Received: by 2002:a05:6000:2c10:b0:414:c2e8:a739 with SMTP id ffacd0b85a97d-425577b43b6mr2280418f8f.31.1759310141915;
        Wed, 01 Oct 2025 02:15:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFFvlvqCMpej7RI94pKLI995PrZUfgpc71b35bS2mBtn+Dx5OH+Jmwv2gbKlHnRII+v//syQ==
X-Received: by 2002:a05:6000:2c10:b0:414:c2e8:a739 with SMTP id ffacd0b85a97d-425577b43b6mr2280355f8f.31.1759310141334;
        Wed, 01 Oct 2025 02:15:41 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4151d0ae6f9sm21782656f8f.51.2025.10.01.02.15.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 02:15:40 -0700 (PDT)
Message-ID: <ab5f77a2-c143-485d-9006-ec45493ea56c@redhat.com>
Date: Wed, 1 Oct 2025 11:15:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
To: Wei Yang <richard.weiyang@gmail.com>, Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, hughd@google.com, ioworker0@gmail.com,
 kirill@shutemov.name, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mpenttil@redhat.com, npache@redhat.com, ryan.roberts@arm.com, ziy@nvidia.com
References: <20251001032251.85888-1-lance.yang@linux.dev>
 <20251001085425.5iq2mgfom6sqkbbx@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251001085425.5iq2mgfom6sqkbbx@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IPwhfn92gHCiZkhF_9z8JYriLKOEWrrzXnEnDRnk8iM_1759310142
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F2012100004
X-Stat-Signature: dmks6dyd76o1da8mgco376h781kp9hom
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759310144-279819
X-HE-Meta: U2FsdGVkX18uqtELuephMi4ZKvGP14iEbCEpbwrdSbHKPVPg+pvE967iUn4uidxOBXWWPawRrTcJUCdxhFLkh7a2fAFpQpd5xPjfACSZ+WncT4bsRfd3FEkW9DptGQKGqR5Ng6XfQLpRKEIZ06DxPRiGkLDBFhwMdNfj28RQncoAx93ZKnPIi6aPNHnmnC/LAGFmbj9RGkQtz9zz/xernBJBMB3VDh+eLxIAzhh/5gQMoVj4pfMw/xGJF4YKU0mXkqDhdGqmZkG6xsMlboYSJjQfFcRMUZcdjYIelEc+7lm4W4fGia/hF85daHQcjU/yB6zov+/Io4Xupr1Y5nkSGzQHoRHcWWw1ma47zxEuLt1gnkh8DtzvMmyGrF0oQqvvTzaCS1G/h45LyL3JplQbAI14BL2JunVrmTN1w+UDAtESH9mp44HKg39mvthxJK9kAi24LoxM/6YZpJ0pYLmakCFfQOrIx2H6tv7Tq6PYVd81P3wC4l7r/vRPGO+vUxvRTF+dpWHqeNxrIGfk2Z6jo0QAPTLMEsFjAe+SQ963qlmAV/jI1SU6JFSCL7IZIz52o37/ORkDXgXPaWPkbjNGGLBFxnPpVBPScUPWD66zWerhjff9VNySNv9Dd6ZubY32ApKxpFSN4mk2jkhxGTcCZJQjYD8EezkJiCvECVoeqrCGyjFBWtCZnvqBgKmQqdcsVtq4aMPpufIiIGgLsDDwypSE+2z+2XuYOT0BSggmIkvPmKXt+PQBahBajRqj0+PdlS1OGRhxctwK5QBxf10VtwdeIcHQ+yTQElWs6LOG1byc+EITTERqWGE5gnMqYPw4lwf+JqvPF+fiu+i5g2g7Qj/iKpRSfWsm4gksa3WTw8lH68maNiqXyDbPZaCP0ncFql9cSzlzwXqdo6LPVsRHgabcrxoJiaDp1CKVDV+YYfoSIRllRIZ3GlRm25nl9vumPRL4IHa65kwDTO3ySWt
 86pnN2bt
 jISIZ20p0GMaz7yR+MoWi0X6uk1fMWB+j2mLRhFy58T7I9+TZ05vyB99V50Hc9Qn8f6W6+kgoO4G8mGgqAOZR60Mx7JMQJzBExunwFBfCJkiKgpdYNuJMtU/lvX4gjkeBN9ByTNPun6kmJ+r7QBPDm3BZp8JFmKHtnnDxO/mOLjz0J1aJBH+X85mMqzsXfuQmak7eNuxJxHB9+yU6WZLPqk91nIXgaLYCzFKo16dqWnRcOMGw1xDJNOfsHlSL2yX4n/V+AWD89Ff0aaQAKhCAOX8Hkgoe1d2lvRbkZi+7ohoBHAy50ykr8kdrUth9avmLy0rFBofDJuOOJpcpUuSjJuBCDyq6i4wpDzVYCIf11UrTfZNm4ETsp2u9gBAU9yattc9hbS8p7zAZFsp1dEz73fRfafNpb12DNpa96g8dg0nK+xKeWy0Ec50646rEfAFkkF+ytRnBEEWiX6p+eR677U8u2A6x/Od1amhvuce4EnuQPlcebzQ/lmPuZCUzkLweh+HxZ/CquoqXNofxTuo6e13GyA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.10.25 10:54, Wei Yang wrote:
> On Wed, Oct 01, 2025 at 11:22:51AM +0800, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> Currently, special non-swap entries (like migration, hwpoison, or PTE
>> markers) are not caught early in hpage_collapse_scan_pmd(), leading to
>> failures deep in the swap-in logic.
>>
>> hpage_collapse_scan_pmd()
>> `- collapse_huge_page()
>>      `- __collapse_huge_page_swapin() -> fails!
>>
>> As David suggested[1], this patch skips any such non-swap entries
>> early. If any one is found, the scan is aborted immediately with the
>> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
>> work.
>>
>> [1] https://lore.kernel.org/linux-mm/7840f68e-7580-42cb-a7c8-1ba64fd6df69@redhat.com
>> [2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local
>>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>> v1 -> v2:
>> - Skip all non-present entries except swap entries (per David) thanks!
>> - https://lore.kernel.org/linux-mm/20250924100207.28332-1-lance.yang@linux.dev/
>>
>> mm/khugepaged.c | 32 ++++++++++++++++++--------------
>> 1 file changed, 18 insertions(+), 14 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 7ab2d1a42df3..d0957648db19 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1284,7 +1284,23 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>> 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>> 	     _pte++, addr += PAGE_SIZE) {
>> 		pte_t pteval = ptep_get(_pte);
>> -		if (is_swap_pte(pteval)) {
> 
> It looks is_swap_pte() is mis-leading?

Yeah, it nowadays includes non-swap entries as well.

Maybe we should consider renaming it at some point to something better.

-- 
Cheers

David / dhildenb


