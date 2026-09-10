Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DF5DC79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 19:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 057636B0098; Thu, 10 Sep 2026 15:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFA6E6B0099; Thu, 10 Sep 2026 15:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC1AC6B009B; Thu, 10 Sep 2026 15:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 955D26B0098
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:35:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC879A52F7
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:35:05 +0000 (UTC)
X-FDA: 85198855770.08.39EE7C7
Received: from mail-oa1-f80.google.com (mail-oa1-f80.google.com [209.85.160.80])
	by imf07.hostedemail.com (Postfix) with ESMTP id EAF0D40007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:35:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3ZgajagkbAFsLRSD3EE7K3IIB6.9HH9E7NL7K5HGM7GM.5HF@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.80 as permitted sender) smtp.mailfrom=3ZgajagkbAFsLRSD3EE7K3IIB6.9HH9E7NL7K5HGM7GM.5HF@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789068904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=Nq7IqBIdgbZsD8ABmIvzn+Awy9fut43M9zz67PnhZZk=;
	b=zg3E3wwfTyi3uFocuL3YmHQ5VkLF37/mNTjWhDwfikpJDbuSN8jMY0qhmx4Xt3xwbOOKzG
	IoDZzDOPGwIIZgqcJNC0uY7NejLP/xlbfmTCkalm+bJMvm6UkTT7zE/4jHiO1ZiRGpwmVc
	D+x6nsm2O6SdS9MkAqPIkNCeOZsXrgE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789068904;
	b=W/Yn6s4xDXuBmYd7IpJqiJf8t9ndLRArBMgpQs8CU0Hv7J4g4bq1QWigBGjIYR1f6YjHwo
	BY5Keha1u1nlILC/bbMTfFCTJnjlN3iGcfBELzJY8S8lzpunO43o85V0F8zLlETeJbmQbc
	uW6ijZUNWF/E3w/3+iHpPF3x83buxVo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3ZgajagkbAFsLRSD3EE7K3IIB6.9HH9E7NL7K5HGM7GM.5HF@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.80 as permitted sender) smtp.mailfrom=3ZgajagkbAFsLRSD3EE7K3IIB6.9HH9E7NL7K5HGM7GM.5HF@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f80.google.com with SMTP id 586e51a60fabf-456b5122c7cso2049900fac.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:35:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789068903; x=1789673703;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Nq7IqBIdgbZsD8ABmIvzn+Awy9fut43M9zz67PnhZZk=;
        b=UVqYBITDYTUiuQ1BB8QIR+COgeKg4uihq/SBqs2iqjTlRdWrVr1IOoYne1GTrH4v/m
         NQKlOwaMVfbS4g4AqHyckOreo5+kZbfaA9GadzqlGHt4lsZIdv1OaN9CVVVwlFU9nUi8
         qnKcFmvm99gK9+eZBloK/n9LUm2+CM7UpPO/1akJ1yi7yiL0KnlaPrvlG3/fEyrDZNt+
         HiBNtxYABlelK2PHpa8YJXBFVafBaYRWv0l1blhxl5PBkKJ3FzTnfmPxTxHXKLra3hr8
         nVNAhg6BnuDGUMFHnSYwULa20La299q5ZvdCxuXguV4g47mWw3/J5Z3RED2V3X5hwDFF
         HSIw==
X-Forwarded-Encrypted: i=1; AKwUvBwR+dQYExEvXU3Qc2E5ApntMTmAa/oRyxYwgUL8CzkHfTADzT4oCdWnLhgmhgwIu1TdqFGx+1fT4Q==@kvack.org
X-Gm-Message-State: AFuF++nmm2fVVYkNMQCmwc/N7I2HAmURXZF33ur1y/jNBFVfmrE0vLCf
	vZTCvVPi/mEjElyC+kCkxtmtommCRiEtVFtwVJIJnFgNXp8Rs/Y3SaZY+d+KUQvqjeybW8E7oZy
	i8Fq+y73Y5W5/Vxo+7rmuHQ0MowaojeFdqOjHmsGr+sGr96qAEb9l1fDuFYs=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:60e:b0:6ba:5f65:6e5c with SMTP id
 006d021491bc7-6bf4786d3a1mr2882836eaf.42.1789068902840; Thu, 10 Sep 2026
 12:35:02 -0700 (PDT)
