Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4118C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 10:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0AF46B009D; Tue,  7 Jul 2026 06:01:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1F76B009E; Tue,  7 Jul 2026 06:01:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D1A46B009F; Tue,  7 Jul 2026 06:01:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 736286B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:01:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE0DA140319
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:01:40 +0000 (UTC)
X-FDA: 84961538760.02.F940997
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id C4EA41C0014
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:01:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gOIc2B+e;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VCy3qV65;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YfKB6ADp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=irpFKmdD;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783418499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TEAbL1M0/ghnef9LV/36CqxYqXKnSdaC1uxYTQoK448=;
	b=grKTNHYl1GJkggUwXrgcG4m5KLVvxJtM917tF4PuxWcQacIEABLV8BPF1I9BGpRHlP4qHM
	q3p78K8/Ftz8ERauG5uq/Scv1MxUZXqh0wPA06RNVkuK/Cs4kpu7FXGf4WbY3/C6HqgAe9
	uHxIdNSUiKdcvJ42KvkMRGBTgTfsxXE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gOIc2B+e;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VCy3qV65;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YfKB6ADp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=irpFKmdD;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783418499;
	b=O0EZ1BaCy8NZb48NsgU6rgImdpSXeNJcDbz6Awkw8QOIJVsMbGpJ4d/zkhfQPQhWqytba4
	d9N2b+h3Axn2asSMEiPFlRXGqD5/LqkJVs1wMQMRFk+k3j3F+lM1D5s41KCn77hlNWe2Wn
	JSVmKOvrS5PvjNKMqP+GEkcDht8uY/8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3E79175A9B;
	Tue,  7 Jul 2026 10:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783418497; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TEAbL1M0/ghnef9LV/36CqxYqXKnSdaC1uxYTQoK448=;
	b=gOIc2B+eLvoLABzAqdkUuYfpzzSVVKJelO0iKAFgU1sKPX7ZaXgZQxrssdoXDTLqn8DLu/
	womM9c2JkmXvQYcNDiOH1WNxY0coxixigXjtC7411D8C8d0f4xinxV+yVV/NOf91jOHwcM
	ptyA7aKnybM9Hh6pIAeoc2hVsjgomlU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783418497;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TEAbL1M0/ghnef9LV/36CqxYqXKnSdaC1uxYTQoK448=;
	b=VCy3qV65NFPjGEJjqyiO22JkaGuFrbKz3NUhdco96BNrfu88ivbQbBamXrHPTqWb2P22G6
	EA7yLoyowm4nZJDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783418496; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TEAbL1M0/ghnef9LV/36CqxYqXKnSdaC1uxYTQoK448=;
	b=YfKB6ADpL21itX1hNy1ZEguUiw+qaVf8Ucix/wdPn+RTYlfsOUjDnfzGs7MydHP+ckmi9o
	xM5FfJwxBxKKTbyCziVI2ZM7no989EeiRYaVxU7euR+suBitdPL2ZCVV96WXslVTSy0nSs
	cgCyOxSY4FTBeoqsnUGerIrJoh924nk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783418496;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TEAbL1M0/ghnef9LV/36CqxYqXKnSdaC1uxYTQoK448=;
	b=irpFKmdDKMASxbs8FyKLRk7YXm2AoMY4WTUB3qXCxlErfpe//rLmxM/U290kRJF37ZwAz9
	dZJrpKCm31NXa+Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 82CAC779AE;
	Tue,  7 Jul 2026 10:01:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IowEHH7OTGqNYAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 07 Jul 2026 10:01:34 +0000
Date: Tue, 7 Jul 2026 11:01:32 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Leon Hwang <leon.hwang@linux.dev>
Cc: linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, 
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, Alice Ryhl <aliceryhl@google.com>, 
	Douglas Anderson <dianders@chromium.org>, Gary Guo <gary@garyguo.net>, Anand Moon <linux.amoon@gmail.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH] mm/mseal: fix mseal documentation for 32-bit kernels
Message-ID: <akzN_HNJJWBW7htL@pedro-suse.lan>
References: <20260703022507.187457-1-leon.hwang@linux.dev>
 <akeDk49-pPgUDek1@pedro-suse>
 <8f75dc18-dd4c-4989-a76c-eec6cc513ccf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f75dc18-dd4c-4989-a76c-eec6cc513ccf@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C4EA41C0014
