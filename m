Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAA92FF885E
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 08:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E35C6B0005; Sun, 26 Apr 2026 04:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794B26B008A; Sun, 26 Apr 2026 04:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AAD36B008C; Sun, 26 Apr 2026 04:17:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 589B86B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 04:17:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01B8A1B8234
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 08:17:27 +0000 (UTC)
X-FDA: 84700002576.05.6E53479
Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4E0A420005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 08:17:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of 3FcrtaQkbALYouvgWhhanWlleZ.ckkchaqoanYkjpajp.Yki@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3FcrtaQkbALYouvgWhhanWlleZ.ckkchaqoanYkjpajp.Yki@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777191446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=abpl5VjWxNF871HT77D7jiqQ5tPgHx4siodqZ1Cbc4o=;
	b=gm3Lw/rj2rl+IEQ1dyOC+QzwDk578c/an0Yx0kDCpbAF5751NAB7TrO0TlETaQF9Fy0wKp
	rrbjWM5zEYl0wNkhHjZ9u9B2AuROsWpmL6zMmyQX6Eae/PxdwAdWyxknq1ioDd0xTdXvxH
	jKpBln3ZTRxpvGC2oeXbUFXNe2Fj2ug=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of 3FcrtaQkbALYouvgWhhanWlleZ.ckkchaqoanYkjpajp.Yki@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3FcrtaQkbALYouvgWhhanWlleZ.ckkchaqoanYkjpajp.Yki@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777191446; a=rsa-sha256;
	cv=none;
	b=2RZuIq2f+jgezgbHvnV686+fm8VTZTEFsuNI9uwjB7lYMQ3g02nhyPXQ66Esh+YSt2aNGa
	N/2l6DyfnJgSUjyIdhfVKk3EY4UrC96e21MPKpQpl3JpwwRmSzZzSUf8z9xlHHsYcYSER0
	DvPPUL77hrHD3ENjH2CqaaCvmFH54So=
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-679c5ed0942so14088846eaf.1
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 01:17:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777191445; x=1777796245;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=abpl5VjWxNF871HT77D7jiqQ5tPgHx4siodqZ1Cbc4o=;
        b=MXLTo/8ZAGM3f7KAHPGJxw/tUZehhRZPGuDkZbSfOgyzoHz5VF92rOmndTfiM0iiqF
         5SqysiRGNKsJD9XHcRrPK8Cem4bQN/XWAX3sy2+miH7qQRQU2s2FSRBOIenXNX8s97mw
         Iv/a53baJDVDi+NbDHpxuy/RxlHJsg3bP6SsbP+kjjr46yXTGqOy2HuHhBobEGzXEM1p
         RIe8ySg5vrqr9u5e3SCgIa/rKRhxfB0hmpIQJEkQYaJauKwemFIMR6k8UUt46g5HjDiX
         iaQNMkLWAtAniolb+wB8XAKRzoZwdZqbjzy4SY6DrqhYOyLLxaG8LyedebAwqryrVle/
         Vu3Q==
X-Forwarded-Encrypted: i=1; AFNElJ8dosZU4QyuLNGHpboQpr/hbrSnBYpg0h6MAa2RF10ES8gyRIO2XSeOo00Hjzn8KoXh0x9aOMVxLg==@kvack.org
X-Gm-Message-State: AOJu0Yxijq5bIhKZFLbTWXQKalXlvc0vHOFyVj8/lUdXYOuZZoe3BQeo
	3nohYtfJgelUwt7Ht2ENeZhoOV7+meQEJT/rRLInx82LQ7+gWpBF719tjMUfQHsWdJqwSLmslFD
	EfhX0Usjkuwfj7ha+6FwOX8E6zQomTlcLfB4+SsWM573UOKA6+aRglxnf4ew=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b14:b0:696:25d4:1e62 with SMTP id
 006d021491bc7-69625d42208mr5229115eaf.2.1777191445302; Sun, 26 Apr 2026
 01:17:25 -0700 (PDT)
