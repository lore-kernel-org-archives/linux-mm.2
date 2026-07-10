Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B1DFC44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 07:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6622A6B0088; Fri, 10 Jul 2026 03:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 612896B008A; Fri, 10 Jul 2026 03:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 529766B008C; Fri, 10 Jul 2026 03:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2AE966B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:48:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF02C8D656
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:48:18 +0000 (UTC)
X-FDA: 84972089076.10.3F221A3
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf07.hostedemail.com (Postfix) with ESMTP id 059BE40002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:48:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3wKNQagkbAKMVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3wKNQagkbAKMVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783669697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=18vfEjJh39zqM38jFcXdkikUnYbrKM4RExAzoNks+6k=;
	b=ZomJGU38deiWmdmkbf9uKb+cQwyrDmvBCpXGdVMES8yI5XeZThegXHkPe7VFKxF/xV+NHE
	sw03Lmv9G43Ih28Ec2lOoDtFhXZRgRV3NQb6bRKOGTkSkRz1P1dsFG+QFMrtgPsPqqwQf3
	EYs5NNi2+wptN806JgaHw0S10iBTWxc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3wKNQagkbAKMVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3wKNQagkbAKMVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783669697;
	b=DFilvzHTuKmkOCC+9fcIoKFu+mtTXV123n7mjwJOTaNEYinHEluVCKl5OEF39F7KOs5u0o
	Yb4/N0Vuski43PzfYRq/tEaIV+alLSe9WSvodQ50WUSRJ4QgP9dfXANLYfeyW+TfayNsYz
	W4kVKaLi6ttKtk8pO2lIZdriVx5p0s4=
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-49ab6a82cd5so687930b6e.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:48:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783669696; x=1784274496;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=18vfEjJh39zqM38jFcXdkikUnYbrKM4RExAzoNks+6k=;
        b=DPqdR5zBjoMuChiLRw6O8TQIG/ujAco2sHiKpuen7vls8iOa/6YVCl7RL0z++ZmyML
         FqeAnzPpXM4kPkyqI6ApvIdDT7DOwS1AyFgDzFkd+r1lN2sbsHTNJ2pDewlfn4iiO+Dv
         pof9SvldHUn4PAzPDdf5GxKN/eO7n9bit0J7hgMx5bfHckejGq3nG/huYTMEQVik2qzr
         3lKhtVlLgb23uW/BDOD3AXX01cF2lCRniv/faAT+2tMRLixwwvGxOYsh5TipptDKLBwA
         5Lc9KJg/2bHhUmuBcZFtMVYoSF/HTGNLHVzqMr4aQd+GQaWGzKBrabFDwFBk/YPGSgmA
         tCaQ==
X-Forwarded-Encrypted: i=1; AFNElJ8anoJXNPvuZagEQ4l3GkLzxzzzKI4BWcnFfvoDBZVmnuyhmX8EGiBhISVyiedXE0PBgxQJGBFWPA==@kvack.org
X-Gm-Message-State: AOJu0YwJgQ1QLU5bHjZrU+0LOc9siQOtxkXxxmmajOZbP8Cc86CENxE6
	voJWx9IECSbx00LEy2aRvKfJFBA4ViN/CNDpTXiG4JpmjTLtVvqRC2zWnwsaSMG7qT9sHARAu8j
	0yBxSShbQaTHdcJUJT+ul8iNkDt11OQX1E2eO4iO7nLP66xfo8hG+1KeiKJU=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1a10:b0:492:f15e:3626 with SMTP id
 5614622812f47-4a206affb0dmr7600731b6e.40.1783669696285; Fri, 10 Jul 2026
 00:48:16 -0700 (PDT)
