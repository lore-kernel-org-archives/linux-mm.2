Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F11F7104BED3
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 10:27:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 163FE6B0089; Wed, 11 Mar 2026 06:27:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1123D6B008A; Wed, 11 Mar 2026 06:27:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010506B0092; Wed, 11 Mar 2026 06:27:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD5DB6B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:27:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3923E16075A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:27:38 +0000 (UTC)
X-FDA: 84533405796.26.8BC8E14
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id DFEA7A000A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:27:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VG9BgjAW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="FwYpY/vD";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VG9BgjAW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="FwYpY/vD";
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773224856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7JVKw+h9h91qN6HVFfeNkgvKaRxr6Sxa9MBTvyH7vIU=;
	b=2da24I0s1NtTWX8g2hgS5FkqzPmZYilO5jQDUV7jPxOhlOxzEGv6slRJkW9rgcv+yjnimg
	2b/6cv/pux/MaPe3R2louea1Q0T6mcrS9lfoNPYHx+0jlayWJDQ2FKXpHibOCJ4IaJoE4u
	oCydp8G/toBKmvw1nNixVOrqOmbRi0w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VG9BgjAW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="FwYpY/vD";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VG9BgjAW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="FwYpY/vD";
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773224856; a=rsa-sha256;
	cv=none;
	b=o0mNAlP1JGukUqt0L1cjXT0Gf4Eos3Gco6hoJmM5PxvKeRHZ4M3ZcazJ+kws582cZr6hXX
	KkA5IQ4vKEmgdCq5N5dErQjOstWx/k4WA8VkQPKE5fzMHYpMLn1Lux8t4qJW1KtATz2QGP
	l8n55DuWB8ckCtFLD6eECKq0kVXuUrA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4F4543F8EA;
	Wed, 11 Mar 2026 10:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773224854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JVKw+h9h91qN6HVFfeNkgvKaRxr6Sxa9MBTvyH7vIU=;
	b=VG9BgjAWtahbViaxEfA0R9d6BdnlS80Mpn6iJtDoqvmFMFgZ3tmE3abONAheRrjl5t06bJ
	keTMeiVIr9BuxCQtygQa6Eo8e2QxUfFitEuxA11DYm5FU6KAkcxawYJoR0GDRYR1NrELdc
	8duNy5QPm6mza8sFwg8qQyM5aW2HYW0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773224854;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JVKw+h9h91qN6HVFfeNkgvKaRxr6Sxa9MBTvyH7vIU=;
	b=FwYpY/vD2E02UkqTBNhbKsZMl/MjP2Fx0XvV7htou3UVEStmHUMwEW2i8zPvrrMR/7C9a0
	Hu1Cx2DrJGYq50CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773224854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JVKw+h9h91qN6HVFfeNkgvKaRxr6Sxa9MBTvyH7vIU=;
	b=VG9BgjAWtahbViaxEfA0R9d6BdnlS80Mpn6iJtDoqvmFMFgZ3tmE3abONAheRrjl5t06bJ
	keTMeiVIr9BuxCQtygQa6Eo8e2QxUfFitEuxA11DYm5FU6KAkcxawYJoR0GDRYR1NrELdc
	8duNy5QPm6mza8sFwg8qQyM5aW2HYW0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773224854;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JVKw+h9h91qN6HVFfeNkgvKaRxr6Sxa9MBTvyH7vIU=;
	b=FwYpY/vD2E02UkqTBNhbKsZMl/MjP2Fx0XvV7htou3UVEStmHUMwEW2i8zPvrrMR/7C9a0
	Hu1Cx2DrJGYq50CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B15783F982;
	Wed, 11 Mar 2026 10:27:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rNvjJ5VDsWmfFAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 11 Mar 2026 10:27:33 +0000
Date: Wed, 11 Mar 2026 10:27:32 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Jianzhou Zhao <luckd0g@163.com>, akpm@linux-foundation.org, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: BUG: KCSAN: data-race in do_mremap / vma_complete
Message-ID: <u7wzfkse7au4aganufewx2ykz5xg2lgzaf2eu3tfkmowcmsobb@4xubw3ikany2>
References: <1a7d4c26.6b46.19cdbe7eaf0.Coremail.luckd0g@163.com>
 <abaad620-bc19-4a3b-9bef-6a1ad4335ce3@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <abaad620-bc19-4a3b-9bef-6a1ad4335ce3@lucifer.local>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DFEA7A000A
