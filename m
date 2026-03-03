Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B471E67A95
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 08:41:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13C16B009F; Tue,  3 Mar 2026 03:41:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABDBE6B00A0; Tue,  3 Mar 2026 03:41:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EA706B00A1; Tue,  3 Mar 2026 03:41:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 876A86B009F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:41:30 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25B99160360
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:41:30 +0000 (UTC)
X-FDA: 84504107940.29.BCB41BA
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7BC6B180008
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:41:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of 3t56maQkbAOIWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3t56maQkbAOIWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772527288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=gVi4tpV4O9olpo0RRrzD1vhvqHxvubnsRs9fNmWiDMs=;
	b=UFd39bXvkWuTO254FatHkp6DNriER1AttDb+QOj6pNu5WsVzB20upHPw9NWEywl5Kmm1Pa
	nyF6n6vnB+BJsVxqVydCRddtP1IIr3rYqPIkcUD1EM32oWNagWdNnDRFUdmM7oud3QESlj
	x4O4INBHF9P1bEK3y/qq4R+CJ1GlX1s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of 3t56maQkbAOIWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3t56maQkbAOIWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772527288; a=rsa-sha256;
	cv=none;
	b=sWm3NSuD0Z1QJajLdVBYEtkBmwZj3wp1SuQnsM/iff0uIWJnjFlSBscNf6pK1vj5Cu1bo9
	DiCjxXA+j5CU3iQiseTumZi+8SPDdKWyib8NVpfNJs1jLgzpxWM2TwQS9q2v7nHFski5TM
	NnqaUJaJGX8Antxhk/YFpaIFrDjCRc8=
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-45f0bfd68a3so27185107b6e.3
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 00:41:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772527287; x=1773132087;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gVi4tpV4O9olpo0RRrzD1vhvqHxvubnsRs9fNmWiDMs=;
        b=ne9HNmGO/KMXLkVTn+nXU50wiQo70HxOy7to2MuVqGQ/0Uzsil8PNX+pwMHjVxd+K1
         dYEL1IvUJL25kyuRwAAiM8pqxQF1FyFUwG8knqHncxEWXvBfhG+v/zpC+vhb9eY/WlP1
         5cpVt92s1mZO47uLlY4/POKGzCHLbNFZWi//6EHD+SEJm/BOVlSRVAy3IHRSDgCCkVn2
         bVgqoViTc42gcc/ad92u8v5K3uXfSACeJaO1Ek4QuvhJzMKH5La0xsEzkrxtKUrk+2wN
         35a/TpiayjgUvCs05po/mwwhJGuD0Uzbp3ImGXX8pkku5OXcc1qA/p4safxRChZ0OTx+
         2Kzg==
X-Forwarded-Encrypted: i=1; AJvYcCXvCh0z1Hj6IC97WLf/fsQ90HxqVbC0+LnikwAnfw+xdrHAk8UzZ8Rd2veVsc+/mT2S/k2GxBOaOA==@kvack.org
X-Gm-Message-State: AOJu0Yxe0pg+ymHZNPuTe6Jg/MSV0kJYwvEHGv++HgSQIc2ub4jceklW
	r9sF53jhBSqIU5+EKbtOB5Ropnzk3JkwNdT6Cnw8y3bAiKfpdRkVXPRNb1CaqyfC5vOQAFKkt+g
	jVxbocgxBtHsNJdeXuRg0OXQwHEX0dJKZfZg/tzi6Cw/G+YBOQfz4ssJ/uDM=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1794:b0:679:a650:cc0b with SMTP id
 006d021491bc7-679faf3393amr8894641eaf.51.1772527287534; Tue, 03 Mar 2026
 00:41:27 -0800 (PST)
