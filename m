Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46401CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 07:38:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EAFF8E0005; Mon,  8 Sep 2025 03:38:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99BA98E0001; Mon,  8 Sep 2025 03:38:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B2528E0005; Mon,  8 Sep 2025 03:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 787E38E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:38:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A987160A37
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:38:29 +0000 (UTC)
X-FDA: 83865280338.25.E1723F7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id B7359120003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:38:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DTEZopvI;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757317106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dHHdLgAcbywenL/cZnIRyAsE86ZGrixMjg4dNdyKV1E=;
	b=Se6C5wZEh9XGDif5UfRddbqVcZd5BBjVZJAjAAw1VyaFQv0gXj3AXuHU3E+vyOYSOkNJQo
	XTNeUw37cWi7Ycvuv2Ouec+MTy/Bq5bpES9X1r8KWmoqqtdTgKo5Cjf+kvjehSmlIirs6M
	utcGKqgYVYEbPITzOE3qP0by7giESGs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DTEZopvI;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757317106; a=rsa-sha256;
	cv=none;
	b=em6wi42AwYeCPfq+zki4wKySpxCrZUc/lPzQvIpysjO+jpjHijjVtWOtC1sGeZ1+tnLjIW
	8ihgZX0nu9oF7hkKKMTc4ik0IxDUpxLtOyIE52qle01qQdooyO+JSBLM7Oy+ZT3ZdhmBe+
	w8ql5EcuAi+G8XIbhmMvuwbfi9uAoWg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757317106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dHHdLgAcbywenL/cZnIRyAsE86ZGrixMjg4dNdyKV1E=;
	b=DTEZopvI5ZFMePg88hSdQixk4mDjKxyCjxyxSKVBdeVaAFLEHd0JPLugZp9u9RVIsJD6JO
	hqkI4+fhcOLkb7f2oHIYWruvWrRGHRoQfo2l1qcEZq81CAvLDEWgJuHPVje2l5/G030HVB
	OuBp2JbrOBSrxcloWAEbcXSMVm/T0Yw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-u2JRaJLcPJWGIifEWelYnw-1; Mon, 08 Sep 2025 03:38:22 -0400
X-MC-Unique: u2JRaJLcPJWGIifEWelYnw-1
X-Mimecast-MFC-AGG-ID: u2JRaJLcPJWGIifEWelYnw_1757317101
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45dd9a66cfbso27021125e9.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 00:38:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757317101; x=1757921901;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dHHdLgAcbywenL/cZnIRyAsE86ZGrixMjg4dNdyKV1E=;
        b=IGco7wOY5I8MS/+CideBUuGrE+M8eP5okijEIGfqODXzCwU80uOxUet3Ayyf4bAd+y
         KJnhNz7UFLcP9sF/YF1xqawT8LCZk9uTVWYNZupo9OuqUmXelNnmNDbCsj/RXDhvzp+v
         wV1L5yt7GwMUWeGhsctQJRJkkMnd0ZfqYSVemIT1/x5kaHwSo6yOUxI4slJ0FtNY4Nu7
         6vcuLMftWvhjbT2LdVMnfyEqjYBCtSIZOc+SZxgy0HALJ40qBkcDQ0T/9ZNML3AUPMJm
         uc4dxufW4fjutgz3O/VLstsz/yhaCqcU3nmNsY+7UG3A6bUxvB6gm22orH86OwdCZByN
         ZDJg==
X-Forwarded-Encrypted: i=1; AJvYcCWSHKug0bWXONL95Wy+28tIq+i/yoEPOFOrr46O2SNKA0y8YnBHNSj4O8nXNati3+C27pil3dGo/g==@kvack.org
X-Gm-Message-State: AOJu0YwL6bC/b6HaOOFR64+dfcco4yI88VXnJ4dsbezHA+ZNr/Skae+N
	LYoWKnQgswxi1f+hfGZPdDCUNdYiK6NvAoHWWwFCADSzIJ23AvhQPbpXe4LSx3hXFQiIXe/3WbE
	ZPcw/edEf90xCPpiXexkfgjllrYw/VvD4EbhUnIqVwjgJLqrtmYTf
