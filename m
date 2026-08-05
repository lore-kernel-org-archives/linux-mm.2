Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BED5C55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 22:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBFA06B0088; Wed,  5 Aug 2026 18:45:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96EF6B008A; Wed,  5 Aug 2026 18:45:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5F06B0092; Wed,  5 Aug 2026 18:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF0AD6B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 18:45:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 206951C0BEF
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 22:45:28 +0000 (UTC)
X-FDA: 85068698736.12.E332708
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	by imf27.hostedemail.com (Postfix) with ESMTP id 778E540009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 22:45:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf27.hostedemail.com: domain of 3Bb1zagkbAKgaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3Bb1zagkbAKgaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785969926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=DFpyOldZEHF9Yg/Zc3gaa8k23ww7akWYZmJqKRrl9dk=;
	b=TX3XkprnEXlf1ORRDJqc8+W+QkoUvB9Rue8+H8qFJMKYG8jSGEIYm4sqeQnCa0kFemmLdp
	FzPJa1X9Q52K/Vi/ViEk3vtU0STPxif7z5Klyz9iC9yJwLzXmI/lOiOmY+FodTJB/OTyHK
	B4Qzl9xn+/1u1KmedeHuVPiPvOF1Q14=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf27.hostedemail.com: domain of 3Bb1zagkbAKgaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3Bb1zagkbAKgaghSITTMZIXXQL.OWWOTMcaMZKWVbMVb.KWU@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785969926;
	b=V2PXnCCAIzQpE9mpJwlzWn7wNgZFrNpVm9tLE3DgWOtKE940vpEW2O0e0tTGri95IJDm7m
	35Vj8lnnotv0BB9OgWgs3MEIgpGWps9UOLU0WeAf8ADDMbx2aNWGmjY+bnl4FNGWskT9OM
	pZWByBmAV8tHGA7b0+pCGg4RiJuJQlY=
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-6ae41d2af58so1197223eaf.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 15:45:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785969925; x=1786574725;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DFpyOldZEHF9Yg/Zc3gaa8k23ww7akWYZmJqKRrl9dk=;
        b=gYTusLqDmlmOlXG8EXHpF88SGrkecd9OlUH0PwwPoAN7Ib4lhp/aitIG9zaEFZtEF5
         1ckDJh9esdWDkIzZEM/sheEelqN6ojECCfkBbzTd9twdzHVhRHw1xQ7qnhqi21+iYgRo
         ORzMHpUkxeeRg31rg7eq7zxbU+mANvhDRiKiTscN3VM/F0kJU85+fewCDChoVpeugQm/
         +a1+PeJFY4c3BMVcz6a8bx4dJot5Zc/w38HlQyFBnZjbU3SqumRU7TIr+calIoSrEFbd
         EO2zphPPZVEGd0NS/kbabM1Gjd1kWANSh8z+tiKaIHe3gv2kOxzFRnDOJNmL8G5ObLW0
         zgag==
X-Forwarded-Encrypted: i=1; AHgh+RrhYcKAsKemWsemnPp8KzGXD8Lre8lcFzvE6/qhGr8kM4gm9cwCIfbvPcsB+BK6k4nGIkE6cV3Vmw==@kvack.org
X-Gm-Message-State: AOJu0YwwWTxb0cKRW4Yt9Aw+kQArdTsmZQ5oEY1yivJ+JbVJIhydBku1
	AkoZB37a6atGuYsu/kfXWgVxZu6DYUe5TRk4YEBsRaG8KjukRM8wM72TYOjkbhWwpU5wpixKXpx
	fWeoLdVRDO5KfHG5oygJRaNc6St+Oi/OzBVH/5rvoFLqYR5ehTdlUUEETVls=
MIME-Version: 1.0
X-Received: by 2002:a4a:ee0a:0:b0:6aa:f810:f579 with SMTP id
 006d021491bc7-6ae96c10190mr5678278eaf.4.1785969925419; Wed, 05 Aug 2026
 15:45:25 -0700 (PDT)
Date: Wed, 05 Aug 2026 15:45:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a73bd05.5aeeccc9.207e63.0004.GAE@google.com>
Subject: [syzbot] [mmc?] [mm?] BUG: sleeping function called from invalid
 context in mmc_free_host
