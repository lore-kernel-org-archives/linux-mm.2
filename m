Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E487CD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 05:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32F6B6B0005; Tue, 26 May 2026 01:49:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0276B0088; Tue, 26 May 2026 01:49:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F60F6B008A; Tue, 26 May 2026 01:49:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EAFA6B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 01:49:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9E0821C1256
	for <linux-mm@kvack.org>; Tue, 26 May 2026 05:49:31 +0000 (UTC)
X-FDA: 84808493742.20.43A5076
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by imf02.hostedemail.com (Postfix) with ESMTP id DF74780005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 05:49:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of 3aDQVagkbAH0tz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=3aDQVagkbAH0tz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779774570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=DzJWSIhvpEau2z8ZBB5xaqMPUjWo5NzLuDCqLRgBZ9U=;
	b=GZyFmewpY+wqp41lNtlFOFJ26gen13F9gB9Kd09HGwENQ7Y3hB0+Y85kq28QYz4hjh8AuX
	7/8BnOXoYrYCFmDBeGAVAep1MfCCIs97Y+yZtn4kFZltCTNoJPU+c22viHE/AwDhuW6FaV
	2POxzUkGQJaRZ6koM03AVOMMNKFHAK0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779774570; a=rsa-sha256;
	cv=none;
	b=5MeubFmWANdi5XkIfxFMkU0ZywTRM2uOrAfC2a9v1J7yY7Ux6MkrKn7xl0HQHKnBzsH3Os
	3aNr3fKmDrrmPpm/eCxG4SgcTnoN69P3UNm3puiq562zQ5Xx+15c8/wGqT61ju1ibhi/uI
	ePFvds3kLoYt11gXzlVAMRjQVC8TYVo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of 3aDQVagkbAH0tz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=3aDQVagkbAH0tz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7e60dfcced4so6806361a34.2
        for <linux-mm@kvack.org>; Mon, 25 May 2026 22:49:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779774569; x=1780379369;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DzJWSIhvpEau2z8ZBB5xaqMPUjWo5NzLuDCqLRgBZ9U=;
        b=sCQOcRtnHRtqkVjw9bfW3t3IGqFCwgd6rzUpXn1NkwTPLh1Gnd6i25Exlt4c7solTC
         KbtCje/n3SgGmvR544XvCAD/dLFiO+vouFPmekwoTSdjtzZMcPzLeMeVAsS09Sz32uB9
         B+vnIrSaso8pEuxQ+ZjOBeU9YsH5Z6vCI1iIxMqwTP2CGB3rdfQfNP4Is551m+q8G1J/
         FHgIl37Qi7yzetftUvBBuJMt93nv2S3qfExM404aYcf31ywXPTuKFngRrMP0Xmc6sK5r
         8lMcSHzJPLjjh9jyszK5GoUJ2WZ7xXclzc1fmijPGBlRVvChMIvWQRnaIVhmhBd+vKOE
         Usqg==
X-Forwarded-Encrypted: i=1; AFNElJ+1dMW38673zvrp8BrCV74L2p5vYnxSd7f9yewW5bgb4s9zM19wDSB1k7Rq01n3WIJ6rDcaaHp4Wg==@kvack.org
X-Gm-Message-State: AOJu0Yyjxo5NTA7bwISNtbX5y5SRSy2Ty8KcNAY+FATxVMYdBeJBZ4tS
	VhSfruvELcO0X0nz/FesKSjrNdZQVHtcvFRdeJFKra81QFN0x+D4EamHDF34B+hdbRnzBfVXQ1a
	k22jZCqPygq8/f8+QKXScM+Z0Nu9xYC9cSxmafXJQJneVvkSFYKjhYeIm4/Y=
MIME-Version: 1.0
X-Received: by 2002:a4a:e84b:0:b0:69d:9153:56ec with SMTP id
 006d021491bc7-69d91536352mr7102173eaf.41.1779774568882; Mon, 25 May 2026
 22:49:28 -0700 (PDT)
