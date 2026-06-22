Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4791BCDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 15:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2F656B0096; Mon, 22 Jun 2026 11:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDFC36B009D; Mon, 22 Jun 2026 11:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF84A6B009E; Mon, 22 Jun 2026 11:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B0406B0096
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:35:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B6A57165FC5
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:35:58 +0000 (UTC)
X-FDA: 84907949196.05.C542E2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1BFF7100011
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:35:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bm3nPm2O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782142557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0WtLG98RNnKThawH5sUjIfrTNwRKeoy4IoR8MM6IZeM=;
	b=bGzUo9dKYRE9+oBcp6/HQ7LXbxedQSmmDR8T3HPcKPwDqZubWpafvqSaoNj2aiAWbRZ/lg
	C15eanf9bz+McmTTTiCRLuwTn2Y8fRmFCOWehhcheTb9eQju7+X55aSe6F1MNpDLMW28jt
	1wLJ8Vf2ylfgqoFKdpgp2qYW8T9kQIg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bm3nPm2O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782142557;
	b=RYYQg5TnQ/oXb9jBRsDzNYu866vHKYDMWRLgrQSetOuFIodAOlceFMAZD5iZMjyHFv7qPf
	eNco6vUMpexVZ+x4jxtnMcyWMK0L84Wa3vRClxCVwzmwoeBf7WXiJmb53dwDahweqkqPHl
	yFcq7xb6RvQAtIz7fCdp0ABtr0pFszc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9DF27601F3;
	Mon, 22 Jun 2026 15:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED841F000E9;
	Mon, 22 Jun 2026 15:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782142556;
	bh=0WtLG98RNnKThawH5sUjIfrTNwRKeoy4IoR8MM6IZeM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bm3nPm2OEqpyPhkbTQukjlslEjjjzb9GXulYKsW+0km8iovMQnS2ZV7UFAr1RwNRU
	 50/uyBhq8+2HhCUFyPqxOSSAsx9XBysNH1LSilW9P99isdxTKggOiXkDOCJhCVaeD5
	 sG8OZmlkVd/riVH7sleThbqYcjU8R7BTbo+MJ9d+XNJNAiNGLe7PSXEXY8R8y3ou+w
	 Nfyuk//VrrmI4nZmqAaRRid9fuaOc3IWv+yin6gXlO4nsFUM7uoIOrTpH6opUTLMr6
	 kYp84VC+4lo5ZNxV647bAgnH3L+N6CNki4x0Qju4J1clqK+Fb8As8T9Tt5rWps6zKR
	 R4r6SAzClYH3g==
Date: Mon, 22 Jun 2026 16:35:49 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: syzbot <syzbot+395b7abe9696862fc188@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, harry@kernel.org, 
	jannh@google.com, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, riel@surriel.com, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org
Subject: Re: [syzbot] [mm?] KCSAN: data-race in __anon_vma_prepare /
 __vmf_anon_prepare (2)