Date: Fri, 10 Jul 2026 00:48:16 -0700
In-Reply-To: <20260709075613.854-1-coregee2000@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a50a3c0.c76b52dc.2a15e.000b.GAE@google.com>
Subject: [syzbot ci] Re: ext4: fix use-after-free in ext4 delayed I/O completion
From: syzbot ci <syzbot+ci87fd14106ebafa1b@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, akpm@linux-foundation.org, coregee2000@gmail.com, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, willy@infradead.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: zwh9cur4eqnm9rztu6494j674z8kmubr
X-Rspamd-Queue-Id: 059BE40002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783669696-686644
X-HE-Meta: U2FsdGVkX1+vGV5O7Xv5PAaX4tlS64xAfeWk8Cj3g0oYGlfOJeRmDk+P3qgulcJPsli1g6D5p1YEgaqlyBGTzkrFy+9MyxC//eXfC2zAqNadDKgPui3pMolW62hFT0vQ3KkybjnmynizvwYQozQFoJjrv8asp3BjmC7gFOtfTsUnhXRwWvz5hLRY3mJbr8AQsttbd7QoTjBpWnNRW8W3gZOfSUoH/qIjrKzyAHKLjKWngUHOWPSj9d+1aK22/dHddjEMbiTFdVfgqPkZG0hXLhCb1a+DQUPQa9q0/fpk8dSIxQyM9getsEf3FKv8BAYodKtQ4S/5tXOWoeWCx71spDsZ47zXp19ajZ2XjMyEAhyGTt+s9nqi1kmLaxWq98ebSt3iYXO4PsUVmCWEFMmcJ2+Yoi2Q4JkGbTyXeOJV9kVv1wBQD9Ohcsyb9GcXAaIJjD1mYmZTMsogxAolxy48IvUrnRsE/LhrZB6FVhZiz9ByBn/+sLdTkzU9O7HdCNosocBkNbtZokjTVFzhAWyhQ1VVYz/ZsCAtXCq5v0JKlxCgFW1tIdxDi6yyvsf8Li/aI6Frj0rgiPi5z6mfyh7DPsgcpyQPtsGf4QJpc+Z1pSZNzWCieYiHvbUUklUvDWz7nkKpaxDfPK8GwSZb2pmfHsnaXgZHhbwEhph8X8Jp/2eZDb4KW9uyg7e0G8kw02FXpaGLT0/NwV4mmqDoEpuMXZzmZCE2ZymvI+zdsybWLPZzYWwQ5pm4vcduChg91IXQw91qJQAIJefzuhecnQFAG/ht0/Zf9dugq4hy9/2hhYPGWHLo4snic6PNKzso4zc+gpab658mLa1NzXSs0rTFip8TOL2eCTa1138+Pm4mSuCfxndeV9Wwx1kShwOb6fFz7mYkzqFHAIEjz0pEmo6BqIRrjFFaT2XzjxxmgXz8zYAKFvnvTYw1ByaTuHWzI93EhTW0SI3DnpqIvqhQT/U
 8HE1k7Ho
 QJXesDbudP3cb9hWCnaj/Wb6TKW7Is1SqaIn+vPA2nrsOyfREqH0T+4KRZcqbmI95HWgF0f2ss6PH9hxlTqYtR6lhvl38gC27vPqfy3yGZLys3CdXTInm/c4TuGYtrtRqJychqeQjXLNUIoWk0xaeiRLSyxPRQscFEyg9K428X5eNwxgmvTbz7SgSxtVI0/m/maQq3PC+/qJif9wwsZou2IQnbTVkUJecl+1ye7WHYCBcRlvV8illAu0u1o+mE2GM1hZAsHVw+/FawYnT++TY0SbQ1b5UFSNDog9/qreNt5kTW8GOJDqp/qtiyQ1B11G9SeXKf/aDw/9unVREB94izT2E1ya4BLjvc1efwY15eWmeJUA6Ph2a2p1bN8L5AVY9J4Xc8bdJTrt9kpQOaRwapPKgJ0aFgMHmwuY5IZayDFfqO8DjwiHa+XdnGwWFSl+gfs7/RJogi0n4ZeBiVFLROQ6NRfVtfKeDJGSymruMh376FvTNA1yi9nEzh8nwbY4rvGJW1aZeyG+aip5XNgi3XMAVgcQV3Hz7QYLTZ0yLdBxGjrjPUlCdhyCRc2KB5Cn+GELZYPvp2VKM6vcUFmtqjcsgUeYtM31FB7SJUmIFQOshc/NogxIKvNmvxgXCDzlGurWuGNVIPYelScSPXBGyXMP3lZ5BDRh/WbIkAg79QwY0PskGs+YADn63kgdrwwCCj24ICscbKP4Ok1v7yH8FajMtX1Mokh9OBlS8Rqtk+Y04N9Haf3S+1HhVncVN5uQxoJSzr3EifsRiA64kq7ioUrCyFzOoNz5+JXAegLijjSEf7krCibV6ILEuaj52oSya9vyFzlIQxIr3M2OD1XN8yFl00P62JSNZj02RZ7i2MCNyBeoLi9ZITIbakOMWHW+DaLYVHkuKckJj7DLUtlFKsJEFo9pwv7vOrprNMuzoOOFER2AVrTqUV93yKyPxf/Wt8Nh/+bIVyjv1D48=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] ext4: fix use-after-free in ext4 delayed I/O completion
https://lore.kernel.org/all/20260709075613.854-1-coregee2000@gmail.com
* [PATCH] ext4: fix use-after-free in ext4 delayed I/O completion

