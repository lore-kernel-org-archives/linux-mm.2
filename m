Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C43B6CAC58F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 14:28:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B0388E000C; Fri, 12 Sep 2025 10:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260A18E0002; Fri, 12 Sep 2025 10:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1298B8E000C; Fri, 12 Sep 2025 10:28:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F25AC8E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:28:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A4EF413BCAF
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 14:28:18 +0000 (UTC)
X-FDA: 83880828276.27.A190853
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 305CC1C000D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 14:28:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q+6mGi8j;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757687296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/INHoqs21znnh/5mPIsed1nkXIhXp3uhrFdBDsES6g=;
	b=ZuP+zoSN7kEsGhGd3uFbl/M0Uwi8OOI4RnLSpCzVYC+0IiJvYlCJvYlU05Kh3CkxiSs5Pp
	7znihJ63mE6o8at7kvR7/268Sx5BvzlZpcnN0591+gw2G6u7Ob7lJ98l0w2YPlkstek9gH
	w/fUPE+L9b94fyldkF/OgDOzVP0GWnU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757687296; a=rsa-sha256;
	cv=none;
	b=z8uHxs3NRCDT2WIb7ZxmX29mSJUBO4afm5xf7szBh6ciB2KSsFolQxrq8mfqqbpIhNzas3
	3QgRSacCofQbV+YvQ6WjSsAsCZHwWPzgiUTibvQkrHEP0GgJhovZj0ny/mfQFoDzNWElhy
	n1txXtIlkUgyAzVtA3yZT/PAhtiNfm0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q+6mGi8j;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757687295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6/INHoqs21znnh/5mPIsed1nkXIhXp3uhrFdBDsES6g=;
	b=Q+6mGi8jD4XAjcgQOAS4uudcZ7vg6DdGxHeuZHTcZAq96jfpJU/YA2uln0DGf0W3OtyzQP
	M9TcY5H5duokd97CXWHMlTsMYRwbnw/Gnp7z/iLBvhCnV/M9uObEnsTuwQx6t6IytDxbXq
	9fB250yhgk9Dr6jmZqyIyLoXtXySg8k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-N4BOYsbzP1mX8jjdGxAW2g-1; Fri, 12 Sep 2025 10:28:14 -0400
X-MC-Unique: N4BOYsbzP1mX8jjdGxAW2g-1
X-Mimecast-MFC-AGG-ID: N4BOYsbzP1mX8jjdGxAW2g_1757687293
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45cb4f23156so12363435e9.2
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:28:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757687293; x=1758292093;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6/INHoqs21znnh/5mPIsed1nkXIhXp3uhrFdBDsES6g=;
        b=Is9NUKus1koEE2+qPHWKBvn7rCyNkaFG+peM15EsG4j4AU+G9Z0Eh3SFLUrKtj6Lc/
         W251Xz2WpVg9dP4LwmNU38lwyd++Tl6/Te1ETnC021EvOPIKcaEBbePqx5ZSKxRtGMaL
         lIgZ3rsteWrTvHPcKc8wZRV36vuwQF8r69tpQXLzz+4hmvjXxsz+sl3ep5bSYUYy5Mrn
         SCzdTMMVVHqR0OlSVveWJvLWlu37KUXQNJCaLGDF0sp4i5lwfsH49tdZeP0lQ7epcI9S
         kj+KHKIkdig2ousV+Q2YRiz3ssfVAw6iooFQn0gkrzqabhZaoIhL29JNMG4w/89zQcx4
         hEhA==
X-Gm-Message-State: AOJu0YzXPIt9JDv8UTiX5/Ha0cs6xSyuyv7zPYicA1wC5H8B1O524d+3
	zVkLtP1+XR8+FRls2F2ejJt04CEmE+qslUOBYgEEmF3VLuK7zf9Bjzryofg/nDVYWqZNq2CYzfB
	7CRMWxcrsgIspyMz+c10aYOV3SNMTJNl24vI9RCSQGy+q/FxBgElr
