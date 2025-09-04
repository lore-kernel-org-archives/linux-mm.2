Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4B1ACA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 10:41:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29AB08E000A; Thu,  4 Sep 2025 06:41:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C068E0001; Thu,  4 Sep 2025 06:41:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 113C38E000A; Thu,  4 Sep 2025 06:41:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB78F8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:41:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8DCDC86C42
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:41:12 +0000 (UTC)
X-FDA: 83851225584.26.5736631
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	by imf28.hostedemail.com (Postfix) with ESMTP id EA7C3C000D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:41:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of 3xmy5aAkbANEFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.197 as permitted sender) smtp.mailfrom=3xmy5aAkbANEFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756982471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=d5Ydvs3V14HrC72+IwRrxXukL/IqHbo4g5cVXlx9SLA=;
	b=TJ3K6+zOQ9+dM3o85Tw2xwutiyCuyYD8fkdtXW3i0Nkg/7htRe6f6NWqsZy0MiUdZLQru9
	E8u8bJivU1DkknGXp07WiONGHGkfSBFvDkHcNFfmdt8CRyD5lvFVZF00LOGR0zuig3e5g1
	J/cU31njWn+yytuqjGnDpHc+uUMb3tA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of 3xmy5aAkbANEFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.197 as permitted sender) smtp.mailfrom=3xmy5aAkbANEFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756982471; a=rsa-sha256;
	cv=none;
	b=0g6VyUJetlaS52Jgsgywnq5iOtVlbkZAtNWHOhEqwx/OjeSBZdPha+qRPscwo5brgrF2Tb
	tRbUCrAXYDVZ0sD2Xdw3AnJ7UBGoEhnk/F0/tZRWUMXyl9l2HSAdJxUrwUSv5SadVU0E/D
	vgHLvNNKObMAba0hpMpcR3g0M+bnKEU=
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3f65e91bfa9so19455565ab.2
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 03:41:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756982470; x=1757587270;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d5Ydvs3V14HrC72+IwRrxXukL/IqHbo4g5cVXlx9SLA=;
        b=wiPewJ2nRmH0Lsp3ahFmOGrerio3z4HVFbmWDj0FwpS3xjopqJ6Q3RvaeFAYpdIGKk
         crZ2BMTqLQfiOr8m24Q2TE2kwFgaLaZDKLUwMS5X1NomCwhjCLxw/X7ySvACsmOlagY1
         OOtS1uqS24jWX5IEHFTxKJwBzMaZ4JcVmvwk5oFbm2xxTzDq2T69Qvw3fUDVduJWfEWh
         4twVMo+vimlgdk6d/iVIDQ4INS8kFrfY1Rso2C1JmvgwoBu5Ms27Jda9w8TiiWsxVJzh
         ePu536RZzCJ9YYpubI0n+IQHUWC2/AZnGnnO1oTYfRkdAE10VM+TVeIqIXlcCrsQyCP3
         qHMA==
X-Forwarded-Encrypted: i=1; AJvYcCW2P86oV8Tp9qHN4eZUEvSR7d9fSV/DAGCA3zCbEtppWzaWHUWhwLY5aMt3U0039q980N4xwOQGoA==@kvack.org
X-Gm-Message-State: AOJu0YwYKl2L5W2SXyb/3tcR1n+vOkL7Z9Mzn0ZCyJvztdgqT4whxIDG
	s33kO6Osiy5FpnJF1Ny2hJwTXRHaCGZSaC+Yxgk6fYdGT1xmIZtSWIrEa+qnfW/Xaw31ysF8t8H
	HO1XslY1ZLMTGH7CsamblbkfuzoVU8NHm6IHvLmrVhWS77ly4uvuoDg55QPE=
X-Google-Smtp-Source: AGHT+IHP5nkhSjEAlq0O+VLctUUxL4WFO4zpj1wiYJsegNjzFAFImJCBqFXsQZnjFjdVl+HZtGvW8cwfMSvoC9cURZVTAax8aBmT
MIME-Version: 1.0
X-Received: by 2002:a92:ca4f:0:b0:3f6:5f94:2847 with SMTP id
 e9e14a558f8ab-3f65f9429ddmr73785585ab.24.1756982470066; Thu, 04 Sep 2025
 03:41:10 -0700 (PDT)
