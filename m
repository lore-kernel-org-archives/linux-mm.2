Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A931FFD45FE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 00:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04A786B0089; Wed, 25 Feb 2026 19:52:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29DC6B008A; Wed, 25 Feb 2026 19:52:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56DB6B008C; Wed, 25 Feb 2026 19:52:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D21D66B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:52:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8BF138B428
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:52:52 +0000 (UTC)
X-FDA: 84484782984.20.EE21A3A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id EDB1014000F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:52:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="c9C/JA8k";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772067170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zOMswypu13iHA8fPia/+mARPHYa3k+gdSAOjdGOi5F4=;
	b=2dAl9OKuOhyXw6mA2oh22obIuyRVdmBWczGP5Tx4w04fyuHl7TgNHmJ3AKkEF3Rx3VIOtf
	WOrdtGr52R8gUyFqA8veYwIiiF9sFy2LK7ce+p3aW46FDKWppt9arLgV23dbdUfICalhgY
	lv1DxgHVUDmpen9Up0N9QaALz36bi7E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="c9C/JA8k";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772067171; a=rsa-sha256;
	cv=none;
	b=ro6mMtoDk4pEMbItddAgNwTQ+tP2ZJ0dTf1JK/WT26BfAq1o+0kqrkLMn0AJQbb2xnz0Hl
	6dLg8bCmJnUxy4Sqog39RU41Qj0rHCJ9geI5uTtRCUUwU+GTzNu2E7C1Pxq3j+ugKnu7yu
	Cp18h7PTCs4vQW54Rjb+48oOPJ4DWYc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 61A7E60054;
	Thu, 26 Feb 2026 00:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2624C116D0;
	Thu, 26 Feb 2026 00:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772067170;
	bh=Cs5Jm3HGPSduoOsafr2sYMh+UobQrLK7pbo4l8qpA4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9C/JA8keNo5dB5zBrxnSwiYNiGwKRHlCouM0r7PngXbLQH2FoyYSC8tRczvSY3R0
	 PVspcWf1Ycx6P+wfrr4p0wGamBWB0lWFFNd989WSY2twUlrBSFtmjHPI+oVmvTWlvx
	 tz40Qo62xTmHblU0sQPS1lrrX3gCeGRrbMNEpbFlW8+T5q+B4B8HQs62Iducm/NLgC
	 PJImODa93xoCDabAOZ/WWydx69edleVhwND6Wmh/jHwtj+MuKiHdkLGxusgC3qyg6g
	 lwHxjy3gx3WibprScbsJa9hD73qxwixYNmqEGCCIXi4GloXsDFwTKo+1TEl1sCY8Q/
	 d5Tn9mdcEMWxA==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH v3 0/4] mm/damon: Introduce node_eligible_mem_bp and node_ineligible_mem_bp Quota Goal Metrics
Date: Wed, 25 Feb 2026 16:52:46 -0800
Message-ID: <20260226005248.7509-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y17HPOxpLF41+Jn-fHqu7s4YUzgsFKdhD9MsN=wCop_kRw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bnfajudug8oekqwnxxeso6yexsdujnuz
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: EDB1014000F
X-HE-Tag: 1772067170-551177
X-HE-Meta: U2FsdGVkX1/6XftofMhwRz99gMe2GjB8GLEZZLAokWG5vJGpyhkG0HIWty2/XZhayqDIunJhCelcRGqkVQ9Hk9KCDyArdvbZAQSz27P6fcBtGqsZVz+hQ/3w78ux+GIJ8rAqD8bXeDljUpws0lOZiMyZ2GKqJVrYNlBp/cY7w3C/GVJn0ZQRtlxn18ACXT4Co7uLrg+VMIIJ5HryNjDHSoIHbpRVc4czN4ecLZsiumfSkWWHMi8PZkO03b2cFpGCGA/c0gZG7lctjENu3pWx3BCKitSjYW/lu/h6q/XAFSVIR2E/AiI7/QNoqYABq/u3UCkq03Z0ThVH4+EysH98HD2dOpL1xlZGPDtl5Sfa876fvFWvdeUCiwb7pnfI2F8TzRxe0yID60kIn5GwicAd2DtnTf1qDjH3dZ4xSH1aJ2kKJeU31fCo1gHfSZmm8mILP6mMpGxaox8V/NZjKp50Nw+r0AvdAWcpifluaMO15j2VH1Ghsk8UFxez77lRFMtsgKASQNbEyLsOoqnX0bjzzPaDu2wwBQJVrjKTqwfRU0l7ZtTKydDqfhH79zqMnzMWTy6CAPB19FFUVCWlfmtsMqUeAzb/PFVKfrfkjeL61fDvsBXXNvw4THM1PNSYGOlXMvQv9gqxuk87I4tTlGG+OWLXhdSdcAO+RnWAPD/DXySdcTEBQRff1W5qmVVltrmY17ZF1YvMDmiZVVlDrIKG+Df2iINK/OekWMu5b8AMSeGylf+79kYW9uyhfC5nM2xOBxYW3zHQsVP2hYaJbZqJVnOgc0RmA1GgoPIdnvJ+rnYC7QxPUeupO69a3F8pgoL8utJODH/dJz2vcDLYhvNt1EAxuI9oHQ11XyhNOzHLENeLH9VkV2XplMT1gv9ktCIfjBR7sveX1nzk0L4S176eNWvkx/WP2hpaFJJQkf3h9ZKrFW3ihh1HfCeczqyb7noVKW5s3Ekns7mgqNauBSi
 oIjs6f5y
 Mp7Bnnfs1lKpASZx/8twmScpIYPBVMVKM7Uh0VllRgptfwRaEdolwVuhVKQh3ox5AXUwVU4p2FdgyAeuQVIt8CL8x4JnfZO66CntO07L+K/WtPlVn8x+3uEN1TKpMHtnJI9pax0uTZXKIY1GByDDEg47b0iT2b4kaH6IUbHm0w2vEPRYCdptcL8/fs22Z3/XqUOSaLA112hsxRfKhLRFsg/vSHCWTI7SKrfQU8PuEj6k9ytjGneCBbqX4As8vYgIK5gMVvdQ6q5hH/q7KMmxfABuLZZVBZ39D9ER/vL9luws2EgdYh8ZLZ0YUaHcncJcmHsXI5V6oCd+GWQZWpjvwzsn/99+tB6f0lGfh3BEaYfWmwSBm/3hhoBOE2raeuViyV330XwdFQ2IoobNmwHc+5lv/q0HjUJxKmxac
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Feb 2026 10:19:11 -0800 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On Mon, Feb 23, 2026 at 9:36 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > Hello Ravi,
> >
> > On Mon, 23 Feb 2026 12:32:28 +0000 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> >
> > > MIME-Version: 1.0
> > > Content-Type: text/plain; charset=UTF-8
> > > Content-Transfer-Encoding: 8bit
> > >
> > > This series introduces two new DAMON quota goal metrics for controlling
> > > memory migration in heterogeneous memory systems (e.g., DRAM and CXL
> > > memory tiering) using physical address (PA) mode monitoring.
> >
> > Thank you for keep working on and sharing this :)
> 
> Thank you for the detailed review!

