Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0185D3EE99
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 410D96B02C5; Thu, 22 Jan 2026 12:17:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E8586B02C7; Thu, 22 Jan 2026 12:17:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314C96B02C8; Thu, 22 Jan 2026 12:17:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1DEC76B02C5
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:17:24 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B13258B98C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:17:23 +0000 (UTC)
X-FDA: 84360255966.17.5DFC65B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E2DDF120002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:17:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HwNktGx2;
	spf=pass (imf29.hostedemail.com: domain of "SRS0=ucPx=73=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=ucPx=73=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769102242;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5pAyNP9u3hX6L+5sv0NSClnZu96SciSFz2fdcLiGdQc=;
	b=0PQvRNlnHphmCl3+lf4aHYLLcBhpMHqrBDepd3CDHO8mFHqg293sGsu8Mw7fUFCUxmkPkm
	KRcRD79I6MOygoGIqhs5wzQgzVVG1uE9bwcdc6akzg+ehpfbB7CCBQw+Iw/lW4toQ4yfwE
	18HtqfSNCQ8+M0MrsjMUAnaFc5kEQow=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HwNktGx2;
	spf=pass (imf29.hostedemail.com: domain of "SRS0=ucPx=73=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=ucPx=73=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769102242; a=rsa-sha256;
	cv=none;
	b=frl6nY2UC+3fFu2CRcxTrDH2I4mQ6PUD4WqFgstBuK5Nk7X5TLfsNfaavKik6L5afaQA/V
	gs7vVyHlDcNSTb6oEs/8GL56k4hDwWwg5PSejWXz/1NE6SZ+OyyWALgNIEibMhpqudXW9x
	HL9Z1Pl78G6FeXvKfFkOB5ICZvg8NYU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F02FD42D69;
	Thu, 22 Jan 2026 17:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE757C116D0;
	Thu, 22 Jan 2026 17:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769102240;
	bh=A9cQRSLz8v2njv45CmUGC/ju5GGeQ9vPP+m1Rqf8v0g=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=HwNktGx2wc5ES0Aj7U0G4a5y9BLRgWYSHcsQT3m8DkCleGR39McCiFdLfNYZjv/Ho
	 KgrESmjedNz6CmlHIOzobCAOzrF24N623Wr2m2LwzKmtKpGcu7y75F6owqVqzrvEfT
	 XditdUDtZqWsd/sp6D7kbGk1ncXUp80NG9cuyxjnsC3LkBGshvSjij/Ys8ebX+u4jc
	 0tDnKoCZyHNK68DN/QadDj9aodF5MoPaDIeNEbOFybaECD3TIP00QSpzkzOx6nrzv5
	 lsVkEkONqhS2sTWozRh01IvQ0h/KF1uRAOuhn8dV8kKMhqkuI8w2SW9ErsZfHFrZLy
	 1+AhAnvEkC39g==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 63F9BCE0B6E; Thu, 22 Jan 2026 09:17:20 -0800 (PST)
Date: Thu, 22 Jan 2026 09:17:20 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Waiman Long <llong@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH] mm/mm_init: Don't call cond_resched() in
 deferred_init_memmap_chunk() if rcu_preempt_depth() set
Message-ID: <61690638-e72d-4d8e-9687-9f4da3ede970@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260121191036.461389-1-longman@redhat.com>
 <20260121114330.6cd34b4732c7803f1720f0ba@linux-foundation.org>
 <0e385146-67a3-4fdd-b119-059caba8c5f0@redhat.com>
 <13d0b8b5-1ba7-4a3e-a686-13a7b993d471@paulmck-laptop>
 <20260122075747.uSLrSJez@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122075747.uSLrSJez@linutronix.de>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E2DDF120002
X-Stat-Signature: h6rsrb7nb4ghowubetfxt1bd1gweri1a
X-Rspam-User: 
X-HE-Tag: 1769102241-307470
X-HE-Meta: U2FsdGVkX19zuGCX/pbbopDHSHL2msrFb6khQwhYbdJkyVLteGxMChdJlYgBAkV7OtWzkVf+djtwcq+2KHuk8+bx1Gi9fPzuVg0hQFHtNgnxK96G0jSZpTqq58aO3i1s+foup+qiYXs6QTWBVSZa9CgFVKlL8y3eUUrlsNcZoT5UReOvBr9RpHJGUs4LPKL+1KGqctbNbqHeTihwldyMZFFCdTqMt4VWcCOflVsnEDgYuS7CTwc/dTi/mwE6oZsVaJZ1DU4x9n52riufFZNHklkLg3/I6GByoTSz6srEyxJ6e/jUADQlMKRaxI/ZfUhPFu5P+cUCatjoOm9Q4aGBLTPt3UN7S9jmTGVsDoxoJ+6EqZOGaU8LaZw4IuAgupypBx+cVJBuLPZ1avpDBL7ziTwf895rqDgj+vLrr8JVF390xE/Cw+qJ2vZM/YwPKhyvGT98x7f83kTMz2woFfA2FtXo+/p9JnXUKgU82R7Dun6bOBiqodmPa9dvur8Eocwe7WhL/fiZzNZwfnXUtd8frm341qnsiW4OXQPAN3fVAsEjj5xwKQiDxAe0MRnKyHvzgcpXFUNMD1iPSmLe7odHN5YPmaTKCLdDbBNYJZoAS1dKEdMe0pXBYkSzau8JX0jpbRpW5OI6I4ub51AXxAWVDYZZwQVrMaXhmva4kRbq49NdxeNGCQB0LRXQ4RHlmkLkAoSRBicUJIyIMOZVwkbizP5xljreCa9zqGGZbQ67wqjC7p3rL8ggZyAaeMzjpVr9sFqII7GE4d3f9FKvxDjyCiNBOtMUT1SAM5F5AbH9xZrgsPurPA0Jx7a2LsccmyslK2OcPNzbPP7pm80EsKZsuNjYCmk0p61xCuql/6W67Fui69Xq4rSJmK0cdDV/Wb7gqMP0lDXOxnwU+j+3atQZlq6Et5DzILll8N4zlM6IkZK9CgFl/998QZlyEgbuBBEqlzpz+DTUn4crhDnszRe
 fXNgy9ye
 mcASEJdJtSDbhDFmVEIhrxLMJhQU87jSPnm4S62i34tc1ZIfB2iY84j34eGzW95Sh8Ta5hqtN8o1xagLuR8juf5bq8plQrXu1TPHE6zftX/TAkwykfqdsvhMxWIg7SghukQrKBXwwKACodTFTjU9cFkwcDwWJrjPY74XOhHVLQSTdP+e97eCtg00CmOMPwuWJBc7H9cW48c0L3tTnbU/cVxSK1G4zVV1ib7FmUykwnwSc+HBuRMD7VGGfAlcGXqqV7eCf8tNzKLhtt3VE4/CCEsRRWHN7vMaMqpTCj53tzTtRzBl97ua0O08xL5hw7KetkKyxwF1//rzkXAJ6/6rDfvXBz6qPLmhx+gpSxb0JZ5CVdgekV6PFPoMHi2zMsHQaha74iuRuih3oFG+Ynb+6Uk5vGLrFfLBRyAlF57X5V7KrPIqD3/EPT7/16Df9Q/otPDtI/QSZh6rz5HcIQSoNJrICybwAdiHwwV7KIVf88TYLmjS97U+QMKWdq1KwQ9cIfLLt7RZZOXAfw5W5nJNEc42QNyPvyXNMnUYqf2QFK6iYQDvv72KDUkMLZCnEIaGfdx/y8IhX+pACYctqfe4tV/nHR70xYw1n1teP4axuRM3JbeQci3jrjZXhrpld+l1ShPNwhtPePUKGNeTwm0iWFjh4/8/KTlcLNLc7tUM1ZQkCs2+JCMmD14UJnPOlIugYQEPi0hGiIjHnG8miIK3onxzaiV8/d3HDjrpt8JgXlqPIlP502h9CWhmpD1FzhMejSd8AmszXV5MLfteRRzxVrQK0gQ5d3NCRDC2X007X8NPyfDI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 08:57:47AM +0100, Sebastian Andrzej Siewior wrote:
> On 2026-01-21 13:27:32 [-0800], Paul E. McKenney wrote:
> > > > > --- a/mm/mm_init.c
> > > > > +++ b/mm/mm_init.c
> > > > > @@ -2085,7 +2085,12 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
> > > > >   			spfn = chunk_end;
> > > > > -			if (irqs_disabled())
> > > > > +			/*
> > > > > +			 * pgdat_resize_lock() only disables irqs in non-RT
> > > > > +			 * kernels but calls rcu_read_lock() in a PREEMPT_RT
> > > > > +			 * kernel.
> > > > > +			 */
> > > > > +			if (irqs_disabled() || rcu_preempt_depth())
> > > > >   				touch_nmi_watchdog();
> > > > rcu_preempt_depth() seems a fairly internal low-level thing - it's
> > > > rarely used.
> If you acquire a lock from time to time and you pass a bool the let the
> function below know whether scheduling is fine or not then it is
> obvious. If you choose to check for symptoms of an acquired lock then
> you have to use also the rarely used functions ;)

