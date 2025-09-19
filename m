Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD007CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 18:32:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EBA98E0002; Fri, 19 Sep 2025 14:32:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C27F8E0001; Fri, 19 Sep 2025 14:32:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B11E8E0002; Fri, 19 Sep 2025 14:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 097378E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:32:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A952213BA41
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 18:32:14 +0000 (UTC)
X-FDA: 83906844588.15.79B85B2
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf17.hostedemail.com (Postfix) with ESMTP id C042B40009
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 18:32:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AjjGCkUZ;
	spf=pass (imf17.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758306732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NNz2rvWdWurkAjYnYhECzBshCI3+0s6yD1fA4kNT29Q=;
	b=B37lnkyc6sod13vro/nhdya3pCfdzvevju7mTuo3oya1NPckBaY6zuKgevWaxmKdZvZ5Fa
	MTGLbXDMw6L6EN8c/VOHDjh1RwLDuRHzME3p13wzUsaGZY/g/Ul2dVAr/8eed7xhua4cg4
	vlrNS73MZagCyT8ejPRvSnHxXR2A2NY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AjjGCkUZ;
	spf=pass (imf17.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758306732; a=rsa-sha256;
	cv=none;
	b=d2D6KDL90FtcNZQIsUZ9pwu/AzT6ffFutH1Gu9NMcGNQd34KCGVaq5/9CHMqN8MvLoiRC2
	RNOVy8xMyDvw2c9BMIUFYi4gLXlXqZS1CWi6icC+A34fsdITpH6dRHz3/TUsU0kiRh2HFI
	wrpTcf15cbPqa+TOw3S0iP9Ji9cW3g4=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3ee13baf2e1so1655176f8f.3
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758306731; x=1758911531; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NNz2rvWdWurkAjYnYhECzBshCI3+0s6yD1fA4kNT29Q=;
        b=AjjGCkUZC/wU/Pq/aBxIj9MogBKPz68IwBRrrLjob0LH/ed9ickNZ34BtX3vNTW56a
         uzj5Mys5ryEdA3AEjnuUAei73WuQPV39OLYxjVBRijw7hjalMMej5j3VtnaD4KYsy3i8
         TK74/OiYL3srQ3QSn4vhNM35I28sgawjny1lqlHe+G7VFvlUr27hynP7upeRi31xHrUT
         m17I5nOjjp59Rw3Om65gi+5I4C/9AITBNp1M5lVmgnJKiR4L6lI1oSBId26zfgQV/rPc
         2HdYSsHz2wNHPkaMAQhNrCcf2ZOAb7NLU2nRT2/7uXA3f2QgPMcKpBgfHaQyEGJb3ciL
         ih8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758306731; x=1758911531;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NNz2rvWdWurkAjYnYhECzBshCI3+0s6yD1fA4kNT29Q=;
        b=C0aMH05KzkBBNt7WYK/Jrb6NN/wdSFBD6lyQE92GpyLwXpT2PpPGapxtPBDhXnqLaK
         NZHDnJgXD+YFW+hlGF/PfOOc1sgy7dTpOb7pL864cf/8U0QaB5VRWIECQv0w2ABxVdPo
         a2cVZYQk/sBcdEvqBDQGUwBlKOii2D9zty40yUGSCunktHUtRili2YGKIMnnF1ZCTW8a
         BOsj3W5fEx/8FAmjPD13xPDEFvJ7GvXdjUP3bj8UqSZ1ABN7BT2JuPNrQs67Ixq3mcVq
         H56MBJS0joQOG7dBytcbN8TAjhbSkXimsVXETs5sUEXLSUiOPbhVsyXDcu096oTzvWKu
         SPIw==
X-Forwarded-Encrypted: i=1; AJvYcCUUTdxPFYrvTPFiimc9tGyvxD8zGvXt+Rj21oSgR5hE+Dv0KDwbxnqZHgx8qerqJDDEt68tZwDZPg==@kvack.org
X-Gm-Message-State: AOJu0Yzeq4yEClaCOCkufeA9LCzy9rncXyeuhiLAUhknjF9Qx65s6XSr
	AWTPUCKaeMv0WtGu6lyyZT0UZW1rXNByJ7m/88AiNuia3rHHT6tHNLSBQMvW8nOmPsKVx92gwyN
	njaf1IwdZYwkdFnMxqHlhqYCVwCR6acI=
X-Gm-Gg: ASbGncv/KCqPNrGkZHAKLpahLELhpgczpuMLlJWsBk2Q1El2NMrzbeAQMBBy4Kf0GBN
	3htHIrnAv9spm2hVA0cMg+0bYPNfbhg5IARthUCalp61ne31cJyf/hb68C1zwUrfGSjvtc+OY2k
	jezLjsXZUzWXe+04JovVdjgerU/9H6nGMTcEq8l6XOsXb0nlhiq3gmWSr8cGPZwwIo1vOsQJ3ry
	9MmWA3767mijvMEjbRh/rQ=
X-Google-Smtp-Source: AGHT+IE1qLgPZ2JZjML9mfB4gOIrZqCWSfRd0LbOWc+PJ+zRKBIhXbuoNJMp3mTSX/to1tTNSiq+a5JIlxqbwS6zv+k=
X-Received: by 2002:a05:6000:2486:b0:3ed:f690:a390 with SMTP id
 ffacd0b85a97d-3ee8481fdffmr3766244f8f.40.1758306730884; Fri, 19 Sep 2025
 11:32:10 -0700 (PDT)
MIME-Version: 1.0
References: <202509171214.912d5ac-lkp@intel.com> <b7d4cf85-5c81-41e0-9b22-baa9a7e5a0c4@suse.cz>
 <ead41e07-c476-4769-aeb6-5a9950737b98@suse.cz> <CAADnVQJYn9=GBZifobKzME-bJgrvbn=OtQJLbU+9xoyO69L8OA@mail.gmail.com>
 <ce3be467-4ff3-4165-a024-d6a3ed33ad0e@suse.cz> <CAJuCfpGLhJtO02V-Y+qmvzOqO2tH5+u7EzrCOA1K-57vPXhb+g@mail.gmail.com>
 <CAADnVQLPq=puz04wNCnUeSUeF2s1SwTUoQvzMWsHCVhjFcyBeg@mail.gmail.com> <CAJuCfpGA_YKuzHu0TM718LFHr92PyyKdD27yJVbtvfF=ZzNOfQ@mail.gmail.com>
In-Reply-To: <CAJuCfpGA_YKuzHu0TM718LFHr92PyyKdD27yJVbtvfF=ZzNOfQ@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 19 Sep 2025 11:31:57 -0700
X-Gm-Features: AS18NWDr8VuH5ucHYn2ibLVBASY5zct8WHDo7Mc0mqgDvlFRZ593jDOgzN6t5y4
Message-ID: <CAADnVQKt5YVKiVHmoB7fZsuMuD=1+bMYvCNcO0+P3+5rq9JXVw@mail.gmail.com>
Subject: Re: [linux-next:master] [slab] db93cdd664: BUG:kernel_NULL_pointer_dereference,address
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, kernel test robot <oliver.sang@intel.com>, 
	Alexei Starovoitov <ast@kernel.org>, Harry Yoo <harry.yoo@oracle.com>, oe-lkp@lists.linux.dev, 
	kbuild test robot <lkp@intel.com>, kasan-dev <kasan-dev@googlegroups.com>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C042B40009
X-Stat-Signature: 4me1eq75iqkyhsp459cmjr31hnr7tomz
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758306732-573657
X-HE-Meta: U2FsdGVkX18Qw88rXmfvBHWbkVwUdcQJhCTyZfTI3kv0L5UJmQBpwxcN3hFSnnJitZ/rVmVlfULQMq9+pXy5ndHqti8ZyTv6jbipZL50Z124417bnfuMvuH062FmBVJrsS8AEgeDwrN/dpZyiMJhVMVuE/LtyXMin5XlCpwDedIu7wiLXZGRAtim6R+J5wyJQBYo6t9jqLMExu7WTP/ZiZyV+wYmaTEzPqckPL89vTi6VQ8SlFnrz2c4fS3KAqxkxivZcBQBllBVTETe14bNDwpZWP48H9LgeXzRK0S6eHKq9dYS5CyFpjViTvYk8iubYuc9ovgxbTlAWs2I7Kaj5+jUm0cfNDzPnN+iMczvjf2Nj17frkx1ALjYXZcEECpikEsCzU7bbp/p0bzQmKoMQNhE+UNd7dlQGL1H8NfnSBxEaK9LPRPo03AgEmlp0jR9gx1dUi/C+4Ilbi9iIPF5f3QVYiFW02Mnx+KaRllMcrhy1tFz8LvkYpg0NGPgQCVSYzcuTmAmUllW3jMkWz2EB7AmMCP/cSTdibTOui+zgpqtS/KcuRnkTjWAGbbJTUCcJRemkwsIgKSURT55GqmpVZiJV9iyYbDVDWBUNakn66bC5QO6KjRCXTcILQXAAt+EhS8NfK8M4yCkQl5q5SvnpIqJSKQoFsipVLq3oFK9PHvIpx1eJvLXpRjV9gR08kNhPSDR2PmpVG9/JAPjcQVRBh9apIToG0VwzhrG0DaSMLeDApvnn58BXsCHwlNAo7C+dj+DS/beMnAEtq9CanHcujfDAhme/tXP0x9YHboPNbbvDXxfauJylSNcmzFFy5Tn+mG4izjxLSxNoqHdCc+1IiPQT8HDL6nJ7JmBK0WkgINxhcoTJItrHsGNa+Jn2D9qhtpR9v8wL/4dIRkLewUYHfIvI5AwOk67hLvIq+/JTGMkxmd56mEotp6HnM23I0WYPlfRtY3lQWSSZJCzPfw
 z4lchCqA
 /vx/Qjmf7+goEoQXG4WNI56IVAGkuuNHaWeup/Uht68/Six5mcpBjIHMviTKTAw/o14/pg0CaUEvLCkLcUTwsSsud4oTysnsjowTsx5eFR4/ZXysHa5Gy+U5XfdYUuATuN3NgoNn3skw1ryCkViir4WEBqIXQOhzECo1GolUZ5wjCCJs4kVAltXCeFODPqq2melXBFd9JzYo2egYI49dVpZwlvQ3cdAXKBTVjR7w3RxraWChzl4QlWIL4O7b+gFp1FcvY/AlhDKkOvKP69OC1E6tR3LzNjfgtnLInsFpWwvf4guYd4ernTmgFXWIz0Zh+lMEP+JQvfRuvAkHZl1l42cro+4YPR5Vvzh0oABpba02UHiZ0ZqzLtvr55rWM5T6DIZCAmuHCh3nWjgAyrkK9VvVgJYTpFBK8r6I4XLwg9PXtKGTygj2ObJTyBdi7lE3TZNPTFu/40ocypGujffBjcCNQdKpx5IGnOxH9w6EjAmCGmLY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 8:01=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Sep 18, 2025 at 6:39=E2=80=AFPM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Sep 18, 2025 at 7:49=E2=80=AFAM Suren Baghdasaryan <surenb@goog=
le.com> wrote:
> > >
> > > On Thu, Sep 18, 2025 at 12:06=E2=80=AFAM Vlastimil Babka <vbabka@suse=
.cz> wrote:
> > > >
> > > > On 9/17/25 20:38, Alexei Starovoitov wrote:
> > > > > On Wed, Sep 17, 2025 at 2:18=E2=80=AFAM Vlastimil Babka <vbabka@s=
use.cz> wrote:
> > > > >>
> > > > >> Also I was curious to find out which path is triggered so I've p=
ut a
> > > > >> dump_stack() before the kmalloc_nolock call:
> > > > >>
> > > > >> [    0.731812][    T0] Call Trace:
> > > > >> [    0.732406][    T0]  __dump_stack+0x18/0x30
> > > > >> [    0.733200][    T0]  dump_stack_lvl+0x32/0x90
> > > > >> [    0.734037][    T0]  dump_stack+0xd/0x20
> > > > >> [    0.734780][    T0]  alloc_slab_obj_exts+0x181/0x1f0
> > > > >> [    0.735862][    T0]  __alloc_tagging_slab_alloc_hook+0xd1/0x3=
30
> > > > >> [    0.736988][    T0]  ? __slab_alloc+0x4e/0x70
> > > > >> [    0.737858][    T0]  ? __set_page_owner+0x167/0x280
> > > > >> [    0.738774][    T0]  __kmalloc_cache_noprof+0x379/0x460
> > > > >> [    0.739756][    T0]  ? depot_fetch_stack+0x164/0x180
> > > > >> [    0.740687][    T0]  ? __set_page_owner+0x167/0x280
> > > > >> [    0.741604][    T0]  __set_page_owner+0x167/0x280
> > > > >> [    0.742503][    T0]  post_alloc_hook+0x17a/0x200
> > > > >> [    0.743404][    T0]  get_page_from_freelist+0x13b3/0x16b0
> > > > >> [    0.744427][    T0]  ? kvm_sched_clock_read+0xd/0x20
> > > > >> [    0.745358][    T0]  ? kvm_sched_clock_read+0xd/0x20
> > > > >> [    0.746290][    T0]  ? __next_zones_zonelist+0x26/0x60
> > > > >> [    0.747265][    T0]  __alloc_frozen_pages_noprof+0x143/0x1080
> > > > >> [    0.748358][    T0]  ? lock_acquire+0x8b/0x180
> > > > >> [    0.749209][    T0]  ? pcpu_alloc_noprof+0x181/0x800
> > > > >> [    0.750198][    T0]  ? sched_clock_noinstr+0x8/0x10
> > > > >> [    0.751119][    T0]  ? local_clock_noinstr+0x137/0x140
> > > > >> [    0.752089][    T0]  ? kvm_sched_clock_read+0xd/0x20
> > > > >> [    0.753023][    T0]  alloc_slab_page+0xda/0x150
> > > > >> [    0.753879][    T0]  new_slab+0xe1/0x500
> > > > >> [    0.754615][    T0]  ? kvm_sched_clock_read+0xd/0x20
> > > > >> [    0.755577][    T0]  ___slab_alloc+0xd79/0x1680
> > > > >> [    0.756469][    T0]  ? pcpu_alloc_noprof+0x538/0x800
> > > > >> [    0.757408][    T0]  ? __mutex_unlock_slowpath+0x195/0x3e0
> > > > >> [    0.758446][    T0]  __slab_alloc+0x4e/0x70
> > > > >> [    0.759237][    T0]  ? mm_alloc+0x38/0x80
> > > > >> [    0.759993][    T0]  kmem_cache_alloc_noprof+0x1db/0x470
> > > > >> [    0.760993][    T0]  ? mm_alloc+0x38/0x80
> > > > >> [    0.761745][    T0]  ? mm_alloc+0x38/0x80
> > > > >> [    0.762506][    T0]  mm_alloc+0x38/0x80
> > > > >> [    0.763260][    T0]  poking_init+0xe/0x80
> > > > >> [    0.764032][    T0]  start_kernel+0x16b/0x470
> > > > >> [    0.764858][    T0]  i386_start_kernel+0xce/0xf0
> > > > >> [    0.765723][    T0]  startup_32_smp+0x151/0x160
> > > > >>
> > > > >> And the reason is we still have restricted gfp_allowed_mask at t=
his point:
> > > > >> /* The GFP flags allowed during early boot */
> > > > >> #define GFP_BOOT_MASK (__GFP_BITS_MASK & ~(__GFP_RECLAIM|__GFP_I=
O|__GFP_FS))
> > > > >>
> > > > >> It's only lifted to a full allowed mask later in the boot.
> > > > >
> > > > > Ohh. That's interesting.
> > > > >
> > > > >> That means due to "kmalloc_nolock() is not supported on architec=
tures that
> > > > >> don't implement cmpxchg16b" such architectures will no longer ge=
t objexts
> > > > >> allocated in early boot. I guess that's not a big deal.
> > > > >>
> > > > >> Also any later allocation having its flags screwed for some reas=
on to not
> > > > >> have __GFP_RECLAIM will also lose its objexts. Hope that's also =
acceptable.
> > > > >> I don't know if we can distinguish a real kmalloc_nolock() scope=
 in