Message-ID: <ajlT5OMAjC47iTTh@lucifer>
References: <6a35fcb0.6813c476.3c3d96.0003.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a35fcb0.6813c476.3c3d96.0003.GAE@google.com>
X-Stat-Signature: zhk53mr8ebqo49w5qsgj8ups1kzby9qt
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1BFF7100011
X-Rspam-User: 
X-HE-Tag: 1782142556-617082
X-HE-Meta: U2FsdGVkX18xxA9GiUeUr0F818+M1O1icWp7Pc5wP0OHwQBT8uzZ2hF5wIotLdNv2fCVujUdRdgnq2hJQOzcOhbKXTcdarUW0lP3vqw3nmrDkPg5O6ClhvvFHy6C1p3h4h8IYS0BZdYdeBaqd3qDLD6ZkWyMCR7KSRnYwgXVj5LT9YAC/XKVRcXuP9XCSfipvtCpRPXUlIS4S36VL0cCBDi6lrStlYfZDEouUOczZoAm/OAinKzWlhvCTkGo7UXxSc7G8iIyNMjYgoK5d0zaGDtW/8YJSpwyQGh7+CfULout2xxlXzvxUSov6qDP0pzsGpuYHG8qlZij2MhdcdxJ2tnzWIItp/zjK2l+GIdQk/ZOeAxvU7nK45CGy/6E76jJQRD1LsR/0d/ncZlh2LxYUOnIzNtKeixjXbh4moxFYzyN7HV3WgVnzHLdmo50z+RzhvNaSIAoz7Vb6D5nWKZejkuMug9l7trGQTl0LKP/nBTuq8gxnt43sFhZ0NVAaZVXKq1B0Kvfy9wXU4B781/oth7jhMPkB8GxQb8ykA33XmIwqiddHuTBqj3WQFm0hUaEm6cFh62Nx6a8v+gdAfsBEYNy2LQUK2U0/C8UzKFnkIqS+4ieCHvCuCmmlPl1b/MKtYYQVNO1oMSBhGQLJ/9PSHy7rA73yT7QN7knIDVvJeoI1Ax0727xiOjgplWZwrDxXFWge0B0T0LcAgoccYnhVGSPmuNZDTnWKsOlPPqnLhR6whJtSWFbxxiIiIKCdt9UQlmvr7lLuVu0cXlilE3qLPmM5aWvY1IDWxBQJyGmVM9E9O8B5ruAubetFE19oxnfc6xPo2sdDYmpKqB0vxegt0QZDNg6TJyxjwA/zQs7C1sTpcqCkSbtDgzBISA8XHDP+g16cX/8PrEtQgm360EkqIe4UOMg/K0afSCPRilQxkg8TJDMc7U/NWIhQUK5hawZAPim4dO4kGTbipVrivN
 rm7OrAC6
 LfhUcHZRMmJJlPo50cr1TGC7eEUEWa/zR4zjxcN9WIIYsgyuNB82lKAL756rYzXo4o6UFPnulwzDA4mYUdBHIufcYYxFUBEq+WFuTXVO/2gCNqk0hIsCGvgG6o4kknxPnG00IayRVPnk4RhiJfasZa1l2aVLVfSmTLwDG+zdu/BFVnSS7SdrWtEu4fjntBmE9u7dWOE0dWfjaOvLLy0LQ+yNGuYlqHwr2eJXTdga7ku1oWuCteO2F3v9EvQ+y+0aUrwryuebJlxhIrQveVUoPIIkKg5pY5LnU3zOaSZsUGtom37Bcqwc2pNkBMXB8hNHTiGJ8GEJ2LHkrwm6cD0m8qCpUATQrhZ8IywGSH5g6dT2rwGWOLlmqj3ZqOoD7lqeogZxMcF3AqEjCtwhZsK9ylZxjMB+vtq2sDrT/L3jsngqsis4HsAWHQF5SCA5Yxa/r+xuvPkXnrva0wj0bq4JoMAMSWFUEbODVafInwfRmL1TmFvgFFBBZh6yi61xN4pfTzPc9Lo1LatkvTBdh/7oGxaV1+hrp/cmrIQ1Myx0TFlYSHLb0PSwJ6bnGs9SzB4UBC7FyfTp2IO3ixLwgC76zMm7R/WdyN29NNXBQYIoAM51TN9bdg6BwkHSmmNAnaPF566f4C0HuH+cq4eYiY86wb7/44iRYyWFBKficX9b7Raijn2L511UtBUws2JR2K00A5IdeA1lgPEXYgiYEuYQl2SejOgltaPEG8EZ4tTcaavQPLd7ehORuEWPIrzBHCfpNQfnWus3xpR9xg55k0PpuVm68lfvgvgvBdT9MgZafc98gi5xMXnPTW4dkKYQdhOqX5URpbfSjed7xVt2VLOaPK1eMjzmQ6bxQJVBaWcqyBtstn/+UhIHP7thgsgpihfCIT34scA3gLJVnK1kqdsskngTh3Yy6zdd1Tu3AO2yXyPsRfi5L4yMKS59dG8nAEVZ8LxE2qzvpoLGHrLwNlvVPtgAOn6Ef
 j7fdc6E3
 huHCyssYVH89DEeuzuUPLXq67AXss4GnWMuhkMb8VvJuV+8tWXQCyRd4dlLQIIvkZhZtQxp4QfJj5mfnAoxyJPXWEZB6GIiQHeHQKopAFZ9QMFKCbRFs/U7tCu7s9vXICJhASQl5YaXARtGCXw80pLXls/AlMkHQT9e2/N8Epnw/zJNNY42XMHEMGFzKPy4Esdb5guwMuBiUhUu3VggoFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This seems to be pretty much identical to the previous report, which we
