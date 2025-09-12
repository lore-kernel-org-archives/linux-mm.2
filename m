Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 991D6CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 08:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F36218E0002; Fri, 12 Sep 2025 04:29:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE6DC8E0001; Fri, 12 Sep 2025 04:29:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFCFE8E0002; Fri, 12 Sep 2025 04:29:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CB6D18E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:29:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68ECFC073D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:29:25 +0000 (UTC)
X-FDA: 83879923890.13.072C2D5
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6B57FA0017
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:29:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JzaOY9Md;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757665763; a=rsa-sha256;
	cv=none;
	b=zDma8YAXeWiDVaZQVa7bPstIhCNmEcygUzt3Ub59Wbfjpy1lbtC1RIPp7dm8E7lvW8FytR
	wJJqzVsEB5OAaYN6/slYdWbnvA9RKFPm2G6IuYe/QntWANgQsQJzWP01nilDZz4r0toHi5
	nIFPZ6h33wBp1vW2zJbIKm+42pmctO0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JzaOY9Md;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757665763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UT4GkfQH7Q77VhObaVtW4zsoo1QdteuiKUxVY5qAxx4=;
	b=skYeiR76ndimCEiaE3QayfLz0VR5qcbJWZYKwKTXe9L9q1QfIYKENYMf8bJyHJwCT/8SC9
	rEAPs9G4FCmhFaZPiAq3UEph0X2c6+wgiDmn5TwjvLCcaUIRiqb8LB2w+wBNfVx2xxnurH
	mpdIjMVs2Fy5Hs4JEL/gZL9gg9luuRs=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-76c20428924so2287046d6.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757665762; x=1758270562; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UT4GkfQH7Q77VhObaVtW4zsoo1QdteuiKUxVY5qAxx4=;
        b=JzaOY9MdUVldGwGss9eBGVlzSAWM7F1tMDrhH2FHwqP57P4oZuAS3v+kKA2D6agzH2
         Vh2xS0OzCAMHN3CAGvKcDfipETW8SwuCO8AlUoGFJoS7sqTJ8VpQr8pcJNoLO55/H4ri
         6oyXHm/GkcSO7PLsERpKczOAbMFAvLG6uUjaoI9W1a/P4fT6HMwYKvRQoueD5kNfUx5H
         Hr9/ngth60P34qQAnCXiCZ9vJu4ljOfuZp+ByHiSXK38fn0aGYfg1Ye6UgmIoiHgkJPe
         XvtPu/1myb9yfm+RF6+RiN9Y41ZFpcvn0F4SEEiIuzTRwA3dlqlHP6W85sBwvSePYaKs
         XwcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757665762; x=1758270562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UT4GkfQH7Q77VhObaVtW4zsoo1QdteuiKUxVY5qAxx4=;
        b=wwe9tzrOYM9qqFNnG6jLBkm+pywgIm1FcDvQn+0BeFGLfCwcDsWObGygc47oyGKhQg
         I8agZue+a9QpFMrXoxlbdaOdhbCUQUt2dx+4zA38DSW6CBTMz2pAjC4zSnROilBzLQ+S
         8jqKv5bNUNJxTsKV9/xD3AZ8rwDw7fUeXNaytk7hxzZDmRKOVfMoMUUNEYaAyezunv42
         kgL35h+24JyF1b8LEeFyFyNtwMWh/0Xhxw89YpZNqSZ358uoQ0gb77UMk4yydPA5Qdos
         4U/oRKa4tx1RScNXvoYXGQjzd2F6aziXzAPpd9Il+SqAOPa7wv+g+Z0vg0VqEb/henvC
         IBGw==
X-Forwarded-Encrypted: i=1; AJvYcCVov86Rd4ARqTkzGcYxU7jVlBmyfMEL26vRL19d7f8xA5EQdG6dCFbu/5KV1tiaoO0eRFtowWlgRA==@kvack.org
X-Gm-Message-State: AOJu0YxR3h7toSANiKRmMkp9E7BYE47ed0pP+F7SKhPW5ZZbZyCa8ep9
	mvMjoS+apxiRyKorxP3HVx8E5f68OoYlHyu9PbjdrpwY9H0W7Ct8QBlFe3IOhTCMB8A/bji++XL
	ITVGtx7XBRRl4MUGHaeF/WOth/f5LaVM=
