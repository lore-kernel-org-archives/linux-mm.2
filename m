Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EAC4CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 09:59:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581E56B0005; Wed, 27 May 2026 05:59:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532FE6B008A; Wed, 27 May 2026 05:59:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448176B008C; Wed, 27 May 2026 05:59:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33ACB6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:59:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D63C31C1B35
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:59:22 +0000 (UTC)
X-FDA: 84812752164.07.BEBD068
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf11.hostedemail.com (Postfix) with ESMTP id 131C240008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:59:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ns20G+K9;
	spf=pass (imf11.hostedemail.com: domain of maarten.lankhorst@linux.intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=maarten.lankhorst@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779875960; a=rsa-sha256;
	cv=none;
	b=srIniIUCN/5YVzNa01Bqjk0WmmokcPr2IsG+zR0xIEBVkrL0FodP1UWoibXfL0N9h2o7hi
	qyGvCu+qP4c7w4CWrkTqg6DiEvoNzio0tmdk9TxiS7Qys6V4oO/rP7F8Rx8wzA6yTJ9HgQ
	3mZPE+KLx2te13ohITzqM/oLUT0qsgI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ns20G+K9;
	spf=pass (imf11.hostedemail.com: domain of maarten.lankhorst@linux.intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=maarten.lankhorst@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779875960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qHnaKaZbsMKV2A1NOBbNKGzImHHNB0bOOc4wcoKVa0o=;
	b=Q21GJT3hiKBm97PZ6OdLnP9+cgN0Cczx7z3h7Ssa+WVo8TsleLf/19OSpzU5eeEPZcibak
	Eco1u6uzQx7Tgjnw8LAn2wwPiYMekE5BQWn3rKzk+ne/fbDBfPEOJTAr39B6mYXP1O+wfY
	C868+nqyIOMM2MRHPkQA4lNOsOZq8cA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779875960; x=1811411960;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3wIvgtNg2kBBklgPZYRB7lSIty8O0DjNPLumA5NPTEk=;
  b=ns20G+K9ppsrsVYYHmwBcFc2YcbY9N1CkB0gDV4CS2puU4+e1kC7wrrL
   tshFMiBKKHkz7ltsKLWzXce/MfXLyYVS//DjijDbJwb/E8RFmQVFHeOGq
   ITo4AXr9jcyfv9LcsaIzjDyq4czs+35/PqX58ljr8WXG8vZot/+3o4AWj
   Y1L3KGBDP9zZPg/yglTUAHzKWc87jeeyGCkYd/+o15/WiaMIagji8MlcE
   aCnHUYzTsbCuc9ZweKkLrjfN/W/+qp8hzcS2CEavNuVK1RjIq2eolr8Ev
   ddeESZfNu0Vx0jmgtm0gkKjBvUC/Q+4KVGOR88ac9V/8zFuuBevxSdVM/
   A==;
X-CSE-ConnectionGUID: ahfWHIUzTeSXTBExtD45BQ==
X-CSE-MsgGUID: CoOmYIYHRCui8661IHBZOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="80733971"
X-IronPort-AV: E=Sophos;i="6.24,171,1774335600"; 
   d="scan'208";a="80733971"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 02:59:19 -0700
X-CSE-ConnectionGUID: laoMbY+VQ0+PTsklcTPaWA==
X-CSE-MsgGUID: UZb0+fmWQ8qpj36fWPA2hA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,171,1774335600"; 
   d="scan'208";a="242024675"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO [10.245.245.58]) ([10.245.245.58])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 02:59:14 -0700
Message-ID: <b3390013-f0de-4e23-a915-23340594fb49@linux.intel.com>
Date: Wed, 27 May 2026 11:58:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH] drm/lease: Limit amount of maximum objects per lease.
To: Andrew Morton <akpm@linux-foundation.org>,
 syzbot <syzbot+5d32c8bd82427f9c77cc@syzkaller.appspotmail.com>
Cc: apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, matthew.brost@intel.com, rakie.kim@sk.com,
 syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, dri-devel@lists.freedesktop.org,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
References: <6a150a33.2b0a0220.185dbd.0005.GAE@google.com>
 <20260526125818.d78b7db78d26df094258f8dd@linux-foundation.org>
