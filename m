Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01E85D38FE6
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 671D16B0088; Wed, 14 Jan 2026 11:23:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61F7B6B008A; Wed, 14 Jan 2026 11:23:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51E3C6B008C; Wed, 14 Jan 2026 11:23:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3F4086B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:23:28 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 79160C1FEB
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:23:26 +0000 (UTC)
X-FDA: 84331089612.27.C214FDC
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6F87EA0012
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:23:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ThtwxDkE;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768407804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ikvxKJIuLP7xPyw5aj9CliT/WHnLxLhC8YGnX6DGna8=;
	b=WkmkeTvanRxlJYsYt7wlEHfqzrtn+xdMq5E/3qZHS+xT5BRCLg5LIULoYAw0Y3VWNRwKrC
	3F3u2AIw5bXACrm0WmC+eB2gTX5UyTRI8dvquXFA89/icq6boNm97GXrHJMh/3Yo/3hVt0
	fY+48433BPohgo9bF55uEx4f29DpRog=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ThtwxDkE;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768407804; a=rsa-sha256;
	cv=none;
	b=dWsJ9vCh9RD7bPsyOT86T99jPAe8KILR5kNF5NVNz2i8ssRKauhPQvU/+KkMr8MNU6UeN8
	7Bc0AM9ElmYVBzUQvvNUTS2aA0p1euaC4ZGytNuxW9TNuTSMmestStxti08+waOeyWTHkx
	n/JjyqdhxJdcOQVySZEvkM3Iuw67Z6c=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b8765b80a52so3548066b.2
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768407803; x=1769012603; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ikvxKJIuLP7xPyw5aj9CliT/WHnLxLhC8YGnX6DGna8=;
        b=ThtwxDkEM0cIBByfq00bN+30wVWXqeTEYyKZM+rNypc7mJrh7q1RrwoNp5EgR1gy6k
         gODnxKAXI6O1hVp4ZKsS4Q9sZCfYWxj+eRDLmKdix41DfvjfYstbVEgwKh7RLYaAYwoJ
         S3/K/V9k7W1bh0NcRbURe2YxJi/mVPj0oSLw1iJlE7iyEYHCvzStM3EnXpAwnT94l0eP
         2fgj1fr5l/ITew/NOayu/oUhKJ8c834VWDsEGFoOc304pcEL3EJ3X+e/RVX8cR95A7aL
         DkfEI/vuN4ciNxEYRZjmykcXokIEt32okYS7VbxTwwNRtJB9xsB9fSB/Gm7eaus7203p
         p0Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768407803; x=1769012603;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ikvxKJIuLP7xPyw5aj9CliT/WHnLxLhC8YGnX6DGna8=;
        b=evmo5n9kkGjqgec3EnssKlhTFEiSzIJR5PhV729QENmZn7gX/br1GKWhiRpTBpnZ5U
         gn/4gpmc8DwE/+yybJWnr7G0VQUn0DlXCAHN9wQQxj1RUebJ2xoJwnY13UYxet+A2G7N
         qriH29OktVW6SfXTiypXs424c6uu8QWPmQX1YIsT32g8Hr8DRDqGkntp0ks17Cmnt2ex
         8yZuI1jvGHhmJdnMJXT/BHR3eqP4KXNPaQPw/J55gXHq6vA0NYZFl2g7EEUShJuKBm+N
         w+68MS60h35+sHmk4e7y+dsXLYva8jpE3AdvEroy/dBIMIEWRDWCNPuQOB4C8UeVS53S
         gqQw==
X-Gm-Message-State: AOJu0YyJjr5KBXUkHsvw3XZUMduPlgXRoMPyUt50GsZD6WeiazF+UpM5
	Ekhfk2Luxl89hp8T5H7MOvRkw2xWGQw9eFUkix0HejbGMYP00H6laexxQ18Nv5dnCiPZSyP8wOA
	siKodb69s4yucMnczsnnyjyQwANhQiVA=
