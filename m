Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEEB4C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 14:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E4656B0098; Tue, 22 Sep 2026 10:23:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BB726B009B; Tue, 22 Sep 2026 10:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB5C6B009D; Tue, 22 Sep 2026 10:23:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 493CA6B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:23:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 98450404D7
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:23:08 +0000 (UTC)
X-FDA: 85241615256.19.2BC61D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id B4F2180008
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:23:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G7OJM7k/";
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790086986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eV4gj96rb3QXMPP74tweZYUu6t3BeYnNxVdGnInbQoY=;
	b=PORV7d0qHr2qSD4HmgVTKUNZ/s0qE1SvaAjvbIQd61cOQurxKhG1xo/9KAWlI0lcTlfBdM
	gq2E70vCW0/Z4E6qNlt4XsSevdetD2s64bDr7tFRqHX3D6Na1QDmZbsH0ixhb7JDbK+6Aw
	e1y3j+jGf6iFoo27VZTp454C2Q+5h4w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G7OJM7k/";
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790086986;
	b=ZS4bQZQoubx561KSk1I/2azVfZZ13Po/k3GlbAgvXaJxo+zjUrrAkg7ryeyK2Go0xeArOY
	pUg7RS36Tc48vrDOJNurTzUCSr8EbsxeF2Mi2wJU7btpkBtosOZzkFKBbDqreonaVk4O1V
	NzTNf6XKL3lNaUBzNLCcG7NmBdkCKOQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A82D60E19
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C211F0089A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790086985;
	bh=eV4gj96rb3QXMPP74tweZYUu6t3BeYnNxVdGnInbQoY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=G7OJM7k/sdi8vpnwhnmfUZdJoXepgK4sYAcFv0UYq6RreMrqA0OoMff3OE+raI1OX
	 t5Yi2hUV4ymjcbVZTdsovaeOWIBBrexx4ehHD6O6ZSKtzLla6elpH8kooUGs+c7rIw
	 iaGBR3lZVgsotSBA8+EtliaP+gcXcExLVar/nA99mAX0ULpOSzTspvowoY5twa00r6
	 VwQmDus48c1+37fNAonmwWohO/P7YALvJlI2OBAZAHXu8V+K0VpfUG1HSjLvJ913Lk
	 kck2nEtXC/ceKW1nbo6hLWJ5qxV+rZ0oZPsZzRiF3G0+tNYMbi4kj+89PTYfhY+yZN
	 hY02oKYlE1AKQ==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-671563fb8beso4011068d50.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:23:05 -0700 (PDT)
X-Gm-Message-State: AFuF++l2r0rnneiU/BL4jgMMegUYryuMJWntLJDG/4uuFUNwE21yDaJd
	gS3t9b0JFOB88PJ/Z7fm8dtYGSW8xfvmfsQ9dqapHQpEbjTcybAz4VqQwv1lyGTkIsyP4bHEC/5
	q6LxKN41VTHmLwqYM+VV+3IdbBHPL3tKAXI0E39NGnQ==
X-Received: by 2002:a05:690e:43da:b0:672:d3e5:fef4 with SMTP id
 956f58d0204a3-672d3e60668mr20158d50.26.1790086985084; Tue, 22 Sep 2026
 07:23:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
In-Reply-To: <20260920072043.430390-1-hebaoquan@kylinos.cn>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 04:22:51 -1000
X-Gmail-Original-Message-ID: <CACePvbXiUmGV920BM58FKuP_iuvhRuoSZrGrrS53rLctJd5uVw@mail.gmail.com>
X-Gm-Features: AcwNN1VblK2RUVo05ZZyNcYoYE_io2nZIcWMzMRgWH1EzEZU1XZ55z8OIDXHSuk
Message-ID: <CACePvbXiUmGV920BM58FKuP_iuvhRuoSZrGrrS53rLctJd5uVw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/17] mm, swap: xswap writeback to a physical backend
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	hannes@cmpxchg.org, nphamcs@gmail.com, baohua@kernel.org, 
	youngjun.park@lge.com, david@kernel.org, kunwu.chan@gmail.com, 
	baoquan.he@linux.dev, gourry@gourry.net, riel@surriel.com, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B4F2180008
