Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27A3CCCD184
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856A38E003D; Fri, 17 Oct 2025 04:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8072A8E0016; Fri, 17 Oct 2025 04:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CF358E003D; Fri, 17 Oct 2025 04:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7AD8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:11:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0EAA559DE0
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:11:27 +0000 (UTC)
X-FDA: 84006886614.19.7E7B11C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7F724120005
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:11:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D9KfdbVg;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760688684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jIfah+DAlEvXgjhi6Yuk+QGMNGhgMkvImu+g/AK8D6k=;
	b=Q+duD6DOjSC63kFb0PY13/1qjIiEEnzdQ4H7xnDc+9PgPzDzwjVdpnWPSBAIH5TK0fXw/Y
	6fo0YOeYkinhob+KnitTEIkk2RO6ksVOSci2hRi6EryFOZRUUbGOiJHpDTo4VOVdJ3yJ4l
	VIJYCzbhB2nVUqptMldJwzWsmpzpH3Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D9KfdbVg;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760688684; a=rsa-sha256;
	cv=none;
	b=u4zlhAAxzUMWD8wEsPdrhBF16GloHRBFWju2JMgPNkjE5PIk1J8AmYlcDtmYARle/USIMl
	1GiFR/0Wbk1JgoKU1I1ozqZsyr0cNaNYmJfv7Q90FZedy49ofaoXyzkjxoeAohUo1d6OQr
	CkZqZ6aVY5EqzJoVdLTiEjC3ruI67xo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760688683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jIfah+DAlEvXgjhi6Yuk+QGMNGhgMkvImu+g/AK8D6k=;
	b=D9KfdbVgchymvTLsIga5UoXDNDcdNXA1a1QmsH/ejXFdvVYAuVNfyWHizEjdtRtwpcsIXc
	IPpXFloD6frVQHRzzEHIL0W3Rqxc6NMCs7ommVO2QkpR8dTCOnofMUdghCEiJmbBebA5wN
	AitqBy6gNhZEaOQG5z4jnyeQbTS0ECc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-dkiZfc8TNEizLQLeJfF_DA-1; Fri, 17 Oct 2025 04:11:22 -0400
X-MC-Unique: dkiZfc8TNEizLQLeJfF_DA-1
X-Mimecast-MFC-AGG-ID: dkiZfc8TNEizLQLeJfF_DA_1760688682
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ece0fd841cso926598f8f.0
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:11:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760688681; x=1761293481;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jIfah+DAlEvXgjhi6Yuk+QGMNGhgMkvImu+g/AK8D6k=;
        b=RUyWncDVQtoPjWTqHaIxDbtH8hi+l12P2QMQmXVhy7fTxaYgl72f2pwsIFVnPXwcvf
         ImV3md1mRwIK62p/m7/snv0AoQ6aEwQCZG2Mys+vak2QcBqspjTK3lCZ55knT60hINuR
         6Jqt1idfFMhOJASuzCyxg/+xnlwHKsrpRA+JlB5djMau7Ikyzw9xZ+xXA2FyyOIgXLiv
         EdPD+8OeUr1Fyp0gE1l0iFnnb4hSfxiA3Bj3ly5nzLgRaRjzVQlaTtaVFTCI+7CO+rQ7
         DN5c01cCDnaLGtJ9JIes0/RfyuGDlSGVFr2mh4aQlQZPk4JM981v6BJWM7bI3veFK9xh
         NtDw==
X-Forwarded-Encrypted: i=1; AJvYcCWacvwqLsYktqdDY+XM5XELdaBtDNpxJoEyRIVBteepJQNblfxVCvXwREJjVzHV7PBpO5dy5M3M0g==@kvack.org
X-Gm-Message-State: AOJu0Yx9hu1ggje9c8sarTv9sHlfg+Sd7RRNv3M5GvpZyhkc7Zw2zE0e
	yZrjhWua/7yjSlC7Hd/k2exOPmF+/8Yym2egebaKd1OnSJ1qyUyEz/f195/reM63NDMmHC+9Azs
	KbJylxcLRVVVlPlxO3qF5dBCBM5Xk21gUzX7Ej/crxdzXL+lF8Loa
