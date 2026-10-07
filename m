Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46AE9CA6007
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 16:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0632B6B0088; Wed,  7 Oct 2026 12:29:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2EB36B008C; Wed,  7 Oct 2026 12:29:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6C66B0092; Wed,  7 Oct 2026 12:29:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABF306B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 12:29:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3A2A11602AD
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 16:29:00 +0000 (UTC)
X-FDA: 85296364440.17.316E306
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6A8702000E
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 16:28:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rJM68mfn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791390538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RVZzMnsixpFGARtt8IMs8sBvKsV/W5PsRCYeKzmQv9o=;
	b=y0O76N2gsx2fis1i8avjzgn8LrdS5PBbWlt6TfFdeApSmbH3WKBuMYESokaR5noNMq/jXg
	kSehqqOEavA7CYkGLXLOye7B5qLc0uO3HN0goVT6YVdsejXDkoMKfCSVnHJ0LI5hEetSer
	8ru/KQRD/vc4R4aV/VhuFeyefAJwKxw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rJM68mfn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of klarasmodin@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791390538;
	b=bd99LeBNVuDR7mCzSauznmcUsTmOWJimBpfKX3qAuoLAWtvnZAZTVfLpb4C/txEtAV1A0k
	EdjLirubPt4FPneUY4RPaF+G0hfQc3boj5zIhl+UMqk2pX0wIryraq95IABwS+AqXDhpQw
	fL7gsrnRX0h8+L6yG6nVKF6qK4y1oWc=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3a76ac0bdafso18453881fa.1
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 09:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791390537; x=1791995337; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RVZzMnsixpFGARtt8IMs8sBvKsV/W5PsRCYeKzmQv9o=;
        b=rJM68mfn7C+D+vdCutompjioF8gcgPhPj3Ofg/Ie4SkyjTV3EqhKUP9FeBSyz1fq08
         7kLepECAvVZoYJ+oi3sCpAl6dcbL9sO/uvOH8NZaY3+mY0KdDowaJ+M0OJc8+SRlO69E
         IFK673kNKMLcqKMaRgGeRKf0pn1fRkgx2z2BnNy1wbtItKEZnDiXEpyTvUYsUasU4rHH
         eGwsQq+broW+UvLhl5XBZZgtuy9Ab1C+3N0SZJK5vA0/ZcTpwPbz96RmXrn1RZXmAFe3
         vTrAnNJeeg7hD3AYbE88SHpOFZxyclp51bFKn3aJ1FiP3FJigFISy8wFHH7CCSn8AXyx
         Kjcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791390537; x=1791995337;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RVZzMnsixpFGARtt8IMs8sBvKsV/W5PsRCYeKzmQv9o=;
        b=o18IKYDsOSVi4zmxoCGwaP8vcJcl6/Gy0UIIkizPS+LsXxlWL9Lgv6MxXf7QBShR9c
         t9fK2E+2doPX5R0uROyCjikhO0vWx7BHMfQS74bTKyJakSwpeCDtEHfh7qCLw5O9Mni0
         jjyVVNFEQEjkLBIuzSJqG+Qj+E7s25OTHbIhqWVZnLkTMG/j8rpnaJQDTaKEU2ZQJ+B/
         C1oTLW7w3Z7vBLJyqRcdQ3FBxKH6Ed7ACnDRYpNUCCMCker0ZrytkTezCYlvUHRY1q0L
         f3LhGVy6yCpiwoqKWQcUhTnDp2CqgU2XaOp7eETmk88l+k3020MWY/NMw6D0YCFdLRUf
         ub1w==
X-Gm-Message-State: AFq9FYLC7KHegzJ0CJOATozeZD4BgdH2u0zWdI+O+8BgEgVXRyA4jnL/
	LezJskQ/z0WMkE/fRf5vCUejfI8fHdWQMGsusVUfETR/V06mKE01zyee