X-Gm-Gg: AY/fxX6z6gOvFmAHovjc+1dQRlr3WJJOXA8l//uSnO4DwzWaQquvdS2pIiYvyv1/Akk
	P2lB7H8gfw0xdi/7zq1koVJ84hxKCIXxnIzu/jLys7taMvEAsA6Ctg7+6iMG+5/0Y4jxOVBa6MN
	3nfcgWihsfiCq8eaJXy284RwO/34qrCfcytAfhT1XgFbIlMRX+C9JvHRr6HJhC/BQUJafNgXCfT
	CpBK+XwL/Pe/nMExSmQDXfA7qzAfdV0MKONYX0w8gUvnAW4+4k+59Qurc5HMtzW3g/WH2ch+8mg
	KHWiBbKRTkkI+sDIejLht+N+cmmt
X-Received: by 2002:a17:906:730f:b0:b76:63b8:7394 with SMTP id
 a640c23a62f3a-b87677e100fmr199785666b.51.1768407802544; Wed, 14 Jan 2026
 08:23:22 -0800 (PST)
MIME-Version: 1.0
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
 <20251220-swap-table-p2-v5-14-8862a265a033@tencent.com> <aWeZ4LmfwiS9iwYF@ly-workstation>
In-Reply-To: <aWeZ4LmfwiS9iwYF@ly-workstation>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 15 Jan 2026 00:22:45 +0800
X-Gm-Features: AZwV_QhBWPQyAd5qCFCLWs0OG7Cd_OMO0uTc5Ks-lryX8Aohf2JMaesrVs9Q1xI
Message-ID: <CAMgjq7AQWswq1Hv_vbPnpNgVuzaRFyGttwm+euE3S=C6+iFHaA@mail.gmail.com>
Subject: Re: [PATCH v5 14/19] mm, swap: cleanup swap entry management workflow
To: "Lai, Yi" <yi1.lai@linux.intel.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6F87EA0012
X-Stat-Signature: 7iqponaadyydgz3yom6jejhyn13xnxrr
X-HE-Tag: 1768407804-155976
X-HE-Meta: U2FsdGVkX1/sKzGn05++iz5jzFOrUChAxfvQ/g74UwXlLiAaHi8Fq8vT+aveciWBAi/fMwh0FG2QDSPknvhLwujsadp5gLS46d22pVVfPxSxgmFztQ2X/QLWrLHU6RV/J6Gy/zbWjZzF+CRdCSpENa6yQU3uwRg8y+b5EnWhn0lg0vXy5jK2bZLolopa0RkzLU2zGWW4bIa0bUvFkOZPUhq2UEB8jaq5CSLGF2p3i6ki0aGosQmCneWEBYHWXb2fUk3Tyjs2hsYmRxenpDN9d2XWDVrQHq2veFYzEOXSxKaC7h6em7wTMwWX0l7uwwrHzBJnf3OB0/oL1JyqlcjJzt7C9qNSLSWteAwHOv6qDhwnNsG6exlkH86Fr9HUoNxuC7vyg8YTcJZNgYezqijpF3HXIRd1JzpCP0pnAlf5lnK+uc8jT9DmDv6NpVPHBn9ZCW61BqB2aVrqx84obywr15wxcn+RPu1sOhs7KLSv+g963eB/aBhj8jCwrk4aLU2zrT8jnvugVxUovLM3cKj5VO2BUEK8BJFl/OJnHor4UoywnA+aSKTn4q38qr+GItsKinUmmzMyewW40raMs3HR5WU41toSTSmaJs9PTdqGEoHgpz4a2aile2YibzH1adb7nThx7VrdjdIrdJbyx/m4BZPJd6OJlClA663EtOpAr4NP12XnjSTwcQQyt3Cg7oYObJhdOBdNoeAkdb87Qg6rhis6VoYtkk6BbmznwvAR95GNDKCuTGvXpCHLEvjG7DGDJ/fU53HAh1kwHsnA5l+vBMuAnaHLIeziiwVR1CaGjHJQleLBZEhCGHhEi7jRhv6enaReUPBS6ZzuuzKV4BjmNb222ArbB7q6k8LBooxC8ufyIawVvkMe3ZzLvi6zHPm7NFkDiJ4z5lN0brHqaDDItolduIdKhvNXoacVVa9w4xW3QI4zxLHT6cI2e1vQF5j7dOhJIfoJtwzpqrc7D+F
 LVjTdti7
 Ofmhx4D7gn7EGlvkCd/LX/jAVxx2+sI6ntEuMym8TJgxZiHaJCjW6nEXZ4UZOOogKa5LgPdyopafTysXoKeFtOPrkE6QMSNShNicMCZKSG3uxIMYOJ7X2v9Ps9GEPK8mkIZu4AWIDjBzkd61WAHfkwFGYRjzFC3xGIwNcY7W/7yZ2PlKT7q+WilaMVlkDmc3znEvO2taetHcj40LQTiC95yy7Kz+bu5T7YHltjLaDEzxw996Py+QEQxIZUm20PEhxmm0jR5HGDkoEkCiHd6BfzofCsohSQCUD6hnmDk5IVlxN1Ha+T2SEOm2z34FIy7iZoRvnOmBazidS57ykL4lN1Sd8lsTgY6k3+oyYdvoflypoXTLWi3z5xcJUwqSKWoY1Z8RNh9RXYN9SCxdQOR05a9KVtQThjfTv8qscq/Sh9puTYJ9z4JKzei+jT+wfDN8lWUfL0iQCARy8NcyvYPMNEijhCX9zI6C5j9PWRbwG7zZYyNAQAmye8rPAn/dyS7QQmINpL8JaZ+yylAJrV8DScOU4s8zxlMGEbHkM8m9mOKDgjQ6F5tAecN28LGdjaLXT/5FUhyAR45reoVm1eYOk413z3UhbxNHuGNG4CImsrW6C93Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 9:28=E2=80=AFPM Lai, Yi <yi1.lai@linux.intel.com> w=
