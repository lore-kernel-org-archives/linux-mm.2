Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96B8CFF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 22:30:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF5096B008C; Wed, 29 Apr 2026 18:30:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCCE36B0092; Wed, 29 Apr 2026 18:30:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0A566B0093; Wed, 29 Apr 2026 18:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C040E6B008C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:30:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5602EC04AE
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:30:27 +0000 (UTC)
X-FDA: 84713038494.18.6827AA1
Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	by imf19.hostedemail.com (Postfix) with ESMTP id A2CD61A0011
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:30:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf19.hostedemail.com: domain of 3gIbyaQkbAK0flmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=3gIbyaQkbAK0flmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777501825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=3HbGDe+FYuDBiqHxgjl3AMAvxH4rr+6wviRQfjDUxY8=;
	b=bV61TmHx0Bzb9pTfYvPIBpYa9YN3g3TmNiGt7adAa/vC8j4TFGuTKw+JfwbxZVQLwGO8sF
	z3t7uRiqj6WHr6muG3pTv7a0mWAbkMa5t1ZBdG5tebJixMG8T/B2Prf9llcO8n3SSRw1aY
	lVKLd1M0ainNNJ7GQjGaXRAHZZqvH0M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf19.hostedemail.com: domain of 3gIbyaQkbAK0flmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=3gIbyaQkbAK0flmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777501825; a=rsa-sha256;
	cv=none;
	b=hnsMp2+k4h9jo1RFY9d7kWRkL0vF+3apFo4aCMsAgVxyPOyVfmzQyGnUnllsv1sniwfPwe
	FNhmcZ0vmotUbXVUq2xpWj27YS7cCYDGSpAEJCp69O4mrHCMSsGAdKh/M6zrAN6rgmObbZ
	HOEBozyqQ5FJk16LvQjvEHZE3i1LCgk=
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-6966f1f4490so778903eaf.1
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:30:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777501824; x=1778106624;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3HbGDe+FYuDBiqHxgjl3AMAvxH4rr+6wviRQfjDUxY8=;
        b=NOe9Yf/NCwvWsNF5k9cN3wSbYHOUKWj7Qmc2iOP4uPzd1Tj+7Xm263S/6megQioEes
         xmXNchh+HusmA2FCHQtBUaOJsnyfYHAQAaqHfWQJ4n5TLPauNIyQc2brA/IlJrevQIaL
         MjCIMpjobj9D4dsPxQt21/Y9p8jpJKqSXFaBfQpQxHZOWKa10Oq/sxEdWTDcp11jw1Yb
         iISQfcPEOL88sSXmea6L56x4gEuL5B3q+ERen0DwzQs97FTGQ1oAH4xHafqIUdLKkHlf
         cD/gX7T3jTMJpUP4JJJsRWoLTanPZkweoHa+srkjcS/zKVgzVdIuHpRxbBv5MeQZCcA4
         Fk6A==
X-Forwarded-Encrypted: i=1; AFNElJ/SbOaSVyjhalFeFRwdz92tVoQs1+aFArQ1AnKmiAz1iRocZ0OYSrTLZTrd/UVZt8OoNATmVABSXg==@kvack.org
X-Gm-Message-State: AOJu0Yzn2UbZAoNU9vj1rLk6xWKjJPOqTzK79NJr0yYSY/je9Yff92MD
	ranWib2bTOwheJDPFvNu4LWJkCJTm763BTJZWPYaKDGQIE2D8/B/p2qBmFULMShmYM1wtO3RGsL
	zpoYeYzpEEO8Un1Rp5R8yqUCTi5iK3DmjzOyLT0vbwAYMA/uLgw/pe4J8ABQ=
MIME-Version: 1.0
X-Received: by 2002:a4a:b684:0:b0:679:c55a:df0b with SMTP id
 006d021491bc7-6966a528262mr1726765eaf.37.1777501824660; Wed, 29 Apr 2026
 15:30:24 -0700 (PDT)
