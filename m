Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 823E7CCF9EB
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 02:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC6568E01B9; Wed, 29 Oct 2025 22:41:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76C48E01B2; Wed, 29 Oct 2025 22:41:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3E378E01B9; Wed, 29 Oct 2025 22:41:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC86B8E01B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:41:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5EE49BC40C
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:41:22 +0000 (UTC)
X-FDA: 84053229204.16.30D1CD9
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id ABD2DC0003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:41:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mHfK3bgE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761792080; a=rsa-sha256;
	cv=none;
	b=Z8UVKvIswMPFQj06ReKiesL5dfm15zOfuQBtq1N8ohlCLZiX5E1c/g2VrnMIVl9k5Oz3Xg
	ulO5W9wrBwxwvl/W/h/RW89J7rK1gyw7g13l9yMdqO9lG8vi83gKnKobKr7NlOl7qZZm+o
	8beWAaRMG3rYAKr9F5OJeunZXgWWWmg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mHfK3bgE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761792080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VSe4ujmKxwC2DXJeO8t3ogNFeO6qZ+2rbxk+w2YyOCw=;
	b=MTT36Naq4iFGFtOQIlvsw6LrQPf96HwXW2XK3m4zPZFQHWXxlge01F2MVmj0kerctUp2k7
	d+vWjcDqwFsbvQmvFctCzBcIbxtwOXgwyBPKpycOzpQN4E9/lQCsQjelB+8OXK+WoLmn3v
	sns867DTOG7AYJNBoSndH51EjZ+ANU4=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-78617e96ae1so6421887b3.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761792079; x=1762396879; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VSe4ujmKxwC2DXJeO8t3ogNFeO6qZ+2rbxk+w2YyOCw=;
        b=mHfK3bgEXectEmCysHLEIxm0HZ6RJ2z90lDiu4PKlGRU968kKSUWtH1g/tcFR7zWNu
         FTBO//3X28a0rPwkZYzBgNDpjsx0pwBilUM7K/ps/LXwExfLHbiFEosZ+D2IjSf66j5D
         NjbkeT3MEX6Mnueh2B+qyYC6kA3LnzIe/M3yCONrY9e8zntmXnMXrFb6sP0p2Y0qXrKv
         MKutmc9QWZiNl1fVxchCQMfrIHSX0vxujSfQzJFrussApqKccGYnTnG8EgL4t6RSuWWZ
         Zi+YyI5WA99R/WQTrY1dJqNlkftIYykHVX5bMxMXHRmPJj4Ou2HJ5O/bSMLEmXQqopUD
         3M5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761792080; x=1762396880;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VSe4ujmKxwC2DXJeO8t3ogNFeO6qZ+2rbxk+w2YyOCw=;
        b=pgSBr4J4D8d2P/iW5D5C6z7Y0uWzlJ1rQn/lTSOJn/1IpbmlyBBAHfmFUqKFedVvyz
         oE+Seye408BNTtl7j2ocJyPkrhShCP+vS8X7ndVgjEqKl7UQfeXxbW8Em5O7JKBylv/8
         hwgRdp/tesMyFquMU+54brUhy1EjTWS+mkD8WqGA+X5YTCH+L0WMqpmJon7BYteGfocB
         +/Liwd3f1ZGaULJrT9oN0S36NBWTf6zdW4PdRan6U9SdOhhhdmxpWalP9AU0MKKVydfT
         a0oBbS0IXGWMnscdtE8RlMIDeOqE5SbvXwb7U3f7LCMsCJLz39baWaoYHtyQ3H9RDD5m
         jooA==
X-Forwarded-Encrypted: i=1; AJvYcCVpWkw0Qc78qcm1t9B2QkZHD3uAxhrBYfnhmKNtfetBM1CTRgkSegIN7QY1rGz9vHHZRH/Lx/W+Cg==@kvack.org
X-Gm-Message-State: AOJu0Yy9/PhHhvYrCF94pq6WNUNOLrwqGlGKAUw1c8gx0t0L6/3on3F7
	D6aI4LmKovKZdjLBD6lHywrkgSC9h0kqNZZJCIf8yalXNLxu+yGK9bAUtsbhf9G36Xu51MFKDvu
	4FLDJMjubiUe3e4MkxGtZVPYhzztAV9g=