From: syzbot <syzbot+0e06aa1bdc6495bac24b@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-mmc@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	ulf.hansson@linaro.org, ulfh@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 778E540009
X-Stat-Signature: mg5bayk7mzqp8dtnn8arg8kybwu7wmy4
X-Rspam-User: 
X-HE-Tag: 1785969926-141269
X-HE-Meta: U2FsdGVkX19kVbS/ds+DMwJ++GgQNoWtK5UVdqsZYRYxIO2l5JtP8zVZfgCMyg9ekQCJ+5VYew3aQWk4g7W3b3N8P4AXyNR1SIxqDGdtyUUzDqZwB4ncEQA2JgTaVJYQMYZYq8f+9FfCkV/1ZEl8QtVqY3cmFhHY9Uj46OeGIfneYZW9rZy49pUmwwoBcmaVr++E+o6sRm9ZR0iZaQ0LIh6xSfw9sgMPZeL2aXgA19waS/YbCsA62FNJEt5mVHUmdo46VzA4TaSi6japFBkyOgRsWfghHkqZXSFkVOEXW04iEV8UoaKoh7UvCq44BJsV5Qgk82c4q9MaD4K3hJ4xeCoKMgyYCumn/nfpPiG4qOOnZMUOMSvFSzmuEaRQwz/sEiDPj65alwLaelfcG6y13CZ3i7MZ0skAic1jprmtri4iDbx6rX48+BZj/9PNuBtuVCtFgw2e+Yf46+abMruNE9hsdsOBcwOocHrXNgA2FZmemALY8WZunA4ynktlf3zKcHtOWGZNIqiQJrJIuzGWwOSnyxFglb9GAiydsbX68y6MrPSyerdK6heBnarxLS1UFiHWmg47rCUx/oON0e8EJDrlmM/GuTWA7jy9WIBAUTrpjTFMqvyVuOa6QyIHfiq5diETPIWilOV5bpWjC6vqqN7mrsCjqkLjqJJiyS9JWnQ/64bEAOifY9E/dXYLtQnQZpAg+fJp9eKNBxRQrwacI6l7XG9+E4TUt9+8KLBYQL+slGyNw7EmQ2dgYCY8TxaLdN2vX5wfyj5ROq34gdtiOoXjoJN11e1k8ZHtAXyqqiIcERj7H0C9XUOR3KWXTDVHeYhSFhJmQh9ybL01U0xQqRM/3cTonuiIFQn7nud79yA79KZUbnlo19gtbElAGOkvdjd7aMfYhQ+qdMZ2Ey/kS7bNuRMAObtr4Cm0quAisZBFiu3gT2Jv7t4ITvJDkTgMrvQOxUS85xcPLJ+3qoK
 v8f6x60S
 ydgKemurqrREpR69AcyybN6CLGDuFaNR1WFsCAY/AeBGj1Q7+/5jvUxcuxtWGorlb0xCSEc7yzF0q80OOdj/6+OxDQngcBloRDJMQQjNKmuYxHOyhdqKNz7QNYXDuHn32So5yQkrhWGzGLp83ktRLBNJdcjuuxYBadNE31FEiOL091XO/u2okQEeFBU6vb3atL1i1QlGAHjLagoxJxfDN1NkW9fIEjNehK0iz4skBEs904mD5ng7AXi7yiAJJZ56lo6bNeQkd76Kav/gYI4PnzU5TXt+n4X9r6VqlwHLggThUQ9xPJ9rNg+fARpdJQP3MP+c31e/m9cTW1YNE4z5XFJVLhd9uIkFcqVmTWf+oAsOyzSz0WFydAf8AQNS+k/CqGCZKqSslM7D/knWbxgnAsWOSyrSsrnKqFWzkRQc1I/iWo9TXjL1Y9IB17hB/gITjDEgqReJxCP3EiYM8ZiP6hTuTzD8I0Engt/AOjg0AUDccS+SGGJnp25F2D/EvW3daw/RSRhlmaRIEUyX+Bdt/ssGt6t6U7zyeglYVEg6G1J1t2l4hxLJ2mQMPBPgStMP+ScZyvs6ujv3pD5CVcXXGom3v4bAOF34LEPN3tMRYJTvtQvqwDvwZiTP/Fqpv0pdc4y93njEBV0iv+gzc6hIjpsFtCKl9D+LeYIX9JqL6FwtMAptTD0kI20g5RqzYZeR61WgV60WIGjMJgp4DUMsMK5wzvPyN2YMmCkq+FkJxdqqFBZ5rjK/bo5yS8CziVa6YErt50Lxg6uf3c9SRqUo+9n/3l3o7jNS++z2f/HkvKCRcs6bce0FtkD7eWc/3TbSdwCmSXaqHfIv1nTUrgZ5oO9VROPyyiAorUsHUbOH2rd9mTXVr84hdocHkq6DV/AuUxK2T6xz/n9QPuJ04pK5387GADhbFjfzxkg+r/gJW+3K3bWIa/7XWL+PNLxWlumz8M0ZtDrxCh0CUQaKTMt4DNbK8DLue
 k2gO/B4b
 jrgoWGqw25M1pdqFHCEp9y/VGCsYzyt1KmXh9N5xHHgwVlJEox9dmX9YDBk18touWH6UrM79WRJuapkrFYthr9BG47RmrYhfypvc4pD8oFLsihpWYgJgfewEdo5FImn1ULpVBX+fR2+AFi1v6JpPaLpS5FY8DSDrGMQCEUCrA8N9FqvTdHmPcSqP12PjuFcA8XT7Ls7pRmwkTZ34k9PwYQ6t3Rk90kP5xD8FEtcImb4KKZVCP6PwEiWM/fYOgCFaWAr5WbmIpgZgnKEdRXc7LOkLKWf38YrS+YWwXz8b6udr8AS9Mu2/uqAzGrqOr4dnRIN2JYYmeeKDqefzDGkS7/C0YI4jrtnkrirMKyJ4P2wa4II2rZ/zUDlYCrpscBKf4Mw55uyN64i0Rx///8sS4o/9ob/1u8OQ2PT82i99d02ByzOTbtMEhGvZx1xA4UNSuVe1FU0dDrc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    848acc8ffe1b Merge tag 'fsverity-for-linus' of git://git.k..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=152c6cc6580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e38b15c29e6a1d9
