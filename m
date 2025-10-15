Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD836CCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 21:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20EDD8E0057; Wed, 15 Oct 2025 17:36:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E6EA8E0027; Wed, 15 Oct 2025 17:36:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FC7C8E0057; Wed, 15 Oct 2025 17:36:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F04118E0027
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:36:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 73D3E1604C8
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:36:53 +0000 (UTC)
X-FDA: 84001658706.18.91DBBB4
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id A8E6D40016
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:36:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=mojatatu-com.20230601.gappssmtp.com header.s=20230601 header.b=DOsVL+Qb
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760564211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CzSvXM+jlguRu/awbYVDNDd3xNqML1B84uavLhBp4Nk=;
	b=vCmJkXDTu5ZLz2Kk65c0KiP75+LLzSXPf5t3JmgbeA/m0ir5/sZ72ru+ErtdXQj0sz1xy5
	0o7pxtjEU3Wfwd12w3djjAIfPvWRra4wNXctjdZry3/X8FhmjXUIQ8z1y0ywhDVDoDreU6
	tLeA6lof6o8vN1ac+/IFxAC2Js9neCw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=mojatatu-com.20230601.gappssmtp.com header.s=20230601 header.b=DOsVL+Qb;
	spf=none (imf11.hostedemail.com: domain of jhs@mojatatu.com has no SPF policy when checking 209.85.210.170) smtp.mailfrom=jhs@mojatatu.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760564211; a=rsa-sha256;
	cv=none;
	b=MhT6a9go3jKAu9Om+/piZhOENaeQyHromcw5vK45sbcSfy/ZaLVd810xBVPzRXncUbxGBo
	h9/oHV8ySuK0zr0CI8ALdnY4n/4hx4UV/8hcYnbdCW0IN5iLjo5eUbm0stEfiQtq1aOIS7
	zwSsRf4RkIVf/9xZTjz04g3ozoaDJaM=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-781ea2cee3fso105477b3a.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1760564210; x=1761169010; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CzSvXM+jlguRu/awbYVDNDd3xNqML1B84uavLhBp4Nk=;
        b=DOsVL+QbqdXNC5FoB8TXqTj5QvNU6dL3zS8Rxvs5eJMml2kNudcwM7HxPAZjZro7pu
         B6Fg1Edu7uIpHwAYhvjRfkhlYMWwY+hGp9rYalxwrLFcCI8d1oBvkgtiy35Ws3M1Ofjz
         7TaFtMTGpjBihCtelmhS4GCF5d+F8UEVgq+1Zi6ekdhfa1QpJ8Pzh4R8AZQBHu9MGaGH
         fAtYWOF7H3HFYxHy0mGeB52yS2eiYl0r+LFbmyMJ96H0tt/I0uzGuXiYwQINhSqi+iD1
         ySOtSG6JvW0Uvq45IrLfYRTIZ900z64Gfc/j8ViO9dGnfeUdaPQ9BL93jkqC8SEhmIbR
         JUFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760564210; x=1761169010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CzSvXM+jlguRu/awbYVDNDd3xNqML1B84uavLhBp4Nk=;
        b=XJBxWdXbIX1GQ6NX27qdUjVFbxzJYPNtiakGaLikKhQv7Z2uwfweL8qww7ZFs2G7Q5
         H6x3xmXb6vaZg6BcAbCZs7hImtv9JUkJ9/tZcxe8cKuK51aHGJyXIhqCXloOpyA8BhtW
         pgXN1BAgJ+n/Y2oGzHiEmoaUrVPYimMUDDxAKovB70N/+h00AwVyivh3fspC+OrXHtjV
         QJGD/cJUy9/CHTfcc8DLaBwZSRFmsrPbDCZdhbCMDgfljoYN4rQRvvQo5/5I8vXBQKNZ
         NMvgLidOVyN1H5t5u1QRyQ3aIGmAIFtanDBZV65Q09ZcC5Ok6Mz1uTtQR9UebgcuP+th
         MeSA==
