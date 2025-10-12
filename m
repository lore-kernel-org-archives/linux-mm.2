Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 643DBCCD187
	for <linux-mm@archiver.kernel.org>; Sun, 12 Oct 2025 15:53:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4B58E0006; Sun, 12 Oct 2025 11:53:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B95AA8E0002; Sun, 12 Oct 2025 11:53:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A842D8E0006; Sun, 12 Oct 2025 11:53:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 948658E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 11:53:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4459D1DA5D9
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 15:53:08 +0000 (UTC)
X-FDA: 83989906056.04.CB27DFC
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4E29E1C0005
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 15:53:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=mojatatu-com.20230601.gappssmtp.com header.s=20230601 header.b=NRID6pqP
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760284386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3vNK/W2vE5CrWbmOQptlg81Stw1jBqstidM0EFkFfMA=;
	b=rzisMygsqdUGoxk16mU3s67i5Ly/1tIoD28Tdj4LV7Essu4P/E1DZoR6LT/L9WXu27XChF
	0WV7RDffIuFBeORXH/DZjvNPheNiC4RqgKemhqZ33KKdVv3c6WHuTc2WXiED08pcjFKvWW
	oZ5YZStKkFfcG3u235DyO5ohF2K6+Uo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760284386; a=rsa-sha256;
	cv=none;
	b=cUFWGaKOVhGKZk5+LQW1sFx+TY/7fWJHL0cyI6PKpvDImg+53r9WoOUK87HHiRLBTLLjCc
	fzHF//6l3DlX3Lhgmbb3W3JOExHVkIb+e1ghSC5WQ7Au91dJDqgCFhWJk+eQ/TFXbwPr+R
	SwIXx9IpD9ZRtdyClbP7N47icYcFem8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=mojatatu-com.20230601.gappssmtp.com header.s=20230601 header.b=NRID6pqP;
	dmarc=none;
	spf=none (imf18.hostedemail.com: domain of jhs@mojatatu.com has no SPF policy when checking 209.85.215.169) smtp.mailfrom=jhs@mojatatu.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b67ae7e76abso635792a12.3
        for <linux-mm@kvack.org>; Sun, 12 Oct 2025 08:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1760284385; x=1760889185; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3vNK/W2vE5CrWbmOQptlg81Stw1jBqstidM0EFkFfMA=;
        b=NRID6pqPUVg+jkhKjAO3xNbvCetaMtMW1goFEihMPbS2EOXk+gIZlG5bjnJ2EG+J0B
         4RWvE9xc3mt3rBhNZWfJXwwb7/IQVznS3IEsj2PO/tfU4feNMDL9puhlv1sKuCQxSWJO
         NHDnJGC/QyDU8dE12MzsxTHaTIMKf1If42uI83cQapuMsxz4b3i82eWu94AGL3UeQVvv
         AMMLAqi9IlazttBLPw3NBgd8bKHGiC4vFsEkFtD4mcs2R6eZM3uvMeqoWPdnkgFcACzQ
         acpwlhHqyNHpzslC8r+hvR/jNIdworU7hlJEzej0mycymzHqnazqzMQM5SyynELc7JBn
         mu+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760284385; x=1760889185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3vNK/W2vE5CrWbmOQptlg81Stw1jBqstidM0EFkFfMA=;
        b=Dk3Tvlc10MlUUwD6PJnS7gGYZFJJpDtwRUfhUfj5+VjDF5WtHol7Sj3czMUMJxfYQP
         oHnxaUVY9hNXhlqlUokFLa0+hbp5C4YZf03H1rGwBOEomKcbJGjq5lGOHtOY0iFjG4El
         +ErGeQ67BsNeUkssZbR4ZzINcvL9Ahsj1eHxd0FSXV6CGynj5tHiChX/y5c8WcgbOj1p
         AdJNqMlyFG7oev9vR5cNpFaZgXSUw60AF650DzKnrBZGL8zatD8NqtovUQHfYIz0YB6p
         BXXLWXt69x3ANrw5RWWxdYRtwDVt1gvdA6Sejfs+Ank/B5JZbGsJfGOzBWnIylyAmLDr
         u9UQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGTcYGSqwJe5HZueU3xUGHKjsUcgH9niyqaPDFoXsv0HgDtN49YskmlJcrcInsAxmWEfIsGXM9jQ==@kvack.org
