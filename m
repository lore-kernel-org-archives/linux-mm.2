Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74533606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cNINS75x
Received: by kanga.kvack.org (Postfix)
	id 72C606B09FB; Thu, 22 Oct 2026 18:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B0706B09FC; Thu, 22 Oct 2026 18:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5781C6B09FD; Thu, 22 Oct 2026 18:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 24C636B09FB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:31:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95861A02FE
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:31:22 +0000 (UTC)
X-FDA: 85351709604.22.8E92DC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 07A6F100005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:31:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cNINS75x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792708281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S6ItmhQmV+wqX2MpWL8c5Yttc4aPWEpi/wAss+677D8=;
	b=4XNZekhCviIWmFVL3L1DB24ptr8NGul9c5ENHgUjbJTe62ra8hOMeYZPhGmCcMMPKryfF0
	kIYe/+0NQ4R5y1hgLbb9PssT49yQ6CQOqSqu4mtgfwfZMIsvVO7hiE46KtV4cYSAfM7U6W
	+nsL5m+ZrCa9CmowaNWx7915mpNepj4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cNINS75x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792708281;
	b=Y71Hntlj/3rSPN44c1C0R3U8/qZknZbQo8A5ju3gZyIZ5wFwHjyP1h9oFTXffGn2VmLCli
	jz/gGq1FEBUWkgW/UJXm2fCvRTRD637NqQbB01vCCPgHE85lAL2x5c24sFC8WXg8N0Fi1k
	b9y3qARk3maBibWd/Iv6CglObPjHS1Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6433B602C3;
	Thu, 22 Oct 2026 22:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24CE1F01825;
	Thu, 22 Oct 2026 22:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792708280;
	bh=S6ItmhQmV+wqX2MpWL8c5Yttc4aPWEpi/wAss+677D8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cNINS75xd5z+a3HR344LN34/HXl5PH0//AlhRP2yTNnunWu8M3d7ff06ib5JtDq3m
	 kjSLPtVghAJmWu7KH3QGsynw+x9DyLWUYE4Cg83B/otaxto9CCwb0Mpo1vze2eKGmN
	 /g9SqYPp4WU8onhFVZOSWwdFFStB//8ACNEHlMI9Jm/C0K/8/aawzkuA/dxi93ApEy
	 4aRpstEfkmXSnJ+NJguTOKCftxGiK6f9dIYJ0W3t/R0f0WQ9bhfcs0/sKrgqG4ppSe
	 /aym6feIyigq3/SICiESMNZJmxYa7W1dHL/NxhzYMUjKEG6W/uT/QEu1zSHsAmvHt+
	 yer4hVCOeemBg==
Date: Thu, 22 Oct 2026 18:31:19 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Mike Snitzer <snitzer@hammerspace.com>, Chuck Lever <cel@kernel.org>,
	linux-nfs@vger.kernel.org, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v7 1/5] mm: expose WB_DONTCACHE_DIRTY in bdi debugfs stats
Message-ID: <atqOtyegOnvw45G0@kernel.org>
References: <20261020220346.28020-1-snitzer@kernel.org>
 <20261020220346.28020-2-snitzer@kernel.org>
 <1315c1dda358121708d6b007dcfa959653988218.camel@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315c1dda358121708d6b007dcfa959653988218.camel@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 07A6F100005
