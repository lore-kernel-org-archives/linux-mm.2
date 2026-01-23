Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D683D778BF
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 00:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B046B6B0565; Fri, 23 Jan 2026 19:46:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB19B6B0566; Fri, 23 Jan 2026 19:46:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B4206B0567; Fri, 23 Jan 2026 19:46:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87E846B0565
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 19:46:05 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE50EAC875
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 23:26:48 +0000 (UTC)
X-FDA: 84364815696.05.C7756AE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 487AF40006
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 23:26:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TDVO2LlF;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769210806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5fKzG3ZqsCU+D3GinO261WdTTeOf+jUnzeg2ypkW+0=;
	b=0p/bFj0LGoY4WKZuZe0FeDpIRldaV+7dM9XLfjmObTphr5vYoQvJHRf6Apq0UBjO/9BeDN
	cyZ/yI0oRQ3hzzmC+/bn1SdzRKceyxsgS8z+ODit0aeZ8ZsKs/QAiJjX72YjpjEVHuoBgA
	KUwgiJ5ZNqrCNPSjKgD8uGb4uLCRLCQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TDVO2LlF;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769210806; a=rsa-sha256;
	cv=none;
	b=dTGvrryzBlto+CS93J10HZQbzkp4dAzzzPeYgruB8sMaJl2FHNClcplW5FF4IhAYG1W3Sn
	GVZz8Q5P5Fw0fHin9AGxXDnS0nsN+Owgl8/YF9G6r7mFLbppFfjOvzWYnJfeBGJzg1aZAx
	Nf4Sc4iWCKCgaNWD+aPDbjWrWS46i8w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769210805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k5fKzG3ZqsCU+D3GinO261WdTTeOf+jUnzeg2ypkW+0=;
	b=TDVO2LlF26z6TEqC+LlbpA+WgF8KenP8XpYINWqcNvwBkMd10o3L5fySfvU5U4z4AWctbh
	C3unGbIbOx0n3ohKz8JCg8QD48ylDKlPrXMrxoxAZiqszixGkbur7JkSjdNfvjXSi0xOSW
	FzgInMZJfWhXKMoBuUJa3DYv6pW2anI=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-uQjvnZH3MaKKMfJlbTK67w-1; Fri, 23 Jan 2026 18:26:37 -0500
X-MC-Unique: uQjvnZH3MaKKMfJlbTK67w-1
X-Mimecast-MFC-AGG-ID: uQjvnZH3MaKKMfJlbTK67w_1769210796
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-794105cd922so35503257b3.0
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:26:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769210796; x=1769815596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k5fKzG3ZqsCU+D3GinO261WdTTeOf+jUnzeg2ypkW+0=;
        b=WCkOO7Yf8DMoPYT6YXlGUPkwIodLzlOIlvtwmNDNXPC9JGyqF5Q+XSfM/VaQvnX5yW
         Ixr7m246swH96CcTAC6SuBuXRaDkpdWBjCJ6ZhpRfuG/L64DUHyRlqFQBmHFNhslV4PJ
         bYJizXyvSLnDH2SnisbsE1BkVitK7lW//HLTL412bdXWyZu/6iXGShmB08VW8hzMUW1U
         /sE0WTmPwrcDIBC53NbTsw9VSwxzhWkV0BZev6e7hfbZpqwE0qjSBHnoxQbc5S27JuqE
         qWFm5jjoGyfvfq44w1IdkaRpCK33fDPeP+2kS5IfV/iCxRqp/F0zktg9WMb1GbGLEb27
         n/9g==
