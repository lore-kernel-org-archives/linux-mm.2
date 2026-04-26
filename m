Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C25FF885E
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 19:02:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C6406B008A; Sun, 26 Apr 2026 15:02:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59D786B008C; Sun, 26 Apr 2026 15:02:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B4396B0092; Sun, 26 Apr 2026 15:02:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38CA66B008A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 15:02:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1E211A05E1
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 19:02:26 +0000 (UTC)
X-FDA: 84701627892.25.C7C41C8
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by imf04.hostedemail.com (Postfix) with ESMTP id 14C4840010
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 19:02:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of 3QGHuaQkbABMBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3QGHuaQkbABMBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777230145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=2ApE86KdB73UZze872ESq1+IlKWsMYblfjrS0boasGw=;
	b=xCp66+ecsoLkwmG6rZ/29iRPv16y1itRetnUXSw52QysIn3LXkBzTwwU7LbNn+X+F76cZZ
	C2Jo51ZR076YambCP/n1XUCLit9HbdPjTeE/VGpmxae0fRix3kNdxxzXLfZkcRuoUGEQAl
	xUiLbh4QKeOEFub2/y2bc8J3y0wlIu4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of 3QGHuaQkbABMBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3QGHuaQkbABMBHI3t44xAt881w.z77z4xDBxAv76Cx6C.v75@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777230145; a=rsa-sha256;
	cv=none;
	b=YsEUTkJQV9WkWC/Sr9D0Amjda3wuCFTs+UVfpcmbImauyuK8ORsTOsrWAiE9GNGgMEv0g4
	UjNNSiQXpBeFFDPhRNA3bx9xQpTepcKeGlCYrthoFfVGmL9ih4onX/GMhILsOuSpBgITNo
	89U6mG50xw2lfXWFJCTrwuAEFsePtcM=
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-694885643e1so13085460eaf.3
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:02:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777230144; x=1777834944;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ApE86KdB73UZze872ESq1+IlKWsMYblfjrS0boasGw=;
        b=PpeKGldKG4SEPb2SWe7FmSRFiIG6QyiRysdkD75xOnklqqVSuJbWecD3xnmgloYUR4
         1qEru7O0qdKMliQdcMvZPlX8V54DrpuGSyUKul9BwYvbARZeOV553RtAf7AgbQFoWtkS
         dZyyOa0Avgd8LZ1mFHilRy0aiopZejPjbLHuQ/ZRjDItq9DqF3s16kl1uBl/mhyfeb7V
         F/nr3eUFYFlebHbpK3MG/pdr43+UmNEiG3cP1oiMvtRUosHTz9qbzXs76yIYf8V4QICz
         DQvMOXSj7qIUal9BOq2GHxBzG7r5lcPTHXwQcoFQYOT7R9Rs3hznw4BVTYBKIIZOeSSD
         G04w==
X-Forwarded-Encrypted: i=1; AFNElJ+FUSBtcEorHarQZBfhSMyHHIqu9QPABi1ZF7krznD2u55g1Qj0pQMgvwIWg7lP/Y+Cuq8SlTRPcw==@kvack.org
X-Gm-Message-State: AOJu0YzqMVtgGsT3NEAnEHNyvbbAy6+Dhzsnyj27B/HoyYrg0okpgtKN
	CJtlcqIe1BM+llg3UfXJiwTIKoqydL3jUaYUHPy2I+ZTe1d+hzpHeVxXNKK8gJYmLqn2q69xLpz
	v20nAbocxn6iiG3+yvQPvDt+TYpE1XlNtxr/Z7UpIzA5dnPkUu54N51QVfFA=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:620:b0:694:a362:4b86 with SMTP id
 006d021491bc7-694a3624ce5mr11481191eaf.22.1777230144106; Sun, 26 Apr 2026
 12:02:24 -0700 (PDT)
