Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CF5ECD4851
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 05:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7B506B0088; Sat, 16 May 2026 01:47:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2BED6B008A; Sat, 16 May 2026 01:47:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D41AE6B008C; Sat, 16 May 2026 01:47:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C22E86B0088
	for <linux-mm@kvack.org>; Sat, 16 May 2026 01:47:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25E5C140312
	for <linux-mm@kvack.org>; Sat, 16 May 2026 05:47:11 +0000 (UTC)
X-FDA: 84772199862.06.B523721
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 75CAC140005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 05:47:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MUpLo1mE;
	spf=pass (imf09.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778910429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HTkUfgfPXiHWPSKdHoICi3dW293ny4bqFNmBGAwWjC8=;
	b=gpuKrv58VGufhAlppSN5PD4rYS6myjkb1fDh1BrmoasCSFMMwX77+kYLh1bdBPWec94Zdp
	6yMUCu0iJeL36fCMaGpsvgbrLsQYUh/dTB7F+KVQsdvquREELKD6F/LdjCuy5vBORaraM4
	hJ2A41ghO3//9X5Qs29S0iruFg7AjYg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778910429; a=rsa-sha256;
	cv=none;
	b=42/XltNyt8R7f9AkYA3LK9xoYXRnKDfjk8WTWi4rI0PIChomJwoZDN/LW/qycYAy3m2zwo
	On+kqxBf27x8V+6dO2UA1J3DOKvbrrH3ChNBLyrnQO5So8oXUHgaAyJ3/IW/0+JldooBL6
	WGSPbRgi75ykQZxb11YtNTs40X5v3XY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MUpLo1mE;
	spf=pass (imf09.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BC2C260138;
	Sat, 16 May 2026 05:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E64AC19425;
	Sat, 16 May 2026 05:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778910428;
	bh=IDkuGTq3F2cfjq4A2tMmj5t/Hru33a8Gq8U2/9uYEVk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MUpLo1mE/JFhAvmQ6T2j8+UVQ/8VfAAgZ8NXh0CNdj5Pe1HMoNvm5aPL6TSp8hrbL
	 dT4mFHmSMvlayufTdon5cAt+146z+sHeABLvEvXsYr9wq0cjya0NUIlwSBA/dase6f
	 0rGdm2xf4etu2hI/gPy8nc1Tm1oRc77QDIe8i7nhfl+veelMc3pe6aD5cyNZ4n8djF
	 x1hHb48i8RVt3xlqhC3mUSLA0IU1zPmsvU2t4AACeYK+cZagXYDppvFnPW4vxjYpqL
	 2oYU7AA5z/iBA5CVCeyfH7UrpixJqi6Me0GgQCgpZcVdXnmRAUFQmR5Lvjy/rLTkFz
	 2XrdBD1gsptVw==
Date: Fri, 15 May 2026 22:47:06 -0700
From: Minchan Kim <minchan@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Christian Brauner <brauner@kernel.org>,
	Jann Horn <jannh@google.com>, akpm@linux-foundation.org,
	hca@linux.ibm.com, linux-s390@vger.kernel.org, david@kernel.org,
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	surenb@google.com, timmurray@google.com
Subject: Re: [PATCH v3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <aggE2haQ7yGeHPeF@google.com>
References: <20260511214226.937793-1-minchan@kernel.org>
 <20260515-nachdenken-umbenannt-a90006a46e14@brauner>
 <agd--WZpeTq2iKFW@redhat.com>
 <agefLhQeWpvil14M@google.com>
 <CAHk-=wiHfzbufXD2nuc9BhOVp-pYEmnVUYeThKmfZRXLU0kJ7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiHfzbufXD2nuc9BhOVp-pYEmnVUYeThKmfZRXLU0kJ7w@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 75CAC140005
X-Rspam-User: 
X-Stat-Signature: wybgwkcwjy7oun1pffr3ha8hhae85o5n
X-HE-Tag: 1778910429-192333
X-HE-Meta: U2FsdGVkX1/dQtf9C17b/apeocDRE5MMY9MG9ADhyJjZjb9Vi4+Ggm6n9T+0S5afWr+q3lBPWCbqwoaDgXxQ+Z7DxEAir8qwi371y22b9nGyWbR6deeyDfAPW0qo1lhA914by+JsmAoMvZX77zTFSzfhX38+eRKaRkG5AtYvyuk+koOhDu70r46cLaqyfHUdp1PIKa5pz5zPLYXkqpI3h/Dcwj2jOCQfVHlQDAtKvbkszoimdKCOPOErRAWiXGr4XKsW+MHKDkv5yKPRi+Ts/cwp9LpslSZI5SaYsN6WyP9JXYEQS1g/P6bQFb7D7l8eBxIVaFZC72TLgyBrM75C47efGO7lAk72ppVZL3xtcqs3t4QMhzng+P0HdtWjqo49OcayTCl7tRuusac8QNMxjdjtHj9X5G+dSfEkAtWCCavViELx+/UG3nUn0Re8/ImY0eVUbBsiGamNoy2YsB+jSQ+25SA8SfC6+vgeHkA7X27b5EhNY8QDTbJsYKuzoTt4ERlY5QtcXq33waT+eDj3UyTwrv0pdU0XA+7chXcTGtMi7Ol0LgvAJ83VMOWtgLSznVh021E5fJ0//AZ8zibFUWk6Gq+9RxDU+4DNlhpt1EZfMHMx2vNK9Np1HFgDVAGMiwhdNwqGc5OD1qw6Ff67+Lzc0Wto8J4aQUbTmIt7a07fSVc5cfgSpU4aSAE885JWbsWq/rOki1SvF20IhA4zWvCFfp3Zc5A0mcSp5A5i/cy0kF5Y4bSerLiI6sBk0iWr9UAsvZdaqyXjk53M6sOYeozuUvdHW9VumtmB5KYak7cKaD0GALZsRMTef6HoCtDVnCiFeHzZiB9yuBLBNbpStx5h20Xj1Zha4WR/AINQK9EvHOxkAv8RSiMmz9Mf/CNHwZfG3t98RdEnd4MiB1snYzIzdLRzTIrbmovMkN0c0ygQIfqAr23pInMM0F8Be2JJwUoBX1Hfn/gaFktgm4v
 1KQoKp4h
 rmfJy3fUV2Yj5idcYXf8Z5gnVVHovTMJ/nq2w+AXTwkDNVuXbBbuYylBI/HzDQ6C24HpT3EFskN5xX3tZQUDgG2/+pgOMU0B9s64nAjFR9hONRqrQ61F+yfQdY5t1Cnv4CvxR0JfSeRCut9On4CRMoeEheTBqkmxvVJI70k97q1q6JdGddvyhKlfKwAU56hRvsfpzmTK8CEXTx9EDCVEd1JbmOT50cTqdg6LuPl32e53TgH5g3aC6PWQKBVQDN6Xxv0y2ZvjzFxz21tctbRUB+3ZG1lm76SNBKkFmkZ0Kovz2Rfvtco9/DybBQ4NSLNIhKYQA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 04:45:38PM -0700, Linus Torvalds wrote:
> On Fri, 15 May 2026 at 15:33, Minchan Kim <minchan@kernel.org> wrote:
> >
> > I hope thisclarifies the motivation and mechanics behind this issue.
> 
> This still seems very hacky and a complete special case for one odd situation.

Hi Linus,

Thank you for looking into this issue and sharing your thoughts.

Regarding proc_mem_open(), it actually operates very close to what you suggested.
It acquires a reference to the mm_struct itself via mmgrab() but immediately
unpins the address space memory via mmput(). Thus, no long-term mm_users
reference is held across the open file descriptor.

The latency issue occurs during seqfile iteration (m_start/m_stop) in
smaps/maps, or during get_cmdline() and ptrace_access_vm(), where the reader
temporarily acquires mm_users via mmget_not_zero() or get_task_mm().

Because these monitoring processes or background readers often run with lower
priority on heavily loaded systems under memory pressure, their temporary
mmget() reference can easily be delayed or preempted for extended periods.

When the victim process exits, its memory teardown (exit_mmap) is blocked by
this stalled reference. Because any kernel interface acquiring mmget() can
potentially cause this delay under heavy load, the issue appears more general
than just a single file interface.

This is why I felt allowing process_mrelease() to directly acquire the dying
address space could be a clean and robust way to resolve this expedited reclaim
issue, without modifying individual callers across the kernel. I would highly
appreciate your thoughts on this perspective.

> 
> This all sounds like it's just because smap is a pig.
> 
> And yes, smap *is* a pig, but it should be trivial to just fix smap
> for this case - fix the problem spot, don't add new horrid logic
> elsewhere.
> 
> I really think the fix is to fix smap instead.
> 
> And I think smap is doing odd things. For example, it does
> 
>    pid_smaps_open -> do_maps_open -> proc_mem_open
> 
> and that proc_mem_open() takes that long-term ref to the mm. And then
> does various memory allocations - and copying data to user space -
> under that long-term ref, which is presumably what causes all the
> latency issues.
> 
> But it doesn't actually seem to *need* a long-term ref to the mm. The
> seqfile interface is designed so that it should all be chunkable, and
> the locks and refs should be done at m_start/m_end time.
> 
> And the smap / maps m_start and m_end functions already *almost* seem
> to do that. They literally look up the task again with
> 
>         priv->task = get_proc_task(priv->inode);
> 
> etc, but then they do that odd
> 
>         lock_ctx = &priv->lock_ctx;
>         mm = lock_ctx->mm;
>         if (!mm || !mmget_not_zero(mm)) {
>                 put_task_struct(priv->task);
>                 priv->task = NULL;
>                 return NULL;
>         }
> 
> dance (where lock_ctx->mm is literally that long-term ref we hold).
> 
> And I don't see why they need to do any of this. I think it's all a
> historical accident.
> 
> Because I think it could look up the mm from the task pointer every
> time, without holding that long-term ref from proc_mem_open() at all.
> 
> IOW, at open time, we could save off the "this is the mm I opened",
> but *without* any refcount, and then just verify that "yes, the task
> mm still matches". No long-term refs anywhere.
> 
> Yes, yes, we'd need some sequence counter for when the mm changes due
> to execve, but *that* should be absolutely trivial.
> 
> And wouldn't that make all of this go away entirely? And probably
> clean up the code at the same time?
> 
> I think the only reason "proc_mem_open()" does what it does was that
> it was simple. Not because it was a good idea.
> 
>                    Linus

