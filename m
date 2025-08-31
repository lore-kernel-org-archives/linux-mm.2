Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB86ACA0FFE
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 02:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29D406B0011; Sat, 30 Aug 2025 22:33:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 227146B0012; Sat, 30 Aug 2025 22:33:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EEFB6B0022; Sat, 30 Aug 2025 22:33:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E68616B0011
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 22:33:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 35ED858742
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:33:35 +0000 (UTC)
X-FDA: 83835481590.19.FD33F72
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8A73440009
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:33:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3fLSzaAkbAAEtz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.80 as permitted sender) smtp.mailfrom=3fLSzaAkbAAEtz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756607613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=M8/eCfebWptm/izG/8pd7XBVIkecBB7c+/s/QAvGCOI=;
	b=1tnDRMczOnvkuUEbGTzDu44u+ev3nmM3Syfy6bn87vFC3SglyTA4LqpfA3m8mhejEg3IiW
	dea17TvvTD53EZDiauC0f80bYBLEYhpB2evMawsTDvDfmWJefM4og3lGU+3NpGh/v2H3qZ
	mV9PSBzu2TR/baXGbpm/yYROF5yLDkI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3fLSzaAkbAAEtz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.80 as permitted sender) smtp.mailfrom=3fLSzaAkbAAEtz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756607613; a=rsa-sha256;
	cv=none;
	b=w9+jWuysB6U7FTGSFd9x7zfgwfVm5vJOWKRmIoG611mVqezSUZMTNWAn5TGu098blsfpOR
	ePB7L8Bvd3q2Tr53WMF+gs467AQ/Hs1t2IXvx4aXR8sv9FktuCDJNJxyTULH9Cnk/Fmsi5
	uXiM9ht1qVD/pdvVD/sYJ1Xip1T3qdk=
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-887094bba6bso768090939f.2
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 19:33:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756607612; x=1757212412;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M8/eCfebWptm/izG/8pd7XBVIkecBB7c+/s/QAvGCOI=;
        b=ars+M4BkVejlVpqw2IJKXAtDMxWXzhpdgdYKeRMl8EXjTb3x0zR4gl6dAzaqpeBX/E
         gkDJaBIlhZBoKnZ4nSTINUux0/Yt6RPTFuSvemVyVdIke0jBzWXfst5hzcGyyrLw68xE
         ipCfXOuElIpxx/Bae0aWHHmUnkRaRtGOfmZe0rxau/tRbbGDckm+8POtiTA5TWngLJBs
         29tbLfFgSj/Oh6K+DPaT4/RKJbzEq7lxK5tZXCT7uneW82GUHl0AVp/U3c0BMDcYV+bt
         rTsgJWjvm1iRGRY/2YzEvfKmNFEbCOwWkLUNjwpKDgKm1ShbYDBSRC8x903sOlltlSBo
         St2Q==
X-Forwarded-Encrypted: i=1; AJvYcCX9FlNF4Nwl5IurWOgs/EIl6/Q/d31LtEPAvTwcGpOX33m0DhzxFfZ7CHm/YqZS8S157XshcjFnRg==@kvack.org
X-Gm-Message-State: AOJu0YzXoFPH7yLJk+0FuCMESBVkAM5gc9GA/kmRUH95NVdjsM4Azkf1
	yM6IK3p6BVeAKqAT9AVzFvLwfMaVjmChvSteKkku2YGD+YrN27VJNL22bjoCVC7WW+kjvRVPpYE
	685TrPXF1Th6SXc6/rKMZ16Mhmoih2vXew8ufk134tb+54cHtk+No003xXrI=
X-Google-Smtp-Source: AGHT+IE5EXL6VS9qGgFeFexTMe+rMpaRXBiF6hosTNIRWPfXcRgHWVWMxf8MJ1H5zaEJMsltHzhKwn4HV+w0EWWNhXuZoDMS8aY2
MIME-Version: 1.0
X-Received: by 2002:a05:6602:27cb:b0:883:f419:e3a8 with SMTP id
 ca18e2360f4ac-8871f432d12mr986185639f.7.1756607612715; Sat, 30 Aug 2025
 19:33:32 -0700 (PDT)
