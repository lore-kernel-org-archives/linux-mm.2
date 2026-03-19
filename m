Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 104871075275
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 08:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DDDF6B0428; Thu, 19 Mar 2026 04:05:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E926B042C; Thu, 19 Mar 2026 04:05:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D5C6B042D; Thu, 19 Mar 2026 04:05:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E49016B0428
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:05:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9CA4113ACE6
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:05:54 +0000 (UTC)
X-FDA: 84562079028.01.EE2CAB0
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id BDF8B160006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:05:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GitlksRg;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773907552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2NsBe2YEaJhTZhc3cWuMJnWEhWKyY3AOJ8RnT3CIBcs=;
	b=z+ng0nfoQbNGsn+BGyyBgdTCd1gzCdwQW/teIu7+W3c6uT0VLwuec7c0Ffk6XhWIHlZb4H
	9KE0u5Ilc5bGUtGgCYLgaUPXd5fX29vcCbrXS6GpXLNjlFbAY8wmA7gPYIuaIAQBYE0Gbs
	tuMieU585HpJLRzGL21Ds8e4PCi3tfY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773907552; a=rsa-sha256;
	cv=none;
	b=HWZZ2wJPuhSZobw3wjOZjxvxDRTfvVkEueAq0L9MtsprAVu42lUmsikqXHVgyMdqt4qoK+
	VaUTr9pFMSPstNcFRrMfRRTCzXC2de/l5cXU2O9HH03df/WGKEVIKEvMF9VyHGcIfuZma0
	5MqVPEyuvpz7OcPFiTqLjUZyiHTlisQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GitlksRg;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <e92ca212-9ada-4cd0-8d54-2f433d6d47a1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773907550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2NsBe2YEaJhTZhc3cWuMJnWEhWKyY3AOJ8RnT3CIBcs=;
	b=GitlksRgIxyp42kdSyWrbfk+PNIiKVbuiBUlyvhgwLLqUjruQ6658bKKA1+YonHOvpbrjP
	+6xQgrPPZQFnunkGcIHgx56iyRpBD3Qk1DXHcx8d2dw49v1ygppUi04SCGRq0VwLsRP8xk
	Q5awulxr0WqJomswxB1il1Wi6XLrgW0=
Date: Thu, 19 Mar 2026 16:05:38 +0800
MIME-Version: 1.0
Subject: Re: [syzbot] [mm?] kernel BUG in collapse_scan_file
Content-Language: en-US
To: syzbot <syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com>,
 david@kernel.org, ljs@kernel.org, willy@infradead.org
