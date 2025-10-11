Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DAB8CCD184
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 09:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2B08E0019; Sat, 11 Oct 2025 05:42:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D530A8E0005; Sat, 11 Oct 2025 05:42:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C419D8E0019; Sat, 11 Oct 2025 05:42:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AFC118E0005
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 05:42:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 674361605A8
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 09:42:52 +0000 (UTC)
X-FDA: 83985344184.13.C9FC117
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8F63D100006
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 09:42:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hNbF8qm3;
	spf=pass (imf05.hostedemail.com: domain of edumazet@google.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760175770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2KA5u3TUp00NYLA35LfzmhRHb51uTtRNeQp/w7ddecs=;
	b=XllnsieOPhru3+s5iCeewPvrgs7OqFFuP9lDmaW4c7TFREtB0kKubX28DYwpzB3ar+5Nlw
	Zar5lhRkmpycUI4Mk3K+u4GlpjFFULH2Wl53E9iPkdjkloItcBOIBLv1h2VMf6t4Du2SnB
	ScuqQFV0cDpcs6D9eV/4NPijDUk2pAU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760175770; a=rsa-sha256;
	cv=none;
	b=OtSbrUM+XrpCu/2qtTW71afCzFw1axuT3o4MtSqqv9m/wxdj/O5P/B3N0xDVp0qP0A/8z3
	lVB+B/bbRVQ3nNHh3UvLwZ3bkXV88SmrOcY6ZKXK5FBbA5obUBzrP332qcuMRQf/JreyYa
	zcSUlH2LUeR0hz31BKFKoMvFfuhGWVY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hNbF8qm3;
	spf=pass (imf05.hostedemail.com: domain of edumazet@google.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-85c66a8a462so458254485a.0
        for <linux-mm@kvack.org>; Sat, 11 Oct 2025 02:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760175770; x=1760780570; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2KA5u3TUp00NYLA35LfzmhRHb51uTtRNeQp/w7ddecs=;
        b=hNbF8qm35UFy7E7qWfjyhVexa+IeU/OX0itfDOxhfXWDJ0ES/fHU5rQuzT6iemvwM+
         qrFCyVLn8OUBrfIkSLySVlgfjSUpj+9o7Y1FpKDVGbX+DZV8dihO5wOOl0CM10yFOIHW
         Qx/96ddIi7/vcR3PUi/FLTaj6v3fD5OmdkBi3btzlG5CzxvPM/w1MWEj7tpau7ARGuZI
         Yn+XWSf2MwVySh58sFpULdwOvA1ppXsX0I1mvBG1nsOkEZ9AUF60rg9KiIQgJuzeOZ3y
         N5We68xWKgl4FeIVRLgsOCgFGfwmOd5wkJLm/N3ncdgiAUQyu5KoVD6PnS/ZmbkIl6Hc
         +arQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760175770; x=1760780570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2KA5u3TUp00NYLA35LfzmhRHb51uTtRNeQp/w7ddecs=;
        b=MRynBfu2zpwIL8p+giiLiHoxcHasnZrQ4iKLkOVwD2/Jdlg19b27t3X5WpRh4Yv6JJ
         MXV5XMKstOL9XefjlwAsQGB601rw1v8OzDwDIz57AZmdPP0Z+ts/6CW4UHjdPMAGMabs
         UaTnPSHwMZezIk6qR9tk1mhp6ganukXdaJN7Oaw+kricc3Yx01XD9jr6KJuolAiL+rlV
         Bz4KJDorUStE8w4SOS6P4pRKdtpE5y0FGreidZ+AY4QQQNUUWP3C1ILI0GV2WhiPoXtO
         utQZACMjdNW916LzyGWSbb+FhXCSbIkAK/SBaW1wxkbHEgJKxV8UhXe4R2OnL8T8coM5
         JMzg==
X-Forwarded-Encrypted: i=1; AJvYcCWPna6cAVAFnrKS7hNyz9VBv7/I5ic7UoxW+2CegTOl50DvFzEZRbn2yzlJLh++BAOZ2vE/RNnuBA==@kvack.org
X-Gm-Message-State: AOJu0YxUy/Mds37A4+Zg3mMGoWlC//nb2G+2QWzecQvmgdGH+KHTk1u9
	XiAo/jrin1e8e97UFoXoyYcd8UX28bhZ47LQM4Tb6fjE814wzpkw10DxSq7d30WbU0dBDgz644p
	fD9EOlOfss9DzSKkeVn5UKYBWrTRd31IwXM0db7Lf
X-Gm-Gg: ASbGnctilLkTunMWLqKwse93ZqM+Wx4wxntuDQTiF1MwWCnZ2T47z2tZdyabmo37RGW
	3zvzoIRrzEhB3oiQTkeDZ4TweuWitHCIA10k5Sgl65VEN3lWsbEPsfZBX50usWtbxq496lyWTD7
	UAOkDegXDLEXFOyHllTWZ+mn9tHv5qVk5AgbHeWXsTSwVwVefg3ebaKY0bM6pZzS5/aCikq5pgI
	N0PrdyuAp5X9AX6AsYVGEHseaceqt+c
X-Google-Smtp-Source: AGHT+IEED7dHBeVXIcW+XT93z7Hf3i3zMcQ6Vt38katNZs1vD6UoQfiDEwwBOYw5pzjJNb5ZZ/ccNgaRmmC/Kn11320=
X-Received: by 2002:a05:622a:1301:b0:4e0:296e:8cbb with SMTP id
 d75a77b69052e-4e6ead5c713mr201176921cf.64.1760175769177; Sat, 11 Oct 2025
 02:42:49 -0700 (PDT)
MIME-Version: 1.0
References: <681a1770.050a0220.a19a9.000d.GAE@google.com> <68ea0a24.050a0220.91a22.01ca.GAE@google.com>
In-Reply-To: <68ea0a24.050a0220.91a22.01ca.GAE@google.com>
From: Eric Dumazet <edumazet@google.com>
Date: Sat, 11 Oct 2025 02:42:37 -0700
X-Gm-Features: AS18NWA0areIK1P_LAC0ovg1dEL8hxEocjKD533OSOIsICc3MFc3HHnf4RoapQo
Message-ID: <CANn89iLjjtXV3ZMxfQDb1bbsVJ6a_Chexu4FwqeejxGTwsR_kg@mail.gmail.com>
Subject: Re: [syzbot] [net?] [mm?] INFO: rcu detected stall in
 inet_rtm_newaddr (2)
To: syzbot <syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com>, 
	Vinicius Costa Gomes <vinicius.gomes@intel.com>, Jamal Hadi Salim <jhs@mojatatu.com>
Cc: davem@davemloft.net, dsahern@kernel.org, hdanton@sina.com, 
	horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org, pabeni@redhat.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: jjoa3fq1xyajipiotpfpcnszjj56oero
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F63D100006
X-HE-Tag: 1760175770-723816
X-HE-Meta: U2FsdGVkX19YKqblQaCe9a91ufY74kzRSrk//dZiwpVapowCdjOhgzfoIEIdx9OXZUFy9YaPjx/Rcz2pxj0HnpaiQJL0Fz/GGr1+pS/+ObCclRC/VnKdKoTbnGv8w2eU83DpWX96Pd0URG74TXfbb6zOONvtQ3dVvOc4gQQibyArmKBSUmTEnrzjmHoNAUAj5Ss/UQuPFLoM23AJaEYxqaiSkqns9q2U9f0x2k2IgIce56EZFJzDqzMkzAK5NoYtWW8KDbiqj3+fnLgYH/y0bWk+3gl54JhXjFyqBjA3tm7PNIE7AbiFBieUh1H9J8hGlLU2nUvm8rmbVqYjXGeONFxDw7GjG3olVow7MV7653EUjZpYyg8zVeYBHHChe26ApGYbxLUUyjBSg/bOCdMAw0jcZDvvJbggvYPpBUysR30afmkICwNmUi3VhWD827HH7BXH8AgJPsV1LC2CmrDlWDZZHIHgXATpyrZaoZxF0bmWXYwMk1TNS0qWKCBjIiMsAh5osQzDzn4Cy86tmwJhC7jS/CuIgF6jtKEj71GY5C6jflR8PNfbZbAO1BE0W2lawbMknS5sOp2YGPl8QJsDER6ne0s5lwFeWQsWREPlpEphJ1RBOkYVjWfl7nF9duW++vnAPZ37hG8dIvUigk4BG6oq45qlkj2BOBrSs4MaqoWnuaGHsIEKq+S2ewObxpT+fbslJcIENUjSUP5kQJLrNFcR3QMdqn6ZS4RahVSe8+etCzGkTTVWp85PqoYsk4DprjZDMlFbj/vU/2FH6MV7TmR5lIX+Mw6KEDl1pnJiKMImtYcB0ON8AFwmp4YWsCuCHVyMhFZZrdZVh0gWvDwYTsBCBQ5xg9YaX4Fy4Cs2edSI6bLQvRiVE9bRRCzpTFhTPVuGYDQ/tooe8NiLsoR/bRvf/1DJp7Rrxui6xTvHyYGniC1axg1lwovAAiqY7J+viDJoFs4RNLocmsqH35E
 frXPZCl0
 tuzeXNDt5422/YbRbxCfLui+tODIzy9Cgnqbj4BkED4cWl0MqoTxa2gJYBVwLWT2948rbAzia7k2SeXLOZBG+Wv6hZ59TCw3nuMviWEWOncEO4pHAuAj1T4vEyTLLZNTLB1a+8Z9QMP81A06mHw4Y7pq+GQoQaKqE+nDdaAokRuT2Hziru7TI9B3u/Zpcvom3FECbrmhW7pAVGJIRNMnEIWpJjfEeybdkd1XgEj9tXtK+uR4PubfxypvrJXBxH8RtjquJp38gUP2ifXZhF/RMJTdDubFjbF/kfJWpvG8G90k4fsoB3dAAQDvOObbkp54RdoJ9AI/tJFnbr8r7UEgtcvMDK1oU+rSwk+mhtnyTZ1PzdXvDiDfW1bBttYe/MIwHbePn7OuKDFSv0m56KvU+X+U+1gVmhbEC2mE0x/UgPIbtJUM8ei6r1rljCbsSOJJDO5b1kF/koet6zdMKeBy5yAoI6//idWIXfT/7vvNstyKz4jmFuC+RcON6amPM1pFNRLRwi/WDuu7kDxej5lmk+YwfI4QpVjHfTAIf2r9HcYrqV52ZoN8znQrHImVo0otok5Lz3+1OZzfyaGnp2zZhH1WzZH51tIH+/FZwOQmuIIMDB5RTLuVsp9DFrGHaxWiRU5784Agiu1gqGCY2JcdagydP9PHFxdXpYlj16VvOjPm4c6FazryFf5Bc2Xxx7+ilTEFiKF90OxJrOwr+HIyfBPVnFt/aol5uxGx451C6bbY6G8ZI47xNNMzGaI0Gr6+IwXV5nlPAjLjWW1/O/gp6LNtEtMBRgnm8Wm5HSOergBzcpWTq50+v6K2hOdewzh3mUUPFsJDmFxtbUs/4oiBnNFoO2jaEv9kxhwAEag6SeyshCeSlzPAOFRADVyC1oC4qZF+c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 11, 2025 at 12:41=E2=80=AFAM syzbot
<syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    18a7e218cfcd Merge tag 'net-6.18-rc1' of git://git.kernel=
...
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D12504dcd98000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D61ab7fa743df0=
ec1
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D51cd74c5dfeafd6=
5e488
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b797=
6-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D14d2a542580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D142149e258000=
0
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/7a01e6dce97e/dis=
k-18a7e218.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/5e1b7e41427f/vmlinu=
x-18a7e218.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/69b558601209/b=
zImage-18a7e218.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com
>
> sched: DL replenish lagged too much
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> rcu:    0-...!: (2 GPs behind) idle=3D7754/1/0x4000000000000000 softirq=
=3D15464/15465 fqs=3D1
> rcu:    (detected by 1, t=3D10502 jiffies, g=3D11321, q=3D371 ncpus=3D2)
> Sending NMI from CPU 1 to CPUs 0:
> NMI backtrace for cpu 0
> CPU: 0 UID: 0 PID: 5948 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 10/02/2025
> RIP: 0010:rb_insert_color_cached include/linux/rbtree.h:113 [inline]
> RIP: 0010:rb_add_cached include/linux/rbtree.h:183 [inline]
> RIP: 0010:timerqueue_add+0x1a8/0x200 lib/timerqueue.c:40
> Code: e7 31 f6 e8 6a 0c de f6 42 80 3c 2b 00 74 08 4c 89 f7 e8 7b 0a de f=
6 4d 89 26 4d 8d 7e 08 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 <74> 08 4c 89 ff=
 e8 5e 0a de f6 4d 89 27 4d 85 e4 40 0f 95 c5 eb 07
> RSP: 0018:ffffc90000007cf0 EFLAGS: 00000046
> RAX: 1ffff110170c4f83 RBX: 1ffff110170c4f82 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88805de72358
> RBP: 0000000000000000 R08: ffff88805de72357 R09: 0000000000000000
> R10: ffff88805de72340 R11: ffffed100bbce46b R12: ffff88805de72340
> R13: dffffc0000000000 R14: ffff8880b8627c10 R15: ffff8880b8627c18
> FS:  000055557c657500(0000) GS:ffff888125d0f000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000600 CR3: 000000002ee76000 CR4: 00000000003526f0
> Call Trace:
>  <IRQ>
>  __run_hrtimer kernel/time/hrtimer.c:1794 [inline]
>  __hrtimer_run_queues+0x656/0xc60 kernel/time/hrtimer.c:1841
>  hrtimer_interrupt+0x45b/0xaa0 kernel/time/hrtimer.c:1903
>  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1041 [inline]
>  __sysvec_apic_timer_interrupt+0x108/0x410 arch/x86/kernel/apic/apic.c:10=
58
>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [inli=
ne]
>  sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1052
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.=
h:702
> RIP: 0010:pv_vcpu_is_preempted arch/x86/include/asm/paravirt.h:579 [inlin=
e]
> RIP: 0010:vcpu_is_preempted arch/x86/include/asm/qspinlock.h:63 [inline]
> RIP: 0010:owner_on_cpu include/linux/sched.h:2282 [inline]
> RIP: 0010:mutex_spin_on_owner+0x189/0x360 kernel/locking/mutex.c:361
> Code: b6 04 30 84 c0 0f 85 59 01 00 00 48 8b 44 24 08 8b 18 48 8b 44 24 4=
8 42 80 3c 30 00 74 0c 48 c7 c7 90 8c fa 8d e8 a7 cd 88 00 <48> 83 3d ff 27=
 5e 0c 00 0f 84 b9 01 00 00 48 89 df e8 41 e0 d5 ff
> RSP: 0018:ffffc900034c7428 EFLAGS: 00000246
> RAX: 1ffffffff1bf5192 RBX: 0000000000000001 RCX: ffffffff819c6588
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff8f4df8a0
> RBP: 1ffffffff1e9bf14 R08: ffffffff8f4df8a7 R09: 1ffffffff1e9bf14
> R10: dffffc0000000000 R11: fffffbfff1e9bf15 R12: ffffffff8f4df8a0
> R13: ffffffff8f4df8f0 R14: dffffc0000000000 R15: ffff8880267a9e40
>  mutex_optimistic_spin kernel/locking/mutex.c:464 [inline]
>  __mutex_lock_common kernel/locking/mutex.c:602 [inline]
>  __mutex_lock+0x311/0x1350 kernel/locking/mutex.c:760
>  rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
>  inet_rtm_newaddr+0x3b0/0x18b0 net/ipv4/devinet.c:978
>  rtnetlink_rcv_msg+0x7cf/0xb70 net/core/rtnetlink.c:6954
>  netlink_rcv_skb+0x205/0x470 net/netlink/af_netlink.c:2552
>  netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
>  netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
>  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg+0x21c/0x270 net/socket.c:742
>  __sys_sendto+0x3bd/0x520 net/socket.c:2244
>  __do_sys_sendto net/socket.c:2251 [inline]
>  __se_sys_sendto net/socket.c:2247 [inline]
>  __x64_sys_sendto+0xde/0x100 net/socket.c:2247
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7faade790d5c
> Code: 2a 5f 02 00 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28 48 8=
b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 f0 ff=
 ff 77 34 89 ef 48 89 44 24 08 e8 70 5f 02 00 48 8b
> RSP: 002b:00007ffdd2e3b670 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 00007faadf514620 RCX: 00007faade790d5c
> RDX: 0000000000000028 RSI: 00007faadf514670 RDI: 0000000000000003
> RBP: 0000000000000000 R08: 00007ffdd2e3b6c4 R09: 000000000000000c
> R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000003
> R13: 0000000000000000 R14: 00007faadf514670 R15: 0000000000000000
>  </TASK>
> rcu: rcu_preempt kthread timer wakeup didn't happen for 10499 jiffies! g1=
1321 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
> rcu:    Possible timer handling issue on cpu=3D0 timer-softirq=3D4286
> rcu: rcu_preempt kthread starved for 10500 jiffies! g11321 f0x0 RCU_GP_WA=
IT_FQS(5) ->state=3D0x402 ->cpu=3D0
> rcu:    Unless rcu_preempt kthread gets sufficient CPU time, OOM is now e=
xpected behavior.
> rcu: RCU grace-period kthread stack dump:
> task:rcu_preempt     state:I stack:27224 pid:16    tgid:16    ppid:2     =
 task_flags:0x208040 flags:0x00080000
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5325 [inline]
>  __schedule+0x1798/0x4cc0 kernel/sched/core.c:6929
>  __schedule_loop kernel/sched/core.c:7011 [inline]
>  schedule+0x165/0x360 kernel/sched/core.c:7026
>  schedule_timeout+0x12b/0x270 kernel/time/sleep_timeout.c:99
>  rcu_gp_fqs_loop+0x301/0x1540 kernel/rcu/tree.c:2083
>  rcu_gp_kthread+0x99/0x390 kernel/rcu/tree.c:2285
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
>
> ---
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.

Yet another taprio report.

If taprio can not be fixed, perhaps we should remove it from the
kernel, or clearly marked as broken.
(Then ask syzbot to no longer include it)

