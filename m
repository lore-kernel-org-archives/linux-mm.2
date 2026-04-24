Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBFB1FDEE28
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 00:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFCC26B008A; Thu, 23 Apr 2026 20:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A85CA6B008C; Thu, 23 Apr 2026 20:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99B8E6B0092; Thu, 23 Apr 2026 20:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8AF646B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:23:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2DE8140AA8
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:23:34 +0000 (UTC)
X-FDA: 84691550748.28.921069A
Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4A3DE1C000B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:23:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of 3A7jqaQkbAHQkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.77 as permitted sender) smtp.mailfrom=3A7jqaQkbAHQkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776990212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=CWIVnShUDLsum8iUvvALRfGhmvCAHleL8NwdfLyFyxE=;
	b=efGPDRxdxrOLE9UVuD6r0PQaeP6S85DXmw0WRG0ZIpUamQj1dWthM3kiSMWTKXjL5Z2wfh
	X3aIRxz9+NvPdw0PmO7zKUSNJHxGig80vMw2H8l8bvnR9nI/JbUUOl/aRwgqNiZF0QhVL8
	RCVoTPsVMPl4SvHyVcDa1rEmkNeXwOw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of 3A7jqaQkbAHQkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.77 as permitted sender) smtp.mailfrom=3A7jqaQkbAHQkqrcSddWjShhaV.YggYdWmkWjUgflWfl.Uge@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776990212; a=rsa-sha256;
	cv=none;
	b=UxIQ9dku/E4X3s8TIN4vLGbJmIgfrwi5KDCU84cepFR55v1+HuC5HT9BCI0diYRAbz8RFu
	vDu+gwqtKvnuSQu3q9ibXWdqrZ0RUthlZyIsk1u6JbF8mihp0fVs7fJTLOM+mIryvf2vco
	HhHSw0oK1VPZmSGvJ5awq9CAJyQGtoM=
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-6961bdde2a1so2141818eaf.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:23:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776990211; x=1777595011;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CWIVnShUDLsum8iUvvALRfGhmvCAHleL8NwdfLyFyxE=;
        b=PzWz/FJTvheUlc6AjC4zZucLSbrBUSNYoPuhUeEHepDXgULwUV5cBTYg2kkg2dlJcr
         +fS4ZzcwbpsFOUNY9q40xxXq6iil1KV/If5o0A6wlZjQ005dWwcSihaxSAFCq+/gw6Na
         HTT2sCJOVITs0Gmn9Si+9flbrjt8M/2LupYl5bqqBniG8GsrSU9nonFkJ2qPUAr6Ty33
         iOQix6qzmkek323pmtPG/GlIv+CB2+D6/kiOOPK0JCb0MIe+oTzvVSqMtu9NXHm+BN4d
         wbF1miKcN37irpM+20EIi2UkWjYtd7LoPqvCizhShGcMlz4XUGzB3kGdIUumkc2CDyMj
         5mbQ==
X-Forwarded-Encrypted: i=1; AFNElJ9KwmDr8bB2Xe8+MydphkqsPDvsDihzV4QF7G+/o9YuIeR53aBznItOeI6LBJYv0DRak7KttrpxlA==@kvack.org
X-Gm-Message-State: AOJu0YzjfFgPk69HG4bd13MFvn3Aass20SfJ/KkCbLJK1DQ685t6ulfv
	oHjLFnW5nK/ZN0OpqN/OdEiPZtgVAIGq0hBLeVdof3LffSsLznLNx6nAetq5pIZpCbh8RVoWCsM
	t3KvI9Spt4Zb85gFiigXUU0YVZ0nsPacSw92m4M3CRvOhMNVFmhdgVtp3Wsc=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:5104:b0:686:48b7:d81d with SMTP id
 006d021491bc7-69462e39623mr11432744eaf.15.1776990211364; Thu, 23 Apr 2026
 17:23:31 -0700 (PDT)
