Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED42CC98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D07476B0088; Thu, 24 Sep 2026 06:00:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8476B008A; Thu, 24 Sep 2026 06:00:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA75C6B0093; Thu, 24 Sep 2026 06:00:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85CD36B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:00:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0617F1A0214
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:00:38 +0000 (UTC)
X-FDA: 85248211356.10.8883CFE
Received: from mail-lr2-f30.google.com (mail-lr2-f30.google.com [74.125.230.94])
	by imf12.hostedemail.com (Postfix) with ESMTP id 333AE4000B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:00:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="nEg4giM/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of klarasmodin@gmail.com designates 74.125.230.94 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790244036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jn5PGTIKzsWJJgsHf1vn6sS9xeXwHdDO76IxSeD182Q=;
	b=WG8fhv8sUOFuNdeNM5gwq4Ey4chTNnDLd9JHPn09wffu9gHi7v5sRX1Y5ffJBq6CsP1Clt
	swuJxikj18MLZJweuYaumaQ82iVq+NTHf396C9eCwqLE7QpO2H+jzTdJoy/wNKWVDgcT9V
	NgsWDg5s8/Tm9azVXdS+uGKVdR2V90E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="nEg4giM/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of klarasmodin@gmail.com designates 74.125.230.94 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790244036;
	b=kajj/CtRCHcsmf7G0ww/ulicscTm4TbumYYT3JVUroW7dgL+tx4jy5abgHoCeNKTA/9R8Z
	WprvhNS3KYjSwv9/MRxKD4NcyJtjhNkfshEuK84jDWFT6aLHGTUj0hrf/JnrFsQc3P1CB/
	B+29/iFRW9pKL2Cqd/G8UW9rKYMRh6Q=
Received: by mail-lr2-f30.google.com with SMTP id 38308e7fff4ca-3a318299b38so17419751fa.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790244034; x=1790848834; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Jn5PGTIKzsWJJgsHf1vn6sS9xeXwHdDO76IxSeD182Q=;
        b=nEg4giM/oaHttrpm/MA1hMV03kNUPQl/Xzd6nxD1iS7rOBnJNN3JexJ382lBIjVpwd
         gZDLHCPBDDDNSgxFTiD8z62lqC/cfOoPLo/2iSjziqjeBaBqKFLlYItWKXmfWhREbCQa
         68oAAA+US2X+gfGBamKT5g7ViwMrhmdItvcjDa+ev7IcJKJwyGZ9wBS2OXn89hEoANlm
         jmWc6N7y031Mld+ZnlbL7BJrMmXRi+itqxh+j/XzPmpWq2JkJTlGqkbhKYwTLPkYJDRj
         xM0z8LZVJokYwWhkWRkP5z+fV6KK+3NitjNASjcMR0iSsJujvRwMWr2+SseVe8uqP6M/
         3KjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790244034; x=1790848834;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jn5PGTIKzsWJJgsHf1vn6sS9xeXwHdDO76IxSeD182Q=;
        b=E5I+GyOFaPUvNj1xp11GPGbwFS9YeR2etKwM9//QGsg4Kbp4aGu1yhJdC5fHgYSzRl
         f8qg7AKLDdpK3eSs9+WXKuBjnEQqOW2AxUjCqazu7rRC0f2HXWlMZeq+nDUL3epesY+4
         KzDgdBLRf33lbT58iDlJAttjzKwFK1E/nBK+9LvHPWUt5bbDbunhpp0TrpWyD9rS+tln
         u7lm3gMOS3AHjGmkW0D7XpwO6Q/h3yWJMtSggNjSZT0NR1slSH81T4NMFa80TDF0Fbcn
         QvO9Zk+TY6rCNvvqM6KiQQ+6QgZjxdu7T6MEGJ5Qpu05Hx1SkkktwblVmV9mw7RPXPAK
         Zhkw==
X-Gm-Message-State: AFuF++mkYCbV4bVKn5y+soFdZdNQgUlz2nzvwLlUF+95ccCzMzKWHTWe
	SwQq3WYbwza18EpFPjRffSCJh0dOmtWCU0nnsgClTLPvQNgXylzDlVFj
