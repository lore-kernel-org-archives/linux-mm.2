Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17176FC72DA
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 00:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 139B66B0088; Tue, 24 Mar 2026 20:21:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C4566B0089; Tue, 24 Mar 2026 20:21:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7F266B008A; Tue, 24 Mar 2026 20:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC66B6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 20:21:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 73983140540
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 00:21:48 +0000 (UTC)
X-FDA: 84582682296.20.EBD5FA5
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6E27410000A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 00:21:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=H0wkndGC;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774398106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IIE4Q5SLYlRwq/ZIsMR50SRao9BYtgMMjZkPu0bPzrI=;
	b=l4cYupUqpgVt+CZ40HlW9YPDAAI71BrcZ17V+eF9PXCOJiyaC+mvx0DXBFCtJkq/BGoJ4M
	584umssbuVwQiczPSvIMBvdLoBGdRurS19VfIGl2F4M1uaMEjfx2c8B7IXLta4v3640mx8
	G7KqHyhWazwigQEegvS1D9dxKB+9GN4=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=H0wkndGC;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774398106; a=rsa-sha256;
	cv=pass;
	b=uf1Prp3xJCGWJDJFlyYufK3W00bacwcyClgx4hQWo8LxslKWxbdNE8GOVqf5r85IjBbwbs
	QhpLTujBlrUKzmHvVAKNqbHoJkqFbGB5Qrwhbkjf6IIDgecGyfeHIsl7pP/qgxtRb+qow2
	CwMAuDyFNskoO1d8Ai/+Rt/a8SNlH3o=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5091ed02c54so131031cf.1
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 17:21:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774398105; cv=none;
        d=google.com; s=arc-20240605;
        b=EIT4r/Bt0C8COCZ4K0iFhJltX42ZcPqotYCnVs0kVhONbUovRnizLRDsZ8lTBoURvD
         U9dSUATKSqbFV5weTLoSa8QQrB+1TRhHGmjX/IX1Ifblej31Y0BaTrFIN5aMCqsbbi1B
         Fkd0wPBXANiwD2Oqn7rrUz1/SYH/O9MrtP4dzWxStxboVv2IVDchO3JJkUPJiDpKsQmF
         qa1ihuX1vAWkgCK6b/mJzr0AUfP56Y/RH0sL8cVWDYPq80hwTlof6woDftkIQvnfn2lI
         ENkgVpQu3O9lvpcZB+qwIsFeG1UIAxtgc41C4j42YOe/Dm/BjnR+4QvOOlSpjDIuF12Z
         +zxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IIE4Q5SLYlRwq/ZIsMR50SRao9BYtgMMjZkPu0bPzrI=;
        fh=+cURRq7e+vuIrBwXIx94pRXjsBCeFvYy//xyCSZ9lDY=;
        b=OcC9h9syOBWNQBLggAiTaotji7UOJSiK0qpwYUwqAlX2uKfjIy4YCACjfNoU8eEiDr
         Mcygir97p+cyVd03ZkLHsrYlOpK29M4NEMp+wRWCjSOX8ksr874NWEFZ0kqkot+T6rpU
         MLFDm6QOp+MTYTIfxlp3dKENYBdAj681bEhntjH9/60CeJXPTtzdVHpwe9gX0ehjnuJX
         HuFzY3zTJGUpCS1YL3Eg6q7Y1Hr7+JnIt1vYSDdc4D9GxBIP48kFq6sfzUEgN1sK4BUC
         3vmBKZa0fvpN6b4DFWGaRphiOH9Rhq+VrYMb5RWX/r3ek0ozUZRRrIPWdVXkUBcpJXp0
         EFVA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774398105; x=1775002905; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IIE4Q5SLYlRwq/ZIsMR50SRao9BYtgMMjZkPu0bPzrI=;
        b=H0wkndGCDO7CMhtO8JlUerh2wI1sMjf8mApXySy9yP0xWy2R1Me8Bp6Ecird+Iyrxo
         WJSXbwaV029kWWTuEiiR87ucwStz88o2E3WcTxlTG7oRYl6YleZgjOFZlFElwHAQ1Pxu
         l35YWpMJlTrzoejxq0ENZRaaT+EL4QZ+AvVWJdXQA9ZbVB3NY6HU1aRgZV8h+MwYH1WI
         3HR0F5d2czSpZLcl+RKAcvw0QNBMHTsBTpwWNkEU/E1uk9oYYy4InBgPrCY72EdiXJkN
         I1d9FAg+9t5IRCkENZNxcTJhfXLvB4szzL7XdmY6tYTWHzO4UQgADCzryqXtjCoT181C
         DYTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774398105; x=1775002905;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IIE4Q5SLYlRwq/ZIsMR50SRao9BYtgMMjZkPu0bPzrI=;
        b=KwjbBOCWwR/SZY2k6P+0Yr65+HcWRaxJYwCwUKs7UEPDJEkPGPiiBvKLG/LnOSgP3E
         NhGoYzYEQLCYHDQ9KnEbgGr12mU3LEPeeBKFVST/OdnLtIexX9XWbm+CZ9tGeS74/pCP
         7mg7DiZbIevWxp3l7k66WdGon8ra2pwNZerXuOe0aF0iEZtGJb5bHVH7NEPTjo4hoIUz
         kCDCVEKyEEbd9kTf/RpQxTS9qYJTlBVmIwOgcLJT0Dpnwe4p80LCdUs48Wv48g1iRDb4
         5KVnPqNb8xCYcW3mPRlhTJHv8GdiOYU3vX3njGEqUJ3nIod9ue7TmlSMyx9YgtFDBeGa
         qB7A==
X-Forwarded-Encrypted: i=1; AJvYcCXDo7/fpfrh91rKny5lsT1EJy00asPHdQfj5DbmzWCxfdypatRGZLe4yZmDE08Pt08vBV7nxaorKQ==@kvack.org
X-Gm-Message-State: AOJu0YwEYV+CiYvRjfk3AWyTucm85doGSLKAJzoehrSPnrtVnziT9kbK
	Vh/XnyIGUyA5rRz3oz59760EfviWW4sBYO0O8VG4sVo1njCcfEvceS5FsSHWQwmudGAhyb580V0
	EgjgSw2cEi/bufMFX+8SIcNGrLzNFD6uym2Bu22Tl
