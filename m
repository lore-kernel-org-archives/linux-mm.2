Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E57CC1125847
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 16:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A68F46B0089; Wed, 11 Mar 2026 12:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A16DE6B008A; Wed, 11 Mar 2026 12:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922696B008C; Wed, 11 Mar 2026 12:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6FCB56B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:17:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0855A8AEC1
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:17:16 +0000 (UTC)
X-FDA: 84534286872.20.B087DCC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5239F8001B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:17:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G148Rhjt;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773245834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zR5i46xDbhmeSJjq4XdGFBMV3VCpEvqNMXuKaXWMMqc=;
	b=8ClfNw17VxKbiCfSA4cMQ52Y1zyvM92MF+HV0eXxaNIuyMZdTclzetArX9BFya04cPtjjm
	J2J93s/gJWpkLSMFoNf3vQk92tRlDBc/ac8Sml7M662yY6RsDchTANz2sUD60DMTCdmYYI
	TLUGaSMaKczRSg0QYtlMTmBKV02ypb4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G148Rhjt;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773245834; a=rsa-sha256;
	cv=none;
	b=kbEs7NuKKfVf9SHVbsBRAtyj3kKXluvuOQhj1OkGdPvRATSxi+8MLkzQ0rfSNFscWwChKe
	V0TJKpUxHfGxmEcOGGFRN1uGhAkTPqorof3ixO9zF3s/auGl2lSZRWuE5O80oqBBvBnN4J
	gMK8rvPRBPG9ZtC1jVuvYMja2+TvV5Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C491F60054;
	Wed, 11 Mar 2026 16:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846CFC4CEF7;
	Wed, 11 Mar 2026 16:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773245833;
	bh=6MCIQ808NMrvAI2QdBiCz63I6Hb0yQa9/67NPihhF1Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G148RhjtorvNmtM/B23TFD0QAwyjQa0UC7lMWG/QX4NdAS0zBCqJBxH5BfYn1DKl3
	 eJIKz1fdTyC3AYum2JIexVmYllHDIqXQTOZNxLsXXqFS8a30YmoWzOqGFy5eriDZIl
	 zp2ailBw3DqT/cl80PlRE9DWSr6Dj4jzOhKzFD++/F4OypTCaogEt3B25m9iW9Rn6T
	 kluyvePcdOzxNMZLHlrbRsEP7MMqa1g2cj9FhWzRIGuEdF0bbFzEPQcMNcJmY3kBV6
	 +7oKytCs9RdaRtxFCVf3EEOy2I9DRRBcpsCuhSuzzyQZfGRfq9Qd5eDRx8V4/ZFMDx
	 YTa2RqHxUv4Hg==
Date: Wed, 11 Mar 2026 16:17:09 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Jianzhou Zhao <luckd0g@163.com>, akpm@linux-foundation.org, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: BUG: KCSAN: data-race in do_mremap / vma_complete
Message-ID: <3c0873a2-6b9c-4842-b2d3-c3ffe908afbe@lucifer.local>
References: <1a7d4c26.6b46.19cdbe7eaf0.Coremail.luckd0g@163.com>
 <abaad620-bc19-4a3b-9bef-6a1ad4335ce3@lucifer.local>
 <u7wzfkse7au4aganufewx2ykz5xg2lgzaf2eu3tfkmowcmsobb@4xubw3ikany2>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <u7wzfkse7au4aganufewx2ykz5xg2lgzaf2eu3tfkmowcmsobb@4xubw3ikany2>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5239F8001B
