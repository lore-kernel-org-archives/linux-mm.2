Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2FEACAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 16:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BDC38E0006; Tue, 23 Sep 2025 12:22:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3950E8E0001; Tue, 23 Sep 2025 12:22:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AB408E0006; Tue, 23 Sep 2025 12:22:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1428C8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 12:22:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB0D285ED7
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:22:30 +0000 (UTC)
X-FDA: 83921032860.04.CE1B5BD
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	by imf29.hostedemail.com (Postfix) with ESMTP id DF7C0120009
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:22:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of 3Q8nSaAkbAG4eklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.80 as permitted sender) smtp.mailfrom=3Q8nSaAkbAG4eklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758644549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=fliOmompFcXDPLp5fyc4D6gMx/asPNTMNLo+cXzT8zs=;
	b=vrDuBG3/UGqRg53c9iXulKOfIF5C2u87Eugwjq4UymfyBudimgg/i4OiTuD9NOpGer8QzU
	xZRxWhrNy0+iSKOUu0LweRStWROFMLGQDV6CaMEUJ+HFG8oq7YfH1+tUiGwD/wWltH+ySZ
	yZgNARkUrbrcyKCHvPo9MHREKlREBBU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758644549; a=rsa-sha256;
	cv=none;
	b=QH5/A071bulaSsWLPcpDUIEYN9FFuNMIIykW2SvH60hixuvNjkqSSGOAtG04nLBn4Utg4I
	n5PLjvq1w/7ovtRM+AAkO1PFXGhZs2/p5F4nzQ+AxBLTBqHOdnMzzBshnhRT4Qah/Uj/t6
	3ZjlkURPezgTvIbDz9owbMkGsFSrLmM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of 3Q8nSaAkbAG4eklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.80 as permitted sender) smtp.mailfrom=3Q8nSaAkbAG4eklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-893dd6dfe1fso498106439f.1
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:22:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758644548; x=1759249348;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fliOmompFcXDPLp5fyc4D6gMx/asPNTMNLo+cXzT8zs=;
        b=p48UzNmaKhVcgax0MXbwJ00utU0JjO99+t5v59YeaPT4ccnSOacV/x9A2IC/Y0fQU7
         aGS/8OUg8xCS6q08FI9GXqDe76lPp36WbjxWnrHma1fLQC5ucLZVrQz2zcFoxZ0YY3jA
         9Ol1o5hbnh6eB3yk8OirHqVKU2vzAaafQj7TfKjCD5KKTzPr9nqKJhBUMVVaaCcUdub5
         NMwlohi7yG563sQ15EuUS9Uj4EB9duyF4hKQwDLNHTL6pEwIXOqFE4/5QADMhN0CRRJ/
         Q725GC46d02XVBX5JX09Xz3CgyR7DLyIZcp/yZyPmGd0CIXiGe/g6GwAttT8vUmzh4Rw
         pkxQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyX3sWXf6I90kXYLro8BYEaocMpRSzdesRyjAWbXRGoAWYerLc7AlqLqWmD+vv4hZtdUsZBHklRA==@kvack.org
X-Gm-Message-State: AOJu0YyvCtahlOjsGL4bjvjMPLaIt6Vi6jdZt5YN6b1Zlv6BEUYFOSBD
	J5lzTZFC7gs1nI/DMF2BXjfQc616z7vqH4Vnxotuycn4Cgkb/IebyvO93cnutC1sHU3mVTsgyQN
	ktNrwlwbLXJV4eySX5NbkcjRQJDYLc3uSaKpYVwQr6UwqmKEvq9pQOyHRRHY=
X-Google-Smtp-Source: AGHT+IHfgRC8BMqPaFSbGMJttCZaLVnmtyUOI5o+nYBtHge6b9pil9feGS+SabO7G3WmYb+l+4tOu/L7GNki4CrWFHoNGql+MRnS
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:144b:b0:425:6f0b:a1db with SMTP id
 e9e14a558f8ab-42581e28e41mr43633795ab.9.1758644547759; Tue, 23 Sep 2025
 09:22:27 -0700 (PDT)
