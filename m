Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DB71CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 21:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CECEC6B0005; Mon, 18 May 2026 17:04:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76F46B0088; Mon, 18 May 2026 17:04:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17066B008C; Mon, 18 May 2026 17:04:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 98E836B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 17:04:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 47C501A0873
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:04:26 +0000 (UTC)
X-FDA: 84781768932.07.E4F6A93
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 463A818000C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:04:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iWsUhLJG;
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779138264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kcwTXDLiF4Lqa/MRkVJI3qKXXCJZGKAl2An41ihIRT8=;
	b=HnbU2XimUFrHegEiVBnNAN0Kw/I2RNOR2bsFOjBg3sNrV7BgVBO+T22FH38Oc2AA/eF0At
	xndHDveOHpd0jvZPk2YQ8/oGmvm7khKUnOnYlmAEjtwuz0t/6rkvH+cwN1FEUVWB9O8Tvu
	VosykejslyZylBnxgtYpL0HRoGFpGiQ=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iWsUhLJG;
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779138264; a=rsa-sha256;
	cv=pass;
	b=EO/EumFt9MM6mUlexBdqi8fH90Pk1G1+LBEkgKVgdFvx2iQ3eiBpzfjRHeKeYfmaV7xRfu
	xfV2Q/Z/oT2u7gZ9ZkDuFeuO0kLul0VAHNMNx3L3vdw5oaO5bnUocOaC5xgz089ltf5eMd
	oPu1JCFOlxvTXmMA83WLxvkufdrw/zE=
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-57524e52a3dso2409361e0c.2
        for <linux-mm@kvack.org>; Mon, 18 May 2026 14:04:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779138263; cv=none;
        d=google.com; s=arc-20240605;
        b=UeRK/C4S0R7QPqMSuhP3wt2rOcYPjNjFJlVjJtTY90nr/MmBqTpUSfQxXa6QIwVBct
         9i+1+Me/4Yxa6EpRrCbqRspSsGd54gXWkUjKQ//NLDx98C/shLsuAgSFuTiEe4S8Ie1m
         xHBb5ENFPUQ8y6LPBtioXxB/FsZMHUH40d+30TTPCbOnL4TUioLGjvHskt40SJE83Lld
         hiZSDKa+qcV3FDegF4Bz+mpUeCP+8qFvrn262Mp2nZwbqKNgYGMaALDEhllhDzSeYl+4
         IQy65Had92O80tJc1jiY1r9o56xIJ/o5h438ZLlOtDtI7B1DSabs4tjDGThC0x1ISa0i
         2FUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=kcwTXDLiF4Lqa/MRkVJI3qKXXCJZGKAl2An41ihIRT8=;
        fh=oZaY7oWvJJWt6FH6NUhMpfXRaqWKzkfRzE7pjgPk3VI=;
        b=cly6Q5vpmbXa+wmYnKKXY5HcNiDlFVKC3qkfqbJCnnWbcewdijwgxRPrH/9BcuSAnQ
         c+jttr0yaRdjJn4oGC+hJABbTjG8Uxh7lF5fkRws1bEe8joF2Y4eOfjhHnI46LjZQIhC
         /UTg2dabMFQLDwTOilVztMNmfZnu8qZoZj1MKsXTkXJcJAyacDnb1XKsX1VRn/2X5G+S
         k63U08nuDWU33krdOK+301VBCh2XWmlyNVUzxAOldecFw9M2/mLE89oMm236uRwmxhYm
         v/7MN20ZKmu2j3rHh4gVng2tWTTCcK0b46GF5I24JUWBzKScKbpEuLiidysIkDFWIgEc
         /gjw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779138263; x=1779743063; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=kcwTXDLiF4Lqa/MRkVJI3qKXXCJZGKAl2An41ihIRT8=;
        b=iWsUhLJGpoiKoFWnt4pOM7MZhpDropAzTGftmUJU9+qGZP3VYWqCgN0nNUn5CdL9C7
         2dmZA5OdHux4y+oWsu1AOUDbZW4hypT+2581R8qgGuAO1QDlZtjsBYrqe1Q5NpxMB31E
         WKPNMHc0DJhigcBF8S152aXg1BxQkzpCmOnNAHJ1O+JCZedG9llaaCd7F2mZMhxt6sf4
         jl5n3P0rVpthTfQpPm5wolO3wrK4cal6D6lpCnSR+b/xzODuGhrCTLWktFzvRPCoPkQ+
         oXNKGHYecza/MSd31XET25YHszzRV/qf5XlTCu3QQxwSes6LDYz8lPn7TSmlyA0q1T3c
         0L3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779138263; x=1779743063;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kcwTXDLiF4Lqa/MRkVJI3qKXXCJZGKAl2An41ihIRT8=;
        b=m+fMbG3QoxsKvFzPXY91k1a+RiWw0zEuBmxrQYLKVmRpYmAgfIUM5WLazUJQOGKG08
         iZ0ukmvRjt+JWgQ0poAdR+LezyfS3KR1BOpThY0M8i5MxRe3bxpVRKmo034YFn5ccMM8
         x3IoT+oP3htQkOskEtyFJcHtN653yubwZ0lbz/nxwA96YA+WHX38R7tu88QDD/mZ2weC
         ZwN/RJrmYmLxE5PWvQLhBa7NnyBsZXNL4+ykkcTOTd1mdV0tNxDHNkCTChR5VGr8ioHT
         OBH+GRP3e5kyy4FcyZ4hCrW15rwEVBE0amm/CJC/+Y7IWSJ1Xm2cl2g4JUd2zp+mnJ59
         XQQA==
