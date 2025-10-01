Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A538CCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 13:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3ACC8E000B; Wed,  1 Oct 2025 09:58:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F12C88E0002; Wed,  1 Oct 2025 09:58:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E01708E000B; Wed,  1 Oct 2025 09:58:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CCD308E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:58:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7BC77BCBB8
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 13:58:26 +0000 (UTC)
X-FDA: 83949700212.02.75A8779
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id D8BB520009
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 13:58:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PlcXqkno;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759327104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EzrKUl+2NkMxRoxmdVM9hHYfWN12ztBQRe+rscPZIc8=;
	b=jVdGpeXgVa9AadnLO2GdmN0MIYOCq94qsAsukeJjPCCSXWX1WGlJBjXUToF5blnv14thkh
	OA68EkWj1cf67e6S8/JgY6mt72weBffR/VY/Ov7ZdRAgsYOOvh8zoTguc2iG1gOYrlihDe
	aM0M1tlfqhf00NL8N+NjbYO7R884tu8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759327104; a=rsa-sha256;
	cv=none;
	b=yGuznYdHosU6RMYyR+kuBAbmeAvrj7ry1vzLzmrB4ug2SrakimTNt3x0uSTkTLHU4Kc1EP
	0l3snUE7SyG+P/p92Z+CuwbACw5O/kO9roWHHR7Rh7bXKkkRcRj89f8sHIqldSBJiMkjNx
	gNE/IhPrfJWyslPeY7ih0/L8Qx9Bx1k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PlcXqkno;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759327101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EzrKUl+2NkMxRoxmdVM9hHYfWN12ztBQRe+rscPZIc8=;
	b=PlcXqknojULBJ9ycU4OAXDvzlrb5dmtp9CtdNLrlk0RT5Hr2v1fqDmwr9+W8g2Ygk1sZtk
	An5FJN3qL6RgGpsmFIXtEpMT8aiZ8INmqUvG+tExXWgHHVFgjfYUWEj1LAwrUEgOWU9KQw
	Au2qoBHsMZC/tWjsF+LW0yscpTJDZEo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-Jei9eyODOT-I7OWNfualvg-1; Wed, 01 Oct 2025 09:58:19 -0400
X-MC-Unique: Jei9eyODOT-I7OWNfualvg-1
X-Mimecast-MFC-AGG-ID: Jei9eyODOT-I7OWNfualvg_1759327098
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3efe4fcc9ccso4399111f8f.3
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 06:58:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759327098; x=1759931898;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EzrKUl+2NkMxRoxmdVM9hHYfWN12ztBQRe+rscPZIc8=;
        b=vGjYxtVhdIN8Rz2Eh3D4BvjFkH4ga5ahcurAE/ibgLdoYfPlKu+kvLZa7RNYCowqLd
         34r7hW1nKzHyiI/Rriz4P3PShSAjb7f3blULoQFCeL5T7WyLfWBLyXCODy02XZ/LZ7DN
         Chm2y1mm7lHyGCNitckrcmHhh9s/lgeolCKwywzJGyQ1KGKIMMmIpOoJkRElpobUAexJ
         1R4aeFwjtuuzueQE3Pq9M61WCji/kxa+BiELdaDHiEwq0ka8oQHkGNaTj7HKS24PeTms
         3YrZIHHsqxWiMnWfVZEKbWNGbukAX3deCI0alELs9mJFsAxbBwe2pNcy8L9Hq1Jw74Nh
         SEtg==
X-Gm-Message-State: AOJu0YxgwiFHwHRqxqpuIqOs8OYBBmuXtsGpmyhmC6qpShzKkZ0WTMyS
	XZd1oJPkpYfITe7HhgrJnoqNAdLUrLkqhyTd83oFCnWFhnj+/cn4TLWzXI9fmFEYfOK0bguyRNV
	oFzCBaZNRgwOaP0tg4UGhdueWQzOVxqjfD/Q/Q3ZxbHEXYZT3E+Tv
X-Gm-Gg: ASbGncsFSGlKKNNIEZYpBE0HKMis3caRYUmu4YgSrqFyIEULkHld3LIMX2jaZcXRSsf
	h4spbggZ1m/OApzyth7V/cX51Xg6VIYaF8Fyp1kf5QcNLzatesSqRxszii0x+0sQkyx435kz8kc
	+uxSgkCtzuexwN++ioFFKd1/pTz67cWldgMiEuzoEN4tLFwqm7bcFWpGS+jV9qdcZwd303jy9ZM
	O0eEotVbNjdAWta9aaL7pCyVJ+uYMqbJEuQKY1JRw44w0jzXU35lA9+5MxENGNxUKLx2BvmqvGv
	OoylkQ7ual6wsrpYoJYuU6Rt7RGrpFBU391uYOuyQV70KEC8cdBf00fyAZViTXX09UU3V9JSszh
	5gsJhc8Xw
