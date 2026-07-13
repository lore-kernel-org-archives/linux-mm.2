Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E667C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:47:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D1DC6B00E9; Mon, 13 Jul 2026 13:47:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9E56B010D; Mon, 13 Jul 2026 13:47:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BF0B6B0113; Mon, 13 Jul 2026 13:47:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29FF26B00E9
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:47:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3274160118
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:47:53 +0000 (UTC)
X-FDA: 84984486426.24.BE405E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 839AB4000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:47:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Qp+N1U6/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783964871;
	b=WTiZe1bx2Xpy0CbGYXPKZmmtwzOAu3GGt5PiUxBxm0I5tWY4RUr77z7axCaaqeJzOD+cJA
	Job71jyhpDtUtd/m0aMZELC7KpNFO5N+YqT/UYJenFSc98EKeZrClup37DyWRcE9nNQd3m
	DjpQ/vvTNvI6+AzEz3TlaWc9Og1Vp8I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Qp+N1U6/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783964871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7U/Ji4WSzIKjRcqrxpbhQJCKg/0RmyqfQoTtNPOQdWk=;
	b=JZb16jy+UFv6wnvIb+njCIDi6N4TCesNCnWhOCU5yGFFY0a4h/4qFs+HtDc/yy/V51hKGo
	+CTo+v2ykpO+pIhAdIwk2HIO6YLI4lgU0Sn6hV2O5nxskUJj+pvMLadNS1EpnyoajQ6Yfe
	WWEJZUgXaxu1Cu0dJ7vebQ5SyJHFnYU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D917412CF
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B01F1F000E9
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783964870;
	bh=7U/Ji4WSzIKjRcqrxpbhQJCKg/0RmyqfQoTtNPOQdWk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Qp+N1U6/NkvZbgpQxUGeImC1derPQ1R2CoApvX/1On/nm8tb0RAR03ZfJ2Zx9s9G8
	 7JnMxxDlJAF+TfBrvSmfZyYPFanAqWB9XQru3HqrKHuVyVAY8EXsPIxBX/JIjUkuRZ
	 Qya5SeM/b/VvO7pbyHzMwNoaK4jcGYLCZNPEeQpvhss8zBEZFWxohYVG0IjhWdjoj6
	 hJQEaUAbXzAyY8MTKjhWZHsHn1yyD4NaZBxoY6zABAJgiY5+N5Qs6HRGSQeeLftqid
	 JfgfmBGD2Lp3lWQmsGGnPzZLdqKY+iEcg+fRk9jrNMQFryq323jwaKQyQrg99PpnCm
	 BBuwPthLSeCgA==
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-667f29dc8a4so184684d50.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:47:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqqt4ABejStqd1my934HJThoK0/InBDK/owZ5uOZ3fCfGJaDPNFn3ALYuGUAtBp1eKwoeNissOiEg==@kvack.org
X-Gm-Message-State: AOJu0Yw+tgYxObeyY+RsCmQYoSt8byiHaJoastdb8LwBe40xQDCcrxME
	VdrJnj1RfcseRTpbofaS7gSlu7/V4lxdeNNLEaVImAxwz57131+Eoql8yN5VRciB0QiBS3bH9xl
	UUk3RXpPKsxFhV/4L72UDRVAKPNxE0vv9Rxe8x90R6A==
X-Received: by 2002:a05:690e:488e:20b0:668:195:9983 with SMTP id
 956f58d0204a3-66801959d49mr615579d50.103.1783964869754; Mon, 13 Jul 2026
 10:47:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260707082614.95030-1-baoquan.he@linux.dev> <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
 <ak-IS61GeP85Jnxg@MiWiFi-R3L-srv> <CAKEwX=PEgnJ4nGFZYUwMryjq+Yp4v8Op_HdZ6_xEJ4n_MrM0Yw@mail.gmail.com>
