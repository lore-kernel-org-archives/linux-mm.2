Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDCD5CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 19:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 389D28E013D; Thu, 18 Sep 2025 15:41:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3608B8E00F6; Thu, 18 Sep 2025 15:41:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 276978E013D; Thu, 18 Sep 2025 15:41:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 16EF98E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:41:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DAA9111A03D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 19:41:29 +0000 (UTC)
X-FDA: 83903390298.11.D5ADE72
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	by imf25.hostedemail.com (Postfix) with ESMTP id 12DEEA0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 19:41:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3Z2DMaAkbAKYYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.197 as permitted sender) smtp.mailfrom=3Z2DMaAkbAKYYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758224488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=jFuQa+Y4FpaQQeM/M6InReVDIhcGmsMw+atLDwBDLk8=;
	b=Ntd7648W6vjBUk8isgLzYDQIUbojRpBWsCnEhLOM6SBYp5rg7x3VlSsF5C+0QyHHYbQdzi
	evk2qexXZKeqhvJAgbXqjxkkzFkdXsPprUmqLEiJEeAgrGPTJU89A9mOGICK7CB69McR+s
	KxJ1GJ6Di8/96odbuWJoS9gbE9EA5Nw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3Z2DMaAkbAKYYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.197 as permitted sender) smtp.mailfrom=3Z2DMaAkbAKYYefQGRRKXGVVOJ.MUUMRKaYKXIUTZKTZ.IUS@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758224488; a=rsa-sha256;
	cv=none;
	b=CJ1I6meWPn1XIo/D7h2y12Yr1VFWK2BY1hUHgyav7ykKcVZnRYlqXaS1dJT8eclVtUrXXs
	nxlKXEl9EjdI0Ya9x1YWgBOs/GujuSA/L+uxvtBTcf/EoaB302IcTBFa1b3RYg4M9Or0FG
	pW85Tun/4ztanECLta9TzvnVqFb3Vug=
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-42408b5749aso34671215ab.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 12:41:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758224487; x=1758829287;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jFuQa+Y4FpaQQeM/M6InReVDIhcGmsMw+atLDwBDLk8=;
        b=mxJ3SOayZ2A4gZvKHVuz0mMeoEaW1vU/g5ydMuaFGJWbek07ELj37sYc59goF7c0zk
         Zoavmgnl4ZU7uftuYVnfvAZPfHqkP/R7NtIhI02sa0DHld0pdOMpQwwwWR9I82OvYtB6
         6L5RJdoRU128FXE8NmiLdhfRzQ+01mfFFn22ymt4dv+uWZwjRS30WUybOxIJwv4fb/Kz
         g0tucZi0p9WZQCtB4Dbvit9z/Yr9SgbVnCLkG5OPDOa9QcisbApPIITvqDoweHh8BPMu
         uVvCTSCz4g8vr05+v46xxbR+qzRlAgxhwsfKzcen9VExSSTp1rIzTrpJzDZtr7t/llr7
         RkzQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+74Uf5KV9faRgEVWrYBfgaAdswOJu5yVH+m9eZTLXFhxC/cb7hZjtUmZqPcVK/YKtRKGIc51bMA==@kvack.org
X-Gm-Message-State: AOJu0YwZMpyYMAu4G99AQEv+jHsER7Xez20AExJf3+/xXTl0nQ22N6ki
	jbNjhe8qsFfoJrlZ8v+m/VTQtC0jNlCuVpWp+oWC6xlk7WZs0chhfx3L2vjq2GPRx7hh2WeWjvQ
	i0ETm0epzVqHnMMY4fLyYyeCVf1VM0G7SGaoguY3o41GkNN4vS0puP6B/pyk=
X-Google-Smtp-Source: AGHT+IHp+WmIL2IJ68tyFld/0nIXw957th39hMRbu6ab9TAjY+iGCLjCAkmJaJtBL9BpNCxThFERyAxXTWPP+JGSPca9tDNIDuO7
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:184d:b0:40c:cf06:ea2a with SMTP id
 e9e14a558f8ab-424816f2c45mr17310755ab.2.1758224487064; Thu, 18 Sep 2025
 12:41:27 -0700 (PDT)
