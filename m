Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6854FC83F27
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 01:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1BE36B0098; Tue, 22 Jul 2025 21:56:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC696B0099; Tue, 22 Jul 2025 21:56:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABAC36B009C; Tue, 22 Jul 2025 21:56:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 978506B0098
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 21:56:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 145D1B9E10
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 01:56:07 +0000 (UTC)
X-FDA: 83693863974.05.2F3E12E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id C36C71C000B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 01:56:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dk8hG44Z;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753235765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bz6qe7sGza0nelW7zhVuxtwxYXtjXl9NGKLnwwou5kM=;
	b=yQBKIwRJ7QUUs8mRS5Q/3uBwpl+3UcMojXzP4b7CgkesmlIB3K8yU08zNtxgxc3oym6s61
	N4Dpdr0oTSsVHoipKJjIfKAYDryOWACzZYJudMfRu5azW3/2+4A1hhiJBneusEG0gbG1O+
	fNMnkhfCLZsuYHp/k+B6LUN+U+npcLM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753235765; a=rsa-sha256;
	cv=none;
	b=zIP8pGqESln4ZBQcyGiTqWdDxRNj4okaZ/7eqXpL5gtEhnpmkik8IrEq7NRprZnQj6RWNB
	kgkuT2O8FXvTvIGmw18KCVaESWz0jIN/hBcLfZKdq73phrYHja1taZPzKSReZ+ZfLAI0t9
	X8FnDhxdRt1xYqgQRi1xdqVFW4a/WDw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dk8hG44Z;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753235764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bz6qe7sGza0nelW7zhVuxtwxYXtjXl9NGKLnwwou5kM=;
	b=dk8hG44Z4ti5kZEu3B1DxhoESh66VYyyP1KlyDsos88yLoUo2cIgmwa9MO3l1rnQHq0nYX
	xLAQCmMO/ISZnz3io+mZGHKpV98t0lMGAp5XUKQJDu5zeGN2feSIZdYx9DA62PsHqx6Jn5
	bvBYWgya1p1qbE/35JRaBtcwW4Zz4Mc=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-vA0pHvN8OhGJpZEXElELWw-1; Tue, 22 Jul 2025 21:56:02 -0400
X-MC-Unique: vA0pHvN8OhGJpZEXElELWw-1
X-Mimecast-MFC-AGG-ID: vA0pHvN8OhGJpZEXElELWw_1753235762
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-70e4269deb2so80271707b3.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:56:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753235762; x=1753840562;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bz6qe7sGza0nelW7zhVuxtwxYXtjXl9NGKLnwwou5kM=;
        b=ocmJAnrv9Vf1eNBEZ5enxn9KmhGF5c35k1b2XZ9zS+ZE7jn3RAgj3HrFKQdIg4TDKj
         yi+Q3eetikDvjvwv90A62SRg8hb4Aw+0cgjV8Viu83IjXfa9B39D3Edoa2jx8wd64yyt
         bKwinNDGBOy+wIwmtCSb0H/ewyCT6X0kymaebC410zTQQvls/R78oaQM3rxhuqxCC+M0
         yIi2T/ZkeW2uHAGJm3S5uw4shYMEBcBJzu0qQiw/nrQ0f2XEb5n2WMd0DGwDq0tUT/z0
         fm5RupcGfxF2aBhP28k0HA5WVnwGJrqDEiEWG4nEl7wt840SBIQGpTpxdF8Qe3y0y//a
         dYAA==
X-Forwarded-Encrypted: i=1; AJvYcCW3PRK4URFYUwnqq7ilRfX06oivM725s+ZlaCkMjkRnsWOuKdOiTlS8w25GCJWHBBYOlmP2KZNAUw==@kvack.org
X-Gm-Message-State: AOJu0YwfUKo0qE1PK+Fo/6UO4qReKFWX9UT6gNOxElBlO3aCrvqu0Zwh
	h352T9mn9ZNVjDOfYuaYrLlbtBlZ135QbzB6Ivm9ZXZDzBCLrXX6B5sZqjEKwb9ELJiEy0B8pMk
	SRqb2sUrVFyxAvei/k7O96+dDajqVGiM/1DYGeY3UmvSFEgZ9O8P0/p0Jpc6aQMQpbJfn8/9jgZ
	yTHuzyYvzO4ahgRJC9Fnmsto80XDU=
