Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77157CCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 19:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8AF48E00A6; Thu,  9 Oct 2025 15:13:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62238E0002; Thu,  9 Oct 2025 15:13:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2A518E00A6; Thu,  9 Oct 2025 15:13:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8FB468E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:13:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3113611B222
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:13:17 +0000 (UTC)
X-FDA: 83979524034.02.BDAD786
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id CA9BD40004
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:13:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AVxB8V9k;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760037194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uMfDHaIXjP5qW70eAEFIPvcXKGAAk4uyl5DbHMEw+mw=;
	b=7u4lPHPUFUQRVMjcB33JLpHQapkoMm57HbiGczFcWWmMj3p7U60Vziu5PO7AgP8x2t6YdZ
	W3BIxt/P4lpdB7EyWG/Q8UQWV7Iu8OPAT2vNcMsTWKkH795NfEfp0pCz8O6suGSkwCCEsF
	llSYUxPh17iEWL34v1+KI6z1a6LvHNM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AVxB8V9k;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760037194; a=rsa-sha256;
	cv=none;
	b=iMOioeLNxrzWficvRVarp7gPYEjkzMb10KuSyLlEs7UYAM9408v+TM1ysAd5zIzTFSrDeg
	5Gj2GPDLH0gVmGI9uJXSvtwEtAJWJ4i3AIGv4nm2x9e8LmBMHOr3RDCgQFXUTfFYtVVQHx
	zgPXm4X+DXf8kvZhZ3JozHgUiGVMpls=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760037194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uMfDHaIXjP5qW70eAEFIPvcXKGAAk4uyl5DbHMEw+mw=;
	b=AVxB8V9kawN89zrXIfJAmaTrS793oJj0f9Xkr6jm13FtLfXdT4PeCAi+ojGm08fEpVWpwP
	AOF8u2ljWrh3dYUMbTDhbrWAt2LTn/mfsu+e/YxJjN7JgNUnJ/SuDBkETEiTyLp+Qpoozw
	yTz6CW4AAl//AMLJBJNC6u0kwafOwyg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-m5rhdVpbOfC6VTf86I2XXw-1; Thu, 09 Oct 2025 15:13:10 -0400
X-MC-Unique: m5rhdVpbOfC6VTf86I2XXw-1
X-Mimecast-MFC-AGG-ID: m5rhdVpbOfC6VTf86I2XXw_1760037189
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e36686ca1so13026625e9.2
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 12:13:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760037189; x=1760641989;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uMfDHaIXjP5qW70eAEFIPvcXKGAAk4uyl5DbHMEw+mw=;
        b=FNM+1Ft/ln3S6QWCdGWD9rLDpS17hvj6yk9+uKwUXGHzrgDRqJ6QEhOR4gfyVQnZX2
         G5P6FPZSN5H6CntoY6CI3ZnBmsIyY/E1qhRfNi3v650G8D88sRmFMX0EoiEFciduHwV9
         xCYkCxa3aSel1+NmSBc95vxLEKaM3CEpmMheEOXmDkqMUZFfp7nGOdkMNWUoIVDRB5AH
         skEaSrWx/VckyBQFMohw6EMeFTH22lPCAQ8x9V81ynSuCZdkxXBz9aeMNSZXMSjnqw3H
         c1uAf1hqh74h/nLTZft7ccEAnExYNH4EdOJN+DCHel7OOc2K11Sq9pQXs9yF3yX5N1h2
         04pw==
X-Forwarded-Encrypted: i=1; AJvYcCWq41Y1qQR6IkgrfOjn5YkNYwu97KaE5okt3XM4m6pNghRZqAquwtwk0eYE0ZPo5ipPtDN72S6q1A==@kvack.org
X-Gm-Message-State: AOJu0YzzCGrVyvN0qn0T7yJFxnfoMkff+ie7l5KjPzRzqJ8YPBX/6vFw
	0dJyEeyZeA/t14J50S1FwEgCxG6Nfh1OtCilqWt+Cx2i5MN0HbW4OMLzSqNa9OU0oRfNBzXknDc
	ojWSDVpmLj49VrjGHNmS4y/9/IL8s06+hAD461gCqcluHssnSbeJ8
X-Gm-Gg: ASbGncsQFclac4NnGF9SMyZ0L/SAZzsn3HTlRDZd+VnyjesVThQAMBkB3LFt/zO6yWL
	CpA+dVAW8+BJCVQ96i2+17ptX9d2tgtarcLHiqe8QhF5cYM6ItFswbRz5eSV83UiLH+D3gHD0dF
	ABGRQtbdPIn/n2rgAEEsrni93zwB3GtbXXPQ8xpppRbrtJ+7Rf/nWf5TaxAbVm1cLktl7Rdwnl/
	h1Cyumo3mcbY7ELvO98BY5tM6DL8Oe4VX51kfUwnC/+hRqOPQcAVAGScUJx+kRz8NhpRzmC6ev/
	wljHPzTKjMXh6I1W+BmAHKCNmgzFg7oTBc2LcKlD2Pnn2kULtnKyj4orVdYSIIgH99Wh9pU3AyW
	melcTC66b
