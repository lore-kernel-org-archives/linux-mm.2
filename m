Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F27CECA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 08:46:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4624F8E0006; Thu, 11 Sep 2025 04:46:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4124F8E0001; Thu, 11 Sep 2025 04:46:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DA738E0006; Thu, 11 Sep 2025 04:46:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 178108E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:46:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E886C1DE640
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:46:18 +0000 (UTC)
X-FDA: 83876337636.07.CFECD42
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 916DC14000B
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:46:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WBtR5k2Z;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757580376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ssCjsQRosnIsyQi6TRiWy/gOOQy1TqZDzUkPJYAbPso=;
	b=XRL8h4FexTOxjRBqUKUGbCqSeWrID0dcoC5c6oIVYbqVxZYmdBikCGVj/zLcLwR7eGqMcM
	Hb5kwWEeoLtY2SD8RjgxNPoRh4igI04HOyVvuwNgbrOFx+e9j4vVyiakjcKBYK9XixCggO
	PI4/yxN5UFVHX8od6Z2+AQo60J/7oK0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WBtR5k2Z;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757580376; a=rsa-sha256;
	cv=none;
	b=Y27wy87qgk4jfPSxpHVp5c3LC5fF4nylHFqZi35Wlrrcv/sCGNv1GB6BdDt5OFnE/8RXoA
	9VeWfqm2cL53vJ61Fla0moF9ASVr7Re+YAllSlHKOPIDBp7niKRVqxSa9fbEsPgWfxkYX9
	KLC54nRaA5TjeQNBqhIr+kH4NmZ2bx0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757580375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ssCjsQRosnIsyQi6TRiWy/gOOQy1TqZDzUkPJYAbPso=;
	b=WBtR5k2ZA6cY/L+yclCcM5OI7cnSoOqs9qifEqLQSuSjGWo8+Hn0PMKW2Lc/UpKs7kMBqm
	ClvIiXOKbz4yas8IF/ZWjR/YJFYtyD2qqliF+bqurgZb7j62ns+L4yoi8IkZPRyw9lK/Us
	wdjxU4DLKDIEbFhkJPCNlP5y1tKnz5I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-59-Ieh_CYfwOnSfsdw-GjFrFQ-1; Thu, 11 Sep 2025 04:46:14 -0400
X-MC-Unique: Ieh_CYfwOnSfsdw-GjFrFQ-1
X-Mimecast-MFC-AGG-ID: Ieh_CYfwOnSfsdw-GjFrFQ_1757580373
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45deddf34b9so9633435e9.1
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 01:46:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757580373; x=1758185173;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ssCjsQRosnIsyQi6TRiWy/gOOQy1TqZDzUkPJYAbPso=;
        b=hdshnDv9mYPJfFWoIQlUbg9r5SAodULQ/MV0LndAmDjbRzcFpjSMjES/SsNuu12nIq
         HdRo7OcCFE2laLt2N587Sfa7dX2S15utobb0B1bjxjU6UTecu8ZEYeWBZQsVXSoGHtAA
         E0WDtfYPujCR4q9bkmeNeJJMeM9WAddoRFzipoVaosanS3eS5ebsCkN6crwE6JO9nALQ
         0aKXup1/7BnU+NW5pxxB/vY4YOAyDWmK93K5VaNvEaUZrXPMbceYMu4pYe3pzRD9WD2W
         Apx8aojS31E0AUvGSx5GCBLOBSbHZryJW02wEviuLixYAybq4IiEiX/OiaB5xDaFzdK4
         6uCg==
X-Forwarded-Encrypted: i=1; AJvYcCW+03fmqtx6u/Tlix7C+KIdOo9iohfS2sFE5lrNvOWNIIi7Dc++ilILIa4XsigpHp4MOfHPMufWyg==@kvack.org
X-Gm-Message-State: AOJu0Yz+M3pOhLLOKzYq3Re+g+GosMOOMLzeFkNCvpm7LQnFBncN1uyV
	gq7rDvjlDQS7+5Ml1Alwty+sAXZl82MzRd25sPC1W8bcyIHGIB7Dy0uGF61dfpvvRyAR/YGRa6Q
	zXI1i9t/DLksAqhHzk1jTSCrdLEPgVAcxMF36P4IuqiIVs9RBzGQZ