X-Stat-Signature: brr5sixpwpcykreng9g9ximyd9k9ex1q
X-HE-Tag: 1783418498-51658
X-HE-Meta: U2FsdGVkX18M7IsoVVve1yKtHrJsJPhKrco1JsmHA+SRdZcyCKMK3fjE1sdtQq3oMPsMJ3cPgpahOlJ6G0T1WU4QcchecAnN6cMzJ8hKJYZtmTtuRk2Xzc/9UQl62PPPQlSSI03SiiayMqcJNYOAiRNZtM25Uffq38UDRpMAzWOtp02dWQa6EjgW5QmqnPwsyI6lyurkxEvwziIHaNjFTRcPF6WBh7vfNDfJymaMbvEkQ5qaQuq8sEOuuxirOqGCWX9Si/RitRgqqELudi7oagbBr2AkhbRZBDMWceIpyYqoK51n27N/UrxHh8J8EPrcpU6HRPVvTdQIq5mLxK7LKGGm3Ex+/6UkHkMkm94qJYXz6WobZA48eBX8RvJC1BaHJ9pbmI+azwVY7HzJk3POGzXVr1kR/jqq8wUYvtdreyMPpMQk15cc40LsDUjuB/ANxugmdpEL/slN75mbG06aScnmXkK+OyXv0aw7rVyjSPc5MbNu0UnWD1YS4P0gkmnQjXJgRn41IDbcssk82fyQfmvMzWkmHN7z7hiwgmraX2Peex3NvVOkaCl7yEXdXIBEEq5n9IbZ65FpoQPafPAkdFPAHaDUYRT1XyMNMNwgXsQH0T+kWHK4JB9UsroCALkqWrahE/FSNr4l/w0E8m5lAf/7LFnyrql8ss7Ns+mKTx070iE0+Bm44wDS1FVpI1yT8VI6hqpDnhPkF2FkGxiFsEFxtcUmA6Zx+DcbnXTGCm6z4FR6qAdyV+PBZp2Y0DxwS635Tqk2Fql/K67rN1gVb/yVb9Fl2eYYrdLPIYTIISg+lUTvbkU1uFeweYBBrgAOlvPLu+XvHLYOwtuTJpWV4c3lZ0e9JiaAhppgWXt1EOrASUf+ao/MP2NxOR5I97Rp9/2LLHFY6EPZ7DIrRAhAFRThOKqk0arYVkiZLOBe0nKFnAHMCntUja17CGj3xAQb0DCmCsPoBWwlhDC68qy
 UwQCi/rt
 +W3XVleMyvRJNjnd8RqR94PsDE6yTa/uTZ8fHVXnIRz7lme9jD4VOpaXpCcalrho6T7tzbSQnMkWZfCe53lhr/20O8gszeSccSAlmbFKteACbtnZN92+gJKSVjdzbQuAEIXUG/8Fe0xV6lm7pJj48tN1+rRajN6Nq4lYoAjEuAprZUGNrtmOMTOBYv5TWNzZ52zXH7lXaeO8v/L3suw8mU9iWDn1rvVA9xMc6lzHMj9Ax3SdiknGRNU/ImgsUtBFIIcrDmYmHrcmAk19EURWBgYUzY2nBXqAtG5mCdoJHNvs+PRGBRxlW/3009HNrsb38h7UOBML6bJNzNmTCYyvKUbYvjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 10:50:29PM +0800, Leon Hwang wrote:
> On 2026/7/3 17:44, Pedro Falcato wrote:
> > On Fri, Jul 03, 2026 at 10:25:07AM +0800, Leon Hwang wrote:
> >> mseal.o is built only for 64-bit kernels, so 32-bit kernels fall back
> >> to sys_ni_syscall() and return -ENOSYS rather than -EPERM.
> >>
> >> Document the -EINTR return from mmap_write_lock_killable(), fix the
> >> CONFIG_MSEAL_SYSTEM_MAPPINGS typo, and describe system mappings in
> >> terms of VM_SEALED_SYSMAP.
> >>
> >> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
> >> ---
> >>  Documentation/userspace-api/mseal.rst | 18 ++++++++++--------
> >>  init/Kconfig                          |  2 +-
> >>  mm/mseal.c                            |  4 ++--
> >>  3 files changed, 13 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/Documentation/userspace-api/mseal.rst b/Documentation/userspace-api/mseal.rst
> >> index ea9b11a0bd89..1f1cf206670c 100644
> >> --- a/Documentation/userspace-api/mseal.rst
> >> +++ b/Documentation/userspace-api/mseal.rst
> >> @@ -50,8 +50,10 @@ mseal syscall signature
> >>           * The start address (``addr``) is not allocated.
> >>           * The end address (``addr`` + ``len``) is not allocated.
> >>           * A gap (unallocated memory) between start and end address.
> >> -      - **-EPERM**:
> >> -         * sealing is supported only on 64-bit CPUs, 32-bit is not supported.
> >> +      - **-EINTR**:
> >> +         * Interrupted while waiting for the mmap write lock.
> >> +      - **-ENOSYS**:
> >> +         * The kernel does not implement ``mseal()``.
> >>  
> >>     **Note about error return**:
> >>        - For above error cases, users can expect the given memory range is
> > 
> > Honestly, this whole thing needs to be deleted. We need a proper manpage.
> 
> $ man mseal
> No manual entry for mseal
> 
> When searching "mseal manual" using Google, this doc is the first entry.
> 
> So, this change is worthy.

