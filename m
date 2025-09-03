Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE749CA100B
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 06:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3347D8E0009; Wed,  3 Sep 2025 02:53:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E5658E0001; Wed,  3 Sep 2025 02:53:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AD258E0009; Wed,  3 Sep 2025 02:53:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 06E0E8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 02:53:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F5381404DD
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:53:20 +0000 (UTC)
X-FDA: 83847022560.02.561916E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2244F80003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:53:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g9YEJPnO;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756882398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=70bJBQTFcg/ajHsnAIc5tswapUZv32i6/YxcawPABPs=;
	b=GfX33xjgoryxptmruGuHUhccm10mI4tQOdZlOnk+8H4Zy3C+HJzNJivQcVw34z0dGU6VSN
	9eM5YMkxiwkDfzZEGE6wUBVio1vBzc/F1RmhAMdjGikymMtcfnG7bSYedq/hV5ulZU/GGh
	1oStI71G9N8IcLdYl674iU6gsmfpn+s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g9YEJPnO;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756882398; a=rsa-sha256;
	cv=none;
	b=3VzEqNygstAi6uyVPa/k6streJThqrbqLlKqFHdonPGmKsHHbt0deUzXVuTRy9ByTFvgXR
	7DocgNYWCAnyItGvYnL20CJTHAF238uz1HDxlstoQ0cdHAGbIinPETewcrv0dhtOI0wH6S
	jnNwJM13YscWWdfC8GaMJqQmclJV8zk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756882397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=70bJBQTFcg/ajHsnAIc5tswapUZv32i6/YxcawPABPs=;
	b=g9YEJPnOh47CeBUS10+dhKD24kLzHk91rpJtOs8/KmpW6DtG36Mol9x8BdpPkLNp8P78Ey
	wboAKUJCou3ffOPUyAJOustjOmM8Nnhrlzk3sOdUuYA4qTUloURYMvxQTsxrMPiRceY2qi
	qty3hzIdlkCgHWW9bhFIRWnLtbSvZUc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-vv32IArBOq2X0cd9i4csKA-1; Wed, 03 Sep 2025 02:53:16 -0400
X-MC-Unique: vv32IArBOq2X0cd9i4csKA-1
X-Mimecast-MFC-AGG-ID: vv32IArBOq2X0cd9i4csKA_1756882395
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3cf48ec9fc1so3117522f8f.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 23:53:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756882395; x=1757487195;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=70bJBQTFcg/ajHsnAIc5tswapUZv32i6/YxcawPABPs=;
        b=GcoZiENxqS4Ra5yto8dewB7Ge0jC/rRmFcCe0mkgG+Fh7ibbqKgvankKyKaSWOxY++
         isYlb5/wEOXxf+KD5HiUbOwQUHiy81UcTdeAGQWt2pzTEc8l/GyXuNJ1xpokdrE0Gzrk
         iqt8YmMrSoTxnSoVPztIKjJAPLT9W+fiD8Fbm4uD8quDhVFk3dJrFLEHjQaszhHbhGwv
         M82ZMXhPWAjSICI+XWCWZOk9689saT+3mEW+cwfuUvaKYS94Frfp1dEHbeFDpwPvcQA1
         RKgbYOaGLMUpFAgCpT2SrkHoxjdSPPgfRLfYjfMgKsgw4hLdvXbHKjJnbodzLir1cecj
         fuXg==
X-Forwarded-Encrypted: i=1; AJvYcCU5Za1qqx1WshOtNpfWJeOw8lj+IVfNMOiq7tg+I94yMj2BgIW9R7yNgrIogJr+xBF7+PQjKK4SSA==@kvack.org
X-Gm-Message-State: AOJu0YwSjc7AvSBRvLuPSfYqmT4u6FEYxd9HCsRzYOSExEPyq68Hexca
	xFBnLyVK3Q7iVGHR0OBVQaps65pAiZmmpX4hlPQTcp1qrE1VVrv5XI87m33SCUWWLol2/04R2oC
	pRK1/sJy4f7K6L/f8w7gRXCdo++SESEelkFLrfzMeIrF+UAWBZOnV
X-Gm-Gg: ASbGnctKF1dtSF5nWXJ8r3A/uRtTyO52aA4/1dInBK+ZewR41G8r2VxuDA7UKZCVKCy
	hc+PncYL0gJxR5o203QJY4cjeWG/hzDqX9FTEKIDndouj1hAVARhFwRdcOV/xoYHg8BMcU57PyN
	Q07yVLcFBtQnFcZbWXmn9kL5pFAneNxYczBYG/S+y2gbeNZ2A9c6SoIZeNSfWiXam4ylPKIgNc1
	YQuO+iqDk/T1HOLxY7q0CpOU2USSJhxCBhcYAJ04+Nk0uI9NRaql9u0vDBvVg5qqoYccCEds+6u
	AD5mT3aNFPPqXtJz75U8E0K0lyQngA5zAb768mABoi0TQ6nXyIxDGpj1pDX3kv0hcluoDrY=
X-Received: by 2002:a05:6000:2dc2:b0:3d1:6748:65fd with SMTP id ffacd0b85a97d-3d1df34f1e8mr10111051f8f.58.1756882395160;
        Tue, 02 Sep 2025 23:53:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0yruhAga9yW6JCJcGMnqV+d1n+KmvFmXuUnB6+Zb3NwS+YvoUrM3+56P9Rlm9hylbXHe6ZQ==
