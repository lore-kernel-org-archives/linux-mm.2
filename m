Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A748ECCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 20:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DF618E000B; Thu, 23 Oct 2025 16:03:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B7168E0002; Thu, 23 Oct 2025 16:03:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE7D88E000B; Thu, 23 Oct 2025 16:03:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFBCC8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:03:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8DAE58914E
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:03:13 +0000 (UTC)
X-FDA: 84030453066.26.6276545
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 339C640009
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:03:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y1q1VHhU;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761249791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QPUi1jKCUzNIqjtqTEITsV04BJ5RU7P6py+r44ygz4A=;
	b=hy714jTFnQIjP/CPWVy0zmZHunu5WLaWfdIKnsvq/V9NWQpOjGb2eLxfuxC0eI5r2XUKwK
	jTdF0QfPO+BjHoDgNqPdHaxqx0P9MRg0TNf/G6WErkkoAyQ2piZhz1U/MnKoex5K4rJMnu
	2PV08LfJEpz9tNI8K+FAUAYjKwkO7q8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y1q1VHhU;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761249791; a=rsa-sha256;
	cv=none;
	b=oURjwQq49mgZVHurnVaONgjPaou1TmV4c/b7xRPUCXJahBQxkgpAY42APpRJ2nHHCImFHP
	qwO/jSV0ksE/2mMSGQw8EFL8F5Kd4K1AtTGbHMpOWepvfrVLF8BFNlGkFBffSu6292TKUY
	HpJbvdFn/A9wIGFavWET8MvyuFfC56M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761249790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QPUi1jKCUzNIqjtqTEITsV04BJ5RU7P6py+r44ygz4A=;
	b=Y1q1VHhUnUtbAfsLtetVtzpxjabLV1NTsI4fNMxCML9j6ZN1Un2/vK5KOp7SKSEklK+Czx
	DyO80aqMXpClMQhHVgHJ7ZqC2anbauKAnhqchE15JCQhNnaFkLuItd06kx1GDdyWpQBOjG
	CqChN+k32fMElHxmy8kacz88TWjjcC0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-5Ob8HuWLPryxSL2vdOkxvg-1; Thu, 23 Oct 2025 16:03:09 -0400
X-MC-Unique: 5Ob8HuWLPryxSL2vdOkxvg-1
X-Mimecast-MFC-AGG-ID: 5Ob8HuWLPryxSL2vdOkxvg_1761249788
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4270a61ec48so796596f8f.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:03:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761249788; x=1761854588;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QPUi1jKCUzNIqjtqTEITsV04BJ5RU7P6py+r44ygz4A=;
        b=CuPT961hcc7uivVe21fwAq0K9d9Cxf8mRk6C/ArQvgYCsaefEW0yxMeWCEM/WOdFQb
         j5FAT8UuWQgsG94ByfeDH968f6xnln7zIc8yDrI0z8CXyQbVV6kGxZyK626352/BHzp/
         LqIkqZ1Tc3MKV6rzi6l1Vctttb+Kepw1p7/DhNhC8xFew9ZvWs9i1X6Fpc1uLQzTgqTl
         vrxV+yMiDNvK+5+iXWR8O/yxdwkaEbi71ERMjhsbZhBnKPR4sTs4bxTpoA724q0tP/Q9
         s/5TumMECLyS0hNp3UJ7XJSCcaTgxXQeS4D87/T6NWpoFhR51BGc0m7l1Oen2lNcfkcK
         fnJQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3FLC8KevWHxeRrv6hxpGtKMS0aUA2kRVQDqdBd5LstclsFISm9XEize2wpctHPmDvpAFP71X77g==@kvack.org
X-Gm-Message-State: AOJu0YwO3RHl29qyHB6Z4zxeL+cubwHqlEQV31DTnll99+OuACE23uSz
	nNQqg5q5g21eX2socC2n3kympByT9Mr6JRP4W3P7tne189OOrge99eP1D5pOXJtZKmn2ijZmVqD
	N0hem7LE7ejFW+ML1kkPCBQ2F+5zZ+QjZybCCPFEF0hnYPbmjsEH8
X-Gm-Gg: ASbGnctSd+fXDN52KX2rsZlo9rGIzCHPUTgnzQRvypR5uzEuQHto6IYGJtVyfLJFJpU
	WWyjPPIWONdbl5zakltOd5Tz+a1b4qXe1ZEBQ/C9w3KWzd2n+/pxpXcxgUT44+5s8hNBjHG+7nj
	dWoZeCMJWAX9o4FDd0zFPjI0SHR51h3fprlElhXxlmFUXSHG7IC+ubaEFtzVRzeW6fB+MtetQz7
	WxKn6VW/TiihuLE3AZIuStaYhupcAc7iqQ2JeEk/P5O2CI8lrEkBg7lyuZFS2Gc7v0EkH/JmeJX
	tHsrSkeDFypq0+0BwHxmVvFJOOk6RvmFaDBtMfRVbyCJWrL2TpepmsUkt5sD1r8N1NzqNkJnxz2
	5sN8p/igLthwAhpym39cmtVeYcheN6srLjzg8+nizXKgYYDv1oa5OiYu+1FhgmUKnB5qBxx1NrF
	Jt5ZtrH8Fl/Zs0oiHtraXjkfBp9LQ=
