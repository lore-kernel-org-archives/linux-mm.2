Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46F3ACA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80C4D8E0020; Mon,  1 Sep 2025 08:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BC648E0013; Mon,  1 Sep 2025 08:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65CD98E0020; Mon,  1 Sep 2025 08:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5000D8E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:17:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4BD413B182
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:17:26 +0000 (UTC)
X-FDA: 83840581692.24.6C52B67
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 91331160004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:17:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GKL3fhdY;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756729044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E7wsDKVeU07tqfba5mhUpd3DLLKgZKYNe/5Ehj98m6A=;
	b=CCz/B3sUPlPvEnZDm4T0e0RuP5MD0mT368J6YD3tn54QYX9n5B/cbfB3xU1VWFRi4/vzdy
	fJnOtMVvOhcxtMQ40Ix9IxKEQxKHXV8/NMgipy0WIhOtD0qwHEs6eIb5lvX87CVaCZdrGG
	sXZeB1BzkgxJ/oE22PW6vavf2xzBuak=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GKL3fhdY;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756729044; a=rsa-sha256;
	cv=none;
	b=EoHP132NfrisHzFL/uct0iDf6vd+Cxr06YZEM/62fkYi4X5IelV+H+uo51rF94wquliTij
	Hd+FeyHgnUw9/TU8rKS0ChYgETmxYnEX9pa5rhptn/oLLm5iFNo5g+2TOnSi/xCeFMc58W
	HPM57LZIEFLTFZVqB1xvtcS7ngYujYw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756729044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=E7wsDKVeU07tqfba5mhUpd3DLLKgZKYNe/5Ehj98m6A=;
	b=GKL3fhdYoLdPaW9YLfWTX9pdyCmeuuAmXx4IPFamkJWD9goCpVwu6KkTDQY5XcxvaAvtlI
	X12XHEXU3uSWar6weRmd822HTl1xrSqca1C2lfqRTsqXl0acUyB/FJWvIF0Jck9tr9G+1r
	mhWsiHr4ETbXLoxmXmYJR0UdAcULoSI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-3HuzNUO_NserFaO_i67sjA-1; Mon, 01 Sep 2025 08:17:22 -0400
X-MC-Unique: 3HuzNUO_NserFaO_i67sjA-1
X-Mimecast-MFC-AGG-ID: 3HuzNUO_NserFaO_i67sjA_1756729042
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ccd58af2bbso1863829f8f.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 05:17:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756729041; x=1757333841;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E7wsDKVeU07tqfba5mhUpd3DLLKgZKYNe/5Ehj98m6A=;
        b=XTjLHGEyjelNXo5r0evHQNA4qZg5/ZdapWpQSAX3L55JkB/H/amBFhCGujI2T/v+Ke
         Xbme4IeTkJXLbudTfBWbjcIknKR1dzPnl9tawpEkR+uPv5eWcvPB8OOhAOtHwn8krNC1
         bReo41IeQpsUh3fhjUjtyX8eOtn1qcAbuuSRiXHiMhKEGNRd+7kzE1qG0XCTamNlPQdd
         76N4H64DBdqmm91T9Eq12oKgHwqn3ybrGxRU9+CH61cwpkbH8KRZOVYZt8jZQxotI/9e
         qOLXqS5zV0OUvDvT8EKrD2DizFaD4d+Z6Sogg2PYLyDaNsHFMY0BMZ9P1Iqz59gELZCZ
         JkOA==
X-Forwarded-Encrypted: i=1; AJvYcCU4WZrIsEi5c+/l0Gg0dGjEA1polbFyl8CgHkR/qy2XfGvtC7uwItdmqCUg/keIFGe9lso4I0SQAA==@kvack.org
X-Gm-Message-State: AOJu0YxvtOp26IurzKtX7w8rCFj2AkxSaK4Vm3BNnox1pGcJzcRx43Pu
	Isfoo9uBQVjryEkgJK88oyhWdxnK15A7EkhahQ9oHz+fmn113z6wK7wyxCvzImndqakBiXYdKit
	2ypj5kAseDRo9UUVccad9ShosSsrkq8bSYrFTuo3D1J4J/AQk5lwJ
X-Gm-Gg: ASbGncuXVL4opAqX88/NkixICEG7q/nH6h7mWFNIQHmKkdEyGFli1mz0R3mgTXGj5Zt
	Y+DTMnhANFXPjUg1l3nJxAEn15y0ccNgTjGJjUv8qOMbl4UkBi3QnPXInU9bhwr/XoJZnawS0U+
	ZMMp+afOnInLmNuoNVzVB2pyk6QqSrTVE4Hm90/yj8Nc9TXDH1P02TKuj87JV+vgtFtPbJ/EjRM
	7k+oA5A7lgq2jX+IH/WMPxJ0bCYTXdigVsMkZQ5q969vW8T7VFzuR0KYa/O5AzHEDWK3FJnfHgD
	Ccj6DOHAoi0upZyZSrmr2NiWumVqMgeY4UnPiyAWe8O435wKM68Tw6wK1zS+Y16lojPeb3oYQKO
	vkA6JwD2O81vz5IvOv4hCIB3r8yHMhnG3S0nMuyrmmtDYP2CAOBagIYuZSmzqnZEYUew=
