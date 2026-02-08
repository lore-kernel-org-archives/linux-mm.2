Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AE1EEF06E2
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 13:25:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6606B0089; Sun,  8 Feb 2026 08:25:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6476B0092; Sun,  8 Feb 2026 08:25:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BD206B0093; Sun,  8 Feb 2026 08:25:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 49C826B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 08:25:23 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1CA6B9FBD
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 13:25:22 +0000 (UTC)
X-FDA: 84421360884.24.7E1D0A0
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id C03C5A0006
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 13:25:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dg2nsR6Y;
	spf=pass (imf15.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770557120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lOnsiH1asBlX42jC0ZqQoEjV3gA1bZrVohiD7zHkZp8=;
	b=n7A96v6zBUCq0R4MAjHy6O1II6OwtlV6MN0zUm+fCdlcmdrpP0X8uVRxnGQk9dsbQ/QJnD
	UIlADjQNGDrumFgTqOHXiK5z/t8qXFzMVn/QY4TSHF0rpnzppGjMPWWYPaNAnC5DB9K5pA
	Q2G3OMTyb9i5eCp2Trwi10WuQ9ECKog=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dg2nsR6Y;
	spf=pass (imf15.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770557120; a=rsa-sha256;
	cv=pass;
	b=nI9+EF8qbCx2MvvDDIsL6X+GkP6MrJxvLZmCZtqIm5mcLUrpDW3POaqpQINigOeQevUZiv
	HDVPI0AY4DbJs2OTachkVZOyj85IkfxXRLlG5XZZfk3ye+u87UbLLtHHSAX2wBEK0c/Pn2
	k6J1+v4IkT9WaC2+B3BdbC0dffFoNpY=
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-382fb2bb83dso21344031fa.1
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 05:25:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770557119; cv=none;
        d=google.com; s=arc-20240605;
        b=ERk4uvfvkBSCV7DPVZIOWe3Fwlm7oDVfCatTu7RWTK0U5umxstQ7pUaGobtQGr+yJX
         52SjAGOnDNlcg33SDWLrcMNS7Hfqdr9yNovvF8DS2s68BY/90FGeMp8tzyc7fur2fYDg
         qci4VNx6nU6I+nroMpYn5/+Uk6+e+1DodGqgIWIeEchS+MaC/tG9ibFX19bD8GB2TRZE
         Fe3Tv9ZxSw+T01EcWpbyNkgwVbRMQJF9xrGGGlV83sCuwgF7HgP3jEUY1+BIaBZ6Twu9
         ntO9k7GlwnGUCpjk5UKH4YiRTfPEY+kfDkKwmbI8h86Ch5RpuLHcM+2YWPogpeqCvA3l
         KvtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lOnsiH1asBlX42jC0ZqQoEjV3gA1bZrVohiD7zHkZp8=;
        fh=KZQzpVOp4rswjr/iwt6mEqsZCHS4489uyFdL8j3SEds=;
        b=D6IlEaQG3KGQYRbU+CQaemuvML5C/mPeipk68cG1JKtTCnMtWfhxYSMnHBu8p5UzUK
         F9Rou/8WNTMSEbowkeFTE928Ic6UnUA2XupL7WPsBb0bTA9ii/GH5f8IkT1ON7Ho2Cga
         dbZxKtfbf4y0DKuFe0Cmqwxb4yi1dKyfv5DeBt3RlThBetJmyTVHqQIxIAEWpTcIZ3Or
         wBsGTBYOzlVsPOBkqHSVIhmxLR95zeljzruVUh8YEsJtGg8zNT+PZ2CR+MVdKGybghET
         5vEAbqh4Dz+6SXORKHcqzG3+YK7bPWVfCpmjDVGToHznK6hjZybzBsA9AkcDd2Jpj4dv
         sJbg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770557119; x=1771161919; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lOnsiH1asBlX42jC0ZqQoEjV3gA1bZrVohiD7zHkZp8=;
        b=Dg2nsR6YbUH/hG54fHdWg+W+fR8iu2DMvcBl/+S7JO05TGJXx2VY/yuQ+Htusv21VZ
         ed73/bW7O61jYtEJAcrrqlDFKxPm/miJWj7CV59oAq2+iLVNdZpcjed/LbWdkWRCBSdY
         wDw9gAx5ChPqN2HHPeCDfbfhUd9DeCFL+EMUCSHDRXI04VpjDe+HkD/DOqAYCH+7+HO3
         gbNglZBM30pRYeLaihRoVP5nNx/nT3S/c9DTngs+hwNDwFehhas5zDgFa5fkj4hDJeMD
         l8pG2cQXSu7cBBxoytPozjLq5UFAZ0ZJWxiQEjz5F1O39rOq6EduYkBeTiJMa3WbJ0Nk
         7oTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770557119; x=1771161919;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lOnsiH1asBlX42jC0ZqQoEjV3gA1bZrVohiD7zHkZp8=;
        b=k8HmMvtA7HrpZwDrJHOuA6NlHs+nGuDLkWDUllg0hQbtbrDfxJe/BoTayiUkbUgi/g
         nFv444i00WzH2RbwdOAaPWc7F8MUoll/+amHJPFt85U6oqYa0u0E8jeICfgXiYptaVA9
         tE65onHwLOyrq8se4fQyUnC+JEmAuIxSZHlGQaOXLwtfnCqFQQcbjAjhr3KTZ53MLbOD
         O2w9O0dgUxo2xikiOa5QQlv7zuyFcvfVUbaxzrGnBenWzohOaNIuq4YBXjKk5wVmzgWV
         oXZAMDsBOw8HMy+38U+PIsV74ishO27frXq2G4PkPTarMiXymCNZxIkzTw4uHFlkfXir
         hH/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXUNwiyeLDLQvgaYjZyWeHL8330r08EbN76N/J/wpsrtNmF0pKzgCTPUpALl9LfF6ZzVNNnZprRhA==@kvack.org
X-Gm-Message-State: AOJu0YzXIrcD93IOo7TqPkMCWEMBE/5ljwCD3SJsIUZ7a5yUk8t8apy/
	9C2wII2ve+aJ+cxb2mOQSbCNT9EJUd4JvweWCLcbhLQZ9/Evkzlw17uxzQqHsTImmCuUgKcdcWM
	ERFcgMNcmP8EO/HgjnbkDsnUH48pLqS0=
X-Gm-Gg: AZuq6aLR2sKS2U0CwZotBn7wC9GURy6PRNR3Ed0r/G+qpqb23VdzpbnhKGnsZMxB75i
	WBwkg8FE5DbpS3RtJqFyUUCQ1hEWP50SehgPhlKc7j31XHqZh1JfVOLjsQiCeu4mTKA6gXF12LF
	S8QM+NTSeb3O+FhaJBRydfpmyYscudFRM1c7zLS6KnYDMvkTAJ4/mtOA3FAKzFxLz7Wkjofmk9Y
	L8i/PIDJLNVUu/dy7WUaw+J4v5EzKdLCxNLXlAPg3oSLcOmkkmitE+FKxhMk4Oh4FzVX+S4
X-Received: by 2002:a05:651c:19a9:b0:386:91a1:f1f2 with SMTP id
 38308e7fff4ca-386b67d8168mr26204201fa.7.1770557118785; Sun, 08 Feb 2026
 05:25:18 -0800 (PST)
MIME-Version: 1.0
References: <20260207081613.588598-1-vernon2gm@gmail.com> <20260207081613.588598-3-vernon2gm@gmail.com>
 <53527839-e918-47d3-9442-cd5e8975ab22@arm.com>
In-Reply-To: <53527839-e918-47d3-9442-cd5e8975ab22@arm.com>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Sun, 8 Feb 2026 21:25:07 +0800
X-Gm-Features: AZwV_QioDICZUV1KnU84LeycNDMqFw2EC2Hvxf8a5wSerPz0wljad1GRgJ35Gwk
Message-ID: <CACZaFFORtLk=J0Z+58GAAY=9OuRJNuK+7UG1xY6bgJdwdEWzuw@mail.gmail.com>
Subject: Re: [PATCH mm-new v7 2/5] mm: khugepaged: refine scan progress number
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: m9t39i4i4g3nj1rrx3o1xoozrkps56eg
X-Rspam-User: 
X-Rspamd-Queue-Id: C03C5A0006
X-HE-Tag: 1770557120-179970
X-HE-Meta: U2FsdGVkX1/3zvRT7pQ4qlDttjqlq0z67RGCOkvICFHMGJTpUx3IEba8ez8HBpbziyqC5Z/cvEtWcvd4QGpi5f00zapTyD1XmhpoimJp8xs7LlIhO/pXZzqbQmv3qCQpOx9X6jT97wJ8UOFi4Vpl34gts2n5YM2gf03euX9VvWD3w5tcdN7vi+Rp8IHOIeWNlQQGpHZJL2H9A2Og2aoMK1Dv+OkYdTbUDHHxB2iKasSrAiMdCYO8WiUcMX5hppJldXD92eBSozODc+nXDR5psr9rKxMuf1wzRanUFixTaTgPklv0SLDJ6coA5mpTvFoR5X9IRa5JfZ2A5tGvzbaIMUND93m4rNHY8A/yFuMiBwGBckh+kqIbNj4C9dBgwaZw8Xm2qo/vK+CNGFHhWcPnC63HtRaFuc0HOWRe5XBxY7js/zY5SsHUXN0iGy1ZjW+cqymBM7yauCpRdo5kTjB3ZAlwUo+X/6/BxhAf8D474VuCStenYw0/1xG2n9lxNPfA6dgfla08oJjc1vOO1nTdMS7mGW9NxkSsPaUrgMf8SFgC3A6J5zGUL6FvYJTigolwXO/JEiDvONVn/frcJHj9BcNHm7NUaZEECD4/JlMQNUpFdpgAVoOnnQ22MMmXx39xkP4e/e85WVSADno5ZShbWSFqL+5B+5KB1bRCaHDu2VJWeSWh07KZa1cnDggNOJyCAx0MJ0qo5OVDJmhkZNENXuCdzZhG5etWufJBusJPa/UoQZ3HtAQ7Hn/xPwBKxBUhymaGTX3mM0/7N4TNG7YkPzazUUuXffv+zFi3rd4HcwQo7DOQO03KOx1IT4jrJ1fRYdI3rNEb8rBb8fzsUxWjaZbX70+4Nqrsfn/uTSkylkjZXaAaK60XvbC/bh30Cm94ymBW3u/bXae3vJPZcnUDxqTGxL9l18hrjbPq0cqMaIDvvBDu8E6KJdUtE3V/w2O+bPVjCuYaz80117V/Q7q
 i7uwTLvQ
 +BDZLMBYvhDS3x+xY0Y23i/7Sz0eT7v2jlZjZxKn2pqW2Fj/+khzMFURR9o2TMCM2WsgT7F446CumgNvQ6EGO7EdWdxsftou/edAjmafLswsGIPci1SvatTjPIpzKTwTsu9i9aPN46DN9c07AZaySD/6xE3Ev6vLeWdoPmLQJVhM4mBWFlygxvyg1Ev2h1eWxN7ZoWRUBEKfWW+pcDQteQEyd7LvEmEN5Xg3CQg73FpzZvNnBGwyrF9kD/n6t1M1GrAjo2kg/5zWZUkFhDXXXap90HOQVN1hnp00cQGVhDU+578W8vUwtZBfTSXQS8T9PTkBXdlE9dZ2aciWrnxQWQYR/kNc/2dfK20FgQ9jsrNgmkPG5NmZZKjctUFpiccokccyNz8bCVO+0pbkIzZ8mIhkq3v8IwMZ58HaHHLXNXVjVafGZIj8EklKsgnzdqmZYTquyGAScGDvHW9PuQtYtRsoHd2DdUJ4D9dInO9KGrOJ4VKftiBBFTxzkIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 8, 2026 at 5:17=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> On 07/02/26 1:46 pm, Vernon Yang wrote:
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > Currently, each scan always increases "progress" by HPAGE_PMD_NR,
> > even if only scanning a single PTE/PMD entry.
> >
> > - When only scanning a sigle PTE entry, let me provide a detailed
> >   example:
> >
> > static int hpage_collapse_scan_pmd()
> > {
> >       for (addr =3D start_addr, _pte =3D pte; _pte < pte + HPAGE_PMD_NR=
;
> >            _pte++, addr +=3D PAGE_SIZE) {
> >               pte_t pteval =3D ptep_get(_pte);
> >               ...
> >               if (pte_uffd_wp(pteval)) { <-- first scan hit
> >                       result =3D SCAN_PTE_UFFD_WP;
> >                       goto out_unmap;
> >               }
> >       }
> > }
> >
> > During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
> > directly. In practice, only one PTE is scanned before termination.
> > Here, "progress +=3D 1" reflects the actual number of PTEs scanned, but
> > previously "progress +=3D HPAGE_PMD_NR" always.
> >
> > - When the memory has been collapsed to PMD, let me provide a detailed
> >   example:
> >
> > The following data is traced by bpftrace on a desktop system. After
> > the system has been left idle for 10 minutes upon booting, a lot of
> > SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
> > by khugepaged.
> >
> > From trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file, th=
e
> > following statuses were observed, with frequency mentioned next to them=
:
> >
> > SCAN_SUCCEED          : 1
> > SCAN_EXCEED_SHARED_PTE: 2
> > SCAN_PMD_MAPPED       : 142
> > SCAN_NO_PTE_TABLE     : 178
> > total progress size   : 674 MB
> > Total time            : 419 seconds, include khugepaged_scan_sleep_mill=
isecs
> >
> > The khugepaged_scan list save all task that support collapse into hugep=
age,
> > as long as the task is not destroyed, khugepaged will not remove it fro=
m
> > the khugepaged_scan list. This exist a phenomenon where task has alread=
y
> > collapsed all memory regions into hugepage, but khugepaged continues to
> > scan it, which wastes CPU time and invalid, and due to
> > khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
> > scanning a large number of invalid task, so scanning really valid task
> > is later.
> >
> > After applying this patch, when the memory is either SCAN_PMD_MAPPED or
> > SCAN_NO_PTE_TABLE, just skip it, as follow:
> >
> > SCAN_EXCEED_SHARED_PTE: 2
> > SCAN_PMD_MAPPED       : 147
> > SCAN_NO_PTE_TABLE     : 173
> > total progress size   : 45 MB
> > Total time            : 20 seconds
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >  mm/khugepaged.c | 38 ++++++++++++++++++++++++++++----------
> >  1 file changed, 28 insertions(+), 10 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 4049234e1c8b..8b68ae3bc2c5 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -68,7 +68,10 @@ enum scan_result {
> >  static struct task_struct *khugepaged_thread __read_mostly;
> >  static DEFINE_MUTEX(khugepaged_mutex);
> >
> > -/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
> > +/*
> > + * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
> > + * every 10 second.
> > + */
> >  static unsigned int khugepaged_pages_to_scan __read_mostly;
> >  static unsigned int khugepaged_pages_collapsed;
> >  static unsigned int khugepaged_full_scans;
> > @@ -1240,7 +1243,8 @@ static enum scan_result collapse_huge_page(struct=
 mm_struct *mm, unsigned long a
> >  }
> >
> >  static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> > -             struct vm_area_struct *vma, unsigned long start_addr, boo=
l *mmap_locked,
> > +             struct vm_area_struct *vma, unsigned long start_addr,
> > +             bool *mmap_locked, unsigned int *cur_progress,
> >               struct collapse_control *cc)
> >  {
> >       pmd_t *pmd;
> > @@ -1256,19 +1260,27 @@ static enum scan_result hpage_collapse_scan_pmd=
(struct mm_struct *mm,
> >       VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
> >
> >       result =3D find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> > -     if (result !=3D SCAN_SUCCEED)
> > +     if (result !=3D SCAN_SUCCEED) {
> > +             if (cur_progress)
> > +                     *cur_progress =3D 1;
> >               goto out;
> > +     }
> >
> >       memset(cc->node_load, 0, sizeof(cc->node_load));
> >       nodes_clear(cc->alloc_nmask);
> >       pte =3D pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> >       if (!pte) {
> > +             if (cur_progress)
> > +                     *cur_progress =3D 1;
> >               result =3D SCAN_NO_PTE_TABLE;
> >               goto out;
> >       }
> >
> >       for (addr =3D start_addr, _pte =3D pte; _pte < pte + HPAGE_PMD_NR=
;
> >            _pte++, addr +=3D PAGE_SIZE) {
> > +             if (cur_progress)
> > +                     *cur_progress +=3D 1;
> > +
> >               pte_t pteval =3D ptep_get(_pte);
> >               if (pte_none_or_zero(pteval)) {
> >                       ++none_or_zero;
> > @@ -2288,8 +2300,9 @@ static enum scan_result collapse_file(struct mm_s=
truct *mm, unsigned long addr,
> >       return result;
> >  }
> >
> > -static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,=
 unsigned long addr,
> > -             struct file *file, pgoff_t start, struct collapse_control=
 *cc)
> > +static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
> > +             unsigned long addr, struct file *file, pgoff_t start,
> > +             unsigned int *cur_progress, struct collapse_control *cc)
> >  {
> >       struct folio *folio =3D NULL;
> >       struct address_space *mapping =3D file->f_mapping;
> > @@ -2378,6 +2391,8 @@ static enum scan_result hpage_collapse_scan_file(=
struct mm_struct *mm, unsigned
> >                       cond_resched_rcu();
> >               }
> >       }
> > +     if (cur_progress)
> > +             *cur_progress =3D HPAGE_PMD_NR;
> >       rcu_read_unlock();
> >
> >
>
> Nit: Could move this at the end of the function. Looks weird before the
> rcu_read_unlock.

I placed it on the next line of rcu_read_unlock() because it follows
the loop more clearly for readability.

> Reviewed-by: Dev Jain <dev.jain@arm.com>

Thank you for review.

