Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C77FFFCC9B3
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 03:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D8176B0088; Mon,  9 Mar 2026 23:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0854B6B0089; Mon,  9 Mar 2026 23:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3886B008A; Mon,  9 Mar 2026 23:54:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9C946B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:54:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A0DC16046A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:54:06 +0000 (UTC)
X-FDA: 84528785292.02.3474BFB
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by imf30.hostedemail.com (Postfix) with ESMTP id C125980009
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:54:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf30.hostedemail.com: domain of 325WvaQkbABoIOPA0BB4H0FF83.6EE6B4KI4H2EDJ4DJ.2EC@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=325WvaQkbABoIOPA0BB4H0FF83.6EE6B4KI4H2EDJ4DJ.2EC@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773114844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=oIx85w9W7IsG0j4v1Wx1+1hfwFsNA9DgmZnpX/ajWn4=;
	b=Cj+syLqPMqpfbJeSadOqB2gfyRPBlwsBrsQPSJ05wxiwOafrSLxpbDprva+eJMBkKvHOw6
	ILU9e92Ypt/3AZcnpfBYpFMDjG4iKoZdt5IpYIqYyuKizzH3By/FCbhjykwwB9zYwe7gWp
	WSRwQtZSDUtyzforU4mZoU7B+YHZ8Fg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf30.hostedemail.com: domain of 325WvaQkbABoIOPA0BB4H0FF83.6EE6B4KI4H2EDJ4DJ.2EC@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=325WvaQkbABoIOPA0BB4H0FF83.6EE6B4KI4H2EDJ4DJ.2EC@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773114844; a=rsa-sha256;
	cv=none;
	b=a3XOe2+9Evmlbr2XyG4xRgfNHbr+3/xECDAJ5tt/JYytKQT2feqRMtmA+tCZ46cx3GTkEm
	L19HR56+BBHIWQJ1+cjjq0IeBKEiP5G4/5rUGW5EPAtHO8/5YTEVNvUZocD0psLePGGePD
	wHCBIj06EH0ciMOLX3MPnoPmZZSofzs=
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-679c5ed0942so138616002eaf.1
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 20:54:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773114844; x=1773719644;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oIx85w9W7IsG0j4v1Wx1+1hfwFsNA9DgmZnpX/ajWn4=;
        b=omLj/OLdKeYizYDpbI9aCpp5od5K9rqXrDP58cXioPhEVf0ly56OGgFuB2XW0qOLOj
         W/kY4/H5OJBZ1RW20N1X7CLRigy67IpGnKM4XZwiZSeAg3pgygwo8BQmdePk+MUlRnUk
         PR6acMV5MGFFQ3A6R6syCG80wun1nzsxYnRT4aFYU+80hqJYERDFT+icz6AkMy/gBm+m
         KHjaPSUM8aq7GLSewDvUo/+IslvOdLdQWiNfl08cHw6XmVXZ7O+ECfFIUT8WknAFJg6l
         zWDXMlxeTGbT32Z+2xuAwkLLr3ytTev6q7VY0wZ5GXN0DyO0zClrN2TckrS/G5K9d1Cu
         UrxA==
X-Forwarded-Encrypted: i=1; AJvYcCWRNbCroIFpqBLgctURldoEfnrtC7uID7HiqDKSeDNC7f8fHvpM+YdTAa8yaQJIdh9TY0Xc84G0Fg==@kvack.org
X-Gm-Message-State: AOJu0YzPGOkH50VYwQAgmEEWdETJuA0VXJK3Nq41zffXS8wrUyfz8/mU
	s+W30ovc0UEYGs4oQxbU8xPotEXK7t4GSY+RkdO3rbRR+cstcDuXu9OIHXWWENgwd6SwrWHKSEP
	LhOMNcIDuPiX/fNSKyd9Zg4gj3wr6FIhAPH0+E+Z6rfL6cIB+6Ha59lTi2to=
MIME-Version: 1.0
X-Received: by 2002:a4a:edc8:0:b0:662:f763:c539 with SMTP id
 006d021491bc7-67b9bc6ad80mr8703060eaf.14.1773114843722; Mon, 09 Mar 2026
 20:54:03 -0700 (PDT)
