Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3816ECA1013
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 01:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155B48E00A6; Thu, 18 Sep 2025 21:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12D6F8E0008; Thu, 18 Sep 2025 21:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01BD18E00A6; Thu, 18 Sep 2025 21:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E07B68E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 21:39:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 72AAC14052E
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:39:58 +0000 (UTC)
X-FDA: 83904293676.19.9363474
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 741351A0002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:39:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gJVX14b8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758245996; a=rsa-sha256;
	cv=none;
	b=PXZ2zNnPJO6DdVzG3fJ5nLM8r2DAQ5JDp3AH3lRpwL705amxPnetaazPPSLzmFtMMGNLK8
	PsNSs9fSbY8/KFbxRWQzcyJfASuEABg5+Hf+3GPSYiw/4oseeoQ23ETITAO5kNY4Q8PzNA
	O/idPXscJDfUD+O3zSxDSG9eA5IG/yc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gJVX14b8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758245996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TLWwqggp3K/TaMuP/qh+3dUHM74KL5ZFGLTQM4YRlUo=;
	b=RN1nQ9IdqVerKxR+HPjWvYMq9xO1i9Gd7T6tsiEBhIrcmp/rV5m3CgmZ4ze6lIjdtMcO95
	nNMR5AppuCPigTlKWmTFyFd1x+Ef4C8VrF4/AACdz6gEHECk7cIxjcQNHsw17PzQGaoslP
	Z++smktTEJbauafkbFnOiqaDycKE/nU=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-46897c60e38so332175e9.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758245995; x=1758850795; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TLWwqggp3K/TaMuP/qh+3dUHM74KL5ZFGLTQM4YRlUo=;
        b=gJVX14b8AFp+ciBzsX03sSBggUn9r2dAcIbtWV1DkmdPJBLJ9/TVBy30ssxZ20xOjw
         8eMRcIYi2ZPGqYCeIXK3l2RoiycFty+w8Z5/KiWOkvI53ic0OSCfj809dVgYnnGyy1QX
         CQHxPgHg2570yOn4K3OTtT6erMUsPiAxPMa9ridDDVklEaPzgRPiWpJjkyHkcGRtRkVb
         yzQqVgpc86rUN1H2PqGaXpRmN94+asdwYpEuhDaT3PrlyVEL6QQ4mYO9dASNMaJFlSgX
         2NyQ8UghWJPzm4KYEHqPAYtjEkwDG9jfpWelRwmg/3qdzObAX9WmIKUWCr/FlFIH0yIg
         R82w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758245995; x=1758850795;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TLWwqggp3K/TaMuP/qh+3dUHM74KL5ZFGLTQM4YRlUo=;
        b=FTmgHGalwBNKtmoKzED4LIJsQvqmIisQzX0yT76dBeHncbcAX3eOuHK0R2cY7ZaAuP
         HmF7Hk8Z58EQqJUD7FtKbNUa9aUeAH1w5Y0Js3u5pcLYS+6bPBi1ytBWxa438d41Lk8h
         uz0qzAKItdaUmXHM+WCgHWoraYe3IUNq/Fw56sjf01XLlZkHYdqwCZ8TuZqfPXHX/znh
         9Wjx3MiX2BcCwmLZXjPZq346gYNpNtZI+RFn3DX96UG0TfTHZZKsPVWMwlit8UgLVhCC
         Era9UKZWcifTDVyTXkbpzFhgTuZAvio0i/T/ywu5qedc8RY8+FaTkXf7ZAiOKdlwRFLp
         EDkg==
X-Forwarded-Encrypted: i=1; AJvYcCXVBknGR6Ro0x54bFd9YlqALQGom2rjespgSwQglMJOG1o0WY0kNCajqDyOFDEKnAgBmAINJqGbPw==@kvack.org
X-Gm-Message-State: AOJu0Yy/uS8pXT2Od8gdrC/ID6lLN2NeIwu1CkLRkAxxGjOY4h+slkpE
	w4WDE7hZClH9OiTEd8w1bRP7zbHsEN0ZgGjBVE6WLKd5hPrdFetsHPAqhFofbLMm4PpSMJvnYY/
	kK8IZqoZTvMgud21s4v1iPmDMZ5PLMwM=
