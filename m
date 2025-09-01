Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB15ECA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 096F58E0039; Mon,  1 Sep 2025 08:54:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06E7C8E000F; Mon,  1 Sep 2025 08:54:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC5C38E0039; Mon,  1 Sep 2025 08:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DD7248E000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:54:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 785F585FF4
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:54:14 +0000 (UTC)
X-FDA: 83840674428.15.DA9A0A2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0BD3320004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:54:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LdTqIwmd;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756731252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vyych5IUQLtEu/xa/A0XqGkr8fWN8lrWcKM9TaSPFq0=;
	b=D/0m+vTBcDDF6ve0w52zuIWVaGwPMOfPSHJ+FK3ebkXijWR4pdFniFYPFad6VOz8nYTOQ8
	AX6M5nVYIhny8KzV+ntQvSzueAZ1wnM4xbR/5ZtKKOhdNOW5prWupmWpOGQzTv20SnxvNP
	xzdOs86rstV0n/XDx9s9ZOBRCf7VdFc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LdTqIwmd;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756731252; a=rsa-sha256;
	cv=none;
	b=1p4X0iLQ2XdEVi7QZujge4xa2xst19Ahe0VU+L95EEaYHdF/rseKBZF2KYHP5MnGbKMsqj
	ElWfVMXlyxdjnaa1KAPdRnJbuoRfpgGMTltffx9bwUAB3s4i+d7fLo6fst9Nkagyf1o9R4
	jeMM7m1w1AFmPmbVhA9JDcG68hrOVqY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756731251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Vyych5IUQLtEu/xa/A0XqGkr8fWN8lrWcKM9TaSPFq0=;
	b=LdTqIwmdQOqCeT7h1LP4m8N7+6Nq1CKsYFsODcmWqHeu5qRPD/kDzumZG+mH3DcK0nGsA4
	fstImcxB5GslOdh7w2nDgK7h7uGCQlFN4jm59LRLlXvTo3dNeuSg/xJCrqehecY/82trWf
	kxsOYw8syQV6Mr6y9olnPxGNx50qNoA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-p9oJ4-4ANW2xAuFZmOO7uQ-1; Mon, 01 Sep 2025 08:54:10 -0400
X-MC-Unique: p9oJ4-4ANW2xAuFZmOO7uQ-1
X-Mimecast-MFC-AGG-ID: p9oJ4-4ANW2xAuFZmOO7uQ_1756731249
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b8a307c12so6149435e9.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 05:54:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756731249; x=1757336049;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vyych5IUQLtEu/xa/A0XqGkr8fWN8lrWcKM9TaSPFq0=;
        b=pI4wkTtl6JQKDw0YaE6YXYwmwwPqukHikXwjJFheq+reJL1J0ZIo3oNSi3SuZU16sj
         caFeZry0AXcIzN4Tm89UmZZaFIv7tQeDTKcTKhZod5n+prE+6o5bVMmWflZOigiyxZBx
         R6mlwA3i1oAeji+ZxZoxW0Kt28QRHWD8QOu2QKGK6vear3abHWCw9H3s6u3zeuqwdYU1
         pHAWaQKd66x69NWvNvyRQkeyWxq9ATvIc9Mi1AZWL8I/Z/ZMXPhHBjBkYf8KGi7kLIuJ
         fjfckpoSjxjX9UBlsQkM5HWDqXESMwgRHhEBod46HX8evz3oq+F4cF5aO5yn1CbQrCoo
         ktxg==
X-Forwarded-Encrypted: i=1; AJvYcCVUsTiYLQCK/UMnc9ehHCWeEaT+FA+dl2Q2vMCvWfQJJXA/8iNh7KhYekZ/0Z/UR7sH/+MuzSg7tA==@kvack.org
X-Gm-Message-State: AOJu0YzxQ/BExrzaZk9QutntssIvURhJc7M6lHNOSD9qyxo21JgnSuyX
	ZC4AKFhCZjL+4UCjKXdY5S71B98VO7e39wbs+9TueqPp1tY+iKCZtI5zEhxOHhVCYy6xdfIfwjQ
	lTRKyZ2ITHyvrXyXDtcXij0pBtoHH4dNdKcrZ+/MpbbNNg5iv7Zwk
