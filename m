Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6078CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E72E48E008B; Mon, 13 Oct 2025 17:51:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49E38E0031; Mon, 13 Oct 2025 17:51:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5FEA8E008B; Mon, 13 Oct 2025 17:51:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BFBF98E0031
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:51:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FC3F5A02A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:51:06 +0000 (UTC)
X-FDA: 83994436932.04.ACAC714
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf07.hostedemail.com (Postfix) with ESMTP id E2EE74000C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:51:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S3Esw2xh;
	spf=pass (imf07.hostedemail.com: domain of vinicius.gomes@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=vinicius.gomes@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QD3GG/DFmOJ80YKa4QZvcy3IZiuJ1Z4i3SHJaSjaTeA=;
	b=QZkeml0GphjdGnnuClXQDioGef2ioKsXdfrOv0P4zurQSUCRFz50fcUtjoBadDVOnghclf
	nP81hCknG8+g8dWpHGLeDLFXh6fCPf4ocPzGT/6Z+A5sEzXHzv1YVof77nUkIn4h2QPzYM
	PvbCCzFeG1uXSpHCR/FU1kdw8QlQRv4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S3Esw2xh;
	spf=pass (imf07.hostedemail.com: domain of vinicius.gomes@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=vinicius.gomes@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392264; a=rsa-sha256;
	cv=none;
	b=yEgeoLcOCwAfr/7z1X3pTW7aBMLyVcAo+QHznGsWw94GEdg3ZgptnE477FbhKJZeypAQDw
	42m9DXyGe3XMH9K7rwTbbBs8x9QeA3C+uSMaK0PG2lK8vDLCLCvW+/1fp0wWLwzu3CHW7w
	gngh4gOL8z7gPBpMnbTIX2ErdMQF7Ts=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760392262; x=1791928262;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=s/rWpAk/spLG7cGAgaAcB22SaCS3hyaO1JzxvOBN1UU=;
  b=S3Esw2xhTDxoZbQhNw8K0K5aEVPqiC0KVJIeKH21kCcc4klAuMwncrGG
   GUM9cpzdbydN/I1H+cgmEu+mGwwuPRMUNn/9J16BprqHYNIEW9259Q8uB
   h/3mgeOrq1f6tSbVCg5q3H5oYyJhGBlnPd63K/NuOMudMgyhlzUqVIJhC
   IYJ8cdipdDjo6lfc9FBmztZmXGcJrzdpVUCLIbv+mLii2p6AfGYGvm0W0
   UfbsG+80ngsin7P1flEz/gD8PnEDENmfg6oS+NthJXSpgirDupb6K2hgy
   OXei35wvMdqFyJs5ec/AnUgYvVWcf9UjQ3P10nT3mHUhmq91+5XoFoIc5
   A==;
X-CSE-ConnectionGUID: X0UBOkm9TnOIS1b+lghczQ==
X-CSE-MsgGUID: pb2RGxM6Rtmpg36cE7n8sg==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="88004548"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="88004548"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 14:51:00 -0700
X-CSE-ConnectionGUID: K2D8ox7WRo6Awe7td7rbkg==
X-CSE-MsgGUID: Xg7zxYz8TLC+L6NGk6zaPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="186809381"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.88.27.140])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 14:51:00 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>, Eric Dumazet <edumazet@google.com>
Cc: syzbot <syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com>,
 davem@davemloft.net, dsahern@kernel.org, hdanton@sina.com,
 horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, netdev@vger.kernel.org, pabeni@redhat.com,
 syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Subject: Re: [syzbot] [net?] [mm?] INFO: rcu detected stall in
 inet_rtm_newaddr (2)
In-Reply-To: <CAM0EoMnGLqKU7AnsgS00SEgU0eq71f-kiqNniCNyfiyAfNm8og@mail.gmail.com>
References: <681a1770.050a0220.a19a9.000d.GAE@google.com>
 <68ea0a24.050a0220.91a22.01ca.GAE@google.com>
 <CANn89iLjjtXV3ZMxfQDb1bbsVJ6a_Chexu4FwqeejxGTwsR_kg@mail.gmail.com>
 <CAM0EoMnGLqKU7AnsgS00SEgU0eq71f-kiqNniCNyfiyAfNm8og@mail.gmail.com>
