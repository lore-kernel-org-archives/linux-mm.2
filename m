Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D375CE9D7B
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 16:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D7F86B0095; Tue,  6 Jan 2026 11:54:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF5F6B0096; Tue,  6 Jan 2026 11:54:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8A56B0098; Tue,  6 Jan 2026 11:54:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 08D0C6B0095
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:54:08 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0DE7B9D76
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:54:07 +0000 (UTC)
X-FDA: 84302136534.12.71B07B9
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id DF92A12000E
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:54:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UP1njHcx;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767718446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYDvBAzOkhTALwT3eyIczOsonUSioadjWvkMgob3zZc=;
	b=ZhD0E3+uAectXZ9tU7uLQNPXmynx+xXPtum4tXoFnhzlcz32PGr6zBcLU2iwyyX0eJcEMr
	yhx1Iqe7eh8ZQlBG4H9c26P2rvEQnKPKK6zfLArkK6u8OGNdyLgxNT5PZTngly/jkZPT9J
	22UAlukHEnYNwRX7bUPypwzE5NzIqYE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UP1njHcx;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767718446; a=rsa-sha256;
	cv=none;
	b=Ft1tszXQNMvoWfjZyWISCSt9YuBswj2R2xT1/i4PgeCq1xfQyrmSEwu6TtiYlEuA+FXJOr
	5XWFb4pz/3UBeGmGydXDuEaMmjehB3pWIrIs3IELtJPPnR92tPzrIQ9AVDPPF3otxDDy5Q
	p5owe8lE5C/H25QAm/dgwb8bPuFmz54=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-88a3b9ddd40so7176626d6.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 08:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767718445; x=1768323245; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kYDvBAzOkhTALwT3eyIczOsonUSioadjWvkMgob3zZc=;
        b=UP1njHcxEmiDWS5ktXAJFRFLuUZX6Yncj3jE9tP/D1INfDVzxpyJOZUGWry3wnlgvT
         J6EVpRbffZAtj274gCoRlSyyiZTWlN2b8cvfAallA2GOajppkvbVVhlcftMZL0Xp5KO6
         q9M49Y+ZY006RhWwlAftn6XIqxef4lA9aTJFyGkIdi20ZMQwQXjYcpa5cMNfjNZ88GwY
         DMrk/a8mim+NUxkNybyYVIiC/nmANftL55PeGpIDO7KbpHgBNnCXFA7HppSzLEdCXcKB
         iICO6yvKDk7LYD6hWhmXbwT33LnBdYV+dsf4xXKcuS3C5E/WIV6qhl1464ZZm7peKZfx
         4ygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767718445; x=1768323245;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kYDvBAzOkhTALwT3eyIczOsonUSioadjWvkMgob3zZc=;
        b=SY6Qz3X9UcC7DySOPUBkaILA9w4E4i9IYTFRpdYLxcPN0zN1D6Yk2nBR5tvkcD/S6I
         7fGhnMPRS7ooDYRwkbq9+yYO6NqzXbd+MMsVfRA4sUTZQ9T2fCWslpuonhGOlWFwSTL4
         7fioL6UhPgG1dfboH5fFgRoCFOu0QNljB4ISANO7DQRGp1JNUqwvUuwgVXciaoumme8z
         K11EW8FEjsN7t7MY6ZOmJdPx28M96vhheQq/eeQPSmMmcP2XWVF4w/smmZOZnBXsMJS3
         1la+xybM7VwcEMx3L3NZnB+o70vwJRzY4lyxgIr6lKd4D8GHM1XbeQDAWsFSDV/7lYUk
         Dq+Q==
X-Gm-Message-State: AOJu0YxH3bUbdLNLGeGDKeCj8bikouipznBu5zlNabmAourdx9Lp8LCC
	E1Ogg9TK6DDj5sitgEj4TgZ9tp3LE1IMlSqHKe+enW4n6BFy6ny2HB9YZROeDMdUOrs=
