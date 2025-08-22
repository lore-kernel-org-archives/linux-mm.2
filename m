Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D19D9CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 04:15:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EE8828000C; Fri, 22 Aug 2025 00:15:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C4908E0056; Fri, 22 Aug 2025 00:15:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1025F28000C; Fri, 22 Aug 2025 00:15:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F1C438E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 00:15:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 92A7C83C63
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:15:39 +0000 (UTC)
X-FDA: 83803079598.19.87145F0
Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	by imf15.hostedemail.com (Postfix) with ESMTP id E794BA0006
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:15:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of 36e6naAkbALIkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.206 as permitted sender) smtp.mailfrom=36e6naAkbALIkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755836138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=Sooom7ibB6unsgJsOQuQIZ+XDG9A4vkYGL93HbGK11g=;
	b=2I5Vb38JRB/rGbLH2+TGbpFJEfF5RX9pluoCRJEWqcZjVHHtfwXlGTZL9yBOMhUdJ96CUZ
	FOPxYLqS9uA1jNrInmrKFgo7yulaB4UnYAfyN0PPBo1drZs7rxnYSzHXtbRIHmsRoWD9Iq
	YVQRtyguRjlxLS0h041VSFMupPyNFmc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755836138; a=rsa-sha256;
	cv=none;
	b=trMvpjHvJZwYPAyuIcvyqZ2TBlDbN7cdITFGT0F1WXXoW8VBW8PYa1/6WG3tWFxX56B1Ws
	I/f5VdkV8xCqC34iVI2j8EBj9rf9JDxBLT2Qh3WBkdFS1Mcn2ujZTE+Wx22KiGoHcZE/Lc
	zh7f7LjxskPQPLJvLqktJXzjqu3bhwQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of 36e6naAkbALIkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.206 as permitted sender) smtp.mailfrom=36e6naAkbALIkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3e6e61caf71so34805975ab.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:15:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755836137; x=1756440937;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Sooom7ibB6unsgJsOQuQIZ+XDG9A4vkYGL93HbGK11g=;
        b=LUPbAhNzt8n/jzNDPupvpOeRc0+J1Wn4+IKu0z5P1LdAbAQVfMM0KRT76My7GhS6ID
         laNOXT+aUzFJn/Sha9OLSxKdwywM3z7RwpvQvZWrbfbVvffhbI0/yr1vyHTYz50hUYjL
         G34xKFeQlftpCt/3E/P8aJdDB3i1kcvwAGd53Dg/VtuWZKLw/fvPAszjHQ8X7sHkYdF0
         p2a44GKrHjDaZfVpei1zzw4wAxX0pZioiZLu3lwPsMZNR1HQBu36WjRxb/NioTYbMGgh
         XMMT/GjJAwGfw+wgIKKOwtEfGRRF6ZblPy2YqOOVC+bILOQwhMoVw1pJVNRkwQnLV8B8
         WGmg==
X-Forwarded-Encrypted: i=1; AJvYcCUkRpFiPw1Ng/9MT0dGWl1EauL3rMlvaCa4pwPAwm7l3fWN6dudKY4Ve+hJr/8VeDhe9S5isdp+9g==@kvack.org
X-Gm-Message-State: AOJu0Yy5lB/H4sfv6fGGUEJ4S2yzylspsI51XS6ReRH8NC8PvYs0pDdW
	/F2sLWDckon8r/r3HHK9MaTLC8ym/fRynQSRFLgAaykK+U58sMKWE/FgLQMCuL8fDiIouM3Rdpo
	Ly6jwDPMzu8C0aymW8vXik+DdYMfiB8hyQ2EvKSuhzcx91lNKY4a951AUl5Y=
X-Google-Smtp-Source: AGHT+IFLt8oqegHL1llaZsphwgFhR/m3ZmVVOqcSlwLrRY9am2eDr3bHXwav1B9UaCHpDJqGAZ07P9ENGR7R6XP1azYIwak5JhI+
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:19c6:b0:3e5:3ef0:b0e5 with SMTP id
 e9e14a558f8ab-3e9201f3b84mr31115545ab.7.1755836137084; Thu, 21 Aug 2025
 21:15:37 -0700 (PDT)
