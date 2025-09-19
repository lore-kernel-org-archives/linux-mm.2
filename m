Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A95EBCAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 07:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D55BE8E0053; Fri, 19 Sep 2025 03:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2D368E0022; Fri, 19 Sep 2025 03:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF4EA8E0053; Fri, 19 Sep 2025 03:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ACD418E0022
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:37:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 69636119DB2
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:37:05 +0000 (UTC)
X-FDA: 83905193610.15.E8C9353
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 029BFC0004
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:37:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VfcYzGw2;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758267423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=onYnfN7O6h6JdeAQyEdy6PhEn+y/Y1HMr7KeWOFCWXM=;
	b=kvQj/uy1qL/wQJV8Xg/81ggFQkgXjDVwh25qQrH3dc7rIV9iQasfDM7uu7YYOWxC9u6RHr
	015I6VZw4g7reEaf0fVL3DB0LuRouKpKjQWkmSjYkxRmUeHsWP/pLic3WqrOqMKhzhZq1q
	wEtTel7JK61Ws/Q6TmlhRcpCKnuXP7Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758267423; a=rsa-sha256;
	cv=none;
	b=AZDRL5J6N9ovbhIecqjNftJW+KWwxGwcmYe6tEz7D5Efkq0ECc5dMKj3xcKXQYW7kVcUML
	pVMubfrBwBqn/2IQ1jMS4h6SdTwk9Adal1ztjy1T8Afly+RcBJ1TJ+Paj65POTrasLAfCZ
	Wb1h1RN3iOrihWd1FUGT8k7MJnG61Mw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VfcYzGw2;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758267422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=onYnfN7O6h6JdeAQyEdy6PhEn+y/Y1HMr7KeWOFCWXM=;
	b=VfcYzGw2VTw9LQsNATEG3phh1rlDFtbdfyKHJQIkxvIeyGWDAJWx+45ZyrEuI4vaMg6SgV
	B9coqTKlCwu7Yt/tQy9NPbjPI7K+/aLg88nAuN0ihyKBShEs7WAN8JK06339POg2XJvO+p
	xDeoDIPMycpRVKWeKJ1hllCxLcGMiMU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-YDu0wjZRONSOGWU0IYpr9Q-1; Fri, 19 Sep 2025 03:37:01 -0400
X-MC-Unique: YDu0wjZRONSOGWU0IYpr9Q-1
X-Mimecast-MFC-AGG-ID: YDu0wjZRONSOGWU0IYpr9Q_1758267420
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45f29c99f99so10949725e9.1
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 00:37:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758267420; x=1758872220;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=onYnfN7O6h6JdeAQyEdy6PhEn+y/Y1HMr7KeWOFCWXM=;
        b=qPgtUqbAycm8E3x0YAlsCjmMzFoxBcothXz+wlOir+liKJ8+i9JHo2xapV99w7a7Pn
         vs6aS4BK4p842Y9ExI7PIxPT7w+cK24XYMVWhPndrZSMfO+7zIZ9DHojbYu/JeqO+Tpv
         ekpM64rcqiY4yTGLZwbOfWYGORctHAsgCSv+a+gSy/tLwd4cVSTUnW94KV4RU6hra0Jh
         o58VQebEoBzfQ2Uq0YX2zTxb9/3Us/Tr7ooNQymOhXzeJwM05u0EjKmK8U+HSxQT+KnT
         NTc1yq4WYvA28MKpkoCKYenRzLXtICdPT/B2mFvnc2EEDeVRdE16+wTKIIZF0mfkRrHb
         +8wQ==
X-Gm-Message-State: AOJu0YzDIGtEiTLZ9LLuyLuXL4pUV/nu6Q/6AZXdq+of3AZUiDvJh/F+
	S7tG4Kc9HUqYMIZ/wLiLsBUmkEYZvBwHiQfZnrgXgTSLAEnEtRP/YsX1CFTqqKejvklji213iLQ
	jRUMVQfriHe+4FU+1AECyz/7dtB7i4CeV6Wk6oHL7O8gIP9bkodJF
