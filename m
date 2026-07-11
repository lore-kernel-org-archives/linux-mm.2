Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A41AC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 08:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FF626B008C; Sat, 11 Jul 2026 04:49:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AEA66B0092; Sat, 11 Jul 2026 04:49:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C43E6B0093; Sat, 11 Jul 2026 04:49:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF8276B008C
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:49:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 86770406AE
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 08:49:23 +0000 (UTC)
X-FDA: 84975871806.27.E550621
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id AD9BC100004
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 08:49:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RMZ9DzxN;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783759761;
	b=zYudu4GA5GvPRMCCfiJ/bXkS+J83133LaelHds24WTQ0xSuvkSu+YRttQ79Of+eyoU/966
	YXV1PsqSHZhoWVJp8iDKB8NS+UVEX+AzvLjbHZ/05es5r9qXJj5nZiQVdWcTX99UfYnWWc
	DF2lXUGlxchx5o2630DDWPh9UzLngpk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RMZ9DzxN;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783759761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nwhedb4SL95KCarRaTI9fBlKI+hDTij1JANmSJKN1a0=;
	b=7FRfziarCvKCknQXAEOyUffUz3C2m8GOx+wEyaAlGZZ9F6RzF6J7UldY9+j9R5np9OkbiH
	w5qE361jOKX31PuIqtL/iQwPSf1K3j1AzLx5bPDVS5mbEAkARxgdkQTPzaTAQPU64ESQPG
	E6OsVIg+968HDnvLZHyT1G+2WdbtxhM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9970A43466
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 08:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752A41F00A3A
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 08:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783759760;
	bh=nwhedb4SL95KCarRaTI9fBlKI+hDTij1JANmSJKN1a0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RMZ9DzxN4hRB/pX1wlUomxAG4uHVDdkPesuMNhU1tmeazjrqT7Ny26EmZmQ1slN0Z
	 bDk9/BkeyK2/WfU5RxOSfuCEWXR1CxEAjZRSF/Ni/18wFq5xgRZb7UWoDCcHhhNSBZ
	 e1sKTWZUOGdlGR1q2VipyBEoVKUvsUDGZGbXD07041WtXsIuqSdLhGkJA8hTnm/szE
	 SCDsej6GBcPwFUZYiXSqk0erkjdOolbNK3+C2B+q6y7E2UHVsd8VsCU8wE7JemE0/u
	 t2lt6NUXnhAXwa4MWzd+avpyRcz0vDCqB3SIxKqix9tlcCEJ60WfGOcp8baFvGb1ms
	 vbyoONow6Lm2g==
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-66493875766so2878607d50.0
        for <linux-mm@kvack.org>; Sat, 11 Jul 2026 01:49:20 -0700 (PDT)
X-Gm-Message-State: AOJu0Yzm8LIbKhvej4dYQuxSNrARlm5KzeDjshYLml64Kc0t1jODLvo3
	5rWnfexc4k8VpwpAu1rn8M5+8ILBZWd5H+sqHulu2FQQnonK0rGmWFW23Ces+jigoanpksiacTx
	jOdVT5hW0HnsUpcAKSoJP1y0/VS3dLc2nNOKCEwS4Ag==
X-Received: by 2002:a05:690e:4188:b0:667:9481:5b37 with SMTP id
 956f58d0204a3-667d7afa86cmr1676519d50.2.1783759759742; Sat, 11 Jul 2026
 01:49:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260707082614.95030-1-baoquan.he@linux.dev>
