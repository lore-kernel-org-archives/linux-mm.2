Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79215F9D0EB
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 17:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB9626B0088; Tue, 14 Apr 2026 13:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A91DF6B0089; Tue, 14 Apr 2026 13:23:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AD1A6B0092; Tue, 14 Apr 2026 13:23:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8AB136B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:23:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2B478E15D5
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:23:58 +0000 (UTC)
X-FDA: 84657834156.27.885C832
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id 13CAA10000B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:23:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kmak8lhQ;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776187436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dp82XmEr+jeti4TR19n6W0flGrbWCgKnTbsqPQVkS+w=;
	b=zLaRIUN/SWNI0wQOcmw5JrcOggbqDK1/u9qrKBoFH6mUHfx0mPcYUSgZgJjj7qtDxe+rcx
	kDo+I3zzzeEBIu4nwZ64SC78sSSh4RKSYDIvw3RerGNV7qlH2FvtLxbRQoMe8G0oKDKxXw
	asH+YYawAi2d4CDKCEhcXqpj/hppnBc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kmak8lhQ;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776187436; a=rsa-sha256;
	cv=pass;
	b=rBoK0kEvnZaBK1XWed36wMR6M/1LjsLIF2dEiFxuocD5HrjNIxTmMl5vQkeLhJvH0FwH4y
	1ck8pkjpDdCKnhJrBS10FRCiy7tc4ZFcK2EfdDOyRjJZ17IJIp5Jk0h4HHZBcEufvgcb7T
	RkGr7cPmstqV4sxOGrMnG5vEFpbJPus=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43cf5ad500fso4951224f8f.0
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:23:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776187434; cv=none;
        d=google.com; s=arc-20240605;
        b=YA1K+3UuPARrfsGDG3VZMJDQqYhmFevngJvjJ14JzElWWvnclBzZ5XVo57zNexyAwN
         4IDadz7OzQ/mVyPLhghGgNJyqB878r7YU+5i59CLIC341Meh1r1BauvH5591v9bnPZ8s
         NuVgcMkYkSyZ3ODJNs2FwIoDvDvqEHrc90q0AzTHYecnIOwyC22rfpGe+X4ap+rZAGq4
         QFvLbd2S0UiKRkgQ8Ymhl0SJDaq1HppqqQaUsO6s0MDxjuniMlUbk/8+RXnQh2x1A/M9
         uQbC8y8Cn1W1dsvVyxmD/2+2Hp1ZYTiNfIf7xFNoDNrVJr6j1p73rXzkidfXEeJKV9rY
         xkIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dp82XmEr+jeti4TR19n6W0flGrbWCgKnTbsqPQVkS+w=;
        fh=zTCvo73QbLqTAeBwo/ZoQaVkO5jHabxNhz/DtUvxOOc=;
        b=THETPpQXhPMSQqF6HqevGEuO+yrgJ1jtPLWyEXMXLwLtXjtzLAkiiNMG6szdesH1Nj
         CgwrZx4Zc6u0oOgEqvAFfSDB5qYfUVLc8XYDKKlrAQ5InyaCrEGPGlyUflloKkUgLBz0
         ylipNPzr1DtjPAZXkx46osgu4vlgFVCoitDcK4CThsKT/NmvOiyuKlC7zNJFP18XBd9s
         qMvGqUWB8ZeM4qFR1XAejAFPUCRzRUdxfZq7f7+ZeJTbJc9hborYELQ1BDgEvRXjaVkE
         B93KBbPUUKqs0WDzpyD8uJ2pwDiWGER/TSlXZYbEOhJtAztTpFBsPrdfgqlqLdrpKRMT
         bFjg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776187434; x=1776792234; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dp82XmEr+jeti4TR19n6W0flGrbWCgKnTbsqPQVkS+w=;
        b=Kmak8lhQsmfBzvAnocOGzK8bLxCq1wo3m2EyDaqVrj2Up8KLXgcss6DCFnM+qvoFA0
         vRF6rMo+2noud+zYpuZoayI0yOIhVrLL81yH6S9/+g7HIHJi5gi37Myg3NxOW5T7w8hy
         GRnix7EQ0vDngvSglSUB+4eYvD4e6FAnj6p+ev9r0xkvcY8Z0qQRXJoWff9wVczXhopz
         TJ00nqnEzD0AGYLuXDjMG8IaUdxYzPsyn7esfRb/UzJqAI/zXKRWWE7Myrgnanw/25YT
         ITNaW4oDGClKX4dwueCs3a5auyYhUOn8sdZB1mz01PKkORTiRVP4EC41YqezP0+tuM0K
         JESg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776187434; x=1776792234;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dp82XmEr+jeti4TR19n6W0flGrbWCgKnTbsqPQVkS+w=;
        b=fPPdd47GjCEfSvJXtKGPmrsAIyTb+vyFIFkhV5luRZKp7sIXXNjEAzE4Y4RXuVbNSn
         +P8oCETxFU2xHuWnHIzW2eM83yWx1nLkMVg+svAjuri2CEkmq/hvtH4W/xSv3LjCQG11
         pt+3Sl093MmTF7fkOGFM6YhJv14Wj79srrIQKJQHws7zhkVYZvGGull0V9u6cyMzOMwF
         aOWSYQK6F1IqEpMYs0iQhWnLssQjyWiNy4z0gftXpdHbB0Vul9IfIiKb04asoxBIZbFS
         NfbIdC7XcEdYg6WOH7TKWGVDzkXknvWr86inKI89i9z/LPvbZmNvOp8V+TUzZMwdTWRd
         pkKw==