X-Received: by 2002:a05:600c:1394:b0:45b:7a93:f108 with SMTP id 5b1f17b1804b1-46fa9a8f090mr59071575e9.3.1760037189455;
        Thu, 09 Oct 2025 12:13:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBcImDsyxTunmBqgZfkDNrdR7pu/FzopoU++FfWBhFLzzgiDgfzJIo/TDjPU5ArHmmJTRIsA==
X-Received: by 2002:a05:600c:1394:b0:45b:7a93:f108 with SMTP id 5b1f17b1804b1-46fa9a8f090mr59071425e9.3.1760037189032;
        Thu, 09 Oct 2025 12:13:09 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5cf6b4sm405958f8f.25.2025.10.09.12.13.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 12:13:08 -0700 (PDT)
Message-ID: <ed7db8b9-e828-420d-a8b2-3e1b8aa8c95c@redhat.com>
Date: Thu, 9 Oct 2025 21:13:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] s390/sclp: Add support for dynamic
 (de)configuration of memory
To: Sumanth Korikkar <sumanthk@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
 linux-s390 <linux-s390@vger.kernel.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
References: <20251009131839.3739108-1-sumanthk@linux.ibm.com>
 <20251009131839.3739108-3-sumanthk@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251009131839.3739108-3-sumanthk@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vk17ph6SXggDemhRXqNQAyaw6OKwXJfPXolIczUB1XA_1760037189
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qkm55t5chc7mj8q9n1sxgchuwmgy6trm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CA9BD40004
X-HE-Tag: 1760037194-198994
X-HE-Meta: U2FsdGVkX18MsWpywtprsrFiTjmSKaIzJxX2XA9jA0RhqLg5+VPG2IJ/MjF+m1rC98JIuRe9rZjGVVwK/bIyheljs958WNBpuohnXaQt/eN8phSzcmFGVtxWnuvos4ljjsSXMCfKsr80eZi2B7fCe71v0MUFsNMEEzs51nlBeHeBEM6tcNqovPc1fgmEd9c12U1zAgHHDQmaUdr9QTIgDKa8EcVSMhI4X8WrvwZx6h7wlqHT/Ld7eAIIkAHB8B8fg8Wk3otK95ScZA4x/RGkT/kHBoCHlwM5WbJG8InfSX2Bl4Yc86IFJfXIsUQIgEFILraxNN9sODhVdLMvRLSXPTPXDNxJPKHh6qHJgzSNHhCBTwLkK8bhzdam9y1tByL4wCDDAnXuhwq+FfdSVzo2dE1l+rJhkkiWGgf7RXoROuQYQRJvRr9gm+U/yTM3WHZ3YIgd00oKxuKaeqwIM+AP0ylXMoJuVwjw0v7G7wYujubSxV5bpnPGPSi+IJgH2czhf03g/iZPrOMmYtK+wmwI5ahRNwWl8XSMFGST2puu64MdHoknFtr3Tmw0sPmip2/+cAQaIsiXpCvs2NEvb9IDAva3zE9fap/Qh0jEFWUTHEQPSCSz7V5aXG4LUl2wk22xxt4+kSHhfDNm6O0aLB7/+/t6gwCkwr1W/gT+QnTBWcJR3rAFmTyJy8+WY5myHJfI8NHoyWgIqWWVeCRfvCYlyKdqYkXUeiUCJMt+AcSL8ED9Z2+VFYhUSroHSys65SctKrpMte6TQbEn76tTrO0R1ccZHgASxfZEGs0a7a+xl+DQDNXDIWSPomdya/+JD0JR5HqIoTeFe0BXLeyqP013ABlv6HXsVj5cWw+HTHLKDSiZ5a+rKh2cvh4wMssBsU6+UCWM8B6/IlJ3hCf0keh4ANusPY3wUAliBvGddfR54xztn4Fum6cd0JozTn7wpCoqMIT/RAAbwEnH37n9GiT
 VZyEY72z
 c0SuK/al/geMrEVs5fj3bMCeheIJNIeMp1hy1CiHFlRHwkkAmgiCYsBiSFyagIK86O12Zdgw0lQ4L5G8HQ3gV7yrPFDPRKxpwEnuKSr32Kq89cMn3nB1gq9+c4fM3p3cmwxIdcy7hd+vW7+pSwZNXNGbOm+L+ZcLGU1C/heUW6NXvqn2lZGEnwEcH2+lBKrVJ7yNCKlDrtDOifNjV2C8Kqcb2bm8jqEixt8B0p+xINxnqYbUHkTXWWbLM5jNaDVYIi416xrK1OG6llymR1XKTpYca1CQXFL1pQGRsFSwGeHRYx82Wjj0YZFix3KstqCEY9MoOaTVbcbO726GHf9ViwKea1Be5s7QObxq8UPv5CxyJIyLjtY3PLw7iJUDIQXYhR/ZAyOOqDxlm6LGj17M/IalNh4y+UBg9ZuDZwkleqomSqDrzmXza824FSshK4OtgSY4bkd77idDBLD1VFbzel9X+MsabuJ8Dh2DdzjXX7icYjDFvrGl5Dn1eFV4iSLhn79wzB7eXAgqtJjMavIj+UrHPbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Just a couple of nits

