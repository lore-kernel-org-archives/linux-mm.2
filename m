Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A52CCCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 17:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E14678E0005; Fri,  7 Nov 2025 12:14:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEBCF8E0002; Fri,  7 Nov 2025 12:14:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D01228E0005; Fri,  7 Nov 2025 12:14:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE5DE8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:14:42 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C5C0C04D3
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:14:42 +0000 (UTC)
X-FDA: 84084460404.21.BACD568
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id C6CBD12000E
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:14:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OWYsVaza;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762535680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lsGhcNk2ubFrqi2YFZgLMZLjo4nT4sZ1uICkDs7Vo+k=;
	b=jR9OL+VnmXmTflAkBoT33hDIPybn8ePbJ4Mw1RUUCeskSiyLSuGNf+CbTFbf6LuiW/d/xc
	9PUjbLLVRmDNU7ES2L2xtyhLi1NWoUrtbsHc+iYFntiA9rELmTS5zDHsVm9YWPhsl3eYlh
	B/DFnZI9kqeIJb+rgcw0oMWH6o7mn7I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762535680; a=rsa-sha256;
	cv=none;
	b=GviFIo+mlrYTt+OCQsF+wySTm5AoXEoFub67rCGfNV+wSkB7/IecGMcRJpTjuGt1B7Wvuf
	E21E7ThMBilABTPY6sw448oibW8VJg3SVQZK/EwcOXjF17DIijIHLdbs8o+PW3TpkIT3no
	lDYG7pN8HvAFU9I0SJKn+hs7sddfXEw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OWYsVaza;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762535679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lsGhcNk2ubFrqi2YFZgLMZLjo4nT4sZ1uICkDs7Vo+k=;
	b=OWYsVazaIhlreai+rmh96D4sysHY45FtItorLND2BZvva8VocYiVMfFOz/GYgbl5e5CmIS
	5b/3XYiQbPo3ZIPpvq/a05SiqjP0TIqHhx9xOy3U/O7RalRmZvEbsX5KNCDvD0OJyJE5ZG
	4ahHlf7b8IWvR71PQD6C3yZRdSIUW0Q=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-36-aN6wMJWDMoeyehJYlbDwRg-1; Fri, 07 Nov 2025 12:14:38 -0500
X-MC-Unique: aN6wMJWDMoeyehJYlbDwRg-1
X-Mimecast-MFC-AGG-ID: aN6wMJWDMoeyehJYlbDwRg_1762535677
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-785ebbc739aso14976937b3.1
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 09:14:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762535677; x=1763140477;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lsGhcNk2ubFrqi2YFZgLMZLjo4nT4sZ1uICkDs7Vo+k=;
        b=qdCL+5iBVkq6U1irMH4lN7he1bK8GM8yCFI4kjhG1FHY5T4dtcwzQcCBS/cNO2W0yZ
         VaAlGzCnwNobjj9pIB57S3fZtdyXLAs1d4zyikNjkxdvY/PnSzRtmEfrDSGOQKdYNoQJ
         3Aj0ICPAXP350KoVqzlPu50YWvmt2Srad6tq77ZtAhYBsNZ3SkCyUi6RXhuMG+24jAN+
         lVLDhudul4n0JUolxadSRlgftsRFZor3/eN6PqNCQr3A6E8lR2J7cA8o7PUufAhSTXF2
         /cGmYxSsNJCuyT+GueRWTYRk3qbmmWjpuMVg3WmfqGHfRXZDl1LIpjaGVdyed6/Hx6iU
         GVmg==
X-Forwarded-Encrypted: i=1; AJvYcCXOjHzS+9Zg6KA0MBjyPJqkYQw6cowb8t8sQYRPLIaErXCAAQOu6AMX21j9X2uXMwOAYLjCulfhJg==@kvack.org
X-Gm-Message-State: AOJu0Yzl/vGyUWizUApglvq6vNEOim88flfdS4eMftW+HeEXl9iOyu2g
	ObJY2w9F5N3nK5C+Opr5ohHeIXRBO/4sRPRFECs85qNxkPwg507NrNnnyCEE9yoguWkMeabvu9E
	n3fnX59Q12TpyUlA75HRPBOhLuFr4LOAjbpIExAiMoQ6kzq81e999wrGEcZBd5An/KsMTz7vvmt
	1vZ5DWaaVXafTzZXoR76/f4t3zvZ8=
