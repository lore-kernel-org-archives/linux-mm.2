Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB310CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 18:09:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA9A4801A5; Tue, 28 Oct 2025 14:08:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A80E780199; Tue, 28 Oct 2025 14:08:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 921E3801A5; Tue, 28 Oct 2025 14:08:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EB6E80199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:08:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CCB313B38F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:08:49 +0000 (UTC)
X-FDA: 84048308778.21.922C8A0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 485914000C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:08:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SPItGr89;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761674926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBqhGMpkBgXLCeSNj2J5u4xC14JwlF+KRKG8Dy0pN44=;
	b=wGQzjVp8SIIrmSN7A8BzgZuRklX3PMWWap7VwlGXxw6l5a7R5q5XyhxFzwye43w6kIu0pF
	hdj+aFsv7MzDAHz/xuBWRuYkS3g/+iyTDZ5qGsC5oJyCvCfAwjBmDn4Uo2Vc/LXh8Sy3ao
	CsoAzFJDG6M0zr/Km6ZOFLGamq52Kvs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SPItGr89;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761674926; a=rsa-sha256;
	cv=none;
	b=NFBMT2RyyFPelLtgR1Nt4BaJcmkR4Se2PirvIGtjowSBnNiX2gurVDUCQJP+os+gD/w1nQ
	gHcKOQKMGaMQj/1glqa13ICi078nN1MNlIHSEUERhA9YPFoV1VnqeUpu8w4F7ivSOPpRlR
	v4hJbUCQYiKQAai72gmo6iHoiGlRNqc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761674925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pBqhGMpkBgXLCeSNj2J5u4xC14JwlF+KRKG8Dy0pN44=;
	b=SPItGr89eD31R0MOurXf2A7RWc/iydNbqAHYYfHSu/ADvErckyokRucz+r/hlq+2cKWCZ8
	WxTFwLWvpaKU/p0KNrJMAgRkjwX/cxJGkmMBVO+oh6eECazzvX0i8/Xm7GQb6t5bYORLL1
	BDoP0otxOsU53rQE2ycaTogmr0WbgsI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-228-SR418LeJNRW3PHURDNqS6Q-1; Tue, 28 Oct 2025 14:08:44 -0400
X-MC-Unique: SR418LeJNRW3PHURDNqS6Q-1
X-Mimecast-MFC-AGG-ID: SR418LeJNRW3PHURDNqS6Q_1761674923
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47111dc7c5dso878945e9.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 11:08:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761674923; x=1762279723;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pBqhGMpkBgXLCeSNj2J5u4xC14JwlF+KRKG8Dy0pN44=;
        b=vwKziKi50KKSziYskGD2fSsDWyuswPuTjNlKnpsabzp/Yh5S+R36QqLAi0zaN2o3N8
         TNrJKSSl044AXomZ1+bYOS7qgP1KTlrmtDu0Ce3YK4zYG3PuVJiShejlxRaIBEuKwpuT
         QE7B9V3zm2npB2dGumBktYUVUqRgKEtZYzOYKu41wB46kCNDGWDN/zJtLhju5IRGo4UL
         Q3zcmTOQ5nCHBsdNrUxnN1dPdb8wllg0QB7ovqMKKMktBOfIagNadwObWStbcKDAaIpi
         0FyWix44oNc0sPpEqVhCWHY7T1NF8abfA+nHlzcI/V7BvAPmvh+bscctnJp76s3G8YTh
         xlsw==
X-Forwarded-Encrypted: i=1; AJvYcCWRYHQdmCiqD/Sy4YMYquSyEq5N2OOWcXyeAzv0rXwcFgwDZJDx+X3HnX/dbzxdzOrSerSPiXYh4g==@kvack.org
X-Gm-Message-State: AOJu0YzlZnBgVkGwAT0BkVxP69l5RL0hmylgvhEO/xw8YxByaa+7p/Av
	YNBvGDLxnSPMzuxUw05sBhAICSAVt7Y6f2g6zzN5jVT6jcba1m1luteP2SF/cPgS5U7WyzLn1aq
	c6yVmjU3vhKdvIwJqC4fLKVheJmooq88wTCuPn8AZnrKNPYCXZf2QHkjc2bSY
