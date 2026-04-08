Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1932710FC456
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 23:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2861F6B0005; Wed,  8 Apr 2026 19:31:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 236DE6B0088; Wed,  8 Apr 2026 19:31:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 126B46B008A; Wed,  8 Apr 2026 19:31:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB39D6B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:31:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84C0114032C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:31:30 +0000 (UTC)
X-FDA: 84636987540.02.7CF261C
Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0900940004
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:31:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of 3UOXWaQkbAMs9FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.80 as permitted sender) smtp.mailfrom=3UOXWaQkbAMs9FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775691089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=NoYggn+qx724MoEOa8/BdCCOa7KoDJVNQ5qZ3LW9kA4=;
	b=egz2CzbKZQG0rWFNc+79OdUNjz4mWW6eD71cQ0mXo3OksKTyT3utYJjw3vNZDNNN2hA9Lh
	cNtcf6/uZP9ax9sA71iQq1/YdCdhoL7zweHY8I6Ex8mqQJgKbyOPmCARGE0zByiFzN1wxP
	MKArkZ3YQW3JqtA4mfFTDNBhRc7tuYo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775691089; a=rsa-sha256;
	cv=none;
	b=17ZE1xitewVCFlKstM83Rf4vpVnehe5Hc8BdbDeWxpLtwPqTwwp1GONipXG75NMu/724Be
	MAdGt4SV7m3rv+bNNDJD6mqA/8mFlpfWQOZRdbTR7jiqKcecM4giznn/TCXDXrgdu8xQ6A
	JkHd8cXqMDFzW1Yr5/S16/apuc6jMp4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of 3UOXWaQkbAMs9FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.80 as permitted sender) smtp.mailfrom=3UOXWaQkbAMs9FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7dbb7625a6eso910176a34.3
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 16:31:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775691088; x=1776295888;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NoYggn+qx724MoEOa8/BdCCOa7KoDJVNQ5qZ3LW9kA4=;
        b=IXs91kTkCALgWmhBnhbTH+Ai2eBnWeQ1xChv99uyO7r5cxpGz3AcFytMK8IN8fKWeX
         xjrNxBO0GdhC30FdANnDpCUG/26v81Osk0mhKJyzOFxoim3uXZp9a2T6yufalNxfOK8U
         jZ0ppyh7jR4PTan2bFWvgVmlU+PtIo1QQ8g299xXQKK0+ZxTj2ugwL7Mu8UjyBz+0Q+N
         rE+tKrUv33It2AtTaaUK3h3QaCxMtrzCvYJQmDoxyb9PBz1NUknyDzOpVyP+DDP327yb
         /vhEG38nh90vFn6tQEZVRgL9ffmc4PuzYFgMO+Jhl1uW6BByISqfYWCrlFriHbq76jfu
         J6Fg==
X-Forwarded-Encrypted: i=1; AJvYcCWaTA8IGZ7KmqvyTNyAD1vQNQT2mMsWZ0ZWFsgjWxp5XVf2iodU3gaIHcObzR1A+pDG12NqTiMgUw==@kvack.org
X-Gm-Message-State: AOJu0YzEnEpd5GpNaFmqRoN6ZoejPCcKm3FrX2XygFNS8jMYT2LQD4IT
	0yV/xuMTHOf/uMSC7tkhDUfVkvXh/ZMIpbS9B8P2hugAdYEqomjqvLYv0xnSYEQerkrk2dP33A1
	qt6Kvo7OSx18XvA+3Xb1vv633n90nXpjIH3MS/a8ymgiNtcE3SOptXnMxMD4=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:81c4:b0:67e:160c:36ba with SMTP id
 006d021491bc7-6822024eb9cmr13775788eaf.48.1775691088004; Wed, 08 Apr 2026
 16:31:28 -0700 (PDT)