X-Forwarded-Encrypted: i=1; AJvYcCUQJAiYM3BR7PSbDhSeQutLNo9w8Tl4zNbYMECkaYW6JUWtTckfPe0uXv1wlDJeE9/Ue3BTmilINQ==@kvack.org
X-Gm-Message-State: AOJu0YyZvvukRSHLTvj4UGt4YeNjc2s4TBuTUuUVtDiPYyjKAY1a9qzS
	UENb71kLJKtcwqW6yEGARBXlx+Nloa+MOgzUEndus5u5UmU2FiWTF5hD7qSTyJOtSfC4vlN937x
	eDT0pMcX/2mRzuxNfIXXM7uOE7wTfShtoN4O8E8B2aTHYtdhVxyNNhqJ+2fvWSbflhfmklNw0Z3
	RjbaGeBoQJrDj9/8PQwDGj/J8vQZs=
X-Gm-Gg: AZuq6aIQgt97qefn5dsGcFEKHdxZolUn5OuZQTmwOzLT12i3lYSAxuDohqGmeVT5msK
	nbKpMh7cK6eLhZWdqVy2bNXovQTdQq3SEJdYE2K5CohBlhW5bfSVeOZj8N8nIRTi0gGF3aH0Boa
	5hP0CTbiua9zYwCtavJQCuOXss/Rpbu/gopYRa38mDVuv91w/aRto94zzEX9ZnWIojp/KujIii2
	JzJyxoT
X-Received: by 2002:a05:690c:83:b0:78f:ca4f:83b4 with SMTP id 00721157ae682-794398fd642mr44427657b3.22.1769210796347;
        Fri, 23 Jan 2026 15:26:36 -0800 (PST)
X-Received: by 2002:a05:690c:83:b0:78f:ca4f:83b4 with SMTP id
 00721157ae682-794398fd642mr44427057b3.22.1769210795499; Fri, 23 Jan 2026
 15:26:35 -0800 (PST)
MIME-Version: 1.0
References: <20260122192841.128719-1-npache@redhat.com> <20260122192841.128719-4-npache@redhat.com>
 <65dcf7ab-1299-411f-9cbc-438ae72ff757@linux.dev>
In-Reply-To: <65dcf7ab-1299-411f-9cbc-438ae72ff757@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Fri, 23 Jan 2026 16:26:09 -0700
X-Gm-Features: AZwV_QilZZc8j4ov7NcM2cFQPQ3LGH5hizv9DIPhiFxGNbdN2xfs0S2Fql_eYr0
Message-ID: <CAA1CXcDm75=hM_g0x7ox05nGrGykE8ry_+NbryYu=T+TY114MQ@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v14 03/16] introduce collapse_single_pmd to
 unify khugepaged and madvise_collapse
