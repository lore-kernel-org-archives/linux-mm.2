Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ABA510775E6
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 16:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 557C46B02B4; Wed, 18 Mar 2026 12:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52F106B02B6; Wed, 18 Mar 2026 12:49:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41DE06B02B7; Wed, 18 Mar 2026 12:49:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2E3906B02B4
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:49:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DBA60C2B87
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:49:08 +0000 (UTC)
X-FDA: 84559768776.18.BB5E40F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 813A212000C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:49:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MCyvaZgV;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773852546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gRmS2ckI25IpIcwLZkK5otL0tcCQ/U40Yu29MTugS/8=;
	b=jZkJ0wPWYpgSZQtXXlboOXzW2sINpM6Uurw3Bn0kDEcxpWpryCPsKpwgkXZqPIfpWbxq7Y
	9e3fsKeOFbg5Df9nYPc4INE9zLqYz9fKDcJsTDdzAOLNyzPAczB99ha0wtccfOimY00z05
	qSb4oWEbSmBdAz3RvuZhsIJXFobnqdA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MCyvaZgV;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773852546; a=rsa-sha256;
	cv=none;
	b=nZs48macDYM5ilPlyXxIU6V6njkhCrsuSbcA6HCd88laIGRYfECiQayvXQ9pshb9BJ+yhv
	zV7cHbrKG+JqY5LBq3ylUFgo37qgcC5Fa1bfQ2+b9B3bwEHCoGWxRk7WdBrS20gh53mPBx
	6CMWwpF2tnGm75+IP0KqQLLHMdmb2S4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773852545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gRmS2ckI25IpIcwLZkK5otL0tcCQ/U40Yu29MTugS/8=;
	b=MCyvaZgVKpJSkqxjPfqeIQPtx2qwOZYeMuKbYGgZm7XiZEozhUfiFreI7/s1vLEkisYuiU
	UsyaUgfDQsf0HWD9roLf3QpxSnDgZB8VA15bAWbbYn+6NOL3qvIMQvuY8mgriPOWYHRife
	I5UreKi2H1hF1h700pPOf3HSN5GonVY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-rIbAgH4iMfejG7PVFjTvFA-1; Wed, 18 Mar 2026 12:49:04 -0400
X-MC-Unique: rIbAgH4iMfejG7PVFjTvFA-1
X-Mimecast-MFC-AGG-ID: rIbAgH4iMfejG7PVFjTvFA_1773852544
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-50917afa521so70401661cf.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:49:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773852544; x=1774457344;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gRmS2ckI25IpIcwLZkK5otL0tcCQ/U40Yu29MTugS/8=;
        b=aRq7Icim0MZreiGWoef2Mxv8Q4XdzFp2sCJPByntqgQ+RrB5SeVTdSP0a6B2vfd9pw
         jXraHe+TMrwLdJUSr+t0Xz6sviUUtlPvpFs6WI+G6zxNY5ZB7umRTWwyEOc9MH89R/qq
         7+JAVFBavdoF71hOKcrAQqfL5nfFuJ2Qs2J7LesHd0/46+P4kbtHDPWnzHiyg0FILs0P
         FWINzpWDqOBAQynFxIypwYdHpK3MrcxNoH7irslHutmS55LfhMjZ2fkwUEEDD/vhy5yI
         6I/Mwrga7LJxWgMzbKJ1CYHWQx/VbSbGBq8ra9IxXtSP6QgvrledKMExuUsyrvtomPzY
         gLTA==
X-Forwarded-Encrypted: i=1; AJvYcCU6z55wJrzDTjTsHH2ryx4nzvyZISdUAERZjvAeKWRXH4x84KqbMGkVgm/Jn5bg9L3in07ntwbhzg==@kvack.org
X-Gm-Message-State: AOJu0YzPlOpPsiztgRw2Rwp07UjuBj+i5HBHT5aaSpxAPwQw+TAdxmPv
	9KltPFhLHZMxjCUw2jyo4Ehq0SJrj4JCBkf2BNkcJTllb0/pkZXZwNbQjmz8Cc+6EuIdO1yyDyo
	mpdciAtN+CUVS3X+xIxwwa9GcMsVNAFoOuyMM+e8QIW0s5A9wuBa+