Date: Wed, 29 Apr 2026 15:30:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f28680.050a0220.11c491.0005.GAE@google.com>
Subject: [syzbot] [mm?] WARNING: lock held when returning to user space in do_fault
From: syzbot <syzbot+4be30d1151ada9ad0194@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, surenb@google.com, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A2CD61A0011
X-Stat-Signature: qmgjz4ydiw9okitggbm3bunctmsagsze
X-HE-Tag: 1777501825-781569
X-HE-Meta: U2FsdGVkX19Hku8svnMJQjw4/QUaxvI+CaG7lVepTclqpwF8QSDiptemBAocCwRZw6K3WjZsMFv8vctv6ilU84cBMuPvz1kHHOyxEczv+doe5F4flvURQIaLGlZ85C7MOoyTqcMtC1XhDW2tqJYLnOCGkDCkYbVrWCGoOQ8B1UHkWSWzNaM2+lL69sIAr09YHHXGhq5FilpLkqADYJ0RfSzqS6c8FeRxYkS8h8YhiR/8lX2iL57YptDFx9nRWqE8Ntk5iWDrd6yAmvZKjvMxee2pCXVQSUZqUEKGacMdnVAgOyMDhdxpGgQB77ZD2tvxjGNnMqH2LGpLWA6cbmUVBOYdZhlsuD1scSZFlB46LwwBeWRWK23ynzU+G4DVQwx3kqGx1K8yZj1n+FM9/OcE/vzucKeGG+hoc/uf2G5J1TqmLsJqA2GBQHd/h20yUjoluutRO9j9iWUxmW2OsY0fyugc2V7zJg0FEsgn+i1klhtZbQR5c/sUHQ1s3M9YrAqNRKF/QxplXa+RAAaUH7AbmiBKQn3drkxrAvN67jo/CT0jEjpSCu0Mn7YYIHaEqYqI3g3Mf5f2fWDzRVQehC9+VDvX8jiHcJ+j41TgJ0dHL1onc+ikrk4CRraP6v9Ozr/M+GqxUThVN1uoysqPNcADI4kiowlf2CSfnV5hnq3tncfvwDSmdAETsFFm8RMhTSAQKBIHENX/kHi44DqDMucWdVAqsBBx8eaIpPCmR9svgMa10fHAyZMhNDI2JJLGbw2nNqxitllgebqzJEYSstvr6xzazqvY2937FKMCstufBRXdv/c9Suj63wB4qSzVLM1wo8DPP/O/YGHbwAOq+3XKrCSpWxy3WYQzEstkGr0PWNuNbK0ZyPtZbAJoDwc6Y7GNg4EGjdAnjv3XAZ7iwms69n6WBJklJX6Ckbu5ZQV7961SmdobCzzrcbYp2XiDbkl76Mjk+VYWPlEJfB95v0q
 W1MwJZKF
 YLO+V5aPMsE7LXACt4KbKeUg6NMhSczXS5L9njguk7fwe7hj0jA7lR3TZGjj75wEvAXonPE/S8WbiAIyR87/D2/xWIvXMIDgZp0dDHkU0BeVcB+AvbyzDkCcZ63psPtvICu38H5HWfQYoCyH70qebgayD4EltzV1MA/laIw2HnRZenBtX090+5d6oISz7WixHYHKo64pATWhHUSW/bv2cQ+EGqKtWczZxQtir0XfMTRagYynaG9dUGkQPJyxKIdil710Te9FLb4kAdVaWyvuzPrd6kgMlX7SWAULWljM8DWvyD8McV0+g4kKIKeB17mu+gubtm3/Ax2X5Z1IDblKZgWP0/b4esiMkkm/bSDmOw4SBdCMSRNS33KHvVNeQGTnNnupABZw0IEt6BrfpPvebjxrYhHK23H5/AjdmuGgxscqfcSzBO4sfpMa1hV7IrRmmxn2YPEzskv0xSpHkn/kuSpc+no0b41u+D+TSbh9UEUjAg5rrf/12lkYuw9NDbHbsJH0hKb29sjcJPL3S6Xx3xAf3KGzUxA2CDDh2Achcq2xPzDGyyEaZqO1C65LDlqEs2Tud8ndMsqtPy7He9oRWEuwretwEHllHF4RjCPiWANboRy8hQxj+n0vxuzUIx4U9srP6Qr1jTU6CYJQ3M3kzxIHUmFe7r+EM3gpd2MGoB5Q++hVrF5YDTTItpiJbcAFl48y4jCjryLhflXvp2EX4gLOFJEmmxawCCbh1C9uXK+jtyUYe3eSLE1Ks3ZblDtCvtmLd+oWsR/8dKO13Nb+rAY70tl09Z+/c7qcY2aurx4vjByE6V7w13d7R39kmaV1B5xY6Sxaq6MjlyqX25IE4MYsNySLWpgK5t41+oMbBhU+u4sJcDUrN3FuZhBfC6++jU17nhDXpZnKA1/fP5FqR6ifjRaZDmtbPG514c1d7m8BF2owLmO5wfeHnIYC09ICbs1ZkUG5HwyKxTOGhL5IaA4gSSSSh
 MZszMrT8
 rIusEi+4x1V3h1TILg3uqltbNsUddsvr/Uhja7f4LQ9QIWvDNB2xarEVYS+gYpufc7rvQRAEFQKM8LWWzkOtuqHGxIkXomdX9BC8OdD1TDVST4dZjupC00l+O7iW80tM4fRczNi2MiVblUO7LCtTexIiJwvy66lF4ft/Znon9NPVeGjx4+Z4gVJZ+X0WbgTzTIVV8uu31RfcswQc5E1ahdHb0dyaZt2jBY82VMRXGzWfm8iNO1iPvspzlPUFjhU4F21i9jhgrDvFR6EhYRJ66O4qdy+b5oHBF7hDYJ8+HNCiS/hXNTL8GX6Cu91Bto0eZ38cK1nDLB02uvuQoO64E2aZLX7NtWBHcEh+JCnE19N9yst+7io51wHhplmrs1XkHc+Q2bxl6phgpwx0fGRhFqxhH4YJtpd43O/5poISbG0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    892c894b4ba4 Merge tag 'locking-urgent-2026-04-24' of git:..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16d771ba580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=36f47f794f188364
