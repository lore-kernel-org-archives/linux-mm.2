Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 923DFC98328
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 03:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6713F6B0093; Sun, 27 Sep 2026 23:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 622076B0095; Sun, 27 Sep 2026 23:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 537546B0096; Sun, 27 Sep 2026 23:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30AB76B0093
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 23:31:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA93680ADD
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 03:31:06 +0000 (UTC)
X-FDA: 85261744932.18.2F8FA44
Received: from mta0.migadu.com (out-196.mta0.migadu.com [91.218.175.196])
	by imf02.hostedemail.com (Postfix) with ESMTP id 838D980008
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 03:31:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oM2bDbos;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.196 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790566265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K0VIYU3Cq5jFyRUvJtc69wYSWkNJMMgIPzKtoX5wGoA=;
	b=pYy+vyNDiPR2/tHJo4Tzht1jyLEjFfxRm6eFGab23rEP2Pdqbi810F8g1V1qgA8DfbwB5f
	fYSoP+85xK9YTGii8iZHJHkzRXhZ1BQ64W18Yir0HEuGN34+0BDJ/zc3UYGU720Sq76qes
	1+cFvWhv4Q1NUlel0q+GUhPutPs2sug=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oM2bDbos;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.196 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790566265;
	b=OBRhlawyz7jGElABdISf1tMbMS7RzcxyXWa1NptcU7PV1zVDL7yQQIERYEFoOrh+uYeSYX
	69UvF7BFj7eRS+ZvjeH1Nv51+7YvwWjBft4vWIm6izjpVMvcPretyRhPRHqScZ7nwSy19P
	LtGOBfTgwtCUvNL+q/7XxJXSx/oq9x8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=uv9M24Qa5k6EVTqz01RkycmxxgZEZ2RP0htT0pOwIY0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790566262; v=1; x=1791171062;
 b=oM2bDboskrZ25NEG56HQUSEOQYCeXXsSYoLqGZvhJd3j496HdzmAcPuk6VxfK3A8Mm07Zrzr
 ZtXqslzrVTBwJqY5lAHJ6fJffU4KIcoGp7HLv+N0thMDLYlcNPum4ZKFXRNlNNREXFStcXuaHBM
 IuVGyih9M+RgAjNj/t4guFQg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id a5420bbe46061314;
	Mon, 28 Sep 2026 03:31:02 +0000
X-Mizu-Trace-ID: a5420bbe46061314
X-Migadu-Flow: FLOW_OUT
Date: Mon, 28 Sep 2026 11:30:59 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Klara Modin <klarasmodin@gmail.com>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, nphamcs@gmail.com, baohua@kernel.org,
	youngjun.park@lge.com, david@kernel.org, kunwu.chan@gmail.com,
	gourry@gourry.net, riel@surriel.com, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev
Subject: Re: [RFC PATCH 00/17] mm, swap: xswap writeback to a physical backend
Message-ID: <arnfc8oXEdCJrWEw@MiWiFi-R3L-srv>
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
 <arUKSOVFzPF-iHxU@parmesan.int.kasm.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arUKSOVFzPF-iHxU@parmesan.int.kasm.eu>