X-Gm-Gg: ATEYQzz9abn/5vSyj4iq5ifjI4IBM02aji9rkc8D1Kd/Nm1AIe1jidjucErvDkmnQj9
	9Dq45O2g2fXH2yCKf2qJEzAhi7EpolnQWh6stIaRigirkp7txa8EcR1YGJnxcDGoswYkJXZ7Lq8
	J17JKR+qiXrX/v9tje29lB4jZ2abIFDTCC+033KwxPxSJHM4p24ykyYdUiEIa1N4N6Qkp5wtbjd
	0O8gayXT6OQbT0qKBHTGFgEPG3sfQ9N+a8BTKPLEig3qoO/cwX5ptnfkwfkUGX57PkiYCj+1aIX
	UbecBLAPeHpgFmG4db2K3BEfVOqcpMoubWO2tCwRhvD0FV0hw6Z6cc/bwrt88+Vzm15XBdSFLuj
	pmZ4e/cLi8ZU3cQg1ya+SDJUQ56E8rD5DPlQJv6sZlLbKUO9fMXCX9QbCMIIA
X-Received: by 2002:a05:622a:1895:b0:509:2135:ed59 with SMTP id d75a77b69052e-50b24793385mr3551671cf.36.1773852544055;
        Wed, 18 Mar 2026 09:49:04 -0700 (PDT)
X-Received: by 2002:a05:622a:1895:b0:509:2135:ed59 with SMTP id d75a77b69052e-50b24793385mr3550861cf.36.1773852543285;
        Wed, 18 Mar 2026 09:49:03 -0700 (PDT)
Received: from [192.168.10.111] (c-76-154-99-94.hsd1.co.comcast.net. [76.154.99.94])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b1348a5d0sm24584531cf.3.2026.03.18.09.48.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 09:49:01 -0700 (PDT)
Message-ID: <42341241-23dc-439e-b32b-da011743adce@redhat.com>
Date: Wed, 18 Mar 2026 10:48:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v3 1/5] mm: consolidate anonymous folio PTE
 mapping into helpers
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260311211315.450947-1-npache@redhat.com>
 <20260311211315.450947-2-npache@redhat.com>
 <5eae219d-62b8-4aea-905d-7a9b59b9892b@lucifer.local>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <5eae219d-62b8-4aea-905d-7a9b59b9892b@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jp0LaPGiG--gAQGeNufwJA29ccZP4QUXzpEykzbCCl0_1773852544
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-ZM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 813A212000C
X-Stat-Signature: f8zzmcg9fd5c8uym3cs4n3fnzw3mjcq5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773852546-294340
X-HE-Meta: U2FsdGVkX18K14AtWqGcrm8gL26luNUBAA2Gqw8rnnRvyqk+8x/rXuZ5ivG248ZiGL+o+9AAdxLGHCpvTbz+lvxrzt3zXMCd/JxvZsiM0A60TXkFjCsKcPdAVMLwV8X0mb7IhCkBBkEipo9uFbzoWDd4HjAhRRbwoCiiZdHjxJeQ3iq6ncVG07qz+JlW5WGdVS3vcv64bXkiz+sE3nR19veyN3JdoXtGO7vc/2PB+M0xicMDV5twBipoPHaUcg47GH+th6PF22SBboxlf2qMKlw8S8lP7pIV48Z65KFD7C1j0Du3rNVzJEocXb/F1D6IAsJNvbLcf+0Hzu5l2zitEQYQsYin/BDORWaNjQvPaQekK+rHI7HWUKFSIKAwuEQRGGVs6S7xueqh56jTI9CeIwyGgh7TXebt3SmnHVerFh0AUNXRq99xrpv26NkSLf9I4sOleo790Z4LexMn3VnmR+DLwXwjMjCHRADDbu+aYhkmCIy1nGzvBGghJR26QS0FJwwBrYfKNDGel5pScypyj821q5uS9R28aYf848pfV4DaeJDKvOAX4jQAVQSq41wfydOAQxm9r+zxgfu/HdtDWRn0CN3XPIZJWQans3g3Pl3YATmQJYehoSmZpZx1bCZoXmheYKuaYxbUPwjfWfLkUTbScAD7fHAUg9FNxvKJ4j5Qq4mNMpdL7Aj+Bg5b/mHovsc0pm+YC4a2HggITFzNeovpQOTBImbZW5qZ1bdXMLNmslvSfNFl3pIS0fBrlBcRKl5YkQzVGnqeAQpJw3Sbf+hyjLssvxnLx69CameRl7es7lVH+fFy3rGhBOEU5IJIzelzLQ92sOly4H6C/pMc2pxnKv2/2aztIG9EsWTwUYTL0kIgeXHv10hb7ftzQomDzyc8z6MYX/6FMivW/5XpfwyeO8hKD/z7V7WWye3gL/9sMukblK2GQGIdR2EmUCtrtwrlZrbQTBss1CrLaZt
 SPnWzW2+
 yylprBy7/NNkemfhCklazNj/sssWGN0DX79mPZtIb+jBcU14LmWvwJSKABQiMuFiFoALALfEAGbdMuz4QwLF+1Z5u4mGrComyMETHKkWJzBxy0413FEc5MhozVzG0fcjV0Mf0o6GBqDe21ldoPle6Ns6SxblSuvnlfjYgCgrIzvBPEM2c+nq42+3bWe+ke9QItIJZ2i83816Jjk4Mh2Lu7ffQp9yoqqB3sPwGGmThJwQpiOOaRJLSRL/n7ivleT8XwZUqpdzBXXqbGfrfUytpEyl/3glCUI1XuNRJgvd3NtdFnMtGKdUfnqONhF/ulVtmW0fFs3nk7mwornjC/Bv+FFjhzWXPZEdEZqblFlSMY6mFHfKvURAY4VBIqHbjJUEuLn1R8tR9WTLtctPfCsEtIhQnVDVOWBZpuq7kKbYkbYfCWzJsAkKXH+MO0H+pOVzdHUGe5q+YB/E3CBkBh61jrM6w/f3KcDYWMPLPoAH2frhMUMysba72OBbxAYQBRHShm+8ny/3l/MrfxWHS5JLpge2EDHtXf4VBAgqRQOT6H2m5r7vgI69gzGbK2QMOBVwTS7QLyGwTiBqHN0chzUSY013su6YNMcB3qQEm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/16/26 12:17 PM, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Mar 11, 2026 at 03:13:11PM -0600, Nico Pache wrote:
>> The anonymous page fault handler in do_anonymous_page() open-codes the
>> sequence to map a newly allocated anonymous folio at the PTE level:
>> 	- construct the PTE entry
>> 	- add rmap
>> 	- add to LRU
>> 	- set the PTEs
>> 	- update the MMU cache.
> 
> Yikes yeah this all needs work. Thanks for looking at this!

np! I believe it looks much cleaner now, and it has the added benefit of
cleaning up some of the mTHP patchset.

I also believe you suggested this so I'll add your SB when I add your RB tag :)

> 
>>
>> Introduce a two helpers to consolidate this duplicated logic, mirroring the
> 
> NIT: 'Introduce a two helpers' -> "introduce two helpers'

ack!

> 
>> existing map_anon_folio_pmd_nopf() pattern for PMD-level mappings:
>>
>> 	map_anon_folio_pte_nopf(): constructs the PTE entry, takes folio
>> 	references, adds anon rmap and LRU. This function also handles the
>> 	uffd_wp that can occur in the pf variant.
>>
>> 	map_anon_folio_pte_pf(): extends the nopf variant to handle MM_ANONPAGES
>> 	counter updates, and mTHP fault allocation statistics for the page fault
>> 	path.
> 
> MEGA nit, not sure why you're not just putting this in a bullet list, just
> weird to see not-code indented here :)

Ill drop the indentation!

> 
>>
>> The zero-page read path in do_anonymous_page() is also untangled from the
>> shared setpte label, since it does not allocate a folio and should not
>> share the same mapping sequence as the write path. Make nr_pages = 1
>> rather than relying on the variable. This makes it more clear that we
>> are operating on the zero page only.
>>
>> This refactoring will also help reduce code duplication between mm/memory.c
>> and mm/khugepaged.c, and provides a clean API for PTE-level anonymous folio
>> mapping that can be reused by future callers.
> 
> Maybe worth mentioning subseqent patches that will use what you set up
> here?

ok ill add something like "... that will be used when adding mTHP support to
khugepaged, and may find future reuse by other callers." Speaking of which I
tried to leverage this elsewhere and I believe that will take extra focus and
time, but may be doable.

> 
> Also you split things out into _nopf() and _pf() variants, it might be
> worth saying exactly why you're doing that or what you are preparing to do?

ok ill expand on this in the "bullet list" you reference above.

