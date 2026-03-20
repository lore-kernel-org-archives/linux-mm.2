Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A52051093170
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AAB36B0429; Thu, 19 Mar 2026 22:14:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B186B042D; Thu, 19 Mar 2026 22:14:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 022FE6B042E; Thu, 19 Mar 2026 22:14:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD39A6B0429
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:14:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D0A5140845
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:14:52 +0000 (UTC)
X-FDA: 84564823224.25.6D15D64
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 55D50180003
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:14:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QEIaopPI;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773972890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJKfKVTIofveAtRGzsSLDDFDiXEsfPWCcqVglT8BXkE=;
	b=RbxFAcdDVB8plOuEddavR+Fh4ZasCGRuicDEqCpLcuUYBL+CXtvjiDBL5NvR8pX7hWDz31
	0H/wOsxBf46nqMOgxMsPkT2ULttYhgqjZOIPv/6bSrK/Jr1JBsKAuBAQ/DHCabaJos9YRB
	bC4go+eOdAGmHTN6MGGTfyvrLZZ68TQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773972890; a=rsa-sha256;
	cv=pass;
	b=eDEuA5KKFwQYLedxhd9oVTwRFYJUe9i1lWLNWTIWQF7baHfrZoKAxZY45Q4QSNKRzJ9ZoX
	nt1mQvpGl/BVc02ao2MNmJ2UhzrGCrT6WemIfCrvZSyev+U10hwqWRCU0hJ3bSAVlTREmX
	tsFsAZkU2ujLJ7/sIOPTqWFJHhjRVR8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QEIaopPI;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50b30d61be6so292011cf.0
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:14:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773972888; cv=none;
        d=google.com; s=arc-20240605;
        b=E6LaCl+WGR6rOSxicmRBMI4D/h5Dnof6t2/YydO6eu9i+aT6scUgJuAs80aYsFj0Gs
         SLB6p0AdcVAoDOgF8abiKOs2SQCs8KMZh9XIc7lrNu5tSS+kaXOwUAGanbkOOmwWsBmt
         OkbZGNTeBGlpnmGSNuQQHjouJfdZTzmLuGYay0jIG+5XurLn8Q2oN9RT7Mr5n7bw/ueo
         iAYPCbvkSfxPLzlFST1vzeMmDlA2DOer9ZVWpZPTIRpIdWrUmBpAYnbUj7I0VwMTiakj
         4GWzYu4J0S5LfFCVos6O2noBpUReNOODx7xEGu0IY0oGevHN2l7/elbqIOEqXhMLEd9B
         yHDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JJKfKVTIofveAtRGzsSLDDFDiXEsfPWCcqVglT8BXkE=;
        fh=nyroR3W7Rgn1S0Gl+seNYi1SJ8o0x2APWgY7WNoSGKE=;
        b=PqqfoLLB9cKAJsF4uzgclXJ0kMbTgTZZ0j2IYzKt4oY97lEIDf72y/VXKuhsf35Hpu
         hZ532DPwt4RsvE/j+4BNY7SrUwkcrBgfrzYHwoL+/H3eNkK6jLwzFIJdfRwhyXz99s6/
         L7q/warATI1F1N0S2GBnAzmXFo4Cuc3VfUcWDrXqfTQKRDjPVj1dbeqDrPk5WL8YAoC2
         6L28iB7c/syZkt0Er1TDXdOeHCoyLUsZPV+FuCQvKZjuocJqSNjqBQOphPubH8FBC5ZB
         YFLMrTgKwP/6ElCW7rFo8x9jFPPuqRfs4O7UgLC1N16gXegZafl2oNql+1ZtVO7FHPzh
         zypw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773972888; x=1774577688; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJKfKVTIofveAtRGzsSLDDFDiXEsfPWCcqVglT8BXkE=;
        b=QEIaopPImcX/3TBWHXXlLPC98hDa4mipvRTMNikUi3CNn3p5FIDHJZrlEqJxvV6mlw
         45fyR23XYAa6ubEpz7fcAi9LT2a2/7KrqEb9CmUWvPbzNc+JvHrd1+8w3FMLz4n2mysc
         A2SXdKoHB9kVii6hRSstSu+qli6zKZr0VgNFgwwsytWDchVs65qQYaWvHSBxRQIEFeHd
         tmPjQ9lswYIbGfxp6BhRDBBgmMHVv6l3WZj1rGngAfJApL6vJ9yc+6H7F6NXl6KJzXgN
         mk6M+IPnfnnQubW7FWkzmxQDFEBjni+ai0IYgj5wuDj1uijOCwKqzDUEv1+cza3gCWcK
         hZHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773972888; x=1774577688;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JJKfKVTIofveAtRGzsSLDDFDiXEsfPWCcqVglT8BXkE=;
        b=dIztqnbjSmyfW6nt+P+Biw2otHDaTBEE4URbOYSn6JB9+8Sfv9/iW+NW4QWwS6bu8o
         hbQVFR8btexherqfnXIa9vaJDYOPX9xXQah7MDQlqBnFZuTgBy9lN66tkgLx0Y8TA0wN
         5kHQ+XSQEbwTxt5hoJETUMHO5YAu5Jp7QgRYWSMEzFQDnlgITG/kEBPW76K3PNTONSra
         gO1lOThCbZxObaw7bwMM0H4N0ruWm/Pszc3Gm442x41wjWpY/wT8+nOCGfwJZRVkOsYm
         yKYM+p8kV7Oy8IYS28Uh3n+HlNmSudO5WOQxyFI1lF0UfLpgzIvSYimnRwLEoq/K+lwt
         Xe9g==
