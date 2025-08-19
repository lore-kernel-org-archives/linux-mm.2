Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 161B5CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 14:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B20868E001A; Tue, 19 Aug 2025 10:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF80C8E0007; Tue, 19 Aug 2025 10:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0DF38E001A; Tue, 19 Aug 2025 10:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8FBB38E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:23:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 38C081A0467
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:23:39 +0000 (UTC)
X-FDA: 83793725358.08.591A391
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 07B448000D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:23:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eMoy2aLD;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755613417; a=rsa-sha256;
	cv=none;
	b=f7tYvaIL6r7lVtL91Jx8SXiYS+5OssVaMB0IjvWERajgPrIf2s4Ly3YZv6ZHTxYRGjaB9V
	J8XEGVeo3rG1/JPjw3qGQqKsdRK5T1TmMXoFDbSOAlWg33s6x5LEXnekNslM0UHX1anj/7
	smZEl/Hqn9IWKRRhOS42nWZ5oAH1bQM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eMoy2aLD;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755613417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s3Yx3WbmFOJltwzECtqg3RoGKlDwwsG1Ihs41TRQMQI=;
	b=KgLAuf47VLbxqt1NZxfHWOnrwZ5CW3YH65mwtZqVWjVLUjVgXCDPk7PE5n4gC/v0Guwfqd
	moAuuzxWq6l8Qdi4Mx7ElSUG9fzJidtOiYuXsUk3pFepO+PI9FjBfIPi2L6WuUwQYwq7g8
	5AWSbuDJt9xkf+aJmDbqERx3GgRCAaA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755613416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s3Yx3WbmFOJltwzECtqg3RoGKlDwwsG1Ihs41TRQMQI=;
	b=eMoy2aLD6B/2yuW0+DjkWN+gcknqBKkjNwIJYkVEFyeYLKAYzJweCAlaGlyFLBxIXWhbTY
	6x0f6quLZOTPbOEZG8jlj6VbIyNnS7crK9RAxdLFztcWwcwqH/X2RDtVXASADq2yUb8WY2
	8UqWa36nST24fo87yDGoWyDP00u4upw=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-tR9Hp8L4N_Oq31qkWGpSzA-1; Tue, 19 Aug 2025 10:23:35 -0400
X-MC-Unique: tR9Hp8L4N_Oq31qkWGpSzA-1
X-Mimecast-MFC-AGG-ID: tR9Hp8L4N_Oq31qkWGpSzA_1755613415
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-e933a696359so4991768276.2
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:23:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755613414; x=1756218214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s3Yx3WbmFOJltwzECtqg3RoGKlDwwsG1Ihs41TRQMQI=;
        b=MiFvHcNauC0W62Z9cUt3RIHVKRNAVFA5r93DsAus1Mbr0X7sFdNn9XOiI+ELZ/1lQz
         bqNHl+YkyngTDHhXcjqdVakqJyLW7BqtEN8dfBq1LqW4bZRlxYAf+Ocl1dwRu6vDVG1B
         rNTRvvo0FQfbxAyQTKF7Zjrh2mdxo3+oTdQzM1dvajKV8ojLj5wMAIfJQLZYYgPSnVrI
         kBnX2zC90nyf1SmLYFAeFlbGOOi3dO4EpRycjlGajmrnsEPniF5D8ooZ1kkfgYFCxpn9
         z/WN9DOVI7qwgNQwPtgYAsSLVMKlXvpkLcsL5PSCsezbegju4Zm2+27NDlvObki2f5ey
         rfsQ==
X-Gm-Message-State: AOJu0YxvKJ5U2t/jrkd7pYR4Avilfl+ZHNv0RcfmlnTZLh8T/aOSr38L
	YL+oEuyzor0N9D8rJP+FmK43GdA/7VnZ4LF9kIJy5KE7VEeuYxgQsKeQDzqcQyMYMc0jlVwq5iv
	sagB/y69Y5jhtL1C2AulqsIBu0KraDV3Q65HECPw7DY558WqnM/Tk5vLqeVZO7UI3285w+pQjcY
	/vxX7GLlim7mtPG4H28TR2x4zZZjrMXSMN28ZftA==