Date: Thu, 18 Sep 2025 12:41:27 -0700
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68cc6067.a00a0220.37dadf.0003.GAE@google.com>
Subject: [syzbot ci] Re: Compiler-Based Capability- and Locking-Analysis
From: syzbot ci <syzbot+ciac51bb7578ba7c59@syzkaller.appspotmail.com>
To: arnd@arndb.de, boqun.feng@gmail.com, bvanassche@acm.org, corbet@lwn.net, 
	davem@davemloft.net, dvyukov@google.com, edumazet@google.com, 
	elver@google.com, frederic@kernel.org, glider@google.com, 
	gregkh@linuxfoundation.org, hch@lst.de, herbert@gondor.apana.org.au, 
	irogers@google.com, jannh@google.com, joelagnelf@nvidia.com, 
	josh@joshtriplett.org, justinstitt@google.com, kasan-dev@googlegroups.com, 
	kees@kernel.org, linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	linux-sparse@vger.kernel.org, llvm@lists.linux.dev, longman@redhat.com, 
	luc.vanoostenryck@gmail.com, lukas.bulwahn@gmail.com, mark.rutland@arm.com, 
	mathieu.desnoyers@efficios.com, mingo@kernel.org, mingo@redhat.com, 
	morbo@google.com, nathan@kernel.org, neeraj.upadhyay@kernel.org, 
	nick.desaulniers@gmail.com, ojeda@kernel.org, paulmck@kernel.org, 
	penguin-kernel@i-love.sakura.ne.jp, peterz@infradead.org, rcu@vger.kernel.org, 
	rostedt@goodmis.org, takedakn@nttdata.co.jp, tglx@linutronix.de, 
	tgraf@suug.ch, urezki@gmail.com, will@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 12DEEA0008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: icxmmxy6ubka1ow3iri6agm355t3rjst
X-HE-Tag: 1758224487-191366
X-HE-Meta: U2FsdGVkX1+VffSacZdcH0NREjwWunrxKKfoupFShBluNsGtQosYPRBfKWHnsOug788aNLBftRjtQ9W0UDKFVFGwY6jZ3Y60F+fCv3a1USJFExZBLgIkrTzuLlyHMTj1BfPGNSGMxDW9lqnC0gazGJzW8GYpsP7N7yR8t4ZXhUDPc7JjukcscQ9ZQ8dwgVBcnhzuX9H7wAFyDf7fLLdTphckn7kLl5nYjJYiNYyBKZ0Nj1iLGkhpwd+nWtFrl3uuGMYQI0KrFQY+8BHFU0KQ1aXgvAsmcuLcdavF2YsWvyxDL4GkGGWTg/uaqje9f43qkKM2WiMZ9zUGKv9HgjbFVTuPGM1VGs69jycvpI+5bF7XxEMxYz08CHgMWZAWQ69561WeLrGkauRL3q4Yhhh/2coCxUHnSiLPHGPhjtjJnCchKfOJWsPZdC7CWbr48ssKoaduaM9JZo46piI+QJM2bZzV+CDSW1ETK3TeOHcMyLQNup+0n3yfNzKXb9DzKstupSFRRAg/q/omohTSAYhdW/43PhpwNsCrFO87NCGhQZ/lufuDxG+MPtoLyvsR7K8gC3x4o0zziUW62PQf271v3HPSzyZLspQ/GN851NClGFYwtY126QasujKWjB8/VKfX9zY3kA9H5A9cO/ISoQiATOtLo1MwO+JTBtd5hVZ4IN9ePwRlBMW+wucG8288PqdquPNX2uJaxuzjfb1r0IJljDY3fNMgESFes4CfxoqeSHL6/8kYcm0W+WITQGKvjOh+mtL2Y4ZbCiPhjZZ8DTS0Q7bFEzusITqehqKIulXTc6Ljlf1C6nKppmbEp/NC4JhIu48Ok1i11YQ1pbd/Tj7ssglwKm616enlnWLIWnzxW+YSy7QU0WSKREAjnyO6vTt/SBqFSiEjZaLVaZRMOnhmarIf24BPm7zHcVOXOk9vU+pGttgYB5wa3CQ2hhEdCKGTfreUIe54pkJXSzTYxeJ
 SZPINiSN
 tp9c/SXZ/hLjw+ZDmIkB9WmVznCrKwgRFjvDDYm2Tql+AMEjtuBbr16RtmH/ERjOqmFhLhEO0m2Ne+j9EKxnDqokci3S86sdbZvtrXYyJJ3VoWA1jB8PQw4GsNmgTtJADoEMTxlOYBHSW/7iZvLdiwYamvVhCnJvF9eFXhozt22se1Hxec1T3SoA/0bQHHc+jJBEnX82YPgcHSalVX7ybLemRH3MVu6CfPaCIJeByWaNLFKkkV4cKaHFXtfcj9TaS5x9sbxK97hMdyoUZFByELT/a7luM4IlObqkIizNvvRe5sBUppZ84ZIfr1BP8dnIw74rsHgpAhDSNSqBgaI1BXqXi5akSYglPQ8GbCeF1z2d1EZBmnvNE476fgq2sI8g0oyFCjNHKkd3vk+xukoLNLbt0daYlT33J+dn5TD3cEPbcK3NkLKcrTBeqA8k3/reHnFo2fSVBuBib6MKosyfqiL1+PUX3s8cX529/COWfghZnkc1cuykb+6mJlyaAdOtnaeY6g84ProZqw9IfXWUvkZJWX7F+MamGf/cCZ+M/4TS8UMJCIxKYLDfOH+h433HpbhDClhj2vCCL2VNOWOFrTG33574TQky7L+EF9gC/VLHhGH1ceHwePBy2dMetPI6jCXg6wgm70Qfutu5aMkZC51RutzGMN6NcEpvl2AxS9Uvc4ldGzpmdUktvGyJ4KOXADYQZslU6oYMgpmm9sWqddA/fiJjncX+v1qvioFuuWkZF7toVDEnYmNA5rr4T9AWMKq7W7MV9WoAuDJwdpoau0Wr7zj5KhoCKCCiqNGAC8pRJqvpRVfR5IF+FIG4VtFe4LrXwAxYZRf5d518mD5qaeTJzPvoCt02hH7WYfdheskeywI/A/sPIvYSfcAMxA4yFfFUO7MHmcmSE3fRMyx5+Q6aYPTYmu0fMdiI7Zx498ZBN9MTB5sQuEIO71/F6airHWJaY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v3] Compiler-Based Capability- and Locking-Analysis
