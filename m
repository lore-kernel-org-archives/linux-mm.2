Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA234F33A7D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 14:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05BA16B0005; Thu,  5 Mar 2026 09:56:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0339A6B0088; Thu,  5 Mar 2026 09:56:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74B76B0089; Thu,  5 Mar 2026 09:56:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D22866B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:56:00 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 74038888BE
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:56:00 +0000 (UTC)
X-FDA: 84512309280.07.0E85EA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id D350E100010
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:55:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kn5ytd+7;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772722558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bkPQ3sgkDOoPfp+AeBsnuKOEYfSCX6MisFQPtRAT9xY=;
	b=Fn1uZMKyQXf5Zs2V3h75MqGUbA6RBdAp5ezpPzFj/Z3Fb4b8rIsKB98qjJNV2OSmfppf5M
	dkm4zairbtdQIMxWl+miXb+f8yxaop1aTuG6/cmpAO0z2rWEfky0OOKoXhuM1nIdC8e2dp
	NemwKLhUqFpW7p/4eM580hzQ+vEqLLQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kn5ytd+7;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772722558; a=rsa-sha256;
	cv=none;
	b=Yq4JJaRzGMJ2SvXJDUKdkbV1b0s4ME8ZAL92u8CydT1mt1UeVrB0nH67lYO2t0agobi6uv
	MApbT0rKQJTxOM8rcjKfFeaOIkdC+hL3Gj7hJxxk2/RVXo+AMbWRGH/J+HE9opU/WT5xAK
	YzTp4GLR19Yz+gQCBslwLcZE0bodXH4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3986A61344;
	Thu,  5 Mar 2026 14:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C8BC116C6;
	Thu,  5 Mar 2026 14:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772722557;
	bh=amy+SaJwg+WdNFtVzm4GtX3Td8Gs26jX8LxmkTno6mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kn5ytd+7nTBuHR5VYD0Y5pcHIekfqTi0HrmCH4uShdxcHMRM7QLt0UwhiTR0IAXYz
	 8hyJKh3UnfDvpbf53kXXwIhziqGlXZfM6ZO4elMz/qwqRp8PvKa34BhMm3nGfQfsjy
	 6mJb2bH+1wsynJJnIzCil2M1AxaznsFfQhSK4gzHpjTaB3mlb6qPmBxW/MqVTIvTw8
	 xZp6Dq7zDPTxggBKUBqxELmoACZFjNpGe8DSbeET7G2D7F02Tvj+o7EWMf6DB8q4yX
	 VIe5zQXI5oniyBBqu7mjnlt+h7uCI2+LLBUN8vpMlXFRZP3RRkekTtfllNd9L3uaBA
	 Xm2NkkFxJkvsA==
