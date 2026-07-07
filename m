Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D3E0C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 21:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598C96B009D; Tue,  7 Jul 2026 17:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 570DB6B009E; Tue,  7 Jul 2026 17:23:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487D66B009F; Tue,  7 Jul 2026 17:23:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 09AA66B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 17:23:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6DCB01205BB
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:23:51 +0000 (UTC)
X-FDA: 84963257862.14.7954053
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 903251C0003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:23:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=riE49g0G;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783459429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E09qmiYa8NHO+mfzGgLxzT6S9uIu/VmXVGvR4QwiMjc=;
	b=hm68xhcacDuvYfSSfIVUoZBRbDy3BYdkx/lADJJbiMYQi3bHYzxfqjs5sH/i6xLGn0XB+1
	7WG4Pvme/sHN4pDE7uQUU3PB8iTqXxxIUJy/HpZmfxFBz3y3StEOGVFWiGuskAg07PYAF0
	RWQDvttAxay8TLCZsEKuA/ly2t6V/2E=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=riE49g0G;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783459429;
	b=bLVFQ52+70LeNfk+ySJz/64yQ7YLKeGxEfWxgpfNMJ5htZeGDOV0u8BqPhnu03gA+Z8JjG
	HxATIt3wGQlD66mhekmhdyD8IxPh+MiTLsJ2lei1FQOb4zMeT3ALbGN7r4C23rctk3pvJW
	wqk4/bRqLyP8ZSdiBmR5fdM0p/eAy4k=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5aea0fff535so4947572e87.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 14:23:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783459428; cv=none;
        d=google.com; s=arc-20260327;
        b=Op4ehUI0FfR+3hcLgpDE/6Pl+DUlKllzlUjz6cOWrXRFixHhWvAQ9e6k//KKcz+A96
         lRrwSZh0nPJ5gmkw8tMQM3GANckjsJK4ZdwjMqkoUFvWz4oNgJOzgm/TXMqWF/B4tOGB
         5OPT4yoh0twfBC6SScOFWP9SCbFcnle09i9iYQGd41icvU4g0YUXSB6/KChZlPRkVu/a
         BbZH6pz+kDIfD6G9mSaVCe2sXz3ItBwVVlSRB5188I4weAyr5Z8o7ODvWy33gRppcuWn
         JiDDe6uTBbogjAS7IlSQkJFdksPBe1TEM1Li/9j+bX33HMn5jv5tzJ6g1NhvfEWVlOhp
         JfEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=E09qmiYa8NHO+mfzGgLxzT6S9uIu/VmXVGvR4QwiMjc=;
        fh=vaecG6QtO6r12GzAj38pAxqRjsWQrAnjzLyMhvd9eFw=;
        b=hdizZiqcQeMqt1jtRrFDsD8dUUfcgIONrf5PTMFobmj1Pn1cfl1h7P+ha6grDTQ4bE
         aDcGpSPAS32FtS3tv18VFMVISVqTEBZZjVAC/dpVK3mI1yvdNxZU5DE2e3xsfRfCpEez
         7//WDKhe5HCdsYuygOUOEPnCONNM776L7OD69N2R1rkEpYQYi/Ezd8T7hlvVqVEVrmBc
         c2rgKfY8MSeKGuvHx6CCPcx5bSCk+qe+Tb86sYlnl64zLo6S7AccrtMfwA/0WZnvigKm
         gyv/FjJG/MBD0IniLbrl5vt8p4wH1y1Ll3D3nqmFXYgI6+ZuLNhw2hn2lK4LP57nQUCU
         60Eg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783459428; x=1784064228; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E09qmiYa8NHO+mfzGgLxzT6S9uIu/VmXVGvR4QwiMjc=;
        b=riE49g0Gbn2KINQ+f2VHGXPKcQ+2Ajw4ZKadm84fqbewEvt6XRK6U5Ol/YeyHPFD8J
         N/Vh8hdNfuFeFAsjncyvFGyDYn0CK+tSySK7W0+IENrVIzdOWysgzMEKodlt+u7zMV2n
         FtertEQy3FKDsmG5SYu74xS6R411/tSKMhCYBTPIuii5sxKQCeIy9gwAGmY+mjwm5KCE
         +/rMf32EREMdsySEAOFVYTl3o+7flW7vXIpc7FTQa1PMbjWr7MZ5YYvlQ/TUeqHlIOBU
         pAMHhQtP8kd2GVOmkHdBIUoWA0gdguj3Kt9jrnnHZYBv8B+NrqTqUklDTOZWg9ugwnG3
         XTiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783459428; x=1784064228;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E09qmiYa8NHO+mfzGgLxzT6S9uIu/VmXVGvR4QwiMjc=;
        b=BSAfHTQ4/zW9MA2GKN4HGLEyHwH/t7mFiKVfTsTf0IBGhId2qzkENA7XxhWnHnsrKy
         6K/UGgL9jE1opzbEvnpA+6VM868B+D+rrPQ7RA1zmyGEINapRPKbFo0efrOJZmf7VgGq
         HT1HNymv3jtqUKJ5oJu4dBP8clYW18Sp0wN0AcCo4uPSmrMAB//hizBdTuJqVA6ETAtf
         TyRxr6sY0iMT42aOG6efdWNgZTA8ezE0+5D4uN5h1pqAztzG9bvTnvpZpfudZVKnuPt4
         OF8QFdBrKh9QtmNXDMlufBeYDLbCYbx3zE9ILB1a7tLJ1+gzdbZABwDGumNCDV5QH668
         5csA==
