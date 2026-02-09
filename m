Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5198BE81BCF
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98A6C6B0088; Mon,  9 Feb 2026 09:36:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93C416B0089; Mon,  9 Feb 2026 09:36:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659406B008C; Mon,  9 Feb 2026 09:36:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51AAE6B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:36:37 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 067EC567BA
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:36:37 +0000 (UTC)
X-FDA: 84425169234.30.E4EBC9A
Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3E8714000D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:36:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of 38vCJaQkbAE89FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.78 as permitted sender) smtp.mailfrom=38vCJaQkbAE89FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770647795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=0lzC3FE5Gg9ui+AagGYjOf20jX4g13SU5kAdfyvpY9U=;
	b=DssWk58FO7+rUFmhG+2w3RZaVB67nj5V8hps/ZJOk2F7vEBsGSUuSafbGXKHZe5RZoz142
	qBr505Dsrb4urzsvOg9SOLaV7ZJWJyeS3r7kipPO0UfVJvFHe9f/8+ybWcGe3NkR/+SCG7
	DQnaxDps89R1JSqfx+k/8B80oLUk10w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of 38vCJaQkbAE89FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.78 as permitted sender) smtp.mailfrom=38vCJaQkbAE89FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770647795; a=rsa-sha256;
	cv=none;
	b=MYWadZTgv3vq9e4kaLqSZBewF0V7vQWVFNcvaaGJSCpHye+27jKMaEJQl5wR6vJMXf0F0A
	Yhf5cGcN7cjC4/xlqD7Yjo+yc+7PSv74biKUg9DX9xPVhv7Qws86aCPHKqTAYK9HqNKFeO
	li8BA7Iy2fO9evAhXQRVduU1LNsnpFM=
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7d19c1317ccso8350053a34.0
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 06:36:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770647794; x=1771252594;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0lzC3FE5Gg9ui+AagGYjOf20jX4g13SU5kAdfyvpY9U=;
        b=vFu0ummuaCvnphMwDZXVo7y7syfINeCWaa6SPecTYDGimfkGwx4JpbHSSLBLOLr7XH
         obanmtTGKu/ZNhnP4w+ZOSSWUyXloPi+XX0O8+gGQwG4lUEq/3PxUqJmwR3PSfrhvzWw
         5v3/e3i4Jq1vmOsIhKY8VKyS8sc2W+N9RMyglRbAaeNjr+p+MhJ5OMa6ZuRsTVJY55MO
         2q/yTSeiwasv/xQf4kSH7mrikwZmxs0ey9i2zibbnXWqL2bmpQMdmeH3KuBMsvjNUoZg
         NlT6FXfFLUk9Q/yAcK6OPMalCw74YRIXQ3JbcZT8tjh09dc/0MMjoUJxD36h1zmIgJ20
         dCXA==
X-Forwarded-Encrypted: i=1; AJvYcCW0oVHfZTMC5kO9+11a3erIns7AXQkV45otDu4bvyfV5CESLXu+mFzIH67DxRuAe9baeXfmFXHhwQ==@kvack.org
X-Gm-Message-State: AOJu0YypzxV7HwcQQF1uAFbIMmq/QWu659Wi/bqyD56IizWVWy7IlgdP
	XcHLMS4GwSSl0WuC0pp8OaV6Fd7vrgIr4tss+h216HkIEPU8Qjk2eGpKUGY9KEOjVzrmAyzzril
	6w9OUI4IDvNr2+Uftl8tSk2SF7b0QgkuJwXJj+hFmwcsNDCGHwetiayGeFno=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:6ae6:b0:663:888:73d1 with SMTP id
 006d021491bc7-66d0c854006mr4808343eaf.60.1770647794068; Mon, 09 Feb 2026
 06:36:34 -0800 (PST)
