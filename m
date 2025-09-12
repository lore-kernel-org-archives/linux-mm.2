Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AD0CCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 07:23:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEB858E000D; Fri, 12 Sep 2025 03:23:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9C678E0001; Fri, 12 Sep 2025 03:23:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A64258E000D; Fri, 12 Sep 2025 03:23:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 920E08E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:23:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 529ABBAC7E
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:23:28 +0000 (UTC)
X-FDA: 83879757696.30.6E0A96A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 01E6C4000B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:23:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IMQSjJ18;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757661806; a=rsa-sha256;
	cv=none;
	b=S2JwHDlpXpuWMgxGPrhRGApGSX2y/URH/1njylH8VD5PVTVaErXZymj9ITUIXdHpq+VBjA
	cMsVSDS/t5UDx5ZgQJiyTDypZtutP4RXENyOJYgsXIgQcqMwlPeK/H1uywtlLeVuTdrvjy
	6hSyM1swZMUT5ClTILH+fKDTydmRt4Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IMQSjJ18;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757661806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wWdmre4gNHl1bdSNhltiDVqeVHUUYjBFiLkO3P9YmQI=;
	b=bEFCNbiAfXfLsRRJ0dYzNxkBm9UBmiky4DtsW5qvs+gkO5GgaA2Kcnv4dDFc8a37CZF6Y1
	dOzKGx+WtWp5fMRyOKgSs5RfhK8ad+L77PkgZkih6F8F+jeR7BIqMF3FseF4bcg1LGaGuz
	IPR5V6GHZAQIh15qVajb7vk3+i7gpm0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757661805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wWdmre4gNHl1bdSNhltiDVqeVHUUYjBFiLkO3P9YmQI=;
	b=IMQSjJ18/XHGOTYPU+D82T1bUzqkYS33TWpsXxDBeIGTVfPEu85I8UzYhBOawEqjsMMzv/
	n7Ddrg2McGcNMDvmcIz5yHnyh0On8HgfHYDVc7d4owA707MWhLM0wNk6CEXkZwfibfoxnz
	VhpLKAlbb2oMNnDzfLz1FtC/bSlUrz0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-237-poD7ygxeO2Gts-f40RL_aA-1; Fri, 12 Sep 2025 03:23:23 -0400
X-MC-Unique: poD7ygxeO2Gts-f40RL_aA-1
X-Mimecast-MFC-AGG-ID: poD7ygxeO2Gts-f40RL_aA_1757661802
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45df7ca220eso4136585e9.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 00:23:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757661802; x=1758266602;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wWdmre4gNHl1bdSNhltiDVqeVHUUYjBFiLkO3P9YmQI=;
        b=uzIKATOOl1SCVRegjpQf9YYO3rOab6CSAn5c0juZ6Lxiqbjv6TKjp7iHvCfrf5cSh1
         0AAjuvd7XQOmMW9Op4S2qAqF+wNl908WpA1h1e0hm8bKA5CxZlQaxxKW/cyILwlmwxUE
         UxPViVpS88D8uv09EqyZUedfd3m42mgtCnJYI+akqyAy7C7tCzZFJv0m/EBSIsIDpH/R
         By7nqjBeqjj1/oaSgWyXzq9ZIh7D2yn0RA4G+5N4h4NSgPWCFf28KWCOsIXH0FWVYZRJ
         uVcvD4veO/lH3v2HcPR1yIgLekdaMbp/XbEYCXkCjYJywmSKL3N0+w+TB5DeqafOESek
         qZBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBvKPTgxgl/rfrRd7UgmEsdod2LcPiy9TqJQuVXvvgUMNxFkhM8qM9nxV23PDxOLG0t/0J8G/BgA==@kvack.org
