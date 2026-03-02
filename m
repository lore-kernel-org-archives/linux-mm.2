Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE2F6D58E4B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 03:57:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 091276B009E; Sun,  1 Mar 2026 22:57:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03E3E6B009F; Sun,  1 Mar 2026 22:57:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62E76B00A0; Sun,  1 Mar 2026 22:57:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D24DE6B009E
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 22:57:04 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B3A4C2BC6
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:57:04 +0000 (UTC)
X-FDA: 84499762368.15.1304DDE
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by imf20.hostedemail.com (Postfix) with ESMTP id B0F531C000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:57:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf20.hostedemail.com: domain of 3jQqlaQkbAIo6CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3jQqlaQkbAIo6CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772423822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=JmWvfmtgAcDRz4bFImh8rJEfEmq6Cak2/bFtX09VN9Q=;
	b=NfOsQjaCVeDzhTnDAHtuKCWDR4caOpuBNzBHuDYAQXFf1RX7g1TqAg0vZnS9q5qOb7rZKi
	JwwqII7LG7XG4IO4Dr9gHUe49BJ3tXBb2moKMC46+ziemcAIyULirgZDVvw8P+6ZpONZRr
	Wr0zf7MCyHBZJ65SH4acTInjb/R3BpU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772423822; a=rsa-sha256;
	cv=none;
	b=eHQVESJg+bJgXlQwKmvgF+i01FbyVZbKyTS4RsU28pbuwAKsAfMePeUFdSyaGfZ2ZhSvUn
	BbXF/fMnxneUd5NpBZeqmZhkBEZxh+aylgIaEX/2InwpYebwp/PbkexHlY3ToccvSABBES
	mmIWSSvxWBoVVqkcV0bKvPXVF3prun4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf20.hostedemail.com: domain of 3jQqlaQkbAIo6CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3jQqlaQkbAIo6CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-67995e1ecacso84743051eaf.0
        for <linux-mm@kvack.org>; Sun, 01 Mar 2026 19:57:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772423822; x=1773028622;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JmWvfmtgAcDRz4bFImh8rJEfEmq6Cak2/bFtX09VN9Q=;
        b=sTAYbOQuAIzhi+XqH68p7Tn8Nu2dcipZ+l7ivP74Dk+sLbWuoqGf9t2QFTOeha5DHz
         XzKN44LPNMYMPSqGHI04d8qJ8JDF+GvSa6rjXoG4s5Kpw8lcz23BeDIUVfWoMnj1T1cL
         UuXq8cOTXPadK0bJBYRobIUzEcE6Y3zXq6LD6Z4TMzfFvgY0wQEBkcbgWyQWjj3ZVJ1v
         KP+4U8TtKzpiiRH9b30lreuu1DkQ5NzMR2kAsctzaAzQCXnUJ2A3QQ623T6owjCmg91T
         EEkJId/gjVw9D5r5wZ8HyZ7fv1gB29ngenEkB7OBtAN8rv3vBNnll9+gijFQ4WeYbAav
         TO8w==
X-Forwarded-Encrypted: i=1; AJvYcCURTu/tAaMuwpPFMk+pjN+1hDsL6U580q/alrru0yLcWJ5IqHnXRvJm8M73p/q70+qhsg7bioMVug==@kvack.org
X-Gm-Message-State: AOJu0YwBus4aPvM8O63GaKTH6xnBQ/J2a0+u5Fi5lhnYaj6iWVRxSMRV
	edfXEE27pN8aCriVaNEJJQs2HIWrpsQcD5CBMhYqhifM7ehbDk3UUpKmNIkdrlkHMIARuUCMvfk
	pa+B7loiv0JtypLHNhUv0LztcVnv7wmX3AbxdIekx/PMBFCqQl4GSulVXSls=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:418e:b0:67a:61f:646b with SMTP id
 006d021491bc7-67a061f67bfmr3305124eaf.74.1772423821722; Sun, 01 Mar 2026
 19:57:01 -0800 (PST)
Date: Sun, 01 Mar 2026 19:57:01 -0800
In-Reply-To: <20260302034102.3145719-1-wangqing7171@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a50a8d.050a0220.3a55be.006f.GAE@google.com>
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
From: syzbot <syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, chao@kernel.org, jaegeuk@kernel.org, 
	jannh@google.com, liam.howlett@oracle.com, linkinjeon@kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	pfalcato@suse.de, sj1557.seo@samsung.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz, wangqing7171@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B0F531C000A
