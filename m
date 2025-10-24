Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 518A4CCD193
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 00:11:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACF248E001E; Thu, 23 Oct 2025 20:11:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA6958E0002; Thu, 23 Oct 2025 20:11:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E35D8E001E; Thu, 23 Oct 2025 20:11:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 880368E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:11:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ECBFC160CBC
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 00:11:02 +0000 (UTC)
X-FDA: 84031077564.24.A501346
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf04.hostedemail.com (Postfix) with ESMTP id 503F240009
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 00:11:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="G15Z2f/g";
	spf=pass (imf04.hostedemail.com: domain of vinicius.gomes@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=vinicius.gomes@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761264660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=24CZ2YYDs4R6EtTfXlSgSy372GfjOTRhnhs+wSbuWks=;
	b=pucDrT7XOk+3lcOVa7f3Ryw0xFQFfTqRmbR4qPkHKFVSmXKLb/D0rgIHSS2JmYKNnBa/GI
	mbeDj+d3Ug2YSyELL+9k3A26DGy6dby1j84Y22C1fqab8y1vH0Uhlz/RQ2IPB4pgLk+xv9
	1OVCZQ2h6HKcnbh1JYiI6G4HiGrAIBg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="G15Z2f/g";
	spf=pass (imf04.hostedemail.com: domain of vinicius.gomes@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=vinicius.gomes@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761264660; a=rsa-sha256;
	cv=none;
	b=inDSpM1gUCA3EkTCyRuC8fgd0Y48IYXKX+oJzNbgSP+KstnpW3FZyZcgZaZkFGG9Doyd9h
	doOrvyayrqZed4zrUceUi1eoKPoZbksV9/DuCO7Q/V8RT3bzkW1aWrY3mYkEmHmTII5xJm
	V09AhlyFAYi2P1FiDqA+3NBlACQjBjc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761264661; x=1792800661;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=cRoFprDz70mbXHrwoT6Ll1/qJQC7aLv3IFRZEqP1G2w=;
  b=G15Z2f/gY44NVwkcZflacvhBeofz0ktN515iwNp+98rN+mKrRmf++y0z
   /WqiK7EpE93cYOQJYK+74nGSAiIT4pdFiTduvMyGMhEWy2U+nu5MHcjCT
   VzrbLgkFY99EShLkGI5LDK1o4hlRIpzIkpt/aZ7H95tu2mtJRwJhevtLX
   aQNGiq8OM49015dx1f/z8FBA2RVb4WB8bLwgFYStKqfZ8xtSLyPrw3KLs
   i/eFqm7UNSfbODtbv5f/A7euYpIvTIBGuDHkPmuZstvhoGCvwUpYHDnvv
   CaGs1yzfXdN9DYjVxjbFJazTYdARzfqG6QDXI25mu6/sQW4frp5UhCdeg
   A==;
X-CSE-ConnectionGUID: rCNeb60DSBu9wFtreMEhoQ==
X-CSE-MsgGUID: SJ985HPvSkK79c97zl93kA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="66062200"
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="66062200"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 17:10:59 -0700
X-CSE-ConnectionGUID: Oe7i+CjoQBOqMVmcJjSHRg==
X-CSE-MsgGUID: a6zWccKrSZWVywwWiEgrFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,251,1754982000"; 
   d="scan'208";a="184003784"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.88.27.140])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 17:10:58 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Eric Dumazet <edumazet@google.com>, syzbot
 <syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com>,
 davem@davemloft.net, dsahern@kernel.org, hdanton@sina.com,
 horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, netdev@vger.kernel.org, pabeni@redhat.com,
 syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Subject: Re: [syzbot] [net?] [mm?] INFO: rcu detected stall in
 inet_rtm_newaddr (2)
In-Reply-To: <87ms5rlrvh.fsf@intel.com>
References: <681a1770.050a0220.a19a9.000d.GAE@google.com>
 <68ea0a24.050a0220.91a22.01ca.GAE@google.com>
 <CANn89iLjjtXV3ZMxfQDb1bbsVJ6a_Chexu4FwqeejxGTwsR_kg@mail.gmail.com>
 <CAM0EoMnGLqKU7AnsgS00SEgU0eq71f-kiqNniCNyfiyAfNm8og@mail.gmail.com>
 <87347mmpwp.fsf@intel.com>
 <CAM0EoMnWcsgtN++zkOW9zf5QqUg9uNBGTNgf=2JARqarW31wwQ@mail.gmail.com>
 <87ms5rlrvh.fsf@intel.com>
