Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC248F4613F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 22:47:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAA0F6B0088; Mon, 23 Mar 2026 18:47:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E817C6B0089; Mon, 23 Mar 2026 18:47:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D97246B008A; Mon, 23 Mar 2026 18:47:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3CA26B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:47:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 63E3B13C1C3
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 22:47:19 +0000 (UTC)
X-FDA: 84578815398.15.2CBD51F
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5288314000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 22:47:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NnW8GYBw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774306037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kSO0dbgCd7NWm7nN7aC4FMwWtdP2y0piwk4ZUzLKu8w=;
	b=aVveZ/esn+SsTEbOh1cSWD48HrJciPkQwzpatK8gkh57bHq0E5JjvdMPkz/IZ4ZJmrstG3
	mtyiAIJFz+pBmmv7RC3zQU6vfrVDwazpFTq9U746cmaDKBiHm5MRbVEowefcQSg5bhJikb
	PAfkg02EGn7A9xCFb500H14DphoMkoU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774306037; a=rsa-sha256;
	cv=pass;
	b=6v7isP1wAF9b01A+DOiik9vX7uw1yy1cm+JSrb9MT+c2gk/aAL9ymypj2vQSsrZ/HL1dri
	Bto1x0uWdMe19HFxZ1bl9sF09QITXERyqar/+5/x2fOVFxz0ib6LPUZd5yzv2IxupDk0/a
	f4TB1oYTgKoMZtBPSeSUlR1dQJ9x/Sw=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NnW8GYBw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-509062d829dso120101cf.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:47:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774306036; cv=none;
        d=google.com; s=arc-20240605;
        b=FjFdXI/ljdDZybR//0WR7kzbKEcpYObmiyHrsL2Z40gfMEKUHDv5heb94H3QfMpzRX
         jbs+uxsuwC7glDVAJgOWimyj4x33/5X7qASc8aet7A+O/aMU/pb52W4hZ1Ucm75uFjFx
         GioVbYXwEkPeJ9K3wQ+qVxIVCzPY6piHk+4k6hh0hjSb7zOwurTXY1rtfxUx304Wpw0A
         TcDBEAQYU2hNEUgluTjsHAWOkKZPkkqzCs6C1O3f6KhftNJizpxwv+WJe8OZI3mGkKAw
         H2BJs7eoAfvt5ayzBqXWGAi12faM1S2BNlhInucm9RSlKuum0vI/RVTEe5vnJRU53qGG
         zdqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kSO0dbgCd7NWm7nN7aC4FMwWtdP2y0piwk4ZUzLKu8w=;
        fh=othfTGOv3v2OYd/XGwg73VdZXvPuJ69p2hTpfzbZRFk=;
        b=SijFcrF0X8Ty4EH8SY7PMrNrjkyUCK8wfxlUflBX7iKfWRWbQzBdAgUcBxY2JhEfMK
         6OMT7GAZKL9GUHnL3BZjO/tkE0xoGZh/qhdwdC6+ijwB27+MsYjKnxQDlCGYfe3z5l6B
         n5CTTsTT7wp6j+1ruOBjBa6iM62815nUCzp5bAYvSVM2s3avSMKvrY47CpACYtvgzxj7
         D6myCDHhiwTsWt5joTNURiG8dOy6UcBpddcAicdfObGi7+ar9IVYlBUYmNPOF4Hi2QnP
         fMW9402Kl4jdRt88QEgpr1wShc7gu23bqU2DLiMkybzhwCeUhZoRwHw4dTbXIcDJqss0
         6noQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774306036; x=1774910836; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kSO0dbgCd7NWm7nN7aC4FMwWtdP2y0piwk4ZUzLKu8w=;
        b=NnW8GYBws+xLbbzE5OZgzIzoV2JcuOXszHmNUeKQks1y0TNQIDGgDHpW9bsGh2VeRo
         Ax88q6ZEXPzg1es3z6XA00m48JB1v6q99wU75UtkcjLYca5Oolik39hm4RzjKx6LKMIE
         lHSI1obLEvae7W//o8PUBBGCbp2mECwazRw1QPhGTFBZ7OnLTp+yhff6PTLtZ2airGxG
         xxtOdIzQkjUpe4hJj4E5SwMtLcKy+HIgyo0aAdln+N7yxxT/0P0cQZhjv70ix7RPzl51
         rRqw85U440IkINmdJNDwMmzzhqUqjXW48HJhQGxzfYglESFcuXqcPmT/TQlOR7MTwPj1
         3exg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774306036; x=1774910836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kSO0dbgCd7NWm7nN7aC4FMwWtdP2y0piwk4ZUzLKu8w=;
        b=k59swmVEkiAWAriTdx1UtjUzZETi0Gtr1lLFVIB/rHMFPz3ioHFtcVFxJ3Nau0l5Nx
         jLUii1ltlNTXFffkbrrNlpWYuLGww95qPH2dwPIemZc3A5SyrkQlHYQehRQjnaaRsofu
         FJuqzDV6t4rY56+GDNge4WmdpkiRbEsw9MucmAFcZPTN947dKVlWMaKWFoa8iCHdsKFv
         qUfWCiPVxDLiqB8ef0VDqPE0ihGD4kGMqBMRmW7GIYRoZIfP1wvVTrqfxq3gy5TmhrEU
         0DUh0OEsdwXEAf92P7cKPhPlgIHkMgGp6MO6W7K7Ken9UlFlZ9SKttnBUCvvou/lfpDl
         icaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcIEkBRTwrG0VOt3QjjxTL69cFxF506V5E6vJmNhYeeQ0AMFkWtjKLfMuxSPRtfbyqsAJm6J3Mtg==@kvack.org
