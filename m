Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B8AECD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC1466B0402; Tue,  2 Jun 2026 06:25:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E98A46B0404; Tue,  2 Jun 2026 06:25:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAE876B0405; Tue,  2 Jun 2026 06:25:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CDA1D6B0402
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:25:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6F3791208E3
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:25:35 +0000 (UTC)
X-FDA: 84834591030.04.E5EE175
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0B6014000E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:25:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qh2SJbMM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tz/vVgYlWzqjYdT5CgsjAyARbiWMqKQW/JOPkRDARg4=;
	b=D7p4ZvRWjhE5hq5WanFQ/ghWA6ctEyKN3SUIdYbdbntBX8g80MgVAcWV5Ap4UR6BF7Gl6J
	WFpRYn4kAgifzEKWP1rLQUhzShACrQZER0JLwlYzM5ch/DRSy8dlLDTPVKJivGhP+gM3tA
	hDBca8IzvFL1kXMIIEJHXmkKkV+ReOM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qh2SJbMM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395933;
	b=WUjF6qUuoF7XMhAkRSEq0lNEduSVAP2taHRredqULwXgX5M7wTJF8MIqQXQCSf7NGXPFLx
	BPzhqV/L9ZsR36TynAWi8gGn4ht7ClR68B8ykmc7mHPsbAkQeRMotAFSPAYfiFKjJC4ZEp
	rxBqRJvWofECw63ncr+c2NBVn96Kpao=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780395932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tz/vVgYlWzqjYdT5CgsjAyARbiWMqKQW/JOPkRDARg4=;
	b=Qh2SJbMMumu/5DJVt4QdFbyS60/DjktMyZ30i/lSOR2oRKvFTws7afyiOaZXy4Woh1b6lW
	Q6vOhlPMkpwz7MPuu6TRO4bHdX1yd8WyHOYWp1dj3DcDQSxzCDxW+TYuFSoyqv14H/hCHI
	Ra+SiSq9LEpzvai7KLjpucNPAuJY+WU=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-0Qkf5qP5NfeXBHtAU9FXCw-1; Tue, 02 Jun 2026 06:25:31 -0400
X-MC-Unique: 0Qkf5qP5NfeXBHtAU9FXCw-1
X-Mimecast-MFC-AGG-ID: 0Qkf5qP5NfeXBHtAU9FXCw_1780395931
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-660575c74f1so5406665d50.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:25:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395931; x=1781000731;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tz/vVgYlWzqjYdT5CgsjAyARbiWMqKQW/JOPkRDARg4=;
        b=Ut6RIB7YLpcRhC9Sa5Ph354/HIRGYeZjiOgVoX+qskMn0YDcd8u3l+5dsZ04LtgxGD
         niT7HeYlYcwjctbu6hj+00HYM8U8R9k3+zI+9j4JZX/hALTsLC4TPP/29RjriZGu1kpy
         tM2HmIIOs/5dvKVeaqjD/nU5hTiCjx1MSYk/6p/YDziE88zbpPmlPuVk5nlgi8SqR6bh
         pvXnMpy2eRkQ4DQYWyvfDKTIhr4FZ7sT+HORVpI75QoM3eXrLo+v4nwQi5jbVZ2tbqi6
         R/cyl9pq20iWUPG4p5wBvyrZzLx8bC13shMfhZ/Xu3aFKrR5xrUxw3LJgdCrKFCOpvkm
         SRbQ==
X-Forwarded-Encrypted: i=1; AFNElJ9kHP0Hsn+faYUVQxBGE72fX653MQ5JeVTjdYvXPeNcYwpUavio0BzEtrK6KRodT1di6nsSjPJiSQ==@kvack.org
X-Gm-Message-State: AOJu0YxuPrAtKR47Ce0hTf/yCH8UD5cBG8vm51jue5E/2zW1kY1R3tPJ
	lL1r8o7CzvGF/ceMnp1T+IEx35IR1mCunD7OEpsGo7ITJraVkoF1wnHbdMzrjDSTcMYvsyL71Va
	G9f3/Cjd194KfFRR0/c80WZdrINbStj7lEb+AWv4cTn+z3vMhRzmYT1HATOZyVTaijy5v/QNPVy
	/OPSJktTLR77CMZtVvV77DO0FP2hY=