X-Gm-Gg: ATEYQzyMDfXeJrU/Vip8z9Z5JPqyVXMTct7YJPkZsK5OqtXqmSFjHkgFwrlaw6FbtzX
	ny7+s+qk4yFGdOtUBeHlcS9aVfezLdr897q9yFEqnZBBiCXcEqhBDgprVhEimLtwVjYskHDEn7u
	pJswwanQPpGOb6qk4O+kdGHIhoeI5Bw8P0vrrK166ZiTzhJvb49yNNzpWpNpw+G5IeEJzNoXjXM
	jj8RR+3KfKVJ/GNY8QO7UpUg64gFPanKa7X9SXtOg3pOiGpGPMK6yrMFl84doTNzd0joR4FWGJA
	E4E92A==
X-Received: by 2002:a05:622a:9008:b0:509:15b6:f6a0 with SMTP id
 d75a77b69052e-50b8221cae5mr7078431cf.6.1774398104483; Tue, 24 Mar 2026
 17:21:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260319083153.2488005-1-hao.ge@linux.dev> <20260319152808.fce61386fdf2934d7a3b0edb@linux-foundation.org>
 <CAJuCfpG5OG66mgfn3ez5ZXTjj7VC8yuK3L2u83uOZhyBbRH2Lw@mail.gmail.com>
 <CAJuCfpHD4SB30oP7Bdm=ey+2W7CAsFPruedEbqgR5OumrQErxQ@mail.gmail.com>
 <9ef1c798-a30f-4458-9684-900136ae8b7d@linux.dev> <CAJuCfpEt1EwS4_kiTbger7sBGFKKhi+6PBjrYrTK1HEJzxOTGg@mail.gmail.com>
 <575e727e-cd47-41df-966a-142425aa8a8b@linux.dev> <CAJuCfpH4Wpv+jFOm2Xc3UOpn-vcEsJj6W0JJC=SJ2nkA=gEOWg@mail.gmail.com>
 <35d274d9-ed52-4325-80fb-c374e8af3169@linux.dev>
In-Reply-To: <35d274d9-ed52-4325-80fb-c374e8af3169@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 24 Mar 2026 17:21:33 -0700
X-Gm-Features: AQROBzCsvqYV4S96trn1j0uZpnwNhLWdDx30fLfRvHtZJBFP1wzEEc7ePNKrJo0
Message-ID: <CAJuCfpF7BuTQgypAsaaccNnk+6Eyo5pumh1nMhFMQeff9CxkgQ@mail.gmail.com>
Subject: Re: [PATCH] mm/alloc_tag: clear codetag for pages allocated before
 page_ext initialization
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: h1mebfaw9st6mq5yezesqjnp4pmnneby
X-Rspamd-Queue-Id: 6E27410000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1774398106-611128
X-HE-Meta: U2FsdGVkX1834i+BqZ+iwkWaKCai0VHcsf1syGK+aogL2w/92K9ttmIrrg4YKbdLaMmJY0oH4ePdC2wWJ/g7IX74v1sB5dJTlYcW3UZIpZvujz2yKWS6+nJpL397LzSjIWUd0AIrjSANZHaMFo+E5QcWeVfVFb/g9xGJpRwyefeCOCn7Lin6+LBow2MLy3hUtcEWRDYNaDO8dpjzPGxOMJ7jXtGRZQxFMmATDV/Vs74pfiQnWCVxKY4VPEtTVx+BNU1tbtRK1K1yGCFhYUkJblUf+X+KH0w7GIFkLD6HqBdmaElEst8kMphaHL4EonxR5XnYZDJTuCBQ7vwmg4GaEqt5s7tAS4wTpLdqBdlYGAXxEEg63z1gqwN6brTCn03TcA30ZnMFd+9ycE5UGifgbqG044saEf9goH/DsLGuHx/2KI52MCelV5vBC9vzCrEPlA/LcB3SjzFn/Ndc5Hd2rxHOmA679uxUGfBpGpSRo+uaKjn5CHQSII5p2XJtHFsfRCbhDOfmf2zKdAnzd58oRs6wNPzZw3xa5/qkrigBUHv/IvGFnOUXPbl815+paUnEWQxl0bA2+FrRi92Ga74WVGnd79ls7t25V4viPtzsKP+9z2GXSkBs7EKZbwf946PZVDCLHgs0FBQV45Z9mh2L0oKo2iZflSJd8f2bQs2i9xmWQ2agVrfh+FZrvQ2Iv0bFBqULf7hl3kjfh/OyOBq1TAl5GBMhm0MO8Z1Ey6KESWbEjdhJfpqeS27aMpm72Znx5E5MW3d+4kMwgMLxhU+WA9pD9kUNhT4dKV49dtPb2vcMHQgrx3wMuEslQXm5Q8OvHWR+XEiOYXyWIJWuDiKX89brM/HnSHXwtZFaVie8kl1eoYFTTuYZqAut/Lqn1wpin8xgz5UErIFLZdtuFTdUTxHmiN9joHaUAz/X6CPq1LPy2pOK2tKbwcOdQ5Dt3BpwRluEoCCWgJaqgGLHl1K
 36iAZw/F
 ismKfqVd3HJykSmrba/OxdyU+29Lqxzl8V4Ac2ScUcDou1zhYZMSG2VRCIDflWl2ZkGInrPcvgrTlnI6iy56tC5sEbstrrsWtjLwx4HUnSdt9NMZhIvkexTUJkKjoo1biZxyUIK1oNS8kKHxrvfiROcTDedyQBqtCmqtIbkk989JOMc5935Gy/5F+a/uful6XkJ2t4y+1W2HLoboyoOd1QkqZSE+jZYUGBYgBFc26C8ywghC66LlTHhEzYwnduewT0X9tm7u03DTpc2TOpHV9BWKvih9jpn2VdRX7GfAQzdPXpWUGWyjuP9VLuxxBDN7wLk2xh2U3nPUs7Kw5YKJyFFz6hUb5VtQQOV7UmK+yiH7qMtiWHbeKtsu2QFRcTUomzRfedvWnWdOQ8LtQNy+WpnQeelx0GQmh4tXqOc/BFbd/VOY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 2:43=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