X-Gm-Message-State: AOJu0YyxBiuuU7Ahp9jgncMRu6BA4O1gVrKTZJbu8P5yLioTYR5sF4zz
	Uh8Ljv2Mt0BXeJjRuS0E3470sFjlO7lNLLImrFNTVOeFevRn+dQzLOJxghPop7coHVHC/RQqdfG
	FDB8hmiBBl0ylPlluB+iGZhfkqvSutbgRmsHL1Z9wW0+YrqKBALzBUZN6IRg=
X-Gm-Gg: ATEYQzwFIQpACJIyUeWk9oWo2+5FPwCT7VbLxL7dUGp5GMcaSEoGpNKMK5do33KYNJQ
	qqqRIkKlBeklrR1XsjI8SJaPI291zLYy37IRnppkxvVYXrFXlfwPDCL9Dem9VC0fE/vGUdguu/3
	hA/15AWhOLb8K0NZZmLXMmkry96QxEB/sqEzzVk4GMcIR9/NA3InjJidVd0bG15MyF5GhrdbKGZ
	xgAqH/2ZoxOnBLQ2iVpEuR5/AeBwYoXMl3m6v4QyW+wNuro7Mn0t92WqiKQkHGfHPGzpHEdonHX
	B4K6yJYgrD20ZNGn
X-Received: by 2002:a05:622a:a10:b0:4fb:e3b0:aae6 with SMTP id
 d75a77b69052e-50b7146e437mr3072301cf.1.1774306035709; Mon, 23 Mar 2026
 15:47:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260319083153.2488005-1-hao.ge@linux.dev> <20260319152808.fce61386fdf2934d7a3b0edb@linux-foundation.org>
 <CAJuCfpG5OG66mgfn3ez5ZXTjj7VC8yuK3L2u83uOZhyBbRH2Lw@mail.gmail.com>
 <CAJuCfpHD4SB30oP7Bdm=ey+2W7CAsFPruedEbqgR5OumrQErxQ@mail.gmail.com>
 <9ef1c798-a30f-4458-9684-900136ae8b7d@linux.dev> <CAJuCfpEt1EwS4_kiTbger7sBGFKKhi+6PBjrYrTK1HEJzxOTGg@mail.gmail.com>
 <575e727e-cd47-41df-966a-142425aa8a8b@linux.dev>