Date: Sun, 26 Apr 2026 12:02:24 -0700
In-Reply-To: <20260426-dontcache-v3-0-79eb37da9547@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ee6140.170a0220.11de9.0011.GAE@google.com>
Subject: [syzbot ci] Re: mm: improve write performance with RWF_DONTCACHE
From: syzbot ci <syzbot+ciecac32dcb1f4d0d7@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axboe@kernel.dk, axelrasmussen@google.com, 
	baohua@kernel.org, brauner@kernel.org, chuck.lever@oracle.com, 
	david@kernel.org, hch@infradead.org, jack@suse.cz, jlayton@kernel.org, 
	kasong@tencent.com, liam.howlett@oracle.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, ljs@kernel.org, 
	mathieu.desnoyers@efficios.com, mhiramat@kernel.org, mhocko@suse.com, 
	qi.zheng@linux.dev, ritesh.list@gmail.com, rostedt@goodmis.org, 
	rppt@kernel.org, shakeel.butt@linux.dev, snitzer@kernel.org, 
	surenb@google.com, vbabka@kernel.org, viro@zeniv.linux.org.uk, 
	weixugc@google.com, willy@infradead.org, yuanchu@google.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: odfsj1pbttdpsw1s67uax6kkdrp65dh4
X-Rspamd-Queue-Id: 14C4840010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777230144-222370
X-HE-Meta: U2FsdGVkX19p1bcu9pIovuu/jiCoQSoy5+p+XBfg2KJB+CCsHYs/khvSO/KtkLLHrvTfRx2IHt2gjLz0vM5RZXa2ZUorehzebYJoMbDpVab7NZx9rfnBhk8C0OTqGzDPJ540MVcqzsjXtN8drH3Gde205KVRqGGjiFoAIlqbGsiNQm1JbkJMJTW9wgpRJ36MKUqWIiRbhHFarnrovkk/MK4/hBUA0j8+FcNhlE64k5QR9oggv2ARcvqcuTzrolOG7DY3B2id790doLZnHI3EZVSZRFG69z9ijtEmSRi81oEGl/eOyhob49dPu+nfwZg6Zc5maozETS1PkvPRvRnZGUWVv9ckpJWoQyky7Zks8RNF9nH9WJ6Hza4CV0iS5CJjbTe+NItq7XZchykZfDe4tkHKzvpRSBvhKvSd390IwE+FetvsqCVZ9Tw7Gv/GEGSX7BocPswq7TjjhxbhsUp1peuLZ0wnZfJq0oy/BVHtew0zreKTaDDEsAsA0iMeddxIZfHnK+Hvfy39RxbJ628/ZiFOGN3MiMAHmJdK2NjXz6NiPtXPnskDIf9JsywI6DgmpEtRJ03QVGvgqVEk5Xq8f3MGzx6oRjDaUpSc+oim2Qzhbip154t6J/PLsPBsCnsIjk4iK5gP+DdZ+oeUzxSTW4HUyRnaDDZTDVW5F3jQNrlDRre2Tkr2AoI0WCxEQWCs2Ywx7nsgV34T/AbCPfWAtpBCIbMFLqFnlD79GJjCH7k5wCbpwUlf0pjEDaKFqn+n7/bVKghylgCh+Qxp+sxRSvZ78rsvo6NF6XW5FUqWQDzzYJcV67sTwevjtMrlkCaoqJK3l48yqBfNssLo5IogM2KWod1Gzg2M3rzSC6WOEIy+P3rsf7QNg7QR5j5wZVaSBvI6F78USaPy9/IfNGbD94RzyQCMSPom7NJPqk8fyOptGhjQUbHMtH0UihGTVjn7H7KcyPhszrmTOJKKiaA
 8DBd1yyZ
 BgdGWr2erFpT/cmX0++vzikCGZJX2UMDpf4MmZvSrepuDR3G/Dzabdt6f45oTrwR6XUCYD3TQP3YpidqEhDpsHPjUHjhGLnNYe6pCRPX3S736RERA+nyKUQGFNgQwhPPHYcb2sg46AyvdBl470d3Yxmfo6w4xOp/VsPrQ8uMlKiqs8AmjvLHtFyYGay4RCx9TWC1zaT+U4jbU2epyc4oDk+4/Z6mO1N6PCHuiV7dtw3FLD9BDupVZ4b1RExYudZC44Lq1T/s2oeWQO7IRBivtoYY+tplxMaJJYhlf5/YLWBvI5pZ5QTnGTftFgX9f7k8UoqGvbDbR161TEE2A1ROtEmPC8FddUYd1Pn5U1CS2R4fW7KiQ/NXhn+nLhdFTW1LLNA404ziqr7/4/vq/7K7teBDpXMuW+avG9BAdSAPjm3PVn3CWhjELo9y8GKwq48S+sdCG1Tm0hvO7Ts5zYhfuyGrXnj2KAesdKfCa2EPiWMeTo20MqiZu+zzTuQd9z11mJGKl0C3XZ2UI08CTSSKpHybBWI8TMbc80r7Lpn9Gx7XzrlZVsOnUqa6y7ETbJETss8bRFB3dTjdHPk5x+dTKuHfal+IwFC5uxcdxjLEmTtSScLBZE4WR6C+Mod2Ek6c/o5ogyxNw0sOBnhaT0AP3WzzcJwBoSRE8V1UC/UAx2ahlQQEvM1c194BIdkx7+b3PARuusiqFqRgCQQ2PsYzSQt+/ON8CVgRjYmflCz1DbCeeUPAVZSqg9CdB9JZ6o1EoUg3by46eOFutzjTfqPfAwCWFaiDOe46qiBe7PoNrAS2t99PG7/86prAhRX4kcy74mHjNmEF4p6HxrjdO+v4VLjuwzApCHfIErVj4rHTzCSfCInDvqoCjVw3c04fkxiubdBVYdzTR7X+Z732RQsQauuFDEC0z5+8RJL+e4Li23B3KSTRp52IiTjiuQTdFS2pyB4p/DpWYpmslJRX0hUpj23ICdSeE
 6xHIczgM
 EmcaH1IBCtHTwYtOrpmAFHW+L48gC9i9tPxxFdG37PZeC+08thlteyLehCHRYZIX62JaLoObVu2ZLbM2H0YtXk3AbtVztpuqllVFR0DqCPSoPb04dsnKIN5Yg0xdFkrI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v3] mm: improve write performance with RWF_DONTCACHE
