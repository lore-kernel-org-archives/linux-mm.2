Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFF17CA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DA2B8E005C; Mon,  1 Sep 2025 09:54:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53C168E0008; Mon,  1 Sep 2025 09:54:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DCD08E005C; Mon,  1 Sep 2025 09:54:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 223D58E0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:54:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D62C616086C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:54:35 +0000 (UTC)
X-FDA: 83840826510.28.F5CAE2A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 93827100015
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:54:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TaNlM+Vb;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756734873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rkOxHsJ9lyozFAluE91xfQ0cGnpBD4cOEv8yb086+4A=;
	b=e3pW4r+42LAMfmO4oz+Yryci2aQTipjaOBjFFXiwokUu1SsTagoMAuVqAtXoi25mHKiN77
	7ufM3lJfyfqJ6oz5KdGnplH3sUZ3eP/2cz17ua6DBPd2/HxZqHAUQkJbR9sI3SdJRoEf7n
	wzSW2XDJ4X/PzlyWEe5jt4hIaKkT4EM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TaNlM+Vb;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756734873; a=rsa-sha256;
	cv=none;
	b=Vozeb8rNj+U7+X92+dS+lgtfMQZNPaf3Hmxid/6Mu3GqMpcxO1N5XOkkpyyOZOBml7sBDG
	WdT9T2QX/SmOKdQBpqeQ1Q7OVhGF0cHw2ubA2bQUcw2inY2OLp74j7CkdlOowkGUY2VuNC
	SS9PReeXt29Qg1MrEMWzBKM6A1dkat8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756734873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rkOxHsJ9lyozFAluE91xfQ0cGnpBD4cOEv8yb086+4A=;
	b=TaNlM+VbL8mxpLjUsubeL1+QeDpT0F1ZuhaNL0wTUCXYpqJCEc6TfRMzcqObGgao0MxsVO
	AvtudOL3QnCIWT5fUXLn6nWlFzuJHQXaCXKjCH771NfoBU6dThLeXwvA3SGUdE5iLpK7aj
	94RcAVVaYwRBUSG3Hzdb5NgaHM8pELA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-h8ALnN-2MzKy1u_YU9xlAQ-1; Mon, 01 Sep 2025 09:54:30 -0400
X-MC-Unique: h8ALnN-2MzKy1u_YU9xlAQ-1
X-Mimecast-MFC-AGG-ID: h8ALnN-2MzKy1u_YU9xlAQ_1756734869
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b7f0d1449so15623445e9.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 06:54:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756734869; x=1757339669;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rkOxHsJ9lyozFAluE91xfQ0cGnpBD4cOEv8yb086+4A=;
        b=FmR5w5LtZ/+TWA79aQ/fnyjshFivzTKFZ2T4KKPPjjifsMaYFtt37TQBbb1xIp8/AR
         Ro31KOjDeFjyrwgIdLrNmg+IfgibyTs2WlZ1pXMTVJU5VrnmUfVNuHgqSjOiRbqnItEq
         WaGgDsWe5Q4drgc/lkusgm2tDHbz6YHQ1LKjOQhsyl7yZr2QeKv95I/E7ueXmN6jzcwU
         0b+XIGOUP5nOcAKDciJrhEkaxmt8piwu78aX9ZcCNjsTGJ3ETVPiIrfwmPFV2QEwwosv
         2qt/a+cuxKuLCSRRKAaDMCytxysmTcJquoUokkO4JkaXeLRKsVzIczMDWtORWXTpBYLt
         iw6w==
X-Forwarded-Encrypted: i=1; AJvYcCVE3xdghXxPRN/AUuulp/5BOwBhj6n8M7j5aUc86SzwfzJ67/oz63xMXFbo3KIvh96sl+zFwnV/Vg==@kvack.org
X-Gm-Message-State: AOJu0YwXTgBJXFOBld4w355kBEqnyGggfAJoCvjWMEamPOtJ5SV5jpjt
	GTI6oQ9hjYLepBoLkZCD+Pcb53Xof6pevsKCvRTQE82JzTgQYWEaJpdGAaP9UfgRRRemfwgJvri
	Z+cRVD9XU0cq4O6l3XDSuSTeNqgJEWF6Fe+gQD+2+atPLAOWVs6Os
