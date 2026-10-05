Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D21CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 08:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 629826B0088; Mon,  5 Oct 2026 04:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D9C26B008C; Mon,  5 Oct 2026 04:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C96C6B0095; Mon,  5 Oct 2026 04:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F3DA6B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:31:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94C53C018C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:31:21 +0000 (UTC)
X-FDA: 85287903162.01.21C4DAC
Received: from mta0.migadu.com (out-82.mta0.migadu.com [91.218.175.82])
	by imf30.hostedemail.com (Postfix) with ESMTP id 654A280005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:31:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j89UXEVf;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.82 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791189079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0etm5y0JSEfvHQiFIPISfzo3FkIiRqHMguzUOcDnjd0=;
	b=QmhFS/axZ5Xgm2Wgbz+qKi1Rq1JkjWAPzU0oxwyxxVNikO7Z+pGbAK7myswZgwQ7MIAWSz
	Hf+x89F++UxmNm53Ic9Els1uEPuGPQ/y9v5ZQcGIGDZaxpdfL6OTNLEyy+leuEIYrdiNLl
	yFrU4amE9TB9hmo/Crky2yzY3YgtkJw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791189079;
	b=ukxzs4HA4JZ5sJ/3/Wt/L9zDfaeAB5wu5d8Ql/HDCCXzh/tONEKjfrGTcvyiwjh5tkE+Da
	18/iZ3+GPogewPcyxaSzuF1dqtD6OMa7/2OBlacgH3lOae3AXavXlAK8tmGnAomzrSI9z0
	FbMO0ou+/DZQjTTuKh1bh2XMc3yQMKo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j89UXEVf;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.82 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gNitw50LwGM11s3LoORNB2PRRIlwARQQvdJlo/NxCq4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791189077; v=1; x=1791793877;
 b=j89UXEVfyfXObGOL8oWeTvnMfv38mITKuCkbIIG9YvDmSmwbHgJkLCLVojMxhTJzRIaiA5wB
 gy9ki3kZ6FtABhQpAP/YVlbzekpB1TQIq3kxkUCJL22c3cMIaozMJW/x/UPTnsEZc2+RLn+ohZD
 97b0nboU+JMKgyPjzim9ttLI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e14146ab66f2a19e;
	Mon, 05 Oct 2026 08:31:17 +0000
X-Mizu-Trace-ID: e14146ab66f2a19e
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: nikola.ciprich@linuxbox.cz,
	andrew.cooper3@citrix.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Subject: Re: hunting memory corruption bug in 6.18.x
Date: Mon,  5 Oct 2026 16:31:11 +0800
Message-ID: <20261005083111.71376-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <arY1Wq6R9OY20ans@pcnci.linuxbox.cz>
References: <arY1Wq6R9OY20ans@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 654A280005
X-Stat-Signature: q5b7dygi6wigm6i8eoidk97oc3qnzim1
X-Rspam-User: 
X-HE-Tag: 1791189079-700037
X-HE-Meta: U2FsdGVkX19AhG44nNwoZQwL9q06XY7HktdovVcnKIUoKaF2jlJGfJyvIYp2Cschz5Ty/hVipMw5/dApS+vB2luS7DG2idgMx7thfvFhtyTkCAGSCnrkN/uYXtJlOJTnXTB9BjeOTXvWfw7S1Yg+OOTSDAb3A6B7s0kNk50fqixU+A28Fz4ICROrfcrv0pQwKd4vdSe8sSV17/bi0tdbivcJNsylwGvM3amhV1C/Wwu9TGK115F/UWEZ3+CvuvWzJPOT3PUmo5u40VadNAw+5U+WsRP7K81oTM17D1qA6TcaUEGJ9w9DHElrGjQ/7eErhKi/JliHWgV8Gdy/+CuK4WxzVBGCkiBX3VX5pSsHgmq9uh6Yc6oDylEqBVODMFFyLsDFk9cLTAAAhyzJSAqxkkRXJjWwyoRVRxxzKis28RypM+K1N5M7shXbV6Ny/4Szxdjvu9GP5n9i/scPQJoBct3tRFD6Axm//cMyfnkc1BG3qC1M0P7Lvm2ogvxCF7M7foMODf77ItniLWoF+G9aGKs585rCML81muaqJ4odkOgc+chO0jghDFBGLx973i8DCP9g0+0ohZCzaR3x/eTZetAIJLwNaLFQhjtiewwbf6bJaFE3VHOj7LYiPMX7KGI1ybiU0FAtkHXUEWGiPrz7D8DNMHmi+8QSx7JFCDahrnJv6GF9WA/vx0gv3jveUz0n05VC9m6fV53U+Zmw8pt2hvNOpa+HK77o8ZhB3wKiLPWT4BlxKJpcbikV+CbwTO1dt8vTK/VkDTxtlyXk7WqkaT+pP+v43uBDlXLLd2R2MRBnJsYujpK9frnRN7N4sH3pCfK7GHIUCjZyMBVyENMagEi25UlkwSFlXpHiMO2BPqBUQOrZGyMp0rZ72sPJXnp9cTLnhEJ2sMM7V4348pFEPUgjaBhvHDWJSCKiuYmOpcYoGEf0EV5tDT7Ge6GwcZ+MGOuGYSZk7XwfxIrl9vT
 KOGAtzHR
 qenLlfs/txeEAoOTDe/HeuUWs8Evr1vHE75GN4N/SbLSLesxqzWlCSzLmdwivzVtQD7iU9nY1aX1TuJDrxyfvGk3zDUgPBvaLHuzLY0rv1HDFd7zNt2nj1eyLFKbk9CCijr95bY64N8h4kPJ2jl3ckuRO9GVoVZvRTjBotBuz2A+0JVXHR2JbJDQDSs+iXKCuHJCJRRum/OG0Q/XdCi5sZRGv9KTb4bbJaIr/KKtmDty5pZI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc: Andrew Cooper

