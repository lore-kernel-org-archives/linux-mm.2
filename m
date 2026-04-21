Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17A2DF8FA73
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 13:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36AA56B0088; Tue, 21 Apr 2026 09:30:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F50A6B0089; Tue, 21 Apr 2026 09:30:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD076B008A; Tue, 21 Apr 2026 09:30:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 072766B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:30:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A083C13C339
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:30:52 +0000 (UTC)
X-FDA: 84682648344.04.6691590
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2D35A4001E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:30:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=C6T96D3h;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=n2WUAtR4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BdkAPFh1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RvmRJOdC;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776778250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UHY3DhG/PGppNI2DHaG+4zPgwezdbdcDkTtshzKqt0U=;
	b=Hf14DySpOAJtp9/mhucVW56xdkV8Mtg6D4KLMvwGRYUnyHtOzOBe+BJU5tFsubZ2fqFdpX
	9A2NTJKPJOfg9p3nJD64kXr1kUbSnq1V7MENfQvZLz5GTuS+WuJCbvA5f7KAqkshIlzq6c
	OOfC9qnQ95eznCsD6kRi6IrUTlqwR4Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776778250; a=rsa-sha256;
	cv=none;
	b=l2wKLu2Bmkdmdx/hutEL+dHtcmzgzAx0QWjyhfiUXRsWNlevctPQk52IXEoDq+tOTsCTjC
	gxFmhQTMCXgjcY1cpFbXVviWiz2tl1fLL7v1kIA7ZGlNzAEqju8p2K0wsojsyrkKTxjjV2
	0OrIdJm9q1JY3FB+fQKhNlyTljlWouw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=C6T96D3h;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=n2WUAtR4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BdkAPFh1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RvmRJOdC;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4CC8A6A8E7;
	Tue, 21 Apr 2026 13:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776778247; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UHY3DhG/PGppNI2DHaG+4zPgwezdbdcDkTtshzKqt0U=;
	b=C6T96D3hZvX0V2hGk94OIpFM4xYiHwuXuodoA0vSuDd9ExA/gpUGDQMPRMcVN/L5MIye4k
	pQPXIsi8tcJkkd06DFxsAjjoD7PedYkzigpFbbhlV5i/p5Xc9awk90GkiwomDGOCU6inSP
	H8LU/5q2N3QZX/Dx3v088/VeRIsBg+k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776778247;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UHY3DhG/PGppNI2DHaG+4zPgwezdbdcDkTtshzKqt0U=;
	b=n2WUAtR4pnt2jJy7cvObtZUnncaCyEVDu2gJU+IkXAzEQqAEHeBC0ZSKV2dVu8KJiJJZ7K
	eeEfzlsxKPYc41Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776778246; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UHY3DhG/PGppNI2DHaG+4zPgwezdbdcDkTtshzKqt0U=;
	b=BdkAPFh1Tao8QwRcgJd8osFBjMgRyqw80xjtsYeUoPMnI/0+lXvOWU5yTON9f+w/cFyxB1
	Iz0+Tuq7UST0VxVE9IioWz97QRj+rBG8PrpcSzZ6SIfZfk/AQELo9BW4j4zV9gO3pzrQUq
	YWDvILqkJhOtUemefhmrM0KI5M+PlPc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776778246;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UHY3DhG/PGppNI2DHaG+4zPgwezdbdcDkTtshzKqt0U=;
	b=RvmRJOdCU2IF/CQYQOtT4aSFTHjimhR6UDl0fUzpobmOR1fWrmuYe1waPoQraNwTRbZZgW
	EpmRHUvWRDwZdWAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A09CF593AF;
	Tue, 21 Apr 2026 13:30:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CGKtIwV852kIEgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 21 Apr 2026 13:30:45 +0000
Date: Tue, 21 Apr 2026 14:30:43 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: syzbot <syzbot+4cc5bc01fb4a179c4ffa@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Subject: Re: [syzbot] [mm?] BUG: sleeping function called from invalid
 context in __zap_vma_range
