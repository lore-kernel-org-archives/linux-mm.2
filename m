Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF916CCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 17:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B559F6B0005; Wed, 29 Apr 2026 13:36:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B06576B0088; Wed, 29 Apr 2026 13:36:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1C276B008A; Wed, 29 Apr 2026 13:36:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8FF4B6B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:36:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 408F91A0360
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:36:38 +0000 (UTC)
X-FDA: 84712298076.13.433B2BC
Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	by imf06.hostedemail.com (Postfix) with ESMTP id 89671180014
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:36:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of 3o0HyaQkbAEY067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.78 as permitted sender) smtp.mailfrom=3o0HyaQkbAEY067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777484196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=jiHUm98BDxZ3jihx0YOQdOmpKJWU+yfzKGqWIOvP2+0=;
	b=FacHin/4ZQe3M7QHb6TNE9qjOG4rQDe/ZLYF4tHxRVFWUMoJ1RpMCLOOl2KI5NwUUB40cJ
	nwWo3FE4iVt/syxrZf5vJthoP+YP9TJpXSVs6cXDO+1PxbyfUiO62cyzxFOHOH9c7pMmsf
	21lp/bk2acnLqTKQdxQM31hxyMPyak4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of 3o0HyaQkbAEY067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.78 as permitted sender) smtp.mailfrom=3o0HyaQkbAEY067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777484196; a=rsa-sha256;
	cv=none;
	b=J4mliZhNE9Y9zX4A1PxnUgRgLjJ0R8hewHEC+iaiDUqK5Rk3hIkrlr+ahCQ0y7TkhEwaXX
	h4vIZfu3z6lwaceO81iWHXsgXGHPaHaY1px76IbpQDI8+kXfEVc10A6Fu8PI6J7VzH1P1w
	GcYlFLfSsf1F8w3hgGLaBqU7kKTLzp0=
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7de75c9be06so244133a34.1
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:36:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777484195; x=1778088995;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jiHUm98BDxZ3jihx0YOQdOmpKJWU+yfzKGqWIOvP2+0=;
        b=msq/HNNRUoRGQUofdC/g/fjkHX35EJzAIBjGcjMfr6vecpN9i5wI137F9rv+68Z85z
         TysYZo1xwWKi+gDWyepxucYzxh6O58NQolVffdm17gLAlQrUH+xZ5ZfPdxCrM4wriAPo
         j8VgI76AwU4fwuQfG3NzvNEIKkdcy23YTRNuIqi+xHIrBKAOsiNP8MWArkgbha/Q6EHC
         qIxV3Asc23XSjNkJBdlw7k8ZMuf10MzJpj2yZFbi3GFYb/tgETtYqQPplqSobvtI2zBa
         cyzBUWqzSBliwSr6R0lVkB1yjzTO7s1HXn++c4/BzhuQJDRuA8s/S+CRGoq9YHXbi6fH
         l63Q==
X-Forwarded-Encrypted: i=1; AFNElJ8EWVD3w7qzdcWNcy1wtE8BuZJixcE/At1WPRa/d5jvMBeo264vyWlb5uRtFc/3QmLl2ZXP6yRThw==@kvack.org
X-Gm-Message-State: AOJu0Yz1BzoURDcpbCaJ1mv8eRgsSKpsoUAzfi6wFUuTGj/1Pwrol+Lk
	thIe7j7Jq3kHo1HMekBrp4gznYHLzFLR3wFf3RiQ6C4yXWWeE1te4RCejwCRPl1sb9QQN99cjQQ
	nCCD98dQW5dGk0xXNO27/7hJmDxWk3SQmcCWZf7IeldGbII+xj0ewvC+Zbog=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2908:b0:694:99e1:62fc with SMTP id
 006d021491bc7-6965cb5bffemr4338246eaf.41.1777484195616; Wed, 29 Apr 2026
 10:36:35 -0700 (PDT)
