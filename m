Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D976BD38FEF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FEEF6B008A; Wed, 14 Jan 2026 12:07:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D6166B008C; Wed, 14 Jan 2026 12:07:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4001D6B0092; Wed, 14 Jan 2026 12:07:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3057C6B008A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:07:08 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B7F611AB41
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:07:07 +0000 (UTC)
X-FDA: 84331199694.09.1C401CE
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by imf12.hostedemail.com (Postfix) with ESMTP id D3D0A40011
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:07:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of 3OM1naQkbAMM178tjuun0jyyrm.pxxpun31n0lxw2nw2.lxv@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3OM1naQkbAMM178tjuun0jyyrm.pxxpun31n0lxw2nw2.lxv@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768410425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=K95I3kAYG1M0KaNSEjeNm5wWa6plLYQ5qvacwmoIgN4=;
	b=jajQcf33r1Z+OAQRzeN3NWNWm2uAhycr+uiZo6jiJpJIyRCxfa1gcrrRkNmxrwkwX+iOiA
	NkyjdziuGxEbBs3b7JQqG0I2OBuR/8lWxsuyGLxzdMe56V4rrkC26aojtwHrEDrc1ZE5k8
	4D+jzm4asgOkxjxCJ2F/tQUfM6ZqSnc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of 3OM1naQkbAMM178tjuun0jyyrm.pxxpun31n0lxw2nw2.lxv@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3OM1naQkbAMM178tjuun0jyyrm.pxxpun31n0lxw2nw2.lxv@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768410425; a=rsa-sha256;
	cv=none;
	b=ekpb6DkysZranNWwpry/P/MLTBJT6nSFHjc2yTxw8520KWUc45pv/p1eoiVyIoq9z80Awe
	cU5GB3eQNki/ByMDP/S4lQ7dFQIxajMiJuH/jTHYLvhnRD+fPsBonjUBV326UmHB6fg5Dt
	Y86CNokIJllPXU3bheShNw5lgG0VZiU=
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6610d90a391so97212eaf.2
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:07:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768410425; x=1769015225;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K95I3kAYG1M0KaNSEjeNm5wWa6plLYQ5qvacwmoIgN4=;
        b=AOBBFOKV1S1SkFKqI2g7bue0Bd6kdWttCQESeFlAHxqi5147RyWI1ONyaDvtdQmHBf
         R3pV5lQ9ogKe/umAVMc93IeJUt0ZgWDmF16A9yXwotxEAQG6Cr57ebBGatjP89QzIKah
         wjKA9uyqNMFhmXn1phY2wi6tasoyezwXewzFulQDAESd7wQo/JeZzL4J8JG/5hYqD1y3
         oJ6EIRg0GGDJM8dFM1Bfgcve6OR6hNFHp9/M6o30IW8Alj3f3lZtj1S52zjjG8M81EPP
         6JJnH8H17UjwfE2PWHXQl0mWyQpbDVLh0gV6Ajm2yeWMiwnaOHIXLydaM8laExaC+/mg
         MASw==
X-Forwarded-Encrypted: i=1; AJvYcCV0dgAsaSxk+LWd0tyYHH+0s0+E4VW2wyS67HqqElw8zkrc9Y4oTwoG9lNfaNfoB7n2J7AoYqJyww==@kvack.org
X-Gm-Message-State: AOJu0YytQ5t5ohPWjD1q70hzV2P+EcHTSFGZxA0aAh0qbsv0hpbnMSxq
	F3EHBBI8Cq4u85T4F1kgzHI8dptRT37WpLx0GZ8veyGviPbQRAfXktM64GFBbzy1AHc/4SfcAXm
	kMddJjoOhSC9MyHJOEcR3CRa3ip0ZQ7+IBKnF6No6haVtKfLydlV6+RIXpcc=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:221d:b0:65f:fee:f7cc with SMTP id
 006d021491bc7-6610072cac5mr2420280eaf.49.1768410424835; Wed, 14 Jan 2026
 09:07:04 -0800 (PST)
