Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C7A8FDEE53
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 00:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2BF6B0088; Thu, 23 Apr 2026 20:08:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A737D6B008A; Thu, 23 Apr 2026 20:08:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9897D6B008C; Thu, 23 Apr 2026 20:08:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 89F776B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:08:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E0A71206B6
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:08:44 +0000 (UTC)
X-FDA: 84691513368.04.5A0B476
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 68B21A0006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:08:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LpOa89wR;
	spf=pass (imf25.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776989322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Os1EUfUO+9RFc5AzhZ0mhGnPra6wa/aa5GdZ2zZeuWc=;
	b=pa3/qU29jzkCQTS0hQrpMTlVqdlMAFx1MK653BiNc1jIMrU2IfNIlRRocp+GM7M1z+ITIk
	Tf+PIWZnrIqwUJZMSbbl+jbnd97fk3xeGfkTDvsd1G+HBhE9vX9GrBZLUrazUBwQi/Rx0i
	rOMVMwyo420yOdZIRCcLfam1lvz01/Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776989322; a=rsa-sha256;
	cv=none;
	b=arXHDiW1vhAFrGJrRV486DQ9pKPv6wruhM4OjT8r1fETW6qjHP52kkzfHsaYyVSVveqHWf
	jAQQn6HNRv8r/fV45PMK8/FvyNYnKgiyJ+JpmcrxU5btKUHsxZhdZd9M7tVOxK4hbWlAGN
	BxdQGUIu7f8ISUD1fnESDU8Q57GLXgU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LpOa89wR;
	spf=pass (imf25.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5525B60018;
	Fri, 24 Apr 2026 00:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79EBC2BCAF;
	Fri, 24 Apr 2026 00:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776989321;
	bh=+P1MRbncfPNSZCuKVTFzs10FnL8JYlgrg9/6Uyx3XaU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LpOa89wRNfFuxGL02wxiK1czOdncRvWCeNALWGXRBSKwmqLZ3l9R3n8FCxhopwRDM
	 F3OPkHZPLiF6A0X5APbB6tjJOl6bgMTf+YvzGROIB4tM+wGhqr22sgjQlgV7uruxVf
	 R9xN+m6cdNcO73fV/rbFskaObOyMOJuzb6Otll0BUm6U/TamiSJYcn6X12POuIWt4v
	 0/e10Tfe59utUINa6fGp3Wv4WoVFsf+Cnt/fwU+CI/NDwrQUiqbz7pN8acGoVAXcoR
	 4RK3HvrNWNVmzbmsOTMLM8Ut4TEVoaKU6Xa+RkWOoTdMargixKC0F4JgqNlGgXV4nr
	 myhBjTUF2aTjw==
Date: Thu, 23 Apr 2026 17:08:39 -0700
From: Minchan Kim <minchan@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>, akpm@linux-foundation.org,
	brauner@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, timmurray@google.com,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC 0/3] mm: process_mrelease: expedited reclaim and auto-kill
 support
Message-ID: <aeq0h1Tp8eO1gR-d@google.com>
References: <ad6c0DN7AGoOQ_Iq@google.com>
 <ad9AXVYxWCkHmh6J@tiehlicka>
 <aeAeqoJ_acUAza8D@google.com>
 <aeCHvYOKP1exBBns@tiehlicka>
 <aeHRLv834FCAQlQ8@google.com>
 <aeHdGf7XDjvOES1V@tiehlicka>
 <aeagUxlju40rvkYQ@google.com>
 <aenPV9ewKAzRF2Vg@tiehlicka>
 <28c3ae9f-c974-454c-b8ed-ba0ba0a5706d@kernel.org>
 <CAJuCfpEGCvuaQ43W4_bPjpoiYgmEspxV78-U4dkA2bcjfxCyFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEGCvuaQ43W4_bPjpoiYgmEspxV78-U4dkA2bcjfxCyFA@mail.gmail.com>
X-Stat-Signature: 9fmm9j4tnu1zzzkw8bgbu1o9wxbzmcuf
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 68B21A0006
X-Rspam-User: 
X-HE-Tag: 1776989322-614338
X-HE-Meta: U2FsdGVkX19IDWWA+Wzzco7PLRvejFIiVZYbGrz8zZL9WLDa+5Pdu9oHe1jyZxilrf90lPOV4EDNTvxHp7zICVpvBg5Usb7wHo5M7Si3Vr83tg3dCRYznP3/G19wd92AxXY55cWveBxT1yov5MlLJHo9EPpoougVRjlC28nmWZHZyfsDwoUDk9ZLco/5X69n98kUn4+S9h86v9IncaHF49FNNny5P4EeHPalpmuTk9V544vEGSdEzr+mvXDImVGCTJPvvmYLH/8YFriIVTK7R84o1D9U05jyagaBbHUsTwUkuIQYN71v5ddPr/i18z1/b+FEEAsC+zi5OGAc6CeDyECSNXI6CTC9Y90i46GyVAgs/kt+OfzzfXt43uDqlVAW7GSsY63TuLaUZjZbqJEJ9MKc7bEuzXBVWFHuQBaiQs0nIwL3SYljB/PuZXJrA77wYtk8DKcJpwSRDVMSuXZ7TBPwoZXV8H98ZMAx3vfXGRnlnyPRcITd3UZ5mGIqi4kfM8GOYUUunjRCZ4oXG1aCb+p3bJqLjPR5/lnGFsAqhKs6YmXo8ZZ0/i56WfWfGGFn/tg7J53v93p1iiaNdttmvr1g2IPu+hyFfeX2/kFj+EQ3OfJ6SqcIFcNwbWi/1ykC5yeE2FqGqWHMvP8y+3n9I4AggGdojMwxA7XZbmKPJqdpP2VdcQSEJ7tMmOHffJT4wl9Ifu9sU+biVfQWGlkDqfySa6IDKgOEqE6o0BOGY0Hk+pIIr1DPyu8wqE+pWpbVxCtrg8S8em/026JOAZnwtpDXMXeZpaWRScs2atosSyylFadKjVb58qh1AjpjQEprF4zO0PQTqD8ZFbUwYFFU99Y43o+SCZbV6OnawZfrwEUv/Yp1fgmu12gzbOWAFpGer9DKOeNjZNRO9EXrUUURkqP4FliiCsBkz3aOJJuuP+616JP02NTDAEBTE7T6lsMqBEDD4gZZAxbrHnXJehd
 vGX3PKNq
 d9jr6ks93BDHPoVHP0egO9fWMTDjXNtOeNICYN+WCj09//QNFM5Dm/62PqmlTVJzWTHrugA8p+G5uRJAg5bspjT7JA6Fh2kgNRnnN4GaoWj31/s8fQxAgTUmdEcPUnHaDJugPT6WWTywgTr8ScNh37G8RgQUTZg7bCTO1zFayr9HQw4Qpnt8Xc7f81XKcouRiHJhieAEn8FTAaT4wYZT18uXOvlyPH9SXpm716OTNDyVvGK9m0uMDOzGw6a46y9eaEPMu0Blv1b4J1UrJne0HdNyKSVL2DDeSE68iLSQ64TXgYDSgwp3Rb37tnbRcpzU8noHvtOQfPmufjN1ccQmJrwLTygvVSGgCWv5rqdp7WjiBYEX3usLYN+kqOyRlJc5tNR33
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 03:36:57PM -0700, Suren Baghdasaryan wrote:
> On Thu, Apr 23, 2026 at 2:50 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 4/23/26 09:50, Michal Hocko wrote:
> > > On Mon 20-04-26 14:53:23, Minchan Kim wrote:
> > >> On Fri, Apr 17, 2026 at 09:11:21AM +0200, Michal Hocko wrote:
> > > [...]
> > >>> Yes. All which make sense, really. I am still not convinced about the
> > >>> clean page cache because that just seems like a hack to workaround wrong
> > >>> userspace oom heuristics.
> > >>
> > >> I see it a bit differently. When paltform decides to kill a process
> > >> to free up memory, they want that memory back right away.
> > >>
> > >> So it doesn't make much sense for the kernel to ignore that and leave the clean
> > >> file pages to be picked up slowly by kswapd later.
> > >>
> > >> In some aspects, you can think of LMKD as a more specialized, userspace version
> > >> of kswapd. It has high-level knowledge of process priorities and knows exactly
> > >> which process is safe to kill to get memory instantly. The kernel's kswapd,
> > >> however, operates globally without this specific process-level awareness, which
> > >> makes it less suited for this kind of targeted reclamation.
> > >>
> > >> If we force LMKD to rely on the slower global kswapd to actually free the clean
> > >> pages, it defeats the whole purpose of targeting a specific process.
> > >>
> > >> So letting process_mrelease speed this up isn't a hack at all. It's just helping
> > >> the kernel do what the admin wanted in the first place: fast, targeted memory.
> > >
> > > This is a very creative/disruptive way to do a memory reclaim. From a
> > > user POV I would much rather see clean page cache reclaimed before my
> > > apps start to disappear. But this is obviously your call and your users
> > > that will care.
> > >
> > > Anyway, I still maintain my position. I do not think it is a good
> > > idea to drop clean page cache as you do not know whether there are other
> > > users.
> 
> I'm very much familiar with these issues in Android and really want to
> find a good solution for them. IIUC, this RFC tries to address 2
> things at once:
> 1. handling clean private page cache when reaping memory of a kill victim;
> 2. addressing a race between kill() and process_release() when
> process_release() can't happen before the kill() but if it happens too
> late after the victim passed its exit_mm() then process_release()
> fails to find the mm to reap. This defeats the purpose of
> process_release() call because the actual memory (released by
> exit_mmap()) might not yet be free and a successful process_release()
> would be very beneficial.
> 
> I see these two as separate issues and I'm not sure combining them
> into a single discussion is a good idea.

Yeah, they are two different issues so I tried to show those problems
in cover-letter and address each issues one by one from each patch.

I can easily drop either of them if it's not received well.
I am fine to send them separately, too if that's confused. No problem.

> 
> >
> > IIRC, Johannes raised in the past the we cannot predict the future.
> >
> > For example, if an app gets OOM-killed, wouldn't we usually try restarting it,
> > re-consuming the clean pagecache pages we would be evicting here?
> 
> Sure, we can't predict which app the user will use next, so when
> killing we usually kill the least recently used one. That's a
> reasonable strategy in most cases.
> In general, if speeding up the victim's reclaim negatively affects the
> overall user workflow then this would mean we are selecting wrong kill
> targets. In that case, we would need to adjust the target selection
> strategy.
> 
> Thanks for tackling this Minchan! I'll try to review the patches this
> weekend and provide my feedback.

Please go with second patchset.
https://lore.kernel.org/linux-mm/20260421230239.172582-1-minchan@kernel.org/

Thanks!