X-Gm-Gg: Acq92OHZ04x/ZzBgzc9GjPT5nCe7xYIv7Go7PyikSDgpi2YD2g7ODP2v6IcrSvOZVlC
	zCkpX9jvRYgVAbtETsYiliDCUEc0klMQsza5m+8XitpWgz/8Zf04zQNmoMr+ixzaE37bC/kzQvQ
	9Z4+h3aA8mKRc/F/txI7pAOWR3dJvZEq5EsnIF/rOSFYcUFTZQbXL6YGIzwPwrY4uYqcpyWLvJ3
	KH7kjELWdZRw4uTlA==
X-Received: by 2002:a05:690e:1595:20b0:660:5e16:f249 with SMTP id 956f58d0204a3-6605edecbf9mr9767421d50.11.1780395930768;
        Tue, 02 Jun 2026 03:25:30 -0700 (PDT)
X-Received: by 2002:a05:690e:1595:20b0:660:5e16:f249 with SMTP id
 956f58d0204a3-6605edecbf9mr9767365d50.11.1780395930340; Tue, 02 Jun 2026
 03:25:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260522150009.121603-1-npache@redhat.com> <20260522150009.121603-6-npache@redhat.com>
 <ah2Ro54tMDMsPevk@lucifer>
In-Reply-To: <ah2Ro54tMDMsPevk@lucifer>
From: Nico Pache <npache@redhat.com>
Date: Tue, 2 Jun 2026 04:26:09 -0600
X-Gm-Features: AVHnY4JldSmClM5zWrsLMpr94a96n3CDQXVYIR75HwJ96w-KO0z_Xu55vTpSsPY
Message-ID: <CAA1CXcAXWWKD64YYGL2ue5iKFUiGsSq-pK2_8qvvgG6EBS079Q@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v18 05/14] mm/khugepaged: require
 collapse_huge_page to enter/exit with the lock dropped
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	liam@infradead.org, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, 
	rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EAMsRyuFt0saF13SJqcrXBgkezmDv9A5a7-bC9lzKXE_1780395931
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 6t9c6hsrhx3fth55pjjczsm8sadjpxm7
X-Rspamd-Queue-Id: 0B6014000E
X-HE-Tag: 1780395932-453115
X-HE-Meta: U2FsdGVkX18BTb5vtUt/JiiyD859NiFKI0pWhUXc4jjd+o/pWyWi4bXtDBOoEE0aB0hA8a7GrNbqZOL67cFcIOTiIdJ7+Cm9y3fGzSzYkSObHiWXuJ6p9vWiNH5PMuO72ZuQclUvH6D3AYUS63Z5hgNgOLsO7H38G7WjFUPgTA5426b1kMw+9ZwmgmXk5blQVfauEgPRsB2UDHUJ7bUjux+c55N2SxAcV8ORCuVwMpmnWpsm1cLCtIDzs0kSy4Xmt3fUsuomA9LWFf6h6bGbJYqKh86My6NUH6GBQ3ldYyxuh7hQL85ltW/5xLzibsuhh+ECP4d9/Metj1CnDCI2oRNpT0yz8XHUjLVkSS+2YCGo66ONubc+Eus5uWh3ERo84Ufeu374qpJp0oDKNOeK9/HIBcnBIiXtlLMjzUTdkQvfZ7zroDcG3kij4sdSgH1Vn1qveBegc2mDUnHaKbI1VM2vqtZzpfPZeF6j/pLauESc0k7UXvOfr1fBLkxi+Ka69uG962js241oPxCD1ezr6gXE3U99/MHLYEA2RjAg6+9G3EBXzfkri5uOPnT5rQLaRnhzOyb9Iqnh/tLh2u5YwFHqmXxID2sIRtXPDYUhlfF5NNY+8FX2Emd1+2DjWQKGWvkkDqWfKDKhWMvg0D9xLMSzeAyBNwO9PBV9DBDOkL9n5jQhmmYvxj4gJDKl/UlVtSvwu9G8S0459CRHZJptzQUy4SkXOYqw8FxefCvxDG6MAR4jv97GAsUalUc/W4k6VVgbDPSnPCVqlhsm/2nOeH2OSx8dWyNdggBH+G4wE0g9JWrT16gCHhZnYNTxQd6nQPAz7bj3mx9qPTB683bkrEJLT1d6tcQfputdcUve/Mxu+lNb91c0RjZHZKQfT3dJF3uTmWIH8XPdba5hbNOdeS+M4kChroWy4Tpqu+m/cwlwkDSayp5XTzGPxR68dmFP7FoeVrBuNyt3MJ6YLAx
 MjCLcwYC
 qsNJvN0rTt4hnwIkJwjO4i3mcEtjJhGHeLZP9v/csVUrqqQQPBAbYXnDo+Rr2GAlrwS+wVAqJsfWnypkOhvuiYyrN8V8rJlXEb1beXgXXka9dqkUrUNy3BMbSUSxRE+Qkk8qpCD0HJaFmpfYgn9pQ4d1ls0Cg9I51By57r6tJ/kes9Vs6HULHLfoAb+x6aoJj3aeb1FP99lfXZjViLGr+aAFCzC5pwT7wW4N/NvIl4OSMIiwWwLhOI1HXPFtOs9LWyDnSfqfKmmuqkLgsjttADDbrNsR4gUOkGCOOz6m/CGbPMOP7wNEh4LLg251msPQQNDdih/L4OVwkDlgLYI6flWPgsjKM98N3zNr5NJ6pAkrrndiaoD/nXn8s9huQpFUSHfB25iuesLhTAPZXiXEAnk3dkUDu751ekmYQxuCbpdvWzJjgDT4o5ZFpwrkY81gbGwucXOEf+SiMpXjuxCpo1AP9zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 8:13=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wro=
