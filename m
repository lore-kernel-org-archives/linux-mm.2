Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90666FCD0A7
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 05:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F381D6B00EA; Wed, 18 Mar 2026 01:02:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8D06B00EB; Wed, 18 Mar 2026 01:02:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFE726B00EC; Wed, 18 Mar 2026 01:02:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C59546B00EA
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 01:02:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9662C1D335
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 05:02:04 +0000 (UTC)
X-FDA: 84557986968.22.7264D7C
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by imf25.hostedemail.com (Postfix) with ESMTP id B4DC1A0013
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 05:02:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3yTG6aQkbAGoaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3yTG6aQkbAGoaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773810122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=XP4T4iMaCErg7kQXZBXgUrqdcl4Ozy9ZpxYT+MtYY3I=;
	b=N4nfRFL45EZjbdBweTwGKrowAlOYeRrUB8sNTSVWNK+UO8DiynHI0JBLAGIAm37GvLWNl4
	iq70oNgcSk4zaz3CvA3fLVRCYSXup1uHpGUYddl1jEB9gcDz2Vn2FEWkqsP8YzkkKNYgiq
	iuNPPQwPKLtcf/OG1Rl+mi6S6vAEl6E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3yTG6aQkbAGoaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3yTG6aQkbAGoaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773810122; a=rsa-sha256;
	cv=none;
	b=WYBxGHAmkP+jrWVn839RZ8zxDAlG0ikv6aSWWZygKFxNiXyx1c/OYEKw30IxvaJ0mLpni5
	c5Ss+TAJGmDmhzy6172Ck9a8bh189QOqoDIYDqmBMYrdA2JMjFX7mAPHJlS9MZMB8yRrNo
	Xn9QOzu89zdz94d4epK3D+xYttB7l4E=
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-67c1228b2a1so2244549eaf.0
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 22:02:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773810122; x=1774414922;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XP4T4iMaCErg7kQXZBXgUrqdcl4Ozy9ZpxYT+MtYY3I=;
        b=COUB7G6RDHOhh4P5v928wabRM0XcEuOQoj5al1YHdex7SwtI6oF+CV/Lydrl+J1Ptw
         z4m0rK0NhHA23ia5u0OYCNWdHFQukVVsY4KkMoxdYE8iRHaP3kZGw5cy44bo6ElKZ/4b
         VjPXDNoy5vzchz24Qu2H4PYBVf8Cz7blvnovkVrhsMfQVAcadJ5JO56x7LacZYJfYzGs
         O4dlqbQUqiWpOEikxMwb84DM0gpFxE3SE6bl+OEOifYSydJQH/r8Ex8IDClPrW+fnVWN
         C2GI1tDUxXZ5NQJM5wBLl/Z/EodTIpVj5GfdU8ox8x5q7Qo9GQCiwi4wOQ059pDsf0wp
         nRow==
X-Forwarded-Encrypted: i=1; AJvYcCVWNTXjcjWSErwuYq00w3JVAiMqAzRF0z+LEcZgiigz+US/BiOxR8wUkhQ8nDda5Yn0vXbUuS5VMg==@kvack.org
X-Gm-Message-State: AOJu0YwCyBsg3/Z117eemVl4gBLhYtnZfTsVzD2IMZAWDbIEFPZQdNws
	i/Vrk1csGag4wt/vsBNrh6izkrInCzkO8IKiAWYcTppFmijnqinvP0wg9wq5JbZwk2Yz2LXSd1R
	nOph9H8rRY4dTWJCMpTXMrEoLSq3Jvc+cwiflCMqJFDIBLqMCwWlfY60dCoE=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4887:b0:66b:6862:18d5 with SMTP id
 006d021491bc7-67c0da588ddmr1007794eaf.8.1773810121701; Tue, 17 Mar 2026
 22:02:01 -0700 (PDT)
