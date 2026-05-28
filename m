Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84A6CCD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B97586B0092; Thu, 28 May 2026 05:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B48186B0093; Thu, 28 May 2026 05:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85266B0096; Thu, 28 May 2026 05:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 96FC86B0092
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:01:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 32D74A07DA
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:01:02 +0000 (UTC)
X-FDA: 84816233964.16.9597BAC
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf15.hostedemail.com (Postfix) with ESMTP id 69DF1A0007
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:01:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779958860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g3IEh3p9BTcBWzmZfCfMXP/txe8uVJe+M3Ryd2QrU8M=;
	b=W4liLWGZgkTnr1wzwV+tyVBPkFiiuJ8aXt9bPhzmegr5QzgByd2qxZCC4PNK8UPiO4KgbV
	eOlThdGG08tV3CMcVYh3OyDBMw6I9ZCHp+B2yl4pXvTXDj8SoaXMayCinx/icl+1KO8sAR
	wCKPtaPT6GgdEbSXkHnmvkBzt32U1Ek=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779958860; a=rsa-sha256;
	cv=none;
	b=lx/sYLXAF81frm8zHr0v2BzQ2MS4MxjULHgA3i4V98YCrIxPyus4B22IPEi/eTjOqXJHs1
	Gtq3DWExcB5pFXD0vAlEhYUrl+CfKzB4euf+QnRF2VQhiqq/dsy3BMRWu8GZgJg19IkvJc
	OINm9387zcon8/FbElMtIGtKkvfjHUw=
Received: by verein.lst.de (Postfix, from userid 2407)
	id CA31868B05; Thu, 28 May 2026 11:00:54 +0200 (CEST)
Date: Thu, 28 May 2026 11:00:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-nfs@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: revisiting alloc_pages_bulks semantics?
Message-ID: <20260528090054.GA8376@lst.de>
References: <20260527071816.GA17632@lst.de> <df21e8b0-a67b-4b71-8178-91221b596949@kernel.org> <20260527121920.GB6079@lst.de> <276835c4-78d4-411d-8097-93cdfb000648@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <276835c4-78d4-411d-8097-93cdfb000648@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 69DF1A0007
X-Stat-Signature: r536hi57e9ocxadegbqkb9g7g9kspiz4
X-HE-Tag: 1779958860-281038
X-HE-Meta: U2FsdGVkX19GGWIHlaiUDUaV2lcs81rcSeAd8zusgVIrqLVfWBRgTdCHKsQxkWOQTtmgDnWQ5yJgbkXc7chKY6DKLD50Se5sz1Zh9WfmEOwgVk971jnm0TZLwHYTmzoQ5niYIz4ngalJe2hctjVG9z3CZw8JsvKOM4MU323zgPwoKX3XAhvJmqPA/GrmoVm2y6Dtxj0m8v/MOg3v1GITYflKmXaushhC7jMDdnKtO7/NnV5CdodHATPBi5OEQhMKW526Bar5q/iGjoccdpQBaFrePh7ipB1Pmn3CAN3+5zi/fFO2uka4rDXDKTKV83j78QbjDibL15I62UEU83HBxUcwuGTEGfWDH8MYJP5Up2dNxkQfxaxnrPatMkxDZIz1QXde3OV0kPJ7GjuU1LMzuxujPxPuFVQKVMweUZseahBMq1640AATGLeCqbAQsiSlD82HqYCQd4YaFlSEdbfg/1ZZTGFFXVrWgIpBEKX98cE9ArSE5j+TQd5Wg1QOC4kk+02eKcxHisOqAYUX0WdXCVnUZAvyHrWeqzShFZSK6MI9WGJaPSZmKOpCPguRM/lgBuMPa/Uty2GnKa4/LNH4EYic+Nns4+gytcdGvQXpLqZ1VrJCpt1izTnJrDcHQ8BVoJOdF9lCCRcV+3+TbCgOhgwWTNdgBuspfQjkQGZEG/zIeTtFDdN/NMDJhA+ZRjYWiPIrB6smzbaScIqarTcskH1vJ+r3L3Pm2q7PMsq/pOgK0vdDGU40EJVpKd2bi/+yXKCV8hF/hfkfVvoIee6IL+NGbZBy+UHwh5vlLb1P+VSwTHpEeHrL7hiKGosWAWoDY8cjhkFSMvdV129R3jhO6EM4gOH5PRTYwQC7RKzAhRnEKzzO7ViRVHEBUlvAwM5i5E3a8+kgfkf/wR35C6eQeKPR2HbzvyRE4ziBnnfnoC4BfQh+uLNbU3teMoLPuJ0xYy5kZi1EWLZ4UqA9eke
 +Qa3ULlZ
 Gfzla3xaXI6JisbS1bbp/MRCFSr7n6EVm16S6+QjnHDfnI96zQHakVNRiRyuUWu5C47eYYMZRFLdhwRfQOnnficHz+yWlxGveffPvRDWN0MwtemBxH4DOEXc1EMIYBr2YseY6vbbFXze6HXu8xEEzFWNjxk+yvvhqkI6lh4Br3NwTQBFPSyExDO5de40nvqWNpKqk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 09:58:11AM -0400, Chuck Lever wrote:
> On 5/27/26 8:19 AM, Christoph Hellwig wrote:
> > On Wed, May 27, 2026 at 12:06:08PM +0200, Vlastimil Babka (SUSE) wrote:
> >>> alloc_pages_bulks can do partial allocations for some reasons, and
> >>> users usually have a fallback by either looping and calling it again
> >>> or falling back to single page allocations.  This sucks!  Why can't
> >>> we get our usual try as hard as you can semantics, requiring
> >>> GFP_NORETRY or similar to relax it?
> >>
> >> If we do that, do we keep the possibility of partial success, i.e. return
> >> how many were allocated? Seems wasteful to suceed N-1 and then throw all
> >> away, if the caller can use a fallback only for the last one.
> >> Do some callers need all-or-nothing semantics? Should a flag indicate which
> >> one to use?
> > 
> > A lot of callers (but not all) need all or nothing semantics.  But
> > freeing already allocated pages is the not a major problem - the caller
> > just has to add a release_pages call if it didn't already have one
> > for cleaning up later failures.
> 
> What the svc/nfsd thread is trying to avoid is sleeping uninterruptibly
> waiting for memory resources. That stalls server shutdown, among other
> things.

I'm not fully understanding the sentence.  I guess you mean that
you want svc_thread_should_stop to intercept some memory allocation
waits?

> > I've added Chuck to the Cc list, but from memory sunrpc actually does
> > make use of this feature and he objected to previous attempts to
> > change it.  So a first step would be to have a lower-level helper
> > that works as-is and a wrapper that zeroes the array, even if that
> > doesn't feel as efficient as it could be.
> If sunrpc is the only user, it might be sensible to hoist the "zero
> fill" capability into sunrpc.ko.

As far as I can tell it is the only one.  But I don't really see
how you could implement that functionality outside the core, except
by falling back to single allocations, or looking for empty slots.

I'm curious what you think about willy's comment, or if there is
indeed a way to always use the pages from the beginning or end in
sunrpc.

>     svc_rqst_release_pages() NULLs only the range
> 
>       [rq_respages, rq_next_page)
> 
>     after each RPC, so only that range contains NULL entries. Limit the
>     rq_respages fill in svc_alloc_arg() to that range instead of
>     scanning the full array.

Does it NULL the entire range, or part of it?  Because if it is the
entire above range, you don't really need the check for NULL behavior
at all but just point the bulk allocation to this range.


