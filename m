Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9AC9CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41C3E6B000C; Mon,  1 Sep 2025 04:35:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A61E6B000E; Mon,  1 Sep 2025 04:35:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26E326B0010; Mon,  1 Sep 2025 04:35:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DEB76B000C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:35:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C4A7A1DE986
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:35:28 +0000 (UTC)
X-FDA: 83840022336.24.82518A7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6DAA21C0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:35:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gA5E2LCD;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756715726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Rp/f+W0ugUReLNu6gdfFdcYbWimciufzeaE9rDyHW8=;
	b=d0LKAt30LWu5Zi+9PuzTFrFvt2geAEcZCxwLcvQvR8VRkwtBeoxb8z1EJ1Ebt3j8T2dwyy
	wfkkocoGpFR7shZY8Iw5dwFFXJhH+wWY2Zx1nvy0GAndYqj/nNquLxFxVZH3mkJ7Z9Hurq
	3AwYFWWDNgzm93v9u07kSEeVSnaqDKY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gA5E2LCD;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756715726; a=rsa-sha256;
	cv=none;
	b=AdsZWL149S9PzRyVkdp+n2BpbiG4wBxDeQ8kNTws8bTybQBfKvpTUGuknZ01i/CvGCgc45
	Z9x0qNiMfLoQaQo8/wMeY3JNDQcTf/dribSdBMRnsNuRaUjMkqfIVl4FzCFCBDwQHa/XZ8
	pm7sdy0HWpcdkV2F2fqe+vYQg+/Cd/A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756715725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0Rp/f+W0ugUReLNu6gdfFdcYbWimciufzeaE9rDyHW8=;
	b=gA5E2LCDu6LC0ZIdrE7KGVsZGouVwZtQO72OaLuow+ebkjWrsWNIXD9gLoKNeZVrskwuRU
	N93Qpmlyj5pA2ZgOlS2PjJOWRi7GS4dD+wlGk+iH9wUvKYQ/qasDkcVTdIqUh2yrmxVEkk
	AI5q9dzR5+E6KgKWiMum+mOvhSXFI0g=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-224-TtdiitEwMiC59tgO76N-yw-1; Mon, 01 Sep 2025 04:35:24 -0400
X-MC-Unique: TtdiitEwMiC59tgO76N-yw-1
X-Mimecast-MFC-AGG-ID: TtdiitEwMiC59tgO76N-yw_1756715724
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b7d497abbso24269505e9.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 01:35:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756715723; x=1757320523;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Rp/f+W0ugUReLNu6gdfFdcYbWimciufzeaE9rDyHW8=;
        b=C5EVAfqG6LVmaqNJOC5YYwCjUINLaMOQig4WupBW/oy1xl1SCpa8xLodIeTMjmTlGM
         GTLK5i03O7QakdATAsIdbCku63QoCUuLbkFGK9Fm3CgLEPyco7UTSZjXXq26hkOzi0Ss
         fLPJSCjXYc0HcIcmL0nNsD8VNaXqIS0vBvSbeGFkgJOf+jqdkBhfh4vDRn/4D48F9fB7
         LAOCbbvXZuKWlAeLxc1Oz3LqHfKa7bPYBetEOnlcZpvUfB46npOt4HatvZtwnHKVdOIt
         Tre5KcIXXOaihZbzIdhYPC0fmDGlC7kvsh2t+zHpqiIyxli30hjt1oAYgXyRm8BOZFh2
         2mYg==
X-Forwarded-Encrypted: i=1; AJvYcCW5AhlxuxR5rE7Xqc6S8lTmsgMB2Vq7fMrE1rb+TKg3BPFvjbvNPx0HxtDhSs65wudU55p/nT/P2w==@kvack.org
X-Gm-Message-State: AOJu0YxLvyJKnCwwPraItINLnY5GN4WKHMT45IlfFbhMCfIZIS5dbDe/
	IFE7hkH3DaeqxChsTd2SfjCznygiQ8WZmkdT8mOqV6uD0Juu7tOTmWg7gaMCeigMKQhHBKhI8/5
	4IetKUT0YyrLvQ1BBU7xGUkVfYYkIr5lP8cyVIDt+XYhmazhPEtOH
