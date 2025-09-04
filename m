Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AC58CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 10:23:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64D3E8E0002; Thu,  4 Sep 2025 06:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6BA8E0001; Thu,  4 Sep 2025 06:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BF058E0002; Thu,  4 Sep 2025 06:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 312EE8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:23:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE6831A0AD6
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:23:40 +0000 (UTC)
X-FDA: 83851181400.25.35FA175
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 91421160013
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:23:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EUpTb8+9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756981418; a=rsa-sha256;
	cv=none;
	b=vQO1IAMpBzsnDuebhLp/lsNYZTBhKzDXDE79w3JMBRlt8B4VQExZ/5tjuRvij/+gsseLEW
	QESExWPV2He+piPMnbS0EtIAz7byViVGJ5716YHc2h4OI0dvmdBWmSj7azl/zew/oyuERw
	C8H/j9NZWtoK+cpq+N942Va6EwDjVXQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EUpTb8+9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756981418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HMLyLUiUh/TZRBZyhVrvLseu1BaUclOXEJcDQ74FaJg=;
	b=Yj7NokPPG2Gxbq5TN21p2lKB2oMuumfssmWjH65NnOzKDwx7lTQthnbAG95coHGMKqja4N
	Ei+diFRThjkjg6v0POSMpiYqEI0FPgKITcYxuZsg2ClVdXeFUXtYAKW+hDhXVHMlW0CRfT
	uKVckY4g4aoR3hjj2wp024f9qWu9Hys=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756981418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HMLyLUiUh/TZRBZyhVrvLseu1BaUclOXEJcDQ74FaJg=;
	b=EUpTb8+9PKM3Bl1k2PsqCKTa266atMPrZE8FWvC+DeK2sT/1UEst5DYo6frFwvXrJwN5Ss
	BNtfmPvdFJneMbUrsdMggeL5/t3E5IWPm5e+J2BGaodFxHg3ZczHn+6wEJVzeoI0SnkJPY
	148XCVkd3bOSbu/gXtcG8IS5EzAngtM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-SUVUXF-ePWaSpwJZuE5Iiw-1; Thu, 04 Sep 2025 06:23:35 -0400
X-MC-Unique: SUVUXF-ePWaSpwJZuE5Iiw-1
X-Mimecast-MFC-AGG-ID: SUVUXF-ePWaSpwJZuE5Iiw_1756981414
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45cb604427fso4337555e9.1
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 03:23:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756981414; x=1757586214;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HMLyLUiUh/TZRBZyhVrvLseu1BaUclOXEJcDQ74FaJg=;
        b=tEBUFJTm8ekhB47hEh5lHQf0VJB2r4W7Km49QzcEjfFwgtZ0eg7pZxZpG9AagJlUKA
         bLxJWNRMobFQ8oOwIBzMgpXa9wL8hWPnRYKI5S73NW4iQysd9neYVQfesRKX9Fajc3Mn
         ARHSyWI2CVXNVwTakk23slNJ/TGEmiwlSiEgpoXNLAEjPrdb34B1Kc18zFHYazkwsuw9
         RV2tVyCwn7KmLJSyGzALwKucDUUi5sAABwnxNh1oayIgIpL4rR4P6MqLWhD3LWmUS06F
         ukukLAms+hKdagAOwyOJGPKI6FuVyIXA0LwE69BmGedvHwx/bwdhumS5pnZapzjaPsUh
         siSw==
X-Gm-Message-State: AOJu0YyTVsmH2m9Y4Ddl/JTn806x85ffVnHiCtD+Oh6rPlPrF6mONLd+
	+0mrZaghGcMR5TOvmbs3g/5eg/Ys/kF8z5/WAyJ99IhfA1AV4Z9Jm0C+7hpJh13wmlqrWRJ5tOk
	jRh0lTskqzqt0aNRKcKKcvIEzuJ4y5HKHICAitjWcufdE4tRhogbL
