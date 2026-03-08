Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85FE9F5513F
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 12:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B45386B0005; Sun,  8 Mar 2026 08:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF33E6B0089; Sun,  8 Mar 2026 08:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F19B6B008A; Sun,  8 Mar 2026 08:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 898C06B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 08:47:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1666F16049F
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 12:47:57 +0000 (UTC)
X-FDA: 84522872994.10.6C4F566
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6FB751C0004
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 12:47:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of 3mm6taQkbAIEx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3mm6taQkbAIEx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772974075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=wXpCrHnBOzbrjuCa4snuHa6G2PuKQUzS5Cx3HuD89MU=;
	b=bLcKOCoQlCFGQFCIXjoYSV4HcXqa3DhWrZfenQkRf4pkX32DCcWwT3iDerOGPoKfi/lkUO
	kRw10D6ZHYhNALtUtLmqYWoyWZJ4YV/6xk1YJQ0osKejMRvifzU9qbIW2eiOHK5wCJS4X9
	v5Zu5NJqNVptnwZHd0gB+lOjldS+JlA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772974075; a=rsa-sha256;
	cv=none;
	b=nTLH+TuIrZ4oZ5n23m+fOlUcb1PXujRRwrwc2J2cNCxgQh8C3loLdXj2zFq9aqkflBT8fN
	gvzv0r/CbR+HAAxnWNXbLD+ZHlsanIOtJ/vVOBlSzDypKexkUMuSTqVHdjuDNfyvcLg8SO
	KaO12EvE/5oxmMOGHC3wDed3z4u/A/8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of 3mm6taQkbAIEx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3mm6taQkbAIEx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c7378ffeeacso16744374a12.0
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 05:47:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772974074; x=1773578874;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wXpCrHnBOzbrjuCa4snuHa6G2PuKQUzS5Cx3HuD89MU=;
        b=SsA9Fqsm3jpgIZCai6uPHdGcYvj9imrEhLuveP/V1YI3mtJZ1P/qmB66diOzK61Ty+
         qWKVKn5WEir1sirgtCTV5ySghez9jWbyI/nZXzZfiUide7MN3dgluPz80oVo/oK94oxW
         DWzKchC1vrJT19GGc3Y3Tj8TekJ5Rbl8plac6zK9Qc1b6Idy8PG4bHSMSb1Tohb1h/Ui
         bNHcYvUbC00TGE2vM3yMMkEeLTvrMBT4gRrntbDpajvHubgUvLkGtg8Ppk6BHiuVNJT7
         ZYpbJ205THbru2CzDuP3LKL8ED2IejoVrgpjrf4oqNyAA4JXabjNG3oPGBg79NlwTlxG
         HwNA==
X-Forwarded-Encrypted: i=1; AJvYcCWn8LivkkvvCWrSpcw474SSYV/PJNwumjsYA7t2r52k5RCKbRdcSn8aHanoJq1OF8Q65tDN6UpcZA==@kvack.org
X-Gm-Message-State: AOJu0YwOtcjDVumplz+GONyUgDoXQBXM1zadrevWyveE4nNXxCss4ICI
	lilkUZzgMUC+7Gd99kX6ImNCCcGZdwBPX3tTdsOmeGeGaATpsSA6CqhSjaq9XwFl0tEUxQydGIj
	5qHXtAk2fb8CyIVuJK5Ho73Fta54N5SVFXWbz13SkIzuMqfWWijLlsW7yoik=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2188:b0:679:ea08:8fd6 with SMTP id
 006d021491bc7-67b9bd22c94mr5375108eaf.46.1772973722411; Sun, 08 Mar 2026
 05:42:02 -0700 (PDT)
