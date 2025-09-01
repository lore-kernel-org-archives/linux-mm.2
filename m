Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D829FCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 19:11:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 430748E0009; Mon,  1 Sep 2025 15:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 408708E0001; Mon,  1 Sep 2025 15:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D06B8E0009; Mon,  1 Sep 2025 15:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 16CFF8E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:11:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1DC91609D3
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 19:11:04 +0000 (UTC)
X-FDA: 83841624048.08.EA94BD4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 27B25A0009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 19:11:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cwUzO34s;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756753862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hktqsh8gO9xWQ1D/D1POyV5vXOSvg9V1CEzpXXPFoGE=;
	b=ABEiPoCP/yOF20/ODbIB7BXfgM6I0N6kvG6uBkdxBft76pL7yO9R3U1jf+RIKIcg36BpCE
	EYtjvZ+zTzx/Mh+abSv+b2Wih7LMSsJlG/ULCjE4O1IOYsXmR2VJ0c8VXeCIj6AsjWkKvv
	B8GlCWwvpqeJH2EoYwePYwcDZTVQYKU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cwUzO34s;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756753862; a=rsa-sha256;
	cv=none;
	b=5FvtT19Ae/Rsn82AYboXDJqKVuUFbMHs2INB1YbtaR2pwONIIqrN2VLo16e1XwaKjDRe41
	WyfdW4R1BNSIrxt0JfLB+/JQMyhx/Sw0/3761NFBTvMToleP0yNafbUudEDVQV77v+pCdr
	BtcINwIM/hHPX9IQ/MjKOJSoXsIngis=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756753861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Hktqsh8gO9xWQ1D/D1POyV5vXOSvg9V1CEzpXXPFoGE=;
	b=cwUzO34sFt5OYnjnOGcVHRHaTQWqQ5sMUdvj6Mv0ZnWK91n07UgC/4bA51qkJcaBpZDbB0
	dFVFPvWbNjIDO7uA9/gIaMqzDVqNKoUCE/hDKH96MaBg2ggZZjk0OsM0Pvp+dqZMLUaHYv
	5Kb8Ovs1QZ4icVXkBTtodkAC/yHK/2M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-HDjno9wAMceuQRW53XLuuw-1; Mon, 01 Sep 2025 15:11:00 -0400
X-MC-Unique: HDjno9wAMceuQRW53XLuuw-1
X-Mimecast-MFC-AGG-ID: HDjno9wAMceuQRW53XLuuw_1756753859
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b7a0d1a71so38087145e9.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 12:11:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756753859; x=1757358659;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hktqsh8gO9xWQ1D/D1POyV5vXOSvg9V1CEzpXXPFoGE=;
        b=AB+9Bnt3fJikIMmL4IDoPLq/JwdxozeD/8FjWQXff6NhEzFZ7SzCC3ifPcDc4wRsYX
         fLuzQ0DSpW+6nV5AlaAD3gBonxuaVWuQ6FbJ7/3CHm626X/lj1RcREDjxmfZ5Cc7+nTA
         AvUGdjS/BrPbB5Wh8z8IheUtQ13GW7DCJMQztOll73a87jvCDQiUlVTNlEbCX2n70pWN
         O3Eb61X8K0fKJ7C7MJ/ZeFUJKmovhAIYasRYOxMLvn3Jt1EmJxF9zZnm5kqul1EYUzCH
         owypMo8AadpnxHWtv1mmbw1oWjUy12CDVGxU0xKJyxkBxplL+z4h37pgbsA1MnfQ7Q9Z
         kZWA==
X-Forwarded-Encrypted: i=1; AJvYcCUICXu3StOgj/msGapPaVvgB3e4yOljLlqJXZq4F0UaABxHOU9wwtH5swrh/5Plba8dhD9teWv9yg==@kvack.org
X-Gm-Message-State: AOJu0YyNCnhb6PlFCIfcRQejHZozyam6JootllUpBeCYk0sWENCjh055
	IMQ71Wq91W+kcQ88woU9pQyIRaLYmCETJDTua7XssjXtRS5wjSosO9PFf1d/5ll6KnncxRCM5t6
	0pY7JtNFJuq4VvyqY+vg22AC8lJJuXZ5WgXEi1UU0ZnQR7Wkj8VMf