In-Reply-To: <20260707082614.95030-1-baoquan.he@linux.dev>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 11 Jul 2026 01:49:08 -0700
X-Gmail-Original-Message-ID: <CACePvbUogrQ5hJSU=S1pQVe4o2vAfbv7V43qUCPwGSz82JW+9g@mail.gmail.com>
X-Gm-Features: AVVi8CcfanDzcc2hpkqRRjoKH9P_P8AreiBaKeXycoc_rKXumOLQp2eHgrKQsEM
Message-ID: <CACePvbUogrQ5hJSU=S1pQVe4o2vAfbv7V43qUCPwGSz82JW+9g@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AD9BC100004
X-Stat-Signature: ybahca36todkj49nrs54m85jnaawp5ah
X-HE-Tag: 1783759761-434879
X-HE-Meta: U2FsdGVkX1+/PqkXPeN+u2kz4KQz3kyhmJx0VFzkqD/PU2+uLgYBrHIiz6rTA7XnKAcHast1OuCWkwAFLvSvkq3+Kpepss50is8jHjAvV+TiZuc/rRinCo6bW7I6xlPFinysKnq5XezMDNz71BfGKGFn29pNX/p2M/7pWS1TLr4zxZEIdJdEjI2vCXk5p4AP0Tqi1ezvN98TeIr05TB3mpOR+mCj+9/KTkNNS/qIe5udjFzAeWufZaFH967saE6cULnRkLkwRYgPKxZHq4chUJbWZMqrOQEe/DHq0v82WT+0lpiZOLxMgh+BD7/n+c5Z2AQQUImuB3s6FyASUnRPjuufblBg73VtMxJhicWEU/D1cXxlV1pV8REo0aZlzJWcvan+AJBLhlB+NAx6pQhssPPk0PBfHYwDDV8WsawT2wC5vN6x9Na84eJLVQfDk99YgM31MiEcXMJpKREUMd0/RG4ue1J4Fej70XTvm5EAOZh3QmDNAoG7ww2yHx3gOifQZMeXbtgKeTeR+s21rKtygSrDP6oh5+cD1WPepm7zvELSZt53cbXuK1FYRWkH1jMMDDjxY44PLrhvDpgAK08Kl4KEICkW4/lpi3gq5rX7QsizMd4VBlpVfMmJ/OcSq19T3+YAO65LqzeIR0mJN6E+Kjt9wjG5KHjv0mOUE0HBHeKymkN8f18J+GtOMAFD4+wyfhohykDcuQwbYQ0pceJNu0h8CXjIXnW1gkFhuMgz4pLX9AMk9xlPIyOXRzVkbLbmlVDVwFaSzufIhMlGE/MqhcsiQdvHvHfQMPrZ9SvVCCvFo4pmpwThroe0jYccoUzs/rSAtziiGJ+v/vbosFhDWv9mwBUWyqvE4pGXTsGWDXzhy4LYqfe/5rvLSqf2Fb6aBNaVVvaBi/P1bRkuN/vEfL5ou3DjyD6gUi3SuzzdGkAH9bHrRE1m8U/+wmGd2Te/iYLscwV7qZTxoFfGAJ8
 hxy9U7kE
 vz3YLmmv7EirmoC2XDa1qIPMQ8ffUs+8ClAWB7JXDYfh5aQem2k8vN8Op0S0ISzMzCfQ6TuBXpg5Lpbb/+oSpW7/QoIdBASjjN+Kok6PntQrV6zme2p0Qcc5L82UkBgXua9ybxNUYAAECBhW62x5vR41icNOmLEHj8Rj/iqjQMC9MCdcHZx9DjPTRaOHYLCQSZ3gw2xm2YdllxeLVM1APkEr1DlErcHqsaa3M9fj8sEdtM07cLUA9uiBlqQ0IHdZNsMmXPHPTviSdoHwamO5ixiXq5gLC8Ig1OijD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baoquan,

Thanks for the patches series. That is very interesting take.

Some high level feedback follows:

On Tue, Jul 7, 2026 at 1:26=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> wr=
ote:
>
> This series introduces a virtual "ghost" swapfile that can be backed
> by multiple physical swap devices, switching between them at runtime
> using a new "Redirect" swap table entry type.
>
> Motivation
> ----------
> Physical swap devices have fixed, large sizes but a machine may only
> need a fraction at any given time.  Ghost swap decouples the logical
> swap capacity from physical swap allocation: it presents a large
> virtual swap device to userspace while lazily mapping slots to
> physical devices only when data must leave zswap (writeback).  This
> enables overcommit of swap capacity without wasting physical disk
> space, and allows the ghost device to grow dynamically at runtime.
>
> Ghost swapfile characteristics
> --------------------------------
> Ghost swap decouples logical swap capacity from physical swap allocation.
> Key properties:
>
> - No backing store required.  A ghost swap device can operate purely
>   as a zswap container =E2=80=94 compressed pages stay in the zswap pool =
without
>   ever touching a physical swap device.  No physical swap device needs
>   to be attached.
>
> - Optional physical backing.  One or more physical swap devices can be
>   swapon'd alongside the ghost device, acting as writeback targets when
>   the zswap pool needs to evict cold pages.  The Redirect entry in the
>   ghost swap table links each evicted slot to its physical destination.
>
> - Dynamic size growth.  The ghost device can be extended at runtime via
>   sysfs, up to a current maximum of 1TB.  This is implemented through
>   lazy vmalloc: a sparse 64MB virtual address space is reserved at
>   swapon time to cover the full 1TB range, but physical pages for
>   cluster_info[] structures are allocated only on demand as the device
>   grows.  The cluster_info pointer never changes, so all existing
>   accessors (__swap_offset_to_cluster, cluster_index) work unchanged.

I think supporting swap file growth is useful at the swap
infrastructure level. I mean generic runtime size growth for swap
files. That does not need to tight to ghost swapfile. For example. If
your swapfile is backed by an LVM logical volume. You can grow the
swapfile size by growing the swapfile's logical volume.

