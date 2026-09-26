Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A5ADC98328
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 09:32:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53DF26B00A5; Sat, 26 Sep 2026 05:32:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EEE76B00A6; Sat, 26 Sep 2026 05:32:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4045A6B00A7; Sat, 26 Sep 2026 05:32:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 027096B00A5
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:32:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE16F40817
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:32:26 +0000 (UTC)
X-FDA: 85255397892.08.09658DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id DDEDB40002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:32:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T2RmtF9t;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790415145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rVhWYeEaf2PJRecjDvNT57L8JnmLDw5AMw9Bjx00I4M=;
	b=tRgdDc4Tut1YWkOGHf7mvdsRZxYkPgj7HmN29Z2Kq7sTHgmwdTpAVAxktD0jSEhQfHrJuz
	QPo7elKWqgrgpTGw/q9rQhpYIpMh8c4mZi7dC5i/AihInJW8hVehGj3Dj71A+oFmf/wTou
	Fr9nDmG/+jY4E56vvAEIuVr5TDjyJZ4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T2RmtF9t;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790415145;
	b=5JSLidKITrU+akjBORGX0ukDY90qAvxhab9nzHN9v27urED+qpXWRimDteEwmWttVfxTbz
	CyHE+LTLJbz2rhFds3gxTmjEhIZAaxG9YO2feHW6jnyZ89CR7dSi0HZXC3fhjyUCkUjlxa
	xZoMDSIHhHrm+68v/cdyKIEKaKWhygA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 171BC429C4;
	Sat, 26 Sep 2026 09:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E461F00893;
	Sat, 26 Sep 2026 09:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790415144;
	bh=rVhWYeEaf2PJRecjDvNT57L8JnmLDw5AMw9Bjx00I4M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T2RmtF9tBZGhzTHOU5YOrngHFOrUoWO8qI2U583UDcQ6SsGOMZ6HnF35eBElYB/20
	 IY7KRGQwWOwNjq0NPAWGzkSP/vP2H843trGEhp0L28ytYSlmfMyXGeMVbWhkFv0uow
	 w2baDdswVQptANRewu5Co27G3X8pWpTx9kWp+LaaUkNdS9TsCpio2eKCpAwSD55fxM
	 xRLZxi9nW40EFR/6ImMom3K4TPkVtB1URm/udSDuZwsshzunrKKErEjKlU6Ic/frK8
	 3HyyLatMQocMjWrAUEk9vlizKmDU+IE2t/yXSEbCBQnuVeGvTjNkuU5BQx+0FsmcZl
	 3+ZGnbgAcSGTg==
Date: Sat, 26 Sep 2026 10:32:18 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, Mike Rapoport <rppt@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Pedro Falcato <pfalcato@suse.de>, 
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <areOeRwZOez0eHm7@gremlin>
References: <arY1Wq6R9OY20ans@pcnci.linuxbox.cz>
 <arZHp8hjYFXE8Rkt@gremlin>
 <arde/t0zQNEkWqi5@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="a2ha3se4httuixcd"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <arde/t0zQNEkWqi5@pcnci.linuxbox.cz>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DDEDB40002
