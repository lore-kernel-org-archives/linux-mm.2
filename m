Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2F35CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40FDF8E014E; Thu, 18 Sep 2025 10:49:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C01B8E013A; Thu, 18 Sep 2025 10:49:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D65E8E014E; Thu, 18 Sep 2025 10:49:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1578E013A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:49:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB5F31401FA
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:49:39 +0000 (UTC)
X-FDA: 83902654878.16.8FEB2E3
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id CBDDA140007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:49:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nVfiQFFB;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758206977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KvgqQMIRazqhTNds4nMPQal7ZSlIJweSzO/oPA+Hs2c=;
	b=ok3/j7WQ2jXrgdIwyzzMOzlCUFXPp4nsAYTH/9z7fvsxAHWoGsCCdxxtvrwl7aIobPxPha
	B/dS0PQ5dEuYMZfltXPZikK4NDxt7SYyh6q0zbRDcTP+I5d0POxmqnkEHY5E4DCwRPtOJF
	9zyHyRTvZQIFcrVcN2Z0U60hJ3DoT7U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758206977; a=rsa-sha256;
	cv=none;
	b=ampqoh2EB/Wlgihi5dn5uMkGIqISBqLdMBXWvo5tlK78HwZ/zoADTqRWuC5QiPWPAm4k9D
	TmD5HEeLAi+F6Vz5m8sqj4Ws0NONtwqqPSzhfEq/Daoz76SPHgzIXNuxWbtGQVrHdhLTbq
	ZUOXLbLr2n8o/mCX2wvBj0Toz5903/g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nVfiQFFB;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b4bcb9638aso434581cf.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758206977; x=1758811777; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KvgqQMIRazqhTNds4nMPQal7ZSlIJweSzO/oPA+Hs2c=;
        b=nVfiQFFBxfApXFigbRAU6ze9tC0vR5xlZaA3jlnn1yeH9hqnauABO4BqIMxK7Ww4F7
         UmKUMmrlYlehR1EC3qlZ7TVqshyFXzmfA1uj7ZrcWTUv6p7OX6+RUuuvMSawyItqEgNN
         uho/JoGNHxzwhUuIhZSAcOM+8LZCu+8Qc2pwIacU/G7hJX7GqFpDXjgsDyAykC7Mfs/2
         rImEAUez0mr9e/XO3tyFJazxxl0z3lzP9du9hMf1dBHa5SroxNjvae6NXGAGhAY+Ps6k
         1ojh4DkH/PEwJV8J3JSa8ZC75sh8Iq72MlB/03apwW42cvlAwRri/3tzCXS+6BVCi5SO
         LneA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758206977; x=1758811777;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KvgqQMIRazqhTNds4nMPQal7ZSlIJweSzO/oPA+Hs2c=;
        b=kXmv6OJbmW/6oykJZ7v6bMkbuC+1AM03baFeaC3dHACS7K0+ZOafc2saboShOZK5kS
         5Uv3O4zoK2YzXkWLdCXBEx9Smy/yhCXHjHt8/U631E+yS6Cj8vbEq3hSLay6CKcHZd58
         jHvn8HejQkW1RHK8ppk1PD3pvkdXtrBUslTKX7qPFYP8hN15ox2hAcjNPArvklgyuorl
         LOdq8zUTgpj3AnemZbwhdunxStNwmLJep/kcZjn99i6GgGOUNidvun6JT8G6e7ZtBukS
         PjobMd5yNIrYesu7YTiMaqxfu9qUm+L1Vg4H9jjL+P6UdKDTFA2Kgwd6dSrWCv8xhK7y
         3M2g==
X-Forwarded-Encrypted: i=1; AJvYcCWqXTfsVzgtLRGQIRN/TRqKwqTUdCQwDx+gGUhevmOkCaiSz7LyLciy0eQ3Dd9IWUeD3x4qSijSlw==@kvack.org
X-Gm-Message-State: AOJu0YzcBMZ6WPD0TQ5UTPCw8Vn3pVW2JH6fFmgJ9cSj/CqcmW970Sog
	0JnXQXMaBH6nVt/c7KSVAc1H1rncr14sr2jL6HNpUYExn9/vfY50xYQYpWPePEwD9A7brqBghEr
	z5T5WlFC+FF6xZIdyzli/DzJIZKs6UNnWN0PqktWA
