Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99197CD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 23:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 852DD6B02B4; Fri,  8 May 2026 19:33:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803526B02B5; Fri,  8 May 2026 19:33:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0066B02B6; Fri,  8 May 2026 19:33:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5ED7C6B02B4
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:33:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ECACB1203EA
	for <linux-mm@kvack.org>; Fri,  8 May 2026 23:33:05 +0000 (UTC)
X-FDA: 84745855530.01.CDFEB05
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id ECE8140006
	for <linux-mm@kvack.org>; Fri,  8 May 2026 23:33:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rSEg/lH4";
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778283184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oSOi2hfsCtv/FfIwJYFm2BLHlgEKmdNqcetZh+pI3Hw=;
	b=CpxtYLReyUesGWLl6rI1m6Ou4V0AZrrYtM/xOI3z1HairSCAR9HcB0VgUKpY5fu3Z2PgJS
	zjZGKE+7R4R3vVwH0aY02AE61HH4bcTIqDLN5Utn5ASPTtcAgaKFvgUDDuMiP0/nCtBigo
	gi1rckIAwTcTCEXc2D3IZu5AbPk2vfU=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rSEg/lH4";
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778283184; a=rsa-sha256;
	cv=pass;
	b=j/g87ocLdhW/2kMnyR48mHRPtT9Ti0u0KzVe55zNHJNQa/0grzmmlD0G3uh6qOLd+4BDVz
	XtvN4+WEOfHcJZNv6XitNvNaC0L/+Er1NrQ9tNapjx+XZ+yjTeb857KfRHfywUPXpwtB6K
	0S1aPToRWuRCgTtIsNIXaNH2LGC9eXM=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43fe608cb92so1545180f8f.2
        for <linux-mm@kvack.org>; Fri, 08 May 2026 16:33:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778283182; cv=none;
        d=google.com; s=arc-20240605;
        b=G3pQWtrSlU/HU5PlXUz1MCkTiLr6vBG+GOxAEJHkhGv2fdDp4WZO98EeOPHiCiMTtU
         NwDdZByGSpcsiACrzxsDIxisMbcVywaMimRuWqoFr7rN5od7EA2rKZqRleCVZyf5d5FR
         10o7tgqY6tKT/J9KXv7viTLM5/F4hTNCWPsSazpfC+euHxDLi6Uh7W7q1jR6UoLJWVbj
         8QsgbbOMhKhdIO29bvTn2UNvQ50E38YMy5hN1QH/LGLfg0ARstF+VhtqO4b9IhYpJlSP
         7GSp4GNfE6ypWQ8De2fhoPRsfy0ViMXD6WCUmNLsvt+XQpF8clVF/X2gtT9bHjkLgGM3
         CS/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oSOi2hfsCtv/FfIwJYFm2BLHlgEKmdNqcetZh+pI3Hw=;
        fh=nIB72I93U2llO5stiCjzftlSktI0gmQEHr47XmGRqFs=;
        b=hYdOGHmMF5LHHn2g2ZZSAvR2eTtv4bpANLze/Yjxio8Daenidi3r6ZhkXa2j7p/cRh
         m6hpI410LSt3xkwrsSP4aO2oOMPxF0O5u9QPo/RP/JS8JQXdtyiMreMqvwaCEaJVOUwl
         7UwEBWDb/tqX2kh06GJvOaBBF7I1N6MQo9UTkw5lUjS7MVUwRpys3gkY09gSa14Lq6eH
         uYC34TUPJ7btbfxd1U01XercSsSMtRJ0B8+Pzc3r6rpgA5H9nico3PATiAzGFWlYWd+a
         IMqfVs3t6o0aUc9E7Q923I9gwLxGxK1EDmfohDRdchAn76k1Q5i6uYZbL4Ob7xzzAHSU
         OiqA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778283182; x=1778887982; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oSOi2hfsCtv/FfIwJYFm2BLHlgEKmdNqcetZh+pI3Hw=;
        b=rSEg/lH4ZmtnjRWqHIe0vlyAO1Owh7NINwE9cfzIKED20LvDLvSdDm6xJAF7wqD1MT
         XRcmYH4ju0Rgmgui7DUvkOjDvvr9zu+IJfK8rC+gdb9PHkj7JYTIegU1rx6C+o5nyWMJ
         s4GhR0S6hXJhj+xr0UenneTPJDqHqq+V2ocv/kSs1eEjEx76slVscRQsYZgDRrVNUWuj
         RVZEfVjJHiO00fyXCfLF77nQ50HxODlqIdiDwHWe8PyT2/CwrKPJV/m549Lmx/h7+BGL
         KPjIsBporcajNb+TndTTvvWpqmSYus3ioLDWCVDFw6TEua7wvkKFHmJElJggGvoIED8m
         Ph4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778283182; x=1778887982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oSOi2hfsCtv/FfIwJYFm2BLHlgEKmdNqcetZh+pI3Hw=;
        b=KVMqJrCKxTz2ZmyLoH5ChoMzlHrFhpgocskzRmQLHUb1JkNr1rpr7f3UZt/Cpl5E3L
         hgcQ1/RIXwtnvy/PkAV7rE3jU8Qgwk4Qv5HnTMv+DyAh6Icd8jRHzPBPGrrUJ7lkOPNJ
         Wxk65b6UqblMHTf0PglGnTCQB8Tp18xiBT2jO4Q8ixJyIdPEF6oJFAX0ikDsHMTAi/mR
         L6kKNEpSqNOJHOtgNmVBTj39IbF0ASS1cBILDZe3ru7z82RCTluu4O/01dQrff+XnO5i
         jxtVFlWWswP8+8H3tzZfXhWEagJVrLBa615FsggeiJOvQ9wld7etQq5JItDGhQ8otVZN
         foYQ==
