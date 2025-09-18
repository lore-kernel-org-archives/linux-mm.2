Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9AA4CAC5A8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 11:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2DE08E00FC; Thu, 18 Sep 2025 07:57:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE958E0093; Thu, 18 Sep 2025 07:57:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7F068E00FC; Thu, 18 Sep 2025 07:57:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BDD938E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:57:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76DA01175F8
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:57:30 +0000 (UTC)
X-FDA: 83902221060.15.1C6296B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8F85EC000C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:57:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GCVmkKON;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758196648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u9QFZVg7m5WtffZ4uotaa1g7xGBp2lY8dS9x6qq/l+g=;
	b=oOuAKqptjqVYSqBr5vLJY7SHXmlpPmYiIv6CVczAvWF52Z9ZBnLRnPviKnQP+lJEq15rnr
	hwLP+7cYBcsjefbDsAK9IjLX1KglNY0nVvBamkjMAMoUASnR6fDupoOeGaUjNZJxMU1hPX
	mAdTIPE05nd36oSzxKdNDnX0HyAzivE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GCVmkKON;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758196648; a=rsa-sha256;
	cv=none;
	b=DdAMhWKm+/8yFO/m8ld8F7d0PqW2yeL+UjX982xzIgFZkLYWnEN5fpv8F4kPLyAwZtP4xt
	G4waovmolN+tft1FPNaeSEceQRJUYS4BzvlLrZxge1BH7volw9SbN5eXnabj3+EHgs8YRy
	yhY+NqaVOhxZvtkXhFDLMNszXWlS2b8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758196646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=u9QFZVg7m5WtffZ4uotaa1g7xGBp2lY8dS9x6qq/l+g=;
	b=GCVmkKONkHJ1hkgmVQ+84Voxf5+dDISeuWrBmncQA3hnPHOEwuzyImx0VWDcunQKwgruAF
	Z+UZlYJpa/Qh1hbAqcaFkdOdSiXH2shidQZrOh6c/BmegySO/UQATtB4EN5fHO7SyDGPwa
	yA2L06mB+cWnm780tcqKNEHQ4RJCqSY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-112-eAzSHyTxMpCqGcgClHUzxA-1; Thu, 18 Sep 2025 07:57:24 -0400
X-MC-Unique: eAzSHyTxMpCqGcgClHUzxA-1
X-Mimecast-MFC-AGG-ID: eAzSHyTxMpCqGcgClHUzxA_1758196644
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b98de0e34so8878265e9.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:57:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758196643; x=1758801443;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u9QFZVg7m5WtffZ4uotaa1g7xGBp2lY8dS9x6qq/l+g=;
        b=vdc7lBIQVIoNKT3M2TAhPUWqYhY8bCh9qayrPkd36FD1dLNZIyBe0C3CqjAb/NGoQO
         s7RFkH2CwlGhnGKTUQHy3vyhI5lYgk3xhyGn2w4ZmGAAYo3fk/DPG1Hy9Gv7U1Eh34Fw
         58TcZ07956xajzMioF+dhRWaVpDcdLRk+5sTfQssbkMICe9X5WX/NOAz+4y0ZVKinmdq
         VTR1p/SBK43DxUkiQZqJQhoiOJ18M6OeUr/3sJgJLcgLzruN9MFZwMJFXUzXBCqFnXGS
         yTHWh0icotJV8h83+lJV10Ssyv2UOLDPwb96mZXqf2hNqnOX4/XyGKjcy3HdbtzQR5mk
         jBVg==
X-Forwarded-Encrypted: i=1; AJvYcCWWFooTOKxoGFyAC7v/7uoaYPc6M2MMfg/B8yNDPps706d9i7cI4NYrQiW79hi9yN8VT/Ss2GbZDw==@kvack.org
X-Gm-Message-State: AOJu0YzDSE8CeyQRTRckzCRxa3OiYjNcNKCPz0mK+QQMje+nyEgKs2bi
	kO79IUlQxBoL1dX1XQPfBZsyBnH9yrJGZ3D9jXiacq0d1+iYXei+e472LDY6Xzt+3J1H9H/cFdP
	OqwHGd3CXZKLzjfQSRliNxxk0coGBddVUpdmZtx5tiRCiOW/jpWWt