X-Gm-Gg: ASbGncvK362MG0l4ACxWgEhvXVy+je9h4+TtdwDvVpDTy8w+WFdNRf8bnNmyCyPVTWQ
	bHa9O5YnnoxNSmeYDQmZmEZPIkH40hWxBrY33kr+pVtLthpaZEqbj1bVmKq7M5/Lzx+asV80F5Z
	mrY7/a3ykCSCh9poP4RsiuU+l8D4/mzAIkiulTU+Ee/yqKB8tpa1JuhBSHLo2IzGVlD7xSGqhrJ
	5tLRdW6kQUQVCq4r+XvgWu4kMLydaK+c/JegdS7OfRHgg9Rs9gkDGDvsejN4A==
X-Google-Smtp-Source: AGHT+IHkaGRY47Vr0p1/F79EcJ88ITWDpiXG/ComEOJWc5GK5/nf645jMmUB4EHdKa7lCdd0T+UHtmu0FhAOXVmqa3w=
X-Received: by 2002:a05:690c:88b:b0:784:ab8d:4b97 with SMTP id
 00721157ae682-78628fdba8dmr47819317b3.58.1761792079474; Wed, 29 Oct 2025
 19:41:19 -0700 (PDT)
MIME-Version: 1.0
References: <20251026100159.6103-1-laoar.shao@gmail.com> <20251026100159.6103-7-laoar.shao@gmail.com>
 <CAADnVQKziFmRiVjDpjtYcmxU74VjPg4Pqn2Ax=O2SsfjLLy5Zw@mail.gmail.com>
 <CALOAHbD+9gxukoZ3OQvH2fNH2Ff+an+Dx-fzx_+mhb=8fZZ+sw@mail.gmail.com> <CAADnVQK9kp_5zh0gYvXdJ=3MSuXTbmZT+cah5uhZiGk5qYfckw@mail.gmail.com>
In-Reply-To: <CAADnVQK9kp_5zh0gYvXdJ=3MSuXTbmZT+cah5uhZiGk5qYfckw@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 30 Oct 2025 10:40:43 +0800
X-Gm-Features: AWmQ_bm6gqmyylYroPXEXY8mGbZ4lcr6XBjms3-D9YBfaNqoGFMZKAl7IMZRKqQ
Message-ID: <CALOAHbC3p-zUZBs7S2r78nCPZm3F=AjJY7cL3RezTPtOXmLb6g@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 06/10] mm: bpf-thp: add support for global mode
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, Johannes Weiner <hannes@cmpxchg.org>, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>, 
	Amery Hung <ameryhung@gmail.com>, David Rientjes <rientjes@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Barry Song <21cnbao@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, 
	Randy Dunlap <rdunlap@infradead.org>, Chris Mason <clm@meta.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ABD2DC0003
X-Stat-Signature: z38orn37rca3p63q3o8k9rfxs7zdduem
X-HE-Tag: 1761792080-181990
X-HE-Meta: U2FsdGVkX19jyqvBleArZLDV79/7uV0iC5fbEhWGy0kjX58uNzI54OpLz6shwwzpu3rKuxpyg8z2pI6hZkgqErcU1ByRBGcFSnhWpThErNl0XcAC9eeVQ59BO2DZ2i0TCfPXuXXn+djKjBepukMdqTzHZKoJp0few8R/J/tLRFz7ylhRLWFz8owae7/4Lphkpi3Cq0IFoYg62dIoRg7m4R/wCXPX149qtmc9Bz49gb4e1haUysqXfTDNDLdQKRH3RKEAxl6JzvyKXjc1a5DArMClO0uVi8gWTEFmEmYkZ5JrmwRlOXNEh3ZEUkVuXwz5zsO9yQZmuEHyyGMNyRdJzlzT2Eh+xfaJ8tmtMNqgUaKckhj8nqTt9dmBfHROkKEaP4NWpJ+yTQJegvKrfbncrIzwLBMJyo1dDn/oHv+nW2X9Xmz8TNYzJ4w4KhRcRIT7TIxKG4wjV9tYlnzYkkpSKhVjFLKzHYLEId6gtbaBF3wdsFiy4CjpVcTHSzdZyM8J5+z1+s1wRfCsJ3yUUFeuZmu6yzlBboAJkngLSzs1ht5FRF/hccXeaIBslWLUGb7NnlfAgronUYbtYZe9HMWB4IaLzy2LxC/rH7Cqtcc6yaRJLjjAbI/Vj7noLQ/F1LvPhh16GXXKpap1yy7oLhrYUL5+k4WpnNoYyKlevQRyEppZUgs7e2EJKtd3pyK5dfIkkxsUFF/CbUyZLAjfH89b5kQooeg2SzU0TPWuLxBDIVeqXcnCUTX+IN9UQiPFSqHU9zWazHj6JFSZrjE0jcvGFB4m1ttvgZP41MTuJqfNys3/AnnJT0qkv9CrEuHchgm1vFc/BJTxcA4ipxrpZDPLchajFzBh/djNc2XVmuF94x9gjDn40m/Mp5MazrBQKNtCwiQ1TxAwS8EoZHHEA+8koKh3P/wGecFBoPhk526Vn3IuPtgagc5TNAyw3FQMjvo6bmvO/tBPe5C99k6fKa4
 4QWz0gin
 lKFjL02LqiX5PSW5jNe++pP1QmTGS6N0klWR/UVM7Anr3XBGtkcG/jQToXGGT+EISPxTz7Jz9cJnutnsXmQW0pg4JemZ+RD2Z+lei6weac5sU1KqWTsJl/kQfPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 8:57=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Oct 28, 2025 at 7:14=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com=