X-Gm-Gg: ASbGncu5+oVLvAE6MITEuX/CbRGMhd8Y0YTfHJePFLIfEn99UG0V4C7ruj3h6isSacU
	A/QoUN0pzDBPRI5S2uWA4EyQgwgHr83rt2JC0gtqa6+8JKfK18wOP2TxzVZhCQ6R67eZBeATVU2
	HQH0ugHRrAOb6YgiAJerFY8og=
X-Received: by 2002:a05:690c:6c8e:b0:718:385e:58e1 with SMTP id 00721157ae682-719b40e6c74mr19777717b3.0.1753235761932;
        Tue, 22 Jul 2025 18:56:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGcUvSR1xEnNnk2wsz8RU+3YgmlHPQ8xdxNQT/0M5qmuW8jeOgz0aWxtQp7CitqZyNVGjBNQEb70xM7y6n+amQ=
X-Received: by 2002:a05:690c:6c8e:b0:718:385e:58e1 with SMTP id
 00721157ae682-719b40e6c74mr19777527b3.0.1753235761489; Tue, 22 Jul 2025
 18:56:01 -0700 (PDT)
MIME-Version: 1.0
References: <20250714003207.113275-1-npache@redhat.com> <20250714003207.113275-3-npache@redhat.com>
 <ifgx5ufi3qxcw7cj2nmkui56xsen5pifd7utv4v7firbjhotuk@2fozz3b7adwk>