X-Gm-Gg: ASbGncu5AzfPIUz39/wsSw0zTiDclwKYsXOXGuwwwSad1Uw0DFLHLYf1SNX0WbBb35B
	t9dj94QeMkPFlDKQK6tCJdl7D9UFHmudSvihxzPn1xB7Ox/nrdZ/IKczkrNk9RrLCT2DSL1Dt1P
	+YAsOFA6s1PjNX5KM33Cok0/RRLUlxcIj7DJAjiXs8zcXFgIV3WMKgbU8lwUwwnzcNUwgO3ooQt
	2qrkESg2D4n4kOVu6nqkA7MQMmsLcyQYtnciWhu9GvEZV15xS6aK7Obo5SaxjwXVLtPHg3zJgF1
	4R4ZlG16L/0J70i829KL/y5ApL6Px6MScmfRGHjbKWqsPEKSOaPZBEy5DERfkMjA44fTJG1xXWH
	sGhhxJl1x8hZDHHo/iEoeh2YSotSwkzxq6F3IzjizlSA35trNmNVhqPnT83ev/UY4vvsEvfjDOm
	s6QVtA0RSNeLOCzsrF5Z74lPP2kwQ=
X-Received: by 2002:a5d:5d0a:0:b0:3e7:6104:35a8 with SMTP id ffacd0b85a97d-42704d98e81mr1969214f8f.35.1760688681569;
        Fri, 17 Oct 2025 01:11:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG8Cf7VNT+2WeB9mtccilKeaUe8M81gPubmwyVKHVTEOMjRsMb6naQEgT4+IDSbNebxQTfcaQ==
X-Received: by 2002:a5d:5d0a:0:b0:3e7:6104:35a8 with SMTP id ffacd0b85a97d-42704d98e81mr1969188f8f.35.1760688681150;
        Fri, 17 Oct 2025 01:11:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4270539be85sm4087942f8f.7.2025.10.17.01.11.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 01:11:20 -0700 (PDT)
Message-ID: <1674efca-6d4e-4247-8b1c-b6816360d8bb@redhat.com>
Date: Fri, 17 Oct 2025 10:11:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: guard is_zero_pfn() calls with
 pte_present()