References: <69bba3c0.050a0220.227207.002b.GAE@google.com>
Cc: baolin.wang@linux.alibaba.com, npache@redhat.com, linux-mm@kvack.org,
 baohua@kernel.org, ryan.roberts@arm.com, syzkaller-bugs@googlegroups.com,
 dev.jain@arm.com, ziy@nvidia.com, linux-kernel@vger.kernel.org,
 Liam.Howlett@oracle.com, akpm@linux-foundation.org
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <69bba3c0.050a0220.227207.002b.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BDF8B160006
X-Stat-Signature: mboiqicdb3gcnf4xjqeoid3soroexkqh
X-HE-Tag: 1773907552-328383
X-HE-Meta: U2FsdGVkX18Llzp9RFHPwzwZHeQ2pZ/J82BPw+aALSl+slqyl5HlyuvxPBquIkzKkWDfUTfGSdIsEX6h2GcqPS10escKpYa8NHTRJqqaj34djo2yMhxHVg9OJEfruPHFlsZUQnmgRJxHHcQv/MN8uxxgiOLYfCV0uLF4gg4s3EkR3pdMEkkClO8plJb66rcbRKkJOtbBFTFpN9wu/lmMjoRl8EBzFzvmQqqOkwX6ko+T6CAHrjTOKubqCEatoa0pwr7NDdJ9Zf+ooj4fVsUYGQwiOUNLZvXa3Z2Heg2paucnM/4Mu+BEfjGWsd+DXK5P5O0q5u+74sRD7Wg6vIuKQP+dlhX69Aq8Re1wvgE5h+/G8KgBXVCuSKmvgMQoDfnVYM0z/05X8nS+qiYCT4AFWcsHNzWm7votLZLngsYX4X8SYFF15fn8hNLeQsZIq5hkxbMfaf6p9z12v8sZKuh8O1m6fMZUA+wb0Of418pV14YKITazDAAi/cVxAb4qtVcY+vJ6t1d6MiD4gI7QPkWxTgEV1H8wmad7BGlEq/5TIqa5gDDd7yUo++PUD/VWBdCsetKFmWQQSU8g8f1Js7wywtvBImXckW92ZgI0dQNuvKOVbMhLlx+z0KaOAOzHNrm97O77EYyQnGc9PTsxa2b5pHx1xAr24mxgcpelm25bPKGlhyVtn9Z2ygwDqWm39PmSyHQW1X9zMbhwZzF0VSdck6QeygOboxa9QOBrIsS2PtnCiN1mngJ3iLK7VC8b31WWdq25jKF9ah5EqV4bVHcjQhu0c9jCC9glEMRXk0AH9onLqm+JwTsso7v24ztTIfOyq2cLQhjy14ouIq0EREWdSCV6MTi0y6qLntsPanYy1PqSqAhOhabSXg9ryVkp/sF2s6GIh2a6ZX7BsEmJWXldF25elm1v5DMBX0KroWZiH27GMlZvfJ1HOk7SPYiy0q2gGEsUeppf+6Xp1kZzaGb
 y8KU0QK2
 5M3IsE52Ug25q3By5BDY8ya0M6YPt8P1HjPQjO2zSlYuNb8ilGHvvIapVGxTbsEOtLEy7G3bCPTDLyWkCPYwWrcjf5A6EiFcG/rVfvuJ/KGk1zVmOddBTRkyb9nE2jbnCSRPlqrhcVtnTKRvMMXgY/xLB2bPzhpxSsGqX8F+enFWT4jqTRaBV3g0Li4wR/OdxbFpMO5ImM2jVDo1N2675kAazV4F8lFiYtKpAEEx9Sea1KR070MZb+lsKl0B77k32tOUko3Wi663E4yeP6fg9Zllsc1F1jeU2A/Gj9S3imW37w1lF93N1dF8XHUGd/bQLZdfw30pUo8KWjwwVz5FHQqnUcbKaQJmLKHjrKeyKkvaOcRDstcqJp/6gDjbDn+h3onsaH222EdbspfI4js2kTvSqP/dpUBjKU0lwvcSV4mLeWmT/nyVsvGbOd7S7hvt94dzmEttSD3w0B5ZAmACJSFfTjxmez/tjqgYDT1Nbn8at/69Ngnu7bNWbJb1SDMJJAGb3fr1k7oeakdno61YGcbpO4cviXpuyt7l5PESU7WXtE+lSUr5/NJKFmbGyhmc686HyRHz8Wsj+UbISKeiEcq6uZ3LyXkM/k4kua0DW/0hSq16AkmA/mm1zGC/izsY9vUYz93iYuSN/sSc9/VA83CJEF/Y9H2rACCK4nIQ+te/ZEXyFxB/mMVjwTYEMJbSQS7d7uKCb9UY52SaBRHbd+jj5gaJSN4wWCsVyZ2DoSRnazXnsmkrl1i78wLblYBayF08SPnyAzBMbi9DBkTIj9aa6t8ZcBaKbOiwP6+KyuNjXMyAnBS+2ysDMtGM9cgv+HkAJoRJSkQk+qO0psOMtGR0O5v8nn34GqDgI/mwP5VGeIbA76utOSRfx/8neXz93IyxeEKJjzZ3HVvXZpZa3mN2CvYIku/+NyzC3zoVoUggGXxrzTMm/BnC9XPnO6tgDPMOB9qHN2mS5pS+L+BbpiBWbnMPS
 WJ8DkOYQ
 r/tAtvJNyJ6+bAwV1IWGmZ1LO8PDQ95B4xKUm9TWgcM9irAkHj/meCxFcgxFtqQ9S4nTsOttDAZ1ok5MxATrq7Y1+OPmrbqaj3P1lv2VVG6KNBcJSBy/INDiXWFgEf1nvFTF+KGXZbluyhQfWHmiqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ccing Willy

IIUC, this is a dup of the earlier report[1], which I looked into back
in January. The root cause is the same: collapse_file() calls
xas_lock_irq() without resetting the xas state first, tripping the
XAS_INVALID() assertion:

#define xas_lock_irq(xas)	xa_lock_irq(XAS_INVALID(xas)->xa)

static inline struct xa_state *XAS_INVALID(struct xa_state *xas)
{
	XA_NODE_BUG_ON(xas->xa_node, xas_valid(xas));
	return xas;
}

Added by commit:

commit 43b00759f21b10142094d1ae5ff65cbb368953a3
Author: Matthew Wilcox (Oracle) <willy@infradead.org>
Date:   Sun Dec 14 10:53:31 2025 -0500

     XArray: Add extra debugging check to xas_lock and friends

     While tracking down a recent bug, we discovered somewhere that had
     forgotten to call xas_reset() before calling xas_lock().  Add a debug
     check to be sure that doesn't happen in future and fix all the 
