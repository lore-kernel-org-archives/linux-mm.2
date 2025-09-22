Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65166CAC5AC
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 08:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACBE78E000A; Mon, 22 Sep 2025 04:16:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA5898E0001; Mon, 22 Sep 2025 04:16:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 992608E000A; Mon, 22 Sep 2025 04:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 860668E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 04:16:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C52D11A603
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:16:57 +0000 (UTC)
X-FDA: 83916180474.12.F3BF643
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id C07BEA0004
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:16:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z+lPjTTo;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758529014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dvgvNYrXIKV1W2tssfM9udlEU1wiyu3lFYf24ezjTww=;
	b=CYDLSaJpf9czT6MUDwYYtiqBAkZAgScmYabpQqjNXa/OJXoip5wZf9bJEZ8jeJRSNfsTO1
	8ogrX6TIPXz0wXS245yPsU/NK0PHRGM9Xue5WtueqX026Yrsp8WWKYiXQSq4XzXLmD0TkN
	YLFo0ZpMgO2+odZNhan6XuXnSzZVX2c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z+lPjTTo;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758529014; a=rsa-sha256;
	cv=none;
	b=CPdFRi5s4brv7s4RdRIzqBYToFfBe60v3XFhjapEyV5dot9n/bhPEuhT74Y2NMktwY9A+a
	gGXY8oqHTkowY82nKdN1Y0nwDny/NTdM4lPFn1sZlVPd0pqKMkUD4x44xlNqM9BcCnICXN
	u/q926Q3DM7iw1GjaUSO5RW0QIEtHdI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758529014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dvgvNYrXIKV1W2tssfM9udlEU1wiyu3lFYf24ezjTww=;
	b=Z+lPjTToS/yh2mHL7wHw4O9O1FUFk890fywJcehinfgtAJb+iNtHI3BfiKGtzhQUvjPnFX
	1W3J8WufBliVX3H3Eip2uVboVCIaLDndgoe0KHUgfzhmysjHUnvO4D4QC8mdNSloEdb4TY
	dfXx7MDoFfzMvtMtV6dXbN9Wi98vNWU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-YAr5EWnNNgi1fqAy8vOWEA-1; Mon, 22 Sep 2025 04:16:52 -0400
X-MC-Unique: YAr5EWnNNgi1fqAy8vOWEA-1
X-Mimecast-MFC-AGG-ID: YAr5EWnNNgi1fqAy8vOWEA_1758529011
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45f28552927so32047585e9.2
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 01:16:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758529011; x=1759133811;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dvgvNYrXIKV1W2tssfM9udlEU1wiyu3lFYf24ezjTww=;
        b=oZcA2uaZjwDLUI5r8iUxFTLUH4aUMYNCWSrXgepSZBMOh0uLUBYrfA+LM8NnHVnex/
         fl/vIpu0XTHIOUPcoBnjr7lkSXg6Q1kjuVksHvTsIF5pSPfJp2D4o7emOA73Y4d0AEtL
         Hs4XhfQ4NnJeDz7ff+Qv06aJ81s2vwKInnbaj8nknEEqoYq1PKeb9u5wz3+E5FZF96we
         kM4LuwlCkmJEZT31sB3s3HYU/o2WyyZgEJ1cLhBsY2dyC61tcD0Z/th5yx6gwfiC5GNM
         B2LnFxYYgcJ4VHm/AtAYPb48LzwR3jd+5xbql5ru+tRpN9CN7m+arb5q8IWf5OnPZOFT
         QueQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9jftCQXafHwXUi7vBI4vZgPmhohi+pHOvATEz0VTWxTVJ5U2KM4hS0P3dLS4CEDCCvCOlIF1zMw==@kvack.org
