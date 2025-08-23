Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A84DACA0EFC
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 01:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C90A86B00ED; Fri, 22 Aug 2025 21:16:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3A4A6B00EE; Fri, 22 Aug 2025 21:16:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B500A6B00EF; Fri, 22 Aug 2025 21:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A14556B00ED
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 21:16:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E8098313D
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 01:16:57 +0000 (UTC)
X-FDA: 83806258074.27.91B8B54
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6C991140007
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 01:16:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OnCzMbG8;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755911815; a=rsa-sha256;
	cv=none;
	b=H5ck1W6ZgSiDYlrZc5wnjMTeyxYsQpmCCTGM9+BnELHuRYDRnZONexkPa5yYjPlaPDngMp
	9/BZzs2sWYnjTZx0ZT5Fpz4L4mY75cjnJISdc6EZzd123oZhaPXVRS76wbABZj9T/fwSqo
	KL1bjGpcrl6VEEwW9FLnDThzYmDWsKM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OnCzMbG8;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755911815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OQbT4ztkuLRoeO8WYj9qYFZuXrUY5bYLAD9gagJjSB8=;
	b=iHJJdurm/D6uVb7nP0+W5F3AcD2rfoCzRgjsYd92GX5OMQyU7eLRmYB3SG86TroJjcuJ3a
	l96pSdD3l/ZHyy29zhTBgBMzC8I3G6/EOfiih7LK4dzZ2+FgilX0WyrGpdOGWaRBEdCjhA
	kv1AVylVZ2W2MbvrphcDtA48tHI5f3s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 650B75C02B0;
	Sat, 23 Aug 2025 01:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFFCC4CEED;
	Sat, 23 Aug 2025 01:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755911814;
	bh=rfoy8dUwVIazm6d2GUzv32yXVdoTMdUG6m95Bx7lLD4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OnCzMbG8BtPUs5b7VgQBWOaxM9mYQLdnuvEtBt5p69Z+QYGc0QnWZHVbikSJ1455z
	 reI6IDL2IFI5hbKcDqyxgzY+gmbD9A6ihJ8o6kMgi7ISKmVGt8Yi8ojcBK5PUvOvtw
	 DHq+SPW8KSTwsJRAmk2MQKh1qOfmHQ9PLas+3Rlc=
Date: Fri, 22 Aug 2025 18:16:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 pasha.tatashin@soleen.com, syzkaller-bugs@googlegroups.com, Andrew
 Donnellan <ajd@linux.ibm.com>
