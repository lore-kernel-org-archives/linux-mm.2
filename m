Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 324F2CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 07:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FA238E0029; Mon, 29 Sep 2025 03:34:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AF848E0002; Mon, 29 Sep 2025 03:34:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7726D8E0029; Mon, 29 Sep 2025 03:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5CE718E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 03:34:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0EE32B7FB7
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:34:22 +0000 (UTC)
X-FDA: 83941474764.28.BA2A167
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 99DA8100006
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:34:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QwAtxLfQ;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759131259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cN6MysZF1C0J6jyCpD7LyZGkMRtdynqcaCV1B52hGE=;
	b=on2g+WiChES/KeknPqlNxVzAtT7KWZDTYdEzESPf0FHgWTPG+kzn3CLbJkIz09JU2IgJSO
	Lh0+k9zgN4BKbjWhCJim0nPs3eevPrl+HhugaOeeqyUPiCVUY4hFVz8QUG/xVH62jKaHL7
	9SCUbIcguLvDTtsDNxbe7AsveyD0K8c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QwAtxLfQ;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759131259; a=rsa-sha256;
	cv=none;
	b=Lf5AeWShqHBgJgsi6fKgyNUuEkR5+94icAi/w80flg95n1XLgZvgT0mgZ2ragOJCaI6dKd
	8J3qxlDLqWFafQWrV2OplxEGlw3kaVoTUZ6FCvvR32GMwkALLSQR2bf5ODeUBgpJ2bg10c
	n0PYg83gMmqJOuIIEVpdTsleXC6vGUo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759131258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4cN6MysZF1C0J6jyCpD7LyZGkMRtdynqcaCV1B52hGE=;
	b=QwAtxLfQqz7IzFymSo/UVVGs8sy/60Zy3+ibr2R5dMzvDAN1+UDb8kkstYMJxXkdsSBJos
	EQfZ+rTD4xIk3IRIqGeuu1dBLnpkjhx6pJCtUocf5/0mnOYeEEa5IYyyVDbj1BfpTSpIWl
	jCGVaulv3jiDCVwlYiEIoR+NVZ8AL4Q=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-600-JBznoAZgPWCP32zAFHMmoA-1; Mon, 29 Sep 2025 03:34:17 -0400
X-MC-Unique: JBznoAZgPWCP32zAFHMmoA-1
X-Mimecast-MFC-AGG-ID: JBznoAZgPWCP32zAFHMmoA_1759131256
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e4d34ff05so5065505e9.2
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 00:34:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759131256; x=1759736056;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4cN6MysZF1C0J6jyCpD7LyZGkMRtdynqcaCV1B52hGE=;
        b=JMPtYIy6muJ8yCkhE9gPx2RUfCCK7581pHzI6IjAGfz1/2x/MaLgU9pYxA8xBSJt+V
         LMgphDyep+tYswDINIXTzRrPeNKu3x7CfUeI9wjANf8qRPEofPZfil14h/fBWt1gVQra
         62an+egYwtdEcMYQlmQ7W9ZJYEBsUM94OBmxhOO4MJSCRJaLWt9xt6WRKJEk4ZAsHp8G
         DFTOeyaC8Eaky6MexvvcBvtNpvZSBCGzvH+LimEMhzU36yMdyvL0vDCEtyhnItNUyIc8
         xH6TRzI1azDvY5d07oeikTrnJr9XoQiee+/LHmemcNAo3kpAyESWlGC4vysNsdw3Wf74
         Fo7g==
X-Forwarded-Encrypted: i=1; AJvYcCWwRgAOsyd7JpOt1VP2N57SfCCaZGr/MfXYLSlfOgrt1hs9GoWv9tn5P9irv9ABE9jBmUpPqNJl2Q==@kvack.org
X-Gm-Message-State: AOJu0Yxy/v+iK2KtfUCsigX3UAvfhwTDdyEp807XmwYD2jsKFLa8olpK
	3fJCAvmOZZMXAIStPZLqx5qtr0LlKjscTjEoIcNM2sYzXWeHlQMumauKK0cbSO8r6vCx6vgxi2C
	9VG0TSPTNzx7kgE7R+0APbvSMiG8SF0K6CC4gR982BArWdCBr2GIG