X-Stat-Signature: 1177ecre3p6drfe45ro3krr93kdbsn95
X-HE-Tag: 1790086986-158631
X-HE-Meta: U2FsdGVkX19YJbBx8anckm1qDBbo7+ulro9Z+uWxSsH/+O/i9JXJqzzfCTtY0slJRX/+5vnK8TYw+IiBybdiundW7sW8UZxI6sxC4taKjYc35+8rDo7gHwmDFQA+IJLUTU9gwOPKuKeeC9Lgw9XFNF1CaniBIc3uEWTglC6oMIoq25KecbrDOwAIlSi0K86kmLSzhay3zX/ADcYCNBHnCfcwl57tLfKNqpjpfDIPunUrT6Mv4UzXvciWBOsQM8PYy7G+UqocS8jp16DaPuItq3G8rJPSjCfEWylkabtR59764S7uJfulIZukDeJdV2drb1WMTDcd5kgBQf8aiYviIS+9MfXqAetoKEY1YZ8nEozI36bn8XAxz1yK3n4Kr13+bUDkepNq6SuLPh+vhPE911urpUUAso9WMFyWUQ1B196NWn7uCwtT0cZpHWTVX8tE/rkcApWxXJWgVrtc4JzysJtX+41pbrQazcfwZNBsPpMebBPdNnFNPxoBLb5mxmciL9KCc9DrYyMfqLv/0ouoAYw1rsXBRNQl4eJml4ID1FwfJX/ddGNU/4Ad2sUQkPhvV/iYNyhr7hNItjYzz5J3oQQyj5ADwkPrGgigVDUtIFGwLBxf7FK7n1+9Pt9d8XPdyjMA84fiUnUfyP71SC4CWfv2QH4qGPoctUQT0y+UgzReU9YVHk+1qzN2Q2mkSFapyi6g+8a/oNXswp1qDcFBkz4aRYRZ1+s06Ja3PoE16xLiZKEEJjfoCpNKKwKPxtv3e8BM8nxp/nBubKkjG45B33z5cz5BYwOjKiKwpKLrGqkGVdHSrFv0vfA0n8Yt/kilZRI29Z7aqMLBK/98mftocPfX0ay9O6BOA51kdjd/t3lSgwdyU1iJLFNltvmCdbde2pkutQz9/H/g2B6XkwC4im7jNNjj6KLQswFgrWlI77/pxLI6m4j0JBWwnafrMGZdgzeqNvDQBuWtk9JAPOH
 4fZmEjcQ
 lZw4Up+vqqgfJVywmlp8L3UUrjxr2VIrFidVS1sSqZTKIhO3cFLQEruCM8Z/GjP+espJhBt4LmN1L8GmMYuKtGtnel7Z5axBYQvJWnAN1gCUb4GWVNEl+DxdIecLwUoUHpEMr1NU/1t2aq6f+pQ7ROdQ9o2bCFwQ7Q/J0p2FSLyS3JOyh1UwaSW+B29jNmq1MMZTkp+iVm7H8pKReQ7ggN2UH4vd4U9nuBXzSd0GXt127ccPg3o5PtyHSkXt5b7mc3bJyUPCrXsbQx/3YJuNhuL9L5XGInyDZWGjpgjXrrJi03kDHXBWjAgwh+F4KmpGpp8wqhfyQ+WVhyR641sVSc5gKuJyYWVmRENQ9Mungt8Fbpx9X8AsVGVaSdDCzlLy4UQ1n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baoquan,

First of all, thank you so much for the great work. That closes a huge
gap in the xswap stack. It is a huge step forward.

On Sat, Sep 19, 2026 at 9:20=E2=80=AFPM Baoquan He <hebaoquan@kylinos.cn> w=
rote:
>
> This is the writeback layer for xswap, on top of the base series. Post it
> as RFC for discussion.
>
> The base series keeps every swapped-out page in zswap. So the pool must
> refuse new pages once it's full. This series gives an xswap slot a
> backend to go, and charge it only when it really goes to real disk
> space.

We should also preserve the charge to the swap counter when swapping
out to xswap. I don't mind having an additional counter track
compression memory vs. disk usage, etc. The swap counter charge should
preserve the current behavior.

> Design
> ------
> - Backend: when zswap refuses a page, take a slot on the real swap
>   device with the highest priority and write the page there. One IO per
>   slot.

More than that, it should also happen when zswap needs to do the
writeback. Zswap has some write back hooks when the system is under
pressure. Those hooks should be introduced into the core swap stack so
other swap types can benefit from them as well.

I would like to point out that the allocation strategy should be
different when allocating for the swap backend. We might want to
introduce an allocation flag for that. The backend doesn't care about
fragmentation as much. Fragmentation is a performance optimization
here. The backend can tolerate fragmentation. In the upper layer, swap
entries are 2^N aligned and sized. It is a hard requirement.

> - Ownership: that slot has no swap cache folio, so record its owner in

Clarify: by "that slot," you mean the backend swap entry has no swap
cache folio.

