Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2272ECAC580
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 06:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 557446B0005; Sat,  6 Sep 2025 02:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507C38E0009; Sat,  6 Sep 2025 02:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CF588E0003; Sat,  6 Sep 2025 02:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2A2B26B0005
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:57:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5ADE8613E
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 06:57:06 +0000 (UTC)
X-FDA: 83857918452.09.F3FCDCE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 30AD740008
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 06:57:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Yk7LL9Dd;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757141824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vne0EVwrnVHw6NJLJyd+zZpE6+oJG9x8TCUx1n8W1nw=;
	b=z2MQhYXdQ/BbgpSVo7CNT/OfE0a/59+vprxWJzYh1KjwFxyzq0THqQYN1bSK8X8PpzKltC
	NquVcLnsdINdmk9KekG6cLFn4+wQIb4JOGecXD1I3anYNQuH5qvoaOVLLwi1W2un5+G/c8
	KBQOocmtQu4eRedZvUUSH26seHZLSq8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Yk7LL9Dd;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757141824; a=rsa-sha256;
	cv=none;
	b=PgbuHJgVj7iAU4LTP7csnL07ajW2DoFEK1j2CI8WLprCfV0+kE1cy1PfVK0lPAAJizcV7T
	FeAd3m/efR6FaN2iXBfRKYjMO7jsJceIjXb8kwMdpXS7+/Yfe9Fmb53Yl+Cq0LamxE9G7h
	wHZ9+M4hbGswg/ajXMiC3XUb35Em8uU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757141823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Vne0EVwrnVHw6NJLJyd+zZpE6+oJG9x8TCUx1n8W1nw=;
	b=Yk7LL9Ddbsa1QtzTm4pq3t+uxP0rib6xILc1i5lVUCPchHpJHhlhd7FJwMNxgqR3PpppuR
	p+GbBF2GNIQxpLfrSj9VGiVxJjQVIFJIAPuXVoRAlgllNWZZ7A2mjfPCNSUFz31S3CrVsk
	TEii+W3Hl+8ofqpmGdgrsAUdG5xZZXc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-676-wHabLxWIPE-YmR1iUbAYTQ-1; Sat, 06 Sep 2025 02:57:00 -0400
X-MC-Unique: wHabLxWIPE-YmR1iUbAYTQ-1
X-Mimecast-MFC-AGG-ID: wHabLxWIPE-YmR1iUbAYTQ_1757141819
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9dc5c2ba0so1415309f8f.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 23:56:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757141819; x=1757746619;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vne0EVwrnVHw6NJLJyd+zZpE6+oJG9x8TCUx1n8W1nw=;
        b=ojnm1JmoLlpRvmQ0aXTgdBuX4U42HzwFncTWJyuNteaYtkO1kDhDmP5+VsC66XfMUI
         O2r38djOmDSXqMnWwvW/lrF/wIZaJR6jwaM54HJAZm6+J36xgKbupODOoZw7U7QSNzve
         yx7+nH++UzpUOkeZen1ygqdrNZUDT8L7l+QNltENnKvPutf0lJH8p4Qe3qctokkj5g4R
         VpGk7Fif6vGwDT9NoRI54PGRs8jNAGSBb/CGfoQ2c/irIzHkHyvBoOib/xGJr1Xt1Ni9
         iDZ2O62Qc0PYN/3lnpSyLsuMnFlKpiJF1QioMaQuPPNEumRQxque9QYwGSA3brx7eRpJ
         W2Jg==
X-Forwarded-Encrypted: i=1; AJvYcCWQLjR9Zgdi6Eiiec2eiAurAdvwYzFRNmjse2lvmTDHtVkpHr/vzJwox4v2J5D36LKUrdj2TzaqDg==@kvack.org
X-Gm-Message-State: AOJu0YyasZyNFmw+LyX97Szjt5kAi7lkDTtYuJaUKYMlydJcURVelHb2
	UlWvHMjZpu8JyO2qFs6G6X2qoyz59Xwq8SFb9LeXgWvMJlWxdCDPIw7zvFkHyWWbx7b4xE2BGI1
	0vtJWJd7llVdSsIhaiYXc4FouFHaAR4YS5nCKaztOOtGg8ghJGuKx
