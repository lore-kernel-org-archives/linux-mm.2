Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49046CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 22:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 983C76B008C; Fri, 15 May 2026 18:33:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A916B0092; Fri, 15 May 2026 18:33:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8979A6B0093; Fri, 15 May 2026 18:33:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B6FA6B008C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 18:33:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF364C094C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:33:22 +0000 (UTC)
X-FDA: 84771106644.09.1AB6386
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6F3844000D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:33:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Too1pJM+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778884401; a=rsa-sha256;
	cv=none;
	b=2RuOVQeIJHLRLG9DdvMZUUIOpXbO++ttsJjc0iDSqNZ+4iJrIt2sLRa66Gst6MOkFLxUAC
	vjZQeRVNf+h0Fjpy5cpu3FFQuprRoGHCnsgAcfbzpwPY1vnWqEKzj+/JQbbnJY6M/KzgVV
	8GK/VxM7QjqCTyekHgVeexlXbHKy3TM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Too1pJM+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778884401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kXW+SmqCd7XQOnmsCPj07hBk3eYlTqnmM6X6Dx9JYEI=;
	b=PUEHL7rnH6gtT9nRkaPL05RWBKfX584jcrwSj2bPdmPXqiGgKL9UWYwFtvbJhAv9O6VexV
	JO9LO70ApM1bAuUWdRUBJov4kzY8KwaQ/zA6ec3OlymomgSR/mPRiMwj+WV9w/2LqwFq5H
	9Gps9xa/d2Y+Q2I5b/J+T0YY0I7Q1mE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D5B5360154;
	Fri, 15 May 2026 22:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EA1C2BCB0;
	Fri, 15 May 2026 22:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778884400;
	bh=6CKdBEtb3qu5B5JUYnre/tgqxseESedpaSxDYKDwlrk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Too1pJM+IoMkHbF9Efvjz++ELv7AuMkUT2Y0cl7609i8ZNO8N/TdztbdaENnilhV9
	 mZincVFX8WFHI3Azjmg9FjvLZXhEY+Y4aR+4F+JLnaEPxQXgMPsM709kXxHopf5h8e
	 G9wWGjD5IuBuuQExqgxvtCXoK2wgD1UOZt29ZL+w6hhqihi7NLJ31i9EkelCCnPQTC
	 CfxLD2DOYEfkmadv2QNHeY4xwabCwd3AuJcvZ5ea6gtLq9up5ICMcdbUSz3QKNjGEt
	 eTIYSGJtaL3MY0WjHdElbV8dYO8V/VlwgTBxK1LFuKQ2vd1rdyxWTcQA2R5QDPVNoJ
	 cqa9iR3vIYAjw==
Date: Fri, 15 May 2026 15:33:18 -0700
From: Minchan Kim <minchan@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>, Jann Horn <jannh@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, mhocko@suse.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <agefLhQeWpvil14M@google.com>
References: <20260511214226.937793-1-minchan@kernel.org>
 <20260515-nachdenken-umbenannt-a90006a46e14@brauner>
 <agd--WZpeTq2iKFW@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agd--WZpeTq2iKFW@redhat.com>
