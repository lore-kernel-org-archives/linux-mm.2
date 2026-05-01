Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C430CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 14:29:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B16696B0005; Fri,  1 May 2026 10:29:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC6AB6B008A; Fri,  1 May 2026 10:29:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98F956B008C; Fri,  1 May 2026 10:29:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 831126B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:29:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A1B9C120308
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:16:53 +0000 (UTC)
X-FDA: 84719052306.13.63BA738
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3748740010
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:16:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="We6/J/fk";
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777645011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U0Id2xfJjyn/73uT0S8lwE8udvk16qyKJSuD4Abx5Bg=;
	b=ABeKZKIxRFV5mMqAF8kEGCy1IW9zLSVGF3GcCrdDBFjXERNOkawAF+GMGLagHFUCLcBUwM
	x9x0H3YchZwHvPQI2ewn6iX7OoKGzZOqNLFXoVCzIMmAdJzcdNQjPzDnefyouTjLE7pB0H
	Qm2Fgmh1So3xAx4h8pdBknw4YqQXaCw=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="We6/J/fk";
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777645011; a=rsa-sha256;
	cv=pass;
	b=Q5WZqsO2pps+coN1dz+ska1MmliLZYxFFh2YEoiUFxOuwS91fm46lsfL72gb4UmBJaBlGQ
	yMzcz4Y7wOPoZGfPdRmchXjCEGE/doPK6qyQiQBAPBQYDQL/CCanN71I27XDdW94D9/9lw
	EwYJGaXMJ3cHbUJ5xfRoDYXlDRP28Og=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488a8ca4aadso22792705e9.3
        for <linux-mm@kvack.org>; Fri, 01 May 2026 07:16:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777645010; cv=none;
        d=google.com; s=arc-20240605;
        b=NYywJwlXlE4Lctb7O7nlO9YNFKaFqXkgb/Rs+36BIIlW0qBo8EBmBTM32bUfegfYmo
         26CHKUd+KdElJlwVlAzbtlDgSOI7INeuEWhWC/0/t6pjPtPxdPCoFD7cq376bzpb8ux5
         vJ7ZixDmO7ZFh87T+G3mhD2LV+mtwrnlgLa4+AvOAE0VlrCDM1/IVrlAa8rCGpNj3t8b
         2uUQT5fePaLI5bLiekmuOI30CeYHM5Kv5Y3PYMRwGPcKBEqb6Ie7BCPsVBNc+awD89tr
         zp7zzBczKdbQgKvSGIUyNDBeS39AfMvnVCUHUW00dm8DoYI7Nzux+nDdamJOV0an13Iv
         i5Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=U0Id2xfJjyn/73uT0S8lwE8udvk16qyKJSuD4Abx5Bg=;
        fh=Dvv7mZT0n7vT8edXmfOoMIXbKjCsMAKoEiOGbYz+GiU=;
        b=A29XzIcJdATR6Jw3LG5k++yU5wk9gHV2MN3qrKeN4MRsXUSOPCKJ0UXw0oP+u+liyj
         SNZ1zOa745ZOsU7eACJgu5qM4bw8kgVkDk2PrqdyaqtFfhnk1bKJjNlfesSK+xP6WOpM
         E5iAMtj+w007sAZqly/kaKs3LbXB9ECd//QPHgMpkGE0KRVgoUVSP1x8V8HJfc73+q5Z
         GBt3H8d0kEk7DYh9tcE48cJ4TDQ0dd7gjW+8IoOL1dx/b40MhZqBwBU/FiwTBR6y5BQR
         GsLP460QeMtl+QYtIeg/bJmSm4kvARlTmixbOD7iPI87BmfHS8af3aB+Me2cwLUKpfX4
         EwAQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777645010; x=1778249810; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U0Id2xfJjyn/73uT0S8lwE8udvk16qyKJSuD4Abx5Bg=;
        b=We6/J/fk0CaHtocONb3aUd4feIP7mDZvsFvH4DRrJh/yYnOrbnjWR3kM4q1rg1ItJj
         eIaOUd2Wi9QZfV0nxkMM+s+Ye7gy/b0bA6nMDfRYB6/i0Jk+SI+oCI+VhrvoeBeAqTBe
         VFh5RhFwXE/0SGXfagiQs3MeCJFPsj6T3Ni4Vcb7avEgyS8VMJt/BWP0L2w216J5cEg9
         sY/TOFc9fc2itb/eJlB5HOrPvOQ4Xwn4ZHqLLukG0OE5RMAaCPvcXD1arNCCqW3pu1mU
         7UZ0vS49Hs0dhPhoN3OpqGFiCVTjx600UCFqEtI27LrNnaKp05nkl3uOzsHALWM1M5JS
         VUkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777645010; x=1778249810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U0Id2xfJjyn/73uT0S8lwE8udvk16qyKJSuD4Abx5Bg=;
        b=rOcc6aRAaqu5F8tujMJ1RNwrDANJsj75IJpWIk/zhYsIFHpmsexN7UmsGdufamIOze
         Li8q08wHDqePrtXNMrnG6Q0Un48ULkWyLpFc0B6PEWWb1+HeL0w4hu55WATMF2fHQ+Pt
         tjzMiGCBBHWUDhp7/mZJTLzjFvHBXP701fR0zgYssDvZMrQD7F6aD0D6fB20xt9vvn+q
         WX34cggQqGQgUcGXEsCI93oJOotTZcnYSDl0fgLUsF5zrNgkKMwVioh3CkP5hv+rEFIO
         J/Ou0+fVwJ1swCcf4seoJwRXSZp7LDrrOxA798E1kBMGIPrHLqyBFx/DoNAbfgLHEJ/c
         U7DQ==