Date: Thu, 04 Sep 2025 03:41:10 -0700
In-Reply-To: <357638f71edc7f1d9814b1851a64e09a8895bffc.1756968204.git.joeypabalinas@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b96cc6.a00a0220.eb3d.0003.GAE@google.com>
Subject: [syzbot ci] Re: fork: simplify overcomplicated if conditions
From: syzbot ci <syzbot+ci452e2303ac12cc31@syzkaller.appspotmail.com>
To: joeypabalinas@gmail.com, kees@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: EA7C3C000D
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8bz9yom7rrjizbxxutt5k6sic41gcpry
X-HE-Tag: 1756982470-887673
X-HE-Meta: U2FsdGVkX18Db4n9GRgSS1QQ36zy/c8JmKYfOnLsqVR9ucbyANC/mH2TPRrEehCGHwNvn0YV1bQVF56JTNe1TcUhaMX3tQJR6qC5v0hDHeb21HkhE9cS6q2NmjLGE9SAmiHjkyeHfs2WSxZID49CUEJGNSmnb+qMVNhCMCixvXM23i6zFNJDLwSdRcMU6Q9ONW645/uqyOUibkKVGeyIBjqnmVu+3DBb61OAjl/6ZpqpHOjaBvKd6ki0A24nTGQsqv+9s0fHJyRGjYe663yi5UCuTDrscx9xopdO7OdbHSR5R4RLDokgcKsL4OKmot/WmIXNtatj+64nPB3X1e4rQ5L6lbAumE19cCYHZqIHiSHRqQOk5QKOi4psDxeXEWjv1aHd1EhH8s0gouu2ufYzdL16jGhDQEKodcozCwEiSJb1Ep8zQ4nS8VHM+ES9WGF9GXxRMhSmKvcYv86YH3NhRQw5ydYDzg4Rie2rm//TSrIpN54wlrmdyOCIJnc98MIk4sZUzTx8FXao0wK8WJSAwSqhsj5x4KOggC6qmw8nJNDihIcU1FEpjPhMFBAIstcXEUNMWljGBzMQjya6E0k/vAOetFAIqtW2iCvQy2sn4FxYMdur1J71nDjo8jnCIgxuPgKlnCCw/IPJsI4+VTrb5XKL7nW9/02XDfhnxK3/QdoFFDQ4oL3spYdOCQqj2Ub6EQvu0rCNQk0fzqTvlsVyKtUXzfjTfo7p//CG3WJxcnSwawRHJgQmtdYsBqSnDmxX6PP43Vqjf+OYMmxOkb1vwTpuiftuCY1oBxW30CThV/C9s9qLGgiDpSqzrzVagcyHns1zgSr4B/3PFKN7RZmxuBDDG5vyQWUwirvzLuuqzICOe5gi2rHH31jdvZGS6BYFgrfbK7rk3iQOltYi1/rLlJV0lgKaJ2AAmeAMp0i8y3zMczcp+1MurcAMKugt8xGxlavkFb5ha0EP1K7wDwa
 Lvu0/Tw3
 w028APWAlRzWQD0JjwIVjwl6BTY0PD4HQLYTnXFdBJacz8Gf95BvDAPovFTdWFT1T/EBz1OwZWPOaFxJRG7wfD5Sj6IH5yWl/ETDlYBMilaNFklewjVPQdnIFFqVWR+Z6fjixKh7ErdRxLz9KkfrgHnfQByTVSddxj6xnz8acClmHQY6alZqTfEVmxmw9hUXr3grGz2tpvAq8wn4JZ0kyLIAgDE06VNWoYnFzVC1vGAAsMBfhJmzK2Tlz++GCAEkFhvqEenrLqU+ZAj3FeHIFKpbNytGgh6MalOgS6yaSOj5oY4NLIo+fVh96E0tDsvl9BtI2VLOekP84feCZbkxdqNn8BueHUCtT27LyFEdmtPMb1h7PNYU0FbyKJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] fork: simplify overcomplicated if conditions
https://lore.kernel.org/all/357638f71edc7f1d9814b1851a64e09a8895bffc.1756968204.git.joeypabalinas@gmail.com
* [PATCH] fork: simplify overcomplicated if conditions

and found the following issue:
general protection fault in rest_init

Full report is available here:
https://ci.syzbot.org/series/e9c440d7-f494-4207-a59d-773bbbf909ff

***

