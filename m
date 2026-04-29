Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D327FF8873
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 21:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5C576B008C; Wed, 29 Apr 2026 17:16:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0D736B0092; Wed, 29 Apr 2026 17:16:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C23466B0093; Wed, 29 Apr 2026 17:16:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ADBCD6B008C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:16:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6FBC21B95FB
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:16:09 +0000 (UTC)
X-FDA: 84712851258.28.379D838
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9AF7CA000C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:16:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VGVwTUEG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777497367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cJz6Y67TYpryJ83b+i+XILsiY+XrAmu/295T8Msf5aQ=;
	b=TCjYZtpr7TESK7IJBO/D/lI+mNAj2b5JCc1rpbfK/1gN+zMMLwFCJ60cZgscet743VVr4i
	7m66tJc3ZvwBHR/MAVaFh0rYDJ16nP+LOHmWdQtYhD/Helbd/oXp3G9D6n+h5+T6cS/bXp
	/ZOMWnkVx5lAdU6Tp6XUHp/iRdWWbHg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777497367; a=rsa-sha256;
	cv=none;
	b=EQaf/VV38XKVuHCsX2BhShQGTS2pHLtiFqL9ogP0kR85rNEYKQtk9ofQWZhTh23YDQTKfZ
	ddD96tpwc4UtP5q2B28STFOBqTF+0rwuwrxKgl15DuaK9h2Uh55jyOYGvG3yrOt7mNWTQH
	KaLyoOt5tfB/hNFbRPShcjHnHwLI6X8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VGVwTUEG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FB1E440F8;
	Wed, 29 Apr 2026 21:16:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D927FC19425;
	Wed, 29 Apr 2026 21:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777497366;
	bh=eDEEz0vt3dv+Jo2Hz2ZFuyN1GgIyXSje5S5MFDCH8r4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VGVwTUEGS1sYLq/4czDmqkj7k+tgCjVAOKKbjuysUNo5fr1n85oUG07mPNLKw/mG6
	 1DUZMDZ6x6T5HHSnxIifcX8XasCJbPsVJBN+TNNI2IDzsqzaWA6Wix4tv0oMl/6+AH
	 c7fiNT3CcHXGrADyBJ2j8K1yBABpkReCNOKhjz3tcKbNYqJj3lIfBd3vdrkZ7QQ7x/
	 t3yhEccUW4Fc8H4McnljTY+srxbMB/yRSeefjcoZqHN3SYnh0IwTXBgKkN3zMooGP7
	 5Kbnld/l2izOgwcTMpAZ416pulhwHz4d9XWvkNA5+WNFf524v94bmF+RtemLvVfNfp
	 MzPN4srUOOLhQ==
Date: Wed, 29 Apr 2026 14:16:04 -0700
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v1 3/3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <afJ1FPuFy_rQgSOY@google.com>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-4-minchan@kernel.org>
 <aesiYAumkLCyedf0@tiehlicka>
 <aevzbx_Pk5Cu5exa@google.com>
 <ae8KD_Tq0t7RvUy1@tiehlicka>
 <ae_dRZ95dCDTTxaQ@google.com>
 <afBbRUaGnE8WZIkY@tiehlicka>
 <afE2xchFRh2xARBn@google.com>
 <afHAi0E11D5sg_9y@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afHAi0E11D5sg_9y@tiehlicka>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9AF7CA000C