Date: Thu, 23 Apr 2026 17:23:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69eab803.a00a0220.17a17.004b.GAE@google.com>
Subject: [syzbot] [mm?] BUG: sleeping function called from invalid context in shmem_undo_range
From: syzbot <syzbot+9722a25de70a85ff48a1@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, hughd@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A3DE1C000B
X-Stat-Signature: xobrhtfhag5rfyt9i4fkn7gennfjureq
X-Rspam-User: 
X-HE-Tag: 1776990212-639109
X-HE-Meta: U2FsdGVkX19ms1hwuZ0KrX2iZ98KNVDChwVV5R+2AxAEiX+1IiVNnTS25oYGgIx+w/+peLUoLs8HyBHb/gUfc3Pxm68eHJsqi0KUQvu6q0tt4sn90pht2GM9NDqYD5MEdeKj0Cxq4GLehVz8Zas25uKn8QtaMW9xJvfPVdlC5Oi3j6TFREo+GCcY+vTHz49kvChncmJt/PlqKB3Pz4qd0/06TUJjd7qtRKMcvcHGi8uKsF8GNNSjIJS/jqfPqyfiCz5ubxV3ztadnxebU/unlX4yM60wOUb3kY8FnQP23iFmU4wzZA3Y15O+xOWXe2td60tBuDlIsFcVxNktinj/5D9nPXuuo8pQFcwJfpYTc7x72YJDbSRpE5hsxmyrvaVfY+La0vQ3eTP2xrcEUqz3zXLwl6QBQujTK++yoPV7ydx9y4EXuYcKrxQ8yF7+DKVfCGvE/vGNIHPAgzvYZCXL8c2Dzw5A1IEs3TXlSI9BXXd+coHGpU2qUK04eP2Box2re7kdsdcZ3gUfFbYq6v5E8PuhuOf3pA0E43lWaY0wXb3h/Ac5ABL+LyPy2yfOzuGLb7gxjP00S1FEezmjO1ui9hV7S8K2fm3H7bKZA1QVZZxQ+9xQT1FjRRnbGnICy3rRPPZfqLjnt9q0uiqo57hEBx2hzla+VRP7wXEFx9yx1wkgsQvi7uN48+sBirh7/8ikLn8du1DMuu8v6sqjkzjQhH1tp6HzAGEX+vOOPvYgXbUXLyC1ze/hLeyDZdrfgqnzMAab8Pz44q7TL645DbB4SFZw1c2rgnrA7S824ySlqXjmpATXt/5ktO/vCKoUUB4fWzX1HDVhVM6ve0ir8FEj9h8Kmq0fgv/j8sVMhkFWEghlq7uc4GDWZYOQifclYSNHn4lZA1tLMgtZWgPSW+ahskOB2LZgP+sD0Kh/VFxBAycXnPdCTeNQL7eQFuSbaMWR8BainLolTluiy8nKfhF
 JYEPmg7Z
 oqadFzN0ZXUxYhTsTLgeHMUYj58dHxqMVrCRx+N9+LMc7zFJhARJP7ZA5l9BcjlGOJF92/cIqye33cWh+7sYVG1T721G93PvM7EzX+pUFjZmskRuQsRwcfWBS0KlfkfuSQHF0CwqYU3B+IOvycGxPhdNJLkUTa2VAx5uiaakwYYYBruLJeoaA72Gt9TqzmKWZq1zUQ+oYKp6qutusikx2pTcAEGrAvmrfPoi05Q4imAraHKXLWIasPwBHJK6GfFWEn1IAfL/I+DU8DlvY+xs0OCuZ//kf02NNW9f32bOnA3cYbLS/h4msQLFY9d6aydp8P4evqlE4H0Yq32DEL7WUAPjvnYT0ZxvOvpmSD+pkg03kUppes3gtdV/Pd8jPFTLdEZPyiCoNcj6jEOXuizzZ7PU839wIaU2Az/6cI5jOE08aiEaZznw9uCn4B8fIV58xP+OMZZLe1W9DtQREq7yQRsgNUfuThsxT1Tz4OsMQ4PsZ5A1Ojq8vb0Y9rjPKQNymv/nS5RaIVhlODZgy5U/VxDAnlGy90IBafqpukS2vZk+f+xmGHbMmWedw726S6M7tiNocwDisGRtzDm0e/0XxRz5FAOlg5PAcrtAajCYHASqWfiLCz3I3zWXE96qgzRLsaBTi0r7IvpeDlvRrNz9pu016YiPEUVzZd4gRdO/Um3RZ6GXNwd6bE7TXfVxKh8RaY4OKU1MRBgL6H/zBirMhU4KHe2x1KqrIo211qgmxcZMawMWWFRLl6Pf2dA212vMsxeu2Cplpah8HDMeWIHjfUjrUPKAeKfTNqu5sAHVjjJV4hejEbP6b2pFyQIybA77rRtV+VeKH9Ar8RUPHXp3a868JvUnCn5L3/pgppJjeqFM762d0cCW3v+VzjsvPzqT2TkMijasCi/UYw7fiTWtJt8oJ2o12Ft/tsSs55t6Gc/LJnxlIrHJpByGIBzIco1GvJrufq59h2RjSsp2wMRVHMRg2ZMZ/
 +cMK2ojz
 7ede9Wf2hDsoLZGYLeUJ6ACr51PWPRCQALB7Q93tpM4x1ujolBGWxOvy21l3bhO410FDgHmYAY05pxeC4yQH6z1uiVAQkFSc/puQe0OxHLKBnC85e+//io+3IhxJ1nDXKtRoAx2OHSGZpeukROkazQpk8RdUDzen6a7lr6uwkIa7dKGxst9oJ5/HGncnqTJOVHJyb8mbmCqJFBb6ShM3/yc008PCy7YXRC/IV5a5oRb2pvvs7xnf12gYv1h89PDCvVhYz4SG1h3qTvWvN0XtKncLRLf6YJICR4mvtGyqgpW8Gbvgk4JEYRiExrows6byGvAwSiszhQHbQAnLBHn4RYHKiFErax6wCiKhMCWpDIOaVMLj4QFUwMePGojw/XaZcP7Ia0+vYLEOENnDmG300i4IbmGZZJL/YQmCL13TQAlfdScUPAUdtIG7+EEyRt+A2Z8SzhyTA2UntLgYIIZIEBuK/umoCvZ+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    2a4c0c11c019 Merge tag 's390-7.1-1' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=109c12d2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=24c8da4692f901cb
