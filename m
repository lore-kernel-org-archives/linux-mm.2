Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79CAC109C05B
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 20:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB4396B0088; Wed, 25 Mar 2026 16:39:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B64D36B0089; Wed, 25 Mar 2026 16:39:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7AF36B008A; Wed, 25 Mar 2026 16:39:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 954766B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:39:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A742160AFD
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:39:28 +0000 (UTC)
X-FDA: 84585750816.23.61B1CAF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 67E17180009
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:39:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=o4dEHtRV;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774471166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qX+god1XVd2ivXCYier0tY7NsB6ICtw7odjLzfpR+Aw=;
	b=n1RMEOOcdXmEA/3E8mp1YLCIjxYRhqxdmxuz63t8oURlaVCK3iV0ESCanLm9/zREaYBlZ4
	w9xVucCVoWOI8bzxY7tSXKuNeTkjtYhWbm8II7NkW4u8Ut1ndzwemDP413BvRQojSBy6FC
	HaHPXZ3CYF4Wkyc39igndHJFsmWmYpI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=o4dEHtRV;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774471166; a=rsa-sha256;
	cv=none;
	b=V+bl2KBiVSLDmrj0I7dtEGzXKDztXP6jyfKIZJhdrxw9oZp7yoldK5sxpZpFc6xiJC4zlW
	BQuz83nCIxxjI4Nzp897n9O+paXlBxeF3TfBr25nBJsvPpVjBNymM5sLL3fZpVaeygqvsi
	FG6X1FHY5KHkJZlF4lfcsnDaznbo4/U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qX+god1XVd2ivXCYier0tY7NsB6ICtw7odjLzfpR+Aw=; b=o4dEHtRV1qXOf0mlPmYYJI7Li5
	x8pyBl3KLeP8H95MLyv95XfcTpXFj0RR4J/a52leLhCW7ttG0fTz0hqwNNotVSklYRexKk28Pi+1L
	mcjlPNvgZ0Gd2qr35dYqIgUD3YTHCudurWe6B3yOfjYap5P8QxfRTj1tlT6ekKTUPDDWgv7ZpP93E
	t5i9d2nuRSHinYSzvotcMDSsacKfGdWyP1c0dDiSNDE807yrFR0EQMc8dSAGK+5z5fV5Ry+sH1cr1
	MdUoOS3RIk/Elmy2VjrESqB5cqbwrU+QL1Rp0atHaOAP4atcCq2RDO2/YNEi2cVgiXGdhPTHl5FYV
	zGMsX7LQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5V0b-0000000GVxU-2CYm;
	Wed, 25 Mar 2026 20:39:22 +0000
Date: Wed, 25 Mar 2026 20:39:21 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Dave Chinner <dgc@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
Message-ID: <acRH-fWPKkFFXcLZ@casper.infradead.org>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
 <acRE8pp6HxjK7Z74@dread>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acRE8pp6HxjK7Z74@dread>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 67E17180009