From: SeongJae Park <sj@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v4 4/5] mm: rename zone->lock to zone->_lock
Date: Thu,  5 Mar 2026 06:55:54 -0800
Message-ID: <20260305145555.86081-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ebd994ca-eb04-4dff-a0a8-47aef0934c2c@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D350E100010
X-Stat-Signature: fqn5oow7xewezm4irixfhbphhp8rh56n
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772722558-61539
X-HE-Meta: U2FsdGVkX19Z9tKEL3Du2imROghOuL6u3dUa+E1iBH04V0olQ4WdYsL0Rr6e7fcH3VCgaqa6NS57cIUpaukQCqYeDQ69wZadOL5wOF+/BhDJwNXOgskZzZC05lu7GnFnQh8gImFcW18eh26tJCVskIu4Lb5cv7AR6Oxp3rtq9sYQanAHqMw+LXoN+pSQouvU/EFJw0WGFHxF0cJPrO5VhwcjaQFqJy3poL5KidK7bEHp+0x79d1+RYSawdD+rOv1VWJr+M/92r/sAeESFAnXQ7rEIYtas14c5p82NcP5VcxkqhQS/R/0IgQXrxHX8tvTpZmly/HM3tmhmVTTOq1OVylM9hGQyWF0Uua7Uz1G05X1Fck3RdY/tWwosaxvOmizDAskOpuT83aXEA7VoAUBPL8YUYAVwsim5mCJ5z2aSSPe/euRfECc0I20sWGdONAqvZJw2g6SLBpqzJuCIuzzcf2ZlZmhUMr+AB8VqSzEPXuTwRH8T/ZCEx/wR1XwKpjAffZokiQ8TcshASv17b7Amanh6qTXuFq/d2L38gzxN+SqERolMQF74Vcsihp9bUpPvpFpTw5KwLLvsKssnBA2u2wKeo9hZZKmAnj8rZCP5H4KjNTrgagnfbAe9dYJvXZvZBfdJJ/Y7G/2tikw+hHUB0bNUfaI92xG87w1SzY+4NoVML9Tvo7VTXvAPOO5SwHYFwHUXnvwphEy0Uq8mZIxax9S4EXhvB6WV23abccAvVWa/EjzphqxvHw7EuhsTI/cKbJxk9n0GtZOg+5h2gnh12GBZBLeXq46SaS58flfIJzhTiBI4wM7cXjbnA6kwZr0oIw+zVb1Suv3cMugLJffmVClhRz7bVYDykq2HQG421amSyzlccObRCxg2Krka/jYkxeAkQ4ySgQHk6oGpCCwidvBbVoTdOlshop7x/Jt5tpZy5dfISTpVQhPZARd1Y68+CVppneBNxrHMoubRDi
 J9+F4xF6
 oXZ53ugGFjLz/J7IhOosC9nzd0X6iwjmWaqKN3SuhxpQgkgNGozPy8o7E16tUigGw9RqvCGQBYs2v1DSKUjCPQn9YJXjyF3miiPfO1nJlEfXOtENvrTNC8x7tpRj4aougfiY8VvHYFJgU9E3BkvFX9pAL7zYjrKWL4a4V0/uimqFLIhoEFdTrgMm7D7eaIS+1LDCqzxdRbBq7pco6QYbogyz67W6oMW3X8EFR1NMWvsYvHHkkpTwCAsugSUAae3LR/d2HreBZzzxDDcgrMc3ULXMKe5XLYS8Xbr1ddUjxgB/paCega/W659qDh8YEaaB6tS/TZTi63NsMpX5ZL8BoZvPRmFwlD/6VH+o15ME1/aKPImtNj8iJghayVZCYfxl2+mdwgzYNkjfu8fA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 5 Mar 2026 10:27:07 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> On 3/4/26 16:13, SeongJae Park wrote:
> > On Wed, 4 Mar 2026 13:01:45 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> > 
> >> On Tue, Mar 03, 2026 at 05:50:34PM -0800, SeongJae Park wrote:
> >> > On Tue, 3 Mar 2026 14:25:55 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> >> > 
> >> > > On Mon, Mar 02, 2026 at 02:37:43PM -0800, Andrew Morton wrote:
> >> > > > On Mon, 2 Mar 2026 15:10:03 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
> >> > > > 
> >> > > > > On 2/27/26 17:00, Dmitry Ilvokhin wrote:
> >> > > > > > This intentionally breaks direct users of zone->lock at compile time so
> >> > > > > > all call sites are converted to the zone lock wrappers. Without the
> >> > > > > > rename, present and future out-of-tree code could continue using
> >> > > > > > spin_lock(&zone->lock) and bypass the wrappers and tracing
> >> > > > > > infrastructure.
> >> > > > > > 
> >> > > > > > No functional change intended.
> >> > > > > > 
> >> > > > > > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> >> > > > > > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> >> > > > > > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> >> > > > > > Acked-by: SeongJae Park <sj@kernel.org>
> >> > > > > 
> >> > > > > I see some more instances of 'zone->lock' in comments in
> >> > > > > include/linux/mmzone.h and under Documentation/ but otherwise LGTM.
> >> > > > > 
> >> > > > 
> >> > > > I fixed (most of) that in the previous version but my fix was lost.
> >> > > 
> >> > > Thanks for the fixups, Andrew.
> >> > > 
> >> > > I still see a few 'zone->lock' references in Documentation remain on
> >> > > mm-new. This patch cleans them up, as noted by Vlastimil.
> >> > > 
> >> > > I'm happy to adjust this patch if anything else needs attention.
> >> > > 
> >> > > From 9142d5a8b60038fa424a6033253960682e5a51f4 Mon Sep 17 00:00:00 2001
> >> > > From: Dmitry Ilvokhin <d@ilvokhin.com>
> >> > > Date: Tue, 3 Mar 2026 06:13:13 -0800
> >> > > Subject: [PATCH] mm: fix remaining zone->lock references
> >> > > 
> >> > > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> >> > > ---
> >> > >  Documentation/mm/physical_memory.rst | 4 ++--
> >> > >  Documentation/trace/events-kmem.rst  | 8 ++++----
> >> > >  2 files changed, 6 insertions(+), 6 deletions(-)
> >> > > 
> >> > > diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
> >> > > index b76183545e5b..e344f93515b6 100644
> >> > > --- a/Documentation/mm/physical_memory.rst
> >> > > +++ b/Documentation/mm/physical_memory.rst
> >> > > @@ -500,11 +500,11 @@ General
> >> > >  ``nr_isolate_pageblock``
> >> > >    Number of isolated pageblocks. It is used to solve incorrect freepage counting
> >> > >    problem due to racy retrieving migratetype of pageblock. Protected by
> >> > > -  ``zone->lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
> >> > > +  ``zone_lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
> >> > 
> >> > Dmitry's original patch [1] was doing 's/zone->lock/zone->_lock/', which aligns
> >> > to my expectation.  But this patch is doing 's/zone->lock/zone_lock/'.  Same
> >> > for the rest of this patch.
> >> > 
> >> > I was initially thinking this is just a mistake, but I also found Andrew is
> >> > doing same change [2], so I'm bit confused.  Is this an intentional change?
> >> > 
> >> > [1] https://lore.kernel.org/d61500c5784c64e971f4d328c57639303c475f81.1772206930.git.d@ilvokhin.com
> >> > [2] https://lore.kernel.org/20260302143743.220eed4feb36d7572fe726cc@linux-foundation.org
> >> > 
> >> 
> >> Good catch, thanks for pointing this out, SJ.
> >> 
> >> Originally the mechanical rename was indeed zone->lock -> zone->_lock.
> >> However, in Documentation I intentionally switched references to
> >> zone_lock instead of zone->_lock. The reasoning is that _lock is now an
> >> internal implementation detail, and direct access is discouraged. The
> >> intended interface is via the zone_lock_*() / zone_unlock_*() wrappers,
> >> so referencing zone_lock in documentation felt more appropriate than
> >> mentioning the private struct field (zone->_lock).
> > 
> > Thank you for this nice and kind clarification, Dmitry!  I agree mentioning
> > zone_[un]lock_*() helpers instead of the hidden member (zone->_lock) can be
> > better.
> > 
> > But, I'm concerned if people like me might not aware the intention under
> > 'zone_lock'.  If there is a well-known convention that allows people to know it
> > is for 'zone_[un]lock_*()' helpers, making it more clear would be nice, in my
> > humble opinion.  If there is such a convention but I'm just missing it, please
> > ignore.  If I'm not, for eaxmaple,
> > 
> > "protected by ``zone->lock``" could be re-wrote to
> > "protected by ``zone_[un]lock_*()`` locking helpers" or,
> > "protected by zone lock helper functions (``zone_[un]lock_*()``)" ?
> > 
> >> 
> >> That said, I agree this creates inconsistency with the mechanical
> >> rename, and I'm happy to adjust either way: either consistently refer
> >> to the wrapper API, or keep documentation aligned with zone->_lock.
> >> 
> >> I slightly prefer referring to the wrapper API, but don't have a strong
> >> preference as long as we're consistent.
> > 
> > I also think both approaches are good.  But for the wrapper approach, I think
> > giving more contexts rather than just ``zone_lock`` to readers would be nice.
> 
> Grep tells me that we also have comments mentioning simply "zone lock", btw.
> And it's also a term used often in informal conversations. Maybe we could
> just standardize on that in comments/documentations as it's easier to read.
> Discovering that the field is called _lock and that wrappers should be used,
> is hopefully not that difficult.

Sounds good, that also works for me.


Thanks,
SJ