>
> On 2026/3/24 06:47, Suren Baghdasaryan wrote:
> > On Mon, Mar 23, 2026 at 2:16=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote=
:
> >>
> >> On 2026/3/20 10:14, Suren Baghdasaryan wrote:
> >>> On Thu, Mar 19, 2026 at 6:58=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wro=
te:
> >>>> On 2026/3/20 07:48, Suren Baghdasaryan wrote:
> >>>>> On Thu, Mar 19, 2026 at 4:44=E2=80=AFPM Suren Baghdasaryan <surenb@=
google.com> wrote:
> >>>>>> On Thu, Mar 19, 2026 at 3:28=E2=80=AFPM Andrew Morton <akpm@linux-=
foundation.org> wrote:
> >>>>>>> On Thu, 19 Mar 2026 16:31:53 +0800 Hao Ge <hao.ge@linux.dev> wrot=
e:
> >>>>>>>
> >>>>>>>> Due to initialization ordering, page_ext is allocated and initia=
lized
> >>>>>>>> relatively late during boot. Some pages have already been alloca=
ted
> >>>>>>>> and freed before page_ext becomes available, leaving their codet=
ag
> >>>>>>>> uninitialized.
> >>>>>> Hi Hao,
> >>>>>> Thanks for the report.
> >>>>>> Hmm. So, we are allocating pages before page_ext is initialized...
> >>>>>>
> >>>>>>>> A clear example is in init_section_page_ext(): alloc_page_ext() =
calls
> >>>>>>>> kmemleak_alloc().
> >>>>> Forgot to ask. The example you are using here is for page_ext
> >>>>> allocation itself. Do you have any other examples where page
> >>>>> allocation happens before page_ext initialization? If that's the on=
ly
> >>>>> place, then we might be able to fix this in a simpler way by doing
> >>>>> something special for alloc_page_ext().
> >>>> Hi Suren
> >>>>
> >>>> To help illustrate the point, here's the debug log I added:
> >>>>
> >>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >>>> index 2d4b6f1a554e..ebfe636f5b07 100644
> >>>> --- a/mm/page_alloc.c
> >>>> +++ b/mm/page_alloc.c
> >>>> @@ -1293,6 +1293,9 @@ void __pgalloc_tag_add(struct page *page, stru=
ct
> >>>> task_struct *task,
> >>>>                    alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * =
nr);
> >>>>                    update_page_tag_ref(handle, &ref);
> >>>>                    put_page_tag_ref(handle);
> >>>> +       } else {
> >>>> +               pr_warn("__pgalloc_tag_add: get_page_tag_ref failed!
> >>>> page=3D%p pfn=3D%lu nr=3D%u\n", page, page_to_pfn(page), nr);
> >>>> +               dump_stack();
> >>>>            }
> >>>>     }
> >>>>
> >>>>
> >>>> And I caught the following logs:
> >>>>
> >>>> [    0.296399] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>> page=3Dffffea000400c700 pfn=3D1049372 nr=3D1
> >>>> [    0.296400] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted
> >>>> 7.0.0-rc4-dirty #12 PREEMPT(lazy)
> >>>> [    0.296402] Hardware name: Red Hat KVM, BIOS
> >>>> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> >>>> [    0.296402] Call Trace:
> >>>> [    0.296403]  <TASK>
> >>>> [    0.296403]  dump_stack_lvl+0x53/0x70
> >>>> [    0.296405]  __pgalloc_tag_add+0x3a3/0x6e0
> >>>> [    0.296406]  ? __pfx___pgalloc_tag_add+0x10/0x10
> >>>> [    0.296407]  ? kasan_unpoison+0x27/0x60
> >>>> [    0.296409]  ? __kasan_unpoison_pages+0x2c/0x40
> >>>> [    0.296411]  get_page_from_freelist+0xa54/0x1310
> >>>> [    0.296413]  __alloc_frozen_pages_noprof+0x206/0x4c0
> >>>> [    0.296415]  ? __pfx___alloc_frozen_pages_noprof+0x10/0x10
> >>>> [    0.296417]  ? stack_depot_save_flags+0x3f/0x680
> >>>> [    0.296418]  ? ___slab_alloc+0x518/0x530
> >>>> [    0.296420]  alloc_pages_mpol+0x13a/0x3f0
> >>>> [    0.296421]  ? __pfx_alloc_pages_mpol+0x10/0x10
> >>>> [    0.296423]  ? _raw_spin_lock_irqsave+0x8a/0xf0
> >>>> [    0.296424]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
> >>>> [    0.296426]  alloc_slab_page+0xc2/0x130
> >>>> [    0.296427]  allocate_slab+0x77/0x2c0
> >>>> [    0.296429]  ? syscall_enter_define_fields+0x3bb/0x5f0
> >>>> [    0.296430]  ___slab_alloc+0x125/0x530
> >>>> [    0.296432]  ? __trace_define_field+0x252/0x3d0
> >>>> [    0.296433]  __kmalloc_noprof+0x329/0x630
> >>>> [    0.296435]  ? syscall_enter_define_fields+0x3bb/0x5f0
> >>>> [    0.296436]  syscall_enter_define_fields+0x3bb/0x5f0
> >>>> [    0.296438]  ? __pfx_syscall_enter_define_fields+0x10/0x10
> >>>> [    0.296440]  event_define_fields+0x326/0x540
> >>>> [    0.296441]  __trace_early_add_events+0xac/0x3c0
> >>>> [    0.296443]  trace_event_init+0x24c/0x460
> >>>> [    0.296445]  trace_init+0x9/0x20
> >>>> [    0.296446]  start_kernel+0x199/0x3c0
> >>>> [    0.296448]  x86_64_start_reservations+0x18/0x30
> >>>> [    0.296449]  x86_64_start_kernel+0xe2/0xf0
> >>>> [    0.296451]  common_startup_64+0x13e/0x141
> >>>> [    0.296453]  </TASK>
> >>>>
> >>>>
> >>>> [    0.312234] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>> page=3Dffffea000400f900 pfn=3D1049572 nr=3D1
> >>>> [    0.312234] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted
> >>>> 7.0.0-rc4-dirty #12 PREEMPT(lazy)
> >>>> [    0.312236] Hardware name: Red Hat KVM, BIOS
> >>>> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> >>>> [    0.312236] Call Trace:
> >>>> [    0.312237]  <TASK>
> >>>> [    0.312237]  dump_stack_lvl+0x53/0x70
> >>>> [    0.312239]  __pgalloc_tag_add+0x3a3/0x6e0
> >>>> [    0.312240]  ? __pfx___pgalloc_tag_add+0x10/0x10
> >>>> [    0.312241]  ? rmqueue.constprop.0+0x4fc/0x1ce0
> >>>> [    0.312243]  ? kasan_unpoison+0x27/0x60
> >>>> [    0.312244]  ? __kasan_unpoison_pages+0x2c/0x40
> >>>> [    0.312246]  get_page_from_freelist+0xa54/0x1310
> >>>> [    0.312248]  __alloc_frozen_pages_noprof+0x206/0x4c0
> >>>> [    0.312250]  ? __pfx___alloc_frozen_pages_noprof+0x10/0x10
> >>>> [    0.312253]  alloc_slab_page+0x39/0x130
> >>>> [    0.312254]  allocate_slab+0x77/0x2c0
> >>>> [    0.312255]  ? alloc_cpumask_var_node+0xc7/0x230
> >>>> [    0.312257]  ___slab_alloc+0x46d/0x530
> >>>> [    0.312259]  __kmalloc_node_noprof+0x2fa/0x680
> >>>> [    0.312261]  ? alloc_cpumask_var_node+0xc7/0x230
> >>>> [    0.312263]  alloc_cpumask_var_node+0xc7/0x230
> >>>> [    0.312264]  init_desc+0x141/0x6b0
> >>>> [    0.312266]  alloc_desc+0x108/0x1b0
> >>>> [    0.312267]  early_irq_init+0xee/0x1c0
> >>>> [    0.312268]  ? __pfx_early_irq_init+0x10/0x10
> >>>> [    0.312271]  start_kernel+0x1ab/0x3c0
> >>>> [    0.312272]  x86_64_start_reservations+0x18/0x30
> >>>> [    0.312274]  x86_64_start_kernel+0xe2/0xf0
> >>>> [    0.312275]  common_startup_64+0x13e/0x141
> >>>> [    0.312277]  </TASK>
> >>>>
> >>>> [    0.312834] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>> page=3Dffffea000400fc00 pfn=3D1049584 nr=3D1
> >>>> [    0.312835] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted
> >>>> 7.0.0-rc4-dirty #12 PREEMPT(lazy)
> >>>> [    0.312836] Hardware name: Red Hat KVM, BIOS
> >>>> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> >>>> [    0.312837] Call Trace:
> >>>> [    0.312837]  <TASK>
> >>>> [    0.312838]  dump_stack_lvl+0x53/0x70
> >>>> [    0.312840]  __pgalloc_tag_add+0x3a3/0x6e0
> >>>> [    0.312841]  ? __pfx___pgalloc_tag_add+0x10/0x10
> >>>> [    0.312842]  ? rmqueue.constprop.0+0x4fc/0x1ce0
> >>>> [    0.312844]  ? kasan_unpoison+0x27/0x60
> >>>> [    0.312845]  ? __kasan_unpoison_pages+0x2c/0x40
> >>>> [    0.312847]  get_page_from_freelist+0xa54/0x1310
> >>>> [    0.312849]  __alloc_frozen_pages_noprof+0x206/0x4c0
> >>>> [    0.312851]  ? __pfx___alloc_frozen_pages_noprof+0x10/0x10
> >>>> [    0.312853]  alloc_pages_mpol+0x13a/0x3f0
> >>>> [    0.312855]  ? __pfx_alloc_pages_mpol+0x10/0x10
> >>>> [    0.312856]  ? xas_find+0x2d8/0x450
> >>>> [    0.312858]  ? _raw_spin_lock+0x84/0xe0
> >>>> [    0.312859]  ? __pfx__raw_spin_lock+0x10/0x10
> >>>> [    0.312861]  alloc_pages_noprof+0xf6/0x2b0
> >>>> [    0.312862]  __change_page_attr+0x293/0x850
> >>>> [    0.312864]  ? __pfx___change_page_attr+0x10/0x10
> >>>> [    0.312865]  ? _vm_unmap_aliases+0x2d0/0x650
> >>>> [    0.312868]  ? __pfx__vm_unmap_aliases+0x10/0x10
> >>>> [    0.312869]  __change_page_attr_set_clr+0x16c/0x360
> >>>> [    0.312871]  ? spp_getpage+0xbb/0x1e0
> >>>> [    0.312872]  change_page_attr_set_clr+0x220/0x3c0
> >>>> [    0.312873]  ? flush_tlb_one_kernel+0xf/0x30
> >>>> [    0.312875]  ? set_pte_vaddr_p4d+0x110/0x180
> >>>> [    0.312877]  ? __pfx_change_page_attr_set_clr+0x10/0x10
> >>>> [    0.312878]  ? __pfx_set_pte_vaddr_p4d+0x10/0x10
> >>>> [    0.312881]  ? __pfx_mtree_load+0x10/0x10
> >>>> [    0.312883]  ? __pfx_mtree_load+0x10/0x10
> >>>> [    0.312884]  ? __asan_memcpy+0x3c/0x60
> >>>> [    0.312886]  ? set_intr_gate+0x10c/0x150
> >>>> [    0.312888]  set_memory_ro+0x76/0xa0
> >>>> [    0.312889]  ? __pfx_set_memory_ro+0x10/0x10
> >>>> [    0.312891]  idt_setup_apic_and_irq_gates+0x2c1/0x390
> >>>>
> >>>> and more.
> >>> Ok, it's not the only place. Got your point.
> >>>
> >>>> off topic -  if we were to handle only alloc_page_ext() specifically=
,
> >>>> what would be the most straightforward
> >>>>
> >>>> solution in your mind? I'd really appreciate your insight.
> >>> I was thinking if it's the only special case maybe we can handle it
> >>> somehow differently, like we do when we allocate obj_ext vectors for
> >>> slabs using __GFP_NO_OBJ_EXT. I haven't found a good solution yet but
> >>> since it's not a special case we would not be able to use it even if =
I
> >>> came up with something...
> >>> I think your way is the most straight-forward but please try my
> >>> suggestion to see if we can avoid extra overhead.
> >>> Thanks,
> >>> Suren.
>
> Hi Suren
>
>
> > Hi Hao,
> >
> >> Hi Suren
> >>
> >> Thank you for your feedback. After re-examining this issue,
> >>
> >> I realize my previous focus was misplaced.
> >>
> >> Upon deeper consideration, I understand that this is not merely a bug,
> >>
> >> but rather a warning that indicates a gap in our memory profiling mech=
anism.
> >>
> >> Specifically, the current implementation appears to be missing memory
> >> allocation
> >>
> >> tracking during the period between the buddy system allocation and pag=
e_ext
> >>
> >> initialization.
> >>
> >> This profiling gap means we may not be capturing all relevant memory
> >> allocation
> >>
> >> events during this critical transition phase.
> > Correct, this limitation exists because memory profiling relies on
> > some kernel facilities (page_ext, objj_ext) which might not be
> > initialized yet at the time of allocation.
> >
> >> My approach is to dynamically allocate codetag_ref when get_page_tag_r=
ef
> >> fails,
> >>
> >> and maintain a linked list to track all buddy system allocations that
> >> occur prior to page_ext initialization.
> >>
> >>    However, this introduces performance concerns:
> >>
> >> 1. Free Path Overhead: When freeing these pages, we would need to
> >> traverse the entire linked list to locate
> >>
> >>        the corresponding codetag_ref, resulting in O(n) lookup complex=
ity
> >> per free operation.
> >>
> >> 2. Initialization Overhead: During init_page_alloc_tagging, iterating
> >> through the linked list to assign codetag_ref to
> >>
> >>        page_ext would introduce additional traversal cost.
> >>
> >> If the number of pages is substantial, this could incur significant
> >> overhead. What are your thoughts on this? I look forward to your
> >> suggestions.
> > My thinking is that these early allocations comprise a small portion
> > of overall memory consumed by the system. So, instead of trying to
> > record and handle them in some alternative way, we just accept that
> > some counters might not be exactly accurate and ignore those early
> > allocations. See how the early slab allocations are marked with the
> > CODETAG_FLAG_INACCURATE flag and later reported as inaccurate. I think
> > that's an acceptable alternative to introducing extra complexity and
> > performance overhead. IOW, the benefits of accounting for these early
> > allocations are low compared to the effort required to account for
> > them. Unless you found a simple and performant way to do that...
>
>
> I have been exploring possible solutions to this issue over the past few
> days,
>
> but so far I have not come up with a good approach.
>
> I have counted the number of memory allocations that occur earlier than t=
he
>
> allocation and initialization of our page_ext, and found that there are
> actually
>
> quite a lot of them.