X-Gm-Message-State: AOJu0Ywumz//8XFkIjzu5Y5UsTxYMqRkbwma+2zRG4VDrygLlA9KgIRJ
	w+pliIX731iswPgTefUVoWe4ksKfc8KemzZaAzcuez3r2tHnfc3w9pJTvj7eRBVPwyXO8isiQM6
	Bo5Ww2/CqJGpLChPcXVq0+RiefiiLeUM=
X-Gm-Gg: AfdE7cl7EFPc58dxyzkvA4AVvRQveZ23i5OWZSEfyjO+afnYHl2HtDjWnuzbqH0GyXX
	GoCZtvd59iNM6Os+LVQpUPcnzTWFd32QUrj9tTEvJ+EULS47++1ryXBw8k/ocNnFWFh/Magjap3
	qB6C8ExJsVg7MokHt4dq4SSKbXtQi2cksL4o0gx0GjTRSP3FbKyqya+Y/Hf51z5W1Lw03kY86e+
	SZ8eTsUZatSBjtffqPc9pG1qyx+FUOR1t45Yah3DgjlXm0nbkEFxMt8ETJ1LroSjkkMYGE2E+Hb
	D8ScJOb4WbwNdeVxf4QBlfHiPkId
X-Received: by 2002:ac2:4189:0:b0:5ae:b25b:1941 with SMTP id
 2adb3069b0e04-5b007c54ebbmr979759e87.49.1783459427442; Tue, 07 Jul 2026
 14:23:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260707082614.95030-1-baoquan.he@linux.dev>
In-Reply-To: <20260707082614.95030-1-baoquan.he@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 7 Jul 2026 14:23:35 -0700
X-Gm-Features: AVVi8Cf74g6XGU95Megpsiq6rcToxY_njCc8toAxEORY5cTvVbttvdyz8FNYNLs
Message-ID: <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
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
X-Rspamd-Queue-Id: 903251C0003
X-Stat-Signature: aezf4zz3ic1fmawugt4mq7t6z6q1q3z8
X-HE-Tag: 1783459429-229379
X-HE-Meta: U2FsdGVkX18zcvD56V0lHb1QXKfEfFn9lG76ZVh5hAMTZkz+bdyBotnLk2Ugx055VS/kOeo4kQrz9dXLA8tAfL9qNtLaucvDwcXprVeoEuicLWbw53NZUEP+o2bDoJtCAAePcKN46YHxwfIEsxhpGUSuKSgSsFXllPOV2EvdjaEWIkN1JxlSDQa9lvNR8QklxffM5jSXWZtT/ZwocHRu3Pg4aLVY+YIJidRLZwK1wSMPwYCntsH8WL9veKdcWJvDqNZUA6o1KZDMQa/BMXzCq3wDHv0N4D2DaALhPjceTLrYV6jLM9xSk9VbYCIYkqpF57qVoypiB/wDkcNrh3msQO4nDpf4g5JgLnomLNWyNHRHNNSn3rWREgi+OpQCJmnmrvFL1LjqKM/umrNjZxgQAR3rwf2bn8mkXq7avi46KWReV/djz7q1nFwfutRSR9BV7xwpyv5WUIsTpRAtXGGE6CRxFmh8wyM3M02NlmCQ+9nY68bSGgJP1a2gbWMX8ZgmYoZM+I73rN22mpIH7S+d6PCeCFkDq3CsVAhwUNBDsRrZXfy12YM8R9Pfdm4tD1uKsx5rTDGfeLTU8mwFkTt0bRu6DZPNqVtaZuNuG7P4dOIAL/3Qx9D4cKP6BasBQBEBey2oYdJjzbipMco7sUqJkX0/TleNXQ1+n4HqPkTFlHTYZMcqD+q/iiIegmDk9hO+xe7OB//d2Pahz8DbIuDeMS53zkzhanX+N1CbnptsrRxwHgBkJ5HXf1s1QBYenc/r6cO6Dn9rSnQtu506ASL6El8kvLZbbz6DAlNtnCqGMbyASIdZQEy0VF9dsnq0uayd9oJIdNeOQZSfpSYHkAWHL6ygnIy4XoAxnte2woecNm8N+5QDkFqw9JQG/UiZZ1F76w3V6LCxV46hm4Un4qqagQwuqaP7g0Dxl00toPiq+xrR1zXNi9q0CN98yE/FNk6mFkDfoXB5Kp01fGRW27C
 DRDFDXz7
 P8xV5FZ5jfGkMVL4L6LmcPZPW7Mesc8QA1YhkOgSUJ3pXaScHYcunoYFlJdu9c8Z/kbjT1J6O6CzyTtkL/IkyMeX+Q5pXWa6ns77NU2Sfk464Dq1HZ5hAevojr5puRTm9W7ox7OJEFu7LFVG0Hgk3w6L3vK6k224CQ7/ooIAnBkR/DY8HWP40nWe8hZ7hk5znuj445XHES6YsWv9PoD3UmRjNp6MKhZyyOB+nM35HCccSrBO52llvvK3WsPSJI136lOo5J2o109pJGcPMPJuY17deua91PBuVwWyIlK8aBYUrQN5+HToi6kE1IiSgvJodfrhRTrW0M6F5XHIn0g/1vDuiB3L9gP1khawTq9IpgnIKBEcFZd/2Lbk56Klf+37MVkpWjEzGx4OqjGGaNXVKSPGoOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