X-Gm-Gg: ASbGnct20BiOERnd1i8mFzF2NOSJWkIOM0bw9N2bKqp4Ts1xc2KYOYDh7WUI/tTTVJS
	ygiNwNx/MSdPECPO7+jEsbw7o9h5VdhIoB8+A16k67gnRy2KXb1RqVYiKjcER2qDQy3XBynKccC
	KWAoaJLXSsDi5oOciPyvZ+u1V9vtUhsjSTziYKE+cpLTm9t5NYhCYlVLMQGcH5+yq+LkWkgh4MW
	d8b2WbmHrNxxO3In9q7LENwo8DoSPkakkZnteGd
X-Google-Smtp-Source: AGHT+IGRwmWY+murcATxsNS4exA4efHW8zui4X5QcN02iFAqtK5Ux8a/+EDSfSqT3Gx34ln92svFIO256LMLgslaL4I=
X-Received: by 2002:a05:6214:5299:b0:72c:5bd6:69ad with SMTP id
 6a1803df08f44-767c78b3792mr24115766d6.58.1757665762135; Fri, 12 Sep 2025
 01:29:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-1-laoar.shao@gmail.com> <20250910024447.64788-3-laoar.shao@gmail.com>
 <4d676324-adc6-4c4c-9d2b-a5e9725bcd6c@lucifer.local>
In-Reply-To: <4d676324-adc6-4c4c-9d2b-a5e9725bcd6c@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 12 Sep 2025 16:28:46 +0800
X-Gm-Features: AS18NWCZIBNJ5kR6bmNor3-BlvQkjf-BV0EXfoE9syj-39GzEW5YzJqyLvnz89w
Message-ID: <CALOAHbB_jrsgEMH=HNozW+rASRLwiy9+QtspmSgM7jtZJMthXg@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 02/10] mm: thp: add support for BPF based THP
 order selection
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6B57FA0017
X-Stat-Signature: 5mjpfchwjecnjsyxoxtpbbsm9te3wfkc
X-Rspam-User: 
X-HE-Tag: 1757665763-772664
X-HE-Meta: U2FsdGVkX1/Gn93t25rhNEzWfZG51/pH/dYSNwLcA4x/9HJS2oZ+mU+2LFVsmxORhuv40QYzQE7lFXs6Pa0RRTnQJvb2plW0i+uIAnx622g6DcHYTVMDM1A2KqShkdK9od6NhTMzud6bKfzTfft4gWFYSUhAoF1L2jIxYYfZl3E5LugmvzlCX19fOQGU4tUBbPjv+jWl0Z6Plst1yVkwEimvzd3NCGyaHnD5+3KU3rT0fUIrqbllgKGI18FO9O8VQFb9TDrAju1Zp1kFi0bV8M03YEGEvl5d1vur+WrTngFvHuJFbCaNNpPtmB4LPknAFGZTnjy1M0zD+4SHUccnHvzzCjgHpIlvK7cECmkrVYMvxkV6J/6i7Qt3L43ER4Y+VozNojt1iFWurcRE3UdcjD0cAtWdKUTCpPjOwvgDQ2KKhGAYgInSR7E+7Y/Lgjt3zZjpqQpEaTmWW9Z5KERbFDuL3AR53iX85N4qfWGVrAFArhMvI5X5UaC+55pcCUmQdtGko9TnOBIxlpKREjCUaHeQRTyQa/z7zO3+00qByzIMUMNj38CiGN3HYBq6/xbrod2sBU3KhmdHibqYJFq7W82lgxqhs0jHs6xTmb9XPLV/LAEJHyiq8LGkWb2WG0DM13AUcKzHQeUMaKzcf6AzbQhXA3G6AXqoXibPjfBJHSCcw9RPCDkZ4bqCDu90PoEQWX3pBH/+LOi6M5z4QPur5IaKmiGJpmXHNBeJYoZvfTIXm/lMAdzT3yjFqiCKdyXwCtQjPmhkvkMhQP8e6bQp+gms/5sb4cuJVZBHgbgTl4lm7c7xDcIp4JVnekL3XOchFxwfHwmCcOUMXoyxw0twBD5VzF6fhktEitgcFJwQvDfGnZDuY0Dl503pPYdbLZEfIFXvqEgUeZD7W5LrD2BOFDYcrbGYs5RPBS+p6Yvsbp8v4bf+lzEBgl5OmkwEJ022B34rU0DcgHJqnltJqSJ
 q+11h0+1
 i8Yx9piRTy1iiBhXFxfZxOZciVE2azqFSAfqqKEGHqP7auRfgCSvsw1ZoFr+EuOrn+JeXdY5ZFaIcvRBh4plBh4amxtwnTHrICO+RbgOlneX5K9Z7WOIJPSKrGXxXTIu2Rak/2qaedMrbkSj57Q8CcLOe6d/gCWNIdS3Hr1iSb+iVpus8OLOBxfIDcaZyboZDMqHzciw1j8Q4psLOsexzlRgyH2B3EZoS0jMwjnH2myaUsJZSPLatOPMxWjuf9JkWsOxZJIcK7gwnFtBA18ZV3lpg7wA8tXw3cn0Z0AW5ysQS4RZYaZBfUhhUdOgprfWvKWd6OnxQHeaWNyKN6C5HbGFD33XsInYm0fQY9OXglMW4DpKX8XNNvdzQFr4lwQGCf6t0GDlUTAiqWPAo2+o7dwa+ofFaOx0I/u1kS1bPzq7QqJGQiuzwspAit4uZzB3GGzeugYBpqak/4Wo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 10:34=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Sep 10, 2025 at 10:44:39AM +0800, Yafang Shao wrote:
> > This patch introduces a new BPF struct_ops called bpf_thp_ops for dynam=
ic
> > THP tuning. It includes a hook bpf_hook_thp_get_order(), allowing BPF
> > programs to influence THP order selection based on factors such as:
> > - Workload identity
> >   For example, workloads running in specific containers or cgroups.
> > - Allocation context
> >   Whether the allocation occurs during a page fault, khugepaged, swap o=
r
> >   other paths.
> > - VMA's memory advice settings
> >   MADV_HUGEPAGE or MADV_NOHUGEPAGE
> > - Memory pressure
> >   PSI system data or associated cgroup PSI metrics
> >
> > The kernel API of this new BPF hook is as follows,
> >
> > /**
> >  * @thp_order_fn_t: Get the suggested THP orders from a BPF program for=
 allocation
> >  * @vma: vm_area_struct associated with the THP allocation
> >  * @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HUGEPAGE =
is set
> >  *            BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or BPF_THP=
_VM_NONE if
> >  *            neither is set.
> >  * @tva_type: TVA type for current @vma
> >  * @orders: Bitmask of requested THP orders for this allocation
> >  *          - PMD-mapped allocation if PMD_ORDER is set
> >  *          - mTHP allocation otherwise
> >  *
> >  * Return: The suggested THP order from the BPF program for allocation.=
 It will
> >  *         not exceed the highest requested order in @orders. Return -1=
 to
> >  *         indicate that the original requested @orders should remain u=
nchanged.
> >  */
> > typedef int thp_order_fn_t(struct vm_area_struct *vma,
> >                          enum bpf_thp_vma_type vma_type,
> >                          enum tva_type tva_type,
> >                          unsigned long orders);
> >
> > Only a single BPF program can be attached at any given time, though it =
can
> > be dynamically updated to adjust the policy. The implementation support=
s
> > anonymous THP, shmem THP, and mTHP, with future extensions planned for
> > file-backed THP.
> >
> > This functionality is only active when system-wide THP is configured to
> > madvise or always mode. It remains disabled in never mode. Additionally=
,
> > if THP is explicitly disabled for a specific task via prctl(), this BPF
> > functionality will also be unavailable for that task.
> >
> > This feature requires CONFIG_BPF_GET_THP_ORDER (marked EXPERIMENTAL) to=
 be