dashboard link: https://syzkaller.appspot.com/bug?extid=0e06aa1bdc6495bac24b
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=132c6cc6580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11137649580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4949138dcfef/disk-848acc8f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/31cc6fbe5b8a/vmlinux-848acc8f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/433919ca6520/bzImage-848acc8f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0e06aa1bdc6495bac24b@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at kernel/workqueue.c:4487
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, name: swapper/1
preempt_count: 101, expected: 0
RCU nest depth: 0, expected: 0
1 lock held by swapper/1/0:
 #0: ffffc90000a08cc0 ((&vub300->inactivity_timer)){+.-.}-{0:0}, at: call_timer_fn+0xd4/0x5e0 kernel/time/timer.c:1745
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Call Trace:
 <IRQ>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:9197
 __cancel_work_sync+0x6d/0x110 kernel/workqueue.c:4487
 mmc_free_host+0x19/0x30 drivers/mmc/core/host.c:700
 call_timer_fn+0x192/0x5e0 kernel/time/timer.c:1748
 expire_timers kernel/time/timer.c:1799 [inline]
 __run_timers kernel/time/timer.c:2374 [inline]
 __run_timer_base+0x652/0x8b0 kernel/time/timer.c:2386
 run_timer_base kernel/time/timer.c:2395 [inline]
 run_timer_softirq+0xb7/0x170 kernel/time/timer.c:2405
 handle_softirqs+0x225/0x840 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0xca/0x220 kernel/softirq.c:735
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:752
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:64
Code: ac 7e 02 e9 93 06 03 00 cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d d3 3e 18 00 fb f4 <c3> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90
RSP: 0018:ffffc90000197e40 EFLAGS: 00000246
RAX: 000000000005e681 RBX: ffffffff819b5450 RCX: 0000000080000001
RDX: 0000000000000001 RSI: ffffffff8e22f174 RDI: ffffffff8c4bdd80
RBP: ffffc90000197f10 R08: ffff8880b87338db R09: 1ffff110170e671b
R10: dffffc0000000000 R11: ffffed10170e671c R12: 0000000000000000
R13: 1ffff11003c56000 R14: 1ffff92000032fd0 R15: dffffc0000000000
 arch_safe_halt arch/x86/kernel/process.c:767 [inline]
 default_idle+0x9/0x20 arch/x86/kernel/process.c:768
 default_idle_call+0x72/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:199 [inline]
 do_idle+0x2e0/0x540 kernel/sched/idle.c:355
 cpu_startup_entry+0x43/0x60 kernel/sched/idle.c:454
 start_secondary+0x101/0x110 arch/x86/kernel/smpboot.c:312
 common_startup_64+0x13e/0x157
 </TASK>
ODEBUG: object ffffc90000a08a80 is NOT on stack ffffc90000190000, but annotated.

======================================================
----------------
Code disassembly (best guess):
   0:	ac                   	lods   %ds:(%rsi),%al
   1:	7e 02                	jle    0x5
   3:	e9 93 06 03 00       	jmp    0x3069b
   8:	cc                   	int3
   9:	cc                   	int3
   a:	cc                   	int3
   b:	90                   	nop
   c:	90                   	nop
   d:	90                   	nop
   e:	90                   	nop
   f:	90                   	nop
  10:	90                   	nop
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	90                   	nop
  16:	90                   	nop
  17:	90                   	nop
  18:	90                   	nop
  19:	90                   	nop
  1a:	90                   	nop
  1b:	f3 0f 1e fa          	endbr64
  1f:	66 90                	xchg   %ax,%ax
  21:	0f 00 2d d3 3e 18 00 	verw   0x183ed3(%rip)        # 0x183efb
  28:	fb                   	sti
  29:	f4                   	hlt
* 2a:	c3                   	ret <-- trapping instruction
  2b:	cc                   	int3
  2c:	cc                   	int3
  2d:	cc                   	int3
  2e:	cc                   	int3
  2f:	cc                   	int3
  30:	cc                   	int3
  31:	cc                   	int3
  32:	cc                   	int3
  33:	cc                   	int3
  34:	cc                   	int3
  35:	cc                   	int3
  36:	cc                   	int3
  37:	cc                   	int3
  38:	cc                   	int3
  39:	cc                   	int3
  3a:	cc                   	int3
  3b:	90                   	nop
  3c:	90                   	nop
  3d:	90                   	nop
  3e:	90                   	nop
  3f:	90                   	nop


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