X-Gm-Message-State: AOJu0Yz8HEjTKCYWjDxmZpHfrtoQRJlNGa//jZ/+uV4zA4AYRrl0uZ9+
	AO+vnEPEmAoUH7ldlF71aQPf5XkjfeB/1i/a6ksoxvP0kqmofmnJI9vugppyV1xoY+9CdZY2DTP
	MTtS1XsjkVmy3zUDDwRAYShVRhDgC+P4UgTrBFL3xDuxDy7SZ1sfp
X-Gm-Gg: ASbGncvyuvVSZlTWZIfBT6p5UxOj0f62rHp6s2GtYRHBgPiGN8De3sL4YlZJlRJprTr
	ZmZn7xEjUqXM0Q9lwSrFj1tiuM+6HIf/rSXFMFKLyelG4mm/N5nsaMB+o5K7IyZoFOuHdZ8z1I3
	MvgU9KTuPFAwi6dN01ntRdeYpENqtT8muxgd1vuDFr9gat46Cwk2VH83XY4iKX4sB4XwyDYX6gx
	WQcY9deWgj6GsnAsA8G04IbnrG+G1Ev4/pH9hwXyx0luiLMoEjzGUhlSuJhL1chy6wUiDHa99qD
	a5YtpdcxSK98/JNuGYOu+Zh0OwLQLRariHYJ7g1WZ3SquS5Wzshe269eEWnh19kq2uWbhxa8CvR
	efh1SNppeRHc2CALmbMcUamjahkoB6Vbei0fhFCiMvGYS7J3WfW+3uL/KyQ7vLMcX+mk=
X-Received: by 2002:a05:600c:3b87:b0:45d:d099:873 with SMTP id 5b1f17b1804b1-45f24efbd40mr1339705e9.6.1757661802155;
        Fri, 12 Sep 2025 00:23:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHRXPmTBNPfZUjp9BkoA7COF8rU23fJ78WiKbk2eNFaJFn1jlwNyzVxKY0TxUT4YnBpvLE3hw==
X-Received: by 2002:a05:600c:3b87:b0:45d:d099:873 with SMTP id 5b1f17b1804b1-45f24efbd40mr1339265e9.6.1757661801719;
        Fri, 12 Sep 2025 00:23:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607770cesm5427830f8f.9.2025.09.12.00.23.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 00:23:21 -0700 (PDT)
Message-ID: <1da42002-9dad-45a7-98f8-90a97801002d@redhat.com>
Date: Fri, 12 Sep 2025 09:23:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm: hugetlb: allocate frozen pages in
 alloc_gigantic_folio()
