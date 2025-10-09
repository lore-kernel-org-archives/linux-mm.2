Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B7B2CCA471
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 06:12:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAE218E0028; Thu,  9 Oct 2025 02:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5E7C8E0002; Thu,  9 Oct 2025 02:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D8B38E0028; Thu,  9 Oct 2025 02:12:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 87D988E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 02:12:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E2A411B167
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:12:37 +0000 (UTC)
X-FDA: 83977556754.02.C128037
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id D40E9A000B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:12:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GVkoDJJ8;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759990355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NRkB3HnbXEauvObRKfhLALPNCnH0LKvnQC+gj83VPV0=;
	b=3wW49lzvCRMfZTc9NQirYN8GqIn+0zm1F7WhGIpncaaavfGZODOdErf1ycd1rQ7hCkjhG7
	MSfXJ1a9en60dcGPg2UbR+X+iIJTGeTguMrnf/ATRt/4+LLVAPMDCW9dRo/Qe11SoLxLrW
	E9LIDiW2u3t3Mkpf0Vbu2S04rKcbwwo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GVkoDJJ8;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759990355; a=rsa-sha256;
	cv=none;
	b=Ty1SCHZeFzuUB1CuhI72QCjNhtr9AW0Wzh2MjnkLA5IbjJ+HpTwjuyMzLJMHGYbzuLakFA
	q9RwxGBMpR8tCdLB6w6SUwojYzheC9jljP/Z59NXzNd8dRdLYOS7icTgftKPwDXMvPiDvS
	0XVDVedWQzu6LnI5fE0z+kmE/nEvSeg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759990354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NRkB3HnbXEauvObRKfhLALPNCnH0LKvnQC+gj83VPV0=;
	b=GVkoDJJ8aDT8Kvu1DJaGC0dgC3KWKucpfi8R0VXt/7MVnua55dMQSUnb3fPmK4MYyNODLd
	YelcsTyUT1slnGvreP71T0+rwJXY/u8QwPwgaLtG0R5vvw76UjqDe+64p2Y1B/5GD2Myf7
	v48vFz7Vzj9e/WoLXXnNXrxi/Cigkvs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-mA-piRuXOG-9XDei_idqtQ-1; Thu, 09 Oct 2025 02:12:31 -0400
X-MC-Unique: mA-piRuXOG-9XDei_idqtQ-1
X-Mimecast-MFC-AGG-ID: mA-piRuXOG-9XDei_idqtQ_1759990350
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e31191379so3809375e9.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 23:12:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759990350; x=1760595150;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NRkB3HnbXEauvObRKfhLALPNCnH0LKvnQC+gj83VPV0=;
        b=Wxhc6tcvQqWf+pfDP2hsM9lPcuJa5BXOBS52+vUP+iTcT5lTePv03lE3jnlBI9R0re
         d7ZXnSyaGDjMs1BWC6TfHY3n86D5eHHesYtK35ED6+H8mU7GIfAISAsL9dE7ekHtwL2r
         /S8z+qNe2LdCXYYWLiMix5sJZa2yK8/ezHLM/YyFbPXTJq8uhVOA1BDQbDHT2+zGoVFk
         8Xen4sf58fLPV3i45H3OfN0OFwLaS5zJITBddm5DAklNnjNxedM/tR2ZFzW7mjMgSQxd
         1TsyadBuu2HE6kC04PwXqcsL8IGnn2rQOx0USwq3OBXGOIaRcMdBbn7W0I7oHJ5SCa1M
         lm3A==
X-Forwarded-Encrypted: i=1; AJvYcCVubcuihM1A1rIaDM9kcSOpAU7Z0ezavbRVph6mpz9VQHnOq9S5obI8f/X3U8ZNf/yBuiK20mSbbg==@kvack.org
X-Gm-Message-State: AOJu0YxbVU1eLhqITiHh+M0IRuHcQ+F88Cp/gHsPNjcXHlq7+mZgD45o
	Uc8U54ktncfVXip8q5mb34S5SXddr9rsX1s0NWc1/ZJ/x4JwBXnqiEpAMuBYBuBCshe2wf1rsLh
	+8bgJ1ngStgoiqhzr3ZViGeLROi9Et0nUTByBX+neQ2XNVMqw2nl8