te:
>
> On Fri, May 22, 2026 at 09:00:00AM -0600, Nico Pache wrote:
> > Currently the collapse_huge_page function requires the mmap_read_lock t=
o
> > enter with it held, and exit with it dropped. This function moves the
> > unlock into its parent caller, and changes this semantic to requiring i=
t
> > to enter/exit with it always unlocked.
> >
> > In future patches, we need this expectation, as for in mTHP collapse, w=
e
> > may have already have dropped the lock, and do not want to conditionall=
y
> > check for this by passing through the lock_dropped variable.
> >
> > No functional change is expected as one of the first things the
> > collapse_huge_page function does is drop this lock before allocating th=
e
> > hugepage.
> >
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Nico Pache <npache@redhat.com>
>
> One small nit below, otherwise LGTM, so:
>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Thank you for reviewing!

>
> > ---
> >  mm/khugepaged.c | 16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index e98ba5b15163..fab35d318641 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1208,6 +1208,12 @@ static enum scan_result alloc_charge_folio(struc=
t folio **foliop, struct mm_stru
> >       return SCAN_SUCCEED;
> >  }
> >
> > +/*
> > + * collapse_huge_page expects the mmap_lock to be unlocked before ente=
ring and
> > + * will always return with the lock unlocked, to avoid holding the mma=
p_lock
> > + * while allocating a THP, as that could trigger direct reclaim/compac=
tion.
> > + * Note that the VMA must be rechecked after grabbing the mmap_lock ag=
ain.
> > + */
> >  static enum scan_result collapse_huge_page(struct mm_struct *mm, unsig=
ned long address,
> >               int referenced, int unmapped, struct collapse_control *cc=
)
> >  {
> > @@ -1223,14 +1229,6 @@ static enum scan_result collapse_huge_page(struc=
t mm_struct *mm, unsigned long a
> >
> >       VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> >
> > -     /*
> > -      * Before allocating the hugepage, release the mmap_lock read loc=
k.
> > -      * The allocation can take potentially a long time if it involves
> > -      * sync compaction, and we do not need to hold the mmap_lock duri=
ng
> > -      * that. We will recheck the vma after taking it again in write m=
ode.
> > -      */
> > -     mmap_read_unlock(mm);
> > -
>
> NIT: Maybe worth an mmap_assert_locked()?

But it will already be unlocked here. The contract is that we enter
unlocked and exit unlocked.

Cheers,
-- Nico

>
> >       result =3D alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out_nolock;
> > @@ -1535,6 +1533,8 @@ static enum scan_result collapse_scan_pmd(struct =
mm_struct *mm,
> >  out_unmap:
> >       pte_unmap_unlock(pte, ptl);
> >       if (result =3D=3D SCAN_SUCCEED) {
> > +             /* collapse_huge_page expects the lock to be dropped befo=
re calling */
> > +             mmap_read_unlock(mm);
> >               result =3D collapse_huge_page(mm, start_addr, referenced,
> >                                           unmapped, cc);
> >               /* collapse_huge_page will return with the mmap_lock rele=
ased */
> > --
> > 2.54.0
> >
>
> Cheers, Lorenzo
>