From: David Hildenbrand <david@redhat.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 20250910133958.301467-1-wangkefeng.wang@huawei.com,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
Cc: sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20250911065659.617954-1-wangkefeng.wang@huawei.com>
 <20250911065659.617954-5-wangkefeng.wang@huawei.com>
 <90e926c9-40cb-4791-8360-e3d145fe3503@redhat.com>
 <8508e8fb-77cc-43a7-8460-456f68a552ba@huawei.com>
 <667133bd-0021-4d4e-9cde-fc8c1324522a@redhat.com>
 <d63e7e02-b2ab-46fb-b981-ad4f4f28d634@huawei.com>
 <3a842ae3-f13a-4f5d-8870-d81cf1f0d56d@redhat.com>
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
In-Reply-To: <3a842ae3-f13a-4f5d-8870-d81cf1f0d56d@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ndBhXvngBiUyJteA7YSIs4J82XseqpzZIjKS3XMAKLU_1757661802
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 01E6C4000B
X-Stat-Signature: 6mbi5s5ui8pkwtasbbu6c1z9cciqhbqc
X-Rspam-User: 
X-HE-Tag: 1757661805-510917
X-HE-Meta: U2FsdGVkX1+N+fT2YffXgTqyp9mLgt0yz6WN5GkZdvx4QHAExWQX77pD5Se2abrAOEYk6ZV5NSkpGeGFyyc/KEK60w5d3DBAwY0lLTB11+pz28Rfu/qXtCyNTzwOEpWNYN9Eo0B/kZM2Gp+1COJDuVDYSAvFa7+E5ZIBO9Pk2S7rRQNQU5NKGATiHGpn3Qdu+z25xWeCoMFXgOKG8pWKegdsdBZyywlf/+zmcP3fD4L0096uGMU5BhruOxtUCt5Ypidv2BDVb0O/BD6Nz2WEnRJyGAaMNPdUY6tiOqem4XJr4+xX40EnFSVsJzlsdN9N3tQF0IEWTl8lMa5MUNXquHHOyfRIDmxL0ENTrws1u0+BxIHg5jHMaU2s00dUvsUq1nj0EMg6NXFuPvo8/uxP9+HceVOOBYbneaCpewcdlbIHbrMYnHpazYEiqkJBRRdC2c2D25OuXy/d/hezv7Il0oQeDdWR2pMpkwc4XyzFxMZdztWnOdthDNCftBVH7m9wxaxPJu8dn38/t7RST5WkAWiK+ovYMx+C9kkDK4nDvusayzN8de3q+u9mDLn8+0kG5wM27tlwPtiUfQuEr0oHAVNANewy/SLGuA343Bi+tmBCc9jxvsn77pjpnO2NBfTVFGfdmIk76IKByuxdG4em1Ls2k5ZhBIWzlnWHSANtHs82OCF0TugDUbuu8mYxNWeNmGA0f4EmfMsKKjZyPg1bSiTn8Ms3uL51YYUEv/F5ZObGDdJJeL7w6DlSFOfgWpqaBuO5tSh70XyeD+RFBtDJsfOxQNVHv0LYsHEHst09pWDQvTpRU6sqYCG7Mne94dMJVD3IGyb6PHjuelklp8oz93n9dh5eVrPJgOhu3V+Bmu3SfuIEup5hb2W+15ffCjbc7aVCQQOIR4Y3wVBo3wdnBImq4NCS7G/5v3xt2QweJmTqRap8DcKMmL1BVVKtFRToq7KVPfEyumuP38jZaYE
 7kDKngs6
 YvyVUckYFFy7dmVPMRGj4Fl4TdLZfY7Qd9lOq8Xq/7Vv2dSK1ElZzi6NsOzDgr5r5BKya1xWuCmZrOY0J6amjvSPJVDXqOUbML0MV+BuIhI8xsDP0Bvxgbf1OPKhOJqyVvk1FTqlfwXfwKS4e+biowbdDqI877l1NGAfosiYKHm17yLJcqJJnvAqeazw68LN+4Dd7INcqnL/vIP9kk09H/KrC4RGTVmj3plnnFlHm3tnAH+St37ZbDuFhOE2Zn6fCxkC5hsAYPV2ykw9whRyCOSMCXU0QtLvPwBmWW6jsnosB4cr6bHikRhG/DhiTNu2St6YDW3WwIbyoQhZ0Ky/mBS5cYNYImcx1b5ymEQC0wKNWgz8LVwlSEFIwlrxB1RZ2YTqcj39bWldGxTRA6aA9SUhJBJIgsCKnJuh6W+SR+3FXEgssQDq9InSkpD6E4jVhlxkw6XaWgPBaP4eLQvZVOIOHleZnvwpVtGUugUpzLAfS64Db+F9ox/6MaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 09:18, David Hildenbrand wrote:
> On 12.09.25 08:57, Kefeng Wang wrote:
>>
>>
>> On 2025/9/12 2:56, David Hildenbrand wrote:
>>> On 11.09.25 11:11, Kefeng Wang wrote:
>>>>
>>>>
>>>> On 2025/9/11 16:25, David Hildenbrand wrote:
>>>>> On 11.09.25 08:56, Kefeng Wang wrote:
>>>>>> The alloc_gigantic_folio() allocates a folio by alloc_contig_range()
>>>>>> with refcount increated and then freeze it, convert to allocate a
>>>>>> frozen
>>>>>> folio directly to remove the atomic operation about folio refcount,
>>>>>> also
>>>>>> saving atomic operation during __update_and_free_hugetlb_folio too.
>>>>>>
>>>>>> Rename some functions to make them more self-explanatory,
>>>>>>
>>>>>>       folio_alloc_gigantic            -> folio_alloc_frozen_gigantic
>>>>>>       cma_{alloc,free}_folio          -> cma_{alloc,free}_frozen_folio
>>>>>>       hugetlb_cma_{alloc,free}_folio  -> hugetlb_cma_{alloc,free}
>>>>>> _frozen_folio
>>>>>
>>>>> Can we just get rid of folio_alloc_frozen_gigantic?
>>>>>
>>>>
>>>> OK, we could kill it.
>>>>
>>>>> Further, can we just get rid of cma_{alloc,free}_frozen_folio() as well
>>>>> and just let hugetlb use alloc_contig_range_frozen() etc?
>>>>
>>>> HugeTLB can allocate folio by alloc_contig_frozen_pages() directly, but
>>>> it could allocate from hugetlb_cma, cma_alloc_folio() need change some
>>>> cma metadata, so we need to keep it.
>>>
>>> Hm. Assuming we just have cma_alloc_frozen() -- again, probably what
>>> cma_alloc() would look like in the future, hugetlb can just construct a
>>> folio out of that.
>>
>> I get your point，firstly, we could convert to use cma_alloc_frozen()
>> instead of cma_alloc_folio() in hugetlb_cma_alloc_folio().
>>
>>>
>>> Maybe we just want a helper to create a folio out of a given page range?
>>>
>>> And that page range is either obtained through cma_alloc_frozen() or
>>> alloc_contig_frozen_pages().
>>>
>>> Just a thought, keeping in mind that these things should probably just
>>> work with frozen pages and let allcoating of a memdesc etc. be taken
>>> care of someone else.
>>>
>>> I'd be happy if we can remove the GFP_COMPOUND parameter from
>>> alloc_contig*.
>>
>> But not sure about this part,  GFP_COMPOUND for alloc_contig* is
>> introduced by commit e98337d11bbd "mm/contig_alloc: support __GFP_COMP",
>> if we still allocate a range of order-0 pages and create a folio
>> outside, it will slow the large folio allocation.
> 
> Assuming we leave the refcount untouched (frozen), I guess what's left is
> 
> a) Calling post_alloc_hook() on each free buddy chunk we isolated
> b) Splitting all pages to order 0
> 
> Splitting is updating the page owner + alloc tag + memcg, and currently
> still updating the refcount.
> 
> 
> I would assume that most of the overhead came from the atomics when
> updating the refcount in split_page, which we would optimize out.
> 
>       Perf profile before:
>         Alloc
>           - 99.99% alloc_pool_huge_folio
>              - __alloc_fresh_hugetlb_folio
>                 - 83.23% alloc_contig_pages_noprof
>                    - 47.46% alloc_contig_range_noprof
>                       - 20.96% isolate_freepages_range
>                            16.10% split_page
>                       - 14.10% start_isolate_page_range
>                       - 12.02% undo_isolate_page_range
> 
> Would be interesting trying to see how much overhead would remain when
> just dealing
> 
> OTOH, maybe we can leave GFP_COMPOUND support in but make the function
> more generic, not limited to folios (I suspect many users will not want
> folios, except hugetlb).
> 
> Maybe just a
> 
> struct page * cma_alloc_compound(struct cma *cma, unsigned int order,
> unsigned int align, bool no_warn);

^ no need for the align as I realized, just like
cma_alloc_folio() doesn't have.

I do wonder why we decided to allow cma_alloc_folio() to consume gfp_t 
flags when we don't do the same for cma_alloc().

-- 
Cheers

David / dhildenb