Date: Thu, 21 Aug 2025 21:15:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a7eee9.a00a0220.33401d.0168.GAE@google.com>
Subject: [syzbot] [mm?] INFO: rcu detected stall in sys_munmap (2)
From: syzbot <syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E794BA0006
X-Stat-Signature: utnupk9ufu58umrk9eezarjodsqa7ubm
X-Rspam-User: 
X-HE-Tag: 1755836137-932888
X-HE-Meta: U2FsdGVkX1+jQZERGe8Rza2PtwonckQHDZTjbZI/ty9kzVqUY8/dOEBpTweNMNPtedaijksUl/nQAYnffNG1T8FJPjXjxMyYjPPA5XqU/1mtY7ZsPxzy45a7ubStW7jGC7jqpaw4QFFy2wS1zint21kVgLiaIavjEZq0w3///Xq7Xpj7RRN+AuETRflQmnZa0wtdg4V93U9czBpWVnnT6swliPZvkYwoaaM0FAmMPRHV/WdpxP5PKCxlzpfkaWXk2hOXbEgle4d7Hd4obvWovPwgaHmpso9F717GYBEE5HonOsDG4tv8CNbMoj8kzYP0N4Gvfn8nEwE7Hbhh8GdAs6tMI9pypwz/0Bj4CHkBcE81D+1UCvyPXsDlOAwyiFtnMgyBjOYMOlZDZN9EoIvbpywaj0TypdbQ+uVAQ/dHiW8XFU0cNIgYEpcexuu5Bw2yBXu+YFgjzJqdrur3OqtShOwJfKjh4atsY605gJ6Upzvy/h6cYHK34t1fBcarpgkFHt9EyJIUT7CNCYCborTV0TpqiBHUaaEINx7tvCITsBfKlAAoGZerHt6mhw0fvsORMcSdUKFEhExagz4Tlfm2Lg6fa+HUlnJzGGOymKtcfo5XZrw2QF6yqtQMUGh38vvZ6mJANjF6svN1k7Bt7mVo8uKLRWpdt7lo4bGe6VvKD+9TJt7zxBbYb5uHcSU/SZUkWDyMOUGbpSXwWPJuBGv42I8M65mx0BZbOVkaadD/2uzT+ZeEglvAZOJAGwK2C5iRHENl4U9w/we/lw8ucXklKxGjpU8qMMIokNDZoXcdm28pCV2copYiaIdWmXXoGZEX+Vj/MSCY/dlxNDgEnSkdUJLEEX/wsPkYFo8Pi1J6/cVWXCyk4s1fkYzOkf0AAfQbjzDYX1jTWPF1JYwDZqGz9kTvy4NUsau5ZXzdwP6KdQ4/dHPTXm6h3YPskEOj2w0nmDkDyAzqZj8J8qbnEau
 DdWViMbs
 dFlk3N2neOUde75zipg2L36wzD3O1jKBPK/cYaLVaNQCaVtXXaN0/uMOc2iPPMNt9SJxUi7gd58W1SuDBu7JtbiT0bl3P1yJqEk52Ump+XZLOxIdL5EC+HeKNNhB1+xCGeOvim3Hm0nDdHH8M0Sywbj6FNOZWQOYlO66iS0IWICu2YGvnKDPaao54F1SjQzqM235FR5xZRtjj1bbHBREO4KG8877/sr5Qb94LvxmO1OzEOTNJ7QH4h7Bb8dzdJR0PF4Cuq8x60utuS+t5CkckIrX4d+ZmxD03+vaGVju5/vqXfuFhBhQmSTZ9rWl5sm/GLQUCON5pAhzl+rpp0uS2o0iQFSJIN6G63qWPur5VbTRLCrPAl9cODzOqIooqAav+2zFvmNCFketsSNm5qPAjYpUdAnKzTineciPE5NTyA+Bj2nHqosmtDaP3rgOH+IOJUC8zRgETFqzslmgYYCSSL3IOHius2jZvnhT/kC5FbT3NPZaPSHfLpwGQEi/DQtsaNI/zqBZ8d0bYzvi93CUERpKxkl9FyFRpvYsAsRuWul33TJ0dVn5p9mqirlpbD6xCO4bEZq8x507yHe6RowqP0nRVtJ7AYEaHrDMbcToS3zqsoW2Uz6Qyv6shwK81235hBuCl16f1pUqEUdBlxvpshx6xbe7pfXgXaTUXrwXDSf/Ih5WiMzPOn78i2zGO8SOBsoPU2XK0WP0juF1+C+mfwqqv6WM53qT0EHyfumBsNIbZG2o7Mjd+pLe6mLlXEfRt/k24D3SM8Rt+GffNHp4VO2ZEwTdnrAMYy2Vtef0hPGwttJVZOfkN0R2Jqn3z5hAxH5DPf9ULMDQFtRKZ5BmDm1mCbpN4h6rrZehsk7UvQvrqSsUyRThyIxMOMSHrL7FW5oCiCUYoEzQexSlt9dv3pJSaLpQu5Acuev0hPr6EXv2wA127poVi6VLrNu8PamCL1CmoZb++YV4j+SHMf2e/Myi7NsA5
 Lx4yOb6H
 Wg/Qtyuv1W9pWn7Glsffa91cZsyfzWpAF/UsEgRTDokjdtAEqcoHDbTWNtV27zltrCpq+acyqLXPNSDZIL6QgTj5Dj4QNsvTquUHnsj/sKDJcQnBqHdarSv+qtDFByhgKcRgOZEznX/Fk48w9l/GAiDgNq5oX/nYZra9/crgDbFGHZm5EDYBOkD8k0ujzV04CuY8TVX1XHwo1TujdI6mn16NxYKkWD6xrFdS6a90S9jddcGzyrD2qUn5AakFMLO++Bc1FqxYs86NgV3FtiRt2d6PVdE8TZUnp4xSmwIoHIOCvzVRc3T8fABFNwa5gx1J7ctWfgU+67gupK1OyEw6ZQkTiVCIwyDo0b62zs/UjgqmDWqpeQQHFbBXDrzDVtQHiNFVBrfiA0UZ9+L/UpJG4vtujXPlrGl3+eRmg/YcnAg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    be48bcf004f9 Merge tag 'for-6.17-rc2-tag' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=136dfba2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=142508fb116c212f
