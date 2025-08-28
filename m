Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EAB5CA0FF6
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 20:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7FE78E0008; Thu, 28 Aug 2025 16:51:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2FB18E0003; Thu, 28 Aug 2025 16:51:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A96F8E0008; Thu, 28 Aug 2025 16:51:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 86E1B8E0003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:51:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 35C571DD9A8
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:51:57 +0000 (UTC)
X-FDA: 83827363074.26.598595E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id A0C85140007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:51:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UhYX4RW1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756414314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TWFVCA1eidbRWe4Mvk+B7obYKckT+mqN7M8LbBoJEjM=;
	b=6+4aN7e/ovQwD97EmfQEQ4TiE42ZB/A7EgS4GzefpoFdJQmPDlWw4AjpyIowLcgaDraVT5
	Vck/d1OtWOoSDp0ONwcYKXu39exbaucU2dNyJunvO7VbZjhxco9Gg2hdWjnCG3mcmmTEpK
	sB4cQLS7qbctya3CJDZU7pXdZxiZbeU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UhYX4RW1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756414314; a=rsa-sha256;
	cv=none;
	b=FgxzWciQ9BMD/DjYGcRg+S9BeJsYb/fXX65O+7UkAx40T73mcs5i2QxO5rvWgOGo/+v4gI
	vCffTw/YD4YQ2wOPgLMRLffYsft3+ng+drpxKhtdTmcvCjsEXuWGEwlhX+SyesWx/zZT9C
	9DB488zN4kH9kwgG8u7abgqpDcXmxTg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756414313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TWFVCA1eidbRWe4Mvk+B7obYKckT+mqN7M8LbBoJEjM=;
	b=UhYX4RW1cHSThivPDmx+7E/zp/Ld67BOG3uhZx1RXHbL0liP0AH/b13dNOrsmkjoCJe6mj
	+R7+Nc9u+NgfBfpjSD+0Gbty4mb/leeHYP7oPGfLuhnwSwrpS343bsU0ZGIpjAVrKV6Ge4
	WKMw6E9/Mbsp7lDM5VBFso1x3bYkySo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-375-Z7hgI0FzOaKTwvgwJZ2skQ-1; Thu, 28 Aug 2025 16:51:52 -0400
X-MC-Unique: Z7hgI0FzOaKTwvgwJZ2skQ-1
X-Mimecast-MFC-AGG-ID: Z7hgI0FzOaKTwvgwJZ2skQ_1756414311
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b612dbc28so9258045e9.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:51:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756414311; x=1757019111;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TWFVCA1eidbRWe4Mvk+B7obYKckT+mqN7M8LbBoJEjM=;
        b=DrZX3OVR/CaAO8Ir/jkMaQ5IJ2jUaZZVvVgcN+4m+sXx5A5kzhM/XGBcfTqcEksUsv
         VHe8LNrh0ufgiO9wv/aa0szGFFpXQpUVHSP4WYnh3KE1evTVu6qWintbFNeoFUtyv0xa
         vqGK5vsfXbTaUzZRYVNM8CaJHdjJslsSk92AjTU8S+ORUPtwNNRfrEUqr6nhhXdrzCmE
         yVEWh0lVbSK6OG5FqDa79Cfv6z26IkTE2eRFaMAtyesrnUbCC9vciHDC4FcNG0STBUmO
         75+a+obiRFqSUsKZSxqlPZhlCJtOfnuJbXh+P+uE/OppHwSgqyQQpOZHTDFks5xTaCE4
         8juA==
X-Forwarded-Encrypted: i=1; AJvYcCUTPuDaYywjEurYfP53uXtPSkGBNGuPBl1iMcX4551ZkYjZFIyfvstge1WqlMF90B2xikcZrBvoAw==@kvack.org
X-Gm-Message-State: AOJu0YzkQDZqZ9UgY/YjHroQwZFHmwUt2q/pTJLfCeuPE3QL6IVt0fv/
	ZkIe5VEWmoTvxCuclK/J6b7vpPYuCCvMUYsr0XfDVy9CXIHPhZi0JGulGZ3BXm2tsKkvGzohNrF
	pjj6kgOsnaAkE8MO5tv67yX8LRTQ/9cYlKtQ3ueCSXzLNHcLYJo69