Date: Thu, 10 Sep 2026 12:35:02 -0700
In-Reply-To: <aqMF_azjzunub9ab@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa30666.f81106d8.2ab401.0012.GAE@google.com>
Subject: Re: [syzbot] [mm?] [cgroups?] inconsistent lock state in
 fs_reclaim_acquire (4)
From: syzbot <syzbot+093e05755c2d99caab91@syzkaller.appspotmail.com>
To: shakeel.butt@linux.dev
Cc: akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-usb@vger.kernel.org, 
	mhocko@kernel.org, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EAF0D40007
X-Stat-Signature: yp41mjg5s7ep7imhe3gr1dxaf4gdhnxp
X-Rspam-User: 
X-HE-Tag: 1789068903-597949
X-HE-Meta: U2FsdGVkX18nvMuxWvcXBRaJPgH/jfzplQzMko/tIBJ/HG1ESCj/aL8d0zWVgAQ6F4jbBJB6d439C1lg54a7GOGuGnFpMS+bOTVLiP7JO8W/hql+tKnwr4W6tQGhxE6Nl8s1fSwDhIYnPFRqWXqFLwaRL/VauO9qw6Vk1Ej41Hz3ibOXrJOIe6QaqJG2klXM/mt5YoXbUqpQx4A8Ifr1pYj0if0D387R/dklKzW9FF6nvmlmRUfhc4udPw6dL1o59bwUevbnateoEd14bEzbEYkdTFr8UK+J/kvtIMyxh+wfP8SD2KnymH1Qc/KRVfmVwk+Yk9z22kuykcBDWwvsF0988fpgoDBflgIXD9n7KsVoB2LyewD3M5davAqm5FQNgrZUcF5pRKuAaN4iwYgMErmfcHf6DTVfbGlT35OjaTj3/HXrrK5CnqxzkDiBYPl5ZVDRJvEyqTr+sjzH5+DUKIiL4Xtg9prM8xKDjrNpxeB0YH4wIYR8N4ZTr4j7FNdh4ve81aIPYRt1sW292BXyU8yBpJ6Ici4r6VUFPC6W/3jHl/NZWEH6krKK5foujU78IpTpb/E68kQgXuQcTIlpw22PWdpkSwHdukwXqv3eC88bIlAwUImlUFN+fKj1EQTyAfe1bijvm31TOcFLlcN7r3XI+knyPPCjIseXkbyVivcEde7fI9l8Fwin32OG30YyDI0iLX9PJIyvs4M0rU367GsZG5E44TuzPyohR4RR+yPZUx/CCnbkIIMNqalDI02S9An8uZxLzBxQZdGdC+kQp3ufcKynqICld5y8nt4DStPIFhlOdxTTaHsdjQEBLLD0tn1zx4xTvQYxOCLq/fLCjTyFW2IHil18F9wpLCa4nSsV828Fu52Zb6CkJURhTeBXNEWHN1BoUrJ7fSPDThUIzgCqwkIca2ufmxBtrEEYd0w9mrfyjhsL959nLwNcEwwxZ6xLho+8gjuFy8xs26c
 J8W9bk0V
 KxOM3hVqsIzBj+iWQGu0SHbIuS1OWYA8S9/PEBd1it5AsWLOb+ZJcgPXh11ylRnZC/QP5tpdY1IWWuysvLSqhXAo5Wvsxy/JHsFlg1x/05M0dTpfZgZaM5TULUW7xnNpGvrUvpnHEtrlhd0HnJpGRlpTU6kDW3J56ki35unxD/SBZY15B5RntqmRV9m0QI0lsfqlCA+nhuHQfRv4JXokaFLv4dq2npnl4b5jQWYEW2yB5KW1/nWdsxOARfsLgEPbk6i5bhFW3xuz6Jm+qnqJHbQ1TY7DWeVqz2XqWcckAg87OSbceuupUrTRHCcBI0tFALCFKffMa5geyFcxAXMDxUCcFPTi3Ec+W6MA2w/HvFi+A2sx1iqRfL++XqtY69XN8vUOUYUyZ2fkpX8pYRA/5f/Kzbd/5sRWbSclJLNiNJgy0cVAdz7ri3JXvJXNeQDtjmSAw2Y5y45q6wxcGqD05INrHW3GRGRJJWdFYrdkyNQ0PBpW9Nc0RdpRkWcPELSlKqh39YrkGCyHB3tchFGLVVXfoqhetkue2+D9TGh4gUtRHbHN//ZOWE3KQO4Abamcsj8QEcCLtrfuWpQ7H1jMPMXIBFCSc7NojK/hWGzj0eAMdma4I80KXAoNyXC+DJvciALXFgW1LoZs9cDxXNjNlt97lmtLzgX8DNR36TyLKwS6laRyDSLjDeBf5UCwAG8jlGCv+sNxPP01oQZs0GDrXDwvTVM8EXzX2x/FzNFAKhbD7zYA1mwNGqzc4H8SsVVS2998Og83OAcD8yNEaXIluXkKxgvnD+VP3ltzAOzTSubpT903G5vRdSoPprvqZxedkTD/nLWMno+uBWumtONYKmfJzitOEjdjsTteecJQAtrvo2aI8d7SWwRmnemN2doC20ehDwP0Co+/rk7/aKlKsQIgnbtGJh5tmrBmDM6PQv6Sug/jLFlxHF0NjdD0fF2NjaFlOD8J7um0UJEdWmR5oq5CWFNYh
 Qi8aFrYC
 vjFY0jIt8+Cigmd2X96ZbiXTLda0E+OO59JeCcDh3zxdWr5nVyij5wHuIADPijaZdO+BsXGWblA4Z7PaBlVSdutFHtE63lkAL2AJTefYw7Ir2//Ri9Ur+460zb9qnuL5jh8w2YyAJlj/yvBPXwDMwbStzk22fVDA5Zk7IdX+xNLXDYGa7uLypjHng5f2GMhJyUuLbqmlUuVNdPUJvNyjBA66Qhl9tpRDSx/M0p/guDVl8h96WTWBbhjRjVnWB8zP5LzvNjCJMLWIoPUx5ynSg9OT0+747SbQ1kdgWFiFjxb3u6bajz8zryA+B2nPcY5OJMcMG4cI6rRS8DGaCI4I3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Wed, Sep 09, 2026 at 03:45:37PM -0700, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    34c9c5517033 Merge 7.3-rc2 into usb-next
