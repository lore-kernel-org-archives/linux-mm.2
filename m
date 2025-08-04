Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBCFC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:50:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A9F8E0002; Mon,  4 Aug 2025 08:50:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CBBF8E0001; Mon,  4 Aug 2025 08:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 193E48E0002; Mon,  4 Aug 2025 08:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07D2A8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:50:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A2C6F5837D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:50:01 +0000 (UTC)
X-FDA: 83739057402.20.5A826FA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1791040006
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:49:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TgV00bXK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754311799; a=rsa-sha256;
	cv=none;
	b=mDr6IwSlqXmDTfgJBNiC9GmKEkG6PrDZcUijOFMUNUWUkoJR8XRua2vMwQ1WXS5StM2NQ+
	Kk8PAyyPK9zRrfDqdBe3mY/de9KIWIkLlnH84Lo3PzBF4pu90wwiZOXeCvVB4zeUff3/Lt
	YFYKubbDBB8jltemIi+2fkK9vMSN5/k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TgV00bXK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754311799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Xhhf7HOlGHP/+Ew73mE+84gy9qClegxqAGKGx6kZAE=;
	b=Mq1fxJhB+hIOY55LoDG+olYHALKF/cGgCDyO/UR4vmGfREQM/Mx2nAUlu8QM1dndE0kYjR
	+YLgkN3CBU2pr4KkwOJZJ/yvW7X1OihrwFpOFOJaUvu7rl56fVttKlm72INrTiF3kR3EKR
	gmRXeKLy0Z/wJDXc75B/x2IvviJWz1Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754311798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+Xhhf7HOlGHP/+Ew73mE+84gy9qClegxqAGKGx6kZAE=;
	b=TgV00bXK9aPS6j5TcKnUxRcbB7nBAcRAjkKTQd2BqJpTh1z1Qv70ogjpKF5RyUFN5XjD7/
	kfW13qm+qBCIstnIHh7uvoqutw+4IWoW96asL3mi+Hd1xJraHD13rEM0wu1FAP5V21Vcul
	m0GeU1BUSLVlj+dLf7hcf5YTZvjM1tQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-PvKAeE6_MGGGlS_Yp5Xt4g-1; Mon, 04 Aug 2025 08:49:56 -0400
X-MC-Unique: PvKAeE6_MGGGlS_Yp5Xt4g-1
X-Mimecast-MFC-AGG-ID: PvKAeE6_MGGGlS_Yp5Xt4g_1754311796
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b7931d3d76so1676177f8f.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 05:49:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754311796; x=1754916596;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+Xhhf7HOlGHP/+Ew73mE+84gy9qClegxqAGKGx6kZAE=;
        b=YmL9N+7Lw+MIzwM0hL4aaHk2ybJGVIvl+eRIX9ncgbu8AfE75UcZMFJo1CmstjBcnt
         ck63Sv4r1o7L+6FVUh8gaxIuOPKm5y4Ma9nJ0euNmlCJXH0LTCAWSEtWBsuRT4gzjNRO
         dEKgDQK7xMrXSICAAwHh4feBLc5q8sHhmm/I5WXJvqzIUcOVstsLt3FmaUBWSqpACtc2
         4HyQaijIv4ROrd6u9No4hxKZcYwx25f4ZFA+jFI7qj92ZScJjqcHgPC5FaCFyFkCodhL
         OsMAUbQaKbeepK6oPoRByQI5Hvb+pt20idSTJKpy+TMyIWm+WPjv3EGTp4g4Chi7K8Um
         Zvkw==
X-Forwarded-Encrypted: i=1; AJvYcCVLqN9RfcsfTYEm92DnatvXA2jSbrywVgA1YOq6lP+HNlA6JVaKPmhxUQgkcm1fxJYDGLdWXPRHUA==@kvack.org
X-Gm-Message-State: AOJu0YzHA0P0VoSNozw7m9YOIHk/6pgg4SLffGvzE8V2HhIlsSv7RGyp
	GWYjtbIAye4AJr0DFF7S+lvw0n36Y+xlM7wDRpNSlQt22yJvsyWsm19sH/WgJ4udCkEl7JmfQwh
	zn1zxlI2B28HJeO9QCIHNRteOsNMNpVuU6D1lhdHH4X3rZxmTdiUv
