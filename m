Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1B91C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 08:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93DD26B01F1; Tue, 18 Aug 2026 04:25:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 915A76B03F6; Tue, 18 Aug 2026 04:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8533E6B03DD; Tue, 18 Aug 2026 04:25:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1E36B0788
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:25:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1486340ADA
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:25:00 +0000 (UTC)
X-FDA: 85113704760.08.4AFFA8F
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by imf13.hostedemail.com (Postfix) with ESMTP id 60B7D2000C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:24:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf13.hostedemail.com: domain of 32RaEagkbAHIiopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=32RaEagkbAHIiopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787041498;
	b=SVOpWd2+l2IehpIJjQNsiFkINBpCE4MtZBTNzXy6jFJBNnNfuW8cJLqQf2cfTqcF0SR6bT
	Pcx0go0wad3bAx1PkaIu/SFUkL2tZ7Q/xtK0X6gSVum2nma2+DdWmC30c59kD+LCdT3a0/
	331CMnbKjHDQnnqA7xGnQY5QkPMTYmI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf13.hostedemail.com: domain of 32RaEagkbAHIiopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=32RaEagkbAHIiopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787041498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=O58fmBB+gdrGTSPuDeyTUQq/CrJ5CHQIBvvW90VjttQ=;
	b=e1KVPC6NVQzbPyQe4Yis/niwAgl09k35zJ7IsVuwKjaipILnRNwbVjsebLI0vMrcqhvB5a
	WDghxJVMB8tkgAEn/d/vtBBvnqBpGORrt4lXFFtYm2XSP1AlsGaZf+OPwsyw+vUi9h47m4
	wFCzfckDbg4Wn0XBTJnRinJgNg0P6rI=
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7f4026a59cbso1667917a34.1
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:24:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787041497; x=1787646297;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=O58fmBB+gdrGTSPuDeyTUQq/CrJ5CHQIBvvW90VjttQ=;
        b=ih7HVMctoCqBQv1OLEzAGQc9tYYt6zbs86XuKDU/0qeSB+WXeIRsaPmxFc9BB8sb57
         FTBuqsI8t2SpRZd4vueNSmGjYHCdIUGz54qmPQt4lPG2A6BM975AfRQDoFOj+7swEydB
         bwuSrVBdHSkqJlApcIoBTSIz3lV48Ea0rEl20bI2RQ+yaerEJxMn8SoYVapafdOQ4fm2
         gXmfppDWLXmjbMQXtYWBh2CiGaSjdX7O+hKp+wbJPROuGor+geEq1E76qE1pXDDHVdvA
         6otGtDn7829a77kC62BHzKDK0xRBDScqzM81/2q51P2jHzWfywMPnG3YDtaj/DZ/gN/e
         vJaw==
X-Forwarded-Encrypted: i=1; AHgh+Rr/7Ft1f4dvii/48fi1hnqUJt8YNmKxcvzwJN3RzuPP0gwY/wteEOnrCinffkYtMoy7B1fmAotocw==@kvack.org
X-Gm-Message-State: AOJu0Yy+ioGjXfTcdnptFioVL5Iz4z3xw3bNzg008yvSsfULx+CH758J
	d5DMXdwruuMMCN9P+MEyrKNC5SBIB1g06lm2/hAZbURMHxTWPj3uUU8BqC/cVx5iMUkiFa7hL9m
	PjBXh906XbgqDvB+Ws4YhPE0FUN2aF/zuYbtsCHXptuwU3axKEtrjRx1GK50=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c8a:b0:6b0:f389:da5a with SMTP id
 006d021491bc7-6b11dd3244amr5374544eaf.8.1787041497264; Tue, 18 Aug 2026
 01:24:57 -0700 (PDT)
Date: Tue, 18 Aug 2026 01:24:57 -0700
In-Reply-To: <20260818023121.100613-1-liuqiqi@kylinos.cn>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a8416d9.f7a79266.2f965f.0033.GAE@google.com>
Subject: [syzbot ci] Re: mm/memcontrol: introduce per-tier memory accounting
 and control
From: syzbot ci <syzbot+cid780730586e082da@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, liuqiqi@kylinos.cn, 
	mhocko@kernel.org, mkoutny@suse.com, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, tj@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 60B7D2000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9cnmzems9d8gsyidbbkabec8fi8arbi9