places in
     the test suite which were carelessly doing just this.

     Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
     Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

I posted a HACK fix at the time[2], but David pointed out that Willy
had mentioned it likely needs more thought[3].

[1] 
https://lore.kernel.org/all/69757ea0.a00a0220.33ccc7.0017.GAE@google.com/
[2] https://lore.kernel.org/all/20260125121001.32733-1-lance.yang@linux.dev/
[3] 
https://lore.kernel.org/all/7bce9231-714c-424a-a4e3-dd42734fb767@kernel.org/


Thanks,
Lance


On 2026/3/19 15:20, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    95c541ddfb08 Add linux-next specific files for 20260316
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=15ccc216580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ed431987028345c6
> dashboard link: https://syzkaller.appspot.com/bug?extid=8961cb270ae74b4129fb
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f778da580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12cc006a580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/c40f27ad73d8/disk-95c541dd.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/bd811888f684/vmlinux-95c541dd.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/3b72363d7dbd/bzImage-95c541dd.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com
> 
> node ffff88805d558b00 offset 0 parent ffff88805d558840 shift 0 count 3 values 0 array ffff88807a8195c0 list ffff88805d558b18 ffff88805d558b18 marks 0 0 0
> ------------[ cut here ]------------
> kernel BUG at ./include/linux/xarray.h:1441!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 6001 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
> RIP: 0010:XAS_INVALID include/linux/xarray.h:1441 [inline]
> RIP: 0010:collapse_file mm/khugepaged.c:2055 [inline]
> RIP: 0010:collapse_scan_file+0x4f98/0x5230 mm/khugepaged.c:2404
> Code: ff 4c 89 e7 48 c7 c6 60 b2 dc 8b e8 82 62 f1 fe 90 0f 0b 48 85 db 0f 84 03 01 00 00 e8 71 e5 8f ff 48 89 df e8 a9 20 7b 09 90 <0f> 0b e8 61 e5 8f ff 48 89 df 48 c7 c6 60 b2 dc 8b e8 52 62 f1 fe
> RSP: 0018:ffffc90003826e20 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88805d558b00 RCX: a13f20bd39c5a100
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: ffffc90003827130 R08: ffffc90003826ba7 R09: 1ffff92000704d74
> R10: dffffc0000000000 R11: fffff52000704d75 R12: ffffea0001b678f0
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffffc90003827010
> FS:  000055557e3c2500(0000) GS:ffff888125437000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000020000000b000 CR3: 000000007ac66000 CR4: 00000000003526f0
> Call Trace:
>   <TASK>
>   collapse_single_pmd+0x22b/0x4510 mm/khugepaged.c:2437
>   madvise_collapse+0x34c/0x820 mm/khugepaged.c:2859
>   madvise_vma_behavior+0x1094/0x4460 mm/madvise.c:1362
>   madvise_walk_vmas+0x573/0xae0 mm/madvise.c:1711
>   madvise_do_behavior+0x386/0x540 mm/madvise.c:1927
>   do_madvise+0x1fa/0x2e0 mm/madvise.c:2020
>   __do_sys_madvise mm/madvise.c:2029 [inline]
>   __se_sys_madvise mm/madvise.c:2027 [inline]
>   __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2027
>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>   do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f90d419c799
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd50711398 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007f90d4415fa0 RCX: 00007f90d419c799
> RDX: 0000000000000019 RSI: 0000000000600003 RDI: 0000200000000000
> RBP: 00007f90d4232c99 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f90d4415fac R14: 00007f90d4415fa0 R15: 00007f90d4415fa0
>   </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:XAS_INVALID include/linux/xarray.h:1441 [inline]
> RIP: 0010:collapse_file mm/khugepaged.c:2055 [inline]
> RIP: 0010:collapse_scan_file+0x4f98/0x5230 mm/khugepaged.c:2404
> Code: ff 4c 89 e7 48 c7 c6 60 b2 dc 8b e8 82 62 f1 fe 90 0f 0b 48 85 db 0f 84 03 01 00 00 e8 71 e5 8f ff 48 89 df e8 a9 20 7b 09 90 <0f> 0b e8 61 e5 8f ff 48 89 df 48 c7 c6 60 b2 dc 8b e8 52 62 f1 fe
> RSP: 0018:ffffc90003826e20 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88805d558b00 RCX: a13f20bd39c5a100
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: ffffc90003827130 R08: ffffc90003826ba7 R09: 1ffff92000704d74
> R10: dffffc0000000000 R11: fffff52000704d75 R12: ffffea0001b678f0
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffffc90003827010
> FS:  000055557e3c2500(0000) GS:ffff888125537000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f8156602000 CR3: 000000007ac66000 CR4: 00000000003526f0
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