>> git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1408d749580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=c451f9f64434b622
>> dashboard link: https://syzkaller.appspot.com/bug?extid=093e05755c2d99caab91
>> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=102c2ef9580000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=156d7af9580000
>> 
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/8a384e63cde6/disk-34c9c551.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/e5a73decdc30/vmlinux-34c9c551.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/13abc163bbdc/bzImage-34c9c551.xz
>> 
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+093e05755c2d99caab91@syzkaller.appspotmail.com
>> 
>> ================================
>> WARNING: inconsistent lock state
>> syzkaller #0 Not tainted
>> --------------------------------
>> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
>> syz.3.17/3981 [HC0[0]:SC1[1]:HE0:SE0] takes:
>> ffffffff89ab7bc0 (fs_reclaim){+.?.}-{0:0}, at: might_alloc include/linux/sched/mm.h:316 [inline]
>> ffffffff89ab7bc0 (fs_reclaim){+.?.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:4636 [inline]
>> ffffffff89ab7bc0 (fs_reclaim){+.?.}-{0:0}, at: slab_alloc_node mm/slub.c:4974 [inline]
>> ffffffff89ab7bc0 (fs_reclaim){+.?.}-{0:0}, at: __do_kmalloc_node mm/slub.c:5413 [inline]
>> ffffffff89ab7bc0 (fs_reclaim){+.?.}-{0:0}, at: __kmalloc_node_track_caller_noprof+0xcc/0x820 mm/slub.c:5545
>> {SOFTIRQ-ON-W} state was registered at:
>>   lock_acquire kernel/locking/lockdep.c:5942 [inline]
>>   lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
>>   __fs_reclaim_acquire mm/page_alloc.c:4375 [inline]
>>   fs_reclaim_acquire+0xc4/0x100 mm/page_alloc.c:4389
>>   might_alloc include/linux/sched/mm.h:316 [inline]
>>   xa_alloc include/linux/xarray.h:876 [inline]
>>   mem_cgroup_alloc mm/memcontrol.c:4160 [inline]
>>   mem_cgroup_css_alloc+0x7e/0x1ce0 mm/memcontrol.c:4225
>>   cgroup_init_subsys+0x223/0x700 kernel/cgroup/cgroup.c:6431
>>   cgroup_init+0x569/0xe50 kernel/cgroup/cgroup.c:6558
>>   start_kernel+0x470/0x490 init/main.c:1176
>>   x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
>>   x86_64_start_kernel+0x12b/0x130 arch/x86/kernel/head64.c:291
>>   common_startup_64+0x13e/0x158
>> irq event stamp: 317
>> hardirqs last  enabled at (316): [<ffffffff878ad162>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:210 [inline]
>> hardirqs last  enabled at (316): [<ffffffff878ad162>] _raw_spin_unlock_irqrestore+0x52/0x80 kernel/locking/spinlock.c:221
>> hardirqs last disabled at (317): [<ffffffff878acd32>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:153 [inline]
>> hardirqs last disabled at (317): [<ffffffff878acd32>] _raw_spin_lock_irqsave+0x52/0x60 kernel/locking/spinlock.c:181
>> softirqs last  enabled at (302): [<ffffffff8177a2a8>] __do_softirq kernel/softirq.c:679 [inline]
>> softirqs last  enabled at (302): [<ffffffff8177a2a8>] invoke_softirq kernel/softirq.c:519 [inline]
>> softirqs last  enabled at (302): [<ffffffff8177a2a8>] __irq_exit_rcu+0x168/0x210 kernel/softirq.c:758
>> softirqs last disabled at (313): [<ffffffff8177a2a8>] __do_softirq kernel/softirq.c:679 [inline]
>> softirqs last disabled at (313): [<ffffffff8177a2a8>] invoke_softirq kernel/softirq.c:519 [inline]
>> softirqs last disabled at (313): [<ffffffff8177a2a8>] __irq_exit_rcu+0x168/0x210 kernel/softirq.c:758
>> 
>> other info that might help us debug this:
>>  Possible unsafe locking scenario:
>> 
>>        CPU0
>>        ----
>>   lock(fs_reclaim);
>>   <Interrupt>
>>     lock(fs_reclaim);
>> 
>>  *** DEADLOCK ***
>> 
>> locks held by syz.3.17/3981: 1, on CPU#0:
>>  #0: ffff888122130870 (&hiddev->existancelock){+.+.}-{4:4}, at: hiddev_ioctl+0x165/0x15b0 drivers/hid/usbhid/hiddev.c:610
>> 
>> stack backtrace:
>> CPU: 0 UID: 0 PID: 3981 Comm: syz.3.17 Not tainted syzkaller #0 PREEMPT(lazy) 
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
>> Call Trace:
>>  <IRQ>
>>  __dump_stack lib/dump_stack.c:94 [inline]
>>  dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
>>  print_usage_bug.part.0+0x258/0x340 kernel/locking/lockdep.c:4086
>>  print_usage_bug kernel/locking/lockdep.c:4054 [inline]
>>  valid_state kernel/locking/lockdep.c:4100 [inline]
>>  mark_lock_irq kernel/locking/lockdep.c:4311 [inline]
>>  mark_lock+0x956/0x1020 kernel/locking/lockdep.c:4797
>>  mark_usage kernel/locking/lockdep.c:4686 [inline]
>>  __lock_acquire+0x7f1/0x1f40 kernel/locking/lockdep.c:5242
>>  lock_acquire kernel/locking/lockdep.c:5942 [inline]
>>  lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
>>  __fs_reclaim_acquire mm/page_alloc.c:4375 [inline]
>>  fs_reclaim_acquire+0xc4/0x100 mm/page_alloc.c:4389
>>  might_alloc include/linux/sched/mm.h:316 [inline]
>>  slab_pre_alloc_hook mm/slub.c:4636 [inline]
>>  slab_alloc_node mm/slub.c:4974 [inline]
>>  __do_kmalloc_node mm/slub.c:5413 [inline]
>>  __kmalloc_node_track_caller_noprof+0xcc/0x820 mm/slub.c:5545
>>  alloc_dr drivers/base/devres.c:141 [inline]
>>  devm_kmalloc+0xa5/0x2b0 drivers/base/devres.c:951
>>  devm_kzalloc include/linux/device/devres.h:50 [inline]
>>  mt_allocate_report_data+0x59/0xcc0 drivers/hid/hid-multitouch.c:695
>>  mt_find_report_data drivers/hid/hid-multitouch.c:745 [inline]
>>  mt_event+0x1bf/0x270 drivers/hid/hid-multitouch.c:1570
>>  hid_process_event+0x37d/0x5a0 drivers/hid/hid-core.c:1572
>>  hid_process_report drivers/hid/hid-core.c:1730 [inline]
>>  hid_report_raw_event+0xb14/0x14c0 drivers/hid/hid-core.c:2109
>>  __hid_input_report.constprop.0+0x349/0x470 drivers/hid/hid-core.c:2180
>>  hid_ctrl+0x4a4/0x560 drivers/hid/usbhid/hid-core.c:486
>>  __usb_hcd_giveback_urb+0x38e/0x610 drivers/usb/core/hcd.c:1657
>>  usb_hcd_giveback_urb+0x3ca/0x4a0 drivers/usb/core/hcd.c:1741
>>  dummy_timer+0xdb2/0x3700 drivers/usb/gadget/udc/dummy_hcd.c:2019
>>  __run_hrtimer kernel/time/hrtimer.c:2067 [inline]
>>  __hrtimer_run_queues+0x462/0x9c0 kernel/time/hrtimer.c:2124
>>  hrtimer_run_softirq+0x1ca/0x360 kernel/time/hrtimer.c:2141
>>  handle_softirqs+0x1d9/0x9b0 kernel/softirq.c:645
>>  __do_softirq kernel/softirq.c:679 [inline]
>>  invoke_softirq kernel/softirq.c:519 [inline]
>>  __irq_exit_rcu+0x168/0x210 kernel/softirq.c:758
>>  irq_exit_rcu+0x9/0x30 kernel/softirq.c:775
>>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inline]
>>  sysvec_apic_timer_interrupt+0x8f/0xb0 arch/x86/kernel/apic/apic.c:1062
>>  </IRQ>
>>  <TASK>
>>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
>> RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:211 [inline]
>> RIP: 0010:_raw_spin_unlock_irqrestore+0x31/0x80 kernel/locking/spinlock.c:221
>> Code: f5 53 48 8b 74 24 10 48 89 fb 48 83 c7 18 e8 56 f7 05 fa 48 89 df e8 de 4d 06 fa f7 c5 00 02 00 00 75 23 9c 58 f6 c4 02 75 37 <bf> 01 00 00 00 e8 65 a3 f8 f9 65 48 83 3d d4 ee 98 05 00 74 16 5b
>> RSP: 0018:ffffc90001bff9f0 EFLAGS: 00000246
>> RAX: 0000000000000002 RBX: ffff8881f5625fc0 RCX: 0000000000000040
>> RDX: 0000000000000001 RSI: ffffffff89329b79 RDI: ffffffff87d2b780
>> RBP: 0000000000000287 R08: 0000000000000001 R09: 0000000000000000
>> R10: 0000000000000001 R11: 0000000000000000 R12: ffff8881f5625fc0
>> R13: 0000000000000000 R14: 00000000ffffffff R15: ffff8881f5626008
>>  __mod_timer+0x409/0xca0 kernel/time/timer.c:1139
>>  add_timer+0x62/0x90 kernel/time/timer.c:1249
>>  schedule_timeout+0x122/0x280 kernel/time/sleep_timeout.c:98
>>  usbhid_wait_io+0x24e/0x420 drivers/hid/usbhid/hid-core.c:648
>>  usbhid_init_reports+0x1a7/0x390 drivers/hid/usbhid/hid-core.c:787
>>  hiddev_ioctl+0xddb/0x15b0 drivers/hid/usbhid/hiddev.c:794
>>  vfs_ioctl fs/ioctl.c:51 [inline]
>>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>>  __se_sys_ioctl fs/ioctl.c:583 [inline]
>>  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>>  do_syscall_64+0x119/0x710 arch/x86/entry/syscall_64.c:84
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f01bd5ee159
>> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007f01bd42e028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>> RAX: ffffffffffffffda RBX: 00007f01bd876090 RCX: 00007f01bd5ee159
>> RDX: 0000000000000000 RSI: 00000000c018480b RDI: 0000000000000004
>> RBP: 00007f01bd68503b R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007f01bd876128 R14: 00007f01bd876090 R15: 00007ffe3b7b3048
>>  </TASK>
>> ------------[ cut here ]------------
>> do not call blocking ops when !TASK_RUNNING; state=2 set at [<ffffffff818d66ad>] prepare_to_wait_event+0x8d/0x720 kernel/sched/wait.c:318
>> WARNING: kernel/sched/core.c:9179 at __might_sleep+0x94/0xc0 kernel/sched/core.c:9179, CPU#0: syz.3.17/3981
>> Modules linked in:
>> CPU: 0 UID: 0 PID: 3981 Comm: syz.3.17 Not tainted syzkaller #0 PREEMPT(lazy) 
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
>> RIP: 0010:__might_sleep+0x97/0xc0 kernel/sched/core.c:9179
>> Code: 8b 94 24 c0 17 00 00 48 85 d2 75 14 48 83 c4 08 89 ee 48 89 df 31 d2 5b 5d 41 5c e9 33 fc ff ff 48 8d 3d 5c d9 92 09 48 89 d1 <67> 48 0f b9 3a eb db e8 fd 20 9c 00 eb 9f 89 74 24 04 e8 22 21 9c
>> RSP: 0018:ffffc90000007828 EFLAGS: 00010082
>> RAX: dffffc0000000000 RBX: ffffffff8931ad45 RCX: ffffffff818d66ad
>> RDX: ffffffff818d66ad RSI: 0000000000000002 RDI: ffffffff8b16a1e0
>> RBP: 0000000000000142 R08: 0000000000000001 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000001 R12: ffff888107ed3c80
>> R13: 0000000000000dc0 R14: 00000000ffffffff R15: 00000000ffffffff
>> FS:  00007f01bd42e6c0(0000) GS:ffff8882683e4000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f01bd42dff8 CR3: 00000001214ba000 CR4: 00000000003506f0
>> Call Trace:
>>  <IRQ>
>>  might_alloc include/linux/sched/mm.h:322 [inline]
>>  slab_pre_alloc_hook mm/slub.c:4636 [inline]
>>  slab_alloc_node mm/slub.c:4974 [inline]
>>  __do_kmalloc_node mm/slub.c:5413 [inline]
>>  __kmalloc_node_track_caller_noprof+0x473/0x820 mm/slub.c:5545
>>  alloc_dr drivers/base/devres.c:141 [inline]
>>  devm_kmalloc+0xa5/0x2b0 drivers/base/devres.c:951
>>  devm_kzalloc include/linux/device/devres.h:50 [inline]
>>  mt_allocate_report_data+0x59/0xcc0 drivers/hid/hid-multitouch.c:695
>>  mt_find_report_data drivers/hid/hid-multitouch.c:745 [inline]
>>  mt_event+0x1bf/0x270 drivers/hid/hid-multitouch.c:1570
>>  hid_process_event+0x37d/0x5a0 drivers/hid/hid-core.c:1572
>>  hid_process_report drivers/hid/hid-core.c:1730 [inline]
>>  hid_report_raw_event+0xb14/0x14c0 drivers/hid/hid-core.c:2109
>>  __hid_input_report.constprop.0+0x349/0x470 drivers/hid/hid-core.c:2180
>>  hid_ctrl+0x4a4/0x560 drivers/hid/usbhid/hid-core.c:486
>>  __usb_hcd_giveback_urb+0x38e/0x610 drivers/usb/core/hcd.c:1657
>>  usb_hcd_giveback_urb+0x3ca/0x4a0 drivers/usb/core/hcd.c:1741
>>  dummy_timer+0xdb2/0x3700 drivers/usb/gadget/udc/dummy_hcd.c:2019
>>  __run_hrtimer kernel/time/hrtimer.c:2067 [inline]
>>  __hrtimer_run_queues+0x462/0x9c0 kernel/time/hrtimer.c:2124
>>  hrtimer_run_softirq+0x1ca/0x360 kernel/time/hrtimer.c:2141
>>  handle_softirqs+0x1d9/0x9b0 kernel/softirq.c:645
>>  __do_softirq kernel/softirq.c:679 [inline]
>>  invoke_softirq kernel/softirq.c:519 [inline]
>>  __irq_exit_rcu+0x168/0x210 kernel/softirq.c:758
>>  irq_exit_rcu+0x9/0x30 kernel/softirq.c:775
>>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inline]
>>  sysvec_apic_timer_interrupt+0x8f/0xb0 arch/x86/kernel/apic/apic.c:1062
>>  </IRQ>
>>  <TASK>
>>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
>> RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:211 [inline]
>> RIP: 0010:_raw_spin_unlock_irqrestore+0x31/0x80 kernel/locking/spinlock.c:221
>> Code: f5 53 48 8b 74 24 10 48 89 fb 48 83 c7 18 e8 56 f7 05 fa 48 89 df e8 de 4d 06 fa f7 c5 00 02 00 00 75 23 9c 58 f6 c4 02 75 37 <bf> 01 00 00 00 e8 65 a3 f8 f9 65 48 83 3d d4 ee 98 05 00 74 16 5b
>> RSP: 0018:ffffc90001bff9f0 EFLAGS: 00000246
>> RAX: 0000000000000002 RBX: ffff8881f5625fc0 RCX: 0000000000000040
>> RDX: 0000000000000001 RSI: ffffffff89329b79 RDI: ffffffff87d2b780
>> RBP: 0000000000000287 R08: 0000000000000001 R09: 0000000000000000
>> R10: 0000000000000001 R11: 0000000000000000 R12: ffff8881f5625fc0
>> R13: 0000000000000000 R14: 00000000ffffffff R15: ffff8881f5626008
>>  __mod_timer+0x409/0xca0 kernel/time/timer.c:1139
>>  add_timer+0x62/0x90 kernel/time/timer.c:1249
>>  schedule_timeout+0x122/0x280 kernel/time/sleep_timeout.c:98
>>  usbhid_wait_io+0x24e/0x420 drivers/hid/usbhid/hid-core.c:648
>>  usbhid_init_reports+0x1a7/0x390 drivers/hid/usbhid/hid-core.c:787
>>  hiddev_ioctl+0xddb/0x15b0 drivers/hid/usbhid/hiddev.c:794
>>  vfs_ioctl fs/ioctl.c:51 [inline]
>>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>>  __se_sys_ioctl fs/ioctl.c:583 [inline]
>>  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>>  do_syscall_64+0x119/0x710 arch/x86/entry/syscall_64.c:84
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f01bd5ee159
>> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007f01bd42e028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>> RAX: ffffffffffffffda RBX: 00007f01bd876090 RCX: 00007f01bd5ee159
>> RDX: 0000000000000000 RSI: 00000000c018480b RDI: 0000000000000004
>> RBP: 00007f01bd68503b R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007f01bd876128 R14: 00007f01bd876090 R15: 00007ffe3b7b3048
>>  </TASK>
>> ----------------
>> Code disassembly (best guess):
>>    0:	f5                   	cmc
>>    1:	53                   	push   %rbx
>>    2:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
>>    7:	48 89 fb             	mov    %rdi,%rbx
>>    a:	48 83 c7 18          	add    $0x18,%rdi
>>    e:	e8 56 f7 05 fa       	call   0xfa05f769
>>   13:	48 89 df             	mov    %rbx,%rdi
>>   16:	e8 de 4d 06 fa       	call   0xfa064df9
>>   1b:	f7 c5 00 02 00 00    	test   $0x200,%ebp
>>   21:	75 23                	jne    0x46
>>   23:	9c                   	pushf
>>   24:	58                   	pop    %rax
>>   25:	f6 c4 02             	test   $0x2,%ah
>>   28:	75 37                	jne    0x61
>> * 2a:	bf 01 00 00 00       	mov    $0x1,%edi <-- trapping instruction
>>   2f:	e8 65 a3 f8 f9       	call   0xf9f8a399
>>   34:	65 48 83 3d d4 ee 98 	cmpq   $0x0,%gs:0x598eed4(%rip)        # 0x598ef11
>>   3b:	05 00
>>   3d:	74 16                	je     0x55
>>   3f:	5b                   	pop    %rbx
>> 
>> 
>
> Seems like HID issue which is being fixed by http://lore.kernel.org/20260910153746.16222-1-ngocthang2710.1999@gmail.com
>
> #syz set subsystems: hid

The specified label value is incorrect.
"hid" is not among the allowed values.
Please use one of the supported label values.

The following labels are suported:
actionable, missing-backport, no-reminders, prio: {low, normal, high}, subsystems: {..
see below ..}
The list of subsystems: https://syzkaller.appspot.com/upstream/subsystems?all=true

>

