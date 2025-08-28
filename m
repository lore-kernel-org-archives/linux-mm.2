Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CFE0C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 13:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95A688E001D; Thu, 28 Aug 2025 09:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 931EC8E0006; Thu, 28 Aug 2025 09:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86E608E001D; Thu, 28 Aug 2025 09:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7717F8E0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:12:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0FB49138CCD
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:12:55 +0000 (UTC)
X-FDA: 83826206310.29.6CFCF58
Received: from r3-21.sinamail.sina.com.cn (r3-21.sinamail.sina.com.cn [202.108.3.21])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2517710001A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:12:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b="VLf/z5Y/";
	spf=pass (imf05.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.21 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756386773; a=rsa-sha256;
	cv=none;
	b=IRDU5LYzVayptKlYu5XuY6mFt8wS0GrIFNTd5kLydqlVQDrXAFNcbOckQt3njQzi+zWB3V
	53WqmfW/UXeROYzk6z3tMDvG3g4I3W4cDuvD6eVdd/lSzirwh9jaqh99YYxqIbkHazXxL7
	c1YChXa86zINYEWCt1kmlPAjcBaNDBk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b="VLf/z5Y/";
	spf=pass (imf05.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.21 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756386773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfczMGMfameg5t5XspoijThbHapqSsEAVcgmCYwa720=;
	b=5rwa5cgxgTFmsDULZAh4zw7UA8dr17T2IxvXUHJ5pILVz1V1cSE9IT77DsMdDuA8hSrawL
	y9mYqjvYQxlobaPd7YMQYePsQmyww5EsBSlC9WluiDn3Epm9TzNO/6jBtrp0qdn6zd5NSD
	J664UrkN8eVDNWcyJ4nPw3eseM/iS9Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1756386772;
	bh=UfczMGMfameg5t5XspoijThbHapqSsEAVcgmCYwa720=;
	h=From:Subject:Date:Message-ID;
	b=VLf/z5Y/mGT7HL+LVCnetq+Gh+eFIWbkCBvXq4NPC45J/fL5HYZQkWUyA38QG9svf
	 Jp5dy92tuWq/ZkIoYIrFbuNXPXfjsTXoKAFG0eSVwrTCUKsCsLcd4HHuJ6LTulD1ou
	 QKUK2D/mjL1s1vY8TEYSbbLMVP4bj5qoKC2KljJ4=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.33) with ESMTP
	id 68B055CD000035C2; Thu, 28 Aug 2025 21:12:47 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 7291006685211
X-SMAIL-UIID: 1F1ACEAFEED84F25A86B1A630A3B358E-20250828-211247-1
From: Hillf Danton <hdanton@sina.com>
To: David Hildenbrand <david@redhat.com>
Cc: syzbot <syzbot+69c74d38464686431506@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	peterz@infradead.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in copy_process
Date: Thu, 28 Aug 2025 21:12:34 +0800
Message-ID: <20250828131235.6007-1-hdanton@sina.com>
In-Reply-To: <04adff83-3771-4a51-95bc-cc11bb169e35@redhat.com>
References: <68abd1c8.050a0220.37038e.0083.GAE@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2517710001A
X-Stat-Signature: aurfkxf3n8e6dr87sef8oztcdsm95yma
X-Rspam-User: 
X-HE-Tag: 1756386771-464705
X-HE-Meta: U2FsdGVkX198VQT1vHdi56AcjVpDWN/W7RzheevC6i8++NgEzxUSujmvZpedeCJXAR6dNlGwN72B8/Fju/sl9jTtbBNT8U6uWc9abKlHZ/8UioziBN60gJlmUD7i0bDXPQydzofLK4w6flyATT5tYK9i8v2TYwlrp0AsVBD/v3pUFkkgz1/dKFE0YNOcnF9WInusDtc8iIgfRd5UGsK7Kibnn6K9r6/8SQOKEYlLlr+UIwNPKZB2CFx3cv4A7y/vsLROh8aG2JGLWUn8xca30VFxChZi+7Ns3nDfVyihHt+lE3nFNWhR+KN+G/UboNTsbefmw3Hndd9e3ixLYYQ6h7AGXNRYsWQ776kZVvp2IjL0fgwyR5vLMZIkycqifuI8XaRQxgYovAMLS+s1W0cGlohMddWExv0FNNy76bPaJgR/d6SYq2GM/zQKyCHKWBK21J3dBlU/WreAhgmM1+f76hPKUBp2p378/Nv0Dp6a1fUlPEAWRXL+s16EOPFQdogzG8DWREUNXBSJSEbDQjsQ3xdj5T887fLVrKwVUXmVcEmt+zvnX1V++3N0d6FRZw2F2m87MwhcxGE+48HgeKivwevy/yCUZtw4Lz/2CfjS+MLSAtSEHjoCeqDyPYFzfYJR5Xi3dHsdjUipLOHdefFT8AJIR0fAXs5bjBuHC/sq+nP88PZr5fBSSUsnBsUi/teHspaet7ap9/FfXtOrmnq9I4G3kKDXEA56ZzH/vDsNyHJfTw36lWEa/ecFr75ZwEoHIatDzS7xODC3m/AkN0KbCcBvsjR8FRdoNp1d6g36zBfzEu20TKHz2TEhyUl5MjKOvey5yDAvGe121kRdMlxMfE1bVWa92ALT958WiQQCpCfH2NPEClVXoIrTgf9/Xpw6g2SATt3da0piwpQXl0t/f495nKvrL1uzr627HBjE1w84JQ0BrAcEhG8ix3ZFpdBsas7AVjD792bgb5H5V+A
 qWbyAhfX
 6jsiJRBWSQpaswmB8okBeF1ZD3Ny/Mjv1bwI9EPbHprtkg80OnrxtRZE2V8uprtU+mZZ7amSj7i0GqBL3M6RFugxbfkA8+xuB/h3ruGuTQm5BWRJMjgtFcO6lc2yhtfa1Mw1/GHtw1nIw4up2dZe/4ed57joINaFXDrOvfoju1gfJ40dQ2niGQYTHFj7P6QuOHdWAkFsl4JUNb5jSI/nu9AYBdOzl7T5Sv4JsZBNTQ2qQ2r+XdQJNQ6O6MueB9uEA8hcs3VBYaA3LK7b4ulJfbqT5j+MOHXzLXRoGpOqPcxfCjRjRb2mesua1KFHOc2hMP6MNlz7Wrl0GUUnrEHe8reIeFnZmDs/yT0il6u2GrxzOMd0bU9saT8Hvj4k6zN9bnACHtUKLyFib02ssIPuwrPHmq26DKbQunzJyiEaQNsGnn6VJyn/fz0boYuwstqRl8+itThOyYIvG7cxMmQ+CMN9K2R7f/dydnzYs5Vf6tCWvV1EORfvoimB08sJhXQ4ynYEIl+F0Y+zed0/4aG+o4/awS2ZBJJnqDpWBuAUWNFuiZu51Kpfz25ghekUAFJ+L1pwKpqI+9xGAJv9IHibpIg83OCrQv0A4LuTBV/vuZze5f30qTEybtqacsfO04+LWKQ3u0CHFWcCuwsvYVYwHsdxJ8TEhMEgith4yGbl8BXNH/l9xCPi8p7jNOZCrxeaEC7LfAoYVE1tWY/hFzGwVEcrph7sdLEkiVM1+6Ncyfo4YDRazkaEmrKfpGEiD4Dx11dWh3/3RHYLp2L+vsd5VPAfzmSUEdbS7G2lFwAnWWyklk0pF0fRApm40PINwoeASjqudsgRZKFpWqMXj0sWTFmE6Nq1xTbBt9CW69YCIB2Uf7AELLKwUKncddOx1QRWL3Lsn1Qd/jXb1UBPY70V+6Qr82+ZoNrG6ShMqSRMEa4uDaOBQAUcJB5wK5qYkjznWBY5fTsMYnuY8QnNJkh2bNZ5g8WIo
 J7RXW2R7
 5UQKufrTc1a6jlR66YQEUkMpjKTMEcF0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 Aug 2025 17:50:15 +0200 David Hildenbrand wrote:
> On 25.08.25 05:00, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    41cd3fd15263 Merge tag 'pci-v6.17-fixes-2' of git://git.ke..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13d8b3bc580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=fecbb496f75d3d61
> > dashboard link: https://syzkaller.appspot.com/bug?extid=69c74d38464686431506
> > compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> > 
> > Unfortunately, I don't have any reproducer for this issue yet.
> > 
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/ea83f558e101/disk-41cd3fd1.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/a35b75cdd97b/vmlinux-41cd3fd1.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/37d76e9636c2/bzImage-41cd3fd1.xz
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+69c74d38464686431506@syzkaller.appspotmail.com
> > 
> > oom-kill:constraint=CONSTRAINT_MEMCG,nodemask=(null),cpuset=/,mems_allowed=0-1,oom_memcg=/syz1,task_memcg=/syz1,task=syz.1.3237,pid=23388,uid=0
> > Memory cgroup out of memory: Killed process 23388 (syz.1.3237) total-vm:101828kB, anon-rss:940kB, file-rss:21532kB, shmem-rss:0kB, UID:0 pgtables:116kB oom_score_adj:1000
> 
> Here we are killing 23388 (syz.1.3237)
> 
> > ------------[ cut here ]------------
> > pvqspinlock: lock 0xffff88803512c0c0 has corrupted value 0x0!
> > WARNING: CPU: 0 PID: 23388 at kernel/locking/qspinlock_paravirt.h:504 __pv_queued_spin_unlock_slowpath+0x237/0x330 kernel/locking/qspinlock_paravirt.h:504
> > Modules linked in:
> > CPU: 0 UID: 0 PID: 23388 Comm: syz.1.3237 Tainted: G     U              syzkaller #0 PREEMPT(full)
> 
> And here we are still in the process ...
> 
> > Tainted: [U]=USER
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
> > RIP: 0010:__pv_queued_spin_unlock_slowpath+0x237/0x330 kernel/locking/qspinlock_paravirt.h:504
> > Code: 03 0f b6 14 02 4c 89 e8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 67 41 8b 55 00 4c 89 ee 48 c7 c7 00 81 ad 8b e8 fa aa e6 f5 90 <0f> 0b 90 90 e9 64 ff ff ff 90 0f 0b 48 89 df 4c 89 04 24 e8 71 15
> > RSP: 0018:ffffc9000e9c79c8 EFLAGS: 00010286
> > RAX: 0000000000000000 RBX: ffff88803512c0c0 RCX: ffffffff817a02c8
> > RDX: ffff88802fa9bc00 RSI: ffffffff817a02d5 RDI: 0000000000000001
> > RBP: ffff88803512c0c8 R08: 0000000000000001 R09: 0000000000000000
> > R10: 0000000000000000 R11: 00000000000d4550 R12: ffff88803512c0d0
> > R13: ffff88803512c0c0 R14: 00000000003d0f00 R15: ffff88802ab43c00
> > FS:  0000555568154500(0000) GS:ffff8881246c4000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f86cc8e86ec CR3: 0000000060c0e000 CR4: 00000000003526f0
> > Call Trace:
> >   <TASK>
> >   __raw_callee_save___pv_queued_spin_unlock_slowpath+0x15/0x30
> >   .slowpath+0x9/0x18
> >   pv_queued_spin_unlock arch/x86/include/asm/paravirt.h:562 [inline]
> >   queued_spin_unlock arch/x86/include/asm/qspinlock.h:57 [inline]
> >   do_raw_spin_unlock+0x172/0x230 kernel/locking/spinlock_debug.c:142
> >   __raw_spin_unlock include/linux/spinlock_api_smp.h:142 [inline]
> >   _raw_spin_unlock+0x1e/0x50 kernel/locking/spinlock.c:186
> >   spin_unlock include/linux/spinlock.h:391 [inline]
> 
> ... busy during clone.
> 
> I assume that it is 23388 calling clone() and not getting cloned (it 
> should not get scheduled yet).
> 
> So likely, the OOM is shooting something down that kernel_clone() still 
> depends on ... maybe?
> 
Difficult to understand the oom shot given tasklist_lock held for write
also in release_task(), weird.

