Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E9FC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 13:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AAE06B00BB; Mon,  4 Aug 2025 09:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934AF6B00BE; Mon,  4 Aug 2025 09:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5E06B00BF; Mon,  4 Aug 2025 09:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6AD9F6B00BB
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:26:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3666A114CBC
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:26:27 +0000 (UTC)
X-FDA: 83739149214.03.2D577A8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id A2BE040017
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:26:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HtDOOzyq;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754313984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+syeeiXPEpHAZa1jQ2IGr9bhWKD3RhAUlR/Ct8pq72g=;
	b=YFaQv/U3ecQiRJsue/e5G5pe/thYrCd/hEkUR3N+0tW0yri1V0269NuXLo+CXTBQk4RMPp
	UuZU/EG17ErNsf+7L5EK5DRbnd6gijhHVzJRaExsM2zEEVEDvNFatjEip/WlUJCGmH4E+o
	w4adgE0+Hmu4bQOIy12LdYffyGrEUBs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HtDOOzyq;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754313984; a=rsa-sha256;
	cv=none;
	b=mt5Y5ben2n0jAkX85UiVfRJ8dptYJqPgSoQ2C4ZPa2UUCsqQEyYtDeqSORd3D6AC4P1PqK
	dOTvoO8oJgwLK4wtw4kH71FuOZBZA/BlIbWRE6E11/Vk0S24i17fiaZ9cd2kWOXCQIVTFl
	agez4C+DZ7948SwyToJyeEWVy4Bo/7E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754313984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+syeeiXPEpHAZa1jQ2IGr9bhWKD3RhAUlR/Ct8pq72g=;
	b=HtDOOzyqqEoRGo9IbFhqN9/+11Onm7TKecQu+pz7S1BkOBrZprDwXqGx11YHa2yMWdL9vT
	+hs0TtAE5Ir+1WWeqWEB1Q+Zww96asJozUTAG3tJDQfx1y9lM89gEcgxR6WrlbccCJDU2N
	yj84hYtIx4zlYBclPUJ5GQW1MsQ5b5M=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-AmHYgxHBNyOPkdDjCrhMWw-1; Mon, 04 Aug 2025 09:26:22 -0400
X-MC-Unique: AmHYgxHBNyOPkdDjCrhMWw-1
X-Mimecast-MFC-AGG-ID: AmHYgxHBNyOPkdDjCrhMWw_1754313981
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-459d7ed90baso7466095e9.2
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 06:26:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754313981; x=1754918781;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+syeeiXPEpHAZa1jQ2IGr9bhWKD3RhAUlR/Ct8pq72g=;
        b=Rh62tdLCgP/aP0lbqNkqIqND0uJUGqFOITIL7xhMz+fR4wTZ0HjIpWAfDZbSMo12vw
         k3XjJalBKBLx9Nm95Rh/TvKmwPdAMkcNbJ4tCknXzqUlJHFhVI77TMruPZa7vZLIatDy
         +zc6t7QG1lbHCPqx6KVVi6eZc9M7HH3pgtsPnxAhZDLWmtgjR0pozfnWWTMT0op3wDEC
         6OjAs8RaT/ipq39AG3y5Flrpfi8WE/HtSm7XsLbdWCUxCLY5hj6/W7O+D4KRSj8ZqWjn
         l4aN4daJ4NIjQFAtyOJcw9DD36HZexRKWe3edKZUxdljya3b4r8akCvBMOFKFZa9cf4d
         t8UA==
X-Forwarded-Encrypted: i=1; AJvYcCXdAkOxQUwWHKjW6cO8ab+BmHNiKwwyJPgWIsWv5fraHmPRHo1PMsHUBn0qC3WrrflC30kXiYDgXA==@kvack.org
X-Gm-Message-State: AOJu0YyGfdJ1E1UlAKIwHy6R8Xc+DswdPYF3mIYiAYpKLSNG9rLNiS5C
	kzBeJrU4+V8Fug8r8AuHt6rJLMR+OqNcs4Y73L52bWRo/i8b8gUN2ODwTlviCGxHrK2aLzS38xo
	irtIBQqXBezCB3SoH3HZOdVh3hztVXMSjD++eUL763WdypPVt6u6+
