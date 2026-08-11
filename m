Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2F56C5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 00:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FC746B008C; Mon, 10 Aug 2026 20:48:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D41E6B0092; Mon, 10 Aug 2026 20:48:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C39E6B0093; Mon, 10 Aug 2026 20:48:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 314236B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 20:48:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AAB4A1C0B98
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:48:56 +0000 (UTC)
X-FDA: 85087153872.28.07E9319
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 67C4F100002
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:48:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="QsjsG/IQ";
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786409334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ULPNoA98k1MGbNwPUHP+7eh68YMauJgzPpcaDil/e2k=;
	b=Ogne5zPy0WLhnWSEi0lxMMtvCcOsk7V30FB9GUtS0EZB+fDSAaBL1eqsUY4/ccOhps8RHN
	hIbD0lKhui4cbSAj6bf6lzfoSjdEZ5x20jJbzAGoG80T2t2j4oQ5yKWcd7FfRvc85X+4LK
	qCxmMdkRIQly5oOdhkkeDBbVgAnpXXM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="QsjsG/IQ";
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786409335;
	b=w9XvoNK/Jo+dQRBYjl7Rvbchr3MP1oqluCQoznQ1pp3EAh7cXEJnP74lVdFz1/8VvFqvap
	/gJGxdsFrK8SBV3UhlCWL/jD2YmVmuh8L8sqKdM+IjJ+14BJ4W7C+9AixEtLo3SuUvTFvI
	hZTHW+/H0+lupGWgibstLrz4fHr4T7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 746D440BDA;
	Tue, 11 Aug 2026 00:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF14C1F000E9;
	Tue, 11 Aug 2026 00:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786409333;
	bh=ULPNoA98k1MGbNwPUHP+7eh68YMauJgzPpcaDil/e2k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QsjsG/IQ4QSsXLetYPhTu56p5S/IkYcP6MgBGAePoP38AQwk3upCTYKfqXaZhndxS
	 FxhCbJRXJ5Eg0w0fIF8Yyet+OHPjffGrUDQrwDEsYy+CO52zsI95M+zlioimW4qz10
	 7K89jETg9le3bGYk7OweqtTmGoM21SxB4YHKVrLI=
Date: Mon, 10 Aug 2026 17:48:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com>
Cc: axelrasmussen@google.com, baohua@kernel.org, david@kernel.org,
 hannes@cmpxchg.org, kasong@tencent.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, syzkaller-bugs@googlegroups.com,
 weixugc@google.com, yuanchu@google.com. R:      Kairui Song
 <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>
Subject: Re: [syzbot] [mm?] WARNING in set_mm_walk
Message-Id: <20260810174852.aca0f73ab7ad71c70dcdefda@linux-foundation.org>
In-Reply-To: <6a7a6929.b50370da.49fe0.005e.GAE@google.com>
References: <6a7a6929.b50370da.49fe0.005e.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 67C4F100002
X-Stat-Signature: 5be57s788o97iwhggk6fag5ndcjct6ey
X-Rspam-User: 
X-HE-Tag: 1786409334-860114
X-HE-Meta: U2FsdGVkX1/XVziELgTbOi58k2NPt+5cI49NKTxrrucKYBvs5dxpNAGCp0nluzVKVa1XPoSNKCTD8y41n+B4ZnY7Xhl7B77fy4OpKV/RHX7L+8EBrBqgtTil54SA6NzoXBTxO9Vsbw+rgUSRrhKwxpFY234SUCk8LSvgn65/u2SBE+HR+wD6NSdVFhHvlEIRhoz1bTjOX1hBjBtYji3IA2aT21nBegfbISrgTHi+Cd4i6gKFLtSUT+SNnuIptogVq4tzeoZQ/M01C4DJKf7Sys9CwD4BSzlXONPM8AOspqrgmP51E6e4EZs6Rb9n0zlolMWezyS2yO7HjEDEyQkyIUePNHjNv4ae9SY6ldtSGbj8sBKr+pobFiB6r5GNqcrlFM9tFYa/OwZ6a7Q28unxkNt5uFMPn1qaG2FSAVSELl56/Mtbnnbqo0H9OmP2NgnwK66sZPvdFx7nysf4M44yGkuHjoJc9CdjylWVv5AEf4HTytUfjY4FHeg9CIkQ1oyr+enk12CBZHlJg5CS+bQoxJzFzrY18qsZhZ7TP3wpd8Cqvaczj+fXjwNV5Eezb6kAbjJDJcqNvvJ8ls4IXy+825O87/QMdewT71U7/ROXOZQ0AKXyNIZyyRkvh92kjh8v2Ieyf2MIL27Sxjb61fjz5Z7JSwoqNt4jkn4R+xN9zyVXZVYAjpk1uoYXIaobEdgRSmhkkL3Yb8HFNGQWRvfvglrgpzxmDDf1r35jYkVEarfz7zjan6BcymHsPH6LWdsZggxW9y5nNsUkbjZ9SuNwosXWs2YeTW97umMn2+6Q1viAkcpgDLOFYDfAgCcjC85+dkXfkVA6ZQhqbMR3g8tI35FwH2GX551JPAIYFfFq4Astjq6a/m+woN8TPNxPnaPF+j3vTvATKua91P873YjWpApLIwdZnOfsdTV0Y6ztnbRyiTxpkJ94J0G+y+XNkpar+qASQeb2zBEvRnb69WT
 RgQ3NeQf
 gPny+5qgp5ta78VV2OaE4+CxIYEm/SoemVDGtPnLqjq6KpGHySY65SFJbyOfP1ogM/TV/kUmEUxC4DehmlBCK9TWBMG6fUSw9m5W3kDCWVSaAgfvvshCx7Rekb7W9/P/48qBc4Z59WRLWVZ2QcOUDXt3mdbIpuPJ0kQNYDq99KAC14Sr2++wZhjmnm7jFMfRGh8GwolcOdrK4Knaeh9Ny2JjQm182lMj0nNfevHWF8wZEJSW501sG/szOfvb1hkrXPOxQLIQASOJdB1h7b2Oi1knhOqt/BCZ2DEjGL9fbF1yWNsl5enTLwSTDzucKBkHe80tXiWPKQkt6m+aFV6AOK+6chTTZLd+PZC/5N5UKf0HV93DEOtOqudQhO4N1s6cz3lWBWTBVso9YYcvtElQMwj38nNvAvVLcnyNW8hdKzlgRZayvH8EUJwMArtHAcq+X2NJb5GH87uZztg/DlN/rwfJEAJCGqusDtV6fxDFknx+h+D0XZIoOEhZqqiUxTS0gxr5/696CQyA+G/0sc/R/itOxsxKdNsIaW/5lysHG2aOU9znHIH/iyqZnD+ny0QPP2tUvL0LKNeQoOgbzigKAs9iEwwVT/QFjEnCYNEfU8Shz3mMOqVb9DXdtNHx3j0HN/tcY/vaymlBCj9h1iMdl/yao8ZBqu7tUGOGwBPxNay/jrtJ2Hpl0n0yx4eG4I+qBjYbgrXE7TQfWnY8gQKjEdDmnLPQXLI1gstp7HoxGI797buhVUng1jBmFlom2ULMyZGLiVIu6CbOUbzxTMqT4Rc+neVYo1atW0+uV+9Vjxuju/FU9eAKtK5FkF5QoILjXj68i418dW7TITkDmYD/9F/++PoB57uz7ZSOzTFyZCBtjV+CxoIruUUrVdKKUohWixqgnQeEoCASjWe6s1tXaAUaG16GDSaOklfM4XaiDrJNq6x+lcxQPNu7Oz/8Vu/ArhjpHKu6zH1w/0iTx/AlecSNGPI0/
 vlWCo6Ww
 bz+zaTR7ANTY0T1iprjrr9gkkkGO02Uk498cxXfpJAFIiqpOy7G0X/UCPd+q/6jO6U7H2WniZWj7phgq9cggdvPcA8/n9ZFuXg3d1+F6gb5VeHjpnUimFS2aAekqkY7jIeOWP9kffHz6cDIJxpMjherrGIJ5HLM0I+uleaWSV33rPM1JDyA6RU7GfotPKUsyraafn1qa6kSSCFaXBbcTcNIwGbXYf+VY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Aug 2026 17:13:29 -0700 syzbot <syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    562bfb501c54 Merge tag 'integrity-v7.2-rc7' of git://git.k..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11a8cbb9580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=145fa60d73086782
