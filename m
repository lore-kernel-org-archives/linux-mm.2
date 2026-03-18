Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF50410854D0
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 03:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035D16B00D6; Tue, 17 Mar 2026 23:08:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29826B00D7; Tue, 17 Mar 2026 23:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3EC16B00D8; Tue, 17 Mar 2026 23:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D42906B00D6
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:08:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 731B6C1DD5
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:08:06 +0000 (UTC)
X-FDA: 84557699772.09.62574DD
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	by imf26.hostedemail.com (Postfix) with ESMTP id BC7F514000A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:08:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf26.hostedemail.com: domain of 3Exe6aQkbAH4u01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.71 as permitted sender) smtp.mailfrom=3Exe6aQkbAH4u01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773803284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=gxvOJNpri5w4RKCQDfdsWJpDQ+y1OdANJaHF9wxYFME=;
	b=RyYHlNv1Vws2+sYtBxPfxlOLcRZ8CwtXKrT+jskqmNkMmjUvSfPhktqqQpQ+8DKrZgfo/I
	PQIrzvMNbQJ3eTae3ILZEI5owTuWKbTPMEhSxFvscV0+EnqSNKG50jAr5/s6ws929TpEIV
	olBpKbVYYjm/rjdhZS+epefxcoau4+Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773803284; a=rsa-sha256;
	cv=none;
	b=PuuLtnAREudhC/UA2TBKRvxvMBsQn4mzsuMVQchI9qiz00FXjqbi9LjpSP/8ok0T7UZT6V
	qh42NFaoitSYpwCTy3n9lOSISDLHsF5MWp9pMl2nh3n63BEmpWbKwisY1+j3zACSSY/PlD
	cBOS2ATKIeB/6W62/ijQmhKI9gKpQd8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf26.hostedemail.com: domain of 3Exe6aQkbAH4u01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.71 as permitted sender) smtp.mailfrom=3Exe6aQkbAH4u01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-4170466438dso26282510fac.2
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:08:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773803283; x=1774408083;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gxvOJNpri5w4RKCQDfdsWJpDQ+y1OdANJaHF9wxYFME=;
        b=pdtRtp5V0xyv2FWEeroIdi+kjVsXeE5NT/YcJs68exFpOKBwx44bliS2SRcR6H49dH
         DcRILHIhuFlzVfNM1AD54/RiaGLozVfOiQ2HL314mB0j3gBH2dwyrx/jOkh2eXxe5K5c
         dUlgxWLjZIzig4czmTCZ2oHS9LV/IyaDaE7Bx2qUK2V+t1l+Gmc96ZXEarR4+KiN6Tar
         PUWQh2x70Ql8rmRg8KhXm+Q5tMyoLYVtA32K2OLHGqwm/ASfow3xAeQ3+A9cpaChl3Ig
         vXymlrm6YNFAJo1KxtMR1A0zKk0eINe0z8ZimE5dZsVh8JtFRtoyi+P6uI4XpAyTULDt
         9uBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqAa++I6iyn4WpmQp1uoIRbYNoUK7H6Tol5vxyWZb7QT0WnsFNbS4pgu77RtzrTDktKx6eAY9qCA==@kvack.org
X-Gm-Message-State: AOJu0YxPLM2uyEGfnBX6c/V7n/ri7jMFrJFRDRrYOBYzd8ABvGTlXMHC
	C/JB3VRJmRi8LscLzWP6QHRZc84f7WvSdTYGsaiUqC4t8UTikLbOeVsd7EPr6W7jw4+2tWmvc48
	RuN1w/BtSif+Wbh7jX9xhy+VxlU88BPA6/jVOqxLslRobblpE/D1RATqdlbg=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1ca9:b0:67b:a489:3b6f with SMTP id
 006d021491bc7-67c0db5551fmr1348347eaf.66.1773803283716; Tue, 17 Mar 2026
 20:08:03 -0700 (PDT)