Date: Sun, 08 Mar 2026 05:42:02 -0700
In-Reply-To: <aa1XpnY0TRvDGf4i@arm.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ad6e9a.050a0220.310d8.000b.GAE@google.com>
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
X-Stat-Signature: cu49gmixrty1gqe8ecp4ja9aqmw8wbn9
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FB751C0004
X-Rspamd-Server: rspam12
X-HE-Tag: 1772974075-699718
X-HE-Meta: U2FsdGVkX1/sHyTRhO2gRmiw4E5VW1oMK/0iO/mYmIRsDNU6OTe3vk2xUdk7Bh9DVzoifpPIjScNwX+qF9QgrzF/4Ti1g6sdlr+IvYOcHkyDb4IS8QHsrhJJQ7dM9jvVISnPD/SKsqZzD+xegAe9eftSUr3EdW0c88Um6++tDwzTYz7SDPkHsmoYV4VmAHDbzQ9/53fA/RBi4CvYXbIYP43Ga+2YU8meTlkdvQ+QFBIKCObiFsCqSCZZ2kJCH8xYRIMuT4MHrFBg4M7xOf63q/XBRiU/Pm1B4g2QxLbQf53lZQtQqzBOM1dN/Qp0fs4deouaRou5ZdWJ14VYpu4uZZ4c4Z3GEyIvmYeB+yOwBFbxsL9MG0PtBmGFzCw4CODo55kZ632ayhSKmECvrewbxNCbLkpZdGrJf/A+FAUKlpdcc0+Al1VmZ4zcb9LClUjHEaxNCgjA4VFbNZKEt0R/kJi4pm/BlU5G7Z+lidSou52jmMXZPS3shRImgG62VsWUVS7XZQXAvM/89j/5hhg8tpo/kd5khawHTdNbicTplbbyU4RAgwTbRpGZQS1s0mQ3W9HUO6/doFPuAB6JJcsVtbNlRhqoZnVNz0TXkytHNlBmv9Xc+XyvY/iuhGVeWVEFhn6pklniUrvvMhMoYKviPeaAlvQPo/HgNKk8rQwj/bQ402vEmxa6aa17CMs6kZFNcc68tNvuwRSwSwxsk8pKbE1ixpDtOu85KONcTl7blo253DqGbIauPcd6uE31wZDmdsNR30mFtkGqNHUCmPoGeIHg0LkRZdo86/xSoN09fVfGuEsg8Egp7asH8hOZmlxLk6Gh2IqbJOu6NgssukL+ekvD7AsNDJ6OJCG6spFf7oXrDtWjhx+cDi2wc0PrLA3eLwvQJRGbYcbbwbdTRrO+nyJVVySWcozNDaR3NL7agARwOVW8HQjAFT1KtM7Qkd8ubO0kR9nGmGY2nmxx3tQ
 4UWIOd7K
 Ww4G+pPyt2HsXIZ4hM2VieCsRZL5MtHBXXcnddWkJB/UNGVCCkGr4mkLKeMn0HvpA9S1foXGT0Ss2qhPJxZrzKfeC+zw/RpRk286y9En89/NOIvlEFVq+/HLI75XxuyejOrok4Yh0VdBJCb4m5JoDQNZnnQjXEcVo4i9YifnR4KjS2sm7vbIDmecPkqWegjthJwODN7rb0pKbCnZxOkuR/BH7eqYwsa8xO5hwhYzPeOe9TbFO9eIfNI6m2TOPBx8PsObnQKzxZ6GUJ+YIKeyWNQ4nZfAYlss1V7R/ryQff5C8CFDQQ1iUb12Lhch3EUTXwZ7YgM9q5i2TrJlBaPtOlM0JuGf8w7rXL9G18CLY1zLUc9RLZAA/sw69Sjq1nGdOWLpI29FY575VPpGGU+JBH86vSenYa91v+0nmZR0VCjsLUnpyh8NUKlSsYmcinw649lC4MCiSzrYIeaxvlSt/0O77PXrRPb9oPGrBhPs/nnWPNJrKaasNJGQ0lG9NwBrPqM+6K4t7tCp/gTyfNTsWFk0JljzWzqvsAUsV5NjC2ay9QyvwnHlTS0q39iHpLWgjE+TLoUfH7OPMvJvZKRjp+2g0JqX05omsFQKRY9u40jlraG9V2dZk+zYUg9tvIPHN5wx6i+j3zrzVv9hHT8+VGaDBddu5QDdhVoXi
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
    00 2a 90 00 81 88 ff ff 00 94 30 29 81 88 ff ff  .*........0)....
    00 12 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc a3e5799):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4547 [inline]
    slab_alloc_node mm/slub.c:4869 [inline]
    __do_kmalloc_node mm/slub.c:5262 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5275
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    alloc_full_sheaf mm/slub.c:2834 [inline]
    __pcs_replace_empty_main+0x1d2/0x260 mm/slub.c:4629
    alloc_from_pcs mm/slub.c:4720 [inline]
    slab_alloc_node mm/slub.c:4854 [inline]
    __kmalloc_cache_noprof+0x3ac/0x480 mm/slub.c:5378
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
  comm "kthreadd", pid 2, jiffies 4294937344
  hex dump (first 32 bytes):
    00 94 30 29 81 88 ff ff 00 d6 de 0b 81 88 ff ff  ..0)............
    00 12 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc 9181eca5):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4547 [inline]
    slab_alloc_node mm/slub.c:4869 [inline]
    __do_kmalloc_node mm/slub.c:5262 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5275
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    alloc_full_sheaf mm/slub.c:2834 [inline]
    __pcs_replace_empty_main+0x1d2/0x260 mm/slub.c:4629
    alloc_from_pcs mm/slub.c:4720 [inline]
    slab_alloc_node mm/slub.c:4854 [inline]
    __kmalloc_cache_node_noprof+0x3ef/0x4e0 mm/slub.c:5391
    kmalloc_node_noprof include/linux/slab.h:1077 [inline]
    __get_vm_area_node+0xc6/0x1d0 mm/vmalloc.c:3221
    __vmalloc_node_range_noprof+0x1d3/0xe50 mm/vmalloc.c:4024
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
unreferenced object 0xffff8881008fd600 (size 512):
  comm "kworker/u8:6", pid 223, jiffies 4294937434
  hex dump (first 32 bytes):
    00 c6 8f 00 81 88 ff ff d8 2c 04 00 81 88 ff ff  .........,......
    00 12 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc 33698a2f):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4547 [inline]
    slab_alloc_node mm/slub.c:4869 [inline]
    __do_kmalloc_node mm/slub.c:5262 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5275
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    __pcs_replace_full_main+0xe8/0x300 mm/slub.c:5725
    free_to_pcs mm/slub.c:5778 [inline]
    slab_free mm/slub.c:6173 [inline]
    kfree+0x352/0x390 mm/slub.c:6486
    call_usermodehelper_freeinfo kernel/umh.c:43 [inline]
    umh_complete kernel/umh.c:57 [inline]
    call_usermodehelper_exec_async+0x1c7/0x1f0 kernel/umh.c:119
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff8881008fc600 (size 512):
  comm "kworker/0:1", pid 10, jiffies 4294937441
  hex dump (first 32 bytes):
    00 1a 39 10 81 88 ff ff 00 d6 8f 00 81 88 ff ff  ..9.............
    00 12 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc fca1c70a):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4547 [inline]
    slab_alloc_node mm/slub.c:4869 [inline]
    __do_kmalloc_node mm/slub.c:5262 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5275
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    __pcs_replace_full_main+0xe8/0x300 mm/slub.c:5725
    free_to_pcs mm/slub.c:5778 [inline]
    slab_free mm/slub.c:6173 [inline]
    kfree+0x352/0x390 mm/slub.c:6486
    vfree.part.0+0x1d5/0x4d0 mm/vmalloc.c:3485
    vfree mm/vmalloc.c:3456 [inline]
    delayed_vfree_work+0x5b/0x90 mm/vmalloc.c:3398
    process_one_work+0x26c/0x5d0 kernel/workqueue.c:3275
    process_scheduled_works kernel/workqueue.c:3358 [inline]
    worker_thread+0x243/0x490 kernel/workqueue.c:3439
    kthread+0x14e/0x1a0 kernel/kthread.c:436
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888100902a00 (size 512):
  comm "kworker/0:1", pid 10, jiffies 4294937448
  hex dump (first 32 bytes):
    00 c4 58 09 81 88 ff ff 00 f8 05 00 81 88 ff ff  ..X.............
    00 12 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc 8a5f0c0d):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4547 [inline]
    slab_alloc_node mm/slub.c:4869 [inline]
    __do_kmalloc_node mm/slub.c:5262 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5275
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    __pcs_replace_full_main+0xe8/0x300 mm/slub.c:5725
    free_to_pcs mm/slub.c:5778 [inline]
    slab_free mm/slub.c:6173 [inline]
    kfree+0x352/0x390 mm/slub.c:6486
    vfree.part.0+0x1d5/0x4d0 mm/vmalloc.c:3485
    vfree mm/vmalloc.c:3456 [inline]
    delayed_vfree_work+0x5b/0x90 mm/vmalloc.c:3398
    process_one_work+0x26c/0x5d0 kernel/workqueue.c:3275
    process_scheduled_works kernel/workqueue.c:3358 [inline]
    worker_thread+0x243/0x490 kernel/workqueue.c:3439
    kthread+0x14e/0x1a0 kernel/kthread.c:436
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff88810958c400 (size 512):
  comm "kworker/u8:5", pid 4599, jiffies 4294937964
  hex dump (first 32 bytes):
    00 4c 6a 12 81 88 ff ff 00 2a 90 00 81 88 ff ff  .Lj......*......
    00 12 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc 45e572cd):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4547 [inline]
    slab_alloc_node mm/slub.c:4869 [inline]
    __do_kmalloc_node mm/slub.c:5262 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5275
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    __pcs_replace_full_main+0xe8/0x300 mm/slub.c:5725
    free_to_pcs mm/slub.c:5778 [inline]
    slab_free mm/slub.c:6173 [inline]
    kfree+0x352/0x390 mm/slub.c:6486
    call_usermodehelper_freeinfo kernel/umh.c:43 [inline]
    umh_complete kernel/umh.c:57 [inline]
    call_usermodehelper_exec_async+0x1c7/0x1f0 kernel/umh.c:119
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF


Tested on:

commit:         c23719ab Merge tag 'x86-urgent-2026-03-08' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10027054580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2c6ad6fefffa76b1
dashboard link: https://syzkaller.appspot.com/bug?extid=cae7809e9dc1459e4e63
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17682a02580000