X-HE-Tag: 1787041498-926620
X-HE-Meta: U2FsdGVkX18TTE1ObrZLVv8zlRvvFV8XJUSSQI6UzIy/QkL/j0vA9QtsWEhdoXxQTcU2eTvA23nhxd+5BZf0JJ79cPys2b8K+xnDC37c7qFZrORjYLvqclLmP0xNQSUIX/jtdcwLvCYsEVIk4oLEQg7L8TIBVZjWnZi4m/LHTtTILBCfUbzEBmNnarKYp56ScVDB8Zxae6aYCX2ngnwqGr63IvMcscMGK1LhypSLc9H+EQJq6T4nip9STVcYqoDYbtzfbk2mZY9bdKe4/YovvcEbfDeMxyAJlKnhqcUVI67VXYs08HXovoftqBYOpUJRKUnwNRpL63xtYgiy93YOh/jHq2rQw2nAguDHanJF6AgP+sTkE9eFhHBMmDsrHLVEE43FF3jeaCsxuyu27tvPSLmt//ejgJOjkZx+IK2JEnIte5wzUb9HCOxd8jLSGEZt0+SdkrGaU4oYRQGAqCR3SdMj8nOPtcucWM7C8id3SX6AHn5hpWOO5NH3pPK8pvTj5FQ8cEm2k4JQWguHkvt0v6z/yYhBUhW00G7zvqeMZ6Xa8zJNattxlZVmD4B/G2rODP1Zxro45+9q90zmB3woEps3EkMAkdrUHHjACcj8BVAI/5B27kbKvJoWKEpt/zkrmW1tzCP0AixT6nAL1tYO5TjnXFM3R1Sb5Q5CpmlH7HVVQAYfAeO8i2AYlBZ/om+yyd7ptVzMjUEjg+eVjPAiVeWmHaOySewvSO+yav0hI+5FMrc7odEYq93txwcwS9wrbcFMrZE+srb23O2AK96dFO5hws9JKwVUXcqTHrPLU7Hq656tgFQobJiR4Uh01oS/miZhLOjFX1iKp8TZUw/IC84X6of3ZVlTewbzj7781T2lcIearwXoTRQ3h4HYmJvWN29oAgMvPmqH+K+J5Ud69XcLclBt6GAVLKUPWTy+8yABEYufSiVxbuXvGBICt9F+0KElazMdYh9nWAugcx6
 euwdyjVo
 U+Q8TqoHL6xeq3daoTqEadHMBF5BawVyVZQtgbwLVi+nuIxA1wHaPO9nt+/fg09AwVdp7OPZ0Cra7F6Vzh4OEVpmValHpjDrHCH/mR50/Re9Irhx6xSPV/abDP3qG3gV3+Tu38fibq3kMBrd+CCgLJcjDB5OrgPdSSMS3lKtLN7A7I/D62U4xymB039X6L+dL18z2iy/FrW8GKKq3yTzlEMOxIi1C9gGqK4FLKwoglfyDXQyM0p9hcOUS67gaD8uiowQdBEoGpvrHCWGAFVasPfoqqXDKw70WWIWlTQWuuq/FwkAlBzMUp6EifvD6Arq0Y4DSJfcvbfryYM/WrQYVdGj6K2nG3ekmVOsDFxN9FirfP8WCx6nSpyvI9XvgZLPLKjwzJe9eqWfXY/wlmqcObizQfUDkqwDB40kZKbCamPJF9CEgZvDC6TavtxAo9YA7xJuH2653UnSMVw7SYs052b4Iz3EHF2dVBtahmqzi/+hjHB01GHFBt4ItmNECoG+J3dII7LcoGtj/F6RNaIo6NBZnfxdzv6peAC6b3RiiKofr/i3BXhwdsxVv4VJamxLKadaOEYqgwSJH8qg+a2qTOjKLaOewDm/X8weN5JL6FNcnXXJYzCi+syR9pe3yAml+n5rxXHD+vK60g54Jk8vNgWHpd9fVSKiZcHJ8dE7ffWwiJ+zVMS6BBvkyW5gR7qFtBSKxYfXNt/y0Y/eJNaTY5MrGkRybrQZCjhniV/7y533SmrPeuVj31u7RpQnguC4Nrrs2EqSHMpElluKvQyXU9XVpESx87SC+eNSTg7GulKFX/cqxCiUVXrdeUTAmNUlUYsxr2mWN8HM3oTYVT1EEL/2yHejkfLPrEzZzKaOpXzWIQk4CSAEFD/NshxtDYus/hM1ySgXKLyxx4ROBAR1TcSEGnf9SbultD7wb63H5nQaO2+sagAGFssBDYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] mm/memcontrol: introduce per-tier memory accounting and control
