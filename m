Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3182210BA45B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 755FB6B00A7; Fri, 27 Mar 2026 05:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706AF6B00A8; Fri, 27 Mar 2026 05:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D2A6B00A9; Fri, 27 Mar 2026 05:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FBE96B00A7
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:11:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 113EEBE320
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:11:21 +0000 (UTC)
X-FDA: 84591274362.03.7EDF733
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3378318000B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:11:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bhyVkfwF;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774602679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K/f5le8ENeENe/lEDzJuYx2wswMwlJZon2lhnDttT6I=;
	b=LbxES50/Ry2yuRTuFAHpVQF8jWLZrhIgqqexGkqdnv5DoQgvu7CRcDAhyoZalup+PipLEn
	oYCuPDK8Xg/bH59zCzejeEtrcD3hsAr99OkVslIBDoC3RWc8CTV4veflIcstUYtdU+LlrM
	arLrz1VFx49X4owoQtNAAgBuCc6U/EU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bhyVkfwF;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774602679; a=rsa-sha256;
	cv=none;
	b=lU8NEqiC6HRtCwnDLBLZNQg5CuXR0FgN5qn2XRFPoeMBfiRLXYZtXLPdZ4V0/CDtnQW3jO
	PN6NUQdcf5hH3IMNdtWzbYWMt8KncRCzj4cQRyPPihxFmfaATH96VrOI3pfwMPuuHpD1jp
	MCkwuELKqoEZLbzcHIK98sgSi/alfjM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 70F6A60133;
	Fri, 27 Mar 2026 09:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9891C19423;
	Fri, 27 Mar 2026 09:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774602678;
	bh=gsdl8OoXFa/X+Ktn9BP5eKegQj8eqTkkYn0pJrZrwWQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bhyVkfwFuQVPuNbnML6nJWlyQlw+2mkAH0fZ25B03Dn7afu3lDSmQH4sxFDtcIPc3
	 rJt/cJlTfazixi5K2zAvOfTjhi0laUSB2vvz3O6EEv4R5yLn2+60sgeSRH0rpYlqde
	 DOVxsJQvgSUgVXiUdr6s3q/tFwULJ+WYoQWdNr7rztBccFwRBNMKr9lSRHjuJIDix8
	 k+6rUkYpgiqZYzeYjyQdxPedjeccfxEbBOX4gL7GsHqhdCK7bNv++6yC8WZgZJ+D60
	 DrvuqnL3mmkw63NyH/Ark9O5YXf3m9a6RmxzB0f50Lqbf233lYWBwpiydaXLhnQYPC
	 JHPI9CcBC4+2g==
Date: Fri, 27 Mar 2026 09:11:15 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: antonius <bluedragonsec2023@gmail.com>
Cc: linux-mm@kvack.org, liam.howlett@oracle.com, jeffxu@chromium.org, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [BUG] mm/vma.c:830 WARNING in vma_modify() via mseal(2) --
 deterministic trigger without fault injection on Linux 7.0-rc5
