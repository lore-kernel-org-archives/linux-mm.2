Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E80FFF60EE
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B28416B0096; Tue, 31 Mar 2026 05:07:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B009F6B0098; Tue, 31 Mar 2026 05:07:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3D326B0099; Tue, 31 Mar 2026 05:07:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 929396B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:07:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3ED1F13C131
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:07:31 +0000 (UTC)
X-FDA: 84605779902.22.183CAD6
Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6E5E2C000A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:07:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf10.hostedemail.com: domain of 30I7LaQkbAHEhnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.80 as permitted sender) smtp.mailfrom=30I7LaQkbAHEhnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774948049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=hOwsQnVoC8n4/+8TxunSebpAnP7Vtw3sdM+Rm58tSqc=;
	b=OTLs+ale5KbbghZYVARoo8xJGwUXjDIrlI7r1C44G70V1kCHE4eqqUF6FqQ19ShoY8KDkg
	/Y2PcpaZvBL0s2CCNzYYw1KWtIRPkxZuhTCasmS7eGadxhDDF5czi7RRNqjZm33iZjYBaD
	ENUIWCCw7TMRHFQn1MfK37kHrWh2piY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774948049; a=rsa-sha256;
	cv=none;
	b=lKxjXcbcjmvd5R+VzZXNNLDd1QUUzdEKHembgIuFKPY7Z2VqIGl2b9OAq0rgMg9XS7ivNg
	gkpgu584pXefQFXxjwyvtqi08g77Kh/t6sRnEP4VOCWPxf3NCGNz2c0gZNNcNwWbQgnWoZ
	FmcoQr6J1sZ73EbOT6Yx0Mk/nIexsQY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf10.hostedemail.com: domain of 30I7LaQkbAHEhnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.80 as permitted sender) smtp.mailfrom=30I7LaQkbAHEhnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7d7e9e02363so21523320a34.2
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:07:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774948048; x=1775552848;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hOwsQnVoC8n4/+8TxunSebpAnP7Vtw3sdM+Rm58tSqc=;
        b=g6LVklr6SD7TfBVR2ofRe5VPPXk9yfl2kIid7uZXWsRh6QlrwfBtwIIHUoA9ZkoTaH
         UjOaCpXocmAcnQCoB+QnXFYpsuWevlIy0Xt226/JmTuNZfAuBmmwhjY1s+lpYLPon7pc
         d8yO2z3DXXQOl8Sc9J/XhzF5TRwYtdpKlPWcKpxbKRIT2icXO5AF60OCl3ZMJ6S9J50m
         cQQwAm7aX79nOdY21IkzETsBWBYmRxiEjgSKBLn+wrJJ7YPpybw4VpdjmxaAu+lbMtJI
         jUHNhbeVVliq/N12C0otW8Z+TG+9pgZbTMd7kB/IwAlBpy7O9Cexbfipt0rBMqqRr3BR
         f9Yw==
X-Forwarded-Encrypted: i=1; AJvYcCUiPH9J27fDyXisq1wGEgomB6o7atWTfaey2EuiEG2uD1nYRs+MmuwIQBo57Qg832QpZSyzJTpdKg==@kvack.org
X-Gm-Message-State: AOJu0Yw9ZWPaNjeyw1krBzYN/0iiB8nRZvp/sKEnyqPYsFMM2rehZVFA
	ThxNdWz2mYk4gr0YZppdgiqQQkeKnzFPihbisWUGSnvnH+mIqC7O4gGxs6Ec4TfLa4ULX28aX80
	g+VeYBtEaYZVQGbZMhXIzmQYJ+HyW+kIPUshyrBfA4euCop/NowhCg7wHzv0=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4c07:b0:67e:16b4:aa06 with SMTP id
 006d021491bc7-67e1863fa15mr8448074eaf.27.1774948048505; Tue, 31 Mar 2026
 02:07:28 -0700 (PDT)
