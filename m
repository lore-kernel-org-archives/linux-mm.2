Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 966D2CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE3C08E00C6; Fri, 24 Oct 2025 11:57:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBBF08E0042; Fri, 24 Oct 2025 11:57:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9538E00C6; Fri, 24 Oct 2025 11:57:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A5FB18E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:57:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5944E88D27
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:57:32 +0000 (UTC)
X-FDA: 84033462744.12.AE9BA7B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id B36D0180011
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:57:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CJ8AQ5+E;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761321450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xSaGAotvonegYqDLipdghoRR3gYmFE63MavmMNvHheo=;
	b=Z3gRtGjG8FP4svbnl4kjhIFvoA7gz5l6qUEOuZNDQqStJbnUagw7uxfvRzwyfz9SVU5hUL
	hBTWSR1hu0EeVK448zgjAHs01hF13PV6radmqmps0nwBiztb0Uyd828rjzTTKB4gEpUJ4C
	Wwn6sv5wIuxAoxctw54EZupX6Vn6A7s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CJ8AQ5+E;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761321450; a=rsa-sha256;
	cv=none;
	b=DZR6I4xG2Xjxtk14lxyOW9hC0wjTZJrjcSW8Eiy4SIk0KxTkdusbFZpupr4rhdZvdSeGne
	kpJdBfoktNTNIwlIS0bBWrYeN6EESLIg0INIMpllLI7aXG/9Hm2s1Ba7gPgSxw1USbELrY
	pVqplIg/QLpwvUnUQIyPBN6qy4i2+CY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761321449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xSaGAotvonegYqDLipdghoRR3gYmFE63MavmMNvHheo=;
	b=CJ8AQ5+EoqprVs1syGgd3sk+cxIpO2zYMsZnfzMji9eQrBwZMBO0h9rOHxlDkUVWgPYFii
	Xo4R5nKKf9XnX4v8ecxcv/vNL+SOb3fl1klluqbdu3CRlqcMO+cUSa81Cps92nKitzLokG
	jeGoL+iDG7h84LIoRh7lcFJLdCksVnQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-D4HTE2deMzCM2ueY_FWVPA-1; Fri, 24 Oct 2025 11:57:27 -0400
X-MC-Unique: D4HTE2deMzCM2ueY_FWVPA-1
X-Mimecast-MFC-AGG-ID: D4HTE2deMzCM2ueY_FWVPA_1761321446
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47113dfdd20so9173405e9.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:57:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761321446; x=1761926246;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xSaGAotvonegYqDLipdghoRR3gYmFE63MavmMNvHheo=;
        b=P6IjrE4cDQKtMZqeb5TmvcwhlttBkO/6GDDzuMAOun/WPDCYL/yM+8WbFNWZMf/T1M
         8QglAi64jQrBgB6LQJWvDUh/serxOVAMUvj5yn6WuHqLbLtizIVd2Y3cp6YppJrk6KSV
         +ilDAHxPpBfIIHfuj7x4aBlV050sx/GVfSNlgIR3oVOWX2jsZrQZ+xkvo3TmjIbREg/f
         vYU/GvOjGEgcibZPrjFyP9jOVn0bin59hr4qbjVakBgWQkSEBeyWKl2BLsmurImQyXwQ
         VFsoB+ojJMeP04eisRcHrEnC0peJ8pp3HlTvjn9FD3Pywq06v4+pG0d6gkTuvX7BqavN
         zaxg==
X-Forwarded-Encrypted: i=1; AJvYcCWSK/EMebTN6DXsjFGh0yAOIhA9+YfcAzINFzQZ5C0HeIJfREpGmsMSxEorlqGhyJ4TeerCPZkRZg==@kvack.org
X-Gm-Message-State: AOJu0YwwNtkyyI8YlZR6+ZCV4JlBXe5DoEAQ8kAUkVk5LeNe+ma189Il
	kEjThIxBpLiJF9/eOrigGnw/Ey1BnZrO6QGnGw6mVyeSfEf98u5C1he4P/E44/PqPXA1GOKjMvq
	Z3zkEHnUKqJ10tKQImxJDybdVcZiwP//AZ8805jeye6aZKDMnY4LB
