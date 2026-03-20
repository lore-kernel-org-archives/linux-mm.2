Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07851108B8ED
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EDD26B0005; Fri, 20 Mar 2026 06:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09EF16B0088; Fri, 20 Mar 2026 06:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6E06B0089; Fri, 20 Mar 2026 06:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD4F66B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:34:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78D1FC04DF
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:34:07 +0000 (UTC)
X-FDA: 84566081334.02.43F359B
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by imf15.hostedemail.com (Postfix) with ESMTP id 245CBA001A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:34:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of 3miK9aQkbACkXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3miK9aQkbACkXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774002845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=PyurhFL0srbaHFfNujAbyanPsO6WBW5rLYYsYSOSV7A=;
	b=zKfAeiZNq1wokebq0YdMRogVOjgZ+EdpVaUL3z/rCTc+I0QT/83cF/Iw7tKuG58KELpYQh
	Qzl5sesUmefVngLArZZEBDFmlLQ4TbdYVv6QWZZ7GiZymcNpL/T9MFeFEvWNH6BURkBHyF
	VrYsm/weNYUAlaCMIcPBdzc02/M5hkM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774002845; a=rsa-sha256;
	cv=none;
	b=6egsriM3CtQFZiUYB8lRx4tIVr3xe0oummFaboQuQRUQoi1z5eHnFpQ3TkloRM2Oe3QnVn
	tEvtVfm1K2iKcDSt3l7ZCnfqSNVaxO8n6z/ajqSAhSQSkK5SAt2L4fh4ybuQuwBXoy/LAb
	dRhKhhPq/c23pkSkWAOqsHZsa8mBP6U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of 3miK9aQkbACkXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3miK9aQkbACkXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-67bc5678917so3377895eaf.2
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:34:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774002842; x=1774607642;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PyurhFL0srbaHFfNujAbyanPsO6WBW5rLYYsYSOSV7A=;
        b=U2ONillcizU0+c8Y6+x5o2oZ8VE4jnEVQKkAdpdN/QxGOCn7oh5CNIskvP/QWe/Gjs
         h16KcLzpDLd56qTmqvnhBtM/CarS9B/Z7skh14bN3b0yzMB0oB7TdX4A1Az+s4Byb6ZP
         cVH+SGWCF0d+GXvFjTFeOcxJ4/F5u+abd2MpvCGF3Fcm1WHyjQQxSoUozfq+bhwpcLV2
         x8Wya9DsxOtKjceupql9AA/HqKsvf6q2yY0ob7I4nb3slNWhqqHiX6lSt4ypP4LcG4pr
         TMajqPzn/bbXtMssPlXbVv8hqqrWrxDfbHVVSzEELC7+wpnT3BKC8dotvSDTkRSeQCBG
         ORtg==
X-Forwarded-Encrypted: i=1; AJvYcCXH3v4b+mq0KNlPbSsGoMd2fsGvZjX6FUeOxqmAWRIxFewaPaeoDT3M6dvKe/HmOpBRq9SXOfoQGQ==@kvack.org
X-Gm-Message-State: AOJu0YwIDIyWYkzOuYqiCSp/rr+WUBE1zHpzX2RNqlONVKtOIbX/u9Oj
	xlbIrNEo9VQlKCtTtu/B2ANrw74SHTePLtVidR5RYvwQuFXOSt2sTqXeef/LC3KmNTSMMY//+zy
	HR0I5KNvlBvM14SrRvNmWX1wdJFIQRRrNkeORtV5VSlTdleen+h3f19bzaSM=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:818b:b0:67b:e3cf:a416 with SMTP id
 006d021491bc7-67c22ec467emr1960545eaf.25.1774002842204; Fri, 20 Mar 2026
 03:34:02 -0700 (PDT)
Date: Fri, 20 Mar 2026 03:34:02 -0700
In-Reply-To: <abyPiI_4bCRGQLBV@hyeyoo>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69bd229a.050a0220.3bf4de.001c.GAE@google.com>
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
From: syzbot <syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, chao@kernel.org, harry.yoo@oracle.com, 
	jaegeuk@kernel.org, jannh@google.com, liam.howlett@oracle.com, 
	linkinjeon@kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, pfalcato@suse.de, 
	sj1557.seo@samsung.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 7f5q6cuedxstqfq845ifkqmshsrrkkb9
