Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60365CA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 06:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7026C6B008C; Fri,  9 Oct 2026 02:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D97F6B0093; Fri,  9 Oct 2026 02:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C95B6B0095; Fri,  9 Oct 2026 02:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 323096B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:47:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9DCC71C2721
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:47:02 +0000 (UTC)
X-FDA: 85302155484.08.E61BE10
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0C1A220006
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:46:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IxGUEkQZ;
	spf=pass (imf03.hostedemail.com: domain of yi1.lai@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791528420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EDoi2zeGSoCCP4PR7jZxDJ9dlHobjbr1BAN3l4O7S5s=;
	b=D/Ja+TvxiTQbxOL+uI5cQT0GAhVELY6nvc/7FxKO99bnYunNKTi/bvJSuVBxIwhaskmqHy
	VzfnKNFLTfQZOxdFzOEr7HIVnI4l59tzYgIyyQ+XfxWLsyJN3Q/qsRmxuV9N7Vk/bSmPsn
	kDRo7GlzXVLhFchmUX/M0jErVS24VI4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IxGUEkQZ;
	spf=pass (imf03.hostedemail.com: domain of yi1.lai@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791528420;
	b=2ZAHwxU/h4in+DEz1dixKG5SpcqSEv0SFQnjI0UsVZqJ5xlqNZlAhV/XpoTCq1RFCwzjA5
	oDwf7H67FhGIMSpQVr9ow8PSWZhTZsSTB+FIZyqjzWP3aZrTK/sXwdpZsWyhLib3+uLnOk
	sqyDWKM6MspRFcZvTxew1qBBS5/oj5o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791528420; x=1823064420;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=OV1RtSHRUR+p3unHrNMGAioLnCcUOrOo/GFrRLcJj1E=;
  b=IxGUEkQZDJDxYt00xENYleQoNhQc5p07AtbRC/bKJ3Dq9LQq1TlKnWAP
   IdW3DnznoGudxVfc4wfVJY0AXpwN2EosFIAH6e4E3Ok67Bnw5wrDIbGcj
   TqyCGAKn8uz+JCgtpfCTw94+87F6lSESV29mcqMPiPEw8qZmVRP/wxOcn
   BYxWpPvxMozbrNakQ+drNs8TAaT7HeUYvENxBds7Enl+uw2sROZfwNJJt
   IBSdM1+/+rawKKQ3ehxOg7VpcbMwpndnPmL0RSjQPTeW6DLHPijHNVnwP
   vYTeX5SByQ4hEzGXO2Uiug/uN2klI9GpvN6uLiXS/hvMK4SCE9u1V7uxO
   w==;
X-CSE-ConnectionGUID: mzXzEIcCSFyDuJnhUREt7Q==
X-CSE-MsgGUID: 5jgSH1g8Qmu4G9vYbZDuwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11929"; a="326053"
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="326053"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 23:46:58 -0700
X-CSE-ConnectionGUID: 2UBBvTA4SomBEUvsnjbmbg==
X-CSE-MsgGUID: PZRFGWHdSYqq260r7G/Rsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="2060061"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 23:46:54 -0700
Date: Fri, 9 Oct 2026 14:46:51 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Qinyun Tan <qinyuntan@linux.alibaba.com>, linux-mm@kvack.org,
	yi1.lai@intel.com
Subject: [linux-next:master] [mm]  b9b1861d4f:
 WARNING:possible_circular_locking_dependency_detected
Message-ID: <202610091403.d1d8080b-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0C1A220006
X-Rspam-User: 
X-Stat-Signature: 3tm5f15oq9gdsy1f1fqeh49ocwiatztq
X-HE-Tag: 1791528419-920964
X-HE-Meta: U2FsdGVkX19OgpttiXIW3i56Y4QCNOdIFUJ/uWzZEweVcxXF8cQHUKXIsRfytkHzWOh/SYXOHGpUvJhLJ0GtLHc5Gep8MtV6sKPhK4f9L6K5gZfXD0QI7bMdZXldeNOgd+AgOOecKm1b5qTuiTAXw3Ty3JPOpOHJUesFWfZZhULLXzz9xOfPQ7tl5N+6bYPT1ypmnbPaE1wS1g5fuV2syFmVvmkYsWWaSQF2vp8SFHOGWT3TfKFeXPawfKExIliK3MMi6+aXPTlB9XdM9Q4BknBZdgJlXlO/ficwv2H2vOcW4hsYJyFyapnrUIV8Njc1cKl7y3bZY8JlwOYaIz+tAhU/fmE327E0WHxJ0MUMqWhr9ohjCs5OC8R44KOX9WFv+kA4lxmFh4yJ20JzCkO7JkicxgxmrJFJ5fmeEglKvHknrporWnxFIV2lrLzTnICActk+k7uKPxb2tzxo+1Na8M1S0mKQin/wMZ8ex5OYBgiChXuu43ZBBqy1OH9OiyK7wOZD9ZlzA19A9x5uUW8FUn4GXpKrJ6cv8inO3zQOiZz5y1TtMoqBqKRC0wTRj/LGS698NRQjBB7Ir5idqKY48/cnyb/MEcIIEhPFW8b5Bqm1/dvk5HdVG2Pt6BULlnRx/5J+lA9CciP5zLpqhIgdQX7saI9OZvVXnJleVHVJ13c23vz6Xv5ZsLJPHvjJNfbIGkP1wSKdLu857+dn4QQtw6k1oUQa4lhofFHzXqw6LlHx1+Epmg2lGCEiJ/yPLt5xzbZHFzv7p89XYlkgPTPOC6cDj17N9+OLgeXgK9DFfVXT4PAjyNdKKAV0zaRadqOlmFafzix9yrthW6aR+/Gx4HOPymNu5ynod7TPLF7gniw73wVog0irakgFOVhLl64JlA85PYMKtKBiRV+c2GMzxnr4/CPupwmfEFpypeS1AL2PLFqg6QD9Xtg3nhZVnX3NA0V98cypjZGmZ4Mc4s/
 SVKM0m9W
 pWXrpZ19vKRL02CzNljoiBF2aE0KCEfamEqCUbYgGvUYQ+rdlsljztrdBk38Fo/iG9ScQ4fZmv/nOlss4S1hZcc0bubGpEyeMFQ0k6S567K4V5dVvRkzJRZJ6i7rSY6MaJeGI7TXyFx8iYrqo0PKiH58BQVzp4O5EQuPeg9UkMNGPvev1ntR1thpngATRuWMRdWcjQqnrgG23mkajpxMptQOMKgkwK9Z4Vgfml4UpWE0sWW4hEEtLTcaKNEsIT3eDrKHs+J6Bwj7Ht9i0+lnDmMKrqI/Y8owM/925a4I6dKp27OVOXtZtAxsFeSndotAmxt6UUofHsjCTSIfBeTb3TXXW8ROLnzTOrCStRsL5KXlgEln4jsDG6Ol66w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "WARNING:possible_circular_locking_dependency_detected" on:

commit: b9b1861d4f7ae63b15228c744d504a86ab48a5a2 ("mm: shmem: make unused huge shrinker memcg aware") https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master f5f84daefcd92d7a630066635ecea1433ed5eac7]

in testcase: boot

config: i386-randconfig-053-20260902
compiler: clang-22
test machine: qemu-system-i386 -enable-kvm -cpu SandyBridge -smp 4 -m 4G

(please refer to attached dmesg/kmsg for entire log/backtrace)

If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202610091403.d1d8080b-lkp@intel.com

[   64.638596][  T203] ======================================================
[   64.643742][  T203] WARNING: possible circular locking dependency detected
[   64.649127][  T203] 7.3.0-rc4+ #1 Not tainted
[   64.652392][  T203] ------------------------------------------------------
[   64.657842][  T203] systemd-udevd/203 is trying to acquire lock:
[   64.663589][  T203] f5835900 (&sb->s_type->i_lock_key){+.+.}-{3:3}, at: igrab+0x44/0xc0
[   64.669221][  T203]
[   64.669221][  T203] but task is already holding lock:
[   64.669221][  T203]
[   64.669221][  T203] but task is already holding lock:
[   64.669221][  T203]
[   64.669221][  T203] but task is already holding lock:
[   64.674183][  T203] f5c5a61c (&l->lock){+.+.}-{3:3}, at: __list_lru_walk_one+0x55/0x180
[   64.679737][  T203]
[   64.679737][  T203] which lock already depends on the new lock.
[   64.679737][  T203]
[   64.679737][  T203] which lock already depends on the new lock.
[   64.679737][  T203]
[   64.679737][  T203] which lock already depends on the new lock.
[   64.679737][  T203]
[   64.686427][  T203]
[   64.686427][  T203] the existing dependency chain (in reverse order) is:
[   64.686427][  T203]
[   64.686427][  T203] the existing dependency chain (in reverse order) is:
[   64.686427][  T203]
[   64.686427][  T203] the existing dependency chain (in reverse order) is:
[   64.691963][  T203]
[   64.691963][  T203] -> #2 (&l->lock){+.+.}-{3:3}:
[   64.691963][  T203]
[   64.691963][  T203] -> #2 (&l->lock){+.+.}-{3:3}:
[   64.691963][  T203]
[   64.691963][  T203] -> #2 (&l->lock){+.+.}-{3:3}:
[   64.695874][  T203]        _raw_spin_lock+0x26/0x40
[   64.699072][  T203]        list_lru_add_obj+0x3c/0xc0
[   64.702561][  T203]        d_lru_add+0x40/0x80
[   64.705640][  T203]        fast_dput+0x1c7/0x200
[   64.708794][  T203]        dput+0x25/0x40
[   64.711603][  T203]        pick_link+0x1ed/0x340
[   64.714612][  T203]        step_into_slowpath+0x1af/0x200
[   64.718143][  T203]        path_lookupat+0x109/0x1c0
[   64.721512][  T203]        filename_lookup+0xc1/0x200
[   64.725044][  T203]        user_path_at+0x2f/0xc0
[   64.728522][  T203]        __ia32_sys_mount+0x134/0x1c0
[   64.732025][  T203]        ia32_sys_call+0x39/0x14c0
[   64.735800][  T203]        __do_fast_syscall_32+0x16c/0x340
[   64.740069][  T203]        do_fast_syscall_32+0x28/0x80
[   64.743715][  T203]        do_SYSENTER_32+0x12/0x40
[   64.747337][  T203]        entry_SYSENTER_32+0x98/0xfd
[   64.750971][  T203]
[   64.750971][  T203] -> #1 (&lockref->lock){+.+.}-{3:3}:
[   64.750971][  T203]
[   64.750971][  T203] -> #1 (&lockref->lock){+.+.}-{3:3}:
[   64.750971][  T203]
[   64.750971][  T203] -> #1 (&lockref->lock){+.+.}-{3:3}:
[   64.756528][  T203]        _raw_spin_lock+0x26/0x40
[   64.760072][  T203]        d_instantiate+0x34/0x80
[   64.763562][  T203]        d_make_root+0x29/0x40
[   64.766867][  T203]        shmem_fill_super+0x292/0x340
[   64.770617][  T203]        get_tree_nodev+0x3e/0x80
[   64.774112][  T203]        shmem_get_tree+0x12/0x40
[   64.777728][  T203]        vfs_get_tree+0x1e/0xc0
[   64.781170][  T203]        vfs_kern_mount+0x6e/0xc0
[   64.784747][  T203]        kern_mount+0x16/0x40
[   64.787998][  T203]        shmem_init+0x26/0x100
[   64.791525][  T203]        mnt_init+0xfd/0x140
[   64.794594][  T203]        vfs_caches_init+0x26/0x40
[   64.798341][  T203]        start_kernel+0x2df/0x380
[   64.801707][  T203]        i386_start_kernel+0xc5/0x100
[   64.805611][  T203]        startup_32_smp+0x151/0x160
[   64.809276][  T203]
[   64.809276][  T203] -> #0 (&sb->s_type->i_lock_key){+.+.}-{3:3}:
[   64.809276][  T203]
[   64.809276][  T203] -> #0 (&sb->s_type->i_lock_key){+.+.}-{3:3}:
[   64.809276][  T203]
[   64.809276][  T203] -> #0 (&sb->s_type->i_lock_key){+.+.}-{3:3}:
[   64.815036][  T203]        __lock_acquire+0x1851/0x2a40
[   64.818649][  T203]        lock_acquire+0x96/0x200
[   64.821879][  T203]        _raw_spin_lock+0x26/0x40
[   64.825139][  T203]        igrab+0x44/0xc0
[   64.828067][  T203]        shmem_unused_huge_isolate+0x2e/0xc0
[   64.832099][  T203]        __list_lru_walk_one+0x98/0x180
[   64.835960][  T203]        list_lru_walk_node+0x1b/0x40
[   64.839660][  T203]        shmem_unused_huge_shrink+0x62/0x500
[   64.843880][  T203]        shmem_alloc_and_add_folio+0x1b8/0x480
[   64.847901][  T203]        shmem_get_folio_gfp+0x1af/0x880
[   64.851755][  T203]        shmem_write_begin+0x5c/0x100
[   64.855571][  T203]        generic_perform_write+0xc1/0x340
[   64.859545][  T203]        shmem_file_write_iter+0x5f/0x80
[   64.863719][  T203]        vfs_write+0x263/0x340
[   64.867230][  T203]        ksys_write+0x6a/0x100
[   64.870798][  T203]        __ia32_sys_write+0x18/0x40
[   64.874740][  T203]        ia32_sys_call+0x1365/0x14c0
[   64.878135][  T203]        __do_fast_syscall_32+0x16c/0x340
[   64.881546][  T203]        do_fast_syscall_32+0x28/0x80
[   64.885606][  T203]        do_SYSENTER_32+0x12/0x40
[   64.889087][  T203]        entry_SYSENTER_32+0x98/0xfd
[   64.892908][  T203]
[   64.892908][  T203] other info that might help us debug this:
[   64.892908][  T203]
[   64.892908][  T203] other info that might help us debug this:
[   64.892908][  T203]
[   64.892908][  T203] other info that might help us debug this:
[   64.892908][  T203]
[   64.900253][  T203] Chain exists of:
[   64.900253][  T203]   &sb->s_type->i_lock_key --> &lockref->lock --> &l->lock
[   64.900253][  T203]
[   64.900253][  T203] Chain exists of:
[   64.900253][  T203]   &sb->s_type->i_lock_key --> &lockref->lock --> &l->lock
[   64.900253][  T203]
[   64.900253][  T203] Chain exists of:
[   64.900253][  T203]   &sb->s_type->i_lock_key --> &lockref->lock --> &l->lock
[   64.900253][  T203]
[   64.909551][  T203]  Possible unsafe locking scenario:
[   64.909551][  T203]
[   64.909551][  T203]  Possible unsafe locking scenario:
[   64.909551][  T203]
[   64.909551][  T203]  Possible unsafe locking scenario:
[   64.909551][  T203]
[   64.915049][  T203]        CPU0                    CPU1
[   64.918939][  T203]        ----                    ----
[   64.922808][  T203]   lock(&l->lock);
[   64.925634][  T203]                                lock(&lockref->lock);
[   64.930586][  T203]                                lock(&l->lock);
[   64.934913][  T203]   lock(&sb->s_type->i_lock_key);
[   64.938686][  T203]
[   64.938686][  T203]  *** DEADLOCK ***
[   64.938686][  T203]
[   64.938686][  T203]  *** DEADLOCK ***
[   64.938686][  T203]
[   64.938686][  T203]  *** DEADLOCK ***
[   64.938686][  T203]
[   64.944491][  T203] locks held by systemd-udevd/203: 4, last CPU#0:
[   64.949046][  T203]  #0: f5c50a6c (sb_writers#6){.+.+}-{0:0}, at: vfs_write+0xb7/0x340
[   64.954944][  T203]  #1: f5655658 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: shmem_file_write_iter+0x28/0x80
[   64.962274][  T203]  #2: f5c5a61c (&l->lock){+.+.}-{3:3}, at: __list_lru_walk_one+0x55/0x180
[   64.968148][  T203]  #3: f5835810 (&info->lock){+.+.}-{3:3}, at: shmem_unused_huge_isolate+0x1f/0xc0
[   64.974409][  T203]
[   64.974409][  T203] stack backtrace:
[   64.974409][  T203]
[   64.974409][  T203] stack backtrace:
[   64.974409][  T203]
[   64.974409][  T203] stack backtrace:
[   64.978786][  T203] CPU: 0 UID: 0 PID: 203 Comm: systemd-udevd Not tainted 7.3.0-rc4+ #1 PREEMPT  2f9698b0cc81084abb5f3c5754f76765d21e2bf0
[   64.987668][  T203] Call Trace:
[   64.990012][  T203]  __dump_stack+0x18/0x40
[   64.993281][  T203]  dump_stack_lvl+0x20/0x40
[   64.996699][  T203]  dump_stack+0xd/0x12
[   64.999644][  T203]  print_circular_bug+0x2bf/0x300
[   65.003228][  T203]  check_noncircular+0xd7/0x100
[   65.006753][  T203]  __lock_acquire+0x1851/0x2a40
[   65.009733][  T203]  ? _raw_spin_unlock_irqrestore+0x20/0x80
[   65.013953][  T203]  lock_acquire+0x96/0x200
[   65.017236][  T203]  ? igrab+0x44/0xc0
[   65.020072][  T203]  _raw_spin_lock+0x26/0x40
[   65.023308][  T203]  ? igrab+0x44/0xc0
[   65.025972][  T203]  igrab+0x44/0xc0
[   65.028647][  T203]  shmem_unused_huge_isolate+0x2e/0xc0
[   65.032472][  T203]  __list_lru_walk_one+0x98/0x180
[   65.035619][  T203]  ? shmem_unused_huge_shrink+0x500/0x500
[   65.039875][  T203]  list_lru_walk_node+0x1b/0x40
[   65.043576][  T203]  ? shmem_unused_huge_shrink+0x500/0x500
[   65.047582][  T203]  shmem_unused_huge_shrink+0x62/0x500
[   65.051774][  T203]  ? shmem_inode_acct_blocks+0x218/0x280
[   65.055593][  T203]  shmem_alloc_and_add_folio+0x1b8/0x480
[   65.059093][  T203]  shmem_get_folio_gfp+0x1af/0x880
[   65.062996][  T203]  shmem_write_begin+0x5c/0x100
[   65.066769][  T203]  generic_perform_write+0xc1/0x340
[   65.070595][  T203]  shmem_file_write_iter+0x5f/0x80
[   65.074058][  T203]  vfs_write+0x263/0x340
[   65.077047][  T203]  ? shmem_file_read_iter+0x400/0x400
[   65.081058][  T203]  ksys_write+0x6a/0x100
[   65.084028][  T203]  __ia32_sys_write+0x18/0x40
[   65.087227][  T203]  ia32_sys_call+0x1365/0x14c0
[   65.090769][  T203]  __do_fast_syscall_32+0x16c/0x340
[   65.094701][  T203]  ? do_fast_syscall_32+0x28/0x80
[   65.098687][  T203]  do_fast_syscall_32+0x28/0x80
[   65.102284][  T203]  do_SYSENTER_32+0x12/0x40
[   65.105857][  T203]  entry_SYSENTER_32+0x98/0xfd
[   65.109406][  T203] EIP: 0xa7fbbc4c
[   65.112302][  T203] Code: c0 74 05 c1 e9 0c 89 08 31 c0 5e 5d 31 c9 31 d2 c3 90 90 90 90 90 90 90 90 90 90 90 90 90 8d 76 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 58 b8
[   65.127608][  T203] EAX: ffffffda EBX: 00000010 ECX: 0238cb60 EDX: 00000023
[   65.133201][  T203] ESI: 00000023 EDI: 0238cb60 EBP: 0238a5e0 ESP: afef94f0
[   65.138647][  T203] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00200246


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20261009/202610091403.d1d8080b-lkp@intel.com

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



