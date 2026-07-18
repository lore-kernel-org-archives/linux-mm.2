Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7A3FC4450A
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 06:47:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ECCE6B0098; Sat, 18 Jul 2026 02:47:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C2E16B0099; Sat, 18 Jul 2026 02:47:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FFF06B009D; Sat, 18 Jul 2026 02:47:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5996B0098
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 02:47:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F1981A035E
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 06:47:20 +0000 (UTC)
X-FDA: 85000965840.06.BFD07A4
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf09.hostedemail.com (Postfix) with ESMTP id E3890140008
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 06:47:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of 3diFbagkbAH8v12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3diFbagkbAH8v12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784357238;
	b=vMnpoy1U0+qxr2R5zvM9VdjGReCfmFDCLVMRlwbJt9MxEIMyEzerSWJkUapO5Ludaa8qsd
	Ijsjbqmxs4DCC6WuSkFOCiaDsNUL6H/3Wga9vO8rPQX60uL5B1ijEIxSnrwpxYVfMjy/5g
	l7IMYBdVjru6GPh+AavN4m5MMqVm1Mc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of 3diFbagkbAH8v12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3diFbagkbAH8v12ndoohudsslg.jrrjohxvhufrqwhqw.frp@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784357238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=im0XS6doI6lHfHAZUyPFcDEiteNFyq5LXp1lzN7Bed0=;
	b=QTxzukk4AH0mypThRPJZwbiy2OOJmx37WKnsBOZbrgdYtYqONRJCm/7KHwlymK4YcLbVct
	P5sPFvf74Pxh9oE+FtlhKZ8MVeDZ3nFp/O1lgO1O5c04u8TI/dUI+XozF9KZoFec5PvXrc
	uDE8GXMtRbavCUo4eNJXjpUfnB908So=
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4a45997664aso8579038b6e.1
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 23:47:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784357238; x=1784962038;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=im0XS6doI6lHfHAZUyPFcDEiteNFyq5LXp1lzN7Bed0=;
        b=ItW1qGgLLq/c4uwTTD+AiNjEdQjUIoa5GKPTv+osMsCXAhTXd0eK5yU1pn+9txcHdb
         njLwLZc6Ms3P5VSWh4VIyM/WbdZanZngXB45p1ppwKQxZs21zGdtOcUWpFivUKgZtSCm
         eQPPbLkv4wkdNT9P4m42hkmHLHTi0sYQB8FWUrfIyC+2VlccsAdXPP7p0rlk6EjTsono
         W2hp/5/pzhloE5dDwGPspi5irnGzFnLzbWXZS0OA81CyYEarvrFjMgWs1N2K0KbDuRbS
         neZPadOrD6LlqoIDGWd2PwvCwYdFuAFkCNEfK6mkR/CnZvg+5ox/4L/EE9IhT0ppMhaZ
         aIqQ==
X-Forwarded-Encrypted: i=1; AHgh+Rojj8SwtG/ONWLtCuBzcGF3BEFDXR+vQ5EPSkOAVSFImpG6vfZizwLfndFUmmz/fRLC38ifKpCApA==@kvack.org
X-Gm-Message-State: AOJu0Yzm/LX1rwVVSodIy+dn+lrdPt2LVWi8fgc6ajR/mu+Xm1GOFcNy
	OirZooDfw0BgXDRRn43wXNml131NHnB09uytI7Ldza6d8mODK5RuqtvKWTaqOQLsY75u2Ol4CHc
	JJvAEsvG3TG3Uq1MDa4XvL0J9+AhMAV+R9IQ7OYMcEBRQ9S0sMPkQy91NCP0=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:13ca:b0:4a4:a930:1f76 with SMTP id
 5614622812f47-4a4d02f988cmr2657882b6e.11.1784357238111; Fri, 17 Jul 2026
 23:47:18 -0700 (PDT)
Date: Fri, 17 Jul 2026 23:47:18 -0700
In-Reply-To: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a5b2176.5028b7d0.1f0bb.00e1.GAE@google.com>
Subject: [syzbot ci] Re: mm/rmap: index MAP_PRIVATE file-backed folios by virt pgoff
From: syzbot ci <syzbot+ci64ff753c2913b080@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	chengming.zhou@linux.dev, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, gregkh@linuxfoundation.org, harry@kernel.org, jack@suse.cz, 
	jannh@google.com, joshua.hahnjy@gmail.com, kees@kernel.org, 
	lance.yang@linux.dev, liam@infradead.org, linmiaohe@huawei.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	matthew.brost@intel.com, mhocko@suse.com, nao.horiguchi@gmail.com, 
	npache@redhat.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	riel@surriel.com, rppt@kernel.org, ryan.roberts@arm.com, surenb@google.com, 
	usama.arif@linux.dev, vbabka@kernel.org, willy@infradead.org, 
	xu.xin16@zte.com.cn, ying.huang@linux.alibaba.com, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E3890140008
