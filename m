Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97286606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 05:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=il2Fkdoj
Received: by kanga.kvack.org (Postfix)
	id 5480A6B05BB; Wed, 18 Nov 2026 00:10:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D0706B05BC; Wed, 18 Nov 2026 00:10:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C0776B05BD; Wed, 18 Nov 2026 00:10:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F19696B05BB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:10:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75F6B40642
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:10:00 +0000 (UTC)
X-FDA: 85447062960.24.669FEA3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D510120005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:09:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=il2Fkdoj;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794978598;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=94w7zfoHb1h/5IU62GWa+RuGhpaQ8snNzNZNBGJzn/0=;
	b=VKEdyr0nQZVY3C1Rdjw9q80lFUfMu66pq8b05f/DputCVh448E+NWeYQG+Ro6y+e/kAhrS
	DY7CYeL0HFOSwTkkgMvvpzpQbcmJXdhsRQzypXmR6rhTCuDoS908DKwUyQaoD2xXJKRMAc
	ZLYR7Jg9EwJW7VKOJ84DqEXlC64sZjQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794978598;
	b=Z3mcBaR4SFZz/yqKQ1eWrmpOB8dXu3AZyaB6RKZuuL68hT4jBHooaE2j9Q9GRytTd6ueX/
	PlTMWA4IPmmYrYwXW+c+HUtjj7sLtuFuce4ieP51XqI1pv0EiREeHcfPtDGgUYNgseWLKT
	2GTQZDc3eJGCdFrfF+TwqrHaJLRkqpM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=il2Fkdoj;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5302F60AB0;
	Wed, 18 Nov 2026 05:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEE71F000C4;
	Wed, 18 Nov 2026 05:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794978598;
	bh=94w7zfoHb1h/5IU62GWa+RuGhpaQ8snNzNZNBGJzn/0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=il2Fkdojk1/zmSFyXaKxGS9NKV9ZALe7oON28kTxvqYTT5bQfco0oDmfx4NVilxCp
	 te8e1xuYk8UMetjUJWIA3EnT131pseDPjxlwfZVIcxYg8CQwP0q3kXQ34jWcKnnHH2
	 VAjWXk+e6IEzYGEL93Ee/NC2Y7MsMjvIFG6QBCnWkixZRk1+CF1mOCxxQ5MpWsh+p+
	 W/cZS6ZtHiX8hr7J46L+yZJiqN+QibsWpLITNmmStChVIIG+nsztwUu6QmXSWNMtSS
	 o4eo79N68MAD7/MJJLQ4xCndBuoEa02KgAiBHjZjmjfNtDrSh6KDthZU0zAm3cwo/q
	 EovNSXKSMNLgA==
Message-ID: <sashiko-outbox-220145@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 10/13] arch: Wire up rootns system calls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Andrew Morton" <akpm@linux-foundation.org>, "Ben
 Segall" <bsegall@google.com>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "David Howells" <dhowells@redhat.com>, "Davidlohr
 Bueso" <dave@stgolabs.net>, "Dietmar Eggemann" <dietmar.eggemann@arm.com>, "Ingo
 Molnar" <mingo@redhat.com>, "Jan Kara" <jack@suse.cz>, "Jonathan Corbet" <corbet@lwn.net>, "Juri
 Lelli" <juri.lelli@redhat.com>, "Kees Cook" <kees@kernel.org>, "K Prateek
 Nayak" <kprateek.nayak@amd.com>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Manfred Spraul" <manfred@colorfullife.com>, "Mel
 Gorman" <mgorman@suse.de>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Neal
 Gompa" <neal@gompa.dev>, "Paul Moore" <paul@paul-moore.com>, "Pavel
 Tikhomirov" <ptikhomirov@virtuozzo.com>, "Peter Zijlstra" <peterz@infradead.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Serge Hallyn" <sergeh@kernel.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Valentin Schneider" <vschneid@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Vlastimil Babka" <vbabka@kernel.org>
In-Reply-To: <20261117050841.3289652-11-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
 <20261117050841.3289652-11-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 05:09:56 +0000