rote:
>
> Hi Kairui Song,
>
> Greetings!
>
> I used Syzkaller and found that there is possible deadlock in swap_free_h=
ibernation_slot in linux-next next-20260113.
>
> After bisection and the first bad commit is:
> "
> 33be6f68989d mm. swap: cleanup swap entry management workflow
> "
>
> All detailed into can be found at:
> https://github.com/laifryiee/syzkaller_logs/tree/main/260114_102849_swap_=
free_hibernation_slot
> Syzkaller repro code:
> https://github.com/laifryiee/syzkaller_logs/tree/main/260114_102849_swap_=
free_hibernation_slot/repro.c
> Syzkaller repro syscall steps:
> https://github.com/laifryiee/syzkaller_logs/tree/main/260114_102849_swap_=
free_hibernation_slot/repro.prog
> Syzkaller report:
> https://github.com/laifryiee/syzkaller_logs/tree/main/260114_102849_swap_=
free_hibernation_slot/repro.report
> Kconfig(make olddefconfig):
> https://github.com/laifryiee/syzkaller_logs/tree/main/260114_102849_swap_=
free_hibernation_slot/kconfig_origin
> Bisect info:
> https://github.com/laifryiee/syzkaller_logs/tree/main/260114_102849_swap_=
free_hibernation_slot/bisect_info.log
> bzImage:
> https://github.com/laifryiee/syzkaller_logs/raw/refs/heads/main/260114_10=
2849_swap_free_hibernation_slot/bzImage_0f853ca2a798ead9d24d39cad99b0966815=
c582a
> Issue dmesg:
> https://github.com/laifryiee/syzkaller_logs/blob/main/260114_102849_swap_=
free_hibernation_slot/0f853ca2a798ead9d24d39cad99b0966815c582a_dmesg.log
>
> "
> [   62.477554] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   62.477802] WARNING: possible recursive locking detected
> [   62.478059] 6.19.0-rc5-next-20260113-0f853ca2a798 #1 Not tainted
> [   62.478324] --------------------------------------------
> [   62.478549] repro/668 is trying to acquire lock:
> [   62.478759] ffff888011664018 (&cluster_info[i].lock){+.+.}-{3:3}, at: =
swap_free_hibernation_slot+0x13e/0x2a0
> [   62.479271]
> [   62.479271] but task is already holding lock:
> [   62.479519] ffff888011664018 (&cluster_info[i].lock){+.+.}-{3:3}, at: =
swap_free_hibernation_slot+0xfa/0x2a0
> [   62.479984]
> [   62.479984] other info that might help us debug this:
> [   62.480293]  Possible unsafe locking scenario:
> [   62.480293]
> [   62.480565]        CPU0
> [   62.480686]        ----
> [   62.480809]   lock(&cluster_info[i].lock);
> [   62.481010]   lock(&cluster_info[i].lock);
> [   62.481205]
> [   62.481205]  *** DEADLOCK ***
> [   62.481205]
> [   62.481481]  May be due to missing lock nesting notation
> [   62.481481]
> [   62.481802] 2 locks held by repro/668:
> [   62.481981]  #0: ffffffff87542e28 (system_transition_mutex){+.+.}-{4:4=
}, at: lock_system_sleep+0x92/0xb0
> [   62.482439]  #1: ffff888011664018 (&cluster_info[i].lock){+.+.}-{3:3},=
 at: swap_free_hibernation_slot+0xfa/0x0