Subject: Re: [syzbot] [mm?] kernel BUG in page_table_check_set
Message-Id: <20250822181653.cd2024360870ef94cdb7db07@linux-foundation.org>
In-Reply-To: <68a7ef20.050a0220.37038e.004d.GAE@google.com>
References: <68a7ef20.050a0220.37038e.004d.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6C991140007
X-Stat-Signature: zddxy84buxdeccyon5pxz1fe4xputsdz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755911815-508458
X-HE-Meta: U2FsdGVkX196IIQ0YS8FNeFkuquE/R4wUC5mSf6sy3wsVajm3PZjcFvxcnJyxQbSD04lkZuNx3fMFKnCDTXhwxqUeq0dEnC5qW+Wxm/u3wfy+IfFyHVoZaUUcYFoxpTZrWCXfVpkEQ03du8F/ydqS/N+TM0GbRVGnRhtp/X7mawbohoMrpLEiw5QCNQkPjZTe5JRnkQMw2S9BTmX6aMJCoMHHUDuDtAz/+n1hz0bdoVwc3bwmG/znGYdgIaLlZtJ6ohcSQJM0VnXRSNogguu8Vfi3FdRWKPt5RRoynEBvhMq10fzPwXRj1eGCzv74NTrZcYcm/Y5BiX9dxLzTmBbdArXupYHgn72+KXTeHDuI6Bb82qRQAEL+vXQe4gyzHJ8EVK7n52L0Ji/ouUZsJK6SZddD/Le7R3w8r/AmbwCJGsLGwWk9nWuHe3EHtBIJqK1OJ9oZKGTL4gSQKhMv8ukuRqzZeL0Y2cad/OMUMTFQFVK3ywKsf5flwft1luEjBdPk0PDISgAQ1OxTmFQN8xaa5h3EtRRLtnlNcpQIjblVZU6tcS2zwQocOWAcNscejDuLsbmXQlJD22MC4wHA+YEnTT/sFvHrKo63j8TR07vicdFJDf+zjv3G8OAaX3yREaxv9aA+Q8TuuPHtIzFfvo1m6ZiPpoLArJbtBdiuzSoHPMTXsDmnYxjliCrFda+QRfknxkxciCxasz9Y8p6zxGOzkohf0k7QQT3uzcPQ9eii+hCefSsRArsm/mXRxNQSMeRg+HuGYsvTjE8LTiLlFrHQrLNfIpiyLEKXF8mHEQ5UZkFgNElJTba44zFuQAN4U4CQBHJk5NuBMLb9I100dEx45aLQxE1U8d/w4bEvcvk7zdOtEE3fU4F0SkGB2rbviyoKnaDArOKlJ0V5xgFvFMtitWhbqo/CNlrOqUcH2oej63s9usMquNjFWXlb5MUFdGzz+ySNcU9jVhjuphZ+1W
 nZlyh13I
 CrxKCofp4FM7vfHcUcKIQPOUIKl4Zk3Oa3RnJkIs8wv1XNoSIM+4BmqoyuGw2rqEM3gYKp6/UFAl6msQXIgn7IBzjL3DImIuRTHcF3q8V+9TQJv601j97YnKqPrndSES/e87jX0FHuySroeAbSotHtGPUVf5yigbzS7gCMD/3KYNkQem/wn1Fq39op33GHO9ayW6wDLJTjaCicg+O5FwgmUEbq0EcKIw9CqmdzxGsFEXn/2l9WhLpT+89+1E1S9NMQsK8VFva7BIh9jfXua+C+5Vq8Pg/z4fIeEFJfbJlxSekkZaLnNT5ZXLs59hnOSr8Xk0na26rVfeU/ul8m87IsQMvdj6+n2RwWZzbRcgPqDC3B0kYktRp4oAiwo5w70SGu/0WDvD4QD0LfoJeiaMS4kVCvMTN/1PbDNfmrfonLIBe7TzI6OxkFXCzlsxJk+X5pQdoXy2sdgxvgI7/kJ8vqzxMXbae7o2nhcl9plm2PKs3Jm9MT6nVV+m4SpipzKqO5mmjxVpCE6k7eWrD21AhKAx//ndBnan3/haF0nGPoPjcOHz4vSxOVBOaGNAgZwoM8Ym37/DZyMNW3mHDIyA/5DCEJG76w9jljKtOCFZv7XxAo1r0bqqUoyj4frQnIQvOXW7qhfxbv1SNb/nMkmRYZivtb4RNSB1dMhEoEfrtB/V6C5HxnlkGtcBbyS7yOHMatRQFzEx5WPso7E0OiOakyNMf58U2AOP409ipJOPjQsXcEzrfLohWT3pj1yYN6fatX6VyCYKVTN4BXm6JqxVvbD46CHjzFBfg/9gOEx2Wi4y+7xjBNbpoo6jsMTz+9LGCKLGJhRFny44Xu0pCS0e94vnP5StLITuovuRCMaL5zYDBaUiKyJf/6y+w8YQBJRyMe9inZmh8goRrUc3M9MIuVV83IItE/+ySmPyR9LPne+xEGxXg9TZU2woI91rHIXybE+nOo8HzyPjMO5H/HBbQhCS66Yza
 XYjQlZ8y
 v4C8uBhDm6GcenMqj7u7oUeLZwmHU6nrvS7ZbGFD6WFXkSbWDnDUdgP5P/jFmi9QLVguxuoO/oGP9bzFC9mQ1xw0PraFjtgGULBaGM7GMemKwqYq4QtPav/PEsQw8Pr4MC9rIWKETZ0gHFRvL9I6ng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 21:16:32 -0700 syzbot <syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=15f926f0580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