X-Gm-Gg: ASbGncsp9Nu/9Z9+tRX/3YK+bJkUuowCqNQHxkqxvvYsi9xW/uJRw01x6pJVzqX1qqn
	ir/1Usl4bUsfulRNQDZ2d+yTkBJyuTGHg/oN6r2J6xtstD1R6CrfKlm3NYMnGlqBaLITf3E9Xie
	Bxbh3rD00pk8G3w26h94JB1oWvnpCbR5zBkUcGTbW1d86tES5GFvpoMXsuJ2BcJLppoQkUn+944
	e0gvJSy3x1IdxekSrhuO0dp1MNCB92lM8dmWzoDNIaPlA7Rp6lddZOkILg2OLWk43+jwJZhfqzd
	D27KEHDus5eLaDUfsRvlbZbvtBm9+gN+Kw0JpBKSWOT5FjIVjRm4LUiMWjsPWRiui+T9Aqpt4tw
	l8U/vCy/9wk+WjrW+cgMlZNleTvaYyZZ5Sc8ebu4NKNEjlPu37ESimheiPHiZwtVqGuFA
X-Received: by 2002:a05:600c:c162:b0:45d:e5ff:e38c with SMTP id 5b1f17b1804b1-467ebbbfcdamr13021215e9.32.1758267419829;
        Fri, 19 Sep 2025 00:36:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTxaAUxiRWrqFd1XkZN0PGrQMcjKQLqY98U3DiPCIVM8rIgNKrA12WQvjG8was+u+TQhpv/w==