X-Gm-Gg: ASbGncspDcXlF/m/jtLEn1uWxqmHbphuhCZ2Egs7m5IecwGSMsbZenJJw2Kd6Ausi/P
	izKmxbWIUYew+A7E1vrrXmnYMlcbOjVmLLlp5cuo6o+lJCKDZw08/mnFzg0bbWv0nSiRxnOOsea
	hubFEK+FR4Q+JWoqAjnA93y5vlX2Gg1bWMWyzVBHadHVtrI2AC9ztsqiY6QLzuLvEkLOVFvq+ql
	cr5ZFFof2leoC60PObLBIxZnTIg5yae5PfZmTcmcLrOrh/m6zm7TuuzdQ05A/HMYu4v8KwsHymc
	SvqwbbrdiMdCpvmR2KC2HaVk7Wznrvsc2GqImKRP+KA+v8SHWEWoT/TEL2RcG+/Zz0w5iTLdUjB
	sIET/Cn0EhFqKRKYalkTRFaWEJ+/wFfdFWrL2qrsH+W1W2qoJN7KqfBAqlat24pxioZ4=
X-Received: by 2002:a05:600c:8b23:b0:459:d5d1:d602 with SMTP id 5b1f17b1804b1-45b8553f3ffmr57688475e9.3.1756734868732;
        Mon, 01 Sep 2025 06:54:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHApjNVFtZLYlxrGhbhPyzStDf2OCbwaNXEbdwjI5RqViWE8PiPULdnUBK5NJLWAEltUwK4fQ==
X-Received: by 2002:a05:600c:8b23:b0:459:d5d1:d602 with SMTP id 5b1f17b1804b1-45b8553f3ffmr57688155e9.3.1756734868174;
        Mon, 01 Sep 2025 06:54:28 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf275d2717sm15536277f8f.15.2025.09.01.06.54.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 06:54:27 -0700 (PDT)
Message-ID: <ce720df8-cdf2-492a-9eeb-e7b643bffa91@redhat.com>
Date: Mon, 1 Sep 2025 15:54:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/12] mm, s390: constify mapping related test
 functions for improved const-correctness
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
 linux@armlinux.org.uk, James.Bottomley@HansenPartnership.com, deller@gmx.de,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
 rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
 broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
 mpe@ellerman.id.au, nysal@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-7-max.kellermann@ionos.com>
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
In-Reply-To: <20250901123028.3383461-7-max.kellermann@ionos.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WP7U4nFx8_6MJ252e88GhvBhneIKorgqpsqZ57nTKRg_1756734869
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xm3jq9cj7o4zkbh585oa3ssxfs3szcyh
X-Rspam-User: 
X-Rspamd-Queue-Id: 93827100015
X-Rspamd-Server: rspam05
X-HE-Tag: 1756734873-670231
X-HE-Meta: U2FsdGVkX198FPACQqJF79DhMNnoBi59XKhIf/BBR9T3qbBi3SaFgIKEun5qKn11pEyI4IAq739YK8//Q9oWa3yzMcQirPTIVOoKO7eBqPJH3H/FH33Cji5pnTOXuDzLfpzirS1DCM3JupFcGvEWaUCe+v8L+ZIeMPdjRZyYtAKTD3kr0+jC2GVJ9j8Bual+4H+8IUWKD6umcSfPmAVUpVzM//lUhYKYPVqwWfgVSdcEALftvWZgXui9jl3sIvKrje3x32hKJfTwJaGxbIXEPragG6YH2rcmtULuwx4G6OSwzIovfBNpKwW/YyJZxD7nrjuHJyOtSJJ03wfuhHDusC9KbcG4oe9jHYiVlmhMniD53Su3Q4iwITEOpTZu/iJc7H8A2oY9MfpZdyEXNM60Z+K1iWPE+ibNhsLz8z34mBHv71wUGfUgPVtPhAwcr6DipI0Ce9qfC//7en+J+Frm7tBD0yLWqXjqj5bGONXYs3v9+zq51HlNtA10EvVIY7vdBsWC1xrT/F1z3PmT4H8Mm99W0wPuPEQ9us52wu2Uf/Otzt3pRgxJxlDA5VEvOfW1Oy95g1n1AiknWM07V8YbxgVGqnTU6T7USkj1mA7CXZHuJTS6xqjJAHMeSvMMXtW5WI7dh9qDzQ13CO+Ts4fF2NWghzBi89+gnJgjfJmNedfinq+V9JKh2U9fVVAOhtAS6lIMG2J84a28rvvEDK5l5EKbV2zBYE9410X+Z3rxBWrmTROYVnJ2en6ZEF9W4pFcgIOnUUXx5C+69z+npZRFaQN7RaELzLd5L91TWKFxN6mkuLAeSnNg1/YmWF1W0COz9fcqKuZumaXhxTLzAEU2Qb2+juBWtoQXZLMcHLExhqthc+QExXMes6yg/NrBZebHKccClnPNIiglRvDIOJUC3WD/J2rBfDPUhON9HXEddIQdjuhZaegNewO/qOl30zQLFMP6vqAoIabVq+Lbj/d
 Ih5IjlJD
 h60tN+bn6Vy6RBbWemGd/HWxyrT4+O2a1xlzULLCPNymD1RcyLBCAh7pbgrfCn/3ItuUdjoaC1OgkZFB6Cias/0HbyO7PZwqrLh5t//BkOpgD1ZlWIKcBxwS2gX64aZSNs2W4ifowmrtA/nn7hPX+DvCqr5g6k+gmppdQlQ8JpcJmne3oNZl0ySmoLkudOtwd77xjjZ3JZilLGSsDyruUZD7Yuiq+/s0fXhTb6M+X5mhKiYAD/oLKUbkpS/ySvhkUfmkJp1e6SlhEfCRxt3+7mblK8wSF91OZcXnuWbVJdsq4dqlUGl9Amh+ZIBve4kh2rgWN9GdbwuUEsIJM9w57UPUdy7SIvrNE8aoQ9cHJ/wsEQeVMcpV6FaFrPgav3EBoNg9XzL85HdWTU9TRYQ3K2LXt0cn2IXBY5Q2NYYd/WSykKAj5/Vx7Mv1ACfpYhLXYgNGrF9FqTUoFMEmhsHOo5GXN+Ukshs5XoOkK3byWrZrPWWSuGESel2hpOJgC1BOg0ku4fq9Xi1aJEolDBMppICDZDjQBGPpRCmJV7kKS4SEcT+CqMgJVaYk9h+kUCTvRkwkcXMJkm53X30HGeVBaVq3KHNwdUFCgX6I4Voxpp1bs6FjfRfO+mz5OW8ytZ23LTsXvrY0CesbZyUbRs/uxMXHxNE6C58WwSmpeRM5h+uENDN0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 14:30, Max Kellermann wrote:
> We select certain test functions which either invoke each other,
> functions that are already const-ified, or no further functions.
> 
> It is therefore relatively trivial to const-ify them, which
> provides a basis for further const-ification further up the call
> stack.
> 
> (Even though seemingly unrelated, this also constifies the pointer
> parameter of mmap_is_legacy() in arch/s390/mm/mmap.c because a copy of
> the function exists in mm/util.c.)
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

Also here, some getters hiding.

> ---
>   arch/s390/mm/mmap.c     |  2 +-
>   include/linux/mm.h      |  6 +++---
>   include/linux/pagemap.h |  2 +-
>   mm/util.c               | 11 ++++++-----
>   4 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
> index 547104ccc22a..c0f619fb9ab3 100644
> --- a/arch/s390/mm/mmap.c
> +++ b/arch/s390/mm/mmap.c
> @@ -27,7 +27,7 @@ static unsigned long stack_maxrandom_size(void)
>   	return STACK_RND_MASK << PAGE_SHIFT;
>   }
>   
> -static inline int mmap_is_legacy(struct rlimit *rlim_stack)
> +static inline int mmap_is_legacy(const struct rlimit *const rlim_stack)
>   {
>   	if (current->personality & ADDR_COMPAT_LAYOUT)
>   		return 1;
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index f70c6b4d5f80..23864c3519d6 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -986,7 +986,7 @@ static inline bool vma_is_shmem(const struct vm_area_struct *vma) { return false
>   static inline bool vma_is_anon_shmem(const struct vm_area_struct *vma) { return false; }
>   #endif
>   
> -int vma_is_stack_for_current(struct vm_area_struct *vma);
> +int vma_is_stack_for_current(const struct vm_area_struct *vma);

Should this also be *const ?

>   
>   /* flush_tlb_range() takes a vma, not a mm, and can care about flags */
>   #define TLB_FLUSH_VMA(mm,flags) { .vm_mm = (mm), .vm_flags = (flags) }
> @@ -2585,7 +2585,7 @@ void folio_add_pin(struct folio *folio);
>   
>   int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc);
>   int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
> -			struct task_struct *task, bool bypass_rlim);
> +			const struct task_struct *task, bool bypass_rlim);
>   


Dito.

>   struct kvec;
>   struct page *get_dump_page(unsigned long addr, int *locked);
> @@ -3348,7 +3348,7 @@ void anon_vma_interval_tree_verify(struct anon_vma_chain *node);
>   	     avc; avc = anon_vma_interval_tree_iter_next(avc, start, last))
>   
>   /* mmap.c */
> -extern int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin);
> +extern int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin);
>   extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
>   extern void exit_mmap(struct mm_struct *);
>   bool mmap_read_lock_maybe_expand(struct mm_struct *mm, struct vm_area_struct *vma,
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 1d35f9e1416e..968b58a97236 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -551,7 +551,7 @@ static inline void filemap_nr_thps_dec(struct address_space *mapping)
>   #endif
>   }
>   
> -struct address_space *folio_mapping(struct folio *);
> +struct address_space *folio_mapping(const struct folio *folio);

And this one?

-- 
Cheers

David / dhildenb