Date: Thu, 23 Oct 2025 17:11:10 -0700
Message-ID: <87y0p1i2g1.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3fq4oycijrb8skq35w3q3jdu575ktesr
X-Rspamd-Queue-Id: 503F240009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761264660-579185
X-HE-Meta: U2FsdGVkX1+byFLOpPpQNOnEfUE4seartBhC4Iko/f36XFCp70MiMfkqUSkQl7TEYvoHZPTGz1P4xjRsuwAOhfwITI9jHg1XE8ptu4inc6WJjecFbVUF3fdpO4TQEk85DnXx9Llmwk3L89qOAiOlReKdfj/P+J8Y6Sicnrm95p7Igc+tes/jqWgdYTs5YAiJFabRQNHSsmENCuDk4UkuHj4DVvCOFZBuJHhDJurQiDoZoITnPCdEVIEPInQqi6USKepUPgjv9txHFmNzsCquVdf3A8HKRxLCzKBZK63riQPFyS7HcAVWk07LiK6CXcRVzCK04+KQ1nk+f4UKR/DEaojAMgzqXJs/xNbKefpfF2rimAbGnftBisK/RZ0G9NcPC5X0jfM8vy06O8dDa1wp7KN/gciCKUKyT3WV9rAwmEoKz2e3gJftD8kppFOgDxJq+qiJmL7d6m9LuI/p5h23rcfKQGk+9S+5kKilfMlui0UfkbwIocenS2iOLoLZVs87lw6qYhKboozNo7O/1MdnYHbWHp1e3d1abKJnsSyNWzG7qHdROtcHVssNg0DfX5C9OQLVaYOe0VOQu8RUWc4wKokzgy2P1LMIHhEJyQW+sFDTRA2w/s6rVvVqj0R53erk7iZ/336JUPEs6jROcKvngCjsbWREJJWAxfdsb7WU6G/CXu042Hsi09SM1KBJmNsoYycDkPMXOCddEowPYmuFt/Yxuo8Rmyi8E/ujHYqRRj+O2MKX/Q3HMsZiFWyfQnLtksozUZd5ggSd6rxIZxNojVnyqgP0RIvp8KvxMmC/gd1m8WkvQ/I8tL+klwhfSjSZ5I2XUxfpp2M/f2McJ9VXv2BTOw/l6ybH3RHjR5YbTbHu81sNDH42nojmU8xJYK3p47J9HgDpUNhkpBn8sjD0khaDJ5FyXFzXDh9wj2+HkbCOtBzX0qayPTR3ocPl5+Nmeo3Ffj7QuG+KozqY+Hh
 d8Cwsco/
 0/wPyzUhwkIrTSUq1y4W+bvcr0rUsbDa5852lXrJE+ECQnzWSwBfPKsVr/HA5z6x5qBv/foH8Fu0mJscd0qNaAuCtkEVp53WuirtvV3EEkV3O5569lA4sfqAtpNm5KWrmyhYIq5aFQ2/NEY2C4v8tKUV6HuuInYLn+pcE8Vy5qEVvOURdo9veTEkdB2hPFvwh+WR67O2z95cniJI80GwRNFDfymnuMAAcPLeO2Mf8Ugab004Il3Pr7FUhKV1L+MB724ykVVXUnCBZgdL5LsDngIKg7YExHZjOM13tuuPYjP7q/O2Wy1WerD9dOmRAGn2P5T01lCiYdrEirfhT4cW/SWgt+9cE9Wq5p/cZjkIvlAQCI8C0pO+jPiTVFgsPexbAS1KZiDxrb2FyiTmW6k7ItL1kj6JLL2YrbTfeC2mD3zJlXkqFiFvBWlhIfeFaJLVFG+jHQULrSrZQ0zLI6ZS6VQaaPO6rK5aUsv2jzaBSdZBrDyYWSdbhJPhBEOvFOZUEYv7WD4ATZo3FytOMcb6a9D3iC7gqMsE5ndz9SCZIeUT996+GKHWzMnCGeG8nlfu0VoPDzejugllkly2bv9FYcGX1O4azvIykIQd1COpumGVeMU1SJDiztEhu8xr/Vcrq9dO49anTcSvuJQjFTCtDzDMOcjFx6bgo3FCQ9+hjKt+6iOMCqyot+hy661HeGHJOjSr0Hf43+T+0kTDQil7IHJtNL8J3pBNAxnGtKLmEAxu3BNVqYS87v2LpZA1mC7jDSnyGNgK672+J0+umfSawLmb2yMhJiC7fL99LQ4F3NJJJ8/9Uuu09lnMhECp52/GdLLCQVtOA9FlmUnheQbVB70j7TJBoYMJr+GsjoNZMLVlaq6WSxvq+KXwAEhJy65kFOVhmtINxmjEDi4sHoYrhw8e7tNq1Ho0pmGRZvS+JCvopzBV5BULh3gwkW0BhK8k5gBE/bOLq1jv5AEYqZswDaa+i8JRb
 Y4YySg6I
 8LiCQCAInSvwHDZ5GWccC8X3ZnmFZ0IxFbXNrNRESYTdrlFUP75qwpfi2AmQKRHs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Vinicius Costa Gomes <vinicius.gomes@intel.com> writes:

> Jamal Hadi Salim <jhs@mojatatu.com> writes:
>
>> On Mon, Oct 13, 2025 at 5:51=E2=80=AFPM Vinicius Costa Gomes
>> <vinicius.gomes@intel.com> wrote:
>>>
>>> Jamal Hadi Salim <jhs@mojatatu.com> writes:
>>>
>>> > On Sat, Oct 11, 2025 at 5:42=E2=80=AFAM Eric Dumazet <edumazet@google=
.com> wrote:
>>> >>
>>> >> On Sat, Oct 11, 2025 at 12:41=E2=80=AFAM syzbot
>>> >> <syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com> wrote:
>>> >> >
>>> >> > syzbot has found a reproducer for the following issue on:
>>> >> >
>>> >> > HEAD commit:    18a7e218cfcd Merge tag 'net-6.18-rc1' of git://git=
.kernel...
>>> >> > git tree:       net-next
>>> >> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D12504d=
cd980000
>>> >> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D61ab7f=
a743df0ec1
>>> >> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D51cd74c5=
dfeafd65e488
>>> >> > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f=
909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>>> >> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D14d2=
a542580000
>>> >> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D142149=
e2580000
>>> >> >
>>> >> > Downloadable assets:
>>> >> > disk image: https://storage.googleapis.com/syzbot-assets/7a01e6dce=
97e/disk-18a7e218.raw.xz
>>> >> > vmlinux: https://storage.googleapis.com/syzbot-assets/5e1b7e41427f=
/vmlinux-18a7e218.xz
>>> >> > kernel image: https://storage.googleapis.com/syzbot-assets/69b5586=
01209/bzImage-18a7e218.xz
>>> >> >
>>> >> > IMPORTANT: if you fix the issue, please add the following tag to t=
he commit:
>>> >> > Reported-by: syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com
>>> >> >
>>> >> > sched: DL replenish lagged too much
>>> >> > rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
>>> >> > rcu:    0-...!: (2 GPs behind) idle=3D7754/1/0x4000000000000000 so=
ftirq=3D15464/15465 fqs=3D1
>>> >> > rcu:    (detected by 1, t=3D10502 jiffies, g=3D11321, q=3D371 ncpu=
s=3D2)
>>> >> > Sending NMI from CPU 1 to CPUs 0:
>>> >> > NMI backtrace for cpu 0
>>> >> > CPU: 0 UID: 0 PID: 5948 Comm: syz-executor Not tainted syzkaller #=
0 PREEMPT(full)
>>> >> > Hardware name: Google Google Compute Engine/Google Compute Engine,=
 BIOS Google 10/02/2025