Content-Language: en-US
From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
In-Reply-To: <20260526125818.d78b7db78d26df094258f8dd@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 131C240008
X-Stat-Signature: dcj4nby3rg6tq7fgn66i8jjdjiompqjw
X-HE-Tag: 1779875959-32097
X-HE-Meta: U2FsdGVkX19pdHwgb6YW9RKxASRBNjURLjqoexpbSDT81bMQK3ABBhKYzsPBUoXx/5+JUbxOEMF2cTRtc60PP/6RgQadRZGkRvkiz7GPTViUYckhvddkG/Fv2D5woJOt0pzlLtw312VWSmKZ4P07OdmXuraKDfXlRSLh2Cm6CV9uldhyngQkPAy40GoB7qVtAq7AAxd0nYhvD/vRQ+uNSq6HK5pkJdgGb6IrXV059i/hqZOEggoTPpJQG2XGIM9cHaDL7jxu0EzNst4qicT8uBtU2rNmc2F+n5VCENFgawJwXzUi4tVOs8iW/AC4jzizwmTn503Tt0b0n6qFem3JRNaf6coKliurBWI6Kv8F36NwRYq56LHyYCwDJHAzqcI0gARV64n6n7yZvgbtSPW1sCngXIwym54ElmyiNA3sHyHW9xHKO+ExW5EsNicf9pMSe01YfInaTNQqrF5R2F4zgnZFZad889oP/4rTRGflkB0Yu/AqoYr5KgqSBmkdo+6nroJ8SMIBh28B42DWmnheotEeDwtjvfvGx5cPSR5BqauMSIgqbI1DXdAS0mRE+HR+G5V6wabJDcQJtDvDfrn2nxFiK2Xb3LzTbWZfmT1qu2sVF/Q7iT+2VJ48oQxw4UUgb+sYlLr0K1HExRdmQr1Zd2rS++Y1ge601cMw2TEaCR1Fir/xYj3MmvDLHqrF5F+5iwe44HbM+bzSt6dultBm7ikpX6suTB6J9ODNpxDQ3iSJ6Z2je6dk2bwk+tO7e+QUCUR5aViwSuOQG8o6e9XXn9EtfopQjggy/LNiFjKzEofavg4hUMGaM+7Cb7oY/J1ByARIgLU39W5mYOpqzcR/cfMZ2ffAjrWoPxCCqGj8aLesdGILaqsRvqYPRp/hkXGjEvXtg9uV8u9MQ56zyrtfItaWuJ5/YuiBDqh5LyOILiQe8wP1t3Ugfpp2ddyUjUubLEnr0Fe26feMihIDVh1
 vkIcFIao
 QDr2U2X0OqvrPFsE8ChRd2fHBF+L4HhpRBPzuo5HnOjBj/YM6CGh1gAE3sYXymRiX7FuzUQtyyXx9X+pH2UnfXeJsvAYbmBnTddU3OBFVaSO64cKwBVP0lYy8UvlRM6Cbtc16MnlOAI8R30/1eRlC4FryOkxVPSvyTj3KQ/ORSKejrFrtvgY0vqZ+N1IBBowuBZK+kbQ3WD+ceI+c4QKDovt4izOECWWWX0W+g5IJt6kQhCe1M0fss5H0m96f5Nf32CvSZspvVL6p8GNXDS/vYblQxlmGKX9RUr8vDQipDd2gXV78V3yvt4QyPs9c+MqvLrfg4k6fZJ5DxRnSxTSjDjHMxh36tNJusmEIgHLJ3ZYUtXw1lmTcrgMXOiK1ELTmyssJf/CGsuKmM7p3+VlRryg/vCJMZ3m/8jkUL7uvZge0oiJ9fcXJ8S4NYWBMs3USBch+vtXoVa9/nEsQLTpdqcqSSjQCOKUAdm3tVUPBujbfsU/nSKJpk+J4cFXWagtffdeNpooHq4IrP7zdXPVkv0giABQnIEy0snDgfIRGwjP3vn6j44CAlV793NDD7hgf6MMFFa5QIc3hqKzGEAB432seKB31b/ST5PrmbI1+Wz3pBmBkNn9+mo2I/jgO9AN5gaDMMsGHi8FqXGce40lGya6kKiyMhgvTP/3852YmnOdzjTU5lZeDfY6DMpfTXX2NPdKmaKivhe4Np4nYbXo4nw8CRV4Ep4nOEvTWtYuRxHQhGQejff9gOMQI2rGp+vd9f9CbVjH8OAFHAwFBKH65+eK44IreVKbcIs5N+Iq1RZ8wTEihjh2Vb8yyqdF+6OgwTL5/ZAGHz97V4ZNR4/SIV5j9ZdUXoAaXXW/dW+06YTkCYbGolN47FlewaUVUlE+sVulB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey,

