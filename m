Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60ABECA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 10:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA6678E0016; Mon,  1 Sep 2025 06:43:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7D498E000B; Mon,  1 Sep 2025 06:43:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92838E0016; Mon,  1 Sep 2025 06:43:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 99CBE8E000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:43:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B90013B0DD
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:43:52 +0000 (UTC)
X-FDA: 83840345904.27.7E0BF53
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id D02F2160014
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:43:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IEs2XUOp;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756723429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zrru358Oin71TiKq2hMC68tlViLzszSZkEqb3BaG11I=;
	b=2TuAyBU/u2TEF0dDlsSYZvRxk41LfgqHkfjbB1IJgbaDsqHGakyi9rhXK4WX8PraW+mSdx
	ZQW5FEyb5Sh4UXk5uAqYCm6+H4LLUd/apMk+lARYxPXEjbDlN6eKFaP4X75bdkDYWNAEk+
	gtndHvOV29KkqER7yhhQizdJJ5X6/+I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756723429; a=rsa-sha256;
	cv=none;
	b=5G5GSD8uC3UrKKj73iNRS4CeLC1/KPtNjLiAvQGasAzEh0teea05s5H2c1I06V2orU6n/m
	WcnlvJteq2/O3oxJE1imCW1wB+xaoDEmoSX6wGcoOVuqFThF52gLARRxvFr3T61EGpovkO
	34s7rgj5uLdN4OILfHXGxq79m5f6aR8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IEs2XUOp;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756723429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Zrru358Oin71TiKq2hMC68tlViLzszSZkEqb3BaG11I=;
	b=IEs2XUOpiOiJ7zZoDYb63g4FWTHZCy5hcK480H2zEajdo9PVm1zkY+xQfb++QqomOBDn6S
	2+d+9oVwOqbTjfT/iXQyC6xhOb9gVnKgzMsgGs2khStoRLJpz5gg3eUKV+hAS8jyoPbAhF
	8n1z/9F64XBQgf0Dh4YJoaCcYX5fF6A=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-390-4GKgfjiCONqgbcmYD63DsQ-1; Mon, 01 Sep 2025 06:43:48 -0400
X-MC-Unique: 4GKgfjiCONqgbcmYD63DsQ-1
X-Mimecast-MFC-AGG-ID: 4GKgfjiCONqgbcmYD63DsQ_1756723427
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b87bc6795so10085635e9.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 03:43:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756723427; x=1757328227;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zrru358Oin71TiKq2hMC68tlViLzszSZkEqb3BaG11I=;
        b=YFtPZZDHBYFurPKUpd5suO250Oun9gt8htTBDJ9UUi7Zwx3OULsk9/TkBVOXolToP7
         m3GEgwzR8J4hBYZ/YE74E6pURybpdken5QaF8OkWarVyOZriHeVmWxc7iytU9uFBQdH7
         OUhHm2Nbe79VAgw5RO1oAQP+vS1eFhE54QxfIjZstErIKvf4P67UmE2aiNa1wFeDrQdz
         AST2F8ludUbl8jh6F9ePSa5siIv1QiE9Ssu1xTtmeAlBtjqmYWhrivLX3rNSywMp3zLb
         c1T+ozbrMtLBiQjHGXr2ITRnkiovv7OHDjxCV3Hn2mn0drMsyRXf4WP1APAtKN9av1QQ
         Ut5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVzn9kYOdLvEtBX46S8N5WIxNeGPf4S7g8KA1I825jQp3t/umJsJRbWaeZONd/f1uGGiEAuzs2Eaw==@kvack.org
X-Gm-Message-State: AOJu0YzwbgVlqVQi2MeCugG5HMDBZi9jJnN4aEbTWAIcyMqtTM0Gskx0
	zQxB9CvTmI2tRTgMuxcK4Ni5LhI8OaAiK5HlmDe2uI63aZL79To/xk9MSQA13lCCA85G73OswUv
	SDInynZKp8yJjG8wXuhBpe7bNnOnzT185VOAZHh/VohV/TQmSpPE6
X-Gm-Gg: ASbGncvOQZdgadCCjVPVz5s7SSNW8qA50ySwdiodWSlFJk3kDWNqVnbyL5O6a8gxlMA
	RhE4fXojcNNj1v9rtiiBBpO+IV8EtiRrM/KpgFmVrDYmTSDvbPcpBXpMBcFmGOUhZjiKL7ld6mx
	GyuTqGYc3ia8GCjkGI9RoS9UOTnh6F0AaP5gS9A9xFVyr3tX9vTBHP7rfDZL5hdj1BBAMFx9D2W
	E3XaWmhe3ZvNsx11dl4t78XSywR42zNDvJ2aR2dHWlUgCcRiUlUKykIKytvShXndE6jn/VUM2vq
	64Iicnx0ilb0Y9FJUv/uB19CUAzBei6FlvkbFZ3b0LIcmJI/0H9Kco9+Xu5IdSG+/k2YxwHNGJ6
	R2bB02YKC6B3wlfCRMjzh2U41/f2NZDiHJV++Cf9wd/QA7XYUEQZzpukESv6NTff7dqM=
