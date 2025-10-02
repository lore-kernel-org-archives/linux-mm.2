Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6003ECAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 07:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD72A8E0007; Thu,  2 Oct 2025 03:16:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAEE08E0002; Thu,  2 Oct 2025 03:16:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9DF38E0007; Thu,  2 Oct 2025 03:16:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 952D58E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:16:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 366BBB890E
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:16:32 +0000 (UTC)
X-FDA: 83952316224.26.48C57EF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id B9BD34000F
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:16:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MIman8Rc;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759389389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1GSMR27hsPUoie6UnsgaJIavv0xUMmpLJvLfbvZzpyw=;
	b=wUATTekLJeHVblY7HEXaPbz8i7OKJP8u/U2HREhiUkKUXg3eCej/gtqM5/YYk32IoIh9Y3
	Fj3j5htuKWFPF+2Jdhf0BMd045oXfthWzN8NpcH4Uf1jaA5PAWRphcDBTuYSp+sda5mmM3
	hLHQ9WOXJJkTIFyCC0jTfVoedaOlZKo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MIman8Rc;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759389389; a=rsa-sha256;
	cv=none;
	b=F3kkSHKqBYqJqMpnpMvQSs03RpAbYcfMNu/jUPCCPuRnrZRLIXjyi9VNK/jSoXA596Rr4c
	4mGAyis86KVjR5UF/kY1mOEZpyl3f0vEpj4VGBfuDkl57F1DxnTQhZM6Ucw3iop5nrJVu2
	cPAvKrLfMGgWEqgRN4v21XsqazbuKq4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759389389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1GSMR27hsPUoie6UnsgaJIavv0xUMmpLJvLfbvZzpyw=;
	b=MIman8Rc7Bv3jNWQiMZGh4pT9z98eZIab6K3CJ4905l8cbxwwvByieeV7YWZFXC5DJwPtt
	c8rm+HVzGdb2/2PftvxJcFWMM7h52Ek3g0icSPYNxR37tWEsYNya5GxHGhX7lkgRMbGcCG
	fcKzIQSLqa/FjH+cWSVGQYS8c1B1mr0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-x1ii9sDBMiGxjWo8H7oBaA-1; Thu, 02 Oct 2025 03:16:27 -0400
X-MC-Unique: x1ii9sDBMiGxjWo8H7oBaA-1
X-Mimecast-MFC-AGG-ID: x1ii9sDBMiGxjWo8H7oBaA_1759389386
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ecdd80ea44so737850f8f.1
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 00:16:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759389386; x=1759994186;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1GSMR27hsPUoie6UnsgaJIavv0xUMmpLJvLfbvZzpyw=;
        b=ZKVg6R0oGMXTFF/KiBX2AhTKAOZsbYSh1ZVfoCfeEYaRxmgR2bfogPKtPjgRSwcW8t
         7Fed3A3s9Nrg7pWSekrmZLkjOYIkHIlqjOu2d47XTlJz3Drv86yTX2+aPchYJd3mY6yF
         Mog39eYVDRrZmPCWIW7kKGmS3Sf4sWD5oRQrNlPQZQuM95pA/yhFBcU6MzFJcaNjw9e9
         +0M6Dz3dXdJUzSXcm/VzSv3+iowhNdNOvYatS1EyVC9Eq0myrZF/fTrL4ProYbe0p6F6
         oGw/tfK5pdrKOXQ3c4lWuQuu2jC+TvtNpJhcNa08wxQ5UxVC/xRge1j9xG4x8W+ae2uj
         nBRA==
X-Forwarded-Encrypted: i=1; AJvYcCUuV79pB0FL7u5TooqCVAgrhumi1/r0UcgIuKZa7y9uC1yfC4AOYskIkKY2yPprkr9u3YeCneSZ/Q==@kvack.org
X-Gm-Message-State: AOJu0YxpQkiOrVzi/d1f+j3bUeX4px0XE5p1rlB7WnQb4zUJRHrhE/LG
	aj3fbxr2xL7gCVyDugQ6Ggw2W+OgP0s5AX+5UiCXZZHp37hD7KLtIjkV5dCjm+S9vjNSsOH8T41
	SdIjAfaxNH2xSL+cqVfm7mfiQADzCnmIQczPMM7GM7X1CCnGoEPOu
X-Gm-Gg: ASbGncv6e+fyvTfG2LLDWyMy5VEGP/DEPn+wTmU0lC8qb9RmRb8eWvWbbG+8n+7GN1N
	ZazUJOihX+v6PjZN6HmdUUs5nkEvYGxVarX9xA1arz12a1NjQRWfsKoUBD6mIvMDTzhR95kUpDU
	mVS+Gr6P4vUxFy538XZSLmf/+7jioEwGWhAq6+HyaV4wnvcnvmP65yzYvlsxgDdVnW3CY++6DgO
	EjI06qZy2Kvkj1isqwzygoyW9thyZJJhLp0BBnVniFT8Umju4bpSTtnn+60KImg774W3SPvQdFC
	Ni56Qxwioq6gLyXTbHJhV5xe/kf9t2ospq+hXlkuFwzafuyQrVfBhb9jJQadQk5S9voaHGbmUy7
	ROew8bUnY
