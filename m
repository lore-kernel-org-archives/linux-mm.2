Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D835CAC5BD
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 07:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA6B48E0003; Mon, 29 Sep 2025 03:25:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B56138E0002; Mon, 29 Sep 2025 03:25:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1E638E0003; Mon, 29 Sep 2025 03:25:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89D2E8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 03:25:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36CC98603E
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:25:42 +0000 (UTC)
X-FDA: 83941452924.14.91D278E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id E7C5810000E
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:25:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UdJNwF0s;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759130740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4sy/3KO2tjGWTLYogygfceE41CTUap6pmBFJxNyOknw=;
	b=rOHZZ7v5bzMkzT5dMBIhLWgxcYVhCVnfI1PaLNH9BiKoAargAu9BeqL7SBQfX+3z15yiwx
	AQFEg1kvY+vNx2jEb4QaG8y4PFubp1PP9eVW0ILfAl4KEt0+hJbG22IrCGYxqWk3WCSARC
	z2qLARWS3N5YkdGumlObe6eEdmLrN1s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759130740; a=rsa-sha256;
	cv=none;
	b=ZxPm7T/iLTSiBqXpJ9TZ7l5oBbluQ8Km1z+0+zEsc7KyXt5jgHzkZlrhrlzGh/MM1I+AZF
	HSuRTWnI90Dul4xzs4p9sTimCvJv7nVn6jsYNJ93efJW92GeWmNPQ22HdW4ejqVAp3/Mqo
	mqSmvxzzmWjL4Hbed/IBNNxhAGl8go4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UdJNwF0s;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759130739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4sy/3KO2tjGWTLYogygfceE41CTUap6pmBFJxNyOknw=;
	b=UdJNwF0sdJbVcODt7JDX3CIgWhQM4rF1n7uE62qFr/De4TGnx8xcfr3iLuHpU/e4YJ9nuy
	DLD5dK3TDeEvztWWw4zVWHcLpxkrQub20+G2m5qLpQGckjOJ9J6sYmCFv2UFeXaryZRHjd
	sE6J7vLPjXZ63aAuSA/usGLV/yAZ7A0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-jWo6zMivNiW9UWwdvc7q-Q-1; Mon, 29 Sep 2025 03:25:37 -0400
X-MC-Unique: jWo6zMivNiW9UWwdvc7q-Q-1
X-Mimecast-MFC-AGG-ID: jWo6zMivNiW9UWwdvc7q-Q_1759130736
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e31191379so27408605e9.3
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 00:25:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759130736; x=1759735536;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4sy/3KO2tjGWTLYogygfceE41CTUap6pmBFJxNyOknw=;
        b=crbT1padti1h50uqB1xl9t7P7AzswKW53KECxuTfrR3JUC2llT+twpVckVVsir4HTR
         lqLQ10vgGpRmDpA2dlye8PJ2N0EZuWi7n+q+p/mQiCyP8sf6oTmsc3evDsQP0W9o7QPc
         d9TqD+rV4INHRvWpWVH2tYBsqsrhzPIr4s/sACVLbmYt7igkHxjbuZpnyoIGzc1bHDB1
         9UZEIp542DN35el4TVs7pUfZabSBHXkjY7TTNAS+8Brvjqyvm8wPiySMNb+JVegJxFC7
         JP/IuI4Y+AhBsg55fCAYcC/zYLzepn+pdQQnCJWyUxlz5BLmE+4pWp5yTVcM5I/ospst
         R6OA==
X-Forwarded-Encrypted: i=1; AJvYcCWP9AX3nMvpOw+VxkYoBBQrC+3+0OqrdB6NMnarPcGebpM9lxM3GYFGzT+xery079a4+qnODNz6SQ==@kvack.org
X-Gm-Message-State: AOJu0YxCIsNZB15M1gjEpjJsGOMmI8+NOQo+qnf5Wrwai0AyWzYvtpdF
	Wrqc38AqOAW5IdNldYfmUGUNTAGSD/qbKlmFbhbJKZfd2YlGemmGFlzWSa3ym95JzPt5CNJgHjd
	6F9vFpoUN5qlpBj/TpLkZ4e5DLoj02Cjbyb2BxIybr+VukryMR6hN