X-Stat-Signature: kp33464a673jjc5pgb7dwjpeptj37wrj
X-Rspam-User: 
X-HE-Tag: 1772423822-811172
X-HE-Meta: U2FsdGVkX183uKa0UDGgfLg+JYS5HC5pvGO/Sc1VjbSBu1QpK9D0IfH2BZ/HnShwC7aJmJ0owfNIULGDyd9PR+7HFz83A3yMbKECF5N02Hi8NQHQQ6pn3fFL/QZzoI8UUPmROL12tUYZwa/GfZ0HBaYo9ZdIhHGieivK43a9gkd9iYJe2Pyxtnemp6nhbsoaCfjXmvdqj2vX7FKZMH7dmWSM4wimWTnndNustJYodj1BG5pkMDxadwOd+vXg70o+BEYog6S7YsrK976tt4dbcATmnvIuB8JVWktrkxL+Ga0ThCIL8MTJeF2pJ6kQcFRgJVKsqMFQnKUiZb8YirpQOruSwvtKTr/S/eapaw9uU1nSB+wFMWvblfUkqnc9Hr/3vEc3i4bX7CPNafludVawJQe4195XARvGzeYznbaqRv/4dShZtJkd4VXY1IeBWFSgv6ejWihZAMNyaR9Iifflgcs2bp8HDOGcSYts9x/N+PmIGnNliSGe1yDbFfSJgTFbSCXDwIH0pYgAWVz8eLoPItJqxhmrPqxXaxFrIz3tYRcCa08ZJ3GSvGApcb22mNSUjFZv75V+s6gXyRjDM2vZQvACR/QGykJ4UV7ZkImjksU+k/AzWkAc4AkOiKzn5W4p6GkNLDV5UMTwlD4Yvdcg7PYJmmYnO3xrFx32JgPiGzYKF0q4Z8WfEJyhfgC99vinOoyf6QIuSlXL0X/XjKA3NvnKer2FWmjU+peR3Hfd3i8+wNhHKBs9ZNe1rp3sWd9eq2NaxtvjLfjBELxHmnH8Q2JBy40dXFeFwR0u/EQg4w6H512TaCFu7dJ0CvOEghAwVSZQXylWfMOMfg6rptsdZp0loKIx4Dk19SehzmNxR6AC9oR4/nBHXxvzkOOS08MJoxwWRibekx7WV1wOQOfCtLnboNosVF0ags2dhXHb8bBYczox9vxfGHdzCDR7fqh/nQg5KLJ6D5/ho5K/b5r
 wTjR7jWq
 mYR72QxVQpd4M0UR5IpjoGB8akNENKFWHC8qFGGFe/F5PSl3FVXUbWFFdx+BQgFes2zaR9ixgiOwpdEJt9pw+gsSQxhZ6PYZw9BIL2fnKKDQO1ruQqI+xEnxrWxxLMeVI9Yh2p/U23rPRK+s+IfoikZasnotoeFCV8hWlUU06FjgdF+rrMJbLOlrq/r6kQZulrxtj39xrGX8ANvmQJ3EqOSO5KsOVLvX/Q2UwVrmRAZvnx9EoC5KVuNFwHujwq5YoLuz7caJ0pJal2ug+fCmbFsjcnYKXm4a53EQ+zjs/ZEVgnjRBQTxRk5JSToLfHmT0HGmqJv2XYYQfyjp3nGdBI7xAn8RReS3zQbfo4RqVr7A43EhAGgUHEFD2AbilvKsVNzXnC2cZ2PuXf1ZPdFpUgHaVao3VZd7riY1nfQYJuIPG8pfnQ0nLUSWOxhhp/Ay7OSH0WPeNooYIBiwz2bb2mhU2wachPxyE9K0MyrVu99x7yPbI0PPtny31K1Xm+SR1wOIzxEX+pqeVPwQ9VmdQXld8Wem5Y+vZVEI04wcLwuOIyZq3Az3u2J9BPNskQ60L1AMEf7+zjOFBk75Ccd73H5qzVXWw8SxZOk7OQ1VtG9PSpw6vMmL+iQlkff7befXvHWQ8T0JvM5GiUx0uwIA+BkcanLkJ/jsh65XGLJjB5vcSxkB0gkqv2wV9PnKzJsyFEPVVEVRfx+w3f4unJFg2LwV6f0d0gDZYiFDKEnzOX90YTZutDHRsMmY98kJ9IRLmL8dl6H81UClH6oG/7MXhHcSZ/RKzgfpevG+1YvI+vafUt/cyQYezQ4Yv/BaUiqN38KLyy9Neoj0FdhNYaIPHSDr6In7Ix2crRqVBtPKPtHvToS3rnWBbQ5XprFhyE8mBUAW7KSFboHnQUymrxuYyOxtOJiqwZ1OWUdgbUOqFAwqhzBfYGg9CzUSMhw==
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
unreferenced object 0xffff88810005fa00 (size 512):
  comm "swapper/0", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    00 2e c5 05 81 88 ff ff 00 a2 96 0a 81 88 ff ff  ................
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc ee49fed0):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4520 [inline]
    slab_alloc_node mm/slub.c:4844 [inline]
    __do_kmalloc_node mm/slub.c:5237 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5250
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    alloc_full_sheaf mm/slub.c:2834 [inline]
    __pcs_replace_empty_main+0x1e4/0x260 mm/slub.c:4602
    alloc_from_pcs mm/slub.c:4695 [inline]
    slab_alloc_node mm/slub.c:4829 [inline]
    __kmalloc_cache_noprof+0x3ac/0x480 mm/slub.c:5353
    kmalloc_noprof include/linux/slab.h:950 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __irq_domain_alloc_fwnode+0x37/0x140 kernel/irq/irqdomain.c:95
    irq_domain_alloc_named_fwnode include/linux/irqdomain.h:271 [inline]
    arch_early_irq_init+0x1c/0x70 arch/x86/kernel/apic/vector.c:803
    start_kernel+0x931/0xb80 init/main.c:1114
    x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
    x86_64_start_kernel+0xce/0xd0 arch/x86/kernel/head64.c:291
    common_startup_64+0x13e/0x148

