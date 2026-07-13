Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAD87C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 00:02:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 532876B0005; Sun, 12 Jul 2026 20:02:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2DD6B0088; Sun, 12 Jul 2026 20:02:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AADA6B008A; Sun, 12 Jul 2026 20:02:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 145426B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 20:02:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94022169F72
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 00:02:19 +0000 (UTC)
X-FDA: 84981801198.14.7B94342
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf31.hostedemail.com (Postfix) with ESMTP id A494C20003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 00:02:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=beYkF7cZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783900937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/yQj88LNQTiDByB7OOCo1SnfcAF/5NlbV7+Wl4UwLTk=;
	b=Vb9OnRhcn2aPlqOh9jIvjMCxq8ZMuJyPpJuWvL6/3ckgOYkev5uByXPw86I2G0MS5pW+i6
	7ikFUpwA+ASi1+QzhTBbjOlVz9IHarbz4AwypUyNLamFOMqKA5/Td33G2UTo6wRz3DqZ+M
	tOy7ZHJqFwVKgkFXkBbbbvPpSJVahUE=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=beYkF7cZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783900937;
	b=64U+JxVGKEDX0VH3Ffsss/kHwwSQDNz7EZkm29jibBm8RZLDi4DBflZjAr6HMASOlexZ3K
	s5BmeTczA2pJSGupdxFt2BPkN116ud9eaSJaU/lP1HotkKfL4A755Z1aHs3nhUgU0klIV/
	yEh+51ey891GCZkciISi/1bP5vDSFVo=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4720d22c94aso2090820f8f.1
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 17:02:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783900936; cv=none;
        d=google.com; s=arc-20260327;
        b=ToqgyZtlfCfTT5FjYY4akLid99B6gJZblxuW+ULLxO/1hFaFjD1NCeFoUZ8UvYd0uG
         ehKaXm7rgMZKCZXXXfDEPaPrmtJHjsj/mrOQDR14My/UtmucPSdFog+4bIZdk4XTmEWH
         +OxxSqIRu/5AAvmgmkx2AG+UUlPvKigXdLhSv0FYmnY1uD9N9G8NH7Hb/glAzaClvImL
         8igcHcKlQuDdUvU1sZ1DFObLF08pXggE4T9fCWbvKF9+EdYOgPtJJ038PFYxhwYD8RIl
         7YXzTjuoRdT5q6Ths2cUATfhdysfbedhSLOKJSV+FZ5LgJAVGeHWwtTwBUw5W2k6qvXQ
         onow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/yQj88LNQTiDByB7OOCo1SnfcAF/5NlbV7+Wl4UwLTk=;
        fh=vaecG6QtO6r12GzAj38pAxqRjsWQrAnjzLyMhvd9eFw=;
        b=m95zyaqQpJPBcpiJAR5Ch2/7DrtxeLxOL/veHn+QFuvlDkupU4r+wBSGSbIgE+w3E5
         k0EYVAc85cqfWB/735pfkHr2MKXbUpx7PrJ5/4WHvuYff2wJsPPEPbknosQZgDK8ia8I
         OG0PWqYXPv5/GeR1uHlMMJUNtObI3zepL4Kk5CnUVTLQQaYUYWgbGGgsiJMVF6L4QNSh
         JGVxpVRAYHpPvRWLF5mkAjnqvGJTOIp/ROR2zviBnv1f9lHqlugf2ZX5epY+Nxq5X+m8
         /+bCuFIit4zo9ML9hR1ODjxhDEyvrrNXYHFoPMMrSnmHOS0oTXwuxRJsLDghAjjtNI79
         LA/g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783900936; x=1784505736; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/yQj88LNQTiDByB7OOCo1SnfcAF/5NlbV7+Wl4UwLTk=;
        b=beYkF7cZo49jDz7d/2bQ6q5nLTZwkDaq7Oz2jj1/0KDgthk6BdWNY8bSNBbPsDqgRI
         aBSHMTXgHYeqZf64nhkY8pBtH5sLYWQfiHzwoFcMX+djNXdla8Nne46czxjtwrb9OYQs
         7q16fPm7m1iGEXS1jK+bfiLzYFT2pGAaju3q9zRpGSDf+ZQMj52J7n3z1Y2vele6zCiV
         k+FBov8bQBPIIAzqLffYwgeWlXarAZs0qnLeDBZdHqqERBr9xuY9iIO5yOSPQ5omjpua
         NoWK1a+8/Ue/Wx5BP33Vg3HB98fSbK6JnTNYU2WMTiXX9I7ra/vbGc5x62L5qUffBv2K
         9tZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783900936; x=1784505736;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/yQj88LNQTiDByB7OOCo1SnfcAF/5NlbV7+Wl4UwLTk=;
        b=OmeqVDgLzKg/OpNmIDLGMdu+VYaKLlJKhNU3Y/JxBFTVZT5WM+deqrCdxPn1PEWRtQ
         prarBet/UpPxOXIG4mYpaE51UzzJD3s9PB9CJbBfOSBNiEb7Y6pNipviJ4roP/rdc2Dy
         UNP7/dpdBw3jgyo1JPX+gsRVFXO7FI6CX8Fen5A4Am06M+ABUNXuqv5JCgFhhi+Hh421
         /BdSvE6mQXgtFF4TbUPG0mecxejFIf4oht2R8b6Nyxj9a8YLcFRp6Ib0ygpXQal2C/4N
         OBkAIBeo7h/kM8xe+16wINokqKVMn3HvdV7RGl0ivbzUgOyLT2sD8RLTYOqppiPvkOuF
         gpzw==
