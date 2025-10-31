Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F61ECCF9FE
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 10:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D27C8E00D5; Fri, 31 Oct 2025 06:40:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AA0E8E0042; Fri, 31 Oct 2025 06:40:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5714C8E00D5; Fri, 31 Oct 2025 06:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42FC88E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:40:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0B2588959
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:40:26 +0000 (UTC)
X-FDA: 84058065252.11.FF15D15
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id C101418000D
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:40:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Nf7zFkvO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761907224; a=rsa-sha256;
	cv=none;
	b=eHs1k9tosfdqM6p8PDVjntEOBmF73SrXZ79N/FxlKbFmFJzh6XxzEffGnicVnm+k3Mmvya
	jFkqLIfToSa5OB2ZMomhGWl1XcUW2GUQ8tBijOh36Y/olq3h5vDUcblPbfh+Y0+QRVTz7d
	s/Fsw9Pa2osh8z5El9zFbjBNtjq7R3s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Nf7zFkvO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761907224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oJIKzzXv1KPAKlEWKXjXEzGX44uW5fHNqueLO5sqP5s=;
	b=PngGZSSTYxgqwwEQ0wtn72lu5Lz7GprbhTPxm3SpnmUXERi+z1g6h8a9I8t9ZsP8oxBV4E
	5QN+e9aZ+7g7rG3mL9HBaE3u4q44ir+4Ak0lwlFA1j4V1z6UAilNumXZIJRIiBAfi6V0M5
	5ewFJL0UxrTM193f233QGn5mIq5lpEQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761907223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oJIKzzXv1KPAKlEWKXjXEzGX44uW5fHNqueLO5sqP5s=;
	b=Nf7zFkvOKw07e1Okx4V1JKBfBwhkj+v9c7prG1KwNGPu6I0lSdMGLMejuAgymZTjmMgpUZ
	e9UH8hALbKQfsKi/bGy3F1M9sGYU2TcpFQqM8idFOReTv3hclAPM2Vx/o8yWaPWNkzl3tk
	91YmC22Nz4CykvVaTi6I/HRL4gRh03Y=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-xbNdbKA1P7uiVM8urAbv_g-1; Fri, 31 Oct 2025 06:40:22 -0400
X-MC-Unique: xbNdbKA1P7uiVM8urAbv_g-1
X-Mimecast-MFC-AGG-ID: xbNdbKA1P7uiVM8urAbv_g_1761907220
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-475de1afec6so9783895e9.1
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 03:40:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761907220; x=1762512020;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oJIKzzXv1KPAKlEWKXjXEzGX44uW5fHNqueLO5sqP5s=;
        b=veTZ2lWntu7OgSEecnuk8GmyI72FzKRPsL6WJD8CB2sj5FxGJ25KqOQ3viQMmpo4GI
         HMzDXiu2nCliXDvgVyneJ3mIeroPObLS4FeEfydTUErpcW8wM7/4QfI1ennVMYzkRjIn
         q70PF0Ia8ZJKyi+Gey/0xQcuDMqfP+e7gE+QbKH88iLpdPlQvkHemgXMWPbQvqvYe1c4
         +HORafCtcffdcOgg6JSLirESfQXxKWoehtw43wqjRC85euguKgJFDUiHRzaPTXw5HZUF
         gsSdjXbil5kfyZQP9i+B8AVHLGzdeudEsxguN+IHAtw7JkNjY8I/4/t4Zc0ZesZ3Tf6u
         M6jQ==
X-Forwarded-Encrypted: i=1; AJvYcCXEYE7LK97k/zQIi5hjqaE1pPH+AssL8Hivka6fEt3p5JWFQgQqS1GYnFTDX9XEko7uuUnT6MEsMA==@kvack.org
X-Gm-Message-State: AOJu0Yxz4RFPga6KLKkvRKxolq6WMkgV1iQl6xMT9ISIl9MlZNoqnZIw
	1YFEzQNsy+DD1BqBufbEatBXkNt7sqn/sKyIcCSZUOwP+uV2LghO3eOYtOtZUIaxkGjeY0Km6Cj
	wjMMP/5v/9o2EYb8tEoC9I3SLPPHDx35N20dE1itAMVKIB+XwSB2DSWPa4UUg