X-Rspamd-Server: rspam08
X-Stat-Signature: i4zn8hy3aweag8geiwgft4bwtud8pqdt
X-HE-Tag: 1773245834-837009
X-HE-Meta: U2FsdGVkX18ypQnYO7UbZ/cqetvCM6Ij8b6B37o1f3ZYlsxS0udCo0xDoamkyB7GbVuF971btBSmabmwHDOGDS59BidPp116nJ2MTUaYSAbfICoPaVYM0wNrlJaaHhROIvkcmgOjJOJBXfPJr6rCZbX9sS04vlKpKzFImVgRDbFxWvpSivGtcKMGsnmiZZ1fbPn1d6zjcWAv/f+kw6quT+FT/Ez26SFMDpak+BcauEJ/EZV+MIQwCfTCpDqUgWOilykmDVAsB15c30/gOdgTOiJJ3e79gNqWbx38FrVdVIZPHnXO3B11CZqTOCvUD5R0c22ZJQi/VDt5quWb77C2zRab/dKBOJS5IDavc1DJQyhegNphml9huA+aITxKedrrBUduA1KdDGre0eS32/v764rEID9+qaUAi4w4/333jOMpr3bcrGbP1tSDbMs2bd8Tq4KvbQjofLFBjQyPYX1kCCvdXocia53Lwg5zjvGMd+3TtjscTPR75tGAOdg2FAV6KGUpjQba6JS4E2Ig8D5VG3LQ6F9+hSWxiIVk+ibNRPJ+W0u7Bo24JF+BBMj4pViogXvfxRQ5IrfVPqJS47eokX0qnqvZJHcmtpKtpZj4s2yjBq1X5sVwfKOd76Dfa+bMSu0KtE0IHT4WRJPqdp4TcuUVJv2t2pzVK+p3WTYg7lQ+wPkHXISF6UndjCdSOpbOPH3KFGnCgm9R1zduRLDCPjZyLuuD38Bcmde0linV9zhSVAYPq8c93E+G4mCshssHuzAjUYLVjiQL+mOqUhecUjgrl1jDkE0c7CB42s5PPK95bzHUWHozx8m4UJl3Tekuj33RIgM/EOg7SvfkTwOdDCR3H2+aFGqC57oh1pWxAydnON94IGI5Dd3vN7MZi3jVCnPqrsTIyeAHIIh0pgG+jPuEnH/TTDRLFRQUH9P7JmfYDo6zBQ+PUUnQM/sCkh+k6UaQJ3camkRW01pvqur
 Sj4OcDz8
 lQ8m1ETC3wTKikyVPRnf8HwEDGkMHEUc/agp/h1fdcvJ/SZqz+0puGvenXCU8Jbzte5li1tJos2tyrA3JN+TPNMPuy12tit3tabMXr+dEw79znRot8RsIqpGS5EjUw1dOuxsShNqdbNNKJ9u2+elSBpfKSoqm8lyZrFq7GAeivYhLVO3popd76kXQc7YjpqwxjrbOKC/Dwj2zdZFJmuCVPV5dAwKk2ncxtYyPEAn3a0OKivCQGbrRUlbJrfWCeynVj/RN5R7YV8WaFMz4qvRxhFOy8pj/dwcuxRh9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 10:27:32AM +0000, Pedro Falcato wrote:
> On Wed, Mar 11, 2026 at 10:11:20AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > (Removing incorrect mail, I know it'll take a while to propagate the mail
> > change :)
> >
> > On Wed, Mar 11, 2026 at 03:58:55PM +0800, Jianzhou Zhao wrote:
> > >
> > > Subject: [BUG] mm/mremap: KCSAN: data-race in do_mremap / vma_complete
> > > Dear Maintainers,
> > > We are writing to report a KCSAN-detected data race vulnerability within the memory management subsystem, specifically involving `vma_complete` and `check_mremap_params`. This bug was found by our custom fuzzing tool, RacePilot. The race occurs when `vma_complete` increments the `mm->map_count` concurrently while `check_mremap_params` evaluates the same `current->mm->map_count` without holding the appropriate `mmap_lock` or using atomic snapshot primitives (`READ_ONCE`). We observed this bug on the Linux kernel version 6.18.0-08691-g2061f18ad76e-dirty.
> > > Call Trace & Context
> > > ==================================================================
> > > BUG: KCSAN: data-race in do_mremap / vma_complete
> > > write to 0xffff88800c232348 of 4 bytes by task 27920 on cpu 1:
> > >  vma_complete+0x6d2/0x8a0 home/kfuzz/linux/mm/vma.c:354
> > >  __split_vma+0x5fb/0x6f0 home/kfuzz/linux/mm/vma.c:567
> > >  vms_gather_munmap_vmas+0xe5/0x6a0 home/kfuzz/linux/mm/vma.c:1369
> > >  do_vmi_align_munmap+0x2a3/0x450 home/kfuzz/linux/mm/vma.c:1538
> > >  do_vmi_munmap+0x19c/0x2e0 home/kfuzz/linux/mm/vma.c:1596
> > >  do_munmap+0x97/0xc0 home/kfuzz/linux/mm/mmap.c:1068
> > >  mremap_to+0x179/0x240 home/kfuzz/linux/mm/mremap.c:1374
> > >  ...
> > >  __x64_sys_mremap+0x66/0x80 home/kfuzz/linux/mm/mremap.c:1961
> > > read to 0xffff88800c232348 of 4 bytes by task 27919 on cpu 0:
> > >  check_mremap_params home/kfuzz/linux/mm/mremap.c:1816 [inline]
> > >  do_mremap+0x352/0x1090 home/kfuzz/linux/mm/mremap.c:1920
> > >  __do_sys_mremap+0x129/0x160 home/kfuzz/linux/mm/mremap.c:1993
> > >  __se_sys_mremap home/kfuzz/linux/mm/mremap.c:1961 [inline]
> > >  __x64_sys_mremap+0x66/0x80 home/kfuzz/linux/mm/mremap.c:1961
> > >  ...
> > > value changed: 0x0000001f -> 0x00000020
> > > Reported by Kernel Concurrency Sanitizer on:
> > > CPU: 0 UID: 0 PID: 27919 Comm: syz.7.1375 Not tainted 6.18.0-08691-g2061f18ad76e-dirty #42 PREEMPT(voluntary)
> > > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> > > ==================================================================
> > > Execution Flow & Code Context
> > > In `mm/vma.c`, the `vma_complete()` function finalizes VMA alterations such as insertions. When a new VMA is successfully attached (e.g., during splitting), the function increments the process's `map_count` while holding the necessary `mmap_lock` in write mode from the calling context:
> > > ```c
> > > // mm/vma.c
> > > static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
> > >     struct mm_struct *mm)
> > > {
> > >  ...
> > >  } else if (vp->insert) {
> > >   /* ... split ... */
> > >   vma_iter_store_new(vmi, vp->insert);
> > >   mm->map_count++; // <-- Plain concurrent write
> > >  }
> > >  ...
> > > }
> > > ```
> > > Conversely, the `mremap` syscall validation sequence preemptively evaluates `check_mremap_params()` *before* acquiring the `mmap_lock`. This allows dropping malformed syscalls fast but leaves the map quota check unsynchronized:
> > > ```c
> > > // mm/mremap.c
> > > static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
> > > {
> > >  ...
> > >  /* Worst-scenario case ... */
> > >  if ((current->mm->map_count + 2) >= sysctl_max_map_count - 3) // <-- Plain concurrent read
> > >   return -ENOMEM;
> > >  return 0;
> > > }
> > > ```
> > > At `mm/mremap.c:1924`, the `mmap_write_lock_killable(mm)` is only acquired *after* `check_mremap_params()` successfully returns.
> > > Root Cause Analysis
> > > A KCSAN data race arises because the `mremap` parameters validator attempts to enact an early heuristic rejection based on the current threshold of `mm->map_count`. However, this evaluation executes entirely without locks (`mmap_lock` is taken subsequently in `do_mremap`). This establishes a plain, lockless read racing against concurrent threads legitimately mutating `mm->map_count` (such as `vma_complete` splitting areas and incrementing the count under the protection of `mmap_lock`). The lack of `READ_ONCE()` combined with a mutating operation provokes the KCSAN alarm and potentially permits compiler load shearing.
> > > Unfortunately, we were unable to generate a reproducer for this bug.
> > > Potential Impact
> > > This data race technically threatens the deterministic outcome of the `mremap` heuristic limit guard. Because `map_count` spans 4 bytes, severe compiler load tearing across cache lines theoretically could trick `check_mremap_params` into accepting or rejecting expansions erratically. Functionally, as a heuristic pre-check, it is virtually benign since a stricter bounded evaluation takes place later under safety locks, but fixing it stops sanitizing infrastructure exhaustion and formalizes the lockless memory access.
> > > Proposed Fix
> > > To inform the compiler and memory models that the read access of `map_count` inside `check_mremap_params` deliberately operates locklessly, we should wrap the evaluation using the `data_race()` macro to suppress KCSAN warnings effectively while conveying intent.
>
> PLEASE WRAP YOUR LINES. thank you.

:>) Please.

>
> > > ```diff
> > > --- a/mm/mremap.c
> > > +++ b/mm/mremap.c
> > > @@ -1813,7 +1813,7 @@ static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
> > >    * Check whether current map count plus 2 still leads us to 4 maps below
> > >    * the threshold, otherwise return -ENOMEM here to be more safe.
> > >    */
> > > -	if ((current->mm->map_count + 2) >= sysctl_max_map_count - 3)
> > > +	if ((data_race(current->mm->map_count) + 2) >= sysctl_max_map_count - 3)
> > >    return -ENOMEM;
> >
> > Ack, this used to be checked under the mmap write lock.
> >
> > I'll send a patch that factors out these kinds of checks + potentially does a
> > speculative check ahead of time and then re-checks once lock established.
> >

>
> Well, the problem is that the data_race() is incorrect. It would only be okay
> if the check could fail (with no bad side-effects). Otherwise, we need READ_ONCE()
> and WRITE_ONCE().

Yeah true, also a user can update sysctl_max_map_count without any mmap locks
held obviously.

So we're probably in a state of sin generally that we've previously tolerated.

Anyway, that check seems to be wrong, so I'm going to send a patch that fixes
it, and I'll update the logic to READ_ONCE() this variable. (proc_int_conv()
already does a WRITE_ONCE()).

>
> --
> Pedro

Cheers, Lorenzo