X-Gm-Gg: AYBFou1kRygA6j4q67pGZMlflKTaISl5haUjjkpsHIXeEVHEuKwufuffuIxcrx4b3Q2
	s6qI6AtO83WWtnx0JXBUQ3IMpFp0egmWFtwZNp2vG1jLJUUzBmARcbn1TOPUsVAHsTJs35lE3W4
	jMVPH5VykzXl+FiiY54mbJUVjd0qxyJMX1/X/ukopgaIJJfMuwsZDGNnHVOQOnAfuD4v9wINdRy
	2WEGrZHuztYluWJr8UMVTC0PIjd9HFn3T9+cZzGP+riDlsrv0H5CVF0uOAqA7/E3AhAo0Zu+et4
	M7QBiuC4U/mdlWpcpg+fZgkCx11ZsFhcNiTxFXWVHWpxfpE5LLfB8zRmRDUnYI/w17V82ouPyCP
	QmJzoFzgKV5UVMrFHUuVwdjJtRJLuTDEzturWmUZo6/WAy1jw/8ypv0+p2Fyr4jzELSx6aYdlsS
	ev18Fdd6H3Oy7MH7GW7Hl0NUcC8A4fCNGdf5q35qVkstj+qc819mG5c3I5hv4NMQDbVhBKHwZvz
	8VjZSwW9UIb
X-Received: by 2002:a05:651c:b12:b0:3a6:4739:2008 with SMTP id 38308e7fff4ca-3a9a2a72bbcmr6039921fa.0.1791390536151;
        Wed, 07 Oct 2026 09:28:56 -0700 (PDT)
Received: from localhost (soda.int.kasm.eu. [2001:678:a5c:1202:7b92:9ac1:b9ef:5287])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a9a1d7648esm7724511fa.26.2026.10.07.09.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 09:28:53 -0700 (PDT)
Date: Wed, 7 Oct 2026 18:28:52 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, nphamcs@gmail.com, baohua@kernel.org, 
	youngjun.park@lge.com, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Subject: Re: [PATCH v4 00/14] mm, swap: extendable swap devices (xswap phase
 I)
Message-ID: <asZt7-8mcxqc1a02@soda.int.kasm.eu>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261003003136.750633-1-hebaoquan@kylinos.cn>
X-Rspamd-Queue-Id: 6A8702000E
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: secu5uod61o7xzhy6tr5t189hfx6bwe3
X-HE-Tag: 1791390538-160740
X-HE-Meta: U2FsdGVkX19oXfL8iHvBxvg52L1n68RJwFvTHvjZPg7/d8hObhidqTJ/lxq5onynd3lFCYWxeUO5LH4iCVGs55GkE6DattrD7Rdhai5nFUwE5Z3OLxETNjv1nEBvL6Nr4H1PWDpbm9HuptR9fkS2RwFO19ArxWJ0CwfTp4hWvBYTMJo/5wEZahzfEeSdXJt2HM6mVwFsLhalq6NYUdJNrzhUm771UUqHBHaS7XW/f3sSZiUkonFi4Jm1/m/OlKuQLoakzEIuzJSzwkrumy9hnyk3mdnOSuK2A0no9uh1uPphJWOUgYaTyBaUrdeED/XFuocHEENrQ/kN7hl7aM7NQsirCwqwRjsjXISgOz6eIVhv0UBR3EtQVlaO0mBS0Oxig84KB+d5sEh3D+JwTDHHh2BFokaV7OHBQqs/wG54sy8g7p06AiKxenCFEYX7VNWBFQaPb2JFjtS7vDQLYtacXJRlboc9GMr+I0e1orfZd/PjsKlO5teMA2bcDGTobVCIqLUbMLyowC+y+dvf/aDbUeet5ppAi5ZH1KLMxuj/Pg3C3VfL80ZoWzB8nEANdDj3EKk9gPi/Lg/YZqVWzPQmyxGGvqptNm5pglrKcy1Y4a7s2AJy9M1nRlsjsLhKrFVp7pxgiB8tEAQFeC3DRvVw6EJyCSzjGsVinXX9khCM4OunuwScq2tF2jeVUxvczZ/uTr9MR8l6WbHWn2lsbyGGhzbE2HC62z/a/OPMwUFgVMKHUOdL3BJhH+VJkJIwe0HMxrEZoigqofvRQ+xh4pI7og4VhrACoU0sNqrDS/MiCEzo0DjEog6qI0jj/mO7xn7rpxxgZSBn95PC9fLdZ5+Caupxpf/FuT7RkocB3I+gr4LcW5gioosqp0/rQgOa0eW56F+7KbKmY/jM9RWuOulGqCvwFAP6cqWqmrZSgZbSIZ77Si3QnrkIn3kPQ8fsSwb1zor1PqYYIVUGs2EfJ0A
 GSvIdeEq
 mehyZclyRjP0dCHZpIZxyaUp4TgDzCz7EiOTDBYj+VwmTvHscIiUxTAwq/00/68ZN3/A5i00CcMM8EiqI7AlulAQF5g3ojDJBz8rrS7ONphwq032E1G4nmq8raNANVeTl74wbgDITj+t0KQArTb6G6HK6cVqVRj8PhH3iruphNsV4rd9jZwb4fviXlIazoADxv0GblDPMz6ikuTFoYiZobJuUwGhZ1xR9P8viV8nl1GKSBu4vfZLRWBzhYYqxrF9HXzLXxlnha6NZ71o/P79u3tKcYUiF7x27bVEBe4/xjF7j81yoht9LT5mXzzlebtW/niGS+kxW4QAyTH8N28zHUQgwnz+dibnnw4GQSMbuIM25QLLk1sqqwap1X698UijvN/t7kqgz5onPJP5qwUtPDwGJRDq4X4i0Zh5HMB8kNjZSAo4jnuuXTxCpFdqXm9e8jOMRd6zBwTVFDDK2Bzu6fprZu1Ln16Xbu5JoePFUTsKyecNivp0f6Y06KHS81gVolCsJUYLggr1pf0iN8U+h5ruHfxrXzCrbMaup7DFltCP+0PnMgCS7HaW8F1dgvHtXJkdQ7/H6MMmwJiK5TG/QwTiKFQ16ICJSPbBy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-10-03 08:31:22 +0800, Baoquan He wrote:
> A normal swap device has a fixed size, set when it is enabled. This
> does not fit zswap well. With zswap, the swapped data stays in RAM in
> compressed form. So how much swap a machine can really use depends on
> how well the workload compresses. It does not depend on a number we
> pick before we know the workload. If we make the device large enough
> for the worst case, most of it is never used. If we make it just large
> enough for the average case, the machine runs out of swap while zswap
> still has free room.
> 
> xswap is a swap device with no backing file. Its swap entries hold pages
> in zswap, and its cluster_info array lives in a VM_SPARSE area that is
> mapped a chunk at a time, so the device covers a large address space
> while costing only the chunks it has actually used. The device grows as
> the workload needs it and gives the tail back when it does not.
> 
> This series is the device itself: the sparse cluster array, growth and
> shrink, and the interfaces that create and destroy one. It is phase I
> of three; the physical backend and the swap accounting builds on it.
> 
> Design notes
> ------------
> 
> The device is only an address space. si->max is set when the device is
> created and does not move for its lifetime; what moves is how much of it
> is mapped. It defaults to twice RAM, and xswap.max= sets another size at
> boot, in bytes or as a percentage of RAM:
> 
>   xswap.max=8G          8 GiB
>   xswap.max=300%        three times RAM
> 
> That is a boot parameter but not a runtime knob because the address space
> cannot move once the device exists; it is fixed at creation and every
> mapped index stays valid for the device's life. swap_info_struct carries
> nr_clusters_max (the address space) and nr_clusters_mapped (the mapped
> prefix), and the two walkers that touch cluster_info are bounded by the
> latter.
> 
> Growth starts when 85% of the mapped range is in use. The call comes from
> cluster_alloc_swap_entry(). Growing maps pages into the VM_SPARSE area.
> Mapping can sleep, so it cannot be done inside the allocation that would
> otherwise fail. If it were, the swap-out path would have nothing to fall
> back on.
> 
> Shrink gives the free tail back when the mapped range is at most 50% in
> use. It is triggered when a cluster becomes completely free. Shrinking on
> a smaller drop is not useful. Growth happens on demand, so the same
> clusters would just be mapped again, and each unmap also costs an RCU
> grace period.
> 
> A file-less device has no swapon, so /sys/kernel/mm/xswap/create makes
> one and destroy takes its swap type. The teardown is shared with
> sys_swapoff() rather than duplicated.
> 
> The only argument create takes is a priority. The size comes from
> xswap.max= at boot, so there is one place to ask for a size and one to
> ask for a priority, and a priority can be given per device while a size
> cannot:
> 
>   # echo > /sys/kernel/mm/xswap/create          default priority
>   # echo 100 > /sys/kernel/mm/xswap/create      priority 100
> 

