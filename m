Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60C02CD8C85
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 19:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21A966B0088; Sat,  6 Jun 2026 15:06:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CB386B008A; Sat,  6 Jun 2026 15:06:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E0906B008C; Sat,  6 Jun 2026 15:06:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F13366B0088
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 15:06:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 962711A0531
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 19:06:34 +0000 (UTC)
X-FDA: 84850419108.17.004DECD
Received: from mail-oa1-f79.google.com (mail-oa1-f79.google.com [209.85.160.79])
	by imf06.hostedemail.com (Postfix) with ESMTP id E08E718000A
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 19:06:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of 3uG8kagkbAIEx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.79 as permitted sender) smtp.mailfrom=3uG8kagkbAIEx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780772793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=lTYxqKOuI/wxZ3TAL1ilaXJl3V+W84ek9LW4M0IzA/g=;
	b=R3V1Moc+ioCJLqYiWP0TkiKSoi8XNjjSnK8Be8vbr2tL1FE5RqmsVy032/tizBu0veiEA1
	dxYNmIaI7V7ttSPgALw5BaPvh2AZgALhtnj9S7J8VM327Ifamf6bzC35UfQrzYVX896QIS
	MUGjKYSzB+o54ag4jUyDSWhUT9y1x40=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of 3uG8kagkbAIEx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.79 as permitted sender) smtp.mailfrom=3uG8kagkbAIEx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780772793;
	b=jnLDQBe8SFisBD3vTI6MDCdWWyni/pDVUHZMIRnr8qXuMmz48IIReffVBgJyGERnrpFCLG
	h2yaN9NOgPXQnNFBD8dxvwoLtqelwpSgM/lnJJ5UM/bl1w5S6BjfZp3IwNaB+223LlSAE1
	Ei0WrVs7ODSxGJVLY7c/3O9d4GX6RBc=
Received: by mail-oa1-f79.google.com with SMTP id 586e51a60fabf-43d1fa463d0so3767271fac.0
        for <linux-mm@kvack.org>; Sat, 06 Jun 2026 12:06:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780772792; x=1781377592;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lTYxqKOuI/wxZ3TAL1ilaXJl3V+W84ek9LW4M0IzA/g=;
        b=OLuOh9eITHOmaZ98z5NIOqO0Dh3dN28Fbzi60ykgMkqc/qTWOLEZTLLlB8pnDuYBuV
         vV3rvcU9Q12ITo+gsM6+WtH3SR8rRnccOu+QEjNifg7SrX+zpM6ptMHEK+BehQICF2Z3
         8yAYws5Klj56R+yPfSqn7rUrM/vDkPuyio5gO+w3wsPMMgmVGHznyBYTDSKibkKPsYBg
         u/wJD42+kjNeCk2CfJI4pKAdOAIgFEFKTXh3osx9THFqcuAsg4/W0hTtgDJ0b1e5rhY2
         FLohzhT/jnFcY3VnY9OD+rwj+bqeP8Fu6+IK1zbipvb8FkYbjStkrajO5EGRKfLTDxHC
         JcPg==
X-Forwarded-Encrypted: i=1; AFNElJ++cvRK/lKPT9spVulT8WT0O547KHUIWORB8eI9nkJZsLdUBGLX+q05pIbBeWKHG8ZusIy/lU1i/g==@kvack.org
X-Gm-Message-State: AOJu0Yw0eMZ+V9+81MffEZJUKFiFgR78YDJpyKnxwmuq0i3XZXQcnURl
	3o5AVT8B/yz9jaqbbOYjSQfhdFc9rZo3M4g5Y5lUsJfXJwow2/YWgqNLpMPRh4D3RL0RwsLRmc9
	GiWxGQxyQ3XWgpYe+xgoKu9a0tUytEYx6c8sGX98L0yLnCiC9a6BwhnN+llE=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c90:b0:69e:855b:5e97 with SMTP id
 006d021491bc7-69e855b68eemr701739eaf.56.1780772792046; Sat, 06 Jun 2026
 12:06:32 -0700 (PDT)
