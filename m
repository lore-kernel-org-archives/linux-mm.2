Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B83F6FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 15:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F9BF6B009E; Wed, 29 Apr 2026 11:34:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0D76B00A0; Wed, 29 Apr 2026 11:34:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BFF66B00A1; Wed, 29 Apr 2026 11:34:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0A11D6B009E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:34:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A1A8F89791
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:34:41 +0000 (UTC)
X-FDA: 84711990762.10.CB55961
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7374120003
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:34:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GNHRFau7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777476879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x52e0fZe8hqgi5rk/2KtQuEEUkLEozDf77zUuE/vYO4=;
	b=hehXWBVGIVb5yLWHnI8TFQO4nssTDOmc3kjD1T7DhCuTOti1I015hAX+Z4+A8MNaziBsoB
	RDrO/I1AWH7KEGVlUt0jUeGALehpFCBtkurzWt+gzSHWu8ZpMvVOd8jrMLMCbE22YUMiBk
	G4pbmG4TB4mOqqcmWesgHikzk0PSosU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777476879; a=rsa-sha256;
	cv=none;
	b=dx5BDQPC5TlDBVCXCcsKDnjigJJQHSanjHiogvppZoJlwxVSGPzb7jr90a8BKjEGvBsjNo
	61MYOQC0bL5X/yKSF9SChf6RP+4IKOv602Up2ObqC5oq0lKWYnFZcKeiI9IrcSAdBHjFZG
	EPhozPWPaAw8f3G/rcFQ03uUNRtQZxg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GNHRFau7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777476878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x52e0fZe8hqgi5rk/2KtQuEEUkLEozDf77zUuE/vYO4=;
	b=GNHRFau7vj37rMMtxgFnJUirLpkM3ZMwDhDjzF+o7b97tV1nxA0YS5SKSk2bkwCWA2mYTH
	LeWNprPiMZPKLrf3LSeG1eRgMhayuX+vOcpRO44zWNk3D8H9khYqmWeLC1az8lLtmI+z54
	onCB/foOpXFAQbvZAWiv1S+w5ukgr4I=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-WJ-58aj0MJGv8hQFNMKPcw-1; Wed, 29 Apr 2026 11:34:36 -0400
X-MC-Unique: WJ-58aj0MJGv8hQFNMKPcw-1
X-Mimecast-MFC-AGG-ID: WJ-58aj0MJGv8hQFNMKPcw_1777476876
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-6546ccc8989so1497570d50.0
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:34:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777476876; x=1778081676;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x52e0fZe8hqgi5rk/2KtQuEEUkLEozDf77zUuE/vYO4=;
        b=qfXFMBRnOF7gMueL1l6JaRNAppk8YlyBnb4XR0DbYeiP70HgtocvJCtrTfVgSw0uUQ
         kUJ8Q5X7vg95PBlfddqfgyMnPkS7VyR4NKC2m6FCrLqHtWFURMc+gBWDIQw8BxW5D55w
         tZXDm+N0Ma2BHhIVB+3Ss5OShhmrNjtjNiOfdT5MNAnZsjWFKUeWq5kcVCY7AuMlbWbn
         lfozNl5l9G3CcV5jDd6bdeOeMwt3OBC/MXX64/kgIEMPTpZTwHq5y/5LZfFzgoliC3tL
         ApS7wZdH/Io+XyRblqgRK6O6dt2O2Q1ehispXZ3QbnVpmnb+Vyt2f0qROs5u0IuIElia
         uUdw==
X-Forwarded-Encrypted: i=1; AFNElJ+HQUhuF0Gbb35dN0CRFAr2I+rk5BN+vuMhUilkdalGs57YDEOAOx5UrUeAceMwgyxKpJwcCl4U7g==@kvack.org
X-Gm-Message-State: AOJu0YzUPBAqABOO++tSLDAsACfSNStgXRaDS5szj80yLgh+oT2N5u5H
	ymSGyvRxVRfhlGECPzH2G7mJk90vRyTGuN9KkXlPOfiMW+a9yUFRb5zvy53MNbZEcYvTkBCaVMz
	MKcgcVjGpKz79QpYt4nvUN8xqUB+u5vcO6yNquzsP9qXhBcdJNwAJDrMb8Dju2ry2m678JbPwvi
	VIUklDh8lYd+NG+53GR9j0ofVwR3A=
X-Gm-Gg: AeBDietGKRAfUlz1k8EeZ+VT7Yf2iojsNGnGejujXpAeVHaeXwIxVLXPOAJj8kOc30A
	Pf7RyJNqlijmG3+McZ/LLFvrzFloBgHdrrbR7c1Nrm+iZphJ6vxa38LeUBExTWZ+CPbEYWejj2B
	PFf4ba1UdKRHspLDFmrrR36OraEcPdYZ01Y65XYmzeNAkC+Rsnp9S03W1jHrrjCbqQiIy/GIxA/
	/VF36UYyGDt1kyI7CNR4YG3YgoKbjQkUWlNpqu+mu9xhBjHrWo=