> The default is the highest priority, SWAP_FLAG_PRIO_MASK. An xswap
> device is then the first one tried, ahead of any ordinary swap device.
> Setting a lower priority is allowed.

Nice, this is now a good default which the user should not have to
change.

> 
> The device does not move once it exists, so the address space cannot be
> changed from this interface either. xswap.max= at boot and this together
> are the whole configuration.
> 
> The device needs zswap. Without it swapout takes a swap entry and frees
> no memory, so creating one fails.
> 
> Testing
> -------
> 
> qemu KVM guest, 8G RAM, booted with xswap.max=10G. memhog is a small
> local helper: it faults <total_gb> of anon, fills it with a fixed
> pattern, and holds it.
> 
> Set up zswap and create a device:
> 
>   # echo 1 > /sys/module/zswap/parameters/enabled
>   # echo > /sys/kernel/mm/xswap/create
>   # awk 'NR == 1 || /xswap/' /proc/swaps
>   Filename                Type        Size        Used        Priority
>   xswap0                  xswap       10485756    0           32767
>   # cat /sys/kernel/debug/xswap/type0
>   clusters_max 5120
>   clusters_mapped 73
>   usage_pages 0
>   tail_free 72
>   grows 0
>   shrinks 0
> 
> Swap 9G of anon through a 2G cgroup:
> 
>   # mkdir -p /sys/fs/cgroup/xswap_limit
>   # echo 2G > /sys/fs/cgroup/xswap_limit/memory.max
>   # echo max > /sys/fs/cgroup/xswap_limit/memory.swap.max
>   # ( echo $BASHPID > /sys/fs/cgroup/xswap_limit/cgroup.procs
>   #   exec env MEMHOG_FILL=pattern numactl --cpunodebind=0 \
>   #       ./memhog 9 600 ) &
> 
> clusters_mapped grows to cover the pages that go to zswap, while
> SwapTotal stays at 10485756. Throughout, SwapTotal never moves and
> SwapFree stays in [0, SwapTotal]. Pushing past the size leaves the
> cgroup out of room and the OOM killer takes the workload, which is the
> pass signal there.
> 
> Growth and shrink, measured with two cgroups so that one keeps its pages
> while the other goes away:
> 
>   idle                           mapped=73    occ=0.000  grows=0   shrinks=0
>   2G in a 1G cgroup              mapped=803   occ=0.737  grows=8   shrinks=0
>   3G more in a second 1G cgroup  mapped=2190  occ=0.777  grows=13  shrinks=0
>   kill the second cgroup         mapped=876   occ=0.675  grows=13  shrinks=1
> 
> The second cgroup is started later, so its clusters sit at the tail, and
> killing it leaves a free tail to take back. The first stays alive, so
> usage falls but not to zero: that is the state the shrink has to land in.
> occ is usage over the mapped range, which is what the grow and shrink
> thresholds are expressed in.
> 
>   # echo 0 > /sys/kernel/mm/xswap/destroy
> 
> Also tested things as below, and nothing crashed or warned:
> 
>   - a shrink racing a swapoff of the same device, 20 rounds
>   - a cgroup that cannot zswap: it must get no xswap slot, and the
>     allocator walk must not spin
>   - a create/destroy cycle: it must not leak per-cluster state
> 