X-Gm-Gg: ASbGncviprRGkFNrMoq2iTeL3q/WxpUQmx4xFy34Tiz6VUIrk+kWON1QOWUQSp1mynU
	o2I+8pumR6fK2ltGqNbI1Z4HStzxzlQ6Gp0DSsi+1j6Lgv2phb/2Ai9y56KhAiua9tP0yeUW8Wj
	1kq4SXELH3bW0kaKhqcGP9Ku+Y/C0tXNeGIqxc8JT/DPIy10GJEPOQOPHOefEYzUVZ6M0FX/XjL
	TEgvdLaQh8xH4Zk2rb6yjsUR+ZEjmOb9C43JhszaI3oKPhA21KvDExLiRQOre9QLAp4BuQ9oykT
	ZuiEKxtppZWcF89+YEUO2INTMNh1zf9DSkJwPC3qT09Fk/toV+3EO3HbBDdR1mznDEB9fluyo2B
	XfS21TbTJuHEtyX4giUr4kIjMoc4565xMBrnm8EZ6/72eUolyo38FgVcwOQRsYWlc
X-Received: by 2002:a05:600c:4fc9:b0:45d:cfc7:a16a with SMTP id 5b1f17b1804b1-45dcfc7a1f2mr20239845e9.9.1756981414011;
        Thu, 04 Sep 2025 03:23:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFyPrZckgqxIwcSXvcmROdXN20zf4ciUTUtqMgHL+vb5j2/auofdb1B1OI/l2DtECrLUTB1bw==
X-Received: by 2002:a05:600c:4fc9:b0:45d:cfc7:a16a with SMTP id 5b1f17b1804b1-45dcfc7a1f2mr20239595e9.9.1756981413558;
        Thu, 04 Sep 2025 03:23:33 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9c234b24sm93227735e9.16.2025.09.04.03.23.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 03:23:32 -0700 (PDT)
