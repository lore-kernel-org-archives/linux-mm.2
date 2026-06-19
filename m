Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B5B4CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 22:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBEB46B0005; Fri, 19 Jun 2026 18:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6F0F6B008A; Fri, 19 Jun 2026 18:36:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86BC6B008C; Fri, 19 Jun 2026 18:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DC106B0005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 18:36:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC7A88F634
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 22:36:31 +0000 (UTC)
X-FDA: 84898122582.01.4E9AE50
Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4A25F40003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 22:36:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of 3bcQ1agkbACYUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3bcQ1agkbACYUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781908590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=gP+LYeB38ctwzvmUsCsvE7at+Uu9aIFzTMPoFwYFcDg=;
	b=bj3otrEixC2Fbk5tq9nyhpVr9RT+IboqvEUUhtWxdpr7il/WzFbaTbz+NV82h5XxKJ4y6m
	80OFO2N4dcOIM4DRpwba153GTqQvPSTMeTwGPXGJUeIO0gaKekVKnrcdrU1FjNoOVVpQNF
	MnRfzrCGr6br9WDQGvXZTtw7ul18O2c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of 3bcQ1agkbACYUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3bcQ1agkbACYUabMCNNGTCRRKF.IQQINGWUGTEQPVGPV.EQO@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781908590;
	b=BTp+XYUremU7NyvTFnQpdlZT+uJ3yhuuctZMNB3TQV7rjFaq6QU9IsO2fsR1wCWWvY7ylQ
	JYiv2qD3KYYMNL7tp9Rlclsq9SmWRtopBXycZ9ZJ+E4S8oexrWRGGLXPIN8R6kFRHpQgLy
	IGt4TGiTl7oFNV2MMEj5rQXDvMMghFs=
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-69e3b10dca5so4074141eaf.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:36:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781908589; x=1782513389;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gP+LYeB38ctwzvmUsCsvE7at+Uu9aIFzTMPoFwYFcDg=;
        b=mV0hfYJqid5nd+ZsVzYSmXyYvDURxlwrCGariovU8cSAzX/xihZTh6OZ/+uBLXf6RJ
         WgxQFw0/UTMwzRqtSkg80iUrn+VFY+07lzoqxFJoAHpVQReoN5eo5sS6bdvjkoDZYxsh
         sBJqvQ/0tAFOzXXjrs2vQBhcpv7WQl0qfMXWyiuwo1IimD+tyCiZUP6q0CU1XsXQ7Cq/
         eD7oNzMTbE8fC9DgXYcOd2lTdpOrUOmzp0e/lqJned4KiD8kJ5boHZpjEo9ClPpUnU/2
         Xd+PJG9rY2IXjHpzN4ZbnByYyyGa0gJn/9fK4REx1+/NPSj4R79GmoR6ZVPBVzpA4O1D
         oBFA==
X-Forwarded-Encrypted: i=1; AFNElJ/RTFq11zH4yaaMX9rUrcIJWyhrqMO/Bgox3BAq3eriPKq3o7Stq9lMZ5ituPzEA2QJ4EhIFkz9+A==@kvack.org
X-Gm-Message-State: AOJu0Yw0MuhSI+VYur9HKzU8XvfChR7h+Emd8ewaRAMoxkJrPFd3uXId
	RtW9tuRU0dFOnUIhWLJ+94nBlnlXV1vFd9Ef0/D/jLtYqeKLUUMPuleTZub5iPNrI8EyxG2/99H
	SmtZg5qfnjxne2d2PdSG/baHgb0HjeyiO0s6gkX27KQSFjcgTDfdLdtwWv/g=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1b1b:b0:69d:64a3:6320 with SMTP id
 006d021491bc7-6a0d9fb7e87mr3215127eaf.6.1781908589414; Fri, 19 Jun 2026
 15:36:29 -0700 (PDT)
Date: Fri, 19 Jun 2026 15:36:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a35c46d.951a15ca.164930.0003.GAE@google.com>
Subject: [syzbot] [mm?] KCSAN: data-race in __percpu_counter_limited_add /
 percpu_counter_add_batch (3)