X-Received: by 2002:a05:6000:290e:b0:3c7:e6d0:b1b6 with SMTP id ffacd0b85a97d-3d1dcb77f57mr6172963f8f.9.1756729041581;
        Mon, 01 Sep 2025 05:17:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4HyO3MsW/7JB2c6b+uWwxyC9MpHi848L8uRbEPhjkFkXwnypkP58uX2s27AjDoWG3KsJ0dw==
X-Received: by 2002:a05:6000:290e:b0:3c7:e6d0:b1b6 with SMTP id ffacd0b85a97d-3d1dcb77f57mr6172942f8f.9.1756729041066;
        Mon, 01 Sep 2025 05:17:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d48760d1c9sm7371553f8f.17.2025.09.01.05.17.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 05:17:20 -0700 (PDT)
Message-ID: <cab1db60-e7bc-4f31-b781-c52ad1b24da6@redhat.com>
Date: Mon, 1 Sep 2025 14:17:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 22/29] mm/numa: Register information into Kmemdump
To: Eugen Hristev <eugen.hristev@linaro.org>, Michal Hocko <mhocko@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 corbet@lwn.net, mojha@qti.qualcomm.com, rostedt@goodmis.org,
 jonechou@google.com, tudor.ambarus@linaro.org,
 Christoph Hellwig <hch@infradead.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <751514db-9e03-4cf3-bd3e-124b201bdb94@redhat.com>
 <aJCRgXYIjbJ01RsK@tiehlicka>
 <e2c031e8-43bd-41e5-9074-c8b1f89e04e6@linaro.org>
 <23e7ec80-622e-4d33-a766-312c1213e56b@redhat.com>
 <f43a61b4-d302-4009-96ff-88eea6651e16@linaro.org>
 <77d17dbf-1609-41b1-9244-488d2ce75b33@redhat.com>
 <ecd33fa3-8362-48f0-b3c2-d1a11d8b02e3@linaro.org>
 <9f13df6f-3b76-4d02-aa74-40b913f37a8a@redhat.com>
 <64a93c4a-5619-4208-9e9f-83848206d42b@linaro.org>
 <f1f290fc-b2f0-483b-96d5-5995362e5a8b@redhat.com>
 <01c67173-818c-48cf-8515-060751074c37@linaro.org>
 <aab5e2af-04d6-485f-bf81-557583f2ae4b@redhat.com>
 <1b52419c-101b-487e-a961-97bd405c5c33@linaro.org>
 <99d2cc96-03ea-4026-883e-1ee083a96c39@redhat.com>
 <98afe1bd-99d2-4b5d-866a-e9541390fab4@linaro.org>
 <c59f2528-31b0-4b9d-8d20-f204a0600ff6@redhat.com>
 <40e802eb-3764-47af-8b4f-9f7c8b5b60c1@linaro.org>
 <7e1f4f64-dfc4-4366-8e01-0891b2d4d2b4@redhat.com>
 <94f537ae-c2b1-4928-a3f3-6449c30cb624@linaro.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <94f537ae-c2b1-4928-a3f3-6449c30cb624@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LO6BdTvHrUsFrOlQojtWMz4Etf4IyMQU1ZxtfHJiT30_1756729042
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 91331160004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: nr91ykneenx3aeedwoa8jndcpcu5htqo
X-HE-Tag: 1756729044-666471
X-HE-Meta: U2FsdGVkX1/wAsm7Pdsr6ZoKE8RRMQRQ6y2cnZ+MkCPqDQPbCT4TqldI1Br6KJpUSPh877vSAfiu0tPvoa/m7pBv2HBeDoHwfg24DqloT26+BevwzMhRXgu4nVzSXadRDXNEdBL4qLoAMHsfJPtFiQzka2b7HVcBFjs7w7sEHAGjyfHEPvRkUxdL6IzmvAWwulyLTbh1nOc+gAbXH20zvkNQCzF+JvtAdVscu/CyW/ry8gl239KnFQl512tbaeDBkbzvCcxEkAcnv4wdlvW3+F7fMdBqgpgZNdItC1rLELBa1Yr8FFGL0ybFUAFC4oq1oOqO+kNIiTrctmaMOx5DE319/AwK/hAxlTTDTvffLabL5gsaF3k4wyUSIld9BbaKdV+sc8BpMXmXPmtJOea+sMQWZM3dshjxEStAjqdHaBTbLmCSelVSYGhm6HQoY8rrz+VfIHcI9EPImwUR9VASfT72qXjMuBX7PvtEvP5/phCH6AVe/PFEqMLqE232GTYc6AoUniQgoAVALTHWBRX4wLAg6oKqDS00MICFdQq17koul661fmE6D3tOxhapq1YwTAtAQDab2jhfb3IA3Y6LReoplvD0clcy0NpLATu5H2upgf+6Fl+vwDKT3oeLqVJ4p/2QDBRbMpdJ4+rYFLCkjvRWG/2nCkQ2aG90bcTL9CyFPbSmc/g+FhJqJq/cp9c1/rZP1a6jRse+U9LAXylKH48+1cltoazprBdcl3TvVrGweNq7b5UjZzPrznRxsbBTi0rJqWyslO7MBcgknfeunX16YAu1FkwwlFZvZ5bix/B5EeTFKSZ7rp+NgOcUz2mLGAzjryBEBng9It+me8VIl7fT6Ysm3+fAVTZGKwDvjEAt9hD3zQKGkIgzWVs+nnryMYlFUxa9AfcsIDuyQNUGkF1J3F6nb5YNLDmmrV4zkmieG1dzdLH0hnCFX3JZOx8Xdkv601r+/gAb4pJmNqy
 nElTsINb
 gCxmW8BkHB6YQxWcPxcuqRwLSUDR4eG0rGWmMewohqsSfLvcB+O0GC5mSPoABnVxLoeGx1d+cqEC//Zd8rEgcQWT9nCB+Y/LD1hLgXRUYCaeLy10DO0INfIxUnHZJzU/EneEDqfVlCdhMxiX73oso0G+tbtJju9LBkdWY/xo8MIH7z3qEq0DQJ5VpOuv75aN3coEr5an5cTX+/qi6272bck7Y3BmkwUmmH5jcUWEQhxobc1wRXTWohJ44aMtkqOGmm1tZbzdddhWBGPB70BlmJBxOMMqCHoYM+DQRPnzVtcxCyDzPOv3cNiM+C2FwNmzdTzz1NOYIzqzWIuqYSQoZHCvGx7h5KFKSQWqnQ4M3dWZ3fYw4QZFkbGMPP0tl7HqIuD9/FEAWtA3rDrRn2ooQEG9RR1KVXBCJKn54qc7EXPOOPACvXeMX2ncVng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 14:02, Eugen Hristev wrote:
