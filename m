Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6856C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 21:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA3366B02BF; Thu, 13 Aug 2026 17:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5B7D6B02C1; Thu, 13 Aug 2026 17:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B71566B02C4; Thu, 13 Aug 2026 17:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8641F6B02BF
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:08:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 021F81602E8
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:08:52 +0000 (UTC)
X-FDA: 85097485746.25.BA59C15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 415C41C000A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:08:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Q4YQfrcK;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786655331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+rfmKpCwzQzpk+tikICt/qpBa2ZKmVy8r8vWJfuUcCg=;
	b=t7qyfqHBHG5Qdr6Px8jB7rAp87L40/rIkLjFpTbrVw14uvEwLlMtqPk+AVLtuoNmOIGDP8
	/8qlZrvU7n93E7GbLxY404P5MttXnfDMaMP9L7JLrVVIPaaFambkZsLP9mvg419I9ceyrO
	lGyHk791bko/7yh0fQxi2T/2d8HPT2E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Q4YQfrcK;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786655331;
	b=Y8RMDCJBH2LeF0IlG3quaH1y6mUmIITzio8evScQmdi71d3XrF/xu6ttnVThAl5Hjz837/
	cQ7c4pjfq5TQBkp0P7aMTdWzj+YHXauRc0CZMOG1ERxXYG0tSSvB1dvQBCxt5nADwT5e1R
	8fGDn4b9GnXAMhJM9mhN9q1HAo0cj0Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BF70C600AF;
	Thu, 13 Aug 2026 21:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C101F000E9;
	Thu, 13 Aug 2026 21:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786655330;
	bh=+rfmKpCwzQzpk+tikICt/qpBa2ZKmVy8r8vWJfuUcCg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Q4YQfrcKimnxgsOB73ScRTbpcKxqS9TXj9swB6nrtcGomsUhyWVAhPxunMAJam5/i
	 VM/fWzBtR5hmqR7PyhdkKbBQAsZKXRjIBN0HcX2dIobevXbwutiOHCYZ4gootTZ5y8
	 8/Tx2eQfhk2wSP+Pj7O6ZXUKORtKrFHinU03XLRE=
Date: Thu, 13 Aug 2026 14:08:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+237bbeed8dfe0699b7f5@syzkaller.appspotmail.com>
Cc: hannes@cmpxchg.org, jackmanb@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mhocko@suse.com, surenb@google.com,
 syzkaller-bugs@googlegroups.com, vbabka@kernel.org, ziy@nvidia.com, Amery
 Hung <ameryhung@gmail.com>, Martin KaFai Lau <martin.lau@kernel.org>,
 Maciej Fijalkowski <maciej.fijalkowski@intel.com>, netdev@vger.kernel.org,
 bpf@vger.kernel.org
