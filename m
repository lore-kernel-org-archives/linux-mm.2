Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E223CAC58F
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 02:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B4506B000C; Sat, 13 Sep 2025 22:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38BD06B000D; Sat, 13 Sep 2025 22:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A1736B000E; Sat, 13 Sep 2025 22:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 148E56B000C
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 22:48:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD5C5140277
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 02:48:13 +0000 (UTC)
X-FDA: 83886321666.18.47FADB0
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id BE38E80008
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 02:48:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f9ojZu5v;
	spf=pass (imf02.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757818091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cp7uGh9XMAtdhC8Pg1wTL8oP/uTc27f9iRVAHQuf6uI=;
	b=lj14XUvKG4p4sJbhz4mna1dPS3M6M3JpntFN0vN5A2XRJCV57DgrVksboRo7yGHDn9njc7
	zZEce2PWj/NBoQclebtCN46x4jLxaTnkFShsi7d6MyiDCw5ZnfQM+3CJXVAOxceuTlZCQJ
	Gd2oSVp9TtptMYC4FQQj4Dtj2GLGvf8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757818091; a=rsa-sha256;
	cv=none;
	b=JERYVBAKX6sD6MNVU7uR56jKjGi1QBh0GlSV4EXHP9gLQFWNFSLu/+GRM2KAxkWHzyiEfg
	k4FAWD6uTb1wpRg086E+O+Pgt6vZb9Nw5gNmqlKvCe1oldLIqTCYBEJ4KifkNWxCuorna7
	eVLdnjSMAhqgdnagnVLOGv5VOi7dY+w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f9ojZu5v;
	spf=pass (imf02.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-7639af4c4acso33472016d6.2
        for <linux-mm@kvack.org>; Sat, 13 Sep 2025 19:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757818091; x=1758422891; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cp7uGh9XMAtdhC8Pg1wTL8oP/uTc27f9iRVAHQuf6uI=;
        b=f9ojZu5vKYQECg7XSTCPjZeSxECFSPq9KlOVNIKB3LrEEb3r8OQRyQO7ly1GvSpd0o
         wzdwvYTwhSOJXQc/sa1t7Yn8iDgFWe+h/jd9cFMd3uKhWZXYyHwpegT2uj24tF0gebaa
         GK61/x+mAcN218xOrD35QlqphjdkEjuEyXG1h+xSmSWF7iR3X/2aF72hZenAlnCgg0fA
         DWc06tHoDBY7+lJe5RhiGQ5EmxtM1DQp6S1l81n1MvAwfnBDtFLysBRMdONQ8G//ayIY
         xkMccFcnVDBU8TxIUXDjbZ97RfrqRDzYg1klVHFCdy+C7/fX68iSnMhqrFVvxv7ObKPI
         LUbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757818091; x=1758422891;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cp7uGh9XMAtdhC8Pg1wTL8oP/uTc27f9iRVAHQuf6uI=;
        b=SzJY4n55z2RS8+SkeYtOckb1xSTvANv3uO8O2EsUPxR2m8+vS8uLMOcB0P0Mk/L6YU
         j1TQXxDmE0FQVJx0KLGQLXzUEkNn10E6726SIgImnm+rYNWW1EVrcCUR2xvIWxcxRm7Q
         g2Cq0PdLx1Pgebk1KGL33aRREUxQPutQfDAB9/wcpLtew0Vo3uFL87dkD46ThOWCSvWc
         /8pjX+khhqypmHTW2Yq+yKUfLR+qzuOvFM0m0ITyM4k+Lh5cIz+cOJJKHYaAhn4zltQp
         vMIr+tZVrnVW3OhRpyOEYZ07ARYynqkSShRTP+Jxddd3+0xIR01dg/htvi/UZlp96bs0
         NyBg==
X-Forwarded-Encrypted: i=1; AJvYcCVaBEh/QuEriQ7j3irO3GtrovUdX/C6cLhEJw4HveHb74/SpgKTgdJTki1Gnh3eHkx8+ksg7UpahA==@kvack.org
X-Gm-Message-State: AOJu0Yylt+BmiB7XRbxP7Hmwg6XGOdH3o3sPWhtIpibXGwfBpHAPuxN8
	phBqfv9BIGzAePj4J3YoWKhYWScS5aUeRXaja1gf+GZk8AqxcKxQwutUB/3HH67MlGUjrntHZbN
	fe53bpYrokMphub34yzUIKGnRzfa8UP8=
X-Gm-Gg: ASbGncsEgSSezqIW3krhxVie05kwqK71N1/zk4dcHYDXHhgpqyt2ufMzD/s/y0rPCyC
	6ZNKI/2Hsk8qfk0R1t9ydUu/YUJyMJFYiYY8k0NMuFbhL2R5NkJoY/EyuQBsOa/lrslO+m8gKzP
	dHWwD8z+Xg5pG2+tfAd7LAPWJU675vy0JiPr2coygBE7L0tJGUbhNpPxgJIB45EDG4e37ZdMYC3
	+zwpbJgjb2OXKmdFsak8+MKqEWYV6X4nT1mIyYEcGg1udyREv4=
X-Google-Smtp-Source: AGHT+IH+Jk17l3gErz7feEZAlaVYld9udv0w6feCbqBBsoiFfdHT/10cXwvqjgQ1b69ZWE+uPc9vUwmMf9zu91A5pl8=
X-Received: by 2002:a05:6214:dcb:b0:722:48f8:66a with SMTP id
 6a1803df08f44-767bf630454mr98094176d6.28.1757818090600; Sat, 13 Sep 2025
 19:48:10 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-1-laoar.shao@gmail.com> <20250910024447.64788-2-laoar.shao@gmail.com>
 <8b7cd7d0-ec5f-4d0e-9182-03e42d37820c@lucifer.local>
In-Reply-To: <8b7cd7d0-ec5f-4d0e-9182-03e42d37820c@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 14 Sep 2025 10:47:33 +0800
X-Gm-Features: AS18NWCLaos2aigXhOQbVTbxEWjeK7eDQncfpgJCLqDM9hHSZWjvSDqX711xaPk
Message-ID: <CALOAHbCJZtLUdbSj8TrV3xqUnpdYL=h+oBofDpsNrPaXdSfwAg@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 01/10] mm: thp: remove disabled task from khugepaged_mm_slot
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, Lance Yang <ioworker0@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jouzmwbc9c9mprrmas6fic98m1fbztwa
X-Rspam-User: 
X-Rspamd-Queue-Id: BE38E80008
X-Rspamd-Server: rspam10
X-HE-Tag: 1757818091-658294
X-HE-Meta: U2FsdGVkX19yjPZv+fp/wvoyo3uKAXev7IneTW0ZSIWfPyhiYOblcuJY0J3+syJjj5aRpjBr5gMruDFgpg6vCCT6yPwuRs+aEEWIE7Bpa8RojqhvGSIrYImHyNiSDAyyysI8X6pzNZC3DtoVjPZcqGYl3fXw8JGGNCLUm7sWUq9E2L4uyPOfXYEMCedYyhkjxa/642GgtU8HKqetubNwaehLrlqGNQD4tr7fg4oaDEJE253ZXl5hd8Otok9GdMEsfabMONhpsAR+8Bb9Nx6FsxuPvT4Rak1cL8/gKO+f5Yb0nGPjRQcudhTH5TDN69XSCsI85Np2Bwvwb6vFoFm7F+XIiE+1YvWIDVsLrQlo9wUWqK+2iddqEqDD4t/gly/TNNbPv7mG7okwCGtSLYy4bJIOcenLAKVPpQSoOtbudn4sG+kahN+qxFOZ3RXz9uinaxuEhwvcUDPzw7r9ZF8gj5v9YAOGAeRy2odQuZWuEHRNvd3Fmn88U/pAjC88IVCqwSRigHp/XMyert72aNO9wHZGKVd5Fc+6NzoaSebK1DNM5ZAz9L9812VsjftogbltGIETVvWqn2/Cgclu/rEq2vKOMt3s+M1S0jGNKHLO5vUjQWuJU0Q02ZjJ84tFVn3ElofBGrc8mq9xM9zdabS7HFJ5tYbY0IwBGExAyhb+Q7ihnMFX5V/F9kqv7VRyOvLk3HV6MwS8JWgQ4lzMocTLHaKgE95uYCRdMXUf2pw0EJJT+i+OzfioLGW8R7N4UsnV9+K7FYCm/1nCHmxaMKaEUQY2FDLdpud7sqsLt2SO2bSDa72Gb3KJcDQ+3wa1Om4jM73RiLvLY8xbvvbOHjE3dZNcTLhwEQJKCz9PWIH9DdQX2Y4Si8+Bgatgxg24QBO+lNOFz638mEcbCUaLjJmk6TfDt0rNoa6q4vjiMQyEbhEVS94H/C3XtfNWe5EkISSJ2VITs3fi85SlO1rnvPP
 laace0Sa
 J/nGSzoW0tTwMLp4qCZJY3PdeUYs+03Q+14L/6spSe9/cUZspz07SYj08/HD/YY0DFblR12RayhIS3C00ZUV++MA/vK1sjntnlR1tySoBoM+CTGnAzdhWz+lqqRCDHrF01ns6eOCs83boa6mA7omAPMtZUpMOxYr8Abtd1n8OftVAuU/0KVs4/c8ZEvJOyGOyKvhKdviYOweRNBS1TVJseajUWt9GBst0tNmUfHQ7Z/H6TzC0XI1BsFavzDuhvcZSX+pUDVZfHn3lCv4thD/UwbsJb9VlDVs46oi9ss+/le2GBAietq9ftl7XL5/RP3HPtDEMUXPoob2BA+yxhTFUUFGtYZTlAUus2B+Xt39Fq1VmYZ+RX2prMfzoZ8FQfEd91oaGF3inwk0Oi79eQXi6jUZI9wftC3XXVHTwichPaOrjlomYRVryr0YvZ1O5VH6nXUdWUPDEj7IhqUwyfPs0S3UzMYp7+MhIDVHXg1G5T6bWGvFB9+s6UrCw0nBdUHyFGYzjv1qrfnVGb98=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 9:43=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Sep 10, 2025 at 10:44:38AM +0800, Yafang Shao wrote:
> > Since a task with MMF_DISABLE_THP_COMPLETELY cannot use THP, remove it =
from
> > the khugepaged_mm_slot to stop khugepaged from processing it.
> >
> > After this change, the following semantic relationship always holds:
> >
> >   MMF_VM_HUGEPAGE is set     =3D=3D task is in khugepaged mm_slot
> >   MMF_VM_HUGEPAGE is not set =3D=3D task is not in khugepaged mm_slot
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Cc: Lance Yang <ioworker0@gmail.com>
>
> (Obviously on basis of fixing issue bot reported).
>
> > ---
> >  include/linux/khugepaged.h |  1 +
> >  kernel/sys.c               |  6 ++++++
> >  mm/khugepaged.c            | 19 +++++++++----------
> >  3 files changed, 16 insertions(+), 10 deletions(-)
> >
> > diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> > index eb1946a70cff..6cb9107f1006 100644
> > --- a/include/linux/khugepaged.h
> > +++ b/include/linux/khugepaged.h
> > @@ -19,6 +19,7 @@ extern void khugepaged_min_free_kbytes_update(void);
> >  extern bool current_is_khugepaged(void);
> >  extern int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long=
 addr,
> >                                  bool install_pmd);
> > +bool hugepage_pmd_enabled(void);
>
> Need to provide a !CONFIG_TRANSPARENT_HUGEPAGE version, or to not invoke
> this in a context where CONFIG_TRANSPARENT_HUGEPAGE is specified.
>
> >
> >  static inline void khugepaged_fork(struct mm_struct *mm, struct mm_str=
uct *oldmm)
> >  {
> > diff --git a/kernel/sys.c b/kernel/sys.c
> > index a46d9b75880b..a1c1e8007f2d 100644
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -8,6 +8,7 @@
> >  #include <linux/export.h>
> >  #include <linux/mm.h>
> >  #include <linux/mm_inline.h>
> > +#include <linux/khugepaged.h>
> >  #include <linux/utsname.h>
> >  #include <linux/mman.h>
> >  #include <linux/reboot.h>
> > @@ -2493,6 +2494,11 @@ static int prctl_set_thp_disable(bool thp_disabl=
e, unsigned long flags,
> >               mm_flags_clear(MMF_DISABLE_THP_COMPLETELY, mm);
> >               mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
> >       }
> > +
> > +     if (!mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) &&
> > +         !mm_flags_test(MMF_VM_HUGEPAGE, mm) &&
> > +         hugepage_pmd_enabled())
> > +             __khugepaged_enter(mm);
>
> Let's refactor this so it's not open-coded.
>
> We can have:
>
> void khugepaged_enter_mm(struct mm_struct *mm)
> {
>         if (mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm))
>                 return;
>         if (mm_flags_test(MMF_VM_HUGEPAGE, mm))
>                 return;
>         if (!hugepage_pmd_enabled())
>                 return;
>
>         __khugepaged_enter(mm);
> }
>
> void khugepaged_enter_vma(struct vm_area_struct *vma,
>                           vm_flags_t vm_flags)
> {
>         if (!thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_O=
RDER))
>                 return;
>
>         khugepaged_enter_mm(vma->vm_mm);
> }
>
> Then just invoke khugepaged_enter_mm() here.

