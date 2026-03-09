Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFD92EFCD9B
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 540F86B0088; Mon,  9 Mar 2026 07:11:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EF2F6B0099; Mon,  9 Mar 2026 07:11:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ED9D6B009B; Mon,  9 Mar 2026 07:11:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2A66B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:11:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECA4B1A014D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:11:05 +0000 (UTC)
X-FDA: 84526257690.08.9C1A038
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	by imf10.hostedemail.com (Postfix) with ESMTP id 36D08C0012
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:11:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of 3x6quaQkbACwaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.71 as permitted sender) smtp.mailfrom=3x6quaQkbACwaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773054664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=Z05biv7HDDyvWTAZybrg4/Tgqu8avyuVtSPLUJRGL/Q=;
	b=2/E0Lfi7RiJAVxpQ1MDdctE9dOujvT80Ygg06hOuBSN4W/dXRBmTmlR0yHh0GQKmJqD+No
	yZ+Zawx4ITw3DS3kfw5RMMqd9rb+S6ePFqMo0/tB/7S/OWlSLBltrd+hYJTAcTCRLJmHzY
	FrAdF4m/DxQD7dyTGYZSoo0xZr5ikcg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773054664; a=rsa-sha256;
	cv=none;
	b=3NGynO3AXHv21EYUa5rs51qcG2E2OBeV7Q6+4w7Bk99mabLiocFMxP3aIMjgvdOtA9f9d8
	jB5dcfj9h3GZIj9lp2KN6CMBdEiMTdfc7t2Z18DcAb74tGJ9c8tC8R5xUsSKcK53WovkRZ
	DHGSK9cA3U+wpmVXsb3/itUt1yQSmZo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of 3x6quaQkbACwaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.71 as permitted sender) smtp.mailfrom=3x6quaQkbACwaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-41555e51e94so22052684fac.1
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 04:11:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773054663; x=1773659463;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z05biv7HDDyvWTAZybrg4/Tgqu8avyuVtSPLUJRGL/Q=;
        b=qca8wjGpjcJ7QI6yAfK9fInXiUfKxeELiDcjtPkhdAn72Ke71XgmhLTWhMnZpDaR40
         kKIgtAkAP6zeN2yBl4skRtj1ioNk2m92ItgV2WeuUR3linyG62uJV95Rguezw3Xw7ERw
         nyODItpN7hv+xOxpCKkn61uYzMJ250ilyIrhOLgWiRWd7eS0HYXe46c7alemNDifbILo
         z2XV7Nz2AkBD4UocfMhAI5dztb90NPBojC1XGpyPLXdCfUC1wMiz5sWkkuPJLoDBeNWb
         FqazDyhp2Jw78C7OIOCH2VGRKNjdMetwhJdeeKKe2/bwgzkgTjL9gLHc2KJVeRfO8FfE
         pR6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWO2X1tzkLh4OIxvVvJS/mdgjkezZ49trCrEKKiOWzXGlpGr+KVlHUDU9eNIvHauSvbXXg7ozo2BA==@kvack.org
X-Gm-Message-State: AOJu0YwnHmFsM7xQtAvPoRz4PfZEidh3QR58cykURW8PAusMCnnCYrjU
	gi0gNBTWUguwlMsqtNaUGTt4jIAEgLSJ3G0h0c8zSFjrsHQqp4yIK3x2dhirUOqsQ+uF3pFslNT
	FLaQK6UpRcj6FcAzATKnSJEv59cFfIhTmK61k2jnrIueGo+pnA+lSiZikVXk=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:3105:b0:679:92c7:2bfa with SMTP id
 006d021491bc7-67b9bd0fc42mr6325438eaf.45.1773054663271; Mon, 09 Mar 2026
 04:11:03 -0700 (PDT)
