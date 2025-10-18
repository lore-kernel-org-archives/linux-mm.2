Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A675BCCD184
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 05:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F5C68E0006; Sat, 18 Oct 2025 01:53:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A7088E0002; Sat, 18 Oct 2025 01:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BC788E0006; Sat, 18 Oct 2025 01:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3325B8E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 01:53:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A13C13ADD7
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 05:53:36 +0000 (UTC)
X-FDA: 84010168032.21.FF302FE
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	by imf03.hostedemail.com (Postfix) with ESMTP id C40AC20004
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 05:53:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of 3XSvzaAkbAM4CIJ4u55yBu992x.08805yECyBw87Dy7D.w86@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.80 as permitted sender) smtp.mailfrom=3XSvzaAkbAM4CIJ4u55yBu992x.08805yECyBw87Dy7D.w86@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760766814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=z/GRj617Cfvkfsc2fvmNusGhnDVIoFOb4MtIivd7Oy8=;
	b=LVBZaa9ntBSw2cREliycNRdlY+G+S7lkBCNTdFbRv3GdEYsOitUihtwLF7JZH9urJTFT7S
	hBTNrz0ObsGn4fXMP/cdKc72QfwlhYw1Pd6CKbDBQto9Cf+WWmYCi/OJ6gUrwAjTx3EWD9
	mh4gpPmErGrw4OlE2ZV7d9UCn/ZMCaI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760766814; a=rsa-sha256;
	cv=none;
	b=NmKzQ3ZjJyB6JYXLFM4zlST3BP2nnZQCN33UBCxEOeMSHLKEdmhFl+yswgUeXog3/KJDTX
	kDAzIzq/YXivu3nGidxRfmOgbPFJ33r+Dnu6jQqzYrxc5vltUMImzVqbzX3y1UMYZOqcin
	uhSsV5l+Ti9NgLNhp1Vn20SRebS6DTQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of 3XSvzaAkbAM4CIJ4u55yBu992x.08805yECyBw87Dy7D.w86@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.80 as permitted sender) smtp.mailfrom=3XSvzaAkbAM4CIJ4u55yBu992x.08805yECyBw87Dy7D.w86@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-93e86696bd9so67275339f.2
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 22:53:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760766814; x=1761371614;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z/GRj617Cfvkfsc2fvmNusGhnDVIoFOb4MtIivd7Oy8=;
        b=N1jJTk2clv8+n27VpDOd+Ly7aCLSUrJtSkHC0lFxYlv6e3YyfcGKyg4f4rDvtOqyZ4
         mfF/tv4hCNrwVvORXbAV9efIcMM4SVllmpTxHTIHOvs9JezQ8Xtw4xUYD89DzOrv24dD
         EsEnsto7eoSzFaIeDAaU2Yu4YVBoBk0USQDKHg5STOzzgPR7M+N4J3gEz+MEDGff3aNH
         UdSLy79HwD8NPzs98oQMAmhXAeQjWpAOxlZBFZ9CjAcxMlSJvog/OOQG7t+dVP4fBSBq
         lrrOtxyxtCAib503Awk0x7Lan5EzxQ7zQjdgYYb0dunJe67y9pH7Y6g7XUkGKSa6CgVc
         NSqw==
X-Forwarded-Encrypted: i=1; AJvYcCVM1yVu928s3+olYHd91jRl68giU8DeItVNMFEdwLeLgQYh2+rYUpALeKROQZiudhohaV4tnc18dw==@kvack.org
X-Gm-Message-State: AOJu0YykIjyFl/lrYtGwjr1PHIrwwejWQdznw1uZvCL8lq5RUJU0WwqG
	vP775ZQnweyXV4arBwDw5OV5O4UtuM76qrchQW3sxi0Tk1+7SxpljLW2vXu7wKwjxIO34oP5XB4
	bRDULcfMmNGttOA/T9ukbkU/Vqo5w24lWsaSRsOr20ZvX6XTSgQopgMAdxRA=
