Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2A0DCAC593
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 11:10:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AA168E000D; Mon, 15 Sep 2025 07:10:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1334F8E0001; Mon, 15 Sep 2025 07:10:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC75D8E000D; Mon, 15 Sep 2025 07:10:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D1BBA8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:10:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 83B0186563
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:10:33 +0000 (UTC)
X-FDA: 83891216346.09.926757D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 200BA20010
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:10:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OdcsmWHo;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757934631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/CAWql+JAQ14jPTZVQe0ITQlkc1jfaNDWNcoF73KKLg=;
	b=fJH9FTTO/RSf8v1213mOTpsBn5YgVA8BFb4IRb1mbS3o3LEaWIIxUhRza4rkBfhco847cr
	Zrb9OKpq3VO+NVZ+9avY11nudsIYxhmplRVPIf0B7QUtMG0AREUlvJKLSdUoaGLDIlvFEm
	mmxpqg+KmAh+w+VolHVpx7nt7RbL7KY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OdcsmWHo;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757934631; a=rsa-sha256;
	cv=none;
	b=vMKGQxBc0HMebWvvu5oGUdNRSDRBm+s1lC33/Hca13GKdiZY7C2/ZDi+e40APMkL++UQ3n
	S461886YwvuKyxWRZAhsJlaCaxz3qUn3aDoHWrsYjk5k8HgBEt4NZjFNfixJ4s5YERIiGN
	oIqimvLZkHtt15Ta1QXP9lsSBr3gxb8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757934630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/CAWql+JAQ14jPTZVQe0ITQlkc1jfaNDWNcoF73KKLg=;
	b=OdcsmWHonfwlw4Lnp+t+4WfuQr0gqlVYnW52NFMRSLp3B91S8Hyp9Qd/35Q9SNoV16qTdT
	knK+w8VxJ+/X7M6n5sRhqqTUFoDSYmL7a3WyZofTCn0V55EmrR0QVFOSHOPsE6MMXv2Zn/
	quVa6uSCeeyWqXofRMyXPdVA7a/Rr0o=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-ExhpXYm9OBepJwEAp6bvjQ-1; Mon, 15 Sep 2025 07:10:27 -0400
X-MC-Unique: ExhpXYm9OBepJwEAp6bvjQ-1
X-Mimecast-MFC-AGG-ID: ExhpXYm9OBepJwEAp6bvjQ_1757934626
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3e997eb7232so481279f8f.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:10:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757934626; x=1758539426;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/CAWql+JAQ14jPTZVQe0ITQlkc1jfaNDWNcoF73KKLg=;
        b=d+Y0TOY2Gc7+nt/nqDgXXmjfJ8ioC/80z4gih/IehTY4YBpRr0D3zq1fIOxsCNDM6p
         McN1goeZ8C8BeZ9Qs+1J5YvDUZFG6YjonB5M/bcINgHOpsr31FXPx0nwGyKan2uAqKjp
         oR3AwpYymfRfOnuKAoVQdHwnoPHSwSGILfpkqOgsxMFkVyrjeqItZspNoKuq653s49Zu
         njiRfFPXgR6HfdvYjcoU2ejtZH8Eoln4+PGWHKSU4GNLE/4f/Ud0m34t5Dwjszfq/GOi
         NThpjVGPiXXPJB5INqw6yjOik64lf3/4vnDUV+Q34DzF/6Oj7Q+s8p6hTR3whn1UwIit
         QXtw==
X-Forwarded-Encrypted: i=1; AJvYcCUBk9UMyGU82ol3g9cemrRYGbjZjv/+Uv2zFt5zA1eRtub/TZ0PO3npAIRkgJBPZKppeYwlAKy41Q==@kvack.org
X-Gm-Message-State: AOJu0YxUu1gZxDH5LW0Ru5jjyDn+NLuWYDTLOcGWW2Sj7Nn5pZdF8Sq7
	SxnTqE3D8Ti2Gjp2sqbO8gtaUpSBEM4iiDWmcsUKNLHTgKmvHf6L4KUWbj1rOE+KNnYePvBjUaE
	ws/sth0pC67ck/N2SSmcnd31pBCx/S7zJi1Mvc/tLdWGjZM4mtXvs
