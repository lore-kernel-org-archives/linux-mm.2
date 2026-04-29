Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F568FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8E6D6B008A; Wed, 29 Apr 2026 10:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3EB56B0096; Wed, 29 Apr 2026 10:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A061D6B009B; Wed, 29 Apr 2026 10:48:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B5E76B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:48:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 54AF5160284
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:48:11 +0000 (UTC)
X-FDA: 84711873582.18.379A968
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id DC4E240002
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:48:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TlzVaPhT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777474089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LvYLtl/btGLGL1tvGyFSRjjJ5sO/Papa+85rbGP6yJ4=;
	b=seJBfxI2TOmh1Q/yJF8tm7opRYNl2RHzDumrM4JMD3IZwYnalHBz98AR5CdyPo7eBImFg8
	qNFIiKozcA+S6zJwauXYRT1hnjEle+OhiCnAUjFvPpU6dS1WGxcjWXte0HjSzgY7vkFBqV
	xuStJI/jkBePucY/IFJKXwWQqy96tKE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777474089; a=rsa-sha256;
	cv=none;
	b=J0QCyD2miOfT+qWy3QtluTi3iXBdeNqyk5aBk2yFkln7dQNkyTxXURo/Bffcf9BTwaDMuG
	Pah626RRKmlomIH0n/ju0/Q9UfChRO7+9WQ6w9PRH9SsSOFW+XhaDlRQ64a5FKQxLbJp2o
	1Z/qXVcTWa672fN4+msTrcXgY0561XQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TlzVaPhT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777474088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LvYLtl/btGLGL1tvGyFSRjjJ5sO/Papa+85rbGP6yJ4=;
	b=TlzVaPhTkVpK4vrhgU+YeAZwZEFYlKr3HW1LhFmcB/Sh1iBMfauWHcjzOlqhb/HJ9KmV83
	1y0RluHogEa85/T7b0L/hLwyOvL2yMtuRy3im7c5yNeapvb03b96G5iVhnYbIDmR7cV93r
	Mt1/Av/nxVfkXO+a3BMHmGh0S/G8Tzk=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-LuRYhRVvPPKu52DWcz57Hg-1; Wed, 29 Apr 2026 10:48:06 -0400
X-MC-Unique: LuRYhRVvPPKu52DWcz57Hg-1
X-Mimecast-MFC-AGG-ID: LuRYhRVvPPKu52DWcz57Hg_1777474085
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-65079af1ee9so5854445d50.1
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:48:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777474085; x=1778078885;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LvYLtl/btGLGL1tvGyFSRjjJ5sO/Papa+85rbGP6yJ4=;
        b=jlst7GAEEPfOPK1y0KLqbWqOCoySqqdxNP1rA3pn3J+/M3fbIQwFJBy6ylMIfal5P2
         IRCGKCrKBwpZYVafNcD5XLN0RxiDD9hrm9Mtd3PFUObEDS2VF/AdJzz2LuXAaubl2cvu
         ifrljGp4lGXWBPkwiI35a+HpSFvs+My/Fs+ZpAOWD6DOxqP+CCfo9DF5soThnNVBsI+A
         JEWKxQvm3baTGTiI24V2dEXf+N6Tv42yd/YhT7f4eBsHn0WN2xrVSQ7f1R0PS6cT7XNV
         +SRJcUHwOTGd+t6+xZPMLEgNoM7/ba1vsDMzbguWjbSFiFTluQb0eBM4W2g2A3w0x4hq
         nMgw==
X-Forwarded-Encrypted: i=1; AFNElJ9t3J8g0U+R5gog5nJBy8oArBXvV1msa5utET7hh+3c5pIJOUpzVzLmJG/LmU5C6THpK9X3/lvTlw==@kvack.org
X-Gm-Message-State: AOJu0YwfntoAMEXLWTgpP4tQXOsHmh58sWRdTs1Lpusc3cMnVB2E5zCZ
	ThtpSG37z3IKrYzuJEUCCTysS2A00aguKPupbEOV23XKZdubFhb0ozH4Oca+LVkmdJjkql70PC2
	TllqdOm2RdnSKKc6Am9sVjMpAA4IES/48Qr2V29dOMc+oAPmg0B7MQA+CNCMRTUu3MUS1wNyj1f
	tOXIcQUbn4Lxk70s42M0cylxX36vA=
