Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D018CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 13:19:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9687E6B0005; Thu,  7 May 2026 09:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 919AB6B008A; Thu,  7 May 2026 09:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 808E36B008C; Thu,  7 May 2026 09:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C99B6B0005
	for <linux-mm@kvack.org>; Thu,  7 May 2026 09:19:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 184D41C1126
	for <linux-mm@kvack.org>; Thu,  7 May 2026 13:19:30 +0000 (UTC)
X-FDA: 84740680500.03.E823F1C
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2722D180010
	for <linux-mm@kvack.org>; Thu,  7 May 2026 13:19:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o4uZEC8s;
	spf=pass (imf24.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778159968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uJsNWGNnboxuwp5GaleyBNu7wVTMMyud/VuzWCCNevo=;
	b=jhAF32LRmGRrHCbCFmw1hKNn3hGpkdLOLFTzHVwimGIk2oMWWof+k/6biETVjyD5RWe4EY
	PH6wxhV9+9G7MQDG1FG/TbgScqMxXargknNUKkj/VJUfkZtDE29fQ/r6wOJUZI+/sS7Bu5
	n563OR2GVUv5mTAJH5tC4b06s7oDCok=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o4uZEC8s;
	spf=pass (imf24.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778159968; a=rsa-sha256;
	cv=pass;
	b=PQn5buKEW9TdDd4/gSq7n7GXgO26xoXRC3eYhlD/Ozf5382TZ2YGcJuCS7KoD2AO/U7AIl
	prONoVIKFHVG5goGqtggYXpDRVf2rfD7BhVK3GnGDHrvTggn1FTHU519MjxhRKmTgJP5hB
	ZnSLxkx6WnCSAQTxgnf5gR0cNviAO9M=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-7bd65714dcaso7946997b3.3
        for <linux-mm@kvack.org>; Thu, 07 May 2026 06:19:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778159967; cv=none;
        d=google.com; s=arc-20240605;
        b=TPJkFUz8r2/Mt4g2tm6ZXR53yKZXuirMnyJJYx7TcxshcxadY4C3UfS/8VCerAf490
         1wi7KfKF/WZ0rRB9eGomJ+tUvFJgcHLMsYkWP3LpYzYd09sTohewUl2jmN4x+z6EOY7W
         IrEJlB7cmflkLsCilSkccFUCXQl2PvBr36TI4l4iRMyND0RYidgRi47WfN5A9gCDXh/U
         te7mLxNlPzLXYugaDHUS7v56+UW/fMcwBFLYDsKd51ims++YgEeVeHoqBHkvA//BPxXE
         56l5DpG7XkntDY6slQcGoy5O2Lh5iuFGwbiSPf0M77gflX2Gkd7/VSeRmJMxJ3w59i7L
         fsEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uJsNWGNnboxuwp5GaleyBNu7wVTMMyud/VuzWCCNevo=;
        fh=v/he/r4W8MGBITiyUh3cmMNzQ13GDHqwuoNc0LGwusE=;
        b=fZGoA3Jo37n6THVYbKPgugb9TqY0AP3yvXsFUymO7daASioXhzj2TDqS5HudeZBrP3
         OvHp6yAlEbgVDYUSQ9XWKqKQKmXEXcCgyL56C6jBnCNGTHc+5UX+oP+mEQiZ3K+rqMc8
         l4iUcM6W4GEjk6aaCZUbgqoN9O+edqpcvEm9GKPLRmSHeyeDBWVa1AWF5QxS50mltol4
         nN5zzWRl1p9WHQ8dqWjmPbwzZrDE5GC3oHNI0MCYE/otRFCvkLDnOrEOTVEy4iYTGVfR
         0u1REh0t62/XNVIoGAGE2d60k8wdOvteKQoYLM4ciNfRx6/3z2eqfucg1GBTtSjvTgQn
         sg2Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778159967; x=1778764767; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uJsNWGNnboxuwp5GaleyBNu7wVTMMyud/VuzWCCNevo=;
        b=o4uZEC8s2mASLgsPiNTW5IbtJtyCn6DhXZ97EUFjfgAtTebrXXJXXS4CVKEn5Qnd60
         9XqIUaVm3BV6QSFQ34V3j70xIILpRduK+aWHGCAqO4PqtiYdUiwLwUqbeMyICsfDjWxA
         K3d7ySxgAgmyC6j8uAtmxmiHz99g7Gdb5zsProMemq8L9C0E5oF8eY/w90E0ezalR1j7
         ewc50sBqgN8p/tDhRNJXD5rPQWAOGZ3JtV9sVgwc4fKOw/wukME6vr8qHPtkLboN/BJV
         45WAh5lCBYoDMOCAzAf3GHZ7oy9X47ktkPSeA0Ak4pxe1FDyNgI0NK3MCvIJT2GILV2f
         Ihlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778159967; x=1778764767;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uJsNWGNnboxuwp5GaleyBNu7wVTMMyud/VuzWCCNevo=;
        b=fMGHQMynPzPUfIcC9Q1lFvJXG1fhRKPALHEYRPpUEOcbyq9kS8mvc3k/ZteGd/iOXG
         h9pKGnppynff5J6qexmK+3W8y0ZDDe47YOf15li38zNHe+4K8UyiH6V9xUm5BY9F21e3
         M1X2kdMg/MhyOqlaRLFVmtKvPxX2g1jSIZ+6Rah9WfVzSDBiC2TXez5VRcFxKIoctmM3
         YE3a23Zez7AWtN/iSMvuJjssvWO7xqOK35Ljp8NrBtXqkVGGu5cX9+QX8W+APpCrgkuR
         CmE3NJ9mHjaWqK+pKUwrJPwclPnvVd81Ab3S9M8QEj3m/J63mM98/pSBchqUpHZM9f4L
         GHAg==
X-Forwarded-Encrypted: i=1; AFNElJ8+7HWbOVJxwIAuWjYqyE3fT6Zpoz7gzWasf5aWdHTX2LDBQHSsnwNJxAVl1Gcpj6ZnRv31jgaLIA==@kvack.org
X-Gm-Message-State: AOJu0Yxn15qL2qDq9BE1Fb1O+fxKU8d2ZrQZTWb86PgtG7MFcwdNmAxT
	20SfgxTOuOUVxB289uq2FqhbxD6+UURmSSqHCCMVeroTr6bFBNxqv2IxuOGXjxdDNeFPC+yGmnH
	jnKJ/9n0MQufUkIX+WiUBsll96D/bCdw=
X-Gm-Gg: Acq92OHEyu+cTl5a7zHKjLIiHFQeOSqRjjekSB1vU0dnVg3g7vklMcQdQ7WlMdKkusb
	kBsLkTtGLjmJfG43BTNUGVdmmpnrtDouHpPFyN6UsI6dW0Fvp0Br2HVyRBPdw1lRL6gLyexXlrC
	x3//ySGPYHRiizKF36M17BXo2f1KpoPqPY7v8YApf/2Tk+3oLec9Ruce+JMFA9/U+ez6TBib4Sw
	JVvYFQErFbkV1asEMHeuSBWEXb8g17Ye11YVPDox62Q2NCa8NKe1TpaIlXfwewfcSrdrPmjKdYt
	pBk1utHnIq9jBEWKTLuzWmKKmiVRuk8tJW2VTQV42ohHB7XgFI4=
X-Received: by 2002:a05:690c:e3e9:b0:7bd:5af9:f0a2 with SMTP id
 00721157ae682-7bdf5da8d19mr85075527b3.14.1778159966849; Thu, 07 May 2026
 06:19:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260503165024.1526680-1-vernon2gm@gmail.com> <CALOAHbBx6GuZjj9_EdrAPCsiLJekAiqOVsWQ0muNJh18Nxaqtg@mail.gmail.com>
 <CACZaFFPXo_f_2M7y4NfQ=sWddS4Kwo5guFTqZcLmm4Z8COWocQ@mail.gmail.com>
In-Reply-To: <CACZaFFPXo_f_2M7y4NfQ=sWddS4Kwo5guFTqZcLmm4Z8COWocQ@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 7 May 2026 21:18:50 +0800
X-Gm-Features: AVHnY4LaEHa2dX9PW99UK0yFlSgEhPhckpxDi__PrvtTYbMZ_56jvjXDiqmJ4Sc
Message-ID: <CALOAHbDQyUARbWudg3e94p7QyUF3Jgi3Y+NgPiSjfw=euENsjg@mail.gmail.com>
Subject: Re: [PATCH 0/4] mm: introduce mthp_ext via cgroup-bpf to make mTHP
 more transparent
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	roman.gushchin@linux.dev, inwardvessel@gmail.com, shakeel.butt@linux.dev, 
	ast@kernel.org, daniel@iogearbox.net, surenb@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	baohua@kernel.org, lance.yang@linux.dev, dev.jain@arm.com, 
	Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2722D180010
X-Stat-Signature: 3k5uwc1fbosb8wwcc5qbxquuwe9uxgkf
X-HE-Tag: 1778159967-303437
X-HE-Meta: U2FsdGVkX18MD1wS+/5ejVVmBWpkO47Nu39ORUsAYXoRmTQdqUU8xXJhl1j91tjLK6IWAkqEQvrrT6NFUqp3OvFv3jKkdke03LxOOLmfjoZutiIa+uLKQnwoOp1HXM+mfvPVBJv1fLT+4OUQqIHvCjR6zwKBQeXXgczDLClYK6QFfOVWTbQdg4bb/lyiSAvZjHP5b18IFXxOUqb6p+Di5eA7g66D3yz3FFvnTC3xsmiuSEcfhVvJkXPsmRvrv5sbuF3cU2uS0fXC+6dnf5+kg012WZIiWfqXaZj5jVb1Fpdkgsn/iRH+vQtCjgmyPDlRbB4JOBD9yDrFTbq7ky5eGlXf4P5dG5LAGLx/J19BF0sNQItHduoRBRXidVM84nevmPYwAQhExEKlbGzq8KbSPHKjSJcBOTcojo7srj1gmp51oRqkAPlYO8MPLn8Rz7SHHtB2pRL89TAbx/J9w4U+X3h0D54BxijJVBiTR+Tu9XSW+DORIsTjKKBZJaAvg8tkteydJ891Alt7n4Cns5sIy0DfSexV43igOihDnRwNHe5ztPKJJopXcRXfazaTpuNMRz6lIoMOsPG/oPOYQsvTRUoBqEx0HpoGfmBwWLfsD2u/FHXeWrCNqb2o1CqZn4Y+Z+V9GW3khDH+Kyh7mR5haRXDwe4IJKlz8mo8/PJgBrrRbzChbGJHlOTVHdu28ZiDErRGYP2fz0G0/cHKlDWjUSgmkYZWgV8cIo7Yj3v3dJUHfIAIVogPgdEw2GUNiF4F5bujGxB9n72u84eJH0qb8jeiQT1i3dXW8Vkg6cqS6UHM45uM1JOU73jzLvkMMBixUQ3HwoR3yuHZkozyhtCNR1vMhUDG+kseATeBi2hDczUuZPzbja3ip4g5RsiRc4z7+zPATyGXLnU5rO/Z9jvOeWHm0eLT2DlCZV2o8TCxmdNYWwe9TPBEj6lyGBpggFPysDNOQ6YPCI9VZ2uCGYU
 GbHibJGP
 7ohMXjWgm3na2E7QwFItRNbeuOWf5MO9A52Up64vNceyyinGt9g6NDcIp0gYZ30ZbncW0QguupUzhUrGERk85ASwZs3zIz4nPd6gkbIyEqUI34Z8d1fGtveAnWx7xa/ihFCdrhWcaVdN1//3ffKw81rfISK/5kxV8XKgWsYSSc0qwoCeGcJ28LTis4suSJMuGJKz3mO6rcz2qoTA/x1LoKxSzZidh9UlOOZg+cMSDN/veI8k6LP0V/J5RZQqCb4KSBlhMDGTodO54kO1jInczrucITm3Lin9yyWQeEo9cF1p7KjORyY/YPYSFl/4Q8ONkEis6b7F9/g1SzC2U8VtYu4ojx25PIxwC9RuATh1RtfFJb2TFKeXyCGphFVJHq3EJ5N3NsZSuO3r5ARR+Cxke/eqRUnj8NAp5KEN4VjdX+NeqH0FzMWMtG9zBUcBtChexe//4LJeHj9jEJOMSu/kXGT6cwtmiwSTjL5FwJY64+wcEDG86Z+Y9YtuYNSOB4JGm4/PaWI7AdR8fwMLFyWn1bpLozQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 7, 2026 at 8:51=E2=80=AFPM Vernon Yang <vernon2gm@gmail.com> wr=
ote:
>
> On Thu, May 7, 2026 at 11:35=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com=
> wrote:
> >
> > On Mon, May 4, 2026 at 12:52=E2=80=AFAM Vernon Yang <vernon2gm@gmail.co=
m> wrote:
> > >
> > > From: Vernon Yang <yanglincheng@kylinos.cn>
> > >
> > > Hi all,
> > >
> > > Background
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >
> > > As is well known, a system can simultaneously run multiple different
> > > scenarios. However, THP is not beneficial in every scenario =E2=80=94=
 it is only
> > > most suitable for memory-intensive applications that are not sensitiv=
e
> > > to tail latency. For example, Redis, which is sensitive to tail laten=
cy,
> > > is not suitable for THP. But in practice, due to Redis issues, the
> > > entire THP functionality is often turned off, preventing other scenar=
ios
> > > from benefiting from it.
> > >
> > > There are also some embedded scenarios (e.g. Android) that directly u=
se
> > > 2MB THP, where the granularity is too large. Therefore, we introduced
> > > mTHP in v6.8, which supports multiple-size THP. In practice, however,=
 we
> > > still globally fix a single mTHP size and are unable to automatically
> > > select different mTHP sizes based on different scenarios.
> > >
> > > After testing, it was found that
> > >
> > > - When the system has a lot of free memory, it is normal for Redis to
> > >   use mTHP. performance degradation in Redis only occurs when the sys=
tem
> > >   is under high memory pressure.
> > > - Additionally, when a large number of small-memory processes use mTH=
P,
> > >   memory waste is prone to occur, and performance degradation may als=
o
> > >   happen during fast memory allocation/release.
> > >
> > > Previously, "Cgroup-based THP control"[1] was proposed, but it had th=
e
> > > following issues.
> > >
> > > - It breaks the cgroup hierarchy property.
> > > - Add new THP knobs, making sysadmin's job more complex
> > >
> > > Previously, "mm, bpf: BPF-MM, BPF-THP"[2] was proposed, but it had th=
e
> > > following issues.
> > >
> > > - It didn't address the issue on the per-process mode.
> > > - For global mode, the prctl(PR_SET_THP_DISABLE) has already achieved
> > >   the same objective, there is no need to add two mechanisms for the
> > >   same purpose.
> > > - Attaching st_ops to mm_struct, the same issues that cgroup-bpf once
> >
> > Hello,
> >
> > The primary hurdles preventing BPF-THP from being upstreamed are:
> >
> > - Uncertainty regarding the stable API
> >
> >   It remains unclear whether the following API is sufficient for
> >   BPF-THP requirements:
>
> Thank you for pointing this out. I will add it to this issue list in
> the next version.
>
> At the same time, I also encourage everyone to actively provide
> relevant real workload scenarios. I will conduct related analyses and
> develop the mthp_ext to address them, so we can determine which ABI
> can satisfy the BPF-THP requirements.
>
> >   unsigned long
> >   bpf_hook_thp_get_orders(struct vm_area_struct *vma, enum tva_type typ=
e,
> >                                             unsigned long orders)
> >   {
> >       return orders;
> >   }
> >
> > - Ongoing integration of cgroups and struct-ops
> >
> >   Work is still in progress to integrate cgroup support with
> > struct_ops (see also
> > https://lore.kernel.org/linux-mm/87cy439x8a.fsf@linux.dev/).
> > We should wait for this infrastructure to land before introducing
> > new cgroup-based struct_ops.
>
> This work can be carried out in parallel with integrating cgroup
> support with struct_ops. I will focus on addressing real workload
> scenarios to further clear/stabilize the BPF-THP ABI.
>
> > >   faced are likely to arise again, e.g. lifetime of cgroup vs bpf, dy=
ing
> > >   cgroups, wq deadlock, etc. It is recommended to use cgroup-bpf for
> > >   implementation.
> > > - The test cases are too simplistic, lacking eBPF cases similar to re=
al
> > >   workloads such as sched_ext.
> > >
> > > If I miss some thing, please let me know. Thanks!
> >
> > BTW, it would be better to include the original authors in the CC
> > list, especially since their work is cited in your commit message. ;)
>
> OK, I will CC the relevant authors in the next version.

Hello Vernon,

I believe it would be best to hold off until David provides guidance
on the future direction. While I am not currently active on BPF-THP,
we are still looking for the right opportunity to upstream it. The
primary difference is that your implementation is cgroup-based;
however, we also plan to switch to that approach once Roman=E2=80=99s work
lands.

I don't mean to imply that BPF-THP is solely my project, but I suspect
you will eventually arrive at a similar implementation to what I=E2=80=99ve
developed. So far, I haven=E2=80=99t found a more efficient API than the
following:

  unsigned long
  bpf_hook_thp_get_orders(struct vm_area_struct *vma, enum tva_type type,
                                             unsigned long orders)
  {
       return orders;
  }

--=20
Regards
Yafang

