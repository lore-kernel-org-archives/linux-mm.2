Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7616CA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 08:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37A638E001F; Tue, 19 Aug 2025 04:54:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 351A08E0002; Tue, 19 Aug 2025 04:54:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 240468E001F; Tue, 19 Aug 2025 04:54:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F0C08E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:54:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD607140665
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:54:39 +0000 (UTC)
X-FDA: 83792896278.16.6DAB9A9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id A81EF4000A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:54:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JpxGGmub;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755593677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2GIAX6Nq7HAe3wQJY59KU2tqqiWvi4h1Hi421Hv5T8c=;
	b=ClgpSpi96QcFFoTq/m6zokhik3SRW6/HS3cDsTmEHw2EkDkagtypCCxdM4bVIVIaHaMs/y
	hLCsaslTQHJaTnwmtrQqrJLsY4rjeo1GIY5D3hVIPAfi0FSTP8UsrE6grdzSCI7mMs2uLC
	zG8gkNksV3u2Z7xET38b7t3JD/mJEgM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755593677; a=rsa-sha256;
	cv=none;
	b=mfR9Gr8ES3vOXKSJWSryvNi2S4GIVHgjoN0GdaoOvUD84Z9aaxFJHEyDlcCcgPn1073QAy
	xiXWCA0UgIG9kDKZJYYJqLlnsbmLOuoTbFTkPUs/RpUZi96YB598dB0be6nk2xzTE1kmJm
	xNqb2/ApXBEG9C1neOgX6S2k+nKResQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JpxGGmub;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755593676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2GIAX6Nq7HAe3wQJY59KU2tqqiWvi4h1Hi421Hv5T8c=;
	b=JpxGGmubE74Gkjf0TClp7G28m/a+Qofo6pSi5ruRwFkqM1ck6dEBdoNoqZD+nsoW5RHPFX
	lAvMuczoMR1O8Ww5JALX1vpl6hsrIkTn7CQmWuBaAQmODSVw11sWBKOX1tFOQ/0GS0a3fI
	dln4rlp5WX/2BlwL67Z2ntuNDBkTmGQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-402-vRymWN9nOlmxZhsew4yC2Q-1; Tue, 19 Aug 2025 04:54:35 -0400
X-MC-Unique: vRymWN9nOlmxZhsew4yC2Q-1
X-Mimecast-MFC-AGG-ID: vRymWN9nOlmxZhsew4yC2Q_1755593674
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9dc553704so3405971f8f.1
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 01:54:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755593674; x=1756198474;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2GIAX6Nq7HAe3wQJY59KU2tqqiWvi4h1Hi421Hv5T8c=;
        b=WbTE4oFBt/40vFLUdJI8YvTEh9z86LMYnOz5EMwZEeN9c9gdKZl83+IEE/p2B1nwey
         7SaDb8GKptJmMtaPxTfjwU4TiShPXKae9ywH4WuEZb7s8edejyXLoOJnnHnNpFy8Cra6
         Zq9IFACb9e5B65WH6x+Xk4M40EFb86f7DWut0QnCb1XRMBXPHGD4C/XwT50u4betjbih
         XQyty49XpYv4BR2dY7Hddk4Vm7cLSZ6t24EOIe0hKieI+++gX8Ie7K/ryPwATXMNGGXd
         9mOB0Em4kLnBV/TSBF4UDqwCanMaDD7bdUwjPv4zj1AMG5Acqb3PqriTCWty4AraZaQW
         YuoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLklK3wvENotFCKnB8c4MefwO/OJ9mwt1qyWu+py6ftjYVhxLu/l9h+WiU0qLNz8Ca8J5+wCugcQ==@kvack.org
X-Gm-Message-State: AOJu0YxoHjjvUspqvtgqjjXmC1rUlGGRSfCkwbaiOatXQoYP7K4CWOEf
	3I7IFBiYbp/+/NKRw50LNvcIwhfYw39JrUjPcbdZo7a1LeIGquUrdKCBqVrwOZN1UtP286Zvxgg
	uxN6hk+q8WAG380fB9pG+MMmvepkwMTqUNHn1qTS6N5WDJ0mOmw1O