Date: Mon, 25 May 2026 22:49:28 -0700
In-Reply-To: <20260525165528.184397-1-osalvador@suse.de>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a153468.050a0220.7dd1.0004.GAE@google.com>
Subject: [syzbot ci] Re: Implement a new generic pagewalk API
From: syzbot ci <syzbot+ci07d784447d67ca63@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@kernel.org, david@redhat.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, muchun.song@linux.dev, osalvador@suse.de, vbabka@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Stat-Signature: iwfji1yc4y36ssqoi1yacoj511tuiyr5
X-Rspamd-Queue-Id: DF74780005
X-Rspam-User: 
X-HE-Tag: 1779774569-981514
X-HE-Meta: U2FsdGVkX1/jt9xfeYoZ2XaF9lRGTrUnkCr7IbLja3mkXb3hjQD87E2UGXJyaEpvqBAeaMbzjoI4+Dv+DWXVFB8P1pksW21GKK/2QNL3XLcoG3/49YsJxIOhs7W0SFzDUgxG9sjTtvigrzkRNzVDk6SLt0d26O2jhZ8WQuTHSw0k2tAapBXq2uO2t0G6VKadSN6fDH3EFGSow2x6DPvrinatZgfIstHcUfgSZBldiemSui2e/hi9MZKuj9ZVzLMozlpJg9rcdLRwdGkDvljAFP6PRDdh2rW/B0GMxefN5m0cqmKgObzvrWD2XQM8VI6k7XwrFmL4V8fWTjPPK9D3KghBAn4Msfh9OBmQQEaq2WRmJ0bTbyvvpHvc5QvDnjo1xR6zqLquLXmGl4JyDwLw9KVBLUkONrnuyc3O8ohPojNE9P42NACgrJ0oLiQxb77jg7QxIbGO64vHKIhT2GBLIqvhPOE+FZEiHu6jNqQE6amg0TigkcDRriGkpqvm4CYHr80pt6S8pWu7fDV3plBual9rbT6DzJpuqh3Ud41cKapiEBlGm0r8W3KAKjUJRz8fHCjHYa6qY3fFtBrrkMxCA9YbhizIcd/vKbSVypVQvlLUjl5unhPKjh2nbDL90rs15xzrJ68yeF3BTZtqmhnS9oKui+HRTUM7m+bwYnsO67dgh7WL7I7R9sZZ4++Mgkew+2optuFM6CU/IqjaeO+eI5zWdKuOsWCu47+eV9Kcr8thfiEZbzjT85cMG/OXYubanPvNA6TEobAbYwKXU2rjF3svAyw2DlTpq5LrSakHOvV1SSRhj7yvwMCFURvrg5dYlHJBvu4X0bbyEtYPIAhnduSaIgoLWPyHUlHEJD7AJrTe4EwJ7iA6lMWUODQWlOVdslTxzCtfagvPZUb2ooJoMswJrdPG3aSMLkB7n9oH7ejw854aNcsesi9Rbveor9RX7k+C0GkOJBXHv9+GVnA
 ApOi8vyN
 hdpu8FvgcDzrmYp2rdvAv8wdz2TxQ5yauMLv9Txa+Moxm9RkqpdpPBZmfydUf6fdTGwNYRfaC4+1vLhnB8wLMIEV8PEsR4ApqEmXw0ylEDKa7pWV4IOuCJWw3BP8O9VLqINySkEdhhJr2etz7aX44fgMp+N34YLTijqlNi2KOSPidy+pKmVIqJdbAQ8/3BK8KB/YifhbpTyNCe9OxoeePCfFehjNN/njgANqSntDA5QDZ4q6tRW80EElkD5EC/1JhoqJiWRW3xd1ttOvpCVfzu9FW+3muh+L8Ohy8iLusa6blIBWJkKkAAXSbbabpoOTNAnvOiBDjNkM8bpK/52MepNkfoWejiSLO8i1XDFq1o6nW5uSk8HeJDhjs9Zr5wRDEd4SqG12mWVfD1eQLdPyfjlt6QLklnBCLwjrmvjEzI2/2D6WeQJlqRaq70AzRvciBaRLukT+4kJNWPdthY9bV3nsamAWknY/nPG917lnrxJW0M20AU2IVuFo/ny4D7Vdootc3GIjHzghZiyMUPl68hsOb49WLpCrXkprOhtOe7RPkLnjs6XFlQF8wCknWdtA3M3qg+p0pEctevF0jOHmfYEIgu3Ip/jjFp2CnlmzgnJ+sUJgLgr8UX4W7ZnZXIWCrit8cWM+b+ZveS14KNSpMZ5LRoAN8aWgFaIG/X7PqH+nGUmuYiPEhYwkiTgKJIZkt7DHsLHwuHOYgS3Dd5buyMI7lHiPotmBdEtQPSCpsVqHPwECSzDbD1893FEkL0759F6GnqGNTxjG1NHUaVVu5FI/WnypwFOxMesIlOUEsOPW6bUBqfLoWITo4GKRQEUwp3ylSTE0IzCKsu0gopoYcGL7yNvN5cmEMNV8qiIksOB2xpuLJi9+Aw3lgm3hyvShreh5sqP2AE4ioC+fyyGOiyqnhMOkJBXOpXAyousKOR0EBvIurv+WrXQywBuTFoxjExRSR+Kj//6ztEm42IuAz7N6hXHT+
 /gnDKGjy
 j8zNNJMGG1g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v3] Implement a new generic pagewalk API