X-Gm-Gg: ASbGnctCXHyRb+fmK9S0Nmg5769zTwQpEXzea6cJVegjfZ/GOQqKv53naIA3aRuTEGl
	xO5IKE5yKeN8UMvdqxuJhoXbvi7tSL5ApqNbNE/JJcXyeMxSLkxGDhbBMdYZdjwyTCCIU5r+uyh
	CXIi2d3aGJ4xMbc1tCeDoxdVwc0mzlDLWHiat7uLghNdLXi/1YEaaFf6nVOxmIIYY06hSXXFBlt
	HkjfdpI7PFTMhAsasS+w7s+KLAHNWuyxeXJnp5qhIe1Zby508oYQS+i0uQ3OBJSYBxBtMJLN4IX
	4sV/QLIu5EFkrwpJh5zMHHIXPHbz8icfRERXZPs7a6LAz1rSe1qWkYEO2wyxwJYa+CofYl6X41V
	a+rH062J+WQIPNpOcUh3PX6tMYgoWQMSWJLj2ZBW2UwQGcbjpc2rqMl2dDV86uQmKhErVQKHq9+
	MbSdPN8j9XikCe1miYNLNcS6fIH8k=
X-Received: by 2002:a05:600c:4e89:b0:46f:b42e:e392 with SMTP id 5b1f17b1804b1-47117931c1dmr203634155e9.39.1761321446470;
        Fri, 24 Oct 2025 08:57:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHA4A2hoyfYF06ELU1f5lK86/4VDaYOE4+LD8w0cVkXBoJRLb76v9U0hz/4ouS4xKx4zUaOIQ==
X-Received: by 2002:a05:600c:4e89:b0:46f:b42e:e392 with SMTP id 5b1f17b1804b1-47117931c1dmr203633615e9.39.1761321445993;
        Fri, 24 Oct 2025 08:57:25 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c4281314sm158156125e9.4.2025.10.24.08.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 08:57:25 -0700 (PDT)
Message-ID: <ff869b97-22bb-48af-b109-ca096afed7b7@redhat.com>
Date: Fri, 24 Oct 2025 17:57:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -v3 1/2] mm: add spurious fault fixing support for huge
 pmd
