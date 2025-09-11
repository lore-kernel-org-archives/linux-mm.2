Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28B07CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 02:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87CAF8E0009; Wed, 10 Sep 2025 22:35:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853F88E0001; Wed, 10 Sep 2025 22:35:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76B168E0009; Wed, 10 Sep 2025 22:35:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6554F8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:35:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11903C035C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:35:45 +0000 (UTC)
X-FDA: 83875403850.10.FC0921F
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id 641E3C0002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:35:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C5XSSUxI;
	spf=pass (imf22.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757558143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4vb0qYaqmVSkWJUt9xOeYowmF68E2HlHjMlrygJw5Ps=;
	b=EjoO7fw11+4lB35QHtw9Y5U0pivcj9tApkmtXtngf+ONht2ksU49fQkyCZTr6UzSzCVe5d
	a7ZRX6kgcZwMRiCI1wlgGestuyk0ZrWjgqdxRRXUeEqzoy3F/To5riHSQrHU24LoyM7/aN
	efJ1kUVJBmh5+GbyXpcJtyctp7DYpv8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757558143; a=rsa-sha256;
	cv=none;
	b=AuydLzqkaUnk8l1fb1DDMj+w7rdpPVRncrQKR3+ML8uw2At2/sfxTeQqZzxfYqBBoPEjJf
	vITUzn/pp7zhz0sqWRtDwSJchyCK0K1iJjpVvtnPBKolFG5wLmDtfrGEGOV7EizW4aOS2V
	4+InvnwyBzRzTPOgRAf/Pmj24GoZxAQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C5XSSUxI;
	spf=pass (imf22.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-7251e6b2f9eso1132166d6.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 19:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757558142; x=1758162942; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4vb0qYaqmVSkWJUt9xOeYowmF68E2HlHjMlrygJw5Ps=;
        b=C5XSSUxI6eHHn7gm7JoA6CxGrVJ4dKeUhuVl+FhqdU2HfGNtqkAar1FujLzDIr+pe2
         VBNb5WxBGZTbpnNrM4PqaHBUC0LdJL3OrewMoTUMrtGpumgrMhJIWxavBwLIAy5GZy0O
         l7vaSgJdlA1Rg6DhSJ+CtAOlNVregP0hJfigX1OsQNWHEB+yhobaygcqUe9olViOrd+T
         srHW66odgGpSldEJccITRp7GN5f62UQNnSeD3x5DWZguum6JtElQuLsj2XozqAfexicm
         EfeG2AYFW1okMmW4r+CVMoskwRiBgQ2xS52fLBrJdsw/4rQ8VbEKkGzB+kBnODbwATEX
         wNkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757558142; x=1758162942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4vb0qYaqmVSkWJUt9xOeYowmF68E2HlHjMlrygJw5Ps=;
        b=wVa6UsGt52ImJeWjEQEc6u2aO2oDDrCn/drW7QoR8At1WnwQhwmDu12i/IhCyK7GPa
         OggP+LqqHyUs+gMMDmBudhkae/Wo/a1IXHV5532vDecYo82OBNO32yIrjJXZHDIRNxuh
         ZD5ivBpPB/buTI0PzadFBz70HPv5wjnWocP07PcExvIAcQrYKBTUW5MRYjR6ACIxa+KU
         VP75pPHh7CEN+k2F3HjgQM5RtUR7y5ahmU8beeL80JBakfHbnL92gwbq1fgRKD5safTO
         lsHEm9jfxd+2899LGxH/5nwqgC/DypWRksTSXn73LbtoBcFtZfCqARjYi48gdBHJSCgV
         Lrfg==
X-Forwarded-Encrypted: i=1; AJvYcCWigAKTCThOmika2KAGJbcaETT3REni3DWLNdyTYTtn5WBwJ4RTVGUPiewSDR1mwIWf44jE7fq1YA==@kvack.org
X-Gm-Message-State: AOJu0YyQy+MnFD+Ivp+lukhlgUmmhsMNCgJFBH/keL8u3H8BEHgLriLg
	0NbLrcc9h1ynlUf3ZG+v1A6GIUHhjcBBClu8OmZOwMMVnzM0B0O6YXq2Fq0x7mGBbfx7iZ3nxxK
	eWo0dKSKoyLFoUXJHElh/B/XMXwbRNOA=
X-Gm-Gg: ASbGncs0PIzmZGWUrauDmVp095SLBVs30IMNk/X/T8Q9lxJNowLTKSZTbmln9sfAcDC
	gEEylRn4lEMj7iu+EalY/UpLTfYXbPknTcVS3HUp7c5HcKPMSKFGWTRJdw2DBMmSjvkcdTk1nVC
	wlvYKlQN6iu6chbvk20cC0b2KntrggXOEyEEwzIGiMzWc+iwteDJiVY5OLU/tDAlngKT16gnETA
	LH1nGvWbL2yuoOfgWOKptvj4BRAsrjOSOoZW9o6cuxlAV2sCKQ=
X-Google-Smtp-Source: AGHT+IEQuOALHNasxHg4cvt9OwSYb+br0tjCphBPeNs06MifOpRvuGmCrw3mRabXyOespOL+oB9+DxVIm2bQo1YAM1M=
X-Received: by 2002:ad4:5aad:0:b0:721:ae2c:599f with SMTP id
 6a1803df08f44-739431f1ccdmr178704756d6.46.1757558142442; Wed, 10 Sep 2025
 19:35:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-2-laoar.shao@gmail.com> <202509110109.PSgSHb31-lkp@intel.com>
 <49b70945-7483-4af1-95ba-e128eb9f6d7e@linux.dev> <DF4CA2C0-25AF-462B-A6D2-888DB20E0DFA@nvidia.com>
In-Reply-To: <DF4CA2C0-25AF-462B-A6D2-888DB20E0DFA@nvidia.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 11 Sep 2025 10:35:06 +0800
X-Gm-Features: AS18NWCT1WMJgiNa7kbBl9p5Ko8LuUJHHLo5A82nBykaRI1tVPLVfUPD6miHkHg
Message-ID: <CALOAHbAWwX2Y50J=H8=ahXk0t9fWh=61gd82E7LJd_k5jWg3EA@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 01/10] mm: thp: remove disabled task from khugepaged_mm_slot
To: Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	Lance Yang <ioworker0@gmail.com>, akpm@linux-foundation.org, 
	gutierrez.asier@huawei-partners.com, rientjes@google.com, andrii@kernel.org, 
	david@redhat.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ameryhung@gmail.com, ryan.roberts@arm.com, lorenzo.stoakes@oracle.com, 
	usamaarif642@gmail.com, willy@infradead.org, corbet@lwn.net, 
	npache@redhat.com, dev.jain@arm.com, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, ast@kernel.org, daniel@iogearbox.net, 
	hannes@cmpxchg.org, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: r4t1x18k8yi9jm9taxpb67kq56xpdtnq
X-Rspamd-Queue-Id: 641E3C0002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757558143-442318
X-HE-Meta: U2FsdGVkX19ji3G0h7mDvPXC7Ym+j++B/mIRoKHAAB4UoeR6H6nBRO8TtbGyr0wJkzMh+A3pHW5k7Bf6V+7ILqnpbUdnDdCXZ4jSmNgYpr3PxdGDZ0Yiy7UZPdP6GpLe7ip9Flk7GEtUHldeMkg6VfEh7HkAf+5Y+/Y8wxHkS1gyG0CjBcwwQAJn4GjLu1ckgbdL0navjVyr2MGL3t6mIc6iSQRW1gjRvdHjD4rlzHGldn0wkRifzDXJ0CKpwVSfwua+CLLL5Pw9HlNJwL8UraxGTeaqKPOsYDcy9QO/higsMLTQnoiRkkmyYp4wyuQ8QeyIUwxjV0pntjHkwkDJJfyWD6wDFrLqwDVBt+zDvwMMTnk/9XrOpo+oHQ8qXlaRqEzDPQgBw9bChR51C0ViAVtULHpvN3dh9rEXJgrS6uW2ts9Hiq5JhswggijH0T0vH/3sxgwpWu09vYQ7caEkKgRa65PBCvVs/Or4FJrZUTTWQ5SfJh44pD+4H3ohYrMMcElIuFx3hjT1nd6k634BwfeK8ZtRFKlnhD26H+SdNbjhRjtOwwmmLpuGImSysyQCOBK3opcI9UZgYQ5T9yD5od9NpMfUfj1hQxWqTLtQhHds4/wHO64hMwVNml449suj6Z51Juf6GTvrGLhXkx5L7iksJ/qqJQ4VHJJjQTRQDTUJY2Dumpm7FwfFZYt0NFympHKzb+YF81G4ztYoRJZvzYUwTxCME/efvj+DJH3bSsieb2ECtIwcXjuH5lFNkYtjXnWLoY45wrbw2LfWxHXYOQXwzu7AAQ0lpsDVFnNrndDrQZfzM3q/Rzn2P9e0lw6IEa+NsSl/TMrKnrI9KIqU2ipRPRC7MlPtChhTQVjFQ0cePiAM9nurNfPrhef3MGN2kpZn9lBrX67RzEXveXmzcOQTWW2YKBD4ZD9ORaHHIjmXodIn7rSsi2o+OZUJpVUI52VOHYqW0eJjOrIfIuw
 UJcMC08w
 uC3diDd7SQdiOC7K/NgBS5Bkx57oqzQ6Vn7tXs2Sk4gQMeCMFsboaNh31blqN2JB89nBVUJnDvhrXQy9sRTY63ZX4gC8Ow5vUrBSg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 10:28=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On 10 Sep 2025, at 22:12, Lance Yang wrote:
>
> > Hi Yafang,
> >
> > On 2025/9/11 01:27, kernel test robot wrote:
> >> Hi Yafang,
> >>
> >> kernel test robot noticed the following build errors:
> >>
> >> [auto build test ERROR on akpm-mm/mm-everything]
> >>
> >> url:    https://github.com/intel-lab-lkp/linux/commits/Yafang-Shao/mm-=
thp-remove-disabled-task-from-khugepaged_mm_slot/20250910-144850
> >> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm=
-everything
> >> patch link:    https://lore.kernel.org/r/20250910024447.64788-2-laoar.=
shao%40gmail.com
> >> patch subject: [PATCH v7 mm-new 01/10] mm: thp: remove disabled task f=
rom khugepaged_mm_slot
> >> config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20=
250911/202509110109.PSgSHb31-lkp@intel.com/config)
> >> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 8=
7f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> >> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/ar=
chive/20250911/202509110109.PSgSHb31-lkp@intel.com/reproduce)
> >>
> >> If you fix the issue in a separate patch/commit (i.e. not just a new v=
ersion of
> >> the same patch/commit), kindly add following tags
> >> | Reported-by: kernel test robot <lkp@intel.com>
> >> | Closes: https://lore.kernel.org/oe-kbuild-all/202509110109.PSgSHb31-=
lkp@intel.com/
> >>
> >> All errors (new ones prefixed by >>):
> >>
> >>>> kernel/sys.c:2500:6: error: call to undeclared function 'hugepage_pm=
d_enabled'; ISO C99 and later do not support implicit function declarations=
 [-Wimplicit-function-declaration]
