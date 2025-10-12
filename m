Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7707FCCD187
	for <linux-mm@archiver.kernel.org>; Sun, 12 Oct 2025 15:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FBBA8E0003; Sun, 12 Oct 2025 11:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AC488E0002; Sun, 12 Oct 2025 11:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1743C8E0003; Sun, 12 Oct 2025 11:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDD958E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 11:47:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69A2CB5E3C
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 15:47:02 +0000 (UTC)
X-FDA: 83989890684.18.0AFF145
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 73CB5A0005
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 15:47:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=mojatatu-com.20230601.gappssmtp.com header.s=20230601 header.b=MUXCGPFq
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760284020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j4GxUB3mXIOijnAo4Jh/QDcKjXyJblUTMk9gLfFdbCM=;
	b=nWmS5fwp5+ZNBv3Nm9wNMiOAT0HnSd7khfDuQrdiqs8gTEPGLyKxErZqRlCb3gtsKu/5Xh
	pOfshAZhwoXM+K0zj7fk7n2pJzH2/bzDGTU6Q63t9yn/bzwqI6moPizepzxoX5BcJf6VTN
	VPq4Vl9Ja93NE6aqd+Wg3ZzFKCucqLw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760284020; a=rsa-sha256;
	cv=none;
	b=k4a4jhR7v05e64YOjGMHjmx5bqmqEnZMr+258bVTTbIAeYzRoXcx3I+L3CgOFdfaylB+Kd
	Qp4J4p46Fkfxcud7qNDNWVV2fg0gC/COCHp8IxptBtvcUAKysUXCUv/Zim5QDg1+bjbL91
	hXCRMFrw7mlHOK27KReMNF3u9djEsf8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=mojatatu-com.20230601.gappssmtp.com header.s=20230601 header.b=MUXCGPFq;
	dmarc=none;
	spf=none (imf25.hostedemail.com: domain of jhs@mojatatu.com has no SPF policy when checking 209.85.214.171) smtp.mailfrom=jhs@mojatatu.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-27eceb38eb1so36720025ad.3
        for <linux-mm@kvack.org>; Sun, 12 Oct 2025 08:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1760284019; x=1760888819; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j4GxUB3mXIOijnAo4Jh/QDcKjXyJblUTMk9gLfFdbCM=;
        b=MUXCGPFqhHB8GN2r1Qb1o99fDjvWVXHEq+xLQrflZeWw9ELBf5ZlYMA4dAd+Vqy4r/
         AXKAClWrDbwKhO0uSHF7cFYDIu32aL6cQ+W/kx33YwGGzlpqiHoajbpu2Xy9R5IenWVO
         ZNMJuQmJk9NkdkpCXA6as8kOj8GlGayLHxQ0KeyLtDwbk32EuafolfmEULzZSjLf7Tby
         alEX3+RvSeglMegAzuU7Pw8qBqquyaNTZLCxIIALoPETNANVmeAkfhWc6JsNnYxOfvKD
         SdcHUKjrsRbsahvN3MpYqDVGET9SAIGrUgYpPjC4SM7a5Zxruyfprftm4+PJM/kgqljU
         h+TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760284019; x=1760888819;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j4GxUB3mXIOijnAo4Jh/QDcKjXyJblUTMk9gLfFdbCM=;
        b=lE0FEhp4M395VUm5VXr7lJVMABmvSgnW7ZAB6uaQVQvrFutbuyLLmAFXLvHvkzNIkk
         PDqhda8NR3gB9iGo0zc+BA/+gtCAgM1cMojRtS5JzT7yNuC4qqC465UV9uxN0CeCEF7z
         ZNWlZCmJLz3j9RJBsP9sIZvvKhMpumZLyQ4MQyLmhZ2BbdFFIZi0aTG/fWeePshMkQqa
         qKygOS6Thh0SMaAZmQct/ToHaR4t6/RVrj79D6bTuJ2QkO41lqVhv7W/Eu298TZdnQ0f
         0l3MjVpPByLK6cWvUe49XNIaT0IDTkezEeQZu1PUR6UU2m+heGKfKYeg/uBfZBaB8uIr
         08ng==
