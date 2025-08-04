Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D578C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 19:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5C9E6B009D; Mon,  4 Aug 2025 15:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0C596B009E; Mon,  4 Aug 2025 15:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAD966B009F; Mon,  4 Aug 2025 15:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95A2B6B009D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:10:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 16C605BCE8
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:10:22 +0000 (UTC)
X-FDA: 83740015884.07.D9DA41A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9D24140010
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:10:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SchS10dZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754334619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QpzbDczQOWTEz8VKaqJRRztpG2xgJNR5kMd2gtLvEkQ=;
	b=F3z+dKNTjcweHLKn0DMmQj+j1UIef9oHoaQmo8RfY3+XQi8mjFkCWsueh7cz/HiHaKWgMu
	jCUZVsE4ubwoHNnPtsWOZm2QXhD6LqRS0Cpp34lTJTSM+qpkW/ptdGftYagmRQBfRkJcDZ
	i1886D+boRHWmtd3nOE6roWTOgk6UZc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754334619; a=rsa-sha256;
	cv=none;
	b=UzCRz6BNa1TxBfTt5USETqJlXwXSIY/OcFQst7WM1nhX000OYlm3tWWYV2mbfH6yj0cymz
	lsFDD8O6hLQzWWagD1wtUxofOKHAAkZI4FkktrSK/ua2p8R9J8nH6XafysgcREp2dMU29w
	yhUTR7HTJFrFzyqbcBBAWRK3CJkxuWE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SchS10dZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754334618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QpzbDczQOWTEz8VKaqJRRztpG2xgJNR5kMd2gtLvEkQ=;
	b=SchS10dZWyk9mIGoptO30fd1C2fmiUYv62Z7y2JUSwQWGlqFrWA6ez/XqBUC9YQulCS25z
	hPna8G0gGPzWWNekSnFLQyObfMQWwmngkjYKEb2fkH/xPvCgi9/sO9XfXCQH5Cp/we2eBC
	v4c/LTOl19ZWIHZJzxSzUMqsbcr9NyE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-VreNmGWZOtGgkX0InYJw2w-1; Mon, 04 Aug 2025 15:10:17 -0400
X-MC-Unique: VreNmGWZOtGgkX0InYJw2w-1
X-Mimecast-MFC-AGG-ID: VreNmGWZOtGgkX0InYJw2w_1754334616
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45526e19f43so11885965e9.3
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 12:10:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754334616; x=1754939416;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QpzbDczQOWTEz8VKaqJRRztpG2xgJNR5kMd2gtLvEkQ=;
        b=iOtXtW6U/KvMeqetE+ArCyqWsfaw5H3BZKaLYoQa+IuiUaBOPXOq86WaCZAfBVPciY
         SwXR7kIrHY55CUpEhWKTXQRDMjk0sUUbyr8HYhbtEiKAzr/3IjUQlBhxpgRpLT52G5hg
         Tmo7DLJ9UT8sA87oOyP8MebeX+vnsKTDnhnJhQUl2p3sh6Yu8QBfz9+5XqV3UVfV5JwI
         6n4aK35GQjGJQHK7wFtlzVgpQVuf1Uc5JiCdrRROCQwJKHXP0bIFrX4qxiKj+kqM65JD
         ebqQnsqYbhk9Uqg3n5NM8QbacHrldWJ3D01Yd2iKdcUp0A7gfxkAcQ5vB6+cxBOy+sJo
         JIzA==
X-Forwarded-Encrypted: i=1; AJvYcCV+8lzl/VBtqF7CuPwbv0k9SdNibrhjxsW2efwQ5NU2AHncu7FmetduTRaM3D03zySPh5ykQ6VCAA==@kvack.org
X-Gm-Message-State: AOJu0Ywz8hrkXlFkcro1Xjk4WDm4BesPvnyza2Slk4ftrUQSh3scI4Mz
	VKUXQkVP3A84PE0zZ8qDIv4+CzL9mkSuONY5DH9tC/JbvZQzSJ4YMpk7yd1sO2IA25Zf+EKF0cE
	ezKSMdLPZW6M+BQEPrUOBIEcj1PnJarntI5gTpFteHDUKAzpKWAQT