X-Forwarded-Encrypted: i=1; AJvYcCUtrGDnZYLiPshm2H7LCW21oHjaC5YPLpY1QtJaSpE6xcWKfKt6yFlFua/w9n2MxWDEqsI2PCI6fg==@kvack.org
X-Gm-Message-State: AOJu0Yzihh/gWPZlsdC+9fEsG8OLLToAW3FqLGJ2vyaErp7DhyjgpQgt
	3rzmDEisSckzSMX/fFQLfE4XuLGB5cN4uqcZYS2Cv6W0tMV5VbIeLYiF50pR4qn5/n9rSoGyc2j
	SBz9PgT9vK09t8P0g3SZO7JybPY5Ualc3PSRqZ+cY
X-Gm-Gg: ATEYQzyKsRA/c1KCvF2Xd8vPvVZDwZibblhedrRHPiZEhiq9cc2XZAUOdVjIrPQjY0Q
	GPRqtgKi9As1eYEaLr0kYiWyFuksxM/xEHTJ2HpV07xz3aBIDsxGdcwd5yL+adLwCmJKY9V8X03
	bR93H53Fu2XCPwZ3Kt7v5mZ1cimSuljSvEnEdGYEauXk8fqHxNRskN5DRhMDFINTqKN9eZx7W6Y
	a6Dw0pCzE7ogHqkBVD5wXpCkgUd+38N2hUml3EmMpu/GemH6luYfPSvvhWElwgWNc0erbL1YbbP
	cs+IBA==
X-Received: by 2002:a05:622a:1f99:b0:509:72a:ae59 with SMTP id
 d75a77b69052e-50b372d9357mr8472921cf.10.1773972887803; Thu, 19 Mar 2026
 19:14:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260319083153.2488005-1-hao.ge@linux.dev> <20260319152808.fce61386fdf2934d7a3b0edb@linux-foundation.org>
 <CAJuCfpG5OG66mgfn3ez5ZXTjj7VC8yuK3L2u83uOZhyBbRH2Lw@mail.gmail.com>
 <CAJuCfpHD4SB30oP7Bdm=ey+2W7CAsFPruedEbqgR5OumrQErxQ@mail.gmail.com> <9ef1c798-a30f-4458-9684-900136ae8b7d@linux.dev>