X-Forwarded-Encrypted: i=1; AJvYcCX4uFAgD0mjGvAB2CIZf0OvdsHiffqnto8+c7Xnj58sM49MBoLOPVy06K/49Wb6oh6ZI61RbfVGZA==@kvack.org
X-Gm-Message-State: AOJu0YyLNJt9OfvJavYGVdtt6pkUWIBJW5wXv/fPUeU+PeIMaUYG6mBB
	EMIkfYPpvc+zfpZQMmmqZRluvytK14ShyhZXK/ZZYgxX6T/ne4jZXKV8AuHQtwIL4An7V77sbMw
	Li6jk/Jxgyf0DiZWg0KqWbyhDhelmNTNpa0CtQJdO
X-Gm-Gg: ASbGnctgrAFzrd/F+65PECVpCD8bUgN+GCiexppjj0dpuJuivlpmr9YtN/1fiAgLmS5
	6awCKJaMBLlw04XjlBUIbayjPO8lRWt+Y8qvsvhxAi9m7by9E237osvzR1lLU+L0fLb6U1/na4f
	Hb7n5gFkPGGChn2TkaFsEJ2j709v3irYW1cbTDYIgBpoGOagq82hpqgzeSaaKMXrGNP8C9bt0fE
	DliAOcX+vOJ0kt+Sbi3V/g0zHYt8o4FpPIihQ1I6pFfMChsHq6/iYJoJGiuclaQHXkep5gPZTqj
	rg==
X-Google-Smtp-Source: AGHT+IEsvkIHji5FXS3k4mVFSuiV2wODeo+ujiKNFe0QTizQr/lk/JboIRcTN5Hm3VjE5u/54mBRs8ZXlewlr2/MopQ=
X-Received: by 2002:a17:902:f64a:b0:277:9193:f2da with SMTP id
 d9443c01a7336-29027356c8emr245366775ad.5.1760284019230; Sun, 12 Oct 2025
 08:46:59 -0700 (PDT)
MIME-Version: 1.0
References: <681a1770.050a0220.a19a9.000d.GAE@google.com> <68ea0a24.050a0220.91a22.01ca.GAE@google.com>
 <CANn89iLjjtXV3ZMxfQDb1bbsVJ6a_Chexu4FwqeejxGTwsR_kg@mail.gmail.com>
In-Reply-To: <CANn89iLjjtXV3ZMxfQDb1bbsVJ6a_Chexu4FwqeejxGTwsR_kg@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sun, 12 Oct 2025 11:46:48 -0400
X-Gm-Features: AS18NWDhOrXzge47KDe52C44MpGP1jFq2C5UW5hu7ElSnyjdHaEd7xaH1FLGrCk
Message-ID: <CAM0EoMnGLqKU7AnsgS00SEgU0eq71f-kiqNniCNyfiyAfNm8og@mail.gmail.com>
Subject: Re: [syzbot] [net?] [mm?] INFO: rcu detected stall in
 inet_rtm_newaddr (2)
To: Eric Dumazet <edumazet@google.com>
Cc: syzbot <syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com>, 
	Vinicius Costa Gomes <vinicius.gomes@intel.com>, davem@davemloft.net, dsahern@kernel.org, 
	hdanton@sina.com, horms@kernel.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: 874zjiemdc85oczrqjmw3gjkb61j69zj
