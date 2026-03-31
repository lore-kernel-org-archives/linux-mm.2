Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32C8610F9302
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 21:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C9836B0092; Tue, 31 Mar 2026 17:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A10B6B0095; Tue, 31 Mar 2026 17:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B7D16B0096; Tue, 31 Mar 2026 17:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EAEB6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:50:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CAE911A0414
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 21:50:24 +0000 (UTC)
X-FDA: 84607702368.11.8558AC6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6B5001C0003
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 21:50:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EYnsTZxF;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774993822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RH0RP98VaY8YObr2bBExt+Mj22wNQxUlH2/ulOuqVJQ=;
	b=hlWx+BgRXD4ddts+bV+yS+FhUoaPvc6TrIrFxpnTyR11IaWvLFDRV62kOxqBtjUgNtMEmS
	faP92zrheXKWTATkHcaHb7YR8gSHwdAZi2kdsAr98v4uTwEvGeCZ4v/WeMpXAgZ3GeTJ17
	nURKJ95UEPkcxnfFHynq0HZOZm4b4mQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EYnsTZxF;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774993822; a=rsa-sha256;
	cv=none;
	b=C+mMc4kbMHRkvumtHghJx2c8z6AtsRNu0U5YJJhR+5Pzls9P4j1JXXvKkzbfpxjUbCf2UE
	+Fzb+4YCT/5tlCt6ySeuei1UnBHegjl7JqEbRw0W+91OhS/pBDX8yiE77vfxtcI/kFnsq2
	q2HW+yODeC4rUscb/Uxh7s5jsOVxoS8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774993821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RH0RP98VaY8YObr2bBExt+Mj22wNQxUlH2/ulOuqVJQ=;
	b=EYnsTZxFp5A7YIJUUteubIU2nYST2Wq4yQg/AJ5HvoL5xDj3RlvqKU+ttx3jbxVKt7Dx8U
	xuNDXgf7zVQrc8fO97ajbdtJCMdF4SFa0+kyuUe5f8X5TukNODTqwNVPwBhvVZ9EAhCiYf
	a1zKjQJU3QtU3kkCvFXkYZylbZ1lXoM=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-yq3fJnR5O7a09NEeB1Z0ew-1; Tue, 31 Mar 2026 17:50:20 -0400
X-MC-Unique: yq3fJnR5O7a09NEeB1Z0ew-1
X-Mimecast-MFC-AGG-ID: yq3fJnR5O7a09NEeB1Z0ew_1774993819
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-79064868702so64035187b3.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:50:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774993819; x=1775598619;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RH0RP98VaY8YObr2bBExt+Mj22wNQxUlH2/ulOuqVJQ=;
        b=QzL79G0WZllSasaxx+tbQ7GdtCe9bceK8NuaQZqwmU+sEdMMyHjytUpAerbp6OPn75
         S9IU1vj29uIblxeAb0zUpZ0eJxpzZQJpdjE8lgpdtatooD4jcWeCCLciB72lMn1qmIKW
         ZfDwSEvKH12UXX9zJeAalP+u1ot9u81XifiHkmiJBHT5sZCa1UCQB05AckulCLWH2+ux
         kSmZo+tm9I976N8Lt3RKGI6Zqumtw7bV0VIgiVu4c0iO7diGi/8FyYTDRih0qhhlBchG
         7glds+fagj9wmL7rGFR4O3ybGLCi0Kfg62f9579wxrvJu3hZt5XzRVpWvFv91ZE9cEam
         px4A==
X-Forwarded-Encrypted: i=1; AJvYcCUYYcs2RNkkSr7HWQYggm9IfK3jZ7a6zlhjy8MYiZfy/BdTnlrruBb+qAgOjL/kRlBhCJz/9qYKNw==@kvack.org
X-Gm-Message-State: AOJu0Yz59pSuor8DV+Qg3uTqkGeXPcbx/dpGZN8kxq5aFEqAyw7+8LuE
	v5oZNS83UM5EW30SyxvQnrDmN6uvroUTys5VQMUyxRAz9hQ3RZ2rZDAkTOT1jq1MQwb6IPEJDO5
	IJA7F4xhzcg1fZjZqHhnm0VXRhjpezWC/jskcvdNhx5QXEQfkZ2rL0t2KJ6kZcxTTep4ibDeVWG
	mV5TH4nbdXUwwCGF63MYAPv5fxXxI=
X-Gm-Gg: ATEYQzyp04qMdl2JBB/Sm5Noukg5RVU1p+GCWsazFRBh/BxAHNr85ysGBoegfFKIf1Z
	BBJR0N7MZVTzM2ZaTtHMoA9szyoaEUr1thJg/P09xDIG22EPp3IpvRkscGIaWcUqzzAiKeUSnOx
	sXSga1hwQ7+stibazH8vXRO4/99Dz0BTqdBXby05/pdaOk88NWoefX3N1XJyNq5xubFEpPyPQs/
	RjrJ4Yv