In-Reply-To: <9ef1c798-a30f-4458-9684-900136ae8b7d@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 19 Mar 2026 19:14:36 -0700
X-Gm-Features: AaiRm50YpHm2Mc7old8k-AwUIbAkgnNU2rtGWnIT-LsVc4ZEf0J6WuUy_ArPOko
Message-ID: <CAJuCfpEt1EwS4_kiTbger7sBGFKKhi+6PBjrYrTK1HEJzxOTGg@mail.gmail.com>
Subject: Re: [PATCH] mm/alloc_tag: clear codetag for pages allocated before
 page_ext initialization
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 55D50180003
X-Stat-Signature: 97as1r94uhq43h7fngfc863ti85e65yb
X-Rspam-User: 
X-HE-Tag: 1773972890-961137
X-HE-Meta: U2FsdGVkX1/KIgbxfM9lkc8UOzKaY69tk8LQqoy7zr29Pse6kaJrYY1ETYpO91+rlAizcu1wWB3vrEqoqC0a4+xa55z64MlvnWkvBoofM7TxuG2E1FoSk2nkRzokbmTrthFxzE/4Uxo0FsZFq6DWkTFX8Jcjxfo+1Fo+PtNgnsA6WDjGTgcV/WZV5u4PI9ektZpwLDPnfKv3MIXFGd5KwlafsgDYJltWy2FcsoRfh6u7Q9RDbkZwDrRH5lQ0TezBG7w23/g67N/u8DsuntZ9icQtjtxqbtb34+bLEWBxIG1gSTXGSA1OADwiRYZDhz0Sjj1TkIRBkCQyrzXzRJCxmAWc8rpVjoVUysu31acIrq3VXDBCUgp7TwBNpzwmq9Bj6YpqP0IQvEont/wb53KlOBlD45/HxuptvJl3noU+CWQM+sL4hBYfeEZF41CjMBJkOFa5t6VErPGWqC0KDhaSXTM3v0FKJp+Q/HooFEuEu1FlpYT2JABUvypGhvjmB4rE96v7d4FslZ3O42udzZFTZ6TRo50SGPzJa4ERRbj0ZctVZCim6jj1fWuEAyj+ivrDNs238E1EwGQAz5sV8b61nOuksdtXymeeNt8Aei+AsMg8u7BBoVTQv05psxRmHaquR7xDyCafnO9b10CayLxZLrFYrrErJV3G0GQxxxPn4sdTPr2wT939NsLGRxBujPZzs27bKVoFmNXCcyn7yZ0HgpSUGy3uruU2SC9D4wPICQyVyDqVl0wMQZiBeitNiMoRKpsuez146Pjg2sRmc+aMZEBAd3VFNE22zxAW6K7D31ILOtpnodkWGEhZvEwQbGMEGN1SLirqiqgg1u06QWLBbKK4UL4+2NbX5an2kmQvAh+6C6oPAynL9ytlwv5t5e2a9YzSSPfqN5MsDN4rjH79VS74rqHwsARQc4S+Bzq6XSDUy2tgtEfb1FczPyqF/DtwZoMBgV8GSpneRglKFTy
 +UbkZ6UZ
 ERxGYEaNgzpnhFto46FCGtvN3zBB8SceyG4biHFF4w5HjoJVHoqnzdAhXl/dNEsgGa4bzknk7x12yESAMVjiDZtL4m6TylOK5tlIqNEaJXRg6ndNUD30c3x2trbv4ucw0tpGIvMLXsR3vSheTXXud7OzePHWZ5a20QFLDp5YPd9l4h4biqRO7sdAcMZs07iewtuxUHJrwChZes9w3jgQhD+AA9ChOa6vFCTb3Nm6tyJ/iYQYttLuOFhGe3ycfeycEzWj+D+LUgSWO7zwznThd0ug8Jt7UFM863r244rHfz3o9VZ2zZvZUa6/iHC2RrLMMKecTtRmKo7H6v9o0Sjv6RxtY/q+6Gw/8Y6dgx7nPtIr5GwxVW2JNZMR7lusRhi/gnTsWdlKMWGvMNRviibo9mDt7WSOLm706/w8gWAPE3Wv0WWo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 6:58=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
