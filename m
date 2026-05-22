Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CA34CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 05:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43A6C6B0093; Fri, 22 May 2026 01:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EB846B0095; Fri, 22 May 2026 01:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301286B0096; Fri, 22 May 2026 01:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1F8316B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:20:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35D26A09BC
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:20:41 +0000 (UTC)
X-FDA: 84793905882.12.437AEC3
Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8CB271C0008
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:20:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 3pucPagkbAA05BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.78 as permitted sender) smtp.mailfrom=3pucPagkbAA05BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779427239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=ZEeJFwmdt7F/FZu5QPiPUGXHxEjq2G3AcpFVdYudJpI=;
	b=3skdDTJ/8kgDWlaQTgAvh9UXD09qxkqgOg4C9GYlfApxs3R1E/NPZPGcShoKlSHa02ft3d
	Eef7A/k3u/6T/OaV+j/NdsNyHqIlsnF8pv8X6n+RznO+blZtmdLPu30NN2TW+Eo9DusOVH
	o1zsMyWBVpolb7RwlmnCw6+Mgt08gvQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 3pucPagkbAA05BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.78 as permitted sender) smtp.mailfrom=3pucPagkbAA05BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779427239; a=rsa-sha256;
	cv=none;
	b=T9r1rcChj5yq6cXMU4AYJXR1JyVZDQs+t0FRSc1cpx8hn1FN33j02DnjFzyj98z6pJAqj6
	/q3rmazBYrhRqvvd6XjNaDR+ROQ3yt7USt6cWv/OcAdR806iuOZA/LvQ4o/VQQy1dVYTPX
	sukQGi8oh0RkuFWe4uzyOENOG3qjrbk=
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7e3a338673eso18072831a34.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 22:20:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779427238; x=1780032038;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZEeJFwmdt7F/FZu5QPiPUGXHxEjq2G3AcpFVdYudJpI=;
        b=W4AHYQS4XqNe+RhUVJ2DOwHXtu64UzVYPz4H5tViX8ckl80omLViIU+1jdcqfBLpCo
         sMK+OVRRVVfC3a9Hb/k7Yog3z/6kyLTFd09ixbX8PFQ2iFsGAbRMerfRvLfuo4xzjk+2
         UQvYjyb9uV5vpikmbRAnpnFV/ye2HEdZ/cGFWwgHOoy0Kfjcu+VTw4rxe4Z41YACSPIl
         XTnVL4OneDZx4JEuOiosQT+WJoApHXlFei0WyYjRu9zytj9Tu/IiR1VOueS8r3pc1Dih
         l00+f3M4gZCJWR2cfB192y0qI508HbXCRz5WHtFlPrlgHSWKkzjq0HMTT7UN3Sstu4Mb
         ibtw==
X-Forwarded-Encrypted: i=1; AFNElJ8dD54J+wpAINsH3oNLdbjUbLDYKM6I9CNKDi8qTpJ0XBBFNY+gqd6HxbwZEnRRoCPLBskA37ibaA==@kvack.org
X-Gm-Message-State: AOJu0YymbegruXRWX+V9Uuv5xkFoO/AK2kQn3aUygbLD/VLHTD0YlJvd
	tXJdp2w9O71S734Axf0Uc8pt81+5kyvZPwSEB+BB+EQCsB9G4EZoLPaRfaZ3Am1xkEmo9J9ILI7
	P9bV0Muv7+XzJTQObjn/PqZ+dA/gaf4O9MbLN8AsrrBCIg0vlKx2/y1PkoAw=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:c003:b0:696:93e7:fddb with SMTP id
 006d021491bc7-69d6e36dd06mr2012540eaf.29.1779427238532; Thu, 21 May 2026
 22:20:38 -0700 (PDT)
