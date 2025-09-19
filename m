Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A868CCAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 15:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 110938E001B; Fri, 19 Sep 2025 11:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E7F08E0019; Fri, 19 Sep 2025 11:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F18E38E001B; Fri, 19 Sep 2025 11:01:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF1868E0019
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:01:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9FF7A1406D9
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:01:51 +0000 (UTC)
X-FDA: 83906314422.30.40FCDE2
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id 85BFD40012
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:01:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TygyYf3s;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758294109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xd49/q/5YBCJxAFGP/L8ktabS8R9TywHti0W/ntbZ14=;
	b=NE+zmXUZPbQWCLI7yHHwkRixoJ+9MU42+iwm2c/dc1DN4Hj4LKcfk6ynlOsd3/z11ByDhh
	a+WEKHINlbRkxG/WOcwjJGXvn7VcgyeNLO2FcpI0PliutMNQ6zxka+HUFyI6RCZ1mLqPxi
	NV6ZYh/m2NhSCnWP8uj0wHYZG05k5sU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TygyYf3s;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758294109; a=rsa-sha256;
	cv=none;
	b=J6Ge+p5myZlw5qtNtY9UsBFhjmdxvs67OwkfQOYktgKjr8GCE5+MgR3/P4vjKLgaA/xqS9
	0IjK6KDaLkb73YCFnVedl9uqRwmLtbNZ7sa9XtW56xob25g8dyp1ywUA1t5UaxfrOEKNKN
	y9qGcEst/RWK94Et0KbbVkI3gcCylQc=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4bb7209ec97so301291cf.1
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758294108; x=1758898908; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xd49/q/5YBCJxAFGP/L8ktabS8R9TywHti0W/ntbZ14=;
        b=TygyYf3sspb7RiQUB8PKQCgmhISXLOsjGw/dWxxwL89U9XF7gA2/aEqC/xnPKwyd3l
         TVPasac8H9NXbW1ovCyvIAWhRT0tlNlXWmrXdFAwkweEUJCrFY1mEmuAKUoE/eCkpr1F
         HOC8SR2qcD62DmfKpEEFEEjhinK8ebOjPo50GYnLwm0g0AcR7u40gntvICLoumkYQxCp
         gNwndbU//iaoXMWVp8mER/IZpQ0flk365TsZcFSz6rcpe49pN38pTnvYAeuybruybCX4
         WM5vKnruO5xmGnnUByJJk9UeYjxPpUf3VIi6vl4r5LIGMpGpJDT6T8LH1bwcxihY4gHF
         YC5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758294108; x=1758898908;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xd49/q/5YBCJxAFGP/L8ktabS8R9TywHti0W/ntbZ14=;
        b=UQNqPzJI+RTGDBxvTzMe5znPMkWJRnwxwdQ4Lo+kTRW8MjZm1fA+86bWGAGBolrmrY
         SoFdfn0KvdhMyg7SucvWiqlps8Q8wPD6/CA/BcERVqD+824TFUES9ccU5cvVgy+d4QXC
         r8B6WAhTaU/c6BZzo+MeA6BGdXw8L7rIe/ag1GjPKZdbZdNcLlZ2eUxRLIAtD5jYBxyg
         bWp+2ZWEmbSIVKVSPDawKsi1bHM7MgSN5bdrQX+UlUnP1sgRj7NX14/I9tRQnZu7XQTY
         DuJhqA734ir9cqadm5aokkW+y4rsmFC/0Uix8ArsrghS5qlgYBMl8xlwFKocfpRorOyr
         G4Sg==
X-Forwarded-Encrypted: i=1; AJvYcCUnJg3+61fAUkDycStiX0PLMQCg6XrlUrc+ECPy8yRH7vR21U3CwaOh3oCwb/9CKbsJ4iPxTmdPXA==@kvack.org
X-Gm-Message-State: AOJu0Yy3aiCCM2pyfW8vgigm+UkupzMq8tujSqy5NLeLdmFLo7Z0fXWa
	XqEiMvxSb01KWRgrYG+v9zqSoyOJpVr7uPTB0ZoxrHpCnEiiTbVd7wYqicbcnjIqQrtEVNY9k8Q
	hgZrDgBYLr9LvOpU+ygIXnxtd62TGXZcA5k6Gb5fF
