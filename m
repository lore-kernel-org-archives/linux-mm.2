Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33A69CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 09:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5888E8E000A; Wed,  8 Oct 2025 05:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5601F8E0002; Wed,  8 Oct 2025 05:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44E398E000A; Wed,  8 Oct 2025 05:34:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5438E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 05:34:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C8E8E14049E
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:33:59 +0000 (UTC)
X-FDA: 83974435398.15.C22118B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 95326C000A
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:33:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OV7TkOmS;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759916037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pvNQ2sqsxcgVrxGJZXdoSqap7VzzZ3mjW5LxJACJ12c=;
	b=Y/4GQN5Xjx20w/aRGN1Yj1VIXyCTrscFRZHcTPECxdaCSY/7SJPvUmGDjgsfi56O3qaEgX
	ud7f9M3E5uRhCBc1V8v6XinLwOg5pTUE0lVNxOoSHukvg41cHCN/QmJMqZKCkKtLMdM1MH
	0mxXKz+M5wO34iio4LgoRxT8/8dfiQA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OV7TkOmS;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759916037; a=rsa-sha256;
	cv=none;
	b=QNHjhEKY92IVprgE+ske7V+2e+dMXBkePrGw+iK46mOqPMUJ1vQ0dzi17M/syVMsbHIpnN
	UmSAX/8Db084zIAQZXvbvjR2OS/Eq1B+sTJve1tWxE2kTh6nfqZuN6eAJP2w0GX6BQFaMV
	dPFgViBGMD6IcTz0dw/s6dNvUG3HkTM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759916036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pvNQ2sqsxcgVrxGJZXdoSqap7VzzZ3mjW5LxJACJ12c=;
	b=OV7TkOmSgisaZOAs+bl1jM68RZK2f8TnJxeIf9Wt1rj2QJdOPOC7opdHbwQLUNc+5wZjjI
	sz3+tel447YK1aMuZELwDOfSwEc6AxrzuoRQJOhOe0yRPKS+GQKaWcwGPHZov0cI3B5Zv+
	3DrWfjFKe3LoYvxngo+8BxdMQEUBUIA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-kP-h3lyBOyqGldFLhoPDFA-1; Wed, 08 Oct 2025 05:33:55 -0400
X-MC-Unique: kP-h3lyBOyqGldFLhoPDFA-1
X-Mimecast-MFC-AGG-ID: kP-h3lyBOyqGldFLhoPDFA_1759916034
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-401dbafbcfaso4382457f8f.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 02:33:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759916034; x=1760520834;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pvNQ2sqsxcgVrxGJZXdoSqap7VzzZ3mjW5LxJACJ12c=;
        b=RsEBxYEWaEGlswStrUFKvQA7CSp7cpt8r7/hX6jNhfdYNzpUQUMCCxR3evaKTM52VM
         yW6HZ9cK8tBWC06vHXGKMTKAMkrxafjAdA/erJ9yCy3OTI4zMrM5ycUHaqctqMvJpDPI
         BiTNP0gLyB9KUxiu/I/j9kEkGDlpKw1Z8+CwKE2d8+wkx+uYsZJowr6luvQCzSPCwSxz
         FILJbbrF6+CS8jcdPcBygppu9gpqc7g28ud6UCMXOIQM9LpuzZ4qBPsWEjCAm/eFMM/k
         e2vlQQCKNbUMphQSa8CGr7A8MGG4DPF1z2XYdOOBLW56rNa6ZJ+/Z8BfBhpJWsdqjLs5
         zOSg==
X-Forwarded-Encrypted: i=1; AJvYcCWHeqRN7ipT6hOKLUUVHes4cVMy6EgVdO20DHd2c0Orj5MsFjTXHBOgF2fcWkzz0OFwZ/8BC4E5oQ==@kvack.org
X-Gm-Message-State: AOJu0Yy4k5mHe9IAb1cLmXOuSZnOVwvLIJDb/+YbHPfaMsEfYSbNt/s7
	pEON2V6F0RJ6hXg28KwVMrWIIoZse0Kb4soPwEJ7WfUWbtAroLFY2avo+XHJwCGCTMPatUyEDwc
	eoWbbeXPnZqAHB9jBkuVl0XVEcMee9hZ9ADuGL19dZYIQVpOPIPLA
X-Gm-Gg: ASbGncsVy8dKgeu1eikAbkWAchD3x7n3u1z28+SnuUDLPP44MZ0vS1sYWsDrpgyoHg1
	ppmT5T18eGEMG2pgYwhAdEMZaWDVnz20sgZcHeaulT8Cmep7kHjY4fcge4MVWR1i4S5dlqtn9mZ
	6FxS98087lCsj72pwEHMmBPZi16SJajdc4lOcVvmc2kG2xphHPi0S/2X0RvgCSWDpmJZXlOGn1E
	TIOoxQqBppjyruQn8mO7nn83WryBsFef89m6T+zSQqBcKCKXPBz59RUtaJWJVoyXV/lNennB6EJ
	F26eT2fdpusGA1WDNe542zEkIKJXtPKn5+eD0YWApvwJMFURoeUExrG6pyPmrrpsLrPWibvS396
	r8nYGgwlM
X-Received: by 2002:a05:6000:2408:b0:414:6fe6:8fbd with SMTP id ffacd0b85a97d-4266e8de55dmr1525956f8f.54.1759916034445;
        Wed, 08 Oct 2025 02:33:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHRgm9ENNBAKPQVvD/piMECVRSv9+MLaK5jztOw4UsWToxz1h/ZD5Ud2PMOKOKZArxB19KvCg==
X-Received: by 2002:a05:6000:2408:b0:414:6fe6:8fbd with SMTP id ffacd0b85a97d-4266e8de55dmr1525932f8f.54.1759916034010;
        Wed, 08 Oct 2025 02:33:54 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f4cc3sm29006938f8f.55.2025.10.08.02.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 02:33:53 -0700 (PDT)