X-Gm-Message-State: AOJu0Yxp8npd1e37il+jon6+aK28Bclbdp9yedFP8pg2YZ0JCcf3sllk
	nvsIXpZq1gNb+S5qHNZi5/RKy1AuBTrWyDhT0XsZJRmsbSdwza5PRHRRS3uIk/vPuqFKFAo3VKw
	43V6aIFAl32Svc8k0c519fLdIVP6gjTe58+OI0iDt
X-Gm-Gg: ASbGncs3GYtv9qsjAcvawIFGuwBk5haiATbVsMSunWmfUJ+lNBvnNUtbmIbMx5KfEz6
	v8HBEmYbeFEAyadASTTXx4JDl2+0VR0Wf98rGb8529RmLUaAaaPyipoi9ZBNMhTvHLNtidwA5vR
	9+wEh33Vrosnfi6pzZR2mmSPbYOwpBwAi6aH6OIaTP5b3DtHtfEQUwJl4+TQhsJV9DBteuAvYFH
	oLITz4jco2+hxEWx+ohszp8QJeVZ+Vp95i6kccO497Q0gqvFRgsRj5w7xeg0AhK/9S3zwzQTRPZ
	i1e0zcq96d7F
X-Google-Smtp-Source: AGHT+IHxJtS5I9ErUleO7vIDv0xZFGkNk841TYZctOcE+MKe/RoTQlBh65eDZvjqgIUYgCqACIrwNf+6cqJVjXJV/UM=
X-Received: by 2002:a17:902:cf04:b0:267:b6f9:2ce with SMTP id
 d9443c01a7336-2902736dff9mr237505235ad.41.1760284385140; Sun, 12 Oct 2025
 08:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <681a1770.050a0220.a19a9.000d.GAE@google.com> <68ea0a24.050a0220.91a22.01ca.GAE@google.com>
 <CANn89iLjjtXV3ZMxfQDb1bbsVJ6a_Chexu4FwqeejxGTwsR_kg@mail.gmail.com> <CAM0EoMnGLqKU7AnsgS00SEgU0eq71f-kiqNniCNyfiyAfNm8og@mail.gmail.com>
In-Reply-To: <CAM0EoMnGLqKU7AnsgS00SEgU0eq71f-kiqNniCNyfiyAfNm8og@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sun, 12 Oct 2025 11:52:54 -0400
X-Gm-Features: AS18NWDNSPnjrErWLLE3rdMuhlIqaiuldMhXvgJdXjdU8KW8o9PP9GYWiDABppA
Message-ID: <CAM0EoMmK7TJ4w_heeMuD+YmUdMyEz7VWKY+a+qMO2UN4GYZ5jQ@mail.gmail.com>
Subject: Re: [syzbot] [net?] [mm?] INFO: rcu detected stall in
 inet_rtm_newaddr (2)
To: Eric Dumazet <edumazet@google.com>
Cc: syzbot <syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com>, 
	Vinicius Costa Gomes <vinicius.gomes@intel.com>, davem@davemloft.net, dsahern@kernel.org, 
	hdanton@sina.com, horms@kernel.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E29E1C0005