> [   62.482936]
> [   62.482936] stack backtrace:
> [   62.483131] CPU: 0 UID: 0 PID: 668 Comm: repro Not tainted 6.19.0-rc5-=
next-20260113-0f853ca2a798 #1 PREEMPT(l
> [   62.483143] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S rel-1.16.0-0-gd239552ce722-prebuilt.q4
> [   62.483151] Call Trace:
> [   62.483156]  <TASK>
> [   62.483160]  dump_stack_lvl+0xea/0x150
> [   62.483195]  dump_stack+0x19/0x20
> [   62.483206]  print_deadlock_bug+0x22e/0x300
> [   62.483215]  __lock_acquire+0x1325/0x2210
> [   62.483226]  lock_acquire+0x170/0x2f0
> [   62.483234]  ? swap_free_hibernation_slot+0x13e/0x2a0
> [   62.483249]  _raw_spin_lock+0x38/0x50
> [   62.483267]  ? swap_free_hibernation_slot+0x13e/0x2a0
> [   62.483279]  swap_free_hibernation_slot+0x13e/0x2a0
> [   62.483291]  ? __pfx_swap_free_hibernation_slot+0x10/0x10
> [   62.483303]  ? locks_remove_file+0xe2/0x7f0
> [   62.483322]  ? __pfx_snapshot_release+0x10/0x10
> [   62.483331]  free_all_swap_pages+0xdd/0x160
> [   62.483339]  ? __pfx_snapshot_release+0x10/0x10
> [   62.483346]  snapshot_release+0xac/0x200
> [   62.483353]  __fput+0x41f/0xb70
> [   62.483369]  ____fput+0x22/0x30
> [   62.483376]  task_work_run+0x19e/0x2b0
> [   62.483391]  ? __pfx_task_work_run+0x10/0x10
> [   62.483398]  ? nsproxy_free+0x2da/0x5b0
> [   62.483410]  ? switch_task_namespaces+0x118/0x130
> [   62.483421]  do_exit+0x869/0x2810
> [   62.483435]  ? do_group_exit+0x1d8/0x2c0
> [   62.483445]  ? __pfx_do_exit+0x10/0x10
> [   62.483451]  ? __this_cpu_preempt_check+0x21/0x30
> [   62.483463]  ? _raw_spin_unlock_irq+0x2c/0x60
> [   62.483474]  ? lockdep_hardirqs_on+0x85/0x110
> [   62.483486]  ? _raw_spin_unlock_irq+0x2c/0x60
> [   62.483498]  ? trace_hardirqs_on+0x26/0x130
> [   62.483516]  do_group_exit+0xe4/0x2c0
> [   62.483524]  __x64_sys_exit_group+0x4d/0x60
> [   62.483531]  x64_sys_call+0x21a2/0x21b0
> [   62.483544]  do_syscall_64+0x6d/0x1180
> [   62.483560]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [   62.483584] RIP: 0033:0x7fe84fb18a4d
> [   62.483595] Code: Unable to access opcode bytes at 0x7fe84fb18a23.
> [   62.483602] RSP: 002b:00007fff3e35c928 EFLAGS: 00000246 ORIG_RAX: 0000=
0000000000e7
> [   62.483610] RAX: ffffffffffffffda RBX: 00007fe84fbf69e0 RCX: 00007fe84=
fb18a4d
> [   62.483615] RDX: 00000000000000e7 RSI: ffffffffffffff80 RDI: 000000000=
0000001
> [   62.483620] RBP: 0000000000000001 R08: 0000000000000000 R09: 000000000=
0000020
> [   62.483624] R10: 00007fff3e35c7d0 R11: 0000000000000246 R12: 00007fe84=
fbf69e0
> [   62.483629] R13: 00007fe84fbfbf00 R14: 0000000000000001 R15: 00007fe84=
fbfbee8
> [   62.483640]  </TASK>
> "
>
> Hope this cound be insightful to you.
>
> Regards,
> Yi Lai
>
> ---
>
> If you don't need the following environment to reproduce the problem or i=
f you
> already have one reproduced environment, please ignore the following info=
rmation.
>
> How to reproduce:
> git clone https://gitlab.com/xupengfe/repro_vm_env.git
> cd repro_vm_env
> tar -xvf repro_vm_env.tar.gz
> cd repro_vm_env; ./start3.sh  // it needs qemu-system-x86_64 and I used v=
7.1.0
>   // start3.sh will load bzImage_2241ab53cbb5cdb08a6b2d4688feb13971058f65=
 v6.2-rc5 kernel