X-Received: by 2002:a05:600c:1f8d:b0:46e:3d17:b614 with SMTP id 5b1f17b1804b1-46e676c7450mr10824485e9.6.1759327097800;
        Wed, 01 Oct 2025 06:58:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbmlLetAaGNeCKOH3qjvN1GbXYlFkysa1ZIB56tW7zS7mcnqFyRmh57QFuiH942kvyNYzrGA==
X-Received: by 2002:a05:600c:1f8d:b0:46e:3d17:b614 with SMTP id 5b1f17b1804b1-46e676c7450mr10824145e9.6.1759327097338;
        Wed, 01 Oct 2025 06:58:17 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e619b8507sm41126065e9.3.2025.10.01.06.58.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 06:58:16 -0700 (PDT)
Message-ID: <43d78ba7-8829-4a19-bdf3-d192a62cdac4@redhat.com>
Date: Wed, 1 Oct 2025 15:58:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Axel Rasmussen <axelrasmussen@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 James Houghton <jthoughton@google.com>, Nikita Kalyazin
 <kalyazin@amazon.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ujwal Kundur <ujwal.kundur@gmail.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrea Arcangeli <aarcange@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
 Suren Baghdasaryan <surenb@google.com>
References: <20250926211650.525109-1-peterx@redhat.com>
 <20250926211650.525109-2-peterx@redhat.com>
 <f1da3505-f17f-4829-80c1-696b1d99057d@redhat.com> <aNwmE11LirPtEuGW@x1.local>
 <f409cbe7-7865-45ab-af9a-6d5108bc5ad4@redhat.com> <aNw_GrZsql_M04T0@x1.local>
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
In-Reply-To: <aNw_GrZsql_M04T0@x1.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iLX6DawozkQMrjUZGktT8tol3NhPuPKyQchFXEzRV58_1759327098
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 59doigjji3n7me13tqrbmrwway7fc5u5
X-Rspamd-Queue-Id: D8BB520009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759327103-567001
X-HE-Meta: U2FsdGVkX1/n7oC49tekXVy4JIR4Zwgx7rT1zTsfhyuXuiIQrFwsZNk+sQ143cI13M+1aGU1bowOkV1s9sRvC8ar8M5vH6L6+7MCr9pVP2EG9qNe8bht+5OdPWdhvXHQAR7wrdh7GccZ5Q7hM6/H5/rXXrnI4OP+GMT66L9fgx+5OhP9+9gz7Z4kZyCdvXW/z27xW8NYWkxRbmLomLwuxHoKSZhU+XlAM+bVu8c9q0zQmetBGxhNoLXhae1yDZXuIKYRHIUDuoUkytjxXZUz8FfR3TqKQeW2tB2jtKSThoVUeGmDwSdKpUns0/UGXnrSUgo/G3b41Dtp3IqQV3oJoz5e3T3XXxbUC6CM/93Jmv6crFYuPTABz63OWtAAXSBKlgGX4mqUnjzWpuFDBJI9/wKjuXEC4SuY4aMAOvYrolm9qs8yasoVhwhvAdPfFg6dCxGfjZ+JAOiYGlUzTxjbKCIiX2fPgJMuAiNcaG+4gT7S/7iSSaDb2m7TGz/X/JoHlpV6DjVBUaZ4dhOxem8AFpxUZiWPfHp9H4lwiKRX3dd7Sn9S9VB7cJn0py2NFzSBwfxpsvNAxewR51mR+ASfZMYX66b33xUD65+HbxwpL4uvK6oFcNEbNx0ptw14J/LAwz4FtIifa0Lm2RaJZa4DZwr6BX1n4mdcCNaPw0oAeaVP6kr/xI2sP9DSvNhX5JBQ8yxBaDm/a7clIXb14IZL8a+jWj67qAouMPPdNCqKSCtr0e8CdAa8coPAJNvAeZbQMkjo6VFEc5mDW1vFCfjweOu8bdcjzOqf2v+DRqBd8v8eiQolchC0m3n/NsPw7xZBPV1YoT0ceaNtpvcW2X0DfmVxBJZxKXDyKBgSkagRPcfou61d52cyEblaQFQelGL4eR2WmcGtSm+jiU1j7q5xePq+7SeskfKzNKowUdP7mA//TQT6SYHA9mUVBzbAYBSEPVikGWYvdER5NsWrgBh
 0e36iY2E
 40xm/M6Y+uMa+uQ79DrSm8EpfigAjcGy5YquIK7bmet05jJsQTvo9eYOlpuyOni4mgGwaqhqwWSH9jt+7LMbzsbiOf8fCubRPshm/yfakeK6yZ0KpazKeqs3IJ5c2ZT/Jeqnfxc/L+9dsUeDCsOlDK/X78lW7Xmp13yrjxlxtH04E+rCtRqwpf0mwpM/iphGY2v68H93vzBEsc20yFidmKpZAGw8ZzvT1NEY2xOOpxxXjXH70S5YkpzoDfCCE6w+/Pi41Bc2JlzmIr712OBZLl4zu89cMBsA7JVRWq52s5QUYWOwLvZH4BGFNK23n+CfUVwUF6VkAjeIpSlMoCxP8qAtsci8IZhvJluqbFgw+qjbjcWKyNNeqeI7f6zbH9Ng2latPD8tQuTwJFqo47hBX5+aybrfQGzm8JGvsO4/0PDPNae6VYdfirk1cM9SxgWyyMSWo1hhpadqJF0Z/1jEAnhQF5v7KuZ54GDbIuY8GTMQwL/qV2YHJ5sCcoEQEin6l0AlE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>> I briefly wondered whether we could use actual UFFD_FEATURE_* here, but they