X-Stat-Signature: qxfti1f18pp3o86rtyqzm8eb9a8k474s
X-Rspam-User: 
X-HE-Tag: 1773224855-352013
X-HE-Meta: U2FsdGVkX190zT5UCOGBSj9hLWZISkU4fyZ6vtvIneWQLR3jxNEHvN1ljRuPIicHskRi6LYl0P8QwPqPq5n4eDjLOZ76S7SOOvh8A1OFai8ZdshhoJhhQKx4dD8Z89c+v6OLgb1zdK2aNSabPpLYY5oSdSxMhZBiY8KgUc9CBc1iKRw5Gur/r/tTUGS+yhR+SX03xQIW7aIoVXDXIG7GaszXs/FuuSGtAwjkGw4aBaeZ9CQo784M31Yrflu+tKnJ0vDf18S7VaefPiyHhIn1SM6ilE+udWbMpjUoR8o4Jdb7g9EIZCIYYhb8w5O3mZbouR02aMPuDSJUS0aqhpEOGZWSZ1++LIqG6YqBOcHN14GgRxQ+1aQEYfOMI3kMw8N/791aXwqvX67xDldFyt/9GpkTMGeWrl1mzZz46q42qxT00nkeJzxP3l/YMC0WRkVnFaw5tpuVIOdq0UUUIMsBOXEM6IXGa81uUdScpMuJAfBgMP4UI/Ca/SbtM2y55MGhznakEBGdloj5ER+5mqoFWny7ghOvPQ9kXiCpj+8imF9tw6qEiDfclUZKdARk405ABMtLnLkTp84VBW07otYdBy6dwpllt0lO4yJ+qPxXOiRppnO9iuWrFS/BTtgwKvGd/30TujuCD22y7mwf3A4RaiwbvKipjlFzWQGOibKEBopqI4HUN8WjUm1fRNbF6BKb2cFVeYl43rhdzg2VDPSwFBHdyO8zopIk6JXNC/IP2Df6xFLLESZSMZOHNyLVBI3Fzt81A6sY+UjxP+EhyOKVl5Xpy16AIWECTPsN6oL1mL4TJl1wsqEA08hacRpXJuokwY4BQ/GR4RPNCD/XMJVnsW/KiFsYpD7fKLR7UN9olUf6EeLybKIzayoAGJX+B+e2Wr7HHqm5+ORNkNQiT8soSyIM2RUJ8L2nUIYFLYsC7d9JN4S8lN+FqFDDpF2kkm/0GLbCAAkE6N+DZHyOr/8
 oipCskn8
 jiqup5rNeJR1+fIFr7mvl2o/pxQgkSiZUc0g6pwCtRWCEvt19hQAlJzyrRUJQ0+IMJCF0Z/abKYvlp1p5meVC91eR3TwFL0sQV0UsaTsYR+1fmkPnitBYAwxbcMJINxEccYxNWnLLQY/kSBljLrscDkxqawN8UkhvhWDcpQaQYOVlOb2BFUiwVHoQVwNdckqHrZRF5cIqKuJUIZFEkdgUyLbarCzJ1LDmRyBYan+b/6MAcnnJcPwQydsQSacyqoX/XIo6+VZ5TK2Mk4XeavE6+fOVTTNGTHMAwYCHpX4zhr98+OkcJurjU0h38HNLg7RE0opUC5ccfjFgM/SBGk7uA777DiHUQy9D2aHZcM6exu/EGMFV7VHyPbnVEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 10:11:20AM +0000, Lorenzo Stoakes (Oracle) wrote:
> (Removing incorrect mail, I know it'll take a while to propagate the mail
> change :)
> 
> On Wed, Mar 11, 2026 at 03:58:55PM +0800, Jianzhou Zhao wrote:
> >
> > Subject: [BUG] mm/mremap: KCSAN: data-race in do_mremap / vma_complete
> > Dear Maintainers,
> > We are writing to report a KCSAN-detected data race vulnerability within the memory management subsystem, specifically involving `vma_complete` and `check_mremap_params`. This bug was found by our custom fuzzing tool, RacePilot. The race occurs when `vma_complete` increments the `mm->map_count` concurrently while `check_mremap_params` evaluates the same `current->mm->map_count` without holding the appropriate `mmap_lock` or using atomic snapshot primitives (`READ_ONCE`). We observed this bug on the Linux kernel version 6.18.0-08691-g2061f18ad76e-dirty.
> > Call Trace & Context
> > ==================================================================
> > BUG: KCSAN: data-race in do_mremap / vma_complete
> > write to 0xffff88800c232348 of 4 bytes by task 27920 on cpu 1:
> >  vma_complete+0x6d2/0x8a0 home/kfuzz/linux/mm/vma.c:354
> >  __split_vma+0x5fb/0x6f0 home/kfuzz/linux/mm/vma.c:567
> >  vms_gather_munmap_vmas+0xe5/0x6a0 home/kfuzz/linux/mm/vma.c:1369
> >  do_vmi_align_munmap+0x2a3/0x450 home/kfuzz/linux/mm/vma.c:1538
> >  do_vmi_munmap+0x19c/0x2e0 home/kfuzz/linux/mm/vma.c:1596
> >  do_munmap+0x97/0xc0 home/kfuzz/linux/mm/mmap.c:1068
> >  mremap_to+0x179/0x240 home/kfuzz/linux/mm/mremap.c:1374
> >  ...
> >  __x64_sys_mremap+0x66/0x80 home/kfuzz/linux/mm/mremap.c:1961
> > read to 0xffff88800c232348 of 4 bytes by task 27919 on cpu 0:
> >  check_mremap_params home/kfuzz/linux/mm/mremap.c:1816 [inline]
> >  do_mremap+0x352/0x1090 home/kfuzz/linux/mm/mremap.c:1920
> >  __do_sys_mremap+0x129/0x160 home/kfuzz/linux/mm/mremap.c:1993
> >  __se_sys_mremap home/kfuzz/linux/mm/mremap.c:1961 [inline]
> >  __x64_sys_mremap+0x66/0x80 home/kfuzz/linux/mm/mremap.c:1961
> >  ...
> > value changed: 0x0000001f -> 0x00000020
> > Reported by Kernel Concurrency Sanitizer on:
> > CPU: 0 UID: 0 PID: 27919 Comm: syz.7.1375 Not tainted 6.18.0-08691-g2061f18ad76e-dirty #42 PREEMPT(voluntary)
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> > ==================================================================
> > Execution Flow & Code Context
> > In `mm/vma.c`, the `vma_complete()` function finalizes VMA alterations such as insertions. When a new VMA is successfully attached (e.g., during splitting), the function increments the process's `map_count` while holding the necessary `mmap_lock` in write mode from the calling context:
> > ```c
> > // mm/vma.c
> > static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
> >     struct mm_struct *mm)
> > {
> >  ...
> >  } else if (vp->insert) {
> >   /* ... split ... */
> >   vma_iter_store_new(vmi, vp->insert);
> >   mm->map_count++; // <-- Plain concurrent write
> >  }
> >  ...
> > }
> > ```
> > Conversely, the `mremap` syscall validation sequence preemptively evaluates `check_mremap_params()` *before* acquiring the `mmap_lock`. This allows dropping malformed syscalls fast but leaves the map quota check unsynchronized:
> > ```c
> > // mm/mremap.c
> > static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
> > {
> >  ...
> >  /* Worst-scenario case ... */
> >  if ((current->mm->map_count + 2) >= sysctl_max_map_count - 3) // <-- Plain concurrent read
> >   return -ENOMEM;
> >  return 0;
> > }
> > ```
> > At `mm/mremap.c:1924`, the `mmap_write_lock_killable(mm)` is only acquired *after* `check_mremap_params()` successfully returns.
> > Root Cause Analysis
> > A KCSAN data race arises because the `mremap` parameters validator attempts to enact an early heuristic rejection based on the current threshold of `mm->map_count`. However, this evaluation executes entirely without locks (`mmap_lock` is taken subsequently in `do_mremap`). This establishes a plain, lockless read racing against concurrent threads legitimately mutating `mm->map_count` (such as `vma_complete` splitting areas and incrementing the count under the protection of `mmap_lock`). The lack of `READ_ONCE()` combined with a mutating operation provokes the KCSAN alarm and potentially permits compiler load shearing.
> > Unfortunately, we were unable to generate a reproducer for this bug.
> > Potential Impact
> > This data race technically threatens the deterministic outcome of the `mremap` heuristic limit guard. Because `map_count` spans 4 bytes, severe compiler load tearing across cache lines theoretically could trick `check_mremap_params` into accepting or rejecting expansions erratically. Functionally, as a heuristic pre-check, it is virtually benign since a stricter bounded evaluation takes place later under safety locks, but fixing it stops sanitizing infrastructure exhaustion and formalizes the lockless memory access.
> > Proposed Fix
> > To inform the compiler and memory models that the read access of `map_count` inside `check_mremap_params` deliberately operates locklessly, we should wrap the evaluation using the `data_race()` macro to suppress KCSAN warnings effectively while conveying intent.

PLEASE WRAP YOUR LINES. thank you.

> > ```diff
> > --- a/mm/mremap.c
> > +++ b/mm/mremap.c
> > @@ -1813,7 +1813,7 @@ static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
> >    * Check whether current map count plus 2 still leads us to 4 maps below
> >    * the threshold, otherwise return -ENOMEM here to be more safe.
> >    */
> > -	if ((current->mm->map_count + 2) >= sysctl_max_map_count - 3)
> > +	if ((data_race(current->mm->map_count) + 2) >= sysctl_max_map_count - 3)
> >    return -ENOMEM;
> 
> Ack, this used to be checked under the mmap write lock.
> 
> I'll send a patch that factors out these kinds of checks + potentially does a
> speculative check ahead of time and then re-checks once lock established.
>

Well, the problem is that the data_race() is incorrect. It would only be okay
if the check could fail (with no bad side-effects). Otherwise, we need READ_ONCE()
and WRITE_ONCE().

-- 
Pedro

