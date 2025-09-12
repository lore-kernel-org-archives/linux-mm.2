Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C878CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 08:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0F768E0010; Fri, 12 Sep 2025 04:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABE9F8E0001; Fri, 12 Sep 2025 04:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AD758E0010; Fri, 12 Sep 2025 04:24:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 88C698E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:24:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 573B11606B8
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:24:55 +0000 (UTC)
X-FDA: 83879912550.16.036360F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0372418000C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:24:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YOImus5G;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757665493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FRWJpxjvGPL3exfTRCSbM3blFXxwMwMcQ1Yjb8ikjDg=;
	b=q8cPMRqSZ71i2otCdIMc8dJt5XX+fsrZG0oaG2xp8fkYTY1tPlx2wo+4DUDdISxMYS+Zpk
	RpwJSJbEgF//e7nS83JE7czd05OkN8teiwkLEuzOvzQLHJXlfrG2UcV9upn9C7VZgHeGIO
	hVv6RCNKMuLUXlnwn4JtZ6lnCxvWc2Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757665493; a=rsa-sha256;
	cv=none;
	b=m3zHzm/8wawehzK88ynBhGqPbgG6xlq0NQpEy6yG7C5KLJ2BqkGmfnAiRMBXtHgV+vFPpr
	FC868BhxUOk/ZDea8m2kYgkwxn0AAO2LGBpBd7CciJLBz12RYsTIeJDmahyL/836T7wJ8i
	lbwmwDSciyMWfJVfX4X5zeoKrxx1k7c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YOImus5G;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757665492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FRWJpxjvGPL3exfTRCSbM3blFXxwMwMcQ1Yjb8ikjDg=;
	b=YOImus5GUumQug73N9LRqHKOHhS4P1ux+G56OTdlMemQoClwmCGHGuPgvXmYIkumZbC3JU
	T+WZUwTPu35VZrsTiPGm33onmTn8HHeZL0y4YvxwwKUv4YUR32De6S2bEufgmnWy3pNPki
	6+SJ72vs+ESjRQKR+ZG/9B8yEpW6eFA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-UnbDMvlEN1e-Cy41oRSXQQ-1; Fri, 12 Sep 2025 04:24:50 -0400
X-MC-Unique: UnbDMvlEN1e-Cy41oRSXQQ-1
X-Mimecast-MFC-AGG-ID: UnbDMvlEN1e-Cy41oRSXQQ_1757665490
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45de07b831dso9879205e9.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:24:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757665489; x=1758270289;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FRWJpxjvGPL3exfTRCSbM3blFXxwMwMcQ1Yjb8ikjDg=;
        b=jNrll+FknRm0+nPhW1LoS6LyxYhcDQVmbNze44OWv95tQtFq9lXB6ooKA+8EfRfyDb
         fxwQnXaJ8zMRoNe7hIuOagREoql6bc7YxW/ybrGJ0KgtGnIiGy2tpML/KsxyqYe0z1YK
         Q0KqIo6ZgZfyz6KkwbS8XecsRT9c8mdrdLkT1FvmGJoxF400Da7q3ZbBYCFHeEXfxC61
         E75fNMaEzuDt5HwuHxIHudD0NlJtMxrjcfuAD3L/y8qJBtc1IGzezq/rtp6NnVcmI2kv
         L4SLSeKwES9ueUyl+o7QaRsFskuXY+L8eHXoWgVugi9FwYPa4/SbAMnfi4m4s72Mp01F
         l9kg==
X-Forwarded-Encrypted: i=1; AJvYcCXzsU6q3semy9AnIx0mcDQ+Ph+QBXHqiuYnKRSiRpMLA1nNCnisLpijEBBVRKAopAzBlmyQWBVb6Q==@kvack.org
X-Gm-Message-State: AOJu0YwjWFL3OLK+QFSKp28JjUtxKBvel94J/rntZui9C2L6bpe3MhDF
	PbNc5NDgJ0uSwejSQ/XhA7lPfhbYPHPc00cLqTv4SflBlZ8be1IU2MZy8bQV1eNoPiHN2D7FvPk
	q8IureO7M4SmgK9/D8OwTdUbZ/vZrleRTa342ts5Q8jlbI9pctQ/Y
