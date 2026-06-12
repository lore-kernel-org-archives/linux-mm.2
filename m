Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60DBECD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 09:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ED076B0005; Fri, 12 Jun 2026 05:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99E076B0088; Fri, 12 Jun 2026 05:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3DE6B008C; Fri, 12 Jun 2026 05:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 764516B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:42:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E4981C3A63
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:42:53 +0000 (UTC)
X-FDA: 84870771426.18.5B1C5EF
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf05.hostedemail.com (Postfix) with ESMTP id 71DD1100003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:42:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ERIvupxV;
	spf=pass (imf05.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781257371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+EETPDO05l17/BFbIZL6wDNJDo2//SDdspTodnkeLw=;
	b=hZ8czRDPmiFP/zy29n53W7R1JBvjeW/HUOyycoSJl9AF+o3JnrE0H+aTsP8sf+Zg7pMI8P
	+lm0DCDVgzbtUVBe9pPBrfU4jFYAIEvwF9yhWX2VaI1Tkj2LkS7B8mhf4fExVe+trCGCKZ
	+tV3bhS6ppoai19S1LMXPg8voto4RRM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781257371;
	b=ytvcDmIl448sS92xGRUY4XQar9U1Ie/XQRz4pwoLmOsCNJ4vqw9dCNSP3DwWp6fHqD0Ulf
	qpZm7Pc8dpOZjJVIghoWftK/oNIzpWhgVy8D8ZuzI2xbCpSW4fdxTjIWl56NGupqxt2DZK
	Yl5FE+5umFlO7LzwHyjbjC+Gx5UQ5gA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ERIvupxV;
	spf=pass (imf05.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=r+EETPDO05l17/BFbIZL6wDNJDo2//SDdspTodnkeLw=; b=ERIvupxVzVUFRmj4gv5o8WeMMR
	q4zMCkbqJZYhsVXEZpBmGgEgN6Ow0mWQKGmhTj8pko0iVqA2AMQkUw6A/NyDmAfwgaV93H87vloNE
	dZWC5B4ugTHM0KB1PyBlqVMqs8B+YjCHnMOOSdRUxz/0OTV2RZB4/um0xVl53EpLJNesBthNvDLpx
	djs7gAXwISeEkaGospstfw17x8jnQmVSpV5svqq3fSedFEahpGINFz5prZ2iqRLK2t+y+vjAUBZ1j
	ZCD62iYbFEiHfMbh05JZKTpQ8XrsiE6HC8cjqSmgygobGoG+d4NgMBSx+66JQlsWU0Q+pjdU26NcM
	oxgaj1qQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wXyPV-00Adru-3A;
	Fri, 12 Jun 2026 09:42:46 +0000
Date: Fri, 12 Jun 2026 02:42:41 -0700
From: Breno Leitao <leitao@debian.org>
To: SeongJae Park <sj@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH RFC] mm/kmemleak: avoid soft lockup when scanning task
 stacks
Message-ID: <aivUb606z0rHakVK@gmail.com>
References: <20260611-kmemleak-stack-resched-v1-1-d6248ade5f4a@debian.org>
 <20260612011049.84146-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612011049.84146-1-sj@kernel.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 71DD1100003
X-Stat-Signature: jce8557oqruunuxtk7umj5pnk89wbocd
X-HE-Tag: 1781257371-659026
X-HE-Meta: U2FsdGVkX1+LMBy+/W0CKlz2GsmC2ynXWawyFpqKQ/N6N+8HixT+3TVev/iu7puHQeFSaXCHbnGFm9PG+y0afb0JbJvL64Z6v5Bw+geB3vBsNUU0buehGFuha53wAPxZx9eNKQZXuPP4iXh2neJpl3bGpzlJdBTGl8Vg0JhW0hNaTqLPVc6OT6TRTFhVAykN3no16/aQTD7JmaX3UcQcXCDbJS8yrGGr6bIWtBrySo5f6GklHl60Rx45oKHRNK9q75P3vGuVdnonewoKUNlJaA9Ald/bFLVQGqnYISbluohoVvy/9vqPGPVkCdhCqhw/ZxMLtxVzBSIe3oSDkSJ0Y/Qc5S2TXJV/L2iUEEko16WalRC8YOcWHXWFiMlLrqHH8WKSryrw2UeM92wr2jYxmuQXzsJVU9XC8RUQ9XxCduUpbd+KxWd4VO7FysZfPmSlcfjkKxHTtKzl1883bQhyGLo0FfSGHN/X6rlpthO7xifveJ/es+gACesgFya9TqMPvB2RnAhreo+6iJuXyW+ZOuwhJndcWp7dqlFlCRUkeBRuoeVi4dCTRAqHFl8GV6gLn6g/CpnsmOU4/nnkmVVbgR8AS/nSzzrtqx/BHjncrtowjfdiFmn/P1AARsDlwe9lpGLqNlJynN0CvLQk9bdmTLYv9179lCJkQbTM9yqtk/UZXZKRx/mRlglHlOhgCEhg1xxILCd34Z6w3t0FY9ONzyf6ucmef5VCLK3fj+o1MrsKnMGuIFdI5bTwON5bGAPn1leYx3QQZgVYgDyvpxiGkBlhmGRYHRUSMxIjqdQjJblg3y7P77yhHRMGtPsdYDjT1bZORKasV9+sz1WQdy4Z/8+sFs4QyEkaOFRESsxSyqKfMCUkL6e1GcagjnjlA8Il3uj0TP3urow1zA8Svi4uYyDkIs5zvR0xFS+RhL7mdCt/fHlkQZMc/rdf5OMJcwvQmiPtzAEDXWOFU6Km/lV
 LP+pf4Ax
 sffkWQrY945JZtOy+hbBcFQduOiOUvF0JJZr+hGOzSfw89BZ0RFG3rwyNa3VJB6sxpR7rbq87npma8cudpsLkxdYlYQex+99ooWAuLJEqUq8PaCASJpo6UU6tRRIb0GsW6NSW9fwPnS7Eax3rRCbzrpvn7dzyZLKIw119Bf3IBBAqw4ezM0h8h5SMUMMY+ML77Vp0ajsvTadse80SOjOMKrY1nueZooouqupAY1Lpnu7HStWfN8WdnwYcx51H8alqDwOT9+PkWs/bVtQoXTnfUtpMBO2u1yeVLH+JYEboxoEB4D2Ct/NBpILK3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 06:10:48PM -0700, SeongJae Park wrote:
> On Thu, 11 Jun 2026 05:45:00 -0700 Breno Leitao <leitao@debian.org> wrote:
> 
> > kmemleak_scan() walks every thread and scans its kernel stack under a
> > single rcu_read_lock() with no reschedule point. On a host with very
> > many threads -- amplified by KASAN/lockdep in debug builds -- this loop
> > can hog a CPU long enough to trip the soft lockup watchdog:
> > 
> >   watchdog: BUG: soft lockup - CPU#35 stuck for 22s! [kmemleak:537]
> >    scan_block
> >    kmemleak_scan
> >    kmemleak_scan_thread
> >    kthread
> > 
> > A cond_resched() cannot be added directly: the loop runs inside an RCU
> > read-side critical section.
> > 
> > Split the scan in two parts:
> > 
> > 1) get the list of tasks (with RCU read lock) in an array
> > 2) run scan_block() for the tasks (with cond_reschd()).
> > 
> > Is it a sane approach?
> > 
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> >  mm/kmemleak.c | 26 ++++++++++++++++++++++----
> >  1 file changed, 22 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> > index 7c7ba17ce7af0..9f8a35ecbb50c 100644
> > --- a/mm/kmemleak.c
> > +++ b/mm/kmemleak.c
> > @@ -62,6 +62,7 @@
> >  #include <linux/kernel.h>
> >  #include <linux/list.h>
> >  #include <linux/sched/signal.h>
> > +#include <linux/sched/stat.h>
> >  #include <linux/sched/task.h>
> >  #include <linux/sched/task_stack.h>
> >  #include <linux/jiffies.h>
> > @@ -1885,17 +1886,34 @@ static void kmemleak_scan(void)
> >  	 * Scanning the task stacks (may introduce false negatives).
> >  	 */
> >  	if (kmemleak_stack_scan) {
> > -		struct task_struct *p, *g;
> > +		struct task_struct **tasks, *p, *g;
> > +		unsigned int nr = 0, max, i;
> >  
> > +		max = nr_threads + 64;
> > +		tasks = kvmalloc_array(max, sizeof(*tasks), GFP_KERNEL);
> > +
> > +		/* Snapshot the threads under RCU */
> >  		rcu_read_lock();
> >  		for_each_process_thread(g, p) {
> > -			void *stack = try_get_task_stack(p);
> > +			if (!tasks || nr >= max)
> > +				break;
> 
> Why don't you check !tasks right after the allocation?

Good question. I will update if we agree this approach is good enough.

Thanks for the review, SJ!
--breno