> 
>>
>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Nico Pache <npache@redhat.com>
> 
> There's nits above and below, but overall the logic looks good, so with
> nits addressed/reasonably responded to:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Thanks :) Ill take care of those

> 
>> ---
>>  include/linux/mm.h |  4 ++++
>>  mm/memory.c        | 60 +++++++++++++++++++++++++++++++---------------
>>  2 files changed, 45 insertions(+), 19 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 4c4fd55fc823..9fea354bd17f 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -4903,4 +4903,8 @@ static inline bool snapshot_page_is_faithful(const struct page_snapshot *ps)
>>
>>  void snapshot_page(struct page_snapshot *ps, const struct page *page);
>>
>> +void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
>> +		struct vm_area_struct *vma, unsigned long addr,
>> +		bool uffd_wp);
> 
> How I hate how uffd infiltrates all our code like this.
> 
> Not your fault :)
> 
>> +
>>  #endif /* _LINUX_MM_H */
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 6aa0ea4af1fc..5c8bf1eb55f5 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -5197,6 +5197,37 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
>>  	return folio_prealloc(vma->vm_mm, vma, vmf->address, true);
>>  }
>>
>> +void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
>> +		struct vm_area_struct *vma, unsigned long addr,
>> +		bool uffd_wp)
>> +{
>> +	unsigned int nr_pages = folio_nr_pages(folio);
> 
> const would be good
> 
>> +	pte_t entry = folio_mk_pte(folio, vma->vm_page_prot);
>> +
>> +	entry = pte_sw_mkyoung(entry);
>> +
>> +	if (vma->vm_flags & VM_WRITE)
>> +		entry = pte_mkwrite(pte_mkdirty(entry), vma);
>> +	if (uffd_wp)
>> +		entry = pte_mkuffd_wp(entry);
>> +
>> +	folio_ref_add(folio, nr_pages - 1);
>> +	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
>> +	folio_add_lru_vma(folio, vma);
>> +	set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
>> +	update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
>> +}
>> +
>> +static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
>> +		struct vm_area_struct *vma, unsigned long addr, bool uffd_wp)
>> +{
>> +	unsigned int order = folio_order(folio);
> 
> const would be good here also!

ack on the const's

> 
>> +
>> +	map_anon_folio_pte_nopf(folio, pte, vma, addr, uffd_wp);
>> +	add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1 << order);
> 
> Is 1 << order strictly right here? This field is a long value, so 1L <<
> order maybe? I get nervous about these shifts...
> 
> Note that folio_large_nr_pages() uses 1L << order so that does seem
> preferable.

Ok sounds good thanks!

> 
>> +	count_mthp_stat(order, MTHP_STAT_ANON_FAULT_ALLOC);
>> +}
>> +
>>  /*
>>   * We enter with non-exclusive mmap_lock (to exclude vma changes,
>>   * but allow concurrent faults), and pte mapped but not yet locked.
>> @@ -5243,7 +5274,14 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>>  			pte_unmap_unlock(vmf->pte, vmf->ptl);
>>  			return handle_userfault(vmf, VM_UFFD_MISSING);
>>  		}
>> -		goto setpte;
>> +		if (vmf_orig_pte_uffd_wp(vmf))
>> +			entry = pte_mkuffd_wp(entry);
>> +		set_pte_at(vma->vm_mm, addr, vmf->pte, entry);
> 
> How I _despise_ how uffd is implemented in mm. Feels like open coded
> nonsense spills out everywhere.
> 
> Not your fault obviously :)
> 
>> +
>> +		/* No need to invalidate - it was non-present before */
>> +		update_mmu_cache_range(vmf, vma, addr, vmf->pte,
>> +				       /*nr_pages=*/ 1);
> 
> Is there any point in passing vmf here given you pass NULL above, and it
> appears that nobody actually uses this? I guess it doesn't matter but
> seeing this immediately made we question why you set it in one, and not the
> other?
> 
> Maybe I'm mistaken and some arch uses it? Don't think so though.
> 
> Also can't we then just use update_mmu_cache() which is the single-page
> wrapper of this AFAICT? That'd make it even simpler.

