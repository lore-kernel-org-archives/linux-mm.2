Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCA29CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 09:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15B558002D; Mon, 27 Oct 2025 05:29:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10C0B8000A; Mon, 27 Oct 2025 05:29:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F15648002D; Mon, 27 Oct 2025 05:29:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DB3628000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 05:29:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82F2248DBF
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:29:25 +0000 (UTC)
X-FDA: 84043371090.14.99BF955
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0494240002
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:29:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KnjnX0i3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761557363; a=rsa-sha256;
	cv=none;
	b=atVWzHboWNpfAwfCUYoha0JsYeydr24ybDDVpRY4R0RhdbGLGWDVSfqQCyA+FA+of4rrfb
	Wl7qUQ04lClOcIxtoekD537/xeS5h0IVM07lLn3R5x7eVbTFVl1bRl438wYn39nceFmN0S
	uMVYNbOmwdIKP/1D+wkATnUv/lrCiFQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KnjnX0i3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761557363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jl/dK5oSynHQvdUuuR4Mz7gZbj0+FmaCnU04jPDI/7g=;
	b=dYcOcln5SejN9hdODKoDxVAR0uqde2nQoIREcT9/XIfb084bTf5Zby7ROh4uZ4RNG7xSwn
	ImPpMaUY3iwG73TF8rwwLdhxktWgOEhMxoOv9Y74i43IbAs8bb2zbTL7NRYty976J+iTux
	YVinglio3+DmifHCAUtUlplw0YqRTgc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761557362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jl/dK5oSynHQvdUuuR4Mz7gZbj0+FmaCnU04jPDI/7g=;
	b=KnjnX0i3duky/AZCXSbTzV7M7NEvouBXHsuJzHTLrJ+hslxg8FiFX3SxZuNaPCQIa/mc+q
	XOxjsWBsGLAP8CSP1j/wpNt239ZwtY0mcTm0/A5InQhdA8TQvQoEuJ9AH+1KI1oYpH+sty
	/FR56F+a/JJacMbph4EGO3XQtITWsyI=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-473-EYNvLBkBNOyX_G8NUqCA4g-1; Mon, 27 Oct 2025 05:29:20 -0400
X-MC-Unique: EYNvLBkBNOyX_G8NUqCA4g-1
X-Mimecast-MFC-AGG-ID: EYNvLBkBNOyX_G8NUqCA4g_1761557359
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-579e84da8a6so2322359e87.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 02:29:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761557359; x=1762162159;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jl/dK5oSynHQvdUuuR4Mz7gZbj0+FmaCnU04jPDI/7g=;
        b=lbrhJH9raIiaYIOYDhT7Fp8KCMc+vUSXoIDDSqrV1LRWlI+4J8CJ5tcyHg69g4aCDi
         uKk1260WRSVMmGt5JkCtTvJFQO0Xah9uRIssWPs6zlmvK/gU2oyTluEdHU9TNbCsI/M9
         EuPJBU6+VrQfWZWdKwc7eROXoswm9R9qnGf2anrfBBUSkoEz8Ze6Hd3L5YRl4hBGHPdM
         MUyv0pVJGuO7jD3qkP8mryBVoN4v6ONmBe+Yqf6fE3pmnXWiIkf2h1D8v/hCl4YNlovw
         lTl3EIjPkGfCFQkCOXQMaFTYVRLkADgersaSM1e+NuGmkODQZpQUck96Af2x4wuhuKzG
         NRqA==
X-Forwarded-Encrypted: i=1; AJvYcCWGL3JspxBaPjs7qnV+VkrE+pNsfcLKc71+bbgNRvb5LR6ruz+yKbitizAyawziTfMcx612vG6Ofg==@kvack.org
X-Gm-Message-State: AOJu0Yx0o18i+1Ji6mycsv4BZo7J9opOvjs2dj3GA/OoFlnTyNsdPJUO
	IQnYBjyVdmSdsop9R+/6h3QazFDEWkSeCGOFlhbJeqiqysJ/mPDlENEoYOPqa7NdnT+vsdJvrtq
	IUo1jToDN/UMI4XsBM7aytB6lsJGg50bxki1IGn82rTetIkbgiEA2OzHAi7wK
