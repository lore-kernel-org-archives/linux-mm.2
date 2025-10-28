Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB828CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 20:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC2968E000A; Tue, 28 Oct 2025 16:58:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9A638E0005; Tue, 28 Oct 2025 16:58:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD8EA8E000A; Tue, 28 Oct 2025 16:58:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA7688E0005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:58:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A11DC0539
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 20:58:36 +0000 (UTC)
X-FDA: 84048736632.23.6050AA1
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	by imf08.hostedemail.com (Postfix) with ESMTP id 84271160010
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 20:58:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf08.hostedemail.com: domain of 3eS4BaQkbACoYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3eS4BaQkbACoYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761685114; a=rsa-sha256;
	cv=none;
	b=iY7D+r8X7ejpgRgG3UbH9cAbbVWAuSAktfHp5eFWkJLCMCjmXQysPqzW+CbCcZSrxOWSxL
	/yYlmHEXlDwylytAa9LnDqEZZ16b5HDnH3HSrrAuf11hLcshkfsid+9fh6lqr4K21k2d1g
	w84ecKKvJJchVcZCllvHT4Vepqo13vk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf08.hostedemail.com: domain of 3eS4BaQkbACoYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3eS4BaQkbACoYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761685114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=d8Q6xMc7Ndu8q4AA2QZ12NoLPaoVzQEf+yv3C2w/BPw=;
	b=XEh+TdehkzM3DI8MdXnPXpEKIaOZkk316KeY/XvmIgvK9I/XLvZ7eLDnUvIvCwIGtkVuss
	D3Qq6a6plhMcjfSRKKlqdZvSogHfukcqQMDC3XvAOdUNP6l2l9xw2IpLJAMRL3RDz7EWlC
	Menifo2S9Hhe4RLsMUM03UIUI08zCsY=
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-430b3c32f75so68671865ab.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:58:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761685113; x=1762289913;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d8Q6xMc7Ndu8q4AA2QZ12NoLPaoVzQEf+yv3C2w/BPw=;
        b=kIlmOztAwldD+iuIOPm02vqkZQ039BGuNesjlizdDf3uy6afkTf1EjQOdVOfbdENhG
         GcCbk0fi1vfZfXkemOFyte1QDXyqnP7lzbkyBr0nAfYpsOpdHCDc2KMRV6lMTd3XLn3i
         BadMo3r6IFdXJQnx7jmdct90IH6uNpWn9SFtOY07IJVaKwBdJS+3Yw5XWpfiDjbGEqLP
         XD4St1y2xnjk4grSwPvo0OdqQx05tEz0jr/l8f9p3eHTW5YfK3JDZBoHUke9EGntK6mX
         we3EbuLscJYSSc5VQ5GSdrXD2S7JR2wzDHI9hNNoFyXgTq3TmNdFGFS4sdYCy6H1n/Jv
         GYHw==
X-Forwarded-Encrypted: i=1; AJvYcCWRN5YDX0NpH5hTvEIGm8eh2p34DNgz0qEcVT3/rXp7s8kvR0Z2S81y9reWMWpnqjku0EKlYxz0Rw==@kvack.org
X-Gm-Message-State: AOJu0YxN25jBZ09NV9I86+JAlNg2Rs2GHxXtVz2K9fX9h4ub8SCOUrHh
	E4ecE52/AvaiQ2qTbUUwxfqcKo0eucsiqPX3wydt2rtcOIvPNIEwZ4Muo9MVW4vW/jm29sf1qTe
	lu0/WTdNcmbJ9IT2DxympK36pzdSccNpalo8yAulQAcNSASOu2FQEMksw7Pk=
X-Google-Smtp-Source: AGHT+IFDFBbc8Cb1UY0q9NJksMCDOPUyRjNT8FEq3e2eFa+YqZJej0oEiYsoupU3doybBUYAA/Hw2lsuh3cPLS+djdwOlI5htbTy
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3003:b0:42f:94fd:318f with SMTP id
 e9e14a558f8ab-432f8fac67bmr9677295ab.9.1761685113513; Tue, 28 Oct 2025
 13:58:33 -0700 (PDT)
