Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D4BACA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 08:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9682D8E0008; Wed,  3 Sep 2025 04:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F92E8E0001; Wed,  3 Sep 2025 04:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792408E0008; Wed,  3 Sep 2025 04:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6326C8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:13:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 115CBC0548
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:13:45 +0000 (UTC)
X-FDA: 83847225210.04.43B469C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id AC12F1C000B
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:13:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BEVQPOAN;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756887222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5T13e6DDVQ5mlidba2ps1Pa0u8cV/VpPy+cX77T2t/U=;
	b=w2XLcTrzJNdMvliQgmRHXr0rda+CoHxdEgVCS9s50iaz8NgfQ0X6vqln6z/6THzg3SC0qj
	OZm29Qav335Auq+HNyka+Nk3y/VDP0jgZjMwP+rGG6tm+ralbsUjKes9qeAXj97pIe0suu
	70OCtp4YHOzP9GfFN7xltRiJPgoXGLM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BEVQPOAN;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756887222; a=rsa-sha256;
	cv=none;
	b=jclZKmn5xHIvsJB0iJ62HAalveAgBzBF8CdxPRr7cX6YoLJAGfxrBe49fHbOwQ38DnUIMy
	mKjVwCd7iBgOgl9oZmBJrL+SeI679Q+/uDu8an3228SXQUjw13uBC5NwLprySUedbNKG/9
	7714Loz82FSaDIfvz0HF+jJaSq3IhGQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756887222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5T13e6DDVQ5mlidba2ps1Pa0u8cV/VpPy+cX77T2t/U=;
	b=BEVQPOANgGb/qJSD5XymhIZiz5bw90uiqBhl1Ye99vG4u1Nllu1zDtJxxFNvcNm5SwCHkF
	E/tzDle/2nQfCRc7bWKosaEhckFU7FCFA1dPcPyKym4piU8tzl5lnvODivl8/hruvORG6F
	Fob5a2EWYGXWWXh+ZtFCcTuHoQJT5n0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-iJepcXt-OWui54xGMEVIQw-1; Wed, 03 Sep 2025 04:13:38 -0400
X-MC-Unique: iJepcXt-OWui54xGMEVIQw-1
X-Mimecast-MFC-AGG-ID: iJepcXt-OWui54xGMEVIQw_1756887218
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b8f4c2f7fso21231385e9.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 01:13:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756887218; x=1757492018;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5T13e6DDVQ5mlidba2ps1Pa0u8cV/VpPy+cX77T2t/U=;
        b=VZRxaDPKuTL8fnvEq1bcqi//VakNbFIwMLveXHi8ZBbm0ClAChokzvEgvnrYc3o5Lp
         D6lLCTDZis1xTzrL4k3F/3u0A4QT1abDj9KLn4WWt+0HLym4e0kOnUmnA6+2h1ufg7vW
         lSzuVQ1rMYlUV4fpoeVwxswolMBdQT+bmqLzUguzr3TL8YTmPRhswxB1LPwbLX9TbUcf
         KcOpwLUNlRPOGtdgAlFChN64dvfpHjBc1jjuDj/lpYZuy9Jsny2cObzHYGR3MaQ7LF5A
         TZmmomOoGXYqvTPtWvpHq1p4UaADKEj1y0MCf1r8SJCBv57bP4lPpM+ncxBrzr7YFPL1
         ZSYA==
X-Forwarded-Encrypted: i=1; AJvYcCXYiFMpoTgkpgZUKcBh8yqQKqOLnIocTnx3Ft7LOuWkABVH/5XujrXFtldvX1eRXnHvxEaRgMhW0w==@kvack.org
X-Gm-Message-State: AOJu0Yz3WOfK3HnNjd7rEZoDdOzXvHJCVa9cxxlsb6oBOsGdnsnRaSh9
	tqtd4B5bzqQItOtRcK7DOLRXOW9Bx6GCKM+3A4wL+RakpvZW4IC3iKvG263z7a/AZYMajgex1T3
	XVDTh4xqvfB/tuQxAcwNaGcZAcI2uck/vhEEUrv3Nf6WxfALN+OeV