Den 2026-05-26 kl. 21:58, skrev Andrew Morton:
> On Mon, 25 May 2026 19:49:23 -0700 syzbot <syzbot+5d32c8bd82427f9c77cc@syzkaller.appspotmail.com> wrote:
> 
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    4cbfe4502e3d Merge tag 'v7.1-rc5-ksmbd-server-fixes' of gi..
>> git tree:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux master
>> console output: https://syzkaller.appspot.com/x/log.txt?x=146c161f980000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=9475bd041c93289
>> dashboard link: https://syzkaller.appspot.com/bug?extid=5d32c8bd82427f9c77cc
>> compiler:       aarch64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
>> userspace arch: arm64
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11026336580000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ab9796580000
> 
> Thanks.
> 
>> Downloadable assets:
>> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/fa3fbcfdac58/non_bootable_disk-4cbfe450.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/e825a08fb48d/vmlinux-4cbfe450.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/55037c053ec3/Image-4cbfe450.gz.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+5d32c8bd82427f9c77cc@syzkaller.appspotmail.com
>>
>> ------------[ cut here ]------------
>> WARNING: mm/page_alloc.c:5202 at __alloc_frozen_pages_noprof+0x734/0x1144 mm/page_alloc.c:5202, CPU#0: syz.2.17/3592
> 
> 	if (WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp))
> 
>> Modules linked in:
>> CPU: 0 UID: 0 PID: 3592 Comm: syz.2.17 Not tainted syzkaller #0 PREEMPT 
>> Hardware name: linux,dummy-virt (DT)
>> pstate: 21402009 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
>> pc : __alloc_frozen_pages_noprof+0x734/0x1144 mm/page_alloc.c:5202
>> lr : alloc_pages_mpol+0x70/0x1a4 mm/mempolicy.c:2490
>> sp : ffff800085d93900
>> x29: ffff800085d93a00 x28: 000000000000000b x27: 0000000000000000
>> x26: 0000000000000000 x25: fcf0000014c00000 x24: 0000000000040dc0
>> x23: 0000000000000000 x22: 0000000000000000 x21: 000000000000000b
>> x20: ffffffffffffffff x19: 0000000000000000 x18: 0000000000000002
>> x17: 0000000000000000 x16: 0000000000000000 x15: 0000000020000200
>> x14: ffff8000828b2000 x13: ffffc1ffc0000000 x12: 0000000000000001
>> x11: 0000000000000000 x10: ffff800082b6f4e8 x9 : 0000000000000000
>> x8 : 0000000000000030 x7 : ffff800082e9b430 x6 : 0000000000000001
>> x5 : 0000000000000000 x4 : f3f00000065c90c0 x3 : 0000000000000000
>> x2 : 0000000000000000 x1 : 0000000000000001 x0 : ffff800082dfd000
>> Call trace:
>>  __alloc_frozen_pages_noprof+0x734/0x1144 mm/page_alloc.c:5202 (P)
>>  alloc_pages_mpol+0x70/0x1a4 mm/mempolicy.c:2490
>>  alloc_frozen_pages_noprof+0x48/0xd4 mm/mempolicy.c:2561
>>  ___kmalloc_large_node+0x11c/0x13c mm/slub.c:5237
>>  __kmalloc_large_node_noprof mm/slub.c:5268 [inline]
>>  __do_kmalloc_node mm/slub.c:5284 [inline]
>>  __kmalloc_noprof+0x450/0x560 mm/slub.c:5308
>>  kmalloc_noprof include/linux/slab.h:954 [inline]
>>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>>  fill_object_idr drivers/gpu/drm/drm_lease.c:389 [inline]
>>  drm_mode_create_lease_ioctl+0x184/0x93c drivers/gpu/drm/drm_lease.c:521
>>  drm_ioctl_kernel+0xc0/0x130 drivers/gpu/drm/drm_ioctl.c:804
>>  drm_ioctl+0x258/0x580 drivers/gpu/drm/drm_ioctl.c:901
>>  vfs_ioctl fs/ioctl.c:51 [inline]
> 
> Methinks drm_mode_create_lease_ioctl() wants some more arg checking.
> 
> otoh, memdup_user() passes __GFP_NOWARN, so perhaps
> __alloc_frozen_pages_noprof() should be taught to honor that.
> 

A lot of places assume max 32 planes, connectors and crtc's per device.
drm_plane_mask(), drm_connector_mask and drm_crtc_mask are an example.

It wouldn't be too hard to cap it to 96 (or 8 * sizeof(drm_plane_mask(NULL) + ...)
in case it changes. Anything above it will need fixing in a lot of places anyway.

Kind regards,
~Maarten Lankhorst

What about the below?

>>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>>  __se_sys_ioctl fs/ioctl.c:583 [inline]
>>  __arm64_sys_ioctl+0xac/0x104 fs/ioctl.c:583
>>  __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>>  invoke_syscall+0x54/0x10c arch/arm64/kernel/syscall.c:49
>>  el0_svc_common.constprop.0+0x40/0xe0 arch/arm64/kernel/syscall.c:121
>>  do_el0_svc+0x1c/0x34 arch/arm64/kernel/syscall.c:140
>>  el0_svc+0x38/0x140 arch/arm64/kernel/entry-common.c:740
>>  el0t_64_sync_handler+0xa0/0xf0 arch/arm64/kernel/entry-common.c:759
>>  el0t_64_sync+0x1a4/0x1a8 arch/arm64/kernel/entry.S:594
>> ---[ end trace 0000000000000000 ]---
> 
-- >8 --
There's no practical limit currently to the amount of objects inside the lease ioctl.
Limit it to 96 for now, the maximum of plane_mask + crtc_mask + connector_mask.