Date: Tue, 28 Oct 2025 13:58:33 -0700
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69012e79.050a0220.3344a1.03ee.GAE@google.com>
Subject: [syzbot ci] Re: Eliminate Dying Memory Cgroup
From: syzbot ci <syzbot+cie7d8f1fc805fcd7a@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, 
	cgroups@vger.kernel.org, chengming.zhou@linux.dev, david@redhat.com, 
	hannes@cmpxchg.org, harry.yoo@oracle.com, hughd@google.com, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, muchun.song@linux.dev, nphamcs@gmail.com, qi.zheng@linux.dev, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, songmuchun@bytedance.com, 
	weixugc@google.com, yuanchu@google.com, zhengqi.arch@bytedance.com, 
	ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 84271160010
X-Stat-Signature: gf4h363hc6di78rhuhoc5t8afn9szc8x
X-HE-Tag: 1761685114-29504
X-HE-Meta: U2FsdGVkX19VkecDE+elwH0xAZ2jiD7e6nW8M6k7dqV796p8rDbuCQ+9VX3bMh6JOL1lE6pr32b8CXVct80QDvBEhnRZY5zpthLlRq1UhL6isFgkXqEa4WE2CwQ6dt+Xqbnwjr3HlTSa90D9rT4oILjKOg4ApBdv9oYLMgsaFDAEBZ/9mVnkGg1I1zzOaZKl9dV+6byHlXDgzY46pW/3EJK9ehJXO/b2fV4tS0uqa9v1Hol6KZ43yEv4q/z8wZLmNfJMdLfF+PWX3P7+cXgclCtDTQgapiOaKCM5je2a1T63e8jhZfYaDSX1E5x9ZlBtOfABjGaQbihBnZQ/BdAcP8cU/oJpFkQ8VAhMjH1zBN8buaKNW0iV0we6ecnA7Q36woF368KvaKNEiql3Ztnacnw8qFdV+8pAB6X33+GJEh2FGdnueHxRlEN1B+ZSrYaSzYbaMyx611cw4M37VMMS9kj8wzOyjPEf4gfObBQ5Le4TCI1INVdnu0W9ZyIwNC+3QhFnbYzvlXdY7R+U+vSaeN2317A+5WgjNhMC2O8FFYsdZP2ZmbNupdAKALNogaQ8pdDMD3NOsQES6h4RbDHlMwiXd3Bh5hz7fJ5vKlny5B7PSyaO3Lv1MW6FvRe/Enb+d7LCWRV8kjSzOQblvG5drZZZIvXIfy8rIFf0jdnMNXp3iWQalZA+4p0KwMUGmn84iGbPecbxMbYLSNg881QXNIk6OPId3GtoIBYxXr3d3uvdF2qkBmKJrJfkgJonTCDtrNfznYuzU1tbGaAH5IRG+X3utkL4dYiXSHxKYV8CGYrbtMlqV0pU9q9bC8pzDEsXqLfb4AqP5hLCJiiy5p8tA4nrrIZ226jaVAY1DdFcZENbDUE6pcJgyL0bhaRd0NCIsu12X9DwPewR0nFHOObIKSpGVyWOXC2CcNgkj60HR3SSBIFHIyfVG79gWRDNjwLYBpNZg6H5iw6jYAYf3Nx
 mKjEQFXs
 J9GvMlYKL4RN+M2eh41y1FbiHZx839rH2bkrrmI9mTsZmZ1zNnYp5/inH+I9nSzB8keH1rC+Vcea+Ej9vAxP7K/NbmQv1MBZ9ZBncuU8RKpry3vy+odQYrzAPbdIdT7186/yvaG8ghR6syjFwdmpWe3hfAuz8k7AJviUopyWlEyVYpZCK2VyIe4n8QI7E9/jvczLJETHRzJWBtatFXHixI1+eo/Yeg/ZToKu5lyZYmVhXFBeMdF81UbZkuqabHVIYDKFXeeoXpKE8m5dQqPWKRcuktO/s41wUOtsP2iS8HC64v0aQk1LS2EIgPVzsk4ULCZC0VzHbL6t1Yeo/8Bd7ClfZBq7Y4dA0BxjNItATnBA0PhrpXNIb5Mp7D+OXLJ646FlLRT2SH1EZrZYb3gGoEcHAFrHLwVu646GnUX/qJPt1ThRr0k9z1zXhJM11d/zSMV+Cl6F8jm+qz+K3f7YS09X698TwE3dunMNl3NqLUrTxwreXKFOgfJT0T6uNNGSwWLvYrNSwNlUKUI8h7LWZS4r14MturR5CcaNxxW3++yop7iLqT+3sPW7BsC/DVoDju7HqwEpWVm8SbSs6wqo6Rj1ooi1aqZS3K/vlSB+8qS9SXrTw4zmVvFWqGl4jWyLs1rHHOjJFO0MSU2NWNwLNHosf7Csq5RnpyN1mvDC2KKD/fRQFoeHL5XOFef+kE2Clsk/ag2yBiNvI+f0fPplpKhXmJH/AtFNfkiAfCvehLS2Gu8FkvuR61Hhf1nYGe09g5rGURFD21icUFMr6ME/pbGvWtOxeY8L/2ZPAhzfeFKF2CvKOM9Vyar4umS/+uCQ4R6OSIN6haV0N6KuxxG2JLH799sGfwnKKSWd//EKdd07tyO36LwHCLBy9+y/HVgfPXEhm7L/zgCT9CTrjSIm7zCnISEzdJSC/HYi2+WBbKvR5R6y9XQgA0Z63p2AQhqck8wCejEqLuFtA1bEnVHyu747PO1Jr
 ruXVgUrg
 FZfnf8Y8MoILZEPnkiqvXPH18JWWLWQ+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] Eliminate Dying Memory Cgroup