X-Gm-Gg: ASbGncsSzJKBoXeOcU0x6LfZEJsY+oi0dyC1XSyV+PyMLp8xBD9/JYK5mTlAs36tpgX
	qyU2NOvI3mILaHLCTZvlBVmRQBudiiGbDK2D9atgVHKT06a5fIMnc/ctVK5kFz7sfLe+MP/HGRU
	t055c53iHtTbcO59ruLMOfdeYDoccfUI3AnuHXFWoucCfFHHAyXdbBmaTBRiN1NxmOcDCSXF2ug
	HJ7A4JHORHtuSaeK91ix9R8D0PHkhg/1iwI+2VRGCf5MpxrX+o2PJMntaZBL1YZT95zbiV7KXWz
	oLNcds/k0Sc4yKhNt2toprkmnd/BUbjsGOQUuHYr1OQrjDw8dS7uHhgAzwP9Qu7XE7XJZ4wUTEJ
	gn+bj4iCi8yEZIjVfp/tDmqCCBOeuDr5+DYPAX+pHxx7yCcYXOPmlKuz67MCO9g2X4/E=
X-Received: by 2002:a05:600c:a4b:b0:45c:b5eb:b0c6 with SMTP id 5b1f17b1804b1-45f211c856dmr37602705e9.5.1757687292749;
        Fri, 12 Sep 2025 07:28:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbTRs/e3GPfZE3JTs6Oz0TWAjSTYauqRQbeN4IfxOKEi5vi5uxWU1if31ZxU9WsAv1EZxTuw==
X-Received: by 2002:a05:600c:a4b:b0:45c:b5eb:b0c6 with SMTP id 5b1f17b1804b1-45f211c856dmr37602185e9.5.1757687292159;
        Fri, 12 Sep 2025 07:28:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e015775f1sm68129895e9.8.2025.09.12.07.28.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 07:28:11 -0700 (PDT)
Message-ID: <ab8c2e03-53fb-402c-a674-c2c6ab11f54e@redhat.com>
Date: Fri, 12 Sep 2025 16:28:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
From: David Hildenbrand <david@redhat.com>
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
 <43f42d9d-f814-4b54-91a6-3073f7c7cedf@redhat.com>
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
In-Reply-To: <43f42d9d-f814-4b54-91a6-3073f7c7cedf@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _q-INM0myMaUv22XJSjRT6J2o4sjZs0168IyXtgJw7E_1757687293
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7bic79zpxf4fu1zt7assj6zmeft1iw4e
X-Rspamd-Queue-Id: 305CC1C000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757687295-525911
X-HE-Meta: U2FsdGVkX19HBbqPLHX9Q/+4fWpSr431y0S5wLhiqhcEmaVQjHlhc2+GhflnXHxjjdnbnasIBmLwQqQs/GcMaTFKfojIcNZw67Bogi2IfM1acST6CMJKIr5EglQEjIuMQujvfJ/U078bopQlH1ojKrTERR3LldHC8yF608drmRgigPn/yE5Bk1kFlMHGHLDwhuTo4PQXzwyXyydYRl9MpJWA5BZZoYb6YJMHcXJlji+c00dRPgs5D+DiHYvvzmGjbq2i9oZ+Pai22xUV/sfzAkOYpuOfFq58VzPKUpWhT5gOlOPGkeW4AqXgC7YLYYLr/Qt5kypzCkPSRqc+p6VzBADxTWN6sfr6Cu31NCLkVj5PMXiuOHM0yonwBl8qp8z8xlAWG/UKQ/VIIAX/v+KNiv/cOw1GsGEXAQ8ENcJdTJerZBKJ0Iw7zzIeFvVyimwc+6OBKo4TMsNLtZH52zNH9TgCnwM/N0wPYz9dNBjFGcscFHxPXF+lkB+7awJLy6zAy98ruib/CPZeR8cypXwdXOTC4KdPNPLh0uj1EwpfG689JvSTArN45mecb20At9T+iKSyjqQd4aaqFJeqbOMy1si9YDXDqatBfsWLMK1eqHN2snXja6YFh+r22NYefBE2gJdoZLE7sODLp+X3rZgvThpTfMMqtscS1ngIfZoSCglFQ3Pa9txJf63S4XPDfPdXQg3iZIfdaeelSi1y2kRVCaevoQYRxYCaBEAMzNsGadLQJh7mujqfESrlDXU/+3/VRYwER6ADPbYNaBUXqFhcaUltykFcL/7pfUIpKWJxZ0I0jnDQk7pHqo8uYOQwzcD5WNYMOkVF5viEoNNc69sJnFYf49tcui6tOrIT7l6cJURopHlokqwP2AmmO0ghFcAUezjZJH04Fd/s1CrZNI+qEip9jApEwUC4Zp0my+Cckk+Xthf4miuVjuDIkpIT2GHlU1lIAuiYyeNPO+E4anU
 5V90JqgK
 LA/emCfsR+dio2V8fyDIKMl0wo01MFoFXDbMOu0Croqv0ceUpIpWysjQswDbXNd9XQMqMovN112cj/vs5zSRPD/w9p/swlyzq4uz0gziKoPehvus8IgEr4nym3HY2XFF1Dbvt273PZDKW2eB5t7a58/fzbU6k/992e7Frb+LV/9xLQsR4qw0nYS+bUxVKOiYbOwuHxynvY9jjyKwf1PDlytCM7kUg0Trb8xCfayPqGvcTbyOgOhUNiXosqmeKjmddy0BCfpNIeO4Qap/zVjdVWi/ncJeb13Hf7A5+0CIXS5eC7njKZKlOKQFkHw+GL+P6CL1J7clYjYcKc8YgH0PUhFg8lZ/J6M+cEcmLhxnaJ7fPRHMoHMpxQTBQBExJC+AIuBP/4Rb5v2UPJaP+D9wZmlpKSzFFK0jsaRZQnd/W9Lkcp2qlBvDf4wlsFbrKZ6s+H30z7u2cRdnILGrOi5ksbO4iQA5/aSZdJ+CCjw8FcS4dAhh3XKRtWqSrag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 15:47, David Hildenbrand wrote:
> On 12.09.25 14:19, Kiryl Shutsemau wrote:
>> On Thu, Sep 11, 2025 at 09:27:55PM -0600, Nico Pache wrote:
>>> The following series provides khugepaged with the capability to collapse
>>> anonymous memory regions to mTHPs.
>>>
>>> To achieve this we generalize the khugepaged functions to no longer depend
>>> on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
>>> pages that are occupied (!none/zero). After the PMD scan is done, we do
>>> binary recursion on the bitmap to find the optimal mTHP sizes for the PMD
>>> range. The restriction on max_ptes_none is removed during the scan, to make
>>> sure we account for the whole PMD range. When no mTHP size is enabled, the
>>> legacy behavior of khugepaged is maintained. max_ptes_none will be scaled
>>> by the attempted collapse order to determine how full a mTHP must be to be
>>> eligible for the collapse to occur. If a mTHP collapse is attempted, but
>>> contains swapped out, or shared pages, we don't perform the collapse. It is
>>> now also possible to collapse to mTHPs without requiring the PMD THP size
>>> to be enabled.
>>>
>>> When enabling (m)THP sizes, if max_ptes_none >= HPAGE_PMD_NR/2 (255 on
>>> 4K page size), it will be automatically capped to HPAGE_PMD_NR/2 - 1 for
>>> mTHP collapses to prevent collapse "creep" behavior. This prevents
>>> constantly promoting mTHPs to the next available size, which would occur
>>> because a collapse introduces more non-zero pages that would satisfy the
>>> promotion condition on subsequent scans.
>>
>> Hm. Maybe instead of capping at HPAGE_PMD_NR/2 - 1 we can count
>> all-zeros 4k as none_or_zero? It mirrors the logic of shrinker.
> 
> BTW, I thought further about this and I agree: if we count zero-filled
> pages towards none_or_zero one we can avoid the "creep" problem.
> 
> The scanning-for-zero part is rather nasty, though.

Aaand, thinking again from the other direction, this would mean that 
just because pages became zero after some time that we would no longer 
collapse because none_or_zero would then be higher. Hm ....

How I hate all of this so very very much :)

-- 
Cheers

David / dhildenb