>
> On 2026/3/20 07:48, Suren Baghdasaryan wrote:
> > On Thu, Mar 19, 2026 at 4:44=E2=80=AFPM Suren Baghdasaryan <surenb@goog=
le.com> wrote:
> >> On Thu, Mar 19, 2026 at 3:28=E2=80=AFPM Andrew Morton <akpm@linux-foun=
dation.org> wrote:
> >>> On Thu, 19 Mar 2026 16:31:53 +0800 Hao Ge <hao.ge@linux.dev> wrote:
> >>>
> >>>> Due to initialization ordering, page_ext is allocated and initialize=
d
> >>>> relatively late during boot. Some pages have already been allocated
> >>>> and freed before page_ext becomes available, leaving their codetag
> >>>> uninitialized.
> >> Hi Hao,
> >> Thanks for the report.
> >> Hmm. So, we are allocating pages before page_ext is initialized...
> >>
> >>>> A clear example is in init_section_page_ext(): alloc_page_ext() call=
s
> >>>> kmemleak_alloc().
> > Forgot to ask. The example you are using here is for page_ext
> > allocation itself. Do you have any other examples where page
> > allocation happens before page_ext initialization? If that's the only
> > place, then we might be able to fix this in a simpler way by doing
> > something special for alloc_page_ext().
>
> Hi Suren
>
> To help illustrate the point, here's the debug log I added:
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2d4b6f1a554e..ebfe636f5b07 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1293,6 +1293,9 @@ void __pgalloc_tag_add(struct page *page, struct
> task_struct *task,
>                  alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
>                  update_page_tag_ref(handle, &ref);
>                  put_page_tag_ref(handle);
> +       } else {
> +               pr_warn("__pgalloc_tag_add: get_page_tag_ref failed!
> page=3D%p pfn=3D%lu nr=3D%u\n", page, page_to_pfn(page), nr);
> +               dump_stack();
>          }
>   }
>
>
> And I caught the following logs:
>
> [    0.296399] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea000400c700 pfn=3D1049372 nr=3D1
> [    0.296400] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted
> 7.0.0-rc4-dirty #12 PREEMPT(lazy)
> [    0.296402] Hardware name: Red Hat KVM, BIOS
> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> [    0.296402] Call Trace:
> [    0.296403]  <TASK>
> [    0.296403]  dump_stack_lvl+0x53/0x70
> [    0.296405]  __pgalloc_tag_add+0x3a3/0x6e0
> [    0.296406]  ? __pfx___pgalloc_tag_add+0x10/0x10
> [    0.296407]  ? kasan_unpoison+0x27/0x60
> [    0.296409]  ? __kasan_unpoison_pages+0x2c/0x40
> [    0.296411]  get_page_from_freelist+0xa54/0x1310
> [    0.296413]  __alloc_frozen_pages_noprof+0x206/0x4c0
> [    0.296415]  ? __pfx___alloc_frozen_pages_noprof+0x10/0x10
> [    0.296417]  ? stack_depot_save_flags+0x3f/0x680
> [    0.296418]  ? ___slab_alloc+0x518/0x530
> [    0.296420]  alloc_pages_mpol+0x13a/0x3f0
> [    0.296421]  ? __pfx_alloc_pages_mpol+0x10/0x10
> [    0.296423]  ? _raw_spin_lock_irqsave+0x8a/0xf0
> [    0.296424]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
> [    0.296426]  alloc_slab_page+0xc2/0x130
> [    0.296427]  allocate_slab+0x77/0x2c0
> [    0.296429]  ? syscall_enter_define_fields+0x3bb/0x5f0
> [    0.296430]  ___slab_alloc+0x125/0x530
> [    0.296432]  ? __trace_define_field+0x252/0x3d0
> [    0.296433]  __kmalloc_noprof+0x329/0x630
> [    0.296435]  ? syscall_enter_define_fields+0x3bb/0x5f0
> [    0.296436]  syscall_enter_define_fields+0x3bb/0x5f0
> [    0.296438]  ? __pfx_syscall_enter_define_fields+0x10/0x10
> [    0.296440]  event_define_fields+0x326/0x540
> [    0.296441]  __trace_early_add_events+0xac/0x3c0
> [    0.296443]  trace_event_init+0x24c/0x460
> [    0.296445]  trace_init+0x9/0x20
> [    0.296446]  start_kernel+0x199/0x3c0
> [    0.296448]  x86_64_start_reservations+0x18/0x30
> [    0.296449]  x86_64_start_kernel+0xe2/0xf0
> [    0.296451]  common_startup_64+0x13e/0x141
> [    0.296453]  </TASK>
>
>
> [    0.312234] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea000400f900 pfn=3D1049572 nr=3D1
> [    0.312234] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted
> 7.0.0-rc4-dirty #12 PREEMPT(lazy)
> [    0.312236] Hardware name: Red Hat KVM, BIOS
> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> [    0.312236] Call Trace:
> [    0.312237]  <TASK>
> [    0.312237]  dump_stack_lvl+0x53/0x70
> [    0.312239]  __pgalloc_tag_add+0x3a3/0x6e0
> [    0.312240]  ? __pfx___pgalloc_tag_add+0x10/0x10
> [    0.312241]  ? rmqueue.constprop.0+0x4fc/0x1ce0
> [    0.312243]  ? kasan_unpoison+0x27/0x60
> [    0.312244]  ? __kasan_unpoison_pages+0x2c/0x40
> [    0.312246]  get_page_from_freelist+0xa54/0x1310
> [    0.312248]  __alloc_frozen_pages_noprof+0x206/0x4c0
> [    0.312250]  ? __pfx___alloc_frozen_pages_noprof+0x10/0x10
> [    0.312253]  alloc_slab_page+0x39/0x130
> [    0.312254]  allocate_slab+0x77/0x2c0
> [    0.312255]  ? alloc_cpumask_var_node+0xc7/0x230
> [    0.312257]  ___slab_alloc+0x46d/0x530
> [    0.312259]  __kmalloc_node_noprof+0x2fa/0x680
> [    0.312261]  ? alloc_cpumask_var_node+0xc7/0x230
> [    0.312263]  alloc_cpumask_var_node+0xc7/0x230
> [    0.312264]  init_desc+0x141/0x6b0
> [    0.312266]  alloc_desc+0x108/0x1b0
> [    0.312267]  early_irq_init+0xee/0x1c0
> [    0.312268]  ? __pfx_early_irq_init+0x10/0x10
> [    0.312271]  start_kernel+0x1ab/0x3c0
> [    0.312272]  x86_64_start_reservations+0x18/0x30
> [    0.312274]  x86_64_start_kernel+0xe2/0xf0
> [    0.312275]  common_startup_64+0x13e/0x141
> [    0.312277]  </TASK>
>
> [    0.312834] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea000400fc00 pfn=3D1049584 nr=3D1
> [    0.312835] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted
> 7.0.0-rc4-dirty #12 PREEMPT(lazy)
> [    0.312836] Hardware name: Red Hat KVM, BIOS
> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> [    0.312837] Call Trace:
> [    0.312837]  <TASK>
> [    0.312838]  dump_stack_lvl+0x53/0x70
> [    0.312840]  __pgalloc_tag_add+0x3a3/0x6e0
> [    0.312841]  ? __pfx___pgalloc_tag_add+0x10/0x10
> [    0.312842]  ? rmqueue.constprop.0+0x4fc/0x1ce0
> [    0.312844]  ? kasan_unpoison+0x27/0x60
> [    0.312845]  ? __kasan_unpoison_pages+0x2c/0x40
> [    0.312847]  get_page_from_freelist+0xa54/0x1310
> [    0.312849]  __alloc_frozen_pages_noprof+0x206/0x4c0
> [    0.312851]  ? __pfx___alloc_frozen_pages_noprof+0x10/0x10
> [    0.312853]  alloc_pages_mpol+0x13a/0x3f0
> [    0.312855]  ? __pfx_alloc_pages_mpol+0x10/0x10
> [    0.312856]  ? xas_find+0x2d8/0x450
> [    0.312858]  ? _raw_spin_lock+0x84/0xe0
> [    0.312859]  ? __pfx__raw_spin_lock+0x10/0x10
> [    0.312861]  alloc_pages_noprof+0xf6/0x2b0
> [    0.312862]  __change_page_attr+0x293/0x850
> [    0.312864]  ? __pfx___change_page_attr+0x10/0x10
> [    0.312865]  ? _vm_unmap_aliases+0x2d0/0x650
> [    0.312868]  ? __pfx__vm_unmap_aliases+0x10/0x10
> [    0.312869]  __change_page_attr_set_clr+0x16c/0x360
> [    0.312871]  ? spp_getpage+0xbb/0x1e0
> [    0.312872]  change_page_attr_set_clr+0x220/0x3c0
> [    0.312873]  ? flush_tlb_one_kernel+0xf/0x30
> [    0.312875]  ? set_pte_vaddr_p4d+0x110/0x180
> [    0.312877]  ? __pfx_change_page_attr_set_clr+0x10/0x10
> [    0.312878]  ? __pfx_set_pte_vaddr_p4d+0x10/0x10
> [    0.312881]  ? __pfx_mtree_load+0x10/0x10
> [    0.312883]  ? __pfx_mtree_load+0x10/0x10
> [    0.312884]  ? __asan_memcpy+0x3c/0x60
> [    0.312886]  ? set_intr_gate+0x10c/0x150
> [    0.312888]  set_memory_ro+0x76/0xa0
> [    0.312889]  ? __pfx_set_memory_ro+0x10/0x10
> [    0.312891]  idt_setup_apic_and_irq_gates+0x2c1/0x390
>
> and more.