That's better.

>
>
> >       mmap_write_unlock(current->mm);
> >       return 0;
> >  }
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 4ec324a4c1fe..88ac482fb3a0 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -413,7 +413,7 @@ static inline int hpage_collapse_test_exit_or_disab=
le(struct mm_struct *mm)
> >               mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
> >  }
> >
> > -static bool hugepage_pmd_enabled(void)
> > +bool hugepage_pmd_enabled(void)
> >  {
> >       /*
> >        * We cover the anon, shmem and the file-backed case here; file-b=
acked
> > @@ -445,6 +445,7 @@ void __khugepaged_enter(struct mm_struct *mm)
> >
> >       /* __khugepaged_exit() must not run from under us */
> >       VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
> > +     WARN_ON_ONCE(mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm));
>
> Not sure why this needs to be a naked WARN_ON_ONCE()? Seems that'd be a
> programmatic eror, so VM_WARN_ON_ONCE() more appropriate?

ack

>
> Can also change the VM_BUG_ON_MM() to VM_WARN_ON_ONCE_MM() while we're he=
re.

ack

>
> >       if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
> >               return;
> >
> > @@ -472,7 +473,8 @@ void __khugepaged_enter(struct mm_struct *mm)
> >  void khugepaged_enter_vma(struct vm_area_struct *vma,
> >                         vm_flags_t vm_flags)
> >  {
> > -     if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
> > +     if (!mm_flags_test(MMF_DISABLE_THP_COMPLETELY, vma->vm_mm) &&
> > +         !mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
> >           hugepage_pmd_enabled()) {
> >               if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED=
, PMD_ORDER))
> >                       __khugepaged_enter(vma->vm_mm);
>
> See above, we can refactor this.