X-Gm-Gg: ASbGncvdm3MqzSA06GnK58HNmoWaLPs3AcBEeaApWuvcXvhDMcMmCtmkZ0eEzbpiTm6
	A509BKvf9923edQNVRPBLmezVj++y1wUpe6Z9jOgYP7BEZ2Z1zoVKcyvekcknQs06+KDCUACmWn
	As+PjNFVA5LrPLQgiYLbSeRRaYV8eOYxuMCkIXN32yT61RTaO6hF6cnnClHbljgv6U4Bj8DQtud
	uWRXIjjxq7hrbnfxQK+NpF4EsVac1wz6LGCIwk8puy7BemDO3aRqxr3hMVTZt4wNBypt/slmAuw
	ov5zF/WETvS+zVdqAjnDjq3P25Ld0fe7CpLDuAMIV0WFrP38n8iZ0rF2j7J+8B6JTH3muQU=
X-Received: by 2002:a05:6000:1aca:b0:3e1:2d70:6785 with SMTP id ffacd0b85a97d-3e643ff7737mr5284116f8f.31.1757317101313;
        Mon, 08 Sep 2025 00:38:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEi3ixPEd6PfcRDGE6ZK7yoXiFzuvm/dSuHsKQcRA2BIwiOIaHzlh3VPu6rAD/JstskdMYbg==
X-Received: by 2002:a05:6000:1aca:b0:3e1:2d70:6785 with SMTP id ffacd0b85a97d-3e643ff7737mr5284084f8f.31.1757317100864;
        Mon, 08 Sep 2025 00:38:20 -0700 (PDT)
Received: from [192.168.3.141] (p57a1ae98.dip0.t-ipconnect.de. [87.161.174.152])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e705508e22sm7508811f8f.49.2025.09.08.00.38.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 00:38:20 -0700 (PDT)
Message-ID: <5a1429ad-3900-404a-bdca-f25623ce603a@redhat.com>
Date: Mon, 8 Sep 2025 09:38:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm: avoid processing mlocked THPs in deferred split
 shrinker
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 usamaarif642@gmail.com, ziy@nvidia.com
References: <20250908040713.42960-1-lance.yang@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250908040713.42960-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fXQUwo-hIASbjtHgIAjLNxyoVxdg33HV7R8KTAxdpl0_1757317101
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6sdzzkp34kog4shcnr5ft9sgqtwtcdbm
X-Rspam-User: 
X-Rspamd-Queue-Id: B7359120003
X-Rspamd-Server: rspam01
X-HE-Tag: 1757317106-924972
X-HE-Meta: U2FsdGVkX18ShfmwIb2dESSgnNs1djfmJ4Rc0PsvaC0VUNC4ODu38TtJjw5gK+kJFmwdg139p4+82j3Du0b75UC8+Rdlo+bdM9XpSrefKKkrpuatzkJijMImdqCnpeE9QkH76ZsWsyEUX89Jvot9qKrPNwelOLsdJPP4U9CHXBBpJbj3JO7k0bYON+Yg7mkqxk+JCzf6lomlBrc1YTY3AiZPbKTPNcAmN8JetuL7hlsiIpfRcNdwO6cLqzldFjKdgmjIleXuOn1N63FpZPbN7hgtLUlR/lAiB+A7eNuNTHiq2inQEr4eTRWpNuUj40aP5jA7hdkekAlUpsp/aL1WYrls1rBbPEyyTPC0wDVBQ99KbwxlAClHq9/odMOeO/BuW41wGZPRGFnU7esKCoS5zW94SGlM21J8HbYtTlFuTqXB1yGkzNDmMWTDaQJi4De4KLEB+CiTHosgDYWPVssp4h8e3DyzKGbxnZ8yAM26VgT5/vBKcP0I5cdm9qyUtUo9ZxpUaj0Vc1ZtbETNsLgXG7jnmfFHIS1cPCdtcv97wkb6mNjIo+ypN+YaMyZ05I5aVU8O/Nq0XDGtYQc1ZSQGx2DaGBoW52yxsxaXchnoHYwQh62O+7qYV9h79z//lnM4EFkORf9hr6y4IsxdNUloRtxK4dCQMXJvkiUzhDF8Vw7jNYkw6o4kkke8t2gbNVUZgsabFN4eZ1M7XmAxKlrguz0+X2nx2dWKq9p1s3QNq56SA1PUeplON5wC/MRttDys/FlaFyNpAQxeso6JJNonO0k2mrbyIXK2NfoZzgS3RYWv4J+aLHsrgBS/C0csMSDLD6aBbmlFQ+dQNXQset1JDbiCYtmFOeMutDQKOYyvF4PP4MgIBdhR4buJE2uJLFVBCZSAhQV7+PqPBSKuCSA1x9/2DooSE5+fY1PiV5DcMV9x28BDtiWbv8gdYc9GMAnIT1snhVVr6xZwHMPDwYn
 FjRSTbyH
 N4p0w71LFKnqfyJQ50inMxeXQfXQKawXrUFn09QlwlsIRvx0Er0eGX1BhHu5jcz7xkxYkOjQ6Acy2inRzzj+hZQfUYztRRF633iC6K8kMAp2fMdVsANqZBBk0U19d4XcH7UTHOLVYu8MGeDqKh71Tq8eUXQ0pac+NFGU2N7lwjXb+1JqH+Rg38A0riE1/K4KQWffpGq/bLZ1o8ubp3vfxlINt8EGm4HYpIVI9MNlmi76vt4e12/jK2Zp4a8ce3bNODCTRknBTOQg2p0QM11jjACghZfcgc8nHgLeq21wbM2ie/akidH2BWZFLjQxJTLelodMS5m1S0V46GO0KAq+oHCZ9/37Ay0jzUQpXD4X/Dd/Q+9KatKve2LYV/4cs2yaPi4utUaT8vZ1qtLfw0Kvrfnw+JbXMQ3Eq/hDtWWPuN6jh+QdZw8T1r0/sWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 06:07, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>