X-Gm-Gg: ASbGncsFbineSSMDqdEDWyzdIFTGuMknwIuwZ6vmE1aMnEVRhNJ8R6A8mNzHf6Uj8it
	DPXEePThUobKRUf+y1rAmiK6sfVE0+4ydau9kTqNEAzqQDOtvR/4PsCZmnNbhtpTdqzUnYSKclb
	H2jJZ4Xt0llxBOw1iKjvLyn6fC6URF5dm4OEL2hvZSNQfyE9POLsp8qAL4Cxq5RLn/eQDRwK3Ii
	nq/WjwAMCIO44ubBYjsMhx3QVamwJQP40E+
X-Google-Smtp-Source: AGHT+IGLUHNvVeU7x3xV9/sHYbwwni9HCE8NZCidCtCfno9QqZD0/k8AaMlh+DMF0H+c7wtm4oRSBiysUcySWCH78RQ=
X-Received: by 2002:a05:600c:4fc3:b0:45d:ddc6:74a9 with SMTP id
 5b1f17b1804b1-467eed8f915mr8129025e9.12.1758245994492; Thu, 18 Sep 2025
 18:39:54 -0700 (PDT)
MIME-Version: 1.0
References: <202509171214.912d5ac-lkp@intel.com> <b7d4cf85-5c81-41e0-9b22-baa9a7e5a0c4@suse.cz>
 <ead41e07-c476-4769-aeb6-5a9950737b98@suse.cz> <CAADnVQJYn9=GBZifobKzME-bJgrvbn=OtQJLbU+9xoyO69L8OA@mail.gmail.com>
 <ce3be467-4ff3-4165-a024-d6a3ed33ad0e@suse.cz> <CAJuCfpGLhJtO02V-Y+qmvzOqO2tH5+u7EzrCOA1K-57vPXhb+g@mail.gmail.com>
In-Reply-To: <CAJuCfpGLhJtO02V-Y+qmvzOqO2tH5+u7EzrCOA1K-57vPXhb+g@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 18 Sep 2025 18:39:43 -0700
X-Gm-Features: AS18NWBlUth1kJvWS5JXtLwteu2b8Preo5gOd_kEK4OqVju9jJmrGXsODrzjcRM
Message-ID: <CAADnVQLPq=puz04wNCnUeSUeF2s1SwTUoQvzMWsHCVhjFcyBeg@mail.gmail.com>
Subject: Re: [linux-next:master] [slab] db93cdd664: BUG:kernel_NULL_pointer_dereference,address
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, kernel test robot <oliver.sang@intel.com>, 
	Alexei Starovoitov <ast@kernel.org>, Harry Yoo <harry.yoo@oracle.com>, oe-lkp@lists.linux.dev, 
	kbuild test robot <lkp@intel.com>, kasan-dev <kasan-dev@googlegroups.com>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 741351A0002
