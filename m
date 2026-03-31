Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EDB8FF60D5
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373CF6B0092; Tue, 31 Mar 2026 15:46:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34B7D6B0095; Tue, 31 Mar 2026 15:46:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260F16B0096; Tue, 31 Mar 2026 15:46:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 189386B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:46:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C706587F9
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:46:29 +0000 (UTC)
X-FDA: 84607390098.23.3293559
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 575DC160006
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:46:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jPqQBLeJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774986387; a=rsa-sha256;
	cv=none;
	b=xTdPPuNSEfSuezqVR1ehmsJyBgT+jB7JWlqiclDePy0AFyA5t7zFVY35RfTe9mDedkkHZS
	7FdUOmrVdE3rvDfAxsbFtO9yFAmGVTO+YG8ja4HdrifWRXeuJfKnPo64ziuJLqL2hL2MW6
	tlBiLBPDqqgWEyRU2xADaa+ylkRwVOQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jPqQBLeJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774986387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q8BjP7+GhIxs8lROs1Fn+DrDYt+KVQ0hPZx9lAMZ8wo=;
	b=o4pC8AxcIPPddWN0uAcWbLTAwAYped05/h4bo9CUFkaMliw4NXLeOB7MPSPz2UcLNfBPnN
	yrGTUUacox1K/j1mFuW4v4XSOQym5eijvpWGGKHw3Nx7LI62f/Pf3wD1MjrnKBCHyc6QTB
	AdP2IY3RV338iTdbMDuxLHFn2PakvhQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774986386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q8BjP7+GhIxs8lROs1Fn+DrDYt+KVQ0hPZx9lAMZ8wo=;
	b=jPqQBLeJIEidkCiESzOB9BJiY1PNW2wtGuJDVtoj7qR3URf/oLnayqPny4XJxVvm3ueNdY
	bLk3zKGu+/WGyjb7dFXMEt2TtWQksuq7bruDnMlqUXQ7A7M9aCbzGPlDvidrINGRbtcyya
	6PcLyUQ0QWAPI02xJpe/littcKRi5OA=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-248--xbao9lCOyGSDB9d_D_I5w-1; Tue, 31 Mar 2026 15:46:25 -0400
X-MC-Unique: -xbao9lCOyGSDB9d_D_I5w-1
X-Mimecast-MFC-AGG-ID: -xbao9lCOyGSDB9d_D_I5w_1774986385
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-64eec2f1f76so18996084d50.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:46:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774986384; x=1775591184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q8BjP7+GhIxs8lROs1Fn+DrDYt+KVQ0hPZx9lAMZ8wo=;
        b=eSfX4JuCFfnqYMPM+ewlT15yDH28zifIapRKxes5ZZdZdaHutEz9hx86ojp87bDIbK
         8UGA+kJAz0A6UdV/nOEdQcv7byR3HHu++fTE0Xu1uw9yyH13L2TY0Gbl3XHjmIb9v4FC
         kzjpJ0BA/5j4KbmCFAbi8VwNKHAMbPfVQXDRiO2TR2YtonMzjGq34+YsuNZ6G99qtvTp
         Y/D3tVyNLuuuYMnJb+DVMPso8amzxoScl84/UOOwvLqbKR8QDwPIbZpmSgNyq1iLwmHk
         c/DQOKY2Q4rmQDjWWqNdwUJIHobOUB3n+ks26o7T0ySKSczIOLZjPN0OreRVqh+lriMm
         aTPw==
X-Forwarded-Encrypted: i=1; AJvYcCXR/Mx6qpZTVkCGWLg73HXJvb3sTg614Wevmb5ePo6m1PZjZPpkVPufFTCaeCcqtecuv4cBEagmsA==@kvack.org
X-Gm-Message-State: AOJu0YyC/oao7ooavoDAlXfL/H2kGqS7Gsl8tiUUVQpN6ZOM4AwuiKzw
	x3znKCHJkeEIYMlDcZWDSdFWWthtH5xLQg+I2q2vA6yeWoyg9e0dywdFf/AF84POHteR5TQDKKx
	bLasZxGNwilZUu9keWOIDaw4uxnjekUVkamQcAoZZh0oOd/G2SUR/8eRamsyO7HlWGIN1OeSBNy
	q1YwkVPwDYDLyEw7EuqeChZiz+JHxLdL7Hq/RHbQ==