X-Gm-Gg: ASbGnctw2iNv5lZAdjOH7vOOucGoM9zouOm7VdxbdEqumj8HxR/AgHlHZH4h8DfNKIG
	/60TraywOwpSwVAmOErE4YNyn+QjGW+uXYe6hDdTd/qyIwKSLZZs9vMl8NKAodrn+3+dkNbOfPN
	YLYq5Lde2/SvxNT2htqSxToqP41ESybTw5A1oKbMx2jXChJ6TRYWDQTN7AeKzNkBEKnf07o1WGI
	cVpNP2PJhOfcksHdOrWQ1VzMM6kDrIO/oL8FVY1+x1EmYBMY47jKYDdJvWqvgHMbIIfMerBIHMX
	KO6uXkJVk66lJjUlIeJNKL3B8hdy4b9mbSThiXHbjmab/Cvft7HtTAxPvfK8U8r+/3+bF+tBxB+
	zzE53Aaz4e8K6zqQqsMdATSgLuf3MsFkusa1TQwc=
X-Received: by 2002:a05:600d:834a:b0:475:f16f:6e10 with SMTP id 5b1f17b1804b1-4771e851587mr396945e9.18.1761674923061;
        Tue, 28 Oct 2025 11:08:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFCrpjgKDo5yTymBdfrcUO58K/LAOUrhDUrhh/kPmj0YlBGWfe50Y1oWbofPkyyJUC+7QTyQQ==
X-Received: by 2002:a05:600d:834a:b0:475:f16f:6e10 with SMTP id 5b1f17b1804b1-4771e851587mr396505e9.18.1761674922574;
        Tue, 28 Oct 2025 11:08:42 -0700 (PDT)
