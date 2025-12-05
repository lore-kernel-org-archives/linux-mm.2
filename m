Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22088D2A538
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 03:01:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6054F6B00F0; Thu,  4 Dec 2025 22:01:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DD1C6B00F1; Thu,  4 Dec 2025 22:01:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3866B00F2; Thu,  4 Dec 2025 22:01:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3649D6B00F0
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:01:31 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD6C913AC89
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 03:01:30 +0000 (UTC)
X-FDA: 84183916740.02.286DE5E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf11.hostedemail.com (Postfix) with ESMTP id 02E9740004
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 03:01:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gQ2if6pp;
	spf=pass (imf11.hostedemail.com: domain of yi1.lai@linux.intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=yi1.lai@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764903688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z49d2sSPaifw8qEtAtNeuX9C0Rm+Wpr8wYopooyoOGQ=;
	b=439g0umC1XAowhbCJ3qxwCYeWJgx66Yb0znPnAklxWVF4exyFc64I57XyPXOJdRDCK/aY6
	XGN9Sg2Tu3vg1FRjKQHUe8iek0OG8K/xGETPEy8EaVFC9NfUCv71vSruhjp01cOA3PHAFv
	OUH9VFzF7B73WJ7Bgnil2rk/J+XuXVg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gQ2if6pp;
	spf=pass (imf11.hostedemail.com: domain of yi1.lai@linux.intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=yi1.lai@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764903688; a=rsa-sha256;
	cv=none;
	b=rRz9WTF5advSOIO9BxJE59HeSlpMswDptlXExw2kx9z2UbWqWgxxJfesyfvMA2zCZgYWfa
	OJsauDKg42FbC9Wp7c7N19U81uOmPrD9yBFbu4Kgc4I2G1sA/OrIPmWPdcgwhr25vb3BrV
	62U9VuncDuojP0rFkYrThHQLGhS03OQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764903688; x=1796439688;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yydnK4B+mUnUHIRa9kX07yGS50HOffFBhTHN0wxFYHg=;
  b=gQ2if6ppRtoYgj1uKAQxUz9paL+TZfjhPQjnB4FOciWvAPQlJKVRI6DU
   25fd1HzuDHJW24h7UiBnqcg7DG8P4errcekssyONIYmmeaybYuLXpKYEL
   mN3y4PZFCOxwcIz06kpkwIZHQGZIkMlRv0S73QsvRz4KmB9DoRmlJQdut
   sGSkSS4IWm+r1o/rHJGqT29FpTnQIOZrz0uAQMxRopA6KRDlwSXaauGlL
   fIBLuQPHpn1OkFnIWz1Up95MP2LiBJOoE0UVO/bqi74OufG8mQr8Yi2pi
   tywXHj33ECjcXa2dzunwYl2CQ2R2iJufG9rbzCo5NEHQ6pl2wF9RAc1nX
   Q==;
X-CSE-ConnectionGUID: rExnkifDQ3yya547mM5SRA==
X-CSE-MsgGUID: u6AfKLr3QBSqFiZJgDcR2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="78047625"
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="78047625"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 19:01:27 -0800
X-CSE-ConnectionGUID: mAa2lJHxRduXVHZSdCWf+A==
X-CSE-MsgGUID: TI4CPpxMS16xEOjWBAKSfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="194451732"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 19:01:24 -0800
Date: Fri, 5 Dec 2025 11:01:20 +0800
From: "Lai, Yi" <yi1.lai@linux.intel.com>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, hch@infradead.org, djwong@kernel.org,
	willy@infradead.org, brauner@kernel.org, yi1.lai@intel.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH v5 5/7] xfs: fill dirty folios on zero range of unwritten
 mappings
Message-ID: <aTJLAFyYBtW47r5Q@ly-workstation>
References: <20251003134642.604736-1-bfoster@redhat.com>
 <20251003134642.604736-6-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003134642.604736-6-bfoster@redhat.com>
X-Rspamd-Queue-Id: 02E9740004
X-Rspamd-Server: rspam02
X-Stat-Signature: a9o1u7nh8j3pgncjdnqqksrz9gg1otyo
X-Rspam-User: 
X-HE-Tag: 1764903687-122832
X-HE-Meta: U2FsdGVkX18X7fZa0lxkXZfD29ga57PKiIhAM9Nna6WIyvW5e4/+AEXfiqjbfYyPWGVaFWNQtOXW9FNYoOXkY8/kGSXs77gLljFQT3XloScKiFA9/5ybCJ3lGDFm8LKYwRxGDNRCVYTj3KPga5CZlYRnL1ht3CcjVjWir7hRr7PKXlb5qEgYQNlK9LOe0zQoK2f4LfHcuO718Wi0fvdY72ZeA3NfrFcINyL8A1yF/VqCLMdB1y2mOJ5U7MT/5ZEAlH2nMXMzCyeH6VJ20HHQEef6p43Qcgh5LaQJDVoyFpq8obukE0F1SrryapAHOADsIwtCdNZ0zeE00VrOYz36DjTQ/Yxt5vaIZLiFQzheEHFHneukzN3LSKDxb+EudmxLmkQ+t80YhLA6/TowaJWby+06m6wEJ8nRrUqkbCd1ehQb1HsqVHd6BnsyN1c48w8Otmk3cOs2LftjCp3N9Rfu+T7nGjnJSBl0GKjOBjIeDapgR8HqXxGYyihTx4H3jI6Liws5OvRZ3+vHbvyzNlT1WrKDDBmuaaYmxqI/yF0GpEfbpBP4IpwHrZF5qX9ONukttGILwFPa2IhYSIhxiwdbcRVdaqFXVQjgAHhnMSvEIRysEVdIYI7zcmIMa3rQwjdrSFOHnF1wp4Hoaofwjm0kTxGfs8JAM0Lfc3wD6+qs65zCNrJozkd9xN3zI6Zqz7CN73QSTWDCdAriyQEelZ0nzQ/W7Dbj7p45kzyaxXD4syiBHqgGkLQMjjz/32lgo4b/5QEuMjLhDZyCh0md0aHCCs3uTWFg3AkrOh1ZPkI61wa5CVS2QMgt8bPvL1VUtAEspn/VzikPdcJqb/EtI1Imp4TVRnsCWUvXBxRpqWitueddhZt5VrMNfGOdCviacNBsC8oZBh+vIZXzX2yEBkUDfgre/ASrA7B/ntqdyykbKb0kzrWqpMIZydSqZK7HM+81NomDQFWnMEz3nlPriHy
 Va2uM8hn
 HZau+KKenFCaWzIVy0B2NUpaTbG+YgKNcENOxMEXGqAgqcYAkwOdPPKVGVULAIsaQ/QxGBxsjhFtbhM9RAvvvrJkthwKoRfVBf/o+6MGGPaIQ92pmnwoV8UwInI94j/m1tpqGwKJqsH57z/zWK8X4ftyCqsy+sKYGSMRY/5oBoBxojW1caBu8MLMZaA+TJ8GSmYAnvPwYsVwy0ZYEswkkImmbqUfrw249Crhz7frg4p6X7Hj+sRkMWkYzmvXUU5kslGd+x2Tyd7EcX4nD+b1FD3VPB2Pgp9ticgVhjg/FqGsve5/TSaO+m6rwnZEY4qGLIb3ldAaMAUIfvSopcTFLhZ/wcVl6TqIdqOAx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 09:46:39AM -0400, Brian Foster wrote:
> Use the iomap folio batch mechanism to select folios to zero on zero
> range of unwritten mappings. Trim the resulting mapping if the batch
> is filled (unlikely for current use cases) to distinguish between a
> range to skip and one that requires another iteration due to a full
> batch.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_iomap.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 6a05e04ad5ba..535bf3b8705d 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1702,6 +1702,8 @@ xfs_buffered_write_iomap_begin(
>  	struct iomap		*iomap,
>  	struct iomap		*srcmap)
>  {
> +	struct iomap_iter	*iter = container_of(iomap, struct iomap_iter,
> +						     iomap);
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
>  	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
> @@ -1773,6 +1775,7 @@ xfs_buffered_write_iomap_begin(
>  	 */
>  	if (flags & IOMAP_ZERO) {
>  		xfs_fileoff_t eof_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
> +		u64 end;
>  
>  		if (isnullstartblock(imap.br_startblock) &&
>  		    offset_fsb >= eof_fsb)
> @@ -1780,6 +1783,26 @@ xfs_buffered_write_iomap_begin(
>  		if (offset_fsb < eof_fsb && end_fsb > eof_fsb)
>  			end_fsb = eof_fsb;
>  
> +		/*
> +		 * Look up dirty folios for unwritten mappings within EOF.
> +		 * Providing this bypasses the flush iomap uses to trigger
> +		 * extent conversion when unwritten mappings have dirty
> +		 * pagecache in need of zeroing.
> +		 *
> +		 * Trim the mapping to the end pos of the lookup, which in turn
> +		 * was trimmed to the end of the batch if it became full before
> +		 * the end of the mapping.
> +		 */
> +		if (imap.br_state == XFS_EXT_UNWRITTEN &&
> +		    offset_fsb < eof_fsb) {
> +			loff_t len = min(count,
> +					 XFS_FSB_TO_B(mp, imap.br_blockcount));
> +
> +			end = iomap_fill_dirty_folios(iter, offset, len);
> +			end_fsb = min_t(xfs_fileoff_t, end_fsb,
> +					XFS_B_TO_FSB(mp, end));
> +		}
> +
>  		xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
>  	}
>  
> -- 
> 2.51.0
>
 
Hi Brian Foster,

Greetings!

I used Syzkaller and found that there is possible deadlock in xfs_ilock in linux-next next-20251203.

After bisection and the first bad commit is:
"
77c475692c5e xfs: fill dirty folios on zero range of unwritten mappings
"

All detailed into can be found at:
https://github.com/laifryiee/syzkaller_logs/tree/main/251204_221645_xfs_ilock
Syzkaller repro code:
https://github.com/laifryiee/syzkaller_logs/tree/main/251204_221645_xfs_ilock/repro.c
Syzkaller repro syscall steps:
https://github.com/laifryiee/syzkaller_logs/tree/main/251204_221645_xfs_ilock/repro.prog
Syzkaller report:
https://github.com/laifryiee/syzkaller_logs/tree/main/251204_221645_xfs_ilock/repro.report
Kconfig(make olddefconfig):
https://github.com/laifryiee/syzkaller_logs/tree/main/251204_221645_xfs_ilock/kconfig_origin
Bisect info:
https://github.com/laifryiee/syzkaller_logs/tree/main/251204_221645_xfs_ilock/bisect_info.log
bzImage:
https://github.com/laifryiee/syzkaller_logs/raw/refs/heads/main/251204_221645_xfs_ilock/bzImage_b2c27842ba853508b0da00187a7508eb3a96c8f7
Issue dmesg:
https://github.com/laifryiee/syzkaller_logs/blob/main/251204_221645_xfs_ilock/b2c27842ba853508b0da00187a7508eb3a96c8f7_dmesg.log

"
[   21.088994] ======================================================
[   21.089362] WARNING: possible circular locking dependency detected
[   21.089726] 6.18.0-next-20251203-b2c27842ba85 #1 Not tainted
[   21.090060] ------------------------------------------------------
[   21.090417] kswapd0/58 is trying to acquire lock:
[   21.090697] ffff888028ff1f18 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_ilock+0x30f/0x390
[   21.091235]
[   21.091235] but task is already holding lock:
[   21.091575] ffffffff8784b580 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0xb7e/0x15c0
[   21.092058]
[   21.092058] which lock already depends on the new lock.
[   21.092058]
[   21.092524]
[   21.092524] the existing dependency chain (in reverse order) is:
[   21.092949]
[   21.092949] -> #1 (fs_reclaim){+.+.}-{0:0}:
[   21.093290]        fs_reclaim_acquire+0x116/0x160
[   21.093579]        __kmalloc_cache_noprof+0x53/0x7e0
[   21.093886]        iomap_fill_dirty_folios+0x118/0x2c0
[   21.094204]        xfs_buffered_write_iomap_begin+0xf18/0x2150
[   21.094552]        iomap_iter+0x551/0xf40
[   21.094798]        iomap_zero_range+0x20b/0xa90
[   21.095075]        xfs_zero_range+0xb5/0x100
[   21.095335]        xfs_reflink_remap_prep+0x3d3/0xa90
[   21.095643]        xfs_file_remap_range+0x23c/0xdc0
[   21.095944]        vfs_clone_file_range+0x2b1/0xda0
[   21.096243]        ioctl_file_clone+0x6e/0x110
[   21.096521]        do_vfs_ioctl+0xcab/0x14d0
[   21.096786]        __x64_sys_ioctl+0x127/0x220
[   21.097057]        x64_sys_call+0x1280/0x21b0
[   21.097331]        do_syscall_64+0x6d/0x1180
[   21.097607]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   21.097936]
[   21.097936] -> #0 (&xfs_nondir_ilock_class){++++}-{4:4}:
[   21.098334]        __lock_acquire+0x14d1/0x2210
[   21.098615]        lock_acquire+0x170/0x2f0
[   21.098869]        down_write_nested+0x9a/0x210
[   21.099145]        xfs_ilock+0x30f/0x390
[   21.099385]        xfs_icwalk_ag+0xaec/0x1b60
[   21.099652]        xfs_icwalk+0x56/0xc0
[   21.099892]        xfs_reclaim_inodes_nr+0x1d3/0x2d0
[   21.100192]        xfs_fs_free_cached_objects+0x6a/0x90
[   21.100506]        super_cache_scan+0x415/0x570
[   21.100794]        do_shrink_slab+0x408/0x1030
[   21.101069]        shrink_slab+0x348/0x12f0
[   21.101329]        shrink_node+0xacc/0x2670
[   21.101587]        balance_pgdat+0xa2d/0x15c0
[   21.101860]        kswapd+0x5b9/0xab0
[   21.102093]        kthread+0x464/0x980
[   21.102329]        ret_from_fork+0x780/0x8f0
[   21.102596]        ret_from_fork_asm+0x1a/0x30
[   21.102873]
[   21.102873] other info that might help us debug this:
[   21.102873]
[   21.103335]  Possible unsafe locking scenario:
[   21.103335]
[   21.103683]        CPU0                    CPU1
[   21.103955]        ----                    ----
[   21.104225]   lock(fs_reclaim);
[   21.104428]                                lock(&xfs_nondir_ilock_class);
[   21.104823]                                lock(fs_reclaim);
[   21.105158]   lock(&xfs_nondir_ilock_class);
[   21.105416]
[   21.105416]  *** DEADLOCK ***
[   21.105416]
[   21.105762] 2 locks held by kswapd0/58:
[   21.105993]  #0: ffffffff8784b580 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0xb7e/0x15c0
[   21.106487]  #1: ffff88800fd580e0 (&type->s_umount_key#53){.+.+}-{4:4}, at: super_cache_scan+0x9f/0x570
[   21.107047]
[   21.107047] stack backtrace:
[   21.107307] CPU: 1 UID: 0 PID: 58 Comm: kswapd0 Not tainted 6.18.0-next-20251203-b2c27842ba85 #1 PREEMPT(volu
[   21.107319] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.q4
[   21.107326] Call Trace:
[   21.107335]  <TASK>
[   21.107338]  dump_stack_lvl+0xea/0x150
[   21.107352]  dump_stack+0x19/0x20
[   21.107359]  print_circular_bug+0x283/0x350
[   21.107370]  check_noncircular+0x12d/0x150
[   21.107383]  __lock_acquire+0x14d1/0x2210
[   21.107398]  lock_acquire+0x170/0x2f0
[   21.107407]  ? xfs_ilock+0x30f/0x390
[   21.107420]  ? __cond_resched+0x37/0x50
[   21.107434]  down_write_nested+0x9a/0x210
[   21.107445]  ? xfs_ilock+0x30f/0x390
[   21.107456]  ? __pfx_down_write_nested+0x10/0x10
[   21.107468]  ? xfs_icwalk_ag+0xadf/0x1b60
[   21.107482]  ? xfs_icwalk_ag+0xaec/0x1b60
[   21.107497]  ? xfs_icwalk_ag+0xaec/0x1b60
[   21.107510]  xfs_ilock+0x30f/0x390
[   21.107523]  xfs_icwalk_ag+0xaec/0x1b60
[   21.107542]  ? __pfx_xfs_icwalk_ag+0x10/0x10
[   21.107561]  ? __pfx_xa_find+0x10/0x10
[   21.107581]  ? xfs_group_grab_next_mark+0x26a/0x520
[   21.107605]  ? __this_cpu_preempt_check+0x21/0x30
[   21.107616]  ? lock_release+0x14f/0x2a0
[   21.107628]  ? xfs_group_grab_next_mark+0x274/0x520
[   21.107643]  ? __pfx_xfs_group_grab_next_mark+0x10/0x10
[   21.107662]  ? __pfx_try_to_wake_up+0x10/0x10
[   21.107678]  ? lock_release+0x14f/0x2a0
[   21.107689]  xfs_icwalk+0x56/0xc0
[   21.107704]  xfs_reclaim_inodes_nr+0x1d3/0x2d0
[   21.107718]  ? __pfx_xfs_reclaim_inodes_nr+0x10/0x10
[   21.107734]  ? __this_cpu_preempt_check+0x21/0x30
[   21.107744]  ? __pfx_prune_icache_sb+0x10/0x10
[   21.107762]  xfs_fs_free_cached_objects+0x6a/0x90
[   21.107777]  super_cache_scan+0x415/0x570
[   21.107794]  do_shrink_slab+0x408/0x1030
[   21.107813]  shrink_slab+0x348/0x12f0
[   21.107831]  ? shrink_slab+0x160/0x12f0
[   21.107845]  ? __pfx_shrink_slab+0x10/0x10
[   21.107866]  shrink_node+0xacc/0x2670
[   21.107888]  ? __pfx_shrink_node+0x10/0x10
[   21.107900]  ? preempt_schedule_common+0x49/0xd0
[   21.107913]  balance_pgdat+0xa2d/0x15c0
[   21.107929]  ? __pfx_balance_pgdat+0x10/0x10
[   21.107941]  ? rcu_watching_snap_stopped_since+0x20/0xf0
[   21.107975]  kswapd+0x5b9/0xab0
[   21.107990]  ? __pfx_kswapd+0x10/0x10
[   21.108002]  ? _raw_spin_unlock_irqrestore+0x35/0x70
[   21.108017]  ? trace_hardirqs_on+0x26/0x130
[   21.108040]  ? __pfx_autoremove_wake_function+0x10/0x10
[   21.108060]  ? __sanitizer_cov_trace_const_cmp1+0x1e/0x30
[   21.108080]  ? __kthread_parkme+0x1bc/0x260
[   21.108094]  ? __pfx_kswapd+0x10/0x10
[   21.108107]  ? __pfx_kswapd+0x10/0x10
[   21.108120]  kthread+0x464/0x980
[   21.108128]  ? __pfx_kthread+0x10/0x10
[   21.108135]  ? trace_hardirqs_on+0x26/0x130
[   21.108149]  ? _raw_spin_unlock_irq+0x3c/0x60
[   21.108158]  ? __pfx_kthread+0x10/0x10
[   21.108167]  ret_from_fork+0x780/0x8f0
[   21.108177]  ? __pfx_ret_from_fork+0x10/0x10
[   21.108186]  ? native_load_tls+0x16/0x50
[   21.108199]  ? __sanitizer_cov_trace_const_cmp8+0x1c/0x30
[   21.108213]  ? __switch_to+0x823/0x10b0
[   21.108232]  ? __pfx_kthread+0x10/0x10
[   21.108240]  ret_from_fork_asm+0x1a/0x30
[   21.108257]  </TASK>
[   21.592826] repro: page allocation failure: order:0, mode:0x10cc0(GFP_KERNEL|__GFP_NORETRY), nodemask=(null),0
[   21.593533] CPU: 1 UID: 0 PID: 727 Comm: repro Not tainted 6.18.0-next-20251203-b2c27842ba85 #1 PREEMPT(volun
[   21.593545] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.q4
[   21.593551] Call Trace:
[   21.593554]  <TASK>
[   21.593557]  dump_stack_lvl+0x121/0x150
[   21.593572]  dump_stack+0x19/0x20
[   21.593582]  warn_alloc+0x216/0x360
[   21.593595]  ? __pfx_warn_alloc+0x10/0x10
[   21.593607]  ? __pfx___alloc_pages_direct_compact+0x10/0x10
[   21.593618]  ? __drain_all_pages+0x27d/0x480
[   21.593628]  __alloc_pages_slowpath.constprop.0+0x1340/0x2230
[   21.593644]  ? __pfx___alloc_pages_slowpath.constprop.0+0x10/0x10
[   21.593657]  ? __might_sleep+0x108/0x160
[   21.593680]  __alloc_frozen_pages_noprof+0x47f/0x550
[   21.593690]  ? asm_sysvec_apic_timer_interrupt+0x1f/0x30
[   21.593702]  ? __pfx___alloc_frozen_pages_noprof+0x10/0x10
[   21.593716]  ? policy_nodemask+0xf9/0x450
[   21.593734]  alloc_pages_mpol+0x236/0x4c0
[   21.593746]  ? __pfx_alloc_pages_mpol+0x10/0x10
[   21.593758]  ? alloc_frozen_pages_noprof+0x48/0x180
[   21.593766]  ? alloc_frozen_pages_noprof+0x51/0x180
[   21.593775]  alloc_frozen_pages_noprof+0xa9/0x180
[   21.593783]  alloc_pages_noprof+0x27/0xa0
[   21.593791]  kimage_alloc_pages+0x78/0x240
[   21.593809]  kimage_alloc_control_pages+0x1ca/0xa60
[   21.593819]  ? __pfx_kimage_alloc_control_pages+0x10/0x10
[   21.593827]  ? __sanitizer_cov_trace_cmp8+0x1c/0x30
[   21.593844]  do_kexec_load+0x39b/0x8c0
[   21.593851]  ? __might_fault+0xf1/0x1b0
[   21.593868]  ? __pfx_do_kexec_load+0x10/0x10
[   21.593876]  ? __sanitizer_cov_trace_const_cmp8+0x1c/0x30
[   21.593887]  ? _copy_from_user+0x75/0xa0
[   21.593904]  __x64_sys_kexec_load+0x1cc/0x240
[   21.593913]  x64_sys_call+0x1c90/0x21b0
[   21.593922]  do_syscall_64+0x6d/0x1180
[   21.593930]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   21.593938] RIP: 0033:0x7f347b83ee5d
[   21.593952] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 88
[   21.593959] RSP: 002b:00007ffc6cb1d938 EFLAGS: 00000207 ORIG_RAX: 00000000000000f6
[   21.593972] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f347b83ee5d
[   21.593977] RDX: 0000200000000180 RSI: 0000000000000003 RDI: 0000000000000000
[   21.593982] RBP: 00007ffc6cb1d950 R08: 00007ffc6cb1d3c0 R09: 00007ffc6cb1d950
[   21.593986] R10: 0000000000000000 R11: 0000000000000207 R12: 00007ffc6cb1daa8
[   21.593991] R13: 00000000004030f5 R14: 000000000040ee08 R15: 00007f347bb26000
[   21.594000]  </TASK>
"

Hope this cound be insightful to you.

Regards,
Yi Lai

---

If you don't need the following environment to reproduce the problem or if you
already have one reproduced environment, please ignore the following information.

How to reproduce:
git clone https://gitlab.com/xupengfe/repro_vm_env.git
cd repro_vm_env
tar -xvf repro_vm_env.tar.gz
cd repro_vm_env; ./start3.sh  // it needs qemu-system-x86_64 and I used v7.1.0
  // start3.sh will load bzImage_2241ab53cbb5cdb08a6b2d4688feb13971058f65 v6.2-rc5 kernel
  // You could change the bzImage_xxx as you want
  // Maybe you need to remove line "-drive if=pflash,format=raw,readonly=on,file=./OVMF_CODE.fd \" for different qemu version
You could use below command to log in, there is no password for root.
ssh -p 10023 root@localhost

After login vm(virtual machine) successfully, you could transfer reproduced
binary to the vm by below way, and reproduce the problem in vm:
gcc -pthread -o repro repro.c
scp -P 10023 repro root@localhost:/root/

Get the bzImage for target kernel:
Please use target kconfig and copy it to kernel_src/.config
make olddefconfig
make -jx bzImage           //x should equal or less than cpu num your pc has

Fill the bzImage file into above start3.sh to load the target kernel in vm.


Tips:
If you already have qemu-system-x86_64, please ignore below info.
If you want to install qemu v7.1.0 version:
git clone https://github.com/qemu/qemu.git
cd qemu
git checkout -f v7.1.0
mkdir build
cd build
yum install -y ninja-build.x86_64
yum -y install libslirp-devel.x86_64
../configure --target-list=x86_64-softmmu --enable-kvm --enable-vnc --enable-gtk --enable-sdl --enable-usb-redir --enable-slirp
make
make install 


