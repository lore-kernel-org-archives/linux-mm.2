Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12251CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 07:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97C7B6B00E3; Mon, 18 Aug 2025 03:49:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92CD56B00E4; Mon, 18 Aug 2025 03:49:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A6A06B00E6; Mon, 18 Aug 2025 03:49:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 62D6F6B00E3
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 03:49:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3B1DE1DCBC4
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:49:40 +0000 (UTC)
X-FDA: 83789103720.01.6803A02
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id E41A0140009
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:49:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fFLqlTQy;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755503377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JvG7aFZ8aE0+JNevCZ82bDuwuz+Fa5f4Y7h7OdT1St0=;
	b=EqaEuQFb+8RJH3srqCe5dbc8a+ahGKZ211cDd0CX5SvkVi5HKeGTNpl4fMFi96aWSdyexP
	BI90ZXzD8etni6ZVCPy6riHS8zR7qKCP2vlyFUCGtkSa9hiYXdCGyv90ONQBLvCOyF4ZHs
	lsoKdUI5FyVZgLroFSk2tROsye/7cL8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fFLqlTQy;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755503378; a=rsa-sha256;
	cv=none;
	b=Q+VoS1gKXPPdGVMSv/au7Z4USVyHxP71ctKm/HI4/UkuQe2WSkFfYz7xGBBCs3TGc5Xall
	EMh6R7A8vEfT84xQ4vVAbR61qG/llrtBI63k8SQhXE6y+7i+nY/aJnQ+eu/85t6et8o308
	dD73DvCTZM+M2S+0muh+PtvItPuOBV8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755503377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JvG7aFZ8aE0+JNevCZ82bDuwuz+Fa5f4Y7h7OdT1St0=;
	b=fFLqlTQybQsFra5TozBmFhDZgP/djKCB74WYS1ZGMgUQNdftMAg3lVZJvCHVmHDSks2ZTG
	Xx6O5JGb70GY367iCEP9UkVnQUV4j6CkrKKN0ETWAqUB0eiOEEvOPYnNidisefTHkk4AzY
	MW9GpqQ/LqqC1JMVbLjSIpY89tJxHtg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-4Cac5ws_PlG26kT1H5bc0g-1; Mon, 18 Aug 2025 03:49:35 -0400
X-MC-Unique: 4Cac5ws_PlG26kT1H5bc0g-1
X-Mimecast-MFC-AGG-ID: 4Cac5ws_PlG26kT1H5bc0g_1755503374
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b05d251so20683105e9.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 00:49:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755503374; x=1756108174;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JvG7aFZ8aE0+JNevCZ82bDuwuz+Fa5f4Y7h7OdT1St0=;
        b=atr+7x2wxsZcaJ6g72vi9pkwapsyTL8Ec0hqgBCzDItZsMaZM8irBdhMeIcnrLL6/8
         XUdAjQzw0w7GtC7BtivAiXdVtm3vAoSdr2Dae45ZV70hSrPh7cAhPu7IMwnsPK84/PMM
         lreLKvhiTB6GZLol9nLFH3JTzonpIUx/GbO60/3PT2SE8muAyPxL2UdsXorWiNg69T2P
         Wm2AM0Cne425sO9bU9g+OBlHIDf8xkcYop4CE8puqaPt8lofKzGiigGSxqhaAG6DK2Zc
         guRVfh8zAK1rjQl+WpfOFxArJci+3jMcfq38L+k+JftYSNAmdESoAhlk6XCBpcjEx6Xh
         vKHw==
X-Forwarded-Encrypted: i=1; AJvYcCXCMjlp5wQzq7LPpJZzNoi1KUalNd+RRDWsncxX72hawgaSFrjdydCfaDIaIMpMB0L/+efc1Yl4lg==@kvack.org
X-Gm-Message-State: AOJu0YwE8jdq+ZRgyoPkY72U7LQHU2BZ74ySwNfdTx6WJjCdiJT07zIJ
	dSsUWLT/vlJHtapxscUWWbF3j/EEeUKdTGneBqXlzvwAs02xKVFogKVrYCMsqdwP1OP+CVjiS3v
	3QZ8AQREBVRRDEFkO3KN4KvjGGmnpE9+7ELNS/0IKB8qL40NODykr
X-Gm-Gg: ASbGncteTsO9z7aDRFUtzBoNxniMoPZZZlYPKSlbatkz+SvN97KE/752lrwoccowmOa
	oNrEdzGk2MJRGmSsDFjpgGgb3meHIo9G4ww83Ha+ullV8WW1KjO568eQSW8z+MLUeNIXuZdfTU0
	0XX5DpBRz5tBPkpy/+Q797vtgR0ox/T3RYuOXl1DNJ5TbFTDHKhl0MoiMsBOcT6feNs1sv6Vejf
	Zznf8sQx/HyfzcEe5HXtAoYyv1SuXRPMXfybsuTfFts4tyePUd1P49Ma66xfslABZR9jOUYI/4+
	P2VuUVvdAxu+KiBU5pgibORiF0JejHrM8Gb+Leg5GFLc+yYpjNIcP1PqIZv6rvs0pTqOse8iMGO
	jxp4/YGkhAhEPr2BsQLeL/YmqI2hS4xMFkFKj6MhzZOeeUS3a4RIUWm1FJsPt8Yl8
