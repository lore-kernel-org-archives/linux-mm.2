Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B755CAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 07:39:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4748E0003; Mon, 15 Sep 2025 03:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 465198E0001; Mon, 15 Sep 2025 03:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3538F8E0003; Mon, 15 Sep 2025 03:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 183BB8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:39:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A7DC111A353
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:39:33 +0000 (UTC)
X-FDA: 83890684626.26.24AFD13
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2D9B6180007
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:39:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf16.hostedemail.com: domain of 3s8LHaAkbAKQWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3s8LHaAkbAKQWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757921972; a=rsa-sha256;
	cv=none;
	b=sZX8IxYDqvq+b+X9HmHzoCGMPfpJ+zm87lXVSL+i6d8xLXL0lPRl6OlfKLSsKJMHk/72tD
	Bg43p+Z3tr1FRT8OVwI3wdmtqOii9fLCgzk8Ly5HeUj0hJb8R9VdJnfcj4WckLMrbn5Qha
	u02yX0H3hfo78qG8soMRUjCGoxOC5N8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf16.hostedemail.com: domain of 3s8LHaAkbAKQWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3s8LHaAkbAKQWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757921972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=dySGFBgkjVikd0fQbO38RWU4Co2WfmuOPRpUI/qZ7rY=;
	b=8PNEbWm7Nk0azIiYi23Cv9rDjClCvFKOuizfINRDgmJBwGKf/JsfFChpU0ypwIHc+O7dzr
	aJ2u+AeOTwW4mvrgBfkmFHygIBCVImCGNbtHuXCVTY2fssLhp8kiFfrgl9LkRGpdxDMY5k
	CB2aAhRSdscXz/WDeL4Z/+X3oMOxuXI=
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-42404bb4284so9466225ab.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 00:39:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757921971; x=1758526771;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dySGFBgkjVikd0fQbO38RWU4Co2WfmuOPRpUI/qZ7rY=;
        b=vE67oHEsxBJDO19/xEBjCBmX/u/3NjGGNBEGJBM84B09r3jE+J40HoZR7ygqm6lUXA
         ASPxY599lNCbFBd/CMwctg+9gPVZ2OAh+TeSF/jVjUOsrWxqziHbTwTb66kRaxn9ekEA
         BNK9q9e8WTu9+//6PPXrlAKrAPnOYv0NLfkQI/cH6MMJKTnzrj7l08nCpnHGLAjFhbWq
         WYGe2pLOFSq8G1vse38GtqPsZb/11zbW5i1/wS3z8pzomc9BtgFDK6AYwB3Za5efBxxb
         Dx9huXnTW2p08bEndjSww/+iMwesspO1VqvYiGwCA1K5Y7lrq2EE1DjDcR4mxEC/EOQV
         nwJA==
X-Forwarded-Encrypted: i=1; AJvYcCVOO+xs8Bt9Pb+uzmneWEpzJC9YmpAl+LU0kb1gukLoz/E2WI3k8YqQDDX32U5i6HyH9ZptqQmosw==@kvack.org
X-Gm-Message-State: AOJu0YyZPM4UpA09HES+JjEJ2Jx+c8kEoQDPAEqLyXXSLUu12ojbonEA
	oPE5E0THMDJD2R9EKv96mVj8SD94njfkwg6ndS8pZ4RDQ0ENhbEisO/3WyQ4ACAunO6Zadg29Rq
	cNTaXHI+2Y8Y1NEXUFWC7Oxf5nrRT+imKaVDNjRDoyXABeT7e07xuVwTrp0k=
X-Google-Smtp-Source: AGHT+IFdD8J1/tqennnnYbtE6aacxehX04c8H9Jsk4npPASwTOfAeBWIMgByP67zeYFcRb+dBaZUY3fTma0MjIalYfWiA8NPZ/2e
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a2f:b0:423:f9af:b8c9 with SMTP id
 e9e14a558f8ab-423f9afbb98mr49790265ab.18.1757921971229; Mon, 15 Sep 2025
 00:39:31 -0700 (PDT)
Date: Mon, 15 Sep 2025 00:39:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c7c2b3.050a0220.3c6139.0d0d.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in ext4_mb_load_buddy_gfp
From: syzbot <syzbot+fd3f70a4509fca8c265d@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, 
	rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2D9B6180007