X-Gm-Gg: ASbGnct875PY4SVmoosXWRKo7whuz+GgrBq9RttPhwm4rzxO5ZhWEamL037WZTI5mjQ
	6yr2cYcUGGwkdFHXPesoxgkhw3TIK04UXJY6m7cCHFl2nfiOSzmbyTGYVeWdvOY9O85B7/P1oqO
	gdPsVKh9FcPJrL5DMxhqT/EgasZK1byc2deqQTZhPVMabCh2vCXeHIYu4u2q1uA6e9GW/qyJcZl
	KQuoXLVr9VdqSB+eY86umjmXECWaBdSonBknW8yBot038IDkZ0rOw5GPEm43KStTtWymB/3/BGS
	Ah1+MhgTwYsKvKpeh8IrBdy6SZ7ExLTCDlTEqawDCwJ0N9w1UUZ3jOm3JrOfuMCTJ8BrL/lJrnj
	WSu45YgFoTdm6ggywsD1x+3K4WYAKYYVFULnTbPhTJRvPPSQW/mL5qPauVAFoewOHHI7X0u2yv4
	07P4Pxdr0sEVzAEOsELbKpVOi5eV4=
X-Received: by 2002:a05:600c:1387:b0:475:dadd:c474 with SMTP id 5b1f17b1804b1-477262a966dmr52601195e9.10.1761907219638;
        Fri, 31 Oct 2025 03:40:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFNypKJqvSxCMoAKYjs9Rl2Q+K34gFvuQORJf5CmJ4AWi1A3ik+7eF/76PZ488GaIPEHvkvg==
X-Received: by 2002:a05:600c:1387:b0:475:dadd:c474 with SMTP id 5b1f17b1804b1-477262a966dmr52600965e9.10.1761907219156;
        Fri, 31 Oct 2025 03:40:19 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477289adaf8sm98599145e9.7.2025.10.31.03.40.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Oct 2025 03:40:18 -0700 (PDT)
Message-ID: <ca63328b-1c57-478c-b8aa-af0974b7f188@redhat.com>
Date: Fri, 31 Oct 2025 11:40:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Hit an assertion within lib/xarray.c from lib/test_xarray.c,
 would like help debugging
To: Ackerley Tng <ackerleytng@google.com>, willy@infradead.org,
 akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: michael.roth@amd.com, vannapurve@google.com