We don't want to put additional operational burden on users. Besides,
expecting userspace to react to swap space being filled, especially
under memory pressure (at which point userspace processes might be
stalling already), is tricky.

This is especially bad when redirection entry still eats up space in
the upper level (ghost zswap) swapfile. You will run out of zswap
space really fast under concurrent zswap store and zswap writeback.

>   sysfs, up to a current maximum of 1TB.  This is implemented through
>   lazy vmalloc: a sparse 64MB virtual address space is reserved at
>   swapon time to cover the full 1TB range, but physical pages for

This range seems a bit small, especially from something essentially fixed.

>   cluster_info[] structures are allocated only on demand as the device
>   grows.  The cluster_info pointer never changes, so all existing
>   accessors (__swap_offset_to_cluster, cluster_index) work unchanged.
>
> - sysfs control.  Each ghost device exposes attributes under
>   /sys/kernel/mm/ghost_swap/ghost_<N>/:
>     path (RO) =E2=80=94 backing device name
>     max  (RW) =E2=80=94 current max pages; writing a larger value trigger=
s
>                 swap_ghost_extend_max()
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

If you think this data structure is superior to the xarray for dynamic
swap address, it's a fairly simple change on top of what I had in the
virtual swap RFC, no?

It can be grafted on top of what I had in a subsequent patch, or
squashed into my first patch. If you have concerns with me
implementing your idea here, I'd take your code if it proves to be
superior.

>
> 2. zswap writeback from ghost: when the zswap pool needs to evict,
>    zswap_writeback_ghost() allocates a physical slot from any real
>    swap device, writes the data there, and plants a Redirect entry
>    in the ghost's swap table pointing to the physical slot.

What if user swapoff the physical swapfile, whose slot is backing a
redirection entry of a ghost swapfile, rather than a PTE. Has this
been handled yet?

Similarly, say the physical swapfile is full, and you attempt to
reclaim a physical swap slot that is swap-cache-only (swap count =3D 0).
Say this physical swap slot was allocated from a previous zswap
writeback attempt, i.e it has a redirection entry in the ghost zswap
swapfile associated with it. Did we handle it somehow?

My apologies if I missed it somehow.

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

I don't get how *any* of this is simpler from what I had. If anything,
it's more complicated. With a vswap device, you just allocate a
physical swap slot (which you also did), change the backend, submit
the IO (which you also did), and that's it. No need to juggle this
redirect_xa entry. What does this redirect_xa buy us?

Not to mention now it entagles generic swap logic into
backend-specific code, unnecessarily. And we have more state in the
state machine to consider: With a generic vswap device, vswap -> disk
swap directly is the same state as vswap -> written back zswap entry.
With this zswap ghost swapfile design, you have to treat the latter
separately, as there is a redirection entry involved, which means
concurrent swap operations interact with it.

So it's more complicated, and achieve less - this is specific to
zswap, whereas what I provide is something generic to swap
infrastructure, which can be extended for future backends. I would
understand if it resulted in less overhead (which was the argument for
my pre-swap-table vswap design), but this seems like it's just virtual
swap, with similar space overhead (technically a bit worse since you
added redirect_xa xarray to physical swap cluster too), and with more
complications?

>
> Note:
> ------
> Ghost swapfile is a proof of concept. Compared with the other patchset:
> [RFC PATCH v2 0/7] mm, swap:  Virtual Swap Space (Swap Table Edition),
> it explores a different approach to implementing virtual swap on top of
> the existing swap table infrastructure, with a simpler implementation.

You neglected to mention that this "simpler" implementation lacks a
lot of design choices. Just on top of my head:

1. Certain optimizations for cases when vswap points to disk swap.

2. No reverse mapping, or at least some mechanisms to handle the case
where you have to go from physical swap slots to the upper layer.

3. Charging behavior difference, and deduplication of metadata when we
have multiple swap levels. (In fact, you seem to be double charging a
writtenback entry here towards the swap counter, not just duplicating
the metadata space)

4. Infrastructure to make sure allocation from this swap device and
allocation from the backing swap device does not invalidate each
other's per-cpu allocation cache. You seem to just go for the slow
path with alloc_phys_swap_slot() for zswap writeback?

It's fine to disagree with any or all of these design choices of mine
- I'm receptive to discussion. But it's misleading to say you have a
simpler design here, IMHO. My design choices resulted from multiple
thoughtful iterations (a lot of them could be found in my
pre-swap-table version of vswap) and real production pains.