dashboard link: https://syzkaller.appspot.com/bug?extid=4be30d1151ada9ad0194
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-892c894b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/80b0456697de/vmlinux-892c894b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a3015c11e495/bzImage-892c894b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4be30d1151ada9ad0194@syzkaller.appspotmail.com

================================================
WARNING: lock held when returning to user space!
syzkaller #0 Not tainted
------------------------------------------------
dhcpcd-run-hook/5670 is leaving the kernel with locks still held!
5 locks held by dhcpcd-run-hook/5670:
 #0: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #0: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: do_fault_around mm/memory.c:5850 [inline]
 #0: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: do_read_fault mm/memory.c:5884 [inline]
 #0: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: do_fault+0x8b4/0x1750 mm/memory.c:6027
 #1: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #1: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #1: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: filemap_map_pages+0x1c5/0x2140 mm/filemap.c:3895
 #2: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #2: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #2: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2f/0x310 mm/pgtable-generic.c:290
 #3: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #3: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #3: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: lruvec_stat_mod_folio+0x76/0x2b0 mm/memcontrol.c:974
 #4: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #4: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #4: ffffffff8e7e54e0 (rcu_read_lock){....}-{1:3}, at: lruvec_stat_mod_folio+0x76/0x2b0 mm/memcontrol.c:974
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:323
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5670, name: dhcpcd-run-hook
preempt_count: 0, expected: 0
RCU nest depth: 5, expected: 0
INFO: lockdep is turned off.
CPU: 2 UID: 0 PID: 5670 Comm: dhcpcd-run-hook Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 __might_resched.cold+0x1ec/0x232 kernel/sched/core.c:9162
 might_alloc include/linux/sched/mm.h:323 [inline]
 prepare_alloc_pages+0x44a/0x5f0 mm/page_alloc.c:4995
 __alloc_frozen_pages_noprof+0x19a/0x2bc0 mm/page_alloc.c:5215
 alloc_pages_mpol+0x1fb/0x540 mm/mempolicy.c:2490
 folio_alloc_mpol_noprof+0x36/0x260 mm/mempolicy.c:2509
 vma_alloc_folio_noprof+0xed/0x1d0 mm/mempolicy.c:2544
 folio_prealloc mm/memory.c:1191 [inline]
 alloc_anon_folio mm/memory.c:5282 [inline]
 do_anonymous_page+0xb46/0x2050 mm/memory.c:5376
 do_pte_missing mm/memory.c:4548 [inline]
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault+0x1d2c/0x2a00 mm/memory.c:6549
 handle_mm_fault+0x36d/0xa20 mm/memory.c:6718
 do_user_addr_fault+0x5a3/0x12f0 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7fe544e18d34
