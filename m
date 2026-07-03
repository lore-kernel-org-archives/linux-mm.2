Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE38EC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 07:03:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D52F6B00B5; Fri,  3 Jul 2026 03:03:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 886706B00B6; Fri,  3 Jul 2026 03:03:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79BA26B00B7; Fri,  3 Jul 2026 03:03:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 451356B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 03:03:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD57A1A0462
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 07:03:33 +0000 (UTC)
X-FDA: 84946574706.03.70A0D74
Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	by imf28.hostedemail.com (Postfix) with ESMTP id 16F6BC0006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 07:03:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of 3w15HagkbAPYqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.78 as permitted sender) smtp.mailfrom=3w15HagkbAPYqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783062212;
	b=7RizcrXPxepmwRhIejkzfL605sX1uX1jFs1WO2uWwsN7uIjN/9K+3XayTM4GXGoIQiYbmG
	4Bam1SbrU9HLW1+A4El+1QEP3bX97FuPlNZ7/S6ptzsGxpF2tYfd1xB0fdRu60oiDaWnzr
	GZzromacoPSeyCjWhyOLn1KeKl7pEUg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783062212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=u0oqcBlSmLAPJh4Lig2GODnq3S05p+UkLPiMOHCs7Sg=;
	b=vB03GocMufD2fPeID0NlJPWUDBYUQiZBttNKrHmSir97vUbAtatIBfsVz3RSRyKMQPRdAv
	DBIx9rpYtaadfq+cfzxl2wsc4l+GcvzpMGrnqGt72hwIrZCumW7jAVpUR/kYjKzgt0OH8b
	JkMjjrpd67fIfjtK4J/fPiB5D4ie4gQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of 3w15HagkbAPYqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.78 as permitted sender) smtp.mailfrom=3w15HagkbAPYqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7e9fbcd3a0eso231772a34.1
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 00:03:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783062211; x=1783667011;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u0oqcBlSmLAPJh4Lig2GODnq3S05p+UkLPiMOHCs7Sg=;
        b=jkVaJZEdpc8aE+jR3hbJN/75vHhiX114UXidovz7ToXvv/ILHRP9xHgCGxt9GxsdKC
         /VRlGhGMHZnc1TktKbxkI+FNL03JJIgYJn6J33p6rV05REM2wI42JiKlwY3lFnCW6D95
         WAnPLDK1dToBczluK8o78iRMFdwM9ClUdWp103k83wwOysDHBt0OMb2TO3CT9ifYhUyH
         GryIOuoLEc53K7A8SleN5tzyFNMRmKydGmQWVxal6rv2wyEDOaysizOQ0zvbGlgNOUkC
         1u+0dBaWMO8wJo80u6GasuG42YTN/2bqrkJy5siUJjWSWRwQ4Bm/NIzn6XCup3ujk5Xl
         YgOA==
X-Forwarded-Encrypted: i=1; AFNElJ+RvIyKyRFfUK/VHjjXObwmtZLqSlUgjQP19x8uimYru/KlBEn5yih00sFDX/8V5voCynaaOuAn8w==@kvack.org
X-Gm-Message-State: AOJu0Yw69oOhfoS0aZoYuT8g0xCDGhkgQeoSuedOxX8Q0gnVohkG0gZV
	CAoKxyAfjbSxUbMoL2YC3cG5yRt3pEtGZyrCFqxbtP7XdcpijNWvV4xvV/GwgqZodX2FLr7dmzk
	+E9Ouvq8Tk6imuDc+TxxrBr7RhiK8+SvkmBesznMMvGRhiKD01dx5asnJkZA=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:622:b0:6a1:50eb:2117 with SMTP id
 006d021491bc7-6a30d8fb717mr5126658eaf.59.1783062211048; Fri, 03 Jul 2026
 00:03:31 -0700 (PDT)
