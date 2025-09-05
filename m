Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4428BCA1015
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 11:38:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A429E8E0014; Fri,  5 Sep 2025 07:38:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1A878E0006; Fri,  5 Sep 2025 07:38:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9097E8E0014; Fri,  5 Sep 2025 07:38:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FAA88E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 07:38:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4C0914011A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:38:42 +0000 (UTC)
X-FDA: 83854999284.04.E79ED94
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3515B40028
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:38:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SAtz4rNY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757072320; a=rsa-sha256;
	cv=none;
	b=8OTDqyE4bdpOwe74GuS0vdTRncwgWGtyplcfdcwtv9o4GH8QYB8JbjnjJYqsNmnefatgIw
	AXx2KDCn/xqw1dvF5bSfsyeNV+HNttPmfrTOtSaTEgQGitsC5QXwKyIkZjAF8pUPNxV2B8
	bWeXFpwDs3an2UsvX3lx5Akhm/peHc4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SAtz4rNY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757072320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=luQGhz3W9bQvvWBMkQH/XO40AxL9T26r0ebxy/p3+ys=;
	b=XtKhVditRoGYntPASsCaI9lAu3AjiJbOOwZL7FPaQymHq7K/C7YFH8GkrBCLAYvp9J/ljN
	5MphT/WAD2bt8/8COCv1A/r3BH99JPng6NNzWsBd00Utc9Xv2XI/RZtSFsNgZuH4FAPwpo
	N25JQgdFtq+ep86QV+3PfTzUGx+P6DI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757072319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=luQGhz3W9bQvvWBMkQH/XO40AxL9T26r0ebxy/p3+ys=;
	b=SAtz4rNYr7w0xIU/eORxNcydcn09buyBgdrIjsws6k4FTEKWITdv/RG7E8PisbwcxKQk27
	VTA02f7eYOvqG7RR7RmsTkN8/7MvUpN5OOpWpbc8bwPhFjpteMggqxLXE42DYXsVyP3l/X
	ddDE10dEkaZiHq9pSW+k0TH0VBdA598=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-IG2ajy60N2aiNbleBdL3NA-1; Fri, 05 Sep 2025 07:38:38 -0400
X-MC-Unique: IG2ajy60N2aiNbleBdL3NA-1
X-Mimecast-MFC-AGG-ID: IG2ajy60N2aiNbleBdL3NA_1757072317
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3df19a545c2so1305489f8f.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 04:38:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757072317; x=1757677117;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=luQGhz3W9bQvvWBMkQH/XO40AxL9T26r0ebxy/p3+ys=;
        b=ugu8ija2EaRET1aayV7bQA7OEXP6niDePjH35iDCu583cOnRbjXjIwvvuoA4EtU7XX
         BNlLtLf3Ee0NUmfVAa2o4GhJJHzYq9htbQaQWMiHOCK1vDNt3HkUwgNMBMdrgI3Ho/3s
         6eJEXSZXCbG8BPAbB2o+o7It0/CSBoKR2hhDEKWNovyntQNSFn3zGz6pYhLh4aEIc5od
         C5ORJok4w7fh6lyT6VcjAd8Etoa0Iwqa0lC1WnZuF5t3ui+lBxo30rob+HLbEyBdwDpa
         at7AbpxzOFAZl0CK0kCvpRULsJysUZXKn6KAPFQINDJ8HuX1qvD0IXEmQ1iBSdmSD4is
         XPww==
X-Forwarded-Encrypted: i=1; AJvYcCWWaO+ZIORsdP5NUU85q+jCuwbsSH0ebL+9uqeaAhFDjGH060LhmQrrr++3LZL24JPByG9FbYYpjw==@kvack.org
X-Gm-Message-State: AOJu0YwKJo6GAr47YL6NYH2Dz026J4OYgijMbPsz7ww+Xiq4UMymVde0
	KtQjKTTi4NBOgBWBF283tomV78hs0HQxIMMvBnXrIaNpTSJ0/9awxv/M8dhevbf9ltzFuxAQ2PN
	zOBzRkb/K81wPxi32zXAm9p4WogxdJqvROV8wNVdiM2ZQHxBsv9Zd