Interesting... I wonder it's because deferred_struct_pages defers
page_ext initialization. Can you check if setting early_page_ext
reduces or eliminates these allocations before page_ext init cases?

>
> Similarly, I have made the following changes and collected the
> corresponding logs.
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2d4b6f1a554e..6db65b3d52d3 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1293,6 +1293,8 @@ void __pgalloc_tag_add(struct page *page, struct
> task_struct *task,
>                  alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
>                  update_page_tag_ref(handle, &ref);
>                  put_page_tag_ref(handle);
> +       } else{
> +               pr_warn("__pgalloc_tag_add: get_page_tag_ref failed!
> page=3D%p pfn=3D%lu nr=3D%u\n", page, page_to_pfn(page), nr);
>          }
>   }
>
> @@ -1314,6 +1316,8 @@ void __pgalloc_tag_sub(struct page *page, unsigned
> int nr)
>                  alloc_tag_sub(&ref, PAGE_SIZE * nr);
>                  update_page_tag_ref(handle, &ref);
>                  put_page_tag_ref(handle);
> +       } else{
> +                pr_warn("__pgalloc_tag_sub: get_page_tag_ref failed!
> page=3D%p pfn=3D%lu nr=3D%u\n", page, page_to_pfn(page), nr);
>          }
>   }
>
> [    0.261699] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001000 pfn=3D1048640 nr=3D2
> [    0.261711] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001100 pfn=3D1048644 nr=3D4
> [    0.261717] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001200 pfn=3D1048648 nr=3D4
> [    0.261721] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001300 pfn=3D1048652 nr=3D4
> [    0.261893] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001080 pfn=3D1048642 nr=3D2
> [    0.261917] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001400 pfn=3D1048656 nr=3D4
> [    0.262018] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001500 pfn=3D1048660 nr=3D2
> [    0.262024] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001600 pfn=3D1048664 nr=3D8
> [    0.262040] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001580 pfn=3D1048662 nr=3D1
> [    0.262048] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea00040015c0 pfn=3D1048663 nr=3D1
> [    0.262056] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001800 pfn=3D1048672 nr=3D2
> [    0.262064] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001880 pfn=3D1048674 nr=3D2
> [    0.262078] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001900 pfn=3D1048676 nr=3D2
> [    0.262196] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D8,=
 Nodes=3D1