X-Stat-Signature: tf5riye5f9w4eryedbt1fsrx3y84bkeu
X-Rspam-User: 
X-HE-Tag: 1758245996-841655
X-HE-Meta: U2FsdGVkX1+HE8lRDqGJFNdO/nIuZQfhhdKXy6wSPsIazGHOpSpNktqD28gXepqeUxh8gC+Y/vn5EC9EQeQfgfeYlNeS93BF6TXrNtPa8GVhLyemzk44QJ2ol8NPpSiOE3orjzc8W+TmB0FXoVlCGxtW1RGaACdEuWmh0DvHWPE1FtrTXfSldNYrCxgp2sU35S6jyB9A1HBjM0OqJHUuxB9oEWupx0rlh4a+OkJjJgeIdjW12p+B0fer6kOQCe6TBmWQKTAlyZzXETMI1bYnC1fRdpo6Zq0v2NsN5nH/I/XI/bgK4hSgeX0ZVwyyPG2eBujpaN4ZpJH2wxeHbgBAYEXblUf344ho7HLotJmMtGex4ShLC5j//YnHOrIfIjPRewVfyEFbXDNU1DtoH8aG2UzHpz2wXY6A4znsggs1uZ9liyFE3YnSm8bjfIjSvRH9cO+taDt2fTm0b4J8MGjyEaNucgM3Ud73NuJVlRY2zB4FWspoT2u/ffYABpub5kbgOc25aJvZWxt35cohmkXOc66ogTj8dzlVKNZmPubfCyKiu3OOq6T07b2IX/uq+vmY6DXaKCZLlIzvWfKiCmQAsgiGqCuY/qlevvDTj7QpFdwl0kA1EptwGqKcHJQsYyfBdMDfcRtF5Ar4WTgq7Fdui30wCXW9krEAnMwsm/lh4xGcxGVusuYAKGFvBr3df0+yN5DiRGTUumOQueOmhrnGqZIPhARS1pQraDqVhwJQ9YT1ZaiV+N8hJ2OHuapEFE678+Dkml6zyFKAlBRtgsu4ZPChSHglLnIKd1z0ZXeJF9hAhbtDRdNwYSpOYoWZItWCmtf4IqfZYz/oByzXLmHTRKyvRjYbfjzbLVjZaxMgEqVGxLCEJqmFok4z04//9eUXYkUxAhT/aEq97JRj8DP+xj7Jz5KktXv+5oYXRAFrYTsX/RyrbYYOWm5sbbDsq8Y046yyufk6a1irf0PsWXd
 jT/EP5ou
 veistAHS/o8kq+8rAMaBuqb+6KCABYK6ZV7yPEd+3pRxwaV4pHAEwaFqLDolyRSOKnnYktq6NKs+U/m/sem2cA6SmIVbFlqbzFnj9h6uSeb1dZU8msGJa2cTR4KJHAw+UiWBkFS2VFuVaSFgi2cpml8kFyT4/mGGHSOmELVB8g5GzlpCh2sUH+5N0DpFYCqDOumT1CUVFSknu1Y37ytnZcapzISslK9WP+qk9V08LoOf4Lah17vfyL9lNX4aV2hKUXcQWbIw+mGyRJkBLE2lMvBd4FGuSBgM95O/A8nnzyQGWoK0mhXdmO9C82C2t0hy1HDjftVJ4ViTcKhDuVo7z79cvo5dkldhqEmTzGHppqez7Z7eKaABwieGpUJ3YLE6dgzIr0mtAR27xdCTYf9lUtUQcuSH/omJleF4sF0VWjjqrpzrOWIRQD8+yyYam55myhbuQ/jzbwtTVLb8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 7:49=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Sep 18, 2025 at 12:06=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz>=
 wrote:
> >
> > On 9/17/25 20:38, Alexei Starovoitov wrote:
> > > On Wed, Sep 17, 2025 at 2:18=E2=80=AFAM Vlastimil Babka <vbabka@suse.=
cz> wrote:
> > >>
> > >> Also I was curious to find out which path is triggered so I've put a
> > >> dump_stack() before the kmalloc_nolock call:
> > >>
> > >> [    0.731812][    T0] Call Trace:
> > >> [    0.732406][    T0]  __dump_stack+0x18/0x30
> > >> [    0.733200][    T0]  dump_stack_lvl+0x32/0x90
> > >> [    0.734037][    T0]  dump_stack+0xd/0x20
> > >> [    0.734780][    T0]  alloc_slab_obj_exts+0x181/0x1f0
> > >> [    0.735862][    T0]  __alloc_tagging_slab_alloc_hook+0xd1/0x330
> > >> [    0.736988][    T0]  ? __slab_alloc+0x4e/0x70
> > >> [    0.737858][    T0]  ? __set_page_owner+0x167/0x280
> > >> [    0.738774][    T0]  __kmalloc_cache_noprof+0x379/0x460
> > >> [    0.739756][    T0]  ? depot_fetch_stack+0x164/0x180
> > >> [    0.740687][    T0]  ? __set_page_owner+0x167/0x280
> > >> [    0.741604][    T0]  __set_page_owner+0x167/0x280
> > >> [    0.742503][    T0]  post_alloc_hook+0x17a/0x200
> > >> [    0.743404][    T0]  get_page_from_freelist+0x13b3/0x16b0
> > >> [    0.744427][    T0]  ? kvm_sched_clock_read+0xd/0x20
> > >> [    0.745358][    T0]  ? kvm_sched_clock_read+0xd/0x20
> > >> [    0.746290][    T0]  ? __next_zones_zonelist+0x26/0x60
> > >> [    0.747265][    T0]  __alloc_frozen_pages_noprof+0x143/0x1080
> > >> [    0.748358][    T0]  ? lock_acquire+0x8b/0x180
> > >> [    0.749209][    T0]  ? pcpu_alloc_noprof+0x181/0x800
> > >> [    0.750198][    T0]  ? sched_clock_noinstr+0x8/0x10
> > >> [    0.751119][    T0]  ? local_clock_noinstr+0x137/0x140
> > >> [    0.752089][    T0]  ? kvm_sched_clock_read+0xd/0x20
> > >> [    0.753023][    T0]  alloc_slab_page+0xda/0x150
> > >> [    0.753879][    T0]  new_slab+0xe1/0x500
> > >> [    0.754615][    T0]  ? kvm_sched_clock_read+0xd/0x20
> > >> [    0.755577][    T0]  ___slab_alloc+0xd79/0x1680
> > >> [    0.756469][    T0]  ? pcpu_alloc_noprof+0x538/0x800
> > >> [    0.757408][    T0]  ? __mutex_unlock_slowpath+0x195/0x3e0
> > >> [    0.758446][    T0]  __slab_alloc+0x4e/0x70
> > >> [    0.759237][    T0]  ? mm_alloc+0x38/0x80
> > >> [    0.759993][    T0]  kmem_cache_alloc_noprof+0x1db/0x470
> > >> [    0.760993][    T0]  ? mm_alloc+0x38/0x80
> > >> [    0.761745][    T0]  ? mm_alloc+0x38/0x80
> > >> [    0.762506][    T0]  mm_alloc+0x38/0x80
> > >> [    0.763260][    T0]  poking_init+0xe/0x80
> > >> [    0.764032][    T0]  start_kernel+0x16b/0x470
> > >> [    0.764858][    T0]  i386_start_kernel+0xce/0xf0
> > >> [    0.765723][    T0]  startup_32_smp+0x151/0x160
> > >>
> > >> And the reason is we still have restricted gfp_allowed_mask at this =
point:
> > >> /* The GFP flags allowed during early boot */
> > >> #define GFP_BOOT_MASK (__GFP_BITS_MASK & ~(__GFP_RECLAIM|__GFP_IO|__=
GFP_FS))
> > >>
> > >> It's only lifted to a full allowed mask later in the boot.
> > >
> > > Ohh. That's interesting.
> > >
> > >> That means due to "kmalloc_nolock() is not supported on architecture=
s that
> > >> don't implement cmpxchg16b" such architectures will no longer get ob=
jexts
> > >> allocated in early boot. I guess that's not a big deal.
> > >>
> > >> Also any later allocation having its flags screwed for some reason t=
o not
> > >> have __GFP_RECLAIM will also lose its objexts. Hope that's also acce=
ptable.
> > >> I don't know if we can distinguish a real kmalloc_nolock() scope in
> > >> alloc_slab_obj_exts() without inventing new gfp flags or passing an =
extra
> > >> argument through several layers of functions.
> > >
> > > I think it's ok-ish.
> > > Can we add a check to alloc_slab_obj_exts() that sets allow_spin=3Dtr=
ue
> > > if we're in the boot phase? Like:
> > > if (gfp_allowed_mask !=3D __GFP_BITS_MASK)
> > >    allow_spin =3D true;
> > > or some cleaner way to detect boot time by checking slab_state ?
> > > bpf is not active during the boot and nothing should be
> > > calling kmalloc_nolock.
> >
> > Checking the gfp_allowed_mask should work. Slab state is already UP so =
won't
> > help, and this is not really about slab state anyway.
> > But whether worth it... Suren what do you think?
>
> Vlastimil's fix is correct. We definitely need __GFP_NO_OBJ_EXT when
> allocating an obj_exts vector, otherwise it will try to recursively
> allocate an obj_exts vector for obj_exts allocation.
>
> For the additional __GFP_BITS_MASK check, that sounds good to me as
> long as we add a comment on why that is there. Or maybe such a check
> deserves to be placed in a separate function similar to
> gfpflags_allow_{spinning | blocking}?

I would not. I think adding 'boot or not' logic to these two
will muddy the waters and will make the whole slab/page_alloc/memcg
logic and dependencies between them much harder to follow.
I'd either add a comment to alloc_slab_obj_exts() explaining
what may happen or add 'boot or not' check only there.
imo this is a niche, rare and special.

