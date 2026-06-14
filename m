Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C058CD98D2
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 06:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D099E6B0005; Sun, 14 Jun 2026 02:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB95F6B008A; Sun, 14 Jun 2026 02:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCE476B008C; Sun, 14 Jun 2026 02:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB7B36B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 02:35:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 388C98F5A0
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 06:35:23 +0000 (UTC)
X-FDA: 84877556526.09.FBCC554
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7B7A8160003
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 06:35:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of 3qEsuagkbAFEBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3qEsuagkbAFEBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781418921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=2r4zfjzZDA4KbiiIFggzjIxr+jx1S4GN8osZMKExG8M=;
	b=kbWfdp9iTrhJ7zp3paUAuzFO12GviKhoHcad16kBnLeyzH0KQGhTC4iI5q37+mHEuwJbB9
	wzA1Vid1zy9+HX5csq9JSnShsdGRNybUwXcjUKN+fWINgqSoaV1NHzdGjme4KRrw+Xl/41
	wKsc9rhZsM35Y0sElrwbJVCIqmXkjPQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781418921;
	b=3tflc2OA+ewrPHaTg0Y1VtZmpEQLwnApu6b6vXgiQ7o9MdnKHyA/KH3u+b9yknUbKhUbMT
	uFGqOnTYBHDOUeR0L5/RDF9UNdXgfRg3vum1cQrGEPFchLJ/fAc6SWAmlYgCMpGo+sgPij
	w5GvJHuob7qS1L+sXSecRaEeCwepVjI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of 3qEsuagkbAFEBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3qEsuagkbAFEBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-485ffc7113bso2552643b6e.0
        for <linux-mm@kvack.org>; Sat, 13 Jun 2026 23:35:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781418920; x=1782023720;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2r4zfjzZDA4KbiiIFggzjIxr+jx1S4GN8osZMKExG8M=;
        b=nPFe66raziX/tcF26ZdkKCC+9Xpw/zzXvweDsLmdRfPlWDcllAtpKKnx9oH9D3owtH
         bn5djK3vQZ64f8kvVz3NHIij/dHvNStCZQUExLV+QGx4TkEhFGQZ+I6hkkQV1XCltCqx
         KqsE8UnoCGZA8L4EQOhwTdtzsKZbRWuTp7AJSPoPXVB1no25dRhCYC0uQ66uiQVUhs5X
         b46CMOPwsQT5gf3vK6OO+ANDXGA1rz2Qi8XRrtQV8SIHNik/NbJKOrdhuMLHaQocsNVj
         5NIus3uUfZVQZiwvBf0l9dNjyvdyDlcAZpu3QQQEdut27WqibIQX6N999vjEUap6mc5z
         lUOQ==
X-Forwarded-Encrypted: i=1; AFNElJ9rV9FVfOWsjtj408K8TPeUuV0cdBlmxa1Aegq6UfxZvEugQsCNxapUiLq8R4e0SMUAzZjpxAU8sA==@kvack.org
X-Gm-Message-State: AOJu0Yxr6b/G7Zji6LrXHdcRbDjAMmF24jPiGI6Sr40c3rG7JPYQ2vyx
	g17VoCiwKGySyXFvXvWiCx3AcNZaVvD6veUJpAJWtrLkKxWznzG6XcsM1SAwxVLsBMGV+9BAzN5
	5VMDy0QSQzUgsG4DELhwKy3sRLsyw6ZJE+PptPjwdSWytlNNKHLJHa8Qc7UY=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:15a9:b0:479:f7e7:4a81 with SMTP id
 5614622812f47-487416dc1d4mr3871956b6e.0.1781418920603; Sat, 13 Jun 2026
 23:35:20 -0700 (PDT)
Date: Sat, 13 Jun 2026 23:35:20 -0700
In-Reply-To: <20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a2e4ba8.8812e0fc.3c3fa4.000f.GAE@google.com>
Subject: [syzbot ci] Re: mm/vmalloc: migrate vmap_area indexing from rb-tree
 to maple-tree
From: syzbot ci <syzbot+ciff8167f913c663d5@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, aliceryhl@google.com, andrewjballance@gmail.com, 
	balbirs@nvidia.com, dev.jain@arm.com, dvyukov@google.com, elver@google.com, 
	glider@google.com, jackmanb@google.com, liam@infradead.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, maple-tree@lists.infradead.org, 
	neil.armstrong@linaro.org, praan@google.com, pranjal.arya@oss.qualcomm.com, 
	puranjay@kernel.org, santosh.shukla@amd.com, shuah@kernel.org, 
	smostafa@google.com, sudeep.holla@kernel.org, surenb@google.com, 
	suzuki.poulose@arm.com, urezki@gmail.com, will@kernel.org, wkarny@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7B7A8160003