X-Forwarded-Encrypted: i=1; AFNElJ9aiRIV9DLAWrveWvyjZiE6mMfEON0iZ/wY0LmK9QUDr5Bifgf0nA2dZ/ZcghxYR+TunAlUlnU6Ww==@kvack.org
X-Gm-Message-State: AOJu0YzEvnX48EcHGkFpytNWXoKaM1kNMenDeYl53Bamr/2gPT1AWic7
	u6n6x7liO0rU5xtcnEU0qVZFmrdIhlYB2IvWC1B9mWJpPiBBV9MDmHYs5FvebK+SKk8xBr5geaH
	H55Id6IYBYdJl6ObbLczvtRhSUNZjC9pmMAxuBjTy
X-Gm-Gg: Acq92OGowAUpWQqXO/RZtnbYCizULx0wSgxkPcam2vHkKHgfa8/z5oS1iKPfCeslrpK
	+T1ubJcIusp+KxsHk9goXSpqq9tue3iqIzby0vUp9LyK/plaTc3031mVsXNVsN/zQK+37slfBoB
	UcMwYbPrufTTTa79wSSA97R8hltbiBu0F5M33MzZZXViuAtQRtSzkeqRWlnSqXGQwa7re7RZQau
	lmBuFbIVRRTgbIr4SCstkyoAzEjwPPzA+dXCuum2fbKTlCppdfbdg2ne7A2lcFEfPIAeCJQKGmZ
	d3hjDolYw2skG2CLI3WNozvRzraWlbNLMYMYIFQ5K8baE0ysJMcJqOKzih63+nJ4SiFx6/Hgp8k
	IBs9f
X-Received: by 2002:a05:6122:d1e:b0:575:27de:3eab with SMTP id
 71dfb90a1353d-5760c057c54mr10430228e0c.9.1779138262674; Mon, 18 May 2026
 14:04:22 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 18 May 2026 14:04:21 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 18 May 2026 14:04:21 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <agqaUcVp_hwH-VXr@localhost.localdomain>
References: <20260506-hugetlb-open-up-v2-0-826a0c5f28fc@google.com>
 <20260506-hugetlb-open-up-v2-6-826a0c5f28fc@google.com> <agMqSlFloJJ22kgB@localhost.localdomain>
 <agqaUcVp_hwH-VXr@localhost.localdomain>
