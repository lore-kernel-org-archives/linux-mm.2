Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26418C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 17:02:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D7E26B008C; Fri,  7 Aug 2026 13:02:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AF536B0098; Fri,  7 Aug 2026 13:02:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EB8D6B0099; Fri,  7 Aug 2026 13:02:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 052086B008C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:02:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 903988012B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:02:17 +0000 (UTC)
X-FDA: 85075091514.14.88357C6
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf31.hostedemail.com (Postfix) with ESMTP id C747420007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:02:15 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf31.hostedemail.com: domain of 3lg92agkbAOcbhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3lg92agkbAOcbhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786122135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=mUsd+K6Snqu6QfiGp91buFYGcGIbaabOhpm9NstAN7g=;
	b=HT/6aRLrEYFI6KI5cmg46OemqYJBX0aAOFVtQs1O5hccbKFRg9PJUvAyjOOBYcFhcuRHCl
	86qliDDm7+6GC+3kiQPGnNTPH9Fv9uYmNq76Zxy3/3kPNzY6jk3C873CMDEYJvkZx1L/KV
	U6TOR7t9P9Kch2ULKo1IsYYTWLkmkVM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf31.hostedemail.com: domain of 3lg92agkbAOcbhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3lg92agkbAOcbhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786122135;
	b=a10JSv4GA8LN7B1EcdGtLmH2WkO0jUn3PbxBeTIf5Rdnk9BBtHwSbFn1kGPV8u1rrCspcz
	cANDqZdZtRJj62e/qYTxoAo3ATGL6dDyAHGYr2znWo8ArCKPyKWdQR7rKFYQpJkd/0I86Z
	MsVCRIPgbK61mpzs+zXEWuPOqCosNs0=
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4a7c64fbbc6so1938236b6e.2
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 10:02:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786122135; x=1786726935;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mUsd+K6Snqu6QfiGp91buFYGcGIbaabOhpm9NstAN7g=;
        b=JUckrd6yCmPydltgL0CXVra+QH9ZQvmbs+LdSlMp7zC4UYZs6AulhOugyDXPNOxyXB
         jFzaajK0K0XeJUTuiM7k5E+3tyClg8sL+EhutIZrOg9qSDPHp9wirEUkIdIuvTp+4VuO
         BNgUgr9aOtA2lOiC0cERTqtKNzsOeibBnb6160RjvL1Nhsord1w0gqg6AF0VssZyXV47
         eFhoOFNTj0Cttcbw5apXERX8bzzIOeovrfQ+6hwwvvSJt55iCDBuaGPyGMbHGSa/pMPv
         mP3c+1L4oJpLwWZAPXuB0e7fYDJUpvUBIXRlb9lOrfbhzfVMqw8gx9wpIKRvfO87VLyM
         ql3w==
X-Forwarded-Encrypted: i=1; AHgh+Roj+K8D8dPhwZuiiYsItaEZasyF8eZEQQ8k8BmbmQftmSeKjcIzC56XWHxSE3pAZMnJS0LlIn70Fg==@kvack.org
X-Gm-Message-State: AOJu0YxJClfMcLmCLOFptNgZhIcCIePTxOuU39EeBfdlrDUt5c3m35Kw
	n6jGKiQCDTPD1FzD0/qpSLwHtC1sTEdMj1+hM2ymQEK+vkCt/B1fFoBcXOOVd06LgSlcoSAGQKz
	qeSbxvrXR30jzERgOJSrmKBaCq6xte8Osn++kuf1WDccXPOq3NPai5BjJIog=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1311:b0:497:c1f1:1511 with SMTP id
 5614622812f47-4afae0f5c07mr12784366b6e.16.1786122134562; Fri, 07 Aug 2026
 10:02:14 -0700 (PDT)