Message-ID: <6f78bafa-924d-42d5-8ecc-f7043104e8cd@lucifer.local>
References: <CAK8a0jwWGj9-SgFk0yKFh7i8jMkwKm5b0ao9=kmXWjO54veX2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8a0jwWGj9-SgFk0yKFh7i8jMkwKm5b0ao9=kmXWjO54veX2g@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3378318000B
X-Stat-Signature: xj3howdykzom3dqsh7fydkdtpnowzsm9
X-Rspam-User: 
X-HE-Tag: 1774602679-189384
X-HE-Meta: U2FsdGVkX19lfGY0W0ICvWk7Ka+Dhq04faq9Pvdg+USkK7bZkktw74aRp2Jk1zFP8YEPvyqFO+TMfJx8ijCYrlnME/IRHUVt0YiivWsAeU3wEH7pl0I6VsNlaAwuLj263YZ+IJhKTz23HOR0bNB2g1hwUGbxGLG0x7icoIKAA/0diw+adCddqDN+eNB86L7x+dO91I+s+djdNdEb64E9sZ+1dVM0UNGNKTTyrDjLevHKQoO+RFFItPgO6wOkMHE1A6u3mfK2HW5POXzJdt1itqTozStMNGLo/MI41Ay806MH4hNg2dzMMG7ZTjhlukgD89+lf4NIvLX1pXk4pc0VizQu4+EkalkDwO4c5RXfJEriF9SpLboC1eG1pZ+V3GK2uYGvhnbHZJwaidSAgJZ0Yu23KSFgkU/Yg2BV/D3jWac/tbRFXE2+joebRq/SsKSsKCyChv/0ry2hOX/cIuxFpAamavLcnsUNzSYpQxu2j1LUhxR7Xm76XffL/IYQ+dMN0SqLIFEKGjexZcyx3tcF7ia7xZnsBdT3WGiJbOB3jS51ipKv9Hrg5sec7lu9te7zvf8FClGpBpG8YN3EPNw4TifRedWVyGLLJ1excm1dVyoEtnTObfrVMUeiS2Huo227CafFnVAI8GP+e1yIlFMexPN4Nrg96KC7sFtmY/PXlJeD7mvgflppiGm8sv3SY4foNHAKNIUNHYJHeIwb306hr9oUkZglijHASFomLLBUEjHr4ZWbHiSZ4LQCQlChYOKXLJ1ZNrlb5Bq8R0uBybBrW3y/hT4Yk+xQM9JdxuqheazYzzw1z4lddX5pNWgcX28fwCnoXF34v5gH02kcoj7vK9DQsvwVVsDFkmj6NNea8CQqpmcnktK+SCfehryom1qkzGwcxhjKi8ILulAL8C5CKhfjpYI6JusrCsI/pO+ayw5SqAdW2AYgkViwSqSkc3ZTPwJZjB6r/cBFeIkkx3e
 jjOaZqTa
 UrMBccC5qxNW6nWXjUat16jr8zxZwfrP9e3AatHYzlbpzLZLVwqPKHyxkS48atb13LLd34sdPohVHyL+jfQkozxcrEHdhxtLgJS9Dq5SfXMcWAQNF0+X4aHFPK5+7cLYTNprWGb7x/eVAJRqKzxJbRtCu9e6b3pHSXbCg883HJZ4jOg8XHNuc+hCyUHNH3OLjHLSwnzMt3ymGsqhS8f6a9MfPqu7suy7Xgo85RYJ+is2Y/dfy+bV8YzP3Zm92UwUMjxtQ0dGKW+2T1xoWL2jb6Y/B3IUYwBK+OGYjwkg9xf8fMLEJgPMXw+2Pw2fiObgJJ/Q66/lKzrmsF0lc5fM106IbUnE05RPs50xkouCCTYw6IXc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-cc old email (please use ljs@kernel.org for correspondence)
+cc linux-mm

On Fri, Mar 27, 2026 at 02:46:32PM +0700, antonius wrote:
> Hello,
>
> I am reporting a reproducible WARNING in vma_modify() at mm/vma.c:830,
> triggered via the mseal(2) syscall on Linux 7.0.0-rc5. The bug was
> discovered using Syzkaller-based fuzzing.

Thanks very much! This is very much appreciated.

So this is triggering:

	/*
	 * If middle == prev, then we are offset into a VMA. Otherwise, if we are
	 * not, we must span a portion of the VMA.
	 */
	VM_WARN_ON_VMG(middle &&
		       ((middle != prev && vmg->start != middle->vm_start) ||
			vmg->end > middle->vm_end), vmg);


And the repro is working for me thanks, it's refreshing to get a nice
consistent repro :)

Looks like the repro is creating two overlapping ranges:

	m2
	0x21da6000                0x21e81000
	|-------------------------|----|
	|           vma2          |vma1|
	|-------------------------|----|
	<------------------------><---->
	         0xdd pages        2pgs

(vma2 with fd2, vma1 with fd1)

Then first mseal split things into:

	0x21da6000 0x21de6000        0x21e81000
	|--|-------|-----------------|----|
	|v2| vma2S |       vma2'     |vma1|
	|--|-------|-----------------|----|
	   0x21da8000

With vma2, vma2' unsealed, vma2S sealed (all with fd2) and vma1 with fd1.

Then we try to mseal:


	0x21da6000 0x21de6000     .  0x21e81000
	|--|-------|--------------.--|----|
	|v2| vma2S |       vma2'  .  |vma1|
	|--|-------|--------------.--|----|
	.  0x21da8000             .
	<------------------------>.
	                          0x21e16000