ack

>
> > @@ -1451,16 +1453,13 @@ static void collect_mm_slot(struct khugepaged_m=
m_slot *mm_slot)
> >
> >       lockdep_assert_held(&khugepaged_mm_lock);
> >
> > -     if (hpage_collapse_test_exit(mm)) {
> > +     if (hpage_collapse_test_exit_or_disable(mm)) {
> >               /* free mm_slot */
> >               hash_del(&slot->hash);
> >               list_del(&slot->mm_node);
> >
> > -             /*
> > -              * Not strictly needed because the mm exited already.
> > -              *
> > -              * mm_flags_clear(MMF_VM_HUGEPAGE, mm);
> > -              */
> > +             /* If the mm is disabled, this flag must be cleared. */
> > +             mm_flags_clear(MMF_VM_HUGEPAGE, mm);
> >
> >               /* khugepaged_mm_lock actually not necessary for the belo=
w */
> >               mm_slot_free(mm_slot_cache, mm_slot);
> > @@ -2507,9 +2506,9 @@ static unsigned int khugepaged_scan_mm_slot(unsig=
ned int pages, int *result,
> >       VM_BUG_ON(khugepaged_scan.mm_slot !=3D mm_slot);
> >       /*
> >        * Release the current mm_slot if this mm is about to die, or
> > -      * if we scanned all vmas of this mm.
> > +      * if we scanned all vmas of this mm, or if this mm is disabled.
> >        */
> > -     if (hpage_collapse_test_exit(mm) || !vma) {
> > +     if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
> >               /*
> >                * Make sure that if mm_users is reaching zero while
> >                * khugepaged runs here, khugepaged_exit will find
>
> Seems reasonable, but makes me wonder if we actually always want to invok=
e
> hpage_collapse_test_exit_or_disable()?
>
> I guess the VM_BUG_ON() (though it should be a VM_WARN_ON_ONCE()) in
> __khugepaged_enter() is a legit use, but the only other case is
> retract_page_tables().
>
> I wonder if we should change this also? Seems reasonable to.

Right, we can change it also. Thanks for your suggestion.


--=20
Regards
Yafang