Date: Fri, 03 Jul 2026 00:03:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a475ec3.6912059f.e0473.000a.GAE@google.com>
Subject: [syzbot] [mm?] INFO: rcu detected stall in unmap_region
From: syzbot <syzbot+2ad5ec205a38c46522b3@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jannh@google.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	netdev@vger.kernel.org, pfalcato@suse.de, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 16F6BC0006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: xdeoisx5eeyscuezatzyagd19iu79ru6
X-HE-Tag: 1783062211-819004
X-HE-Meta: U2FsdGVkX18FiVYfgLHapabXT+w0lA0JQ7MBFCwZRCCLESV5eYJbXrv8p3fU+KV+b96pcqQ1VlbMWJH/XV1iNWPKil4FZqcIO8o061nqSnmg10Dy0eFDqAYqA/W9iJ4mxu8zbEJBSwota3ohSGIdI1SUVU+qPqDpwk94rGkzMLTLHAbbcx+9cCvNFCjy1SRUk4M8Cq4Ci7TKL+Dpq11Z0Q4wetKP22tayfvvNYsUTmAy8FCficmo2KyXQIG9ebJW/o6ltQvvkI4s5h1hCuCFaUXJSFOEH+kTi8vNX+wGsR/YfgoDN0wFZJhg/ldQqe03kPpnuVq3rNwOPB+w8L526O4raTHN0dold7q3nOgu5o2TAzCfK1dRHL2gdBtUp1x5WbuDFveaNLBkw0pGV6VdE4W0Kn1C+1pHZK5wDHibI3WqgGa0SMOw4vz6723j5ffHA+MfuS7yrVtTqfcF8ialUiL8RWC6KqdI7qA8NCxNmYvkCcgW95ZL3NGDwgbBoyp6ndU/iX7Mt55dD8uaE655t5CJULHUN0lbU8zVBPG8A7f3OwInI7CtB4tkn6j+H1fEg8yETOgA8EBtBUykKwTCEbsOv5jxnU5apj1PiFaOGxwWtEnwnxZSmuOFRegTSVOa/KV4+k84jd1F2NLxdE3zmNOXNFxUAGzHPEGtzOqgFyxjBm5HPsEEO4cpBSvycLFsrOMaqIg9qnMxnuwJVLcJBh2DHeQTOS1NdtcfmBQ54czvn2Z7yTWDZi+EnQ633+eslsmGDrnDQ0To6dUbfc9BffApdy3+rojAqDB2lLOYgF/8YQEa9+iCkQVK5quyLnxKVcN6t9pO3TS5fBYVK9qRZ2WMuvc4e4mjSKqlcesgVOtDz0Aby/7rnRlQ3u6ozILdbrWW2imwBnYgi1mb+HOkVT27+t8qzVvGb0WH7P8g132pauiAhR3RPAqW/rSOU8YcNpiyPBvw9b1WL158Ry+
 vSV5QIcC
 1xXAVYXA0vRHTZstT0kZ/NKlZyjjYuAnH8tPBPfSieOntP3nQvRlkhSGDoU20ZKHxbxDTiP2aJSneP93Xn4KSUBDhuSl1XbAs+vycVS1wTJcvIhMGQL0uVQ4i6Boue85e/AURuMQH2FQV3fna77wT85CTOO3g6ZeyXYhvt/lfnRrEJVg08q1GvbL/8hW8eQXRAdyjSjm1yerLb7cXiKwk3osFJaatcnn5WF8upMMfvEvDxSG3wsfzDpn/YkAA0lQ/rFrBJenIATbocN5M9YmFDcLChHli+JxWgQrD8QIVc+5JPfbVLw8NGaCnQfj0xYCwM8xR67F4KgtroizrVqWXahhSqey5By/2kgl+rTXs4VnHxdupyaR9w+JK5UGWb1Pei40/qgyQn/TGdEcX3NOqFMPvJJi08zThimcyRBPgx+h6ppwcubIQuXZkw4RvAx2boUHt5QwLSwGdN3IArXOKbAg02Rxq9I/XK9yRR98SzzAzyOticJZNMGMeTaMnDeGsNe3YYN1OqXCb0k0jc5mWXAQR+JY6FE7VsRMBBbCPPzVedw/pZD3d7ouKFrBiZb1FluyB6rHKzxqTzY9bp+NP5Mhw0Q0/qoNBN6JS1fmkrAKS9odTJxQj8k0zy7M05etuSVSo8mnX/S3ssZhveQTq/rpOUX6YlI+Yvx4Tt+A83XgJ8b3OUjiiScZbs71mZDeVBLpzKhLZL4N6sYrxULab4EiXngR+PnHlHa83r4NSFfxTUBkVxJkrpOfoNoLWD1AgAE1KowyWvKXPwEPrjuhFbsLQAUOQnEj40+mZhNyFReHLOHXhCH/hOpo0bzgHiCdATkLdKkmRsUtTVXPcJfYlb3a2wGTh69pxgRe8/ZqWJTlukAe32UQeCXApBxD12Xh6OQzi2mhweN1yokPlH0b6TAdOhbT1dCEcuUlVa9REizMccbRnb2cELuWkurQlTHF2bSoW9d78f+Btot2+or9dPaHcMMNz
 dkmZHnXn
 /T55zQkdpdzMVuvcM6sofHxSZjnMM0sAPdnfpXT1esqsnokwgohT0gzPdwgBjS5TztSDVW5U/SuYGosbzIn0rXgNmAlWI1qHkcFDPTb1h7UYwLRTaCQ6c+7iPaRpwqqfImYOTRRNMJWbNgUPSamoo+LkePJvJuom7XaGmLXCCeQxxWkLPHk8uSsGszuD0P8FWw0txmr/RlNeYBNfnpa6FS9GjKtA8PS8P3360gxOOlVy4jqSAl6CeCJlH0aT0uvm8QKS++kvgR2N/GCfk6P2duy8xoFKz1qxAdqaLsbSKAUXlFqAcGxUnArYwbs1A33rqPu0bIl8eEUctcoxfrupJY8fk9wbXyudkU8GrYJbvf8dD/Pmxj26bphiNFJ/1edybPrVl4pv9dFFKZ3Ss5sCEkhT4hiWVHBR3KaCJrDeSKt/QdPBz8Zee8B01hH5sC6jDQYT2x74k2s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    32f1c2bbb26a net: airoha: dma map xmit frags with skb_frag..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=116c2c0a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=86ba763b42fa66a
