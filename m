Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EB76C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 12:14:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68BB36B0095; Fri, 25 Sep 2026 08:14:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63D096B0096; Fri, 25 Sep 2026 08:14:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 552256B0098; Fri, 25 Sep 2026 08:14:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B7706B0095
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:14:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B21F0405DD
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:14:00 +0000 (UTC)
X-FDA: 85252176240.17.2C7AFD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 077C980009
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:13:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i1mPHuje;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790338439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=53HWvP0dLSU2JJOmePowB/DLYu/nl90Sc+5CBtn/VIg=;
	b=ZOtS08ZEkoVmp5tPlvtkElA78nyzEMLGZstC342cwO+pWKxPWeu7pk/uEGe3f9lRTeRnYT
	xnlCP2e36e5p51X7xsZ2tgwSzOazR2FMQSCvNrgbQ3Z+Q5iPZRS/DDfvdZplcF957MSOpd
	E8H0bZoJCfon88YANIinCNAJ6YGge2w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i1mPHuje;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790338439;
	b=dyi8BHXm3FmLqiRBUkdhtOemnhxrSaJEOyaMQLPMqHsAR1r95RfUXC8j4m7vFkQNjssFpO
	8aUf4qTwC66HoSC/vGddLrS4sPNZDKLY5L+LXXLcyLQWPRiBRgvR0TjeDJ8SHBa/kcr2JO
	e7Uo1R2a2PEi0cn072BUpL9WTNZR+rY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 33242439B4;
	Fri, 25 Sep 2026 12:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFDC1F000FF;
	Fri, 25 Sep 2026 12:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790338438;
	bh=53HWvP0dLSU2JJOmePowB/DLYu/nl90Sc+5CBtn/VIg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i1mPHujeGzTKw/tr4OcFT2QE62XStebN2RAIIfSo95FRf2A3w0K2lRT9ih3PGQX2U
	 lwdMDgPLawvYvR4LWqshuvMELmLCgTgym1970Cb5UDXniDRE//+CZOcF5bB2U2hO0T
	 fQIq/+jfuFA3r3y3I+nFnKUuXdFYAKeIKjXGrHoYXubw9NBO7uZbPI6Xni5iPtg3tX
	 NvnPX8IeI8+d4QQjZgqe5NMuLmzVyNf0Bc0OkZgY7JQh8hb15IncNMmSpbOrJSAuOq
	 bst57/WvacsoUxS+094oZHVMhrcXynb2SkVhSWUL8kfrrGHoj0fxbL5WMz+Js+mswI
	 NkfbR+pLimN6Q==