MIME-Version: 1.0
Date: Mon, 18 May 2026 14:04:21 -0700
X-Gm-Features: AVHnY4LgUbxphtOijZ8fuqgWRPYM2iVOTrAkNuSd7Um_bAaQ20qour3EKiImZFQ
Message-ID: <CAEvNRgGx2Qko3J3+zs2FWW-=OjH6nKBJ-xm5UZNHQxsywWPoiw@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] mm: hugetlb: Refactor out hugetlb_alloc_folio()
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>, Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com, jiaqiyan@google.com, 
	joshua.hahnjy@gmail.com, jthoughton@google.com, mhocko@kernel.org, 
	michael.roth@amd.com, pasha.tatashin@soleen.com, pbonzini@redhat.com, 
	peterx@redhat.com, pratyush@kernel.org, rick.p.edgecombe@intel.com, 
	rientjes@google.com, roman.gushchin@linux.dev, seanjc@google.com, 
	shakeel.butt@linux.dev, shivankg@amd.com, vannapurve@google.com, 
	yan.y.zhao@intel.com, Dan Williams <djbw@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: sf93wj9ebsf81ggic8kj7qff99w6b36p
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 463A818000C
X-Rspam-User: 
X-HE-Tag: 1779138264-671486
X-HE-Meta: U2FsdGVkX1/usW+u4NaEdAEis+OctaR+XaFJ6GpcyGPUJBHtOVTBmbNH47ERrez9vZh7yo2skeh6t4cnRrStIbhxoGhnKaPKiukoweJMl5VSMyWiL704B2b2vnLK9/JNfjQDl1YNWUYDfudQapTN/3A2CztCeWLrn1rqapM84AxCI0HziPl4keXRd2Veu9CwLcrn5kPJKVT4z4hcYYjwiam9XzSGEepI4Q7CSYNNDvDycp+aFf0DOhk6DhhGNZplEboB1k5akvUYSsQdZBj/YkQ9rPchHOlAc3M28PS4Rm3V1HH7NozAxEvU9kqTWzA3ixyNMKezCs7+aOSP8nZC6KazefFTYMcrj9lXy6vMOhQ4lsYoMyQz0D34bfMRBuehcf/v/4GpHZ3RM70GyzCl+elruruXECaQpoKuFr6Whs1W9OdzixhamA8n7AHhsal0sbxBXx6KF2WzRM8iJdSXgzO//IAoV9CAYUFHVYyzNY4LXooAdU7UYrWascUkMQkjtYYHBs+vpk8wBVF4IasNXGi8/q4cam0Patm0HaapDdRBZhELnXsQpd6JY0GGxPgdaYkD/q+Cq3MZJG43wgQmvMv8qf5aN9oaTS/avZT3A/JeRQi7Gp+kJ6vS68YT8AC1p+GICuWM0SyoIUYGVLFutnoKtDjwow5Boi9x72sQcCRzDe+1XjMFTd+qc5KJZgDMeCf43AuP3k+1T7nMue2TQibocDeuDEYBuwJUVnH3epeA139eeCur4N4ICKc27Rd5j+9D/7KfBOtwkqMFufYWrKMScM1Qh69z5zjiUfFx1zhSCEt0MDG95JLZ9C8s6xOCRco9xrN0PCDwb9ZAlG2eUiUo2CPeTSk8sYhvgJesFy9UxtWFjek+WEHqYuTQ6VgqAuO9+rLVoq1QpI7tGUiAcmHD/WIOpLKX9twMpCj0qMVNx4EqNzqAw6Tf6lhg3QZ+n7OCbe1As6z7c3I+kHD
 6R4FPxSL
 8C599dnmUdyEhYSwLsMs9LcYyjlmkQuIvZmsn+9YhWEGJzEXMYJts2l42DpAF/mG2uzb1gBz80z2q2TAHmm2rbKZ9i4w8c7qi/wqi2jU3CUZ+2wgmWXOY78ID3coLCv2Bz8t/oZp8bZ1kKoSTK7CfiBRpcDCIuP5SdN7x2/GGB+jpXxv4DZO9nwhWjWbSHrqZVnFqBGDi5T9Q4pvFZbvKlVkTJ3a5Nd05zBePUCMxyJ6qKRkKptyuRE4CNSpbvd0aKeNiDBjhMiX5TBmkrNABCO7kQOYFev8trWd3lx39OYHjlTfMxEs5ScgPhnkYVytewrHHKWrka6Nnn5kS9La6Q8Jcll8FYppc2NTgG/VFvRNofNFdgXwx/LHuTweu425TByp/0yU3hrBOWqmD7gYQc8dCERhTAOubrzRcyrWfz0Mduwc9s7QfOGp0Jk8CEGWXkW4GklYRyKOq9FpZNVJFlf57og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Oscar Salvador (SUSE)" <osalvador@kernel.org> writes:

> On Tue, May 12, 2026 at 03:25:30PM +0200, Oscar Salvador wrote:
>> On Wed, May 06, 2026 at 08:54:42AM -0700, Ackerley Tng via B4 Relay wrote:
>> > From: Ackerley Tng <ackerleytng@google.com>
>> >
>> > Refactor out hugetlb_alloc_folio() from alloc_hugetlb_folio(), which
>> > handles allocation of a folio and memory and HugeTLB charging to cgroups.
>> >
>> > This refactoring decouples the HugeTLB page allocation from VMAs,
>> > specifically:
>> >
>> > 1. Reservations (as in resv_map) are stored in the vma
>> > 2. mpol is stored at vma->vm_policy
>> > 3. A vma must be used for allocation even if the pages are not meant to be
>> >    used by host process.
>> >
>> > Without this coupling, VMAs are no longer a requirement for
>> > allocation. This opens up the allocation routine for usage without VMAs,
>> > which will allow guest_memfd to use HugeTLB as a more generic allocator of
>> > huge pages, since guest_memfd memory may not have any associated VMAs by
>> > design. In addition, direct allocations from HugeTLB could possibly be
>> > refactored to avoid the use of a pseudo-VMA.
>> >
>> > Also, this decouples HugeTLB page allocation from HugeTLBfs, where the
>> > subpool is stored at the fs mount. This is also a requirement for
>> > guest_memfd, where the plan is to have a subpool created per-fd and stored
>> > on the inode.
>> >
>> > No functional change intended.
>> >
>> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>>
>> I yet have to review more thoroughly, but I have a comment below:
>
> So, I thought about this some more and here it is what I came up with
>
> - Ideally this new hugetlb_alloc_folio() function should be as generic
>   as possible to try to fit other users in the future

Yes, glad you agree!

> - I would create a ctxt struct to pass all the parameters

This is a good idea, I will do this in the next revision.

> - charge_hugetlb_cgroup_rsvd and use_global_reservation could be a flags
>   thing (action_flags?) within the ctxt struct. We might want to add
>   more flags in the future to tweak the allocator behaviour.

I'll give this a shot in the next revision.

> - Ideally gfp_t mask should be created in hugetlb_alloc_folio() and tweak it in
>   there before being passed down the road, which means do
>
>   gfp_t gfp = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL)
>
>   in hugetlb_alloc_folio() instead of doing it in alloc_buddy_hugetlb_folio_with_mpol()
>

I think gfp can be in the ctxt passed into hugetlb_alloc_folio(), but
alloc_buddy_hugetlb_folio_with_mpol() has a different gfp from
dequeue_hugetlb_folio_with_mpol().

dequeue_hugetlb_folio_with_mpol() just uses gfp to select a zone to
dequeue from, but alloc_buddy_hugetlb_folio_with_mpol() is actually
doing allocation. Later in hugetlb_alloc_folio(),
mem_cgroup_charge_hugetlb() uses (gfp | __GFP_RETRY_MAYFAIL).

In the next revision I'll put gfp in the ctxt struct, which will just be
htlb_alloc_mask(h), and I think the other functions should modify gfp as
required from the ctxt.

>   As of right now, we define it in four different places:
>   hugetlb_alloc_folio, alloc_hugetlb_folio, dequeue_hugetlb_folio_with_mpol, and
>   alloc_buddy_hugetlb_folio_with_mpol.
>
> - I think we could strip _mpol from both   alloc_buddy_hugetlb_folio_with_mpol and
>   dequeue_hugetlb_folio_with_mpol, and pass a boolean "node_preferred_many".
>

Will do.

>
> I am probably missing something but I cannot remember it right now.
>
>
>
> --
> Oscar Salvador
> SUSE Labs