X-Gm-Gg: ASbGncs0j07vXkj/4qMxcbKPfy5Pi7ztUb25X4NNIy1SdCztMPLWewiTm6fY52Oj9uQ
	AosGrUS/UVI2TOUnt1lT2CFAdDHv8Paqr/zvCgOvof0w9oLQgo/MGOJ+O133+txKJWXHRoG2U4v
	G2pD3vjYGCWvLFnui2GNqkwrSLWvVxGlZ5Y4apwquqgRudy7YgVFq9lFqXGunpw96roCTTjQtsz
	eepS3UchxKESp283NLZaCphfvEyaIEPJRSdqlVEGYwq+FhsDFyb3qLE4jh8mGAUbSgfCOPifpYm
	VC7j/gwOfIeaugtOqOTb+8yxsY13w7mrgtirJcG4U5Yn85riNL2P+VCqh7ERZ6ppdmyAtzF7Uzt
	X1xSckXUgo03BJDfumLFi3aTnAUgH/trMndh0cYnxfZOr4KL806W8J/jfCWKrlNkxFon1
X-Received: by 2002:a05:600c:4ec6:b0:45b:81b4:1917 with SMTP id 5b1f17b1804b1-46202a0e626mr62439785e9.10.1758196643419;
        Thu, 18 Sep 2025 04:57:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHbsgdSeobOixENFmXxQQX7eWA5kipslQfbqvhsBaFLFQ3Iyvdx2qAFSdTxCjPF7a0VHSWCfg==
X-Received: by 2002:a05:600c:4ec6:b0:45b:81b4:1917 with SMTP id 5b1f17b1804b1-46202a0e626mr62439455e9.10.1758196642915;
        Thu, 18 Sep 2025 04:57:22 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:dd00:ca9c:199e:d2b6:9099? (p200300d82f07dd00ca9c199ed2b69099.dip0.t-ipconnect.de. [2003:d8:2f07:dd00:ca9c:199e:d2b6:9099])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbf1d35sm3664976f8f.55.2025.09.18.04.57.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 04:57:22 -0700 (PDT)
Message-ID: <a21a4dbe-ce2f-417b-8e21-3e846d7202d7@redhat.com>
Date: Thu, 18 Sep 2025 13:57:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/6] mm: remap unused subpages to shared zeropage when
 splitting isolated thp
To: Usama Arif <usamaarif642@gmail.com>,
 =?UTF-8?B?UXVuLXdlaSBMaW4gKOael+e+pOW0tCk=?= <Qun-wei.Lin@mediatek.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "yuzhao@google.com" <yuzhao@google.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "corbet@lwn.net" <corbet@lwn.net>,
 =?UTF-8?B?QW5kcmV3IFlhbmcgKOaliuaZuuW8tyk=?= <Andrew.Yang@mediatek.com>,
 "npache@redhat.com" <npache@redhat.com>, "rppt@kernel.org"
 <rppt@kernel.org>, "willy@infradead.org" <willy@infradead.org>,
 "kernel-team@meta.com" <kernel-team@meta.com>,
 "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>,
 "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
 "cerasuolodomenico@gmail.com" <cerasuolodomenico@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "ryncsn@gmail.com" <ryncsn@gmail.com>, "surenb@google.com"
 <surenb@google.com>, "riel@surriel.com" <riel@surriel.com>,
 "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
 =?UTF-8?B?Q2hpbndlbiBDaGFuZyAo5by16Yym5paHKQ==?=
 <chinwen.chang@mediatek.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 =?UTF-8?B?Q2FzcGVyIExpICjmnY7kuK3mpq4p?= <casper.li@mediatek.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 "baohua@kernel.org" <baohua@kernel.org>,
 "kaleshsingh@google.com" <kaleshsingh@google.com>,
 "zhais@google.com" <zhais@google.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