X-Gm-Gg: ATEYQzwRrB5nA02adIpYnuNM0SHA9y3pe6aPNz1BXz2/QoGrkQko+BhyztFhwtG4fYF
	L5OSICemsVc+Ys0oGn78DeoOETOSlu09QcQNC9SUVeYhin9iMjsmYNWSeog17auhfDtznQeddyM
	Vu5OB4w/LYADG/a9WuGO/8gTucegbyH6B3hRYXdxaXZp6ZyI10Fs2h2QFTYkBvzdH3kvdQriq1w
	phSDcKI
X-Received: by 2002:a53:a046:0:b0:650:19c7:c5d3 with SMTP id 956f58d0204a3-6502fde1580mr522234d50.32.1774986384542;
        Tue, 31 Mar 2026 12:46:24 -0700 (PDT)
X-Received: by 2002:a53:a046:0:b0:650:19c7:c5d3 with SMTP id
 956f58d0204a3-6502fde1580mr522200d50.32.1774986384075; Tue, 31 Mar 2026
 12:46:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260325114022.444081-1-npache@redhat.com> <20260325114022.444081-6-npache@redhat.com>
 <7760c811-e100-4d40-9217-0813c28314be@lucifer.local> <0223d45b-e8b4-49a7-882b-477250d0c14d@kernel.org>