X-Gm-Gg: ASbGncuCzU8mAtSED2MAlA6xgvDWtuJRQew4nTzHt3fXrEcU4bLVBUK6qb4XXt6xnwB
	GGh2TocpEyR3nRfDMcd1vBN+QRW/iWtKF2W3pQNY15Q9Gj701AhhCAzmqcYwP/IbZ3x3sD5s6y6
	j9Hr4H1LldsmP/qd/womaqqialBzXdIHLJT0JakZO7TpQujtsYDj1hLxtgynKMMqK7K1frMw==
X-Received: by 2002:a05:690c:868d:20b0:787:c2be:33ff with SMTP id 00721157ae682-787d537693fmr714677b3.20.1762535677331;
        Fri, 07 Nov 2025 09:14:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFQek+0t4w48azAVl2zrNoGHztFPdW8lJvf083PafgskTvQqA5rrsO6WLqA1i+ny2NLFGpojXq6gxXmP3Am90Y=
X-Received: by 2002:a05:690c:868d:20b0:787:c2be:33ff with SMTP id
 00721157ae682-787d537693fmr714427b3.20.1762535676754; Fri, 07 Nov 2025
 09:14:36 -0800 (PST)
MIME-Version: 1.0
References: <20251022183717.70829-1-npache@redhat.com> <20251022183717.70829-10-npache@redhat.com>
 <ffcf2c28-d0ae-4a45-8693-10fb4dff8479@lucifer.local>
