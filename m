Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A7F7CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 11:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7A7B8E0012; Fri,  5 Sep 2025 07:28:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A52398E0006; Fri,  5 Sep 2025 07:28:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9680B8E0012; Fri,  5 Sep 2025 07:28:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 85D3B8E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 07:28:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38E2EB6066
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:28:46 +0000 (UTC)
X-FDA: 83854974252.13.1B36841
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id A465620005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:26:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=LuV1nOPt;
	spf=pass (imf13.hostedemail.com: domain of axboe@kernel.dk designates 209.85.219.179 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757071616; a=rsa-sha256;
	cv=none;
	b=Ute2ItoeMWwS1kFJ9Pd3VN7OAOBSCtLABszZ8T6fYIHdw5lWUk4yFjvTQ6WlBLFWNH3o61
	I3pQEc83CqUIEWoDmEY0GQYc1nbjr6i+2u5NiXvVA2M+G4Sor0O2N6E7Lm3iVxFp9IHpeJ
	CO/MJ5ahc27ld5OQpbZ8CDu5+PFLdTY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=LuV1nOPt;
	spf=pass (imf13.hostedemail.com: domain of axboe@kernel.dk designates 209.85.219.179 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757071616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yNzF16PbnrymzXw8XwNj1X2cjJHo1hQQnEraT/RlzJM=;
	b=TWlqdglZD8HjKFcNJ3bCliMGdtEvW3tYgX00W01lbVML/cIkhepu8qLTEYYqOEWi5C4mzv
	55VyGAPgxlPu6lHJLavgSYraBwOVLUZ4IS/lgtoltujm3/vISIEna5yfbnk0b42F7jBcjI
	zYy7mK5YgT+tX/us0JQd7GU4WzfasTk=
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e96ff16fea1so2248727276.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 04:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757071615; x=1757676415; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yNzF16PbnrymzXw8XwNj1X2cjJHo1hQQnEraT/RlzJM=;
        b=LuV1nOPtsk5FDmRkmduQa9FtMHWQLYoN3WkEUBT176J51CrBw4KDyIetHO1J6LtPAO
         s4dcoCCK2pM9TK/oj0zfFduZEChKZ1KAbEYdLPTL9JQoRVAx5pmjI3jwu0UuSsnFoyjj
         jDblxWTDkQiAZvCkeqgM54YtdhiVIiQNIYjUsyw8zJXz39xUK5zcuOVdPLaMVO4o20RX
         4rMqLV47nnqmR+2/LLQwo6cTqk6xuIVljbevp93RIlSjchbfuJhJvMDoSRTL6pkujbUB
         F/lTiv6wrZ2vWqbHOw8YxpZIBHx07fucZsFhC9SamUDy77VHd7U3YndBPcaLttH4eQeM
         Or1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757071615; x=1757676415;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yNzF16PbnrymzXw8XwNj1X2cjJHo1hQQnEraT/RlzJM=;
        b=Wr6khLxrkrTuSQ8/R1/4RMSlwBGjjyk1pL8N6jt+aiyxgGdHJRe0iLvd/ET1mjP4dv
         Yfe+mktuaX07xSN0ZgdWaZ/BCQAYD8Yka2/NZgkJ5m+OD2R5Lngq/Qq/tMpPL4ciygMq
         DoXjsILnoyg1HzyqJRABfeWWVYTfnJW7ZmHe3hmh3yDX5TzHA8OuzVoYsD6D+rfajJiD
         OSQ/w9Sk4Jush0Ecl98vsVL+OmnSBHrEAhZ1aPoy2VDSurJ59pMClNf33ySHKbyNfOyB
         48gFue8zclUMCSGVGjc3/86G9wg57v9dhd4hqhV3XMpPq/20dvlpv6W1xi/ORwUwTw8s
         /sBg==
X-Forwarded-Encrypted: i=1; AJvYcCXG7lTuxr5JXugbjQQQj1XQFONefzvV2UOLjiXRnICbY6xkX7H8EjpHFbuLjiQpdelSXpMErzj6yA==@kvack.org
X-Gm-Message-State: AOJu0Yx+vbCI/dVI5rXLEHxpuDQKATYWuDuuVX/5F02PmT3lNINnSqDC
	BqdUHBrzW4eZznNMArc2Xr7ZvQC0KgiOxnFNpspTulsSQIiRXYMwfGieaNxK/TpJCsQ=
X-Gm-Gg: ASbGncsS5nCcje/GrYJ37pBZmV9jI1skQUjcYz34AWXSyXshJv7voaYiEWZZy4rygHN
	WJ93kHfF3wAHtao6Fu6xfxfaR7ioOkHH2LyMb/Ip7ley5cwv2v9po3BS6zCXN2ILByoQYVcoeDF
	RiF5RO6ha4lrzJ7S+NfiwDxtAJJ9lbWPGxHl9TPIIITHPJ/4qcZEPbY6e6oQt9DYYEKcHlhlC3Y
	OEdbxOeCAlQNlcCzggxUEkAxd6xnGWT9sEn5dtcaqYkP04Lafr+ShAWpOHuTbE+iv0/0kyW32y3
	P6uu0V28FvPPO44TLD8wsIfTb02WFz3PKlFvnr59qhxB0fYVUXsyrW6DyGHM8UYM2Jgq0q8qsVq
	EltCr0iCT00cMqy+HKQ==
X-Google-Smtp-Source: AGHT+IEXVquWXmj0Yd3oyr4uhZoLxM2opNHaeihf8Xp8KBtnXc2guOYW42U1nSR+kmrTjCZ7Op/enQ==
X-Received: by 2002:a05:6902:18ce:b0:e96:fac0:60bc with SMTP id 3f1490d57ef6-e98a58455f2mr22114649276.41.1757071615282;
        Fri, 05 Sep 2025 04:26:55 -0700 (PDT)
Received: from [10.0.3.24] ([50.227.229.138])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e9bbdf504e0sm3031724276.11.2025.09.05.04.26.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 04:26:54 -0700 (PDT)
Message-ID: <1513d5fd-14ef-4cd0-a9a5-1016e9be6540@kernel.dk>
Date: Fri, 5 Sep 2025 05:26:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
 kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-20-david@redhat.com>
 <5090355d-546a-4d06-99e1-064354d156b5@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5090355d-546a-4d06-99e1-064354d156b5@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A465620005
X-Stat-Signature: i9znt5y77gqsbtph4ofzfgmoef4p6ohg
X-Rspam-User: 
X-HE-Tag: 1757071616-306694
X-HE-Meta: U2FsdGVkX190w2God422kwuCEffe+fIqzuKk1ZGnRG/1z3TDog0m82oJyYmn1E382nmwO3qEclSzzLpYEvlBpAJVPghxLz2Y511two0vXSAQZll4gLou+uGOKLunFLXA8dEouDbFsbUAN8tJVKsCl+jZvd71nekvN4XNf/WtEB2HM+b7M3RzrTTNHZrCPKfY2pMXEMkx0z82COsdMbrriy26HSQhd1pI0JCkyYsz+TdRYqRMbOH39lsDOS1pqICzOoQC+o7xDNJE72p1hB2+S74XLZxo85Om/QmMjK0AKHXT84Dry7E+p0BusiKV4lZ1MzfTar36mSbq8OH5HDKF0Ck0x7dSK8HUj/5iW2jNpxThPR4t+3nlkG9avXjKN25n+KdfZ/YwZh2KDfPak8LYoSdXZAO1MsZ6xdyiGEBikIu40jSrPbbenlj5YfZ/j7nu31saEYPXZI5pPC314rpl66hVvF8JN1msL1rFW2aTYWfAbDyVXv47byDgVxjDwdGWnKda1THyWYF8BQWCMGp3ruZDgT72U+rMY0LKaahrBV/brgNtTvGaWh8Q1g9UM6TV+DkBUGdrIF0SkRMJWSV718C11Y433RhvtnuLBRPU6E3cN1eD5wggZlte0WLwr+/JNjICwvXpc9AnUNTSyiBqMdMNbVQSCqcR3C1ZDc/oGx5DNQCwC62JW3MUxrbPaJMz1I+SoWT61bBtpNTdshMk/BwCNmbX2HzzpeY8YU/cGJerHNA1HHuoj68p7ABupBWVLKsCez9ypZq1MTM8e8VlKI4j1bJpMaqRtNdbUzM6CQ4jL7hvYs4cdGOKGzu5e/pD/AIrqpNCyWaV2bxHWxHbPmbXyr2S0TUepfLp7BNcZsD5d4XhKSYdNXDO9XVhJO5Spfy4PP+PrrzHQjot/lSk09g6tz3vmO8nwvZ2qkyFy2IvhlDmYCkgH1lkOFd1SHZGVAFiweMI4zr+EKrkB6z
 bZ8bLhxK
 T8srbN2QM3OXyTn9YvDUdnrCJtwaLz95HeruDuvWYmkPCNO66uRHyhStTQjf0flX0eh5fr+smoMyspRb/Jr2+Uku3er7bCUk9i0f2fnkQhXcoGcU6yvCLKmNlEcn6cpGJgxxYIh9FNmCKRy8KaNIFazogFp9lE4ydFUp6VvQJhB+Uh6a5sd1G/rSg5BwvemXB3OHpGkz1Zji4lFEEoN6IVGQloK6o0k8mFJhHqtBv0tcMxeR6tDfrLX7XBSa6Pan2JSc8zToymdx2znhWZPhejMvLjElzOceorqGF2QDQUxCZm3EWo9QeKwwCMipD/MUZh5abA04YEDGjtJJ9zT9EJgq8Ueg9NEVK6yrvMv2rXnxqYaDHArFNciWawhAjRsvnbR0xi4pLJj2WQcFADCKBIsiKo1DSiEbUbeF05oGG4TJ/mtA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/5/25 12:41 AM, David Hildenbrand wrote:
> On 01.09.25 17:03, David Hildenbrand wrote:
>> We can just cleanup the code by calculating the #refs earlier,
>> so we can just inline what remains of record_subpages().
>>
>> Calculate the number of references/pages ahead of times, and record them
>> only once all our tests passed.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   mm/gup.c | 25 ++++++++-----------------
>>   1 file changed, 8 insertions(+), 17 deletions(-)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index c10cd969c1a3b..f0f4d1a68e094 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -484,19 +484,6 @@ static inline void mm_set_has_pinned_flag(struct mm_struct *mm)
>>   #ifdef CONFIG_MMU
>>     #ifdef CONFIG_HAVE_GUP_FAST
>> -static int record_subpages(struct page *page, unsigned long sz,
>> -               unsigned long addr, unsigned long end,
>> -               struct page **pages)
>> -{
>> -    int nr;
>> -
>> -    page += (addr & (sz - 1)) >> PAGE_SHIFT;
>> -    for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
>> -        pages[nr] = page++;
>> -
>> -    return nr;
>> -}
>> -
>>   /**
>>    * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
>>    * @page:  pointer to page to be grabbed
>> @@ -2967,8 +2954,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>>       if (pmd_special(orig))
>>           return 0;
>>   -    page = pmd_page(orig);
>> -    refs = record_subpages(page, PMD_SIZE, addr, end, pages + *nr);
>> +    refs = (end - addr) >> PAGE_SHIFT;
>> +    page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
>>         folio = try_grab_folio_fast(page, refs, flags);
>>       if (!folio)
>> @@ -2989,6 +2976,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>>       }
>>         *nr += refs;
>> +    for (; refs; refs--)
>> +        *(pages++) = page++;
>>       folio_set_referenced(folio);
>>       return 1;
>>   }
>> @@ -3007,8 +2996,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>>       if (pud_special(orig))
>>           return 0;
>>   -    page = pud_page(orig);
>> -    refs = record_subpages(page, PUD_SIZE, addr, end, pages + *nr);
>> +    refs = (end - addr) >> PAGE_SHIFT;
>> +    page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
>>         folio = try_grab_folio_fast(page, refs, flags);
>>       if (!folio)
>> @@ -3030,6 +3019,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>>       }
>>         *nr += refs;
>> +    for (; refs; refs--)
>> +        *(pages++) = page++;
>>       folio_set_referenced(folio);
>>       return 1;
>>   }
> 
> Okay, this code is nasty. We should rework this code to just return the nr and receive a the proper
> pages pointer, getting rid of the "*nr" parameter.
> 
> For the time being, the following should do the trick:
> 
> commit bfd07c995814354f6b66c5b6a72e96a7aa9fb73b (HEAD -> nth_page)
> Author: David Hildenbrand <david@redhat.com>
> Date:   Fri Sep 5 08:38:43 2025 +0200
> 
>     fixup: mm/gup: remove record_subpages()
>         pages is not adjusted by the caller, but idnexed by existing *nr.
>         Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 010fe56f6e132..22420f2069ee1 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2981,6 +2981,7 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>                 return 0;
>         }
>  
> +       pages += *nr;
>         *nr += refs;
>         for (; refs; refs--)
>                 *(pages++) = page++;
> @@ -3024,6 +3025,7 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>                 return 0;
>         }
>  
> +       pages += *nr;
>         *nr += refs;
>         for (; refs; refs--)
>                 *(pages++) = page++;
> 

Tested as fixing the issue for me, thanks.

-- 
Jens Axboe

