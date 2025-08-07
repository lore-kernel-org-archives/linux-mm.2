Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CFCC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 19:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6F028E0002; Thu,  7 Aug 2025 15:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1E1B8E0001; Thu,  7 Aug 2025 15:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E6EE8E0002; Thu,  7 Aug 2025 15:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D3C48E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:11:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E614A137817
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:11:01 +0000 (UTC)
X-FDA: 83750903922.08.8A673B2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0E5C620009
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:10:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eboI3kMP;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754593858; a=rsa-sha256;
	cv=none;
	b=HqBZOXIZWyzyUa+IGOwmzNzHUHoH346P3/W8BEwdUWE93AhOdeVdugqAKDUesrVPT+OGlg
	MVxjr0dw93xCNeXymvpETdVCQkGgUSg7is3qHfHGnrawECfSomQ4E8/3EbCvEki71siXPb
	yzNL4aiq7eXnj7GZww+0NlUyjdHIMIU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eboI3kMP;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754593858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a6eH69LxmXMYsaPkPvzCN+AdEuwzJKY4+tn/p+ORHaU=;
	b=XxeDU0El1rdxIdkvrGbh6Za0GVW3RTS/qzkq2JU0VuTbsIyYNDQUduhoQ15HlXednL1a93
	+oG/4jd0Nq5HeyAQD91MK7DuW5HXkFTYaOMrwx/eDMFzUV1yg0uEEPglDfIzrR9TO0WSml
	jgMFTt0t3uMl8vCYCdq+q8ipKDG692Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754593857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=a6eH69LxmXMYsaPkPvzCN+AdEuwzJKY4+tn/p+ORHaU=;
	b=eboI3kMPpp/Ts7mDAD6unbdUPQLdDQkpyHVMtDXL2V7gnyTGhkwOYwcvH/UmXgat/hd+O4
	GIYmEKcxd9msG3zZJ4HCwojTqRuBWcdQrd/Sg5Rp+CWBdEgUtMO2aZb+qMhLsl5Dg8cbzc
	RkGSN0hqeWnVgEk3b3LF/Zza9zerRF4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-lkAWestvPdGV-rexj-di0g-1; Thu, 07 Aug 2025 15:10:55 -0400
X-MC-Unique: lkAWestvPdGV-rexj-di0g-1
X-Mimecast-MFC-AGG-ID: lkAWestvPdGV-rexj-di0g_1754593855
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459e6c564fdso6034305e9.0
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 12:10:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754593855; x=1755198655;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=a6eH69LxmXMYsaPkPvzCN+AdEuwzJKY4+tn/p+ORHaU=;
        b=KRWHQZBSWhU+aGS4WqmFtO845F5l7b6QhEhXd47p9+wsKxxahi9/NH5G6oCIXKJoYV
         DRg8dcBk+MrYfjL9RGZeXnEqmg6jwKxiczFmwqCNbPK/GNS0KPvGbAdeaD5yb9zKljxR
         d5r30S7p+/Sg5biXit3GC2MMCXy//1Lw/WXVLp2JCBIXGZ7hMyIo6w7ESLvH5Aotz0fT
         kxxSyRe6YLqgQBW1Yevr2fTsU/CcbXIfZ5q3xtFFTBQrlK3OXCZZCHmbYs7y4x2BIi0X
         bl0GPURma2euPFawuxKaA5LfjIZePFoNNdveXYr04HDGigvF/yHru27nO4knS3eM0nTH
         n7Hg==
X-Forwarded-Encrypted: i=1; AJvYcCXDcEipyKsognQcQfT19/E5YcjbQV8OCoD90wtFlbx8NyUyIoz8GOGHhBsqLsDHZl4mTeDDeL1k6g==@kvack.org
X-Gm-Message-State: AOJu0YzV77ogrzGvXplcDDD50IIR0ld3OSFhVbhret8S3BMt6QOBZB3Y
	WyGUmzr6Hl/kAwDb3/OwRCRfBd9xnxAgnMNjY43fO63W0b47QzGjYmidp6ao+8D+EfmmNhLOZSg
	bWrQmNiarLOdLuUS2UZWsAnwWZeRbz4F2szXNCtEf5fdfXIa/NXah
