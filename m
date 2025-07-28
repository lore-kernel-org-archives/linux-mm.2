Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCED5C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 18:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E6AD6B008A; Mon, 28 Jul 2025 14:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BE2E6B008C; Mon, 28 Jul 2025 14:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FB6A6B0092; Mon, 28 Jul 2025 14:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E99A6B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:29:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C2A5F803B3
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 18:29:38 +0000 (UTC)
X-FDA: 83714511636.02.067D423
Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	by imf26.hostedemail.com (Postfix) with ESMTP id B9265140004
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 18:29:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of 3j8GHaAkbAHwx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.79 as permitted sender) smtp.mailfrom=3j8GHaAkbAHwx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753727376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=e6gSR+K0MANHv0vyIASIA2YCGJCrixEwa05dyDMZ7kE=;
	b=uEfhhGfg5rDU2gwxFSOrvPzoQxFjnnSUX+BC4oZfqJJoqp/4pmK+w4W94/RN5JuTiby4WC
	wLvJosHtnI9PocR1i+aFfHB9OmEh7E88MdWUeKPEJVt4siDiHy49kRmUa9WfpidoECrqeK
	fhrY2iBNzBDVx4C2Z0zTfB0e3Eu7+vc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of 3j8GHaAkbAHwx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.79 as permitted sender) smtp.mailfrom=3j8GHaAkbAHwx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753727376; a=rsa-sha256;
	cv=none;
	b=Jro8bP4VdLjK2zUNxDrCBIwnLvZ+LF86iho9ELm555pedlljnSo/gIAGDJsCldAr3dKYst
	g3LkJDGW5VQdETMBXcTsam9pw12XQ+yb01KdLUL8VaG/RxWjFgMZmVK+4GlNt+J/TuwKxZ
	tQGY9bC6ic/x612gXp9S1sre0SejB3w=
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-8760733a107so535739139f.3
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 11:29:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753727376; x=1754332176;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e6gSR+K0MANHv0vyIASIA2YCGJCrixEwa05dyDMZ7kE=;
        b=mgANFegctONgYyBxGGDVO/P84N7HMDfBkHKPyRMqzBLUvq7yaU0VZp8a1iy4PLKyYq
         Kfj7tdfczKBxD7PWjjkLDUfT7/4c2zJm39uLTFawWKJVQxEMwfCQBiVbjtmbsASXjuKq
         MMvESrD9/IBnOWWZUj1CLqu6U45WsqRR1YxXPOW1Lzk01fUjKw4sLR40NjkYSChMkMKF
         6GERTQ9Xkfm6LfE6HAHS/HEc4DXbyduhx/dHgZxPW7HXr2+tE7EQPt+ZS2/Fr/+QiB0X
         84+6A5+Nk+u/4mmuA9zNtNr9zv0HF6eXlW/itl+m9agCk8IfGL2UNirEiL4ON4b+m8b+
         uQvA==
X-Forwarded-Encrypted: i=1; AJvYcCXLum+GiKtnuZCJ1wRpNZeiu3dQYdhO9Mn1WSwY8T8jE3RTeGwJUkh5C74d0GEtP37DZOFPP72m1w==@kvack.org
X-Gm-Message-State: AOJu0YzKMlrkQk5KOdRSif+ytH64NvFf5VymSbwk0pk+vq6UTgXCLtED
	8eyGtryvriPKxFl3Dn5+fm/nZRrxUen6lLy3lRtkVzBe+IX+TcH5vIgZY8H7VFWnQOeyv3NsiE8
	Vz3/39JDh7H6rgY6zWKpm9sgXhA2h5x0b3Yd6SuKz0STdCPq6mlUvYACJiRg=
X-Google-Smtp-Source: AGHT+IFOVG1qEshG+9mVORxycfBFrFHHC7hDcvu/57rmUCwIDnuCJdbvWi9SaDDD5Lft72kbt87utLWInMH4DE2h7BHp/YQCpPkm
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:32c9:b0:3e3:d245:8a1 with SMTP id
 e9e14a558f8ab-3e3d2450a71mr169524415ab.2.1753727375680; Mon, 28 Jul 2025
 11:29:35 -0700 (PDT)
