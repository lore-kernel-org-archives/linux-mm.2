Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36ABBCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 12:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52FFA8E0005; Wed,  8 Oct 2025 08:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D98B8E0002; Wed,  8 Oct 2025 08:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37A608E0005; Wed,  8 Oct 2025 08:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2052E8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:07:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA0FFBA0E5
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:07:19 +0000 (UTC)
X-FDA: 83974821798.11.22897A4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4BD1F1C0005
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:07:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eiUNCypW;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759925237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o5FnuToEIzk7CULAIAJhbxtkKW+EwClFaV2jtolz3jY=;
	b=b05/8WCLTyxOOnfJFYDUP5NzUbswMRukBqYiqKkw+OwKPKVtUkLJPr1gF7Se/BnsL7JM2Z
	iD3Rsm5epqI/6/Xts2BE0bNMAAN2YX5nePe+SDfOUYPQucN9ZvGditKHpemw8fwT8TJpI/
	Axw/3Xj7jNCrL99r2Jg4rZ708eJoD5s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eiUNCypW;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759925237; a=rsa-sha256;
	cv=none;
	b=7nrUYvdV4u3u/wP8ZS2EN8qLvEVceKfbLmHUANF3sESsoct6p72gu6rF/DpWQQSUvq1/Gv
	c0BwHOYJcHaH0cMq4Qr/xM3J2+QkEPFpIzo1o3YeHoPJqEgRMv0P1ZX9vRXrX3chHoD/JI
	8TsWgPT0Lfpq9ImpZSM7FLl9lN7m5RI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759925236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=o5FnuToEIzk7CULAIAJhbxtkKW+EwClFaV2jtolz3jY=;
	b=eiUNCypWU94GrO2WRDm/fSgzcMFpuIHcgM+aF+c8oaWZPhKer/3PQY1oQIrXYx1KK3Ms6W
	e5jeWImavUBLgqbR+CWidadAx/nKevpiyKsbGYE0vRzlzk8hHTc3uedJzlTF/oAVAqJLfc
	z4Zr5Bfk3/rmteq6zdti2Jvq+m9PCAo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-UJyzNQ6dPm2_6oOfVelDEA-1; Wed, 08 Oct 2025 08:07:15 -0400
X-MC-Unique: UJyzNQ6dPm2_6oOfVelDEA-1
X-Mimecast-MFC-AGG-ID: UJyzNQ6dPm2_6oOfVelDEA_1759925234
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3f3787688b0so4095543f8f.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 05:07:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759925234; x=1760530034;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o5FnuToEIzk7CULAIAJhbxtkKW+EwClFaV2jtolz3jY=;
        b=Ps092PZwL9Tiu5lp+KuhAx+6VLaiHpMwW4ILE3J7xogilum0/3xuBgtHEXcL2JB26H
         Pysq3335ZDwmr/8RtCsSaRzZbz2j+ydqBNNXqCfJqk9kTrBTQh+e9quVDEwiYF31MlLJ
         5P3mwO2h+KLPR88dDg9Sp9fyP3tW7OrLEswOD26HfDGvk5Xv0hXitCR/25rCqrX1Dscc
         GdrcXNPaD7CN0wSfFEB7vWLiMggNcgtfdMW2wcgMfuJRPN/StJwlU5nPw1yf/vtOsUvO
         awSSyERfT9m69rPbjINLioKmHeUcAQIfOleQ76u0EyjY/dprUtcs7BIXoLtaAW+/9pwW
         gpKg==
X-Forwarded-Encrypted: i=1; AJvYcCUoleA23vzVEkqBYd3Pqpt07WgY5fKV2HuvDDkSCAKRgI4YV2GTxrPY3SZ9DbQOhARnNdrkZcnrTA==@kvack.org
X-Gm-Message-State: AOJu0YzpGmUk8WUVNr4dcwfputR/joPz7u5+MEKFXjofKYaZtlPdFWG1
	A5zguFZxsq5CPyEbtrOvmIvhVgJyukAN4nJ7OAPWTUHtrsT01TfJEUcwr271v1ShPB6tok/3ZeN
	52E8PgcddTqftY8cdX79Pb7Oa2pF8A07vPCFsaCkALsRWAMcMzx0t
