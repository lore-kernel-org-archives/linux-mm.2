Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25762CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 18:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C1FF8E0007; Mon,  1 Sep 2025 14:38:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3997E8E0001; Mon,  1 Sep 2025 14:38:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 288568E0007; Mon,  1 Sep 2025 14:38:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17CEC8E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:38:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C28E91609C4
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 18:38:47 +0000 (UTC)
X-FDA: 83841542694.07.8DE4159
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 61121160010
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 18:38:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Ky/1jGe9";
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756751925; a=rsa-sha256;
	cv=none;
	b=Y58hXO3dk0sZpwwXUzRL6NZoAT/bg8Symh35b0Y20tmfbkmp2sAftBnW4TmaVXvf7xcIeT
	QqUw/2nlHZIRub8Mhf2qpzAfplOiCKVAGBKR2S51EFLOoFc8nd24wxAW7BmdL1MsWmYeVh
	uP0Wh+K8bvBjYgyMOKqRmsdo+K7YjZQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Ky/1jGe9";
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756751925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aOMYfYkIB0MeR6VSaf6nAC5fx6q+m9vBzWbf+mnbIXw=;
	b=tPZJaCgln55/bRq8QDOWvpdUnw/bbvpTEP1PzxvxFCQoEVU/k3cCcz/wBawRJ26YYfWLMK
	IH4o692Ij8JfnO1SKY7IDF8UbF4zHu+MVCBBEHXh4rU5nMdtUqSi3HcNjGSH2u2N8Daubh
	j/Y3bh8L+ThQajC3345twQUeyDmsRXg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756751924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aOMYfYkIB0MeR6VSaf6nAC5fx6q+m9vBzWbf+mnbIXw=;
	b=Ky/1jGe9yTkF8RcmBd2Szu9ECzJX0/uZ5n/2RL3vFwkF6nC9zilG5X9i71eIpHHdyU31jQ
	UQk6TDxVykK0LTNkP1ARZsbhZJ1/wzLFmcHtexjUfx1EuezPw/6xp8MSS97SMDOR87r7Pn
	mufSbYjw9ikRcqse16m9s9JXsgzI92k=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-OgtBZZy2PEC4HS6_mGK4nA-1; Mon, 01 Sep 2025 14:38:41 -0400
X-MC-Unique: OgtBZZy2PEC4HS6_mGK4nA-1
X-Mimecast-MFC-AGG-ID: OgtBZZy2PEC4HS6_mGK4nA_1756751920
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b828bed3fso11787965e9.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 11:38:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756751920; x=1757356720;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aOMYfYkIB0MeR6VSaf6nAC5fx6q+m9vBzWbf+mnbIXw=;
        b=Ac90cp+bUmPLsVMEwYY1U5Ci9usd50srKThI5gCTl/Juwppln3SEgtZAxPQBwZCDdL
         A3Sd2NXPXn2BqM98mNfG37R9R+NPfQN1rQiv8tRPPJA52ygS8c0FQ8fe1WbtgGdMoPMW
         mlTmkfB9A46sOtW5JVGsA+ZgzcjyZZvz+zPp10LT3ZkF2dlpWAMHD0n7eaAuoxn+lMqC
         kZuAQ/CwqCQRzfKwi9/EyOS3reySUY5/8xZ5HhY9IETHlY1BOrYfmQtrgPnI2qWX+TkA
         Uoxj6nVE0f9n9XyTtG7qOZ+FGGyeCaOOjz7aCGJ3o60xp4fnJ6OrEoyBsQGcZ0QEMAu+
         XqDg==
X-Forwarded-Encrypted: i=1; AJvYcCUmkrRYpr3OPsqKa03oB8dDj9XRP4LIr3pxYUlZJUXgEOBHto/vzUTJDNonwA/xSlizQjaFqvLNag==@kvack.org
X-Gm-Message-State: AOJu0YwnknMP0ykh5Jl9W0jdLAzbVOjWhCCKJlo1h+2/5QZP5zD9IXG2
	1/n3KYQeX6Si6mJZkxDqOB+JO2hKOicvaYtc0A9cgv3LMrWKsWCBrs0tWtaC7qsU1Xl1n+X9OFP
	ZWv+Yh/Y0qRszU4qv5SISYSAuYy1siPPSteu/ZzwYgGaGpLg2C+QI
X-Gm-Gg: ASbGncvqEKI50Qj9fhY2oQLdqO1/WGTEiM8BLpjTNbJcl+LGnLfw7PGq0X+HN1PXm6I
	v1Xqavmo9jaWONECQY8yP2N+EsLBlpO1nowVUqHUhHQcpDZ9OTk4OVo79cIuT3jJYbdq6n3T+s5
	7MEt3zYJYU5xxqyDoDEuubXxzINTde7pEghYpJunweU8dGW9mSmOxIpdrY656dr2/+ZTTTGkw8o
	CnaeNTyrmhcP1DXFA0webOwJUL7xeykzi/Viqe+qKy5yFotqNP+zGmddnA6Uh0wDP+arZCrfpRr
	Nf8iyMfXG0iAX/abiu0sguydj+a6vyCNDO9vytVFLRlZiYND6n1dK6i62K2NZgaTayzHfywNK2H
	kKKEANDMKojoVW4gsD/LTWcVG0NvXugmBkbXihWWRsQfImJ6L+YF2kraP/MqP4+qhFyk=