X-Forwarded-Encrypted: i=1; AFNElJ8ncl33CKb58ILAk5Y6UatxTtzkphb8OO/xAIYhlc4C72wlORiEULqrwHc0gL8tXsnixFkPBm2+eQ==@kvack.org
X-Gm-Message-State: AOJu0YyrpaeoEujJiYxajRGbQgSTHGdtg/OjF6z9ClW1eW9AQjJIe/Fa
	jWwk2eRfQn97onenKOqVZqaZJwM7p+hS9gcfZQbJ8VTQ2j9CCqukJQuCrd+lz67sOePh+NIpldm
	2GD87Cg+P4Zg5SkSwzt9QdPzBpv1QOyw=
X-Gm-Gg: Acq92OEuSEvf9wWlBDCdsXmhaKEI/f1HV9SEcG/X2fyhq/kvNW5PR5xG8nnQoDvJwxP
	aacXvmeux/jKmxUD3utw+ggBzOj/3UUE2iLUf5/jkgWIXh7nkLg1AFRvEHKh16SRNARFVszBKC4
	PCVfvsAtGncdpE7reEVcY1Q1bLD9xCSIobuFRLgdrObSg5gQdlLklpyH4Yyv4J2cBZubZ0WDsvC
	jHHv761bWFj0RX2QYDXnlqv4eKE77oeWFZYljbA1e+TKjBuKwJdbt+ldyfXgg2+KUeWPUZuC2mA
	cLgBgdiFXGM2+pv4DbwyGIZTae7EQm6FaUIYc7OzRY19U0yz
X-Received: by 2002:a5d:588c:0:b0:451:bbe4:b48e with SMTP id
 ffacd0b85a97d-45460e406fdmr7146433f8f.5.1778283182084; Fri, 08 May 2026
 16:33:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
 <CAOptpSPs-1UrEa8AHg19e590=SiV6bpnex7gCbif8=aY7BtpuA@mail.gmail.com>
 <CAO9r8zOjugCwWqHP3zxXPmjp8TwpoROCjCqTZ_uxOBQwVqCWqA@mail.gmail.com>
 <CAOptpSMQyyb+q-VJdJ0RzNkjaer1CTePM5WkwEj_7cAO4aUToQ@mail.gmail.com>
 <CAKEwX=PrfrNys4ao7-d11J7r4pv5VmE8gTU_7iUHaHAKNaFuBQ@mail.gmail.com> <CAOptpSOnRCHo35KK5x3S0f5y9+7+dxfznpjNRH072jZvhYHwww@mail.gmail.com>