Date: Wed, 08 Apr 2026 16:31:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69d6e54f.a00a0220.468cb.0012.GAE@google.com>
Subject: [syzbot] [mm?] INFO: rcu detected stall in kcov_ioctl (3)
From: syzbot <syzbot+8a59070fc852219166ab@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@kernel.org, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: et3h3emr13trw8zzrfq9fsf51y6zs9c7
X-Rspamd-Queue-Id: 0900940004
X-Rspam-User: 
X-HE-Tag: 1775691088-148445
X-HE-Meta: U2FsdGVkX18BHbyZLoG13S5Z/fdRF4kLysHk2M6ejjqkZfeksxpvJ5mjEyyQ6dvKpKyCpinmdnZphHVOG3VKDHJLBVTzBSnl9iO+Syx1x3WGG+iCayrKwVG2Cw4VZIX6HhlY3yK7xfRr0r3jmxMmF4eN/fm4JpnQnsqxkqw1eZ64J9j2RY1Q5KdyghpHcogtVTzVDZm+gUSHbODtBcrv7xJA0EXByJN99D8sWA03SyYpkgmUZ+on8g+9QmFJZnMYbgmE+oIZZcEmfItgXfROCywB3SYjO+tBvbF63PvfbLhkCi+s7PlcI8IFyJU/khkyPUYMs4c6TJU4KEm6tYMxMr3GP3NrIxY7B0+JrXb2sd0oggs/UBwMK0O08vkHts1YEao8e1lgozL85pXCYvm/pWx9MERSUMNIOV9bBClngogy0jdjdyiZ+BKXNGRzsrrb1z5fm0+03XUm5R7qu5gBlrKEA3vVGKMP2VK5rPismABZYDLnnzQP/PKzwVCjnAUWljRcV3+8+Xl4dRh6KkykMkTHo+Xfzu80Ol9UWsn8WXlzelDQw17CnHULHJwzThT4ORJ1dtBYeJeBf1s+/uaoFAhDUeO5aNrpRmJdwduF8wsmK9ZmyvQXasry82yuePwXjOg/ZTKAb/MfdyBjKCKILInSaFJS2ImBZ2vPNOJ0gdEPbsBwDWrtXSvkD+defVOSNUgv9nQsneZ/VIRREKgjFllTTjI7X1IvkKTmI83ivyT/z40Z0fK7RmXCfXIH9QHsZae15UwhA+SEhicy64WqkV5whwofRc+kX3yPxfwkd5yaZL5WjZ+lxoxA5aMlMctF/prRBIh0kk8RP1qjikREKVnewdxUxTyiBebL+KQAM4/0vYb8BC4A5YnHGwRQnPnL2NJ/fC0B98EQB9d536+6Ug9zrVv4SclG6un9aEjpPR2GsknXstECgpG065BKWe6yV9rM3uxtWhN4Xn/QYUI
 T6H1Vle4
 Y+KvSM301I4kim5NTcRK37Ma8h/Pb+oOk9r54lnGiWll4Ax8S1oaz0I/5jDF+s6CUlJND9gn/oQbE38pYL4zIR4KS1tTW8OUb5aDJCGR78jAOmg6ylPoFwMJT1V7348bqMHhYbiB1I3FjQqsWb9f3JkLuCWj3RQ8UWCI1CP0etZr129QzUuGqYtPfld65P7hSDClidmWCxkHO7EuuDgGzw+eTmbCZTTc8oHxWf1asWvB8jdpy+07Zta5FIO74zg8lxSFItX+aGbFkmZcdnv4a5Xwpu+oTCgVpt1smKVasj4cCEkZpUNTEsTrI7SwbSmGD+p78hGBxcPvBlpoMwF/HaFYXgOXL5E4nlVn+WA6xvA2owAE2L8nsytvTswFORPdaYKvXR+4sInx4kuU/ESI+1Z7Eetx40T2svGUTt735lhqoojNZ0OfragX2yJx5ZgV3kn/VTqE3x+i+08IOzWM0LTFEBCrlev/XJpMOgezJju2TvKp8VriF3H9S722hV6q/1cwAd7MZLHdjX+Qo94Khm007qzA+MHW/86SfnhFxCEu98U4zkc7+aaQ9US+uVPOgWO9s4e2MLaCdbGkrZ7ono6NVq9uDZ77frOPjFYOabKwjgns1egcnLOoVRyalegsHUP/1jQa+ZpZMMmOc8yx3EaSxjPmVEdGFgQjTdonGJoj669yjl0TkbwlYydG05IPD/VQqTC9RR0OU6xs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    7ca6d1cfec80 Merge tag 'powerpc-7.0-4' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=133b4dda580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=64e78d99d9bf8b4c