X-Stat-Signature: 53e58rk1u8yrf84uibiqid19w1eybc15
X-HE-Tag: 1784357238-471920
X-HE-Meta: U2FsdGVkX19Ghp2raNe+gIROuYTj4VI5h/bvVLtZttmBm7csQB1VtM37RUb7QQoPv2yht4Nsg7CWtE4UVjGbjVMa2kaGUHraZZiQrnU4QXgppWO+lKt/1SJybeP3Ubso65qyuJ8Pq1AeqcojIuvbvV9H4XHs/MKVPGx2/KVQEdAp8n5cP8SnTJZdG0hVb9oidD81wKLBohFYilenM+Btai/TudUJzqyYujvUfb2yusX7uUV+2AA5mE0nHkBJGBOfibTOB/coUxEBfLqMD5jLYPKD8TIXoAQnLyz3JHLQZxmQ80xCPYC9vkd1lxE4XapykMSZAxqxRZAwY071QxgJOXi+OR5oxBtJaD0dsCzG5HmYu1uY2Lq/oeFmhJ/j2ypkKnBetbOxIA6zKlzeypwJY8PWqREiFf88osZ602yC/mBVjpL2b4gzNptLxTrKte86V/dfC/dFsC42H5y8I2wbga4ogQftu1iVtYwnfve5RtdmWrSFa1vxtl+2U8ISX4v3J8G3U2llq6BdVfQcMACJUzIKMtmUP62uJyZp/ZXzkagTEa+cqVt8pPqgUpriNApDQj+IrSRoxS9BzMtNRwW+bonhbygJJMDRkD5aS9Be9G6ArtqR0aom+FsMmJ5Wj8FYL4O9fyMEziW+YmKcCe3GhDvZXehoQXpsj6vWY9lZchu7vYUtS9FR0H5ckALT6dyBFq1keiC8l+mSM//WYBurDgT1crZaka8Elt1brh6jUXovSBxj/pxVWoY6bFohWgkJ7dBtSFg2TnpvjzjyBIZPykfpWJ9234vdMJA7RXv5sRtqP8l8X+CMEkMJL0iu8l9e/2xgqOO4nm2RgnNkxMEEmg4wcNxql+fBdwq9OHYunLnJnC27NSouziOJVYDX72rZREoQmHILcMnYZ7FJxO1azua0eUzIXHTqaUTK1AN+UUFIYgRKOGJIyvrl9RsroGqFDjmnnz6z2rnOufdMad3
 1oJJkAgB
 Z8mgdvR3wYd68hOb+sfXGbpsd30ZtkhUWoDQh/9bOYnR6+jBvDN4A+/PkWM/eqagei5LZQFOoHWF5d1CsBUH7CWxWGPuhWRN9u+T+MUYCug+EP9B0bu37H0U9pJjGF5a6Bdce9bdsdfcC9Rwk57ivOKqVcaz16gbZFEEWqJ59ANPez5gj80mI7IKnxiRhmT1EObSmrLn1AcQiGA0zuxlgGyshe/7qwFTfapGJOjf2/c6E4N5B1YFFC2YiYN1g5fpFcxynBFT/kjepLbaTelXcr1YVywHk4XsaqRAReZxe0OcET6jjUoxaX2uHJkLLAALF5C+2NBIv42HtZesat130v+0tNDgve/O+6jchiTznE3ohqX0umUpq04KWumNkKnm47A2hlD953cTKaEkUl+wgNvPiOzSe5iPRZeHuUCdNEINbn0PmjdbtxJj3Fb9ifMPKraxYTDal912eWf056TSo8QksycF2Ah9/6dcZglB+WbnMJXvMMqkMzE/VHud7+pAG5/vT1ItKqq+fGWRo/SSoiVyrN8qT4I9uygT7QoW+LAYFUsPSeYmF/Zz8PsELG8CJm0gesrUs7NHXD9eVfFbCn32HSOs0CJIDrCHf009BmHcAuuoisMDd8gkjKDCxXydga2mB1D8Ba3jjXwNcERjJ6GMkn7RhTkn7nJoGBBneKdFVMzsn9zF6UXClByvoD7Gr2XsT4/WGba2Zn1bMvKod3+o2ZgyqTzLR0stOy+fWpyjUSfppdhMLiMD/ZXxcsRdkXB5310zsLexn5PCGGsiFtXGKMXK96tQaEsV0IbdC6eIT+uOFDiUl1tYeBTzsnj8leX3gI8dPTE8UyorgyfKNBjGz80MUDc7ncmzNmidel/G4uy8b7v2hT+tPTNN4ztCMemlOY6dtkEWx9fvpT3hW+uzj12DLQi47enYEEQtnxMfXcWeIRzKXItJ03f4bQBoafspDlfJbPVEUFKCBOTUu5sHcsPVG
 NAnAhXKk
 /X4NY8Qx4sZmcwcTw4KpwWopzCuIZi6yNyJsZ/us90s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] mm/rmap: index MAP_PRIVATE file-backed folios by virt pgoff