Date: Sat, 30 Aug 2025 19:33:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b3b47c.a00a0220.1337b0.002b.GAE@google.com>
Subject: [syzbot] [mm?] INFO: rcu detected stall in sys_madvise (2)
From: syzbot <syzbot+455cf6d72dfed822de56@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: wm9qe8ryduezjabsehnga6ttenrspghw
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A73440009
X-Rspamd-Server: rspam01
X-HE-Tag: 1756607613-104361
X-HE-Meta: U2FsdGVkX1/EJ3VZ96pGvJDCKJxXnomahHSUsRp8xk3D2gVFLjSMbGDOmMvPhCioH+uEwPDoqO0oqrd7S20j7BMgGjxWvBxQzOhzrAfarvYa3fNfLt3XHM4qLnE8MJuRujafydymlW5/hO7RQRuyIbBH7dHqkaueNUz6KLobhAZFj4mEHZlYKArNl7a8xYfW2PY5hbx2AEgsyZ6Bl217PnX7GZ5k3hj4kDi131bq3HGLhTckinlYybRrwAvgnSe4pLUS13acft3nDpDXtwS52Oze7lTBZbh392jWTgOGFalR42gyO3Q4gub0ah7ADQq88nGtYBNS1N27Jp/mgGWaRHevnfEicBkEkWQz+vv954I46547xECMOjSVElB0K0ylT7p70fPDaePfHtqEDrA//BpBTeCNNpxa6zXtIIbK54Kldq5gmx5rPVR3oJi/x9MRhz066HWc3PDwr3prEhZW+VIGgiU/PCy0qh8mQXvDP5xZ3S83CqqPTo+ZVZLV+/Wjfq57o1iz/hkpse3jqiT29F5vYFH8qNnkSPIJYNVIlQK6qgH8g7rlIp34/2OVxLt2jif73pHYP8XGJCOp+cqi7kHyKPX5aOdRUc80n16i1hOyQqcxKUiALEKlUm+4+N9vMAxakEekJ+pXMXkD1GCvfeAgOUHAEa6KuGCZKunvmjv8XQZE+eIADNiz66D5hk7hm8INRw61eu1WvqgtgsKKzel7Ob3q2+4pmPkvzB3dAAKYptkxla4LVpbMqNKPQKjFHkWu56haFTlKGatnFebtuq41qTZeC/6GX+bDf9gV6b+4xIOQInd/ws9cLNqk/h27rX03c9a8t4qZeTjGjcXlRhoUeYw7ttFb+gCQn/SwCGYUtxB7Cq5O1pWwyGeaTdPzqLwwPej7RaJl8GC8OH6mby0pb/MkHWsTWRSy/eFiK0+JZGmKElho1e4SD4vmoq7jnX6guEM0waUpur3cILf
 JqKsCjYj
 62aFoscguE1db9717fiwpe/wobFgT1Esz0KuNSHneEUtn6Y8m3DSfamKW2InqvCOkWhRALv4LTsiLelo+UnieuKkKubO+z0flcZXcmew96SpeaGe/sBlZFzKuFECRpjaSMbfOioAp08MUHyHkUrVQJP75diD3coqlGdzVsWezb6GXkSjRRgpg10eAH10zQLMUbgY8nRZ0VNeXc2gy28IuR8qrTJDBN6wvdqrwRjJt/KzAGQm805SDbbrK/BvTsY2+Jt/CC4GbGqcJw/iH6K+Lsq5jbvapGPPusQs2oe4tGgYHfj/16Ea/s6eaYTGznRY26SCG0vVxamSUAT8KpQzKjBuF2g72ffPqyGIVShnq5d8ntqJcvtk7B8sQpFG8FW9nNM24gYFqV/iUU28Mw+iEiIdcosGd1oSWQHvG5FTfPlzPqEUMnM/8Jm5/0ev0uyOp/F88EoxmCc8dKoJrBA80IsDBt3lhFB43mgEL4vpkObkBBdkQi8atRHSIeLNuhbCopO15OhscqEk7DULZE0zKNQZIjfINfctUNZEPIffWs/9RTq2+W2E4ANY8aNT5AgjGmkDEjDeYBGY0drGwCJB1B7IhqFPj/OgcZuNweJa0noZf9gZ9keMeTbwcK/b9iuMp6hynFOGLm1IH350haStxAvqXPMRonP4OkwV5whdifZ8UBUXQC/ebekhm4Nm1crjtyFCIbwJ/16GuzEFaAQqUlCz1aVqEr/OO/YdOwind2Sg3gRCjS/nZNxIMb3T3Yn5OKV3DiypmBFbT9kH8uX0potN8pSe+BsJUskNFtB/IMXchGKhiB1MxRHCSRnRozqajWI1nHCTwaIdbCYZqpkB8QW6ovPgPfK3WmtC6sAOgCbIHYQ1Iq7dcHSZOmKajnH0SBfh4iYihVmkHm2S0hY2Vl95njwvDtFqygRgu7PzhIEc1BfO0+g2SHa++Xto0H1MBhBOiqgbtCsxtxFiXn2RWsWBETMWM
 yMUs1+AP
 D6M25B/cEOyEhXRpeifEaqED2yu/t4lFDNJtd8vQUxoRKzIUkXKyZUWmRCycVUm6ibFHUDSMKAB43QYU65Rnh3gHtmtYzrXboALIAAMZGxGJMCM1fYNqkLvQ2IVUjwM2QdBpQC0rEsol2BKxFhsofTDCkw9ro9kdILPeeJcwpP7avxftpLLdbgE3hHr1EyY+QLHOYxyiEfsiBbbx7OR/bD59tlnSd/pOkBqBwoT5nFkcDhHzEPEpiG8WEKQAqySYoRXBSFZjikaU9yjgzzuzG8LRCmNRxjLlGW5z4rEKpaZYKzvkV8Yjigtn98nD6jVSEkoRIIXI+mbV/afyx3rcd1QJU0i5Fd0maIbuMdBs3PUgVvX6hvxzoOrPwT381L37G/i0zdmIpkROIevcch9rPuTkikn99QTJJbWvRGCTVfweIuPgxr6Vv5NpgMKVLJx/IdIzWJr+LBgKt0T3wGiyJxAC7ep3oFbZlnshE5J6CG/uDPlZVpuJroNTJOwdpWK5I1tJxNyNZsbk2nbTePoRG6qqbNWZj1NM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    dfc0f6373094 Merge tag 'erofs-for-6.17-rc2-fixes' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15580da2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc3f2c190ebad30b