dashboard link: https://syzkaller.appspot.com/bug?extid=8a59070fc852219166ab
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ace9641c44ac/disk-7ca6d1cf.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6e66f8b9476e/vmlinux-7ca6d1cf.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d679c066df56/bzImage-7ca6d1cf.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8a59070fc852219166ab@syzkaller.appspotmail.com

bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P23414/1:b..l P27649/1:b..l P27664/1:b..l
rcu: 	(detected by 0, t=10502 jiffies, g=200461, q=440 ncpus=2)
task:syz-executor    state:R  running task     stack:25416 pid:27664 tgid:27664 ppid:5809   task_flags:0x400000 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5298 [inline]
 __schedule+0xfee/0x6120 kernel/sched/core.c:6911
 preempt_schedule_irq+0x50/0x90 kernel/sched/core.c:7238
 irqentry_exit+0x17b/0x670 kernel/entry/common.c:239
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:__orc_find+0x49/0xf0 arch/x86/kernel/unwind_orc.c:101
Code: 00 49 89 fe 48 89 f0 49 39 fc 72 7b 48 b9 00 00 00 00 00 fc ff df 49 89 ff 48 89 fd eb 0c 48 8d 6b 04 49 89 df 49 39 ec 72 4e <4c> 89 e2 48 29 ea 48 89 d6 48 c1 ea 3f 48 c1 fe 02 48 01 f2 48 d1
RSP: 0018:ffffc9000d12f138 EFLAGS: 00000212
RAX: ffffffff91777f46 RBX: ffffffff90f165c4 RCX: dffffc0000000000
RDX: ffffffff81aecd9f RSI: 0000000000000000 RDI: ffffffff90f165b8
RBP: ffffffff90f165b8 R08: ffffffff91777f70 R09: 0000000000000007
R10: 0000000000000200 R11: 000000000000aecd R12: ffffffff90f165c0
R13: ffffffff81aecd22 R14: ffffffff90f165b8 R15: ffffffff90f165b8
 orc_find arch/x86/kernel/unwind_orc.c:238 [inline]
 unwind_next_frame+0x2ec/0x1ea0 arch/x86/kernel/unwind_orc.c:510
 __unwind_start+0x3d1/0x7f0 arch/x86/kernel/unwind_orc.c:773
 unwind_start arch/x86/include/asm/unwind.h:64 [inline]
 arch_stack_walk+0x73/0xf0 arch/x86/kernel/stacktrace.c:24
 stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
 save_stack+0x162/0x1e0 mm/page_owner.c:165
 __set_page_owner+0x8c/0x540 mm/page_owner.c:341
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x153/0x170 mm/page_alloc.c:1889
 prep_new_page mm/page_alloc.c:1897 [inline]
 get_page_from_freelist+0x111d/0x3140 mm/page_alloc.c:3962
 __alloc_frozen_pages_noprof+0x27c/0x2ba0 mm/page_alloc.c:5250
 __alloc_pages_noprof mm/page_alloc.c:5284 [inline]
 alloc_pages_bulk_noprof+0x782/0x1490 mm/page_alloc.c:5204
 ___alloc_pages_bulk mm/kasan/shadow.c:345 [inline]
 __kasan_populate_vmalloc_do mm/kasan/shadow.c:370 [inline]
 __kasan_populate_vmalloc+0xf0/0x210 mm/kasan/shadow.c:424
 kasan_populate_vmalloc include/linux/kasan.h:580 [inline]
 alloc_vmap_area+0x95d/0x2bd0 mm/vmalloc.c:2129
 __get_vm_area_node+0x1ca/0x330 mm/vmalloc.c:3232
 __vmalloc_node_range_noprof+0x213/0x1530 mm/vmalloc.c:4024
 vmalloc_user_noprof+0x9e/0xe0 mm/vmalloc.c:4218
 kcov_ioctl+0x4c/0x720 kernel/kcov.c:726
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb4e519c4ab
RSP: 002b:00007fff4cf1e620 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000100000 RCX: 00007fb4e519c4ab
RDX: 0000000000100000 RSI: ffffffff80086301 RDI: 00000000000000d7
RBP: 00007fb4e5415f40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000003 R14: 00007fff4cf1e8d8 R15: 0000000000000000
 </TASK>