> dashboard link: https://syzkaller.appspot.com/bug?extid=49a796ed2c9709652f1e
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15faa7a2580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144143bc580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/disk-8f5ae30d.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinux-8f5ae30d.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/Image-8f5ae30d.gz.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> kernel BUG at mm/page_table_check.c:118!

Thanks.

Presumably due to the series "Support page table check on PowerPC". 
Andrew, could you please take a look?

The series has been in mm.git for a week so I guess the impact of this
is small.  I won't drop it at this time, but prompt attention would be
appreciated.

> Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> Modules linked in:
> CPU: 1 UID: 0 PID: 6740 Comm: syz.0.17 Not tainted 6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
> pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
> pc : page_table_check_set+0x584/0x590 mm/page_table_check.c:118
> lr : page_table_check_set+0x584/0x590 mm/page_table_check.c:118
> sp : ffff80009c9674c0
> x29: ffff80009c9674d0 x28: ffff80008fae0000 x27: 0000000000000002
> x26: ffff0000c079ca80 x25: 0000000000000001 x24: 0000000000000001
> x23: ffff0000c079ca80 x22: 000000000012b950 x21: 0000000000000001
> x20: 0000000000000003 x19: 1ffff00012eb65b0 x18: 0000000000000000
> x17: 0000000000000000 x16: ffff800080528a28 x15: 0000000000000001
> x14: 1fffe000180f3950 x13: 0000000000000000 x12: 0000000000000000
> x11: ffff6000180f3951 x10: 0000000000ff0100 x9 : 0000000000000000
> x8 : ffff0000cdb05b80 x7 : ffff800080d16554 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff800080d15b5c
> x2 : 0000000000000001 x1 : 0000000000000002 x0 : 0000000000000001
> Call trace:
>  page_table_check_set+0x584/0x590 mm/page_table_check.c:118 (P)
>  __page_table_check_ptes_set+0x2a8/0x2e0 mm/page_table_check.c:209
>  page_table_check_ptes_set include/linux/page_table_check.h:76 [inline]
>  __set_ptes_anysz arch/arm64/include/asm/pgtable.h:709 [inline]
>  __set_ptes+0x4a0/0x504 arch/arm64/include/asm/pgtable.h:741
>  contpte_set_ptes+0x120/0x188 arch/arm64/mm/contpte.c:464
>  set_ptes arch/arm64/include/asm/pgtable.h:1794 [inline]
>  modify_prot_commit_ptes+0x4e4/0x694 arch/arm64/mm/mmu.c:1556
>  prot_commit_flush_ptes mm/mprotect.c:197 [inline]
>  commit_anon_folio_batch mm/mprotect.c:246 [inline]
>  set_write_prot_commit_flush_ptes mm/mprotect.c:273 [inline]
>  change_pte_range mm/mprotect.c:354 [inline]
>  change_pmd_range mm/mprotect.c:570 [inline]
>  change_pud_range mm/mprotect.c:633 [inline]
>  change_p4d_range mm/mprotect.c:659 [inline]
>  change_protection_range mm/mprotect.c:687 [inline]
>  change_protection+0x1e84/0x3ff0 mm/mprotect.c:721
>  mprotect_fixup+0x504/0x744 mm/mprotect.c:837
>  do_mprotect_pkey+0x864/0xb30 mm/mprotect.c:993
>  __do_sys_mprotect mm/mprotect.c:1014 [inline]
>  __se_sys_mprotect mm/mprotect.c:1011 [inline]
>  __arm64_sys_mprotect+0x80/0x98 mm/mprotect.c:1011
>  __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>  invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
>  el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
>  do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
>  el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
>  el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
>  el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
> Code: d4210000 97e865fd d4210000 97e865fb (d4210000) 
> ---[ end trace 0000000000000000 ]---
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