dashboard link: https://syzkaller.appspot.com/bug?extid=9722a25de70a85ff48a1
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-2a4c0c11.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/acfb852f3eb2/vmlinux-2a4c0c11.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d8166ea5d3da/bzImage-2a4c0c11.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9722a25de70a85ff48a1@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at mm/shmem.c:1150
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5904, name: rm
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
2 locks held by rm/5904:
 #0: ffff88802b0d0410 (sb_writers#5){.+.+}-{0:0}, at: filename_unlinkat+0x1ad/0x730 fs/namei.c:5545
 #1: ffffffff8e7e5260 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire.constprop.0+0x7/0x30 include/linux/rcupdate.h:300
CPU: 1 UID: 0 PID: 5904 Comm: rm Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 __might_resched.cold+0x1ec/0x232 kernel/sched/core.c:9162
 shmem_undo_range+0x447/0x1570 mm/shmem.c:1150
 shmem_truncate_range mm/shmem.c:1277 [inline]
 shmem_evict_inode+0x3f3/0xc40 mm/shmem.c:1407
 evict+0x3c2/0xad0 fs/inode.c:841
 iput_final fs/inode.c:1960 [inline]
 iput.part.0+0x605/0xf50 fs/inode.c:2009
 iput+0x35/0x40 fs/inode.c:1975
 filename_unlinkat+0x466/0x730 fs/namei.c:5572
 __do_sys_unlink fs/namei.c:5603 [inline]
 __se_sys_unlink fs/namei.c:5600 [inline]
 __x64_sys_unlink+0x46/0x70 fs/namei.c:5600
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x10b/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7eff00dbe937
Code: 00 00 e9 a9 fd ff ff 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 5f 00 00 00 0f 05 c3 0f 1f 84 00 00 00 00 00 b8 57 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 91 b4 0d 00 f7 d8 64 89 02 b8
RSP: 002b:00007ffef2c377b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000057
RAX: ffffffffffffffda RBX: 00007ffef2c37dd7 RCX: 00007eff00dbe937
RDX: 00007ffef2c377c8 RSI: 00007ffef2c37dd7 RDI: 00007ffef2c37dd7
RBP: 0000000000000008 R08: 00007ffef2c37dc0 R09: 0000000000000000
R10: 0000000000000100 R11: 0000000000000246 R12: 0000000000000000
R13: 00007eff00f4e9cc R14: 00007eff00faa000 R15: 000055fe0234bd98
 </TASK>