In-Reply-To: <0223d45b-e8b4-49a7-882b-477250d0c14d@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Tue, 31 Mar 2026 13:46:02 -0600
X-Gm-Features: AQROBzBjeVXf5TbX5QTMgNURNVgrNol1piCJYvh3bRZAuoeVgKUKqvb41pp2SFw
Message-ID: <CAA1CXcAHa9KOR92oHAPZ0z44DKS6yhgNArKoH6caVSBio0z-8g@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v4 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	aarcange@redhat.com, akpm@linux-foundation.org, anshuman.khandual@arm.com, 
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
X-Mimecast-MFC-PROC-ID: mFLE4v7qfhKVf25sDUlV015tMG9hSGsycCBg4FhdOM8_1774986385
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5tku3z8cnibzfgku4ars1ryrqiaurymz
X-Rspamd-Queue-Id: 575DC160006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774986387-428351
X-HE-Meta: U2FsdGVkX188a2M0wMEMmXlSjXy1bboJ82/jU732UVPuS8yrdDIikcmguzwGLEUoI5W4ooKa/fCeoaplcMTzVAd5Zw8t3zXJjoGEAZK78ixP/VDN0XRxjDtwKa1IKXd8ndZCRg+Mw0SuFj3q00pisFsSCuDyIHV03mH8wK2uHTejONVnZ+E/ZiKFd8LDfEjPOJEqt7gcVrrmvtrgyOUpIfUxmbo0HGY/uV4PLEMsertfdUU3hbef39cQmoV2w+e7rsYMCuiG6l/wQVLQ/WSX+lwhph+RE+mvInqOcKF38uAlWcpBGJRvH5q6ggZuAL6FEfiFO2ikBFinBh2uK2/hR/RPD1QhvJ4ROzMzuwPpL225GXm7V9cFfLqwnPHnC6+QqG7AvT17nwFw65uSGn3TCgqYN2JfBHFfrAv5Q16aBjA1kef64xomcfnHzOM4Fw1OXHO5VPQWFUZijbm/gBD3rsE4cgGtxKfq5/VafKo7KtKo4iGHAY3LkBIIFeoUMCaS1VqwHm0dh8jNb73VFUjE1Ucah+7ARHMNS04Pjd4C/6mYuYNEJ2xWCXihTKEob6IAPMc+i63AhP9j8MMuT2uGm1wos5hippY5VhkLNRpCKu6A3kd72CzQJiBDUqtEjY9cr64LrZ6+tj8xOl2Ru7ZZ4T2GwBWbxSm+tMFAw2DZfu2El9vuIzmduZu6MTaDmgb5Grr2NpvmVzLDW1huQSVp1PnHD8iVjT1CF54tlI6nVt2rvTD0Y/YI0uXZ9Vlz82shlmvfHy/5pFoSp/Rm7LlhHP7jhhgyXnC44bPrPjuxBetagHN3BTPqosaPOK1MwyCZPyjfJBFRumNkYE4feMDeScsDnZTc34L86UAY8J4VY+UWUZxuw1IX0hq03jGUNVWNNiZwpSnJFo+uvJwyYZjgc0ZmfMxHaC/SayyjR1MNMJlUliNLe+kEnfQMg4jt/zREB0YomK+Lvi/DKuzPGpX
 /QRnfPF0
 sm7D8MlX5/eNWKcPmQXAEpiStfgC2oBmjGJKHuKzcmlzD0ocpY8CJ+lbIODmAXGq517c0hX9BaiOuFeolRIH25nTzH5XHQGmRZ9EwxGcu2fFWuBcTA91jVMpnmyMbf0DjzFqZGAUpC/WMoj3XsLYo4LWRsHZit5jdjZfzx1PP82iz5R2MMlsTPqFOu71DuHg1qTtKKg8gZ1iXYkNPZgnd3cxaDzLzIfxxw2ufSoGUH3vSPqWGmwurJASQF0/3x5bupl2Hzers1JQB5ZLIJscukEnCxUqiIbspMt2/0csl20+g866wwgPcIL3g0mnZHDao/yWgv7j85ErLOFuwHEIkdEWb3ls1mEor4soPuJ5hwL0E827PdPl9Hfc7uy6XMsWX/DPVLqi/x+/Jvtf3/vpB08pBsfISK3iCbRL+M+LkrVq5GB2XK5kzykzC+7K2rRj8l/9XGgOp7yePR9kMch/7Qx4ChARC0OBFmM4T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 8:13=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> >> +            if (*lock_dropped) {
> >>                      cond_resched();
> >>                      mmap_read_lock(mm);
> >> -                    mmap_locked =3D true;
> >> +                    *lock_dropped =3D false;
> >
> > So this is the bug. 'lock_dropped' needs to record if the lock was _eve=
r_
> > dropped, not if it is _currently_ dropped.
>
> Ah, well spotted. I thought we discussed that at some point during
> review ...

Yes I think we've discussed this before, and IIRC the outcome was, "We
weren't sure why this semantic was in place, or if we truly needed to
track if it was dropped at any point, or simply if it is currently
dropped.". The code is rather confusing, and changed mid-flight during
my series.

Lorenzo asked me to unify this semantic across the two functions to
further simplify readability, but it looks like we indeed needed that
extra tracking.


Cheers,
 -- Nico

>
> Thanks for tackling this!
>
> [...]
>
> >
> > ----8<----
> > From a4dfc7718a15035449f344a0bc7f58e449366405 Mon Sep 17 00:00:00 2001
> > From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> > Date: Tue, 31 Mar 2026 13:11:18 +0100
> > Subject: [PATCH] mm/khugepaged: fix issue with tracking lock
> >
> > We are incorrectly treating lock_dropped to track both whether the lock=
 is
> > currently held and whether or not the lock was ever dropped.
> >
> > Update this change to account for this.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> >  mm/khugepaged.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index d21348b85a59..b8452dbdb043 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2828,6 +2828,7 @@ int madvise_collapse(struct vm_area_struct *vma, =
unsigned long start,
> >       unsigned long hstart, hend, addr;
> >       enum scan_result last_fail =3D SCAN_FAIL;
> >       int thps =3D 0;
> > +     bool mmap_unlocked =3D false;
> >
> >       BUG_ON(vma->vm_start > start);
> >       BUG_ON(vma->vm_end < end);
> > @@ -2850,10 +2851,11 @@ int madvise_collapse(struct vm_area_struct *vma=
, unsigned long start,
> >       for (addr =3D hstart; addr < hend; addr +=3D HPAGE_PMD_SIZE) {
> >               enum scan_result result =3D SCAN_FAIL;
> >
> > -             if (*lock_dropped) {
> > +             if (mmap_unlocked) {
> >                       cond_resched();
> >                       mmap_read_lock(mm);
> > -                     *lock_dropped =3D false;
> > +                     mmap_unlocked =3D false;
> > +                     *lock_dropped =3D true;
> >                       result =3D hugepage_vma_revalidate(mm, addr, fals=
e, &vma,
> >                                                       cc);
> >                       if (result  !=3D SCAN_SUCCEED) {
> > @@ -2864,7 +2866,7 @@ int madvise_collapse(struct vm_area_struct *vma, =
unsigned long start,
>
> (in hurry so I might be wrong)
>
> Do we have to handle when collapse_single_pmd() dropped the lock as well?

There are some oddities about madvise that sadly I don't fully
understand. This is one of them. However, I dont believe khugepaged
had these lock_dropped semantics and just tracked the state of the
lock.

>
> --
> Cheers,
>
> David
>