> 
> Having done this, is there any reason to keep the annoying and confusing
> initial assignment of nr_pages = 1 at declaration time?
> 
> It seems that nr_pages is unconditionally assigned before it's used
> anywhere now at line 5298:
> 
> 	nr_pages = folio_nr_pages(folio);
> 	addr = ALIGN_DOWN(vmf->address, nr_pages * PAGE_SIZE);
> 	...
> 
> It's kinda weird to use nr_pages again after you go out of your way to
> avoid it using folio_nr_pages() in map_anon_folio_pte_nopf() and
> folio_order() in map_anon_folio_pte_pf().

Yes I believe so, thank you that is cleaner!  In the past I had nr_pages as a
variable but David suggested being explicit with the "1" so it would be obvious
its a single page... update_mmu_cache() should indicate the same thing.

> 
> But yeah, ok we align the address and it's yucky maybe leave for now (but
> we can definitely stop defaulting nr_pages to 1 :)
> 
>> +		goto unlock;
>>  	}
>>
>>  	/* Allocate our own private page. */
>> @@ -5267,11 +5305,6 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>>  	 */
>>  	__folio_mark_uptodate(folio);
>>
>> -	entry = folio_mk_pte(folio, vma->vm_page_prot);
>> -	entry = pte_sw_mkyoung(entry);
>> -	if (vma->vm_flags & VM_WRITE)
>> -		entry = pte_mkwrite(pte_mkdirty(entry), vma);
>> -
>>  	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, addr, &vmf->ptl);
>>  	if (!vmf->pte)
>>  		goto release;
>> @@ -5293,19 +5326,8 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>>  		folio_put(folio);
>>  		return handle_userfault(vmf, VM_UFFD_MISSING);
>>  	}
>> -
>> -	folio_ref_add(folio, nr_pages - 1);
>> -	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
>> -	count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC);
>> -	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
>> -	folio_add_lru_vma(folio, vma);
>> -setpte:
>> -	if (vmf_orig_pte_uffd_wp(vmf))
>> -		entry = pte_mkuffd_wp(entry);
>> -	set_ptes(vma->vm_mm, addr, vmf->pte, entry, nr_pages);
>> -
>> -	/* No need to invalidate - it was non-present before */
>> -	update_mmu_cache_range(vmf, vma, addr, vmf->pte, nr_pages);
>> +	map_anon_folio_pte_pf(folio, vmf->pte, vma, addr,
>> +			      vmf_orig_pte_uffd_wp(vmf));
> 
> So we're going from:
> 
> entry = folio_mk_pte(...)
> entry = pte_sw_mkyoung(...)
> if (write)
> 	entry = pte_mkwrite(also dirty...)
> folio_ref_add(nr_pages - 1)
> add_mm_counter(... MM_ANON_PAGES, nr_pages)
> count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC)
> folio_add_new_anon_rmap(.., RMAP_EXCLUSIVE)
> folio_add_lru_vma(folio, vma)
> if (vmf_orig_pte_uffd_wp(vmf))
> 	entry = pte_mkuffd_wp(entry)
> set_ptes(mm, addr, vmf->pte, entry, nr_pages)
> update_mmu_cache_range(vmf, vma, addr, vmf->pte, nr_pages)
> 
> To:
> 
> <map_anon_folio_pte_nopf>
> entry = folio_mk_pte(...)
> entry = pte_sw_mkyoung(...)
> if (write)
> 	entry = pte_mkwrite(also dirty...)
> if (vmf_orig_pte_uffd_wp(vmf) <passed in via uffd_wp>) <-- reordered
> 	entry = pte_mkuffd_wp(entry)
> folio_ref_add(nr_pages - 1)
> folio_add_new_anon_rmap(.., RMAP_EXCLUSIVE)
> folio_add_lru_vma(folio, vma)
> set_ptes(mm, addr, pte, entry, nr_pages)
> update_mmu_cache_range(NULL, vma, addr, pte, nr_pages)
> 
> <map_anon_folio_pte_pf>
> add_mm_counter(... MM_ANON_PAGES, nr_pages) <-- reordered
> count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC) <-- reodrdered
> 
> But the reorderings seem fine, and it is achieving the same thing.
> 
> All the parameters being passed seem correct too.

Thanks for the review and verifying the logic :) I was particularly scared of
changing the page fault handler, so im glad multiple people have confirmed this
seems fine.

Cheers,
-- Nico

> 
>>  unlock:
>>  	if (vmf->pte)
>>  		pte_unmap_unlock(vmf->pte, vmf->ptl);
>> --
>> 2.53.0
>>
> 
> Cheers, Lorenzo
> 