X-Gm-Gg: ASbGncumgIiLpOzzUlm3Kr+WY8Tx0LHFT4vRIqvLFTHDYS00kB01U+/qa0MTmb1eLA7
	6NKEWrRiU+PKcRmtsFSJM1r3MQ39PdxotA3spMlK+kA3bsY0h3qitK3h2EaY72LWkPqrgrwLOsz
	mRCYvr10vKteX+zYaLPTot39Hztwv7hlkYu01n1fUGTnFkmJpy15rt2xmJfOISoGZlrhs3ncyY/
	nFomgtrmu909kt9tta2g8EJIssXURy0RJES+594m7wdKxoRTqidKV38jk3ClFDTQmxBkgT+eb4i
	KWPMJMsdWjvR/Tu9YIOG++4R3FWogJH/aqbLhknK5g0AKIsY3aoiewO7ZZm5z001t7TY108BckV
	ATl8mLwzEfi6gWs/m46IBCO0emTDPZpmrq9WCN07V4Hx+KQ4+iEDBtS+8P4rzzsu8v6s=
X-Received: by 2002:a05:600c:c491:b0:45b:4d47:5559 with SMTP id 5b1f17b1804b1-45b517dadd6mr212975935e9.36.1756414310776;
        Thu, 28 Aug 2025 13:51:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEBxEpIi+OizhCOrvRivNgDFtglg6ujTEy6gKjCh35xHRfgibjOrf5BEosBm4/LLfFcliwoKA==
X-Received: by 2002:a05:600c:c491:b0:45b:4d47:5559 with SMTP id 5b1f17b1804b1-45b517dadd6mr212975405e9.36.1756414310334;
        Thu, 28 Aug 2025 13:51:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7df3ff72sm8506805e9.1.2025.08.28.13.51.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 13:51:49 -0700 (PDT)
Message-ID: <2be7db96-2fa2-4348-837e-648124bd604f@redhat.com>
Date: Thu, 28 Aug 2025 22:51:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 20/36] mips: mm: convert __flush_dcache_pages() to
 __flush_dcache_folio_pages()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-21-david@redhat.com>
 <ea74f0e3-bacf-449a-b7ad-213c74599df1@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <ea74f0e3-bacf-449a-b7ad-213c74599df1@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CGEZc-yrGs8oHTLO_ivos4EpuPvu5dNgZbFkArygOGs_1756414311
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A0C85140007
X-Stat-Signature: zxn6qx56hq88zqhj1wwx9sxn76y8qcha
X-Rspam-User: 
X-HE-Tag: 1756414314-773045
X-HE-Meta: U2FsdGVkX1+QOhTYBUkGOsMn23BIShZi0JTJ5gTYwrs7oWM19y69iF2zfbID6oqq/Hkb+9B744xC15RqmjGyaFQmrJURgW0kQinv1fH8RaVx6XvgQiOmRho4T3Mk2+lj0JZluk6mbv/NFJBa7Qv6vzFjmSs/25Va8AQDLsyhWklwofwZFjx+1C9X9L2kaZXfPez2rFNpDh7vjX0u6HvN7dlYMuxhz2drfj0JUHhEqjhMSrJa7ux8Kpu2nWMzE79UCfaR7kTqluo5A+XKJwo1iE2xgzAnNa3iQYRFO7OFA8IrOaBVF5pHrrx+RFK3hW2hBXpByScERdcRscNgMxClqjLw2tyNm63shZQjaF229XFsEMA/+Z48KOrS7bIJ05Zynxgpwuz68MqrlTw7uc3IJr2HPzNSwMF855wSTHhtoxmdM/bPVfhnstqlwD8AcFn6/qCtWnKLxrM+Uofq4a9i2n6fLAzZpPLXbeEvhJddD4//W2VDk+mn9tCdhr6l8dQ5X2q7YiVmLYwwRIGHl/XuceVIQcG+HvjbldBBAJ0BOCwGZUMf3uBSUbxL7CsCgBb2GZ4Mwo09J3NHg/qkvtlWKR3nsU7RFtLKKtvQS7NWTLrOuEKei2J0ZMs8RT+h6DdQQYu2BGg6/QdPBz3XockI3NJI5F5S56z5I9UFt4N7zLY11mOZd15xwwbtCor6MXrlgHxyZ0GxLd7fj9jIn15akASXHPg/kf7Zxl7d9c2Rvyt/0nJbeKBsHTs0STf77uq2x7ISWi6BuY1gHsDpY8aVEvKcjOrwDWm1ejykQw+WtbXwhYMhP/KoZs93AkGfCILD+UuwefgYhoK6nxi2/zCNJZ3OmI1NKBvXxa1ipT+uTRtbAWYEtG4nxzF0YAfCJ7yejVvzTKimp0JdZVntxD3wwf30LLGumwNAhKSP1QnpgiPNnXdOxQL+M75E8lpSquFrnfW/vSXS3btL7ktS0Bb
 ptpsvU8d
 qEX3cEo11hmcy/ngL4JDUBm5gbrvFzcRH3b0wiizxKfhEH23vgrlfknq+Z5WqEcoSZ3/wqKMYlbQiN21T+M2Xw2+GAkGroHOEF0HY7Zp07SyJHkEfr7ce0GCg4V7n55UUyFBwN/vaSNb8XVYRpjEvrqCpsshrI8bHW+lx/QyztqPwq2vb+yFsMqoTvXje2EufoFUZWPwAQnWjCRyqLqQO5zWkNOvKQFmCHpQEb0TBUeMZn5Nk4ejYuU8jeSeJibko7iBzpGiyzLyhd/Nrxyw7NvgGJyLuzi1axzwLY62XiQeIkFJ0BZgk4zKhx9kLD2WtcPiXdoGt+alr8+7zwgZSBzLc3IexzQjMpeAdWk7Viq4JaUhwp08zVYZ42kGt/VK+a9Vf3F3pmnqWTXFFtNDUm5z3dR+dGdP5ZvgAWhZRGpZ2aeswalX2q1V0jtqZOOCwCXMopGW9g0lLhGJq2tCBsB/PYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 18:57, Lorenzo Stoakes wrote:
> On Thu, Aug 28, 2025 at 12:01:24AM +0200, David Hildenbrand wrote:
>> Let's make it clearer that we are operating within a single folio by
>> providing both the folio and the page.
>>
>> This implies that for flush_dcache_folio() we'll now avoid one more
>> page->folio lookup, and that we can safely drop the "nth_page" usage.
>>
>> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   arch/mips/include/asm/cacheflush.h | 11 +++++++----
>>   arch/mips/mm/cache.c               |  8 ++++----
>>   2 files changed, 11 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/mips/include/asm/cacheflush.h b/arch/mips/include/asm/cacheflush.h
>> index 5d283ef89d90d..8d79bfc687d21 100644
>> --- a/arch/mips/include/asm/cacheflush.h
>> +++ b/arch/mips/include/asm/cacheflush.h
>> @@ -50,13 +50,14 @@ extern void (*flush_cache_mm)(struct mm_struct *mm);
>>   extern void (*flush_cache_range)(struct vm_area_struct *vma,
>>   	unsigned long start, unsigned long end);
>>   extern void (*flush_cache_page)(struct vm_area_struct *vma, unsigned long page, unsigned long pfn);
>> -extern void __flush_dcache_pages(struct page *page, unsigned int nr);
>> +extern void __flush_dcache_folio_pages(struct folio *folio, struct page *page, unsigned int nr);
> 
> NIT: Be good to drop the extern.

I think I'll leave the one in, though, someone should clean up all of 
them in one go.

Just imagine how the other functions would think about the new guy 
showing off here. :)

> 
>>
>>   #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
>>   static inline void flush_dcache_folio(struct folio *folio)
>>   {
>>   	if (cpu_has_dc_aliases)
>> -		__flush_dcache_pages(&folio->page, folio_nr_pages(folio));
>> +		__flush_dcache_folio_pages(folio, folio_page(folio, 0),
>> +					   folio_nr_pages(folio));
>>   	else if (!cpu_has_ic_fills_f_dc)
>>   		folio_set_dcache_dirty(folio);
>>   }
>> @@ -64,10 +65,12 @@ static inline void flush_dcache_folio(struct folio *folio)
>>
>>   static inline void flush_dcache_page(struct page *page)
>>   {
>> +	struct folio *folio = page_folio(page);
>> +
>>   	if (cpu_has_dc_aliases)
>> -		__flush_dcache_pages(page, 1);
>> +		__flush_dcache_folio_pages(folio, page, folio_nr_pages(folio));
> 
> Hmmm, shouldn't this be 1 not folio_nr_pages()? Seems that the original
> implementation only flushed a single page even if contained within a larger
> folio?

Yes, reworked it 3 times and messed it up during the last rework. Thanks!

-- 
Cheers

David / dhildenb