X-Gm-Gg: ASbGncvJfIkzY6yLbHD9y+ATPIqOITVeqt2iPs4jm4esvzL9WqdDtlnBwQuQwtAi9a3
	IERz13kSESIZO7/2hkYL8ukeiyzoYKVatOsUdBd16g57CA0efBwGKHpQP7jGKZMAlPZvDkND/lB
	TApRGjbBnYA36w2oLPlL+cv8qYaxkhI/PX9duDk2eA18j/WA0WKmqnf15oNCm8bRHCizSgrIRfW
	kJnbNoTkiVst2sNoDBznnKiiOeNQCDsHQ8U+tOAxnkUKYOmc/Jv37fvygksqAE=
X-Google-Smtp-Source: AGHT+IE3vt5RgQAoZi6woEVABoOhvcwZJraj4zZpjNZVZ8uWgSgQ2w/k0DQPdvldDL/0AUskfnLbq+byz8vkiHdvA2A=
X-Received: by 2002:a05:622a:118c:b0:4b3:50ee:579e with SMTP id
 d75a77b69052e-4ba2dbd8d7amr13425281cf.11.1758206976508; Thu, 18 Sep 2025
 07:49:36 -0700 (PDT)
MIME-Version: 1.0
References: <202509171214.912d5ac-lkp@intel.com> <b7d4cf85-5c81-41e0-9b22-baa9a7e5a0c4@suse.cz>
 <ead41e07-c476-4769-aeb6-5a9950737b98@suse.cz> <CAADnVQJYn9=GBZifobKzME-bJgrvbn=OtQJLbU+9xoyO69L8OA@mail.gmail.com>
 <ce3be467-4ff3-4165-a024-d6a3ed33ad0e@suse.cz>
In-Reply-To: <ce3be467-4ff3-4165-a024-d6a3ed33ad0e@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 18 Sep 2025 07:49:25 -0700
X-Gm-Features: AS18NWBKqEKLWVuQ980Fh7DdopBdRtw6yIZtBXo-Y59z15HRkGH_vRxj6TN4pFk
Message-ID: <CAJuCfpGLhJtO02V-Y+qmvzOqO2tH5+u7EzrCOA1K-57vPXhb+g@mail.gmail.com>
Subject: Re: [linux-next:master] [slab] db93cdd664: BUG:kernel_NULL_pointer_dereference,address
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, kernel test robot <oliver.sang@intel.com>, 
	Alexei Starovoitov <ast@kernel.org>, Harry Yoo <harry.yoo@oracle.com>, oe-lkp@lists.linux.dev, 
	kbuild test robot <lkp@intel.com>, kasan-dev <kasan-dev@googlegroups.com>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CBDDA140007