X-Received: by 2002:a05:690e:148b:b0:64e:8d59:c495 with SMTP id 956f58d0204a3-6502fda4ae5mr1023501d50.12.1774993819437;
        Tue, 31 Mar 2026 14:50:19 -0700 (PDT)
X-Received: by 2002:a05:690e:148b:b0:64e:8d59:c495 with SMTP id
 956f58d0204a3-6502fda4ae5mr1023454d50.12.1774993818970; Tue, 31 Mar 2026
 14:50:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260325114022.444081-1-npache@redhat.com> <20260325114022.444081-6-npache@redhat.com>
 <7760c811-e100-4d40-9217-0813c28314be@lucifer.local> <0223d45b-e8b4-49a7-882b-477250d0c14d@kernel.org>
 <fef63b28-a364-4e7c-bdbd-6d0403632920@lucifer.local> <26fcec86-ee78-4f5c-8ca5-0e6230699cfd@kernel.org>
 <20260331143538.f41a5fef4201a7384388f31c@linux-foundation.org>
In-Reply-To: <20260331143538.f41a5fef4201a7384388f31c@linux-foundation.org>
From: Nico Pache <npache@redhat.com>
Date: Tue, 31 Mar 2026 15:49:57 -0600
X-Gm-Features: AQROBzCN1zPMbFfCXPwf3VJtMbUnyB1DIWkkVjEwMoKr-Y8KXN6aPAXDDQHiMP4
Message-ID: <CAA1CXcB8D9o=5EC2dbL8N=o9p2WqrHnugoGYmwUvLh8n=w5p=w@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v4 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, aarcange@redhat.com, anshuman.khandual@arm.com, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, jack@suse.cz, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
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
X-Mimecast-MFC-PROC-ID: 4ya-b58iMmROtmyPQE-3rst9xPuCIX4cD2DIGnDQ1As_1774993819
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6B5001C0003
X-Stat-Signature: kpz9gyy8frhca8me33h95a6z3sanobz4
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774993822-888005
X-HE-Meta: U2FsdGVkX1/biCWwcioJN9al67xhgu+nI/4p+3slTuqtuSa06hpRp0zBWQfDwSMfj4kj1uPIiOevFdtJnzbLjZkQVgu2Pzu2lVGyFDQced/7YGzuzTHC/ciO1Xu3Ch4g4WSmHjM+VkQd52E91fqDaCrmFuskuHQIxoYB3t4GTzBvbYNUm57q1lPaRQ7TpqV/s8DXfw4QspY3GhZiewndsmU8/HgBAJQ57f98ATeb9dg+DRu8udpIDgwqBBB43kwzLvuyTOQPFPaMMfm9b6gediQ+t/xAoPE/s4BhU0hZjVemuF+lVWs17I4YSf2G7BHSKjcdlPfrqiYUDPpjWEIhsYhuwthIf+Fd+/s+X/vOopAOaoqrfLhmQcaw/XlJj7Mca4iLFr4EVCX2WabLCnc18iG4xDtAAoZ3IgOlJ8KaeRSgcj9op/SxNjQir0bd5wepIr0v99pFGsTssc6rDHTV40yr3dWo7KkmETR0dPVwHCTLFggWoy9lfqbDXYqFa0hK4iHbTjOgsRyC8wAL/QqubZANm9GfuD/TkuKtfnU4iT/93CjKhxGoConz3pdILOAc6RpDcxm/mtDa40fd1zNFGM3RB57SWBTCS7xT+kwTngGJnYgdIEmPa5nu432+GYC49/SG/0w1qMidRq6jjOPjQf/wsKLz87yvQ44FWVrZDgQsALLGT7ZTtOCA58HnCZLyPg7jnLW2RMhhkPK/jCP9jzqW5yVCoV1UADXWwXtfWFRgGqR932AuLyvQcc609HDm/JLno8tok+uIy5qLvAtc1+DfE5KmPkGuTLITMoyQ/hRnmXrsEQJ2vdQyp+t4eXJhL2S9Wipiot/QNkDxDKlNhXMDGwLjSTA78vBiK+VNc7tqH15cnGKlkZXSBbihKHl7/8B/V/MSRxoDZ55Lk1icVZTws3t4/2f4Lj+ZIodqwAHhhJYmJypo2shVAlYuiuX2L+DT4pteLt3+9/hoR6q
 9B8nFPlu
 JfR+p8jBHi2d/lgl8QJAp5x/0jWCp00supcJjonftpoaGj6WhdgQh3a/7L7fJDmzTZ0db+HC01UleZTKr2ietmt37Ikvi3umjYlhfEyabXzQHx8FuwL0n23Vz81x4MV1QBkpRWbfOu/1Wned/piM8p0lykR13nHqodBdFphwAtG8QEjpVLoXpKRpaqnvKazmsH4LSbRO8p65XDvgJVqAtDiMVa6vQ81ulhtBqsZ46ZJ1pWdqT51W9ov6iqgeIjai/MST2KLtxVaEXrYuyQe6SY+HE06yu/3VSPN8FynR1dTUXgNnRKmIQXAiwddbpYjNNAqdK54ZSURK3aTRtrvcqq7fJjqqX9M6aLvD4B4ROeIMUGzZbK28OmIc2xCOEyQYidB9MToXaVuciEoiX6/D3Qjb3FPqnIKGV5AgbESEzimc8bwp1lOUeSJmoo6nm3MYDiGu/PxUYUeKhwRkDP3dGcIyByFr2Ie9JdrfHHRwDRKSNt1qsjYg3sukOVG3n70sBMF8Pd0kujP84P0JZaczO8GxVyIosKgiHdSqHJrH4dBoETzI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 3:35=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 31 Mar 2026 22:00:58 +0200 "David Hildenbrand (Arm)" <david@kerne=