To: Wei Yang <richard.weiyang@gmail.com>, Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 baohua@kernel.org, ioworker0@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251016033643.10848-1-lance.yang@linux.dev>
 <17c4c5f9-6ac8-4914-838f-f511dfbf948f@arm.com>
 <20251017012724.4bo5oj2g6tdmp2fv@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251017012724.4bo5oj2g6tdmp2fv@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: y3tOyq525TiAbBrg0JpQVXftBKJi4qXcHg7j3tkT-FM_1760688682
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tzircmrnkn6h9k6q4e1bdtuf8h4f3jqo
X-Rspamd-Queue-Id: 7F724120005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760688684-262260
X-HE-Meta: U2FsdGVkX19Qy1M5UFF1mtR/B8E56ZqYGvrXk6P6KiF1qfEctsUi7wQJUr+l2ApaZKWjDG8vRf1neas0uJPI6Nm03qwd0zjkMKvBVQOkAgBr3EDX/naroa9N3tkdov6yTr3gU8577zVbt9xqA+xuNlI/QUOoVxYsojMxSigCX8TNkoTLEpiGEtaOWK4mCJFv91vyJUKV8z+XmACMgzhp6V19XAw3dX4kMm5MtfIwoASWvDUt0Y6/qLWNm7Rnk8z8gtiBw8XX4y1asNKlqjgQDgOUfKjhOkPEo2Xw1xRNtLTlnTrtLHsa5SgM5T3adPvyRDKHdXI1IJzqgRnjFvvc3kcO1go/BYIyVPQjp2+DDUxcS5whJIbyQV6hZBGWhsJ5K1DOBI18SYyKqU3UrpZK49uvEpn2rzvQFmdIPjkkT/bdJwULPcb8wsU2OhDpK8DsyzzIYLepDPaU9DdItibZAryqn7TfOqzf9fWjcw3i3+3jNFSQ7a8sllBQeB6JMFE0qebpD2VKZR2KUUmCxmxy7Oel+JKHdw0kqMWSYvs8DLEmCBFe0MpfaSeUveD96Q5kSH8PNWOnbDJ53DNwZprfPSkriyR2dRvq9c+/cVAlLiZpvkhoCglFAcr8URH50cVvCSTERDUoFcembGrFHgVtkSYDB4CQ2cJpMtxjwDLbZMyvwJ+BPqNMhhW9yHJDD7MLRQf+C38ZDIm1kJAkhEh90r27LeyBcuP1QLYldD0tbWrrUipsQJ5Ru6fNhKDWn+V3GwtLIMWUYqTm+smeHtQd4goMzzoHLWl/j/O+lsLOQccPwOdWOco7QKSf3S7CANw/LEbOU15sI9r+98EK9ay9S9XeZY6ZLM7sdQrYwHwSSovnfb6o8ScFPpBDVhsp58rm7pXDzOM0ZvOCJOzfU4oVSqUcWVmyiioMq8KFGwKoZdbqT/UNc+mABf91LRE1dRxrSrXi4WCP42pyjZdf1b9
 ypJSxLqH
 9DA0ePQRgmYOCNwscnt0p0XczwB3D/5pDQNu2F2vdiktm5iJ9B9zupOR/wxQjQBjzrTmGPvK7B5zY5q0S2UcVUYU3z93IHaEAdKqIq1bE77iGeNVv04RC9+tVeKmDVPXFZZTT30M2+8J2hASk67aMC5rtc5YLaCPYqPbTVa+nrDQmBzw5/vkiwcmq4vzH4li7nr6JAiK+IdjXkaLqgGm73ZQ2kROAgxtsz04YIIzDT0LnaUIhHhMCaOH1FYULdx04dHpPvX/mBk6qp/9X6vfEILsXREr0d50uTns79h+AW19SI+2XUInIJjVdKIcD+DUb9xW5psL+pU01IRxHyv23KnS6UjjP5YY3H8sLeejXC61eaadA77ASWsXN2QD0d52QkVAWMBzEfIKDKhfvms9/yDDTsBkoGoq6mEZ78swcNzRyrlBD1A9xZQhDv+XeiWsxNF6FIONAECcr4ZiiEcLZ8CILBIwgFcxRdWUzn/pX/HIHpw/Zmw8fhS7zZjN0lDwqt9ZMzinlF8bNP84C2QX8S8VdNes/K+tRZTsVQDEK56hkKHlZJhjtUjp8VABlpz+Zz//d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.10.25 03:27, Wei Yang wrote:
> On Thu, Oct 16, 2025 at 11:47:06AM +0530, Dev Jain wrote:
>>
>> On 16/10/25 9:06 am, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> A non-present entry, like a swap PTE, contains completely different data
>>> (swap type and offset). pte_pfn() doesn't know this, so if we feed it a
>>> non-present entry, it will spit out a junk PFN.
>>>
>>> What if that junk PFN happens to match the zeropage's PFN by sheer
>>> chance? While really unlikely, this would be really bad if it did.
>>>
>>> So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
>>> in khugepaged.c are properly guarded by a pte_present() check.
>>>
>>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>>    mm/khugepaged.c | 13 ++++++++-----
>>>    1 file changed, 8 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index d635d821f611..0341c3d13e9e 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -516,7 +516,7 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>>>    		pte_t pteval = ptep_get(_pte);
>>>    		unsigned long pfn;
>>> -		if (pte_none(pteval))
>>> +		if (!pte_present(pteval))
>>>    			continue;
>>>    		pfn = pte_pfn(pteval);
>>>    		if (is_zero_pfn(pfn))
>>> @@ -690,9 +690,10 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>>>    	     address += nr_ptes * PAGE_SIZE) {
>>>    		nr_ptes = 1;
>>>    		pteval = ptep_get(_pte);
>>> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>>> +		if (pte_none(pteval) ||
>>> +		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
>>>    			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
>>> -			if (is_zero_pfn(pte_pfn(pteval))) {
>>> +			if (!pte_none(pteval)) {
>>
>> Could save a level of indentation by saying
>> if (pte_none(pteval))
>>     continue;
>>
> 
> Vote for this :-)

I suspect there will be a v2, correct?

-- 
Cheers

David / dhildenb