X-Gm-Gg: ASbGnct+fCgj3s0hcLwaW8kd7tNQ8T2zcgeZKWIl54X+beaelMD3KOmZE+WgIcdiQc/
	vJExzsEXh+YC0Q36HJGKXn7mM8Ii7NTor64hjjf+LdHS6sZIKzTkmGLk4cVzNyGyrxlcX1QgHDY
	Rg7CA+V7jrJxRj7EMkLSSomm48wErSmvDG4s60cB0FDJ88CDpsJpBF2QByy57ItgU3yqE1hvZmm
	pcmAg==
X-Google-Smtp-Source: AGHT+IHQKWY6HNPV+dUIZl6mPbASDwCVYU/qUliIO+mvEsbanwTZHZDc0ajD82tEvxz5DM4rad1N9lGhmUa33cuVXW8=
X-Received: by 2002:ac8:5f84:0:b0:4b7:94d7:8b4c with SMTP id
 d75a77b69052e-4b9d33b6432mr19618551cf.0.1758294107407; Fri, 19 Sep 2025
 08:01:47 -0700 (PDT)
MIME-Version: 1.0
References: <202509171214.912d5ac-lkp@intel.com> <b7d4cf85-5c81-41e0-9b22-baa9a7e5a0c4@suse.cz>
 <ead41e07-c476-4769-aeb6-5a9950737b98@suse.cz> <CAADnVQJYn9=GBZifobKzME-bJgrvbn=OtQJLbU+9xoyO69L8OA@mail.gmail.com>
 <ce3be467-4ff3-4165-a024-d6a3ed33ad0e@suse.cz> <CAJuCfpGLhJtO02V-Y+qmvzOqO2tH5+u7EzrCOA1K-57vPXhb+g@mail.gmail.com>
 <CAADnVQLPq=puz04wNCnUeSUeF2s1SwTUoQvzMWsHCVhjFcyBeg@mail.gmail.com>
In-Reply-To: <CAADnVQLPq=puz04wNCnUeSUeF2s1SwTUoQvzMWsHCVhjFcyBeg@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 19 Sep 2025 08:01:36 -0700
X-Gm-Features: AS18NWD12crNOmM4aEy96ofaHX5zWtBB8_S_SE5RNjFC2qJWezk2NctkV6nki6A
Message-ID: <CAJuCfpGA_YKuzHu0TM718LFHr92PyyKdD27yJVbtvfF=ZzNOfQ@mail.gmail.com>
Subject: Re: [linux-next:master] [slab] db93cdd664: BUG:kernel_NULL_pointer_dereference,address
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, kernel test robot <oliver.sang@intel.com>, 
	Alexei Starovoitov <ast@kernel.org>, Harry Yoo <harry.yoo@oracle.com>, oe-lkp@lists.linux.dev, 
	kbuild test robot <lkp@intel.com>, kasan-dev <kasan-dev@googlegroups.com>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 85BFD40012