Date: Tue, 17 Mar 2026 20:08:03 -0700
In-Reply-To: <aboPKERGvOniN-OK@hyeyoo>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ba1713.050a0220.3077e3.0001.GAE@google.com>
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BC7F514000A
X-Stat-Signature: kmp4eyhqd9p3w8pms3ykqqaaa7mza5wo
X-Rspam-User: 
X-HE-Tag: 1773803284-416854
X-HE-Meta: U2FsdGVkX18s7xMkxTdpS6eqj+Rch9X8Gp2621Rktx+SaI8glq6nigdXAqsSnTiR4EA8643ngNvaU6itHQXb/kvAEzIEoXl+JbRVgG/UtPRizhoDIMrBjp5gb/58vqgoQuKwQc0aoLKxjf9fdOgVhPPRaiSvFjzoM6dVcL8DhaHFqrFyt253x24s1/4XoDdN0tmofaQwfGpt+q3ktoiM80kv9h+vn+OpxZpeduUB6hlXWf85agexpbCnAkYU1oyqJOfQhwTX0kVPstFJ2fxpN3K4JjXFN9CTU+VQ9vSNZGSqpgGDTRvTECWbSw7r1oTZ2GeI/eufQjsR+7nm3mEMruvzXlSdsRNHnbDusA+pccnrR7VwFddB7ksUESTNaHladDQ5VbstjixtjKHQI+vReYCsDvSDJ5o1MQZJJt9CegRaui5QbD4q2Cs/DcP+jWy9g5RL0BRkdwzmQJdBkGcL2VRses/8a9qEH5lN3mg5duURs7RKv688tmJL1yCOxpWKeQMAZbyyjiICwMbMpvnD5otIKW4z3mzfFpzuv0Xr3KIb2SSl6MCbc9+xffzCWagSe1ypW65WJWoK0KwpZuco5icB70Gx4Qis599gCP/BTY3d7sAVk1L/LR6gPOJxL4wGwaey/POnb51wMgJNpnMwQ292P3ZZX+ywvh7vaA99UZd2B8w7IpCXF7Nx4patESNkZqVLOf2jx1QQJsQBxvunrrzKTxJKbB9B4UzGCclC6SvCxXFVzZIJkS1K40SZf5EUisld4pVmAmZ5UCNcW9CCJS5SBsFpzAW9OQW0Yzi3IJNQfavUeq/knTjhYbuvnK1/KW9N3UUZxEeEHsrcjDEQHF6/tJRp2oanebcxKS1OuMWtMw42wAs/Uja/E24FwlwQqtaiOEAJdE/Oy1+wzq1hAQa3gAGojHFTTMuJBuk/Kx7Hott9O3LW5URYmKayAopiMqgIYwpn6/J56rx8nVA
 Z0o4/INx
 q1GTY2RjHejARUjd6o838NjwUig2QAEJ7fWhoTAR2gOi0N3Hhjddo6WniaVi3XDgZ+XKwncQHG2L6oFiFPh0evrqAFiB2nJoSb4pYF1KkB7HCL/AJdN2JM+HSOXDjBrhpojm6nsbZ/cNsyLxCsRpsdTRhYO7FhzWHCufUDTdiTiNPk9aw4QPKwwHrUXK36DBitagAAUckhlqFvv4mTd/e/Mp7Qg0oL2TErd3pW0LhpLqH3bcrZWpjXTRl/2H5sGGU53Gw25gk2WtA2AZzYbSuf3nTDaDVvAUWmBo2s70345esRu8cu9UE5bD49wnmAWyPcHcRWqqNhfbuQzfABJIzVjrYR6Lq/1jqsSz4aPCY+SFfCKMh/ndhun4/piApan6fvv4UnAXqiQIIkaCvGxRn04bAUXJrF1baxI5zHshe02FoQ7Z+bzqtcl5CGFGrGv0D30h3ayPMpx0Q2ytSeplnHYCVnE3nhHd17+8ziSFzfSx0Hvhi0CySOh/4GQqJsBy/PFAc3MaF/0Xglqeyzn19+Jm+NJdTKHWRjnKfkAyaYq/AjkctcUp+zv+rUSUzcOIgkc0lGAoWdRFWEdtZSnhfkQX1AlNoCQgHusD+r5iU4Tvoi18614ii7XmdURjpHYIBccjFXtxc5lStk7e7GQrbIzYDeP0xa0+8EzdqfPnAH3OYfK7Zd0HfPca7e9C9cIUL+KZYTvRusjhg2qaOjXhg3jjD1Bev5cJaUJhZJe9AeO0rz/Q2rR/FhmF528jlYddT+0jp3fl49lxAWFLNMyCI6gVTjVT3+AyPmInsy0tw0csnOAA1M/KkOAJaDXVwzoeNg8Oqw9RuulLMYt0W76UzSU999IvuTrd3BSiBwf/w6xKLs7oUGlUKGxWA7xs5JM/0DE8enZqFj5WzGWseC2jOc5mheMdqRjK7+bDWuV3IwsAuhLSFkbC6lC1kAum5CUGEvtG2+FPtbNyBJPJj+7dRu1Vbskx2
 B3KrAMDI
 Jd8rjJHEQp3glAkfk7JwFs9iSBnUyrNrtTT1iculVCfmp7Z3OunoFw==
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
unreferenced object 0xffff88810e983c00 (size 512):
  comm "softirq", pid 0, jiffies 4294948614
  hex dump (first 32 bytes):
    c8 2c 04 00 81 88 ff ff 00 a4 98 0e 81 88 ff ff  .,..............
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 8f5c2bf9):
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
    __do_kmalloc_node mm/slub.c:5259 [inline]
    __kmalloc_noprof+0x4c5/0x560 mm/slub.c:5272
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    cfg80211_inform_single_bss_data+0x21d/0xa70 net/wireless/scan.c:2344
    cfg80211_inform_bss_data+0x13f/0x1dc0 net/wireless/scan.c:3226
    cfg80211_inform_bss_frame_data+0x108/0x340 net/wireless/scan.c:3317
    ieee80211_bss_info_update+0x13a/0x320 net/mac80211/scan.c:230
    ieee80211_scan_rx+0x269/0x3b0 net/mac80211/scan.c:364
    __ieee80211_rx_handle_packet net/mac80211/rx.c:5305 [inline]
    ieee80211_rx_list+0x111b/0x1850 net/mac80211/rx.c:5588
    ieee80211_rx_napi+0x50/0x110 net/mac80211/rx.c:5611
    ieee80211_rx include/net/mac80211.h:5267 [inline]
    ieee80211_handle_queued_frames+0x9c/0xf0 net/mac80211/main.c:452
    tasklet_action_common+0xb7/0x270 kernel/softirq.c:925
    handle_softirqs+0xdf/0x2c0 kernel/softirq.c:622
    __do_softirq kernel/softirq.c:656 [inline]
    invoke_softirq kernel/softirq.c:496 [inline]
    __irq_exit_rcu+0x91/0xb0 kernel/softirq.c:723
    instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
    sysvec_apic_timer_interrupt+0x73/0x80 arch/x86/kernel/apic/apic.c:1056