X-Gm-Message-State: AOJu0YxgdvF+XQcDErmkVLNot+Cb+avRcSZ5Mkqt1vEO5PuprvD3I6Sd
	65jitiADTABjGFCzC2nTgf39sVTUSIiDDaJKSbwsIIlOhIymHUMrp1tb/5ZsVh7Kq5KM4O9QKKa
	c0Ab9XCapy/KudNGjG1WJDtuTe6+22bs=
X-Gm-Gg: AfdE7cnpvra+qFSpX0EGZRVz5MN8pbC3t3OQamjam1ke3tUMyX3+cpMQT+3nFSKCBTx
	1pwNK5qsOOpYhlGcjR4ZuiOzxr3rDEzt8mvowsL44SF505vVOvG63eGPHEv9l7MdZlD2p85G/UW
	49kjK1qni8Dqk12nHa6ytGo6QaMy6AFhKrG9ItftiiNMeSen92yA19DNtro7XmulCVRQExP3J3p
	FwcX95VT7/37zB/S04DF4SqzUAOXQ1PKYE8Z9KDiptwT7zxYVulYdmYO5Ww4oSC+7sqReVLVeBv
	0w0vqi0hiCIYXC3b52AbVGqJmLKGSi3vU9bFcvs=
X-Received: by 2002:a05:6000:26c9:b0:47e:aa42:4e42 with SMTP id
 ffacd0b85a97d-47f2dd15aa3mr8107544f8f.55.1783900935748; Sun, 12 Jul 2026
 17:02:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260707082614.95030-1-baoquan.he@linux.dev> <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
 <ak-IS61GeP85Jnxg@MiWiFi-R3L-srv>
