Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3ABA606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=j5bWsZdV
Received: by kanga.kvack.org (Postfix)
	id CAE626B05DB; Wed, 18 Nov 2026 16:21:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85856B05E0; Wed, 18 Nov 2026 16:21:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9BB86B05E1; Wed, 18 Nov 2026 16:21:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A09B6B05DB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:21:25 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 67F7D1608C8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:21:24 +0000 (UTC)
X-FDA: 85449510888.06.C4AAEDE
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7E0F916000C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:21:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=j5bWsZdV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795036882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b5FVwTr0+ioK5OPo7LsDsfPzhpde0ciar5bplP2bt1E=;
	b=ZIUZ3RNWL92zxhvEE2OqTfxQou+z/Sheikxsr9L2y8Dcr2BONYPA173O4M5broyjYDk8rm
	AsMS39aHL1eSwdTCd5zBY7Q1UANbJ+jHk+szzgpbveYHIVRQszn6KwKGA58KIeWruH5wl2
	J8BNGDT3iuvThc1PvgTSqTy07l1C57o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=j5bWsZdV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795036882;
	b=oIaM2oKkYTfQYGDU1sVGfeq02ugK58q4yDOMSKyGYNCimaQzUAp95+Vz3j33fTuYH9tew2
	nWr3/btEHBGfCXVmHWQFwyQpgpymusyeMnnlLbYBiFs7nXUfigq3PjO8d6j8xhi8McJI20
	sOLJ1Oj//GDbV5FMIGGhTs+elU0wcqE=
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-43bf9548df4so1565863fac.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795036881; x=1795641681; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b5FVwTr0+ioK5OPo7LsDsfPzhpde0ciar5bplP2bt1E=;
        b=j5bWsZdVlDjh2eMAu9CVfdCzVrZgATX+xuRt9b+rYDyIvm/jJv9vKg5XQyfx+0abjc
         4/ubHzSdX4CoAFU+QPVOcz+qtzta8Yuv0Z/zijjB9RxEF43x0x5GOP3HWy0TwKGkm0ts
         5z33pkHnaZkh5gHGV/VoTrBjA+cag6t9g03QRfVJgLev8P7jJKbFyLhko+Sq0Gnr+H/O
         Ew6YLyISrDT1nyZekdHCxAfhyrpAjG0xkgg61KqW9gBaYuFwermiyA1p2daMXMLa6ofR
         jZdSzX1IpOXUmhvRvRR+5kqAwESKel13XxKaRcrretJ5DFyRA3bHa9w1Rpqvv05JtJ2A
         G8uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795036881; x=1795641681;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=b5FVwTr0+ioK5OPo7LsDsfPzhpde0ciar5bplP2bt1E=;
        b=JNfm2CzKGaxBpBnDPQl3Mcev8/Lu7YHf2icQSkdU5DfU5q5WXClYYeorc7XVzVKEvE
         uRbzef4qvbAPUhGaiSFdZV3DPLYXQu+hAq1f3g81/OkYrKoAivKMMKnDoSC2sKBitfYL
         WMCLhJrCs86j82XfNFb3MdZUJ/I10Bd/4b6tG3RTPvOpR+0U5a5LUd7GII+/qSs95VKS
         kULGgEtQtPTcrSqEOqOj9zOwGnXFFjqE6eGp5K/AyTrPGfchJ8lmxstxGfdk/+b+TQQg
         OjfE0nuT0XUyd7Lp/rgOa7/8WHGvIDOgizdRO8vJN/uboxZWUDA8TgavbkVqV7JIY3Zp
         CJ+A==
X-Forwarded-Encrypted: i=1; AL+hErEsMeooXssaL2q6AQ5YB6H/xkqqB2rh9kCnp9WaoxkHrJha6p35PAAiPoLyv0oVd/Ku6M52Wz5aUQ==@kvack.org
X-Gm-Message-State: APuU4Z88fwPI77yJXTCJe9FjWUIXok0zU6WuJx12TQTeKEu+gRnQRmto
	gqlowrraMpB2jNpeBRbE+Fqb6gl5OOHMUkQpd555wN3cDlY2fISp03z/
X-Gm-Gg: AYBFou1RVrTBZLYxCXVmZTvLDP5kmetR8+bAt2BIQSuEEfvKBV4nPQE9Wt63c/sxNku
	k0eU33yTKUuuYl+daKwqojHPEAFcx0zSzN4xQ5ptSxrHAeeus0JNOwhNCRNzqUWjX2qkrbI9roB
	s5+FU3SFonBQYPURAGr6NuuOzFIsYREqgHC/eho0DbAWV90egLkMH/CVtKklz2Gq5xVKSwhRUWo
	UmtCIFkYv4UvY4n7dhbgKYE/0xaQIjgJUza5VSZxPj4gQmXt+BzHae6Ato2EQKBl6KPcC41BeO3
	2SVvsvA/VYdCMvAbkYR8oPoB7LZA9K2mMRxlveC+UFbs1l7+f9aboILbkRoRkLIlR55ifu2amve
	BpyFJNb7j1Cu/pZo7q7Or+ihgWy7D1WZw0+lvFJOGd/4ZXf2sjsjLlLORPsEbXJpJp8zOR6BTzM
	++fkBJDbKNjAuXnbNhD9k7RjZxX/moCm+VReC2nGULZXyxBdDgJM+h19989nPMwN3sdhpAJeubU
	2Lkviml5xQef8LulDr8xWjwS69QJM9zH3i0kQRjhTPHNa9ay+db05oy01lFYTTfcntmJ/yfvVSR
	WH5bC+D8E7Avl4I/ZqkEgflUrbcH2LjOk/CjzSJBlNVgKp4sblhDq87W/0E4
