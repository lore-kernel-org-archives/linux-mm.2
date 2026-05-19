Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20BECCD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 18:25:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B6316B0005; Tue, 19 May 2026 14:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 666896B0088; Tue, 19 May 2026 14:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 506A46B008A; Tue, 19 May 2026 14:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B5266B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:25:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0856D120875
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:25:40 +0000 (UTC)
X-FDA: 84784997640.15.48D1D6F
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 09BA24000D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:25:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kuyYYcKo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.52 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779215138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQWQtoOkp+8KFknC3n18YYYjw5CoEEKJDAVDWQGGhAM=;
	b=kk1S4ss0mYIS1/cBaLw+64weAXi7ToIXd6Ty5eAnFWr7UU5GNm2bdmN4BsMKIQHOyXA3i7
	QQylhcy+IpC3IzYWdYu0udkpgDP6B6qMsor9sRD7KJVRTevgCqABm2ozbdtsdFFr8DYdr8
	zOYTnLlyoKT5hPR8RimsG70QIsvFxrk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779215138; a=rsa-sha256;
	cv=pass;
	b=OrJv3h4AJebapTkMuiIikzjx2SoXhD9Qm5tUFPGvPlANwxGY/Q9PP9LUo4kKkechfiydit
	ChS0gzS8JK5CyLMPmcPbyg3R6DnN2F9Ah1MWpfpmAOLW+NLTrK0nfCKtVtiPQZ7ygIWGcd
	GNllii6rJajt8kTDRSyhwGo01tP+MQo=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kuyYYcKo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.52 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-95cc8ac98bfso629548241.3
        for <linux-mm@kvack.org>; Tue, 19 May 2026 11:25:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779215137; cv=none;
        d=google.com; s=arc-20240605;
        b=CDtbaGqFUL5yiWwYKo4t0Xt7HbIJcsfbNVCXKZaRtqCi0fEg3czYav8CnDe66uCv+0
         +smqs8pSRlVsvx6ldIFWjMXm2pb4jJIyMLbUGVfV33/bDdmPWSsh85iq66Gkl4oHD/qL
         go176b8DNWXyouZ+6/8bisQJAfK5NFA0KvbYbSrUqWoAJmFcQPZiXBdra8posSJ5dK+R
         68gXORhPymOhViGe1uHuuIk7Sjzw3b65aHualrzUVZVVUNv59ePwwG/5CA6lMDMlxwH7
         6jlwes+ZHk/N+a197JlxjcZDimlKmJR8qmPpHXGWHVtV2NJ/r6u3XsDJuYoBZjvQJ4Lf
         lGhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=CQWQtoOkp+8KFknC3n18YYYjw5CoEEKJDAVDWQGGhAM=;
        fh=5+4w6h+0k8OfExcrCZ1Ds5ookAaaW0tC2RnmsRknrB8=;
        b=IIymXQx9rqahbqstx5F4DoaoScPj2G/LJAjaJISmYtMs2P75Bxvl/j62Ha1pI1ZzM+
         mVnXEhQC48UbZYbXyLhVvr+xqXkwEYj2xbqyJv+dg3J+/uekDLJKQT4jv1Sc2BrgIK3N
         NP8aXUT7gWjbd+rId1IOw8K8FTyVJQQuGQhfwkxM22wOw8w/+6/vrFkfkoqk1Kw7CHpC
         NOqo2TW1vm31hqnQ//H1TEGC2tCdbQzi5u8aGiLEQWfGN8sc3SAKXDEw1blmh5ch74BJ
         UNb/sLfHwJjb5iNLO5fQ7xO7EthQgq8xcZuWlC96XK3uY9Nv9Rhro+2kjgMCHiDtcLL1
         wV4w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779215137; x=1779819937; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=CQWQtoOkp+8KFknC3n18YYYjw5CoEEKJDAVDWQGGhAM=;
        b=kuyYYcKoHK8+DSLKxzBkX5BhayOHDkulc+qMmWTGkJ1Iak7Bu9PTEQe6c9RTe127Uz
         rQMGqJOY7NMTIxToAcet8zk9v0JD6z2l3EDSrLwH4TeCD3Ts8GCJLlrXtmi+W7J22cOq
         oT0I5hxR1Dh7wIROBEx147tZSXMqETU9RiXJE/3hSPDNMLEBApoAc8vEmNG4ipO+InNj
         EQu9+jBkOTT7lq5yzZ2m+xTMe+9QKOOJDhDOmGDh8ysdcOTARUQCSl5Vnc51EnRVNuuY
         HRQANZhoBIv+aVu9rrZ2Q3yk9yAJgHt0csYYrzu/0uKU9dlIkLMRXqgN9sOe5xjQx19n
         YH0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779215137; x=1779819937;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CQWQtoOkp+8KFknC3n18YYYjw5CoEEKJDAVDWQGGhAM=;
        b=coUuKWJ2xlE56kEqnr4JdGsJfRgMeTIWleToaKptu6RncEsyoHAPy1nly8LdzVBkpz
         EAAR3g2zzMMKW5g34UIDpVOBYS9GX5OH2lYf+xZKEqnGTSZnZxBhRGB5plmSJT7RswfB
         4xW+YsAVW7db4ARDeFvjrpG0GcAHETuQZ9JR8u6+72ZCWBkKE/5NY47uHeF15h/Hvlo9
         qiJ3UcmAsyXnuBwTqwzR2GSEpfBcTgoCGjgC1zcsOkyftSWzh0WQRYPhhIAePhB21pr+
         1+VZFQnOyCTwWfa5E5Zkb9dEg9rK2NTACo/Th1zLWQqdou0v3RsBGvHewAxS/rpnfJwf
         OAHw==