Date: Sat, 06 Jun 2026 12:06:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a246fb8.c25708ab.1b19ef.0009.GAE@google.com>
Subject: [syzbot] [mm?] upstream test error: WARNING in call_timer_fn
From: syzbot <syzbot+8b331cede7bfea7c674c@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jannh@google.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E08E718000A
X-Stat-Signature: yd7n3zx17g3mbkgbszhjkyj33j389p74
X-Rspam-User: 
X-HE-Tag: 1780772792-28256
X-HE-Meta: U2FsdGVkX1+E9DeBggdPawrxvy/NzElZfydxczTSMzVHusCxbbcBfBN96Lx5PvVZGJSpQn4x8+1iy+5DwdjqGHbkKoPUkHp2ZYYXiumsXzyH+Ni1EO8cjQ7S9uuaDfqqrIjh+0eXElyZvdbPEmsqps3qVwkNRr+w5zIh1LT/FvFTkqqh+iiLD4kmz3o1Smw3PPkDdZTuy7vaEqFKYbNaQQJ+DUdGdbA3UD6WVWthstd3BsGKMV0WVg8h5A44YzaE3mshgdPwExFFdd4cmN4s402Swo58ZwOlEqFcuGO/BoPioMv52JUp1ikbZnuIyMO64uRYH2CS8+0WD9YreJJ2uvbmaSu4E6OUT/5TfWOUQLsJyw7BDOywxOSezTUp2P5c7VBK969KYbm0+reLP4k3hFJRGb1UM60raC4RP0dcAaM64Z58KOSo7U07Yxe8eYR5cCTGrczXgdwD3Bx2iIttftqh8nxnJtAwqYeMqdUhLn9M87yWbJCqCeDZ1tNMxLH3SCWm/i5BT5e6tyj6PV98GmW5362CJwgS0dbasig+Mf1cA7UN6rPp5l9hY+/tbPxx4qTAwit6MX0akx5+VsX79Kbqa0/bLFpJcGv+/+ET7o2l/f14+z9vHjPfcdQNs6x6BoJZHGz4Ligw6bcCi5Vah41Sy3vUBMJ3MLbf9QVBDdCFSgiCHn5m7XFliGYyRHLfYOXoL3TdBYT+RZjPDjK7JnGqPN7VxEjQ+uT6xhWS5V26jBiXtuJw6eJHsno6olmC0zdy0CnE421natPZBGf+JARo7umoJZQ6A7L+Wghd6IAq78Ke0wknnzu5gbV/+9eH+1urMww65UhMLD2awm3BrdYOVT2kM/+fHxbcASe7Syqx+8jObFmy4mjFFAxkzAwP/K3V+HkX8YoknxdSc9JrDduaJdBkg2Kq1X617ndzYAVcpjjNoH3d4o8bM+oIllk8GJYVczCUhl68csmcW+G
 p+I2vO14
 cAfB/6XNea+i+4Ojx+pZPuUtOxGA2Ad11V+SBVCaO/ARAWJ+cuS0wKrd9wdExBzYjV0QktwsxJiZXgVPaS48LB16B7Kzz3hDheQkrd1Ji3f49t6wKdpKKpJlIxi+diKx9KKziRZywt5OmUgXUmTmJaOBiBugJkxyzwygXCntDI3BJOYTa9jgdi5n6KYdMscHu8d82JewHXY6IKkPpkNk4aplMa64uttTwrAd1Th+JNhwTwufBmDDZggm5mfT+2s5MAqe0MqqzYe3a9D81D/qetxPp18mUqeuTKnTASMkAzz+ZhJr/6RtnUL7GzV///TjZXkYRLAVPboMXMH3XU3Vbr+7D7tF5/FBo0l+22uMgt68g3Hf0fjVXffcyewEKWpN9VDW3AtFzHJCFM37ZR+YDAr4PwX0UvYuJ+karX+TCC1cqWyWKlTIgSVe/J+pp7fPaAk0AQt+pdkO9qcE2x6iAv9Qlrk8v1GSJEOdgg6F4qR6DEIk6vP8N0kY0ED5Vpx9l45wLD+sPXny40vX4QyoASx/6bvA5ZjOHKbfzmkpE5xpD2Z7gXrCwTotXdUfD/kn3hmDcUEgvET3rce0pesttIDj5UkCGUTeYYPhzF9KT1tqTzKBbNNdXaAhB67TmSWvIEbFI0F0Zx2lrLosjjFguN4qJovJZDPTPQJmOljz4crFVHMk5ZNkhQ2C3YRlZ9v5FIcgap/4shcqMwHWGNnMPidzMx0eYPC15cApjXrGoAvakiLCFbkZjapZIH6zXtoyaRgJZ3vmuLjHNa6Fr7IxIGktjZ4oppnQwyQ24DH57HXo64Dt2O4a1d6jndKQekF//+DSLUMQa829YC9X8vTasepCR8pBVSmMnpeHqK0Ho3+Mmupi8YHwrCjCCxz04p7BZ2PLEh8xbbhJupyx48Kld/NiAY6bZ8X1SNigbthifGrBk2ascaKbLl2CdmKaO++7wTOLqHXVp3nTzGaaoaK0G5ON3TrUX
 KHL1kGG6
 LCbX2H+G4chYoQSRTuAXrZ1pGTtmT3UcfkpNiWS7jhmvUA/VXOa1zmB/tf/nzgu9Ji1mEYdH770ksO9vHcZd23DW5/WwtLTMHcZeMgS6jot4Lapv69WE+vXfN8s5PvSZxFY1bhqLBvzr9BkDGDji626S2BnyrTt7jFu49fmDOWikc8UVeH9qtF65eIewLkPe3Jxlg0eZFBksygRqZvhQuzDkKyqvA80M0EZbBElKVKZTGjenvQRK+YeIxQf0F7IHv+I810wb+q79ZGo7UuIylfzyD5FLXLH0PM4W0lUToUHNx6WsYRK+WDK/rXwK3YD9SzEqqTsA6o4h35f53/P+tvvJuUYzjVhfhAax6zVWvwTmnXTC0AOiA829lWVbr+NdKRj0P4xbUL+lIUGEL6K5Kz/UhxmU/4eYQXU0d56ltWl7uZoy8rtX0nBHHLSz20uWTv1X8S224WWUEd1nPg0KayPT/H48S/FP3pm7hYEU8eC1OrWCzAEmYv/SL7/2hG9h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    ba3e43a9e601 Merge tag 'soc-fixes-7.1-2' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12180f2e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b4166e8ea5fbf7e3