dashboard link: https://syzkaller.appspot.com/bug?extid=2ad5ec205a38c46522b3
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=132f5861580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7b7c3a22a8ed/disk-32f1c2bb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/168b43c87305/vmlinux-32f1c2bb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/70704720d284/bzImage-32f1c2bb.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2ad5ec205a38c46522b3@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	0-...!: (1 GPs behind) idle=6664/1/0x4000000000000000 softirq=17730/17732 fqs=2
rcu: 	(detected by 1, t=10502 jiffies, g=17101, q=1895 ncpus=2)
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 6010 Comm: modprobe Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
RIP: 0010:lock_release+0x5/0x3c0 kernel/locking/lockdep.c:5876
Code: e9 4f fe ff ff 41 bf 2f 00 00 00 e9 06 ff ff ff 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 55 <41> 57 41 56 41 55 41 54 53 48 83 ec 30 49 89 f5 49 89 fe 65 48 8b
RSP: 0018:ffffc90000007db0 EFLAGS: 00000082
RAX: 932ea09fa7cced00 RBX: 0000000000000092 RCX: 0000000000000002
RDX: 0000000000000001 RSI: ffffffff81b30e19 RDI: ffffffff9a73d4c8
RBP: ffff88807e29b300 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000000f98 R12: ffff8880b86281c0
R13: dffffc0000000000 R14: ffffffff9a73d4b0 R15: ffff8880b8628350
FS:  0000000000000000(0000) GS:ffff888125226000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffae81e84e8 CR3: 000000007ee52000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:176 [inline]
 _raw_spin_unlock_irqrestore+0x1b/0x80 kernel/locking/spinlock.c:198
 debug_hrtimer_deactivate kernel/time/hrtimer.c:490 [inline]
 __run_hrtimer kernel/time/hrtimer.c:2000 [inline]
 __hrtimer_run_queues+0x239/0xa10 kernel/time/hrtimer.c:2096
 hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2215
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1068
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:do_zap_pte_range mm/memory.c:1819 [inline]
RIP: 0010:zap_pte_range mm/memory.c:1934 [inline]
RIP: 0010:zap_pmd_range mm/memory.c:2020 [inline]
RIP: 0010:zap_pud_range mm/memory.c:2048 [inline]
RIP: 0010:zap_p4d_range mm/memory.c:2069 [inline]
RIP: 0010:__zap_vma_range+0xfbd/0x4f10 mm/memory.c:2109
Code: 4c 89 64 24 30 4c 89 e6 48 83 e6 9f 31 ff e8 3a 4a ad ff 4d 89 e7 49 83 e4 9f 75 2f 48 8b 44 24 10 4c 01 e8 48 83 f8 01 74 28 <e8> 3e 45 ad ff 48 83 c3 08 49 ff c5 4d 89 f4 eb a3 4d 89 ef e8 2a
RSP: 0018:ffffc90003287000 EFLAGS: 00000286
RAX: ffffffffffffff73 RBX: ffff888034e9d190 RCX: ffff88802dcf1f00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc900032872f0 R08: ffff888078979803 R09: 1ffff1100f12f300
R10: dffffc0000000000 R11: ffffed100f12f301 R12: 0000000000000000
R13: 0000000000000032 R14: dffffc0000000000 R15: 0000000000000000
 unmap_vmas+0x390/0x550 mm/memory.c:2178
 unmap_region+0x208/0x330 mm/vma.c:488
 vms_clear_ptes mm/vma.c:1303 [inline]
 vms_clean_up_area mm/vma.c:1315 [inline]
 __mmap_setup mm/vma.c:2476 [inline]
 __mmap_region mm/vma.c:2756 [inline]
 mmap_region+0xc62/0x2310 mm/vma.c:2860
 do_mmap+0xc3b/0x10c0 mm/mmap.c:560
 vm_mmap_pgoff+0x272/0x4e0 mm/util.c:581
 ksys_mmap_pgoff+0x4dc/0x760 mm/mmap.c:606
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ffae8219242
Code: 08 00 04 00 00 eb e2 90 41 f7 c1 ff 0f 00 00 75 27 55 89 cd 53 48 89 fb 48 85 ff 74 33 41 89 ea 48 89 df b8 09 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 5e 5b 5d c3 0f 1f 00 c7 05 46 40 01 00 16 00
RSP: 002b:00007ffec64cd428 EFLAGS: 00000206 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007ffae7f73000 RCX: 00007ffae8219242
RDX: 0000000000000005 RSI: 000000000014e000 RDI: 00007ffae7f73000
RBP: 0000000000000812 R08: 0000000000000000 R09: 0000000000028000
R10: 0000000000000812 R11: 0000000000000206 R12: 00007ffec64cd478
R13: 00007ffae81ed5f0 R14: 00007ffec64cdc60 R15: 00000fffd8c99a88
 </TASK>
