Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04B00CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6270A8E0016; Mon,  1 Sep 2025 04:07:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B0478E0013; Mon,  1 Sep 2025 04:07:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478A18E0016; Mon,  1 Sep 2025 04:07:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5498E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:07:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F0E791DEA39
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:07:15 +0000 (UTC)
X-FDA: 83839951230.02.B5B5672
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8C484C0004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:07:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="I14f4/Vu";
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756714033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kVLhREYblbo3zV+RJetjUr2sHUhQc5+2HE4X6CHGYpc=;
	b=tGeFFhTywirG4BK7GfArPBDcu6Tz8AKYzYS4Pr4xY4k7OjXwsTn4MYlPc3SEPRI2kK8gNn
	mwxrkNupa8O6GlfOZPl/jezEqmdfbcJUDQXP/4Rj0sQ1DWSFgJuRqRn+7G/LnsDFphkzLR
	1n+L/yAjtgmONZvSgVO/A1f901VeYJc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756714033; a=rsa-sha256;
	cv=none;
	b=hif+TRZYMzfgiT1n//teYwvmMd9PEEzwUzdx+CSik+kg7ypPNtCVTQ2ZnMDPBmoN2VJmZ9
	SoNgBEFjav1GVZn807ONrnQ10RUdXxz/GfEHz1RofXw03Coou2FzR7tpeQM7CYLnY542XQ
	skDJgKBIKrthyaIWpb4FfgN9RUWYQyM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="I14f4/Vu";
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756714033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kVLhREYblbo3zV+RJetjUr2sHUhQc5+2HE4X6CHGYpc=;
	b=I14f4/VuZLWfut4F3D4D0ohrOBhrrLw/2KtToJcuGEGew5oQbzX6JNb97eVGjMRB5Su8sk
	mo2AIzcBd8SrElbL0ehRPaa+VZxB0xnfPK3MSyvu/7JHgINx4cAZxJgc0DIGmCrnVw6qEF
	9uaKKix2/88a9d+UA7HbklJusoOgc8U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-2zUyzKOZMNm0pmbXA-W9pQ-1; Mon, 01 Sep 2025 04:07:12 -0400
X-MC-Unique: 2zUyzKOZMNm0pmbXA-W9pQ-1
X-Mimecast-MFC-AGG-ID: 2zUyzKOZMNm0pmbXA-W9pQ_1756714031
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3cf48eca078so2324277f8f.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 01:07:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756714031; x=1757318831;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kVLhREYblbo3zV+RJetjUr2sHUhQc5+2HE4X6CHGYpc=;
        b=ZqD2R1kRIF2hNW0pbD0ui3YFEgTXjZEQpPO60NoiReKnqcZY2jKwmM/N22rvK5O/Kd
         Io7fLuD9aAWGnGy/Z6StV5LFZc3KcnYkIbLfYQnYRnSw1iDa3UH9PoAZjXRUHzYEtb6b
         XuhSDZunf/5gEx3acJMNPoGsJNUqfgiFZipUHcaHGE6PUjIfgmROQFBFdR/9J9l4BAvo
         wMYedrFQM/1MjVZguw2OCZzOMxfNVMegLgqZJnt742d1knT3VRWSkbGnTBdNsrbbbPli
         vOsOUsLcA1TpewGMS4M7+w5nDzTglpyQgFZXbN2208Al6RZjoGoU0q6ULuQ4eg4M8ULF
         a+cA==
X-Forwarded-Encrypted: i=1; AJvYcCW7oQkqjaDW+1hnYsMb5Tscb/LkLxxKJn8el70V24jwsBJZYtW+pJvL6ADm9u0c4VvBU8Luo/WhFw==@kvack.org
X-Gm-Message-State: AOJu0YyFjvjGUdrFTdN8+5s9Yr1aD4LTW/WDba0uq3WqocnZomXmMQWU
	3veZrgy3ZGfCDqYJ/YTZbOASz+2Mu03qbUprxP0RG4VKB7tigAP36F3bOiDESaAvGM6xvd7CR/y
	VLgNQ0/Q+hsTptlhw9UTZ1uMk40oPysTL5hO2/UDFq3BYl0aN4vJG
X-Gm-Gg: ASbGncsB9tf2t6qAw7bgnk0EDC3xxDL5rY5VRInG+tqv9nqUQRnbzrnMCvIfe8W5Mc9
	rOCfBFYN1GZ/t0QWnXxhq+te9Wi9/6GdasUgzdnCHDXF4S7x/BSJnsbSVdA2kGJDuxuMXOMadA0
	W4yB29WYQhSxBEbcDAUqhzLDGci0ZgYIkJB4ENDAljXrHQhn+/tN1KdzVgwbDbzVVBNJMqWT9Al
	DLEinVCOYTe9Z9laypYMsIBvIGRxn3Uz41VCU3y8nlectzv0+npdYeJVMWkQsxKnNGh/Iz5ATKa
	lOWyC8tugIoWtUEpqKTQ76WbBGACHKYC0azI05/yzh+RzYe1weV507gwVZAT/fU7uDFyJyhMBF7
	qBKkpgWhYZNrmNsskwZ1zpBlXkMfiWJwysErayWS07zUBDkP7hx/CgVu6wvQvcf8u2FI=
X-Received: by 2002:a05:6000:2005:b0:3ce:fe6a:a9e3 with SMTP id ffacd0b85a97d-3d1dfc0734cmr5474534f8f.34.1756714030679;
        Mon, 01 Sep 2025 01:07:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFIYzH3ehFZlr9zFSuAWEjoTKdXRfZkW00Auw9hUewKGpPrV3x2/KRj/mcz8/n6ea855oItyA==