X-Forwarded-Encrypted: i=1; AFNElJ+XgTA/q9C8YsUd8t1SomrPU3j3xZtmueFcAgUltXjrvmi0THcINtr49j/yvJJVKlpoTU7GgTDwIw==@kvack.org
X-Gm-Message-State: AOJu0Yw38QA5SvbQC+a18mfKUbaBjUr5I5t2DxP3hjrtbqGIO/dTDYqm
	jQdKcKiIjTKTK4/dWn3OyBJR1boCXSX9T9LMVhabvMozpTukwcJlcC8YH4UdIMerobY7fxwBl7e
	jR2FzFXKnGSinQgMfw1oPfn01Gqy1O80=
X-Gm-Gg: AeBDievC5q6XtSaRfldWml0ybbU7AaEKhAAn3tAJuiBBvEBdWxXZ5d94gLq/0Pstd4v
	9VeN0KSkr+lektcwzFSwRV3u/8e4kom45YuecbxqAMNqNu5aavGPX6LH2rUsZhRUWIfdThVcBtS
	U/P884clZnouUYZ+R8rAFPI1kd/ooR3cNWabMSDBDZxG9wrSc/QaOEnxKT3MEEpq3OA2OxZbV9m
	GvxtboIAK1XArlzUq9ofJ5xCNPTj7v4YN9yQyKNIzhUb0XcnCTTi1UC46VMyKm3PBChAPolAsVD
	RlYN90RYTSGTdJZhPN05KfpPRIWxlivJJXxU54J8CzCHTMPwufDZ6zAU1NHbTp4OJw==
X-Received: by 2002:a05:600c:4a9f:b0:48a:9562:7a30 with SMTP id
 5b1f17b1804b1-48a95627aa2mr9093625e9.24.1777645009250; Fri, 01 May 2026
 07:16:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <aegUoOiUbjUAH5aT@google.com>
 <CAMgjq7C53WRS5oYxO157mX7JxhfoPoi34k+taiKLrMah-b-iRg@mail.gmail.com>
 <aektdlD4npMVThu3@google.com> <CAMgjq7DRrz4Hdy-s4y-C=3BmPt50LKOfdWjjf2mWmCybdRaJ4w@mail.gmail.com>
 <CAO9r8zPvApgxKiVy5NhiWup_m57huF3MTuPvo=iq5kAxjRZC8Q@mail.gmail.com>
 <CAMgjq7AGzBubCkmv7LubBjPLN1DzL472d4zUm+sGxo8ZptMgRw@mail.gmail.com>
 <CAO9r8zO+tm2J0FRC64VKCYOSuKPXX8cQG7C07SwMWKoLiwoV+w@mail.gmail.com>
 <CAMgjq7D1WXUHqAV1yuXvrUmEsE_m_+yx0mBq6teJhipx6mySbA@mail.gmail.com>
 <CAO9r8zMk7xTi-Txmj1+Z9=250fD8HuMQFyT1iwjTW9coLXgqoA@mail.gmail.com> <CAMgjq7A4+Sac9-CYkig1LFfEh5rq-4vLka8AXREei_m3svzJ7w@mail.gmail.com>
