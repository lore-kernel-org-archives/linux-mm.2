Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7672ECA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 15:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB6748E0044; Mon, 25 Aug 2025 11:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8DF58E0038; Mon, 25 Aug 2025 11:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7C7F8E0044; Mon, 25 Aug 2025 11:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 943208E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 11:19:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3FBE91A0471
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 15:19:13 +0000 (UTC)
X-FDA: 83815638186.27.5FBEEFE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id E44DC40008
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 15:19:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CbXnWbrU;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756135151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+8Qu0u/8VaalAB9h3u7E2OosCBBMleTFRkPyST5G7FQ=;
	b=Fl+BCDARfDqFLuL8FXj0Ba+K0t8jvc9ys4ytlDsqBnxWXO6zpIzCzRx0uTaZv+To5CK2rl
	t9xwt3UsqIWc5bVYjlfGfBocbzbAUhy5HIj7Cpob4viWzoRt7t1LSE0Xx7bIS9HJF5zgbn
	cjr9Qv5yeL5zjCMaVxiABG/VE7Gj7K0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CbXnWbrU;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756135151; a=rsa-sha256;
	cv=none;
	b=jwlOl4XJdhyn2PTGe2ZFW88efk1sARgZ/6BzDZJ9RangMPqrLpIWE04PJ+Ykvr28WwNu8p
	ASWu0nicCfxJDvtiaI+NaIzQeeIj0aqU6cT+1NJQEy+3grcHVKYlfhU2dX+IBxf5Xu7MDK
	A6f17HgRpsVHiGGA2WSMJrxjfBuRdZ8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756135150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+8Qu0u/8VaalAB9h3u7E2OosCBBMleTFRkPyST5G7FQ=;
	b=CbXnWbrUa4LvcQ4JO3yHUDAjUmwzf92u5NRoD0YdcUkxnXp8Z2eyTCAIKqK/OnGiGcpXbs
	4go69O+Z88mCXyBSdIZ9tqLh1fMTRUsgbaVKyT08E1tFRIoY3eUZb4c5G5MDZzCZSeUef8
	8cf+M3vLeiOfnaDQ4YSFxLimlYTYFF8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-341-itDxN5DnNr6TGBwmEW-qvg-1; Mon, 25 Aug 2025 11:19:08 -0400
X-MC-Unique: itDxN5DnNr6TGBwmEW-qvg-1
X-Mimecast-MFC-AGG-ID: itDxN5DnNr6TGBwmEW-qvg_1756135148
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b467f5173so33360975e9.3
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 08:19:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756135148; x=1756739948;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+8Qu0u/8VaalAB9h3u7E2OosCBBMleTFRkPyST5G7FQ=;
        b=LvFrz8CmSCA1rM4DYW0bu5nC5HsridnJjTZAEpp1Jamhdc0gr2OkVdyiYsekn7kuU6
         Mn7bIZWNes4c+amiHD5BRWCWSY0NPLCHzyGCfbMPWr6BVlAVB3LJmTDYa1tzajh7gDkP
         H6JUtw8gg8HKS4z1B0s4iWsyg2L0cQSHDtdW9SfKS7azpmJckSm5Nn/rIToPTrBU7TU+
         QwP5a5e+k5eAnhace7c7+YHXSReEOfw1CnVqhsyfVlN0pR7NVCVtpKv636QTwx20m0RF
         bZBdQEbJr1Fx05CZU3o9H19FVdMpYnQG4VXJoT/pM+vU7brqETNQBri9/5S/2flyGUr7
         NXPw==
X-Forwarded-Encrypted: i=1; AJvYcCUDHPfXPIbxrhBEkMZlOozpLb5nUyWhIlitaNqGSl7PrQtbcZRO9mehJUtn7pn1e65jN+By1n3DKA==@kvack.org
X-Gm-Message-State: AOJu0Yw9hHvHjwMLvS9Fp+Wg9vMkGYKt2vIdNLuwZA7KpPh6sWcl6RcL
	PVTWIsTLNKeVb3NOPpx4/zfU/S/Da2q4W0hV+PUws2hqU/ca0z4UPVRWGjju/vXCfJkO7kd72wN
	vlK+m69gvCRZ0mR4psZ/ITA2yxget053ZitcaRdrNO43E1ITOipo1