X-Stat-Signature: mswkzbnkckrmcakyz5ma5a3p5ugfs3m4
X-HE-Tag: 1781418921-112770
X-HE-Meta: U2FsdGVkX1+gPIm/2XYp1Gr+tkLpfupEjwjrkNA/7hRq/v59mHo6ZKyUdZoeJ/Q0tzqndDyDzusICmSaM7ok5hznShhpb43Czq7xzgvyuTes1lB63nq6RG8UcKFU/EAXiGzOsjvuzOSAI3+5rh3U5LEq7XbBP4m+ZJygauBeN66F1BcXvjEL1IfADGAU7R07yS7arVu2CWYB+XWcdMg7a2Qlttuhi8uD6u6cGzvkvdUkUS7ZecSMhvy2TprgnbUxLkrBfRLICQA+VuRMtFS6snn7w1a+1rrRv0paFbqx7Ndikfcw6lxXhANACvzAxexREPmD2LI9lnb1tzDlllnhxAVjARp/WgdN+/ogJvPAk+unLuoN5SKSoa+M3qlDRJlH8p/IB1f9PKXk14H78GUuXK48Bi9x9P6YdUZBRE99tgHdwU3l4BuFgOR16kqu7k9w8JPPK9mYuCxuJZzwZoxY3Y1zetKnvNzo8MmBZsSbi3UPzr7JF69C32Cq7kjxi9nEx4wmhCgN6yShdgHsXEru0SAizYKackPtLDLMmI/dteivVgJsRAQmEUh+x9NUSjFXhD4pLrLqHVeHmk7AqpJZF1Swd3Mm1PBP8A6WNYY3TE08WOQFkg1m2HOSRr/J/DHopoqOHpybTPht0nhoVpgz+AiHixT1ojEL9+l6E1ywFHaHS5fQC/emHdzZPjzJ3TXs9XmgE1CcLPve7LnkF1MbDV2wEZ+XRmwtX0phSgmRr+GBD/lYAPqZS2WzE9YdhkJGr6PwyrKVOOmjEFQ5jDPH1DNtMAYbGq/pgR/ejFT/PaYdcyNN9u3+nfZriBl0uuziLIjBWxxwF53vqAkwg5zZKIgcLPUE/rii+lGbrZTi80XzsHikAizpkFzAwLht3kizXNqLwxzObOMTnvxDxDh9riVHH9CMy8rYYYjN1pYa0tEVi2Cwf7NR+t/skM6DiQiW5RNPiurqMl6yH4+QHcd
 XeQoHf6p
 4ZbdDiVPD2tovLwJqCrBMKpUGJo4cNbSFznNmtZn7DhS4xWjlABqeMEQZ07d4eFviSUC5Sw575iCXjKTMiBaOa4hYeGDJPXjbOQkoSZ5ZHLQG3WYRIXF7kFV1LYUhtv+XENFWmfu7NocRb0QOAq1eVByYRzPsnyLFZBYaFuzNtVvdx2WRDbCj1Wnyh6d704TvD1etaixjNsykPJWR7unchG22ZrbnP2YWbGqrMrNH4uDFFeIE1LbHHGzyusUYfIkmT9BNxpYolMkYn6ZEdlsnSyZh3UGe36kYDblNZR/+SoNhhJfW4EgCL+V9JY0EeU162jlf889Xg1Dpry/+RnLOvnzVCeBWyTSO77UT5FSrMEoedC1LwAiZLvkRPsNqY1wcd6X1S3ERn6mzKIOT53VF3zjW3GBxDVgbMEhMr7L37DnMoYzuQSzJ+0avMSRgzikTmktapYvv1+Wyq9TyVjiY11w0vHGcM5CwkTmVp3cJh6Ma1yDsjYwWSwX8wLAymdr8zVfXtXJQhMBBLdzyAote2rZVBuB7uNVGHwwjfPumXUSyZ+8wEr19/TtlTR9aX+InKW9d30xpCkZ5FwQQ0FwivM0A2ULXJEAUegTCDPlhuNOagkgcSR704cKgNDc4qscUJ9KfO4xV2GsDPikZpb1G2l+T8eBxXvm0yyWjv9wWGCrPAb/Uz4B2fJql06uvtpT0XFQY7MGSo4cQIQMkw/5P43agM5GOxlI0FtF7mn/IqMKDSBu93ZfKHdpFRGSP+kzc/JKkY/x0FWkG2fjOlb+5Shm40a9RQ4ZbfCi97m6bL0U6Z2YZP7nUFP9oaAlr4s9dwfCLKRuaCL6mgDUAJP08YNJCe+gxGGOClZ6lujWInFLSnqY70pnYoZSoq2YqSz8NXQ9XQdLgBXzoCw1FjMljM8TG/2At4RuyYxHfV8JUKpSOTWzo1idmqqOD6ce0PG7G2VYNI+O3F9TmW5gOvo2xGtjfPnfx
 m2FFylSu
 gbHn5N8ziNWZ9DB2wMvftnUf28LAAQfPsHq5NVQ54n/LM9IMWvtwZRMzO+TWRnZ20KEa+tNabkKc2gsWYTCQTqBCJrMSo4R9H+VBtOdZPL5iCVu2bT0Ewg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] mm/vmalloc: migrate vmap_area indexing from rb-tree to maple-tree