BUG: memory leak
unreferenced object 0xffff88810e98a400 (size 512):
  comm "kworker/u8:7", pid 1022, jiffies 4294952987
  hex dump (first 32 bytes):
    00 3c 98 0e 81 88 ff ff 00 68 cd 2a 81 88 ff ff  .<.......h.*....
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc b6e2f12f):
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
    __do_kmalloc_node mm/slub.c:5259 [inline]
    __kmalloc_noprof+0x4c5/0x560 mm/slub.c:5272
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    cfg80211_inform_single_bss_data+0x21d/0xa70 net/wireless/scan.c:2344
    cfg80211_inform_bss_data+0x13f/0x1dc0 net/wireless/scan.c:3226
    cfg80211_inform_bss_frame_data+0x108/0x340 net/wireless/scan.c:3317
    ieee80211_bss_info_update+0x13a/0x320 net/mac80211/scan.c:230
    ieee80211_rx_bss_info net/mac80211/ibss.c:1094 [inline]
    ieee80211_rx_mgmt_probe_beacon net/mac80211/ibss.c:1575 [inline]
    ieee80211_ibss_rx_queued_mgmt+0xb75/0x1230 net/mac80211/ibss.c:1602
    ieee80211_iface_process_skb net/mac80211/iface.c:1748 [inline]
    ieee80211_iface_work+0x6af/0x9b0 net/mac80211/iface.c:1802
    cfg80211_wiphy_work+0x1db/0x280 net/wireless/core.c:440
    process_one_work+0x277/0x5f0 kernel/workqueue.c:3276
    process_scheduled_works kernel/workqueue.c:3359 [inline]
    worker_thread+0x255/0x4a0 kernel/workqueue.c:3440
    kthread+0x14e/0x1a0 kernel/kthread.c:436
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF


Tested on:

commit:         a989fde7 Merge tag 'libnvdimm-fixes-7.0-rc5' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1005f8da580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e2bba615ee79faa5
dashboard link: https://syzkaller.appspot.com/bug?extid=cae7809e9dc1459e4e63
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1405b406580000