X-Stat-Signature: 3bgnxok4fzkw8e68kanmckwrquzwd9sk
X-Rspamd-Queue-Id: 838D980008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790566264-469246
X-HE-Meta: U2FsdGVkX1+S1S+8jCrHvXVJgi1oxOu7t0KQJwGrcx35Lpfiz1uiHhb+66xMEfRmJwayfHvSc0UYVNrdr2jW7Ej9pxGwV/1isELpyRgslcxTM9KqHwtQmfymiWNZ85rC9YkrJeLpDMi25rCGbxmzjLSVHGezgrZ0wehi6LCNwB3GxpOaXov5p5LTMW1MZay7a6dIZX4FHJt4CCrhTmYSaWOlOqsx1oTFs44T+Ez0f2vl31zFgICj1g6U3WIHadGWNPIq1DiMnNZNFe1Bt9LxToTtAfmdYjhxRS5O55v4H3u2yMPD1zjgChcSxqis0vtH3wlA1v4WMNzvq6j0M3a6kGqM9L4iWerrk10S7BdvCGqfuP3OiiGYMx1klS1xxDKwx12Wsa9ddFLKYHWN1YsdZU+GMFjB5uk7amRAerEEvV5m6jdsEmhIXqHanvFbpm75ceQrGu7Idn+/BuMMZX4RMuw9KxBTvFJhbecW9msPYUU5jv58v860W/W+/aTARnLwaTMMePVGA9GsBXxlArJ/VR4UJFV2SAsm3aKmRLOMplj+QP8cTYl0d1iZijiO1p5emM9RJe2eIAwnZhoWVubTD2ENEtGjR1HrWe5q8MPXDqkq+++YCoflrQBFi4yIr4jaUKq23DmzoFouIrzLSyC8ZycQsWO8KwfohLQUIPk5zWjcRFycn8y+oCVEjAFToqIwwhGW3XulXnZqZEIwm1/IDc6nm+RNHYZHjpejQTTXqMUQv1WredKIeDgB0EGqEgsETclMPXC3oAdJC6QBZLEp/fIXh8mIJ+1pgzWwmLI5coF4pNzhiLkapFQ9tZi5vD1kPEfSxjkG8X9XqaLshT5iR1EeLhugb8GiBT+N1MvvC27sSBo+lcXq3wvVtun2ZTd1eys8MVxNGwZGmCIUq6NHEt3MTV5bfymI5ewLq8y6NfRoDEQ7gv+avToHCIa5AN1+D/SCols076LxRgxaa5V
 Fs61B6oT
 XKJYDQdBhgmAajm2x1ZQMIjEe6NGF0Tor6EFfhRhNk7k4eD2quEk+EjvgyrrbGHzWpchK65yYIZwQ32NfsKO2qtzcvpyRPtxXY2QDZ+EXCTdAn8aimbkQvtYY+OS4vlQzlUuvzdZuKgA2iiyP8p6Wo386gNucoAiRs2fAt4XQ3tfyXYlaSjrrr+9AoCJ9jel9AXDjqE4Ie/E2vQRuUNUh+tHTgm5fnipoo2YWpeQ+WLWiOJQkhSTOcoW1zlhqOINtlTcKYwtTx24wRjlZ6wIerlL2s4C0lj7MGGKTUw1wOFpmQbOVtp/tIvPC9gEYVdOVYYVPQB29x8P2LCPcTCNmMl4/ngfXgJO/v7HQKj+Qxe0tzQCKWNbX4mL7GmTYlXlNeMaA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/24/26 at 02:17pm, Klara Modin wrote:
> On 2026-09-20 15:20:26 +0800, Baoquan He wrote:
> > This is the writeback layer for xswap, on top of the base series. Post it
> > as RFC for discussion.
> > 
> > The base series keeps every swapped-out page in zswap. So the pool must
> > refuse new pages once it's full. This series gives an xswap slot a
> > backend to go, and charge it only when it really goes to real disk
> > space.
> 
> There is some weird trailing whitespace in this email for some sections.

Thanks for careful checking, will clean this up before sending out.

...snip... 
> > Testing
> > -------
> > qemu KVM guest, 8G RAM.    
> >    
> > A 4G swap disk /dev/vdb is added as the physical backend, and zswap is
> > turned off so that every page has to reach a backend slot. Note that it
> > need create xswap device firstly then disable zswap, so every page has
> > to reach backend slot.
> > 
> > The workload is memhog, as in the base series. Every page is filled with
> > a fixed pattern, so the data can be checked after a readback.
> > 
> >   # echo 1 > /sys/module/zswap/parameters/enabled                                                     
> >   # echo 100 > /sys/kernel/mm/xswap/create                                                            
> >   # mkswap /dev/vdb && swapon -p 0 /dev/vdb                                                           
> >   # echo 0 > /sys/module/zswap/parameters/enabled                                                     
> >   # mkdir -p /sys/fs/cgroup/xswap_limit                                                               
> >   # echo max > /sys/fs/cgroup/xswap_limit/memory.swap.max                                             
> >   # MEMHOG_FILL=pattern numactl --cpunodebind=0 --membind=0 ./memhog
> 
> You did not include e.g. cgexec here, so is memhog really running in the
> cgroup you created?