Date: Mon, 28 Jul 2025 11:29:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6887c18f.a00a0220.b12ec.00ab.GAE@google.com>
Subject: [syzbot] [mm?] WARNING: locking bug in __percpu_counter_limited_add
From: syzbot <syzbot+57a2bb6f53fad29bd29c@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, hughd@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: B9265140004
X-Rspamd-Server: rspam06
X-Stat-Signature: n3jwo7jhmgwm6xyd6ix1m3wi4jsuz4ic
X-HE-Tag: 1753727376-674735
X-HE-Meta: U2FsdGVkX1/+fnEu3yKFUll6WJp/wjB6Hvxkw3m+hswNxc22wnA7baWUATvxABAyhJw+DdAvaiRpFTDEW5dum9WiD1CTu1mxAftnThV4CJgaZIdatElxOXp5RiA1SBGsYFh0IJITpkQt0PVkRUugDBuTx6U/VE7Yfk1rV+Q1rTQWvF/h85dfjtsFzLDJqR1NWBMeBLZ3UCfXNiImKz4qNcMdSpx0Xl2xUD5a53s9C79oTRrQQbBakNHK4mf1k0PIKdDWZKl22cgdz0OpPoFxEgRmvPURFXOoPa/rJP8HZZMwQMZ+3poI+7RjZfrf8VAQeFM2PNM1MZXBvj27JCbWaSl1Mo6fDmwApRNT/p7A2v1O8QWEuCW21ZHeM9c+gPLJvg0d6LNMyyssPgIjLet6K3tJ6oB/QhGTtIUoEd1WmAHrkfodi/RSBDChBNEzTPLUoJZYoau2iycamFPK5K6Ch+rn2YA32qAXGYQciO9mZo5KP83Jm4zeLJ0EMV8x3HMxlYyT6Fyo1CLgf8vcUmcLTtGyw5FL85hR1rUOYzZoFbGIqA7OXBbA8pAGIQ2SqucvYUii5j7JDrUyFolxvRS5JtJNzHT38lGc2nF2rYkMhXU1VyaL2BwrNWTaiNEtvmkI+gVsX4Rt6TrDTxLb3oUpT/E6jiAKfZt4n2vbZ/Gi693JjT9hMIx9od5ke+EdLO+NDPeunMplzHLcBOz+6wKhfoRbKRLqtNaL/prefLMIFdQSVFmmBr+6pJqjVScDE0RSUtIUnqasO8NetPTxflTu09PHpAByb5LirOPCyjKpcl/mINlvVwAR22jNXHyjjXV1Laa70wBOugGectU1LgoS1SXP6oeVuProb7bYOScEtmI+A+liSJsfAmvSLh6wc3l9ZGDtYa2Q2uJxnBA2224UNI8YKIO3eb35UvAVUJt7RpxmkPukdv31oMqrsS05X6ZP5bmO22iCVoEt2pOWUue
 6BPwWYJF
 UH0lwLhM+CSlyWooUvUV8lR32GszTipqehZbTDq060FBcjSCpzSxGPjC08znbMI9fToyQ4XxK9BROxBRz9XlEMTFL35qhCJ8WP/79FrLO5WDOWJEb8bPHBkBgSpUf3K1up4ks/LT98jdTqBkCOs/KDizF30x1QKcHmHo3kGenRKcPoZYHsr1jmYwPggkSstq8DjO3yQVVIbQv9Gc4VPKAOEok4WCDmsl4mv1Gkt/5Dmtd0qfUBx6z71VPoE5xUB0D5fcmHZB/9RRkFjYZrNMlc0sgGSs5wuRgvx3IhD/54YJe+3WtjYfWqTN0ILfZdPNlXLtDgDEnNuC4TCuT5vGUjJEChUitlquGIT9lW7Q9ldk8zXy8FGRtj5D8d7H9OMUx0fNywMihXLA+WpwajbOk80K6lXEN2pD8EpVlI53QTcOw513F7ZgsJt688Z8f5NYMJo09j7oDsAzzmHj4+QPYQALk9ZnT4ZnAXRMoSbEF1VqjQ/FG3m+3x0LtimQAOnH6Yx7afk/00Y3AsOZnNm+fQeLP+3XVCtA3KDxvTDLWS+fzH+LUyY1oJrtIeTJzkOrVTygGzKu77+kzyffIj1srlEFpuS3XdXWVl7m+rIHZ07dMgQFtG4LCf8kwXH32LvfWBlN7FYvmMfPpfxGc6SYKzhuw2+Z+xuUBCkvJ2dA750GFVjs0M84HJbp0nQNigIdIZQYP9UTJHLGHW6GjGgYRLqPc/pyP6lm3BODs3a5GLED1zngNWH/pz131M0JZQ8ckOs7twT0vt84rccR5+LygKEa0nIEa1eZasIWGi3Gve8KhkguarPJYOOo2cJVftw8UaOzU0Q/HFwPKNLtyD3jDyE9+EPLFBN11NbbPaIOLQKGKzZAdYVNu9FpfrGW5NVmGE2RBFeQ0xCH5s/ax7PxkZ/Ha71gJK54+Cg8EN5VHLWHJLMHfsSmeubiswB6mv6TCvhRR4v04U0yG/kwgKGrJ8+da+Sas
 Ab+qQh2j
 2BTdlN/vMxqxFG7VU1XeZ0GSaMU789Kq0LJtDu2mKsZM7he74KQZpWD5lVvOUIZWhc+/tl3IzoaUNEJ0ciIFq/gCff8fi2RVagvTkKqgJgJyLJ/pKW8wbJbI+uXA98WtV/lkoDPKHl1imXeUGrsuc7YUaDDR7XdzNKBZ44d9zWC3xjP9Edj3MgLUpgzfE373RY/pyXIFu1ajOXMfwnDGT/v6ntfd4QbkxSyvlGEe2wZaW/xedbkcBLWN7IHqCwaWCFn5wHefAC/Ne8jpWrwTetJMDMergJYKi/5rLzYD3YAN9bCbzLC93NxMBSDTJ327tq4ldpbthP4k+VgWXC1jG56zGQ6oBZB6wJvFB8yQBumfA7rMw5rJ5v2Q3s9JdfAO1msiJ11dY1juNfMRnL0+XQOo18dw2zssn4zurCo4q0xoaqVJfJPLVmFDrST0ktQym5w5H531FwN7VCyjOpPxdEtGWNaAC9aCsm35McbKQnv6wKfROCno69BSaYVwViu4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    94619ea2d933 Merge tag 'ipsec-next-2025-07-23' of git://gi..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1327c0a2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ceda48240b85ec34