X-Gm-Gg: ASbGnctaBtRi0jyxdP+VfT7Fv1JF9MZKlb8T4uXR8z7soBeuTkma5COky1CawaNkrfa
	0v7wUHrm7LwAwd2HUza/DOWTxs1E0mns8PF6+eoStDrR/dFsmWcsQ4rIsJ0DtvghXNQH9wJkEoL
	dREeX9YME9NBM9TVihHC88JDsh/QEcyVE26BUY0MtSnH+i5YWRXdKdpfdHRmHY5DKSHwLuiNNJI
	zO/AcAEeFXinw110ougQYMJf6bqFuZWr9gq8M1X3g3fOGBOCuE+i2+h1p9jL0EqsJ7OiZif1JKP
	HiO41nrVdOZqadU2uOmpAscFrZTHRB5OKqYo2QrRd5b91Be55xmwmrxbc+sbnVeeGhAH8SL9ciS
	kmwvwvAAX/04JQ4cfTv6dz2SvX1yJfv5LHCl9oubfnxFw8ei9D2sAzoZh0XeECOL2MN8=
X-Received: by 2002:a05:600c:35ca:b0:45b:8939:8b19 with SMTP id 5b1f17b1804b1-45b89398d7amr40695425e9.8.1756715723511;
        Mon, 01 Sep 2025 01:35:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFddP6f93Y6m5iRNV/zYvBCXZhasJOXAiWFqnS7FH0aiguBZ9WEirTfxYpQJ343zE7hjq4YFA==
X-Received: by 2002:a05:600c:35ca:b0:45b:8939:8b19 with SMTP id 5b1f17b1804b1-45b89398d7amr40695215e9.8.1756715723093;
        Mon, 01 Sep 2025 01:35:23 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6db6sm240749605e9.2.2025.09.01.01.35.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 01:35:22 -0700 (PDT)