X-Forwarded-Encrypted: i=1; AJvYcCVZlH7Yoo4bEhxaxZ09pfBg3AD+3g5ZN47WA6G556ld1vkJnw2w7CfK5bl5yD2x2SSHEI7g7EtzeA==@kvack.org
X-Gm-Message-State: AOJu0YzegxUSQpWwzigYEkNMDhpwEp6YyAIbunnD6q+8J+4C+g9bOeld
	JOtlVn6xZHDkHER6qGl5Me3M3Fq3jbXKnFZp2oFcV8OMuy10JfFEnOBDeW4pXIcnRkNbD2vsbBp
	uZWrZxBY++W7I78wKgl1O582tjjHC2cufbl1DeC4p
X-Gm-Gg: ASbGncswCF22Z+ngCZA+Wc9SOoKFPDNjtzAhEHbwYavo7I9mMjhtGbI7yZXc+LrfKhv
	5UQR1hu4ywQV05R1WwekmtTQ4BC92gDngih00EhNof5hobD3Z/+kVEM1SPTWCL2UqdCPaSD5xGK
	WGjz7xg9xfstbtiH/DdAT/lc4kYV/i42hobPdsctuVwPquEtViwGy/3p+dNOqIFjX5n9hdeGbdY
	909XL5HdPGYfktHkgDjPgxEhZGg3OlOVZ7q3EI/k9uvfXlVYnJ4q4uLG8E9dEIDIkM9Gs95Yxri
	lONCmlSr5L4dvdAJOszgwv0=
X-Google-Smtp-Source: AGHT+IELxj5a7h+o5Luu19pXGQ4VkpPt+FUNnaQnoS6dyUNaqIr/GBMJMif+q0MFMpmlTEAbqOQIKJxaU3dB+8Ubrj0=
X-Received: by 2002:a05:6a20:9392:b0:32b:6f6c:98d4 with SMTP id
 adf61e73a8af0-32da81541eemr40399081637.20.1760564210403; Wed, 15 Oct 2025
 14:36:50 -0700 (PDT)
MIME-Version: 1.0
References: <681a1770.050a0220.a19a9.000d.GAE@google.com> <68ea0a24.050a0220.91a22.01ca.GAE@google.com>
 <CANn89iLjjtXV3ZMxfQDb1bbsVJ6a_Chexu4FwqeejxGTwsR_kg@mail.gmail.com>
 <CAM0EoMnGLqKU7AnsgS00SEgU0eq71f-kiqNniCNyfiyAfNm8og@mail.gmail.com> <87347mmpwp.fsf@intel.com>
In-Reply-To: <87347mmpwp.fsf@intel.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Wed, 15 Oct 2025 17:36:39 -0400
X-Gm-Features: AS18NWDq1L4jsWd86ZGlqYi63dTb-i0V7eW3hYlGtsDWjEV25RTc6xg8okqheEA
Message-ID: <CAM0EoMnWcsgtN++zkOW9zf5QqUg9uNBGTNgf=2JARqarW31wwQ@mail.gmail.com>
Subject: Re: [syzbot] [net?] [mm?] INFO: rcu detected stall in
 inet_rtm_newaddr (2)