concluded was benign [0].

I think I'll send a patch to add a data_race() annotation nto the read-side.

[0]:https://lore.kernel.org/linux-mm/6967c517.050a0220.150504.0007.GAE@google.com/

On Fri, Jun 19, 2026 at 07:36:32PM -0700, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    5e2e14749c3d Merge tag 'landlock-7.2-rc1' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10e5ccfe580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b0ae27ce66b92956
> dashboard link: https://syzkaller.appspot.com/bug?extid=395b7abe9696862fc188
> compiler:       Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/a565c60a4762/disk-5e2e1474.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/e593a6eb0057/vmlinux-5e2e1474.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/d24b55020ea3/bzImage-5e2e1474.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+395b7abe9696862fc188@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KCSAN: data-race in __anon_vma_prepare / __vmf_anon_prepare
>
> write to 0xffff88811a6a4d00 of 8 bytes by task 20911 on cpu 1:
>  __anon_vma_prepare+0x172/0x2f0 mm/rmap.c:212

WRITE: VMA under mmap read lock, page_table_lock:

	vma->anon_vma = anon_vma;

>  __vmf_anon_prepare+0x91/0x100 mm/memory.c:3829
>  hugetlb_no_page+0x1b8/0xf30 mm/hugetlb.c:5756
>  hugetlb_fault+0x608/0xda0 mm/hugetlb.c:-1
>  handle_mm_fault+0x1de9/0x2da0 mm/memory.c:6684
>  faultin_page mm/gup.c:1126 [inline]
>  __get_user_pages+0x129c/0x1f10 mm/gup.c:1428
>  populate_vma_page_range mm/gup.c:1860 [inline]
>  __mm_populate+0x242/0x390 mm/gup.c:1963
>  mm_populate include/linux/mm.h:4171 [inline]
>  vm_mmap_pgoff+0x23b/0x2d0 mm/util.c:586
>  ksys_mmap_pgoff+0x2c6/0x310 mm/mmap.c:606
>  x64_sys_call+0x14df/0x3020 arch/x86/include/generated/asm/syscalls_64.h:10
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x136/0x3c0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> read to 0xffff88811a6a4d00 of 8 bytes by task 20901 on cpu 0:
>  __vmf_anon_prepare+0x26/0x100 mm/memory.c:3823

READ: VMA under VMA read lock:

	if (likely(vma->anon_vma))
		return 0;

It's benign because if we race here we'd just recheck in __anon_vma_prepare()
and the mm->page_table_lock would serialise for us.

>  hugetlb_no_page+0x1b8/0xf30 mm/hugetlb.c:5756
>  hugetlb_fault+0x608/0xda0 mm/hugetlb.c:-1
>  handle_mm_fault+0x1de9/0x2da0 mm/memory.c:6684
>  do_user_addr_fault+0x402/0x1060 arch/x86/mm/fault.c:1394
>  handle_page_fault arch/x86/mm/fault.c:1483 [inline]
>  exc_page_fault+0x62/0xa0 arch/x86/mm/fault.c:1536
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
>  __put_user_nocheck_4+0x3/0x20 arch/x86/lib/putuser.S:97
>  ____sys_recvmsg+0x1a1/0x280 net/socket.c:2917
>  ___sys_recvmsg+0x11f/0x3a0 net/socket.c:2946
>  do_recvmmsg+0x1e5/0x560 net/socket.c:3041
>  __sys_recvmmsg net/socket.c:3115 [inline]
>  __do_sys_recvmmsg net/socket.c:3138 [inline]
>  __se_sys_recvmmsg net/socket.c:3131 [inline]
>  __x64_sys_recvmmsg+0xe5/0x170 net/socket.c:3131
>  x64_sys_call+0x80f/0x3020 arch/x86/include/generated/asm/syscalls_64.h:300
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x136/0x3c0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> value changed: 0x0000000000000000 -> 0xffff8881020cec60
>
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 0 UID: 0 PID: 20901 Comm: syz.0.4316 Tainted: G        W           syzkaller #0 PREEMPT(lazy)
> Tainted: [W]=WARN
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
> ==================================================================
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

Thanks, Lorenzo

