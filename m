Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72746606A330
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 22:22:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 698116B00EF; Sun, 15 Nov 2026 17:22:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 648646B05B0; Sun, 15 Nov 2026 17:22:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53A166B05B2; Sun, 15 Nov 2026 17:22:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 195316B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:22:40 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2183780876
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:22:39 +0000 (UTC)
X-FDA: 85438778838.13.581D665
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6943920009
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:22:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of 3rDD6agkbAFUFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3rDD6agkbAFUFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794781357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=j48R735f118eJ59p+9MBsl6aHMwkGoc0F1+DYRBFwdk=;
	b=w3lWNxWzbbYa1ctOZmpSUS4bBrXRQxXUYb/z/NIqqjONt3wee+dCaCRx/spA98oSrF45wn
	+aUz4M81xDCDefwykZwUgEoUhu25ih3Edvw40AuAwu3IQF3VygB+OVLG6/x25P8ri8p4/2
	EW7ZyJ2m+dt509+VLRw/DjWPioaW3UQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794781357;
	b=GIIrLJS/cuV/hmG4OmAmd3tkXlYj7vrfxNgv6zPJ8uBDLXDNLOxWFC/ciupzFL/Ok5Ye93
	wchVRuqXG86v7YKvCnGirUmzluSsgLeut6UWB477MIMyu+7rktHlK7971kuHQc7yrRKc5n
	TDVxJFYsCG5etU+2T+BE5+rgLswI+FA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of 3rDD6agkbAFUFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3rDD6agkbAFUFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-71ad7f06ab4so1274881eaf.1
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:22:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794781356; x=1795386156;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=j48R735f118eJ59p+9MBsl6aHMwkGoc0F1+DYRBFwdk=;
        b=Kcu8bR/vBvsw/3xvDJ+hiJcsAo1UDYLRnuFHSirS5I4FuU2n9mNJRmXkh33V5yEy8C
         7Xdo7z0N6DUpFCB+8W65/WGMNc0QAUopnb6QbHTAzHYbFsXu9pqLLVsE9C+Pjh+yZZQS
         05GCHKAMhE+1AQyhxf+yaq+M1wALsu/ya71N2DT7CgjHZaWHFnQm/cxPisWa4zRml7wE
         Am7MK1ff8r/C1hBvcmK/FLzoqvGufC5HCkcWMIH0CaSx/bOP6Fx3JsYCLbDEiZUCjG40
         TO7187XJy41Vgw+XRcWwTgKod0UoBcWp4bUt2gE9Qf9tgF468EM+KAxZ95IMsbpKl1KD
         a4Tw==
X-Forwarded-Encrypted: i=1; AL+hErEgWhJYs3XzH1/edLSj+V1zcOSP5eMuZMccYB447JzGoCp1MgL4cGSzqTGyIh0+YnxvRgJphmIqeg==@kvack.org
X-Gm-Message-State: APuU4Z/4UE0HEVVjFH0Ai1xo5eY5AWtLgbtlSFVY8wZ4IUP1mABSb0Ot
	nzm8juLc6l1wV2j8PEKDsHh5Eai258Ai2w05vkuokIK4mDcByX69T5U8cmXRthsUGd9ACu1d2+N
	crtNWDoaiWP8QZMH+6e3TN6NzJUr+R2yB0tc8TwzNw+nU8PD+DxEPxO8CinQ=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:c44b:20b0:71a:f794:49cd with SMTP id
 006d021491bc7-71af7944c7amr136480eaf.65.1794781356552; Sun, 15 Nov 2026
 14:22:36 -0800 (PST)