References: <20240830100438.3623486-1-usamaarif642@gmail.com>
 <20240830100438.3623486-3-usamaarif642@gmail.com>
 <a7944523fcc3634607691c35311a5d59d1a3f8d4.camel@mediatek.com>
 <434c092b-0f19-47bf-a5fa-ea5b4b36c35e@redhat.com>
 <52175d87-50b5-49f8-bb68-6071e6b03557@gmail.com>
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
In-Reply-To: <52175d87-50b5-49f8-bb68-6071e6b03557@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VbMUFbMHGGnR0w0wtyZWQ_GO1TO7QGWoT0D6Bl5uKIM_1758196644
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8F85EC000C
X-Stat-Signature: x69zzf3mxw7dj8cnjmc9gbuk43nzkr5f
X-HE-Tag: 1758196646-149180
X-HE-Meta: U2FsdGVkX1+JfNV1icbFVT0t+ylPqRUPSDflUvAbuGEzlKWupul3AB/q+ES9S0TCVoyTDtoHRPMYuKjYuSDQzXAY7pRLPHG/Qgi4pSEKS0p63sMTfrMO8K9rwWSxWoETNn2A5Je7ATVnjBfq13TRbZlWM5OT2G1SktjpuEdEbh6tNgu7pxAkWJwivrl0UQBAeN8TPxgTzTmK9LWEIOrNqVe+4AzSOgg1icm2ztDixm6HEDBNCQAv/CN66k3dwgwLmdIKiQjp50ofOHKilcMKJYzf9I1cWfBZqHeEagFVIpzilezRy/T74s17rWAWvyiDwUim6i6p/Bmd6Nivy4WFGDwXoavDda2xVgGsWD0Uiu6Y7RiqcMyYr9XDbdLLE2xo8DwZ7ZD1o1CUVfNvyNlavGljHp8KGM55n4cK2Mr6Zqq29M9JmiMk7vR9pMOkxAnltjv56S0cKn+iuVTFtQbXmVX8D9Yu/BLhj6JkWR7VQlC4m9AN1mBdeXkxFbkkp2JS+dDyO05n3Gtfu1TUHo0TcDH3nVq9WLfXhpDexL9RXvI8wmNuqSp/+TLXUKxQ/UgnXpM9l1OABmXjlYT/8SwfMobuLWKZBEgDQCiOHJ3WPQ6qs72PoJ97+2l1K/uy0x4S5ErqxayN3sxY6QHG/zp+woeYpwaPXkZK8T+KlUPNGu0sarfxj08fKmlW3PYcWcte5FkO1rQogQbZouHzJyYe7/BcN5cvWEkeBRBpC7BUUj/OLVQ+Dgg4DpymSeSTugtEJJCRG2SsuLLwCKuqS0u59NymXDQ4K25nZwZs2sUI9x3KjI9xgZwupFKgtKBKxdIKSBefhnuPfB0woe+iD/G+jwfZGFyenFhJzYbbuS7jSmpwC8s+N0NoocUkoAotvZdIzLG+y2iYXT8gh48AmVVp8QbL6Ohx8PFOxaxrsUBJWL7wcDeBMi5ZubiR5JbquWVWDKgboZ04TvrQub7x12k
 hCyfIHvB
 hu5fqs88eLT6SlFQU2OcLoTBo2dzD5GoQfwxE5/9V0Ijfd1pEo1uNFsAuv/qSafDip9EEqrGyKRm0JUvoADjqPLAHczV86Yp2b290TtfUI1vQ1TbsJ2JnnaRnvGTMFCzbQRopgDjq+BfEyHJDGuHIRJufISwXW2+EAP+KYax2mUsb+pPY+uOwPq/tRBtyrqLPcRnt7R9hk2Iw9pobzPwBxyvaVptZThCCNxKiRbL363aU9b6M77SiSWpgJyXamAx0wpaEXNdjh4wBF6cG1HR1Kw8caV/bA5CnC4BDXkskjyJpJidQI/8mneWP1MlkjqJpNLwUL6c0Ai3YDIVKjsu1PVl6f4QYnuCqd8mCtoS6sKT7nY4b3DVyoj0eEpes7HS7MLliwL5BZo5ELoBeMljBQGjaRlcGhTdYV25iywfdXei+Uygslvga//smEou+ZK29nKZX/+Qvsxp1gjB0+J+GCexy1/d0kbRAjj4OwHvjaM9bprQIVzBxHskvTvLKkqdwjkLV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.09.25 13:42, Usama Arif wrote:
> 
> 
> On 18/09/2025 09:56, David Hildenbrand wrote:
>> On 18.09.25 10:53, Qun-wei Lin (林群崴) wrote:
>>> On Fri, 2024-08-30 at 11:03 +0100, Usama Arif wrote:
>>>> From: Yu Zhao <yuzhao@google.com>
>>>>
>>>> Here being unused means containing only zeros and inaccessible to
>>>> userspace. When splitting an isolated thp under reclaim or migration,
>>>> the unused subpages can be mapped to the shared zeropage, hence
>>>> saving
>>>> memory. This is particularly helpful when the internal
>>>> fragmentation of a thp is high, i.e. it has many untouched subpages.
>>>>
>>>> This is also a prerequisite for THP low utilization shrinker which
>>>> will
>>>> be introduced in later patches, where underutilized THPs are split,
>>>> and
>>>> the zero-filled pages are freed saving memory.
>>>>
>>>> Signed-off-by: Yu Zhao <yuzhao@google.com>
>>>> Tested-by: Shuang Zhai <zhais@google.com>
>>>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
>>>> ---
>>>>    include/linux/rmap.h |  7 ++++-
>>>>    mm/huge_memory.c     |  8 ++---
>>>>    mm/migrate.c         | 72 ++++++++++++++++++++++++++++++++++++++----
>>>> -- 
>>>>    mm/migrate_device.c  |  4 +--
>>>>    4 files changed, 75 insertions(+), 16 deletions(-)
>>>>
>>>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>>>> index 91b5935e8485..d5e93e44322e 100644
>>>> --- a/include/linux/rmap.h
>>>> +++ b/include/linux/rmap.h
>>>> @@ -745,7 +745,12 @@ int folio_mkclean(struct folio *);
>>>>    int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages,
>>>> pgoff_t pgoff,
>>>>                  struct vm_area_struct *vma);
>>>>    -void remove_migration_ptes(struct folio *src, struct folio *dst,
>>>> bool locked);
>>>> +enum rmp_flags {
>>>> +    RMP_LOCKED        = 1 << 0,
>>>> +    RMP_USE_SHARED_ZEROPAGE    = 1 << 1,
>>>> +};
>>>> +
>>>> +void remove_migration_ptes(struct folio *src, struct folio *dst, int
>>>> flags);
>>>>      /*
>>>>     * rmap_walk_control: To control rmap traversing for specific needs
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 0c48806ccb9a..af60684e7c70 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -3020,7 +3020,7 @@ bool unmap_huge_pmd_locked(struct
>>>> vm_area_struct *vma, unsigned long addr,
>>>>        return false;
>>>>    }
>>>>    -static void remap_page(struct folio *folio, unsigned long nr)
>>>> +static void remap_page(struct folio *folio, unsigned long nr, int
>>>> flags)
>>>>    {
>>>>        int i = 0;
>>>>    @@ -3028,7 +3028,7 @@ static void remap_page(struct folio *folio,
>>>> unsigned long nr)
>>>>        if (!folio_test_anon(folio))
>>>>            return;
>>>>        for (;;) {
>>>> -        remove_migration_ptes(folio, folio, true);
>>>> +        remove_migration_ptes(folio, folio, RMP_LOCKED |
>>>> flags);
>>>>            i += folio_nr_pages(folio);
>>>>            if (i >= nr)
>>>>                break;
>>>> @@ -3240,7 +3240,7 @@ static void __split_huge_page(struct page
>>>> *page, struct list_head *list,
>>>>          if (nr_dropped)
>>>>            shmem_uncharge(folio->mapping->host, nr_dropped);
>>>> -    remap_page(folio, nr);
>>>> +    remap_page(folio, nr, PageAnon(head) ?
>>>> RMP_USE_SHARED_ZEROPAGE : 0);
>>>>          /*
>>>>         * set page to its compound_head when split to non order-0
>>>> pages, so
>>>> @@ -3542,7 +3542,7 @@ int split_huge_page_to_list_to_order(struct
>>>> page *page, struct list_head *list,
>>>>            if (mapping)
>>>>                xas_unlock(&xas);
>>>>            local_irq_enable();
>>>> -        remap_page(folio, folio_nr_pages(folio));
>>>> +        remap_page(folio, folio_nr_pages(folio), 0);
>>>>            ret = -EAGAIN;
>>>>        }
>>>>    diff --git a/mm/migrate.c b/mm/migrate.c
>>>> index 6f9c62c746be..d039863e014b 100644
>>>> --- a/mm/migrate.c
>>>> +++ b/mm/migrate.c
>>>> @@ -204,13 +204,57 @@ bool isolate_folio_to_list(struct folio *folio,
>>>> struct list_head *list)
>>>>        return true;
>>>>    }
>>>>    +static bool try_to_map_unused_to_zeropage(struct
>>>> page_vma_mapped_walk *pvmw,
>>>> +                      struct folio *folio,
>>>> +                      unsigned long idx)
>>>> +{
>>>> +    struct page *page = folio_page(folio, idx);
>>>> +    bool contains_data;
>>>> +    pte_t newpte;
>>>> +    void *addr;
>>>> +
>>>> +    VM_BUG_ON_PAGE(PageCompound(page), page);
>>>> +    VM_BUG_ON_PAGE(!PageAnon(page), page);
>>>> +    VM_BUG_ON_PAGE(!PageLocked(page), page);
>>>> +    VM_BUG_ON_PAGE(pte_present(*pvmw->pte), page);
>>>> +
>>>> +    if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags &
>>>> VM_LOCKED) ||
>>>> +        mm_forbids_zeropage(pvmw->vma->vm_mm))
>>>> +        return false;
>>>> +
>>>> +    /*
>>>> +     * The pmd entry mapping the old thp was flushed and the pte
>>>> mapping
>>>> +     * this subpage has been non present. If the subpage is only
>>>> zero-filled
>>>> +     * then map it to the shared zeropage.
>>>> +     */
>>>> +    addr = kmap_local_page(page);
>>>> +    contains_data = memchr_inv(addr, 0, PAGE_SIZE);
>>>> +    kunmap_local(addr);
>>>> +
>>>> +    if (contains_data)
>>>> +        return false;
>>>> +
>>>> +    newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
>>>> +                    pvmw->vma->vm_page_prot));
>>>> +    set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte,
>>>> newpte);
>>>> +
>>>> +    dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
>>>> +    return true;
>>>> +}
>>>> +
>>>> +struct rmap_walk_arg {
>>>> +    struct folio *folio;
>>>> +    bool map_unused_to_zeropage;
>>>> +};
>>>> +
>>>>    /*
>>>>     * Restore a potential migration pte to a working pte entry
>>>>     */
>>>>    static bool remove_migration_pte(struct folio *folio,
>>>> -        struct vm_area_struct *vma, unsigned long addr, void
>>>> *old)
>>>> +        struct vm_area_struct *vma, unsigned long addr, void
>>>> *arg)
>>>>    {
>>>> -    DEFINE_FOLIO_VMA_WALK(pvmw, old, vma, addr, PVMW_SYNC |
>>>> PVMW_MIGRATION);
>>>> +    struct rmap_walk_arg *rmap_walk_arg = arg;
>>>> +    DEFINE_FOLIO_VMA_WALK(pvmw, rmap_walk_arg->folio, vma, addr,
>>>> PVMW_SYNC | PVMW_MIGRATION);
>>>>          while (page_vma_mapped_walk(&pvmw)) {
>>>>            rmap_t rmap_flags = RMAP_NONE;
>>>> @@ -234,6 +278,9 @@ static bool remove_migration_pte(struct folio
>>>> *folio,
>>>>                continue;
>>>>            }
>>>>    #endif
>>>> +        if (rmap_walk_arg->map_unused_to_zeropage &&
>>>> +            try_to_map_unused_to_zeropage(&pvmw, folio,
>>>> idx))
>>>> +            continue;
>>>>              folio_get(folio);
>>>>            pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
>>>> @@ -312,14 +359,21 @@ static bool remove_migration_pte(struct folio
>>>> *folio,
>>>>     * Get rid of all migration entries and replace them by
>>>>     * references to the indicated page.
>>>>     */
>>>> -void remove_migration_ptes(struct folio *src, struct folio *dst,
>>>> bool locked)
>>>> +void remove_migration_ptes(struct folio *src, struct folio *dst, int
>>>> flags)
>>>>    {
>>>> +    struct rmap_walk_arg rmap_walk_arg = {
>>>> +        .folio = src,
>>>> +        .map_unused_to_zeropage = flags &
>>>> RMP_USE_SHARED_ZEROPAGE,
>>>> +    };
>>>> +
>>>>        struct rmap_walk_control rwc = {
>>>>            .rmap_one = remove_migration_pte,
>>>> -        .arg = src,
>>>> +        .arg = &rmap_walk_arg,
>>>>        };
>>>>    -    if (locked)
>>>> +    VM_BUG_ON_FOLIO((flags & RMP_USE_SHARED_ZEROPAGE) && (src !=
>>>> dst), src);
>>>> +
>>>> +    if (flags & RMP_LOCKED)
>>>>            rmap_walk_locked(dst, &rwc);
>>>>        else
>>>>            rmap_walk(dst, &rwc);
>>>> @@ -934,7 +988,7 @@ static int writeout(struct address_space
>>>> *mapping, struct folio *folio)
>>>>         * At this point we know that the migration attempt cannot
>>>>         * be successful.
>>>>         */
>>>> -    remove_migration_ptes(folio, folio, false);
>>>> +    remove_migration_ptes(folio, folio, 0);
>>>>          rc = mapping->a_ops->writepage(&folio->page, &wbc);
>>>>    @@ -1098,7 +1152,7 @@ static void migrate_folio_undo_src(struct folio
>>>> *src,
>>>>                       struct list_head *ret)
>>>>    {
>>>>        if (page_was_mapped)
>>>> -        remove_migration_ptes(src, src, false);
>>>> +        remove_migration_ptes(src, src, 0);
>>>>        /* Drop an anon_vma reference if we took one */
>>>>        if (anon_vma)
>>>>            put_anon_vma(anon_vma);
>>>> @@ -1336,7 +1390,7 @@ static int migrate_folio_move(free_folio_t
>>>> put_new_folio, unsigned long private,
>>>>            lru_add_drain();
>>>>          if (old_page_state & PAGE_WAS_MAPPED)
>>>> -        remove_migration_ptes(src, dst, false);
>>>> +        remove_migration_ptes(src, dst, 0);
>>>>      out_unlock_both:
>>>>        folio_unlock(dst);
>>>> @@ -1474,7 +1528,7 @@ static int unmap_and_move_huge_page(new_folio_t
>>>> get_new_folio,
>>>>          if (page_was_mapped)
>>>>            remove_migration_ptes(src,
>>>> -            rc == MIGRATEPAGE_SUCCESS ? dst : src,
>>>> false);
>>>> +            rc == MIGRATEPAGE_SUCCESS ? dst : src, 0);
>>>>      unlock_put_anon:
>>>>        folio_unlock(dst);
>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>> index 8d687de88a03..9cf26592ac93 100644
>>>> --- a/mm/migrate_device.c
>>>> +++ b/mm/migrate_device.c
>>>> @@ -424,7 +424,7 @@ static unsigned long
>>>> migrate_device_unmap(unsigned long *src_pfns,
>>>>                continue;
>>>>              folio = page_folio(page);
>>>> -        remove_migration_ptes(folio, folio, false);
>>>> +        remove_migration_ptes(folio, folio, 0);
>>>>              src_pfns[i] = 0;
>>>>            folio_unlock(folio);
>>>> @@ -840,7 +840,7 @@ void migrate_device_finalize(unsigned long
>>>> *src_pfns,
>>>>                dst = src;
>>>>            }
>>>>    -        remove_migration_ptes(src, dst, false);
>>>> +        remove_migration_ptes(src, dst, 0);
>>>>            folio_unlock(src);
>>>>              if (folio_is_zone_device(src))
>>>
>>> Hi,
>>>
>>> This patch has been in the mainline for some time, but we recently
>>> discovered an issue when both mTHP and MTE (Memory Tagging Extension)
>>> are enabled.
>>>
>>> It seems that remapping to the same zeropage might causes MTE tag
>>> mismatches, since MTE tags are associated with physical addresses.
>>
>> Does this only trigger when the VMA has mte enabled? Maybe we'll have to bail out if we detect that mte is enabled.
>>
> 
> I believe MTE is all or nothing? i.e. all the memory is tagged when enabled, but will let the arm folks confirm.
> 

I think for a process it's only active when PROT_MTE was called.

In khugepaged, I recall that we use 
copy_mc_user_highpage()->copy_user_highpage() that translates on arm64 
to its custom copy_highpage() where tags are copied as well.

So that's why khugepaged works.

KSM? Hmmm. Not sure how that is fenced off. We'd likely need some hidden 
page_mte_tagged() check somewhere.

-- 
Cheers

David / dhildenb


