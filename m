Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA8A2CA101C
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 06:57:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 139EB8E0003; Sat,  6 Sep 2025 02:57:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 112156B000D; Sat,  6 Sep 2025 02:57:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1BA48E0003; Sat,  6 Sep 2025 02:57:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DF7DB6B000C
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:57:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 72D9D592C2
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 06:57:47 +0000 (UTC)
X-FDA: 83857920174.03.1A3CC34
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 29EBF100002
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 06:57:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IFSh2Efd;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757141865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCJs31gS3SmY6gT03ZW9SqmlSjC26seB+xyCx6US3Ag=;
	b=ieBtL0JwZ0aocXsokzsrGWRqG4cwb+6HQ4M3hATOFF6D6mfGHGbjxmafPFAEq0LveCksk/
	NwSBS0HEmExQSNV7YGP0dq8+mlogudYLXGBhObt4+f3lmJgSuZupcM8mAD6N7ildbyEhuJ
	rDPPKz7blI3QuIjzyZZHGgc79aDYHHA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IFSh2Efd;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757141865; a=rsa-sha256;
	cv=none;
	b=gpHQqCuIAQKP/i4t2nuqfROUHNgPjJUmp2eP1vqq+Z58H+q6sd2WvcEIiCL6Hdq/SwLmyJ
	CN/uZbb484gzEGQWbp1QFccV3pOWeyalyKRYUroECjDSomYEA3rUnlvkkI4iOAyRmSssps
	m6tsfqHh2b/OYk2m9UmFj7gx6tfiCv4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757141864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CCJs31gS3SmY6gT03ZW9SqmlSjC26seB+xyCx6US3Ag=;
	b=IFSh2EfdGppfeq4GeY0J0xB4q5d+wOrOayF6sliBVxyG0sBcnqW4rqxOEex1cj20LfDUE8
	MrcNNxqEG3zmXnDH272aQRj88zOViWoHuQiSxnLVY509ZoAVY3K1KNoLpyvjrSojHXkq/f
	utwStpE1CxZm84wkN2m4Qd2kzU1WU7s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-yN1yADv9OoK0EWNVS73Tfw-1; Sat, 06 Sep 2025 02:57:43 -0400
X-MC-Unique: yN1yADv9OoK0EWNVS73Tfw-1
X-Mimecast-MFC-AGG-ID: yN1yADv9OoK0EWNVS73Tfw_1757141862
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45cb5dbda9cso17914015e9.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 23:57:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757141862; x=1757746662;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CCJs31gS3SmY6gT03ZW9SqmlSjC26seB+xyCx6US3Ag=;
        b=DD2GCA40IRDrRfJ8gG2dm84W93GBO21uBrUS2mY0NABKQOR9UKABdgT11OGMiRxZQx
         lC74Jziyf4K680HaWNCrdUg2fs+Llsrm8/HntF93dFhtVY5QRlrwaudMwQVbKGlq0exR
         JKXcpU/7BaOIvoTvUrcMhJ5DI2KBpRzZ4yCRBQ3aw1mWWWjtF/byuvEk2EesbXnNc6YA
         Z171NIn8h+FLru0A8i8GfHjUW7r/6Z2dhC6mYqehVuAXv/mGxLMPHjCLWjPtKP4YQG6E
         x/nUVltpMR4roU8lLIff1T2DSYPkUV82kKc4ucSOzoyuL4p31axge98FJtx9IJOKC1Yn
         GasQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHupiNhxOVl5kSrizAfYLnzlFRJmFYu1HnITF+61qJrjNXWaM3cYE8dcKksHGAI8puXqbMnRtT9g==@kvack.org
X-Gm-Message-State: AOJu0YwgeGu3FSWUfCH8BIC91xfH0X3PubO19jmb5drkcl7IlAZ2cIp2
	wohgFVjwh76otZt4Pzgi7KvptEvIqsuU7fWGRSPS+WOxl6yohZ3db94VCtGHjXAey++xOH47md+
	6MJKTIqaqBCWC89C6Kvx55wBfQkCbekQmyH4H5bjqFp+ou4xW4TXt
X-Gm-Gg: ASbGncs6rDWjzLQouBu+eLpG/tOdNQlNiKsjW+RPKhdENwLopjbXF4aVDz/K+T1Ye4Z
	962BmrWbJNT5/RqdUHgSOQFCA/mxp370Lus10k7TBwZgwVzQRQvFha2ZWWeXDsI9A0GzpcEHBrU
	SBbFFc9MmJMyEznY2Kg5svIo5xL6aXWbcqoumLgiAyvEIkOIWTrYkmVuEDKDPVr9flx/UIC8glJ
	3deArXtLim/T6VT75XRpLWOilwFsGQvFEalHDpXxpyWu+dWmLF4IcjnXmwUFH2trICTOsHACuJ1
	aLWQ0aGbBCoQAGvpm5c4zG9VTTmEq36IrISkI6PmSelslF2KnwMm1SX3KNwJmBnOkqihRhnvXmC
	XrcwV9JHF2jLzjvnaTF3dd89MCPgjT9zUcwmkYg3fNHQiE2ZENl32NxV5lWfRbehiX6g=