X-Forwarded-Encrypted: i=1; AFNElJ/i4v3O7R+tKRkH3G/QDgwg3BSHt0hKOCDjUT7ob+J2Y69+aSzqwzOsLNp7txWoF4egKX1Ft1+SDw==@kvack.org
X-Gm-Message-State: AOJu0Yzh6Xv+XTTKJMsJbhJh/cFaWKJJs3BbvRXLCqTnbG5gzQjKLhVH
	K0Kt9vZpbMy2wvSFD6V1D5/rBQuf5wrdnKJQrFfIJ7+Yu0tS/vU+hRYrjW00czD7bulh2UROCjo
	Uxsv9Crq3gVjkZVcEnN6QbCt63lix2y/tLVkaLLx4
X-Gm-Gg: Acq92OGOgr0DnJrZt2gQ0HTstm5pcFkpmS8BozNghBAvaqGjfEKEO3QkhjC2njlTLbl
	cfNQKkWAkpWSevjOqkz5fY5zHlyoa+I4/G3iOw28LaKt07Yqfu/RPqfvXY+22hOOHs2Vqjx0uXR
	faRKext1OhiLMPEodoajRnVxvu5s+VeJouO/atIQ9obq+91JZj1/wkUpumbbKOer0v3ck6pghzI
	l6Gi7viMgj98Z5hYcQG9Awtusn8OrRXy+BJ7O5we8KazYODidRyj/PKvA+FLyIssET5MkD6JtjD
	UpWhNuE8T3XuE6srQnnyaH4/3AU5WEWjoK9F8sXcw6xKH7x+NgrwxmAz5xAXssZCdeLoyxlwx+f
	9AwmZahUEDLp6SDQ=
X-Received: by 2002:a05:6102:2924:b0:633:75d3:3545 with SMTP id
 ada2fe7eead31-63a401a6ca8mr10296479137.30.1779215136180; Tue, 19 May 2026
 11:25:36 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 19 May 2026 11:25:35 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 19 May 2026 11:25:35 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <agwab8q-C2ZetFOJ@localhost.localdomain>