Date: Sun, 26 Apr 2026 01:17:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69edca15.170a0220.38e3f1.0000.GAE@google.com>
Subject: [syzbot] [mm?] WARNING: bad unlock balance in do_wp_page
From: syzbot <syzbot+7d60b33a8a546263da7c@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	shakeel.butt@linux.dev, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: hpywnxjrtxfkhf9s65pdpfuidij9dy4k
X-Rspamd-Queue-Id: 4E0A420005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777191446-497449
X-HE-Meta: U2FsdGVkX18RqaKNrRbHBRDcrikpakPFTt2vE7CTB0wWYHvERzz3oboUhkeQKVRxYuN6up9P/zpwSghL/85wZ6vcp+MNMQg0UZxjY/T+nY2o/gs/k7CE4ieslNNYQTV4e9powDrXPkkrc8sn0ObEedCNi8bVqoR8iyeQiu2Unk7RGVJa24Mko2aRb/V+9zYJQrzyDiBygXFTvAs7HOa6Os7DAdl4cr29IsoWSRoFs+Qo6bDAG1HSwXqCBRhQR72YRloSu7l1whhl/643q3avsnSySoEF4yNJ7fu7Z4O0uKaej8cKmR4G/8dorAPE6enVXifRi7oeRzwCRVrp7Tsl6gTfQ1QnquUJtTkEH9+CtYo/v+c6fMj51JOlFUmgVhmZ/B6dS/C1GqSa6t+0PAEbgThI4kd3+A+ddq5JBeq3q7HZ2kJiEukAJgzrCvZ4O8a8WARf4tcww0R1OVlhRm3/G4Ltp5A8vxNLnxOCW+fATf17aUegXby902WM2vS3Ba0LutwPX34MiZLjXiWHtosaRWLlgsT2JAUa/LbGLJ9NFFsVQvCK7MZNftlwIWUjdfaw380Bgr5pz60MFKqnA4lmh+uhyow4JQerJAdBZDAginrMiKY5OE4xRmLL9QWp+NMVAYtk8GOO1QcJ/gacG1Un9nMl+wNRdSg6m8sQ3T5tOvPxZlgUVBie91GCIVayBYCNzypOuiKwUVgyv1SP+NWNHIlqjRtKuL3WTMOd6gpfJieE77f2R2EL8VFlJgmGZe77/7+9nPfDEFncjKqS/cL/8uNBFhwEpihppxE+ZuN32vGfNPvuBaVbiq29Si0xdywAg8ZycLCGaZkCXkECvi2o+mFznaQiNMHm4QvlFMePru7WLqdyYOZHgMNhZBMtv6fTKjN5oM56rherV1RmyLKuz6Gmh36m+MJ6x/Yp0G8fm40kgMHmKU4ixgVizKEo2OexC9LnAganCwodlufcF9W
 B55OZ4h4
 oBozNN6Oh0zNLIz6lugr1+z+SFGqs8RepbXdi1/t6U+oVMG+8+T5V3C9qV7EC8bGQW/XD0bvOB1eW2Do4hSFSnraOfpzpGRjn1RVKgdxum3/YKYuOd1n+QdpxtM5BEtCCrijtzQsMxWBLv29YoEiZfA2n5H5cNyxrsv4Axh2Kqq6E4De2bewJsI1uIzmaz+W0EWC+q17pfoa8xM3zk7oWGDANwY8vYymCxS+v4tO3aaA1n7S9KBk/Y1k5McHC6vHULuuobwLmadG0yTGc1kNSQ6UBnFJVrPE56L58vqj8S4GqVme2u6VvfT4i4hYENQq/43Fo+0h2r1CPCPVGCntuPCiyPe1pF+2lXHyxyLjP785E7lMhvIdAUgRga+YmZFrynwAsfCxNg6wcxDsyUEzkkqmm32P3uUQPklsyrAx/ggOvtOifkM9cqVuDMgtKQd59mPDU+pJdWDnZNdJJrN9PPHpN4jNPPRq3e5xZ/17F0z1D71cMKACMQSXlmYpSI9A8/oolAh7QVf/Re188RWHhKszmkhOO+rSWCvdp+gGSbeRCRXLyqpcDtcDer5jtn7hNzLUa2MvoNPWSGaYwcOhAmumq/qYUonzFlaInDXSs6T9NSm1Cdci1l0ebnqEfEg7qVGf+h+NJTnB9x2PUQSN7zCcc3pjizf/8w6NBaSlL4jDD6V3QRepPpLY6O60VFrnG09sWlV5M6r3ANSLzciaz9mE4eTS8gV7Gd8RLA8T4FddtJ/CMnjCd5HyXlB+IjXznSr1BKVY5lvlASOlWfJlFaXymFe+fobIRElst7AOGBCbSdQQ1hROBYs4yKdDjWaF7Npa3mtYuJ+m0pTpOam6EyINSmSJK9+QobJapErf3jGAOVvQ1Yeb9oyG2ZkVfXpDCxDQ51H6WeTFF9pyohx5eWsYyEBxr5nlirT3Kgk6FNK6DAgsudUbF47CbGl57WAhYeRqH2fOjK6iE80L5xZfZYvsDs0G8
 xQbBqpR5
 nO3dnAeuC6L1JNOtUjyhuK6KYrB/f1/Ts1i28DYnZbR0VYC8dQYGu0rXzszrP00r5+LhLI6kKOCzBPcmaf52i8eOan/dOwfo2mJDcMT7AIh5F7PpFkWkjh1tjv5gBAG56GqeiWGM80/Kg9hQ76sofBWWj50rCvW3CPbekPAKDLZYAD/w8/ui3NzVGfvevMsbwuIvnkpy+6ZbAfWJEboMBoHjusKFlnXAdCIBFF7EskRtAxJPlfKkZUPPKQhB0tyJIe4AXF1rg/Hs9Q9ZryIdnecU3mPHqE8JuQdRCaOcF98fSSUCUtRLFRDu2c9n5mdc0XTZoy2d5ZCvsBeuf89IieyqWbONtmd5bMBImCtOU31ZwKjSpDVpZAw2YyAQoDGTnovU8if7wpPF3tz66GX4jCFWWPHCBAMV4hFqpstYsJJ5P2cecHiLmUQGqadrIjbQy2uaYj76+juvFRvbylsu87hIz2wijf9d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    6596a02b2078 Merge tag 'drm-next-2026-04-22' of https://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12483702580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=24c8da4692f901cb
