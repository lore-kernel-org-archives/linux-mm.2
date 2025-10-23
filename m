Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 532A2CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 11:11:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8C9D8E0008; Thu, 23 Oct 2025 07:11:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A14518E0015; Thu, 23 Oct 2025 07:11:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B4BF8E0008; Thu, 23 Oct 2025 07:11:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD308E0008
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:11:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F66E490FD
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:11:53 +0000 (UTC)
X-FDA: 84029114106.24.B7A1F1C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id B0A461C0007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:11:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pj4iGvGB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761217910; a=rsa-sha256;
	cv=none;
	b=192guCmhYWA+WGaLmsi5JHgEIx9aUeeTS/87eycfrCl9jbSH5zhTPZdJhCzuo8tHdySRsf
	FwnKueiGMK+88MDOTVDSC+UrWvOgt99r8C5aobze87lMBUVt/d26ivvAPGoUkvZCcNauz6
	8QPJsrUK9Hh/0mkDFs8oot44SUwKaP8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pj4iGvGB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761217910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6bhJ9D9puoNFe1MUqX6TKFTSvBgiw0Qt1Ir2FpXvY+U=;
	b=pprJMwN/x/Q4tLo1gNhC+GE6CK8vkpwVy8HP/IHyKt3AhlxW/Af+EuTBh/ZPit5zRHrf5C
	1hVvEFUv3aKUx4qPxan4rzlcXeSezIRu+D58yew0d/xX1C4aBK8mWM38DHeXAQyYS5Nawm
	KwLLz0UTAf2MtrGZnjRxIvwSH/iIEXI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761217910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6bhJ9D9puoNFe1MUqX6TKFTSvBgiw0Qt1Ir2FpXvY+U=;
	b=Pj4iGvGBNgRzCw260I8RILBaitSRBQEVNhJzLOuPNzVMKUSGaHYl/Xm4e3EOswMHFCjhtL
	fEHgqeHIpNCO+j9AgKp8Qqv6AHWEs4zTYNOPsI+OcWD7cHkSsR6TaY5lriIFg+4Oo4NtIQ
	J1qGDQWYgT0srIWBsLBleY3HOERRIrs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-VuirbT6gMQWoSNOJmDGYDg-1; Thu, 23 Oct 2025 07:11:46 -0400
X-MC-Unique: VuirbT6gMQWoSNOJmDGYDg-1
X-Mimecast-MFC-AGG-ID: VuirbT6gMQWoSNOJmDGYDg_1761217905
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-472ce95ed1dso4207655e9.3
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 04:11:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761217905; x=1761822705;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6bhJ9D9puoNFe1MUqX6TKFTSvBgiw0Qt1Ir2FpXvY+U=;
        b=P8BDMZ/mC8Jtn9LgqqMrmCUOMnhte3LrEhjgWnK4Pp6dhNtTsGzh7lsvZf2XSxbW6c
         RoZrp0UQiN547mCUv96nmI4VmiUDoQzyL7GpOtal0ThQ5gPMygfKihGrtW7DfC8geH7R
         XqLn6Yief8HdoNJZ7X7qiMxC4Ttwcm2iDB4LgnLoHcJwabDf1szKIcIuF2tKj7eg/GjL
         tkzoRkje9Axz+4xELllheeCy7psiGg37a1Oun8GBmG1VridWVqhdJD+669N0+0d/Wa+h
         DZjR8bKUd2cL9u0bcIbb9nD7C7WtrJJBM4jSMtMjVz5VIZzEgQq90/NE//oA7bT/TGpf
         FVvg==
X-Forwarded-Encrypted: i=1; AJvYcCVXzw2LcOUqJQUHdSVmGdvRj6c2Vwqzv3YCLBfdB6Xy++xUKYXDkA4K4yZloTw4R27dTjpaNWWG2w==@kvack.org
X-Gm-Message-State: AOJu0YxxylWTJzdTi2pAfZPMIUqzhqNrH3Y3USSAHwhO7SSrkLT2v4H4
	YPIDrSCTQ3ulTvukqQAYEWtQ/0tzh/pi5QbjqJdsr3JuuYVtVZJKUOwlCxr7ixpSJS9gKIvVvhF
	6iwxZWZj9G6d7JI5dh/OhZF3V9BfejcWflOSIDDhyAc/pVgDEA/ho