task:syz.0.5971      state:R  running task     stack:26536 pid:27649 tgid:27649 ppid:23762  task_flags:0x40044c flags:0x00080003
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5298 [inline]
 __schedule+0xfee/0x6120 kernel/sched/core.c:6911
 preempt_schedule_irq+0x50/0x90 kernel/sched/core.c:7238
 irqentry_exit+0x17b/0x670 kernel/entry/common.c:239
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:lock_acquire+0x5e/0x380 kernel/locking/lockdep.c:5872
Code: 05 3b 8d 29 12 83 f8 07 0f 87 f0 00 00 00 48 0f a3 05 06 89 f5 0e 0f 82 c2 02 00 00 8b 35 ce bc f5 0e 85 f6 0f 85 dd 00 00 00 <48> 8b 44 24 30 65 48 2b 05 dd 8c 29 12 0f 85 02 03 00 00 48 83 c4
RSP: 0018:ffffc900040d70d8 EFLAGS: 00000206
RAX: 0000000000000046 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8de5cea9 RDI: ffffffff8c1b1da0
RBP: ffffffff8e7e7760 R08: 0000000086db7919 R09: 0000000000000007
R10: 0000000000000200 R11: 0000000000000000 R12: 0000000000000002
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 rcu_read_lock include/linux/rcupdate.h:850 [inline]
 __update_page_owner_free_handle.isra.0+0x4d/0x4d0 mm/page_owner.c:283
 __reset_page_owner+0x93/0x190 mm/page_owner.c:321
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1433 [inline]
 free_unref_folios+0xaea/0x1790 mm/page_alloc.c:3040
 folios_put_refs+0x53c/0x840 mm/swap.c:1002
 folio_batch_release include/linux/pagevec.h:101 [inline]
 shmem_undo_range+0x5e5/0x1570 mm/shmem.c:1149
 shmem_truncate_range mm/shmem.c:1277 [inline]
 shmem_evict_inode+0x39e/0xbd0 mm/shmem.c:1407
 evict+0x3c2/0xad0 fs/inode.c:846
 iput_final fs/inode.c:1966 [inline]
 iput.part.0+0x605/0xf50 fs/inode.c:2015
 iput+0x35/0x40 fs/inode.c:1981
 dentry_unlink_inode+0x2a1/0x490 fs/dcache.c:467
 __dentry_kill+0x1d0/0x600 fs/dcache.c:670
 finish_dput+0x76/0x480 fs/dcache.c:879
 dput.part.0+0x456/0x570 fs/dcache.c:928
 dput+0x1f/0x30 fs/dcache.c:920
 __fput+0x519/0xb40 fs/file_table.c:477
 task_work_run+0x150/0x240 kernel/task_work.c:233
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x8b8/0x2b60 kernel/exit.c:976
 do_group_exit+0xd5/0x2a0 kernel/exit.c:1118
 get_signal+0x1ec7/0x21e0 kernel/signal.c:3034
 arch_do_signal_or_restart+0x91/0x770 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0x86/0x4a0 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
 do_syscall_64+0x668/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f405f19c819
RSP: 002b:00007ffe63f10a68 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007f405f417da0 RCX: 00007f405f19c819
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 00007f405f417da0 R08: 0000000000000006 R09: 0000000000000000
R10: 00007f405f417cb0 R11: 0000000000000246 R12: 000000000014b49e
R13: 00007f405f41609c R14: 000000000014b46c R15: 00007f405f416090
 </TASK>
