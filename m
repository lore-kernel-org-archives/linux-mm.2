Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 143A5CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 06:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31EC88E0002; Wed, 10 Sep 2025 02:18:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CF708E0001; Wed, 10 Sep 2025 02:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 197338E0002; Wed, 10 Sep 2025 02:18:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 03DFD8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:18:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A037B140694
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:18:26 +0000 (UTC)
X-FDA: 83872336212.27.E3A402D
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id C9E4410000F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:18:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FlO1c1ea;
	spf=pass (imf05.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757485104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DYzJL7Hx4cl0FskNvKkVhvtLZ/R9JXw2qBXsF5fYGzI=;
	b=S2IPAsbQrVquKSoEhX30lcgE8huFuFV5Hj704b5ShyBzVpdci1ISIxhwKyWyBnS3F+pkKh
	iT9RX+/4narPh+1RhV5SwRq+IZ/6yidzLk3SLImZzBHsL13xYJc1CSS/nqnadweT0bAAXs
	59+wQypNx7t9WckBm5wgukCWZ8PPzDk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FlO1c1ea;
	spf=pass (imf05.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757485104; a=rsa-sha256;
	cv=none;
	b=XoqAy/1+zWxDHjsDpESPMe0GnA9F0/5u2aqWiYS0kE6Vv7Wy7Y+6BxTe0heEhQaTkf5mPb
	lwcJ7Qc1gCeTL3+XJXhFVJecOD+2054s0b6ql03U1vMbFjSy3t97CtpK82Hgtz5gv5hNb7
	NKI0PskYK57UNFHO9OQnE+A3XVwBT/U=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-729c10746edso51024766d6.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 23:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757485104; x=1758089904; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DYzJL7Hx4cl0FskNvKkVhvtLZ/R9JXw2qBXsF5fYGzI=;
        b=FlO1c1eajzh81PMODcvKkNWadNhqdeTFOshGjlqdYZd6/Z9QYc0VkjfTp2Bk+hFbAg
         2UxtSsWH61hZdj2WTePyKKjl15BCSWHsg0LpvVFiIUoOv4UYHVz2Q5ESwgNF5Qnez8PW
         Auo88wq4YJZx0Z//A2Lkh9gm8jg5ttY9f5mGVnmwKh5RNQaK1RteZ/t1Y5LkC1J76SB0
         /rrBVkJ9LwldbhnSDV0pDhSEBA187Cw4uYPyj1rvH0HGoCy0aZNgpFt55zgFyUU3/I+i
         gC61NlOwiI+ptlH1scu/dYAWPKiByZ4oN7L4v8V+U/hL1LnwIltgMhECmvl+xPcxCzwY
         9E7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757485104; x=1758089904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DYzJL7Hx4cl0FskNvKkVhvtLZ/R9JXw2qBXsF5fYGzI=;
        b=UZo2GfEBVcmvv0nD5y8yQz1Kby0z6d1ZuBjd1b6R8KwT9KNmB7Vgex/ZIXe9zBkiZ0
         I8PSzbg/n/9n2ExNBLoB7GRJMvA6/C+tg4DJe39FShlYISzcbvAGcXPvfMqY/lNNkct1
         itMp7qusUex10UfGJ+pAkrLCQJ4NV7H0WS5yGQYNK5nQ37PL/GG8CbQV5bdxPcfpbZcQ
         t6nOdVUaep94YlewctTHd67LTansoVKiGmo7qpKE0MItmpnO0WWuFgpCpx0v/9Dw4pKt
         /eUDv7T0afXtu/cSgPr6HfA1+5bcCaJklQCoZwq+xrx9oTCbG7NphfPWmK6FIR2q6PBL
         c3hg==
X-Forwarded-Encrypted: i=1; AJvYcCVTQxfCvuw9L/w3py/jm/hElZRL+cg/XRV8ORLkvRoTzyvwNwCib87P54idT3j72rnVOoSI5q6FeQ==@kvack.org
X-Gm-Message-State: AOJu0YxHZE1h3VivGGXPAC6Yg41954cPxK/GOs5AUL7ulSLNwVUjBg2R
	w8tTlOh88i1GB12q0dWWovzzVqmKYoTGBa911G3tcLXiz8BnY2QPVcmoDC/j/LUTxVg+2QmAGkf
	5y2cAVRPWKbx3cTJONlWnXiGhqGrEqFI=
X-Gm-Gg: ASbGncs6zNy/Vd6nh3H2N91guUjxBwPNEkM7fP//3AEx54JgHmObJrq0ibYDW7AiplE
	C6vmJQK77j6jovN8ymVhzzqr2EIz4M9vTLm8ib1bcrDIlmVqQd2IPwoxLRx8sWqd7p0wSaJEv+w
	VvUHt15XOGEcezJPO2G4oGehPocgaSRw9KVZNE2H/T0dlIB4q8b7dTLiGxYdQxeknbWVPoh9mlA
	g9Q70A5ObWWnHdts4KrSu01rZcZROM4SNCAk4njOrjwNcB95JE=
X-Google-Smtp-Source: AGHT+IFvX8ysVDBbiXtbizZMNGoZJmz5YmPfl+MEXyDzgFg9igYbqr/nnoZNtm5eoSPGvCef4i3c5jWe9oYtmW6CEfo=
X-Received: by 2002:a05:6214:1c43:b0:720:3cd9:1f7e with SMTP id
 6a1803df08f44-738f718cb4cmr113550666d6.0.1757485103832; Tue, 09 Sep 2025
 23:18:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-1-laoar.shao@gmail.com> <20250910024447.64788-2-laoar.shao@gmail.com>
 <7c890b42-610f-42ec-acf2-b5b9f95209b1@linux.dev>
In-Reply-To: <7c890b42-610f-42ec-acf2-b5b9f95209b1@linux.dev>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 10 Sep 2025 14:17:47 +0800
X-Gm-Features: AS18NWAEtXjJHwi77ZRJ7QtvbBT2n7zXaHBMPXJVp87PMZaJZ2j5bODmbGmPrA0
Message-ID: <CALOAHbDWJMyNQknX9ihGKuAJNQk+MuG8Af4cpLh=0N5mB_-2tg@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 01/10] mm: thp: remove disabled task from khugepaged_mm_slot
To: Lance Yang <lance.yang@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	Lance Yang <ioworker0@gmail.com>, baolin.wang@linux.alibaba.com, ziy@nvidia.com, 
	hannes@cmpxchg.org, corbet@lwn.net, ameryhung@gmail.com, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, rientjes@google.com, andrii@kernel.org, 
	daniel@iogearbox.net, ast@kernel.org, ryan.roberts@arm.com, 
	gutierrez.asier@huawei-partners.com, willy@infradead.org, 
	usamaarif642@gmail.com, lorenzo.stoakes@oracle.com, npache@redhat.com, 
	dev.jain@arm.com, Liam.Howlett@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C9E4410000F
X-Rspamd-Server: rspam05
X-Stat-Signature: jp9pme9yr8ettep7cof876fuz7orp1qk
X-Rspam-User: 
X-HE-Tag: 1757485104-992124
X-HE-Meta: U2FsdGVkX1+CO4wuKNEQ+ee0yX2FH5tGsdRvKTskaB4YZGa9AF27KLCa7HOX7ToZ0lcjzbtV+sGVgJO8lR4+dsyqbaJk3bdoQf/IwZR0RrJ75o/GHadv8VWd2J1Dfyq7VJPQkw7u2fHth9KjcptI9RneRfkqklLKMlOEcy6cAmbL3JKaj4qzjF5mdk0jqUqUkNb4pRyKddwrv5XxtUTXT1XYN2t8LoS8fkidFtLfLhHdIPxhXOXJI28OWfKg9p0Bri6QIII23NxByLslLdCLhsswk0HGDzaD5PPZleNtRVEiJyg74salVE47n0YAusYWPxBRYXY2bUGwnaG9loRj23jYWjN/2SzzpqpRU3jzwpHzFUYB/jIX2B04PTjNSrMbf6eiXoiEN2lCW8wmz0h11Z8HfAvKIEeFAAZvVugFkEHRRf8g927Kt1L9GAvYcKv741I8FR3H2Wpt9bcKPab7A2df0b3XHVZNTObeekua02NXqzUh979eWCpXHGPH4byAZLUja6B7O9gZ25a/fW499a90BSQ8GO7/gBbdJwqulHzyJXjkJpgJ52K2qPELPtsmZvmkSVP8Cm0VRFWeqIx11PGGioadUNAswmpmJTW71oPTVon+hA3lumhedP2vvM6O7OmCpcCPVJmH9GJxVg3lfoXwR4dr0KsLhHC5xtGKe6Ep4Y2S7mylDg1N2Auhh4K2w0zRW05yZCJ46RkNj6QOgj9B8hTGVgCFhKQogl9HfOlague/hKhRqf8UbjK89SfW76c8dvyj7f69gY/5zG2Fum7rvaH9FdYrCtoi5dSZ8JNiXS9sgDXDxqJodTR2d/t47B7x7EvXJfJzgA94N0YWH50OmcFr1tePjBC+J3fvA63KizuoLnm0Tt/VEv0fXqcdAhfJoKtOBNjaS8KthjrCHcdPA19O27a9XtBXHY7TGZKw/SEZJIfqKTKRmWLoIK9nfoGHxfjfBpSENErV5Hv
 +PDlpQaw
 BTki4AZmV+dwA3JOuSBcstsh21ZTCvnn6byT4uFqFZdcsIirRz21SWJSjoQmxrt3ce3V+NaSNVvokwgabR1mgk4yxHhaQK7Xqeb7jCKByr4hEMRjvHArsHvTu3oMIXCNBdhDgxEJoDAlgOBUo2zpmKQDjkNlSro105Owpg9ItpSyRe0D/DHUNs499aqguGdycpKcvp4Y5ekoEtUB8jux+ejClQ/gFyCx6lF4j3UKvr+kIAXzFVsbsZwWJDxfNWvxo8DHh0jvYkETtu6Io3qEl4YOtxe9dgv2RCPlDlpnGGLaXZBVjyxqqnozUx2gY0mmsx7h+kVVG9rRdYoa6Kd1dpQSGOpGjBpIzxhUJSXjH9gzn8xano3Myr+H0cwvn7EwcHIs2kC4KlbAIN1yPdj/VMKGipb34UzLTBwVpGWp5Ja3blv/lT7tkNQHf26xUqzIXmt/AB/sI6sPnROB0M8ZoMhw/ZL+LPEuGKkz/mzX72MqGeMu9EgNJ25uDY99TmUoX98hadZR0hYsSskkYgD3Kl2s31g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 1:11=E2=80=AFPM Lance Yang <lance.yang@linux.dev> w=
rote:
>
> Hey Yafang,
>
> On 2025/9/10 10:44, Yafang Shao wrote:
> > Since a task with MMF_DISABLE_THP_COMPLETELY cannot use THP, remove it =
from
> > the khugepaged_mm_slot to stop khugepaged from processing it.
> >
> > After this change, the following semantic relationship always holds:
> >
> >    MMF_VM_HUGEPAGE is set     =3D=3D task is in khugepaged mm_slot
> >    MMF_VM_HUGEPAGE is not set =3D=3D task is not in khugepaged mm_slot
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Cc: Lance Yang <ioworker0@gmail.com>
> > ---
> >   include/linux/khugepaged.h |  1 +
> >   kernel/sys.c               |  6 ++++++
> >   mm/khugepaged.c            | 19 +++++++++----------
> >   3 files changed, 16 insertions(+), 10 deletions(-)
> >
> > diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> > index eb1946a70cff..6cb9107f1006 100644
> > --- a/include/linux/khugepaged.h
> > +++ b/include/linux/khugepaged.h
> > @@ -19,6 +19,7 @@ extern void khugepaged_min_free_kbytes_update(void);
> >   extern bool current_is_khugepaged(void);
> >   extern int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned lon=
g addr,
> >                                  bool install_pmd);
> > +bool hugepage_pmd_enabled(void);
> >
> >   static inline void khugepaged_fork(struct mm_struct *mm, struct mm_st=
ruct *oldmm)
> >   {
> > diff --git a/kernel/sys.c b/kernel/sys.c
> > index a46d9b75880b..a1c1e8007f2d 100644
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -8,6 +8,7 @@
> >   #include <linux/export.h>
> >   #include <linux/mm.h>
> >   #include <linux/mm_inline.h>
> > +#include <linux/khugepaged.h>
> >   #include <linux/utsname.h>
> >   #include <linux/mman.h>
> >   #include <linux/reboot.h>
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
> >       mmap_write_unlock(current->mm);
>
> One minor style suggestion for prctl_set_thp_disable():
>
> static int prctl_set_thp_disable(bool thp_disable, unsigned long flags,
>                                  unsigned long arg4, unsigned long arg5)
> {
>         struct mm_struct *mm =3D current->mm;
>
>         [...]
>         if (mmap_write_lock_killable(current->mm))
>                 return -EINTR;
>         [...]
>         mmap_write_unlock(current->mm);
>         return 0;
> }
>
> It initializes struct mm_struct *mm =3D current->mm; at the beginning, bu=
t
> then uses both mm and current->mm. Could you change the calls using
> current->mm to use the local mm variable for consistency? Just a nit ;)

