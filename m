Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 005C7CA1007
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 16:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E960A8E0019; Mon,  1 Sep 2025 12:15:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E46BC8E0003; Mon,  1 Sep 2025 12:15:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35918E0019; Mon,  1 Sep 2025 12:15:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C2CED8E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:15:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CBB5160920
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:15:51 +0000 (UTC)
X-FDA: 83841182502.24.F4B3202
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id D85D840009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:15:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=frBZwBEq;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756743349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WzCHhi4hjG4XUTM3m5FXF23YIR33PFzU4tTzZn5EUNE=;
	b=RrTVvRbfa72TkCqsKgO5VlT4F1v9aWAauuZXDNPkpO52dJkmNrEoLKbCP7pQIaS+jrrsSf
	OMMhci08G5aQjUjpsBoVmHKSjskSVWjRPG7p6Td+E7Kyy95Q1W8KZ0qehR4vm675AL+VLY
	sP0TqHYwk1xFl9wPh4WAilblLs7d+wE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=frBZwBEq;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756743349; a=rsa-sha256;
	cv=none;
	b=nGN/UkEdGokuTYuYfewOBtoSUopZGYbzwvcvct9oYx/RGCw0iJv3x8ZEY2cN//jHuo/Ncb
	BKVBFg0Yz1+9GpqigmnrTnFXS4rSgjLAJ+xldMuHYBM7M2URkcpXeER+muMQbKZ8WCV2iC
	vnT4ldT7VSSHCdyuC8RfMFEpZsAWZvg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756743348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WzCHhi4hjG4XUTM3m5FXF23YIR33PFzU4tTzZn5EUNE=;
	b=frBZwBEqPWiW2EhLInHqpH2K+XqZJWvgApPZbpRUimzAoodxihT8ifOVxntBqyVRc2IqQY
	HxU5g00TARvAA7+XlTHHG4JX7oMQ6LoKP4sy29waYRf9sH41Ejrz2lt0LUyxwoZQTD2sPl
	C39H39FDd6relMLe+GD/meMzb0cBNzk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-ASKRfdCHO-WTPL5j0TCahg-1; Mon, 01 Sep 2025 12:15:45 -0400
X-MC-Unique: ASKRfdCHO-WTPL5j0TCahg-1
X-Mimecast-MFC-AGG-ID: ASKRfdCHO-WTPL5j0TCahg_1756743344
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b8f4c2f7cso7023005e9.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 09:15:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756743344; x=1757348144;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WzCHhi4hjG4XUTM3m5FXF23YIR33PFzU4tTzZn5EUNE=;
        b=niA1wmlCybj8YOt2QWwrxEtmOBLebmBNQ4LBhU7Ack9phrqQ45ZCiwJYdnzMilWRi4
         LKL4qvRX5Xzk3y39woQtMHx9+0ziMpde1DZrqQUJaKAoWnksFrNKYx5YGj7pESo/r3iD
         q6SnDPaK8EdF+znZRJvEumCj7V/iitUSj81A0cacJ2QSff/cnM4sWIQCyiEFokqq9miv
         cDNbUCQXScA6fXUSY57pR5EvWPbXewCVp8sIPIoQcbRY8w3R+G0YCuZFtGbs3Fkndys7
         xBKVy7NPvrGgQQ2YuS0g2GSAb4i358kuum03KcY4qic30NbTHDHOY+USUrCA2vTrvuvL
         fKuQ==
X-Gm-Message-State: AOJu0YyF2cvPB1h+P8+6Kxef5teGxYRMQD8YIcWWX0nrS42KJs6eLr4s
	05Vu0anoLgmyNGu6ehimDdbWIyLXr+DaZylYSDcc1cHhxgeypUNoEhLZfu3+M5HBROgEfZUmXbQ
	I/WM5StjhRKwFKa6qAfkWqWOLcN7wPoypWl5ufNpOGnd/nJvoBqfj
