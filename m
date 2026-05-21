Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA16DCD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 07:39:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54B856B0096; Thu, 21 May 2026 03:39:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FCA06B0098; Thu, 21 May 2026 03:39:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4129A6B0099; Thu, 21 May 2026 03:39:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8E76B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:39:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EFD271A0547
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:39:18 +0000 (UTC)
X-FDA: 84790626396.04.99B6EDE
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by imf21.hostedemail.com (Postfix) with ESMTP id 41E681C0004
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:39:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3pLYOagkbAKMVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3pLYOagkbAKMVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779349157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=XWKRtXiZ3vPr/SWGzquOclNiqgxO1IwRNyvP9OlYuFI=;
	b=aHrTFfTYNmuEyFDr4GoOUfUxD1Lid0ehVedtMo0mhmfB9abS2jv6ijmeFCzYM3Khx1PBw3
	wbMsBfHu5HYWGWd7RXgvHGD+tgzLXs7b6Xt+f3VTllxVNlfB0TMtXbX0iCqOk0k342H+Q1
	Wjypdq7jOe5RtIlMbYKk0rrQ1BRvSEE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779349157; a=rsa-sha256;
	cv=none;
	b=dVS34ClNkf/Eo10yQzIVHn174UtY/cjRKkhInnuU5up9AVw780/So9djubyYNnEYtogGOR
	aDb9gBpKzred8L4FNS+1TeOdgWlMHl+FZ2CSetlf5/vZw5/6usjYylCO0Xdn6AzGHp0xzc
	aoZKrOUguypkr40CR3lSoG3yn1psYng=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3pLYOagkbAKMVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3pLYOagkbAKMVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-69d6c151922so1326498eaf.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 00:39:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779349156; x=1779953956;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XWKRtXiZ3vPr/SWGzquOclNiqgxO1IwRNyvP9OlYuFI=;
        b=F96BJAXjSTNZSzWzfVxajwBOx1Sizb4mDehQ7e2QKMWq6BlIVu83Ts/gfZ4HgrkdCc
         YQEXo/GPieW3xVFsxweFMXomLsgp92k0ic44XXs6LQSqBR48GndM47dYFjAX3vrm3rxa
         ULe+JhxuGknSKmnaAtwDfJZywQQGa77Fg9JgbyHLwH9YJhTWeHsWSuRXng1PGWvurHCh
         FoCi6z44LV2J9e9u3JXZPwXjepGRQ1tRxfLXUBuGAsME605CnRHBmGBuQFW8eFMD+dSm
         jeIXSBL3DQ9BJLY/UfaQ1P6wzvR3XeHSb14RNiNoEeMIkrh5GWhOruzCL8vF5S+jtvCh
         KF+w==
X-Forwarded-Encrypted: i=1; AFNElJ+iJpqDCLhW9UVDwZOWCTT4V5Il4EU8m0DwcSQ0cXPB5zjCooG2mIHMhbgp/rXuYcDf3tYJvd4ChQ==@kvack.org
X-Gm-Message-State: AOJu0Ywfc9/BVVbg1z0TWI2l292ODHoda4UvcoGd8cZm6KxDRFlLPbfP
	SA4Ei+rttKB9okwfqgTK2LciGsL30RIpDHgGUsD9vHvYcKA4qj80Q9Dag+9f7z42ms2ERvGw+tf
	7j8EhcnIdY/c8a1kBmaqrCrpWkQKqdr6g8FUIM6DE/OkJXvWRkHrTahydPlg=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1f07:b0:696:72c4:5da3 with SMTP id
 006d021491bc7-69d6ee129d0mr701634eaf.15.1779349156267; Thu, 21 May 2026
 00:39:16 -0700 (PDT)