Message-ID: <tq37r4njepyw3gmrihclvqzus5cvpmepvyrjhggb3wpv7cnsmy@naeba6ofwutx>
References: <69e69c55.050a0220.24bfd3.002a.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69e69c55.050a0220.24bfd3.002a.GAE@google.com>
X-Rspamd-Action: no action
X-Stat-Signature: af5wdsfa4tyuhg9swrw7fzcjsri34tmd
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2D35A4001E
X-Rspam-User: 
X-HE-Tag: 1776778249-689266
X-HE-Meta: U2FsdGVkX1+OdQeU0o5z0oxOSWA8sFDqMBTHNE2U8I2avLta+lwqSR01ZlNlwSYpZI942tX8HYTJUNmDRywCEz8LQTZTXUtW4kcimB8Hwaabt35p5OwAipzBEsK89cSWOQZFT0nJ9jzRpxkk3bZmRQcDJDcES04zfBRn/WNBTlRec4P6y/l2b3nLTWo9brqLg1KXPv7L7fNM4enV73+ju3yUWicEbEeZi06ibXhw8aqYjo4V9nAzllm+0OXJVprP7w267tOP8NNoJUQ1xXd27YqFctw94cb3qr4FAeyhpDR7xpbkYoKwkOBdAiH1Aj+KU5u9XuDipI2cqEENzNJoDe67XY+0lYaMf2+ezvxV9cSbhh9PRD7FQnHgO/Gn66r6Sl6T1B3DYra+jOUwfnrY7n3Wti6bA31oWVDPVMpevKsM2SMwHpKns6lIz218duqKFq+0jc3Ic9cxeyhoWpUdoTfdQlwpyyD1vPCxBrLWL/l6gcOx7RfASWng0SQv26Rga4V/pyHu3OJblJTuANHyJExQL7UY1gtJZuTAW3rjeTEdgIUseFVUeO1UG6NASovSxxLiV9QEPTjkedfKnpwgnyusbtsa1Ds+9PUefaqHDTgwbhgUHzYBPdwYSlYgfDYutXAhupHXRBKdhEP6ZyU0gGYoJZ/CkhILAKKGqr09z0sr2ZxLGIqhBC3sXtR2WYoHXChttEmZBQbB/VnUBUGNk8okwYtso5OXiYYc9YT93jY8x8yazj9RDg0WzrHIYxANx8yhkVSXojCh7M5d+O7bra9TN++z4ByYWrV6aYFK0lAh1qqIFvcSBbiYhcUe2qD3w0soR1jO5iCPud4z28eDCcdW6Ywoy/Epl/tuhSUFGZP4tIEGgNMQW7h9RY142ioQZt/tvYDVOul18RtQ7Rp7nLn4nZEW0MmKrSVnqaPCj+4QRY5HRPO9T7qJhpLvqpaw/mRRfAfkkwqdRRpUinu
 wJBMQdTL
 mw9nm5Qwwp1UF98G6nVtNAoy92AuejbbO5SYEIix7qgseKDMFzj/Ja4s/jpDOVMQTKZHE6sqY4xRr20JhH87xHtqljlQ/vL4UH//z2peXueOr4LY5Q7du12BltliABHG7316YxAcXpc6mKLL/lTn3y1Q2/GPpeeXEpmHieB9QjHApuhpswvx+ghv4lhduahPxJzjjSLI9MDDF1ZN6D9nSZ6khaPtWGSBVcQe14fRjM6prWLxVYXehWim1gB+y8HWWF1K3q/0xYl5lRnuIJ6CV74H2zEFzHhM8mONpvTEmUNYTARGMW2UPVmHtgv9fSfScrL4QXkTPasB4XJF4B2D+bWhTRbbFyqgaBbO499ZTqW/33ojRAAn2oyannUIDaJAOJH/PkASdQRJxTEiGv2smhDjSyPEHfvZGSHTJj1zx/2+VFh2fMheQ4W2HvjI9mOrgwngNG8za5L8/sUQPjh8V7g41xiyigbfKJI6bQVFxjqJI+/iIzOozVB05+HaFiILqfn86qXh3BVjWjRKM57jeuMcf4fJbY2NHW6Dju8tQfg2fAtNRc++JyYt9OkUGl6S2oxARTvjFJNbQkeDkV9v9nBBuZrdADNyXLzoc9geTx9WabWDW3OZ8m/n+7IrNGJQwhk1jttLLyHwnsqvRemekjrfABdBmA8hRCPsTDkB6Ki+q2/rlB/bf258MGekobKVnSy+lPe9GmkuvaFuey1hcpMewGWuJWWIewyXjABfFphgw4NJe0kK9GV1AqRg+NTLIo9fNMAHOFau6fVOMCioWEllSacoOMclqYgiz4RsOiW4R5ppwKR6uGrHumBo8z5OvRbVh9NAe1SeELGxmAczAD9oqj5qYbFSkWXO12xHaB4e7igpuv+ur043rjBa+tSghmEsKcTKJhu37rQr935QFVjXQzvVG7QL8UeiRfak/af+5xDMF7+MwgaHD/Uubtrj3oML9wwaydJoLPpOCsSpZHXUa9SBW
 StvT3Zyq
 3//KC8X03+A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 02:36:21PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    c1f49dea2b8f Merge tag 'mm-hotfixes-stable-2026-04-19-00-1..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=142514ce580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6a29a582d8ced859
> dashboard link: https://syzkaller.appspot.com/bug?extid=4cc5bc01fb4a179c4ffa
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-c1f49dea.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/402c79548d6e/vmlinux-c1f49dea.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/1bc39526d7f4/bzImage-c1f49dea.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+4cc5bc01fb4a179c4ffa@syzkaller.appspotmail.com
> 
> BUG: sleeping function called from invalid context at mm/memory.c:2007
> in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5913, name: cmp
> preempt_count: 0, expected: 0
> RCU nest depth: 1, expected: 0
> 2 locks held by cmp/5913:
>  #0: ffff88801b8cc078 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock include/linux/mmap_lock.h:592 [inline]
>  #0: ffff88801b8cc078 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x124/0xa10 mm/mmap.c:1284
>  #1: ffffffff8e7e5460 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
>  #1: ffffffff8e7e5460 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
>  #1: ffffffff8e7e5460 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2f/0x310 mm/pgtable-generic.c:290

This first looked to me like some spot where we forgot to unmap the PTE, but a
closer look suggests that, since we no longer hold the pte lock, something
forgot to unlock the rcu lock and we're just seeing the lock nesting in action.

Possibly related to the swap rework or so? I dunno. Hard to guess without
more clues. I tried looking at the mm changes for the cycle but nothing
seemed to pop out to me.

-- 
Pedro