X-Stat-Signature: u9mtpfjpmrnw1zc46s66efcx1j3hqc1d
X-Rspam-User: 
X-HE-Tag: 1758206977-572103
X-HE-Meta: U2FsdGVkX1+h1ofsopGR7wYXe8Yq9+iPufkktM3BzL808WBlaWVF4Qsj/P7we1wawj9+2lRwMCMafZ9+3MDfjU+Vw7c7vfVmd6fYmfm4uPXqRaWK+YlcyCYdD33oG7fu2gpGtqq2N8fHGdTAAhn37GYw6052orJWHuQkcXUjlsShB1XKjLwbwxnaAJ5sJb9mpJ8H3KlgxbtXp0l2sIwd3exqS/TuUhmlMi6pF1TEII5Fy8w9+aVh1fSCCvKIYfpsNEhyGIHfbpc6MEsT3uENVLuuoQZpewEiD1QehGC1+Z2PgJ0zl4hgJxvJlNCl5h+U+im9dK9cPLKQ7fmMRHqKGHSyScWZJqDONDS5IZhG4CWOl1GVPMVyexBYQZLsGMS+lIi7MbnJ1mYDQWDdiRuOkWDYGiOSiZ8pgnv1iQJ+gzTK4nglEcL16Er2K4KHbmrFBO05EIM6JPHFUVldtX6B+X2XSiMbLfpSqKQFa57aGTnfwJ1O++P5a3UnEchGwIn4W5jKwa7D2cn/U3WpvcdL1dt7OCd5nWXO8NBAMEOK8Bylg2m9TxczkjhfT2710axYExorMcAusYbPAwQ016E6FBFzV/nvZJxBZGxB11CkgetPO7IHgyy+0UkQ9WOYI6o0DV0npGz+tYpu+3PWURiWqlnyw+VVbgQ83GuhzmKqgECAD5O6A3rHThJ/uHrFEqvtMR1hyl06tpQ7hlHbgMWgw2mZ4GCjMA9rNASjXIrT9yYA2Pu4aQHhwtayxt2lBTklWF2NYWh2FkIgYuHINSVwYkcpLpCaTPCxAYfKNhtgBnUE4KaTuq4bGYL3IUsNcc4Kobba1vcVdrNI6stE0fDmbHBYi3lzvM+iJGPOzZr8LdMyFlTPgjiOD44J3+UZ4ayQBpEDAvNk6XkFjskIOymy427MFNts0eiBfgyO+wD3agxgwp+OGKjNH4nSJV1XqvC6fq+0gV3s0OGX9pVJzIl
 B+gkATPq
 DWxHGidISsL8NVj4tUmgHyCAWJ9WzK5B3638NfDgO+ZykFNh5MLaE5T0MSk/lgFel2zBrQqiZF3TOE1znrg5+IJqqNoTP8DCNSnyIF2ZglEGjMsm3fUl3Ew1wgDoXFiH2CaaW3WvfxBupHz9u5GdNKla2Qk0Cu3ks2sStOHIibBXdpJHkNjLVbZQoLQqnAL57LCxbJfdWL6jtkkBEwvTVuTrJ8XjcQXVkU1cCX1YswmSRGxQbmCT1CDMlHi1zXNlCyKdvUq5D7r8oX+M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 12:06=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> On 9/17/25 20:38, Alexei Starovoitov wrote:
> > On Wed, Sep 17, 2025 at 2:18=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> >>
> >> Also I was curious to find out which path is triggered so I've put a
> >> dump_stack() before the kmalloc_nolock call:
> >>
> >> [    0.731812][    T0] Call Trace:
> >> [    0.732406][    T0]  __dump_stack+0x18/0x30
> >> [    0.733200][    T0]  dump_stack_lvl+0x32/0x90
> >> [    0.734037][    T0]  dump_stack+0xd/0x20
> >> [    0.734780][    T0]  alloc_slab_obj_exts+0x181/0x1f0
> >> [    0.735862][    T0]  __alloc_tagging_slab_alloc_hook+0xd1/0x330
> >> [    0.736988][    T0]  ? __slab_alloc+0x4e/0x70
> >> [    0.737858][    T0]  ? __set_page_owner+0x167/0x280
> >> [    0.738774][    T0]  __kmalloc_cache_noprof+0x379/0x460
> >> [    0.739756][    T0]  ? depot_fetch_stack+0x164/0x180
> >> [    0.740687][    T0]  ? __set_page_owner+0x167/0x280
> >> [    0.741604][    T0]  __set_page_owner+0x167/0x280
> >> [    0.742503][    T0]  post_alloc_hook+0x17a/0x200
> >> [    0.743404][    T0]  get_page_from_freelist+0x13b3/0x16b0
> >> [    0.744427][    T0]  ? kvm_sched_clock_read+0xd/0x20
> >> [    0.745358][    T0]  ? kvm_sched_clock_read+0xd/0x20
> >> [    0.746290][    T0]  ? __next_zones_zonelist+0x26/0x60
> >> [    0.747265][    T0]  __alloc_frozen_pages_noprof+0x143/0x1080
> >> [    0.748358][    T0]  ? lock_acquire+0x8b/0x180
> >> [    0.749209][    T0]  ? pcpu_alloc_noprof+0x181/0x800
> >> [    0.750198][    T0]  ? sched_clock_noinstr+0x8/0x10
> >> [    0.751119][    T0]  ? local_clock_noinstr+0x137/0x140
> >> [    0.752089][    T0]  ? kvm_sched_clock_read+0xd/0x20
> >> [    0.753023][    T0]  alloc_slab_page+0xda/0x150
> >> [    0.753879][    T0]  new_slab+0xe1/0x500
> >> [    0.754615][    T0]  ? kvm_sched_clock_read+0xd/0x20
> >> [    0.755577][    T0]  ___slab_alloc+0xd79/0x1680
> >> [    0.756469][    T0]  ? pcpu_alloc_noprof+0x538/0x800
> >> [    0.757408][    T0]  ? __mutex_unlock_slowpath+0x195/0x3e0
> >> [    0.758446][    T0]  __slab_alloc+0x4e/0x70
> >> [    0.759237][    T0]  ? mm_alloc+0x38/0x80
> >> [    0.759993][    T0]  kmem_cache_alloc_noprof+0x1db/0x470
> >> [    0.760993][    T0]  ? mm_alloc+0x38/0x80
> >> [    0.761745][    T0]  ? mm_alloc+0x38/0x80
> >> [    0.762506][    T0]  mm_alloc+0x38/0x80
> >> [    0.763260][    T0]  poking_init+0xe/0x80
> >> [    0.764032][    T0]  start_kernel+0x16b/0x470
> >> [    0.764858][    T0]  i386_start_kernel+0xce/0xf0
> >> [    0.765723][    T0]  startup_32_smp+0x151/0x160
> >>
> >> And the reason is we still have restricted gfp_allowed_mask at this po=
int:
> >> /* The GFP flags allowed during early boot */
> >> #define GFP_BOOT_MASK (__GFP_BITS_MASK & ~(__GFP_RECLAIM|__GFP_IO|__GF=
P_FS))
> >>
> >> It's only lifted to a full allowed mask later in the boot.
> >
> > Ohh. That's interesting.
> >
> >> That means due to "kmalloc_nolock() is not supported on architectures =
that
> >> don't implement cmpxchg16b" such architectures will no longer get obje=
xts
> >> allocated in early boot. I guess that's not a big deal.
> >>
> >> Also any later allocation having its flags screwed for some reason to =
not
> >> have __GFP_RECLAIM will also lose its objexts. Hope that's also accept=
able.
> >> I don't know if we can distinguish a real kmalloc_nolock() scope in
> >> alloc_slab_obj_exts() without inventing new gfp flags or passing an ex=
tra
> >> argument through several layers of functions.
> >
> > I think it's ok-ish.
> > Can we add a check to alloc_slab_obj_exts() that sets allow_spin=3Dtrue
> > if we're in the boot phase? Like:
> > if (gfp_allowed_mask !=3D __GFP_BITS_MASK)
> >    allow_spin =3D true;
> > or some cleaner way to detect boot time by checking slab_state ?
> > bpf is not active during the boot and nothing should be
> > calling kmalloc_nolock.
>
> Checking the gfp_allowed_mask should work. Slab state is already UP so wo=
n't
> help, and this is not really about slab state anyway.
> But whether worth it... Suren what do you think?

Vlastimil's fix is correct. We definitely need __GFP_NO_OBJ_EXT when
allocating an obj_exts vector, otherwise it will try to recursively
allocate an obj_exts vector for obj_exts allocation.

For the additional __GFP_BITS_MASK check, that sounds good to me as
long as we add a comment on why that is there. Or maybe such a check
deserves to be placed in a separate function similar to
gfpflags_allow_{spinning | blocking}?