References: <20251028223414.299268-1-ackerleytng@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251028223414.299268-1-ackerleytng@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JNadR_sOp-J8WxzCuHnPu7zJyaUrcqBMGhzPkfd1jrM_1761907220
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C101418000D
X-Stat-Signature: ei6oa8ibjjnrut5pjpz55g5pigwjnemj
X-HE-Tag: 1761907223-735091
X-HE-Meta: U2FsdGVkX18ENxtxPFo+LFstrrwSgYC7a9Akb+AbZwYcJfZUQ8rA7Ez2kWhBDjY4BPO4N+W5HwZRTJvZmzAjKzfqekCzDYdYNosp6q1DWBxRFfPUwOZcG7lSrqxo+Oud+Bf7YFw/tkHsgHtedSkIaapiKb06dsBsPZqB7z8J5Z1ZmSfrp3NzUs8KhlrY5JV2LwaxI78265AfsTuLwtwOKJYOl1cBlbGs/6rTwRrztD7xHhG8+zhtEMan6rvs4uceTzkwyWEkojdxDAKZvuxyTuSy3VaOlmRrYkkG2AQWr/K8VKQ7uNgB7lPZNf6c8iMkeVtsGd8bTEooWrwSgkSaY3k9XhMvjJJ+4gAIh5MruUUv6KxldbdDOiAZyfHXJ1z7/9IHUcEaySihGFQSwp3hNpW73Wrrx0ig1F8onQ8SifImVsGX8N/fye+xvfj26sxXtpvWsWf/QbX2x7clBga4DW94qwf3/QAzfBGyqxlwrHMI5+kqOcg3ca7xd50Gabv2EglvVzXxEnjR8pWPi+fajsCSgRxAPJrkFmYRvF/aGw0qpbgydv5CQPOx4Up6GdrySSw3RFx0WgCSPM1Vf5+jyVIO2udfKtnTA1gPnrX1/+039DftMEkKAu8/oZjXPimgoCHEIPhPyG5MRmLd3zbBt44N/bytrzOmGq3pdWsljlXG70c5ll6TJbAvQgcqryWjqoBG8nXIRgmRrqgylhXzkdKWt2Lds2D+5yWaYLfensFN4wvPjM8auz/bNZuvIh6gnb6wl6CjmgLwMqISmmtIF/dqzLcmbzAxBdcwSH93sDOzkJMvD+/gb7JoBraTs7IKGgfYTPfSOt4mm15Dj9Z2bQADJpDUMQ0kazjeU3glYgwtAC8l05/vDA3/E1XtZ+Hhh/SwjF12zfUNFFqLcRByE0+/8GNbVAHnYIxPAET69kQ+TdiCysio3/L2p41zMy9hn3jW/UAuF3YUgXT+fP4
 mK+TxwPf
 x1uZ+lCVGDZD09DohEE0qxV5mHkPrQVdnSmilyAmPSFepFe0UgiSPlzZk6ilf/MZpRrQqeOOvPjLON6VI91ZKgZnVxK9vF87QdJQ28f94LgTk8mGlzFsKyAtCCqd8wBjVdE9VOKeIfkNjPHK4WDbqYVQbTmzZIlWOpX3fDXqmc4bURZgHTpVO1ZoKLK7V6b/lyTrdwG6AkGIfPFZseSSrBtC3DYrh+QNAV1qHtS+GVv7g40YfKgSutRb8PbB5rqPod7hXYu1/T73mgT+FYlUOG/4WfRCE8RhuXiVnzp4S9pXCFjr5ars3ziK6jJbEo9hGRf3Z32l6YVS2RF0Wl3wtpvcBoGasHulfZa/3x+1jqrHnhJl8HFjqyDiPPAfzx0hUoL1wynGjBLRNjTvI2eEUwlBhKMgr383YHO6WVkPuQDuXHOqRXVCJLThp+owYITZfU1elYqQ7UuTly5MdSWFOz15lPeN7tGBrkh3jgqnnX4xuqui6JmO90w9AdWZGkDQneITLgD+nr7so2984/43fJIF/VFGR4us66UOJOM3hZ965a1dxoO8B+Ya1gQBW1YtFIjkyUwaTT//j4Z1Jy5p95OCJGQks3JLx/RXx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.10.25 23:34, Ackerley Tng wrote:
> Hi!
> 

Hi!

> I'm trying to use multi-index xarrays and I was experimenting with
> test_xarray.c.
> 
> I'm trying to use xa_erase() on every index after splitting the entry in the
> xarray. (and I commented out every other test case just to focus on this test)
> 
> Should erasing every index within the xarray after splitting be a supported use
> case?
> 
> Here's the diff:
> 
>    diff --git i/lib/test_xarray.c w/lib/test_xarray.c
>    index 5ca0aefee9aa5..fe74f44bbbd92 100644
>    --- i/lib/test_xarray.c
>    +++ w/lib/test_xarray.c
>    @@ -1868,6 +1868,9 @@ static void check_split_1(struct xarray *xa, unsigned long index,
>     	rcu_read_unlock();
>     	XA_BUG_ON(xa, found != 1 << (order - new_order));
> 
>    +	for (i = 0; i < (1 << order); i++)
>    +		xa_erase(xa, index + i);
>    +
>     	xa_destroy(xa);
>    }
> 
> And made a call to
> 
>    check_split_1(xa, 0, 3, 2);
> 
> Here's the assertion I hit:
> 
>    node 0x7c4de89e01c0x offset 0 parent 0x7c4de89e0100x shift 0 count 4 values 254 array 0x55edd2dd8940x list 0x7c4de89e01d8x 0x7c4de89e01d8x marks 0 10 0
>    xarray: ../shared/../../../lib/xarray.c:764: update_node: Assertion `!(1)' failed.
> 
> 
> I think I've narrowed down the issue to the for (;;) loop in xas_store(), which
> I believe isn't counting the `values` to be updated in update_node() correctly.

I wish i could help, but I'm not an expert on that code and it's not the 
easiest code to read :) But staring at it a bit I assume you are right 
on that one.

> 
> Is `values += !xa_is_value(first) - !value;` intended to compute the increase in
> number of values with replacement of every slot being iterated by the new entry?

Unfortunately that I am also not 100% sure about that one.


-- 
Cheers

David / dhildenb


