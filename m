Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F77BC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 19:33:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FDD06B0098; Thu,  7 Aug 2025 15:33:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ACC16B00A3; Thu,  7 Aug 2025 15:33:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4746C6B00A6; Thu,  7 Aug 2025 15:33:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6336B0098
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:33:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A13ADBD486
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:33:38 +0000 (UTC)
X-FDA: 83750960916.07.69127E7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3B2D714000F
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:33:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xi9eMMs0;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754595216; a=rsa-sha256;
	cv=none;
	b=7tP6uu7udM3zcZqDC0iz4VewPziutg1SoQ975sRnNYtdIOqPbR3jjwflA54q+ZkSJWGQvY
	XVfHGX9k3HcjazAAaS9c7du0W8kFSPjeT7n0vJogAmzzQ9UXXKHAxriNsNbEgr5kigo1fu
	1dU/Owl+Q2g11TC3TBe8uw2KFM1bhC0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xi9eMMs0;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754595216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L3sfW+BuUN8qg0raSUf+jpJ80763tcAVtLgdzo6FODg=;
	b=e3sS3S3QjUm3Gin8maQ6SsZ67Md2CxcR0PxB4hp40Z+4ol1A8IKIuIb/+nI7NKaZy+riSx
	FRDW1/tDvm3Oaou2k6EycY+/X0PSKQkyg4TiQpPI7R0MKaOQZM1hmFk4Y9ykxLLx3dDl7G
	ImNIUAXTJJsp5eiq6tZBKm3ndvskWzk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754595215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=L3sfW+BuUN8qg0raSUf+jpJ80763tcAVtLgdzo6FODg=;
	b=Xi9eMMs0QN3dnKyuDFhVRN/u+u6ey/77miMTF3kJIeTniJdBWOdkXUlPvHpJfnAP9gEV7O
	/kqgIwy/+OPnuJmtIlFJro7T8S4FMdhade1RGVbFboo6f4iQunyWmi5cAO1d4nNh9xdego
	/BPk+sYk2MnqB9IZeqi21mnVXAAnS9I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-5gLmemtmNrOTVDQgj7kABQ-1; Thu, 07 Aug 2025 15:33:34 -0400
X-MC-Unique: 5gLmemtmNrOTVDQgj7kABQ-1
X-Mimecast-MFC-AGG-ID: 5gLmemtmNrOTVDQgj7kABQ_1754595213
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459db6e35c3so10833595e9.2
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 12:33:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754595213; x=1755200013;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=L3sfW+BuUN8qg0raSUf+jpJ80763tcAVtLgdzo6FODg=;
        b=D+XKwV1eoSuafngmdxdVeWiNvOKxZdeyYtTxkdr3ZbA4v8CtezownDQfHBARRZ9kqd
         J6RcV8mcem8m2wSEMpZcLrCYnzpwzDnELViUBsDQqqvXKQS8fnRjc23w80UK2mymxB8l
         pUB3FbGJ3Fwf7j/mMp+bKiXMu5DnZQcwYgqPj6CPUhWg+e+oeLp0bc0bJCwUw3XU4I44
         BdfFNFYLoydjnBDOxSuRdmbuuncm05iiz6FSTH2JrGLT6QpmVrjL00ap+rbO/wkCV6rR
         VWVw9MWBmfulMiGTemP6eSjq6TIvZVq2mbfUxBsUtbCWebnDiXz9wTnL2jEgBvqGTGa/
         7bxw==
X-Forwarded-Encrypted: i=1; AJvYcCX3K22uBaVm6HjyA8Cn/repm3W0xLrPbPiEqpZEjyt32KeN6HWpRzY4+G/wJ4mVFyiXKWudX90v9g==@kvack.org
X-Gm-Message-State: AOJu0Yz6aMtH2DglIUeFrc8cHbVx7A2y+CA1AWg0rlSe1FxVnCZF7onT
	Qe09fMbC3MMbrasl3eJecdCzCcvrxpDjJcy2UL7KHNxdL0yugjUdoRlgjnxMA9KIUgHDGEI3eoS
	DuyOiuxWtTdh0NdjjQ5ZBvb2X+gOfjQ4QS+/hOVQMCAcZIs2IDPQR