https://lore.kernel.org/all/20260426-dontcache-v3-0-79eb37da9547@kernel.org
* [PATCH v3 1/4] mm: add NR_DONTCACHE_DIRTY node page counter
* [PATCH v3 2/4] mm: kick writeback flusher for IOCB_DONTCACHE with targeted dirty tracking
* [PATCH v3 3/4] testing: add nfsd-io-bench NFS server benchmark suite
* [PATCH v3 4/4] testing: add dontcache-bench local filesystem benchmark suite

and found the following issue:
WARNING in __mod_memcg_lruvec_state

Full report is available here:
https://ci.syzbot.org/series/e53aef43-ac7a-4cb7-8714-bb927aaee659

***

WARNING in __mod_memcg_lruvec_state

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      27d128c1cff64c3b8012cc56dd5a1391bb4f1821
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/c10ddd10-bb16-48c2-90fb-3625d3b258aa/config
syz repro: https://ci.syzbot.org/findings/1e8993c1-818b-4ddf-b90b-30f051b3a9d6/syz_repro

------------[ cut here ]------------
__mod_memcg_lruvec_state: missing stat item 21
WARNING: mm/memcontrol.c:911 at __mod_memcg_lruvec_state+0x1f3/0x360 mm/memcontrol.c:911, CPU#0: syz.0.17/5831
Modules linked in:
CPU: 0 UID: 0 PID: 5831 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__mod_memcg_lruvec_state+0x1fc/0x360 mm/memcontrol.c:911
Code: 00 11 85 c0 74 31 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d e9 95 2e 72 09 cc 48 8d 3d 7d c4 fd 0d 48 c7 c6 5d b4 f5 8d 89 da <67> 48 0f b9 3a eb d5 90 0f 0b 90 eb 90 e8 02 22 fb fe eb c8 48 8d
RSP: 0018:ffffc900039e7520 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000015 RCX: dffffc0000000000
RDX: 0000000000000015 RSI: ffffffff8df5b45d RDI: ffffffff90363d90
RBP: 0000000000000001 R08: ffffffff82388833 R09: ffffffff8e95cd60
R10: dffffc0000000000 R11: fffff940008c3f49 R12: ffff8881026eee80
R13: 00000000000000ff R14: 0000000000000001 R15: ffff888173a80e00
FS:  00007f5f76bca6c0(0000) GS:ffff88818dc95000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d77c624128 CR3: 0000000171fde000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 mod_memcg_lruvec_state+0xa7/0x220 mm/memcontrol.c:941
 mod_lruvec_state mm/memcontrol.c:964 [inline]
 lruvec_stat_mod_folio+0x239/0x3e0 mm/memcontrol.c:984
 folio_account_dirtied mm/page-writeback.c:2634 [inline]
 __folio_mark_dirty+0x633/0xec0 mm/page-writeback.c:2692
 mark_buffer_dirty+0x261/0x410 fs/buffer.c:1110
 block_commit_write+0x15d/0x270 fs/buffer.c:2115
 block_write_end+0x6e/0xb0 fs/buffer.c:2191
 ext4_write_end+0x27d/0xa30 fs/ext4/inode.c:1458
 ext4_da_write_end+0x86/0xcb0 fs/ext4/inode.c:3296
 generic_perform_write+0x620/0x8f0 mm/filemap.c:4350
 ext4_buffered_write_iter+0xcb/0x370 fs/ext4/file.c:316
 ext4_file_write_iter+0x298/0x1bd0 fs/ext4/file.c:-1
 do_iter_readv_writev+0x619/0x8c0 fs/read_write.c:-1
 vfs_writev+0x33c/0x990 fs/read_write.c:1059
 do_pwritev fs/read_write.c:1155 [inline]
 __do_sys_pwritev2 fs/read_write.c:1213 [inline]
 __se_sys_pwritev2+0x184/0x2a0 fs/read_write.c:1204
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5f75d9cdd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5f76bca028 EFLAGS: 00000246 ORIG_RAX: 0000000000000148
RAX: ffffffffffffffda RBX: 00007f5f76015fa0 RCX: 00007f5f75d9cdd9
RDX: 0000000000000001 RSI: 00002000000001c0 RDI: 0000000000000004
RBP: 00007f5f75e32d69 R08: 0000000000000001 R09: 0000000000000081
R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5f76016038 R14: 00007f5f76015fa0 R15: 00007fffe7503ad8
 </TASK>
