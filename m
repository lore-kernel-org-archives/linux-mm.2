Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01381C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 21:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE6ED6B0092; Fri, 26 Jun 2026 17:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBE7C6B0093; Fri, 26 Jun 2026 17:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BADB36B0095; Fri, 26 Jun 2026 17:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 925816B0092
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:28:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF480C24E0
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 21:28:03 +0000 (UTC)
X-FDA: 84923351646.29.A9ED530
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3CA4540003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 21:28:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="idzxYD/U";
	spf=pass (imf27.hostedemail.com: domain of sanan.hasanou@gmail.com designates 209.85.222.44 as permitted sender) smtp.mailfrom=sanan.hasanou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782509282;
	b=cUoqO0PfxazhwGKc2U9oLfFia3+MR+JSWK3MmXsHrDPK+dQFBgmNK4M3y9kb0214fPjU/X
	44tBwx5L5BoP/aSZXqTltNiyhS4QYupKyTtl7HkM5Qidq3BSGUxbUwYqc24e//TkBFVtGw
	GqeLbFNeFUDxxsYndSTPUaBrHgWABzY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782509282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Dg6HnAcnrgr/QBBb7mjq3oP0dONdnO/rhY7BsmxAB3E=;
	b=Z2M0iSeBiWELhJ/NJ4r7Wf6hYv8KSxzHiBNgjafHcEKNjzwN/PN8cBO+eHZMHB2Ykdl729
	/Pj8cSuOVvsfqrN4+ZL3ZnaRJ846iKQ4ECxJM0kW7udIKz9uOcimeCCzKUm+Nms3wsfbc+
	DtdWOLRwqyqNYRDGhNRfbzdmOjYA9mg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="idzxYD/U";
	spf=pass (imf27.hostedemail.com: domain of sanan.hasanou@gmail.com designates 209.85.222.44 as permitted sender) smtp.mailfrom=sanan.hasanou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-9692c008bd7so5899241.2
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782509281; x=1783114081; darn=kvack.org;
        h=from:mime-version:content-transfer-encoding:content-type:cc:to
         :subject:date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Dg6HnAcnrgr/QBBb7mjq3oP0dONdnO/rhY7BsmxAB3E=;
        b=idzxYD/Ud86RmraSeo+Qafs/Zxt5EC5v2++CS6m1Jel6b6U7/urM93cEWZvJbNuZk6
         U34B7yKRaJIPVOWuPILMU0r6SMvDeuBZZHRxF7edE8tVOU2raGwvvoGrw89xSVxSAiWu
         I878sTr/M+YiEuS07hid1XZz4Czgf0Lh/MzYk6VP+XygZU/Zr5ei7M38yvnja1dNHZ3Z
         ZiyIKW8v19WbV1FO8V2menQBuY7/3Zdt9hjR/drTY9lFtDG98rel1Eu8OqrnB70kn4eR
         x0wYeRngpzZeFvtjRPacFvKeVcK37FQt1FSS3XVYAtDxhujRO+wqpxVgkiqSQml5rNQR
         Mwig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509281; x=1783114081;
        h=from:mime-version:content-transfer-encoding:content-type:cc:to
         :subject:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Dg6HnAcnrgr/QBBb7mjq3oP0dONdnO/rhY7BsmxAB3E=;
        b=DisvHAuV3HGOn3UVXUZ55VOU9YkyjhORNHhGAFI5YThPSjCnHaYEGnyQn1UhBaSlj/
         ITOga9v95MRwQm+Un1tjiPT8Zs23LQTDW9r+55mLj6MXGWd6rp5G6TgqkOB+gLO9Um8L
         7fNcTbWYZ6gAvZH1ZPkdMe4qbBtNjxonPVmpluK0Fi2nYbKg72e+tZLjOv7/prSlefXD
         kdqTVekUtFbxk6FkjJXpCxhkzbGJ+ZfvoFNNtxFz6nLE4pJvgFNJqfcd65Ux7TgHbn5V
         kR/LkrwrkYrRQV+OjbesOxtwfdpe0wmh+PSaxTLTC34cQHBZwvLpnOQ5zhDfBf0jRL57
         bHgg==
