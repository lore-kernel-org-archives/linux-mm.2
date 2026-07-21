Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A809C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:03:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC6316B0093; Tue, 21 Jul 2026 14:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D784F6B0095; Tue, 21 Jul 2026 14:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3F906B0096; Tue, 21 Jul 2026 14:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF936B0093
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:03:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C1421C02B1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:03:44 +0000 (UTC)
X-FDA: 85013556768.24.DC6B6B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8E4B8160006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:03:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P0ue+JtV;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784657022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=40DlVF8YWAaA6BEtxce78kvuBS8jA9Ra9nOJJYpwzcM=;
	b=SOY8CfMP7sqHgeCB//JiM5Px5MawSURLHrNcNwQAYJgDh41hunMAVUHAgqLbHNR+Rpjv6B
	LmQy1s0oSC/L9vUI3qp6HSO9a3M1pSG5eyAEcuGtAyeeqx9+um9SUJpspVewZK0F/cD1kY
	h+MQhAQMHali3p0Q7/4yNargJ/DEj88=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784657022;
	b=LNezZ6VDGlv3jS7faHID2EhL8ED64E9UU2fqn0LAIPD730MrhjbNZfbA/XbOT7mCC9XsQV
	z6suZBplGeCZIOQJ+xja4Z8dlfX0LLOA64dLAUWDiQh2lkWB1inCbEECtQ2GLJRbrKKeYt
	Dj/tKW4/hQjv+kkRU7sedHe1zdmh11E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P0ue+JtV;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C12A42B61
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9E91F00AC4
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784657021;
	bh=40DlVF8YWAaA6BEtxce78kvuBS8jA9Ra9nOJJYpwzcM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=P0ue+JtV/FVzJlahZBFToj/R+1/z8yTndcfvVRW41HGEME1EGIXX5CVlw5SVk4/42
	 Ag++CE/t1ZWHGTZl4QzkvTuW0Ew8IV/F3+KvuW6YXrF/GsFcN6IFZOMeiqsaDnC8mr
	 wwFTlpbtpBlnvsymRmorH8oX86xDKr5XOp1/l+rpjPRifBUpepsnu9hZm8CcECa+4t
	 NcW5X9mKFa6KEyFlYrjUhYsfbHm2SGsck7wnccS+eVSFGOK3xD6xWzhzehj0y7soP8
	 BdhTuMJsxL5rXmf3QAbqbzFuKsib+zlo0CVTTNPgf0hxLWNHvskSbB7uN79wWqhx3Y
	 o5LM6u1hsfcsw==
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-81ed073fed0so79538427b3.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:03:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrdU3E9Zk0CFROfpTFkxJT2jAIk6PqP3UjZOScHvKCYJ8FdozdlEkC1Vbt9MEgCdwdan4k4L6uz+g==@kvack.org
X-Gm-Message-State: AOJu0YxKFGGZ8udS7eCGpZNNzGss6ZXx7/lNSsuDhuBEvbU59ExJ+0MO
	03lJmtDzISYgbTw0wzw8PqhqpkDN2EL+HNjx0ogmfuQKu+k/d2AnJmXzgKCHhBTYokgud7NqSFs
	FXQGLuFOAsJMTSr/wic1eL5+5l6GT19UYGlh26hZ2mg==
X-Received: by 2002:a05:690c:6b0b:b0:81d:26f9:bc82 with SMTP id
 00721157ae682-81ef26b4f7dmr66783587b3.57.1784657020648; Tue, 21 Jul 2026
 11:03:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
 <ak-IS61GeP85Jnxg@MiWiFi-R3L-srv> <CAKEwX=PEgnJ4nGFZYUwMryjq+Yp4v8Op_HdZ6_xEJ4n_MrM0Yw@mail.gmail.com>
 <aldtS2S-TXc7ocsH@MiWiFi-R3L-srv> <aleW5xL2gYcU_Rl4@MiWiFi-R3L-srv>
 <CAKEwX=Pm_C6OD1jAo818wzFVVhLwgVFu-4bLdNrmUZ01URpLTQ@mail.gmail.com>
 <CACePvbV62T9LA894vTXzBZQ2PNh6iYZD7eH6=UjeFSWhUW2aDA@mail.gmail.com>
 <CAKEwX=NXJ1LKQOA8Qy_4YOS6v+jGbAJnbD5K0=jNbgC8Da0iKw@mail.gmail.com>
 <alo7tuEKLjA0IZQe@MiWiFi-R3L-srv> <CAKEwX=Pm2=fdPYE6e0o8bO2sazACwGhKCpstii-P-8P2AxWGDQ@mail.gmail.com>
 <al8ohWshSSZ64AtT@MiWiFi-R3L-srv>