dashboard link: https://syzkaller.appspot.com/bug?extid=8b331cede7bfea7c674c
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-ba3e43a9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/721f1d5136ec/vmlinux-ba3e43a9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ff33eef1aaee/bzImage-ba3e43a9.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8b331cede7bfea7c674c@syzkaller.appspotmail.com

------------[ cut here ]------------
workqueue: cannot queue hci_cmd_timeout on wq hci0
WARNING: kernel/workqueue.c:2298 at __queue_work+0xd3f/0x1040 kernel/workqueue.c:2296, CPU#0: syz-executor/5425
Modules linked in:
CPU: 0 UID: 0 PID: 5425 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__queue_work+0xd67/0x1040 kernel/workqueue.c:2296
Code: a6 0e 49 8d 7d 18 48 89 f8 48 c1 e8 03 42 80 3c 20 00 74 05 e8 7a 7b a5 00 49 8b 75 18 49 81 c7 70 01 00 00 4c 89 f7 4c 89 fa <67> 48 0f b9 3a 4c 89 e8 48 c1 e8 03 42 80 3c 20 00 74 08 4c 89 ef
RSP: 0000:ffffc90000007bd8 EFLAGS: 00010082
RAX: 1ffff1100259b94e RBX: 0000000000000008 RCX: ffff8880336a2540
RDX: ffff888041425170 RSI: ffffffff8a9c7e10 RDI: ffffffff90334eb0
RBP: 0000000000000100 R08: ffffffff90304ff7 R09: 1ffffffff20609fe
R10: dffffc0000000000 R11: ffffffff818d37e0 R12: dffffc0000000000
R13: ffff888012cdca58 R14: ffffffff90334eb0 R15: ffff888041425170
FS:  0000000000000000(0000) GS:ffff88808c891000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2fa63fff CR3: 0000000012c0c000 CR4: 0000000000352ef0
Call Trace:
 <IRQ>
 call_timer_fn+0x192/0x5e0 kernel/time/timer.c:1748
 expire_timers kernel/time/timer.c:1794 [inline]
 __run_timers kernel/time/timer.c:2374 [inline]
 __run_timer_base+0x67e/0x8b0 kernel/time/timer.c:2386
 run_timer_base kernel/time/timer.c:2395 [inline]
 run_timer_softirq+0xb7/0x170 kernel/time/timer.c:2405
 handle_softirqs+0x22a/0x840 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0xca/0x220 kernel/softirq.c:735
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:752
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1061 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1061
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:bytes_is_nonzero mm/kasan/generic.c:97 [inline]
RIP: 0010:memory_is_nonzero mm/kasan/generic.c:115 [inline]
RIP: 0010:memory_is_poisoned_n mm/kasan/generic.c:140 [inline]
RIP: 0010:memory_is_poisoned mm/kasan/generic.c:172 [inline]
RIP: 0010:check_region_inline mm/kasan/generic.c:191 [inline]
RIP: 0010:kasan_check_range+0x90/0x2c0 mm/kasan/generic.c:200
Code: 03 48 bb 01 00 00 00 00 fc ff df 4d 8d 34 19 4d 89 f4 4d 29 dc 49 83 fc 10 7f 29 4d 85 e4 0f 84 3d 01 00 00 4c 89 cb 48 f7 d3 <4c> 01 fb 41 80 3b 00 0f 85 9e 01 00 00 49 ff c3 48 ff c3 75 ee e9
RSP: 0000:ffffc9000e2bf240 EFLAGS: 00000202
RAX: 1ffff92001c57e01 RBX: e00006dffe3a8187 RCX: ffffffff8176f0e3
RDX: 0000000000000001 RSI: 0000000000000010 RDI: ffffc9000e2bf3b8
RBP: 0000000000000000 R08: ffffc9000e2bf3c7 R09: 1ffff92001c57e78
R10: dffffc0000000000 R11: fffff52001c57e77 R12: 0000000000000002
R13: 1ffff92001c57e6f R14: fffff52001c57e79 R15: 1ffff92001c57e77
 __asan_memset+0x22/0x50 mm/kasan/shadow.c:84
 unwind_next_frame+0xf33/0x2550 arch/x86/kernel/unwind_orc.c:621
 arch_stack_walk+0x11b/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0xa9/0x100 kernel/stacktrace.c:122
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
 __call_rcu_common kernel/rcu/tree.c:3131 [inline]
 call_rcu+0xee/0x890 kernel/rcu/tree.c:3251
 slab_free_hook mm/slub.c:2653 [inline]
 slab_free mm/slub.c:6251 [inline]
 kmem_cache_free+0x462/0x650 mm/slub.c:6378
 tear_down_vmas+0x312/0x520 mm/mmap.c:1262
 exit_mmap+0x4b6/0x9e0 mm/mmap.c:1320
 __mmput+0x118/0x430 kernel/fork.c:1178
 exit_mm+0x1f6/0x2d0 kernel/exit.c:582
 do_exit+0x6a2/0x22c0 kernel/exit.c:964
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1119
 get_signal+0x1284/0x1330 kernel/signal.c:3037
 arch_do_signal_or_restart+0xbc/0x840 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0xa9/0x680 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f328ef57fd7