X-Received: by 2002:a05:600c:c8f:b0:45b:7ce0:fb98 with SMTP id 5b1f17b1804b1-45b85528677mr78023185e9.5.1756751920250;
        Mon, 01 Sep 2025 11:38:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHq87FLfD4bNpAb7pWs0AmNW8xxuWnKcg9odd5omeYSbwlpcrZLSZ/gW4a3C/k//IJfK2+Qbg==
X-Received: by 2002:a05:600c:c8f:b0:45b:7ce0:fb98 with SMTP id 5b1f17b1804b1-45b85528677mr78022885e9.5.1756751919831;
        Mon, 01 Sep 2025 11:38:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b814da51esm145663325e9.8.2025.09.01.11.38.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 11:38:39 -0700 (PDT)
Message-ID: <776629b2-5459-4fa0-803e-23d4824e7b24@redhat.com>
Date: Mon, 1 Sep 2025 20:38:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/3] cgroups: Add support for pinned device memory
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Maarten Lankhorst <dev@lankhorst.se>,
 Lucas De Marchi <lucas.demarchi@intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Maxime Ripard <mripard@kernel.org>,
 Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?=27Michal_Koutn=C3=BD=27?=
 <mkoutny@suse.com>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "'Liam R . Howlett'" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Thomas Zimmermann <tzimmermann@suse.de>
Cc: Michal Hocko <mhocko@suse.com>, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org
References: <20250819114932.597600-5-dev@lankhorst.se>
 <dc21e54c-d7ae-4d7e-9acb-6a3fa573b20f@redhat.com>
 <9c296c72-768e-4893-a099-a2882027f2b9@lankhorst.se>
 <b6b13ad22345bcdf43325173052614c17e803d00.camel@linux.intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <b6b13ad22345bcdf43325173052614c17e803d00.camel@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3YDoKFWCdP0fnipu9QkjJDTDgZ1qvqYLA4JaALtgdxw_1756751920
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 61121160010
X-Stat-Signature: gg89phsyitue4dx7mbo3rezskpfuybj7
X-Rspam-User: 
X-HE-Tag: 1756751925-722370
X-HE-Meta: U2FsdGVkX1+CTBajCH5pk2mCykUV975O7A/xJGrMT2k6nA28K1O8JvTME/gIIz0UfkDoPDVoFPDSISXuJ3XBwoo+svHgBASt6Kw5ONc55g+YlFoxWGnMP1HEiUAAAXJD69Y7yQo6OD+iNhoWC8tWa1/Zc3lTMnjoPv0cP7hSZnRCWkQfwqivRntZM7gRsCAiIAzRCFe8kVBkVGJsAbUGl94PLIpkt/8PdtNJclO/wiITK/rP5BP+d3f4/rpR5lqS1RqSB0G4OaMoHyHO+nateoFd1D2IyJA823PTeb4rADDlOzHyGeH7tXFgekBi+KbSuOvdDEhMn02vZCGAvswLg2ZPh75ErQv9b92droPf0i7YXVAt3FsDTJ88QT4hlJgfYCLDvVkrUy5QPyCnOKKyjsoZTpg+1pZDxpjmL3xG5uLD+iGHMzwTSwxl72nOlq3jwnYHgf8j4W/TT/JKytRcuNztkcjzLtXwcoVLPwRW4TNdGu70KFUPf3ygd1TTeN0wNXmgp3KcmAGxOKtXng5SS07ZcDHS19PU2Zr+3AB+Ie/gi/LwlWcdp9ngZ8o6EJBwfvFele81Rb5DY4SN2e1CoNl9+XaWRAxji1ybmuULJdYzIJ//KdHWWLlnG5LWJ7VCIzaJROSBa1CsWPsYMm3hF/DGPfkdqyHm8GS2axiSsiax0csUPJ1RTsHMzcxjWnvkreQSiA7H3e0Pw2FovQ4Zi6/7fk770abJCQiy3anuyhfZRE4GPKRoPel/XGfpL+fmD0SJ0RUmeQNgsOd2fdSEt5V/8bo/JToIfdlGezTiik8Iti2eKZD5o7z9iNduE9VxI+T+FPOx1Aoo2AdH3Xwr9I1wCmNYH6xEHT2Z7uZXC4nfXnaH1EL9gfJlnPrq90wjjSKMczoVpo7qgz6l8Gut95sW3G/eb6IgY2ZR4G3MXHPPsinUWRCmrGZYzDw2bMLP1OYB/PfDSg88WfOw+8Q
 pURGf8xy
 u5lQsMFZ6hS3S9KXg7Z9eARuPEgEml84NSkZv5Xt5hpVGESsngw9m/WFzCfMGJHTChdl9bfM05RtaPvx0rqDRKnGWuzmxdUWE8g01xf3H6VCa7tu8v30TWPEA+LFFdqcLnJvk/OcLc35DnpYvxRtbIPlh8Z7TlcCH8qwgaTSP8nFVjL6XSwzx23MNmbaIWcegmD2nvj8LfOXRlcQcnZRLvtAEPrPL/VYcU0G4dLnnOVGkpgRWFmB/FtJoS29l3zJV+H3VTBBGgnAhrfd4oP2do1ih+SpM7LRxNzS3ihcRZL0eTpK1Bqy5mMc1z+/Vf5BVoHQq3j+Hj6emPy5iiqACutfl36BgKat7LEi7THVKGP7c0CE9oFIYznthgsQQbXnWn3bvewnNmGWLJMcI+5Zn5XBDI0e9fLftknufaqYak23j++afHjhmgxQMm7boN+xMDTxfpFBQmA9RF0U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 20:21, Thomas Hellström wrote:
> Hi,
> 
> On Mon, 2025-09-01 at 20:16 +0200, Maarten Lankhorst wrote:
>> Hello David,
>>
>> Den 2025-09-01 kl. 14:25, skrev David Hildenbrand:
>>> On 19.08.25 13:49, Maarten Lankhorst wrote:
>>>> When exporting dma-bufs to other devices, even when it is allowed
>>>> to use
>>>> move_notify in some drivers, performance will degrade severely
>>>> when
>>>> eviction happens.
>>>>
>>>> A perticular example where this can happen is in a multi-card
>>>> setup,
>>>> where PCI-E peer-to-peer is used to prevent using access to
>>>> system memory.
>>>>
>>>> If the buffer is evicted to system memory, not only the evicting
>>>> GPU wher
>>>> the buffer resided is affected, but it will also stall the GPU
>>>> that is
>>>> waiting on the buffer.
>>>>
>>>> It also makes sense for long running jobs not to be preempted by
>>>> having
>>>> its buffers evicted, so it will make sense to have the ability to
>>>> pin
>>>> from system memory too.
>>>>
>>>> This is dependant on patches by Dave Airlie, so it's not part of
>>>> this
>>>> series yet. But I'm planning on extending pinning to the memory
>>>> cgroup
>>>> controller in the future to handle this case.
>>>>
>>>> Implementation details:
>>>>
>>>> For each cgroup up until the root cgroup, the 'min' limit is
>>>> checked
>>>> against currently effectively pinned value. If the value will go
>>>> above
>>>> 'min', the pinning attempt is rejected.
>>>>
>>>> Pinned memory is handled slightly different and affects
>>>> calculating
>>>> effective min/low values. Pinned memory is subtracted from both,
>>>> and needs to be added afterwards when calculating.
>>>
>>> The term "pinning" is overloaded, and frequently we refer to
>>> pin_user_pages() and friends.
>>>
>>> So I'm wondering if there is an alternative term to describe what
>>> you want to achieve.
>>>
>>> Is it something like "unevictable" ?
>> It could be required to include a call pin_user_pages(), in case a

We'll only care about long-term pinnings (i.e., FOLL_LONGTERM). Ordinary 
short-term pinning is just fine.

(see how even "pinning" is overloaded? :) )

>> process wants to pin
>> from a user's address space to the gpu.
>>
>> It's not done yet, but it wouldn't surprise me if we want to include
>> it in the future.
>> Functionally it's similar to mlock() and related functions.

Traditionally, vfio, io_uring and rdma do exactly that: they use GUP to 
longterm pin and then account that memory towards RLIMIT_MEMLOCK.

If you grep for "rlimit(RLIMIT_MEMLOCK)", you'll see what I mean.

There are known issues with that: imagine long-term pinning the same 
folio through GUP with 2 interfaces (e.g., vfio, io_uring, rdma), or 
within the same interface.

You'd account the memory multiple times, which is horrible. And so far 
there is no easy way out.

>>
>> Perhaps call it mlocked instead?
> 
> I was under the impression that mlocked() memory can be migrated to
> other physical memory but not to swap? whereas pinned memory needs to
> remain the exact same physical memory.

Yes, exactly.

> 
> IMO "pinned" is pretty established within GPU drivers (dma-buf, TTM)
> and essentially means the same as "pin" in "pin_user_pages", so
> inventing a new name would probably cause even more confusion?

If it's the same thing, absolutely. But Marteen said "It's not done yet, 
but it wouldn't surprise me if we want to include it in the future".

So how is the memory we are talking about in this series "pinned" ?


-- 
Cheers

David / dhildenb