task:syz-executor    state:R  running task     stack:24128 pid:23414 tgid:23414 ppid:1      task_flags:0x40054c flags:0x00080003
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5298 [inline]
 __schedule+0xfee/0x6120 kernel/sched/core.c:6911
 preempt_schedule_irq+0x50/0x90 kernel/sched/core.c:7238
 irqentry_exit+0x17b/0x670 kernel/entry/common.c:239
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:unwind_next_frame+0x17a/0x1ea0 arch/x86/kernel/unwind_orc.c:510
Code: ea 03 0f b6 04 02 4c 89 f2 83 e2 07 38 d0 7f 08 84 c0 0f 85 f7 0a 00 00 48 89 e9 41 0f b6 45 35 48 ba 00 00 00 00 00 fc ff df <48> c1 e9 03 80 3c 11 00 0f 85 8b 16 00 00 4d 8b 7d 48 3c 01 49 83
RSP: 0018:ffffc90011ee7668 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffc90011ee7720
RDX: dffffc0000000000 RSI: ffffffff8c1b1d20 RDI: ffffffff8e1318e8
RBP: ffffc90011ee7720 R08: 0000000086db7919 R09: 0000000000000007
R10: 0000000000000200 R11: 0000000000000000 R12: ffffc90011ee7728
R13: ffffc90011ee76d8 R14: ffffc90011ee770d R15: ffff8880285d1e80
 arch_stack_walk+0x94/0xf0 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
 save_stack+0x162/0x1e0 mm/page_owner.c:165
 __reset_page_owner+0x84/0x190 mm/page_owner.c:320
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0x7e1/0x10d0 mm/page_alloc.c:2978
 vfree.part.0+0x12b/0x9d0 mm/vmalloc.c:3479
 vfree+0x55/0x80 mm/vmalloc.c:3456
 kcov_put kernel/kcov.c:442 [inline]
 kcov_put kernel/kcov.c:438 [inline]
 kcov_close+0x34/0x60 kernel/kcov.c:543
 __fput+0x3ff/0xb40 fs/file_table.c:469
 task_work_run+0x150/0x240 kernel/task_work.c:233
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x8b8/0x2b60 kernel/exit.c:976
 do_group_exit+0xd5/0x2a0 kernel/exit.c:1118
 get_signal+0x1ec7/0x21e0 kernel/signal.c:3034
 arch_do_signal_or_restart+0x91/0x770 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0x86/0x4a0 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
 do_syscall_64+0x668/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f181535d04e
RSP: 002b:00007ffcfcebc618 EFLAGS: 00000246 ORIG_RAX: 000000000000003d
RAX: 000000000000037a RBX: 0000555591a58500 RCX: 00007f181535d04e
RDX: 0000000040000000 RSI: 00007ffcfcebc6bc RDI: ffffffffffffffff
RBP: 00007ffcfcebc6bc R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000108
R13: 0000555591a6b9f0 R14: 000000000014b4dd R15: 00007ffcfcebc710
 </TASK>