X-Forwarded-Encrypted: i=1; AHgh+RoTraFgv/SmZ2ghQh0+D8gjQ3wPOnR5ZineWBKpWdmGGhDqpoMPiZIirhHDOlcLmAoSzy9t77xRSQ==@kvack.org
X-Gm-Message-State: AOJu0Yy4zRRx7e2drdTo26Ksboliq2GzsVQskiboLkmf3T7LWaWS6S8j
	xlGpZtsSbK8Nv1usAAixiqeFqxg4MtXoHj/bC2CKKPQkCQoFfpnjMi16
X-Gm-Gg: AfdE7cmwZLlDIqYCmHMClI9aBQVceMkF6Ryl7nXRk9c1ziyHKxDIhFN6anTZyVCgboz
	wZCOcNINGdqdtkXXjKhvSmkgLoE7c86wfLDW9A3Y++emf87A8X7Jt6/0fmJ8ii6ZpKlZ5/K6Pm5
	JwYt050hfYfuVRgf03a8UYgDl3+cX+0ja9IFzjN+mxSeVsH4mTZcX2l00Nor0AjU+zXsRw7uhmq
	jslfon0kWj2kshxXMRwN39uJw81ErQHhK9W0A41csn2vJZfWXcNPgISLQRZoaLBcEhtDvZiKXx8
	Bt5+dHEmBjQXsXS+Y5jhElHgIXap5DlQOLld4A5tFafYe6DnJkFCpNTJCAwzdHKQnejH+cgwIca
	1FPkm/g3n1xYbuk7UzAjk0XkFGfHYHAiqFeFAWsJBzxeiXjxzsIhsAeOxGS7B5E5bG6KLFhmGww
	eP9Xdok4rYAxOWUgZzT5XvWhLWR78OR4w/5ZDazMqvr7qw90kAf0VTUOKAJ0304HFSXpQBOTlwe
	3Zw82y6wrJH
X-Received: by 2002:a05:6102:3748:b0:727:1311:19b7 with SMTP id ada2fe7eead31-734366c149fmr1431711137.6.1782509281300;
        Fri, 26 Jun 2026 14:28:01 -0700 (PDT)
Received: from [192.168.10.115] ([132.170.207.48])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-735697bcbf4sm1955132137.7.2026.06.26.14.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 14:28:00 -0700 (PDT)
Message-ID: <6a3eeee0.90b0dd93.20279d.5780@mx.google.com>
Date: Fri, 26 Jun 2026 14:28:00 -0700 (PDT)
Subject: WARNING in shmem_evict_inode
To: hughd@google.com, baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: syzkaller@googlegroups.com, contact@pgazz.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: sanan.hasanou@gmail.com
X-Rspam-User: 
X-Stat-Signature: fj9qzdb481pdf38u6ecctwmoboaejdp7
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3CA4540003
X-HE-Tag: 1782509282-960389
X-HE-Meta: U2FsdGVkX1+r1+0ei7KnjuAx2oNe0HaRYirjVgMlP8c3zC7dBn7sUgj6eBqfLPQ7WL7uQyLJW9EipKx2SFS3aXxk8zp9tYxQRn+I6b5xJFboD1wWZEgiH826lIPRHUmfF8vRb+m7kgZSfcJJ5Df4GHtCur8RRIUgo7DlQpzlFmgt4pDhAKXlQxnCA49cv5Yyw5200Z6Lbt1RFRH7odjJHgcGybQzmh0u9tM79EMaWh3dxISTI2H1UqBTvyBj8KmWLrq6gy6wadThYRYhB03qzw5M+xbk014VmQlcsk1mjr5dRR2lc4jdPSvB+GvcJ8pKcqQ9VRBBFb5JLtYd9ezIQ/Oae2kGNTIHd/lmfktAuuLnx7AgKuE7h+tZ/a9IIqvzpiEG5eI1C3cAnWWD+2IvYargc8O35bi7rQz69RIjPg5qTfMRwGD9+9noTECarUvhz3WRhajkAkGl1yyRAylyChtvh1UQCkVfrmGoXfk0SMMR1zgFq6kTfRI+6P++uHdA569oZG0mjRJVlQIpYrxSaxdmmaMh+Pczj4ye4reQ7u6VB267/vpl2ihQyeb9RqmzWFGpcrRjXttbYNxgq1wGdEhiC1sLLusKeliRK3L8QKfNGmkKC/btalkfva+RRG3zENxSU9ERHdv+/qFKvNLlK3s7KIUyePkCQpjtjwZQDuzUBVElCWPnMTmOUCri4BR5eGNuEHPVTmVIi7hXPe0uXfaXnbqtXda82MFQfd51ygki4H1rcSMD73HvrvqMuGrkEfWqnt+64T/HlUtQ+aFL3GzyFAHE81OTHvWlAEF6pZuUk+WLtvUlNgUiIHKg+v3hCpoSz9K5oFa69At5iLZOcGVGXfeK3I9/J7loePjRi8zC3Na4RvpPr2yHYAKof997NQuHE3f4wYhIYBTEFQr3j5YpWoaK6fvpwE+Fvm2/2yCvL/aiGhlRVesNZ5FpSNIC6Sk16rNQufhemmY1UAJ
 lbNIp2V7
 481RmG5Tv7yik23XyXxAfzPO8hDZy4KTqcXXXamMcLlIY6xscu4w6Cww7efIYN+XsduHlJnzqSMY9RGyWPE59YRMOKZ8sUYC+Nas3GI7mdC7fdaE1hoYKwtJzCAmdjt5FYvL+yMWXgQy8u9X+v4ET1zNJF7aBLo/EiGzh5wvP6QUhPG/S+Rfbs2kJCecJkMqgvq+Q9jUghqFAwvVMAjx5r4NO4+GoYtXcSxA/4dOgUQpVUfAMYI/HBFF9EaILdvmRsOYodhnmm+S4Aya5LPzJZhfCI6oDWNnn5UDDqxiqZIMNb0s2sfa70lVEeeNWQGA849djHk69YnWd/f6g2KWHYzwwcXZOvKExFoVGapJE/EJAqcecdKz9jXUxglZH/fUH7NMC6iLRYhaihIWDo8KvNOxgJZagrl4seeAdDnvRLQTWIvBo6uYUtVZewZRpF76dfWbCkxncLPI+MO8RC2VwZ1Jp50503x6Ul0csyRKcb0vOK8Ia5sTfvz1bCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Good day, dear maintainers,