X-Gm-Gg: ASbGncsHquvZ9MqQgx23Q8tgQ3d2zdLl8wEgloRRC1K64EKFB/R0xY3Pa/rDaM+4y9K
	+PAp/78riWADL6H+s5IBwnw0Dk/wEqmoZGTc31A/NFuYjuDSI8HPPVKUQNBpJjKeNNWB3kGYsIp
	afGhXHSUTtTZo+Vmwd1SgzxGTJyR5HqLcIK0oO06R9fHHjIoGaS7O70ekgaL8GNwBtPZmIEURJH
	tFGYwwzEtV2PdW1fhHX4XJy3AMEkE7lbl3+VfHNePV7tn8M3Siow8pzyAeY63UGKgL5vb3AKr+N
	GlBE7DCC4Ypp/P1kY8W/icRjcFfz5qV+qvgc6iBMOHpzVgMgGmCbDfD8pWzL3tUxafjYpCerWI+
	4Sr/55s9eONmjflMzSk1x5ox5L/E5BbK9qzljFJMvOjRN2KK0t2piuXTf2hqR6o9XEq8=
X-Received: by 2002:a05:600c:3ba8:b0:45b:6705:4fca with SMTP id 5b1f17b1804b1-45b8558b82amr80213575e9.31.1756743343871;
        Mon, 01 Sep 2025 09:15:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBz1k7vAtdK4ipj+F4kTUm7DgeCfwB5I9v5S+ZFupzLSKLX3A+8B7qS4i4w56nZH+z+JGhtA==
X-Received: by 2002:a05:600c:3ba8:b0:45b:6705:4fca with SMTP id 5b1f17b1804b1-45b8558b82amr80213195e9.31.1756743343343;
        Mon, 01 Sep 2025 09:15:43 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d12c90a01bsm13377439f8f.31.2025.09.01.09.15.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 09:15:42 -0700 (PDT)
Message-ID: <07007d31-1601-4b95-b646-687295487cfe@redhat.com>
Date: Mon, 1 Sep 2025 18:15:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 05/13] khugepaged: generalize __collapse_huge_page_*
 for mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819134205.622806-6-npache@redhat.com>
 <2ddd1403-1bda-4875-91fb-7060804a50c6@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <2ddd1403-1bda-4875-91fb-7060804a50c6@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tIE4l07WOD9Br9DQCACJGi6qZVlfJF8SsIogWdb-PIo_1756743344
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D85D840009
X-Stat-Signature: xq3x3e8ncu7f3d58c9p4opw3oyxcxb98
X-Rspam-User: 
X-HE-Tag: 1756743348-107656
X-HE-Meta: U2FsdGVkX1/lvSZxNvJ9RldgWbrgz/PW5pLwJ5QaZ3uhHbrcG3+tIZeZ6QUo+iE+eQuRMLXUpzh6LLm7Xs1EWj14f458gmQSA6EQyOIq/AjbH8tVXYFJL3LXX6xA09cOByDvsOH0McfltpYsXAE+HCDJWNhIjN5qMm4HaqJUQBguaNa3mXzxGZHJmHZxjeuHyz2kFcwNAAo4RQ3AV2ym+3MDxjdGmTR+1X2GxsMU2fgs/DBbl7lj0bVN5E3OMGKX1+2uMjWqYivR8O9+QpDHJcDfM2HzE1wJawzme8qwEDsW+NfTM6604KK/Oir0PI+oslOxpn9AIdGD6oHZ0c53CkuU1eZUMhNa0XfVVs9VgvZ3SPS1jeizJPu9O5knjiVuOzUEp+ggBVRAaknjxZec2Wyg2UJZyI+xaR2lOGQXVL/dsssxA1EjMFjw7F7f5Et0YBhjTq5Im4O6oqaCEdjbv2EBFO49hPlIELH748VsqKivcIp6MlLMe15KOD3yVYoS3dXRP72wpx3LpQR4kl9cJGreR3vStH5Gvv2OEmdHGqrsVxGM0h5X7zYOlYvyyqRZRByC6rMTg94dJQNABHk1LZcmWjlyBz6Y0AcNa+Ir65PqmSm0SU2ZqIcby9V/CIvlKR8y+c0t+DHQEnQ5Mq62dM0e74G9lo4U5WBQqdhZlfOXAgWEhs4kMPfzDTcDH0jruB7KVd9KyW+Sgd3NXfebfgfoap5XMPimLcVBAlkJ6mspgGfx473lCXrH3CI6ZdNUDtfRasGTyHaAQGdObRMkBP6RItPc7mmZBwEkrjmlQNBkuXeTamactxkp9dBBYAJ6xqqgH6YwjH319PCn0x85C54H4lif4U0gU47P7GGFJoO5idUDX3Kp5CYirZ1pQDuYmJQot929l0xG7ll16osmR7nopWf8bYINDY5RwCMDO9GNm0hsHLS3Im0IfWXuuwNexgfVJPt4jxEUlECafYK
 F6khOvr3
 j2lQi8xIHboA5DA39K9YE4pxUZhRxLHh2hCB4VqRdBgDuOh9RMEu2mulOfCXCt9Vm/gZudic0syVmphXUo6e+bCQxqYF5mDhQ+oBK1sAookeARJmOeDphKYpiK60BZIF+c1Fo4ytkMPl7GsHANMctb7/uRS8g2rKWvskOt6MvbzcVCFrKuZww1zqh9Tudq0KYk5zVt8SILc+HxyxfQCJNqPxgldYVg4t11pT5MrNsZNuERuvZU/pwBGegMNLiNqARZTCNwzc22COBIQ2Dj86rahQNejZ0Z8+xgubXIT52Q/tO5M9IW0tPsopSf6BU+Br6AIAiyZcztD1VxLo1Gy+ewy9bobbq7a77rHCnhqyHUwqkrcuoa9Ca1iCA00z+2y4tAY28gRKDR5O86ttQqOkYHrTDwuPJw482QCaZzhykm6vVZNSUtuNAvFKC1hdZgwBZt3VTeWaoaR1H9z0sd5WAuscVf/MK+e8yimlHpNB6+JfhffvylYIzItQpo269GXlSK5VMZit+YEA8uUF4pzh8K/aD/hj8sMIBl6Rx1/gqNAx9MT4VzSzpSU1m2fqf7+bFQtr9jar8a9GSybMyshHvT5aActACcw8JC7c5c2y7Vs/iAVI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.08.25 16:22, Lorenzo Stoakes wrote:
> On Tue, Aug 19, 2025 at 07:41:57AM -0600, Nico Pache wrote:
>> generalize the order of the __collapse_huge_page_* functions
>> to support future mTHP collapse.
>>
>> mTHP collapse can suffer from incosistant behavior, and memory waste
>> "creep". disable swapin and shared support for mTHP collapse.

I'd just note that mTHP collapse will initially not honor these two 
parameters (spell them out), failing if anything is swapped out or shared.

>>
>> No functional changes in this patch.
>>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Co-developed-by: Dev Jain <dev.jain@arm.com>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> Signed-off-by: Nico Pache <npache@redhat.com>
>> ---
>>   mm/khugepaged.c | 62 ++++++++++++++++++++++++++++++++++---------------
>>   1 file changed, 43 insertions(+), 19 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 77e0d8ee59a0..074101d03c9d 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -551,15 +551,17 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>   					unsigned long address,
>>   					pte_t *pte,
>>   					struct collapse_control *cc,
>> -					struct list_head *compound_pagelist)
>> +					struct list_head *compound_pagelist,
>> +					unsigned int order)
> 
> I think it's better if we keep the output var as the last in the order. It's a
> bit weird to have the order specified here.

Also, while at it, just double-tab indent.

> 
>>   {
>>   	struct page *page = NULL;
>>   	struct folio *folio = NULL;
>>   	pte_t *_pte;
>>   	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
>>   	bool writable = false;
>> +	int scaled_max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);
> 
> This is a weird formulation, I guess we have to go with it to keep things
> consistent-ish, but it's like we have a value for this that is reliant on the
> order always being PMD and then sort of awkwardly adjusting for MTHP.
> 
> I guess we're stuck with it though since we have:
> 
> /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none
> 
> I guess a more sane version of this would be a ratio or something...

Yeah, ratios would have made much more sense ... but people didn't plan 
for having something that is not a PMD size.

> 
> Anyway probably out of scope here.
> 
>>
>> -	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>> +	for (_pte = pte; _pte < pte + (1 << order);
> 
> Hmm is this correct? I think shifting an int is probably a bad idea even if we
> can get away with it for even PUD order atm (though... 64KB ARM hm), wouldn't
> _BITUL(order) be better?

Just for completeness: we discussed that recently in other context. It 
would better be BIT() instead of _BITUL().

But I am not a fan of using BIT() when not working with bitmaps etc.

"1ul << order" etc is used throughout the code base.

What makes this easier to read is:

	const unsigned long nr_pages = 1ul << order;

Maybe in the future we want an ORDER_PAGES(), maybe not. Have not made 
up my mind yet :)

-- 
Cheers

David / dhildenb


