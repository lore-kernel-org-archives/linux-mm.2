Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C833606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 05:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 253656B08F3; Wed, 25 Nov 2026 00:37:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 203666B08F4; Wed, 25 Nov 2026 00:37:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 117106B08F5; Wed, 25 Nov 2026 00:37:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BECCE6B08F3
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:37:33 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25F4F160D29
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:37:33 +0000 (UTC)
X-FDA: 85472533986.28.FBE5B15
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0699A120005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:37:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf29.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795585051;
	b=IGh26LDQq4U7kJ1ncwdlnUVgc28o9texH8sNPv1SpMDA94xvQAnxROY+J2YoEuuBKiSHJi
	bTkJvOgKdYoQK1SBU6IVmjIOtkH8VVahgL/XRF6SsPTDxz3ZibgQ6NDCgLSsj0e5u40HZi
	mxl1gTgC2HGG69tdXwPoSiR8ztTM+xQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795585051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KExUYFfCttDOz9ZPR8Zh/4+eptBdQsoGj4ZqNQ9Fesc=;
	b=CdLc8MQhSsWhUtldtwR4drlIbuDG6WOMLOHgX7eWsWPIFlxMMkZWNInZR5nF4hP7/QKw2O
	IE0BE7Rl5T/lxR0ldFTJI3A6TgjeUXL9Q+MbvcxBwMmjPvbkXOUSXnBjZAk8RhTcuOd4aU
	M4szb4LrI8ciA8HHPb/rDV/3EDHiSuE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf29.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5C82068AFE; Wed, 25 Nov 2026 06:37:24 +0100 (CET)
Date: Wed, 25 Nov 2026 06:37:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Subject: Re: [PATCH 1/2] mm/shmem: add shmem_backup_folio() helper
Message-ID: <20261125053724.GC20407@lst.de>
References: <20260721174723.1039395-1-matthew.brost@intel.com> <20260722094350.GA1057@lst.de> <amEj8GO4sz1Be5pa@gsse-cloud1.jf.intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amEj8GO4sz1Be5pa@gsse-cloud1.jf.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: 7idddpuhu514a1k93pt89mcj1b4i789s
X-Rspam-User:
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 0699A120005
X-Rspamd-Server: rspam03
X-HE-Tag: 1795585050-972105
X-HE-Meta: U2FsdGVkX1/jFS2Ii7vgNzs1lAZxevf1WSF5uPXPZTk2HgOOdWOsEEDNvLtyqLJ6Y2EzYuyIVU/q/r0OC3sqQAAtDy7O2/jchkpZYxzM8VSNiR9rFdEkz2kiVmVG1zjar3mCm/7u1R9V6gVnx8H4XZR7tuNnHBgRUPn+UJaHwN2vHmcfS7DU9ez0P4L2d8Zqj7QlXD/XQ7EZRWzg3dQ7zMqLF7fZ2CrQKpapASDOEyFn+k+2CG8QkbwD673ajwNDQQXVt/qLWWeWOfZcudBCrJ9rS/B/rspyvUp3OrDgOSF95MAEsPxRX+q7SbfUfVYinuVL44nctfv0vxyvnAUHFdEkNoivFRWV02o7xlg+JBbwht61Xf38lZaQaBhjTh32siK2/HlYPX0rGEcE0WG1xz6nUi8C2669so3Tz9GXFU/nerfAWLVXQRX5lm6/8hY9QUWeY21hNDFgNkIp5ZTFE4vL0CNhIBuK/9f+H3LP8luppKdZcLuQGkRkWjIrV2sdsTh+ivQkDrtiRGvIPR0KQ85Pz9DUHc+CkuZ4S9+TlLMLMc2QmigxyNnJNzsnNrAnMCkAHPXfyn3Tz/frIJrj5h+WPQhd/+xZrXqBiqg466jJ7DG/ctuPnnngu/YhtKCkQ1vbMbIEf1n5APpMjxiSoL7nK7gpFPX+1/ajrNcSMr/5VQZx0crRNBChjpMOJ1+BbmS/ypWn7IGkO8zJj6IjHq/RLmZudOneh3RVA4zstAxEtHwmQq8O4xHbRJflTlUt1EssXWTNuJJpNN0aUZuUiOeo5k2Sih/xMWeZVnNY9nUJgaLe0SmceQbq6Z8p9rqeBLhhLMMxq6OlzDfxeUcpxMeOAEhNktb0umY33SiHPWVkEvWh0nyyEyM+ZR5dr3tusLOEzMXL6DPDdy0fuJ5gLpHhn0IhU3tFJV/Pdx2YPaesG5Wtv5bh/7g6A5Akr3MAKEXce7nlzktvzbOl2P2
 B0YkrN/8
 vXAhBXO8fzJIsv7+40CICiJ9GI3//BkXunfOVtcT/Sd1QORsre7dnNkgtPx7AbMw0l8fdRxkB/T70ZJsmxYHbozQYvM995dwJx112SOTONaOEpoq4ZabM15UVXZ1FJJXXQCld5l9TAtvU41IJ19uX1mKRqPAia+JAQf6ymxKmWMetnqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Just trying to bring this up again as we're having a discussion on