Message-ID: <244b73d5-39dc-4bcc-a69c-8ae3010b40d9@redhat.com>
Date: Mon, 1 Sep 2025 10:35:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/12] mm/shmem: add `const` to lots of pointer
 parameters
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
 <20250831093918.2815332-2-max.kellermann@ionos.com>
 <day257vhz3o7hepucfz5itjvdtp2k36hkqdg7hckqleb4jxyku@rs4rs3zhl4hn>
 <CAKPOu+-ZjNr9hEir8H=C5C9ZwbS7ynY4PrJuvnxa-V425A+U3Q@mail.gmail.com>
 <e3ec5583-adf0-44c3-99c9-5a388c43fb7d@redhat.com>
 <CAKPOu+9CiT-5P--6TZcyq=jHLDhCa8LDh1AYjKr69+0shO8UrQ@mail.gmail.com>
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
In-Reply-To: <CAKPOu+9CiT-5P--6TZcyq=jHLDhCa8LDh1AYjKr69+0shO8UrQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oIurVDTzZhyUipDLXYchDzch1_HmtZl3omPnUOwgk9c_1756715724
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8n5sqnjpqbymabpmaugtswp7tjhpy7bj
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DAA21C0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1756715726-138444
X-HE-Meta: U2FsdGVkX19CqmuD9UBngVmHfqr3KFSh4u+W4PDBD1Fx5VWpP3lvCxSkKXz0xMe314QLLQIikXmJSJg0P3iNG6l6+eHkIhvlBbXfglRyUb0uazsG+/iYmA8WRCC/21XRkOy9i1SgOEjrEHw6rj7L7R2LRhWRU3p8wDnE2YWeQz3jkv7ulXOdBuY9YDxOPMzcZ1mxoosxWdrRIBbyM4Se/SKy+XrwPTkS1qaMjrxHrp2XzYFtzy+Hzl51otj+FcnzpyvF55zGItz53OXWWDBKJczpAAvn14TIv3NDPJRBFZ9cT476tz/kn1wNJ+kfXMVzjYq/J8APNfrAGpFGehYJxGUmgfdXANmRxzmphOfWaKeas3dG0QWs+xZ4rZFTgYs4yxj1hWngU/bz0HCME/WRIEavpr0lbrIv/1o41IrHxy82O2iw+79ltKF4NV9YsxfCTwU/tV0B/yuxSNRJdtopAPcEKYxlLY6epmvjdq7S7L/4kbV7uI8YfAjRxK67gqOavyiL56WwnhWd8gBNOOKymxuSKvqLW7DUmu2ey9xyQmOYU5mGYNyIBa+Vydj5/JU1Vhdu5pNYv0lIHja/gEEg0zNG0+tIuYKcL+z+VgPaxS1YMKOhGh4RoOwfLvTNRA/mXhfxkn1gxlNxm/a6qodf1vnHaVQkXjLyinxHLlxvlGYd9SYkDJEDN2NshKzYIzj8ReeXEUUV0SJ/ScF05YitYPmPrSKM+Os7oIzA5Axq/9hcqrCGktUNbBcoKm4ni1b9A3P67Kny9Q8Ef96juX3bDuPlz4e1o0XbzIiYjAkWPEhOzdf1CLFLPlDf054lkIqQAfRqq0K4DMKJX1Ar8rUx3a5kF+DHsS3B7Y4Abyeke/ymLbXY7klppoGuXWCsWu283iEyc1cdcxhfvmMQKPnaJ6ZL5lUjks1/4VYf/8Ex1Q6OJw1Hhepdyoe95LtYBfetfpiIqaTbzJIn1bYAXEv
 Rji66R/0
 yzUyCgxfmthHsYt5d7an2e1Kr5y8SVViskz6yAi6GAab6Y4PJs4Sbq1sfY0jNO5X15V3D1Y1SOr3PmLinNoaHOVfVMxfFHBcUKd16cmGU5ogsFrTwrOz5CslqjSn+aAZsmFRAb7Ns4bpptCgenrPcRY/p/7k9m6udUB8q+T+3dbLiw5Hhrf9YDDvGry8bE4LAeFnNJFYNQyw8aloVxOnXadSFM2pIVn6H9exUCqVhEpx8HE1uTISLbYV8VhJ/k/bacourWdrt8I89aIkVThp0sKJmvi2LmxW2XJNfdtG6mKPxtHK+OsR6/U/lSRCmjpsLeNFjdEIt7kojto0tbvcPaIPntfQ4tZVRncWI34OYWGzbUwVvQSDFZGjQplCCzq5PfG0Mftc4KMb2W3y8RnnOLnctVB+NRCojWVzx0zMEJmwPJ77slIxzwN4BawtdbKCLlw0sXIagrGPM7tWTjcpc3mNjG6OaQff6eK+ypomyV+Yy0MnccUSBI79gw+2RBAGFmKi6lJYjXGaup4wznoNeh+dVmI2lbzEvilEUFIAAb9cFpb3gtxgNdJqnDf2TSAWwtEv8DmrzYk1JizAvs4g7/pYrnZyHWrXMKkqh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 10:26, Max Kellermann wrote:
> On Mon, Sep 1, 2025 at 10:20 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 01.09.25 10:05, Max Kellermann wrote:
>>> On Mon, Sep 1, 2025 at 9:33 AM Kiryl Shutsemau <kirill@shutemov.name> wrote:
>>>>
>>>> On Sun, Aug 31, 2025 at 11:39:07AM +0200, Max Kellermann wrote:
>>>>> For improved const-correctness.
>>>>
>>>> It is not a proper commit message.
>>>
>>> I believe it is proper for something as trivial as this. I think
>>> adding more text would just be noise, only wasting the time of people
>>> reading it. But that is a matter of perspective: I expect every
>>> competent C developer to know the concept of const-correctness.
>>>
>>> Do you believe the commit message of 29cfe7556bfd ("mm: constify more
>>> page/folio tests") is "proper"?
>>>
>>
>> "Constify shmem related test functions for improved const-correctness."
> 
> Mentioning "shmem" adds no information because that is already
> mentioned in the subject. "Constify" is just as redundant, it's the
> same as "adding const".
> 
> The only new piece of information here is "test". If you want, I can
> change the subject to "mm/shmem: add `const` to pointer parameters of
> test functions" and leave the body. Would that make the commit message
> "proper", or do you insist on having redundant information in the
> body?

We usually write complete sentences, and there is nothing wrong with 
repeating what the subject says.

All the time it takes you to argue here would be better used improving 
your patch descriptions.

-- 
Cheers

David / dhildenb