X-Rspamd-Queue-Id: 245CBA001A
X-Rspamd-Server: rspam03
X-HE-Tag: 1774002842-404980
X-HE-Meta: U2FsdGVkX18XVNPss0jKUkGxicIgWJ/LkJSBqcSAAT2D4jh/C4srakV6PfnMDx08xJGsmiTFBOxdDkla2CxfAgMP2Hl8DiwjGQT9U9NYek8xgaZqmiZHkbNORRvkyoJ+0qR5DVB/oXez+rmukmRmw6Yj9b5TTuoLcPoZJP1YnYG83IleJU4LXCcRqaw8rjL8bUUgz7q/hoCh3pti6ZH+n7YeGo+dA2ckESj6cCkAjU+dupzoW5cHcf7zBcEewdUCikQkxszWIBxKNsSLvUV6eJnEmRKXzNh0y2ArIXhqKfVwghpniy2AqW3r7dEdcOLz8Igermae69+a93sl4VzIqvJNm4ZCAeBAzCq7aXhW/Z7EW9XzQbzMZ3INzy4xcQOV8PBASQEGl79EO2b0w2Xx4NBnUhIt9thGlYUMtBvVSMbZd93QPx5PBvsmnyn70dVkOuIQd+g/hvSKf1j++uCoxzD5no4vyEuIV5HcQFFiyF5cU9eZorBgkV8kc56MSNtmWSTmQJbxioW4uXT7XfBQQma3yU563ut3Rt5ACY4c34xO2FuBD6t/deQHPX8H/Hs8hpWhtpiWBHZIxAw6uTUZ2Tm235Vr9wmb0+FNu5v4KZ+fLsk4FEU0/gM0riqmmrt+cNPle95GOwOb+MKaTe4zeYz4qVzZ75okkFnmsl0/moO9i7gZnfverjzxPtcpCvc3c1xTeJBIOmG7pGFxNjeVtyJjK7YTWywiWHczbB5wsxcPdx/0cL7jDdYyXVrpI5tvkXHk90TwkvdwP1Fyyee2IR005RPJHuwDEVaXnMkzniII2J8g0uvJVMJCFDecAwVnZQ9CByq2WuQ/COoFa4o7N8K+i/jSAsO4uLRVxC2IsSiTXqINeGdrk67w7Ven+EbJPgQO8o3NnG9ELhhKnUPCYGXffVjV4ui/m0nL+o0E6z0ahDqgC69Es7acEs01Xvvb99uQTG4Icz7aM6opeUb
 GKhreVFm
 imkBXBMdJlJ4dinFqRWnnNeAYBg/pYNge/BupyE3Ga78YiEN3JVJwUxXFVEgtN24kdrGl5wFNwHxv9Xc4xp5/SDGvSIB36L5PsIpXH5c3pK41ChqVeaokmg0NDWVgXrRXbVivNsUtefy4rt8yT1KZzKoCCB1YOu4fmoWlH3LaiP1SgjotvrPtlTAbeqo1bHKavQAqGuapyqzyqB7shHhKkHgacLtSAcYAnxBe9ECTDvHfxGMVAlysnaAe4bwevZVbrJXsX0eXSlV8jDeSItmEr5dpyNfaKWXckQ3P7+g31aeKRht/hjaaSW+rqDjtzpWURs7IP/N6WxsTfZjLDzUY2erutUU4k2EtmtMQTe8cN6d7tA5X+YnAkxy0tseAGli84TZEXYPqZisLaZpPwZtzTElNGXQCpshVEB3WtJoO/Ho8UvWLcTTCZjJAjTcAE2tAbt9c/n319Xq9VZbnFKjEIT/aVj9OnGfLiBCjJw47Au6jO6TZh8aIaMUW1WCU+9+F2aF4pkjU9+olcVFGJjLBKNjXEhvnIu9x2I/8rbV4OAiEsv8hUeVVf8pGNLriwVYuktGsZW1aiCRw6yXish8WKDxWvWAwY5L2ujjIf3Um5DYTT2tKRpE+VMm4wsJlhEKaESyGGCaEUQ2XVsKAk2rbxhAYhB5O+tshYIk/wH8HamPCvQjNTzU5CgoAEDBbbArTinfsNfzEtHJAdh8jCBLMQuFHFvlhh3w9G2q/TFOYHc0QN5YVBBHRO6+ZAZrrmd+6D6HZXxHn6nVVZD5awADmPFxCcgoRvIQi9W5uK7ss2wepnGHG5NqQ2SvMuX2YAa2P8GP1aRwBg7dNxONRdZyAMQvM+d6sJHhPQ5iJqrwLdbZ1aa2pj0FTwe2Xe2Kz/zABZpOWc/w7VJc9Oz2YKFRGX4UKtOuLWR5RdEfA1A9fwu+UA9mdc1/ok/fK07/olRZdKd9kFlHeWntKhy7fELU12iXT9Omb
 MWEaS9WH
 ea3XxCrICl+mqZHPrAGcsST8S4a5v5KkgHCJALBV2Xj40tascttBEA==
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
unreferenced object 0xffff88810005f800 (size 512):
  comm "swapper/0", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    60 bd 2a 2f 81 88 ff ff 30 ba ad 81 ff ff ff ff  `.*/....0.......
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 81834c79):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4543 [inline]
    slab_alloc_node mm/slub.c:4866 [inline]
    __do_kmalloc_node mm/slub.c:5259 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5272
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2764
    alloc_empty_sheaf mm/slub.c:2779 [inline]
    alloc_full_sheaf mm/slub.c:2829 [inline]
    __pcs_replace_empty_main+0x1e0/0x2f0 mm/slub.c:4626
    alloc_from_pcs mm/slub.c:4717 [inline]
    slab_alloc_node mm/slub.c:4851 [inline]
    __kmalloc_cache_noprof+0x3ac/0x480 mm/slub.c:5375
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
unreferenced object 0xffff8881008f6c00 (size 512):
  comm "kthreadd", pid 2, jiffies 4294937342
  hex dump (first 32 bytes):
    d0 16 c9 29 81 88 ff ff 30 ba ad 81 ff ff ff ff  ...)....0.......
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 38b48d73):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4543 [inline]
    slab_alloc_node mm/slub.c:4866 [inline]
    __do_kmalloc_node mm/slub.c:5259 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5272
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2764
    alloc_empty_sheaf mm/slub.c:2779 [inline]
    alloc_full_sheaf mm/slub.c:2829 [inline]
    __pcs_replace_empty_main+0x1e0/0x2f0 mm/slub.c:4626
    alloc_from_pcs mm/slub.c:4717 [inline]
    slab_alloc_node mm/slub.c:4851 [inline]
    __kmalloc_cache_node_noprof+0x3ef/0x4e0 mm/slub.c:5388
    kmalloc_node_noprof include/linux/slab.h:1077 [inline]
    __get_vm_area_node+0xc6/0x1d0 mm/vmalloc.c:3221
    __vmalloc_node_range_noprof+0x1d3/0xe50 mm/vmalloc.c:4024
    __vmalloc_node_noprof+0x71/0x90 mm/vmalloc.c:4124
    alloc_thread_stack_node kernel/fork.c:355 [inline]
    dup_task_struct kernel/fork.c:924 [inline]
    copy_process+0x3e5/0x28c0 kernel/fork.c:2050
    kernel_clone+0xac/0x6e0 kernel/fork.c:2653
    kernel_thread+0x80/0xb0 kernel/fork.c:2714
    create_kthread kernel/kthread.c:459 [inline]
    kthreadd+0x186/0x250 kernel/kthread.c:817
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888102011400 (size 512):
  comm "kworker/u8:1", pid 274, jiffies 4294937433
  hex dump (first 32 bytes):
    28 f6 7b 31 81 88 ff ff 30 ba ad 81 ff ff ff ff  (.{1....0.......
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc c5ce2dfb):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4543 [inline]
    slab_alloc_node mm/slub.c:4866 [inline]
    __do_kmalloc_node mm/slub.c:5259 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5272
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2764
    alloc_empty_sheaf mm/slub.c:2779 [inline]
    __pcs_replace_full_main+0xe8/0x300 mm/slub.c:5722
    free_to_pcs mm/slub.c:5775 [inline]
    slab_free mm/slub.c:6170 [inline]
    kfree+0x352/0x390 mm/slub.c:6483
    call_usermodehelper_freeinfo kernel/umh.c:43 [inline]
    umh_complete kernel/umh.c:57 [inline]
    call_usermodehelper_exec_async+0x1c7/0x1f0 kernel/umh.c:119
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888102010600 (size 512):
  comm "kworker/1:1", pid 41, jiffies 4294937437
  hex dump (first 32 bytes):
    88 c3 c4 29 81 88 ff ff 30 ba ad 81 ff ff ff ff  ...)....0.......
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 5d48f1c0):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4543 [inline]
    slab_alloc_node mm/slub.c:4866 [inline]
    __do_kmalloc_node mm/slub.c:5259 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5272
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2764
    alloc_empty_sheaf mm/slub.c:2779 [inline]
    __pcs_replace_full_main+0xe8/0x300 mm/slub.c:5722
    free_to_pcs mm/slub.c:5775 [inline]
    slab_free mm/slub.c:6170 [inline]
    kfree+0x352/0x390 mm/slub.c:6483
    vfree.part.0+0x1d5/0x4d0 mm/vmalloc.c:3485
    vfree mm/vmalloc.c:3456 [inline]
    delayed_vfree_work+0x5b/0x90 mm/vmalloc.c:3398
    process_one_work+0x277/0x5f0 kernel/workqueue.c:3276
    process_scheduled_works kernel/workqueue.c:3359 [inline]
    worker_thread+0x255/0x4a0 kernel/workqueue.c:3440
    kthread+0x14e/0x1a0 kernel/kthread.c:436
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888102010400 (size 512):
  comm "kworker/u8:1", pid 443, jiffies 4294937439
  hex dump (first 32 bytes):
    e8 50 dd 31 81 88 ff ff 30 ba ad 81 ff ff ff ff  .P.1....0.......
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 11032afc):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4543 [inline]
    slab_alloc_node mm/slub.c:4866 [inline]
    __do_kmalloc_node mm/slub.c:5259 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5272
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2764
    alloc_empty_sheaf mm/slub.c:2779 [inline]
    __pcs_replace_full_main+0xe8/0x300 mm/slub.c:5722
    free_to_pcs mm/slub.c:5775 [inline]
    slab_free mm/slub.c:6170 [inline]
    kfree+0x352/0x390 mm/slub.c:6483
    call_usermodehelper_freeinfo kernel/umh.c:43 [inline]
    umh_complete kernel/umh.c:57 [inline]
    call_usermodehelper_exec_async+0x1c7/0x1f0 kernel/umh.c:119
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff8881095d5a00 (size 256):
  comm "swapper/0", pid 1, jiffies 4294937857
  hex dump (first 32 bytes):
    00 d4 9c 1d 81 88 ff ff 88 fc 04 00 81 88 ff ff  ................
    00 1a 04 00 81 88 ff ff 1c 00 00 00 00 00 00 00  ................
  backtrace (crc deebd371):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4543 [inline]
    slab_alloc_node mm/slub.c:4866 [inline]
    __do_kmalloc_node mm/slub.c:5259 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5272
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2764
    alloc_empty_sheaf mm/slub.c:2779 [inline]
    alloc_full_sheaf mm/slub.c:2829 [inline]
    __pcs_replace_empty_main+0x1e0/0x2f0 mm/slub.c:4626
    alloc_from_pcs mm/slub.c:4717 [inline]
    slab_alloc_node mm/slub.c:4851 [inline]
    __kmalloc_cache_noprof+0x3ac/0x480 mm/slub.c:5375
    kmalloc_noprof include/linux/slab.h:950 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    init_srcu_struct_fields+0x29d/0x320 kernel/rcu/srcutree.c:241
    rtnl_link_register+0x81/0x1c0 net/core/rtnetlink.c:615
    ipgre_init+0x10d/0x1a0 net/ipv4/ip_gre.c:1828
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

commit:         0e4f8f1a Merge tag 'parisc-for-7.0-rc5' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13b18cba580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e2bba615ee79faa5
dashboard link: https://syzkaller.appspot.com/bug?extid=cae7809e9dc1459e4e63
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12608cba580000


