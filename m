Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B169CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FFB56B0088; Wed, 14 Oct 2026 13:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B03A6B008A; Wed, 14 Oct 2026 13:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C9B26B008C; Wed, 14 Oct 2026 13:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19F686B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:43:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B248A83D6
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:43:38 +0000 (UTC)
X-FDA: 85321954116.04.0CF23C0
Received: from mta1.migadu.com (out-32.mta1.migadu.com [95.215.58.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 54F0080008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:43:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZfXRQfHQ;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.32 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791999816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k1GONzJSbtExU6phhV2NYjClO42zv3bBRMvXDAGBgJU=;
	b=bTK/Wd7Ic+xIzkbFgTjYufwcwc9e7SOvTGeUer6RiKZfR/sHEQ63z32c0zBucAQvDheTF9
	r2JjwwmL7E7yfEy59Ou/XaHUtVXlNcIUYzpUt9iX5oeiggPanGmmO244d5ICVJomWaDsDI
	abi3PBaZNEnr+hBW0I8pffBBs5SAbYI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZfXRQfHQ;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.32 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791999816;
	b=yFZI8XlP2tVK0Nn8xd3GAgF+UCTgzDHTWUn7zA3t9W/KjTvog6xiYbgZS8KSi6ldnwsX/O
	jf8lYciGrdUZ01rEagYXY6a6tN1oMQoCRJ1j1m3a54+S1N2xL5mERgNe5GCJ/p0c0TtmVR
	VPY8SmKo6cAQaMM8kJTrwSCL2H84VM8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=q5POMpCCLN/ewLuDa3kIQXsVdH+S/vIBvv/bj14RqT8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791999814; v=1; x=1792604614;
 b=ZfXRQfHQzp04Jmef1UvxTF9HZV7RBFkJ2QRBGU9jU0rMZ1bQvydkJLKzksVjNV2JkYkrPJG4
 QETks8hRgWzhIVl6Osy/jlQUeL7JZRi7cESf8c9/zqx3OulfxnLXwWkFt9MpI4g7J43l/tx63Uc
 /uFq+fFOGm+TtXapaaKyEZS4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id eff8696d1074c0e2;
	Wed, 14 Oct 2026 17:43:34 +0000
X-Mizu-Trace-ID: eff8696d1074c0e2
X-Migadu-Flow: FLOW_OUT
Date: Wed, 14 Oct 2026 10:43:33 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 5/5] memcg: simplify high limit handling after a
 charge
Message-ID: <as-sE3hZqFA_Wb5B@linux.dev>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-6-shakeel.butt@linux.dev>
 <as9rj8KoF1oKO8rE@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as9rj8KoF1oKO8rE@tiehlicka>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 54F0080008
X-Rspam-User: 
X-Stat-Signature: 71k4f3jdo6xk1zcrctoxp6qzxjomamks
X-HE-Tag: 1791999816-501073
X-HE-Meta: U2FsdGVkX1/GhAF8cjWXz9RDJzwgb8vQzW7VmEsqKWuKOEDGzre4PP2h1b2OfwDGtNI6EMUgzzAWizjrZ8WXNl75qCm1UllGjQIRN3OEEP9OMj0poIgltqeQegUzpUUizfoElYgWKjqyXcGxsYREyeFP/L7S/IzAooIVDVVZVzY7pzo7XboBA3HIS0/BgkpKgvcvlmrlqu0/EXhqDzb8UXkgKjidlNL4gY2ZTUVN4J/Ly7k43e+bagX1Uhk9tXuS1IsOawvGRqg520Pmv2Ua5MUE+R8LdSJvtZ5/d6FpZHsElhdsFaedIF3XiBYO/+GkncSB1Y1YFHzgeGClAkbFEcYLExGlKpHFFEqo0BWy1mUSPlmeuKORlFBEJvHTFpkO/ulU0puld4sonVlJ4+7MBRjhkEWLUf29XwLeezREjCj0iTtsgdVzWIYxIJUpOfZTpZjBtWKRHPOrZM3TK7kixX3rg1EkBirM1xFPRDlk4TG7VKcwbCJF5Cw/glIoCw/NuguBgIVIo9t5UIxbHACurPQTyKGy4Z7H/Hzwf2+h4xUHtunPNBVZDFE0K9XaRET+Q5yVTimq09rHEhhMkXRzBt0M++JCGlq/2wyQAvP2c95afRd9N3VnFuvGndtFZyKtuaySt1rp5aegVux0EvM84XdLRMb/pceQO+kCZ5GSetSqNi700ZhyGPk23Y9n49oXLy2xphkfyyjbl9JS3GSRWwnLRd7q1oe9fWMpAJCHVYae86LH7H0Ebc848wWFJjMtjpCyLgcMYd7rB8UDt6FERE1hYHWvrVulfu3+aGB0swFiwsJ1J7CmUvxoRAfG+FuCyIPPaX2M37CRPb3mZfw+0MBnLy7RsiakPzkfzE8A5a1KmN3k9ln2YlrjKw1YMSrUhKYJ7u5lmDRl7tjpew+C7uMT4LCzz6EVP5U0sWfO3m7UP2aRr5zT7LiqgJTI/Av8OP0MsObZ/AtNYPHB0Aw
 CgY2M0ZC
 DuX9TqPasxwawCsXIx34VEeBltPVV4VN66MIMMPFVKeVnbTVMS86HBS+Gt5jsq3FYesx4XpDgClOc6diO1Rfscu/H4WI0f7a+WpJjAEPvbucY19eKwg3SNiwjtVLJ31WG/gSsl4dStwX4Rv+vp6dIeHRMGoQZm/eyNPBnRuMe1duJ0QrjBh3AREPNQ7gjZJKeoPMv4O110v5vEoiE7kW/T9DkEUC8HNLNqBRFhCieEusSe17t//SlAbaq6lb7LGES0q5UlxhNbM+f2RM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 01:46:23PM +0200, Michal Hocko wrote:
> On Sat 10-10-26 14:09:57, Shakeel Butt wrote:
> [...]
> > -	/* Interrupts, kernel threads, and remote chargers stop here. */
> > -	if (use_worker)
> > +	/*
> > +	 * Use a worker for interrupts, kernel threads, and tasks whose mm
> > +	 * does not match the charged hierarchy.
> > +	 */
> > +	if (use_high_work) {
> > +		if (!iter)
> > +			return;
> > +		if (allow_spinning)
> > +			schedule_work(&iter->high_work);
> > +		else
> > +			irq_work_queue(&iter->high_irq_work);
> >  		return;
> > +	}
> > +
> > +	if (iter) {
> 
> Would it be much simpler to bail out on iter==NULL (i.e. nothing over
> high limit) right after the loop?
> 

I want this patch to not change any behavior. If we return here when iter is
NULL, we will skip a potential call to __mem_cgroup_handle_over_high() when
current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH. Though I agree that is
very subtle and most probably unexpected. If we decide to remove it, we should
do it in a separate patch. Actually I am working on a followup series where I
plan to remove the sync enforcement of memory.high and put high enforcement on
the code paths which can potentially do a lot of allocation within a single
kernel entry.

> > +		/*
> > +		 * Count the full batch so reclaim work and delay penalties scale
> > +		 * with the pages charged by this task.
> > +		 */
> > +		current->memcg_nr_pages_over_high += nr_pages;
> > +		set_notify_resume(current);
> > +	}
> >  
> >  	/*
> > -	 * Reclaim is set up above to be called from the userland
> > -	 * return path. But also attempt synchronous reclaim to avoid
> > -	 * excessive overrun while the task is still inside the
> > -	 * kernel. If this is successful, the return path will see it
> > -	 * when it rechecks the overage and simply bail out.
> > +	 * Earlier charges may have left high overage pending even if this charge
> > +	 * found no new overage. Handle it now if this charge can block, to limit
> > +	 * overrun while the task remains in the kernel.
> >  	 */
> >  	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
> >  	    !(current->flags & PF_MEMALLOC) &&
> > -- 
> > 2.53.0-Meta
> 
> -- 
> Michal Hocko
> SUSE Labs