My pleasure!

[...]
> > > - Added PA-mode detection lag compensation cache (see dedicated section
> > >   below for design details).
> >
> > I'm not very sure if this is really needed, though.  I'll leave comment on the
> > dedicated section below.
> 
> Understood. I consciously separated the cache implementation (patch 4)
> from the core metrics (patch 3) because the cache is ONE possible approach to
> handle detection lag - not necessarily THE approach. My goal was to share
> what was needed to achieve equilibrium with my synthetic benchmark
> workload (multiload),
> while making it clear that the cache mechanism could be dropped or
> replaced with alternatives.

That was indeed helpful for reviewing, thank you!

> 
> >
> > >
> > > - Added fix for esz=0 quota bypass that allowed unlimited migration when
> > >   goal was achieved.
> > >
> > > - Added fix for goal_tuner sysfs setting being ignored due to
> > >   damon_new_scheme() always defaulting to CONSIST.
> >
> > Thank you for finding and fixing these issues in my previously shared RFC patch
> > series!  I left a few comments to the patches.  In short, the second fix looks
> > good and I will add that to the next revision of my RFC patch series, if you
> > don't mind.  For the first fix, I'd like to take more time on thinking more
> > cleaner solution.
> 
> Sounds good. Please go ahead and incorporate the goal_tuner fix into
> your series.
> Happy to test whatever approach you come up with for the esz=0 issue.

Thank you, I will do!

[...]
> > > In PA-mode, when pages are migrated:
> > > 1. Source node detection drops immediately (pages are gone)
> > > 2. Target node detection increases slowly (new addresses need sampling)
> >
> > I agree.  And this is not what I clearly expected during the previous
> > discussion.  Thank you for sharing this issue.
> 
> I'm glad this observation is useful. It was something I discovered during
> testing that wasn't obvious until I looked at the trace data closely.

Thank you for sharing the pain point.  I recently added a few more DAMOS
tracepoints motivated by our offline discussion.  I'm planning to add better
supports of those in DAMON user-space tool.  Knowing this kind of pain points
is essential and useful at improving DAMON, thank you!

[...]
> > I will leave more comments to the patch implementing this.  But this seems too
> > much at the current stage, unless there are clear test results showing its
> > needs.  I'd recommend proceeding without this, and later revisit if the problem
> > becomes clearly significant.
> 
> I agree. Let's drop patch 4 for now and focus on getting the core
> metrics merged.
> The cache mechanism can be revisited later if real-world usage shows
> it's needed.

Thank you for flexibly accepting my suggestion!

[...]
> > I'm yet to further reply to the fourth patch, but I hope my comments be worthy
> > :)
> >
> 
> Very much so! Your feedback has been invaluable in shaping this work. :-)

More than exciting to hear that :D

> 
> I'm currently on a break and will be back after March 10th. Once I return,
> I'll send the updated patch 3 and share test results with CONSIST
> tuner.

Sounds perfect, I hope you to have great break!


Thanks,
SJ

[...]

