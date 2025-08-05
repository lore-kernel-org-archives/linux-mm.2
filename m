Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FEBC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 21:08:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C2878E000A; Tue,  5 Aug 2025 17:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 799CE8E0001; Tue,  5 Aug 2025 17:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AF8D8E000A; Tue,  5 Aug 2025 17:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5EB5A8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:08:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DEB0F1A024D
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 21:08:57 +0000 (UTC)
X-FDA: 83743943514.14.A75F9CC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 584AC1C0006
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 21:08:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eJftTIhQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754428135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/eL0tC2humxAnE4NSMATRiPYyHhDovlDD4H4yRhz90=;
	b=8fU2HKckDG95DO1ZCrd6L9oLwRKeb0jn22KP+yCBdjqBINdMe+BGqVXhdsz/K3Sibwv/CN
	bvmPGZYtWXgE6dnlX7v7JgGiPLLAsWjKOmAF1ctGIsizSp4uOs55YlXNi2UrZ2uYE4ho5j
	kY9jdNMqkYCPVB2eO2TolCefg6thkgc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754428135; a=rsa-sha256;
	cv=none;
	b=pZmikk8jPYEPhcvMQtDhB1D7LvfM1ZTCrfZf5m1Z/WNKizQpyOs8CdKeKiBGXr4ADc3ajV
	XJmt6SkGAJ8Y9tP08eEQq1zatPCjoEwbb2UmBsCifx6uTI1B/Zuul13MxZTOYy96tW8PZX
	EV9HWThUlDaklK54KjMqFjyjL53tyEo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eJftTIhQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754428134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=u/eL0tC2humxAnE4NSMATRiPYyHhDovlDD4H4yRhz90=;
	b=eJftTIhQdN7ZygWDDyAMQ4AtmcFi5WayHZO9nGZ//UMl5U/F6wo/2MC3zWZWTcbrhQcTaz
	+3Jx2oOScLQYyzKLLawd67QI/WOv7Gk0VbyNbPbgFrA1mSYuQDJFfmm7wzDTgAEmWgm7sr
	uVN0ep44ulXyeHg3j+WxN+BcOP8ylME=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-7bm8TbCAMzKDt2Xqxk84sA-1; Tue, 05 Aug 2025 17:08:51 -0400
X-MC-Unique: 7bm8TbCAMzKDt2Xqxk84sA-1
X-Mimecast-MFC-AGG-ID: 7bm8TbCAMzKDt2Xqxk84sA_1754428130
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-459de8f00cfso8246225e9.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 14:08:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754428130; x=1755032930;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=u/eL0tC2humxAnE4NSMATRiPYyHhDovlDD4H4yRhz90=;
        b=TzCMBsSZxdRMqmRsWX7q7EAi0rZr5xg2z4P838PC9NH5yK1eVSUHQWyhUIw3LrT17C
         eK8zfuip6uuHX2osIVgoH4oRHSiuwFpKTMp/enM3h2rV7e76FqDoSL8ixNchagCOvddz
         GaxL8ZpzIaI8SFmKruhQQw0AX3oUMZ8Tozda4H6VoSBXkRKSkOhHvXQLGjd2vJVva5oa
         2Lxu3ZDoRsYCQxZ52HdELtYktEIkfnrlAWLgcYnPVHyZxlwRTSRejLLcZAT6+9QEueEW
         PO+5o2mXPaYLB8VCREMXLbFMhtrQDaANYjDc6U4RLwm9xCX72vOpYmWMf1ax5eDNnYUk
         IzJw==
X-Forwarded-Encrypted: i=1; AJvYcCVOojfVLxmbJOFfgvqOmNnIn/NydysRkdQcPg1eAZ5FDbMX5L7A9FEL2nWp3thX75aCfW4tzTl7pw==@kvack.org
X-Gm-Message-State: AOJu0YzUmNsalku5oxk7org4kjSIifdBZ9ALKDbMR03hVUmTgWaA+d5C
	KfQSiSLmt8J/aHQ7NlrrMgIctjzUkPcdp6x7aOMCR9p5KJAnDdDrRtjK24aSYFIGmOet1Qe1CMO
	VTbv/0hHo4Rji86fy/fOu8QxREGRQfLCdgjW/Bdpu5g4TQnklufYV