Date: Mon, 13 Oct 2025 14:51:18 -0700
Message-ID: <87347mmpwp.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E2EE74000C
X-Stat-Signature: q71cng6tz41ongtaysf115qcm3kbink3
X-Rspam-User: 
X-HE-Tag: 1760392261-12905
X-HE-Meta: U2FsdGVkX1+t8NsYBHfp09D6fgMNbeuRDi64txbViG48Tuwu6OT/EHmhV0Hub8vBJbSH8H3nFomLSUizHAI6UrRnfyf1x9FYGqpZI8HZerja66g5XpnK9demfHkPSSdOIyiAcZj7OwGssJSw3yG0QVG+xiqoT/lTgzvus/qYcA+DBbvDgigph4dtVl2ozOoXZp8IE74pynkrJMaOsCYXOH0C3lS6KKzKrLhxcgKLgvZ+oNFpyI4YyJ590VEACE3iPcb2sB4mPJRsKF00+XLyR7atr2nJaBSxpoWwNL5Hs+hw+ro208x3qK5gTuOkRWxPMy95xqNTM/CX24WfsbXf0vsKUtXs1k/DCPRAU8Wy1RCUMqlJnMataFmt3vdQPxBPQr9KL3LhopHTRP8CSaxSICJsVGRnOmrDFn42rXbNRKLpBSpY9wurhYqG3lIoMVUiuOt40Cbt7qc4QLSPK905PcBcQYZQ6ELIgD2R2+iU9vfVj4vtOq1NUzzBEKRpcj/gWfaj4pC3SszDJu27BmGb3Ku9VRDeCgjho4i45v0Y4w6J4WfhTHtNm0r7JwbjwpW/Vlmw1fJws0qU/i/2yD2ZNum7dQYNGuoXiFmLuGSJiM/EeIUU0Y8MD7kbAuAIwxiXO9KoWh9wer22b2Jpe+of4ya354VpR1BRQagKbPZtMppYfT/PZ5sKD7bJgSewM7hv99jN8tPoc4rAIht8tHjLE8vEX0UnEl6sdNop/j+ZQQm3KxfCT4CCDBHzACB54oBn+5PQ5DWB84HkgMDUoGk1o68DXrYXm+WDj/ygzEnPA0pfdctv22BModQcB8R0/o0QWtopYpejus1QGwkVWjANItOlOIpjm3HoZ5YIGRMq4cO4XSMLJ/6SpVsnZ2Qq+T2dUSmPcKz2POyMwMiJImrL675ZRIfHKNYbp9qPmoACPhCXcM3gMytoRd+eLwqOfMjkSo4BMrB1BsCLd3sgBMH
 VsnB9W23
 ENvQyIm/xJHiRCzAEbj/Y/X9K8Kn3g6XIcuncqS3CYqOdFqIpaO/+bduGYD+tba1fIYCfUBwcg5Evqkiuh/nbAogyO/CcgjAgLXmm8sdMJR00W5R+t/RCmJbfgtFBbAaIY7A21S7a42UP62tZF4O7PNqu3ilSQKBv2iFqZ0o8hPTYlFDCXsKizh0/qNRtEuXMZqUnjtJQMEbHoTjqYNAFv3yS4bvpyYtCOm/qvRwu9OygceolVW+eAZhq4vFVMtI/UHCTftTJuBjPse0kCoZSydmE+vAsE2pRE5F2o3SQvnAeoCTQ/Ku4TR1iPJETqkcAFznHSQDxL5kx4HrqZuFnBEVLViTz7zUW/vv8Qk5gZEQ8YxQpVqdPMQQJWvcz372N4qTrOk0OoFjUVGcsIsAyy6kkvr/S55FOIfeOYcu7n1nUvnu63qQUYaeuyAm4/GxvkvG5Et7DlkDGn40R5/Bv4vTKZQuBHdNHuoqxrUPnCA7ZeMqJuOInTd4qnn7Ex8hKFST/4X5NJR7nSBs3S7jr9CrM3tFFpeBYKwLrWHnsc4RAbVBLNejxRSP0ZMiyGY6snvlnLX2yReh2Y6G+F5qq6iKCxItMviL39v9ZM4F6jn9H50kfCU7YARnKTYqJ9va5Q3oUqR3Kd9R4rzsVZ+qvurCiQahfxyAcZK7uVMoF/6Z9iJqlo143P9SD5fe0XoWMsQP4Qn1nUFDFK8n+B1tSvVHo2oxRxey/e2gp+gDksxogiKkWH605L7xVQAriBHfhEqhcy5b3k3LN3XEUOHH3xY9G3WpOZD6OnoUrgFFDVW8r5d5SBxTJMUws4aAj18BSjyIDMgcW+1OdmAbf36VtPC7XMqFExGttRGhq9OhDWcpVwoyn/gWlDfHH6fndUdpwGugz6Tpj+vWy0wZqKObOZkJBgA46NwS0xBgd5UJ2FP3REqDXQl5dTjc8h5bD6X/g6SIStuglueuXKXj/aFrKf/Rdtxg4
 Rcx9QHAs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jamal Hadi Salim <jhs@mojatatu.com> writes:

> On Sat, Oct 11, 2025 at 5:42=E2=80=AFAM Eric Dumazet <edumazet@google.com=
> wrote:
>>
>> On Sat, Oct 11, 2025 at 12:41=E2=80=AFAM syzbot
>> <syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com> wrote:
>> >
>> > syzbot has found a reproducer for the following issue on:
>> >
>> > HEAD commit:    18a7e218cfcd Merge tag 'net-6.18-rc1' of git://git.ker=
nel...
>> > git tree:       net-next
>> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D12504dcd98=
0000
>> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D61ab7fa743=
df0ec1
>> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D51cd74c5dfea=
fd65e488
>> > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b=
7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D14d2a542=
580000
>> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D142149e258=
0000
>> >
>> > Downloadable assets:
>> > disk image: https://storage.googleapis.com/syzbot-assets/7a01e6dce97e/=
disk-18a7e218.raw.xz
>> > vmlinux: https://storage.googleapis.com/syzbot-assets/5e1b7e41427f/vml=
inux-18a7e218.xz
>> > kernel image: https://storage.googleapis.com/syzbot-assets/69b55860120=
9/bzImage-18a7e218.xz
>> >
>> > IMPORTANT: if you fix the issue, please add the following tag to the c=
ommit:
>> > Reported-by: syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com
>> >
>> > sched: DL replenish lagged too much
>> > rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
>> > rcu:    0-...!: (2 GPs behind) idle=3D7754/1/0x4000000000000000 softir=
q=3D15464/15465 fqs=3D1
>> > rcu:    (detected by 1, t=3D10502 jiffies, g=3D11321, q=3D371 ncpus=3D=
2)
>> > Sending NMI from CPU 1 to CPUs 0:
>> > NMI backtrace for cpu 0
>> > CPU: 0 UID: 0 PID: 5948 Comm: syz-executor Not tainted syzkaller #0 PR=
EEMPT(full)
>> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIO=
S Google 10/02/2025
>> > RIP: 0010:rb_insert_color_cached include/linux/rbtree.h:113 [inline]
>> > RIP: 0010:rb_add_cached include/linux/rbtree.h:183 [inline]
>> > RIP: 0010:timerqueue_add+0x1a8/0x200 lib/timerqueue.c:40
>> > Code: e7 31 f6 e8 6a 0c de f6 42 80 3c 2b 00 74 08 4c 89 f7 e8 7b 0a d=
e f6 4d 89 26 4d 8d 7e 08 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 <74> 08 4c 89=
 ff e8 5e 0a de f6 4d 89 27 4d 85 e4 40 0f 95 c5 eb 07
>> > RSP: 0018:ffffc90000007cf0 EFLAGS: 00000046
>> > RAX: 1ffff110170c4f83 RBX: 1ffff110170c4f82 RCX: 0000000000000000
>> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88805de72358
>> > RBP: 0000000000000000 R08: ffff88805de72357 R09: 0000000000000000
>> > R10: ffff88805de72340 R11: ffffed100bbce46b R12: ffff88805de72340
>> > R13: dffffc0000000000 R14: ffff8880b8627c10 R15: ffff8880b8627c18
>> > FS:  000055557c657500(0000) GS:ffff888125d0f000(0000) knlGS:0000000000=
000000
>> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> > CR2: 0000200000000600 CR3: 000000002ee76000 CR4: 00000000003526f0
>> > Call Trace:
>> >  <IRQ>
>> >  __run_hrtimer kernel/time/hrtimer.c:1794 [inline]
>> >  __hrtimer_run_queues+0x656/0xc60 kernel/time/hrtimer.c:1841
>> >  hrtimer_interrupt+0x45b/0xaa0 kernel/time/hrtimer.c:1903
>> >  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1041 [inline]
>> >  __sysvec_apic_timer_interrupt+0x108/0x410 arch/x86/kernel/apic/apic.c=
:1058
>> >  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [i=
nline]
>> >  sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1052
>> >  </IRQ>
>> >  <TASK>
>> >  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtent=
ry.h:702
>> > RIP: 0010:pv_vcpu_is_preempted arch/x86/include/asm/paravirt.h:579 [in=
line]
>> > RIP: 0010:vcpu_is_preempted arch/x86/include/asm/qspinlock.h:63 [inlin=
e]
>> > RIP: 0010:owner_on_cpu include/linux/sched.h:2282 [inline]
>> > RIP: 0010:mutex_spin_on_owner+0x189/0x360 kernel/locking/mutex.c:361
>> > Code: b6 04 30 84 c0 0f 85 59 01 00 00 48 8b 44 24 08 8b 18 48 8b 44 2=
4 48 42 80 3c 30 00 74 0c 48 c7 c7 90 8c fa 8d e8 a7 cd 88 00 <48> 83 3d ff=
 27 5e 0c 00 0f 84 b9 01 00 00 48 89 df e8 41 e0 d5 ff