Date: Fri, 25 Sep 2026 13:13:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, Mike Rapoport <rppt@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Pedro Falcato <pfalcato@suse.de>, 
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <arZHp8hjYFXE8Rkt@gremlin>
References: <arY1Wq6R9OY20ans@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arY1Wq6R9OY20ans@pcnci.linuxbox.cz>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 077C980009
X-Stat-Signature: wr9atwx6oa4fre4zu6gjfwuq7et4gnpo
X-HE-Tag: 1790338438-607521
X-HE-Meta: U2FsdGVkX197Ah9+Ki3Uqr4k7eWEqQd/A7Y8wCQAAr7gbSi7R47KS+zu9tB+isuI01cLuccAHUd0Pc+9UwuRqv0TQwiYym+nXyomdov73ZGGngmfVKpln1gx0+2ThHM7GGarKppJpglrsCvqXK9OkWlWFE8L1/x0jd77AsAMzAoX+rRaKwz9aqVI/hMtNOrmjM0RC09+t9Ioq1t+NCK/a9SPb3Eob2k985uM519GRrrbz9oTGUsujmOjOpONOpsYaNKOsgXWyM8c1bCIt6Cb7lGuTysXOw+c06/UGsmTVuQuGcLNp0LQKWp+irQW9gi5wT1V5wJc//zhQ28LaptlN93d7GD9ZseYemA7KXM0UjsMZqD4pedC4qz8zLjlvm5NBKXENwq3Cb6jkF01mtAllfQVwH9w7AQ4mITH+EEk2uJ4JtiXCty+2QeuLY92uxeON9f5EIf2vsxEvFfoky5BLJD93yRvSQKWZLU27+v155G2JJp1nu8N383UmRhT2ifWOS3dLWt3RIGTG5/KLcNtNuiciK96TOELu9N6+AeOStzObtV5N20QlDR0mHHPCerneSnGgD757xIXmEW5AZk5hDYWshIg5ULR1L8jVcKRD9FQmalMP8ZB4hoKfFdwfleCI12XTwgH5vD+RR5IsG9Aw6L/S5GNe4bzjtkNGF7Uivem0VpNAhhGCCjYb7vHR6Lj+tJlrGFFKK9/CaC1xz2Xd68LCeoAsDzCI1aNdqNgLV7JH9dX4l/Z3aomir5ze/rzhKliwaAbLTsxoUDvCQAUJ9baJ/hPiS8/F5FpFG0For/UHB/44VNPW2l7UFA+ln0XCK+mf0vThCm71v20Ih62voStCHpkYRm1A1Hc8Mlk1t9a3rKikWOc32I5T7pWrZ4BmgJFtV5YL/4m9l8JW97hrk5p6T3tk132xkJ9UoC97PWBRsSeUWFVLhzq42j/lekH4T0Ykplh0RFV0rbEY4T
 ry0wS5wp
 46qCz23vwZracu3zlKGLeJGX6td/m2wje1aqPYUeb4sKs9gbO0/Ix62W8g9zvw6JbjcanS/aYgd1FUKs1/hMRysyQo8F2OzJz4BXgHYUE8neqD/AgJqMexNrwJOAq7Xyuqne27E8p7/XxSlKbZ3gBbikf5dCvPjWFlUbJ/6p3gSiDqpAKcz4b4Y71+oKnnCXY43XVmA9c7ms+QT7Sq4oSgObufi2fwBZ8ZFCoVPSE1/RxizOJFAzVABrPbuQnSPovDej1m73CdzERkUGDieX+1WqXuxQksJoOx/xVtx5XaDF9xbI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc various

Tl;DR before I dig in, I had an AI dig into the report (as they're
essentially superhuman at this kind of thing so always worth doing), and it
seems the recently fixed CPA bugs are likely to be the underlying cause
here.

EDIT: OK so I spent 2+ hrs analysing this :>))) but hopefully it's useful,
I wanted to make sure what the LLM came up with was vaguely sensible.

It's speculative, but I really think the below is the best explanation for
what you're observing.

And TL;DR is that 6.18.53 should fix it.

On Fri, Sep 25, 2026 at 10:48:26AM +0200, Nikola Ciprich wrote:
> Hi,
>
> I've been hunting a weird memory corruption bug for the last few weeks,
> without success so far, so I'd like to report it and kindly ask for help.

Thanks for the detailed report!

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

