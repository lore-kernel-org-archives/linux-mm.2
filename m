Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC287CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 18:38:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F393B28000C; Wed, 17 Sep 2025 14:38:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1126280002; Wed, 17 Sep 2025 14:38:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4E3928000C; Wed, 17 Sep 2025 14:38:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D2C4D280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:38:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A06A28720D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:38:56 +0000 (UTC)
X-FDA: 83899603872.28.EC8DADF
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id B15C7140002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:38:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hhI1loJW;
	spf=pass (imf09.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758134334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WSe+/0Ppv6md7i7Zvl8mHAv4aY3npVBA8JoXdsiKzcU=;
	b=TTDkGuxP3BFY6yFfONTHa45SJNZ/fOa0XXSXu/UzqnlCyLxMRZELOpMWYQagVvkljk+Pqv
	3KeCohl7hjGfSWGWeMrlDPoFa7LwB5V60Zv+wZRD8lSZ954jkR9ocYE8WAEMvsazEwxNJE
	piaw02OyraUSP0ozSpG/TqSoMvsXtIs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hhI1loJW;
	spf=pass (imf09.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758134334; a=rsa-sha256;
	cv=none;
	b=UBWXfxMYpFlVf3bkMro8PU+BEzQcckcm+zOs5Guy6w/ujyiyVucUQ5Uss5Bv9VOFguKS4D
	shxujzgmIF3KwTGeWKHW0JMAemGz79nAye5Ez10hQ46S+/im7z2pMrd4c1MQCCZ6Qy9RD9
	YCc9Y2oap9IDRQcARSGrd91vIBZ6gjA=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-46130fc5326so691595e9.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758134333; x=1758739133; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WSe+/0Ppv6md7i7Zvl8mHAv4aY3npVBA8JoXdsiKzcU=;
        b=hhI1loJW+2k0FzG2KNMuIjCl1g/GWh3FAu95jd0f+VceVRHkDkK7/JFUU+EhRj3YgF
         rXmDbCGvefVIb+aNwjB+fSHa7m6pBip5kdLscZcLuGLxhzEtOirJ9HxBC1zTSS92/OT3
         VDTy9eKPx3aw0iHZDu+oGdc3ZZPOzJ0PFojlYJSz90sZvhOr81PY4aAtSQLIOwYaEYnD
         ubcCL7CakpWis9RoykAF7FeDh3g31+dHASodijHoj5AYNXZHDmuglXIzuZvlkQY7+gQ5
         tJEq0EC8s4pN0XQAS4b4nERy3H7LBi1iUrst6gC6EjCkNX1kkREqNllMReN0Wg1LStzM
         w2Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758134333; x=1758739133;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WSe+/0Ppv6md7i7Zvl8mHAv4aY3npVBA8JoXdsiKzcU=;
        b=HB7mLkpgfuQnrFc1MdFKdrkYnUGLaphlmTHkW4KkKNOVxQyLTcL/uuj1z74l5iy3SH
         n4r6x2HShZ2Pbis/Igk0BPTfN5wD8scXFv3Eqgd+W/otm+HkM7/rKnnAA6hp3rptwAr3
         AAYfFcIdO1xvrsittLfOxn4NM46Uu1rgRIU9XscKaiHo4YkxBO72CRnb9xGLgmwzJ6md
         aoFDfrzMUfEHkpVXkZ5KIwL+rlf0d1rxdstMjzdDRDOjBIdp1CoRIKI8eqYyiJ0Q1YXE
         4yk19qsXT+BQXbGeycm25F4ZO254XWmGtHASX0SfgiiQZd7PiNu8baToFfhg67qlzhmD
         zAMw==
X-Forwarded-Encrypted: i=1; AJvYcCWG3lMysBQEJwk+Ng6mv/aZjCqd6DnrgHoS9o1OBd6JOA8uXnn9Pu7+BsgCeSfpqCbuRVGiF1f9TQ==@kvack.org
X-Gm-Message-State: AOJu0YwD+w2Vt3RF5pD9dtCEa7Tj+skISL9uzuqeD0zJFMvVNY18uNof
	9FnDxpCZx3p0HKDlrZaQlp3AHgme6VWzfiBZXxEROyAHQaQe02qAkRM3R+lxTZCoB4TpXKrxJoB
	Ptl+EWCD5qrkbpfjSzEEdzxi2ATyzi4Y=
X-Gm-Gg: ASbGncuExpQ30tWDx2LxUmDmIe/jlz+Re3Na9c6OXjanLneoJkpY82jF1QssIbz8sMg
	9Odmb3VT12HAMZUQs293uCnTQ+e9wvxYeyr+AmE7Kir6SNZKI5K4/z4MTlEnWLCLwRDp7b4Cnwz
	08ytVIwzSO9n1eos3I7cK843Pl5s6T1Xnxmuc2deGtRtNht1kw4Gmkih1w/ZKaXpVTBqoFNkL2q
	xJ+nFqGYaqt3gmNpWpgiOOLMpSerGRDZJXCtNocQFraHGs=
X-Google-Smtp-Source: AGHT+IH65vHoAWQlQ3QxZg0jgRGWoc8ZKpbjQvB+6DwLthXrDAHZtbRQCJn4p44AxNGvT6W9g4Y7hgPMfFj54oU5Po4=
X-Received: by 2002:a5d:5d83:0:b0:3e8:f67:894a with SMTP id
 ffacd0b85a97d-3ecdf9b19b2mr3358067f8f.5.1758134332921; Wed, 17 Sep 2025
 11:38:52 -0700 (PDT)
MIME-Version: 1.0
References: <202509171214.912d5ac-lkp@intel.com> <b7d4cf85-5c81-41e0-9b22-baa9a7e5a0c4@suse.cz>
 <ead41e07-c476-4769-aeb6-5a9950737b98@suse.cz>
In-Reply-To: <ead41e07-c476-4769-aeb6-5a9950737b98@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 17 Sep 2025 11:38:41 -0700
X-Gm-Features: AS18NWCa5a8ExJYAmvo8581Fjoj9FqLlIlKIfMzQMBKR4Zv-pgzwhyjut6uI-zc
Message-ID: <CAADnVQJYn9=GBZifobKzME-bJgrvbn=OtQJLbU+9xoyO69L8OA@mail.gmail.com>
Subject: Re: [linux-next:master] [slab] db93cdd664: BUG:kernel_NULL_pointer_dereference,address
To: Vlastimil Babka <vbabka@suse.cz>
Cc: kernel test robot <oliver.sang@intel.com>, Alexei Starovoitov <ast@kernel.org>, 
	Harry Yoo <harry.yoo@oracle.com>, Suren Baghdasaryan <surenb@google.com>, oe-lkp@lists.linux.dev, 
	kbuild test robot <lkp@intel.com>, kasan-dev <kasan-dev@googlegroups.com>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B15C7140002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: x894m6ybpifdsat1u1we1545hnrtrwtx
X-HE-Tag: 1758134334-556971
X-HE-Meta: U2FsdGVkX1/UrifSvey2wfi+hrT2uLUVf1G3VmBuTa8yatRWoqMM289/T8q06Re/ApAAMKBar37zs0DA6zKu88jOVQ2A3cNJR1/ylJSQn/unNh+QS8tAdwTzCownr1sQIRpxkw2xYhxiv/x5elXULOE6+XBTve8Un3xZ4ENo3wRwo7IV9f8OTgLNyeJ+e2gTqvlcrZg6JQhmH1hNSIh4RgAs0yzDypJf5vFtEQxSIQ4z1fSU9W6CR/+39gaA4+40qcsiYE4zPzr+bBn7tbKhnsDuaJwYS6z/GSq30pNbgZmS31sMRopbGDLKSBZsgXnmNo24k0LSQ7juFv26K+BDRCKzBvnxz4PMr4Mb+P55ERF7xjM6MUkCdUwmehVN+aejQrbOLBQ4c1BrsibYgv5dBHa8Fcg6+3MNhcD5yJVmvbBqioyjwYgbXNDB5vP24UscEPxEGDBI382FdMsLj+4eZnyxc9CI9HcImhTFPLzqevA1RFGtAWL/UHEj3FDD+0xTGRey+kUM7R+C0E83g+uPkKos+NCp+8KDjD4Q4lSvZVPkscyCKKm2H6ZSsdbnYyOi15vrfkHCvQaZnhDSrwwwais8xtOd1su3dCZkD37IkVji1NkGex7s0p3Q3bLajYecSTaHEetjfpNwo8Z4dvai99S79F0q7qbsE5oWzfi8yE16Z7wLAY4rKG7PVZjI7juaTmly8M5+yiD1Ta8fMnwBCyJbkcZo6AiGvZBVx3rAze4fzozKWnhFOEmu0OKe0TOvy3UsMqKF5vvMn/Vo2EyMlSxLgmS7F+T2KRAzmnMyDosIV23oCsavpXPWpr/uoAvDucG1SQbA7nB1aur1aiORN6qdDPq32VRwb5MhTdd19K7OkKHpou9j7J8/guvwp7GWnTqvwkQbLfim4DMpJfUIAIvRWMnjJ4OlvOWIui48s05dqYhsLXHSEpOGOq4sx1VnVZRkr//3RRbjiNcj/oK
 VKVZnBxk
 buj2DkPIIn1m7DuQiT3PHfgXHQWZQtY+vNTDh8DtxMmP8j2fgqda9hcQ4A/JHQStQfmuL8PA5a+LeK01T9l1bOS9BmoGAWpffhVCo3KPeA+Qm10zQrE5U5/JPunVDcPPizisvpUy14mIbB+q1Mcgpp3SLYasP8V2qmjZOB/zxLhD0wdctLk6SDt3L5Jp2w1YXBychtsUWolATktSUzVNbzqYYgdGda2ETGKaeuJkuemvCjX9JyVtxQZ/jWUduFwpJRoZj/s/RrUAZ1L5YkrYXzTPr/7tSPaKge1/QxQwUD5TvpW8V3BW8FH75B3SOOWl3D0i15+c0Y54x0T96tqxYWz2X1XbFo78p/g2Otfb7S0RnbmwVVMXaRR+MEspRsFIenG10HTbdtan9WF9OzT7YZXSgHjqDRZ/1c9i7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 2:18=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 9/17/25 10:03, Vlastimil Babka wrote:
> > On 9/17/25 07:01, kernel test robot wrote:
> >>
> >>
> >> Hello,
> >>
> >> kernel test robot noticed "BUG:kernel_NULL_pointer_dereference,address=
" on:
> >>
> >> commit: db93cdd664fa02de9be883dd29343b21d8fc790f ("slab: Introduce kma=
lloc_nolock() and kfree_nolock().")
> >> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git maste=
r
> >>
> >> in testcase: boot
> >>
> >> config: i386-randconfig-062-20250913
> >> compiler: clang-20
> >> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -=
m 16G
> >>
> >> (please refer to attached dmesg/kmsg for entire log/backtrace)
>
> Managed to reproduce locally and my suggested fix works so I'm going to f=
old
> it unless there's objections or better suggestions.

Thanks for the fix. Not sure what I was thinking. __GFP_NO_OBJ_EXT
is obviously needed there.

> Also I was curious to find out which path is triggered so I've put a
> dump_stack() before the kmalloc_nolock call:
>
> [    0.731812][    T0] Call Trace:
> [    0.732406][    T0]  __dump_stack+0x18/0x30
> [    0.733200][    T0]  dump_stack_lvl+0x32/0x90
> [    0.734037][    T0]  dump_stack+0xd/0x20
> [    0.734780][    T0]  alloc_slab_obj_exts+0x181/0x1f0
> [    0.735862][    T0]  __alloc_tagging_slab_alloc_hook+0xd1/0x330
> [    0.736988][    T0]  ? __slab_alloc+0x4e/0x70
> [    0.737858][    T0]  ? __set_page_owner+0x167/0x280
> [    0.738774][    T0]  __kmalloc_cache_noprof+0x379/0x460
> [    0.739756][    T0]  ? depot_fetch_stack+0x164/0x180
> [    0.740687][    T0]  ? __set_page_owner+0x167/0x280
> [    0.741604][    T0]  __set_page_owner+0x167/0x280
> [    0.742503][    T0]  post_alloc_hook+0x17a/0x200
> [    0.743404][    T0]  get_page_from_freelist+0x13b3/0x16b0
> [    0.744427][    T0]  ? kvm_sched_clock_read+0xd/0x20
> [    0.745358][    T0]  ? kvm_sched_clock_read+0xd/0x20
> [    0.746290][    T0]  ? __next_zones_zonelist+0x26/0x60
> [    0.747265][    T0]  __alloc_frozen_pages_noprof+0x143/0x1080
> [    0.748358][    T0]  ? lock_acquire+0x8b/0x180
> [    0.749209][    T0]  ? pcpu_alloc_noprof+0x181/0x800
> [    0.750198][    T0]  ? sched_clock_noinstr+0x8/0x10
> [    0.751119][    T0]  ? local_clock_noinstr+0x137/0x140
> [    0.752089][    T0]  ? kvm_sched_clock_read+0xd/0x20
> [    0.753023][    T0]  alloc_slab_page+0xda/0x150
> [    0.753879][    T0]  new_slab+0xe1/0x500
> [    0.754615][    T0]  ? kvm_sched_clock_read+0xd/0x20
> [    0.755577][    T0]  ___slab_alloc+0xd79/0x1680
> [    0.756469][    T0]  ? pcpu_alloc_noprof+0x538/0x800
> [    0.757408][    T0]  ? __mutex_unlock_slowpath+0x195/0x3e0
> [    0.758446][    T0]  __slab_alloc+0x4e/0x70
> [    0.759237][    T0]  ? mm_alloc+0x38/0x80
> [    0.759993][    T0]  kmem_cache_alloc_noprof+0x1db/0x470
> [    0.760993][    T0]  ? mm_alloc+0x38/0x80
> [    0.761745][    T0]  ? mm_alloc+0x38/0x80
> [    0.762506][    T0]  mm_alloc+0x38/0x80
> [    0.763260][    T0]  poking_init+0xe/0x80
> [    0.764032][    T0]  start_kernel+0x16b/0x470
> [    0.764858][    T0]  i386_start_kernel+0xce/0xf0
> [    0.765723][    T0]  startup_32_smp+0x151/0x160
>
> And the reason is we still have restricted gfp_allowed_mask at this point=
:
> /* The GFP flags allowed during early boot */
> #define GFP_BOOT_MASK (__GFP_BITS_MASK & ~(__GFP_RECLAIM|__GFP_IO|__GFP_F=
S))
>
> It's only lifted to a full allowed mask later in the boot.

Ohh. That's interesting.

> That means due to "kmalloc_nolock() is not supported on architectures tha=
t
> don't implement cmpxchg16b" such architectures will no longer get objexts
> allocated in early boot. I guess that's not a big deal.
>
> Also any later allocation having its flags screwed for some reason to not
> have __GFP_RECLAIM will also lose its objexts. Hope that's also acceptabl=
e.
> I don't know if we can distinguish a real kmalloc_nolock() scope in
> alloc_slab_obj_exts() without inventing new gfp flags or passing an extra
> argument through several layers of functions.

I think it's ok-ish.
Can we add a check to alloc_slab_obj_exts() that sets allow_spin=3Dtrue
if we're in the boot phase? Like:
if (gfp_allowed_mask !=3D __GFP_BITS_MASK)
   allow_spin =3D true;
or some cleaner way to detect boot time by checking slab_state ?
bpf is not active during the boot and nothing should be
calling kmalloc_nolock.

