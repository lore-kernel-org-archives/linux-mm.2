Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A141606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 15:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=Q22kbEsz;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=oePzjRX5
Received: by kanga.kvack.org (Postfix)
	id 699396B0A4B; Wed, 25 Nov 2026 10:19:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 649106B0A4D; Wed, 25 Nov 2026 10:19:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5383A6B0A4E; Wed, 25 Nov 2026 10:19:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BF296B0A4B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:19:40 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA819A8E7E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:19:39 +0000 (UTC)
X-FDA: 85474000878.19.AE92AA4
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf03.hostedemail.com (Postfix) with ESMTP id F343520008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:19:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Q22kbEsz;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=oePzjRX5;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795619978;
	b=8pZ+moR8U6ZBKsl7aVYKXcHtQ97LBrd7T8nc9zUJlDYb3E0lO2QOxBnF6gtE1dTsojbuow
	Pm5IyUWE9Ie8bSHNB/f51o4DM7Yc/AFGLHwr4yV7AKtkf6DN/gV22X9BZYqCmvWzhm1/h/
	iJOi3PvqZhxPP7TG55WAw2oj22cBBxU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795619978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0a9q+huuyoIOz8IkHD+r5Bw+xupFItGuXtoD3i7TDIU=;
	b=ZZlvpJkW09b/h1+1l9uooWk8aydm4hMqSij4Zei56aD6H9CoPo/NxIX0H2JC2+hNJtJM06
	sPMLnM++7NmetuCMlMIxWGBerqS8CzQd0ic6p64iaQszkrp7sJ91k2esutx0t4D/WJzdoZ
	XJ5WMS/hn4me4h0umePoPjDqs9te9I4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Q22kbEsz;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=oePzjRX5;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
Date: Wed, 25 Nov 2026 16:19:34 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795619976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0a9q+huuyoIOz8IkHD+r5Bw+xupFItGuXtoD3i7TDIU=;
	b=Q22kbEszPMOtoqXdNesp74j+B4T3Sddk02EMxGU6ZZti/drUuN/TTbmWfO9FVIknny0VNO
	OgqrVaLxdfFAEVBjvROhhG0IeqGFI0fNGDIX9Fz9WT2OU5l/+vX1LxV4MRCesSjHDsL+6h
	FGPMI8d2KLeabCQooQiYnNzHTSy67EjRE6O37eSgAqRmnnQKFuAU9Fk2QXkSq825ehV+HJ
	G5ZyJlmKbZNM2dmYzCHZH6qzfjwVA7wnimfDLlCqnF2ZT7Yi+pvbCEZ33w/w0zCHbjUEfz
	Ts0sqkVdUVRyuswHFpYAKJxad6MSPXIu3VOaPesUNpZ7oLYpFXSHAPwZXbPduA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795619976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0a9q+huuyoIOz8IkHD+r5Bw+xupFItGuXtoD3i7TDIU=;
	b=oePzjRX50n0SqvTlICcaKy9+VF0d2Ledtjo6oUG+P6LBSzqaBex5HradhIL6Xi0oLfxVP1
	TAhWj9xLLXM4MdDQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Harry Yoo <harry@kernel.org>
Cc: Takuo Koguchi <takuo.koguchi@gmail.com>, cip-dev@lists.cip-project.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Takuo Koguchi <takuo.koguchi.sw@hitachi.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Clark Williams <clrkwllms@kernel.org>,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH] memcontrol: protect drain_local_stock() with
 get_cpu_var()
Message-ID: <20261125151934.-RufHHEw@linutronix.de>
References: <20261125043900.3618611-1-takuo.koguchi.sw@hitachi.com>
 <awb6bJ1-_8zeyTYQ@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <awb6bJ1-_8zeyTYQ@thinkstation>