Date: Mon, 09 Mar 2026 20:54:03 -0700
In-Reply-To: <aa-SinLe2jrtO1pS@hyeyoo>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69af95db.a00a0220.d013.0001.GAE@google.com>
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
From: syzbot <syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, catalin.marinas@arm.com, chao@kernel.org, 
	hao.li@linux.dev, harry.yoo@oracle.com, jaegeuk@kernel.org, jannh@google.com, 
	liam.howlett@oracle.com, linkinjeon@kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	pfalcato@suse.de, sj1557.seo@samsung.com, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org, vbabka@suse.cz, wangqing7171@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C125980009
X-Stat-Signature: 9p891zjt4amib1wyr87o7hcqb39g3y7f
X-Rspam-User: 
X-HE-Tag: 1773114844-177416
X-HE-Meta: U2FsdGVkX1/rr+wixMqakkR03sMqny42jvYFyM7er2/K1DWB0crEhXwrjtZ+GWYb8F9Jcr2rBETJTEhb98Kq8i6+C5b+BuwP3+wtG6OdFZqrdcJqx1d56RGOpwJnWUHrPNK2f9t1w7dlP2o62gPf+/rwzYhR5+sfW60GUBHVCXUxToLiz78oc8xFl0eaqZrUOwFMZJtCAzW6WIHyn4xF/PQQXb6968r7rjbcePx+eEjApOSEJmhA6E7+TnelV9lAYLHWumBYteIlNCRpQxddFcZbLiy2FA7oVM9kWCIhSlZDUsSC3wDFRkliAZzSHztj7KL+tYmOHz6CdLazVnzrBQQt58adKE9l4j+F13hKWpTEgpOtF19oPIzHuvdgG4lg8nMdravx/592tLHjSRxi4ce8xGzSice92mGOQqfmyVdx1sKrl0/9tlGSGW9XxhE8zcFQmsqGjIVOcSzr0UXbXnDXh0oFQycVFWMbjlgkGW+a/tmSJN51dgxZz1idN81lo5XCfoqLLpSBr+dMDuMU4vNF6X0aph1xyC3S8C4KranoK+ANo9CcnvLZ5C1XVFlIo/zwVl3Rx41sMrTqa2nZawjN/4ApC3fXkdSnXNiKvzhoyigwBtLac3N6ZdevB4fkTPmRa3GyqTJ+YQCipO4aGjubkD3Re6lgpCwrHivRKx4ydUIjR880sHZruW/VoaYop3bYGnvYsi2pj/aVm6cWkI0MfvSljtF1imczL/MaZUCcQS10FYSkovU7M6wpmk9OaG/2fGi8uk3j1rDBP1Id/T3YKhNb9utdjXk4cWA4eJFh78LIkJPJBjAhsRhyFoGJOg+sqgqNjJ1Oj5RdnA2gQB5lIQdG68eIqDhFMDCtVtDwMRSF8cGxAdOeI/wZiqRMRUmmd0q6ybqkgZf0OAmSlb545swzRlHQUGKs3aITPXYxRAlznrh9eCXxvswI4YjOXivqv5LulPSEJpZNCaV
 q7Up2Z1l
 SPfrYkDj/qqNodln2gziROme4p32JKbJ/H1w3yXCW8su/PfjMH+jUCHazK9KKKQdVcGyKSsDjGd6wYq/H9smZp7CHrFfwjSCSGXUnvO+hzSoeuDSlZ+Bz8OyaHcovFXudLdyfshgFFv5FaO0ec1fXGwjc47hluXzJ3RUcFLogNB/i5UrSF8odnJWuEwn2/YsO+VdC72dUAW1HTgKAKqz6ls7wNUQWWy4N9e4TjT9O0P+7p81/hfN00jLAP9mT9AmAnwsVZ5mLvgJWCOUyRmOKixRb6i0ke9ByVdPlhUg+m7L3FF2VUFeke+V0FgvAHA63XPSnezbB47BUuF7iadP7cCdFpoNA7Ki1IB3OGBo2Gyfqhvoy/OGzym4FL3dpJfxgZydqWM9HWoHl7KPvD7aB5ZRaxufycIi/YPDS8O9nDVUsINcT1KxHs6cEPOGrCt+wtWasAPbuYQvyZ4m4Q9gdTYvY6+0E3AYHFBxFF9qU6RlwxFbQK+625LozDAhrgrDyATQFfRx9AeuhsIKLKn3RYmnpNh454Ca3r5+8Sqn7oOIAHaTyr5PhMFWEXHFuFUsuHg5wxu32hk04vAvPeGE2S0BHwj0ZU0F5ecwF8EHudP6qtVV3KB9r6tT4FqV4H3NMvueiRQP9gq7teCEY6EHJ2ZIbNdh+HlkzZgJ92vV4nIPER6daDyXauzllq1GOeR6oL+skx5pmEmnIgmS0brQZj2RlH/iS1pVg78TT5kEQINSRT8IcT6liy7OiJuNkLmFHS0gZMj/kS1qHnkAGD5npNph/XcIluLy1INiosLdt67Blh06wdTHlp7GGVOUK4EibMoQqaDHcmSZnlNN/E2GsV6LpyCJAySLn00KkluDktGz/ieL6n3a4U2kzJKZau098AJoZw0vLGPlB5aXCu086Bavsy0IZ26gCiYlo/X6LJPHnmNgdaYT2b6jo/JI5LSSzZAdVYW+mFyaEouCDKkuMuYmEaSD2
 y07UE0pY
 cXYpmWgiGsAfyjcIwOgodjqkhicTTyi0ovhZrHmmdC7WQqFqtzvgtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