To: Lance Yang <lance.yang@linux.dev>, "Garg, Shivank" <shivankg@amd.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net, 
	rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-kernel@vger.kernel.org, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	jannh@google.com, pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, kas@kernel.org, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	zokeefe@google.com, rientjes@google.com, rdunlap@infradead.org, 
	hughd@google.com, richard.weiyang@gmail.com, 
	David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5CddL3TGo27w6GrsXuTe9hGr-z6uA8DO1hcegKGojCA_1769210796
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 487AF40006
X-Stat-Signature: hqduae9uksgzkphfuk8y6k9mjs3dz6ss
X-Rspam-User: 
X-HE-Tag: 1769210806-496739
X-HE-Meta: U2FsdGVkX18XR1YKfxzkqdIOcVIZoroqQIQk2J8PXH1/EssVCv2NzADrEe9Y9z/2ZLJCNV/DWxR9sV57Grr1fedhTBQ09Ve7zMrcci9Oi7JEd5HAQ9RpbmiD3j5gGwdUS2iX74DwPXcK+8L9DVY3D6TxHSxsDZOq8x2JIOnE6ZbDwpgCrEg4mWydikMlyQ479/EvuE4hZ9mjbUYhs10J3TU9s/PJMxUof54rrbZwqPxuIaBawXPmnopTMD+z+2NwOfnFw0WUXDu5FU2Pi+2dux7DsBmCyUAfApkt94Z68lvwdgJz9Y5BrW1PcSUVItT/Xma3hj0rKx6giqIRVVxQblf+Odc4iodE/Yaufp4bf2n39N/TVN2VRXyjxSZRgPbSNnjEHzNECKkMbmEMcJs1QHW1Du60mXRYlbVbx06ef/gMWbnmOf6zJpYvrDTGihNy5LVtstN/AXDuxphyJ6ycL4wHJ6cbkmfy6uc7SVjv4WnUli3NGHRelGBgVecOYolFXE4QcRTx+9KmUrBrc2jUdD5LuX+qp/O7OcVQwbZQZn7/wJPw7UHlehkd0vD0F6lKwaAnEN5yovgYSxNrNt0Tk+4cMxKJ4kO3SxoaFbPBqONZMNFpYpHQrEfTJFRVkjCfY/Upmwp0FiZF6ZWF2oTJAWORiKaaGn2H5YlUo4llyY+H2sRiCSKOH1Web5SCexCVFvnaLE139tVX6kDCNhAnWDdQjGN345s2eQBz1iKckz7pJYyjJxLExKU9zAiM+ONA+rWCpE8qlQJlbMWFqJc9heq8pPjhPlG3zNJJePZoTJgfatsZ9x6uGDCTUb5A4xvq5Fiwle5X40iKoDBAyBxjXLl41U9Pczt9hfiKkX/Pve9TFgEX3j6T10Jsg8FYkq/xWddhoxssFLwDD6qEEi0TPvMRE/3QLm7sR6KKY/KCyHIv5lIOrNQOKFW6LsWzrEPkt+5+ZPRI2pkGbU78MoE
 kLh/cQW3
 k0CWSvMlOMoCq1mJDt6QVjc9pZMilNP7mtSoNo4s9PT6X95JXazw2QleQSwOpnkCemCjCB2ug/my5sHBaUtLivkQiOGgPnT2IpXOA3gdeXucfi79tc3g7OAn0L/5CM1MZnEnmJjSTvOAvnWrojCG1JiFrKH6vhQdhqw+kEJbbN6/JisUgiQ4v+pzaQwAMx6BFPSGXLaC/x99khiPdSIlky2EaDPmeinhGtLNvG9Gv8bOFPK1mqg0a0m6iTwInQO2FeuTiL5iC8eT/Xntze7wcsZZFRNX+fid1Pnz85GbHcAcQXC3l4LxZiJMtZiBdixvEB7nmbNICyervXqFljowbMFeDftkjIxqM9zTL/4qGa6vv8Ps8/HmREJDiolFqG0G+jOMRm56+3AiTk42P02/Q6MnYQ6SU6Sx2jxCV5MkUtZg2XysQ5PM1/VkFE9tgvN6RjyEm/B+x+ZSaICzdqBqQ0BYExGXVFIW6LMJs7sA0iH9u9n9qItdzoNtFwUFQYjrXNTFDLzLUChBP32fVQLlY3IGItYn4DFWH06/sekF0c4JH9dNyyjFUWo/oxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 10:08=E2=80=AFPM Lance Yang <lance.yang@linux.dev> =
