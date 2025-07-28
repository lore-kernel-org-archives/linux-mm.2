Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C76C87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 08:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91B2D6B009A; Mon, 28 Jul 2025 04:45:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F2BE6B009B; Mon, 28 Jul 2025 04:45:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1B76B009C; Mon, 28 Jul 2025 04:45:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F9ED6B009A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 04:45:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18AFEC01BE
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:45:34 +0000 (UTC)
X-FDA: 83713039788.09.8A9D3B9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 99FF418000A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:45:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cX9YQp8d;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753692331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xOI/nhsp0FQxSML+6RN9rUzsV1D1LgxO16j6gmYC+9k=;
	b=KB+sThjTrlMbRNi50SmBBUm4KwuulBFfmwfKCMlSALJDnLTHaQOHTN6N3JVDKXxkoyLHJd
	E61eH5qZYcTDC+6AvLI5OJpKzN+DdQ1PVd4Os1F0k/WxNNITp9bYXqxA3Vls3NcJ6XWQjw
	2He8kiowP2T2eYV8MvLlPyOg4B1cCbQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753692331; a=rsa-sha256;
	cv=none;
	b=u188TpuFwbpicOflJVfcb0vY4oU5xx8zfsztUnlbzd7hREHJeIlfAkns+gvkLtB4ZXfs0A
	AyN7vKgJu7u+VLGknQKZKvDZHD7wKzd+BlzrMVlAI5I4MrAuVEW9wfAZnOdxfRRbPz0Epv
	Av+e6WJpvzDdaWSb4PTGvEngk55pyBA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cX9YQp8d;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753692331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xOI/nhsp0FQxSML+6RN9rUzsV1D1LgxO16j6gmYC+9k=;
	b=cX9YQp8d4tDASB7UilIfCtmzCAlddBxCXl7i+PzrwNN4eqZwyKsv1RBtRgrcokecXPrcoX
	akR2FxFOMEEHOfS3/z8ThBMRV28L2HloZwbOS+TYwa8/v5x2EPUBq2WxFxBVwWskO86F3m
	glz7EGwqdFscCA5r3NXwfZ2Rb6jNMQQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-446-gdBgZ-2bNoq_4_fKyfXggQ-1; Mon, 28 Jul 2025 04:45:28 -0400
X-MC-Unique: gdBgZ-2bNoq_4_fKyfXggQ-1
X-Mimecast-MFC-AGG-ID: gdBgZ-2bNoq_4_fKyfXggQ_1753692327
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-458881c3f76so4247935e9.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 01:45:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753692327; x=1754297127;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xOI/nhsp0FQxSML+6RN9rUzsV1D1LgxO16j6gmYC+9k=;
        b=t+elh8NqXcxjkt26AGZj97d5dRnuQEeHDlJeWTSUCo2FFzBit74Eg0+9SgT8SEqGSq
         6P3L6CyBeRWNQMWvKOTclABoglju/55AddkKBCgYeZd5qBavGECnHtkZlTjk52nQSzRo
         Q7ErzQJHN/+BiD332FB1wpwzXnMLusujk+KYygOZ3wcytaQ9rLP6Ds73qgtUwY7NsA4O
         IP07MUPybJ5DjauAx2SREOFxGLUzYRJ6IA3FNXC3qvVSA2Vj2tCaHky27EKMtgkUgXvk
         xbE+sLHZ6deMen3wfjnUOkM6fTL/GEmHWSR+RMHB0dp3oZCxWb9+O/rDzB58BWyGt7jW
         5//A==
X-Forwarded-Encrypted: i=1; AJvYcCXfIwzk3WXZlEVpvNVPE54GkkTh/uJMvejquXPY3efaWNmEyumEt+0U38t94WhVcwIJgqjNG1yQww==@kvack.org
X-Gm-Message-State: AOJu0Yx6I/DrqhlGG9blXixzlMGNEXq6N2LgyfFVspLwz6YVlHoE4YBo
	Kzq72u+3G7clsrHexTarFEVOV080oLM5WC4NiOVUV+nrC8QhXsTc2tVGv4w4aF21TCkFti2b3Tu
	2uFnh9ujHwkokJX63M8ll0Mza8y+lYzC1o/eM4lDKghhHm1JHCuvg