X-Gm-Gg: ASbGncuNE7qb2xMSiOXyrDkeStmSIK8TcxXKwfXJqR5LxMkpeP1Oip8hmvqo8XQzON9
	wXmbE7O3Z6ocddPsjAbnI8ohOSvWLdPFlyjANGq7p4tWSOEj+57WRBmoPsijgJQwv3G+JBmCAvg
	zcTWH+BV1pGiiTVHa5admy6NZoB+hcaWFZEbM9c1LUeLGvDYbGi7aX5vw1SQC7L2832pf2UFGw5
	ogYabiN45sJxFsFigi8o0EjKX91KNgqZMfMsLb7zvb5ov+XuV9C+s5T7Wn8MmkSlGf4GxZpGxel
	n29++k+qoqfjhrsNWvEdn3gX4aDi+DNSfyh6q9sMmc8EgdAnQllXgpub+Nq2r89hHVTF4mLqM72
	ZE2qfREmW0A6+UVMjI/9VMxrIZEgmArVc2kipqYBjDCR7bMBoNilGUuhzAwt4jiymii8=
X-Received: by 2002:a05:6000:18ad:b0:3b7:8892:ed8d with SMTP id ffacd0b85a97d-3c5da54ed40mr9321932f8f.6.1756135147597;
        Mon, 25 Aug 2025 08:19:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmEeHLhPWiRsJMGTJgizh/SfTOdCkPcXSvkHli8LnUFicyIhY8gIYgsb1MvnwzeW9ZvuUg5g==