Message-ID: <84297d37-b766-4cfe-9c3f-bff1cb3cb4a4@redhat.com>
Date: Thu, 4 Sep 2025 12:23:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: tag kernel stack pages
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>
References: <20250820202029.1909925-1-vishal.moola@gmail.com>
 <ea48bc1f-7ee7-48b4-b389-c3622fc4d3d1@redhat.com> <aLiGnSHFJdaTpMc-@fedora>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aLiGnSHFJdaTpMc-@fedora>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: feKaSEuaP0ebdk3GhGbfkBaD3Ij80R9XfBwqw0FJs6g_1756981414
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 91421160013
X-Stat-Signature: efnopknt6wpfxyqk1m8ipwywycstjbyc
X-HE-Tag: 1756981418-237731
X-HE-Meta: U2FsdGVkX19o13fYdsx7Ecrv7ouqw8y26Q7gt/IYkOoyekEyeI7oGP6I5LRWGw0iurRIEFPZWrrHN/AMb9MhOJAKn90RhTrsYXCMshe5E5DyV5ou3Are2xoRfNcRJA9QLmbZrSjtBp0MYtUZLAZmjVORfMEVzZoTaFGM3F/C48gNqv9OQ35Z5hf0Q8l/TAmEzS2r+siEccphutWFZqPPe7G15ETToTTjzLj61C1xHmPUQAlHCxNVVEVynlfm65QXMU94RbH5twwFwx+IrHZo8jbdkO9qObDdFL889NUvB8Vfz5OIINTUeSmnqESleKXIL91d/8u6fgbDLwnAJzOxrKx2y3tR0RGPbfh/TwcqzgizCOuCj8uM8rmuDYVQ+qLZbg1oM9W7iC1IXf6/3jvwS9VmklxKwkVySauQ2cZFNxKbN9OhEVoZXLcL3xqjS+PuVwe48GV3u8ap6Vw57NBfPu1/GKvQNv3eKUbS8K9+EY5uWwuifFuUf69Apm2+ODk3J8tnYKNNjqpY6lH/9IHMVNoTdTEKyk4hsXlQOIP7+bx4ft/nEV8mPcdn8y5e+Iknq6nzlI/FdcV2Y6cO1ZA/sC2/RbZ5AHzxje3cen6xyvspZ1omnwZ4ckaA9xshkaRW/+loLA/jBa/pNKoDt4qngxebuv9JPaQEMycrgr4aRE6UJG7qGTjauxPOdUJkIYx0Q2Ogmeq8UkWhADHQGoBy3ZQcBTM1oe+jxFOPETEkKTOhj115zn1S0cxGMWr7vywfQe7a+llh7MtJZX/HFTKnRYnOdPWuv3s1h2bT+pu1TGVKQDZXqQpayZ4XBf7V6weEw3kFQQbDSRkRZocZ3GxDn5kECKZBEZlGWqLvVLhMEZLHgwJEnqu+7jzjgDSpBX+j5K4vwPxvaPoF91imdrI1jO79CAUKC8gN7WSNmqWaszuwUHC+PMgxKr2B6OvyXzPliyfdMYL6ebYSeBUoBNN
 BPxUGQ0p
 9rF1KDoApq7g6liXfKt6B69j2oU5991TTa/1ZlJOzcPxMQuyO4JRczTw3/c3D3kB242xKuMdwKfm7K1irDhD3v9/VTdrAzVoRQUjpoVEduGNh8khIQrxaawJ0kl5xzujpxom1kOHWHIo7GJec5wMlpQNUY5uZz2hNEwvNLGr4Wj4kTiUlN7yrPZNjZoRdwAKW3EZBC2ynRJuJPuMxlL6sqahVa9ipi/mHOMdVvH/gdjimssAAyop2aLMNp9b4w7xn1B3It9b/F+483gn/VN+NB0JquQeykfOC9NkwZitg4/KLGx0N+WscjTXDy2GyJ85F9m8cLmHwSdZpMsvKobzXbsSyQD9mSrVdXZx/MCt+lEQ2Kc/DHInv0QB5oUzU5lUBdnJuO529REumvEnyrtjDQKCDM49bzwVJy9sRaqq7+S1C1LDMLfYFrhlRCypLfRIVHZ2ziAOzPUNs+UzL/8g5dtqHerXxewvyMnPnsMpTRTrzgF+wFCGpKDwhf3XFio++LxCu3mS31wqlFhA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.09.25 20:19, Vishal Moola (Oracle) wrote:
> On Wed, Sep 03, 2025 at 09:49:06AM +0200, David Hildenbrand wrote:
>> [resending my original mail because it might have landed in the spam folder]
> 
> Ah, indeed the original mail was found in my spam folder. Thanks for
> resending.
> 
>> On 20.08.25 22:20, Vishal Moola (Oracle) wrote:
>>> Currently, we have no way to distinguish a kernel stack page from an
>>> unidentified page. Being able to track this information can be
>>> beneficial for optimizing kernel memory usage (i.e. analyzing
>>> fragmentation, location etc.). Knowing a page is being used for a kernel
>>> stack gives us more insight about pages that are certainly immovable and
>>> important to kernel functionality.
>>
>> It's a very niche use case. Anything that's not clearly a folio or a
>> special movable_ops page is certainly immovable. So we can identify
>> pretty reliable what's movable and what's not.
>>
>> Happy to learn how you would want to use that knowledge to reduce
>> fragmentation. 🙂
>>
>> So this reads a bit hand-wavy.
> 
> My thoughts align with Matthew's response. If we decide "This doesn't add
> enough value to merge it upstream" thats fine by me.
> 
> Otherwise if we think this is useful, I can respin this with your
> suggestion below.

As raised in my other mail, I assume there is no way to just have any 
stack pages in any kernel config marked appropriately (slab allocation 
discussion)?

If so, I prefer to not add it.

If there is a way to just make it consistent, then no strong opinion 
from my side. Willy is the page-type guard :)

BTW, I was wondering if page-owner could be useful instead.

-- 
Cheers

David / dhildenb