X-Gm-Gg: AY/fxX5KSl71nTcVr4lM4/SSmnPI5OsJ5jgs5gCXJ+3N6KyBAVwRwrh7+jOmhvcL7Q0
	cAFM5riG8UeSuLycBH2y411AlmGNyY4vRh4JgPQJvI7hJc2qxQHNsAOTJ8NdBXFpT8QOxs1o3zw
	mOd6zMTDYCA9ww3sY8imEWIkjsdb5mvsPB5Dkua/o9YPk3Sr0fUyqCvnrnneb+D6od9rm9EjkB0
	36F7YMn5Wwk28l1gcnt2UHDafYxRiEi+JXY6IwegM38GEwSPIAzjdtZIxk3/w/vYBoDj8vAKPz2
	0kxyjxOZ2rDGJVRIgUtS+mbOsGXcjojaPpvzhKw/+v8iiSNXNPrVrUyb+cmcYXZYHxs20VpPKUb
	2qOTbpk5IDvFD1kqlJU9cmAQNdOyoO2fRVWcSavrICSgU5LracoUvEV8kgFRRWbqrWhGvBz2qyl
	z+SbnPAL9Ge0r9iCTsQbzo6Slu5mUHsoEcImVAFykPUyFqkTGGFjjZmTq0RLnJ9DDbtUytht/M4
	EIkO5k8
X-Google-Smtp-Source: AGHT+IEi8zj6WqmI82CY2AQdJr047h5UMomuGGL/gYN5QJO+P0m+nYFAEyPxUyu5PKAelEybPRtnxg==
X-Received: by 2002:a05:6214:5786:b0:88a:442c:2988 with SMTP id 6a1803df08f44-89075e49c9bmr47967136d6.6.1767718444827;
        Tue, 06 Jan 2026 08:54:04 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770ce659sm16547896d6.10.2026.01.06.08.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 08:54:04 -0800 (PST)
Date: Tue, 6 Jan 2026 11:53:30 -0500
From: Gregory Price <gourry@gourry.net>
To: Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	david@redhat.com, osalvador@suse.de, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, hare@suse.de
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
Message-ID: <aV0-ChclC7SCrxcg@gourry-fedora-PF4VCD3F>
References: <20260105203611.4079743-1-gourry@gourry.net>
 <aV0kzBxg57Mlw8mx@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV0kzBxg57Mlw8mx@tiehlicka>