X-Received: by 2002:a05:600c:a43:b0:45d:d944:e763 with SMTP id 5b1f17b1804b1-45dddef8abemr11582555e9.33.1757141861913;
        Fri, 05 Sep 2025 23:57:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9de71akgKQMTH3Yad6UmnskyHOcTJBFrvjc1jDcnRZYiXZrAsp4/fGMOazHSvHvTFxb0cMA==
X-Received: by 2002:a05:600c:a43:b0:45d:d944:e763 with SMTP id 5b1f17b1804b1-45dddef8abemr11582145e9.33.1757141861401;
        Fri, 05 Sep 2025 23:57:41 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f30:de00:8132:f6dc:cba2:9134? (p200300d82f30de008132f6dccba29134.dip0.t-ipconnect.de. [2003:d8:2f30:de00:8132:f6dc:cba2:9134])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e740369f1esm87090f8f.11.2025.09.05.23.57.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 23:57:40 -0700 (PDT)
Message-ID: <64fe4c61-f9cc-4a5a-9c33-07bd0f089e94@redhat.com>
Date: Sat, 6 Sep 2025 08:57:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
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
 <5090355d-546a-4d06-99e1-064354d156b5@redhat.com> <20250905230006.GA1776@sol>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250905230006.GA1776@sol>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: p5yUkQrvZx6jOxbR9uhGGK0EspWUP0S7TLofBo-z3-Q_1757141862
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 29EBF100002
X-Rspam-User: 
X-Stat-Signature: d3gugj8ejon7eexuzy4z1hen63gqap1p
X-Rspamd-Server: rspam09
X-HE-Tag: 1757141864-149762
X-HE-Meta: U2FsdGVkX1/zkE7dAI2ALQdRYHCixki1zhrCtnRhrLDsQ3S8dP8rDBg105QjR/lL7qRb0TIK+rXTXDd7AocBM2/YvWyj3IEOAtNWkQhrY4rc8K0raGZNCYNQ/MuVPQ93mhbsMulI+q3i8D6x2zmukWDz/oDfcS8AJh5vsghEsm5Gc14sSposjs29LzPz6AvTg5NM6527Z8ZxMAB1Nq1EK77mZ886+Sqe0vkiLHxP0Qyt2nj3qFxx6CwJybwIk2BzW5P2TsS2TVRw2Wml/pDprwSIYuBRXGgDIE8M3n/HAQp3Tj7EbWASMylLo5tYJHvsYJH2Y+UePKBw87euwDVfWSZVueOgCTAHeDB2PTA+wLGv4WCX5w6stdRomYOAq+zsaHEL8jBStr0FAApGTFJN6b/EaWxtSW2JPaMZTzW/7Um9g2uUu5anaR463ka94enZhlWgp7v8XObBnHHZElRwjiB6u8HZ4woS/PUVAdHTBhDaXvBrwPey81nWe8ItpyLo+U8s+rMnHInow/c0T7v5P67n2or5idggH1IZHjBO5+R7Gv2oNTM1Blpdr8CHuQLARhO4K7XaTmXiJXFdmGRbAixDwMiXoZ2/j6cc/raP6ZU35yCFl5B4waiWvN9ubh8PUE/T6DcUtiexy3Ma1HwoKlgvSVnFTnwLHxUrVpbDXhxTz+F+SLZ4Zspgy6gQN+bJi99P4SPHqNgQumPWWVC2/lSs07Cv5ATW9IHLJ1Fg1t/e0TW0dy9ZK6XuBEnZbi18tcIBDGQKJZSSLiPmkITmFjDBWTv6WbzEKSkSYthYcfd+hPy9M8QGqjNJD0QdqMS8py2dXidBlyMORKHS0SydlByoAes7mCwr0flAGEZbRp6CGeICgacxSJb9p7sAgGOfts+WZsprqQYiqWc2wQVk0eDgx1wF7To05lxfyObSfcbMgDyF2nCOagr4iYt/eWZY+91aqzb2tbN81M7gXg9
 kQJlFmGQ
 J3ts9h+iDvlyjDTrBtxD8jZyO63sJ++z34mhW0gQ/q/z7XKZQZNIvGcwmgsUKhWI7NS7/GYDBPe8p9buDMnGnxOUTPQWGK8gq8LakfJ6V094Wj0ClkdzvI/IzKa7kTM8Ml2Hu6yT4hYpTgwE0RL1Tf4R6ze1uNS9qxaRVzgVkWfgcY3z765IGS99m4IelN55OHsWnNZciEQeh66SpsLLT1kVNE2q4h36Nh5EWwiHFkuHNxGtSmfBs2VMg83e93fPggPXnhrcOb0F96k8bKdTmgJ1FD6M8LfmO3WGRLZkd+nXRQ1Ma0YdPkj0wGm/GoTiOXNeFnk2u3XfGnxWOn3sFWT8k5QKZYC+c8pO5p9lAZZ6LUqbUZtB4cuqXLVLOcGCMOTeUzJyKss+dmSfy95ujxnz8WprMKHRJCuLs/JyMaMB1nZr50XvLgUU52RZaD3xqGV/zzasy27UPBV3wfrobsO3/mQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.09.25 01:00, Eric Biggers wrote:
> On Fri, Sep 05, 2025 at 08:41:23AM +0200, David Hildenbrand wrote:
>> On 01.09.25 17:03, David Hildenbrand wrote:
>>> We can just cleanup the code by calculating the #refs earlier,
>>> so we can just inline what remains of record_subpages().
>>>
>>> Calculate the number of references/pages ahead of times, and record them
>>> only once all our tests passed.
>>>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> ---
>>>    mm/gup.c | 25 ++++++++-----------------
>>>    1 file changed, 8 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/mm/gup.c b/mm/gup.c
>>> index c10cd969c1a3b..f0f4d1a68e094 100644
>>> --- a/mm/gup.c
>>> +++ b/mm/gup.c
>>> @@ -484,19 +484,6 @@ static inline void mm_set_has_pinned_flag(struct mm_struct *mm)
>>>    #ifdef CONFIG_MMU
>>>    #ifdef CONFIG_HAVE_GUP_FAST
>>> -static int record_subpages(struct page *page, unsigned long sz,
>>> -			   unsigned long addr, unsigned long end,
>>> -			   struct page **pages)
>>> -{
>>> -	int nr;
>>> -
>>> -	page += (addr & (sz - 1)) >> PAGE_SHIFT;
>>> -	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
>>> -		pages[nr] = page++;
>>> -
>>> -	return nr;
>>> -}
>>> -
>>>    /**
>>>     * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
>>>     * @page:  pointer to page to be grabbed
>>> @@ -2967,8 +2954,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>>>    	if (pmd_special(orig))
>>>    		return 0;
>>> -	page = pmd_page(orig);
>>> -	refs = record_subpages(page, PMD_SIZE, addr, end, pages + *nr);
>>> +	refs = (end - addr) >> PAGE_SHIFT;
>>> +	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
>>>    	folio = try_grab_folio_fast(page, refs, flags);
>>>    	if (!folio)
>>> @@ -2989,6 +2976,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>>>    	}
>>>    	*nr += refs;
>>> +	for (; refs; refs--)
>>> +		*(pages++) = page++;
>>>    	folio_set_referenced(folio);
>>>    	return 1;
>>>    }
>>> @@ -3007,8 +2996,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>>>    	if (pud_special(orig))
>>>    		return 0;
>>> -	page = pud_page(orig);
>>> -	refs = record_subpages(page, PUD_SIZE, addr, end, pages + *nr);
>>> +	refs = (end - addr) >> PAGE_SHIFT;
>>> +	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
>>>    	folio = try_grab_folio_fast(page, refs, flags);
>>>    	if (!folio)
>>> @@ -3030,6 +3019,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>>>    	}
>>>    	*nr += refs;
>>> +	for (; refs; refs--)
>>> +		*(pages++) = page++;
>>>    	folio_set_referenced(folio);
>>>    	return 1;
>>>    }
>>
>> Okay, this code is nasty. We should rework this code to just return the nr and receive a the proper
>> pages pointer, getting rid of the "*nr" parameter.
>>
>> For the time being, the following should do the trick:
>>
>> commit bfd07c995814354f6b66c5b6a72e96a7aa9fb73b (HEAD -> nth_page)
>> Author: David Hildenbrand <david@redhat.com>
>> Date:   Fri Sep 5 08:38:43 2025 +0200
>>
>>      fixup: mm/gup: remove record_subpages()
>>      pages is not adjusted by the caller, but idnexed by existing *nr.
>>      Signed-off-by: David Hildenbrand <david@redhat.com>
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 010fe56f6e132..22420f2069ee1 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -2981,6 +2981,7 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>>                  return 0;
>>          }
>> +       pages += *nr;
>>          *nr += refs;
>>          for (; refs; refs--)
>>                  *(pages++) = page++;
>> @@ -3024,6 +3025,7 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>>                  return 0;
>>          }
>> +       pages += *nr;
>>          *nr += refs;
>>          for (; refs; refs--)
>>                  *(pages++) = page++;
> 
> Can this get folded in soon?  This bug is causing crashes in AF_ALG too.

Andrew immediately dropped the original patch, so it's gone from 
mm-unstable and should be gone from next soon (today?).

-- 
Cheers

David / dhildenb