X-Rspamd-Server: rspam02
X-Stat-Signature: w46kzk7swkis7rpgpqnp1d7kqn8h9bxo
X-HE-Tag: 1760284386-913138
X-HE-Meta: U2FsdGVkX1/V8zWlhYcTFLAtSFhlquqPQ3NB0eGOkuLj+GblberK1F+15z72dgYHPUX+M1pmMToJS/c9CTvi/LDUpE9KWW3udXXOMdPxkzRmeVNisJN3PCOTatqAbt860PmfIhj9bQri3wUBA9BTNhZXiGmh1E/xktvt+ENDYZRv+Khk8hpFSSz/zuhDlLs1/61X6y2FeU1Bbq6alCGlBCjP9wvJg+wsIw9QUjydPdKhhs9N7dmfXlD5d3NxEEBTsuQOQaEuQWKerSxU8Ozqwn1ylMvFqlgm9mgCJERNVkzbqdPnZJHDAw+tq2kZ/QpWUyMmI1uQbPihl3rqPqytgmLMzpOmps+YhkeXmCkS4KjJb1jx+KJiacJY1Jm4hj3Wut76gjsOZPb0g3sCv0BkQb9EjkRYj/uViQFzlKRPYNuBEIUPLYeH5m73+/e+cTAZLoKorlKuCHLXMnnaKzCD1S24bwnIME6p2LgwSh5brhC9LfHisUBX+WB7FJxdBwxQnNb87GIshbjdsWNKhu8Uvm7GUE/kXCMdx+rgKv7IrDov+1x79WDhv0XrWE0pqaS4hkg2gGShtdFH90UpshVfm+5gUxM+mDigslwN8jpl2VokCYptRkdFUxHLPwFs93vWhn8kRgqqX6csoG+xTWuRvUIYg8ku62oBBXlfYoOj5F4GEgaTPMjdw+iZEd/4LYEadsz8LhmGtRd+fM9CKD/lQn8DvZkNOAK1FrtlxkGg7PFWe1oWJ53gUe9Gi1FxOj4z8jJjKaAqs2q0KxeL/fevscNLoE1JxYvZ8zLMv2S+y6tbQN+ocr3FXmyECGVcTVg5iLyp1Sx0oU2vicqkPZVIs5SjPZmJko2cmCCvd7hBqo0LRoTahbnJOUAGoyyzW1h1aJb1CdqHmCWB1JifSm/2gEFyIPuxfMb2aS5sBGR6vRj8vhI46BdS/7WVqj9LdleSgx8y9zMrWaP3aqpkCab
 lVdDYJ2S
 sOo1aMsSXJSNqf2qCHsnZpJXu4CAbXDTERKggOmgrdYQbNhGQx19f77IQkjrAdIMKKziDYeWTa4wO3Mzz2LEqok8gCvCIHG/l/62J9+30E3xX5TEORtEml4VX9Zz1qIpSe2h0WptNzpOgul36/X9l0IqBDlLS6kjxKC+BL+TwOSAw+z3pvppxP+0FXEbIBNioYHEsHz/wALpzSWN7L4k4kElT8pH/FH5cp4guOCxm4ob+zLVCHY8h32LrbLqu0+mcTURIb/zQbNHDnzS9hcUuquJxr4/slM0IwH9L5XdprgpSQNw5FnIn0MYb8Un8GfIJw8Am6oF+rOMay+t++/oUC+LMQZn89Rq2Bmp/dvl/SK3Ttq4qsfIYKjwSVUBkshAb9cb3fov5E5DK8y4x6ojNad+HDfKq9D5gxbKW60WqXx5YIl8iazGRgrI7dgBzUN8ImO8MLm3KnRcmNwch+VJkEX4cmy2CvkL8w2/3NeuMfOztH+hQgUqgMXcL9GyUP6YfzzBiH6fAvw4S/89+ZZrqcxiBhVmV/QnxTYjBqCLeLJHPo1do6xN/fXDt3phL7eF+lbZmf/hFK8UzxsJ3ahQ1CMA8H9m4FYVYx+vFlY/QbLlLsOhDq93Sw3dqzQBGh5sOeXLnJqnM1WtXV6XXxiOL88flOlfocjZJPY9H7FG/cx8G3QXaYB3QrL+Pcld3rUzTnRKFrR5sXzShUwYhPg5AJNt6efy58uyLjo/Njoxs+xtiYBDptbG+vRDq/X6jhwq6T40KCGyDMpdUsiktuUvy+omoVHb9XnPpCmk7HvcEOUHxD0maoa5oH/u1Ed58U5OSRSlZssE5zsva0SRK7kEHeSEoxds9w1HHjiOIxnrMQcObp4ZPKhvLoyu5euexPPqqr0vTEvH4HASjTS/IzRCGzTnrmJ52DMZ8BTd3G34mK+oVFak93/8Ov1lkVyWXlwlX56Zuok7ZTo1JoPSV2TF/p9BTvMf7
 7bEaxXwA
 lBMbvROerQc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 12, 2025 at 11:46=E2=80=AFAM Jamal Hadi Salim <jhs@mojatatu.com=