Subject: Re: [syzbot] [mm?] BUG: Bad page state in corrupted
Message-Id: <20260813140849.b8cb508d473a4d47ffed0afb@linux-foundation.org>
In-Reply-To: <6a7d0b01.3668565d.e8814.0017.GAE@google.com>
References: <6a7d0b01.3668565d.e8814.0017.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 415C41C000A
X-Rspamd-Server: rspam07
X-Stat-Signature: r7c7s9iqs81mtdiwps5huqouf4tt3kx6
X-HE-Tag: 1786655331-513628
X-HE-Meta: U2FsdGVkX1/jdBf1Qzj0yknKYs+MhbpAMgXw7jmYh2AeiAlucM4O60ZE140I8LDSEBa6TFYDAlXJ63IkinO66FNMJllZnvAIEsSPpAPuI+vtcx3zKb8OI0nglbU3wF5jjH/w73q4gOpdf7l6Tbaynpq5rMhZTKGoRab1mAOKXvmByaeCEwyjS6QQYubwdLZXViG1Sknav8WzvSoGKY9OEm59LtnsH55ZPUgVaVeVrAYQtun+ywzUoZbDB4QWCwoiNiLRYk/8O4YvBuvDMHdl7VQhGB1mU4XmfmKCUyKm+x3u4M4XJmjX3YPizXCONKGTY9e7KsAvHmeXpNEjklyZ0yj0xvr+bAm/2O6Qui3lYKLWA2pbtjG+n3zz2mf0nIVrpra7TXRArW0Dft1rJ2qjl1t2WC3zTOCR/nzzwjJYPt1uZIYJg/HTyVoUMHz3aHWioVq7ImTjR71lqukaHGZbOI4qVXXH5GldSC8q8hC1lXFtXyVqmsA8ybueKuEtQuSwn1cJH+sGgHtsPKoFYQjE6nUtAkJPEW60JRqLZpLNl7eeZxV28CRNsWDBMyWyd+0PRKnJpHSlgx3YEB+Yn6f+UBLFhqIkw5OMGJ7S6OOsIsIjKjtNE/S6ffIPZSKZaul/9bHuevhrc5ciboBVo3F1f+lyyHaz/cJ9X4xS+5NRa+O3VYzJuB57REQHsT8IhYVikGeSmOd8AX3YPwkl19d3syt0FMqIzWeGNudlwLJSIrb8RYVgsqg6G21ImWKdmBA8ldbMf95XTBF/0eySOSxqcG2IfdYNGUulJxodsulV3Krx0PCBjrvZT5AeBW27rkisYa1BAEKlcP4lPXWeTf048A50gLu90zs9zsEYa6NNasBC5gPwHmgrNtYuq3AFaFdxFcekr4xw9wyDAZMG17EP1zXNUkINKdmGKNPTUmdx1DZlpDnCw2Brjl3+xSGAnZmn/5TYKbaFb0/pSkP59eZ
 izhNeUeJ
 NOVkbppIxP0FD1g0RegRNKuBj0WN5eXR1pI9qJfCny71IsfRHxAqCkqY2S3BpisewxbU+Mln1QBDq1mL5SM6Zk/3L4pUf3ZqR081v/wgwN1yLciixYyMlFq9KVqJ25rID6VmqePOXGVfwtK8FUd0AVSxLaeASUaY/DZmpLXnp4yV93C/riekDnqSQEWZdahOi60/ZPtof4r3iTsqw7aCUUCkM3QpCiypbDP4OE6GPrbpQ50LOddrd6L80faPJv82HrUdpa3yOtzdmPW4WLuKmhiCyJRqPhCAzkzY53wfeKsMksghcJSC8gezHvpqVKizudBXxC5uiC8VnyX2O3qYteHjJ1VXjVkIEnPJS6oeP2xEtJ6N0SgsWYMG0Lmfy2UnZgiwv62IWQAJGdyE9VXud13KSg+MMxZB7Hhr4pHlghjsG0OMDBpIZ0ncyzXgiVJ5YeGUjRCoUnHwCDHCk+rQb99qxWdfOv0UTkwplyDnGQ1f9zfNnaQAeGaBlQhKM+eBWzOv+C4J2z1dc99V5jPqmJatMnAVvk3ZyQeZ4SlHhTLmLP5EMpDiD6zlqsvOh6LN3g7/ZvKhf/qnlDgZYushlXJ+PRwZNXy4vj4rBOuGtzyHb8A/WEADZqomKiyHcblcAR0JGR1XAHiGrKj3R9CgPw936xc+ddWRNFiHGSkyrnVgc/X5OLPF/dqhrMTNk8qAKPd1oA1t7MXDQ18wXzGOoWGVFikiidZOgrEG9Gy37f7kCgUkGM+3pqgHBBLltUYhB26Hf6C2mUfH1qaSfQT9106/tuYsDwKwyP8v0aWpbJ5nyz5dmo0i45CFOviSrYic/czWScnMScRkEudBeZR/Sh88BPPimWINCCCaRalaLOu0mCcIRXVoRfcFMe1BaDpvD6FrswAMqX2F87qZB/qFBBNOU3NHDzh+jmNsAeoNdg9y/fRa3Vhyk0ys4AQy61yoM84zfZ+ik4caCwxCHd0wpcjWk+UQT
 UaSr/tTQ
 hnRobxIjNubIeD/JIJ+ZK14crt1Y2+/qj15jlktHI9utbsj7y0mZRhphiCq/8ILsT5OkY6vl3b2Fz2/U3q2F0Pz+jW5rlFKdFBPmKbZG9boEzospTKiskdls657TrCBCiO5rQtcB4dIs05uH/NITV+RKgups/ahG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Aug 2026 17:08:33 -0700 syzbot <syzbot+237bbeed8dfe0699b7f5@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    ba5cc80fd326 Merge branch 'for-next/core' into for-kernelci
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=14db42c6580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ccf4bea59f67007
> dashboard link: https://syzkaller.appspot.com/bug?extid=237bbeed8dfe0699b7f5
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1690bfb9580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17fc0149580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/959ad5f4e730/disk-ba5cc80f.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/0787d25f251e/vmlinux-ba5cc80f.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/2e85c36fabac/Image-ba5cc80f.gz.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+237bbeed8dfe0699b7f5@syzkaller.appspotmail.com
> 
> BUG: Bad page state in process syz-executor210  pfn:112724

