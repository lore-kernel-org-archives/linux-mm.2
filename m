Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA7CDCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 21:45:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 452676B00B4; Mon, 11 May 2026 17:45:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 429086B00B5; Mon, 11 May 2026 17:45:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365DC6B00B6; Mon, 11 May 2026 17:45:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29E776B00B4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:45:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0DDDA027F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:45:01 +0000 (UTC)
X-FDA: 84756469602.03.1DAAF6A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id E6965100013
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:44:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SgfZFSsp;
	spf=pass (imf14.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778535900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3SPZ3gej12nz8tg5Np129CxuRAGPvBDQEPy/D2zlUWg=;
	b=fryZiv1GJ5BDDV/bYiYGp2QivFWq1207v3DK9skWl8UDdOiGVRzrLP8hIJXqTmyUDs+fth
	7gyn7OkZUMPoEcX8QUPtkF+Zk5+fshZbq9YY9Zw1skUB1GVrIE/aapXgbxI+U8Dl++GBWd
	eJbrwlhJpWnwzNArP545nuGC4TfyWJM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SgfZFSsp;
	spf=pass (imf14.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778535900; a=rsa-sha256;
	cv=none;
	b=M4elqptmP3MFLNlJKdu6oKpducoEJdykvcSNl3wXwlv92Z/tXoRvPGNuXYBY3C+ssxCtt4
	NYClzSCaS7HRDJjfVMmJ3UumUOlnLjkKgmitWF8XkeMjfLvSAxcpjC3aWzFGGM++YDh7X9
	EyOfik7eiZepcRXmPBtZ/AWnDNkFx4k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4782E60121;
	Mon, 11 May 2026 21:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3698C2BCB0;
	Mon, 11 May 2026 21:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778535899;
	bh=98jBSuv1F1dX3cA80ejdn4ypbeO/KR79fZk6lhmH88w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SgfZFSspXJQBAZEi4MKR/S1lYPksnxNsXmino5liB6srPrI5oH4EP+fhkljfV2PiE
	 vBj/dhVGqD2qY5f4SkONzPfkE9PevxeG4UcF5EDIuvdLTCS/E4XiOepD7S41Mp2U4d
	 7wv252PbttjBnTrJeiOLyJEg9j+w0gXattS2wGdl8b0QEY9QkPHQNTLpiI8+ScApKM
	 AV77NZrrVyTUjT6Fz5RHHMlYWzALotYVXv6gzGTbLnbRIiOFYwrvCHCIHWWc3WdkF9
	 KlhnsJQsl4EylGyBivV9Kw3CeqmORud/bwRv4YWQSUEgtt+qYXXQ2sQ+D+nImjLxLs
	 gplP2SIDnwGrA==
Date: Mon, 11 May 2026 14:44:57 -0700
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Christian Brauner <brauner@kernel.org>, akpm@linux-foundation.org,
	hca@linux.ibm.com, linux-s390@vger.kernel.org, david@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v2] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <agJN2esiIGIhUlMG@google.com>
References: <20260429211359.3829683-1-minchan@kernel.org>
 <afMnKrYT0xG_a-b3@tiehlicka>
 <afUYfpwWsUQoB9hz@google.com>
 <afhQB0CWEcflXpOi@tiehlicka>
 <20260505-wegbleiben-deshalb-f929089dbdab@brauner>
 <afoUt3te1k2TNao-@tiehlicka>
 <afowD31YsGVdVUBP@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afowD31YsGVdVUBP@google.com>
X-Stat-Signature: 45dgayx91eowzd7q6zu7gg9nwxyh1in3
X-Rspamd-Queue-Id: E6965100013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778535899-949184
X-HE-Meta: U2FsdGVkX1863e5OcyooYbBc4E3qJZJaTR9/GY95iF7c3w2pW10Yr2USIOOBui4KzmUpjd3n7BUOt+zex88FEYovSCmZILvXDo1a90Wv+X6zyB7xhLo9JrmZJkK7Wdy4kP0QFawEsQTwduN6yuX3K6VYZIMH+n9fUukAFvgWJSqpXV7Fw+83LzcRcRqo/we55n3REWTKXVkEChwYJLUNjfr8V24xzbnn8AmIkIxOn+gCoR9zqNHQNGFzstWI0IXVV+9XQwIVPtBh/84taQYIDDdJ1GqrPiX85UkZsDODdV3gOvqgTDRtO5YxbUw+guRPVlDjlmXcPQWhCDZvalI5yXTaIXccn0tHvo+R2sG86kl1NuAbI7eUYrhX1pXAP1ML1fNkpiMvZd3yKtR32+YxVuE2u7sweGsgZAtrV+ocy10Jq9jhBgg2GP7Je4rXOXoufp48andKdeeOnMnm3oMKWxnpzAZ9vTIycARZWnXkuLygwBIORRoo4UJCgTwVF/cybFKv8mxVVQQcUXJZ/9onMjF22CZ6d/hOdrenLNNbVwkOW3P2JpEgEh+K1kagPqiVY95b6laEvhBjfgLwdBeOT9y3yrutlE5RHLAjCDi3uKDkOidmYDj9qyeFzrllbODrmknQEoLzJY8H66PJ6pKNdcvY2HLuv3947PG+1EO0CVTst3Mc0tydv9EaF6DNQEYt35u+0Gm6HCsw4yY3zjBAbjOOUendLKA3gVkHKCl3FJ6AeA/2wgbeLFnaZfzY4G+IcwTueJp7ByYN6wQVMdN+HyFTwZ9Ynfb7QGdHDtanZJoFfS6GfFUgJMgdwkKBxhJO/4vq+v2HJ0L+xiG/ywlEnMVWuzOmKAOiONh6ARWugfWEpAoxn4e88b88ckqdgYLJXh/rAeuAtf8bB4aDbUNLrjAd5uTtT5YLSCz5y+gAk1vndmsnBkFuO/vY/zojAsDn18AYWOmd4/+IFfXJ5Xg
 gtvNXGyl
 PsBbopdlrRgWjoFYk8f887j2XSSSoJ75q/kygzCAtnWFV5DKcA7SKPqbTSlaOqPckUY8gzN7hAzOiEoQtbB3XXm6yBXzwkOREXC17aVxtlkLDrPg3QoCasmVOhlVYnWYWj9CmMY4846CZiLpu0VvMHXTsTZQl+3N0peO+U+vh6AaSBPIYK6PI90TNREv8nCyGJA1znYcVNIi8VnDWEmmYTWv8eLnPZEOeb9MxkqHK1MP6yUxrlPLSDAxv4pcYJpsh1DlSCTI2Je/nFyUhF1fmn5RilaDfJukHrsjH17eh9wssNW1tOr8jXD/jSWE29Lbbj0Ck
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 05, 2026 at 10:59:43AM -0700, Minchan Kim wrote:
> On Tue, May 05, 2026 at 06:03:03PM +0200, Michal Hocko wrote:
> > On Tue 05-05-26 11:30:22, Christian Brauner wrote:
> > > IIUC, then the OOM kill if invoked from the kernel just takes down
> > > without permission checking what it wants to take down. That makes a lot
> > > of sense and is mostly safe - after all it is the kernel that initiates
> > > the kill.
> > > 
> > > However, when userspace initiates the kill we need at least the
> > > semantics you proposed, Michal. You can only kill processes that you
> > > have the necessary privileges over otherwise you end up allowing to
> > > SIGKILL setuid binaries over which you hold no privileged possibly
> > > generating information leaks or worse.
> > 
> > Agreed!
> > 
> > > The other thing to keep in mind is that currently pidfds explicitly do
> > > not to allow to signal taks that are outside of their pid namespace
> > > hierarchy - see pidfd_send_signal()'s permission checking. I don't want
> > > to break these semantics - it's just very bad api design if signaling
> > > suddenly behaves differently and pidfd suddenly convey the ability to
> > > do a very wide signal scope.
> > 
> > Agreed!
> > 
> > > The other thing is that pidfds are handles that can be sent around using
> > > SCM_RIGHTS which means they could be forwarded to a container or another
> > > privileged user that then initiates kill semantics.
> > > 
> > > The other thing is that the type of pidfd selects the scope of the
> > > signaling operation:
> > > 
> > > * If the pidfd was created via PIDFD_THREAD then the scope of the signal
> > >   is by default the individual thread - unless the signal itself is
> > >   thread-group oriented ofc.
> > > 
> > > * If the pidfd was created wihout PIDFD_THREAD then the scope of the
> > >   signal is by default the thread-group.
> > > 
> > > * pidfd_send_signal() provides explicitly scope overrides:
> > > 
> > >   (1) PIDFD_SIGNAL_THREAD
> > >   (2) PIDFD_SIGNAL_THREAD_GROUP
> > >   (3) PIDFD_SIGNAL_PROCESS_GROUP
> > > 
> > >   The flags should be mostly self-explanatory.
> > > 
> > >   So I really dislike the idea of now letting the pidfd passed to
> > >   process_mrelease() to have an implicit scope suddenly. The problem is
> > >   that this is very opaque to userspace and introduces another way to
> > >   signal a group of processes.
> > 
> > I do see your point. Unfortunately the whole concept of mm shared
> > across thread (signal) groups is not fitting well into the overall
> > model. For the most usecases this is not a big problem. But oom handlers
> > do care. If you do not kill all owners of the mm you are not releasing
> > any memory.
> > 
> > > IOW, I still dislike the fact that process_mrelease() is suddenly turned
> > > into a signal sending syscall and I really dislike the fact that it
> > > implies a "kill everything with that mm and cross other thread-groups".
> > > 
> > > I wonder if you couldn't just add PIDFD_SIGNAL_MM_GROUP or something to
> > > pidfd_send_signal() instead.
> > 
> > That would be a clean interface for sure. The thing we are struggling
> > here is not just the killing side of things but also grabbing the mm
> > before it disappears which is the primary reason why process_mrelease is
> > turning into signal sending syscall (which you seem to be not in favor
> > of).
> > 
> > So I can see these options on the table
> > 1) keep process_mrelease as is and live with the race. This sucks
> > because it makes userspace low memory (oom) killers harder to predict.
> > 2) we add the proposed option to kill&release into process_mrelease that
> > is not aware of shared mm case. This sucks because it creates an easy
> > way to evade from the said oom killer
> > 3) same as 2 but add PIDFD_SIGNAL_MM_GROUP that would do the right thing
> > on the signal handling side. You seem to like the idea from the
> > pidfd_send_signal POV but I am not sure you are OK with that being
> > implanted into process_mrelease.
> 
> For 3, maybe something likle this?
> (Just to show the concept for further discussion)

Posted v3 - https://lore.kernel.org/linux-mm/20260511214226.937793-1-minchan@kernel.org/

Thank you.