X-Gm-Gg: ASbGncspk6ndqlX24UK7rF8LS48b2HrJFIgIEA91r1xQZo51b+FDIwsJaRFZXxEwh73
	exsftf/uh6Poc7H+SrRBjiSuna6pUh4w1vTL9yTntL8EWiGVUoM9RFR26YdDnKWMemENlIcP70f
	TxO9Vc85WIBXFlmTirg0PwWtecWvTSMX8SRwcHFKkVIpBjpP72JZwAiUMit5ZDnw/QD7laZsxc1
	cUCTuMg0aNn6IouqYfbUtv84wJ0sYLH4s0Z0F5Z02qUps5FIij3PFP+2QZyQBiQsbW/ooGoZ+4D
	oHDTD4EdwDFL89Py7zBTOJFAYg0zuC9ZwroAA/sfN0WV6Qspu4CneKXNKo9E/GoceSsaZ968oOA
	+Ly1c7fR2LCKWfpIEWQJGi4u0xdKRWdUFR39DaOLh5ZvculdeDBMdWn6oQy78FBjDBs4=
X-Received: by 2002:a05:600c:3ba5:b0:459:d616:25c5 with SMTP id 5b1f17b1804b1-459d6162762mr52351765e9.12.1754334616356;
        Mon, 04 Aug 2025 12:10:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGqKOc0puZuFe2BKSfXuUO51+TKPaxeerEzpJWBflJeShfRYpvNjoQBexxKd7V/4fPDOXF5Ng==