Date: Wed, 14 Jan 2026 09:07:04 -0800
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6967cd38.050a0220.58bed.0001.GAE@google.com>
Subject: [syzbot ci] Re: Eliminate Dying Memory Cgroup
From: syzbot ci <syzbot+ci7d2110b831be06f6@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apais@linux.microsoft.com, 
	axelrasmussen@google.com, cgroups@vger.kernel.org, chengming.zhou@linux.dev, 
	chenridong@huawei.com, chenridong@huaweicloud.com, david@kernel.org, 
	hamzamahfooz@linux.microsoft.com, hannes@cmpxchg.org, harry.yoo@oracle.com, 
	hughd@google.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, mhocko@suse.com, mkoutny@suse.com, 
	muchun.song@linux.dev, nphamcs@gmail.com, qi.zheng@linux.dev, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, songmuchun@bytedance.com, 
	weixugc@google.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D3D0A40011
X-Stat-Signature: kx7jqwf1d5nb4u9bgg8fyoegr3qrkdgi
X-HE-Tag: 1768410425-13534
X-HE-Meta: U2FsdGVkX1/oGAkoBGyPvyuJUBkotbXPz0tbv9iyMkiie1XfGW0rZulusoMceKjOh93dbip3EZThPf2tF7LfHVxXmMInQqmkT7Hikvlrg3HBrbqH5nmk6TNVncxChwwKNYjtAr7+lAfZEiSFlOEpGRjg92mE/OajgMF//kMHWISRYRoXznJLeZiBr8b3lf76gWRsDTFNTPi4Cq7uJOyipCK1uT6BMsRZ230M51no7pS4h59fifBKBAKOdtlm8NqOnUh/hKNoqDx5z1+v1TG/jfg09+gZkLZetUu2UNxSf7hF5/tdwgMIm7gDbYcijyurmPkRhA+YDbC6+D8HYOl4AMzKIpHZBUJQbGzBtESKZ27PIlRa0xGA1k428lsFfoNw8rbVMKt0oHM7OQn5e4dXV9rvwrav+3CCBUh8uRA/7SCEGP8HoaVE42TXucrdac0T4GVMM8Sb4w/dLg6M6imjfTbCB0HowsMi0o896SlT6LEWSicP08K0WhZc9IUJB7j2q/SKn2sjdhubp5XQcarAIc7zpof3mD0zoW/irYDgdKrEz6TeDjYwOnhZ/p214Ahw+YPTKqRF8G8LusH9+s84pbm7voTIwMknWh6qwvfRUUsyj4kDdQL6CVEtdMk7fwtynJ6wyjQR3V1bPSMH1BskFPdfyv0PpfkQfB/FwSwgsCW5AlXnUWNyNSrA7mCJ3D2mpetpX+fRugmyrv4nTs1fK+mo2p4/HUeMKJk5PzcONXJNwwzA6kCVuXt25O0yLPqL48WlTBJmytOo872Z0K2y5rUuPDx3xc+gJBiALlB3PrJmUZUxGewHLHAM7SwvbWwW8gfcOXgEi1adql1TAPF57qlPZiQhvyxTUhe76wh1uraOPq4I5szoTYGz3RvrU/eo4qCfUxGRx8wnqLGcO6wDIO3b11ZlQOXsd26btJ0LGN+k4yPmEE+nV9wasGBrhVFeozGPKwDQAMbJr/Z/mJr
 yLz6uKOw
 vmqv9kR7J4yZ161GRdEe2gNW8COl+zFOZjGoZ3WorJc3CMj/qXypaIWrrKTT6T2JZir7T2+MCZgUqkJMXbQh0kBg+1jqXz0SeDF8O6vWMec/X4ab0OMTfrJZNk5iNBAchw5I1zJFP1ck/C5Qe/rr9Dgcq5wf12ZakOIJ1LUk2WlopAGz+GuGxGZeP13hDMArYmxgq9Z7jzau8JXgaKZEXWyNIO2S02RQgVZDzQN+AH+LOgcOSNXc712BAlC43YQQUU67Ln6ZjxzMUv6NZsNi6fikJLvYufyz43fmZA9hQP3AEwvD6EYV6uiMjEj/cF+GVLI3KKPvBLy9i/qVMt3Pez48RhEcOMIfYfsnHD36KfhMxoPRKOu9L5jalHV9f+u2a+iVW5rcD5o0BfjDPKuYwN9ZqVrv5Pkia9CI+yG1xdaGyyTMdjSyepuyWxLH1rReQTzE20Bd77EX2jTAltuefGXuC2Eolgl9+LseqpFjCxJNBziLSl4lXZ99eI4MFzRYXV2LZEx1VpZ/3V/CeJwHj+MikfhLiGCW2K8NnuMJ0vGcKBrz6qRNaWmlW0RgdEXaZBYGF1MgHfmwrg4Odt4Vc4/j/B0ok4leq2VipH1TXO+foufabHvy1R5KQrwtrTGyFH1gn+W+XxvW8K29kg59Bh6WgdnkBJDF0hT5Wt0HnjKWuJaYX7SFphN8gWAGMKq4RGGS3gkT9tKaTifXnd93G56QtYjdXnyfHQZNJpULELjUCsSSf7Gf9nXq6L8C/srlRsFzRGuTd1YuKQKuhdERhJOdSGbXQ3qh4UPBMGtrPde9RKe8OuDXLCO/u0p20UaKckUZ4YeNqW62J+uxCDne734wiwZJSNMxodZJWKl0957W8cI69QMNOD4EAf3bgPvrT2kSzcWFROW8+d2eK0ND7PDGWm8OYMYnsIOfA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v3] Eliminate Dying Memory Cgroup
