Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33C19CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 07:19:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90E748E0065; Thu,  9 Oct 2025 03:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5F58E0002; Thu,  9 Oct 2025 03:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D3F68E0065; Thu,  9 Oct 2025 03:19:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6CF248E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:19:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0BD1F468A8
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:19:45 +0000 (UTC)
X-FDA: 83977725930.27.CF3D402
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id BD1021C000C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:19:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="c43Z/i4D";
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759994382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MAf7j15IA9NV3ibFlHPooOFQlDK8wDMuEk53oehy5lI=;
	b=QlDMcrYZCiza0prH4BXNmrEqHXdV2YJ6QaAYDbll7PqznYZxSFCw3g3D4rajULuej4AXrA
	xeF7KZtU4RuBNhOOvOYoDPIh98GJWjmSqYZ/eR8Kt/m5Vcpehlpcc2nFr5KtgCCfl4FM6S
	12/qWqKNlBiXMoPTpzErHexHVfiasyk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="c43Z/i4D";
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759994382; a=rsa-sha256;
	cv=none;
	b=aKdEvswrwX2K2nJ4xlWGtPMTFGrc/U6M5eJ0gUyIxjgAO240BdqUepr8gWfZt20WsroKXn
	vt/4sMCL93vtbtdc2UNsrcQtpraeCcCWVIcNwYzxFq6zcprmQuDmE+7akJEcBMoWORN0vN
	sQyerQ3VqyCGGP+Idf8JaqZdcV9cvGk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759994382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MAf7j15IA9NV3ibFlHPooOFQlDK8wDMuEk53oehy5lI=;
	b=c43Z/i4D5zzIuLiMVsrCZN+yqr06X2RT92mpU2x+u91JrA4YH9MsDrWKq38oEuJ5XK/HLi
	G5rCo4HM17JEhVhFOejTvGJiEP2lZKBg7Omf9bhsyvu3anV6IPgQx7zyV5mSLkMIe/ELUe
	yicATc3EfPJzOLF6iHGptaTfC72KHsQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-NF9tnsMoMziCeCetrzz9kQ-1; Thu, 09 Oct 2025 03:19:38 -0400
X-MC-Unique: NF9tnsMoMziCeCetrzz9kQ-1
X-Mimecast-MFC-AGG-ID: NF9tnsMoMziCeCetrzz9kQ_1759994378
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ecdf7b5c46so392916f8f.2
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 00:19:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759994378; x=1760599178;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MAf7j15IA9NV3ibFlHPooOFQlDK8wDMuEk53oehy5lI=;
        b=g0ROUWEAjC4EiqtBLuumFGBvlLYQ57h2A+x80xIKNJ9C3ge+TlBeVKLLQEOS9TMi0H
         gOe8gENj1giBEUosjCDe4rs9Mti2cjnpJDL1Y4AJeorjdXxhUWDGmEyXQQNurINd0S/k
         VqW9cRPDZPAXQjRPNuzkaYKbIwVi1r8TNJqoxJboDyftCJKJ33dxEVhmbl7G7Ti4jlPU
         QTF7jUikG0R1HRyvOXvlsKrtbMl3MCpH3PTCBg3xV7m6ZoZss7fB3uclOMZo6RZnmhd+
         QT8IyIGyt7Ic4GeoWySxf2bTD4XgUnpm2Qq4Nq17DYBGPK6rEnT9TUx4oQvynDm6lztb
         yUzg==
X-Forwarded-Encrypted: i=1; AJvYcCUS62bqlCTjo87ll6ZoeCvVlx5FF90oD6zGIWUd4mqrhvKt5SmkIAxnkhDx5AzpVLbl91OgiLZLkw==@kvack.org
X-Gm-Message-State: AOJu0YyJ3tR0VwsuqcUnv9c/vqlFKWt9Hzw08D9hVde0I0PBkjjax4Ys
	Ap3p5/WYe/YRU4PHpO2jqv6As3lgEm1fc+y6BcG0WFBcSWd92EobQG9iPmGVk/0GY6oB+QYPmZN
	zKjUpgleT1/uHBkoJh77hfSnDEX4r8UAfpNKxPeQpOSF7i1ccWJ9N
X-Gm-Gg: ASbGncsiaFJDTXY05tA2U22Lz35Vidtj5puAyvF4y+/Mk73kYj4XrdJWH8iyPiubwL7
	pmdSz6w56zSaxOyq2DZcKfwhNPQxCtNkxgiUCjAyIasItCdePuN2CgyxpE+cTD02pRRKx1zdEV2
	eT78tQLnPuYNi3GjtIox0lAJGi6t1pi7ucL71WWhviySchdIqdwkDL9VOfUMAo7wWMVDFmqZoy0
	lJ2R0Xgl49qCFTjuI93XGhc6kml1Ju9Fx3G+hQkcL4hJ99naiplsh7UvFzEujX1U/jYJHhJkerD
	ItZjV/uJ3BXxN5LF8m/tG2ZXbeg/agq4Mn+npTIdpDZ5V5ZtyozBYaBiE9+H505WSozYRgdLrEE
	ANWA99seJ