Date: Tue, 31 Mar 2026 02:07:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69cb8ed0.050a0220.183828.0027.GAE@google.com>
Subject: [syzbot] [mm?] KASAN: slab-use-after-free Read in madvise_walk_vmas
From: syzbot <syzbot+001b9efd14d3e8fac896@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	jannh@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6E5E2C000A
X-Stat-Signature: miz6jbkcya9ewaybzrbyu9gac8n7r1xb
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774948049-22640
X-HE-Meta: U2FsdGVkX19emuzDLNMW87CVSpMrYnrAVAbtqgD4RZi6lFmxrDkxpUz5d/+n/o9XIfj022zXQRU5f6FUqnekaIB4boI14JeveK1ogBUMOLEs0aDdvuOhFRoBZQGC8JwuTE6VggQ9d7VHlPW44ptWxse3NT5C0qcrndnwum0Tx0FV26c9HhpTN7Izp4QU/ddS2cIasYbNb/nr45+ywlMKO0teqWhhS81r8KmTtdTKlnWcMhl0jPVMwVQEVLEfqS00N9smUabsPQWI8MwnPx52NOze9Hf8gd2HB219et+w2a/8MsDXIXYaoo4AglYEgkk77x8JP94PJjncUeKdsplU2a8ZUpknUpqq6yCCYifzN/y+UAkhyml4KOomB3cHE0B5aOOqx0jHAavcqlJNXP4195tg9Bq+DF1IN5dnusd5d9LbL2pusTJP+SKmoSGb2sTovzGgSZfTZNPcgianV+FuNhoS/lbSizNRUwURHMxALZ6seloFSGrWOSDZA8T0tZGlaRAYMO0bthZrpGqGHN+sg2UrxFWtgvibgiLXXjcArQZUjl7yMLjnlYcP6xx6eNcL/BjerEVEm4iMXl42JHsMBYM0m/TyPCjedtqaZUGgsWbtZky4CiZ15C1BqSMxl4N1Y9TdY2nU2otQwgBd9+F9e6VbPtaNbU1z6TLDeoD3xG8DrsTrEDrNVXsq+XLTL4QbY3FP2qbP9znyTr+UotWc1PCxUYtlorfL/j26oc4B4AOQKRM9wE9EzdK+3NoF819bCSSoYh3mKixLtROr6a2CxawukPhr7tJoAhzRCNzQ3w6kiTZL3MfIdUuv7DA52vYRWclXAAEloFyGmZy9vB0pPPyM4og/iiEI9AfHz+a/0TxPVXf5uYT3GJHTo28w7KoNTA5Wm8ROhzCKM29GZSd9vFu3c5Qec7gPDkexgv4By+/yLNaM5kzuyMH0rq+0cBD27zNkSisv3Twf0vKCviC
 7ezRG/MS
 Xie/rnVQI96CzaNbxAlHbwArU99GY1rBSyiSlUmK9RYX+Clkt05jr4aUFhJn5KGKro8i7kL7rrEUQG0Ox5QrNjTF8LMimFNbQk12aGjbL41NpMtiRUgs0dnBiSiCniXpUG6y8L0oBP4wrqRlR9nUtNclltsiNvo9MUHmL8nMthD6ZkngOpjolQYv1PBAmSstI0rJmANBsVD9GsRrxqTv9JPazLl8IJ4YaHUgVumxs5ufRQfi5RJNp2xKLToF9xgbCgMN1oq8rQIuG2EPONbJ35frvypdmKBmiUkscuRURDtDNT0xsID9/hTYmnaxiaMXVgsEF6cr34vhnCqK6dKBTA9IGRZxE4cCc8uDOTflzrvaqbXrAFJtvmMJ15iy+AkkGVo03674EhMgfz0GV6sElZKpq3eQHCRQHuQIv+5Cm3+0S7VoHDmNjl0kDcgqZyoiewXCnrNGHAonbLra6BVlYQzKVHjT/dtjvw7zDbMDL04irPbonJxZeQ4/mZZ657jRFK0QZI7Q2AdVF9pSlQqYkvSEMwZfv45rXqKR/H41eIzfEJOs2k1Pwf548jdSs92JoKdK3XuSl1UqgaD5EoG1T3LhTgZ5i52WmOCJ4c1SjvHcr+9lonhgOtxyFaoHfJnwbUPfm74Qx+eHhJ+PEYY4B6RT/y26W0N6VYLaLxq8dXgJF6dLNJUI3oLIp/x4L12vDvmB9ShM09sdMOpl7hrfAxwbbsOqrADDheEWnt2u5eoJd87cb7Fn123vplfE0zc+jC+1v8MiDWwXg/UoWV+PIBGDjHOB6i56bewRarQSxEuPEGTmh7YUvSLOKJKPEiBD/OockXa13+whNsJen+xxtYHKazkcK2V+BiL5YEZXDCmwX01dw6y3ZBBBKuh7m8JKtM0JoWCvndrUO5vDjtwvh68M36xnNw+9R+Gr5VAEbE/MFFB7CxP6J0XAJoBvQG9AEWWGuxyn+U/dWP44nxJeCuEju/EjN
 ei4Fw35d
 kdjkoW5zLjDF6DrTWUkiyBAeRe1mOR/S0rTKcK1iIvqE45xLwj7KXb38MJx8AFla4xkhUl1qTyQEQ1FJU43lC2IyPRQ7j+nT1fDkJVPPUWR1mdQMpKE8rhyDn0tF5ZH9e30XMzh4oj/nBjvvHtbYAOLc19uh86EVb7I956FvLDVgscLlwGW1X8oZMz4ptiGDnHDVng8m41GurHuFzdOWIhsMDYJzD0GiFWfcd7UR5s+RZi03jgWjhIibNC/8DFB+ieN5Ke2yVCD2bqMUaAe2RqSVT2+mHlPvhk/xG2aUI1olRYzD9HhPc0tbjd7TQI9SgsaDs5mrM/psNSgZ4Fdhmu0HqG9NKzZQo6SvZFBsne1hb7MQNPe4EmW4zxOyu+CW0uP/i7KtnoKxO5vX7qG5kip4fc9N5PZPAKSZ1jq5ItLoQGYjDinhi6HRRpaW5fKHVSpeaVnTdoIhsF9bGHak3Ed4K/oGUFF+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    e77a5a5cfe43 Add linux-next specific files for 20260326
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13640f52580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=51ca7cbda5f81780
dashboard link: https://syzkaller.appspot.com/bug?extid=001b9efd14d3e8fac896
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/63883a48e879/disk-e77a5a5c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cfdff9b548ab/vmlinux-e77a5a5c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f2e4eca37d44/bzImage-e77a5a5c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+001b9efd14d3e8fac896@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in madvise_walk_vmas+0x661/0xae0 mm/madvise.c:1726
Read of size 8 at addr ffff88803322aa08 by task syz.0.3603/14995

