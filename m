Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DDBFCD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 17:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0B726B0145; Wed, 27 May 2026 13:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE4226B0146; Wed, 27 May 2026 13:36:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8E66B0147; Wed, 27 May 2026 13:36:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0F9D6B0145
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:36:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 518D414055D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 17:36:27 +0000 (UTC)
X-FDA: 84813904014.21.AF4494A
Received: from mail-ot1-f77.google.com (mail-ot1-f77.google.com [209.85.210.77])
	by imf21.hostedemail.com (Postfix) with ESMTP id 954E11C0006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 17:36:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3mCsXagkbAKMVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.77 as permitted sender) smtp.mailfrom=3mCsXagkbAKMVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779903385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=totVlNcyW/0jXnXRHnwuZL43Th/QUwRX+76XXQ++hDI=;
	b=ecEWWE5sVopya5bpWCurp+Ba8AQaFU/OI55YXIyg7r1ttDUw8/ehg6iZCLZe+JnL87qIVG
	pjAWW95BmKltkPO7ndDq0TNYIBENe4YD7BC6UfnVA29zCbuE0EBMzwLjzVI0WgxMQPEWJX
	H5aGhVaGQ68TmdqKEn/gFnJ/IGFDc+s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779903385; a=rsa-sha256;
	cv=none;
	b=MdVgXNEUPWx3DIQYRbbGzDPFpv6M28seH5CaG0wv6LI11Glo4y9xCriLSxVfvJSDjzAJty
	8WXC5UDeVgNNOzzlQz7shoTg92RtOqAym0pblorU6G60RguhJXdBY5jQPBhQl9+X2tKmwI
	uNwRx7OZioZLPvtu6p0NOO0oyxoCQaM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 3mCsXagkbAKMVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.77 as permitted sender) smtp.mailfrom=3mCsXagkbAKMVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f77.google.com with SMTP id 46e09a7af769-7e64d84a305so2272317a34.2
        for <linux-mm@kvack.org>; Wed, 27 May 2026 10:36:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779903384; x=1780508184;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=totVlNcyW/0jXnXRHnwuZL43Th/QUwRX+76XXQ++hDI=;
        b=qYZn2GplH/e1kpQyExX1f1PJdw2nGpX7blbxe0g8RSDYbKe+YcJXhrTr0OXKoXpFZp
         ezSecs0ZI1zZN/6Qzz0AyCKJeA9V5PMZ0lLwQOK8Gnm+qcxQ4kBdm2COsaj+Z9R5kVwh
         ft35Y+YVburfX0BPVLPnUZIHSeo2WaaOAqNG31+Y4iQfgNC57LZ6a69sj2/CyblOu/fS
         W+nbccGqRQpPO6sTOwEdV1jrLlKOm1X170v7BvhSHw3sz9vGQpWakch/xfQAOgRHfXkI
         er4221YMyi5/Tl4X87p2IU+A7RYHPpD8PyCeH+PoSOqi8H/2FGoMrYmq9/gApxaF1ppp
         85fg==
X-Forwarded-Encrypted: i=1; AFNElJ+xZVCSv52pJteamRVppGIXS2XEQeerODs18pPnp9vYdpA31E6VMjXEeQPCMTEMcUpVZaJoAkq3wg==@kvack.org
X-Gm-Message-State: AOJu0Yx2rZPjXGCcTVbwViqHuH8Rzza05mGJ+5VXDGVGEKGjVl+Pj8Ka
	Bcz1SlnfYUrovalY1NXbJsLtjWQrZB/rfOicl76EFK+8RehyTVzIqm0G+nJ16qm00JB9Q+LMRH3
	qUf+nMEBRwjzcn6/acyxRhw6Gp0AH/eFPCCekCHG4jBFFBAjrnCQdioggBk4=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1987:b0:69d:c4bd:8ea6 with SMTP id
 006d021491bc7-69dc4bd9682mr5716536eaf.21.1779903384621; Wed, 27 May 2026
 10:36:24 -0700 (PDT)
