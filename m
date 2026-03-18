Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7F2610775E1
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 16:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C9F6B02B8; Wed, 18 Mar 2026 12:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0406B02BA; Wed, 18 Mar 2026 12:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B77F06B02BB; Wed, 18 Mar 2026 12:53:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A14536B02B8
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:53:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D32CBB9D5
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:53:57 +0000 (UTC)
X-FDA: 84559780914.24.EEE8C77
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 71D30140008
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:53:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h7kRifsp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773852835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JFBJheRcxnFvhtIcW2IDEBpPz+t2EMg7OGGBrmDY/eg=;
	b=zXnUjAIcngE7+iV4owFV5s5l2wcfXdzxNSrAMlc6Ves7Wrkfy3H1MnJPk000GzUvna8VDe
	3JcqeUy2UWXpkWaDl8dNch72WsxI24b5gHSgsqcLUuPXlFV91PNxUdWPXeRGZT1+A2s/Ow
	36oPsGa1QcUlZkxDotNzw/CbHdl0SfY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h7kRifsp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773852835; a=rsa-sha256;
	cv=none;
	b=E6vxbSoEbczIiPB3pEl7YlKIgHA77WgValrImnFnBLag+aiiO5/vaBbMEhSJnTYORIwgvs
	zZmyzPJ6/1tBJoKsn9E7PUfgNRUOw/5Ok69X1kwaa/hZngVo2Zdhmy5AniW1UdxC+Lz5mk
	mnn5EKQ5vyFCyjhZPNumFYHaxBLh5yk=
Message-ID: <cfa40f51-0a39-49e3-adac-48b2709e67c8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773852832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JFBJheRcxnFvhtIcW2IDEBpPz+t2EMg7OGGBrmDY/eg=;
	b=h7kRifsp+R+PKcozL0bLph/GAkDSTIbUZN48QOqMUvMot+q16sFxCj3RgjWgxd5DqjjOai
	phlHPgrB/psjGgWbhHnZCG0LM4AhE9uH1yQkvV9/BJKaUX0hMnsGydrkwRv9k2FlTFDHlA
	0ghfZjylmp3aD1r9a0ThSarY+nXZ/fE=