X-Gm-Gg: ASbGnctOilCtEVKbvwMvyqmd25YyPfXqMcx1WZsf7bwXsKfPvWC2FNAddMpJdN0ByHI
	2o6AzEDy2kmb4CFnpSdSmzrxKkx8HtwLtdaWZWgvQ7HtC1DGShLnq3ckQV+nOnC+QJOv0oMDS4J
	x+3CEp3j4XiJTxG1ETU7anJkQaSbIfi6tz88nAfN56hgXDHnmTuM97d9nbdmg4oT+cIWg+xCcJ7
	c98ZYsQgsByg4p+LMrV0atLoeuRSReEVy9eVeyfYRgNG0XSBxpJmKYtgZmHwM/f9wfG7o2Gu3i4
	rhpO+BvrAf7me6eRviCFTR/A9WjhIA/rxZ/5wCh1ON73H5nhSOMkKazBTO3zZ0Up/dJKeV5LzaH
	CTwAuqFCGMx/S8hkMOi/rwZTwxZynOhnSfDhTEPANwdYjHbGtuIhL2tQYVCXs/WofbQ==
X-Received: by 2002:a05:600c:c0d5:b0:46e:4cd3:7d6e with SMTP id 5b1f17b1804b1-46e4cd37ec1mr23407135e9.9.1759130736295;
        Mon, 29 Sep 2025 00:25:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEC8JA6ojG0RK/BWOWXqdIdPR54HSGF6zZtmicAMPJN4Os7iy+ZeWmHixT2nGgDQSTRkKabRw==
X-Received: by 2002:a05:600c:c0d5:b0:46e:4cd3:7d6e with SMTP id 5b1f17b1804b1-46e4cd37ec1mr23406905e9.9.1759130735908;
        Mon, 29 Sep 2025 00:25:35 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f05:e100:526f:9b8:bd2a:2997? (p200300d82f05e100526f09b8bd2a2997.dip0.t-ipconnect.de. [2003:d8:2f05:e100:526f:9b8:bd2a:2997])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab31f1dsm212404725e9.13.2025.09.29.00.25.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 00:25:35 -0700 (PDT)
Message-ID: <b19b4880-169f-4946-8c50-e82f699bb93b@redhat.com>
Date: Mon, 29 Sep 2025 09:25:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/rmap: fix soft-dirty bit loss when remapping
 zero-filled mTHP subpage to shared zeropage
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 ryan.roberts@arm.com, dev.jain@arm.com, npache@redhat.com, riel@surriel.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
 jannh@google.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, usamaarif642@gmail.com,
 yuzhao@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ioworker0@gmail.com, stable@vger.kernel.org
