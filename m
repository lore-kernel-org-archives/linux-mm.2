Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFC42CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 09:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A73D6B0005; Tue, 19 May 2026 05:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1588B6B0088; Tue, 19 May 2026 05:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 047186B008C; Tue, 19 May 2026 05:43:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E795E6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 05:43:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9946F1A02A1
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:43:24 +0000 (UTC)
X-FDA: 84783681528.15.C83B6A8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 45D3E180006
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:43:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TtLgIlST;
	spf=pass (imf24.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779183802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5x571feKyCrxAyf039bp6xhn3Td73dplWB4PHAo5Mng=;
	b=KV2WXMvE01P9FzB0mXfV4Q0vutvQksieS4SSG0cmO882CdR4w7MigdtRjiGmEHQxQ4Q1Lf
	S26ilXHjGFlwDtNgIPDWx00nDLJyH5GxxIbg9vJhnbQPo3yn/C5IhaMSqhw3WcCe6fwAO6
	PS0wmeuKLvKPrmepM9idanIVM0EcTEw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779183802; a=rsa-sha256;
	cv=none;
	b=xizKoohmLpSaSmxj0bboio5RzMX4tY11Dnks6HiwhM/S9ywzHaQQKzcNmSBQXx5ybkyRgr
	58sfg6eSdDmew7wB1z0fhkstFBIUUZjp14Chv9JY20LmioludGP6EZe110mr5VQcPhEoCF
	SrDti7KAOXjtEyiCcMcUB/BUJsf6Qtk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TtLgIlST;
	spf=pass (imf24.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779183801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5x571feKyCrxAyf039bp6xhn3Td73dplWB4PHAo5Mng=;
	b=TtLgIlSTk0kRO9ZPvkrLDs9bgs97tSEGLHjqELywBE1r1nxKee7tyjOPXl+NA1uniPtiD2
	4n4OEGVnU3vAUFTvOKNO/5yAU3aUkfLHlQsMYidVeWmo7s8vS+gNudIRuY14GHNXKGmwL3
	NXmtRi3LU5+Fy0wTn6VTMlQMNF1t7Pg=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-W1gpmMkCOIy7YFcztoq8Rg-1; Tue, 19 May 2026 05:43:20 -0400
X-MC-Unique: W1gpmMkCOIy7YFcztoq8Rg-1
X-Mimecast-MFC-AGG-ID: W1gpmMkCOIy7YFcztoq8Rg_1779183800
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-7bd66ec877aso56654157b3.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 02:43:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779183800; x=1779788600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5x571feKyCrxAyf039bp6xhn3Td73dplWB4PHAo5Mng=;
        b=JDv+pxmj8dHtDxMBXnIAu1nDHO1w1Yq1whHPTDxhDFmKlywF2loLb9OiAdlwDogs84
         4GOgwWzpqsKv5ECH/QefXgi6IwSQLwj7wcpp2hjxXBIEgBnDpK9rF9Tzy6cxrMzEglo6
         E/uTU88E6/ZdtIV5rFZH+a33lGQBMax9+OmuwiVxGvh3PFJWXuBBs79w9v4XQ+mjuyPP
         OxK6RXMaqlKb1ra93/myGZrDJS92tA2feOUQMxUg/pfh31MClqicr4DbAc294nllJyHX
         r8dD3zariLvdUahjvz4yYkvxbnZTVIsIG3FS32EM3c7efrC+opHfQl5OKeJctmBM4FmV
         B3mg==
X-Forwarded-Encrypted: i=1; AFNElJ+D4UgWbRcxFNp+9NK2HKwYP7irR/LYYNA+JniN+unITeoauF87oMkDiDn1mVNxUtkRs7d1dLpDwg==@kvack.org
X-Gm-Message-State: AOJu0YxZrlC7H3Jo1OIRGwhsdn+58e+neusVh33b7lGN7rL7C48aXUv1
	xIyBjr8687Di+jYBoqNmIyJTca+wEqiszh+mct2tp4GeQjDkKEEKc7A5ZsHVTxVhWxJVzeUm5Ba
	XuJA29WJVNcaFIwG+7cB8UN1bN8eSxuFx06eKt8dd+YKyUguwauJuUxH0JsjwZSEO3J2bFBHWia
	WVhwdKC2sHpKxO4dWcrimLA5H+x8s=
X-Gm-Gg: Acq92OGAEt15J+U6AfUulFv0PnctbR1BPHkbwpBCX6sVAaEusCKA7o/Oq8DY0vk0AIq
	sdLfU5sWxGhDIQvJZxau2JBTlOptR82hpSW8sl2m/HJ85luiqnWFdThj62XCO3G/XXrBwgw77th
	PbP4wrz1D1an6CgPMh+7v2Sl/Z2Q0numxLZZVG2j+0ivRB2rZdAhCBHJyCmAQoTQr9K+m4NVFcg
	Vo8XQ==
X-Received: by 2002:a05:690c:6e81:b0:7bd:a63d:fe69 with SMTP id 00721157ae682-7c7e6586abemr212584757b3.9.1779183799599;
        Tue, 19 May 2026 02:43:19 -0700 (PDT)
X-Received: by 2002:a05:690c:6e81:b0:7bd:a63d:fe69 with SMTP id
 00721157ae682-7c7e6586abemr212584217b3.9.1779183799106; Tue, 19 May 2026
 02:43:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <CAGsJ_4xfznffbjOaNKwnN6oZk_H6pqOzYqd1zx4Q9XrocdzV8A@mail.gmail.com>
 <CADSE00LjJcL8P5M-UPEpzZijU70uEmUirnin29N8YR5W5D-oFg@mail.gmail.com> <CAGsJ_4xwJ7SAhKPJyRtMTw6psTO7H1EcFFpDw0po1W8PX4FE8g@mail.gmail.com>
In-Reply-To: <CAGsJ_4xwJ7SAhKPJyRtMTw6psTO7H1EcFFpDw0po1W8PX4FE8g@mail.gmail.com>
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 19 May 2026 11:43:06 +0200
X-Gm-Features: AVHnY4K6WRueJTIRx5g-aAlFuFoKaIp0iRf0U18smAauuYj52IGoBPbNpAKamXc
Message-ID: <CADSE00L00D7yi_DevNsZ8_=VXBVD2eO5FbcM+sv1ZdwgjaiRmg@mail.gmail.com>
Subject: Re: [PATCH RFC 2/5] dma-heap: charge dma-buf memory via explicit memcg
To: Barry Song <baohua@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Christian Brauner <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, mripard@kernel.org, 
	echanude@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IxXl-FfdTBbNbjzXo7mr5rLCFJae4MQ9h8gMRYoUG68_1779183800
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 45D3E180006
X-Rspam-User: 
X-Stat-Signature: kixfngqjgama3tei3ff7wt99x1b6o3ph
X-HE-Tag: 1779183802-570307
X-HE-Meta: U2FsdGVkX19XxGQgnBnP5iVuJrp+feMjsqL9lIK3q5zMPf8yKTgbQwV/WrnSz7kpeHid/VNeMscTB4feUJnX1ULx5jTi//AnlCcCDcLgc47nHfpbCwh8w5Ac5Slt0g97BCFYKXAjccM3k5MDv3cKAV+dRDIw4UoxNBsWzukyiSMZOmSZ8GwW4jUJzy8iG6MgAxBpgz0SHwi+fNj6UWsvY7tXQsRRrGLdrTNQsDkmzIde3EntggPZaFk1vgz/kXxaBKmOI6DaF4kfM/aaxtpkmYPm0FXzH4jeGYiVAcQSy6xIDC1SQaKxiaCpNPAdb6teXkCRjmFJ85n03cCj5wxKLF85X0lfNt2l/SuaidCTjJCH+Z0hFAzHdr6n6lKf++Kfy1Y0INS2wK58Lb2Ul2GwXA79KRuOeXtEnOFTOi2fkhUGw7KmDhjaEkD46xuSek20N6WUr4zneeA1ObiCX0Qy8Q5yY0Z3t/3dBXk+Xi1FrIolgrxBH+92L4zChDuxq6fVFSHNwk3mv3i9p2PUNy3WSZD36Rv0Z9BoY8aI8gmVSEJ6jkEz6K4eUCQ3bWepJTjvvzFccLdhm0pyQ9Vp7iGC1ATgIf0LiZ4fUYQB1oB8l/MaK3apOnIyB9LNc9xMAMRH2BFJ4gVSsUikFATVZdyfQ/JURiTGfipQ8pPhrMMjQBzUPjWi5dWnpFVdzEM8jPCuB5ib8CM1Qe87G51DiV/iQPByeXDbiO5biSjbCrzDk7D1B+LdDqwz5xK6Os2vrriDR1cAwKDlJFB7yybxxkgBBGvtLFKrs+vepzy5V80VSpf5q39rtadYynCn2j5u59Mud1630+33UiNnCgjWNME78x2we9oBHNB80QTZZ6FZkbQ7OmTop82PYbAtM2gWjB1qZVK5fFYARh++OfCch8a5KNC7GbRhk3TnryV6MYGSIdR0D5EM75u+agLUDxtoanyBk9t7gE0XDReYCZrdShm
 ArIsMs2y
 PQI/DZgHhcQ/BAFbIOvyUNfWeQmYV6/WaRt42aM+e9pzes1EOT0tMYVDpvsEmAbirdW8E8EAh9J6wvdvcAbujUII84EaO0uD39ewueO5MVvbDHUGHQjWkuJpZlIhimR97XZStcVqvfVls7vUyC6cNC1KGAjBaV5ZR2yH5KQry9d92gxvtSUGq4ICbgyV9oJ+UivW5D9QbMeg/oDus3UthMuRQh2kEBO2Jn1pz31yt6FbvVXhcX0GBcM3k3EhTLslYWl57aHcfqSIWd3BmU1jAq/rax+1I09L3j4KgccSzRHOqZU5BMD8jyp+Zr8/0Bvhr3ccFMNhl8J9mZ2SxgQeEfHZJnua7qwpKJiPKCwYqhlNElk4trdZj6juyz43b6LK9MjaBBWSE6ix/7U3TI8JllBwS8mpDPBuTg+mUNu8JWmcwvHw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 12:43=E2=80=AFAM Barry Song <baohua@kernel.org> wro=
te:
>
> On Mon, May 18, 2026 at 8:16=E2=80=AFPM Albert Esteve <aesteve@redhat.com=
> wrote:
> >
> > On Sat, May 16, 2026 at 9:37=E2=80=AFAM Barry Song <baohua@kernel.org> =
wrote:
> > >
> > > On Tue, May 12, 2026 at 5:18=E2=80=AFPM Albert Esteve <aesteve@redhat=
.com> wrote:
> > > >
> > > > On embedded platforms a central process often allocates dma-buf
> > > > memory on behalf of client applications. Without a way to
> > > > attribute the charge to the requesting client's cgroup, the
> > > > cost lands on the allocator, making per-cgroup memory limits
> > > > ineffective for the actual consumers.
> > > >
> > > > Add charge_pid_fd to struct dma_heap_allocation_data. When set to
> > > > a valid pidfd, DMA_HEAP_IOCTL_ALLOC resolves the target task's
> > > > memcg and charges the buffer there via mem_cgroup_charge_dmabuf()
> > > > inside dma_heap_buffer_alloc(). Without charge_pid_fd, and with
> > > > the mem_accounting module parameter enabled, the buffer is charged
> > > > to the allocator's own cgroup.
> > > >
> > > > Additionally, commit 3c227be90659 ("dma-buf: system_heap: account f=
or
> > > > system heap allocation in memcg") adds __GFP_ACCOUNT to system-heap
> > > > page allocations. Keeping __GFP_ACCOUNT would charge the same pages
> > > > twice (once to kmem, once to MEMCG_DMABUF), thus remove it and rout=
e
> > > > all accounting through a single MEMCG_DMABUF path.
> > > >
> > > [...]
> > >
> > > > -               if (mem_accounting)
> > > > -                       flags |=3D __GFP_ACCOUNT;
> > >
> > > Hi Albert,
> > >
> > > would it be better to move this and its description to patch 1? It
> > > looks like patch 1 already introduces the double accounting changes,
> > > and patch 2 is mainly just supporting remote charging.
> >
> > Hi Barry,
> >
> > Thanks for looking into this series! Yes, in my head I was trying to
> > keep patch 1, which was taken from a previous, different series, and
> > then diverge from it starting with patch 2. This would clarify the
> > difference between the two. But I can see it just added some confusion
> > (for example, patch 1 charges on dma_buf_export() and then it is moved
> > to dma_heap_buffer_alloc() in patch 2). I will reorganize it better
> > for the next version, including your suggestion.
>
> Yep, I understand the situation now. I also understand
> that you were referring to T.J.'s patch, which caused
> some back-and-forth confusion for readers when reading
> patches 1 and 2.
>
> >
> > >
> > > Also, mem_accounting is only used by system_heap.c; has this patchset
> > > also eliminated its need?
> >
> > No, mem_accounting is still handled in this patch for the general case
> > where no `charge_pid_fd` is used. See dma_heap_buffer_alloc() code:
> >
> > +       if (memcg)
> > +               css_get(&memcg->css);
> > +       else if (mem_accounting)
> > +               memcg =3D get_mem_cgroup_from_mm(current->mm);
>
> I see. What feels a bit odd to me is that mem_accounting
> could either be dropped (with unconditional charging), or
> it should cover both remote and local charge cases.

Good point. If I understand correctly, looking at patch [1] that
introduced the flag, the shared buffer caveats mentioned there are not
yet covered by this approach, so the flag should stay. I will make it
consistent and cover both remote and local charge cases.

[1] https://lore.kernel.org/all/20260116-dmabuf-heap-system-memcg-v3-1-ecc6=
b62cc446@redhat.com/

>
> I don=E2=80=99t have a strong opinion here=E2=80=94it just feels a bit
> strange, since its description is quite generic for memcg:
>
> "Enable cgroup-based memory accounting for dma-buf heap
> allocations (default=3Dfalse)."
>
> Best Regards
> Barry
>