> > > > >> alloc_slab_obj_exts() without inventing new gfp flags or passing=
 an extra
> > > > >> argument through several layers of functions.
> > > > >
> > > > > I think it's ok-ish.
> > > > > Can we add a check to alloc_slab_obj_exts() that sets allow_spin=
=3Dtrue
> > > > > if we're in the boot phase? Like:
> > > > > if (gfp_allowed_mask !=3D __GFP_BITS_MASK)
> > > > >    allow_spin =3D true;
> > > > > or some cleaner way to detect boot time by checking slab_state ?
> > > > > bpf is not active during the boot and nothing should be
> > > > > calling kmalloc_nolock.
> > > >
> > > > Checking the gfp_allowed_mask should work. Slab state is already UP=
 so won't
> > > > help, and this is not really about slab state anyway.
> > > > But whether worth it... Suren what do you think?
> > >
> > > Vlastimil's fix is correct. We definitely need __GFP_NO_OBJ_EXT when
> > > allocating an obj_exts vector, otherwise it will try to recursively
> > > allocate an obj_exts vector for obj_exts allocation.
> > >
> > > For the additional __GFP_BITS_MASK check, that sounds good to me as
> > > long as we add a comment on why that is there. Or maybe such a check
> > > deserves to be placed in a separate function similar to
> > > gfpflags_allow_{spinning | blocking}?
> >
> > I would not. I think adding 'boot or not' logic to these two
> > will muddy the waters and will make the whole slab/page_alloc/memcg
> > logic and dependencies between them much harder to follow.
> > I'd either add a comment to alloc_slab_obj_exts() explaining
> > what may happen or add 'boot or not' check only there.
> > imo this is a niche, rare and special.
>
> Ok, comment it is then.
> Will you be sending a new version or Vlastimil will be including that
> in his fixup?

Whichever way. I can, but so far Vlastimil phrasing of comments
were much better than mine :) So I think he can fold what he prefers.

