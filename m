Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F73BCAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 11:45:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B23538E0012; Mon, 15 Sep 2025 07:45:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFAD78E0001; Mon, 15 Sep 2025 07:45:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EA5A8E0012; Mon, 15 Sep 2025 07:45:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AB288E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:45:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20307BA511
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:45:49 +0000 (UTC)
X-FDA: 83891305218.18.F218767
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id C3FB71C000F
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:45:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PO9Eef93;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757936746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Ng7yCw1wP5MZtSwh7Wi4NlfzosbrOaxU97IITYT9yU=;
	b=oTbpzfrjI35sjEb5qDpRV9A32t87rjLBJr8s3opT21ce3xU+UpG8pfq9GAitpM0vEvqkAg
	aYn67P9NuhL7Z7DwkOIJqOUM7CCQ0XpUbt62T5heu0UCLZC0KwAx9J8QPOdVJOzJfz4xQx
	o+DG5/2LW6DUuu2ltfV3ooWrbWfNHEk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PO9Eef93;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757936746; a=rsa-sha256;
	cv=none;
	b=m/g1NPqs2MjNxP6hTKkwJI4WFLkT9IKX/Hwbcgnej8HguG6PHX+ivKqvxM/MzirHu8W+sm
	e6crrHWJpAx2KNmKcKfpv/9+u0Q9yQRKTUb6KYEr6Q0+9hZ7MANsIPc7HvuYPQFClaY4MS
	425/o7mugM06Pe6XZ1fO7cURjJHbpOs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757936746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+Ng7yCw1wP5MZtSwh7Wi4NlfzosbrOaxU97IITYT9yU=;
	b=PO9Eef93l6e7At5hMF2Z8nkLDG+u8uIMXmkT3rwQtddr2TBj1bEcT8aYAo6/CBt1SC2l+3
	CmHTNXSB0+m/BAJLJY5LVtyDEOZxmmKl2sBY8v8pxFWO01WGQA3C+jC/Cv7duKPGChnYmi
	AaBE8wXurVDkigjSRxc7NdfiEyNvGfs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-VeJBNzUxMUy44tWkhnOQRg-1; Mon, 15 Sep 2025 07:45:45 -0400
X-MC-Unique: VeJBNzUxMUy44tWkhnOQRg-1
X-Mimecast-MFC-AGG-ID: VeJBNzUxMUy44tWkhnOQRg_1757936744
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b467f5173so27775565e9.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:45:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757936744; x=1758541544;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Ng7yCw1wP5MZtSwh7Wi4NlfzosbrOaxU97IITYT9yU=;
        b=beyDTSqbuIccSMSm4t02Kfbe9+TtbMLJmd/98SD9Uh5wtEje7pT/nKzZLgf5XfvvGO
         bhrCUYiaMztc5dqAN4DAKYUbd7d9nmqwoaskUC8AHHickRUJt9wxg64CJF485CJ2UxA9
         joBAIin0xRTTHoBS74qD2dZ596T2zij8ZNd8w5dgO/Y2eQp912Otm9l/OrkaBXuLlpGp
         /tA/BpqbyPsr/CRvjRwzldACTacl+4rC+qoPng/Hpk+INig4SXvKC1dLdLLmmRcE00mE
         /HQnH/cJUHdqxdK1ef/b97yFuP8H9dHkTDgfCne3jVogrx47X4cuFadp7OLKeLG5DCKG
         8JPw==
X-Forwarded-Encrypted: i=1; AJvYcCWGxut6HCZe6phGknfR47AO4xSSNnrpvBgjXW+AjCivMjhd97+kLG9ppOvqihveRLYskboFsqGFRw==@kvack.org
X-Gm-Message-State: AOJu0YwQN3hAgMEkxDFyD873gHSMj9B0zs1cNLIKYmsXoonnKOgyAgtJ
	5AbGcC7fvoQIo09zqaGQMu2K2wYTXnUni/1XkpLDoNkqFQJtqR5r/lOdH41jGPTyrcje5OUXo/F
	dHz0Hc/AY3N2N3ZNkucA1h5G/9OltGSEbObpwRs3xtnFLOSudKJbP