X-Gm-Gg: ASbGncs6mBAFhsSTewdpGWn5SrM9EhZSTL363QV09zqu5k+f043nj7jXdvVB00i+IiJ
	2sEKNl8u2FLibDziEWgnWi+SSpoHtrn+JTFRCml7+LSNSSynlFRLz54J7Xb0/sdvCDPRBaeRgLu
	+R4CGr9UAo1qrFlDwYQCluLZMKyT0xApiyiFsLutK6wJ6qZDZEwGxOPGgP8kkxMNkCkm5j+BLxn
	Q+UsimrVSIB1cBtChYc12WHsEFHkE1+C4+JubpjEn2ZMPKiu1nub1NIx7WyOkOn7IPDkQf0t87t
	1A8RQI9r9u4LsscwbTR3KHBRym13SOcb1AxJ6EBfZ3Ane7lOQ6P1mONNwJfbMfma9hZUjkpbTIF
	AlTrcxJ89uWTNgQ1m+mfAavIBEOTJDbSi6BSVXiXK2AiBdR8JyW8srZA0OkLm75drrA==
X-Received: by 2002:a05:600c:4ec6:b0:46c:7097:6363 with SMTP id 5b1f17b1804b1-46e329b441cmr135712855e9.13.1759131256010;
        Mon, 29 Sep 2025 00:34:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGO1W3cLkDsOrAUUj/Y71FAFuKW33ai4dR71vpnx/udDB8eBJ1Ccnl/FvU8H9AzA7aJClyCqA==
X-Received: by 2002:a05:600c:4ec6:b0:46c:7097:6363 with SMTP id 5b1f17b1804b1-46e329b441cmr135712565e9.13.1759131255575;
        Mon, 29 Sep 2025 00:34:15 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f05:e100:526f:9b8:bd2a:2997? (p200300d82f05e100526f09b8bd2a2997.dip0.t-ipconnect.de. [2003:d8:2f05:e100:526f:9b8:bd2a:2997])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e32bf61b1sm90731705e9.2.2025.09.29.00.34.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 00:34:15 -0700 (PDT)