general protection fault in rest_init

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      b320789d6883cc00ac78ce83bccbfe7ed58afcf0
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/58676b34-5a2d-40b9-ab9d-b45b8161dd5c/config

Console: colour VGA+ 80x25
printk: legacy console [ttyS0] enabled
printk: legacy console [ttyS0] enabled
printk: legacy bootconsole [earlyser0] disabled
printk: legacy bootconsole [earlyser0] disabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8192
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     1048576
... MAX_LOCKDEP_CHAINS:      1048576
... CHAINHASH_SIZE:          524288
 memory used by lock dependency info: 106625 kB
 memory used for stack traces: 8320 kB
 per task-struct memory footprint: 1920 bytes
mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
ACPI: Core revision 20250404
clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604467 ns
APIC: Switch to symmetric I/O mode setup
x2apic enabled
APIC: Switched APIC routing to: physical x2apic
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x285d45cc0d6, max_idle_ns: 440795339158 ns
Calibrating delay loop (skipped) preset value.. 5600.55 BogoMIPS (lpj=28002760)
Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
mitigations: Enabled attack vectors: user_kernel, user_user, guest_host, guest_guest, SMT mitigations: auto
Speculative Store Bypass: Vulnerable
Spectre V2 : Mitigation: Retpolines
ITS: Mitigation: Aligned branch/return thunks
MDS: Vulnerable: Clear CPU buffers attempted, no microcode
Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer sanitization
Spectre V2 : Spectre v2 / SpectreRSB: Filling RSB on context switch and VMEXIT
active return thunk: its_return_thunk
x86/fpu: x87 FPU will use FXSAVE
Freeing SMP alternatives memory: 136K
pid_max: default: 32768 minimum: 301
LSM: initializing lsm=lockdown,capability,landlock,yama,safesetid,tomoyo,apparmor,bpf,ima,evm
landlock: Up and running.
Yama: becoming mindful.
TOMOYO Linux initialized
AppArmor: AppArmor initialized
LSM support for eBPF active
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes, vmalloc hugepage)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes, vmalloc hugepage)
Mount-cache hash table entries: 8192 (order: 4, 65536 bytes, vmalloc)
Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes, vmalloc)
Running RCU synchronous self tests
Running RCU synchronous self tests
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:rest_init+0xf8/0x300
Code: f6 49 bf 00 00 00 00 00 fc ff df 89 ef 48 c7 c6 40 57 fe 8d e8 e9 47 12 f6 49 89 c6 48 89 c7 48 83 c7 2c 48 89 f8 48 c1 e8 03 <42> 0f b6 04 38 84 c0 0f 85 d9 01 00 00 41 80 4e 2f 04 e8 e1 e3 ff
RSP: 0000:ffffffff8de07ee0 EFLAGS: 00010207
RAX: 0000000000000005 RBX: ffffffff8b79fc61 RCX: ffffffff8de95100
RDX: 0000000000000000 RSI: ffffffffffffffea RDI: 000000000000002c
RBP: 00000000ffffffea R08: 0000000000000000 R09: ffffffff8b79fc61
R10: dffffc0000000000 R11: fffffbfff1f47207 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b8618000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88813ffff000 CR3: 000000000df36000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 start_kernel+0x3a9/0x410
 x86_64_start_reservations+0x24/0x30
 x86_64_start_kernel+0x143/0x1c0
 common_startup_64+0x13e/0x147
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:rest_init+0xf8/0x300
Code: f6 49 bf 00 00 00 00 00 fc ff df 89 ef 48 c7 c6 40 57 fe 8d e8 e9 47 12 f6 49 89 c6 48 89 c7 48 83 c7 2c 48 89 f8 48 c1 e8 03 <42> 0f b6 04 38 84 c0 0f 85 d9 01 00 00 41 80 4e 2f 04 e8 e1 e3 ff
RSP: 0000:ffffffff8de07ee0 EFLAGS: 00010207
RAX: 0000000000000005 RBX: ffffffff8b79fc61 RCX: ffffffff8de95100
RDX: 0000000000000000 RSI: ffffffffffffffea RDI: 000000000000002c
RBP: 00000000ffffffea R08: 0000000000000000 R09: ffffffff8b79fc61
R10: dffffc0000000000 R11: fffffbfff1f47207 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b8618000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88813ffff000 CR3: 000000000df36000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