X-Gm-Message-State: AOJu0YzmrPGByqjAANlydT3+jpIXIy3NzTjjcx3kHUC6MfbiNy4ONh//
	PumXnhjU2d7mRL2KnkewNf+XgWI175RKugUGrYIYoIMypvjnGxIVkOg4Z5fplD8vEJoLUqPcekI
	Qw484UYK4AP2wLQWaF8e3QU8lq7mUPAz6NXbVlEHudasNYe1qkrG8
X-Gm-Gg: ASbGncvue3JPZhL4Cnr1VuwTDWCbby3iU85eKlup8yr+uYhIyxk/PrOKAaQ4mTe1uhT
	QAw2pvWADJXwCCg7mXjBk8khLxwxugLRgd1zyd+AG2w0BaFL5qkFup18zxXxrRxs50yUk8xJ+3J
	aO+X+Ao0L2yRPJ3vGc6Nn8VwblSgejObWV8OBFib8cTqDbHwrgb2avSOwbtE60YM/LQfHI3kkz3
	sNsqkC4QMRcyiGOaDB8d8IJYER5JI3oyoXHCQhlzTfHs2Tu4Pbv08EpIrrH9/a0ujUi805dhWlp
	t8QqD9lgpR3cwz8nG8rT48TLqH8Q5Q8BzImfIgt1CpavX0ndvE2OJdWDrOMrVfMJ3ii89WYatw0
	l+ucRQvZiBfNeyZJTnQY3o3eTgn/P50YExYoeQF8pt7U3DJ74iU9RfGgpyqJCuz8=
X-Received: by 2002:a05:600c:46c9:b0:45d:d68c:2a36 with SMTP id 5b1f17b1804b1-467f0b4f285mr85588045e9.27.1758529011109;
        Mon, 22 Sep 2025 01:16:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1cdOmkPLjBkNAcAZmTg8sY7rqKnBjZctblpWpPX1Re6vRdSneBPKmE7W2qqSgKnGsdkL0+w==