X-Gm-Gg: ASbGncumQLy4Jgz0zuAHd+651iBUHi+zEyohfxEoeDANd22wkN3QzIK5l5wvOCVuVj5
	gdtWkQYKPF41maze+o4Moq5OXklRk6f6WyBvPjIbPlm0pTVhTJmUNkYnQCSpFnu3FsbIsVHyRfO
	Sdpk+7v2lOM9LxGpqNRa4GWmA2R3gS+SfXhvoGDdwfK9S00fOJvmXuMVg22i03oOUfDvg0kwuHY
	qk/oqXo3bfpyYboMokq4+l4pW+sVtW8sdx0teUO3sHcq0kizyI/m2EgxrT/T+FpTzZZ6lalx9Na
	wcytE7Es05+bOC8VgvdCQ1PvrQNXJesBi/ficXUgUZuX8rw6vBRuLdRtaAW64bUo6zjU6l1qgqD
	T0Kg0BwEm/EDsAWmTniq47Etx6lAEY0+ik1rWfOBuNenXpxMwqb/+xNqRa/1h0nlmMq4=
X-Received: by 2002:a05:6000:4406:b0:3e7:404f:6b9 with SMTP id ffacd0b85a97d-3e7404f0ad9mr25530f8f.24.1757141818670;
        Fri, 05 Sep 2025 23:56:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTOe1nfTlzU6tKtOOERnuEGL0krwza2F9vwEf5QifLuwYgeR9BVKfnULAEyM/P+fsTi5oZpw==
X-Received: by 2002:a05:6000:4406:b0:3e7:404f:6b9 with SMTP id ffacd0b85a97d-3e7404f0ad9mr25486f8f.24.1757141818148;
        Fri, 05 Sep 2025 23:56:58 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f30:de00:8132:f6dc:cba2:9134? (p200300d82f30de008132f6dccba29134.dip0.t-ipconnect.de. [2003:d8:2f30:de00:8132:f6dc:cba2:9134])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3df4fd372ccsm11959114f8f.32.2025.09.05.23.56.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 23:56:53 -0700 (PDT)