I suggest focus on that allow increase of si->max as the baby step and
keep the optinal physical backing for later phase. That should make
your series much smaller and easier to merge.

>
> - sysfs control.  Each ghost device exposes attributes under
>   /sys/kernel/mm/ghost_swap/ghost_<N>/:

BTW, I want to rename the ghost swap file to remove the ghost part. I
inherited that ghost name but I feel ghost is a bit too spooky for my
taste. I am pretty bad at naming stuff myself. I was thinking
something like "VX swapfile" (virtual extendable swapfile) for
example.

>     path (RO) =E2=80=94 backing device name

Let's focus on the extendable part for now and worry about the
physical backing device later.

>     max  (RW) =E2=80=94 current max pages; writing a larger value trigger=
s
>                 swap_ghost_extend_max()

We can use a debugfs entry before we settle on the final
implementation. It is useful for demo and testing purposes if we have
some way to trigger the growth. Having the ability to grow is more
important than how it is triggered. We can also let it auto grow as
needed based on config.

BTW, I  notice your patch series doesn't apply cleanly on mm-unstable.
I have to resolve some conflicts myself.


>
> Design overview
> ---------------
> A swap table slot can now hold a Redirect entry:
>
>   Redirect: |----- physical swp_entry_t -----|101|
>
> This stores a plain swp_entry_t pointing to a slot on a real (physical)
> swap device.  The low 3-bit mark (0b101) distinguishes it from Pointer
> (0b100), PFN (0b10), Shadow (0b1), and NULL (0) entries.
>
> The lifecycle is:
>
> 1. swapon a ghost device =E2=80=94 reserves sparse vmalloc area (64MB vir=
tual)
>    and physically backs only the initial range.  The device starts with
>    no physical backing store: pages swapped out go to zswap, and zswap
>    pool evictions go to any concurrently attached physical device.

Again, let's make it more generic also works on physical device change
size as well.

>
> 2. zswap writeback from ghost: when the zswap pool needs to evict,
>    zswap_writeback_ghost() allocates a physical slot from any real
>    swap device, writes the data there, and plants a Redirect entry
>    in the ghost's swap table pointing to the physical slot.

Don't worry about zswap write back for now. Able to grow swap device
size is a useful phase by itself.

>
> 3. Swap-in from ghost: swap_read_folio() detects the ghost device
>    (SWP_GHOST), resolves the Redirect to the physical swp_entry_t,
>    and forwards the read I/O to the physical device.
>
> 4. When the swap cache folio is removed, the Redirect entry is restored
>    from an xarray (redirect_xa) that persists the mapping, so
>    subsequent reads still find the physical backing.
>
> 5. When the physical slot is freed, the ghost slot is also freed,
>    cascading through swap_range_free().
>
> Note:
> ------
> Ghost swapfile is a proof of concept. Compared with the other patchset:
> [RFC PATCH v2 0/7] mm, swap:  Virtual Swap Space (Swap Table Edition),
> it explores a different approach to implementing virtual swap on top of
> the existing swap table infrastructure, with a simpler implementation.
> It builds on Chris Li's earlier ghost swapfile work and is currently
> tentatively named "ghost swapfile" =E2=80=94 alternative naming suggestio=
ns are
> welcome.

VXSwap or XSwap

> Ghost swapfile setup can also be integrated through modifications
> to the swapon API and the swapon command in util-linux, for example:
> swapon --ghost ghost_1:2G -p 5.

For the ghost swapfile, the eventual goal is that its size can
automatically grow as needed because there is no phyiscal backing
device.

Chris

>
> Baoquan He (9):
>   mm/swap_table: add Redirect entry encoding for ghost swap backend
>     switching
>   mm/swap: add redirect_xa field and ghost redirect helper declarations
>   mm/swapfile: implement ghost redirect helpers and free-path cascade
>   mm/swap_state: restore Redirect entry when swap cache folio is removed
>   mm/zswap: implement ghost-to-physical writeback for backend switching
>   mm/page_io: forward ghost swap reads to physical device via Redirect
>   mm/swapfile: manage ghost cluster_info via lazy vmalloc
>   mm/swapfile: implement swap_ghost_extend_max() for dynamic growth
>   mm/swapfile: add sysfs interface for ghost swap extension
>
> Chris Li (1):
>   mm: ghost swapfile support for zswap
>
>  include/linux/swap.h |  10 +
>  mm/page_io.c         |  51 +++-
>  mm/swap.h            |  16 +-
>  mm/swap_state.c      |  28 +++
>  mm/swap_table.h      |  38 +++
>  mm/swapfile.c        | 579 ++++++++++++++++++++++++++++++++++++++++---
>  mm/zswap.c           |  98 +++++++-
>  7 files changed, 772 insertions(+), 48 deletions(-)
>
> --
> 2.54.0
>
>