Agreed.

> > > That is true. Beside the scheduler, workqueue also use rcu_preempt_depth().
> > > This API is included in "include/linux/rcupdate.h" which is included
> > > directly or indirectly by many kernel files. So even though it is rarely
> > > used, but it is still a public API.
> > 
> > It is a bit tricky, for example, given a kernel built with both
> > CONFIG_PREEMPT_NONE=y and CONFIG_PREEMPT_DYNAMIC=y, it will never
> > invoke touch_nmi_watchdog(), even if it really is in an RCU read-side
> > critical section.  This is because it was intended for lockdep-like use,
> > where (for example) you don't want to complain about sleeping in an RCU
> > read-side critical section unless you are 100% sure that you are in fact
> > in an RCU read-side critical section.
> > 
> > Maybe something like this?
> > 
> > 	if (irqs_disabled() || !IS_ENABLED(CONFIG_PREEMPT_RCU) || rcu_preempt_depth())
> > 		touch_nmi_watchdog();
> 
> I don't understand the PREEMPT_NONE+DYNAMIC reasoning. irqs_disabled()
> should not be affected by this and rcu_preempt_depth() will be 0 for
> !CONFIG_PREEMPT_RCU so I don't think this is required. 

If touch_nmi_watchdog() is fast enough that calling it in a potentially
tight loop is OK, then agreed, this is not required.

