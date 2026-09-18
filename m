Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02E01C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 00:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA6366B0098; Thu, 17 Sep 2026 20:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50976B0099; Thu, 17 Sep 2026 20:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C18D86B009B; Thu, 17 Sep 2026 20:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 944336B0098
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:13:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9ED1C1C2709
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:13:29 +0000 (UTC)
X-FDA: 85224958938.07.9E3FADD
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf28.hostedemail.com (Postfix) with ESMTP id C18C3C000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:13:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bykuXFHK;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789690407;
	b=XMEGjWcCj2uIuXKDtSgIXaP/v/A/OsI6chQzA90mV4qXrW2JWxNp6cR9mbrYdnCj+2OCzs
	JvjTy9RMba6uXnlOjK/rNVmASgTNHqJtKx9k/zuhqQchtPuHv6hxvI43zpnit6f3P1pqJO
	iS+ngPFyJEXPWYDTgxzXl1lFzHWamOI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bykuXFHK;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789690407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZxC2zmZBXNKohtVlSKjG/OT2cN2Az5DZgDZVOC3Qko=;
	b=77FB4cUQznRK/IOLLb07SK6dfi+yixtM2+frVMuDV+ALek6eBnDQNDEAPQkCcG49QP8aK5
	GMF4LltY90eIei/jrvwJDUgP9HLxzH2LRh/yV4/SqSk+iIaH8cMDw9CejnaiTeZey7m2DB
	chgLeOk8qq2mcGXQycxhjlt65/SAYGs=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccfd61ecaso1431305e9.3
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:13:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789690406; cv=none;
        d=google.com; s=arc-20260327;
        b=NdvwrtffDzNu8T4OkXs+vAU6GWECi90WodwjAfXw3gQJKhUpunXKRe9jJKQHhj7C5S
         jQ3gECWQxVFAUPogZ7DikxaIQSdKJas70dnvAeaQGGLIiFQ1Nq1T/vLswgzFddMDQ41H
         CuSALAWpYsIPK9hsa1+HCEBd/z4Wu+KBshA0ZEYjjUOv7Hh4riMeNM7iGga3Sb+UatxB
         lZk7VH9aZloEF41kz+M0SiLlBRbVqAAvEtXPkEqLfOA60oARS9jzJ1gh9eARZ4RJrGI8
         DOTdgKd85pRVmtRzrcEOBQOAqJ1+XRHKYl30HcFIL6pM1WNTuJeLydlPYzu929Y2uOs7
         /Dag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aZxC2zmZBXNKohtVlSKjG/OT2cN2Az5DZgDZVOC3Qko=;
        fh=Mku5TSMXRT2R+rAT9VVy4aA5vRpquE1HQUuZQk8RgVc=;
        b=YzLX1mvpghoSOR+slPR2VTPO4LS0J3R8SSm1c/cRDBoATuvDRAzoYyAg5q6cJXueqd
         /elUYtsEb3AwMf8PvjX+6zo47il7T7Joexm9Av20xCvnmsNHp4ERtywAzI9Ho/Sth1VN
         pODK+caKIcLxpmeqs2mZvGcwanSBFCtBL68262lfIfrNHo9b11IfVfYjJtc3RIopIMSv
         81V9hbVW95D4mPIi7SgXYjgY5+dGZSmJi3f3RAbW/jEvvow/l4/uBv3d4ZtFxTn3iFdQ
         KVXaXxhp8GOBnS6N6j6lZ9bXW/zC7nc5OsO+1Z2XTlr+GCeCgHvbPKQTH4X3tPBUnDaN
         kQ2w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789690406; x=1790295206; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aZxC2zmZBXNKohtVlSKjG/OT2cN2Az5DZgDZVOC3Qko=;
        b=bykuXFHKKxG34tOr37PiM8kbFf2g6wgKTJ73Rg13QsP4AxVqB2NbmHH8pVvV/R9vQF
         bY0e+OvwMPP430YWsHudktjxqkic16z1nFXvr/6YK2wDnR0DhIedSAza8mbJLGXGA9n2
         e6GzjuE1rrp2GDmCMalj2b1fuuOIcvY1uYVDki87Q/4MaRvIB/4SsbgklHXNYxrG6VKS
         B8wGCZoFhGwUdD35VqWN/o59bCrSoaHQpNXNZO5Xvu8nTUVA5qoY97TO2989xFoKqkQ4
         +ChBRrRNHLO58ag9q9AOz1Ji9FocykGCcIC1EkrYnjZzxRXxyZPuNnNpZADUu7UqdGts
         UkrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789690406; x=1790295206;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aZxC2zmZBXNKohtVlSKjG/OT2cN2Az5DZgDZVOC3Qko=;
        b=AMot0Oyk1lIEUIxqAdThcBSkX9GjGgPn8EMYepDwSfgcHssfOBk6nXNrQAz5ZR0ZfB
         O+ak5m2/UZu92NQUqQ2xKq3ERaZj7mOlAX8U5Ae3sgfWbtVXLB+kMMtJDuGuDaz2vFZ9
         7sMaDdQAXLljU2z7CqmZwbEtYmrhwySmDAIQe/6aLen20xX2pdUhoVdEfVGDx+sf1Gi3
         UYwPq/HMRbylt+jW6ln4zPD0KUH01kSX2BQNVF2oUQL/NWwuptEecjoIe+/jewTk1Mqt
         Sk81Iyv7SOAUzEfPVJahOUwjAZTuxKd0IQpXntH2z6voJkLzXMhiHTgcRmO7KRZp6VJv
         NNFg==
