Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C6F1C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 08:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 224666B0095; Fri, 25 Sep 2026 04:48:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FB976B0096; Fri, 25 Sep 2026 04:48:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C6436B0098; Fri, 25 Sep 2026 04:48:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC35A6B0095
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:48:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 53A4980554
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:48:46 +0000 (UTC)
X-FDA: 85251659052.29.0BE2035
Received: from gwu.lbox.cz (gwu.lbox.cz [62.245.111.132])
	by imf01.hostedemail.com (Postfix) with ESMTP id D261540006
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:48:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=LlgkgILF;
	dmarc=pass (policy=none) header.from=linuxbox.cz;
	spf=pass (imf01.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790326124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=A50e+YgdNLkM4nQFJoNYZfD+GUb7IwX8nYRhcaDLAX8=;
	b=RIsAEqjLw9sdyXpc+j4LWO7zEun3/Ch14G3RO+IGB0ihk97xAo6/rmEsLQdNzIQuAAp3yA
	DgN/MbS3Cxf5HDFZEJ+G7OFDksvlN7q03NLBbrhP7zlx9iDcADMq93AAcg2OiBbz7DPP99
	4PuB41jIdlJ7Re2UwfKDgDQJ11MABrQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=LlgkgILF;
	dmarc=pass (policy=none) header.from=linuxbox.cz;
	spf=pass (imf01.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790326124;
	b=DnnsfkvDesK2Qhotz5sA4QnV1RiLq8SjAgP9P+A/dl5Nn1j7KnPESjhnQedgCdqJEw5hF9
	/jFj8Z2AXl3zBQh9BfqrE9QS/PjCEAI3bC2AOWG/Tn58UP7Slah5q045J2m7l61aFwkayH
	CWyDuHvw+ad9JTbEkZ9BqdYhzLc9sO0=
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTPS id 68P8mUvO2944311
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 25 Sep 2026 10:48:30 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 68P8mUvO2944311
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
	s=default; t=1790326110;
	bh=A50e+YgdNLkM4nQFJoNYZfD+GUb7IwX8nYRhcaDLAX8=;
	h=Date:From:To:Cc:Subject:From;
	b=LlgkgILFSJnaa3lUS/f0dgMDBP2AsVOBxiJ17PyQ9hY8YKFZ2wQK0BNaNo/444d8C
	 1bxr9GcbqfIbtVf7frJOfT+eIWAyHnwEQdtWdkCqS4JfbAY2l+mo1DXr/NgXNKMsRu
	 6vO4o2yiv3e8aSEQRN6bCYeDP6M8HVKTr60pUUsk=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 68P8mTuQ044319
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 25 Sep 2026 10:48:29 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
	by pcnci.linuxbox.cz (8.18.1/8.15.2) with ESMTPS id 68P8mQQp1861687
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Sep 2026 10:48:29 +0200
Date: Fri, 25 Sep 2026 10:48:26 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org,
        ljs@kernel.org, nikola.ciprich@linuxbox.cz
Subject: hunting memory corruption bug in 6.18.x
Message-ID: <arY1Wq6R9OY20ans@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.7.1 on 10.76.66.3
X-Scanned-By: MIMEDefang v3.7.1/SpamAssassin v4.000002 on lbxovapx9 (nik)
X-Scanned-By: MIMEDefang 2.86 on 10.76.66.10
X-Antivirus: on lbxovapx9 by Antivirus 
X-Milter-Copy-Status: O
X-Stat-Signature: f99xmkjew9yt1r8j5gmrn46pbkymwnq9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D261540006
X-HE-Tag: 1790326123-347214
X-HE-Meta: U2FsdGVkX19sdsej9nFMqFcQXT1Itw1SywCyPISfwsDTmyUMQHL0+iKigcFLTiwJnw3oNrwfnpBHr4XLmhtyTmJGEDkSDbbTnH8oBMJr/6fOU2/vanntpr78f+eLABPyybkbYM3Y45EWuySxr1ouJUZ8RGIya+OaT5G8vBx7oX5dZ5SVUrpeu9o4JvytAFCMMOeGZs3hFbGmtRGPnnG5FnThzKbTh5STLaLppD1/JvtyRmc3cU4fsW2cceIdSJhV/TgwXS/7BPVz7d1evvPC41oJ1vWzZnnQhdlH1/I4O2xBo6sHu/EpODmMi3vx+cN04unmVlMW/5RfJC0VlipZhsa8d+jPMqbOBjH65XBexekfZpS3CJKUAXLgjY9/uSa1h41Qr4u9TB25zpMomGKZcMTJSyf2zpgBvmgjUqesSgQLi0t/DrJavOuQSVeu2iuh/o7JDcukM/xt+SIKGPFxRvxELKlClxD9QyvXglXP4HM4tdovHNbJNjCHV/NIOCPcKNRrf4wLu9plxrzOU20Cg4HLx+WFWYaPhZ70qwOvHj+c6fqyGaOP1fzkTkFRQG+Pu3QybmLvH4aw9edpP6sk2FRmUEzCbpFAfRDWOipKJx307aSEpGHTuvgLyENYqqGoGtKL4kaetarykUiEJ5iB2ERaTzNvzc0vVGQXb2Oky/iFkRlvrBnvOJvXYNCa3yB7ENNwRY/aEKbk9QwZFPutUm/+uacZjyb3RKKXANQmRrLrS14FT4VF6yiaBe/VpQILFSTs08z9jm8kEAgNSeCAoH7tqzrsANwZ/0TiRnuk6ne1suRTwGCyy8fV7hb6iEdh0TlUJeClQ2F/AbwI1NE+FH7osEs9MtEv8ciMV4ck0uUiJ+oGITGx402fzFvjvFivkn/3kuebIKE2wMVrHB/aFZUOYNhYMwoFm+E45T/izdkkFduEeHmHfgxvIYoJFViCir6q9os4VeiNeRFQejV
 iaSyWAIl
 K28G9g9ZnPHZKRtJ4Q7qoF13mwAO4I7ECT3wyIb3fSRMXs52PWbSouS7bPCQvMPq/TH7Cvo7iyjgdF0tw6ktjZB/9124Q6buXoXBw2B6l5oZQcRTNTAbF42AKMi2DWZZ4cKlNtYDTtkF+BpdzeTxS8Cw2w1FVXhL8JIUdX1xMuIND/9F945dUhWA+Gz41R0r1RkO/1TykOBvR3Kt0HcKj6Zi/4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I've been hunting a weird memory corruption bug for the last few weeks,
without success so far, so I'd like to report it and kindly ask for help.

We first hit it after a live VM migration between two KVM hosts:
suddenly some dynamic libraries in the host appeared to be corrupted:

Inconsistency detected by ld.so: ../sysdeps/x86_64/dl-machine.h: 548: elf_machine_rela_relative: Assertion `ELFW(R_TYPE) (reloc->r_info) == R_X86_64_RELATIVE' failed!

(Later we also hit this with libcrypto.so.3 etc.) The files on disk
were OK; the problem seemed to exist only in RAM.

I'm fairly sure this is not hardware related: there were no ECC errors,
and we have since hit this (and similar issues, more on that below) on
multiple machines.

The problems started after we moved from 5.15.x to 6.18.x kernels.

Since then I've spent a lot of time trying to reproduce it on a lab
cluster, and we were able to trigger some corruption after days of
migrating VMs back and forth. At first I suspected the Intel ice driver,
for which I found similar reports, but we saw new problems even after
backporting fixes (and also with Mellanox cards).

So far we've hit three different kinds of problems, which may or may
not be related:

- .so library corruption right after VM migration
- VM crashes (or process crashes inside VMs), possibly related to
  migration (those always happened during migration)
- host crashes due to kernel structure corruption (these happened
  without any VM migration)

We first hit these problems with 6.18.31; the last crash I saw was
with 6.18.44.

All affected machines use AMD EPYC CPUs and act as KVM hosts; the OS
is AlmaLinux 9.

I suspect two subsystems that have seen a lot of changes:

- transparent hugepages
- NUMA balancing

(but those are just my guesses)

As a safety measure, we've disabled THP and NUMA balancing on all hosts.

I'm aware this is still a very vague report with a lot of guessing,
but my question is: has anybody hit similar problems with 6.18 or
newer kernels?

I see a lot of patches in every stable release, but simply trying
newer kernels doesn't seem efficient here. Deploying them is also
risky, since the hosts have to be emptied by migrating VMs off them
before reboot, and that migration itself may trigger more crashes.
None of the released or queued fixes for 6.18 seem to be directly
related.

I tried running my migration tests on hosts with KASAN enabled, and
also with SLUB debugging, but was never able to reproduce the problem
with those enabled (without them, I was able to hit issues within
days).

I'll start another round of migration tests in the lab, now with
6.18.54-rc1, but I still thought it would be good to report this and
ask here.

last but not least, here's kdump from last crash (this was not related
to any VM migration, but is very similar to another few crashes
we got):

[1924553.414736] Oops: general protection fault, probably for non-canonical address 0xfffffff0c930038: 0000 [#1] SMP NOPTI
[1924553.434800] CPU: 23 UID: 189 PID: 7538 Comm: pacemaker-contr Kdump: loaded Tainted: G            E       6.18.44lb9.01 #1 PREEMPT(voluntary)
[1924553.456934] Tainted: [E]=UNSIGNED_MODULE
[1924553.465551] Hardware name: ASUSTeK COMPUTER INC. RS720A-E12-RS12/K14PP-D24 Series, BIOS 2305 11/21/2025
[1924553.484152] RIP: 0010:__d_lookup+0x4a/0xc0
[1924553.492878] Code: ff 48 89 c5 c1 e8 07 48 8d 1c c2 e8 60 8f d1 ff 48 8b 03 48 89 c3 48 83 e3 fe 48 83 f8 01 77 0a eb 2f 48 8b 1b 48 85 db 74 27 <39> 6b 18 75 f3 4c 8d 63 78 4c 89 e7 e8
d5 e1 7c 00 4c 39 6b 10 74
[1924553.525191] RSP: 0018:ff7532a13699fda0 EFLAGS: 00010212
[1924553.534986] RAX: 0fffffff0c930020 RBX: 0fffffff0c930020 RCX: 0000000000000000
[1924553.546679] RDX: ff2e6dbe0d9b6000 RSI: ff7532a13699fe60 RDI: ff2e6d1e4e630d80
[1924553.558367] RBP: 000000000b654440 R08: 0000000000002403 R09: 0000000000000179
[1924553.570026] R10: 000000000000000d R11: 0000000000000000 R12: 0000000001876e5c
[1924553.581601] R13: ff2e6d1e4e630d80 R14: ff7532a13699fe60 R15: 0000000000000000
[1924553.593115] FS:  00007ff8743aaa80(0000) GS:ff2e6e5e94c45000(0000) knlGS:0000000000000000
[1924553.605576] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1924553.615611] CR2: 00007ffcd63a5000 CR3: 00000003ee840001 CR4: 0000000000771ef0
[1924553.627022] PKRU: 55555554
[1924553.633869] Call Trace:
[1924553.640353]  <TASK>
[1924553.646369]  d_lookup+0x27/0x50
[1924553.653366]  lookup_dcache+0x1f/0x80
[1924553.660713]  lookup_one_qstr_excl+0x1e/0xe0
[1924553.668589]  ? preempt_schedule_common+0x2c/0x70
[1924553.676837]  filename_create+0xc4/0x160
[1924553.684209]  do_mkdirat+0x5a/0x190
[1924553.691050]  __x64_sys_mkdir+0x42/0x60
[1924553.698163]  do_syscall_64+0x64/0xbf0
[1924553.705145]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[1924553.713533] RIP: 0033:0x7ff8754ff08b
[1924553.720358] Code: 8b 05 91 bd 0f 00 41 bc ff ff ff ff 64 c7 00 16 00 00 00 e9 4f ff ff ff e8 12 f7 01 00 66 90 f3 0f 1e fa b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 5d
bd 0f 00 f7 d8 64 89 01 48
[1924553.748552] RSP: 002b:00007ffc05e5c148 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
[1924553.759401] RAX: ffffffffffffffda RBX: 00005623cc0bd513 RCX: 00007ff8754ff08b
[1924553.769760] RDX: 000000000fde421b RSI: 00000000000001c0 RDI: 00005623cc0bd4f4
[1924553.780083] RBP: f49998db0aa753ff R08: 0000000000000004 R09: 0000000000000001
[1924553.790348] R10: 00007ff87587d000 R11: 0000000000000246 R12: 8421084210842109
[1924553.800604] R13: 00005623cc0bd513 R14: 00007ff8755bd740 R15: 000000000fde421b
[1924553.810819]  </TASK>

I'll be very very gratefull for any hints here..

with best regards

nikola ciprich

PS: I tried to CC maintainers of suspected subsystems, but those are just my guesses,
so I hope I won't offend anyone.