Nice catch

Hello Andrew, David,

The original commit "prctl: extend PR_SET_THP_DISABLE to optionally
exclude VM_HUGEPAGE" is still in mm-new branch. The change below is a
minor cleanup for it.

Could we please fold this change directly into the original commit to
keep the history clean?

diff --git a/kernel/sys.c b/kernel/sys.c
index a46d9b7..2250a32 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2479,7 +2479,7 @@ static int prctl_set_thp_disable(bool
thp_disable, unsigned long flags,
        /* Flags are only allowed when disabling. */
        if ((!thp_disable && flags) || (flags & ~PR_THP_DISABLE_EXCEPT_ADVI=
SED))
                return -EINVAL;
-       if (mmap_write_lock_killable(current->mm))
+       if (mmap_write_lock_killable(mm))
                return -EINTR;
        if (thp_disable) {
                if (flags & PR_THP_DISABLE_EXCEPT_ADVISED) {
@@ -2493,7 +2493,7 @@ static int prctl_set_thp_disable(bool
thp_disable, unsigned long flags,
                mm_flags_clear(MMF_DISABLE_THP_COMPLETELY, mm);
                mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
        }
-       mmap_write_unlock(current->mm);
+       mmap_write_unlock(mm);
        return 0;
 }


--=20
Regards
Yafang

