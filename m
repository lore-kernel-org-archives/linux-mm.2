Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15BDBEA4E3A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 16:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3891E6B0005; Mon,  2 Mar 2026 11:14:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336876B0088; Mon,  2 Mar 2026 11:14:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 218EC6B0089; Mon,  2 Mar 2026 11:14:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1371C6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:14:18 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B589A89FB6
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:14:17 +0000 (UTC)
X-FDA: 84501620154.27.4DD33CC
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8DE721C000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:14:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YG01ILjL;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772468056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MLL8CQedq0WsIHC423sVIgR4mj4t68qiQx4HMXd9uDE=;
	b=3sSvfUPpNVx3KNFxhtJO8+pjbaOIXyvUrikd++eucSk4Fg/1wIkHo/yJWYztx44GP2ry1g
	w8OEHtTBcDChGbJENXMp9raDEM7PSGeR0mYsjwo623MZpJZpczbXtgm3EJJTyUDS8o1xjn
	Qvi0g1jyHnGA0n4x9oam5OhfhRA799k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772468056; a=rsa-sha256;
	cv=none;
	b=p8LE4YsvNZYbvMjnW27llD5hKfuwzio8m4SThhKfOc/3kDle9Ej5AC8HDpgE6TyxyxZ0Aq
	BvMrBVXBwVHnKE4nz9RObbHSSisO7eWt16bjZ85EMk4cvcVa4pKEwWCyUBEDz25dKQHxQ0
	zn66rSrkMU+dq/T8JLXrfxomof0SXto=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YG01ILjL;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 2 Mar 2026 08:14:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772468053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MLL8CQedq0WsIHC423sVIgR4mj4t68qiQx4HMXd9uDE=;
	b=YG01ILjLYI0dk46V+QncPZZT1q3hBjoc84PeXOZJVUm0yLSx284+Q4kliCpzftFLybp+5L
	kpTVPFxfUITqsKaMqQAgDHi5QNKoE5mvAK0ecsIL/CeH8tWyYKJTYft+DRokoxgqFSwbBG
	1ptqeewLBnfoxD5xDpCIAv4liTj8Y2c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Daniel Sedlak <daniel.sedlak@cdn77.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 2/3] cgroup: add lockless fast-path checks to
 cgroup_file_notify()
Message-ID: <aaW2feETIF7I65i1@linux.dev>
References: <20260228142018.3178529-1-shakeel.butt@linux.dev>
 <20260228142018.3178529-3-shakeel.butt@linux.dev>
 <40c77bba-0862-4422-b23e-2a10cd01c728@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40c77bba-0862-4422-b23e-2a10cd01c728@huaweicloud.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8DE721C000A
X-Stat-Signature: 7kb6r7g7bwiwwn98aqentm44knh9xfaa
X-Rspam-User: 
X-HE-Tag: 1772468055-41725
X-HE-Meta: U2FsdGVkX1/9YvRGX1XBN0Nk5QiE5amDrEJRLPlcYnxW33btNzujePo6uW8Teitn2zZrL7WTW4h9akr0tFBrnVgWfePeO9yPWVFK1Zqg0/y5gNRANZQEDcicj71D0oEfnoIaA4trgp2l+3w1mhptbXQJiYdD4u9Vkb/CswhnCyEzAOTF7fMJ6p/f5J0fOXGKJgL7XD3jYzpBEdgYAoyAOMFaxpmGtiBv+8YD8d5HOTi49moXF8e6JPHdhEb2QNyDcpWpS+N8FPfBJM+o/+VAM4HMgj0HaQHrmCm7xBU3A6IrxfcpXDR46nAIlB+sAnIctmcCKT/kZUenhmm9CAWQNMxdWAC50y/0THlJaxlZcaRG/tl32J9qAaHqKVKM1uUxD1wLGZUAlvZav0lkoAXtFhQl9iiwKSasMQdiU8u9uDdSNpODCwgxinWJObUYC7X9HBefIAVpF13esh8+EQLetbHvHmhk5cgHaQ3p70KgUvbwq46DUtfRqbSJkISrAE6wOAelXqyx5D9a6OTjkCVyW6Y9DK/zFRKGXz1VJ+fw98LOZQ9zynCaZpKh+CWLsLN8Y7D3vWOT0uGKyGyXrDCYSxOvXJUL9WImqZLLeHDq9e9hK4w+l96IWEexKy7ZmK8lckX24EYevSvh0yoHVjL/h2NxvKxjc+7ohJAqUzgDxukZPeIHMjWtUZUYfBbMMFMGUrjq8LLltdI2JrFiS36SC4eTxcbrZWvdBR+1sIckELoN6v1g35cunGYhbjbNgOK0jGAnt1sLNP9sAvNsF8jGv6kjeY22kj+x3Wbj0sJixkp7H3zfY0itMo/mhezMKxLyRI+7AnQjWzimrEXdh6F9eaU5RItDCueDRDBZa1Twr/S+lB/2TPw29NycqocIyflUPIGbF93nUF2OE2G/7wdAyPxFUcYyuOsvoXq6jS0WD+DGn5Lm4Kc/YTi5KcMagBJztnQMk98GX63mR2I/mPi
 2EWJg0eo
 pPaPhY+8GRQzBjgzpSq9ja+4CW9Djpgz2XPWJ8L7E4bAksSPzNdLAx9/y0MuC9+krOV36xlA5Uu2VWL0nkMhu1TC5PEOedbod6rel7zY9Gca+tmPBIuSjMWcmrqCDcXCSovYqWUVF0OUwZN9QLEVLsuidNY0ZgJfd1P/PZtvN04GSaYpwnfvjQw9N4InCLc9D5RZHXeeAGSBQwlIV2bEfxbuDai9kPgz4BOH5F9beVaN96jKpPbQRkpbHylCZjcwkhy5yRuiMV43ryJ1H/bztDv44WA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Chen, thanks for taking a look.