X-Gm-Gg: ASbGncuo/GoGsz3e5dEhHUrIytKYbWJym+c566LxmQJyvP5XIyvjD+QUh9oQugFs1Hs
	bRBKcni2v0f3ddPDzyI8D96tjlbDXc9Ck2csQEjIJFal/bbdzPFYJS7zfqOggsSVpXkIGYx3Rqw
	npN+UnouWYDdm+2QzKcPrUp+ouO2c4qWM7PBFcScKFjSgbKa+2iHecxVau5WnOW2NpEZieO5i3t
	QXdXw7HdVRiHlwXuwdSSVvcVBkgH5taOYqtfFKQHCYxskGVzMXffbV2L09UUVZkVbjvqW0w53w+
	wqEVQHQ20iLgD4HoGAp+wMEs3lhYVr9JRxrrUPNTIhgDp26Uz8HJCTrhGTMasZHODuBFD9Ak1HK
	FhO+r5rMkBn28+Cdqkf5JK/TklUiLg0X0T/cd3aW1fUubU36C9hbm75ASlzkLYlRaBSxe8VgVgp
	sQK+yP2dpcyhE8Jqa4/gYottmeFpc=
X-Received: by 2002:a05:6512:b97:b0:591:c2f8:9a5a with SMTP id 2adb3069b0e04-592f5a597bbmr4225769e87.35.1761557358822;
        Mon, 27 Oct 2025 02:29:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeFOAW1hrpbsW0eQlRbjQxJr+vhA/fG2pz5sBmADxwmWW7wq6SVBBMIi1ckQnF6/ww/Geqxg==
X-Received: by 2002:a05:6512:b97:b0:591:c2f8:9a5a with SMTP id 2adb3069b0e04-592f5a597bbmr4225749e87.35.1761557358143;
        Mon, 27 Oct 2025 02:29:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59301f5fc75sm2135864e87.59.2025.10.27.02.29.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 02:29:17 -0700 (PDT)
Message-ID: <811fd675-b231-45e4-b9d5-636fe63bde6b@redhat.com>
Date: Mon, 27 Oct 2025 10:29:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Convert memory block states (MEM_*) macros to enum
To: Israel Batista <linux@israelbatista.dev.br>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-debuggers@vger.kernel.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20251026162156.12141-1-linux@israelbatista.dev.br>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251026162156.12141-1-linux@israelbatista.dev.br>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -CHfRook_qTmoweu4gZ5D4MmchwSrWQFaOhKOPCvSYs_1761557359
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wu7idh6tssey8ejuanmoxtu7gnq7em9s
X-Rspamd-Queue-Id: 0494240002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761557362-234239
X-HE-Meta: U2FsdGVkX19H7Rytxu3oZn6OoOXhkxIYxv/iQtz7BVfXBGs6CMgOI3xQ8FnNET35Gdod0crvVp/zWqhN2WlY7PhykO5l4lW1rFr1L7pYFC/n/TkiQVGC/nxbwTtjyytkkYZQmhrTh8G/BVWOPXNjDFPXCxDVnIapB4lDXMZAp0eZGs7eiQIxSApyfZldc7fvDrpJnJVrlx7Uz7ZoRqkAgvmD1aTinFRmfWCZ15rRDzVwhVzmqUcyEuY8MDR6to1Bq1+xqpr1R1/Llgy/b3P20HkTYDuc4mhSd/5BAUqF6PYd/RdYVvEkRKbqQJjshqeicvCt4PZkWwHWnXx38iAYJVEjGQlbF+IVIAQN+Xq/wEcuXMWn8D3ke392yevmQt7sr+n9e4T1occBZ5AA+m5YSd5zri4JrYSLztRF+O+JY/1c/tzW105mbjHM8HvYOHC61r9AvJq3ABmHQaBPaaVk6KLKbCMuSHPFnxTKRWk8BeWEDAXrk9sOWrg8/riakB/+JSCIjP0CzQVKsmxV0/TugGCQIbNls4f31aJa7ptNg3yUGK3h4M3Qbi7lvuYxYuORbZZP9nchr98sBQGHrfY2osMEMD0T/97DQWiemEwx8wcoOtdboPcQi1t2u+zQx7R+I3+JLcUJVPDr89p+Qot2f1OcFUTX6yp8fy1PFXkx5xmjovQE8nHqmEpMvrIGKRZmJuI/hLdUqIdOlHfuI9YS+5MTv09/djPolwFDsuCttb+QkFxqdaLjQxqJ329IVx8qaUgBJJ8mXjGUDf6BYKJKDeleJ2MjEnjCQO8aAzf+v7WhHLpWixNzxxv4+N4qamH7oGrCRgAmJIZ0WLCbs82h1NmjDIVN02zpeijCPboRg3UrA+8Ye0xsIYhGQU0cmck1cIB9IJX4PiQcwbZYV+y6KHx2cthB0476ySZA896n2EOnmt4R5hEMhWV1NM1U5rohrJaYIta25uoz/Qbg1O0
 MtrZ9kbN
 83C3HvRNU3dojFnIMvbJ0gq17I8DdjdiIGt/l9GWX7PVc7ZN//c2yqLyIWjSwJH8oJvt14XCSQXjK5bIIg1QQvuG/NP4T2JPVVF5sLW2GLYFpy6bGRPE9iAruaPuHwJLGX9Yrvo4GlRLbRvLlLX4y4K3VOHFvl/1yUpEWrn+739uMJ71dAKel1LyffWwFVclpTVuLbs7X5WZ062MaT1ySTCMoni8jO6YeVnEA12LjQ0KHmmbfkZTm/x32KuxDipnq209KyxNURCNrQElNpf0xP+3zuKOt3ZWPGwifQlhgZKrmujuGoenVqJA/ayid+hrUpCNTtqO9FwEnbuEtvxrhmd8NGeWt/XHlGZ4c0YwJG6AFzz32dCMzoferLuiyPI/K2ibPVnnWRDucH4OfUtLvx8Ui2CYDblZn2p4T6ZceugbRiBDmkEvNmIHzhMzUrC7KLK8v8LwVFHoKOazJAujoWKdrNsy3GpipOg4r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.10.25 17:22, Israel Batista wrote:
> The MEM_* constants indicating the state of the memory block are
> currently defined as macros, meaning their definitions will be omitted
> from the debuginfo on most kernel builds. This makes it harder for
> debuggers to correctly map the block state at runtime, which can be
> quite useful when analysing errors related to memory hot plugging and
> unplugging with tools such as drgn and eBPF.
> 
> Converting the constants to an enum will ensure the correct information
> is emitted by the compiler and available for the debugger, without needing
> to hard-code them into the debugger and track their changes.
> 
> Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
> ---
>   include/linux/memory.h | 16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/memory.h b/include/linux/memory.h
> index ba1515160894..8feba3bfcd18 100644
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
> @@ -89,13 +89,15 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
>   unsigned long memory_block_size_bytes(void);
>   int set_memory_block_size_order(unsigned int order);
>   
> -/* These states are exposed to userspace as text strings in sysfs */
> -#define	MEM_ONLINE		(1<<0) /* exposed to userspace */
> -#define	MEM_GOING_OFFLINE	(1<<1) /* exposed to userspace */
> -#define	MEM_OFFLINE		(1<<2) /* exposed to userspace */
> -#define	MEM_GOING_ONLINE	(1<<3)
> -#define	MEM_CANCEL_ONLINE	(1<<4)
> -#define	MEM_CANCEL_OFFLINE	(1<<5)
> +enum mem_states {
> +	/* These states are exposed to userspace as text strings in sysfs */
> +	MEM_ONLINE		 = (1<<0), /* exposed to userspace */
> +	MEM_GOING_OFFLINE	 = (1<<1), /* exposed to userspace */
> +	MEM_OFFLINE		 = (1<<2), /* exposed to userspace */
> +	MEM_GOING_ONLINE	 = (1<<3),
> +	MEM_CANCEL_ONLINE	 = (1<<4),
> +	MEM_CANCEL_OFFLINE	 = (1<<5),
> +};
>   
>   struct memory_notify {
>   	unsigned long start_pfn;

CCing Lorenzo, we recently had a discussion about such conversions.

The states are mutually exclusive (so no flags), so I wonder if we can 
just drop the (1<< X) setting completely. IIRC, these values are not 
exposed to user space, only the corresponding names are, see state_show().


Won't the compiler now complain that e.g., kcore_callback() does snot 
handle all cases? (no default statement)

-- 
Cheers

David / dhildenb


