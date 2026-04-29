Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8B33FF8873
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 21:17:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DBCF6B0093; Wed, 29 Apr 2026 17:17:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B37B6B0095; Wed, 29 Apr 2026 17:17:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F32696B0096; Wed, 29 Apr 2026 17:17:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E1D026B0093
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:17:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 873ED1401BA
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:17:22 +0000 (UTC)
X-FDA: 84712854324.13.BECD562
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id EBFA3C0017
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:17:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LBceHZMd;
	spf=pass (imf22.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777497440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wWdGMrzE6g6LaiowNUCutypoTWea3j0innRZFQPj9No=;
	b=jPMaKfwzcIfSWxC4zwM/l1iILLDK0lcxP12IDFI7p5tSDjha+dx6PdLdenmJfOqZ2x+YQX
	FEvgqGc7N0VmPI/O6pYgsyyIjA8fclqMqat2mqIkGV6ApaHvZ7h/fPyDM5cwhrvcIQuNXk
	qmxsDnK5Js7LBsS4Qgc2dTVf69q4BEk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LBceHZMd;
	spf=pass (imf22.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777497440; a=rsa-sha256;
	cv=none;
	b=JxhI4zu8D+SwaDSo0HpYpRt89wUYBlVz8a7mn0aM3JqE8kz47013WXLtXep9viMxhngrwy
	l4P6AgQFeRCniR0w5yFttol+sPAkoki2q5iVLmqTcSEXYPPDdM4oQD+kewP9z+b9yeDNSJ
	lrVxX39Qtb2hZ/lN3oOXHNdObKNG0ZA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B7BE6015B;
	Wed, 29 Apr 2026 21:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8F0C2BCB4;
	Wed, 29 Apr 2026 21:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777497438;
	bh=TdYyRj0HlGviy4I5wZGb57C9BaeXuPqFVgueod/dgKM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LBceHZMd0eb0oRMr6V1OBqPnCT1BWkG0z6IfcxYo9bzwlf7+mPDWP5tkqFu+Skzql
	 /+f6rcxkCKx3MPg533htkjeIxtTGvtwdmnWPTiBN4JIlpMQGUaFvVaEEKgKQlGhzNo
	 vk/OszpRB2EFXTzqrGcYUyrWcBgZnE792RXn+WD47tvMaf3LymBH1mxobWXTDulRBQ
	 RCtPhN6o1fSoEJa9G+tkKFCLdIpbKykC1Q3jThk3z211lx2NgMJgyTVYwWuTJGUlgs
	 n3s0rz7mJOYZUYOi9cLaAaPK1ypxaNLXlavIOCHXZZpqhf/H9m/tETcSNgZahdYAVZ
	 tlEDB+mtdCZEA==
Date: Wed, 29 Apr 2026 14:17:17 -0700
From: Minchan Kim <minchan@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>, akpm@linux-foundation.org,
	hca@linux.ibm.com, linux-s390@vger.kernel.org, david@kernel.org,
	brauner@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, timmurray@google.com
Subject: Re: [PATCH v1 3/3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <afJ1XUP4udSDyNJs@google.com>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-4-minchan@kernel.org>
 <aesiYAumkLCyedf0@tiehlicka>
 <aevzbx_Pk5Cu5exa@google.com>
 <ae8KD_Tq0t7RvUy1@tiehlicka>
 <ae_dRZ95dCDTTxaQ@google.com>
 <afBbRUaGnE8WZIkY@tiehlicka>
 <afE2xchFRh2xARBn@google.com>
 <afHAi0E11D5sg_9y@tiehlicka>
 <CAJuCfpFxtbSXKabKd0G1i4WXWs2M4c4aDs4xTA0BNJB2e0P7Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFxtbSXKabKd0G1i4WXWs2M4c4aDs4xTA0BNJB2e0P7Lw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: EBFA3C0017
X-Rspamd-Server: rspam06
X-Stat-Signature: p4z6a8yjuhuwccukom33j9ohn3hd5azs
X-HE-Tag: 1777497439-334460
X-HE-Meta: U2FsdGVkX1/FG+DwLsUjn34vEiFLmOT+1BTJAkYUv05bBDLag5yXFNpRDuhJYno3xdWMlfcj3VYCL9GhNeQK9f8RnZ9/mD5omJu6CADre/DeaYthUFyIsCl4lphfSb882/klKSLmZnIg9O7F7YUpUklw5LzNE+OUUYd9WjdPsjNgjJGH2wkSC8CbGVuc9NOrCNSLQ38vqnZ+Rk63ZSh8x+Gl3jyaebmXPjed42dpg+buYG1DCNGW0jHr6HRPKjx7m58PV6GoM21VgcMIy78r60UTHcBQ7PpqSGRvvcDoU9Oz5YPhOezXEqwOKji47Bs614WXE39urRLfSKf1NzfbYYs8l77IE2J69FKA6F5SQX3JrVIkoh/2iCL0SLD5eGFvghuZYtqASfWL/IaMWu7PatNN8su9dDMGr1uf6dZT5fkOWHyD+pS+zv8UxEtc7gKjcB8TI2bWejAmFMYmFdT3is4JEtJI9DgrHUKmJ4agFCfVVEARpxbTStcSGab29tvXivWFz9CLmjEjJZj2h2a/Na72kMUdvmstPJx9uR+3RjTmMCKCeCEse+SjWEBT6I75uhvAYHT6Gc21Z9e8+KahX9WaA/1Fcv+zi67QS4OcB0EAdk+isnpbm8CjJWpXp5mBUzJ1lEcKEop+egKrDbMcTzlYExTDP458A8ee9Ut7XpPJ0ZNFiOq9819fToT3NXm496TPCoY3M3qKdndAcyqjiKPAnyBgd1X8HGf1XsVO8S+C5rfXhqvZQlTGaXSTWUjf9MD23n4h+IWope8794COEbRtYuRY2cuX6CZIBiVGe7cmX+DM2Zrw4BKsvJFsGDYFPKrpdRA0PbnbPSX0UZzHXki6bgj0b9fcxyhtMeevxgwTpJRNSuUoV5ICBMUWiaU8FXXBP6ymULCMUCYZbP8tWt52QTjfN3sx9m8nCm12l3zaYlWUHV2IXWFYbRbkOiaosbBAKx++AXPG4OA0x9w
 y/ExAUM1
 fgjIP5CL75php3wRVAMuIv1nMHKVvtmr+0617suWq4zmTa3Ug9iFYFoO/F98/1br1PaTVRbFz32yS0HmlgSvFPpStAI+wPt+nZHYDoL3tKo5dI6PoWDjIkRkN0bMmZh2NkLLP4klQx0hfEOTb0VjOJVuZnXBTcmDNu8wFVGqHbuqmX0DqUIzjJrWQBeXvoCMaz9y9D/QgT+Jv21AgAaZ10lVd2u55Z67TmNjSzj3B3oLuwOW5b55w/cKQvjjXEY/fHqwxNoP7GBMwftRkXMRS6qm5IOWmNoJb+F86IhICB7FR2Hy6Qj+7BTHdcKwyGcyWUvDF/mxWdXZY5FonhbR9u8n7o9mPgH1p0hD42Q9ruivikAV7PT9hWv7OwoMit8kEMzwoQh1cermy+CZ+0/cZmNhzIh4jMu3NIIoEPRD1qYz9D10=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 01:01:21PM -0700, Suren Baghdasaryan wrote:
> On Wed, Apr 29, 2026 at 1:25 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Tue 28-04-26 15:37:57, Minchan Kim wrote:
> > [...]
> > > >From be4bd22a100ed6be2d1d2599ddb9da04043143eb Mon Sep 17 00:00:00 2001
> > > From: Minchan Kim <minchan@kernel.org>
> > > Date: Fri, 24 Apr 2026 14:27:08 -0700
> > > Subject: [PATCH] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL
> > >  flag
> > >
> > > Currently, process_mrelease() requires userspace to send a SIGKILL signal
> > > prior to invocation. This separation introduces a scheduling race window
> > > where the victim task may receive the signal and enter the exit path
> > > before the reaper can invoke process_mrelease().
> > >
> > > When the victim enters the exit path (do_exit -> exit_mm), it clears its
> > > task->mm immediately. This causes process_mrelease() to fail with -ESRCH,
> > > leaving the actual address space teardown (exit_mmap) to be deferred until
> > > the mm's reference count drops to zero. In the field (e.g., Android),
> > > arbitrary reference counts (reading /proc/<pid>/cmdline, or various other
> > > remote VM accesses) frequently delay this teardown indefinitely,
> > > defeating the purpose of expedited reclamation.
> > >
> > > In Android's LMKD scenarios, this delay keeps memory pressure high, forcing
> > > the system to unnecessarily kill additional innocent background apps before
> > > the memory from the first victim is recovered.
> > >
> > > This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
> > > an integrated auto-kill mode. When specified, process_mrelease() directly
> > > injects a SIGKILL into the target task after finding its mm.
> > >
> > > To solve the race condition, we grab the mm reference via mmgrab() before
> > > sending the SIGKILL. If the user passed PROCESS_MRELEASE_REAP_KILL, we assume
> > > it will free its memory and proceed with reaping, making the logic as simple
> > > as reap = reap_kill || task_will_free_mem(p).
> > >
> > > To handle shared address spaces safely in the auto-kill mode, we bail out
> > > immediately if the mm is marked with MMF_MULTIPROCESS when
> > > PROCESS_MRELEASE_REAP_KILL is specified. This protects existing users of
> > > process_mrelease() from behavior changes while preventing unsafe reaping of
> > > shared memory.
> >
> > Please explain why this is a different behavior from the global oom
> > killer and how do you intend to deal with those mm shared process
> > groups. I am not saying this is a wrong behavior but it will be hard to
> > change once in place.
> >
> > > Fundamentally, this allows process_mrelease() to trigger targeted memory
> > > reclaim (via oom_reaper infrastructure) quickly, even if the victim is
> > > not yet in the exit path, while reusing existing race handling between
> > > reaper and exit_mmap.
> > >
> > > Signed-off-by: Minchan Kim <minchan@kernel.org>
> >
> > Other than the above looks ok to me.
> 
> Implementation looks good to me. After addressing Michal's comment
> please split this patch from the series and feel free to add:
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

I just posted v2 with your Reviewd-by.
https://lore.kernel.org/linux-mm/20260429211359.3829683-1-minchan@kernel.org/

Thanks, Suren.