and found the following issue:
inconsistent lock state in igrab

Full report is available here:
https://ci.syzbot.org/series/91c98fac-dc4f-4090-8c56-abbc36b7cd36

***

inconsistent lock state in igrab

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      86f436567f2516a0083b210bedc933544826a2c3
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/7d4608a1-deef-4f49-aff7-ee231c101f0a/config

================================
WARNING: inconsistent lock state
syzkaller #0 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
swapper/0/0 [HC0[0]:SC1[1]:HE0:SE0] takes:
ffff888112ebb350 (&sb->s_type->i_lock_key#23){+.?.}-{3:3}, at: igrab+0x2d/0x1e0
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire+0x116/0x340
  _raw_spin_lock+0x2e/0x40
  iget_locked+0x397/0x6a0
  __ext4_iget+0x242/0x4290
  ext4_get_journal_inode+0x30/0x1c0
  ext4_load_and_init_journal+0x231/0x23f0
  ext4_fill_super+0x3a64/0x6560
  get_tree_bdev_flags+0x430/0x4f0
  vfs_get_tree+0x92/0x2a0
  do_new_mount+0x325/0xac0
  init_mount+0xc3/0x110
  do_mount_root+0xf4/0x260
  mount_root_generic+0x1a7/0x370
  prepare_namespace+0x71/0xa0
  kernel_init_freeable+0x36e/0x4b0
  kernel_init+0x1d/0x1d0
  ret_from_fork+0x5b0/0xb20
  ret_from_fork_asm+0x1a/0x30
irq event stamp: 682389
hardirqs last  enabled at (682388): [<ffffffff81862340>] handle_softirqs+0x1a0/0x850
hardirqs last disabled at (682389): [<ffffffff8b73ff0e>] _raw_spin_lock_irqsave+0x8e/0x100
softirqs last  enabled at (682374): [<ffffffff81862c35>] __irq_exit_rcu+0xd5/0x1f0
softirqs last disabled at (682387): [<ffffffff81862c35>] __irq_exit_rcu+0xd5/0x1f0

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&sb->s_type->i_lock_key#23);
  <Interrupt>
    lock(&sb->s_type->i_lock_key#23);

 *** DEADLOCK ***

1 lock held by swapper/0/0:
 #0: ffff888112ebb880 (&ei->i_completed_io_lock){..-.}-{3:3}, at: ext4_put_io_end_defer+0x442/0x700

stack backtrace:
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <IRQ>
 dump_stack_lvl+0x1a9/0x280
 print_usage_bug+0x28b/0x2e0
 mark_lock_irq+0x410/0x420
 mark_lock+0x115/0x190
 __lock_acquire+0x65c/0x2cd0
 lock_acquire+0x116/0x340
 _raw_spin_lock+0x2e/0x40
 igrab+0x2d/0x1e0
 ext4_put_io_end_defer+0x4d0/0x700
 blk_update_request+0x57b/0xe30
 scsi_end_request+0x77/0x820
 scsi_io_completion+0x133/0x360
 blk_done_softirq+0x10a/0x160
 handle_softirqs+0x275/0x850
 __irq_exit_rcu+0xd5/0x1f0
 irq_exit_rcu+0x9/0x30
 common_interrupt+0xbb/0xe0
 </IRQ>
 <TASK>
 asm_common_interrupt+0x26/0x40
RIP: 0010:pv_native_safe_halt+0xf/0x20
Code: 57 5e 02 c3 cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d d3 07 18 00 fb f4 <e9> cc f3 02 00 cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90
RSP: 0018:ffffffff8e007d80 EFLAGS: 00000286
RAX: ec158cdc8cc84600 RBX: ffffffff8198983a RCX: ec158cdc8cc84600
RDX: 0000000000000001 RSI: ffffffff8da4eee4 RDI: ffffffff8be557c0
RBP: ffffffff8e007eb0 R08: ffff8881210336db R09: 1ffff110242066db
R10: dffffc0000000000 R11: ffffed10242066dc R12: 1ffffffff1c12a78
R13: dffffc0000000000 R14: 0000000000000000 R15: 1ffffffff1c00fbc
 default_idle+0x9/0x20
 default_idle_call+0x72/0xb0
 do_idle+0x1ea/0x4e0
 cpu_startup_entry+0x43/0x60
 rest_init+0x2de/0x300
 start_kernel+0x3a6/0x400
 x86_64_start_reservations+0x24/0x30
 x86_64_start_kernel+0x137/0x1b0
 common_startup_64+0x13e/0x147
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