X-Gm-Gg: ASbGncvOOZK47K2mW8obRZlmH295t/t7jHD1ZdbH38gI+ZjirwKl98Q7c2iDuuOFI2O
	6qU4PjPo7DYeOcS7QwCB4BcloVC+hSnWtywhTOzxXSOGv0eprTo0QoqW1olCLI8YELw3U4n/zbX
	oHyJrTBa1mvc1IlGVAkqM7BsHvOZZhYcKwUbcuQKSf5Z8T6RU3ulxiGfIO1/7WXXuPOVk/y04rX
	GNQqiR+uDt7Xm7wtko3jyBgAfgTjg+2RNRPTKsDZSoBS4F5+FY6wnKU6opFcGyFDatxgZorblif
	8DrJihe4mgaZK0qGohb/EHSEIx127ZmJpdzatMtVP3nviFqpJVbsN78L3d6eir3RUIlhlJQB0Jt
	XyUEnNapuItnyPO+GL/A1w5q6aEoJ+2P5NakpAOYw8Kuz/+mOOyAYTg76MFh6WhV5k9Q=
X-Received: by 2002:a05:600c:1ca1:b0:45b:8d8d:58b5 with SMTP id 5b1f17b1804b1-45b8d8d5b0cmr32972135e9.15.1756753859068;
        Mon, 01 Sep 2025 12:10:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCzYEDhPCaqzntJlqhh6uR24AEmbZv4V5Y8kMkmlsfFlAm2Kd7XcuWxxlMJtCGtQkVfBvkBg==
X-Received: by 2002:a05:600c:1ca1:b0:45b:8d8d:58b5 with SMTP id 5b1f17b1804b1-45b8d8d5b0cmr32971935e9.15.1756753858607;
        Mon, 01 Sep 2025 12:10:58 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b814da51esm146543865e9.8.2025.09.01.12.10.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 12:10:58 -0700 (PDT)
Message-ID: <5a796574-0a3c-4040-b0bc-3ff757402759@redhat.com>
Date: Mon, 1 Sep 2025 21:10:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] selftests/mm: check content to see whether mremap
 corrupt data
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20250831022701.2595-1-richard.weiyang@gmail.com>
 <f8e942de-1a50-412e-9020-1bc901b4243b@redhat.com>
 <61E58B7C-23D0-49FE-8D0C-CE0B672114E2@nvidia.com>
 <0a0b0018-9427-4201-bf53-6aeb251bc482@redhat.com>
 <1D88E773-C11E-4F28-A13A-1A681898198B@nvidia.com>
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
In-Reply-To: <1D88E773-C11E-4F28-A13A-1A681898198B@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pwGqesUwLJTz-iIDJIuPUb15GtIAzJLDGy7Z8lxg9Nw_1756753859
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 27B25A0009
X-Stat-Signature: am5fmykui7jsibq9g3rs4atcm5ffm4ke
X-Rspam-User: 
X-HE-Tag: 1756753861-225782
X-HE-Meta: U2FsdGVkX19yXuXxAgLe+qgtFGVGla1IlwVkISj2ETcf8fadQj3xCCMW4QDg9riDMRz+Q/qHtjIsiZFFTrp95FEkpfrAEleOZ7VTTlZvpgqJcidx8DkXPsvoKXJZ1Escr9IxlhlleAEz37XudzSwUk2jTy1afdLY/zJVQhMTLWhcsuUFEMeFXUDRvZ4theGZ+Y0ErNyoSx07p+ltS9nlwZFrC/ytg96aTy3fPLrKF7+r2qe20Ygfw8Z8djxyMO1pRTRPs5b8MXcNAsr+ORBeQQxvD8o36tZITdCxB4iM2iKscPj913f2ogv5GQU21bVcKmUk4OHO2C262TSfjm4M/447i/uRcv1YDmVbylus9mtwJ724aLHiWyWZOCDnY7KrJzl5opT6lrdGj43hpojLUb5tBi1QxP9I5UMNt2lEmnbPR/wuTOHWuwTe7el2I+tOhil2R0ru3/o+VaXA1bs72iO0hf+5exVRZOSiQ0CyY0p8eikeFpM4Mc5DrTdbdn1Tr3l1u2QsyhX8VMdz/D/8AwqF/zo0ukkc1IYN5neV59gqxjmkTP8npWHV8Fk2C3Jh4CtwLO+JdUNOcpToP7W3CMLeChVHET295T3yC+GYyTgbTvnfdt6PGQMC255apzMm1tAh04jeDAPSe6/E7160f6YSXzUaSD6Yn/ukF03c2bMeM/PvDTI6XMQFtMCT/kZG4bPHSyQiQQeClQKFQrJDNTUKx4Pt33QMRrdDM4nB/v8m9hbXMRBbkkQTEX76GetWaS2ln556qGdXZ6NtK6fAFKMxvvLIkj4XnHdwhpej+8AdyTQIKF+NsPacuCLCcvVaJg6L653u6wIkW8c3GYvLUbB3oA9ppn9PIZ9hQbi3u7Xds0bC1EXm/lY1SsizDNZY7ncknum/Bq9cexkt0iFBjn/mCPg8w84a3+hy93Nn0qMxhEAo7MZLbMUzprHsmHA+Mls5ZeSyRQ6KLuhvJyL
 zd2apHAi
 SFqynYd/seDh7mrHmFJ4svsMwANNC9qg+xlE9fs4SqP5sbMPi4PoI6O6h/HbEnTITZLpV2Mv8E3Eo1QFoGRA6oKyg2w1QR3AGUK8TA7wF2NeWrGBYUWY8mXiiqZgoBt2fPDqr4qaCS1jRDr+NurOlxvvtlciowlgF1wfaOeqcKZWOtiOf5P8d1OmLlxAp7MdZmZCpIqYi+3j6WewN5EZ/G3sdeaQO+Q4E0fSLqHxFmL8o5ton0IX6mqU0ANcKTmIPT9cQhd6m2lsfvL4+GRN3hfOHlcTmZDwjlxuM6bdq0q3CLGMufXsfaDPdXkdCj4mKllv2NLWx1WvxCUigGpTbot2lzt36BNiVsHn6xdksKtyqtJLKNBdw+mAaNsQZm+Xnt8wfCPOo+cf2lcp4yJFMn4Gwo+W1PchoMkbaiEQxnNMfnv8NLEJynz0Als80d5TZ7WtyXydanc4HmnI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>> (a) Will this actually do anything? Also, maybe it does now, but can't the kernel just optimize that out in the future?