X-Gm-Gg: ASbGncvXp/RkkK0Zr/nfCc2TVMoWU5lqCKJYuJfm8qFORasJVDa7LmGnhMrWecR37wy
	GVvD782FL9gZcL05iT6zYhsRYgIbN8yjUPvT46K4TsPKGK7Pf7ZAdAP74AqY8okZrW3Geai+59p
	jVm6K9FdZ0vBn2toha4rrVD/orscjyx/+wTYgDlR9rBVUCJRucJ3OiDh8Jw1U9u13cto8v6jtQC
	+lTBjYNA/wZwD6oPABp7FIsFojaRPstUPHEk2GAWtrdlyZla8bzojdAaYHJrL5/KT9j1Xuzw3/j
	wWUIILCxBTF0pGuIExE20pbMeM2QQ5m6/6BvRhswXYAKkZRwokQbg6xk/MU8Z91gIzLakUl6gDg
	UrxopyJRliMChhbmx2hZGAnFsQWQSAAKHA7XQeFlHulJLB1i6HiQdm8fsT4BZ1H2XBYs=
X-Received: by 2002:a05:6000:2005:b0:3e2:bbd1:e90a with SMTP id ffacd0b85a97d-3e7659c4dcdmr8167270f8f.37.1757934626125;
        Mon, 15 Sep 2025 04:10:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTQVs1VB/MdL+atPfDHzXpL4rT+6Y4YLYWGCYu3x8Erf1i5OLLyh+BaEPetWMGx0DNJ4HYug==
X-Received: by 2002:a05:6000:2005:b0:3e2:bbd1:e90a with SMTP id ffacd0b85a97d-3e7659c4dcdmr8167245f8f.37.1757934625670;
        Mon, 15 Sep 2025 04:10:25 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e8c7375fb7sm9147411f8f.14.2025.09.15.04.10.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 04:10:24 -0700 (PDT)
Message-ID: <1312fa3e-88dd-490a-9e07-9749c625933b@redhat.com>
Date: Mon, 15 Sep 2025 13:10:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
 catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <CAA1CXcA+pb5KvEnJJqdf1eSjaFiBZ82MRB+KDmyhj3DbiQqOxg@mail.gmail.com>
 <enrgrocqajwu5d3x34voghja7pbvau45oobxgabawrly44ld4u@ahch3xn6rtq5>
 <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
 <2c5328ee-fb6e-45cf-a151-868cc8e7ff97@lucifer.local>
 <4508810d-7645-4f57-a0c5-2ee9f44206fc@lucifer.local>
 <34754ca4-fced-4a3c-8ff8-c00967d487de@redhat.com>
 <92352257-5be4-4aaa-b97f-c4e879ac6959@lucifer.local>
 <de3f5502-ef81-4f44-96a9-995e512301a3@redhat.com>
 <5099d9fe-4a07-4acd-95c8-782ffc74df37@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <5099d9fe-4a07-4acd-95c8-782ffc74df37@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Dp6QImO0gD_N7-AmlZu1mNVMiEMT0WsRZeyALmoCn74_1757934626
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 200BA20010
X-Rspamd-Server: rspam05
X-Stat-Signature: ytuxzsjiku6c8szex6hoau9jooqfc67i
X-Rspam-User: 
X-HE-Tag: 1757934630-470263
X-HE-Meta: U2FsdGVkX1/VQcY1VHjN3WdNLxeZNg+9nL2Z2l6QCkX/JHQpLpKW9fJf95kx9YnDMs3t/n4zQP+nZ3+JmoWjhQJk1i5GJaVqRS2ozz+YjmAQ5b86v4hojAEx50brFyrJhfvUax+cZSfDb8zwaWD7BwphEx3qhGHujqCM1S9C7l8d7XpJ4jkqVVIWmG5Yv3ZizZcnYzy5m9SESYVAnvx0pkeaR0zeEOqXszq0E0PbbeGvnUE3stjthGzbvtin8WwOhA9vSMRvA4TeHb1DZBlnJWJ+7ZkLVWsRtxyn3+vqojL70FIJiQI4ZaKqZMa2brscAFZy6ZrZN65NM1BbhsJx05TUVEp5GMNs8yrMRwWk/kOfqwHC1CUzgzzexfMjYu5QE2a1czqewKESUlvWnJI2zmK1bm84VDi52dfIm1IzOfUs8r0feJMlSZ0kXvBCC34eprWrBW8gQbSGWra4NbZfTuSxGMIq/oTf+KIZL/sGczUMmzgDP0fRZfvitQaiN93pcbE3ymV63wquwe5VH3pkAS286K+O+OTn3PfDR0yaMAgCxh6bzy/w3+2qDgoXmBfdiG9B+Q9KyVCkrXVEeBQ14ZuTI9Q2VYHx36ReWvfhaxkN8q8BrUsBH/jBxZ3G25ZMwUm8zEzTT890MpPI8SIgnXru5U1x14P+E4QIcwNFrSkLZlHUNwXcmyciVC791PvnMx0ecCwfVQ1J2xIgQbAeW+G7vcMhZcicDcOtmlu+zT8CyEgOsw3R7lCMQLvD0xlN3x4/c4ad5WWs+GrPRYHDoB5XtHECXIH88Nc1RcEpm1pijfw4f5wnMihyMybyOp+wKgNBGXuJYSpX9Zlobm95UVK5ndAVnF635MwiuPys/uc98w7Di5sBQ2bNmKuNfOqCYMznh1OM2AZaf6KJb/8nuI47meotm4CG3un8SH6jqd4+uYdqSABw9iYiQtvXtRgoDMNGaiqj+MF1Z3Lqjku
 N2334od/
 HBnGLERSZ/59GC+vSmBRd6v4tbF82Jlq3jX5Qyx1mXpohRHESe8ES34tl+kObpIkumALQxYd8HqB9M7a31b7TGG1STnsiPTGSjfEaywgQkHmTmvKdmHVpr9svYL2WE1Xpb8FO4XTXsF1sOj8uCLD+aCkHEJuUU3XllM2EfB2kWXPx0Sp+Sa9e9IgFvZBL3GyUuvRWl3pyoZO5gk15HTr6SMrqGXXtvuSkLuhtddvDRjEJ1q2BRHibxMf0st7BYLGEH4x9KBtYWeF1ksF4exMlrTgcAjLDqWOg4HW0YAVgtQhAKBy1thNbI5hE8wBjyxJc0NbcyAVkoNzN02+J94K81wD9IEtUVP83f+vl0ZCtGfkl/g83Xr6aBWgWlkro9merF/QfExLS7TeJPtuNYygG+cPMR1rDPAGLDvuJbyUpmCmkf8QXiTL3kQ0g3JBAbxyzPOp5ELWCfKH/vDqLmfxbTbh3Y/ovS3X/OM0Hi9WYOK5gocR8irNK/fi1FA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 12:59, Lorenzo Stoakes wrote:
> On Mon, Sep 15, 2025 at 12:52:53PM +0200, David Hildenbrand wrote:
>> On 15.09.25 12:48, Lorenzo Stoakes wrote:
>>> On Mon, Sep 15, 2025 at 12:44:34PM +0200, David Hildenbrand wrote:
>>>>>>> Mapping that to actual THP sizes (#pages in a thp) on an arch will be easy.
>>>>>>
>>>>>> And at different mTHP levels too right?
>>>>>>
>>>>>
>>>>> Another point here, since we have to keep:
>>>>>
>>>>> /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none
>>>>>
>>>>> Around, and users will try to set values there, presumably we will now add:
>>>>>
>>>>> /sys/kernel/mm/transparent_hugepage/khugepaged/eagerness
>>>>>
>>>>> How will we map <-> the two tunables?
>>>>
>>>> Well, the easy case if someone updates eagerness, then we simply et it to
>>>> whatever magic value we compute and document.
>>>>
>>>> The other direction is more problematic, likely we'll simply warn and do
>>>> something reasonable (map it to whatever eagerness scale is closest or
>>>> simply indicate it as "-1" -- user intervened or sth like that)
>>>
>>> I don't love the idea of a -1 situation, as that's going to create some
>>> confusion.
>>
>> swapiness also has a "max" parameter, so we could just say "override" /"
>> disabled" / whatever?
> 
> I don't love the user being able to override this though, let's just nuke their
> ability to set this pleeeease.
> 
> Because if they can override it, then we have to do some deeply nasty scaling
> for mTHP again.

There are ways to have it working internally, just using a different 
"scale" instead of the 100 -> 50 -> 25 etc.

I am afraid we cannot change the parameter to ignore other values 
because of the interaction with the shrinker that easily .... we might 
be able to detracted at wait a bunch of kernel releases probably.

-- 
Cheers

David / dhildenb