X-Stat-Signature: 5sogbam9re1pmtwqjcw486df5aeucb41
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DF92A12000E
X-HE-Tag: 1767718445-4960
X-HE-Meta: U2FsdGVkX18pQZhOvC/ST4h1QkF+DymD/+9S+ICbj+gFgnUe9jAcba2UIlr2JTXJB7Q1pdfeGWgg3EJ8VmFx++qTyd1etP7szFFz82ure6+FKoq+B2kHrggqe+5UYwoj8srVCzvSuyFz8UOVxqCpBMG5PgVHm5Rld+QcUrNKKNoNlhWj1DC4kcwDmnyOMvDbHQFWoKgAM4XqZoeCfRlPpLou+L8OuiQZihjQ2nqGbNvjSMx9Mo8bY6Y69OVd6NDLmGudFnOzV7j0Bjlg19ux5KAScOMfzyYkK/uVGzuneqN1AEMKsgobTeg6nBMhJ666EDoNToSGRnAew/qh6XrIcRhBdagiHTQBuQoSBUjZyWS1u1FCEUAd4AbpxTRnokeX8iuLIHyG5XzA5UT0c5foonuYGwIxm/QQSo1sqBdIue8BMYp3h0/wNBVw5nt2WadSWMc2qYRFTD3T9gjiqOdOsuuRUf/MVoOyxEZhVvhnm9kgthm/HslE7F/AJrzsnXCKa3Tu5PmoAq3f26pqk3LHKjPSlUS3Sb/BTg8V0jCjXnfMRsr4ZMXh9i+IA4Aa5VVtXjdbxOkzU0u5ehV0E/Tz16yx0ZMkEs1gOYuQZ87Q2dkpTGQCBM0fcZiv7dHYkvGVgd1YwuGsfUU/EMzN4otizh7hBBvZuFHDBcLXeaMwZj8Que72VqSq0d5ggU9vLIb9wyPsjRMR3K/eLirmhH7NCSsBo3dJhHdWyZxsc24m4lm9ZqeSS7KIq+ZD4YUYcn95Qzlo8wmCIjgOHWBUOoq4YcsNwBNNCifT4/wQ1uaaMLvD9INeV2NNZ9pNlukdZFto3tAstqr3Yn2Z6aYFqisol1xZF8A2G7wcssfvUEcpDL0IYdxKh2WgFD5QmldpHC6oFLaEDewgJt1FkhV+rhJjBUWO5HIVBMbdwJN9JyodsWrM5NgrMQnhBnKmkp0xkimpmDbLORKkhWVRjW6+Cik
 rn00UQrb
 2/yFwkZBtEpH7uEyxTVL1x/auMw5i9jIV4mvD1GjsdWxrMy8rYpG4RCLkHRR/5J2+Mq7Fm31izrc1TcdMOSt+1NQb3M4VvjnlT1OvWcI6S22uOa2+diYWa+fVU1G1ImP2BOnLMLOMdrZt5yBYM6s9efnF6BLH9ZBpmTizoszqS5MPQn9viFwB2HpyWITiYxzEd2AwWQ44pXmYL0CTDM1BDZzLzVB2UANgpdTVzTHWOksBsfXNFuMFrlbHyYNCxWHPOz5e6JjYv1B6gA7yjVXNeqfJHYX0dpommQibsK8y2UrYpJLQ16OK3r1jeqXATrj4TP6td5RaTTRh9rJjQrFz96YjBQ7JNdHtvLrnPMwN8mOrY0OZcgefchCefw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 04:05:48PM +0100, Michal Hocko wrote:
> On Mon 05-01-26 15:36:11, Gregory Price wrote:
> > It was reported (LPC 2025) that userland services which monitor memory
> > blocks can cause hot-unplug to fail permanently.
> >
> > This can occur when drivers attempt to hot-remove memory in two phases
> > (offline, remove), while a userland service detects the memory offline
> > and re-onlines the memory into a zone which may prevent removal.
> 
> Are there more details about this?

The details are with Hannes, I was just recapping what was described in
his devmem talk at LPC ("To online or not online").

> 
> > This patch allows a driver to specify that a given memory block is
> > intended as ZONE_MOVABLE memory only (i.e. the system should try to
> > protect its hot-unpluggability). This is done via an MHP flag and a new
> > "movable_only" bool in `struct memory_block`.
> > 
> > Attempts to online a memory block with movable_only=true with any value
> > other than MMOP_ONLINE_MOVABLE will fail with -EINVAL.
> > 
> > It is hard to catch all possible ways to implement offline/remove
> > process, so a race condition here can clearly still occur if the
> > userland service onlines the memory back into ZONE_MOVABLE, but it at
> > least will not prevent the removal of a block at a later time.
> 
> Irrespective of the userspace note above (which seems like a policy that
> should probably be re-evaluated or allow for a better fine tuning) I can
> see some sense in drivers having a better control of which zones (kernel
> vs. movable) can their managed memory fall into.

Hannes pointed out that this is some default policy on one or more
distributions, which is quite annoying.  Obviously a kernel change to
fight against user-policy is not great, but trying to prevent
hotplug-intended memory from being onlined in hotplug-unfriendly zones
seemed like a pretty straight forward improvement.

> 
> That being said, rather than movable_only, should we have a mask of
> online types supported for the mem block?
> 

I briefly considered this.  I went with this for RFC-v1 since it's
fairly simple and because movable is really the only zone with hotplug
guarantees (any other zone makes no hotplug guarantees).

It's also significantly more complex of a change for questionable value,
but if people see this as the way to go i'll happily pivot to that.

~Gregory