X-Gm-Gg: ASbGncshZFUCO8VKeObtFhRUtLrTxYI62q8h+A1IHXb9e6LieOZjKly8mX4/aym9qi5
	8X83pRUhcoCIS6PEftpZN6p/Yg1p6ouknVZAwQSkNdHQHQXYuSo9cqIqQLXYUGpxtb8eZk7MTEW
	xU8H5VWrC9mViUC/6xa9zOzXsN7wfWU2fHR+VMJME+isl+z/PXXqQe5pDOdxU39r0MYzcC0Ekyt
	GeFPldMilYz+Tik/qX0ZPrTHFrWfRfF+6j9EM6IuGk1KdRl/YU40sXKY1IYTJmc7iucbNjLgHbK
	R4hE8D4nTduYsCBsPIppTaKflWhMXGDnsaoJdlfBqcubh02FLXiz0lHo4Wkqpr0iLd0RQITAqAO
	E7tIuHYF+ZxGSvlU8QzDURj3WMTzw3Nm2w8ilbN8wdDeL0+ElmRxelwQ/5sAiaElKchU=
X-Received: by 2002:a05:600c:c4a5:b0:456:1006:5418 with SMTP id 5b1f17b1804b1-458763179bcmr74260285e9.13.1753692326825;
        Mon, 28 Jul 2025 01:45:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0ytbTFRQr+toJytfGYg9ytmkAf7bGWIT/KNRNPVSHmspPTjkBiFTwTnkeGrsjvDaNVuTIwA==