dashboard link: https://syzkaller.appspot.com/bug?extid=7d60b33a8a546263da7c
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-6596a02b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c5a50c04af50/vmlinux-6596a02b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/70da0dbf8561/bzImage-6596a02b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7d60b33a8a546263da7c@syzkaller.appspotmail.com

=====================================
WARNING: bad unlock balance detected!
syzkaller #0 Not tainted
-------------------------------------
dhcpcd-run-hook/5941 is trying to release lock (rcu_read_lock) at:
[<ffffffff8258a32d>] rcu_read_unlock+0x2d/0xb0 include/linux/rcupdate.h:867
but there are no more locks to release!

other info that might help us debug this:
1 lock held by dhcpcd-run-hook/5941:
 #0: ffff8880440f3d48 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0x11d/0x590 mm/mmap_lock.c:310

stack backtrace:
CPU: 2 UID: 0 PID: 5941 Comm: dhcpcd-run-hook Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_unlock_imbalance_bug.part.0+0xfb/0x106 kernel/locking/lockdep.c:5298
 print_unlock_imbalance_bug kernel/locking/lockdep.c:5278 [inline]
 __lock_release kernel/locking/lockdep.c:5537 [inline]
 lock_release kernel/locking/lockdep.c:5889 [inline]
 lock_release+0x28d/0x310 kernel/locking/lockdep.c:5875
 rcu_read_unlock+0x32/0xb0 include/linux/rcupdate.h:867
 pte_unmap include/linux/pgtable.h:117 [inline]
 wp_page_copy mm/memory.c:3960 [inline]
 do_wp_page+0x13d7/0x4350 mm/memory.c:4320
 handle_pte_fault mm/memory.c:6427 [inline]
 __handle_mm_fault+0x1ab6/0x2a00 mm/memory.c:6549
 handle_mm_fault+0x36d/0xa20 mm/memory.c:6718
 do_user_addr_fault+0x5a3/0x12f0 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7f7501c33f87
