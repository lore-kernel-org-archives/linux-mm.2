Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6074E606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 01:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JB9GbvwY
Received: by kanga.kvack.org (Postfix)
	id 842ED6B0BEB; Fri, 23 Oct 2026 21:12:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F3E76B0BEC; Fri, 23 Oct 2026 21:12:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2CC6B0BEE; Fri, 23 Oct 2026 21:12:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E58A6B0BEB
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 21:12:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB2BA160208
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 01:12:01 +0000 (UTC)
X-FDA: 85355743242.25.11DFCA3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4FC1D40004
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 01:12:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JB9GbvwY;
	spf=pass (imf27.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792804320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qqcjA7DNdTq+xZwtRnwCLNkrsUov1CecwEVrKr3pes8=;
	b=2LOij8xMs+RHTZXyzk3jvLa8npi/6bqbYmORBXubV8sB9KwZZtVtLUcNvmSzNt1O3fUlYt
	7xZwb+a2mnEjXlFo00SMsk+2V5kjd9j3i1pvO3192EIUz0lp0fKtaEOBvvdE2YdeM6R/QZ
	00hM98pPsS4ET+KihCqxz2nn7hUMJX4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JB9GbvwY;
	spf=pass (imf27.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792804320;
	b=V5dBnsE16Eh4U53BmfBXfAkUqasnxM93my9lTj+kdUhsbtT3Rf7hhdC7BAdCCx9nWrg/YJ
	C+Oa/bTOK648iCefjb27UHTZuxD3pcGERE9mth5uktWF8h3048CgmXMfDFwP9VhyON/AxV
	Ku7hM0O6HordG8vAzp/P/1O7yT4CZ3U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A92C7601DE;
	Sat, 24 Oct 2026 01:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6E51F01825;
	Sat, 24 Oct 2026 01:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792804319;
	bh=qqcjA7DNdTq+xZwtRnwCLNkrsUov1CecwEVrKr3pes8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JB9GbvwYUPYu2AenF8uiR5+l/yJlmYsyVbpE5bjdXpbiNpcMEu4A+zbRAGiFuQrKV
	 lAH9sjVruL0NoEC4b45IRnzOd+ue2Xg+QmfwVwdYKi57DDN35Nt2+OJZaqWOUknrJF
	 kpGU8VWhL87l2F0PgDsav9PgAEIQZn7q9mXAxEpuSTyrtl7A73SwzQQ+1RI+37OKXR
	 b7kBNAdR9lsOR1Mg0J8REHrYPrSUqd5mP8jZxguQa9TGrklVdop/NKfhivSBCynqxm
	 TAk2zyy5KVGDryqPIFGoyLvQO1kJhmq6BrRtqj1l1+VuBF0yLVT6fpdhHMkTgKa8Kp
	 mHe3pNskHcJxA==
Date: Fri, 23 Oct 2026 21:11:58 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Chuck Lever <cel@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v8 1/7] NFSD: cut a misaligned direct-mode WRITE at the
 mapping's smallest folio
Message-ID: <atwF3s3-VtUkooZI@kernel.org>
References: <20261023024548.71123-1-snitzer@kernel.org>
 <20261023024548.71123-2-snitzer@kernel.org>
 <36498551-15ee-4a55-9757-54aa8a07085a@app.fastmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36498551-15ee-4a55-9757-54aa8a07085a@app.fastmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4FC1D40004
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: c6dubwzeuoau9ssqzjtzz53995jh1w45
X-HE-Tag: 1792804320-266968
X-HE-Meta: U2FsdGVkX1+Kx1kOjNWyv8ER9hMMJZ7zGYfbQAIr1O78T2yeC+gCFmAFof99KfB88RvyQJ0Mzi+2GUj0EzpsngIJGK7NmN2GBIbZxFMhrgN8shYV2a/MteleDBkHc3/Tw78csdfSx8JdNHKMaCUcvcIhxi241C+52HbadM0mhn074mumTLP3T8Leo1a3a1RxYmjXa61OaMPOXnMy3WRswBOBevsbjUmo9ulWXciXg6VJE5ErzKHtJzFtDCLY1FhnIvArs6WBTMY6YXstGUXsm2lmwEjwBVA8EY3vbGhFtMkVI+ExH/jgsT+ZuAXepo/3BL9XQzEbfRCrnk+1R70YyHj7eH9Uuy7jxUjNmB+DNnhQ8++VW2IQlFhY1i50YU0uhWgCIlVqm1kQPKVHP5d/ZeqGnDTYThxfUOnx0OtP76QYCEcydtWiKCTW+Oobw7TD3rw0AVwSA1+TRsUBxjhq4UM/ruPqxAL4akeKlYmgduA24oKFohG/CLknZ4SjODJrn6EtRORlUxGih2OwBu62WKTRMmAg9rSh6WrcORMqwX8fODzKouFSmYuvsR3B8fHRKE7fzQdmr5L4YJcVLF3bZQtO+rSYVcOJm4YvphU+GKq0Idb8wZHXJgzN7U1ytJ9qEYEvt5sOrz7Uc13VxIeClpHYj2OsnLxMv2stMBcO3dTWaixm63ZI516cKgm9kiWjXdC2Tnr5OKDA3T/9QouIvb6mcNbJQLtt1GnuhtxvwM70VSS1Vt+3s4qk76dcw0D4esnzqhcSOzFig99yUTTWMrw2B6NfL2ssZJZQYmO5u7dJuMk7cG1U1SlWochsNtzd/FiU+Mz9cZIiPy9KMxIHlG7n5MSmRop1Ya7FtBye5IcvmzRn+t2ohYHl7dcEcU+eFxDudIVJy3/1Ip+rdCojgkYe0gVxh/y4ZAlVk8C1gotHzYAJdERYH9ErF7EVv7M8xlDYdmypMkcvf8ItvRZ
 lXvg+YsN
 b2XtiA0ro8IEwVfo35AeNYrebDGx5/+B7zmuqrHeP+r/zwPIMHHgFsBvbww/uUXiimqyA6bCqbVOeqgyyTT51y3io4kLtxhsrMyIPtugGYA74sZu+bhVO73lDCYl4hVHdMjWE3xDpUdUlaEFCWiPn3gv9yy1Dev8Ewtuh/hkqkubxZoFX2nqWTGg+uum0cBCHzKIP0Kb9J2OrllHwnLBEemr4Prm5/nJZXWDSATEhuuNTL7STnp+BX7vQTQXhQQ1wWu5y70GOcoTLS88CD3vgwTYjJ6sYuSoePo4GWn+kjjWfW6/5gAiot2uRKUWqYgYsWN/7Ktlsgd69xEO00ZUlup/nCUwGZA+IHiwh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 01:45:21PM -0400, Chuck Lever wrote:
> 
> 
> On Thu, Oct 22, 2026, at 10:45 PM, Mike Snitzer wrote:
> > nfsd_write_dio_iters_init() cuts a misaligned end of a direct-mode
> > WRITE at a multiple of the larger of offset_align and PAGE_SIZE, so
> > that the direct middle, which invalidates the page cache over its
> > range, never shares a page with a buffered end.  But where the
> > mapping's minimum folio order makes the smallest folio a block larger
> > than a page, the page cache holds that block as one folio: an end cut
> > on a page boundary inside a block leaves the middle and the buffered
> > end in the same folio.  The middle's invalidation then drops the folio
> > the end wrote, and whichever of the two neighbouring WRITEs comes second
> > reads the block back.
> >
> > Cut a misaligned end at a multiple of the smallest folio the mapping
> > allows as well.  Where that is a page, nothing changes.
> >
> > Fixes: 80728157d1bd ("NFSD: cut a misaligned direct-mode WRITE at page 
> > boundaries")
> > Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> > ---
> >  fs/nfsd/vfs.c | 14 ++++++++------
> >  1 file changed, 8 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> > index 9219f8eb386d..ade00dabef18 100644
> > --- a/fs/nfsd/vfs.c
> > +++ b/fs/nfsd/vfs.c
> > @@ -1452,13 +1452,15 @@ nfsd_write_dio_iters_init(struct svc_rqst 
> > *rqstp, struct svc_fh *fhp,
> > 
> >  	/*
> >  	 * The direct middle invalidates the page cache over its range, so it
> > -	 * must not share a page with a buffered end.  An aligned end needs no
> > -	 * buffered segment; a misaligned one is cut on a page boundary even
> > -	 * where the offset alignment is finer than a page.  A WRITE may end
> > -	 * at OFFSET_MAX, so the prefix is sized as a distance rather than
> > -	 * by rounding @offset up, which could wrap.
> > +	 * must not share a folio with a buffered end.  An aligned end needs no
> > +	 * buffered segment; a misaligned one is cut on a boundary of the
> > +	 * smallest folio the mapping allows, a page or, where the block is
> > +	 * larger, a block, even where the offset alignment is finer.  A WRITE
> > +	 * may end at OFFSET_MAX, so the prefix is sized as a distance rather
> > +	 * than by rounding @offset up, which could wrap.
> >  	 */
> > -	cut = max_t(u32, offset_align, PAGE_SIZE);
> > +	cut = max3(offset_align, PAGE_SIZE,
> > +		   mapping_min_folio_nrbytes(nf->nf_file->f_mapping));
> >  	prefix_end = offset;
> >  	if (!IS_ALIGNED(offset, offset_align))
> >  		prefix_end += min_t(loff_t, cut - (offset & (cut - 1)), total);
> > -- 
> > 2.52.0
> 
> PAGE_SIZE looks dead in the max3(). mapping_min_folio_nrbytes() is always
> at least PAGE_SIZE, so the cut is just max(offset_align, min folio). The
> new commit message and comment both describe three independent bounds, but
> the accurate statement is two: the DIO offset alignment and the mapping's
> smallest folio.
> 
> Also I would like to keep the helper's unsigned long type instead of
> narrowing to u32.
> 
> Post an updated version of the v7 patch so we can test and review that
> as a single change. This will also archive that revision in the lore
> archive. This will likely result in merge conflicts with subsequent
> patches in the series. If those are just comment conflicts I can fix
> those up when I apply the revised version.
> 
> Do not include the new revision of this patch in v9. v9 is now patches
> destined for the MM tree(s) while this patch goes to NFSD.

v7 didn't have this 1/7 patch.  But seems you're saying the fix for
nfsd-testing commit 80728157d1bd (which started as v4 1/10) would be
to have max_t() use mapping_min_folio_nrbytes(nf->nf_file->f_mapping)
instead of PAGE_SIZE?

I think you're saying post a revised version of commit 80728157d1bd as
a standalone NFSD patch?  I can check if it causes the other patches
you've staged to have conflicts (but like you say, should be simple to
resolve).

Thanks,
Mike