(cc's added)

Thanks.  I asked gemini to triage this and it suggested that
bpf_xdp_shrink_data()'s callee is freeing a page directly via
page_frag_free(), whereas it should have used the page_pool APIs.

	https://gemini.google.com/app/5fde6de04c8e128f

> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff0000d2724480 pfn:0x112724
> flags: 0x5ffc00000000000(node=0|zone=2|lastcpupid=0x7ff)
> raw: 05ffc00000000000 dead000000000040 ffff0000c30e0000 0000000000000000
> raw: ffff0000d2724480 3fffffffffffffff 00000000ffffffff 0000000000000000
> page dumped because: page_pool leak
> Modules linked in:
> CPU: 1 UID: 0 PID: 4718 Comm: syz-executor210 Not tainted syzkaller #0 PREEMPT 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/02/2026
> Call trace:
>  show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
>  __dump_stack+0x30/0x40 lib/dump_stack.c:94
>  dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
>  dump_stack+0x1c/0x28 lib/dump_stack.c:129
>  bad_page+0x194/0x1d0 mm/page_alloc.c:643
>  free_page_is_bad mm/page_alloc.c:1078 [inline]
>  __free_pages_prepare mm/page_alloc.c:1397 [inline]
>  __free_frozen_pages+0xb68/0xbb8 mm/page_alloc.c:2950
>  free_frozen_pages+0x14/0x20 mm/page_alloc.c:2988
>  page_frag_free+0x18c/0x1e0 mm/page_frag_cache.c:169
>  __xdp_return+0x200/0x738 net/core/xdp.c:448
>  bpf_xdp_shrink_data+0x288/0x348 net/core/filter.c:4294
>  bpf_xdp_frags_shrink_tail+0x1c0/0x424 net/core/filter.c:4318
>  ____bpf_xdp_adjust_tail net/core/filter.c:4340 [inline]
>  bpf_xdp_adjust_tail+0x198/0x1dc net/core/filter.c:4333
>  bpf_prog_5d7dc57dfd7f985a+0x38/0x58
>  bpf_dispatcher_xdp_func+0x30/0x44 net/core/filter.c:12027
>  __bpf_prog_run include/linux/filter.h:724 [inline]
>  bpf_prog_run_xdp include/net/xdp.h:696 [inline]
>  bpf_prog_run_generic_xdp+0x4a4/0x11e0 net/core/dev.c:5498
>  netif_receive_generic_xdp net/core/dev.c:5614 [inline]
>  do_xdp_generic+0x97c/0x11e0 net/core/dev.c:5676
>  tun_get_user+0x1e24/0x364c drivers/net/tun.c:1874
>  tun_chr_write_iter+0xfc/0x168 drivers/net/tun.c:2001
>  new_sync_write fs/read_write.c:595 [inline]
>  vfs_write+0x51c/0xa0c fs/read_write.c:687
>  ksys_write+0x12c/0x228 fs/read_write.c:739
>  __do_sys_write fs/read_write.c:750 [inline]
>  __se_sys_write fs/read_write.c:747 [inline]
>  __arm64_sys_write+0x84/0x98 fs/read_write.c:747
>  __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>  invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
>  el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
>  do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
>  el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:738
>  el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:757
>  el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:590
> BUG: Bad page state in process syz-executor210  pfn:113883
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff0000d3883c00 pfn:0x113883
> flags: 0x5ffc00000000000(node=0|zone=2|lastcpupid=0x7ff)
> raw: 05ffc00000000000 dead000000000040 ffff0000c30e0000 0000000000000000
> raw: ffff0000d3883c00 0000000000000001 00000000ffffffff 0000000000000000
> page dumped because: page_pool leak
> Modules linked in:
> CPU: 1 UID: 0 PID: 4718 Comm: syz-executor210 Tainted: G    B               syzkaller #0 PREEMPT 
> Tainted: [B]=BAD_PAGE
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/02/2026
> Call trace:
>  show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
>  __dump_stack+0x30/0x40 lib/dump_stack.c:94
>  dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
>  dump_stack+0x1c/0x28 lib/dump_stack.c:129
>  bad_page+0x194/0x1d0 mm/page_alloc.c:643
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

