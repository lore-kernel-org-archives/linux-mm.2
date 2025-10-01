Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDD0CCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 08:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 248E68E0013; Wed,  1 Oct 2025 04:35:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F99D8E0002; Wed,  1 Oct 2025 04:35:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C1638E0013; Wed,  1 Oct 2025 04:35:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E91C68E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:35:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BD3AD140936
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:35:03 +0000 (UTC)
X-FDA: 83948885286.27.6C7D9A9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 628AE10000A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:35:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F3w1XHwo;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759307701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GHOYCWtkEZTeHPNgBnU50nnYMIf4R7PChTS34jXjbrs=;
	b=lwa5Xms4SO5mz5f5Cjc3g28ZdaTxcwzkiDx7Imn29EZLMQ5XQx3X28PU/PR79qMe+Chz1t
	sQrCOA20ix3F3X0RG1X6zXB4o38vMKHjW3/rJ8U+ivM6eBVOh0R41q5ZtwWiHukOOThph8
	JaDfqVkYFzs/UMipIwaRzz9g+Sw/NWs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759307701; a=rsa-sha256;
	cv=none;
	b=4S2k4rpnZvp+WlJrdNSEnlLRdqRoxx4SmY+bmqKPCgDz1nkSPd3+xvK8fyAX5yp7slAr6r
	kUAZKm471Aet+kvbjfYKYCtyWjxRxydjmtksLpCIq8i0NYvkmJ6vM+OekatSgbs6gRerUw
	YqUOuioo/jodvb2zQta7niJuolkfLkc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F3w1XHwo;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759307700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GHOYCWtkEZTeHPNgBnU50nnYMIf4R7PChTS34jXjbrs=;
	b=F3w1XHwoe8M+zF4VCvjLM10PJP4cY96l4wDmfkBDtFbLHgeMamGxooJLDzaIO5LrbD/5vD
	Hd07+w6EdXGyahI6Kom2s1xBCq9xwru9LrJGSXIBTAeR80nNqEk4y0q/Zh6L4VRCghT9Wh
	g8+UUOsJhRCbHu92aGGSfqIaN/Au3K0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-XBzFxvfPNhqhvQK5GFDzbw-1; Wed, 01 Oct 2025 04:34:57 -0400
X-MC-Unique: XBzFxvfPNhqhvQK5GFDzbw-1
X-Mimecast-MFC-AGG-ID: XBzFxvfPNhqhvQK5GFDzbw_1759307696
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3f3787688b0so4173908f8f.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 01:34:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759307696; x=1759912496;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GHOYCWtkEZTeHPNgBnU50nnYMIf4R7PChTS34jXjbrs=;
        b=oR3tYWLMwzuX6uaPNAvpTgzDP9Nn/l7dWvd3hr+cmEZzMI9q5STCS+McUVLpGY+ml0
         LnE9dQDP0s68y/twVd7fEl+cXO5uQVG6wHszNH1vh1WAPrXtoA9wf6x8eJPQ4g8iLG60
         4P8f927BRWp4duSJ6sUqOlTMLTnJqTkBnZcvhfM4Y7hzrWD+pi52TIRxgLfg/MKXKHUv
         XldZcCVljqsyGFyfGhLDfDKnjEwKgSVnUtV/lY0byQZDtj/v/5mynhbG8dugPl3Kl7sH
         JkgkOD7UEVw9gF+rTMXakPdJPYF4M/c/1AhEilNVAexWrDysFv4vI9BHGmJjcY044dLG
         numw==
X-Gm-Message-State: AOJu0YxijlFlMx5ib125mdGkuFIZRb5IiCgd7TqtINbHHdr1kMwuc8+5
	DwZbLuhBA5Pc98IRa40UuyGRGphSX5G/0XXvKJW/RduEJ17IKKl3/JVY+TD/RVJJEX4n1mR9Ng2
	w/sQ9s5Agt4SHStdf8VD23xT5y0BiGrLTIINn6kANOmmN8lJte0MZ
X-Gm-Gg: ASbGncv58ZHAc706qV1JbiLC1RnCq4I+zOoacE7aJkwDtyeUe1YkGCtiOuIzmK3c4ZY
	CFpcjhrppPEd1bf7iw63lqUKfIsCIxrZ+Wkvu7Ru8SM8KIJ8/w1P28Dv49X8ZbPDMWDy+N5dhWD
	Ng8NSOaGw0+v9TxWu5V5Yi9XkUXOFI5Kcma+huUAwJ5VvHrnZ8FWtemD9h/VXaKhfKbDi6lRYRJ
	7naPeMqyfGHb9tPF0+ICTaVSVQOaikM7bevGD3NhZhHrrKHvTOFftw58ZI6PNGDMknOLfqIog7R
	t5ZQ0Qi1qiAs/0q+arRFiL+DaojLXa/jYjFPydY2B1I8w+H8dyZx4zXar6miUsGMC0u5mOVUS6q
	aGeupphE1
X-Received: by 2002:a05:6000:2c10:b0:3ff:17ac:a347 with SMTP id ffacd0b85a97d-425577fdfc1mr2134047f8f.27.1759307696271;
        Wed, 01 Oct 2025 01:34:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFao689kCq+67MSCcnVVrQpMR5na3mtZHO+4w5Pzne5fPgdgTKb0qJV8Oi8G88CmmEvWjevbg==
