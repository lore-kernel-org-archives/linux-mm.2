Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFFA1CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 12:25:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49F688E0014; Fri, 12 Sep 2025 08:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 476BD8E0003; Fri, 12 Sep 2025 08:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3656A8E0014; Fri, 12 Sep 2025 08:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 21CC48E0003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:25:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C220713B8DD
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:25:40 +0000 (UTC)
X-FDA: 83880519240.16.2B7F376
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4F88180006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:25:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=COR5gYVO;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757679938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wTo+izX1w//0z26IKQTIbvBaXy5RN7cB2ha614yOXr0=;
	b=CjkWXT7CAAiGZ5ERW/VpWbFDtSFDLLZwCqyaIj6FlJ4C6hE3CR/Y60Ri4pmPObxuDGN732
	cHRYVejCA+Mw1WOOSHgieedEJVExgRGRD+f6pT11+waFID6RNephKSC4zkn4wsMVNRle4Z
	R3l7IQ4VT8ssTccYTVtnbfnr8fqw0DQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=COR5gYVO;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757679938; a=rsa-sha256;
	cv=none;
	b=AlY1cwcY9XGCtad1Cd/TZiL9T7J6E/pH+opzfGmojbwHgcaUZzX/P/WH6Pa1QOcRdLuf2X
	5don2W3jhl02cz7NVbkocHpJTIGuK6oCKXX4ZTtNnX52WKvuXQ+bjTuY1gN5Kgpg0XUBDv
	t6NU+SAW09MVyauO90Sc4Wnrks6Hn+A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757679937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wTo+izX1w//0z26IKQTIbvBaXy5RN7cB2ha614yOXr0=;
	b=COR5gYVO8IQHtx64ybw10Nxjz5bcEZLpGRMaqt898a/5Iv5TA7DBlMjWPeFrXGaMjuQf0C
	/2mKOxeid6bFk9M+J+YXrjOOValz60Ok00D91kzTtWz+e/hQXE737L2JFGCJzMQ5Mm84Sa
	R7Rg+vzqwhgLD9kkKqk9JoTCZk3qrxU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-JWh0LvsUOPG6xnmc94p7vQ-1; Fri, 12 Sep 2025 08:25:36 -0400
X-MC-Unique: JWh0LvsUOPG6xnmc94p7vQ-1
X-Mimecast-MFC-AGG-ID: JWh0LvsUOPG6xnmc94p7vQ_1757679935
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3e424a186fcso995090f8f.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:25:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757679935; x=1758284735;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wTo+izX1w//0z26IKQTIbvBaXy5RN7cB2ha614yOXr0=;
        b=UVWP9fWESCReEvDFemcbeRXMJr4nYqEHh6FVXfJo5fTXCWLDPPBWFNPPZGXSFzTQx1
         823C3y+qupT56YgC4onhjmeluL+QD25tC4/xdrXeV359pPgxOfn5pRDbNjb0q5KM5wLI
         xxSdeIzcT5TP5akg+tbDfaQnd1XUQbMSofu5NjKq4gZBqAv0xnuQxsL223WnQwi0lRSm
         mnnA2ZTEH/eSY2r2gYGJoVhCGf7W8MF4y29NnBamquR/goFL6Cmykx2I/+SL71DM0rmk
         6V5lmenX3rbtscaKaBDqtd5Qfm7XT8TbrcQxDEk60m7sKoQ5s2wPXGALMpi8GnAhq3I5
         gjZg==
X-Gm-Message-State: AOJu0Yx/kXdJpWH8hW4Y5J3225vg/TOuz6oBxsHPrLPEAZBytwj3hHVQ
	f/y2lfgaByu36wpDpSq5zHLoUTj3VmHaG0rivbRmFKFwK0KR65yGNyrWeDbfyVADQret0e/Ik13
	UxZB6ZAjCsbOTXJHHBs5xSS4n1KSsIbpagMwXGFHi/RpjFd2BPDYy