X-Rspam-User: 
X-Rspamd-Queue-Id: 73CB5A0005
X-HE-Tag: 1760284020-189117
X-HE-Meta: U2FsdGVkX1+YyuO6/GretmL3qs5r+qvJaPHWdUSnRnyOci8/S7nds/mNze2q6+kjvJ7A/FMHyZnTq+n1nSFas2mCJ7hyM9n7QsAyInDEsQghiHA0p7YUR2+M/kXOmb0j/6cJ3aULvyywQP1fIUvgb9j/0uJpWeC3VyG7DGHGQZKksBF0MWjg8p78cgC6EGG7V/MbHoCwQ85izZRA/6t6jAsymDomd+DaHHvqyJZRVzpx+m9ki9wu4OO/odQJFvnYRB3YSHtwj7GRHhJIAuscYicFRPGCkc7RYmiN/4XElmNO/GmssrW0xoBIcIuuINW6iJoWB3nSnB64l9lUpmfjo+q1c7MjoK2nQjahITrUEoVEJT0lS/Dr8Y1UP6Rq8YuVd0vBSXnrgA+1c8cx5siWMTUdVSAxTBeNoq1TQWqTay1PT6NL8CkJUzEHwK2ivHRDNqxJ+ruG03pfh/ioJ+ZxC9RbXpWz0bm+LZGE3o+YBAsn+Jxy0B1hkCgpt1JeQXHH9rSiBopW8R+giLJB253zPczu8I9BpEVUABpt5tAp5t4VI7eFqZxdKh28/6hU/xy9BlpAmpVi3D+eM4e5Hl6Xo5pGxeaBXCs4YCfG2W6OBlcSx6OdH1ieMw4d01CxQ5qYf8JD43o/7fWfduw7u5O/JY14U//rLjqDqGoi8G0SGI78PgE9ML5AVMBgtNCbpqC2zLVo8Kn0tqmbHWDTJcNnimqJVykxhQaBdTKG8YUgqCCxm85mN69iwF74D2Wne1exb7pAp/D0Or8etLKpdp/nse5GPOa2fDsSRecfJnnAazzqpe4KfzWKhw5agbkkS2CHUvl0aeuOme2kyYDaNL9W7BUhaWtXQlY5gb4VRqu5Za0ksaI8duuAX0h/37adVwkl9exS79f3Pioy+8Ihq/j/KtegcuElFdrkbFe6AL7+z+SI++Cyb8JEUvmsMVGAa7Fj1dNh4XjDao03JCnABaT
 CNI11Sj4
 Cu4Zsp5jiNR+yG0xF7gAI5RByc+p8YgFbYH2I3o7CiNLculxudFJVHDUcj2UNs0NV7JL0rsBWXATDVybsQ4A8S+ycnB9KZ0+UkfRmLh+8kLb8nkpLdByShpCdJab2Kk6Bn93FK4J3ccsf0kc2Q1ifiG5zijw5kgE9KN5LUyY3YEMneX9fgBsUWp/PAZrxy9CGmhpyDxbhiIUDggSZ1sKEWB1/+5XmdOejhlv+CZqIlWkKLOZlzC5M+NUQuKfKlpvCzX6yqBsA94hRkH+Ym3fDyfP6Yc/x+PBxl6FIZVzKYSFFykAvYcgtFMuiQkDRlBqJW+zW1iIDH9I4MraOFaYuqT0m5IocB7fyi26IdTuI8+1v3sdgBzZGxCw0khxrOggxxaqAh/Z7t8ruKM5PB+WQUACw2NEfQYQzuZjdfrrM12cRqqQnCqzjMIywROUCQGM+blx8Ud1YlXmEsNi3jtvsPRSDrdbhjAByVZqWDmgTCcB2nbO/Hr+per1ZJ/NAAfsps1WWms6Dp48a94l+tb04ouIv594ibpX04LZ6DkCkJv14/+99OIr4cqgnY/LHCK0vj3i3np8YzEMwMdhnPF/rcR9j6lF1qJ3G39XoflTKfScRpJyvDJyLrH4EJjwE3gtVfuSM+y+Ai8Ccys+rh2u7n/TAQI/qoqZfkZA4jxqUc07yDHyH9M+SKbWeE3E9JTEQiy66AiFCJQVZSSxZpIJGOOppScLTszsIDCPVds2rjaUKgOnb25sGj0vI/mZdO9zTllVXsWIfz+Zt/TNndX7pluzi7sN4ys2miYzZRrfuZdzyh8zF97Pnyn2Zgs4mLxjVPkdbEXdR3FUFWLNtZUi8MRFVOW2SAEf7RGRmHGOfZAoPE7hbgK+9kNay/o+wwsZaWkhg8iVuHCC1wumkAJrKv/DlkUSakP6n0i1SUvW91cDbdyE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 11, 2025 at 5:42=E2=80=AFAM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Sat, Oct 11, 2025 at 12:41=E2=80=AFAM syzbot