Date: Fri, 07 Aug 2026 10:02:14 -0700
In-Reply-To: <20260807-evict_folios_race-v1-1-b167c6b4cfde@oss.qualcomm.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a760f96.01d0871a.3a0d52.0050.GAE@google.com>
Subject: [syzbot ci] Re: mm/mglru: fix lockless folio_putback_lru() race in evict_folios()
From: syzbot ci <syzbot+ci8a966c1cd19d53db@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com, 
	kernel@oss.qualcomm.com, ketan.kishore@oss.qualcomm.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, prakash.gupta@oss.qualcomm.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com, 
	yuzhao@google.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: fjoe5kjpnbsqpfd6dn69xgypj8ntgu5x
X-Rspamd-Queue-Id: C747420007
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786122135-390922
X-HE-Meta: U2FsdGVkX19mn7xFj3dEx7p2c3AYR+osmmYN+xCxZgsjLbFn5VQgseZvy9zg32DthejvGubuQnViah7uODSvxj8V5pGTYkyaeqo+lUxT9k6gLoFmQJOgtJ4hT8NqJCcUjhPOttiulUVnjFu4iZeAvrh9OrQ+b+eGTC/jAP+61KygTI2iJ7AAwMYexkhbN5b8JsG8j344bEoGuHco0JPxrysP6owaxjmF/IX2nXv70zv1qsuAes4MsWKeF2Q5loA81zD2bCYLMR2RPMyrOSDYpHSNFJYfxxP8PtZT3NJtdrVKW7tABrwTlPC/13axwU0KruMvuWX27O8IZ8o1QpjH8JVYDZjw7L7qUu9JNe9Seux3MG4Np6BhDQxKXjtMCGdDZR3DPEKiivtB4XEhxr0uzae4F5OzIUbGHbetoDEb9Bc0BYLuDQg/R1j2CsIqO571ps9G7azQkKdc7JfWPZyo0DH5KigymqjQdtdGpoiGzlE4ubmco0xC6+u4bS7pNii4AxkTCfrAVOsJ3FDs3XfdzmNMhKulo4abUU0G+7xmRvSoUj1m1/IhRRIm+WIxwR07l1t1Pmyhd8ODJvAgPvArIFZw4UWZN0BZOCJdhtT4nQfaAKRSY5gSh6CXkC5q+PWV1ulXfD0wtTY5j+hL8Avy0rprMgCpz5FXT36UrlRPmhBeIsJWxcWEJ5hsn6Y0n70DFn31l+SkZgFJiro7/wfFTY+BdnWRwVm8DnW8T1MgbppqK2DL3yn/yEbJcbDcS0aa8HX51GKqOYdFA6zgfuqRH6iF4iHSVaY/jz6FtLK8g23B6l7V7zuyGA1qPVNYMjVZC1BZWZyrmmcnjCJA4ZI9fSyMFvHdA3uskkKBlFOHOPy0+sUodwzwB1G192LmdDg2YxgJWBaMEiM9zm6hfgMLbd3fKNjl1a7LKzD+SHeT/mm08wOGTaKpSt57hqj8un6C6TPGr89ZMNIC/TLptEg
 +MEli6wb
 ZBgd4IwFSM4S4AaAMlRRb3HKKmMhApba4LDFEncG/GG53s0dYukf3J9TBNbkjb/OyouAttpD438CWVrwophccijeCAnDnH/sRd4lEe9IOg5P3FoEhMWvneQkhfZ9hpt40T15nYJXVt1WwCc8n/IrjX09f90Ori1NTA843BYvcNuycZ8fm9DezqKmVpR65DcjTmjOHVIXIIVARqd8CtMcKSbc17aDbbR8jsLm6DiZZdpqChRfxamBWeqmRrtCSGI+maa6esd2VS2DrAFF5UYhowA+/l9a/kL9khoY9cLSlEo2qUPFCUnzL1EvwlPzWBQgbjFZdtU4NRUsi06qiFy5sjuiiCtXIhU5YRPqanluN/7zV9OcEKjG+U/PlG+5CZjxsd0+bc2KfxNddMtn5EKnTPmPmK2IO1ME/ZlzNv0PEv85ITxlven6W/KVyQVHd+Zu+mhF3MBjRfcBRSepWmT2zw0Es9bljOCXXNTe73fH0qsXMrx93i1i2iGHaam0nzI4eOZVLTIgpuCZPRXUY0isBNG8urOCCCdflozDqd2axCNm2y61uqb386LtctNxnn4kgtEQxNpLm+VT4zdoIv3lWCIF/8aDyCjjBnGkAQYxtup29uNiXTCnjRL5f9DRy0otswgCIdzOQInUDpET+6Cp2BmN3vnI6Zjp90oEfNrNQN38Rkyl8n09XqZpB+nSez1cR8h6PW2OFmgNp5snDaMRZ7PdtkrYw4A/2vFm6fPte4vMAttSxhtoDUdI7bXGVpbvP/1gBKIIvTTY8vHak1HIqnwLspsgLXx91o5wY3ihaR5sXbrn2Pv61Tpt8Mv5XFrz8FS2vvAZavEXZmTr40N/U90ClnqeseF+4dbzOE2L2gnKwSYKWQWQXJ/YgvHn4qV1zvKw0qm5RQlFloacs1vOvIcsiaqcQaWypSViIe+/SpucIhq8q/tFYLuSK2RlOwQZa8XIz7VKkLcz/qfJ3pkOgkMqAf5xh
 358bFBRN
 rM1WZ5iTYHD1NC14c4G+/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] mm/mglru: fix lockless folio_putback_lru() race in evict_folios()