>   // You could change the bzImage_xxx as you want
>   // Maybe you need to remove line "-drive if=3Dpflash,format=3Draw,reado=
nly=3Don,file=3D./OVMF_CODE.fd \" for different qemu version
> You could use below command to log in, there is no password for root.
> ssh -p 10023 root@localhost
>
> After login vm(virtual machine) successfully, you could transfer reproduc=
ed
> binary to the vm by below way, and reproduce the problem in vm:
> gcc -pthread -o repro repro.c
> scp -P 10023 repro root@localhost:/root/
>
> Get the bzImage for target kernel:
> Please use target kconfig and copy it to kernel_src/.config
> make olddefconfig
> make -jx bzImage           //x should equal or less than cpu num your pc =
has
>
> Fill the bzImage file into above start3.sh to load the target kernel in v=
m.
>
>
> Tips:
> If you already have qemu-system-x86_64, please ignore below info.
> If you want to install qemu v7.1.0 version:
> git clone https://github.com/qemu/qemu.git
> cd qemu
> git checkout -f v7.1.0
> mkdir build
> cd build
> yum install -y ninja-build.x86_64
> yum -y install libslirp-devel.x86_64
> ../configure --target-list=3Dx86_64-softmmu --enable-kvm --enable-vnc --e=
nable-gtk --enable-sdl --enable-usb-redir --enable-slirp
> make
> make install
>

Thanks Lai!

The issue is with the WARN_ON I added... Didn't notice that the
WARN_ON requires ci lock, so we better just remove that.

Following change should fix the issue you reported:
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 85bf4f7d9ae7..8c0f31363c1f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2096,7 +2096,6 @@ void swap_free_hibernation_slot(swp_entry_t entry)

        ci =3D swap_cluster_lock(si, offset);
        swap_entry_put_locked(si, ci, entry, 1);
-       WARN_ON(swap_entry_swapped(si, entry));
        swap_cluster_unlock(ci);

        /* In theory readahead might add it to the swap cache by accident *=
/

---

swap_entry_swapped requires CI lock. There wasn't any WARN_ON before,
it was added to just ensure things worked as expected, really not
needed.