X-Gm-Gg: ASbGncul2qJIz/QoT3dgfqgruO5Dm+g/S7R20Ma41MpAV3/nIvwG1iWhUQbuN3eUY/f
	cIIabi5+zDxMfhFVPJ6qkmhKQ7lPszbhHMsiO3IswI0vRU9jloxXvZKOyNO4z+0Of/0sm4uV/Ga
	AGGE0LEoDkTgCyCIHFnp1znLrHvHm/lDSgfZuShFdOPkhsTHAzpjVPAiEpRWmsSWIR4i2kN279N
	NwVPBjwL5erIbUX7O6ubrsSWS+FvmKAjfgaoIjaafz4ahleZJr3BT94PfXHvhWRdfWxEVziQn46
	CgAoZz9kXK78jY8gPLKXXxjtRMZv7aNCBp18hl7bQr6Bxqv6qT6v0irv6EsoJrOn7G1LCPFGAUo
	uahQSIX88DuwYOy7ce3/oY/eJtFRenNT5NDMgrtLSZBhAJUGH1ZSkjurI4F/2gzCDYT4=
X-Received: by 2002:a05:600c:3543:b0:45b:87b6:1f65 with SMTP id 5b1f17b1804b1-45b87b62146mr51137815e9.21.1756731248948;
        Mon, 01 Sep 2025 05:54:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0CKCVqu16gwWVYQD17Tvg0mK0Hr9EQxiFvygZkxb3jpFTWdzldhbTv1mVs1RCO3C49asHCQ==
X-Received: by 2002:a05:600c:3543:b0:45b:87b6:1f65 with SMTP id 5b1f17b1804b1-45b87b62146mr51137495e9.21.1756731248488;
        Mon, 01 Sep 2025 05:54:08 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e7d2393sm155934915e9.3.2025.09.01.05.54.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 05:54:08 -0700 (PDT)
Message-ID: <76079f7e-9874-41a5-ab00-9fa4765f8ee0@redhat.com>
Date: Mon, 1 Sep 2025 14:54:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: directly add pagesize instead of increase
 until page size
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20250830023102.14981-1-richard.weiyang@gmail.com>
 <E0C570E7-C4CD-4E41-9590-DDB64757CA2C@nvidia.com>
 <c89a9096-716a-4bbb-a911-99096ff8f0a0@redhat.com>
 <20250901125126.furb4fkgim7adzhq@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901125126.furb4fkgim7adzhq@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oQa2KBYHsanGNjgVwRqaaPP_gSXwywQZUOTQubIWzDg_1756731249
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bbzskhabq3xjfbhiumrrwrh3rxaoaore
X-Rspam-User: 
X-Rspamd-Queue-Id: 0BD3320004
X-Rspamd-Server: rspam01
X-HE-Tag: 1756731251-153687
X-HE-Meta: U2FsdGVkX1/+4zGqpOGFghZS4Qda2YD6TZYlB9/ug7NCu055L4h29hctoUthyKONzUhbHh9pFwWTyxaTdW6QEZztb/rVIktI5AxIRiWw+WEalvI1eqw1yeaaL3KmQFPfwwR0X2votCtzqamdzoknOamMGLwpadwM0scUyEjOA2VWWqaJVyaNybrRVyvGz9UU4Npw8jsB6tjRcvavthOA+l6C0IpbES33A9XqpG4PEYqYWhRPgjKVLySie6Y1o14O048FCPBhUifhjXrS/AiCqenIDP+v8prU04oX1VArS8dHOfoUeaV2wSuzoF7bcginft8iZrqzoce0B27Uh7cBEvecpUzs6Nb7kdULDyuB5EFt7epUuU/bCoZjD2qi+5l3MzXgRTD7iIYmNF2aUlqcjz94eWKr40g6oAV4KXaC0hGpvRaijH1L8Gynulx43yQKu5KH1k44wdmZtDJwoRzoIfrtafBmfo448YzRikSwPUYUGR4FGVqrwv1kmJUn2Gt4HRi1Teei178eVkT0u9Ihp1lD6KYWpVyitQ0cildO0LpzYUCZK12XOvoveoXVM0zmNdsffOMd2u3j0Kdm4uc5IK4kYcwGaG2LPUUYkQqccj4hwYtgVwhgiY1v3RkTK7oeG/mWpo9ukLvJsH3NIHnRdMyayNK3RkbxuZah+eAcRdAiTXJpVmS11k3yfIRPCv4u1Ssb7U0tOa2koqTyoy4LsFr87/Utars2+a96FZ/8hVW9cfjgFOsxbZIutBePuZbtPFOO8f3ieVET/wuIYF7YtSorGVvbU9XUQ70UwshAr0VNkbfu2Mf2xkVx8f0QLhSjiEl8fJTcwz7yr6vUd9+6teeWAskOjnTsYRsRRER5njvYezp42LEo37Lv6BmlOMdUbAJuCfeEV1qmRwZBVOqUbtGAK4C6kaB8vs9rAbtvnwbHjOvv8Cb31XaRjKemmrJBTmF/wc+dpQZJV4bjhV+
 KehJIQLG
 aMmMRl9GAUZTBZ/f4FPO86ppb+ptuz/MtXSHmFJkqiwr34HgJ6VMBVJTpPakQOtE9OdDMC4tkVcYVWwLPmS3vxU+uq1qZBw8NiXsBjutO6NjWhMvkPvF0BD1tkZdTZaHRjubfM+qrhhW5hZntN3p0R46lWcIKY3iHiFI5CmLC4C2Rf0GW6X4cZaitzAAdYullZEymrtL4dCDpjjO57bTi32EGOZa33TrQGURBy4BWmo3siQMssL0EGr0i5nxi3La5IRs09In/ZxzxRApi4KZfy7rc+sqwlNE4Q93/MGA84jRDlMbYd/laRtgC+buyg4pi3ijarb5trSAcevBf9jfyfzAlPcj2liAmVvZ1GW5gwr7LbKtd/z94n+dlwt0uzGeQo4DOcTXWO3mHaS90cjqaUIO1fhQ/NOcCRjsxnBjIiYU2Z3u5yy3m9HSSh3YZmJbVGMUQO7tl6Q3du3uTPc1i90fj935ws1Y1BCv6J2ydGLJwcqT5tbxe6mrMVwLi2JN01Zd5RqubLJQs7OlvbbrEfOWQoAzjjc64KyyGSEs9molZ+P9oPbNHpDS5Tjj+pxCAw5Qxynf23QumWH0jMkw/b7rkhGYKpZNi0oEa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 14:51, Wei Yang wrote:
> On Mon, Sep 01, 2025 at 11:32:11AM +0200, David Hildenbrand wrote:
>> On 31.08.25 03:32, Zi Yan wrote:
>>> On 29 Aug 2025, at 22:31, Wei Yang wrote:
>>>
>>>> The check of is_backed_by_folio() is done on each page.
>>>>
>>>> Directly move pointer to next page instead of increase one and check if
>>>> it is page size aligned.
>>>>
>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>> ---
>>>>    tools/testing/selftests/mm/split_huge_page_test.c | 5 ++---
>>>>    1 file changed, 2 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>>>> index 10ae65ea032f..7f7016ba4054 100644
>>>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>>>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>>>> @@ -423,9 +423,8 @@ static void split_pte_mapped_thp(void)
>>>>
>>>>    	/* smap does not show THPs after mremap, use kpageflags instead */
>>>>    	thp_size = 0;
>>>> -	for (i = 0; i < pagesize * 4; i++)
>>>> -		if (i % pagesize == 0 &&
>>>> -		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
>>>> +	for (i = 0; i < pagesize * 4; i += pagesize)
>>>> +		if (is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
>>>>    			thp_size++;
>>>>
>>>>    	if (thp_size != 4)
>>>
>>> It might be better to add
>>>
>>> if (pte_mapped[i] != (char)i)
>>> 	ksft_exit_fail_msg("%ld byte corrupted\n", i);
>>>
>>> instead to make sure mremap() does not change pte_mapped[] values.
>>
>> We do have a corruption check later in that function, so I think we can just
>> keep it simple here.
>>
>> So this as is LGTM
>>
>> Acked-by: David Hildenbrand <david@redhat.com>
>>
>> As noted, we should just move from mremap() to mprotect() or sth like that
>> which has clearer semantics.
>>
> 
> If my understanding is correct, we should
> 
>     mmap 4 PMD_SIZE region with RW
>     madvise and fault in to allocate pmd-mapped thp
>     mprotect first page of each PMD to read-only to split to pte-mapped thp
>     check whether the page is backed by pmd-order folio
> 
> Is this the correct way?

Yeah, I would just mprotect(PROT_READ) the first page of each PMD. That 
will trigger a PTE-mapping of the THP reliably.

-- 
Cheers

David / dhildenb