X-Gm-Gg: ASbGncue1kBlmF1ghF8c15VLprgJ45ScLPC6kkRfTqhYzSFwszeBjidpbk7HLietDlB
	soBTZPyk4Tw1/+tiVcldFoPWXORU4OwsxmwGFEYdQlRd1g+mhCXMICCaki+AWEW1HvL0+b2bDnv
	w5p5jaeW0N3eM9/c75ud1gkX7A/XgtWfwi2dgpMFtDgR2lcdABkr780563eWyI2EdP0mylMpIi8
	mnp5Bs99lDTg6833Chbq7uMTB0st1AIU6DQP4ZRmsxelLpbhMRu4M4mB81B0apb+DyXzVPWafvL
	5oQ48FaLAG+I6SGK3yLtCoBTgwErN4N2nT2LhmWemcdFVk0D+TQXyEEzpWzkuz5+D7K/IpIanjn
	jQvr5Ue515OcmjgeLDIMZyLWYzcsX7QqrSP5dLfnJGkxbbheooVkbLCyGOsj+fZPPS/0=
X-Received: by 2002:a7b:c04b:0:b0:45b:81b4:1917 with SMTP id 5b1f17b1804b1-45f211d5d6fmr95730265e9.10.1757936743672;
        Mon, 15 Sep 2025 04:45:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHHWeQtRmvajOk6PjvNrrZnGwcCmKaM8guZ/XD7rSJpezG2pi0yt91kJg016WDbZLNw0/ir1A==
X-Received: by 2002:a7b:c04b:0:b0:45b:81b4:1917 with SMTP id 5b1f17b1804b1-45f211d5d6fmr95729955e9.10.1757936743224;
        Mon, 15 Sep 2025 04:45:43 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e017c0643sm172762125e9.23.2025.09.15.04.45.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 04:45:42 -0700 (PDT)
Message-ID: <6ec80746-2945-485f-930e-8cc34446f9e3@redhat.com>
Date: Mon, 15 Sep 2025 13:45:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
 catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <CAA1CXcA+pb5KvEnJJqdf1eSjaFiBZ82MRB+KDmyhj3DbiQqOxg@mail.gmail.com>
 <enrgrocqajwu5d3x34voghja7pbvau45oobxgabawrly44ld4u@ahch3xn6rtq5>
 <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
 <155c821d-402c-4627-a723-6f8c88a2f65c@lucifer.local>
 <ae9d88e2-bab9-49fc-a459-d7b9a8fe9351@redhat.com>
 <ff4b6935-fd13-478e-9187-219fb612aac3@lucifer.local>
 <e450009a-56c9-4820-bd0c-da1d782d3962@redhat.com>
 <2757fb07-78bf-4a39-8c60-8ca8be200994@lucifer.local>
 <a48c8d89-da30-4a7d-96f6-e5e17757b818@redhat.com>
 <e0580a44-2afc-4f3e-8d3e-d4fe9b2eeb21@lucifer.local>
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
In-Reply-To: <e0580a44-2afc-4f3e-8d3e-d4fe9b2eeb21@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: u9a1c5Y89YZvhzbcNcy_xDt6vsJP0Tjr0M2GMOKNVAY_1757936744
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C3FB71C000F
X-Stat-Signature: af918rbcd5fsg38mdf4f1h3cwdua8jgg
X-HE-Tag: 1757936746-374634
X-HE-Meta: U2FsdGVkX18huymTGf40dXU0JsWjGk2AKpST1ybhLSo0zX1CIwEG5isUDt6QZBEVgh2Oiw6/uBEqlvZiBiKGIrZj/aR4aQwOdTG0j00AD9Fe89YGA2Q7EyynmGWCWupRxsBRxceheEpy0kF8BGd3HSWqxO7fqBdXqlgNoZvioSrzXJq4nAUo3plW+N01XLDpKKmgKx5m3tC1cr4MwrzmYQzXiVd/Q7lRjIoxu+4jSDI0vrUrOH6tM29KHIwf304KnPKgHv36vNCUO3mPZzFhgsYv9L7spJnFKBQkYZI+ty8n5QKOgdy1gIqxCH20kRiH7qWRsnZfwxsUkCYvQo5pL88H8ifcNlBb8p/z/rRvANLBpDoidffyDaQ/QkYtL59Rf6y6Zj4vPuaTCyrrMezerrGRdgIIIk+HcNzffrOa1leYnLHgU9O7kJoDRddNTPOT77SI8I1Zp8OFMjYULZLyKZpxHYulHzUQD2vASwpg/T/ulvlt/GJvW/q7SxUTdoLMiusZek67PgijJF1/cqOdvffD6oxPelgtPS/uUjvwpzFBq1CFIq4dWrs0TGM2mIaNOVLPyQr8o24hfcXLakFG9nZ8J/+gFUEafkjiGIQX0xOTnhOn7FO86LraGbkv19d1WUgw9ivAK4mpDBeAPXyEZ0W7SdWgWIr+z0JjoIhRKNGhA91g+Z9UmPO1UVYWKJX7QWGf4Ox8fK0c33v92Loz72wH8JlY1bSyXY9rdDvKCGzBR9Zx6IK7tMY/WutMY8kOvhjEFlaf1PVWkHnxxojyxmsTwug2dTTfN4sUh0B+RYrEvQnFXBwFkrwPf+KOUXSNAn++7shT0fSZKnFD8YsUEfbIWRRPt4rWhznOIeDZlgQfYWgqhvRk04VNLtrq7buQJ3HH/YdhfbhI056UU89xrVKGHfOTcOqxdqLu9cP1eDfHXfoBn/hjWDkYcXv//UqJACDUrT4RLI/aU/PJDCg
 WNc6dj3t
 SWuKQmYm174hw4VonzwCm574LJhE6i4P5k/54txFYw4J9dRA3j7XrqESGzhOAtahkU8o5UNXCgJWswfk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 13:35, Lorenzo Stoakes wrote:
> On Mon, Sep 15, 2025 at 01:29:22PM +0200, David Hildenbrand wrote:
>> On 15.09.25 13:23, Lorenzo Stoakes wrote:
>>> On Mon, Sep 15, 2025 at 01:14:32PM +0200, David Hildenbrand wrote:
>>>> On 15.09.25 13:02, Lorenzo Stoakes wrote:
>>>>> On Mon, Sep 15, 2025 at 12:52:03PM +0200, David Hildenbrand wrote:
>>>>>> On 15.09.25 12:43, Lorenzo Stoakes wrote:
>>>>>>> On Mon, Sep 15, 2025 at 12:22:07PM +0200, David Hildenbrand wrote:
>>>>>>>>
>>>>>>>> 0 -> ~100% used (~0% none)
>>>>>>>> 1 -> ~50% used (~50% none)
>>>>>>>> 2 -> ~25% used (~75% none)
>>>>>>>> 3 -> ~12.5% used (~87.5% none)
>>>>>>>> 4 -> ~11.25% used (~88,75% none)
>>>>>>>> ...
>>>>>>>> 10 -> ~0% used (~100% none)
>>>>>>>
>>>>>>> Oh and shouldn't this be inverted?
>>>>>>>
>>>>>>> 0 eagerness = we eat up all none PTE entries? Isn't that pretty eager? :P
>>>>>>> 10 eagerness = we aren't eager to eat up none PTE entries at all?
>>>>>>>
>>>>>>> Or am I being dumb here?
>>>>>>
>>>>>> Good question.
>>>>>>
>>>>>> For swappiness it's: 0 -> no swap (conservative)
>>>>>>
>>>>>> So intuitively I assumed: 0 -> no pte_none (conservative)
>>>>>>
>>>>>> You're the native speaker, so you tell me :)
>>>>>
>>>>> To me this is about 'eagerness to consume empty PTE entries' so 10 is more
>>>>> eager, 0 is not eager at all, i.e. inversion of what you suggest :)
>>>>
>>>> Just so we are on the same page: it is about "eagerness to collapse", right?
>>>>
>>>> Wouldn't a 0 mean "I am not eager, I will not waste any memory, I am very
>>>> careful and bail out on any pte_none" vs. 10 meaning "I am very eager, I
>>>> will collapse no matter what I find in the page table, waste as much memory
>>>> as I want"?
>>>
>>> Yeah, this is my understanding of your scale, or is my understanding also
>>> inverted? :)
>>>
>>> Right now it's:
>>>
>>> eagerness max_ptes_none
>>>
>>> 0 -> 511
>>> ...
>>> 10 -> 0
>>>
>>> Right?
>>
>> Just so we are on the same page, this is what I had:
>>
>> 0 -> ~100% used (~0% none)
>>
>> So "0" -> 0 pte_none or 512 used.
>>
>> (note the used vs. none)
> 
> OK right so we're talking about the same thing, I guess?
> 
> I was confused partly becuase of the scale, becuase weren't people setting
> this parameter to low values in practice?
> 
> And now we make it so we have equivalent of:
> 
> 0 -> 0
> 1 -> 256
> 2 -> 384

Ah, there is the problem, that's not what I had in mind.

0 -> ~100% used (~0% none)
...
8 -> ~87,5% used (~12.5% none)
9 -> ~75% used (~25% none)
9 -> ~50% used (~50% none)
10 -> ~0% used (~100% none)

Hopefully I didn't mess it up again.

-- 
Cheers

David / dhildenb