> wrote:
>
> On Sat, Oct 11, 2025 at 5:42=E2=80=AFAM Eric Dumazet <edumazet@google.com=
> wrote:
> >
> > On Sat, Oct 11, 2025 at 12:41=E2=80=AFAM syzbot
> > <syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com> wrote:
> > >
> > > syzbot has found a reproducer for the following issue on:
> > >
> > > HEAD commit:    18a7e218cfcd Merge tag 'net-6.18-rc1' of git://git.ke=
rnel...
> > > git tree:       net-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D12504dcd9=
80000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D61ab7fa74=
3df0ec1
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D51cd74c5dfe=
afd65e488
> > > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909=
b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D14d2a54=
2580000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D142149e25=
80000
> > >
> > > Downloadable assets:
> > > disk image: https://storage.googleapis.com/syzbot-assets/7a01e6dce97e=
/disk-18a7e218.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/5e1b7e41427f/vm=
linux-18a7e218.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/69b5586012=
09/bzImage-18a7e218.xz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> > > Reported-by: syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com
> > >
> > > sched: DL replenish lagged too much
> > > rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> > > rcu:    0-...!: (2 GPs behind) idle=3D7754/1/0x4000000000000000 softi=
rq=3D15464/15465 fqs=3D1
> > > rcu:    (detected by 1, t=3D10502 jiffies, g=3D11321, q=3D371 ncpus=
=3D2)
> > > Sending NMI from CPU 1 to CPUs 0:
> > > NMI backtrace for cpu 0
> > > CPU: 0 UID: 0 PID: 5948 Comm: syz-executor Not tainted syzkaller #0 P=
REEMPT(full)
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BI=
OS Google 10/02/2025
> > > RIP: 0010:rb_insert_color_cached include/linux/rbtree.h:113 [inline]
> > > RIP: 0010:rb_add_cached include/linux/rbtree.h:183 [inline]
> > > RIP: 0010:timerqueue_add+0x1a8/0x200 lib/timerqueue.c:40
> > > Code: e7 31 f6 e8 6a 0c de f6 42 80 3c 2b 00 74 08 4c 89 f7 e8 7b 0a =
de f6 4d 89 26 4d 8d 7e 08 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 <74> 08 4c 8=
9 ff e8 5e 0a de f6 4d 89 27 4d 85 e4 40 0f 95 c5 eb 07
> > > RSP: 0018:ffffc90000007cf0 EFLAGS: 00000046
> > > RAX: 1ffff110170c4f83 RBX: 1ffff110170c4f82 RCX: 0000000000000000
> > > RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88805de72358
> > > RBP: 0000000000000000 R08: ffff88805de72357 R09: 0000000000000000
> > > R10: ffff88805de72340 R11: ffffed100bbce46b R12: ffff88805de72340
> > > R13: dffffc0000000000 R14: ffff8880b8627c10 R15: ffff8880b8627c18
> > > FS:  000055557c657500(0000) GS:ffff888125d0f000(0000) knlGS:000000000=
0000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 0000200000000600 CR3: 000000002ee76000 CR4: 00000000003526f0
> > > Call Trace:
> > >  <IRQ>
> > >  __run_hrtimer kernel/time/hrtimer.c:1794 [inline]
> > >  __hrtimer_run_queues+0x656/0xc60 kernel/time/hrtimer.c:1841
> > >  hrtimer_interrupt+0x45b/0xaa0 kernel/time/hrtimer.c:1903
> > >  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1041 [inline]
> > >  __sysvec_apic_timer_interrupt+0x108/0x410 arch/x86/kernel/apic/apic.=
c:1058
> > >  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [=
inline]
> > >  sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:10=
52
> > >  </IRQ>
> > >  <TASK>
> > >  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idten=
try.h:702
> > > RIP: 0010:pv_vcpu_is_preempted arch/x86/include/asm/paravirt.h:579 [i=
nline]
> > > RIP: 0010:vcpu_is_preempted arch/x86/include/asm/qspinlock.h:63 [inli=
ne]
> > > RIP: 0010:owner_on_cpu include/linux/sched.h:2282 [inline]
> > > RIP: 0010:mutex_spin_on_owner+0x189/0x360 kernel/locking/mutex.c:361
> > > Code: b6 04 30 84 c0 0f 85 59 01 00 00 48 8b 44 24 08 8b 18 48 8b 44 =
24 48 42 80 3c 30 00 74 0c 48 c7 c7 90 8c fa 8d e8 a7 cd 88 00 <48> 83 3d f=
f 27 5e 0c 00 0f 84 b9 01 00 00 48 89 df e8 41 e0 d5 ff
> > > RSP: 0018:ffffc900034c7428 EFLAGS: 00000246
> > > RAX: 1ffffffff1bf5192 RBX: 0000000000000001 RCX: ffffffff819c6588
> > > RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff8f4df8a0
> > > RBP: 1ffffffff1e9bf14 R08: ffffffff8f4df8a7 R09: 1ffffffff1e9bf14
> > > R10: dffffc0000000000 R11: fffffbfff1e9bf15 R12: ffffffff8f4df8a0
> > > R13: ffffffff8f4df8f0 R14: dffffc0000000000 R15: ffff8880267a9e40
> > >  mutex_optimistic_spin kernel/locking/mutex.c:464 [inline]
> > >  __mutex_lock_common kernel/locking/mutex.c:602 [inline]
> > >  __mutex_lock+0x311/0x1350 kernel/locking/mutex.c:760
> > >  rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
> > >  inet_rtm_newaddr+0x3b0/0x18b0 net/ipv4/devinet.c:978
> > >  rtnetlink_rcv_msg+0x7cf/0xb70 net/core/rtnetlink.c:6954
> > >  netlink_rcv_skb+0x205/0x470 net/netlink/af_netlink.c:2552
> > >  netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
> > >  netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
> > >  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
> > >  sock_sendmsg_nosec net/socket.c:727 [inline]
> > >  __sock_sendmsg+0x21c/0x270 net/socket.c:742
> > >  __sys_sendto+0x3bd/0x520 net/socket.c:2244
> > >  __do_sys_sendto net/socket.c:2251 [inline]
> > >  __se_sys_sendto net/socket.c:2247 [inline]
> > >  __x64_sys_sendto+0xde/0x100 net/socket.c:2247
> > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > >  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
> > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > RIP: 0033:0x7faade790d5c
> > > Code: 2a 5f 02 00 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28 =
48 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 f=
0 ff ff 77 34 89 ef 48 89 44 24 08 e8 70 5f 02 00 48 8b
> > > RSP: 002b:00007ffdd2e3b670 EFLAGS: 00000293 ORIG_RAX: 000000000000002=
c
> > > RAX: ffffffffffffffda RBX: 00007faadf514620 RCX: 00007faade790d5c
> > > RDX: 0000000000000028 RSI: 00007faadf514670 RDI: 0000000000000003
> > > RBP: 0000000000000000 R08: 00007ffdd2e3b6c4 R09: 000000000000000c
> > > R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000003
> > > R13: 0000000000000000 R14: 00007faadf514670 R15: 0000000000000000
> > >  </TASK>
> > > rcu: rcu_preempt kthread timer wakeup didn't happen for 10499 jiffies=
! g11321 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
> > > rcu:    Possible timer handling issue on cpu=3D0 timer-softirq=3D4286
> > > rcu: rcu_preempt kthread starved for 10500 jiffies! g11321 f0x0 RCU_G=
P_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
> > > rcu:    Unless rcu_preempt kthread gets sufficient CPU time, OOM is n=
ow expected behavior.
> > > rcu: RCU grace-period kthread stack dump:
> > > task:rcu_preempt     state:I stack:27224 pid:16    tgid:16    ppid:2 =
     task_flags:0x208040 flags:0x00080000
