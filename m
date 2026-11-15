Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E14D2606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 21:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DQtCWfou
Received: by kanga.kvack.org (Postfix)
	id 0B5456B00EF; Sun, 15 Nov 2026 16:23:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065D86B05B1; Sun, 15 Nov 2026 16:23:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBD7C6B05B3; Sun, 15 Nov 2026 16:23:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C87FB6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:23:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 513F3C0609
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:23:41 +0000 (UTC)
X-FDA: 85438630242.08.4AE2CA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id A59511C0005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:23:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DQtCWfou;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794777819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIErJBE4pTmp+Ek6j7ApefZdRjObg4z6oE12g+W9FPo=;
	b=1eDtnHTCx2FWJKDxZdu3vj1lk0SCu5ievEbQCMz9HkYmDo9lCWFKRLaA4DlpUl/e5RqRCr
	mKPWPAFCQiN6kvsr7+z9PI8kKUtpt+veu3YgdVaXmm4xIVc2GIbkNxxGvnmsLaxB/6TUSz
	gUlo0CSaFzeBBiXSyXFtgqAsUxiXnEc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794777819;
	b=oDPfwchl7D9JZcJMiFHxoNStlrPWYqbxJuS4n6SLZbUz0iBBFQqPZEpEbmdKvqUjLqyc3c
	9dgRovT9Jv2kCM1UifTRd3oxOtYgU5/S4QhRLrXFukCeYJKDgQdYg9g2kaES/FjAP4BIGV
	LRSfzQI7HJRwbB34RtXhQ1+XYbGtWSI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DQtCWfou;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D754B42A46;
	Sun, 15 Nov 2026 21:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F071F000C4;
	Sun, 15 Nov 2026 21:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794777818;
	bh=BIErJBE4pTmp+Ek6j7ApefZdRjObg4z6oE12g+W9FPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQtCWfou/P7cpdyZdSZ5+j9dv++E7R752cAV4QGLLHLvnvcVOOCzcC9EK+jeuX9Wj
	 09qrsIpzpU9uPjlOg1ibGAPiypKvhqyzgcZXiPJdjxew6fvZ2LqJQiNXX8knTIoUI0
	 sM51aTSEDevwGIVQQO7aKFH2w2FbnT32DZZ2tiP1rlbvj/2UpztJK2CrA+CIMODbap
	 +lCJWMRT5JhU9CrJKsYin95sbtkG9Va4i/ibJX2NyPWT/DBpyr32sxOZ1k5BZUkg2R
	 WWMDDwSs/+FWrl3Y8I+jvj/j3Z/y9h/wrBmq+tkwTl/iySQ1pSZWdNI87pEQiTtg9G
	 f+FmyBN17auIQ==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 03/27] mm/damon/core: introduce damon_submit_report()
