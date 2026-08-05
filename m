Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B351C55838
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 00:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 585D86B0088; Tue,  4 Aug 2026 20:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D1B6B0093; Tue,  4 Aug 2026 20:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 472DC6B0095; Tue,  4 Aug 2026 20:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D8156B0093
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:01:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98D0614032B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 00:01:51 +0000 (UTC)
X-FDA: 85065262422.08.14D8FD7
Received: from mail-oi1-f205.google.com (mail-oi1-f205.google.com [209.85.167.205])
	by imf25.hostedemail.com (Postfix) with ESMTP id EB6CCA0013
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 00:01:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3bH1yagkbAIs7DEzp00t6p44xs.v33v0t97t6r328t28.r31@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.205 as permitted sender) smtp.mailfrom=3bH1yagkbAIs7DEzp00t6p44xs.v33v0t97t6r328t28.r31@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785888110;
	b=cSIh7EK6ncltbpeevejJbuk7Z83K5n3Bczni6fva+yj8N4TF41YtAm7tv3zZwbLWWuXL4m
	8PkTzXdS8I4fcTHHOuK1u+b/OgM8VFJZ4l667cmhqglS1DXRM5wSSLL+oGUeK+IUz0g8wW
	EP0CeNanMYGAfg03HGz6yAHIupGO7No=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3bH1yagkbAIs7DEzp00t6p44xs.v33v0t97t6r328t28.r31@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.205 as permitted sender) smtp.mailfrom=3bH1yagkbAIs7DEzp00t6p44xs.v33v0t97t6r328t28.r31@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785888110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=7ljke+Jb2WS/MuuNhu+Gojm59EgN+Rdq5k66c0XmNA4=;
	b=ppxsuv/yB9laj/M888OThtoWUZi7a5GMCxxdSh1Q0hIb27lFRuVMAdjuw+jcHih1LXavmq
	c/A6JjsBg3DihmIKiP/c66Q6PW7oWhOsPrbHvT2WwAuk0mkyWC9eNlLe5c4fuxP6YO0Goe
	3+6aXOQcilAq52VUvETQZa58lITOXr8=
Received: by mail-oi1-f205.google.com with SMTP id 5614622812f47-49001defc4dso449014b6e.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 17:01:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785888109; x=1786492909;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7ljke+Jb2WS/MuuNhu+Gojm59EgN+Rdq5k66c0XmNA4=;
        b=hHIzp0P1FYRr64f1W0q/QbHuS0nRKZfz427XgDyZXb1ZsPGb5RsvJRP5HzJ+ozAc+L
         6x7fVDTl75lwen+44yxnkfPJTQgAFzb9JWHh+RHZj5awCP8VB8pMP9aV57PT4AG00fOo
         ijxtzhj8PrJakbopZavSUVawNiB+9/NVahahMO8UsOYyFzMT3hTeOYozToO32dA1S8Cf
         AYy431pXvwBosL0WnLZWNJyDLg2grLhBQabEye1y9E/vIRwFSqLrJ0JDiR7Ms/bLvIga
         vS71SHqdXoddAcXN6hBpGuUcpdtU0HuXsp53Kd04l36KRpsgGXRh9Sk93Wet4oy1d0aB
         RpRg==
X-Forwarded-Encrypted: i=1; AHgh+Rr1fljjXMxl8bJVH2qIU91VZMj/wo4R29Co1mvcnmHVEGPMNC/fqtqhYwEhbNwgtw1yXMfP82joRA==@kvack.org
X-Gm-Message-State: AOJu0YzDUe0BY/v4+sEbvmxHx/Zk9QYmb6DonuVsIz3fTyPulYQOytps
	62bXVM8G6MDgEYOx4jkozeWRbrOPs5aJJ5t1ESnkF+PENO9SQSY1dH/HLPPSUu56TnlvvJD9Isn
	je+nlz9lpMT4fK2I6yHy+AdK5DVHzx1rcm2Ec9CeFlMufW/W7JDx5ZVvIPV0=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:188e:b0:6ae:46cd:e908 with SMTP id
 006d021491bc7-6ae96ec7afdmr1717347eaf.17.1785888108906; Tue, 04 Aug 2026
 17:01:48 -0700 (PDT)
