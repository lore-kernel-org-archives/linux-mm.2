Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE8AECAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 11:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272678E0016; Mon, 15 Sep 2025 07:29:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2224C8E0001; Mon, 15 Sep 2025 07:29:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C2D68E0016; Mon, 15 Sep 2025 07:29:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EAB0E8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:29:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90EF51605AD
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:29:33 +0000 (UTC)
X-FDA: 83891264226.24.D3B220D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1B8EF40003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:29:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="LK64fq/z";
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757935771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3c8/ma9rmwVpnwsDyCojdkiFtcRxll8GhUqHuOo1hY=;
	b=NtLVS3+T/sxNHcGKBqiMAx38CRePOXgEyaNyJGiS9wxhrjQrGcHGGwaZv+xFMdQ8XMxNZk
	Us8EcXoXWIqXq96hZMt7Hdm97U9TIB/aJ3ZzpD2NvlE95m54m4y7ixNoGTsRZIRO6zugLY
	2UJNKBnSLlBWy7D1h+td7sRDBr8Fz78=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757935771; a=rsa-sha256;
	cv=none;
	b=OGpzR0cS/W+nmWRxr8/8jqBlYPBJpqtOd9wzFKvGPi6Zxab1M2hSXq5983PMqQtOaioR9/
	lsXkOGWR7MC9Vp94PxVphK5FHII//uq6xm2D9ssvJ76zZ47oYvVhWYVt43cu+jo6Vz5SNa
	6R1LWu9SqHjcTM31BCEH/7pHlhETJ7g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="LK64fq/z";
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757935770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=T3c8/ma9rmwVpnwsDyCojdkiFtcRxll8GhUqHuOo1hY=;
	b=LK64fq/z+rOWskCzgobYtM2Z2HHGtmdn9JoPNYgieZRG4adUbYzwYBKHsrVAijYTIQKK7J
	V0Lhew3fHaw40wjNBpU7ngY0A6Djjnw6oPTvTagIf75nSywSqBI7tAHbwudf7C5vIWhV7J
	UGy3QmXgYKAnArUlPl8nyPeiDG6nGpE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-Oa5G83zWNA-WYNU6eXdTSQ-1; Mon, 15 Sep 2025 07:29:28 -0400
X-MC-Unique: Oa5G83zWNA-WYNU6eXdTSQ-1
X-Mimecast-MFC-AGG-ID: Oa5G83zWNA-WYNU6eXdTSQ_1757935767
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45f2f1a650dso4189285e9.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:29:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757935767; x=1758540567;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T3c8/ma9rmwVpnwsDyCojdkiFtcRxll8GhUqHuOo1hY=;
        b=mY/Cpz4AiZvTI/obsYSV3npk0GFYv3/iyTwl/KbUiPGpxlm/V3Ytoyf/f6htwFj2sK
         GHibERX5yozQ/Oy+kIR0qKQqfdqXi9bomxmF98EhZvGevaQLM7r4knijNJkMin79BXPf
         3/xzr4YMmwGifnPoI0D/PLZqp843WXDEG+x4wEAZtWUCAJqlTBVbaOimxcxov0dpA8kU
         4WuKMQNLbx95nryFFd3zqoZgR4oc3YZ2bl6P948vYeFD6UuliMbNk08LMHItcCPdxbYX
         YWuXoAHRtYEVf6KF+1R6W4SbxYvZwZQaAwNn6P9yC1kFeMvKiCDMjqlirlK8TrB4Zs+P
         vmOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuqMioeil2ZZ8E7B6D4i1rPWP/RzB/waLelCP6FXzb6owOrX+/G5pyeIwe1YDHlF+g90JOUVke1Q==@kvack.org
X-Gm-Message-State: AOJu0Yxz52ULlbLgAJ1edrXZEiYe6cNW0z3tcseoauUt+yhFI1i6eMbY
	gED98awZ3y55UcNffz5uVgxm3B3Hpe+xlU4wxDbropfcIVVLq1rVN7cb8jZogOxQN7wwqHTZAdM
	01FOJCynWmIdgOMfgUorbZRMm8z5EQ3ceeROZTYY7km9+FQN3eg8T