Date: Thu, 19 Mar 2026 00:53:46 +0800
MIME-Version: 1.0
Subject: Re: [syzbot] [mm?] general protection fault in zap_huge_pmd
To: syzbot <syzbot+de14f7701c22477db718@syzkaller.appspotmail.com>
References: <69babeba.050a0220.1b2d94.0003.GAE@google.com>
Content-Language: en-US
Cc: david@kernel.org, ljs@kernel.org, ryan.roberts@arm.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ziy@nvidia.com,
 linux-mm@kvack.org, akpm@linux-foundation.org, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, dev.jain@arm.com
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <69babeba.050a0220.1b2d94.0003.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 71D30140008
X-Stat-Signature: qyfdia8859ptzzb3g8enjthmcnqsr5ic
X-Rspam-User: 
X-HE-Tag: 1773852835-60593
X-HE-Meta: U2FsdGVkX19CCWQhhilTJJDN5rP81aVmXNtSk95M01I98YtR8dCkYsvK+Q1oYoa5IEFHtSqxang52xPkhBFIBktuxEEvENflmfu6nKTHKtIvtym9qDnaMCmoZ6vIUUAleIQr0LgxnQXOTE85LqIS3RsABstfAcd6rMx5rCMWLnf3fZDyM9Hs6pn/YycaKtLqo2GsT2X/jcoForY4irFm88rgTaM0DWQS7Vt9P7W6r4iLbTaUe0vMHGQDCoqRUHSDdkjAY5WRA6vEmupFn1jWg05bfHaoWmAgyXzPcijAG40KaMrqPUbKyU81pXvo6qxhGx2bC5tnK1555oeT+7ID8Jm2TKZPiPB5zKb3Oqp2poTdcsy2FJ1xSoCfgd0ndN40c5ZpzXNmf7rAHJHr5WsM+5iXQvu1AqdYGDeMFyXVqToUSqMHuy9UPvBk3ua9DPk0spMqVhQID/xuC50NH5xqwbTC81mL3QwN9wtONt1okzMNxQuQeZIbHdfzdP4UEYV3bSRq4MBLkS3Z/dTM5ufNI57AEur34yU4OuAOTNMpL+eFFbHZeGjMOfSwJVT+oNca2LMOfqIF4JKEsrESuB0G++PlTkzDcRbsiQcE/K1fzB456DIWsxne84k+vQVoIVFRwPCEgzEK4ItTdfErxWRjBOEWbtZt/OR4uB/aP6dCA0wS/BaOVn3XPvAmTfGbRGvqzvIsffzwRNyfFkN+NFveZeSGsYNgywwDa8TclL2sHB6SDmqzuXc9r30nRrLEEX0xmzLJ2iVAG7E6gAdA0LKE7bap3kVgOkGtpscEyMDhanZCm88kQVbcPzaZb6jXqFt5lyAn8mycScsfV8wI6o5QePgVnKOIQX6Ec9d5Rly/IfFRLL9FVzSP51C7io4qvYWUo2L37GLHm5oRBWvZNxf+sHd8BIIEIRmOzBd4Nna47g6WTEJGpY25xtGEkiRGzpRDJLUdrILjx+WrDdTemKd
 0jV/wPhL
 zfxmlvyscFbbRFNnyEFflgn5tlgNW/+gwdM3GBeUVjGkaPtOFQbyHukxvULQ86ANRV2m+A6KoZSsRHEieNuWB8BugEJEr9jQGybFlaT9c2lqehCW9GNldiQ9vXsg1wPrcBwlCa1E3yVwqdIXZEhGSCFh6dnxsC53YcnCz9o49J1jjpMKVbEOC3WQgjHGCBuHXV2RSYFo8e4Yjy1fpc5nwg8Ux4zauWwRPNFcUq5AqkKbncjU5oyiey0n/UfsgPDbe97C3Lxj2Rsrm5MsoqUzWzX4xkt4AWcQfgUJrRVtL2eCUA2KTYrM1CJy57jBgquf7vID2/Qnpd7qjGauTqq1qIhg/yfNO6L7j5CRl3ThhmtAPFdm1BVpInGVrNP2Qb7B4UvPQTdlPIV5nbfwzrjOZfGm35GORiGVTu4zzQ3QGyQ/Tl+Km4nK3rD53bVdTcOAb/0Q3KGShexqADiXKKMBRuS4Z5EvqVY3CF8oRNntljf//1CRFt56lMVL+hLRAl6FLd5B9/ahUr/Tvx/eocorP2BlMSkC3xb+dJ9Py94LzyZOHGaWd+D86NOJOMxlHJOvgYQJW2ORcidIKI7YqEh1P1Y+HFOnchNjKpefsi7GNoUCLypz3hf1ASXI4uX4oZWxfXI9G8GTlTOOeWlVPCis25U4KPGS6zBkSEK8tbnk+sQyD9BmBlir7Bc5ej+UkY0Cy+9zQLuCpCjZgGnRbeOypgRFPa5rn2TGVV0GH9Ibv57PZnwq5ywhLeFqYIcdpnw3iL+QVplwRpImbgFuH9iwvj4f9jOyTOrI/3QqhpH1x+ArkSGZ76VhtXC3NIy1+0w6kJWKhC9vQSR17FGIMPwKY3Qz+yK8R8apS3DcC0fNRZvo/7PUuV4p6thbIvn/rdg7t7SjXPc7k4N/fCO7CuyiLLTbv2LSskaha+GgLwyfLDstAD0XsXq4MOGpqQucZUGipDGDA0TkpwN02uwY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/18 23:03, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b84a0ebe421c Add linux-next specific files for 20260313
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=119ddd52580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e7280ad1f68b2dce
> dashboard link: https://syzkaller.appspot.com/bug?extid=de14f7701c22477db718
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=173b44da580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1537b8da580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/09145161a8a9/disk-b84a0ebe.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/b64c254e474c/vmlinux-b84a0ebe.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/a7c33f5f7f45/bzImage-b84a0ebe.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+de14f7701c22477db718@syzkaller.appspotmail.com
> 
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASAN PTI

Looks like it hits a general protection fault in zap_huge_pmd() while
dereferencing folio->mapping via folio_test_anon() ...

zap_huge_pmd() fails to handle non-present, non-none PMD entries that
are not valid PMD softleaf entries, leaving folio as NULL and
dereferencing it ...

For PMD-sized hugetlb mappings like the reproducer above,
hugetlb/userfaultfd would make such PMD entries that can be
non-present and non-none without being valid PMD softleaf entries?

I'll look into it :)

Thanks,
Lance

> KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
> CPU: 1 UID: 0 PID: 5994 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
> RIP: 0010:folio_test_anon include/linux/page-flags.h:718 [inline]
> RIP: 0010:zap_huge_pmd+0x7b1/0x1030 mm/huge_memory.c:2463
> Code: 08 00 00 e8 11 e0 92 ff 48 c7 44 24 10 00 00 00 00 4c 8b 3c 24 4c 8d 75 18 4c 89 f0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 4c 89 f7 e8 f1 43 fc ff 49 8b 1e 48 89 de 48 83
> RSP: 0018:ffffc90003bb7550 EFLAGS: 00010206
> RAX: 0000000000000003 RBX: f000000000000000 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000003
> RBP: 0000000000000000 R08: ffff88807cc9802f R09: 1ffff1100f993005
> R10: dffffc0000000000 R11: ffffed100f993006 R12: ffff88807cc98028
> R13: fffffffffffffa00 R14: 0000000000000018 R15: ffffc90003bb7ac0
> FS:  0000000000000000(0000) GS:ffff888124ee0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00002000000000c0 CR3: 000000000e94a000 CR4: 00000000003526f0
> Call Trace:
>   <TASK>
>   zap_pmd_range mm/memory.c:1990 [inline]
>   zap_pud_range mm/memory.c:2032 [inline]
>   zap_p4d_range mm/memory.c:2053 [inline]
>   __zap_vma_range+0xa82/0x4bd0 mm/memory.c:2093
>   unmap_vmas+0x379/0x530 mm/memory.c:2162
>   exit_mmap+0x280/0xa10 mm/mmap.c:1302
>   __mmput+0x118/0x430 kernel/fork.c:1180
>   exit_mm+0x18e/0x250 kernel/exit.c:581
>   do_exit+0x8b9/0x2490 kernel/exit.c:962
>   do_group_exit+0x21b/0x2d0 kernel/exit.c:1116
>   __do_sys_exit_group kernel/exit.c:1127 [inline]
>   __se_sys_exit_group kernel/exit.c:1125 [inline]
>   __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1125
>   x64_sys_call+0x221a/0x2240 arch/x86/include/generated/asm/syscalls_64.h:232
>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>   do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fdd0b39c799
> Code: Unable to access opcode bytes at 0x7fdd0b39c76f.
> RSP: 002b:00007fff630f1d78 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fdd0b39c799
> RDX: 0000000000000064 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000003 R08: 0000000000000000 R09: 00007fdd0b5e63e0
> R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fdd0b5e63e0 R14: 0000000000000003 R15: 00007fff630f1e30
>   </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:folio_test_anon include/linux/page-flags.h:718 [inline]
> RIP: 0010:zap_huge_pmd+0x7b1/0x1030 mm/huge_memory.c:2463
> Code: 08 00 00 e8 11 e0 92 ff 48 c7 44 24 10 00 00 00 00 4c 8b 3c 24 4c 8d 75 18 4c 89 f0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 4c 89 f7 e8 f1 43 fc ff 49 8b 1e 48 89 de 48 83
> RSP: 0018:ffffc90003bb7550 EFLAGS: 00010206
> RAX: 0000000000000003 RBX: f000000000000000 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000003
> RBP: 0000000000000000 R08: ffff88807cc9802f R09: 1ffff1100f993005
> R10: dffffc0000000000 R11: ffffed100f993006 R12: ffff88807cc98028
> R13: fffffffffffffa00 R14: 0000000000000018 R15: ffffc90003bb7ac0
> FS:  0000000000000000(0000) GS:ffff888124ee0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00002000000000c0 CR3: 000000000e94a000 CR4: 00000000003526f0
> ----------------
> Code disassembly (best guess):
>     0:	08 00                	or     %al,(%rax)
>     2:	00 e8                	add    %ch,%al
>     4:	11 e0                	adc    %esp,%eax
>     6:	92                   	xchg   %eax,%edx
>     7:	ff 48 c7             	decl   -0x39(%rax)
>     a:	44 24 10             	rex.R and $0x10,%al
>     d:	00 00                	add    %al,(%rax)
>     f:	00 00                	add    %al,(%rax)
>    11:	4c 8b 3c 24          	mov    (%rsp),%r15
>    15:	4c 8d 75 18          	lea    0x18(%rbp),%r14
>    19:	4c 89 f0             	mov    %r14,%rax
>    1c:	48 c1 e8 03          	shr    $0x3,%rax
>    20:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
>    27:	fc ff df
> * 2a:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1) <-- trapping instruction
>    2e:	74 08                	je     0x38
>    30:	4c 89 f7             	mov    %r14,%rdi
>    33:	e8 f1 43 fc ff       	call   0xfffc4429
>    38:	49 8b 1e             	mov    (%r14),%rbx
>    3b:	48 89 de             	mov    %rbx,%rsi
>    3e:	48                   	rex.W
>    3f:	83                   	.byte 0x83
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