https://lore.kernel.org/all/20260818023121.100613-1-liuqiqi@kylinos.cn
* [RFC PATCH 1/8] mm/memory-tiers: add node_to_tier_id and tier_id_to_nodemask
* [RFC PATCH 2/8] mm/vmscan: add try_to_free_mem_cgroup_pages_nodemask
* [RFC PATCH 3/8] mm/memcontrol: add per-tier page counter infrastructure and lifecycle
* [RFC PATCH 4/8] mm/memcontrol: add per-tier charge and uncharge
* [RFC PATCH 5/8] mm/memcontrol: add per-cpu stock for tier charge/uncharge
* [RFC PATCH 6/8] mm/memcontrol: add memory.tier control file
* [RFC PATCH 7/8] mm/memcontrol: auto-derive tier high/max from memory.high/max
* [RFC PATCH 8/8] cgroup: add memory_tiered_limits cgroup mount option

and found the following issue:
WARNING in uncharge_folio

Full report is available here:
https://ci.syzbot.org/series/9db711d8-d389-45d1-b245-7e8b316a8432

***

WARNING in uncharge_folio

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      dcacab904fe78d60840ba947a104993ee9ded887
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/bf213e6f-1b40-41fa-a938-385807688eec/config

------------[ cut here ]------------
debug_locks && !(rcu_read_lock_held() || lock_is_held(&(&cgroup_mutex)->dep_map))
WARNING: ./include/linux/memcontrol.h:391 at uncharge_folio+0x459/0x5b0, CPU#1: udevd/5681
Modules linked in:
CPU: 1 UID: 0 PID: 5681 Comm: udevd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:uncharge_folio+0x459/0x5b0
Code: c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 48 8b 3c 24 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d e9 88 79 00 00 90 <0f> 0b 90 e9 c9 fe ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 49 fc
RSP: 0018:ffffc90004ff7210 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc90004ff72a0 RCX: 0000000080000001
RDX: 0000000000000000 RSI: ffffffff8e4a6d0d RDI: ffffffff8c4bb280
RBP: ffffc90004ff72a8 R08: ffffea0006e7a7c7 R09: 1ffffd4000dcf4f8
R10: dffffc0000000000 R11: fffff94000dcf4f9 R12: ffffea0006e7a7f8
R13: 1ffffd4000dcf4f8 R14: 0000000000000001 R15: ffffea0006e7a7c0
FS:  00007f1ec7ce0c80(0000) GS:ffff8882a8f6a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0cdf670000 CR3: 000000017358a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __mem_cgroup_uncharge_folios+0xfd/0x1d0
 folio_batch_move_lru+0x86f/0xa60
 lru_add_drain_cpu+0xbc/0x750
 lru_add_drain+0x121/0x3e0
 __folio_batch_release+0x48/0x90
 shmem_undo_range+0x4e6/0x15d0
 shmem_evict_inode+0x280/0xa80
 evict+0x624/0xb50
 dentry_kill+0x1b9/0x880
 finish_dput+0x1a/0x260
 filename_renameat2+0x61b/0x9a0
 __se_sys_rename+0x55/0x2c0
 do_syscall_64+0x174/0x580
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1ec789a93b
Code: 48 8b 15 f0 64 15 00 83 c8 ff 64 83 3a 15 75 0e 48 8b 7c 24 08 e8 d5 d4 07 00 f7 d8 19 c0 48 83 c4 18 c3 b8 52 00 00 00 0f 05 <48> 3d 00 f0 ff ff 76 10 48 8b 15 be 64 15 00 f7 d8 64 89 02 48 83
RSP: 002b:00007ffcb336cd08 EFLAGS: 00000202 ORIG_RAX: 0000000000000052
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f1ec789a93b
RDX: 0000558c622ea032 RSI: 00007ffcb336cd28 RDI: 00007ffcb336d128
RBP: 000055893abc0910 R08: 0000000000000006 R09: f80f8ce6f311cb22
R10: 00000000000001b6 R11: 0000000000000202 R12: 000055893aba2730
R13: 00007ffcb336cd28 R14: 00007ffcb336d128 R15: 0000558926efb160
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

