Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 094E9FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 15:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A2426B009B; Wed, 29 Apr 2026 11:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652B06B009E; Wed, 29 Apr 2026 11:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 542066B00A0; Wed, 29 Apr 2026 11:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3FF4B6B009B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:34:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B09B54031A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:34:25 +0000 (UTC)
X-FDA: 84711990090.05.CD58D11
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 49256C0015
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:34:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NSRnQGgA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777476863; a=rsa-sha256;
	cv=none;
	b=xwg8W0NWvUhmpnjT5jjr2shEOYvArDCNEdEq0RYrL4NSsWHjhVp+m0GKDegSpt4NC/4im/
	C868cQEapWcT8sGjoVnP10Su0zPH1eNDe2XkmnzDct1OVCdaW9itGMk6qLY9SfFiFERIGA
	+kVUanimSRGu+YC7YkM5bPlkcxeF/rQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NSRnQGgA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777476863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HuFfgBtz9KMV/pnRXnzflTopMd89eVVSakVY5rVzpsI=;
	b=MX7ZOWA4RLDJ7mxj2BKxS8X5AuAgHp7XtuUMM1qeehJILJ7vOXXaOmHTTV288NuY7t2pH3
	W3/tLiQJN+pOU/wQoxYcgapsEwihAfXqSof6eo8B0ZATVOC+iqfQKq8sv6UJHOD9lKbZ94
	ufMiDZjVtzRVcJFoYJGPuevzw2YtOZU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777476862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HuFfgBtz9KMV/pnRXnzflTopMd89eVVSakVY5rVzpsI=;
	b=NSRnQGgAPouKTerh0XFGhrftVEpJfNUQFmXrB2tEo2IxXMsPDOWVZ1jd/nv4zNNz5QabDg
	Yp3lO+7WIH8TuLFTbEsOgS6ArqNLMOGHMhyFMuMErXDLtSM+Cxjmr1WDNDf1FZB1bd5iO2
	xTRGhWysX6R08djCkzHjjk5qyO10+6w=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-ETceGNZ7MdmBk35wH-dHHw-1; Wed, 29 Apr 2026 11:34:21 -0400
X-MC-Unique: ETceGNZ7MdmBk35wH-dHHw-1
X-Mimecast-MFC-AGG-ID: ETceGNZ7MdmBk35wH-dHHw_1777476861
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-652ddb428beso25111117d50.2
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:34:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777476861; x=1778081661;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HuFfgBtz9KMV/pnRXnzflTopMd89eVVSakVY5rVzpsI=;
        b=LkymGE7Plv0l4wEtpvnGpqXxguI9nTID+AoYw27ret/4elU17A12xXR3UamR1juqbi
         R+TGlchJHxJfLyZC3EFCmJqSuRPgYaFB6yFaAsU+JC4SSA1RSWbw2FImw1h8506b19aF
         S7wKDsHdaek7IADqKXjupASbnwkwW7GADMlWsb6FxziEAe0H28jfDzdr3tV+x8n54dLb
         KOVAnzdsQi78iauKPNtKqtb6oF6RHu120W8OvmSSfT0hnwmoAyqXqyn5ydwll2oGt6OM
         86DINB0YGXvnzce8zucPno7UXTIrVnkPzH4ZmGMNhqQOfdxQIFR1X9u6RBwA37qn+FtP
         o8Bw==
X-Forwarded-Encrypted: i=1; AFNElJ+3cZrsS65a1K31i/1+fNAVHFo8rd/MhpSOF5Rex0J3joLVw1PdISFIqcmaieOy5XZ7kNQl8wU08g==@kvack.org
X-Gm-Message-State: AOJu0YxMseCBM+cgVUJq/SwxXZols1NTjR6LhhniYGTNdzTeko9EjZpK
	CPNl3E8ljDfNV06Ix6Oi91CxDB4FV55ri+NT8r96GUqOn5c8Fr1okB1c9I/UKvZf0W16U5CYD9S
	0qH5WJA1i4jhXPKbvFK72VZWEvsHTWJjH8ggjt6tiaVfhL9kN13ELcucWiQGHV/N9Yq/dbKiB+Q
	c67dvlT/ZZMXFgd/QWxw11bV+R/Rc=