Message-ID: <85e760cf-b994-40db-8d13-221feee55c60@redhat.com>
Date: Sat, 6 Sep 2025 08:56:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
To: John Hubbard <jhubbard@nvidia.com>, linux-kernel@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, kasan-dev@googlegroups.com,
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
 <016307ba-427d-4646-8e4d-1ffefd2c1968@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <016307ba-427d-4646-8e4d-1ffefd2c1968@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8tQEtMIMf-4j790kuSKrGWB2cUL-EZaDqWCH01gWhkY_1757141819
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 30AD740008
X-Stat-Signature: aca3dri66yo5q1pu7wmum7k83f7sn7p1
X-Rspam-User: 
X-HE-Tag: 1757141824-186036
X-HE-Meta: U2FsdGVkX18AD4W/kFfR778sJmRfZYpGRMYP1D2x/oVOKy/rQPG0R2j2650EBp4OvCUK5BJ975yCSmK7/3Py8qBchzURPC8oDy623k+ZEldql+oAN9ciR44ZRjVWYElKjSE0Yj/gx3uNx2Z5l0S0Idr9Lz5SMnK+i6HPmwGng7aBZ7JEcPnWbzlnAJIHS4z5kyihNnWHYnenCscJUzuvAy0MSGROLxYka3aAlZKg78A7LhsH+tAzaovKQBiIAcmoJM/MUQ5TgRy+rGhEPz14L09TyZS/nj9OpGH1xKgEYVeTvc/tu8GbOsiTHL5ENQxm7ABBGe/Y+gNorjkpth7pWaySO6HnNDyx/Rxb4k5q8/LulOC5+xzABz4EAAsfSTNiSVWKaTix0Bd0FBu1CXpJ2Lvv0IRMKf+a0aMpUA8cl67AHIhKju7v4SxWMdXL3Hu9PuiThEiVDHD/uA1DvLRKhcfEckMZLC3C8CSx/0M5Bv/Yez9pdvool2DyznAIlsfNs+V4/mlDODUTv7pIXqm6Iud+mLyjxBv0nSN5HZ2arTnFytrTKE2NsUH4vlljuI/XJZo6PosUkad8Jcg0aoeGm/bPlSjxSmalIQ+aBNp5khqCW8+cTv6atwPRmT7MCfov4B3HeapYUtgcf3NRp6okBSp2ZLqonY3oJdXNlHLCS2qSX0ww5U19ImVyAd8WdXie9k8FyK2ycMUIouh4neQ2RxYiHr0sqEErBC0gKp1SnRdZSYHd7Usy7LSkdGSBToOgPPK9u6UHA6D8nuKw/YyYDkwN3iSvrgK54b98GWgBpsXRo//EHuGLu0dEKuk99cN1U8joBZRZTX6TBlITvgZ3RFM8Uws6VIHQ+/abBjOmfURcDamz3N9XaOp9qshNk7qoH7myzljhv2nnAqhZnmd8d1pjFWdrFiykb6Jk8647Dsn/TuRXW5iSM08do2k0SGiAryaQCGzM+RGw/Jeeq/x
 2I7LwnJe
 jeByRBXl9QgEOypkqYqF4ivGmRj0nwFoaYiigpbYZ9G5jQwEUUy1/hDDFyaZ2I3OZbxCQ6kD8xyv1/1c7kmebzn/XZFHik8huIpdbyjxlxyQHSifQxmzEtzbdkOi0HIhBcK5nUBezGwUk3TN3/2wNX+1YgZur4K37TP2j9xRtAQiyASXBEJmMTnlMp8FA26EHq1Vsv/9lCt1WZQP+cPcr9k1QJuzs4wvPo3hSm4Aawpf77LTB1BA01VgGdzmY24KLxR6RXKeVaORjw0KsDvNUvTXI63KiYlw/B4sVrvVhKG9AyAWhiU5lzEAu3ilg6jjBXJwL1GHZnzOkSX9N6NH+T67rmijrGVht8twTXwseBsBQiVjhhXk/2KlI0AmddloOPBPzI1DSak72aGikEQzSBHk02e82O10Br+psNTaIq/OFnAtETWSaoVkRPYArONRMdIbYEP9XBU60h9ckH1paqW561A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.09.25 03:05, John Hubbard wrote:
> On 9/1/25 8:03 AM, David Hildenbrand wrote:
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
>>   
>>   #ifdef CONFIG_HAVE_GUP_FAST
>> -static int record_subpages(struct page *page, unsigned long sz,
>> -			   unsigned long addr, unsigned long end,
>> -			   struct page **pages)
>> -{
>> -	int nr;
>> -
>> -	page += (addr & (sz - 1)) >> PAGE_SHIFT;
>> -	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
>> -		pages[nr] = page++;
>> -
>> -	return nr;
>> -}
>> -
>>   /**
>>    * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
>>    * @page:  pointer to page to be grabbed
>> @@ -2967,8 +2954,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>>   	if (pmd_special(orig))
>>   		return 0;
>>   
>> -	page = pmd_page(orig);
>> -	refs = record_subpages(page, PMD_SIZE, addr, end, pages + *nr);
>> +	refs = (end - addr) >> PAGE_SHIFT;
>> +	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
>>   
>>   	folio = try_grab_folio_fast(page, refs, flags);
>>   	if (!folio)
>> @@ -2989,6 +2976,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>>   	}
>>   
>>   	*nr += refs;
>> +	for (; refs; refs--)
>> +		*(pages++) = page++;
>>   	folio_set_referenced(folio);
>>   	return 1;
>>   }
>> @@ -3007,8 +2996,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>>   	if (pud_special(orig))
>>   		return 0;
>>   
>> -	page = pud_page(orig);
>> -	refs = record_subpages(page, PUD_SIZE, addr, end, pages + *nr);
>> +	refs = (end - addr) >> PAGE_SHIFT;
>> +	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
>>   
>>   	folio = try_grab_folio_fast(page, refs, flags);
>>   	if (!folio)
>> @@ -3030,6 +3019,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>>   	}
>>   
>>   	*nr += refs;
>> +	for (; refs; refs--)
>> +		*(pages++) = page++;
> 
> Hi David,

Hi!

> 
> Probably a similar sentiment as Lorenzo here...the above diffs make the code
> *worse* to read. In fact, I recall adding record_subpages() here long ago,
> specifically to help clarify what was going on.

Well, there is a lot I dislike about record_subpages() to go back there.
Starting with "as Willy keeps explaining, the concept of subpages do
not exist and ending with "why do we fill out the array even on failure".

:)

> 
> Now it's been returned to it's original, cryptic form.
> 

The code in the caller was so uncryptic that both me and Lorenzo missed
that magical addition. :P

> Just my take on it, for whatever that's worth. :)

As always, appreciated.

I could of course keep the simple loop in some "record_folio_pages"
function and clean up what I dislike about record_subpages().

But I much rather want the call chain to be cleaned up instead, if possible.


Roughly, what I am thinking (limiting it to pte+pmd case) about is the following:


 From d6d6d21dbf435d8030782a627175e36e6c7b2dfb Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Sat, 6 Sep 2025 08:33:42 +0200
Subject: [PATCH] tmp

Signed-off-by: David Hildenbrand <david@redhat.com>
---
  mm/gup.c | 79 ++++++++++++++++++++++++++------------------------------
  1 file changed, 36 insertions(+), 43 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 22420f2069ee1..98907ead749c0 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2845,12 +2845,11 @@ static void __maybe_unused gup_fast_undo_dev_pagemap(int *nr, int nr_start,
   * also check pmd here to make sure pmd doesn't change (corresponds to
   * pmdp_collapse_flush() in the THP collapse code path).
   */
-static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages)
  {
  	struct dev_pagemap *pgmap = NULL;
-	int ret = 0;
+	unsigned long nr_pages = 0;
  	pte_t *ptep, *ptem;
  
  	ptem = ptep = pte_offset_map(&pmd, addr);
@@ -2908,24 +2907,20 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
  		 * details.
  		 */
  		if (flags & FOLL_PIN) {
-			ret = arch_make_folio_accessible(folio);
-			if (ret) {
+			if (arch_make_folio_accessible(folio)) {
  				gup_put_folio(folio, 1, flags);
  				goto pte_unmap;
  			}
  		}
  		folio_set_referenced(folio);
-		pages[*nr] = page;
-		(*nr)++;
+		pages[nr_pages++] = page;
  	} while (ptep++, addr += PAGE_SIZE, addr != end);
  
-	ret = 1;
-
  pte_unmap:
  	if (pgmap)
  		put_dev_pagemap(pgmap);
  	pte_unmap(ptem);
-	return ret;
+	return nr_pages;
  }
  #else
  
@@ -2938,21 +2933,24 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
   * get_user_pages_fast_only implementation that can pin pages. Thus it's still
   * useful to have gup_fast_pmd_leaf even if we can't operate on ptes.
   */
-static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages)
  {
  	return 0;
  }
  #endif /* CONFIG_ARCH_HAS_PTE_SPECIAL */
  