In-Reply-To: <ak-IS61GeP85Jnxg@MiWiFi-R3L-srv>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sun, 12 Jul 2026 17:02:04 -0700
X-Gm-Features: AUfX_mwWpsguZBkHrVtAXHvm7tV3gGbUp3NdfEco_IzGMSs4Jap00Puy95Y8C3I
Message-ID: <CAKEwX=PEgnJ4nGFZYUwMryjq+Yp4v8Op_HdZ6_xEJ4n_MrM0Yw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A494C20003
X-Stat-Signature: thwyqjmjkexbytadziho4uqke1i5t144
X-HE-Tag: 1783900937-841512
X-HE-Meta: U2FsdGVkX1/rGGhTErVyh4ziGlTm5RbeDOIFPyQI9F0fOz1e4oXAVKp0XVZEp69Eq54tqNyCpsPUA76CScA96KuD4kerpwqJdakWIoHtMFaDx8HP1qwFa+PXwWzmglW6vDEzkPxFKUI/CQGzSA66U0JvLekie3hWcsmN91RpIW5S0rMM9mhl2jNjCrbsdxTU1TTL1TooZBT80hfOW4YTwtxIXStLwoSdeCdGbrrRWHAhsP8t03gJyCved9ALgF9qS4zcDm8MByHVeOt7SIECHby+VRo/C+KtAiMKJcmu2b7Ur5D2x6C0En1XuFzPWpgsJO/T48vmet50ji1Q+v7bcUP5gQDg7X5vijOfQigbndnWZuEMVfLfGMm4fWk16Pej8ZzVR1sNvM8FEJUlC3m9hVVnz5t8u1Hce+l1gRxz2wsjAzeK5abHfd6rRqBlXT3syE2/eJAHir6qX17QH5z3bDi5Shs+roIRRJZf+i2z8KD+NE6AgGeKBE6yQ+N0P4IbdvF/WIh2NpjOX9+FOHgZTZM6oA1YM+zPnG3sxhHCCGOcysWIVjvD1oXQKbXR5z22/9+tc4ijQGr9kPDfvLZ2zsVGJFAUv9XHymivGBozwWF3DqdINzmfe0XTEyJ+TPTNppKm0oLicrXTXrGEQczx5RkC/0ZYPKUqHEnX+9tQbOBYDvf5dxdSst0Vxl4DCS/6Pxt3x0oJKLDwTonJxdiTFMtk2DHx/hzTEBbMJqd9bcEUKfVPJv03p0Rd3BUYgL3veYeulXe0uBNe5bNTo1bYHW1ieHat38tcSiOEc/AG0jHCi2eRJ76Nmku78r98u7s/zYHppCNhw6MVauD/uoPyj3yLuWGt4va8eTpeGEZjJP21P080QQZ+IkAerbL/NmT1mFVG/b7/9GXshlqhHfRr6NugkfccQ6iC60aiMCqqABqnLIdYG0X50BARBdz8jIlfKzLMV+rdxApCpBNwk7T
 veQGsZBo
 IvV+pX0828pNJjdhZZKDScHXSUybcoMlPDhwbb0OO7Rz8hMksn54Xh22bD/oYLqQ92IH/8tUTGeqs+zF0bzDDp3U3F6CRT9k526hiJcayg+Joy7Q5+Z+xjQ4ePG5RB56sNR24LJuI8mU63DvTBGtXdi7Fix/CL9qokPVycuEpPDP9+UfvdIQkRsYpkScAC53yPYW3eSkE/1z2vR9sRNcPDiiPkHPCMTO29zkGeiPfqKN0DLrxOkPlnTGMMEI8yiBLHFUuKFF5qZhFNzLXIHtKVBD0zVRfqqCJzLd4e+ZN1obIVSexnhXHvmX8rKmt0vQefX8505ngYz3z/rkQVrJ8dOKxgv9jZ3ymZg/Wn7vR8S8SwBmiZolVlXwH7kqkdVKjv4vQOOUSrv9E1ROP8RhxUsANLOGxw3rIwTxYqwuz11w4uUiYCmQV7nPxmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 9, 2026 at 4:39=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> wr=
ote:
>
>
> Thanks for the thorough review, Nhat.
> >
> > We don't want to put additional operational burden on users. Besides,
> > expecting userspace to react to swap space being filled, especially
> > under memory pressure (at which point userspace processes might be
> > stalling already), is tricky.
>
> The manual sysfs extension is the minimal viable interface for the RFC,
> not the final choice. But even in its current form, it is a dramatic
> improvement over the status quo.
>
> Today, to use zswap you MUST provision a physical swap device of the
> same size as the swap capacity wanted =E2=80=94 even though most of that =
disk
> space will never be touched.  With ghost swap, you swapon a ghost
> device at whatever size you expect to need (e.g. 64 GB), and if your
> workload grows, you grow it via sysfs.  That is already a step
> change in operational simplicity: no disk pre-provisioning, no wasted
> storage, and a one-line resize when needed.

If these are the only three requirements you have, in fact, you can
already achieve something equivalent to a ghost swapfile: just put
zswap on top of any of the in-memory swapfile (and perhaps disable
writeback, although with careful limit setting it's almost impossible
to trigger writeback with zswap in newer kernels anyway).  I know this
works, because I even run tests with zswap-on-top of zram :) You can
swapon new swapfiles to support your "userspace-triggered" growth
strategy.