X-Gm-Gg: AYBFou1deXhSM8aiEm1MSlC6acC9d1RmCZaIWvf0O/TmRAgHBjYz7wdEPYkCATtFkh1
	9yajFGQJ8EjRsITMasNY995OW6rwrVCKhAta4EebXyUqWHYYxymMR5L3P1nDd/DvBel2BsiwgDF
	ujUIiVS0IBL7I1Qt1twjEdkD5srlKllKYK8xjJAVxFyfWKMJmeq1uMVenIq5PLcPZixtv5TANuR
	29w/rVshp993ZEu+fCh+WZTvHbbdI2Gfx39xiJn97jLxFnPikdDeNh5qb+mrcDa4wlRI0bV8Mhe
	ecQpbPJH5e6RMeS/B4ozNFTcf8dzA8PoUWFdHvKtuwbHI+/qgfqphJZODvD5vxVYzc1LNP053vN
	vup/cEeatt7AAJBsrFKeeoV8nx2UHBT3VQQuoYTvTYycf9ZxbZ+Bdlk3jHNjZ3YteUMkjQyIsru
	QQxrr1rRtk73IeM/1GRduCJoekbnkgtkrjfP1ncjpgNc5Yc6ptyLK6jGeR08A9x6yhynymjWIC/
	MWbYtRDPAjFiSSVrl61g8PAq7Rj
X-Received: by 2002:a2e:be84:0:b0:3a1:30c4:d95 with SMTP id 38308e7fff4ca-3a63bf684d2mr5192491fa.5.1790244033541;
        Thu, 24 Sep 2026 03:00:33 -0700 (PDT)