Date: Wed, 27 May 2026 10:36:24 -0700
In-Reply-To: <69160af1.050a0220.3565dc.002d.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a172b98.9cfaf1a7.256f5b.0004.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in __page_table_check_ptes_set (3)
From: syzbot <syzbot+18d274a59b87cf80e86d@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, pasha.tatashin@soleen.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 954E11C0006
X-Stat-Signature: adqce6j88cinneheo1mo1xobh7x4ctys
X-Rspamd-Server: rspam06
X-HE-Tag: 1779903385-584639
X-HE-Meta: U2FsdGVkX1/4WSAhtPzBPH0a6yRyUi3cs1BQmjPMio12Sl+XIDlQcvQfNpPQ6+URLLUISIqsl2NVJIlGaVRUUjvYF8NnCBgRHyyIKK6asRtKxMuNVoBulHPFmdwlwXIJ9zUm8v0DZrA8cYR0BYZG2FY7+vAw03x0Eg5IaVnTDRyAY4qGewGyeHD+uBb/ONcNp4IULTRguW/xXBzqHvB+3wANLgxBZIJoDI57o8r2fuclTkCZLzcVK2tf3L6wxEPR1oUR4LBhzqgyXZ565XGpu7xfTBpocfo+t5qX6ftYdM/W5+6vUVyi0RbJ1/aRtOpKb/46WTTYTv2m4VJlGs+/xG0w/KoztuJ1faDBMmDUI/SRq15qALHvtamrkZA8PNyuyjjVGhn4FXfB+h/xyemfW3cVcVE8Qea/5GRer2bpCb9Q9HGl5b0jTMSOa2OaKnYNUi0YSjMuIjXsR2KrBO+6nsnoogTsTQ8jXeX2dCmL1g61ex2sYxuovCvjxr35KM0GuIB77GhqSCv5R5id0PQjdsEpkpAZCDWg/VfzQnEC2t0aJhM+EY4Ev5ai/9bg6WLKh1nujAlfaIZqkmPq1bWW2PVtUS+RcWr5hyUwVB2rhlqkGfXVlnkv3B2xdspY7BH81uMYUzOP6cb8HnL0SyvqwDxwNkMctCD/2j0SLFmMftQ3xl6zSFDXCVOKTchHNkZHwNTmxo8rFv/dVSOUv/5+R7Ffo1Gtv74rgYIdFbzpZh7HG7ySGTQanqdOShkLbEdL4RPZjonMYTRWMIC2NeThqVB9corcCXrAarqv1mY9gJpjG3VS2sbSBCopGAta7EaldWBOd1vJUlOOkeqpzunWSye+JH7fQT17WplIAlS9mNwHMXKwFcW9ZcpH5vxzW9b1n7Uc2B51izLcucaU7UDVyifIc1MzOtei/eLsEFeSM5/JrwW6RKF/8K1LotLD+oZxXwDszLJNne2iwnIcCtN
 cMunwtfG
 5JH0+OQqVFnZBCSfJuW1Jay+PLj+Urou65RZqTqo/2Nw8adXqwLncbac3qEj5Xbagb/Zu3MlRu+XUuWJ+lTiY5vWmiKzpupzpkRSCNCOnqTaN2QeHVAuM7W45t78xznnvxhylQkeN9PmwIGTaghSrwrRgNaEKSQhipwd+tjITLXzv8uzI/UPfYfKA14I2hEwFVE+ssLi8Ix7HstHnctO4umgo9UeW+YAV4Elnac+1qNPIZA7YvP2LG8x55TL5rSSq4CpQMs0ESOx6ERqFWIsDfHOVdWbfLigqw9d/Mjv+OoYHvbvVHnalL9X0Bj/qn1xS2PBVkq/1i9BU5tRdggAXCHr2aCUsg2wVNBECULCZ+2XycU93/IKRfznAGyez9kcKPck1Xr4Gl9edSwK/2wW++RUHHpNCKbhGcX17kbzG/EyIog1RN/hs1Q8+jnWv8xP1/l1OyCUDH77+T08wrsir88cvgVUqSiwNRpYcS6ovd+/JKsf51C4UWKgesVBtFOoBb/+znz61Jb9cf0CXQ00fLfiywT5CKdp+YWcGW6CJH4gu5/oq8bBOgHNPre1hHQBdeF9zrsOYJI1+ax2mUikYCPopDc81ZkZaDl6wJp0yUSGMujwKR9TL/43vZ/MBZd/7YlEOj6LRN7sbJKkd8CLH5WpeXaF7v/NjYGmWewosJKqPp+vdnsVOYKUAUChxdVE0ASNLX19NzdbVpiL0Eyn13UtDWOyafWWDR0uo8DT53tzeFnraKzn60oUquutw2koJvicyf3cvfyX7B5beZPQZX49L1ghbHVNDSYl5OzD5blEg5ustYcEfILnH6jvQoisNGNUOrb6GWn5oOxU/qYlb2AHOc6Ukno9eNbcNE0wmtJU2f+PIaylAyRocGl2+Eusso194NZr0/2lyKPrlO5+sHoVUyohsmeiK9FG6McmVh/5n+zk6NJbtx1pJcq6iXWoiqSkC8M4ELHDAa9idOs5SqhB8B4F0
 IhDFfpwJ
 DLyjDS4VXRnMdhgtwXpoIAOzsE5drBTN6e1LKb4pOiJkwWmTGL1XVgjlbotGRk/eIBlUjRBYBqkSi8oBsPCp6n8zxrxsjJzq0/lXiUSasuiOGvB9dFUgVkuOVdTwuHgN6lDRf/UY97L2lWmLzfqrMO4oqknQku3h8hthnPtPJ7Vs7z3OuMtWOoNDDP9L3sHG9/nCQInr85knvjItz6AMT6twToTcX4dyI7pWOx638aOssN7mlQOgPlHYdHfWQbr5OuJ1L6LQxkC9CTxapPVPYHCTC+mg/ujv072lt+d2jIGVlNa6z9DMv0XHJ0PtpT4/T1/61GTFoTedZoaR8qHbZpz0vrZdgwc1gbNye2JKc7sc/CZJkUFclA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    4b4362973b6f Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=13c4d67e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f52fb4a6d220c448