https://lore.kernel.org/all/20260807-evict_folios_race-v1-1-b167c6b4cfde@oss.qualcomm.com
* [PATCH] mm/mglru: fix lockless folio_putback_lru() race in evict_folios()

and found the following issue:
possible deadlock in __folio_batch_add_and_move

Full report is available here:
https://ci.syzbot.org/series/84ef3e36-11bb-4ace-93cf-a1d457206afc

***

possible deadlock in __folio_batch_add_and_move

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      ea2bff00da89d7767d677bb68470130ba96f4928
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/fefee38b-873a-46f2-b7ad-f80279b083f8/config
syz repro: https://ci.syzbot.org/findings/9a05a8ec-c7b9-47ec-8888-0383f37b235c/syz_repro

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.17/5796 is trying to acquire lock:
ffff888121033c10 (lock#3){+.+.}-{3:3}, at: local_lock_acquire include/linux/local_lock_internal.h:46 [inline]
ffff888121033c10 (lock#3){+.+.}-{3:3}, at: __folio_batch_add_and_move+0x11a/0xc50 mm/folio.c:220

but task is already holding lock:
ffff888102ab6cb0 (&lruvec->lru_lock){....}-{3:3}, at: spin_lock_irq include/linux/spinlock.h:372 [inline]
ffff888102ab6cb0 (&lruvec->lru_lock){....}-{3:3}, at: evict_folios+0x3cf5/0x4970 mm/vmscan.c:4926

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&lruvec->lru_lock){....}-{3:3}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
       _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:166
       folio_lruvec_lock_irqsave+0x273/0x550 mm/memcontrol.c:1509
       folio_lruvec_relock_irqsave include/linux/memcontrol.h:1567 [inline]
       folio_batch_move_lru+0x6d3/0xa60 mm/folio.c:192
       __folio_batch_add_and_move+0x510/0xc50 mm/folio.c:224
       shmem_alloc_and_add_folio+0xcc2/0xf60 mm/shmem.c:2033
       shmem_get_folio_gfp+0x5da/0x16d0 mm/shmem.c:2527
       shmem_read_folio_gfp+0x8a/0xe0 mm/shmem.c:5964
       drm_gem_get_pages+0x253/0x9c0 drivers/gpu/drm/drm_gem.c:695
       drm_gem_shmem_get_pages_locked+0x22b/0x480 drivers/gpu/drm/drm_gem_shmem_helper.c:242
       drm_gem_shmem_pin_locked+0x251/0x510 drivers/gpu/drm/drm_gem_shmem_helper.c:305
       drm_gem_shmem_vmap_locked+0x487/0x7d0 drivers/gpu/drm/drm_gem_shmem_helper.c:409
       drm_gem_vmap_locked drivers/gpu/drm/drm_gem.c:1421 [inline]
       drm_gem_vmap+0x10a/0x1d0 drivers/gpu/drm/drm_gem.c:1463
       drm_client_buffer_vmap+0x6c/0xb0 drivers/gpu/drm/drm_client.c:356
       drm_fbdev_shmem_driver_fbdev_probe+0x280/0x930 drivers/gpu/drm/drm_fbdev_shmem.c:159
       drm_fb_helper_single_fb_probe drivers/gpu/drm/drm_fb_helper.c:1544 [inline]
       __drm_fb_helper_initial_config_and_unlock+0x148f/0x1b50 drivers/gpu/drm/drm_fb_helper.c:1725
       drm_fbdev_client_hotplug+0x16c/0x230 drivers/gpu/drm/clients/drm_fbdev_client.c:66
       drm_client_register+0x16e/0x200 drivers/gpu/drm/drm_client.c:143
       drm_fbdev_client_setup+0x1a0/0x450 drivers/gpu/drm/clients/drm_fbdev_client.c:168
       drm_client_setup+0x107/0x220 drivers/gpu/drm/clients/drm_client_setup.c:46
       bochs_pci_probe+0xa9a/0xbb0 drivers/gpu/drm/tiny/bochs.c:776
       local_pci_probe drivers/pci/pci-driver.c:354 [inline]
       pci_call_probe drivers/pci/pci-driver.c:416 [inline]
       __pci_device_probe drivers/pci/pci-driver.c:478 [inline]
       pci_device_probe+0x48e/0xd10 drivers/pci/pci-driver.c:512
       call_driver_probe drivers/base/dd.c:-1 [inline]
       really_probe+0x254/0xae0 drivers/base/dd.c:706
       __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
       driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
       __driver_attach+0x339/0x600 drivers/base/dd.c:1292
       bus_for_each_dev+0x23b/0x2c0 drivers/base/bus.c:383
       bus_add_driver+0x345/0x670 drivers/base/bus.c:763
       driver_register+0x23a/0x320 drivers/base/driver.c:174
       do_one_initcall+0x250/0x870 init/main.c:1359
       do_initcall_level+0x10a/0x1a0 init/main.c:1421
       do_initcalls+0x59/0xa0 init/main.c:1437
       kernel_init_freeable+0x29d/0x3e0 init/main.c:1672
       kernel_init+0x22/0x1d0 init/main.c:1562
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #0 (lock#3){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3181 [inline]
       check_prevs_add kernel/locking/lockdep.c:3300 [inline]
       validate_chain kernel/locking/lockdep.c:3924 [inline]
       __lock_acquire+0x15ff/0x2e50 kernel/locking/lockdep.c:5254
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5908
       local_lock_acquire include/linux/local_lock_internal.h:46 [inline]
       __folio_batch_add_and_move+0x132/0xc50 mm/folio.c:220
       folio_putback_lru+0x18/0xe0 mm/vmscan.c:822
       evict_folios+0x3cfd/0x4970 mm/vmscan.c:4927
       try_to_shrink_lruvec+0xe3b/0x1340 mm/vmscan.c:5081
       lru_gen_shrink_lruvec mm/vmscan.c:5226 [inline]
       shrink_lruvec+0x54f/0x2c40 mm/vmscan.c:5986
       shrink_node_memcgs mm/vmscan.c:6225 [inline]
       shrink_node+0xa9b/0x3e30 mm/vmscan.c:6269
       shrink_zones mm/vmscan.c:6508 [inline]
       do_try_to_free_pages+0x6a3/0x1990 mm/vmscan.c:6570
       try_to_free_mem_cgroup_pages+0x30d/0x830 mm/vmscan.c:6892
       mem_cgroup_resize_max+0x23c/0x470 mm/memcontrol-v1.c:1817
       mem_cgroup_write+0x223/0x290 mm/memcontrol-v1.c:-1
       cgroup_file_write+0x331/0x8f0 kernel/cgroup/cgroup.c:4412
       kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x612/0xba0 fs/read_write.c:687
       ksys_write+0x150/0x270 fs/read_write.c:739
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x510 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&lruvec->lru_lock);
                               lock(lock#3);
                               lock(&lruvec->lru_lock);
  lock(lock#3);

 *** DEADLOCK ***

locks held by syz.0.17/5796: 5, last CPU#0:
 #0: ffff88810338ecf0 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x246/0x320 fs/file.c:1259
 #1: ffff888110422460 (sb_writers#10){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2754 [inline]
 #1: ffff888110422460 (sb_writers#10){.+.+}-{0:0}, at: vfs_write+0x22b/0xba0 fs/read_write.c:683
 #2: ffff88811ad85880 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter+0x1d8/0x540 fs/kernfs/file.c:336
 #3: ffff8881bd86d3c8 (kn->active#53){.+.+}-{0:0}, at: kernfs_get_active_of fs/kernfs/file.c:73 [inline]
 #3: ffff8881bd86d3c8 (kn->active#53){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x22b/0x540 fs/kernfs/file.c:337
 #4: ffff888102ab6cb0 (&lruvec->lru_lock){....}-{3:3}, at: spin_lock_irq include/linux/spinlock.h:372 [inline]
 #4: ffff888102ab6cb0 (&lruvec->lru_lock){....}-{3:3}, at: evict_folios+0x3cf5/0x4970 mm/vmscan.c:4926

stack backtrace:
CPU: 0 UID: 0 PID: 5796 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2059
 check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2191
 check_prev_add kernel/locking/lockdep.c:3181 [inline]
 check_prevs_add kernel/locking/lockdep.c:3300 [inline]
 validate_chain kernel/locking/lockdep.c:3924 [inline]
 __lock_acquire+0x15ff/0x2e50 kernel/locking/lockdep.c:5254
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5908
 local_lock_acquire include/linux/local_lock_internal.h:46 [inline]
 __folio_batch_add_and_move+0x132/0xc50 mm/folio.c:220
 folio_putback_lru+0x18/0xe0 mm/vmscan.c:822
 evict_folios+0x3cfd/0x4970 mm/vmscan.c:4927
 try_to_shrink_lruvec+0xe3b/0x1340 mm/vmscan.c:5081
 lru_gen_shrink_lruvec mm/vmscan.c:5226 [inline]
 shrink_lruvec+0x54f/0x2c40 mm/vmscan.c:5986
 shrink_node_memcgs mm/vmscan.c:6225 [inline]
 shrink_node+0xa9b/0x3e30 mm/vmscan.c:6269
 shrink_zones mm/vmscan.c:6508 [inline]
 do_try_to_free_pages+0x6a3/0x1990 mm/vmscan.c:6570
 try_to_free_mem_cgroup_pages+0x30d/0x830 mm/vmscan.c:6892
 mem_cgroup_resize_max+0x23c/0x470 mm/memcontrol-v1.c:1817
 mem_cgroup_write+0x223/0x290 mm/memcontrol-v1.c:-1
 cgroup_file_write+0x331/0x8f0 kernel/cgroup/cgroup.c:4412
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x510 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f64a439e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f64a5333028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f64a4625fa0 RCX: 00007f64a439e0d9
RDX: 0000000000000020 RSI: 00002000000002c0 RDI: 0000000000000003
RBP: 00007f64a4435024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f64a4626038 R14: 00007f64a4625fa0 R15: 00007fff0f9eaaa8
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

