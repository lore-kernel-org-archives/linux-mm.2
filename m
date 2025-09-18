Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7FC4CAC5A8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 11:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E9558E00F8; Thu, 18 Sep 2025 07:42:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 399768E0093; Thu, 18 Sep 2025 07:42:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261068E00F8; Thu, 18 Sep 2025 07:42:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 136828E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:42:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC5DA16014F
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:42:38 +0000 (UTC)
X-FDA: 83902183596.18.905ECF2
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id C172D1A000C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:42:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AlplYPej;
	spf=pass (imf19.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758195756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9MDldjfo9tupcUWZQnJpfd82Ij9mxbI05fyuJdEjujE=;
	b=QKttHSs+1cduasoJksIGu0KvJiclL7tqCh/+oX8Wb5jNUru5+9LJYLQsMEMWvvqHIHPhzm
	SoJgkw+0xOhU+b2sWhFIQG6Avl/V3EeNgYB1K1O2MtkZX5qll+1sX/HzTNEZVktOIYV57y
	FZrsMMaYhmPlIFwkzn43wiXixjxKEi8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AlplYPej;
	spf=pass (imf19.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758195756; a=rsa-sha256;
	cv=none;
	b=p1Qzz+vP1D6KDuUxiEqVHNa2pOCz8Ff46VfZ+TnpPSFu101LXIb1wsIJOhlPEdUCFEJRtE
	uzpQtvusuY+BeQAT+oM+F7SqZQRoBUhmRE186EmqoQxrbeYJIA9rPBba+19awJwh5+mNsw
	EfdfccOc00dc1hGwjp8IkkNT1ZBg7+U=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3b9edf4cf6cso639407f8f.3
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758195755; x=1758800555; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9MDldjfo9tupcUWZQnJpfd82Ij9mxbI05fyuJdEjujE=;
        b=AlplYPejny96Y46t1hC31SyWml8Dlo6HPGXz63sXTsM6+ZWTVAhXoWk8H5ritUEI72
         kPwU06U4TLNECAe8LtH8a72SNkT4d0L/gDXsVJ6MIeCyELRUDhGn6SngWacjnCq3KRMJ
         XzlhKW387FFuzBeYiKTxnOaKSOT0sd/OHlxjEJrw1C4ZQHSbgLuldipesu1YoCfXgaL3
         pPZSvOBuhJGvz7QO5C6YteMgB7FyIEG+miJx8DLaAFW8quq1Pd1mbU883gu0mzMMSE9H
         d9Rc4Alc6FRzuni6vIBI57qzRxxNH9ASScTePSzcNTNOvO+yMiUmRX+EFQRk0POATv31
         cBlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758195755; x=1758800555;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9MDldjfo9tupcUWZQnJpfd82Ij9mxbI05fyuJdEjujE=;
        b=fC+yG2WH6hk+cCjGaopsvJfM7o570h/IzZeNJIlB9ae7i47FZMuv70GXJz+1v+5I09
         XzPpYSINt6J/TVIUYIqPemG9i67ecEbO6Y1fFccYzZMEeHFNlVOnKiKJ3rHUh0hfJgH1
         YHiHOKFWw1Eqs7uZ4bjwZAYJxuJ4OxN/FTJOrjcDbmEtQJ2SswZI3TlqHNt7mGlScFUe
         q9qeJVmuWxADVcA44PFsDfY24AoNWDlp4KJGtWA2NwuTfTLoPp/O1SwpFb5urDyQg8cI
         R3TrlhczZW6NMs9aB/zCMMnFtv59iHLdtXuD110DQbRyWPoYnJ7TIA2WjciMG5DnaOBV
         Lkzg==
X-Forwarded-Encrypted: i=1; AJvYcCXv7HgW/xp3ITeECxeg1py8V3D/02FIR8843DJYlio4GleQPrR81GSAs6sKyBFBWmYyS58fnwoByA==@kvack.org
X-Gm-Message-State: AOJu0Yx481NzFiyq8OlO1vXQdqexGzl6fU3S8h9fBEKYvwhQYqaVqFvd
	sj+bEr4oZSzevvZ0FfDCMOxIkFHJzpa9kDyz0Lt9Z7fNgMF8u63Jve4K
X-Gm-Gg: ASbGncsaJ+NyiOjGolI1kUhMSWlLaTnZxFNpRm6q+8RItuy0hMPF40e6ICS/LXQTjKH
	WQbpTHkgExVRnsQ+vWr6V1Llmj1I44IsX4D27Vz7E0vXylyt7fDqkVG0tR3dc8WtSz1zwDp88eQ
	xsX2fgIZhywUvWx2nhqfUyva2VWC8Q5kqIJccxHJEq+4WHAWFcFKZe1S7kmFy5dKrtu2sBGpePS
	eNQ2mx8pvwdBwN66u8YAOeTuv71a9DlGMpBYZPxywUBkiBWHBqiDORKE3NYfvh4rrnKCil3Zrva
	+8GVeUTvjuzs7kY8SBEVH7q5svXr6PcivZfL+C1dLPtEcRzzrsTJkGWt7GFmxyW220FySgTDeC8
	tbLUbUqd7FuQIlPkTYpokhbHttizGisvqrd9pTXk9CAZ4fqPou7MEOzy/8N1J/DIFghMSVNyXNk
	alK0X5adMPw8hoI0gevQbQj63JnKvAZuUqEQMMBi4I/umpiac=
X-Google-Smtp-Source: AGHT+IF829AGz7l52wXYxA2mF38Hka9ir3qUf7a8oPfBCDeW8zhPeoB6ZqT8hn60Yp5Ltk7KFhTa5Q==
X-Received: by 2002:a05:6000:4383:b0:3e1:219e:a74a with SMTP id ffacd0b85a97d-3ecdf9c277cmr5586035f8f.21.1758195754770;
        Thu, 18 Sep 2025 04:42:34 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23? ([2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbfedd6sm3405278f8f.60.2025.09.18.04.42.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 04:42:33 -0700 (PDT)
Message-ID: <52175d87-50b5-49f8-bb68-6071e6b03557@gmail.com>
Date: Thu, 18 Sep 2025 12:42:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/6] mm: remap unused subpages to shared zeropage when
 splitting isolated thp
Content-Language: en-GB
To: David Hildenbrand <david@redhat.com>,
 =?UTF-8?B?UXVuLXdlaSBMaW4gKOael+e+pOW0tCk=?= <Qun-wei.Lin@mediatek.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "yuzhao@google.com" <yuzhao@google.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "corbet@lwn.net" <corbet@lwn.net>,
 =?UTF-8?B?QW5kcmV3IFlhbmcgKOaliuaZuuW8tyk=?= <Andrew.Yang@mediatek.com>,
 "npache@redhat.com" <npache@redhat.com>, "rppt@kernel.org"
 <rppt@kernel.org>, "willy@infradead.org" <willy@infradead.org>,
 "kernel-team@meta.com" <kernel-team@meta.com>,
 "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>,
 "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
 "cerasuolodomenico@gmail.com" <cerasuolodomenico@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "ryncsn@gmail.com" <ryncsn@gmail.com>, "surenb@google.com"
 <surenb@google.com>, "riel@surriel.com" <riel@surriel.com>,
 "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
 =?UTF-8?B?Q2hpbndlbiBDaGFuZyAo5by16Yym5paHKQ==?=
 <chinwen.chang@mediatek.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 =?UTF-8?B?Q2FzcGVyIExpICjmnY7kuK3mpq4p?= <casper.li@mediatek.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 "baohua@kernel.org" <baohua@kernel.org>,
 "kaleshsingh@google.com" <kaleshsingh@google.com>,
 "zhais@google.com" <zhais@google.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
References: <20240830100438.3623486-1-usamaarif642@gmail.com>
 <20240830100438.3623486-3-usamaarif642@gmail.com>
 <a7944523fcc3634607691c35311a5d59d1a3f8d4.camel@mediatek.com>
 <434c092b-0f19-47bf-a5fa-ea5b4b36c35e@redhat.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <434c092b-0f19-47bf-a5fa-ea5b4b36c35e@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C172D1A000C
X-Stat-Signature: 6ttcb95hpiornajj75fayofep7jswx64
X-HE-Tag: 1758195756-261653
X-HE-Meta: U2FsdGVkX1/imJRG7uWECUTFfaxBHyuBh83ej4ShnKTUWpLpL/LLkh+SSJ/k8DVa5al2s1gr3VBqqZ3YZ73zLT44hxuf+bf+sgf5LM/i1w/QgEL7PJ4NfgpQeZBc4Z4t8BdXhH8hQKagzWpEeNo8FSkhXAq+l6yeJldk4+vbiWxJLxh9/m+w1ePvrMddTh8e0JnDz9mBt9IE5tw5KprdCONiu7IQqck1ULG7mCay5EAwwobPtU6OY9jUxjkuOzZ5O4qzu1/7Wf+ZtalUq2tcYdSjoNg9RONDlJJs7ndBXpZewbjpSj0vAOy97qgI1/8Zbgm3VeAp8yz6XVJA+9eqHhXhCJN0josDZbcj+c2NLtVZGOCB2oX/r5AFqWIgiz5LacTvR8PtVwy5gNLjBsWNihm11xfD+0ZIeGYsMdg6C9PeDrX3Fvn6HvXjCxXQgoQ9DAK1y5MbacPVCYBK3aI2P9r8zZRsio1k1qfnuejTSw/GEsHkIugD1KSzxRoiFCtJHSMo2hK8KVwLZqdrvKkAABv3ayIdUdWNxYnF0x4PYJaCFJUFo27ZvHhTaG7OvGJ7YWv7QZfNRa5AfkPWOaxYLWt38egiobDUqZ1Ugg0C67gILiM9wuYb9msB1xdzsaxXbIOy8eWbY2ZGAFAOxREDnTUZSC/pfLlsTCZI5RBZCRNdP4orX0PFQxMIFNpH2ces7H+PSuaKD7Oq3cU56qvVFKkntAHGDWzdv6hdThORoCbWbto4XlffTSTrO9CBmoWcVoL/rW7V/flU4SvXR3iomTxIkd3AELcti6moJImMr93lnugry6B0P4akfgbg0w70nJyaUAKcXDAgWztT8Lxj38Mk4I+cGXaKsWV6xlZUcCmoVnJBu2F0toENKcf7V7UEdRL73O5KMKApX25QjMiSYkC/OsJeE+iev5nbUYWfWaHzTC2A5Vn1vwoPIVrC8SJhWmuBPjwwFksU5f8sXhr
 5fWP0hkp
 wE4CkI+izAZQVQIUpmZ7u31JpTBaDTZSJ41T/G3qnAXyR6lXRdmXPAVm6NurPYx8wZecuaD94+ZTI7WqL5T8HKTZ+Pon/r2k/NnqIYzOYGe9885CygW3O7w4ot5jiMf1qOzDLb5WDeQfXKawTTIHAu1RREk49u2v16rMMHJ+ukOa1iFlFbXvErq7cxofPBSRkZAnXrvPmlyy+Nh5pTTDHefGesUYNzc7PeeBdQT6fd1/BTx20GnHoVU7LPmISIIdp7dB50skEaB3OWdt7zEVJYVkRAJSO4u7iy/RbXT/E4V92BIo3mOPXCtBISQ5Th8JD2mpsxqOtLcfv3no60gUL9LidAh87Em9XgrpPbN2WyUKqFXe84W0UFaDmmDBr6Un17/8AOBG4VaXkQDkqJg/AI13w8gBRJUuP/YZzWiHYgeqxuoMuHiKUiEO4C0oEMuMfOUhjtBFrUw6V45+qLTZDiQS5xb9Wrj4AWDob78S+EyFIDGgYsKlukAzia6qX10fiBdF8OFeOtLuwFcTAxwX+DQrsdE9Tgl1trkTPl68XArrkMEU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/09/2025 09:56, David Hildenbrand wrote:
> On 18.09.25 10:53, Qun-wei Lin (林群崴) wrote:
>> On Fri, 2024-08-30 at 11:03 +0100, Usama Arif wrote:
>>> From: Yu Zhao <yuzhao@google.com>
>>>
>>> Here being unused means containing only zeros and inaccessible to
>>> userspace. When splitting an isolated thp under reclaim or migration,
>>> the unused subpages can be mapped to the shared zeropage, hence
>>> saving
>>> memory. This is particularly helpful when the internal
>>> fragmentation of a thp is high, i.e. it has many untouched subpages.
>>>
>>> This is also a prerequisite for THP low utilization shrinker which
>>> will
>>> be introduced in later patches, where underutilized THPs are split,
>>> and
>>> the zero-filled pages are freed saving memory.
>>>
>>> Signed-off-by: Yu Zhao <yuzhao@google.com>
>>> Tested-by: Shuang Zhai <zhais@google.com>
>>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
>>> ---
>>>   include/linux/rmap.h |  7 ++++-
>>>   mm/huge_memory.c     |  8 ++---
>>>   mm/migrate.c         | 72 ++++++++++++++++++++++++++++++++++++++----
>>> -- 
>>>   mm/migrate_device.c  |  4 +--
>>>   4 files changed, 75 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>>> index 91b5935e8485..d5e93e44322e 100644
>>> --- a/include/linux/rmap.h
>>> +++ b/include/linux/rmap.h
>>> @@ -745,7 +745,12 @@ int folio_mkclean(struct folio *);
>>>   int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages,
>>> pgoff_t pgoff,
>>>                 struct vm_area_struct *vma);
>>>   -void remove_migration_ptes(struct folio *src, struct folio *dst,
>>> bool locked);
>>> +enum rmp_flags {
>>> +    RMP_LOCKED        = 1 << 0,
>>> +    RMP_USE_SHARED_ZEROPAGE    = 1 << 1,
>>> +};
>>> +
>>> +void remove_migration_ptes(struct folio *src, struct folio *dst, int
>>> flags);
>>>     /*
>>>    * rmap_walk_control: To control rmap traversing for specific needs
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 0c48806ccb9a..af60684e7c70 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3020,7 +3020,7 @@ bool unmap_huge_pmd_locked(struct
>>> vm_area_struct *vma, unsigned long addr,
>>>       return false;
>>>   }
>>>   -static void remap_page(struct folio *folio, unsigned long nr)
>>> +static void remap_page(struct folio *folio, unsigned long nr, int
>>> flags)
>>>   {
>>>       int i = 0;
>>>   @@ -3028,7 +3028,7 @@ static void remap_page(struct folio *folio,
>>> unsigned long nr)
>>>       if (!folio_test_anon(folio))
>>>           return;
>>>       for (;;) {
>>> -        remove_migration_ptes(folio, folio, true);
>>> +        remove_migration_ptes(folio, folio, RMP_LOCKED |
>>> flags);
>>>           i += folio_nr_pages(folio);
>>>           if (i >= nr)
>>>               break;
>>> @@ -3240,7 +3240,7 @@ static void __split_huge_page(struct page
>>> *page, struct list_head *list,
>>>         if (nr_dropped)
>>>           shmem_uncharge(folio->mapping->host, nr_dropped);
>>> -    remap_page(folio, nr);
>>> +    remap_page(folio, nr, PageAnon(head) ?
>>> RMP_USE_SHARED_ZEROPAGE : 0);
>>>         /*
>>>        * set page to its compound_head when split to non order-0
>>> pages, so
>>> @@ -3542,7 +3542,7 @@ int split_huge_page_to_list_to_order(struct
>>> page *page, struct list_head *list,
>>>           if (mapping)
>>>               xas_unlock(&xas);
>>>           local_irq_enable();
>>> -        remap_page(folio, folio_nr_pages(folio));
>>> +        remap_page(folio, folio_nr_pages(folio), 0);
>>>           ret = -EAGAIN;
>>>       }
>>>   diff --git a/mm/migrate.c b/mm/migrate.c
>>> index 6f9c62c746be..d039863e014b 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -204,13 +204,57 @@ bool isolate_folio_to_list(struct folio *folio,
>>> struct list_head *list)
>>>       return true;
>>>   }
>>>   +static bool try_to_map_unused_to_zeropage(struct
>>> page_vma_mapped_walk *pvmw,
>>> +                      struct folio *folio,
>>> +                      unsigned long idx)
>>> +{
>>> +    struct page *page = folio_page(folio, idx);
>>> +    bool contains_data;
>>> +    pte_t newpte;
>>> +    void *addr;
>>> +
>>> +    VM_BUG_ON_PAGE(PageCompound(page), page);
>>> +    VM_BUG_ON_PAGE(!PageAnon(page), page);
>>> +    VM_BUG_ON_PAGE(!PageLocked(page), page);
>>> +    VM_BUG_ON_PAGE(pte_present(*pvmw->pte), page);
>>> +
>>> +    if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags &
>>> VM_LOCKED) ||
>>> +        mm_forbids_zeropage(pvmw->vma->vm_mm))
>>> +        return false;
>>> +
>>> +    /*
>>> +     * The pmd entry mapping the old thp was flushed and the pte
>>> mapping
>>> +     * this subpage has been non present. If the subpage is only
>>> zero-filled
>>> +     * then map it to the shared zeropage.
>>> +     */
>>> +    addr = kmap_local_page(page);
>>> +    contains_data = memchr_inv(addr, 0, PAGE_SIZE);
>>> +    kunmap_local(addr);
>>> +
>>> +    if (contains_data)
>>> +        return false;
>>> +
>>> +    newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
>>> +                    pvmw->vma->vm_page_prot));
>>> +    set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte,
>>> newpte);
>>> +
>>> +    dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
>>> +    return true;
>>> +}
>>> +
>>> +struct rmap_walk_arg {
>>> +    struct folio *folio;
>>> +    bool map_unused_to_zeropage;
>>> +};
>>> +
>>>   /*
>>>    * Restore a potential migration pte to a working pte entry
>>>    */
>>>   static bool remove_migration_pte(struct folio *folio,
>>> -        struct vm_area_struct *vma, unsigned long addr, void
>>> *old)
>>> +        struct vm_area_struct *vma, unsigned long addr, void
>>> *arg)
>>>   {
>>> -    DEFINE_FOLIO_VMA_WALK(pvmw, old, vma, addr, PVMW_SYNC |
>>> PVMW_MIGRATION);
>>> +    struct rmap_walk_arg *rmap_walk_arg = arg;
>>> +    DEFINE_FOLIO_VMA_WALK(pvmw, rmap_walk_arg->folio, vma, addr,
>>> PVMW_SYNC | PVMW_MIGRATION);
>>>         while (page_vma_mapped_walk(&pvmw)) {
>>>           rmap_t rmap_flags = RMAP_NONE;
>>> @@ -234,6 +278,9 @@ static bool remove_migration_pte(struct folio
>>> *folio,
>>>               continue;
>>>           }
>>>   #endif
>>> +        if (rmap_walk_arg->map_unused_to_zeropage &&
>>> +            try_to_map_unused_to_zeropage(&pvmw, folio,
>>> idx))
>>> +            continue;
>>>             folio_get(folio);
>>>           pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
>>> @@ -312,14 +359,21 @@ static bool remove_migration_pte(struct folio
>>> *folio,
>>>    * Get rid of all migration entries and replace them by
>>>    * references to the indicated page.
>>>    */
>>> -void remove_migration_ptes(struct folio *src, struct folio *dst,
>>> bool locked)
>>> +void remove_migration_ptes(struct folio *src, struct folio *dst, int
>>> flags)
>>>   {
>>> +    struct rmap_walk_arg rmap_walk_arg = {
>>> +        .folio = src,
>>> +        .map_unused_to_zeropage = flags &
>>> RMP_USE_SHARED_ZEROPAGE,
>>> +    };
>>> +
>>>       struct rmap_walk_control rwc = {
>>>           .rmap_one = remove_migration_pte,
>>> -        .arg = src,
>>> +        .arg = &rmap_walk_arg,
>>>       };
>>>   -    if (locked)
>>> +    VM_BUG_ON_FOLIO((flags & RMP_USE_SHARED_ZEROPAGE) && (src !=
>>> dst), src);
>>> +
>>> +    if (flags & RMP_LOCKED)
>>>           rmap_walk_locked(dst, &rwc);
>>>       else
>>>           rmap_walk(dst, &rwc);
>>> @@ -934,7 +988,7 @@ static int writeout(struct address_space
>>> *mapping, struct folio *folio)
>>>        * At this point we know that the migration attempt cannot
>>>        * be successful.
>>>        */
>>> -    remove_migration_ptes(folio, folio, false);
>>> +    remove_migration_ptes(folio, folio, 0);
>>>         rc = mapping->a_ops->writepage(&folio->page, &wbc);
>>>   @@ -1098,7 +1152,7 @@ static void migrate_folio_undo_src(struct folio
>>> *src,
>>>                      struct list_head *ret)
>>>   {
>>>       if (page_was_mapped)
>>> -        remove_migration_ptes(src, src, false);
>>> +        remove_migration_ptes(src, src, 0);
>>>       /* Drop an anon_vma reference if we took one */
>>>       if (anon_vma)
>>>           put_anon_vma(anon_vma);
>>> @@ -1336,7 +1390,7 @@ static int migrate_folio_move(free_folio_t
>>> put_new_folio, unsigned long private,
>>>           lru_add_drain();
>>>         if (old_page_state & PAGE_WAS_MAPPED)
>>> -        remove_migration_ptes(src, dst, false);
>>> +        remove_migration_ptes(src, dst, 0);
>>>     out_unlock_both:
>>>       folio_unlock(dst);
>>> @@ -1474,7 +1528,7 @@ static int unmap_and_move_huge_page(new_folio_t
>>> get_new_folio,
>>>         if (page_was_mapped)
>>>           remove_migration_ptes(src,
>>> -            rc == MIGRATEPAGE_SUCCESS ? dst : src,
>>> false);
>>> +            rc == MIGRATEPAGE_SUCCESS ? dst : src, 0);
>>>     unlock_put_anon:
>>>       folio_unlock(dst);
>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>> index 8d687de88a03..9cf26592ac93 100644
>>> --- a/mm/migrate_device.c
>>> +++ b/mm/migrate_device.c
>>> @@ -424,7 +424,7 @@ static unsigned long
>>> migrate_device_unmap(unsigned long *src_pfns,
>>>               continue;
>>>             folio = page_folio(page);
>>> -        remove_migration_ptes(folio, folio, false);
>>> +        remove_migration_ptes(folio, folio, 0);
>>>             src_pfns[i] = 0;
>>>           folio_unlock(folio);
>>> @@ -840,7 +840,7 @@ void migrate_device_finalize(unsigned long
>>> *src_pfns,
>>>               dst = src;
>>>           }
>>>   -        remove_migration_ptes(src, dst, false);
>>> +        remove_migration_ptes(src, dst, 0);
>>>           folio_unlock(src);
>>>             if (folio_is_zone_device(src))
>>
>> Hi,
>>
>> This patch has been in the mainline for some time, but we recently
>> discovered an issue when both mTHP and MTE (Memory Tagging Extension)
>> are enabled.
>>
>> It seems that remapping to the same zeropage might causes MTE tag
>> mismatches, since MTE tags are associated with physical addresses.
> 
> Does this only trigger when the VMA has mte enabled? Maybe we'll have to bail out if we detect that mte is enabled.
> 

I believe MTE is all or nothing? i.e. all the memory is tagged when enabled, but will let the arm folks confirm.

Yeah unfortunately I think that might be the only way. We cant change the pointers and I dont think there is a way
to mark the memory as "untagged". If we cant remap to zeropage, then there is no point of shrinker. I am guessing
instead of checking at runtime whether mte is enabled when remapping to shared zeropage, we need to ifndef the
shrinker if CONFIG_ARM64_MTE is enabled?

> Also, I wonder how KSM and the shared zeropage works in general with that, because I would expect similar issues when we de-duplicate memory?
> 

Yeah thats a very good point!

Also the initial report mentioned mTHP instead of THP, but I dont think that matters.