X-Stat-Signature: 767jh9hptycdz9db8rs1om3j6h9jwdj3
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758294109-317893
X-HE-Meta: U2FsdGVkX1/jDXxMuABNe7/+qDC0HXMmw4RE68c+KbiOv+fjinDowoeExdoMR6Xc/83SuNIvsI2VpRYyXroNR7icpXG88Ki32FdpuohV+g5JrFjvkgFTvAXksOPfhgvcxapCWiNxpy7u7VcvwR1E4L7dD2ghF8UB63DRnIXOYSEGYVRCKPs4aGITNSAdxCgNbBg8aebh08AON/XKXUw30hrKEmvkjHvwqSddDKGiK2u9bUUHS4yWvDPZgLY2DWGmbm0FI5A/J7Bs4Fscc+drOuTXehjeCoyYxk1mfJf3fICaeGhWH99e+UyvlM4htVeDTIp1NsTBDlIdol6agK1zG69DXVMm3dEhRnCQsxpyZ4rj51ovwKWa1eSu5VUVbZ1YIwYimmaW/16dKqmAbAjmsNLcR761f9gBJjM4ryXC7Hpb9OGR4V628rIIt6hg6Ryej1KKEy0kjQbgpZJx0EUIK8NBxqqJAbz4kUJ/m3X14WqbcrlC4rc5F0CQRPztnhDv567wCFqAwDCz2XovZ9rkraaWT+DK0pJeAJY6cEWvHSJF5DdyA5PdS0Geg8lFc+T6oTPNyPamdlpNlRY7Z4QfgnKDB8WPpwDQFQE9+CeFyBfhXoVtdyLsxAL9JkrQkqSPcLYBv3XA58rWO4h1YqWez20Q0/aktDnClI0FWQhk3PeNsjZF2u2GgdYr9gOnS8Rb1N9THqWzxmcR8/Cj/KLBgjRnIJyg3VHv6G94HKC168OVdXrRmU+Bi6oqQjRbeBPT3dLGHdOwPdahYuPoJPBl88Cr2Lq90GirWLCJORZXWSexiLIPC5Nzm6fNLy8QvqgemzVvEifAx4YlFvnhiVxcpN5y6KsAiT/Qolrcyv4elOjERzVUq1yH43o4WE/4MPqVLdXf943W/qRyzAmCkx99v9x9bNRm/4Uxaj5Zfv0ET4rmEJixGbo6QrN9xBRnQnoHbQdk4tlir6QCSuPjfvY
 fRfQjYhn
 fNEN9VV3Y+zX9hIEtnJ9Fm95KALNhKWgZrJrSPNpi4YLTyCfOUJX7yV4KSMIfiN0UTeM/s20tpIaKIhbPVaKR9BPDWxJFj+lEHtIEYN3QUI28kVzfr133wEmWa9uVspZcua3H3SaegtkHmcaMqVLYsCRW6ClavpkM09i+tIEBlDfSAMasueBA7o77+jSprrQIEdza1n0aNXOkIUKV4FLUNj5LkbNDI65pYJTtmccW9dgqv941BsiB4L8/9JXAhGVKluiOREQ51zfLlhLjrR+3Y6OkjH8QPuv5ZX8JuEnhFyx1Cy07rAvC/oklHYDoz21vwwHaE54i6PFaObKO/jl6EXLgwkRPWg9UTStnwYWLBzQfPNA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 6:39=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Sep 18, 2025 at 7:49=E2=80=AFAM Suren Baghdasaryan <surenb@google=
.com> wrote:
> >
> > On Thu, Sep 18, 2025 at 12:06=E2=80=AFAM Vlastimil Babka <vbabka@suse.c=
z> wrote:
> > >
> > > On 9/17/25 20:38, Alexei Starovoitov wrote:
> > > > On Wed, Sep 17, 2025 at 2:18=E2=80=AFAM Vlastimil Babka <vbabka@sus=
e.cz> wrote:
> > > >>
> > > >> Also I was curious to find out which path is triggered so I've put=
 a