You are right, I didn't write out the full command, just list the steps.
And here memhog is not a standard one from installed rpm package
numactl, it's a small local helper. It faults <total_GB> of anon, holds
it, and can drop the mapping or read it back. And the helper keep a known
byte pattern, so the data can be checked byte for byte after it is read
back.

# echo 1 > /sys/module/zswap/parameters/enabled
# echo 100 > /sys/kernel/mm/xswap/create
# mkswap /dev/vdb && swapon -p 0 /dev/vdb
# echo 0 > /sys/module/zswap/parameters/enabled
# mkdir -p /sys/fs/cgroup/xswap_limit
# echo 4G > /sys/fs/cgroup/xswap_limit/memory.max
# echo max > /sys/fs/cgroup/xswap_limit/memory.swap.max
# ( echo $BASHPID > /sys/fs/cgroup/xswap_limit/cgroup.procs
#   exec env MEMHOG_FILL=pattern numactl --cpunodebind=0 --membind=0 \
#       /mnt/kernel_src/testing_kernel_hebq/xswap/memhog 5 600 ) &

I will add the complete block in next version, sorry for the
inconvenience.

> 
> > 
> > 1. Swapout to the backend
> > 
> >    Run the workload with 5G of memory in a cgroup capped at 4G:
> > 
> >    # awk 'NR == 1 || $1 ~ /xswap|vdb/' /proc/swaps
> >    Filename                Type        Size      Used      Priority
> >    xswap0                  xswap       8155132   2392176   100
> >    /dev/vdb                partition   4194300   2392176   0
> > 
> >    The two Used values are equal, so the pages reached the backend and
> >    the xswap side accounted for them.
> 
> This is a bit confusing to me. If I now run free, the written back data
> will be represented twice in the sum? Since the written back data is
> still presented as used in the xswap device, does it still consume space
> there, i.e. does it prevent that amount of new data being stored in the
> xswap device? If this is the case, it would make it even harder to
> dimension the xswap size since one would also have to take into account
> all the other swap devices which are present in the system.

I have to admit you found out an issue, thanks. I noticed it too while
I havne't thought of a satisfying way to fix it. What I can think of
is to mark the usage size of writeback on disk and list it separately. 

# awk 'NR == 1 || $1 ~ /xswap|vdb/' /proc/swaps
Filename                Type        Size      Used            Priority
xswap0                  xswap       8155132   2392176         100
/dev/vdb                partition   4194300   2392176         0
                                              2392176 (xswap) 

If xswap is disabled and full, /dev/vdb got swapped out data by its own,
then the amount of used slot will be reflected as before.

# awk 'NR == 1 || $1 ~ /xswap|vdb/' /proc/swaps
Filename                Type        Size      Used            Priority
xswap0                  xswap       8155132   2392176         100
/dev/vdb                partition   4194300   3000000         0
                                              2392176 (xswap) 
I think this can be fixed later, I see it as a non-blocker for now.
	