X-Received: by 2002:a05:600c:c162:b0:45d:e5ff:e38c with SMTP id 5b1f17b1804b1-467ebbbfcdamr13020985e9.32.1758267419443;
        Fri, 19 Sep 2025 00:36:59 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:5600:727b:b2f6:94a1:a51b? (p200300d82f235600727bb2f694a1a51b.dip0.t-ipconnect.de. [2003:d8:2f23:5600:727b:b2f6:94a1:a51b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbefd5csm7277363f8f.51.2025.09.19.00.36.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Sep 2025 00:36:59 -0700 (PDT)
Message-ID: <66fdb874-1fb1-41c3-86ca-97755d09de9b@redhat.com>
Date: Fri, 19 Sep 2025 09:36:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2 2/2] mm/khugepaged: remove definition of struct
 khugepaged_mm_slot
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 xu.xin16@zte.com.cn, Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, Kiryl Shutsemau <kirill@shutemov.name>
References: <20250919071244.17020-1-richard.weiyang@gmail.com>
 <20250919071244.17020-3-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250919071244.17020-3-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xttLYLemNkfpF9rM4KhoxZ5iSwI7AgNaZ3BGu4bYPqg_1758267420
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tdg6x7cdga8ee5egw7aaajctzmo8tf3n
X-Rspamd-Queue-Id: 029BFC0004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758267422-546046
X-HE-Meta: U2FsdGVkX18/LWtVDknO/Z3rTyI75tAGGB1fH95lb0b88wQJ3oboUOGkZkvwlFVSYYO4lCghSw/Po6w6BlNtnO9ClvKcRroqaxP2QWtu9bRB85eVflWiq8P0KCimUwfVH39F5heaCMt45lk++2/LNVYHTQ8Me1jco5EVLTYjMlVG8yFdec6TRXgSL7uuz6GT8w/BX2IegIF2URVyVruus8Xg5v1IV2nEJhPRUOdNqEFVEKsyYKOEaP948or2E71D8+ce2IMKvUZMKuIEqQ4iK8dszZio2dexcA9cTcsk6UZbQ5+pc7nvCQOUG0/AxgtkVb++LVlHHKeU3N4MdJkCXetotu1qWf/E81ZFtunV3CRLtfrZA6gCWjwGpWf1WfB+ZnGHWPSxdkJZhrXZyOFSz3ECQel6CaDnP+UVkifl2kFj0NOStPFQNDE1HuXfvu2zwYZ4bhpP5zEGeDIKYSBf53cumXOFj1NhvhuS0OvrtRtCvTRhbkY6e/Jz5YoFDPCZ5X9D5MQ39oxj3gXYfQgtZNPz//RyfGPf6GfI4n0hkaeV7nw+nid5aWNCaFCUAGkSRIT4feaeuSCvFrt7pEYEQkVnUa9p8xplWOdo2ZkVYntcpsfuhkCbx+Wh/MLY88Dp8lj6pVRvk5u6Iwggiuj9GYpuWKUs65MV27EmlmkYyD12ufKUB1HMV7Sfv/fttAY63AXOoIFP+XuYTY8NCaHsfmKD33YwWqMfziSG8qFdOzhRuTyrT9uKpboEp74FT4yW7/fQEDS45ju7NkFzwFyVTiyMOifjxrUsxO7o0x7Cmx4t0ravJ/HZ/1BFGR7Dz5WVw7XnNGtSijvAX/29bkmszS/NtNQeZbs+aWpqHHxP0foj2BGnnaqgg8fmYi+MvdwLKBfH+iWYwJLnsLHapJVLDzKXzKNuFAXqkNmJYNLV8xhTaJ3jbKih6YLGHgiflsr+ZOruOxhINWmlPOyR3r3
 0ozNoWpR
 8iPBclX1RH62O7hE2F+HaJcCASKH+VjvITN4xauZuE8YFXfR07RbeqFiQw+QZoyy5Wk8o/a93FgXG8+49AU8t3q1dK4S6fns6Cta7bipV4y4Z6kuBY23EkNhyLtMjM1UYRm4vDK4z62aeULm0DenzDWJ545KYAdrzE+LXMbuUJNrCb5PHTRuwXII9LzeI8aLjvDYznCU9PjUFEMx1m6ekJkM2T+4/KXcSVIieexsY/tPjRYMR+WHSErMwppgT5ju+1L0PawTz8Yl/lVNkE26qTwuAJBwyP51CAWQIUZOQh8r6QzHmnyuombMlY9cl1nI7j3etTUNTVx3+nRVlueu73zPzYJVxcBWRkTGlG39vRvAQE6RTwD0nnzAal9RW7/GZaKfCjCS0pyQ0BN9CcDuo+DItosMPCDVVL5jq5mfuQQrWloRlV2S0EhOdgdjDPWXQ7g3LXvMQ3lvGgqfMGhlAxcwCAwwYnEvn0Td6ktCiM3yI9Vp6qqC+m6PHEFGYvkb9UFWk0pM/5DL4PSENVKTSCyQqe8OaryDoDPgK6W4sA8HUeVo8gcwQGj94VoZuliXTI/n8/J0fIOVt2fCqi2FLHy7NMHEiJ5HARNFvuGR/bOq1rYIfDEA1clfe9nrLXcm+x/EnWHCPzffbFOckHkHeoP0UmV66a+Se/oCIiKBJiGr9Omc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.09.25 09:12, Wei Yang wrote:
> Current code is not correct to get struct khugepaged_mm_slot by
> mm_slot_entry() without checking mm_slot is !NULL. There is no problem
> reported since slot is the first element of struct khugepaged_mm_slot.
> 
> While struct khugepaged_mm_slot is just a wrapper of struct mm_slot,
> there is no need to define it.
> 
> Remove the definition of struct khugepaged_mm_slot, so there is not
> chance to miss use mm_slot_entry().
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Kiryl Shutsemau <kirill@shutemov.name>
> Cc: xu.xin16@zte.com.cn
> ---
>   mm/khugepaged.c | 57 ++++++++++++++++++-------------------------------
>   1 file changed, 21 insertions(+), 36 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index e019ea2cbab0..88ea92c64bf0 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -103,14 +103,6 @@ struct collapse_control {
>   	nodemask_t alloc_nmask;
>   };
>   
> -/**
> - * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
> - * @slot: hash lookup from mm to mm_slot
> - */
> -struct khugepaged_mm_slot {
> -	struct mm_slot slot;
> -};
> -

Looking into the details, we remove the last entries from this member in 
d50791c2bee9 ("mm/khugepaged: delete 
khugepaged_collapse_pte_mapped_thps()").

@Nico did you have any use case in one of your scanning-optimizing 
prototypes for khugepaged_mm_slot?

-- 
Cheers

David / dhildenb