X-Received: by 2002:a05:600c:1c11:b0:43d:42b:e186 with SMTP id 5b1f17b1804b1-45a217f38cbmr64475815e9.8.1755503373782;
        Mon, 18 Aug 2025 00:49:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+R4BTN5wtqMrjV8DaHS5wNTE3hiVZhoPxXGSX+s7SlPH9szHPb2D+pX9sfU+sf8LvxTrSKg==
X-Received: by 2002:a05:600c:1c11:b0:43d:42b:e186 with SMTP id 5b1f17b1804b1-45a217f38cbmr64475205e9.8.1755503373303;
        Mon, 18 Aug 2025 00:49:33 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:600:53c7:df43:7dc3:ae39? (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb680798fasm11870486f8f.52.2025.08.18.00.49.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 00:49:32 -0700 (PDT)
Message-ID: <61cd1dfd-f51c-4f47-84d2-1f8b134105e4@redhat.com>
Date: Mon, 18 Aug 2025 09:49:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 mm-hotfixes 3/3] x86/mm/64: define
 ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings()
To: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 "H . Peter Anvin" <hpa@zyccr.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Juergen Gross
 <jgross@suse.de>, Kevin Brodsky <kevin.brodsky@arm.com>,
 Oscar Salvador <osalvador@suse.de>, Joao Martins
 <joao.m.martins@oracle.com>, Lorenzo Sccakes <lorenzo.stoakes@oracle.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Mike Rapoport <rppt@kernel.org>, Gwan-gyeong Mun
 <gwan-gyeong.mun@intel.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@linux.ibm.com>, Uladzislau Rezki <urezki@gmail.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Ard Biesheuvel <ardb@kernel.org>, Thomas Huth <thuth@redhat.com>,
 John Hubbard <jhubbard@nvidia.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Peter Xu <peterx@redhat.com>, Dev Jain <dev.jain@arm.com>,
 Bibo Mao <maobibo@loongson.cn>, Anshuman Khandual
 <anshuman.khandual@arm.com>, Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
References: <20250818020206.4517-1-harry.yoo@oracle.com>
 <20250818020206.4517-4-harry.yoo@oracle.com>
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
In-Reply-To: <20250818020206.4517-4-harry.yoo@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WrdOxk-UQhCCECsw5tAsQ2ozQyRrFujIPnQaYG6RqTQ_1755503374
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E41A0140009
X-Stat-Signature: d4ded7ftc7ymowypxtztw4f8ift8pxy3
X-Rspam-User: 
X-HE-Tag: 1755503377-734839
X-HE-Meta: U2FsdGVkX191v9cHeIWHPGZJrcH3L0mJusEsTJG/W+oY7AAwP4DR0LVYcm8M5ZM3ii55FjMCxSPyjSZ8PCkgehyubuNcfroTmTOBIQy7DB1p5n4MdufQSJ9OIDdvUyPN3pZn/rOhYTHCxVYy0YKfs7msVbsmUTlscsL9RAykx0Nm1IHIpZ0oOSLxP1pN0C73V9+t+DBGjhS+ieyAJtnuqWY5tP29cUHNZzi3O/XWxZsXFGegNLf3of4tf16CSEcNtP/ZkfegD8TRXm5n2JqJ3Yjt0So+BaAnED4hnJcJUkzPOSxXzA9qEU9CgCOo2w2tzhPKq2B5ssWmDh1Kaa0aVFW7R7mYyiGxHF26oSq0fIP7A49Sr11ZmZH+Z4VUlmFcclcgrJjVYhKopqHBCnR7RwowBa5QB0xIE9KAQoQkl3XXEozyS7udTrljYNDJjhBClzjrrjs+frItmDo6wSCYhEAVKLCZvIwnRV2+/rvwoZgnGyWLh0qQjSEk8HPIKYIb+blAPHeoOc3CIl+LotN3S32iCkhDmmrAq+HYSp20DPLNrPmKafcPAHyg8EN2+uadZJ3wLbqehRDL5kS5gEcohQxgBtvv5aQexwvz7mMkxSq2wDV7pCjtjxE96h+9tyQjtau+I4gn3fPNx2jr3gDoyUrlaM/awFjkbmeO3eeX/q598rg3lm7FpS1AJTzXP6l3SgFJjLYVFA7hsmctf2IcSOcJtDlW2ZE9h8JbRHu4NkGwT2k4He6QAlNbBtXEWG0YtcJU4DkMb6cIchyL4whKO65MieM5l7F+kGDwTPGXq4fX9Lr57baEahyern71Qsy5BJ4cp9n3iKQKfwm6bv9Ju+Q7KvGlarZjJMHPxaOjMb0E/yK4/VIBIBHC0OEIkOiHlmdEfQ/op9iKgqsuv4aWTQbKFPEsq+AqAo76hQe62rq2fJBr+jFhdZCu6wOSXNP20ewBe3s55H0OtuY87AL
 Oy+XPxEA
 SM2GRsPrjoeHnVEhFwqnKTov5C8ch3q+PjUdXalPJUawE7owcfPUZ6+dF/yiHQn7NEnmUFbhZ4Oi8P9Q5aFryTYOhRWMqOnblFfqXp0trcB8pN4/NvsmkVUne5CTM1w2nDUU65/+gUPrcGk40N6cUISfuKk2aCdJ9u5V9iXmB5YmG1/9edEjTQTC0hb+taqqauvC0qf+t6DFpFGo4HbSSzajZ2W3SmDmExFngv4SwnbQkCiTE12o201nZKmYNhAabkTM/J4ZCnGq9rZhQtX6qRzOKY4o8j1dwGESFbNYeOnD2sG0ovarSvl6/YoeIRM58PPBJoKFTE0WpDD2mjDo2UcrgHrKogLR/nY8pItuj2AUalM9d9Dkm1wwdgYlsExECAF4vfrpv5zLiLAMBrHSg3fJXhSCf5fJJY0p/TYavDlh7zLdId48xZx1+2/afQWZhZDAa4R89W07F/cpu4LYIDxPzcJSrs2UQ+0DNoamQ9uANznGUByTtcX+XK5gjzNzQwuebv3toz5zqnmngWM0pebvCvN4SbxicI8K4h/JSG9uNxrrecdtPs4ZWYpgthbghstWciJJ6fcBUNBLWOBc9Qnqk+0G18QTen6bf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.08.25 04:02, Harry Yoo wrote:
> Define ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings() to ensure
> page tables are properly synchronized when calling
> p*d_populate_kernel().
> 
> For 5-level paging, synchronization is performed via
> pgd_populate_kernel(). In 4-level paging, pgd_populate() is a no-op,
> so synchronization is instead performed at the P4D level via
> p4d_populate_kernel().
> 
> This fixes intermittent boot failures on systems using 4-level paging
> and a large amount of persistent memory:
> 
>    BUG: unable to handle page fault for address: ffffe70000000034
>    #PF: supervisor write access in kernel mode
>    #PF: error_code(0x0002) - not-present page
>    PGD 0 P4D 0
>    Oops: 0002 [#1] SMP NOPTI
>    RIP: 0010:__init_single_page+0x9/0x6d
>    Call Trace:
>     <TASK>
>     __init_zone_device_page+0x17/0x5d
>     memmap_init_zone_device+0x154/0x1bb
>     pagemap_range+0x2e0/0x40f
>     memremap_pages+0x10b/0x2f0
>     devm_memremap_pages+0x1e/0x60
>     dev_dax_probe+0xce/0x2ec [device_dax]
>     dax_bus_probe+0x6d/0xc9
>     [... snip ...]
>     </TASK>
> 
> It also fixes a crash in vmemmap_set_pmd() caused by accessing vmemmap
> before sync_global_pgds() [1]:
> 
>    BUG: unable to handle page fault for address: ffffeb3ff1200000
>    #PF: supervisor write access in kernel mode
>    #PF: error_code(0x0002) - not-present page
>    PGD 0 P4D 0
>    Oops: Oops: 0002 [#1] PREEMPT SMP NOPTI
>    Tainted: [W]=WARN
>    RIP: 0010:vmemmap_set_pmd+0xff/0x230
>     <TASK>
>     vmemmap_populate_hugepages+0x176/0x180
>     vmemmap_populate+0x34/0x80
>     __populate_section_memmap+0x41/0x90
>     sparse_add_section+0x121/0x3e0
>     __add_pages+0xba/0x150
>     add_pages+0x1d/0x70
>     memremap_pages+0x3dc/0x810
>     devm_memremap_pages+0x1c/0x60
>     xe_devm_add+0x8b/0x100 [xe]
>     xe_tile_init_noalloc+0x6a/0x70 [xe]
>     xe_device_probe+0x48c/0x740 [xe]
>     [... snip ...]
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 8d400913c231 ("x86/vmemmap: handle unpopulated sub-pmd ranges")
> Closes: https://lore.kernel.org/linux-mm/20250311114420.240341-1-gwan-gyeong.mun@intel.com [1]
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Acked-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