CPU: 1 UID: 0 PID: 14995 Comm: syz.0.3603 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 madvise_walk_vmas+0x661/0xae0 mm/madvise.c:1726
 madvise_do_behavior+0x386/0x540 mm/madvise.c:1929
 do_madvise+0x1fa/0x2e0 mm/madvise.c:2022
 __do_sys_madvise mm/madvise.c:2031 [inline]
 __se_sys_madvise mm/madvise.c:2029 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2029
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6f8599c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6f8681a028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f6f85c16090 RCX: 00007f6f8599c799
RDX: 0000000000000019 RSI: 0000000008000000 RDI: 0000200000000000
RBP: 00007f6f85a32c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6f85c16128 R14: 00007f6f85c16090 R15: 00007ffd2a0e3548
 </TASK>

Allocated by task 5846:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4569 [inline]
 slab_alloc_node mm/slub.c:4898 [inline]
 kmem_cache_alloc_noprof+0x2bc/0x650 mm/slub.c:4905
 vm_area_dup+0x2b/0x680 mm/vma_init.c:123
 dup_mmap+0x8b1/0x1d90 mm/mmap.c:1786
 dup_mm kernel/fork.c:1533 [inline]
 copy_mm+0x13b/0x4a0 kernel/fork.c:1585
 copy_process+0x1efd/0x4430 kernel/fork.c:2260
 kernel_clone+0x26d/0x8e0 kernel/fork.c:2709
 __do_sys_clone kernel/fork.c:2850 [inline]
 __se_sys_clone kernel/fork.c:2834 [inline]
 __x64_sys_clone+0x1b6/0x230 kernel/fork.c:2834
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 15002:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2689 [inline]
 slab_free_after_rcu_debug+0x12a/0x220 mm/slub.c:6304
 rcu_do_batch kernel/rcu/tree.c:2617 [inline]
 rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
 handle_softirqs+0x22a/0x840 kernel/softirq.c:622
 do_softirq+0x76/0xd0 kernel/softirq.c:523
 __local_bh_enable_ip+0xf8/0x130 kernel/softirq.c:450
 lock_sock include/net/sock.h:1713 [inline]
 packet_do_bind+0x33/0xe10 net/packet/af_packet.c:3198
 __sys_bind_socket net/socket.c:1932 [inline]
 __sys_bind+0x2e3/0x410 net/socket.c:1963
 __do_sys_bind net/socket.c:1968 [inline]
 __se_sys_bind net/socket.c:1966 [inline]
 __x64_sys_bind+0x7a/0x90 net/socket.c:1966
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Last potentially related work creation:
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
 slab_free_hook mm/slub.c:2650 [inline]
 slab_free mm/slub.c:6242 [inline]
 kmem_cache_free+0x44f/0x650 mm/slub.c:6369
 remove_vma mm/vma.c:473 [inline]
 vms_complete_munmap_vmas+0x929/0xc60 mm/vma.c:1361
 do_vmi_align_munmap+0x3b7/0x4b0 mm/vma.c:1604
 do_vmi_munmap+0x252/0x2d0 mm/vma.c:1652
 do_munmap+0xf9/0x170 mm/mmap.c:1067
 mremap_to+0x353/0x880 mm/mremap.c:1448
 do_mremap mm/mremap.c:1999 [inline]
 __do_sys_mremap mm/mremap.c:2055 [inline]
 __se_sys_mremap+0xe6d/0x11d0 mm/mremap.c:2023
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88803322aa00
 which belongs to the cache vm_area_struct of size 256