>>>> are rather unsuited for this case here (e.g., different feature flags for
>>>> hugetlb support/shmem support etc).
>>>>
>>>> But reading "uffd_ioctls" below, can't we derive the suitable vma flags from
>>>> the supported ioctls?
>>>>
>>>> _UFFDIO_COPY | _UFDIO_ZEROPAGE -> VM_UFFD_MISSING
>>>> _UFFDIO_WRITEPROTECT -> VM_UFFD_WP
>>>> _UFFDIO_CONTINUE -> VM_UFFD_MINOR
>>>
>>> Yes we can deduce that, but it'll be unclear then when one stares at a
>>> bunch of ioctls and cannot easily digest the modes the memory type
>>> supports.  Here, the modes should be the most straightforward way to
>>> describe the capability of a memory type.
>>
>> I rather dislike the current split approach between vm-flags and ioctls.
>>
>> I briefly thought about abstracting it for internal purposes further and
>> just have some internal backend ("memory type") flags.
>>
>> UFFD_BACKEND_FEAT_MISSING -> _UFFDIO_COPY and VM_UFFD_MISSING
>> UFFD_BACKEND_FEAT_ZEROPAGE -> _UFDIO_ZEROPAGE
>> UFFD_BACKEND_FEAT_WP -> _UFFDIO_WRITEPROTECT and VM_UFFD_WP
>> UFFD_BACKEND_FEAT_MINOR -> _UFFDIO_CONTINUE and VM_UFFD_MINOR
>> UFFD_BACKEND_FEAT_POISON -> _UFFDIO_POISON
> 
> This layer of mapping can be helpful to some, but maybe confusing to
> others.. who is familiar with existing userfaultfd definitions.
> 

Just wondering, is this confusing to you, and if so, which part?

To me it makes perfect sense and cleans up this API and not have to sets 
of flags that are somehow interlinked.

>>>
>>> If hugetlbfs supported ZEROPAGE, then we can deduce the ioctls the other
>>> way round, and we can drop the uffd_ioctls.  However we need the ioctls now
>>> for hugetlbfs to make everything generic.
>>
>> POISON is not a VM_ flag, so that wouldn't work completely, right?
> 
> Logically speaking, POISON should be meaningful if MISSING|MINOR is
> supported.  However, in reality, POISON should always be supported across
> all types..

Do you know what the plans are with guest_memfd?

> 
>>
>> As a side note, hugetlbfs support for ZEROPAGE should be fairly easy:
>> similar to shmem support, simply allocate a zeroed hugetlb folio.
> 
> IMHO it'll be good if we do not introduce ZEROPAGE only because we want to
> remove some flags.. We could be introducing dead codes that nobody uses.
> 
> I think it'll be good if we put that as a separate discussion, and define
> the vm_uffd_ops based on the current situation.

Right. I'd vote for an abstraction in the lines of what I proposed 
above. Doesn't have to be the terminology I used above, but some simple 
single set of flag that we can map to the underlying details.

But again, hoping to hear other opinions on this topic.

-- 
Cheers

David / dhildenb