To: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Eric Dumazet <edumazet@google.com>, 
	syzbot <syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com>, davem@davemloft.net, 
	dsahern@kernel.org, hdanton@sina.com, horms@kernel.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A8E6D40016
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: sy19zwmunuxbjbxdprfimoid7ic1yuu3
X-HE-Tag: 1760564211-887658
X-HE-Meta: U2FsdGVkX1/16HGByf9AwMxL5UHaYP1XVbVsPEGZNrNHDz3EhtVOid9o9GWAmT7aG6fs3gAtIrI9aldpLy0MKx3WJR3NurjBpTAQJTnxAkNlZVYkvznH6z7MD+iK3xhqNMCnGywCKM7M00s6IAGYnPLLRglP+itRbf9j5VkQmuYwfMZ7Ug0Or/TjzfvXw2UacIKFJ748LNqZMRYDG6B8GdwV4uW+GPGv3bR2bAphHxHkFyfh/edGZjvKggAIq0xOqvivw2tA9VvHeCgk6oY0BYXFMJwxpfiuF9TnroYFAEH2JItXKrK6hTKpiBzFB8kDhUbE9TI2NOD0XpzqKgGkAP268Jdn4o3tFBKb4tY6hQ1MgPEe9CPBJlJwVgpnbxK5tpfGc0yupLmBjkCbtlEFhfNGTv3zxRo7paJxbsDiM32dxeB2w7TOt9b4v1cI8lul+IUKZ9QrEf/CjYlZU5JuSyDRn41VVQkDF9ghiQDPzpMsOzwMh2RGqo4hLaXMqVR1HD2FS9p46qy/p9OgVv2OXky/zsQtonJBntDth5sRMW4BeXhrW5UCDJUi6somisLF5sewgPVP4Edc0FuD9s3YYioKg4aGtpY+yFjgBSAHGAfVkWgHd9TMpf8mR3LqSXiq9+0B9DWY4RjqjNDPVsLCeuvqf2/dwwN50OjqKi2d8AjZHvIfLmpKSuCusnUjovJouwfzWeYwGZkjDDC0nEHSquRRigR1I3IEQwDXYVCmJkwPYHD5YaM+ZloLbbreUSVPXSIqSb++GzUMgVOec32iD7u6Xkti762rO5xvvOSuiOIrOvkZnk2bHfbR8ka86uMhD20AgrgMKgp81s2JVmYBAei4QO8pwBrIBZoc2ULzHLMSEvpWwD3UCuv8v7K9lNPyy9AmF2L+J9KG6qCvoHarq6NrxGdauDPfC76JHEPyJZgo2Ccme9aHuz3dLzEV18olWfsBKKs5Mz+Vz5/VNSp
 yk75x7IC
 +XG/QlaxuT+7wZtYlmBdUp7IJemDjKCRL6zmZssENmPD1g+nNNFXbtOUxykh0rmpeEJVyJ6N7FnTmzkUyyTHZfydeyWuMIXWmjmPVTs/Ypd5u46w98anmaTi9R4pxtCqbQIpEzfOBV+Vgnv7t3EXONFjNFZwx5kHmtjis3Yhs/RzTLeu692XfTWjIdAVWqM3MqGKcWQDAlA78I2qaQtUdUpsgdWjlv8w3L0z3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 5:51=E2=80=AFPM Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Jamal Hadi Salim <jhs@mojatatu.com> writes:
>
> > On Sat, Oct 11, 2025 at 5:42=E2=80=AFAM Eric Dumazet <edumazet@google.c=
om> wrote:
> >>
> >> On Sat, Oct 11, 2025 at 12:41=E2=80=AFAM syzbot
> >> <syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com> wrote:
> >> >
> >> > syzbot has found a reproducer for the following issue on:
> >> >
> >> > HEAD commit:    18a7e218cfcd Merge tag 'net-6.18-rc1' of git://git.k=
ernel...
> >> > git tree:       net-next
> >> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D12504dcd=
980000
> >> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D61ab7fa7=
43df0ec1
> >> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D51cd74c5df=
eafd65e488
> >> > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f90=
9b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> >> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D14d2a5=
42580000
> >> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D142149e2=
580000
> >> >
> >> > Downloadable assets:
> >> > disk image: https://storage.googleapis.com/syzbot-assets/7a01e6dce97=
e/disk-18a7e218.raw.xz
> >> > vmlinux: https://storage.googleapis.com/syzbot-assets/5e1b7e41427f/v=
mlinux-18a7e218.xz
> >> > kernel image: https://storage.googleapis.com/syzbot-assets/69b558601=
209/bzImage-18a7e218.xz
> >> >
> >> > IMPORTANT: if you fix the issue, please add the following tag to the=
 commit:
> >> > Reported-by: syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com
> >> >
> >> > sched: DL replenish lagged too much
> >> > rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> >> > rcu:    0-...!: (2 GPs behind) idle=3D7754/1/0x4000000000000000 soft=
irq=3D15464/15465 fqs=3D1
> >> > rcu:    (detected by 1, t=3D10502 jiffies, g=3D11321, q=3D371 ncpus=
=3D2)
> >> > Sending NMI from CPU 1 to CPUs 0:
> >> > NMI backtrace for cpu 0
> >> > CPU: 0 UID: 0 PID: 5948 Comm: syz-executor Not tainted syzkaller #0 =
PREEMPT(full)
> >> > Hardware name: Google Google Compute Engine/Google Compute Engine, B=
IOS Google 10/02/2025
> >> > RIP: 0010:rb_insert_color_cached include/linux/rbtree.h:113 [inline]
> >> > RIP: 0010:rb_add_cached include/linux/rbtree.h:183 [inline]
> >> > RIP: 0010:timerqueue_add+0x1a8/0x200 lib/timerqueue.c:40
> >> > Code: e7 31 f6 e8 6a 0c de f6 42 80 3c 2b 00 74 08 4c 89 f7 e8 7b 0a=
 de f6 4d 89 26 4d 8d 7e 08 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 <74> 08 4c =
