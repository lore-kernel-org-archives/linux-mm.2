Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E84C104C00E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 11:03:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CB956B0005; Wed, 11 Mar 2026 07:03:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379A16B0089; Wed, 11 Mar 2026 07:03:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27F856B008A; Wed, 11 Mar 2026 07:03:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 00E5D6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:03:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8703659CF9
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:03:08 +0000 (UTC)
X-FDA: 84533495256.17.1C5DCBC
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	by imf29.hostedemail.com (Postfix) with ESMTP id D9416120014
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:03:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf29.hostedemail.com: domain of 36UuxaQkbAJoMSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=36UuxaQkbAJoMSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773226987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=00o6g65oUdrN243+trpF7SWGsKEiuTr8VPwUn01kWqM=;
	b=g3UG/iaHIL8zU/YnMu0F6JPZ7195hmQhaCJ5gTIjDMo4dkA6l64cByBScPz/AgUhw5fS25
	JIMpXyViGhg9taEhl6PjiJevolXn+wvNWPe0MzyNnnqTRdpF/RwQra2aMCUoLqVb4iRg1t
	YHYnWrjno3jMutQTkCdTEg/n3N67tco=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773226987; a=rsa-sha256;
	cv=none;
	b=e2aJ2xgiXChw/yIIZ+HmTgxVyM6ofoAW6BjiuSSpOQJ/IWaJdp33AAg12lj2fSQY6yYHAH
	RPXmMkDcJamCPKlSe+m3NSJ720ZrvsjMo/L14w2wAAxGkdZ3iqPi4k4ZFaJ/Zk8hKILGs8
	coigCFTANBFRwz2H11iJ3IyvCMSfQLM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf29.hostedemail.com: domain of 36UuxaQkbAJoMSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=36UuxaQkbAJoMSTE4FF8L4JJC7.AIIAF8OM8L6IHN8HN.6IG@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-67baeba7a53so9168177eaf.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:03:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773226986; x=1773831786;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=00o6g65oUdrN243+trpF7SWGsKEiuTr8VPwUn01kWqM=;
        b=RI0AVqsaoQ3RXdAn2j4tHecWOTDQEntXdDTL1Y/bdF/dMGyEJrhbzGwiUPWZMeijiZ
         t/V/IEznUc/lsV0VqTg4NsAMeUJ5SG424WFZ1z6B6oMkPB8jjFBYr3rJG2hTRF8Tu7ip
         ynV1EFbUKPRx1h91wq/uAAgDoOjHXLUE712cbV3+pzEgRJs2fGlRLQtVjtLURTs6j0ud
         LsvRYWLMPkg7OG1chlCcjIO3negHk/r8bF/kL3MbeZqTfuP9WLRIG5WNNBPjkuJzyBUM
         y84Dj6z2n6y5NO/jIZBj2NYc5YBp4Rqk2vTCDEJOqtMSv03ziwlq+NNPyaNmaB6a8zrR
         jo6g==
X-Forwarded-Encrypted: i=1; AJvYcCUa4l8ALvVu/EGPlwa+ntQS2WWDEcMr6kkPZmcbrIrvrwHbT6GQxP0FF2XvjaNo5QXtFci2y4R7qg==@kvack.org
X-Gm-Message-State: AOJu0YyRG3SfVbvxJHKodbDZ+zPma6iOvaF7Gc/RlMJ+KfAvz9T54rOC
	MWJWdGjeWzwYppZ3skY7juVnCb/qNmf4HSy93cRpDkfCMGmpIlPUF97EuBgaeIa3Tsk438hPsoM
	KYKpV1nyerfEMGtQXqAXn1M12hvJCgVEvOngHhrcdpN/k7CKnVOtkSSK2Hro=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c9e:b0:67b:b63b:6fe4 with SMTP id
 006d021491bc7-67bbc7330d5mr4435697eaf.19.1773226985864; Wed, 11 Mar 2026
 04:03:05 -0700 (PDT)