> >>      2500 |             hugepage_pmd_enabled())
> >>           |             ^
> >>>> kernel/sys.c:2501:3: error: call to undeclared function '__khugepage=
d_enter'; ISO C99 and later do not support implicit function declarations [=
-Wimplicit-function-declaration]
> >>      2501 |                 __khugepaged_enter(mm);
> >>           |                 ^
> >>     2 errors generated.
> >
> > Oops, seems like hugepage_pmd_enabled() and __khugepaged_enter() are on=
ly
> > available when CONFIG_TRANSPARENT_HUGEPAGE is enabled ;)
> >
> >>
> >>
> >> vim +/hugepage_pmd_enabled +2500 kernel/sys.c
> >>
> >>    2471
> >>    2472      static int prctl_set_thp_disable(bool thp_disable, unsign=
ed long flags,
> >>    2473                                       unsigned long arg4, unsi=
gned long arg5)
> >>    2474      {
> >>    2475              struct mm_struct *mm =3D current->mm;
> >>    2476
> >>    2477              if (arg4 || arg5)
> >>    2478                      return -EINVAL;
> >>    2479
> >>    2480              /* Flags are only allowed when disabling. */
> >>    2481              if ((!thp_disable && flags) || (flags & ~PR_THP_D=
ISABLE_EXCEPT_ADVISED))
> >>    2482                      return -EINVAL;
> >>    2483              if (mmap_write_lock_killable(current->mm))
> >>    2484                      return -EINTR;
> >>    2485              if (thp_disable) {
> >>    2486                      if (flags & PR_THP_DISABLE_EXCEPT_ADVISED=
) {
> >>    2487                              mm_flags_clear(MMF_DISABLE_THP_CO=
MPLETELY, mm);
> >>    2488                              mm_flags_set(MMF_DISABLE_THP_EXCE=
PT_ADVISED, mm);
> >>    2489                      } else {
> >>    2490                              mm_flags_set(MMF_DISABLE_THP_COMP=
LETELY, mm);
> >>    2491                              mm_flags_clear(MMF_DISABLE_THP_EX=
CEPT_ADVISED, mm);
> >>    2492                      }
> >>    2493              } else {
> >>    2494                      mm_flags_clear(MMF_DISABLE_THP_COMPLETELY=
, mm);
> >>    2495                      mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADV=
ISED, mm);
> >>    2496              }
> >>    2497
> >>    2498              if (!mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm=
) &&
> >>    2499                  !mm_flags_test(MMF_VM_HUGEPAGE, mm) &&
> >>> 2500                    hugepage_pmd_enabled())
> >>> 2501                        __khugepaged_enter(mm);
> >>    2502              mmap_write_unlock(current->mm);
> >>    2503              return 0;
> >>    2504      }
> >>    2505
> >
> > So, let's wrap the new logic in an #ifdef CONFIG_TRANSPARENT_HUGEPAGE b=
lock.
> >
> > diff --git a/kernel/sys.c b/kernel/sys.c
> > index a1c1e8007f2d..c8600e017933 100644
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -2495,10 +2495,13 @@ static int prctl_set_thp_disable(bool thp_disab=
le, unsigned long flags,
> >                 mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
> >         }
> >
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >         if (!mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) &&
> >             !mm_flags_test(MMF_VM_HUGEPAGE, mm) &&
> >             hugepage_pmd_enabled())
> >                 __khugepaged_enter(mm);
> > +#endif
> > +
> >         mmap_write_unlock(current->mm);
> >         return 0;
> >  }
>
> Or in the header file,
>
> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> ...
> #else
> bool hugepage_pmd_enabled()
> {
>         return false;
> }
>
> int __khugepaged_enter(struct mm_struct *mm)
> {
>         return 0;
> }
> #endif

Thank you, both. I will address this in the next version.

--=20
Regards
Yafang