dashboard link: https://syzkaller.appspot.com/bug?extid=8785aaf121cfb2141e0d
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=107a43bc580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/24fd400c6842/disk-be48bcf0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/59146305635d/vmlinux-be48bcf0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b3e5f65cbcc8/bzImage-be48bcf0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P6029/1:b..l P1208/1:b..l P6031/3:b..l P6030/1:b..l
rcu: 	(detected by 1, t=10502 jiffies, g=6285, q=421 ncpus=2)
task:dhcpcd          state:R  running task     stack:28896 pid:6030  tgid:6030  ppid:5513   task_flags:0x400040 flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
 preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7288
 irqentry_exit+0x36/0x90 kernel/entry/common.c:197
 asm_sysvec_reschedule_ipi+0x1a/0x20 arch/x86/include/asm/idtentry.h:707
RIP: 0010:unwind_next_frame+0xfe7/0x20a0 arch/x86/kernel/unwind_orc.c:664
Code: 85 80 0c 00 00 49 89 6d 40 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e 56 10 00 00 <41> 39 5d 00 0f 84 10 06 00 00 bd 01 00 00 00 e9 de f3 ff ff 48 b8
RSP: 0018:ffffc90003cdf6a8 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffc90003ce0000
RDX: 1ffff9200079bee3 RSI: ffffc90003cdfa70 RDI: ffffc90003cdf758
RBP: ffffc90003cdfae0 R08: 0000000000000001 R09: 0000000000000000
R10: ffffc90003cdf718 R11: 00000000000121e6 R12: ffffc90003cdf768
R13: ffffc90003cdf718 R14: ffffc90003cdfa80 R15: ffffc90003cdf74c
 arch_stack_walk+0x94/0x100 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
 kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:548
 slab_free_hook mm/slub.c:2378 [inline]
 slab_free mm/slub.c:4680 [inline]
 kmem_cache_free+0x15a/0x4d0 mm/slub.c:4782
 vms_complete_munmap_vmas+0x573/0x970 mm/vma.c:1293
 do_vmi_align_munmap+0x43b/0x7d0 mm/vma.c:1536
 do_vmi_munmap+0x204/0x3e0 mm/vma.c:1584
 __vm_munmap+0x19a/0x390 mm/vma.c:3155
 __do_sys_munmap mm/mmap.c:1080 [inline]
 __se_sys_munmap mm/mmap.c:1077 [inline]
 __x64_sys_munmap+0x59/0x80 mm/mmap.c:1077
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb13ec2f2e7
RSP: 002b:00007fffe10fae78 EFLAGS: 00000206 ORIG_RAX: 000000000000000b
RAX: ffffffffffffffda RBX: 0000562bd1443510 RCX: 00007fb13ec2f2e7
RDX: 0000000000000002 RSI: 0000000000004028 RDI: 00007fb13ea1b000
RBP: 00007fffe10faf80 R08: 0000562bd1432470 R09: 0000000000000001
R10: 00007fffe10fadb0 R11: 0000000000000206 R12: 00007fffe10faea0
R13: 00007fb13ec42000 R14: 0000562bd1443510 R15: 0000000000000000
 </TASK>
