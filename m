Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 238B3CD8C8C
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 22:02:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94F0B6B0088; Sun,  7 Jun 2026 18:02:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900106B008A; Sun,  7 Jun 2026 18:02:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815A16B008C; Sun,  7 Jun 2026 18:02:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 715446B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 18:02:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 151B11C1FEB
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 22:02:33 +0000 (UTC)
X-FDA: 84854491386.19.3D99BAE
Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5C34F10000E
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 22:02:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf05.hostedemail.com: domain of 3duolagkbADspvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.207 as permitted sender) smtp.mailfrom=3duolagkbADspvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780869751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=QrnJscUqb8nFwrlaHYcAxf2BdfKALHQGG36qMQ6iurs=;
	b=4eLyG3iNzrI2Oeav5s7g8UbUNxgvXSnF6L/3QqPpA7gUFpt1w0pFS4IqEiM3qlY9Z284ZB
	5L1Bv3EKQyo1XSKQ1dPbhZcH0IJ2ayFqXJCpGM9eLuFttv9TVlHsH61JTcny03PXinBwl9
	zw1N141wfyspTWT964sZchaPVJGL1Z0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf05.hostedemail.com: domain of 3duolagkbADspvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.207 as permitted sender) smtp.mailfrom=3duolagkbADspvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780869751;
	b=eq2hi11EMN5GkukP+3YkAAg95l/qyWEWPueF54jyFnzXe6KAxeNebUacqwXEnAdEb0NbW+
	7sfB4h/1EPFzRGjQKU/yjvdCpdzMsvTYLcBHUt4ek+tNfyyfmVgDFHd0uIVQqw3B067EHv
	ZgwR+p2AWMG/pkYkfxDB3uE7FIfNumw=
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-4865ab81f1fso608630b6e.1
        for <linux-mm@kvack.org>; Sun, 07 Jun 2026 15:02:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780869750; x=1781474550;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QrnJscUqb8nFwrlaHYcAxf2BdfKALHQGG36qMQ6iurs=;
        b=ZjMaZ6D8SKLi8p3Fg88FPUqhZiKlpRvNJda1w5iXejIiK1DkWFC7bRbrIQ6QOMUVGT
         MAEAAk3m8T/a/R7MvKU3IkODON6CphUHnZLXK80KnbJNw6v+vZWsj6c65uCSIAhDQcKR
         sLadcg3AhOtAC8GHbZpkD2rJA4LjIfvmzSIVmJy8TCfKhQ6KfXkR0XQ3nRlVXo5ATWpm
         yw6U4/O5+GvsCk4wy22N48co8DlDsfDl4p8B0/DGqRo+3+tzDtzEAZLqK+YwFuOZz0cb
         r8yawloKuGQhyYDxwtvDTMraHqwLsO//NvSELRI0sE0TG3cGYuvroYGoWE/OS5ybaKbm
         uwLA==
X-Forwarded-Encrypted: i=1; AFNElJ+Ebcno3Lb8cd/lZwJDTyJNiuygTNm5eHxE/rHXaIpYyTD1BTOLWoXqjaJybMup2BUzmIQUdqVjTw==@kvack.org
X-Gm-Message-State: AOJu0YyqMhAptKKivzGbdvswfqnxONoFTJLs0YzdkZK+93x4uqDWJUyM
	1nmehQBSQtv1Vi3t7r1bC2fj457H7Zr7pR6S5xB9AbK9bVhayrImJRw+tKY+YcGl4TtYSLrtDIC
	ECx4zOcyZodH/rYAsew9tbiSa/89tGzQCPeua4+7o8tauDyzudCxZdOBJc8A=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:451:b0:69e:3dde:8695 with SMTP id
 006d021491bc7-69e68c9433emr5423015eaf.54.1780869750317; Sun, 07 Jun 2026
 15:02:30 -0700 (PDT)
Date: Sun, 07 Jun 2026 15:02:30 -0700
In-Reply-To: <69a69eb7.a70a0220.135158.0008.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a25ea76.c25708ab.1b19ef.000e.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in __dentry_kill
From: syzbot <syzbot+f8ccdac0a7eede0e1ae5@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, brauner@kernel.org, hannes@cmpxchg.org, 
	jack@suse.cz, jackmanb@google.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, 
	netdev@vger.kernel.org, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org, viro@zeniv.linux.org.uk, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: k8f79qzefexstyrrpycoaf3ooyxnfja9