-static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages)
  {
+	const unsigned long nr_pages = (end - addr) >> PAGE_SHIFT;
  	struct page *page;
  	struct folio *folio;
-	int refs;
+	unsigned long i;
+
+	/* See gup_fast_pte_range() */
+	if (pmd_protnone(orig))
+		return 0;
  
  	if (!pmd_access_permitted(orig, flags & FOLL_WRITE))
  		return 0;
@@ -2960,33 +2958,30 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
  	if (pmd_special(orig))
  		return 0;
  
-	refs = (end - addr) >> PAGE_SHIFT;
  	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
  
-	folio = try_grab_folio_fast(page, refs, flags);
+	folio = try_grab_folio_fast(page, nr_pages, flags);
  	if (!folio)
  		return 0;
  
  	if (unlikely(pmd_val(orig) != pmd_val(*pmdp))) {
-		gup_put_folio(folio, refs, flags);
+		gup_put_folio(folio, nr_pages, flags);
  		return 0;
  	}
  
  	if (!gup_fast_folio_allowed(folio, flags)) {
-		gup_put_folio(folio, refs, flags);
+		gup_put_folio(folio, nr_pages, flags);
  		return 0;
  	}
  	if (!pmd_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
-		gup_put_folio(folio, refs, flags);
+		gup_put_folio(folio, nr_pages, flags);
  		return 0;
  	}
  
-	pages += *nr;
-	*nr += refs;
-	for (; refs; refs--)
+	for (i = 0; i < nr_pages; i++)
  		*(pages++) = page++;
  	folio_set_referenced(folio);
-	return 1;
+	return nr_pages;
  }
  
  static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
@@ -3033,11 +3028,11 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
  	return 1;
  }
  
-static int gup_fast_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+static unsigned long gup_fast_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
+		unsigned long end, unsigned int flags, struct page **pages)
  {
-	unsigned long next;
+	unsigned long cur_nr_pages, next;
+	unsigned long nr_pages = 0;
  	pmd_t *pmdp;
  
  	pmdp = pmd_offset_lockless(pudp, pud, addr);
@@ -3046,23 +3041,21 @@ static int gup_fast_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
  
  		next = pmd_addr_end(addr, end);
  		if (!pmd_present(pmd))
-			return 0;
+			break;
  
-		if (unlikely(pmd_leaf(pmd))) {
-			/* See gup_fast_pte_range() */
-			if (pmd_protnone(pmd))
-				return 0;
+		if (unlikely(pmd_leaf(pmd)))
+			cur_nr_pages = gup_fast_pmd_leaf(pmd, pmdp, addr, next, flags, pages);
+		else
+			cur_nr_pages = gup_fast_pte_range(pmd, pmdp, addr, next, flags, pages);
  
-			if (!gup_fast_pmd_leaf(pmd, pmdp, addr, next, flags,
-				pages, nr))
-				return 0;
+		nr_pages += cur_nr_pages;
+		pages += cur_nr_pages;
  
-		} else if (!gup_fast_pte_range(pmd, pmdp, addr, next, flags,
-					       pages, nr))
-			return 0;
+		if (nr_pages != (next - addr) >> PAGE_SIZE)
+			break;
  	} while (pmdp++, addr = next, addr != end);
  
-	return 1;
+	return nr_pages;
  }
  
  static int gup_fast_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr,
-- 
2.50.1



Oh, I might even have found a bug moving away from that questionable
"ret==1 means success" handling in gup_fast_pte_range()? Will
have to double-check, but likely the following is the right thing to do.



 From 8f48b25ef93e7ef98611fd58ec89384ad5171782 Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Sat, 6 Sep 2025 08:46:45 +0200
Subject: [PATCH] mm/gup: fix handling of errors from
  arch_make_folio_accessible() in follow_page_pte()

In case we call arch_make_folio_accessible() and it fails, we would
incorrectly return a value that is "!= 0" to the caller, indicating that
we pinned all requested pages and that the caller can keep going.

follow_page_pte() is not supposed to return error values, but instead
0 on failure and 1 on success.

That is of course wrong, because the caller will just keep going pinning
more pages. If we happen to pin a page afterwards, we're in trouble,
because we essentially skipped some pages.

Fixes: f28d43636d6f ("mm/gup/writeback: add callbacks for inaccessible pages")
Signed-off-by: David Hildenbrand <david@redhat.com>
---
  mm/gup.c | 3 +--
  1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 22420f2069ee1..cff226ec0ee7d 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2908,8 +2908,7 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
  		 * details.
  		 */
  		if (flags & FOLL_PIN) {
-			ret = arch_make_folio_accessible(folio);
-			if (ret) {
+			if (arch_make_folio_accessible(folio)) {
  				gup_put_folio(folio, 1, flags);
  				goto pte_unmap;
  			}
-- 
2.50.1


-- 
Cheers

David / dhildenb