X-Gm-Gg: ASbGncsP4hmvcT+L93DwYUOfeQoQ5atG2JIV9UkqJnU3ajzzGnM0CM/cR3IKTK4ziJD
	TNkWuOV6FSAFRam+psPYR6eY8xKroHnbkRb8iXbRwS4RfY65E9HGe1hE/8KtrlsA35Jw5yRo6iK
	mt6pkwOQcB00RSawjw+cjv6uIoe2rtdGqNtdfs+B4T0vsGG2+6djmlOpCWXSeA7iJevfqnMacxJ
	rs+tWC4fkUD84Ym6KIcJdTm0biyW86KGTeEOyDiAo4hJLH4teYzBO0cI8q2/KcOsc4wwt+/pPuF
	Wnabo25QcZCiWJmYSr4HlsS9z6EQCCZioa6AstyztArhU3Ck9feLtqFRR/651l1WLbz9lyzUPI7
	IIRSmxrYH9p0K1uoJtI2P5fFyvoqjJExmGcsxo6RS/xc+QWIl9eXtRGWpak5ObL4kkPU=
X-Received: by 2002:a05:600c:4591:b0:459:ddd6:1ca3 with SMTP id 5b1f17b1804b1-459ddd61df8mr20635635e9.0.1754313980537;
        Mon, 04 Aug 2025 06:26:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHzEU2ciW2PAPHvOJPycVzMqjI/w8se0E7GvKwu8THCSgopGYOKxHb1Dfm+Yw30i1TMB/Pz4w==