X-Gm-Gg: ASbGncv4eb12w2nASAcs7MxIdqTFz++b5m0XBWetu0KGRItxMny8AYs81LLXFREbZ9q
	K9eUuxn9AXS2Cty2UGMbs4nKD1iKxAsDtvexIr38sd0AB0M+tWhyZ2qDAqoYMn2KNhAkAsi4VyG
	u9eIb8gntqegRuGFXUBXKchW6QG/A0FyWSXoAyyKokIZ7fx8gtvmNF5QbjaXqojkAJY89VGmEb7
	YvV1otxLBfem/BRfjR1Vw3xEhzviT9GGBWwhURsakv4Rdoj/La+Kg4mM5ERIkBHI34I5P4UmJ0H
	xGERmnXFzTsbFEfVd2kGFR0d18NdV3FMIt9OwALzIMzSEC9L1Lk3o+DrREHRhgEoqzlpphnVsya
	ZVyc/ADvCs5pwqggbrBwATHI9hW4yXdhvueG2Iff9mpguudZyfnKT2pSQ6vPZ+8PNPmw=
X-Received: by 2002:a05:6000:2887:b0:3b7:7680:35d3 with SMTP id ffacd0b85a97d-3c0ec09eedamr1193316f8f.37.1755593674427;
        Tue, 19 Aug 2025 01:54:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEBx+g1KE59r6WAwYU95cz0a0anPGXIMLeDTaZZc18sEosWBDMgWHB5aYADzmqt0aRx3a0pHQ==