Date: Mon, 09 Feb 2026 06:36:34 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6989f0f2.a00a0220.34fa92.0047.GAE@google.com>
Subject: [syzbot] [fs?] [mm?] possible deadlock in writeout_period
From: syzbot <syzbot+d38b792a5cbd941006fc@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: we1mjcugwz8mshmu1ukgpafanboqpyhk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3E8714000D
X-HE-Tag: 1770647795-134350
X-HE-Meta: U2FsdGVkX19GN/RMxvbK7iBiJFL/YiC67zgbX0jfmpUvpWuzUjAmoAkzrCn9lYzKJUFdwt05LF1EN+Eoeb1gCH2qFRlYyYVOxXNhGXqGCMxjvNi/x3YMBXRfqDGi4QUp2NioopFjOmdKAcoGQK1Hn2XuacmngK7M7nqOeS2712M3JTxd3w8hREZgmUQzxlxwdcWnb8OkthSkKWwvi8Dtg2d22c57ucKhqCIigSIGvHzQzPmk7UDSCJjqVRV4rw3LLY1MgXmvnw/HldWRCZc2HXICly/0riD4vXth7VlkP2DH0mwF6dCOZCjHx8UCubf6inre5/Z0n7Dj5W66hvMrCu/FyZ23cXoxyATCNuBAjUxJK+fAHnhitHPI9yMFDUdqFi5wCvsVKUrStS76OEzf4pMCSQWEEwoSfkPnV5mYB6fqwU+w+odfLrG2qDR/5XTNfp+g0tHnu0LJNG94TLSIH0fM8jxbVIEc+Cep4lglhSVEOsXWp/s5kSyJPBArv0yJO36qNVqCXvEuSMN6vsg8ckqn98BJstBw4lgOLN242/O3iS/2yIbBXJ7Zt0SpLQSC+1qV30OiT5/3vH4CdHBTkOshdhbEvb92TeozCEwMZNqVwQX8wDheue1BZOsfyjNPF/RaoVp+5fgvBfuavJEFC7Aap3ZlzaRC6yNotXEleTCtdXorVd/cr7mPUlgUr9Cq7ZDOX3EHTNUWusa4cksHa2X/PmT1CsrXqExmtU5lyBdCYQV4mFvkrhqtl2DGQlTPEoDeUJcWmlj94Wa8DUJ3IvsAM4SYWOFBrd7aFBMWobq73kJ9vx8g5FoSBgEKNJZGRsIR+HgH4tuUg5cqyN7B34FGcTVn82ZgUT/xIdZpNIPbHeWJG25IiY26dsGqPPellxu4HH7IWqJZlI0yHEr90Nzlee+ICUWq2g+yyY9/6aKjDmdMYqy0s/576tsbVTyy3TuTL3GLgecfP20qz1G
 W0hOhC3q
 1NDKlP2058Pqw2jQBQTm+ce1pp/GtQhNd4VLO+fXCSJEtQ4ov1GfpgShFoXPmuEhntDn2Gw0gYUup9cPlcFBzyE1SwpLs3gwA2wEO/3X+M4VbiITp/QZbo/85Ym6ZPSksHrdVE4iD8HXlvQDUtPOtNDLlvnATxZ64r58LezVInB/znDFipieiQBH1n7jfDvZevY6VgF5uRu11Cjk6IqG9kOAXsG33AkSizMUGQ0c7cM9tK6jwjEY+MzJjLuWpRvXnkdZelvOJFvkB3ke7UNzpPiQKifmXjSlwAuiaWSb5an3wvfnPbqtrvMFUbfCC5tC7u4xJYrz9/3o0W58Nc4YGD/PGGJkvMo2EfHNPPAuwtPHAQXsSWpFgn1CTXVVs68VjSYznyR9yTsg6UaSfez2GClrGtBMwnn3o9037Iwx3ibDIH3aIwKsaerJoM2u9xvW4cqoAy3MxzEp5V7VPjJQklzESzFd++K65M8eNsLt08g/2GSvuFqiF1HP+2Ih4AkbaF4qi0FtDSHgNfi+xFJOydcdebCvYS6iuE3aqKj/yAyeeP+42R7trd2ZD3ENyWH+oM9AZzOaKh9fQAhQNw5kMFPr8Te9NnkRQC5wHapYYFIrvbkyDU9F73Dw0nUxdMr5whKWVS5xLn52HTQF2s3C9JuxFZC+ExRIyAVID5G7SIcz5Scg+8uKUhT1nTTuJo3YCcKSOLPx+s1qk4khHx/lgy3eQBoyZVtMTqnCD5LovEVXyQNJACDO8MsrcDWRT3Uu8fSB3YKwbyuT/YOQz/v020JC9mKdtvczvNrY3x4PMNSIvS6JkaETE2qgBOPjAZtu+fWWlJOi8tC1Vl2pP7slWxa3zAssPSZX6X6RxFjGJm0+8GCE/8cQxpoBzLUtxyD/CEjAUV0HS9ZuOXRVmJUCQejALQ31NvNkj3U9XvpbZ6PeQ4hnj8MDp0XsXJkE39vaa3KE7EXqMSewTq00honqq/1L8y/YF
 l+qZjaW1
 iELW+edK3aEID2pTdrham7lnsquBXUI6QNGQ+obmcaVjYGyIKIAQ0J3KhiSfdv3TGtIJV0rhN+ItFetUod2X6nyE0PcHO0/4qAGVRNkgbWUzA7ZpNW0Oxt7kj0aSxZ195TxbxoMl36DD0CsKdAyfNHxXvCVnMX0HZ3TbRUHwf7tE9W0ivn6+Or+Bp2yHWoTli+KTuYtggdAavVvfVyGvKjlqjgBGbyKRlt1HWCIMhyaXJv6arlP1Sws2xw2rmG8yQYhvhZQLy5jkljbQ/7qw2tQklfa85wUpZ42S38YCLqqvZxiqdhkhlkgmDYwWV77DaMyPj55plrSnC+2ZxIRFxwYpPdXfaOnuFaTBN8cJciZ3fRhjHEZX8KHvCex/U9/cKqxPpsGaPIn8XYwbSDnmYZwSqESvRUwLNpQSBBODjs2i07VxJuq8j2b9CJb67MOE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    59e4d31a0470 Merge branches 'for-next/core' and 'for-next/..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=14454b22580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8a8594efdc14f07a
dashboard link: https://syzkaller.appspot.com/bug?extid=d38b792a5cbd941006fc
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/746a1d5c4188/disk-59e4d31a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2eefade79f10/vmlinux-59e4d31a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/140624ef24ed/Image-59e4d31a.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d38b792a5cbd941006fc@syzkaller.appspotmail.com