X-Received: by 2002:a05:6870:262:b0:4a7:6c8a:f47f with SMTP id 586e51a60fabf-4b75d26dc2fmr3227807fac.37.1795036881334;
        Wed, 18 Nov 2026 13:21:21 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4f::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4b744928389sm3266157fac.12.2026.11.18.13.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 13:21:20 -0800 (PST)
Date: Wed, 18 Nov 2026 13:21:20 -0800
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/3] mm/page_alloc: move the kswapd node skip check
 into a helper
Message-ID: <av4V1AzQXSZbtSei@devbig011.atn3.facebook.com>
Mail-Followup-To: Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261116232346.788145-1-joshua.hahnjy@gmail.com>
 <20261116232346.788145-3-joshua.hahnjy@gmail.com>
 <bf8692ab-f5b6-4ffe-b5ad-02ad59182cc0@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf8692ab-f5b6-4ffe-b5ad-02ad59182cc0@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7E0F916000C
X-Stat-Signature: kty3n5amzmzegjp5w7k6us7tbqgwkika
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795036882-351827
X-HE-Meta: U2FsdGVkX1+zQjploGvKJiF3flSPehSAKBY6YI55FO5X0SEcY+ztPGNh1+EA7qFvPVO+UjG+Vz8L8ZG4VZRYE3w0ZqQMxyKLymhAk8XvgWkaPUWkysLBBCUOF01mrRVttmm/gmU19DUbR1IAln0uf6zkpPckU6/KXd1kAeNrrWU4M/msWHJjcdoQQU4y63Yw8v1Efz/EkGJrUZBf0JIvpRGZpg41KAtbz21rrZEEeX20DQLDXOEQ/GNyfL9jW7rAwaGUKKCscq7mCZZnwC3ap8IAzFj9DArERusy4KjhOcHwIoPs627VU+T7aEQUhlJ4T86bLO/PO9M6tmEcqStrTZPDzaqNCYdvTgXkGgjVRTvPBQAeNQLCdDGUUj5j0uKa+S8CS8une+6DA4GAE+MSL/VnPyc4/7sO09uG1VGo8ofP0RKN2BvXi+oK1NfDsK7sJQNUblONdO5OZ++OF2NKqkyCBZ59GoxF1VByXwwSRp3pVjrpdoKpOW6VfCS8Z81J3pmzNHkDc3/aqSO7CjJ6QHWi0dscTk3ZaMOaaVtYMDL55ao3KZjf0KsznSwX2ahD8LTvQI94+L2hv3ymgxL2rC2O7g51/UUffeiOlkckGkTTzi7Oapg+b7jnYgOmr67a9+U2L7HdupKILQ8rV6uz0ybNOV42VmdCdsJDSmaLKiK9CqPmx3sEzMROpHOvJgZciL7Mrcf/WKnIZRYz2Mqi7k/h1yZh7tZNjT06OlyLCjoR3ygSUEaL62ZoMQb5V/BhtvIyKHHHZhZ6Qqv5utm6zxMYwJB1uijeK0OiNRq54H7HWrqNkbtZ37i9skdYpPXD05r605V1/mq0xu32Re/R75LxU/ba6ffqp0pYr8YXfE14PKVtIH8aRB+GtNmrXEgRR0VxzBSlW6oQ47pdPNAmJesJ1ft9QOVr42ITUf3itodfuUc5h68PRLFPuEHbY5XQd23gmu+n4hYEwsdOW+x
 MjOVTutE
 VQQd02dLS8/fefcPqFMCUcGp0UiFREv4KNkqjU6aEaSzJQoZI1pGnYsT4fzjU/bqJYdZZQ1vg1l48dU6KpPu5Tgb/klMQ2K6HoUCWXrjkDC1Db/rB5Fmqex6Cm0NCGY8T6B/KN/hNAOzBzdTHE6/NMsHEd+oJfVHd2UNz/M2s9oxDDo2oU7EBx2V4tgDfFaqJKp8R9Bu0YZGZEa4OKM//WMDR8lycTuzMNEKm7XM7Hv27d/QVolWBcFIvWIKJNUHGMitUn/xf9VhwCBj56lIVhxJHX66o3uPwsBkd07JEI9UlobgDy/eESUDDzw+m8Z8NDwpGLz1Y+RbdYDV1bd8TVpmp0yry78T66jNZ2fLx2MN+x48+A6ekT3z+HsP+EAHhvFq6GHzP7ObP83AmP8FsuDttwGuat88D9zATPZU1wvQEPARhc+a/t1fR66RbddGBwZrLx8xU5urPtJhNMgeY7zLBOiKCeoo9enuM+PIjvWsZXgVU4MKWrFIjQ9F9nwDbLHU95Qhy/bc8JxG+kX4R9RcVFdJMZISuqsApXFVA4UPFnKCObc7iFJLqnZLTWklpLizeFmqLb+iP//oGKbd9hPISYRClEHMp4Ay5BvQBSqSR05q0Mrbu6LMhBlC17VuIxmKqEJAfwD5YBw/F6oqWwwx/cY/QoR45dZSnXcBo44VHnTu0uIG0/9ySsSIXjHPm4o4z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 09:16:51PM +0530, Dev Jain wrote:
> 
> 
> On 17/11/26 4:53 am, Joshua Hahn wrote:
> > get_page_from_freelist() checks many conditions for each zone, often
> > with a big comment block explaining the conditions.
> > 
> > Move the kswapd check and its comment into should_skip_kswapd_zone() to
> > make the zone iteration cleaner to read.
> > 
> > While moving this, also resolve a checkpatch warning which complains of
> > a waitqueue_active() call with no corresponding comment explaining why
> > the lockless use is OK in this case.
> > 
> > No functional change intended.
> > 
> > Reviewed-by: SJ Park <sj@kernel.org>
> > Reviewed-by: Chris Down <chris@chrisdown.name>
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Tested-by: Chris Down <chris@chrisdown.name>
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> 
> Thanks looks better.
> 
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> 
> But see below.
> 
> 
> >  mm/page_alloc.c | 47 +++++++++++++++++++++++++++++------------------
> >  1 file changed, 29 insertions(+), 18 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 4d829e5eac49d..43929faffb989 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -3785,6 +3785,32 @@ static inline unsigned int alloc_flags_cma(gfp_t gfp_mask)
> >  	return ALLOC_DEFAULT;
> >  }
> >  
> > +/*
> > + * If kswapd is already active on a node and the zone is below its kswapd
> > + * watermark for this request, keep looking for other nodes that might be idle.
> > + * This can happen if another process has NUMA bindings and is causing kswapd
> > + * wakeups on only some nodes. Avoid accidental "node_reclaim_mode"-like
> > + * behavior in this case.
> > + */
> > +static bool should_skip_kswapd_zone(struct zone *zone, unsigned int order,
> > +				    const struct alloc_context *ac)
> 
> Make this inline? This is the very hot page allocator code that's why :)
> I may be overthinking but in page_alloc.c I do see functions with similar
> size being marked inline.

Very reasonable! I think it's just a few checks and bitwise comparisons
at most (apart from the zone watermark checks). I'll make that change.

Thanks Dev!
Joshua

> > +{
> > +	unsigned long mark;
> > +
> > +	/*
> > +	 * This means kswapd is asleep, so don't skip the zone. This is a
> > +	 * lockless check, since a stale result only affects zone selection.
> > +	 */
> > +	if (waitqueue_active(&zone->zone_pgdat->kswapd_wait))
> > +		return false;
> > +
> > +	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
> > +		mark = promo_wmark_pages(zone);
> > +	else
> > +		mark = high_wmark_pages(zone);
> > +	return !zone_watermark_fast(zone, order, mark, ac->highest_zoneidx, 0);
> > +}
> > +
> >  /*
> >   * get_page_from_freelist goes through the zonelist trying to allocate
> >   * a page.
> > @@ -3796,9 +3822,6 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
> >  	struct zoneref *z;
> >  	struct zone *zone;
> >  	struct pglist_data *last_pgdat = NULL;
> > -	enum zone_watermarks kswapd_watermark =
> > -		sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
> > -		WMARK_PROMO : WMARK_HIGH;
> >  	bool last_pgdat_dirty_ok = false;
> >  	bool no_fallback;
> >  	bool skip_kswapd_nodes = nr_online_nodes > 1;
> > @@ -3865,22 +3888,10 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
> >  			}
> >  		}
> >  
> > -		/*
> > -		 * If kswapd is already active on a node and the zone is below
> > -		 * its kswapd watermark for this request, keep looking for
> > -		 * other nodes that might be idle. This can happen if another
> > -		 * process has NUMA bindings and is causing kswapd wakeups on
> > -		 * only some nodes. Avoid accidental "node_reclaim_mode"-like
> > -		 * behavior in this case.
> > -		 */
> >  		if (skip_kswapd_nodes &&
> > -		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
> > -			mark = wmark_pages(zone, kswapd_watermark);
> > -			if (!zone_watermark_fast(zone, order, mark,
> > -					ac->highest_zoneidx, 0)) {
> > -				skipped_kswapd_nodes = true;
> > -				continue;
> > -			}
> > +		    should_skip_kswapd_zone(zone, order, ac)) {
> > +			skipped_kswapd_nodes = true;
> > +			continue;
> >  		}
> >  
> >  		cond_accept_memory(zone, order, alloc_flags);
> 