X-Forwarded-Encrypted: i=1; AFNElJ+0/Qkx/7IN+q5ngSrFkj5zpFAn5dcfjhxrBu+BIqiCNU3lMQAPwOwSOyHp1iMLq1kpqw/GLqvVIQ==@kvack.org
X-Gm-Message-State: AOJu0YzXeDAme70d2H0XaaWfgQ0V31ANDI2h1XoTv1VHerdZl3DDi9U6
	o+iQzFKAgWPctcb3qVh1ihQA/G8zD6yk++5NTYv4Q3Lz0tbKiH/8e63B8wdUl5FJyvszaAMBKEB
	TN+LGWLEwKesEvKi/ChKtksq9cQCXztk=
X-Gm-Gg: AeBDiessdIOAeBWuXfgIco6Ql4Shd2n7KJ1ZJyVjby5p3Z/AqOKw2swH2uAapaALLAP
	pkOQjfCws0uT4Pp11k3qOhMehV3NnRFR9ax4IPmHEWUhdO72S6OB6jcCbv/UbK8i7mCv641ITO9
	iAdvTLepcfXabn44h0aREsqoQjxJ0zmHTz7+u/CecDMEzOOYM4i2kQHbmDWAvZjNOUJqSM4obmG
	Q8N8Kzq7huZMqATxC1IkCrTRZ/81qN+Kbkyslqnb9dR8MOsrCytCfJgtDPQCLzqZZnkvd2ijxfC
	tpk47SBWyvwyjInO0p9y5yas3yVMAkz0hpYX/uo=
X-Received: by 2002:a05:6000:2211:b0:43d:2f92:633f with SMTP id
 ffacd0b85a97d-43d641f97aemr27791434f8f.0.1776187434027; Tue, 14 Apr 2026
 10:23:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <CAMgjq7AiUr_Ntj51qoqvV+=XbEATjr7S4MH+rgD32T5pHfF7mg@mail.gmail.com>
 <CAKEwX=PBjMVfMvKkNfqbgiw7o10NFyZBSB62ODzsqogv-WDYKQ@mail.gmail.com>
 <CAMgjq7AzySv801qDxfc8mEkEsFDv4P=_qw0rNOTe0n+qy7Fz6A@mail.gmail.com> <CAKEwX=P4syV38jAVCWq198r2OHXXc=xA-fx1dk6+qYef6yzxWQ@mail.gmail.com>
In-Reply-To: <CAKEwX=P4syV38jAVCWq198r2OHXXc=xA-fx1dk6+qYef6yzxWQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 14 Apr 2026 10:23:42 -0700
X-Gm-Features: AQROBzCvQ2Y205EwGC1lGKq27IJDyjI-VHhfD6X3kasimC4o5zGPGqT7idYCq1M
Message-ID: <CAKEwX=NrUhUrAFx+8BYJEfaVKpCm-H9JhBzYSrqOQb-NW7QRug@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Kairui Song <ryncsn@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, apopple@nvidia.com, 
	axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, 
	lenb@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev, 
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com, peterz@infradead.org, 
	pfalcato@suse.de, rafael@kernel.org, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, 
	tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 13CAA10000B