Received: from localhost (sol-eduroam-pathost130.ki.se. [130.237.96.130])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a63bdbc54bsm5933921fa.4.2026.09.24.03.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 03:00:31 -0700 (PDT)
Date: Thu, 24 Sep 2026 12:00:31 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Subject: Re: [PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
Message-ID: <arTwYTK22Wm0u3BC@parmesan.int.kasm.eu>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916101929.149106-1-hebaoquan@kylinos.cn>
X-Stat-Signature: 47miywois8eu9ajbknkxtjuzgw7otsky
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 333AE4000B
X-HE-Tag: 1790244036-465809
X-HE-Meta: U2FsdGVkX18NYm6+Zp2jqbLyLRydTfWlgq6bMtGjS4v4p4jpAmEb32hOIdkTt5taR8EVUwqwsVxBCAY0dLeUPjDTgSvPXOiJOgdkY43Gj9kdffr2yfP6jCoiiNpXYn0INX1hPiquReNLYixwUfpTPVsqbZv5hItmzMk4xW8fSVKsjd9SaxTF3wKJ3qJ45HgeZL4paQbQdiSFsbn4rabpXJfp+c8xAybe9tG6Xop2EDIrrXPHBIgrFhaoWVU6rdhv6XUe5g6wDlrj02Rzz9sk/JPwBr/+/lD0CE/wZAnYjVvhJr7BEIi82mWQR7hK6dThjv3Kq8nQ3hxI51Wpg663lu8XYCVfEc3K3RE5E2ToGEN8KNtlfZqPsJIhNr9f/HHH7IiD9eFT3KIs4wED3h13in1PDh9bdpJV2kTbPRqZkKr5JDp5lhEmO3OD+VQA5CIN9ErcmkDtFGOTLierAEToh6xl94WxxHr/qEtahNnb/+I27w3BDcY9iUDcpmshN9aIMVBl67s3zab64JoXlYhUg7rFOAfE4vRMsLOtGmuu2JVIQpGK3kO0cVn+ma5NZpM0eXUmsgfcR2UnGeWmPFo4mht8rWPYovPdDC/R40doZC7REYzjenZFdZzXZrT55KXFzMkdDyseEOlRHMDGoDGG6vh2lUHOd72aDgikB2lPjdPzR9+HFJxwOJUjOEo56dvIocr8Xto9VHEexvbbg1f4ln3kWW90v5DPoBZ2vCcB7gSMY7006lw8L4GW+Yo1Xw7K9lTz7+kACv/VeZdjTg5iL3Yq5CdyOljRLC6L/OEw5YR+AwX4iXcxpHUVnGNuug22BmpcK3YQA7jM65qn47PvjQopz9qup7Eef4XxvTomgdvoF10bGYFnSyIvN/lPWJuw9b4M32tumS3edZPPiKs6/We4VWh47I2HLlDSz2Jc6aXUiPMkkh2bMnRxCf9Y9NGi64jA4bCpKNObbwCpBUl
 bWxARxUm
 hMrEAnZeYVR0Op3mV7PdLC3qt5jR0/OG1j/ZnbsdVcjz6WWIB8mkUhB68kNlD30qAaxVTOSEu64N7lEY3X+bkM8/23M+aWQYBZKxZ1ewAQCFKroEHwFd9BweYP4QiNzklvH7nnBybvfq10BNsxNsQ5lD8WlGS6vTho7JTdP/6x/z1631dvg4PJ7mizEM0jXaUZyDmCcAKbHdIijDpEqSvXpnPhqWnGkQsUvbNtfNXQBL/GBmDtXHHga+D12upAEiJQfG+OVPcMbHsJdLaOJn76UrPDB4O776BgtEdbUAxHb4ASXnoR91Q6igjBrllzZm1rFb3YbHsVwnIbx7g4GqucjrdekM0/GbHA8ecwhlva3TMZzbX4zy3Dlklgo5uWZY2sRKnG+f/qAH6A7ThBh3zBpM1vBPYMAFLusadJax24w4vUmfWkvjdNSBFxnRzg6TypiUg44tjbqGoA2Hot1CwNTAgjKdtc6VBvuj2UHV/GfDDQmY2KCwkUxeuRmyFqaJ8oEVhhH2Z0Kfe5wY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-16 18:19:07 +0800, Baoquan He wrote:
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

So I can't set an xswap device to more than twice the RAM? I suppose I
could create multiple xswap devices, but it would get tedious fast on
systems which have a different amount of memory. Is there a particular
reason for this limit? I think I could create an arbitrarily large xswap
device with your previous version which needed the specially crafted
swapfile (with only the header).

As I wrote in the other thread, I would rather not have to set a limit
at all, or at least have a limit I'm sure I won't reach.

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
> 
> Testing
> -------
> qemu KVM guest, 8G RAM.
> 
> Tested create/destroy, raising and lowering the limit (including clamping
> when it is written below the pages in use), shrink with live entries, and
> 2000 create/destroy cycles for leaks; all passed.
> 
> The workload is memhog: it faults in N GB of anonymous memory inside a
> cgroup with a much smaller memory.max, forcing the pages to swap.
> Set MEMHOG_FILL=pattern: the default fill is all-zero pages that zswap
> compresses to almost nothing, so the device never fills.
> 
>   # echo 1 > /sys/module/zswap/parameters/enabled
>   # mkdir -p /sys/fs/cgroup/xswap_limit
>   # echo max > /sys/fs/cgroup/xswap_limit/memory.swap.max
>   # MEM="MEMHOG_FILL=pattern numactl --cpunodebind=0 --membind=0 ./memhog"
> 
> 1. Create and destroy
> 
>    # echo > /sys/kernel/mm/xswap/create
>    # swapon
>    NAME    TYPE  SIZE USED PRIO
>    xswap0  xswap 7.8G   0B   -1
>    # cat /sys/kernel/mm/xswap/type0/limit
>    2035199
>    # echo 0 > /sys/kernel/mm/xswap/destroy
>    # swapon
>    (nothing)
> 
>    limit is in 4 KiB pages; 2035199 is RAM (2034976 pages) rounded up to a
>    whole number of clusters. The device starts at RAM, not twice RAM.
> 
> 2. The cap holds
> 
>    # echo 2147483648 > /sys/fs/cgroup/xswap_limit/memory.max
>    # ( echo $$ > /sys/fs/cgroup/xswap_limit/cgroup.procs; eval $MEM 11 300 ) &
>    # awk '/SwapTotal|SwapFree/' /proc/meminfo
>    SwapTotal:       8140796 kB
>    SwapFree:         354012 kB
> 
>    The cgroup runs out of room before the device does and the OOM killer
>    takes the workload ??? that is the pass signal. SwapFree never exceeds
>    SwapTotal, so nr_swap_pages never goes negative.
> 
> 3. Raising the cap
> 
>    # echo 3052543 > /sys/kernel/mm/xswap/type0/limit
>    # awk '/SwapTotal/' /proc/meminfo
>    SwapTotal:      12210172 kB
>    # ( echo $$ > /sys/fs/cgroup/xswap_limit/cgroup.procs; eval $MEM 11 300 ) &
> 
>    No OOM this time: 2473705 pages in use against 2034976 pages of RAM, so
>    usage goes past RAM.
> 
> 4. Lowering the cap below the pages in use
> 
>    # echo 1000000 > /sys/kernel/mm/xswap/type0/limit
>    # cat /sys/kernel/mm/xswap/type0/limit
>    2426879
>    # awk '/SwapTotal|SwapFree/' /proc/meminfo
>    SwapTotal:       9707516 kB
>    SwapFree:             860 kB
> 
>    The write is clamped up to the clusters covering the pages in use, so
>    the free slots in the partially used top cluster stay accounted for.
> 
> 5. Shrink with live entries, then destroy
> 
>    # echo 4069887 > /sys/kernel/mm/xswap/type0/limit
>    # sleep 60
>    # awk '/SwapFree/' /proc/meminfo
>    SwapFree:       16279548 kB
> 
>    The shrink unmapped the tail ??? the state find_next_to_unuse() must
>    survive. Put live entries back and destroy:
> 
>    # ( echo $$ > /sys/fs/cgroup/xswap_limit/cgroup.procs; eval $MEM 3 300 ) &
>    # echo max > /sys/fs/cgroup/xswap_limit/memory.max
>    # echo 0 > /sys/kernel/mm/xswap/destroy
>    # swapon
>    (nothing)
> 
>    dmesg stays clean across create, shrink, swapoff and destroy.
> 
> 6. 2000 create/destroy cycles, diffing /proc/slabinfo before and after:
>    the largest growth is 142 objects. One object leaked per cycle would
>    be 2000.
> 
> Performance
> -----------
> (qemu KVM guest, 8G RAM, zram as the swap device)                                                         
> This series should not slow down a kernel that never creates an xswap
> device. I measured that overhead by comparing the base tree with this
> series. Both were built with the same .config and CONFIG_XSWAP=y, and no
> xswap device was created. I ran three 3G MADV_PAGEOUT workloads, three
> rounds each, alternating between the two kernels across reboots. I
> counted retired instructions per page swapped out with perf stat:
> 
>   workload                      base       series     delta
>   swapout                       50824.8    50866.2    +0.08%
>   swapout and swapin            63770.4    63796.8    +0.04%
>   swapout into a full device    67729.9    67707.8    -0.03%
> 
> Two runs of the same kernel differ by less than 0.1%, so the differences
> above are real, not measurement noise. I cannot use wall clock time for
> this comparison, because two runs of the same kernel differ by more than
> the two kernels do.
> 
> Changelog
> =========
> v2 -> v3:
> - Rebased onto the latest mm-new.
> 
> - The grow path now honors the user-set ceiling (si->nr_clusters) instead
>   of growing up to nr_clusters_max, and a ceiling below the mapped range
>   is unmapped exactly instead of rounded to a chunk (patches 12 and 14).
> 
> - The limit write clamps the ceiling up to the clusters covering the pages
>   in use, replacing the earlier WARN_ONCE; si->pages becomes mutable at
>   runtime (patch 13).
> 
> - Minor comment and cleanup changes.
> 
> v1->v2:
> - Patch 1 (mm: zswap: return -ENOENT when the swap device is gone) is not
>   part of this series; it was posted separately.
> 
> - There is only one size knob now. The runtime ceiling and the debugfs
>   per-device limit are gone. All that is left is the optional per-device
>   cap, /sys/kernel/mm/xswap/type<N>/limit. Grow and shrink work without
>   it.
> 
> - The shrink no longer keeps its own count of the free tail. It scans the
>   tail instead, and dropping the counter also removes a call from the
>   cluster allocation path.
> 
> - The priority is no longer a patch of its own. The create attribute
>   takes it:
>     echo 100 > /sys/kernel/mm/xswap/create
> 
> RFC v3 -> v1
> - Add patch 16 to support setting xswap device priority at creation.
>   The create sysfs interface (/sys/kernel/mm/xswap/create) previously
>   hardcoded every new device's priority to DEF_SWAP_PRIO, it now
>   accepts an optional priority:
> 
>     echo "<percent> [<prio>]" > /sys/kernel/mm/xswap/create
> 
> - Bug fix: xswap_lock init ordering. mutex_init(&si->xswap_lock) was called
>   after xswap_map_clusters() (which locks it), i.e. locking an uninitialized
>   mutex. Init now before the first xswap_map_clusters() call. Thanks to Klara.
> 
> - Bug fix: Fixes a compile error in !CONFIG_XSWAP builds. xswap_debugfs_root
>   is declared inside CONFIG_XSWAP ifdeffery scope, so the ungarded use
>   caused error when CONFIG_XSWAP is off.
> 
> RFC v2-> RFC v3:
> - Replace the "header-only swap file + swapon" creation hack with a
>   proper file-less device created and destroyed via sysfs
>   (/sys/kernel/mm/xswap/{create,destroy}).  This required the
>   __swapoff() refactor and the free_swap_cluster_info() signature
>   change (patches 4, 6, 14).
> 
> - Require zswap: refuse to create an xswap device when zswap is
>   unavailable (patch 15).
> 
> - Split the unrelated zswap -ENOENT fix out of the series into a
>   standalone patch (patch 1).
> 
> - Fix nr_free_tail over-counting on concurrent grow, shrink leaking
>   detached clusters on early bail-out, a re-init race on cluster
>   spinlocks in xswap_map_clusters(), the nr_clusters_mapped update
>   ordering, and swapoff accessing the shrinker-unmapped cluster tail.
> 
> - Minor cleanups (checkpatch, /proc/swaps alignment, commit messages).
> 
> RFC v1-> RFC v2:
> - Added __GFP_HIGH | __GFP_NOMEMALLOC to alloc_page() and kmalloc_array()
>   in the grow path, plus memalloc_noreclaim_save/restore() wrapping,
>   to prevent the grow path from consuming emergency memory reserves
>   or recursing into swap under PF_MEMALLOC. This is folded into patch 3.
>   This was pointed out by Nhat.
> 
> - Folded the mutex serialization fix into the cluster grow patch (patch
>   3). This is suggested by Nhat.
> 
> - Fixed coding style issues: corrected indentation of declarations in
>   xswap_unmap_clusters(), removed unnecessary block scope around the
>   err variable in xswap_map_clusters().
> 
> - Rebased onto mm-unstable
> 
> Baoquan He (13):
>   mm, swap: add CONFIG_XSWAP and xswap fields to swap_info_struct
>   mm, swap: refactor free_swap_cluster_info to take swap_info_struct
>   mm, swap: add xswap cluster grow via VM_SPARSE vmalloc
>   mm, swap: add sysfs create interface for xswap
>   mm, swap: add xswap grow trigger on cluster allocation
>   mm, swap: add xswap_try_shrink and shrink trigger on cluster free
>   mm, swap: free backing pages in xswap_unmap_clusters
>   mm, swap: defer xswap shrink to workqueue to avoid lock recursion
>   mm, swap: refactor swapoff and add xswap_destroy
>   mm, swap: require zswap for xswap devices
>   mm, swap: cap xswap growth at nr_clusters
>   mm, swap: add sysfs per-device size limit for xswap
>   mm, swap: shrink xswap to the ceiling when it drops
> 
> Chris Li (1):
>   mm: xswap support for zswap
> 
>  include/linux/swap.h |   26 +-
>  mm/Kconfig           |    9 +
>  mm/page_io.c         |   19 +
>  mm/swap_state.c      |    4 +
>  mm/swapfile.c        | 1240 +++++++++++++++++++++++++++++++++++++-----
>  mm/zswap.c           |    7 +-
>  6 files changed, 1174 insertions(+), 131 deletions(-)
> 
> 
> base-commit: baa8de2f3448d1466a888a805c18d01c998fe052
> -- 
> 2.54.0
> 

