Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6EB9CA0FFE
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 13:41:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01A8D6B0011; Fri, 29 Aug 2025 09:41:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34606B0012; Fri, 29 Aug 2025 09:41:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E237A6B0022; Fri, 29 Aug 2025 09:41:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D104B6B0011
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:41:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CE0D13A87A
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 13:41:50 +0000 (UTC)
X-FDA: 83829907980.15.0727611
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7E32F1C0005
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 13:41:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f98+42k7;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756474907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ZezTDYPV9FY1vYbYIlP1Z79qo+TmLw98Vo74TFiYNA=;
	b=5zYytycxNkizJ+TRNg8L9041tFFhY4MPYyVjdw6ajHEn657PF2e4Q8yLaivQ9QNykervme
	q2+X8XQbmi3t1itI5/WxBae0Ok6Zf4tvkUTY5THQgoqoCKogYcK/aY85mTuyJxuMwV9AVA
	SHEJ5hK03FjSwtiFTF+v3iaOTkoK+Nc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f98+42k7;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756474907; a=rsa-sha256;
	cv=none;
	b=ndo1T8xm5kjHZe2Ls6FttaIISapnGOXhD/oTYnVBtUGKOJJVdteZxDOMD5tjGq5rwxreLz
	Huiyxk3UPTUNBBtB3F7rLwdjoCIcC+nwoLBm9L8dz4QkFacxiq1jgs50sq4e55gDSiPh7b
	/vyeUc6L2VlHdbe6qBRscJaiOFOzl1Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756474906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7ZezTDYPV9FY1vYbYIlP1Z79qo+TmLw98Vo74TFiYNA=;
	b=f98+42k7426a6CzPQitG4DnS9zPuRNCj/2cp6rT985RCqcYo/vnpZO6T/x/SB7t5eP5Tsj
	HVYVCVdLegLykUVu5kQakqp49TeNtQzmzkc4lUi1lNYjUYkDaoD9LecAW8SFGQAJDDcJ26
	YgrLct+RrB7vq1xlQoGiX5+chGe/iGY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-oG3Z9hyhNXCFBzOZDFuwjg-1; Fri, 29 Aug 2025 09:41:44 -0400
X-MC-Unique: oG3Z9hyhNXCFBzOZDFuwjg-1
X-Mimecast-MFC-AGG-ID: oG3Z9hyhNXCFBzOZDFuwjg_1756474904
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b7bb85e90so12565775e9.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:41:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756474903; x=1757079703;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ZezTDYPV9FY1vYbYIlP1Z79qo+TmLw98Vo74TFiYNA=;
        b=ONzELJA8vHzO3zjgdFnAlhLfatzoyVE8V+fdxZGMwLuN98d6SCInmPwpI/eNUDdYZM
         15RegUisajOnx16SDIUjSJAIBCLp/VZq61eoS4BiS4k+qRqF16t5x57rIV9nLdz7wkSL
         0HFhQJAQgcDNR6SF6WLqyEmgaFLBn3R5bkRbKW/mMxe2yk2PjzS1OCdX8isZGqIz0Y7c
         uC+ILoz3kZSwpNNUljsGgvnaQjBgxotcm2LaXLsYTzRLq1vvj2dtL0iNCaw/XIG961x5
         IoEncwVIN6UfI6UB0//w4+J5zg9BSJnu/Lx7Lry4uvKDp4gCNEEAp8IVxfDNq0fHEq3B
         RYfA==
X-Forwarded-Encrypted: i=1; AJvYcCX0CLlbS9DuBnEWtIpWROJ8mi2VPJ2rOchUElQxnOMCo8xvGWfQ0eSUAFQ2Y/oZ1Fehkf2R/X8gCg==@kvack.org
X-Gm-Message-State: AOJu0Yy6Q6xZ3qceKuGP/8CDouh/A8YPoFVPCqLqtaYV/Ew6afg0fxZG
	LF9Oyx9BCtAmKqvYvDWK/20ae5Jw2enh05zwFyoZB4KCWpSRaMiife4izUxwN5uh56BdPGGRmVD
	FY0ZDnburacVnMDwU53tPEj6WDSfSkG8mLrjxQ467LghUQ5dhAXuU