X-Stat-Signature: mudxyfmhk7tg4d3zz4fr98spuignbe3e
X-Rspam-User: 
X-HE-Tag: 1776187435-568023
X-HE-Meta: U2FsdGVkX1+fXETFBj8deyV029zP4yMT3b/z+p95irjlDbg4YX8WUFP6SUB8HWScE8focCzVID5WTc2BsPmI9j6jgWe9mzI2BAWTmUDs2iX3z5nkRkJELCbBAor/AzPYD8YWneulcrtsWHbhmGkwkkgqmrdp6cbDFFIvvo4EWofTuT2VO7P9h07WF5hTNSLeFVyvNVqM1NTPxVN3RBx6Mwr6BT/rarLQfQVZwboPZAkfy1McokwMwXnxAD1iZtZrbbVnDVLuWggFcQX1CoraK5+OUd6jR5rCe2q7ohPNXI0jOvV+8PGUUBI47I6oE+CtgDWYLMng5gMNz1pvWNkzZlzJNWJnxQ5wsl8llB0xJ970rMxeYszIOkSJyK3qng5x+VkmypfJ8B7E3O0xBUCJX9WAcOV6SFimH8xV3OiuNmyAlWhtEYUA9Yu/6efu/BkFC6aNbJmbsQRnl7LfTwsXYrCMHtBQZk78wYKo3bxdo+KqvgNoQ1FOXQL8ufqdVJs+BwR+5rN+sZdcZg1YuvVTEjDb8ubn8pxTbx/0q13FQU2vHVLrpRMvxT4V6H7ufhHLjTFrLS1an9nxlWNK+G7a3wFTYVfdEfmtAzIx0sTeEsOeI+whJZP7zkwLXDtSTM+Bl2ydGh/F0gy8IzaC+Ynla9ialpVSEyXKgS/b2tphsXAjxrn4x5VZhmgQEcBofCVRAUqFIUIgF3Gsj9TwGQdjEiGJ9gfEioMpTQwiHGgwOoqNB19EuvdugnjD5QRTLqrEPEgFzuyNnIJVvnS7sfrRAwTP+2brBFdgdmG5uMQJPZ4J53xZN9SmQFfwmd+MkH6g7brgIwJLruKHBbtqYC5JQLSLLVAJzEchzaJ9TfqE4txW2H6elxl/m0xsPUEUdSZ3eBPzXec/wifCRLUEKduYyfL6kPO3Xz+J2IXjZtPMZ7uCFGgVN23uzZOOClQANvYI4PrqVVEXq3ZEvnOwseM
 FBosfpjX
 DVAtvXpC8Yp4nQ39rLJMi3+hp/3irUGq1niYPuf9EM5iwqO4Js6xLvBBK6TMvj1z0mSHXsXe10Lae9cyjR9yXgYyPT87WxlEwCiD/uF5RU9TA0SUuORnHAaykVYBueDrTlg42L/eaXywL/u+rgOijFpM8HSpAHfdNXouZwRbTAI1fjCpuzbR4X6mRGyT/M/+WJoD+HiO/vDAnk+delVz1sekCCjjxrL4R+K5EmwSR8IGxXRO+EQEHbnh9QfTsfjIpkRqdA3bWBGc6klXx3V4p9tTev8RgKJb0KQ8lYtiC70C0IuQm/XvGsd9IIWA0xn+s0uKTgVmlP1zUg6DdBSDhL7h6qlatmS6SVQ3f9MOBg7vR1B4ZpFUcaXIFoLbhZpZGmQTAjgNZCQbEq3Mv4cL05S6j3ZPOCncWgeZybb1CZk49TUI65vjmkULJ9TX896Y5qwsgw2AYUj2Lx4qy3lDqgC7oW/BpjxkVlI4EG/1jrR36GKE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 1:05=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Mon, Mar 23, 2026 at 12:41=E2=80=AFPM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > On Mon, Mar 23, 2026 at 11:33=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> =
wrote:
> > >
> > > On Mon, Mar 23, 2026 at 6:09=E2=80=AFAM Kairui Song <ryncsn@gmail.com=
> wrote:
> > > >
> > > > On Sat, Mar 21, 2026 at 3:29=E2=80=AFAM Nhat Pham <nphamcs@gmail.co=
m> wrote:
> > > > > This patch series is based on 6.19. There are a couple more
> > > > > swap-related changes in mainline that I would need to coordinate
> > > > > with, but I still want to send this out as an update for the
> > > > > regressions reported by Kairui Song in [15]. It's probably easier
> > > > > to just build this thing rather than dig through that series of
> > > > > emails to get the fix patch :)
> > > > >
> > > > > Changelog:
> > > > > * v4 -> v5:
> > > > >     * Fix a deadlock in memcg1_swapout (reported by syzbot [16]).
> > > > >     * Replace VM_WARN_ON(!spin_is_locked()) with lockdep_assert_h=
eld(),
> > > > >       and use guard(rcu) in vswap_cpu_dead
> > > > >       (reported by Peter Zijlstra [17]).
> > > > > * v3 -> v4:
> > > > >     * Fix poor swap free batching behavior to alleviate a regress=
ion
> > > > >       (reported by Kairui Song).
> > > >
> > >
> > > Hi Kairui! Thanks a lot for the testing big boss :) I will focus on
> > > the regression in this patch series - we can talk more about
> > > directions in another thread :)