Date: Thu, 21 May 2026 00:39:16 -0700
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0eb6a4.170a0220.55718.0291.GAE@google.com>
Subject: [syzbot ci] Re: mm: reliable 1GB page allocation
From: syzbot ci <syzbot+cib9dcfd931f19159c@syzkaller.appspotmail.com>
To: boris@bur.io, clm@meta.com, david@kernel.org, dsterba@suse.com, 
	fvdl@google.com, hannes@cmpxchg.org, hnaz@cmpxchg.org, kernel-team@meta.com, 
	lenb@kernel.org, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, ljs@kernel.org, 
	pavel@kernel.org, rafael@kernel.org, riel@surriel.com, surenb@google.com, 
	usama.arif@linux.dev, willy@infradead.org, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 41E681C0004
X-Stat-Signature: 4p4u98fdfqokczwchuywotadn67bghpi
X-Rspam-User: 
X-HE-Tag: 1779349157-49097
X-HE-Meta: U2FsdGVkX1/bjeH40RQfDblhMJfaqUmDwSrYjPLWPZBSkQ9tC53w/B5+JwSQL/+n/CmhulnsXYrGG2g0QUl0CbUh8tVIPyTO1eFcpWaU9OA1/Jv92uwAXDW5PkZ7vmCpyqEAp8gU/QJSjpDOTn9fp+7USBRfQ9FO/+pl4G9//2HJ9pqFTpux9Qm5V13fhkmLe6Xj1loHPsufTLuSbLzoSchd0nXp/xof8zqYCuFezF6i0Mu5rC2TZYUB1dKBNFFgKI4zYkGfgarSusB/VK9Op5gcu5DgY58I/tpvVh1RqzykUJLWOqeIOxDAJN71oxZq3oskB1/EALqlO/QtU9j9YqTcA56wxwhhx5io+eMs9RC1hLUKyIH0WZ2ZbNhqx4qXVI68Pp5m0CNVJ9ncqC85bv5tuo7woT02LYsgF7z0JqVMGkV22EhfFcSH9JfceeFzJ6sueJvXJYJEln9xz06KG9ENN1aILH+h+3zAzOpKhgHrKopadHdbPP2Z997ntO9v/uSzBO6UuJsWTlidCywIdV9hCuXmrwdYEHLoq+kH2qt37BjFv2qJ/jcaZ8Y4HyQsDn0qycySMwIGbwuWaul38LQO9vlFXrR7m+/xLnbAFbuTk19vPRtdbaiHXa9eWsNNu2iY+PwFsEfFxz5y1ANPou+S/xWI4lOTjjFd+/zGqRj3aTkcs6SlPYHugwo5CMfScxEva4iF4gjxw0aw6UsPaSeexbIegax5QrNIzrl6MeqmCiEGYvmA45zY0EMm+MZd5hRibAzQPUAl4T5DQ4vj/VpGbS5uKd+eEG28ZlvFTVxlmw+r0Xc8cVMt5Y21xRlLvKu82NREg+mnfnrwC2LpPTyUW9bqQ5J+SNO704MlFzHAskSq+7y0of5gvQUWgf8Adn5Kqlnz99E/URxHabqyPsOK+KHNxMY4wmqBrBLoEeCxtRziLD6muFzVIsmINpWushIo58htidzfHrBBxuq
 5JzsFJlB
 xwbhwZnlvTXMDuhjECsAllQFLXceBt286xbT4gwlKdam5pcH/15laxDFT7wWsj5tbo0n+xGiE9mWwK3Po9CvoJWQvVSm2W0HjhvbEzZI9575FymKSZpKy3s5+3X2IgcmYDrBYs5MfiqkpBO6Y6RiTNpevGmwzVwuqbwE4Crnwn+qZeXAdzJ8sPxFm3OBBRfpeDgZ0Zdq7cE97kK1cEQzzcBdeo4f/HCdhCkO4Q9Lc8g3L4Z5zUwzjoI4aCingc0r2FYbkZCEVR3wT3iaimFQzms/55/gb2SD+Ky98oxFvuV5C+7ufSyBRcSbJjhO3mQXNS06wSP7FrLDYKQkG4xTlP8UxNBnWcw1zK/N2mKKAd24Vzh0jvaE9zEJD+aS2njhGBqfVliBrb3Lguh1/cqqbW0rGascEKC2UFqMhbNBLbmiQjk8qVoNXqnnhuc2u5j6Ui0b5g7/IUCVvTz2CilK3KPuZd8XxxgmcePPsFG91vE+Ux8oQrX1szUKA8ISd1jvEKzpJIcvrm3dIJ+VwLl19buoWPoI1xzkp6fw2RXi+tzxniJX3D91Y5xufXDMTnkwJGug8WG2Du1pZe+X4hUrJLLX6S3yNuffqw1s54pY3jsNscO8pvNXgx/9av+EMuTkT1wGrPhgmWwpadn30YUVvu0b9TVrOFSz63gK3fJytWVwSIXRHR5crMseYpAbK0DlFkXnyoV1Wgk+uJvlAKsL/IKvWruh3+YU78DReGAD28pxpyqu1ovHi9YLDCsQmL4MBAsR6Lpd6qNBu83fPK8cO8eV4tfioNk17yBqE7Qvku01RmGUd9Fs6VhdVbDas7xPKOcH61gAG873iWTaSy1H9pmjXbsT2l/bxCE4StYplg8t1ss0faep/H9zmT60UD22lQAUQhmWlywPFfeW8vtA5pkbHDHYTvwPAM29/Lhpyazxemw8Yg2IY3M1FhucLFL+pYk3fKRQvapmZhGhT5uj9j3KV5eEQ
 3jmnfzfV
 Y8aPPFh+Q5V37MUabtAXmejrFhpkplkb41xtShpbk22PD7mmPyn1xra8xg8Vt+Sh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] mm: reliable 1GB page allocation