https://lore.kernel.org/all/cover.1761658310.git.zhengqi.arch@bytedance.com
* [PATCH v1 01/26] mm: memcontrol: remove dead code of checking parent memory cgroup
* [PATCH v1 02/26] mm: workingset: use folio_lruvec() in workingset_refault()
* [PATCH v1 03/26] mm: rename unlock_page_lruvec_irq and its variants
* [PATCH v1 04/26] mm: vmscan: refactor move_folios_to_lru()
* [PATCH v1 05/26] mm: memcontrol: allocate object cgroup for non-kmem case
* [PATCH v1 06/26] mm: memcontrol: return root object cgroup for root memory cgroup
* [PATCH v1 07/26] mm: memcontrol: prevent memory cgroup release in get_mem_cgroup_from_folio()
* [PATCH v1 08/26] buffer: prevent memory cgroup release in folio_alloc_buffers()
* [PATCH v1 09/26] writeback: prevent memory cgroup release in writeback module
* [PATCH v1 10/26] mm: memcontrol: prevent memory cgroup release in count_memcg_folio_events()
* [PATCH v1 11/26] mm: page_io: prevent memory cgroup release in page_io module
* [PATCH v1 12/26] mm: migrate: prevent memory cgroup release in folio_migrate_mapping()
* [PATCH v1 13/26] mm: mglru: prevent memory cgroup release in mglru
* [PATCH v1 14/26] mm: memcontrol: prevent memory cgroup release in mem_cgroup_swap_full()
* [PATCH v1 15/26] mm: workingset: prevent memory cgroup release in lru_gen_eviction()
* [PATCH v1 16/26] mm: thp: prevent memory cgroup release in folio_split_queue_lock{_irqsave}()
* [PATCH v1 17/26] mm: workingset: prevent lruvec release in workingset_refault()
* [PATCH v1 18/26] mm: zswap: prevent lruvec release in zswap_folio_swapin()
* [PATCH v1 19/26] mm: swap: prevent lruvec release in swap module
* [PATCH v1 20/26] mm: workingset: prevent lruvec release in workingset_activation()
* [PATCH v1 21/26] mm: memcontrol: prepare for reparenting LRU pages for lruvec lock
* [PATCH v1 22/26] mm: vmscan: prepare for reparenting traditional LRU folios
* [PATCH v1 23/26] mm: vmscan: prepare for reparenting MGLRU folios
* [PATCH v1 24/26] mm: memcontrol: refactor memcg_reparent_objcgs()
* [PATCH v1 25/26] mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios
* [PATCH v1 26/26] mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance helpers