X-Stat-Signature: jay1ntttmzf43asyxfmdrpyms6xfuqqp
X-Rspam-User: 
X-HE-Tag: 1757921972-335001
X-HE-Meta: U2FsdGVkX19GjVo0Kb8KrbSTNLo0Jo6HWLig8BTZaNSf2ZEfj2hVkQHLCY3YEUg/KovhQOOh1dyW+3FZeYmH2rv+8Zyyel8+QHnAYdDkDgW255pAj46ixAncHsS5mK3iDP5XOAh3+5WtFn6f1Mu5u2VehD3u8RSIcUW5SlT2sIPvx1nxWIuYq/DM9gXZMzyWG8dwyIHAVm2LkYnrfqKtDEluclqifBoQG1oD5L0Vl25Mw9qSt+I95AD0HzUhP1BCqDSPCdPwNZWnzMZBfZt78BishT3BKLLPEg2enrspZR9wzeO1mFjPRitj5JOjbejbf/Eb/XaynFtlIVtrf6CZhFFZ/ZgDTC6EYPC6+YeLq/RZF2/LGssilVXc3UDSWb5lQ553nQqLuwQU6NTAoLG4CXb0aiEh3+7iUKilVVIoCgzJir/AeCLvyLbWVP07RdCfCtpgEldPlEEsq0qi+Q0JEaWP/GJ6tNNBVXwDc60hSTJFCzj8IEMufcsA2AO25Vpm0LrLV8pcf1q79ZpKEEHnSPcc6zojR4rS0NqPY4RvMdFilRjoFeXOhop8z4GJ+9Mmc5GSmLgHXwqNNtz2rUnmoqG9/Q5UTWCkl70hru6pGZsrYC7JtyxOzwzudNNLRcMA5lb4HxU2wCO08ywOWsKpzUE7QilY4rReG+vmwXNsWOcpfFo9FKD3Rq7Ynfj7DKLfnkt5QrdinnsNx1IAfYIhFe3hK6P0/9iCk+ZfrK/AltzJ0PBOrzvxDXRmxw4ZE+Jqx7P8WKdhEJY0YtKUojcBG9qGE3BqyvunauskeAti7+7waALjUHKogb+VHbKm8JBZ3d0GxYLHl+gJh1F/b+LzmXKsMsegxRC0JNE1RBPu4XYXnstmhsTIiCoIoi+5jdjCf9Qh3OQtM9g6bHPQAfgIPwILbT/JqhNvkwGT/BmwwQ3NsygleCKS8coeCznDG2xdoK9FYKXrJawwXPYhdY0
 5+IIaBUo
 DVAvE3HVwd3Blvc1xzjrV5MpFDQHn1UTp3vxjqU7n9bHyT/wsfZl9IpjulAL7c1H3DPGJchx00BAxp7d8Ao0Bv9Cv9tmF/PERqOGuYpMTnHitVsTh+ttOwA92DRGJ5HTFVEd7+9jD5YHjXpmjvD4hssuGUaFuD8tDjV5klpw3UxJn9l5/BlFD5Um4r8cIQS/X0hJNhDCri5V9gtw/aIblQxHiNCoc7MpfuVLZael7A/Y88cPopJLKxHbBFrIC3QZMVcfC0K8dvK7eoWueOtSwNb4J6rc3n8pJ61NzOVgq25CPIHB3aMQkXWmfVoKjbbDgIut+3NQFTuUGUIGmeny1a7cBYddX+99ndu2wKHDaFA8zK0WyIjRWGJWMpiOWvGs004FYPRtJO4C2/ILAu+m+WuMiAz+xm3vZkuL4iCaxgpCrgZISm2vkrYueMnX71Ei2G1rvHo3fIsZ7qok5PIYyL8kAuukzj6NJla2LjSSzr7RuymB/T4mWG/u0JV0/Ght+u0ly+BuLd6pwVL55czrTMEhCEtc1uw+oI/5kBPzyUssq99pw+qLuZ7Pessl/4Nl8W7tqXImnXU/oM1uao6D8iBI70w/XuInG065HVKUT3HveDfHJOl2ifXR0jBeO3boY0nHzTpQvpPgrlSymZyGWHVUVN9GC3gzbzFE6lse0cZVKjhc8TS4lt/XFvjVu5OdPi9aJ7SuGAItGcr60XLi+nlx/5xNn5nNOQO24Ws4mPtKK5mRlztyHHNs7/7odmb9RXDgJ+g965axj5/FKqEIRNoVTXpbzFxx/yz/jn8yxk6UOCQNPrxz6I788AQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    22f20375f5b7 Merge tag 'pci-v6.17-fixes-3' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1252eb62580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf99f2510ef92ba5