Code: Unable to access opcode bytes at 0x7f328ef57fad.
RSP: 002b:00007ffd7ad34110 EFLAGS: 00000202 ORIG_RAX: 000000000000003d
RAX: fffffffffffffe00 RBX: 0000555594d02500 RCX: 00007f328ef57fd7
RDX: 0000000040000000 RSI: 00007ffd7ad3416c RDI: ffffffffffffffff
RBP: 00007ffd7ad3416c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffd7ad341e8
R13: 0000000000000002 R14: 00007ffd7ad343c8 R15: 0000000000000000
 </TASK>
----------------
Code disassembly (best guess), 2 bytes skipped:
   0:	49 8d 7d 18          	lea    0x18(%r13),%rdi
   4:	48 89 f8             	mov    %rdi,%rax
   7:	48 c1 e8 03          	shr    $0x3,%rax
   b:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1)
  10:	74 05                	je     0x17
  12:	e8 7a 7b a5 00       	call   0xa57b91
  17:	49 8b 75 18          	mov    0x18(%r13),%rsi
  1b:	49 81 c7 70 01 00 00 	add    $0x170,%r15
  22:	4c 89 f7             	mov    %r14,%rdi
  25:	4c 89 fa             	mov    %r15,%rdx
* 28:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2d:	4c 89 e8             	mov    %r13,%rax
  30:	48 c1 e8 03          	shr    $0x3,%rax
  34:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1)
  39:	74 08                	je     0x43
  3b:	4c 89 ef             	mov    %r13,%rdi


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