X-Received: by 2002:a05:6000:2887:b0:3b7:7680:35d3 with SMTP id ffacd0b85a97d-3c0ec09eedamr1193288f8f.37.1755593673846;
        Tue, 19 Aug 2025 01:54:33 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:8700:71be:5385:87b8:5a98? (p200300d82f07870071be538587b85a98.dip0.t-ipconnect.de. [2003:d8:2f07:8700:71be:5385:87b8:5a98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c0771c1636sm2742820f8f.43.2025.08.19.01.54.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 01:54:33 -0700 (PDT)
Message-ID: <268d9c9b-4c48-449c-97c7-33534fb23fa3@redhat.com>
Date: Tue, 19 Aug 2025 10:54:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/5] selftests/mm: reimplement is_backed_by_thp() with
 more precise check
To: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
 wang lian <lianux.mm@gmail.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250818184622.1521620-1-ziy@nvidia.com>
 <20250818184622.1521620-4-ziy@nvidia.com>
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
In-Reply-To: <20250818184622.1521620-4-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: a1aFvT2q8ITCQimdRqwp5yFNpJeh-1HOUZmS5tLry9k_1755593674
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A81EF4000A
X-Stat-Signature: 8jeigrni5465zetoadsb8hqn1dgfmpdt
X-Rspam-User: 
X-HE-Tag: 1755593677-969524
X-HE-Meta: U2FsdGVkX1+t+PYaKehmrzquXc+sRUsJsTPkYwK33CduzrR0dM1/exsHjomlzWAcJqKx10KbrI8vopLXNn+TWZueGQmPjTkqjfN3+iquZNg73tycREJWZMj1XB1tFstR0G7G0lUIugmVsReO5ObTXYTPYx0O9jvKdgziTeAPnhS2HlSqheCV3F2y5zf1Nlam4bCsrODUTSydT5Iq5+BmuwKjABEPb780uMqiFYWgoMNdNy96uL6DrqH9VxzHT/a3HhSBFOIyV0eFMhC+7UIKBPnq47ElJ50eex7wcSZB6geUgAuxfdxGap9Iog9FaQRD3M2hUIeg+/hB4uBXB7SCPSLI0EpmEcVdWm/8ExIA3Rt63OxpKEJ1MVq9SVbNdrpMfRSf2i0rbeCI1rK+0TQu8mw0M1hLmf8N4BjXmHBDIJh0VYHTxq9nUxGHT/1QLi8qln15ttzaB+E4BQ2FJNFtMBOk5b0G4Mp7e6N58PdTFvNtBZB/EDmsr7E/CBzUdF9XQYwCqBk/c4cuH/SQbU3OHEYVnL1n/m0Po2RXWnMzdHbtXMel44NW6fedGQ9K6oKWVjp2LgeBju4LHNvfvxdnYrwgYGMyZb+ffDa1ZCBQLdEXSruJBgaHNGdAhIPkJFpe0KdHZKTloukGRm8P6KBHunR8HeJu5WJlu91iVL4nASbvJc6lJFfd0HAZCb15k6yxFVdHWX5k7/xflaFHvBTfuDpk2ULE+nIFUCVuiy66oFG82yrIfHQ5d85/3s6ycSVJ+uDmEe718fIb81L+PEyEiGjAKxaRxUOdrqaTjM12QAQrEiljnlQeZt2uUwW4dwb8YMHGebEkz/1mhJ2YiEj56uuSci1FrYnkg/0lpJGmo/vxntk+AcJyMl6VUrJDWf690z8rdZR2OR6Jq+huxCPcWoq+45IcgX1U1SbylPiqLAZsOChDXt9Dtu27HisxGOxlgBsRNCwA+1ZpeOOtJYL
 6GqClbLR
 LWByDhEEkuQ5Eox6b1KZLc3IxaQR8cqJ9xw5g9s9ECMm1eHxrgh+shkoXNhsnT7E3RxftAZd6kPlRDVyN+EWyN7NPBC2emk2WPI84Oz6Hyok+nvShqZgnQCvQrnkg0vISMmZT2CstMl8/2+ju5pE/8lg+wrZgYLFlzc9b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.08.25 20:46, Zi Yan wrote:
> and rename it to is_backed_by_folio().
> 
> is_backed_by_folio() checks if the given vaddr is backed a folio with
> a given order. It does so by:
> 1. getting the pfn of the vaddr;
> 2. checking kpageflags of the pfn;
> 
> if order is greater than 0:
> 3. checking kpageflags of the head pfn;
> 4. checking kpageflags of all tail pfns.
> 
> pmd_order is added to split_huge_page_test.c and replaces max_order.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: wang lian <lianux.mm@gmail.com>
> ---
>   .../selftests/mm/split_huge_page_test.c       | 88 ++++++++++++++-----
>   tools/testing/selftests/mm/vm_util.c          | 13 +++
>   tools/testing/selftests/mm/vm_util.h          |  4 +
>   3 files changed, 81 insertions(+), 24 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 089e146efeab..56d1eaf9a860 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -25,6 +25,7 @@
>   uint64_t pagesize;
>   unsigned int pageshift;
>   uint64_t pmd_pagesize;
> +unsigned int pmd_order;
>   
>   #define SPLIT_DEBUGFS "/sys/kernel/debug/split_huge_pages"
>   #define SMAP_PATH "/proc/self/smaps"
> @@ -34,26 +35,66 @@ uint64_t pmd_pagesize;
>   #define PID_FMT_OFFSET "%d,0x%lx,0x%lx,%d,%d"
>   #define PATH_FMT "%s,0x%lx,0x%lx,%d"
>   
> -#define PFN_MASK     ((1UL<<55)-1)
> -#define KPF_THP      (1UL<<22)
> -
> -static int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
> +static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
> +		int kpageflags_fd)
>   {
> -	uint64_t paddr;
> -	uint64_t page_flags;
> +	unsigned long pfn_head;
> +	uint64_t pfn_flags;
> +	unsigned long pfn;
> +	unsigned long i;

Final nit (sorry!) :)

const unsigned long nr_pages = 1ul << order;

so you can make some of the code below easier to read.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