rcu: rcu_preempt kthread starved for 6467 jiffies! g200461 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=1
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27832 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5298 [inline]
 __schedule+0xfee/0x6120 kernel/sched/core.c:6911
 __schedule_loop kernel/sched/core.c:6993 [inline]
 schedule+0xdd/0x390 kernel/sched/core.c:7008
 schedule_timeout+0x127/0x280 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x1a9/0x900 kernel/rcu/tree.c:2095
 rcu_gp_kthread+0x179/0x230 kernel/rcu/tree.c:2297
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x754/0xd80 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
RIP: 0010:__orc_find+0xab/0xf0 arch/x86/kernel/unwind_orc.c:111
Code: 75 4b 48 63 13 48 01 da 49 39 d5 73 af 4c 8d 63 fc 49 39 ec 73 b2 4d 29 f7 49 c1 ff 02 4b 8d 14 7f 48 8d 04 50 48 83 c4 08 5b <5d> 41 5c 41 5d 41 5e 41 5f e9 c7 f3 d9 09 48 83 c4 08 31 c0 5b 5d
RSP: 0018:ffffc90000a07cc8 EFLAGS: 00000296
RAX: ffffffff92173478 RBX: 0000000000000002 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff915bde84
RBP: ffffffff915bde88 R08: ffffffff9217347e R09: 0000000000000007
R10: 0000000000000200 R11: 0000000000095cb0 R12: ffffffff915bde84
R13: ffffffff8a5cb0cc R14: ffffffff915bde84 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff888124440000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f27e3852753 CR3: 000000002b72e000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 orc_find arch/x86/kernel/unwind_orc.c:238 [inline]
 unwind_next_frame+0x2ec/0x1ea0 arch/x86/kernel/unwind_orc.c:510
 arch_stack_walk+0x94/0xf0 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x89/0x90 mm/kasan/common.c:366
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4538 [inline]
 slab_alloc_node mm/slub.c:4866 [inline]
 kmem_cache_alloc_noprof+0x241/0x6e0 mm/slub.c:4873
 skb_ext_maybe_cow net/core/skbuff.c:7092 [inline]
 skb_ext_add+0xfa/0x810 net/core/skbuff.c:7167
 nf_bridge_unshare net/bridge/br_netfilter_hooks.c:169 [inline]
 br_nf_forward_ip.part.0+0x28/0x820 net/bridge/br_netfilter_hooks.c:681
 br_nf_forward_ip net/bridge/br_netfilter_hooks.c:676 [inline]
 br_nf_forward+0xfe5/0x19f0 net/bridge/br_netfilter_hooks.c:773
 nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
 nf_hook_slow+0xbf/0x220 net/netfilter/core.c:623
 nf_hook include/linux/netfilter.h:273 [inline]
 NF_HOOK include/linux/netfilter.h:316 [inline]
 __br_forward+0x2f6/0x970 net/bridge/br_forward.c:115
 deliver_clone net/bridge/br_forward.c:131 [inline]
 br_flood+0x37f/0x650 net/bridge/br_forward.c:250
 br_handle_frame_finish+0xff4/0x1f60 net/bridge/br_input.c:229
 br_nf_hook_thresh+0x30d/0x420 net/bridge/br_netfilter_hooks.c:1167
 br_nf_pre_routing_finish_ipv6+0x769/0xfb0 net/bridge/br_netfilter_ipv6.c:154
 NF_HOOK include/linux/netfilter.h:318 [inline]
 br_nf_pre_routing_ipv6+0x39c/0x8b0 net/bridge/br_netfilter_ipv6.c:184
 br_nf_pre_routing+0x90d/0x1550 net/bridge/br_netfilter_hooks.c:508
 nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
 nf_hook_bridge_pre net/bridge/br_input.c:291 [inline]
 br_handle_frame+0xcdd/0x1520 net/bridge/br_input.c:442
 __netif_receive_skb_core.constprop.0+0x6c5/0x3550 net/core/dev.c:6068
 __netif_receive_skb_one_core+0xb0/0x1e0 net/core/dev.c:6179
 __netif_receive_skb+0x1f/0x120 net/core/dev.c:6294
 process_backlog+0x37a/0x1580 net/core/dev.c:6645
 __napi_poll.constprop.0+0xaf/0x450 net/core/dev.c:7709
 napi_poll net/core/dev.c:7772 [inline]
 net_rx_action+0xa40/0xf20 net/core/dev.c:7929
 handle_softirqs+0x1eb/0x9e0 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0xef/0x150 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
 sysvec_apic_timer_interrupt+0xa3/0xc0 arch/x86/kernel/apic/apic.c:1056
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:63
Code: a8 84 02 c3 cc cc cc cc 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d 43 00 1d 00 fb f4 <e9> fc 35 03 00 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90
RSP: 0018:ffffc90000197df0 EFLAGS: 00000246
RAX: 00000000018c87c5 RBX: ffff88801e6b0000 RCX: ffffffff8b8e8c75
RDX: 0000000000000000 RSI: ffffffff8de82fd4 RDI: ffffffff8c1b1da0
RBP: 0000000000000000 R08: 0000000000000001 R09: ffffed10170a679d
R10: ffff8880b8533ceb R11: 0000000000000000 R12: 0000000000000001
R13: ffffed1003cd6000 R14: 0000000000000001 R15: ffffffff90d9fc10
 arch_safe_halt arch/x86/include/asm/paravirt.h:73 [inline]
 default_idle+0x9/0x10 arch/x86/kernel/process.c:767
 default_idle_call+0x6c/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:199 [inline]
 do_idle+0x464/0x590 kernel/sched/idle.c:352
 cpu_startup_entry+0x4f/0x60 kernel/sched/idle.c:451
 start_secondary+0x21d/0x2d0 arch/x86/kernel/smpboot.c:312
 common_startup_64+0x13e/0x148
 </TASK>
net_ratelimit: 11899 callbacks suppressed
bridge0: received packet on veth0_to_bridge with own address as source address (addr:f6:07:a3:ff:61:53, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:f3:a6:36:2e:63, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:f6:07:a3:ff:61:53, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:f3:a6:36:2e:63, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:1b, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:f6:07:a3:ff:61:53, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:1b, vlan:0)
net_ratelimit: 14052 callbacks suppressed
bridge0: received packet on veth0_to_bridge with own address as source address (addr:f6:07:a3:ff:61:53, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:f3:a6:36:2e:63, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:f6:07:a3:ff:61:53, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:f3:a6:36:2e:63, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:1b, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:f6:07:a3:ff:61:53, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:1b, vlan:0)


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