========================================================
WARNING: possible irq lock inversion dependency detected
syzkaller #0 Not tainted
--------------------------------------------------------
syz-executor/6572 just changed the state of lock:
ffff800097626150 (&p->sequence){+.-.}-{0:0}, at: writeout_period+0x94/0x11c mm/page-writeback.c:615
but this lock was taken by another, HARDIRQ-safe lock in the past:
 (&xa->xa_lock#10){-.-.}-{3:3}


and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&p->sequence);
                               local_irq_disable();
                               lock(&xa->xa_lock#10);
                               lock(&p->sequence);
  <Interrupt>
    lock(&xa->xa_lock#10);

 *** DEADLOCK ***

1 lock held by syz-executor/6572:
 #0: ffff800097bd7c40 ((&dom->period_timer)){+.-.}-{0:0}, at: lockdep_copy_map include/linux/lockdep.h:41 [inline]
 #0: ffff800097bd7c40 ((&dom->period_timer)){+.-.}-{0:0}, at: call_timer_fn+0xd4/0x814 kernel/time/timer.c:1738

the shortest dependencies between 2nd lock and 1st lock:
 -> (&xa->xa_lock#10){-.-.}-{3:3} {
    IN-HARDIRQ-W at:
                      lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5868
                      __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
                      _raw_spin_lock_irqsave+0x5c/0x7c kernel/locking/spinlock.c:162
                      __folio_end_writeback+0x10c/0x6f8 mm/page-writeback.c:2990
                      folio_end_writeback_no_dropbehind+0xd0/0x204 mm/filemap.c:1661
                      folio_end_writeback+0xd8/0x248 mm/filemap.c:1687
                      end_buffer_async_write+0x20c/0x350 fs/buffer.c:419
                      end_bio_bh_io_sync+0xb0/0x184 fs/buffer.c:2776
                      bio_endio+0x8d4/0x910 block/bio.c:1675
                      blk_complete_request block/blk-mq.c:908 [inline]
                      blk_mq_end_request_batch+0x49c/0x105c block/blk-mq.c:1202
                      nvme_complete_batch drivers/nvme/host/nvme.h:802 [inline]
                      nvme_pci_complete_batch drivers/nvme/host/pci.c:1348 [inline]
                      nvme_irq+0x1ec/0x240 drivers/nvme/host/pci.c:1450
                      __handle_irq_event_percpu+0x20c/0x8e4 kernel/irq/handle.c:211
                      handle_irq_event_percpu kernel/irq/handle.c:248 [inline]
                      handle_irq_event+0x9c/0x1d0 kernel/irq/handle.c:265
                      handle_fasteoi_irq+0x328/0x8d8 kernel/irq/chip.c:764
                      generic_handle_irq_desc include/linux/irqdesc.h:172 [inline]
                      handle_irq_desc kernel/irq/irqdesc.c:669 [inline]
                      generic_handle_domain_irq+0xe0/0x140 kernel/irq/irqdesc.c:725
                      __gic_handle_irq drivers/irqchip/irq-gic-v3.c:825 [inline]
                      __gic_handle_irq_from_irqson drivers/irqchip/irq-gic-v3.c:876 [inline]
                      gic_handle_irq+0x6c/0x18c drivers/irqchip/irq-gic-v3.c:920
                      call_on_irq_stack+0x30/0x48 arch/arm64/kernel/entry.S:891
                      do_interrupt_handler+0xd4/0x138 arch/arm64/kernel/entry-common.c:135
                      __el1_irq arch/arm64/kernel/entry-common.c:497 [inline]
                      el1_interrupt+0x3c/0x60 arch/arm64/kernel/entry-common.c:510
                      el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:515
                      el1h_64_irq+0x6c/0x70 arch/arm64/kernel/entry.S:592
                      __daif_local_irq_restore arch/arm64/include/asm/irqflags.h:175 [inline]
                      arch_local_irq_restore arch/arm64/include/asm/irqflags.h:195 [inline]
                      kasan_quarantine_put+0xbc/0x1c8 mm/kasan/quarantine.c:234
                      __kasan_slab_free+0x8c/0xa4 mm/kasan/common.c:295
                      kasan_slab_free include/linux/kasan.h:235 [inline]
                      slab_free_hook mm/slub.c:2540 [inline]
                      slab_free_after_rcu_debug+0x120/0x2f8 mm/slub.c:6729
                      rcu_do_batch kernel/rcu/tree.c:2605 [inline]
                      rcu_core+0x848/0x1774 kernel/rcu/tree.c:2857
                      rcu_core_si+0x10/0x1c kernel/rcu/tree.c:2874
                      handle_softirqs+0x31c/0xc88 kernel/softirq.c:622
                      run_ksoftirqd+0x70/0xc0 kernel/softirq.c:1063
                      smpboot_thread_fn+0x4d8/0x9cc kernel/smpboot.c:160
                      kthread+0x5fc/0x75c kernel/kthread.c:463
                      ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:844
    IN-SOFTIRQ-W at:
                      lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5868
                      __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
                      _raw_spin_lock_irqsave+0x5c/0x7c kernel/locking/spinlock.c:162
                      __folio_end_writeback+0x10c/0x6f8 mm/page-writeback.c:2990
                      folio_end_writeback_no_dropbehind+0xd0/0x204 mm/filemap.c:1661
                      folio_end_writeback+0xd8/0x248 mm/filemap.c:1687
                      end_buffer_async_write+0x20c/0x350 fs/buffer.c:419
                      end_bio_bh_io_sync+0xb0/0x184 fs/buffer.c:2776
                      bio_endio+0x8d4/0x910 block/bio.c:1675
                      blk_complete_request block/blk-mq.c:908 [inline]
                      blk_mq_end_request_batch+0x49c/0x105c block/blk-mq.c:1202
                      nvme_complete_batch drivers/nvme/host/nvme.h:802 [inline]
                      nvme_pci_complete_batch drivers/nvme/host/pci.c:1348 [inline]
                      nvme_irq+0x1ec/0x240 drivers/nvme/host/pci.c:1450
                      __handle_irq_event_percpu+0x20c/0x8e4 kernel/irq/handle.c:211
                      handle_irq_event_percpu kernel/irq/handle.c:248 [inline]
                      handle_irq_event+0x9c/0x1d0 kernel/irq/handle.c:265
                      handle_fasteoi_irq+0x328/0x8d8 kernel/irq/chip.c:764
                      generic_handle_irq_desc include/linux/irqdesc.h:172 [inline]
                      handle_irq_desc kernel/irq/irqdesc.c:669 [inline]
                      generic_handle_domain_irq+0xe0/0x140 kernel/irq/irqdesc.c:725
                      __gic_handle_irq drivers/irqchip/irq-gic-v3.c:825 [inline]
                      __gic_handle_irq_from_irqson drivers/irqchip/irq-gic-v3.c:876 [inline]
                      gic_handle_irq+0x6c/0x18c drivers/irqchip/irq-gic-v3.c:920
                      call_on_irq_stack+0x30/0x48 arch/arm64/kernel/entry.S:891
                      do_interrupt_handler+0xd4/0x138 arch/arm64/kernel/entry-common.c:135
                      __el1_irq arch/arm64/kernel/entry-common.c:497 [inline]
                      el1_interrupt+0x3c/0x60 arch/arm64/kernel/entry-common.c:510
                      el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:515
                      el1h_64_irq+0x6c/0x70 arch/arm64/kernel/entry.S:592
                      __daif_local_irq_restore arch/arm64/include/asm/irqflags.h:175 [inline]
                      arch_local_irq_restore arch/arm64/include/asm/irqflags.h:195 [inline]
                      kasan_quarantine_put+0xbc/0x1c8 mm/kasan/quarantine.c:234
                      __kasan_slab_free+0x8c/0xa4 mm/kasan/common.c:295
                      kasan_slab_free include/linux/kasan.h:235 [inline]
                      slab_free_hook mm/slub.c:2540 [inline]
                      slab_free_after_rcu_debug+0x120/0x2f8 mm/slub.c:6729
                      rcu_do_batch kernel/rcu/tree.c:2605 [inline]
                      rcu_core+0x848/0x1774 kernel/rcu/tree.c:2857
                      rcu_core_si+0x10/0x1c kernel/rcu/tree.c:2874
                      handle_softirqs+0x31c/0xc88 kernel/softirq.c:622
                      run_ksoftirqd+0x70/0xc0 kernel/softirq.c:1063
                      smpboot_thread_fn+0x4d8/0x9cc kernel/smpboot.c:160
                      kthread+0x5fc/0x75c kernel/kthread.c:463
                      ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:844
    INITIAL USE at:
                     lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5868
                     __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
                     _raw_spin_lock_irq+0x58/0x70 kernel/locking/spinlock.c:170
                     spin_lock_irq include/linux/spinlock.h:376 [inline]
                     shmem_add_to_page_cache+0x564/0xa24 mm/shmem.c:904
                     shmem_alloc_and_add_folio+0x758/0x10c4 mm/shmem.c:1958
                     shmem_get_folio_gfp+0x4d4/0x159c mm/shmem.c:2556
                     shmem_read_folio_gfp+0x8c/0xf0 mm/shmem.c:5970
                     drm_gem_get_pages+0x1cc/0x7c0 drivers/gpu/drm/drm_gem.c:654
                     drm_gem_shmem_get_pages_locked+0x1d4/0x364 drivers/gpu/drm/drm_gem_shmem_helper.c:240
                     drm_gem_shmem_pin_locked+0x1f8/0x410 drivers/gpu/drm/drm_gem_shmem_helper.c:301
                     drm_gem_shmem_vmap_locked+0x3cc/0x658 drivers/gpu/drm/drm_gem_shmem_helper.c:405
                     drm_gem_shmem_object_vmap+0x28/0x38 include/drm/drm_gem_shmem_helper.h:245
                     drm_gem_vmap_locked drivers/gpu/drm/drm_gem.c:1273 [inline]
                     drm_gem_vmap+0x104/0x1d8 drivers/gpu/drm/drm_gem.c:1315
                     drm_client_buffer_vmap+0x68/0xb0 drivers/gpu/drm/drm_client.c:355
                     drm_fbdev_shmem_driver_fbdev_probe+0x1f4/0x700 drivers/gpu/drm/drm_fbdev_shmem.c:159
                     drm_fb_helper_single_fb_probe drivers/gpu/drm/drm_fb_helper.c:1562 [inline]
                     __drm_fb_helper_initial_config_and_unlock+0x108c/0x1728 drivers/gpu/drm/drm_fb_helper.c:1741
                     drm_fb_helper_initial_config+0x3c/0x58 drivers/gpu/drm/drm_fb_helper.c:1828
                     drm_fbdev_client_hotplug+0x154/0x22c drivers/gpu/drm/clients/drm_fbdev_client.c:66
                     drm_client_register+0x13c/0x1d4 drivers/gpu/drm/drm_client.c:143
                     drm_fbdev_client_setup+0x194/0x3d0 drivers/gpu/drm/clients/drm_fbdev_client.c:168
                     drm_client_setup+0x114/0x228 drivers/gpu/drm/clients/drm_client_setup.c:46
                     vkms_create+0x370/0x420 drivers/gpu/drm/vkms/vkms_drv.c:211
                     vkms_init+0x64/0x9c drivers/gpu/drm/vkms/vkms_drv.c:239
                     do_one_initcall+0x248/0x9b4 init/main.c:1378
                     do_initcall_level+0x128/0x1c4 init/main.c:1440
                     do_initcalls+0x70/0xd0 init/main.c:1456
                     do_basic_setup+0x78/0x8c init/main.c:1475
                     kernel_init_freeable+0x268/0x39c init/main.c:1688
                     kernel_init+0x24/0x1dc init/main.c:1578
                     ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:844
  }
  ... key      at: [<ffff80009764a620>] xa_init_flags.__key+0x0/0x20
  ... acquired at:
   seqcount_lockdep_reader_access include/linux/seqlock.h:72 [inline]
   fprop_fraction_percpu+0xf0/0x270 lib/flex_proportions.c:155
   __fprop_add_percpu_max+0x130/0x1f4 lib/flex_proportions.c:186
   wb_domain_writeout_add mm/page-writeback.c:562 [inline]
   __wb_writeout_add+0xbc/0x27c mm/page-writeback.c:586
   __folio_end_writeback+0x380/0x6f8 mm/page-writeback.c:2997
   folio_end_writeback_no_dropbehind+0xd0/0x204 mm/filemap.c:1661
   folio_end_writeback+0xd8/0x248 mm/filemap.c:1687
   iomap_finish_folio_write+0x1c0/0x2a4 fs/iomap/buffered-io.c:1713
   fuse_writepage_finish fs/fuse/file.c:1903 [inline]
   fuse_writepage_end+0x238/0x454 fs/fuse/file.c:2003
   fuse_request_end+0x898/0xc10 fs/fuse/dev.c:507
   fuse_dev_end_requests fs/fuse/dev.c:2415 [inline]
   fuse_abort_conn+0xe88/0x10a0 fs/fuse/dev.c:2513
   fuse_dev_release+0x430/0x4c8 fs/fuse/dev.c:2556
   __fput+0x340/0x75c fs/file_table.c:468
   fput_close_sync+0x100/0x264 fs/file_table.c:573
   __do_sys_close fs/open.c:1573 [inline]
   __se_sys_close fs/open.c:1558 [inline]
   __arm64_sys_close+0x7c/0x118 fs/open.c:1558
   __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
   invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
   el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:132
   do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
   el0_svc+0x5c/0x26c arch/arm64/kernel/entry-common.c:724
   el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
   el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> (&p->sequence){+.-.}-{0:0} {
   HARDIRQ-ON-W at:
                    lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5868
                    do_write_seqcount_begin_nested include/linux/seqlock.h:477 [inline]
                    do_write_seqcount_begin include/linux/seqlock.h:503 [inline]
                    fprop_new_period+0x3b8/0x718 lib/flex_proportions.c:74
                    writeout_period+0x94/0x11c mm/page-writeback.c:615
                    call_timer_fn+0x19c/0x814 kernel/time/timer.c:1748
                    expire_timers kernel/time/timer.c:1799 [inline]
                    __run_timers kernel/time/timer.c:2373 [inline]
                    __run_timer_base+0x51c/0x76c kernel/time/timer.c:2385
                    run_timer_base kernel/time/timer.c:2394 [inline]
                    run_timer_softirq+0x11c/0x194 kernel/time/timer.c:2405
                    handle_softirqs+0x31c/0xc88 kernel/softirq.c:622
                    __do_softirq+0x14/0x20 kernel/softirq.c:656
                    ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:68
                    call_on_irq_stack+0x30/0x48 arch/arm64/kernel/entry.S:891
                    do_softirq_own_stack+0x20/0x2c arch/arm64/kernel/irq.c:73
                    invoke_softirq kernel/softirq.c:503 [inline]
                    __irq_exit_rcu+0x1b0/0x478 kernel/softirq.c:723
                    irq_exit_rcu+0x14/0x84 kernel/softirq.c:739
                    __el1_irq arch/arm64/kernel/entry-common.c:498 [inline]
                    el1_interrupt+0x40/0x60 arch/arm64/kernel/entry-common.c:510
                    el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:515
                    el1h_64_irq+0x6c/0x70 arch/arm64/kernel/entry.S:592
                    __daif_local_irq_enable arch/arm64/include/asm/irqflags.h:26 [inline]
                    arch_local_irq_enable arch/arm64/include/asm/irqflags.h:48 [inline]
                    preempt_schedule_irq+0x78/0x188 kernel/sched/core.c:7189
                    raw_irqentry_exit_cond_resched+0x30/0x44 kernel/entry/common.c:173
                    irqentry_exit+0x1b0/0x308 kernel/entry/common.c:216
                    exit_to_kernel_mode+0x10/0x1c arch/arm64/kernel/entry-common.c:58
                    __el1_irq arch/arm64/kernel/entry-common.c:500 [inline]
                    el1_interrupt+0x4c/0x60 arch/arm64/kernel/entry-common.c:510
                    el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:515
                    el1h_64_irq+0x6c/0x70 arch/arm64/kernel/entry.S:592
                    __daif_local_irq_restore arch/arm64/include/asm/irqflags.h:175 [inline]
                    arch_local_irq_restore arch/arm64/include/asm/irqflags.h:195 [inline]
                    class_irqsave_destructor include/linux/irqflags.h:266 [inline]
                    __free_object+0x514/0x720 lib/debugobjects.c:524
                    free_object lib/debugobjects.c:532 [inline]
                    debug_object_free+0x298/0x3e4 lib/debugobjects.c:976
                    destroy_hrtimer_on_stack kernel/time/hrtimer.c:448 [inline]
                    hrtimer_nanosleep+0x214/0x2a4 kernel/time/hrtimer.c:2178
                    common_nsleep+0xa0/0xb8 kernel/time/posix-timers.c:1352
                    __do_sys_clock_nanosleep kernel/time/posix-timers.c:1398 [inline]
                    __se_sys_clock_nanosleep kernel/time/posix-timers.c:1375 [inline]
                    __arm64_sys_clock_nanosleep+0x334/0x370 kernel/time/posix-timers.c:1375
                    __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
                    invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
                    el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:132
                    do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
                    el0_svc+0x5c/0x26c arch/arm64/kernel/entry-common.c:724
                    el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
                    el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
   IN-SOFTIRQ-W at:
                    lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5868
                    do_write_seqcount_begin_nested include/linux/seqlock.h:477 [inline]
                    do_write_seqcount_begin include/linux/seqlock.h:503 [inline]
                    fprop_new_period+0x3b8/0x718 lib/flex_proportions.c:74
                    writeout_period+0x94/0x11c mm/page-writeback.c:615
                    call_timer_fn+0x19c/0x814 kernel/time/timer.c:1748
                    expire_timers kernel/time/timer.c:1799 [inline]
                    __run_timers kernel/time/timer.c:2373 [inline]
                    __run_timer_base+0x51c/0x76c kernel/time/timer.c:2385
                    run_timer_base kernel/time/timer.c:2394 [inline]
                    run_timer_softirq+0x11c/0x194 kernel/time/timer.c:2405
                    handle_softirqs+0x31c/0xc88 kernel/softirq.c:622
                    __do_softirq+0x14/0x20 kernel/softirq.c:656
                    ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:68
                    call_on_irq_stack+0x30/0x48 arch/arm64/kernel/entry.S:891
                    do_softirq_own_stack+0x20/0x2c arch/arm64/kernel/irq.c:73
                    invoke_softirq kernel/softirq.c:503 [inline]
                    __irq_exit_rcu+0x1b0/0x478 kernel/softirq.c:723
                    irq_exit_rcu+0x14/0x84 kernel/softirq.c:739
                    __el1_irq arch/arm64/kernel/entry-common.c:498 [inline]
                    el1_interrupt+0x40/0x60 arch/arm64/kernel/entry-common.c:510
                    el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:515
                    el1h_64_irq+0x6c/0x70 arch/arm64/kernel/entry.S:592
                    __daif_local_irq_enable arch/arm64/include/asm/irqflags.h:26 [inline]
                    arch_local_irq_enable arch/arm64/include/asm/irqflags.h:48 [inline]
                    preempt_schedule_irq+0x78/0x188 kernel/sched/core.c:7189
                    raw_irqentry_exit_cond_resched+0x30/0x44 kernel/entry/common.c:173
                    irqentry_exit+0x1b0/0x308 kernel/entry/common.c:216
                    exit_to_kernel_mode+0x10/0x1c arch/arm64/kernel/entry-common.c:58
                    __el1_irq arch/arm64/kernel/entry-common.c:500 [inline]
                    el1_interrupt+0x4c/0x60 arch/arm64/kernel/entry-common.c:510
                    el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:515
                    el1h_64_irq+0x6c/0x70 arch/arm64/kernel/entry.S:592
                    __daif_local_irq_restore arch/arm64/include/asm/irqflags.h:175 [inline]
                    arch_local_irq_restore arch/arm64/include/asm/irqflags.h:195 [inline]
                    class_irqsave_destructor include/linux/irqflags.h:266 [inline]
                    __free_object+0x514/0x720 lib/debugobjects.c:524
                    free_object lib/debugobjects.c:532 [inline]
                    debug_object_free+0x298/0x3e4 lib/debugobjects.c:976
                    destroy_hrtimer_on_stack kernel/time/hrtimer.c:448 [inline]
                    hrtimer_nanosleep+0x214/0x2a4 kernel/time/hrtimer.c:2178
                    common_nsleep+0xa0/0xb8 kernel/time/posix-timers.c:1352
                    __do_sys_clock_nanosleep kernel/time/posix-timers.c:1398 [inline]
                    __se_sys_clock_nanosleep kernel/time/posix-timers.c:1375 [inline]
                    __arm64_sys_clock_nanosleep+0x334/0x370 kernel/time/posix-timers.c:1375
                    __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
                    invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
                    el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:132
                    do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
                    el0_svc+0x5c/0x26c arch/arm64/kernel/entry-common.c:724
                    el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
                    el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
   INITIAL READ USE at:
                        lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5868
                        seqcount_lockdep_reader_access include/linux/seqlock.h:72 [inline]
                        fprop_fraction_percpu+0xac/0x270 lib/flex_proportions.c:155
                        __wb_calc_thresh+0xfc/0x3b0 mm/page-writeback.c:913
                        wb_bg_dirty_limits mm/page-writeback.c:2130 [inline]
                        domain_over_bg_thresh+0xb8/0x1f0 mm/page-writeback.c:2144
                        wb_over_bg_thresh+0xf8/0x17c mm/page-writeback.c:2165
                        wb_check_background_flush fs/fs-writeback.c:2278 [inline]
                        wb_do_writeback fs/fs-writeback.c:2376 [inline]
                        wb_workfn+0xa30/0xdc0 fs/fs-writeback.c:2403
                        process_one_work+0x7c0/0x1558 kernel/workqueue.c:3257
                        process_scheduled_works kernel/workqueue.c:3340 [inline]
                        worker_thread+0x958/0xed8 kernel/workqueue.c:3421
                        kthread+0x5fc/0x75c kernel/kthread.c:463
                        ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:844
 }
 ... key      at: [<ffff800097b9a340>] fprop_global_init.__key.1+0x0/0x20
 ... acquired at:
   mark_lock+0x170/0x1d0 kernel/locking/lockdep.c:4753
   mark_usage kernel/locking/lockdep.c:4662 [inline]
   __lock_acquire+0x9a0/0x30a4 kernel/locking/lockdep.c:5191
   lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5868
   do_write_seqcount_begin_nested include/linux/seqlock.h:477 [inline]
   do_write_seqcount_begin include/linux/seqlock.h:503 [inline]
   fprop_new_period+0x3b8/0x718 lib/flex_proportions.c:74
   writeout_period+0x94/0x11c mm/page-writeback.c:615
   call_timer_fn+0x19c/0x814 kernel/time/timer.c:1748
   expire_timers kernel/time/timer.c:1799 [inline]
   __run_timers kernel/time/timer.c:2373 [inline]
   __run_timer_base+0x51c/0x76c kernel/time/timer.c:2385
   run_timer_base kernel/time/timer.c:2394 [inline]
   run_timer_softirq+0x11c/0x194 kernel/time/timer.c:2405
   handle_softirqs+0x31c/0xc88 kernel/softirq.c:622
   __do_softirq+0x14/0x20 kernel/softirq.c:656
   ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:68
   call_on_irq_stack+0x30/0x48 arch/arm64/kernel/entry.S:891
   do_softirq_own_stack+0x20/0x2c arch/arm64/kernel/irq.c:73
   invoke_softirq kernel/softirq.c:503 [inline]
   __irq_exit_rcu+0x1b0/0x478 kernel/softirq.c:723
   irq_exit_rcu+0x14/0x84 kernel/softirq.c:739
   __el1_irq arch/arm64/kernel/entry-common.c:498 [inline]
   el1_interrupt+0x40/0x60 arch/arm64/kernel/entry-common.c:510
   el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:515
   el1h_64_irq+0x6c/0x70 arch/arm64/kernel/entry.S:592
   __daif_local_irq_enable arch/arm64/include/asm/irqflags.h:26 [inline]
   arch_local_irq_enable arch/arm64/include/asm/irqflags.h:48 [inline]
   preempt_schedule_irq+0x78/0x188 kernel/sched/core.c:7189
   raw_irqentry_exit_cond_resched+0x30/0x44 kernel/entry/common.c:173
   irqentry_exit+0x1b0/0x308 kernel/entry/common.c:216
   exit_to_kernel_mode+0x10/0x1c arch/arm64/kernel/entry-common.c:58
   __el1_irq arch/arm64/kernel/entry-common.c:500 [inline]
   el1_interrupt+0x4c/0x60 arch/arm64/kernel/entry-common.c:510
   el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:515
   el1h_64_irq+0x6c/0x70 arch/arm64/kernel/entry.S:592
   __daif_local_irq_restore arch/arm64/include/asm/irqflags.h:175 [inline]
   arch_local_irq_restore arch/arm64/include/asm/irqflags.h:195 [inline]
   class_irqsave_destructor include/linux/irqflags.h:266 [inline]
   __free_object+0x514/0x720 lib/debugobjects.c:524
   free_object lib/debugobjects.c:532 [inline]
   debug_object_free+0x298/0x3e4 lib/debugobjects.c:976
   destroy_hrtimer_on_stack kernel/time/hrtimer.c:448 [inline]
   hrtimer_nanosleep+0x214/0x2a4 kernel/time/hrtimer.c:2178
   common_nsleep+0xa0/0xb8 kernel/time/posix-timers.c:1352
   __do_sys_clock_nanosleep kernel/time/posix-timers.c:1398 [inline]
   __se_sys_clock_nanosleep kernel/time/posix-timers.c:1375 [inline]
   __arm64_sys_clock_nanosleep+0x334/0x370 kernel/time/posix-timers.c:1375
   __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
   invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
   el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:132
   do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
   el0_svc+0x5c/0x26c arch/arm64/kernel/entry-common.c:724
   el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
   el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596


stack backtrace:
CPU: 1 UID: 0 PID: 6572 Comm: syz-executor Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/03/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_irq_inversion_bug+0x1f8/0x1fc kernel/locking/lockdep.c:4125
 mark_lock_irq+0x3b4/0x47c kernel/locking/lockdep.c:-1
 mark_lock+0x170/0x1d0 kernel/locking/lockdep.c:4753
 mark_usage kernel/locking/lockdep.c:4662 [inline]
 __lock_acquire+0x9a0/0x30a4 kernel/locking/lockdep.c:5191
 lock_acquire+0x140/0x2e0 kernel/locking/lockdep.c:5868
 do_write_seqcount_begin_nested include/linux/seqlock.h:477 [inline]
 do_write_seqcount_begin include/linux/seqlock.h:503 [inline]
 fprop_new_period+0x3b8/0x718 lib/flex_proportions.c:74
 writeout_period+0x94/0x11c mm/page-writeback.c:615
 call_timer_fn+0x19c/0x814 kernel/time/timer.c:1748
 expire_timers kernel/time/timer.c:1799 [inline]
 __run_timers kernel/time/timer.c:2373 [inline]
 __run_timer_base+0x51c/0x76c kernel/time/timer.c:2385
 run_timer_base kernel/time/timer.c:2394 [inline]
 run_timer_softirq+0x11c/0x194 kernel/time/timer.c:2405
 handle_softirqs+0x31c/0xc88 kernel/softirq.c:622
 __do_softirq+0x14/0x20 kernel/softirq.c:656
 ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:68
 call_on_irq_stack+0x30/0x48 arch/arm64/kernel/entry.S:891
 do_softirq_own_stack+0x20/0x2c arch/arm64/kernel/irq.c:73
 invoke_softirq kernel/softirq.c:503 [inline]
 __irq_exit_rcu+0x1b0/0x478 kernel/softirq.c:723
 irq_exit_rcu+0x14/0x84 kernel/softirq.c:739
 __el1_irq arch/arm64/kernel/entry-common.c:498 [inline]
 el1_interrupt+0x40/0x60 arch/arm64/kernel/entry-common.c:510
 el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:515
 el1h_64_irq+0x6c/0x70 arch/arm64/kernel/entry.S:592
 __daif_local_irq_enable arch/arm64/include/asm/irqflags.h:26 [inline] (P)
 arch_local_irq_enable arch/arm64/include/asm/irqflags.h:48 [inline] (P)
 preempt_schedule_irq+0x78/0x188 kernel/sched/core.c:7189 (P)
 raw_irqentry_exit_cond_resched+0x30/0x44 kernel/entry/common.c:173
 irqentry_exit+0x1b0/0x308 kernel/entry/common.c:216
 exit_to_kernel_mode+0x10/0x1c arch/arm64/kernel/entry-common.c:58
 __el1_irq arch/arm64/kernel/entry-common.c:500 [inline]
 el1_interrupt+0x4c/0x60 arch/arm64/kernel/entry-common.c:510
 el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:515
 el1h_64_irq+0x6c/0x70 arch/arm64/kernel/entry.S:592
 __daif_local_irq_restore arch/arm64/include/asm/irqflags.h:175 [inline] (P)
 arch_local_irq_restore arch/arm64/include/asm/irqflags.h:195 [inline] (P)
 class_irqsave_destructor include/linux/irqflags.h:266 [inline] (P)
 __free_object+0x514/0x720 lib/debugobjects.c:524 (P)
 free_object lib/debugobjects.c:532 [inline]
 debug_object_free+0x298/0x3e4 lib/debugobjects.c:976
 destroy_hrtimer_on_stack kernel/time/hrtimer.c:448 [inline]
 hrtimer_nanosleep+0x214/0x2a4 kernel/time/hrtimer.c:2178
 common_nsleep+0xa0/0xb8 kernel/time/posix-timers.c:1352
 __do_sys_clock_nanosleep kernel/time/posix-timers.c:1398 [inline]
 __se_sys_clock_nanosleep kernel/time/posix-timers.c:1375 [inline]
 __arm64_sys_clock_nanosleep+0x334/0x370 kernel/time/posix-timers.c:1375
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x26c arch/arm64/kernel/entry-common.c:724
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596


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

