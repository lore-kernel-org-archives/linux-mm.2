Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EBF5C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 13:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522ED6B04E5; Thu, 13 Aug 2026 09:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3E86B04E9; Thu, 13 Aug 2026 09:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9056B04EA; Thu, 13 Aug 2026 09:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 192496B04E5
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:26:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A900716015C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:26:53 +0000 (UTC)
X-FDA: 85096321506.18.A5B4428
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	by imf26.hostedemail.com (Postfix) with ESMTP id EFF8114000D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:26:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf26.hostedemail.com: domain of 3GsZ9agkbAPcrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=3GsZ9agkbAPcrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786627612;
	b=V8FyCavxRFOf8OV3mbtamyYxZOqT6M6w9bwggePHritJyLVWcnajejo9inbNrkk6UMdEG0
	bhBcPbqpxMfvSwkz2vrZnAKe5yTGcYSTUDaRFXOy/kMh5hfocr0wjSJVwU8USk6qMaMA5u
	cGfRmhhAMRxBCVD3TaiGm+yh9ZB8708=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf26.hostedemail.com: domain of 3GsZ9agkbAPcrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=3GsZ9agkbAPcrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786627612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=hABxMDJF3aW+EgiaAYYhCDRtl3tqj0WVMhGSSJF258M=;
	b=xc+QF5cm5BuDiQTIblw/UN5KBiYmmo1Pp9BPByjpkDUp4hGSoxAl/b1/GyHOGEBpZ+sUKr
	ZkytAZReY/mGdgofEjvSgV5KdPfGbydPz8y9QvwoMX1OqqX5F2SesY2TnMYrufKY6xPSwd
	gGd8U1hHbR03RczoiYloJxknx1H9GlQ=
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6a313ec13ceso1619115eaf.2
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:26:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786627611; x=1787232411;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hABxMDJF3aW+EgiaAYYhCDRtl3tqj0WVMhGSSJF258M=;
        b=C5kuW9rSbgQTYzsZaQ9BRgTgk/2aE49yyobyawEpNxK68/iKXfGvEjITc+UZaIddRP
         U/CAxOJRZjhafYy+v+wY/qqGK41ytlZmrns+rN8bDMZrZzP3A8RiJoibBZyBvnmn55d9
         Lhr18OI1OppXz9EmfixudwDvK9bnGkYpoVVtWWUSgd6/5XP94suBQjeYAlpLFVKMMGaW
         lDB+UBO9fe4fYI/peOYI00ish2JbM912Uy69bkMUhNI0ItCsgxXW+lGrNO9VuV3njLe9
         NCsYM8lu4ScT5CPJSLEnpdvO6UJgy1GEbZaQR93aW8gkhqKwFsQTGc3UnNkpjY79jJqR
         /6hA==
X-Forwarded-Encrypted: i=1; AHgh+RrWKdNQuAkfRoNWk+vr2tcQhUMuMJf4hcV1aKfG5HW94AKZYF2WRByKSXx4NTBx6UODY1KxU1rL4Q==@kvack.org
X-Gm-Message-State: AOJu0Yyg+DxlN9uFjBqJ+kkSpPUBxEcbzbbXmutyGrlSObStMJ5jNeEy
	3UhcpbWbaAXmVXpzuGryOTqnFD37n2ZAYlmsaInpQl6ZYbCDXhut2KhEALgAcx2Hu3Z6elFhBlY
	V61jtXd/1uauHlmZD8DZMSuCEzgxcmXtOL1sZtg37VmjUbf7Zg6ewLEdzu1E=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f033:b0:6a3:c1a2:bd4 with SMTP id
 006d021491bc7-6b0c42f759dmr4956829eaf.20.1786627610938; Thu, 13 Aug 2026
 06:26:50 -0700 (PDT)