dashboard link: https://syzkaller.appspot.com/bug?extid=455cf6d72dfed822de56
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4dfa56dd97cf/disk-dfc0f637.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e381d6bdc1d0/vmlinux-dfc0f637.xz
kernel image: https://storage.googleapis.com/syzbot-assets/182bfdad6b5a/bzImage-dfc0f637.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+455cf6d72dfed822de56@syzkaller.appspotmail.com

bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P16208/2:b..l P16191/3:b..l
rcu: 	(detected by 1, t=10502 jiffies, g=85289, q=304 ncpus=1)
task:syz.0.1939      state:R  running task     stack:24088 pid:16191 tgid:16191 ppid:5863   task_flags:0x400640 flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
 preempt_schedule_common+0x44/0xc0 kernel/sched/core.c:7145
 preempt_schedule_thunk+0x16/0x30 arch/x86/entry/thunk.S:12
 __raw_spin_unlock include/linux/spinlock_api_smp.h:143 [inline]
 _raw_spin_unlock+0x3e/0x50 kernel/locking/spinlock.c:186
 spin_unlock include/linux/spinlock.h:391 [inline]
 filemap_map_pages+0xe15/0x1670 mm/filemap.c:3791
 do_fault_around mm/memory.c:5531 [inline]
 do_read_fault mm/memory.c:5564 [inline]
 do_fault mm/memory.c:5707 [inline]
 do_pte_missing+0xe36/0x3ba0 mm/memory.c:4234
 handle_pte_fault mm/memory.c:6052 [inline]
 __handle_mm_fault+0x152a/0x2a50 mm/memory.c:6195
 handle_mm_fault+0x589/0xd10 mm/memory.c:6364
 faultin_page mm/gup.c:1144 [inline]
 __get_user_pages+0x551/0x34a0 mm/gup.c:1446
 __get_user_pages_locked mm/gup.c:1712 [inline]
 get_dump_page+0x257/0x3d0 mm/gup.c:2212
 dump_user_range+0x195/0xb70 fs/coredump.c:1364
 elf_core_dump+0x2929/0x3b60 fs/binfmt_elf.c:2085
 coredump_write fs/coredump.c:1049 [inline]
 vfs_coredump+0x2ba2/0x56d0 fs/coredump.c:1168
 get_signal+0x22e3/0x26d0 kernel/signal.c:3019
 arch_do_signal_or_restart+0x8f/0x790 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop kernel/entry/common.c:40 [inline]
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 irqentry_exit_to_user_mode+0x12a/0x270 kernel/entry/common.c:73
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0033:0x401000
RSP: 002b:000000000000000a EFLAGS: 00010282
RAX: 0000000000000003 RBX: 00007f0e941b5fa0 RCX: 00007f0e93f8ebe9
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000020003b46
RBP: 00007f0e94011e19 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0e941b6038 R14: 00007f0e941b5fa0 R15: 00007ffe733e96c8
 </TASK>