> [    0.262213] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001980 pfn=3D1048678 nr=3D2
> [    0.262220] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001a00 pfn=3D1048680 nr=3D4
> [    0.262246] ODEBUG: selftest passed
> [    0.262268] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001b00 pfn=3D1048684 nr=3D1
> [    0.262318] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001b40 pfn=3D1048685 nr=3D1
> [    0.262368] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001b80 pfn=3D1048686 nr=3D1
> [    0.262418] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001bc0 pfn=3D1048687 nr=3D1
> [    0.262469] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001c00 pfn=3D1048688 nr=3D1
> [    0.262519] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001c40 pfn=3D1048689 nr=3D1
> [    0.262569] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001c80 pfn=3D1048690 nr=3D1
> [    0.262620] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001cc0 pfn=3D1048691 nr=3D1
> [    0.262670] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001d00 pfn=3D1048692 nr=3D1
> [    0.262721] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001d40 pfn=3D1048693 nr=3D1
> [    0.262771] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001d80 pfn=3D1048694 nr=3D1
> [    0.262821] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001dc0 pfn=3D1048695 nr=3D1
> [    0.262871] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001e00 pfn=3D1048696 nr=3D1
> [    0.262923] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001e40 pfn=3D1048697 nr=3D1
> [    0.262974] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001e80 pfn=3D1048698 nr=3D1
> [    0.263024] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001ec0 pfn=3D1048699 nr=3D1
> [    0.263074] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001f00 pfn=3D1048700 nr=3D1
> [    0.263124] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001f40 pfn=3D1048701 nr=3D1
> [    0.263174] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001f80 pfn=3D1048702 nr=3D1
> [    0.263224] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004001fc0 pfn=3D1048703 nr=3D1
> [    0.263275] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004002000 pfn=3D1048704 nr=3D1
> [    0.263325] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004002040 pfn=3D1048705 nr=3D1
> [    0.263375] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004002080 pfn=3D1048706 nr=3D1
> [    0.263427] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004002400 pfn=3D1048720 nr=3D16
> [    0.263437] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea00040020c0 pfn=3D1048707 nr=3D1
> [    0.263463] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004002100 pfn=3D1048708 nr=3D1
> [    0.263465] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004002140 pfn=3D1048709 nr=3D1
> [    0.263467] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004002180 pfn=3D1048710 nr=3D1
> [    0.263509] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004002200 pfn=3D1048712 nr=3D4
> [    0.263512] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004002800 pfn=3D1048736 nr=3D8
> [    0.263524] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea00040021c0 pfn=3D1048711 nr=3D1
> [    0.263536] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004002300 pfn=3D1048716 nr=3D1
> [    0.263537] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004002340 pfn=3D1048717 nr=3D1
> [    0.263539] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004002380 pfn=3D1048718 nr=3D1
> [    0.263604] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004004000 pfn=3D1048832 nr=3D128
> [    0.263638] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004003000 pfn=3D1048768 nr=3D64
> [    0.263650] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004002c00 pfn=3D1048752 nr=3D16
> [    0.263655] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea00040023c0 pfn=3D1048719 nr=3D1
> [    0.270582] __pgalloc_tag_sub: get_page_tag_ref failed!
> page=3Dffffea00040023c0 pfn=3D1048719 nr=3D1
> [    0.270591] ftrace: allocating 52717 entries in 208 pages
> [    0.270592] ftrace: allocated 208 pages with 3 groups
> [    0.270620] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004002a00 pfn=3D1048744 nr=3D8
> [    0.270636] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea00040023c0 pfn=3D1048719 nr=3D1
> [    0.270643] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006000 pfn=3D1048960 nr=3D1
> [    0.270649] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006040 pfn=3D1048961 nr=3D1
> [    0.270658] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004007000 pfn=3D1049024 nr=3D64
> [    0.270659] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006080 pfn=3D1048962 nr=3D2
> [    0.270722] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006100 pfn=3D1048964 nr=3D1
> [    0.270730] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006140 pfn=3D1048965 nr=3D1
> [    0.270738] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006180 pfn=3D1048966 nr=3D1
> [    0.270777] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea00040061c0 pfn=3D1048967 nr=3D1
> [    0.270786] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006200 pfn=3D1048968 nr=3D1
> [    0.270792] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006240 pfn=3D1048969 nr=3D1
> [    0.270833] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006300 pfn=3D1048972 nr=3D4
> [    0.270891] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006280 pfn=3D1048970 nr=3D1
> [    0.270980] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea00040062c0 pfn=3D1048971 nr=3D1
> [    0.271071] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006400 pfn=3D1048976 nr=3D1
> [    0.271156] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006440 pfn=3D1048977 nr=3D1
> [    0.271185] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006480 pfn=3D1048978 nr=3D2
> [    0.271301] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006500 pfn=3D1048980 nr=3D1
> [    0.271655] Dynamic Preempt: lazy
> [    0.271662] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006580 pfn=3D1048982 nr=3D2
> [    0.271752] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006600 pfn=3D1048984 nr=3D4
> [    0.271762] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004010000 pfn=3D1049600 nr=3D4
> [    0.271824] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006540 pfn=3D1048981 nr=3D1
> [    0.271916] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006700 pfn=3D1048988 nr=3D2
> [    0.271964] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006780 pfn=3D1048990 nr=3D1
> [    0.272099] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea00040067c0 pfn=3D1048991 nr=3D1
> [    0.272138] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006800 pfn=3D1048992 nr=3D2
> [    0.272144] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006a00 pfn=3D1049000 nr=3D8
> [    0.272249] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006c00 pfn=3D1049008 nr=3D8
> [    0.272319] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006880 pfn=3D1048994 nr=3D2
> [    0.272351] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006900 pfn=3D1048996 nr=3D4
> [    0.272424] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004006e00 pfn=3D1049016 nr=3D8
> [    0.272485] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004008000 pfn=3D1049088 nr=3D8
> [    0.272535] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004008200 pfn=3D1049096 nr=3D2
> [    0.272600] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004008400 pfn=3D1049104 nr=3D8
> [    0.272663] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004008300 pfn=3D1049100 nr=3D4
> [    0.272694] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004008280 pfn=3D1049098 nr=3D2
> [    0.272708] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004008600 pfn=3D1049112 nr=3D8
>
> [    0.272924] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004008880 pfn=3D1049122 nr=3D2
> [    0.272934] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004008900 pfn=3D1049124 nr=3D2
> [    0.272952] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004008c00 pfn=3D1049136 nr=3D4
> [    0.273035] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004008980 pfn=3D1049126 nr=3D2
> [    0.273062] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004008e00 pfn=3D1049144 nr=3D8
> [    0.273674] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004008d00 pfn=3D1049140 nr=3D1
> [    0.273884] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004008d80 pfn=3D1049142 nr=3D2
> [    0.273943] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009000 pfn=3D1049152 nr=3D2
> [    0.274379] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009080 pfn=3D1049154 nr=3D2
> [    0.274575] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009200 pfn=3D1049160 nr=3D8
> [    0.274617] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009100 pfn=3D1049156 nr=3D4
> [    0.274794] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009400 pfn=3D1049168 nr=3D2
> [    0.274840] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009480 pfn=3D1049170 nr=3D2
> [    0.275057] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009500 pfn=3D1049172 nr=3D2
> [    0.275092] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009580 pfn=3D1049174 nr=3D2
> [    0.275134] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009600 pfn=3D1049176 nr=3D8
> [    0.275211] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009800 pfn=3D1049184 nr=3D4
> [    0.275510] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009900 pfn=3D1049188 nr=3D2
> [    0.275548] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009980 pfn=3D1049190 nr=3D2
> [    0.275976] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009a00 pfn=3D1049192 nr=3D8
> [    0.275987] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009c00 pfn=3D1049200 nr=3D2
> [    0.276139] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009c80 pfn=3D1049202 nr=3D2
> [    0.276152] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004008d40 pfn=3D1049141 nr=3D1
> [    0.276242] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009d00 pfn=3D1049204 nr=3D1
> [    0.276358] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009d40 pfn=3D1049205 nr=3D1
> [    0.276444] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009d80 pfn=3D1049206 nr=3D1
> [    0.276526] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009dc0 pfn=3D1049207 nr=3D1
> [    0.276615] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009e00 pfn=3D1049208 nr=3D1
> [    0.276696] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009e40 pfn=3D1049209 nr=3D1
> [    0.276792] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009e80 pfn=3D1049210 nr=3D1
> [    0.276827] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009f00 pfn=3D1049212 nr=3D2
> [    0.276891] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009ec0 pfn=3D1049211 nr=3D1
> [    0.276999] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009f80 pfn=3D1049214 nr=3D1
> [    0.277082] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea0004009fc0 pfn=3D1049215 nr=3D1
> [    0.277172] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea000400a000 pfn=3D1049216 nr=3D1
> [    0.277257] __pgalloc_tag_add: get_page_tag_ref failed!
> page=3Dffffea000400a040 pfn=3D1049217 nr=3D1
>
> and so on.
>
>
> > I think your earlier patch can effectively detect these early
> > allocations and suppress the warnings. We should also mark these
> > allocations with CODETAG_FLAG_INACCURATE.
>
> Thanks to an excellent AI review, I realized there are issues with
>
> my original patch. One problem is the 256-element array; another

