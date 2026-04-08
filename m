Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63A7C10FC460
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 23:52:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A95106B0005; Wed,  8 Apr 2026 19:52:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6CDB6B0088; Wed,  8 Apr 2026 19:52:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A9726B008A; Wed,  8 Apr 2026 19:52:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87C196B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:52:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E72A13A774
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:52:47 +0000 (UTC)
X-FDA: 84637041174.30.A0F1EA1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 65926140005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:52:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CvHUGpMI;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775692365; a=rsa-sha256;
	cv=none;
	b=Vu+QSSbaRKuAcKW9hXB4ktMBjxdJqOi5Tg2IWUlEIQpKGYLLmxBrf3SxWBfvwkfJT8KfB2
	4QAWTEYDMEJONAlty8g3aOORsRJJNwc6MiJYHr8kxY8KLbiZhllOzNhz8prgaxsN1ZD482
	HRSZdd4HCELMVaw435kR0W7k3v4UyRI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775692365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mGckHCLTGMVTcwZwbxQrLXVXwNuPQELw3TwpjAQfPoQ=;
	b=e8x54/ES2gdCS2H62zQMq+zRmGe8aRXUHHOWs2Os+syCpLoTH1lgAOeJpObZoq5dCub7ez
	f+wnMTaieM1wB9zdc+SyxhPGxZHZAKrNkAy73NdJVsN0p9fF2e0stph6Nmvx7bl8Mr2OKJ
	/kyY21mz1r2ZCMMvX+4GWn5l6yqGr/M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CvHUGpMI;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 53B0A600CB;
	Wed,  8 Apr 2026 23:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA50C19421;
	Wed,  8 Apr 2026 23:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775692364;
	bh=NoXTCDZdFrEUxD6kvr1g80kAzOx+axNA5Wxx5KjLhms=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CvHUGpMI8iV7a3qdD67rMlMQHJwIimrGieGk/w1PMg8Hj+buOG1fSH0hb3ppNkZM0
	 Y91A9xAB9FDcvJhqGNMDoTX1877jXPFf/w2DTEFWbZmySvnagFP0eVwy89t4JfR53r
	 I89zcnym4lP3mR8G6REEGzbqHKREANmsHwjl5wu4=
