Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DDFE606A336
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 08:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I+cKpbzK
Received: by kanga.kvack.org (Postfix)
	id 76D296B01FB; Wed, 21 Oct 2026 04:37:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71E5C6B01FE; Wed, 21 Oct 2026 04:37:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E50D6B01FF; Wed, 21 Oct 2026 04:37:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32F116B01FB
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:37:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F41DF804A9
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:37:54 +0000 (UTC)
X-FDA: 85345980510.12.8F7512C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2FE88100004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:37:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I+cKpbzK;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792571873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SZ3EviCYxMDcxcQqwdkGz4a9ADC55X4maOqxKmHiuIA=;
	b=k0Ht6Ph26W5kkbtbv+RdjSXCtgA/TR359AEzQPeRM2e84sOB2S9CIOcN8MX8f2C+xUB4T2
	lWORBe7kDlUvtwWVDr04T0HnDu4iGjKq6LAFSzHAgysDHFTGRzk4BxJsrahCazck9IpyKF
	KmouFhcxeXiKPPANqBL8JVIR58jPWYo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I+cKpbzK;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792571873;
	b=iJF2tfz7408myxJp3cpu8DkAGoDCpUkaj4tZ4J1bdkyedYdI4At5m/snT3b9wc+Fyws/89
	x3ix+x92BqXkbbAK24mEEnguyfEuI59NgMlB70ucK0fcW6ZggC1Q6HONH/IuKoHw0P7pV1
	LEr8COJI0L4J2pTMPJsgJBrj4T2iGEY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 58E4944464;
	Wed, 21 Oct 2026 08:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A681F000CE;
	Wed, 21 Oct 2026 08:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792571872;
	bh=SZ3EviCYxMDcxcQqwdkGz4a9ADC55X4maOqxKmHiuIA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I+cKpbzKX1NJJ+vV3Nf0xMc43gi4ozC2qu1m4Ircxn0vL1WBettiLwcFxk0f2Zk7m
	 36hyR7/aePcxRJAnWMBei2+6ToqUej8aR+A7EAKCBm3fz1bLXzkpfI7BhoEbc+AJO3
	 MrGhYQT/V2n2ViXB972cnyE8mcI7UoUCQ5QW6JrOzOs1XRwHDxzlJDGjFMXfY2GA2i
	 q7o4gYrYg+OiQleCuWFTeREKMo3iuAk51O7BQ52KEfPtOzZf5CMRZbo1Wh9s/x5+7W
	 ugnkO+geYfV8JQgNZKoYEx+5Bhy+TD7dXOH256AeeqslY0Y+BQITgPUjBMJv0B8C3F
	 FcjEbATjabgLg==
Message-ID: <973fd409-64b7-4c62-82e1-c75c784b80f7@kernel.org>
Date: Wed, 21 Oct 2026 10:37:44 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm/huge_memory: recheck a special PMD under the
 lock in copy_huge_pmd()
To: Konstantin Khorenko <khorenko@virtuozzo.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
 =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
 dri-devel@lists.freedesktop.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
 stable@vger.kernel.org
