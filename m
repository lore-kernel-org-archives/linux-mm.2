Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9A03FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 20:51:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18F226B0088; Mon,  4 May 2026 16:51:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140236B008A; Mon,  4 May 2026 16:51:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055DF6B008C; Mon,  4 May 2026 16:51:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E452D6B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 16:51:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AAFE01602A8
	for <linux-mm@kvack.org>; Mon,  4 May 2026 20:51:04 +0000 (UTC)
X-FDA: 84730932048.14.FFCE6C7
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0CE158000E
	for <linux-mm@kvack.org>; Mon,  4 May 2026 20:51:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of 3tQb5aQkbAPww23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.72 as permitted sender) smtp.mailfrom=3tQb5aQkbAPww23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777927863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=bCjj8G05TtBZLOd7zrH44gm7HPyOQ+hR+PG268x3BGk=;
	b=vs0eLWJ2YCjP2MQRLuLFQVNqmQ+iIWC+VOR5bk6p2kVwZDqcs1NalkraKISKI30rYULyIp
	aHkQaunJ5i/cPBGT0ztrxJJ6EpIxGw5gHrYihnF+eyDcCCqsF4TlJ54N4nbTmtI93E0uo1
	pH6zRwlfN62wrctleqLAnW9ACTRrDGg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of 3tQb5aQkbAPww23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.72 as permitted sender) smtp.mailfrom=3tQb5aQkbAPww23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777927863; a=rsa-sha256;
	cv=none;
	b=6ZJjr5zymSaWULI6vSFycXekl4Yryppx+xkufN6Ligms8dnoZaSZkFaFn+rlkOkRt5T4e6
	nsetoqIXhKRnB6NrCm0OEU60or2CC10+DMYcUS6lO47D36gwduOIzc17aTOoZ44wVoopE9
	zz/kwa9mVClJh3wcJfIQBRbh9Pl2etk=
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-415e1e9aa5dso7196533fac.0
        for <linux-mm@kvack.org>; Mon, 04 May 2026 13:51:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777927862; x=1778532662;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bCjj8G05TtBZLOd7zrH44gm7HPyOQ+hR+PG268x3BGk=;
        b=iAZ4dyM2V/AUM3JIfdDmX75diULoUAuVByWZUn6CjLPnlHCyNiDyi1J1l9Bw8PsyjJ
         oS/oPAArjUyAanJZt5aV7Tp8xJ23d+XON7yrkrvgKM9R7CBQjy2rQpBs4amZRJp3CBHV
         8/ztXggSuzTxavhCR4x39ykXQ+lpDqAl7HYfheptsxHaSAVpgI6tcWO+AYBEGI/W8I1d
         qusSnDf1HapNIuocTX8TQHrQZ6GQ2TjkO13WNzxYt5EbS8T7dN2nxkE/vI+HuYg1yD0M
         hF6OYW+Uo/cgF0wtdmSIbxhgLuLtqYK0qyZ0Rzk7rBFYPKfLb1cGNwcUGLUmVd78zb8n
         rHOw==
X-Forwarded-Encrypted: i=1; AFNElJ8m4KLIV6mQLaqohLwSaEq5yZ14EQsPd/UQs65R3j+99RaBKlG+Yyv8F5v2EnqQqmBXeywkTA5D2g==@kvack.org
X-Gm-Message-State: AOJu0YzXBDksxLQQ96Rtbp9NivKCq5NaBOV9XUL00G9Wi/XSx7XXgWqQ
	ZnmcEFFfnNNKm+xFzcAYjCLz5RA3m/WB+3gjSh5xp6vZ0sLkWiMKgQT/k4Malaiq6ofz1URStrb
	uSvR3u6u5eniErDYPUQnRBKGzfnsoGo862h1B2DaWtZ6HepXIVOJJM8RfQmM=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:60f:b0:696:8c3f:d7d8 with SMTP id
 006d021491bc7-6998d225e63mr109559eaf.37.1777927861903; Mon, 04 May 2026
 13:51:01 -0700 (PDT)