To: Huang Ying <ying.huang@linux.alibaba.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Yang Shi <yang@os.amperecomputing.com>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Anshuman Khandual
 <anshuman.khandual@arm.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Yin Fengwei <fengwei_yin@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251023013524.100517-1-ying.huang@linux.alibaba.com>
 <20251023013524.100517-2-ying.huang@linux.alibaba.com>
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
In-Reply-To: <20251023013524.100517-2-ying.huang@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NV3quHTY6DtySXh37-NI5dGSZAny7VjsBchM5xHB_a4_1761321446
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B36D0180011
X-Stat-Signature: x4rawbek1yoy4usgw1zos6aibddpueb5
X-Rspam-User: 
X-HE-Tag: 1761321449-94175
X-HE-Meta: U2FsdGVkX18/4jOzWhcmGxZ5lLW21syVvNAD6X5m45eGQS/9SEqeDX3mQWXhoyOVtjfpngkF66Qw5jouB02g5iGmpaCJ3uaBeswpKwUdRzY14DOBmHInFws347VBIYUK3Axr644l635ljcm8SILFB4mVu2aqubc7EMyCtY+3eRU/SYy0sdEptsyI1tphr/K759FegyoHtdbyAph66CTmkJrCLqUbKUwMhQ41g5UP/K8C/t1+iCxqSegWORUxxaD+dAUn8gwOKi0pOt6mLlasgJSKX7VX89h3kPoc41slC1PEMXSfFiAOIa6VICxTZ+iUtkqcRb00irsio7ME0S1+MrWXbkOxbGPZhri++jrq8k2Y0uBk/oJ1HYmqwvd/g9mnT1gOuYqH3LvzS1bnxowhf2K/5ighM2QRgemy6+ZV3iHALZBcxBRGUbhsQD1jJT8A1fAUn94hiceQbr9+ZhWsSDk8QQCMi/S0TuFMXb1BY0lEgVMwDhRaYMoDKtTsRshGK9WseMDAv81DSWeW+/JKaZcEjEEYxNqQ0fLOHMCEMXFwoZf2P006r8h2gwewrgbx8iXQxyWis1MO7lS4HWZEgblII6/eVtc2qnw8KdaOUjDm9fr1mUXsdMqgcs+JV3qv6c+JcPaxyM+zzQvP+unZ1987OmWTsdr/LAoyv8XHZaz7HZxlCcbd8IfuzpRneBVqKMTxz5RPiQPpC6zpmlwQGTByrjtAFrsNvCAmtrwKhi5t3I+c9Yd+EhE/hSHpaw1xvyjleMzefzvOt8ANmMh3ydbKmXqp6a066fRI2ji4glppJvUK80hByF3c4M5q5030CWkjg8i/rqBHeFjtVRSi1gMTTTwiJnUUBxrZQGz0KGEnfSSX5M8lUZvfMEJcI0JToTA/3O8bT/FPwa3EnhmoRV4HvanTXMIU5qjRIOT4f0lXIb05zLWsPkAAMao8eVGz7diAOUo++IRFiA+i50W
 0bsNf3/t
 bbRbgp40OC7NFCEm1RZeIwdLiHqJhpfmwY47wzgfko56XDFRzaV2jJEkVRKXkDgHtbJ1x8wciju8VPKl9nK3V+TGUHpefjE4NhEhhkAH5TMT+gYLwoGgwLlQ1uzoAMID00PFAUcaeBk3wTBINojsn8IN3NWXTlmPUmUIBpw4m3VUGGBDx9PbpCu4yFS0OL00kNqiee+eYLtyLRdZsv4joHKAROElY2dxIoOMfofkYo4v96vyFMKcniLVu9IgjOXTl38WHxOlpfR/FkMSEj8bzV70r2e4XrfT6zWcu7cMOKklOXR07qMAwfjCB9ivrUx0jkXrf3LheytVEfG53ftnAwkk/JvFXt8LMupb6d4xBnJJs2RM9cleiUuCV8GS9VIogh1fpKk0uOe2dK0I0in4Iee7WuRmRb9mSxw1+NssDMRr9QT9jsQ1BqVfDYeFnPsHIPts3ReGPO0qQxCojQdbkr3iq5v1+Kukka5kZeCgm9mMLfCNrVIDjsECpxLO9R0K5EZd0l/czohDcqQk7MAXbctFrApltnkYtnmX6vyM0gMqLbmiFGQAc0o7rqoRX7rJLb3ZEE5kv5PepznOSRzkdiDJT5RhOrDky+6/iQgmsXU3Rminlm7qPgrnKfBJEAKn8k/qKQ13eAFXc0i5ydCSJN+V1xeRgB6ZeQRxwwHwX9uz5m1wyl9cyfUS2kcInEfBFtlu4TtIqgXIRBA6CQszv21UZ/T5/h8f4G1C7smSrK84Iw+JlxEkNdXzL9/7tzJyUdsS8W1l3QhtJlxiEItM7XlxmYZ370xZIbGihVlpfdfdu5etY0mGFYAdqLCUR0hCxwURt77zUWzfMq9xH/qzBBwJdeW92WBUs35jh8MMLW6/MKxB8GCdwMFrJG6kUZHINycDUbqbWfGq7mpjwo5s9NvIRmI7qb9RJY0lg8NCXHoCTMj2FxF/rYpI2D0EF/DHq+YtSUEB9SNQxDIFilN4Qo20YflUf
 CZXG1ufe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.10.25 03:35, Huang Ying wrote:
> The page faults may be spurious because of the racy access to the page
> table.  For example, a non-populated virtual page is accessed on 2
> CPUs simultaneously, thus the page faults are triggered on both CPUs.
> However, it's possible that one CPU (say CPU A) cannot find the reason
> for the page fault if the other CPU (say CPU B) has changed the page
> table before the PTE is checked on CPU A.  Most of the time, the
> spurious page faults can be ignored safely.  However, if the page
> fault is for the write access, it's possible that a stale read-only
> TLB entry exists in the local CPU and needs to be flushed on some
> architectures.  This is called the spurious page fault fixing.
> 
> In the current kernel, there is spurious fault fixing support for pte,
> but not for huge pmd because no architectures need it. But in the
> next patch in the series, we will change the write protection fault
> handling logic on arm64, so that some stale huge pmd entries may
> remain in the TLB. These entries need to be flushed via the huge pmd
> spurious fault fixing mechanism.
> 
> Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Yang Shi <yang@os.amperecomputing.com>
> Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Kevin Brodsky <kevin.brodsky@arm.com>
> Cc: Yin Fengwei <fengwei_yin@linux.alibaba.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