>   the swap table entry. 0b100 in the low bits marks a backend slot, and
>   the xswap type/offset go above. The physical side then does not treat
>   it as free, and readahead skips it.

I don't want to get ahead of ourselves. You have only considered
writeback from xswap to disk so far. A stretch goal for you is to
consider how we can mark the swap table so that it can work with other
swap types as well. e.g. e.g., writing data from SSD to HDD. We don't
have to do it in this series. But it is good to start considering this
kind of thing so that we don't lock ourself out when we want more
generic writeback between swap tiers.

Stretch 2 is considering how to deal with data moving from xswap to
SSD, then SSD to HDD. The front swap only needs to point to the HDD
and skip the SSD completely. It shouldn't require a forward chain.

> - Per-slot record: ci->xs_table[], one unsigned long per slot, allocated
>   the first time a cluster takes a backend. Zero means no backend.

There might be some micro optimization we can do if the whole cluster
does not point to any back ends, we might be able to design the array
access so that we don't need to allocate the back end pointer array
for it.

> - Read: a written-out slot has no zswap copy, so swap_read_folio()
>   follows the pointer and reads from the backend.

We need to pay attention to the race condition here when moving data
from xswap to the backend. I am not saying you have a bug here, I
haven't read the code yet. I imagine there will be some very tricky
swap cache interaction going on here.

> - Release: verify the slot still points back to the xswap entry first;
>   the record can go stale.

What do you mean the record can go stale here?

> - swapoff: try_to_unuse() used to skip these slots. It now reads them
>   back, marks the folio dirty so reclaim re-stores it in zswap, then
>   drops the backend.

It seems data can remain in zswap past swapoff? That seems wrong to
me. In my mind, it should just read into the swap cache or promote to
the upper swap tier.

> - Reclaim: an xswap entry's count can reach 0 while its folio is still
>   in the swap cache; the physical scanner reclaims the redundant slot
>   through __try_to_reclaim_swap().

Clarify: I assume you mean swap cache reclaim not the memory reclaim.

> - Large folios: a read starts at the first physical slot, so the run is
>   reserved whole and must be backed contiguously; otherwise the fault
>   retries at a smaller order. xswap is SWP_SYNCHRONOUS_IO, which also
>   skips readahead.

I imagine the front swap needs to be contiguous, but the back swap doesn't?

> - Charging: Record the owner at allocation but do not charge. Take the
>   charge when the entry gets a physical backend slot, and give it back
>   with that slot.memory.swap.current then counts only real on-disk swap
>   usage, and a cgroup with memory.swap.max at 0 can still swap out throug=
h
>   zswap.

I want the old swap charging behavior back. Please don't change that
behavior. That behavior change should be a separate discussion and
split out from this series. BTW, I am against that change.

Great work.

Chris

>
> Note
> ----
> The base series is sereis of xswap foundation. This one depends on it.

Do you have a git repo I can fetch from? I will try applying your
patches as well. I assume mm-unstable should be the base?

