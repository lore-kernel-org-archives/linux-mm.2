Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACA75C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D9266B009B; Mon, 27 Jul 2026 10:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98A3F6B00A0; Mon, 27 Jul 2026 10:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89FEA6B00A9; Mon, 27 Jul 2026 10:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D8E86B009B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:28:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F40741A06A1
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:28:43 +0000 (UTC)
X-FDA: 85034787726.20.9270E3C
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3EE7BA000C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:28:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sq0VHDUf;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785162522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kkkRTdV74rQTeXkzTGoMJcqmPwizpsosvteuIcTbWAA=;
	b=ZSG8F7ycA0TGL9HXNsbahVGVeE7Li/hEpLc65QXUMU4YJAdHrAqTJlcmci9YaVPbjstx+c
	OK+prF7dGOSb3mq+SQ2RJ+NPh9+CHbpwx+KxiwqvBeFvZXGAYKNWDqYrxO1a11/WXrCXCM
	SkM9zLSugJuDH6dlbAMfG2sHIeIHgpE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sq0VHDUf;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785162522;
	b=Ztbcs31nlv1c5m8Okwrr4wbyZ1D3FRJ3LLoojtFSxWAvsuzLxXrVc+hVeXGXiXhikyjSWZ
	OutvKT7tRjru2JytUT0QXX5z+4BvIFAVhz7n1I8lwzib7YdAzrslaMgQp2k4SF11OAmcC2
	PNcTWks/hIAR67J04/tMOlGhMtnE+L4=
Date: Mon, 27 Jul 2026 07:28:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785162520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kkkRTdV74rQTeXkzTGoMJcqmPwizpsosvteuIcTbWAA=;
	b=sq0VHDUfO8mBCuDnqVS/iAsGgZNRheiKOoC7299q6YQPK9G345lofQ9RyQwQETwGq9bnPF
	ImTJlcG9yd3KB1Tzi1h+73urjzX0vbtw/eO2aa4SYHCU6OUWiBHtglYkGkv4rKFzykdRlY
	F0qcemM12BAMWiVXU0yHY2+OsE/4vL4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Usama Arif <usama.arif@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	kasong@tencent.com, qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	rientjes@google.com, kernel-team@meta.com