X-Stat-Signature: 5hmispn4zeutpx1tktt5aegju7i9tu75
X-Rspam-User: 
X-Rspamd-Queue-Id: D510120005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794978598-637478
X-HE-Meta: U2FsdGVkX18MgBmatJem1KipcCWCfdDiHxCM5Rf0zK9UTgAnwJBfPqG7H9tY029kgPevxvyuVGpwm8FXoXH0O2aGp+1TSmOkCDOtSxIaZaMcYo+F4TdaAeXK84ypewNVLD4BC72RPwsrHKBLAltAGsc45MhLAgY/GD4Gp60stbUEdKWPlhcy+kus8JzHi+wqblko4mPpE3fnOxZ4bgY7kvLINZayHPHz/30r7wRjleJFRvuAEN5YyJ8IuzyoeajJIV3VYweQlGzb9dpOFoCBeVTMfl941o6VHnRSAiCkMnpU7m3wfymHxDCFQ5hNWtcu5RAibyhR+lm9JfPOvwCRsvajxX1UUZF7RHHTPFAZ7h3MEbnhcNGdiUp5y5PBkHCwZRhgbL3yGKAc2PHig88NxxC03cu6ln8ksLSrOdgt4GWZop5lApK0s9D1POIgpyI8XjeW9mfgTlX1ul9lOD6159YIJuL8bjpAmnPgOgHLLt6IHZO1yoQwP+ttySIImWdLh+MFfkvbWk3OjshBSneGFMtROO312BApiBN0cMXq7WCCtfIdHWFDUOZtZYOxXcKkGGKSQ/Lo2SZfJJ6ZOeYaiCv4m+w7YK/rAB5gkDRI6n/eO0pDvA0U2BvZocydKyQi2gvK+PcRX4JhyMsGgFOzh8mEi3Vf6UTdY7J5daYPzw1y3qsaqVMZh29RR2yio3yReU6sEsrw0zFphRAy3zEPL8nQ76IL5XPCW6oG245akn5tPCmcjyewvWtErG1bhSYvztKT35Ca10QuE1aDx3MqJ8ZKJ/03Cb1dhyrXza7ZPm+ty64rpF372DgsPxmYN0JmubILJdqdiU0kee7iLxDhWvtHwXM/EGPdXPzUM+HpPoDjqIMF2tmwyYLMVesO3PJ1SOSixHk6HUMUFqiUS04b5QCdDjZIIZVJX5a78qmU88dWbq6UizHLIHglhAUfmHiaWqZCJrkLuPvzGlT0MF5
 FuY1uzKA
 yqggd2/hofFZDlKAUYAkWY9PZlDKT6CKDAlDBxZbCtxJqfsWqIglUgvwQ6oeUBlWbSaYXqf1D9n3YI6e22N+Mslb9xeUBjMr3xASWCkFoKMvb2WSXczh7skmpAmVDnTw658XQDVdNZdlJH68EtUrylfx1K3RQwJ7lI7XY/x4tIL1bpgTmiYotOKlQuu3k9quVmLJtXiBJEXYreK2cYoAJ9u/3elogCuzdnvKWU7QVaTYWK7NQnHCO1EUyKMM1iADcjxYA2Vk/VfJMPu6+TnYvJ6//zboaUqrx+TrGc6zWYuMp2nupmBhvcncQWYa64BUcW2PyaFH6DOKHn1pvTtCfnZwEfuJ4uLHeuLtHZ2uzQ8CPlDT0UKNE6LlgRROkHJVhNlrWvn2RtCHRbQxOCwzXfhNvMchWTn5x+19ptVz7YJrbGNMepv+pdOd1zhWbuUgn4y20aM0sMygZmvaC7AwvSxNDr4IKtWZsVhKOGbtfLvIQykpRGf2a3lo7N5WCMAoWO7xkSqfeamNaP2T5vA/Zl73THyM/FC4ie2cnOq18mfOxaTCZA78w42p0nbGHud0Tt/jDCz93EiHF2/aMfYS4WCOrrGF5UKnncY/I7GnVRH3Otv0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] arch: missing fork wrappers and copy_thread() handling for
  rootns_enter()
- [Medium] powerpc: syscalls: mark rootns syscalls as nospu instead of
  common
--

commit 6e1db5e1442ac6454b78c4391c7f17751ffafb5b
Author: Jarkko Sakkinen <jarkko@kernel.org>