Date: Wed, 11 Mar 2026 04:03:05 -0700
In-Reply-To: <20260311104855.102050-1-wangqing7171@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b14be9.050a0220.209d0e.0001.GAE@google.com>
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
From: syzbot <syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, chao@kernel.org, jaegeuk@kernel.org, 
	jannh@google.com, liam.howlett@oracle.com, linkinjeon@kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	pfalcato@suse.de, sj1557.seo@samsung.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz, wangqing7171@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D9416120014
X-Stat-Signature: aisdjxsnygr4bf44uky4u3xk4om7rq95
X-Rspam-User: 
X-HE-Tag: 1773226986-733030
X-HE-Meta: U2FsdGVkX18Rxpy3xL6kDUWUrzT647MQlYFNMQ2w8E279sfik7NyocQtFny7rcmiMyzsdwPa/KSdnUOvcj6WDmPemDNdNxy/fn9H1aLP+a2vwb8jN+EOMqvfmEgWs/bRyfR5u0BSdt9+g1/8fYYzAUErgspvxxcn73lrLWFckMliMmkT1gczXhpgGhYfIHDs8RY9jb1eBqtSfXeLoEor+ym6h29akfgrYEK6uCUJP+B1qipjAryYaLGIZYzEPSqGgdVqh6DTYKrP/leRJcWrHmoSiMkFDUFHW9VH3WrhEvjhv8pJWz4S+AVr/38LbZNpo6cm5wzzzK0ms+wTOqQdtGuUoGHViYCndWxue1lq5i/a5pQ4GuC/vEM3CdLiWea2TEWmRHckAEl+blrRuFvwKkKXHdpMPLvkqkumPmr+HReCJnrJaNX8UDMPm/Pxi3sJmMkmLmb3S+3mumOXF/rgXIyVM8Ui10kQ26e2rQCWVbyqoXOmf0PWlf8cvhU/7KS6RJxhfeidw+/EOL5ntB8CKglCUbZIPDg1XlkwfAu1uoDm6+/Uz96Nz8Rz4L4B1sjnrbFz/zV5QwUhGTN4TDf4bMhbAcWXYPMfzcJvQCnTd60ZKYoY1/dPl4GhqOSe2WM5Q7hN7JdmnKT4GiDQaueZI2Y/vEb9wrRFKUtXpV0PcFd49OeqCr9pJI03K6IK4snVb+2bZ3D/JdltS0Z0vsA05IddD3t+TQAwYJCzoyaNFhO1I1RwmyhczKo6DlBxzyZ7tfizE2vHP+qr1J+rKYj9MsUTDA1fdKm3oJOkQnVFQG9avJuxp8UYTYf/VswjItZNq5iPvMVUGw0vH5icutTV4l/YUW9UWRbp0O8c0brcyywe9pqgGAszrJbql0qdEqjuTg2Sr9PRdlcRvUpswqpGOm4Q/7w2fYd0hx/bN7YSztloQckJlN1bzXBWxFqAzuAfM8RnYCZTP/2C4dFIbyV
 cTvxsv3/
 7gSm9x2/yoxC0VzxgghgND90AF1NhphVma3fTWeR/G9lMWkph4B+CeCh6c9BmtTMg0qkV2Zs2UH7gtLXsSResNjKgT6uEoGV4mth0whHb9gNpmQgvrrIEp2QIBLn1XH1V8BHd3hGXUqXT3DBkqgSAbhpOJ1u/z6/6FerVeeS3ceUpvkRSFMuU+0YHVTfX/LVoNBY9R5yHOjoaxsT1VZDyn85TLoTlsxhx03M0RM3ZXh2Vhc8fITRYA/swRZD53i2Y5UpLZOFT2I1erBy+r2BWuPmPHrxUneKCd7swbu1fP5w14M/LAcmqqLuMf5qyv65OEAJmpTCHl+YgN4LbLdAglHzu6m0raKURr0Bj+XeqXIE0mlMdicFrY88xmK1UqxppFWz9ecIiIMS9ChZ8/4aYi2PJ9eVpddFeEvlipc8I122blylnu+dvjQen/OZOQEAxSjViKDxGaWplhb1zqilQAf7FjabnKa9fwLK160JaS7ZUkys70wxK46naTl8HobmyBZF6M9wuQ4EZlAUKL1QQ8CxrkdPiN/rKUMUgSm94JUstbcom1wZKkjlUQeqlQFiXHHeQUSxVr8Ra02mgwpmLB1A/t9ZUrP0P60Znfg0gxwGoZEIuxVML2n9zSBf+qKoKeLU3G9NsszvDlIPdZ0oPnC9oWsy6BAZ8YliUWKRo5tSbMpjqhuEHjmLtV1hkUkehr/qKyL4TEoyXTp0qhsqSMiBCiwUY1OdcSRNhtniHjgB1bX0pGC/v1U07i65nq4A/T5FvvVXpujSjp9vzs9NSOPiYSyqUb+ezppT8nMf3g08XWNgR8iyreCRPeTcVpszC4QBVmU3A0bEUMtpdAx7SWxb6xITHUkStl4gxnGGbASmq2AWZVQIbS9yWxS3nnXUR5bFNlIsTFt3SMQKC1lPwQOOJL1sUEbp01WbWtZs19rrKxIYEZ3THAZZOxxQd+I4cIGyXf69haOVcu4tDaAgjvcvmPDRg
 6m0WXqQ/
 rlQ5xhfzD5FyXSNYAanm61+5pfrDDtTWCHUy3AUAw+44Uuru/XHl4A==
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
    18 ca 17 2e 81 88 ff ff 00 b6 ad 81 ff ff ff ff  ................
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 9b7d1e76):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4550 [inline]
    slab_alloc_node mm/slub.c:4873 [inline]
    __do_kmalloc_node mm/slub.c:5266 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5279
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    alloc_full_sheaf mm/slub.c:2836 [inline]
    __pcs_replace_empty_main+0x1e0/0x2f0 mm/slub.c:4633
    alloc_from_pcs mm/slub.c:4724 [inline]
    slab_alloc_node mm/slub.c:4858 [inline]
    __kmalloc_cache_noprof+0x3ac/0x480 mm/slub.c:5382
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
    08 5e e1 28 81 88 ff ff 00 b6 ad 81 ff ff ff ff  .^.(............
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 89324f2):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4550 [inline]
    slab_alloc_node mm/slub.c:4873 [inline]
    __do_kmalloc_node mm/slub.c:5266 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5279
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    alloc_full_sheaf mm/slub.c:2836 [inline]
    __pcs_replace_empty_main+0x1e0/0x2f0 mm/slub.c:4633
    alloc_from_pcs mm/slub.c:4724 [inline]
    slab_alloc_node mm/slub.c:4858 [inline]
    __kmalloc_cache_node_noprof+0x3ef/0x4e0 mm/slub.c:5395
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
unreferenced object 0xffff8881023c6800 (size 512):
  comm "kworker/u8:3", pid 829, jiffies 4294937473
  hex dump (first 32 bytes):
    00 56 0a 2b 81 88 ff ff 00 fe 03 2b 81 88 ff ff  .V.+.......+....
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 175b82b9):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4550 [inline]
    slab_alloc_node mm/slub.c:4873 [inline]
    __do_kmalloc_node mm/slub.c:5266 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5279
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    __pcs_replace_full_main+0xe8/0x300 mm/slub.c:5729
    free_to_pcs mm/slub.c:5782 [inline]
    slab_free mm/slub.c:6177 [inline]
    kfree+0x352/0x390 mm/slub.c:6490
    call_usermodehelper_freeinfo kernel/umh.c:43 [inline]
    umh_complete kernel/umh.c:57 [inline]
    call_usermodehelper_exec_async+0x1c7/0x1f0 kernel/umh.c:119
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff8881023e9000 (size 512):
  comm "kworker/0:1", pid 10, jiffies 4294937519
  hex dump (first 32 bytes):
    e0 52 f6 28 81 88 ff ff 00 b6 ad 81 ff ff ff ff  .R.(............
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc d8ec9e0d):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4550 [inline]
    slab_alloc_node mm/slub.c:4873 [inline]
    __do_kmalloc_node mm/slub.c:5266 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5279
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    __pcs_replace_full_main+0xe8/0x300 mm/slub.c:5729
    free_to_pcs mm/slub.c:5782 [inline]
    slab_free mm/slub.c:6177 [inline]
    kfree+0x352/0x390 mm/slub.c:6490
    blk_free_flush_queue+0x28/0x40 block/blk-flush.c:514
    srcu_invoke_callbacks+0x11a/0x1c0 kernel/rcu/srcutree.c:1941
    process_one_work+0x26c/0x5d0 kernel/workqueue.c:3275
    process_scheduled_works kernel/workqueue.c:3358 [inline]
    worker_thread+0x243/0x490 kernel/workqueue.c:3439
    kthread+0x14e/0x1a0 kernel/kthread.c:436
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888104850a00 (size 512):
  comm "kworker/0:1", pid 10, jiffies 4294937528
  hex dump (first 32 bytes):
    00 6c 8f 00 81 88 ff ff 00 10 0a 2b 81 88 ff ff  .l.........+....
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc c75772dc):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4550 [inline]
    slab_alloc_node mm/slub.c:4873 [inline]
    __do_kmalloc_node mm/slub.c:5266 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5279
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    __pcs_replace_full_main+0xe8/0x300 mm/slub.c:5729
    free_to_pcs mm/slub.c:5782 [inline]
    slab_free mm/slub.c:6177 [inline]
    kfree+0x352/0x390 mm/slub.c:6490
    blk_free_flush_queue+0x28/0x40 block/blk-flush.c:514
    srcu_invoke_callbacks+0x11a/0x1c0 kernel/rcu/srcutree.c:1941
    process_one_work+0x26c/0x5d0 kernel/workqueue.c:3275
    process_scheduled_works kernel/workqueue.c:3358 [inline]
    worker_thread+0x243/0x490 kernel/workqueue.c:3439
    kthread+0x14e/0x1a0 kernel/kthread.c:436
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888104850800 (size 512):
  comm "kworker/0:1", pid 10, jiffies 4294937528
  hex dump (first 32 bytes):
    18 6a 89 26 81 88 ff ff 00 b6 ad 81 ff ff ff ff  .j.&............
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 1ece07b3):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4550 [inline]
    slab_alloc_node mm/slub.c:4873 [inline]
    __do_kmalloc_node mm/slub.c:5266 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5279
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2771
    alloc_empty_sheaf mm/slub.c:2786 [inline]
    __pcs_replace_full_main+0xe8/0x300 mm/slub.c:5729
    free_to_pcs mm/slub.c:5782 [inline]
    slab_free mm/slub.c:6177 [inline]
    kfree+0x352/0x390 mm/slub.c:6490
    vfree.part.0+0x1d5/0x4d0 mm/vmalloc.c:3485
    vfree mm/vmalloc.c:3456 [inline]
    delayed_vfree_work+0x5b/0x90 mm/vmalloc.c:3398
    process_one_work+0x26c/0x5d0 kernel/workqueue.c:3275
    process_scheduled_works kernel/workqueue.c:3358 [inline]
    worker_thread+0x243/0x490 kernel/workqueue.c:3439
    kthread+0x14e/0x1a0 kernel/kthread.c:436
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF


Tested on:

commit:         b29fb882 Merge tag 'v7.0-rc3-ksmbd-server-fixes' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13fb694a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2c6ad6fefffa76b1
dashboard link: https://syzkaller.appspot.com/bug?extid=cae7809e9dc1459e4e63
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14023016580000