X-Gm-Gg: AeBDieuAnHsuxsPmgwYMwC2QshwP4dVovdZ3jfIA+fm51jyDz8209B5XumHH7CbmWKN
	2AHXs91Zop2pd5d1eoR8qugC1pd3xC3XKII2XP2fCbcLVtEgHE0E4XOaEc5H5HTpNGuOaFQMDtV
	7crtgH9JkkAoZmayPXEKPbwnmQHckF7BjE2l1J1h5u4TdiRoXkK9SFjvx1Y8EZNVqG+jgT/yDVH
	nUAfVrN+5cOp6K0i08aEAAwKO438o334P7OI+w3uWHFRsm0/CY=
X-Received: by 2002:a05:690e:4388:b0:651:bb21:e7fd with SMTP id 956f58d0204a3-65bfb6e20f6mr3328332d50.42.1777474085498;
        Wed, 29 Apr 2026 07:48:05 -0700 (PDT)
X-Received: by 2002:a05:690e:4388:b0:651:bb21:e7fd with SMTP id
 956f58d0204a3-65bfb6e20f6mr3328242d50.42.1777474084850; Wed, 29 Apr 2026
 07:48:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260419185750.260784-1-npache@redhat.com> <20260419185750.260784-4-npache@redhat.com>
 <c82a0b73-67ff-45e6-a792-e610b35a5b2f@kernel.org>
In-Reply-To: <c82a0b73-67ff-45e6-a792-e610b35a5b2f@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Wed, 29 Apr 2026 08:48:10 -0600
X-Gm-Features: AVHnY4KJXyCS0pyZ03HCURX89EqHRn0KObQgQxv-NQzUy6bFSsVv_67rAsVp3HM
Message-ID: <CAA1CXcCNpLHkRO82m+XZUVEKsNrvQgUFWVbV7=4PwL8M7jmsug@mail.gmail.com>
Subject: Re: [PATCH 7.2 v16 03/13] mm/khugepaged: rework max_ptes_* handling
 with helper functions
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org, anshuman.khandual@arm.com, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, Liam.Howlett@oracle.com, ljs@kernel.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uY4ltapjG-Qku_FT9LUYj1rkpyy3EwHpXZ5izjeo69c_1777474085
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DC4E240002
X-Stat-Signature: iuiunegd7s6izyhc9uu667uta9hk9tqi
X-Rspam-User: 
X-HE-Tag: 1777474088-243646
X-HE-Meta: U2FsdGVkX1+VY5ijtZRE5nL4AA03sIAE4WIAWR296O6NGoW+Z0GriEaf6DQ+MT0orIO+2jONpmcKgRWMRk0DaNt4a3DndTLQmIpmGJyG2GAKZb9oPI+CbbpKOAzFGbG2zNAfvgD/kWVKwljCo4wprHOS2QAp5mcKCGCYcpnCRq3d14IJlXn+ttB9s1DG62UsBHmTFLDTL/eS2tGPIvYYd9+G1ZdJUnUJviEV/zdiZszte5+Z2hGdUpD+WQha6RZ0wWceYyJx+QyLF/0cKx7cILrJRd4VmkPKLFiLmAG8BqWcu3vzuiSEGvkFag+iJXRiC3OClODWq3gEAXXpthrszyT0vdEPaVHWgJV/jfwkaGTdxnKRBPxhtObPv+tVeGCPRNC2D5ib7LyREepyWMUXq3hl5ZjksiTe1g/9dIwiTIOEsBm/+NQSY6lXkcI6u1fvsvlNCOTo80OqAtJozdaxrID2vDSV+cUl1j8/CC6tQi+uRYNXDW9rMHLaU6SP27UmJsvjzZCG+Nfpej1yar470YHjgUmBOgDq6XaQZpcPOfrDtdPakZuCWZg0Ov91cXblqEF68CEF6Dqr4o+CZdl/S35OG7JTN1nQ4uChjfoW0zF/9Xt2W+305gl/agHHhbDTl7PRvi+OBjbIge10J2P6eHuqLVGoqTU1qU5xmUweVToupYd4qozLxguNLXCj4QhzPfwwOG9dADxWb+W2yrA4AnRcBLePa1QDeuXhZPaqg5ODRYVAkX6uHV0A1PxyjngWazbLcWVRHnPdiAiuQMmZGOhrFpKhKzWy2uq5yXZzHoJ9NOICT/b8ONYyumgiSB38OXVilqB3kdUYLrgL5dEYFyIg/WwCW5Dp5v3KLzyfpo6IeLdhHcpELwKfK/7clCzw0sP+sm3wZePnLhay9ZdjVDLJEi7TphIwGJDLQmglag4SljPbPfgfsXNJ3DIpQXVhU+WJcFNqSKrN8rw49j7
 rbAZpB4S
 miibqqrlpIEqI2Zu5G3qYF0RXaHtZnPyLH+DzIuVj0ROe16UdQ8+zC3MZCCBMA8+W/sPXaPfT1xNiHClai4p9/dB7Jr9ie/rUhUpnF9PRiBvf+2R+dgHe0LdgkSwpkOFwQzNpKH4TMPm/Tm1VyqECgXPtFaVASVxHoITBLKpXr8PcYSC/TMMtxdc7/ZFF3abkXNF2KUdjVhSXPS9T+Ll4gxrE/5UycThMKsctTaBOrrNW76Bzwyp6N7rdgv6rNFkqyze9B2NUNaxWgGDLOOakCcv68eOOjmpiBIf8C3mk9MRw/IX3rfNwvdODkPtmM0wzBCwrfhRy14sMdXcZ5Jz3e4AkwehbzO2fdbMPZscR0mIEpfpbG3n/GX2wTf9jxu0guFt9wXWfEfwjnL0JqDGv8qGm2uZfwAPboMtfvtBC9YrzWhtFdQddm70pvYmN+1/IQaih7iMjelQ4QkrmLdHo6i8n6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 1:52 PM, David Hildenbrand (Arm) wrote:
> On 4/19/26 20:57, Nico Pache wrote:
>> The following cleanup reworks all the max_ptes_* handling into helper
>> functions. This increases the code readability and will later be used to
>> implement the mTHP handling of these variables.
>>
>> With these changes we abstract all the madvise_collapse() special casing
>> (dont respect the sysctls) away from the functions that utilize them. And
>> will later in this series to cleanly restrict mTHP collapses behaviors.
>>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Signed-off-by: Nico Pache <npache@redhat.com>
>> ---
>>   mm/khugepaged.c | 114 +++++++++++++++++++++++++++++++++---------------
>>   1 file changed, 78 insertions(+), 36 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index afac6bc4e76d..f42b55421191 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -348,6 +348,58 @@ static bool pte_none_or_zero(pte_t pte)
>>      return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
>>   }
>>
>> +/**
>> + * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
>
> empty PTE or PTE mapping the shared zeropage ? That should be clarified also below.

Ah fair point, "empty" isn't the best representation of a "none"/zeropage.

>
>> + * @cc: The collapse control struct
>> + * @vma: The vma to check for userfaultfd
>> + *
>> + * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
>> + * empty page.
>
> Not completely accurate due to uffd. And it's not really "empty page".

Sorry I forgot to update this comment. I originally planned on skipping
the VMA passing, but then figured later that it would make the code even
more uniform (as you suggested)

>
> Is that information really necessary for the caller? I'd suggest you drop this
> here and instead add a comment inline above the "return HPAGE_PMD_NR;".

Yeah, I'm not really sure; I can shorten them. I was heeding to lorenzos
request to add these with docstring headers

>
>> + *
>> + * Return: Maximum number of empty PTEs allowed for the collapse operation
>> + */
>> +static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
>> +            struct vm_area_struct *vma)
>> +{
>> +    if (vma && userfaultfd_armed(vma))
>> +            return 0;
>> +    if (!cc->is_khugepaged)
>> +            return HPAGE_PMD_NR;
>> +    return khugepaged_max_ptes_none;
>> +}
>> +
>> +/**
>> + * collapse_max_ptes_shared - Calculate maximum allowed shared PTEs for collapse
>
> "shared PTE" is not quite clear.
>
> "PTEs that map shared anonymous pages" ?

That works for me, thank you

>
>> + * @cc: The collapse control struct
>> + *
>> + * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
>> + * shared page.
>
> Same comment as above.

ack

>
>> + *
>> + * Return: Maximum number of shared PTEs allowed for the collapse operation
>> + */
>> +static unsigned int collapse_max_ptes_shared(struct collapse_control *cc)
>> +{
>> +    if (!cc->is_khugepaged)
>> +            return HPAGE_PMD_NR;
>> +    return khugepaged_max_ptes_shared;
>> +}
>> +
>> +/**
>> + * collapse_max_ptes_swap - Calculate maximum allowed swap PTEs for collapse
>
> We're actually checking non-present page table entries (anonymous THP collapse)
> or non-present pagecache entries (file THP collapse).
>
> I wonder if there is an easy way to clarify that here, at least in the
> description (confusing name can stay unless we find something better).

I'll update the comment to include some form of this. In my mind the
name should probably stay relatively consistent to the sysctl value.

>
>> + * @cc: The collapse control struct
>> + *
>> + * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
>> + * swap page.
>
> Dito.

ack!

>
>> + *
>> + * Return: Maximum number of swap PTEs allowed for the collapse operation
>> + */
>> +static unsigned int collapse_max_ptes_swap(struct collapse_control *cc)
>> +{
>> +    if (!cc->is_khugepaged)
>> +            return HPAGE_PMD_NR;
>> +    return khugepaged_max_ptes_swap;
>> +}
>> +
>>   int hugepage_madvise(struct vm_area_struct *vma,
>>                   vm_flags_t *vm_flags, int advice)
>>   {
>> @@ -546,21 +598,19 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>      pte_t *_pte;
>>      int none_or_zero = 0, shared = 0, referenced = 0;
>>      enum scan_result result = SCAN_FAIL;
>> +    unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
>> +    unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);
>
> These could be const, right? Or will that change in future patches?