In-Reply-To: <ffcf2c28-d0ae-4a45-8693-10fb4dff8479@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Fri, 7 Nov 2025 10:14:10 -0700
X-Gm-Features: AWmQ_blPYWAWamFBzA1ly_X3usXllN1louZ3uBjkPVp_-hEefXw_Vu-oIqBHt-w
Message-ID: <CAA1CXcDT19rV_08pVP7CLuUZiVHW_1rSOv2oMXUHyRxh5sGCcA@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 09/15] khugepaged: add per-order mTHP collapse
 failure statistics
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org, 
	peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com, 
	sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, kas@kernel.org, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nCmLnUl-Dv3hwZAyXNRXqM3jc4KJMliGkPdzFX4mGyg_1762535677
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ock3y7npyxyaybdr6w7asy1nwrwkjwre
X-Rspam-User: 
X-Rspamd-Queue-Id: C6CBD12000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1762535679-457146
X-HE-Meta: U2FsdGVkX19j2o4sR9J3KcLKa6Ii3+n/vUtDg2CQOtOBGp21I5/k+ZkbQwBLxbuBZpaCeyxQQ9VRqHag2NM4PAbg8slXa97eKBBoitToKbQSSL0dTvzC77gqmm0cBjXnFsMro90Q1rZ/x6DLIMF4retu8X2nIx+STkWAMryU9m3M6Di0N5ekMU0j8M09BkrcdkvCaIgH2HhLBZiAobp1eB7kUmbHH5T/evb9hdHmuRda7cIbn38XU5s7SB3epn61xYmFH8IWAbY6ZALj8rf8u3xgtfLPm8VHavR2HzpBQq3mxkmCSpSKAhy9/ORm6SAt//H2kMwMr2+LJHUpReUiiQwLDV6IHI0lIkbVXnM549fgkDCVPr+adJDSY+N+b2GZ13FwLuU8+ruPi/EX0Gpm0ooypQzCmQLx/2X4BECg91k3jWP7W+ZuW3XKeLR2k0GPZAkxf+i0+ZmvbPpFYb7Pf3RiWaitBVWkNG9oqEIa8+a0vwp9uphM83CQtIOHR3hld0OgxgNo91R4PjECxO7xwYlEbcYeRizIZgLJhp4mU7Hj/qCttmHFUggh1x9WCIHjw1CWgHBDycPJSVu8zQIFfKD500VgQmr4D2GFvgM8qm5YR2ZQMMUIZmUKU3I8255jycPfIv0Yb7Z4KX1Q8ZDc3YaVjHn/O/2a47iz783C06CbEgXD5cViILVzv/vT/+XlJ4Hsv+rfvQ0ZDSoYLlL2UQrcH4pWaaHvUPH0z3ENU4r0f5W4jsBVfwVC39Jh3mkZHPbWw4svdtYP637I0ABKeqLu2xR9PlGkP7ZJM5iHFhbXn/yTQdR7XadEgrE/S6oGMoQCANJMS+C9+eskzffQWKt9yKKURuKv5zwf7jyFfeu6oRmdzRu1dyAJ+PWMxUSkFJGsYxktUQ8EBohxjGC2YOjiulSZR6raec44+jtcuEteCK8Ee5SoEGHu2p4B1s5j0oDPwuwac7MgLxS6n5i
 kYOmmx1L
 JAY3dMOWAvXu1DDjUlJXZKX7JXZpTxtzgKJnzCx7cN2jc5q6DQvtisT8HZGfEmfRuwYzWRhbnaoxeumAfjfw1HTNUiUxXX/vEuMTeeLx3wx7ULSxXiNd1jF8AGnmf9X6aOePJkjyJ4BZao8+eX6R6d+/tZjFn0bRiRV/J0HYsvKlzcVc9Ucdr4UGyb2r5C3MqRFLCO8JK2qj8W/vcDx2Rx/Uj/TzsnpBSNFdkii9kSxzTfAkhBQx7DTMhV8Eyljs21ZuWxNJIvS3IfXzFH7UYv+uVYfgVJvF8LQlmd9klfGsTSUoim6ZCucjAr4VDPr30UjgMz06SHMZkSK7PzaGjFYcQ2i1hYWU11uP6JGx37IP2XUlhJacpk+CjuEity8KXBYztEDm2EoPwPVyp6tbRov0Hbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 6, 2025 at 11:47=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Oct 22, 2025 at 12:37:11PM -0600, Nico Pache wrote:
> > Add three new mTHP statistics to track collapse failures for different
> > orders when encountering swap PTEs, excessive none PTEs, and shared PTE=
s:
> >
> > - collapse_exceed_swap_pte: Increment when mTHP collapse fails due to s=
wap
> >       PTEs
> >
> > - collapse_exceed_none_pte: Counts when mTHP collapse fails due to
> >       exceeding the none PTE threshold for the given order
> >
> > - collapse_exceed_shared_pte: Counts when mTHP collapse fails due to sh=
ared
> >       PTEs
> >
> > These statistics complement the existing THP_SCAN_EXCEED_* events by
> > providing per-order granularity for mTHP collapse attempts. The stats a=
re
> > exposed via sysfs under
> > `/sys/kernel/mm/transparent_hugepage/hugepages-*/stats/` for each
> > supported hugepage size.
> >
> > As we currently dont support collapsing mTHPs that contain a swap or
> > shared entry, those statistics keep track of how often we are
> > encountering failed mTHP collapses due to these restrictions.
> >
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  Documentation/admin-guide/mm/transhuge.rst | 23 ++++++++++++++++++++++
> >  include/linux/huge_mm.h                    |  3 +++
> >  mm/huge_memory.c                           |  7 +++++++
> >  mm/khugepaged.c                            | 16 ++++++++++++---
> >  4 files changed, 46 insertions(+), 3 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation=
/admin-guide/mm/transhuge.rst
> > index 13269a0074d4..7c71cda8aea1 100644
> > --- a/Documentation/admin-guide/mm/transhuge.rst
> > +++ b/Documentation/admin-guide/mm/transhuge.rst
> > @@ -709,6 +709,29 @@ nr_anon_partially_mapped
> >         an anonymous THP as "partially mapped" and count it here, even =
though it
> >         is not actually partially mapped anymore.
> >
> > +collapse_exceed_none_pte
> > +       The number of anonymous mTHP pte ranges where the number of non=
e PTEs
>
> Ranges? Is the count per-mTHP folio? Or per PTE entry? Let's clarify.

