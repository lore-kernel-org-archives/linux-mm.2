Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4F03CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 08:59:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 281228E000D; Thu, 28 Aug 2025 04:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 259258E0003; Thu, 28 Aug 2025 04:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147908E000D; Thu, 28 Aug 2025 04:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 00E038E0003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:59:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B60871DEC68
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:59:28 +0000 (UTC)
X-FDA: 83825567616.09.1AEC691
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4B6CE140007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:59:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DJyhdxTs;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756371566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qGBV0trfmwtCdsO1on6+SbThI8fH1bwSfxhJY1VBlnI=;
	b=vGICwYbzToLx8rwyBykLabSNbXpGtRTz3FA4sJDQ2G9CB8C48PyFJ3AeFxyLOzj4eu6c0h
	Eg0sPxqxRK7xNbnmHEBNOqgCZi7grQvvWJLKi1ukLNI/UnXTobhiEQmGIA7ReE87U0mRN3
	9qMYfD+2vOqTbrVk1mFNZm+Fwncu17s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DJyhdxTs;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756371566; a=rsa-sha256;
	cv=none;
	b=kTLsiMCG8hOponSF0QTPawfAHFceIHOTCq8KZzRIxLNR9WcXDpj5mEuM8MN0lAGAAOEI70
	5y/TJdqbZK3MYTl8ATNG+Njp6x4Daw78S7K1AY7MrYp4DmuPkWohysN6M8bb/SLyZ3LClJ
	RVWWT/f+NrZqQaipeSJpNIy3PtSHjHA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756371565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qGBV0trfmwtCdsO1on6+SbThI8fH1bwSfxhJY1VBlnI=;
	b=DJyhdxTsBPMmdT9t+iJaDI3ghMFopdgI5d/oX5HfnilKVgLu63V0VS0v6Xs7KsD2FjsaCi
	U5q0cfIcN95HiDoZNxFFT/wv8wQGEqbu/OVYzqHmU59dCXK2P+o9pKnd+OhbeFS2xuyiXz
	GEF878+eHQ1s8V5Xx7vaAQOF0bBHSkk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-3jUExHXtO5meYimsXu7epQ-1; Thu, 28 Aug 2025 04:59:24 -0400
X-MC-Unique: 3jUExHXtO5meYimsXu7epQ-1
X-Mimecast-MFC-AGG-ID: 3jUExHXtO5meYimsXu7epQ_1756371563
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1ad21752so3754445e9.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:59:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756371563; x=1756976363;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qGBV0trfmwtCdsO1on6+SbThI8fH1bwSfxhJY1VBlnI=;
        b=o0w88TdlxIV5ptzDoqsvRxjeCrLyIxruB5E4RKAZ5I1nuL3qQ+Ewec+ZOUg57RkSK6
         vq09fIS+E5YSS/CfTJyMHBXgAD3Q1E4rCwKz+55jihIxPxKOQkR107vhB5SQMnoKkOGX
         fg9VxH9jdKgtluVRwFblAJXraRt1MhMYZzt9GO7IflY61NmtEwnJeqloK5HWmIObq6fw
         kv0c6NRx7tm6i+1YntS/AwVeWhMwJxC8vdHNgkwvlTG3p3YXWmPQYRbGbcnTDM0+2kh7
         e3d/iWZAMBMJYKL69jEBUkTjEBIh7X6S0zv82YJquw7NdsbdHlwj080VuGtlJ6woJR5E
         caxA==
X-Gm-Message-State: AOJu0YxOXjo9045TGRZxeEjpCEKL/u77jK9i0jt8essAVMSoaPvCKwrC
	qfKzM5WDEJsy4xwmmCD3sTBx+qbrR0l6671pvxXZfGVQk9+9olpK+99lr3yvnlGTrwDHDB07IoS
	ihXUF4S3FDp75o4q3auUuU7YoD5ETQRKglNeBvpypiLUhr/TLRKbf
X-Gm-Gg: ASbGncvWDR9GpZ6K+sCHoUqRTlgltETRZp3ZgGlnPHw8/XxiMPQ8suDx7LsERxsGoJW
	ajt6pT48+eBsoG8YTHIPxrZRsu7wH3/7YWOZ5qxyI11OJpMEmJSJ4jOt9tNxiBvcaNDGys4CfCy
	cEB0Gbcj6k8WThvgKaC6XtbwHPnNuV4uM4/L2Wm9P2hKVJh7SSfpB73NNH46xpjeUdThe3ZCqQO
	UNzddoMM9+xOR8LCOQCS/FeKQq7SWV9BVcmdosdKkkxNtvf0WuzJHHBVGJjKKAZ0ofNCE2lw4q9
	5jzftyeS4V2E5//GNtW9WdCqkNZf4Xzr/S58XK3zDvzF+Uv6lcWaw0Mh39ihOBuMTipSojX1m4s
	M5BlfLszFOo/dGiUyc1M2rr/eCmBUI0zfr4mCTi2qBAMVWnktO2CD3pzYIstPBQ42FYI=