Code: 5c 25 28 49 8b 57 10 48 85 db 74 27 8b 74 24 0c 23 73 08 44 39 f6 75 16 48 39 c2 75 05 e8 62 ff ff ff 48 8b 53 10 48 83 c0 08 <48> 89 50 f8 48 8b 1b eb d0 49 83 c4 08 49 81 fc 38 01 00 00 75 be
RSP: 002b:00007ffd29921270 EFLAGS: 00010212
RAX: 00005645dcc81140 RBX: 00005645dcc716d0 RCX: 0000000000000002
RDX: 00007ffd29925f83 RSI: 0000000000000001 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000008
R13: 00005645dcc70e60 R14: 0000000000000001 R15: 00005645dcc70c30
 </TASK>
------------[ cut here ]------------
rrln < 0 || rrln > RCU_NEST_PMAX
WARNING: kernel/rcu/tree_plugin.h:443 at __rcu_read_unlock kernel/rcu/tree_plugin.h:443 [inline], CPU#3: dhcpcd-run-hook/5941
WARNING: kernel/rcu/tree_plugin.h:443 at __rcu_read_unlock+0x235/0x5e0 kernel/rcu/tree_plugin.h:430, CPU#3: dhcpcd-run-hook/5941
Modules linked in:
CPU: 3 UID: 0 PID: 5941 Comm: dhcpcd-run-hook Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__rcu_read_unlock kernel/rcu/tree_plugin.h:443 [inline]
RIP: 0010:__rcu_read_unlock+0x235/0x5e0 kernel/rcu/tree_plugin.h:430
Code: 74 11 c7 45 58 01 00 00 00 bf 09 00 00 00 e8 12 a5 da ff e8 9d e2 22 00 9c 58 f6 c4 02 0f 85 dd 02 00 00 fb e9 57 fe ff ff 90 <0f> 0b 90 5b 5d 41 5c 41 5d 41 5e 41 5f e9 d9 14 ad 09 e8 44 64 87
RSP: 0000:ffffc900049c7af0 EFLAGS: 00010286
RAX: 00000000ffffffff RBX: ffff888029ec4a00 RCX: ffffffff81e80bfe
RDX: 0000000000000000 RSI: ffffffff8df2fec2 RDI: ffff888029ec4ec4
RBP: 0000000000000001 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000012 R12: ffff88802ad93408
R13: ffffea0000ad7800 R14: 0000000000000000 R15: ffffea0000ad7800
FS:  00007f7501945c80(0000) GS:ffff8880973e2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005645dcc70950 CR3: 00000000297d6000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 pte_unmap include/linux/pgtable.h:117 [inline]
 wp_page_copy mm/memory.c:3960 [inline]
 do_wp_page+0x13d7/0x4350 mm/memory.c:4320
 handle_pte_fault mm/memory.c:6427 [inline]
 __handle_mm_fault+0x1ab6/0x2a00 mm/memory.c:6549
 handle_mm_fault+0x36d/0xa20 mm/memory.c:6718
 do_user_addr_fault+0x5a3/0x12f0 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7f7501c33f87
Code: 5c 25 28 49 8b 57 10 48 85 db 74 27 8b 74 24 0c 23 73 08 44 39 f6 75 16 48 39 c2 75 05 e8 62 ff ff ff 48 8b 53 10 48 83 c0 08 <48> 89 50 f8 48 8b 1b eb d0 49 83 c4 08 49 81 fc 38 01 00 00 75 be
RSP: 002b:00007ffd29921270 EFLAGS: 00010212
RAX: 00005645dcc81140 RBX: 00005645dcc716d0 RCX: 0000000000000002
RDX: 00007ffd29925f83 RSI: 0000000000000001 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000008
R13: 00005645dcc70e60 R14: 0000000000000001 R15: 00005645dcc70c30
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