> wrote:
> >
> > On Wed, Oct 29, 2025 at 9:33=E2=80=AFAM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Sun, Oct 26, 2025 at 3:03=E2=80=AFAM Yafang Shao <laoar.shao@gmail=
.com> wrote:
> > > >
> > > > The per-process BPF-THP mode is unsuitable for managing shared reso=
urces
> > > > such as shmem THP and file-backed THP. This aligns with known cgrou=
p
> > > > limitations for similar scenarios [0].
> > > >
> > > > Introduce a global BPF-THP mode to address this gap. When registere=
d:
> > > > - All existing per-process instances are disabled
> > > > - New per-process registrations are blocked
> > > > - Existing per-process instances remain registered (no forced unreg=
istration)
> > > >
> > > > The global mode takes precedence over per-process instances. Update=
s are
> > > > type-isolated: global instances can only be updated by new global
> > > > instances, and per-process instances by new per-process instances.
> > >
> > > ...
> > >
> > > >         spin_lock(&thp_ops_lock);
> > > > -       /* Each process is exclusively managed by a single BPF-THP.=
 */
> > > > -       if (rcu_access_pointer(mm->bpf_mm.bpf_thp)) {
> > > > +       /* Each process is exclusively managed by a single BPF-THP.
> > > > +        * Global mode disables per-process instances.
> > > > +        */
> > > > +       if (rcu_access_pointer(mm->bpf_mm.bpf_thp) || rcu_access_po=
inter(bpf_thp_global)) {
> > > >                 err =3D -EBUSY;
> > > >                 goto out;
> > > >         }
> > >
> > > You didn't address the issue and instead doubled down
> > > on this broken global approach.
> > >
> > > This bait-and-switch patchset is frankly disingenuous.
> > > 'lets code up some per-mm hack, since people will hate it anyway,
> > > and I'm not going to use it either, and add this global mode
> > > as a fake "fallback"...'
> > >
> > > The way the previous thread evolved and this followup hack
> > > I don't see a genuine desire to find a solution.
> > > Just relentless push for global mode.
> > >
> > > Nacked-by: Alexei Starovoitov <ast@kernel.org>
> > >
> > > Please carry it in all future patches.
> >
> > To move forward, I'm happy to set the global mode aside for now and
> > potentially drop it in the next version. I'd really like to hear your
> > perspective on the per-process mode. Does this implementation meet
> > your needs?
>
> Attaching st_ops to task_struct or to mm_struct is a can of worms.

The feedback suggests there may not have been an opportunity to review
patch #3 in detail yet. I would appreciate it if you could take a look
at the specific changes in that patch, as it addresses the core of the
implementation.

> With cgroup-bpf we went through painful bugs with lifetime
> of cgroup vs bpf, dying cgroups, wq deadlock, etc. All these
> problems are behind us.

The attachment-based design of cgroup-bpf creates significant
operational challenges. It lacks visibility, making it difficult to
identify which cgroups have active attachments, and requires explicit
author knowledge for clean detachment.

> With st_ops in mm_struct it will be more
> painful.

To save your time, I've pasted the relevant portion of patch #3 below:

  When registering a BPF-THP, we specify the PID of a target task. The
  BPF-THP is then installed in the task's `mm_struct`

    struct mm_struct {
        struct bpf_thp_ops __rcu *thp_thp;
    };

  Inheritance Behavior:

  - Existing child processes are unaffected
  - Newly forked children inherit the BPF-THP from their parent
  -  The BPF-THP persists across execve() calls

    A new linked list tracks all tasks managed by each BPF-THP instance:

  - Newly managed tasks are added to the list
  - Exiting tasks are automatically removed from the list
  - During BPF-THP unregistration (e.g., when the BPF link is removed), all
    managed tasks have their bpf_thp pointer set to NULL
  - BPF-THP instances can be dynamically updated, with all tracked tasks
    automatically migrating to the new version.

  This design simplifies BPF-THP management in production environments by
  providing clear lifecycle management and preventing conflicts between
  multiple BPF-THP instances.

To clarify, this design has no lifecycle issues. It provides clear
traceability: you can always identify who loaded the program and which
processes it's attached to. Moreover, removing either the loader or
the pinned bpf_link will completely remove the program and all its
associated state.

> I'd rather not go that route.

I'm glad we can talk about this directly=E2=80=94it saves us both a lot of =
guesswork.

>
> And revist cgroup instead, since you were way too quick
> to accept the pushback because all you wanted is global mode.
>
> The main reason for pushback was:
> "
> Cgroup was designed for resource management not for grouping processes an=
d
> tune those processes
> "
>
> which was true when cgroup-v2 was designed, but that ship sailed
> years ago when we introduced cgroup-bpf.
> None of the progs are doing resource management and lots of infrastructur=
e,
> container management, and open source projects use cgroup-bpf
> as a grouping of processes. bpf progs attached to cgroup/hook tuple
> only care about processes within that cgroup. No resource management.
> See __cgroup_bpf_check_dev_permission or __cgroup_bpf_run_filter_sysctl
> and others.
> The path is current->cgroup->bpf_progs and progs do exactly
> what cgroup wasn't designed to do. They tune a set of processes.
>
> You should do the same.

I'm fully supportive of a cgroup-based approach, as it simplifies
integration by requiring only a kubelet plugin instead of
modifications to containerd.

However, my primary concern is the potential for maintainer pushback,
given the historical precedent. For instance, a similar discussion in
the NUMA-balancing context saw cgroup maintainers insisting on a
process-based method (see link below):

  https://lore.kernel.org/lkml/ldyynnd3ngxnu3bie7ezuavewshgfepro5kjids6cuxy=
4imzy5@nt5id7nj5kt7/

To proactively address this, what alternative plan would you recommend
if we encounter such resistance? It's unclear what a viable path
forward would be if we are committed to a cgroup-based approach but it
is ultimately rejected by the maintainers.

(Adding Michal to CC for visibility)

>
> Also I really don't see a compelling use case for bpf in THP.

I'd recommend familiarizing yourself with the THP implementation. This
would be beneficial for our discussion on the specific changes.

> Your selftest is beyond primitive:
> +int pmd_order;
> +
> +SEC("struct_ops/thp_get_order")
> +int BPF_PROG(thp_not_eligible, struct vm_area_struct *vma, enum tva_type=
 type,
> +     unsigned long orders)
> +{
> + /* THPeligible in /proc/pid/smaps is 0 */
> + if (type =3D=3D TVA_SMAPS)
> + return 0;
> + return pmd_order;
> +}
> hard code this thing. Don't bother with bpf.

A prior implementation that combined these components existed in an
earlier version:

  https://lore.kernel.org/linux-mm/20250729091807.84310-5-laoar.shao@gmail.=
com/

However, based on your previous guidance that fexit and struct_ops
should not be mixed, the current approach was adopted.

In summary, I'm happy to proceed with a cgroup-based implementation. I
would appreciate your support in addressing any concerns the cgroup
maintainers might have.

--=20
Regards
Yafang