>>> >> > RIP: 0010:rb_insert_color_cached include/linux/rbtree.h:113 [inlin=
e]
>>> >> > RIP: 0010:rb_add_cached include/linux/rbtree.h:183 [inline]
>>> >> > RIP: 0010:timerqueue_add+0x1a8/0x200 lib/timerqueue.c:40
>>> >> > Code: e7 31 f6 e8 6a 0c de f6 42 80 3c 2b 00 74 08 4c 89 f7 e8 7b =
0a de f6 4d 89 26 4d 8d 7e 08 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 <74> 08 4=
c 89 ff e8 5e 0a de f6 4d 89 27 4d 85 e4 40 0f 95 c5 eb 07
>>> >> > RSP: 0018:ffffc90000007cf0 EFLAGS: 00000046
>>> >> > RAX: 1ffff110170c4f83 RBX: 1ffff110170c4f82 RCX: 0000000000000000
>>> >> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88805de72358
>>> >> > RBP: 0000000000000000 R08: ffff88805de72357 R09: 0000000000000000
>>> >> > R10: ffff88805de72340 R11: ffffed100bbce46b R12: ffff88805de72340
>>> >> > R13: dffffc0000000000 R14: ffff8880b8627c10 R15: ffff8880b8627c18
>>> >> > FS:  000055557c657500(0000) GS:ffff888125d0f000(0000) knlGS:000000=
0000000000
>>> >> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> >> > CR2: 0000200000000600 CR3: 000000002ee76000 CR4: 00000000003526f0
>>> >> > Call Trace:
>>> >> >  <IRQ>
>>> >> >  __run_hrtimer kernel/time/hrtimer.c:1794 [inline]
>>> >> >  __hrtimer_run_queues+0x656/0xc60 kernel/time/hrtimer.c:1841
>>> >> >  hrtimer_interrupt+0x45b/0xaa0 kernel/time/hrtimer.c:1903
>>> >> >  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1041 [inli=
ne]
>>> >> >  __sysvec_apic_timer_interrupt+0x108/0x410 arch/x86/kernel/apic/ap=
ic.c:1058
>>> >> >  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:105=
2 [inline]
>>> >> >  sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c=
:1052
>>> >> >  </IRQ>
>>> >> >  <TASK>
>>> >> >  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/id=
tentry.h:702
>>> >> > RIP: 0010:pv_vcpu_is_preempted arch/x86/include/asm/paravirt.h:579=
 [inline]