X-Received: by 2002:a05:600c:4591:b0:459:ddd6:1ca3 with SMTP id 5b1f17b1804b1-459ddd61df8mr20635205e9.0.1754313980022;
        Mon, 04 Aug 2025 06:26:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9? (p200300d82f0e2c00d6bb8859fbbcb8a9.dip0.t-ipconnect.de. [2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9eddsm15589726f8f.22.2025.08.04.06.26.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 06:26:19 -0700 (PDT)
Message-ID: <9f13df6f-3b76-4d02-aa74-40b913f37a8a@redhat.com>
Date: Mon, 4 Aug 2025 15:26:18 +0200
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
 <20250724135512.518487-23-eugen.hristev@linaro.org>
 <ffc43855-2263-408d-831c-33f518249f96@redhat.com>
 <e66f29c2-9f9f-4b04-b029-23383ed4aed4@linaro.org>
 <751514db-9e03-4cf3-bd3e-124b201bdb94@redhat.com>
 <aJCRgXYIjbJ01RsK@tiehlicka>
 <e2c031e8-43bd-41e5-9074-c8b1f89e04e6@linaro.org>
 <23e7ec80-622e-4d33-a766-312c1213e56b@redhat.com>
 <f43a61b4-d302-4009-96ff-88eea6651e16@linaro.org>
 <77d17dbf-1609-41b1-9244-488d2ce75b33@redhat.com>
 <ecd33fa3-8362-48f0-b3c2-d1a11d8b02e3@linaro.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <ecd33fa3-8362-48f0-b3c2-d1a11d8b02e3@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Q-2VyEco1Kkze9D2uXe2luQGcCuZf8ntzP2LP6w_y6Q_1754313981
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A2BE040017
X-Rspamd-Server: rspam06
X-Stat-Signature: d64yzaeyfqwgy9ozf59oqdjgz6zcxd1d
X-HE-Tag: 1754313984-130535
X-HE-Meta: U2FsdGVkX19vBVMDiENdX0r3j4w9m7KH9O9DdN2HkOEkf10BZLnOtk3MfOYNesV9uVuTYtMUymjIBsEjbVDyFwagvy76QsJ0/oGGTEbs/21Fv6d3quoGiikfAm0B6y4npCS4XMMcRevaQA5onsVET07C9qUBzTdm2D2qPcxbbiLlfDq/NwuRNld/OWoyXDdBWPjVHNFX5uVAOV8RXy3wHQlY2VS8Jxu9ylm8jAuphYrhWKYkyceqjSE667JNcv5ta3SLA/WWc/gswFsr6XqDCrZakKa2gAzAa7tSD3Vu0GKWajA35WAHXOqN9qlTtYyfpdKyyCGSYuK48AtAJFOQ1fkY4Ze373LWXMUCieW000DCWU3askJ4DxXsVc3F5PxxEfpDiwZDQyBZL436306nyCj/GavULJ9Lq7mjl0phylX/2x59v2ICHpLw3zUeKql8g/T6WTA4AN8ubM8SXPIDVVhFYlqCIsQCke4dvgK1Ksh6qUc8uW/4g3geUY4LzuRyqoXAdql7IFENGgPWRHvSieFo7P+ZzX4dQyZYIPICfcYk5PzL0Zdx/HjS+yBwe6mi/p1507YdY7qFSPtheO9IfUunnmKPaqyZ9ppx1Tq1e0udUhtB0pB2EF7IYVS7w1moGvSOdCgYFJpm7cS3pDlZhhaGZgpbXfGHCNgbGkuXEKVi9NAFbumygY+e+fW0Ti2cfX6Ggosnr1INUuFrzYmoPkrt0lgsTQovLP6Eys/29PYwhHA7OUbTi6vt8nJfNFn1ihd1SQZZsF5XqhLnmQPzNSrxoPOav4P6i8EeST+O1En0kU/9UvCUul63kqlGy2Z5XF6P8uZJkovWGPQsBS5yVOc4L1CXDtc/tgRCUJwwrcK9RqSEAZFfxf7Pn4ukrpXMd6F11SEVsIQfjUmRw39YCa8UagG49RsuqwyUop7awtDhSJSC1N+6k4AqkdNvY/c4iPOHOzu2BFe2ZMA1RGh
 SUu/Lp3f
 wzAOqHzPfOOU86klfU7idyIGIa+2VOm+VDvwOd/luKIr6Pv2zBmc46MplWK3FiDgI3sMxAPBHG8qkt6DVnOLh61nSNLvjOw+7meR9u/MHYjHK9f2utiDyN8HDyRCS418ZT0zZibpU5qCbwNtlw0/hbrD0Toh6nDb2WvXgIsMR7uuaZql2mCxKzhTd6Aj29Vob8GgC7isZ9OZb8F7TQEHsu0LlmHuLKs6OhgG6eWVvAGz5qj6mzU7UdlDwLFNtNlqNumiLQN2NFc4V6QlSg/awJSerDEd32YX5bSk1NkakD3/wAl4wxN6jqU5TquhXbyDvCi62ShJYG0bznTNdZbcQF/xX7Ss8inwNDvBfsa4h7SPWqHgp3TvA4s62RQMCvD7EGnQbotuLVNKQq1Pz7VoKHabWpj5psaK7sR4juLNxf3WsXe5hvaHfYVH9e9KC06CrXflKYh7FRUM7mXCkFqj4D2wykE6uhBd8x5lGMkEmxV4N93w6FLdb5Owj6gJxX71JGjKU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.08.25 15:03, Eugen Hristev wrote:
> 
> 
> On 8/4/25 15:49, David Hildenbrand wrote:
>> On 04.08.25 14:29, Eugen Hristev wrote:
>>>
>>>
>>> On 8/4/25 15:18, David Hildenbrand wrote:
>>>> On 04.08.25 13:06, Eugen Hristev wrote:
>>>>>
>>>>>
>>>>> On 8/4/25 13:54, Michal Hocko wrote:
>>>>>> On Wed 30-07-25 16:04:28, David Hildenbrand wrote:
>>>>>>> On 30.07.25 15:57, Eugen Hristev wrote:
>>>>>> [...]
>>>>>>>> Yes, registering after is also an option. Initially this is how I
>>>>>>>> designed the kmemdump API, I also had in mind to add a flag, but, after
>>>>>>>> discussing with Thomas Gleixner, he came up with the macro wrapper idea
>>>>>>>> here:
>>>>>>>> https://lore.kernel.org/lkml/87ikkzpcup.ffs@tglx/
>>>>>>>> Do you think we can continue that discussion , or maybe start it here ?
>>>>>>>
>>>>>>> Yeah, I don't like that, but I can see how we ended up here.
>>>>>>>
>>>>>>> I also don't quite like the idea that we must encode here what to include in
>>>>>>> a dump and what not ...
>>>>>>>
>>>>>>> For the vmcore we construct it at runtime in crash_save_vmcoreinfo_init(),
>>>>>>> where we e.g., have
>>>>>>>
>>>>>>> VMCOREINFO_STRUCT_SIZE(pglist_data);
>>>>>>>
>>>>>>> Could we similar have some place where we construct what to dump similarly,
>>>>>>> just not using the current values, but the memory ranges?
>>>>>>
>>>>>> All those symbols are part of kallsyms, right? Can we just use kallsyms
>>>>>> infrastructure and a list of symbols to get what we need from there?
>>>>>>
>>>>>> In other words the list of symbols to be completely external to the code
>>>>>> that is defining them?
>>>>>
>>>>> Some static symbols are indeed part of kallsyms. But some symbols are
>>>>> not exported, for example patch 20/29, where printk related symbols are
>>>>> not to be exported. Another example is with static variables, like in
>>>>> patch 17/29 , not exported as symbols, but required for the dump.
>>>>> Dynamic memory regions are not have to also be considered, have a look
>>>>> for example at patch 23/29 , where dynamically allocated memory needs to
>>>>> be registered.
>>>>>
>>>>> Do you think that I should move all kallsyms related symbols annotation
>>>>> into a separate place and keep it for the static/dynamic regions in place ?
>>>>
>>>> If you want to use a symbol from kmemdump, then make that symbol
>>>> available to kmemdump.
>>>
>>> That's what I am doing, registering symbols with kmemdump.
>>> Maybe I do not understand what you mean, do you have any suggestion for
>>> the static variables case (symbols not exported) ?
>>
>> Let's use patch #20 as example:
>>
>> What I am thinking is that you would not include "linux/kmemdump.h" and
>> not leak all of that KMEMDUMP_ stuff in all these files/subsystems that
>> couldn't less about kmemdump.
>>
>> Instead of doing
>>
>> static struct printk_ringbuffer printk_rb_dynamic;
>>
>> You'd do
>>
>> struct printk_ringbuffer printk_rb_dynamic;
>>
>> and have it in some header file, from where kmemdump could lookup the
>> address.
>>
>> So you move the logic of what goes into a dump from the subsystems to
>> the kmemdump core.
>>
> 
> That works if the people maintaining these systems agree with it.
> Attempts to export symbols from printk e.g. have been nacked :
> 
>   https://lore.kernel.org/all/20250218-175733-neomutt-senozhatsky@chromium.org/

Do you really need the EXPORT_SYMBOL?

Can't you just not export symbols, building the relevant kmemdump part 
into the core not as a module.

IIRC, kernel/vmcore_info.c is never built as a module, as it also 
accesses non-exported symbols.

> 
> So I am unsure whether just removing the static and adding them into
> header files would be more acceptable.
> 
> Added in CC Cristoph Hellwig and Sergey Senozhatsky maybe they could
> tell us directly whether they like or dislike this approach, as kmemdump
> would be builtin and would not require exports.
> 
> One other thing to mention is the fact that the printk code dynamically
> allocates memory that would need to be registered. There is no mechanism
> for kmemdump to know when this process has been completed (or even if it
> was at all, because it happens on demand in certain conditions).

If we are talking about memblock allocations, they sure are finished at 
the time ... the buddy is up.

So it's just a matter of placing yourself late in the init stage where 
the buddy is already up and running.

I assume dumping any dynamically allocated stuff through the buddy is 
out of the picture for now.

-- 
Cheers,

David / dhildenb


