Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38289CCD183
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 13:12:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 771A58E0027; Wed,  8 Oct 2025 09:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7491E8E0002; Wed,  8 Oct 2025 09:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65EB68E0027; Wed,  8 Oct 2025 09:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 552C88E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:12:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5CF416056E
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 13:12:19 +0000 (UTC)
X-FDA: 83974985598.22.7AEBBCF
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id D379F40005
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 13:12:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d8JXcXpm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759929137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fBKwa75rcl5jnXtV/oS/WIGH19YZKQyj0WoGa9cCm+I=;
	b=TGRVuIyFOAHcOXwJoRkskf7C/AEZGAg8GziFGgcN6RMcqFrarddC9SkPKTYFyIZuMUyaKe
	K8oDM9tX+gmqfDYrRR2s4K9MR1wDjsw2z8FPFMhymk+TErUIR2uRp8hWHPU5iTmANX2D5a
	NjrjI7rM33e1nsUbGa4W0j6EeiCR0Xc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759929137; a=rsa-sha256;
	cv=none;
	b=xk4f1ViBujH+EtPO8AaY7l1LaLwV3TrHMpgnGlrjcs6/CvilGlSTtzDNPi5vvWes5uf0Be
	Y71F3i5c5k8okW4q3I4A1W/VJi1xf0x3l3TDmC18XWL7ir/j70t1AMWME+vRT4ccgdvJVC
	j/bs0JuGWs/iPDWhDkofMjSm8v6gsvs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d8JXcXpm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-7900f7f4ba9so71750496d6.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 06:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759929137; x=1760533937; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fBKwa75rcl5jnXtV/oS/WIGH19YZKQyj0WoGa9cCm+I=;
        b=d8JXcXpmuLc0b5ArpdcxaSH5vF9txVCgHu3CuEDw/pBUC7ENle3euMR9dCLYeInfpU
         DenRWt3wSGiXKZu1St9nFLbQExd38y/eGH5SJ638oIOXbusfuk/so/Rz0W9amn6xl0ur
         yBAVpDqmOPFzzobIu0CpIJBuFHo/d+pKG3kjb53Oo4WwXLYR5+Iykf224vTU5x2EomrG
         iMN8bJHUpughhKzCJdDz9FLcuvp8VxcFvsnqx3sr6BVfhH4SNkbRSOA906/qQz/pOY6Y
         t/IGjBN7rEtJnMDPkMhqtUtsFxDZEh/JVC4OKNbHrh3JHCjkDkoI0D/NbueWm9evSx6i
         MXeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759929137; x=1760533937;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fBKwa75rcl5jnXtV/oS/WIGH19YZKQyj0WoGa9cCm+I=;
        b=cgQaoJ9k1V6jK3fqTywVc89M8dWqOEK6vedWIuBDZYVjpGzk44LYTtbHV/4IEU3U1y
         cmoqcLNVGLC62goTrDM3RHWq/Vz+wH128AEVq2v7w0uLStTVjhHzyyLuaJ1KayVITlx5
         +xX47bGX6sjO0TTWm3ClcgepWZoqpQGJuDXSCUHIS+cNSfj96QlR1hcMkCgMzcidaks3
         cMGoeqTlAwmH1GqVGjtk5MgreGNJWEsJrGa9fRMzRhXfRpgV4kqdJqEbKVrOy/7SKIO7
         joZ7QVW7W82HvjndzBsLU7zkC4jtYSKDlXU83/uvujh+V0oUd84TiuC5GkqNVXZeiaWz
         /ZPg==
X-Forwarded-Encrypted: i=1; AJvYcCVFwstbr+LtK53s2AMZIbXAQbYKr4siJrPvqWlGm067eJvIUeIvqrlVOQ5VRQRZHhbb+ds48NZA6A==@kvack.org
X-Gm-Message-State: AOJu0Yz65wr9sTZ6S2vdL4+je7W2uw+CAmBPqlGUXe+W+j41r6N9XWaP
	TGzCJOVGpmwgzotV4cwOx7+vOMgEgNrWJvEvKrcGUq3MNNPLhBpzM2YKZ85XafNf2IKRbkUzsAI
	uDhu4pGtM9kFCS9mpiBvhsb8FmNHhE8E=