task:syz.0.1943      state:R  running task     stack:24568 pid:16208 tgid:16207 ppid:5863   task_flags:0x400940 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
 preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7288
 irqentry_exit+0x36/0x90 kernel/entry/common.c:197
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:__ref_is_percpu include/linux/percpu-refcount.h:174 [inline]
RIP: 0010:percpu_ref_tryget_many include/linux/percpu-refcount.h:243 [inline]
RIP: 0010:percpu_ref_tryget include/linux/percpu-refcount.h:266 [inline]
RIP: 0010:obj_cgroup_tryget include/linux/memcontrol.h:767 [inline]
RIP: 0010:__get_obj_cgroup_from_memcg+0x90/0x230 mm/memcontrol.c:2618
Code: 50 b9 02 00 00 00 31 f6 48 c7 c7 60 10 5c 8e e8 76 bc 6e ff e8 41 8b 67 09 5a 85 c0 75 7c 48 89 e8 48 c1 e8 03 42 80 3c 20 00 <0f> 85 67 01 00 00 48 8b 45 00 a8 03 0f 85 eb 00 00 00 65 48 ff 00
RSP: 0018:ffffc9000b176d18 EFLAGS: 00000246
RAX: 1ffff110050ec640 RBX: ffff88805a7b0000 RCX: 00000000ac0bef84
RDX: 0000000000000000 RSI: ffffffff8c162900 RDI: ffffffff8df57e68
RBP: ffff888028763200 R08: 852cca471aa95b22 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000000 R12: dffffc0000000000
R13: dffffc0000000000 R14: 0000000000000001 R15: 0000000000000000
 get_obj_cgroup_from_folio+0x148/0x270 mm/memcontrol.c:2738
 swap_zeromap_folio_set mm/page_io.c:206 [inline]
 swap_writeout+0x4bc/0xfe0 mm/page_io.c:264
 writeout mm/vmscan.c:669 [inline]
 pageout mm/vmscan.c:728 [inline]
 shrink_folio_list+0x3e46/0x4880 mm/vmscan.c:1452
 reclaim_folio_list+0xda/0x5d0 mm/vmscan.c:2232
 reclaim_pages+0x47b/0x650 mm/vmscan.c:2269
 madvise_cold_or_pageout_pte_range+0x1546/0x2120 mm/madvise.c:565
 walk_pmd_range mm/pagewalk.c:130 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0xc02/0x1f50 mm/pagewalk.c:303
 __walk_page_range+0x163/0x820 mm/pagewalk.c:410
 walk_page_range_vma+0x2c7/0xa20 mm/pagewalk.c:705
 madvise_pageout_page_range mm/madvise.c:624 [inline]
 madvise_pageout+0x257/0x540 mm/madvise.c:649
 madvise_vma_behavior+0xb22/0x2d60 mm/madvise.c:1352
 madvise_walk_vmas+0x31f/0x9c0 mm/madvise.c:1669
 madvise_do_behavior+0x1e2/0x530 mm/madvise.c:1885
 do_madvise+0x176/0x240 mm/madvise.c:1978
 __do_sys_madvise mm/madvise.c:1987 [inline]
 __se_sys_madvise mm/madvise.c:1985 [inline]
 __x64_sys_madvise+0xa9/0x110 mm/madvise.c:1985
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x490 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0e93f8ebe9
RSP: 002b:00007f0e94d81038 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f0e941b5fa0 RCX: 00007f0e93f8ebe9
RDX: 0000000000000015 RSI: ffffffffffff0001 RDI: 0000000000000000
RBP: 00007f0e94011e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0e941b6038 R14: 00007f0e941b5fa0 R15: 00007ffe733e96c8
 </TASK>
rcu: rcu_preempt kthread starved for 374 jiffies! g85289 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=1
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:28760 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x1190/0x5de0 kernel/sched/core.c:6961
 __schedule_loop kernel/sched/core.c:7043 [inline]
 schedule+0xe7/0x3a0 kernel/sched/core.c:7058
 schedule_timeout+0x123/0x290 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x1ea/0xb00 kernel/rcu/tree.c:2083
 rcu_gp_kthread+0x270/0x380 kernel/rcu/tree.c:2285
 kthread+0x3c5/0x780 kernel/kthread.c:463
 ret_from_fork+0x5d4/0x6f0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 1 UID: 0 PID: 11087 Comm: kworker/u8:31 Tainted: GF R                 6.17.0-rc1-syzkaller-00036-gdfc0f6373094 #0 PREEMPT(full) 