X-Received: by 2002:a05:600c:3ba5:b0:459:d616:25c5 with SMTP id 5b1f17b1804b1-459d6162762mr52351565e9.12.1754334615920;
        Mon, 04 Aug 2025 12:10:15 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9? (p200300d82f0e2c00d6bb8859fbbcb8a9.dip0.t-ipconnect.de. [2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459c58ececdsm45294775e9.1.2025.08.04.12.10.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 12:10:15 -0700 (PDT)
Message-ID: <5bf65002-8d2f-4b9b-8f22-3ba69124335c@redhat.com>
Date: Mon, 4 Aug 2025 21:10:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
To: Zi Yan <ziy@nvidia.com>
Cc: Juan Yescas <jyescas@google.com>, akash.tyagi@mediatek.com,
 Andrew Morton <akpm@linux-foundation.org>,
 angelogioacchino.delregno@collabora.com, hannes@cmpxchg.org,
 Brendan Jackman <jackmanb@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
 Linux Memory Management List <linux-mm@kvack.org>, matthias.bgg@gmail.com,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, wsd_upstream@mediatek.com,
 Kalesh Singh <kaleshsingh@google.com>, "T.J. Mercier"
 <tjmercier@google.com>, Isaac Manjarres <isaacmanjarres@google.com>
References: <CAJDx_rgzkZognxWzOXJ-ZxdTtUaM3FT6bmpkwxMz03XiX3fKAQ@mail.gmail.com>
 <d395b14a-9a84-4f25-b4f0-45e8500fc5fe@redhat.com>
 <8A3D2D44-DCE9-48FC-A684-C43006B3912F@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <8A3D2D44-DCE9-48FC-A684-C43006B3912F@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: p7p4f5D4wJi9QAR8pXGVb_be--FgPeh7HU7uwQkGXIw_1754334616
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q9dtwfwzt457gx5me8j9bb5erjp916u6
X-Rspamd-Queue-Id: 9D24140010
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754334619-795728
X-HE-Meta: U2FsdGVkX1/QFoOiV0XU5fSN+Vq9Eq1T+Bf3ACaI+NIhVwLix5mNaxgpn8+dWjj1wFHW3BZbbgIb2fuU571IT67736RHhvZ1tjtRQKYyqba6roQ6/ulaZfQrTvDEIPO55bO1M3UmWf0kfHGJoMiMvYhoGum75ODLw5io38jmoYsPxXYybas1ZtZsCC3o7xfrNm1QvU2QzlEx7+0SynXsh1AOpUXXllZn+h/d1zEc7HwQ7UPh+naIPfPSfKwp7PeOaSavu6PBa8g6w6EGctrageHzV1XK2vAKZr3jVb3AtPTPvk55FdFWfUId0fQUECUfeqg8wF8bP4vm0/e1SACfBAx6H0eQGA8/5tm+mnS3cKdlNrHg6QOH7SA8a5eR3kwI64rZFisCfKeB8ZtX+DQoU/NzIdZZBFjUL2V2MoivTR+aTV5Lc7g2XVjU88CaL4wpm9N+w4tD+q4jVbp68jLyFoqT3FOx6hm+tg3+M3U3b2tkhHsGIIAvxNky+G7DnH62kHGFzd5JYN8EYEdYbiE+WPoBrA/4fgSrAoq4qb+G/aQhtoEBJH/BNt7lXbLflHxQ96Cz1fBWaJWd1uCsUoeKYixn1X1iytgAOkiHOIM8Fttx8BygXi3lKXuVVyzoUHKVSSSXcfnDjxGmbnqHzsYomWczeDfXs8VUEzgX5MXR1q3HD4CThjMLsGwuOkLc7S6Kv9JInzj0gpf7GMFVjkLocZRw2pPV3sApCr7dHFo/m/iQFxz2xQfAAC1ewoakJDBpTfOpZeb+mDipDYJDYXD91PskSBbwA1HY/77hJVj5JNKmlPUlzbq1+1voToZey9hkd4wQig2JXC+gVwIUjP/v7DgoQulvtE5+uq9LF4VL2RHvz4BROVU5oy6c4viGS/6xmNW0DLt/OK7kslExVGlT275PKogb4EYlk7k0VtXb2tGCnnhsPtlmzv8CAHdffZsHZiGuQP+YlJXCeZGgBdu
 tDJhc+9c
 x6EDwylzwYCt/Nom5cMDEqvBKrH0l/hadRpd6qlukNs/WzPRvy3BYjZKnPhzx+CTqhewauVv3srTHPxFJe5gBUe1H7k6NhRyZvLxvMp8+r/7LulmK+WnOwO7DiywLzuGduSwlmk2YBIJzC0iaa2HS7tPfN3TEvwjOAA5ZflMCXt/3C6gfuqxcKRaZSzpHB9MtUAWH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.08.25 21:00, Zi Yan wrote:
> On 4 Aug 2025, at 14:49, David Hildenbrand wrote:
> 
>> On 04.08.25 20:20, Juan Yescas wrote:
>>> Hi David/Zi,
>>>
>>> Is there any reason why the MIGRATE_CMA pages are not in the PCP lists?
>>>
>>> There are many devices that need fast allocation of MIGRATE_CMA pages,
>>> and they have to get them from the buddy allocator, which is a bit
>>> slower in comparison to the PCP lists.
>>>
>>> We also have cases where the MIGRATE_CMA memory requirements are big.
>>> For example, GPUs need MIGRATE_CMA memory in the ranges of 30MiB to 500MiBs.
>>> These cases would benefit if we have THPs for CMAs.
>>>
>>> Could we add the support for MIGRATE_CMA pages on the PCP and THP lists?
>>
>> Remember how CMA memory is used:
>>
>> The owner allocates it through cma_alloc() and friends, where the CMA allocator will try allocating *specific physical memory regions* using alloc_contig_range(). It doesn't just go ahead and pick a random CMA page from the buddy (or PCP) lists. Doesn't work (just imagine having different CMA areas etc).
> 
> Yeah, unless some code is relying on gfp_to_alloc_flags_cma() to get ALLOC_CMA
> to try to get CMA pages from buddy.

Right, but that's just for internal purposes IIUC, to grab pages from 
the CMA lists when serving movable allocations.

> 
>>
>> Anybody else is free to use CMA pages for MOVABLE allocations. So we treat them as being MOVABLE on the PCP.
>>
>> Having a separate CMA PCP list doesn't solve or speedup anything, really.
> 
> It can be slower when small CMA pages are on PCP lists and large CMA pages
> cannot be allocated, one needs to drain PCP lists. This assumes the code is
> trying to get CMA pages from buddy, which is not how CMA memory is designed
> to be used like David mentioned above.

Right. And alloc_contig_range_noprof() already does a 
drain_all_pages(cc.zone).

-- 
Cheers,

David / dhildenb


