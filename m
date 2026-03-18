Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA3DF103E195
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2E86B0269; Wed, 18 Mar 2026 11:03:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AA3F6B026C; Wed, 18 Mar 2026 11:03:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C0196B026D; Wed, 18 Mar 2026 11:03:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECF3B6B0269
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:03:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ADC631B8A0E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:03:28 +0000 (UTC)
X-FDA: 84559502496.21.655C8E5
Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
	by imf23.hostedemail.com (Postfix) with ESMTP id E1DE8140008
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:03:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of 3ur66aQkbAHcntufVggZmVkkdY.bjjbgZpnZmXjioZio.Xjh@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.206 as permitted sender) smtp.mailfrom=3ur66aQkbAHcntufVggZmVkkdY.bjjbgZpnZmXjioZio.Xjh@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773846206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=448yYbzRRxq6bdAx7wW1zfDT2Iu6eXFzWfA4H8JFuxY=;
	b=Sksh1nrlaCLypsPgZprIouswC5KJMIuRH4Icu7gAtO2Ihte3RemevL4wDM4ag6QIcCOHA2
	+UhfzDv1yFrn9De0Lir129y/eSvoshfHkrZ9yZ6Na84l9nFLa8RyOMvpf4+30CHPnq2wPd
	frY7DcalsSHVNat+d2cOK43wyDcfZXk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773846206; a=rsa-sha256;
	cv=none;
	b=GXARoCn2YmcbIuNNf95PQ25Nay2D5+z0S2VldPA7xjsDAeGUqpYaRvohUdWz52VGlsw5n9
	LmbHucjaAk89oP+6kOFHsAB3hQrDpt42dDM9C1MWkQ5RM8BIoM2Z/jXeNAk+wuisQSNbSo
	BD5lmqBiSDgh/TwvEw2eFHRNyaF1M1w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of 3ur66aQkbAHcntufVggZmVkkdY.bjjbgZpnZmXjioZio.Xjh@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.206 as permitted sender) smtp.mailfrom=3ur66aQkbAHcntufVggZmVkkdY.bjjbgZpnZmXjioZio.Xjh@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-464a0af43deso98237b6e.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:03:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773846203; x=1774451003;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=448yYbzRRxq6bdAx7wW1zfDT2Iu6eXFzWfA4H8JFuxY=;
        b=WlBkCn/6ndaZRF7DLz7igwbkfXsqyJHCtDftst2q+yweWfxr1rGo4bk9tn8YXDCG5M
         6Z/SGiqV4NSOGsnFjfayzSHq/q/YwPa1XEer2XYP2E66pdapZrPXjM0lnZ5eyi4FzphD
         CLfbyW5ssgPatGwDpbt5m2WtV9jtreuSu0iuVeQ32gp9p1YQrHeKKb/Y4BsuRwqkK4gU
         fzAw//FOvwM4VbJxZUywz4KFXnqweKxR8vKkeOr6KNs7TDPrHntVmucGdqNPMf5SI3qT
         vjOvef5n8778e4gj/loiajTJ5Qlmxhsix3o3OfE+lH37FNfBRrBr+0f7cLE+Td9HdMbQ
         pKQg==
X-Forwarded-Encrypted: i=1; AJvYcCVBtJClM8Bi+PrYEvcTvWVmkTX3TOw4wtLaJxMSAt833V1Jnb2yTL/SHyTxfGfvTvjv6W+sPSz6fA==@kvack.org
X-Gm-Message-State: AOJu0YykD4P6YWrVbwUQAd4KNwi0fIpCyO9TQBIKhemPkEV15RQfHMsS
	CQA55wwoWZuDM+PKlK3h/wZkEzx4j4CnrkJRu5F8y1g8zbFqDgwKOC04jVWpTJarO/r6lwnbiJq
	2tDssRZMytUy/3KJgRYMQ7UWkCUt3kD7y4lxklgOJAfnk+9t+oqhhYAijgSw=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:16a5:b0:455:d3f2:4bf9 with SMTP id
 5614622812f47-467ba4167e8mr2193966b6e.30.1773846202215; Wed, 18 Mar 2026
 08:03:22 -0700 (PDT)