https://lore.kernel.org/all/20260520150018.2491267-1-riel@surriel.com
* [RFC PATCH 01/40] mm: page_alloc: replace pageblock_flags bitmap with struct pageblock_data
* [RFC PATCH 02/40] mm: page_alloc: per-cpu pageblock buddy allocator
* [RFC PATCH 03/40] mm: page_alloc: split-path PCP free with local-trylock + remote-llist
* [RFC PATCH 04/40] mm: mm_init: fix zone assignment for pages in unavailable ranges
* [RFC PATCH 05/40] mm: page_alloc: remove watermark boost mechanism
* [RFC PATCH 06/40] mm: page_alloc: async evacuation of stolen movable pageblocks
* [RFC PATCH 07/40] mm: page_alloc: track actual page contents in pageblock flags
* [RFC PATCH 08/40] mm: page_alloc: superpageblock metadata for 1GB anti-fragmentation
* [RFC PATCH 09/40] mm: page_alloc: support superpageblock resize for memory hotplug
* [RFC PATCH 10/40] mm: page_alloc: add superpageblock fullness lists for allocation steering
* [RFC PATCH 11/40] mm: page_alloc: steer pageblock stealing to tainted superpageblocks
* [RFC PATCH 12/40] mm: page_alloc: steer movable allocations to fullest clean superpageblocks
* [RFC PATCH 13/40] mm: page_alloc: extract claim_whole_block from try_to_claim_block
* [RFC PATCH 14/40] mm: page_alloc: add per-superpageblock free lists
* [RFC PATCH 15/40] mm: page_alloc: add background superpageblock defragmentation worker
* [RFC PATCH 16/40] mm: compaction: walk per-superpageblock free lists for migration targets
* [RFC PATCH 17/40] mm: page_alloc: superpageblock-aware contiguous and higher order allocation
* [RFC PATCH 18/40] mm: page_alloc: prevent atomic allocations from tainting clean SPBs
* [RFC PATCH 19/40] mm: page_alloc: aggressively pack non-movable allocs in tainted SPBs on large systems
* [RFC PATCH 20/40] mm: page_alloc: prefer reclaim over tainting clean superpageblocks
* [RFC PATCH 21/40] mm: page_alloc: adopt partial pageblocks from tainted superpageblocks
* [RFC PATCH 22/40] mm: page_alloc: add CONFIG_DEBUG_VM sanity checks for SPB counters
* [RFC PATCH 23/40] mm: page_alloc: targeted evacuation and dynamic reserves for tainted SPBs
* [RFC PATCH 24/40] mm: page_alloc: prevent UNMOVABLE/RECLAIMABLE mixing in pageblocks
* [RFC PATCH 25/40] mm: trigger deferred SPB evac when atomic allocs would taint a clean SPB
* [RFC PATCH 26/40] mm: page_alloc: refuse fragmenting fallback for callers with cheap fallback
* [RFC PATCH 27/40] mm: page_alloc: cross-migratetype buddy borrow within tainted SPBs
* [RFC PATCH 28/40] mm: page_alloc: drive slab shrink from SPB anti-fragmentation pressure
* [RFC PATCH 29/40] mm: page_reporting: walk per-superpageblock free lists
* [RFC PATCH 30/40] mm: show_mem: collect migratetype letters from per-superpageblock lists
* [RFC PATCH 31/40] mm: page_alloc: per-(zone, order, mt) PASS_1 hint cache
* [RFC PATCH 32/40] mm: debug: prevent infinite recursion in dump_page() with CMA
* [RFC PATCH 33/40] PM: hibernate: walk per-superpageblock free lists in mark_free_pages
* [RFC PATCH 34/40] btrfs: allocate eb-attached btree pages as movable
* [RFC PATCH 35/40] mm: page_alloc: refuse best-effort high-order allocs servable at lower orders
* [RFC PATCH 36/40] mm: page_alloc: set ALLOC_NOFRAGMENT on alloc_frozen_pages_nolock_noprof
* [RFC PATCH 37/40] mm: page_alloc: move spb_get_category and spb_tainted_reserve to mmzone.h
* [RFC PATCH 38/40] mm: compaction: skip empty tainted superpageblocks as migration source
* [RFC PATCH 39/40] mm: compaction: respect tainted SPB reserve in destination selection
* [RFC PATCH 40/40] mm: page_alloc: SPB tracepoint instrumentation [DO-NOT-MERGE]