Date: Sun, 15 Nov 2026 14:22:36 -0800
In-Reply-To: <674b53e8.050a0220.253251.00e0.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6afa30ac.920b2b3a.148c65.0047.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in sys_sendmmsg (7)
From: syzbot <syzbot+53e660acb94e444b9d63@syzkaller.appspotmail.com>
To: andrii@kernel.org, anna-maria@linutronix.de, ast@kernel.org, 
	bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net, 
	edumazet@kernel.org, frederic@kernel.org, horms@kernel.org, jmaloy@redhat.com, 
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	pabeni@redhat.com, pablo@netfilter.org, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, tipc-discussion@lists.sourceforge.net, 
	tung.quang.nguyen@est.tech
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: tr8shwrzjgsxkpzmigmfzj575483tuso
X-Rspamd-Queue-Id: 6943920009
X-Rspam-User: 
X-HE-Tag: 1794781357-361233
X-HE-Meta: U2FsdGVkX1/f7tzvA4Wmiju0m2SwhI1Bc+zPiMvJNDAyY061Q3aEhgWTz0sHHkus61XT+pSnlOM2WDIUek4ZBlLgVsyFY599MmouBe6Cz3dS2ZWAKh5hxoWXcHN01boSUn+OMhYKnhuGUkvB1k6DPtQ7FAcwoZl7owzk0Fntp0sXkdJIcDyTtO51PUPm0yaLRugM+MDzFaGfwfPErQM8lDc30ScPtUJMgEULbsxCB94mMbx946eOkqnWHn1YNkhhWWDRwYX1x5tKRUaZC0kniZLC4b2K2TeBS1E/tgR+G6WL6EQlF48muouq6+nR6Xxca+zD7sei/abm9DCSkMWR6jXtCDevsIS+yzK3zjXc5mNAPVWx1qQkQnwKEmrivoF9hiR3YekqC5gXbJ41zYnIja+tVx5iHFqCHDLtfrCy0jk1fRfXmMIVdIXXoCW5YpKQb/Yai0wbKPJarbs5Mi3EOH5GwVT+tH+bO92/EVXDrb2yepxaMoetWGLEn+rarz79A3cGwNsijYE+00F4vyGAhx8EGQyqpJi+h2VislBavvFTVubr+EJPwox3uWYOsf+jOA5ZvOcB2ZAXq1pNvF1pUoXvHUHgrwRLyrPY4yAEsqp2zs2DPcRPbRwW1fjlVsD4Riz9o9HY8lANY7Mk2cBOuejnAzSK+IOsbjvHOSN4KA+biUDuBKD53Vudb0F5d3I4yCMuOIuBPQLkeET4ljCrSlmpPtXb0M88SQ/15EI3k34j7UKIJasztLBwhxXdXOMcXxxZpb/dlm5u/HeiLED64lC5uUxmGytOqpazwNH+n73zpggYI/uKJ8fb2KXiPKW/GRpUDQzNs5KUeAbWwXJovgLvbq+tnPvtF2NUnNEa9BA7TKDzqxzjASyixzlLC3CAA6M8QqZu9PSQQtOI8zhV5CS351r9gD8/B3ReSX3WMZPPNkXXqXw3VNdrgpnse0uUM1GGkiTlgdB9D3yStvi
 HSyLA/XB
 C9lkYLrc5RE8x0n04E/Lf83awVBO1jd90rbZpvlfo9PfuCHOCUcM7XpeLxLv+C+bWl5ZgC150QtYHrYqAIDwxcx94ILEWX5Z7yZBG4f0H9LkZ406zgAeo7q7ijrrFygH8EWUntzBKWeAoo08Pwso9tCAhuPdKf5OP7jbl+yKAlqJI2RSqPYIVPKrul1VfGdoy9bk5rZWmIAsD9kcEfPhlXzFgp8MMhPWAHq2i+aRxj7jMK5EQe+KVG2M67QjyrOGyefmU5wvFkUYmdHoqrV16VEQ5FzFYrXpcSiYMdMsMk8D5CjjIkviBqfC/qGbRmk2wg2fhcPjcNx3fiFZv1PV9IYqIhB4iJOmU23+d3qhJGKNEKDH8+gKt3WAcy8/ZWlVx7qCsP9EUfwxwJ5z1c+6hA3+92m6CBEyAycVLm9U2KaMHhohnM0k6qFJut3OfKI5QFkz2iIptg/XOaI1NKx2WrWi5xIJVWogEu3WhlW+bEO4myxKqHf3JCDyWt5eOvDD6p9SnfYvwS+O8rZwon4r6v8tOdu34idq0XF0GuaC/GhAtZnjIg4qOzrt8W0156HwEdYr6kpKYFvDqXYOeFqU2rx9HK+FYjtA9L84b0YFIAwAxXeO2VIWs5o3G19xTUaClkoKk0Q9ZwZV5NzUhwtJutT8tPAkmAAgdTO2WiFBMC7IEnWBNqBnKhxQ/JuXAyWwAB7v+zLP3XSfBvEuD+3dQWH2WumHF4SZwYuDwzTqP2/ADhe1Qj744P24PlfI4RD6XJawxTqYDBCf869LbIVVbEuu/BSQWL+LXDJkzarMP1A8mTkPSIrF+PC1q9qy87y+Y5MaXVqJ29T30O2/NhLncwBmHBscc50e9qEeJs7ud+1YOijsNSwjsM7KVCxLCMv5qkD4V5DM5lhSrt42BijDkA23oShSSeOvnVTSKU0yEaMSDseC49t8fptP886hCq5JbGlMsb3zWmg2UypYqg91SUVxZCySH
 N1vUSZer
 ZvqGnmJNRbj+aXkA9QH6YuDW0SWrBNoOspWuLPy53pLC1e7Z3o727vHZYZyjDULOvGgWQ/GzV6Bs7TxSoiTYNnqjL+h7osbfMmzwlhKDsrAd81wKLv6WL6OHn6izNZnajNnDsSMk+EBjvCCskbpGKh7E7ggCepMxEnzKjKRaaWAQbSSQLilRdvV/2c/ChbAcUHIX7oRZY2/yWLtYMfe9kafiPcUG9ECgYbzPOT9B+J84ykxqOs1nS5g8AxDodY+y8sxEYoy2/UG4RueNSDW8z5PK4CkpfsLViu4+UBqKHUt9W6OYkoyftr9BWa3i4aiR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