X-Received: by 2002:a05:6000:2c10:b0:3ff:17ac:a347 with SMTP id ffacd0b85a97d-425577fdfc1mr2134023f8f.27.1759307695849;
        Wed, 01 Oct 2025 01:34:55 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5602f15sm26032795f8f.39.2025.10.01.01.34.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 01:34:55 -0700 (PDT)
Message-ID: <f1218a6d-b1ec-460f-afbe-3f88f3cc44ea@redhat.com>
Date: Wed, 1 Oct 2025 10:34:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch mm-stable-fixup 0/2] mm_slot: fix the usage of
 mm_slot_entry()
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev
Cc: linux-mm@kvack.org, kirill@shutemov.name, raghavendra.kt@amd.com
References: <20251001010651.10543-1-richard.weiyang@gmail.com>
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
In-Reply-To: <20251001010651.10543-1-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zSvkNyykP5EbfB7dj3_Fmty8nmKHdLvZuBIwhOI9Ngs_1759307696
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 628AE10000A
X-Stat-Signature: a7i6yh4r4q9gzbnwxpqjge4w1izfcihd
X-Rspam-User: 
X-HE-Tag: 1759307701-137221
X-HE-Meta: U2FsdGVkX1+Jh3fJydiv6j+wxr2sDHMe+EMxrA0LCP3/+S7TWnZS7A7xjWXU41SBWJPGRxfxyJln26uO7zUjDymWuPtsRKm7XabH/A5u6QrDqpg2ELiPC4X/1grxu+tm+2sIaDkon8sXoVQl0y2MGjKwr3sW7vXg2D2rsr283XUTIbCrKz0brFvY5kpeUBlwZFIlM7F0ZtI3a+/E8TFppRbiZjvEYpnVoMoy2YYdO5JlB24abVwl+vycCXJzs51qgkLILvF/IUibTjElABlgIJNQc9gu/8zhcCflc0LP5obFBt9RgcH8HIX76XNro58tsqXG21sRbWV0jgpjuQ/cDoYjaQcJPWt/ZvOtwHlk013vKav925a9++Fj2ih2SOFXfLukIyqzk45iCcIhoJ0qu8pEbvssPCRrP3l4jSKH35RhAiyio5JfXWVK77T1lB/2CB0wq0RHId/yeGlfUGIuQ60/eTGXAkqN5hu2KUmTQOC4SLNgAMH869EWjvKAxox1xfN/NSkpi4OvywN6yiS2NJI/64u4A6hOlG7gtz6TWa6psgGZo5ehnN/2ZkuYcSXPeMNRwRyeQUVjhaIM+yZ/23KmdAw7fF6MTDFvqBn9lVFPXBjVRgegS4EZ+eaqLw5fmwN8TLoF9GeYbN6+Xxx07OkCI9ONqghkp5PInkfu+nhLb0Sa84Ke0lbD6NrjtW88eGNpCaS1lJI4jq4SJjae/lgoBs2FhBnYwaMwMIiBzYhzK0qsxPISOcDLpZIkGvW+RvoEUzqnSgPNvx/Et4G7+ASn2QNXozVaiv3zEO0MGG6P9xbbbKML3HDCCeTECB6ov8wcym9i8fPX+YyblrUHnsuWdYs6AHx1rjRd1vYktkcICvnmyqQq8Tx5cbnXV3sXYHWqSWjdoAKBen+SwmfbKrXM2zBoS/WT/HjqOAJWpEyTVfrSOCyJIiDcf87Vly4T5s/TcMnpqdTmoaSUaj3
 6wOf41MF
 AjWo5ZXHhGMvEe99Q3u15R7XfqRpgeVzzB4Me8ZWxy6SUFVTxaXjN+05M/Q94x8vPqSRJQGiYzSAJGaqlDMo4QU6fvw5hh4x7G8BgVGABynhiik4AUIAfTHVmLxV2ZvqZyalZYDzO3Fi+YqxLj8M2fD1JDXBlLDz14fnQ185aGhzeLVgiWMB9U4v2O8qMmHz5FcQDwLN6jOU20Shhxyg+TkwuDIgFmXK8HvYfPtUJAMAOKRTY05y8mr9pLou+E2ghUXBWz7VQsOYT5SUNV+keYXiLbx3lzwaXXncuttUzHIpBEMD9KSJlkYySOvGvNKhg2qmiC2Sg0loffjvE81Xz4/10gnV6RxKUskdnrUplJM+szvWuyYa8QdHY58HCS/QrSTLmB3J8Z0AOlgYexDAWGCX+7yIpBq1iW3nO/EkYHy/pIgotRMA8MrDD5B1Ki1U3C9rbEIUAPD86pxz1JiYlza+9xpY3nALtjg+Apz73y4jFcBmPrm2/dU/B9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.10.25 03:06, Wei Yang wrote:
> This is the fixup based on mm-stable.
> 
> The base commit:
> 
>     mm: swap: check for stable address space before operating on the VMA
> 
> The reviewed version is at [1].

I'm confused: why "fixup"?

Usually fixups are applied on top of other patches (to be squashed in).

-- 
Cheers

David / dhildenb