X-Received: by 2002:a53:b688:0:b0:650:3138:115 with SMTP id 956f58d0204a3-65beee4a1b0mr6260597d50.36.1777476875928;
        Wed, 29 Apr 2026 08:34:35 -0700 (PDT)
X-Received: by 2002:a53:b688:0:b0:650:3138:115 with SMTP id
 956f58d0204a3-65beee4a1b0mr6260501d50.36.1777476875210; Wed, 29 Apr 2026
 08:34:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260419185750.260784-1-npache@redhat.com> <20260419185750.260784-6-npache@redhat.com>
 <6025c087-378b-4754-b1f2-3c5448b49d6c@kernel.org>
In-Reply-To: <6025c087-378b-4754-b1f2-3c5448b49d6c@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Wed, 29 Apr 2026 09:34:41 -0600
X-Gm-Features: AVHnY4LxGs5gVtTI63RcmHeUNNAvbBe-z9kQhpe1H901TsSecYTyWmk06JRVx0o
Message-ID: <CAA1CXcB-BpuryzNLznU_JS5XLvLmGoT34UK-bpMOPjE0GE1NEA@mail.gmail.com>
Subject: Re: [PATCH 7.2 v16 05/13] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
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
X-Mimecast-MFC-PROC-ID: J55bj78OpqgynlGSgdyrbvPuxybp_H3O3OCv4DPsFBE_1777476876
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7374120003
X-Stat-Signature: ziz6g5sazba3g5qxwq36ksjg1pdkzmam
X-Rspam-User: 
X-HE-Tag: 1777476879-73016
X-HE-Meta: U2FsdGVkX19dgdkxKcKT/8Sxen3o3ZN2FmE63K/6gFPnqNF7m9gAEG/LJJs95kNyCK/OAGuLdIrI7rKH8IODhaORbJ30PBHRyhD+ZQDI7OXh674S5ObzYuyVpDWbfkKpz/2KTlFgGT+YfJ1VL3bsDXf7rp2Gv18E9zKnoeO/THnvWQbkzqNdvXhHJZ0YOz85QyRW6ooDwP36XWLjNygPOTHfaTH1RT4aJQGpuSkoZ8+ipiUN0goyIy2g9/OO7EKUPqf1c2WVw1/0N/PfGstCM/l5Gs7cj3hZwUvGaV9U0tU2cXYA9+UGTUtNfE229JqktB90y5qha8AV73uYJxk5IeMCBu8HO/f2Thyf6yn5UligQpk0sGb54bfCZ95XwT0Q1yq7VsKKR3RZMoBnSHC4Y7kn+gpmiTqn1MQ2lADmYW452MwDeSqaBQ5Dzqc9HMRDCvMr5nBVBN4pAT8YAqAVHWwuwMuWWUWKXcM8a2Dqn7v9tbW6cLexoUeO7cVO18mNWX1la0BuSMQapGrNbi7Arg8tu921nL9S2FA3bg5Ew9SJt5iEJkGOVeG06BQihPnzRdReZQWcRmMgdSNjDURUCnHjRBCvkcW9KIWHYjGtnTPC2BwzplHNR6ZswdWDj0jo1dC19Pz7fIHdg606ZjHfMYcLsll8I4nnLK2B2MWD8gu4KhY2OpLhGWu7nf7ZHsE7XmtanwpiiXKjfNIIvFQFet8u7iMX0emo76OXBjoRAp7C1zC67A45MNNiFcQjC2dm2MrcvbTgrH3vZJSzF6FMfp7bd40hTMirbRW/GgE/cOoLjSQoNAdaKWz8N+wcCr2d19+vPZaLKl4RU85hoKxZZk1M+cC8sg0vtBfLGe3+FAB39eB/nS1otWecheqk4VqsAMMglCF/NLCWVZXVWH0Uo0lTR6oEOl/lR8PeXi7Gm0zIK4hP0HSPlAlY9OVJwyrIs0AwESeMgIPReEkCMKk
 h2TvZwuv
 MRI1GppkxRbKAeKsxDkdoLXQfLt6XsKaJMRu3QXyqM/CbBC+wnNWZShiI4EPNdvj8o8D4zNZBnNAfLyINKrOP3QjFR3TZt+2MszAm63FromX0I3+QZ8gXeU/ixqx4jEAunCwTXidyYBK+b0GkRJgrfPHxGQSZESo3sOnx4lk4OGs5mDR6yPgaWsmpIOj3ES7FealUEEWBxbqx+cx/hZwhPHtOuqsJBfNVRmVr1kfM2xl3aCEqEgIEHdgqzdBNNqiZQ1AqS4XdvzX995qBVa4Hjqg9p94VvhCrUPtm2tCLxKL3cifkPruJGwAt08xnweu7dUW0mc5zbUfoEb/pzI/ycc7EczC8OMSmZlyQqqdU99canXWaq7CycCsqm7SLol6amszxbQrJ/PsmCpu02DzXMfJ7Kp4uoY2RvHoVVMfwTPgnJacVyJSYnhDbEuFopbS4cLYP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 2:13 PM, David Hildenbrand (Arm) wrote:
> On 4/19/26 20:57, Nico Pache wrote:
>> Pass an order and offset to collapse_huge_page to support collapsing anon
>> memory to arbitrary orders within a PMD. order indicates what mTHP size we
>> are attempting to collapse to, and offset indicates were in the PMD to
>> start the collapse attempt.
>>
>> For non-PMD collapse we must leave the anon VMA write locked until after
>> we collapse the mTHP-- in the PMD case all the pages are isolated, but in
>> the mTHP case this is not true, and we must keep the lock to prevent
>> access/changes to the page tables. This can happen if the rmap walkers hit
>> a pmd_none while the PMD entry is currently unavailable due to being
>> temporarily removed during the collapse phase.
>>
>> Signed-off-by: Nico Pache <npache@redhat.com>
>> ---
>>   mm/khugepaged.c | 103 +++++++++++++++++++++++++++---------------------
>>   1 file changed, 57 insertions(+), 46 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 283bb63854a5..ff6f9f1883ed 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1198,42 +1198,36 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>>      return SCAN_SUCCEED;
>>   }
>>
>> -static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
>> -            int referenced, int unmapped, struct collapse_control *cc)
>> +static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
>> +            int referenced, int unmapped, struct collapse_control *cc,
>> +            unsigned int order)
>>   {
>>      LIST_HEAD(compound_pagelist);
>>      pmd_t *pmd, _pmd;
>> -    pte_t *pte;
>> +    pte_t *pte = NULL;
>>      pgtable_t pgtable;
>>      struct folio *folio;
>>      spinlock_t *pmd_ptl, *pte_ptl;
>>      enum scan_result result = SCAN_FAIL;
>>      struct vm_area_struct *vma;
>>      struct mmu_notifier_range range;
>> +    bool anon_vma_locked = false;
>> +    const unsigned long pmd_addr = start_addr & HPAGE_PMD_MASK;
>> +    const unsigned long end_addr = start_addr + (PAGE_SIZE << order);
>
> In general, const read better when they are at the very top of this list.

Ack! still getting in the habit of this, sorry.

>
>>
>> -    VM_BUG_ON(address & ~HPAGE_PMD_MASK);
>> -
>> -    /*
>> -     * Before allocating the hugepage, release the mmap_lock read lock.
>> -     * The allocation can take potentially a long time if it involves
>> -     * sync compaction, and we do not need to hold the mmap_lock during
>> -     * that. We will recheck the vma after taking it again in write mode.
>> -     */
>> -    mmap_read_unlock(mm);
>> -
>
> You should spell out that locking change (moving it to the caller), and why it
> is required, in the patch description.
>
> I'd even have put this into a separate patch, as it's independent to the
> order-passing changes.

Yeah good point ill separate this out into its own patch, I also
realized I never updated the commit message for this patch to properly
describe this change. Whoops.


> [...]
>
>>       */
>>      __folio_mark_uptodate(folio);
>> -    pgtable = pmd_pgtable(_pmd);
>> -
>>      spin_lock(pmd_ptl);
>> -    BUG_ON(!pmd_none(*pmd));
>> -    pgtable_trans_huge_deposit(mm, pmd, pgtable);
>> -    map_anon_folio_pmd_nopf(folio, pmd, vma, address);
>> +    WARN_ON_ONCE(!pmd_none(*pmd));
>> +    if (is_pmd_order(order)) { /* PMD collapse */
>> +            pgtable = pmd_pgtable(_pmd);
>> +            pgtable_trans_huge_deposit(mm, pmd, pgtable);
>> +            map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
>> +    } else { /* mTHP collapse */
>
> Do both these comments (PMD collapse ...) really add any value? I'd say it's
> pretty self-documenting code already.

Yeah with the new is_pmd_order helper its def a little overkill. I'll
remove them. Thanks!


>
>> +            map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);
>> +            smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */
>> +            pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>> +    }
>>      spin_unlock(pmd_ptl);
>>
>>      folio = NULL;
>>
>>      result = SCAN_SUCCEED;
>>   out_up_write:
>> +    if (anon_vma_locked)
>> +            anon_vma_unlock_write(vma->anon_vma);
>> +    if (pte)
>> +            pte_unmap(pte);
>


