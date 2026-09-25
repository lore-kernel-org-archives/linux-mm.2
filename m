Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 761E0C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 10:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F5B66B0092; Fri, 25 Sep 2026 06:05:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CD4A6B0093; Fri, 25 Sep 2026 06:05:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E3456B0095; Fri, 25 Sep 2026 06:05:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A70D6B0092
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:05:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E0A30A6AF0
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:05:18 +0000 (UTC)
X-FDA: 85251851916.03.7A63586
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 46ABC4000A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:05:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WTeHMOUw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790330717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9QKjH4Zvw7ev86vKtZhIFLG3BXwtK9MVvLnMAi8UATs=;
	b=FjPe+GK7Lm08zpws4ZNB1IBN/1Lh2lGav8Y/rCu3BVco04mvdjkMtbjFkU71hk+ymrg12y
	7PjGEPYWoybQrtghcrbPNXOJufLmXaa15UlfQDngwBV2HS0CEwTQKej0dKlKFrKONZsamz
	7AUuCUpp1FnTzuriFyo1KrNjiImM5vs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WTeHMOUw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790330717;
	b=lLa56RaVSIfkQHujPMv6uhRPMo2W8kMN6Ag22iDsQ+/pIdYWPWDZ/1++23Zx+LhPA2KjxT
	IZ2aautrjh5lGapTupjGEWa9PFMBDqRsJdn3a9H/LVBvtaWpjq9bxLezOdwCrVg4J7zz4u
	1MMzcsB+UebSlYZw/gRo8BpAfEjNELk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DDFC41068;
	Fri, 25 Sep 2026 10:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DA91F000FF;
	Fri, 25 Sep 2026 10:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790330716;
	bh=9QKjH4Zvw7ev86vKtZhIFLG3BXwtK9MVvLnMAi8UATs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WTeHMOUwXwTJ8poXqhdaFC7osKWvuD6E+tMTvnkmbLE21spynI63Qf1dkqrXgxIhG
	 0ucJjmyhM4yfHrVA4EqNHT8erDaatzbduNQjSBYMiU8CcxTFzm98bFD+fYMjkKUGvs
	 WtBv/i4AGt7bLZ+omreQoFXV4/j+EyC5cidTIlf/nRygMjbwPYh6Okq7CcKufVg28U
	 Cm1mEliTe0jbN/n4AkiGHlFKu+AxVvoIWKQHErZC27hzeEHtPMnIQ2Lw7QZJ12jqkg
	 1ARTHV64k4dTJ73HajEoSaQ4TK63hm8jTV6jCekTt9LJH6CgSiLsdBliu2Mf37Xz5I
	 O828rA5dnjLbQ==
Date: Fri, 25 Sep 2026 11:05:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, 
	Mike Rapoport <rppt@kernel.org>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <arZFQef9TywPval2@gremlin>
References: <arY1Wq6R9OY20ans@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arY1Wq6R9OY20ans@pcnci.linuxbox.cz>
X-Stat-Signature: dhxix9j6ydfxnmb4ebrpa87q5hc1r7zh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 46ABC4000A
X-HE-Tag: 1790330717-926729
X-HE-Meta: U2FsdGVkX1+NJDzVZJk88JuVp29AItJotT2i7ZUWL9KhCDp3Q3geK+B1k1DhzXA1ztpXx+0qbSAVG1ZsqZAYs9MFd66lntSSp8hwKtoTV4ZK4yS6s/SNVWebspI7ketbb3tHk+kbYz08U8DYfVkXzTOoHgi4qTh/0xsLiOg8/9DVkmqI/WCYcob1a8JMN2k67WH8rx4Zeo8ZvMxbRhlfweXE2Z6LEQ8KF6x/Rsumxpj8GNRkguJPmGBnwOAZcsAIBD33t16hIFMH5NQzs4CpLTf3GSc4PTIPYFmI/Yfflh6kVJS8D2P2AwtPXwoOhSBS/ho8lwItzbJ8ISNp3k1PrB5fHGHv51OMD3naBDTIeICCFBCrL55VzT5PuZXzU4qFgwlL/xoFwc2wiiPRPi/6JnKiIZ9PpOFAWd69JnEkZbeABCi2+d0zChZf8kfMk9g+mz9FCAU+0JMElYaOANK5xz6Gvvb6xF2EibfqfwcfcyLXVy+YZx/P4gCUDAk64/CU/yJtIttopeGSzgovRwztYkLwRZwwAU3uq0mECXbNdhTGGppH8xVFlnH+5wU/0Bd+UU4xyk9kyFlyZy+CIZBZX5BH+P+rVPwwg3almaVDxON4c+kjRIDbhMJ+aikwgyw+eqooH2cLVxbR94IurAPkdubZeyjxcaS+TdgSi5bOq7AtfpDlG5ucAdfwdXXVIE0JPUB5847i7kUNijz4U29iiwZmdLABiHcDUaUHEdJLsvCFUS9hra3N17Rvi+nxe+8g0RnlgHwOL2IwCuisJ46Yo+GW6mcQoFq+CXxw9dGQZNdhXHq772FsUiITw8V/0Nmpb1eRnSybv59M8fC7/dlJiV1aPj33RaEp7ShyKVQe5NKKiwTA7Oj1uwT4gr4SSLXtw7pSxzP8IglrHmJ2UtpVeRaIgS7vJpJgyEQ+fSmJneLhEjkvKK3yn+OprunX3xHjdNENHwj+xW4JV3JbiNk
 kRPaYU8q
 g/kojovb8WnO6Q10Xvw3OCQUQfOgaOKmE0iLd7I0ZMjMkzk67YbUV524j9yVrWFgNKVbY3ys6/1cCi2txdNgx18wtsRFkODQoyf0IlZrk/+HGDUorJQ799vI025hATjhZ+CVYgW4D4t5SUcgXfqjTCYjyHl4y63QDSUVvBIAlZWCjnqOXLnTnJSSluZNVLbDu+96OKx/EQhm7qv6sSsVnxjXNmF1i2/g5M3doXb5WFfipIDc4rf1PAeePqBoTGDS9+hAi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Dave, Mike


