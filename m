Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4ACECCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 20:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 471FB8E0032; Thu, 16 Oct 2025 16:55:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4225F8E0002; Thu, 16 Oct 2025 16:55:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EA608E0032; Thu, 16 Oct 2025 16:55:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1BDA28E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:55:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A3D058FAD
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:55:20 +0000 (UTC)
X-FDA: 84005182800.20.91C4A2D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 167F44000B
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:55:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UDAbCJzb;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760648118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I8i6tGQrPfrnRJOA/8H62CFFvRz1tXxW9tTyBQNOk7s=;
	b=p/XevOLQw7OD8X3k1zh5d/OgYb6LVSbzeEdIi63ELB+EpC5LzZYKveH/Eu6Z3c4gjsh9b8
	l/IcYC/XMCgqrhGGzSpLFtklD8GM5CEzVCMkZkKD98pqXsxyHue6D20ldb9iXueh6KT0b6
	n76EBktpu2mr1oBLh61m9iCOI4QdbA8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760648118; a=rsa-sha256;
	cv=none;
	b=B4geDmMZOa89Qz4GYq6ozP3NDr9dfXdGsliA1TzQXg7jn89NBOLOUy1NBo2vZcDIDuTCr1
	oaw074nYKbw3H5OI4tHWUJpdnWQ/Z0I4CuZFOD54MIYXrCPCL79G7M52u5jQYa13/vWy4z
	bp1yEpT46Erk7YFbIn7J0bxKs+Y5gHQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UDAbCJzb;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760648117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=I8i6tGQrPfrnRJOA/8H62CFFvRz1tXxW9tTyBQNOk7s=;
	b=UDAbCJzb/1jwuEs5UzKtLpyiQIcpqw5TL8xDiI9tADfnETY9b6hWkyAbReOYPN25GhzIlT
	6lK3HlgX3h1lOtvPHXHlZ4mFnwTer7VxvqPKjMn9MtAh0f0kYRi3BRjqIHXPbPAfPOUd9B
	xETDzu56fRXqk5OX7U9wbf9d+rkRY4U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-sy2dY3iKM1Wxa7E37q1BGQ-1; Thu, 16 Oct 2025 16:55:13 -0400
X-MC-Unique: sy2dY3iKM1Wxa7E37q1BGQ-1
X-Mimecast-MFC-AGG-ID: sy2dY3iKM1Wxa7E37q1BGQ_1760648113
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47113dcc15dso8066885e9.1
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 13:55:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760648112; x=1761252912;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I8i6tGQrPfrnRJOA/8H62CFFvRz1tXxW9tTyBQNOk7s=;
        b=v2btvoF6zFSCuUJjZOZ4MXb4tsTO7fPOgQAbCQxjRRDiE1GPArIKN/bFJTW1M4XaPL
         iVEkafcS+1+u8gSoknF1YihwVMMQVspa0bGNCb9VdGNyR1XcdQEOx8nzoxyiCGawcKjl
         x/xUyrDofR7HjZQEWTJpdCEa48gS1rU/M0DDVYDeOEsdenfumBzdr16cft7g4SEucuP/
         o626joiJSXJ5rZM1BDTvEm5sCcBItcGnFeQJ7uZXsTjFhdqx1nsU0ylKRoXkxwMoDdcz
         GXYbTOTQKuS3x3JfcO3fh6ZJ7Vek+cvJGxXBm6V/rm+t22kC7pFxC4klFlFQlFCT5xow
         +zVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpo4z7ebiwvOUiEzGp/2U8uP1ouHskxYM/X8g1820+iA2KdfrF43IGy4YEjmklgn9NxgtXG7XCRQ==@kvack.org
X-Gm-Message-State: AOJu0Yz9IgcUDxZ2Fv/7cG8xuLRULAXToMAM/ZQEhyincl30GMxB9Y3y
	+QqgFbsMrVEELrvXivzz7QVnDtoiwSBlHQLYpE/KxjWsFYcWUikHmBZT51gYgPcNCjh+OJcJALt
	GBmLpdC5Mi3cph11yxozb7sJhWJt3sUhm5hdUAlMZwxbNX+2Tvc8E