Date: Thu, 13 Aug 2026 06:26:50 -0700
In-Reply-To: <20260813-memcgid-objcg-v1-0-83d21c685b77@tencent.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7dc61a.ec5dc6cc.21cb3f.00b7.GAE@google.com>
Subject: [syzbot ci] Re: memcg: fix dying memcg pinned by swapped out shmem pages
From: syzbot ci <syzbot+ci49bb3ed471ef5f9f@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	bfguo@icloud.com, bingfangguo@tencent.com, cgroups@vger.kernel.org, 
	david@fromorbit.com, david@kernel.org, devnull@kernel.org, hannes@cmpxchg.org, 
	kasong@tencent.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, mhocko@kernel.org, muchun.song@linux.dev, qi.zheng@linux.dev, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, weixugc@google.com, 
	yuanchu@google.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: EFF8114000D
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: m3n6x9qdsfhy5nogqg848ocaj7751kos
X-HE-Tag: 1786627611-680068
X-HE-Meta: U2FsdGVkX18Yk706LtPMOLp/d2rRTxbOxcyF2wMVMCH66BbGgI6i2vZ6VX2IhVuChtsyC3e8qljJhWhBMkMz9hONRJH6R96TIIQBi/TwvC6TycZsttWjCfArRuksV2UezpA5YKYkF377pauAjWtCs7GTva+FA1+stw+GaJDS4kcngVDzdS5ycrxjeXVTh/rTJpEj9CYdvcg3/kBPun0qmuxkzQP6y1A/iM2/KqaZ6Jf2OW7PeGvVbNdkE48LYct8JEORhVC/YlAG7T3r6PvB8pKzz/2FC0/ajTZ1Z9On5yamlajIunOuVJSfslHflf50mlxppk4bP8Lqs6AX9e0dtxBP0fEzcs8tgBlWd7MH/iaviBDI01oWhvPEBqoIH8Vh82nzeDeTJr00HwviVDwx817t9drI+X6rFy3I4Q7FHZBWYPnwjFrS+e7ClPb4+ChlCAP1QtdAEE/zY99dMNo8FYQyfKseZPJHTEN15E9a4L+AWaV4stIMnNur9ahn8hNbeVPG7JZX+9vB7gsoRnzJ79ftHFDNK+e9XXibRHlKm+5p5PeSMLWaAPkOBtzuNXto7BcL8itJG6q1urY88ft2ZXLdD2wFOvyfHHUH3Onb8V34zmMGhQFj75A4IyGaWmEzHevy/nyTQ1CzJkvck1Guxo6oPRnCa5RJlEE0kWoP1lx4jFGPHWtglhg56mMFBbYRVnOSqOa/7iCefjP1BQSzUcaZE+Zy7KGfPnZ4TxbsVtOUVWIL4YEdwf6P47tbIQoZ/YW67lMyLNL8+S5qGDJuBauhuXS6sXWgv0QlCU2YKRpaapOOMsETVw9QVsCtHcX6X6zygfYVdLRkflPRsw/XytdaxwMphW7ATAcUIUrpmnyGqVW+Wm+fJ/4duk55RIPCusQgWOLBO7GExwf0rDingrDDd0sHjOZNYgXqTA04UjoYmFqHCFtFLzTrgiqblvu/pK1b5wTNg5K8yzp05Cs
 8P7MoCMM
 WkQeJs2U/KXHo5BsJtsHeSjy/NOzb1nACuNBMpE2L7PAbwlsPFeJixV+qhNEmLxAnrTkC3P/FYuYvlzuO8LQnuqKp3puYE3g7aBv/WW3pHEXUEs7qJ/R0ykmEj32xpiSe3DByPJg4LmqJx8wufHkXkwJQKfuN+2RN2uoHczwOqGJbGS77l7EQKWgXRS96GI6FGoCBoWbG26SBRa/604H1M31syr6WgOtC+0Hdkhu1P1r0ytJVLDruvoufaSybXVoevZphdAGqirnwKlYBoPTJo83TvjiQPojStmRsYXlnVESi+BgM+x0ZZyDyDq7Edt885nXHqGUN7TCGnA3AIyOghsmKoQvsSHMfoHNPsdM2any7hUrJVBTVrJ/ajIsU3f5s0CNzhUxdL8NUBs1t+13SBxWdEQGNBtXhBJaLonbC6lm9yDgUPhHOKd1J921/OvVmMdMVwOMrJzFsQ73ijXov7NRcykVNEPWQ17GJhJXQYX1wDWUnOQn9j9cUTBb5Z2nafnGAP962/UrXi2QF/dqeTNwm+dDm3XK3Or0OGlm9FS6NnFfZKXdRY9aZjl2n+mAhcuvdCuBOcB2ATho34qQpg1il9maFVQ/tG0LZTPpsXdQ416Y13QqbkaMXNWnt9aOuTU3Dbl4FMCdxB3Wcz1ikfx/bxgXMWjgCfe8S8elNf+XnektC8VDotFr7xtLOjCx7l0ZTjAvrv1T/Tj2ID1OFABuj7nvxeZR7ehdEGfCJsk+v2RGgXHQ3pAZskeYSJQzg3Tkk/OdKkdBH+Lw2SSZL1KBh5jHIy45yzJAtbA0y43HSDyX78pmcRK/pljoFdJEnVDFin0LbAkNONrh9EoFULXF4C84SDVkROFSHmMOi9n76bzaAK1oxlxX5xzmQI4QE1B6Ba8EjnkCUmmdGlNn+yGCrffOObTmxVyknatETd55qRkD035kb6pXs6yw0MT72gTyHaWe8dI2uIiU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] memcg: fix dying memcg pinned by swapped out shmem pages
https://lore.kernel.org/all/20260813-memcgid-objcg-v1-0-83d21c685b77@tencent.com
* [PATCH RFC 1/5] memcg: move memcg private ID refcount to objcg
* [PATCH RFC 2/5] memcg: get stable memcg first before getting memcgid reference
* [PATCH RFC 3/5] memcg: remove retry logic in mem_cgroup_private_id_get_online
* [PATCH RFC 4/5] memcg: add a helper to get online memcg from memcgid
* [PATCH RFC 5/5] memcg: filter out reparented memcgs got using memcgid

and found the following issue:
WARNING: refcount bug in __mem_cgroup_uncharge_swap

Full report is available here:
https://ci.syzbot.org/series/3a8a2a5f-8b6d-4abf-954e-a1a18ee62748