dashboard link: https://syzkaller.appspot.com/bug?extid=fd3f70a4509fca8c265d
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=154ed642580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17af7362580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-22f20375.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ecd89a64f115/vmlinux-22f20375.xz
kernel image: https://storage.googleapis.com/syzbot-assets/73fd42b48d3c/bzImage-22f20375.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/3c9e74db5034/mount_6.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=114ed642580000)
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/1c25a03fc55a/mount_8.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=13af7362580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fd3f70a4509fca8c265d@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5744 at mm/page_alloc.c:4630 __alloc_pages_slowpath+0xca5/0xce0 mm/page_alloc.c:4630
Modules linked in:
CPU: 0 UID: 0 PID: 5744 Comm: syz.5.31 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__alloc_pages_slowpath+0xca5/0xce0 mm/page_alloc.c:4630
Code: 48 8b 1c 25 08 60 a1 92 48 83 c3 2c 48 89 d8 48 c1 e8 03 0f b6 04 08 84 c0 75 2e f6 43 01 08 48 8b 14 24 0f 84 a2 f3 ff ff 90 <0f> 0b 90 e9 99 f3 ff ff e8 1e 55 64 09 90 0f 0b 90 f7 c5 00 04 00
RSP: 0018:ffffc9000d656050 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff888000bba46c RCX: dffffc0000000000
RDX: ffffc9000d656160 RSI: 0000000000000000 RDI: 0000000000048c40
RBP: 0000000000048c40 R08: ffff88801b2f30cf R09: 1ffff1100365e619
R10: dffffc0000000000 R11: ffffed100365e61a R12: ffffc9000d656160
R13: 1ffff92001acac28 R14: 0000000000048c40 R15: dffffc0000000000
FS:  00007f7ccbb366c0(0000) GS:ffff88808d20a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f94b93a8638 CR3: 0000000042c26000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __alloc_frozen_pages_noprof+0x319/0x370 mm/page_alloc.c:5161
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_frozen_pages_noprof mm/mempolicy.c:2487 [inline]
 alloc_pages_noprof+0xa9/0x190 mm/mempolicy.c:2507
 folio_alloc_noprof+0x1e/0x30 mm/mempolicy.c:2517
 filemap_alloc_folio_noprof+0xdf/0x470 mm/filemap.c:1007
 __filemap_get_folio+0x3f2/0xaf0 mm/filemap.c:1981
 ext4_mb_load_buddy_gfp+0x281/0xeb0 fs/ext4/mballoc.c:1709
 ext4_discard_preallocations+0x66b/0xec0 fs/ext4/mballoc.c:5660
 ext4_clear_inode+0x40/0x1c0 fs/ext4/super.c:1503
 ext4_evict_inode+0xa67/0xee0 fs/ext4/inode.c:321
 evict+0x504/0x9c0 fs/inode.c:810
 dispose_list fs/inode.c:852 [inline]
 prune_icache_sb+0x21b/0x2c0 fs/inode.c:1000
 super_cache_scan+0x39b/0x4b0 fs/super.c:224
 do_shrink_slab+0x6ef/0x1110 mm/shrinker.c:437
 shrink_slab_memcg mm/shrinker.c:550 [inline]
 shrink_slab+0x7ef/0x10d0 mm/shrinker.c:628
 shrink_one+0x28a/0x7c0 mm/vmscan.c:4954
 shrink_many mm/vmscan.c:5015 [inline]
 lru_gen_shrink_node mm/vmscan.c:5093 [inline]
 shrink_node+0x314e/0x3760 mm/vmscan.c:6078
 shrink_zones mm/vmscan.c:6336 [inline]
 do_try_to_free_pages+0x668/0x1960 mm/vmscan.c:6398
 try_to_free_pages+0x8a2/0xdd0 mm/vmscan.c:6644
 __perform_reclaim mm/page_alloc.c:4310 [inline]
 __alloc_pages_direct_reclaim+0x144/0x300 mm/page_alloc.c:4332
 __alloc_pages_slowpath+0x5ff/0xce0 mm/page_alloc.c:4781
 __alloc_frozen_pages_noprof+0x319/0x370 mm/page_alloc.c:5161
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 folio_alloc_mpol_noprof mm/mempolicy.c:2435 [inline]
 vma_alloc_folio_noprof+0xe4/0x200 mm/mempolicy.c:2470
 folio_prealloc+0x30/0x180 mm/memory.c:-1
 alloc_anon_folio mm/memory.c:4997 [inline]
 do_anonymous_page mm/memory.c:5054 [inline]
 do_pte_missing mm/memory.c:4232 [inline]
 handle_pte_fault mm/memory.c:6052 [inline]
 __handle_mm_fault+0x2ab9/0x5440 mm/memory.c:6195
 handle_mm_fault+0x40a/0x8e0 mm/memory.c:6364
 faultin_page mm/gup.c:1144 [inline]
 __get_user_pages+0x1699/0x2ce0 mm/gup.c:1446
 __get_user_pages_locked mm/gup.c:1712 [inline]
 faultin_page_range+0x240/0x8d0 mm/gup.c:1932
 madvise_populate mm/madvise.c:979 [inline]
 madvise_do_behavior+0x2e7/0x550 mm/madvise.c:1883
 do_madvise+0x1bc/0x270 mm/madvise.c:1978
 __do_sys_madvise mm/madvise.c:1987 [inline]
 __se_sys_madvise mm/madvise.c:1985 [inline]
 __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:1985
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7ccad8eba9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7ccbb36038 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f7ccafd5fa0 RCX: 00007f7ccad8eba9
RDX: 0000000000000017 RSI: 0000000000c00000 RDI: 0000200000000000
RBP: 00007f7ccae11e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7ccafd6038 R14: 00007f7ccafd5fa0 R15: 00007ffd394e0938
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