X-Rspamd-Server: rspam04
X-Stat-Signature: pd5u484ze9rg6e8y5fabxt97jtw8xuik
X-HE-Tag: 1777497367-268050
X-HE-Meta: U2FsdGVkX1/nCq0M0q72zRWXB4EgoJI6dPixiy9gWxIo1ulxUvwHech/rKh0OYVIq/eTg2UXqktWmo+72LGSs9YsJUkmdaXvakx24wfuscQS6bzM6l4lImOKlFm/B3xxqiG6tu7kSpKTO3rS7cEDhmBdvxg+QD1wFzA7QBhtOxrmLFrZidFOQfMmHk+gIWfKenRnkk+8p4ZF+BbvI/dB+FXLjYjKs9wlwuUyxxGhavRKhTtpDgcROyhxiYu24Whujk75AyTN7v8bOL2xdCQKKmH8StC6Z61jCZU7L9EyLTx9xdlSVSHK12d4vKwOQOCG75o4H6NJj1lt3BYg4nPCJz5ZT8V1G+cXdN6htoA1crET4Tcncy8EYYBnUlWnynU02L3h09TcT1z9OK1wvu3ecm8qQYO8hQS9l5f8X/nXn1SBYDyvh0uEOP1GNOCOVLQjvSXOck5N/63Rq/3QTZhT0EzvftPhRrMcJ0I8cPwyHQZn+Q0lb8PYorf3xSdidSfdyqL9UCWaOanL4VYrVLtTwU3fFvyg7Z4CrRg8i6hBoGTW50vC4B19jDgm6aJukf69+oqZ1gULbZhan7uNAilYR0t4Cmz8lOBrWz3UMm2nqMxr2iWhsFpePmiQXVpeCenLAHsNwxejzhTRU35arCS6zaof2L43xggeq0sUWYY+Y62sdphPx6vbWfx15aY6L1DDw8QNzIV1scCVvnE+wTUAeof4doWChKr0WA9dQJ6nkDYYvXT2HMRi5CGgkd1S36loKLWjTG+L2hJ5heyc3xQSJmKg4SU8ciczxtk0RZWOGhcwKynD+y1Lhj/DaD2Ib0447TlOmks2qLS96+bCD93CCiRaIv91PDZ5WQZ1Uj2TyL2PGBQ5WrSiUL3WVWAfHcrt5Hrtr5lPmI03iN0psBETAXQJZ0r1dKIvxmL3MxY9Drri86bOxJxo6jywZEIANiP17sj3ppmRu5EhzurpYcN
 R/IZAhvA
 /7vyD+vPsmJo/QUZxKK73Dd+6e13TIYydnqVgpJ5CU53KxSQPKlRM+D/Dwi1kYp2sLfREAw+w4pqqXMD5JUB7BiOby/hN0a7jzzskkvtJD0NSVHdOb1bevDMpdy3tvqndowgHomRkc9vaTd6kGGBuXh5UjgACEIk75FaZrw7HdbZkqrj9iDY3QguCBOkBueO4e0OvkKLLG0/xSj89gYfONcWlkCs8bFtb/vtSe7RZlwJL+wjYAcFz5AG0BgC18PwnB9sbXdeUVOpZk4H2/PeyNyPQ6PP5U0Z6VJ/QUR8/BS4CAOtt2f+AaVHue6jOmOHu66wN8NnX4JU3wa7z2p4hINLpvSry1R+O9hn3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 10:25:47AM +0200, Michal Hocko wrote:
> On Tue 28-04-26 15:37:57, Minchan Kim wrote:
> [...]
> > >From be4bd22a100ed6be2d1d2599ddb9da04043143eb Mon Sep 17 00:00:00 2001
> > From: Minchan Kim <minchan@kernel.org>
> > Date: Fri, 24 Apr 2026 14:27:08 -0700
> > Subject: [PATCH] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL
> >  flag
> > 
> > Currently, process_mrelease() requires userspace to send a SIGKILL signal
> > prior to invocation. This separation introduces a scheduling race window
> > where the victim task may receive the signal and enter the exit path
> > before the reaper can invoke process_mrelease().
> > 
> > When the victim enters the exit path (do_exit -> exit_mm), it clears its
> > task->mm immediately. This causes process_mrelease() to fail with -ESRCH,
> > leaving the actual address space teardown (exit_mmap) to be deferred until
> > the mm's reference count drops to zero. In the field (e.g., Android),
> > arbitrary reference counts (reading /proc/<pid>/cmdline, or various other
> > remote VM accesses) frequently delay this teardown indefinitely,
> > defeating the purpose of expedited reclamation.
> > 
> > In Android's LMKD scenarios, this delay keeps memory pressure high, forcing
> > the system to unnecessarily kill additional innocent background apps before
> > the memory from the first victim is recovered.
> > 
> > This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
> > an integrated auto-kill mode. When specified, process_mrelease() directly
> > injects a SIGKILL into the target task after finding its mm.
> > 
> > To solve the race condition, we grab the mm reference via mmgrab() before
> > sending the SIGKILL. If the user passed PROCESS_MRELEASE_REAP_KILL, we assume
> > it will free its memory and proceed with reaping, making the logic as simple
> > as reap = reap_kill || task_will_free_mem(p).
> > 
> > To handle shared address spaces safely in the auto-kill mode, we bail out
> > immediately if the mm is marked with MMF_MULTIPROCESS when
> > PROCESS_MRELEASE_REAP_KILL is specified. This protects existing users of
> > process_mrelease() from behavior changes while preventing unsafe reaping of
> > shared memory.
> 
> Please explain why this is a different behavior from the global oom
> killer and how do you intend to deal with those mm shared process
> groups. I am not saying this is a wrong behavior but it will be hard to
> change once in place.

Sure.

> 
> > Fundamentally, this allows process_mrelease() to trigger targeted memory
> > reclaim (via oom_reaper infrastructure) quickly, even if the victim is
> > not yet in the exit path, while reusing existing race handling between
> > reaper and exit_mmap.
> > 
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> 
> Other than the above looks ok to me.

Thanks for the suggestion and reviews, Michal.