X-Gm-Gg: ASbGnctcmrB9ok0HAE9B9P9LGpzGIE0T4v+mnncNCbPhb0WBZqckhdoUBbBG8e1J8s3
	0LeDQtZGKrME9RCeCzQKMZrgjLgA7GJn6VSka/dGoQTxjdCTJVin9e9BWDjFIZ7He490C9c2/oN
	Zh2jFXNvkWRYK0RSxAHnGjfAkriJA5ds5LFhuihN7tC1roTLhDFCfpDkCgdrH0fj8fJvDCQYy8M
	J0rtCEczvHEnefBD3r6K1f6dXELigTwPk7rzGaDZ5BZaoOBSH2F91bTyg8MjWbOjLdCdhcPMPS0
	3sgx7Q9wQZSTeC4CfsM3QJ9mPUq/k7zIA9aYYFVH3tXrvAAFxfgQXw4YbnGPdlMoFIRaVKiPQUe
	GqiGdS0o65D0Bcz5vTGR+DFKOXat6t9O4a3h5/IUB6XTRE68rpnSyvQglhrYmEpGv234=
X-Received: by 2002:a05:600c:46c8:b0:458:b8b0:6338 with SMTP id 5b1f17b1804b1-45dfd5c473bmr26815835e9.6.1757580373264;
        Thu, 11 Sep 2025 01:46:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEKWKwxqu2qOEyBEgAUAxpXzm9G4HcETc4FviAdPqhEnNC1NKGJCc3NQuXVk0LzZ/0UgZIzQ==