X-Received: by 2002:a05:6000:2005:b0:3ce:fe6a:a9e3 with SMTP id ffacd0b85a97d-3d1dfc0734cmr5474502f8f.34.1756714030230;
        Mon, 01 Sep 2025 01:07:10 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf34491a7fsm13866834f8f.57.2025.09.01.01.07.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 01:07:08 -0700 (PDT)
Message-ID: <80f0df00-645e-4fc6-9886-03cc56699991@redhat.com>
Date: Mon, 1 Sep 2025 10:07:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] mm: Revert "mm: vmscan.c: fix OOM on swap stress
 test"
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Will Deacon <will@kernel.org>, Shivank Garg <shivankg@amd.com>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
 Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Frederick Mayle <fmayle@google.com>,
 Peter Xu <peterx@redhat.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
 Alexander Krabler <Alexander.Krabler@kuka.com>, Ge Yang
 <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>,
 Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Konstantin Khlebnikov <koct9i@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
 <bd440614-3d2c-31d6-1b8f-9635c69cef7c@google.com>
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
In-Reply-To: <bd440614-3d2c-31d6-1b8f-9635c69cef7c@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CPpXg9_nl_FQIG0pyIjgXJfJI5-zILUDj1IeWxKt9do_1756714031
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8C484C0004
X-Stat-Signature: obhcbbftkpptk9caktofkj8fnucrkmhx
X-HE-Tag: 1756714033-769827
X-HE-Meta: U2FsdGVkX1//lva53H0eCIeMOgScsK8xGUPYS+K2xMhqnb+MIOp6XA7DXIgs8zWhaXv3m1qxuXE4sxZ7wHtx9j+xe/eCmt+TK3yWItVtjRA+La6NFKmjgh1Cwoc1sbZAc2hFTK4W17FY5NdN4dIYrwKCB0KGfsfcAcx7eo+CM5Az3ngqwVexTn9kYaxjTBxkaslDp6V2+tqkohSLIu+ai2t1+/C9UaCcHikjGotjoNmKCPjbbQO7dI2SYQ+rSWDSjHee3k0Kf9kBZGvAYk6zNgHlO+nCCtjGk25bbpQqEPRZROC1tkgkVMJQOXxvs8tRKLtZQj1KWvHxNDkEk+TMLIWwhUMHUj4nLkejL19sW9B5x/b+OAi1WKTvmciH7NahHlwbWbiXGSl29vMiMrtecsDtrgPjyYyoMVnyJeC2Ve84n1sFdRJGB1eVdirN3NWRubJHSlUsGiwpxLR6eSLGppAxylZ3tTbhLLPA4q+XB9letKJmSs26dJ4ktPe0tb41pXhohdtRjRo+k63nInCAHfTrwUZPdZaiF7ZNitduktumv7gg+0yX8E6XbolbOQrTBU3v9QHVZGGEy5gMyTTNGde3NPAil9kBbNXX3Upd4CIE/F+P1jYv0b7QAWg6Mod0fZj8ywz/O9sPOxR31ZJ6LaeWY+GQxM0fca0ja4pTacxpDqpclc/WyH9mmnNuFl8ej6tTQQP92XmcCOSH0uIb6O/pTTScU4CKP7shtdAl8OopimjUKceW/DHzZAlBVXpGz1BUhJHrxX+FbVSdlFFlacFtpkdBDQdE8Lx4G5LXgim1nSGV/TxKElBE9Kp7kml0G08GRdIYIA2Wx48ZETD+m9P92bPLAwr+dJziXq+VG+UcQ92kc+4PdPFeVtrIDGT/mdAILULyRDVQifdplkdhQIckSNjqQ+B9uTfnHR0gGRRoCCnRB72eqJE1pz6s/b1cZ266tl4fgp2sx53805w
 zL9RQPd7
 MN8DzkUkckb/oxOznQYU0YuCpBiYi4MkMWG6LWA7ZAG0SBkclFgxSocoABgmSYx0sbOc1gmKIjVMZQTgJ9JlmqiMODwY+9fdEruSYOSNqNmhMQeLxmGiDEqm62aKpv2ovvyThVExbi5fqubqNWOlzgqI/1ARFbT5hTfkdVs5cSGXaHNbkoryamFAFQw+AgmuEjJbSMGCgMRb8yuj0uOMR0lT1m7qPKoflYMIkjEP1PoMzyETvBzA1hI8BMEXU5wUL66osvdEIStlOdrBJTSygmUQfMKfTSSsNoOMwPiiJNEIfKr7VmQKe8ansSqL5RtRAtAMyuZnD6pt448yoq6VNXCkdnWDlDY3DSiH5P95FsUkUrsjHSKUNlw/GrNzZztwHgDMjjp28o/t8iTgWSnZ/S0Wff7UkuJCvm4Bw3fXFfXDT/PFJCOOYME0d5EbX0g26L2s587ywrZxt4GCSq9xxVqgjZemULjXQhg5mbkChQmGpZ0fmvNzwYUukJGm041hvVcnhAAiEIyr/oNszmxvjQvPbRDVuWmKAM/9WO8yL2pcbUpE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.08.25 11:13, Hugh Dickins wrote:
> This reverts commit 0885ef4705607936fc36a38fd74356e1c465b023: that
> was a fix to the reverted 33dfe9204f29b415bbc0abb1a50642d1ba94f5e9.
> 

Likely checkpatch will not like the long commit ids.

> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: <stable@vger.kernel.org>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