In-Reply-To: <575e727e-cd47-41df-966a-142425aa8a8b@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 23 Mar 2026 15:47:04 -0700
X-Gm-Features: AQROBzA2HhPW4vL1eM8i1R5ROEO-QTjg_Z8suoFwsAObbEiVbhFqeKDPMYbe5xM
Message-ID: <CAJuCfpH4Wpv+jFOm2Xc3UOpn-vcEsJj6W0JJC=SJ2nkA=gEOWg@mail.gmail.com>
Subject: Re: [PATCH] mm/alloc_tag: clear codetag for pages allocated before
 page_ext initialization
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5288314000B
X-Stat-Signature: 3ue917h84677w364hzbza5g49gkyx4y5
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774306037-401308
X-HE-Meta: U2FsdGVkX1/3FLQMHI1rwbcfyukdne70Hs1giQoomCrFhiCDLdEUI+0ZJff+tHoELV4DFiN3RnvFYuZupmmQua6NurCMrYO0sbxXtZ7pdElgMCo5HKaUVEcwFGurA4UbMXVXPOKqQ5frn4m007Q+fLe5Hbgu2Y0LKZT/DAu6/QeXwAWcI+pmo2cwGWbZfiemwlely5VTpsP7zSuIEveXx3odaAkte5OXpKTE3xnNibuMGJaAq8nTmX9A1LPJhKld50A9VX+DzXGBM98oUDV2LSFpfW9QWEH0Zara2m4LRMbv7o/OVyzkSMvukNN0Dq2L/i8v0oEytZ1Pyk+0kK7+Dqf0h9fzm/LPrRFySIOJAdmNw/D1W4UiSbc9s/cWaa+jyoJnzvTGCsGCnLxOUKO0vxJwEkCL7UetPYfUsE9jHPgWZgkw+fCvr9mjTBknJWCGFfWmajih0F1FCilJVxbHBObRHJ1kBdcX79Jt9GddQaqLTW2IwMspaORtdDH4BR1VUV8gn0kmChQ5J9hx0am2jV33k1TK33/9Tp4Z2G62U5RV4oenxzO4V5kZ1TniJZPGEpO7dNQ+wINC6BBl3tjCmXTniI7kqC1X3FE1ddyV7q/UTxKbyWeXaCorCGvF+bgWvsg1g5tCf7397sYWbNfJXINSk4rYB6eJOJems2J1XAxYz2K1RDB3UEtCv3ISdW/RoBctxbCH2nchLxlmtreLO+/C8u/2P9ZQ2XvTMRG2qVRT/hKTM0s/u7rLsM9U0WU1kAdfG6XSPTUzV27oMUO8pkWRux/+6RMjITEk00dsRG4WjPjSWDGfdu9NuD4VRuuEMDbXVgtvW8g4dHwr/QlghZTu/qmUlbJPr+8YcslJtoRH06U+MV5u8tsUb1v7kFshEoQObPzS5tmZaya1Ww257E+aILkXzl4Qa5TQ5O62nYzTyxd/TAHMnOZKvzwDq4CM2s2oQBL6MVh5ThJoeYj
 j15sZXsB
 8AH1r6OQKb08JblVOS2ItMlqPXm9q44WBhWlDcJMIRbxneOYvza+y0H/ABJA36CZu3B8/Nh+WIii3FYf/Enp+3tXGX5kS5JW4zutdkBicyyizGfh/9NP8aSvT/cmhejtKFiURXnSMw0uUjk+8bBOk+AMphO6v00gsE82e93kchUsix0jP1gSGdlxG6XrNrl1kY8loHvZbfLqsq3wWRva0kYAt/zH6Yx1CuMYEmj95A68gxMqUdq5wdqNYjH1C74NvHvk58bdr13vblQ5Rs80mxq4MuWE0Yoi1sY05aDj77c+z7+nKYeoRSD3B5ObFCEu9SB8YES/oJQQQcr+rGANVm47BBsW+qsZMF/WSRCfzWY0+7Fqbt6kYGB1/GoihFoT3QDCBFKOt4sZXbH3NxDqwq1+DbyUOfyP3DhRoFBlJc2S0NR0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 2:16=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