>
> Automatic growth can be considered later if it's really demanded.

It is really, really necessary. Please read my older virtual swap
space patch series for why it's necessary (see [5]).

>
> >
> > This is especially bad when redirection entry still eats up space in
> > the upper level (ghost zswap) swapfile. You will run out of zswap
> > space really fast under concurrent zswap store and zswap writeback.
>
> I think there is a misunderstanding here.  A Redirect entry does not
> consume an *additional* ghost slot.  Before writeback, the ghost slot
> held a Pointer entry (zswap).  After writeback, that same slot holds a
> Redirect entry (pointing to the physical device).  It's a state
> transition =E2=80=94 one slot, one entry =E2=80=94 not an extra allocatio=
n.  The ghost
> device's total capacity is unchanged by writeback activity.

No, what I meant is, after writeback, you still hold on to the old
slot on the ghost device, AND a new slot on the physical device,
correct?

>
> >
> > >   sysfs, up to a current maximum of 1TB.  This is implemented through
> > >   lazy vmalloc: a sparse 64MB virtual address space is reserved at
> > >   swapon time to cover the full 1TB range, but physical pages for
> >
> > This range seems a bit small, especially from something essentially fix=
ed.
>
> The 1TB limit comes from a conservative 64 MB sparse vmalloc reservation
> in RFC. It certainly can be redefined as a bigger one which is more
> reasonable in reality. For most real-world deployments today, 1 TB per
> ghost device =E2=80=94 with support for multiple ghost devices =E2=80=94 =
is more than
> sufficient.

I beg to differ. We already have multi-terrabyte scale machines in
production in multiple places, and more and more overcommitting. At
least make this configurable.

>
> >
> > >   cluster_info[] structures are allocated only on demand as the devic=
e
> > >   grows.  The cluster_info pointer never changes, so all existing
> > >   accessors (__swap_offset_to_cluster, cluster_index) work unchanged.
> > >
> > > - sysfs control.  Each ghost device exposes attributes under
> > >   /sys/kernel/mm/ghost_swap/ghost_<N>/:
> > >     path (RO) =E2=80=94 backing device name
> > >     max  (RW) =E2=80=94 current max pages; writing a larger value tri=
ggers
> > >                 swap_ghost_extend_max()
> > >
> > > Design overview
> > > ---------------
> > > A swap table slot can now hold a Redirect entry:
> > >
> > >   Redirect: |----- physical swp_entry_t -----|101|
> > >
> > > This stores a plain swp_entry_t pointing to a slot on a real (physica=
l)
> > > swap device.  The low 3-bit mark (0b101) distinguishes it from Pointe=
r
> > > (0b100), PFN (0b10), Shadow (0b1), and NULL (0) entries.
> > >
> > > The lifecycle is:
> > >
> > > 1. swapon a ghost device =E2=80=94 reserves sparse vmalloc area (64MB=
 virtual)
> > >    and physically backs only the initial range.  The device starts wi=
th
> > >    no physical backing store: pages swapped out go to zswap, and zswa=
p
> > >    pool evictions go to any concurrently attached physical device.
> >
> > If you think this data structure is superior to the xarray for dynamic
> > swap address, it's a fairly simple change on top of what I had in the
> > virtual swap RFC, no?
>
> I appreciate the suggestion. However, the difference between the two
> approaches goes beyond the cluster allocation strategy =E2=80=94 it's
> the overall architecture:
>
> - Virtual swap introduces a mandatory, always-on vswap device (CONFIG_VSW=
AP).
>   with per-cluster virtual_table arrays, xarray-backed dynamic clusters.
>   per-CPU allocation caching.
>
> - Ghost swap extends the existing swap device model with one new entry
>   type (Redirect, 0b101) and one new flag (SWP_GHOST).  It reuses
>   swapon/swapoff, the existing allocator, and the swap cache
>   essentially unchanged.  No Kconfig option is needed.
>
> These are two explorations of the same problem, while virtual swap goes
> far beyond the problem itself, the decoupling of physical swap and
> virtal zswap. We can discuss and choose one approach.