X-Received: by 2002:a05:600c:1f13:b0:45b:8ab0:59a9 with SMTP id 5b1f17b1804b1-45b8ab05bd1mr39257215e9.18.1756723426864;
        Mon, 01 Sep 2025 03:43:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEXxb4OFUEp+gmXD4h1anmHcaA/DXKzIrss5TRKXevtLzyH/iVfzwjgDIJ/CEIsJTOraM8Ezw==
X-Received: by 2002:a05:600c:1f13:b0:45b:8ab0:59a9 with SMTP id 5b1f17b1804b1-45b8ab05bd1mr39256555e9.18.1756723426359;
        Mon, 01 Sep 2025 03:43:46 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e74b72esm154711095e9.0.2025.09.01.03.43.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 03:43:45 -0700 (PDT)
Message-ID: <bfe1ae86-981a-4bd5-a96d-2879ef1b3af2@redhat.com>
Date: Mon, 1 Sep 2025 12:43:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/12] mm: establish const-correctness for pointer
 parameters
To: Max Kellermann <max.kellermann@ionos.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 willy@infradead.org, hughd@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
 linux@armlinux.org.uk, James.Bottomley@hansenpartnership.com, deller@gmx.de,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
 rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
 broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
 mpe@ellerman.id.au, nysal@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, conduct@kernel.org
References: <20250901091916.3002082-1-max.kellermann@ionos.com>
 <f065d6ae-c7a7-4b43-9a7d-47b35adf944e@lucifer.local>
 <CAKPOu+9smVnEyiRo=gibtpq7opF80s5XiX=B8+fxEBV7v3-Gyw@mail.gmail.com>
 <76348dd5-3edf-46fc-a531-b577aad1c850@lucifer.local>
 <CAKPOu+-cWED5_KF0BecqxVGKJFWZciJFENxxBSOA+-Ki_4i9zQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKPOu+-cWED5_KF0BecqxVGKJFWZciJFENxxBSOA+-Ki_4i9zQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ibHGXdl49uwFlN5wsN0HevL_5JJpBvFMa3iw_mtC84g_1756723427
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D02F2160014
X-Stat-Signature: dbnu7ee3zx4thzdxqpjdnin7x3qaa4ue
X-HE-Tag: 1756723429-907536
X-HE-Meta: U2FsdGVkX1/eXJXpE5jz6vDARfKDo/SqBeExfQlLC5CVJ12y/65+bC5X4jkHhn8gWWMlOAt42R+0bYyQxavJt26EzOtU35mrVntc7hl6lkGBePRVptDMeiI0qCsvmnuuXJMMqNGPQMdQGplqZ3zCyeqreGf3hu9O54M0qe1iTMT/TUhMI8a+WAQFbKWRa7RLUaVOgAyzV/SHtZtFaak56x/YUolr0cGQTViBYS2kpY5FNkFRZ1D0HsESQTVgY1TEJVmZhKbFY9nyej7MeQGTxgMJdaG7ZVIYzvRoidvb8xj0s/GFWVYgQd22BjJxTc7fhksdOepJ7sKLz+EjroZszUl6kQbs9ZYHZP8+RxwDi6h5g6BIjnXhXTllzntc2tY2RO+6AmoJmjJwHJkVhz49UpqJDVdzqd34a1VUZG3dSxzmhmWiq4hapJdbjI0ONF5b5gV1rg4DsjGj56SuvWFIsWWPNIjviTUPzK3KqLuP2yfMsktoUtLr4gAnfXhCRvFEvMf4uWZaG8wX8Wh6E/1gFfcjdHCBODfViIb0UrumEANBGVslaTkj8DiIoD+aaXS3eiHB9wiSAmmK4qEYavgHceNx9aA37n6o+EyzEOiomqwbUKQjZCcsNgoMFNrpWqyKl6a+PkMS+oaisWxNTerJxmziSTJf61imZsd7cJbRep/e++QI8onBtEHsqeJwiI2GPEtySaj3cDtOYrYIaXWE9cThXSHGuvJWDEdmUhxamPgjWNO0EeEITlkfigWlbvQUjXgfHHguzQG8OenPEr+tpz6kl3GhM0V+0e+XCQ9pieVD7qQkBKW1HmyRQ3O+mhPuZtuReC+WL1ilxfkNZl/JrEsBjzi+2TLTZwwEk7ncqGUWqVuO7ZTKCBV3aCMGhwLysQsSrE2fEHa5yfdCZX5FqGsByKQkPEqNT8tX/zW3OQzy0+7Q7CAAsCo5gluwBGt9uHcD3CeiPZ0y+oKoyF3
 ZRU0PG48
 uBdxeQAoSRh8W3jqwsLyOE5SxgmPEhze2muGPXVU/BBkBWfYhTWCPL/LqAc/ONvLHJA6WRpkKVJQVMawf6ajG7SnYIHLYLI25BpqYNllUBn8oVIHsCD0J11rX2I5OE/HPI8y+Zi2rgehRe8TVhkmxbMOe3UkZbTOXspTgh2g3JZUMUWPKZ5dgjc3+55cIUi24rnRFrvZ4+sa8eMGvGXzu1y2VaKeZcy94dcpeH7+VUWeQQmjeavPPn8Ap4DVhuOsFMpRUOALjKUKia9etCFs7QSXB9y+/W/MmwT1fTxHBPnJ/QxXZpVLd2ZYOT5mK29rA9fzUZ8EQd+L+VfaymOeeuIgGlBzymddmH98ADTx9jOv1TL8P8sI/LYGbg8WaJPQJBDVgtGsbISHU2I0Ef5p/s12K+/D8n0GHosUc+XsJevjVHrfjF4wuxK57QafWsddked/fpoMZheWJetYEKRuF7GhxaM92AGvsTh1o72MUjJsYI6SkfRozJz6LBo5PjN3DUI94AARQ1GQE60E+w94fR3YSbaEp3BohCK3SnDj5Cb4gcya4R697x0mCBLXLqF6jSf/626W/XaGPQXhQIsLO+3B2C0qHprezkz3SJEX+YJtTY1wQop+bpaONk47/ElHvYN1h75L2NW9ADY23v3xz2lRZn/Ho/T6/GNJGx/djV7S21XAhXgEKYINqaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 12:20, Max Kellermann wrote:
> On Mon, Sep 1, 2025 at 12:04 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
>>
>> +cc CoC.
>>
>> On Mon, Sep 01, 2025 at 11:54:18AM +0200, Max Kellermann wrote:
>>> On Mon, Sep 1, 2025 at 11:44 AM Lorenzo Stoakes
>>> <lorenzo.stoakes@oracle.com> wrote:
>>>> You are purposefully engaging in malicious compliance here, this isn't how
>>>> things work.
>>>
>>> This accusation of yours is NOT:
>>> - Using welcoming and inclusive language
>>> - Being respectful of differing viewpoints and experiences
>>> - Showing empathy towards other community members
>>>
>>> This is also not constructive criticism. It's just a personal attack.
>>
>> It is absolutely none of these things, you admitted yourself you thought the
>> review was stupid and you used an LLM to adhere to it, clearly with bad faith
>> itnent.
> 
> There must be a huge misunderstanding somewhere. I and you guys must
> be talking in a completely different language. None of that is true
> from my perspective.
> 
> I never called any review stupid, nor did I admit that. I disagreed,
> but that's not the same thing. Remember when I told you "Let's agree
> to disagree"? It's perfectly fine to have different opinions. Please
> don't mix that up.
> 
>>>
>>> (I'm also still waiting for your reply to
>>> https://lore.kernel.org/lkml/CAKPOu+8esz_C=-m1+-Uip3ynbLm1geutJc7ip56mNJTOpm0BPA@mail.gmail.com/
>>> )
>>
>> Your behaviour there was appalling and clearly a personal attack.
> 
> It was not. Maybe you felt that way, but I did not intend you to feel
> that way. I would like to find out why you felt that way (because I
> don't have the slightest clue), that's why I asked, and why I'm
> waiting for your reply. If you would reply, maybe we could clear
> things up and resolve the misunderstanding.
> 
> It sounds like I won't ever have the chance to do that, so... farewell.

Let's all calm down a bit.

Max, I think this series here is valuable, and you can see that from the 
engagement from reviewers (this is a *good* thing, I sometimes wish I 
would get feedback that would help me improve my submissions).

So if you don't want to follow-up on this series to polish the patch 
descriptions etc,, let me now and I (or someone else around here) can 
drag it over the finishing line.

-- 
Cheers

David / dhildenb