X-Gm-Gg: ASbGnctj2CwN/vjRz8jB2hKAXJCBhErJ8uNOnnYoioXKAOyawhDLpbRBgg0MM/O8y6G
	Bni/E/+oOjLkZ+nvkfChjc1O+Ovmk81hyJ7z4C5Qn8xy0vHiTrCOvsJB7m+oMIi0HEIngG02WaD
	xFm8c5K6z6XSoJTfoOGD0uWguNInlkI9UHLWK2Aa5nXbGW5Y/rDuESY8QVg1MHB8DZmyRru11c7
	vB9OKZfikQQFdKwLz4Pc0PhmJW2UH1kht8IEqsvG4irZ+wJGKy7wDpCNh5afpgYY6Tf7q8XvQlW
	9hi6aQbuGX7wqoR8TmArxOQR0dRZ3WXYf3A4sUANgMuVtIDpZt3muybvyz3X/q1TwwcJZ6MM6D9
	iVPaTgi0w
X-Received: by 2002:a05:6000:2906:b0:3eb:c276:a347 with SMTP id ffacd0b85a97d-42666a9700fmr1720311f8f.0.1759925234256;
        Wed, 08 Oct 2025 05:07:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGl5UIHSQTiPUAwAyYXE6o47cthpdZyFFk38qwEN2BAQXdWDhiI44bPzc/OakXM6EvI0VCKJw==
X-Received: by 2002:a05:6000:2906:b0:3eb:c276:a347 with SMTP id ffacd0b85a97d-42666a9700fmr1720258f8f.0.1759925233689;
        Wed, 08 Oct 2025 05:07:13 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9d4caa4sm35056875e9.12.2025.10.08.05.07.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 05:07:13 -0700 (PDT)
Message-ID: <f743cfcd-2467-42c5-9a3c-3dceb6ff7aa8@redhat.com>
Date: Wed, 8 Oct 2025 14:07:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: Zi Yan <ziy@nvidia.com>, Yafang Shao <laoar.shao@gmail.com>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, baolin.wang@linux.alibaba.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, usamaarif642@gmail.com,
 gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 David Rientjes <rientjes@google.com>, Jonathan Corbet <corbet@lwn.net>,
 21cnbao@gmail.com, Shakeel Butt <shakeel.butt@linux.dev>,
 Tejun Heo <tj@kernel.org>, lance.yang@linux.dev,
 Randy Dunlap <rdunlap@infradead.org>, bpf <bpf@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