> > > Call Trace:
> > >  <TASK>
> > >  context_switch kernel/sched/core.c:5325 [inline]
> > >  __schedule+0x1798/0x4cc0 kernel/sched/core.c:6929
> > >  __schedule_loop kernel/sched/core.c:7011 [inline]
> > >  schedule+0x165/0x360 kernel/sched/core.c:7026
> > >  schedule_timeout+0x12b/0x270 kernel/time/sleep_timeout.c:99
> > >  rcu_gp_fqs_loop+0x301/0x1540 kernel/rcu/tree.c:2083
> > >  rcu_gp_kthread+0x99/0x390 kernel/rcu/tree.c:2285
> > >  kthread+0x711/0x8a0 kernel/kthread.c:463
> > >  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
> > >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> > >  </TASK>
> > >
> > >
> > > ---
> > > If you want syzbot to run the reproducer, reply with:
> > > #syz test: git://repo/address.git branch-or-commit-hash
> > > If you attach or paste a git patch, syzbot will apply it before testi=
ng.
> >
> > Yet another taprio report.
> >
> > If taprio can not be fixed, perhaps we should remove it from the
> > kernel, or clearly marked as broken.
> > (Then ask syzbot to no longer include it)
>
> Agreed on the challenge with taprio.
> We need the stakeholders input: Vinicius - are you still working in
> this space? Vladimir you also seem to have interest (or maybe nxp
> does) in this?

+ Vladmir..

> At a minimum, we should mark it as broken unless the stakeholders want
> to actively fix these issues.
> Would syzbot still look at it if it was marked broken?
>
> cheers,
> jamal

