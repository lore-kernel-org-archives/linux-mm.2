Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BE10CAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 08:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 536988E000C; Mon, 15 Sep 2025 04:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50DE48E0001; Mon, 15 Sep 2025 04:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FCE18E000C; Mon, 15 Sep 2025 04:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D64A8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:02:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD4DEC04F1
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:02:42 +0000 (UTC)
X-FDA: 83890742964.02.4469E52
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 636C210000F
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:02:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b0qZ9GjH;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757923360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NCGW5vXi3KzhsYVXIY0kjzcv0eF0LSLQelXGRAlgR0Q=;
	b=SZwMTDP1JF5s2cIrd2+7HSqacHFUlKyyNJVm+uCWL50BMyfRGbm33p4FCfjZgjhTHvBhvT
	wLznAr8G98aGhIawAaITwpxu+31fATIIBiPH6gixOosfic1Y0OqxabmoMJUsJ3PwRa4i/s
	0pI+gmy8tXC911bBBBxQp6VU6anENOk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757923360; a=rsa-sha256;
	cv=none;
	b=KLJ2B/kf5h6fm6pOfn2qPEhih45jTlnE0a29boza9ECrK6HtJFXm+YvX5XbnLzFnifDS2k
	aJ6jArktxEy4ZMEbgKhRFTdby9JoyoVJu9P1HKj7AEW5NltN10ZW9aqY8UjmRG8NFfMTPK
	a6BKeSSecUEAH3dnobDpM8ejGb/60F4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b0qZ9GjH;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757923359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NCGW5vXi3KzhsYVXIY0kjzcv0eF0LSLQelXGRAlgR0Q=;
	b=b0qZ9GjHLPnsuBU9vTjoBox9FmL9y/e91MAse325e33+x12rUWXp608wp8xS/WG2LcUC2Q
	CJrKlDW6pz/dyaNlHv4+uBtR2Ufvz85my1ruPQeMsZL/fwtRv1SoXhZ1jdJoqJgC2H4YIj
	owA21E4NaiYq56JtGDsjilDExYC8sf4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-oyhInI1GPxKMSGXmC3fH7A-1; Mon, 15 Sep 2025 04:02:38 -0400
X-MC-Unique: oyhInI1GPxKMSGXmC3fH7A-1
X-Mimecast-MFC-AGG-ID: oyhInI1GPxKMSGXmC3fH7A_1757923357
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45de07b831dso20899555e9.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:02:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757923357; x=1758528157;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NCGW5vXi3KzhsYVXIY0kjzcv0eF0LSLQelXGRAlgR0Q=;
        b=nEuEV+HS5WB/NAjOc4y820DCzYqeQS+nAvK7KLRcfE0+cs4z5hwdNjUGJ3i+v8djug
         I5WiouR3K7GvS1Ri+dsR4uq3SVpGuuI0+I6xUW2YPBXJX4nfRqBDJS5TYexhwvCI5KnN
         lZ/StBYWpj26Qlqper0ERuOTjYkzTkkHbLtgUdZ5ZZSAnc8pxKQofai1aQkNpCwx81rZ
         PECPibKFt7c8pXTCjtLQsiJRZIZFqNNPB3KFbz7eBXfhKjbHWiwvvDAayVmmBzOnmCnu
         6vXaPo75DkXFhJ3jPA400lF5K4TT6G7DWzN4ggjsgLmIFMaXktlO74YhiG8G/gGNvCd8
         90qw==
X-Forwarded-Encrypted: i=1; AJvYcCUZzXw53ZVfGjRHBO+zsZ7n90Hm0Lb8hIIhyS4u/ndT37ybwvx643WpNmbN58N8nJPSD1AMxMQRYA==@kvack.org
X-Gm-Message-State: AOJu0YzNi39FVIn+itmXbOqrC6cc51q6cVRcOLPytX2uTrWXE8s/u5cO
	FKDK6vghZyZq/BfLkdKKFYXZ6NRYQ2IInr8PIV5jYawyKYJRO8Z0W8SDLGmX1Nxzdwdwf/e3XVb
	LEwZdz8TKcXNIG5lIrcdfL/Nm3nxM2Gr2hlIryVFc0gC1snyXYEmC
X-Gm-Gg: ASbGncvIw4nCNvmRO2zZAdC99ntCxSm945/ZkIFdfKcRjdOvRm3zeoAb5JIDZK7MiKy
	6Ucbiw1pBZAZ9lkqcaz/3IVRvAhjleDCsF/jywGPYw3BIo6XARduDPw2CSMKqEE62rqh3v6wrDv
	Tzyyq8nsfKKcMjcerRplbUBEqigxFE7u9TuioNyvGsKy1p7hm8748hgc0Fx2f27BaqxOzrrI7gc
	XQt2idmGhcbSrS47le78Mw/DBe7i3uf3M2vESyz6IGDDqlrFulfb3doISO6ekEAeRHO2VGCfR5W
	iiTXGiMgf4K76rmh22P/AfJHTKjuNE3iAS0qnEYKS+AUkqQ3xw/911b90pFAx7Aot0Jr3yaAdIy
	IToLqSpD1E1zw6L4BEQl5MB189E2xqbAqPLHz8K6V0ZYnpVWnyFG0wUAHmBzKNUGH974=