X-Received: by 2002:a05:6000:18ad:b0:3b7:8892:ed8d with SMTP id ffacd0b85a97d-3c5da54ed40mr9321902f8f.6.1756135147153;
        Mon, 25 Aug 2025 08:19:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76? (p200300d82f4f130042f198e5ddf83a76.dip0.t-ipconnect.de. [2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ca6240b4e1sm2156715f8f.21.2025.08.25.08.19.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 08:19:06 -0700 (PDT)
Message-ID: <dc92aef8-757f-4432-923e-70d92d13fb37@redhat.com>
Date: Mon, 25 Aug 2025 17:19:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [DISCUSSION] Unconditionally lock folios when calling rmap_walk()
To: Lokesh Gidra <lokeshgidra@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Barry Song <21cnbao@gmail.com>,
 "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
 Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
 Kalesh Singh <kaleshsingh@google.com>, android-mm <android-mm@google.com>,
 linux-kernel <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
References: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
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
In-Reply-To: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5aI-uJcw3BClACQyUGwBWbe190v1zDSy0MF0sTzuCTo_1756135148
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6317cy4ameym5w6sdunbyp494omobtko
X-Rspam-User: 
X-Rspamd-Queue-Id: E44DC40008
X-Rspamd-Server: rspam01
X-HE-Tag: 1756135150-375843
X-HE-Meta: U2FsdGVkX19tuKZh1xjnuG0ZjKRvhefqBMj1kPsKVNypdMSelBi0Rv5tn46KdHU0ueaf223+D5/BzYfqFYQnk+HOfNG+6AKDlzKi5PCdDsKkH0U5XvSuDz9bWOU0J3zEjHR+8FNng9nwpYCHBvp0SNr7AkC0BJuGDHP3wrUMQW6yX1AVAJX7VJdr9eGOSGg+hgTaXiG0B95ntJWrMfvrr2KTP6F4l3V8AQnvBw8CLuxg/Qzu2Wycso7rkIBfCqQsO0uAiqedfjGirXfmWD/7GVj6Qx0+CTcJ7Kux5HC0Qa7zmC4J4l9wXEk9BY2o1WQXz7IGvQU6+/xfrSanS/8E/uKPn9rOWx3VRujpJfa5CX6fxJBP3Epzvi4LvRD5SZE3OD0nwdKG306hL17P/eMX0Y3dXYv+Xhq0D4bvZn9qWxH0VXnv2XdM5QPBkzyST108VWpat32PX8PAzuv/vmrj4HFhTJ1lC5e5yqS1M7Z8i82xz+XkNp+S/DtqQv6OUiM4o6KQQdarwsYSiInYGoXiqu2KXKjQV8eiusQXCk6zTSzhaCqovnU5cjADGRXt6a7eFKnQnWH39iP12imWqxChuQdHYrcSCGFti/Sqp2QRgEbS286OESzrY2zQLPFdde/qk7NjxBcLYGH1FCUyX7RdI1OMP94hsJqEoVhOKeA1xxe17lBodtEJ2SGQQAcpagyOMcP0LM1FksprcSx0yqcADyj6GzSgHShsqr0Jhux+5Ny/jot8kxjmQM4fPg4hzCD3PPTjJY8+LiMoUIIWg7ohoc6ny4Yr7ZP11TVimTSLSIrSYMKEdA69Lr+ev5qQPOZ896IEBJlUEGwjGKsW1Gk7iY9IJz+NJSxDIRhE55UIDUsNlbN1s/+07HMZDR1DXJTcnBRE9qU7XKSbUcMKjwXldMfvF0HGkeOYfCElduEOMrXwYSwEjcDA6RdEZ6kjTxVYv2QddXG4glAIWdAW5LU
 eqIPxcbo
 rxHb6uwBgCfKg4F1i2ijIa93eWR0vhM3t3olcudMJtAtSHCrPyEm9w2S1CeenZeJqZUdKiU9G/UOmqUBHgycbfLicT+D/pQZ8fH22cu4PTl1jyuKrCPisGO/u2ZlsOqLzZhTwi//77EoCzcON8DHnU1B6Qiy5aS+OvSXv+XuF75bsA/uexsC2GCdIkFPb7zwAEW6WXqeRZsHmFPfa3yI74o/q2HLA5FneN5jMgFNalflhu7Pm2UZl8V+x/6GYGY6CqT41GDvbnHioDHtXOMQik7asyP6PFeeCFP8xcR53+BjZopw8kMJ2L975I+EqGTaU+xX9S1UGAhCGaC4yEtOQxM9kCYdMuuMcp0b8BvXGKMRx41rTzAk3sPaZILgrc38kZd/Csvy6a9t6sEN//urtU1SSmTRhyuICPclax4So0gXRG7Pyrz3lFLcho4XbUNNHIVsJCNd73LLHuDOPSWo8IEuUf9uLTXJyRxML094mle5M8LcP8twe2nRyHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.08.25 19:29, Lokesh Gidra wrote:
> Hi all,
> 
> Currently, some callers of rmap_walk() conditionally avoid try-locking
> non-ksm anon folios. This necessitates serialization through anon_vma
> write-lock elsewhere when folio->mapping and/or folio->index (fields
> involved in rmap_walk()) are to be updated. This hurts scalability due
> to coarse granularity of the lock. For instance, when multiple threads
> invoke userfaultfd’s MOVE ioctl simultaneously to move distinct pages
> from the same src VMA, they all contend for the corresponding
> anon_vma’s lock. Field traces for arm64 android devices reveal over
> 30ms of uninterruptible sleep in the main UI thread, leading to janky
> user interactions.
> 
> Among all rmap_walk() callers that don’t lock anon folios,
> folio_referenced() is the most critical (others are
> page_idle_clear_pte_refs(), damon_folio_young(), and
> damon_folio_mkold()). The relevant code in folio_referenced() is:
> 
> if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
>          we_locked = folio_trylock(folio);
>          if (!we_locked)
>                  return 1;
> }
> 
> It’s unclear why locking anon_vma exclusively (when updating
> folio->mapping, like in uffd MOVE) is beneficial over walking rmap
> with folio locked. It’s in the reclaim path, so should not be a
> critical path that necessitates some special treatment, unless I’m
> missing something.
> 
> Therefore, I propose simplifying the locking mechanism by ensuring the
> folio is locked before calling rmap_walk().

Essentially, what you mean is roughly:

diff --git a/mm/rmap.c b/mm/rmap.c
index 34333ae3bd80f..0800e73c0796e 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1005,7 +1005,7 @@ int folio_referenced(struct folio *folio, int is_locked,
         if (!folio_raw_mapping(folio))
                 return 0;
  
-       if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
+       if (!is_locked) {
                 we_locked = folio_trylock(folio);
                 if (!we_locked)
                         return 1;


The downside of that change is that ordinary (!ksm) folios will observe being locked
when we are actually only trying to asses if they were referenced.

Does it matter?

I can only speculate that it might have been very relevant before
6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive").

Essentially any R/O fault would have resulted in us copying the page, simply because
there is concurrent folio_referenced() happening.

Before 09854ba94c6a ("mm: do_wp_page() simplification") that wasn't an issue, but
it would have meant that the write fault would be stuck until folio_referenced()
would be done, which is also suboptimal.

So likely, avoiding grabbing the folio lock was beneficial.


Today, this would only affect R/O pages after fork (PageAnonExclusive not set).


Staring at shrink_active_list()->folio_referenced(), we isolate the folio first
(grabbing reference+clearing LRU), so do_wp_page()->wp_can_reuse_anon_folio()
would already refuse to reuse immediately, because it would spot a raised reference.
The folio lock does not make a difference anymore.


Is there any other anon-specific (!ksm) folio locking? Nothing exciting comes to mind,
except maybe some folio splitting or khugepaged that maybe would have to wait.

But khugepaged would already also fail to isolate these folios, so probably it's not that
relevant anymore ...

-- 
Cheers

David / dhildenb