In mseal_apply() with start=0x21da6000, end=0x21e16000

static int mseal_apply(struct mm_struct *mm,
		unsigned long start, unsigned long end)
{
	...
	unsigned long curr_start = start;
	...

	for_each_vma_range(vmi, vma, end) {
		const unsigned long curr_end = MIN(vma->vm_end, end);

		if (!(vma->vm_flags & VM_SEALED)) {
			vm_flags_t vm_flags = vma->vm_flags | VM_SEALED;

			vma = vma_modify_flags(&vmi, prev, vma, curr_start,
					       curr_end, &vm_flags);
			if (IS_ERR(vma))
				return PTR_ERR(vma);
			vm_flags_set(vma, VM_SEALED);
		}

		prev = vma;
		curr_start = curr_end;
	}

	return 0;
}

Iteration 0:

curr_start = 0x21da6000
curr_end = MIN(0x21da8000, 0x21e16000) = 0x21da8000

		if (!(vma->vm_flags & VM_SEALED)) {

Is true

So:

			vma = vma_modify_flags(&vmi, prev, vma, curr_start,
					       curr_end, &vm_flags);

Results in a MERGE:

	0x21da6000 0x21de6000        0x21e81000
	|----------|-----------------|----|
	|  vma2S   |       vma2'     |vma1|
	|----------|-----------------|----|

But...

curr_start = curr_end = 0x21da8000
             ^
	     |
	     This is not updated!!

prev = vma = the now-merged vma2S.

Then iteration 1:

curr_start = curr_end = 0x21da8000

Annnd we're in trouble because this is wrong.

vma moves to next VMA (0x21de6000)

And:
		const unsigned long curr_end = MIN(vma->vm_end, end);

Results in curr_end = MIN(0x21de6000, 0x21e16000) = 0x21de6000

And prev = vma2S, vma/middle = vma2', next = vma1

So:

	0x21da6000 0x21de6000        0x21e81000
	|----------|-----------------|----|
	|  vma2S   |       vma2'     |vma1|
	|----------|-----------------|----|
	   ^       ^
	   |       |
	   |       curr_end
	   curr_start = 0x21da8000 - OFFSET into vma2S. INCORRECT.

So:

	VM_WARN_ON_VMG(middle &&
		       ((middle != prev && vmg->start != middle->vm_start) ||
			vmg->end > middle->vm_end), vmg);

Where vmg->start = 0x21da8000 which != middle->vm_start == 0x21da6000 so
this triggers.

It's essentially asserting we're not offset into the VMA, but here we are.

I've sent a fix for this already - see
https://lore.kernel.org/all/20260327090640.146308-1-ljs@kernel.org/

Cheers, Lorenzo


>
> REPORTER
> --------
> Antonius / Blue Dragon Security
> https://bluedragonsec.com
> https://github.com/bluedragonsecurity
>
> NOTE ON RELATIONSHIP TO KNOWN BUGS
> -----------------------------------
> The VM_WARN_ON_VMG at mm/vma.c:830 inside vma_merge_existing_range()
> has been previously encountered via madvise()+OOM conditions
> (reported by syzbot+46423ed8fa1f1148c6e4 and Brad Spengler; addressed
> by Lorenzo's patch "mm: abort vma_modify() on merge out of memory
> failure").
>
> This report describes a DISTINCT trigger via mseal(2) that:
>   1. Does NOT require fault injection or OOM pressure
>   2. Is 100% reproducible on every run (fires within 1 second)
>   3. Goes through a different call path: do_mseal() -> mseal_apply()
>      rather than madvise_walk_vmas()
>   4. Is triggered by VM_SEALED flag state inconsistency across VMAs,
>      not by a failed merge commit
>
> I could not find a prior LKML report or syzbot entry for this specific
> mseal(2) trigger.
>
> SUMMARY
> -------
> File:    mm/vma.c, line 830
> Func:    vma_merge_existing_range()
> Trigger: mseal() spanning two adjacent VMAs where the first has
>          VM_SEALED set and the second does not
> Via:     mseal(2) -> do_mseal() -> mseal_apply() ->
>          vma_modify_flags() -> vma_modify() ->
>          vma_merge_existing_range() -> VM_WARN_ON_VMG
>
> AFFECTED VERSIONS
> -----------------
> Linux 7.0-rc3  -- confirmed (original fuzzing target)
> Linux 7.0-rc4  -- confirmed (mm/vma.c unchanged rc3->rc4)
> Linux 7.0-rc5  -- confirmed (mm/vma.c unchanged rc4->rc5)
> Linux 6.x      -- NOT affected (mm/vma.c rewritten for 7.0)

This doesn't seem to be correct, this bug has been there since v6.17,
doh...

>
> DMESG OUTPUT (Linux 7.0.0-rc5, trimmed)
> ----------------------------------------
>
>   [ 1680.275764] ------------[ cut here ]------------
>   [ 1680.275771] WARNING: mm/vma.c:830 at vma_modify+0x35b/0x2190
>   [ 1680.275808] CPU: 0 UID: 1000 PID: 1661 Comm: repro_mseal_vma
>   [ 1680.275826] Tainted: [W]=WARN  7.0.0-rc5 #1 PREEMPT(lazy)
>   [ 1680.275969] Call Trace:
>   [ 1680.275975]  <TASK>
>   [ 1680.276030]  vma_modify_flags+0x24c/0x3c0
>   [ 1680.276085]  do_mseal+0x489/0x860
>   [ 1680.276136]  __x64_sys_mseal+0x73/0xb0
>   [ 1680.276187]  do_syscall_64+0x111/0x690
>   [ 1680.276207]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   [ 1680.276394] ---[ end trace 0000000000000000 ]---
>
>   [ 1680.314910] vmg dumped because:
>     VM_WARN_ON_VMG(middle &&
>       ((middle != prev && vmg->start != middle->vm_start) ||
>        vmg->end > middle->vm_end))
>
>   vmg state:
>     vmi [21de6000, 21e83000)
>     prev   [21da6000-21de6000)  flags: 0x400000000f8 (VM_SEALED set)
>     middle [21de6000-21e83000)  flags: 0xf8           (NOT sealed)
>     vmg->start = 0x21da8000
>     vmg->end   = 0x21e16000
>
> ROOT CAUSE
> ----------
> The bug is in vma_merge_existing_range() at mm/vma.c:830.
>
> Reproduction sequence:
>
>   1. memfd_create("syz-mseal", MFD_CLOEXEC)  -> fd1
>   2. mmap(0x21da8000, 0xdd000, PROT_SEM, MAP_SHARED|MAP_FIXED, fd1, 0)
>      -> establishes VMA at [0x21da8000 .. 0x21e85000)
>
>   3. memfd_create("syz-mseal", MFD_CLOEXEC)  -> fd2
>   4. mmap(0x21da6000, 0xdd000, PROT_SEM, MAP_SHARED|MAP_FIXED, fd2, 0)
>      -> remaps, leaving:
>           VMA-A [0x21da6000 - 0x21de6000)  pgoff=0    (fd2)
>           VMA-B [0x21de6000 - 0x21e83000)  pgoff=0x40 (fd2)
>           VMA-C [0x21e83000 - 0x21e85000)  (leftover)
>
>   5. mseal(mmap1_result, 0x3e000, 0)
>      -> seals [0x21da8000 .. 0x21de5fff]
>      -> VMA-A gets VM_SEALED (0x400000000000) set
>
>   6. mseal(mmap2_result, 0x70000, 0)
>      -> targets [0x21da6000 .. 0x21e15fff]
>      -> range spans VMA-A (sealed) and VMA-B (not sealed)
>
> In step 6, do_mseal() calls mseal_apply() per-VMA but ultimately
> calls vma_modify_flags() with the original full mseal start address
> (0x21da8000). When vma_merge_existing_range() processes VMA-B as
> "middle":
>
>   vmg->start        = 0x21da8000  (original mseal start)
>   middle->vm_start  = 0x21de6000  (VMA-B start)
>   middle != prev                  (different VMA objects)
>
>   -> vmg->start != middle->vm_start  -> WARN_ON fires at line 830
>
> The invariant violation occurs because the vmg->start passed to
> vma_modify_flags() is not clamped to the current VMA's start when
> the mseal range spans multiple VMAs with different VM_SEALED states.
>
> IMPACT
> ------
> - Reachable from unprivileged userspace (UID 1000, no capabilities)
> - Only memfd_create(2), mmap(2), mseal(2) required
> - The WARN_ON indicates that vma_merge_existing_range() operates on
>   an inconsistent vmg state; in production kernels with WARN compiled
>   to no-op, this could result in VMA tree state inconsistency
> - mseal is a security primitive; invariant violations in its
>   application logic are security-relevant
>
> SUGGESTED FIX DIRECTION
> ------------------------
> In do_mseal() or mseal_apply() (mm/mseal.c), when iterating over
> VMAs in the mseal range, the vmg->start passed to vma_modify_flags()
> should be clamped to max(mseal_start, vma->vm_start) rather than
> using the original mseal() start address. This would prevent
> vma_merge_existing_range() from receiving a vmg->start that is
> inconsistent with vmg->middle when the mseal range spans multiple
> VMAs with different seal states.
>
> Alternatively, the WARN_ON in vma_merge_existing_range() may need
> to account for the mseal multi-VMA iteration pattern, though fixing
> the caller in do_mseal() seems more appropriate.
>
> REPRODUCER
> ----------
> Compile: gcc -O2 -o repro repro_mseal_vma.c && ./repro
> Fires:   Within 1 second, iteration 0, no fault injection, no root
>
>   #define _GNU_SOURCE
>   #include <stdint.h>
>   #include <stdio.h>
>   #include <stdlib.h>
>   #include <string.h>
>   #include <sys/syscall.h>
>   #include <sys/wait.h>
>   #include <unistd.h>
>
>   #ifndef __NR_memfd_create
>   #define __NR_memfd_create 319
>   #endif
>   #ifndef __NR_mseal
>   #define __NR_mseal 462
>   #endif
>
>   static void setup(void) {
>     syscall(__NR_mmap, 0x1ffffffff000UL, 0x1000UL, 0UL, 0x32UL, -1, 0UL);
>     syscall(__NR_mmap, 0x200000000000UL, 0x1000000UL, 7UL, 0x32UL, -1, 0UL);
>     syscall(__NR_mmap, 0x200001000000UL, 0x1000UL, 0UL, 0x32UL, -1, 0UL);
>   }
>
>   static void trigger(void) {
>     intptr_t fd1, fd2, m1, m2;
>     memcpy((void*)0x200000000100UL, "syz-mseal\0", 10);
>     fd1 = syscall(__NR_memfd_create, 0x200000000100UL, 1UL);
>     if (fd1 < 0) return;
>     m1 = syscall(__NR_mmap, 0x21da8000UL, 0xdd000UL,
>                  8UL, 0x11UL, (intptr_t)fd1, 0UL);
>     memcpy((void*)0x200000000100UL, "syz-mseal\0", 10);
>     fd2 = syscall(__NR_memfd_create, 0x200000000100UL, 1UL);
>     if (fd2 < 0) return;
>     m2 = syscall(__NR_mmap, 0x21da6000UL, 0xdd000UL,
>                  8UL, 0x11UL, (intptr_t)fd2, 0UL);
>     syscall(__NR_mseal, (uint64_t)m1, 0x3e000UL, 0UL);
>     syscall(__NR_mseal, (uint64_t)m2, 0x70000UL, 0UL);
>   }
>
>   int main(void) {
>     setup();
>     for (int i = 0;; i++) {
>       int pid = fork();
>       if (pid == 0) { trigger(); _exit(0); }
>       int st; waitpid(pid, &st, 0);
>       fprintf(stderr, "[iter %d]\n", i);
>     }
>   }
>
> VERIFICATION
> ------------
> Kernel:    Linux 7.0.0-rc5 #1 SMP PREEMPT_DYNAMIC x86_64
> HW:        QEMU Standard PC (i440FX + PIIX), BIOS 1.17.0-debian
> User:      UID 1000 (no root required)
> Fires:     Iteration 0, consistently, < 1 second
> mm/vma.c:  Not patched in rc3->rc4 or rc4->rc5
>
> ---
> Reported-by: Antonius <antonius@bluedragonsec.com>
>
> Please use this tag in the fix commit:
>   Reported-by: Antonius <antonius@bluedragonsec.com>
>
> ---
> If this is a known issue or already fixed, please point me to the
> relevant commit. I was unable to find a matching LKML/syzbot entry
> for this specific mseal(2) trigger path.
>
> Thank you,
> Antonius
> Blue Dragon Security
> https://bluedragonsec.com
> https://github.com/bluedragonsecurity