X-Received: by 2002:a05:6000:2dc2:b0:3d1:6748:65fd with SMTP id ffacd0b85a97d-3d1df34f1e8mr10111031f8f.58.1756882394774;
        Tue, 02 Sep 2025 23:53:14 -0700 (PDT)
Received: from [192.168.3.141] (p4fe0fbfb.dip0.t-ipconnect.de. [79.224.251.251])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3dbead0b247sm2935180f8f.6.2025.09.02.23.53.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 23:53:14 -0700 (PDT)
Message-ID: <451967e1-81d0-40ba-b02f-935acd646033@redhat.com>
Date: Wed, 3 Sep 2025 08:53:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: Drop all references of writable and SCAN_PAGE_RO
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, kas@kernel.org,
 willy@infradead.org, hughd@google.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250903054635.19949-1-dev.jain@arm.com>
 <20250903054635.19949-2-dev.jain@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20250903054635.19949-2-dev.jain@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9VjO6daBjkW6it-Mhs_jwRRXQfq1GTKSbLwGmzMxgV0_1756882395
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2244F80003
X-Stat-Signature: edtns7joth1kxq9t87rk5nbaefj9byin
X-Rspam-User: 
X-HE-Tag: 1756882397-494313
X-HE-Meta: U2FsdGVkX1/QNlPmQaaPrQNgm0V/PiWdbdvAUxtACEFqFjhYCSzs4TdmaFncTorDhNHPP1J+PVxjvRMvU9p71AvS4uxfdDkz0XIdFF3iVONiQpiZ5+B2cZPVkrTJ+Y8rABru6aNk+kQYjKb7N3SrcYimsNHRDHr0BbOQF57a4BbjlC5tOCKZGrd33HP6hmwnBwT8FjsOBXKt/rw3paXYuWmj5CPk+2PDGB3YGjUILh77wrQ0NdjuiGO9lN/icb/RgOz979Szz1iOf30sa+10S3sw4kY+fix3N/r43XmR9lsCZMVG850t4zwyAdBvIOiK7t/dwDjowmFLpMHNLERqS8t2lLKoUsGK3K95rdFA9p7t64Q0SHNrnsI6N0oupzOcochtaRST1KK80buWDSnALQiOkKL6mD0DK0wey/1GlZEjfpc2uQ9JcQuoMKXYk1d0K3Slvbfb5D8FXngkxiFtZI7l0pevA7iyvEs+u6dU1j960O0i+Wp/9NR7C3Dyod7K6tbu7Elac1QHiUVYQULqutkSH/cN6EiGLUqRDvSNaDuFRkdB71UbDeWUL5/vl5cOEYgNWSEZP2FYpJ2NNUzBDxJGHyIGY1e2QHJuzRtJLuP9OVZTA9tFvO++xmfxfZhva/9QIW8t7e4wcYkMJtHiiGcLfOOnze1MWeAASMZV6PtQkjesL5kWSXhtPLzVH/ru6+ypQhgoemJfixE/ox8gATX4KYbSp8zg88hyGUi3Sm6gabLYE1rJPTuQ/k9BkeOjYjHyDc20DM/0zBz74vOzD6pOs+P7czRCQnLOCbbtRh71zHpM4y2b8RN8tjFTr1Cahw4dKiuio4V6PhDYuIZ2HGwh8mNWfAYc7cWej26sGwWxamsxp0CwF5D+dffci3CbtbvCL6ZOYQhQfkfZoFpVwvc3oRpxioYw1cN1mBLXv58sWjjxHugKeNIz8+IZRQyYk/jnmxzc9E7X310jr7x
 R2AoucGh
 nrzYJ/xiNYuiWAOC23doCd5yxORO7tgrfiTFL1Nmn/+q9l5hh7nTZKYAU+EgVslfUB15me7sFbWoW4IBPF49w8O9owUukJ+lGhMhWDJpf+9/iybhOpm66keq7nGdpisvFRp3MGDXrq9vDlIrlfZqzRmbCBGTVnr1ZUfz+/vV8tnhDAG7wqOzC3ajLjYzIea1qu+euLmkvUzwmjoi9Z9toGFiDIZqT2EN+95bO0kOqzLUYl7kXRDYuLC1Kv4AgbJzLId3zvMyAKcq4FVKg3K73r7mNaaYDOxgiRpzFVuembd1vCcx04iH7W+R0I74rF0ZyV5yQkxDJYa9WId97NWxf1y6WcejZoCZVCj50qRspD8dTkP8AZMqFQvk7tyNPwFKdbuVD9is/17V5TStHwS3SCKyEFbqUY27EEwzLbE20wpLvAEwU3CbHTcDV8dNYhh1KLj2nuXQeKnT9yoTFnxjmvdp0kAK9toQN12U7Uo7FJlOezHTRZwl3lP7nTbthCHgRjY0ojKtapqBGFFNs/zdlJGIAM2R2pwTvL89apr8kNqwJdHQl6GpPirSZts1R2RFIOSdx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.09.25 07:46, Dev Jain wrote:
> Now that all actionable outcomes from checking pte_write() are gone,
> drop the related references.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