>
> On 2026/3/20 10:14, Suren Baghdasaryan wrote:
> > On Thu, Mar 19, 2026 at 6:58=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote=
:
> >>
> >> On 2026/3/20 07:48, Suren Baghdasaryan wrote:
> >>> On Thu, Mar 19, 2026 at 4:44=E2=80=AFPM Suren Baghdasaryan <surenb@go=
ogle.com> wrote:
> >>>> On Thu, Mar 19, 2026 at 3:28=E2=80=AFPM Andrew Morton <akpm@linux-fo=
undation.org> wrote:
> >>>>> On Thu, 19 Mar 2026 16:31:53 +0800 Hao Ge <hao.ge@linux.dev> wrote:
> >>>>>
> >>>>>> Due to initialization ordering, page_ext is allocated and initiali=
zed
> >>>>>> relatively late during boot. Some pages have already been allocate=
d
> >>>>>> and freed before page_ext becomes available, leaving their codetag
> >>>>>> uninitialized.
> >>>> Hi Hao,
> >>>> Thanks for the report.
> >>>> Hmm. So, we are allocating pages before page_ext is initialized...
> >>>>
> >>>>>> A clear example is in init_section_page_ext(): alloc_page_ext() ca=
lls
> >>>>>> kmemleak_alloc().
> >>> Forgot to ask. The example you are using here is for page_ext
> >>> allocation itself. Do you have any other examples where page
> >>> allocation happens before page_ext initialization? If that's the only
> >>> place, then we might be able to fix this in a simpler way by doing
> >>> something special for alloc_page_ext().
> >> Hi Suren
> >>
> >> To help illustrate the point, here's the debug log I added:
> >>
> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> index 2d4b6f1a554e..ebfe636f5b07 100644
> >> --- a/mm/page_alloc.c
> >> +++ b/mm/page_alloc.c
> >> @@ -1293,6 +1293,9 @@ void __pgalloc_tag_add(struct page *page, struct
> >> task_struct *task,
> >>                   alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr)=
;
> >>                   update_page_tag_ref(handle, &ref);
> >>                   put_page_tag_ref(handle);
> >> +       } else {
> >> +               pr_warn("__pgalloc_tag_add: get_page_tag_ref failed!
> >> page=3D%p pfn=3D%lu nr=3D%u\n", page, page_to_pfn(page), nr);
> >> +               dump_stack();
> >>           }
> >>    }
> >>
> >>
> >> And I caught the following logs:
> >>
> >> [    0.296399] __pgalloc_tag_add: get_page_tag_ref failed!
> >> page=3Dffffea000400c700 pfn=3D1049372 nr=3D1
> >> [    0.296400] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted
> >> 7.0.0-rc4-dirty #12 PREEMPT(lazy)
> >> [    0.296402] Hardware name: Red Hat KVM, BIOS
> >> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> >> [    0.296402] Call Trace:
> >> [    0.296403]  <TASK>
> >> [    0.296403]  dump_stack_lvl+0x53/0x70
> >> [    0.296405]  __pgalloc_tag_add+0x3a3/0x6e0
> >> [    0.296406]  ? __pfx___pgalloc_tag_add+0x10/0x10
> >> [    0.296407]  ? kasan_unpoison+0x27/0x60
> >> [    0.296409]  ? __kasan_unpoison_pages+0x2c/0x40
> >> [    0.296411]  get_page_from_freelist+0xa54/0x1310
> >> [    0.296413]  __alloc_frozen_pages_noprof+0x206/0x4c0
> >> [    0.296415]  ? __pfx___alloc_frozen_pages_noprof+0x10/0x10
> >> [    0.296417]  ? stack_depot_save_flags+0x3f/0x680
> >> [    0.296418]  ? ___slab_alloc+0x518/0x530
> >> [    0.296420]  alloc_pages_mpol+0x13a/0x3f0
> >> [    0.296421]  ? __pfx_alloc_pages_mpol+0x10/0x10
> >> [    0.296423]  ? _raw_spin_lock_irqsave+0x8a/0xf0
> >> [    0.296424]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
> >> [    0.296426]  alloc_slab_page+0xc2/0x130
> >> [    0.296427]  allocate_slab+0x77/0x2c0
> >> [    0.296429]  ? syscall_enter_define_fields+0x3bb/0x5f0
> >> [    0.296430]  ___slab_alloc+0x125/0x530
> >> [    0.296432]  ? __trace_define_field+0x252/0x3d0
> >> [    0.296433]  __kmalloc_noprof+0x329/0x630
> >> [    0.296435]  ? syscall_enter_define_fields+0x3bb/0x5f0
> >> [    0.296436]  syscall_enter_define_fields+0x3bb/0x5f0
> >> [    0.296438]  ? __pfx_syscall_enter_define_fields+0x10/0x10
> >> [    0.296440]  event_define_fields+0x326/0x540
> >> [    0.296441]  __trace_early_add_events+0xac/0x3c0
> >> [    0.296443]  trace_event_init+0x24c/0x460
> >> [    0.296445]  trace_init+0x9/0x20
> >> [    0.296446]  start_kernel+0x199/0x3c0
> >> [    0.296448]  x86_64_start_reservations+0x18/0x30
> >> [    0.296449]  x86_64_start_kernel+0xe2/0xf0
> >> [    0.296451]  common_startup_64+0x13e/0x141
> >> [    0.296453]  </TASK>
> >>
> >>
> >> [    0.312234] __pgalloc_tag_add: get_page_tag_ref failed!
> >> page=3Dffffea000400f900 pfn=3D1049572 nr=3D1
> >> [    0.312234] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted
> >> 7.0.0-rc4-dirty #12 PREEMPT(lazy)
> >> [    0.312236] Hardware name: Red Hat KVM, BIOS
> >> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> >> [    0.312236] Call Trace:
> >> [    0.312237]  <TASK>
> >> [    0.312237]  dump_stack_lvl+0x53/0x70
> >> [    0.312239]  __pgalloc_tag_add+0x3a3/0x6e0
> >> [    0.312240]  ? __pfx___pgalloc_tag_add+0x10/0x10
> >> [    0.312241]  ? rmqueue.constprop.0+0x4fc/0x1ce0
> >> [    0.312243]  ? kasan_unpoison+0x27/0x60
> >> [    0.312244]  ? __kasan_unpoison_pages+0x2c/0x40
> >> [    0.312246]  get_page_from_freelist+0xa54/0x1310
> >> [    0.312248]  __alloc_frozen_pages_noprof+0x206/0x4c0
> >> [    0.312250]  ? __pfx___alloc_frozen_pages_noprof+0x10/0x10
> >> [    0.312253]  alloc_slab_page+0x39/0x130
> >> [    0.312254]  allocate_slab+0x77/0x2c0
> >> [    0.312255]  ? alloc_cpumask_var_node+0xc7/0x230
> >> [    0.312257]  ___slab_alloc+0x46d/0x530
> >> [    0.312259]  __kmalloc_node_noprof+0x2fa/0x680
> >> [    0.312261]  ? alloc_cpumask_var_node+0xc7/0x230
> >> [    0.312263]  alloc_cpumask_var_node+0xc7/0x230
> >> [    0.312264]  init_desc+0x141/0x6b0
> >> [    0.312266]  alloc_desc+0x108/0x1b0
> >> [    0.312267]  early_irq_init+0xee/0x1c0
> >> [    0.312268]  ? __pfx_early_irq_init+0x10/0x10
> >> [    0.312271]  start_kernel+0x1ab/0x3c0
> >> [    0.312272]  x86_64_start_reservations+0x18/0x30
> >> [    0.312274]  x86_64_start_kernel+0xe2/0xf0
> >> [    0.312275]  common_startup_64+0x13e/0x141
> >> [    0.312277]  </TASK>
> >>
> >> [    0.312834] __pgalloc_tag_add: get_page_tag_ref failed!
> >> page=3Dffffea000400fc00 pfn=3D1049584 nr=3D1
> >> [    0.312835] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted
> >> 7.0.0-rc4-dirty #12 PREEMPT(lazy)
> >> [    0.312836] Hardware name: Red Hat KVM, BIOS
> >> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> >> [    0.312837] Call Trace:
> >> [    0.312837]  <TASK>
> >> [    0.312838]  dump_stack_lvl+0x53/0x70
> >> [    0.312840]  __pgalloc_tag_add+0x3a3/0x6e0
> >> [    0.312841]  ? __pfx___pgalloc_tag_add+0x10/0x10
> >> [    0.312842]  ? rmqueue.constprop.0+0x4fc/0x1ce0
> >> [    0.312844]  ? kasan_unpoison+0x27/0x60
> >> [    0.312845]  ? __kasan_unpoison_pages+0x2c/0x40
> >> [    0.312847]  get_page_from_freelist+0xa54/0x1310
> >> [    0.312849]  __alloc_frozen_pages_noprof+0x206/0x4c0
> >> [    0.312851]  ? __pfx___alloc_frozen_pages_noprof+0x10/0x10
> >> [    0.312853]  alloc_pages_mpol+0x13a/0x3f0
> >> [    0.312855]  ? __pfx_alloc_pages_mpol+0x10/0x10
> >> [    0.312856]  ? xas_find+0x2d8/0x450
> >> [    0.312858]  ? _raw_spin_lock+0x84/0xe0
> >> [    0.312859]  ? __pfx__raw_spin_lock+0x10/0x10
> >> [    0.312861]  alloc_pages_noprof+0xf6/0x2b0
> >> [    0.312862]  __change_page_attr+0x293/0x850
> >> [    0.312864]  ? __pfx___change_page_attr+0x10/0x10
> >> [    0.312865]  ? _vm_unmap_aliases+0x2d0/0x650
> >> [    0.312868]  ? __pfx__vm_unmap_aliases+0x10/0x10
> >> [    0.312869]  __change_page_attr_set_clr+0x16c/0x360
> >> [    0.312871]  ? spp_getpage+0xbb/0x1e0
> >> [    0.312872]  change_page_attr_set_clr+0x220/0x3c0
> >> [    0.312873]  ? flush_tlb_one_kernel+0xf/0x30
> >> [    0.312875]  ? set_pte_vaddr_p4d+0x110/0x180
> >> [    0.312877]  ? __pfx_change_page_attr_set_clr+0x10/0x10
> >> [    0.312878]  ? __pfx_set_pte_vaddr_p4d+0x10/0x10
> >> [    0.312881]  ? __pfx_mtree_load+0x10/0x10
> >> [    0.312883]  ? __pfx_mtree_load+0x10/0x10
> >> [    0.312884]  ? __asan_memcpy+0x3c/0x60
> >> [    0.312886]  ? set_intr_gate+0x10c/0x150
> >> [    0.312888]  set_memory_ro+0x76/0xa0
> >> [    0.312889]  ? __pfx_set_memory_ro+0x10/0x10
> >> [    0.312891]  idt_setup_apic_and_irq_gates+0x2c1/0x390
> >>
> >> and more.
> > Ok, it's not the only place. Got your point.
> >
> >> off topic -  if we were to handle only alloc_page_ext() specifically,
> >> what would be the most straightforward
> >>
> >> solution in your mind? I'd really appreciate your insight.
> > I was thinking if it's the only special case maybe we can handle it
> > somehow differently, like we do when we allocate obj_ext vectors for
> > slabs using __GFP_NO_OBJ_EXT. I haven't found a good solution yet but
> > since it's not a special case we would not be able to use it even if I
> > came up with something...
> > I think your way is the most straight-forward but please try my
> > suggestion to see if we can avoid extra overhead.
> > Thanks,
> > Suren.
>