----------------
Code disassembly (best guess):
   0:	00 11                	add    %dl,(%rcx)
   2:	85 c0                	test   %eax,%eax
   4:	74 31                	je     0x37
   6:	48 83 c4 08          	add    $0x8,%rsp
   a:	5b                   	pop    %rbx
   b:	41 5c                	pop    %r12
   d:	41 5d                	pop    %r13
   f:	41 5e                	pop    %r14
  11:	41 5f                	pop    %r15
  13:	5d                   	pop    %rbp
  14:	e9 95 2e 72 09       	jmp    0x9722eae
  19:	cc                   	int3
  1a:	48 8d 3d 7d c4 fd 0d 	lea    0xdfdc47d(%rip),%rdi        # 0xdfdc49e
  21:	48 c7 c6 5d b4 f5 8d 	mov    $0xffffffff8df5b45d,%rsi
  28:	89 da                	mov    %ebx,%edx
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	eb d5                	jmp    0x6
  31:	90                   	nop
  32:	0f 0b                	ud2
  34:	90                   	nop
  35:	eb 90                	jmp    0xffffffc7
  37:	e8 02 22 fb fe       	call   0xfefb223e
  3c:	eb c8                	jmp    0x6
  3e:	48                   	rex.W
  3f:	8d                   	.byte 0x8d


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