References: <20260518-hugetlb-open-up-v3-0-e14b302477f8@google.com>
 <20260518-hugetlb-open-up-v3-6-e14b302477f8@google.com> <agwab8q-C2ZetFOJ@localhost.localdomain>
MIME-Version: 1.0
Date: Tue, 19 May 2026 11:25:35 -0700
X-Gm-Features: AVHnY4LQkvIBKYTeLddbnZXgv-JFa0YHmPLh0IpJL-FNBklMx_jT8ZjybJ88rqs
Message-ID: <CAEvNRgHe+dwvH-AyexfvUBmq22Pxss1j0cwMZA-vxrrMEP6ixQ@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] mm: hugetlb: Refactor out hugetlb_alloc_folio()
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com, 
	jiaqiyan@google.com, joshua.hahnjy@gmail.com, jthoughton@google.com, 
	mhocko@kernel.org, michael.roth@amd.com, pasha.tatashin@soleen.com, 
	pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roman.gushchin@linux.dev, 
	seanjc@google.com, shakeel.butt@linux.dev, shivankg@amd.com, 
	vannapurve@google.com, yan.y.zhao@intel.com, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Dan Williams <djbw@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 09BA24000D
X-Stat-Signature: 1nndnfo8h5eq8xgz94y8sotifyrg591a
X-Rspam-User: 
X-HE-Tag: 1779215137-443416
X-HE-Meta: U2FsdGVkX184nLxBX91gakoMRF/HQ78irVJeaiZp2djvlYPFLCvGXNxrK/1uZUS3XRaYy4eUHd5rNafLJdifqlr00bDr0JvaT2duyo+v8fTAOY7WG2iis+pooQHc6aVt+ZmR6d1zKTbACKjQ5eEmW/tRo7dsY+OhHQe6+tg3bIjsHEQ6wXRe8BxhODSTiQ2qxOyfRwlkbERhofZ94pyE02voA14t3OUG870JU0AIiApC6+CBLr8/IYP+a1jPW7jExSLDdUcfbzD3mEr+MyEze4DjUJz9xwGLCTcy81JIOQMsYTxlUQCNje2DM9PYAoQl+ac30uOFQpuuSjFxf33YzcBbtKnsXRWZudSmiuAZF8rlVLOYLuRLFxk/sdcTMy/+Itns7SldHjxt0vTdE1jOCdFGDcszIa/7sZipLB1nOcPzzuCdKX1ipBdLyUFpat/Zvg4l1p4dU+keX0HYBF/Td5KzXjKCW7PIDlUA1NfNSSx2Jo+8i90BVAVPyM4bv5M4gDg8SURNOphe5rFkKJIctP0WDzBPhjfe9KqyAMl2pNTRZ5nuIFY3v5PJM1sxSGafAzNVhHJIHj/Z/Ok7CmyXFMgEW4cjQzXmpmROU2XWrE7XanD1qNavNW6aZoOgyXGs+igImc0g0uKpfsq6PURkpUyMj3Jm+AlfaHZM+8s0IXKhwZh0qDmoyqTn44o6CfmQRohiV/u4A4+GDQ3DiZ6u2r2DpQ+Mo7oltwmAy//bwk9lqw8Z09A+D9+P9ouzPDxWUWveN5o9h5Z096f8OH/EpVQI9DDV8sE1oG7JxlRg1q0XkARx0igWqNitEbf3v9eJl1w54+dc/Qq0FQqtZ4AUBaCYqmeH+0P3r+R0k1FjI/iTkdv5NmuAF24L8G8ZksImJ8RJZ+FSd4Sc+wb3rKZUqJi3VUXxWYmufcqPAMIt7y1QJXf/dzSP8D9u14MxrESkPeAlh/+htwHpi6DNgX6
 jyfF4yZN
 2gEUjW90EgtulimvxwK7Lq3ZgGDmX3t2WkXLZd/fO2O17VXOVw3da5u2E4G/rjwoaZH5HuHT8O9xFmvqGo60lrJ5eEA8aiaTsVGf0JK48B6Qadg3INfBbk8brm4opxJpYAZDdNEF9L3IHnPQqScJxfH0S5IbDdyZj+f/LW76c/r7H4G7tJ7K7gbhUVRHx7HEmrwcUcO1wI9M1u+wCh46rOBovzqyI4bkGJUAVV3JLQ3v7YEiBBn8qGHbFyOt+rUBGmAb05aZ7bph+2PQVLfWhiiJZb2FTCfsFna16i1ES035wS1cQ445HZnLvEr5mapYW6/BwCVuchkHFgPh7ce1a2LdxgQJwGK0sqPwFwzOqUCFC9T7gHB4eaC9c8xXNzp9y+qX1fxoMX1jrDsymMMN7FeDSS7Z5RC/+BzWdgNkJ4l25H9UR7tNao+1SAuHhR49k/d682ipOXaXjVwo9PeG5qoxlIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Oscar Salvador (SUSE)" <osalvador@kernel.org> writes:

> On Mon, May 18, 2026 at 05:19:45PM -0700, Ackerley Tng via B4 Relay wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> Refactor out hugetlb_alloc_folio() from alloc_hugetlb_folio(), which
>> handles allocation of a folio and memory and HugeTLB charging to cgroups.
>>
>> This refactoring decouples the HugeTLB page allocation from VMAs,
>> specifically:
>>
>> 1. Reservations (as in resv_map) are stored in the vma
>> 2. mpol is stored at vma->vm_policy
>> 3. A vma must be used for allocation even if the pages are not meant to be
>>    used by host process.
>>
>> Without this coupling, VMAs are no longer a requirement for
>> allocation. This opens up the allocation routine for usage without VMAs,
>> which will allow guest_memfd to use HugeTLB as a more generic allocator of
>> huge pages, since guest_memfd memory may not have any associated VMAs by
>> design. In addition, direct allocations from HugeTLB could possibly be
>> refactored to avoid the use of a pseudo-VMA.
>>
>> Also, this decouples HugeTLB page allocation from HugeTLBfs, where the
>> subpool is stored at the fs mount. This is also a requirement for
>> guest_memfd, where the plan is to have a subpool created per-fd and stored
>> on the inode.
>>
>> Provide and use alloc_flags to allow more allocation knobs in future
>> without expanding the number of parameters in hugetlb_alloc_folio().
>>
>> No functional change intended.
>>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>
> I am traveling so I plan to do a more careful review in a few days but I
> wanted to do some remark:
>

Looking forward to the rest of your reviews!

>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
> ...
>> +struct folio *hugetlb_alloc_folio(struct hstate *h, struct hugepage_subpool *spool,
>> +		gfp_t gfp, struct mempolicy_interpreted *mpoli,
>> +		u8 alloc_flags)
>> +{
>> +	bool charge_hugetlb_cgroup_rsvd = alloc_flags &
>> +					  HUGETLB_ALLOC_CHARG_CGROUP_RSVD;
>> +	bool use_global_reservation = alloc_flags &
>> +				      HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS;
>> +	size_t nr_pages = pages_per_huge_page(h);
>> +	struct hugetlb_cgroup *h_cg = NULL;
>> +	int idx = hstate_index(h);
>> +	struct folio *folio;
>> +	int ret;
>
> IIUC, hugetlb_alloc_folio() will be the gateway function everyone will use from now
> on to allocate hugetlb pages, that goes for hugetlb itself and external users like guest_memfd.
>
> The gfp flag should really be defined here, because otherwise you are creating openings for
> external users to start passing their own crafted gfp flags and that feels wrong.
> Sure we can guard that down the road but we should not really need it.
>

Makes sense. I'll define gfp with htlb_alloc_mask(h) within
hugetlb_alloc_folio() instead of letting gfp be a parameter in the next
version.

>
>
> --
> Oscar Salvador
> SUSE Labs

