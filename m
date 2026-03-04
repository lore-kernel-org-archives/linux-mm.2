Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F4ECEB363E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E0C66B0088; Wed,  4 Mar 2026 08:01:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A1EB6B0089; Wed,  4 Mar 2026 08:01:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CE616B008A; Wed,  4 Mar 2026 08:01:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2E1F86B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:01:55 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2161B98F5
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:01:54 +0000 (UTC)
X-FDA: 84508392948.02.ADD4CD8
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf14.hostedemail.com (Postfix) with ESMTP id 937C810001A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:01:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=pFthcIOp;
	spf=pass (imf14.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772629313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A9Z22CwhsOMBQOd91GzYVcy5QaFqoA5vc5xFlhCLB5c=;
	b=R+tl0fMg2g+rrauQ5ymd0ln5zh6yVxKHhBD61JgEVs0NbmfC4a+zJS/knVgAjH5uC4v8LN
	Tgcj9dRNL0PwnDkjGwpvDS3amxMaBNjWa2A5yDp81kl7UVrVOPVFWPvPh7pe3ajpUNLiJE
	xtuCtLiFy3SX1CFo7Cwfm10ZHugbxLM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772629313; a=rsa-sha256;
	cv=none;
	b=RWhLq5OUV+gTK/U5d7aFjoLxAKrLfHlI5/tQiQk2W30dvFRKvRaPRkwqSAuNP/XJTgNaev
	dDeDSw5i2tmLstKp92+WcuYCtIh4v9CEkQ+PhK9u/O/j1oaBlilFJlUGKk99a9AA4odJHx
	PmdFhCjodxSbARVoUC77JbQ/zpYpODE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=pFthcIOp;
	spf=pass (imf14.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 87BDEB3180;
	Wed, 04 Mar 2026 13:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772629310;
	bh=A9Z22CwhsOMBQOd91GzYVcy5QaFqoA5vc5xFlhCLB5c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=pFthcIOpg6gMssYocf5aeRIIf77W9v5hZIKXBO7FBI43GEFsFtiRaFd/8KmWzEQbq
	 r5Mij1YYDKyrPnmIdgwa/tHoTR+2WzWnTHVmDS1cW790Wkj+VNUORUSHNy9/MsuVMl
	 j/JEInhSlK7v2JYG+6N18JlNqCd4oHXPL8TqT9y0=
Date: Wed, 4 Mar 2026 13:01:45 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v4 4/5] mm: rename zone->lock to zone->_lock
Message-ID: <aagtOctLQqpDcw_h@shell.ilvokhin.com>
References: <aabvc4Xhc9qBfaG7@shell.ilvokhin.com>
 <20260304015035.84839-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304015035.84839-1-sj@kernel.org>
X-Rspam-User: 
X-Stat-Signature: t1cisfzq3zyyat6d9cacs1wtkt93bbty
X-Rspamd-Queue-Id: 937C810001A
X-Rspamd-Server: rspam03
X-HE-Tag: 1772629312-588563
X-HE-Meta: U2FsdGVkX193iLuFO+Ka7iUEeeoQcdF316D9pV2D00jKaooOiWdEz4ecRiu6Te9upkN9ZgyMUELvUvS9lBiZf4UuAc/TmWLqTBuL1MAeMGR4kAPQ6+ls8SKwjltPQvkA2aT7JbCHFIrRBpLwMCGQq4jJ/HqGHKcrIZ4cN6KSSZjx1qf8eT9eNkv/liY5NvX+hZmcQjAb9EzfZEjRu5QedyJKVd1U/z6p1g7G+LTo32OH/74txOCBHMrWoK8Lvafa6m3eKsPhqgCsP3iGhnhWfDrp3MIOb9SrbyFnl+L/QKayb2N6jM0F3K7y8GEE/qD8KplEfv5Z6XtEQhabNARRo0yx8XI4DjNa6AWKvFNmNho9bFHUTtDMlAF72xCBwdPFdkeO3bjj1rH3Vgj8nt3dguHgMylaWkaTFo+7cTBx6mDKYQ16UP2yX/UrNFTjzvMFhuvzHuObh8NQ9+t20ATKHfZUpCgsJQEQxMUT5tbH7kjFJvFCBEOyPEH7JzmK/mUb/oyLzenYxUjA7uBut4zjCzEcjOJ/y9i2UKdV9grE9zOyUcmHF85lw93sViUGNqduBsBgLOfz3A6Vi5aANYI+tQNrR42gyjLThnxMfppTVw7vGX4p4Txs11c3cjSQXjTJXEmLZlkAGwIiyvAW94Wt1rBUhwiXnnczd4UJf8YGtrLhHMYsztgVC3o/Z9VyyEcz+t0Vq4BEqQxaRyEZATEWdt7DkNTfCX099RjfhSKeUYGUX9/CZC1FyuOenqrumnf3BvbuWQq2Kz9IQXAC2gOa7XEiOYWSWd1g2kGfOHm3ZGmpiTFPwyu/sDfegiLdWx4o9ejr/fYyN5et2ozIeLzFMZkPJWXvXv4myS/FKJL3D8ufym0vXiqneWIUwWt/WYsrrINRi9b9uhdFSmP9UBBYCYlUIB+ALsZvQIOg5wKHwN6V1ex3PCdKxHHp4QqBxs+3tPk+rUcc9gE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 05:50:34PM -0800, SeongJae Park wrote:
> On Tue, 3 Mar 2026 14:25:55 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> > On Mon, Mar 02, 2026 at 02:37:43PM -0800, Andrew Morton wrote:
> > > On Mon, 2 Mar 2026 15:10:03 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
> > > 
> > > > On 2/27/26 17:00, Dmitry Ilvokhin wrote:
> > > > > This intentionally breaks direct users of zone->lock at compile time so
> > > > > all call sites are converted to the zone lock wrappers. Without the
> > > > > rename, present and future out-of-tree code could continue using
> > > > > spin_lock(&zone->lock) and bypass the wrappers and tracing
> > > > > infrastructure.
> > > > > 
> > > > > No functional change intended.
> > > > > 
> > > > > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> > > > > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > > > > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > > > Acked-by: SeongJae Park <sj@kernel.org>
> > > > 
> > > > I see some more instances of 'zone->lock' in comments in
> > > > include/linux/mmzone.h and under Documentation/ but otherwise LGTM.
> > > > 
> > > 
> > > I fixed (most of) that in the previous version but my fix was lost.
> > 
> > Thanks for the fixups, Andrew.
> > 
> > I still see a few 'zone->lock' references in Documentation remain on
> > mm-new. This patch cleans them up, as noted by Vlastimil.
> > 
> > I'm happy to adjust this patch if anything else needs attention.
> > 
> > From 9142d5a8b60038fa424a6033253960682e5a51f4 Mon Sep 17 00:00:00 2001
> > From: Dmitry Ilvokhin <d@ilvokhin.com>
> > Date: Tue, 3 Mar 2026 06:13:13 -0800
> > Subject: [PATCH] mm: fix remaining zone->lock references
> > 
> > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > ---
> >  Documentation/mm/physical_memory.rst | 4 ++--
> >  Documentation/trace/events-kmem.rst  | 8 ++++----
> >  2 files changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
> > index b76183545e5b..e344f93515b6 100644
> > --- a/Documentation/mm/physical_memory.rst
> > +++ b/Documentation/mm/physical_memory.rst
> > @@ -500,11 +500,11 @@ General
> >  ``nr_isolate_pageblock``
> >    Number of isolated pageblocks. It is used to solve incorrect freepage counting
> >    problem due to racy retrieving migratetype of pageblock. Protected by
> > -  ``zone->lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
> > +  ``zone_lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
> 
> Dmitry's original patch [1] was doing 's/zone->lock/zone->_lock/', which aligns
> to my expectation.  But this patch is doing 's/zone->lock/zone_lock/'.  Same
> for the rest of this patch.
> 
> I was initially thinking this is just a mistake, but I also found Andrew is
> doing same change [2], so I'm bit confused.  Is this an intentional change?
> 
> [1] https://lore.kernel.org/d61500c5784c64e971f4d328c57639303c475f81.1772206930.git.d@ilvokhin.com
> [2] https://lore.kernel.org/20260302143743.220eed4feb36d7572fe726cc@linux-foundation.org
> 

Good catch, thanks for pointing this out, SJ.

Originally the mechanical rename was indeed zone->lock -> zone->_lock.
However, in Documentation I intentionally switched references to
zone_lock instead of zone->_lock. The reasoning is that _lock is now an
internal implementation detail, and direct access is discouraged. The
intended interface is via the zone_lock_*() / zone_unlock_*() wrappers,
so referencing zone_lock in documentation felt more appropriate than
mentioning the private struct field (zone->_lock).

That said, I agree this creates inconsistency with the mechanical
rename, and I'm happy to adjust either way: either consistently refer
to the wrapper API, or keep documentation aligned with zone->_lock.

I slightly prefer referring to the wrapper API, but don't have a strong
preference as long as we're consistent.

> 
> Thanks,
> SJ
> 
> [...]