X-Gm-Gg: ASbGncvZAyJ6EbTZSEyfm5aViG6qhqBg0O82XGK6am7RiVnkmvypksflHy9WYLX/s1w
	KPoGX/ULAlC8nL30DZdlS7oWU66WqXXZV/n2kfW9C/CaBIs35ycGMQ4yLswPNvlPdv9IhkZZBwm
	WZEsZkmyA2gKV+dD0YNIzXAOaq3wtPAT9XX2EW6F4KiB/hWGXY22YLk8osPO6LlJjL5NPoizr8P
	df/ko9QFw//aD511GnmnLJQLqxU3M1yoVdRUgD+Ao4AIvpKwgSB5QU8BwOLXWa40hiLDy3UZWH4
	jAR4WwFVlzSFpZZJrStCK9N5WyinQ2erLThQllZYEUI1QY+NtLKcOtorq9HGXCPyt9Oz28ooehK
	3e13uATTFDN3PySVXFtyErZCRi/y+LmsSmFUpSH7us/ME2hlmVhnfSqMNo0Ak48XRH6g=
X-Received: by 2002:a05:600c:4816:b0:459:d3d0:650e with SMTP id 5b1f17b1804b1-45b8555e01emr72709585e9.13.1756887217692;
        Wed, 03 Sep 2025 01:13:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEypdG3WMnPu1Akg1ScMhfh0zsYVs5yyCGaHvvaGEjUQUmSxY1wD4AvNm+x1sllQB+cOt5EMA==
X-Received: by 2002:a05:600c:4816:b0:459:d3d0:650e with SMTP id 5b1f17b1804b1-45b8555e01emr72709435e9.13.1756887217245;
        Wed, 03 Sep 2025 01:13:37 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f306c93sm313894595e9.14.2025.09.03.01.13.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 01:13:36 -0700 (PDT)
Message-ID: <759bff7a-3918-41ac-a184-8c07ec414bb2@redhat.com>
Date: Wed, 3 Sep 2025 10:13:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: Enable khugepaged to operate on non-writable VMAs
To: Wei Yang <richard.weiyang@gmail.com>, Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, kas@kernel.org, willy@infradead.org,
 hughd@google.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250903054635.19949-1-dev.jain@arm.com>
 <20250903080839.wuivg2u7smyuxo5e@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250903080839.wuivg2u7smyuxo5e@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VDJjw5Iulhep--qAaIFtXyTxStYwrYENqEu00-Z1iNU_1756887218
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC12F1C000B
X-Stat-Signature: qkmsndcusung83bdii6ffnw1gbmud89h
X-Rspam-User: 
X-HE-Tag: 1756887222-924550
X-HE-Meta: U2FsdGVkX1/Dqf1KbIDzJ/zDQnPglbA3UT0Ej9tstKplBRZC/tSh31XQfbhZVcxrFQBcoh9GzFQ1A6C9BJeC8LPET2YDXITtc8knT++T5wiVWvuJJZc6AN0BWfpWe1/FtAopOIijTEXbcBsPYwWSOmlpMN0LH5UfKmMNU6yrwUp/yIaNN+Oct+QALojjwx0YyfNKldf2F5OUqd+lWXQq23hGZpS/kJHPcZSOKR1/eRE2vKro4+ruP+TzZMj/4NI87XF6GziWbpA5DQ7To/gO76gRasnLK/Dx2lQ5UVeRKfpedRiE1yEyt5jBCxmNarKxSpY1dDHQalev09gYoF+jLoLV4DwQJdyQEfuIlz2fZZ9sOWoOF/zKBalvDjD2RQ9SjK7y2u+fivXuLy1jA+awPYcvR3xSvSEkmaM9K4yHhO6yErN9c6x7HZd/74HQnMXJrmrJJoXhYPv+c2srpyzqtkXbVdyJY+PHIVdkWlc5DTsNJTh5ttFlDsv3IcPiE6FqeA9hBpSsER1yXOWiA8d9GDjzsBIoSrBlmovfZb7FqNg9rfZ0iavYuPKk8WxjZF1T81kB0WDYwKT6kkoDQfQiqS0RwNG5pQm0hoVACDHt1AJqTfyXe14EqrfzABigsTwAkK7X4WtsfGVZEA+T1zEN61EK/uHYZSWndLpzFD+WCTujuZMKSP980JzcUiqkpgLSDBdz3zPT/KEk4MWXG86x6fm5fc3ql9RMQgq0OmOy81BUrxoNJkBs6YeLFhOGQyb773slbpmhJCIUc037cCl1vd6WovYFC7Bo1JkMVkeambchOMlgD7HPKvoJMTHKr99yTr0+mdy4oheGjfrsTiIm6Udp+JYw4qjhtSlghxWd7yw7Mb7jO6d66PbhubIYLzju884ydEKwK8+UcAJri9HahVHimzMlIMamAnBR4KVzoMio5slI1X5pm42ZOIJXdvsrOo9Spk9u4QKGMHo0kji
 Cnlu9uFp
 DYy3iZjYkNxUoyg//wHqxdDn1St9zulkrLYNdHb40F9HxqRezhK0SpbSEGB9dNTKaBO6OiRwvzm6piqCfVlDCpPYkVYJP5I0/dqs5gacO6qyO0seEKmhC3tPFUVskOBsWT5J4OiKwSAYRK0kDa7/74oJGpsax1oiiPfZh06hLNIQoVj8n6L+QGKekG5ezlVdPCXBX1Mojcx+6Ba3dTc6H4YX6uw9CJRSWB72w6Ah+NfTkaXq6l9nvIQ3S9oqYVBlSDI5KRlqL2zsRNgRYafLb9UNOLMOwwrGY3a24IGIFH3PLmS+5dUI4hCVcmI/tmpVM2JrnKXd/a7B/1vsS2WdBRstEXrKo5In/Bf2Ob5JmgZHiwMtiGN7ycMROPJHHkrTw/Fn3lJ7RjeX412HB09B4DHg4pXv6zVVDvaE/Cwgt82qoMZNOu6JUFZ6BpT81MHwYm8fP8no/Fw2ieyEFwkuIY7TgzD8d6zUh2qTPVMXJ/4VDS5V9XtKJoXa1rEd4E0lwVVHuKivv2jDaHhRn74SncxRYjmQHGEhqFRd40HQr205aM8RIy2AQqff+WQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.09.25 10:08, Wei Yang wrote:
> On Wed, Sep 03, 2025 at 11:16:34AM +0530, Dev Jain wrote:
>> Currently khugepaged does not collapse a region which does not have a
>> single writable page. This is wasteful since non-writable VMAs mapped by
>> the application won't benefit from THP collapse. Therefore, remove this
>> restriction and allow khugepaged to collapse a VMA with arbitrary
>> protections.
>>
>> Along with this, currently MADV_COLLAPSE does not perform a collapse on a
>> non-writable VMA, and this restriction is nowhere to be found on the
>> manpage - the restriction itself sounds wrong to me since the user knows
>> the protection of the memory it has mapped, so collapsing read-only
>> memory via madvise() should be a choice of the user which shouldn't
>> be overriden by the kernel.
>>
>> On an arm64 machine, an average of 5% improvement is seen on some mmtests
>> benchmarks, particularly hackbench, with a maximum improvement of 12%.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
> [...]
>> mm/khugepaged.c | 9 ++-------
>> 1 file changed, 2 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 4ec324a4c1fe..a0f1df2a7ae6 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -676,9 +676,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>> 			writable = true;
>> 	}
>>
>> -	if (unlikely(!writable)) {
>> -		result = SCAN_PAGE_RO;
>> -	} else if (unlikely(cc->is_khugepaged && !referenced)) {
> 
> Would this cause more memory usage in system?
> 
> For example, one application would fork itself many times. It executable area
> is read only, so all of them share one copy in memory.
> 
> Now we may collapse the range and create one copy for each process.
> 
> Ok, we have max_ptes_shared, while if some ptes are none, could it still do
> collapse?

The max_ptes_shared check should handle that, so I don't immediately see 
a problem with that.

When I thought about the "why is this writable check there" in the past, 
I thought that maybe it was "smarter" to use THP where people are 
actually using that memory for writing (writing heap etc).

But I can understand that some pure r/o users exists that can benefit as 
well.

-- 
Cheers

David / dhildenb


