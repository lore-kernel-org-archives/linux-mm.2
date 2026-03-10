Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C73EFEFCD9F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 09:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 239616B0088; Tue, 10 Mar 2026 05:40:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21AF86B0089; Tue, 10 Mar 2026 05:40:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1104A6B008A; Tue, 10 Mar 2026 05:40:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EF4FD6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 05:40:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A5EB213B222
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:40:06 +0000 (UTC)
X-FDA: 84529657212.19.1D06122
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by imf15.hostedemail.com (Postfix) with ESMTP id D57C9A0005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:40:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of 38-avaQkbANQIOPA0BB4H0FF83.6EE6B4KI4H2EDJ4DJ.2EC@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=38-avaQkbANQIOPA0BB4H0FF83.6EE6B4KI4H2EDJ4DJ.2EC@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773135604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=i8Z0gVF0uPQ8qNSugfsMNVMLQ4iv7U/CKd+gpIjRAX8=;
	b=BHQvTF6FeohIDV9Faj+rKHjmBU28OyL8IS5O8aTaka2E+RUnSlMlWFVBJE4AB/+eThqXRm
	2IfJkd4t+bvMse3oUigI6rsmH4FiiBgYO0N6sJhp5t6PM5f1xL6ptjWJq4EG93HibwuzOf
	npF4tC6Qfu/v3OXW3sIZRFknSvelB/M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of 38-avaQkbANQIOPA0BB4H0FF83.6EE6B4KI4H2EDJ4DJ.2EC@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=38-avaQkbANQIOPA0BB4H0FF83.6EE6B4KI4H2EDJ4DJ.2EC@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773135604; a=rsa-sha256;
	cv=none;
	b=fdt5Nut26av29ZfviGI4sKqBde7f0JGvnt9tWbCgANruQH1SLhQOTEGjVPWjVIzQbGLXoF
	CwaRgWsI1jka4d2rKTEgXAoLuc3UQsCPLoBdn4iqblI0ZQi0kdZ9rS18JY8RvrPDdDuY3H
	G4mmeG3oRxkahBKkbrf4zJ/1EmWW234=
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-679a47a1febso68808819eaf.3
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 02:40:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773135604; x=1773740404;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i8Z0gVF0uPQ8qNSugfsMNVMLQ4iv7U/CKd+gpIjRAX8=;
        b=SenQ+9HAKFJgEXjCgfyVunObjwLJwZNQJ0RTwoUxt+HGVCiMPXsW+5LKRtPBg6FBg1
         1kF/A5ora1uqeA50gVOgfA3+YrJwZGcLR+k7/1sHaugHagE8a1PB+UUdJuBtvP/tFNzf
         N7DeYPCVLf5did+yPI2R15iJ6NV7PEPDcnzVZ6Rez0AphW0O9Ydtwv50x1X4j6KTV5ny
         Q7pdnYroZT1ZCBAg7KSg/5R42QZVz+3HFbKfFWUawBK50lm1sMKxLzeMulmuiHaPY7B+
         Z5dTnAsi7gx3+lLvc1fecKWKKAueG6R0Ti7sUvRAmiz6e4f2VSuzuSmdii2gWMc3V+Ir
         iHDw==
X-Forwarded-Encrypted: i=1; AJvYcCU/cnsgJIVR8ihHBVuwPfxMo2KrjTkRUwg+ugQXSn0E1hOG+T7h2WJEGEPAikqwct3mk+MyXxDxdA==@kvack.org
X-Gm-Message-State: AOJu0YylNdBiLi9HA8r5FjOOxNqyYbazjzWZN9lso9LwAtUTSlaWk/a/
	UVN0afaX4vsxIiOKhLvAqQT/sg9C33hzRcFEpKZxtiE9cPQ32XX04fbULYl36mUa0B2drFbl8X2
	jyf8yK7yyrNm+/u1dv7MRUS6rC3J7qn4P02ZxRLqoL4svok7R2tyrZ5BHnKw=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:3102:b0:66f:c72c:7c7 with SMTP id
 006d021491bc7-67b9bca8899mr9412099eaf.18.1773135603949; Tue, 10 Mar 2026
 02:40:03 -0700 (PDT)