In-Reply-To: <CAKEwX=PEgnJ4nGFZYUwMryjq+Yp4v8Op_HdZ6_xEJ4n_MrM0Yw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 13 Jul 2026 10:47:37 -0700
X-Gmail-Original-Message-ID: <CACePvbUQGMuNvr613TFUN4ttjDXy56jWDJ7MBD1RXtxMzuA=wg@mail.gmail.com>
X-Gm-Features: AVVi8CfzCRfcFcUqgx66_sai_7R1wYEDBXHbyrwMnhxeYCYHS6jp-LL3rG4OeZU
Message-ID: <CACePvbUQGMuNvr613TFUN4ttjDXy56jWDJ7MBD1RXtxMzuA=wg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
To: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 839AB4000A
X-Rspam-User: 
X-Stat-Signature: a9ppk1ogg8mdgn98zrgjn3z4mn4sg8to
X-Rspamd-Server: rspam03
X-HE-Tag: 1783964871-645319
X-HE-Meta: U2FsdGVkX19+Nrxfk7ztopv5gSmskAYTyenzccwQQq9UYB/9NhDmOJLWKQHW7bAYEa0jsg82xgMCH65JaS26nsRXbfiwzp3yh5CkkF9VjSEJhr8gXg1ru2KhCO84uADAckQpbT/XHEZdQdpxDUFtbSrVdVnE8tZwnYGJXAJv/uS2vkMQC83odJSTfYXcQkXtFGjPabZYyGo50du7YPk0ghavPskXlaUpt7i8vY8xq6rweRDoS1qzNLxAxRhYDEUbTrNrzFonJy+m2RLr9fCTgLrSlI4hbmfqA7IUzIGK1o0RwVx+yWGn9eTrvXQh8Px2yltJQc9nFbWwB0I6HFPJ4CLtrBKuj2CjhDT5ING8GZDPDnLA1JpjRAPAUeoh4JzI2rT5sK9HcjDdH+sFGjqAgEkny0cu3gKU+4K3HpYFPwZlCulpkHdp/NrQmqgetFc+JlKqgj4q9i3/to1cfrMbPJROJNMH0eu/GyNqGObN/eRR+c8FaSw6I/dPbeKEcHKOncfBfk4tu7LUwIOdSsUYpL3hKZPTof0vn9xNr0Vj8pxmevcjkxHUJIv/r06XoPZieBJJ80HrcWXMfXAGmi3rnjdJiodINT2haETvkmKfYoUsUkilDCL3sUpJ0oxR/zk6TkfrVb0MlQHO0Vi4J9AERCg4SE7m6TSyDVIU1NwU9OkfuyUd3OLj/O0tDVnwN5fUq3X/or0kftPDPl7xfzr0IARdgPmQGIYSXoaoEkzqzuD6NmMdlWLv1TNO9Y2GnPXtQuMAqKlJGq9gfvYc+2tnSjXzWxSQ4x8bRXEIatEIVjunNLc2XDgF24sD2C7dC3bQM1OXd00wS2IWnKfKUFPxBNMzt4bP2WysYpP01yjOPMI/Oa0Y4uay/KuAmxmwKKPVlDe5bq3rop+khSmhO3bkNxsimL1rmp3auXC8xkqRtivsR0SNxyapwCyyr3RAcIQHI/0dqi3QBKV0Lblpac9
 HXYSwq46
 VzhQtzHEOQ5yO2vP5b6rY+tI5dEZR01epzyatLmC9+CUCG+VJg6WNrvk/6BgVhx8iWHwl9mjP/q5RUG4HxsJaAj7ptnhV5QJL5kuLU+BgCMv1nSv6LxlZrDwIPC+IOH0Y0cvMx5s5fneSOoh7V9U+FoithXPZlwFeXo34Lfwv5jEVEd3At+bxA6sYe5D5BdA9jPHYAS1bZoM2j9jeXFfYpkE23HIUCRj0abvMJlAppGczbv7tvbMTfeivdJQZzOVvpVgDRA2MFBPqWt811/NI/azEtn6pf2VMqnw5M7gUpsZdDP3I0H7eC3H1eA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 12, 2026 at 5:02=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Thu, Jul 9, 2026 at 4:39=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> =
