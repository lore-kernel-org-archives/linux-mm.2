Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAE5BCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 19:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19A1D6B0088; Tue, 26 May 2026 15:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1719B6B008A; Tue, 26 May 2026 15:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AECB6B008C; Tue, 26 May 2026 15:58:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0000F6B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:58:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9BE10C17F6
	for <linux-mm@kvack.org>; Tue, 26 May 2026 19:58:22 +0000 (UTC)
X-FDA: 84810632844.26.ED6B4D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id D834410000B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 19:58:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vC+5haJr;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779825501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lMQX5cmTdMhyiYzNOAjSjjruf4hIUXjs5/FMA2ixGi8=;
	b=jhtwCYUVTTTv3Q6oHbodPsk18J4BNzf2Eyc7EUGF5BE6rtxgVNC1QTRTgC3fMk1KwcFZ2j
	iHJBQ16c++q8LfbHcy7lIhgSLpJwC8hm3rkI/VG0naWHRTir8MNXnhYlOwgWpaoC1vTPuz
	155aABHCTdS4ktVeST2SmspUEI9zD4A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vC+5haJr;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779825501; a=rsa-sha256;
	cv=none;
	b=26n2c0/a2N9i8hdeqS7t6Wrm0+bJMdFF9RaeCfFNb8xiSjrxB3jGKKy5pn31JzmpukkpyE
	uHNzUV+UE0KThV1P73ahjr8/dFlHwoPgZ4b3bT4O+Ke+NRqk8Au2CtCfGbY8XZo5PoOmS9
	NII66QhkeOSh+Jz4WTLzN9pcnq0a9kE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FA8C60018;
	Tue, 26 May 2026 19:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662251F000E9;
	Tue, 26 May 2026 19:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779825500;
	bh=lMQX5cmTdMhyiYzNOAjSjjruf4hIUXjs5/FMA2ixGi8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=vC+5haJrZXcnYfhXlK6XMFGrf8Pa12esbMowF6KHpRCbwN3adLP+YkMOUmlgJLbPX
	 uEcdIH+WEbpHFRZtlJLmHKci0Rp4HSrsNhDknaSH2SjbtxwE66P0JVpXjys5uvU0BE
	 hzg5G67c9oQ1F744OCJmCB8WNKnTSMwAMGJtxkyw=
Date: Tue, 26 May 2026 12:58:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+5d32c8bd82427f9c77cc@syzkaller.appspotmail.com>
Cc: apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, matthew.brost@intel.com, rakie.kim@sk.com,
 syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, dri-devel@lists.freedesktop.org, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>