> <syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com> wrote:
> >
> > syzbot has found a reproducer for the following issue on:
> >
> > HEAD commit:    18a7e218cfcd Merge tag 'net-6.18-rc1' of git://git.kern=
el...
> > git tree:       net-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D12504dcd980=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D61ab7fa743d=
f0ec1
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D51cd74c5dfeaf=
d65e488
> > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7=
976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D14d2a5425=
80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D142149e2580=
000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/7a01e6dce97e/d=
isk-18a7e218.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/5e1b7e41427f/vmli=
nux-18a7e218.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/69b558601209=
/bzImage-18a7e218.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com
> >
> > sched: DL replenish lagged too much
> > rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> > rcu:    0-...!: (2 GPs behind) idle=3D7754/1/0x4000000000000000 softirq=
=3D15464/15465 fqs=3D1
> > rcu:    (detected by 1, t=3D10502 jiffies, g=3D11321, q=3D371 ncpus=3D2=
)
> > Sending NMI from CPU 1 to CPUs 0:
> > NMI backtrace for cpu 0
> > CPU: 0 UID: 0 PID: 5948 Comm: syz-executor Not tainted syzkaller #0 PRE=
EMPT(full)
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 10/02/2025
> > RIP: 0010:rb_insert_color_cached include/linux/rbtree.h:113 [inline]
> > RIP: 0010:rb_add_cached include/linux/rbtree.h:183 [inline]
> > RIP: 0010:timerqueue_add+0x1a8/0x200 lib/timerqueue.c:40
> > Code: e7 31 f6 e8 6a 0c de f6 42 80 3c 2b 00 74 08 4c 89 f7 e8 7b 0a de=
 f6 4d 89 26 4d 8d 7e 08 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 <74> 08 4c 89 =
ff e8 5e 0a de f6 4d 89 27 4d 85 e4 40 0f 95 c5 eb 07
> > RSP: 0018:ffffc90000007cf0 EFLAGS: 00000046
> > RAX: 1ffff110170c4f83 RBX: 1ffff110170c4f82 RCX: 0000000000000000
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88805de72358
> > RBP: 0000000000000000 R08: ffff88805de72357 R09: 0000000000000000
> > R10: ffff88805de72340 R11: ffffed100bbce46b R12: ffff88805de72340
> > R13: dffffc0000000000 R14: ffff8880b8627c10 R15: ffff8880b8627c18
> > FS:  000055557c657500(0000) GS:ffff888125d0f000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000200000000600 CR3: 000000002ee76000 CR4: 00000000003526f0
> > Call Trace:
> >  <IRQ>
> >  __run_hrtimer kernel/time/hrtimer.c:1794 [inline]
> >  __hrtimer_run_queues+0x656/0xc60 kernel/time/hrtimer.c:1841
> >  hrtimer_interrupt+0x45b/0xaa0 kernel/time/hrtimer.c:1903
> >  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1041 [inline]
> >  __sysvec_apic_timer_interrupt+0x108/0x410 arch/x86/kernel/apic/apic.c:=
1058
> >  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [in=
line]
> >  sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1052
> >  </IRQ>
> >  <TASK>
> >  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentr=
y.h:702
> > RIP: 0010:pv_vcpu_is_preempted arch/x86/include/asm/paravirt.h:579 [inl=
ine]
> > RIP: 0010:vcpu_is_preempted arch/x86/include/asm/qspinlock.h:63 [inline=
]
> > RIP: 0010:owner_on_cpu include/linux/sched.h:2282 [inline]
> > RIP: 0010:mutex_spin_on_owner+0x189/0x360 kernel/locking/mutex.c:361
> > Code: b6 04 30 84 c0 0f 85 59 01 00 00 48 8b 44 24 08 8b 18 48 8b 44 24=
 48 42 80 3c 30 00 74 0c 48 c7 c7 90 8c fa 8d e8 a7 cd 88 00 <48> 83 3d ff =