References: <20250928044855.76359-1-lance.yang@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250928044855.76359-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EP7NOyAIgJ2LNyDSvFtCgaN17ob1kYxNYQDG6ALt9-0_1759130736
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E7C5810000E
X-Stat-Signature: jc4wjwikk1ymeojsz5fd5j57cgszdfof
X-Rspam-User: 
X-HE-Tag: 1759130739-442092
X-HE-Meta: U2FsdGVkX19KQ2XZukwGyX6xFAPRCkr0Y9SODn7BRkAPm36Ur8hhoh4n9InJhndcAxFteRQ5UjHOTVfRQQsnJJ5NIrMld5rDvYdMpU/UKGl7gFKhwSvNuzU8eoJsegUhmoHuHdJddCHpJhIKtvJA5abZsGoigdnkEEOT6y7D8j4qqodMlRPX/kw2m1oKkN6kDdcIt2xkoPg5sZ2ngeZfNgQKaMo5GctD9LvWkb1CAZJ/sJMk5nIsCf+GxOm6sq+Kq1i7ptU13aTST+YN7ahET+lPQoI4kt6vX/PgzairapyUx0nUXgNuWkyAhLIjwJ9cKWsYK0kNK3TrThe0oclfsXTIoxx97/6+xP7lHQQUnD8Tr6Tz5Mfa9kDZMjCYWa/n6vYeGUobemMWkbCURLNSqal5VhLyxmBy5JyL+QKDwwY3Yv1pG9fitE8O96IFFD3tcMYLI7j8guQO4c9vMdtd0NoUjojp8/yPUCkMrDe82JWigZXlvHQB8bul8xWL/LxwynrImRoRv0qfUbIYSoTbMgK8z+D8+qXX71YM4EEhOoKAfEeFPDBXMAWTdRRQWsqJtzQBxhbhn76Jcxw+fL8VePPTERTqztPVeQudIieJaZpLSTP+mA5gnu6ZYRYlqyd2DI0yDiz9utgkMO4EehK2zG53G91tTk2P8C6qjh/duQ6j6aku+fCpReRYUgzhwfvSJzQaPHJlGy7akqPzLcjdZnaAnKUUoUqvuBqRnu62UQQmC2Qsvnm6YSD/02Z1nOEa7wGeCC46rj6+4P6Bss51dGyhjYJXcarBHm6UzROgaGXfvnlTwRCOKLhqqT396jlVsxLoK/VxnmPtsx8NzcNgg7CnFhEVmseIKlpGz/+pr7fAtEcrVYz5u0zjNtxhUMGnxng7l3BSC8FnPE5y08EGnyiZnmad6WsYm8zAOxCyVytYiHgp0TGwag3kkJf3GOaKBbKrbtrSh+mdZXnbU1j
 fYxAlHdG
 tXj3Rv4/p1z6nISqIHIs30o6z1YBjf1s9G0QML+DIAyU59UWHPmMP9c5rgFoVJBwbdBHIYk7tWqyag5HUG3rd45x7lRzClZAh4WuwzY/Sykau0G4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.09.25 06:48, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> When splitting an mTHP and replacing a zero-filled subpage with the shared
> zeropage, try_to_map_unused_to_zeropage() currently drops the soft-dirty
> bit.
> 
> For userspace tools like CRIU, which rely on the soft-dirty mechanism for
> incremental snapshots, losing this bit means modified pages are missed,
> leading to inconsistent memory state after restore.
> 
> Preserve the soft-dirty bit from the old PTE when creating the zeropage
> mapping to ensure modified pages are correctly tracked.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   mm/migrate.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index ce83c2c3c287..bf364ba07a3f 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -322,6 +322,10 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>   
>   	newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
>   					pvmw->vma->vm_page_prot));
> +
> +	if (pte_swp_soft_dirty(ptep_get(pvmw->pte)))
> +		newpte = pte_mksoft_dirty(newpte);
> +
>   	set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
>   
>   	dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));

It's interesting that there isn't a single occurrence of the stof-dirty 
flag in khugepaged code. I guess it all works because we do the

	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);

and the pmd_mkdirty() will imply marking it soft-dirty.

Now to the problem at hand: I don't think this is particularly 
problematic in the common case: if the page is zero, it likely was never 
written to (that's what the unerused shrinker is targeted at), so the 
soft-dirty setting on the PMD is actually just an over-indication for 
this page.

For example, when we just install the shared zeropage directly in 
do_anonymous_page(), we obviously also don't set it dirty/soft-dirty.

Now, one could argue that if the content was changed from non-zero to 
zero, it ould actually be soft-dirty.

Long-story short: I don't think this matters much in practice, but it's 
an easy fix.

As said by dev, please avoid double ptep_get() if possible.

Acked-by: David Hildenbrand <david@redhat.com>


@Lance, can you double-check that the uffd-wp bit is handled correctly? 
I strongly assume we lose that as well here.

-- 
Cheers

David / dhildenb