Date: Sun, 15 Nov 2026 13:23:30 -0800
Message-ID: <20261115212331.101376-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-215851@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wctug3r4t8i15xokyz1su949qga8ihhk
X-Rspamd-Queue-Id: A59511C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794777819-727724
X-HE-Meta: U2FsdGVkX1/P9AJ5qG0XVihudyr850Xwd/D8itc9mnBg6iz0U86ICuWImjJWH9cqw8ztj7Kq1FUIHd82P9JEpfdXiFfQmC9cFOIPU6ylkgy4f9tviPBiWc4trugIvQcRRPUXP6KqczzHlcIrGjL9jJKyczmvhXWsqq2Yu84EeBKJiuYSqivxYA8cDbFrCHfpSF3kUDI3XHSuFWbOwBYXNCTRjlSA//ho600xZE9/KIFezYdUJbqnWPLuxYYAbv6LhdeoKR3nRA/O0g9pvb1bRdtjWOOedOatZpi9GhwL4CJQhqlZanaS+OIdcZZ9sBCvKxTss7iYuW125wI7HX1sRozoaiPSgGWKI7WUbaqUxLbL2QwgUDPioN1rW75kMPq/L9O2Kt/EapHLLwo6VY6ZPx7VJ24Mbx66WZcdoL8FlxlxEpFQ8GbKm0UaIWEVrusaEKY5x9lQTQXN+kF0+ubQWlDgQsKcvAaMvZeNgp70qXTh4/dXJ3uCVSagJ5nSTR6+j3nf3XiCdyan4x5Jl90iS1vtwinck9UKERhkSH+jGbkfKLxLirc8dxcp6DDZK4Md08vDebzIILCjtRVqRDRpoByyoHCRuu/0xlgG4ZV+i0jZ86BZ/Ot5SR+FKV8cJN38WxGMApQ8orCzbrWc/xPSRiQh5/z+jnK/VhjWWD7g3aAQNVi9ToirwI56S6Hpbv0nnMIqXGLE0PJxzA7lPSw9BodeR+efj4ixfjbdM0SrE91/axkl7rqwcyffAXEFSiay3hdEkhVmsQLUD7VY3jlKKS2HXOIFsvbkGNrP3EBjHDAB8Vi74qE8+UCHfisxB/bosdgH6rN5jjpl638iMyVpwFhnZzELDg2SnlyQuBq7FJvV0lovIQiCmQmCPCxdnFLo9AptLvd8AxBs1ybvNP2SSuRipxWUR7HfhvHwOLMbG81eK5r2IwPK4sBJky/5jUTdPFv+ujb68pRwlbs2q4O
 4jyG7KHF
 8tJlf7foxaulCqvXf1Y0D4Q6XppFV95eiAdaSxO93qSKuEbk0ialqCq3hVW0v4bfoYZcCrXw3PDdAwBEPsylP4eHuwE97Jp13gL9s3ysFxNgNL895yZScfsOCvLerjAL0s6gMEvY9cV+xbM8KGo8CulfYxCCikv9lzpfruJ+sQOK8rouKRUzhbpcKWfAtcQJRSv2+Trw9Sg99MtNjIELXldU4GWdIGmDHnsfR0mdsrYHHnDwM85aFh5Y2wYF6YKPXFMJxqNFfOCmE1UdrzJt50LeuCkYWsftkP2yM7AI3fFXDcNjZVnVbSSlijawByMwHdMNRAG6lA9dsxN8TvnRxvaWabitUFYSBmDWBMbYxqG/jgZfYSpfNpjPMsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 15 Nov 2026 20:42:40 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [High] mm/damon/core: out-of-bounds write in damon_submit_report() on
>   queue wrap
> - [Low] mm/damon/core: missing Return section in damon_submit_report()
>   kernel-doc
> --
> 
> commit bcb278386fb51304d0c224892db9744bf9e27c8f
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: introduce damon_submit_report()
> 
> This commit adds damon_submit_report() to enqueue a data attribute report
> into the DAMON internal report queue using CAS-based try-locking.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 3f87a7eec442e..06b85d00e38d9 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2353,6 +2353,36 @@ struct damon_report_queue {
> >  
> >  struct damon_report_queue damon_report_queue;
> >  
> > +/**
> > + * damon_submit_report() - Enqueue a given report to DAMON internal buffer.
> > + * @report:	The report to enqueue.
> > + *
> > + * This function can be called from any context including the NMI context.
> > + */
> > +int damon_submit_report(struct damon_report *report)
> 
> [Severity: Low]
> This isn't a bug, but the kernel-doc comment for damon_submit_report() is
> missing a Return: section describing the 0 and -EBUSY return values, which
> triggers a kernel-doc warning under W=2 builds.

Nice catch, I will add Return: comment.

> 
> > +{
> > +	struct damon_report_queue *queue;
> > +	int lock_old_val;
> > +	unsigned int tail;
> > +
> > +	queue = &damon_report_queue;
> > +	report->jiffies = jiffies;
> > +	lock_old_val = atomic_cmpxchg(&queue->lock, 0, 1);
> > +	if (lock_old_val)
> > +		return -EBUSY;
> > +
> > +	tail = queue->tail;
> > +	if (tail == queue->size)
> > +		tail = 0;
> > +	queue->reports[tail] = *report;
> > +	queue->tail++;
> 
> [Severity: High]
> Does this write out of bounds of queue->reports[] after the queue wraps?
> 
> When queue->tail reaches queue->size, only the local variable tail is
> reset to 0 while queue->tail++ increments queue->tail to queue->size + 1.
> Every subsequent submission then bypasses the tail == queue->size check
> and writes past the end of the queue->reports heap array, corrupting
> adjacent slab memory.  Updating queue->tail = tail + 1 would wrap the
> index properly.

Good catch.  I will remove tail local variable and just use queue->tail.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261115202849.99134-1-sj@kernel.org?part=3
> 


Thanks,
SJ