X-Gm-Gg: ASbGncurnn/WrMJjrfwW4mWwOFrpFHHxc7A28+kj80x7VhYZ4lohqv4RSpGMymCJIrN
	NIAv2LVJhzUjyB6FeC+O8mNHEAisT8sfK6SoB3GU6kIiBDM3MJIb737diJkF/CRaW7yE8J9ve2p
	5+10UDOmnGmWOSvoZ5T2epJ5FgL/cJgTfKpgrMleyMLkXme4Hvt7gW0mtUTyiSvxv9j2x8q/yUT
	tIPd9VJc1uKH0KYmtGNd5Zgz/7bHrViOsGb3Qa//42r6LW54uSFIH/M8kTKGJlEKgU5fYAFzA3w
	agWnGm1nH/kY/bkK/eS0/bmuOPGnOwL/oSIcpYtdHa5ER/Bi8CU6yGL1Uk9T8bzH5cErQWAUwaS
	YUHJZNTZMn4sNF6nvMABSy87iRicsm65Y+tmFWTEr9jvY/Audq0Aq5Fsx
X-Received: by 2002:a05:6000:1789:b0:3e0:43f0:b7b6 with SMTP id ffacd0b85a97d-3e043f0be07mr5028719f8f.52.1757072316809;
        Fri, 05 Sep 2025 04:38:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFo8MNleTLRHLacoeKcQ93i9Gk8ZDv5dPOPJ5nfQMIibIGfmFimYQBfp9bCIqgP6uhYUdcj5w==