References: <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v3-0-85eaec8417f6@virtuozzo.com>
 <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v3-1-85eaec8417f6@virtuozzo.com>
 <5800bc6e-7671-41eb-bb09-7fbc8f2d085c@kernel.org>
 <03a10e8e-f14e-4612-9c23-70f94137a29e@virtuozzo.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <03a10e8e-f14e-4612-9c23-70f94137a29e@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2FE88100004
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: ir7tbu5xtimtndk86fu47e15ig4fozh7
X-HE-Tag: 1792571873-262030
X-HE-Meta: U2FsdGVkX1/YRkIkICcMTXNWm4j2W+Syt+UrHiLfqaxJb0jM+FDXcGrtKnI8buE3EsFBgZf+lBN1o3Wv9NJVUWouzZfAVEjTmKsnKBWBOxe+T6kX469frTZcBH3p84phCDXm/tJrIezdCYdRbQqkjT1xCBzBuJUYs9XRZxBccV3tsL3FAsdm1UXuY/oK1g6pXq+UfgO45yLEevSd3L1q0CkwsBh6BCq5CoDLeX2vR6tIVWkEAwgPyFnDhnUwq8mhX9z2uq8f/zVNuhfpwnqtDSeDN/su4uE7iV5W+FpyFpO1X2oyAQXDeclcSEj4DOhUjPo1OsSqu4Uiya4Txl1MdYJniMFY8U6gJMsmRaNFv0Xxp8+otCxpHADZngGci5NyMFg4/FGdYki3BgRi8pFQF7C4r36PavN7CB8KledyuHGBrby3Ml54AzaQ92fU/3B9I07YYmJENdnhYC/YQ6Kc8s2QaNrwP/EYOWlGZw1Wzd5AEw+dIyMNtSYNrEE0STdrMR88xEGCP1ErLTURNhJute63BRi7xAPwyB+B6NMq/yjEQ4Gn0jzE6PhGrzGQcmiPIt/hCO5y5Xwr53Y/eCfPWgnictHiuPcLsMKLPuABTwpS4xV8suUpCo9N+cDXYIltfJJweEAVXgwcOOfEvrH0XDNs2WyjLP7YXOEx4qIs0hPBezLlGTVkKB5EP7guadM9c5EGKqDVqiXBTBg/VHTjL61z9ophPF1MYre+YmUbl0nEVDh5hHcEF7cMcsZe94xN7aOHK2/IxJjsgFRUoyK2+AQx0gYhJ0bcQQXimtVU669/2fGWeQLGxI6tdhQ3ryZO1vzAKUAz7KoheqxF6OLsTDYrAnM4Nwyro6xhXZDa6fdKXfIDFmmcldnd2UUpnzgiwSnf598Wgq6Jwhy1RR34HE//JgKHjndsMEbl9bns2SGAClDIrGNby2fr+WrNvimYjeYjkk48EaaHdmegbGy
 LqQoDxTZ
 n+DKXUSyaqFBd+tx1CCfiSWR/bKcdduRKlbNS+yu7eu6mVDSNzdSYRH8YIr54QwAYh8uNLWhp5ZSzNEScmT5y+6a5IDc8CFXyuBYP68+CiMizWXYnp25/r433dxE6o74JA1E92YaBp//sRcKgRFrEo10DhsW9+i3bJkZIpWATP+TKKa7eorJVM0QwWDVTnqD5qjrVUcO0Z3T1kkyoI70z20t7fa2Dc/OqRPwFGZnXHWknvZgAHACjolSSJLB7fRg3y8URMqGclKZ9wMOjR1lYVHdyCGqSI4k4wlXpkoMVd61DsQOb/nCf/cVRuZIYfnlt/xGx5a7wWDMOBXajgdogbiUKW3jIYjtfezsu+Ouw5CDtvlojh9PHcFBL52Oykh3tUG5OmfUkGnl6hpxZta0MqJ/EcZy0KVVkNPkF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/16/26 15:05, Konstantin Khorenko wrote:
> On 10/15/26 16:14, David Hildenbrand (Arm) wrote:
>> I would have thought that unmap_mapping_pages() is only called in
>> corner cases when we would have concurrent fork().
>>
>> Like vfio_pci_zap_bars().
>>
>> But yeah, likely there is a theoretical race.
> 
> Agreed, it needs a zap such as vfio_pci_zap_bars() racing with fork()
> of the mapping owner. I only hit it with a delay injected into the
> window.
> 
>> TBH, I think we can drop this comment entirely. That's just simply
>> the right thing to do?
> 
> Will do. I kept the comment on the CoW warning below it, which is
> about something else.
> 
>> But why do we do this early copy dance *at all*? I think I
>> complained about this vma_is_anonymous handling in the past.
>> vma_needs_copy() is the one deciding whether something should get
>> copied or not.
>>
>> So, can't we just get rid of the vma_is_anonymous() handling and
>> perform the weird special-pte check (that I hate entirely) when
>> already holding the PTL?
> 
> I tried exactly that first, see "try 1" below. The early
> vma_is_anonymous() return is gone, the locks are taken for every huge
> PMD, and both the special check and the skip of non-anonymous VMAs
> run on the value read under the lock. The lockless read is gone, and
> the race with it. The skip itself has to stay, as the anonymous path
> cannot copy a file THP.
> 
> That makes fork slower when it walks a VMA full of huge PMDs that it
> then skips. vma_needs_copy() sends such VMAs here, for example a
> MAP_PRIVATE file mapping with an anon_vma. fork() of a process with
> 4 GB of shmem THPs mapped MAP_PRIVATE and an anon_vma on the VMA
> (2047 PMD-mapped THPs), median of 2000 forks, 4-vCPU KVM guest:
> 
>   v7.3-rc7     86-87 us
>   try 1       131-148 us