task:syz-executor    state:R  running task     stack:27632 pid:6031  tgid:6031  ppid:5870   task_flags:0x400000 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
 preempt_schedule_common+0x44/0xc0 kernel/sched/core.c:7145
 preempt_schedule_thunk+0x16/0x30 arch/x86/entry/thunk.S:12
 __raw_spin_unlock include/linux/spinlock_api_smp.h:143 [inline]
 _raw_spin_unlock+0x3e/0x50 kernel/locking/spinlock.c:186
 spin_unlock include/linux/spinlock.h:391 [inline]
 filemap_map_pages+0xe15/0x1670 mm/filemap.c:3791
 do_fault_around mm/memory.c:5531 [inline]
 do_read_fault mm/memory.c:5564 [inline]
 do_fault mm/memory.c:5707 [inline]
 do_pte_missing+0xe39/0x3ba0 mm/memory.c:4234
 handle_pte_fault mm/memory.c:6052 [inline]
 __handle_mm_fault+0x152a/0x2a50 mm/memory.c:6195
 handle_mm_fault+0x589/0xd10 mm/memory.c:6364
 do_user_addr_fault+0x60c/0x1370 arch/x86/mm/fault.c:1336
 handle_page_fault arch/x86/mm/fault.c:1476 [inline]
 exc_page_fault+0x5c/0xb0 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0033:0x7f54cd7177c7
RSP: 002b:00007fffb79a5b40 EFLAGS: 00010246
RAX: 00007f54ce525000 RBX: 0000000000000000 RCX: 0000000000000064
RDX: 00007fffb79a5de9 RSI: 0000000000000002 RDI: 00007fffb79a5dd8
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
R13: 00007fffb79a5c48 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
task:kworker/0:3     state:R  running task     stack:25368 pid:1208  tgid:1208  ppid:2      task_flags:0x4208060 flags:0x00004000
Workqueue: events_power_efficient gc_worker
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
 preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7288
 irqentry_exit+0x36/0x90 kernel/entry/common.c:197
 asm_sysvec_reschedule_ipi+0x1a/0x20 arch/x86/include/asm/idtentry.h:707