Date: Mon, 09 Mar 2026 04:11:03 -0700
In-Reply-To: <aa6lBQDAVnqjz_lk@hyeyoo>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69aeaac7.a70a0220.52840.0014.GAE@google.com>
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
X-Rspam-User: 
X-Stat-Signature: hhw8iybcjy7uttk6sw3df7r4f9o79ndt
X-Rspamd-Queue-Id: 36D08C0012
X-Rspamd-Server: rspam03
X-HE-Tag: 1773054664-257530
X-HE-Meta: U2FsdGVkX19xq0CbxPf4Mcg7KdzTlKwUktEZkBR48zJ3nZ5w5G3jOMFyT8eBZSTsaXqRPmp8h51QtuH/almSPXdrmBRUKUMljcWRuyxyaGSMXe24FdcfKAfr8QoJib+4nhHpPW597WHrPy9z72QnJuSm0gxXdil1pZvBxc7fGibxP23uZ0YG8adDstxzXWziUiF0AdiOr6MOT38cuEYeLu2CMSl0YevOJ5GQUubfj5VQFvlCPL47Jjk20JixH7a2nHBxUUdlpZHPc3myq0LCszEF+ffrnTvxkM6F2VyaG2J5RsinJiNEJ4SVoc9AERQqVCWBhHbWEQcG72aqoX8xWetFw/ORSx5kELMmTwPZNDpblc4aBmMRkxU1I8z0dVp7SPSgAHB/6vNYaatcKcW3JynUm1V/hYHyaxw70PpiXjd4KsjnHR/hQOmXHdfwlmW0/v1pD4Ji08ADT4GwccTyacFR3Ch9zoNoO8MpRUBbKw3lCHYjs9c7silyEdOK1qkBWT5OXyQ9OuTrwuBO/X0dcQmyJ8n957OOkfuNvkNPmWyjkvDoka0ldJzyw0HZo/bKXIZVRk3d1w/OIxebmGUizcU+mU37WPpGYLeLjQKGhdjybY/0TUi8bpd/H4Khq1AxvMLNWC6omEisPC6cfBKLgDtGhGRgR/l6QQF9LPloi7aLRapvV8V7oIVE/2ydfayVNtqjzMvo94YV0IIMljKP7o83Sff91Q0/lk7l4GAADolbaSSe6GH5vWRx4S1k+ZeLmPBMFxbOwPZgX4iZFU58wE2Aw29W/seVz2qRBIR3tg04R1d0vU1WjduF5frMh0VAlkGwU1ikRUzMg30437+/J31FVNxfBLl8xFOVi3dLjZ1/MVwkprXEAPTl6XfRzGJuDlbHNEEtJsAq0itd4HCeH6QF4PLcPcr2xsuGNtfIh65obwC4E7M+CPYvQZVIDFkOknm1FKWOfl8lXBH7CFL
 bOGG+ZaM
 y0HVnXBpYLDi4bFSqJP1jwrZog596KoyzA6UBUlBJ2huds+AzHzDUsOmRXLF5P61iWwIKejklsGL3y/cP03ODR0X8Aj2X1ywwerWNZmzOkN3O0zTFYJi595W/IMU76GEO+z1qDcMKw8fzdmZ2PVzIMHB01veeMw3qAp9JXQUi6JVxAf5ujtuteqwD7JYC+WNzpnLxPRi8UPPyqK/semKQk4yV98nu7HfH4DHGjsei+NsI+Ug82wEUdzvPyyfPg+XW+E77zc0fgDBat2DsDBFO40peuhG7IUC13RE2qBRpwqInCkTxELSL2vDV7AwpGiXv6J9qeaB8Notw+0CLHNFavFG+aidxXS/QbfXLPFgyWXtcz/CzkXGNJ5hzL+uBva6kvU5JWUMgnjXbZuuiE1ziaWfXkkL25m0KrDg0AhuZvJ9PKPHWVJnlTpOpI7VjAyhi+ecPQeHOUJ9gLBePs05eDGCqpaLep0d0LX90NQxbqtBq+8P3Cff8wO8hrKcLkF+O9nX/AFbhbqdo2Q7hBY8Qr8ja6NxFIBYl+zcIuiy6TtjwyfsXjVCKZRE0puriyqE50FxUfNqpnn+BcL5siidK7LXGW+JUfx70P/MRhCd3+uLCw1ZVt2GtJFXcl4EJaNjEKkb8i/Jv98Y0UOki9ANQloKBVBLGHPJIlx6CsOlylVlmdBm8CHYFoemfL/5LTRP3fSLzALr2VVzITyjiqBWRFx225ez/vuRVT+49ULjBcMrjVhg32rn0HWiNBcdKO9qRLmy7UE1ZqfYI3e6vmhSHTYMEVpXsn6+UDNQOOQmij9r4c807YHyV6ozQdo0ACrHU/3MApDPGFwDyrHPEOO0foMBiFHL6s7QSGCi+9RP40oh2ftSI57JlXQ/D3XQ6dcsjXz8+NlAsUR24dxmspaDkllzt/ff9YHj4xqGYWUQ9r3JpO2hOW86ZWewwIdmXTqPjLTBd8FiJDFx3VGYsIQXxucqe7YE0
 ub5vtsdS
 4nG3YYgDtFirkkQF3b7UMaSvc97G+ehovX3Oh3CR57aM+xrOj9mcGg==
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
unreferenced object 0xffff8881008bb900 (size 256):
  comm "swapper/0", pid 0, jiffies 4294937326
  hex dump (first 32 bytes):
    00 e8 54 0b 81 88 ff ff 00 55 bf 0f 81 88 ff ff  ..T......U......
    00 e1 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc e804819c):
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
    __kmalloc_noprof+0x4c5/0x560 mm/slub.c:5280
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __register_sysctl_table+0x4e/0xa60 fs/proc/proc_sysctl.c:1379
    register_sysctl_sz fs/proc/proc_sysctl.c:1436 [inline]
    __register_sysctl_init+0x30/0x70 fs/proc/proc_sysctl.c:1465
    pagecache_init+0x4e/0x70 mm/filemap.c:1095
    start_kernel+0xb33/0xb80 init/main.c:1193
    x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
    x86_64_start_kernel+0xce/0xd0 arch/x86/kernel/head64.c:291
    common_startup_64+0x13e/0x148

