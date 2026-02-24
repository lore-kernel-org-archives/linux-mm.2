Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26DB2F3C99E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 15:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F74F6B0088; Tue, 24 Feb 2026 10:50:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A5326B0089; Tue, 24 Feb 2026 10:50:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3862E6B008A; Tue, 24 Feb 2026 10:50:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 244AD6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:50:46 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B76811396FA
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:50:45 +0000 (UTC)
X-FDA: 84479788050.29.182D9DF
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf16.hostedemail.com (Postfix) with ESMTP id DD07718000E
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:50:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=aNEnycGi;
	spf=pass (imf16.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771948244; a=rsa-sha256;
	cv=none;
	b=bFWEfwBmvo6YsqGTTIaouZOZ4BVQHTtsiFHOkOpOLgNkUpiObWLKwnUyBCI4uo5h4yaRc6
	3is9AnvbBQ0lZqXQ8rd3ywKV5osg9xOdGmrTgHWdhGP3b9TWulfivwzuHuxnb7uW9jgjZv
	++nQbGBJ6u+FLjwgMOTyuzVJ3DRJASw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=aNEnycGi;
	spf=pass (imf16.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771948244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Afmea4/5yCr+RWfrWvynSjvo68B8NHavl3Ss2MT9/VQ=;
	b=j+j0bqnpz0ZU/I8j9S9eCov5+/4Vzm8DY7YzdnSWvrWdxza5BeTOeScR8Cn4jXLZbSPiR3
	AR72SRhYxlCo1zZb0tAHeoCmqwchAjPKN1SGgoDXfGIatQJqTbS56NevajHHaUrKak78rn
	B5qeyRqIwY/l/qnM5ywWTXxMnQk9Hvc=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id E929EB2BBD;
	Tue, 24 Feb 2026 15:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1771948242;
	bh=Afmea4/5yCr+RWfrWvynSjvo68B8NHavl3Ss2MT9/VQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aNEnycGipuTvB2eFYUNi+YkjU7B1iN2zSAv5L2GpcFd4CIkpEfhb2xvGYXuJLJ4T5
	 H68tjkaI9ypOxNFtEqKRUfIN6qN3VyZvOUvCF70KRM1KYbJTEE4ZX/zTlI5MWMJ5hG
	 KNdFnNRD+v/8PyWc+lCMPO1pp1WLhsioXMoBUIRA=
Date: Tue, 24 Feb 2026 15:50:40 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	kernel-team@meta.com, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Subject: Re: [PATCH 3/4] mm: convert compaction to zone lock wrappers
Message-ID: <aZ3I0ADTAdCN6UmN@shell.ilvokhin.com>
References: <cover.1770821420.git.d@ilvokhin.com>
 <3462b7fd26123c69ccdd121a894da14bbfafdd9d.1770821420.git.d@ilvokhin.com>
 <74fc1f28-b77e-4b9c-b208-51babae9d18e@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74fc1f28-b77e-4b9c-b208-51babae9d18e@amd.com>
X-Rspamd-Queue-Id: DD07718000E
X-Stat-Signature: acxmwymtprjkjz6ac5dfoqdbnyzxisj9
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771948243-943878
X-HE-Meta: U2FsdGVkX1+b+X+aLLpxFZ6EICNSwIMScmWQ1U/7mHKwu95feBn5gWAyS2EOOR0DiwoRcwDsQSp2zLWHafi1upv5CvPeRJNg4wzQVNfWedGbLSSIgiJiqnMwr+hk/QTFPe7WGDh6fbQzMlyu+LOaDGeDyc1yHF3ApDbiXT8+EyNJu4vzek4SsDg198VInvlEx+mJ1AeDocGCBHcXONE9ZAn4aqyXOzb2z4U++FfrFmNMGoVjGHnUBJ/h1HAkVTDqCNwgY2vUfLJSUQc6w16tf1QWKQxLpC82GplN/vpJRzcipmFm8PDrkRQjym1KglKuM/BJb3nJ/hwnVTZSfdyvguWsCdlDT37vJqaVLGwmcnS4aK87euEbAUkJIgnM+hHKSEMCOU/fd4IwmrKXkrzkBN9OSBmseleRxRAwZvUKqLNVoT3M4xvAR9B92mcKCsYae8A1iWIWlbyeg8SiZpItF230ZvYmRr4FXEwyHJz9hvng7RYbrnJIS67XdVaH/Pf9hLALtLt4v5hyZ42yQk54cu/cdGfISKrGqgQwlDERmDeQPTloE2i4Ztis0El4hIV284VQiheCp8Qdu0BgW3Nr4IIaVrRpnplIxG5QS3fKT4EMjMtVaMEa3vW9+DsVm3hHxNl0DZrT+AsPsAodVgkjyDF7xgxxZBbIo7VHerBCwES5b+CV2phVhrhnuGTjTc2TmU+IVk/udvA3iMI0uoJhS0MCpK228tP5zaE1XFnX0vzwTw6yyfPgLsVyOQA74m8ABINPlB7p9a27KybWPJsr95L3XO9RDJuNbUGSJfmn7CiFxkBX2Fa6k8p7YeYRntzQ9OPwTf+baiimYTSTaVr21w45TgG04u0bLjnKbrS4GKv0j0MrIm9BXUgYovjEsBUxVMwq4ERQxEqkHpbQhGaSQc92aee4/FjoZUKUrRvhgDpSWgEVzkr3nfwwDEerSPI2drEnDgbr6CZvMBTCT4k
 YZClbUWo
 1YdDUR/M6s6yCTCdacLKYsi8cDdowH/gcH51boIq49KDhO+uW1HWBOUkb1Vi5iMPmsOUAsEkTqRT9Hohl9PbVwMTwfmNeSLjjxgZzDb09pYc6nQuve9dABQXev9RODnJktPf6PvNxxcRZmwBeAyXqf7ZURL8Su9HaqHG13F9Zo7MeAbypsLCwPj3YDyG/iHN32fcG8poyQa4yjx6BPUrCYBsOfrxoWtoE02iHfCHSbFHJMRD3fyZpgJNrhf+cg4CaveFTE3P59jzwzKBDOoDY4hrJ8PBZie83Dev7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 01:10:05PM -0600, Cheatham, Benjamin wrote:
> On 2/11/2026 9:22 AM, Dmitry Ilvokhin wrote:
> > Compaction uses compact_lock_irqsave(), which currently operates
> > on a raw spinlock_t pointer so that it can be used for both
> > zone->lock and lru_lock. Since zone lock operations are now wrapped,
> > compact_lock_irqsave() can no longer operate directly on a spinlock_t
> > when the lock belongs to a zone.
> > 
> > Introduce struct compact_lock to abstract the underlying lock type. The
> > structure carries a lock type enum and a union holding either a zone
> > pointer or a raw spinlock_t pointer, and dispatches to the appropriate
> > lock/unlock helper.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > ---
> >  mm/compaction.c | 108 +++++++++++++++++++++++++++++++++++++++---------
> >  1 file changed, 89 insertions(+), 19 deletions(-)
> > 
> > diff --git a/mm/compaction.c b/mm/compaction.c
> > index 1e8f8eca318c..1b000d2b95b2 100644
> > --- a/mm/compaction.c
> > +++ b/mm/compaction.c
> > @@ -24,6 +24,7 @@
> >  #include <linux/page_owner.h>
> >  #include <linux/psi.h>
> >  #include <linux/cpuset.h>
> > +#include <linux/zone_lock.h>
> >  #include "internal.h"
> >  
> >  #ifdef CONFIG_COMPACTION
> > @@ -493,6 +494,65 @@ static bool test_and_set_skip(struct compact_control *cc, struct page *page)
> >  }
> >  #endif /* CONFIG_COMPACTION */
> >  
> > +enum compact_lock_type {
> > +	COMPACT_LOCK_ZONE,
> > +	COMPACT_LOCK_RAW_SPINLOCK,
> > +};
> > +
> > +struct compact_lock {
> > +	enum compact_lock_type type;
> > +	union {
> > +		struct zone *zone;
> > +		spinlock_t *lock; /* Reference to lru lock */
> > +	};
> > +};
> > +
> > +static bool compact_do_zone_trylock_irqsave(struct zone *zone,
> > +					    unsigned long *flags)
> > +{
> > +	return zone_trylock_irqsave(zone, *flags);
> > +}
> > +
> > +static bool compact_do_raw_trylock_irqsave(spinlock_t *lock,
> > +					   unsigned long *flags)
> > +{
> > +	return spin_trylock_irqsave(lock, *flags);
> > +}
> > +
> > +static bool compact_do_trylock_irqsave(struct compact_lock lock,
> > +				       unsigned long *flags)
> > +{
> > +	if (lock.type == COMPACT_LOCK_ZONE)
> > +		return compact_do_zone_trylock_irqsave(lock.zone, flags);
> > +
> > +	return compact_do_raw_trylock_irqsave(lock.lock, flags);
> > +}
> 
> Nit: You could remove the helpers above and just do the calls directly in this function, though
> it would remove the parity with the compact helpers. compact_do_lock_irqsave() helpers can stay
> since they have the __acquires() annotations.

Yes, I agree, there is no much value in this wrappers, will remove them,
thanks!

> > +
> > +static void compact_do_zone_lock_irqsave(struct zone *zone,
> > +					 unsigned long *flags)
> > +__acquires(zone->lock)
> > +{
> > +	zone_lock_irqsave(zone, *flags);
> > +}
> > +
> > +static void compact_do_raw_lock_irqsave(spinlock_t *lock,
> > +					unsigned long *flags)
> > +__acquires(lock)
> > +{
> > +	spin_lock_irqsave(lock, *flags);
> > +}
> > +
> > +static void compact_do_lock_irqsave(struct compact_lock lock,
> > +				    unsigned long *flags)
> > +{
> > +	if (lock.type == COMPACT_LOCK_ZONE) {
> > +		compact_do_zone_lock_irqsave(lock.zone, flags);
> > +		return;
> > +	}
> > +
> > +	return compact_do_raw_lock_irqsave(lock.lock, flags);
> 
> You don't need the return statement here (and you shouldn't be returning a value at all).

Yes, agree, will fix in v2.

> 
> It may be cleaner to just do an if-else statement here instead.
> 
> > +}
> > +
> >  /*
> >   * Compaction requires the taking of some coarse locks that are potentially
> >   * very heavily contended. For async compaction, trylock and record if the
> > @@ -502,19 +562,19 @@ static bool test_and_set_skip(struct compact_control *cc, struct page *page)
> >   *
> >   * Always returns true which makes it easier to track lock state in callers.
> >   */
> > -static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
> > -						struct compact_control *cc)
> > -	__acquires(lock)
> > +static bool compact_lock_irqsave(struct compact_lock lock,
> > +				 unsigned long *flags,
> > +				 struct compact_control *cc)
> >  {
> >  	/* Track if the lock is contended in async mode */
> >  	if (cc->mode == MIGRATE_ASYNC && !cc->contended) {
> > -		if (spin_trylock_irqsave(lock, *flags))
> > +		if (compact_do_trylock_irqsave(lock, flags))
> >  			return true;
> >  
> >  		cc->contended = true;
> >  	}
> >  
> > -	spin_lock_irqsave(lock, *flags);
> > +	compact_do_lock_irqsave(lock, flags);
> >  	return true;
> >  }
> >  
> > @@ -530,11 +590,13 @@ static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
> >   * Returns true if compaction should abort due to fatal signal pending.
> >   * Returns false when compaction can continue.
> >   */
> > -static bool compact_unlock_should_abort(spinlock_t *lock,
> > -		unsigned long flags, bool *locked, struct compact_control *cc)
> > +static bool compact_unlock_should_abort(struct zone *zone,
> > +					unsigned long flags,
> > +					bool *locked,
> > +					struct compact_control *cc)
> >  {
> >  	if (*locked) {
> > -		spin_unlock_irqrestore(lock, flags);
> > +		zone_unlock_irqrestore(zone, flags);
> 
> I would move this (and other wrapper changes below that don't use compact_*) to the last patch. I understand you
> didn't change it due to location but I would argue it isn't really relevant to what's being added in this patch
> and fits better in the last.

Thanks for the suggestion. Totally makes sense to me, will do in v2 as well.

> 
> >  		*locked = false;
> >  	}
> >  
> > @@ -582,9 +644,8 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
> >  		 * contention, to give chance to IRQs. Abort if fatal signal
> >  		 * pending.
> >  		 */
> > -		if (!(blockpfn % COMPACT_CLUSTER_MAX)
> > -		    && compact_unlock_should_abort(&cc->zone->lock, flags,
> > -								&locked, cc))
> > +		if (!(blockpfn % COMPACT_CLUSTER_MAX) &&
> > +		    compact_unlock_should_abort(cc->zone, flags, &locked, cc))
> >  			break;
> >  
> >  		nr_scanned++;
> > @@ -613,8 +674,12 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
> >  
> >  		/* If we already hold the lock, we can skip some rechecking. */
> >  		if (!locked) {
> > -			locked = compact_lock_irqsave(&cc->zone->lock,
> > -								&flags, cc);
> > +			struct compact_lock zol = {
> > +				.type = COMPACT_LOCK_ZONE,
> > +				.zone = cc->zone,
> > +			};
> > +
> > +			locked = compact_lock_irqsave(zol, &flags, cc);
> >  
> >  			/* Recheck this is a buddy page under lock */
> >  			if (!PageBuddy(page))
> > @@ -649,7 +714,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
> >  	}
> >  
> >  	if (locked)
> > -		spin_unlock_irqrestore(&cc->zone->lock, flags);
> > +		zone_unlock_irqrestore(cc->zone, flags);
> >  
> >  	/*
> >  	 * Be careful to not go outside of the pageblock.
> > @@ -1157,10 +1222,15 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
> >  
> >  		/* If we already hold the lock, we can skip some rechecking */
> >  		if (lruvec != locked) {
> > +			struct compact_lock zol = {
> > +				.type = COMPACT_LOCK_RAW_SPINLOCK,
> > +				.lock = &lruvec->lru_lock,
> > +			};
> > +
> >  			if (locked)
> >  				unlock_page_lruvec_irqrestore(locked, flags);
> >  
> > -			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
> > +			compact_lock_irqsave(zol, &flags, cc);
> >  			locked = lruvec;
> >  
> >  			lruvec_memcg_debug(lruvec, folio);
> > @@ -1555,7 +1625,7 @@ static void fast_isolate_freepages(struct compact_control *cc)
> >  		if (!area->nr_free)
> >  			continue;
> >  
> > -		spin_lock_irqsave(&cc->zone->lock, flags);
> > +		zone_lock_irqsave(cc->zone, flags);
> >  		freelist = &area->free_list[MIGRATE_MOVABLE];
> >  		list_for_each_entry_reverse(freepage, freelist, buddy_list) {
> >  			unsigned long pfn;
> > @@ -1614,7 +1684,7 @@ static void fast_isolate_freepages(struct compact_control *cc)
> >  			}
> >  		}
> >  
> > -		spin_unlock_irqrestore(&cc->zone->lock, flags);
> > +		zone_unlock_irqrestore(cc->zone, flags);
> >  
> >  		/* Skip fast search if enough freepages isolated */
> >  		if (cc->nr_freepages >= cc->nr_migratepages)
> > @@ -1988,7 +2058,7 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
> >  		if (!area->nr_free)
> >  			continue;
> >  
> > -		spin_lock_irqsave(&cc->zone->lock, flags);
> > +		zone_lock_irqsave(cc->zone, flags);
> >  		freelist = &area->free_list[MIGRATE_MOVABLE];
> >  		list_for_each_entry(freepage, freelist, buddy_list) {
> >  			unsigned long free_pfn;
> > @@ -2021,7 +2091,7 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
> >  				break;
> >  			}
> >  		}
> > -		spin_unlock_irqrestore(&cc->zone->lock, flags);
> > +		zone_unlock_irqrestore(cc->zone, flags);
> >  	}
> >  
> >  	cc->total_migrate_scanned += nr_scanned;
> 