X-Stat-Signature: qjmm6fufw5eu766hu49e79bwo9b6bjrf
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792708280-986389
X-HE-Meta: U2FsdGVkX19lO8ejKTMt2CtubwtwbG/w+Frf8V7RnUHMAE380eRPxfRIY936hJEXh43OnaZogY3SCW2gxLHSCTzQv87zaQCiQkw+RgMvPc8rlf04YAqt2TZC+uljpI/MF6w40Xjp0d4NmZM2kOvmH0Lgn7KJBBxmLR3QEAZiPDenxyhe5kJ2CJu7SnxOegsOj/gj+kvs5tLA1jLYA6RKJCxgD5fupdIRCJV3/kjg0SpSMeEVMxyWIuvpr8sCaxs7Hg/IYZjKtchSDsTqc4YjyNFeyTSpSAR5o1RXmumCWRqDVX2de9tORH8ap5JaYriYCJiIUvgENCrezL0fhWBIWj44xvu8fCxCTsfitOtOMYsT7rZTxe++h4wopebyF7hnpfs5JIoPzKlqSn/0ONaB9vZY6O4Rv607z18Y26ON4LpKutZlZv29KoO4cAIu6vPBwmb2ty4kg5qehGJhq6Tp+Or+OCrfsrhf36c6agEgVHt5CynGrzGPb1eGM1vhqaB+dQiFcUcyTen7Srb9ugRrpBU2WTIN6prmhwGbALk5YPzGub1jaU5BvIleper2aZ3wISJ7cGHCqV5Q7Z01yfbvXlx/rrSgn6bfXJqknQHU+sXcm5qbqB7cZH41iCmCtgAELaeFOfDi/c2GmdMgj3kDFRErucywaZ7bVD2la9emQRBAZ3Zs+VIYJ6h5ukR4tDL3VKVB9vOmPolMO0yfbVtazA9/mWpb411RrDRQbpRMCBYzPa0A29F7vvJ8586hbVZvVWA0fJQbgd+QRtKJg6b7qsHHmFmRYg9wHv1qic75BsObllROwcS1SHTflo1lHUP4N/0GeRRLfmKCPD4R7BoOD/5eufo+RMTDhsEIUeQKg2clsFrlGkMYvRLjkYjCpuh61p8huXR3mJ8GoBBZbjs5D0yc69hpFDLJZ7IUzCByqHZigt5uESwcLkDXLg1TNP0/yjC5dZXYZiOsOS5p/2T
 sEVCefW1
 /8SQwECDiZN4rgno8f5ig6o8MrkmkwfoS7RLX0zCmIdyQeKCS1MsPN6xBASnCv3rpDyd7gRgPUH7i2Dp6g2kSiI6QjC84RiajOgUYJ7NnmSvlSCdvQ6QJw+Y2qqpBV9cMl7MNEh1CnsVkNumX/wBKux1Hvabg6cOEeRqxnSTvWFKR2znHv+HlTmKbtDrJqFAJH6SL3uk1CP8r+FWv5s4d91fr7ZGjWEct2t7oh9mbbHxcdeVhNzM/9ekUPik1jqqlVeefCMq5G6eKc5iuzEXGOJNHyVV72rVuVndub2MLmhBb4jWnEO719PZ5dHapE9/e1/2Kh4Sh69iF8+WCWm+iR6tXCCfQwD2lKj+h8p/Qs9xFlDpKlyBv8jZxUL5K1f6U9rIVSh00Yu+Dzbc3v+Q558gajYutAsPobMsiJ5hLOshzl1VBF1bx9huwDgU43f5NXdz9NAZ0AJWnHi4KM/A4BDIg+L+4wG6lNb9UJL1yVr6LCNJaRHswa6+wcJFZycQVEbeh9Mh8FGEknaM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 06:50:47AM -0400, Jeff Layton wrote:
> On Tue, 2026-10-20 at 18:03 -0400, Mike Snitzer wrote:
> > The per-bdi_writeback WB_DONTCACHE_DIRTY counter drives how much the
> > flusher writes back in response to an IOCB_DONTCACHE kick, but it is
> > not reported anywhere, so the DONTCACHE dirty backlog can only be
> > inferred from MemFree/Cached movement.
> > 
> > Report it as BdiDontcacheDirty in /sys/kernel/debug/bdi/<dev>/stats
> > and as WbDontcacheDirty in the per-wb stats, next to the
> > Reclaimable line.  Use wb_stat_sum() rather than wb_stat() to fold in
> > the per-cpu batches: the flusher targets the summed value and small
> > backlogs would otherwise read as zero.
> > 
> > Fixes: 88d6f128d06d ("mm: track DONTCACHE dirty pages per bdi_writeback")
> > Cc: Jeff Layton <jlayton@kernel.org>
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Cc: linux-mm@kvack.org
> > Assisted-by: LLM
> > Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> > ---
> >  mm/backing-dev.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> > index 18e999053bae..b8a2c27e07fa 100644
> > --- a/mm/backing-dev.c
> > +++ b/mm/backing-dev.c
> > @@ -46,6 +46,7 @@ struct wb_stats {
> >  	unsigned long nr_dirty_time;
> >  	unsigned long nr_writeback;
> >  	unsigned long nr_reclaimable;
> > +	unsigned long nr_dontcache_dirty;
> >  	unsigned long nr_dirtied;
> >  	unsigned long nr_written;
> >  	unsigned long dirty_thresh;
> > @@ -78,6 +79,12 @@ static void collect_wb_stats(struct wb_stats *stats,
> >  
> >  	stats->nr_writeback += wb_stat(wb, WB_WRITEBACK);
> >  	stats->nr_reclaimable += wb_stat(wb, WB_RECLAIMABLE);
> > +	/*
> > +	 * Sum the per-cpu batches: the dontcache flusher targets this
> > +	 * counter via wb_stat_sum() and small backlogs would otherwise
> > +	 * read as zero here.
> > +	 */
> 
> nit: I don't personally find this comment very helpful.

Meant to address "why not just use wb_stat()?". But will drop it (and
leave it to commit header to explain).

> > +	stats->nr_dontcache_dirty += wb_stat_sum(wb, WB_DONTCACHE_DIRTY);
> >  	stats->nr_dirtied += wb_stat(wb, WB_DIRTIED);
> >  	stats->nr_written += wb_stat(wb, WB_WRITTEN);
> >  	stats->wb_thresh += wb_calc_thresh(wb, stats->dirty_thresh);
> > @@ -125,6 +132,7 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
> >  	seq_printf(m,
> >  		   "BdiWriteback:       %10lu kB\n"
> >  		   "BdiReclaimable:     %10lu kB\n"
> > +		   "BdiDontcacheDirty:  %10lu kB\n"
> >  		   "BdiDirtyThresh:     %10lu kB\n"
> >  		   "DirtyThresh:        %10lu kB\n"
> >  		   "BackgroundThresh:   %10lu kB\n"
> > @@ -139,6 +147,7 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
> >  		   "state:              %10lx\n",
> >  		   K(stats.nr_writeback),
> >  		   K(stats.nr_reclaimable),
> > +		   K(stats.nr_dontcache_dirty),
> >  		   K(stats.wb_thresh),
> >  		   K(dirty_thresh),
> >  		   K(background_thresh),
> > @@ -163,6 +172,7 @@ static void wb_stats_show(struct seq_file *m, struct bdi_writeback *wb,
> >  		   "WbCgIno:           %10lu\n"
> >  		   "WbWriteback:       %10lu kB\n"
> >  		   "WbReclaimable:     %10lu kB\n"
> > +		   "WbDontcacheDirty:  %10lu kB\n"
> >  		   "WbDirtyThresh:     %10lu kB\n"
> >  		   "WbDirtied:         %10lu kB\n"
> >  		   "WbWritten:         %10lu kB\n"
> > @@ -179,6 +189,7 @@ static void wb_stats_show(struct seq_file *m, struct bdi_writeback *wb,
> >  #endif
> >  		   K(stats->nr_writeback),
> >  		   K(stats->nr_reclaimable),
> > +		   K(stats->nr_dontcache_dirty),
> >  		   K(stats->wb_thresh),
> >  		   K(stats->nr_dirtied),
> >  		   K(stats->nr_written),
> 
> Patch looks fine though:
> 
> Reviewed-by: Jeff Layton <jlayton@kernel.org>

Thanks! 