Date: Tue, 23 Sep 2025 09:22:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d2c943.a70a0220.1b52b.02b3.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in memory_failure
From: syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, linmiaohe@huawei.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nao.horiguchi@gmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DF7C0120009
X-Stat-Signature: prhohrfeapum68fjkmbgpj8wzusq8gxs
X-Rspam-User: 
X-HE-Tag: 1758644548-673316
X-HE-Meta: U2FsdGVkX1+7Ox2ANaxCMIoF5vEyUoF5X3EvVDUK3C1pgX5RQM7CCqURrLbLIb1zLoGYaCC19Z2iixu0qkeow5tAe45hlptUX4y5mkyLGdY372cVrYYv8FcjAXnp2LsRVgZNA2rqQzYYgJmc8CQjO6C1XmsXHc5bn1wuUxfitn91FG3/1Zx5/86YbELP7+WHTNB0LA13SqN76L//BEqmLL4kBJqHabD3sC0WhtKpY4BxsL6O4HRA+6zf6L3FP7afD26MMyAfHLXdTOjfAgqayEyNXkU1YF/o3Qmdcb18jMNxs0Al9pPGNgqwysS6+KwTguB1LrS1yxTC/HFgRxQ1LDMgrBRmoknATmwusXUj7bbwLbF17uWJ9ci53hem+XmEfAvQuZaunRm7JnjofXIDRI/fe/0vNz8QaTIwrk0xKueYrwWhx5dAUe4DjjFfbMJrkAVvlR4eWyg8kUI7gq39cVpVRjzAdeyCJ/nxIFFhICa1o+Y/sMINScl6tlMr283qc7xxb52+cTAJnlmtxB9GQmHNhoIyNZmAk3XtfiOl1RhI6Q3WX2cyu3ENUcbP9WPg+2UeikfDtmrunCzq9I2BzUcWhIUmm3FaWxpIir6Z5pZFTA6EWCc+cM7kQarDN2H0/8N3HsnWFZQaFBd2RfeLan4c/WQIam+ArpScSMdZ4JP0kpp83dmTsymD1LeyEg7Exj6kVRNro1U4B94ffERiHu46/8JQoPc2jsDTyzRDEnrw4mMfoSjFiv3LuiV43j7jccxiXyYWZnavxbF3x5E8B7wBk53FcHz6kEhvUNkgEmQMtIrw3y3J0cNbKS40dJtvsHWfg+XcQu6+Nhm1Sh9VM4W2Et681ZdySCp5uTUTdU06447q0MwuXs0jZTJ9gJOF555XzmApc8aD3meTq9pXzEVxdMeI0y4cFlPJsR8tyq+VkA4xQs93hSfhEb4PKcoHiVJl1pjlCMOhO3QYFqt
 qG7J91vx
 JnLwgXidnvISmTbxiUQJdmx4utIrk87kLq+iOWSB1DP8Q8919Gu9vNrCjB7qFOipqJerQgSAIBqG5M/bleAH/XOlw2fhc14Ycz7Je/qqCyxx3sV8xR/Ss8egaPjqwGteu+oGy38kbM5MSwav7trKXK2PJERDTCnVO33FE1cnDMHkbhJ1w7owFgRzhoalnRERfd0TsjvNlP/IEWYnx4TpsIC1O0w4Hoiz4fTAv3halLyd94pBNZF9L/JrMzfmMxiIqEKgRizzKSTa/MN5RKf4M6VhA/LI0XS9gFe/Vy3U3rzF8B8iGzQJIT3OuA/ZquVElZaoxOnGMsz+TI2k9b1VdKk4UmtXalP/ZmEIqdxplOZt1sQuaQfTGbcEDPQq7Jcjbi4pm8MiE8/bX2UkStcERYXM7rPJzaay5itwiQSpz3B/QTJhKBD94Hbetbn4dkx73qK6SuvEDyO7Kj8FGhkGrZGY7k/D4/P4+DRgXqhxCub4PQyQhdjzBcepih+rZ50HDjAkBazVUqWnYDsQjWgP392ZfHLgBmsJ1guYmHbKH9rQ1wcKF8TwM2lKdcJaqv2d9iNyF051YQqcbs7X/MeJwVex6n3zdXiGsGeLIMuvN7bVs00mfXozs4kaEvqNC2vuA8wYh3A8Z5PznVfSvjRTYYExVVzNHkRly063F5nt6CO3TgdMW9lrVri9F9wxdhfcNa2Im255LBu0EngehuX+FMfztEn6Km7gV02Nz4zix4NfIiQWRhb9faiTxEOI/uSCfxP27HNJAwqfpU+pjckQuwTO37UCPUPOxGNx3AZu/KX47w/g0GbqacUMX4SHSaLv026VtQBgQqBlUUvyCfrNHz/dOlFTRJBUJCjnVpUO6oTDyAX7UMW40yT0kMO5ux6fze7HZ2c1Tay53YavCYZHOA7jyqqpO5iKXqUpfFcSf8IxXpDFN4gMrYdK4s5H6+C4msHgkih6due9tPfxeLotDGHcuWHo9
 lEBEWXO9
 aSipGwXJ3loXiH7DnaCPX3LBZrW1Lk66B/Q4uCqZJCj7oNQPvb34cZoXze5BdBjoIiV2gDR3ZEpJLsb20tuvrroz9KHoLgM+bpblo/tJHzqFfyitvY/3uAj8LyDYFqJ+9UzYNqNV79sby0jJGFfugXArKoL3p3xgk00m5sRoYBBvajKjDKNIzTbG91F1FA7TttVcs3Wm3EguxammSpaS1q/WnGKUVQ70STm5mO65nMvxNJkxLAfS9dq9eVSmasSlOc9QrHZt87d19zlnvtIEFM0BiT+bXyYiGjvbft00UiI3uRfX6/P9mp2AofcQCNB2RROr8HSWJqHQKNJbBp5n1ouxBZVwS46i9f4oXPdfgg9hmPqSBNA8gkVZsULKwClngLu42pKiEC4JBHXAEOQ/meQC5Yyg0SPPLp3YOWvLKq2sEbviJve406dCTpFy89Tm/FEb1OBo6hInh/+D57UUnyUL54cwF8dw2TowwqeYNK/ulm9ucYMBt5ENIE6DSnuJwYC+IipsQpv5FFcJrtSI3AI7aHs2iFRmwk2+yuTRja43URQS63OAf17f5sw325IAGElMaCMLKe0i454B9/g72MsRCiVWRtka
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    b5db4add5e77 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=10edb8e2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2ae34a0711ff2f1
dashboard link: https://syzkaller.appspot.com/bug?extid=e6367ea2fdab6ed46056
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14160f12580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1361627c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6eee2232d5c1/disk-b5db4add.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a8b00f2f1234/vmlinux-b5db4add.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fc0d466f156c/Image-b5db4add.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com