> Open items
> ----------
> 
> - xswap_create() sets si->pages to the whole address space (twice RAM by
>   default) and _enable_swap_info() adds it to nr_swap_pages and
>   total_swap_pages, which is what __vm_enough_memory() uses for
>   overcommit. That raises the commit limit by 2xRAM for a device whose
>   real capacity is bounded by the zswap pool and by how well the workload
>   compresses. The question is which semantics overcommit should follow:
>   worst-case backing, or the address space.
> 
> - destroy takes a bare swap type. The type is an internal index that
>   alloc_swap_info() recycles as soon as SWP_USED clears, so a value read
>   earlier can name a different device by the time it is written. The
>   swapoff ABI uses a path for this reason. It wants a generation or
>   another stable handle.
> 
> - The new interfaces (/sys/kernel/mm/xswap/create and destroy, xswap.max=,
>   the new type string in /proc/swaps) are not documented yet.

To me it feels a bit weird to have the interface split between a kernel
parameter and sysfs, meaning I have to configure this in two places now.
As far as I gather, there's also nothing that needs the limit to be
fixed at boot since it is applied at creation. If we want to expose this
limit to users (as xswap does) it would be nice to have a 'max'
shorthand for tha largest possible value, i.e. SWAPFILE_CLUSTER *
UNIT_MAX (or whatever it might be in the future). That would I guess in
practice give the same behaviour as vm.overcommit_memory=1 which might
or might not be desirable.

> 
> Changelog
> =========
> v3 -> v4:
> - Rebased onto the latest mm-new.
> 
> - Add boot parameter xswap.max= .
> 
> - The device has one size now: set at creation, fixed, with xswap.max= to
>   ask for another one at boot. v3's runtime ceiling, the per-device limit,
>   the clamp it wrote and the shrink to that ceiling are all gone as
>   Johannes suggested (v3's patches 12, 13 and 14).
> 
> - v3's patches 2 and 4 are the new patch 3: neither builds a device
>   alone. It also bounds find_next_to_unuse() and wait_for_allocation(),
>   which walked up to si->max past the mapped range. Chris suggested
>   this.
> 
> - New patches 11 to 13: a cgroup that cannot zswap is not given an xswap
>   slot, swap_info_struct max and pages are unsigned long, and debugfs
>   counters for the mapped range and the grow and shrink counts.
> 
> - v3's patches 1 and 3, and 5 to 11, are unchanged; the merge shifts them
>   to 1 and 2, and 4 to 10.
> 
> - Minor comment and cleanup changes.
> 
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
> RFC v3 -> RFC v2
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
>   mm, swap: refactor free_swap_cluster_info to take swap_info_struct
>   mm, swap: back the cluster_info array with a sparse VM_SPARSE area
>   mm, swap: add sysfs create interface for xswap
>   mm, swap: add xswap grow trigger on cluster allocation
>   mm, swap: add xswap_try_shrink and shrink trigger on cluster free
>   mm, swap: free backing pages in xswap_unmap_clusters
>   mm, swap: defer xswap shrink to workqueue to avoid lock recursion
>   mm, swap: refactor swapoff and add xswap_destroy
>   mm, swap: require zswap for xswap devices
>   mm, swap: do not give an xswap slot to a cgroup that cannot zswap
>   mm, swap: widen swap_info_struct max/pages to unsigned long
>   mm, swap: add debugfs counters for xswap
>   mm, swap: let the command line set the xswap device size
> 
> Chris Li (1):
>   mm: xswap support for zswap
> 
>  include/linux/swap.h |   16 +-
>  mm/Kconfig           |    9 +
>  mm/page_io.c         |   19 +
>  mm/swap_state.c      |    9 +
>  mm/swapfile.c        | 1221 +++++++++++++++++++++++++++++++++++++++---
>  mm/zswap.c           |   11 +-
>  6 files changed, 1205 insertions(+), 80 deletions(-)
> 
> 
> base-commit: 9a0542b19a541eda3f82934ee747c61ec3f18847
> -- 
> 2.54.0
> 