89 ff e8 5e 0a de f6 4d 89 27 4d 85 e4 40 0f 95 c5 eb 07
> >> > RSP: 0018:ffffc90000007cf0 EFLAGS: 00000046
> >> > RAX: 1ffff110170c4f83 RBX: 1ffff110170c4f82 RCX: 0000000000000000
> >> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88805de72358
> >> > RBP: 0000000000000000 R08: ffff88805de72357 R09: 0000000000000000
> >> > R10: ffff88805de72340 R11: ffffed100bbce46b R12: ffff88805de72340
> >> > R13: dffffc0000000000 R14: ffff8880b8627c10 R15: ffff8880b8627c18
> >> > FS:  000055557c657500(0000) GS:ffff888125d0f000(0000) knlGS:00000000=
00000000
> >> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> > CR2: 0000200000000600 CR3: 000000002ee76000 CR4: 00000000003526f0
> >> > Call Trace:
> >> >  <IRQ>
> >> >  __run_hrtimer kernel/time/hrtimer.c:1794 [inline]
> >> >  __hrtimer_run_queues+0x656/0xc60 kernel/time/hrtimer.c:1841
> >> >  hrtimer_interrupt+0x45b/0xaa0 kernel/time/hrtimer.c:1903
> >> >  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1041 [inline=
]
> >> >  __sysvec_apic_timer_interrupt+0x108/0x410 arch/x86/kernel/apic/apic=
.c:1058
> >> >  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 =
[inline]
> >> >  sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1=
052
> >> >  </IRQ>
> >> >  <TASK>
> >> >  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idte=
ntry.h:702
> >> > RIP: 0010:pv_vcpu_is_preempted arch/x86/include/asm/paravirt.h:579 [=
inline]
> >> > RIP: 0010:vcpu_is_preempted arch/x86/include/asm/qspinlock.h:63 [inl=
ine]
> >> > RIP: 0010:owner_on_cpu include/linux/sched.h:2282 [inline]
> >> > RIP: 0010:mutex_spin_on_owner+0x189/0x360 kernel/locking/mutex.c:361
> >> > Code: b6 04 30 84 c0 0f 85 59 01 00 00 48 8b 44 24 08 8b 18 48 8b 44=
 24 48 42 80 3c 30 00 74 0c 48 c7 c7 90 8c fa 8d e8 a7 cd 88 00 <48> 83 3d =
ff 27 5e 0c 00 0f 84 b9 01 00 00 48 89 df e8 41 e0 d5 ff
> >> > RSP: 0018:ffffc900034c7428 EFLAGS: 00000246
> >> > RAX: 1ffffffff1bf5192 RBX: 0000000000000001 RCX: ffffffff819c6588
> >> > RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff8f4df8a0
> >> > RBP: 1ffffffff1e9bf14 R08: ffffffff8f4df8a7 R09: 1ffffffff1e9bf14
> >> > R10: dffffc0000000000 R11: fffffbfff1e9bf15 R12: ffffffff8f4df8a0
> >> > R13: ffffffff8f4df8f0 R14: dffffc0000000000 R15: ffff8880267a9e40
> >> >  mutex_optimistic_spin kernel/locking/mutex.c:464 [inline]
> >> >  __mutex_lock_common kernel/locking/mutex.c:602 [inline]
> >> >  __mutex_lock+0x311/0x1350 kernel/locking/mutex.c:760
> >> >  rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
> >> >  inet_rtm_newaddr+0x3b0/0x18b0 net/ipv4/devinet.c:978
> >> >  rtnetlink_rcv_msg+0x7cf/0xb70 net/core/rtnetlink.c:6954
> >> >  netlink_rcv_skb+0x205/0x470 net/netlink/af_netlink.c:2552
> >> >  netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
> >> >  netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
> >> >  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
> >> >  sock_sendmsg_nosec net/socket.c:727 [inline]
> >> >  __sock_sendmsg+0x21c/0x270 net/socket.c:742
> >> >  __sys_sendto+0x3bd/0x520 net/socket.c:2244
> >> >  __do_sys_sendto net/socket.c:2251 [inline]
> >> >  __se_sys_sendto net/socket.c:2247 [inline]
> >> >  __x64_sys_sendto+0xde/0x100 net/socket.c:2247
> >> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >> >  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
> >> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >> > RIP: 0033:0x7faade790d5c
> >> > Code: 2a 5f 02 00 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28=
 48 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 =