From: syzbot <syzbot+a3c71b9db9c11c270f59@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, hughd@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4A25F40003
X-Stat-Signature: 9a19bf4g5a6zzwcuexfwp6d7soh7upug
X-HE-Tag: 1781908590-845585
X-HE-Meta: U2FsdGVkX19TUS0BoLUsrO8G1t+34OYD9IhS3FeHFyQWgtN1K1A1LjrfWidiHtlVCImOahIS3MK5c3XTlvSZiDbSPgnVh/F2stBWNDOQ0nEdrU4w6yIJNx+C+ZBklhvSBFNFVNTE/BiDHeE83i/3QgSCyvsnwbtgAEXQRgQbXfHtw6x4E/Fp2dCNf0pIbfGh4llKG4GP3gwu8K8FmgbHoX9SbPBpGgRTRRemBo0S8nDgHcwp+lm0WKrf/H+KAnjQNzQ4VU30UEskIhbKgHpcYOSGL1xALJ4/gM1cJ83mbIMsdFaNJVwHLLOaPaC9s4BBb07aMntBAghcJNA2NdDvJb6B3Bq8C/7cO/6IBG6gIAV8Op5O5a6mQrXJMq9QVwyppZ0zXvtU28MeAt+LJu4ZFwzPcQrovrmTYvdKJzK1AMvV9eP06c3owr3utEc6ev8KSSv2rx01c6y8hnCosRUsBioyuLvuqhO642XFpHY+NF4OZCeZBrKfvXLSeZPAM0u6vbSIMk/L+hzHG3G7DpZO8NjYX6NuaoP6/UzKWJODQ3VFg4m12h7j2kVh+fKF5JP9E2ZoTS8FHJ4/x6KgY+QsfhJMyldGIvS1G8xRK7s5emZH3wTS8Hll2jzD5PBMt+5w/gDsutqS9WvMhAaf4CqyO3je6sqnEEVHnMhR/kbbop8LqU5QWmFQsfkJLVDtv+VJlCI/0gU6kx/k4jhZNKgm6tsxKcDSZB95MLh0BtNuLfj7t4zB3Sa8UdCS9kN3Y16tt8hReO/heBg07FT0DBEajDPHHGV9w3SgkmFMDsHnYiqMsHgJ7+KpfGlbPDxjxnoUD2zuIdGrnm6lax6UVWkI/9oUxBovLnDRvGoMSD2dh4iEbaGKCbdibbXe3P1XbYSSWFfg3T8jWxQkBw2Oi44ZIKEh6xJwaHPNFGT9ppaI3itduyH5KKnSdQnvl2C3dsPrpXaM/+oAzBh2NeeNXb6
 BSIH5OIf
 klE8NT8OMkB9YWIeFNvR7BO+h/eJeBwt1JKI/RuAyt7W9s19+2hHZLjd731mfNPJlmXGWfy2b2CGOOlxXRbb1LUxt8COUWgl4lWCkh7MpOgRgmskMYuD+psxzvtqJfekmL1OXbpdFKu/1s2YC66D9Lh83WXKH9gW+vV/6jdK/NcvkELbpLxrVfOnh/mNMlBsIGcs+R7+cjeGrMJnyCQWfoknMlDolv+9ibYqMhiKQsk6PSmJoqMGzrne40wIhaIS+fvONvywvXPbShioUZAQ7HIRqx0q/aLOmg35JhUFntR/WzpQGorMl2z82pOYNtm5jsorppjUVntj4vb9nAaOEPq3ive9fpAlnRGwCflJyQDGNtpP3E0gHID0eOrTzLsGYjAS9QZbr8zywOu5JHs3oKNT1kk61GGNf3hy32OQ7BJBDy43pQQ9koAQS6lHaqHpgmIn3x1hHoZWaek9x3HtPyB0p/q8IQ+IGy1NycI5k6jnwaiqyB/DgALDc+V+U6C1Y4Co6pr4izqQGrOTMYjqPbBDPPj+Vl25IbZI+qC3545/eDFhA1k/qIpkRoBroTuyl14y05kb5QCj4L0AF/2Pe62a+5ow6cZa+NBp8kqRyOGU143L5UFfVnMBTHta8mfnUAMN35Awb7rAH14x7u3OTfiH8/BwQYwYCVE89qmOJ3WbprsNfuyuTfPwZm5C67tBdSaBViR+cy+IIM0vYX/G/wIgOHQAVtbcONxmFB/CUbQaXd/0cTxGxtIE3hDCnRoyt5gttqoEWTrwMgDWV6sLYq1o1gNfXR57ryvp/3Gjs6s00G2gaLRxzCWFmp0i+n00CPq59KylF3nVFBTz+A8P0EzpVDjRExH97Fy65NsIhulqU1IX2aE6zmTMrH8O/oH70YzrUfU0qf++cX/0Wh/QXy/vf7nD6tfA4OfGHzHpfx2bZ/RWcVxS6AXinctWfABIKUnAENiXYK43+RfnojpEBUwonvQXf
 6S2+7yCK
 GnKUoxm7yRZ9+dvtbkUteHvJBkeZ+B2P/UAAnzBoKEFC2jYDLMBAQ5/5K3m/jk+zuiQqpA8+GbHWtrUT9F7P2kDvky7dqUO/IEcU1VcOU45d5INkiN9UU4br7LPAlQZ28rZmEU9s2U0/4gI1xWqwSHcb12pDkYGfrX8j7Ys6hs1Z7X3ma5QnfOSUMckPEwl76b+OVlzRRIFgafx4FZSpuBem3MB0Bh/BPLsg0zwmpCzVLSbi39Mbli+b7+2OU1kuKBL5X971YptVvsjDGO7MAytTCw7pp4YxHzlgFpPUTzmhPWoA5OKGzS2AfKj0hbvzKzCnZI9mA2E7PWpbRD6iqMFTzZwRTL4hsbCrjczKDbJdyubaqNHWrzqs3Lu6yIsvSvYCuU0h4PRlmScchUc290CB72pwf6RdX5f44qmc+kwffeWuAKoisVRx0moybLapKhidwOt8RN8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    5e2e14749c3d Merge tag 'landlock-7.2-rc1' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=115453b6580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b0ae27ce66b92956
