Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 864DCCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 13:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22F6F6B00D5; Mon, 18 Aug 2025 09:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 207656B00D6; Mon, 18 Aug 2025 09:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F6186B00D7; Mon, 18 Aug 2025 09:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF8AA6B00D5
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:06:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B417B1187A7
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:06:08 +0000 (UTC)
X-FDA: 83789901216.07.3C97D2A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 651521C001B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:06:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NQUcqskL;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755522366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6lWFVTHNTqihw285zTjFaouowYhqDI1uhwlP3YPVfSU=;
	b=loKQa9+M9FnaYkK9JZucMSjm0r5zJqpqn3ssSw4yGZ/2tilZ+FWSIUtYNcrPtVGS8uF9Ox
	sIWxPb2GfRpAOSPGuwIUSGcbLBz2rOwHwXZz4heU3Nt1LFAUxDcii+bJumXyTGcXaSnerB
	KNOoyzNQRC8PnJrygiVPWsrj6LzckuA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NQUcqskL;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755522366; a=rsa-sha256;
	cv=none;
	b=HTRN4risjASOUUZo4PLM5yJp9J/kkTnuxbD5ufxntqQiGk/WFkem6ICOnln3WlSJEqga9o
	/Fy5Jnc5YpcFu40syCqNAbxuTkFZG/n6VJEO61tbUF0Yrsk395WwYcFK1hH3i93RtatVyq
	J5jIf7Ip8V3zdew76INVn1Ggk4IhDm4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755522365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6lWFVTHNTqihw285zTjFaouowYhqDI1uhwlP3YPVfSU=;
	b=NQUcqskLtgb6ZPcTP8EoLEUMaOmw4F6OWd+oYuxVF7/uQDa+JN2XGpX+d7bSODOiTpSt7p
	xrKOZxaSVVy8DVWrpjrvFsFhD8Ks1nzlF94Zjrl57+vD9j1r9rxuZRV7oKgYihlmB4R2pO
	TuNu2yUlvwHHNuVpzZ6aPdbRSzcg2ZQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-c7ppxt3nMgWrtvYXIr1y9Q-1; Mon, 18 Aug 2025 09:06:04 -0400
X-MC-Unique: c7ppxt3nMgWrtvYXIr1y9Q-1
X-Mimecast-MFC-AGG-ID: c7ppxt3nMgWrtvYXIr1y9Q_1755522363
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b9bfe2c601so2409541f8f.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:06:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755522363; x=1756127163;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6lWFVTHNTqihw285zTjFaouowYhqDI1uhwlP3YPVfSU=;
        b=K29Z2q48XV7LVSRIkZn5apRv/0RZ/fm7WO+8XRn3WRQ/PHS4Zg04XDkN0HxDkjvVbi
         vPaovmd8WPzt+j9ntf+80nR7NnVFXz0wcsVVMu9E/Lp0R6Oxe3Sik7Kctcyy9JHLY13W
         fBHzDKWWITRvSQfEt3+o8Kaja0Cukid5W6wKjo6fayKSDPc8pfNQLawp6R5Aovq0QOhH
         2HfA8DMfWO56VCtrX9Nvl95Ny6j5vSj3w1GtuBu8MTX9UCaNTlIu+jQn4g9gbJ0UUD6D
         tR39k+oX6FR9IGFphJjb83CgTm4CwLZRb0hFje9q8t0gyyP7wdOlsqMoIiggObgN9dKU
         Ywvg==
X-Forwarded-Encrypted: i=1; AJvYcCUHTawFnnboZRSeE9WW5d1gAoBTPCDd0yBfGEIzNvVcFXHI0r3zMYlOO0mVYcxnojX+XhFBlQhiZw==@kvack.org
X-Gm-Message-State: AOJu0Yy9w02fmeHQq7HP6IIgittlVLaI25a4MVk0m143uBOERiR+Vyz+
	rS5lUAK8DcoxlA3Wt8PfVqthZy7bAnbbVzhZ6m/opDiWW0i948JexOYGQosemkYlDNXm8ER4sjr
	csJ5EeLUUYG2hDDyMgLYHfRgY7xhmvuD2OwdFikrsDz1Gj3b2LfMD
