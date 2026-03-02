Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B385D58E48
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB7396B0005; Mon,  2 Mar 2026 12:00:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64EC6B0089; Mon,  2 Mar 2026 12:00:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70906B0092; Mon,  2 Mar 2026 12:00:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B5BF16B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:00:30 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72F99B73C3
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:00:30 +0000 (UTC)
X-FDA: 84501736620.07.4E1C905
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id 843CD4001B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:00:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QM+FemWK;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772470828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WbAs9ykKjGj1acVkdZLpnTflSlmI29KTifSwOcqBl6o=;
	b=42+qOf1PqswP6VLBSsqOmHRvj6IyuDuruJjB5CBi0+b7lgPofRanB7sEHom3Hx2Ol9u2Pt
	CzOzJVGu5tb1w/4KT3r4f/EiTR/hHGqtsMmQBlYmmE54iWNGl3hhM+28sPdKSPkgYolMhJ
	vPXZrvUsb3o1NL2rGTWOu9D6yn27aDQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772470828; a=rsa-sha256;
	cv=none;
	b=TcHcFSjEIpvCSRg4k9c7rV8mWeCyTo6GyXKWM+gnMBQ4Jyiyn1r/V7RJ6SKM4OqMFXcENK
	BObIUhP2mD3mTTJDFgSJWAfd6jCQcQMqCZWsyfeZ9+3/vF9mI52lEdURPX5XR3GLDei/BB
	TVPrDhpQJw+Yka7QuRQHCTZDQ6Dk1Kw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QM+FemWK;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 2 Mar 2026 09:00:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772470826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WbAs9ykKjGj1acVkdZLpnTflSlmI29KTifSwOcqBl6o=;
	b=QM+FemWKuEjzR06V0+l7g/FTA9BP0C/iPlSfw9pkv9G5M1hdQfOly2TwTD4+rNwMhqH/bn
	T+8kvhEDBbuIhVFJ8GbNVA5bJCEsWUXglP1KG0rc5R/dx16wW2t2fj/+Z3PO0epJAgbm6B
	/qIfXUGfLqj4AceUt5U7OJ0Eh/hTSwA=
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
Message-ID: <aaXB0A7eTbyZ4wA_@linux.dev>
References: <20260228142018.3178529-1-shakeel.butt@linux.dev>
 <20260228142018.3178529-3-shakeel.butt@linux.dev>
 <40c77bba-0862-4422-b23e-2a10cd01c728@huaweicloud.com>
 <aaW2feETIF7I65i1@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaW2feETIF7I65i1@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 843CD4001B
X-Stat-Signature: 4xmfechwrjuut5gjq98e4qmukecb9ssg
X-HE-Tag: 1772470828-389429
X-HE-Meta: U2FsdGVkX19y79m/aaxfmXvcg2qgAf0xapV668uH/lU2g7U/ram1iND1RykuVoyUqJmFJTSF1GGRF/hWsHq92NndfCOPQbLapxoZZKgQEPrTlrBJcfzOE3Kko4nnuuMlvSKjNWnheyETDkbiyP0kvYWKzSmZAf3DgJmnXrVTLX/vSQ9uDvdAVCqU2ovscoTMbpgWpRKzUCWfnMXcJgw/hjtVq6J/U1Ft5YhabJ2xk3zw4mK09QUTItzJqqkCDlhv87VFpk9gGZd5na1bunU2ZLC5qI+QZtYKJFjs4o6JNQZhM+cU/Fs1NHkUrl+pZuzIRVwXyfXbha3kuzr+XZ7lRmgARPYqyPam8/JHoTdobmLAP2PBC95TNwcXgdr5A+w0Xw3BQq+JrRT2grI5tpYkYQaRtgWhg1QFZ5AdOhAe6KjucPCYq/incSzuV6l0cw5Pw4iYlyEma0S0Ztfv/t+/Ycl6jfWyaRja0b4t/uwmI5umTeSKw1biL9qAvudTS2S4pqw32Jqcg2QVLrTmgYydsO3VuEQm7pUzlcsdPmiQ8H7IU9GWJWE/oAvLrRxyw0fljJ3/AB00m72bXGDNnZJuU/edvGiO8a7RN9D6PFoo1a/o4+DLYLmzKLLEjStVis5+sWS3qSV7a3lJ4HItQyaNnGFF/X4V8SYv5xzijaFLjVgv2txwUeitRZ2gT5+UG7Bd8G3EV5OiaPiYDcWpbe/+me6JRjyesxPCD8sCdLicoQy/mI3J25cJPW4ZGm6ILmXANN2uj0ZRFUUkFRRMkIMxoRUwfJDfNxCIQxHHYtfOa8djHM4JNxdpM7JF3B0LWuDuWeGUwdb/42z/L9/JfdZvMGrPgLS9v+KDI1wnDf5/G+ffnZs8SbUYW/lJvmgwJ2MOPRfDTnD8bWCfTLyn8TOlWen0ABYNJJmoBfVMIF2Sz9MclwfHGhB2dYyx5WRLSAM61ykQBwzGlsbVgOI6PwJ
 P9100tla
 JjO72lV+I7t0xwEh0+5KojoWifNqVQsC9OnCn+qCI9CwpNZ9qYKEB5WBLXiGuFAWgi6S2ZoL+8H+yYNU+oFfUgRv56zd/JiJ5FJU8X72x6qmk8CzHcCDDhUKzigtZIdq/It8vev0MiD1gMAeSC6iymLjn89bnN6i5R00FRSGnGlvngQ+ksNkZVQp56tieiRgKZHE2Bq9lCJQvHCSjLhddnIxQJumdsDK1wbgrhGmgluHFKt2c7HslfqpCrDTUB3EOhKqLoMztsaLquSoewCEfR65rvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 08:14:05AM -0800, Shakeel Butt wrote:
> Hi Chen, thanks for taking a look.
> 
> On Mon, Mar 02, 2026 at 09:50:53AM +0800, Chen Ridong wrote:
> > 
[...]
> > > +	last = READ_ONCE(cfile->notified_at);
> > > +	if (time_before_eq(jiffies, last + CGROUP_FILE_NOTIFY_MIN_INTV))
> > > +		return;
> > > +
> > 
> > Previously, if a notification arrived within the rate-limit window, we would
> > still call timer_reduce(&cfile->notify_timer, next) to schedule a deferred
> > notification.
> > 
> > With this change, returning early here bypasses that timer scheduling entirely.
> > Does this risk missing notifications that would have been delivered by the timer?
> > 
> 
> You are indeed right that this can cause missed notifications. After giving some
> thought I think the lockless check-and-return can be pretty much simplified to
> timer_pending() check. If timer is active, just do nothing and the notification
> will be delivered eventually.
> 
> I will send the updated version soon. Any comments on the other two patches?
> 

Something like the following:

From 598199723b50813b015393122796f6775eee02d7 Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeel.butt@linux.dev>
Date: Sat, 28 Feb 2026 04:01:28 -0800
Subject: [PATCH] cgroup: add lockless fast-path checks to cgroup_file_notify()

Add two lockless checks before acquiring the lock:

1. READ_ONCE(cfile->kn) NULL check to skip torn-down files.
2. timer_pending() check to skip when a deferred notification
   timer is already armed.

Both checks have safe error directions -- a stale read can only
cause unnecessary lock acquisition, never a missed notification.

Annotate cfile->kn write sites with WRITE_ONCE() to pair with the
lockless reader.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: Jakub Kicinski <kuba@kernel.org>
---
 kernel/cgroup/cgroup.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 2b298a2cf206..6e816d27ee25 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1749,7 +1749,7 @@ static void cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
 		struct cgroup_file *cfile = (void *)css + cft->file_offset;
 
 		spin_lock_irq(&cgroup_file_kn_lock);
-		cfile->kn = NULL;
+		WRITE_ONCE(cfile->kn, NULL);
 		spin_unlock_irq(&cgroup_file_kn_lock);
 
 		timer_delete_sync(&cfile->notify_timer);
@@ -4430,7 +4430,7 @@ static int cgroup_add_file(struct cgroup_subsys_state *css, struct cgroup *cgrp,
 		timer_setup(&cfile->notify_timer, cgroup_file_notify_timer, 0);
 
 		spin_lock_irq(&cgroup_file_kn_lock);
-		cfile->kn = kn;
+		WRITE_ONCE(cfile->kn, kn);
 		spin_unlock_irq(&cgroup_file_kn_lock);
 	}
 
@@ -4689,6 +4689,12 @@ void cgroup_file_notify(struct cgroup_file *cfile)
 	unsigned long flags;
 	struct kernfs_node *kn = NULL;
 
+	if (!READ_ONCE(cfile->kn))
+		return;
+
+	if (timer_pending(&cfile->notify_timer))
+		return;
+
 	spin_lock_irqsave(&cgroup_file_kn_lock, flags);
 	if (cfile->kn) {
 		unsigned long last = cfile->notified_at;
-- 
2.47.3