X-Gm-Gg: ASbGncvgV8Z2o4eMHPr+45YRUJ7QemgzGYAbszea37KnssfbKkPSsOkoxSPHzN/7pVr
	cfOoXZHXBKn8qO6Z7+zVKCF8G5ec52JdyiLe0+fETGR7cFrWrh1BoizfxookNBVJi2W5WNT05qX
	SASzFVvzmp6dJDb7cFYEDu7BZClCnrp/sK6GLGCI1Cfal5VNsLeRd2+tD6TCPRbhhUvZZQT0WrV
	3x0cWMBnEMVBciW/hsjwBt8s950Fz4AJDD2ZFZw1wIYBFw+lBYmE0dB/0TyyOqAItE4yzjXUXV4
	D+3dbXKp0X/Ln0Mo1QbaJ6xaoSd2JSLFQAllxVJB1XQM1V2PIlsp8x/s3m9E7kDbbIPFjz9+7t/
	dClmAqT51ZoDubMXNS5QEtkfa8vpPlYvubZ35usSgjp0CqJmFxf4SPe+HYYxy/hSgv7s=
X-Received: by 2002:a05:600c:5793:b0:45d:e211:da8f with SMTP id 5b1f17b1804b1-45f21202791mr14565525e9.36.1757665489576;
        Fri, 12 Sep 2025 01:24:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHiYqeRzPlyHLpt5eEQYJOufy0h05+64TX3jz0Z08DG2bpaL+p8+xBHK7jj+4aVOVK+tXQdnw==
X-Received: by 2002:a05:600c:5793:b0:45d:e211:da8f with SMTP id 5b1f17b1804b1-45f21202791mr14565325e9.36.1757665489178;
        Fri, 12 Sep 2025 01:24:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0159f2d5sm28850115e9.9.2025.09.12.01.24.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 01:24:48 -0700 (PDT)