X-Received: by 2002:a05:600c:46c8:b0:458:b8b0:6338 with SMTP id 5b1f17b1804b1-45dfd5c473bmr26815495e9.6.1757580372845;
        Thu, 11 Sep 2025 01:46:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f42:b000:db8b:7655:f60f:812b? (p200300d82f42b000db8b7655f60f812b.dip0.t-ipconnect.de. [2003:d8:2f42:b000:db8b:7655:f60f:812b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e760786ceasm1624111f8f.16.2025.09.11.01.46.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 01:46:12 -0700 (PDT)
Message-ID: <749511a8-7c57-4f97-9e49-8ebe8befe9aa@redhat.com>
Date: Thu, 11 Sep 2025 10:46:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: Disable soft offline for HugeTLB pages
 by default
To: Kyle Meyer <kyle.meyer@hpe.com>, akpm@linux-foundation.org,
 corbet@lwn.net, linmiaohe@huawei.com, shuah@kernel.org, tony.luck@intel.com
Cc: Liam.Howlett@oracle.com, bp@alien8.de, hannes@cmpxchg.org, jack@suse.cz,
 jane.chu@oracle.com, jiaqiyan@google.com, joel.granados@kernel.org,
 laoar.shao@gmail.com, lorenzo.stoakes@oracle.com, mclapinski@google.com,
 mhocko@suse.com, nao.horiguchi@gmail.com, osalvador@suse.de,
 rafael.j.wysocki@intel.com, rppt@kernel.org, russ.anderson@hpe.com,
 shawn.fan@intel.com, surenb@google.com, vbabka@suse.cz,
 linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <aMGkAI3zKlVsO0S2@hpe.com>
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
In-Reply-To: <aMGkAI3zKlVsO0S2@hpe.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TOf5aIabT8iwJEAUFzIs_Oy3AhRW47FJYLTw7qjsh4Y_1757580373
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 916DC14000B
X-Stat-Signature: yt6m36whzqsxwypamnaes9xwqso7j77e
X-HE-Tag: 1757580376-206099
X-HE-Meta: U2FsdGVkX18WF63FoIjoVUKp6/AlgHA1cHC9F7RC4agpB1efzWqI0c7aUKhG1/4et+eC5LtI/ZQP4mPZjbmT0Xni/kqQBbDlQeNr1Xj7dD1hAs5oPWLRJU4gFtWb+jS2BmXVROXxcsy5u9CzZAfhJqN4ms8j9PEC+hVwBZ28HBtzMTWdnU+8K/VqVDJ0RR+d/yxF4c0regVwKU8WI9AaXLoglsCZGLMY6QglfWbGncuWAQ67ieXYfOWV/O4txW5TqsgYAa9Rb8NUydT3n9J17DUE6G3/AKgUMLUN9mf8mQsXv1gppuqnjmm3i48T4qH/nxeK5n4bP9hKNhTKRYVYjRJBsP6CuzGxOqKKC57wGAnQLAgrAr+Xtsqq6TdC1+T+gQqQRMROaMLj3FEbUu4ilE1b9Dt7Tm2JVcMaPhtuJdRJSDHml00CGAUFa8loJlz5BP1lG25EphiGCtLBfxuIvEjYCGL2BRah4Y9fAjJVhdS7EBGa85a/nfyHFlYVDj1Ynb1TykAt906GELuRD43VhCVMSVkSwcrnJ1722D85GGnmJ9GWMNJTSXThgDMckgXcMCJXouiXJnc7Nt0lF/WUu9firyNDIsFp6Re45JOCjwQJGlSRpyRC/rmwOJO3tnkox7UkF2lRaYgQmB+hjg+J6A2q23KbPo6YfguBu6oP4LreJxwexPdc5q49d5egAJ9B0Eu7DCXomy5R1aeIDigYdzOy5mqPDg/ZgQqj5EHSF6BAOqgWIl4m7Q8JDDtzALINMrTrCdHNp15C28dM9VyZm0QJxgNDFR4siOKalkQX0vHsbNgsYO4VNg1QK+/FnXwTZUUt87wcfM8eijF/okOQAaMgbUDWACsTUNzU0CUw/IJsn000En55QiauZRWBLBjKPVDh76e4Vffxr/khAE+cbmlwGzdjiCRXIXXFB2NPeisMqn3dI2SvkwuEUIpmVySTWjbcT57GfQ2uy94OiEo
 ZYFK+eOe
 Wi7QPEADZViI37LFarl4+uqPkbMn1622GvQasXdF59xQw5bZ7WUUKCVvlMwPStQDRlddu7CgIBYq2l+3vuD+xGB53YI66R/MNPok7H+d8tjacm51XFG4Y5yMo9Wq6XZzKDRo2HLY+IVa8LQUMqYquz6NZPH9WEzyR2KnY6EbuMOMAK6qqc37nK1EAm7JFan1PYNofSVG6jbQkV4Xr9UDQykelEGci1UQ2e3Mt4pgnS9ETdF9qpf+8Im7yLxPkrC991AWnm8KBmgKH1a5gHQakRtVpvnkkoCIjcWDuvk/YL5nEhOIAHaP45xUSevOICOk0dnwHztEeflFOwIo6L/Y9s0WEY/obLYIPS827R83uq2Is+xcMwT8YfNkg9Zz9+mYGvnljp050e1PcC7sK+icvbvZoPCvncnmbwYOwH7LLWslGXaY/VQgbAcUo2+Pg9msZKVPNLSuEc5yhMt0PqI3HeaSgcJ9uJ4CbvIHvXu1UVTN9qwcdDSAXQLk8KQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.09.25 18:15, Kyle Meyer wrote:
> Soft offlining a HugeTLB page reduces the available HugeTLB page pool.
> Since HugeTLB pages are preallocated, reducing the available HugeTLB
> page pool can cause allocation failures.
> 
> /proc/sys/vm/enable_soft_offline provides a sysctl interface to
> disable/enable soft offline:
> 
> 0 - Soft offline is disabled.
> 1 - Soft offline is enabled.
> 
> The current sysctl interface does not distinguish between HugeTLB pages
> and other page types.
> 
> Disable soft offline for HugeTLB pages by default (1) and extend the
> sysctl interface to preserve existing behavior (2):
> 
> 0 - Soft offline is disabled.
> 1 - Soft offline is enabled (excluding HugeTLB pages).
> 2 - Soft offline is enabled (including HugeTLB pages).
> 
> Update documentation for the sysctl interface, reference the sysctl
> interface in the sysfs ABI documentation, and update HugeTLB soft
> offline selftests.

I'm sure you spotted that the documentation for 
"/sys/devices/system/memory/soft_offline_pag" resides under "testing".

If your read about MADV_SOFT_OFFLINE in the man page it clearly says:

"This feature is intended for testing of memory error-handling code; it 
is available  only if the kernel was configured with CONFIG_MEMORY_FAILURE."

So I'm sorry to say: I miss why we should add all this complexity to 
make a feature used for testing soft-offlining work differently for 
hugetlb folios -- with a testing interface.

-- 
Cheers

David / dhildenb


