Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 831AC606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 21:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BwYVRuQ3
Received: by kanga.kvack.org (Postfix)
	id A94B26B05B0; Sun, 15 Nov 2026 16:17:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A45C76B05B2; Sun, 15 Nov 2026 16:17:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95BF46B05B3; Sun, 15 Nov 2026 16:17:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 753BB6B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:17:33 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 15366A081C
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:17:33 +0000 (UTC)
X-FDA: 85438614786.27.A2D9386
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 603E5100003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:17:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BwYVRuQ3;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794777451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EE7GAzdHDxgyN97YRBQACDLzjUljmIUH3x5jpLG84+E=;
	b=5RsQCIffGXn4p56rP3OLdcKtK7hojBONKejfLDQ6S750olNW4pEr177E0G2fjvcKBvixcY
	LIt8iIBReg56njIGG005KRCN7MLqyoM3sNvCnJIuBqROf/6RiGGFwEG0xcOKeq56T+6hIs
	OYcP0vJZgODVlG+OOy2Hdz2E//+et04=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794777451;
	b=GxHZ3osf95GCl8x7umN2wpnW1LUTUi+2QhQY2AIxYgPyzh9jB2UnqUMWEgMxFp3qe4Yxec
	/3hQ+aBjgXDeqdcB7zWPe0PJPd+JDvNCY3jScGLrdd9xpvba8Aw1/cUnYPHdBfIK51qDqI
	dxy7FZT+RSREfG4UEp+XpE48/zfi51A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BwYVRuQ3;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D606D60D5F;
	Sun, 15 Nov 2026 21:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FDC1F000C5;
	Sun, 15 Nov 2026 21:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794777450;
	bh=EE7GAzdHDxgyN97YRBQACDLzjUljmIUH3x5jpLG84+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BwYVRuQ3+jmYVOnw/z8CebDR+LNz8kgr/CPQcAxMUOha8IjB4i7VZajFRhyWLuqtB
	 q9TepgLNsgS7Jb4tOeJm8PDeo61l/KRfxdxIFVOVf4TsQUd9Vm5tQ1N1UQfdsazrUb
	 iPNyRpeVOgme/P5NUsn0f+MHjoY3Vc4rmKXQL15Td9oi77VU7OZhp13RYijWXWvmgn
	 x/yMNpxtA4FfVnarTOOFCre6EWFUg1+3+RJUV9tRXPA4etZk8oMMVgtWBitvbsMVJm
	 vlgvvGm8nSN1aE0SBLNCls2Zo4ae144ELao1ZMKnh7+4aS37Q3hb6oQf1C/ty7OfHN
	 cmpRAt0jGMkLw==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 02/27] mm/damon/core: implement data attribute report queue
Date: Sun, 15 Nov 2026 13:17:22 -0800
Message-ID: <20261115211723.101033-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-215849@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 4p3oe61ebixfq4h9dhqmimu9mtc563u3
X-Rspamd-Queue-Id: 603E5100003
X-Rspam-User: 
X-HE-Tag: 1794777451-42242
X-HE-Meta: U2FsdGVkX1/rS1iW+hO4EdcFHXpvIIETJAL+s1GTiKyJQmMTfwhcDfLMRIg6qEU1IRnqzpnd2nR/C6rFykHZSqwJmYmhSN+BiUrrwFevSv13tAmnkM2oy/YUOCpLKmyJCyshgnB6sfTqF6QRt+n+wgp2MORsM8tXbsmMksuhXrVeLXLeEJtBwKjxalIpnmhWiONXkb2PFmtuhSRu1qhylUw7cIvNJKroFbZrJMe/0fbs7xrqxIAPcWisz43Dic4cf1/dVFZITXEvDG6VTOFMjWaTzN2CELLIv5mnx3SeQw1vP2mHFBwNJQ3ys+Mi9YkjwBUn2rbOJa1UrHw+bOQ/iYpBYG6hhk4qRlHsEb3hrW+he/DUmGGmuuluFL2JiWh6kVDsWOk/r+IzwSUI8gMWnJG9W2F+oPAocwxp+r9PCC8WQzx4ZJOTlbm4iRrxoAAE5+SMxTwZkDHH8MD+MAHu1DIVcOzWrxESbPxTUU9PHsBphkVN8HQw0vk9bHOyY/6XzOipN8sPL42CrqzcGFYNffoBorFb0ZjopRj5t+6XlUweILBpyeDa02pALs4xSrb/PmqVw1vN2dCVyMjSeqAl7CBjBdOLKXpDsgF4VilejL6YBPyVqGpJIiCDJnK0pY4ELWXjoAaayJNZswcaqqgQcK1JTX8QGxNpdBPFW8MTKHOyTCt/MnrDPA9/qyuwYTxtcetEgST4Dn8XkzoDU9Q4bK46e+A6dXdUf59l1eCq37PMxZpb9iEfxgtQt09PPx3G8H4hvmXdHKXVXB+CPA1VUBXUz+B2Jyiz6jLLh+lEHew4wESc/yctzWUdZ4SO97hiQ9iKwG2NxTjUHXr+W5g/Lbif3dWlSNmk/Ol5nL7zTOCKV9f6jh9I95e9XuHDhKdLRyA+cWaIm9TyaStbsoeScq7NFoUastacY6LJpTPpyqqZKY64sbjjefMTBFOpI3k7fP1fVYDv8jGLWXd9t2j
 a83SuS9l
 VUzies2BsHvWI2UE3QL4qQRH0OIcOuDdaSqs3v6/djSjyqdTSsicpr+ryrCFqXWZZvxHdRCZTjI73cDggT5DUOJ1S2JC92v7Yos4lOsYylOx8CYAegA054rIbJqqhxDIP1JvIu3+aNHitNJsq57XoDpOQYCZg0rTVNzajj0C5ZtI6Ci+fE1xVJTtxZ6WPduig6+YZTq4hDF46E2rgLBeINKkd+OY54qnm1V4elzQD/P4WbkMBbtO/eC/p4BzEcCB0CumqqdhUJ0+HXsg7vBqzF7hWtJmceXnGHL0m/vovYXErGxFOSDIvwinODI9vzIk6kI/A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 15 Nov 2026 20:41:23 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 3 potential