X-Gm-Gg: ASbGncvsnQSfqtXZdODuLYE9+tdgGtWHkPUf7Xxw7ylRGJeVMzQloXyyZc5fqrm0Nv0
	1P5Bw+GZWZlQfUtqBStKNRgOPHhLL4pIUC9YOvO+2hEBeI6rID+n3y63WuDZM9xr9+2mrdkyrfw
	/6t072YDpT7sTl2t5dLkbIBpw=
X-Received: by 2002:a05:6902:3302:b0:e90:6e1f:56b3 with SMTP id 3f1490d57ef6-e94e6094cd0mr2715173276.7.1755613414447;
        Tue, 19 Aug 2025 07:23:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnzwnibgt/XeaswLHQENR5+DMzayfV7924bb8m3+Q/0aGqUrDD2rGuExgIkd35TqRCyLnp3B2R4M4uEj5nITg=
X-Received: by 2002:a05:6902:3302:b0:e90:6e1f:56b3 with SMTP id
 3f1490d57ef6-e94e6094cd0mr2715129276.7.1755613414012; Tue, 19 Aug 2025
 07:23:34 -0700 (PDT)
MIME-Version: 1.0
References: <20250819134824.623535-1-npache@redhat.com>
In-Reply-To: <20250819134824.623535-1-npache@redhat.com>
From: Nico Pache <npache@redhat.com>
Date: Tue, 19 Aug 2025 08:23:07 -0600
X-Gm-Features: Ac12FXwnn2MMnUVTpNFBn4Ff3i8_FNGdV8T00Ku52kXw2sNhN4OlDuPKu8EOG9k
Message-ID: <CAA1CXcCS+eVoS_XyWgO2Xexwo-9pc_sUaTpmnet1EHqOGDGwWg@mail.gmail.com>
Subject: Re: [PATCH v10 12/13] khugepaged: add per-order mTHP khugepaged stats
To: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Cc: david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com, 
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de, 
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, 
	jglisse@google.com, surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Apmcq99_8EKsOCPyp4QUvMB30b1_Fh9c_bsczJU3xyE_1755613415
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 07B448000D
X-Stat-Signature: xbwefuq7nrh3czjg3kn8hdi43k3phmk1
X-Rspam-User: 
X-HE-Tag: 1755613416-106818
X-HE-Meta: U2FsdGVkX1+bplvEFtNr39ydFsi4/sHRC52vMtCsp5nGMygCT4pxAlEC3fvGvQR9Ertm16vT6MfirbpX0XeiRB2UUa5uZaO6HWQ1pGtiBU6KKV+44BH4MJMry/Qe7amde1I6v2qEEAsxAxe1gkD37tsogbUCq5EAxa9uiInhlRH6x5DO94gc60IrKUr2ideHDmyKBPbCtO+98CjonKhQjPpitEGoid8h81ZGoELTbx/64oe83v+WTe9dC8PcFcEl5z+801Sqd/5o++pTcURLaKxU+NxZ7DrFT36nMbN+FtoEOqBuOF3EGIDkMhvuxhHG/pfZv4Lpvqe6RG9TRlYuUU7dsbeFiXRD+Zc0RpnLF3A+brXeXs0xnlja7ae0yue3LkU8pGUlkps+bUr+1y1u8xUecw8gIOy1P0hIcmcz4iazqkiMQLX8wzkPbm4a4VX5k+Q3ur/mrn/Sl3zSgj0YlNCpmpat5+H1nBF1Fg+9zgSf8fF2ITtq5GgPAiXs+GPiSgr683EPvLzgNcIGEdTXflSltp6tYUJLFFeVt2+geTisMD4+sJjfxggghX+LxJ5hAHXQrLkImuGSZGGLVXxyZSF/xVaEMSpi9oGI/RHq7lREpBsmawH4fvGUtrk3RQ3EB1QRPZXxPv6glFcC1rPswU+5BqX+oKwHD9ysLkPZMLdFAtqTSSrCngT9ZV1C+DGeaRmhz9NGav4T/O2BhiOAkFIE9zAwfuX696Z9HuBItDIOYwQz2VGlpK9PgE8+UF38EoKLOKbwSWLAQNgcEHAb8V5V2OBXJSA4DcMsdSlfhbjNKJi79D9Jg7pNGrNlV89ZGF6peRZkpJ4PPp+5JKQ63JZkys4An0X22Hsc1Sj6PKPx6cKjHJ0f6xnaQvjv26Iq09215J1AaM7Ug+CGfDS3Xz5XaI718CtfgiZ/hnOr/Jx9RCiiLsYc0RsewJ7ak4k2GFM5UYJYImclp9JULlp
 bN+gci5Q
 7h8THAs2cz6Nq4hd0Em2Y9LO5xZ2SJVepTzDX/V3oSPzDnxylKczq2pq+QlIv/zXiCPuERUjdH8PHjJOTjfK6AJBk4ccvrqNvX5thf/Cl1Ytw5FZzYg7uYtygQ2izHR3M2/euzHUaP+Pq7QJWXcne+BC84vNdUzd3swrQRif5oYPyvmnBKpkLv0687i8K8AohqLq2xybhdwDQMUWN8fqZHe+lTrWThU+qny6I9g8ONOkLmqCURb4mkxG00JRcr3agrpS7hj1ZhkYsoC62cIOkiM/0rRf5qyD9qMPJtuIpLWXdaonXtc4B0pKQ1hUdegdM70Q3lO1hiKsO6kRl82JLXWVwpABSP3DEAdzQY5r405xvy4m9Q+Es58SuawoxoZmBM89LsFHxlDOvOlCtaFcw8XpeYQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 7:49=E2=80=AFAM Nico Pache <npache@redhat.com> wrot=