Date: Tue, 04 Aug 2026 17:01:48 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a727d6c.9511d2ce.1fc5b9.035e.GAE@google.com>
Subject: [syzbot] [mm?] INFO: rcu detected stall in khugepaged (3)
From: syzbot <syzbot+d2401aeb74cc84adba04@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@kernel.org, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EB6CCA0013
X-Stat-Signature: fpdcxpo5nmckpntynnmgdg9e95gc9yya
X-Rspam-User: 
X-HE-Tag: 1785888109-925858
X-HE-Meta: U2FsdGVkX19nyoqucFv4zRdLsgasfRiNboMFh2Hn1HuL/s5RN73pl1ol2J2Swu1PBlu/qMGnJy4TI9PxrMHKB1S27aeey+LCenj/VU8l5el9nnNGaD5gJ97IWClqiMDFFCnEm3PlO1BBvjoR9kGp3GWgv3bAdFFSSh4YTzjNM19KveV6Wr41ciOdMtXA+gzbi8JvqLPoSBV0gE3086lhT9n1wlLyPuoszZ2FCG2S5YRCI1aJWfdLCfJGAsKLGIid198JpijyS20LsGZ622O2lFORcFiml3qtQ4iEF3SBCoBc8LBA1pVCYq2ejdeZjSE2dZHZ6jIWU5AM3dkEWyQK12eeXnMIzkHlotd41GwxWDze9gIikKin76nlaOUFey2WJWR1qmzSb0MpW8/xoSC5G0yw2pAdKWjOhylfcR6n+bZnQpZeP4oBP/svO0rj2RvpgMz2nrTjHHT+a2cFeoM0TYRQf6F3EIcJlYG7MO0CognMdVjfhu8feDgk9m99tZO9lrUD9W5UP57tZO41UnBQMUewwzFaSOD5i/ClviH9RDdEflPbSDDQ0xtabL4YEvTTDHcDadBgG20cVdh8HmPifm5Oi84hQgVO0q6iG66PpSRGnWGxXS9aYWKVKAFr4s5ZIfbSI0ERUXXgtPeBKzD+iPWAEAYerjDG6rHnRRJgLiEojdnlw3ll6qxb+W0WWa32mX1spTiLab8oa6rUi1sX0cFRHiHPqHz6eUqxbiGVMNYr+SHIKBxfevSEPO+0dSbQOdEEmCwHRm1d2LSHytlefjcIQKy32WjvPJEc2MzBMB2OZGLRwFxVVYkuW5Ok5CeyiZhDgt1eIRq9uSqb5COCUQkdU5yKwoSnofRY3O6TCOL4bKl0bRSFKXwQg3T40KZ8NVxqw+ax5cyv/CI7tKJqDDUUBR8Uz3pKqtGaQykMhRjHj3zBJnQtEnXnQFT39oN2W+OtVnYpZFrLNHXYJ26
 s0MnyTKn
 pn/nuyVIJA3JQHG1CBzzRXYrxJX3q117ZAXKWEQFMDgTvgIfQsHUaeCcA0PWDDaTQPGfRg7YSuqMsbiqoYFFCbRubQl3Ce/PQtggrM2f5LQpckob/sf1JkoGTomcwc5UzRWUPiVspF88muwoiPgdEJJP1TAnqr6n4sKyK8MI4JCRh2tyXleuUPpGqiR10zlghG0f3t99KCOul64FOBrwBvGbbCSs6F1QMU9KvUFzBefJRIuwlC7r5SopSu9oD3vuVwpbz7jOaY6sJtjxPeqRXQ+jsPgkXK+ibmxaN/jdFvT/n2J/EvJPzoc2fQA9v+Z1dcOsJibzPfaGkiKS/OVEFrBL2IMN6FwwxjFMdtBunTVeuk5EaOkkxjG4vnujMMXReU+SUX/aPoqd0gNyE71Igx4HkJMqLxthOfTP0gPdn0aSl36dzJ+EZelD+sq1EXIZ31bP+B44kwqYY6qzqVDTsKc/bU+8M5QYdQEPQHQWon1zcjfv+aQs0JLLJpZZCbNAVKhrOr8KxTzd7X8o6Jb3qg6tS7uUmbge45/DRd87vraAivYB1FxLdMGi48eIrECS64oNqvM9o8uVdzjj1hj5M/q153PPEKnOcFRScoic6yBsUIxjMhMXpbUpMg9TRL5Yo7AiSz3JLOwm14Op/9bCOHg1pUk0nJ+MA1mmvdpb6AlM2C16HCafGIScZTI0cpDV/uDt57p/5JZ0GF9YM/CDkM5RdVstHXTlM4z+6o9WnS1vw2+e3PU2dysy2+V9UqhCbgfZ+fo5ZBYr3K7RoRkn/kq1QN1yqJhQ4XNRq1aqzEDf+e1IXJ9zGK2va0/Dj1xirTQExEyz/A6nriI8Flp8Jvd/4ajYAAF0611z33Hvy4amBEWU3koPq0cRLI8zWGU1Gsy1lycOM97ItadkTRhvfpMhMzP/XajUrCuixdvWrgwFRdDnmSsGmCBgq1Klq/rfoJBUaon2wDA50vYjpO8hAoo6jMPrU
 zHS5nJd5
 wq+81YBMqKZwkuVcsMPKyzNK8Rwwhf/PAVVp00NMKietpEiRFo4I3PHaBaFuMvOdQHEKkM/zvCYcH+jeKvhfA7vgKH4XETV9fKkaNOJ4QKOVsZp6Ddkwl/loLr4rCNkTuqyMPnlQTlOIrlE1SOs3vUe9KWKwm4l6IHVTjILJ/721pyM0X889i7e01Hky5dS6UP6PzZbZ/JETXcXnkoBQB/cLcdQ1J3LRLB7UzpZxBt3suhTIGWtNiPqF/4vIyW0zeii0n1rGqlQ/6LB/qXZI0txiINda2TN+bJmQlig2fjTphuhi10mDKInQlFhwdBlDHR5+kxCxbcxDk79JwlT4bCVNmRGaA1bdkQ3cojHXfO4HsOSe9miUdHC1pFQrAlRdntM2zUGkmSyTXgQ0zBDaQX1HX/oQSKEi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    3708dd948844 Merge tag 'pm-7.2-rc6' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11ac703e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e38b15c29e6a1d9