Message-ID: <9f35aedb-fd67-412f-a3d3-bb6692f7c2ce@redhat.com>
Date: Wed, 8 Oct 2025 11:33:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Support dynamic (de)configuration of memory
To: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-s390
 <linux-s390@vger.kernel.org>, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>
References: <20250926131527.3260733-1-sumanthk@linux.ibm.com>
 <ab366c03-8c78-449d-bfc4-2d155212d9d7@redhat.com>
 <aOVUNmDiWgrDJ1dJ@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
 <5e3b16ec-9ef9-483e-b97e-bff0c1915b19@redhat.com>
 <aOX_L1_2S30XhLRA@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
 <1efcb368-fcdf-4bdd-8b94-a705b7806bc2@redhat.com>
 <aOYrUEr-inqogzJE@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aOYrUEr-inqogzJE@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6ou8xKIS-zyUPPOuIKXTBsrda8D2XSXAlpLympLSvrY_1759916034
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 95326C000A
X-Stat-Signature: he5nrergc5o7cdd1wceydjr41ebbdhzh
X-Rspam-User: 
X-HE-Tag: 1759916037-243336
X-HE-Meta: U2FsdGVkX18+prfgKiJhwM6FUWxUfpFVv2NSWhibAsmai6htWbpulBipQweVxshWRPuu1k0qex2RgjStIPEQ+u510RqsfHunRD3/e6hWmpXDWZNqlVjh1DHBWGu71MuyhNVtdN1rBX3OAzVTBtC3kYIL7V+Km1imTcA0ijb7xyerz9V3Ed9AetrGJsGDsmTkh+3vDAGLMbG4xdWEKoY9wzNvit+cG/Q7ELA25r9ywIO+Mugya9VsXoCEMkAAhMKdx33RJQS/HdsbL9jAB/X5G7MCcHfw5PoYP470xfkxXDz13XRgY4iVW3IOelr2E89jOEJiaZONIIvzuOaRY+kyrS0I6tK7d9aho0DaeBo37ghON6fYilZ3VYz0thdp73yXRgCd4Y0jkGGxbz5SsiHNzyyzcVHWHiHwYnBRbiyW5Ud1bqiuuZ25zuj43h/wUsgDfFbD9mN51+wElljY1MKhjgW6s3FUt2A2wkKopSfRNuz37EC+JLwCgijhErAE/tN+O3hf9T/MH5KavGSxT911GWGOLArTQ7xJnqcVHpzmF+uvqogzcvWRMArDNIxtMAj1NPsZpn5xSoWr++5FBUnI0DvhZCvaDvtmlpQLOh8OqEQBYCCTS9c88aCefsFMTCBRM4kaLCMzPP9L2nM/MD61U1DVp2HQaqMtg64FD37kJrdi0DVSGI0F/CEfK6QWt683v44jrys5UdUeJXqSvaHYng2gVAIy/8O99QLd1RU/1D0Pe0Nov3H5Fi77rhiIoT/Sp/Jci/xXJYnAKTusgy744cvs3YW8jB1yu+33zlM5YI7BSQv9yhloAfzQ/5uguCHDv24EUtCgCCC08CYdeHO+IuBBIXC2abkjwcUcEyTMPHPhzEhjTmIf18Z8x2NVN7ofvcdNIcFFvQn9c11XruuDTEdR6KHJJxqct2yYuusQlC3H6hCgHmud4WrusNRnzeQ5awXxRsB30RcjOrR+pGM
 zDe1+VIT
 kdPkrpsAG2c9+/I6usj1QoxLtCwNqtv0Urw7D
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.10.25 11:13, Sumanth Korikkar wrote:
>>>> I wonder if the above two are really required. I would expect most/all users
>>>> to simply keep using -e / -d.
>>>>
>>>> Sure, there might be some corner cases, but I would assume most people to
>>>> not want to care about memmap-on-memory with the new model.
>>>
>>> I believe this remains very beneficial for customers in the following
>>> scenario:
>>>
>>> 1) Initial memory layout:
>>> 4 GB configured online
>>> 512 GB standby
>>>
>>> If memory_hotplug.memmap_on_memory=Y is set in the kernel command line:
>>> Suppose user requires more memory and onlines 256 GB. With memmap-on-memory
>>> enabled, this likely succeeds by default.
>>>
>>> Later, the user needs 256 GB of contiguous physical memory across memory
>>> blocks. Then, the user can still configure those memory blocks with
>>> memmap-on-memory disabled and online it.
>>>
>>> 2) If the administrator forgets to configure
>>> memory_hotplug.memmap_on_memory=Y, the following steps can be taken:
>>> Rescue from OOM situations: configure with memmap-on-memory enabled, online it.
>>
>> That's my point: I don't consider either very likely to be used by actual
>> admins.
>>
>> I guess in (1) it really only is a problem with very big memory blocks.
>> Assuming a memory block is just 128 MiB (or even 1 GiB), you can add+online
>> them individually. Once you succeeded with the first one (very likely), the
>> other ones will follow.
>>
>> Sure, if you are so low on memory that you cannot even a single memory
>> block, then memmap-on-memory makes sense.
>>
>> But note that memmap-on-memory was added to handle hotplug of large chunks
>> of memory (large DIMM/NVDIMM, large CXL device) in one go, without the
>> chance to add+online individual memory blocks incrementally.
> 
> Interesting. Thanks David.
> 
> Heiko suggested that memory increment size could also be upto
> 64GB. In that case, it might be useful.

Yeha, rings a bell. But that would not be your 4GiB scenario you shared :)

-- 
Cheers

David / dhildenb