e:
>
> With mTHP support inplace, let add the per-order mTHP stats for
> exceeding NONE, SWAP, and SHARED.
>
> Signed-off-by: Nico Pache <npache@redhat.com>

I had git send email error and had to resend this patch (12) and patch
13, but i forgot the in-reply-to
please ignore this one and reply to correct version

https://lore.kernel.org/lkml/20250819141610.626140-1-npache@redhat.com/
--in-reply-to=3D20250819141610.626140-1-npache@redhat.com


-- Nico

> ---
>  Documentation/admin-guide/mm/transhuge.rst | 17 +++++++++++++++++
>  include/linux/huge_mm.h                    |  3 +++
>  mm/huge_memory.c                           |  7 +++++++
>  mm/khugepaged.c                            | 16 +++++++++++++---
>  4 files changed, 40 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/a=
dmin-guide/mm/transhuge.rst
> index 7ccb93e22852..b85547ac4fe9 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -705,6 +705,23 @@ nr_anon_partially_mapped
>         an anonymous THP as "partially mapped" and count it here, even th=
ough it
>         is not actually partially mapped anymore.
>
> +collapse_exceed_swap_pte
> +       The number of anonymous THP which contain at least one swap PTE.
> +       Currently khugepaged does not support collapsing mTHP regions tha=
t
> +       contain a swap PTE.
> +
> +collapse_exceed_none_pte
> +       The number of anonymous THP which have exceeded the none PTE thre=
shold.
> +       With mTHP collapse, a bitmap is used to gather the state of a PMD=
 region
