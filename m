Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F689F47CAC
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 18:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AE686B0005; Thu,  5 Mar 2026 13:16:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48F236B0089; Thu,  5 Mar 2026 13:16:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 391E86B008A; Thu,  5 Mar 2026 13:16:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 26CA16B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:16:31 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 683E0C1371
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 18:16:30 +0000 (UTC)
X-FDA: 84512814540.27.C6F988F
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf19.hostedemail.com (Postfix) with ESMTP id 725171A0016
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 18:16:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=ERHsymTj;
	spf=pass (imf19.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772734588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RIxu2UmisZj1gBHdIkVdu8dfhc8pgW90ZwBwUMZ5Nt8=;
	b=bAMHu1Dr7fdhFvgFr32K23Y+6DN74KSmwN3r5I9clEqc7gvoddD9LvYR/86m0cJBBllG1r
	/tgIHo8wmtKGfHKp3yZWbo95tghnWvobRw0hryLQMFMKY/vMSkfvreswfcwC0jP4U/HxlT
	2B0tZuADP4pxtzBk5IFo2nBdte+bciQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=ERHsymTj;
	spf=pass (imf19.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772734588; a=rsa-sha256;
	cv=none;
	b=DunaIXodNB8th3/vfw+9v6PrtQaHa8DzhUDsNtMI5Wzz+Qp3ib64mPL7Im27WK9BrZtFr5
	KhytxTzwpA8mFMzzHa9WWX55pJ0hzzBGDifz32XcNLbG6Sk9xE54VYbeH92a0N6nV0RfDx
	s+VjHf7/mylWp3C3rBlkTGghJZAObnI=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 6B5C1B3372;
	Thu, 05 Mar 2026 18:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772734586;
	bh=RIxu2UmisZj1gBHdIkVdu8dfhc8pgW90ZwBwUMZ5Nt8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ERHsymTj9fD63/PVjhhmH9C1LwEd9+RUVtbRLwgIZpQxPyzqTf8Xu6psm6AfXHl8w
	 /d5TZigph9IPleKxGJSRug/wlIRqY9Cg72ZdQkvR9hR24OhGq56INmDCERndOUVXxL
	 wAIjy/hh/1LaLFYcySTpruGS/PgjuhwMUdO67AEI=
Date: Thu, 5 Mar 2026 18:16:22 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <aanIdk2i-Eo9M967@shell.ilvokhin.com>
References: <20260304151335.172572-1-sj@kernel.org>
 <ebd994ca-eb04-4dff-a0a8-47aef0934c2c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebd994ca-eb04-4dff-a0a8-47aef0934c2c@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 725171A0016
X-Stat-Signature: cegxnezkjmetea8btg53hmu34bxqhn37
X-Rspam-User: 
X-HE-Tag: 1772734588-988957
X-HE-Meta: U2FsdGVkX1/ycdenISwCSaDmKzgFQKPqj1BGNZwPg/DizDRqHmSTqG6KIzTrryFbS4Df3ZFrz5dVRP4tdB5r2VDPugvlTeJoUUX9AVs8MXtO5L+Ubne7SVsaq7PF2uOr7EcNJXRcbliW6iwkGbAe3z4dhG/udHH+vg5bBqCCMvYfcu6wNKYh87vn4d2gpOGS8UVOJalfp/piDhn6jjDqMGUslN4sjhTfFqCqxbVo4WXBmzblAI95HmUJ1n/B/1gWS/BrEW+/1LWk+G3TCR7VU732JTEDwCgQlb9R6D3JBExmBEe0v6SWVlCNNZqHUUan/s8uSsvnJDhxNE+9UOJpRY6mHHBvj89DNiMf3+I+Enj9BsOGDTobqIgG7B9hBlyI6+Og48rcK5SAElkT+kXVBCV2MH5lMJFGWhBbndKjH0EmhKJNg0BGsU9bYYP/3fPc4J7B6OmJtp0fyNbV1qWx8Zb4ainbFU25xPXZVNAx1SC1MmDEyFxyTPbyZdLwlt094FbmLGrgDTKgbEj76ksF/dw1CZe8H4tTAcXq2CfGocssJ4ExjcBucOz23IshTySFiQsemgDVmdi/A1iXob1STdI6DDnsWOraK62YwTkuhwq7vP4Pc6YENMfvAG3pwv9+1Nmc9NCj2PwNqcvNVeS6NPaho4/jSfxFg8T13ie3dzQax75k10jH/hEAw23m2ht+LbbSGwJslMp7oCKXVOzYjfPeQbIKfGGcHjSMhw8pux+dI/ymrlwZK+9/2Px6JDeCj5kgCYm2yAaAJm4994EcITBvTgYvPPFxoohAKgqjyFSRVYmB7rrXqTQKd0dl6vMfUXjMtoP2KTsb8YhXqWCWUfNnJ+dr0sA7X/bcfQJ5HoQX/lUTvhf3HaK/lZNEtjD0njEi7KogaLXmVtHhxNPz4LXnFS1YbPIPWpPINGI/7QbzU0zCuycnI2lg2t26p1psyX8RVwLHiMkDkTl0BA9
 iwQlMFyk
 NgeC8oCMw79wXQ8cVj/e2/QEv+4OhCCpkRwIENLhdN3s/r53Wjeug2dXvxLzsqCfkttqzFu0IDneCtkARgtYO0s/7hwvec2t32Bo+qokb6drWRt/f83x4lt3u8ku4a04MRxhaAoSKZnCwJDG+ZkevgGTTBA1xiJdiULVgnmeqzCYedpMK7kUzVs4LBsZT5a8oCgVoOuEbaw5IEozyHGwrWbeYUQd8euQmX4ApalyOVRoHx3GnCL04gR5mxa16H5L6AErUZna3M2vTLe8qH+NGyhIutDrtD1DRfnw/9rzg2q99S/uQKhCiG1k3jlcUuxPY5ukKbJnlJiwoj1EdwkfGIOQvol1q4T4FJ7X6nWvucjeyH5jsfHVr3qbghklHo27yTUixhBN2ob8h6HwP3RmpkXADuWZKnsFVS/FtIBUsYOdivD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 10:27:07AM +0100, Vlastimil Babka (SUSE) wrote:
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

Thanks for the suggestion, Vlastimil. That sounds reasonable to me as
well. I'll update the comments and documentation to consistently use
"zone lock".