X-Received: by 2002:a5d:64e9:0:b0:3e7:6367:2bc6 with SMTP id ffacd0b85a97d-3e765a358a4mr10536449f8f.56.1757923357059;
        Mon, 15 Sep 2025 01:02:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6s+X3rp+DWpbnXK5djiT/Xw4QD8km1FPeMVJ/NnzfceueHx+G34YL2pTs/L+001A0RK0YgA==
X-Received: by 2002:a5d:64e9:0:b0:3e7:6367:2bc6 with SMTP id ffacd0b85a97d-3e765a358a4mr10536396f8f.56.1757923356354;
        Mon, 15 Sep 2025 01:02:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e813eb46f3sm10069239f8f.23.2025.09.15.01.02.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 01:02:35 -0700 (PDT)
Message-ID: <053aa2ec-c112-415b-94b6-e4677262d117@redhat.com>
Date: Mon, 15 Sep 2025 10:02:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 01/15] mm/zone_device: support large zone device private
 folios
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250908000448.180088-1-balbirs@nvidia.com>
 <20250908000448.180088-2-balbirs@nvidia.com>
 <8c5267ec-cc85-4eff-b890-eb705472e2b2@redhat.com>
 <f98d3149-9cc1-4211-af8f-e49547134b8c@nvidia.com>
 <244005a2-4796-4985-853e-f916bdfd096a@redhat.com>
 <ce40579b-4ded-473b-8fdb-a41d5b5021d5@nvidia.com>
 <3674bdb2-0e59-4f0d-8adf-4794a6db546c@redhat.com>
 <227ee2b2-3c1f-449f-98f1-29bde663bfdf@nvidia.com>
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
In-Reply-To: <227ee2b2-3c1f-449f-98f1-29bde663bfdf@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zmy2lR7hVpJz141sDNwf-O13e_ohH6UNrpbdZZT8C4Y_1757923357
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 636C210000F
X-Stat-Signature: 1b9tcco3w8ax94nxut93zpmxugyukhmi
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757923360-341783
X-HE-Meta: U2FsdGVkX19OCjsc+pnMGxxcySti2v05DXOHiKnuJ/3eCiNCR4Ca+O9PlqqahT2LavbsEU4gTdCx7TOuq4dbeWMvDcVACfb69VRsL6FmDeYkd+F93CaVCOqCFwkDjiVQQLDk17bazxb70hewFDSG269gdKIM5B4P7LlOgnZJLatQPqaZ2A6IZQgalqvRY0NQ7SxBYiGO/eQnQi82riaNC1lpZt8giXeHBjGbs6NT1FttyLVzPkNLYdx1yaP3CTU0sm+J9UWOzPmru8T8bkmoZajzWZfEZ0x1nzeM439oxdRGpwgjywsyowQpaNsnhawdWUBuBsxdXEQUbts21hPsf1rrSZcguBx4cWios+O8GVNOF7RJHKXn/NvVlEM8VF/ovIhTlGKHKFWgyKCIM/bMLy7LOj7IPyNWTGtMxcxAvX2XrLAGbywt9qE7UJBeK3NVGxDh30bFjcBjuvaRVBpDwHqhf4aRFpnZilKhwiCyyL+RImVYGevcHcdBCtfi9u/Oa4RtcmBIXFF/FLabRmTyISB/eaKiehRQYP8fhDQY2XL0LAOseuLZii1Ls3pNXPY+/E2IR7xBiLBBWLT2xEzsobTZIYE1YX18ehkL4yaa5reUsoh6X91NhRAKwIk7aZtReqpq6clARaH4Ku7hZkNRqC4LMmmaReIY/lwoea/YkxnjjC398o0DV4dh2DTZ879RfQKkBQ5ThphYYQMGPYAjF8Vb7i0f5Vey8xz4xxjmZSA0zhXkD2zt/aZxgIRaA/bCq51Vks+TWTw5VPVKo0gbYk68nMNUADSNSWk0vnkwOMgdaL/J9ia456cbYeq3y4fo/Pw1dNEuic3zT1ZxHdzjZ2Awi17L5bmkkHTj2LmT2FwX/reGCHgFSq9FnXawkWDkWUU8Zf4YRlNZ7qYJpqIuxpc9d27R23wUuhH2un8EOmWrGzDbXCBvw3zCkkGJAEVacCJlFLUAa97kKaIzbxb
 o9USYxs0
 lk52EW7wX3aRVLBsVa3r37B8UOXJgJuvcwb8lnNKxpe8kkWljEGvuveHzTZ9TMr3m/xdI1a/GXhumeMEVk65XIv1Q7ky6RjbO4y4uhjmNvkVd5kgy8rnQ6kcEiILYCEPjOqIKWAvySagJgnZuNvI9qWO2UBu5+zAGVycGDV42twb8Hf1aIF/535mq4xUvSLVfUGLW59AH5thFN6GNe1wvIrTXiiH4gwSVgLqIseuWIA6OLtOE+XM78jZSEc/iyOW1jLU8PKH/kqe5+mAvGYuJbDJt7hWiQOpm672zU+w0pAxLBMEsxGDNQu4niQWnMWEe6zReGiuf4rFT6wx4aU5Wvr0nQEQZrbsrAOrUBO9XbM8xqcAkZBCLhDZ15XID/VfF3E3JBSqD5cg0nWikN0+5lksqEGJEzlg/6XfOWt4KWZdNfEDPjuoHkiNuGXqGXan1lCNW3TxucHB7Bp+YgAZz7gyvZI91Q9T4HE2y3iuP05T6ey0beD0Yf6u+kZMxw+YgBDiNLHMOFKBmbibRXMAC4rtpLxG8fy7BbSoUxJcNh3ORtAr5dYsA+XoeIEfWIL5CtnOLrSVSAuFNfWwxhFBElASaHBV+QXUs1nKdKYriwngPJnNm/RBW719l2lGcxNmPiiwVqVcU8gTucsAx2rMD/JsysI0WHnvN1GRf3AdYg4yLXSqEbIM5eQ9t9JshdjaMM+GhmwDEYZD5+wMfZpf46fXZand/Xx+I2mCf9H7Vulm0TSURc+qV/CRb31xAOkO0jOTBP4QGkvB2eeMIDsJM8Nv4WfskJ36smUN9n7Xps2PtNJePUKzU9RS0bKndfaBEWVAHJxFQ6aCiu9LezR5EEkmsNQVKNN1kwcC4Ql9IGC/BRyQBv+id2SDRawWmVS/L3rUwrGho0gIeDTKR1w+VMGiSTx9Km4p6wKSPNHoaPc3qFbNpFbcagM/+aA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.09.25 01:14, Balbir Singh wrote:
> On 9/12/25 19:20, David Hildenbrand wrote:
>> On 12.09.25 06:49, Balbir Singh wrote:
>>> On 9/11/25 22:52, David Hildenbrand wrote:
>>>> On 11.09.25 14:49, Balbir Singh wrote:
>>>>> On 9/11/25 21:45, David Hildenbrand wrote:
>>>>>> On 08.09.25 02:04, Balbir Singh wrote:
>>>>>>> Add routines to support allocation of large order zone device folios
>>>>>>> and helper functions for zone device folios, to check if a folio is
>>>>>>> device private and helpers for setting zone device data.
>>>>>>>
>>>>>>> When large folios are used, the existing page_free() callback in
>>>>>>> pgmap is called when the folio is freed, this is true for both
>>>>>>> PAGE_SIZE and higher order pages.
>>>>>>>
>>>>>>> Zone device private large folios do not support deferred split and
>>>>>>> scan like normal THP folios.
>>>>>>>
>>>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>>>>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>>>>>> Cc: Byungchul Park <byungchul@sk.com>
>>>>>>> Cc: Gregory Price <gourry@gourry.net>
>>>>>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>>>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>>>>>> Cc: Nico Pache <npache@redhat.com>
>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>
>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>> ---
>>>>>>
>>>>>> You missed my comments of this patch in v3.
>>>>>>
>>>>>
>>>>> Hi, David
>>>>>
>>>>> Looks I missed your comments, just checked those were largely about alignment and
>>>>> integrating the code for DEVICE_COHERENT and DEVICE_PRIVATE cases into similar looking
>>>>> bits for zone device folio free and code-alignment. I'll take a look and update as needed.
>>>>
>>>> Yes, and the confusing folio->mapping = NULL that I cannot connect to THP support.
>>>>
>>>
>>> I can remove that, let me reunify those bits, seems relatively straight forward
>>
>> BTW, I was wondering when we invalidate folio_test_anon() by clearing folio->mapping int he current code flow?
>>
>> I mean, this must happen at some point when freeing device folios.
>>
> 
> The free_zone_device_folio() code does that. Lines 434 onwards there is a comment that explains it

Ah okay. So it's not required at all in your case because 
MEMORY_DEVICE_PRIVATE is handled through

	if (pgmap->type != MEMORY_DEVICE_FS_DAX &&
	    pgmap->type != MEMORY_DEVICE_GENERIC)
		folio->mapping = NULL;


You using "folio->page.mapping" instead of "folio->mapping" added a bit 
more confusion :)

-- 
Cheers

David / dhildenb