X-Gm-Gg: ASbGncuVRls2ploqkX61VcjyLFQPH52FJxw5uWeobZyDsULTVAMfXY/l5PHWVHh+8EZ
	fT92dqve3c4jax+zYRDFdhpbDLhkz5XXqN2a+d191DNoItnzlFFnRmI1EUiJioQ0ked2LqYaHNe
	1pLG37DjjiIUWP7v5TvjL3OAQQ2WGLiNlUK09u1SdeEb4b8ZmY4tzLvjxWCpO0EyFN6w61+GYY6
	Us0wyxDVGao+b/B0h8ARd6CQkxcb5RYs+Bt+5cvmk2xt3tGOulVhhh5UYtznyQgIpTlYIthEN1X
	yTyd0gcwqgO0/4mD/M2jDndaiUnxAIz+W4JjCWReXzWOPb+3TeA9ytRzwkGmYS9OIV7tYXPteIT
	9eoKavMD8
X-Received: by 2002:a05:600c:34cc:b0:46e:59dd:1b4d with SMTP id 5b1f17b1804b1-46fa9aa2076mr63277665e9.16.1759990350187;
        Wed, 08 Oct 2025 23:12:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGgr3EwtW4kZSC4wN79xTrMonutG/ORyGxtzc7Y7j2Fbu8/LN9oI7c3abBPFzy3SYjFVQbwOQ==
X-Received: by 2002:a05:600c:34cc:b0:46e:59dd:1b4d with SMTP id 5b1f17b1804b1-46fa9aa2076mr63277065e9.16.1759990349745;
        Wed, 08 Oct 2025 23:12:29 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d869d50sm33971611f8f.0.2025.10.08.23.12.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 23:12:29 -0700 (PDT)
Message-ID: <5a5013ca-e976-4622-b881-290eb0d78b44@redhat.com>
Date: Thu, 9 Oct 2025 08:12:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 06/35] mm/page_alloc: reject unreasonable
 folio/compound page sizes in alloc_contig_range_noprof()
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
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
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-7-david@redhat.com>
 <fa2e262c-d732-48e3-9c59-6ed7c684572c@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <fa2e262c-d732-48e3-9c59-6ed7c684572c@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E85JJ7pOLLZYaM8GLNLmNXrNmpKJL5F55xGXSuzFGMg_1759990350
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xxfyzpatp3msats8k5o3u64r6nf9mhjh
X-Rspamd-Queue-Id: D40E9A000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759990354-473487
X-HE-Meta: U2FsdGVkX1+gUSxzUB73Sa7jUp78pzgBCYQGcRV+XDYq64Ab5hvvuIKV+lOJZ9NQcUlGIB/DgEr8VknQ68W+V90RiN/GDs96EggooHxnRg8O7STlOnCX+b81dVgfLb07YBEo40tZy7y7cVXTz82CaxmvYXuehsMR39dSQ+8DW4/dCyZn4MlvsCdZKf2tV9JX4oJTTT9U+UU/kjbFxnwI9Z2Hya4PFa0tiYc49s1VJjzH7bpdVTjQw1T44fG8QPMlFloF9VNzPH2jS7OzTSHHEonQSbhMWlduEoyqMl3CC6qR5dhw14weQUdA20HqF/7eJsA3N0YauTpMakMtGg7HqOoW8mE7nx9ouaII98Wd15I2MIKlJfiNycHCOdDur8njldOY4HnGfyVCyfpILwAmltSmFUn9diZa3Q1+luf66pFSTgHZBFqIPmXW0SZztQhF1+MOXpFgyvsOYaeJ4dveivAv3v7kHKvU51OJ4uHBJYoOphAztOHQXkqM1gxld023yZtVHlF8n2BRt7wm+h2wW+hCXjwq3W6KyoW6pprFrWRTNFvWc+PuaAQjmLvTS4cJBlXdiKjjoYbplB6vC3cgIQtSS5c/LLWrwS7cEIrQGpUlaJR0DOQ/pDM6JOnTo1echS1oRJ8OswMBxaVwWtqZx9rwGe1xkFbG3zaFYFj00nbeLICAfiF5Az2JALwsWRdnljV1GJe+WboMxSrlfpgoelG9vgQyRHHMOrg7VGXVvk0SGUnddiaKCL8P0/2qNDUUjJmch7QUkTsLSaiD0aVI2g+JSB5dgz5SuHBOz6PeL7WhqpeM9RaO3/ZfKq6ytIfKApTtUgyIepUAfvQm/JsuGdJzs9MA4IDovD9ZhxGwd+bzLvAicUzIkGVKFChQ6eD/1J8JYBThsbxPiHbP/j8FaEEYMBpbEFSuLZeyZQxE433TD4fJdyR6x6IhIaCOxjsD8g9yg22zOchgmUmDc3H
 6nBy740k
 yFY+fl6m0tDSxfD2bo0oQ/oII+SFhNbR59jLgvlTMIahqsFbhZYjrk+vP9txFk4w59WpNZC0bAv39YrP6chzAncQUHWbQr0sibWWiOzzAEoflx01YVOQ27ATvwfUEoocScHUL5wY9CsanUZ+CmnsVA8efNftA0JaUaE+aBrzzPGcqDK/vad0DmnU9dcPL766qA6osxBxnBuGF8m+WWhvS6zyDQzjCIPxUm039MIkMc/c/lBIL8qA2AruvWcGqTKXAa4859AkqnqOFcVTjxGSS+fzB34ZjNbuzgxdpjz+AcYsQb/Ku9hlR8UwmcNmA4cdFmc6+GmwcYjT4xZLxQ9Cb6Umwm5yZ7g7Mq1Wzk4INeYCxNjdejE7Db2G0bmKvbbcoZPPtNTzFl0s3Mdsq1Z/bexQ0D+68/h2I68B7vS0/3O22DF4uJoncGbefsfWxXIiGUaJTnuu86+CBPYAcrOBkn+hlRjDAxQejxMDU5+iRQRtgH/lONYBnrzoadr58mS8YnGFllcfWgOLxFdn8dRCyBxjPo+5swmHraxPochdlDUuN9mKd2b8OI1fGTKp95Mjzu5n6TDxohiAdN6cF+AbcdLHLd30hP/WhwWvG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.10.25 06:21, Balbir Singh wrote:
> On 8/22/25 06:06, David Hildenbrand wrote:
>> Let's reject them early, which in turn makes folio_alloc_gigantic() reject
>> them properly.
>>
>> To avoid converting from order to nr_pages, let's just add MAX_FOLIO_ORDER
>> and calculate MAX_FOLIO_NR_PAGES based on that.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   include/linux/mm.h | 6 ++++--
>>   mm/page_alloc.c    | 5 ++++-
>>   2 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 00c8a54127d37..77737cbf2216a 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -2055,11 +2055,13 @@ static inline long folio_nr_pages(const struct folio *folio)
>>   
>>   /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
>>   #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>> -#define MAX_FOLIO_NR_PAGES	(1UL << PUD_ORDER)
>> +#define MAX_FOLIO_ORDER		PUD_ORDER
> 
> Do we need to check for CONTIG_ALLOC as well with CONFIG_ARCH_HAS_GIGANTIC_PAGE?
> 

I don't think so, can you elaborate?

>>   #else
>> -#define MAX_FOLIO_NR_PAGES	MAX_ORDER_NR_PAGES
>> +#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
>>   #endif
>>   
>> +#define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
>> +
>>   /*
>>    * compound_nr() returns the number of pages in this potentially compound
>>    * page.  compound_nr() can be called on a tail page, and is defined to
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index ca9e6b9633f79..1e6ae4c395b30 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -6833,6 +6833,7 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
>>   int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>>   			      acr_flags_t alloc_flags, gfp_t gfp_mask)
>>   {
>> +	const unsigned int order = ilog2(end - start);
> 
> Do we need a VM_WARN_ON(end < start)?

I don't think so.

> 
>>   	unsigned long outer_start, outer_end;
>>   	int ret = 0;
>>   
>> @@ -6850,6 +6851,9 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>>   					    PB_ISOLATE_MODE_CMA_ALLOC :
>>   					    PB_ISOLATE_MODE_OTHER;
>>   
>> +	if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
>> +		return -EINVAL;
>> +
>>   	gfp_mask = current_gfp_context(gfp_mask);
>>   	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
>>   		return -EINVAL;
>> @@ -6947,7 +6951,6 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>>   			free_contig_range(end, outer_end - end);
>>   	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
>>   		struct page *head = pfn_to_page(start);
>> -		int order = ilog2(end - start);
>>   
>>   		check_new_pages(head, order);
>>   		prep_new_page(head, order, gfp_mask, 0);
> 
> Acked-by: Balbir Singh <balbirs@nvidia.com>

Thanks for the review, but note that this is already upstream.

-- 
Cheers

David / dhildenb