X-Gm-Gg: ASbGncvWydco5YLO6arEKNZ2fBpt7AYbUO9hNU6TL9ihKJoXe+sRqEYKAKxRnWAtpYo
	B6lTyUkJmt5HPkfT5SkzRwzYnd28NNi0kpyv3k3djNYi4R0aXyu5x1gImgrdh50VxdF0vcExXqb
	J1iUMf6oDlojUd0+vM9RwC8owIVyE0/FKPv2p45u6HDuGr5AR81p974Lv+7ukFN56+Y6IpYLQGC
	zqh+DGJ9CCHicLBtZXW1wmBk9mALEoIdYSGmVybg8iQyHuz3xc/R2DklOB50SnatWAEBnR11/K1
	OqNRhYRFb1KeTdJy0s7aW0wiQPqSEbwBojvVl/IHwkGD2c0BGTbGIFletZBlYphKepRR/ymLuik
	6u8i2rO30gUKYZ+rp1IvD0kxZfwdpIheLs9kGZ5VLbY8SL/b9XsIKaKCSh75/3O5k
X-Received: by 2002:a05:6000:2586:b0:3b5:e6bf:f86b with SMTP id ffacd0b85a97d-3ba5068102amr13511043f8f.11.1755522363102;
        Mon, 18 Aug 2025 06:06:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEfrgsoT1TOVtpG1c/AniLc8bVaw+tyzrLAfe8E6BPoy9cmQkiw4CgNBczPzw9LaWx4sWZxUg==
X-Received: by 2002:a05:6000:2586:b0:3b5:e6bf:f86b with SMTP id ffacd0b85a97d-3ba5068102amr13511006f8f.11.1755522362594;
        Mon, 18 Aug 2025 06:06:02 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:600:53c7:df43:7dc3:ae39? (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb64758690sm12914199f8f.6.2025.08.18.06.06.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 06:06:02 -0700 (PDT)
Message-ID: <cdd753ab-61b7-48ac-b535-556f39f46b81@redhat.com>
Date: Mon, 18 Aug 2025 15:06:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 7/7] selftests: prctl: introduce tests for disabling
 THPs except for madvise