X-Rspamd-Queue-Id: F343520008
X-Stat-Signature: 5py1oypgup9i5wboszthtbtht1gk5jhe
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795619977-273611
X-HE-Meta: U2FsdGVkX1+fhE3jIjFtMZZ8LiiXyjNv/HpoYCSgTuXQBs8HFH/Vfxdp4IiMGCuBE7k29P34w9dN7lFiqbNcZJaFkxiH7y+bXLUD3kjY49DN2DnXN0L49E9+EBJkx1h9EVEmh7vXlke7F45mxsEqp5AdomYlhCKg706KJzMOVWEKh3CfiJYLYAvVnjrRRLTiC163zPUJQv4WQ1IGhXJ+vclc+nclMehytZhcP3DJgW5p6BIoJSbLV+DADWegP/K29IN3HA3atNsHDLgoL8GelGsr4TdjQPgsDOlRX7T3j54xKFTFMY/R4OA47OItxMUUctbJ2y7i9kxw869oO6z4LxHhxdKGtcawFOU2xu4uoWrjU2YGRa7j7iAr9LwssmmkiaQRO60ejP0YKtPzSi5k1gk3uzuD6CNOHK5+j0lgqpNAYFh7vAB1z2s6aMhSODVbbFh/8rk9gp2fOCfulXjKZOcNgAZP20cQmU6APDuMA9xMpPrXKFh84MN52AI777d5bSxHZfkGFkDCrpQyDMpaSJTL4dV2AG2DWrHxf0oppK2fSX74aFSnnwQEybrx1xBusAOovgvTeGjHSTS5O2C7MRqxg5YdUVbtWDo/Wjos4bZnLuuw0W+tICnF3SxZb0SnZ7p4UwZP/HidX/MOsHvuT71ttdIbomnr1vub/n08Zit+vHAgWVBJ/XWvEHqZYKyWwgJY2l7ki5nbwy/eBkn4dSlNgeMIAVB4TvS3Q/3wUxvBRYyzgtiaktnHxfCLxrmrwMav+eDU+xbcVLhW0PSeWz7+kfcCSYwBSvm6TqIJQIxdp4dD3CvyHCL1hlNSb8AZcTIzU31wRbX+q/99VgEaJCEJV4QJN6uFKdBTLwx2FWcCEYWSbFRKQWX58sbr6/brvr3XcpSukr2Zy/A5YlrOlj/SkT90DlCbpQLugCMMn/xPgS4MWjPBWoXUYZZbKLlNlO5BrvmzfE9pmtCxB9W
 TMRztyQW
 V/Wxk+aRKldikU+r+MsvIhoCChMBuPgfV1VpGZC/hfBAiNrrLrsYS8hr+6hiMKxgNZRL8Nt2J8VJU2+Im0B489P5OEtpq/9Q3VvqbhMgq0eCNblGBtk2NWyT+3ePQxoZSpySXDPl0Ae3iGGi1K9R1RJRUgDJBxqXTr8jtZg+/xzQfBBrVjnnWBj72CpxFPzFUh961UOgML5MMYdCmBAh2ynAohZtk88+lc5m+IpwRERvtXVU3H6TeiGuBsYhAId6Kb3uX08ryywa+NQUe0txbgyHWDJRXi6OdZS0K0xda5l5hM99ZiEZhqgFAFyZRhmdeLE9OBul+M1b5RSEwRK3kb6K6sCAqe/WOvTUlYXo+3eYGwV4JcqyiLs259Zi//BUMBK1VWxXnYMZLCNraNEFMGa31htwEIrOjXzaylnw4oVF3/QEHBLKsSw3ZqnOsqDuGKZdiaLVyZsj04WRyismSi9azFvpRWdlxAfppc6LqQreuHxzPqlH4WqJkzCtPxKqRwBGt1BVm8a4AFSUGxP1z9X89OQYEmb47iv/r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-25 15:13:05 [+0000], Harry Yoo wrote:
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -1933,14 +1933,21 @@ static void drain_stock(struct memcg_stock_pcp *stock)
> >  }
> >  
> >  /*
> > - * This must be called under preempt disabled or must be called by
> > - * a thread which is pinned to local cpu.
> > + * Drain this cpu's stock.  Called directly by drain_all_stock() for the
> > + * local cpu and as a work item for the other cpus.  Preemption is
> > + * disabled here because neither caller guarantees it on PREEMPT_RT:
> > + * drain_all_stock() only holds get_cpu_light(), which is a plain
> > + * barrier() without CONFIG_SMP, and the work item runs in a preemptible
> > + * kworker.  consume_stock() and refill_stock() run with preemption
> > + * disabled, so this keeps every user of the per-cpu stock serialized.
> >   */
> >  static void drain_local_stock(struct work_struct *dummy)
> >  {
> > -	struct memcg_stock_pcp *stock = this_cpu_ptr(&memcg_stock);
> > +	struct memcg_stock_pcp *stock = &get_cpu_var(memcg_stock);
> > +
> >  	drain_stock(stock);
> >  	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
> > +	put_cpu_var(memcg_stock);
> >  }

This breaks PREEMPT_RT and is nonsense. this_cpu_ptr() should not create
any warning here and if it is then something else is broken.
There is no need to disable preemption here, this is invoked from a
per-CPU worker.

Sebastian