memory leak in __pcs_replace_empty_main

BUG: memory leak
unreferenced object 0xffff888100b60200 (size 512):
  comm "kthreadd", pid 2, jiffies 4294937343
  hex dump (first 32 bytes):
    00 6c c3 09 81 88 ff ff 00 9a 9d 0a 81 88 ff ff  .l..............
    00 16 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc 8a95531e):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4552 [inline]
    slab_alloc_node mm/slub.c:4874 [inline]
    __do_kmalloc_node mm/slub.c:5267 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5280
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    alloc_full_sheaf mm/slub.c:2834 [inline]
    __pcs_replace_empty_main+0x1d2/0x260 mm/slub.c:4634
    alloc_from_pcs mm/slub.c:4725 [inline]
    slab_alloc_node mm/slub.c:4859 [inline]
    __do_kmalloc_node mm/slub.c:5267 [inline]
    __kmalloc_node_noprof+0x57e/0x5d0 mm/slub.c:5274
    kmalloc_node_noprof include/linux/slab.h:1081 [inline]
    __vmalloc_area_node mm/vmalloc.c:3855 [inline]
    __vmalloc_node_range_noprof+0x284/0xe50 mm/vmalloc.c:4064
    __vmalloc_node_noprof+0x71/0x90 mm/vmalloc.c:4124
    alloc_thread_stack_node kernel/fork.c:355 [inline]
    dup_task_struct kernel/fork.c:924 [inline]
    copy_process+0x3e5/0x28c0 kernel/fork.c:2050
    kernel_clone+0xac/0x6e0 kernel/fork.c:2654
    kernel_thread+0x80/0xb0 kernel/fork.c:2715
    create_kthread kernel/kthread.c:459 [inline]
    kthreadd+0x186/0x250 kernel/kthread.c:817
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff88810438c200 (size 512):
  comm "swapper/0", pid 1, jiffies 4294937794
  hex dump (first 32 bytes):
    00 02 10 0e 81 88 ff ff 00 56 c3 09 81 88 ff ff  .........V......
    00 17 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 3e1bb722):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4552 [inline]
    slab_alloc_node mm/slub.c:4874 [inline]
    __do_kmalloc_node mm/slub.c:5267 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5280
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    __pcs_replace_full_main+0xe8/0x300 mm/slub.c:5730
    free_to_pcs mm/slub.c:5783 [inline]
    slab_free mm/slub.c:6185 [inline]
    kfree+0x352/0x390 mm/slub.c:6498
    v4l2_ctrl_handler_free drivers/media/v4l2-core/v4l2-ctrls-core.c:1756 [inline]
    v4l2_ctrl_handler_free+0x92/0x290 drivers/media/v4l2-core/v4l2-ctrls-core.c:1736
    vivid_dev_release+0x26/0x90 drivers/media/test-drivers/vivid/vivid-core.c:857
    v4l2_device_release drivers/media/v4l2-core/v4l2-device.c:51 [inline]
    kref_put include/linux/kref.h:65 [inline]
    v4l2_device_put+0x6b/0xa0 drivers/media/v4l2-core/v4l2-device.c:56
    vivid_create_instance drivers/media/test-drivers/vivid/vivid-core.c:2070 [inline]
    vivid_probe.cold+0x55a/0x386d drivers/media/test-drivers/vivid/vivid-core.c:2095
    platform_probe+0x86/0xf0 drivers/base/platform.c:1446
    call_driver_probe drivers/base/dd.c:583 [inline]
    really_probe+0x12f/0x3a0 drivers/base/dd.c:661
    __driver_probe_device+0xc7/0x160 drivers/base/dd.c:803
    driver_probe_device+0x2a/0x120 drivers/base/dd.c:833
    __driver_attach drivers/base/dd.c:1227 [inline]
    __driver_attach+0x10a/0x200 drivers/base/dd.c:1167
    bus_for_each_dev+0xb8/0x120 drivers/base/bus.c:383
    bus_add_driver+0x122/0x280 drivers/base/bus.c:715
    driver_register+0xb1/0x140 drivers/base/driver.c:249