> dashboard link: https://syzkaller.appspot.com/bug?extid=12ee2725d5fde63a9c96
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Thanks.  One for the MGLRU develoeprs, it seems.

https://share.gemini.google/Wg4a5ns7E0LF might save a bit of time figuring this out.

> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-562bfb50.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/9cbf6ef0490e/vmlinux-562bfb50.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/7ee52864c79a/bzImage-562bfb50.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> current_is_kswapd()
> WARNING: mm/vmscan.c:3800 at set_mm_walk+0x210/0x270 mm/vmscan.c:3800, CPU#1: kswapd0/110
>
> Modules linked in:
> CPU: 1 UID: 0 PID: 110 Comm: kswapd0 Tainted: G             L      syzkaller #0 PREEMPT(full) 
> Tainted: [L]=SOFTLOCKUP
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> RIP: 0010:set_mm_walk+0x210/0x270 mm/vmscan.c:3800
> Code: 13 00 00 4d 8d 7d 08 e9 f7 fe ff ff e8 79 f5 2a 00 e9 b7 fe ff ff e8 7f 6b ba ff 90 0f 0b 90 e9 d2 fe ff ff e8 71 6b ba ff 90 <0f> 0b 90 e9 74 ff ff ff 4c 89 ff e8 80 f5 2a 00 e9 4e fe ff ff 48
> RSP: 0018:ffffc900027772b8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff888024934a80 RCX: ffffffff824ff8e8
> RDX: ffff888024934a80 RSI: ffffffff824ff96f RDI: ffff888024934a80
> RBP: 0000000000020000 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000020000 R11: 0000000000000000 R12: 0000000000000000
> R13: ffffc90002777c38 R14: 0000000000000001 R15: ffffc90002777c40
> FS:  0000000000000000(0000) GS:ffff8880d5ed8000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b31923ffc CR3: 0000000109695000 CR4: 0000000000352ef0
> DR0: 0000000000000005 DR1: 0000000000000005 DR2: 0000000020040004
> DR3: 0000000000000056 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  try_to_inc_max_seq+0xf0/0x1090 mm/vmscan.c:4023
>  try_to_shrink_lruvec+0x4bd/0x6b0 mm/vmscan.c:4977
>  lru_gen_shrink_lruvec mm/vmscan.c:5128 [inline]
>  shrink_lruvec+0x31e/0x25b0 mm/vmscan.c:5888
>  mem_cgroup_shrink_node+0x227/0x6a0 mm/vmscan.c:6753
>  mem_cgroup_soft_reclaim mm/memcontrol-v1.c:312 [inline]
>  memcg1_soft_limit_reclaim+0x2d5/0x830 mm/memcontrol-v1.c:362
>  balance_pgdat+0xa11/0x1f00 mm/vmscan.c:7177
>  kswapd+0x556/0xb50 mm/vmscan.c:7462
>  kthread+0x370/0x450 kernel/kthread.c:436
>  ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
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
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

