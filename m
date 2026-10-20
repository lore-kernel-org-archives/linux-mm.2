Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FEA2606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 22:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N1/nEJWO
Received: by kanga.kvack.org (Postfix)
	id 602146B0575; Tue, 20 Oct 2026 18:11:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D82D6B0576; Tue, 20 Oct 2026 18:11:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EFA36B0577; Tue, 20 Oct 2026 18:11:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EA5A6B0575
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:11:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB9FD1C399E
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:11:57 +0000 (UTC)
X-FDA: 85344403074.28.7B613CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2136D2000B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:11:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N1/nEJWO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792534316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NpFLan+/UuwgnzMCO1yKW0YhIn6YvxfWrSCdFI7nkSg=;
	b=HJg5LEEHNEwgqQbq7vwBBVjYprLJ6FUft5iAoniXdAeYx1at5LKNsqbGebKK+X8MdnLiz3
	laLtoVmVW7UcfQXithPYpwGhSgxbyjJMVKpAYJ4w6wWMMsnnf4W9FlQbc91Vyg9ZPMwXg9
	0gpOfIpRnIPw8i9ojfEYR2qLm0CLLKc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N1/nEJWO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792534316;
	b=180WlBAJhzgTzRi5REZb3QdKPT61kpm8XvDjhlyl6bINm4s4BqvrcK5UF4V+ECUo92rkSd
	9MjMe9ftbTDFv+N23GWW/17gaEKrDp8iIEGjpLqFCRy1n+pMoeSCFcqE2jLREN0yAoCt+l
	MtvTQA61Fppu4pDsk0Pg52RsSlCPIa0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AD24601E4;
	Tue, 20 Oct 2026 22:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52651F000C9;
	Tue, 20 Oct 2026 22:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792534315;
	bh=NpFLan+/UuwgnzMCO1yKW0YhIn6YvxfWrSCdFI7nkSg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N1/nEJWOj9GL0Tc5obFWdlcWohS41ITXgsBTMTdVcUdZ3M00ZixvCMaMTMsT+OwuD
	 g+ycxH/HAME4S/LIjYo4Kd1fXkJ9oXBw5XyrL07bK8TqBU9/bmJBrSqTQD+z8WMqqt
	 6XE1bszg5xZjnxqWX/Mj+fra/ygDz3ypMGHygi7DlO35STxFgn0c+Z7lzr5hJIFh71
	 MQg8Ov3kzBbxTKTQHk4DyH2htibCiDlwcpufA9EdsVjApsDhlrKxmZTukgkryU/TW0
	 34qnmroxipBVxkKxhm8too4dCWsX2bRYOffBv9HSWUA13VZjpGo8WJ6nzNTYAZ2D41
	 Xxh5crpem99iw==
Date: Tue, 20 Oct 2026 18:11:53 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Mike Snitzer <snitzer@hammerspace.com>
Cc: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v7 1/5] mm: expose WB_DONTCACHE_DIRTY in bdi debugfs stats
Message-ID: <atfnKRbYfnwwi_Tb@kernel.org>
References: <20261020220346.28020-1-snitzer@kernel.org>
 <20261020220346.28020-2-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020220346.28020-2-snitzer@kernel.org>
X-Rspamd-Queue-Id: 2136D2000B
X-Stat-Signature: y6sf8prhktnrw7woytkdhcnxywjarq3u
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792534315-195566
X-HE-Meta: U2FsdGVkX19dPzdugtZn6w53JAugX0DM+F2a3n5DWj8mlOR/GHxdg915179yJ17XINAWkqZMSNcPY0piPVTbVa59ddr6XNnXJM9g17m8TMDXhQUu8EpQzg8eCU93uQ321ZuOpCjcxs63E3K+bZIJI/CsH+K1g11oo+6kBkTKF9GwDDD+oo9T6qA4aAyRUZK6PXmHdBofYTyZke7KWLC9bC1fefBLhlExUUkatlzuqp1eVqBR8IizlBRsMRGoqWtbuLKRd9pypYV7woDYaPoKWOMOC3iKTB1QPUReZ7NnM25vT73MI2DIZNaLX93nQuLLnleaHinpHYVp85TAZ+nhSiU0slee11+Oa1GCp3JTIZISt2eEyyVAHNXA+E53pO1g3Xhy4nTFhSLtYclSWcqffw9k8R+woM5FEtsIBbdcicbJb2F3JEc+I8BHij8yLFUOl6NomEb9YwxYOA4rfItMbH0n6qhtkA4Iwmn6/ic9tYwDHu8kdFgP/Dp/45DDtKuX+4iod6g5buLrgwJ3DGXMv4EZInIYRMCPQt1RtZhEoEkPbL8Wp1Bfm6are5syetPoEr4ii5XEwMgijbjskZWT8cyqsP8/8OYLFhyjIitljbIgSZ0Q5LNT7trIeluY2z/5At7SURnNkJEDQ4S7vLZGbfW8Dcq3XpvIBv/Y26gjcx9xQb6jeUcQ4fiGLDCe8wzYdF2Qfm1HAMEUqnYiblZll6lgKZBT9fTf6a2tdDxiqZVIXihbmgKvFV1jjZnP1JvHOmrWqgyytDIhW0Ai1kpesFHIYPYDnVhwkKzWigxKLCtji1QJCvqwn3eFyk4WfrQ8hf5ieGu3hKMXAJ7jy1QcGDPy2PETATQvL21a0+xB2P/gBEfT4sOuHXwtfZvQHO2GhQ5kJ86TsRoa0fhsQXWHN3nrm8KX4r9kOIaFUNbMDODB+GdbUN43gGz0eYJz2RtyCgLQFFQU7p0PbPKzz42
 TDrK0LGb
 g//qhEzcmVJIuEsallZeLn30LBHE48rZuo7YamEOLflaWgK4VUscum4MQ5CwkGQsbH71UHbUBAM67A8EcFymm06or27Bq7toy3UpLgUFAIkK3h7VB+kPjytfObXheBF4VMlLZkt9+t/yLZY2lbEzdZ9KdXJ6GGRPMgA/QyNfCREATgsYFyY+DrKomfdzHrs9fny2VaWnUbxYIEk5KTnoSosgGTBmja5lDXr5e2CZrkNrSDfdCcq3oqjY4qqgJhRK4Gduz0kLV1y5Vu6rsB3GR21MFbQOQOH7pejM18F/fqL3lauMUEH+rf20AobC5fdiqB7YJe0e2Ht9tyJrjIhKIZb8uvFIM4jwmRSMMUAQRJWfzK1OENBLwaxfAC4ylccEcJvMln3qY2HMUuqky9Zd82PSjyMDiM4Tv7aFqzYmxV0DfmY9iFQT6NtKYlH8TFgAL45rT9SWUfaOcC3OmWTe5nkZ92fctmIcHEj0x70UPeP0x//1TDtC4Lxti+rhM8u2lCgrbZ6/n8Xx3dZk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 06:03:42PM -0400, Mike Snitzer wrote:
> The per-bdi_writeback WB_DONTCACHE_DIRTY counter drives how much the
> flusher writes back in response to an IOCB_DONTCACHE kick, but it is
> not reported anywhere, so the DONTCACHE dirty backlog can only be
> inferred from MemFree/Cached movement.
> 
> Report it as BdiDontcacheDirty in /sys/kernel/debug/bdi/<dev>/stats
> and as WbDontcacheDirty in the per-wb stats, next to the
> Reclaimable line.  Use wb_stat_sum() rather than wb_stat() to fold in
> the per-cpu batches: the flusher targets the summed value and small
> backlogs would otherwise read as zero.
> 
> Fixes: 88d6f128d06d ("mm: track DONTCACHE dirty pages per bdi_writeback")
> Cc: Jeff Layton <jlayton@kernel.org>

FYI, I forgot to pick up Jeff's provided review tag for this patch:

Reviewed-by: Jeff Layton <jlayton@kernel.org>

see: https://lore.kernel.org/linux-nfs/2bee53783a2372b8dc715350b6f6d2ad5d8770ff.camel@kernel.org/

Thanks,
Mike

> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: linux-mm@kvack.org
> Assisted-by: LLM
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> ---
>  mm/backing-dev.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 18e999053bae..b8a2c27e07fa 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -46,6 +46,7 @@ struct wb_stats {
>  	unsigned long nr_dirty_time;
>  	unsigned long nr_writeback;
>  	unsigned long nr_reclaimable;
> +	unsigned long nr_dontcache_dirty;
>  	unsigned long nr_dirtied;
>  	unsigned long nr_written;
>  	unsigned long dirty_thresh;
> @@ -78,6 +79,12 @@ static void collect_wb_stats(struct wb_stats *stats,
>  
>  	stats->nr_writeback += wb_stat(wb, WB_WRITEBACK);
>  	stats->nr_reclaimable += wb_stat(wb, WB_RECLAIMABLE);
> +	/*
> +	 * Sum the per-cpu batches: the dontcache flusher targets this
> +	 * counter via wb_stat_sum() and small backlogs would otherwise
> +	 * read as zero here.
> +	 */
> +	stats->nr_dontcache_dirty += wb_stat_sum(wb, WB_DONTCACHE_DIRTY);
>  	stats->nr_dirtied += wb_stat(wb, WB_DIRTIED);
>  	stats->nr_written += wb_stat(wb, WB_WRITTEN);
>  	stats->wb_thresh += wb_calc_thresh(wb, stats->dirty_thresh);
> @@ -125,6 +132,7 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
>  	seq_printf(m,
>  		   "BdiWriteback:       %10lu kB\n"
>  		   "BdiReclaimable:     %10lu kB\n"
> +		   "BdiDontcacheDirty:  %10lu kB\n"
>  		   "BdiDirtyThresh:     %10lu kB\n"
>  		   "DirtyThresh:        %10lu kB\n"
>  		   "BackgroundThresh:   %10lu kB\n"
> @@ -139,6 +147,7 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
>  		   "state:              %10lx\n",
>  		   K(stats.nr_writeback),
>  		   K(stats.nr_reclaimable),
> +		   K(stats.nr_dontcache_dirty),
>  		   K(stats.wb_thresh),
>  		   K(dirty_thresh),
>  		   K(background_thresh),
> @@ -163,6 +172,7 @@ static void wb_stats_show(struct seq_file *m, struct bdi_writeback *wb,
>  		   "WbCgIno:           %10lu\n"
>  		   "WbWriteback:       %10lu kB\n"
>  		   "WbReclaimable:     %10lu kB\n"
> +		   "WbDontcacheDirty:  %10lu kB\n"
>  		   "WbDirtyThresh:     %10lu kB\n"
>  		   "WbDirtied:         %10lu kB\n"
>  		   "WbWritten:         %10lu kB\n"
> @@ -179,6 +189,7 @@ static void wb_stats_show(struct seq_file *m, struct bdi_writeback *wb,
>  #endif
>  		   K(stats->nr_writeback),
>  		   K(stats->nr_reclaimable),
> +		   K(stats->nr_dontcache_dirty),
>  		   K(stats->wb_thresh),
>  		   K(stats->nr_dirtied),
>  		   K(stats->nr_written),
> -- 
> 2.52.0
> 

