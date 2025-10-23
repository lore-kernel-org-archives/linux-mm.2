Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70821CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 11:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B77A68E0014; Thu, 23 Oct 2025 07:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B03BA8E0016; Thu, 23 Oct 2025 07:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956B48E0016; Thu, 23 Oct 2025 07:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A6CD8E0019
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:49:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2DE11BD065
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:49:30 +0000 (UTC)
X-FDA: 84029208900.12.28EFF5F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7B6FA1C0006
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:49:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hnPYjmKX;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761220167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JCBxlSGX2oKy9c5VZTiKe/QSwX2dngLFxql68g6Ybmk=;
	b=y7Vaf3MWYyHz2fSJj660OeOJolfjw+OSwOC1u8OGzTf3ZnT36N8DpKkKpEbVhuvOp2C8EO
	hQTvvuUXwvKnwh0qHwlSPMqLkDWaPOWDB44aPq1PYZht74gjcyPWdhpn/B7hvLTDMzY10N
	jDGxqMH5u7BZuwx+ziHiCF+9u5WBz3Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hnPYjmKX;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761220167; a=rsa-sha256;
	cv=none;
	b=0CWyfTiaXW5E4H/BZEePXfq1iCoN7a/gkv66o/3pz/Kb5v0/Q+BcIQA0itWIn0noPk2EMu
	a/MZ1/9kbCtxd70kFdIaDiRSP60SWMZ+jBOt6ulC17vQ0ZzSMl5TK28PsVJIQ+3JDitPpS
	Z1q0tNWR/B5QvDzu5sUFAHdJqxHfEAk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761220166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JCBxlSGX2oKy9c5VZTiKe/QSwX2dngLFxql68g6Ybmk=;
	b=hnPYjmKXRrKnWup7dOoXW5QlLEvOn5U5a1MtzIdiBH3Y6vACdrgkDHDIa5YVwjK7W4AcOr
	HaCEP8VLaW/vy0DQiblWoQVjaAl1IQkT3SQlpieDcH8eF/um6461Y9RLQNPHSr79cZ4Tej
	R0rJ0hBuDEL1IFzYp0MYpR3UIPOGnMA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-473-Slf90KT5MwyLD-gUJ__qsg-1; Thu, 23 Oct 2025 07:49:25 -0400
X-MC-Unique: Slf90KT5MwyLD-gUJ__qsg-1
X-Mimecast-MFC-AGG-ID: Slf90KT5MwyLD-gUJ__qsg_1761220164
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4270a61ec48so442244f8f.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 04:49:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761220164; x=1761824964;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JCBxlSGX2oKy9c5VZTiKe/QSwX2dngLFxql68g6Ybmk=;
        b=blmDKff0JRW513GxfLhsvc/OCQAZZ/YwGHwOj11Q0/L14ZPnIgMui8M8T91jSvUyRB
         c2tzZc5R3XUW8CoZvfytJ/ebu9ZrjJJ7kfbYWGtywGpgg1D4AyjbUKLUoWK/HTgwbbr/
         UYjRo2JMNKkMhuwAINLJtxH1jkegd1fqtSyf42uVGMKJphGZ+06SlxWTCBkg2NUaDJj5
         +I2qqulI2JSVzcEOMCyAoTP8e2UEv6rb+O4ZzlCldITIf8YiKAjL15tcD356tsfAi1wP
         f/fwmJLSX6pRt0LVgzmfXyq/cJOxVYBszACwV1rtBV3Ub1J9vp8hmJXRYq0vMsigeIzq
         qu2A==
X-Forwarded-Encrypted: i=1; AJvYcCUuHjCtdMjJ7SgSxdnN/X3cJFXvTG8Xr2EuqNA3HselVMYn51wLrx3GKbyR9/DoZ4RL5uZwrI0K+w==@kvack.org
X-Gm-Message-State: AOJu0Yx8+iH463vb0YN8ZcqM1VHqgn59oRvbyp3t/WRC1O4xcS0QtFCz
	nCcWEomAL6YosoQgcWlYIGrtRJAbIcu0+dVmGoDX/VtF/xp84kexaiVKryqAjmefoWP7Al/2tr4
	1k77IXaB5s+/UiNOpdtw9kBYvs4N3AeA+hUsaW6ee42+UMcK+vOvV