X-Gm-Gg: ASbGncvmRFBzKyaZuYYtBeAMvBhcvLnmJmXENaStj5N58MTayew65wb2CVH9gOmJki3
	SWClGklXP5ostqal3Ar2QYEYK8v+KrCINBxtEfSN7ivztj00HzzDAMEEc1vs7PKE1dIbqCY/pB3
	OLa0tWCSTxKf5lOSkZ+gpB92bZzLyoL3AVvGK2vFhP/F7wSDFmKsfi7+XTiHfMi8GzfuOXVSC0h
	kW+KVZzRH1PeMPpRX5YOKkNQJv+UzGqixBU6jlgoH60XYVNvEemuRgjhfUa0cOkJA8QxmoTnGM=
X-Google-Smtp-Source: AGHT+IFzUXffB1zB7vnWpuKrlcQPdtVGJfSjZp7EPf6PBL/bCYvn3+y9LWXlhXOmcWWw4fXUcxkyECmMdiurn0kjvhs=
X-Received: by 2002:a05:6214:268b:b0:796:6034:c0fb with SMTP id
 6a1803df08f44-87b20ff9e9fmr42443166d6.13.1759929136653; Wed, 08 Oct 2025
 06:12:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250930055826.9810-1-laoar.shao@gmail.com> <20250930055826.9810-4-laoar.shao@gmail.com>
 <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
 <27e002e3-b39f-40f9-b095-52da0fbd0fc7@redhat.com> <CALOAHbBFNNXHdzp1zNuD530r9ZjpQF__wGWyAdR7oDLvemYSMw@mail.gmail.com>
 <7723a2c7-3750-44f7-9eb5-4ef64b64fbb8@redhat.com> <CALOAHbD_tRSyx1LXKfFrUriH6BcRS6Hw9N1=KddCJpgXH8vZug@mail.gmail.com>
 <96AE1C18-3833-4EB8-9145-202517331DF5@nvidia.com> <f743cfcd-2467-42c5-9a3c-3dceb6ff7aa8@redhat.com>
In-Reply-To: <f743cfcd-2467-42c5-9a3c-3dceb6ff7aa8@redhat.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 8 Oct 2025 21:11:39 +0800
X-Gm-Features: AS18NWAfLSZj5vVPHQEFQdqoJ0RU1U5dgEf--oeMfkY_sJP1b_wNMDZYIuMpIdc
Message-ID: <CALOAHbAY9sjG-M=nwWRdbp3_m2cx_YJCb7DToaXn-kHNV+A5Zg@mail.gmail.com>
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	baolin.wang@linux.alibaba.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	Matthew Wilcox <willy@infradead.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Amery Hung <ameryhung@gmail.com>, David Rientjes <rientjes@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, 21cnbao@gmail.com, Shakeel Butt <shakeel.butt@linux.dev>, 
	Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, Randy Dunlap <rdunlap@infradead.org>, 
	bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: ojtig77p7u85tcsujuwrc39o4expgf79