Date: Tue, 03 Mar 2026 00:41:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a69eb7.a70a0220.135158.0008.GAE@google.com>
Subject: [syzbot] [mm?] INFO: rcu detected stall in __dentry_kill
From: syzbot <syzbot+f8ccdac0a7eede0e1ae5@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@kernel.org, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 7BC6B180008
X-Stat-Signature: u5ywdbecftiqy8hai8cobhtqitq9fqum
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772527288-220831
X-HE-Meta: U2FsdGVkX192w6MVXf1F2kGuNNxkEN6aV7og1GaUBww/M4C9VZ+j/IiH4KGqamKhUoAYJoOnGwJbP60pb/vAr5jLblfqflTyewW/BvCvG9P4y3DgT4BQm+7nSmLiAYZghYmdEmaplHbRGAhkvHpWPzypDCvZ/ZrTCu+U9qVf2sEdYQIf+cwXl7YXVhwvIEuIu+W+Df2JTEkYBD8soZoOkRTqd44lfqXoDJUTsuCF2zCUBxxW1SmU6oaXD9Vk5RjM4huPRMVT7bC0VWGYmcuwmVPZMRhbGWx2iFLyiKeUVtVyY40QQjoYQqkX/p86o5vN/OCpxRu5eZSrGAhQtS4oUhVotHPpgFREuEzAg/CD9mZFpOX63MFFsmCldc2qlsSk/pBbuMqdhf1IcLO2+cypoN07IC4XG5FVNftzqYJZn5FFFjcdO9kbrtrnwbdYtBFovSd+3m7E25RyMOvfGwD6ZN0dmvOrONIjThuD4bhIhvUdnZCWbUYx3MvOSNYK5MhgHW8crc3s0CB3xZIjjdOq1uOdBZDf4lGoj9qNk1RtvxBG/G3a2WsJrrhWab7ewJRiZtg9C7sVsAeqMqE3zj3lMWMCp/st7Tbva/Rk39Pintod7i/+rP5Ef7YefhkZSATru1rJ4gPyELoF4KH4KS47AzSMI1pt1N4AY8B2M74rARWbUeHLLEWULqDrgfslXsAVJ4txTV02f5fHRmRb642JpZkjOo5qc5718uqqVFMiq6GGQJHx5REu6YhUPG+O73gB9BDFr4hAw9HlyVh13D7esjZpfOIGU3h1fjliZKwkFhigZ7XQgf6vRGfl705Z8XG3iZ0iPSLzbluJQmPF1ch0gmSlZm5KQzjfOvHlbAOyQiIM96h4aDZV2i4yStCex/1TDPlzrLjZb4ZgiJGL/CdleH+0FNOxfb0ilaJTi0ASYVrarpCws/MoDVpQAgowhOfcNuLPwzXCxOyrOxUbpYr
 lLoTRsI4
 HbiDQOiiyT0wBURxsogx7FOYQrBVxYHr21Vw3jBQDZva7UId73GkRBS7gcoEVvxxnzXh5uIwPdOmrl1iedJjtyw8XxNA95+ghkGrx3uIpcFmjEq7+rCQB1yoy59PX2ewzVgoBO/H/UrA+6r4hvcF1/Bb7NDpUis+VflbyVxfZyNJiVmD427WIg1/klRWV2ksHsr48TVJS0Gk8GBktUwz8Gu7VpbzskQoVOVh1Bdj+XthU7ZPtTLsqeFDsSUlH+fCghYPa+IERmGYgzMGnJiEP1mDMlSRm8rtMLP+N0Y2qzf3kYh+ZFfNH7Df8IacC8Vijr7W3F1lFhTvCo9b9WWmejQTbfXAQgzttk8t26W99XG6umsspzH6EBSXmHc21s0zzrwnEyOjrFgJ5EfAQHyCFFJr+S01ks9cJ4VGhQRoUERdKH4YT7dYyExAA0vZYfkRLDJJu3AbP/W8yd/5sqLJxiE+clvIJOJRPkWslc8ul9s+AKUiQQMmrTd8xAzplRwD/Dzn2OiFak+E62aA+5zntUDAoFWkb9CxlWJwfyUGQccPYCJ/9iM685+YDFDjATDE9bBfgh0w5gVVPiAgFwp5pOD/WV7xBlUzSGiN8tFE6SaAar0LtPLzpLHVr1+LEaMUCFyDNyUHkkJjFzJ0BF/VX/AjYL7xl7u9ty7u3xxev95z6Azre2UbvZ3G6T+R7fxFCZZCBAFckyzU0+Bg6hjDJ4+PiTf3ayQBcXhWskdaAiMA/M5kkkPIa/NDlbK2WQDw7BPeATBVJt9pGI9GYkhRakemiVVM7sYEBalNnWKRALCaguLZOnFigVZewZuBqGsycyxPHesNPKfF+3vf5zwJG5eLHSRPflhFK3Do5Qd+dny5afWPBAdWRHduUTM5x8hzzSWva4AAFeDXLm52byGod3XuzSZeLTDHBtK1tXzwisgW4o7UL/uIsdR8wHxwDI6Tk5lYuohg3b4oQaf13i/C3Eh7LMG9Z
 LI4hsJ7H
 dHOo0lE/ovRloLQYAPF37eGxdnUOvENtbpFZ6kxsBQ6nWQz70QdG20FawVss7k6OJPUrJBZ80YkbtgvHj4VfMn1uALRB38nSCcchfL7pLMNzcw66j0hYpKCv7Nfu3jWAC10ousjMy3WJr/TFCrVDhX0TaY0e8+U71gKl6+KGr5wwa2mZ4IUMptLQzi/ly1sI2aIBpfVsdKq5hFP23/8EWY4uarUdOfNujeI9m2lcsnFgKGX1dBzBR6HiOwXl9No/hB7wY84UbVgdTGleWtyPznuSZb6eSb64XvcRCXScIiIZKJJhN4l4iGuE6W/tDoufpHu+ob6EintG2RYTyfjwixf4BYBNsQ6GSl2oo8IgJ//IyiQhe2Z3TTjG5jx8cWg2xB32fa3gFpAr3ISScNa9Og1z5EHSCzob82sf7AbJ2lDCcOaOb3iUQyhbYG+quyWvn0aNtd53WwYAOFQGRXlzofCNoEZ8aMaL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    2f9339c052bd Merge tag 'spi-fix-v7.0-rc1' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17ee2d5a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=af6ed0125ed44356