X-Gm-Gg: ASbGncspZbCaMiC6Nc84yUZ1QZaqd/7KBG1uC42PVZk4zQwoDzVZzWyHFg/ZT7WES8D
	OA4cFWA0i4YdbXxhQ/xbLzkqfMe7OXpiRFrbEx5hXaflg688OMZL1cClZU2i+X7eL+7qvBtpRy7
	V/J39lGx1n6ymCcVTFN06PkGMEK+B9HNZX7pHZgSCaigR9Jpw13f580C+7goRPZNou8C8KFkkWO
	Xm/f0sJUy9sUb+MPmjWrFitwhdvWvDnyhez8QzZ+/9d4PFZjEZgmgQn8ZhSWlwTJr6KP9eV5sB9
	FlxTQC8b3RFtL3yHiW+DpWXTdbdtS9vG+rrLCpc+rO+Su0yejDl4YqjQz2JsB3yUmKJ/9FMUD3U
	VsrUzq0TIgAjbgtiM7NpzGT0VwV/JsZvw9m0/45ooLHY2zBjDUP09dvUhPLToM4bc5O4=
X-Received: by 2002:a5d:584c:0:b0:3a6:ec1d:1cba with SMTP id ffacd0b85a97d-3b8d947083emr7216526f8f.20.1754311795523;
        Mon, 04 Aug 2025 05:49:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHFXgDt/YpWGgP2V8sWDg7uI7r5JelqiIRnbxs/Y/QppAtTZ4vWQf600coJVI3Z9N9Z5dRAbg==