To: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250815135549.130506-1-usamaarif642@gmail.com>
 <20250815135549.130506-8-usamaarif642@gmail.com>
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
In-Reply-To: <20250815135549.130506-8-usamaarif642@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dR9yMUMCRs1_SK8-33-RKEF4ImtkdV_MUCTvVhdBv0s_1755522363
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 651521C001B
X-Rspam-User: 
X-Stat-Signature: 9ckutxbq69w1d59a1kk1w7d1dbp1tchf
X-Rspamd-Server: rspam09
X-HE-Tag: 1755522366-965607
X-HE-Meta: U2FsdGVkX18NqrnH5eiL7skzmfOFM1rSHmirRohXSjn92GDlI1pjep3xKoRxY19ypjOIyWVM+dGEt8LXWM6Yk3SuDSwM95x284FkikIqg9cMCx7Hu3dR9pLaq95/eoIaCSnnC4mpS3FNsj37RgBukb6czvqfCZ7NBOWhF3T5FZyb7fUDVvX1S1dnLlRTMBiEzn2PlVMwlb6k6JgGGp15UN5a3ZZDhk2ej0S9qbKSxtd4ZSCSIOrohOhsfZIJreATDs/F/arG1b+VM/Cq/HnL2/xoWXU04PqzRCLR4UA09Mm4sIYjVGgbXgO77z3RT1vLMXASyhpfD7JCdbCJSrBI5a3nS1lvJauByR1k0l+hUj7gLF100pKe1SmVkfCx3syQVdoRhB30ICnmwC7dH34c2J+NS9xwOaf39shC/jDa83Ik4bxkbaYJWQ2jdYEabATpBKm74XWoZqcOI2M2GzFlag3t69Nhw7OW2wboMY1P6oQMhRR+wGkf6j/X7c7JX/KJ+dlTEetevRMnMdv4x4j/FQk9r/bCb0HlQ9x5tooKBVOXkpi0URhXdSRNXO5T0GEG4jczqCyJnJ/8aOUYFEVVmd4fpfDoTVfhW3hFDRVrLK+s3TR+StSlAOFzqXfZyO7sqeGwJIXwDgsvDuA9mtTmA8bT/3oITyXnumxmrG8NvtwruVehu22HGSmksOSTH5+JydBBQcMPLPnQ4wM+CyESg+u0KbG0HQZTAerQIkXo4AK7+uvd+Goky1+ZEeqkOiSInDLizxOgp5Ud2VgqUbqONzd/RnhNeZRM1Rtq1Wu8HPO01aCXn7F+CUYDKQS4P6tIc4nISjltixkzrU8cFTRMWw3CfAgFwiSZQN8K/rGK7OYGzFDdQH4VcF8x7UgLIGD6HcnVNqh3mZBVtgzV2tF42Ki4W0OSnGvh80j54g8KSzrAlR2U7H3bLvAOBVzyQsNz6FHzLQIDpEBA81WScXg
 MRtCi+ts
 UV2s7LD8TXXRvAGxbZ60EeeYlfxYRj4kcceJJRWaRYyBsQ9nmvQZHqAiHLzrSR3Bvl+e4K1KxNbMgtKqg3Zs7q3XGdQZQ5StnE4/zk1K3vPOETJYGfW3GKwHNg3ozdzUh0Wpmy3MqSkZIxfzXhk+AEFZG75pzGvmgJIZ0LoE8/PHYzWLFqQwgQ1Tik2apyEpKZtT409/dC1dmYpG4XCiukqksyS7uJpBJ90wXj9WcWIZRvxCXlIKBlOgM8r/0Lx8ubeUgwA3U/SHRdLeyMElH12NrNRyXBikpnW4ikbZDKkwbxCk5k7dL43Jpzmj2tnS7KvTRWRxCpgU5wQkHNNmLIsLvKHpboclPwLwx7dxSNDsC7moCTglePOhjU9C3SU7M+RE0d12q+excd/PwDQaHK503lQPmpYkzWV/yAlligzqN18RqvxjHnsvE9O1TGfvm0IpkwQJg3OZREBF3btRctpvWVVAIszn5D3ik1NDmzuN2lfd+BiiRiYyj1LNdt/1lwzXC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.08.25 15:54, Usama Arif wrote:
> The test will set the global system THP setting to never, madvise
> or always depending on the fixture variant and the 2M setting to
> inherit before it starts (and reset to original at teardown).
> The fixture setup will also test if PR_SET_THP_DISABLE prctl call can
> be made with PR_THP_DISABLE_EXCEPT_ADVISED and skip if it fails.
> 
> This tests if the process can:
> - successfully get the policy to disable THPs expect for madvise.
> - get hugepages only on MADV_HUGE and MADV_COLLAPSE if the global policy
>    is madvise/always and only with MADV_COLLAPSE if the global policy is
>    never.
> - successfully reset the policy of the process.
> - after reset, only get hugepages with:
>    - MADV_COLLAPSE when policy is set to never.
>    - MADV_HUGE and MADV_COLLAPSE when policy is set to madvise.
>    - always when policy is set to "always".
> - never get a THP with MADV_NOHUGEPAGE.
> - repeat the above tests in a forked process to make sure  the policy is
>    carried across forks.
> 
> Test results:
> ./prctl_thp_disable
> TAP version 13
> 1..12
> ok 1 prctl_thp_disable_completely.never.nofork
> ok 2 prctl_thp_disable_completely.never.fork
> ok 3 prctl_thp_disable_completely.madvise.nofork
> ok 4 prctl_thp_disable_completely.madvise.fork
> ok 5 prctl_thp_disable_completely.always.nofork
> ok 6 prctl_thp_disable_completely.always.fork
> ok 7 prctl_thp_disable_except_madvise.never.nofork
> ok 8 prctl_thp_disable_except_madvise.never.fork
> ok 9 prctl_thp_disable_except_madvise.madvise.nofork
> ok 10 prctl_thp_disable_except_madvise.madvise.fork
> ok 11 prctl_thp_disable_except_madvise.always.nofork
> ok 12 prctl_thp_disable_except_madvise.always.fork
> 
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


