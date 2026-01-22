Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C54AC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 07:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8300F6B0101; Thu, 22 Jan 2026 02:57:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DE066B0103; Thu, 22 Jan 2026 02:57:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EA846B0104; Thu, 22 Jan 2026 02:57:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57E266B0101
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:57:53 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F1D5113940F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:57:52 +0000 (UTC)
X-FDA: 84358845984.16.141235D
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf02.hostedemail.com (Postfix) with ESMTP id EB85180006
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:57:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=2xoVN3s8;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=3DYaD3ey;
	spf=pass (imf02.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769068671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MypdZdzoYDN+43tzngLVqabik36CdSqEt94qP7vPfsY=;
	b=szxPuJqeZW9X8tO5dm6NxrxQV9tpM4SISJbFrZTMmXmtieWQ2+xvxHWQJolBcW6lynS6+Q
	1m3XL2tWQdFPlf6pTNdFlrt80YZ5JJ2AfjQy9YZyGWnpkIdwIWDwiVTT6Qm1SID2M4ty1m
	QVp6E4vq7BZMr/IZ+TbchvQO3DMQkMY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=2xoVN3s8;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=3DYaD3ey;
	spf=pass (imf02.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769068671; a=rsa-sha256;
	cv=none;
	b=pcGOhp+pW6RpfeuT8CkOh0QRULWKT7KtmgOhXhqjwHUtFEEYzH0bnTp0Gw5ZU+3w7Nu8W4
	LQQ9Thz4FABQSKgl/Xt/0J85J+S0wbGzwT0fzQj+OuOEBnCEju5YW7HyLx9fVyPqDrCTvD
	HXjAml9rl/AFYOBE0/iSXBcsxZY0hxE=
Date: Thu, 22 Jan 2026 08:57:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1769068668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MypdZdzoYDN+43tzngLVqabik36CdSqEt94qP7vPfsY=;
	b=2xoVN3s8I1jE/1uegEX6ChsSmnLcKEkxfCRTZD8aDwrSPdkhkVcwVarUTK4LAhsDcmLG4n
	3HVo1yK1PdLXU9Net5S2Z7NLJBJ5n3oW+0QHpV20NwU3L3rcJF9D4cJUhjFKQCuzxAjOcK
	3AL4CGPQuaDH6fqGhOPnAhXrvqknB0u/eUism/E5mX+o1x/Fqm4MsjrAfVhfM6aPKVD5bx
	yUj21iib96XbJSYJonKPC8iGCAvxd5/k6oZR0rCZ8h5KLlj6rincrCBuJITE59/huFIfqH
	s2AZVnLWumQ8luJWgbfJXhYeoNz2Z2gfOYWAk7X70ZvbvBhE6+oC08FM7FQpDg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1769068668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MypdZdzoYDN+43tzngLVqabik36CdSqEt94qP7vPfsY=;
	b=3DYaD3ey9CwD8bGmkZZKuggP2Wasq5Y/BI39C/lfTzka24QgGR84pXqcyxLlAK6vg43rim
	hzgrKCVob0W47wDA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Paul E. McKenney" <paulmck@kernel.org>
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
Message-ID: <20260122075747.uSLrSJez@linutronix.de>
References: <20260121191036.461389-1-longman@redhat.com>
 <20260121114330.6cd34b4732c7803f1720f0ba@linux-foundation.org>
 <0e385146-67a3-4fdd-b119-059caba8c5f0@redhat.com>
 <13d0b8b5-1ba7-4a3e-a686-13a7b993d471@paulmck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <13d0b8b5-1ba7-4a3e-a686-13a7b993d471@paulmck-laptop>
X-Rspamd-Server: rspam11
X-Stat-Signature: 6irrfaud5ri5zi6tmo1o1tzo9co649ty
X-Rspam-User: 
X-Rspamd-Queue-Id: EB85180006
X-HE-Tag: 1769068670-584799
X-HE-Meta: U2FsdGVkX1+ypLi2IpzUXatPJfmJfBnhUUuICBL2GQVZPgFl8pOGwFUF7U5ztIOY7yNKJhNc3dp1KCpECqEzTxqdmjGkTjfawOn79uej2a09pNAKzFr2QfGLQYjlFIQIQtTyz2YW955/4CIHceMnC76X04PYUaQhCRFe1U8O4MGyKW3kXQ4WCAmyKpfBoOH1IXqQHKtwf29kj7zjKrO9XupcoCT7uoREVIRKTqHfFq3j3Az+TfZDSNLa3+4c0yKRRitw+vtwoDu9/s5+7dmwP2gV/q8+Y8kAHrQ/fHPRsPQtOp/RuWC+4Vws+u0mHH1Ddg8wuN+dC1EA8Ww/NBeaiuLhUhzDRS8OVmfA9Fzz5iNWCcax3YtEVphw/utHwBQjLBc4Q+6J+HM+EFj6RuiDNc6eLpTRknITtkn2uey8W7fzP9yzwSRmxg9T2fyNvspV48CLjof8KiVYoc9nFU4jvExcVbq88TBl7Zsqk7SqGdvIO5mu9vY/bCQdSc0LVsXoAVE2TPhaMNoFCdztMrjBvP9LGE1wHwhtZt6g+sLk3J/1nkxNz8xSbT7NVy9LvCgRHIfdok0Zn1GQPmXEMNIv2Ws2ZpKkiDf3P9Chh2mS2abhBiTCB+WmtEC8tShlfWdqcFK0nA4Ozsxk2rn/la5HBX+NbfhzvaF/fxqat+eGniCTFleV8m4MPM9l3LkNyo0bkruTb6gQ9svEltWuPSvUClH345PKWEv1Rd7b6VWC3QUI87x0NJ7+YOuoWP0HFStKpDZzlZtc/UFfwA1Bft3O/r9i1eUmbW5eAx+UP1dZUIpeYfmpqUyXKaOOmElVRMscGdSSjJR0X48/xMKqEC4vz/ngJm/GWKpcp4PZXPtCM/dJ1zkjlNr/G2ChhAPcCTgKVXqHqTNFKYp8CShYl91ffbpgd2pNEqYkR+5QgRtGmqq4pBW8aQ6uLaZ+W2N5fZTSiGNULrYAvTS0cpHW2Jr
 1mAEs0ut
 IoWLroTpad2Eds2RarwUSfT4hzqDSpOFzWuOSl0TAjnIg3NTlgvzsICJm597f6Ym3PHLG/GDk6nRdwsvLB4BKD5T5Vlqf0uLi0ZFkSdA0BQDQKTuN/Uoxq5sbWStFh+v2Wk+srPZW9BMrSNjEMK44KySLZroI8GNhc9QW0s0cQfri70Qk7Fqp3X5LtFeIv8ppb1gzMFM3fT9a9xS80JZ4usYxdRUSGtkocf54eq21/7Lt/03QTO1qeA+nVlpcahOWf0/rk4YROwj5G6p/7yPvgbOcFABRYlZuLFQ0A1EkyGOljP3vzTiqDkxKlfO+CMKaI/uXTnDoZAVN5mUQDv6LwannJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-21 13:27:32 [-0800], Paul E. McKenney wrote:
> > > > --- a/mm/mm_init.c
> > > > +++ b/mm/mm_init.c
> > > > @@ -2085,7 +2085,12 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
> > > >   			spfn = chunk_end;
> > > > -			if (irqs_disabled())
> > > > +			/*
> > > > +			 * pgdat_resize_lock() only disables irqs in non-RT
> > > > +			 * kernels but calls rcu_read_lock() in a PREEMPT_RT
> > > > +			 * kernel.
> > > > +			 */
> > > > +			if (irqs_disabled() || rcu_preempt_depth())
> > > >   				touch_nmi_watchdog();
> > > rcu_preempt_depth() seems a fairly internal low-level thing - it's
> > > rarely used.
If you acquire a lock from time to time and you pass a bool the let the
function below know whether scheduling is fine or not then it is
obvious. If you choose to check for symptoms of an acquired lock then
you have to use also the rarely used functions ;)

> > That is true. Beside the scheduler, workqueue also use rcu_preempt_depth().
> > This API is included in "include/linux/rcupdate.h" which is included
> > directly or indirectly by many kernel files. So even though it is rarely
> > used, but it is still a public API.
> 
> It is a bit tricky, for example, given a kernel built with both
> CONFIG_PREEMPT_NONE=y and CONFIG_PREEMPT_DYNAMIC=y, it will never
> invoke touch_nmi_watchdog(), even if it really is in an RCU read-side
> critical section.  This is because it was intended for lockdep-like use,
> where (for example) you don't want to complain about sleeping in an RCU
> read-side critical section unless you are 100% sure that you are in fact
> in an RCU read-side critical section.
> 
> Maybe something like this?
> 
> 	if (irqs_disabled() || !IS_ENABLED(CONFIG_PREEMPT_RCU) || rcu_preempt_depth())
> 		touch_nmi_watchdog();

I don't understand the PREEMPT_NONE+DYNAMIC reasoning. irqs_disabled()
should not be affected by this and rcu_preempt_depth() will be 0 for
!CONFIG_PREEMPT_RCU so I don't think this is required. 

> This would *always* invoke touch_nmi_watchdog() for such kernels, which
> might or might not be OK.
> 
> I freely confesss that I am not sure which of these is appropriate in
> this setting.

What about a more straight forward and obvious approach?

diff --git a/mm/mm_init.c b/mm/mm_init.c
index fc2a6f1e518f1..0b283fd48b282 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2059,7 +2059,7 @@ static unsigned long __init deferred_init_pages(struct zone *zone,
  */
 static unsigned long __init
 deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
-			   struct zone *zone)
+			   struct zone *zone, bool may_schedule)
 {
 	int nid = zone_to_nid(zone);
 	unsigned long nr_pages = 0;
@@ -2085,10 +2085,10 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 
 			spfn = chunk_end;
 
-			if (irqs_disabled())
-				touch_nmi_watchdog();
-			else
+			if (may_schedule)
 				cond_resched();
+			else
+				touch_nmi_watchdog();
 		}
 	}
 
@@ -2101,7 +2101,7 @@ deferred_init_memmap_job(unsigned long start_pfn, unsigned long end_pfn,
 {
 	struct zone *zone = arg;
 
-	deferred_init_memmap_chunk(start_pfn, end_pfn, zone);
+	deferred_init_memmap_chunk(start_pfn, end_pfn, zone, true);
 }
 
 static unsigned int __init
@@ -2216,7 +2216,7 @@ bool __init deferred_grow_zone(struct zone *zone, unsigned int order)
 	for (spfn = first_deferred_pfn, epfn = SECTION_ALIGN_UP(spfn + 1);
 	     nr_pages < nr_pages_needed && spfn < zone_end_pfn(zone);
 	     spfn = epfn, epfn += PAGES_PER_SECTION) {
-		nr_pages += deferred_init_memmap_chunk(spfn, epfn, zone);
+		nr_pages += deferred_init_memmap_chunk(spfn, epfn, zone, false);
 	}
 
 	/*

Wouldn't this work?

> 							Thanx, Paul

Sebastian