Subject: Re: [PATCH v4 2/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-ID: <amdn2Kcfe9owkDWN@linux.dev>
References: <20260720164207.450685-1-usama.arif@linux.dev>
 <20260720164207.450685-3-usama.arif@linux.dev>
 <amK-ApfqfwkPheC5@linux.dev>
 <32a85420-caac-477e-b371-8628ed28c428@linux.dev>
 <amOv0MlF1S-oFZHX@cmpxchg.org>
 <amdjsVuNYW98Q--Z@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amdjsVuNYW98Q--Z@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 3EE7BA000C
X-Rspamd-Server: rspam01
X-Stat-Signature: mw569hu6y71yyxuat1o14xsst868dqj5
X-HE-Tag: 1785162522-956654
X-HE-Meta: U2FsdGVkX18OIrwdmmPc4BCjAzNr+MxoG1CteL0WkZqv2EkhchKq0gA+CImt3O94T108/f6oH1fXoLCyimLvyay7OcijBeMfSu+NeB41IPMVn/5JCZoarm24YL/RrusJ+qYS/NjYGmSHTNoiYE3G7mf6y/jgiAS28Yy6vFRLgO5YdTEhDSsiERQGc0fley+jHPIfnbxDFxFawxBoVQ83numuOXUh/wXDGP54z4oQ44unnOeub5VL/RhVB58t0GQgjSpJoRKOL8Q69e60cPK6o2y0r+DG2O+BDX21KnGLFab2z6liGY3+JgE71MxOI5nohHXNS/AH0leMr3+1n8NKw+wxSXzSGdrsalRB7R8fxHjyKMHelP6Geiru81DMggAwBEDJmz73ggTFVjeJaSdNfdL2CjdC0A4ywU3gPhlMjVEOCkcC9fAz8icB+TgAJnR17a9dOmbJDhouxYF4Xmd3xNnIk1PXdbjwkQ0X0wC7OZnKoupuxJJtyGiPzI9EkynGRCduv8aVrbnXD0pAH3/hWFlasnNqiLt99uTrXPOlFMJtFEbff8rMgcGmQ+xE/rfewm8NbXVW+oomm3812AkZxx2/9Nns00W4BFzqhAzDgGY0pE7nNKLyVElYzi/cvakHRKp8IhskVIzbPDRDHtQnl/DmvH+7WFjeKQIriHkrHejoRf+7x2JETFcfb394nodY+5QcvMFCg03nZwSgIewbQfQBg6tONyBC5Wr/ZbQvcWCa3Z7BQsf58cW48Ui6mTUiX2qDX/Uza+bpSWZXQhMhvySQU1WhE0Y/x2miln8YjFVH4qxxUyuF9U0q+//URndv6wu6IT2zU99Zg9/ewsEMyR9vOlcRNvn6CrXb5fzG4WjbuFrzcSms5zzia2g4ocUUdjJfrxS95Y4QTTHUIlM45KyEmbGJh+7k/h1hW7u65ZJJgD8dtLl6TU+3Go015HsqoZnE941rg0It9GPhrVB
 FucjXi4P
 +e3bHicTuTV/dlHON5VyXp7NRSpc+f4Evygw7oVfRslCiXGx12t22ItbTx+eNWIimw1lwuku4yB9NDUC9zmpj18B3/feV2mw51FAgCeKIJirM39vNSmfZBIO+bWXKhqs2wVv5scQe+l1WPcK0JA2La4suTc/Dy4tlTaZGhdNbLSHo4DTIxCB2bwF4UqbVqZn9LNhZ+U3Tbadla1yW1anuOx88uyOyHaY29dxBuB0KVyZJ5ZLirzmO7vDBlkrOD52emR5f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 09:57:05AM -0400, Johannes Weiner wrote:
> On Fri, Jul 24, 2026 at 02:32:52PM -0400, Johannes Weiner wrote:
> > On Fri, Jul 24, 2026 at 02:29:23PM +0100, Usama Arif wrote:
> > > 

[...]

> > > 
> > > > 
> > > > The patch looks good but I have one question. We already have concept of
> > > > pgrotated through /proc/vmstat which represents number of pages we have moved to
> > > > the tail of inactive LRU to make them next reclaim candidates. This patch is
> > > > exposing pgrotate_[anon|file] to userspace. Here these metrics represents either
> > > > the number of pages we scanned but didn't reclaim plus number of pages given one
> > > > more trip in the active LRU.
> > > > 
> > > > Older and newer pgrotate metrics kind of represent something different. It may
> > > > cause confusion. Now before suggesting to change the name, let me ask do we
> > > > really need to expose these to the userspace? How exactly users can use these
> > > > new metrics? I think you can use them here without exposing to userspace. So,
> > > > does it makes sense to delay userspace exposure later when we have a more solid
> > > > usecase for that unless you have it already.
> > > > 
> > > 
> > > I do think the userspace counters have diagnostic value. They can be another metric
> > > to show how much anon/file reclaim work is spent on pages that are not immediately
> > > reclaimed, including pages retained on actie LRU. It could help explain if there
> > > is elevated reclaim CPU usage.
> > 
> > Hm, this is an interesting discussion.
> > 
> > The existing PGROTATED is kind of useless. When it's bumped:
> > 
> > - truncation fails and moves folios to the LRU tail for faster reclaim
> > - writeback ends on folio that was tried to reclaim, moves to LRU tail for fast retry

Yes PGROTATED only tells number of pages moved to LRU tail and nothing about the
why. I can see that from user's perspective the why part is more important.

> > 
> > Ok, who needs to know this? The new counters you're adding, on the
> > other hand, they capture the information you frequently need for
> > understanding reclaim behavior.
> > 
> > That said, looking closer at this one more time, you can already
> > (almost) derive them fully from existing counters:
> > 
> > drotated = (dPGSCAN_ANON - dPGSTEAL_ANON) + dPGDEACTIVATE_ANON
> 
> Talking with Usama offlist, there are two problems with this:
> 
> - PGDEACTIVATE is obviously wrong. We want the the pages we don't
>   deactivate (hot file executables)
> 
> - PGSCAN includes things that didn't work out due to caller
>   restrictions (reclaim_idx) and race conditions (tryget, !lru) that
>   shouldn't contribute to the balance.
> 
> So let's go with PGROTATE as Usama proposed.
> 
> But I'm against hiding them from the vmstats.
> 
> I'd rather remove or rename the existing one if we're worried about
> confusion. We've historically applied a much lower bar to vmstat
> stability. It's geared towards understanding detailed MM behavior
> behavior, which undergoes constant changes.

Let's keep the deprecation part orthogonal to this series. No objection from me
if these new metrics help in understanding the MM reclaim behavior. The only
request I have is to introduce these metrics as a separate independent patch.
First introduce the metrics with the detail on how they can be useful and then
later use them for the internal balancing algorithm.