Perfectly fine.

> 
> That is about 25 ns per huge PMD, spent taking and dropping the two
> PMD locks only to skip it.

We should likely do exactly what we do in the PTE path: copy PMDs that reference
file folios. See copy_present_ptes().

This THP/PMD handling inconsistency is annoying the crap out of me. We should
just consistently do the same thing for PTE vs. PMD.

> 
> So "try 2" keeps the early return, but decides it from the VMA flags
> instead of a lockless read of the PMD: a non-anonymous VMA without
> VM_PFNMAP or VM_MIXEDMAP cannot hold a special PMD other than the huge
> zero one, as vmf_insert_pfn_pmd() requires one of the flags, and the
> flags cannot change under the mmap write lock fork holds. Everything
> else is decided under the PTL, as in try 1. fork() is back at
> 86-87 us.
> 
> I also tried vma_is_special_huge() for that check, but its
> vma_is_dax() test on every huge PMD made fork cost about 17% more
> kernel instructions than v7.3-rc7 here, against about 1% for the
> flags test.
> 
> Both diffs are against v7.3-rc7 and leave out the deposit fix from
> patch 2, which goes on top as before. If try 2 looks right to you, v4
> will be try 2 plus the deposit patch.
> 
> Try 1:
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1958,39 +1958,36 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>         pgtable_t pgtable = NULL;
>         int ret = -ENOMEM;
> 
> -       pmd = pmdp_get_lockless(src_pmd);
> +       if (vma_is_anonymous(dst_vma)) {
> +               pgtable = pte_alloc_one(dst_mm);
> +               if (unlikely(!pgtable))
> +                       goto out;
> +       }
> +
> +       dst_ptl = pmd_lock(dst_mm, dst_pmd);
> +       src_ptl = pmd_lockptr(src_mm, src_pmd);
> +       spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
> +
> +       ret = -EAGAIN;
> +       pmd = *src_pmd;
> +
>         if (unlikely(pmd_present(pmd) && pmd_special(pmd) &&
>                      !is_huge_zero_pmd(pmd))) {


There is a vm_normal_page_pmd(). It should be used instead of all of this
open-coded crap people added over the years.

Again, take a look at how the PTE scenario handles it in copy_present_ptes() etc.

> -               dst_ptl = pmd_lock(dst_mm, dst_pmd);
> -               src_ptl = pmd_lockptr(src_mm, src_pmd);
> -               spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
>                 /*
> -                * No need to recheck the pmd, it can't change with write
> -                * mmap lock held here.
> -                *
> -                * Meanwhile, making sure it's not a CoW VMA with writable
> -                * mapping, otherwise it means either the anon page wrongly
> -                * applied special bit, or we made the PRIVATE mapping be
> -                * able to wrongly write to the backend MMIO.
> +                * Make sure it's not a CoW VMA with writable mapping,
> +                * otherwise it means either the anon page wrongly applied
> +                * special bit, or we made the PRIVATE mapping be able to
> +                * wrongly write to the backend MMIO.


Nobody should be checking pmd_special() bits manually. Use vm_normal_page_pmd().

Sorry that you'll have to clean up the mess people created over the years.

But it's all just waiting for more bugs to be discovered or introduces when
doing stuff completely different for PTE vs. PMD.

-- 
Cheers,

David