X-Received: by 2002:a05:6000:1789:b0:3e0:43f0:b7b6 with SMTP id ffacd0b85a97d-3e043f0be07mr5028644f8f.52.1757072316181;
        Fri, 05 Sep 2025 04:38:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4d:e00:298:59cc:2514:52? (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dda2021dfsm19061165e9.24.2025.09.05.04.38.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 04:38:34 -0700 (PDT)
Message-ID: <9fe9f8c7-f59d-4a4b-9668-d3cd2c5a5fc9@redhat.com>
Date: Fri, 5 Sep 2025 13:38:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-20-david@redhat.com>
 <5090355d-546a-4d06-99e1-064354d156b5@redhat.com>
 <b7544f6d-beac-46af-aa43-27da6d96467e@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <b7544f6d-beac-46af-aa43-27da6d96467e@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DNndu6ol2z9jMWV7iKfjmf6ZQU9TL9dHji3gPRVAiSE_1757072317
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 3515B40028
X-Stat-Signature: pinn6gh9txnwkj6g7zxicp5gbdurr98r
X-HE-Tag: 1757072320-970773
X-HE-Meta: U2FsdGVkX18zW95+fnjDmTxxL7zsQZ7y73YNJ3aiVIgaISUGGQLry/B6A+vqWC2bHD5FJlEV6Glj82JUvP6iGeWin2w5S6MEA2noI1JrVqdWF2BJHGrDYzY4OhBle3D4so5sx/xbOBhIFSMvc244c+xCKs+iEeYIiYT4Ggy0pLetCGM4upmbzwzrASxmO7sMrEHezPdiJhCLbFRsf+wkrdunK7dm93OnU08unr6TNvXmRllpryc0MnOS9hWDiSdV5uKWz4TuzNR9BJwTFHr5Ns+cKHwOeeT8m76MwmVGyIMo3T6ylW8/W7nQVyZJvEZSausZ5J/lh/wccUYbTSFjKzdqUiRUsKxphrOrJ0Isy67sqpsTNNkUj5cBLQy16x9se0qoXm3OFLCi5+KGpXDVp9RO6PeAC28X7CX6P+gZKANivPZKgqc6tSmiNDsnQrAtIjISH2CJYjpRQKIhzBUHYBO/6KDJkte08D55/TRBIh9YSU1hL3ED06oJIu7spZaMUtJKhSSiThuP4k7GDlAnr200DgDbN9Okje0GvUgLoheMSB7h/qXXr8iQvg5OtlzG1ZseT7Dr2BKoHPOqcdqnTm3TaIVAHkdFYzNCBjrh02mq8BBaewg8J5153+4vH9PA6avwUx106+f0zRzffagsBk2lszUKhJ2tJfe+zAr9Gfd+foNBknbgaYZIT7TGoAl/JBkd30JOo0hdDE/LfAhzd9wXsf6sPQXMvLsmEbOfVEut4RvIdbEzjHcfaPnBaYcSxEodmxOgiYPPVNwrXl+G9TTFwbo75IcQAZot8Pn6HzrNltdme25h0+EwxHx6VZloPxG70hf3ZX3uvYugUDwaYUKSDgIfOejV2f1wAM4St1xMyc5ESeJl/SULYPk9ezpml15XejaTP2F0f1nwHVp9RMES2VPf2ZsI0W59OusPZJu21p+I5PvyapXNNhdYxBj3ex/gAAR0ZZFfcRpKM/R
 St7pHeDX
 7OxbVJIjdFv3+XOPRO7E8oZV3/xF++pDeYYNHkiu1l8FEN4zTyrXRs6Lcs0KjxK4W2CaV6Tt1pVesej9wsaqAuzVjMzbhPyWAKW0hlTFhzWSteV+uchtukEmDR6EbTNOy90gui0QgXpS1GCslGd0VBTDGb+EvQx+Ot3VHlgDa04hkP37/4CKWPuCDjKUaF4HwIZBL+YjpdtR00mASRxIg3kUmWX5QSsvmiIAt1DzefNM5ZePqhirMwaQuves+Vzjg1RzpJeF++3TDIyd2dyIWObY9yWGALxt/ilR3MoAb7z5xYw8IM5XnbDkQIYz4rWoc34ZMfI3GByF1dzmVuNTVBBKxjzhef4/oIjYF3WO4rWgtoJUu9KJ50q1auoYKIxjmkLX3M+yoq6ByTVkFfxjHPo/VLvrCBFg6O+UHLIzk99ccOxkEtctsgsQXqi3VL33/9vLRgJsWZo5h8EN9rcoHOIBNnuRfWaKBvIir4LKcQ5X6cLk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.09.25 13:34, Lorenzo Stoakes wrote:
> On Fri, Sep 05, 2025 at 08:41:23AM +0200, David Hildenbrand wrote:
>> On 01.09.25 17:03, David Hildenbrand wrote:
>>> We can just cleanup the code by calculating the #refs earlier,
>>> so we can just inline what remains of record_subpages().
>>>
>>> Calculate the number of references/pages ahead of times, and record them
>>> only once all our tests passed.
>>>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> So strange I thought I looked at this...!
> 
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
> This looks correct.
> 
> But.
> 
> This is VERY nasty. Before we'd call record_subpages() with pages + *nr, where
> it was clear we were offsetting by this, now we're making things imo way more
> confusing.
> 
> This makes me less in love with this approach to be honest.
> 
> But perhaps it's the least worst thing for now until we can do a bigger
> refactor...
> 
> So since this seems correct to me, and for the sake of moving things forward
> (was this one patch dropped from mm-new or does mm-new just have an old version?
> Confused):
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
> For this patch obviously with the fix applied.
> 
> But can we PLEASE revisit this :)

Yeah, I already asked someone internally if he would have time to do 
some refactorings in mm/gup.c.

If that won't work out I shall do it at some point (and the same time 
reworking follow_page_mask() to just consume the array as well like gup 
does)

-- 
Cheers

David / dhildenb