f0 ff ff 77 34 89 ef 48 89 44 24 08 e8 70 5f 02 00 48 8b
> >> > RSP: 002b:00007ffdd2e3b670 EFLAGS: 00000293 ORIG_RAX: 00000000000000=
2c
> >> > RAX: ffffffffffffffda RBX: 00007faadf514620 RCX: 00007faade790d5c
> >> > RDX: 0000000000000028 RSI: 00007faadf514670 RDI: 0000000000000003
> >> > RBP: 0000000000000000 R08: 00007ffdd2e3b6c4 R09: 000000000000000c
> >> > R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000003
> >> > R13: 0000000000000000 R14: 00007faadf514670 R15: 0000000000000000
> >> >  </TASK>
> >> > rcu: rcu_preempt kthread timer wakeup didn't happen for 10499 jiffie=
s! g11321 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
> >> > rcu:    Possible timer handling issue on cpu=3D0 timer-softirq=3D428=
6
> >> > rcu: rcu_preempt kthread starved for 10500 jiffies! g11321 f0x0 RCU_=
GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
> >> > rcu:    Unless rcu_preempt kthread gets sufficient CPU time, OOM is =
now expected behavior.
> >> > rcu: RCU grace-period kthread stack dump:
> >> > task:rcu_preempt     state:I stack:27224 pid:16    tgid:16    ppid:2=
      task_flags:0x208040 flags:0x00080000
> >> > Call Trace:
> >> >  <TASK>
> >> >  context_switch kernel/sched/core.c:5325 [inline]
> >> >  __schedule+0x1798/0x4cc0 kernel/sched/core.c:6929
> >> >  __schedule_loop kernel/sched/core.c:7011 [inline]
> >> >  schedule+0x165/0x360 kernel/sched/core.c:7026
> >> >  schedule_timeout+0x12b/0x270 kernel/time/sleep_timeout.c:99
> >> >  rcu_gp_fqs_loop+0x301/0x1540 kernel/rcu/tree.c:2083
> >> >  rcu_gp_kthread+0x99/0x390 kernel/rcu/tree.c:2285
> >> >  kthread+0x711/0x8a0 kernel/kthread.c:463
> >> >  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
> >> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >> >  </TASK>
> >> >
> >> >
> >> > ---
> >> > If you want syzbot to run the reproducer, reply with:
> >> > #syz test: git://repo/address.git branch-or-commit-hash
> >> > If you attach or paste a git patch, syzbot will apply it before test=
ing.
> >>
> >> Yet another taprio report.
> >>
> >> If taprio can not be fixed, perhaps we should remove it from the
> >> kernel, or clearly marked as broken.
> >> (Then ask syzbot to no longer include it)
> >
> > Agreed on the challenge with taprio.
> > We need the stakeholders input: Vinicius - are you still working in
> > this space? Vladimir you also seem to have interest (or maybe nxp
> > does) in this?
>
> No, I am not working on this space anymore.
>
> I will talk with other Intel folks (and my manager) and see what we can
> do.

I assume your customers are still interested in this working? If yes,
that would be a good pitch to the manager.
In my (extreme) view, another selling point is that there is an
ethical obligation to ensure things continue to work as intended.
Getting patches in is the easy part.

cheers,
jamal

>But if others that find it useful can help even better.
>