If my problems are real, why do we have to choose? If we go with my
approach, all of our problems are solved. If we go with your approach,
then your problem is solved, with a promise that my problems will be
tackled in the future.

>
> >
> > It can be grafted on top of what I had in a subsequent patch, or
> > squashed into my first patch. If you have concerns with me
> > implementing your idea here, I'd take your code if it proves to be
> > superior.
> >
> > >
> > > 2. zswap writeback from ghost: when the zswap pool needs to evict,
> > >    zswap_writeback_ghost() allocates a physical slot from any real
> > >    swap device, writes the data there, and plants a Redirect entry
> > >    in the ghost's swap table pointing to the physical slot.
> >
> > What if user swapoff the physical swapfile, whose slot is backing a
> > redirection entry of a ghost swapfile, rather than a PTE. Has this
> > been handled yet?
>
>
> This is a gap in the current RFC.  Both swapoff and physical-slot
> reclaim would need a reverse mappingfrom the physical slot back to the
> ghost entry to be handled robustly. This can be added in a future version

To be clear, this is not a feature gap. In the current form of your
RFC, it is an actual bug: it breaks writeback *completely*. Swapoff
(and reclaim of swap-cache-only physical slots) leaks ghost zswap
swapfile slots that are still backed by these reclaimed slots.

I understand that this is just an RFC, or rather a proof-of-concept of
what you want to propose. But you can't claim it both way. It is only
simpler if you're dropping writeback altogether.

> if there is consensus that writeback-to-physical is a necessary part of
> the design.

I'll not spend my time argue for the necessity of  writeback. I've
already written essays about it, but the fact that we're implementing
new mechanism to trigger writeback (see [4]), optimization on the
writeback path (see [1]), and the fact that even ZRAM has some
writeback mechanism, mean multiple parties are interested. We need to
make it better, not digging ourselves into a hole that prevent it from
moving forwards.

>
> I think the primary motivation for ghost swap is to enable zswap
> usage *without* a backing physical swap device at all =E2=80=94 the "No b=
acking
> store required" mode described in the cover letter.   In that mode,
> writeback never happens (there is no physical device to write to), so
> the swapoff and reclaim questions do not arise. Ghost writeback to a
> physical device is an optional extension for users who want the safety
> net of disk-backed swap. Surely we can discuss and decide if we need
> add it or not.
> >
> > Similarly, say the physical swapfile is full, and you attempt to
> > reclaim a physical swap slot that is swap-cache-only (swap count =3D 0)=
.
> > Say this physical swap slot was allocated from a previous zswap
> > writeback attempt, i.e it has a redirection entry in the ghost zswap
> > swapfile associated with it. Did we handle it somehow?
> >
> > My apologies if I missed it somehow.
> >
> > >
> > > 3. Swap-in from ghost: swap_read_folio() detects the ghost device
> > >    (SWP_GHOST), resolves the Redirect to the physical swp_entry_t,
> > >    and forwards the read I/O to the physical device.
> > >
> > > 4. When the swap cache folio is removed, the Redirect entry is restor=
ed
> > >    from an xarray (redirect_xa) that persists the mapping, so
> > >    subsequent reads still find the physical backing.
> > >
> > > 5. When the physical slot is freed, the ghost slot is also freed,
> > >    cascading through swap_range_free().
> >
> > I don't get how *any* of this is simpler from what I had. If anything,
> > it's more complicated. With a vswap device, you just allocate a
> > physical swap slot (which you also did), change the backend, submit
> > the IO (which you also did), and that's it. No need to juggle this
> > redirect_xa entry. What does this redirect_xa buy us?
>
> The redirect_xa persists the ghost=E2=86=92physical mapping across swap-c=
ache
> folio teardown.
>
> Ghost: redirect_xa[offset] =3D phys  (only allocated when Redirect
>        is active) + swap_table[slot] =3D Redirect(phys) once the
>        swap cache folio is removed

So it's basically the same thing as vswap's vtable, which houses the
redirection, except:

1. It's not cluster-partitioned, so more lock contention.