Date: Wed, 18 Mar 2026 08:03:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69babeba.050a0220.1b2d94.0003.GAE@google.com>
Subject: [syzbot] [mm?] general protection fault in zap_huge_pmd
From: syzbot <syzbot+de14f7701c22477db718@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, npache@redhat.com, ryan.roberts@arm.com, 
	syzkaller-bugs@googlegroups.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: eo5gd6651fzgobuaypnzzxoog6fi41i8
X-Rspamd-Queue-Id: E1DE8140008
X-Rspamd-Server: rspam03
X-HE-Tag: 1773846203-701719
X-HE-Meta: U2FsdGVkX19UFaNIknGUPlW7cECSKWnVnUu3K9k1Y+OtUkZ+xb1cSLtaSFRIyZ+xe+u+acBbrPcKMgeTA3WtwgR/jdTADzNAOQWX5L2kRPL697VmtTCNI1d0QmzUmqRxYmfQx9D+C9YpxmDmvbTx+wWiiEevtxHcH/FnA0O9O8lrqwcvEeydfDvkTLKHbVpQTBkHSMSQfiDz+u4sWSN156u4zmmU7IW+2Bw2J+TBli0lcmCvJzugnTGDGZwML29CHkriLahzgsjsqqpy/H6Ls6QnX7PcMVXS/GKPXx/XUethm9KbxUmNE4jCS5jVWK4HZksco3AHHAN6RpMG9Mev1eYDykgLHJXUpfGJwvg5z6l3u3sswhvrTlEhF3LcTtqaKcwFCRx5QXs32qDQVUmdaWQl2ngS7gxKBBR6/t/KATGkE1PL8wwdwshRSFmCEkepxBWo9HvfVj3Pgg6HtRKqt/jW75MLBLGVrdUEhIyb4zZGjDCt7RpUz5YskzZTPRSeQKiYa5TGJou/G6e7e0Vd+GwtXjDUe/p9yhm38tcfCzyQa22X6Q6eBiXhWcL8b3NZ62MmQx6IoiH0bsfgQj9nOlUwvO6swPAxog78obeAGtR4eyrPSHMamgm5BuG98yYQdndpcTvQTd6ANdeiPpT+s8cVey5pOaKgCRtTEAtD/8XHtEJorGjYo5KCMOctGJubttlzXyx+aHUsFwUO9Gx5yFb9WYv5CwMlaGNDf3RQO9LJZSIbU5eTknPKJkXF3FLrylBRAutbcS2fgmV4HtawZ2ogFCE4rOSMe1U+iB+CU8fsyk0zKw6NSLE3MXj6cxVm2mB7xg4cds6g4WKh1VNlMHEbnbJtnTUKX4T3iPsqjeQKdeWnAjb3yobY54IxstDe3aTa6W7tuSC1PPNcvrl7uTntLeHABdV0FK1ueHBwsvz3P307eiebjtHFi7ppPf5JUmpypmWkDRi4w+lnkTa
 Dhj8gudq
 Tp7wBEv0S0HPhQmNwgVJ3xNQdmyzyqV1XdlwGZZ+caqAehCHHi8wOz0mF1HbDfzBJ61rFMqRCU7dpTYNPCbgBavkN3QFfCDxal77q+w1wOqsAPW+YQP7n5drYeSv5gFt2APIL4aBcgLWP62HU9Y7A0ik67vLfiLMIodyXTgXlgVCVezvYD44q0Tobj5Qnxhp6s9oooBHykov7RbiB117BJg8BIBAurnIk8k9Zk0jVGdQVHWrlSJd/vgIvCkLCqM66m1CEqqyCJ1G5D9s/+vGMxYUQwwCh0TbOxEotWu3yONcTcRoMG8NO++T8Hhv5FVrpSaQ8yqDNUHL0V7IDihj/mYHyXPBX67eM6JemP8sloRY0MgdITzfJEq00z2ldbmQDHVUi9nxwRvlhvV7cyVBgz0HZFIhpCOWNEZflpp+LV/jNU5SljPin3qy3nv2a/oLcdKO9LUfuoiLM9ahCMvDKV0oS5Wh8Xi0qZA06R7H9J18a2dO570P0AT5dpBhGVd/7yYz13t8mETVkvBbI1IG1ddOONKHvZeaw2t5iL5gQ7x2UqQMVoNB3L36vMY5+EAOI2F+uWEAHHfAU43Xd3GmU0JUlf8Trn3gblNIncX33JIrCTgiuCGBeckURhBVLtQv0p3rFckN+UmojDPln93cenX5S+usXIawaxDwB+rOMMjnZ4vij7om9zwmBengW0DuhrRiej8ITIPfvZ3sc8wivfAwhGtor+A/dDCFnkVrdggIXf+0MzKfskhVlM35dXUW6bQdPQAjp2EVr8BJjGnNthg/BABZnVaWBiBcOQkCjdkp9fF1H+8Ht9W0VjUMA5KDzPZ11ZouXzYP/OjPDiQSjfvqvfzr0h0n+TmkzH5/hSQbkOXJXRqZQ78yP5RvgYtx5//9mm6xUVc48R/zd3dO45gjcZQ7X2ozaByRUz/pzdYRnN0bMMtk5VrS2kwVTcXegwU63326vWcLhULBTYH3lc/Z/h5Zh
 3A6gHagS
 dEKy7FqFj/cLkfM+bPVGy0JBh+lTp3/z2bdmTi/zBDkTPqQ+gOmCvaqRKh99IUQdqmKcWiXtwd9NjKmGhdZ6qCCEMLOS1UKRfC5XquGnOd34wxvl0Ymn4NjKSQe3rW5hJTihyhDJzT90LKVEKQPvaszXlGusE0Vftn6f6+s/Nc7BXbICOlzfDhfvdsaMCKcRIMLRgpG96v/4D/613rHDDAaeZXrK/dMaZyQqcDjfF+bhZ50VAXZrELXvl/boYmC61VaDPWppbAGGAJwlQlLOgZ6JVpcwjjmnE7KcDUwoYzZK0h7ZFodJmEUJafLb417YHKGtg+MEfRPakOyiPo7caonj2Fo3gnzGDY1lXS+xAbxzpn73zvXtDM7N7M6Z8BhD6VWodoBunEyHN3tMjlu6uLyel51EuGzHUvjSGrouENJCXsWn9aAjdoUmobNqRzPhSRkoyLGLfa6aR35PEsXjUT9ParH7J0gV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    b84a0ebe421c Add linux-next specific files for 20260313
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=119ddd52580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e7280ad1f68b2dce
dashboard link: https://syzkaller.appspot.com/bug?extid=de14f7701c22477db718
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=173b44da580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1537b8da580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/09145161a8a9/disk-b84a0ebe.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b64c254e474c/vmlinux-b84a0ebe.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a7c33f5f7f45/bzImage-b84a0ebe.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+de14f7701c22477db718@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 1 UID: 0 PID: 5994 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
RIP: 0010:folio_test_anon include/linux/page-flags.h:718 [inline]
RIP: 0010:zap_huge_pmd+0x7b1/0x1030 mm/huge_memory.c:2463
Code: 08 00 00 e8 11 e0 92 ff 48 c7 44 24 10 00 00 00 00 4c 8b 3c 24 4c 8d 75 18 4c 89 f0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 4c 89 f7 e8 f1 43 fc ff 49 8b 1e 48 89 de 48 83
RSP: 0018:ffffc90003bb7550 EFLAGS: 00010206
RAX: 0000000000000003 RBX: f000000000000000 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000003
RBP: 0000000000000000 R08: ffff88807cc9802f R09: 1ffff1100f993005
R10: dffffc0000000000 R11: ffffed100f993006 R12: ffff88807cc98028
R13: fffffffffffffa00 R14: 0000000000000018 R15: ffffc90003bb7ac0
FS:  0000000000000000(0000) GS:ffff888124ee0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000000000c0 CR3: 000000000e94a000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 zap_pmd_range mm/memory.c:1990 [inline]
 zap_pud_range mm/memory.c:2032 [inline]
 zap_p4d_range mm/memory.c:2053 [inline]
 __zap_vma_range+0xa82/0x4bd0 mm/memory.c:2093
 unmap_vmas+0x379/0x530 mm/memory.c:2162
 exit_mmap+0x280/0xa10 mm/mmap.c:1302
 __mmput+0x118/0x430 kernel/fork.c:1180
 exit_mm+0x18e/0x250 kernel/exit.c:581
 do_exit+0x8b9/0x2490 kernel/exit.c:962
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1116
 __do_sys_exit_group kernel/exit.c:1127 [inline]
 __se_sys_exit_group kernel/exit.c:1125 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1125
 x64_sys_call+0x221a/0x2240 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdd0b39c799