dashboard link: https://syzkaller.appspot.com/bug?extid=f8ccdac0a7eede0e1ae5
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/80058c3aa6af/disk-2f9339c0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b80f7bb94c82/vmlinux-2f9339c0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2aca3560fd76/bzImage-2f9339c0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f8ccdac0a7eede0e1ae5@syzkaller.appspotmail.com

bridge0: received packet on veth0_to_bridge with own address as source address (addr:8a:88:71:a0:4a:94, vlan:0)
rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P10337/1:b..l P10386/1:b..l
rcu: 	(detected by 1, t=10503 jiffies, g=42749, q=1178 ncpus=2)
task:syz.1.1104      state:R  running task     stack:26792 pid:10386 tgid:10385 ppid:5832   task_flags:0x40054c flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5295 [inline]
 __schedule+0xfee/0x60e0 kernel/sched/core.c:6907
 preempt_schedule_common+0x42/0xc0 kernel/sched/core.c:7091
 preempt_schedule_thunk+0x16/0x30 arch/x86/entry/thunk.S:12
 __raw_spin_unlock include/linux/spinlock_api_smp.h:169 [inline]
 _raw_spin_unlock+0x3e/0x50 kernel/locking/spinlock.c:186
 spin_unlock include/linux/spinlock.h:389 [inline]
 zap_pte_range mm/memory.c:1959 [inline]
 zap_pmd_range mm/memory.c:2021 [inline]
 zap_pud_range mm/memory.c:2049 [inline]
 zap_p4d_range mm/memory.c:2070 [inline]
 unmap_page_range+0x152f/0x4840 mm/memory.c:2091
 unmap_single_vma+0x153/0x240 mm/memory.c:2133
 unmap_vmas+0x295/0x590 mm/memory.c:2171
 exit_mmap+0x1ef/0xa30 mm/mmap.c:1302
 __mmput+0x12a/0x410 kernel/fork.c:1174
 mmput+0x67/0x80 kernel/fork.c:1197
 exit_mm kernel/exit.c:581 [inline]
 do_exit+0x78a/0x2aa0 kernel/exit.c:959
 do_group_exit+0xd5/0x2a0 kernel/exit.c:1112
 get_signal+0x1ec7/0x21e0 kernel/signal.c:3034
 arch_do_signal_or_restart+0x91/0x770 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0x86/0x4a0 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
 do_syscall_64+0x668/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f663f59c799
RSP: 002b:00007f6640521028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: fffffffffffffffc RBX: 00007f663f815fa0 RCX: 00007f663f59c799
RDX: 0000000000000017 RSI: ffffffffffff0005 RDI: 0000000000000000
RBP: 00007f663f632bd9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f663f816038 R14: 00007f663f815fa0 R15: 00007ffe16d21cd8
 </TASK>
task:syz.3.1088      state:R  running task     stack:26216 pid:10337 tgid:10337 ppid:5827   task_flags:0x40064c flags:0x00080001
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5295 [inline]
 __schedule+0xfee/0x60e0 kernel/sched/core.c:6907
 preempt_schedule_irq+0x50/0x90 kernel/sched/core.c:7234
 irqentry_exit+0x17b/0x670 kernel/entry/common.c:239
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:__sanitizer_cov_trace_pc+0x3f/0x70 kernel/kcov.c:217
Code: 05 12 a9 00 01 ff 00 74 1b f6 c4 01 74 07 a9 00 00 ff 00 74 05 e9 d1 30 88 09 8b 82 54 16 00 00 85 c0 74 f1 8b 82 30 16 00 00 <83> f8 02 75 e6 48 8b 8a 38 16 00 00 8b 92 34 16 00 00 48 8b 01 48
RSP: 0000:ffffc90004ba7188 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffea0001354c80 RCX: ffffffff827e8e11
RDX: ffff888020f90000 RSI: ffffffff827e8b0d RDI: ffff888020f90000
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000001640274 R14: 0000000000000000 R15: 0000000002b60289
 __update_page_owner_free_handle.isra.0+0x6d/0x4d0 mm/page_owner.c:284
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
 do_exit+0x829/0x2aa0 kernel/exit.c:971
 do_group_exit+0xd5/0x2a0 kernel/exit.c:1112
 get_signal+0x1ec7/0x21e0 kernel/signal.c:3034
 arch_do_signal_or_restart+0x91/0x770 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:98 [inline]
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 irqentry_exit_to_user_mode_prepare include/linux/irq-entry-common.h:270 [inline]
 irqentry_exit_to_user_mode include/linux/irq-entry-common.h:339 [inline]
 irqentry_exit+0x1f8/0x670 kernel/entry/common.c:219
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x4021000
RSP: 002b:0000000000000009 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00007f8bdda15fa0 RCX: 00007f8bdd79c799
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: 00007f8bdd832bd9 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8bdda16038 R14: 00007f8bdda15fa0 R15: 00007ffe5ae86398
 </TASK>
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:1b, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:8a:88:71:a0:4a:94, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:1b, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:8a:88:71:a0:4a:94, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:1b, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:1b, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:8a:88:71:a0:4a:94, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:1b, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:8a:88:71:a0:4a:94, vlan:0)
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