Yes, if there are lots of such allocations, it's not appropriate.

>
> is that it involves allocation and free operations =E2=80=94 meaning we n=
eed
>
> to record entries at __pgalloc_tag_add and remove them at __pgalloc_tag_s=
ub,
>
> which introduces a noticeable overhead. I'm wondering if we can instead
> set a flag
>
> bit in page flags during the early boot stage, which I'll refer to as
> EARLY_ALLOC_FLAGS.
>
> Then, in __pgalloc_tag_sub, we first check for EARLY_ALLOC_FLAGS. If
> set, we clear the
>
> flag and return immediately; otherwise, we perform the actual
> subtraction of the tag count.
>
> This approach seems somewhat similar to the idea behind
> mem_profiling_compressed.

That seems doable but let's first check if we can make page_ext
initialization happen before these allocations. That would be the
ideal path. If it's not possible then we can focus on alternatives
like the one you propose.

>
> I would appreciate your valuable feedback and any better suggestions you
> might have.

Thanks for pursuing this! I'll help in any way I can.
Suren.

>
> Thanks
>
> Hao
>
> > Thanks,
> > Suren.
> >
> >>
> >> Thanks
> >>
> >> Hao
> >>
> >>>> Thanks.
> >>>>
> >>>>
> >>>>>>>> If the slab cache has no free objects, it falls back
> >>>>>>>> to the buddy allocator to allocate memory. However, at this poin=
t page_ext
> >>>>>>>> is not yet fully initialized, so these newly allocated pages hav=
e no
> >>>>>>>> codetag set. These pages may later be reclaimed by KASAN,which c=
auses
> >>>>>>>> the warning to trigger when they are freed because their codetag=
 ref is