It seems that commit 41d88484c71c ("x86/mm/pat: restore large ROX pages after
fragmentation") is the underlying cause (landed in 6.15).

It impacts CPA or 'Change Page Attributes' which is the means by which direct
mapping page table entries are updated to reflect underlying attribute changes
for ranges, often (and the motivation behind this change) read-only executable
ranges for e.g. JITters etc.

When it does this it sees if the range being changed can be 'collapsed' into a
huge page, i.e. mapped at PMD level for instance rather than PTE level to avoid
fragmentation of the direct map.

In particular the change introduces cpa_collapse_large_pages(), which frees
kernel page tables when it does this.

And this is problematic, because it did that without properly synchronising
against concurrent readers.

And I think in particular the issue here is the one fixed by Pedro in commit
1587d3394e25 ("x86/alternatives: Exclude text poking against
change_page_attr()").

>
> Since then I've spent a lot of time trying to reproduce it on a lab
> cluster, and we were able to trigger some corruption after days of
> migrating VMs back and forth. At first I suspected the Intel ice driver,

Yeah these race bugs can be VERY painful, sorry about that!

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

So there are two sides to the race: set_memory_rox() - triggered on module
load, ftrace trampoline creation and every new BPF 2M program pack.

The other side is execmem_force_rw() -> set_memory_[nx,rw]() (concurrent
module load or ftrace trampoline allocation) __text_poke() ->
vmalloc_to_page() for patching module text, kprobe slots, trampolines or
BPF.

Both are happening a lot at KVM host bringup (module autoload, per-VM
seccomp filters, perf, BPF probes, etc.

So this aligns with the theory.

>
> We first hit these problems with 6.18.31; the last crash I saw was
> with 6.18.44.

Yeah, the fact you didn't see an issue with 5.15 matches commit
41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
being the cause.

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

Actually I think doing this doesn't actually save you at all, since the
collapse happens even without THP enabled, and NUMA balancing shouldn't
impact any of this.

>
> I'm aware this is still a very vague report with a lot of guessing,
> but my question is: has anybody hit similar problems with 6.18 or
> newer kernels?

Yeah, the description of a fix for this mentions something that seems
exactly like this bug:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1aac65f3e651334259ecb2a5f5ddb81c01f02599

Though note that that patch doesn't actually solve the problem, you need
fixes from 6.18.53 to resolve the bug:

Commit a1c7570cedd0 ("x86/mm/pat: Acquire init_mm write lock on collapse to avoid UAF")
Commit d5d8b8662e6e ("x86/mm/pat: Acquire init_mm read lock on attribute changes to avoid UAF")

These are prerequisites ^^^ for the actual fix for this vvv

Commit 1587d3394e25 ("x86/alternatives: Exclude text poking against change_page_attr()")

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

Ugh, unhelpful, but makes sense as it changes race windows.

>
> I'll start another round of migration tests in the lab, now with
> 6.18.54-rc1, but I still thought it would be good to report this and
> ask here.
>

Ah yeah you're already going to be testing the fixed series then :)

Obviously if the issue re-triggers there, back to the drawing board. But I
don't think it will.

> last but not least, here's kdump from last crash (this was not related
> to any VM migration, but is very similar to another few crashes
> we got):
>
> [1924553.414736] Oops: general protection fault, probably for non-canonical address 0xfffffff0c930038: 0000 [#1] SMP NOPTI
> [1924553.434800] CPU: 23 UID: 189 PID: 7538 Comm: pacemaker-contr Kdump: loaded Tainted: G            E       6.18.44lb9.01 #1 PREEMPT(voluntary)
> [1924553.456934] Tainted: [E]=UNSIGNED_MODULE
> [1924553.465551] Hardware name: ASUSTeK COMPUTER INC. RS720A-E12-RS12/K14PP-D24 Series, BIOS 2305 11/21/2025
> [1924553.484152] RIP: 0010:__d_lookup+0x4a/0xc0

So __d_lookup() is where the invalid address oops happened.

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

So the LLM went to town on this and it's quite interesting.

The code (6.18.44) disassembles to:

struct dentry *__d_lookup(const struct dentry *parent, const struct qstr *name)
{
	...

	hlist_bl_for_each_entry_rcu(dentry, node, b, d_hash) {

Which is:

#define hlist_bl_for_each_entry_rcu(tpos, pos, head, member)		\
	for (pos = hlist_bl_first_rcu(head);				\
		pos &&							\
		({ tpos = hlist_bl_entry(pos, typeof(*tpos), member); 1; }); \
		pos = rcu_dereference_raw(pos->next))

And:

static inline struct hlist_bl_node *hlist_bl_first_rcu(struct hlist_bl_head *h)
{
	return (struct hlist_bl_node *)
		((unsigned long)rcu_dereference_check(h->first, hlist_bl_is_locked(h)) & ~LIST_BL_LOCKMASK);
}

And:

static inline bool hlist_bl_is_locked(struct hlist_bl_head *b)
{
	return bit_spin_is_locked(0, (unsigned long *)b);
}

  mov    (%rbx),%rax          ; rax = h->first = 0x0fffffff0c930020

  mov    %rax,%rbx
  and    $-2,%rbx             ; strip hlist_bl lock bit (no-op, bit 0 clear)
  cmp    $1,%rax              ; hlist_bl_is_locked()
  ja     body                 ; non-empty, enter loop
  ...

		if (dentry->d_name.hash != hash)
			continue;
body:
  cmp    %ebp,0x18(%rbx)      ; <-- FAULT: deref of dentry->d_name.hash

So dentry is corrupted.

The code and registers are consistent with this being the first iteration
of the loop, which you'd expect with corrupted dentry.

Looking further back in the code:

struct dentry *__d_lookup(const struct dentry *parent, const struct qstr *name)
{
	...
	struct hlist_bl_head *b = d_hash(hash);

And:

static inline struct hlist_bl_head *d_hash(unsigned long hashlen)
{
	return runtime_const_ptr(dentry_hashtable) +
		runtime_const_shift_right_32(hashlen, d_hash_shift);
}

Only the trailing ff is in the code output from the splat but the movabs is
there -> RDX: so:

  movabs	$0xff2e6dbe0d9b6000,%rdx	; runtime_const_ptr(dentry_hashtable)
  mov		%rax, %rbp
  shr		$0x7, %eax			; runtime_const_shift_right_32(hashlen, d_hash_shift);
  lea		(%rdx, %rax, 8), %rbx		; bucket = &dentry_hashtable[hash >> 7]

(The 8 is multiplying the size of the 8 byte pointers)

Note that rbp retains RAX's value = 0xb654440 (not clobbered elsewehre), so
the hlist_bl_head bucket pointer is

	0xff2e6dbe0d9b6000 + (0xb654440 >> 7) * 8

So:

b = 0xff2e6dbe0e51b440

This matters, because in hlist_bl_first_rcu() this pointer is treated as a
valid struct hlist_bl_head pointer:

struct hlist_bl_head {
	struct hlist_bl_node *first;
};

And the data at 0xff2e6dbe0e51b440 contains 0x0fffffff0c930020 (rbx), which
is assumed to be a valid struct hlist_bl_node * embedded in a dentry.

IOW, RDX contains the dentry_hashtable pointer:

static struct hlist_bl_head *dentry_hashtable __ro_after_init __used;

That is allocated in dcache_init_early() and never freed:

static void __init dcache_init_early(void)
{
	...
	dentry_hashtable =
		alloc_large_system_hash("Dentry cache",
					sizeof(struct hlist_bl_head),
					dhash_entries,
					13,
					HASH_EARLY | HASH_ZERO,
					&d_hash_shift,
					NULL,
					2,
					0);
	...
}

So that allocate has to be legit, somehow the data there got corrupted.

This is allocated early by memblock.

d_hash_shift = 7 = 32 - lg(entries), so entries = 25, and 2^25 entries of 8
bytes each = a 256 MiB table.

So it's legit data that got corrupted.

RDI contains the parent dentry at 0xff2e6d1e4e630d80 (the disassembly at
__d_lookup() confirms).

KASLR makes things tricky but this is most definitely a slab allocation in
the direct map and the stack (VMAP_STACK) is at 0xff7532a13699fda0 (rsp)
~70 TiB higher which sits at least 10 TiB padded above the direct map so
it's safe to say that this is in the direct map.

And the corrupted value (rbx) 0x0fffffff0c930020 is interesting - it's an
exactly a x86-64 swap softleaf value:

__swp_type()   = val >> (64 - SWP_TYPE_BITS=5) = val >> 59 = 1
__swp_offset() = (~(x).val << SWP_TYPE_BITS >> SWP_OFFSET_SHIFT) = (~val << 6 >> 14)
               = 0x79b67f

I.e. it's a swap softleaf entry 0x79b67f 4 KiB pages into the swap = ~30.4 GiB.

It's also the _second_ swap in the system (Nikola - if you have a 2nd swap
on the reporting system of >=~30 GiB that kinda confirms it).

Also, interstingly, bit 5 is set, which is one of the bits allowed to be
set (possibly by hardware) in the swap entry.

__swp_entry() clears bits 0-8 and only bits 1-3 are software bits in a
non-present PTE.

This is _PAGE_ACCESSED (1 << _PAGE_BIT_ACCESSED = 5) = 0x20. So it makes
sense that hardware might have set it.

In effect - every single bit is exactly how it should be for a valid swap
entry (since commit 00839ee3b299 ("x86/mm: Move swap offset/type up in PTE
to work around erratum"))..

It seems more than a coincidence :)

This speaks to some kind of memory corruption that has resulted in a store
to an arbitrary physical address that happens to be the dentry.

Now looking to the proposed CPA cause (ultimately the thing solved by


So the speculated race here is:

pfn_exec: pfn of the module text page CPU A is changing attributes on
pfn_dh:   pfn of the dentry hash table page the swap PTE ends up in

CPU A: set_memory_nx() (text_poke)     CPU B: set_memory_rox() (module load)
------------------------------------   -----------------------------------------
__change_page_attr()
  kpte = lookup (lockless)
  <preempted>
                                       cpa_collapse_large_pages()
                                         set_pmd(leaf)
                                         __free_pages(old PTE table)

                                       some process: pte_alloc() gets
                                       that page as a user page table

  UAF!!! Writing into arbitrary memory
  set_pte_atomic(kpte,
      pfn_pte(pfn_exec, prot))         <- lands in that page table:
                                          entry -> pfn_exec (module text)

                                       process faults on it, GUP follows
                                       it, later zap frees the data page at
				       pfn_exec while it is still live module
				       text!!!

                                       That data page is reallocated as a PMD
                                       table.

					text_poke() keeps writing
                                       code bytes into it -> entries
                                       with arbitrary pfns, one of them
                                       pfn_dh

                                       reclaim: try_to_unmap_one()
                                         pte_offset_map() -> __va(pfn_dh)
                                         set_pte_at(swap PTE)   <- dentry
                                                                   hash table

(The reason it needs to be interpreted as a PMD page table is otherwise
reclaim wouldn't be trying to write a swap PTE entry into it).

And this is exactly what commit 1587d3394e25 ("x86/alternatives: Exclude
text poking against change_page_attr()") protects against.

Yes it's out on a limb (and I spent FAR TOO LONG going through this
analysis) but there's really no other sensible explanation as to why dentry
data got corrupted like that to that exact shape.

Which goes to show how nasty this kind of data corruption issue can be.

>
> I'll be very very gratefull for any hints here..

As above :)

>
> with best regards
>
> nikola ciprich
>
> PS: I tried to CC maintainers of suspected subsystems, but those are just my guesses,
> so I hope I won't offend anyone.
>

Don't worry about that, I think we're all happy to get legit bug
reports. We just might be too busy to reply right away :)

The LLM added on some hints for confirmation of this:

Schlopp>>

Log greps, across all affected hosts and all boots, not just the ones
that crashed:

    grep -i 'Bad page map' /var/log/messages*
    grep -i 'bad pmd' /var/log/messages*
    grep -i 'bad pud' /var/log/messages*
    grep -i 'Bad page state' /var/log/messages*
    grep -i 'CPA: called for zero pte' /var/log/messages*

Any of these, particularly "bad pmd", is direct evidence that a freed
kernel PTE table was reused as a user page table. "CPA: called for zero
pte" would be the CPA walker itself tripping over a collapsed mapping.

Questions:

1. swapon --show on the host, and inside the guests. Is there a swap
   device with index 1 and a size of at least roughly 30.5GiB? That
   tells us whether the corrupt word is a host swap PTE or a guest one,
   which distinguishes case A from case B above.

2. From the vmcore, dump the 4K page containing 0xff2e6dbe0e51b440. If
   the neighbouring words are also PTE-shaped, the page was being used
   as a page table and the diagnosis above is confirmed. If only the
   one word is corrupt, it was a single stray store.

3. What are CONFIG_DEBUG_VM, init_on_alloc, init_on_free and
   page_poison set to in the production build versus the KASAN build?
   free_page_is_bad() is gated on is_check_pages_enabled(), which needs
   CONFIG_DEBUG_VM, so the production kernel would not report the bad
   free even if it happened.

4. Are any of the crashing guests Windows, and is hv-tlbflush set on
   them? That decides whether 26505e1b5b54 matters for you.

5. Has any corruption occurred since THP was disabled? If yes, that
   supports the CPA race over your THP theory.

6. When you run the 6.18.54-rc1 test, please note that 6.18.52 is only
   a partial fix, so if you have any results from a 6.18.52 kernel they
   should not be treated as a clean run.

<< Schlopp

But really a run against 6.18.53 being OK under heavy testing for several
days should confirm it also.

If it turns out it's not this then back to the drawing board I guess! Let
us know.

--
Cheers, Lorenzo