X-Received: by 2002:a05:600c:46c9:b0:45d:d68c:2a36 with SMTP id 5b1f17b1804b1-467f0b4f285mr85587815e9.27.1758529010657;
        Mon, 22 Sep 2025 01:16:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2a:e200:f98f:8d71:83f:f88? (p200300d82f2ae200f98f8d71083f0f88.dip0.t-ipconnect.de. [2003:d8:2f2a:e200:f98f:8d71:83f:f88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3fee58e6e25sm2887904f8f.58.2025.09.22.01.16.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 01:16:50 -0700 (PDT)
Message-ID: <89afa6d6-0a02-4825-8923-3752397b38dc@redhat.com>
Date: Mon, 22 Sep 2025 10:16:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: use [pmd|pte]_addr for better reading
To: Wei Yang <richard.weiyang@gmail.com>, Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org
References: <20250920005416.5865-1-richard.weiyang@gmail.com>
 <4fb37530-3826-4ff5-ad7a-dc9dac4937de@arm.com>
 <20250920090228.lovkrpwj23bqdamj@master>
 <93095f34-d7ac-40c7-87c7-60d2c64d4800@arm.com>
 <20250922081226.hsglokm74lh2eng6@master>
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
In-Reply-To: <20250922081226.hsglokm74lh2eng6@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2dlr_OHHSfEU7P_4GfmuoYT559x8hVxaPrUzOloQsQc_1758529011
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1z65ys1a18fsg3fows1hx64r6w5w6tsx
X-Rspam-User: 
X-Rspamd-Queue-Id: C07BEA0004
X-Rspamd-Server: rspam04
X-HE-Tag: 1758529014-881752
X-HE-Meta: U2FsdGVkX19VQmycawUWsjTncqyZkS3j9wNtOoDeaE+DwSI2oOLYwQO7Q+vNerbCu/xsKrHgefSPTDRx2s7+b6W2HZOWjPb4elTqwmgMJcZTZsJXPkxcYfjY5skZIVVyv7LbEg7Rbkmw04t1UsJSy4EDJrdKiZq3YCmsGDQb5yB6QnfKz37kEJDi0ZoBWLmeQnJ9AMqPom3gVwrw7sqAcNm/+c9koalu9RmUzgGk1UAwQu32FJUt8rTOLrxbMHZXGo9CnRLXfn5OfyCwuoBudYT5fCWoVBniVnOX//o6nJQETNTlU8nly6tL7C6opiMzWwMmiyHpFJr4caOoXNKRVPk7pjJfaOeGY3YHkI810zwAYLHATTaLFO9fh/ZXGSEn4vj87XZGaRR6XpGx5GslL0KZ9dtSz2SbjSbYQYqCoI4awjDilA0oUyNTJGgicHGnArazF3HS2ZJa/CPlCh8oXzGq/6a20msOoJttsC4TsoI/aAlN6MPhqleJZ8elcvx+f/NVm8SbYyvN+vkni0t0SUlKEXsO7hQyG31YeI/zW77v636XdEJJ76EWz3g+CP2MuhrPgxndJXgSKrQwHbCu7q0IVf7xdmVeoLAJM+Hpa9vFp/LX56E2rCXwX7ARABaLy+FtsFZ/0OdRepj4xf1yqTv1sqWNwiGbNh9J2TcRoXqHrkhr52gqzV8ezT+JKUjJqi6M2nR8jKhAMrfILptIONiJjorHZuAc1cSxWBl//BGZlOIwfQt1slrsf4hc+q2B7oUyL2Q/0dxWfqI4gpnERxm/sZeKbY/6LVQ1IjMyv9kfwcFzfO8NXvjTgE3ipE/8tncwWML+3j2SMJaSAHgu8Kl284ZOB+FiWn968CYKezwezYfv5HNxrusdz+cJCKswOAiXbUVhzNoysgumUz2pwd2q5SYjvOaMbcGQ7DdcMMjWK8h8o8lXBgO5e6mvujJkIlMcFqOeUevb1OsVpGe
 eu3+CkRn
 ny0sVZl841uN22x5XK9nh8zcAVTZm4MyhFWH7NUrA4z4Fh4bvxgTwBJQ3t9A/IjN/FvFQMP45BcfBlHbrmSmkD287ABvs4JMxNnXEsdsHRoc38s8jhfaZB3DwdGvqPt9TiBXMBI7jrrpWPtKRdQSeTMVxV4R/KIgbDmWftHI6RnPonfDQbQ5u0Ag5bfik0ateTG34Snvx/oYyvsNrCvqAYcRYu0Jjq4nEhdImUO0iqpNqBYguBfwlB4SLjTKZMq95Gw/dpWSY/+icIrvqTTvH6HNr+QDPkGTsrNaK4oRyXZSoBgUd4/z8H+qAJ+BmAWI5tceIM7yA+b/yA2MF0rZNICFPzAskD4zXUytJQvJExCt1Ea+T1pXD+ZIizyDYgEszb5wq4sYlC4AjXIUGxR7LjPicWSeLCRMzv60fAZ1KX7Ksrwhoy4Cfj6dIIS1IlyEa4lk9JKuH/lJV6I9cWWT1WjRClSxaKOWOmSIXKyWPwDvo64cRHXLPFIcscklHOK795ImVW/l11JaRnJasGXZhhBVrO6nEGJwCwYvInydd+UW6shLoVXVYnCBk/z986OeFsq6asYIaa7ulZGFlzXoFG5z2gQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.09.25 10:12, Wei Yang wrote:
> On Sat, Sep 20, 2025 at 06:01:59PM +0530, Dev Jain wrote:
>>
>> On 20/09/25 2:32 pm, Wei Yang wrote:
>>> On Sat, Sep 20, 2025 at 10:21:56AM +0530, Dev Jain wrote:
>>>> On 20/09/25 6:24 am, Wei Yang wrote:
>>>>> When collapse a pmd, there are two address in use:
>>>>>
>>>>>      * address points to the start of pmd
>>>>>      * address points to each individual page
>>>>>
>>>>> Current naming is not easy to distinguish these two and error prone.
>>>>>
>>>>> Name the first one to pmd_addr and second one to pte_addr.
>>>>>
>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>>>> ---
>>>>>     mm/khugepaged.c | 43 ++++++++++++++++++++++---------------------
>>>>>     1 file changed, 22 insertions(+), 21 deletions(-)
>>>>>
>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>> index 4c957ce788d1..6d03072c1a92 100644
>>>>> --- a/mm/khugepaged.c
>>>>> +++ b/mm/khugepaged.c
>>>>> @@ -537,18 +537,19 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>>>>>     }
>>>>>     static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>>>> -					unsigned long address,
>>>>> +					unsigned long pmd_addr,
>>>>>     					pte_t *pte,
>>>>>     					struct collapse_control *cc,
>>>>>     					struct list_head *compound_pagelist)
>>>>>     {
>>>>>     	struct page *page = NULL;
>>>>>     	struct folio *folio = NULL;
>>>>> +	unsigned long pte_addr = pmd_addr;
>>>>>     	pte_t *_pte;
>>>>>     	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
>>>>>     	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>>>>> -	     _pte++, address += PAGE_SIZE) {
>>>>> +	     _pte++, pte_addr += PAGE_SIZE) {
>>>>>     		pte_t pteval = ptep_get(_pte);
>>>>>     		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>>>>>     			++none_or_zero;
>>>>> @@ -570,7 +571,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>>>>     			result = SCAN_PTE_UFFD_WP;
>>>>>     			goto out;
>>>>>     		}
>>>>> -		page = vm_normal_page(vma, address, pteval);
>>>>> +		page = vm_normal_page(vma, pte_addr, pteval);
>>>>>     		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
>>>>>     			result = SCAN_PAGE_NULL;
>>>>>     			goto out;
>>>>> @@ -655,8 +656,8 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>>>>     		 */
>>>>>     		if (cc->is_khugepaged &&
>>>>>     		    (pte_young(pteval) || folio_test_young(folio) ||
>>>>> -		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
>>>>> -								     address)))
>>>>> +		     folio_test_referenced(folio) ||
>>>>> +		     mmu_notifier_test_young(vma->vm_mm, pte_addr)))
>>>>>     			referenced++;
>>>>>     	}
>>>>> @@ -985,21 +986,21 @@ static int check_pmd_still_valid(struct mm_struct *mm,
>>>>>      */
>>>>>     static int __collapse_huge_page_swapin(struct mm_struct *mm,
>>>>>     				       struct vm_area_struct *vma,
>>>>> -				       unsigned long haddr, pmd_t *pmd,
>>>>> +				       unsigned long pmd_addr, pmd_t *pmd,
>>>>>     				       int referenced)
>>>> Will this be a problem when mTHP collapse is in? You may have the starting
>>>> address lying in the PTE table.
>>>>
>>>> Personally "haddr" is pretty clear to me - I read it as "huge-aligned addr".
>>>> I will vote for naming the starting addresses everywhere as "haddr", and use
>>>> addr as the loop iterator. This is a short name and haddr will imply that it
>>>> is aligned to the huge order we are collapsing for.
>>>>
>>> So your suggestion is
>>>
>>>       pmd_addr -> haddr
>>>       pte_addr -> address
>>
>> pmd_addr -> haddr
>> pte_addr -> addr
>>
> 
> Take another look into the code.
> 
> The change touch three functions:
> 
>    __collapse_huge_page_isolate()
>    __collapse_huge_page_swapin()
>    hpage_collapse_scan_pmd()
> 
> Use pmd_addr/pte_addr look reasonable for hpage_collapse_scan_pmd().
> And haddr/addr would be suitable for the other two.

haddr vs. addr is just nasty.

Can we call the aligned one "aligned_addr" or something like that?

-- 
Cheers

David / dhildenb