Date: Wed, 29 Apr 2026 10:36:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f241a3.170a0220.3c4978.0005.GAE@google.com>
Subject: [syzbot] [mm?] WARNING: bad unlock balance in finish_fault
From: syzbot <syzbot+8caf74f5399ee2d5212b@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	shakeel.butt@linux.dev, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 89671180014
X-Rspamd-Server: rspam06
X-Stat-Signature: 5rmqdwirjbd1nck7336ixte4dbrctyxa
X-HE-Tag: 1777484196-692679
X-HE-Meta: U2FsdGVkX1/A/eboru7EhfMeZEvMvaKAXrF9tTOpdVy5f/ORyR5KDtXNsPeQ5iCu8KV0gcwOFCN4ypdweNCJuVERQMalQjmpdi+ljVJy1nGDn4DyBiopm8BKrnueL+MtPy03jhSNnMtTn+/7zblUCpoq2J7/3hQ7RrjPtZlIeU0/jj8BSV2Ei6+CyFWv05EKDVgWHrfXiaMJhTiPVNmeztUq1OR8nPTkznpktv9EUR23YCNCF9XhR2hP/RSl6eGV31IegO4fDAHepbgoBGa5GyyMTQfUmvaXu1hmNX0tlwpNbWt8H80vnFVmCRisMqlNO5msiRHL7WLi7fzsDlUjzLR0iiXW2iXA4yKD7SFOqmyFs32ffy+ql4M4LlkCGDtA9pInFBffcMaoNTMX0spKaq2P4PaU8vN3KeJ8x5KFKHPCtDBnR4bWSpZ4q53tQncQaDhhclaZwZRh3jF4zkbwxa5T6Kd1PRzi6dWf2r0tN37lfMxvJ089uW7opeH1iqdEAS3ZTIJXd1M+oapXnIuv/aVq0VjrH2wm4CT6/0aWsBVBMW/xDtYuczlj7vqX//8y0R3jxu3KC34a5eHHNcyriqkyO5Vkk7/eU434geh78v9Tb2GIAFa4LdoYcD88Ug0Qm4h/ixA+AYukZEcjTJ+IqXPmwdaDUKDpGQuWFQq3gmj4/1nla7VHWuYyUx1VnRD2ctAtwnzpMS0fbV1ROoQHRftdzh7w0E+2huew4hgj9GxVycjJoukBQ2pbjTiB3VnVesh0v2KzPY1/J95llc6TYxKJnP/Eotw2cgUhUHPUTdXC+7xA3WVXVLHDo6o/XSB++l8kHRD8ajZFWSRY+PvadQBWmTvpfAeF0ZZXhDw9i4p0CBZ1AAoGmA/dvQvObWl3YHV8MuTZHAd7vxrlD7/WuBlMr4+Hu33uMG4t4NLnp5mVji09Hb/tGmwBJjfTgqPwEvy91xUoX+JNZ4X8La4
 AH3VpXEh
 frNzAkBj83anhJKToVFwvA1Ja8oAIs+3gHPmQzXlmsyEd+uL4BWSOAaQOAkA+oQ8Oc5HtHfzUGF7iZY7Sso+qVFYtQciWDEB1NFGRq8VGnnqST1s+YdVwk0BOXy7NN2Pd3pWSQz7P8yzfrz/os3zDrsOYIflVzZ4wb7eZZU3VdIi+sRm+2Rr1yJXaGsVr4U2uHcSdIRiqbeaDk7EkxEE2kocCKsTCxGx5qOCrolk5U/6P1ZRQWfAmLPMIp20KSFSLDPTsKrI3wAk0n3MqTyQkwS/tJZLqIzRRc3u1sZdaF71IdeUuNabzNTdF/XUafV9ju6J4d4GEk3QwgLHSn11DHour0WqGZ+vrN8VKSLKbvfbQ5NGL0RT0qWwB4su4O9rsto/cp3lNwErIxEWBZlQpwyzq9eCUVq0cCaX3Y307OsWK09UM89HR8RHCw55IslM81Ot0BrvhK1q8SZrxy3VbudYgyBqqorTDfofC/3FDyd8QoZCZEEiH3tejuJR18EXXPIUPwsqOcSusfugBPCfsMoQ1iqAnqGsGus5MTwm9NLAkXFbsSw0PcwN6tcOdUGANf9zCRsRW/aoYUJgrdMMNtG/V7lxaJ6RCi6sFV/flZdVUKpHQGzzZuec6qJ5lK7e9ReJ219TGJ28kwxwbbP8VketvHmJ/KBXZO3BpaeHNY4LfL7r6tIMbhLIszG6tP8yVPPLF5AaXrlxsqbtUG6np53Jn0h2OiVlMMjvaWxGTmRBUH/2V/2er12GftJiLK2xwKOzwbbqOfJER0RwL0uUqYERnX1zNpHcZ3zP5x+dg7S/vhEoJZXhA7KTLAzsjmHIHqPSS48iV1e8Oer7/yjdHkx8KNtr2pz9RniE8HvtCd4sS6fGj82za+qWWZ9T6ZbbRfc1WntPWV4gm6uV6tAKKsLb+hOTrH54UcClstSo2BMtOI36xmoW0K1f/Yyi0CjVAYiBil2kJtYz031NsbBMVKucIPu1p
 baSfQQz5
 Eatqq9caxD89ibw120IoiroDJ4eaHYfHJf4xj0UaTAuaGwTeea0WrwYv1ZMd9batJsbsbEdIQDTUfbWPfxQiiEBON5ahUVmRu+Db5StiKF7dKxQP8NPKr5eQ53MuTlwjMSptOnls8idnu2r01M5WlZLb22cqbmmeeVEoHYN3JtYC0nn3s2RHPoGWSNhBl0DA0W86qwGDrksnc/JFrb4Ll5o2nsc2YVlr59z+RyaMpcrBKlaRe7pzkitNpO51/WnAJtO32sGZqhtU3iei8ig1awrCJrQt9hzq5qt7CRL0u4IRyelW5OvETy1aAZ+JU2DbzV5m14HLc4ginbLmqFa+1HNZdRdGENrWwgtm/eYM0OJwzlhp4BDtsYWCBVnd22Xld2dNfG67Jl7CoDl4G2aEQ7Hxw8eE0WyP7d67+EugPu1IGCY2V5srA4D52WmLLW4fhvUWlsBVAwa8Kh9QcR34PqJXXx/AnxZz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    897d54018cc9 Merge tag 'fbdev-for-7.1-rc1-2' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=158df1ba580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=59da38148f3a3d24