We found a bug using a modified version of syzkaller.

Kernel Branch: 7.0-rc1
Kernel Config: <https://drive.google.com/open?id=1XWXrj7ZUAS3GWmqvnny_U_mcxR6_AZCL>
Unfortunately, we don't have any reproducer for this bug yet.
Thank you!

Best regards,
Sanan Hasanov

------------[ cut here ]------------
inode->i_blocks
WARNING: mm/shmem.c:1430 at shmem_evict_inode+0x9d2/0xa30 mm/shmem.c:1430, CPU#0: syz.2.443/13891
Modules linked in:
CPU: 0 UID: 0 PID: 13891 Comm: syz.2.443 Not tainted 7.0.0-rc1 #1 PREEMPT(full) 
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:shmem_evict_inode+0x9d2/0xa30 mm/shmem.c:1430
Code: 0e 48 3b 84 24 00 01 00 00 75 24 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 59 28 b8 ff e9 43 fe ff ff e8 4f 28 b8 ff 90 <0f> 0b 90 eb 9a e8 24 4f 16 09 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c
RSP: 0018:ffffc9000b8ff680 EFLAGS: 00010293
RAX: ffffffff82056871 RBX: 0000000000000008 RCX: ffff88801b71d700
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000000
RBP: ffffc9000b8ff7d0 R08: ffffffff8da5a1a3 R09: 1ffffffff1b4b434
R10: dffffc0000000000 R11: fffffbfff1b4b435 R12: ffff88804b899ae8
R13: ffff88804b8999f0 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88809b068000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30924220 CR3: 000000000d74a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 evict+0x5ed/0xad0 fs/inode.c:846
 __dentry_kill+0x198/0x5d0 fs/dcache.c:670
 finish_dput+0xc9/0x480 fs/dcache.c:879
 __fput+0x688/0xa60 fs/file_table.c:477
 task_work_run+0x1ce/0x250 kernel/task_work.c:233
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x694/0x22f0 kernel/exit.c:971
 do_group_exit+0x21c/0x2d0 kernel/exit.c:1112
 get_signal+0x1280/0x1330 kernel/signal.c:3034
 arch_do_signal_or_restart+0x9a/0x640 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0x87/0x4e0 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
 do_syscall_64+0x33b/0xfc0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
RIP: 0033:0x7fd265fa3b6d
Code: Unable to access opcode bytes at 0x7fd265fa3b43.
RSP: 002b:00007fd266d8a0d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007fd266216188 RCX: 00007fd265fa3b6d
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fd266216188
RBP: 00007fd266216180 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fd266216218 R14: 000000000000006e R15: 00007ffcd73a64f0
 </TASK>