> 
> 
> On 9/1/25 13:01, David Hildenbrand wrote:
>>>>> What do you think ?
>>>>
>>>> Looks a bit over-engineered, and will require us to import a header
>>>> (likely kmemdump.h) in these files, which I don't really enjoy.
>>>>
>>>> I would start simple, without any such macro-magic. It's a very simple
>>>> function after all, and likely you won't end up having many of these?
>>>>
>>>
>>> Thanks David, I will do it as you suggested and see what comes out of it.
>>>
>>> I have one side question you might know much better to answer:
>>> As we have a start and a size for each region, this start is a virtual
>>> address. The firmware/coprocessor that reads the memory and dumps it,
>>> requires physical addresses.
>>
>> Right. I was asking myself the same question while reviewing: should we
>> directly export physical ranges here instead of virtual ones. I guess
>> virtual ones is ok.
> 
> In patch 22/29, some areas are registered using
> memblock_phys_alloc_try_nid() which allocates physical.
> In this case , phys_to_virt() didn't work for me, it was returning a
> wrong address. I used __va() and this worked. So there is a difference
> between them.

memblock_alloc_internal() calls memblock_alloc_range_nid() to then 
perform a phys_to_virt().

memblock_phys_alloc_try_nid() calls memblock_alloc_range_nid() without 
the phys_to_virt().

So it's rather surprising the a phys_to_virt() would not work in that case.

Maybe for these cases where you export the area through a new helper, 
you can just export the physical addr + length instead.

Then, it's also clear that this area is actually physically contiguous.

> 
>>
>> What do you suggest to use to retrieve that
>>> address ? virt_to_phys might be problematic, __pa or __pa_symbol? or
>>> better lm_alias ?
>>
>> All areas should either come from memblock or be global variables, right?
> 
> I would like to be able to register from anywhere. For example someone
> debugging their driver, to just register kmalloc'ed struct.
> Other use case is to register dma coherent CMA areas.

Then probably better to export physical addresses (that you need either 
way) directly from the helpers you have to add.

> 
>>
>> IIRC, virt_to_phys() should work for these. Did you run into any
>> problems with them or why do you think virt_to_phys could be problematic?
>>
> 
> I am pondering about whether it would work in all cases, considering
> it's source code comments that it shall not be used because it does not
> work for any address.

Yeah, it does for example not work for kernel stacks IIRC.

-- 
Cheers

David / dhildenb