In-Reply-To: <CAOptpSOnRCHo35KK5x3S0f5y9+7+dxfznpjNRH072jZvhYHwww@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 8 May 2026 16:32:50 -0700
X-Gm-Features: AVHnY4LVPgaokRSD-yNzmbW3fcr5U2WsfiVX3TD22zLlG4u5QMOCyYiPo_GSa7U
Message-ID: <CAKEwX=PgsM4Z0URJcF5VSXX_jdy-cAs2JxDCCR1a8CGwV4tCAg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/zsmalloc: reduce zs_free() latency on swap
 release path
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Barry Song <baohua@kernel.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ECE8140006
X-Rspam-User: 
X-Stat-Signature: ws5469ecyjz1wk8jakpbrzrwt83t5s4m
X-HE-Tag: 1778283183-155160
X-HE-Meta: U2FsdGVkX1/eXgrwHhS9dF4bwqSVwySw6TYlV4kTMLFtEWzwF7yc/8f/3LTcE2bk3dvaLrwUsSxOklEeb3eiBVfWuQ1Rof63yMSP/RQI8hg/1e/EpgNz5DDGLunijtJsk1cdLEO7CgoKKPfcXouO5hi1JzD45j69XODIZOOPxbr1bOXTAqWu1WjGCZZsoQPx575pZzOQYMWiQvyC8/McTpvbfLCPN4BtksYVCcbFIQXDlXWG1qc1lt5mPFG24jnriAhGQyTr6tbJFvZl3BlPAnbsS/DAKG1tSlyg3u3eLAc6JH28iLWfbVFIFhxw2vHya2TWmDufUSQCTr3wQeK0nmjh/clMjI0N73nsL3IWjWRTAg4QlBWXf4qYM4vXOHMUOjxSv5ar868KR/f8w2HGiGtdP6yaXHKS7VEmQAPEm8ctgdAOjYcF09uA+3//ztJNHjVNiZ6PmsIURUI7PYmrbhval3FUiRIsZGFBl8kf1+farZOuxbUdu4D4S5K6aOdeVr9jV5I3lm7GsCSWGvp0f865A0/xv6MTi9guI6aEh1BIZ6Cl9IHgDnxrySUD5rABj02KONTKLJLC6EYvs/cr5qps7fbju/q40iydpBq6jG4A5CHrR7/NoO1zyU8r6SrsfIg4InHRwC9isFW3IEZ6VygLRh4OMGyj1K9op7c6emZtzw8awSvJXttJircTCzd0SW2RxXMT1tH7d//bA9iHigXmYuPsXLSw92PZg8bhWeIFiL9nbvOni3SQuEvgSNpB6ZnlvL531993mp+EwvmTq6FiFEbUpimZIZQCnWWi4IopEUVc3t34F1ao9n48kMwh3ZcvPpSy9VqWU2QSvJnM4JNRFJ7a8biE0B/z6uM3tZeKo7yY6Ns94afGWD6Juss7UB/sU9BZTULYeifi9SMnFhQ968QOys2Z+U39S/bjrFDoQV/YjCJ3G+dgnn9nyRpbI5vtSg7z7cKTJOJxjJG
 HTtD+aVa
 81gE7M0KnWiXeo6neRkcucoledcPBN/2XSM9wEvj60EeJqKnQbEglw8z7kp/GlJiUbFhwscxzI8CuQ6VTpKGYez1tVsDVVa0MXiSUdQBQEFiJJovDMGMl1O2lJGaFEAw95o+ZTB1Qvk8J0iNsMBWgBQKC7O1FVGGv2xJQcm10cTdbYT2ZeAZT5j+x3SIqGqbl0gM0XXYyG40DDUoWByHNRuigVbfSDraARIakNcg0sWfnNv10wsbIRiiRTX/PTdOaloToacSDCaZK4JGkT6gt/P9G2Mlb+q+xC09M1xSR88frzrjCGO3fwzlNdZ7agaYJr+Ofhxx4xu28/xrtSi15X5+O6fKW/vHF9xWAieveadzMVz1ceoKJCkGzLo/td7ZeS5FsJApZCVgnsOREcyLZja2WSOyss5Wh49GzAHPgDikeuan09QcoOdmTdcPC/Jv3/qwY+G3h9Oge4ty85ihLJ/DOSZULygxsFTSeH36KHdmVYjBhxCqUn0o93QAv42bObP3aDDU6G55EOVRhZOSEsJswFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 6, 2026 at 6:55=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.com>=
 wrote:
>
> On Sat, May 2, 2026 at 3:21=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrot=
e:
> >
> > > With only the class_idx-in-obj encoding (eliminating pool->lock from
> > > zs_free, no deferred freeing), we measured on two platforms.
> > >
> > > Test: each process independently mmap 256MB, write data, madvise
> > > MADV_PAGEOUT to swap out via zram (lzo-rle), then concurrent munmap.
> > >
> > > Raspberry Pi 4B (4-core ARM64 Cortex-A72):
> > >
> > >   mode        Base       ClassIdx-only   Speedup
> > >   single      59.0ms     56.0ms          1.05x
> > >   multi 2p    94.6ms     66.7ms          1.42x
> > >   multi 4p    202.9ms    110.6ms         1.83x
> > >
> > > x86 physical machine (4-core Intel i7-12700, 2 rounds averaged):
> > >
> > >   mode        Base       ClassIdx-only   Speedup
> > >   single      11.7ms     9.8ms           1.19x
> > >   multi 2p    24.1ms     17.2ms          1.40x
> > >   multi 4p    63.0ms     45.3ms          1.39x
> >
> > Oh man, you are eliminating pool lock here right? This would help my
> > other patch series a lot too :)
> >
> > https://lore.kernel.org/all/CAKEwX=3DM5YpR0cQrryX_y4pm_BuxyUWZ_8MbhWodw=
bf1Fe=3Dgzew@mail.gmail.com/
> > https://lore.kernel.org/all/CAKEwX=3DPkFiP+u+ThrzjTKBi+usQf2uuhTZcfB2BN=
NA8RboOFDQ@mail.gmail.com/
> >
>
> Yes, exactly. With class_idx encoded in the obj value,
> zs_free() can determine the correct size_class without
> any pool-level lock. The lockless read gives a valid
> class_idx because it's invariant across migration (only
> PFN changes), and we re-read obj under class->lock to
> get a stable PFN.
>
> > Well, the deferred freeing would completely move that contention out
> > of the way lol. But this would benefit all users, regardless of
> > whether we're deferring the free step or not (for instance, this will
> > reduce contention between page fault and compaction, IIUC?) I feel
> > like you'll get some good numbers testing in a system with compaction
> > and THP enabled, with lots of swap activities. Which is... a lot of
> > server setup :)
> >
> > If the deferred freeing is too controversial, this smells like
> > something that should be upstreamed independently.
> >
>
> Agreed. We're planning to split the series so that the
> class_idx encoding + pool->lock elimination can be
> reviewed and merged independently of the deferred free
> framework. It's a pure win with no behavioral change
> =E2=80=94 just less lock contention.
>
> > >
> > > Single-process shows modest improvement. With multiple processes,
> > > each read_lock/read_unlock atomically modifies the shared rwlock
> > > reader count, and the cost of these atomic operations increases
> > > with more CPUs accessing the same cacheline concurrently.
> > > Eliminating pool->lock removes this overhead entirely.
> > >
> > > This only works on 64-bit systems where OBJ_INDEX_BITS has enough
> > > spare bits to fit class_idx. 32-bit systems don't have the room.
> > > I'm still working on the compile-time gating to properly enable
> > > this based on architecture and page size configuration.
> >
> > /*
> > * The pool->lock protects the race with zpage's migration
> > * so it's safe to get the page from handle.
> > */
> > read_lock(&pool->lock);
> > obj =3D handle_to_obj(handle);
> > obj_to_zpdesc(obj, &f_zpdesc);
> > zspage =3D get_zspage(f_zpdesc);
> > class =3D zspage_class(pool, zspage);
> > spin_lock(&class->lock);
> > read_unlock(&pool->lock);
> >
> > It's basically just this blob right?
> >
>
> Yes, that's the blob being replaced. On the
> ZS_OBJ_CLASS_IDX path (64-bit systems), it becomes:
>
>     obj =3D handle_to_obj(handle);
>     class =3D pool->size_class[obj_to_class_idx(obj)];
>     spin_lock(&class->lock);
>     obj =3D handle_to_obj(handle); /* re-read for stable PFN */
>
> No pool->lock at all. We've also added compile-time
> gating (#if BITS_PER_LONG >=3D 64) since 32-bit systems
> lack the spare bits in OBJ_INDEX to fit class_idx. On
> 32-bit, it falls back to the original pool->lock path.
>

BTW, I've tested your idea with a hacky prototype, when I was playing
with my vswap series. It absolutely improves free time in the usemem
benchmark :) Idea is very promising - I won't scoop your work of
course, just letting you know that at least in my use case, it works
:) Look forward to seeing it submitted soon!!!