Received: from [192.168.200.155] (host-80-81-2-50.customer.m-online.net. [80.81.2.50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4771e3a8209sm3460265e9.11.2025.10.28.11.08.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 11:08:42 -0700 (PDT)
Message-ID: <74583699-bd9e-496c-904c-ce6a8e1b42d9@redhat.com>
Date: Tue, 28 Oct 2025 19:08:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com,
 raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
 tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
 cl@gentwo.org, jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
 <CAA1CXcA4AcHrw18JfAoVygRgUZW3EzsN6RPZVrC=OJwSNu_9HA@mail.gmail.com>
 <e69acbc5-0824-4b07-8744-8d5145e2580b@redhat.com>
 <e66b671f-c6df-48c1-8045-903631a8eb85@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <e66b671f-c6df-48c1-8045-903631a8eb85@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8wDXAbusl2b1DdB8QADDtM7JTrnzqb5ZqEWaJ3oLIfY_1761674923
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: to94w7j5o3xq8j9hgdh88655swyproey
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 485914000C
X-HE-Tag: 1761674926-681110
X-HE-Meta: U2FsdGVkX1/Yqm1BP/j4WjHQyvdE0dLYSQFfk/KNRkVJrOzm+yuJNsG53hQM8O+XGqYl6YMrT0Rk4D0er4V4P6aF6ze5ETrvyyocxVycmozNETEAVvOCq+CJ97ss1hFLexIQ/sLMNw0Yq5lZOovE70fmpJ1jV25MIH2lxYawX3wBoibgn1Yhe9im1spP8kyBB16FByvk5hhP2lPnKjJecimblV/Ruh/8BHLPiTG9JFnrCj5KH3laIHulcEv5BKQZtdL4W/idNDrd/be2mmZ/UAJ1pBwr5mTB3UE4jesDiJjbay19za8IC0wdR/R68V8VuPrXFdK8S4Jw+wobMdmyyzK+eIYRv5zwa8e5mQpPFxbZBR7sE6RpTds7eRfFU8sbO6o2N62x9sELaa5C8lQMhitU7P84hHU/8PREKfG9ZVq4J0vPU9FOBbJ9h7ugksEoE+R4K3A+PY4qnWB2YoG1Hx0qi4qhKfVy+fIkEpHfnc1D75rGs6FpNIaNMXdYIwYjv7BJY9ukcoeCxa2s096yJ8WFzY7MSZ4cZ8f4Av2kGhGmSX+kiOKU3JCF2qJ/mBtlsp5UaT2B2RZpfwaHlRCFjgkXaGKqOA7jCwefcOjrz8FYcZ2JIXahRszuIj8HCNrDXYzpFu3Gd2U8Jd4LyDZoNHxNlz4qR7ejOmosJgQtYHZ2H6TpNisEhGzALnvGMc/8ZczAzxqg9VevJ02n0I6bJHxsoYM/hb/daJfGBDFkHI/P02NM3+SqZhREwivrqYwDqimROVbF4GCpGVrhLb8VS01/0dD1Q3D7v8jyVPUwZ4QXzK7ukVnAmedxG8R1FAw90bDtaCY7QSG3T0UNLPE5vKAYZD3xMRtDk/qug8YmfFlnQn8bs2MH2Tn75H1+NhUvK6S6xDbDbIth8f2yuUsBDA3QXGHQdZTiRB4c9JJqlC7v+1Jddf1urD2/UUoL3ink5bet9frjf1+//ceQ3og
 9o6BJBZW
 yd40mxG2ccnY2s+DyNzCMfJjGEP0H/t7VAbxhLtPeBz8ngX0v/WXBK16KSzcGgzJdHyJRqwmY0x0JBIb/IhqVeXBEQ8Bvvck8Gsxr58Q3XZjchYuFCtXF1FU+c8YhAyAZO/LpTP9acwOQA9CrSZT6LkUvUmeuGulCCafmDfGI0QqEVy/HcXqD1EEweQro6w1PlkBKYCRl0OiMm0Zv6Gg0dyRqd0uXPBf34+Ym5MwXS9Eepr4rNCP6Nfu/odajFwyq/cuJv+qPRmq6N2QVTZomyis/SqkuKfJT194uqMjdQMQvyEB/bRF46+o+w5Czkm8sRrJdVi3kyS/jg1jAtZTqkupP0Dk+eXFF5KdvfONMH8CzdXkr+1q1LU4NJen+N7Xf7uXTWV/RMj7HAcklZWENJYIuG3B5DrxP0Owxuopg3wZIXrqNNc5sdwHxCvUdrV9OrpuNg6/OtBg1OeWMvXPTtWHYvcpEeGr8aD+TxQmyhDp6K6/Za0jR3c0Sma5iaBgZelI2DU/jM1aqb+PggiZyqeOTxxG1iHvPVvImVsOzV0/7VBGtBVkW4RdHtEnfNYM5oPnL+cDasVLCdWNXkxIvkFil1+fSPm5t4ulaKbE0yM1kbgvjzX/JNBOUCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>> Hey Lorenzo,
>>>
>>>> I mean not to beat a dead horse re: v11 commentary, but I thought we were going
>>>> to implement David's idea re: the new 'eagerness' tunable, and again we're now just
>>>> implementing the capping at HPAGE_PMD_NR/2 - 1 thing again?
>>>
>>> I spoke to David and he said to continue forward with this series; the
>>> "eagerness" tunable will take some time, and may require further
>>> considerations/discussion.
>>
>> Right, after talking to Johannes it got clearer that what we envisioned with
> 
> I'm not sure that you meant to say go ahead with the series as-is with this
> silent capping?

No, "go ahead" as in "let's find some way forward that works for all and 
is not too crazy".

[...]

>> "eagerness" would not be like swappiness, and we will really have to be
>> careful here. I don't know yet when I will have time to look into that.
> 
> I guess I missed this part of the converastion, what do you mean?

Johannes raised issues with that on the list and afterwards we had an 
offline discussion about some of the details and why something 
unpredictable is not good.

> 
> The whole concept is that we have a paramaeter whose value is _abstracted_ and
> which we control what it means.
> 
> I'm not sure exactly why that would now be problematic? The fundamental concept
> seems sound no? Last I remember of the conversation this was the case.

The basic idea was to do something abstracted as swappiness. Turns out 
"swappiness" is really something predictable, not something we can 
randomly change how it behaves under the hood.

So we'd have to find something similar for "eagerness", and that's where 
it stops being easy.

> 
>>
>> If we want to avoid the implicit capping, I think there are the following
>> possible approaches
>>
>> (1) Tolerate creep for now, maybe warning if the user configures it.
> 
> I mean this seems a viable option if there is pressure to land this series
> before we have a viable uAPI for configuring this.
> 
> A part of me thinks we shouldn't rush series in for that reason though and
> should require that we have a proper control here.
> 
> But I guess this approach is the least-worst as it leaves us with the most
> options moving forwards.

Yes. There is also the alternative of respecting only 0 / 511 for mTHP 
collapse for now as discussed in the other thread.

> 
>> (2) Avoid creep by counting zero-filled pages towards none_or_zero.
> 
> Would this really make all that much difference?

It solves the creep problem I think, but it's a bit nasty IMHO.

> 
>> (3) Have separate toggles for each THP size. Doesn't quite solve the
>>      problem, only shifts it.
> 
> Yeah I did wonder about this as an alternative solution. But of course it then
> makes it vague what the parent values means in respect of the individual levels,
> unless we have an 'inherit' mode there too (possible).
> 
> It's going to be confusing though as max_ptes_none sits at the root khugepaged/
> level and I don't think any other parameter from khugepaged/ is exposed at
> individual page size levels.
> 
> And of course doing this means we
> 
>>
>> Anything else?
> 
> Err... I mean I'm not sure if you missed it but I suggested an approach in the
> sub-thread - exposing mthp_max_ptes_none as a _READ-ONLY_ field at:
> 
> /sys/kernel/mm/transparent_hugepage/khugepaged/max_mthp_ptes_none
> 
> Then we allow the capping, but simply document that we specify what the capped
> value will be here for mTHP.

I did not have time to read the details on that so far.

It would be one solution forward. I dislike it because I think the whole 
capping is an intermediate thing that can be (and likely must be, when 
considering mTHP underused shrinking I think) solved in the future 
differently. That's why I would prefer adding this only if there is no 
other, simpler, way forward.

> 
> That struck me as the simplest way of getting this series landed without
> necessarily violating any future eagerness which:
> 
> a. Must still support khugepaged/max_ptes_none - we aren't getting away from
>     this, it's uAPI.
> 
> b. Surely must want to do different things for mTHP in eagerness, so if we're
>     exposing some PTE value in max_ptes_none doing so in
>     khugepaged/mthp_max_ptes_none wouldn't be problematic (note again - it's
>     readonly so unlike max_ptes_none we don't have to worry about the other
>     direction).
> 
> HOWEVER, eagerness might want want to change this behaviour per-mTHP size, in
> which case perhaps mthp_max_ptes_none would be problematic in that it is some
> kind of average.
> 
> Then again we could always revert to putting this parameter as in (3) in that
> case, ugly but kinda viable.
> 
>>
>> IIUC, creep is less of a problem when we have the underused shrinker
>> enabled: whatever we over-allocated can (unless longterm-pinned etc) get
>> reclaimed again.
>>
>> So maybe having underused-shrinker support for mTHP as well would be a
>> solution to tackle (1) later?
> 
> How viable is this in the short term?

I once started looking into it, but it will require quite some work, 
because the lists will essentially include each and every (m)THP in the 
system ... so i think we will need some redesign.

> 
> Another possible solution:
> 
> If mthp_max_ptes_none is not workable, we could have a toggle at, e.g.:
> 
> /sys/kernel/mm/transparent_hugepage/khugepaged/mthp_cap_collapse_none
> 
> As a simple boolean. If switched on then we document that it caps mTHP as
> per Nico's suggestion.
> 
> That way we avoid the 'silent' issue I have with all this and it's an
> explicit setting.

Right, but it's another toggle I wish we wouldn't need. We could of 
course also make it some compile-time option, but not sure if that's 
really any better.

I'd hope we find an easy way forward that doesn't require new toggles, 
at least for now ...

-- 
Cheers

David / dhildenb