X-Gm-Message-State: AFuF++mn/Xb9mHEADHInAm1l3/swaSyEG0AW8UIyrLxhPnCJ+1eFkuRl
	2saLyzGa0HRfdBbhw03xtzVSTEZd3CbxCuDsYqRdpMqgk66oq22WT0r2qRFmF6PHraoqanlaxKL
	mvuuJw7QMP3ym4pgYZYxb7IylKLNzIBI=
X-Gm-Gg: AYBFou2RyvcRKENYej3HpxqQMbg8oGHhIQm2UEMol+776r/toQOu6XxU7AHFqX3aE1H
	0T+SCXBINbtDks6QXdnEnxDFYIAfw24mURS7Xc9HxLTK3DX56DM9IoKCqxjnnpNqFPTYH045SfW
	DAWTJHt7aG+Nm2pfKN0SM4YeIsXl00HfQpUo6fzgTiSJ72ydlBsEcl5nSSePSZ4Vh50fvApdMxM
	q+mIp2q1MXWxUO2xHbQkaE+vlwiDVNfTQUltNB6WciaLTOVkzNM2wkbfGNc/KDnAL9zSrdlWsy4
	ir/nmVEsKAzTYlwvADH3MqHbvEas0m5wExsJ3+Yz3HCdaawwDZt7Xze6kOA875CSINUqsnMayY/
	+FOd2vanCjWo=
X-Received: by 2002:a05:600c:138f:b0:49f:bbab:aa10 with SMTP id
 5b1f17b1804b1-49fc5741672mr5579525e9.20.1789690405281; Thu, 17 Sep 2026
 17:13:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