>>>
>>> It remaps each subpage of 4 PMD THPs into a contiguous 2MB vaddr range and
>>> perform split on that range.
>>
>> I'm afraid I am missing the "why".
>>
>> I would have thought that a "split_pte_mapped_thp" test would want to pte-map THPs
>> to the see if they can be split.
>>
>> Why is the mremap required? IOW, what exactly is the test trying to test that
>> exceeds "split_pte_mapped_thp" ?
> 
> IMHO, it is an interesting test case for splitting a THP when only a subpage
> is mapped into a vaddr range and in a contiguous vaddr each page comes from
> different THPs.

Right. Slightly similar to just MAV_DONTNEED'ing the other PTEs and trying to
split the bigger range.

Of course, if you involve more mremap, the RMAP logic of installing migration
ptes will get stressed more.

So yes, there are various ways on how to stress the RMAP walk when splitting.

> The mprotect test case you are mentioning would still have all
> subpages mapped by contiguous vaddrs.

Right, it would not stress RMAP as much.

> 
> But if you think both are just testing PTE-mapped THPs, feel free to replace the
> existing one with the mprotect test case. In addition, is_backed_by_folio()
> can be reverted back to its prior version, since it no longer needs to handle
> the case where subpages from different THPs can be mapped into a vaddr range.

Oh, the is_backed_by_folio() change is actually really valuable.


I think I was confused by the implementation that works on a single virtual address
range with multiple different variables, questioning why we mremap at all.