================================================
WARNING: lock held when returning to user space!
syzkaller #0 Tainted: G        W          
------------------------------------------------
rm/5904 is leaving the kernel with locks still held!
1 lock held by rm/5904:
 #0: ffffffff8e7e5260 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire.constprop.0+0x7/0x30 include/linux/rcupdate.h:300
------------[ cut here ]------------
Voluntary context switch within RCU read-side critical section!
WARNING: kernel/rcu/tree_plugin.h:332 at rcu_note_context_switch+0x859/0x19c0 kernel/rcu/tree_plugin.h:332, CPU#1: rm/5904
Modules linked in:
CPU: 1 UID: 0 PID: 5904 Comm: rm Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:rcu_note_context_switch+0x859/0x19c0 kernel/rcu/tree_plugin.h:332
Code: c1 ea 03 80 3c 02 00 0f 85 9b 0b 00 00 48 8b 53 28 b9 01 00 00 00 4c 89 ef e8 a3 cf fe ff e9 1d f9 ff ff 48 8d 3d b7 5e f1 0e <67> 48 0f b9 3a e9 99 f8 ff ff 48 b8 00 00 00 00 00 fc ff df 48 8d
RSP: 0000:ffffc9000407fcf0 EFLAGS: 00010002
RAX: 0000000000000001 RBX: ffff88802b33c3c0 RCX: ffffffff81ee0fc1
RDX: 0000000000000000 RSI: ffffffff8c1c1000 RDI: ffffffff90dfe2a0
RBP: ffff8880267b2500 R08: 0000000000000000 R09: fffffbfff21b89ca
R10: ffffffff90dc4e57 R11: ffffffff94142590 R12: 0000000000000000
R13: ffff8880267b29c4 R14: ffff88802b33b380 R15: ffffffff90dc81c4
FS:  00007eff00c00c80(0000) GS:ffff8880971e2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007eff00da0850 CR3: 000000004cf7d000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __schedule+0x276/0x6820 kernel/sched/core.c:7043
 __schedule_loop kernel/sched/core.c:7267 [inline]
 schedule+0xdd/0x390 kernel/sched/core.c:7282
 __exit_to_user_mode_loop kernel/entry/common.c:54 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:98 [inline]
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 irqentry_exit_to_user_mode_prepare include/linux/irq-entry-common.h:252 [inline]
 irqentry_exit_to_user_mode include/linux/irq-entry-common.h:323 [inline]
 irqentry_exit+0x359/0x790 kernel/entry/common.c:162
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0033:0x7eff00dbe937
Code: 00 00 e9 a9 fd ff ff 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 5f 00 00 00 0f 05 c3 0f 1f 84 00 00 00 00 00 b8 57 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 91 b4 0d 00 f7 d8 64 89 02 b8
RSP: 002b:00007ffef2c377b8 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 00007ffef2c37dd7 RCX: 00007eff00dbe937
RDX: 00007ffef2c377c8 RSI: 00007ffef2c37dd7 RDI: 00007ffef2c37dd7
RBP: 0000000000000008 R08: 00007ffef2c37dc0 R09: 0000000000000000
R10: 0000000000000100 R11: 0000000000000246 R12: 0000000000000000
R13: 00007eff00f4e9cc R14: 00007eff00faa000 R15: 000055fe0234bd98
 </TASK>
----------------
Code disassembly (best guess):
   0:	c1 ea 03             	shr    $0x3,%edx
   3:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   7:	0f 85 9b 0b 00 00    	jne    0xba8
   d:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  11:	b9 01 00 00 00       	mov    $0x1,%ecx
  16:	4c 89 ef             	mov    %r13,%rdi
  19:	e8 a3 cf fe ff       	call   0xfffecfc1
  1e:	e9 1d f9 ff ff       	jmp    0xfffff940
  23:	48 8d 3d b7 5e f1 0e 	lea    0xef15eb7(%rip),%rdi        # 0xef15ee1
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	e9 99 f8 ff ff       	jmp    0xfffff8cd
  34:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  3b:	fc ff df
  3e:	48                   	rex.W
  3f:	8d                   	.byte 0x8d


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