syzbot has found a reproducer for the following issue on:

HEAD commit:    ad3fc05c7e65 arm64: suspend: Only track cpuidle context fo..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1344e44d580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e8e6c1701ad8af2
dashboard link: https://syzkaller.appspot.com/bug?extid=53e660acb94e444b9d63
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16190411580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1730444d580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a30beb3b2b82/disk-ad3fc05c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2eaac3d8da90/vmlinux-ad3fc05c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/212a161a069b/Image-ad3fc05c.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+53e660acb94e444b9d63@syzkaller.appspotmail.com

watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [syz.0.42:5008]
Modules linked in:
irq event stamp: 7423
hardirqs last  enabled at (7422): [<ffff8000869575f4>] irqentry_exit_to_kernel_mode_after_preempt include/linux/irq-entry-common.h:511 [inline]
hardirqs last  enabled at (7422): [<ffff8000869575f4>] __arm64_exit_to_kernel_mode+0xe4/0x140 arch/arm64/kernel/entry-common.c:99
hardirqs last disabled at (7423): [<ffff800086954144>] __el1_irq arch/arm64/kernel/entry-common.c:566 [inline]
hardirqs last disabled at (7423): [<ffff800086954144>] el1_interrupt+0x28/0x60 arch/arm64/kernel/entry-common.c:582
softirqs last  enabled at (2824): [<ffff800084c751c0>] spin_unlock_bh include/linux/spinlock.h:407 [inline]
softirqs last  enabled at (2824): [<ffff800084c751c0>] release_sock+0x150/0x228 net/core/sock.c:3950
softirqs last disabled at (2830): [<ffff800084c894d0>] spin_lock_bh include/linux/spinlock.h:353 [inline]
softirqs last disabled at (2830): [<ffff800084c894d0>] lock_sock_nested+0x70/0x110 net/core/sock.c:3927
CPU: 0 UID: 0 PID: 5008 Comm: syz.0.42 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/06/2026
pstate: 03400005 (nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : queued_spin_lock_slowpath+0x138/0xb5c kernel/locking/qspinlock.c:219
lr : queued_spin_lock_slowpath+0x144/0xb5c kernel/locking/qspinlock.c:219
sp : ffff80009b9174e0
x29: ffff80009b917580 x28: ffff0000c8151d90 x27: 1fffe0001944c94b
x26: 1fffe0001902a3b2 x25: ffff0000c8151d80 x24: dfff800000000000
x23: ffff700013722ea0 x22: ffff700013722ec0 x21: ffff0000ca264a58
x20: ffff0000ca264a60 x19: ffff0000ca264a50 x18: ffff800123625000
x17: ffff0001ace95387 x16: ffff0000c8151d94 x15: 0000000020007000
x14: 00000000005e6a88 x13: 0000000000000001 x12: 0000000000000000
x11: 0000000000000000 x10: ffff60001944c94b x9 : 0000000000000000
x8 : 0000000000000001 x7 : ffff800084c894d0 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff80008697b308
x2 : 0000000000000000 x1 : 0000000000000001 x0 : 0000000000000001
Call trace:
 __cmpwait_case_8 arch/arm64/include/asm/cmpxchg.h:231 [inline] (P)
 __cmpwait arch/arm64/include/asm/cmpxchg.h:259 [inline] (P)
 queued_spin_lock_slowpath+0x138/0xb5c kernel/locking/qspinlock.c:219 (P)
 queued_spin_lock include/asm-generic/qspinlock.h:115 [inline]
 do_raw_spin_lock+0x21c/0x2d0 kernel/locking/spinlock_debug.c:116
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:183 [inline]
 _raw_spin_lock_bh+0x50/0x60 kernel/locking/spinlock.c:205
 spin_lock_bh include/linux/spinlock.h:353 [inline]
 lock_sock_nested+0x70/0x110 net/core/sock.c:3927
 lock_sock include/net/sock.h:1717 [inline]
 tipc_sendstream+0x54/0x88 net/tipc/socket.c:1550
 sock_sendmsg_nosec net/socket.c:800 [inline]
 __sock_sendmsg+0xc8/0x188 net/socket.c:818
 ____sys_sendmsg+0x3f8/0x6c8 net/socket.c:2715
 ___sys_sendmsg+0x198/0x224 net/socket.c:2769
 __sys_sendmmsg+0x204/0x580 net/socket.c:2858
 __do_sys_sendmmsg net/socket.c:2885 [inline]
 __se_sys_sendmmsg net/socket.c:2882 [inline]
 __arm64_sys_sendmmsg+0xac/0xc8 net/socket.c:2882
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x60/0x1d8 arch/arm64/kernel/entry-common.c:797
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:816
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:606
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 5009 Comm: syz.0.42 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/06/2026
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : should_resched arch/arm64/include/asm/preempt.h:80 [inline]
pc : __local_bh_enable_ip+0x150/0x234 kernel/softirq.c:480
lr : __local_bh_enable_ip+0x14c/0x234 kernel/softirq.c:478
sp : ffff800096516740
x29: ffff800096516740 x28: ffff800096516b80 x27: 000000007a3a32f3
x26: ffff0000dd3d8780 x25: ffff800096516800 x24: ffff700012ca2d00
x23: dfff800000000000 x22: 1fffe000191a6b11 x21: ffff800086493f3c
x20: 0000000000000201 x19: ffff0000c8d35888 x18: 00000000ffffffff
x17: 0000000000000000 x16: 0000000000000000 x15: ffff800080d84024
x14: 00000000027c6219 x13: 0000000000000001 x12: 0000000000000003
x11: ffff80008b386328 x10: 0000000000000003 x9 : 0000000000000001
x8 : 0000000002d1a4ce x7 : 0000000000000000 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000008 x3 : ffff8000801546f4
x2 : 0000000000000002 x1 : ffff0000c8d35880 x0 : ffff80012364b000
Call trace:
 __daif_local_irq_enable arch/arm64/include/asm/irqflags.h:26 [inline] (P)
 arch_local_irq_enable arch/arm64/include/asm/irqflags.h:48 [inline] (P)
 __local_bh_enable_ip+0x150/0x234 kernel/softirq.c:478 (P)
 __raw_spin_unlock_bh include/linux/spinlock_api_smp.h:237 [inline]
 _raw_spin_unlock_bh+0x3c/0x4c kernel/locking/spinlock.c:245
 spin_unlock_bh include/linux/spinlock.h:407 [inline]
 tipc_skb_peek_port net/tipc/msg.h:1235 [inline]
 tipc_sk_rcv+0x2ec/0x13f0 net/tipc/socket.c:2506
 tipc_node_xmit+0x1c8/0xb9c net/tipc/node.c:1708
 tipc_node_xmit_skb+0x10c/0x178 net/tipc/node.c:1773
 tipc_sk_rcv+0x11c0/0x13f0 net/tipc/socket.c:2537
 tipc_node_xmit+0x1c8/0xb9c net/tipc/node.c:1708
 tipc_sk_push_backlog+0x3a0/0x788 net/tipc/socket.c:1314
 tipc_sk_filter_connect net/tipc/socket.c:2260 [inline]
 tipc_sk_filter_rcv+0xcb8/0x1fa4 net/tipc/socket.c:2379
 tipc_sk_enqueue net/tipc/socket.c:2460 [inline]
 tipc_sk_rcv+0x5b0/0x13f0 net/tipc/socket.c:2512
 tipc_node_xmit+0x1c8/0xb9c net/tipc/node.c:1708
 tipc_node_xmit_skb net/tipc/node.c:1773 [inline]
 tipc_node_distr_xmit+0x264/0x370 net/tipc/node.c:1788
 tipc_sk_backlog_rcv+0x17c/0x23c net/tipc/socket.c:2427
 sk_backlog_rcv include/net/sock.h:1194 [inline]
 __release_sock+0x174/0x2c0 net/core/sock.c:3341
 release_sock+0x174/0x228 net/core/sock.c:3940
 tipc_release+0xca8/0x10d0 net/tipc/socket.c:652
 __sock_release+0xa0/0x1d4 net/socket.c:735
 sock_close+0x24/0x38 net/socket.c:1529
 __fput+0x338/0x74c fs/file_table.c:512
 fput_close_sync+0x10c/0x278 fs/file_table.c:618
 filp_close_sync+0x7c/0xb4 fs/open.c:1573
 __range_close fs/file.c:919 [inline]
 __do_sys_close_range fs/file.c:1003 [inline]
 __se_sys_close_range fs/file.c:954 [inline]
 __arm64_sys_close_range+0x898/0xbdc fs/file.c:954
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x19c/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x60/0x1d8 arch/arm64/kernel/entry-common.c:797
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:816
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:606