Hi Kairui,

My apologies if I missed your response, but could you share with me
your full benchmark suite? It would be hugely useful, not just for
this series, but for all swap contributions in the future :) We should
do as much homework ourselves as possible :P

And apologies for the delayed response. I kept having to back and
forth between regression investigating, and figuring out what was
going on with the build setups (I missed some of the CONFIGs you had
originally), reducing variance on hosts, etc.

I don't have PMEM, so I have only worked with zram backend so far. I
did manage to reproduce the regressions you showed me (albeit at a
much smaller gap on certain metrics than your cited numbers, which I
suspect is due to zram/pmem difference).

There are two benchmarks that I focused on:

1. Usemem - the exact command I ran is: time ./usemem --init-time -O
-y -x -n 1 56G

My host is 32GB, 52 processor(s) / x86_64.

Build        real (s)          vs base   sys (s)           tput (KB/s)
       free_ms
baseline     175.6 +/- 3.6      =E2=80=94        121.9 +/- 3.3    391,941 +=
/-
8,333  6,992 +/- 204
vss_v5       184.0 +/- 3.9    +4.8%      130.5 +/- 3.8    376,192 +/-
8,581  8,297 +/- 247

(I hope the formatting works, but let me know if it looks weird).

2. Memhog: time memhog 48G

My host for this one is 16 GB, 52 processors, x86_64 too.

Build        real (s)          vs base   sys (s)
baseline      80.5 +/- 1.9      =E2=80=94         62.7 +/- 2.0
vss_v5        83.0 +/- 1.8    +3.1%       65.7 +/- 1.8

On both benchmark, I enable MGLRU, to more closely match the setup you had.

Staring at the run logs (and double check with the logs you sent me to
make sure it's not just on my system), there are some common patterns
I noticed across these runs:

1. Kswapd is slower on the vswap side, which shifts work towards
direct reclaim, and makes compaction have to run harder (which has a
weird contention through zsmalloc - I can expand further, but this is
not vswap-specific, just exacerbated by slower kswapd).

2. Higher swap readahead (albeit with higher hit rate) - this is more
of an artifact of the fact that zero swap pages are no longer backed
by zram swapfile, which skipped readahead in certain paths. We can
ignore this for now, but worth assessing this for fast swap backends
in general (zero swap pages, zswap, so on and so forth).

I spent sometimes perf-ing kswapd, and hack the usemem binary a bit so
that I can perf the free stage of usemem separately. Most of the
vswap-specific overhead lies in the xarray lookups. Some big offenders
on top of my mind:

1. Right now, in the physical swap allocator, whenever we have an
allocated slot in the range we're checking, we check if that slot is
swap-cache-only (i.e no swap count), and if so we try to free it (if
swapfile is almost full etc.). This check is cheap if all swap entry
metadata live in physical swap layer only, but more expensive when you
have to go through another layer of indirection :)

I fixed that by just taking one bit in the reverse map to track
swap-cache-only state, which eliminates this without extra space
overhead (on top of the existing design).

2. On the free path, in swap_pte_batch(), we check cgroup to make sure
that the range we pass to free_swap_and_cache_nr() belongs to the same
cgroup, which has a per-PTE overhead for going to the vswap layer. We
can make this check once-per range instead, to reduce overhead. Even
better - we can skip this check in swap_pte_batch() for the free case,
and deferred this check to later on where we already enter vswap
cluster lock context :)

With a bunch of changes like that, I closed the gap majorly:

usemem:
Build        real (s)          vs base   sys (s)           tput (KB/s)
       free_ms
baseline     175.6 +/- 3.6      =E2=80=94        121.9 +/- 3.3    391,941 +=
/-
8,333  6,992 +/- 204
new_opt_v2   179.8 +/- 3.0    +2.4%      126.1 +/- 2.9    382,536 +/-
6,662  7,105 +/- 183