X-Gm-Gg: ASbGncuriGGosfC/KQbSxG5Apg/uOYsgGCZriL7fxB2N+ima869VyhxfjFOE4EL7qbw
	dmqHdPh3xjc4oq7Yy9IN+GeKs4q6UP+tKtmfRh73CVWgLHtiFYlzNWDHo/t8OvnXX7eEViRq68i
	DULgMhmJKMTBt96iMjbDfS/dcWll1pjPZu8T1Q5PGXb3v+8CbljMl2LsUH74T+NJM/UZPktEGcp
	zNFXDPjpTmdyxrO9ahl+2RS29GzLn9kJt2MjtmuTMOYX5YLbs7Ee5gQg2A5dOIo7K4dDWWbb9TS
	pnoYRCid0L/VVVw5nS7Fs+YpACKb4Xqiw/KaVwaMIGhEY0lDx/2/WG31CZFDhP9OK04j+HrMsVl
	Jfue2b2qMf8Pn3bnWrSs0eGDOlfT0XDexoBUHU5ssfflsfqxI6bETfxshvFylS8v/VFkOdjgM6K
	TvZYxDlWhAxojvikp12hqYReFtX5s=
X-Received: by 2002:a05:600c:524f:b0:46e:74cc:42b8 with SMTP id 5b1f17b1804b1-471178a6e99mr9053065e9.17.1760648112493;
        Thu, 16 Oct 2025 13:55:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH3b6mrA0sOT+GPWp3hF29bV8MKKlETyp6Wi9qV6E17wx6TeJQusn0h4fzjN7Nmfpftk2om7g==
X-Received: by 2002:a05:600c:524f:b0:46e:74cc:42b8 with SMTP id 5b1f17b1804b1-471178a6e99mr9052905e9.17.1760648112058;
        Thu, 16 Oct 2025 13:55:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144d17cdsm43843075e9.18.2025.10.16.13.55.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 13:55:11 -0700 (PDT)
Message-ID: <518dedb8-d379-47c3-a4c1-f4afc789f1b4@redhat.com>
Date: Thu, 16 Oct 2025 22:55:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2 2/2] mm/huge_memory: Optimize and simplify
 __split_unmapped_folio() logic
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
References: <20251016004613.514-1-richard.weiyang@gmail.com>
 <20251016004613.514-3-richard.weiyang@gmail.com>
 <99d5c245-3b0f-4b33-8d44-bc2b203a5a51@redhat.com>
 <BE1A9E45-A304-4A54-AA4A-C8ACF889262F@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <BE1A9E45-A304-4A54-AA4A-C8ACF889262F@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HtjcFoXyQOCFayaA5kCns7dqqs-bs--2SOiTa-xWMyU_1760648113
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 4uagsn33f9ywh69kyd79kdtgspje9wy1
X-Rspam-User: 
X-Rspamd-Queue-Id: 167F44000B
X-HE-Tag: 1760648117-749607
X-HE-Meta: U2FsdGVkX189B32w044X9SCVawnWjulOHYBfQ73q09KI0K9Cs/ziV2yV4UKQ83MZRs6HohATLDC7/r5jf5NGMjVwyxMZ0snc5OvWy/OHpVwGGvJwZ/Gcpftay+Gf4cqT3o0fw4ZD7m+iYb3IYXTdHYegfGYnG5HZkOHDQ4U1wuIR/H+OT8J1xr9bMnkZNhnCxupXshF7xWamsGOTzfYrgBEjfqPkYBvozQBeVB+T1VHr1SSqDZPsQ7S/z/z35xuvWFoG7ikzju0SN5k5dKcPf0RafM4KVlt5fe25BN0Q4RiblrtPonm0YuvnWineMJyp0nPDkmnyFO7F5tDaNUV6NqkZXA4fT+/o2svP6h1rMQ8EhytoTvaTY/jSINXil9xbrbcoM0/a7EAk7XqohXJvMErDA2753aTtBrcvoN7CgGg5QjhDCtuRhgSrCMUMmbwd9lSDY3GjqzLCwgQO/eIm1GAIpAIRQlESK1PMxgXtZ4g2OggQpbPWkjfoNm6kZnQK8zP3YItFXdIBP0jETzy1V3ANDyjPKWSM0HVjXM1XQHts7XuAebiKo3g8H1+boUAnzdrStZsoXxJGmHS5G+dMVO6Qsj/DSM/ACqbW5XV8rJ17UXz5F/1hedenvCYUEh66R0k8JbxRYl3+okTjEt5AarDrpmTqCO5mYmx/QxYiKk7W3UrDZmCB+T4AeSxdImRsokxrbw9Ps1LPJ7C0kUkdaOnM0uo+uhwjxqNw9OUapVulfKJRCnl6awJPYn2OOeLH56kh9TvLaNVGvCjfF+9Je27iNYOS2qT7F5ZvJBSgnmyUeYXZ6GD32q94FYNx9Goby8UUo4OyEFnRTI0GIe9BStVyMywUnncPoL+qv5ObTYN4WYvUyShheltrRhkVc5Uo17CPLZDQmaJV+Uv3F9SeI929YTnHIdaqKxFK/wqXSELpwLQdlqFOpX3D1WDRykREKGbcutrsi786Dw0eIlx
 jvEKQIEG
 LuersQN8js9yboCWyj/mADL3FzQtnNrxI2f3va0QxrcsiK3i3XQEQBnULyDSkqhTdaXqZpJ/PfKoSekPFACCO8HbnapMzm4/k+WO6TKOikLVCvPSeR2/ikUiX6nTe7JXPv7uTsrivdo0iAm4oACBOAS+9br8BLb5mopuTDo0LK8RT0sNkYHheIJ0Rhcb8VZvs4OIU6iX8tVrZ8QQBTmEUnlNzRJEwu9iFeY2HYMrXD+AMr8Kh1PuBh1z/pTuwgvkDQOzJj9KP/WgmaFrX2YDAnk2TZHg1HiSDxmMKjPI7tTeReU3kIEdyKdsnJ98WXjFishWuUu9wx75GboZ8im8aAaGbPXhWMfc3U+9IrOZDKAXHctXWfPmMR+QaqXuKLmoa/nO/lffX5+Vm2qHl3Lpskuz5YzpeKmquOrHc+jMyCc374xmQY5sGiXT+exvSh94Q0BHHMDyvfbieMZVaylKqpDgBje9zcMjCuRMlEKF2PGeDU7d1G0EN6RcJKrGu7cMdaiCrJmnNpP56F7cmZbyHSXhmplnTqukh7ZDJrgnDnJ5zWbVmkytk/bAiPuXd/nUrzeM5vkmpY4zjv4pRJB6N48Q79giAIQnq+0x+Gme88vFiwUhVhMB/QI3Pbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.10.25 22:22, Zi Yan wrote:
> On 16 Oct 2025, at 16:10, David Hildenbrand wrote:
> 
>> On 16.10.25 02:46, Wei Yang wrote:
>>> Existing __split_unmapped_folio() code splits the given folio and update
>>> stats, but it is complicated to understand.
>>>
>>> After simplification, __split_unmapped_folio() directly calculate and
>>
>> s/calculate/calculates/
>>
>>> update the folio statistics upon a successful split:
>>
>> s/update/updates/
>>
>>>
>>> * All resulting folios are @split_order.
>>>
>>> * The number of new folios are calculated directly from @old_order
>>>     and @split_order.
>>
>> That makes sense.
>>
>>>
>>> * The folio for the next split is identified as the one containing
>>>     @split_at.
>>>
>>
>> That as well.
>>
>>> * An xas_try_split() error is returned directly without worrying
>>>     about stats updates.
>>
>> Why is that change ok?
> 
> Before this, the code decreases 1 for the to-be-split folio before
> the split actually happens, so for a failed xas_try_split() the stats
> needs to be fixed up. Wei’s code updates stats after the split,
> removing the stats fixup for a xas_try_split() failure.

Ah, that was not immediately clear to me.

> 
> How about?
> 
> * Stats fixup is no longer needed for an xas_try_split() error,
> since originally stats was updated before an split happens.

... since we now update the stats only after a successful split.

?

> 
>>
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>>
>>> ---
>>> v2:
>>>     * merge patch 2-5
>>>     * retain start_order
>>>     * new_folios -> nr_new_folios
>>>     * add a comment at the end of the loop
>>> ---
>>>    mm/huge_memory.c | 66 ++++++++++++++----------------------------------
>>>    1 file changed, 19 insertions(+), 47 deletions(-)
>>
>> Skimmed over the rest and LGTM, but it's all a bit complicated to understand.
>>
>> Trusting on Zu Yan here :)
> 
> ;)

"Zi" of course :)

-- 
Cheers

David / dhildenb