X-Stat-Signature: 65d43x37spkmf5oqcyfs4chrww87pkeo
X-HE-Tag: 1790415144-925479
X-HE-Meta: U2FsdGVkX1/+YwiO1eZkZmDC+A16yAPehvaGl2qcDqBe0myIow5oHhyqWw6AZCjPa/pE544uzrs8IRT7ixHTG7mjr2zEGt866YApJLRnTQgiEddUhK/fdoqKk8flza8wCtv6zzuNzerwYAEIU9DqXKidNEWHk8M66h6DSdn6wJjuRaKnY6drutCpQ/enL43A12SxmCgZV58h96fjXUFCHXxRWDANhK2rTDeOamHKjHtOU7CxN6B0KczCyDTIV6QhgL66HLvnWHJUKxkJ0Zots1VVtcmL7gIRsF+fZh4DC62IV4EzLB2KpXjiWtYrFfQwGnNC5Qa1a1P56KwwzDBMUSPI3qGUF84zxIRIpNc809E/M4NiFFnvRH7jOwxAmqvxsCHqTVwRwKWDYy0NR0rpSmyIJn88S4csUcyrnxNBioLHNheBSKQeXv+FRON3EKZdxIBfIX9+nOxyQIJN9Hb+lfd/7PIYbwWMn7uVqjl/TgORZKPTOef7s1+ay4MQlYKTrpv9atA7HwF0qvbBYlf2CZVgoPM4eg/u2tEajdY6l9fl802wbYVh26+yaIjw9BBjdiCeo/a/z29aMvJ5r3K5zSqYlhroEHHzyn6+/qhkTvE8c3dy4eakUPgh7iwM5xw23Y8+c6v/nnnWMPZtr/7pKuKCr93VabMGk9Ry4wpone8vLF1Dum83mWF/VzANSMLehQJ+cEMtXRAJN3b9lDVCm3krAt6v07i0Srs7U8IdMJa9B7G4pSGeJRZv/vwjYLp5Az31C5eTcWKqZ2l3vCfO5Lp98Hw6kiwc7P2yQs+7taCAi7BWB6DOQPJ55sFdIqcOee/dJPPrp8tSNVO03g64/9Ra3ReomxIN1ctzbGe6EHPBuT+WQmHFM87aNQ4MsQ+M/9WE7iVkGeC0A4Ntj5/QxAh3Yvs2/QpDpHWNZE8F1qzrGPGtGiUSFuWPNUGIn/6F8wj1lZizRLlPMjaSd9G
 DvLblrNC
 meIBYiI6W5yKV4odYBOXeLIlA+muasN60Mwr0c8yClBzsNyRL6kOsgCSAkv2PiWVsj3iT8T3U/tvy7lQMaNxR3+v4GnVLcqJJvy5sE9v5cA27iQbjGkHCw65yM3EeAB9OLKH2d53CfokIIT5IssBWMV8fCUB0wwXi90vX3bLCK7BYhhVgQG1fCDL2Sq8KzCQOU23R9j3mGzeR5P5zZ1M34pK9bS2KxgDj7vBZJd2Cdk3bWZqIR2jrvZDsp+m1s2Ts1ju2b/lk+ynC680Drps1X4DvERGjW7C/dwnJ32H1wu1+/OEHaUGuY6D+Y48GODKNhutTglJyS4rJtvkiIQMi+toTAA9KQt939gyzt09TeOC2LUJB64jU1pXbY4yHdbbEEd3BzVgsgGSelN2jl4hnzfXOCizZLB/R/Fvs1Z8v2+NysKl+g5aHNAM4dG/5l9t+ZSWE/e6ScSRLEPpX8zzQEw86Bj28u/WidMvCYoc0fFlbcrjUbUnHhmSOuvIn9AkEIK0y6wj0I3NhhPS87AASW80z2xuXZLs5/8zPCdBlaZ5gzynEZmc6hGKQNBdShTe5eWLKCbC2MFdc7OXeAeWfaiuoZNIheWF9HRWgO3MxddzFyTw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--a2ha3se4httuixcd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sat, Sep 26, 2026 at 07:58:22AM +0200, Nikola Ciprich wrote:
> Hello Lorenzo (and others),
>
> thank you for your time looking into this..

No worries!