X-Gm-Gg: ASbGncu0UonNSzJtjRT+5beCL0eVa8dwVqP2SaME1OAtH7gUfbU1zZE9TtlPEM2Y75k
	6znohENLc7iXUat9RzlLALimM8GpOJHoiNJhjdsRKbM8BkaC1fRoB7mLJujITmPMq7RyVLzhN6V
	Ut5jE+AtbT0xsk68b9lEcpHIG++PFY1AtUJkyNXFSCleyjJRxwMOqjBUqqX0A/uETnXSU+mA6s4
	h282dXTHaQe1jQVt1EzC3R/MrCsFq5aqYVVPBPmc0V+AfuliYxgbL5MhrWLT0O9ZpLsQtvYZSOg
	c58lP8phcBXJNcshoEE8+69wRvgF5ekxdhrg5e3JzuBgSjg2xN7GiIECiKtJt+P7QUVnjv8A2UA
	DEVXXfBiCFHiEMsm5CWmq86wMiVjSdamiW4C2XiSa7Ej26jfioXIwDZqOSILrNzxN/po=
X-Received: by 2002:a05:600c:12c8:b0:459:d645:bff7 with SMTP id 5b1f17b1804b1-45f211d075emr77848195e9.12.1757935766929;
        Mon, 15 Sep 2025 04:29:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXwSZAmD9XxC8mSwauh0HqDNFoXO/t7RfP7K5UEy8I9vZ6KWWwB8fAmEU7M97ekmJeVjPdJg==
X-Received: by 2002:a05:600c:12c8:b0:459:d645:bff7 with SMTP id 5b1f17b1804b1-45f211d075emr77847905e9.12.1757935766402;
        Mon, 15 Sep 2025 04:29:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e017b3137sm180607445e9.19.2025.09.15.04.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 04:29:25 -0700 (PDT)
Message-ID: <a48c8d89-da30-4a7d-96f6-e5e17757b818@redhat.com>
Date: Mon, 15 Sep 2025 13:29:22 +0200
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
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <CAA1CXcA+pb5KvEnJJqdf1eSjaFiBZ82MRB+KDmyhj3DbiQqOxg@mail.gmail.com>
 <enrgrocqajwu5d3x34voghja7pbvau45oobxgabawrly44ld4u@ahch3xn6rtq5>
 <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
 <155c821d-402c-4627-a723-6f8c88a2f65c@lucifer.local>
 <ae9d88e2-bab9-49fc-a459-d7b9a8fe9351@redhat.com>
 <ff4b6935-fd13-478e-9187-219fb612aac3@lucifer.local>
 <e450009a-56c9-4820-bd0c-da1d782d3962@redhat.com>
 <2757fb07-78bf-4a39-8c60-8ca8be200994@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <2757fb07-78bf-4a39-8c60-8ca8be200994@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6dmDX3SuJa1-vfLD1Lt-sm1dT4YtDROt50qdcs72njc_1757935767
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: iyupr87bpnjksz55k6mmwt4mf1js1f9a
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B8EF40003
X-Rspamd-Server: rspam10
X-HE-Tag: 1757935770-307374
X-HE-Meta: U2FsdGVkX1/0VgAADo38DfSgVv/nuYtWUTGhP9Nh3ZuFfC4I4cm/gFI2Ab7Dwx702uIM8aEQBQB5a+VBKq6QyTyO48a/G7Rbn/C2FJyn4kC8b2ZQxaFwXK8R0EKcBy9Cxe/pKs4W0lrJ2s+jWNFg7co2cHQMuwNCjscGzPqvqvgsSLFHLxRMUW3BF6ZNC9dxJfx77Hd7bviNAMBdDnXKpDYx6h6xH4QNFd8lEqriirSIF7nkDfhgYzYzf9LkRsydvVJoE4WcIxFOVBXfxGTuHWlJCLwJDdP2/EYyKcajQOOHXwYcKcQjKSK5pFpv2wc3yWXvGWfNGtie92v4dTHqIS2BBxAlwcBYrI2k/v0qMWIGkQ6s6NVr3q9SzYbtNl1SDXuCMsCiurPjiFFONnUES/whkfjgYxP4RrEQukL2TkJVJLfQOYKacOIOmXLaV4rA2jGH38gBC7YQVD+caC4GWLhENIXsQ6SCNW7vCIbn6YkaQ+RZIm7Z2iEjlEiceYUsMvndasvOBnFAyfBoB/dIZzSeXDUHslKk8LAbyngAqh34F9m25ijJtWcC+QTDdbZWfZxWyGhlOMY7v6Kf7bZsVuf61mVIfkqipAWqBuyhvNZbrzW71ItASCpH0JluV4RVpNstGmO+FkBqVgznUrJV3odqlbmHW7PaW8dQp17bBYMcDQsc97ClMsyUv26NWlyWG0//CX0WfwlSp/Ezxvs5OeWpSZd+mE7cOHdkRNgEOFbuIbtq0UnFHLWKjWgYVuHobSwnYgHDXQRqOOsMHreqgsceU+w7lq02Art1EIMYuYmx2+X9khz7+6PfsaS47g6250IQUkybbSiyOIz8SmpdftYdawN8b8jKC+QQiO31GD1RQnrBaLvzo0BbwqqS+fz2Eu8Ytn95wdNr5hDIVZVuJBK+5Sp87MNlbJhXDCIuvBl5uwBV7szqeud4zRNXiezG7U6SX51qrj+yCcAy81t
 m/r3SCwz
 5tPwDZdyCqJ6dTWXEItjIWhUgLpqeNyhM3VHYmkDUqdhPqB+3Gz7H0FhwI0brrAPNAMJffUektMLLQbQE9IS+dgiIo24LMVRtkBn3qN6ftoygOqpWSN8lpG7ZoaP3iiymjK5R6WX05nWgdRzavNfktkZDsfJxud/4WykCp+d7L113l7yZGCqVL0D+ACNhVb5Io4gO1QrCB1sUKnz3ykNcLn8C6IJ8gDdCG3KC1j34TcwF5CqcsG2BwECoEi3y/Yc2+xKMSHd1azEEbHpjvAj0hgeHNwbCLSfmWII73XoELT2CbOIcWYrb8A/pQDEmq27d7Ccqi1J1ZDJbPbvxE/Xba8V/6uHsNYbXJvHpZDC3hkqPwbtH08m0RXr0bU1bH9pdpwetb36qrPvgu4AaS605A5oG6nsqjZ6uVDlBHFhZaxWWrPBc0/pvASHVWcVwqCpv9MmPYb0wikfxiyEi+z/wfreY+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 13:23, Lorenzo Stoakes wrote:
> On Mon, Sep 15, 2025 at 01:14:32PM +0200, David Hildenbrand wrote:
>> On 15.09.25 13:02, Lorenzo Stoakes wrote:
>>> On Mon, Sep 15, 2025 at 12:52:03PM +0200, David Hildenbrand wrote:
>>>> On 15.09.25 12:43, Lorenzo Stoakes wrote:
>>>>> On Mon, Sep 15, 2025 at 12:22:07PM +0200, David Hildenbrand wrote:
>>>>>>
>>>>>> 0 -> ~100% used (~0% none)
>>>>>> 1 -> ~50% used (~50% none)
>>>>>> 2 -> ~25% used (~75% none)
>>>>>> 3 -> ~12.5% used (~87.5% none)
>>>>>> 4 -> ~11.25% used (~88,75% none)
>>>>>> ...
>>>>>> 10 -> ~0% used (~100% none)
>>>>>
>>>>> Oh and shouldn't this be inverted?
>>>>>
>>>>> 0 eagerness = we eat up all none PTE entries? Isn't that pretty eager? :P
>>>>> 10 eagerness = we aren't eager to eat up none PTE entries at all?
>>>>>
>>>>> Or am I being dumb here?
>>>>
>>>> Good question.
>>>>
>>>> For swappiness it's: 0 -> no swap (conservative)
>>>>
>>>> So intuitively I assumed: 0 -> no pte_none (conservative)
>>>>
>>>> You're the native speaker, so you tell me :)
>>>
>>> To me this is about 'eagerness to consume empty PTE entries' so 10 is more
>>> eager, 0 is not eager at all, i.e. inversion of what you suggest :)
>>
>> Just so we are on the same page: it is about "eagerness to collapse", right?
>>
>> Wouldn't a 0 mean "I am not eager, I will not waste any memory, I am very
>> careful and bail out on any pte_none" vs. 10 meaning "I am very eager, I
>> will collapse no matter what I find in the page table, waste as much memory
>> as I want"?
> 
> Yeah, this is my understanding of your scale, or is my understanding also
> inverted? :)
> 
> Right now it's:
> 
> eagerness max_ptes_none
> 
> 0 -> 511
> ...
> 10 -> 0
> 
> Right?

Just so we are on the same page, this is what I had:

0 -> ~100% used (~0% none)

So "0" -> 0 pte_none or 512 used.

(note the used vs. none)

-- 
Cheers

David / dhildenb