In-Reply-To: <al8ohWshSSZ64AtT@MiWiFi-R3L-srv>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 21 Jul 2026 11:03:28 -0700
X-Gmail-Original-Message-ID: <CACePvbUBfut0rjfK_4MTGrp09KHSXxtU7neS7O_eLNW8co-DaQ@mail.gmail.com>
X-Gm-Features: AUfX_mxtnDN3RRyBaA5aVa1Gt2lTjaXdZI4XIOqO1GD4TKGbRzuj0wU2ra8wC6c
Message-ID: <CACePvbUBfut0rjfK_4MTGrp09KHSXxtU7neS7O_eLNW8co-DaQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
To: Baoquan He <baoquan.he@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8E4B8160006
X-Stat-Signature: x6ab88boyohzsqjisyccn7aupmjakwbz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784657022-7754
X-HE-Meta: U2FsdGVkX182HHgw26jIcmQZCAudsb45orL+YPKBDET9H7j6m8VxzCi+6/xCftgWawpfVVJi/NqEsMqpd2cV4g6bPwFFaVqJgKABgxwhtKytlNSFLduxqZ5biZHwA1tGKD7VtdepfCZkYR4DwfLy2E32lZwLWhidj9q4NRct/34HrTyVXrj2jls004qUPCsGl+Gos1jmqBiWWtuc62uopuNZsrP4O1j4uHCh3VKkKP+2Bu9I4DHAxr5KFDMyhvIo0qUmZO6Uo7oiExYudt6eFJzclimidtOWwygTHJkSv4+DJutjF79AVz/4dIp8FSHjF5+FogAHZ4HJny4mPRJhePgeYz0gl6dKAY12lk+VMmG5SNVnHazgtK+DKfAbHKbvVbmB+9+PdgLEJ6B/oKB0r+ZKjNJ6nSdt47I9Sv+K9oKf4Koq4VNHNTGtkiQNIUdWrfiZ/OnPdMErl3XxVGO/fdht9lSqBa5nN9Zon9y2LNo4ZoAi3gZ4H2DGjRhdy/jHpjsDdzOVnonZP13f+N99r2dV0ZyJ49pyJp7JVbtkT8VPjCywtMnbme6pB3pI5yGHLWzbplTPAb7V11X2crNtV+jsv8k3Q1HY2z5P8hHSji4Dd0QK5tQTEKwkWZA4D1DVeLEFfVoyVyJP7TWGexMm5XWyiq3rJXZ371UVEWGGCEiV8/1/UGHERDhGF9mznfyC+O3yKcX+47u4DaZBvjjTbREWCx0MSn4NAbkmHxpm8Dqy5d2kSkOBcJ2vj2J6z9plD9Vf0xxXuR47qQv9/a1frQzJtyhluWCv1I2dSk2CxsPJ6xJzuV3/WVnoprKopG+aiXwmnaAPpY9Fv1JzrG98lVut4TUpEAeGJ/5NbEOZoj5skrbreV8KGJ0s01ul7vBzZaXEevmIMc0cSIeIKZhnPJNPqCQ9d7NvSi9fH+DNEC4KS7TjvKzFXaWxyf5dm43wvMN0ovSvsDeejJJNhHo
 vFDtu7sz
 V3qTj0QBq2MfUjtbw80IC6bP1tUj/Gx1NuI0rz3mya63GSceNYYhJqIQaE5RDhHtOICc4j//L3c1ZkliNkLtaN3LBiyGD0CjXFvU9ISOxmC36zIlW+aCHJaJJcq8j8mGCbvOYrw57MfIYvqbDT5owoe0J945hDWU8uoOLrGHwJ844Jtw5dQ/zCw/PBI0Ds2e39xOt6Jeg5sIs4EVEMbpk8yZeEdmYbWUspxQb30rfT2z+PtgYeMrTuYMnnN7CGjdn8cb+MUYFWvKieK/hAhechBTlqSfiG/WiKYkh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 1:06=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> On 07/17/26 at 09:02am, Nhat Pham wrote:
> > On Fri, Jul 17, 2026 at 7:27=E2=80=AFAM Baoquan He <baoquan.he@linux.de=
v> wrote:
> > >
> > > On 07/16/26 at 09:49am, Nhat Pham wrote:
> > >
> > > Thanks for the thoughtful reply and the very constructive proposal.
> > > Your suggestion about moving forward in small, incremental steps in
> > > last mail is really appealing =E2=80=94 I think that's the right way =
to make
> > > progress on this. I need a little time to think it through more
> > > carefully before giving you a proper response. Will get back to you
> > > soon.
> >
> > Yeah let me know what you think. I'm planning to send out v3 with some
> > more cleanups and fixes, but I'm happy to hear what you and Chris
> > wants to make it as useful as possible for everyone.
>
> Hi Nhat,
>
> I've thought about it more carefully. Here's what I think the path
> forward could look like. I'll try to lay it out from the bottom up.
>
> 1. Data structure
>
>    Instead of introducing a separate swap_cluster_info_dynamic wrapper,
>    I'd prefer to add a per-slot backend pointer array directly into
>    struct swap_cluster_info:

I agree with that. The current VS patch is a great improvement over
the previous version of VS. However it places the cluster info and
swap table in different locations when accessing swap table-related
information. The code path requires different locks as well, the
xarray needs to take the xa lock.  This kind of dual-personality issue
will make reasoning harder. Keeping the swap table in the same place
is simpler in my mind.

The other issue I want to add is that, using xarray as a swap
allocator is unverified. It has no size limit which is one of its
claimed advantages, but also one of its drawbacks. Because it does not
have swap_full() concept. It will never do the normal if swap_full()
fail to allocate, let's do swap cache related. That code path cannot
trigger because the xarray has no size limit.
There are other considerations as well. It works fine if VS only wants
to allocate 4K swap entries. If VS later wants to go into the mthp
swap entry allocation. I don't think xarray has similar considerations
as the current swap allocator regarding fragment lists, etc. The
xarray isn't designed to be used that way, at least not in the common
usage situation.  You are likely running into your xarray allocation
specific issue.

Therefore, I think we should keep the current swap entry allocator and
the swap table data structure storing locations. Just extend the
per-swap-entry to allow custom implementation for VS to store the
zswap or even the write back info. Grow the swap device size if needed
after the normal swap cache reclaim path. That is likely a better way
to proceed.

>
>    struct swap_cluster_info {
>        ...
>    #ifdef CONFIG_ZSWAP
>        atomic_long_t *vs_pointer;   /* or xs_pointer =E2=80=94 per-slot b=
ackend pointers */
>    #endif
>        struct list_head list;
>    };
>
>    This is allocated together with or alongside the swap table when the
>    cluster is first used.  No wrapper struct, no new ->cluster_info
>    pointer type change =E2=80=94 just one extra field that is NULL for cl=
usters
>    that don't need it.

I think there are other ways to allocate and grow that array. Maybe we
could unify this with other per swap-ops devices by having their own
extnesion on swap ops private pointer. On the other hand, we can do
the simplest thing to unblock and move forward. This data structure is
internal, we can always change it later.
>
>    The name is bike-sheddable: vs_pointer (virtual-space pointer) or
>    xs_pointer (cross-space pointer), xs_table (xswap extension table),
>    aux_table (auxiliary table), priv_table (private data table),
>    slot_priv (per-slot private data) or s_ext (slot extension).  The
>    point is that it stores a pointer to the backend owner of each slot =
=E2=80=94
>    initially just struct zswap_entry *, eventually extensible to other
>    backend types. I prefer to name it ext_table, but we have had
>    extend_table. My second favorite option is aux_table. What's your
>    choice?
>
> 2. Eliminate the zswap xarray
>
>    Once vs_pointer is in place, zswap can store and load entries
>    through vs_pointer[ci_off] instead of xa_store/xa_load on the
>    per-device zswap xarray.  The cluster lock protects the access.
>    This is exactly the same idea as your virtual_table, just placed
>    directly in swap_cluster_info rather than in a wrapper.

Yes. I would like to get rid of the xarray from zswap or VS.

>
>    The benefit: zswap_swapon and zswap_swapoff become no-ops (no
>    global xarray to allocate or tear down).  The per-cluster allocation
>    is lazy =E2=80=94 only clusters that actually see a zswap store alloca=
te the
>    array.
>
> 3. First step for ghost swap / virtual swap: dynamic growth and shrink,
You mean xswap :-)

>    no writeback yet
>
>    I think we agree that the first landing should be narrow in scope:
>    - A virtual swap device that decouples PTE swap entries from
>      physical backing.
>    - Backed only by zswap (and zero pages) initially.
>    - No writeback to physical swap.
>    - Dynamic growth and shrink of the cluster space.
>
>    For the dynamic cluster management, I'd like to try a lazy vmalloc
>    approach: allocate the cluster_info array as a vmalloc region, and
>    use vm_area_map_pages() to map newly populated clusters on demand.
>    Growth is automatic via page faults; shrink means reclaiming the
>    physical pages backing freed clusters.
>
>    The vmalloc approach has O(1) lookup (simple array index), which
>    matters on the swapout hot path.  The trade-off is that shrink is
>    coarser than xarray-based management (we can't easily unmap an
>    individual cluster from the middle of the vmalloc region).  But for
>    the initial landing where swap usage tends to be ratchet-like, I
>    think this is a reasonable trade-off.  We can always switch to
>    xarray later if shrink granularity becomes a real issue.