I dont know the proper terminology. But what we have here is a range
of PTEs that is being considered for mTHP folio collapse; however, it
is still not a mTHP folio which is why I hesitated to call it that.

Given this counter is per mTHP size I think the proper way to say this woul=
d be:

The number of collapse attempts that failed due to exceeding the
max_ptes_none threshold.

>
> > +       exceeded the max_ptes_none threshold. For mTHP collapse, khugep=
aged
> > +       checks a PMD region and tracks which PTEs are present. It then =
tries
> > +       to collapse to the largest enabled mTHP size. The allowed numbe=
r of empty
>
> Well and then tries to collapse to the next and etc. right? So maybe wort=
h
> mentioning?
>
> > +       PTEs is the max_ptes_none threshold scaled by the collapse orde=
r. This
>
> I think this needs clarification, scaled how? Also obviously with the pro=
posed
> new approach we will need to correct this to reflect the 511/0 situation.
>
> > +       counter records the number of times a collapse attempt was skip=
ped for
> > +       this reason, and khugepaged moved on to try the next available =
mTHP size.
>
> OK you mention the moving on here, so for each attempted mTHP size which =
exeeds
> max_none_pte we increment this stat correct? Probably worth clarifying th=
at.
>
> > +
> > +collapse_exceed_swap_pte
> > +       The number of anonymous mTHP pte ranges which contain at least =
one swap
> > +       PTE. Currently khugepaged does not support collapsing mTHP regi=
ons
> > +       that contain a swap PTE. This counter can be used to monitor th=
e
> > +       number of khugepaged mTHP collapses that failed due to the pres=
ence
> > +       of a swap PTE.
>
> OK so as soon as we encounter a swap PTE we abort and this counts each in=
stance
> of that?
>
> I guess worth spelling that out? Given we don't support it, surely the op=
ening
> description should be 'The number of anonymous mTHP PTE ranges which were=
 unable