> ---
>   drivers/s390/char/sclp_mem.c | 290 +++++++++++++++++++++++++----------
>   1 file changed, 207 insertions(+), 83 deletions(-)
> 
> diff --git a/drivers/s390/char/sclp_mem.c b/drivers/s390/char/sclp_mem.c
> index 27f49f5fd358..e1302b1c98ac 100644
> --- a/drivers/s390/char/sclp_mem.c
> +++ b/drivers/s390/char/sclp_mem.c
> @@ -9,9 +9,12 @@
>   #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
>   
>   #include <linux/cpufeature.h>
> +#include <linux/container_of.h>
>   #include <linux/err.h>
>   #include <linux/errno.h>
>   #include <linux/init.h>
> +#include <linux/kobject.h>
> +#include <linux/kstrtox.h>
>   #include <linux/memory.h>
>   #include <linux/memory_hotplug.h>
>   #include <linux/mm.h>
> @@ -27,7 +30,6 @@
>   #define SCLP_CMDW_ASSIGN_STORAGE		0x000d0001
>   #define SCLP_CMDW_UNASSIGN_STORAGE		0x000c0001
>   
> -static DEFINE_MUTEX(sclp_mem_mutex);
>   static LIST_HEAD(sclp_mem_list);
>   static u8 sclp_max_storage_id;
>   static DECLARE_BITMAP(sclp_storage_ids, 256);
> @@ -38,6 +40,18 @@ struct memory_increment {
>   	int standby;
>   };
>   
> +struct sclp_mem {
> +	struct kobject kobj;
> +	unsigned int id;
> +	unsigned int memmap_on_memory;
> +	unsigned int config;
> +};
> +
> +struct sclp_mem_arg {
> +	struct sclp_mem *sclp_mems;
> +	struct kset *kset;
> +};

Just one thought: if you keep either as global variable you wouldn't 
need this. (I would just keep both as globals, but whatever you prefer)

Whatever you prefer.

[...]

>   
> -static void __init sclp_add_standby_memory(void)
> +static int __init create_standby_sclp_mems(struct sclp_mem *sclp_mems, struct kset *kset)
>   {
>   	struct memory_increment *incr;
> +	int rc = 0;
>   
>   	list_for_each_entry(incr, &sclp_mem_list, list) {
>   		if (incr->standby)
> -			add_memory_merged(incr->rn);
> +			rc = create_standby_sclp_mems_merged(sclp_mems, kset, incr->rn);
> +		if (rc)
> +			goto out;

Why not "return rc;" to avoid the goto label?

>   	}
> -	add_memory_merged(0);
> +	rc = create_standby_sclp_mems_merged(sclp_mems, kset, 0);
> +out:
> +	return rc;
> +}
> +
> +static int __init init_sclp_mem(void)
> +{
> +	const u64 block_size = memory_block_size_bytes();

Instead of "u64" maybe "unsigned long" like memory_block_size_bytes() 
returns?

> +	const u64 max_sclp_mems = roundup(sclp.rnmax * sclp.rzm, block_size) / block_size;

Instead of u64 maybe "unsigned int" like the ids you store per sclp_mem?

> +	struct sclp_mem *sclp_mems;
> +	struct sclp_mem_arg arg;
> +	struct kset *kset;
> +	int rc;
> +
> +	/* Allocate memory for all blocks ahead of time. */
> +	sclp_mems = kcalloc(max_sclp_mems, sizeof(struct sclp_mem), GFP_KERNEL);
> +	if (!sclp_mems)
> +		return -ENOMEM;
> +
> +	kset = kset_create_and_add("memory", NULL, firmware_kobj);
> +	if (!kset)
> +		return -ENOMEM;

I guess we don't care about freeing sclp_mems in that case? Likely it 
should never ever happen either way.

-- 
Cheers

David / dhildenb