l.org> wrote:
>
> > > out_maybelock:
> > >     /* Caller expects us to hold mmap_lock on return */
> > >     if (mmap_unlocked) {
> > >             *lock_dropped =3D true;
> > >             mmap_read_lock(mm);
> > >     }
> > >
> >
> > Right.
> >
> > The original code used
> >
> >       bool mmap_locked =3D true;
> >
> > If the fix get squashed, maybe we should revert to that handling to
> > minimize the churn?
> >
> > (this is not in stable, right?)
>
> "mm/khugepaged: unify khugepaged and madv_collapse with
> collapse_single_pmd(): is presently in mm-stable.
>
> Doing a big rebase&rework isn't the done thing, I believe.  So queue it
> afterwards, add the Fixes: and tolerate the minor runtime bisection
> hole.  It ends up looking like a later hotfix.
>
>
> Below is what I added to mm-unstable.  I added a note-to-self to check
> in on Nico's question at
> https://lore.kernel.org/all/CAA1CXcCYLGQBy9nT-MSTPVK=3DXgWWtD6Af-QiA_6pXt=
M_2pybPg@mail.gmail.com/T/#u
>
>
> From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> Subject: mm/khugepaged: fix issue with tracking lock
> Date: Tue, 31 Mar 2026 13:11:18 +0100
>
> We are incorrectly treating lock_dropped to track both whether the lock i=
s
> currently held and whether or not the lock was ever dropped.
>
> Update this change to account for this.
>
> Link: https://lkml.kernel.org/r/7760c811-e100-4d40-9217-0813c28314be@luci=
fer.local
> Fixes: 330f3758a3bc ("mm/khugepaged: unify khugepaged and madv_collapse w=
ith collapse_single_pmd()")
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Nico Pache <npache@redhat.com>
> ...
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/khugepaged.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> --- a/mm/khugepaged.c~mm-khugepaged-fix-issue-with-tracking-lock
> +++ a/mm/khugepaged.c
> @@ -2828,6 +2828,7 @@ int madvise_collapse(struct vm_area_stru
>         unsigned long hstart, hend, addr;
>         enum scan_result last_fail =3D SCAN_FAIL;
>         int thps =3D 0;
> +       bool mmap_unlocked =3D false;
>
>         BUG_ON(vma->vm_start > start);
>         BUG_ON(vma->vm_end < end);
> @@ -2850,10 +2851,11 @@ int madvise_collapse(struct vm_area_stru
>         for (addr =3D hstart; addr < hend; addr +=3D HPAGE_PMD_SIZE) {
>                 enum scan_result result =3D SCAN_FAIL;
>
> -               if (*lock_dropped) {
> +               if (mmap_unlocked) {
>                         cond_resched();
>                         mmap_read_lock(mm);
> -                       *lock_dropped =3D false;
> +                       mmap_unlocked =3D false;
> +                       *lock_dropped =3D true;
>                         result =3D hugepage_vma_revalidate(mm, addr, fals=
e, &vma,
>                                                          cc);
>                         if (result  !=3D SCAN_SUCCEED) {
> @@ -2864,7 +2866,7 @@ int madvise_collapse(struct vm_area_stru
>                         hend =3D min(hend, vma->vm_end & HPAGE_PMD_MASK);
>                 }
>
> -               result =3D collapse_single_pmd(addr, vma, lock_dropped, c=
c);
> +               result =3D collapse_single_pmd(addr, vma, &mmap_unlocked,=
 cc);
>
>                 switch (result) {
>                 case SCAN_SUCCEED:
> @@ -2893,8 +2895,10 @@ int madvise_collapse(struct vm_area_stru
>
>  out_maybelock:
>         /* Caller expects us to hold mmap_lock on return */
> -       if (*lock_dropped)
> +       if (mmap_unlocked) {
> +               *lock_dropped =3D true;

Hmm this was =3Dfalse in David's example and =3D true here? Now i am also
confused hahaha. It seems Lorenzo's code is correct. I think i
responded to my own code changes, when I thought David was replying to
Lorenzo's.

I think we are all good with Lorenzo's changes.

Sorry for the confusion

-- Nico

>                 mmap_read_lock(mm);
> +       }
>  out_nolock:
>         mmap_assert_locked(mm);
>         mmdrop(mm);
> _
>