27 5e 0c 00 0f 84 b9 01 00 00 48 89 df e8 41 e0 d5 ff
> > RSP: 0018:ffffc900034c7428 EFLAGS: 00000246
> > RAX: 1ffffffff1bf5192 RBX: 0000000000000001 RCX: ffffffff819c6588
> > RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff8f4df8a0
> > RBP: 1ffffffff1e9bf14 R08: ffffffff8f4df8a7 R09: 1ffffffff1e9bf14
> > R10: dffffc0000000000 R11: fffffbfff1e9bf15 R12: ffffffff8f4df8a0
> > R13: ffffffff8f4df8f0 R14: dffffc0000000000 R15: ffff8880267a9e40
> >  mutex_optimistic_spin kernel/locking/mutex.c:464 [inline]
> >  __mutex_lock_common kernel/locking/mutex.c:602 [inline]
> >  __mutex_lock+0x311/0x1350 kernel/locking/mutex.c:760
> >  rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
> >  inet_rtm_newaddr+0x3b0/0x18b0 net/ipv4/devinet.c:978
> >  rtnetlink_rcv_msg+0x7cf/0xb70 net/core/rtnetlink.c:6954
> >  netlink_rcv_skb+0x205/0x470 net/netlink/af_netlink.c:2552
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
> >  netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
> >  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
> >  sock_sendmsg_nosec net/socket.c:727 [inline]
> >  __sock_sendmsg+0x21c/0x270 net/socket.c:742
> >  __sys_sendto+0x3bd/0x520 net/socket.c:2244
> >  __do_sys_sendto net/socket.c:2251 [inline]
> >  __se_sys_sendto net/socket.c:2247 [inline]
> >  __x64_sys_sendto+0xde/0x100 net/socket.c:2247
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7faade790d5c
> > Code: 2a 5f 02 00 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28 48=
 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 f0 =
ff ff 77 34 89 ef 48 89 44 24 08 e8 70 5f 02 00 48 8b
> > RSP: 002b:00007ffdd2e3b670 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
> > RAX: ffffffffffffffda RBX: 00007faadf514620 RCX: 00007faade790d5c
> > RDX: 0000000000000028 RSI: 00007faadf514670 RDI: 0000000000000003
> > RBP: 0000000000000000 R08: 00007ffdd2e3b6c4 R09: 000000000000000c
> > R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000003
> > R13: 0000000000000000 R14: 00007faadf514670 R15: 0000000000000000
> >  </TASK>
> > rcu: rcu_preempt kthread timer wakeup didn't happen for 10499 jiffies! =
g11321 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
> > rcu:    Possible timer handling issue on cpu=3D0 timer-softirq=3D4286
> > rcu: rcu_preempt kthread starved for 10500 jiffies! g11321 f0x0 RCU_GP_=
WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
> > rcu:    Unless rcu_preempt kthread gets sufficient CPU time, OOM is now=
 expected behavior.
> > rcu: RCU grace-period kthread stack dump:
> > task:rcu_preempt     state:I stack:27224 pid:16    tgid:16    ppid:2   =
   task_flags:0x208040 flags:0x00080000
> > Call Trace:
> >  <TASK>
> >  context_switch kernel/sched/core.c:5325 [inline]
> >  __schedule+0x1798/0x4cc0 kernel/sched/core.c:6929
> >  __schedule_loop kernel/sched/core.c:7011 [inline]
> >  schedule+0x165/0x360 kernel/sched/core.c:7026
> >  schedule_timeout+0x12b/0x270 kernel/time/sleep_timeout.c:99
> >  rcu_gp_fqs_loop+0x301/0x1540 kernel/rcu/tree.c:2083
> >  rcu_gp_kthread+0x99/0x390 kernel/rcu/tree.c:2285
> >  kthread+0x711/0x8a0 kernel/kthread.c:463
> >  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >  </TASK>
> >
> >
> > ---
> > If you want syzbot to run the reproducer, reply with:
> > #syz test: git://repo/address.git branch-or-commit-hash
> > If you attach or paste a git patch, syzbot will apply it before testing=
.
>
> Yet another taprio report.
>
> If taprio can not be fixed, perhaps we should remove it from the
> kernel, or clearly marked as broken.
> (Then ask syzbot to no longer include it)

Agreed on the challenge with taprio.
We need the stakeholders input: Vinicius - are you still working in
this space? Vladimir you also seem to have interest (or maybe nxp
does) in this?
At a minimum, we should mark it as broken unless the stakeholders want
to actively fix these issues.
Would syzbot still look at it if it was marked broken?

cheers,
jamal