BUG: memory leak
unreferenced object 0xffff888109c35c00 (size 512):
  comm "kworker/0:1", pid 10, jiffies 4294937868
  hex dump (first 32 bytes):
    00 68 d4 09 81 88 ff ff 00 9c de 09 81 88 ff ff  .h..............
    00 16 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc 9ab54a7c):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4552 [inline]
    slab_alloc_node mm/slub.c:4874 [inline]
    __do_kmalloc_node mm/slub.c:5267 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5280
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    __pcs_replace_full_main+0xe8/0x300 mm/slub.c:5730
    free_to_pcs mm/slub.c:5783 [inline]
    slab_free mm/slub.c:6185 [inline]
    kfree+0x352/0x390 mm/slub.c:6498
    vfree.part.0+0x1cd/0x4d0 mm/vmalloc.c:3484
    vfree mm/vmalloc.c:3456 [inline]
    delayed_vfree_work+0x5b/0x90 mm/vmalloc.c:3398
    process_one_work+0x26c/0x5d0 kernel/workqueue.c:3275
    process_scheduled_works kernel/workqueue.c:3358 [inline]
    worker_thread+0x243/0x490 kernel/workqueue.c:3439
    kthread+0x14e/0x1a0 kernel/kthread.c:436
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff88810a9d9a00 (size 512):
  comm "swapper/0", pid 1, jiffies 4294937887
  hex dump (first 32 bytes):
    00 02 b6 00 81 88 ff ff 00 98 9d 0a 81 88 ff ff  ................
    00 16 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc 368f6316):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4552 [inline]
    slab_alloc_node mm/slub.c:4874 [inline]
    __do_kmalloc_node mm/slub.c:5267 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5280
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    __pcs_replace_full_main+0xe8/0x300 mm/slub.c:5730
    free_to_pcs mm/slub.c:5783 [inline]
    slab_free mm/slub.c:6185 [inline]
    kfree+0x352/0x390 mm/slub.c:6498
    slab_sysfs_init+0xce/0xf0 mm/slub.c:9613
    do_one_initcall+0x79/0x4c0 init/main.c:1382
    do_initcall_level init/main.c:1444 [inline]
    do_initcalls init/main.c:1460 [inline]
    do_basic_setup init/main.c:1479 [inline]
    kernel_init_freeable+0x2a4/0x340 init/main.c:1692
    kernel_init+0x1b/0x1d0 init/main.c:1582
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff88810a9d9600 (size 512):
  comm "swapper/0", pid 1, jiffies 4294937887
  hex dump (first 32 bytes):
    00 b6 34 0a 81 88 ff ff 00 6c c3 09 81 88 ff ff  ..4......l......
    00 16 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc d6fcd7dc):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4552 [inline]
    slab_alloc_node mm/slub.c:4874 [inline]
    __do_kmalloc_node mm/slub.c:5267 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5280
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    __pcs_replace_full_main+0xe8/0x300 mm/slub.c:5730
    free_to_pcs mm/slub.c:5783 [inline]
    slab_free mm/slub.c:6185 [inline]
    kfree+0x352/0x390 mm/slub.c:6498
    slab_sysfs_init+0xce/0xf0 mm/slub.c:9613
    do_one_initcall+0x79/0x4c0 init/main.c:1382
    do_initcall_level init/main.c:1444 [inline]
    do_initcalls init/main.c:1460 [inline]
    do_basic_setup init/main.c:1479 [inline]
    kernel_init_freeable+0x2a4/0x340 init/main.c:1692
    kernel_init+0x1b/0x1d0 init/main.c:1582
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF


Tested on:

commit:         1f318b96 Linux 7.0-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17bde806580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2c6ad6fefffa76b1
dashboard link: https://syzkaller.appspot.com/bug?extid=cae7809e9dc1459e4e63
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1065375a580000