arch: Wire up rootns system calls

This commit wires up the rootns_create(), rootns_wait(), rootns_kill(), and
rootns_enter() system calls across the architecture syscall tables and
asm-generic/unistd.h.

> diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/s=
yscalls/syscall.tbl
> index 52e3538cc7df4..a945b15abe6dd 100644
> --- a/arch/alpha/kernel/syscalls/syscall.tbl
> +++ b/arch/alpha/kernel/syscalls/syscall.tbl
> @@ -512,3 +512,7 @@
>  580	common	listns				sys_listns
>  581	common	rseq_slice_yield		sys_rseq_slice_yield
>  582	common	fchroot				sys_fchroot
> +583	common	rootns_create			sys_rootns_create
> +584	common	rootns_wait			sys_rootns_wait
> +585	common	rootns_kill			sys_rootns_kill
> +586	common	rootns_enter			sys_rootns_enter

[Severity: High]
Does wiring rootns_enter directly to sys_rootns_enter corrupt the child
process's user registers and leak kernel stack contents on architectures th=
at
require a fork-like entry wrapper?

sys_rootns_enter() calls kernel_clone() -> copy_process() -> copy_thread().
On Alpha, normal syscall entry (entSys) pops struct switch_stack before
calling the C handler, whereas fork, vfork, clone, and clone3 use fork_like
wrappers (alpha_clone3, etc.) to push struct switch_stack and call
__save_fpu().  Without that wrapper, copy_thread() copies
((struct switch_stack *)regs) - 1, which holds sys_rootns_enter()'s C stack
frame, into childstack and restores kernel stack words into the child's
r9-r15 registers in ret_from_fork.

The same issue affects the other architectures in this patch whose normal
syscall entry does not save callee-saved registers or register windows befo=
re
copy_thread():
- m68k needs a SAVE_SWITCH_STACK wrapper like __sys_clone3 so copy_thread()
  does not populate the child's switch_stack (d6-d7, a3-a6) from the C fram=
e.
- MIPS (o32, n32, n64) needs save_static_function() so s0-s8 are saved into
  struct pt_regs before copy_thread().
- PA-RISC needs a fork_like wrapper like sys_clone3_wrapper to save r3-r18
  and cr27 into task->thread.regs.
- SPARC (32-bit and 64-bit) needs an assembly wrapper like __sys_clone3 /
  sparc_clone3 to flush register windows and call synchronize_user_stack(),
  and copy_thread() in process_32.c and process_64.c needs to check for
  __NR_rootns_enter alongside __NR_clone3 so it does not apply SunOS fork()
  return conventions (which set the child's %o0 to current->pid instead of 0
  and clobber %o1).
- ARC, Nios II, and OpenRISC (via include/uapi/asm-generic/unistd.h and
  scripts/syscall.tbl) likewise require their callee-saved register /
  switch_stack wrappers before calling sys_rootns_enter().

[ ... ]

> diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kern=
el/syscalls/syscall.tbl
> index cfbb70039ff00..610ceedd1a14c 100644
> --- a/arch/powerpc/kernel/syscalls/syscall.tbl
> +++ b/arch/powerpc/kernel/syscalls/syscall.tbl
> @@ -563,3 +563,7 @@
>  470	common	listns				sys_listns
>  471	nospu	rseq_slice_yield		sys_rseq_slice_yield
>  472	common	fchroot				sys_fchroot
> +473	common	rootns_create			sys_rootns_create
> +474	common	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
> +475	common	rootns_kill			sys_rootns_kill
> +476	common	rootns_enter			sys_rootns_enter

[Severity: Medium]
Should the rootns syscalls, especially rootns_enter, be marked nospu instead
of common on PowerPC?

Entries marked common are included in spu_syscall_table[] and can be invoked
by a Cell SPU program via spu_process_callback() -> spu_sys_callback() while
the host PowerPC thread is inside spufs_run_spu().  Process creation and wa=
it
syscalls (fork, vfork, clone, clone3, waitid) are marked nospu so an SPU
context cannot clone the host PPE thread from inside sys_spu_run().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117050841.3289=
652-1-jarkko@kernel.org?part=3D10