<<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>

Modules linked in:
CPU: 0 UID: 0 PID: 13891 Comm: syz.2.443 Not tainted 7.0.0-rc1 #1 PREEMPT(full) 
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:shmem_evict_inode+0x9d2/0xa30
Code: 0e 48 3b 84 24 00 01 00 00 75 24 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 59 28 b8 ff e9 43 fe ff ff e8 4f 28 b8 ff 90 <0f> 0b 90 eb 9a e8 24 4f 16 09 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c
RSP: 0018:ffffc9000b8ff680 EFLAGS: 00010293
RAX: ffffffff82056871 RBX: 0000000000000008 RCX: ffff88801b71d700
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000000
RBP: ffffc9000b8ff7d0 R08: ffffffff8da5a1a3 R09: 1ffffffff1b4b434
R10: dffffc0000000000 R11: fffffbfff1b4b435 R12: ffff88804b899ae8
R13: ffff88804b8999f0 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88809b068000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30924220 CR3: 000000000d74a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 evict+0x5ed/0xad0
 __dentry_kill+0x198/0x5d0
 finish_dput+0xc9/0x480
 __fput+0x688/0xa60
 task_work_run+0x1ce/0x250
 do_exit+0x694/0x22f0
 do_group_exit+0x21c/0x2d0
 get_signal+0x1280/0x1330
 arch_do_signal_or_restart+0x9a/0x640
 exit_to_user_mode_loop+0x87/0x4e0
 do_syscall_64+0x33b/0xfc0
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
RIP: 0033:0x7fd265fa3b6d
Code: Unable to access opcode bytes at 0x7fd265fa3b43.
RSP: 002b:00007fd266d8a0d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007fd266216188 RCX: 00007fd265fa3b6d
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fd266216188
RBP: 00007fd266216180 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fd266216218 R14: 000000000000006e R15: 00007ffcd73a64f0
 </TASK>
Kernel panic - not syncing: kernel: panic_on_warn set ...
CPU: 0 UID: 0 PID: 13891 Comm: syz.2.443 Not tainted 7.0.0-rc1 #1 PREEMPT(full) 
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 vpanic+0x41f/0xa30
 panic+0xb9/0xc0
 __warn+0x317/0x500
 __report_bug+0x28d/0x500
 report_bug+0x16a/0x220
 handle_bug+0x98/0x200
 exc_invalid_op+0x1a/0x50
 asm_exc_invalid_op+0x1a/0x20
RIP: 0010:shmem_evict_inode+0x9d2/0xa30
Code: 0e 48 3b 84 24 00 01 00 00 75 24 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 59 28 b8 ff e9 43 fe ff ff e8 4f 28 b8 ff 90 <0f> 0b 90 eb 9a e8 24 4f 16 09 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c
RSP: 0018:ffffc9000b8ff680 EFLAGS: 00010293
RAX: ffffffff82056871 RBX: 0000000000000008 RCX: ffff88801b71d700
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000000
RBP: ffffc9000b8ff7d0 R08: ffffffff8da5a1a3 R09: 1ffffffff1b4b434
R10: dffffc0000000000 R11: fffffbfff1b4b435 R12: ffff88804b899ae8
R13: ffff88804b8999f0 R14: 0000000000000000 R15: 0000000000000000
 evict+0x5ed/0xad0
 __dentry_kill+0x198/0x5d0
 finish_dput+0xc9/0x480
 __fput+0x688/0xa60
 task_work_run+0x1ce/0x250
 do_exit+0x694/0x22f0
 do_group_exit+0x21c/0x2d0
 get_signal+0x1280/0x1330
 arch_do_signal_or_restart+0x9a/0x640
 exit_to_user_mode_loop+0x87/0x4e0
 do_syscall_64+0x33b/0xfc0
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
RIP: 0033:0x7fd265fa3b6d
Code: Unable to access opcode bytes at 0x7fd265fa3b43.
RSP: 002b:00007fd266d8a0d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007fd266216188 RCX: 00007fd265fa3b6d
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fd266216188
RBP: 00007fd266216180 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fd266216218 R14: 000000000000006e R15: 00007ffcd73a64f0
 </TASK>
Kernel Offset: disabled
Rebooting in 86400 seconds..

<<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>