Date: Tue, 17 Mar 2026 22:02:01 -0700
In-Reply-To: <abolyGbAyynUANDB@hyeyoo>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ba31c9.050a0220.3077e3.0002.GAE@google.com>
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
X-Rspamd-Queue-Id: B4DC1A0013
X-Stat-Signature: x5g8e68y39g7sh6ustjfskpos1e36ow1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773810122-29976
X-HE-Meta: U2FsdGVkX18m9FbN6IkVxjGv1ATjuroow9tlsUVTp/1TdRwcwpSP1mCSShh7W91W9EZmavKRGT0XGn/zw89ceclIF2KCeO/cogZpP72OGtb95IQh6hfqG1rkz6LMEfB9PnkD0+3vWCkHBjesMWVa3XFEWpGAWdQpvsrOEWVmnEdo2F/u2PRbbw9srXocvwmaZ3o/2gy/tEocW6CGGBg6l65pw+oUTD5Q+ZTFNo+GQBMHRFiJHRFk6Pkn7hmPZmAExt0/vp7Vq91UxHxXvTxyqMeVp72WJCfAzib7yxJGBTKjLh4vGKqITh0qpMXRbJ1Bdn/yWoa7MdK7iNJJGixSyhCe9igbf5RzjXA9C15arC+byhcok/n7ZSNDHUqIQzuIswTsTp8i+BOh+HcO+hFb0CTLpLtE06DWzW101A7QBak4DjwtAZswHeUDxmVFhdtv07lSAAMjoUG6YdBTw0HmSzqpgz7JSjrBR8/cFbOrRgEEogzWRORAUZ6GQjo4So6OH9I5JjBo3o5eE/wZPokoKegOqQZXc6VV+uBWre6bkAP/7nkjV1MGd1KBwOjkgy60+w8gMplneQh+rM4N3E1espEFFqDoPL4vejvPUWCd+UlkoPkrKwUZu3/u7+e+BOyWBQdnIKFhl7GhASTgHJbGAE+qghvwdjDIcDbx7MQvUuBVsyv33E0Ve9vhgU+jEDIUF41DjMNZYDIxeMsd3eYiT4ZMLlo12pHn746QBYiMZ87utuNczp3s9xZc7Dv4gV+oLJk8j1NlJCRyTeSvlX9rH6abP6zj9RIwxPAuJzv6NKJryA7qdQCJzyowEpDq51g6R+oxYCPDYP321y5XcViPESmSGOygp/iqnjmTlt6jH9cDvcHCE5il8Nd+07WoBkasLK7pnaIVJy5vfkVE407CaGOEh9NmYDevm816pf1Tvqbsy9jPk5QCYOAtjaqp9RAjgsPOjPKHmLzCiErsKHg
 OI0NiRlu
 TnKg1Fc/+eVV/Rt9tAG8zTwStmlwZcAYMBQFlPWUywAJizmxkBtL5MhuA6kuxZxVbTLbF0SrNJlJ/8guObIr8mAbEInfFJsILANiuc5zXsx2kOUT9afDtfTMzBrmc0pln0A1rlNCm/zfDhzFnx6DPOP8QL9eRrC9gbx1RGhCKo02SqpoYn0ybnEkaiQxJ3ey+OWoU936DehAYuoQJsxD+6boS9c2ZFxPV3iJe49b8AO/wij6J0Pdv4YYYQuXt4vivsqopZzMkg5KGmql0u1wwOGfK8U3nsCkjEdyT0EMkvAtoV/3ws+xfbSqMPcDIbT7DoB9r7PEH3xh/WDsiwyX5U6L3tPTybLAn7PNK+G9wKWoAImEDjd1TMz48VHzUA1HltRP+p7pBhqmVqJHX4CJVpN1+93E3gEpWwJJ4q4nq/kf3H/IaQSG7yEoiTPxKWhZLaRcvSOdElv/OVYJJdtWEZgnFN3XhfPgFfo1V+ZlxzL6hGJOvygD/IhHkPw5WHnkhd3mGrCw3mD4H9Nutg6+In6qVT7HLtb1PEKthdQDZ8otgkkjdyrq9Gx5syO3qk7R5gR3U4aFjJrT58MxOUtjf98y6oEUsiaUOaA0SBUq2JMP6MdmdEcG8Zm3d2Rw2PDI8JPmoQNGDVf1/EBOnsTJ+7BPm07zIEk6JiMUyL/BmMFESffIDfj6vL0/UTaY4YBjsi74XoMKgB3S2kUhTPh8wGIXogAXf5vEkAtJQAd7M+sFoYEGb8LQEoPOe0Ex4jKfJh7cgTAp/A6g4ld2xm1af80DGg3AU1rvRZkOtqe49ksSZuV9+wq9ZnPUw9RDxqZuvmRLxMJJX9h7k23ZOsFBi7x1wKEcNOsZS+Ik/Z/3AGuf6BZ5Zttuk33nax7qaahpDD6BU9OWtOME/XHNEaoyExzalTvPKkfdWeXGsXlcHR2cYGK1ecTb/RDKURdYFAmDM/j38mxAQyKQsrZ2Y9kIFLyGKKUjc
 BVIK9X1J
 ndK6EW67l7lw+knxV8UsjHGJJ0W+J7qqr3H08CXY/OpPHL5SmtAU7w==
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
unreferenced object 0xffff888129413800 (size 512):
  comm "kworker/u8:3", pid 58, jiffies 4294947638
  hex dump (first 32 bytes):
    00 ac 98 1c 81 88 ff ff 00 18 6b 0a 81 88 ff ff  ..........k.....
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 10da2a4f):
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

BUG: memory leak
unreferenced object 0xffff88812a621a00 (size 512):
  comm "kworker/u8:3", pid 58, jiffies 4294950606
  hex dump (first 32 bytes):
    00 18 62 2a 81 88 ff ff 00 d6 04 00 81 88 ff ff  ..b*............
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 231cde90):
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

BUG: memory leak
unreferenced object 0xffff88812a621800 (size 512):
  comm "kworker/u8:6", pid 932, jiffies 4294950638
  hex dump (first 32 bytes):
    00 18 6b 0a 81 88 ff ff 00 1a 62 2a 81 88 ff ff  ..k.......b*....
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 9a0f4a55):
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
console output: https://syzkaller.appspot.com/x/log.txt?x=15c4974a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e2bba615ee79faa5
dashboard link: https://syzkaller.appspot.com/bug?extid=cae7809e9dc1459e4e63
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=178fc216580000