Date: Mon, 04 May 2026 13:51:01 -0700
In-Reply-To: <2956b248-c79f-4eae-8bfc-81178b5899af@dev.snart.me>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f906b5.050a0220.892e9.00d7.GAE@google.com>
Subject: Re: [syzbot] [mm?] [exfat?] [f2fs?] memory leak in __kfree_rcu_sheaf
From: syzbot <syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com>
To: dxdt@dev.snart.me, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CE158000E
X-Rspamd-Server: rspam06
X-Stat-Signature: ajwzdwkhu67kjjykihfe5zrhim6uaei1
X-HE-Tag: 1777927862-662111
X-HE-Meta: U2FsdGVkX1+vuDa81UTZWrQ28uC7cmRMJD9H3rUeuDL1OnSYnkoQVAu5GqqFeL955/pbrFVgFycqZ6CPyOZ51LlshhRRd0jFO6F2aFTQwFibjG6vSuETLpOUGhS+qNGVteQ/0dHKUnRwvn9XsfdAcXjZtQRKPh4cVmv7ACJG8sdok3bwQdxnepImQ7Pboqp8zoZNqcUZSpbZvB1O2KeafHvYzLiGFiqQEXHkQ+oEVXLfqoNJmWi42HMG84YPuiZ+z6H+QrKQ5CXGX8jVE3U28XqQi+2DG+eOX7b0QajSMuGUiFtzdDM3AbdTgK7C67GfjE+TeTHungEJ/IYS8twqkZ2XTqjFQWZB4iHpSkG+ATlk+q+pmm5AoghFrKJsj1yFSkPs6fDoMFzbJj3oosw7aXWlaNRUDr4h5eWwYG1p3pq+cmNupU6tqV5fNcgET/IIgVUlqHCWLSvzoxF4A05pqZoFN3dnGwrD5w/bBlcnKK4uUAjVBQA0gFyY8M5k0lhOC1NLJ/8z82Ib+cMIxN7w6Zjrpr0OzDPxFePTkZd63EzDAL9PmMvrSoxmnLB4ZKicKIX6HhMTnaJ1u2YHbsTi9AoJlC/3X8H1J4M1SsKdxOyx90vsCHPUyKNE7rLsszq2q/naUxCxHJ8lnxLM/mobZC/K5jQGSmb+KKPN5LJjJFpFaDentzth6hoAfZ7UUwQ6jp+F+abY1poOJ0VjkA60+Hj/t8dcucILBcm6aczZTG+1OvYr966t+ft/yRlSAWcdkkz0mIvqDTS2hT5VPb/UvWQsde8ulUQu16lZpbDaFBdUrB86i+uekINo2RNl9qyLhbr6qOw321EZHVSmW5rGdhBt0URV5UE99A6CtcpWAc9rQBw9KTKPoWq+NnaoqmimBiWXMn1mT6BREOX5VbfNqzIhPRU+mej/XdQtvx6wD7R5pW3GeNjWnXjkP9e5qj3PjUnabyDDKgGLS5WU1Ov
 b9Y1DSNv
 bIvcAoP1le15bFda00DyImUBQuReJODNK+BH880md1DSvHlfq0k3M3sFXcP0I6awxWvYpInJyinHyHN1USVbAXnaF2OHLOQiU/3KmGK+lZsf+6rPzNz27iZkEVx7FqJvytBNWWRXNhQ/CLqAiphd9DcS1Po0NQ27pnjcq87XZdg8L+MovL3kwu0L0k+8IcudY6fKS5CpSkVN1DMa7TdDT59dp9NiLcfOdB1uq/GUCnkpEwvLQNsrREOcq1Ncx/w3GZ2eXYoZ3AEsdjwM5040zzgDp+EWmq5GZBc+G7xi8FDTeJWUTbRJ/HOdfTpP84Qm0/BM5kfUrzLSSGNx9hgH1110PGj0evMCofnUKW+aUnKjwTEOoG+OmqF3lGC+9Y1nf1L2b8MLzvXZ6pzGUq1y3PtfTH/y9KEhqUruDRfjZkoxR4O2CGSbJL6gBlw2Fq3ZMSU6BBzlXugrPib5Wgw6IG63Cp7zlqZ5n0QaGudGgAC1axA6PmB1jsJZUr3CaXR63+K2Qcd4Jg3t51YD5/zwGzWi5LvRewZsOubKAA2ZCHRxa36vC9j/atVpDIH7ZBAdCwJtZmgxQc/y+k0mzjGAxsZ1MvS4Tcedg21U3up/Sn3TPGyhzLPZg7W6y9f36xf5HJ1HW7OKDgU7R5UBztnRJrXmr6m/aij9WDDKDCV/xa8HPEII5xZtUaL7GE8YE8XcyY4zE2zyDHdNQQOyz9QYNJiO4HuWIt9eSBx+vKiXpc3fBU8CxH5c4rVyb9NytQ/4zgsyg65sFrLAb5sADIRrQ/VZqGV1H3ZqJYKTQdvlN92gPSaos1JhmtcaJn4xSXJdIwIwzpz0cldHp03RRoMuTXrhLY24PiK7oyivHVHSDmEwXpHE8EkZdr1cjDH+Y4qYkfCAL6rTyn2+5+o2o/EUKQArM3FezjZANMOhKy+PXtZ8bgFTRl2hALngbwoZrwG/xn1VQ/WPH5uavsHyib3iqN5EPpQq8
 VEO2ziDA
 66CbFGoRelzb9HyWwXuCWu4z0d75S2vWgTeXmzcwYKJdJ0JOldKPwRh+uUYCJKaR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
kernel panic: !!! sbi at ADDR used after freeing !!!

F2FS-fs (loop1): f2fs_record_error_work()
Kernel panic - not syncing: !!! sbi at ffff888129322000 used after freeing !!!
CPU: 1 UID: 0 PID: 6598 Comm: kworker/1:5 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Workqueue: events f2fs_record_error_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x97/0xe0 lib/dump_stack.c:120
 vpanic+0x383/0x6d0 kernel/panic.c:650
 panic+0x6e/0x70 kernel/panic.c:787
 f2fs_record_error_work.cold+0x14/0x14 fs/f2fs/super.c:4747
 process_one_work+0x277/0x5b0 kernel/workqueue.c:3302
 process_scheduled_works kernel/workqueue.c:3385 [inline]
 worker_thread+0x255/0x4a0 kernel/workqueue.c:3466
 kthread+0x14e/0x1a0 kernel/kthread.c:436
 ret_from_fork+0x219/0x490 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Kernel Offset: disabled


Tested on:

commit:         6d35786d Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17a63a36580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9645c21cfd1d3e8f
dashboard link: https://syzkaller.appspot.com/bug?extid=cae7809e9dc1459e4e63
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=172b8ad2580000