X-Gm-Gg: ASbGncv95SPZt9eojHps+CYhxtgL4EWz9507HBW5rM04vZHYcA5HMv6+vM6Qa/FdIvZ
	eMIjIIczg7cpCN2v0BdmHgNQKmN06+WYIwL6trMd0CvUulUw//T/MlPGi2eu5zCS1FbtziSGJTi
	j3w24YvWZFtzYu+sO00RIm8ZY7LC2BLD7eJ95gAdCDXwBxyzsSer+1CGisPhcvw2wjUpqCGwuVV
	jm6cj4SEYV5a/QFfpbgthgifDH/jnh1PNbWGbZvizSL2sGI+hS8+47ymlp1SveC7bRktQuQR4Ki
	BxfH/Dmn5rP2r7xKzZ0Xp40QJsTIZ36oi6YsG7vVQWVmeCya0mWsqHsCXXRgK1gzOWIkoC4xfKy
	vvHuW2JxcPV6iYN+s8pxvO7gfn+uO90VYrmvwg5usdtazdWhx9NleQMNL4M9Ggh8DEpo=
X-Received: by 2002:a05:600c:474a:b0:455:fc16:9eb3 with SMTP id 5b1f17b1804b1-459f4f3e33bmr1378055e9.33.1754595212778;
        Thu, 07 Aug 2025 12:33:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKzAaiLE4wWUDzv/kHmD0X6RwWzUT4LbWdsvRdTyvoc2LKZ8O7shwZOIhexGhHBHA6I/MKBg==
X-Received: by 2002:a05:600c:474a:b0:455:fc16:9eb3 with SMTP id 5b1f17b1804b1-459f4f3e33bmr1377855e9.33.1754595212308;
        Thu, 07 Aug 2025 12:33:32 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f49:bc00:12fa:1681:c754:1630? (p200300d82f49bc0012fa1681c7541630.dip0.t-ipconnect.de. [2003:d8:2f49:bc00:12fa:1681:c754:1630])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e587d378sm103146285e9.23.2025.08.07.12.33.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Aug 2025 12:33:31 -0700 (PDT)
Message-ID: <cb010f6c-4fd1-4d5d-87f5-4223ddb70f5a@redhat.com>
Date: Thu, 7 Aug 2025 21:33:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH HOTFIX 6.17] mm/mremap: avoid expensive folio lookup on
 mremap folio pte batch
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
 <ujfeyn2awquoc4pc7qxcnavgqcu57kvmdb66x2hyaeoiasq3w4@u5qlyyklfrld>
 <c556f29b-fffb-48d2-beda-a9e2b70aa4a4@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <c556f29b-fffb-48d2-beda-a9e2b70aa4a4@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Now-T1XJhbR63svK4HJNozKluSCI_ODgsZpJTk3iEIQ_1754595213
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3B2D714000F
X-Stat-Signature: 8hj4xbpi4jaqybhni19ch1xtpafisai7
X-HE-Tag: 1754595216-784958
X-HE-Meta: U2FsdGVkX1+5uYnRlqlQPrCI+tzqvdIaynwUIRxZcoxIXLUUzM69nvP+dnvXuNeZsn3xDubgVC2nkOXmRxHt4B60im0pFJ3RAMRURjbXgjEWdA65ILmH/hvCJAN9d40xsfKI35qXoCpGXKqFR+lVxispIB+1HrVqCyL7ZF0o8laxEMfJV/mY+PxsI/2S91SHyTX92FwrIvwtPqVSpfvLdJtEDorS3O/yuC93kxnhw7qGeRfunUHU3dU7yRelGLK9u4YSk3MQ5MmCCcyS7TeyNab2Jg5NoolXvMkjNt7uf/04bJGuXLNRw5SHjGtvvVefxOnknWRFODWXuaQmULGYproUbP2HKjziSQ/s49sHJVH2eZaaMgGwSnHpRhB2RRPsdq/RXeOf4nEwJ8neG53Q0sS2ZfJhv93QuZCSAcWtRaad8j16X6oo5XE3p0I+q/P15HYa+CGZAONQezYFUpFqkCoAELsBZq3qnKhMM0rmJevbuGWJ/BmVDf525/hDxg6JX1AAxZgoAOIBHqKH4GS4MIMHR3StGsfKeyDXPl6OjDM9ZhobS+/NQ/Lt54X7wKPNsWTeWbA/wx5vaLonuaWPbhhA9XpU1NiendnX5XfvC8WZ5Fb0sYySraO+Y/5rjYjRfiNcQQvEq7SghXfl1BwU6CaqES+3nqwAvwUijt9pz/CA7ubkKiZJNh8YGOo3SpQimzBQIafnAtTkDNmnsuCvDT3rw1uoRnNiJHKXJ74Zd1J8GLHydoBa7WRHdjyl0rWwiaDHw+lLL+M1/uo/zOCSeLwU1sLLJ/gzb5umz4/aIR4NSAqnti+rUBaX+SwqRc18lwao/yeapsqYztdmOd+XLvWcwV1agBxm9lSUym6MPplF4X5U2lrnJVENr+GuapX5DyZ576SBv3NBDvfiRz/tMuW7PJWYb3M5bMKq7KRP1TMBrVthcnZPWFT/nC+mbexifGbWPuSFKZRqCOiuK3m
 m61A6NVU
 BpsPAvmdx3VPvn008iyF7/1WsWZl8EMGjyED6nt4f5baZOfdht7Z+DX1/UsMou9iNw5+FUtDKYYOs22FkXny3wFw9nHMc1nVGvr01SP6PM1skCE8OvHg21cFlQ44iQ1Rx8pc1/cEwHw/Tzrt9GcBb7DBX9hJy+j2ASUog7Rc8tjMVnPTrZo92TIwmkh8oQ2OrNIA6cwoCtmEzllA7OvVb/cJ4tpLg3W7fz0Oxu8k10EOLCVIBXgQonYO2oaeL8F2813xQnkfyV7Je9BsCtGrLLPblLPIRfQf30+SVnW7ckkWM+hIhvsMtxLO+rRAA8H9R8Vg70a86f0zcpB1OTn9DY9dYwEXWdyNPKRRZkKonhAGgBrCKkBumuFxF36EXpygHwpVcZNeHVPYdnwn2wPFRy7vJUKBQHbboGA4WqqHBYfRHYq6UThSNYnMtVBg0AcFVihu9LNAj+XzwWjqgv3ieVheWZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.08.25 21:22, Lorenzo Stoakes wrote:
> On Thu, Aug 07, 2025 at 08:14:09PM +0100, Pedro Falcato wrote:
>> On Thu, Aug 07, 2025 at 07:58:19PM +0100, Lorenzo Stoakes wrote:
>>> It was discovered in the attached report that commit f822a9a81a31 ("mm:
>>> optimize mremap() by PTE batching") introduced a significant performance
>>> regression on a number of metrics on x86-64, most notably
>>> stress-ng.bigheap.realloc_calls_per_sec - indicating a 37.3% regression in
>>> number of mremap() calls per second.
>>>
>>> I was able to reproduce this locally on an intel x86-64 raptor lake system,
>>> noting an average of 143,857 realloc calls/sec (with a stddev of 4,531 or
>>> 3.1%) prior to this patch being applied, and 81,503 afterwards (stddev of
>>> 2,131 or 2.6%) - a 43.3% regression.
>>>
>>> During testing I was able to determine that there was no meaningful
>>> difference in efforts to optimise the folio_pte_batch() operation, nor
>>> checking folio_test_large().
>>>
>>> This is within expectation, as a regression this large is likely to
>>> indicate we are accessing memory that is not yet in a cache line (and
>>> perhaps may even cause a main memory fetch).
>>>
>>> The expectation by those discussing this from the start was that
>>> vm_normal_folio() (invoked by mremap_folio_pte_batch()) would likely be the
>>> culprit due to having to retrieve memory from the vmemmap (which mremap()
>>> page table moves does not otherwise do, meaning this is inevitably cold
>>> memory).
>>>
>>> I was able to definitively determine that this theory is indeed correct and
>>> the cause of the issue.
>>>
>>> The solution is to restore part of an approach previously discarded on
>>> review, that is to invoke pte_batch_hint() which explicitly determines,
>>> through reference to the PTE alone (thus no vmemmap lookup), what the PTE
>>> batch size may be.
>>>
>>> On platforms other than arm64 this is currently hardcoded to return 1, so
>>> this naturally resolves the issue for x86-64, and for arm64 introduces
>>> little to no overhead as the pte cache line will be hot.
>>>
>>> With this patch applied, we move from 81,503 realloc calls/sec to
>>> 138,701 (stddev of 496.1 or 0.4%), which is a -3.6% regression, however
>>> accounting for the variance in the original result, this is broadly
>>> restoring performance to its prior state.
>>>
>>
>> So, do we still have a regression then? If so, do we have any idea why?
> 
> It's within 1 stddev of the original results, so I'd say it's possibly
> noise.

It's very likely noise. And even if it's not, even a simple code layout 
change by the compiler can provoke something like that.

-- 
Cheers,

David / dhildenb