https://lore.kernel.org/all/20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com
* [PATCH RFC 01/12] mm/vmalloc: introduce maple_tree-based indexing for vmap_area
* [PATCH RFC 02/12] mm/vmalloc: convert allocation-side gap finding and insertion to maple_tree
* [PATCH RFC 03/12] mm/vmalloc: convert free, purge, and pcpu paths to maple_tree
* [PATCH RFC 04/12] mm/vmalloc: finalize maple-only indexing and shrink struct vmap_area
* [PATCH RFC 05/12] mm/vmalloc: tighten failure handling under memory pressure
* [PATCH RFC 06/12] mm/vmalloc: tighten alloc/free hot paths
* [PATCH RFC 07/12] mm/vmalloc: consolidate occupied tree as authoritative index on hot path
* [PATCH RFC 08/12] mm/vmalloc: track lazy-purge queue as a list_head
* [PATCH RFC 09/12] mm/vmalloc: collapse busy-tree find-then-unlink into a single mas_erase
* [PATCH RFC 10/12] mm/vmalloc: per-CPU caching of free ranges from the maple_tree allocator
* [PATCH RFC 11/12] mm/vmalloc: O(1) lookup of cached vmap_areas with bounded fast-reject
* [PATCH RFC 12/12] mm/vmalloc: harden bump-allocator alloc/free against UBSAN array bounds

and found the following issue:
WARNING in alloc_vmap_area

Full report is available here:
https://ci.syzbot.org/series/45e14120-bbb8-4a0c-b5c6-0aaf3b421101

***

WARNING in alloc_vmap_area

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      c425609d6ac4012c8bbf01ec2e10e801b1923a7b
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/481f4f4b-8d55-4e3c-b96c-1de7b763686d/config
syz repro: https://ci.syzbot.org/findings/ae02a227-b4c3-476a-826b-3bbf18bdbfe4/syz_repro

------------[ cut here ]------------
(*left)->va_end > start
WARNING: mm/vmalloc.c:1371 at find_vmap_area_insert_neighbors_mt_locked mm/vmalloc.c:1371 [inline], CPU#0: syz.0.17/5834
WARNING: mm/vmalloc.c:1371 at validate_vmap_area_range_insert_mt_locked mm/vmalloc.c:1388 [inline], CPU#0: syz.0.17/5834
WARNING: mm/vmalloc.c:1371 at insert_vmap_area_busy_locked mm/vmalloc.c:1480 [inline], CPU#0: syz.0.17/5834
WARNING: mm/vmalloc.c:1371 at alloc_vmap_area+0x5458/0x87f0 mm/vmalloc.c:2917, CPU#0: syz.0.17/5834
Modules linked in:
CPU: 0 UID: 0 PID: 5834 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:find_vmap_area_insert_neighbors_mt_locked mm/vmalloc.c:1371 [inline]
RIP: 0010:validate_vmap_area_range_insert_mt_locked mm/vmalloc.c:1388 [inline]
RIP: 0010:insert_vmap_area_busy_locked mm/vmalloc.c:1480 [inline]
RIP: 0010:alloc_vmap_area+0x5458/0x87f0 mm/vmalloc.c:2917
Code: a5 ff e9 fc 0f 00 00 e8 e6 80 a5 ff 4c 8b 74 24 18 e9 ed 17 00 00 e8 d7 80 a5 ff 90 0f 0b 90 e9 34 e5 ff ff e8 c9 80 a5 ff 90 <0f> 0b 90 4c 8b 74 24 18 eb 09 e8 b9 80 a5 ff 90 0f 0b 90 49 bf 00
RSP: 0018:ffffc90031ade360 EFLAGS: 00010293
RAX: ffffffff82200aa7 RBX: ffffffffa0000000 RCX: ffff888109e2bb80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90031adf4f8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000100 R11: 0000000000000003 R12: ffff88810007d888
R13: ffffffffa0002000 R14: ffffffffa0401000 R15: ffffc90031adeb80
FS:  00007f97268b66c0(0000) GS:ffff88818e8af000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9727132780 CR3: 000000010cd9e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __get_vm_area_node+0x1f8/0x300 mm/vmalloc.c:4214
 __vmalloc_node_range_noprof+0x36a/0x1750 mm/vmalloc.c:5030
 execmem_vmalloc+0xa7/0x1d0 mm/execmem.c:41
 bpf_dispatcher_change_prog+0x25d/0xd70 kernel/bpf/dispatcher.c:151
 bpf_prog_test_run_xdp+0x794/0x1160 net/bpf/test_run.c:1464
 bpf_prog_test_run+0x2cd/0x340 kernel/bpf/syscall.c:4859
 __sys_bpf+0xa20/0xd90 kernel/bpf/syscall.c:6436
 __do_sys_bpf kernel/bpf/syscall.c:6537 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6534 [inline]
 __x64_sys_bpf+0xba/0xd0 kernel/bpf/syscall.c:6534
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f972725ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f97268b6028 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f97274d5fa0 RCX: 00007f972725ce59
RDX: 0000000000000050 RSI: 0000200000000b80 RDI: 000000000000000a
RBP: 00007f97272f2d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f97274d6038 R14: 00007f97274d5fa0 R15: 00007ffd7848c2a8
 </TASK>


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