Yes, I agree. To be clear, my main gripe is with the current state of things,
not your patch.
> 
> > 
> >> @@ -62,7 +64,8 @@ mseal syscall signature
> >>          memory range could happen. However, those cases should be rare.
> >>  
> >>     **Architecture support**:
> >> -      mseal only works on 64-bit CPUs, not 32-bit CPUs.
> >> +      mseal is built only for 64-bit kernels. 32-bit kernels return
> >> +      ``-ENOSYS``.
> > 
> > This LGTM.
> > 
> >>  
> >>     **Idempotent**:
> >>        users can call mseal multiple times. mseal on an already sealed memory
> >> @@ -131,20 +134,19 @@ Use cases
> >>  - Chrome browser: protect some security sensitive data structures.
> >>  
> >>  - System mappings:
> >> -  The system mappings are created by the kernel and includes vdso, vvar,
> >> +  The system mappings are created by the kernel and include vdso, vvar,
> >>    vvar_vclock, vectors (arm compat-mode), sigpage (arm compat-mode), uprobes.
> >>  
> >>    Those system mappings are readonly only or execute only, memory sealing can
> >> -  protect them from ever changing to writable or unmmap/remapped as different
> >> +  protect them from ever changing to writable or unmapped/remapped as different
> >>    attributes. This is useful to mitigate memory corruption issues where a
> >>    corrupted pointer is passed to a memory management system.
> > 
> > Also LGTM.
> > 
> >>  
> >>    If supported by an architecture (CONFIG_ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS),
> >> -  the CONFIG_MSEAL_SYSTEM_MAPPINGS seals all system mappings of this
> >> -  architecture.
> >> +  CONFIG_MSEAL_SYSTEM_MAPPINGS seals mappings marked with VM_SEALED_SYSMAP.
> > 
> > VM_SEALED_SYSMAP isn't meaningful to userspace.
> 
> 
> Got it. Will drop this change.
> 
> > 
> >>  
> >>    The following architectures currently support this feature: x86-64, arm64,
> >> -  loongarch and s390.
> >> +  loongarch, riscv, and s390.
> > 
> > This is also useless, every 64-bit architecture will support this.
> 
> 
> Do you mean dropping this sentence, or this change?

This sentence (this is not architecture specific...).

> 
> > 
> >>  
> >>    WARNING: This feature breaks programs which rely on relocating
> >>    or unmapping system mappings. Known broken software at the time
> >> diff --git a/init/Kconfig b/init/Kconfig
> >> index 5230d4879b1c..12bb39f637b1 100644
> >> --- a/init/Kconfig
> >> +++ b/init/Kconfig
> >> @@ -2112,7 +2112,7 @@ config ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
> >>  	  from a kernel perspective.
> >>  
> >>  	  After the architecture enables this, a distribution can set
> >> -	  CONFIG_MSEAL_SYSTEM_MAPPING to manage access to the feature.
> >> +	  CONFIG_MSEAL_SYSTEM_MAPPINGS to manage access to the feature.
> >>  
> >>  	  For complete descriptions of memory sealing, please see
> >>  	  Documentation/userspace-api/mseal.rst
> >> diff --git a/mm/mseal.c b/mm/mseal.c
> >> index 9781647483d1..0464c7b94ab9 100644
> >> --- a/mm/mseal.c
> >> +++ b/mm/mseal.c
> >> @@ -132,8 +132,8 @@ static int mseal_apply(struct mm_struct *mm,
> >>   *   addr is not a valid address (not allocated).
> >>   *   end (start + len) is not a valid address.
> >>   *   a gap (unallocated memory) between start and end.
> >> - *  -EPERM:
> >> - *  - In 32 bit architecture, sealing is not supported.
> >> + *  -EINTR:
> >> + *   interrupted while waiting for the mmap write lock.
> >>   * Note:
> >>   *  user can call mseal(2) multiple times, adding a seal on an
> >>   *  already sealed memory is a no-action (no error).
> > 
> > And this whole header needs to be deleted as well. No one's looking at
> > kernel code for documentation (and if they are, we did a horrendous job
> > at actually documenting the thing).
> > 
> 
> Just to confirm, do you mean removing the entire function comment above
> do_mseal()?

Yes. Again, not your fault, just old gripes :)

-- 
Pedro