X-Received: by 2002:a05:6000:1a86:b0:3ec:dfe5:17e8 with SMTP id ffacd0b85a97d-4255d294d2emr1524303f8f.6.1759389386155;
        Thu, 02 Oct 2025 00:16:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+Q/M2OlgijeOAdFrqP6QBlh2tyKnC3lcVltauGf5917JFuF4BsL0kpGZDKPSm1P3cI2xQpQ==
X-Received: by 2002:a05:6000:1a86:b0:3ec:dfe5:17e8 with SMTP id ffacd0b85a97d-4255d294d2emr1524284f8f.6.1759389385675;
        Thu, 02 Oct 2025 00:16:25 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6e1bsm2378053f8f.8.2025.10.02.00.16.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Oct 2025 00:16:25 -0700 (PDT)
Message-ID: <a4b5589a-1607-4e67-939d-f86f98a395a6@redhat.com>
Date: Thu, 2 Oct 2025 09:16:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/huge_memory: add pmd folio to ds_queue in
 do_huge_zero_wp_pmd()
To: Wei Yang <richard.weiyang@gmail.com>, Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 wangkefeng.wang@huawei.com, linux-mm@kvack.org, stable@vger.kernel.org
References: <20251002013825.20448-1-richard.weiyang@gmail.com>
 <20251002014604.d2ryohvtrdfn7mvf@master>
 <fa3f9e82-c6c8-43f2-803f-b8bb0fe56f37@linux.dev>
 <20251002031743.4anbofbyym5tlwrt@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251002031743.4anbofbyym5tlwrt@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: F5E6z5IBsbESuoyGveR0lMYdbbs5vT7XIuERicURUCo_1759389386
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B9BD34000F
X-Stat-Signature: rrg9rc7y3db6okqb6po7auyuqriu6b8z
X-HE-Tag: 1759389389-638193
X-HE-Meta: U2FsdGVkX19i3k4YdQRYxYRjK3JcWp71RP6Hhz/TNeqIbCdb3GUh0GLniPuyyG3iG4ODjeWPz/NEipPI3VlSO0IZq4LLz2M2Igj/53eK0H0LsR5nCpmARp7gpqvv5/pc5iCP+8DkInOButuuR29K5j+ee1tfLnOL9p7xTCArZ4xwbc7ytJ0sRUw1S2TxQijLdNdU/rgGlZJxpzzuFANto0TzfpiF8E7r+SQXGylZ4gk9QXxVuJDs32yJ+wW08u41vsyBnYBMDCKRspkGXkn5YTWlz3tKju8o1yjSVoEC0DEjTHhy9XDR1ZLLSfBNcWA9XbQbhteqKuQ2RAP1Ok6dRB91rFkCAg4AdmgWV2lGz/eCpAqlbuIyLLsnhTp2zY0E0aTU1b06YCYBjq+tC4gUfftgmC1I0uRAc3e19TVfDKzU3gljonIaJT4Sg8KtwTZE+r1BWcqwSHROWQpVqCboh3+EBUTIxZM2hRKmNTme/ApgXOI3xmxsh47iu1r3ITUKsjyvCbtqBzXwDyBq/iDPg7MfkOejBRplBavCoDvbzFt7iGJgeHQsx6K3Xii3A/l3j5K7c0mA0UWVXGxLuKlbsB6ZV6f7j3AKzZ74Wk5RU5CKLBiXdewYU8rPr6keU67slUenu/JfniGfbJn77SC18kEqoq95OkuGGfUj2PLXo7ETObZexaYW5Vcz9+htzoQBQQBPrnLj5dWfSPpYm5x/aUSLl80a2xSjB638yFgfq1CAVa8sXZYoFslcnYjbilJI+ul8TV6211FvLZany4G2tR7BLIMg6yOof8nbxXihQfGA6oiBtPAoPCfxKTV5NXczpb0dm4k8+9pcmSR5xt3i4eG5S0qwR8OrYYi4gTas0u3oAAOeipJ9qzDV9PY03xXL1PVE2DoElK13+zeFG/8+/8cREFWdYd3Kz9A2AAUYt4lqjCjIFGv9xyJKH1b27FKQzyjwBR+QgSXYfTI9Ugc
 f84JicnZ
 K9uBV9/4ieYmG+qtBiLo7889CmEwSZn/zW0ccpMIMEB5seEIMiK2dLlmMRQnICQdxfOBT3J4kH9uv2s9diZi5mgmwN0SHIgvYfqvxabz+tcEK4xfddNGa0onRUeU5UWptscRPaaHedi8yBKqftNZMOpUEXDCttir+i+93Rsi4brfbcN2g5wl97qx8YSDEgHXgzVem9np5bqJKgbVH99HLfPfn43Uyt2hP/VCZcN+13G7b6YpEWso3HLC5g5YnUOrWxdSy9q46ieahlxYF+AcK61EIt8RE+E012mouxiALDQh2Z/k37NS7bYmRkmca1HpSCd+VJQDJjBgxYfx+s3uAv3Cfqxbt4+ilJsNwF/9uhFdQTtVfHsXhROZTbdcWfQ1d68IMMX5petjr/WLqpPKPVjYgdL8drANYc/Qkzq2978RvsvAtOCJJVTx8vMThATH6fA89jbD+xdyS5dOw1RLDodk8rx5GRHqDemoK2fn3dRbtGz2bq4VdVuZ4ht1bqxzmuCGN1qnjF4+KtFFFR8BJ0GWh1bld26y0Bhx9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.10.25 05:17, Wei Yang wrote:
> On Thu, Oct 02, 2025 at 10:31:53AM +0800, Lance Yang wrote:
>>
>>
>> On 2025/10/2 09:46, Wei Yang wrote:
>>> On Thu, Oct 02, 2025 at 01:38:25AM +0000, Wei Yang wrote:
>>>> We add pmd folio into ds_queue on the first page fault in
>>>> __do_huge_pmd_anonymous_page(), so that we can split it in case of
>>>> memory pressure. This should be the same for a pmd folio during wp
>>>> page fault.
>>>>
>>>> Commit 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault") miss
>>>> to add it to ds_queue, which means system may not reclaim enough memory
>>>> in case of memory pressure even the pmd folio is under used.
>>>>
>>>> Move deferred_split_folio() into map_anon_folio_pmd() to make the pmd
>>>> folio installation consistent.
>>>>
>>>
>>> Since we move deferred_split_folio() into map_anon_folio_pmd(), I am thinking
>>> about whether we can consolidate the process in collapse_huge_page().
>>>
>>> Use map_anon_folio_pmd() in collapse_huge_page(), but skip those statistic
>>> adjustment.
>>
>> Yeah, that's a good idea :)
>>
>> We could add a simple bool is_fault parameter to map_anon_folio_pmd()
>> to control the statistics.
>>
>> The fault paths would call it with true, and the collapse paths could
>> then call it with false.
>>
>> Something like this:
>>
>> ```
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 1b81680b4225..9924180a4a56 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -1218,7 +1218,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct
>> vm_area_struct *vma,
>> }
>>
>> static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
>> -		struct vm_area_struct *vma, unsigned long haddr)
>> +		struct vm_area_struct *vma, unsigned long haddr, bool is_fault)
>> {
>> 	pmd_t entry;
>>
>> @@ -1228,10 +1228,15 @@ static void map_anon_folio_pmd(struct folio *folio,
>> pmd_t *pmd,
>> 	folio_add_lru_vma(folio, vma);
>> 	set_pmd_at(vma->vm_mm, haddr, pmd, entry);
>> 	update_mmu_cache_pmd(vma, haddr, pmd);
>> -	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>> -	count_vm_event(THP_FAULT_ALLOC);
>> -	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
>> -	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
>> +
>> +	if (is_fault) {
>> +		add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>> +		count_vm_event(THP_FAULT_ALLOC);
>> +		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
>> +		count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
>> +	}
>> +
>> +	deferred_split_folio(folio, false);
>> }
>>
>> static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index d0957648db19..2eddd5a60e48 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1227,17 +1227,10 @@ static int collapse_huge_page(struct mm_struct *mm,
>> unsigned long address,
>> 	__folio_mark_uptodate(folio);
>> 	pgtable = pmd_pgtable(_pmd);
>>
>> -	_pmd = folio_mk_pmd(folio, vma->vm_page_prot);
>> -	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
>> -
>> 	spin_lock(pmd_ptl);
>> 	BUG_ON(!pmd_none(*pmd));
>> -	folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
>> -	folio_add_lru_vma(folio, vma);
>> 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
>> -	set_pmd_at(mm, address, pmd, _pmd);
>> -	update_mmu_cache_pmd(vma, address, pmd);
>> -	deferred_split_folio(folio, false);
>> +	map_anon_folio_pmd(folio, pmd, vma, address, false);
>> 	spin_unlock(pmd_ptl);
>>
>> 	folio = NULL;
>> ```
>>
>> Untested, though.
>>
> 
> This is the same as I thought.
> 
> Will prepare a patch for it.

Let's do that as an add-on patch, though.

-- 
Cheers

David / dhildenb