> > enabled. Note that this capability is currently unstable and may underg=
o
> > significant changes=E2=80=94including potential removal=E2=80=94in futu=
re kernel versions.
>
> Thanks for highlighting.
>
> >
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  MAINTAINERS             |   1 +
> >  include/linux/huge_mm.h |  26 ++++-
> >  mm/Kconfig              |  12 ++
> >  mm/Makefile             |   1 +
> >  mm/huge_memory_bpf.c    | 243 ++++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 280 insertions(+), 3 deletions(-)
> >  create mode 100644 mm/huge_memory_bpf.c
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 8fef05bc2224..d055a3c95300 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16252,6 +16252,7 @@ F:    include/linux/huge_mm.h
> >  F:   include/linux/khugepaged.h
> >  F:   include/trace/events/huge_memory.h
> >  F:   mm/huge_memory.c
> > +F:   mm/huge_memory_bpf.c
>
> THanks!
>
> >  F:   mm/khugepaged.c
> >  F:   mm/mm_slot.h
> >  F:   tools/testing/selftests/mm/khugepaged.c
> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > index 23f124493c47..f72a5fd04e4f 100644
> > --- a/include/linux/huge_mm.h
> > +++ b/include/linux/huge_mm.h
> > @@ -56,6 +56,7 @@ enum transparent_hugepage_flag {
> >       TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
> >       TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG,
> >       TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG,
> > +     TRANSPARENT_HUGEPAGE_BPF_ATTACHED,      /* BPF prog is attached *=
/
> >  };
> >
> >  struct kobject;
> > @@ -270,6 +271,19 @@ unsigned long __thp_vma_allowable_orders(struct vm=
_area_struct *vma,
> >                                        enum tva_type type,
> >                                        unsigned long orders);
> >
> > +#ifdef CONFIG_BPF_GET_THP_ORDER
> > +unsigned long
> > +bpf_hook_thp_get_orders(struct vm_area_struct *vma, vm_flags_t vma_fla=
gs,
> > +                     enum tva_type type, unsigned long orders);
>
> Thanks for renaming!
>
> > +#else
> > +static inline unsigned long
> > +bpf_hook_thp_get_orders(struct vm_area_struct *vma, vm_flags_t vma_fla=
gs,
> > +                     enum tva_type tva_flags, unsigned long orders)
> > +{
> > +     return orders;
> > +}
> > +#endif
> > +
> >  /**
> >   * thp_vma_allowable_orders - determine hugepage orders that are allow=
ed for vma
> >   * @vma:  the vm area to check
> > @@ -291,6 +305,12 @@ unsigned long thp_vma_allowable_orders(struct vm_a=
rea_struct *vma,
> >                                      enum tva_type type,
> >                                      unsigned long orders)
> >  {
> > +     unsigned long bpf_orders;
> > +
> > +     bpf_orders =3D bpf_hook_thp_get_orders(vma, vm_flags, type, order=
s);
> > +     if (!bpf_orders)
> > +             return 0;
>
> I think it'd be easier to just do:
>
>         /* The BPF-specified order overrides which order is selected. */
>         orders &=3D bpf_hook_thp_get_orders(vma, vm_flags, type, orders);
>         if (!orders)
>                 return 0;

good suggestion!

>
> > +
> >       /*
> >        * Optimization to check if required orders are enabled early. On=
ly
> >        * forced collapse ignores sysfs configs.
> > @@ -304,12 +324,12 @@ unsigned long thp_vma_allowable_orders(struct vm_=
area_struct *vma,
> >                   ((vm_flags & VM_HUGEPAGE) && hugepage_global_enabled(=
)))
> >                       mask |=3D READ_ONCE(huge_anon_orders_inherit);
> >
> > -             orders &=3D mask;
> > -             if (!orders)
> > +             bpf_orders &=3D mask;
> > +             if (!bpf_orders)
> >                       return 0
>
> With my suggeted change this would remain the same.
>
> >       }
> >
> > -     return __thp_vma_allowable_orders(vma, vm_flags, type, orders);
> > +     return __thp_vma_allowable_orders(vma, vm_flags, type, bpf_orders=
);
>
> With my suggeted change this would remain the same.
>
> >  }
> >
> >  struct thpsize {
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index d1ed839ca710..4d89d2158f10 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -896,6 +896,18 @@ config NO_PAGE_MAPCOUNT
> >
> >         EXPERIMENTAL because the impact of some changes is still unclea=
r.
> >
> > +config BPF_GET_THP_ORDER
>
> Yeah, I think we maybe need to sledgehammer this as already Lance was con=
fused
> as to the permenancy of this, and I feel that users might be too, even wi=
th the
> '(EXPERIMENTAL)' bit.
>
> So maybe
>
> config BPF_GET_THP_ORDER_EXPERIMENTAL
>
> Just to hammer it home?

ack

>
> > +     bool "BPF-based THP order selection (EXPERIMENTAL)"
> > +     depends on TRANSPARENT_HUGEPAGE && BPF_SYSCALL
> > +
> > +     help
> > +       Enable dynamic THP order selection using BPF programs. This
> > +       experimental feature allows custom BPF logic to determine optim=
al
> > +       transparent hugepage allocation sizes at runtime.
> > +
> > +       WARNING: This feature is unstable and may change in future kern=
el
> > +       versions.
> > +
> >  endif # TRANSPARENT_HUGEPAGE
> >
> >  # simple helper to make the code a bit easier to read
> > diff --git a/mm/Makefile b/mm/Makefile
> > index 21abb3353550..f180332f2ad0 100644
> > --- a/mm/Makefile
> > +++ b/mm/Makefile
> > @@ -99,6 +99,7 @@ obj-$(CONFIG_MIGRATION) +=3D migrate.o
> >  obj-$(CONFIG_NUMA) +=3D memory-tiers.o
> >  obj-$(CONFIG_DEVICE_MIGRATION) +=3D migrate_device.o
> >  obj-$(CONFIG_TRANSPARENT_HUGEPAGE) +=3D huge_memory.o khugepaged.o
> > +obj-$(CONFIG_BPF_GET_THP_ORDER) +=3D huge_memory_bpf.o
> >  obj-$(CONFIG_PAGE_COUNTER) +=3D page_counter.o
> >  obj-$(CONFIG_MEMCG_V1) +=3D memcontrol-v1.o
> >  obj-$(CONFIG_MEMCG) +=3D memcontrol.o vmpressure.o
> > diff --git a/mm/huge_memory_bpf.c b/mm/huge_memory_bpf.c
> > new file mode 100644
> > index 000000000000..525ee22ab598
> > --- /dev/null
> > +++ b/mm/huge_memory_bpf.c
> > @@ -0,0 +1,243 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * BPF-based THP policy management
> > + *
> > + * Author: Yafang Shao <laoar.shao@gmail.com>
> > + */
> > +
> > +#include <linux/bpf.h>
> > +#include <linux/btf.h>
> > +#include <linux/huge_mm.h>
> > +#include <linux/khugepaged.h>
> > +
> > +enum bpf_thp_vma_type {
> > +     BPF_THP_VM_NONE =3D 0,
> > +     BPF_THP_VM_HUGEPAGE,    /* VM_HUGEPAGE */
> > +     BPF_THP_VM_NOHUGEPAGE,  /* VM_NOHUGEPAGE */
> > +};
>
> I'm really not so sure how useful this is - can't a user just ascertain t=
his
> from the VMA flags themselves?

I assume you are referring to checking flags from vma->vm_flags.
There is an exception where we cannot use vma->vm_flags: in
hugepage_madvise(), which calls khugepaged_enter_vma(vma, *vm_flags).

At this point, the VM_HUGEPAGE flag has not been set in vma->vm_flags
yet. Therefore, we must pass the separate *vm_flags variable.
Perhaps we can simplify the logic with the following change?

diff --git a/mm/madvise.c b/mm/madvise.c
index 35ed4ab0d7c5..5755de80a4d7 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1425,6 +1425,8 @@ static int madvise_vma_behavior(struct
madvise_behavior *madv_behavior)
        VM_WARN_ON_ONCE(madv_behavior->lock_mode !=3D MADVISE_MMAP_WRITE_LO=
CK);

        error =3D madvise_update_vma(new_flags, madv_behavior);
+       if (new_flags & VM_HUGEPAGE)
+               khugepaged_enter_vma(vma);
 out:
        /*
         * madvise() returns EAGAIN if kernel resources, such as

>
> Let's keep the interface as minimal as possible.
>
> > +
> > +/**
> > + * @thp_order_fn_t: Get the suggested THP orders from a BPF program fo=
r allocation
>
> orders -> order?

ack

>
> > + * @vma: vm_area_struct associated with the THP allocation
> > + * @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HUGEPAGE=
 is set
> > + *            BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or BPF_TH=
P_VM_NONE if
> > + *            neither is set.
>
> Obv as above let's drop this probably :)
>
> > + * @tva_type: TVA type for current @vma
> > + * @orders: Bitmask of requested THP orders for this allocation
>
> Shouldn't requested =3D available?

ack

>
> > + *          - PMD-mapped allocation if PMD_ORDER is set
> > + *          - mTHP allocation otherwise
>
> Not sure these 2 points are super useful.

will remove it.

>
> > + *
> > + * Return: The suggested THP order from the BPF program for allocation=
. It will
> > + *         not exceed the highest requested order in @orders. Return -=
1 to
> > + *         indicate that the original requested @orders should remain =
unchanged.
> > + */
> > +typedef int thp_order_fn_t(struct vm_area_struct *vma,
> > +                        enum bpf_thp_vma_type vma_type,
> > +                        enum tva_type tva_type,
> > +                        unsigned long orders);
> > +
> > +struct bpf_thp_ops {
> > +     thp_order_fn_t __rcu *thp_get_order;
> > +};
> > +
> > +static struct bpf_thp_ops bpf_thp;
> > +static DEFINE_SPINLOCK(thp_ops_lock);
> > +
> > +/*
> > + * Returns the original @orders if no BPF program is attached or if th=
e
> > + * suggested order is invalid.
> > + */
> > +unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
> > +                                   vm_flags_t vma_flags,
> > +                                   enum tva_type tva_type,
> > +                                   unsigned long orders)
> > +{
> > +     thp_order_fn_t *bpf_hook_thp_get_order;
> > +     unsigned long thp_orders =3D orders;
> > +     enum bpf_thp_vma_type vma_type;
> > +     int thp_order;
> > +
> > +     /* No BPF program is attached */
> > +     if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
> > +                   &transparent_hugepage_flags))
> > +             return orders;
> > +
> > +     if (vma_flags & VM_HUGEPAGE)
> > +             vma_type =3D BPF_THP_VM_HUGEPAGE;
> > +     else if (vma_flags & VM_NOHUGEPAGE)
> > +             vma_type =3D BPF_THP_VM_NOHUGEPAGE;
> > +     else
> > +             vma_type =3D BPF_THP_VM_NONE;
>
> As per above, not sure this is all that useful.
>
> > +
> > +     rcu_read_lock();
> > +     bpf_hook_thp_get_order =3D rcu_dereference(bpf_thp.thp_get_order)=
;
> > +     if (!bpf_hook_thp_get_order)
> > +             goto out;
> > +
> > +     thp_order =3D bpf_hook_thp_get_order(vma, vma_type, tva_type, ord=
ers);
> > +     if (thp_order < 0)
> > +             goto out;
> > +     /*
> > +      * The maximum requested order is determined by the callsite. E.g=
.:
> > +      * - PMD-mapped THP uses PMD_ORDER
> > +      * - mTHP uses (PMD_ORDER - 1)
>
> I don't think this is quite right, highest_order() figures out the highes=
t set
> bit, so mTHP can be PMD_ORDER - 1 or less (in theory ofc).
>
> I think we can just replace this with something simpler like - 'depending=
 on
> where the BPF hook is invoked, we check for either PMD order or mTHP orde=
rs
> (less than PMD order)' or something.

ack

>
> > +      *
> > +      * We must respect this upper bound to avoid undefined behavior. =
So the
> > +      * highest suggested order can't exceed the highest requested ord=
er.
> > +      */
>
> I think this sentence is also unnecessary.

will remove it.

--=20
Regards
Yafang