the other shmem abuse in i915, so this reminded me of this discussion
where AFAICS we still haven't made in progress.

On Wed, Jul 22, 2026 at 01:11:28PM -0700, Matthew Brost wrote:
> On Wed, Jul 22, 2026 at 11:43:50AM +0200, Christoph Hellwig wrote:
> > On Tue, Jul 21, 2026 at 10:47:22AM -0700, Matthew Brost wrote:
> > > Add a new generic helper, shmem_backup_folio(), that copies the pages
> > > of an arbitrary source folio into a range of a shmem-backed file,
> > > optionally issuing writeback for each destination folio. It is
> > > extracted from drivers/gpu/drm/ttm's existing shmem-backup loop so
> > > that other subsystems (starting with TTM in a follow-up patch) can
> > > share the same implementation.
> > 
> > Hmm, what is the difference to just doing a ITER_BVEC write with a bvec
> > containing the folio for this the pure write to shmem part of this?
> 
> Thanks for the pointer here. I'm somewhat ignorant of filesystem-related
> details.
> 
> There is slightly less GFP control since kernel reserves can't be dipped
> into for the forward process, but perhaps that doesn't matter. There are
> also slightly different locking chains (more on that below).
> 
> > 
> > You'd probably want a kernel_write_iter helper wrapping
> > __kernel_write_iter for the writecount, but otherwise this sounds
> > like a normal write.
> > 
> 
> I tried writing a `kernel_write_iter()` wrapper around
> __kernel_write_iter() that performs file_start_write()/file_end_write(),
> as suggested by the comment above __kernel_write_iter(), but lockdep
> [1] isn't happy. 
> 
> We have a hard requirement in DRM to shrink under dma-resv locks which
> creates the circle:
> 
> pipe->mutex -> mmap_lock -> dma_resv -> sb_writers -> pipe->mutex
> 
> If I simply export __kernel_write_iter(), bypassing
> file_start_write()/file_end_write() and therefore bypassing sb_writers,
> this seems to work.
> 
> I think this is safe for shmem files, but it's difficult to say with
> 100% certainty given my lack of filesystem knowledge, or whether
> exposing a dangerous low-level bypass function for files would be
> acceptable.
> 
> > We'd want something for the writeback part, preferably a purely
> > range based API to be generic.
> 
> I found filemap_fdatawrite_range for this part.
> 
> Matt
> 
> [1] Lockdep splat:
> 
> [  105.374023] ======================================================
> [  105.375386] WARNING: possible circular locking dependency detected
> [  105.375396] 7.2.0-rc4-xe-01637-g40a493568fe3 #1290 Not tainted
> [  105.375406] ------------------------------------------------------
> [  105.375416] cat/3121 is trying to acquire lock:
> [  105.375425] ffff888105677460 (&pipe->mutex){+.+.}-{3:3}, at: iter_file_splice_write+0xb9/0x550
> [  105.375444]
>                but task is already holding lock:
> [  105.375453] ffff888112889420 (sb_writers#5){.+.+}-{0:0}, at: __do_splice+0xc4/0x180
> [  105.375468]
>                which lock already depends on the new lock.
> 
> [  105.375480]
>                the existing dependency chain (in reverse order) is:
> [  105.375492]
>                -> #3 (sb_writers#5){.+.+}-{0:0}:
> [  105.375503]        kernel_write_iter+0xaa/0x270
> [  105.375513]        ttm_backup_backup_folio+0x95/0x130 [ttm]
> [  105.375529]        ttm_pool_backup+0x376/0x560 [ttm]
> [  105.375541]        ttm_tt_backup+0x32/0x60 [ttm]
> [  105.375552]        ttm_bo_shrink+0x76/0x140 [ttm]
> [  105.375564]        xe_bo_shrink+0x19e/0x290 [xe]
> [  105.375642]        __xe_shrinker_walk+0xfb/0x310 [xe]
> [  105.375803]        xe_shrinker_walk+0x36/0xc0 [xe]
> [  105.375885]        xe_shrinker_scan+0x110/0x1e0 [xe]
> [  105.376067]        do_shrink_slab+0x151/0x6c0
> [  105.376076]        shrink_slab+0x140/0x8b0
> [  105.376083]        drop_slab+0x3e/0x90
> [  105.376092]        drop_caches_sysctl_handler+0x74/0xc0
> [  105.376102]        proc_sys_call_handler+0x16c/0x230
> [  105.376112]        vfs_write+0x3ae/0x560
> [  105.376119]        ksys_write+0x66/0xe0
> [  105.376127]        do_syscall_64+0xca/0x540
> [  105.376136]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [  105.376146]
>                -> #2 (reservation_ww_class_mutex){+.+.}-{3:3}:
> [  105.376159]        __ww_mutex_lock.constprop.0+0xca/0x1960
> [  105.376170]        ww_mutex_lock_interruptible+0x26/0x90
> [  105.376180]        xe_gem_object_mmap+0x1d/0x120 [xe]
> [  105.376241]        drm_gem_mmap_obj+0x6c/0x190 [drm]
> [  105.376417]        drm_gem_mmap+0x44/0xb0 [drm]
> [  105.376446]        __mmap_region+0x8d0/0x10b0
> [  105.376453]        mmap_region+0x157/0x180
> [  105.376459]        do_mmap+0x4fb/0x660
> [  105.376467]        vm_mmap_pgoff+0xae/0x190
> [  105.376473]        ksys_mmap_pgoff+0x15e/0x200
> [  105.376480]        do_syscall_64+0xca/0x540
> [  105.376486]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [  105.376494]
>                -> #1 (&mm->mmap_lock){++++}-{3:3}:
> [  105.376503]        __might_fault+0x4a/0x70
> [  105.376509]        _copy_from_iter+0x4a/0x740
> [  105.376517]        copy_page_from_iter+0x7a/0x100
> [  105.376524]        anon_pipe_write+0x30f/0x7e0
> [  105.376531]        vfs_write+0x43c/0x560
> [  105.376537]        ksys_write+0xbc/0xe0
> [  105.376543]        do_syscall_64+0xca/0x540
> [  105.376549]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [  105.376556]
>                -> #0 (&pipe->mutex){+.+.}-{3:3}:
> [  105.376565]        __lock_acquire+0x13c1/0x2400
> [  105.376573]        lock_acquire+0xcb/0x310
> [  105.376822]        __mutex_lock+0x9d/0x10f0
> [  105.377067]        iter_file_splice_write+0xb9/0x550
> [  105.377311]        do_splice+0x360/0x9f0
> [  105.377551]        __do_splice+0xc4/0x180
> [  105.377786]        __x64_sys_splice+0x89/0x110
> [  105.378022]        do_syscall_64+0xca/0x540
> [  105.378255]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [  105.378500]
>                other info that might help us debug this:
> 
> [  105.379182] Chain exists of:
>                  &pipe->mutex --> reservation_ww_class_mutex --> sb_writers#5
> 
> [  105.379856]  Possible unsafe locking scenario:
> 
> [  105.380297]        CPU0                    CPU1
> [  105.380517]        ----                    ----
> [  105.380736]   rlock(sb_writers#5);
> [  105.380954]                                lock(reservation_ww_class_mutex);
> [  105.381174]                                lock(sb_writers#5);
> [  105.381393]   lock(&pipe->mutex);
> [  105.381609]
>                 *** DEADLOCK ***
> 
> [  105.382240] 1 lock held by cat/3121:
> [  105.382452]  #0: ffff888112889420 (sb_writers#5){.+.+}-{0:0}, at: __do_splice+0xc4/0x180
> [  105.382675]
>                stack backtrace:
> [  105.383108] CPU: 10 UID: 0 PID: 3121 Comm: cat Not tainted 7.2.0-rc4-xe-01637-g40a493568fe3 #1290 PREEMPT(full)
> [  105.383110] Hardware name: Intel Corporation Raptor Lake Client Platform/RPL-S ADP-S DDR5 UDIMM CRB, BIOS RPLSFWI1.R00.5045.A00.2401260733 01/26/2024
> [  105.383111] Call Trace:
> [  105.383111]  <TASK>
> [  105.383112]  dump_stack_lvl+0x82/0xd0
> [  105.383115]  print_circular_bug+0x2d2/0x400
> [  105.383116]  check_noncircular+0x12d/0x150
> [  105.383117]  ? kernel_text_address+0x5b/0xc0
> [  105.383121]  __lock_acquire+0x13c1/0x2400
> [  105.383123]  lock_acquire+0xcb/0x310
> [  105.383124]  ? iter_file_splice_write+0xb9/0x550
> [  105.383126]  __mutex_lock+0x9d/0x10f0
> [  105.383128]  ? iter_file_splice_write+0xb9/0x550
> [  105.383128]  ? _raw_spin_unlock_irqrestore+0x41/0x70
> [  105.383130]  ? iter_file_splice_write+0xb9/0x550
> [  105.383131]  ? __kmalloc_noprof+0x3e0/0x5b0
> [  105.383133]  ? iter_file_splice_write+0xa3/0x550
> [  105.383134]  ? iter_file_splice_write+0xb9/0x550
> [  105.383135]  iter_file_splice_write+0xb9/0x550
> [  105.383138]  do_splice+0x360/0x9f0
> [  105.383139]  __do_splice+0xc4/0x180
> [  105.383141]  __x64_sys_splice+0x89/0x110
> [  105.383142]  do_syscall_64+0xca/0x540
> [  105.383144]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [  105.383145] RIP: 0033:0x5601751088ae
> [  105.383146] Code: 55 48 89 e5 53 49 89 f0 8b 3f 31 db 48 ba 01 00 00 00 00 00 00 00 4d 85 c0 74 3e b8 13 01 00 00 31 f6 45 31 d2 45 31 c9 0f 05 <48> 3d 01 f0 ff ff 0f 9d c1 48 85 c0 40 0f 98 c6 40 84 f1 75 05 49
> [  105.383147] RSP: 002b:00007ffdccdc35f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
> [  105.383148] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00005601751088ae
> [  105.383149] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000009
> [  105.383150] RBP: 00007ffdccdc3600 R08: 000000000000013e R09: 0000000000000000
> [  105.383150] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000a
> [  105.383151] R13: 00007ffdccdd36c0 R14: 00000000001a02ef R15: 00007ffdccdd36d0
---end quoted text---