X-Gm-Gg: ASbGncupvuYaOuCGD+iXmNycsWp1ADVGFbgb0adfTkqDvPlNq0wh7TVy72wjKSYl7zC
	wuPAfpEAMLQAPlk5xaCTA4/MLJPgQOawwrnhSRAK/6QenroEd6/o855zBl5v5BNVwvO+nQu6/2K
	17fFSVchzhUcR7ZRXrWJVA5g2LyITQSNSmMo8JDMjIWHEgk+3UqoHwnoDiOva1Kv+bPeq9Y8iKt
	JXP9npU66GH7ujvPBC6/nVBxtNPYtNI1S9fo7rp97s/luhMLfPtAnjpdRL27lu4cOzjlTwWwFMu
	ROljTvIJyD5w3veQZZvs28JzM4VypnIHZO58BMX0HfjC5O+ecU/IknDN3Xl0zDfcS9GAtj0rN88
	apE/vOBpuKZVKFHrbn3zrm7h1/ApWBzuz1QY/WZDoJ8DiG20FVCqsA38+dBVc6NWATcFHelbG1A
	yITGc8bm3L2zpCqMlwTblUF0WEVLs=
X-Received: by 2002:a05:6000:470a:b0:427:491:e77d with SMTP id ffacd0b85a97d-42704da9e16mr15577043f8f.36.1761220164345;
        Thu, 23 Oct 2025 04:49:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJfOXZJEHV2NsbUj6aOO2PBD6VL5w9K1QsDgEyX5FiTcCiFyrw8Szd74pXh3vMEb+fyU8utQ==
X-Received: by 2002:a05:6000:470a:b0:427:491:e77d with SMTP id ffacd0b85a97d-42704da9e16mr15577028f8f.36.1761220163874;
        Thu, 23 Oct 2025 04:49:23 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429898acc63sm3522878f8f.27.2025.10.23.04.49.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 04:49:23 -0700 (PDT)
Message-ID: <f57d73e3-fb6c-4c01-9897-c9686889fec2@redhat.com>
Date: Thu, 23 Oct 2025 13:49:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
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
 <5b33b587-ffd1-4a25-95e5-5f803a935a57@redhat.com>
 <7fmiqrcyiccff5okrs7sdz3i63mp376f2r76e4r5c2miluwk76@567sm46qop5h>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <7fmiqrcyiccff5okrs7sdz3i63mp376f2r76e4r5c2miluwk76@567sm46qop5h>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: h6n9eZl3utYMv76mS7IGDy-IZ3mMiV-KO_Hvudxxq-w_1761220164
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7B6FA1C0006
X-Stat-Signature: ik6981onmjddpm5a46y9qsdxszi7yyg3
X-Rspam-User: 
X-HE-Tag: 1761220167-724076
X-HE-Meta: U2FsdGVkX18io8FMaGugFEW+h8TVo0XitZ9H1n1bLuu6Tegl6S9LpRzbylikqmV+wgDgEojfEnP3LnUkVHU8cZTgygw9Duhlr8STNu+4nLGZj66C13A96rP9oQRNRLmaeleDesbtzoUoj6U6959MavfN9IGan5yZE2s1U8abn5HnM8+PGDUT+RFwTyonyQZGnpOCVk81HK0sPmpnrDJnImnJjWYwY+en4wVO8E1OH2GUbTbP/WniyAXerXdMTNANVJK612MHohu+NwoBed/+KHaTB9LzIgc4unKiBUV9enioxOViLMOOZTk/re8N/Vi+XsUZKc0rupCIxwxWuifiqFETxyafObZokCDTLJv/tvlppYKHWPuv0dqJ3baSNC2lpU2cGJFJS+579dv1dWMgs58y7ujXOy+kU9aTaTWZEBQQZ15NP41uA03PFPAWMYJw0IT7LpQeX7dS+DPjG5QAmAQXS1/x3wHSVRbKBg47baaNjmDZl5BMU27f7b/uKRZcebVZSJ9jQM5VTjrUWjQvkBqc4ynMjpZNGMjvls0KaVkphFe+gTNVbrmmQFd7+p4jjPN1A8JW3a+Kk3Xr3QbWL5vtzu8cY1oBL2gU3yYjWJpJMlUlxpY1DjLhfE1ELsrTqBvGS63rztTv18R2D9vymvhXJLmWXiPzFmQLN35UT0ccSOzUEonXcUnu4LLaKo87hmYAhvor/oIKsRlbOGxf5TCCICOqtLbvIn8W67PUn4/TV9+nIFCJll7jOMQP2+otkanlY1ZCzdACofLjQXU0jOseX64urVOfgXL/QkxGk7S/FduBRLkCOE4m9wglcejt5psrg/0Ug8VkVCwuIM5yyNErR6F47SBbHwP/hryu9gHL9Zq8Aiwi1LGPiAvBVK7UrkJxp+lrB+6poYUHc1BYUyeGtLo/x2za5gcX4H7pOBkVlc0pFPYHfzppJ93GQh0BiAk8+arvIliKlujrzj/
 1mKKqOtx
 XS6QKiwN6IEYOwvUF0oS24v89FicBGtMx7ykylYs6m1YF5OyIfXQdoXNSQTgKkH8oL1iX76uUC0irz4fZURaftny5o2V0wuGI8Ttri8d3z8EFYGZU/oodEmKanK4N6QPAemeyilAnRC6P2+R5hF1BBsyuaOt2lX7pGVfMHWZq9+2PrEpIkigqptfiZ6xRXWojk5KAh7bWpzQvJW4DiE0X8vYjiPEXRSp6kgTi/hhM9rDI0SM8QinUvXwGVb8EwkiROBPH+by5aAVvns+kpJuCT29fdyuaTt1mWjd4g8nX2IF0WMKRoXAYHn4/IjuOWGr7uR822Zp3oAv6AEl6ZErqKWFKkQOYLy6fl9X878kkCIrWfnOd+06nYIOFfghBxeGUGzSg5VyR09VCVrT16SeqQSg83VB4WwaL8wH0rlcmuNEn5wKznredWdqXS0dyRPZ+PDtsl8c4btGRbfOE7szPl4NV97ynvi8t6dGOnfPkpHhp7HiTCyzz5PsMn+29UKxuqkX8gTCL+HoanAM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.10.25 13:40, Kiryl Shutsemau wrote:
> On Thu, Oct 23, 2025 at 01:11:43PM +0200, David Hildenbrand wrote:
>> On 23.10.25 13:10, David Hildenbrand wrote:
>>> On 23.10.25 12:54, David Hildenbrand wrote:
>>>> On 23.10.25 12:31, Kiryl Shutsemau wrote:
>>>>> On Wed, Oct 22, 2025 at 07:28:27PM +0200, David Hildenbrand wrote:
>>>>>> "garbage" as in pointing at something without a direct map, something that's
>>>>>> protected differently (MTE? weird CoCo protection?) or even worse MMIO with
>>>>>> undesired read-effects.
>>>>>
>>>>> Pedro already points to the problem with missing direct mapping.
>>>>> _nofault() copy should help with this.
>>>>
>>>> Yeah, we do something similar when reading the kcore for that reason.
>>>>
>>>>>
>>>>> Can direct mapping ever be converted to MMIO? It can be converted to DMA
>>>>> buffer (which is fine), but MMIO? I have not seen it even in virtualized
>>>>> environments.
>>>>
>>>> I recall discussions in the context of PAT and the adjustment of caching
>>>> attributes of the direct map for MMIO purposes: so I suspect there are
>>>> ways that can happen, but I am not 100% sure.
>>>>
>>>>
>>>> Thinking about it, in VMs we have the direct map set on balloon inflated
>>>> pages that should not be touched, not even read, otherwise your
>>>> hypervisor might get very angry. That case we could likely handle by
>>>> checking whether the source page actually exists and doesn't have
>>>> PageOffline() set, before accessing it. A bit nasty.
>>>>
>>>> A more obscure cases would probably be reading a page that was poisoned
>>>> by hardware and is not expected to be used anymore. Could also be
>>>> checked by checking the page.
>>>>
>>>> Essentially all cases where we try to avoid reading ordinary memory
>>>> already when creating memory dumps that might have a direct map.
>>>>
>>>>
>>>> Regarding MTE and load_unaligned_zeropad(): I don't know unfortunately.
>>>
>>> Looking into this, I'd assume the exception handler will take care of it.
>>>
>>> load_unaligned_zeropad() is interesting if there is a direct map but the
>>> memory should not be touched (especially regarding PageOffline and
>>> memory errors).
>>>
>>> I read drivers/firmware/efi/unaccepted_memory.c where we there is a
>>> lengthy discussion about guard pages and how that works for unaccepted
>>> memory.
>>>
>>> While it works for unaccepted memory, it wouldn't work for other random
>>
>> Sorry I meant here "while that works for load_unaligned_zeropad()".
> 
> Do we have other random reads?
> 
> For unaccepted memory, we care about touching memory that was never
> allocated because accepting memory is one way road.

Right, but I suspect if you get a random read (as the unaccepted memory 
doc states) you'd be in trouble as well.

The "nice" thing about unaccepted memory is that it's a one way road 
indeed, and at some point the system will not have unaccepted memory 
anymore.

> 
> I only know about load_unaligned_zeropad() that does reads like this. Do
> you know others?

No, I am not aware of others. Most code that could read random memory 
(kcore, vmcore) was fixed to exclude pages we know are unsafe to touch.

Code where might speculatively access the "struct page" after it might 
already have been freed (speculative pagecache lookups, GUP-fast) will 
just back off and never read page content.

We avoid such random memory reads as best we can, as it's just a pain to 
deal with (like load_unaligned_zeropad(), which i would just wish we 
could get rid of now that it's present again in my memory. :( ).

-- 
Cheers

David / dhildenb