dashboard link: https://syzkaller.appspot.com/bug?extid=57a2bb6f53fad29bd29c
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/afd64d9816ee/disk-94619ea2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e1755ce1f83b/vmlinux-94619ea2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2061dff2fbf4/bzImage-94619ea2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+57a2bb6f53fad29bd29c@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(!test_bit(class_idx, lock_classes_in_use))
WARNING: CPU: 0 PID: 20124 at kernel/locking/lockdep.c:5210 __lock_acquire+0xc0c/0xd20 kernel/locking/lockdep.c:5210
Modules linked in:
CPU: 0 UID: 0 PID: 20124 Comm: syz.3.4335 Not tainted 6.16.0-rc6-syzkaller-01673-g94619ea2d933 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:__lock_acquire+0xc0c/0xd20 kernel/locking/lockdep.c:5210
Code: ff ff 90 e8 36 ad 1e 03 85 c0 74 22 83 3d 2f 14 04 0e 00 75 19 90 48 c7 c7 1d b7 b8 8d 48 c7 c6 ff 5b a0 8d e8 25 cb e5 ff 90 <0f> 0b 90 90 90 e9 8f 00 00 00 90 0f 0b 90 e9 8d fe ff ff 90 e8 fb
RSP: 0018:ffffc9000524f5c0 EFLAGS: 00010046
RAX: b837b7aac7381900 RBX: 0000000000000003 RCX: 0000000000080000
RDX: ffffc90011215000 RSI: 000000000000cba4 RDI: 000000000000cba5
RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1bfaa6c R12: 0000000000000004
R13: 0000000000000002 R14: ffff8880251d4768 R15: 0000000000000000
FS:  00007f1c62b736c0(0000) GS:ffff888125c15000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000003e000 CR3: 0000000075eea000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 __percpu_counter_limited_add+0x22d/0x710 lib/percpu_counter.c:351
 percpu_counter_limited_add include/linux/percpu_counter.h:77 [inline]
 shmem_inode_acct_blocks+0x187/0x470 mm/shmem.c:233
 shmem_alloc_and_add_folio+0x8bc/0xf60 mm/shmem.c:1920
 shmem_get_folio_gfp+0x59d/0x1660 mm/shmem.c:2536
 shmem_get_folio mm/shmem.c:2642 [inline]
 shmem_write_begin+0xf7/0x2b0 mm/shmem.c:3292
 generic_perform_write+0x2c7/0x910 mm/filemap.c:4112
 shmem_file_write_iter+0xf8/0x120 mm/shmem.c:3467
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x548/0xa90 fs/read_write.c:686
 ksys_write+0x145/0x250 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1c61d8e9a9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1c62b73038 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f1c61fb6160 RCX: 00007f1c61d8e9a9
RDX: 00000000ffffffc1 RSI: 0000200000000200 RDI: 000000000000000a
RBP: 00007f1c61e10d69 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f1c61fb6160 R15: 00007ffe8452d7f8
 </TASK>


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

