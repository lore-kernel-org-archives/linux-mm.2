Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62267CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6D508E0016; Mon,  1 Sep 2025 08:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1E698E0013; Mon,  1 Sep 2025 08:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0CF18E0016; Mon,  1 Sep 2025 08:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F6E08E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:02:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 583E311A02F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:02:53 +0000 (UTC)
X-FDA: 83840545026.16.9981D92
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id 48741A001C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:02:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=SqvlGRgp;
	spf=pass (imf15.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.41 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756728171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RnfmWiYHUC8i19glkM7oL/LSJL9iA4N5hQ/wPd1r+F0=;
	b=LuagkK2tvqttycC02zybyxOkI/5puPnGIqLQq2eGJ3U5PigDT9x+Pp/A6iEsQ26cP+Otf9
	TzWExEgCCYjDfF62lGKTvHEa8I5a0c0B5CVADgk63i2M3Piy/D+VB9VfsklmuKRWua+lRP
	aokSjfrNytAmNq4wjFOA728k7hT6X+o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=SqvlGRgp;
	spf=pass (imf15.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.41 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756728171; a=rsa-sha256;
	cv=none;
	b=rJ+qCZ1NzaYEgnTRUq8GZrvyIUo2CSvStx3uKEsyYgY/W4jYeKLnPXwvpAi9bhUbZHDK2Y
	/Ev+j3R3J75CTQi0H5sulUYE05FM1qBPi525VVnaei8SoW+ROA4N65MeKo2vxcNCHs6C5T
	g14p0sIZ8/3av0SfZlxTzhc1xQp+AlE=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3d1bf79d7acso1222325f8f.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 05:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756728170; x=1757332970; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RnfmWiYHUC8i19glkM7oL/LSJL9iA4N5hQ/wPd1r+F0=;
        b=SqvlGRgpZYTRRop+fJ1iB6t/2sP6s4aZpbGwQIAw9qO5IfwkEU/HSe3cFa1ud26OQ5
         LxtzPob7I3wrSjytCcmKSi8RqOO2qn79GIf2crpJmhhJHThMN7rDlbU2Rk7+ceQ5Xn5B
         vDaYrz3SDaR4orxwl/YIHsGuaqpMMXlZpgSljpF1jrxjAjJ0tvLKXhY6/YVkKgv4UIC1
         ejQUX6cW87Ct4umY8m1E2PuYVB/LJe8ANhlpIn/ZsuW8ruBVKGuZqla3OUcfMOSbjfke
         njFX8v+ZKGq0kWJ97bcShGvxioxOCpFQ4tQ3n7/uQK8TfynmLg6SRCvKMLi3a0fPp+1m
         cN5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756728170; x=1757332970;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RnfmWiYHUC8i19glkM7oL/LSJL9iA4N5hQ/wPd1r+F0=;
        b=NL6nZO3Ni1S+Zf1eRTE1bwLNZ9SMOsXOQQGpr1VcFSdOzlEJ3jbzLYfPhKJltpc2Zq
         5m2xqxKnFnKl17ysNxHRdktCt/28Nre19RWIkq3c/wsJs/o7g/YyMk40zTZu3+OlNJ4R
         SXP+EsPFieOn1tTQ53Rw7x9sDiBjJ3sX4ke4AKmzrNrgH5yH7+nDyqS1lfeffHWP4VQY
         wy74ZhAs5MB5Oksj7LnWCz2waR5XjfQPMOg9IYwB+uFxpJ5QzxQ/Act1pN6P8X/Z+hsT
         hw1I1tj6Wh/AjMJGpd7L+aWTjBWJdOZynI3LhWmh1Ls5sFWhLqZVr1bFyFnq5/L75utx
         Ua5g==
X-Forwarded-Encrypted: i=1; AJvYcCVDMZF1HnK20rakj4/wAKdKe/V6oJR1dJ1Bga1NpzNcriCLCHMKzas6ZkqmoHEZqlXIrSDeoQjoIg==@kvack.org
X-Gm-Message-State: AOJu0YxX0rkQx3vWyBoIecVSv0EnJHaKX6GmFbY1YJ0kR86Zh0ghFgvq
	Tz924nx7rqexocM6Ho8MOKjsz0RhSDn/9u6TNy8cyysusSHEtIRqzroI7bgea132zAA=
X-Gm-Gg: ASbGncsgtzX4exYPDzMJb0i1B9Srt+QvN/o4C3VIsc5gFzie0RiMDDZ+psgXxY9La2x
	knFaNPwu8ZX9AeArgQf/K4Z1YaNTgyQdPDv/fPytunE6StSFs9ZwIAKpK+uFlktlKLEuG9+7t5Q
	vce739exO4+hah96OV8EKgHKH/+erIgph0TRwilnvHvnwoY0rkkkjt7vkJV6QgnLsqDPx+/8TTn
	WVZRbyUY36HeXNqnoyqjYiWPYeQT7EsmbzG5Onlj73lMZ8tqQGW8omM4BVjoVf9aLCJfPCP7sJY
	l3iHluGQ7TpSRiuMAIFPYV0yNQ5skb+7iYqpMD16CRC25M9txz6712penjwDFsSlElmmP5r+67L
	NeC8EUSduiiOTr197Ua2i5H9HDpb/wqJaHs9J3Qh5mN+Q+rnDyxmrR146kAXlOAJ1WeYavu6bxe
	tvsTg=
X-Google-Smtp-Source: AGHT+IGtFYqe1NkisHt6TuhFoDyL75/fnRaNQlYXgCsJGFwGxCneAkzy9wIFe6z6w5vZIfrX/R2fCA==
X-Received: by 2002:a5d:5f90:0:b0:3d9:2fa8:1009 with SMTP id ffacd0b85a97d-3d92fa81454mr79263f8f.45.1756728169537;
        Mon, 01 Sep 2025 05:02:49 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:335e:2208:72de:40f7:b7be:9bb7? ([2a0d:3344:335e:2208:72de:40f7:b7be:9bb7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e88785bsm154333855e9.14.2025.09.01.05.02.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 05:02:48 -0700 (PDT)
Message-ID: <94f537ae-c2b1-4928-a3f3-6449c30cb624@linaro.org>
Date: Mon, 1 Sep 2025 15:02:41 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 22/29] mm/numa: Register information into Kmemdump
To: David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 corbet@lwn.net, mojha@qti.qualcomm.com, rostedt@goodmis.org,
 jonechou@google.com, tudor.ambarus@linaro.org,
 Christoph Hellwig <hch@infradead.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <e66f29c2-9f9f-4b04-b029-23383ed4aed4@linaro.org>
 <751514db-9e03-4cf3-bd3e-124b201bdb94@redhat.com>
 <aJCRgXYIjbJ01RsK@tiehlicka>
 <e2c031e8-43bd-41e5-9074-c8b1f89e04e6@linaro.org>
 <23e7ec80-622e-4d33-a766-312c1213e56b@redhat.com>
 <f43a61b4-d302-4009-96ff-88eea6651e16@linaro.org>
 <77d17dbf-1609-41b1-9244-488d2ce75b33@redhat.com>
 <ecd33fa3-8362-48f0-b3c2-d1a11d8b02e3@linaro.org>
 <9f13df6f-3b76-4d02-aa74-40b913f37a8a@redhat.com>
 <64a93c4a-5619-4208-9e9f-83848206d42b@linaro.org>
 <f1f290fc-b2f0-483b-96d5-5995362e5a8b@redhat.com>
 <01c67173-818c-48cf-8515-060751074c37@linaro.org>
 <aab5e2af-04d6-485f-bf81-557583f2ae4b@redhat.com>
 <1b52419c-101b-487e-a961-97bd405c5c33@linaro.org>
 <99d2cc96-03ea-4026-883e-1ee083a96c39@redhat.com>
 <98afe1bd-99d2-4b5d-866a-e9541390fab4@linaro.org>
 <c59f2528-31b0-4b9d-8d20-f204a0600ff6@redhat.com>
 <40e802eb-3764-47af-8b4f-9f7c8b5b60c1@linaro.org>
 <7e1f4f64-dfc4-4366-8e01-0891b2d4d2b4@redhat.com>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <7e1f4f64-dfc4-4366-8e01-0891b2d4d2b4@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jtsyrpwhzz6hgn59gutfhjzqfcjfhnw3
X-Rspam-User: 
X-Rspamd-Queue-Id: 48741A001C
X-Rspamd-Server: rspam05
X-HE-Tag: 1756728171-420564
X-HE-Meta: U2FsdGVkX1+zCsfIi/5Xk9VU8+sIGO5pS2hLIvMfRryq2cRnwVDCfCxdKfsdygynmNoUqjuNm16m454fKyhiIPBaF+jE1yN+90TINwanvytu4VkIgnOJ+I1eccrmyR5DzE+i2UUbntVj3xLD6uFnsxza+DYyZj4olTj55hQLP9yVWq1fRpi0Te65Zk6tnriDuyT5hlOVq4T/8ZtD5LwzODUKOs2lIlg8cruZht1aYoW1gTJZep55v931RROmlDXS7Wzl5ALoUwm3CbFbtmQzgioInvtbRQ0XLO1VnkffM6LVfVcKvPiCYV/9l4AHy8t634kIEh/SJMHzJC0TrfXdoj/Bt+oEKBaXT5cdj9YwYNceU5WOcKAN223Lgy8RcupvcEc1B2debnqnBFPW8uDZJOKTQEDPhSu3dA+epP6uhPhCEI984z++D6FPKCV6/w50SQtjvySj2AKCJVi9xeT1+r+5FH3wz/RMwUL2egcklEdHOjuOwD3Jd+WC8yd/DejDuIdPK9P9FOh5aVs+H+6kbPSRN5WvTKf9F+wtfGxOiouOTQzVpi0Ea1kzVQROhzofquxAVUxoEXuhYQpQqif4VgZTin7ZoWRHRtdWUSXsxR8TosAq0A+uBfS5XE3KZCYZbqKL+hAqSYFag5EiquQsYtSIqP8ZWc9iS0hTB0UKEFySnC8FOMr952+b/nVAb1mkdQQ5NWQdn/g1p2HoAtwVKuhZXfC3tb+YaO1t0n9bGDrcCM7T6jpkoQ+J52/DZfFho8mldhqLK1F3/DI9G8zBZWQYKQqhDhKFbP6AguAXwaPKkGBoE+MinjfYZpfqxYM2Ixt3nJjaQUrDomYsQrORaW4+Xz4JhyCUKa46zTVvEZyXdDT+gOJIQ67qUCCmvXLr+MwvwFAG0UyX8U8DSvgER6hYPo/DGHncRfodOJ1s3W+Xa9vtKBfwfDtIzB2z/30TKV3pxOBt5NNbi8llzMg
 S0YHKKZd
 cEZZwD+2VbiBDug4wYi/UdEfPlVO0Usyq4hJeWmkuryw43OG/C3S7vtQAK44f/+LxkZTNbse6fJQvTB1qxFMWHDmLTZBEAw5mCzOdpehXyW600xvY6rL1c78FNi0HoTpCuRoUGA2V4+EZH5tRQ8AXUhEp/AvQjJi+sKj9eO89KhOudFn6iQFrr8A8O5ZN4LM06yp9of2RYjByfYsANP8GtdhSuvWWpCwYcjrXqE3SzKQ4pTOpnD22zNFBn2n6Y/vlu0wJCeIzvOsumJYKaYJWsgtPWxZ06U+J+QrLnPx/hiSF9RH6D5G08ntoj/VAnbp3ZjKHBp4hB8ihnAjj6uYkd28tyxJm86e1uW3ESmAKQoTmIbI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/1/25 13:01, David Hildenbrand wrote:
>>>> What do you think ?
>>>
>>> Looks a bit over-engineered, and will require us to import a header
>>> (likely kmemdump.h) in these files, which I don't really enjoy.
>>>
>>> I would start simple, without any such macro-magic. It's a very simple
>>> function after all, and likely you won't end up having many of these?
>>>
>>
>> Thanks David, I will do it as you suggested and see what comes out of it.
>>
>> I have one side question you might know much better to answer:
>> As we have a start and a size for each region, this start is a virtual
>> address. The firmware/coprocessor that reads the memory and dumps it,
>> requires physical addresses.
> 
> Right. I was asking myself the same question while reviewing: should we 
> directly export physical ranges here instead of virtual ones. I guess 
> virtual ones is ok.

In patch 22/29, some areas are registered using
memblock_phys_alloc_try_nid() which allocates physical.
In this case , phys_to_virt() didn't work for me, it was returning a
wrong address. I used __va() and this worked. So there is a difference
between them.

> 
> What do you suggest to use to retrieve that
>> address ? virt_to_phys might be problematic, __pa or __pa_symbol? or
>> better lm_alias ?
> 
> All areas should either come from memblock or be global variables, right?

I would like to be able to register from anywhere. For example someone
debugging their driver, to just register kmalloc'ed struct.
Other use case is to register dma coherent CMA areas.

> 
> IIRC, virt_to_phys() should work for these. Did you run into any 
> problems with them or why do you think virt_to_phys could be problematic?
> 

I am pondering about whether it would work in all cases, considering
it's source code comments that it shall not be used because it does not
work for any address.

Someone also reported its unavailability like this:
drivers/debug/kmemdump_coreimage.c:67:24: error: call to undeclared
function 'virt_to_phys'; ISO C99 and later do not support implicit
function declarations [-Wimplicit-function-declaration]

I am yet to figure out which config fails.