X-Received: by 2002:a5d:5f54:0:b0:428:3e62:3220 with SMTP id ffacd0b85a97d-4283e6236ebmr11705611f8f.30.1761249787944;
        Thu, 23 Oct 2025 13:03:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGVpW2WfIyt9mGiyfA1hGoENq2TIdXWY1dpXbpJHoGGtaDtHStMqMHIOiYdTKz+oFfHpZxtMw==
X-Received: by 2002:a5d:5f54:0:b0:428:3e62:3220 with SMTP id ffacd0b85a97d-4283e6236ebmr11705579f8f.30.1761249787533;
        Thu, 23 Oct 2025 13:03:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429897f57d9sm5671794f8f.20.2025.10.23.13.03.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 13:03:07 -0700 (PDT)
Message-ID: <e8d31a8d-ad4b-4365-951a-dff0bc9535a5@redhat.com>
Date: Thu, 23 Oct 2025 22:03:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/13] sparc/mm: replace batch->active with
 in_lazy_mmu_mode()
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-11-kevin.brodsky@arm.com>
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
In-Reply-To: <20251015082727.2395128-11-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wCxiRXEQcSUE_a7lkg9mFy4V_2jTbZ94AYzzOI9v7Ho_1761249788
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 339C640009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: h8h1i9zzxrs4gxabzum9nwszgt1bqpki
X-HE-Tag: 1761249790-825915
X-HE-Meta: U2FsdGVkX1/xvfpA7Be1+Onv3AZjU6KLMM6wEZHbzg/gisz0gbJ1pWQ5RyTewG1+zlZG+T5VkxcmeNGk5ScvcqRXm3cVdVrxyMgfj4ISWIIOli8nRTdJYN5E50shCA3Mtl2kP4O9QhYwkyJzuedjWsfQqUs18TI9Q5rMJ2R+Aq+347cnhaSlaN6+wWmADyfVRKhlJtPhtU11ObsmGyXjSx17pSd2xvAEgXDqVMgnB5hEDjtcT49sFPxYaYv7iBrs7qe5nSDo0vKqAqCHAh5mu4N0c2HbSSodHi0TAxMVbLIzEZ3DKkzxyhNqAzsNH0Vsiuq6Bn7nI5gtiyzXhOYA6NrEEeIE7JcQ07xYnW1MKn9Trnk3oZjq2aB6bUFV1GUMd+G2K7+n76S7rql762hm3S6IOnXjWT4UeKTD9I+yeedmC7dtwDZHTE4aXzpSzvcgWBlTI+tFnmbYy3Dr2ScRZ5DjZ0NuL0BVqCpwYi6SomfxoZ4O13NEdizGzbIo+t+iFTqGuWzF8117dRVc9/CAuj6EIbwP62dzMMZV8RMBBAihEutP+KMkSFtLBdXWiBb8LVFDkw8n/KcIINdyXgiBdEFtGN+OSmqi0cB0FXpP+spf1lE9l4QJEsWrIosfhtkVHb3sHVUGayhL2cxAt1I1cMokqVDXNxvlFwULddMbS/89NBaCViRjktlohVueIeXmEmLbxM7gkW2x54cj7O/SkfVqqg0qPYVgXDVRslpWMrbHOWSAhwrlua2vqp4lwHUtAw+0Vjn4ysam8kvsAqvv7w7eEqNh4Rw3RYwZDfsdEm9mLxpA9rR4Lkdl98KxpzUJCLyssqPXSnHCc0HmFJqn4d9CpstWx1+YUCa+Cc5ysc5Ey/nEA+Pz6JrDJokqttfE0k6TQoJwdfCWU1FOTCvrfNIaVEsSt7RlQHuULsjBvoMg3AXhwN+Adu4+lyzozSauTRTb1Jg5WCVPzc92/p9
 G9EMwIGV
 upCkSUBXGk5dyuSPs2xGc60gIDRcUr+9sJYXz9EWBrY16IhdZlMGUIPjpLMzJ07xJ9PN0u9+7rTBwmCVl4Hbt358SA2LEWiv276XHOdAVoJe1UfxjCTTuYTGMDfXjzXgVHHCqnQ1vXn/ISxW/NvpD0FGCmqFRRKpEyhwGbWs2gC0UmYjZSjjFKGr0REIvol8Z/igVsuhe8i7FTVzAFQ9D6SpA2EfYpSudp5UcHv5M/vL1psZzQOFJmepRXYDzXPMpbU5tHbELgIa/4SE2VeE67GGh+R5TBoYoCvRI5OJ6ui54r7sC3fzdp5PhrAEG2+03eLmRQ8/bOUiZtndcv/GXakvn3ysylWAfF/C9TeOUT6xMuaib1lznR/TnNDhZyCAuU+23/00K7GTgbUi/Z6lghKxfLDPN3zWvfMbvDvF60rt1KhXbqOu6KZxFTrEPUF144CvMyQfwhJzu9jLE3wZ4ldVcTqSWFw2nrhq1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 10:27, Kevin Brodsky wrote:
> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
> mode. As a result we no longer need to track whether the per-CPU TLB
> batch struct is active - we know it is if in_lazy_mmu_mode() returns
> true.

Same here, document the dependency on disabled preemption.

-- 
Cheers

David / dhildenb