Injecting memory failure for pfn 0x104000 at process virtual address 0x20000000
------------[ cut here ]------------
WARNING: CPU: 1 PID: 6700 at mm/memory-failure.c:2391 memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
Modules linked in:
CPU: 1 UID: 0 PID: 6700 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
lr : memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
sp : ffff8000a41478c0
x29: ffff8000a41479a0 x28: 05ffc00000200868 x27: ffff700014828f20
x26: 1fffffbff8620001 x25: 05ffc0000020086d x24: 1fffffbff8620000
x23: fffffdffc3100008 x22: fffffdffc3100000 x21: fffffdffc3100000
x20: 0000000000000023 x19: dfff800000000000 x18: 1fffe00033793888
x17: ffff80008f7ee000 x16: ffff80008052aa64 x15: 0000000000000001
x14: 1fffffbff8620000 x13: 0000000000000000 x12: 0000000000000000
x11: ffff7fbff8620001 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000d7eedb80 x7 : ffff800080428910 x6 : 0000000000000000
x5 : 0000000000000001 x4 : 0000000000000001 x3 : ffff800080cf5438
x2 : 0000000000000001 x1 : 0000000000000040 x0 : 0000000000000000
Call trace:
 memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391 (P)
 madvise_inject_error mm/madvise.c:1475 [inline]
 madvise_do_behavior+0x2c8/0x7c4 mm/madvise.c:1875
 do_madvise+0x190/0x248 mm/madvise.c:1978
 __do_sys_madvise mm/madvise.c:1987 [inline]
 __se_sys_madvise mm/madvise.c:1985 [inline]
 __arm64_sys_madvise+0xa4/0xc0 mm/madvise.c:1985
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
irq event stamp: 1544
hardirqs last  enabled at (1543): [<ffff80008b042cd0>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (1543): [<ffff80008b042cd0>] _raw_spin_unlock_irq+0x30/0x80 kernel/locking/spinlock.c:202
hardirqs last disabled at (1544): [<ffff80008b01a1ac>] el1_brk64+0x20/0x54 arch/arm64/kernel/entry-common.c:434
softirqs last  enabled at (1528): [<ffff8000803da960>] softirq_handle_end kernel/softirq.c:425 [inline]
softirqs last  enabled at (1528): [<ffff8000803da960>] handle_softirqs+0xaf8/0xc88 kernel/softirq.c:607
softirqs last disabled at (1397): [<ffff800080022028>] __do_softirq+0x14/0x20 kernel/softirq.c:613
---[ end trace 0000000000000000 ]---
Memory failure: 0x104000: recovery action for huge page: Recovered
Injecting memory failure for pfn 0x131e00 at process virtual address 0x20200000
------------[ cut here ]------------
WARNING: CPU: 1 PID: 6700 at mm/memory-failure.c:2391 memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
Modules linked in:
CPU: 1 UID: 0 PID: 6700 Comm: syz.0.17 Tainted: G        W           syzkaller #0 PREEMPT 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
lr : memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
sp : ffff8000a41478c0
x29: ffff8000a41479a0 x28: 05ffc00000200868 x27: ffff700014828f20
x26: 1fffffbff878f001 x25: 05ffc0000020086d x24: 1fffffbff878f000
x23: fffffdffc3c78008 x22: fffffdffc3c78000 x21: fffffdffc3c78000
x20: 0000000000000023 x19: dfff800000000000 x18: 00000000ffffffff
x17: ffff80009353a000 x16: ffff80008052aa64 x15: 0000000000000001
x14: 1fffffbff878f000 x13: 0000000000000000 x12: 0000000000000000
x11: ffff7fbff878f001 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000d7eedb80 x7 : ffff800080a549a8 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff800080cf5438
x2 : 0000000000000001 x1 : 0000000000000040 x0 : 0000000000000000
Call trace:
 memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391 (P)
 madvise_inject_error mm/madvise.c:1475 [inline]
 madvise_do_behavior+0x2c8/0x7c4 mm/madvise.c:1875
 do_madvise+0x190/0x248 mm/madvise.c:1978
 __do_sys_madvise mm/madvise.c:1987 [inline]
 __se_sys_madvise mm/madvise.c:1985 [inline]
 __arm64_sys_madvise+0xa4/0xc0 mm/madvise.c:1985
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
irq event stamp: 2162
hardirqs last  enabled at (2161): [<ffff800080ca8720>] __folio_split+0xf7c/0x1438 mm/huge_memory.c:3856
hardirqs last disabled at (2162): [<ffff80008b01a1ac>] el1_brk64+0x20/0x54 arch/arm64/kernel/entry-common.c:434
softirqs last  enabled at (1726): [<ffff8000803da960>] softirq_handle_end kernel/softirq.c:425 [inline]
softirqs last  enabled at (1726): [<ffff8000803da960>] handle_softirqs+0xaf8/0xc88 kernel/softirq.c:607
softirqs last disabled at (1547): [<ffff800080022028>] __do_softirq+0x14/0x20 kernel/softirq.c:613
---[ end trace 0000000000000000 ]---
Memory failure: 0x131e00: recovery action for huge page: Recovered
Injecting memory failure for pfn 0x134200 at process virtual address 0x20400000
------------[ cut here ]------------
WARNING: CPU: 1 PID: 6700 at mm/memory-failure.c:2391 memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
Modules linked in:
CPU: 1 UID: 0 PID: 6700 Comm: syz.0.17 Tainted: G        W           syzkaller #0 PREEMPT 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
lr : memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
sp : ffff8000a41478c0
x29: ffff8000a41479a0 x28: 05ffc00000200868 x27: ffff700014828f20
x26: 1fffffbff87a1001 x25: 05ffc0000020086d x24: 1fffffbff87a1000
x23: fffffdffc3d08008 x22: fffffdffc3d08000 x21: fffffdffc3d08000
x20: 0000000000000023 x19: dfff800000000000 x18: 1fffe00033793888
x17: 646461206c617574 x16: ffff80008052aa64 x15: 0000000000000001
x14: 1fffffbff87a1000 x13: 0000000000000000 x12: 0000000000000000
x11: ffff7fbff87a1001 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000d7eedb80 x7 : ffff800080a549a8 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff800080cf5438
x2 : 0000000000000001 x1 : 0000000000000040 x0 : 0000000000000000
Call trace:
 memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391 (P)
 madvise_inject_error mm/madvise.c:1475 [inline]
 madvise_do_behavior+0x2c8/0x7c4 mm/madvise.c:1875
 do_madvise+0x190/0x248 mm/madvise.c:1978
 __do_sys_madvise mm/madvise.c:1987 [inline]
 __se_sys_madvise mm/madvise.c:1985 [inline]
 __arm64_sys_madvise+0xa4/0xc0 mm/madvise.c:1985
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
irq event stamp: 2768
hardirqs last  enabled at (2767): [<ffff800080ca8720>] __folio_split+0xf7c/0x1438 mm/huge_memory.c:3856
hardirqs last disabled at (2768): [<ffff80008b01a1ac>] el1_brk64+0x20/0x54 arch/arm64/kernel/entry-common.c:434
softirqs last  enabled at (2364): [<ffff8000803da960>] softirq_handle_end kernel/softirq.c:425 [inline]
softirqs last  enabled at (2364): [<ffff8000803da960>] handle_softirqs+0xaf8/0xc88 kernel/softirq.c:607
softirqs last disabled at (2321): [<ffff800080022028>] __do_softirq+0x14/0x20 kernel/softirq.c:613
---[ end trace 0000000000000000 ]---
Memory failure: 0x134200: recovery action for huge page: Recovered
Injecting memory failure for pfn 0x129000 at process virtual address 0x20600000
------------[ cut here ]------------
WARNING: CPU: 1 PID: 6700 at mm/memory-failure.c:2391 memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
Modules linked in:
CPU: 1 UID: 0 PID: 6700 Comm: syz.0.17 Tainted: G        W           syzkaller #0 PREEMPT 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
lr : memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
sp : ffff8000a41478c0
x29: ffff8000a41479a0 x28: 05ffc00000200868 x27: ffff700014828f20
x26: 1fffffbff8748001 x25: 05ffc0000020086d x24: 1fffffbff8748000
x23: fffffdffc3a40008 x22: fffffdffc3a40000 x21: fffffdffc3a40000
x20: 0000000000000023 x19: dfff800000000000 x18: 1fffe00033793888
x17: 646461206c617574 x16: ffff80008052aa64 x15: 0000000000000001
x14: 1fffffbff8748000 x13: 0000000000000000 x12: 0000000000000000
x11: ffff7fbff8748001 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000d7eedb80 x7 : ffff800080a549a8 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff800080cf5438
x2 : 0000000000000001 x1 : 0000000000000040 x0 : 0000000000000000
Call trace:
 memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391 (P)
 madvise_inject_error mm/madvise.c:1475 [inline]
 madvise_do_behavior+0x2c8/0x7c4 mm/madvise.c:1875
 do_madvise+0x190/0x248 mm/madvise.c:1978
 __do_sys_madvise mm/madvise.c:1987 [inline]
 __se_sys_madvise mm/madvise.c:1985 [inline]
 __arm64_sys_madvise+0xa4/0xc0 mm/madvise.c:1985
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
irq event stamp: 3024
hardirqs last  enabled at (3023): [<ffff800080ca8720>] __folio_split+0xf7c/0x1438 mm/huge_memory.c:3856
hardirqs last disabled at (3024): [<ffff80008b01a1ac>] el1_brk64+0x20/0x54 arch/arm64/kernel/entry-common.c:434
softirqs last  enabled at (2986): [<ffff8000803da960>] softirq_handle_end kernel/softirq.c:425 [inline]
softirqs last  enabled at (2986): [<ffff8000803da960>] handle_softirqs+0xaf8/0xc88 kernel/softirq.c:607
softirqs last disabled at (2771): [<ffff800080022028>] __do_softirq+0x14/0x20 kernel/softirq.c:613
---[ end trace 0000000000000000 ]---
Memory failure: 0x129000: recovery action for huge page: Recovered
Injecting memory failure for pfn 0x134600 at process virtual address 0x20800000
------------[ cut here ]------------
WARNING: CPU: 1 PID: 6700 at mm/memory-failure.c:2391 memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
Modules linked in:
CPU: 1 UID: 0 PID: 6700 Comm: syz.0.17 Tainted: G        W           syzkaller #0 PREEMPT 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
lr : memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
sp : ffff8000a41478c0
x29: ffff8000a41479a0 x28: 05ffc0000020086c x27: ffff700014828f20
x26: 1fffffbff87a3001 x25: 05ffc0000020186d x24: 1fffffbff87a3000
x23: fffffdffc3d18008 x22: fffffdffc3d18000 x21: fffffdffc3d18000
x20: 0000000000000023 x19: dfff800000000000 x18: 1fffe00033793888
x17: ffff80009353a000 x16: ffff80008052aa64 x15: 0000000000000001
x14: 1fffffbff87a3000 x13: 0000000000000000 x12: 0000000000000000
x11: ffff7fbff87a3001 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000d7eedb80 x7 : ffff800080a549a8 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff800080cf5438
x2 : 0000000000000001 x1 : 0000000000000040 x0 : 0000000000000000
Call trace:
 memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391 (P)
 madvise_inject_error mm/madvise.c:1475 [inline]
 madvise_do_behavior+0x2c8/0x7c4 mm/madvise.c:1875
 do_madvise+0x190/0x248 mm/madvise.c:1978
 __do_sys_madvise mm/madvise.c:1987 [inline]
 __se_sys_madvise mm/madvise.c:1985 [inline]
 __arm64_sys_madvise+0xa4/0xc0 mm/madvise.c:1985
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
irq event stamp: 3462
hardirqs last  enabled at (3461): [<ffff800080ca8720>] __folio_split+0xf7c/0x1438 mm/huge_memory.c:3856
hardirqs last disabled at (3462): [<ffff80008b01a1ac>] el1_brk64+0x20/0x54 arch/arm64/kernel/entry-common.c:434
softirqs last  enabled at (3064): [<ffff8000803da960>] softirq_handle_end kernel/softirq.c:425 [inline]
softirqs last  enabled at (3064): [<ffff8000803da960>] handle_softirqs+0xaf8/0xc88 kernel/softirq.c:607
softirqs last disabled at (3027): [<ffff800080022028>] __do_softirq+0x14/0x20 kernel/softirq.c:613
---[ end trace 0000000000000000 ]---
Memory failure: 0x134600: recovery action for huge page: Recovered
Injecting memory failure for pfn 0x134800 at proces
Injecting memory failure for pfn 0x134800 at process virtual address 0x20a00000
------------[ cut here ]------------
WARNING: CPU: 0 PID: 6700 at mm/memory-failure.c:2391 memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
Modules linked in:
CPU: 0 UID: 0 PID: 6700 Comm: syz.0.17 Tainted: G        W           syzkaller #0 PREEMPT 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
lr : memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
sp : ffff8000a41478c0
x29: ffff8000a41479a0 x28: 05ffc0000020086c x27: ffff700014828f20
x26: 1fffffbff87a4001 x25: 05ffc0000020186d x24: 1fffffbff87a4000
x23: fffffdffc3d20008 x22: fffffdffc3d20000 x21: fffffdffc3d20000
x20: 0000000000000023 x19: dfff800000000000 x18: 1fffe0003378f088
x17: ffff80008f7ee000 x16: ffff80008052aa64 x15: 0000000000000001
x14: 1fffffbff87a4000 x13: 0000000000000000 x12: 0000000000000000
x11: ffff7fbff87a4001 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000d7eedb80 x7 : ffff800080a549a8 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff800080cf5438
x2 : 0000000000000001 x1 : 0000000000000040 x0 : 0000000000000000
Call trace:
 memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391 (P)
 madvise_inject_error mm/madvise.c:1475 [inline]
 madvise_do_behavior+0x2c8/0x7c4 mm/madvise.c:1875
 do_madvise+0x190/0x248 mm/madvise.c:1978
 __do_sys_madvise mm/madvise.c:1987 [inline]
 __se_sys_madvise mm/madvise.c:1985 [inline]
 __arm64_sys_madvise+0xa4/0xc0 mm/madvise.c:1985
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
irq event stamp: 3538
hardirqs last  enabled at (3537): [<ffff800080ca8720>] __folio_split+0xf7c/0x1438 mm/huge_memory.c:3856
hardirqs last disabled at (3538): [<ffff80008b01a1ac>] el1_brk64+0x20/0x54 arch/arm64/kernel/entry-common.c:434
softirqs last  enabled at (3500): [<ffff8000803da960>] softirq_handle_end kernel/softirq.c:425 [inline]
softirqs last  enabled at (3500): [<ffff8000803da960>] handle_softirqs+0xaf8/0xc88 kernel/softirq.c:607
softirqs last disabled at (3465): [<ffff800080022028>] __do_softirq+0x14/0x20 kernel/softirq.c:613
---[ end trace 0000000000000000 ]---
Memory failure: 0x134800: recovery action for huge page: Recovered


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