X-Gm-Gg: ASbGncuzRyCwSyytXtu/seh6DkStbAyIEQRcm9AdFbbm1NgEi3quMqr3D6AvMXSTbup
	jCYBZkhxwaM9Rj/W5tsj9QJ2oboRqQQaJ8hCxkRRL+kdsgaJfpeZK+Ns011UpbboEN/TYakBl7q
	tuGkvcuM7oaZd8VRbnTeHsxiXdgRg/m4NLRp0WyICKCZa0Gwdd8veC/vIZLBvxtsZF8bh87Ax9h
	/VR+JCetE6vYeSAG4NhO3SKyMOAV+j0o84sG9RCL7Z8ftSApVpxlm1oGgFQ/k5aI7F+ulDlbp+f
	zw+MBDMoRr8wQFgHGJ1XfT7fmCKAeyoIzHafhokBCdbwzvFdfiGa6K84E5TaoQapqzrVEhJVYpO
	JYFFVwoaAI7YHkil1x24fAMw//t5dl9PSHGt5/GwR5PINVgynofPW58QZ2hbg9pa/paU=
X-Received: by 2002:a05:600c:45c7:b0:458:c002:6888 with SMTP id 5b1f17b1804b1-459f4fc0ee2mr580215e9.32.1754593854636;
        Thu, 07 Aug 2025 12:10:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEfskDxx2ZKvsf//OfNBtDtOmUppN3tfOBPkKr36e+s4etTTUVcYCSpV3IOuXQkGCW8CKEmQw==
X-Received: by 2002:a05:600c:45c7:b0:458:c002:6888 with SMTP id 5b1f17b1804b1-459f4fc0ee2mr580035e9.32.1754593854168;
        Thu, 07 Aug 2025 12:10:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f49:bc00:12fa:1681:c754:1630? (p200300d82f49bc0012fa1681c7541630.dip0.t-ipconnect.de. [2003:d8:2f49:bc00:12fa:1681:c754:1630])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459de91ea4csm158838245e9.10.2025.08.07.12.10.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Aug 2025 12:10:53 -0700 (PDT)
Message-ID: <158e6422-fc82-4d6c-a442-2ebe956a66da@redhat.com>
Date: Thu, 7 Aug 2025 21:10:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH HOTFIX 6.17] mm/mremap: avoid expensive folio lookup on
 mremap folio pte batch
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MSo4gat89UjC2LWpdCte9NFbeR5-aqNx--t-0afAeoA_1754593855
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k9sir5uctg3e78g5z1pr6bcf6dmcosur
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E5C620009
X-Rspamd-Server: rspam02
X-HE-Tag: 1754593857-660094
X-HE-Meta: U2FsdGVkX18P6PGwvFrCobIIe14f4neOHVEY/l8s+Q0Z4B8FIsA8X39LXJhrhwdyeKwXGXWU7xhg6qGn9LLiktipGfa7oPENM1FyeAp+Q+SHjVzfQqnUq6oznItoYN89/bjRuDEDNYkybyEoADOrAmxEjYtv6vm/IuomE6fJNdRmQP0rZJvw1LEskWRNnLPJPGlA1PoF/907x9JeB8FHqwfCHD5ga40mHlcBGWrY3IVzjpv07gqyI2IpicLZEQqixFnFfr3wJcL/uVc3DFLZp07af40CbhknBgY5Qu2edQ2Ngjsvndt5k6aFzY3ohiI+9Yst3yovcePa161x9irFYxhDNOK6qlpAs3NEX4F4a8PYSxp3Z+VPcpMKia8J3PYk9ZMit0ww/SVRrePZ/EhvHLWwfdpdDnvy7vrmGRwZx/jMAEZBO/gG9wFZ60mTUIZJgvmWqpOb4bM/mZFn3kdlqpV2Qh9Aog+XOf6hvJ+7+j2W03KUg7ULgUpCxyLQBvUvqlLB+Z4t1vBy6tkV/3jGHq6pOadGhijU4kXnCpktTCVy4kxHyZs7ikgSWnVP8PGjJbrqJz0EZF0mudK3NDOk0DpN7vpT1JXeXbTP69EOf97uYITS79IkVQyfUqq0a7iB6RajihkhQc9qhNciA+T/uY2bAnloP0RSICUDBw0tdcEXPv5YZ9Owl7sKFUUqcRgOoREg2M1BMYPiDd5eIdujLnZpwe/rn4QeptwY/SLn4efNxAhkBJiRmHu6T6RF+07NwbaGll6d6MjLJn1HieHiSW17vzqbUJpo9fIVT32N67DiQgrcz0l4WjqZYluPSsfSkGvOKbNOLihNK/N1YTUqZ+3N2yi4caszg5toRlQfqDb58o4GIIToeCBwZa8wX42MsEYYV7OUTJf88Hu2AsK/q4fYJ74dacEHXwjlYpJKdlUQ4pE8L+xylUsu5LEZ8BJE4sSfMvx0SllPP1Fx/7P
 CGpWbJrU
 DJ21nDZE4fuqdQngYuI6VjxYO/xJgBOdzLS1Ac9eygRVyHvj3y055qmIPKipLGQ9UubdgwQyAu4bXpWb2l2w1NRn30VVcYqORWlnzrNqDZgORbMXlsaZsebfKmKj/WggCMRbPFZmkOrfzl+uEgDfhPtp32f7rB7LtWhmeFGJN06xnvmpdS/3KbC3MI6WUjq5Y91Q8246vDtP+khOKEr/RwG1OQoBE/JhbE+TTEopEtufjlgtO38BikKJYiYrO3VEGadcjTyE553TaXwbN3GfzudGUYct42MbGR5Prppkm8lnouWp0FcBJttrkg7DmNMdmnb4p/P0+tRTiIVhCfQ9rmONidiuilIZODJNNjXikb/misU8oQdszQcenjdldAzrtemTp/Fag9mfK45eA9ouT6HEhQGuEc2C6S9T1OE9i8ScSkBixb3XNDy75QuyTLhQPEA244yVXCC7ugAgx8qoR93gWN69JUbjxzY0YQeU2MOylTw9fO1JaribOSg3XdBrwEQvVZU0q5n8PXj4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.08.25 20:58, Lorenzo Stoakes wrote:
> It was discovered in the attached report that commit f822a9a81a31 ("mm:
> optimize mremap() by PTE batching") introduced a significant performance
> regression on a number of metrics on x86-64, most notably
> stress-ng.bigheap.realloc_calls_per_sec - indicating a 37.3% regression in
> number of mremap() calls per second.
> 
> I was able to reproduce this locally on an intel x86-64 raptor lake system,
> noting an average of 143,857 realloc calls/sec (with a stddev of 4,531 or
> 3.1%) prior to this patch being applied, and 81,503 afterwards (stddev of
> 2,131 or 2.6%) - a 43.3% regression.
> 
> During testing I was able to determine that there was no meaningful
> difference in efforts to optimise the folio_pte_batch() operation, nor
> checking folio_test_large().
> 
> This is within expectation, as a regression this large is likely to
> indicate we are accessing memory that is not yet in a cache line (and
> perhaps may even cause a main memory fetch).
> 
> The expectation by those discussing this from the start was that
> vm_normal_folio() (invoked by mremap_folio_pte_batch()) would likely be the
> culprit due to having to retrieve memory from the vmemmap (which mremap()
> page table moves does not otherwise do, meaning this is inevitably cold
> memory).
> 
> I was able to definitively determine that this theory is indeed correct and
> the cause of the issue.
> 
> The solution is to restore part of an approach previously discarded on
> review, that is to invoke pte_batch_hint() which explicitly determines,
> through reference to the PTE alone (thus no vmemmap lookup), what the PTE
> batch size may be.
> 
> On platforms other than arm64 this is currently hardcoded to return 1, so
> this naturally resolves the issue for x86-64, and for arm64 introduces
> little to no overhead as the pte cache line will be hot.
> 
> With this patch applied, we move from 81,503 realloc calls/sec to
> 138,701 (stddev of 496.1 or 0.4%), which is a -3.6% regression, however
> accounting for the variance in the original result, this is broadly
> restoring performance to its prior state.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202508071609.4e743d7c-lkp@intel.com
> Fixes: f822a9a81a31 ("mm: optimize mremap() by PTE batching")
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>   mm/mremap.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 677a4d744df9..9afa8cd524f5 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -179,6 +179,10 @@ static int mremap_folio_pte_batch(struct vm_area_struct *vma, unsigned long addr
>   	if (max_nr == 1)
>   		return 1;
> 
> +	/* Avoid expensive folio lookup if we stand no chance of benefit. */
> +	if (pte_batch_hint(ptep, pte) == 1)
> +		return 1;
> +
>   	folio = vm_normal_folio(vma, addr, pte);
>   	if (!folio || !folio_test_large(folio))
 >   		return 1;

Acked-by: David Hildenbrand <david@redhat.com>

Wondering whether we could then just use the patch hint instead of going 
via the folio.

IOW,

return pte_batch_hint(ptep, pte);


Not sure if that was discussed at some point before we went into the 
direction of using folios. But there really doesn't seem to be anything 
gained for other architectures here (as raised by Jann).

-- 
Cheers,

David / dhildenb