The xarray allocator also has a fragmentation issue where not all
memory released from the xarray returns to the system as free pages.
Using kvmalloc grow it will wait some unused cluster info. But let's
put it into perspective: cluster info is shared by 512 swap entries.
Each swap entry is 4K. So the memory used by swap cluster is pretty
small. Much smaller than 1 byte per swap entry. We can also modify the
cluster info array, making it an array of pointers. Then the waste
will be even smaller (if unused). At the cost of one more pointer per
swap_cluster_info. We can consider all this later, not at this current
stage.

> 4. Writeback and rmap as follow-up

I agree that adding cluster info growth as the first step. I recall
Kairui has an RFC patch series to implement virtual entry lookup
(still using the xarray). I think the combination of growth and
indirection lookup should provide most of what VS depends on from the
core swap point of view.


>    Once the basic virtual swap device is upstream, we add writeback
>    support:
>    - When zswap store fails, fall back to allocating a physical swap
>      slot and writing out.
>    - The vs_pointer entry is updated to point to the physical slot
>      (tagged to distinguish from a zswap_entry pointer).
>    - rmap for physical -> virtual reverse lookup, needed for swapoff
>      and physical slot reclaim.
>
>    This is a natural extension: the vs_pointer is already per-slot, so
>    adding a new backend type is a tag-bit change, not a rewrite.
>
> 5. Longer-term: swap tiering
>
>    Looking further ahead, the per-slot pointer can also serve as the
>    basis for a swap tiering model.  Imagine a memcg with multiple
>    tiers: ghost/virtual swap at the top, then pmem, then SSD, then
>    HDD.  Swapout goes to the top tier first; when that fills, data
>    cascades down to the next tier.  Each swap device only needs to
>    know about the device directly below it =E2=80=94 a simple "push down"
>    interface.

I like that a lot.

>
>    This is a longer-term vision, but having a uniform per-slot backend
>    pointer from the start keeps the door open without painting us into
>    a corner.
>
> 6. Naming
>
>    We have three names floating around: "ghost swap", "virtual swap",
>    and Chris suggested "xswap".  We're going to be talking about this
>    thing a lot, and having a single agreed-upon name would help avoid
>    confusion in discussions, commit messages, and documentation.  I
>    don't have strong feelings about which one =E2=80=94 but I'd like us t=
o
>    settle on something everyone can live with.

I recall Rik suggested taking VS and ghost swap and creating something
new that is better than each. I agree with that collaboration
suggestion. I totally welcome a name that follows that spirit.

>
> 7. How to swapon a ghost / virtual swap device
>
>    There are several approaches on the table right now:
>
>    a) A sparse file created via truncate (Chris's approach): a swap
>       file that looks large (e.g. 1GiB) but only has one real backing
>       page.  Works with the existing swapon syscall, but the sparse
>       file has to live somewhere and the filesystem interaction is a
>       bit of a hack.

I give up on that truncated hack, but what if we make the swap file
really small, e.g. 4K and then dynamically grow it at runtime. Then it
is not a hack anymore. No more truncated file. We can find many ways
to improve it to get rid of the hack. That was the original reason to
send out the ghost swapfile RFC: a starting point for discussions.

>
>    b) A boot-time, always-present device (your VSS approach): the
>       vswap device is created unconditionally at late_initcall when
>       CONFIG_VSWAP=3Dy.  No userspace action needed, but no runtime
>       control either =E2=80=94 you can't create or destroy it, and you ca=
n't
>       have per-memcg or per-workload virtual swap spaces.

I don't think we should have swap without swap on. I prefer keeping
the swap on/off interface even for memory based swap.

>
>    c) A swapon flag: something like SWAP_FLAG_VIRTUAL or
>       SWAP_FLAG_GHOST passed to swapon(2), which tells the kernel to
>       treat the swap device as a ghost device with no backing storage.

You mean SWAP_FLAG_XSWAP :-)

>
>    d) A dedicated sysfs / debugfs knob: create and size the ghost
>       swap device at runtime via a file under /sys/kernel/mm/swap/.

For the most part we should allow the swap device to grow
automatically for the virtual entry internally without userspace
knobs. We might still want a knob for the max limit of the virtual
entries. I don't think it should be unlimited. I am open to
suggesting.

Chris

>
>    e) Something I'm missing?
>
>    Each has trade-offs between flexibility, simplicity, and the
>    existing swap management model.  I'd like to hear what you and
>    Chris think =E2=80=94 especially whether the boot-time-only nature of =
the
>    current VSS design is a deliberate simplification or something
>    you'd be open to revisiting.
>
> Curious to hear what you think =E2=80=94 especially if you see any struct=
ural
> issues with putting vs_pointer directly in swap_cluster_info rather
> than in a wrapper.  If the wrapper is important for your v3 design,
> I'd like to understand the rationale better.
>
> Thanks,
> Baoquan
>