https://lore.kernel.org/all/cover.1768389889.git.zhengqi.arch@bytedance.com
* [PATCH v3 01/30] mm: memcontrol: remove dead code of checking parent memory cgroup
* [PATCH v3 02/30] mm: workingset: use folio_lruvec() in workingset_refault()
* [PATCH v3 03/30] mm: rename unlock_page_lruvec_irq and its variants
* [PATCH v3 04/30] mm: vmscan: prepare for the refactoring the move_folios_to_lru()
* [PATCH v3 05/30] mm: vmscan: refactor move_folios_to_lru()
* [PATCH v3 06/30] mm: memcontrol: allocate object cgroup for non-kmem case
* [PATCH v3 07/30] mm: memcontrol: return root object cgroup for root memory cgroup
* [PATCH v3 08/30] mm: memcontrol: prevent memory cgroup release in get_mem_cgroup_from_folio()
* [PATCH v3 09/30] buffer: prevent memory cgroup release in folio_alloc_buffers()
* [PATCH v3 10/30] writeback: prevent memory cgroup release in writeback module
* [PATCH v3 11/30] mm: memcontrol: prevent memory cgroup release in count_memcg_folio_events()
* [PATCH v3 12/30] mm: page_io: prevent memory cgroup release in page_io module
* [PATCH v3 13/30] mm: migrate: prevent memory cgroup release in folio_migrate_mapping()
* [PATCH v3 14/30] mm: mglru: prevent memory cgroup release in mglru
* [PATCH v3 15/30] mm: memcontrol: prevent memory cgroup release in mem_cgroup_swap_full()
* [PATCH v3 16/30] mm: workingset: prevent memory cgroup release in lru_gen_eviction()
* [PATCH v3 17/30] mm: thp: prevent memory cgroup release in folio_split_queue_lock{_irqsave}()
* [PATCH v3 18/30] mm: zswap: prevent memory cgroup release in zswap_compress()
* [PATCH v3 19/30] mm: workingset: prevent lruvec release in workingset_refault()
* [PATCH v3 20/30] mm: zswap: prevent lruvec release in zswap_folio_swapin()
* [PATCH v3 21/30] mm: swap: prevent lruvec release in lru_gen_clear_refs()
* [PATCH v3 22/30] mm: workingset: prevent lruvec release in workingset_activation()
* [PATCH v3 23/30] mm: do not open-code lruvec lock
* [PATCH v3 24/30] mm: memcontrol: prepare for reparenting LRU pages for lruvec lock
* [PATCH v3 25/30] mm: vmscan: prepare for reparenting traditional LRU folios
* [PATCH v3 26/30] mm: vmscan: prepare for reparenting MGLRU folios
* [PATCH v3 27/30] mm: memcontrol: refactor memcg_reparent_objcgs()
* [PATCH v3 28/30] mm: memcontrol: prepare for reparenting state_local
* [PATCH v3 29/30] mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios
* [PATCH v3 30/30] mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance helpers