dashboard link: https://syzkaller.appspot.com/bug?extid=8caf74f5399ee2d5212b
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-897d5401.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/20848bcda8fe/vmlinux-897d5401.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2351a3d1bb73/bzImage-897d5401.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8caf74f5399ee2d5212b@syzkaller.appspotmail.com

=====================================
WARNING: bad unlock balance detected!
syzkaller #0 Not tainted
-------------------------------------
cmp/5659 is trying to release lock (rcu_read_lock) at:
[<ffffffff82595f6d>] rcu_read_unlock+0x2d/0xb0 include/linux/rcupdate.h:867
but there are no more locks to release!

other info that might help us debug this:
1 lock held by cmp/5659:
 #0: ffff88803accd848 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0x11d/0x590 mm/mmap_lock.c:310

stack backtrace:
CPU: 2 UID: 0 PID: 5659 Comm: cmp Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_unlock_imbalance_bug.part.0+0xfb/0x106 kernel/locking/lockdep.c:5298
 print_unlock_imbalance_bug kernel/locking/lockdep.c:5278 [inline]
 __lock_release kernel/locking/lockdep.c:5537 [inline]
 lock_release kernel/locking/lockdep.c:5889 [inline]
 lock_release+0x28d/0x310 kernel/locking/lockdep.c:5875
 rcu_read_unlock+0x32/0xb0 include/linux/rcupdate.h:867
 pte_unmap include/linux/pgtable.h:117 [inline]
 finish_fault+0x8ed/0x1400 mm/memory.c:5763
 do_cow_fault mm/memory.c:5935 [inline]
 do_fault+0xff2/0x1750 mm/memory.c:6029
 do_pte_missing mm/memory.c:4550 [inline]
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault+0x187d/0x2a00 mm/memory.c:6549
 handle_mm_fault+0x36d/0xa20 mm/memory.c:6718
 do_user_addr_fault+0x5a3/0x12f0 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7fd47fe2aff2