X-Rspam-User: 
X-Rspamd-Queue-Id: D379F40005
X-HE-Tag: 1759929137-896541
X-HE-Meta: U2FsdGVkX1+HMrp/uoIcE2xFBp8nY2g1DIdodnyy3e9wfDBirTKfthzGh6h8LACcNV6EiQVLXlpFNfdwtRcDpYHQyLEP+ZIcMJQ8a1Xlkp8hfjPXvVvhLant88tmRFKB3u+NUX471ZAu2Cy4Xqe59QAerj613Ksn0e5TwNpJ4h9twS06T5ig+HxQGA/6fzAat28dhy5hl4b7AE78X0PsluoyU7orYwAcgnLsatw66s70ox5/vaLzh2phYuqiPfqFCTEe04ilJjANZ4hJ689YB1kH6IUXB5U7U21zcVGba9asP5wvaCsrDNmsNA4wH2uxkbp/HwsfkSz22l5Q69yd1QS3S2p+btn7vY1URznnggpdU3EhKOkCElQ1LxkAvSsTzK4/NFBCXsPDD4cKM0QLpb7BZOeLqhAOJh6jPDr2+SkWs1ZMpV80fOXAGC3XbCOntGk1x08Q+Id/jpQaPj5ndhG8bGVECHP9+kyW9pVCq7pp3clX4nRQUp7DjWREKHVlwKAxGtbHNdu00qt/e/qX76Zs52ubf327ZgWQCuhiRJFGCrDucETc9ZQ8cCOM+zrjxLf04djRoLAW5ByNjJ3BNG7Ai0YFAcKjK4nLcp9MpexJ6iN9NItFgv60/Uf++ckz/VQT31e3qeqKmxWmPogwmnn5Ft0J4qRmdBVTsRMTLUZYFnz6Z1wPTWumV1iFuh2m2dBP1lRruJwRJRgziDmjf8wYm5A0tlJ6nok5vl3eztt1EFXA0MFhBAtZ10hxdhqCCnK4oZXj1UuMyte0Sr0yp7JMw8F/KB+1WdXsaEnqmGisqWEyLkWGqyUmEfv9Mosc+wAjCSKaTH79FyAOlHP6hNJoLpKdDpR78zdqoSUrXWmTzTzE0Wfn8PgpRzwbYtNlIYVO4til8wpHqF5dFe/Cgt42nQ6J2QNf1gtNI/UqeKP2bmw38jLJajjkufKo5miyYJIAGxHdRP+ZLzNndiC
 Z0NjoQZl
 SMjLkW4YwMSbHB9+Y0JuvzdxnrM6PzGznVa9pCkSAk8okcu2hRQMcCfkbbUoLFSGiVaCjmqxGt3HKT27XmShNv7jFVNxQ1GxX+Zz5uekvcYmRUqzMrd2No6aMV6RW8ju8IK1NGM3eOmGAdcArmr8xjtClAveyw8IjlAHm50O11a3tZNW+hwjzmcUtCQc4Uvo5wYpWpdPN+4oG1e93DMLualWlfel0hAOOSkgLErdNUSUTPUS4zp1cYxeztmt9no9jGfJRwZSubOB2rmkjhqTZBzm827e39OM7f/9qGAc+oJyc3HqdyJqxB0hBlYH0pCrMTgXJWuATHhWpVNhkC2WWlloPlXLfnY8hyR14LO9Fm3/RsqqEahfMiqkZ4Ux3dvVxHVwdjOTOjQkqlLNknP1Ui/3k3Qyl4Q17iO5BhKMwuv2CFWI6QcdYGicTwBkIYcgR2qZIVe+XEPKrAwpTjd5KU3+KvIAH7C8iKHUKwwR5+Z5ULWnYfcrJ+3XupxWBqBXXKWZ5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 8, 2025 at 8:07=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 08.10.25 13:27, Zi Yan wrote:
> > On 8 Oct 2025, at 5:04, Yafang Shao wrote:
> >
> >> On Wed, Oct 8, 2025 at 4:28=E2=80=AFPM David Hildenbrand <david@redhat=
.com> wrote:
> >>>
> >>> On 08.10.25 10:18, Yafang Shao wrote:
> >>>> On Wed, Oct 8, 2025 at 4:08=E2=80=AFPM David Hildenbrand <david@redh=
at.com> wrote:
> >>>>>
> >>>>> On 03.10.25 04:18, Alexei Starovoitov wrote:
> >>>>>> On Mon, Sep 29, 2025 at 10:59=E2=80=AFPM Yafang Shao <laoar.shao@g=
mail.com> wrote:
> >>>>>>>
> >>>>>>> +unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma=
,
> >>>>>>> +                                     enum tva_type type,
> >>>>>>> +                                     unsigned long orders)
> >>>>>>> +{
> >>>>>>> +       thp_order_fn_t *bpf_hook_thp_get_order;
> >>>>>>> +       int bpf_order;
> >>>>>>> +
> >>>>>>> +       /* No BPF program is attached */
> >>>>>>> +       if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
> >>>>>>> +                     &transparent_hugepage_flags))
> >>>>>>> +               return orders;
> >>>>>>> +
> >>>>>>> +       rcu_read_lock();
> >>>>>>> +       bpf_hook_thp_get_order =3D rcu_dereference(bpf_thp.thp_ge=
t_order);
> >>>>>>> +       if (WARN_ON_ONCE(!bpf_hook_thp_get_order))
> >>>>>>> +               goto out;
> >>>>>>> +
> >>>>>>> +       bpf_order =3D bpf_hook_thp_get_order(vma, type, orders);
> >>>>>>> +       orders &=3D BIT(bpf_order);
> >>>>>>> +
> >>>>>>> +out:
> >>>>>>> +       rcu_read_unlock();
> >>>>>>> +       return orders;
> >>>>>>> +}
> >>>>>>
> >>>>>> I thought I explained it earlier.
> >>>>>> Nack to a single global prog approach.
> >>>>>
> >>>>> I agree. We should have the option to either specify a policy globa=
lly,
> >>>>> or more refined for cgroups/processes.
> >>>>>
> >>>>> It's an interesting question if a program would ever want to ship i=
ts
> >>>>> own policy: I can see use cases for that.
> >>>>>
> >>>>> So I agree that we should make it more flexible right from the star=
t.
> >>>>
> >>>> To achieve per-process granularity, the struct-ops must be embedded
> >>>> within the mm_struct as follows:
> >>>>
> >>>> +#ifdef CONFIG_BPF_MM
> >>>> +struct bpf_mm_ops {
> >>>> +#ifdef CONFIG_BPF_THP
> >>>> +       struct bpf_thp_ops bpf_thp;
> >>>> +#endif
> >>>> +};
> >>>> +#endif
> >>>> +
> >>>>    /*
> >>>>     * Opaque type representing current mm_struct flag state. Must be=
 accessed via
> >>>>     * mm_flags_xxx() helper functions.
> >>>> @@ -1268,6 +1281,10 @@ struct mm_struct {
> >>>>    #ifdef CONFIG_MM_ID
> >>>>                   mm_id_t mm_id;
> >>>>    #endif /* CONFIG_MM_ID */
> >>>> +
> >>>> +#ifdef CONFIG_BPF_MM
> >>>> +               struct bpf_mm_ops bpf_mm;
> >>>> +#endif
> >>>>           } __randomize_layout;
> >>>>
> >>>> We should be aware that this will involve extensive changes in mm/.
> >>>
> >>> That's what we do on linux-mm :)
> >>>
> >>> It would be great to use Alexei's feedback/experience to come up with
> >>> something that is flexible for various use cases.
> >>
> >> I'm still not entirely convinced that allowing individual processes or
> >> cgroups to run independent progs is a valid use case. However, since
> >> we have a consensus that this is the right direction, I will proceed
> >> with this approach.
> >>
> >>>
> >>> So I think this is likely the right direction.
> >>>
> >>> It would be great to evaluate which scenarios we could unlock with th=
is
> >>> (global vs. per-process vs. per-cgroup) approach, and how
> >>> extensive/involved the changes will be.
> >>
> >> 1. Global Approach
> >>     - Pros:
> >>       Simple;
> >>       Can manage different THP policies for different cgroups or proce=
sses.
> >>    - Cons:
> >>       Does not allow individual processes to run their own BPF program=
s.
> >>
> >> 2. Per-Process Approach
> >>      - Pros:
> >>        Enables each process to run its own BPF program.
> >>      - Cons:
> >>        Introduces significant complexity, as it requires handling the
> >> BPF program's lifecycle (creation, destruction, inheritance) within
> >> every mm_struct.
> >>
> >> 3. Per-Cgroup Approach
> >>      - Pros:
> >>         Allows individual cgroups to run their own BPF programs.
> >>         Less complex than the per-process model, as it can leverage th=
e
> >> existing cgroup operations structure.
> >>      - Cons:
> >>         Creates a dependency on the cgroup subsystem.
> >>         might not be easy to control at the per-process level.
> >
> > Another issue is that how and who to deal with hierarchical cgroup, whe=
re one
> > cgroup is a parent of another. Should bpf program to do that or mm code
> > to do that? I remember hierarchical cgroup is the main reason THP contr=
ol
> > at cgroup level is rejected. If we do per-cgroup bpf control, wouldn't =
we
> > get the same rejection from cgroup folks?
>
> Valid point.
>
> I do wonder if that problem was already encountered elsewhere with bpf
> and if there is already a solution.

Our standard is to run only one instance of a BPF program type
system-wide to avoid conflicts. For example, we can't have both
systemd and a container runtime running bpf-thp simultaneously.

Perhaps Alexei can enlighten us, though we'd need to read between his
characteristically brief lines. ;-)

>
> Focusing on processes instead of cgroups might be easier initially.


--=20
Regards
Yafang