> > > >> dump_stack() before the kmalloc_nolock call:
> > > >>
> > > >> [    0.731812][    T0] Call Trace:
> > > >> [    0.732406][    T0]  __dump_stack+0x18/0x30
> > > >> [    0.733200][    T0]  dump_stack_lvl+0x32/0x90
> > > >> [    0.734037][    T0]  dump_stack+0xd/0x20
> > > >> [    0.734780][    T0]  alloc_slab_obj_exts+0x181/0x1f0
> > > >> [    0.735862][    T0]  __alloc_tagging_slab_alloc_hook+0xd1/0x330
> > > >> [    0.736988][    T0]  ? __slab_alloc+0x4e/0x70
> > > >> [    0.737858][    T0]  ? __set_page_owner+0x167/0x280
> > > >> [    0.738774][    T0]  __kmalloc_cache_noprof+0x379/0x460
> > > >> [    0.739756][    T0]  ? depot_fetch_stack+0x164/0x180
> > > >> [    0.740687][    T0]  ? __set_page_owner+0x167/0x280
> > > >> [    0.741604][    T0]  __set_page_owner+0x167/0x280
> > > >> [    0.742503][    T0]  post_alloc_hook+0x17a/0x200
> > > >> [    0.743404][    T0]  get_page_from_freelist+0x13b3/0x16b0
> > > >> [    0.744427][    T0]  ? kvm_sched_clock_read+0xd/0x20
> > > >> [    0.745358][    T0]  ? kvm_sched_clock_read+0xd/0x20
> > > >> [    0.746290][    T0]  ? __next_zones_zonelist+0x26/0x60
> > > >> [    0.747265][    T0]  __alloc_frozen_pages_noprof+0x143/0x1080
> > > >> [    0.748358][    T0]  ? lock_acquire+0x8b/0x180
> > > >> [    0.749209][    T0]  ? pcpu_alloc_noprof+0x181/0x800
> > > >> [    0.750198][    T0]  ? sched_clock_noinstr+0x8/0x10
> > > >> [    0.751119][    T0]  ? local_clock_noinstr+0x137/0x140
> > > >> [    0.752089][    T0]  ? kvm_sched_clock_read+0xd/0x20
> > > >> [    0.753023][    T0]  alloc_slab_page+0xda/0x150
> > > >> [    0.753879][    T0]  new_slab+0xe1/0x500
> > > >> [    0.754615][    T0]  ? kvm_sched_clock_read+0xd/0x20
> > > >> [    0.755577][    T0]  ___slab_alloc+0xd79/0x1680
> > > >> [    0.756469][    T0]  ? pcpu_alloc_noprof+0x538/0x800
> > > >> [    0.757408][    T0]  ? __mutex_unlock_slowpath+0x195/0x3e0
> > > >> [    0.758446][    T0]  __slab_alloc+0x4e/0x70
> > > >> [    0.759237][    T0]  ? mm_alloc+0x38/0x80
> > > >> [    0.759993][    T0]  kmem_cache_alloc_noprof+0x1db/0x470
> > > >> [    0.760993][    T0]  ? mm_alloc+0x38/0x80
> > > >> [    0.761745][    T0]  ? mm_alloc+0x38/0x80
> > > >> [    0.762506][    T0]  mm_alloc+0x38/0x80
> > > >> [    0.763260][    T0]  poking_init+0xe/0x80
> > > >> [    0.764032][    T0]  start_kernel+0x16b/0x470
> > > >> [    0.764858][    T0]  i386_start_kernel+0xce/0xf0
> > > >> [    0.765723][    T0]  startup_32_smp+0x151/0x160
> > > >>
> > > >> And the reason is we still have restricted gfp_allowed_mask at thi=
s point:
> > > >> /* The GFP flags allowed during early boot */
> > > >> #define GFP_BOOT_MASK (__GFP_BITS_MASK & ~(__GFP_RECLAIM|__GFP_IO|=
__GFP_FS))
> > > >>
> > > >> It's only lifted to a full allowed mask later in the boot.
> > > >
> > > > Ohh. That's interesting.
> > > >
> > > >> That means due to "kmalloc_nolock() is not supported on architectu=
res that
> > > >> don't implement cmpxchg16b" such architectures will no longer get =
objexts
> > > >> allocated in early boot. I guess that's not a big deal.
> > > >>
> > > >> Also any later allocation having its flags screwed for some reason=
 to not
> > > >> have __GFP_RECLAIM will also lose its objexts. Hope that's also ac=
ceptable.
> > > >> I don't know if we can distinguish a real kmalloc_nolock() scope i=
n
> > > >> alloc_slab_obj_exts() without inventing new gfp flags or passing a=
n extra
> > > >> argument through several layers of functions.
> > > >
> > > > I think it's ok-ish.
> > > > Can we add a check to alloc_slab_obj_exts() that sets allow_spin=3D=
true
> > > > if we're in the boot phase? Like:
> > > > if (gfp_allowed_mask !=3D __GFP_BITS_MASK)
> > > >    allow_spin =3D true;
> > > > or some cleaner way to detect boot time by checking slab_state ?
> > > > bpf is not active during the boot and nothing should be
> > > > calling kmalloc_nolock.
> > >
> > > Checking the gfp_allowed_mask should work. Slab state is already UP s=
o won't
> > > help, and this is not really about slab state anyway.
> > > But whether worth it... Suren what do you think?
> >
> > Vlastimil's fix is correct. We definitely need __GFP_NO_OBJ_EXT when
> > allocating an obj_exts vector, otherwise it will try to recursively
> > allocate an obj_exts vector for obj_exts allocation.
> >
> > For the additional __GFP_BITS_MASK check, that sounds good to me as
> > long as we add a comment on why that is there. Or maybe such a check
> > deserves to be placed in a separate function similar to
> > gfpflags_allow_{spinning | blocking}?
>
> I would not. I think adding 'boot or not' logic to these two
> will muddy the waters and will make the whole slab/page_alloc/memcg
> logic and dependencies between them much harder to follow.
> I'd either add a comment to alloc_slab_obj_exts() explaining
> what may happen or add 'boot or not' check only there.
> imo this is a niche, rare and special.

Ok, comment it is then.
Will you be sending a new version or Vlastimil will be including that
in his fixup?