I believe this is sufficient on all platforms, and fixes the backtrace below.

------------[ cut here ]------------
WARNING: mm/page_alloc.c:5202 at __alloc_frozen_pages_noprof+0x734/0x1144 mm/page_alloc.c:5202, CPU#0: syz.2.17/3592

	if (WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp))

Modules linked in:
CPU: 0 UID: 0 PID: 3592 Comm: syz.2.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: linux,dummy-virt (DT)
pstate: 21402009 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
pc : __alloc_frozen_pages_noprof+0x734/0x1144 mm/page_alloc.c:5202
lr : alloc_pages_mpol+0x70/0x1a4 mm/mempolicy.c:2490
sp : ffff800085d93900
x29: ffff800085d93a00 x28: 000000000000000b x27: 0000000000000000
x26: 0000000000000000 x25: fcf0000014c00000 x24: 0000000000040dc0
x23: 0000000000000000 x22: 0000000000000000 x21: 000000000000000b
x20: ffffffffffffffff x19: 0000000000000000 x18: 0000000000000002
x17: 0000000000000000 x16: 0000000000000000 x15: 0000000020000200
x14: ffff8000828b2000 x13: ffffc1ffc0000000 x12: 0000000000000001
x11: 0000000000000000 x10: ffff800082b6f4e8 x9 : 0000000000000000
x8 : 0000000000000030 x7 : ffff800082e9b430 x6 : 0000000000000001
x5 : 0000000000000000 x4 : f3f00000065c90c0 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000001 x0 : ffff800082dfd000
Call trace:
 __alloc_frozen_pages_noprof+0x734/0x1144 mm/page_alloc.c:5202 (P)
 alloc_pages_mpol+0x70/0x1a4 mm/mempolicy.c:2490
 alloc_frozen_pages_noprof+0x48/0xd4 mm/mempolicy.c:2561
 ___kmalloc_large_node+0x11c/0x13c mm/slub.c:5237
 __kmalloc_large_node_noprof mm/slub.c:5268 [inline]
 __do_kmalloc_node mm/slub.c:5284 [inline]
 __kmalloc_noprof+0x450/0x560 mm/slub.c:5308
 kmalloc_noprof include/linux/slab.h:954 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 fill_object_idr drivers/gpu/drm/drm_lease.c:389 [inline]
 drm_mode_create_lease_ioctl+0x184/0x93c drivers/gpu/drm/drm_lease.c:521
 drm_ioctl_kernel+0xc0/0x130 drivers/gpu/drm/drm_ioctl.c:804
 drm_ioctl+0x258/0x580 drivers/gpu/drm/drm_ioctl.c:901
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __arm64_sys_ioctl+0xac/0x104 fs/ioctl.c:583
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x54/0x10c arch/arm64/kernel/syscall.c:49
 el0_svc_common.constprop.0+0x40/0xe0 arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x1c/0x34 arch/arm64/kernel/syscall.c:140
 el0_svc+0x38/0x140 arch/arm64/kernel/entry-common.c:740
 el0t_64_sync_handler+0xa0/0xf0 arch/arm64/kernel/entry-common.c:759
 el0t_64_sync+0x1a4/0x1a8 arch/arm64/kernel/entry.S:594
---[ end trace 0000000000000000 ]---

Reported-by: syzbot+5d32c8bd82427f9c77cc@syzkaller.appspotmail.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
---
diff --git a/drivers/gpu/drm/drm_lease.c b/drivers/gpu/drm/drm_lease.c
index 5d2cf724cbd7b..9d0ccc8e0274f 100644
--- a/drivers/gpu/drm/drm_lease.c
+++ b/drivers/gpu/drm/drm_lease.c
@@ -486,6 +486,10 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
 	struct drm_file *lessee_priv;
 	int fd = -1;
 	uint32_t *object_ids;
+	static const size_t max_objects =
+		8 * sizeof(drm_crtc_mask(NULL)) +
+		8 * sizeof(drm_plane_mask(NULL)) +
+		8 * sizeof(drm_connector_mask(NULL));
 
 	/* Can't lease without MODESET */
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
@@ -505,6 +509,11 @@ int drm_mode_create_lease_ioctl(struct drm_device *dev,
 	}
 
 	object_count = cl->object_count;
+	if (object_count > max_objects) {
+		drm_dbg_lease(dev, "too many objects (%ld)\n", object_count);
+		ret = -EINVAL;
+		goto out_lessor;
+	}
 
 	/* Handle leased objects, if any */
 	idr_init(&leases);