X-Gm-Gg: ASbGncs1yDE55Bu2SheVZBimNGExbkO9Rjnc/+U1Y7CbnoauOzQ2EikY8rVAO4vok6M
	NTFFkH+W9p2kRC0nPd05PTKB6jO0NGONyVK5Auygdrt2RYks9cEcPK9lk4NcCYcgrxP8tWLxNhX
	Mwfb4uuyEDvtc1ZrynNq8HOd8URNFnpF7bQF9SuIndTglKw898bNglNINAOiNCNVI0EBilD33li
	4yyv/8hQ2reMMdLa3LK/yV1L/IaXDWfscJG4PS4cKLiuPUErq6Seu8DCya9hu5Mh4aoy+0K67Ag
	zZroGFKm13AQo28N1bGR3Nxj8LOXov0tx5Tb+Wpp0s7/Bhd5L12xXin2P1Dzn92nCaFDekfJ53f
	h41rNT/9KcLVT6NtCnfvjRMgaz7gKjgnS1Yag18ebh2MN8aZQMsE+RF+VxnACHXm3
X-Received: by 2002:a05:600c:8b0a:b0:45b:733b:1feb with SMTP id 5b1f17b1804b1-45b733b214dmr83370535e9.10.1756474903630;
        Fri, 29 Aug 2025 06:41:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWe5EWQVl5iPDqqeubvc9kL/5oN1fdgiPPYoM9Zstyja975cqp15HWRaThC/EH89lpSzwt8Q==
X-Received: by 2002:a05:600c:8b0a:b0:45b:733b:1feb with SMTP id 5b1f17b1804b1-45b733b214dmr83370155e9.10.1756474903176;
        Fri, 29 Aug 2025 06:41:43 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf3458a67esm3469559f8f.62.2025.08.29.06.41.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 06:41:42 -0700 (PDT)
Message-ID: <632fea32-28aa-4993-9eff-99fc291c64f2@redhat.com>
Date: Fri, 29 Aug 2025 15:41:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 18/36] mm/gup: drop nth_page() usage within folio when
 recording subpages
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
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-19-david@redhat.com>
 <c0dadc4f-6415-4818-a319-e3e15ff47a24@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <c0dadc4f-6415-4818-a319-e3e15ff47a24@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: f8Wk0LuN1KgRWM6a0zTHMSDYEsbEths--oz6r5xpqPU_1756474904
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7E32F1C0005
X-Rspam-User: 
X-Stat-Signature: 6hdh469ooxamat8nbdbhuzs3q5ezsxob
X-Rspamd-Server: rspam09
X-HE-Tag: 1756474907-882310
X-HE-Meta: U2FsdGVkX1+hHniLcf60oAZX2Bo6LXHo+W/o+CZaIhW0UJMqh5IPr2mgh0D7jbuDq8NF0VNXktIn33iSdu3CHJNQ0lAmoGGlUlIB06lUXHoWFCCKFD1CyhvEHdL5HrUKPMwU1hBm/Zp8kRulRvNCQlfCPbpwgqT75xBGtcJ0/PlvsErw6eqn7IfVAVPY7CIoircaW8ZBdtBT/KBxWE/QI2cU0p0nu8Fz7/8FmxAFTRZu3OTkAeLRVvkFrcPNCriA8fjjxSNOcOMhyvQ1BKddLFfH8dnQy929fxoWJfC8rKO+RB96Cqd5HnAmrfEMblwY8E6acXoP5+mjSPKJo8ZiLuE5FRzC5qKF7fsqT0tB37YlHh5QPRhaRld0KNk9ktvnPNSkYUL4/pnWEIfzt7fibtkXhczN+6vJrqiYDOjT2vLoE4ikCxx2PghWMMrpZVYcea1gpTCVTHyJtdxZlVPuXlMHMtjRPM3cNfPBSBphFnQLaZuWd9YsOWCTlHIlMq3LpV4K9bLjva+FqDV4TnuLUnrD6GuUbhr7MRX9t/KhHWH3QguHM2AEvmUZe/GcPhF3xhy7c3IH2eui9aGaCdt+eHqertA5ZAzk4u8bTxw/NwHUFAQ1+gP0w3iDknB0YFxdwveNVOYrN7ahRpZ7yhm5vqUrKaO2eknlKzrWxgl9Nb5s2rRh/wglNTJ6Pd/9GLsOH3zP2zMj6XvBN0iuPPTM7mgHl54mekfZkqdHT37AkYLVDCgQ/k8UhLegBeIOnBfYaYze5mYq4i8zKlEvn769m9/amv6zNO+4g7FKVlwaLdPG3rhVSwtDDJ2i67gMZBt8wVWE8j3bJanIf48AnEaJY9SPmb72H+MFlSZ3/czO2S+Fj3EAmsUTwIcgVFd5OrN9cmwMV96zM3DAu3fcm5j2oKu2yzGdqSiZqsXTUoH5ki2Wi2F7wdGlAu3DzN0is6+HInIWfKOGwEQ0+jDGBR1
 YGbx8pLk
 tsN/F9sWTQ4Sf9Tkr/j73C3kUciAK1qOcDbNVMCJSPqbEAVEjNAqOFobCwKWlZPHADCrWJbwgmhU0c4YRxGZxuTVUXTPg3kz180NupBHBZTSVdJ3MoM3bbWBtiKhkYBuuFYFUKf3wPnD5MM9Yy4emo+UJobWmTWFvoOIv5YzBrLQY2OeNsKQb6hfSJmSBFuW6jutTIDyfGzgnirXG2JeJbAM4Jv/UgKzYFYkykbvQ9MZMy2k4z/zdM7TWCLm97ldJhb59YDGAvyKcM0RRv1UgLWomyfyICQrT/KJb8EwRoxRD3CE1HeSn2c5FhdwK7W+T6QPAVZbzCZQJ98PppURKhzUhom/IhaxT9AqE3X4V0giZnMNUF/162G4RmWflyTX6T6unEvJzeMoWKw4Dgwzh5E/uRubI0e/0PhSQuvkgEa7TjDC9q6rqGDRdWkKtPkNrKbBz/A1tUnU10P4Jx7syrI0K46QyvBanAaWejYIvEX/LQ60=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 18:37, Lorenzo Stoakes wrote:
> On Thu, Aug 28, 2025 at 12:01:22AM +0200, David Hildenbrand wrote:
>> nth_page() is no longer required when iterating over pages within a
>> single folio, so let's just drop it when recording subpages.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> This looks correct to me, so notwithtsanding suggestion below, LGTM and:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
>> ---
>>   mm/gup.c | 7 +++----
>>   1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index b2a78f0291273..89ca0813791ab 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -488,12 +488,11 @@ static int record_subpages(struct page *page, unsigned long sz,
>>   			   unsigned long addr, unsigned long end,
>>   			   struct page **pages)
>>   {
>> -	struct page *start_page;
>>   	int nr;
>>
>> -	start_page = nth_page(page, (addr & (sz - 1)) >> PAGE_SHIFT);
>> +	page += (addr & (sz - 1)) >> PAGE_SHIFT;
>>   	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
>> -		pages[nr] = nth_page(start_page, nr);
>> +		pages[nr] = page++;
> 
> 
> This is really nice, but I wonder if (while we're here) we can't be even
> more clear as to what's going on here, e.g.:
> 
> static int record_subpages(struct page *page, unsigned long sz,
> 			   unsigned long addr, unsigned long end,
> 			   struct page **pages)
> {
> 	size_t offset_in_folio = (addr & (sz - 1)) >> PAGE_SHIFT;
> 	struct page *subpage = page + offset_in_folio;
> 
> 	for (; addr != end; addr += PAGE_SIZE)
> 		*pages++ = subpage++;
> 
> 	return nr;
> }
> 
> Or some variant of that with the masking stuff self-documented.

What about the following cleanup on top:


diff --git a/mm/gup.c b/mm/gup.c
index 89ca0813791ab..5a72a135ec70b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -484,19 +484,6 @@ static inline void mm_set_has_pinned_flag(struct mm_struct *mm)
  #ifdef CONFIG_MMU
  
  #ifdef CONFIG_HAVE_GUP_FAST
-static int record_subpages(struct page *page, unsigned long sz,
-                          unsigned long addr, unsigned long end,
-                          struct page **pages)
-{
-       int nr;
-
-       page += (addr & (sz - 1)) >> PAGE_SHIFT;
-       for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
-               pages[nr] = page++;
-
-       return nr;
-}
-
  /**
   * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
   * @page:  pointer to page to be grabbed
@@ -2963,8 +2950,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
         if (pmd_special(orig))
                 return 0;
  
-       page = pmd_page(orig);
-       refs = record_subpages(page, PMD_SIZE, addr, end, pages + *nr);
+       refs = (end - addr) >> PAGE_SHIFT;
+       page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
  
         folio = try_grab_folio_fast(page, refs, flags);
         if (!folio)
@@ -2985,6 +2972,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
         }
  
         *nr += refs;
+       for (; refs; refs--)
+               *(pages++) = page++;
         folio_set_referenced(folio);
         return 1;
  }
@@ -3003,8 +2992,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
         if (pud_special(orig))
                 return 0;
  
-       page = pud_page(orig);
-       refs = record_subpages(page, PUD_SIZE, addr, end, pages + *nr);
+       refs = (end - addr) >> PAGE_SHIFT;
+       page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
  
         folio = try_grab_folio_fast(page, refs, flags);
         if (!folio)
@@ -3026,6 +3015,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
         }
  
         *nr += refs;
+       for (; refs; refs--)
+               *(pages++) = page++;
         folio_set_referenced(folio);
         return 1;
  }


The nice thing is that we only record pages in the array if they actually passed our tests.


-- 
Cheers

David / dhildenb