memhog:
Build        real (s)          vs base   sys (s)
baseline      80.5 +/- 1.9      =E2=80=94         62.7 +/- 2.0
new_opt_v2    79.9 +/- 1.7    -0.8%       62.4 +/- 1.7

I would like to also point out that, some of this overhead is specific
to the swapfile backend case, which is why we don't see this in zswap
in the stats I included in V5. Zswap does not require this
swap-cache-only dance, because in virtual swap, zswap only needs the
virtual swap slot as the index (on top of much more negligible space
overhead thanks to zswap tree merging into vswap cluster, no swap
charging, no double allocation, etc.).

Anyway, still a small gap. The next idea that I have is inspired by
TLB, which cache virtual->physical memory address translation. I added
a per-CPU MRU virtual cluster. The idea is that a lot of consecutive
swap operations operate on the same range of swap entries - merging
these operations of course makes the most sense, but sometimes it's
not convenient to do it. The non-vswap, old design sometimes lock the
physical swap cluster and expose the swap cluster struct to callers to
pass around, but I would like to avoid that if possible :)

With this change, we close the gap even further - exceeding the
baseline in average in certain cases, but as you can see it's within
noises so I wouldn't conclude too much out of it:

usemem:
Build        real (s)          vs base   sys (s)           tput (KB/s)
       free_ms
baseline     175.6 +/- 3.6      =E2=80=94        121.9 +/- 3.3    391,941 +=
/-
8,333  6,992 +/- 204
cc_v2        176.4 +/- 5.3    +0.4%      123.6 +/- 5.4    390,405 +/-
12,792 6,987 +/- 296


memhog:
Build        real (s)          vs base   sys (s)
baseline      80.5 +/- 1.9      =E2=80=94         62.7 +/- 2.0
cc_v2         79.9 +/- 0.9    -0.8%       62.1 +/- 1.5

The reclaim and compaction stats tell a similar story:

Reclaim / Compaction (usemem)
Metric                               baseline
vss_v5                   new_opt_v2                        cc_v2
allocstall                 167,787 +/- 10,292           170,532 +/-
15,185           169,782 +/- 9,903            168,635 +/- 13,526
pgsteal_kswapd          6,932,143 +/- 186,411        6,965,962 +/-
288,323        6,968,188 +/- 286,383        7,038,513 +/- 202,696
pgsteal_direct          9,759,350 +/- 480,674        9,978,721 +/-
765,543        9,899,698 +/- 480,781        9,845,668 +/- 544,319
swap_ra                        82.9 +/- 22.6             5994.8 +/-
2817.5            4976.8 +/- 1484.2            4718.2 +/- 1510.5
pgmigrate               1,029,901 +/- 428,416        1,687,072 +/-
399,505        1,260,451 +/- 202,603        1,144,560 +/- 490,177

Reclaim / Compaction (memhog)
Metric                               baseline
vss_v5                   new_opt_v2                        cc_v2
allocstall                 101,245 +/- 6,271            109,320 +/-
12,180           100,207 +/- 11,053            99,223 +/- 9,905
pgsteal_kswapd          8,817,264 +/- 432,519        8,436,548 +/-
265,763        8,728,944 +/- 305,101        8,962,443 +/- 589,012
pgsteal_direct          5,408,046 +/- 394,775        5,932,611 +/-
584,873        5,419,891 +/- 551,226        5,349,352 +/- 601,655
swap_ra                        66.5 +/- 22.8             8589.5 +/-
3325.1            8954.5 +/- 2661.9            8703.1 +/- 1746.6
pgmigrate                  239,410 +/- 46,014           277,193 +/-
71,487           320,672 +/- 59,488          243,989 +/- 136,129

You can see that the latter versions gradually restore the behaviors
of baseline in terms of reclaim dynamics :)

Some final remarks:
* I still think there's a good chance we can *significantly* close the
gap overall between a design with virtual swap and a design without.
It's a bit premature to commit to a vswap-optional route (which to be
completely honest I'm still not confident is possible to satisfy all
of our requirements).

* Regardless of the direction we take, these are all pitfalls that
will be problematic for virtual swap design, and more generally some
of them will affect any dynamic swap design (which has to go through
some sort of indirection or a dynamic data structure like xarray that
will induce some amount of lookup overhead). I hope my work here can
be useful in this sense too, outside of this specific vswap direction
:)

I will clean things up a bit and send you a v6 for further inspection.
Once again, I'd like to express my gratitude for your engagement and
feedback.