X-Stat-Signature: s6r44gi53ak7n6jsmhea69fr7kc6oqrw
X-Rspam-User: 
X-HE-Tag: 1774471166-106425
X-HE-Meta: U2FsdGVkX1/FeUjUbcoY4km/BVs0mWVlWIW05saPnR9ZuOr9UN7/HtEZ101u5z3aPeqxqf2YN1mqDYpRbaS90HodwVxyH58uBrFErVJbcgHeaJpZNEEpuKEtxbcxzwqk6QbHnaIkq3AbUD5E5QtCIZV2cYiLFwzolIRMTchWTrNywCiL3/naDSRP0w+AJK28EFFV2M3gYR5AItaLmohCTwLmCogRXnJ/NR1vhSpvQYGUwP4QW9bzWbaXyX1CIFgOwuyMZfFqq3TIdQVHxVTzH9OpEA2eeNSqkFrlBmLOy9kA9VwsWNZb/sD/fSpswoCjJdLq+SMuMtKQsLh8RNvPOGiKdGRlGE5wYUGlRxgl+Unq+N7YE4Z51mDGf8xPF3hgB9frzWFZ3d6F98W0zsQsyls4cpo+XdJDhMdzs95HidsOun1b/Se1KwrIoMZrKMITz05QZ2jSU6ggMYYermvuPCnZY+AvrQCsJdoQcsm5snKmAgt90UBoYb0tvadIOlOkKml3/rGw35w5ZVTCtGbz8NMgmthI+DBy7jUoPPR+w0UK29eiAmaoPpF9eBO0d+5Bo67PhGyhGeBzHL7rP1NkqzRNwLItFTTRUSw6psUDDzItHOASStTEgkAFJrVlwEOLUAtqnjDbzTwiRFqU5F5ne0N3YoRwciwcYUNku7wdy+RHIK0NTV/rlrUopdrbcJ8eaCnEeVF6Dd+Uo/l5FU8wQntFBXXeyuJyh7g4IDhfYHbGX1sS8ybz2mr8SkSxtEs8ujOmgwQq5plJ1FPxWqlA6QuLxV/hu++rQfGjfKa8ZvyF98ka8t6L+7RsGC6XDWw7bPBEAttOFd5j/DJI/tZHNZ6ZjGbBUs3LG1dFyfgI6nOJkVGx26zAYYXwQIfeHMnRIISDzhF3gE6IJdygCWH5YgJU0abTw8R2jQH8hKd2hquG0k7Pu+QHTWlWAdZnYF/vFuWfQgYknDvzXED4nA4
 kFh9cc+v
 pLnsjmOrPhSHpROo5vUMNvr16/9YDL3i/TimgwoY9yupP9nvb5SpkZ3yRDlht2GByFMAepMQm/EcAQZL/qTVBFLUxGaUUoJx4ulJaYnT1iS0SqWbVZQOf7U6WlxBF89Chsw9RJKe0XXOXM7pih9la8ogg0kz1yHNi52VaDGgrkViapfZ/D6Q6EoD1r8IGIBHxIxzOf9za1QsOKwFJXixDFq6GeFhO9HClHakCKDBfMwem/YTe5c30c3TP50GB6lqCPJUJWffJjgl6WcMQa8m189GiP2+3mgej/IQRGiuznvNzrg8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 07:26:26AM +1100, Dave Chinner wrote:
> > @@ -1988,6 +2060,16 @@ static int __init init_bio(void)
> >  				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
> >  	}
> >  
> > +	for_each_possible_cpu(i) {
> > +		struct bio_complete_batch *batch =
> > +			per_cpu_ptr(&bio_complete_batch, i);
> > +
> > +		bio_list_init(&batch->list);
> > +		INIT_WORK(&batch->work, bio_complete_work_fn);
> > +	}
> > +
> > +	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "block/bio:complete:dead",
> > +				NULL, bio_complete_batch_cpu_dead);
> 
> XFS inodegc tracks the CPUs with work queued via a cpumask and
> iterates the CPU mask for "all CPU" iteration scans. This avoids the
> need for CPU hotplug integration...

Can you elaborate a bit on how this would work in this context?
I understand why inode garbage collection might do an "all CPU"
iteration, but I don't understand the circumstances under which
we'd iterate over all CPUs to complete deferred BIOs.

> > +++ b/include/linux/blk_types.h
> > @@ -322,6 +322,7 @@ enum {
> >  	BIO_REMAPPED,
> >  	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
> >  	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
> > +	BIO_COMPLETE_IN_TASK, /* complete bi_end_io() in task context */
> 
> Can anyone set this on a bio they submit? i.e. This needs a better
> description. Who can use it, constraints, guarantees, etc.
> 
> I ask, because the higher filesystem layers often know at submission
> time that we need task based IO completion. If we can tell the bio
> we are submitting that it needs task completion and have the block
> layer guarantee that the ->end_io completion only ever runs in task
> context, then we can get rid of mulitple instances of IO completion
> deferal to task context in filesystem code (e.g. iomap - for both
> buffered and direct IO, xfs buffer cache write completions, etc).

Right, that's the idea, this would be entirely general.  I want to do
it for all pagecache writeback so we can change i_pages.xa_lock from
being irq-safe to only taken in task context.