X-Received: by 2002:a05:600c:5246:b0:458:6f13:aa4a with SMTP id 5b1f17b1804b1-45b68b79262mr80523045e9.6.1756371562840;
        Thu, 28 Aug 2025 01:59:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWdyMtBKjr7hAqURhS0tLFjeTMjbDj3wWx/dBhhAh6ZZbIaTVjgJ+6cEX3TylMiqVoySxXmw==
X-Received: by 2002:a05:600c:5246:b0:458:6f13:aa4a with SMTP id 5b1f17b1804b1-45b68b79262mr80522605e9.6.1756371562368;
        Thu, 28 Aug 2025 01:59:22 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cd8bb9ee97sm3403595f8f.27.2025.08.28.01.59.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 01:59:21 -0700 (PDT)
Message-ID: <a0d1d889-c711-494b-a85a-33cbde4688ba@redhat.com>
Date: Thu, 28 Aug 2025 10:59:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: Drain batched mlock folio processing before
 attempting migration
To: Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Frederick Mayle <fmayle@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>,
 Ge Yang <yangge1116@126.com>
References: <20250815101858.24352-1-will@kernel.org>
 <c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com>
 <aKMrOHYbTtDhOP6O@willie-the-truck> <aKM5S4oQYmRIbT3j@willie-the-truck>
 <9e7d31b9-1eaf-4599-ce42-b80c0c4bb25d@google.com>
 <8376d8a3-cc36-ae70-0fa8-427e9ca17b9b@google.com>
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
In-Reply-To: <8376d8a3-cc36-ae70-0fa8-427e9ca17b9b@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: g6_Ww5_qbXi-h-aGZ4kde-P_KMiwcbrY5JxzyJql-yg_1756371563
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4B6CE140007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: odz9r4dtsyd1wq3d6xdfo8ewj9mmuz78
X-HE-Tag: 1756371566-438817
X-HE-Meta: U2FsdGVkX1+xlkhvi7EngyE73zZ2BspRJpGMuc1DLu0pEB4lQHe07Brz3bvYQFZXFm15mL4PQgjIbmwJXt2vQj6THHVIezKVnndgZN0C+YZdv+6ilk8yQL80MVzbGjZyky63x31c3JniaHfQxzATu2O8MUhCRXaima/lBU09kksFomti92pqYSjxaSJAPyREclJGGoeRLuiPYrOuuE+tVasrwMeUkcV44MHRJac2mjeoiFg1FIvw1f1SbELJxwb+8XUkjnVoTTnvCZAGAc+CtG94UzXlXb4yjyVSL3q/vOmZ7eI1HZTg7Fn2HmQ/I4WUcY8Z2YPsJRrJn614Xv9IJNePUXwU95bscQEAEeu0O1eT64TuP9egCjYosol/SLyevCO/K9WU9o0y8Gpwg2I4K+D3+DaCz8WvN62lnAxwEXc8LvwbvwntLVWrLN7OaCI4JRP2Lv8W6ahD+MHEdf+BFOSJDUqor2gTcpCGDEYTjMIhf/6Ubr5XXUvmzFF0birAEu7Ks+i19SzZxdLWLNg+9EWNEj2EJU8WQa0AtmZJLObUGBW4Rwf2g/7qx8C79Gs8w0o1AELdMEKYXwqGVyUCyXTTfvnfvFBsulIl6L53JVqtblj7810Xt9LSCqhrFBq7Vtv7n1EoEM/UujF1sE8Qc8zIjKc+2+GPUsWQPs5LizpvhR0puA2UL+1knPv7gDwPcy9rDGjMOGtCS3KCWRaExLK879xJfG3ucFrnHt+T2q40FJwzJQYUX7oSfvjv/Pj9TMnZfRjDm9/92OC9miybYI2bsQiyNp+gKAYfW/vH9LESuBbYVSB2zrsq03TH0oz3ZeaLVGdAgoQlpVcS64/Mx9QVxMAM4brYTuB69RPnoj345r6xnr1Zh0OOZczrcfaiQkBO505wyUzdioyaU1SquAFzBCLq2KvqZ5AKg1PWEDsGAyOjhYwJLS56QAQyFCNC+G5+e/+24bHwU/o9Qh0
 dcQjGELd
 XJ1v16hzB34qkKRTLap1Az51SnEDLCqSjyY6/m3f7Jri/XFjceVmQF3aHIY5kgS3jVy0BWqszWePnxtbNJ1fct6PookO5M1TCx6zVtjTwEuYpuQSVvEt8nOgo/nvgRNVT/eim7CX488jXWTeJjB9KsSc8boKKXpnwtyfLeTi/9UCv4QhtyIa7yfdi5ijVBi4KCj055WWv/NyuIIZ41x7w1T3iHsXtGwC5m81VrZ+kQgOsxwo6QEigcaRuALinMIWKS3bBLwBXU0+XMrfhLSe+NmYBoomueqCrmXHFkGAunHSA1hw0dpokbCzvvOAkyqDU4Jg5FtnOBXRDuMpQyrh2vcpM3K4pJSkCtCQyK6ZVHtyhkuL1wKGc3x7/jUFnmwLqVus66G2c7pkrlWEpBxeZoIz6AVHYiYD6jPly9HbWcrpnnioybHk8SEyyzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 10:47, Hugh Dickins wrote:
> On Sun, 24 Aug 2025, Hugh Dickins wrote:
>> On Mon, 18 Aug 2025, Will Deacon wrote:
>>> On Mon, Aug 18, 2025 at 02:31:42PM +0100, Will Deacon wrote:
>>>> On Fri, Aug 15, 2025 at 09:14:48PM -0700, Hugh Dickins wrote:
>>>>> I think replace the folio_test_mlocked(folio) part of it by
>>>>> (folio_test_mlocked(folio) && !folio_test_unevictable(folio)).
>>>>> That should reduce the extra calls to a much more reasonable
>>>>> number, while still solving your issue.
>>>>
>>>> Alas, I fear that the folio may be unevictable by this point (which
>>>> seems to coincide with the readahead fault adding it to the LRU above)
>>>> but I can try it out.
>>>
>>> I gave this a spin but I still see failures with this change.
>>
>> Many thanks, Will, for the precisely relevant traces (in which,
>> by the way, mapcount=0 really means _mapcount=0 hence mapcount=1).
>>
>> Yes, those do indeed illustrate a case which my suggested
>> (folio_test_mlocked(folio) && !folio_test_unevictable(folio))
>> failed to cover.  Very helpful to have an example of that.
>>
>> And many thanks, David, for your reminder of commit 33dfe9204f29
>> ("mm/gup: clear the LRU flag of a page before adding to LRU batch").
>>
>> Yes, I strongly agree with your suggestion that the mlock batch
>> be brought into line with its change to the ordinary LRU batches,
>> and agree that doing so will be likely to solve Will's issue
>> (and similar cases elsewhere, without needing to modify them).
>>
>> Now I just have to cool my head and get back down into those
>> mlock batches.  I am fearful that making a change there to suit
>> this case will turn out later to break another case (and I just
>> won't have time to redevelop as thorough a grasp of the races as
>> I had back then).  But if we're lucky, applying that "one batch
>> at a time" rule will actually make it all more comprehensible.
>>
>> (I so wish we had spare room in struct page to keep the address
>> of that one batch entry, or the CPU to which that one batch
>> belongs: then, although that wouldn't eliminate all uses of
>> lru_add_drain_all(), it would allow us to efficiently extract
>> a target page from its LRU batch without a remote drain.)
>>
>> I have not yet begun to write such a patch, and I'm not yet sure
>> that it's even feasible: this mail sent to get the polite thank
>> yous out of my mind, to help clear it for getting down to work.
> 
> It took several days in search of the least bad compromise, but
> in the end I concluded the opposite of what we'd intended above.
> 
> There is a fundamental incompatibility between my 5.18 2fbb0c10d1e8
> ("mm/munlock: mlock_page() munlock_page() batch by pagevec")
> and Ge Yang's 6.11 33dfe9204f29
> ("mm/gup: clear the LRU flag of a page before adding to LRU batch").
> 
> It turns out that the mm/swap.c folio batches (apart from lru_add)
> are all for best-effort, doesn't matter if it's missed, operations;
> whereas mlock and munlock are more serious.  Probably mlock could
> be (not very satisfactorily) converted, but then munlock?  Because
> of failed folio_test_clear_lru()s, it would be far too likely to
> err on either side, munlocking too soon or too late.
> 
> I've concluded that one or the other has to go.  If we're having
> a beauty contest, there's no doubt that 33dfe9204f29 is much nicer
> than 2fbb0c10d1e8 (which is itself far from perfect).  But functionally,
> I'm afraid that removing the mlock/munlock batching will show up as a
> perceptible regression in realistic workloadsg; and on consideration,
> I've found no real justification for the LRU flag clearing change.

Just to understand what you are saying: are you saying that we will go 
back to having a folio being part of multiple LRU caches? :/ If so, I 
really rally hope that we can find another way and not go back to that 
old handling.

-- 
Cheers

David / dhildenb