X-Gm-Gg: AeBDieswCQfNXnCenxXUPxjWQvjTsLr22PJmZyRbp90NUZD2RDLOvb1pk54+Zvj/8ha
	1KTeVPkUSqjGIPcruHCU92J2Cl2IgI9bEnXbhW9lD1DPC2q7auwpHUxtASvp82X4BsH+dQ2j3Ja
	dbuCNlOHNH/RLq2iM6WO9Ahx8PBa38LCsebjfub0Xyz/Am6myhmJlaO8hmTWvHJlPND8S/6FP2y
	S3EsuJ5oEAISoLVI7BUrN4m/1dawqNbIwU0zbrd0i+MEoVx+c8=
X-Received: by 2002:a05:690e:42d0:b0:654:4045:f40c with SMTP id 956f58d0204a3-65beee98103mr5731426d50.53.1777476860535;
        Wed, 29 Apr 2026 08:34:20 -0700 (PDT)
X-Received: by 2002:a05:690e:42d0:b0:654:4045:f40c with SMTP id
 956f58d0204a3-65beee98103mr5731328d50.53.1777476859542; Wed, 29 Apr 2026
 08:34:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260419185750.260784-6-npache@redhat.com> <20260420142057.392263-1-usama.arif@linux.dev>
In-Reply-To: <20260420142057.392263-1-usama.arif@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Wed, 29 Apr 2026 09:34:24 -0600
X-Gm-Features: AVHnY4K58vxjzjxYUrb5dAGrEP1k6JdWhwO4Q7LKZOLVwPj1q4pvyOMwTkVSZu4
Message-ID: <CAA1CXcDgFDcsx3-mrnFzNu3zMkinFtEKSv84VKepTihUuRPfKg@mail.gmail.com>
Subject: Re: [PATCH 7.2 v16 05/13] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
To: Usama Arif <usama.arif@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, Liam.Howlett@oracle.com, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oPPEq3rp6avH9jJjyCJb20ClEarPU5A6OXJvZLxzTRg_1777476861
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: h1fyzsb7a1reuga8ccgtnfi9f8swez1p
X-Rspam-User: 
X-Rspamd-Queue-Id: 49256C0015
X-Rspamd-Server: rspam07
X-HE-Tag: 1777476863-162081
X-HE-Meta: U2FsdGVkX1/Q9TQ9++6e1cO21v61bMFo5w2giPqXWvovDCR9sByWbtUmMPnf21U1xDb9itlInktR2tzcNCXJPx6mmVz0psV9O5ge1Euojy+TnnKYgK9npVaAhbFlFZp9wSRoRpWbSImJtH0XtDEqxxTStrC4ntsdUBhbyCv4d00M3ufblB7B7oXm7A4vLHq/hbAf2HIylc8bV02eNbspBMcyf8qsOYWgbEcK3rwrN951xcjRt+bW32FrnH0K+F46E33qULkHHZNgFU4Hc12WI+rbiV9A4n/XTrxFLdu1B/X6YBHSLhLm6kxdK2O/co1kOFgO0Q9YswZMhcOVVh2Y4XREQaXrAeJjFuER6WwfzNlP+1Ce3kNtVBaIJ1AnPd25+00Mfx5t/GH0zIJxHxjsXjnW1Ikv9sDT1uIPzpRx4Aku79i7KUjgjVnVCplyl6YwNZUqutqf8flb0PW6LeUy+nfUBCiOeQTqqEr/rfk7QZSGVlhNEXjV6bzQV1Zj09MfBtcTj1korB3s5LMH5iFmm0FWYZJBhkXs9qTTd4fQ7SHw3UOgO3XB46rrlwWD6Ed1Yoh4bYwc9YAWtqZPgKkDkTFju/2t5nL3+X5BWGp0s5cd04uU52YShP8+SrmQAP7IveRW46DQK+9pWBixl4cMigGeu7gc9RMLV6cWNF0BInKiipaLSE4rCgVQ2U1AHtXwedLoTC/ymaaEScBGEQMDW+AF6IKf+AZfYN/FSS8X+Qa0d4Zq8sYmcmrR7HcbUa4vk4kd6qurBNRQ0DzzHlb7DC6y9YuF/HUXcde4KKpsO4/cTi9e8N65A/471oINQpen7UrNjRfDNtZBcEW/yOx2JZnyCi4MgEPBQYv2YdUto46Mf8FQkM65GQnW7GnfOTDeCuIGQOiM/WNAoDYGTOlm/c5GGeUK4pvL73sjDOY4fTYsS1ai7vGgspmAGIyhffB3qB936He37ZjkeKYvNfx
 CmLKIfxR
 4sk8Kxt3xoptFSqr77GpCU8rYWQjKJ5CVQA3k8V2SfmzEuufNceCfOSKMauqfeWZZs7Ttj8PWlTeZiqoqPSGA1BBR5snqCsQ//thffyS8/rDnFBdOVAcBm4AwhWExOxXPOnJsqelqUnPvc2hljjRk1xXO3CmoXlPd/D6skwTrTaLdpTcPaskraTP9its9Wvf5LdMuzMajURO6nPKLg8uyqVwvWlC//BQhifJIyRBFwy2UyiiMaV6PgipeZRzTxs8W61oFHz6e9PbqfZHYvobeVFZJTWBBE91eJhr9lqzF8Miwo6rhL21wEtogiXWtzCYz2oteQZtDYK8r5Gir0bvjrBruv6kDtimgwNDSKyfh15OPj1EEiJwaZD0Z5lO45cB7wYfa1v3I+ZKTLwiq7GhZzQtYb+bgQNbT5fNDuIBjljDZfna1Kl/WHzrG9G/sG4Jh93+FvQQvfiUgnAzgzGLAf3ZCxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/20/26 8:20 AM, Usama Arif wrote:
> On Sun, 19 Apr 2026 12:57:42 -0600 Nico Pache <npache@redhat.com> wrote:
>
>> Pass an order and offset to collapse_huge_page to support collapsing ano=
n
>> memory to arbitrary orders within a PMD. order indicates what mTHP size =
we
>> are attempting to collapse to, and offset indicates were in the PMD to
>> start the collapse attempt.
>>
>> For non-PMD collapse we must leave the anon VMA write locked until after
>> we collapse the mTHP-- in the PMD case all the pages are isolated, but i=
n
>> the mTHP case this is not true, and we must keep the lock to prevent
>> access/changes to the page tables. This can happen if the rmap walkers h=
it
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
>> @@ -1198,42 +1198,36 @@ static enum scan_result alloc_charge_folio(struc=
t folio **foliop, struct mm_stru
>>      return SCAN_SUCCEED;
>>   }
>>
>> -static enum scan_result collapse_huge_page(struct mm_struct *mm, unsign=
ed long address,
>> -            int referenced, int unmapped, struct collapse_control *cc)
>> +static enum scan_result collapse_huge_page(struct mm_struct *mm, unsign=
ed long start_addr,
>> +            int referenced, int unmapped, struct collapse_control *cc,
>> +            unsigned int order)
>>   {
>>      LIST_HEAD(compound_pagelist);
>>      pmd_t *pmd, _pmd;
>> -    pte_t *pte;
>> +    pte_t *pte =3D NULL;
>>      pgtable_t pgtable;
>>      struct folio *folio;
>>      spinlock_t *pmd_ptl, *pte_ptl;
>>      enum scan_result result =3D SCAN_FAIL;
>>      struct vm_area_struct *vma;
>>      struct mmu_notifier_range range;
>> +    bool anon_vma_locked =3D false;
>> +    const unsigned long pmd_addr =3D start_addr & HPAGE_PMD_MASK;
>> +    const unsigned long end_addr =3D start_addr + (PAGE_SIZE << order);
>>
>> -    VM_BUG_ON(address & ~HPAGE_PMD_MASK);
>> -
>> -    /*
>> -     * Before allocating the hugepage, release the mmap_lock read lock.
>> -     * The allocation can take potentially a long time if it involves
>> -     * sync compaction, and we do not need to hold the mmap_lock during
>> -     * that. We will recheck the vma after taking it again in write mod=
e.
>> -     */
>> -    mmap_read_unlock(mm);
>> -
>
> My understanding now is that the caller will need to drop the mmap_read l=
ock?
>
> This needs explicit documentation at the start of the function IMO. I thi=
nk
> there are callers in later patches and its very easy to miss this.

Yeah as David suggested I will probably seperate this out into its own
patch. And add some proper comments to describe the requirement. I didnt
even realize I had forgot to update the patch to describe this change
(apart from the coverletter). Thank you :)