Subject should likely be more specific:

mm: skip mlocked THPs that are underused early in deferred_split_scan()

> 
> When a new THP is faulted in or collapsed, it is unconditionally added to
> the deferred split queue. If this THP is subsequently mlocked, it remains
> on the queue but is removed from the LRU and marked unevictable.
> 
> During memory reclaim, deferred_split_scan() will still pick up this large
> folio. Because it's not partially mapped, it will proceed to call
> thp_underused() and then attempt to split_folio() to free all zero-filled
> subpages.
> 
> This is a pointless waste of CPU cycles. The folio is mlocked and
> unevictable, so any attempt to reclaim memory from it via splitting is
> doomed to fail.

I think the whole description is a bit misleading: we're not reclaiming
memory from fully-mapped THPs even when they are underused, because it
could violate mlock() semantics where we don't want a page fault+memory 
allocation on next access.

So something like the following might be clearer.

"When we stumble over a fully-mapped THP in the deferred shrinker, it 
does not make sense trying to detect whether it is underused, because 
try_to_map_unused_to_zeropage(), called while splitting the folio, will 
not actually replace any zero-ed pages by the shared zeropage.

Splitting the folio in that case does not make any sense, so let's not 
even scan if the folio is underused.
"



If I run my reproducer from [1] and mlock() the pages just after 
allocating them, then I essentially get

AnonHugePages:   1048576 kB

converted to

Anonymous:       1048580 kB

Which makes sense (no memory optimized out) as discussed above.


[1] https://lkml.kernel.org/r/20250905141137.3529867-1-david@redhat.com

> 
> So, let's add an early folio_test_mlocked() check to skip this case.
> 
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   mm/huge_memory.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 77f0c3417973..d2e84015d6b4 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4183,6 +4183,9 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>   		bool underused = false;
>   
>   		if (!folio_test_partially_mapped(folio)) {
> +			/* An mlocked folio is not a candidate for the shrinker. */

/*
  * See try_to_map_unused_to_zeropage(): we cannot optimize zero-filled
  * pages after splitting an mlocked folio.
  */

> +			if (folio_test_mlocked(folio))
> +				goto next;
>   			underused = thp_underused(folio);
>   			if (!underused)
>   				goto next;


-- 
Cheers

David / dhildenb