dashboard link: https://syzkaller.appspot.com/bug?extid=d2401aeb74cc84adba04
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c0390423374e/disk-3708dd94.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3130bf9c5dbf/vmlinux-3708dd94.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2c8fbf8aeba4/bzImage-3708dd94.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d2401aeb74cc84adba04@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P37/1:b..l
rcu: 	(detected by 1, t=10503 jiffies, g=32265, q=1190 ncpus=2)
task:khugepaged      state:R  running task     stack:26864 pid:37    tgid:37    ppid:2      task_flags:0x200040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x17d9/0x56c0 kernel/sched/core.c:7234
 preempt_schedule_irq+0x4d/0xa0 kernel/sched/core.c:7556
 irqentry_exit_to_kernel_mode include/linux/irq-entry-common.h:539 [inline]
 irqentry_exit+0x14f/0x8f0 kernel/entry/common.c:167
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:lock_release+0x2d7/0x3c0 kernel/locking/lockdep.c:5893
Code: 7d ca 11 00 00 00 00 eb b5 e8 55 ad 2e 0a f7 c3 00 02 00 00 74 b9 65 48 8b 05 45 38 ca 11 48 3b 44 24 28 75 44 fb 48 83 c4 30 <5b> 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 48 8d 3d a2 33 b8
RSP: 0018:ffffc90000ad7028 EFLAGS: 00000286
RAX: 623a32d217845600 RBX: 0000000000000206 RCX: 0000000000000046
RDX: 0000000000000000 RSI: ffffffff8e4b3351 RDI: ffffffff8c4bdd80
RBP: ffff888020ea0ba0 R08: ffffc90000ad74d0 R09: 0000000000000000
R10: ffffc90000ad7158 R11: fffff5200015ae2d R12: 0000000000000000
R13: 0000000000000000 R14: ffffffff8eb59c60 R15: ffff888020ea0000
 rcu_lock_release include/linux/rcupdate.h:310 [inline]
 rcu_read_unlock include/linux/rcupdate.h:871 [inline]
 class_rcu_destructor include/linux/rcupdate.h:1183 [inline]
 unwind_next_frame+0x1baa/0x2550 arch/x86/kernel/unwind_orc.c:709
 arch_stack_walk+0x11b/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0xa9/0x100 kernel/stacktrace.c:122
 save_stack+0x122/0x230 mm/page_owner.c:165
 __reset_page_owner+0x71/0x1f0 mm/page_owner.c:320
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1406 [inline]
 __free_frozen_pages+0xc1e/0xd10 mm/page_alloc.c:2950
 __folio_put+0x4b3/0x590 mm/swap.c:112
 folio_put_refs include/linux/mm.h:2144 [inline]
 collapse_file mm/khugepaged.c:2643 [inline]
 collapse_scan_file+0x4285/0x5210 mm/khugepaged.c:2773
 collapse_single_pmd+0x2b1/0x3da0 mm/khugepaged.c:2808
 collapse_scan_mm_slot mm/khugepaged.c:2913 [inline]
 khugepaged_do_scan mm/khugepaged.c:2993 [inline]
 khugepaged+0xa00/0x1780 mm/khugepaged.c:3048
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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