BUG: memory leak
unreferenced object 0xffff8881008f8c00 (size 512):
  comm "kthreadd", pid 2, jiffies 4294937339
  hex dump (first 32 bytes):
    00 d6 04 00 81 88 ff ff 00 92 96 0a 81 88 ff ff  ................
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc f2ef5290):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4520 [inline]
    slab_alloc_node mm/slub.c:4844 [inline]
    __do_kmalloc_node mm/slub.c:5237 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5250
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    alloc_full_sheaf mm/slub.c:2834 [inline]
    __pcs_replace_empty_main+0x1e4/0x260 mm/slub.c:4602
    alloc_from_pcs mm/slub.c:4695 [inline]
    slab_alloc_node mm/slub.c:4829 [inline]
    __kmalloc_cache_node_noprof+0x3ef/0x4e0 mm/slub.c:5366
    kmalloc_node_noprof include/linux/slab.h:1077 [inline]
    __get_vm_area_node+0xc6/0x1d0 mm/vmalloc.c:3221
    __vmalloc_node_range_noprof+0x1d3/0xe50 mm/vmalloc.c:4024
    __vmalloc_node_noprof+0x71/0x90 mm/vmalloc.c:4124
    alloc_thread_stack_node kernel/fork.c:355 [inline]
    dup_task_struct kernel/fork.c:924 [inline]
    copy_process+0x3e5/0x28c0 kernel/fork.c:2050
    kernel_clone+0xac/0x6e0 kernel/fork.c:2654
    kernel_thread+0x80/0xb0 kernel/fork.c:2715
    create_kthread kernel/kthread.c:490 [inline]
    kthreadd+0x186/0x250 kernel/kthread.c:848
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888105c53200 (size 512):
  comm "kworker/1:0", pid 23, jiffies 4294937917
  hex dump (first 32 bytes):
    00 a2 96 0a 81 88 ff ff 00 d4 04 00 81 88 ff ff  ................
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc d24dd055):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4520 [inline]
    slab_alloc_node mm/slub.c:4844 [inline]
    __do_kmalloc_node mm/slub.c:5237 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5250
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    __pcs_replace_full_main+0xe9/0x2c0 mm/slub.c:5700
    free_to_pcs mm/slub.c:5753 [inline]
    slab_free mm/slub.c:6154 [inline]
    kfree+0x352/0x390 mm/slub.c:6467
    vfree.part.0+0x1d5/0x4d0 mm/vmalloc.c:3485
    vfree mm/vmalloc.c:3456 [inline]
    delayed_vfree_work+0x5b/0x90 mm/vmalloc.c:3398
    process_one_work+0x26c/0x5d0 kernel/workqueue.c:3275
    process_scheduled_works kernel/workqueue.c:3358 [inline]
    worker_thread+0x243/0x490 kernel/workqueue.c:3439
    kthread+0x14e/0x1a0 kernel/kthread.c:467
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888105c52e00 (size 512):
  comm "kworker/u8:5", pid 4440, jiffies 4294937918
  hex dump (first 32 bytes):
    c8 2c 04 00 81 88 ff ff 00 fa 05 00 81 88 ff ff  .,..............
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc a68b63de):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4520 [inline]
    slab_alloc_node mm/slub.c:4844 [inline]
    __do_kmalloc_node mm/slub.c:5237 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5250
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    __pcs_replace_full_main+0xe9/0x2c0 mm/slub.c:5700
    free_to_pcs mm/slub.c:5753 [inline]
    slab_free mm/slub.c:6154 [inline]
    kfree+0x352/0x390 mm/slub.c:6467
    call_usermodehelper_freeinfo kernel/umh.c:43 [inline]
    umh_complete kernel/umh.c:57 [inline]
    call_usermodehelper_exec_async+0x1c7/0x1f0 kernel/umh.c:119
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff88810a96a200 (size 512):
  comm "udevadm", pid 5177, jiffies 4294938175
  hex dump (first 32 bytes):
    00 fa 05 00 81 88 ff ff 00 32 c5 05 81 88 ff ff  .........2......
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 94107438):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4520 [inline]
    slab_alloc_node mm/slub.c:4844 [inline]
    __do_kmalloc_node mm/slub.c:5237 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5250
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    alloc_full_sheaf mm/slub.c:2834 [inline]
    __pcs_replace_empty_main+0x1e4/0x260 mm/slub.c:4602
    alloc_from_pcs mm/slub.c:4695 [inline]
    slab_alloc_node mm/slub.c:4829 [inline]
    __kmalloc_cache_noprof+0x3ac/0x480 mm/slub.c:5353
    kmalloc_noprof include/linux/slab.h:950 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    kernfs_get_open_node fs/kernfs/file.c:543 [inline]
    kernfs_fop_open+0x4f3/0x580 fs/kernfs/file.c:718
    do_dentry_open+0x202/0x8d0 fs/open.c:949
    vfs_open+0x3d/0x1b0 fs/open.c:1081
    do_open fs/namei.c:4671 [inline]
    path_openat+0x154d/0x1e20 fs/namei.c:4830
    do_file_open+0x121/0x200 fs/namei.c:4859
    do_sys_openat2+0xa5/0x140 fs/open.c:1366
    do_sys_open fs/open.c:1372 [inline]
    __do_sys_openat fs/open.c:1388 [inline]
    __se_sys_openat fs/open.c:1383 [inline]
    __x64_sys_openat+0x82/0xf0 fs/open.c:1383
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888109d58400 (size 512):
  comm "udevd", pid 5176, jiffies 4294938222
  hex dump (first 32 bytes):
    00 12 47 2a 81 88 ff ff 00 ee 46 2a 81 88 ff ff  ..G*......F*....
    00 12 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc af8b5cec):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4520 [inline]
    slab_alloc_node mm/slub.c:4844 [inline]
    __do_kmalloc_node mm/slub.c:5237 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5250
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    __kfree_rcu_sheaf+0x164/0x240 mm/slub.c:5887
    kfree_rcu_sheaf mm/slab_common.c:1608 [inline]
    kvfree_call_rcu+0x1f6/0x3c0 mm/slab_common.c:1957
    kernfs_unlink_open_file+0x194/0x1b0 fs/kernfs/file.c:604
    kernfs_fop_release+0x55/0x110 fs/kernfs/file.c:783
    __fput+0x1b5/0x4f0 fs/file_table.c:469
    fput_close_sync+0x67/0x120 fs/file_table.c:574
    __do_sys_close fs/open.c:1509 [inline]
    __se_sys_close fs/open.c:1494 [inline]
    __x64_sys_close+0x4a/0xc0 fs/open.c:1494
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF


Tested on:

commit:         11439c46 Linux 7.0-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1277a202580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2c6ad6fefffa76b1
dashboard link: https://syzkaller.appspot.com/bug?extid=cae7809e9dc1459e4e63
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13801006580000