Hi Hao,

> Hi Suren
>
> Thank you for your feedback. After re-examining this issue,
>
> I realize my previous focus was misplaced.
>
> Upon deeper consideration, I understand that this is not merely a bug,
>
> but rather a warning that indicates a gap in our memory profiling mechani=
sm.
>
> Specifically, the current implementation appears to be missing memory
> allocation
>
> tracking during the period between the buddy system allocation and page_e=
xt
>
> initialization.
>
> This profiling gap means we may not be capturing all relevant memory
> allocation
>
> events during this critical transition phase.

Correct, this limitation exists because memory profiling relies on
some kernel facilities (page_ext, objj_ext) which might not be
initialized yet at the time of allocation.

>
> My approach is to dynamically allocate codetag_ref when get_page_tag_ref
> fails,
>
> and maintain a linked list to track all buddy system allocations that
> occur prior to page_ext initialization.
>
>   However, this introduces performance concerns:
>
> 1. Free Path Overhead: When freeing these pages, we would need to
> traverse the entire linked list to locate
>
>       the corresponding codetag_ref, resulting in O(n) lookup complexity
> per free operation.
>
> 2. Initialization Overhead: During init_page_alloc_tagging, iterating
> through the linked list to assign codetag_ref to
>
>       page_ext would introduce additional traversal cost.
>
> If the number of pages is substantial, this could incur significant
> overhead. What are your thoughts on this? I look forward to your
> suggestions.