BUG: memory leak
unreferenced object 0xffff888104417400 (size 512):
  comm "kworker/0:1", pid 10, jiffies 4294937905
  hex dump (first 32 bytes):
    00 42 a4 1c 81 88 ff ff 00 06 05 00 81 88 ff ff  .B..............
    00 16 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc db9a578f):
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
unreferenced object 0xffff88810ad9d600 (size 512):
  comm "syz-executor", pid 5829, jiffies 4294941807
  hex dump (first 32 bytes):
    00 72 0a 00 81 88 ff ff 00 d2 04 00 81 88 ff ff  .r..............
    00 af 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc 57ea7b83):
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
    __kvmalloc_node_noprof+0x5a7/0x770 mm/slub.c:6767
    allocate_hook_entries_size net/netfilter/core.c:58 [inline]
    nf_hook_entries_grow+0x178/0x3e0 net/netfilter/core.c:137
    __nf_register_net_hook+0xc4/0x2e0 net/netfilter/core.c:432
    nf_register_net_hook+0x8a/0x110 net/netfilter/core.c:575
    nf_register_net_hooks+0x5d/0xd0 net/netfilter/core.c:591
    ipt_register_table+0x15e/0x220 net/ipv4/netfilter/ip_tables.c:1781
    iptable_security_table_init+0x40/0x60 net/ipv4/netfilter/iptable_security.c:46
    xt_find_table_lock+0x1a3/0x270 net/netfilter/x_tables.c:1260
    xt_request_find_table_lock+0x28/0xb0 net/netfilter/x_tables.c:1285
    get_info+0x101/0x460 net/ipv4/netfilter/ip_tables.c:963
    do_ipt_get_ctl+0x9b/0x5e0 net/ipv4/netfilter/ip_tables.c:1659
    nf_getsockopt+0x61/0xa0 net/netfilter/nf_sockopt.c:116
    ip_getsockopt+0x10a/0x150 net/ipv4/ip_sockglue.c:1777

BUG: memory leak
unreferenced object 0xffff88810fbf5500 (size 256):
  comm "kworker/u8:0", pid 12, jiffies 4294942140
  hex dump (first 32 bytes):
    00 b9 8b 00 81 88 ff ff 00 72 02 01 81 88 ff ff  .........r......
    00 e1 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc 88397b4):
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
    netif_free_tx_queues net/core/dev.c:11206 [inline]
    free_netdev+0x71/0x380 net/core/dev.c:12183
    netdev_run_todo+0x5ec/0x770 net/core/dev.c:11726
    ops_exit_rtnl_list net/core/net_namespace.c:189 [inline]
    ops_undo_list+0x2bd/0x300 net/core/net_namespace.c:248
    cleanup_net+0x287/0x570 net/core/net_namespace.c:704
    process_one_work+0x26c/0x5d0 kernel/workqueue.c:3275
    process_scheduled_works kernel/workqueue.c:3358 [inline]
    worker_thread+0x243/0x490 kernel/workqueue.c:3439
    kthread+0x14e/0x1a0 kernel/kthread.c:436
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff88810b540200 (size 512):
  comm "kworker/u8:2", pid 34, jiffies 4294942151
  hex dump (first 32 bytes):
    00 8a 51 27 81 88 ff ff 00 2e 7a 2e 81 88 ff ff  ..Q'......z.....
    00 18 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc 8700e7f7):
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
    process_one_work+0x26c/0x5d0 kernel/workqueue.c:3275
    process_scheduled_works kernel/workqueue.c:3358 [inline]
    worker_thread+0x243/0x490 kernel/workqueue.c:3439
    kthread+0x14e/0x1a0 kernel/kthread.c:436
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888127522c00 (size 512):
  comm "kworker/u8:7", pid 1176, jiffies 4294942410
  hex dump (first 32 bytes):
    00 7a 54 0b 81 88 ff ff 00 e6 b9 0f 81 88 ff ff  .zT.............
    00 18 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc c4b7e6cc):
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
    process_one_work+0x26c/0x5d0 kernel/workqueue.c:3275
    process_scheduled_works kernel/workqueue.c:3358 [inline]
    worker_thread+0x243/0x490 kernel/workqueue.c:3439
    kthread+0x14e/0x1a0 kernel/kthread.c:436
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF


Tested on:

commit:         1f318b96 Linux 7.0-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=117b875a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2c6ad6fefffa76b1
dashboard link: https://syzkaller.appspot.com/bug?extid=cae7809e9dc1459e4e63
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17b8375a580000