X-Gm-Gg: ASbGncvaz6oLPc0LNOEVxNc00nhiuZQdvG7tUw6pljzIpXUY/3nBk80t+7rg45qV7sl
	uRQ7tSl71MkkyUUoUGZhdKG96lb4efks+Ih0lih9hJJMKMvh1Ga//DxgUKUdJXx9sjLlNF3L9ZF
	L/95JyWZ4Ujme3cdd+PSV6+kf+NPXAtZxtJIRuK1imqwhQBbGD7mzTWw8W/N6j6SGRDG0netAQJ
	UlChO8WpC5Le9NFEenYMWnLroC0/eWrBm0J8EQBqUzpYxr1w+hlvtjyD9qNvGqXhIuLYJot7c5j
	YVCixwQnJqWT6fWrvu7Ve+dsBvPy3i86XTsJVGXSnC7rpFUkA1Lf9JCVC2sFk1eWAr3nzKvIKcZ
	vl+exa6aAAlDv2k17uFnHbZRHDSZL484utKhexWCsek4p+Rf0g+lqr6454Nl5JveRAs4=
X-Received: by 2002:a05:6000:178e:b0:3e4:957d:d00 with SMTP id ffacd0b85a97d-3e7659f5dd6mr2519969f8f.58.1757679935083;
        Fri, 12 Sep 2025 05:25:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6PZSoaqYfs4WDxtD7xqA4jAMhuyLomw1mK3Dy9a1s3qWzRB2kaFiIuJKmlg+DYd89YE4p1Q==
X-Received: by 2002:a05:6000:178e:b0:3e4:957d:d00 with SMTP id ffacd0b85a97d-3e7659f5dd6mr2519910f8f.58.1757679934531;
        Fri, 12 Sep 2025 05:25:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607d822fsm6485239f8f.53.2025.09.12.05.25.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 05:25:34 -0700 (PDT)
Message-ID: <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
Date: Fri, 12 Sep 2025 14:25:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
To: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
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
In-Reply-To: <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DV0sMx47eS2zWwCvsqXZ-RnHgArAEFz_rZypmKXQt2k_1757679935
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4F88180006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 7h1s575dqqznx88wu6g8xis5kgf8ajq5
X-HE-Tag: 1757679938-450100
X-HE-Meta: U2FsdGVkX1++Oi1EkHIh/Z3bJlXh1yZYKmdzMHe+s3hS72mxJP2UEcWrzZm4Bvv33vZ9dtY63KFm59+87C8NWagjnw+RAv7Ls0/xKQ85IGQH49xi6rMSWVEFkFGNVhag3Yyj6fNyI16lfBg0UIqg+S2YW7Vfh5CaaF7+BYOCJ9oqrJmLru141BeAqNRxxQQKNOkSmlHEHVYMTTfvJf++AKUH22K8/RjkmaXGyoy7lhU8f02enjc5FZMsF0ailU71WiK6GyUrKD4i8cvbifPNu/WlyEEcmTcq+uIxkWtW5d5MIhxcujMo8qlu2v78dxkgdFiwbHtFq/RcHFWRLqvuKx96JQryXPIWZunUmoZIa7GVGUnLM88HLPQ5xO4439+4RBj3FKORDglPZSqLfUUFLqkwZtdNQJzHOwdCxui51L6CHfZQVTar4PgLyrCvI7pZBzZravpPt6qSdRmPwWzY4UMs0NoAEsBLgt5LINBsBjvPJdXFs4j3GvLyO1YRVc+HrzzIH16W/K3+oMV7f7JtVGJoVskfusFPawZ3ieoBdFPKX6Spb3XzL76R1Eqc76JCf+07YUeKCuIj7yNYNC77+b0ZoQ3ZIyGL8/dhAS/Hpo/Gik+02HdanWziRv8fpUMeNfR18DX5C1mnQxMpiwzEeZgU8rflBqAGwtMX65XrcLkAQZGVCPjDRwcn5hg+46vIt8K5RdkLGhDw+YOn2phkygtcGl8TiP4tjEF6S2Exfuau4mjoiYZ1JcO6X4OWpERlIV/HOUhU11W4jdG7uHkMOQ16mGqiolfvdQYHbwT42XstZUA4jYBfvYUncWy3SOpNyepM7Z3xyjC49QtINBdYzMauR4Xo19i3qMUTECUgxcGpZUiDZu0MpZoOaWCp9j6wSvXfzamOG/jHByHJveYDlFbHXsCPB0pk2GsULEtwYpyvRg25rHm0Ibehe1/8QHSGp42+HFT5AL3QayWH01c
 jDXIW5+x
 OX6PSwj23sI4tWKz70CXDG0ZsJFIbDA5KPyGKMAaedxWTEy2t2jedP6BBpuAYDwuagRp+xG15ny4KSweHRGq/LviNKsbzOxOg3MqgTy090RSkxpPfX9QsEua2EIaBYOZf4/Y4bEVWZTqzrmSO5oIMFAq8qG9YjtN51sWksAqX5NO9Glog3h4cfHGOyAbaE/u/1juV0arpAoDfjCXqPtNhigMAl/4Uonjruwi8etiF+yrO56VBTdi9CqC+b6j2crsV8dFlU6p+vPP3s67Oe8EZI/w8NBm0rdlD2TBbBPR2h9Gl40jIk6+dJMaqluZrRxGD9wo+CohTCBK26q9St/4qI9DnFhVwTwe/stdAnhEst/rJ3bfmomwB07TIU1x1DTLQ2xEERZ/ND0uK4hjoD5v/JZeY8JBfvGcxVYXXX4g/6ewXIMae4RRZVNehrAHA8BwEBuYJMwweBzs0leHFzsrzIpJzzR1erEV/VlB/jmA1X6JLF375XmCsxLMKqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 14:19, Kiryl Shutsemau wrote:
> On Thu, Sep 11, 2025 at 09:27:55PM -0600, Nico Pache wrote:
>> The following series provides khugepaged with the capability to collapse
>> anonymous memory regions to mTHPs.
>>
>> To achieve this we generalize the khugepaged functions to no longer depend
>> on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
>> pages that are occupied (!none/zero). After the PMD scan is done, we do
>> binary recursion on the bitmap to find the optimal mTHP sizes for the PMD
>> range. The restriction on max_ptes_none is removed during the scan, to make
>> sure we account for the whole PMD range. When no mTHP size is enabled, the
>> legacy behavior of khugepaged is maintained. max_ptes_none will be scaled
>> by the attempted collapse order to determine how full a mTHP must be to be
>> eligible for the collapse to occur. If a mTHP collapse is attempted, but
>> contains swapped out, or shared pages, we don't perform the collapse. It is
>> now also possible to collapse to mTHPs without requiring the PMD THP size
>> to be enabled.
>>
>> When enabling (m)THP sizes, if max_ptes_none >= HPAGE_PMD_NR/2 (255 on
>> 4K page size), it will be automatically capped to HPAGE_PMD_NR/2 - 1 for
>> mTHP collapses to prevent collapse "creep" behavior. This prevents
>> constantly promoting mTHPs to the next available size, which would occur
>> because a collapse introduces more non-zero pages that would satisfy the
>> promotion condition on subsequent scans.
> 
> Hm. Maybe instead of capping at HPAGE_PMD_NR/2 - 1 we can count
> all-zeros 4k as none_or_zero? It mirrors the logic of shrinker.
> 

I am all for not adding any more ugliness on top of all the ugliness we 
added in the past.

I will soon propose deprecating that parameter in favor of something 
that makes a bit more sense.

In essence, we'll likely have an "eagerness" parameter that ranges from 
0 to 10. 10 is essentially "always collapse" and 0 "never collapse if 
not all is populated".

In between we will have more flexibility on how to set these values.

Likely 9 will be around 50% to not even motivate the user to set 
something that does not make sense (creep).

Of course, the old parameter will have to stick around in compat mode.

-- 
Cheers

David / dhildenb