rcu: rcu_preempt kthread starved for 10477 jiffies! g17101 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=1
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:28192 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x17d9/0x56c0 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 schedule_timeout+0x152/0x2c0 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x30c/0x11f0 kernel/rcu/tree.c:2123
 rcu_gp_kthread+0x9e/0x2b0 kernel/rcu/tree.c:2325
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 1 UID: 0 PID: 4992 Comm: udevd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
RIP: 0010:csd_lock_wait kernel/smp.c:342 [inline]
RIP: 0010:smp_call_function_many_cond+0x10b0/0x14b0 kernel/smp.c:892
Code: c0 75 73 41 8b 1e 89 de 83 e6 01 31 ff e8 d8 1e 0c 00 83 e3 01 48 bb 00 00 00 00 00 fc ff df 75 07 e8 84 1a 0c 00 eb 37 f3 90 <41> 0f b6 04 1c 84 c0 75 10 41 f7 06 01 00 00 00 74 1e e8 69 1a 0c
RSP: 0018:ffffc90003837580 EFLAGS: 00000293
RAX: ffffffff81ba5717 RBX: dffffc0000000000 RCX: ffff88807e5a0000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc900038376a8 R08: ffffffff9032d2f7 R09: 1ffffffff2065a5e
R10: dffffc0000000000 R11: fffffbfff2065a5f R12: 1ffff110170c85fd
R13: ffff8880b873c448 R14: ffff8880b8642fe8 R15: 0000000000000000
FS:  00007fdd3255d880(0000) GS:ffff888125326000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002c919703e000 CR3: 000000007e7f2000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 on_each_cpu_cond_mask+0x3f/0x80 kernel/smp.c:1057
 __flush_tlb_multi arch/x86/include/asm/paravirt.h:46 [inline]
 flush_tlb_multi arch/x86/mm/tlb.c:1361 [inline]
 flush_tlb_mm_range+0x5c4/0x1090 arch/x86/mm/tlb.c:1451
 dup_mmap+0x1786/0x1d90 mm/mmap.c:1905
 dup_mm kernel/fork.c:1538 [inline]
 copy_mm+0x11a/0x480 kernel/fork.c:1590
 copy_process+0x1e99/0x43f0 kernel/fork.c:2288
 kernel_clone+0x2d7/0x940 kernel/fork.c:2747
 __do_sys_clone kernel/fork.c:2888 [inline]
 __se_sys_clone kernel/fork.c:2872 [inline]
 __x64_sys_clone+0x1b6/0x230 kernel/fork.c:2872
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdd31ef1636
Code: 89 df e8 6d e8 f6 ff 45 31 c0 31 d2 31 f6 64 48 8b 04 25 10 00 00 00 bf 11 00 20 01 4c 8d 90 d0 02 00 00 b8 38 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 52 89 c5 85 c0 75 31 64 48 8b 04 25 10 00 00
RSP: 002b:00007ffcd95f6670 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007ffcd95f6678 RCX: 00007fdd31ef1636
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000001200011
RBP: 0000564712dd5910 R08: 0000000000000000 R09: 0000564712ddd8e0
R10: 00007fdd3255db50 R11: 0000000000000246 R12: 00007ffcd95f6a30
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>


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