>>> >> > RIP: 0010:vcpu_is_preempted arch/x86/include/asm/qspinlock.h:63 [i=
nline]
>>> >> > RIP: 0010:owner_on_cpu include/linux/sched.h:2282 [inline]
>>> >> > RIP: 0010:mutex_spin_on_owner+0x189/0x360 kernel/locking/mutex.c:3=
61
>>> >> > Code: b6 04 30 84 c0 0f 85 59 01 00 00 48 8b 44 24 08 8b 18 48 8b =
44 24 48 42 80 3c 30 00 74 0c 48 c7 c7 90 8c fa 8d e8 a7 cd 88 00 <48> 83 3=
d ff 27 5e 0c 00 0f 84 b9 01 00 00 48 89 df e8 41 e0 d5 ff
>>> >> > RSP: 0018:ffffc900034c7428 EFLAGS: 00000246
>>> >> > RAX: 1ffffffff1bf5192 RBX: 0000000000000001 RCX: ffffffff819c6588
>>> >> > RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff8f4df8a0
>>> >> > RBP: 1ffffffff1e9bf14 R08: ffffffff8f4df8a7 R09: 1ffffffff1e9bf14
>>> >> > R10: dffffc0000000000 R11: fffffbfff1e9bf15 R12: ffffffff8f4df8a0
>>> >> > R13: ffffffff8f4df8f0 R14: dffffc0000000000 R15: ffff8880267a9e40
>>> >> >  mutex_optimistic_spin kernel/locking/mutex.c:464 [inline]
>>> >> >  __mutex_lock_common kernel/locking/mutex.c:602 [inline]
>>> >> >  __mutex_lock+0x311/0x1350 kernel/locking/mutex.c:760
>>> >> >  rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
>>> >> >  inet_rtm_newaddr+0x3b0/0x18b0 net/ipv4/devinet.c:978
>>> >> >  rtnetlink_rcv_msg+0x7cf/0xb70 net/core/rtnetlink.c:6954
>>> >> >  netlink_rcv_skb+0x205/0x470 net/netlink/af_netlink.c:2552
>>> >> >  netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
>>> >> >  netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
>>> >> >  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
>>> >> >  sock_sendmsg_nosec net/socket.c:727 [inline]
>>> >> >  __sock_sendmsg+0x21c/0x270 net/socket.c:742
>>> >> >  __sys_sendto+0x3bd/0x520 net/socket.c:2244
>>> >> >  __do_sys_sendto net/socket.c:2251 [inline]
>>> >> >  __se_sys_sendto net/socket.c:2247 [inline]
>>> >> >  __x64_sys_sendto+0xde/0x100 net/socket.c:2247
>>> >> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>> >> >  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>>> >> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>> >> > RIP: 0033:0x7faade790d5c
>>> >> > Code: 2a 5f 02 00 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 =
28 48 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 0=
0 f0 ff ff 77 34 89 ef 48 89 44 24 08 e8 70 5f 02 00 48 8b
>>> >> > RSP: 002b:00007ffdd2e3b670 EFLAGS: 00000293 ORIG_RAX: 000000000000=
002c
>>> >> > RAX: ffffffffffffffda RBX: 00007faadf514620 RCX: 00007faade790d5c
>>> >> > RDX: 0000000000000028 RSI: 00007faadf514670 RDI: 0000000000000003
>>> >> > RBP: 0000000000000000 R08: 00007ffdd2e3b6c4 R09: 000000000000000c
>>> >> > R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000003
>>> >> > R13: 0000000000000000 R14: 00007faadf514670 R15: 0000000000000000
>>> >> >  </TASK>
>>> >> > rcu: rcu_preempt kthread timer wakeup didn't happen for 10499 jiff=
ies! g11321 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
>>> >> > rcu:    Possible timer handling issue on cpu=3D0 timer-softirq=3D4=
286
>>> >> > rcu: rcu_preempt kthread starved for 10500 jiffies! g11321 f0x0 RC=
U_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
>>> >> > rcu:    Unless rcu_preempt kthread gets sufficient CPU time, OOM i=
s now expected behavior.
>>> >> > rcu: RCU grace-period kthread stack dump:
>>> >> > task:rcu_preempt     state:I stack:27224 pid:16    tgid:16    ppid=
:2      task_flags:0x208040 flags:0x00080000
>>> >> > Call Trace:
>>> >> >  <TASK>
>>> >> >  context_switch kernel/sched/core.c:5325 [inline]
>>> >> >  __schedule+0x1798/0x4cc0 kernel/sched/core.c:6929
>>> >> >  __schedule_loop kernel/sched/core.c:7011 [inline]
>>> >> >  schedule+0x165/0x360 kernel/sched/core.c:7026
>>> >> >  schedule_timeout+0x12b/0x270 kernel/time/sleep_timeout.c:99
>>> >> >  rcu_gp_fqs_loop+0x301/0x1540 kernel/rcu/tree.c:2083
>>> >> >  rcu_gp_kthread+0x99/0x390 kernel/rcu/tree.c:2285
>>> >> >  kthread+0x711/0x8a0 kernel/kthread.c:463
>>> >> >  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>>> >> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>>> >> >  </TASK>
>>> >> >
>>> >> >
>>> >> > ---
>>> >> > If you want syzbot to run the reproducer, reply with:
>>> >> > #syz test: git://repo/address.git branch-or-commit-hash
>>> >> > If you attach or paste a git patch, syzbot will apply it before te=
sting.
>>> >>
>>> >> Yet another taprio report.
>>> >>
>>> >> If taprio can not be fixed, perhaps we should remove it from the
>>> >> kernel, or clearly marked as broken.
>>> >> (Then ask syzbot to no longer include it)
>>> >
>>> > Agreed on the challenge with taprio.
>>> > We need the stakeholders input: Vinicius - are you still working in
>>> > this space? Vladimir you also seem to have interest (or maybe nxp
>>> > does) in this?
>>>
>>> No, I am not working on this space anymore.
>>>
>>> I will talk with other Intel folks (and my manager) and see what we can
>>> do.
>>
>> I assume your customers are still interested in this working? If yes,
>> that would be a good pitch to the manager.
>
> I did talk with some people here, and let's just say that I am hearing
> positive noises. So chances are that I should be able to dedicate some
> of my "job time" to this area again.
>

Just a quick update, I got to spend some time on this, basically trying
to implement the idea here (that I had completely forgotten about):

https://lore.kernel.org/all/87jzftpwo2.fsf@intel.com/

Very early code, just to see how the code would look like is here:

https://github.com/vcgomes/net-next/tree/taprio-fix-syzkaller-report-clock-=
adjust

In case anyone is interested.

>> In my (extreme) view, another selling point is that there is an
>> ethical obligation to ensure things continue to work as intended.
>> Getting patches in is the easy part.
>>
>> cheers,
>> jamal
>>
>>>But if others that find it useful can help even better.
>>>
>>
>
>
> Cheers,
> --=20
> Vinicius
>


Cheers,
--=20
Vinicius