***

WARNING: refcount bug in __mem_cgroup_uncharge_swap

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      288058d8db5d35623228d84f48d9bea3707d5c85
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/35dac6f6-b44a-4ea8-9adf-2cdda5584e45/config
syz repro: https://ci.syzbot.org/findings/6e117c0b-d6e2-44a6-8e35-161cb33f2aff/syz_repro

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: lib/refcount.c:28 at refcount_warn_saturate+0xb2/0x110 lib/refcount.c:28, CPU#0: syz.2.19/5863
Modules linked in:
CPU: 0 UID: 0 PID: 5863 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:refcount_warn_saturate+0xb2/0x110 lib/refcount.c:28
Code: 64 84 8e 0b 67 48 0f b9 3a eb 4a e8 58 fa f2 fc 48 8d 3d 61 84 8e 0b 67 48 0f b9 3a eb 37 e8 45 fa f2 fc 48 8d 3d 5e 84 8e 0b <67> 48 0f b9 3a eb 24 e8 32 fa f2 fc 48 8d 3d 5b 84 8e 0b 67 48 0f
RSP: 0018:ffffc90003bbf1d0 EFLAGS: 00010293
RAX: ffffffff84d3ed9b RBX: 0000000000000003 RCX: ffff8881bdf58000
RDX: 0000000000000000 RSI: ffffffff8f363380 RDI: ffffffff90627200
RBP: 1ffffffff20ae968 R08: ffff8881bdf58000 R09: 0000000000000005
R10: 0000000000000004 R11: 0000000000000000 R12: ffff8881026f8000
R13: ffff88810a914100 R14: ffff88810a914134 R15: 1ffff110204df009
FS:  00007fe2ee63d6c0(0000) GS:ffff88818d960000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056066247f0b8 CR3: 000000000e946000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 mem_cgroup_take_from_private_id mm/memcontrol.c:4049 [inline]
 __mem_cgroup_uncharge_swap+0x204/0x2a0 mm/memcontrol.c:5707
 mem_cgroup_uncharge_swap include/linux/swap.h:520 [inline]
 __swap_cluster_free_entries+0x735/0xc50 mm/swapfile.c:1955
 swap_put_entries_cluster+0x3b1/0x4b0 mm/swapfile.c:1629
 swap_put_entries_direct+0x137/0x210 mm/swapfile.c:2139
 zap_nonpresent_ptes mm/memory.c:1838 [inline]
 do_zap_pte_range mm/memory.c:1905 [inline]
 zap_pte_range mm/memory.c:2003 [inline]
 zap_pmd_range mm/memory.c:2089 [inline]
 zap_pud_range mm/memory.c:2117 [inline]
 zap_p4d_range mm/memory.c:2138 [inline]
 __zap_vma_range+0x1d9d/0x4f10 mm/memory.c:2178
 unmap_vmas+0x390/0x550 mm/memory.c:2247
 exit_mmap+0x293/0x9f0 mm/mmap.c:1315
 __mmput+0x118/0x420 kernel/fork.c:1187
 exit_mm+0x221/0x2d0 kernel/exit.c:615
 do_exit+0x6cd/0x2360 kernel/exit.c:997
 do_group_exit+0x22d/0x2f0 kernel/exit.c:1152
 get_signal+0x121b/0x12c0 kernel/signal.c:3046
 arch_do_signal_or_restart+0xbb/0x860 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:66 [inline]
 exit_to_user_mode_loop+0x104/0x730 kernel/entry/common.c:101
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe2ed79e0d9
Code: Unable to access opcode bytes at 0x7fe2ed79e0af.
RSP: 002b:00007fe2ee63d0e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007fe2eda25fa8 RCX: 00007fe2ed79e0d9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fe2eda25fa8
RBP: 00007fe2eda25fa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe2eda26038 R14: 00007fff0bed41b0 R15: 00007fff0bed4298
 </TASK>
----------------
Code disassembly (best guess):
   0:	64 84 8e 0b 67 48 0f 	test   %cl,%fs:0xf48670b(%rsi)
   7:	b9 3a eb 4a e8       	mov    $0xe84aeb3a,%ecx
   c:	58                   	pop    %rax
   d:	fa                   	cli
   e:	f2 fc                	repnz cld
  10:	48 8d 3d 61 84 8e 0b 	lea    0xb8e8461(%rip),%rdi        # 0xb8e8478
  17:	67 48 0f b9 3a       	ud1    (%edx),%rdi
  1c:	eb 37                	jmp    0x55
  1e:	e8 45 fa f2 fc       	call   0xfcf2fa68
  23:	48 8d 3d 5e 84 8e 0b 	lea    0xb8e845e(%rip),%rdi        # 0xb8e8488
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	eb 24                	jmp    0x55
  31:	e8 32 fa f2 fc       	call   0xfcf2fa68
  36:	48 8d 3d 5b 84 8e 0b 	lea    0xb8e845b(%rip),%rdi        # 0xb8e8498
  3d:	67                   	addr32
  3e:	48                   	rex.W
  3f:	0f                   	.byte 0xf


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