https://lore.kernel.org/all/20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org
* [PATCH 01/15] mm/vma: introduce VMA virtual page offset field and add helpers
* [PATCH 02/15] mm: introduce linear_virt_page_index()
* [PATCH 03/15] mm: abstract vma_address() and introduce vma_anon_address()
* [PATCH 04/15] mm: update print_bad_page_map() to show virtual page index
* [PATCH 05/15] mm: introduce and use vma_filebacked_address()
* [PATCH 06/15] mm: propagate VMA virtual page offset on map, remap, split + merge
* [PATCH 07/15] mm/rmap: track whether the page VMA mapped walk is anonymous
* [PATCH 08/15] mm: introduce and use linear_folio_page_index()
* [PATCH 09/15] mm/rmap: use virt pgoff for MAP_PRIVATE file-backed anon folios
* [PATCH 10/15] tools/testing/vma: expand VMA merge tests to assert virt pgoff
* [PATCH 11/15] tools/testing/selftests/mm: test virtual page offset merge behaviour
* [PATCH 12/15] mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous
* [PATCH 13/15] mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous
* [PATCH 14/15] tools/testing/vma: add test to assert MAP_PRIVATE-/dev/zero is anon
* [PATCH 15/15] tools/testing/selftests/mm: add MAP_PRIVATE-/dev/zero merge tests

and found the following issue:
general protection fault in mapping_wrprotect_range_one

Full report is available here:
https://ci.syzbot.org/series/b5c827e8-78a4-494c-b925-417c34a60e85

***

general protection fault in mapping_wrprotect_range_one

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      5093dba1014c1d7f7e247fd118f0fa8f22136046
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/0d856612-f1b4-4e6e-86af-4ed3215225aa/config
syz repro: https://ci.syzbot.org/findings/3484dc14-c12f-477e-b14a-6b249c47b2fd/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 1 UID: 0 PID: 32 Comm: kworker/1:1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: events fb_deferred_io_work
RIP: 0010:folio_test_anon include/linux/page-flags.h:718 [inline]
RIP: 0010:mapping_wrprotect_range_one+0x147/0x230 mm/rmap.c:1246
Code: 7c 24 40 49 8d 7f 28 ba 18 00 00 00 31 f6 e8 e0 2e 14 00 48 c7 84 24 80 00 00 00 01 00 00 00 49 83 c6 18 4c 89 f0 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 f7 e8 ea 2b 14 00 4d 8b 36 44 89 f6 83
RSP: 0018:ffffc90000a777c0 EFLAGS: 00010206
RAX: 0000000000000003 RBX: ffffc90000a779e0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90000a77840
RBP: ffffc90000a778e0 R08: ffffc90000a7783f R09: 0000000000000000
R10: ffffc90000a77828 R11: fffff5200014ef08 R12: dffffc0000000000
R13: 1ffff9200014eefc R14: 0000000000000018 R15: ffffc90000a77800
FS:  0000000000000000(0000) GS:ffff8882a920c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f84a91e9c38 CR3: 000000000e746000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __rmap_walk_file+0x4cd/0x6a0 mm/rmap.c:3116
 mapping_wrprotect_range+0x110/0x180 mm/rmap.c:1294
 fb_deferred_io_work+0x15a/0x310 drivers/video/fbdev/core/fb_defio.c:399
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:folio_test_anon include/linux/page-flags.h:718 [inline]
RIP: 0010:mapping_wrprotect_range_one+0x147/0x230 mm/rmap.c:1246
Code: 7c 24 40 49 8d 7f 28 ba 18 00 00 00 31 f6 e8 e0 2e 14 00 48 c7 84 24 80 00 00 00 01 00 00 00 49 83 c6 18 4c 89 f0 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 f7 e8 ea 2b 14 00 4d 8b 36 44 89 f6 83
RSP: 0018:ffffc90000a777c0 EFLAGS: 00010206
RAX: 0000000000000003 RBX: ffffc90000a779e0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90000a77840
RBP: ffffc90000a778e0 R08: ffffc90000a7783f R09: 0000000000000000
R10: ffffc90000a77828 R11: fffff5200014ef08 R12: dffffc0000000000
R13: 1ffff9200014eefc R14: 0000000000000018 R15: ffffc90000a77800
FS:  0000000000000000(0000) GS:ffff8882a920c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000025d35e991000 CR3: 0000000110c34000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	7c 24                	jl     0x26
   2:	40                   	rex
   3:	49 8d 7f 28          	lea    0x28(%r15),%rdi
   7:	ba 18 00 00 00       	mov    $0x18,%edx
   c:	31 f6                	xor    %esi,%esi
   e:	e8 e0 2e 14 00       	call   0x142ef3
  13:	48 c7 84 24 80 00 00 	movq   $0x1,0x80(%rsp)
  1a:	00 01 00 00 00
  1f:	49 83 c6 18          	add    $0x18,%r14
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 f7             	mov    %r14,%rdi
  34:	e8 ea 2b 14 00       	call   0x142c23
  39:	4d 8b 36             	mov    (%r14),%r14
  3c:	44 89 f6             	mov    %r14d,%esi
  3f:	83                   	.byte 0x83


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