>
>
>> -    result =3D alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
>> +    result =3D alloc_charge_folio(&folio, mm, cc, order);
>>      if (result !=3D SCAN_SUCCEED)
>>              goto out_nolock;
>>
>>      mmap_read_lock(mm);
>> -    result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc,
>> -                                     HPAGE_PMD_ORDER);
>> +    result =3D hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=3D*/=
 true,
>> +                                     &vma, cc, order);
>>      if (result !=3D SCAN_SUCCEED) {
>>              mmap_read_unlock(mm);
>>              goto out_nolock;
>>      }
>>
>> -    result =3D find_pmd_or_thp_or_none(mm, address, &pmd);
>> +    result =3D find_pmd_or_thp_or_none(mm, pmd_addr, &pmd);
>>      if (result !=3D SCAN_SUCCEED) {
>>              mmap_read_unlock(mm);
>>              goto out_nolock;
>> @@ -1245,8 +1239,8 @@ static enum scan_result collapse_huge_page(struct =
mm_struct *mm, unsigned long a
>>               * released when it fails. So we jump out_nolock directly i=
n
>>               * that case.  Continuing to collapse causes inconsistency.
>>               */
>> -            result =3D __collapse_huge_page_swapin(mm, vma, address, pm=
d,
>> -                                                 referenced, HPAGE_PMD_=
ORDER);
>> +            result =3D __collapse_huge_page_swapin(mm, vma, start_addr,=
 pmd,
>> +                                                 referenced, order);
>>              if (result !=3D SCAN_SUCCEED)
>>                      goto out_nolock;
>>      }
>> @@ -1261,20 +1255,21 @@ static enum scan_result collapse_huge_page(struc=
t mm_struct *mm, unsigned long a
>>       * mmap_lock.
>>       */
>>      mmap_write_lock(mm);
>> -    result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc,
>> -                                     HPAGE_PMD_ORDER);
>> +    result =3D hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=3D*/=
 true,
>> +                                     &vma, cc, order);
>>      if (result !=3D SCAN_SUCCEED)
>>              goto out_up_write;
>>      /* check if the pmd is still valid */
>>      vma_start_write(vma);
>> -    result =3D check_pmd_still_valid(mm, address, pmd);
>> +    result =3D check_pmd_still_valid(mm, pmd_addr, pmd);
>>      if (result !=3D SCAN_SUCCEED)
>>              goto out_up_write;
>>
>>      anon_vma_lock_write(vma->anon_vma);
>> +    anon_vma_locked =3D true;
>>
>> -    mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
>> -                            address + HPAGE_PMD_SIZE);
>> +    mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, start_addr=
,
>> +                            end_addr);
>>      mmu_notifier_invalidate_range_start(&range);
>>
>>      pmd_ptl =3D pmd_lock(mm, pmd); /* probably unnecessary */
>> @@ -1286,26 +1281,23 @@ static enum scan_result collapse_huge_page(struc=
t mm_struct *mm, unsigned long a
>>       * Parallel GUP-fast is fine since GUP-fast will back off when
>>       * it detects PMD is changed.
>>       */
>> -    _pmd =3D pmdp_collapse_flush(vma, address, pmd);
>> +    _pmd =3D pmdp_collapse_flush(vma, pmd_addr, pmd);
>
>
> For an mTHP collapse covering, say, 64KiB of a 2MiB PMD, the patch still
> flushes the entire PMD via pmdp_collapse_flush and tlb_remove_table_sync_=
one.
> That triggers cross-CPU TLB shootdowns for ~1.94MiB of unrelated mappings=
 on
> every successful sub-PMD collapse. Probably acceptable as a first cut?

Hmm interesting consideration, I believe this is neccisary from a GUP
perspective as the comment suggests. Me, Dev, and David had discussed
that once that this lands we wanted to play around with a lot of the
locking and previously defined "requirements" to see what is actually
needed. So yeah I think for now we leave it as is. Hopefully we can make
more improvements in the future.

>
>
>>      spin_unlock(pmd_ptl);
>>      mmu_notifier_invalidate_range_end(&range);
>>      tlb_remove_table_sync_one();
>>
>> -    pte =3D pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
>> +    pte =3D pte_offset_map_lock(mm, &_pmd, start_addr, &pte_ptl);
>>      if (pte) {
>> -            result =3D __collapse_huge_page_isolate(vma, address, pte, =
cc,
>> -                                                  HPAGE_PMD_ORDER,
>> -                                                  &compound_pagelist);
>> +            result =3D __collapse_huge_page_isolate(vma, start_addr, pt=
e, cc,
>> +                                                  order, &compound_page=
list);
>>              spin_unlock(pte_ptl);
>>      } else {
>>              result =3D SCAN_NO_PTE_TABLE;
>>      }
>>
>>      if (unlikely(result !=3D SCAN_SUCCEED)) {
>> -            if (pte)
>> -                    pte_unmap(pte);
>>              spin_lock(pmd_ptl);
>> -            BUG_ON(!pmd_none(*pmd));
>> +            WARN_ON_ONCE(!pmd_none(*pmd));
>
> Why was this turned into WARN_ON_ONCE? Would be good to add to commit mes=
sage
> what the reason is if it has been discussed earlier.
>
> The next line writes a PMD entry over an existing one =E2=80=94 that leak=
s the
> previous page table or PMD-mapped folio and can corrupt VA mappings. BUG_=
ON
> failed loudly and safely; WARN_ON_ONCE continues into the corruption and =
falls
> silent after the first hit.

Discussed here:
https://lore.kernel.org/lkml/c781ec19-724b-4c00-9ad6-56b9733cefa0@lucifer.l=
ocal/

But yes im more so on your side that id rather crash the system then
warn if we are potentially corrupting things in memory.

@lorenzo and @david can we come to a definitive consensus on this?

>
>
>>              /*
>>               * We can only use set_pmd_at when establishing
>>               * hugepmds and never for establishing regular pmds that
>> @@ -1313,21 +1305,24 @@ static enum scan_result collapse_huge_page(struc=
t mm_struct *mm, unsigned long a
>>               */
>>              pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>>              spin_unlock(pmd_ptl);
>> -            anon_vma_unlock_write(vma->anon_vma);
>>              goto out_up_write;
>>      }
>>
>>      /*
>> -     * All pages are isolated and locked so anon_vma rmap
>> -     * can't run anymore.
>> +     * For PMD collapse all pages are isolated and locked so anon_vma
>> +     * rmap can't run anymore. For mTHP collapse the PMD entry has been
>> +     * removed and not all pages are isolated and locked, so we must ho=
ld
>> +     * the lock to prevent neighboring folios from attempting to access
>> +     * this PMD until its reinstalled.
>>       */
>> -    anon_vma_unlock_write(vma->anon_vma);
>> +    if (is_pmd_order(order)) {
>> +            anon_vma_unlock_write(vma->anon_vma);
>> +            anon_vma_locked =3D false;
>> +    }
>>
>>      result =3D __collapse_huge_page_copy(pte, folio, pmd, _pmd,
>> -                                       vma, address, pte_ptl,
>> -                                       HPAGE_PMD_ORDER,
>> -                                       &compound_pagelist);
>> -    pte_unmap(pte);
>> +                                       vma, start_addr, pte_ptl,
>> +                                       order, &compound_pagelist);
>>      if (unlikely(result !=3D SCAN_SUCCEED))
>>              goto out_up_write;
>>
>> @@ -1337,18 +1332,27 @@ static enum scan_result collapse_huge_page(struc=
t mm_struct *mm, unsigned long a
>>       * write.
>>       */
>>      __folio_mark_uptodate(folio);
>> -    pgtable =3D pmd_pgtable(_pmd);
>> -
>>      spin_lock(pmd_ptl);
>> -    BUG_ON(!pmd_none(*pmd));
>> -    pgtable_trans_huge_deposit(mm, pmd, pgtable);
>> -    map_anon_folio_pmd_nopf(folio, pmd, vma, address);
>> +    WARN_ON_ONCE(!pmd_none(*pmd));
>> +    if (is_pmd_order(order)) { /* PMD collapse */
>> +            pgtable =3D pmd_pgtable(_pmd);
>> +            pgtable_trans_huge_deposit(mm, pmd, pgtable);
>> +            map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
>> +    } else { /* mTHP collapse */
>> +            map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd=
_wp=3D*/ false);
>
> map_anon_folio_pte_nopf calls set_ptes and modifies pagetable, while hold=
ing
> pmd_ptl only. It should be safe as we expect pmd_none. But I think you sh=
ould
> put a comment about this?

Yeah doesnt hurt. Ill try to clarify that.


>
>
>> +            smp_wmb(); /* make PTEs visible before PMD. See pmd_install=
() */
>> +            pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>> +    }
>>      spin_unlock(pmd_ptl);
>>
>>      folio =3D NULL;
>>
>>      result =3D SCAN_SUCCEED;
>>   out_up_write:
>> +    if (anon_vma_locked)
>> +            anon_vma_unlock_write(vma->anon_vma);
>> +    if (pte)
>> +            pte_unmap(pte);
>>      mmap_write_unlock(mm);
>>   out_nolock:
>>      if (folio)
>> @@ -1525,8 +1529,15 @@ static enum scan_result collapse_scan_pmd(struct =
mm_struct *mm,
>>   out_unmap:
>>      pte_unmap_unlock(pte, ptl);
>>      if (result =3D=3D SCAN_SUCCEED) {
>> +            /*
>> +             * Before allocating the hugepage, release the mmap_lock re=
ad lock.
>> +             * The allocation can take potentially a long time if it in=
volves
>> +             * sync compaction, and we do not need to hold the mmap_loc=
k during
>> +             * that. We will recheck the vma after taking it again in w=
rite mode.
>> +             */
>> +            mmap_read_unlock(mm);
>>              result =3D collapse_huge_page(mm, start_addr, referenced,
>> -                                        unmapped, cc);
>> +                                        unmapped, cc, HPAGE_PMD_ORDER);
>>              /* collapse_huge_page will return with the mmap_lock releas=
ed */
>>              *lock_dropped =3D true;
>>      }
>> --
>> 2.53.0
>>
>>
>