In-Reply-To: <20260916101929.149106-1-hebaoquan@kylinos.cn>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 17 Sep 2026 17:13:14 -0700
X-Gm-Features: AcwNN1WpNUvbpMcj0o-RkcSZEW3mXC3Qne85caJPWZ5BGl0U5kjLLvyPTNmZXNI
Message-ID: <CAKEwX=PEEkYiNRaVhCuM4E6mxB9huPKfkDa4m62VMTzedg1oYw@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C18C3C000B
X-Stat-Signature: g3rzn4peauk54dwhq4bzy6w5yoe1huy5
X-HE-Tag: 1789690407-613053
X-HE-Meta: U2FsdGVkX1+uwJN9PBzssfMpBt9En4ceVaJdIzf4O/eCkBb1sjJvt+nnLXzcWXjDAL+wRqlncJWLc35nBraZKExUZaD4672BLKw22Hu1T3XRKSj8qAkcMEkF8uwCZ2nDHATDKg/W9MNH149JRzOXLEy3tyofGmr8Ne0tfl65eoXipu+brLauSfPXzgWdXfivZLXGmF1Oz32PJmFjrrKyLNlDtRKCcni06tjFZJ8CSYcrgmJFPnlX+t+NlJPssR20QweZ7glqgSu2l8Z+9j3gxfINGfKHjR+w/RQjV2CGdAbGSp6z8jbZaU5vnk2Lm6mBtL1J8udmnGiHKe37vA+4XA8B4Fd0CZhWFxexUUM+ifE0/JfN/wKvPS+qNmU5cYK/QzfU8GqdEUIzHPTwi6jeu+ulUZ/9kAeZUI/P0N3N1wBsW6TKQEJa4FPDEbi40cRwLTbjvtzZzC6K9pFGfXwUAsAAq/vWsHx+MJWeUY/iHsLfJK0FCMmTjirC9kfBooSF+gka3UB54kvnyyGEQHq6+uACnnQ7fcwXaUnIybDeUDM5FQ9sE5wUvtegqVenG4zOM7VEANb/HE3HWFclGMdB6lGjjK1lgIo68FGPgbV6EcusniKYZm3JBvWlK3ssDQsiVO7luCIIMSXGGDnITIjS1s0SQXZeVZ7+uvUZh8AgpeTI5Dv/3cDIs5FnyUdKhYPKUN99VTHnxScgHEaIKEY6mKWssjXdNusawef7n8usCjg+g7mWOIo55tjfG5fgVIzJ/ENVZTp/lPFAuwkiwTzutS9/f5Phhva1OciBLowVezG1YDSwJ5TYQHlouLemZ2Lkx/c5jwOyyb/kG2BQhE1PjvrgqP2+JYHtrSPTxuvPaKKjFRpJkpaeUckDsClPGnnIh93v93KsdL2DKQ9QDqzm/Rv/1DTMxo83Kep+Z230POGF+4Qb8q4eoUN5gfviGm4MEwdtINCPy7etHpchQHc
 gYkzetT0
 IWX3Bf5oWBeEUVQyzrpSu9JSaox8Zcdd+fZ1pNpE4bZ0PEQtyX0BdFIU9ycb4bYZuRT6lY/h2+/dFY22l/zcpnC3CUwwL3ff+FYdAryvYvG1hvSZlF6InaDincAaRPnAU2CmKrU9lwcc3P2N7qTp3+3OINj8DWuf2bs9vxHtX1XXWekNAKbITDPtWOGAVcKkf+7yp5bSWaSvHFENm/5Ospqx//m1wUiE+5K73rINImzr7jMRQY10VUcqs0AJZpS5LNdDmmVA8fz28bXxnGYFw9pVuqCqDpkGlvmnqKz9cbkib4/4E2YlgEewCkqZAbp8jgqnD3mY4WINoJMtWi7x2NxYYb4dOCi8D/orcoLLmIUUVhm+uRzs7X9G4eKYlg2UD11Y5mSKKJY1nwkieT60xeTW7CX2/BZd/XDypnIlScQUBWhC1FtaSTiA1tH1hHtvxI7Su6UjoCssF1C9RAMvggETQorZZFMTjq+qiQBv+D6DFnDoxDqnN3rvofwxulT7vLmJUo5eTiOxcDmowIFix3It4msSUn0sa+uSldicSmFliwbA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 3:19=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> w=
rote:
>
> xswap is a swap device with no backing storage. Swapped-out pages live
> in zswap. Its cluster_info[] array lives in a VM_SPARSE vmalloc area,
> and the area is grown and shrunk on demand as swap usage changes.
>
> The problem being solved is the static size of compressed swap. Both
> zram and zswap need the size fixed in advance, and neither gives memory
> back when the workload shrinks. The solution should be a device whose
> size can scale up/down as per usage. xswap does that by mapping the
> metadata lazily instead of reserving it for the whole range.
>
> Design
> ------
> - si->cluster_info[] stays a plain array. Access is still
>   &si->cluster_info[offset / SWAPFILE_CLUSTER]: no per-access branch, no
>   RCU discipline, no tear-down state machine, no NULL return.
> - Only an initial chunk is mapped at creation. The rest of the address
>   space is reserved, not allocated, so an idle device costs nothing.
> - Growth is driven by allocation. When no free cluster is left and the
>   address space has room, the next chunk is mapped and added to the free
>   list. No userspace involvement.
> - Shrink is driven by frees. The free tail is scanned, and whole chunks
>   are unmapped once the mapped range is at most half in use and several
>   chunks can go. One chunk is left mapped as slack, so the next
>   allocation does not map it straight back. A ceiling lowered below the
>   mapped range skips the half-in-use rule and is enforced at once.
>
> Size
> ----
> A device starts at 1xRAM, rounded down to the cluster. That costs
> nothing, because the mapping is lazy. The underlying address space is
> 2xRAM. An optional per-device cap,
> /sys/kernel/mm/xswap/type<N>/limit, lets an admin lower the ceiling;
> the excess is unmapped right away. Grow and shrink both work without
> it. Creating a device requires zswap.
>
> Interface
> ---------
>   /sys/kernel/mm/xswap/create           write an optional priority
>   /sys/kernel/mm/xswap/destroy          write a swap type
>   /sys/kernel/mm/xswap/type<N>/limit    read/write, in pages
> The device shows up in /proc/swaps as xswap<N>.
>
> Note
> ----
> Writeback, rmap lookup, etc. are consumers of this base. I have a
> writeback prototype on top of this base and will post it as a reference.