Subject: Re: [syzbot] [mm?] WARNING in alloc_frozen_pages_noprof (2)
Message-Id: <20260526125818.d78b7db78d26df094258f8dd@linux-foundation.org>
In-Reply-To: <6a150a33.2b0a0220.185dbd.0005.GAE@google.com>
References: <6a150a33.2b0a0220.185dbd.0005.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dys9jts4d1ek6rskainjtiaiyofbkkpf
X-Rspamd-Queue-Id: D834410000B
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779825500-240967
X-HE-Meta: U2FsdGVkX1/zu9oENUxGmNgO3Jcw/IGl62LqWPWLcD49x4gsa1tEgy5rFUy/VID/jWjFGGL3vNsLLxxuC409LnDxaf5yfBpzNAmv/CGpxSM52ZT18uiWcginheSzFJLrwZZhP5P+hzjsSqVZEpdzclgPwlzBmGQs5YTEAFJmBYjiwTHbMRVau03oeeLqQnT+BpJT5m3crdZA2fksNyi07HPfsnfxJs7qCVAf4hj8+O7vjczsBHFKZoHkdCC0rJsd+yDtdSv1nsVJY0oUuZCvo3TNmhEOPRJQwWfiSTVI8bjd5sQZfY3ge/QHMcFoAy+KUMOG6D8vucfZcRC+WBEQg4CRaGWFD+9MoHHFSjnARE5E3Fft7yEI4UjU3RqYxM67inxwPTfVKLDK9jpNRZJN4WZJWj2AqlCcmC9BS+T99MfSYPAqT4FpB+lErRctzilX/GxCbc5qwlgx+arqTsxZmqfZUYFZQIbQoyMwl2VmPUbUe9wA0qCxIqs9YMkox7BNX1uY6gUMADuI4jvxMH6UtWTaNcrlR0l927odDTilNZ7YKWfBAPw/B4epNYZ9czmtdfoZf+wMnRijrtpRQHngWB3zep1uEPFyNIhRNrkEjink+X9shTOF6awtSs+v4GtWxII3/9tHycmV3h5qOMFDG2+1XA8Ig7oAuinYrQwaCvP3I068a8aIxlQHwFofOhiAwvYbsMocv6W5/3yijVV44BhlUz+X5GEpHnDqqFWsafsS5z8apCT03SZMygs3HG3i7Ndb7z6Fxw8nPJidqzOnn7L5QTO8FcbG+vMBzUpzB8cA9SY993MbeFx/kHTMqK/n/ZD95zSQUD3UkaU9RhOL+pIxiG133ZL6+APgBUL9ooSm6Ap/TsGt33OFvyB/7TwoY0XHLjbtjmhbB12sWLW3LtyG++b++F3RtgyZEbxtwlZG2/bI+wuXwFcKYmXsaz4iyLxvAUOiamjBEmfvNvP
 oLkjfmW5
 TzNaBInDFD0yGyajlOZiNrvDcyWHxlAc+I1NqHx93RBHSFvuWGXO6aNBHVXgQBwXlfGyQHXDDBMDvRPFGsSmcvBzTULMw/NkhFzbhK10EJqx2iMTE/PqyaA8TIPO8he6TmPHJ71KnrCCoVkdHr8PRNC7H5ZJ5btZGK+fnQLd4j9BGqUP3wR/e4XzKlyatlqiZX3sHW0s/GjLhVd95ua8qszJPiK7OYPjaHd/dUHBfEubmDzwV2T/3/IW7KqN3hXXT4KQy9fT6TjwUa6c+VlsuRXrtJrfIBoMafWmw/G3Jp2fzQJPBdnL6MRw/WEPyugTGJ7rwyor9odyIOz6ilo2qFYoWfK4Ubyk3UHjYO3uIkRS/56P8DhsYU/MlcvnLi+Db4x+r4PGlKzkp4KTfS7NvDJTYaaFppqQWRA5DLPgjhvkoB/gIz4gkplJm7XLD9UVl4wB1I+7riQa6BEvfmU4c6GZvj5h6JeFh6aOpMBuXCOpzodzxyWMgpcWB70jlwGcBJpOKtkLsK26jzZBOyCn9IMqcyHjsCJhRhH4PNmsmmJekhcB98FkkxVfJxbTAK1Jfi8kR+fRQqeNk6WC0eU+3wljQcxrc7s1WRBfqN2Xe9+ZQeciwH8OvTe8OuvVfWKOagTGPIDQFvKoTVtomhnFEvyHcEW0CPfE3pn8n3LK9CzEu+Zxx0s1FFIeEf/DZIUROh7qmAYXe/lEJ2JOpKzL4fcyGcE0PTBNcNMcZJA2lhSi+4LZTu89Zx9uawedvKY6FxR6j2AO+WPwtMprMUCUzgfFZsi1lTFhkXhWniE9GNJgsAIxJtwGGhx+K58uVY5e1SSYD6pNnLmUtTjpqUxEmHfqZa7pAwPT654TCLKDeDZDjl8DXAD2v9Kq4a+FAPIF+mXxbfldh5uiFlUF/oJLQOqOkJJW6ouJaYKKTrSJO0Mf6e/KNqWEScVTznBZWRNd0WB7ssNbdA+4AR1T6Khekpaxgfmtj
 fmTXgfjo
 QE8Awi1kwicZOcXWCqM9Qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 19:49:23 -0700 syzbot <syzbot+5d32c8bd82427f9c77cc@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4cbfe4502e3d Merge tag 'v7.1-rc5-ksmbd-server-fixes' of gi..
> git tree:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux master
> console output: https://syzkaller.appspot.com/x/log.txt?x=146c161f980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9475bd041c93289
> dashboard link: https://syzkaller.appspot.com/bug?extid=5d32c8bd82427f9c77cc
> compiler:       aarch64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11026336580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ab9796580000