> +       and is then recursively checked from largest to smallest order ag=
ainst
> +       the scaled max_ptes_none count. This counter indicates that the n=
ext
> +       enabled order will be checked.
> +
> +collapse_exceed_shared_pte
> +       The number of anonymous THP which contain at least one shared PTE=
.
> +       Currently khugepaged does not support collapsing mTHP regions tha=
t
> +       contain a shared PTE.
> +
>  As the system ages, allocating huge pages may be expensive as the
>  system uses memory compaction to copy data around memory to free a
>  huge page for use. There are some counters in ``/proc/vmstat`` to help
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 4ada5d1f7297..6f1593d0b4b5 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -144,6 +144,9 @@ enum mthp_stat_item {
>         MTHP_STAT_SPLIT_DEFERRED,
>         MTHP_STAT_NR_ANON,
>         MTHP_STAT_NR_ANON_PARTIALLY_MAPPED,
> +       MTHP_STAT_COLLAPSE_EXCEED_SWAP,
> +       MTHP_STAT_COLLAPSE_EXCEED_NONE,
> +       MTHP_STAT_COLLAPSE_EXCEED_SHARED,
>         __MTHP_STAT_COUNT
>  };
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 20d005c2c61f..9f0470c3e983 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -639,6 +639,10 @@ DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_=
FAILED);
>  DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
>  DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
>  DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIA=
LLY_MAPPED);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEE=
D_SWAP);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXCEE=
D_NONE);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_EXC=
EED_SHARED);
> +
>
>  static struct attribute *anon_stats_attrs[] =3D {
>         &anon_fault_alloc_attr.attr,
> @@ -655,6 +659,9 @@ static struct attribute *anon_stats_attrs[] =3D {
>         &split_deferred_attr.attr,
>         &nr_anon_attr.attr,
>         &nr_anon_partially_mapped_attr.attr,
> +       &collapse_exceed_swap_pte_attr.attr,
> +       &collapse_exceed_none_pte_attr.attr,
> +       &collapse_exceed_shared_pte_attr.attr,
>         NULL,
>  };
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index c13bc583a368..5a3386043f39 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -594,7 +594,9 @@ static int __collapse_huge_page_isolate(struct vm_are=
a_struct *vma,
>                                 continue;
>                         } else {
>                                 result =3D SCAN_EXCEED_NONE_PTE;
> -                               count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +                               if (order =3D=3D HPAGE_PMD_ORDER)
> +                                       count_vm_event(THP_SCAN_EXCEED_NO=
NE_PTE);
> +                               count_mthp_stat(order, MTHP_STAT_COLLAPSE=
_EXCEED_NONE);
>                                 goto out;
>                         }
>                 }
> @@ -633,10 +635,17 @@ static int __collapse_huge_page_isolate(struct vm_a=
rea_struct *vma,
>                          * shared may cause a future higher order collaps=
e on a
>                          * rescan of the same range.
>                          */
> -                       if (order !=3D HPAGE_PMD_ORDER || (cc->is_khugepa=
ged &&
> -                           shared > khugepaged_max_ptes_shared)) {
> +                       if (order !=3D HPAGE_PMD_ORDER) {
> +                               result =3D SCAN_EXCEED_SHARED_PTE;
> +                               count_mthp_stat(order, MTHP_STAT_COLLAPSE=
_EXCEED_SHARED);
> +                               goto out;
> +                       }
> +
> +                       if (cc->is_khugepaged &&
> +                           shared > khugepaged_max_ptes_shared) {
>                                 result =3D SCAN_EXCEED_SHARED_PTE;
>                                 count_vm_event(THP_SCAN_EXCEED_SHARED_PTE=
);
> +                               count_mthp_stat(order, MTHP_STAT_COLLAPSE=
_EXCEED_SHARED);
>                                 goto out;
>                         }
>                 }
> @@ -1084,6 +1093,7 @@ static int __collapse_huge_page_swapin(struct mm_st=
ruct *mm,
>                  * range.
>                  */
>                 if (order !=3D HPAGE_PMD_ORDER) {
> +                       count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_=
SWAP);
>                         pte_unmap(pte);
>                         mmap_read_unlock(mm);
>                         result =3D SCAN_EXCEED_SWAP_PTE;
> --
> 2.50.1
>