wrote:
> >
> >
> > Thanks for the thorough review, Nhat.
> > >
> > > We don't want to put additional operational burden on users. Besides,
> > > expecting userspace to react to swap space being filled, especially
> > > under memory pressure (at which point userspace processes might be
> > > stalling already), is tricky.
> >
> > The manual sysfs extension is the minimal viable interface for the RFC,
> > not the final choice. But even in its current form, it is a dramatic
> > improvement over the status quo.
> >
> > Today, to use zswap you MUST provision a physical swap device of the
> > same size as the swap capacity wanted =E2=80=94 even though most of tha=
t disk
> > space will never be touched.  With ghost swap, you swapon a ghost
> > device at whatever size you expect to need (e.g. 64 GB), and if your
> > workload grows, you grow it via sysfs.  That is already a step
> > change in operational simplicity: no disk pre-provisioning, no wasted
> > storage, and a one-line resize when needed.
>
> If these are the only three requirements you have, in fact, you can
> already achieve something equivalent to a ghost swapfile: just put
> zswap on top of any of the in-memory swapfile (and perhaps disable
> writeback, although with careful limit setting it's almost impossible
> to trigger writeback with zswap in newer kernels anyway).  I know this
> works, because I even run tests with zswap-on-top of zram :) You can
> swapon new swapfiles to support your "userspace-triggered" growth
> strategy.
>
> >
> > Automatic growth can be considered later if it's really demanded.
>
> It is really, really necessary. Please read my older virtual swap
> space patch series for why it's necessary (see [5]).
>
> >
> > >
> > > This is especially bad when redirection entry still eats up space in
> > > the upper level (ghost zswap) swapfile. You will run out of zswap
> > > space really fast under concurrent zswap store and zswap writeback.
> >
> > I think there is a misunderstanding here.  A Redirect entry does not
> > consume an *additional* ghost slot.  Before writeback, the ghost slot
> > held a Pointer entry (zswap).  After writeback, that same slot holds a
> > Redirect entry (pointing to the physical device).  It's a state
> > transition =E2=80=94 one slot, one entry =E2=80=94 not an extra allocat=
ion.  The ghost
> > device's total capacity is unchanged by writeback activity.
>
> No, what I meant is, after writeback, you still hold on to the old
> slot on the ghost device, AND a new slot on the physical device,
> correct?
>
> >
> > >
> > > >   sysfs, up to a current maximum of 1TB.  This is implemented throu=
gh
> > > >   lazy vmalloc: a sparse 64MB virtual address space is reserved at
> > > >   swapon time to cover the full 1TB range, but physical pages for
> > >
> > > This range seems a bit small, especially from something essentially f=
ixed.
> >
> > The 1TB limit comes from a conservative 64 MB sparse vmalloc reservatio=
n
> > in RFC. It certainly can be redefined as a bigger one which is more
> > reasonable in reality. For most real-world deployments today, 1 TB per
> > ghost device =E2=80=94 with support for multiple ghost devices =E2=80=
=94 is more than
> > sufficient.
>
> I beg to differ. We already have multi-terrabyte scale machines in
> production in multiple places, and more and more overcommitting. At
> least make this configurable.
>
> >
> > >
> > > >   cluster_info[] structures are allocated only on demand as the dev=
ice
> > > >   grows.  The cluster_info pointer never changes, so all existing
> > > >   accessors (__swap_offset_to_cluster, cluster_index) work unchange=
d.
> > > >
> > > > - sysfs control.  Each ghost device exposes attributes under
> > > >   /sys/kernel/mm/ghost_swap/ghost_<N>/:
> > > >     path (RO) =E2=80=94 backing device name
> > > >     max  (RW) =E2=80=94 current max pages; writing a larger value t=
riggers
> > > >                 swap_ghost_extend_max()
> > > >
> > > > Design overview
> > > > ---------------
> > > > A swap table slot can now hold a Redirect entry:
> > > >
> > > >   Redirect: |----- physical swp_entry_t -----|101|
> > > >
> > > > This stores a plain swp_entry_t pointing to a slot on a real (physi=
cal)
> > > > swap device.  The low 3-bit mark (0b101) distinguishes it from Poin=
ter
> > > > (0b100), PFN (0b10), Shadow (0b1), and NULL (0) entries.
> > > >
> > > > The lifecycle is:
> > > >
> > > > 1. swapon a ghost device =E2=80=94 reserves sparse vmalloc area (64=
MB virtual)
> > > >    and physically backs only the initial range.  The device starts =
with
> > > >    no physical backing store: pages swapped out go to zswap, and zs=
wap
> > > >    pool evictions go to any concurrently attached physical device.
> > >
> > > If you think this data structure is superior to the xarray for dynami=
c
> > > swap address, it's a fairly simple change on top of what I had in the
> > > virtual swap RFC, no?
> >
> > I appreciate the suggestion. However, the difference between the two
> > approaches goes beyond the cluster allocation strategy =E2=80=94 it's
> > the overall architecture:
> >
> > - Virtual swap introduces a mandatory, always-on vswap device (CONFIG_V=
SWAP).
> >   with per-cluster virtual_table arrays, xarray-backed dynamic clusters=
.
> >   per-CPU allocation caching.
> >
> > - Ghost swap extends the existing swap device model with one new entry
> >   type (Redirect, 0b101) and one new flag (SWP_GHOST).  It reuses
> >   swapon/swapoff, the existing allocator, and the swap cache
> >   essentially unchanged.  No Kconfig option is needed.
> >
> > These are two explorations of the same problem, while virtual swap goes
> > far beyond the problem itself, the decoupling of physical swap and
> > virtal zswap. We can discuss and choose one approach.
>
> If my problems are real, why do we have to choose? If we go with my
> approach, all of our problems are solved. If we go with your approach,
> then your problem is solved, with a promise that my problems will be
> tackled in the future.
>
> >
> > >
> > > It can be grafted on top of what I had in a subsequent patch, or
> > > squashed into my first patch. If you have concerns with me
> > > implementing your idea here, I'd take your code if it proves to be
> > > superior.
> > >
> > > >
> > > > 2. zswap writeback from ghost: when the zswap pool needs to evict,
> > > >    zswap_writeback_ghost() allocates a physical slot from any real
> > > >    swap device, writes the data there, and plants a Redirect entry
> > > >    in the ghost's swap table pointing to the physical slot.
> > >
> > > What if user swapoff the physical swapfile, whose slot is backing a
> > > redirection entry of a ghost swapfile, rather than a PTE. Has this
> > > been handled yet?
> >
> >
> > This is a gap in the current RFC.  Both swapoff and physical-slot
> > reclaim would need a reverse mappingfrom the physical slot back to the
> > ghost entry to be handled robustly. This can be added in a future versi=
on
>
> To be clear, this is not a feature gap. In the current form of your
> RFC, it is an actual bug: it breaks writeback *completely*. Swapoff
> (and reclaim of swap-cache-only physical slots) leaks ghost zswap
> swapfile slots that are still backed by these reclaimed slots.
>
> I understand that this is just an RFC, or rather a proof-of-concept of
> what you want to propose. But you can't claim it both way. It is only
> simpler if you're dropping writeback altogether.
>
> > if there is consensus that writeback-to-physical is a necessary part of
> > the design.
>
> I'll not spend my time argue for the necessity of  writeback. I've
> already written essays about it, but the fact that we're implementing
> new mechanism to trigger writeback (see [4]), optimization on the
> writeback path (see [1]), and the fact that even ZRAM has some
> writeback mechanism, mean multiple parties are interested. We need to
> make it better, not digging ourselves into a hole that prevent it from
> moving forwards.
>
> >
> > I think the primary motivation for ghost swap is to enable zswap
> > usage *without* a backing physical swap device at all =E2=80=94 the "No=
 backing