> So if anyone wants to apply this patchset, the order is base-commit
> as below, then xswap foundation, finally this patchset.
>
> [PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
> https://lore.kernel.org/all/20260916101929.149106-1-hebaoquan@kylinos.cn/=
T/#u
>
> base-commit: baa8de2f3448d1466a888a805c18d01c998fe052
>
> This partially refers to Nhat's vswap-v4 series. E.g patch 1 is
> consistent with his patch 3, patch 12/13/14/15 are from his patch 8.
>
> And the last 2 patches are fixing bugs when charging patches are added.
> Since the charging of xswap is still under discussion, I dind't merge
> them into commits. Will squash them or take them off once decision is
> made.
>
> Testing
> -------
> qemu KVM guest, 8G RAM.
>
> A 4G swap disk /dev/vdb is added as the physical backend, and zswap is
> turned off so that every page has to reach a backend slot. Note that it
> need create xswap device firstly then disable zswap, so every page has
> to reach backend slot.
>
> The workload is memhog, as in the base series. Every page is filled with
> a fixed pattern, so the data can be checked after a readback.
>
>   # echo 1 > /sys/module/zswap/parameters/enabled
>   # echo 100 > /sys/kernel/mm/xswap/create
>   # mkswap /dev/vdb && swapon -p 0 /dev/vdb
>   # echo 0 > /sys/module/zswap/parameters/enabled
>   # mkdir -p /sys/fs/cgroup/xswap_limit
>   # echo max > /sys/fs/cgroup/xswap_limit/memory.swap.max
>   # MEMHOG_FILL=3Dpattern numactl --cpunodebind=3D0 --membind=3D0 ./memho=
g
>
> 1. Swapout to the backend
>
>    Run the workload with 5G of memory in a cgroup capped at 4G:
>
>    # awk 'NR =3D=3D 1 || $1 ~ /xswap|vdb/' /proc/swaps
>    Filename                Type        Size      Used      Priority
>    xswap0                  xswap       8155132   2392176   100
>    /dev/vdb                partition   4194300   2392176   0
>
>    The two Used values are equal, so the pages reached the backend and
>    the xswap side accounted for them.
>
> 2. Pages are read back from the device
>
>    Lifting memory.max and touching the pages again reads them back. The
>    pages-swapped-in counter went up by 265642, so the read did reach the
>    device. 1010 of the folios read back were 1M, each read with one IO:
>
>    # echo max > /sys/fs/cgroup/xswap_limit/memory.max
>    # cat /sys/kernel/mm/transparent_hugepage/hugepages-1024kB/stats/swpin
>    1010
>
>    hugepages-2048kB/stats/swpin stays at 0, because the swapin order is
>    capped below the PMD order.
>
> 3. verifies data correctness
>
>    After the readback the data is compared byte for byte against the
>    pattern, one time with zswap on and one time with zswap off, so the
>    pages come from zswap in one time and from the backend in the other
>    time.  All bytes matched.
>
> 4. Destroying a device returns its backend slots
>
>    The device was filled, then destroyed with no readback first:
>
>    # awk '$1 =3D=3D "/dev/vdb" { print $4 }' /proc/swaps
>    3157220
>    # echo 0 > /sys/kernel/mm/xswap/destroy
>    # awk '$1 =3D=3D "/dev/vdb" { print $4 }' /proc/swaps
>    0
>
> 5. verifies the charge is correct
>
>    An xswap entry is charged only when it holds a backend slot, so the
>    two counters have to show the same number of pages:
>
>    # echo $(( $(cat /sys/fs/cgroup/xswap_limit/memory.swap.current) / 409=
6 ))
>    526852
>    # awk '$1 =3D=3D "/dev/vdb" { print $4 / 4 }' /proc/swaps
>    526852
>
>    Nothing is charged while the pages stay in zswap: with the pool holdin=
g
>    them and the backend untouched, memory.swap.current stays 0.
>
> 6. A cgroup with no swap room can still reclaim its anon memory
>
>    With memory.swap.max at 0 and no xswap device, the cgroup ran out of
>    room and the workload was killed. With an xswap device and zswap on,
>    it swapped out through zswap, was charged nothing, and was not killed.
>
>    E.g if memory.swap.max is set at 100M, the cgroup will be killed when
>    the cap was reached.
>
> Baoquan He (12):
>   mm, swap: tag a swap table entry with its owning xswap entry
>   mm, swap: prepare the folio-less allocation path for xswap
>   mm, swap: add a physical backend for xswap slots
>   mm, swap: use the xswap physical backend
>   mm, swap: fall back to disk when zswap refuses an xswap page
>   mm, swap: support swapoff of an xswap physical backend
>   mm, swap: reclaim physical slots backing cache-only xswap entries
>   mm, swap: back a large xswap folio with a contiguous physical run
>   mm, swap: enable THP swapin for xswap entries
>   mm, swap: drop swap_folio_sector()
>   mm, swap: do not retake the cluster lock when uncharging an xswap slot
>   mm, swap: drop a refused xswap backend run directly
>
> Nhat Pham (5):
>   mm, swap: prepare the swap IO path for xswap backends
>   mm, swap: split the swap memcg charge helpers
>   mm, swap: do not charge zswap-backed xswap entries
>   mm, swap: charge an xswap entry when it gets physical backing
>   mm, swap: don't gate xswap on the physical swap free count
>
>  .../admin-guide/cgroup-v1/memcg_test.rst      |   2 +-
>  include/linux/memcontrol.h                    |   6 +
>  include/linux/swap.h                          |  69 +-
>  include/linux/swap_ops.h                      |   9 +-
>  mm/memcontrol-v1.c                            |  10 +-
>  mm/memcontrol.c                               | 147 ++--
>  mm/memory.c                                   |   7 +-
>  mm/page_io.c                                  |  95 ++-
>  mm/swap.h                                     |  35 +-
>  mm/swap_state.c                               |  12 +-
>  mm/swap_table.h                               |  53 ++
>  mm/swapfile.c                                 | 742 ++++++++++++++++--
>  mm/zswap.c                                    |  20 +-
>  13 files changed, 1026 insertions(+), 181 deletions(-)
>
> --
> 2.54.0
>
>