References: <20250930055826.9810-1-laoar.shao@gmail.com>
 <20250930055826.9810-4-laoar.shao@gmail.com>
 <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
 <27e002e3-b39f-40f9-b095-52da0fbd0fc7@redhat.com>
 <CALOAHbBFNNXHdzp1zNuD530r9ZjpQF__wGWyAdR7oDLvemYSMw@mail.gmail.com>
 <7723a2c7-3750-44f7-9eb5-4ef64b64fbb8@redhat.com>
 <CALOAHbD_tRSyx1LXKfFrUriH6BcRS6Hw9N1=KddCJpgXH8vZug@mail.gmail.com>
 <96AE1C18-3833-4EB8-9145-202517331DF5@nvidia.com>
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
In-Reply-To: <96AE1C18-3833-4EB8-9145-202517331DF5@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zqo6UDdXVH1MNSFf102mTiVe9yr2vYWKnTC1xgbORDI_1759925234
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7mfwm4hgy3c3rwe3hgswarn9w6q13xja
X-Rspamd-Queue-Id: 4BD1F1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759925237-465544
X-HE-Meta: U2FsdGVkX1/8gNAckwodIQu2CgsVFcuiIaQ01FAae3ExQpwMBFuworY9BZWoO5nCd4DwBDEivA4C3CulNNQnhEVwNZuqHCQNi92TXvB1nXtt0w+bJ1IRfBnCiErVwZTDnOClemySUJ9hJoOAD2gsEH0ya+/0wcOSouID0SMI02mgzehioqziUxWoTCyeF1tZ3Kf28QPAyvhA8jaDvu1rwvEc2Jj8EaAXO82zwmoi+nyjL4TqlKeC5zL22qKWv5OuHDVegtIdC3ukw6yNSsNRp8Pi2NcQSjBkOBjxPuVUk3ylo4ZEd33tgiLni1un90WV/CCLqUwDTl0iSJ8T48bXit1615MzttjuoN+lCI5r6Ag9wSPlGhcXiLEhYBOp322Naq/gc87eoiD7xhiIuy8O+wmBbywdUn73PD16MUKACCpu/26fDLcw/5PE7dV+aZqVhKUZqh+YftJsoWhqU5hDHjEq+jRmOwMGoOvZ8Hu4opl/vmZBgVJ1Nm5+ryNQmqACDa98f1WSindHMHr3pPUx/reSTGpEjWrovXlZl8Tk6zTRBA0kB4BoTl5/EfHDUkgi3kdvAJ/kqqY4NgKCmPtmmqaNL2XaG9TalAaLxEXbYv8pBNdAGe1FAoJONIrb3cZdIc/N4bS5Ukl9jWAW8VvkcaNg+sFNWNGQroO4QHsA4C4SePch3O2Mx8HIIby7YRSVBf04l+bI8e/9iV7BZBxQYSwTe6XJTueCH+bwkyEPw5XXJJ7pNr3tNTsLFwiC5L27xGyof7uyF1H12GPQ3/bo2sVbzcRe44SFEWmhtMCIDnJnistYuppc/ZIu3jyYmwEtzUD5tM3SgqKOnHNVxMCiVQIZm1pVieIcHJiMl8h26nWE0+VYFb++meWrOz4qW7sTrXKpcOmTobVzU8WLn9b3kd0iavKQpG6h2A9o2TWElYfDPMIhHRY+9jwaM4wHtMqIv/+anrHQv6qhQ+IjRsh
 lYwlGB1r
 NnGrstJZpoI1tylFRKupflc5ZrK8rGZbIj3IBxE2+RYjjVzL692PBImKi5J97ExKmHwplYhuwqhMAHQD98r5ofZ9e/3RlEX2nIZUfy8hG/qjEtAd/f1FF0QeOJ7MlVwcUH4myh+s156XiEPcc5HGeeYPB1YbnpM+7JsrR/wSUBQ9LdaVqB2MJxNaqhBjbNbK/N9E1UNqyCo4JmDouo9z3Pp8j2deD3sskpbzfq8ocecwsyP/jlWhI7j47Xnz54zDz1RjoHxxqImgtRWu3g7Ts3rR4F+jxWpbjOfFCgzuCY/3UdQ8+m29i/GTT0ixqVz0F1q43P+ExTr2OmErtnDWvDhxTm0zb+4daPUsDRGOOM4YRFPxJi55cJNXzSJE7sxfVPYtcUFe8xzdsnbcZxrlq25/MppzCdLW3Qg118HTqAp0hgJ3EuZ8MX1Ae9uYSePv0/KV7gdDhxxwhyGMdtj74eegGYTVpKEEhgMJ95V+RclsiBMxA1CT+6u32N6Kq70KjKv3/l362Ia2WmNM9yTNbTCKUcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.10.25 13:27, Zi Yan wrote:
> On 8 Oct 2025, at 5:04, Yafang Shao wrote:
> 
>> On Wed, Oct 8, 2025 at 4:28 PM David Hildenbrand <david@redhat.com> wrote:
>>>
>>> On 08.10.25 10:18, Yafang Shao wrote:
>>>> On Wed, Oct 8, 2025 at 4:08 PM David Hildenbrand <david@redhat.com> wrote:
>>>>>
>>>>> On 03.10.25 04:18, Alexei Starovoitov wrote:
>>>>>> On Mon, Sep 29, 2025 at 10:59 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>>>>>>>
>>>>>>> +unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
>>>>>>> +                                     enum tva_type type,
>>>>>>> +                                     unsigned long orders)
>>>>>>> +{
>>>>>>> +       thp_order_fn_t *bpf_hook_thp_get_order;
>>>>>>> +       int bpf_order;
>>>>>>> +
>>>>>>> +       /* No BPF program is attached */
>>>>>>> +       if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
>>>>>>> +                     &transparent_hugepage_flags))
>>>>>>> +               return orders;
>>>>>>> +
>>>>>>> +       rcu_read_lock();
>>>>>>> +       bpf_hook_thp_get_order = rcu_dereference(bpf_thp.thp_get_order);
>>>>>>> +       if (WARN_ON_ONCE(!bpf_hook_thp_get_order))
>>>>>>> +               goto out;
>>>>>>> +
>>>>>>> +       bpf_order = bpf_hook_thp_get_order(vma, type, orders);
>>>>>>> +       orders &= BIT(bpf_order);
>>>>>>> +
>>>>>>> +out:
>>>>>>> +       rcu_read_unlock();
>>>>>>> +       return orders;
>>>>>>> +}
>>>>>>
>>>>>> I thought I explained it earlier.
>>>>>> Nack to a single global prog approach.
>>>>>
>>>>> I agree. We should have the option to either specify a policy globally,
>>>>> or more refined for cgroups/processes.
>>>>>
>>>>> It's an interesting question if a program would ever want to ship its
>>>>> own policy: I can see use cases for that.
>>>>>
>>>>> So I agree that we should make it more flexible right from the start.
>>>>
>>>> To achieve per-process granularity, the struct-ops must be embedded
>>>> within the mm_struct as follows:
>>>>
>>>> +#ifdef CONFIG_BPF_MM
>>>> +struct bpf_mm_ops {
>>>> +#ifdef CONFIG_BPF_THP
>>>> +       struct bpf_thp_ops bpf_thp;
>>>> +#endif
>>>> +};
>>>> +#endif
>>>> +
>>>>    /*
>>>>     * Opaque type representing current mm_struct flag state. Must be accessed via
>>>>     * mm_flags_xxx() helper functions.
>>>> @@ -1268,6 +1281,10 @@ struct mm_struct {
>>>>    #ifdef CONFIG_MM_ID
>>>>                   mm_id_t mm_id;
>>>>    #endif /* CONFIG_MM_ID */
>>>> +
>>>> +#ifdef CONFIG_BPF_MM
>>>> +               struct bpf_mm_ops bpf_mm;
>>>> +#endif
>>>>           } __randomize_layout;
>>>>
>>>> We should be aware that this will involve extensive changes in mm/.
>>>
>>> That's what we do on linux-mm :)
>>>
>>> It would be great to use Alexei's feedback/experience to come up with
>>> something that is flexible for various use cases.
>>
>> I'm still not entirely convinced that allowing individual processes or
>> cgroups to run independent progs is a valid use case. However, since
>> we have a consensus that this is the right direction, I will proceed
>> with this approach.
>>
>>>
>>> So I think this is likely the right direction.
>>>
>>> It would be great to evaluate which scenarios we could unlock with this
>>> (global vs. per-process vs. per-cgroup) approach, and how
>>> extensive/involved the changes will be.
>>
>> 1. Global Approach
>>     - Pros:
>>       Simple;
>>       Can manage different THP policies for different cgroups or processes.
>>    - Cons:
>>       Does not allow individual processes to run their own BPF programs.
>>
>> 2. Per-Process Approach
>>      - Pros:
>>        Enables each process to run its own BPF program.
>>      - Cons:
>>        Introduces significant complexity, as it requires handling the
>> BPF program's lifecycle (creation, destruction, inheritance) within
>> every mm_struct.
>>
>> 3. Per-Cgroup Approach
>>      - Pros:
>>         Allows individual cgroups to run their own BPF programs.
>>         Less complex than the per-process model, as it can leverage the
>> existing cgroup operations structure.
>>      - Cons:
>>         Creates a dependency on the cgroup subsystem.
>>         might not be easy to control at the per-process level.
> 
> Another issue is that how and who to deal with hierarchical cgroup, where one
> cgroup is a parent of another. Should bpf program to do that or mm code
> to do that? I remember hierarchical cgroup is the main reason THP control
> at cgroup level is rejected. If we do per-cgroup bpf control, wouldn't we
> get the same rejection from cgroup folks?

Valid point.

I do wonder if that problem was already encountered elsewhere with bpf 
and if there is already a solution.

Focusing on processes instead of cgroups might be easier initially.

-- 
Cheers

David / dhildenb