Code: Unable to access opcode bytes at 0x7fdd0b39c76f.
RSP: 002b:00007fff630f1d78 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fdd0b39c799
RDX: 0000000000000064 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000003 R08: 0000000000000000 R09: 00007fdd0b5e63e0
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fdd0b5e63e0 R14: 0000000000000003 R15: 00007fff630f1e30
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:folio_test_anon include/linux/page-flags.h:718 [inline]
RIP: 0010:zap_huge_pmd+0x7b1/0x1030 mm/huge_memory.c:2463
Code: 08 00 00 e8 11 e0 92 ff 48 c7 44 24 10 00 00 00 00 4c 8b 3c 24 4c 8d 75 18 4c 89 f0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 4c 89 f7 e8 f1 43 fc ff 49 8b 1e 48 89 de 48 83
RSP: 0018:ffffc90003bb7550 EFLAGS: 00010206
RAX: 0000000000000003 RBX: f000000000000000 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000003
RBP: 0000000000000000 R08: ffff88807cc9802f R09: 1ffff1100f993005
R10: dffffc0000000000 R11: ffffed100f993006 R12: ffff88807cc98028
R13: fffffffffffffa00 R14: 0000000000000018 R15: ffffc90003bb7ac0
FS:  0000000000000000(0000) GS:ffff888124ee0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000000000c0 CR3: 000000000e94a000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	08 00                	or     %al,(%rax)
   2:	00 e8                	add    %ch,%al
   4:	11 e0                	adc    %esp,%eax
   6:	92                   	xchg   %eax,%edx
   7:	ff 48 c7             	decl   -0x39(%rax)
   a:	44 24 10             	rex.R and $0x10,%al
   d:	00 00                	add    %al,(%rax)
   f:	00 00                	add    %al,(%rax)
  11:	4c 8b 3c 24          	mov    (%rsp),%r15
  15:	4c 8d 75 18          	lea    0x18(%rbp),%r14
  19:	4c 89 f0             	mov    %r14,%rax
  1c:	48 c1 e8 03          	shr    $0x3,%rax
  20:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  27:	fc ff df
* 2a:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1) <-- trapping instruction
  2e:	74 08                	je     0x38
  30:	4c 89 f7             	mov    %r14,%rdi
  33:	e8 f1 43 fc ff       	call   0xfffc4429
  38:	49 8b 1e             	mov    (%r14),%rbx
  3b:	48 89 de             	mov    %rbx,%rsi
  3e:	48                   	rex.W
  3f:	83                   	.byte 0x83


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