In-Reply-To: <ifgx5ufi3qxcw7cj2nmkui56xsen5pifd7utv4v7firbjhotuk@2fozz3b7adwk>
From: Nico Pache <npache@redhat.com>
Date: Tue, 22 Jul 2025 19:55:33 -0600
X-Gm-Features: Ac12FXzKmyB_PCF_XfE0ZL6463nA8qUSGh0SKuLPbr3f8v6ajiQFuaDPZtk_Y-I
Message-ID: <CAA1CXcAJU4mKmHLixGrm1mZiphFYbfdE+1yqQLSvxH2A-An__Q@mail.gmail.com>
Subject: Re: [PATCH v9 02/14] introduce collapse_single_pmd to unify
 khugepaged and madvise_collapse
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org, 
	peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com, 
	sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com, 
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de, 
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, 
	jglisse@google.com, surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FKZBlO9JmynXWU2yaqSXZgINZn81f0iCldpBnNaeGXY_1753235762
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8rxmjx3n1p3sr6puunpcqxj1d6i1raj7
X-Rspamd-Queue-Id: C36C71C000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753235764-989740
X-HE-Meta: U2FsdGVkX19PeslKUmaIEs5bRJZoDqUZcr9PRKpiaGejz+VPKOFIk1dJVJKpc36R8S5pxvZkIPBfgTsDHRSlvGeWVD8Hg2wbTkMq3sxJxQWPMqrbVOa5XRI8gNf5QrlZfdjltenQDiXIvaK3DNp9XgdW1Wr3qfzHauE58d+QkD3HA2R5Eo3QON4huzBTwE228azuD3D2hiN3lPfsxNmcdpawxEC8B8pX/NNqY3wPpmtxrLxcsXxzAQJWUtVkBJF3u/cw2UZ/OWSyq9DBb27d8gE2/uFZcjUUT9uftd48GDOgPbAJ55c0KOovt9vn+mp0wgHpeFCpc+i1S06fm2fszUZo3SYrMid980fKJtAE6uEYrknFkMfLwuBsr+dh89IyxZJUfZ8YR4YJrEgciC9MeWJk/qnLmME+PkUlFKXxz2CUaPKUm757vhOdO+nkhHQcVLQyo4M2Ytzuiv2xgYWAqIzsOa51eNbkFbjeRE/dosBYHeAdZlsqCy/l4ZlQ+8g4xLFE7Mcq1nSR8VRFpkb7qxlIzbiOvnNwSKK5gr9RGcO7O8EyyEFBhp4L6Znn/Yjqmf/LwrjJ1Yf8Ek/pHJzZRBPGv8J1q2GiI7AGyIfo8E3j2GreFtvIYWSFFI3ifJBCj2RCv6Ym+ALjU6VD6fE/u+BkkPayK/ITlC0AK2qUOz0nDggU+xPQDh/j7tQw//hFrv8POPaN4HFPSIZhCgpq4qT5acJcNLVlVaIqgw893FoCbMRzjEKPSLvtBaAuF+7fwXIv598bV6j+eOVFwhHDrMoz8bDTlum4qe/g/PJl37eWBTATlg4QZdEt75XQb6kaMIK9HHqLfMHXtqwkxqL2U8gw0iYCuJEo7qe3l7Juh0t3K1IT3AEWYkjpzoTD3YqHykChYPDYIrOzdKrp9qZfXUrie2KvrLzbKuF/fRZLbgCG/EoH6PVn0Nhk6ojxOg0GSbB+zZ5q+omklBegNBW
 YIK9k1+1
 xG4HXvqOeEH5t1LEuOEiJzSPZan3UPjPXEvI5hbxfLWrnx9FblPmcLEVRN/FY7IlHMjObEI04hrzuWKd0iHTa4JdEtfk6MJf0aQ9eBPd/dyD5JN07ZEIkYXtBSLVi9OWYHPikH7/dYuo90Sar2qYQrqFGgN1uWSh3nyxagBbgBljFAZFIa0mmWH296VWtDEITkO5JMXzitXIk6TeRkkvIkND70GAcsWNcO2B5zjupW3gn5v8RrEWXcqI29naO8G2DSjHU1YlG8M6adT9nLcm+bT9c9sqbpszU2OBNPKBjCC3Pz6wo2FHxFHNn/171dYmuzELqSrgGtkXDJCPgPcbygh2PJ5hzO88tG0Ug9VZUYOp1laMTP0VcuNEneM6JkWPgkIwrfVWRa2Hb0Kn1iE3pOqdjfX8VSgx9rC+w5Vnbyhifqfw+Q57a3Mkmc39/AjATspnp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 16, 2025 at 9:14=E2=80=AFAM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> * Nico Pache <npache@redhat.com> [250713 20:33]:
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
> > this check.
> >
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 95 +++++++++++++++++++++++++------------------------
> >  1 file changed, 49 insertions(+), 46 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index eb0babb51868..47a80638af97 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2362,6 +2362,50 @@ static int collapse_scan_file(struct mm_struct *=
mm, unsigned long addr,
> >       return result;
> >  }
> >
> > +/*
> > + * Try to collapse a single PMD starting at a PMD aligned addr, and re=
turn
> > + * the results.
> > + */
> > +static int collapse_single_pmd(unsigned long addr,
> > +                                struct vm_area_struct *vma, bool *mmap=
_locked,
> > +                                struct collapse_control *cc)
> > +{
> > +     int result =3D SCAN_FAIL;
> > +     struct mm_struct *mm =3D vma->vm_mm;
> > +
> > +     if (!vma_is_anonymous(vma)) {
> > +             struct file *file =3D get_file(vma->vm_file);
> > +             pgoff_t pgoff =3D linear_page_index(vma, addr);
> > +
> > +             mmap_read_unlock(mm);
> > +             *mmap_locked =3D false;
>
> Okay, just for my sanity, when we reach this part.. mmap_locked will
> be false on return.  Because we set it a bunch more below.. but it's
> always false on return.
>
> Although this is cleaner implementation of the lock, I'm just not sure
> why you keep flipping the mmap_locked variable here?  We could probably
> get away with comments that it will always be false.
>
>
> > +             result =3D collapse_scan_file(mm, addr, file, pgoff, cc);
> > +             fput(file);
> > +             if (result =3D=3D SCAN_PTE_MAPPED_HUGEPAGE) {
> > +                     mmap_read_lock(mm);
> > +                     *mmap_locked =3D true;
> > +                     if (collapse_test_exit_or_disable(mm)) {
> > +                             mmap_read_unlock(mm);
> > +                             *mmap_locked =3D false;
> > +                             result =3D SCAN_ANY_PROCESS;
> > +                             goto end;
> > +                     }
> > +                     result =3D collapse_pte_mapped_thp(mm, addr,
> > +                                                      !cc->is_khugepag=
ed);
> > +                     if (result =3D=3D SCAN_PMD_MAPPED)
> > +                             result =3D SCAN_SUCCEED;
> > +                     mmap_read_unlock(mm);
> > +                     *mmap_locked =3D false;
> > +             }
> > +     } else {
> > +             result =3D collapse_scan_pmd(mm, vma, addr, mmap_locked, =
cc);
> > +     }
> > +     if (cc->is_khugepaged && result =3D=3D SCAN_SUCCEED)
> > +             ++khugepaged_pages_collapsed;
> > +end:
> > +     return result;
> > +}
> > +
> >  static unsigned int collapse_scan_mm_slot(unsigned int pages, int *res=
ult,
> >                                           struct collapse_control *cc)
> >       __releases(&khugepaged_mm_lock)
> > @@ -2436,34 +2480,9 @@ static unsigned int collapse_scan_mm_slot(unsign=
ed int pages, int *result,
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
> > -                             *result =3D hpage_collapse_scan_file(mm,
> > -                                     khugepaged_scan.address, file, pg=
off, cc);
> > -                             fput(file);
> > -                             if (*result =3D=3D SCAN_PTE_MAPPED_HUGEPA=
GE) {
> > -                                     mmap_read_lock(mm);
> > -                                     if (hpage_collapse_test_exit_or_d=
isable(mm))
> > -                                             goto breakouterloop;
> > -                                     *result =3D collapse_pte_mapped_t=
hp(mm,
> > -                                             khugepaged_scan.address, =
false);
> > -                                     if (*result =3D=3D SCAN_PMD_MAPPE=
D)
> > -                                             *result =3D SCAN_SUCCEED;
> > -                                     mmap_read_unlock(mm);
> > -                             }
> > -                     } else {
> > -                             *result =3D hpage_collapse_scan_pmd(mm, v=
ma,
> > -                                     khugepaged_scan.address, &mmap_lo=
cked, cc);
> > -                     }
> > -
> > -                     if (*result =3D=3D SCAN_SUCCEED)
> > -                             ++khugepaged_pages_collapsed;
> >
> > +                     *result =3D collapse_single_pmd(khugepaged_scan.a=
ddress,
> > +                                             vma, &mmap_locked, cc);
> >                       /* move to next address */
> >                       khugepaged_scan.address +=3D HPAGE_PMD_SIZE;
> >                       progress +=3D HPAGE_PMD_NR;
> > @@ -2780,35 +2799,19 @@ int madvise_collapse(struct vm_area_struct *vma=
, unsigned long start,
> >               mmap_assert_locked(mm);
> >               memset(cc->node_load, 0, sizeof(cc->node_load));
> >               nodes_clear(cc->alloc_nmask);
> > -             if (!vma_is_anonymous(vma)) {
> > -                     struct file *file =3D get_file(vma->vm_file);
> > -                     pgoff_t pgoff =3D linear_page_index(vma, addr);
> >
> > -                     mmap_read_unlock(mm);
> > -                     mmap_locked =3D false;
> > -                     result =3D hpage_collapse_scan_file(mm, addr, fil=
e, pgoff,
> > -                                                       cc);
> > -                     fput(file);
> > -             } else {
> > -                     result =3D hpage_collapse_scan_pmd(mm, vma, addr,
> > -                                                      &mmap_locked, cc=
);
> > -             }
> > +             result =3D collapse_single_pmd(addr, vma, &mmap_locked, c=
c);
> > +
> >               if (!mmap_locked)
> >                       *lock_dropped =3D true;
>
> All of this locking is scary, because there are comments everywhere that
> imply that mmap_locked indicates that the lock was dropped at some
> point, but we are using it to indicate that the lock is currently held -
> which are very different things..
>
> Here, for example locked_dropped may not be set to true event though we
> have toggled it through collapse_single_pmd() -> collapse_scan_pmd() ->
> ... -> collapse_huge_page().
>
> Maybe these scenarios are safe because of known limitations of what will
> or will not happen, but the code paths existing without a comment about
> why it is safe seems like a good way to introduce races later.
You bring up some good points here...

Its actually rather confusing why we have this flag, and what purpose
it serves with relation to those comments (other than tracking the
state of the mmap_lock). You are correct that it states to indicate
that the lock was dropped at some point, but in practice that is not
the case, there are multiple cases of the lock being dropped and
reacquired without flipping the flag to false. So in practice I dont
think that's the way it's actually working.

I did some digging and it was introduced in 50ad2f24b3b4
("mm/khugepaged: propagate enum scan_result codes back to callers"),
and AFAICT it was introduced to so we can properly indicate the return
value/state to the parent callers and those comments are incorrect.

"Since khugepaged_scan_pmd()'s return value already has a specific meaning
    (whether mmap_lock was unlocked or not), add a bool* argument to
    khugepaged_scan_pmd() to retrieve this information."

Cheers,
-- Nico
>
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
> > -                     result =3D collapse_pte_mapped_thp(mm, addr, true=
);
> > -                     mmap_read_unlock(mm);
> > -                     goto handle_result;
> >               /* Whitelisted set of results where continuing OK */
> > +             case SCAN_PTE_MAPPED_HUGEPAGE:
> >               case SCAN_PMD_NULL:
> >               case SCAN_PTE_NON_PRESENT:
> >               case SCAN_PTE_UFFD_WP:
> > --
> > 2.50.0
> >
> >
>