> > store required" mode described in the cover letter.   In that mode,
> > writeback never happens (there is no physical device to write to), so
> > the swapoff and reclaim questions do not arise. Ghost writeback to a
> > physical device is an optional extension for users who want the safety
> > net of disk-backed swap. Surely we can discuss and decide if we need
> > add it or not.
> > >
> > > Similarly, say the physical swapfile is full, and you attempt to
> > > reclaim a physical swap slot that is swap-cache-only (swap count =3D =
0).
> > > Say this physical swap slot was allocated from a previous zswap
> > > writeback attempt, i.e it has a redirection entry in the ghost zswap
> > > swapfile associated with it. Did we handle it somehow?
> > >
> > > My apologies if I missed it somehow.
> > >
> > > >
> > > > 3. Swap-in from ghost: swap_read_folio() detects the ghost device
> > > >    (SWP_GHOST), resolves the Redirect to the physical swp_entry_t,
> > > >    and forwards the read I/O to the physical device.
> > > >
> > > > 4. When the swap cache folio is removed, the Redirect entry is rest=
ored
> > > >    from an xarray (redirect_xa) that persists the mapping, so
> > > >    subsequent reads still find the physical backing.
> > > >
> > > > 5. When the physical slot is freed, the ghost slot is also freed,
> > > >    cascading through swap_range_free().
> > >
> > > I don't get how *any* of this is simpler from what I had. If anything=
,
> > > it's more complicated. With a vswap device, you just allocate a
> > > physical swap slot (which you also did), change the backend, submit
> > > the IO (which you also did), and that's it. No need to juggle this
> > > redirect_xa entry. What does this redirect_xa buy us?
> >
> > The redirect_xa persists the ghost=E2=86=92physical mapping across swap=
-cache
> > folio teardown.
> >
> > Ghost: redirect_xa[offset] =3D phys  (only allocated when Redirect
> >        is active) + swap_table[slot] =3D Redirect(phys) once the
> >        swap cache folio is removed
>
> So it's basically the same thing as vswap's vtable, which houses the
> redirection, except:
>
> 1. It's not cluster-partitioned, so more lock contention.
>
> 2. It only holds the redirection temporarily. Which complicates the
> logic, because now you have to add more logic to handle the transition
> of the redirection entry to the ghost swapfile's swap table?
>
> So it's potentially less efficient, and logic-wise, just as if not
> more complicated?
>
> >
> > >
> > > Not to mention now it entagles generic swap logic into
> > > backend-specific code, unnecessarily. And we have more state in the
> > > state machine to consider: With a generic vswap device, vswap -> disk
> > > swap directly is the same state as vswap -> written back zswap entry.
> > > With this zswap ghost swapfile design, you have to treat the latter
> > > separately, as there is a redirection entry involved, which means
> > > concurrent swap operations interact with it.
> >
> > I'd argue the opposite.  Ghost swap touches the generic swap paths in
> > very few places:
> >
> >   - swap_read_folio:    one SWP_GHOST branch =E2=86=92 resolve Redirect
> >   - __swap_cluster_free_entries: one Redirect check =E2=86=92 cascade f=
ree
> >   - __swap_cache_do_del_folio:   one redirect_xa lookup =E2=86=92 resto=
re
> >   - zswap_writeback_entry:       one SWP_GHOST branch =E2=86=92 ghost w=
riteback
>
> That's because you just don't handle all the cases required to make it
> correct (rmap) and efficient (per-device per-CPU allocation caching)
> :)
>
> >
> > Ghost swap only affects behavior when a ghost device has been
> > explicitly swapon'd, and even then only on the paths listed above.
> >
> > This is different than virtual swap which is more ambitious. As I said,
> > ghost swapfile focuses on the problem itself, and based on the swap
> > table.
>
> I'm considering adding a sysctl knob to enable/disable vswap at
> runtime in the next version of my patch series. This is trivial, as
> even with CONFIG_VSWAP, both the new and the old code paths already
> co-exist (as I still keep the old code path as a potential fallback
> for the cases when vswap slot allocation fails for whatever reason).
>
> That means that you can get functionally the same thing here if you
> want - the old behavior, even with CONFIG_VSWAP.
>
> >
> > >
> > > 2. No reverse mapping, or at least some mechanisms to handle the case
> > > where you have to go from physical swap slots to the upper layer.
> >
> > Acknowledged =E2=80=94 a reverse mapping can be added in a future versi=
on if
> > writeback-to-physical becomes a priority.
>
> More like, if you want writeback-to-physical *correct* at all.
>
> > >
> > > 3. Charging behavior difference, and deduplication of metadata when w=
e
> > > have multiple swap levels. (In fact, you seem to be double charging a
> > > writtenback entry here towards the swap counter, not just duplicating
> > > the metadata space)
> >
> > >
> > > 4. Infrastructure to make sure allocation from this swap device and
> > > allocation from the backing swap device does not invalidate each
> > > other's per-cpu allocation cache. You seem to just go for the slow
> > > path with alloc_phys_swap_slot() for zswap writeback?
> >
> > Yes, alloc_phys_swap_slot() uses the slow-path allocator
> > (cluster_alloc_swap_entry), which is correct for this low-frequency
> > operation.  zswap writeback is not a hot allocation path =E2=80=94 it r=
uns
> > from the zswap shrinker under memory pressure, typically hundreds to
> > thousands of operations per second at most.  The fast-path per-CPU
> > caches remain dedicated to folio_alloc_swap(), which handles the
> > high-frequency swapout path.  There is no cache invalidation problem
> > because the two paths use different allocation mechanisms on different
> > devices.
>
> I'm nooot entirely sure about this. Zswap writeback can be quite a hot
> path - there is work on optimizing it (see [1] for a recent attempt to
> limit the expensive rstat flushing here - and this flushing is *per
> shrinker iteration*, whereas the physical device allocation will be
> *per writeback*, which is much, much more frequent).
>
> > >
> > > It's fine to disagree with any or all of these design choices of mine
> > > - I'm receptive to discussion. But it's misleading to say you have a
> > > simpler design here, IMHO. My design choices resulted from multiple
> > > thoughtful iterations (a lot of them could be found in my
> > > pre-swap-table version of vswap) and real production pains.
> >
> > You're right that "simpler" needs qualification, and I'll update the
> > cover letter accordingly.  What I meant =E2=80=94 and what I should hav=
e stated
> > explicitly =E2=80=94 is that ghost swap is less invasive to the existin=
g swap
> > infrastructure:
> >
> >   - It does not require a Kconfig option.
> >   - It does not create a boot-time device that lives for the kernel's
> >     lifetime.
>
> I don't think these 2 are significant.
>
> >   - It does not introduce a new per-cluster data structure
> >     (swap_cluster_info_dynamic / virtual_table).
>
> Instead, you add a redirect_xa xarray, which, as I noted above, plays
> a *very* similar role (store the redirection), except a bit worse
> performance-wise and more complicated.
>
> Again, unless you're willing to drop writeback :)
>
> >   - It does not add a separate per-CPU allocation cache.
>
> This is *by design*, because I want to avoid writeback invalidating
> the main allocation path.
>
> If the argument is that it is not a problem, then I'm happy to drop
> it. But I don't think that's the case - in fact, as Kairui have
> pointed out, what we're moving towards is *every* swap device having
> its own per-CPU allocation cache (see [2]). It's really necessary, not
> just for vswap, but also for swap tiering (see [3]). So i don't think
> the argument (that we don't need separate caching) here is correct,
> and it's also immaterial soon enough (once we have generic per-device
> per-CPU allocation cache I'll drop the vswap-specific one).
>
> >   - It does not split the swap entry namespace into "vswap" vs
> >     "physical" =E2=80=94 a ghost device is just another swap device wit=
h one
> >     extra flag and one extra swap-table entry type.
>
> Actually, if we're to take in your full design, it's *two* entry
> types. It's the redirection entry (if you want to support writeback) +
> the Pointer entry (for your zswap "optimization").
>
> >
> > I think VSS goes beyond solving the "zswap without backing store"
> > problem =E2=80=94 it is fundamentally an architectural restructuring of=
 the
> > swap subsystem, with virtual swap as a first-class abstraction layered
> > above physical devices.  That is both its strength (comprehensive,
> > future-proof) and its trade-off (more invasive to existing paths).
> > I respect that.
> >
> > My goal with ghost swap is different: address the immediate pain point
> > with the smallest possible change to the existing infrastructure.  Both
> > approaches have value, and I hope the community discussion will help
> > identify the right balance.
>
> That's because I believe "zswap without backing store" just by itself
> is a bit narrow of a problem. It's certainly nice to fix, but it's
> more of a nuisance - you already have userspace hacks for it (as I
> mentioned above).
>
> The problem I'm trying to solve is to support:
>
> 1. Writeback.
>
> 2. Dynamicity.
>
> 3. Decoupled backends.
>
> all of which are motivated by real production issues, not some
> theoretical problems. I'm concerned that if we only focus on the third
> goal, we'll dig ourself into a hole that prevents us from solving 1
> and 2 efficiently down the line.
>
> >
> > Thank you again for the detailed review =E2=80=94 it has already clarif=
ied
> > which parts of the design need more thought and documentation, and will
> > make the next version stronger.
>
> I really don't want to be antagonistic, but I hope you'd take the real
> production pains that we've had (and have tried to communicate in
> multiple mailing threads, across a timeline of almost 2 years at this
> point) seriously.
>
> Collaborations should go both ways. I've gone out of my way to try to
> address the concerns of various parties, from spending *multiple
> weeks* testing and investigating performance regression on zram
> backend (which my company does not use), to a rewrite/re-design of
> virtual swap to accommodate parties who wished to opt out of virtual
> swap for now.
>
> I hope you can extend the same good will to our needs :) I've included
> you (and other swap folks such as Chris and Kairui) in my cc-lists. If
> you have concerns, you could have commented. Instead, you decided to
> send a patch series, which is basically just the ghost swapfile, with
> a bit of afterthought to handle writeback and dynamicity, rather
> inefficiently (no dedicated per-CPU caching), and not even correctly
> (the lack of rmap means swapoff / swap-cache-only physical swap slot
> reclaim is broken).
>
> I respect you and Chris very much to assume bad faith, but please work
> with me rather than against me.

Hi Nhat,

Please read my above email. I agree with you that the ghost swapfile
writeback feature seems a bit premature. I suggested dropping the
ghost swapfile writeback from this series and focusing on generic
swapfile growing, because the swap device can actually grow outside of
the virtual context as well.

Growing a swap device does not mean it has to have another xarray or
indirection sitting in front of it. That is what I want to see
happening. It is actually more efficient without it.

As to your VS series, I have already made my comments on earlier
series and I am not going to repeat myself too much. I suggest taking
a more incremental approach rather than trying to solve all the
problems at once. Another thing is that, is there any reason the VS
can't be done on a per swap file using the swap ops approach? Assume
you can modify the swap ops to fit your need. That way you don't force
zram to take your VS layer as an additional penalty.

Given the choice between two approaches, if everything else is equal,
one forces an extra layer while the other does not. I would pick the
later one any time. Again if one extra layer is compile time, the
other one extra layer is run time. If everything else is equal, I
would prefer the runtime layer.

Thanks

Chris