dashboard link: https://syzkaller.appspot.com/bug?extid=a3c71b9db9c11c270f59
compiler:       Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a565c60a4762/disk-5e2e1474.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e593a6eb0057/vmlinux-5e2e1474.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d24b55020ea3/bzImage-5e2e1474.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a3c71b9db9c11c270f59@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in __percpu_counter_limited_add / percpu_counter_add_batch

read-write to 0xffff88812a80e9d0 of 8 bytes by task 11484 on cpu 0:
 percpu_counter_add_batch+0x101/0x120 lib/percpu_counter.c:107
 percpu_counter_add include/linux/percpu_counter.h:71 [inline]
 percpu_counter_sub include/linux/percpu_counter.h:277 [inline]
 shmem_inode_unacct_blocks mm/shmem.c:263 [inline]
 shmem_recalc_inode+0x143/0x1f0 mm/shmem.c:466
 shmem_undo_range+0xb20/0xb60 mm/shmem.c:1272
 shmem_truncate_range mm/shmem.c:1277 [inline]
 shmem_evict_inode+0x132/0x520 mm/shmem.c:1407
 evict+0x2a5/0x510 fs/inode.c:828
 iput_final fs/inode.c:2022 [inline]
 iput+0x430/0x5a0 fs/inode.c:2071
 filename_unlinkat+0x21f/0x410 fs/namei.c:5585
 __do_sys_unlink fs/namei.c:5616 [inline]
 __se_sys_unlink+0x2b/0xe0 fs/namei.c:5613
 __x64_sys_unlink+0x1f/0x30 fs/namei.c:5613
 x64_sys_call+0x2eb6/0x3020 arch/x86/include/generated/asm/syscalls_64.h:88
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x136/0x3c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffff88812a80e9d0 of 8 bytes by task 16836 on cpu 1:
 __percpu_counter_limited_add+0xc4/0x3f0 lib/percpu_counter.c:-1
 percpu_counter_limited_add include/linux/percpu_counter.h:77 [inline]
 shmem_inode_acct_blocks+0xf4/0x230 mm/shmem.c:232
 shmem_alloc_and_add_folio mm/shmem.c:1979 [inline]
 shmem_get_folio_gfp+0x5d3/0xd90 mm/shmem.c:2502
 shmem_get_folio mm/shmem.c:2608 [inline]
 shmem_write_begin+0xfc/0x1f0 mm/shmem.c:3239
 generic_perform_write+0x186/0x490 mm/filemap.c:4363
 shmem_file_write_iter+0xc5/0xf0 mm/shmem.c:3414
 __kernel_write_iter+0x30f/0x590 fs/read_write.c:621
 dump_emit_page fs/coredump.c:1298 [inline]
 dump_user_range+0xa73/0xd00 fs/coredump.c:1372
 elf_core_dump+0x21c0/0x2340 fs/binfmt_elf.c:2109
 coredump_write+0xaf9/0xdd0 fs/coredump.c:1052
 do_coredump fs/coredump.c:1131 [inline]
 vfs_coredump+0x2770/0x3290 fs/coredump.c:1200
 get_signal+0xd33/0xf10 kernel/signal.c:3023
 arch_do_signal_or_restart+0x96/0x480 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:66 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:101 [inline]
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 irqentry_exit_to_user_mode_prepare include/linux/irq-entry-common.h:244 [inline]
 irqentry_exit_to_user_mode include/linux/irq-entry-common.h:315 [inline]
 irqentry_exit+0x14d/0x610 kernel/entry/common.c:165
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595

value changed: 0x000000000000459f -> 0x00000000000035b4

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 UID: 0 PID: 16836 Comm: syz.5.4499 Tainted: G        W           syzkaller #0 PREEMPT(lazy) 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
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