Message-ID: <8ef5e3fd-2ee8-453a-b8ae-584e3d606aa4@redhat.com>
Date: Mon, 29 Sep 2025 09:34:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm: prevent poison consumption when splitting THP
To: Qiuxu Zhuo <qiuxu.zhuo@intel.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, linmiaohe@huawei.com, tony.luck@intel.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, nao.horiguchi@gmail.com, farrah.chen@intel.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Zaborowski <andrew.zaborowski@intel.com>
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
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
In-Reply-To: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: t7XFb-5nK4A9NFLOhaMUmVbKUHHqOY8ZuLUjqzBVGdQ_1759131256
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 99DA8100006
X-Stat-Signature: 1a8e1p1xnxsbixouhbc784a4fzc3wsfm
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759131259-790461
X-HE-Meta: U2FsdGVkX18104POoS7F/mTG2Qz549Bdr1+LOqbudPv+T2oZi3/xeoOIGan1dIlQIZobxRZgPNgnIWrxNWxtiT6HHS97CEmVRZOjap6zJanv0OHsRjqr7BzQf4m+TXl/ykHsQ9TyjdvXHT7dm+clitdG7m6IjeAOFBglmck4srwKjiZZTazNoPaJSufnGTD3mSZzjoQgGzkwTrIe63hmTqHL6AnuUF+gkG2p6ii37WJztmbY7W8BEQ5NaDbi5gx5zBGBRnjbTLdQzlYYptPGZOf6QcsnMovfkbZvy0DRgbTsXxy/nvjbnv9hFRmJhahioWn5OusSnQi4MlGOx5qrXPi4aF3SMK/rysrW0rMew6vpJwzbGRTJjCZ/q07DssuA4OhJOnxHQTmH5vko7XKf3NJuGkC6Hk9/fO9RRnStbhJN7vYruRxETgEdCAwqfQ7wLQe+qU5yagUTdx7ySi2S+Y/FJ48gJD5V+0sb7AYP2lDTSzu9z40zLXYviLyEfd1OVyLzqvtXL3880cmqWKRyuLB0j/FAUiVbuTItoQRWUDgnuzRpPcxx/wEynyvbWEdg3xTrgW26dqRfKtCCEkCacll5wWE5in4IHzXeDwsQle1peA9cdHa7cuvIi4sW6q931rDBiwD67hTFFf1wb4V+4dvw/w4rr7pKME/VZxDIisfnmev1/NQB0Hsig5aQsAQEaSlpZAYNMcQdP3bgA+QtDOMwze58vB+FyHCgr9mEqt0i/4oJHCCuZMcSLmq77+Fm6ISM2yz40L9y6IxP5C8wAl/Ti4Mqagq+Mja+AVdooUfpZcNpW5anfuAvEUKYER9BCE/4Y5K71bLboYUuNOQwcCg3hkJQxZtoJzusVJfx+pC3FivmhD2CETN7j9fWnU4jsfy8Ou6b9FGYrki4sSYYAZbF78nIKNVeIiiMgGo3sqDTt+Ap0sCshrhdgwif0i70ACnGVqGc+Q/5Nkg7yOu
 wADQ+LjH
 1Ohuhcivr0rRLBK1jn3iRsE6Ij7x3zxdb5b/I/2i++LjrVABmbwGZuW3CAni2AmxUx91/4IaDJR9QO+2JcHoFWL0+9i+OLUq4Jaf5ra/g3n6DbQ8o9tcDhPomnGFLshdkn3ZBlW8/FgRWya6q9VSLVL22Bg/khdZRA2NfNGDot+X8M6w9/gWio9GT+75jdThhj7neh2p0lhO42Vv+UOM4H8wsmiQV6dRNl8uTuF1Nmj1bVsfEb4EosqufbmNoUdWUrklwiCFVvHk/+zEKZRZlEl+MjXmlY542eOKTGo4ASvK9UlRIsv6FABv7ww2kiG/Mc8gjPcjL4qVU0CSJYa29MHnVty662tE9eQa190QqgaqRGqoYEkM4aB2GwMi8Fx2lFfjmQ2oMFw3t4y6o7jqedKufobO0xpuS8kOC9n28Mx9YwAjsXFbKsGelBvPoLSbj0tUR8L/pvhq1HjupuU0rKHIuMs3CZuz/LwkaKlGMB0DO7gj1m11nyePoVhqFrDe51toOQC7X1nLhS/9mwwMWmHonmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.09.25 05:28, Qiuxu Zhuo wrote:
> From: Andrew Zaborowski <andrew.zaborowski@intel.com>
> 
> When performing memory error injection on a THP (Transparent Huge Page)
> mapped to userspace on an x86 server, the kernel panics with the following
> trace. The expected behavior is to terminate the affected process instead
> of panicking the kernel, as the x86 Machine Check code can recover from an
> in-userspace #MC.
> 
>    mce: [Hardware Error]: CPU 0: Machine Check Exception: f Bank 3: bd80000000070134
>    mce: [Hardware Error]: RIP 10:<ffffffff8372f8bc> {memchr_inv+0x4c/0xf0}
>    mce: [Hardware Error]: TSC afff7bbff88a ADDR 1d301b000 MISC 80 PPIN 1e741e77539027db
>    mce: [Hardware Error]: PROCESSOR 0:d06d0 TIME 1758093249 SOCKET 0 APIC 0 microcode 80000320
>    mce: [Hardware Error]: Run the above through 'mcelog --ascii'
>    mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
>    Kernel panic - not syncing: Fatal local machine check
> 
> The root cause of this panic is that handling a memory failure triggered by
> an in-userspace #MC necessitates splitting the THP. The splitting process
> employs a mechanism, implemented in try_to_map_unused_to_zeropage(), which
> reads the sub-pages of the THP to identify zero-filled pages. However,
> reading the sub-pages results in a second in-kernel #MC, occurring before
> the initial memory_failure() completes, ultimately leading to a kernel
> panic. See the kernel panic call trace on the two #MCs.
> 
>    First Machine Check occurs // [1]
>      memory_failure()         // [2]
>        try_to_split_thp_page()
>          split_huge_page()
>            split_huge_page_to_list_to_order()
>              __folio_split()  // [3]
>                remap_page()
>                  remove_migration_ptes()
>                    remove_migration_pte()
>                      try_to_map_unused_to_zeropage()
>                        memchr_inv()                   // [4]
>                          Second Machine Check occurs  // [5]
>                            Kernel panic
> 
> [1] Triggered by accessing a hardware-poisoned THP in userspace, which is
>      typically recoverable by terminating the affected process.
> 
> [2] Call folio_set_has_hwpoisoned() before try_to_split_thp_page().
> 
> [3] Pass the RMP_USE_SHARED_ZEROPAGE remap flag to remap_page().
> 
> [4] Re-access sub-pages of the hw-poisoned THP in the kernel.
> 
> [5] Triggered in-kernel, leading to a panic kernel.
> 
> In Step[2], memory_failure() sets the has_hwpoisoned flag on the THP,
> right before calling try_to_split_thp_page(). Fix this panic by not
> passing the RMP_USE_SHARED_ZEROPAGE flag to remap_page() in Step[3]
> if the THP has the has_hwpoisoned flag set. This prevents access to
> sub-pages of the poisoned THP for zero-page identification, avoiding
> a second in-kernel #MC that would cause kernel panic.
> 
> [ Qiuxu: Re-worte the commit message. ]
> 
> Reported-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Tested-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> ---
>   mm/huge_memory.c    | 3 ++-
>   mm/memory-failure.c | 6 ++++--
>   2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 9c38a95e9f09..1568f0308b90 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3588,6 +3588,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>   		struct list_head *list, bool uniform_split)
>   {
>   	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
> +	bool has_hwpoisoned = folio_test_has_hwpoisoned(folio);
>   	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
>   	struct folio *end_folio = folio_next(folio);
>   	bool is_anon = folio_test_anon(folio);
> @@ -3858,7 +3859,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>   	if (nr_shmem_dropped)
>   		shmem_uncharge(mapping->host, nr_shmem_dropped);
>   
> -	if (!ret && is_anon)
> +	if (!ret && is_anon && !has_hwpoisoned)
>   		remap_flags = RMP_USE_SHARED_ZEROPAGE;
>   	remap_page(folio, 1 << order, remap_flags);
>   
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index df6ee59527dd..3ba6fd4079ab 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2351,8 +2351,10 @@ int memory_failure(unsigned long pfn, int flags)
>   		 * otherwise it may race with THP split.
>   		 * And the flag can't be set in get_hwpoison_page() since
>   		 * it is called by soft offline too and it is just called
> -		 * for !MF_COUNT_INCREASED.  So here seems to be the best
> -		 * place.
> +		 * for !MF_COUNT_INCREASED.
> +		 * It also tells split_huge_page() to not bother using
> +		 * the shared zeropage -- the all-zeros check would
> +		 * consume the poison.  So here seems to be the best place.
>   		 *
>   		 * Don't need care about the above error handling paths for
>   		 * get_hwpoison_page() since they handle either free page

Hm, I wonder if we should actually check in try_to_map_unused_to_zeropage()
whether the page has the hwpoison flag set. Nothing wrong with scanning
non-affected pages.

In thp_underused() we should just skip the folio entirely I guess, so keep
it simple.

So what about something like this:

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9c38a95e9f091..d4109fd7fa1f2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4121,6 +4121,9 @@ static bool thp_underused(struct folio *folio)
         if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
                 return false;
  
+       folio_contain_hwpoisoned_page(folio)
+               return false;
+
         for (i = 0; i < folio_nr_pages(folio); i++) {
                 kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
                 if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
diff --git a/mm/migrate.c b/mm/migrate.c
index 9e5ef39ce73af..393fc2ffc96e5 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -305,8 +305,9 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
         pte_t newpte;
         void *addr;
  
-       if (PageCompound(page))
+       if (PageCompound(page) || PageHWPoison(page))
                 return false;
+
         VM_BUG_ON_PAGE(!PageAnon(page), page);
         VM_BUG_ON_PAGE(!PageLocked(page), page);
         VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);


-- 
Cheers

David / dhildenb