X-Google-Smtp-Source: AGHT+IElhltGiLsko8opmZStyEUHbYRepMEk8ZMccaPq7VeXFIuIUakGpUrNkGUrNbHb+mrWW4GUYQ6kYJkcvQEbYH1Ccp4mqfsl
MIME-Version: 1.0
X-Received: by 2002:a05:6602:29b3:b0:915:f0:58a3 with SMTP id
 ca18e2360f4ac-93e76437f51mr751969839f.15.1760766813811; Fri, 17 Oct 2025
 22:53:33 -0700 (PDT)
Date: Fri, 17 Oct 2025 22:53:33 -0700
In-Reply-To: <6840fdc4.a00a0220.68b4a.000d.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f32b5d.050a0220.1186a4.051d.GAE@google.com>
Subject: Re: [syzbot] [net?] BUG: soft lockup in sys_sendmsg (2)
From: syzbot <syzbot+4032319a6a907f69e985@syzkaller.appspotmail.com>
To: axboe@kernel.dk, davem@davemloft.net, dvyukov@google.com, 
	edumazet@google.com, hdanton@sina.com, horms@kernel.org, jmaloy@redhat.com, 
	kuba@kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, paulmck@kernel.org, peterz@infradead.org, 
	syzkaller-bugs@googlegroups.com, tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Stat-Signature: ph5918dd3qm7xdxtcrh37q3k78z3z68u