Message-ID: <94cfb423-1dc5-43e1-bd1f-75b8d43fdc1a@redhat.com>
Date: Fri, 12 Sep 2025 10:24:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
From: David Hildenbrand <david@redhat.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 hannes@cmpxchg.org
Cc: mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 lorenzo.stoakes@oracle.com, hughd@google.com, willy@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1757648598.git.baolin.wang@linux.alibaba.com>
 <b8c0fe71982aa1cafafd59d8e71064efaac16007.1757648598.git.baolin.wang@linux.alibaba.com>
 <e6fc05fa-a622-47fc-acf4-9a5be98032aa@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <e6fc05fa-a622-47fc-acf4-9a5be98032aa@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Eoat4hT_uQRRQMScJaOxZwDyfdoPN2U6n_9cNXm1BK8_1757665490
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0372418000C
X-Stat-Signature: 1wwnniey1qig3ydfdma6h3189cnj6pf4
X-Rspam-User: 
X-HE-Tag: 1757665492-22197
X-HE-Meta: U2FsdGVkX19OJzM4BEg/70oBwGyR1d8B720o0nxnw2tlLvQGmZWNW3FPif4ic5RsBKODvBUdpdjkRRZdvGaKiCkYc82N/zBc1xh2Nxcj5jsVYjweaIFO8OeGVgZ2oyh4NoNqgZjIzNHbB9PRJuOqyMfcggRYp7TcGkTRIuHDY359F/yRDA1ZserSfCCEN8HeIXxfJoF/+otuGcRCFMj+uSZmMA6P0XcbpfFwpX19BNHrGhWmxzllleX4yco/tt1yywNJkj/2OmUxrOCBAAZk6azy0x7xTd7/Hzbhk0okxcIeKAHb4M+PtBgS4IH54FRZT65USv3H7tD9ZlTTnbFyWkG4Xh9e+KEATgnfzWJ6vdl0+keMvNzWn9aIY9UiVdwDVlosKb8EKFeVV1/JBeNnchAQp8ziIdRya03ogLCI6kGWkhW39joySdnCtXpH6qAkUsIWpN41YZ00xt7cNaMEpcVGzaBprmjIYhlufjrIN6+stiLUUFyqpHuE87JEvHuDISDds8XnLg81GEV1UftM7ytrQKD8ddPMK0zG6HU0r0vc0l9K+1db1KgUMtQKVRMWn69TqE93w/0hEpFnSBe+7hzyLSAIA2a3WblC9I8zqAjv3Vg7X/M6GWvBrudwre3/vlpRc7FA4YydmiWrDXaVoJ3iMuIp1G/BG5s+IdYNTzEo1qU9mKDlExXZ8WiTta0TczlijwQLLcAmUJkhn5WvoK6ZNgA3PcqS7mugpHl/OqRVJ5Mo293QnKEHQvmkGalo9jpZMuEC1nna+NczlbjAkfrf1XgiW/vlyJaP41XHX5wSgAsBrjVo73I6yZgMblz1R6cuySfHftnlQT8Q5WPUFgRZWNw/ObnobXa0k9t2HeKWDdsMll4Sl1ykORXGWzb6Hpff7hdfa+Yc8uOv1w3Rxy44T1oa7iB5rvlnFKttDw8a278E7imc00p/0j+H5DaXrC2mrGwAiyCg8kgjKa8
 QyWFsLAL
 EF8s1TZbaZhd3ha9rk+575V3cSd7YXytLqyMDI3ZhCiHU9G4s9dHJBP0mfJgg6hq966Pnpw04N8BEKjlAJKSsYdF5mgXi8zTbsvb9P3tY/RN2UsZZi3cVUAqgm3xMqDsxsR3a8ZwV9PAOVEw/0H9Pcht5B3QGabXP2FqfHdVayz++4qVh1nUxRQlNtEAHDMy0n6rOHmD6RRqp586+cUkqoZ3RArm7k4GBHcEJMwWq0XEYVOImG0hMNgXP4vIO0Tj3iT2Se/HSnYDjhQ53X4spW5c0L9IuvExwOy1sTPszfoWD4nTkOkmZ3ZcUhMazFwBX+n5zUcUzLvGPSw3syEdNGm+0+Y3/uXDJL1tZhC2JBjhFp/iJB5dEq70Ph2AzYlW35+b2/MIeRdnygi4pbK+90+t/L0uatnmpUsmfLhAs/mxyEKJyS7sXbqvdfIvsFnInZ6iNwKNLj5zi1kK7/TFLSafp5QEr+8Z0JPKBfGAQzrmoulcEsnHS4O9ryjMU6bt50r1ZyZLXajC22lQKCx7+VZutKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 10:24, David Hildenbrand wrote:
> On 12.09.25 05:45, Baolin Wang wrote:
>> Currently, we no longer attempt to write back filesystem folios in pageout(),
>> and only tmpfs/shmem folios and anonymous swapcache folios can be written back.
> 
> Can you point me at the code where that is fenced off?
> 
> I can spot a folio_is_file_lru() check before we call it, but the
> description tells me that there are indeed ways we could still pass that
> check for file-lru folios if we are kswapd.
> 
>> Moreover, tmpfs/shmem and swapcache folios do not use the PG_private flag,
>> which means no fs-private private data is used. Therefore, we can remove the
>> redundant folio_test_private() checks and related buffer_head release logic.
> 
> If that's indeed the case, do we still need the folio_test_private()
> check in is_page_cache_freeable()?

Ah, that's patch #2 :)

-- 
Cheers

David / dhildenb