dashboard link: https://syzkaller.appspot.com/bug?extid=18d274a59b87cf80e86d
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15aab6ec580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1789c6ec580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cdc9dd8cab69/disk-4b436297.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6bb74747f86d/vmlinux-4b436297.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a20d7153214f/Image-4b436297.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+18d274a59b87cf80e86d@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: mm/page_table_check.c:191 at page_table_check_pte_flags mm/page_table_check.c:191 [inline], CPU#0: syz.0.17/4918
WARNING: mm/page_table_check.c:191 at __page_table_check_ptes_set+0x24c/0x254 mm/page_table_check.c:207, CPU#0: syz.0.17/4918
Modules linked in:
CPU: 0 UID: 0 PID: 4918 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : page_table_check_pte_flags mm/page_table_check.c:191 [inline]
pc : __page_table_check_ptes_set+0x24c/0x254 mm/page_table_check.c:207
lr : page_table_check_pte_flags mm/page_table_check.c:191 [inline]
lr : __page_table_check_ptes_set+0x24c/0x254 mm/page_table_check.c:207
sp : ffff800099487420
x29: ffff800099487430 x28: 1ffff00013290efb x27: fffffdffc3a3b640
x26: ffff8000994877d8 x25: 04a8000128ed9f43 x24: 0408000000000000
x23: 0408000000000000 x22: ffff0000dd901f80 x21: ffff0000d0bc0ff0
x20: 0000000000000001 x19: 04a8000128ed9f43 x18: 00000000ffffffff
x17: ffff80008a186c80 x16: ffff80008a4a3638 x15: ffff0000c4c80b50
x14: ffff0000c4c80b30 x13: 0000000000000001 x12: 0000000000000000
x11: 0000000000000000 x10: 0000000000ff0100 x9 : 0000000000000001
x8 : 0000000000000000 x7 : ffff800080af57c0 x6 : 0000000000000000
x5 : 0000000000000030 x4 : 0000000000000001 x3 : ffff800080c10240
x2 : 0408000000000000 x1 : ffff0000c4c80000 x0 : 0000000000000000
Call trace:
 page_table_check_pte_flags mm/page_table_check.c:191 [inline] (P)
 __page_table_check_ptes_set+0x24c/0x254 mm/page_table_check.c:207 (P)
 page_table_check_ptes_set include/linux/page_table_check.h:83 [inline]
 __set_ptes_anysz+0x4dc/0x51c arch/arm64/include/asm/pgtable.h:681
 __set_ptes arch/arm64/include/asm/pgtable.h:714 [inline]
 set_ptes arch/arm64/include/asm/pgtable.h:1782 [inline]
 do_swap_page+0x2464/0x4348 mm/memory.c:5128
 handle_pte_fault mm/memory.c:6414 [inline]
 __handle_mm_fault mm/memory.c:6549 [inline]
 handle_mm_fault+0xd80/0x245c mm/memory.c:6718
 faultin_page mm/gup.c:1126 [inline]
 __get_user_pages+0x678/0x20f0 mm/gup.c:1428
 populate_vma_page_range+0x260/0x358 mm/gup.c:1860
 __mm_populate+0x200/0x324 mm/gup.c:1963
 do_mlock+0x52c/0x630 mm/mlock.c:659
 __do_sys_mlock mm/mlock.c:667 [inline]
 __se_sys_mlock mm/mlock.c:665 [inline]
 __arm64_sys_mlock+0x60/0x78 mm/mlock.c:665
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:140
 el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:740
 el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:759
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594
irq event stamp: 960
hardirqs last  enabled at (959): [<ffff8000867c300c>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:178 [inline]
hardirqs last  enabled at (959): [<ffff8000867c300c>] _raw_spin_unlock_irqrestore+0x38/0x98 kernel/locking/spinlock.c:198
hardirqs last disabled at (960): [<ffff80008679e6f8>] el1_brk64+0x20/0x54 arch/arm64/kernel/entry-common.c:429
softirqs last  enabled at (156): [<ffff800080137ce0>] local_bh_enable include/linux/bottom_half.h:33 [inline]
softirqs last  enabled at (156): [<ffff800080137ce0>] put_cpu_fpsimd_context arch/arm64/kernel/fpsimd.c:251 [inline]
softirqs last  enabled at (156): [<ffff800080137ce0>] do_sve_acc+0x22c/0x3b8 arch/arm64/kernel/fpsimd.c:1360
softirqs last disabled at (154): [<ffff800080137bc0>] local_bh_disable include/linux/bottom_half.h:20 [inline]
softirqs last disabled at (154): [<ffff800080137bc0>] get_cpu_fpsimd_context arch/arm64/kernel/fpsimd.c:234 [inline]
softirqs last disabled at (154): [<ffff800080137bc0>] do_sve_acc+0x10c/0x3b8 arch/arm64/kernel/fpsimd.c:1346
---[ end trace 0000000000000000 ]---


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