On Fri, Sep 25, 2026 at 10:48:26AM +0200, Nikola Ciprich wrote:
> Hi,
>
> I've been hunting a weird memory corruption bug for the last few weeks,
> without success so far, so I'd like to report it and kindly ask for help.
>
> We first hit it after a live VM migration between two KVM hosts:
> suddenly some dynamic libraries in the host appeared to be corrupted:
>
> Inconsistency detected by ld.so: ../sysdeps/x86_64/dl-machine.h: 548: elf_machine_rela_relative: Assertion `ELFW(R_TYPE) (reloc->r_info) == R_X86_64_RELATIVE' failed!
>
> (Later we also hit this with libcrypto.so.3 etc.) The files on disk
> were OK; the problem seemed to exist only in RAM.
>
> I'm fairly sure this is not hardware related: there were no ECC errors,
> and we have since hit this (and similar issues, more on that below) on
> multiple machines.
>
> The problems started after we moved from 5.15.x to 6.18.x kernels.

I had an AI dig into this.

And to give a quick response before trying to wrangle/check what it said
into a coherent analysis, the TL;DR is it seems to be caused by some CPA
bugs we fixed recently in x86.

This should be fixed in 6.18.53+ could you test again with everything
re-enabled?

I'll reply again with something more detailed.

>
> Since then I've spent a lot of time trying to reproduce it on a lab
> cluster, and we were able to trigger some corruption after days of
> migrating VMs back and forth. At first I suspected the Intel ice driver,
> for which I found similar reports, but we saw new problems even after
> backporting fixes (and also with Mellanox cards).
>
> So far we've hit three different kinds of problems, which may or may
> not be related:
>
> - .so library corruption right after VM migration
> - VM crashes (or process crashes inside VMs), possibly related to
>   migration (those always happened during migration)
> - host crashes due to kernel structure corruption (these happened
>   without any VM migration)
>
> We first hit these problems with 6.18.31; the last crash I saw was
> with 6.18.44.
>
> All affected machines use AMD EPYC CPUs and act as KVM hosts; the OS
> is AlmaLinux 9.
>
> I suspect two subsystems that have seen a lot of changes:
>
> - transparent hugepages
> - NUMA balancing
>
> (but those are just my guesses)
>
> As a safety measure, we've disabled THP and NUMA balancing on all hosts.
>
> I'm aware this is still a very vague report with a lot of guessing,
> but my question is: has anybody hit similar problems with 6.18 or
> newer kernels?
>
> I see a lot of patches in every stable release, but simply trying
> newer kernels doesn't seem efficient here. Deploying them is also
> risky, since the hosts have to be emptied by migrating VMs off them
> before reboot, and that migration itself may trigger more crashes.
> None of the released or queued fixes for 6.18 seem to be directly
> related.
>
> I tried running my migration tests on hosts with KASAN enabled, and
> also with SLUB debugging, but was never able to reproduce the problem
> with those enabled (without them, I was able to hit issues within
> days).
>
> I'll start another round of migration tests in the lab, now with
> 6.18.54-rc1, but I still thought it would be good to report this and
> ask here.
>
> last but not least, here's kdump from last crash (this was not related
> to any VM migration, but is very similar to another few crashes
> we got):
>
> [1924553.414736] Oops: general protection fault, probably for non-canonical address 0xfffffff0c930038: 0000 [#1] SMP NOPTI
> [1924553.434800] CPU: 23 UID: 189 PID: 7538 Comm: pacemaker-contr Kdump: loaded Tainted: G            E       6.18.44lb9.01 #1 PREEMPT(voluntary)
> [1924553.456934] Tainted: [E]=UNSIGNED_MODULE
> [1924553.465551] Hardware name: ASUSTeK COMPUTER INC. RS720A-E12-RS12/K14PP-D24 Series, BIOS 2305 11/21/2025
> [1924553.484152] RIP: 0010:__d_lookup+0x4a/0xc0
> [1924553.492878] Code: ff 48 89 c5 c1 e8 07 48 8d 1c c2 e8 60 8f d1 ff 48 8b 03 48 89 c3 48 83 e3 fe 48 83 f8 01 77 0a eb 2f 48 8b 1b 48 85 db 74 27 <39> 6b 18 75 f3 4c 8d 63 78 4c 89 e7 e8
> d5 e1 7c 00 4c 39 6b 10 74
> [1924553.525191] RSP: 0018:ff7532a13699fda0 EFLAGS: 00010212
> [1924553.534986] RAX: 0fffffff0c930020 RBX: 0fffffff0c930020 RCX: 0000000000000000
> [1924553.546679] RDX: ff2e6dbe0d9b6000 RSI: ff7532a13699fe60 RDI: ff2e6d1e4e630d80
> [1924553.558367] RBP: 000000000b654440 R08: 0000000000002403 R09: 0000000000000179
> [1924553.570026] R10: 000000000000000d R11: 0000000000000000 R12: 0000000001876e5c
> [1924553.581601] R13: ff2e6d1e4e630d80 R14: ff7532a13699fe60 R15: 0000000000000000
> [1924553.593115] FS:  00007ff8743aaa80(0000) GS:ff2e6e5e94c45000(0000) knlGS:0000000000000000
> [1924553.605576] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [1924553.615611] CR2: 00007ffcd63a5000 CR3: 00000003ee840001 CR4: 0000000000771ef0
> [1924553.627022] PKRU: 55555554
> [1924553.633869] Call Trace:
> [1924553.640353]  <TASK>
> [1924553.646369]  d_lookup+0x27/0x50
> [1924553.653366]  lookup_dcache+0x1f/0x80
> [1924553.660713]  lookup_one_qstr_excl+0x1e/0xe0
> [1924553.668589]  ? preempt_schedule_common+0x2c/0x70
> [1924553.676837]  filename_create+0xc4/0x160
> [1924553.684209]  do_mkdirat+0x5a/0x190
> [1924553.691050]  __x64_sys_mkdir+0x42/0x60
> [1924553.698163]  do_syscall_64+0x64/0xbf0
> [1924553.705145]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [1924553.713533] RIP: 0033:0x7ff8754ff08b
> [1924553.720358] Code: 8b 05 91 bd 0f 00 41 bc ff ff ff ff 64 c7 00 16 00 00 00 e9 4f ff ff ff e8 12 f7 01 00 66 90 f3 0f 1e fa b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 5d
> bd 0f 00 f7 d8 64 89 01 48
> [1924553.748552] RSP: 002b:00007ffc05e5c148 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
> [1924553.759401] RAX: ffffffffffffffda RBX: 00005623cc0bd513 RCX: 00007ff8754ff08b
> [1924553.769760] RDX: 000000000fde421b RSI: 00000000000001c0 RDI: 00005623cc0bd4f4
> [1924553.780083] RBP: f49998db0aa753ff R08: 0000000000000004 R09: 0000000000000001
> [1924553.790348] R10: 00007ff87587d000 R11: 0000000000000246 R12: 8421084210842109
> [1924553.800604] R13: 00005623cc0bd513 R14: 00007ff8755bd740 R15: 000000000fde421b
> [1924553.810819]  </TASK>
>
> I'll be very very gratefull for any hints here..

Hi, I had a

>
> with best regards
>
> nikola ciprich
>
> PS: I tried to CC maintainers of suspected subsystems, but those are just my guesses,
> so I hope I won't offend anyone.
>

--
Cheers, Lorenzo