On Mon, Mar 02, 2026 at 09:50:53AM +0800, Chen Ridong wrote:
> 
> Hi Shakeel,
> 
> Good series to move away from the global lock.
> 
> On 2026/2/28 22:20, Shakeel Butt wrote:
> > Add two lockless checks before acquiring the lock:
> > 
> > 1. READ_ONCE(cfile->kn) NULL check to skip torn-down files.
> > 2. READ_ONCE(cfile->notified_at) check to skip when within the
> >    rate-limit window (~10ms).
> > 
> > Both checks have safe error directions -- a stale read can only cause
> > unnecessary lock acquisition, never a missed notification.  Annotate
> > all write sites with WRITE_ONCE() to pair with the lockless readers.
> > 
> > The trade-off is that trailing timer_reduce() calls during bursts are
> > skipped, so the deferred notification that delivers the final state
> > may be lost.  This is acceptable for the primary callers like
> > __memcg_memory_event() where events keep arriving.
> > 
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Reported-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  kernel/cgroup/cgroup.c | 21 ++++++++++++++-------
> >  1 file changed, 14 insertions(+), 7 deletions(-)
> > 
> > diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> > index 33282c7d71e4..5473ebd0f6c1 100644
> > --- a/kernel/cgroup/cgroup.c
> > +++ b/kernel/cgroup/cgroup.c
> > @@ -1749,7 +1749,7 @@ static void cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
> >  		struct cgroup_file *cfile = (void *)css + cft->file_offset;
> >  
> >  		spin_lock_irq(&cgroup_file_kn_lock);
> > -		cfile->kn = NULL;
> > +		WRITE_ONCE(cfile->kn, NULL);
> >  		spin_unlock_irq(&cgroup_file_kn_lock);
> >  
> >  		timer_delete_sync(&cfile->notify_timer);
> > @@ -4430,7 +4430,7 @@ static int cgroup_add_file(struct cgroup_subsys_state *css, struct cgroup *cgrp,
> >  		timer_setup(&cfile->notify_timer, cgroup_file_notify_timer, 0);
> >  
> >  		spin_lock_irq(&cgroup_file_kn_lock);
> > -		cfile->kn = kn;
> > +		WRITE_ONCE(cfile->kn, kn);
> >  		spin_unlock_irq(&cgroup_file_kn_lock);
> >  	}
> >  
> > @@ -4686,20 +4686,27 @@ int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
> >   */
> >  void cgroup_file_notify(struct cgroup_file *cfile)
> >  {
> > -	unsigned long flags;
> > +	unsigned long flags, last, next;
> >  	struct kernfs_node *kn = NULL;
> >  
> > +	if (!READ_ONCE(cfile->kn))
> > +		return;
> > +
> > +	last = READ_ONCE(cfile->notified_at);
> > +	if (time_before_eq(jiffies, last + CGROUP_FILE_NOTIFY_MIN_INTV))
> > +		return;
> > +
> 
> Previously, if a notification arrived within the rate-limit window, we would
> still call timer_reduce(&cfile->notify_timer, next) to schedule a deferred
> notification.
> 
> With this change, returning early here bypasses that timer scheduling entirely.
> Does this risk missing notifications that would have been delivered by the timer?
> 

You are indeed right that this can cause missed notifications. After giving some
thought I think the lockless check-and-return can be pretty much simplified to
timer_pending() check. If timer is active, just do nothing and the notification
will be delivered eventually.

I will send the updated version soon. Any comments on the other two patches?