Yes I believe these can be const now! Thank you

>
>>
>>      for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>>           _pte++, addr += PAGE_SIZE) {
>>              pte_t pteval = ptep_get(_pte);
>>              if (pte_none_or_zero(pteval)) {
>> -                    ++none_or_zero;
>> -                    if (!userfaultfd_armed(vma) &&
>> -                        (!cc->is_khugepaged ||
>> -                         none_or_zero <= khugepaged_max_ptes_none)) {
>> -                            continue;
>> -                    } else {
>> +                    if (++none_or_zero > max_ptes_none) {
>>                              result = SCAN_EXCEED_NONE_PTE;
>>                              count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>>                              goto out;
>>                      }
>> +                    continue;
>>              }
>>              if (!pte_present(pteval)) {
>>                      result = SCAN_PTE_NON_PRESENT;
>> @@ -591,9 +641,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>
>>              /* See collapse_scan_pmd(). */
>>              if (folio_maybe_mapped_shared(folio)) {
>> -                    ++shared;
>> -                    if (cc->is_khugepaged &&
>> -                        shared > khugepaged_max_ptes_shared) {
>> +                    if (++shared > max_ptes_shared) {
>>                              result = SCAN_EXCEED_SHARED_PTE;
>>                              count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
>>                              goto out;
>> @@ -1270,6 +1318,9 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>>      unsigned long addr;
>>      spinlock_t *ptl;
>>      int node = NUMA_NO_NODE, unmapped = 0;
>> +    unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma);
>> +    unsigned int max_ptes_shared = collapse_max_ptes_shared(cc);
>> +    unsigned int max_ptes_swap = collapse_max_ptes_swap(cc);
>
> Same question here.

ack! will adjust.

>
>>
>>      VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>>
>
>
> In general, LGTM. With the doc fixed up
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thank you Ill get those updated.
>