and found the following issue:
WARNING in folio_memcg

Full report is available here:
https://ci.syzbot.org/series/0d48a77a-fb4f-485d-9fd6-086afd6fb650

***

WARNING in folio_memcg

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      b227c04932039bccc21a0a89cd6df50fa57e4716
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/503d7034-ae99-44d1-8fb2-62e7ef5e1c7c/config
C repro:   https://ci.syzbot.org/findings/880c374a-1b49-436e-9be2-63d5e2c6b6ab/c_repro
syz repro: https://ci.syzbot.org/findings/880c374a-1b49-436e-9be2-63d5e2c6b6ab/syz_repro

exFAT-fs (loop0): failed to load upcase table (idx : 0x00010000, chksum : 0xe5674ec2, utbl_chksum : 0xe619d30d)
exFAT-fs (loop0): failed to load alloc-bitmap
exFAT-fs (loop0): failed to recognize exfat type
------------[ cut here ]------------
WARNING: CPU: 1 PID: 5965 at ./include/linux/memcontrol.h:380 obj_cgroup_memcg include/linux/memcontrol.h:380 [inline]
WARNING: CPU: 1 PID: 5965 at ./include/linux/memcontrol.h:380 folio_memcg+0x148/0x1c0 include/linux/memcontrol.h:434
Modules linked in:
CPU: 1 UID: 0 PID: 5965 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:obj_cgroup_memcg include/linux/memcontrol.h:380 [inline]
RIP: 0010:folio_memcg+0x148/0x1c0 include/linux/memcontrol.h:434
Code: 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 5f c8 06 00 48 8b 03 5b 41 5c 41 5e 41 5f 5d e9 cf 89 2a 09 cc e8 a9 bb a0 ff 90 <0f> 0b 90 eb ca 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c ef fe ff ff
RSP: 0018:ffffc90003ec66b0 EFLAGS: 00010293
RAX: ffffffff821f4b57 RBX: ffff888108b31480 RCX: ffff88816be91d00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffff88816be91d00 R09: 0000000000000002
R10: 00000000fffffff0 R11: 0000000000000000 R12: dffffc0000000000
R13: 00000000ffffffe4 R14: ffffea0006d5f840 R15: ffffea0006d5f870
FS:  000055555db87500(0000) GS:ffff8882a9f35000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2ee63fff CR3: 000000010c308000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 zswap_compress mm/zswap.c:900 [inline]
 zswap_store_page mm/zswap.c:1430 [inline]
 zswap_store+0xfa2/0x1f80 mm/zswap.c:1541
 swap_writeout+0x6e8/0xf20 mm/page_io.c:275
 writeout mm/vmscan.c:651 [inline]
 pageout mm/vmscan.c:699 [inline]
 shrink_folio_list+0x34ec/0x4c40 mm/vmscan.c:1418
 reclaim_folio_list+0xeb/0x500 mm/vmscan.c:2196
 reclaim_pages+0x454/0x520 mm/vmscan.c:2233
 madvise_cold_or_pageout_pte_range+0x1974/0x1d00 mm/madvise.c:565
 walk_pmd_range mm/pagewalk.c:130 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0xfe9/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_vma+0x393/0x440 mm/pagewalk.c:717
 madvise_pageout_page_range mm/madvise.c:624 [inline]
 madvise_pageout mm/madvise.c:649 [inline]
 madvise_vma_behavior+0x311f/0x3a10 mm/madvise.c:1352
 madvise_walk_vmas+0x51c/0xa30 mm/madvise.c:1669
 madvise_do_behavior+0x38e/0x550 mm/madvise.c:1885
 do_madvise+0x1bc/0x270 mm/madvise.c:1978
 __do_sys_madvise mm/madvise.c:1987 [inline]
 __se_sys_madvise mm/madvise.c:1985 [inline]
 __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:1985
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fccac38efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd9cc58708 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fccac5e5fa0 RCX: 00007fccac38efc9
RDX: 0000000000000015 RSI: 7fffffffffffffff RDI: 0000200000000000
RBP: 00007fccac411f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fccac5e5fa0 R14: 00007fccac5e5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