https://lore.kernel.org/all/20260525165528.184397-1-osalvador@suse.de
* [RFC PATCH v3 1/8] mm: Add softleaf_from_pud
* [RFC PATCH v3 2/8] mm: Add {pmd,pud}_huge_lock helper
* [RFC PATCH v3 3/8] mm: Implement folio_pmd_batch
* [RFC PATCH v3 4/8] mm: Implement pt_range_walk
* [RFC PATCH v3 5/8] mm: Make /proc/pid/smaps use the new generic pagewalk API
* [RFC PATCH v3 6/8] mm: Make /proc/pid/numa_maps use the new generic pagewalk API
* [RFC PATCH v3 7/8] mm: Make /proc/pid/pagemap use the new generic pagewalk API
* [RFC PATCH v3 8/8] mm: Make /proc/pid/clear_refs use the new generic pagewalk API

and found the following issue:
general protection fault in clear_refs_write

Full report is available here:
https://ci.syzbot.org/series/0beab2d0-9d88-4288-ac81-b294e51c057d

***

general protection fault in clear_refs_write

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      5200f5f493f79f14bbdc349e402a40dfb32f23c8
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/8f20e88b-808c-4c60-9b8e-0af4c9fce5ff/config
syz repro: https://ci.syzbot.org/findings/634b1f0a-cf64-4607-928a-ef3ad40f765c/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 5863 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:clear_soft_dirty_pmd fs/proc/task_mmu.c:1545 [inline]
RIP: 0010:clear_refs_pmd_range fs/proc/task_mmu.c:1581 [inline]
RIP: 0010:clear_refs_write+0xaa7/0x1590 fs/proc/task_mmu.c:1721
Code: 44 24 10 4c 8b bc 24 20 02 00 00 83 7c 24 28 04 0f 85 aa 05 00 00 48 8b 9c 24 08 02 00 00 48 89 d8 48 c1 e8 03 48 89 44 24 58 <42> 80 3c 20 00 74 08 48 89 df e8 fa 2c c6 ff 4c 8b 23 4c 89 e6 48
RSP: 0018:ffffc900037bf960 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000005
RDX: ffffffff826b21ce RSI: ffffffff8eb17b50 RDI: 0000000000000001
RBP: ffffc900037bfc10 R08: ffff8881047c0000 R09: 0000000000000002
R10: 0000000000000002 R11: 0000000000000000 R12: dffffc0000000000
R13: fffff520006f7f40 R14: ffff8881141c8308 R15: ffff8881141c8300
FS:  00007ff8ffc1d6c0(0000) GS:ffff8882a928a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b33e63fff CR3: 000000010476e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 do_loop_readv_writev fs/read_write.c:852 [inline]
 vfs_writev+0x4bd/0x990 fs/read_write.c:1061
 do_writev+0x154/0x2e0 fs/read_write.c:1105
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff8fed9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff8ffc1d028 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 00007ff8ff015fa0 RCX: 00007ff8fed9ce59
RDX: 0000000000000001 RSI: 00002000000000c0 RDI: 0000000000000003
RBP: 00007ff8fee32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff8ff016038 R14: 00007ff8ff015fa0 R15: 00007fffd02796e8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:clear_soft_dirty_pmd fs/proc/task_mmu.c:1545 [inline]
RIP: 0010:clear_refs_pmd_range fs/proc/task_mmu.c:1581 [inline]
RIP: 0010:clear_refs_write+0xaa7/0x1590 fs/proc/task_mmu.c:1721
Code: 44 24 10 4c 8b bc 24 20 02 00 00 83 7c 24 28 04 0f 85 aa 05 00 00 48 8b 9c 24 08 02 00 00 48 89 d8 48 c1 e8 03 48 89 44 24 58 <42> 80 3c 20 00 74 08 48 89 df e8 fa 2c c6 ff 4c 8b 23 4c 89 e6 48
RSP: 0018:ffffc900037bf960 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000005
RDX: ffffffff826b21ce RSI: ffffffff8eb17b50 RDI: 0000000000000001
RBP: ffffc900037bfc10 R08: ffff8881047c0000 R09: 0000000000000002
R10: 0000000000000002 R11: 0000000000000000 R12: dffffc0000000000
R13: fffff520006f7f40 R14: ffff8881141c8308 R15: ffff8881141c8300
FS:  00007ff8ffc1d6c0(0000) GS:ffff8882a928a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b34063fff CR3: 000000010476e000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	44 24 10             	rex.R and $0x10,%al
   3:	4c 8b bc 24 20 02 00 	mov    0x220(%rsp),%r15
   a:	00
   b:	83 7c 24 28 04       	cmpl   $0x4,0x28(%rsp)
  10:	0f 85 aa 05 00 00    	jne    0x5c0
  16:	48 8b 9c 24 08 02 00 	mov    0x208(%rsp),%rbx
  1d:	00
  1e:	48 89 d8             	mov    %rbx,%rax
  21:	48 c1 e8 03          	shr    $0x3,%rax
  25:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
* 2a:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	48 89 df             	mov    %rbx,%rdi
  34:	e8 fa 2c c6 ff       	call   0xffc62d33
  39:	4c 8b 23             	mov    (%rbx),%r12
  3c:	4c 89 e6             	mov    %r12,%rsi
  3f:	48                   	rex.W


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