Date: Thu, 21 May 2026 22:20:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0fe7a6.170a0220.2e5ec6.0003.GAE@google.com>
Subject: [syzbot] [mm?] BUG: sleeping function called from invalid context in shmem_inode_acct_blocks
From: syzbot <syzbot+7978e769e19888e1171e@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, hughd@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: skkmhkzjng4bpdqeirr4dxfj45tyisbg
X-Rspamd-Queue-Id: 8CB271C0008
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779427239-970139
X-HE-Meta: U2FsdGVkX1/V4SKQ9a8Yktl6BD3KE/nKD0FMAYyy5LOOcTb1Vb2QJ7uZ6+L6F9FJYcZ3Gg1Gpo6Gwt1bkzRhTWjcXDudEkGsofsnCkXwGRgB1fwf1dubCUne/mgPjRsVRi46yjSyWVqa5qpaVSz6sFPKb/qT8kjUFpWa/rDggYcxS1LLYQVbmj9w3MBeeG7rRlmi5o8i/hlAR/Iz3NeR1Eeczqaa7qVXYdxP85mYz057ih4VOIPE9KVkif1Vj1T4S4B8B/6o4ieNJxRfDNVN6xNHJRELlm43P2EL87HG95SF7u2KVOFxzHyArL7icPujE1a31weQdRCYKsFeLig6WZPg9I6oWplB4fG5IOivmEA/n9SWxYEBvBCvpg0xD41KRKIixgoRzx2tMkmyMzIvA7avv08OKP0xDpGxzSEMavzgphQN4dvonDgEUKEWZ9ueLl3v2Bt4FusMb/QJwesK3ljo4awHzxHWBoXGFvpXD9S1WRPsrnqXJltJa0xltI1fiQuLTL06pFG8AAn4iKGTojxr/MmSFREdjnsHPfbuFuTdD/UjfQevh5CicXuxRpRpjivKqoip0y5QUkgTtg8iNTN+BSbVHooDdHGwQzdrS7l6tIt2yO46nzTK2J62hwU9r+CTWc2U7VkixHPVHWrZJI1LL0zoybKYie/AA5Nehj1a6VOauOPI16oSHjMd2VsmRg896lJBB1mUW3CpzFFXRfCTfN4SKSvuqVNJ8BCWT/7wwdviOTjqtdy8wQER57xLKoHC285BupmpsOgN1jZQQ3QtXqqeW3vYnNV0hXbGx/n5llr0/BL/z7CXdRrukMk0bUl37LBSl2a0S5tufFR5rOdybXMJJ3A4885T9u1MFYfVV9KMmUWfzueIthsQ+w4hIZ0aBPD07VpOJFLmbdAJPneb0FWDnB/zo0m+1Hb+amM84pwZcDir7zKqIwMyQb2y79ZyImK2cKFqKXNwVvM
 Ywfr/FJc
 gHpWBQkOoXdgDhyzf7X+OgYNEHIjy2QZAqJ8HM1mfwEBGM9Za+XJ9qYCgrUTnARFRweODtxXQRsWpCN5iz16xIq2rd23zfANcLjuYzFa4bq/kfKRQO//Dz+F55DpgSnAZjJYiGMK4dC7MPC0xUFKDcGxjjS3V8tlezo8z2iU2dAGpARou4DjjIFiDz444A0IOmgdE+uwLm0Lgpz4kej4BJP/3dJ7uo/VRKpL/gY7WTpjN72p+/8s59IWO/9O0cr26sMrPvsvjQ8Vw1YJ0eMWI3Blu/ewJ8ylrLNBBE4Z59v1XTRQvwllc2SiH4BDILgyNmn9Q1oj0UwwX+Pb/VIsNFH4f6CUYHcdvE2xjTu7JZpeeUCY1JaS5oxZ2YTUz6rl6aActSqBsRRzzvFR2voEK3ekOxcSedOCT+USQ7OjR+O2XxC7S3m1xToC+ex4k1irFBEleKeIaCBmzOt7wqcgFvkmhyUq1CgkNpS3BR4KwyHcQDVZzLr+i0GRfY93TapzRrL4DDDhqT2r6SrcuyJSovNRPivyjxEbhs/r0c+w6I8ZH0XhLpf1tWLl/LbkOuXS5BeYg4P1oy5Upg0LkO9lXokTB7CWYSMpiIonX4nyPYyv2XXMVmFrOy2VemgtK1+xZ+wxj/Lm+v3qRS2/rMMYdpUIEy9T8nTNyn3jfJU/+nsVEt0cZeLxZ/vymPWC93sAQXklEp6l40Y9sicYDGBOU1ZCVEr2UYYHxe77kOrYM/kP3cS82kMzeiDm3BIniM7kV/TITP+NzRk7+jDP0fIYLDyx8fceDwYldXjYRpfmUheMUFpvlKxKsFxVyRfbkV9xZyqH5nauTGWchuEhpNle9f1mXX4HdmPWZKhC78ND3rcm6DgCsrqP5sFBYlsvGEeEEdrq4KDO0bt1nF9R0RNriKILZ5ykcMgqpIzKFmSX6pJRWLAV9KI+RwpFdHDsRAZAwIbXnZhmFFU2zA15tzwgGYhl/dnMM
 8uM+yx16
 zp08qO5RqWHqNt34FQHo8Pk0lIf0b8rY39x11wokICv5W0qjimYcw8WMDdSiAQEX3vp8MEqB/sD6NMRE0+JXpg2W8r/URPycX1ZN2ZkTJcmD/mFAfLf4HBwC8tdc0jIwZ7+oL+YfFgkhpKQaRpVD+gLWEK87YdDV8oahMdVS3+Ic4JpPvWo9VJ23ee+xCUwV2EmTOI6vBnvxeUsZloDmfPbV0oXyhvQwQlB+X8o9h0sMOet6i42JEBJ0DlrexS2FWVL2fY+4WMvMcpCqSr2G56WKuVbjHbWMvAGpceQSGe9h3re/8/4tVvnh/4VOiyVK2mDe45YoLhxim0bgoXX9JY0eqlQln7SlkQSWKSwFtOUFeQc49IAm5k7pwFQPh2SpBeEqiNGW5yducoojdiTbHjALjE2dadd7S4EQKgdkcSU9ZTgh0fkdOa6ibMyt3GPkI1P0lPODtC6WjrhgzeCCh+MdLny0dKqEbCSlePF4vQqmro5vQWxWZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    f2abc305aa93 riscv: Define __riscv_copy_{,vec_}{words,byte..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git for-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15b358c8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1cf93e35eaea44b1
dashboard link: https://syzkaller.appspot.com/bug?extid=7978e769e19888e1171e
compiler:       riscv64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: riscv64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/a741b348759c/non_bootable_disk-f2abc305.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/94904c75b810/vmlinux-f2abc305.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2195b3067ea1/Image-f2abc305.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7978e769e19888e1171e@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at mm/shmem.c:230
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 3023, name: syslogd
preempt_count: 0, expected: 0
RCU nest depth: 2, expected: 0
4 locks held by syslogd/3023:
 #0: ffffaf801c0dc410 (sb_writers#5){.+.+}-{0:0}, at: percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 #0: ffffaf801c0dc410 (sb_writers#5){.+.+}-{0:0}, at: __sb_start_write include/linux/fs/super.h:19 [inline]
 #0: ffffaf801c0dc410 (sb_writers#5){.+.+}-{0:0}, at: sb_start_write include/linux/fs/super.h:125 [inline]
 #0: ffffaf801c0dc410 (sb_writers#5){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2724 [inline]
 #0: ffffaf801c0dc410 (sb_writers#5){.+.+}-{0:0}, at: vfs_write+0x8a0/0xc78 fs/read_write.c:684
 #1: ffffaf801cacb280 (&sb->s_type->i_mutex_key#14){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1029 [inline]
 #1: ffffaf801cacb280 (&sb->s_type->i_mutex_key#14){+.+.}-{4:4}, at: shmem_file_write_iter+0x78/0x138 mm/shmem.c:3468
 #2: ffffffff887f4120 (rcu_read_lock){....}-{1:3}, at: folio_pgdat include/linux/mm.h:2495 [inline]
 #2: ffffffff887f4120 (rcu_read_lock){....}-{1:3}, at: lruvec_stat_mod_folio+0x5a/0x25c mm/memcontrol.c:971
 #3: ffffffff887f4120 (rcu_read_lock){....}-{1:3}, at: folio_pgdat include/linux/mm.h:2495 [inline]
 #3: ffffffff887f4120 (rcu_read_lock){....}-{1:3}, at: lruvec_stat_mod_folio+0x5a/0x25c mm/memcontrol.c:971
CPU: 1 UID: 0 PID: 3023 Comm: syslogd Tainted: G        W           syzkaller #0 PREEMPT 
Tainted: [W]=WARN
Hardware name: riscv-virtio,qemu (DT)
Call Trace:
[<ffffffff8007c6da>] dump_backtrace+0x2e/0x3c arch/riscv/kernel/stacktrace.c:149
[<ffffffff80003284>] show_stack+0x30/0x3c arch/riscv/kernel/stacktrace.c:155
[<ffffffff80060a24>] __dump_stack lib/dump_stack.c:94 [inline]
[<ffffffff80060a24>] dump_stack_lvl+0x114/0x1ac lib/dump_stack.c:120
[<ffffffff80060ad8>] dump_stack+0x1c/0x28 lib/dump_stack.c:129
[<ffffffff8021bac6>] __might_resched+0x556/0x5b4 kernel/sched/core.c:9162
[<ffffffff8021bba4>] __might_sleep+0x80/0xc4 kernel/sched/core.c:9091
[<ffffffff80981e9a>] shmem_inode_acct_blocks+0xaa/0x410 mm/shmem.c:230
[<ffffffff80986cf4>] shmem_alloc_and_add_folio+0x544/0x1a1c mm/shmem.c:2005
[<ffffffff8098b412>] shmem_get_folio_gfp+0x5ea/0x173c mm/shmem.c:2564
[<ffffffff8098e9d6>] shmem_get_folio mm/shmem.c:2670 [inline]
[<ffffffff8098e9d6>] shmem_write_begin+0x17e/0x360 mm/shmem.c:3303
[<ffffffff808c2c7e>] generic_perform_write+0x23e/0x944 mm/filemap.c:4325
[<ffffffff80974aa4>] shmem_file_write_iter+0x110/0x138 mm/shmem.c:3478
[<ffffffff80cbfcac>] new_sync_write fs/read_write.c:595 [inline]
[<ffffffff80cbfcac>] vfs_write+0x648/0xc78 fs/read_write.c:688
[<ffffffff80cc06ce>] ksys_write+0x126/0x238 fs/read_write.c:740
[<ffffffff80cc084e>] __do_sys_write fs/read_write.c:751 [inline]
[<ffffffff80cc084e>] __se_sys_write fs/read_write.c:748 [inline]
[<ffffffff80cc084e>] __riscv_sys_write+0x6e/0x94 fs/read_write.c:748
[<ffffffff80078f0a>] syscall_handler+0x92/0x114 arch/riscv/include/asm/syscall.h:112
[<ffffffff8648ebf0>] do_trap_ecall_u+0x3dc/0x61c arch/riscv/kernel/traps.c:342
[<ffffffff864b9f62>] handle_exception+0x15e/0x16a arch/riscv/kernel/entry.S:232

================================================
WARNING: lock held when returning to user space!
syzkaller #0 Tainted: G        W          
------------------------------------------------
syslogd/3023 is leaving the kernel with locks still held!
2 locks held by syslogd/3023:
 #0: ffffffff887f4120 (rcu_read_lock){....}-{1:3}, at: folio_pgdat include/linux/mm.h:2495 [inline]
 #0: ffffffff887f4120 (rcu_read_lock){....}-{1:3}, at: lruvec_stat_mod_folio+0x5a/0x25c mm/memcontrol.c:971
 #1: ffffffff887f4120 (rcu_read_lock){....}-{1:3}, at: folio_pgdat include/linux/mm.h:2495 [inline]
 #1: ffffffff887f4120 (rcu_read_lock){....}-{1:3}, at: lruvec_stat_mod_folio+0x5a/0x25c mm/memcontrol.c:971
------------[ cut here ]------------
Voluntary context switch within RCU read-side critical section!


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