X-Rspamd-Queue-Id: 5C34F10000E
X-HE-Tag: 1780869751-806870
X-HE-Meta: U2FsdGVkX19WNYwZg4sDvgizH0CZ9ci/1IYN+VndPm0mzyJctUryEJYKqpNfIekV1xkH6oQwq7xYuLAT86LUO8RNQWZCGyhQaSSkgRy+8J2v5T/S0Lu/85RrxvLmNK64Q++u1xpFc0WRBVQbyJUZ8z+TGETdPQ8GSpyZZeP/TelFmP5JVk8mgyyaPr4bKHnM11ppOwG91OVWrFvt/oa0oRvr56Oez7F3qGmnUVu783tKF58uQqJmOdiadSrZtnHi72kaDNUcx7pzEZ1c5zFebtZe2DrjwXHDlc1ZUecaqy81OVYZJaGfpU6H5OoZuds9tBri3CbxBNMUT7pZiJz/cYBZfUaDdSPQoUKqSFrx7T18QyW//w8YYl1liFj25xzterUc+jsO2uRCWIxVUtR8JFdYTQR8+5GtBrYMFfmS/xziulJWSCXYlzjSEFvN2hKXbHye55qJ2bqlmmS1pu+OYDtS0OBlVVQ9Kk2VgKC2yWov8W2nNy1aJjEcc5cyAUqdBxoFiXyapqnf7O/uYQ371jfJvIcDqdJqDQiRE0JuDAt/sp8fcu4ldq3oPKKisiGpkQE97GqzZASJYG9HCsPKrnjCwOUTp+PQG9oZpTpPGpHM4hZ72+NKDLaPnhCFQSH5oQCYiAKHAGmdozSCYDfJaN2UWq0eyozhBwAJcvY32jXScnQboGruqwPm0jAB3tuFvjDFdyVqL8PedCxEy3bnDTWb0XsFc8TdZJf5zxz9a2DJjeJQzUBz9d1aD6mbsrouBHTLNkVnpVKP4bBvxs1dFAlf20rMpIuASGNqZknWh+7EWRcDZChmKaR0OkR0G7aiSSbKaL4uGoSr82SyglcXviCKfKk9L1sOO+q14Az9lB6ARscs6OxMs6xYEMgePaV/FrBHB7Ytd3U93U259hj2yBz0QlGEKUwvoMVC7eJE5d/BocxJvMYruvx9YyWNwb5ZFpedWHutZRJdtdtuEcL
 ye0F9qxj
 qBBudF2rMqDXxT1VEimQgnBtR5xS+mFY4IVGH1B77O4MhgQfYAqiF/2lN0eLXKRUnz1PUWvn6toRiN3J0edH9jak+H24emacR8NGwFUAaaqwFjda8BNuL/nnx5zFeoMz4sWhKg/lCXMn/Kmye5IdhcrtftWew/ElpZ/rrGhKr+pa8JKsi/Me0CGjGYCdO4rvpk8CawKzqlnmpSEOw5H+3GlUJBRs2nDihzWWASgRjkico5F9Ocxrwuo0GqXliCEqkYgbdTyLxk6Hlnq1TR0W/ebEwMQlfnPuDgnnzMsNIMVPsTp9um7RS7i77u/PkL43T1wtqR0ppkLlb3Oyvvmb2hHoh+PYmuvzXDswnNFNkPF7lw/BuQo9HpAiHr8+YPNEWjrglv6v3e8G9Di/SpSIHdEr5J/I7LrEhSQrHh6gceJHoALVWwCz4Mc1jdZXspKFV3HyqDvjEP5+UNlCd9y9bfVcfRpdLuaFoztqDWfv+cNJ1IeUQ0o5Nimg8CfL96/IPHa5yfiuyzsNYNpSiVLe1WSJ/UqeCfSXgPrpKB8zbYPTGRLe0pNWboyH0vPhCAUjflGct1rar/pZ3I7dBoqfOuL+IxJQrxKgVQXC6Xq3EBoXocJyk8tBjIuj+Afh9ISHCzalD6fSy4QryNCFxReuMySm7hR1jorz+NU9YLohhE7auw6Djbyr5sK0W/mD9b0VxmwgyjyBXea2Hi3Vmi0JQ/f+bxHIzpHjOqc3uyWXaGG33M0kief5rZfJpTTzmfQEejs2vlqILzQunRbA6XudftbTOXEK6w1pNg3NnHANFwZSgMmZPrAGQs/Yrv3LjIX9nxKqBbdGliLFo935uZ0ba8mGao0ygwEfqqCvlRBK8Up4zJHgMtUIHz9ss23ppb5+7WcLhzswwVdOqGCQqbms1xrvrvfrvV67j8L0ZLgtlDGTZ2Lpuai0hMxEkDFXRv3t2U17+mZv/GtvXIaQ0uqx3QrGgIWRM
 KOBCiw+i
 rLn16DRshzwtQHM2QzaD1RLejKQOASE6ZHifNrlYaKInTxqfsLZImcRaVDfB4AEOtayTUV49booLeDquqZo2HW2DDziv6xAvx6AJD5LSjH5MhgB0OHmwelGjvUzN96125YaakjNFnRXs9PnRPdzJNtxqInPdm7fmVp4OwT27GWS0rBqr+XdB2hbTcvvJcouM52xGoCCcKD1MQcUAK0u1E4DSThxbLEZbu8xuVpVBBOVurnYg+OXE75eKGZEMq3zkywkZrXL07GehSAXpm+io4rHJiphI4yU8n3eZ/UN9Ci8OntgrrIRhkIFJgIRklIqKXbTLuvuFujizorgrn8sN91Rat7wZPbg2CAxkWS7Kh/j+oe3Q3frPPKyVGni7W3YI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    9772589b57e4 netlabel: validate unlabeled address and mask..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=13230bec580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=65472e27d1590a04