Thanks for posting v3.

I spent a while building the other half of what I want out of this on
top of your series, to see how much work is needed if we are to expand
from xswap to cover the vswap use case.

It is actually way more work than I anticipated. And a lot of it is
because of the way you indiscriminately apply the full swap device
model to xswap, without careful consideration of actual use cases.

Johannes has already discussed one piece of that, the sizing knob [1],
so here I would like to expand on other design and interface choices.

First, in terms of priority, an xswap device has to be preferred over
disk swap. This is already zswap's model, as it is the *only* coherent
swap tiering scheme. Exposing priority selection to userspace just
invites misconfiguration - what if a user accidentally sets physical
swap to be preferred over zswap?

Next, regarding the ability to create multiple xswap devices:

With at most one virtual device, there is no selection problem to solve
at all: vswap's entire device-selection policy is reduced to two
branches: if vswap is possible, go for it; otherwise try physical swap
device. No need to think about policy to select which virtual device to
allocate. No need to track virtual vs physical devices to select the
right class for allocation, as you can just put the virtual device in a
pointer, and off the avail list (which is only used for physical
devices). These suddenly matter when you add multiple xswap devices.
And for what purpose? This has never been properly justified to me.

On the flip side, there are cases where your treatment of the xswap
device as "just an ordinary swap device" actually breaks *existing*
deployment, and makes several code paths more complicated.

For instance, at allocation time, cgroups that disable zswap might get
an xswap slot. At swap_writeout() time, it is *stuck* - we already do
the unmapping step, so we cannot reclaim the page. Ironically a
physical swapfile backend could have bailed you out here, but you have
not implemented it yet :)

The other way you can get around it is checking if the folio being
reclaimed belongs to a cgroup that allows for disk swap or zswap, and
bypass xswap/vswap if so. But that brings me to my next point: since
you just treat xswap/vswap as a normal swap device and share all the
allocation structures and logic, making such a selection becomes way
more complicated code-wise, and less efficient at runtime too (since
the per-cpu cache of clusters for allocation is shared for all swap
devices in your code).

As of this version, it not only does not work for the writeback use
case. It cannot even work in deployments where some workloads (cgroup)
select zswap, whereas others select disk swap. It can only work if you
intend to have a single class of device - either virtual/xswap or disk
swap - but not both.

There are more, but I think these already illustrate my points.

The root cause of all of these is that xswap reuses the swap device full
machinery and interface, even where it does not make sense, or where it
exposes a policy decision the kernel should be making (priority, size,
number of instances).

vswap's interface came from the other end: what has to be true for
zswap to be an independent AND co-existing tier, and what needs
userspace's input for that to work. The answer was close to nothing, which
is why close to nothing is exposed, and why there is so little to get wrong
inside it. It also simplifies the logic in many places.

Constraint liberates; liberty constrains.

So let me flip it on its head. What if we keep the interface I already
have, and use your data structure instead? I tried that too [2], and it
was significantly easier, because it is just a data structure change,
without having to accomodate for the full interface of swap device.

Happy to expand on the prototype if necessary.

Thanks,
Nhat

[1] https://lore.kernel.org/all/aqLi6cIjD2wJwk0B@cmpxchg.org/
[2] https://lore.kernel.org/all/20260910232704.3364879-1-nphamcs@gmail.com/