X-Rspam-User: 
X-Rspamd-Queue-Id: C40AC20004
X-HE-Tag: 1760766814-90597
X-HE-Meta: U2FsdGVkX19Ov7uwCPc+HTi2mBExAA8PP9M/oaVJnSHrmyA/uklqt21up25eUeh+LUPcx1ee5r3+1I57kHn6eMIC/khKRcxWgQ3W/ktTjg7s/jI2TBn+MYiUY0mbeh1Nv7gJecIIVatnuvrB6E0M1K8D0rYV96Knm+AlflfiLPq3w4DM2M5l788JyxdEGAp1MhC1KIbYnOdkhVnGHhAEfvWPqN/WR3VY60I4lsVBTUbSPsmz6tlEkrE+epBnrN1C3T5yjapRqr2dLidOtHj/9CV3Sbl0ppY1bRmZA14prVwIutOcnkAKa0sQhzjT6jr7eBFMr10JUQfG+Ws7FAFWQ26o1h1hjeYbdYT/JPommRdO5oJBZI0mMLrHBLFtC/CkDYTtEY/Xxk3ghLHTAV33RoYybulfpzI6xUyoM7JB3uWEG7GQg+eDH04l/1FeSypA4Qmzjw+raL7CXEEmqUCKl4P2QM7n4KsXFvxFhKUWkEf8aqg4a53W2ovoC8qzIC1o6JlRoCIIznHTD9XmlYJduHsF79Z3T9MTc74v5GpIFdBdwf3p4DzMfRNYvMqjVXH7KvxHrNa8kuVSBUHrCPwYcwGwAgeNxww9NBweBM4CDPcgL9E+lEFyyJoFw0fDqqc6v9cOgaRj6qABHNScTdYwn+t1Wr+vvgKGRaDIusZz9Per8MKg3g9jmOcSG6SBmn4YFuEoaXrwPtG9SS0yQhtEDoPkouu+EQJlUqd9fR9g+CaMzfQfWY8t/8N52fpqfsUs04iaZEmrrniXu9o4kmaOfkHsIJbHFyozPKP79pF9ui3XQKH/beIK5K3CfSG4YLbn3lxhJF01XKCCC1KthGaifhuBdoXmGei8SET1QiKghyBcLhGRcOUDqgQQozKsFHjifrfakJNnYBum4pQfPYwN9XOGOy9qHgw5Ah2v4VVzASKsHcA1sIiepaWjiSdAPIfY9umMESvuBB60Vjq/GRu
 1+Flz0cr
 g/Acw23h2zM8HcUTZvJ0tLY25XLo+Q89kHwU9GT11JCd0Gp5y3iQcxzHzcYj+SpeZhNY4+yWeu5RhlFelvpzf2SojUhFO77q6TidvnyKouRfXDiCqyRFCfRla0nMZk4hzbddKuMjVq9KZGkN3Qq7G49Y4fOOynsmiC/CycIhJIbxN3xBOHFE35VFJ4bCJoP7g34Q3XjV3PcEcI0PJ46sdkExnvJtYoFPNNtzQC8dL4Wnocg2/VUIwRE6o1wBzeiu/aJijvGivA9dMiX4iRe9CnPq1fFgmc28CzawvZkSkLsIkylShDF5oQV5xdB8ifJgo/XMK1vh7Zo4PlM1FnIn3d7B/XcwzgdLaIQwK+PrFc2d59U+CpZgZ3P4jh6mLEQXzygvmLgWp8CKoTFjUV/vHY9+D1XeqV46U7uWNjMxFyCJKkpIKCtTpVMC+944d45CCEVnoySGh/iDlEC/6+0WsMIN8lW2Ss0oYD3oqR1hG+4+idCqxL8lmSznVBIEie7v1wFIdY1A84CSR94/AOCLonhywHfKJGA50E6hVowXCY8u1OG1PJA6B+ilUPYTGwT5wbfknbMHsWgmMavOhwl+MUhoiZO7tKA2qkBtSVVvQBi9BJf/fc4/mHWQpdB2QTDr74b5uIEgE3Riet6U9VYFfnJCG4Uha0DVA9MqzZo/Nlav3vaf6qxPIthkEYOfOpY5+IR1KSOwD11dF63uNHWwVE1CDNlCEXNi1lduQaMcTwnsZ5AJBjnW+j/iBuhqSVQaIxp+GEu4S3k5psfFezOZyjhC8Y79LZCCqmsbpI4GE/IMzhup3XNEN7SVBfdCsvzn0f+dl2Kb/TCsMmOl6/4oeGaDn+30Jn0XkjiRbtZgxqvOuzgaG2Dw7MWZkqFxpYmINAUKoIGugwAk9r6zaz6B8GPFFxsnimJdlJ9kznD0kNSiWhZ1NZsF9LS4JReW1qy4k1ylBhwGkGwf4kRrlHRQCgt00HJMN
 3r1BXYs2
 s8LCkm0tCneFvgYQWPJoQbiHHU80gXgHYtv60crIPtQ3OkRhnX0htzH/OkWTux+fzX/bnyE2CZ5mHwPDDmeLxdYRqqrMOR8edFLc39wbQ+Mo147h7YbvQdNRqOCp/qcNbelUbT9zK3t107b/3L5n9sn8pa8aGrzZsz8dTbT67ki7zoMkeIFQfZwl+LZo2ylSIVv8EC3HBzdsN05ZH9SEIngsHiDLxYmVsU9u0TD1RXebBj1fcwHuGvSlWwN/0rrlnpPXif/xqLSw18vK47NhyVaaxBMWY0T7oYLWCUcqdMHsdM/2ZpyDCLinRlUvInTwcFe+qgIGgza2gqm6Ai7RkF7sMYEusUxLwAUjB2EQvrM3h3btJl+rP69XvXb9h9IpFraUlxjR/4CPzoXPZlMVgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    bf45a62baffc Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=15941de2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd2356106f507975
dashboard link: https://syzkaller.appspot.com/bug?extid=4032319a6a907f69e985
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1494767c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=126fdde2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f0d4874557e9/disk-bf45a62b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0bf44a13b5b2/vmlinux-bf45a62b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/18db8bc9907c/Image-bf45a62b.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4032319a6a907f69e985@syzkaller.appspotmail.com

watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [syz.0.76:6894]
Modules linked in:
irq event stamp: 5181
hardirqs last  enabled at (5180): [<ffff80008b064a14>] irqentry_exit+0xd8/0x108 kernel/entry/common.c:214
hardirqs last disabled at (5181): [<ffff80008b062af0>] __enter_from_kernel_mode arch/arm64/kernel/entry-common.c:43 [inline]
hardirqs last disabled at (5181): [<ffff80008b062af0>] enter_from_kernel_mode+0x14/0x34 arch/arm64/kernel/entry-common.c:50
softirqs last  enabled at (522): [<ffff8000892e0188>] spin_unlock_bh include/linux/spinlock.h:396 [inline]
softirqs last  enabled at (522): [<ffff8000892e0188>] release_sock+0x14c/0x1ac net/core/sock.c:3735
softirqs last disabled at (528): [<ffff8000892f4c84>] spin_lock_bh include/linux/spinlock.h:356 [inline]
softirqs last disabled at (528): [<ffff8000892f4c84>] lock_sock_nested+0x70/0x118 net/core/sock.c:3714
CPU: 0 UID: 0 PID: 6894 Comm: syz.0.76 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
pstate: 03400005 (nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : queued_spin_lock_slowpath+0x138/0xaec kernel/locking/qspinlock.c:197
lr : queued_spin_lock_slowpath+0x144/0xaec kernel/locking/qspinlock.c:197
sp : ffff8000a1a17600
x29: ffff8000a1a176a0 x28: 1fffe0001b9124c1 x27: 1fffe000196c6002
x26: ffff0000cb630000 x25: dfff800000000000 x24: ffff700014342ec4
x23: 0000000000000001 x22: ffff0000cb630010 x21: ffff0000dc892608
x20: ffff0000dc892610 x19: ffff0000dc892600 x18: 0000000000000000
x17: 0000000000000000 x16: ffff800080537d14 x15: 0000000000000001
x14: 1fffe0001b9124c0 x13: 0000000000000000 x12: 0000000000000000
x11: ffff60001b9124c1 x10: dfff800000000000 x9 : 0000000000000000
x8 : 0000000000000001 x7 : ffff8000892f4c84 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff80008b0885f8
x2 : 0000000000000000 x1 : 0000000000000001 x0 : 0000000000000001
Call trace:
 __cmpwait_case_8 arch/arm64/include/asm/cmpxchg.h:229 [inline] (P)
 __cmpwait arch/arm64/include/asm/cmpxchg.h:257 [inline] (P)
 queued_spin_lock_slowpath+0x138/0xaec kernel/locking/qspinlock.c:197 (P)
 queued_spin_lock include/asm-generic/qspinlock.h:114 [inline]
 do_raw_spin_lock+0x2a8/0x2cc kernel/locking/spinlock_debug.c:116
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:127 [inline]
 _raw_spin_lock_bh+0x50/0x60 kernel/locking/spinlock.c:178
 spin_lock_bh include/linux/spinlock.h:356 [inline]
 lock_sock_nested+0x70/0x118 net/core/sock.c:3714
 lock_sock include/net/sock.h:1669 [inline]
 tipc_sendstream+0x50/0x84 net/tipc/socket.c:1545
 sock_sendmsg_nosec net/socket.c:714 [inline]
 __sock_sendmsg net/socket.c:729 [inline]
 ____sys_sendmsg+0x490/0x7b8 net/socket.c:2614
 ___sys_sendmsg+0x204/0x278 net/socket.c:2668
 __sys_sendmsg net/socket.c:2700 [inline]
 __do_sys_sendmsg net/socket.c:2705 [inline]
 __se_sys_sendmsg net/socket.c:2703 [inline]
 __arm64_sys_sendmsg+0x184/0x238 net/socket.c:2703
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 6895 Comm: syz.0.76 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : should_resched arch/arm64/include/asm/preempt.h:78 [inline]
pc : __local_bh_enable_ip+0x1f0/0x35c kernel/softirq.c:414
lr : __local_bh_enable_ip+0x1ec/0x35c kernel/softirq.c:412
sp : ffff8000a1806210
x29: ffff8000a1806220 x28: 0000000040613361 x27: ffff8000a18063e0
x26: ffff0000f25e3b60 x25: dfff800000000000 x24: 0000000000000001
x23: dfff800000000000 x22: 1fffe000196c63d1 x21: ffff80008ab3e7b8
x20: 0000000000000201 x19: ffff0000cb631e88 x18: 00000000ffffffff
x17: ffff800093605000 x16: ffff80008052bc24 x15: 0000000000000001
x14: 1fffe0001b9124c0 x13: 0000000000000000 x12: 0000000000000000
x11: ffff800093404c28 x10: 0000000000000003 x9 : 0000000000000000
x8 : 000000000382547a x7 : ffff80008ab4aee0 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000010
x2 : 0000000000000002 x1 : ffff80008ee54d8e x0 : ffff80010c40c000
Call trace:
 __daif_local_irq_enable arch/arm64/include/asm/irqflags.h:26 [inline] (P)
 arch_local_irq_enable arch/arm64/include/asm/irqflags.h:48 [inline] (P)
 __local_bh_enable_ip+0x1f0/0x35c kernel/softirq.c:412 (P)
 __raw_spin_trylock_bh include/linux/spinlock_api_smp.h:177 [inline]
 _raw_spin_trylock_bh+0x68/0x80 kernel/locking/spinlock.c:146
 spin_trylock_bh include/linux/spinlock.h:411 [inline]
 tipc_sk_rcv+0x2f4/0x2294 net/tipc/socket.c:2494
 tipc_node_xmit+0x18c/0xc9c net/tipc/node.c:1701
 tipc_node_xmit_skb net/tipc/node.c:1766 [inline]
 tipc_node_distr_xmit+0x248/0x33c net/tipc/node.c:1781
 tipc_sk_rcv+0x1df0/0x2294 net/tipc/socket.c:2499
 tipc_node_xmit+0x18c/0xc9c net/tipc/node.c:1701
 tipc_sk_push_backlog+0x398/0x744 net/tipc/socket.c:1312
 tipc_sk_conn_proto_rcv net/tipc/socket.c:1366 [inline]
 tipc_sk_proto_rcv+0x704/0x12ec net/tipc/socket.c:2156
 tipc_sk_filter_rcv+0x2524/0x277c net/tipc/socket.c:2350
 tipc_sk_enqueue net/tipc/socket.c:2443 [inline]
 tipc_sk_rcv+0x628/0x2294 net/tipc/socket.c:2495
 tipc_node_xmit+0x18c/0xc9c net/tipc/node.c:1701
 tipc_node_xmit_skb net/tipc/node.c:1766 [inline]
 tipc_node_distr_xmit+0x248/0x33c net/tipc/node.c:1781
 tipc_sk_backlog_rcv+0x164/0x214 net/tipc/socket.c:2410
 sk_backlog_rcv include/net/sock.h:1150 [inline]
 __release_sock+0x19c/0x39c net/core/sock.c:3172
 release_sock+0x60/0x1ac net/core/sock.c:3726
 sockopt_release_sock net/core/sock.c:1155 [inline]
 sk_setsockopt+0x2354/0x28ec net/core/sock.c:1668
 sock_setsockopt+0x68/0x80 net/core/sock.c:1675
 do_sock_setsockopt+0x19c/0x328 net/socket.c:2340
 __sys_setsockopt net/socket.c:2369 [inline]
 __do_sys_setsockopt net/socket.c:2375 [inline]
 __se_sys_setsockopt net/socket.c:2372 [inline]
 __arm64_sys_setsockopt+0x170/0x1e0 net/socket.c:2372
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