Andrew mentioned

"
That looks like the Zen5 issue ...
"

in another thread. Could you elaborate on that?

Cheers, Lance

On Fri, Sep 25, 2026 at 10:48:26AM +0200, Nikola Ciprich wrote:
>Hi,
>
>I've been hunting a weird memory corruption bug for the last few weeks,
>without success so far, so I'd like to report it and kindly ask for help.
>
>We first hit it after a live VM migration between two KVM hosts:
>suddenly some dynamic libraries in the host appeared to be corrupted:
>
>Inconsistency detected by ld.so: ../sysdeps/x86_64/dl-machine.h: 548: elf_machine_rela_relative: Assertion `ELFW(R_TYPE) (reloc->r_info) == R_X86_64_RELATIVE' failed!
>
>(Later we also hit this with libcrypto.so.3 etc.) The files on disk
>were OK; the problem seemed to exist only in RAM.
>
>I'm fairly sure this is not hardware related: there were no ECC errors,
>and we have since hit this (and similar issues, more on that below) on
>multiple machines.
>
>The problems started after we moved from 5.15.x to 6.18.x kernels.
>
>Since then I've spent a lot of time trying to reproduce it on a lab
>cluster, and we were able to trigger some corruption after days of
>migrating VMs back and forth. At first I suspected the Intel ice driver,
>for which I found similar reports, but we saw new problems even after
>backporting fixes (and also with Mellanox cards).
>
>So far we've hit three different kinds of problems, which may or may
>not be related:
>
>- .so library corruption right after VM migration
>- VM crashes (or process crashes inside VMs), possibly related to
>  migration (those always happened during migration)
>- host crashes due to kernel structure corruption (these happened
>  without any VM migration)
>
>We first hit these problems with 6.18.31; the last crash I saw was
>with 6.18.44.
>
>All affected machines use AMD EPYC CPUs and act as KVM hosts; the OS
>is AlmaLinux 9.
>
>I suspect two subsystems that have seen a lot of changes:
>
>- transparent hugepages
>- NUMA balancing
>
>(but those are just my guesses)
>
>As a safety measure, we've disabled THP and NUMA balancing on all hosts.
>
>I'm aware this is still a very vague report with a lot of guessing,
>but my question is: has anybody hit similar problems with 6.18 or
>newer kernels?
>
>I see a lot of patches in every stable release, but simply trying
>newer kernels doesn't seem efficient here. Deploying them is also
>risky, since the hosts have to be emptied by migrating VMs off them
>before reboot, and that migration itself may trigger more crashes.
>None of the released or queued fixes for 6.18 seem to be directly
>related.
>
>I tried running my migration tests on hosts with KASAN enabled, and
>also with SLUB debugging, but was never able to reproduce the problem
>with those enabled (without them, I was able to hit issues within
>days).
>
>I'll start another round of migration tests in the lab, now with
>6.18.54-rc1, but I still thought it would be good to report this and
>ask here.
>
>last but not least, here's kdump from last crash (this was not related
>to any VM migration, but is very similar to another few crashes
>we got):
>
>[1924553.414736] Oops: general protection fault, probably for non-canonical address 0xfffffff0c930038: 0000 [#1] SMP NOPTI
>[1924553.434800] CPU: 23 UID: 189 PID: 7538 Comm: pacemaker-contr Kdump: loaded Tainted: G            E       6.18.44lb9.01 #1 PREEMPT(voluntary)
>[1924553.456934] Tainted: [E]=UNSIGNED_MODULE
>[1924553.465551] Hardware name: ASUSTeK COMPUTER INC. RS720A-E12-RS12/K14PP-D24 Series, BIOS 2305 11/21/2025
>[1924553.484152] RIP: 0010:__d_lookup+0x4a/0xc0
>[1924553.492878] Code: ff 48 89 c5 c1 e8 07 48 8d 1c c2 e8 60 8f d1 ff 48 8b 03 48 89 c3 48 83 e3 fe 48 83 f8 01 77 0a eb 2f 48 8b 1b 48 85 db 74 27 <39> 6b 18 75 f3 4c 8d 63 78 4c 89 e7 e8
>d5 e1 7c 00 4c 39 6b 10 74
>[1924553.525191] RSP: 0018:ff7532a13699fda0 EFLAGS: 00010212
>[1924553.534986] RAX: 0fffffff0c930020 RBX: 0fffffff0c930020 RCX: 0000000000000000
>[1924553.546679] RDX: ff2e6dbe0d9b6000 RSI: ff7532a13699fe60 RDI: ff2e6d1e4e630d80
>[1924553.558367] RBP: 000000000b654440 R08: 0000000000002403 R09: 0000000000000179
>[1924553.570026] R10: 000000000000000d R11: 0000000000000000 R12: 0000000001876e5c
>[1924553.581601] R13: ff2e6d1e4e630d80 R14: ff7532a13699fe60 R15: 0000000000000000
>[1924553.593115] FS:  00007ff8743aaa80(0000) GS:ff2e6e5e94c45000(0000) knlGS:0000000000000000
>[1924553.605576] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>[1924553.615611] CR2: 00007ffcd63a5000 CR3: 00000003ee840001 CR4: 0000000000771ef0
>[1924553.627022] PKRU: 55555554
>[1924553.633869] Call Trace:
>[1924553.640353]  <TASK>
>[1924553.646369]  d_lookup+0x27/0x50
>[1924553.653366]  lookup_dcache+0x1f/0x80
>[1924553.660713]  lookup_one_qstr_excl+0x1e/0xe0
>[1924553.668589]  ? preempt_schedule_common+0x2c/0x70
>[1924553.676837]  filename_create+0xc4/0x160
>[1924553.684209]  do_mkdirat+0x5a/0x190
>[1924553.691050]  __x64_sys_mkdir+0x42/0x60
>[1924553.698163]  do_syscall_64+0x64/0xbf0
>[1924553.705145]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>[1924553.713533] RIP: 0033:0x7ff8754ff08b
>[1924553.720358] Code: 8b 05 91 bd 0f 00 41 bc ff ff ff ff 64 c7 00 16 00 00 00 e9 4f ff ff ff e8 12 f7 01 00 66 90 f3 0f 1e fa b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 5d
>bd 0f 00 f7 d8 64 89 01 48
>[1924553.748552] RSP: 002b:00007ffc05e5c148 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
>[1924553.759401] RAX: ffffffffffffffda RBX: 00005623cc0bd513 RCX: 00007ff8754ff08b
>[1924553.769760] RDX: 000000000fde421b RSI: 00000000000001c0 RDI: 00005623cc0bd4f4
>[1924553.780083] RBP: f49998db0aa753ff R08: 0000000000000004 R09: 0000000000000001
>[1924553.790348] R10: 00007ff87587d000 R11: 0000000000000246 R12: 8421084210842109
>[1924553.800604] R13: 00005623cc0bd513 R14: 00007ff8755bd740 R15: 000000000fde421b
>[1924553.810819]  </TASK>
>
>I'll be very very gratefull for any hints here..
>
>with best regards
>
>nikola ciprich
>
>PS: I tried to CC maintainers of suspected subsystems, but those are just my guesses,
>so I hope I won't offend anyone.
>
>