> >>>>>>>> still empty.
> >>>>>>>>
> >>>>>>>> Use a global array to track pages allocated before page_ext is f=
ully
> >>>>>>>> initialized, similar to how kmemleak tracks early allocations.
> >>>>>>>> When page_ext initialization completes, set their codetag
> >>>>>>>> to empty to avoid warnings when they are freed later.
> >>>>>>>>
> >>>>>>>> ...
> >>>>>>>>
> >>>>>>>> --- a/include/linux/alloc_tag.h
> >>>>>>>> +++ b/include/linux/alloc_tag.h
> >>>>>>>> @@ -74,6 +74,9 @@ static inline void set_codetag_empty(union cod=
etag_ref *ref)
> >>>>>>>>
> >>>>>>>>     #ifdef CONFIG_MEM_ALLOC_PROFILING
> >>>>>>>>
> >>>>>>>> +bool mem_profiling_is_available(void);
> >>>>>>>> +void alloc_tag_add_early_pfn(unsigned long pfn);
> >>>>>>>> +
> >>>>>>>>     #define ALLOC_TAG_SECTION_NAME       "alloc_tags"
> >>>>>>>>
> >>>>>>>>     struct codetag_bytes {
> >>>>>>>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> >>>>>>>> index 58991ab09d84..a5bf4e72c154 100644
> >>>>>>>> --- a/lib/alloc_tag.c
> >>>>>>>> +++ b/lib/alloc_tag.c
> >>>>>>>> @@ -6,6 +6,7 @@
> >>>>>>>>     #include <linux/kallsyms.h>
> >>>>>>>>     #include <linux/module.h>
> >>>>>>>>     #include <linux/page_ext.h>
> >>>>>>>> +#include <linux/pgalloc_tag.h>
> >>>>>>>>     #include <linux/proc_fs.h>
> >>>>>>>>     #include <linux/seq_buf.h>
> >>>>>>>>     #include <linux/seq_file.h>
> >>>>>>>> @@ -26,6 +27,82 @@ static bool mem_profiling_support;
> >>>>>>>>
> >>>>>>>>     static struct codetag_type *alloc_tag_cttype;
> >>>>>>>>
> >>>>>>>> +/*
> >>>>>>>> + * State of the alloc_tag
> >>>>>>>> + *
> >>>>>>>> + * This is used to describe the states of the alloc_tag during =
bootup.
> >>>>>>>> + *
> >>>>>>>> + * When we need to allocate page_ext to store codetag, we face =
an
> >>>>>>>> + * initialization timing problem:
> >>>>>>>> + *
> >>>>>>>> + * Due to initialization order, pages may be allocated via budd=
y system
> >>>>>>>> + * before page_ext is fully allocated and initialized. Although=
 these
> >>>>>>>> + * pages call the allocation hooks, the codetag will not be set=
 because
> >>>>>>>> + * page_ext is not yet available.
> >>>>>>>> + *
> >>>>>>>> + * When these pages are later free to the buddy system, it trig=
gers
> >>>>>>>> + * warnings because their codetag is actually empty if
> >>>>>>>> + * CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled.
> >>>>>>>> + *
> >>>>>>>> + * Additionally, in this situation, we cannot record detailed a=
llocation
> >>>>>>>> + * information for these pages.
> >>>>>>>> + */
> >>>>>>>> +enum mem_profiling_state {
> >>>>>>>> +     DOWN,                   /* No mem_profiling functionality =
yet */
> >>>>>>>> +     UP                      /* Everything is working */
> >>>>>>>> +};
> >>>>>>>> +
> >>>>>>>> +static enum mem_profiling_state mem_profiling_state =3D DOWN;
> >>>>>>>> +
> >>>>>>>> +bool mem_profiling_is_available(void)
> >>>>>>>> +{
> >>>>>>>> +     return mem_profiling_state =3D=3D UP;
> >>>>>>>> +}
> >>>>>>>> +
> >>>>>>>> +#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
> >>>>>>>> +
> >>>>>>>> +#define EARLY_ALLOC_PFN_MAX          256
> >>>>>>>> +
> >>>>>>>> +static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX];
> >>>>>>> It's unfortunate that this isn't __initdata.
> >>>>>>>
> >>>>>>>> +static unsigned int early_pfn_count;
> >>>>>>>> +static DEFINE_SPINLOCK(early_pfn_lock);
> >>>>>>>> +
> >>>>>>>>
> >>>>>>>> ...
> >>>>>>>>
> >>>>>>>> --- a/mm/page_alloc.c
> >>>>>>>> +++ b/mm/page_alloc.c
> >>>>>>>> @@ -1293,6 +1293,13 @@ void __pgalloc_tag_add(struct page *page,=
 struct task_struct *task,
> >>>>>>>>                  alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE =
* nr);
> >>>>>>>>                  update_page_tag_ref(handle, &ref);
> >>>>>>>>                  put_page_tag_ref(handle);
> >>>>>>>> +     } else {
> >>>>>> This branch can be marked as "unlikely".
> >>>>>>
> >>>>>>>> +             /*
> >>>>>>>> +              * page_ext is not available yet, record the pfn s=
o we can
> >>>>>>>> +              * clear the tag ref later when page_ext is initia=
lized.
> >>>>>>>> +              */
> >>>>>>>> +             if (!mem_profiling_is_available())
> >>>>>>>> +                     alloc_tag_add_early_pfn(page_to_pfn(page))=
;
> >>>>>>>>          }
> >>>>>>>>     }
> >>>>>>> All because of this, I believe.  Is this fixable?
> >>>>>>>
> >>>>>>> If we take that `else', we know we're running in __init code, yes=
?  I
> >>>>>>> don't see how `__init pgalloc_tag_add_early()' could be made to w=
ork.
> >>>>>>> hrm.  Something clever, please.
> >>>>>> We can have a pointer to a function that is initialized to point t=
o
> >>>>>> alloc_tag_add_early_pfn, which is defined as __init and uses
> >>>>>> early_pfns which now can be defined as __initdata. After
> >>>>>> clear_early_alloc_pfn_tag_refs() is done we reset that pointer to
> >>>>>> NULL. __pgalloc_tag_add() instead of calling alloc_tag_add_early_p=
fn()
> >>>>>> directly checks that pointer and if it's not NULL then calls the
> >>>>>> function that it points to. This way __pgalloc_tag_add() which is =
not
> >>>>>> an __init function will be invoking alloc_tag_add_early_pfn() __in=
it
> >>>>>> function only until we are done with initialization. I haven't tri=
ed
> >>>>>> this but I think that should work. This also eliminates the need f=
or
> >>>>>> mem_profiling_state variable since we can use this function pointe=
r
> >>>>>> instead.
> >>>>>>
> >>>>>>