>> > RSP: 0018:ffffc900034c7428 EFLAGS: 00000246
>> > RAX: 1ffffffff1bf5192 RBX: 0000000000000001 RCX: ffffffff819c6588
>> > RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff8f4df8a0
>> > RBP: 1ffffffff1e9bf14 R08: ffffffff8f4df8a7 R09: 1ffffffff1e9bf14
>> > R10: dffffc0000000000 R11: fffffbfff1e9bf15 R12: ffffffff8f4df8a0
>> > R13: ffffffff8f4df8f0 R14: dffffc0000000000 R15: ffff8880267a9e40
>> >  mutex_optimistic_spin kernel/locking/mutex.c:464 [inline]
>> >  __mutex_lock_common kernel/locking/mutex.c:602 [inline]
>> >  __mutex_lock+0x311/0x1350 kernel/locking/mutex.c:760
>> >  rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
>> >  inet_rtm_newaddr+0x3b0/0x18b0 net/ipv4/devinet.c:978
>> >  rtnetlink_rcv_msg+0x7cf/0xb70 net/core/rtnetlink.c:6954
>> >  netlink_rcv_skb+0x205/0x470 net/netlink/af_netlink.c:2552
>> >  netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
>> >  netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
>> >  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
>> >  sock_sendmsg_nosec net/socket.c:727 [inline]
>> >  __sock_sendmsg+0x21c/0x270 net/socket.c:742
>> >  __sys_sendto+0x3bd/0x520 net/socket.c:2244
>> >  __do_sys_sendto net/socket.c:2251 [inline]
>> >  __se_sys_sendto net/socket.c:2247 [inline]
>> >  __x64_sys_sendto+0xde/0x100 net/socket.c:2247
>> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>> >  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> > RIP: 0033:0x7faade790d5c
>> > Code: 2a 5f 02 00 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28 4=
8 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 f0=
 ff ff 77 34 89 ef 48 89 44 24 08 e8 70 5f 02 00 48 8b
>> > RSP: 002b:00007ffdd2e3b670 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
>> > RAX: ffffffffffffffda RBX: 00007faadf514620 RCX: 00007faade790d5c
>> > RDX: 0000000000000028 RSI: 00007faadf514670 RDI: 0000000000000003
>> > RBP: 0000000000000000 R08: 00007ffdd2e3b6c4 R09: 000000000000000c
>> > R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000003
>> > R13: 0000000000000000 R14: 00007faadf514670 R15: 0000000000000000
>> >  </TASK>
>> > rcu: rcu_preempt kthread timer wakeup didn't happen for 10499 jiffies!=
 g11321 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
>> > rcu:    Possible timer handling issue on cpu=3D0 timer-softirq=3D4286
>> > rcu: rcu_preempt kthread starved for 10500 jiffies! g11321 f0x0 RCU_GP=
_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
>> > rcu:    Unless rcu_preempt kthread gets sufficient CPU time, OOM is no=
w expected behavior.
>> > rcu: RCU grace-period kthread stack dump:
>> > task:rcu_preempt     state:I stack:27224 pid:16    tgid:16    ppid:2  =
    task_flags:0x208040 flags:0x00080000
>> > Call Trace:
>> >  <TASK>
>> >  context_switch kernel/sched/core.c:5325 [inline]
>> >  __schedule+0x1798/0x4cc0 kernel/sched/core.c:6929
>> >  __schedule_loop kernel/sched/core.c:7011 [inline]
>> >  schedule+0x165/0x360 kernel/sched/core.c:7026
>> >  schedule_timeout+0x12b/0x270 kernel/time/sleep_timeout.c:99
>> >  rcu_gp_fqs_loop+0x301/0x1540 kernel/rcu/tree.c:2083
>> >  rcu_gp_kthread+0x99/0x390 kernel/rcu/tree.c:2285
>> >  kthread+0x711/0x8a0 kernel/kthread.c:463
>> >  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>> >  </TASK>
>> >
>> >
>> > ---
>> > If you want syzbot to run the reproducer, reply with:
>> > #syz test: git://repo/address.git branch-or-commit-hash
>> > If you attach or paste a git patch, syzbot will apply it before testin=
g.
>>
>> Yet another taprio report.
>>
>> If taprio can not be fixed, perhaps we should remove it from the
>> kernel, or clearly marked as broken.
>> (Then ask syzbot to no longer include it)
>
> Agreed on the challenge with taprio.
> We need the stakeholders input: Vinicius - are you still working in
> this space? Vladimir you also seem to have interest (or maybe nxp
> does) in this?

No, I am not working on this space anymore.

I will talk with other Intel folks (and my manager) and see what we can
do. But if others that find it useful can help even better.

> At a minimum, we should mark it as broken unless the stakeholders want
> to actively fix these issues.
> Would syzbot still look at it if it was marked broken?
>
> cheers,
> jamal
>


Cheers,
--=20
Vinicius