X-Received: by 2002:a05:600c:c4a5:b0:456:1006:5418 with SMTP id 5b1f17b1804b1-458763179bcmr74259825e9.13.1753692326327;
        Mon, 28 Jul 2025 01:45:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f47:2b00:c5f3:4053:2918:d17c? (p200300d82f472b00c5f340532918d17c.dip0.t-ipconnect.de. [2003:d8:2f47:2b00:c5f3:4053:2918:d17c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fa5sm151414405e9.26.2025.07.28.01.45.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 01:45:25 -0700 (PDT)
Message-ID: <558720e0-f145-469b-89b8-c8d6ec41da0c@redhat.com>
Date: Mon, 28 Jul 2025 10:45:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm, page_pool: introduce a new page type for page pool
 in page type
To: Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
 brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20250728052742.81294-1-byungchul@sk.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250728052742.81294-1-byungchul@sk.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3Dad1lxgpwxFxmHJRAuew_IZNelIuCPCP4t_ip6-z6w_1753692327
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 99FF418000A
X-Stat-Signature: w7x3q3md94sr88sazz4ewu6jp7druzsa
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753692331-51939
X-HE-Meta: U2FsdGVkX1/J10z/N9a/HQUWjI/t8BdKgIlzI2ZUnLvWrw9F0LQJId4qosOG6ff4FELxUbff5EBU/LqTldSAzkXWTk1sCwGYNkU/MFJsfB6BdOlcGMEyEw3p6tWWcepf3GUfRkWyPxe3E/CeJPmDxaz0/ITJMovC8Y7rF9ze0R8jiUTStZ3xkLyl3xURepw45WG2HSmzZhPu1SXXzlniJSFqvYpAML+n1LC/pZs2pa2QkvpAhfPl+sy15BhyhdANAHao8Io6WVGXbRESWCOhT1N9HBpV38V1xEh2iudwArVqx4K27Om0LZN0UFgzIgwqPQ7c8W21It44CviPhi+BML/4sEcFOjQrfx2P0RTjlJJqbOBWrowgdDPBgmV2wb79h4/92lKPLnKeZxkeUBl6oVu9EK7DOepRrz2TEp/YrN7qNKo6rKJpjy8FIgTOvM7nfWxrbbDoac4Mj5lW3xAfoud5whXGWQeUFt58NtqaRIQg1+eAxuPbuWEQQed24wJyzKCb0eyJMLOrCcWVRQnzzsKu58mBFX5D5O33CAA6HH+3R9bxdP4WePW57NXuzryvtB7RvCPwfJno9wvX258GY1JnPZ4Sgyg2si9I0laiXPB034K5DKXY84NM1hEVNHbH3D6F17CH+ToANiyigaD2CY5ltBFUowmIFoUjsybnvMDFRiJdgH7+u0vxAt9GfpCcofkRhrFNDXxa88NW8vIFf73MgTTunWRAnvyT2pJfUWBh2+GFf9/aLqAoKn1boN5pNaWflLsnB+O1QQ/Q2/063PUUvM1dIPKoj/J6FDg6bCvDDsFzwE1OYohZDxZ/KfCQaTJzSHdAsfoZlJ6hLP8eZFOTIO5e7i7/kUlMc6Z8jU58lQJBz16ecqj448B0i2CJhKEi3CMtqP9l6fsQ5ECkX6d3GQWwbEH5CV6XcUehQ9upbFxNHENdlRyKUVrc+lh1bVB9ZWXiIOD+t1axdc8
 HqjvMmDz
 vERRqzAYok7T7Y5+18z6/m3xfDnaKAkrm1Nxg9QulC8gZhkdvFpKEfZRlU1sVWFkzs7OxhZ4EwpCbKLltehHw46X4ukTIg0IaDY/zI36MIiT/lvlDFY+xE9KgrmC90dS/8+LK1RGTNczpEnS7sq84UrJS7+dxP5huXs4yiPs8md42phakgkWcZMLJWchgByLhgZ3wP+b/MJ4RysscIKJAIOha8iPF85Y8aO3eoGfy5+hhUVhF1e3iWl6GvrsS8K4vGJqXDT7vHQCY8BE1GEi6JF33LkRssdar3a69UQek83NjqFi0mwEUb1a+X83aFocPqd6ohXw4nKpJFvbJwHqwz49SLPMnNq9YeDJMm5k77D2uxKKUdZAwqTxNlOlDsx+uBvxWJiUYqR5POdn9KIqo8rSCqriGy8yGHpavtNQSSRhQP01oHvYFM207UZB3R7NbAb1DH5oPi/pU1/coZMIUlE3eQ0WQtxLjQZA6CjkZ8HPpU+oulZ8NZTSSF1S1SpCZbMk1Uofuf0pU+1Ol+C6t0qt+ZV45udHnKRUJ5NqRPYdUWxC12SgfQiS5JDWkNUTyh84+EoAR9kNq7j1BS9ou7F04ydYeDChv1Lo1qN9h+4vpOAwuY1JFrEG54cKVW5pwBkaI0ikOYJNzwwAmwhEL5gkEgeZvQ9dPowdp9XwDD1fxgdl/nScXc+6HvGR2X5eXuBqm0s2PYyCj2vO3J0mNYYnHQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.07.25 07:27, Byungchul Park wrote:
> Changes from v1:
> 	1. Rebase on linux-next.
> 	2. Initialize net_iov->pp = NULL when allocating net_iov in
> 	   net_devmem_bind_dmabuf() and io_zcrx_create_area().
> 	3. Use ->pp for net_iov to identify if it's pp rather than
> 	   always consider net_iov as pp.
> 	4. Add Suggested-by: David Hildenbrand <david@redhat.com>.
> 
> ---8<---
>  From 08b65324282bbe683a2479faef8eb24df249fd18 Mon Sep 17 00:00:00 2001
> From: Byungchul Park <byungchul@sk.com>
> Date: Mon, 28 Jul 2025 14:07:17 +0900
> Subject: [PATCH v2] mm, page_pool: introduce a new page type for page pool in page type
> 
> ->pp_magic field in struct page is current used to identify if a page
> belongs to a page pool.  However, ->pp_magic will be removed and page
> type bit in struct page e.i. PGTY_netpp can be used for that purpose.
> 
> Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
> and __ClearPageNetpp() instead, and remove the existing APIs accessing
> ->pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> netmem_clear_pp_magic().
> 
> For net_iov, use ->pp to identify if it's pp, with making sure that ->pp
> is NULL for non-pp net_iov.
> 
> This work was inspired by the following link:
> 
> [1] https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
> 
> While at it, move the sanity check for page pool to on free.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> ---

Nothing jumped at me, so

Acked-by: David Hildenbrand <david@redhat.com>

for the MM bits.

-- 
Cheers,

David / dhildenb