> >
> > So there are two sides to the race: set_memory_rox() - triggered on module
> > load, ftrace trampoline creation and every new BPF 2M program pack.
> >
> > The other side is execmem_force_rw() -> set_memory_[nx,rw]() (concurrent
> > module load or ftrace trampoline allocation) __text_poke() ->
> > vmalloc_to_page() for patching module text, kprobe slots, trampolines or
> > BPF.
> >
> > Both are happening a lot at KVM host bringup (module autoload, per-VM
> > seccomp filters, perf, BPF probes, etc.
>
> one note here, at least last mentioned crash (with 6.18.44) happened with
> host running only windows guest, in general we're seeing those problems
> mosly with windows VM hosting machines.. so maybe they're triggerng the
> problem with some other, but similar mechanism?

Interesting! But indeed all this is host-side.

Though it came up with a possible finding around commit 26505e1b5b54 ("KVM:
SVM: make svm_flush_tlb_gva do a full asid flush if NPT enabled") which has
not been backported yet.

That's is a. AMD-specific guest memory corruption and b. only if
hv-tlbflush=on.

This is independent of the CPA stuff.

So if the CPA stuff turns out to be a red herring that's one worth looking
at? Are you able to run a modified kernel with this applied on top?

> > KASLR makes things tricky but this is most definitely a slab allocation in
> > the direct map and the stack (VMAP_STACK) is at 0xff7532a13699fda0 (rsp)
> > ~70 TiB higher which sits at least 10 TiB padded above the direct map so
> > it's safe to say that this is in the direct map.
> >
> > And the corrupted value (rbx) 0x0fffffff0c930020 is interesting - it's an
> > exactly a x86-64 swap softleaf value:
> >
> > __swp_type()   = val >> (64 - SWP_TYPE_BITS=5) = val >> 59 = 1
> > __swp_offset() = (~(x).val << SWP_TYPE_BITS >> SWP_OFFSET_SHIFT) = (~val << 6 >> 14)
> >                = 0x79b67f
> >
> > I.e. it's a swap softleaf entry 0x79b67f 4 KiB pages into the swap = ~30.4 GiB.
> >
> > It's also the _second_ swap in the system (Nikola - if you have a 2nd swap
> > on the reporting system of >=~30 GiB that kinda confirms it).
>
> I suspect this may be a bit of a red herring...
>
> actually there is NO swap on that machine, also there were no linux guests.. so
> that might just be a coincidence? not sure if it changes anything..
>

Hmm that's really really odd. But if you had swap before or VMs before this
is a long-lasting corruption that could have been sat there for days before
you triggered it.

> > The LLM added on some hints for confirmation of this:
> >
> > Schlopp>>
> >
> > Log greps, across all affected hosts and all boots, not just the ones
> > that crashed:
> >
> >     grep -i 'Bad page map' /var/log/messages*
> >     grep -i 'bad pmd' /var/log/messages*
> >     grep -i 'bad pud' /var/log/messages*
> >     grep -i 'Bad page state' /var/log/messages*
> >     grep -i 'CPA: called for zero pte' /var/log/messages*
>
> not a single occurance (this machine uses journal, but I checked those
> and no such messages.. in general i tend to check dmesg and system logs
> a lot, so I'd have already reported such messages..

Yeah I don't know why it assumed you used antiquated logging..! :)

OK that's interesting.

>
> >
> > Any of these, particularly "bad pmd", is direct evidence that a freed
> > kernel PTE table was reused as a user page table. "CPA: called for zero
> > pte" would be the CPA walker itself tripping over a collapsed mapping.
> >
> > Questions:
> >
> > 1. swapon --show on the host, and inside the guests. Is there a swap
> >    device with index 1 and a size of at least roughly 30.5GiB? That
> >    tells us whether the corrupt word is a host swap PTE or a guest one,
> >    which distinguishes case A from case B above.
> >
> > 2. From the vmcore, dump the 4K page containing 0xff2e6dbe0e51b440. If
> >    the neighbouring words are also PTE-shaped, the page was being used
> >    as a page table and the diagnosis above is confirmed. If only the
> >    one word is corrupt, it was a single stray store.

> unfortunately I don't have full vmcore from that crash, as it didn't fit
> to /var/crash, backtrace I posted is from vmcore-dmesg.txt so can't confirm
> that..

Ah that's a pity!

>
>
> >
> > 3. What are CONFIG_DEBUG_VM, init_on_alloc, init_on_free and
> >    page_poison set to in the production build versus the KASAN build?
> >    free_page_is_bad() is gated on is_check_pages_enabled(), which needs
> >    CONFIG_DEBUG_VM, so the production kernel would not report the bad
> >    free even if it happened.
>
> I don't have CONFIG_DEBUG_VM enabled in production..

Well that explains the lack of bad reports above. I don't know why it'd
assume you'd run kernels with that (we do not recommend that for production
:)

>
> >
> > 4. Are any of the crashing guests Windows, and is hv-tlbflush set on
> >    them? That decides whether 26505e1b5b54 matters for you.
> yes, windows, but hv-tlbflush is enabled on a sigle VM and it runs od
> different node all the time.

Ah but that could be enough to cause memory corruption. The reports seem to
be about guest memory corruption though.

To be clear - are you observing it in the guest or host? I gathered host
from the splat.

>
>
> >
> > 5. Has any corruption occurred since THP was disabled? If yes, that
> >    supports the CPA race over your THP theory.
> not yet, but it's not happening that often, so unsure here

Yeah it seems to be a hard one to hit. If you tried a kernel with KASAN
enabled it might be flagged earlier? But that could also kill the race
window and would slow the system down a lot.

>
> >
> > 6. When you run the 6.18.54-rc1 test, please note that 6.18.52 is only
> >    a partial fix, so if you have any results from a 6.18.52 kernel they
> >    should not be treated as a clean run.
> sure, I'll start today with 6.18.54, won't consider older tests.

Ack, that's the best thing to do at the moment to be honest.

If you were consistently getting corruption after X days previously, 2*X
days let's say of none can give confidence it's fixed there.

>
>
> >
> > << Schlopp
> >
> > But really a run against 6.18.53 being OK under heavy testing for several
> > days should confirm it also.
> >
> > If it turns out it's not this then back to the drawing board I guess! Let
> > us know.
> I surely will!
>
> cheers, nik

Thanks! Given the nature of the bug and the fact the LLM went a little out
on a limb.

Some more stuff from the report, which I also enclose in full here FYI.

schlopp>>

26505e1b5b54 ("KVM: SVM: make svm_flush_tlb_gva do a full asid flush if
NPT enabled") is mainline only and has not been backported to 6.18.y.
It is AMD-specific guest memory corruption via the Hyper-V PV TLB flush
path, so it only affects Windows guests running with hv-tlbflush=on. If
any of your crashing guests are Windows, this is worth backporting
separately. It is independent of the CPA race.

55ddbc2ca6d5 (upstream f7491d7c81db, "x86/mm: Fix user-space data loss
with MADV_FREE and THP") is a real bug in 6.18.44. pmd_modify() drops
_PAGE_DIRTY, which has been the case since v6.10, and it causes data
loss for MADV_FREE THP and writable file THP. It is fixed in 6.18.53.
It is data loss rather than a stray write, so it does not explain the
oops, but it is another reason to move off 6.18.44. Note that this one
needs THP, which you have now disabled.

d053eb7e09e1 (upstream 1e75a8255f11, "iommu/amd: Wait for completion
instead of returning early in iommu_completion_wait()") is already in
6.18.42 and therefore in the kernel that crashed. It is ruled out for
this oops, but it may be relevant to the earlier incidents you had on
6.18.31 through 6.18.41.

<<schlopp

Let us know how the tests get on! If you trigger a bug on 54 let us know
ASAP so we can investigate alternative theories.

Thanks!

>
>
>
>
> >
> > --
> > Cheers, Lorenzo
> >
>
> --
> Ing. Nikola CIPRICH
> technický ředitel
>
> +420 591 166 214
> +420 777 093 799
> nikola.ciprich@linuxbox.cz
>
> www.linuxbox.cz

--
Cheers, Lorenzo

--a2ha3se4httuixcd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="debug-report.txt"

Summary
=======

The corruption you are seeing is consistent with a known use-after-free
in the x86 change_page_attr (CPA) code that is present in 6.18.44 and
was only fixed in 6.18.52 and 6.18.53.

cpa_collapse_large_pages() rebuilds a leaf PMD out of its 4K PTEs and
then frees the old PTE table, with no lock held against the lockless
page table walk that __change_page_attr() performs before it stores
through the PTE pointer it cached. The stale 8-byte store of a kernel
PTE value lands in whatever the buddy allocator has since handed that
page out for.

On a KVM host the two sides of this race are both hot. set_memory_rox()
is the only caller that passes CPA_COLLAPSE, and it runs on every module
load (execmem_restore_rox()), every ftrace trampoline creation
(arch/x86/kernel/ftrace.c:423) and every new 2M BPF program pack. The
other side is any lockless walk of the same execmem tables:
set_memory_nx()/set_memory_rw() from execmem_force_rw() on module load
and trampoline allocation, and vmalloc_to_page() inside __text_poke()
for every patch of module text, kprobe slot, trampoline or BPF pack.
Module text, kprobe slots and ftrace trampolines share the same 2M ROX
cache pages, so the collapser and the victim land in the same PMD by
construction. A libvirt host does all of this constantly: module
autoload (tun, vhost_net, br_netfilter, ebtable_*, xt_*), per-VM seccomp
filters, systemd cgroup BPF, perf and BPF probes, ftrace and static call
patching on every module load.

This matches your good/bad window exactly. The collapse feature was
added in v6.15 and is not in 5.15.

It also matches the KASAN result. free_page_is_bad() is gated on
is_check_pages_enabled(), which is off unless CONFIG_DEBUG_VM is set,
and KASAN changes the allocation pattern enough that the freed page
tends not to be reused in the race window. The upstream reporter only
reproduced it by injecting a delay at the CPA page table lookup.

Recommendation: run 6.18.53 or later. 6.18.54-rc1, which you say you
are about to test, has the complete series. 6.18.52 has only the
cpa_lock patch, which does not close the window. Mainline (v7.3-rc5)
has nothing further pending for arch/x86/mm/pat/set_memory.c.


Kernel version
==============

6.18.44lb9.01 (AlmaLinux 9 build of stable 6.18.44, stable commit
1efe5d048a39). First seen on 6.18.31, last crash on 6.18.44. 5.15.x
was fine.


Machine
=======

ASUSTeK RS720A-E12-RS12 / K14PP-D24, AMD EPYC, BIOS 2305 11/21/2025.
KVM host, AlmaLinux 9, Intel ice and Mellanox NICs. Taint "G   E",
unsigned module only.


Stack trace
===========

  Oops: general protection fault, probably for non-canonical address
  0xfffffff0c930038: 0000 [#1] SMP NOPTI
  CPU: 23 UID: 189 PID: 7538 Comm: pacemaker-contr
  RIP: 0010:__d_lookup+0x4a/0xc0
  RAX: 0fffffff0c930020 RBX: 0fffffff0c930020 RCX: 0000000000000000
  RDX: ff2e6dbe0d9b6000 RSI: ff7532a13699fe60 RDI: ff2e6d1e4e630d80
  RBP: 000000000b654440
  Call Trace:
   <TASK>
   d_lookup+0x27/0x50
   lookup_dcache+0x1f/0x80
   lookup_one_qstr_excl+0x1e/0xe0
   filename_create+0xc4/0x160
   do_mkdirat+0x5a/0x190
   __x64_sys_mkdir+0x42/0x60
   do_syscall_64+0x64/0xbf0
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   </TASK>

Other messages you reported:

  Inconsistency detected by ld.so: ../sysdeps/x86_64/dl-machine.h: 548:
  elf_machine_rela_relative: Assertion `ELFW(R_TYPE) (reloc->r_info) ==
  R_X86_64_RELATIVE' failed!


What the oops registers say
===========================

The Code bytes decode to the hash chain walk in fs/dcache.c:__d_lookup():

    mov  (%rbx),%rax        ; load bucket->first
    mov  %rax,%rbx
    and  $-2,%rbx           ; strip the hlist_bl lock bit
    cmp  $1,%rax
    ja   body
  loop:
    mov  (%rbx),%rbx        ; node->next
    test %rbx,%rbx
    je   out
  body:
    cmp  %ebp,0x18(%rbx)    ; <-- faulting insn, d_name.hash_len
    jne  loop

RAX equals RBX and RAX is only ever written by the initial bucket load,
so this is the first loop iteration. The corrupt word is the
hlist_bl_head.first field of the dentry_hashtable bucket itself, not a
dentry's d_hash.next.

RDX 0xff2e6dbe0d9b6000 is the dentry_hashtable base, and the runtime
constant d_hash_shift is patched to 7, so:

    bucket = 0xff2e6dbe0d9b6000 + (0x0b654440 >> 7) * 8
           = 0xff2e6dbe0e51b440

That table is a 256MB alloc_large_system_hash() allocation from
memblock. It is allocated at boot, is PG_reserved and is never freed.
So this is a stray write to a fixed physical page, not a
use-after-free of a recycled object.

The corrupt value 0x0fffffff0c930020 is an exact x86-64 non-present
swap PTE: __swp_type() is 1 and __swp_offset() is 0x79b67f, about
30.4GiB into swap device 1. The only low bit set is bit 5,
_PAGE_ACCESSED.

Every bit the swap layout constrains is as it should be: P, PSE and
the G/PROT_NONE alias are clear, the software bits 1-3 are clear, the
type is an ordinary swap type and the inverted offset gives the long
run of ones in bits 32-58. The one thing the layout does not account
for is bit 5. __swp_entry() leaves bits 0-8 clear and no helper sets
bit 5 on a non-present PTE; arch/x86/include/asm/pgtable_64.h treats
bits 5 and 6 as don't-care only because of the Intel Knights Landing
erratum (00839ee3b299, _PAGE_KNL_ERRATUM_MASK), which does not apply to
EPYC. So either something other than a Linux swap PTE happens to fit
this layout, or the word was a swap PTE that acquired a stray bit. I
cannot tell which from one word, which is why the vmcore page dump
requested below matters: 511 neighbouring PTE-shaped words would settle
it.


Suspect commit
==============

    commit 41d88484c71cd4f659348da41b7b5b3dbd3be1f6
    Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

    x86/mm/pat: restore large ROX pages after fragmentation

    Link: https://lore.kernel.org/r/20250126074733.1384926-4-rppt@kernel.org

This added runtime collapse of split kernel large pages, driven from
cpa_flush(), including freeing the PTE table that the collapsed PMD
replaces. It is the Fixes: target of every fix listed below. It is in
v6.15 and later, and is not in 5.15.

> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c

> @@ -394,6 +408,40 @@ static void __cpa_flush_tlb(void *data)
> +static void cpa_collapse_large_pages(struct cpa_data *cpa)
> +{
> +	unsigned long start, addr, end;
> +	struct ptdesc *ptdesc, *tmp;
> +	LIST_HEAD(pgtables);
> +	int collapsed = 0;
> +	int i;

[ ... range iteration ... ]

> +	if (!collapsed)
> +		return;
> +
> +	flush_tlb_all();
> +
> +	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
> +		list_del(&ptdesc->pt_list);
> +		__free_page(ptdesc_page(ptdesc));
> +	}
> +}

In 6.18.44 that last loop is pagetable_free(ptdesc), which is still an
immediate free. There is no RCU grace period and no other deferral. The
flush_tlb_all() above it only makes the hardware forget the old
translation; it does nothing about a CPU that is sitting inside
__change_page_attr() holding a pointer into that table.

> @@ -402,7 +450,7 @@ static void cpa_flush(struct cpa_data *cpa, int cache)
>  	if (cache && !static_cpu_has(X86_FEATURE_CLFLUSH)) {
>  		cpa_flush_all(cache);
> -		return;
> +		goto collapse_large_pages;
>  	}

[ ... ]

> @@ -427,6 +475,10 @@ static void cpa_flush(struct cpa_data *cpa, int cache)
>  	mb();
> +
> +collapse_large_pages:
> +	if (cpa->flags & CPA_COLLAPSE)
> +		cpa_collapse_large_pages(cpa);
>  }

The collapse is hooked into cpa_flush(), which
__change_page_attr_set_clr() calls after it has already dropped
cpa_lock. So cpa_lock does not serialise the collapse against anything.

> @@ -1196,6 +1248,161 @@ static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
> +static int collapse_pmd_page(pmd_t *pmd, unsigned long addr,
> +			     struct list_head *pgtables)
> +{

[ ... uniformity checks over all 512 PTEs ... ]

> +	old_pmd = *pmd;
> +
> +	/* Success: set up a large page */
> +	pgprot = pgprot_4k_2_large(pte_pgprot(first));
> +	pgprot_val(pgprot) |= _PAGE_PSE;
> +	_pmd = pfn_pmd(pfn, pgprot);
> +	set_pmd(pmd, _pmd);
> +
> +	/* Queue the page table to be freed after TLB flush */
> +	list_add(&page_ptdesc(pmd_page(old_pmd))->pt_list, pgtables);

collapse_large_pages(), the caller, takes pgd_lock around this. The
lockless CPA walker never takes pgd_lock, so pgd_lock does not help
either.

The other side, in 6.18.44:

    arch/x86/mm/pat/set_memory.c:__change_page_attr() {
            address = __cpa_addr(cpa, cpa->curpage);
    repeat:
            kpte = _lookup_address_cpa(cpa, address, &level, &nx, &rw);
            ...
            old_pte = *kpte;
            ...
            if (level == PG_LEVEL_4K) {
                    ...
                    new_pte = pfn_pte(pfn, new_prot);
                    ...
                    if (pte_val(old_pte) != pte_val(new_pte)) {
                            set_pte_atomic(kpte, new_pte);   <-- stale
                            cpa->flags |= CPA_FLUSHTLB;
                    }

_lookup_address_cpa() reaches lookup_address_in_pgd_attr(), which is a
plain lockless walk. Between the walk and the set_pte_atomic() the
caller can be preempted or take an interrupt; this runs with interrupts
on. That store is the only unsafe instruction in the function. The
large-page split branch further down is safe because __split_large_page()
revalidates under pgd_lock.

The freed table is not even a tracked page table page in 6.18.44:

    arch/x86/mm/pat/set_memory.c:split_large_page() {
            if (!debug_pagealloc_enabled())
                    spin_unlock(&cpa_lock);
            base = alloc_pages(GFP_KERNEL, 0);

A bare alloc_pages(), so it goes straight back to the per-CPU free list
and can be reallocated immediately.


Race timeline
=============

    CPU A (text_poke ->                CPU B (module_enable_rox /
    execmem_make_temp_rw ->            execmem_restore_rox /
    set_memory_nx/rw)                  bpf_jit_binary_lock_ro ->
                                       set_memory_rox, CPA_COLLAPSE)
    -----                              -----
    __change_page_attr()
    kpte = _lookup_address_cpa()
    old_pte = *kpte
    new_pte = pfn_pte(...)
    preempted / interrupted
                                       __change_page_attr_set_clr()
                                       drops cpa_lock
                                       cpa_flush()
                                       cpa_collapse_large_pages()
                                       collapse_pmd_page(): all 512
                                       PTEs uniform, set_pmd() installs
                                       a leaf, old PTE table queued
                                       flush_tlb_all()
                                       pagetable_free() -> immediate
                                       __free_pages()

                                       (any CPU) page is reallocated:
                                       .so page cache folio, QEMU guest
                                       RAM, a user PMD/PTE table, slab

    set_pte_atomic(kpte, new_pte)
    stores a PTE-shaped word into
    the reallocated page

Where the swap PTE comes from (inferred continuation)
------------------------------------------------------

The race above writes a present kernel PTE, never a swap entry. To
reach the dentry hash table with a swap-PTE-shaped word the following
has to happen next. Each step is verified in the 6.18.44 code; the
sequence as a whole is inferred, not proven for this oops.

    1. The freed PTE table is reallocated as a QEMU page table.

    2. The stale set_pte_atomic() lands in it. The injected entry is a
       translation into an execmem text page (case A/B below).

    3. Case B: GUP-slow follows that entry and KVM maps the text page
       into the guest; a later zap_present_folio_ptes() does an
       unbalanced folio_put() and frees the still-live text page.

    4. That text page is reallocated as another page table while
       text_poke()/the BPF JIT keep writing instruction bytes into it
       through the ROX mapping. Instruction bytes are now PMD entries
       with arbitrary pfns; some pass pmd_bad().

    5. Reclaim: try_to_unmap_one() -> page_vma_mapped_walk() ->
       pte_offset_map_lock() reads such a PMD, computes
       __va(garbage pfn) as the PTE table, and set_pte_at() stores a
       swap PTE there. If that pfn is the dentry_hashtable page, one
       bucket head becomes 0x0fffffff0c930020-like.

    6. Days later __d_lookup() hashes into that bucket and faults.

Step 5 is the only writer of an ordinary swap type in the mm, and
the only step that can touch memory the allocator never owned.

This is not speculation about the code. The same interleaving was
reported upstream with a KASAN reproducer, in the commit that first
tried to address it:

    commit 1aac65f3e651 ("x86/mm/pat: Take cpa_lock around large-page
    collapse")

      BUG: KASAN: use-after-free in __change_page_attr+0x7cc/0x7e0
      Write of size 8 at addr ffff888181139718 by task modprobe
      ...
      The buggy address belongs to the physical page:
       pfn:0x181139 ... page_type: f2(table)

    Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after
    fragmentation")
    Signed-off-by: Denis V. Lunev <den@openvz.org>


Which stable releases carry the fixes
=====================================

None of these are in 6.18.44.

The fixes that matter are the init_mm mmap lock pair, a1c7570cedd0 and
d5d8b8662e6e: the collapse runs under the init_mm write lock and the
whole attribute change, including the lockless walk and the store
through the cached pointer, runs under the read lock. That excludes
both walker-vs-collapse and collapse-vs-collapse. 1587d3394e25 covers
the third walker: __text_poke() resolves the pages it patches with
vmalloc_to_page(), a lockless walk of the same execmem tables, and now
takes the init_mm read lock around it. Without that, a collapse under
a concurrent text_poke() returns NULL (the BUG_ON at
arch/x86/kernel/alternative.c:2576 that openSUSE hit) or, if the freed
table has already been reused, a wrong page that text_poke() then
writes instruction bytes into. 9e4a3ec3411b makes the split tables
real kernel page tables so their freeing is deferred. The earlier
cpa_lock patch, 1aac65f3e651, is superseded by the write lock and adds
nothing once those are applied.

  6.18.52
    591b6fac9df3  x86/mm/pat: Take cpa_lock around large-page collapse
                  (upstream 1aac65f3e651)

  6.18.53
    35820cf8dd52  x86/mm/pat: Acquire init_mm write lock on collapse to
                  avoid UAF (upstream a1c7570cedd0)
    e21a9ea81426  x86/mm/pat: Acquire init_mm read lock on attribute
                  changes to avoid UAF (upstream d5d8b8662e6e)
    e164f4a25e23  x86/mm/pat: Convert split_large_page() to use ptdescs
    5029589bb773  x86/mm/pat: Don't gate cpa_lock on
                  debug_pagealloc_enabled()
    84e0cd79d57f  x86/mm/pat: Allocate split page tables as kernel page
                  tables (upstream 9e4a3ec3411b)
    281e6f536f2f  x86/alternatives: Exclude text poking against
                  change_page_attr() (upstream 1587d3394e25)
    74a2626044de  x86/mm: Fix and document DEBUG_PAGEALLOC
                  (upstream 7da514d819a0)

6.18.52 does not fix this: it only takes cpa_lock around the collapse,
and the walker never holds cpa_lock across its walk-then-store window.
The init_mm mmap lock pair that closes that window is in 6.18.53, which
is the first stable release with the complete set. Use 6.18.53 or
later.

There is no clean interim mitigation on 6.18.44. CPA_COLLAPSE cannot be
disabled by a boot parameter.


How this reaches the symptoms you saw
=====================================

Symptoms 1 and 2 follow directly. The stale store writes a PTE-shaped
qword into a page that has been reallocated. If that page is a page
cache folio for a mapped .so, eight bytes of its relocation table are
replaced and ld.so trips the R_X86_64_RELATIVE assertion while the file
on disk is intact. If it is an anonymous page that QEMU has just
populated as guest RAM on a migration destination, the guest sees eight
corrupt bytes. Both of these match "right after migration": the
destination host is populating gigabytes of guest RAM and allocating
page tables at maximum rate, which is exactly when a just-freed page
gets reused inside the race window.

Symptom 3, this oops, needs one more step, because the dentry hash table
is memblock memory that is never freed and therefore cannot be the
directly reallocated page. The escalation is that the victim page is
itself a page table. Each of the following links is verified in the
6.18.44 source, but I want to be clear that the end-to-end chain for
this particular oops is plausible rather than proven from a single
vmcore.

Case A, the victim is a user PMD table. pmd_bad() is true for the
injected value, so the first user-mode touch faults and
mm/pgtable-generic.c:___pte_offset_map() heals it via pmd_clear_bad()
with a "bad pmd" pr_err. But a supervisor-side copy_to_user() is
permitted through a U=0 level. A read() or recvmsg() into guest RAM, or
vhost-net, or kvm_write_guest(), then has the hardware walker read a
qword of module text as a PTE. If that qword happens to have P and RW
set, the copied data is written to an arbitrary physical address. This
route leaves no taint.

Case B, the victim is a user PTE table. x86 has no pte_bad(). GUP-fast
rejects a U=0 entry, but GUP-slow does not:
mm/gup.c:follow_page_pte() and mm/memory.c:__vm_normal_page() check
neither _PAGE_USER nor PageReserved, so a live execmem page is returned
and KVM maps kernel module text into a guest. A later
mm/memory.c:zap_present_folio_ptes() does folio_remove_rmap_ptes() and
folio_put() on a page that was never rmapped, dropping the refcount to
zero, printing "BUG: Bad page map" and releasing live ROX text into the
buddy allocator while text_poke() and the BPF JIT keep writing
instruction bytes into it. Recycled as a user PMD table, instruction
bytes are page table entries with arbitrary pfns that pass pmd_bad(),
pte_offset_map() computes __va() of an arbitrary physical page, and
try_to_unmap_one() writes a genuine host swap PTE into it.

That last step is what the corrupt word looks like: a real host swap
PTE. The stray bit 5 is unexplained on this route too.

One caveat that argues against case B on this specific host: the taint
is "G   E" with no "B". "BUG: Bad page map" had not fired on that
machine before the crash. So either the taint-free case A route or a
direct stray write carries this particular chain, or the corrupting
event happened on a different boot. This limits, but does not refute,
the cascade. The corruption can sit in a rarely used dentry bucket for
a long time before something hashes into it, which fits the 22-day
uptime on this crash and your observation that the host crashes were
not correlated with migration.


Secondary findings
==================

These came up while looking and are worth knowing about, but none of
them explains this oops.

26505e1b5b54 ("KVM: SVM: make svm_flush_tlb_gva do a full asid flush if
NPT enabled") is mainline only and has not been backported to 6.18.y.
It is AMD-specific guest memory corruption via the Hyper-V PV TLB flush
path, so it only affects Windows guests running with hv-tlbflush=on. If
any of your crashing guests are Windows, this is worth backporting
separately. It is independent of the CPA race.

55ddbc2ca6d5 (upstream f7491d7c81db, "x86/mm: Fix user-space data loss
with MADV_FREE and THP") is a real bug in 6.18.44. pmd_modify() drops
_PAGE_DIRTY, which has been the case since v6.10, and it causes data
loss for MADV_FREE THP and writable file THP. It is fixed in 6.18.53.
It is data loss rather than a stray write, so it does not explain the
oops, but it is another reason to move off 6.18.44. Note that this one
needs THP, which you have now disabled.

d053eb7e09e1 (upstream 1e75a8255f11, "iommu/amd: Wait for completion
instead of returning early in iommu_completion_wait()") is already in
6.18.42 and therefore in the kernel that crashed. It is ruled out for
this oops, but it may be relevant to the earlier incidents you had on
6.18.31 through 6.18.41.


Theories that were eliminated
=============================

KVM NPT mapping at too large a level, or with the wrong base pfn. The
mapping level comes from the host page tables and the pfn from GUP;
KVM cannot reach memblock memory on its own.

A host mm swap or migration PTE stored through a stale page table
pointer. All the store sites are bounded and the pointer provenance
checks out.

A missed MMU notifier invalidation. Notifier ordering on the recovery
path is correct, and this cannot reach never-freed memory.

NIC DMA to the wrong address. Only a teardown-time page_pool
use-after-free turned up, and the iommu/amd completion-wait fix is
already in 6.18.42.

105d04edbec8 (upstream 33192a26cddea, mm/huge_memory huge_zero_pfn
race). Real, but not present in 6.18.44, and it cannot reach memblock
memory.

0a25ee42e7d1 (upstream 3d679b7cb31f, KVM x86/mmu CMPXCHG when clearing
the Accessed bit in the TDP MMU). Not in 6.18.44, and benign for this.

TDP MMU in-place huge page recovery. Structurally excluded: notifier
zaps take mmu_lock for write, recovery takes it for read.

memblock/buddy physical aliasing. This would produce "Bad page state"
reports, which you have not seen. Worth confirming from the vmcore, see
below.

Neither THP nor NUMA balancing is involved in the CPA race. Disabling
them was a reasonable precaution but it will not stop this. If you keep
seeing corruption with THP off, that is consistent with the diagnosis
rather than against it.


What would confirm this
=======================

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

--a2ha3se4httuixcd--