X-Received: by 2002:a5d:584c:0:b0:3a6:ec1d:1cba with SMTP id ffacd0b85a97d-3b8d947083emr7216499f8f.20.1754311795008;
        Mon, 04 Aug 2025 05:49:55 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9? (p200300d82f0e2c00d6bb8859fbbcb8a9.dip0.t-ipconnect.de. [2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589edf56e0sm169284285e9.1.2025.08.04.05.49.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 05:49:54 -0700 (PDT)
Message-ID: <77d17dbf-1609-41b1-9244-488d2ce75b33@redhat.com>
Date: Mon, 4 Aug 2025 14:49:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 22/29] mm/numa: Register information into Kmemdump
To: Eugen Hristev <eugen.hristev@linaro.org>, Michal Hocko <mhocko@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 corbet@lwn.net, mojha@qti.qualcomm.com, rostedt@goodmis.org,
 jonechou@google.com, tudor.ambarus@linaro.org
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <20250724135512.518487-23-eugen.hristev@linaro.org>
 <ffc43855-2263-408d-831c-33f518249f96@redhat.com>
 <e66f29c2-9f9f-4b04-b029-23383ed4aed4@linaro.org>
 <751514db-9e03-4cf3-bd3e-124b201bdb94@redhat.com>
 <aJCRgXYIjbJ01RsK@tiehlicka>
 <e2c031e8-43bd-41e5-9074-c8b1f89e04e6@linaro.org>
 <23e7ec80-622e-4d33-a766-312c1213e56b@redhat.com>
 <f43a61b4-d302-4009-96ff-88eea6651e16@linaro.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <f43a61b4-d302-4009-96ff-88eea6651e16@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GxynSXzP5V03DQebNMkQT-7nJDDuR0bkw9w_ccNGxXM_1754311796
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1791040006
X-Stat-Signature: 8ib3n9bw3xgcjjsowufy673e7n59nr66
X-Rspam-User: 
X-HE-Tag: 1754311798-869270
X-HE-Meta: U2FsdGVkX1/iSq/CpZSPopiTpc8kbPnLCD6tJSAo+1yAJGFtLgUz10CzZqrVtgQF6DX43Q244tTzxQi4hoxL9z+MfBmBlrZCJAI97v+4Ez5ox6BAvhWddM018L5MeYKFtJrsfTZjut4x2JFZceSi0fcNVLcUyUW+JX/UdrmFvYx69yXI196LOe3/DLIFmRke+suU8Lkx3vn9U7CJwJ7c/yeEytT6jCQMAnoXSo/eUBpPitt9ZriEOU1xkdpPy3UkqhGL+Oma2oHlzNl0lMTykzBiDyQw+u9wrygqEzlDUooz83a4LsPDVlPNS0l5venWQtGPXN4p62gkx06uBGDRU21RjeZiXAbEJf4UQns0SRf11gr9D14VirTJk9xUCKR9os8Z4SPrdUAwmf6AuCY2fUmqHYqZFSjkgljkI+ufjD4JMdm35Bmyra0fDysVUU55NbPth73/vXaQdZ8A4E4n49/ZnoufmF9StrQ/w28eNL6khK5KCN6Hn20BKTMdIuXB8fmxk4FTFu8nTBYvdR7PzStYEi5R6GiRbQ2LhpNCY7HYCjtadArITGc5UUiVkjlSHRYrMPw/vLdkVucfeavZMmD3+hWzVq6i65M0rqhItpEqjdkFSWRKcaXRUHwv7TRDNB0GDhkadYFM7cYvhQnotec8FOsl2Kuk+syZZmuCdO6s+zLqh/QFxTaIp1QxD94U0QSHVOR7Qg4OO3sEx2DUi53wRRpLkemVFrzV14bFE7PYI7el2VeF/DYFnA8MO14rgu/KgR3ksfbIrLgCyIsOmVy8QrKx4aWPt0MZmCgcVmlADAbFPgQAvu6DmWzk8h4w+biYRcnO/ZeXa8QOIpw+H3zelx74/EqdEZY0HQVw1EUjK5ctvmZjhZ2EipPYphDUhBPTSOTMYRy+CCj8YXmNTloNzBoIevsORhMwr0WDG3y0t0XQbM+eGE6Shz5+WWfFGGBnrhlj6VQ4e1WKyys
 xZo5NGDS
 Asa+Zpce64lIpPAfsn+ygCddACGdYFjrAACrl1/hhn5NdkflWee6Odam+YPe2vN10107nXuT4Nw70cTMx4VO1cY+awddxqTUAjio9GG/ln94dkQVJ+y9p6Qpa9lmZ7ZGu+z7o1yxTic61dIdK/2dZhDijwRj/1O/EL9ARRX5isq2kZpFlvmMR2/sYBIN7P1AixQjBfI0LIIayWqyvMk9jy6SJ0tMVKs4K7jKMCfJXjcObRXKH+YN2jSMPsSXqXuBaQAD7RX7ToWwDg8A0adIFNMO1aXV09PguU5YNa1TSwfMqMzUBLySct73EJw2ROhJP6z/FnLc6bhS/EFzaVGLFQ+gMp6/I+Qd/Re2LG6h8atnZp2glQmjPxhCm3BxOxRRZQKEmhmaJ+7v8lhudCQdyyCZ3jlsWLgqo/qlMaLh7y+cS9mM5g4Uc6oPgOwSzK5nRGM3U6uMErtqr64M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.08.25 14:29, Eugen Hristev wrote:
> 
> 
> On 8/4/25 15:18, David Hildenbrand wrote:
>> On 04.08.25 13:06, Eugen Hristev wrote:
>>>
>>>
>>> On 8/4/25 13:54, Michal Hocko wrote:
>>>> On Wed 30-07-25 16:04:28, David Hildenbrand wrote:
>>>>> On 30.07.25 15:57, Eugen Hristev wrote:
>>>> [...]
>>>>>> Yes, registering after is also an option. Initially this is how I
>>>>>> designed the kmemdump API, I also had in mind to add a flag, but, after
>>>>>> discussing with Thomas Gleixner, he came up with the macro wrapper idea
>>>>>> here:
>>>>>> https://lore.kernel.org/lkml/87ikkzpcup.ffs@tglx/
>>>>>> Do you think we can continue that discussion , or maybe start it here ?
>>>>>
>>>>> Yeah, I don't like that, but I can see how we ended up here.
>>>>>
>>>>> I also don't quite like the idea that we must encode here what to include in
>>>>> a dump and what not ...
>>>>>
>>>>> For the vmcore we construct it at runtime in crash_save_vmcoreinfo_init(),
>>>>> where we e.g., have
>>>>>
>>>>> VMCOREINFO_STRUCT_SIZE(pglist_data);
>>>>>
>>>>> Could we similar have some place where we construct what to dump similarly,
>>>>> just not using the current values, but the memory ranges?
>>>>
>>>> All those symbols are part of kallsyms, right? Can we just use kallsyms
>>>> infrastructure and a list of symbols to get what we need from there?
>>>>
>>>> In other words the list of symbols to be completely external to the code
>>>> that is defining them?
>>>
>>> Some static symbols are indeed part of kallsyms. But some symbols are
>>> not exported, for example patch 20/29, where printk related symbols are
>>> not to be exported. Another example is with static variables, like in
>>> patch 17/29 , not exported as symbols, but required for the dump.
>>> Dynamic memory regions are not have to also be considered, have a look
>>> for example at patch 23/29 , where dynamically allocated memory needs to
>>> be registered.
>>>
>>> Do you think that I should move all kallsyms related symbols annotation
>>> into a separate place and keep it for the static/dynamic regions in place ?
>>
>> If you want to use a symbol from kmemdump, then make that symbol
>> available to kmemdump.
> 
> That's what I am doing, registering symbols with kmemdump.
> Maybe I do not understand what you mean, do you have any suggestion for
> the static variables case (symbols not exported) ?

Let's use patch #20 as example:

What I am thinking is that you would not include "linux/kmemdump.h" and 
not leak all of that KMEMDUMP_ stuff in all these files/subsystems that 
couldn't less about kmemdump.

Instead of doing

static struct printk_ringbuffer printk_rb_dynamic;

You'd do

struct printk_ringbuffer printk_rb_dynamic;

and have it in some header file, from where kmemdump could lookup the 
address.

So you move the logic of what goes into a dump from the subsystems to
the kmemdump core.

-- 
Cheers,

David / dhildenb