The buggy address is located 8 bytes inside of
 freed 256-byte region [ffff88803322aa00, ffff88803322ab00)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88803322adc0 pfn:0x3322a
memcg:ffff88803322af01
flags: 0xfff00000000200(workingset|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000200 ffff88801c294b40 ffffea0001163f90 ffffea0001dba810
raw: ffff88803322adc0 00000008000c000b 00000000f5000000 ffff88803322af01
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 11045, tgid 11045 (syz.0.2085), ts 233915893282, free_ts 233883108694
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1850
 prep_new_page mm/page_alloc.c:1858 [inline]
 get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3938
 __alloc_frozen_pages_noprof+0x233/0x3d0 mm/page_alloc.c:5218
 alloc_slab_page mm/slub.c:3278 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3467
 new_slab mm/slub.c:3525 [inline]
 refill_objects+0x339/0x3d0 mm/slub.c:7247
 refill_sheaf mm/slub.c:2816 [inline]
 __pcs_replace_empty_main+0x321/0x720 mm/slub.c:4651
 alloc_from_pcs mm/slub.c:4749 [inline]
 slab_alloc_node mm/slub.c:4883 [inline]
 kmem_cache_alloc_noprof+0x37d/0x650 mm/slub.c:4905
 vm_area_dup+0x2b/0x680 mm/vma_init.c:123
 __split_vma+0x1dc/0xa40 mm/vma.c:516
 split_vma mm/vma.c:599 [inline]
 vma_modify+0x88a/0x1e10 mm/vma.c:1691
 vma_modify_flags+0x24b/0x330 mm/vma.c:1719
 mprotect_fixup+0x62a/0xb60 mm/mprotect.c:759
 do_mprotect_pkey+0x8d5/0xd20 mm/mprotect.c:937
 __do_sys_mprotect mm/mprotect.c:958 [inline]
 __se_sys_mprotect mm/mprotect.c:955 [inline]
 __x64_sys_mprotect+0x80/0x90 mm/mprotect.c:955
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 23 tgid 23 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1394 [inline]
 __free_frozen_pages+0xbc7/0xd30 mm/page_alloc.c:2935
 __tlb_remove_table_free mm/mmu_gather.c:228 [inline]
 tlb_remove_table_rcu+0x85/0x100 mm/mmu_gather.c:291
 rcu_do_batch kernel/rcu/tree.c:2617 [inline]
 rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
 handle_softirqs+0x22a/0x840 kernel/softirq.c:622
 run_ksoftirqd+0x36/0x60 kernel/softirq.c:1076
 smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff88803322a900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88803322a980: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
>ffff88803322aa00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff88803322aa80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88803322ab00: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00
==================================================================


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