My thinking is that these early allocations comprise a small portion
of overall memory consumed by the system. So, instead of trying to
record and handle them in some alternative way, we just accept that
some counters might not be exactly accurate and ignore those early
allocations. See how the early slab allocations are marked with the
CODETAG_FLAG_INACCURATE flag and later reported as inaccurate. I think
that's an acceptable alternative to introducing extra complexity and
performance overhead. IOW, the benefits of accounting for these early
allocations are low compared to the effort required to account for
them. Unless you found a simple and performant way to do that...
I think your earlier patch can effectively detect these early
allocations and suppress the warnings. We should also mark these
allocations with CODETAG_FLAG_INACCURATE.
Thanks,
Suren.

>
>
> Thanks
>
> Hao
>
> >
> >> Thanks.
> >>
> >>
> >>>>>> If the slab cache has no free objects, it falls back
> >>>>>> to the buddy allocator to allocate memory. However, at this point =
page_ext
> >>>>>> is not yet fully initialized, so these newly allocated pages have =
no
> >>>>>> codetag set. These pages may later be reclaimed by KASAN,which cau=
ses
> >>>>>> the warning to trigger when they are freed because their codetag r=
ef is
> >>>>>> still empty.
> >>>>>>
> >>>>>> Use a global array to track pages allocated before page_ext is ful=
ly
> >>>>>> initialized, similar to how kmemleak tracks early allocations.
> >>>>>> When page_ext initialization completes, set their codetag
> >>>>>> to empty to avoid warnings when they are freed later.
> >>>>>>
> >>>>>> ...
> >>>>>>
> >>>>>> --- a/include/linux/alloc_tag.h
> >>>>>> +++ b/include/linux/alloc_tag.h
> >>>>>> @@ -74,6 +74,9 @@ static inline void set_codetag_empty(union codet=
ag_ref *ref)
> >>>>>>
> >>>>>>    #ifdef CONFIG_MEM_ALLOC_PROFILING
> >>>>>>
> >>>>>> +bool mem_profiling_is_available(void);
> >>>>>> +void alloc_tag_add_early_pfn(unsigned long pfn);
> >>>>>> +
> >>>>>>    #define ALLOC_TAG_SECTION_NAME       "alloc_tags"
> >>>>>>
> >>>>>>    struct codetag_bytes {
> >>>>>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> >>>>>> index 58991ab09d84..a5bf4e72c154 100644
> >>>>>> --- a/lib/alloc_tag.c
> >>>>>> +++ b/lib/alloc_tag.c
> >>>>>> @@ -6,6 +6,7 @@
> >>>>>>    #include <linux/kallsyms.h>
> >>>>>>    #include <linux/module.h>
> >>>>>>    #include <linux/page_ext.h>
> >>>>>> +#include <linux/pgalloc_tag.h>
> >>>>>>    #include <linux/proc_fs.h>
> >>>>>>    #include <linux/seq_buf.h>
> >>>>>>    #include <linux/seq_file.h>
> >>>>>> @@ -26,6 +27,82 @@ static bool mem_profiling_support;
> >>>>>>
> >>>>>>    static struct codetag_type *alloc_tag_cttype;
> >>>>>>
> >>>>>> +/*
> >>>>>> + * State of the alloc_tag
> >>>>>> + *
> >>>>>> + * This is used to describe the states of the alloc_tag during bo=
otup.
> >>>>>> + *
> >>>>>> + * When we need to allocate page_ext to store codetag, we face an
> >>>>>> + * initialization timing problem:
> >>>>>> + *
> >>>>>> + * Due to initialization order, pages may be allocated via buddy =
system
> >>>>>> + * before page_ext is fully allocated and initialized. Although t=
hese
> >>>>>> + * pages call the allocation hooks, the codetag will not be set b=
ecause
> >>>>>> + * page_ext is not yet available.
> >>>>>> + *
> >>>>>> + * When these pages are later free to the buddy system, it trigge=
rs
> >>>>>> + * warnings because their codetag is actually empty if
> >>>>>> + * CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled.
> >>>>>> + *
> >>>>>> + * Additionally, in this situation, we cannot record detailed all=
ocation
> >>>>>> + * information for these pages.
> >>>>>> + */
> >>>>>> +enum mem_profiling_state {
> >>>>>> +     DOWN,                   /* No mem_profiling functionality ye=
t */
> >>>>>> +     UP                      /* Everything is working */
> >>>>>> +};
> >>>>>> +
> >>>>>> +static enum mem_profiling_state mem_profiling_state =3D DOWN;
> >>>>>> +
> >>>>>> +bool mem_profiling_is_available(void)
> >>>>>> +{
> >>>>>> +     return mem_profiling_state =3D=3D UP;
> >>>>>> +}
> >>>>>> +
> >>>>>> +#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
> >>>>>> +
> >>>>>> +#define EARLY_ALLOC_PFN_MAX          256
> >>>>>> +
> >>>>>> +static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX];
> >>>>> It's unfortunate that this isn't __initdata.
> >>>>>
> >>>>>> +static unsigned int early_pfn_count;
> >>>>>> +static DEFINE_SPINLOCK(early_pfn_lock);
> >>>>>> +
> >>>>>>
> >>>>>> ...
> >>>>>>
> >>>>>> --- a/mm/page_alloc.c
> >>>>>> +++ b/mm/page_alloc.c
> >>>>>> @@ -1293,6 +1293,13 @@ void __pgalloc_tag_add(struct page *page, s=
truct task_struct *task,
> >>>>>>                 alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * n=
r);
> >>>>>>                 update_page_tag_ref(handle, &ref);
> >>>>>>                 put_page_tag_ref(handle);
> >>>>>> +     } else {
> >>>> This branch can be marked as "unlikely".
> >>>>
> >>>>>> +             /*
> >>>>>> +              * page_ext is not available yet, record the pfn so =
we can
> >>>>>> +              * clear the tag ref later when page_ext is initiali=
zed.
> >>>>>> +              */
> >>>>>> +             if (!mem_profiling_is_available())
> >>>>>> +                     alloc_tag_add_early_pfn(page_to_pfn(page));
> >>>>>>         }
> >>>>>>    }
> >>>>> All because of this, I believe.  Is this fixable?
> >>>>>
> >>>>> If we take that `else', we know we're running in __init code, yes? =
 I
> >>>>> don't see how `__init pgalloc_tag_add_early()' could be made to wor=
k.
> >>>>> hrm.  Something clever, please.
> >>>> We can have a pointer to a function that is initialized to point to
> >>>> alloc_tag_add_early_pfn, which is defined as __init and uses
> >>>> early_pfns which now can be defined as __initdata. After
> >>>> clear_early_alloc_pfn_tag_refs() is done we reset that pointer to
> >>>> NULL. __pgalloc_tag_add() instead of calling alloc_tag_add_early_pfn=
()
> >>>> directly checks that pointer and if it's not NULL then calls the
> >>>> function that it points to. This way __pgalloc_tag_add() which is no=
t
> >>>> an __init function will be invoking alloc_tag_add_early_pfn() __init
> >>>> function only until we are done with initialization. I haven't tried
> >>>> this but I think that should work. This also eliminates the need for
> >>>> mem_profiling_state variable since we can use this function pointer
> >>>> instead.
> >>>>
> >>>>