X-Received: by 2002:a05:6000:607:b0:425:72a0:a981 with SMTP id ffacd0b85a97d-42666abb02bmr3786627f8f.2.1759994377616;
        Thu, 09 Oct 2025 00:19:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFvd+7KvkDLhqe4fcCdP+yrbRxdeZF/qL8BolXYSkRHh/d0PcTODdY5Gee0yd7hexyiQvZxDA==
X-Received: by 2002:a05:6000:607:b0:425:72a0:a981 with SMTP id ffacd0b85a97d-42666abb02bmr3786590f8f.2.1759994377140;
        Thu, 09 Oct 2025 00:19:37 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46faf12fd83sm32079965e9.9.2025.10.09.00.19.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 00:19:36 -0700 (PDT)
Message-ID: <b198ff9d-b96e-47c6-acaa-c3c641cd64b1@redhat.com>
Date: Thu, 9 Oct 2025 09:19:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/compaction: check the range to
 pageblock_pfn_to_page() is within the zone first
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 iamjoonsoo.kim@lge.com, linux-mm@kvack.org
References: <20251002033140.24462-1-richard.weiyang@gmail.com>
 <20251002033140.24462-2-richard.weiyang@gmail.com>
 <99824e33-bf25-40ef-b969-a48e3b916ad1@redhat.com>
 <20251009020817.y7ji6wqhrv44h5uz@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251009020817.y7ji6wqhrv44h5uz@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: o3FU09vFAx2OgRpRkg2AELrORDj804CO2cboV-edBio_1759994378
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s4h8q439r6bcpm9pzdf8xymhf9bjcbm3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BD1021C000C
X-HE-Tag: 1759994382-93316
X-HE-Meta: U2FsdGVkX1/ZtPTMmzBzGT5Nhy3sT3pQI6zz3odXKIv5xNSKRWfIXFVAeYVrcT8ZVI3Mx43ze70N2ax06GRgAiUx6dZ8FCmozWFKeP5R4KlzxBjQ1uVIuAJPZDpgdzCJ0ZhA8AWVgFWFjDkoBqP2dQjIytOBV/7WG5nwcydxX0GqXk/cKtMNzgvdNRCd8p8Cc+TbprHTBdFcYLM2LU8Y7ttx6uFJOA5XjTOgOjbb8xTvUOo5LYFntmzYv3LdoZFtMRlP6FNBw4zvxtntmpRENZvHpg45b1CjANlbleBXjGuusdfNLMo4aZTEPSOgTIxLzENqtWxLdyqMrvrgW9ioYLkQ9YGdMPJIJSUReidbhmUvdGDELO8SnpeyAwd3sbBmqRcdPYf4kf61Epa5Bx+x0yHiwar6WmDKQiQnNex5PhIZ83iZn3GJlIfUBYS2e4SehCNBIQ6fjQGVRBoD493zvj9yzBNzC53kvY9iAXasT6wtk7x1s2k3VP8wiJ5yNcth8Dfpnk7cCOkKUa89STSjymOVge1nJCOM6yZq3CbPEoaYItVybGsFYonhaYos+7C9vCqj/Joe7Lhj22pR54Br3Ps03CV+hrUweeOsNabDlOxbCa2oNW8cjzOqz9BoGskR+dfkg4aMz3bxT+9n36+6DZH9ooM8FW4jkMB3OEz9U9Os1EeOPxwfSwyvTf4VzFONJvIHaGWVo6MHL4NRsOncEJPjfS+4BsElR/XBrcDOU43lxmb+r/JEgkf0GpVX0fa01Hb9r6KMYuu3dSzymrlare5ik2se+3RE17Oeud+4w3vzljXpC6nen+nvExzpcpcQqJY18AriQAHQRkmkb/UGeIuYRs/J5OJWJbaRtSYIi+KQB1Z8n18ktiDt6aFYx/KyM96ogCZt2FsCfyL+s/qXwWaiHy1lw3U/E3Zqi9L88FCKmrxVF+Z3Y0JXn9BbJayGRRWwQ2u5bsaEBeiKKwX
 f7rGEfPY
 7CiwUju2o3iv+wCyG6TWBDbLp1uYDIbRyQkjFWvNILTThq6fkQDvJn9ZG/i2ALMamufonU2uJW26F5BjDVxzSP42f6k3F9/D1SeHVPD4z6+DK1NNRn6c/Xw7D9D/pdbOGVxX2kBJ4IZ3WhTa+24NfZnRMIZDev1pE7SDfG6Wy2kr+f3uoqZA5hv4w4+rIlgoqDAjjy42RRUzgL2a7seRDyP5jmGcAIyiXlJ/D5BfnEAWcXbskMk9C9Ll+ks3/IGNQ+J14cDMWC443vkx1qyanHY37IT+LxhJTv1BZIPK/aicyumluWx0E/sgvU6NHXx8Yq+Vaw53HUIttnaA+G4M6RvSbqRCZaDquUkcdYkjGbfktHVZPf0ocd5n4eu9urabqKLsJQzxpoPLSxRQ2B8ool1K6cpNXjKGnKr7moTBDz0uGbHDOJKY3vNpV+Jee7fg85opI3cZ/7GvS397aLFpdS+C1sz4nj7z/PEH4FkdC0rI0F+l9RJ5Xcf0DWMH5mkxP3M7fxQvZ9fmCMeqlSJ8k1sLbJ2aWtJrRhit55ifCbYwXx4awfaJD+Lb4PXGhEhVZEmVPyHpHQEtB6dPuYqAoXRlGgtrpiW7WswbLkmmeHDKksqLwHL0BfPT7Ryo38lCpMba9FDGYmtAW5o7+3aGH6JrBaz0f6IO2S+AEG7QaxsnNTAU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.10.25 04:08, Wei Yang wrote:
> On Wed, Oct 08, 2025 at 12:14:25PM +0200, David Hildenbrand wrote:
>> On 02.10.25 05:31, Wei Yang wrote:
>>> Function pageblock_pfn_to_page() is introduced by commit 7d49d8868336
>>> ("mm, compaction: reduce zone checking frequency in the migration scanner"),
>>> where there is no requirement on start_pfn/end_pfn except they are in
>>> the same pageblock.
>>>
>>> So at that time, pageblock_pfn_to_page() would be passed with pfn
>>> without compared with zone boundary.
>>>
>>> But after commit 7cf91a98e607 ("mm/compaction: speed up
>>> pageblock_pfn_to_page() when zone is contiguous"), pageblock_pfn_to_page()
>>> would think the range is valid and in the same zone if zone->contiguous,
>>> even the range doesn't belong to this zone.
>>>
>>> For example, in fast_isolate_freepages(), min_pfn is assigned to
>>> pageblock_start_pfn() and passed to pageblock_pfn_to_page() without
>>> checking with zone_start_pfn. And mostly, the end_pfn is not checked
>>> with zone_end_pfn() before using.
>>>
>>> To make this function robust, check the range is within the zone first.
>>>
>>> Fixes: 7cf91a98e607 ("mm/compaction: speed up pageblock_pfn_to_page() when zone is contiguous")
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Cc: Vlastimil Babka <vbabka@suse.cz>
>>> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>>> ---
>>>    mm/internal.h | 3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> diff --git a/mm/internal.h b/mm/internal.h
>>> index 38607b2821d9..8e1a3819c9f1 100644
>>> --- a/mm/internal.h
>>> +++ b/mm/internal.h
>>> @@ -724,6 +724,9 @@ extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
>>>    static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
>>>    				unsigned long end_pfn, struct zone *zone)
>>>    {
>>> +	if (start_pfn < zone->zone_start_pfn || end_pfn > zone_end_pfn(zone))
>>> +		return NULL;
>>> +
>>>    	if (zone->contiguous)
>>>    		return pfn_to_page(start_pfn);
>>
>> fast_isolate_around() adjusts the range to the zone boundaries before calling
>> fast_isolate_around().
>>
> 
> Correct.
> 
>> isolate_migratepages_range(), isolate_freepages_range(), isolate_freepages()
>> and isolate_migratepages similarly all seem to take the zone range into
>> account as well.
> 
> Maybe I missed something.
> 
> isolate_freepages() takes care of the end_pfn, but I don't see it adjust
> start_pfn. Or you mean low_pfn is already adjusted?
> 
> isolate_freepages_range() / isolate_migratepages_range() just adjust start_pfn.
> 
> isolate_migratepages() seems not adjust start_pfn nor end_pfn?
> 
> Maybe I misunderstand you, would you mind giving more detail?
> 
>>
>> Only fast_isolate_freepages is a bit more tricky. It definitely takes the end
>> into account. The start comes from cc->free_pfn but IIRC it's always above
>> the zone_start_pfn.
>>

I don't recall all the details, but at least regarding ZONE_MOVABLE we 
make sure that the start is aligned to MAX_ORDER_NR_PAGES and that the 
size is aligned to MAX_ORDER_NR_PAGES, see 
find_zone_movable_pfns_for_nodes().

Note that MAX_ORDER_NR_PAGES >= PAGEBLOCK_NR_PAGES.

I think the same is true for any other zone as well. (DMA / DMA32 etc 
should always be at suitable boundaries already IIRC).

Note that memory hotplug always works in section granularity, and a 
section is always <= MAX_ORDER_NR_PAGES, so it's also guaranteed there.

-- 
Cheers

David / dhildenb