Code: 0f 60 c0 66 0f 61 c0 66 0f 70 c0 00 48 83 fa 10 72 76 48 83 fa 20 77 12 0f 11 44 17 f0 0f 11 07 c3 0f 11 47 e0 0f 11 47 f0 c3 <0f> 11 07 0f 11 47 10 48 01 d7 48 83 fa 40 76 e7 0f 11 40 20 0f 11
RSP: 002b:00007ffcb5d4bcd8 EFLAGS: 00010206
RAX: 00007fd47fb30068 RBX: 0000000000000004 RCX: 00007fd47fb326d0
RDX: 0000000000000f98 RSI: 0000000000000000 RDI: 00007fd47fb30068
RBP: 00007ffcb5d4c0a0 R08: 00007fd47fb30068 R09: 0000000000000003
R10: 0000000000000812 R11: 00007ffcb5d4c188 R12: 00007ffcb5d4bd88
R13: 00007fd47fdffab0 R14: 00007ffcb5d4c140 R15: 00007fd47fb31000
 </TASK>
------------[ cut here ]------------
rrln < 0 || rrln > RCU_NEST_PMAX
WARNING: kernel/rcu/tree_plugin.h:443 at __rcu_read_unlock kernel/rcu/tree_plugin.h:443 [inline], CPU#2: cmp/5659
WARNING: kernel/rcu/tree_plugin.h:443 at __rcu_read_unlock+0x235/0x5e0 kernel/rcu/tree_plugin.h:430, CPU#2: cmp/5659
Modules linked in:
CPU: 2 UID: 0 PID: 5659 Comm: cmp Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__rcu_read_unlock kernel/rcu/tree_plugin.h:443 [inline]
RIP: 0010:__rcu_read_unlock+0x235/0x5e0 kernel/rcu/tree_plugin.h:430
Code: 74 11 c7 45 58 01 00 00 00 bf 09 00 00 00 e8 c2 6f da ff e8 9d ff 22 00 9c 58 f6 c4 02 0f 85 dd 02 00 00 fb e9 57 fe ff ff 90 <0f> 0b 90 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc e8 54 76 88
RSP: 0000:ffffc90003a27b28 EFLAGS: 00010286
RAX: 00000000ffffffff RBX: ffff888029db4a00 RCX: ffffffff81e7b7ae
RDX: 0000000000000000 RSI: ffffffff8def8e2a RDI: ffff888029db4ec4
RBP: ffff88802bdd4980 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000012 R12: ffff88802bf53d40
R13: ffffc90003a27d58 R14: 0000000000000001 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880d6579000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd47fb30068 CR3: 000000003585a000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 pte_unmap include/linux/pgtable.h:117 [inline]
 finish_fault+0x8ed/0x1400 mm/memory.c:5763
 do_cow_fault mm/memory.c:5935 [inline]
 do_fault+0xff2/0x1750 mm/memory.c:6029
 do_pte_missing mm/memory.c:4550 [inline]
 handle_pte_fault mm/memory.c:6411 [inline]
 __handle_mm_fault+0x187d/0x2a00 mm/memory.c:6549
 handle_mm_fault+0x36d/0xa20 mm/memory.c:6718
 do_user_addr_fault+0x5a3/0x12f0 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7fd47fe2aff2
Code: 0f 60 c0 66 0f 61 c0 66 0f 70 c0 00 48 83 fa 10 72 76 48 83 fa 20 77 12 0f 11 44 17 f0 0f 11 07 c3 0f 11 47 e0 0f 11 47 f0 c3 <0f> 11 07 0f 11 47 10 48 01 d7 48 83 fa 40 76 e7 0f 11 40 20 0f 11
RSP: 002b:00007ffcb5d4bcd8 EFLAGS: 00010206
RAX: 00007fd47fb30068 RBX: 0000000000000004 RCX: 00007fd47fb326d0
RDX: 0000000000000f98 RSI: 0000000000000000 RDI: 00007fd47fb30068
RBP: 00007ffcb5d4c0a0 R08: 00007fd47fb30068 R09: 0000000000000003
R10: 0000000000000812 R11: 00007ffcb5d4c188 R12: 00007ffcb5d4bd88
R13: 00007fd47fdffab0 R14: 00007ffcb5d4c140 R15: 00007fd47fb31000
 </TASK>


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