> 
> > 
> > 2. Pages are read back from the device
> > 
> >    Lifting memory.max and touching the pages again reads them back. The
> >    pages-swapped-in counter went up by 265642, so the read did reach the
> >    device. 1010 of the folios read back were 1M, each read with one IO:
> > 
> >    # echo max > /sys/fs/cgroup/xswap_limit/memory.max
> >    # cat /sys/kernel/mm/transparent_hugepage/hugepages-1024kB/stats/swpin
> >    1010
> > 
> >    hugepages-2048kB/stats/swpin stays at 0, because the swapin order is
> >    capped below the PMD order.
> > 
> > 3. verifies data correctness
> > 
> >    After the readback the data is compared byte for byte against the
> >    pattern, one time with zswap on and one time with zswap off, so the
> >    pages come from zswap in one time and from the backend in the other
> >    time.  All bytes matched.
> > 
> > 4. Destroying a device returns its backend slots
> > 
> >    The device was filled, then destroyed with no readback first:
> > 
> >    # awk '$1 == "/dev/vdb" { print $4 }' /proc/swaps
> >    3157220
> >    # echo 0 > /sys/kernel/mm/xswap/destroy
> >    # awk '$1 == "/dev/vdb" { print $4 }' /proc/swaps
> >    0
> > 
> > 5. verifies the charge is correct
> > 
> >    An xswap entry is charged only when it holds a backend slot, so the
> >    two counters have to show the same number of pages:
> > 
> >    # echo $(( $(cat /sys/fs/cgroup/xswap_limit/memory.swap.current) / 4096 ))
> >    526852
> >    # awk '$1 == "/dev/vdb" { print $4 / 4 }' /proc/swaps
> >    526852
> > 
> >    Nothing is charged while the pages stay in zswap: with the pool holding
> >    them and the backend untouched, memory.swap.current stays 0.
> > 
> > 6. A cgroup with no swap room can still reclaim its anon memory
> > 
> >    With memory.swap.max at 0 and no xswap device, the cgroup ran out of
> >    room and the workload was killed. With an xswap device and zswap on,
> >    it swapped out through zswap, was charged nothing, and was not killed.
> > 
> >    E.g if memory.swap.max is set at 100M, the cgroup will be killed when
> >    the cap was reached.
> 
> Disregarding my comments and opinons on the interface, it seems to be
> working so far and I can see writeback happen during a GCC 17 build on
> my BPI-F3, but the entire thing takes roughly 18 hours and is not done
> yet.

Thanks again for your careful checking, testing.

Thanks
Baoquan

> 
> > 
> > Baoquan He (12):
> >   mm, swap: tag a swap table entry with its owning xswap entry
> >   mm, swap: prepare the folio-less allocation path for xswap
> >   mm, swap: add a physical backend for xswap slots
> >   mm, swap: use the xswap physical backend
> >   mm, swap: fall back to disk when zswap refuses an xswap page
> >   mm, swap: support swapoff of an xswap physical backend
> >   mm, swap: reclaim physical slots backing cache-only xswap entries
> >   mm, swap: back a large xswap folio with a contiguous physical run
> >   mm, swap: enable THP swapin for xswap entries
> >   mm, swap: drop swap_folio_sector()
> >   mm, swap: do not retake the cluster lock when uncharging an xswap slot
> >   mm, swap: drop a refused xswap backend run directly
> > 
> > Nhat Pham (5):
> >   mm, swap: prepare the swap IO path for xswap backends
> >   mm, swap: split the swap memcg charge helpers
> >   mm, swap: do not charge zswap-backed xswap entries
> >   mm, swap: charge an xswap entry when it gets physical backing
> >   mm, swap: don't gate xswap on the physical swap free count
> > 
> >  .../admin-guide/cgroup-v1/memcg_test.rst      |   2 +-
> >  include/linux/memcontrol.h                    |   6 +
> >  include/linux/swap.h                          |  69 +-
> >  include/linux/swap_ops.h                      |   9 +-
> >  mm/memcontrol-v1.c                            |  10 +-
> >  mm/memcontrol.c                               | 147 ++--
> >  mm/memory.c                                   |   7 +-
> >  mm/page_io.c                                  |  95 ++-
> >  mm/swap.h                                     |  35 +-
> >  mm/swap_state.c                               |  12 +-
> >  mm/swap_table.h                               |  53 ++
> >  mm/swapfile.c                                 | 742 ++++++++++++++++--
> >  mm/zswap.c                                    |  20 +-
> >  13 files changed, 1026 insertions(+), 181 deletions(-)
> > 
> > -- 
> > 2.54.0
> > 
> > 