X-Gm-Gg: ASbGncsYBoQSU62APBDGo6b3X3QjoHLjhPkdTHsmGxRBXg2LUFwDn0mKB9Py/qB2/1J
	ddNrc9qqlqDObJOLMiVC1QRMLnN26ejRLsdbomJ5W0ht5mH8UuO4m+uQUXEIl0jqlvR5xIC80ZG
	QnGfNFgTJdwTgZLDphD4U+rMM0Udhaxg/Q3ZvSJwx7ScV2Ue99e2yn+vH6ZEG3SvCpj6BZWJRUg
	3U8a8WyI80rI6UT/N4qIx5J41ukrR3ZF9q2r65n/54UHa/hurpn5/s+4MZc/Xunb1FLy/REQD1/
	PlgIaqusWiRdgo+i0lg8DT0ja7PUAquQr+YvBsmDXPd5MWcBkcrUFcmLlILZn2foT72h5vSe+DL
	u4jvzhiCq/tuGNVKFEbYKjDn88Rh0PAui1VuI9hGf6OhcdT9gx6Uf55rUCHP/aeb12CF5Q+UCSB
	Xx5+7cNM4BGdwcErGPzpQdliO5+7U=
X-Received: by 2002:a05:600c:a02:b0:46e:477a:f3dd with SMTP id 5b1f17b1804b1-475cb064926mr13576485e9.36.1761217905503;
        Thu, 23 Oct 2025 04:11:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjOTIGLdchiCXBCt7631vjjgeG9GW8BcZLSQPY9hw9ONCdFryCE3QwKhyQwOYvrWIr0Y7WWQ==
X-Received: by 2002:a05:600c:a02:b0:46e:477a:f3dd with SMTP id 5b1f17b1804b1-475cb064926mr13576225e9.36.1761217905063;
        Thu, 23 Oct 2025 04:11:45 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-474949e0a3csm60171795e9.0.2025.10.23.04.11.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 04:11:44 -0700 (PDT)
Message-ID: <5b33b587-ffd1-4a25-95e5-5f803a935a57@redhat.com>
Date: Thu, 23 Oct 2025 13:11:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
From: David Hildenbrand <david@redhat.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251017141536.577466-1-kirill@shutemov.name>
 <dcdfb58c-5ba7-4015-9446-09d98449f022@redhat.com>
 <hb54gc3iezwzpe2j6ssgqtwcnba4pnnffzlh3eb46preujhnoa@272dqbjakaiy>
 <06333766-fb79-4deb-9b53-5d1230b9d88d@redhat.com>
 <56d9f1d9-fc20-4be8-b64a-07beac3c64d0@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <56d9f1d9-fc20-4be8-b64a-07beac3c64d0@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 20jfsZ5oo4unnbYihv1qSIMfcPuWWE3VWUJ-oSHWOKA_1761217905
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: iiu45cye83pgaf15xuzm6qodaiqcmwy3
X-Rspamd-Queue-Id: B0A461C0007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761217910-102944
X-HE-Meta: U2FsdGVkX1+i9rfc4XQNiYNXIF/Y4/KqTgmzmGhoCOHXBWtfT3ezsLL3VEYp0vxsKYeqdiiOwPLi022Aud1Brp3IdBmMc8Nq2IlQJ6nIw7TaO/wgLPccYQkOiT3bJBbOj0ii4EkSXBm83NKG971lmQoFepJlaiCcY8l2ClDBZuYMnmq3Myya2axXsnOmdfEeUtQaGgaOIm80owmN4J1NaHyp6Nr2bi2l2/VyHvd0CFjRlbQMqtfeNN0girsivYClj5Qqxb35rWK2KdcGJfOGJrjTKiifYOqwMD0p3z9CHBL9E++yzd+k7eMpCnesJi7TYivmfMZFdqtWTkEI9EjnCZhAaFsPnemiiy3o7FWk3REksoXHIgPU3GRY/lgxRXfk/rbUN/0sMfo80baAr0MXWKwe/yINdoCLnBLl7B0x6V6KwIrrR9IsEEKBoWMJF3V8GKeoCvba+V2mF1Gy0I6s2Mk8KegA4oBIbrG7OJYoEO6gbwo4F9cl0P70TDzIJGD7F1xhKSzxAR3hbk3Q0YcboN/dlrkyPXINVzqejc6q+7ulA5O6Zx2X3q1TOJu0wfjMzjwLxO0evgTzDXvqrwR0pL2xq1ZnL2rsCzYp1N9NVTT8cD+g2+a8FE93kUWmXMqTgwcOcNxYnuahCdnZP7+NdLo/iqQIgUQ+ioOCNVm+ZTcwXI7lDkQQtaMU7ApYuGd/Z0qVbuQO9RvaWM+sGp7CQW625f/WCmQbm75BrGRfOVq9wJSs9Pdz6bqw86fBuAzFpEPjbuKk++2jc6wh9Y1EDJejymzpjCAWHCCEREbz93rfgIbB4xxz/fE/eVImKxU5LelVSLhlV/+6Gk//4ydl0/okI5D5WFtXPNvnbOo1sQFveCJh7/qqLbr1WhdDUAPTYpMkglYVTth8XRqJHdrCI9oYkhPOItYYwsYBUg4asRg3dKJO01+pEcEsizIT/8vUULTE0AR6kwhcVxjM1cW
 PQveJxlg
 jDNJIM2Pj9Nm7XN/FB9lswBu43d2QTYAcwlHG8B7jQNQOcQnN/lGYFkgBoHlhtpr+czaPHNjuG9VMNFhMa5EhjgxBc3bz2ngplkycK2fXC8phm1ld7JAOg0EAt7E7O6AhhaW4zMpa6XkyEbV7RJg0SFOgdceRpxc4IdgCNPBhsug8NzYF2IsQfgAbsiKAsrjo8c9SHrhA0VNCWlb6gEmxJVEoH522RLpIligv2deTqt9gETZUXx6WFE4H12RjKaXHRwPnyFWRwXRJnKaYhHBIWVnlUih6lcH++3RyhFfJU+KqcKCZLdxqnp+jsZZG9fR3pSNRF0Sseb3z4F7CFemzB9t0EvqjCTzSCEV9He3ORc6HKi1wWfwu9wXJffJxjqrr+PrH7hE3fGcG9ERP+vNhBF0V+14jxRvSoWOBiZXsHGdkMQErZ6RRIqV5bc01OJ7lToS5843/PPy5mK/YOZK8MguzBvMhsyDwJXOVDjDDRfb1C5zqYuOdRP7o+E3Yf27uFsSrZwIVjPu2zDA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.10.25 13:10, David Hildenbrand wrote:
> On 23.10.25 12:54, David Hildenbrand wrote:
>> On 23.10.25 12:31, Kiryl Shutsemau wrote:
>>> On Wed, Oct 22, 2025 at 07:28:27PM +0200, David Hildenbrand wrote:
>>>> "garbage" as in pointing at something without a direct map, something that's
>>>> protected differently (MTE? weird CoCo protection?) or even worse MMIO with
>>>> undesired read-effects.
>>>
>>> Pedro already points to the problem with missing direct mapping.
>>> _nofault() copy should help with this.
>>
>> Yeah, we do something similar when reading the kcore for that reason.
>>
>>>
>>> Can direct mapping ever be converted to MMIO? It can be converted to DMA
>>> buffer (which is fine), but MMIO? I have not seen it even in virtualized
>>> environments.
>>
>> I recall discussions in the context of PAT and the adjustment of caching
>> attributes of the direct map for MMIO purposes: so I suspect there are
>> ways that can happen, but I am not 100% sure.
>>
>>
>> Thinking about it, in VMs we have the direct map set on balloon inflated
>> pages that should not be touched, not even read, otherwise your
>> hypervisor might get very angry. That case we could likely handle by
>> checking whether the source page actually exists and doesn't have
>> PageOffline() set, before accessing it. A bit nasty.
>>
>> A more obscure cases would probably be reading a page that was poisoned
>> by hardware and is not expected to be used anymore. Could also be
>> checked by checking the page.
>>
>> Essentially all cases where we try to avoid reading ordinary memory
>> already when creating memory dumps that might have a direct map.
>>
>>
>> Regarding MTE and load_unaligned_zeropad(): I don't know unfortunately.
> 
> Looking into this, I'd assume the exception handler will take care of it.
> 
> load_unaligned_zeropad() is interesting if there is a direct map but the
> memory should not be touched (especially regarding PageOffline and
> memory errors).
> 
> I read drivers/firmware/efi/unaccepted_memory.c where we there is a
> lengthy discussion about guard pages and how that works for unaccepted
> memory.
> 
> While it works for unaccepted memory, it wouldn't work for other random

Sorry I meant here "while that works for load_unaligned_zeropad()".

-- 
Cheers

David / dhildenb