Thanks.

> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/fa3fbcfdac58/non_bootable_disk-4cbfe450.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/e825a08fb48d/vmlinux-4cbfe450.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/55037c053ec3/Image-4cbfe450.gz.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5d32c8bd82427f9c77cc@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: mm/page_alloc.c:5202 at __alloc_frozen_pages_noprof+0x734/0x1144 mm/page_alloc.c:5202, CPU#0: syz.2.17/3592

	if (WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp))

> Modules linked in:
> CPU: 0 UID: 0 PID: 3592 Comm: syz.2.17 Not tainted syzkaller #0 PREEMPT 
> Hardware name: linux,dummy-virt (DT)
> pstate: 21402009 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> pc : __alloc_frozen_pages_noprof+0x734/0x1144 mm/page_alloc.c:5202
> lr : alloc_pages_mpol+0x70/0x1a4 mm/mempolicy.c:2490
> sp : ffff800085d93900
> x29: ffff800085d93a00 x28: 000000000000000b x27: 0000000000000000
> x26: 0000000000000000 x25: fcf0000014c00000 x24: 0000000000040dc0
> x23: 0000000000000000 x22: 0000000000000000 x21: 000000000000000b
> x20: ffffffffffffffff x19: 0000000000000000 x18: 0000000000000002
> x17: 0000000000000000 x16: 0000000000000000 x15: 0000000020000200
> x14: ffff8000828b2000 x13: ffffc1ffc0000000 x12: 0000000000000001
> x11: 0000000000000000 x10: ffff800082b6f4e8 x9 : 0000000000000000
> x8 : 0000000000000030 x7 : ffff800082e9b430 x6 : 0000000000000001
> x5 : 0000000000000000 x4 : f3f00000065c90c0 x3 : 0000000000000000
> x2 : 0000000000000000 x1 : 0000000000000001 x0 : ffff800082dfd000
> Call trace:
>  __alloc_frozen_pages_noprof+0x734/0x1144 mm/page_alloc.c:5202 (P)
>  alloc_pages_mpol+0x70/0x1a4 mm/mempolicy.c:2490
>  alloc_frozen_pages_noprof+0x48/0xd4 mm/mempolicy.c:2561
>  ___kmalloc_large_node+0x11c/0x13c mm/slub.c:5237
>  __kmalloc_large_node_noprof mm/slub.c:5268 [inline]
>  __do_kmalloc_node mm/slub.c:5284 [inline]
>  __kmalloc_noprof+0x450/0x560 mm/slub.c:5308
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>  fill_object_idr drivers/gpu/drm/drm_lease.c:389 [inline]
>  drm_mode_create_lease_ioctl+0x184/0x93c drivers/gpu/drm/drm_lease.c:521
>  drm_ioctl_kernel+0xc0/0x130 drivers/gpu/drm/drm_ioctl.c:804
>  drm_ioctl+0x258/0x580 drivers/gpu/drm/drm_ioctl.c:901
>  vfs_ioctl fs/ioctl.c:51 [inline]

Methinks drm_mode_create_lease_ioctl() wants some more arg checking.

otoh, memdup_user() passes __GFP_NOWARN, so perhaps
__alloc_frozen_pages_noprof() should be taught to honor that.

>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl fs/ioctl.c:583 [inline]
>  __arm64_sys_ioctl+0xac/0x104 fs/ioctl.c:583
>  __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>  invoke_syscall+0x54/0x10c arch/arm64/kernel/syscall.c:49
>  el0_svc_common.constprop.0+0x40/0xe0 arch/arm64/kernel/syscall.c:121
>  do_el0_svc+0x1c/0x34 arch/arm64/kernel/syscall.c:140
>  el0_svc+0x38/0x140 arch/arm64/kernel/entry-common.c:740
>  el0t_64_sync_handler+0xa0/0xf0 arch/arm64/kernel/entry-common.c:759
>  el0t_64_sync+0x1a4/0x1a8 arch/arm64/kernel/entry.S:594
> ---[ end trace 0000000000000000 ]---