RIP: 0010:write_comp_data+0x0/0x90 kernel/kcov.c:240
Code: 48 8b 05 db b4 1a 12 48 8b 80 30 16 00 00 e9 97 05 db 09 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <49> 89 d2 49 89 f8 49 89 f1 65 48 8b 15 a7 b4 1a 12 65 8b 05 b8 b4
RSP: 0018:ffffc9000441fb50 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000040000 RCX: ffffffff89ba2a52
RDX: 0000000000040000 RSI: 0000000000000433 RDI: 0000000000000004
RBP: ffffffff9b2c41ec R08: 0000000000000004 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff9b030610 R12: ffff888031800000
R13: 0000000000000433 R14: dffffc0000000000 R15: 0000000000001770
 gc_worker+0x342/0x16e0 net/netfilter/nf_conntrack_core.c:1549
 process_one_work+0x9cc/0x1b70 kernel/workqueue.c:3236
 process_scheduled_works kernel/workqueue.c:3319 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3400
 kthread+0x3c5/0x780 kernel/kthread.c:463
 ret_from_fork+0x5d7/0x6f0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
task:dhcpcd          state:R  running task     stack:26072 pid:6029  tgid:6029  ppid:5513   task_flags:0x400040 flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
 preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7288
 irqentry_exit+0x36/0x90 kernel/entry/common.c:197
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:orc_ip arch/x86/kernel/unwind_orc.c:80 [inline]
RIP: 0010:__orc_find+0x7e/0xf0 arch/x86/kernel/unwind_orc.c:102
Code: ea 3f 48 c1 fe 02 48 01 f2 48 d1 fa 48 8d 5c 95 00 48 89 da 48 c1 ea 03 0f b6 34 0a 48 89 da 83 e2 07 83 c2 03 40 38 f2 7c 05 <40> 84 f6 75 4b 48 63 13 48 01 da 49 39 d5 73 af 4c 8d 63 fc 49 39
RSP: 0018:ffffc90003337648 EFLAGS: 00000202
RAX: ffffffff914e0dd8 RBX: ffffffff90c5215c RCX: dffffc0000000000
RDX: 0000000000000007 RSI: 0000000000000000 RDI: ffffffff90c52148
RBP: ffffffff90c52148 R08: ffffffff914e0e1a R09: 0000000000000000
R10: ffffc900033376f8 R11: 0000000000011271 R12: ffffffff90c52170
R13: ffffffff82127173 R14: ffffffff90c52148 R15: ffffffff90c52148
 orc_find arch/x86/kernel/unwind_orc.c:227 [inline]
 unwind_next_frame+0x2ec/0x20a0 arch/x86/kernel/unwind_orc.c:494
 arch_stack_walk+0x94/0x100 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
 kasan_save_track+0x14/0x30 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:405
 kmalloc_noprof include/linux/slab.h:905 [inline]
 slab_free_hook mm/slub.c:2369 [inline]
 slab_free mm/slub.c:4680 [inline]
 kmem_cache_free+0x142/0x4d0 mm/slub.c:4782
 vms_complete_munmap_vmas+0x573/0x970 mm/vma.c:1293
 do_vmi_align_munmap+0x43b/0x7d0 mm/vma.c:1536
 do_vmi_munmap+0x204/0x3e0 mm/vma.c:1584
 __vm_munmap+0x19a/0x390 mm/vma.c:3155
 __do_sys_munmap mm/mmap.c:1080 [inline]
 __se_sys_munmap mm/mmap.c:1077 [inline]
 __x64_sys_munmap+0x59/0x80 mm/mmap.c:1077
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb13ec2f2e7
RSP: 002b:00007fffe10fae78 EFLAGS: 00000202 ORIG_RAX: 000000000000000b
RAX: ffffffffffffffda RBX: 0000562bd1443f00 RCX: 00007fb13ec2f2e7
RDX: 0000000000000001 RSI: 000000000002f6d0 RDI: 00007fb13e9c1000
RBP: 00007fffe10faf80 R08: 00000000000004f0 R09: 0000000000000002
R10: 00007fffe10fadb0 R11: 0000000000000202 R12: 00007fffe10faec0
R13: 00007fb13ec42000 R14: 0000562bd1443f00 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