I tried cleaning up that test myself and ended up with the following (it
escalated a bit). If that looks cleaner to you as well, I can submit that as a
patch.

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 10ae65ea032f6..aa0f0502efa06 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -390,67 +390,88 @@ static void split_pmd_thp_to_order(int order)
  
  static void split_pte_mapped_thp(void)
  {
-	char *one_page, *pte_mapped, *pte_mapped2;
-	size_t len = 4 * pmd_pagesize;
-	uint64_t thp_size;
+	const size_t nr_thps = 4;
+	const size_t thp_area_size = nr_thps * pmd_pagesize;
+	const size_t page_area_size = nr_thps * pagesize;
+	char *thp_area, *page_area = NULL, *tmp;
  	size_t i;
  
-	one_page = mmap((void *)(1UL << 30), len, PROT_READ | PROT_WRITE,
+	thp_area = mmap((void *)(1UL << 30), thp_area_size, PROT_READ | PROT_WRITE,
  			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
-	if (one_page == MAP_FAILED)
-		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
+	if (thp_area == MAP_FAILED) {
+		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(errno));
+		goto out;
+	}
  
-	madvise(one_page, len, MADV_HUGEPAGE);
+	madvise(thp_area, thp_area_size, MADV_HUGEPAGE);
  
-	for (i = 0; i < len; i++)
-		one_page[i] = (char)i;
+	for (i = 0; i < thp_area_size; i++)
+		thp_area[i] = (char)i;
  
-	if (!check_huge_anon(one_page, 4, pmd_pagesize))
-		ksft_exit_fail_msg("No THP is allocated\n");
+	if (!check_huge_anon(thp_area, nr_thps, pmd_pagesize)) {
+		ksft_test_result_skip("Not all THPs allocated\n");
+		goto out;
+	}
  
-	/* remap the first pagesize of first THP */
-	pte_mapped = mremap(one_page, pagesize, pagesize, MREMAP_MAYMOVE);
-
-	/* remap the Nth pagesize of Nth THP */
-	for (i = 1; i < 4; i++) {
-		pte_mapped2 = mremap(one_page + pmd_pagesize * i + pagesize * i,
-				     pagesize, pagesize,
-				     MREMAP_MAYMOVE|MREMAP_FIXED,
-				     pte_mapped + pagesize * i);
-		if (pte_mapped2 == MAP_FAILED)
-			ksft_exit_fail_msg("mremap failed: %s\n", strerror(errno));
-	}
-
-	/* smap does not show THPs after mremap, use kpageflags instead */
-	thp_size = 0;
-	for (i = 0; i < pagesize * 4; i++)
-		if (i % pagesize == 0 &&
-		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
-			thp_size++;
-
-	if (thp_size != 4)
-		ksft_exit_fail_msg("Some THPs are missing during mremap\n");
-
-	/* split all remapped THPs */
-	write_debugfs(PID_FMT, getpid(), (uint64_t)pte_mapped,
-		      (uint64_t)pte_mapped + pagesize * 4, 0);
-
-	/* smap does not show THPs after mremap, use kpageflags instead */
-	thp_size = 0;
-	for (i = 0; i < pagesize * 4; i++) {
-		if (pte_mapped[i] != (char)i)
-			ksft_exit_fail_msg("%ld byte corrupted\n", i);
+	/*
+	 * To challenge spitting code, we will mremap page[x] of the
+	 * thp[x] into a smaller area, and trigger the split from that
+	 * smaller area. This will end up replacing the PMD mappings in
+	 * the thp_area by PTE mappings first, leaving the THPs unsplit.
+	 */
+	page_area = mmap(NULL, page_area_size, PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (page_area == MAP_FAILED) {
+		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(errno));
+		goto out;
+	}
  
-		if (i % pagesize == 0 &&
-		    !is_backed_by_folio(&pte_mapped[i], 0, pagemap_fd, kpageflags_fd))
-			thp_size++;
+	for (i = 0; i < nr_thps; i++) {
+		tmp = mremap(thp_area + pmd_pagesize * i + pagesize * i,
+			     pagesize, pagesize, MREMAP_MAYMOVE|MREMAP_FIXED,
+			     page_area + pagesize * i);
+		if (tmp != MAP_FAILED)
+			continue;
+		ksft_test_result_fail("mremap failed: %s\n", strerror(errno));
+		goto out;
+	}
+
+	/*
+	 * Verify that our THPs were not split yet. Note that
+	 * check_huge_anon() cannot be used as it checks for PMD mappings.
+	 */
+	for (i = 0; i < nr_thps; i++) {
+		if (is_backed_by_folio(page_area + i * pagesize, pmd_order,
+				       pagemap_fd, kpageflags_fd))
+			continue;
+		ksft_test_result_fail("THP %zu missing after mremap\n", i);
+		goto out;
  	}
  
-	if (thp_size)
-		ksft_exit_fail_msg("Still %ld THPs not split\n", thp_size);
+	/* Split all THPs through the remapped pages. */
+	write_debugfs(PID_FMT, getpid(), (uint64_t)page_area,
+		      (uint64_t)page_area + page_area_size, 0);
+
+	/* Corruption during mremap or split? */
+	for (i = 0; i < page_area_size; i++) {
+		if (page_area[i] == (char)i)
+			continue;
+		ksft_test_result_fail("%zu byte corrupted\n", i);
+		goto out;
+	}
+
+	/* Split failed? */
+	for (i = 0; i < nr_thps; i++) {
+		if (is_backed_by_folio(&page_area[i], 0, pagemap_fd, kpageflags_fd))
+			continue;
+		ksft_test_result_fail("THP %zu not split\n", i);
+	}
  
  	ksft_test_result_pass("Split PTE-mapped huge pages successful\n");
-	munmap(one_page, len);
+out:
+	munmap(thp_area, thp_area_size);
+	if (page_area)
+		munmap(page_area, page_area_size);
  }
  
  static void split_file_backed_thp(int order)
-- 
2.50.1


-- 
Cheers

David / dhildenb