But maybe I should redefine !PREEMPT rcu_preempt_depth() in terms of
preemptible() or some such.  Thoughts?

> > This would *always* invoke touch_nmi_watchdog() for such kernels, which
> > might or might not be OK.
> > 
> > I freely confesss that I am not sure which of these is appropriate in
> > this setting.
> 
> What about a more straight forward and obvious approach?
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index fc2a6f1e518f1..0b283fd48b282 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2059,7 +2059,7 @@ static unsigned long __init deferred_init_pages(struct zone *zone,
>   */
>  static unsigned long __init
>  deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
> -			   struct zone *zone)
> +			   struct zone *zone, bool may_schedule)
>  {
>  	int nid = zone_to_nid(zone);
>  	unsigned long nr_pages = 0;
> @@ -2085,10 +2085,10 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
>  
>  			spfn = chunk_end;
>  
> -			if (irqs_disabled())
> -				touch_nmi_watchdog();
> -			else
> +			if (may_schedule)
>  				cond_resched();
> +			else
> +				touch_nmi_watchdog();
>  		}
>  	}
>  
> @@ -2101,7 +2101,7 @@ deferred_init_memmap_job(unsigned long start_pfn, unsigned long end_pfn,
>  {
>  	struct zone *zone = arg;
>  
> -	deferred_init_memmap_chunk(start_pfn, end_pfn, zone);
> +	deferred_init_memmap_chunk(start_pfn, end_pfn, zone, true);
>  }
>  
>  static unsigned int __init
> @@ -2216,7 +2216,7 @@ bool __init deferred_grow_zone(struct zone *zone, unsigned int order)
>  	for (spfn = first_deferred_pfn, epfn = SECTION_ALIGN_UP(spfn + 1);
>  	     nr_pages < nr_pages_needed && spfn < zone_end_pfn(zone);
>  	     spfn = epfn, epfn += PAGES_PER_SECTION) {
> -		nr_pages += deferred_init_memmap_chunk(spfn, epfn, zone);
> +		nr_pages += deferred_init_memmap_chunk(spfn, epfn, zone, false);
>  	}
>  
>  	/*
> 
> Wouldn't this work?

I will defer to the mm guys on this question.

							Thanx, Paul