https://lore.kernel.org/all/20250918140451.1289454-1-elver@google.com
* [PATCH v3 01/35] compiler_types: Move lock checking attributes to compiler-capability-analysis.h
* [PATCH v3 02/35] compiler-capability-analysis: Add infrastructure for Clang's capability analysis
* [PATCH v3 03/35] compiler-capability-analysis: Add test stub
* [PATCH v3 04/35] Documentation: Add documentation for Compiler-Based Capability Analysis
* [PATCH v3 05/35] checkpatch: Warn about capability_unsafe() without comment
* [PATCH v3 06/35] cleanup: Basic compatibility with capability analysis
* [PATCH v3 07/35] lockdep: Annotate lockdep assertions for capability analysis
* [PATCH v3 08/35] locking/rwlock, spinlock: Support Clang's capability analysis
* [PATCH v3 09/35] compiler-capability-analysis: Change __cond_acquires to take return value
* [PATCH v3 10/35] locking/mutex: Support Clang's capability analysis
* [PATCH v3 11/35] locking/seqlock: Support Clang's capability analysis
* [PATCH v3 12/35] bit_spinlock: Include missing <asm/processor.h>
* [PATCH v3 13/35] bit_spinlock: Support Clang's capability analysis
* [PATCH v3 14/35] rcu: Support Clang's capability analysis
* [PATCH v3 15/35] srcu: Support Clang's capability analysis
* [PATCH v3 16/35] kref: Add capability-analysis annotations
* [PATCH v3 17/35] locking/rwsem: Support Clang's capability analysis
* [PATCH v3 18/35] locking/local_lock: Include missing headers
* [PATCH v3 19/35] locking/local_lock: Support Clang's capability analysis
* [PATCH v3 20/35] locking/ww_mutex: Support Clang's capability analysis
* [PATCH v3 21/35] debugfs: Make debugfs_cancellation a capability struct
* [PATCH v3 22/35] compiler-capability-analysis: Remove Sparse support
* [PATCH v3 23/35] compiler-capability-analysis: Remove __cond_lock() function-like helper
* [PATCH v3 24/35] compiler-capability-analysis: Introduce header suppressions
* [PATCH v3 25/35] compiler: Let data_race() imply disabled capability analysis
* [PATCH v3 26/35] MAINTAINERS: Add entry for Capability Analysis
* [PATCH v3 27/35] kfence: Enable capability analysis
* [PATCH v3 28/35] kcov: Enable capability analysis
* [PATCH v3 29/35] kcsan: Enable capability analysis
* [PATCH v3 30/35] stackdepot: Enable capability analysis
* [PATCH v3 31/35] rhashtable: Enable capability analysis
* [PATCH v3 32/35] printk: Move locking annotation to printk.c
* [PATCH v3 33/35] security/tomoyo: Enable capability analysis
* [PATCH v3 34/35] crypto: Enable capability analysis
* [PATCH v3 35/35] sched: Enable capability analysis for core.c and fair.c