Tainted: [F]=FORCED_MODULE, [R]=FORCED_RMMOD
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
Workqueue: bat_events batadv_tt_purge
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:26 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:109 [inline]
RIP: 0010:arch_local_irq_save arch/x86/include/asm/irqflags.h:127 [inline]
RIP: 0010:lock_is_held_type+0x54/0x150 kernel/locking/lockdep.c:5936
Code: b1 45 08 85 c0 0f 85 ce 00 00 00 65 4c 8b 25 0b 70 45 08 41 8b 94 24 ec 0a 00 00 85 d2 0f 85 b6 00 00 00 48 89 fd 41 89 f6 9c <8f> 04 24 fa 48 c7 c7 da ef f3 8d 4d 8d ac 24 f0 0a 00 00 45 31 ff
RSP: 0018:ffffc90000a08360 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: ffffffff903855c8
RBP: ffffffff903855c8 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff888026a30000
R13: 00000000ffffffff R14: 00000000ffffffff R15: ffff88807b867000
FS:  0000000000000000(0000) GS:ffff8881247c6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb361800218 CR3: 000000000e380000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 lock_is_held include/linux/lockdep.h:249 [inline]
 lockdep_rtnl_is_held+0x1b/0x40 net/core/rtnetlink.c:182
 __in6_dev_get include/net/addrconf.h:347 [inline]
 ip6_ignore_linkdown include/net/addrconf.h:443 [inline]
 find_match+0x34b/0x15d0 net/ipv6/route.c:780
 __find_rr_leaf+0x140/0xe00 net/ipv6/route.c:868
 find_rr_leaf net/ipv6/route.c:889 [inline]
 rt6_select net/ipv6/route.c:933 [inline]
 fib6_table_lookup+0x57c/0xa30 net/ipv6/route.c:2233
 ip6_pol_route+0x1cc/0x1230 net/ipv6/route.c:2269
 pol_lookup_func include/net/ip6_fib.h:617 [inline]
 fib6_rule_lookup+0x536/0x720 net/ipv6/fib6_rules.c:120
 ip6_route_input_lookup net/ipv6/route.c:2338 [inline]
 ip6_route_input+0x662/0xc00 net/ipv6/route.c:2641
 ip6_rcv_finish_core.constprop.0+0x1a0/0x5d0 net/ipv6/ip6_input.c:66
 ip6_rcv_finish net/ipv6/ip6_input.c:77 [inline]
 NF_HOOK include/linux/netfilter.h:318 [inline]
 NF_HOOK include/linux/netfilter.h:312 [inline]
 ipv6_rcv+0x1e8/0x650 net/ipv6/ip6_input.c:311
 __netif_receive_skb_one_core+0x12d/0x1e0 net/core/dev.c:5979
 __netif_receive_skb+0x1d/0x160 net/core/dev.c:6092
 process_backlog+0x442/0x15e0 net/core/dev.c:6444
 __napi_poll.constprop.0+0xba/0x550 net/core/dev.c:7489
 napi_poll net/core/dev.c:7552 [inline]
 net_rx_action+0xa9f/0xfe0 net/core/dev.c:7679
 handle_softirqs+0x219/0x8e0 kernel/softirq.c:579
 do_softirq kernel/softirq.c:480 [inline]
 do_softirq+0xb2/0xf0 kernel/softirq.c:467
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x100/0x120 kernel/softirq.c:407
 spin_unlock_bh include/linux/spinlock.h:396 [inline]
 batadv_tt_local_purge+0x21c/0x3c0 net/batman-adv/translation-table.c:1315
 batadv_tt_purge+0x8b/0xb80 net/batman-adv/translation-table.c:3509
 process_one_work+0x9cc/0x1b70 kernel/workqueue.c:3236
 process_scheduled_works kernel/workqueue.c:3319 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3400
 kthread+0x3c5/0x780 kernel/kthread.c:463
 ret_from_fork+0x5d4/0x6f0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
net_ratelimit: 11652 callbacks suppressed
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
net_ratelimit: 16288 callbacks suppressed
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