2. It only holds the redirection temporarily. Which complicates the
logic, because now you have to add more logic to handle the transition
of the redirection entry to the ghost swapfile's swap table?

So it's potentially less efficient, and logic-wise, just as if not
more complicated?

>
> >
> > Not to mention now it entagles generic swap logic into
> > backend-specific code, unnecessarily. And we have more state in the
> > state machine to consider: With a generic vswap device, vswap -> disk
> > swap directly is the same state as vswap -> written back zswap entry.
> > With this zswap ghost swapfile design, you have to treat the latter
> > separately, as there is a redirection entry involved, which means
> > concurrent swap operations interact with it.
>
> I'd argue the opposite.  Ghost swap touches the generic swap paths in
> very few places:
>
>   - swap_read_folio:    one SWP_GHOST branch =E2=86=92 resolve Redirect
>   - __swap_cluster_free_entries: one Redirect check =E2=86=92 cascade fre=
e
>   - __swap_cache_do_del_folio:   one redirect_xa lookup =E2=86=92 restore
>   - zswap_writeback_entry:       one SWP_GHOST branch =E2=86=92 ghost wri=
teback

That's because you just don't handle all the cases required to make it
correct (rmap) and efficient (per-device per-CPU allocation caching)
:)

>
> Ghost swap only affects behavior when a ghost device has been
> explicitly swapon'd, and even then only on the paths listed above.
>
> This is different than virtual swap which is more ambitious. As I said,
> ghost swapfile focuses on the problem itself, and based on the swap
> table.

I'm considering adding a sysctl knob to enable/disable vswap at
runtime in the next version of my patch series. This is trivial, as
even with CONFIG_VSWAP, both the new and the old code paths already
co-exist (as I still keep the old code path as a potential fallback
for the cases when vswap slot allocation fails for whatever reason).

That means that you can get functionally the same thing here if you
want - the old behavior, even with CONFIG_VSWAP.

>
> >
> > 2. No reverse mapping, or at least some mechanisms to handle the case
> > where you have to go from physical swap slots to the upper layer.
>
> Acknowledged =E2=80=94 a reverse mapping can be added in a future version=
 if
> writeback-to-physical becomes a priority.

More like, if you want writeback-to-physical *correct* at all.

> >
> > 3. Charging behavior difference, and deduplication of metadata when we
> > have multiple swap levels. (In fact, you seem to be double charging a
> > writtenback entry here towards the swap counter, not just duplicating
> > the metadata space)
>
> >
> > 4. Infrastructure to make sure allocation from this swap device and
> > allocation from the backing swap device does not invalidate each
> > other's per-cpu allocation cache. You seem to just go for the slow
> > path with alloc_phys_swap_slot() for zswap writeback?
>
> Yes, alloc_phys_swap_slot() uses the slow-path allocator
> (cluster_alloc_swap_entry), which is correct for this low-frequency
> operation.  zswap writeback is not a hot allocation path =E2=80=94 it run=
s
> from the zswap shrinker under memory pressure, typically hundreds to
> thousands of operations per second at most.  The fast-path per-CPU
> caches remain dedicated to folio_alloc_swap(), which handles the
> high-frequency swapout path.  There is no cache invalidation problem
> because the two paths use different allocation mechanisms on different
> devices.

I'm nooot entirely sure about this. Zswap writeback can be quite a hot
path - there is work on optimizing it (see [1] for a recent attempt to
limit the expensive rstat flushing here - and this flushing is *per
shrinker iteration*, whereas the physical device allocation will be
*per writeback*, which is much, much more frequent).

> >
> > It's fine to disagree with any or all of these design choices of mine
> > - I'm receptive to discussion. But it's misleading to say you have a
> > simpler design here, IMHO. My design choices resulted from multiple
> > thoughtful iterations (a lot of them could be found in my
> > pre-swap-table version of vswap) and real production pains.
>
> You're right that "simpler" needs qualification, and I'll update the
> cover letter accordingly.  What I meant =E2=80=94 and what I should have =
stated
> explicitly =E2=80=94 is that ghost swap is less invasive to the existing =
swap
> infrastructure:
>
>   - It does not require a Kconfig option.
>   - It does not create a boot-time device that lives for the kernel's
>     lifetime.