Code: 8d 34 19 49 39 d0 49 89 70 60 0f 95 c2 48 29 d8 48 83 c1 10 0f b6 d2 48 83 c8 01 48 c1 e2 02 48 09 da 48 83 ca 01 48 89 51 f8 <48> 89 46 08 48 89 cf 4c 89 e6 48 89 4c 24 08 e8 18 c7 ff ff 48 8b
RSP: 002b:00007ffcc6945410 EFLAGS: 00010206
RAX: 000000000001fe51 RBX: 0000000000000410 RCX: 0000564e7ee79db0
RDX: 0000000000000411 RSI: 0000564e7ee7a1b0 RDI: 0000000000000000
RBP: ffffffffffffffc0 R08: 00007fe544f51ac0 R09: 0000000000000410
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000400
R13: 0000000000000410 R14: 000000000000003f R15: 00007fe544f51b20
 </TASK>
------------[ cut here ]------------
Voluntary context switch within RCU read-side critical section!
WARNING: kernel/rcu/tree_plugin.h:332 at rcu_note_context_switch+0x859/0x19c0 kernel/rcu/tree_plugin.h:332, CPU#2: dhcpcd-run-hook/5670
Modules linked in:
CPU: 2 UID: 0 PID: 5670 Comm: dhcpcd-run-hook Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:rcu_note_context_switch+0x859/0x19c0 kernel/rcu/tree_plugin.h:332
Code: c1 ea 03 80 3c 02 00 0f 85 9b 0b 00 00 48 8b 53 28 b9 01 00 00 00 4c 89 ef e8 a3 cf fe ff e9 1d f9 ff ff 48 8d 3d 17 e9 ec 0e <67> 48 0f b9 3a e9 99 f8 ff ff 48 b8 00 00 00 00 00 fc ff df 48 8d
RSP: 0000:ffffc9000333fcf0 EFLAGS: 00010006
RAX: 0000000000000005 RBX: ffff88806a63c280 RCX: ffffffff81edab71
RDX: 0000000000000000 RSI: ffffffff8c1c1c00 RDI: ffffffff90db08b0
RBP: ffff88802615ca00 R08: 0000000000000000 R09: fffffbfff21aeeaa
R10: ffffffff90d77557 R11: 0000000000000014 R12: 0000000000000000
R13: ffff88802615cec4 R14: ffff88806a63b240 R15: ffffffff90d7a8e4
FS:  00007fe544cb7c80(0000) GS:ffff8880d657c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe544fd3feb CR3: 0000000038dc4000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __schedule+0x276/0x6820 kernel/sched/core.c:7043
 __schedule_loop kernel/sched/core.c:7267 [inline]
 schedule+0xdd/0x390 kernel/sched/core.c:7282
 __exit_to_user_mode_loop kernel/entry/common.c:54 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:98 [inline]
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 irqentry_exit_to_user_mode_prepare include/linux/irq-entry-common.h:252 [inline]
 irqentry_exit_to_user_mode include/linux/irq-entry-common.h:323 [inline]
 irqentry_exit+0x359/0x790 kernel/entry/common.c:162
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0033:0x7fe544fa2f32
Code: 00 74 05 e8 c0 d6 fc ff 48 83 c4 10 5b 5d 41 5c c3 41 55 41 54 41 89 f4 55 48 89 fd 53 51 0f b6 07 48 89 f9 c1 e0 04 0f b6 11 <84> d2 74 07 48 ff c1 01 d0 eb f2 6a 1f 25 ff 7f 00 00 59 31 d2 f7
RSP: 002b:00007ffcc6944980 EFLAGS: 00000206
RAX: 000000000000076f RBX: 0000564e7ee792c0 RCX: 0000564e7ee82333
RDX: 000000000000006d RSI: 0000000000000000 RDI: 0000564e7ee82330
RBP: 0000564e7ee82330 R08: 0000000000000001 R09: 0000000000000000
R10: 00007fe544ef7fe0 R11: 00007fe544ef88e0 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000001 R15: 00007fe54501e240
 </TASK>
----------------
Code disassembly (best guess):
   0:	c1 ea 03             	shr    $0x3,%edx
   3:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   7:	0f 85 9b 0b 00 00    	jne    0xba8
   d:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  11:	b9 01 00 00 00       	mov    $0x1,%ecx
  16:	4c 89 ef             	mov    %r13,%rdi
  19:	e8 a3 cf fe ff       	call   0xfffecfc1
  1e:	e9 1d f9 ff ff       	jmp    0xfffff940
  23:	48 8d 3d 17 e9 ec 0e 	lea    0xeece917(%rip),%rdi        # 0xeece941
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	e9 99 f8 ff ff       	jmp    0xfffff8cd
  34:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  3b:	fc ff df
  3e:	48                   	rex.W
  3f:	8d                   	.byte 0x8d


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