and found the following issue:
WARNING in preempt_count_sub

Full report is available here:
https://ci.syzbot.org/series/8eef71e1-708c-40d0-9f9d-3a1bd637fc80

***

WARNING in preempt_count_sub

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      4b83cbc4c15f09b000cc06f033f64b0824b6dc87
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/de024c89-d472-4f06-b5be-4f75f2acd1d9/config

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(val > preempt_count())
WARNING: kernel/sched/core.c:5883 at preempt_count_sub+0x9e/0x170, CPU#0: kworker/0:0/9
Modules linked in:
CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: events drain_vmap_area_work
RIP: 0010:preempt_count_sub+0xa5/0x170
Code: 29 31 90 48 c1 e8 03 0f b6 04 18 84 c0 0f 85 88 00 00 00 83 3d ff 50 9d 0e 00 75 13 48 8d 3d 32 37 a0 0e 48 c7 c6 c0 f8 cb 8b <67> 48 0f b9 3a 90 eb b8 90 e8 ed d6 1d 03 85 c0 74 2f 48 c7 c0 c4
RSP: 0000:ffffc900000e7590 EFLAGS: 00010246

RAX: 0000000000000000 RBX: dffffc0000000000 RCX: ffff8881007d5880
RDX: 0000000000000000 RSI: ffffffff8bcbf8c0 RDI: ffffffff90341000
RBP: ffff888121042dc0 R08: ffffffff903129c3 R09: 1ffffffff2062538
R10: dffffc0000000000 R11: fffffbfff2062539 R12: 0000000000000020
R13: dffffc0000000000 R14: ffff888121042d80 R15: ffff88815fffbae8
FS:  0000000000000000(0000) GS:ffff88818dc7e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e74a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 free_frozen_page_commit+0x737/0x1290
 __free_frozen_pages+0x873/0x1070
 kasan_depopulate_vmalloc_pte+0x6d/0x90
 __apply_to_page_range+0xbdc/0x1420
 __kasan_release_vmalloc+0xa2/0xd0
 purge_vmap_node+0x220/0x960
 __purge_vmap_area_lazy+0x779/0xb40
 drain_vmap_area_work+0x27/0x40
 process_scheduled_works+0xb5d/0x1860
 worker_thread+0xa53/0xfc0
 kthread+0x388/0x470
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

