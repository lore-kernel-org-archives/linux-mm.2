Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA50EEF8FF3
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E26E6B008A; Wed,  4 Mar 2026 10:13:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28FBA6B008C; Wed,  4 Mar 2026 10:13:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18E866B0092; Wed,  4 Mar 2026 10:13:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 078FB6B008A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:13:56 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A0761B8446
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:13:55 +0000 (UTC)
X-FDA: 84508725630.15.4B59F9C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id EDEEAC0013
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:13:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vPvSHVMp;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772637233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vVzlVJCKPmMDMIWZO1x6Q+mabNba4yEUK35mv1gdRxw=;
	b=sorb4vhZWsnaPg9oWwe5sG4cWFTp531cphjMfh0psxs6I4XrPPpfxfxXPGXTcVXwH1zZ5+
	oNnAyoL1xi6kzbEQW8z0w3Koj6PGYlm//XHbyzlqcYspZfrQVg4VOyRx4P+E0rIoS3W56+
	hCj5qS1KkBU+DsDzDcUEvR/k3Yeti6k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vPvSHVMp;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772637233; a=rsa-sha256;
	cv=none;
	b=2hor7+b3osaFUcrMIionA2zToPMZ1mTmZRXJSuREE9N/6e+dmEwRi68AVMp8IR1WvhFmAk
	gYQquUAlqHir6hnPOC/tHtbQduRoq1bZTV8BhBMDIvMwzWE14og7a5OGyJHbBUKvVV6Fmh
	SetZM7ln9AyetI1HEdAOYESBEw7x5u0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 500A960097;
	Wed,  4 Mar 2026 15:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3CEC4CEF7;
	Wed,  4 Mar 2026 15:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772637233;
	bh=8QWqZ7YNDPVF6gZQ/i7c6RdhDtv9wD4t4d1tq0V22Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPvSHVMpbDtgWdTEaP2C6BvxAyg9V9WE2471ZNAhaRLeQz/pv6ihmrNaoqAOmSBPf
	 pVnNmTuJ7tWGqKJOQRMxgdvDSd1gsBypb43d5flxEX+PKJMg68CHlGuUIqLTiCFFuz
	 rKc1J8WJC8Pzjhh2VbH7q/t8+THOPWP+XMsLDTbTJ56nsjnrtQHCWj3p6bIBLwDZUH
	 dsnB+x2CRDMw3WeW5B2royvEVABcmYe086q2XeWwyM46Zbx4dnV3V7Lbti9KtpkpPj
	 JUMdnVwEMKWupt4mteIGkGEu0zZYa8FXy9APLll3zPJtiAf8bRT1EMQssv7I9hkYG+
	 tPEEdQ/fLqUqQ==
From: SeongJae Park <sj@kernel.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: SeongJae Park <sj@kernel.org>,
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
Date: Wed,  4 Mar 2026 07:13:34 -0800
Message-ID: <20260304151335.172572-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aagtOctLQqpDcw_h@shell.ilvokhin.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EDEEAC0013
X-Stat-Signature: j76akxpbxodkwbnz5sy1c7idf7yqzewu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772637233-793898
X-HE-Meta: U2FsdGVkX1+FYxjdgUVCCUPhW2bw/MUeKi41m5RG35MziZHkCqR8y4qi2RZzCNksfOi47g9ylcNYnBMzGTuYMncwZQet/SocjmIfomUiGJYO4FV5Hk7OIEOmAZ9/GfwO9UBUhL/iDzK/+8AFhDmE8yZxB6JObEgSJbR0Ys2wboEx9GaHFPYJiypw87Od7YZR0QFjToi2uMUqL3KSxxbiEhGDPSPIhRvvRPVQm77v8x3q+sYmpOUQ8LizmL6euZpXN9LfmbM1cYE0MDDQy1LkXleuctXzNzP1pOVN36l+klLmG42mDwJr5852b+2wAJPQriedVUoB9YF59UeSPUNabD597DiP06Gwmg7sJiCetsq3ziVlxezVV5xiY4iiY1xyhjPHgKuPiFq1gB5IROpREOOl0fa+9hbXCce8kNi/zAIjF1r1mFWJf1tlZbnEv8wXXxMTSgz5fuJYw54W9l8AWnWbK/fzDGHSGkbO3ZalV8Wq/emka8/nk3BJSoD9W3f6zzfCWh9E8eIM5WKAlXB05VhCofUcxByD4o7JUL0LUU5/Yk0i378sehCp5Ic/LjxC2/j9CTItGqc+uTREh4vU9UWgY0IrVoDqdD+zIPext67avXWtpIL3pQMzwf7+w37PhzZpGiqIgmN4eXJr9nS0OK/bCtLfVij38BZHLRaG6+D2PjFRbUdqKjajDRrvGCRhhEv0eyZq2yiDQPuXCQNdkZkla6XCQVlJnWJZEsAp68QREcM5EPLAF6giSQe9Gx6aiKs5W6Snqae4lHLl9P1LSdGVrxQgshPdo9yprGydzBrmWjBzwG3YPAXi/BFJa/DyLcZ7dlE18ibfEIaoWrzA28TmtS2PVybA1CF93RAcWPyF24qrKtEWhMZrExbT4w90EYwu80XmmYXc8FDg9j+qZsedo8GrJZSVXKs6HcgDbpZ/EIleTxsWhSS1WBAMdfJyDvXTkl2ePklp9oo8B2i
 ID7Fmr63
 eZwerH02on+dkaOGtsNyTLhiLQ/58k/S2b1GB1MczsGbppKI6hyaenCN0L53CbYib7ewjqXeNVxZ+w0lPtXecU0mf8wVCqSTItyAzQRUDrNUwA4yxY4joxTsFF8xGAKbK/P0899H4JCrpLjEi+/AVkbPucVk7NaoVS/j0KLHHFBaVVPhUBvvhZyeN2Xl15xgPEVmdVAoWepAGkMqntAVaFiAHJud1sy6I6eX+cvJlp9lKRrlAqT8O9z2A0PVbxDfvW/l9RJrB3hRAA8PuSFx9PsiTE2pinblj/MVmEKbrlkngfI+WI+HLE/DJrX7udOxpSTIpxRU/ovDvqVa09kX2pLqPtxVzpLIlm3dRN+YjybcTbSSfKsm1v1dohRoeFa0tY9CYLezoJabknxU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 4 Mar 2026 13:01:45 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> On Tue, Mar 03, 2026 at 05:50:34PM -0800, SeongJae Park wrote:
> > On Tue, 3 Mar 2026 14:25:55 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> > 
> > > On Mon, Mar 02, 2026 at 02:37:43PM -0800, Andrew Morton wrote:
> > > > On Mon, 2 Mar 2026 15:10:03 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
> > > > 
> > > > > On 2/27/26 17:00, Dmitry Ilvokhin wrote:
> > > > > > This intentionally breaks direct users of zone->lock at compile time so
> > > > > > all call sites are converted to the zone lock wrappers. Without the
> > > > > > rename, present and future out-of-tree code could continue using
> > > > > > spin_lock(&zone->lock) and bypass the wrappers and tracing
> > > > > > infrastructure.
> > > > > > 
> > > > > > No functional change intended.
> > > > > > 
> > > > > > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> > > > > > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > > > > > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > > > > Acked-by: SeongJae Park <sj@kernel.org>
> > > > > 
> > > > > I see some more instances of 'zone->lock' in comments in
> > > > > include/linux/mmzone.h and under Documentation/ but otherwise LGTM.
> > > > > 
> > > > 
> > > > I fixed (most of) that in the previous version but my fix was lost.
> > > 
> > > Thanks for the fixups, Andrew.
> > > 
> > > I still see a few 'zone->lock' references in Documentation remain on
> > > mm-new. This patch cleans them up, as noted by Vlastimil.
> > > 
> > > I'm happy to adjust this patch if anything else needs attention.
> > > 
> > > From 9142d5a8b60038fa424a6033253960682e5a51f4 Mon Sep 17 00:00:00 2001
> > > From: Dmitry Ilvokhin <d@ilvokhin.com>
> > > Date: Tue, 3 Mar 2026 06:13:13 -0800
> > > Subject: [PATCH] mm: fix remaining zone->lock references
> > > 
> > > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > > ---
> > >  Documentation/mm/physical_memory.rst | 4 ++--
> > >  Documentation/trace/events-kmem.rst  | 8 ++++----
> > >  2 files changed, 6 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
> > > index b76183545e5b..e344f93515b6 100644
> > > --- a/Documentation/mm/physical_memory.rst
> > > +++ b/Documentation/mm/physical_memory.rst
> > > @@ -500,11 +500,11 @@ General
> > >  ``nr_isolate_pageblock``
> > >    Number of isolated pageblocks. It is used to solve incorrect freepage counting
> > >    problem due to racy retrieving migratetype of pageblock. Protected by
> > > -  ``zone->lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
> > > +  ``zone_lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
> > 
> > Dmitry's original patch [1] was doing 's/zone->lock/zone->_lock/', which aligns
> > to my expectation.  But this patch is doing 's/zone->lock/zone_lock/'.  Same
> > for the rest of this patch.
> > 
> > I was initially thinking this is just a mistake, but I also found Andrew is
> > doing same change [2], so I'm bit confused.  Is this an intentional change?
> > 
> > [1] https://lore.kernel.org/d61500c5784c64e971f4d328c57639303c475f81.1772206930.git.d@ilvokhin.com
> > [2] https://lore.kernel.org/20260302143743.220eed4feb36d7572fe726cc@linux-foundation.org
> > 
> 
> Good catch, thanks for pointing this out, SJ.
> 
> Originally the mechanical rename was indeed zone->lock -> zone->_lock.
> However, in Documentation I intentionally switched references to
> zone_lock instead of zone->_lock. The reasoning is that _lock is now an
> internal implementation detail, and direct access is discouraged. The
> intended interface is via the zone_lock_*() / zone_unlock_*() wrappers,
> so referencing zone_lock in documentation felt more appropriate than
> mentioning the private struct field (zone->_lock).

Thank you for this nice and kind clarification, Dmitry!  I agree mentioning
zone_[un]lock_*() helpers instead of the hidden member (zone->_lock) can be
better.

But, I'm concerned if people like me might not aware the intention under
'zone_lock'.  If there is a well-known convention that allows people to know it
is for 'zone_[un]lock_*()' helpers, making it more clear would be nice, in my
humble opinion.  If there is such a convention but I'm just missing it, please
ignore.  If I'm not, for eaxmaple,

"protected by ``zone->lock``" could be re-wrote to
"protected by ``zone_[un]lock_*()`` locking helpers" or,
"protected by zone lock helper functions (``zone_[un]lock_*()``)" ?

> 
> That said, I agree this creates inconsistency with the mechanical
> rename, and I'm happy to adjust either way: either consistently refer
> to the wrapper API, or keep documentation aligned with zone->_lock.
> 
> I slightly prefer referring to the wrapper API, but don't have a strong
> preference as long as we're consistent.

I also think both approaches are good.  But for the wrapper approach, I think
giving more contexts rather than just ``zone_lock`` to readers would be nice.


Thanks,
SJ

[...]