and found the following issue:
general protection fault in validate_page_before_insert

Full report is available here:
https://ci.syzbot.org/series/81182522-74c0-4494-bcf8-976133df7dc7

***

general protection fault in validate_page_before_insert

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      f83ec76bf285bea5727f478a68b894f5543ca76e
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/8f7ff868-4cf7-40da-b62b-45ebfec4e994/config

cgroup: Unknown subsys name 'net'
cgroup: Unknown subsys name 'cpuset'
cgroup: Unknown subsys name 'rlimit'
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 UID: 0 PID: 5775 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:validate_page_before_insert+0x2a/0x300
Code: 55 41 57 41 56 41 55 41 54 53 48 89 f3 49 89 fe 49 bd 00 00 00 00 00 fc ff df e8 f1 3f b3 ff 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 ff e8 17 b3 16 00 4d 8b 3f 4c 89 fe 48
RSP: 0018:ffffc90002a5f608 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffff888022891cc0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888028c71200
RBP: ffffc90002a5f720 R08: 0000000000000000 R09: 1ffff11021cf81e0
R10: dffffc0000000000 R11: ffffed1021cf81e1 R12: dffffc0000000000
R13: dffffc0000000000 R14: ffff888028c71200 R15: 0000000000000008
FS:  00005555815ad500(0000) GS:ffff8880b8615000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1788fd20b8 CR3: 000000010d8a4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 insert_page+0x90/0x2c0
 kcov_mmap+0xc3/0x130
 mmap_region+0x18ae/0x20c0
 do_mmap+0xc45/0x10d0
 vm_mmap_pgoff+0x2a6/0x4d0
 ksys_mmap_pgoff+0x51f/0x760
 do_syscall_64+0xfa/0x3b0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1788d8ebe3
Code: f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 41 89 ca 41 f7 c1 ff 0f 00 00 75 14 b8 09 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 25 c3 0f 1f 40 00 48 c7 c0 a8 ff ff ff 64 c7
RSP: 002b:00007ffc8a37e638 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007ffc8a37e670 RCX: 00007f1788d8ebe3
RDX: 0000000000000003 RSI: 0000000000400000 RDI: 00007f17867ff000
RBP: 00007ffc8a37e940 R08: 00000000000000d8 R09: 0000000000000000
R10: 0000000000000011 R11: 0000000000000246 R12: 0000000000000003
R13: 0000000000000000 R14: 00007f1788fa11c0 R15: 00007f1788e2e478
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:validate_page_before_insert+0x2a/0x300
Code: 55 41 57 41 56 41 55 41 54 53 48 89 f3 49 89 fe 49 bd 00 00 00 00 00 fc ff df e8 f1 3f b3 ff 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 ff e8 17 b3 16 00 4d 8b 3f 4c 89 fe 48
RSP: 0018:ffffc90002a5f608 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffff888022891cc0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888028c71200
RBP: ffffc90002a5f720 R08: 0000000000000000 R09: 1ffff11021cf81e0
R10: dffffc0000000000 R11: ffffed1021cf81e1 R12: dffffc0000000000
R13: dffffc0000000000 R14: ffff888028c71200 R15: 0000000000000008
FS:  00005555815ad500(0000) GS:ffff8880b8615000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1788fd20b8 CR3: 000000010d8a4000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