> issues to consider:
> - [Medium] mm/damon: damon_init() leaks damon_region_cache on queue
>   alloc failure
> - [Low] mm/damon: missing static qualifier on damon_report_queue in
>   core.c
> - [Low] mm/damon: struct damon_report_queue comment documents head not
>   nr_reports
> --
> 
> commit 10a61bc9bab6e48534e4a8552380aecaccbee97a
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: implement data attribute report queue
> 
> This commit adds an internal damon_report_queue structure, allocates its
> buffer for up to 1,000 reports in damon_init(), and checks that buffer in
> damon_initialized().
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 0a056949604f9..3f87a7eec442e 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2334,6 +2334,25 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
> >  	return 0;
> >  }
> >  
> > +/*
> > + * struct damon_report_queue - &struct damon_report queue.
> > + *
> > + * @lock:	Represent if this queue is being used by someone.
> > + * @head:	Head of the queue.
> > + * @tail:	Tail of the queue.
> > + * @size:	Size of the queue.
> > + * @reports:	Array of &struct damon_report.
> > + */
> > +struct damon_report_queue {
> > +	atomic_t lock;
> > +	unsigned int tail;
> > +	unsigned int size;
> > +	unsigned int nr_reports;
> > +	struct damon_report *reports;
> > +};
> 
> [Severity: Low]
> The comment above struct damon_report_queue documents @head, whereas the
> struct defines nr_reports instead.

Nice catch.  I will remove the comment for @head and add a comment for
@nr_reports.
> 
> > +
> > +struct damon_report_queue damon_report_queue;
> 
> [Severity: Low]
> Should damon_report_queue be marked static?  struct damon_report_queue is
> private to mm/damon/core.c, so leaving damon_report_queue non-static
> exports it into the global namespace and triggers sparse and W=1 missing
> variable declaration warnings.

Good suggestion, I will mark it as static.

> 
> > +
> >  /*
> >   * Reset the aggregated monitoring results ('nr_accesses' of each region).
> >   */
> > @@ -4308,7 +4327,7 @@ void damon_update_region_access_rate(struct damon_region *r, bool accessed)
> >   */
> >  bool damon_initialized(void)
> >  {
> > -	return damon_region_cache != NULL;
> > +	return damon_region_cache && damon_report_queue.reports;
> >  }
> >  
> >  static int __init damon_init(void)
> > @@ -4319,6 +4338,14 @@ static int __init damon_init(void)
> >  		return -ENOMEM;
> >  	}
> >  
> > +	damon_report_queue.size = 1000;
> > +	damon_report_queue.reports = kmalloc_objs(*damon_report_queue.reports,
> > +			1000, GFP_KERNEL);
> > +	if (!damon_report_queue.reports) {
> > +		pr_err("report queue alloc fail\n");
> > +		return -ENOMEM;
> > +	}
> 
> [Severity: Medium]
> Does this error path leak damon_region_cache when kmalloc_objs() fails?
> Destroying damon_region_cache and resetting it (along with
> damon_report_queue.size) before returning -ENOMEM would avoid leaking the
> slab cache and leaving partially initialized state.

Good suggestion.  I will do destroy damon_region_cache.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261115202849.99134-1-sj@kernel.org?part=2
> 


Thanks,
SJ