wrote:
>
>
>
> On 2026/1/23 03:28, Nico Pache wrote:
> > The khugepaged daemon and madvise_collapse have two different
> > implementations that do almost the same thing.
> >
> > Create collapse_single_pmd to increase code reuse and create an entry
> > point to these two users.
> >
> > Refactor madvise_collapse and collapse_scan_mm_slot to use the new
> > collapse_single_pmd function. This introduces a minor behavioral change
> > that is most likely an undiscovered bug. The current implementation of
> > khugepaged tests collapse_test_exit_or_disable before calling
> > collapse_pte_mapped_thp, but we weren't doing it in the madvise_collaps=
e
> > case. By unifying these two callers madvise_collapse now also performs
> > this check. We also modify the return value to be SCAN_ANY_PROCESS whic=
h
> > properly indicates that this process is no longer valid to operate on.
> >
> > We also guard the khugepaged_pages_collapsed variable to ensure its onl=
y
> > incremented for khugepaged.
> >
> > Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> > Reviewed-by: Lance Yang <lance.yang@linux.dev>
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
>
> I think this patch introduces some functional changes compared to previou=
s
> version[1] ...
>
> Maybe we should drop the r-b tags and let folks take another look?
>
> There might be an issue with the vma access in madvise_collapse(). See
> below:
>
> [1]
> https://lore.kernel.org/linux-mm/20251201174627.23295-3-npache@redhat.com=
/
>
> >   mm/khugepaged.c | 106 +++++++++++++++++++++++++++--------------------=
-
> >   1 file changed, 60 insertions(+), 46 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index fefcbdca4510..59e5a5588d85 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2394,6 +2394,54 @@ static enum scan_result collapse_scan_file(struc=
t mm_struct *mm, unsigned long a
> >       return result;
> >   }
> >
> > +/*
> > + * Try to collapse a single PMD starting at a PMD aligned addr, and re=
turn
> > + * the results.
> > + */
> > +static enum scan_result collapse_single_pmd(unsigned long addr,
> > +             struct vm_area_struct *vma, bool *mmap_locked,
> > +             struct collapse_control *cc)
> > +{
> > +     struct mm_struct *mm =3D vma->vm_mm;
> > +     enum scan_result result;
> > +     struct file *file;
> > +     pgoff_t pgoff;
> > +
> > +     if (vma_is_anonymous(vma)) {
> > +             result =3D collapse_scan_pmd(mm, vma, addr, mmap_locked, =
cc);
> > +             goto end;
> > +     }
> > +
> > +     file =3D get_file(vma->vm_file);
> > +     pgoff =3D linear_page_index(vma, addr);
> > +
> > +     mmap_read_unlock(mm);
> > +     *mmap_locked =3D false;
> > +     result =3D collapse_scan_file(mm, addr, file, pgoff, cc);
> > +     fput(file);
> > +
> > +     if (result !=3D SCAN_PTE_MAPPED_HUGEPAGE)
> > +             goto end;
> > +
> > +     mmap_read_lock(mm);
> > +     *mmap_locked =3D true;
> > +     if (collapse_test_exit_or_disable(mm)) {
> > +             mmap_read_unlock(mm);
> > +             *mmap_locked =3D false;
> > +             return SCAN_ANY_PROCESS;
> > +     }
> > +     result =3D try_collapse_pte_mapped_thp(mm, addr, !cc->is_khugepag=
ed);
> > +     if (result =3D=3D SCAN_PMD_MAPPED)
> > +             result =3D SCAN_SUCCEED;
> > +     mmap_read_unlock(mm);
> > +     *mmap_locked =3D false;
> > +
> > +end:
> > +     if (cc->is_khugepaged && result =3D=3D SCAN_SUCCEED)
> > +             ++khugepaged_pages_collapsed;
> > +     return result;
> > +}
> > +
> >   static unsigned int collapse_scan_mm_slot(unsigned int pages, enum sc=
an_result *result,
> >                                           struct collapse_control *cc)
> >       __releases(&khugepaged_mm_lock)
> > @@ -2466,34 +2514,9 @@ static unsigned int collapse_scan_mm_slot(unsign=
ed int pages, enum scan_result *
> >                       VM_BUG_ON(khugepaged_scan.address < hstart ||
> >                                 khugepaged_scan.address + HPAGE_PMD_SIZ=
E >
> >                                 hend);
> > -                     if (!vma_is_anonymous(vma)) {
> > -                             struct file *file =3D get_file(vma->vm_fi=
le);
> > -                             pgoff_t pgoff =3D linear_page_index(vma,
> > -                                             khugepaged_scan.address);
> > -
> > -                             mmap_read_unlock(mm);
> > -                             mmap_locked =3D false;
> > -                             *result =3D collapse_scan_file(mm,
> > -                                     khugepaged_scan.address, file, pg=
off, cc);
> > -                             fput(file);
> > -                             if (*result =3D=3D SCAN_PTE_MAPPED_HUGEPA=
GE) {
> > -                                     mmap_read_lock(mm);
> > -                                     if (collapse_test_exit_or_disable=
(mm))
> > -                                             goto breakouterloop;
> > -                                     *result =3D try_collapse_pte_mapp=
ed_thp(mm,
> > -                                             khugepaged_scan.address, =
false);
> > -                                     if (*result =3D=3D SCAN_PMD_MAPPE=
D)
> > -                                             *result =3D SCAN_SUCCEED;
> > -                                     mmap_read_unlock(mm);
> > -                             }
> > -                     } else {
> > -                             *result =3D collapse_scan_pmd(mm, vma,
> > -                                     khugepaged_scan.address, &mmap_lo=
cked, cc);
> > -                     }
> > -
> > -                     if (*result =3D=3D SCAN_SUCCEED)
> > -                             ++khugepaged_pages_collapsed;
> >
> > +                     *result =3D collapse_single_pmd(khugepaged_scan.a=
ddress,
> > +                                                   vma, &mmap_locked, =
cc);
> >                       /* move to next address */
> >                       khugepaged_scan.address +=3D HPAGE_PMD_SIZE;
> >                       progress +=3D HPAGE_PMD_NR;
> > @@ -2799,6 +2822,7 @@ int madvise_collapse(struct vm_area_struct *vma, =
unsigned long start,
> >                       cond_resched();
> >                       mmap_read_lock(mm);
> >                       mmap_locked =3D true;
> > +                     *lock_dropped =3D true;
> >                       result =3D hugepage_vma_revalidate(mm, addr, fals=
e, &vma,
> >                                                        cc);
> >                       if (result  !=3D SCAN_SUCCEED) {
> > @@ -2809,17 +2833,17 @@ int madvise_collapse(struct vm_area_struct *vma=
, unsigned long start,
> >                       hend =3D min(hend, vma->vm_end & HPAGE_PMD_MASK);
> >               }
> >               mmap_assert_locked(mm);
> > -             if (!vma_is_anonymous(vma)) {
> > -                     struct file *file =3D get_file(vma->vm_file);
> > -                     pgoff_t pgoff =3D linear_page_index(vma, addr);
> >
> > -                     mmap_read_unlock(mm);
> > -                     mmap_locked =3D false;
> > +             result =3D collapse_single_pmd(addr, vma, &mmap_locked, c=
c);
> > +
> > +             if (!mmap_locked)
> >                       *lock_dropped =3D true;
> > -                     result =3D collapse_scan_file(mm, addr, file, pgo=
ff, cc);
> >
> > -                     if (result =3D=3D SCAN_PAGE_DIRTY_OR_WRITEBACK &&=
 !triggered_wb &&
> > -                         mapping_can_writeback(file->f_mapping)) {
> > +             if (result =3D=3D SCAN_PAGE_DIRTY_OR_WRITEBACK && !trigge=
red_wb) {
> > +                     struct file *file =3D get_file(vma->vm_file);
> > +                     pgoff_t pgoff =3D linear_page_index(vma, addr);
>
>
> After collapse_single_pmd() returns, mmap_lock might have been released.
> Between
> that unlock and here, another thread could unmap/remap the VMA, making
> the vma
> pointer stale when we access vma->vm_file?

+ Shivank, I thought they were on the CC list.

Hey! I thought of this case, but then figured it was no different than
what is currently implemented for the writeback-retry logic, since the
mmap lock is dropped and not revalidated. BUT I failed to consider
that the file reference is held throughout that time.

I thought of moving the functionality into collapse_single_pmd(), but
figured I'd keep it in madvise_collapse() as it's the sole user of
that functionality. Given the potential file ref issue, that may be
the best solution, and I dont think it should be too difficult. I'll
queue that up, and also drop the r-b tags as you suggested.

Ok, here's my solution, does this look like the right approach?:
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 59e5a5588d85..dda9fdc35767 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2418,6 +2418,14 @@ static enum scan_result
collapse_single_pmd(unsigned long addr,
        mmap_read_unlock(mm);
        *mmap_locked =3D false;
        result =3D collapse_scan_file(mm, addr, file, pgoff, cc);
+
+       if (!cc->is_khugepaged && result =3D=3D SCAN_PAGE_DIRTY_OR_WRITEBAC=
K &&
+           mapping_can_writeback(file->f_mapping)) {
+               loff_t lstart =3D (loff_t)pgoff << PAGE_SHIFT;
+               loff_t lend =3D lstart + HPAGE_PMD_SIZE - 1;
+
+               filemap_write_and_wait_range(file->f_mapping, lstart, lend)=
;
+       }
        fput(file);

        if (result !=3D SCAN_PTE_MAPPED_HUGEPAGE)
@@ -2840,19 +2848,8 @@ int madvise_collapse(struct vm_area_struct
*vma, unsigned long start,
                        *lock_dropped =3D true;

                if (result =3D=3D SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggere=
d_wb) {
-                       struct file *file =3D get_file(vma->vm_file);
-                       pgoff_t pgoff =3D linear_page_index(vma, addr);
-
-                       if (mapping_can_writeback(file->f_mapping)) {
-                               loff_t lstart =3D (loff_t)pgoff << PAGE_SHI=
FT;
-                               loff_t lend =3D lstart + HPAGE_PMD_SIZE - 1=
;
-
-
filemap_write_and_wait_range(file->f_mapping, lstart, lend);
-                               triggered_wb =3D true;
-                               fput(file);
-                               goto retry;
-                       }
-                       fput(file);
+                       triggered_wb =3D true;
+                       goto retry;
                }

                switch (result) {



-- Nico


>
> Would it be safer to get the file reference before calling
> collapse_single_pmd()?
> Or we need to revalidate the VMA after getting the lock back?
>
>
> Thanks,
> Lance
>
> > +
> > +                     if (mapping_can_writeback(file->f_mapping)) {
> >                               loff_t lstart =3D (loff_t)pgoff << PAGE_S=
HIFT;
> >                               loff_t lend =3D lstart + HPAGE_PMD_SIZE -=
 1;
> >
> > @@ -2829,26 +2853,16 @@ int madvise_collapse(struct vm_area_struct *vma=
, unsigned long start,
> >                               goto retry;
> >                       }
> >                       fput(file);
> > -             } else {
> > -                     result =3D collapse_scan_pmd(mm, vma, addr, &mmap=
_locked, cc);
> >               }
> > -             if (!mmap_locked)
> > -                     *lock_dropped =3D true;
> >
> > -handle_result:
> >               switch (result) {
> >               case SCAN_SUCCEED:
> >               case SCAN_PMD_MAPPED:
> >                       ++thps;
> >                       break;
> > -             case SCAN_PTE_MAPPED_HUGEPAGE:
> > -                     BUG_ON(mmap_locked);
> > -                     mmap_read_lock(mm);
> > -                     result =3D try_collapse_pte_mapped_thp(mm, addr, =
true);
> > -                     mmap_read_unlock(mm);
> > -                     goto handle_result;
> >               /* Whitelisted set of results where continuing OK */
> >               case SCAN_NO_PTE_TABLE:
> > +             case SCAN_PTE_MAPPED_HUGEPAGE:
> >               case SCAN_PTE_NON_PRESENT:
> >               case SCAN_PTE_UFFD_WP:
> >               case SCAN_LACK_REFERENCED_PAGE:
>