dashboard link: https://syzkaller.appspot.com/bug?extid=f8ccdac0a7eede0e1ae5
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12fc5e7a580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/54d0bafddbc5/disk-9772589b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/82dd93b33708/vmlinux-9772589b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5ab8ee618a60/bzImage-9772589b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f8ccdac0a7eede0e1ae5@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P5788/1:b.el
rcu: 	(detected by 0, t=10506 jiffies, g=15749, q=1307 ncpus=2)
task:syz-executor    state:R  running task     stack:21752 pid:5788  tgid:5788  ppid:5780   task_flags:0x400140 flags:0x00080001
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5388 [inline]
 __schedule+0x1821/0x5740 kernel/sched/core.c:7189
 preempt_schedule_irq+0x4d/0xa0 kernel/sched/core.c:7513
 irqentry_exit_to_kernel_mode include/linux/irq-entry-common.h:539 [inline]
 irqentry_exit+0x14f/0x8b0 kernel/entry/common.c:164
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:__orc_find arch/x86/kernel/unwind_orc.c:101 [inline]
RIP: 0010:orc_find arch/x86/kernel/unwind_orc.c:238 [inline]
RIP: 0010:unwind_next_frame+0x4d6/0x2550 arch/x86/kernel/unwind_orc.c:510
Code: 00 00 83 f8 01 4c 8b 7c 24 50 48 bd 00 00 00 00 00 fc ff df 4c 8b 6c 24 20 0f 84 86 16 00 00 e9 03 02 00 00 49 89 d5 48 89 d5 <48> 89 d8 48 29 e8 48 89 c1 48 c1 f9 02 48 c1 e8 3f 48 01 c8 48 83
RSP: 0018:ffffc90003c2f4b8 EFLAGS: 00000246
RAX: ffffffff9052f1d0 RBX: ffffffff9052f1d0 RCX: ffffffff9052f1d8
RDX: ffffffff9052f1d0 RSI: ffffffff90d3bfc2 RDI: ffffffff8c28b880
RBP: ffffffff9052f1d0 R08: 0000000000000003 R09: ffffffff8e95cc20
R10: ffffc90003c2f5d8 R11: ffffffff81b0e0e0 R12: ffffffff8243249e
R13: ffffffff9052f1d0 R14: ffffc90003c2f588 R15: ffffffff9052f1d4
 arch_stack_walk+0x11b/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0xa9/0x100 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4570 [inline]
 slab_alloc_node mm/slub.c:4899 [inline]
 kmem_cache_alloc_noprof+0x2bc/0x650 mm/slub.c:4906
 kmem_alloc_batch lib/debugobjects.c:371 [inline]
 fill_pool+0x156/0x580 lib/debugobjects.c:420
 debug_objects_fill_pool lib/debugobjects.c:752 [inline]
 debug_object_activate+0x4a3/0x580 lib/debugobjects.c:841
 debug_rcu_head_queue kernel/rcu/rcu.h:236 [inline]
 __call_rcu_common kernel/rcu/tree.c:3116 [inline]
 call_rcu+0x43/0x890 kernel/rcu/tree.c:3251
 __destroy_inode+0x2b2/0x640 fs/inode.c:369
 destroy_inode fs/inode.c:392 [inline]
 evict+0x8a7/0xb10 fs/inode.c:865
 __dentry_kill+0x1a2/0x690 fs/dcache.c:718
 finish_dput+0xc9/0x480 fs/dcache.c:927
 __fput+0x691/0xa60 fs/file_table.c:518
 fput_close_sync+0x11f/0x240 fs/file_table.c:615
 __do_sys_close fs/open.c:1507 [inline]
 __se_sys_close fs/open.c:1492 [inline]
 __x64_sys_close+0x7e/0x110 fs/open.c:1492
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7efe5039bfc7
RSP: 002b:00007fff8a26cfa8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007efe5039bfc7
RDX: 0000000000000000 RSI: 0000000000008933 RDI: 0000000000000005
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000004
R10: 0000000000000005 R11: 0000000000000246 R12: 00007fff8a26d03c
R13: 00007efe504334c0 R14: 00007efe51144620 R15: 00007efe504334c0
 </TASK>