Date: Tue, 10 Mar 2026 02:40:03 -0700
In-Reply-To: <aa_R-6SdHYBBkQX-@hyeyoo>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69afe6f3.050a0220.310d8.0038.GAE@google.com>
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
X-Rspamd-Queue-Id: D57C9A0005
X-Stat-Signature: rny5hpi61n6hk1u73n4979hqcc7biic7
X-Rspam-User: 
X-HE-Tag: 1773135604-369378
X-HE-Meta: U2FsdGVkX18IOPww8UnXHq6pOV2KLqW0fVFtOgu14c+4eBjnt8E5Vu8ufrEWqUpwfHc+ntO02XIwBfkA+EIkW2xzJkfO6Cw1yMRF9DQt3ew8csCEECvCKAdWJ5nWQ0rqqEaX3RygFFAbi8uX3rFz5FhfsKG66E63x7ktdaewLJvEaPCIg5/HTlQ86zV5SjltYwQbm2SRTLFEDKW4I4AWJprP0JXdgk/PJNOFckMTTA8YQpB/2A2Uqs5Ry+AEqslem/BV1IzjYjk+xKzLHokqGmh/HDrca2LW3wlFN4s1ASAeJ0vQ1wyZtnVa9oHPDOYXjEGTMf0opcftWsQ9/Q0D6lmHSeif3f3pV+5/ZSRQoW8oqvfd3SdGeZPtggYwbtJJZu15nHC9ZHREZmCG/RZCHS8XFEeq3iZYMSCcL+J4/DRD5fp5svqfai4dXqvSUzgJO0oI4Nc1fOcu6IWOCZdUqLzK9fWdDkErR4Xhgu+bBw4XLyOZLpkQdjLCD9x1KvVdgVllDK3y77OOVZiysHYfvv/IiWla72wsxHy6Lu/YJePp+UAtb+yPirlCev+3FDcv4PNag+cLgIqWRvSNLQ57T00azAUJj3jkjjk/uLaCStWgqh4XP/A/rWhGigTGpydQtmILtiweFcYGKOISHZMt/pt0SmlPMFViajqXggAt3PFdtNHexK9rBseXIqGzocO6m+oIst84yqzRFK3MybWc3jwQ2JCiz6WZwGnU83aKKJyak7JN9aW2AOa03jaC0ATXhXhcmJpi0HSGJ+r5D/f4yQ4d8x/v25yr5awuod/HLQwFPweSfseRiMuLcVjoKUXxdWtY/P+3yqJ2MRw6pCjLN4Ry+9Wf8hVuR8GYPI05XMyzf6asGWf/Iou26u7yXMvlECAo6HY2Pk3Ve0mnJu732Ug9VllogwL0dWI44M2GOMa6+yyowRtjnlZdTp2hcpP/j5SOfpKK8LQ7d9nV1VY
 obgtxc7Z
 4LLGILXXqJwKqIcaMgA5EGnNPoxHzI8bZ68Mc2Q32f7zZZNnd343Qt6rQA+yDLugsI39+h00csB6CyChgm4PMgw76Mig6BzOe4yv63pxPdpvtkijMW+c/azyIVe5GKkuzfSM1TTy+CpV/tBsaoyu0LxGYd3oJ2tf+Gmthhb9lpH6bfljp2a7qDRrbFpxoovFbvaVM5HiazHYkpIBM2ODxG+nhI2E6rOh5BOZuxuEYFSxgPi4TMw+XJE3UfMo9ueVn0s2bX94xcWcxVWB3Qz5HE8HcTUJFVgFpJgpByo/Id26Fm5H53F0eOOjMzrabwZQvl00qnpCatSyr7qvkur6ZY2NIjkksi9d07wNCexbjDOoxsMb/S9aS6Atl8DWnsun6qlYddLlQRPZRw4hjHC7IKoTk8MbRgLrVhbAJIO7wvLW3E7F7a2slHzCJTfzkLVowD1u+bdOykmDfIRlKzWeLKvwbNqETIbR9AdvDUqze4r6r4Wa/mVtQLwsZesGkltV2jQoRIMDZAyqniK0vkZg1oWyoNcIYpuKp25MqUQuYlbadWyW7nQybxQy/N3Ep8ihhztkZ5EHxHaW9nVoieGu+1eLQ87IFBDn7rsVbgTIGE8VySKKf8saL8OtrcwQixZpnpnN46/mcZSO2Mcy3bb6Hbafo/APrDyKEpOWcK8n1wu4O5BKuLjYPDfwAXXPKoJzOt0m1/+/MVtGSaK67lqX7lcdt0JCaovNoMWXKafdj7jQZIc0aM2IH+saZR3kXbwwKG7JyQFsvW3/KFzDAuheXq4iBToeM69btwTDCUT1S9zApB9nvbIXXfyTqJuS5gw9QodTf/VCw1HZDzGzNzpmCl434Ttq7pS/4SYcIN7M0khz582LtF2YdP/RTnuISZJWo+jRY1tDAFf/2zFUHH4hsIv6z0Et8Crg3yH7MB2nVrocO0SbMZpSze9OJnW5n2rs+pYVJEDyz+E+wTfPHslDAvK7jqJ7J
 KVDITkVj
 TD1TpGJPgABNZLNsfcCphxrXIO6IN0n55ttL9NonS6L4HuEx2r6P5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