Date: Wed, 8 Apr 2026 16:52:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+8a59070fc852219166ab@syzkaller.appspotmail.com>
Cc: hannes@cmpxchg.org, jackmanb@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mhocko@suse.com, surenb@google.com,
 syzkaller-bugs@googlegroups.com, vbabka@kernel.org, ziy@nvidia.com, Dmitry
 Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 kasan-dev@googlegroups.com
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in kcov_ioctl (3)
Message-Id: <20260408165242.3cc507e32217426be2686a8e@linux-foundation.org>
In-Reply-To: <69d6e54f.a00a0220.468cb.0012.GAE@google.com>
References: <69d6e54f.a00a0220.468cb.0012.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 65926140005
X-Stat-Signature: m8zyijy8pjozutwzay5bjrrnew4o8eh5
X-HE-Tag: 1775692365-4456
X-HE-Meta: U2FsdGVkX191PR5Ho/PrZlnh/CXMtS+cD5zoPAXb98BCnu/EUqHjuzK4l2N/4Otaz0w24UBW6UZXZiJdTjSP/ZoTowORQC615Heo6KZQUBafdTyn7xhfBG80SfAMRf5n4NOWS0983pqIpI8bE0uYkPwKQi3zlTFELd5WYgBg64DhAQ7Al1mVdgarWEpNwsIMukxrauvjhX61p5sQSUWK/ZFd66MiCyhgiS9oFo9KD3OnhuLPTymWCLXK/91BEGyhusV3zc2JKRAUD6Utcy7pxn3GUPgbQKz+mHwi3aHw9bW/9zi9GEl0JMXzcE3daCVizOTqmxtbsNKz8hFikGtDMYbEg7nv37eEJpxPKieWwLqBjqW+8Ig4FA589/lFb1kdNfKh/Gv7El5185rswfALiTFCDTx8BVB3H6pHQ0yMqHikFtV/AKp2ZgPAbXjM1h78FpMWC+M7B0qettgIsjyRx6tmulH3/HG7trbORv9sMyu/FX5GgS0ejJmuG5q14OkQ7IIX3qSg05EpB4Ybrcuh+8bxWGS9DMn2RkRnM4uSmpRUZOHfFKOY9ar1vWmbhSHSvRt6PM25JwlBcn5HVujlI9WjCbIpYMIkKGhKFCTC3/7QMd2E7vpzeFMymd+a4h5aK1oAgXbiPixvIEYdy30ITfVVCTuVaJ8CmUCtvnj1rTDrjLNtXQV1pZ12fLQ52E2SmERWnmtH0C52mh+6Zzaje2vMEelMlRxYaoFvmiwr7dqvWPXtCSUUj/+arSdnMG/qoWQT4QTIVRianeDW0nz2CUF4Tyw9zTHKGG07JVZBTNiOn7tFraiMcf3910Pt/zQAAaA7E2Galfj8NAuw3PzW7h//BdZjoDS3pUZ03FeWd9yDN149ZRYuZ6+pENO3/R5lhL5O8/i+pXZEjE7RmoSoxTv18OdgkcvhHcK7LAc7RWlHaWifHTD6/vwtMxsli/yxRUE3P1n2YuHJvPwmQf2
 id/pSUWi
 g6L9eIh8ga90c6ewi2c9ojalRn40Hl8pN7OeyvcCblFL/QPiH+E04U3YH+xvC2IKFFHTP6h1JAS14XgVG4NQJcJRtMs4s9iLSeQZNzVA1SlRlvPBiOLPtZCmGsLjt5wFg+MfvrVN7b6a6ln16byVawPmek2b9CuTMa8sz5+kqPsW4qawFN041HrNy/qsjSUjJcCYXSdsRYaSNU3Mn0iQPEYaUPvWBJRgPt7ASQtMi+iirs3HvjE7EG4YpLf4iPpuyS8N3humz3PM+HL5i8INhHWzJJvjVT7c69yKbzHKjYb5UMBajqHE0IA8B/IYPOfMXvr12WWToEPglmrfgsYqI+Wm3ux+4ecq6sFk3dF6nLJbiRYsavfZehOTwDUNcS6kMKLjAgZj0iCxxDMkJr0uG3iLtaGj9uBwYtMjJjWCZGQUA7QRDaMF3vROiAfJVYOTnHG9vMbj3FXJrqjCmMvgxb3blPG9Kmo+drUU3C8a+zlFTwnAECyxUqr6lDd1q8eh+DcKpZrQxT85ZNLx47/tXHdbueeo+Kfwwho8UAcidCwq9wxi6SVt7NDB68fLVUHZ4RojIu21x7984XZnXokifJFm4zAE+N1Nu9Pax6v7zgYxHtiqRDasocJi6qUl7AX24TeWXiEDk4+QVSKwWEcsubhX/FHMebvZ/e2RKhnG4nmmDS4WhmxLLwRxA3sFuSypKwp3hnrMj3XgS0M+FBMUwqJ4Kj2h8SQ2M+N2CSVNc97Oex/bVcXZqVCZXa/xTxr5nb0tpxrQ00JpWvNi6y+biMQ70Q7/1DjRKd9j16exPw0DtoLhtMKYRDNdA7ovUc3mmDorLTwIID78F6FcpjObd91Ui4UH/cff/tRu2aTtuvwrB8WJkjRJRtlFlpJjReSZ98sDFtJz23MFHacqfyrSSa4x1Qh4LqdlmdcsJB+y+qFHtMduTLYeowDLE9KJFd+Fid8gb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 08 Apr 2026 16:31:27 -0700 syzbot <syzbot+8a59070fc852219166ab@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    7ca6d1cfec80 Merge tag 'powerpc-7.0-4' of git://git.kernel..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=133b4dda580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=64e78d99d9bf8b4c
> dashboard link: https://syzkaller.appspot.com/bug?extid=8a59070fc852219166ab
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> 
> Unfortunately, I don't have any reproducer for this issue yet.

Thanks.  I added a few kcov names from MAINTAINERS.

> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/ace9641c44ac/disk-7ca6d1cf.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/6e66f8b9476e/vmlinux-7ca6d1cf.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/d679c066df56/bzImage-7ca6d1cf.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8a59070fc852219166ab@syzkaller.appspotmail.com
> 
> bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P23414/1:b..l P27649/1:b..l P27664/1:b..l
> rcu: 	(detected by 0, t=10502 jiffies, g=200461, q=440 ncpus=2)
> task:syz-executor    state:R  running task     stack:25416 pid:27664 tgid:27664 ppid:5809   task_flags:0x400000 flags:0x00080000
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5298 [inline]
>  __schedule+0xfee/0x6120 kernel/sched/core.c:6911
>  preempt_schedule_irq+0x50/0x90 kernel/sched/core.c:7238
>  irqentry_exit+0x17b/0x670 kernel/entry/common.c:239
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
> RIP: 0010:__orc_find+0x49/0xf0 arch/x86/kernel/unwind_orc.c:101
> Code: 00 49 89 fe 48 89 f0 49 39 fc 72 7b 48 b9 00 00 00 00 00 fc ff df 49 89 ff 48 89 fd eb 0c 48 8d 6b 04 49 89 df 49 39 ec 72 4e <4c> 89 e2 48 29 ea 48 89 d6 48 c1 ea 3f 48 c1 fe 02 48 01 f2 48 d1
> RSP: 0018:ffffc9000d12f138 EFLAGS: 00000212
> RAX: ffffffff91777f46 RBX: ffffffff90f165c4 RCX: dffffc0000000000
> RDX: ffffffff81aecd9f RSI: 0000000000000000 RDI: ffffffff90f165b8
> RBP: ffffffff90f165b8 R08: ffffffff91777f70 R09: 0000000000000007
> R10: 0000000000000200 R11: 000000000000aecd R12: ffffffff90f165c0
> R13: ffffffff81aecd22 R14: ffffffff90f165b8 R15: ffffffff90f165b8
>  orc_find arch/x86/kernel/unwind_orc.c:238 [inline]
>  unwind_next_frame+0x2ec/0x1ea0 arch/x86/kernel/unwind_orc.c:510
>  __unwind_start+0x3d1/0x7f0 arch/x86/kernel/unwind_orc.c:773
>  unwind_start arch/x86/include/asm/unwind.h:64 [inline]
>  arch_stack_walk+0x73/0xf0 arch/x86/kernel/stacktrace.c:24
>  stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
>  save_stack+0x162/0x1e0 mm/page_owner.c:165
>  __set_page_owner+0x8c/0x540 mm/page_owner.c:341
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x153/0x170 mm/page_alloc.c:1889
>  prep_new_page mm/page_alloc.c:1897 [inline]
>  get_page_from_freelist+0x111d/0x3140 mm/page_alloc.c:3962
>  __alloc_frozen_pages_noprof+0x27c/0x2ba0 mm/page_alloc.c:5250
>  __alloc_pages_noprof mm/page_alloc.c:5284 [inline]
>  alloc_pages_bulk_noprof+0x782/0x1490 mm/page_alloc.c:5204
>  ___alloc_pages_bulk mm/kasan/shadow.c:345 [inline]
>  __kasan_populate_vmalloc_do mm/kasan/shadow.c:370 [inline]
>  __kasan_populate_vmalloc+0xf0/0x210 mm/kasan/shadow.c:424
>  kasan_populate_vmalloc include/linux/kasan.h:580 [inline]
>  alloc_vmap_area+0x95d/0x2bd0 mm/vmalloc.c:2129
>  __get_vm_area_node+0x1ca/0x330 mm/vmalloc.c:3232
>  __vmalloc_node_range_noprof+0x213/0x1530 mm/vmalloc.c:4024
>  vmalloc_user_noprof+0x9e/0xe0 mm/vmalloc.c:4218
>  kcov_ioctl+0x4c/0x720 kernel/kcov.c:726
>  vfs_ioctl fs/ioctl.c:51 [inline]

I assume the fuzzer is asking kcov_ioctl() to allocate ludicrous
amounts of memory.

	case KCOV_INIT_TRACE:
		/*
		 * Enable kcov in trace mode and setup buffer size.
		 * Must happen before anything else.
		 *
		 * First check the size argument - it must be at least 2
		 * to hold the current position and one PC.
		 */
		size = arg;
		if (size < 2 || size > INT_MAX / sizeof(unsigned long))
			return -EINVAL;
		area = vmalloc_user(size * sizeof(unsigned long));

KCOV_REMOTE_MAX_HANDLES looks to be OK.

/sys/debug/kcov is mode 0600 so this is no emergency.

Maintainers, perhaps we can do something more ... restrained here?