> to be collapsed due to containing one or more swap PTEs'.
>
> > +
> > +collapse_exceed_shared_pte
> > +       The number of anonymous mTHP pte ranges which contain at least =
one shared
> > +       PTE. Currently khugepaged does not support collapsing mTHP pte =
ranges
> > +       that contain a shared PTE. This counter can be used to monitor =
the
> > +       number of khugepaged mTHP collapses that failed due to the pres=
ence
> > +       of a shared PTE.
>
> Same comments as above.
>
> > +
> >  As the system ages, allocating huge pages may be expensive as the
> >  system uses memory compaction to copy data around memory to free a
> >  huge page for use. There are some counters in ``/proc/vmstat`` to help
> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > index 3d29624c4f3f..4b2773235041 100644
> > --- a/include/linux/huge_mm.h
> > +++ b/include/linux/huge_mm.h
> > @@ -144,6 +144,9 @@ enum mthp_stat_item {
> >       MTHP_STAT_SPLIT_DEFERRED,
> >       MTHP_STAT_NR_ANON,
> >       MTHP_STAT_NR_ANON_PARTIALLY_MAPPED,
> > +     MTHP_STAT_COLLAPSE_EXCEED_SWAP,
> > +     MTHP_STAT_COLLAPSE_EXCEED_NONE,
> > +     MTHP_STAT_COLLAPSE_EXCEED_SHARED,
> >       __MTHP_STAT_COUNT
> >  };
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 0063d1ba926e..7335b92969d6 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -638,6 +638,10 @@ DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLI=
T_FAILED);
> >  DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
> >  DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
> >  DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PART=
IALLY_MAPPED);
> > +DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXC=
EED_SWAP);
> > +DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXC=
EED_NONE);
> > +DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_E=
XCEED_SHARED);
> > +
> >
> >  static struct attribute *anon_stats_attrs[] =3D {
> >       &anon_fault_alloc_attr.attr,
> > @@ -654,6 +658,9 @@ static struct attribute *anon_stats_attrs[] =3D {
> >       &split_deferred_attr.attr,
> >       &nr_anon_attr.attr,
> >       &nr_anon_partially_mapped_attr.attr,
> > +     &collapse_exceed_swap_pte_attr.attr,
> > +     &collapse_exceed_none_pte_attr.attr,
> > +     &collapse_exceed_shared_pte_attr.attr,
> >       NULL,
> >  };
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index d741af15e18c..053202141ea3 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -592,7 +592,9 @@ static int __collapse_huge_page_isolate(struct vm_a=
rea_struct *vma,
> >                               continue;
> >                       } else {
> >                               result =3D SCAN_EXCEED_NONE_PTE;
> > -                             count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> > +                             if (order =3D=3D HPAGE_PMD_ORDER)
> > +                                     count_vm_event(THP_SCAN_EXCEED_NO=
NE_PTE);
> > +                             count_mthp_stat(order, MTHP_STAT_COLLAPSE=
_EXCEED_NONE);
> >                               goto out;
> >                       }
> >               }
> > @@ -622,10 +624,17 @@ static int __collapse_huge_page_isolate(struct vm=
_area_struct *vma,
> >                        * shared may cause a future higher order collaps=
e on a
> >                        * rescan of the same range.
> >                        */
> > -                     if (order !=3D HPAGE_PMD_ORDER || (cc->is_khugepa=
ged &&
> > -                         shared > khugepaged_max_ptes_shared)) {
> > +                     if (order !=3D HPAGE_PMD_ORDER) {
>

Thanks for the review! I'll go clean these up for the next version

> A little nit/idea in general for series - since we do this order !=3D
> HPAGE_PMD_ORDER check all over, maybe have a predict function like:
>
> static bool is_mthp_order(unsigned int order)
> {
>         return order !=3D HPAGE_PMD_ORDER;
> }

sure!

>
> > +                             result =3D SCAN_EXCEED_SHARED_PTE;
> > +                             count_mthp_stat(order, MTHP_STAT_COLLAPSE=
_EXCEED_SHARED);
> > +                             goto out;
> > +                     }
> > +
> > +                     if (cc->is_khugepaged &&
> > +                         shared > khugepaged_max_ptes_shared) {
> >                               result =3D SCAN_EXCEED_SHARED_PTE;
> >                               count_vm_event(THP_SCAN_EXCEED_SHARED_PTE=
);
> > +                             count_mthp_stat(order, MTHP_STAT_COLLAPSE=
_EXCEED_SHARED);
>
> OK I _think_ I mentioned this in a previous revision so forgive me for be=
ing
> repetitious but we also count PMD orders here?
>
> But in the MTHP_STAT_COLLAPSE_EXCEED_NONE and MTP_STAT_COLLAPSE_EXCEED_SW=
AP
> cases we don't? Why's that?

Hmm I could have sworn I fixed that... perhaps I reintroduced the
missing stat update when I had to rebase/undo the cleanup series by
Lance. I will fix this.


Cheers.
-- Nico
>
>
> >                               goto out;
> >                       }
> >               }
> > @@ -1073,6 +1082,7 @@ static int __collapse_huge_page_swapin(struct mm_=
struct *mm,
> >                * range.
> >                */
> >               if (order !=3D HPAGE_PMD_ORDER) {
> > +                     count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_=
SWAP);
> >                       pte_unmap(pte);
> >                       mmap_read_unlock(mm);
> >                       result =3D SCAN_EXCEED_SWAP_PTE;
> > --
> > 2.51.0
> >
>
> Thanks, Lorenzo
>