memory leak in __kthread_create_on_node

BUG: memory leak
unreferenced object 0xffff88811351d1b0 (size 16):
  comm "syz.0.38", pid 7021, jiffies 4294948268
  hex dump (first 16 bytes):
    66 32 66 73 5f 66 6c 75 73 68 2d 37 3a 30 00 00  f2fs_flush-7:0..
  backtrace (crc 73f9c04e):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4548 [inline]
    slab_alloc_node mm/slub.c:4870 [inline]
    __do_kmalloc_node mm/slub.c:5263 [inline]
    __kmalloc_node_track_caller_noprof+0x3e0/0x5d0 mm/slub.c:5372
    kvasprintf+0x6e/0xf0 lib/kasprintf.c:25
    __kthread_create_on_node+0x9e/0x1c0 kernel/kthread.c:491
    kthread_create_on_node+0x73/0xa0 kernel/kthread.c:559
    f2fs_create_flush_cmd_control+0x178/0x200 fs/f2fs/segment.c:707
    f2fs_build_segment_manager+0x212/0x3630 fs/f2fs/segment.c:5734
    f2fs_fill_super+0x14b1/0x3c20 fs/f2fs/super.c:5140
    get_tree_bdev_flags+0x1c0/0x290 fs/super.c:1694
    vfs_get_tree+0x30/0x120 fs/super.c:1754
    fc_mount fs/namespace.c:1193 [inline]
    do_new_mount_fc fs/namespace.c:3763 [inline]
    do_new_mount fs/namespace.c:3839 [inline]
    path_mount+0x5a9/0x1360 fs/namespace.c:4159
    do_mount fs/namespace.c:4172 [inline]
    __do_sys_mount fs/namespace.c:4361 [inline]
    __se_sys_mount fs/namespace.c:4338 [inline]
    __x64_sys_mount+0x1a3/0x1e0 fs/namespace.c:4338
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff88810b6a4700 (size 4544):
  comm "kthreadd", pid 2, jiffies 4294948268
  hex dump (first 32 bytes):
    04 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 01 00 00 00 80 00 00 00 00 00 00 00  ................
  backtrace (crc 71339aaa):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4548 [inline]
    slab_alloc_node mm/slub.c:4870 [inline]
    kmem_cache_alloc_node_noprof+0x373/0x4d0 mm/slub.c:4922
    alloc_task_struct_node kernel/fork.c:185 [inline]
    dup_task_struct kernel/fork.c:916 [inline]
    copy_process+0x286/0x28c0 kernel/fork.c:2050
    kernel_clone+0xac/0x6e0 kernel/fork.c:2654
    kernel_thread+0x80/0xb0 kernel/fork.c:2715
    create_kthread kernel/kthread.c:459 [inline]
    kthreadd+0x186/0x250 kernel/kthread.c:817
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888109f45f00 (size 184):
  comm "kthreadd", pid 2, jiffies 4294948268
  hex dump (first 32 bytes):
    02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 5ee6cb00):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4548 [inline]
    slab_alloc_node mm/slub.c:4870 [inline]
    kmem_cache_alloc_noprof+0x372/0x480 mm/slub.c:4877
    prepare_creds+0x22/0x600 kernel/cred.c:185
    copy_creds+0x44/0x290 kernel/cred.c:286
    copy_process+0x7a7/0x28c0 kernel/fork.c:2084
    kernel_clone+0xac/0x6e0 kernel/fork.c:2654
    kernel_thread+0x80/0xb0 kernel/fork.c:2715
    create_kthread kernel/kthread.c:459 [inline]
    kthreadd+0x186/0x250 kernel/kthread.c:817
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff8881096f8240 (size 32):
  comm "kthreadd", pid 2, jiffies 4294948268
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    f8 6e 0a 00 81 88 ff ff 00 00 00 00 00 00 00 00  .n..............
  backtrace (crc 13ba6aa5):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4548 [inline]
    slab_alloc_node mm/slub.c:4870 [inline]
    __do_kmalloc_node mm/slub.c:5263 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5276
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    lsm_blob_alloc+0x4d/0x80 security/security.c:192
    lsm_cred_alloc security/security.c:209 [inline]
    security_prepare_creds+0x2d/0x290 security/security.c:2763
    prepare_creds+0x395/0x600 kernel/cred.c:215
    copy_creds+0x44/0x290 kernel/cred.c:286
    copy_process+0x7a7/0x28c0 kernel/fork.c:2084
    kernel_clone+0xac/0x6e0 kernel/fork.c:2654
    kernel_thread+0x80/0xb0 kernel/fork.c:2715
    create_kthread kernel/kthread.c:459 [inline]
    kthreadd+0x186/0x250 kernel/kthread.c:817
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888125626e40 (size 192):
  comm "kthreadd", pid 2, jiffies 4294948268
  hex dump (first 32 bytes):
    02 00 00 00 00 00 00 00 00 00 00 00 ff ff ff ff  ................
    01 00 00 00 00 00 00 00 60 4a 8a 82 ff ff ff ff  ........`J......
  backtrace (crc 3a1ec858):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4548 [inline]
    slab_alloc_node mm/slub.c:4870 [inline]
    __kmalloc_cache_noprof+0x377/0x480 mm/slub.c:5379
    kmalloc_noprof include/linux/slab.h:950 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    set_kthread_struct+0x58/0x150 kernel/kthread.c:107
    copy_process+0x15b8/0x28c0 kernel/fork.c:2152
    kernel_clone+0xac/0x6e0 kernel/fork.c:2654
    kernel_thread+0x80/0xb0 kernel/fork.c:2715
    create_kthread kernel/kthread.c:459 [inline]
    kthreadd+0x186/0x250 kernel/kthread.c:817
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff88812cb53700 (size 64):
  comm "kthreadd", pid 2, jiffies 4294948268
  hex dump (first 32 bytes):
    20 09 d5 89 ff ff ff ff 00 00 00 00 00 00 00 00   ...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc e7a33bad):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4548 [inline]
    slab_alloc_node mm/slub.c:4870 [inline]
    __do_kmalloc_node mm/slub.c:5263 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5276
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    lsm_blob_alloc+0x4d/0x80 security/security.c:192
    lsm_task_alloc security/security.c:244 [inline]
    security_task_alloc+0x2a/0x260 security/security.c:2682
    copy_process+0xedf/0x28c0 kernel/fork.c:2205
    kernel_clone+0xac/0x6e0 kernel/fork.c:2654
    kernel_thread+0x80/0xb0 kernel/fork.c:2715
    create_kthread kernel/kthread.c:459 [inline]
    kthreadd+0x186/0x250 kernel/kthread.c:817
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff88810b507180 (size 1152):
  comm "kthreadd", pid 2, jiffies 4294948268
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    90 71 50 0b 81 88 ff ff 90 71 50 0b 81 88 ff ff  .qP......qP.....
  backtrace (crc ef1916d7):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4548 [inline]
    slab_alloc_node mm/slub.c:4870 [inline]
    kmem_cache_alloc_noprof+0x372/0x480 mm/slub.c:4877
    copy_signal kernel/fork.c:1700 [inline]
    copy_process+0x10da/0x28c0 kernel/fork.c:2220
    kernel_clone+0xac/0x6e0 kernel/fork.c:2654
    kernel_thread+0x80/0xb0 kernel/fork.c:2715
    create_kthread kernel/kthread.c:459 [inline]
    kthreadd+0x186/0x250 kernel/kthread.c:817
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF


Tested on:

commit:         1f318b96 Linux 7.0-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1751f8d6580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2c6ad6fefffa76b1
dashboard link: https://syzkaller.appspot.com/bug?extid=cae7809e9dc1459e4e63
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10def8d6580000