and found the following issue:
UBSAN: array-index-out-of-bounds in reparent_memcg_lruvec_state_local

Full report is available here:
https://ci.syzbot.org/series/45c0b58d-255a-4579-9880-497bdbd4fb99

***

UBSAN: array-index-out-of-bounds in reparent_memcg_lruvec_state_local

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      b775e489bec70895b7ef6b66927886bbac79598f
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/4d8819ab-0f94-42e8-bd70-87c7e83c37d2/config
syz repro: https://ci.syzbot.org/findings/7850f5dd-4ac7-4b74-85ff-a75ddddebbee/syz_repro

------------[ cut here ]------------
UBSAN: array-index-out-of-bounds in mm/memcontrol.c:530:3
index 33 is out of range for type 'long[33]'
CPU: 1 UID: 0 PID: 31 Comm: kworker/1:1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: cgroup_offline css_killed_work_fn
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
 __ubsan_handle_out_of_bounds+0xe8/0xf0 lib/ubsan.c:455
 reparent_memcg_lruvec_state_local+0x34f/0x460 mm/memcontrol.c:530
 reparent_memcg1_lruvec_state_local+0xa7/0xc0 mm/memcontrol-v1.c:1917
 reparent_state_local mm/memcontrol.c:242 [inline]
 memcg_reparent_objcgs mm/memcontrol.c:299 [inline]
 mem_cgroup_css_offline+0xc7c/0xc90 mm/memcontrol.c:4054
 offline_css kernel/cgroup/cgroup.c:5760 [inline]
 css_killed_work_fn+0x12f/0x570 kernel/cgroup/cgroup.c:6055
 process_one_work+0x949/0x15a0 kernel/workqueue.c:3279
 process_scheduled_works kernel/workqueue.c:3362 [inline]
 worker_thread+0x9af/0xee0 kernel/workqueue.c:3443
 kthread+0x388/0x470 kernel/kthread.c:467
 ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
---[ end trace ]---
Kernel panic - not syncing: UBSAN: panic_on_warn set ...
CPU: 1 UID: 0 PID: 31 Comm: kworker/1:1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: cgroup_offline css_killed_work_fn
Call Trace:
 <TASK>
 vpanic+0x1e0/0x670 kernel/panic.c:490
 panic+0xc5/0xd0 kernel/panic.c:627
 check_panic_on_warn+0x89/0xb0 kernel/panic.c:377
 __ubsan_handle_out_of_bounds+0xe8/0xf0 lib/ubsan.c:455
 reparent_memcg_lruvec_state_local+0x34f/0x460 mm/memcontrol.c:530
 reparent_memcg1_lruvec_state_local+0xa7/0xc0 mm/memcontrol-v1.c:1917
 reparent_state_local mm/memcontrol.c:242 [inline]
 memcg_reparent_objcgs mm/memcontrol.c:299 [inline]
 mem_cgroup_css_offline+0xc7c/0xc90 mm/memcontrol.c:4054
 offline_css kernel/cgroup/cgroup.c:5760 [inline]
 css_killed_work_fn+0x12f/0x570 kernel/cgroup/cgroup.c:6055
 process_one_work+0x949/0x15a0 kernel/workqueue.c:3279
 process_scheduled_works kernel/workqueue.c:3362 [inline]
 worker_thread+0x9af/0xee0 kernel/workqueue.c:3443
 kthread+0x388/0x470 kernel/kthread.c:467
 ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
Kernel Offset: disabled
Rebooting in 86400 seconds..


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