X-Gm-Gg: ASbGnctG2slwsXApXsFqX0Ez+N1tvJB4vXvFWq7hQg4Cqxd8VFjq9EGegpbCLiEt3x2
	RZWm6PlNagUoVWXvrco2tTiPEBuKNX1uEXmLHV4mbXKVu4RBPoM9bCK7cJb+mIvLBelMRt5MKPt
	UDw5nTufN2hILQneFv1zwD6ZW93JYOoEkATyk8l2vBYUXCJxk6D2Cqnrob2MTUnl58arUgnLSld
	qOJlg9X3GyBfrW0Y9SXWWn4wZHy8C8nKODnEBjVd3vzIY99svFJaQvJ6u5QeVLCVw2iiJFAOaZQ
	xqCp6IizGk3uShHXEuE0/scPGs+Gr/Z+Nfyd+3WZgGKLGbiJNGNufs5to3Sc9/nw0YlaOwfEP1z
	YEYTsQs+A4h4Kv8HMZ64YjbyWtP+RxdFl3EIkOryviSSXo+fcOsRQFflyD/71urqYi4Y=
X-Received: by 2002:a05:600c:4fd5:b0:456:26a1:a0c1 with SMTP id 5b1f17b1804b1-459e70eeb5cmr2928215e9.17.1754428130184;
        Tue, 05 Aug 2025 14:08:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFcSYv4Sqy94KAApt5uEeACzubGuEsOE55mxZ7I9ESflZEKKHfxakUYforoYyFFXqPR+btRNg==
