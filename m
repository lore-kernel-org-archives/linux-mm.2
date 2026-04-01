Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8023110F6FD9
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 15:44:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61316B0088; Wed,  1 Apr 2026 11:44:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D12676B0089; Wed,  1 Apr 2026 11:44:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C01166B008C; Wed,  1 Apr 2026 11:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB1C36B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:44:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 62F198C72A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:44:16 +0000 (UTC)
X-FDA: 84610408512.07.E711488
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id 79AE91C0012
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:44:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=HNEaaa3j
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775058254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MxBAS4YTt72TMZrDYJdny7nH8fv6qBkvO/lDqD+k4tA=;
	b=CgP800VJgbA8GN14dQtUwqs3anhEyY3UQLTCPbLoyD/DlEhgOPqY9HjQnUWmujgwVWYX1i
	AIeAuAvuqTtZur4CBbQWUOmGzjVneP7BOHZD1c0kiy8IidllR1xOh8iV4hrTPOYKomogwN
	nAsLiAFY+7l5d9gXJXo0RzKk+4Jh12U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=HNEaaa3j;
	spf=none (imf18.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775058254; a=rsa-sha256;
	cv=none;
	b=YGa7D4Gs/SD3eSJHyjiaAkKGHFbdPMHnVN3Sd/Ov1ZG2Zs1TOYOwyu87lIuKE/Y7dbMjuL
	izeiElmin4ZUJJywlaolN+Qx+dYVK6xnhWmXeQToLO+4at6FmcKrhkbqbPE4fMlgwvVdN4
	Lb6llBkQmDHj0+tAZ5kzRBRPLABHjTI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=MxBAS4YTt72TMZrDYJdny7nH8fv6qBkvO/lDqD+k4tA=; b=HNEaaa3jH/NeXpyDOGO153//jx
	44xxgKRQoLjCe0iYy7Zz1Zl7KGxpfv4AlxvYbNBQmiqetlmWa6dJSjcAAaH52FwjEw+42AU7j65Ca
	fmmf1Is+7CSvnnDVZG6wK3+fvn595Xs8sazwT89P6vrcOY/M/nYn1Fc9iMH9RMxf+XKdO5nE2tvVO
	osPeMAFeSzNfmItI6sZPabpFxHCBqSZ0Z9umPw84fadx/ftjPISpWD+QuqnFuKIF0fJF4GMaDw2O7
	q20WmxrlDGB6v8iC7xF/LwaYTADteT+ylMgj5xaFDYYRleOEcrXwaaVCwIr1sMCcf99FBdeayaSBK
	Z8uGRfwA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7xjb-0035ak-0s;
	Wed, 01 Apr 2026 15:43:58 +0000
Date: Wed, 1 Apr 2026 08:43:52 -0700
From: Breno Leitao <leitao@debian.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kas@kernel.org, 
	shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
Message-ID: <ac08dcv31J5_lAHs@gmail.com>
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
 <20260401152343.3294686-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260401152343.3294686-1-usama.arif@linux.dev>
X-Debian-User: leitao
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 79AE91C0012
X-Stat-Signature: ba4cfdcbtiz5kacqtdr8gwxcy9fhpwq5
X-Rspam-User: 
X-HE-Tag: 1775058254-644842
X-HE-Meta: U2FsdGVkX1+nLehe/9lyN+bxG2GQbghGHOuPQaSgiW+UrzZWvA5icsCee91WcbvUa1dMjgs7Cah4+LXZ5nd0TeMH/I8DPEi6H9I+qMYmFeyMMe2aPJMtsNnWsEKXWV+Eoc9xSrt0n0YUTSlWEAQ1Hj2r5gOdVfwMYltQ2BHNkuKu5bTuZRpd+vBT81w80sw/O7KRZvw8wd3mUQI+PL3pqFCukYzJYlwELWIx0YkS7FdlYs7IBR4AxrFkTHGEeZDgPFxOV0q59qN1oZzygcTtAJrnbowoI7qvwt0j2b2p+ZalHY+kFy7X1RAlO0xtUx57TZlR+RhYC0JazI+2/JzVZpYGaHUV3s4DEZYaCk5BJFxAS6Rjsd2phZU2nQVVTKkjxWlXC0GFHKg//KzcCQrSKxg7si+3R/jPHCn85QuuefrCttPWvS1BdgG4IYLZzWdoW0beuXz68PC5mhEG5pOPhiabkEVHpBcQ/sf9PRX7n33GrRu9DCHbJsV4eyOkueBYq56ZmGKrMQZuBQZ/tbh+eYMrSJ6dRnBz99Cz1ECdG93GvMG1jJ7Si5Lldq6JteebR+engxeIJkbIOF47BjiwbjIrjGlQEkaoOuVzJ3WcFcO1NRp8GLgLrN3tAJX2FNIdu3RW6d09F8ow+PsgYqJ8/DTa33n1gfWIJfQ/5HzdKyOa12M36Nvr/Pd2q08gBSAAI+0nGSnhSQoQYLSPJLzJHfSn6sv9ac0iTIoh8vhJm6GEoFX+eKPTXfOf8EciwvQoVhdPi4FuUaD9tbFUSIMSQIRiKhaKG+GM3MMcL7SmRo5957y+7vOGiGcElKWvgGEPNq1z0bq4N0bk4jzU80RNOHmtL7ZOa7Xg3heWjBNFSnVXAi/zyZjgNSf2vNwdKAamA9inr9DkRJHURGdJVAHxCzw6mtq3GYXkWkEeipTKTHLxcGki9jxHE3ht5YEg5AsoZgbC0uBliFLgqFp0fZe
 dk+IV4ir
 cIAPJgOWK1a3WHNTMaLJNmxVBqe16mSpIYUXDmuownoPnQ1RaniWppGmK1DRp2vIXgJype+8VHQqTH7+qv3iSDXFBZvmNo60oZ6IgX8tqQ0zE//1z2rU1+o2FNCOOUnJU5wlSB0sY8h6CM/obtNBnxtnBgd/sXQvXAhy4Rj94GCgF55r6p1yeU2tAMipBdBWZ9dFbKsxfqZYQoIeMDbLSIMy7Q4LjZ95Tk78O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 08:23:40AM -0700, Usama Arif wrote:
> On Wed, 01 Apr 2026 06:57:50 -0700 Breno Leitao <leitao@debian.org> wrote:
>
> > vmstat_update uses round_jiffies_relative() when re-queuing itself,
> > which aligns all CPUs' timers to the same second boundary.  When many
> > CPUs have pending PCP pages to drain, they all call decay_pcp_high() ->
> > free_pcppages_bulk() simultaneously, serializing on zone->lock and
> > hitting contention.
> >
> > Introduce vmstat_spread_delay() which distributes each CPU's
> > vmstat_update evenly across the stat interval instead of aligning them.
> >
> > This does not increase the number of timer interrupts — each CPU still
> > fires once per interval. The timers are simply staggered rather than
> > aligned. Additionally, vmstat_work is DEFERRABLE_WORK, so it does not
> > wake idle CPUs regardless of scheduling; the spread only affects CPUs
> > that are already active
> >
> > `perf lock contention` shows 7.5x reduction in zone->lock contention
> > (872 -> 117 contentions, 199ms -> 81ms total wait) on a 72-CPU aarch64
> > system under memory pressure.
> >
> > Tested on a 72-CPU aarch64 system using stress-ng --vm to generate
> > memory allocation bursts.  Lock contention was measured with:
> >
> >   perf lock contention -a -b -S free_pcppages_bulk
> >
> > Results with KASAN enabled:
> >
> >   free_pcppages_bulk contention (KASAN):
> >   +--------------+----------+----------+
> >   | Metric       | No fix   | With fix |
> >   +--------------+----------+----------+
> >   | Contentions  |      872 |      117 |
> >   | Total wait   | 199.43ms | 80.76ms  |
> >   | Max wait     |   4.19ms | 35.76ms  |
> >   +--------------+----------+----------+
> >
> > Results without KASAN:
> >
> >   free_pcppages_bulk contention (no KASAN):
> >   +--------------+----------+----------+
> >   | Metric       | No fix   | With fix |
> >   +--------------+----------+----------+
> >   | Contentions  |      240 |      133 |
> >   | Total wait   |  34.01ms | 24.61ms  |
> >   | Max wait     |   965us  |  1.35ms  |
> >   +--------------+----------+----------+
> >
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> >  mm/vmstat.c | 25 ++++++++++++++++++++++++-
> >  1 file changed, 24 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/vmstat.c b/mm/vmstat.c
> > index 2370c6fb1fcd..2e94bd765606 100644
> > --- a/mm/vmstat.c
> > +++ b/mm/vmstat.c
> > @@ -2032,6 +2032,29 @@ static int vmstat_refresh(const struct ctl_table *table, int write,
> >  }
> >  #endif /* CONFIG_PROC_FS */
> >
> > +/*
> > + * Return a per-cpu delay that spreads vmstat_update work across the stat
> > + * interval.  Without this, round_jiffies_relative() aligns every CPU's
> > + * timer to the same second boundary, causing a thundering-herd on
> > + * zone->lock when multiple CPUs drain PCP pages simultaneously via
> > + * decay_pcp_high() -> free_pcppages_bulk().
> > + */
> > +static unsigned long vmstat_spread_delay(void)
> > +{
> > +	unsigned long interval = sysctl_stat_interval;
> > +	unsigned int nr_cpus = num_online_cpus();
> > +
> > +	if (nr_cpus <= 1)
> > +		return round_jiffies_relative(interval);
> > +
> > +	/*
> > +	 * Spread per-cpu vmstat work evenly across the interval.  Don't
> > +	 * use round_jiffies_relative() here -- it would snap every CPU
> > +	 * back to the same second boundary, defeating the spread.
> > +	 */
> > +	return interval + (interval * (smp_processor_id() % nr_cpus)) / nr_cpus;
> > +}
> > +
> >  static void vmstat_update(struct work_struct *w)
> >  {
> >  	if (refresh_cpu_vm_stats(true)) {
> > @@ -2042,7 +2065,7 @@ static void vmstat_update(struct work_struct *w)
> >  		 */
> >  		queue_delayed_work_on(smp_processor_id(), mm_percpu_wq,
> >  				this_cpu_ptr(&vmstat_work),
> > -				round_jiffies_relative(sysctl_stat_interval));
> > +				vmstat_spread_delay());
>
> This is awesome! Maybe this needs to be done to vmstat_shepherd() as well?
>
> vmstat_shepherd() still queues work with delay 0 on all CPUs that
> need_update() in its for_each_online_cpu() loop:
>
>       if (!delayed_work_pending(dw) && need_update(cpu))
>           queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
>
> So when the shepherd fires, it kicks all dormant CPUs' vmstat workers
> simultaneously.
>
> Under sustained memory pressure on a large system, I think the shepherd
> fires every sysctl_stat_interval and could re-trigger the same lock
> contention?

Good point - incorporating similar spreading logic in vmstat_shepherd()
would indeed address the simultaneous queueing issue you've described.

Should I include this in a v2 of this patch, or would you prefer it as
a separate follow-up patch?