In-Reply-To: <CAMgjq7A4+Sac9-CYkig1LFfEh5rq-4vLka8AXREei_m3svzJ7w@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 1 May 2026 15:16:36 +0100
X-Gm-Features: AVHnY4JpHB4eIrG5SgzyWnvdTJaCS5EqLLry8xKYoE_XxqUlALfldRFV_NWt4b0
Message-ID: <CAKEwX=NR5dkKduTPwDHWiSMFwJ9ZmvindFvUNbPgQu690W_m+A@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Kairui Song <ryncsn@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, akpm@linux-foundation.org, 
	Alistair Popple <apopple@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Baoquan He <bhe@redhat.com>, Byungchul Park <byungchul@sk.com>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Lance Yang <lance.yang@linux.dev>, lenb@kernel.org, 
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Matthew Brost <matthew.brost@intel.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Mariano Pache <npache@redhat.com>, Pavel Machek <pavel@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Pedro Falcato <pfalcato@suse.de>, 
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>, Rakie Kim <rakie.kim@sk.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Suren Baghdasaryan <surenb@google.com>, tglx@kernel.org, 
	Vlastimil Babka <vbabka@suse.cz>, Wei Xu <weixugc@google.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Yuanchu Xie <yuanchu@google.com>, Qi Zheng <zhengqi.arch@bytedance.com>, Zi Yan <ziy@nvidia.com>, 
	Meta kernel team <kernel-team@meta.com>, Rik van Riel <riel@surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3748740010
X-Stat-Signature: 7js8yyuzipt63h1ukkpga34ix78tfszi
X-HE-Tag: 1777645010-915242
X-HE-Meta: U2FsdGVkX18f2PZj2j6HkcyMAIPMEteW5QE2n/1kv3WNyRXGJ5nlxL8/IuOd4c3FtKwn1Msdb9zvqJVynR760h0LLhF12ZS4WEhlw1eRp021R1XUVz9iwBgtXHhA4uTRZn0WLpc9Z6lTxPS/PTXIoYob4AXLm8svqCf88tqSiBcuR3Sux7HVnsCheaBD9HVAfZNZvu8EMCh3jAI7ihuu5HvVsfTheuy27f+0GQf32aHi7GzdRQqzWKxk6buoxj5bUd+8nAs1Ia0MpijqoU0wpyoHhyst/ScF9IOIyS7JRmD5NulfDQ3KkoEDi7fgujgNS65fHOR4gPW14ypQDnU9XFLcXvwblTtXSq9anBCgUDO6UJr4Uf8mU5VmwYmboa3CJSmlRbGkip68YIFveg8TaD3xIwl69izoCbiiqkDbQHf7QSoSeizV82bJ2XcaKYxC01Z8QrXI7waykwoZ9em3ksxRMtZ/m7fBDtqolp5lg+J2N8lNYPphUz/6XMpz1oH70dqNeL1fX8o7tngzSmzSGUw6I2M4xzdypKmpO9oVSwvSfDHLzsY7bSWd4D9gCwTzo7qoBAjxwTPkL8jOY0GVciaJ7EdwBEUYdNm5VyCg6S7DqauCEWHdlNYM+YCpsisyVbtw8y8rCdefePZGS4Tq0YPD1cONAru7lP1pESWX7XCI4cytjGQaDC6eueLSq11cAFFI/IrOLomd0YjCN7cUxnJKwNy1atNHROJh5/zvHI56YrYh+DArVAWNG8a/V3pkes12ZLszMGRU7PJ7hB0qSTq4iJvZzyoX6b4WJj1UA1uVxPou4tItqirEmcvHmViLwRHtM5nIneC7IQceC8acOVb9hvcrAt8tM7mHMdSOcEho+2hTqo8hEuGd4IX1jF1dwLqDSLg40JvKRqtC5kfpDz9Qw9rMfJIu3xIvVo6xNp2DxbhRGcHHKab104VOCkBG8//13Ss+AMVrjL9R3yo
 hu6Yqvey
 D9hWXlUfK+s42UpNQDYAYaukL/p0RfLZ8OUsiN8qpB/3PiBwee6vpzmLljt6l0jDJ1qh+jjxTW62H4B9MrnXxKiljgFp6+HnoPB81Q6McMkBwupiVMZdyMYIek5wpSySj3dwENkX6alzX4Hq/xgb6/YcCHVHR1PZsXnBF7iOwuIHcvD09hxQ4fyzve4uDVm+AkgVhqCBz896mhsyv4uZau90F2ZgqJhattA+UlgMDi+Nc847hM3MavD1vurBV+11dwnifPZUgzNEKAwTPpc+/0kUjkfD99stmn0xfgV0L4Ro89RgN0lnK71Au4xMB6YPsvMZFOoLBKWJZZlzra6W3WrfWF7xAHV7xb9FJFYl3uKiBhqXg6VUrvVLZyYaiZIuEUDbZnIaTAFwwQ00CN5yWqFgw40hgssPHRr3jolzMWEPCwPHJJq0e98rbpK8f+FM2RMoFNUyStkyX3OkjjO2pXjJTBe/O5GSVMMQEFepG/aD51dl3782gWx5iu9MpJnZKUAdfIVPegevdFYL+SFBngcTw6tZkIF0gphONfwHdFq8DZ8PLXbXCNNYoLJALXJv8T9epgDtRi6BgwwHfVDa8qJ/DzDW/LXhn2kIsRsnpcJg3X0agIvwhWZ4wFpx4tx5QiqLZXOWSLikz0E+xLJG/OarFBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 8:52=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Sat, Apr 25, 2026 at 3:12=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote
> > > https://lore.kernel.org/linux-mm/20260421055323.940344-1-youngjun.par=
k@lge.com/
> >
> > Does this do promotion/demotion of swap entries?
>
> Not yet, let's do things step by step.
>
> > > For example just reserve a type (e.g. type 0) as the virtual type?
> > > (type is really a bad naming though).
> > >
> > > The that swap file (or swap mapping) will be
> > >
> > > I was trying that based on this:
> > > https://lore.kernel.org/linux-mm/20260220-swap-table-p4-v1-15-104795d=
19815@tencent.com/
> > >
> > > It seems to work and the only thing we need is actually just somethin=
g
> > > like this one in VSS:
> > > https://lore.kernel.org/linux-mm/20260320192735.748051-15-nphamcs@gma=
il.com/
> > >
> > > This part:
> > > + /* fall back to physical swap device */
> > > + if (!vswap_alloc_swap_slot(folio)) {
> > >
> > > We do a folio_realloc_swap if folio->swap have type 0.
> > >
> > > Which means, if there is no virtual device / mapping / file / space
> > > (I'm not sure how to name it at this point :) ), the ordinary swap
> > > routine is just still there untouched.
> > >
> > > If there is one, and it's being used, then, it is still the ordinary
> > > swap routine, just do an extra allocation (and the extra allocation
> > > strictly follows YoungJun's tier rule), which is same with VSS, but
> > > everything is reused. From a user or high level interface perspective=
,
> > > this can be designed with no difference as VSS. Just with a few
> > > bonuses: being per memcg / task / runtime optional, zero overhead if
> > > not enabled, and reusing all the infra.
> > >
> > > BTW this deferred allocation (in VSS or dynamic swap mapping, similar
> > > thing) is actually a bit concerning to me as well. It changes the
> > > common swapout routine and maybe worth reconsideration (e.g.
> > > activate_locked_split and mTHP stats is now ignored?), being optional
> > > for now also seems safer.
> >
> > I am not sure if I understand you correctly. I think what you're propos=
ing is:
> >
> > - Page tables either point directly to a swap slot, or to a virtual swa=
p entry.
> > - By default, page tables just point to swap slots maintaining current =
behavior.
>
> I mean, they are all swap entries, nothing special from the page table
> side. Swap subsystems handle things internally.
>
> > - If we have multiple backends (e.g. zswap or tiering), we use virtual
> > swap entry instead.
>
> Actually that can just follow the swap priority, or tier rule. Even if
> virtual mapping exists, it can be bypassed. e.g. you have a large NBD
> and don't care about either fragmentation or compression for offline
> workload cgroups, then why use a virtual layer for them which could
> double the kmem usage or spend more CPU? Setup is a different issue
> which can be discussed.

I assume NBD =3D=3D network block device here?

If you use a NBD, I think vswap overhead is not going to be the
bottleneck here :)

And, what about reliability. Say you allocate a slot on the NBD, unmap
the page from the PTEs, then proceed to swap_writeout(). What if the
NBD device is no longer available? What if IO fails? If you already
encode the physical swap slot location in the PTEs, then it's very
expensive to correct this mistake. Whereas with vswap, you can fall
back to another device if you so choose, and all it takes is just a
simple backend change at the vswap layer.

Another issue with the current physical swapfile allocator is that
induces physical contiguity where it's absolutely not needed. I don't
know if this is the case with an NBD, but for flash device for e.g,
obviously contiguity makes thing more efficient, but it would be nice
if we can fallback to discontiguous swapout as a fallback.

I feel like NBD is an argument FOR virtualization, not against.

>
> > - The physical swapfile has clusters and swap tables (status quo).
> > - Virtual swap is implemented with clusters and swap tables in a
> > virtual space, and each table entry points to an underlying swap slot
> > or zswap entry.
> > - If a page table has a physical swap slot, and we need to do tiering,
> > we basically "make it virtual" by making the swap table of the
> > physical swapfile point at a virtual swap entry? or another physical
> > swapfile? Not sure.
>
> They are still ordinary swap entries, nothing special. The virtual
> space is also just a ordinary swap file (or swap mapping), which is
> easy to do:
> https://lore.kernel.org/linux-mm/20260220-swap-table-p4-v1-15-104795d1981=
5@tencent.com/
>
> Then its virtual_table will have a different set of swap entries. (I
> left that part undone though).
>
> > > Right... I mean with two layers you will likely have >16 bytes
> > > overhead, and double lookup.
> >
> > Why >16 bytes? Do we need anything extra other than the reverse
> > mapping? Also why do we need a double lookup?
>
> You will have to store at least the following info: memcg (2 bytes),
> shadow (8 bytes), count (at least 1 bytes), and revert mapping (8
> bytes, since you have to address a full virtual swap space). And some
> type info is also needed. Part of them can be shrinked but still,
> scientifically, merging two layers into one is considered a kind of
> optimization.

Optimization is always a worthwhile pursuit of course. But you have to
gauge it with what we can buy with a more flexbility design, which
might end up buying us more performance win down the line

In the immediate term, vswap buys you a dynamic compressed layer +
maintain the ability to write back.

Looking a bit longer term, I don't think you can do the following
without a layer of indirection here:

1. Compressed writeback.

2. Discontiguous swapouts. I think we need this as a fallback for THP
swapping (see [1] for the discussion).

3. Mixed backend swapin.

4. Optimizing swap IO - if sequential patterns matter for example, you
need the ability to delay or change backend allocation. The current
model is way too inflexible to allow for that.

5. Adding new swap backends. We want to decouple what the MM subsystem
needs (which is minimally captured in the virtual layer), with what
the backend itself wants.

Youngjun's paper is a case study for what you can buy with virtualization:

[1]: https://lore.kernel.org/all/6869b7f0-84e1-fb93-03f1-9442cdfe476b@googl=
e.com/
[2]: https://ieeexplore.ieee.org/document/8662047

>
> You need lookup the virtual layer, then the lower layer for many
> decision making, is was discussed before to introduce more cache bit
> or things like that and I think that is getting over complex, reminds
> me of the slot cache or HAS_CACHE thing...:
> https://lore.kernel.org/linux-mm/CAMgjq7DJrtE-jARik849kCufd0qNnZQs7C8fcyz=
VOKE14-O+Dw@mail.gmail.com/
>
> > I don't think I quite understand it yet, maybe I am the problem :)
>
> Haha, not at all! Blame me for the poor explanation. To be honest, the
> design is still evolving and there are definitely details that need to
> be improved. It's hard to discuss these abstractions purely in theory,
> so it's probably best just keep the works moving forward in a clean
> way, and make things simpler and better be opt-in first.