X-Received: by 2002:a05:600c:4fd5:b0:456:26a1:a0c1 with SMTP id 5b1f17b1804b1-459e70eeb5cmr2928115e9.17.1754428129737;
        Tue, 05 Aug 2025 14:08:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4b:5100:3004:3864:4049:722e? (p200300d82f4b5100300438644049722e.dip0.t-ipconnect.de. [2003:d8:2f4b:5100:3004:3864:4049:722e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e5879d76sm20391725e9.24.2025.08.05.14.08.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 14:08:49 -0700 (PDT)
Message-ID: <6dee6cd9-c67f-480f-b728-21c3a7b72004@redhat.com>
Date: Tue, 5 Aug 2025 23:08:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
To: Juan Yescas <jyescas@google.com>
Cc: akash.tyagi@mediatek.com, Andrew Morton <akpm@linux-foundation.org>,
 angelogioacchino.delregno@collabora.com, hannes@cmpxchg.org,
 Brendan Jackman <jackmanb@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
 Linux Memory Management List <linux-mm@kvack.org>, matthias.bgg@gmail.com,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, wsd_upstream@mediatek.com,
 Zi Yan <ziy@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>,
 "T.J. Mercier" <tjmercier@google.com>,
 Isaac Manjarres <isaacmanjarres@google.com>
References: <CAJDx_rgzkZognxWzOXJ-ZxdTtUaM3FT6bmpkwxMz03XiX3fKAQ@mail.gmail.com>
 <d395b14a-9a84-4f25-b4f0-45e8500fc5fe@redhat.com>
 <CAJDx_rgrp1TpOt-iDcsSGRTL=qZZsK_dpKL1bSkyunPGcGXt5g@mail.gmail.com>
 <486c5773-c7fa-4e19-b429-90823ed2f7d5@redhat.com>
 <CAJDx_ri==3SxFcuKXHpNjrtxbp0hLyhM+zXeJ-LQX38rfbUChw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <CAJDx_ri==3SxFcuKXHpNjrtxbp0hLyhM+zXeJ-LQX38rfbUChw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qFuL-2hh2fZmWK7HQVCW3RTOZeidmtPRsNqkaZK0x3E_1754428130
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nmtez68z1qd1d5r7h3gufigqhaxedhs3
X-Rspamd-Queue-Id: 584AC1C0006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754428135-909996
X-HE-Meta: U2FsdGVkX1+Ry0lWgoiGQYQfU023ctVihnYppryz4nySUQGrJM2ZO1PmYRQQo7EIW7Djf5KWqErwnlLyZyXv6JN4tPoCHvzMcmE9+rHqk7yUKJLD0IuCpioj7LlytpJA+Ngd48ZWo5b/sWDkc0PmosgF2RCZqB3IfgojHfX9/Ga3SARFAcdxjzt90bg2BrlNq2gdxTQaso+9BoLNGL3lTStTtEB96HvYxfUgulWzY1SMARekz8k47j/QZQ1qVANMQh7OzXcI5OEq+/MY8klCp3BCTTHbCs+kZAry/euVNPEuhsHhtC/3IE+QsGE3oOshWRfgtbyv9B1EleJ2gYRplRM9DYPa5c1wNbkRX0a7f2gnP0I5LrH8+R8vsN30Uc2ckis9ejF1G2SVRrPB225GHpV24R88MPUO6byfV+zAwdsN+S3tqMGJix5mdmxFF7vpEqPii3z+TTXq6+2cwiDYZtloe9y/2wD1AqpCHKpCEGQkNNwEolA0cuOfJ8r/noqFRjCYtc3ZqkSlH6eJeB9tic5O/ve14VhqIZmnvP+Llal0zuutRIjz+IJGoqXp1kOXQbdRcVbF+0qkZ9CSjwiBSgqT371sYbhpniBGJfwLgfbtKO4DLd6utuwVEisSxUxS3QkOxqWpHoEhwI+q7/4sDjXrgPsWcNwD7afm0lfFn9lY8vD5+rhxaQWbBSH4SpCaiylGtGMg6dFqg6tLEoydqidG/RDRYyqBJFXO2dI5+mEn80s1gmKlIZ9moNaR3VQiyb5b2q40Y/dg5AJXkwPa8WARsJuR0gWKCyYSpqav+d8Bu7PHJyJLabEqEbKFWZ27KiEmMAFOkfMhJcAmUATcFg+T3FtGsGqoKyOb6n0NYtu8HbdBs8aO3uxmieLtX7r1i414xe1ezsqak54aXlkB2H91Is2Wpyc8mNX33oU8SJA3y3kCDvnSrt5hosQIvMmZr1RePSyGBElM7NgsiNW
 hpWnQBi3
 GSrBne9Xs2zFT/AguJ2x7qeI1yg5THwsrOKnWGJKeKb2EuP4UGbaOEsCU8r2dLIltBdItzok9l5gd78n6whE6Iox4BF6nvAR3ZztPo0IrzPwHKRcFss+fnYE31Wx3rj4mO88JmjjINwpqXpB4RgTihm2xzND4+083INunLI9wfKHcJjd6klUL5R2aCeofItjuS7ctwJq8et923QtiVTDRJ7KISGwX45SxoogiQO/Hj7utAF4a0sTCVqW3sI9FKRjlvRNnQ6wsIwne8dL9lNQfhyj4qrItvsdaQcxPMurC538MevjuMjhpzl7USJIaBOSPkXVJN5q7WpLL7LT/xPhw+sXC8Tt23Ti0RvmQRlti1iRfXajW8k7ziKv+CO+d3tLeSpG+wX71Vm1tVi6yfSClqewXTSiiO8DirCb5FpltsLHk1P1t2WfAohJK+GCCBdsflF9D752p5ho5wz/0oew0JqnntTX1cYEFf3sdFIwSrar5P3/vt26ChtD8uDE/c+0vaABSTKydxrLZCqlLz73nMJ/oFuA0oi3sXwyOPmJE+zoP8NSfTkVKhkiHFECan09gjXf07OTA/UxHTnJkP9hs/h+EK9mifz4FRfNWJGoQvKsyI2Jh10nGvBAojPVWQGPGl49VV/T+RAC9wH9+HKWc1jhKvtss2fufCr5QDPyXiyA11tQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.08.25 18:57, Juan Yescas wrote:
> On Tue, Aug 5, 2025 at 2:58 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 05.08.25 03:22, Juan Yescas wrote:
>>> On Mon, Aug 4, 2025 at 11:50 AM David Hildenbrand <david@redhat.com> wrote:
>>>>
>>>> On 04.08.25 20:20, Juan Yescas wrote:
>>>>> Hi David/Zi,
>>>>>
>>>>> Is there any reason why the MIGRATE_CMA pages are not in the PCP lists?
>>>>>
>>>>> There are many devices that need fast allocation of MIGRATE_CMA pages,
>>>>> and they have to get them from the buddy allocator, which is a bit
>>>>> slower in comparison to the PCP lists.
>>>>>
>>>>> We also have cases where the MIGRATE_CMA memory requirements are big.
>>>>> For example, GPUs need MIGRATE_CMA memory in the ranges of 30MiB to 500MiBs.
>>>>> These cases would benefit if we have THPs for CMAs.
>>>>>
>>>>> Could we add the support for MIGRATE_CMA pages on the PCP and THP lists?
>>>>
>>>> Remember how CMA memory is used:
>>>>
>>>> The owner allocates it through cma_alloc() and friends, where the CMA
>>>> allocator will try allocating *specific physical memory regions* using
>>>> alloc_contig_range(). It doesn't just go ahead and pick a random CMA
>>>> page from the buddy (or PCP) lists. Doesn't work (just imagine having
>>>> different CMA areas etc).
>>>>
>>>> Anybody else is free to use CMA pages for MOVABLE allocations. So we
>>>> treat them as being MOVABLE on the PCP.
>>>>
>>>> Having a separate CMA PCP list doesn't solve or speedup anything, really.
>>>>
>>>
>>> Thanks David for the quick overview.
>>>
>>>> I still have no clue what this patch here tried to solve: it doesn't
>>>> make any sense.
>>>>
>>>
>>> The story started with this out of tree patch that is part of Android.
>>>
>>> https://lore.kernel.org/lkml/cover.1604282969.git.cgoldswo@codeaurora.org/T/#u
>>>
>>> This patch introduced the __GFP_CMA flag that allocates pages from
>>> MIGRATE_MOVABLE
>>> or MIGRATE_CMA. What it happens then, it is that the MIGRATE_MOVABLE
>>> pages in the
>>> PCP lists were consumed pretty fast. To solve this issue, the PCP
>>> MIGRATE_CMA list was added.
>>> This list is initialized by rmqueue_bulk() when it is empty. That's
>>> how we end up with the PCP MIGRATE_CMA list
>>> in Android. In addition to this, the THP list for MIGRATE_MOVABLE was
>>> allowed to contain
>>> MIGRATE_CMA pages. This is causing THP MIGRATE_CMA pages to be used
>>> for THP MIGRATE_MOVABLE
>>> making later allocations from THP MIGRATE_CMA to fail.
>>
>> Okay, so this patch here really is not suitable for the upstream kernel
>> as is. It's purely targeted at the OOT Android patch.
>>
> Right, it is a temporary solution for the pinned MIGRATE_CMA pages.
> 
>>>
>>> These workarounds are mainly because we need to solve this issue upstream:
>>>
>>> - When devices reserve big blocks of MIGRATE_CMA pages, the
>>> underutilized MIGRATE_CMA
>>> can fall back to MIGRATE_MOVABLE and these pages can be pinned, so if
>>> we require MIGRATE_CMA
>>> pages, the allocations might fail.
>>>
>>> I remember that you presented the problem in LPC. Were you able to
>>> make some progress on that?
>>
>> There is the problem of CMA pages getting allocated by someone for a
>> MOVABLE allocation, to then short-term pin it for DMA. Long-term
>> pinnings are disallowed (we just recently fixed a bug where we
>> accidentally allowed it).
>>
> Nice, it is great the issue got caught and fixed upstream :)
> 
>> One concern is that a steady stream of short-term pinnings can turn such
>> pages unmovable. We discussed ideas on how to handle that, but there is
>> no solution upstream yet.
> 
> Are there any plans to continue the discussion? Is it in the priority
> list?

Ohh, it's somewheeeeeere on the todo list :)

Do you (or one of your colleagues) have capacity to work on that? One 
idea was to flag folios as "pending on migration" and disallow any 
further short-term pins until migration is done. IIRC, there were other 
ideas (e.g., isolated pageblock).

> Maybe
> a topic we can discuss in LPC Japan?

Sounds good, feel free to propose this as a topic. I wills end out the 
announcement of the MM MC probably next week.

-- 
Cheers,

David / dhildenb