rcu: rcu_preempt kthread starved for 5285 jiffies! g15749 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27688 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5388 [inline]
 __schedule+0x1821/0x5740 kernel/sched/core.c:7189
 __schedule_loop kernel/sched/core.c:7268 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7283
 schedule_timeout+0x158/0x2c0 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x312/0x11d0 kernel/rcu/tree.c:2095
 rcu_gp_kthread+0x9e/0x2b0 kernel/rcu/tree.c:2297
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 0 UID: 0 PID: 1163 Comm: kworker/u8:9 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
Workqueue: events_unbound toggle_allocation_gate
RIP: 0010:csd_lock_wait kernel/smp.c:342 [inline]
RIP: 0010:smp_call_function_many_cond+0xfcf/0x13d0 kernel/smp.c:892
Code: 79 45 8b 2e 44 89 ee 83 e6 01 31 ff e8 aa 07 0c 00 41 83 e5 01 49 bd 00 00 00 00 00 fc ff df 75 07 e8 55 03 0c 00 eb 37 f3 90 <43> 0f b6 04 2c 84 c0 75 10 41 f7 06 01 00 00 00 74 1e e8 3a 03 0c
RSP: 0018:ffffc900058e7700 EFLAGS: 00000293
RAX: ffffffff81b9b376 RBX: ffff8880b863c388 RCX: ffff888028eb3e00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc900058e7840 R08: ffffffff903034f7 R09: 1ffffffff206069e
R10: dffffc0000000000 R11: fffffbfff206069f R12: 1ffff110170e81b1
R13: dffffc0000000000 R14: ffff8880b8740d88 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8881252a0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7680c6904c CR3: 000000000e74a000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 on_each_cpu_cond_mask+0x3f/0x80 kernel/smp.c:1057
 on_each_cpu include/linux/smp.h:72 [inline]
 smp_text_poke_sync_each_cpu arch/x86/kernel/alternative.c:2773 [inline]
 smp_text_poke_batch_finish+0x5f5/0x1160 arch/x86/kernel/alternative.c:2983
 arch_jump_label_transform_apply+0x1c/0x30 arch/x86/kernel/jump_label.c:146
 static_key_enable_cpuslocked+0x128/0x240 kernel/jump_label.c:210
 static_key_enable+0x1a/0x20 kernel/jump_label.c:223
 toggle_allocation_gate+0xab/0x290 mm/kfence/core.c:906
 process_one_work kernel/workqueue.c:3314 [inline]
 process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