I don't think these 2 are significant.

>   - It does not introduce a new per-cluster data structure
>     (swap_cluster_info_dynamic / virtual_table).

Instead, you add a redirect_xa xarray, which, as I noted above, plays
a *very* similar role (store the redirection), except a bit worse
performance-wise and more complicated.

Again, unless you're willing to drop writeback :)

>   - It does not add a separate per-CPU allocation cache.

This is *by design*, because I want to avoid writeback invalidating
the main allocation path.

If the argument is that it is not a problem, then I'm happy to drop
it. But I don't think that's the case - in fact, as Kairui have
pointed out, what we're moving towards is *every* swap device having
its own per-CPU allocation cache (see [2]). It's really necessary, not
just for vswap, but also for swap tiering (see [3]). So i don't think
the argument (that we don't need separate caching) here is correct,
and it's also immaterial soon enough (once we have generic per-device
per-CPU allocation cache I'll drop the vswap-specific one).

>   - It does not split the swap entry namespace into "vswap" vs
>     "physical" =E2=80=94 a ghost device is just another swap device with =
one
>     extra flag and one extra swap-table entry type.

Actually, if we're to take in your full design, it's *two* entry
types. It's the redirection entry (if you want to support writeback) +
the Pointer entry (for your zswap "optimization").

>
> I think VSS goes beyond solving the "zswap without backing store"
> problem =E2=80=94 it is fundamentally an architectural restructuring of t=
he
> swap subsystem, with virtual swap as a first-class abstraction layered
> above physical devices.  That is both its strength (comprehensive,
> future-proof) and its trade-off (more invasive to existing paths).
> I respect that.
>
> My goal with ghost swap is different: address the immediate pain point
> with the smallest possible change to the existing infrastructure.  Both
> approaches have value, and I hope the community discussion will help
> identify the right balance.

That's because I believe "zswap without backing store" just by itself
is a bit narrow of a problem. It's certainly nice to fix, but it's
more of a nuisance - you already have userspace hacks for it (as I
mentioned above).

The problem I'm trying to solve is to support:

1. Writeback.

2. Dynamicity.

3. Decoupled backends.

all of which are motivated by real production issues, not some
theoretical problems. I'm concerned that if we only focus on the third
goal, we'll dig ourself into a hole that prevents us from solving 1
and 2 efficiently down the line.

>
> Thank you again for the detailed review =E2=80=94 it has already clarifie=
d
> which parts of the design need more thought and documentation, and will
> make the next version stronger.

I really don't want to be antagonistic, but I hope you'd take the real
production pains that we've had (and have tried to communicate in
multiple mailing threads, across a timeline of almost 2 years at this
point) seriously.

Collaborations should go both ways. I've gone out of my way to try to
address the concerns of various parties, from spending *multiple
weeks* testing and investigating performance regression on zram
backend (which my company does not use), to a rewrite/re-design of
virtual swap to accommodate parties who wished to opt out of virtual
swap for now.

I hope you can extend the same good will to our needs :) I've included
you (and other swap folks such as Chris and Kairui) in my cc-lists. If
you have concerns, you could have commented. Instead, you decided to
send a patch series, which is basically just the ghost swapfile, with
a bit of afterthought to handle writeback and dynamicity, rather
inefficiently (no dedicated per-CPU caching), and not even correctly
(the lack of rmap means swapoff / swap-cache-only physical swap slot
reclaim is broken).

I respect you and Chris very much to assume bad faith, but please work
with me rather than against me.

[1]: https://lore.kernel.org/all/20260702180908.150136-1-yunzhao@cloudflare=
.com/
[2]: https://lore.kernel.org/all/CAMgjq7BhOn48xEyC=3D2j837R7qddfjeBVHMiRqdx=
8no4ZEBpBLg@mail.gmail.com/
[3]: https://lore.kernel.org/linux-mm/ah0BfRFv285gWph8@yjaykim-PowerEdge-T3=
30/
[4]: https://lore.kernel.org/all/20260629112032.20423-1-jiahao.kernel@gmail=
.com/
[5]: https://lore.kernel.org/all/20260505153854.1612033-1-nphamcs@gmail.com=
/