X-Stat-Signature: j94sabkxeupxm6gjwd9dbb4wf8itqzc6
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F3844000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1778884401-254992
X-HE-Meta: U2FsdGVkX1+/Mb4aED6TDuD5+P6Wm/MLGqOL4HaLXy2wPVsh3lUpTI6B9h2yMdW3md/pLatDmGSxRGMkhWtEN6oxkreHgbrPLvQvbhYFKrk89w01thZEghePzHUmnWXDFqkpFgcnCtk8ynGA/0GPmUSxp5Aw+RL4NUngbs6wcKHQZs1wX/NNBQuXC+hbER9pDVVqUwaHHz3/zbgfIF3guBim+q9HjM9c4PafiyM17LDV/lSzplnVWFDIjcAPyOWGYfsnhp/78CW6O2mEEqLIqEUgzUFxeMN4WNFOUw8ha9CUW2NKBeaib0eSAkYd3/8E6WO1aqR6wE+3PghglaYG+E4hhiwibyQgiXwXzkH1iF3NZJ/Q9Aqz2p2dsaaw4DlSOwmxqAUJkRvsRGxxNie7zgj9mVqHlAhWdo3R1pBAGa7AdcagU7b3257oyd331LnO0tWKFOXMJ7fOFm6yiGSP602sct23ZtuHI1MWxgKC2U8yd08rc4NzxKHBsA4mnwnxDBMsyj6O98xDOti1cTESjUANFqLxl+T69QFNZfuOl5sRRH/0T67c+dy+dZ4WCW0MwMl0NPmPbvc5+quHGn3tC1OXepzngurywSdOXDEI3qF8qbkSTxm/B3S1qUMD25aKgkwTLQypTG0/sWVwhZWLA1c65g8eNpvMCFm9urZihhof7K6eyiGul2do8xKpJLwOOJfaz4XkDPxDj1D/quULA2MbMb2Id4MojDKG0PC1v8HtGzxen8vgeU4ZlPSuDGCTW7ThiFMdfJUHL1h5lWxqP1aeCd/1Pc/WU4UbFQCKHOBmXuNWJrhaqqBrrXrsV119j0psMvDZfqQDW0cPPtKoU7QvX60831kSxmGMCRYuFd2hTMTsF6bu7o0UP4Vn1Ffnkf1Ng/aljUlujWaeSG4waAHqdYW5TfRBaUok6RR2XQAqqgl2CXnyAYj0O4GQSEn5Dz/ycDsw0smipaMz8sC
 NMDwtPDn
 UdXabwUjDFxZxGjc1N3JhXWRvse9/LzuUwR0GYYQW3NcGIO27H4JOfAGlReJBuuyUbBTTb0iTptkXux3R+PcyHMaO4Kb73wTF6p/NhaM+E/XlTs0jhY/qBj7XFi3BNDz7zypq2HWT0C5p7EpdjwxbNI7KM2SbP41NPocPhEQNQDlEpHfQBaRHoGameNsXxalgRgxKfzOKU96BIqAIcqXCxJZg7762scgSLzmPDlVviTZrcmSbasucOJM8Vcm2YDlcjO4Kx0ZeDNPjVO22BYCHfk2WQxC1snGncGJU83S8qoeGG4Kx789nOBrL76MsAcKKDbE98h5n1o2Z90w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 10:15:53PM +0200, Oleg Nesterov wrote:
> In fact I don't even understand the motivation...
> 
> On 05/15, Christian Brauner wrote:
> >
> > On Mon, May 11, 2026 at 02:42:26PM -0700, Minchan Kim wrote:
> > > leaving the actual address space teardown (exit_mmap) to be deferred until
> > > the mm's reference count drops to zero. In the field (e.g., Android),
> > > arbitrary reference counts (reading /proc/<pid>/cmdline, or various other
> > > remote VM accesses) frequently delay this teardown indefinitely,
> 
> Sure, get_task_cmdline() can delay mmput(). But indefinitely ?
> 
> Perhaps the changelog could be more clear? I don't see how any remote VM access
> can pin mm->mm_users "indefinitely". Even if, say, a lot of threads read
> /proc/<pid>/cmdline in an endless loop in parallel...
> 
> I must have missed something.

Thank you for the review and questions. You are entirely right that under normal
uncongested conditions, a /proc reader drops mmput() quickly.

However, on any heavily loaded system under severe memory/CPU pressure, this delay
can be long enough to cause cascading issues. Here is exactly how this occurs
and why it acts as an indefinite delay from an emergency reclaim perspective.

When memory pressure is critical, a userspace OOM killer terminates a large
victim process. Simultaneously, another process (such as a monitoring tool) is
reading /proc/<pid>/smaps or cmdline. Because the system is heavily loaded, the
reader thread on CPU C can get preempted or blocked while holding mmget().

When the dying victim executes exit_mm(), mm_users drops from 2 to 1. Thus,
exit_mmap() does not run. For hundreds of milliseconds or seconds, the memory
remains fully trapped. The userspace OOM policy sees that memory is still
critically low and unnecessarily kills additional innocent processes.

Here is the exact timing chart illustrating the existing problem and why
process_mrelease() fails in this scenario:

CPU A (Userspace OOM Killer)      CPU B (Victim Task)      CPU C (/proc Reader)
----------------------------      -------------------      --------------------
						       open(/proc/pid/smaps)
						       get_task_mm()
						       [mm_users++ => 2]
						       (Preempted/Stalled)
							          |
1. Sends SIGKILL                                                  |
2. Victim receives SIGKILL                                        |
			      do_exit()                           |
				exit_mm()                         |
				  task->mm = NULL                 |
				  mmput() [mm_users => 1]         |
				  (Memory NOT freed!)             |
							          |
3. Calls process_mrelease()                                       |
							          |
find_lock_task_mm() sees task->mm == NULL                         |
Returns -ESRCH. Reaping fails!                                    |
(Memory remains trapped until CPU C finally finishes!) <==========/

I hope thisclarifies the motivation and mechanics behind this issue.