Ok, it's not the only place. Got your point.

>
> off topic -  if we were to handle only alloc_page_ext() specifically,
> what would be the most straightforward
>
> solution in your mind? I'd really appreciate your insight.

I was thinking if it's the only special case maybe we can handle it
somehow differently, like we do when we allocate obj_ext vectors for
slabs using __GFP_NO_OBJ_EXT. I haven't found a good solution yet but
since it's not a special case we would not be able to use it even if I
came up with something...
I think your way is the most straight-forward but please try my
suggestion to see if we can avoid extra overhead.
Thanks,
Suren.

>
> Thanks.
>
>
> >>>> If the slab cache has no free objects, it falls back
> >>>> to the buddy allocator to allocate memory. However, at this point pa=
ge_ext
> >>>> is not yet fully initialized, so these newly allocated pages have no
> >>>> codetag set. These pages may later be reclaimed by KASAN,which cause=
s
> >>>> the warning to trigger when they are freed because their codetag ref=
 is
> >>>> still empty.
> >>>>
> >>>> Use a global array to track pages allocated before page_ext is fully
> >>>> initialized, similar to how kmemleak tracks early allocations.
> >>>> When page_ext initialization completes, set their codetag
> >>>> to empty to avoid warnings when they are freed later.
> >>>>
> >>>> ...
> >>>>
> >>>> --- a/include/linux/alloc_tag.h
> >>>> +++ b/include/linux/alloc_tag.h
> >>>> @@ -74,6 +74,9 @@ static inline void set_codetag_empty(union codetag=
_ref *ref)
> >>>>
> >>>>   #ifdef CONFIG_MEM_ALLOC_PROFILING
> >>>>
> >>>> +bool mem_profiling_is_available(void);
> >>>> +void alloc_tag_add_early_pfn(unsigned long pfn);
> >>>> +
> >>>>   #define ALLOC_TAG_SECTION_NAME       "alloc_tags"
> >>>>
> >>>>   struct codetag_bytes {
> >>>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> >>>> index 58991ab09d84..a5bf4e72c154 100644
> >>>> --- a/lib/alloc_tag.c
> >>>> +++ b/lib/alloc_tag.c
> >>>> @@ -6,6 +6,7 @@
> >>>>   #include <linux/kallsyms.h>
> >>>>   #include <linux/module.h>
> >>>>   #include <linux/page_ext.h>
> >>>> +#include <linux/pgalloc_tag.h>
> >>>>   #include <linux/proc_fs.h>
> >>>>   #include <linux/seq_buf.h>
> >>>>   #include <linux/seq_file.h>
> >>>> @@ -26,6 +27,82 @@ static bool mem_profiling_support;
> >>>>
> >>>>   static struct codetag_type *alloc_tag_cttype;
> >>>>
> >>>> +/*
> >>>> + * State of the alloc_tag
> >>>> + *
> >>>> + * This is used to describe the states of the alloc_tag during boot=
up.
> >>>> + *
> >>>> + * When we need to allocate page_ext to store codetag, we face an
> >>>> + * initialization timing problem:
> >>>> + *
> >>>> + * Due to initialization order, pages may be allocated via buddy sy=
stem
> >>>> + * before page_ext is fully allocated and initialized. Although the=
se
> >>>> + * pages call the allocation hooks, the codetag will not be set bec=
ause
> >>>> + * page_ext is not yet available.
> >>>> + *
> >>>> + * When these pages are later free to the buddy system, it triggers
> >>>> + * warnings because their codetag is actually empty if
> >>>> + * CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled.
> >>>> + *
> >>>> + * Additionally, in this situation, we cannot record detailed alloc=
ation
> >>>> + * information for these pages.
> >>>> + */
> >>>> +enum mem_profiling_state {
> >>>> +     DOWN,                   /* No mem_profiling functionality yet =
*/
> >>>> +     UP                      /* Everything is working */
> >>>> +};
> >>>> +
> >>>> +static enum mem_profiling_state mem_profiling_state =3D DOWN;
> >>>> +
> >>>> +bool mem_profiling_is_available(void)
> >>>> +{
> >>>> +     return mem_profiling_state =3D=3D UP;
> >>>> +}
> >>>> +
> >>>> +#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
> >>>> +
> >>>> +#define EARLY_ALLOC_PFN_MAX          256
> >>>> +
> >>>> +static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX];
> >>> It's unfortunate that this isn't __initdata.
> >>>
> >>>> +static unsigned int early_pfn_count;
> >>>> +static DEFINE_SPINLOCK(early_pfn_lock);
> >>>> +
> >>>>
> >>>> ...
> >>>>
> >>>> --- a/mm/page_alloc.c
> >>>> +++ b/mm/page_alloc.c
> >>>> @@ -1293,6 +1293,13 @@ void __pgalloc_tag_add(struct page *page, str=
uct task_struct *task,
> >>>>                alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
> >>>>                update_page_tag_ref(handle, &ref);
> >>>>                put_page_tag_ref(handle);
> >>>> +     } else {
> >> This branch can be marked as "unlikely".
> >>
> >>>> +             /*
> >>>> +              * page_ext is not available yet, record the pfn so we=
 can
> >>>> +              * clear the tag ref later when page_ext is initialize=
d.
> >>>> +              */
> >>>> +             if (!mem_profiling_is_available())
> >>>> +                     alloc_tag_add_early_pfn(page_to_pfn(page));
> >>>>        }
> >>>>   }
> >>> All because of this, I believe.  Is this fixable?
> >>>
> >>> If we take that `else', we know we're running in __init code, yes?  I
> >>> don't see how `__init pgalloc_tag_add_early()' could be made to work.
> >>> hrm.  Something clever, please.
> >> We can have a pointer to a function that is initialized to point to
> >> alloc_tag_add_early_pfn, which is defined as __init and uses
> >> early_pfns which now can be defined as __initdata. After
> >> clear_early_alloc_pfn_tag_refs() is done we reset that pointer to
> >> NULL. __pgalloc_tag_add() instead of calling alloc_tag_add_early_pfn()
> >> directly checks that pointer and if it's not NULL then calls the
> >> function that it points to. This way __pgalloc_tag_add() which is not
> >> an __init function will be invoking alloc_tag_add_early_pfn() __init
> >> function only until we are done with initialization. I haven't tried
> >> this but I think that should work. This also eliminates the need for
> >> mem_profiling_state variable since we can use this function pointer
> >> instead.
> >>
> >>

