Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A71606A321
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 16:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MZlquYDI
Received: by kanga.kvack.org (Postfix)
	id E60DE6B02FA; Mon, 19 Oct 2026 12:57:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E12A86B02FC; Mon, 19 Oct 2026 12:57:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD9406B02FD; Mon, 19 Oct 2026 12:57:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 924E46B02FA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:57:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DCB7AC077B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:57:31 +0000 (UTC)
X-FDA: 85339981902.04.07C7E7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 26208160002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:57:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MZlquYDI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792429050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Od2rtReIL7bq8xC+py6KjgoIClum75QNK+ffkf2+KsA=;
	b=O0y3CpGLkRTG5E4TGCbpiD9gAexMIX2Ce+7qzy8XDpzXa0uDtDC7qDsLPZF71Vvjfchsm6
	avm2y02vuMS46ttT6PWFS/pHrQAHqiUJrgV3daejvza+Motgi69HoRbym/Kc5zsCdqNAGs
	d2lnuoGOZlmzCG/6iUGDTmU0xfnr34E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MZlquYDI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792429050;
	b=uwslpWPZmqbn6PHsfDnJEcHj6gZZKupS/DNn3+W8d8GRb9UhRQ0uMO01KWLHlqxj8MQ0Tx
	rAI8XjcaNOic2EOURb9FUsp1+PXBsH2w33d0hWncdc7bvMsr8+wd1tJc+MBQXEjHBjvNHB
	NIJJzfT3eg1kbvTh8fH4WwNU1kUU8kQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A90A43D24;
	Mon, 19 Oct 2026 16:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A48D1F000C4;
	Mon, 19 Oct 2026 16:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792429049;
	bh=Od2rtReIL7bq8xC+py6KjgoIClum75QNK+ffkf2+KsA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=MZlquYDIkzeDjF3sMmL307ehIaswqt0v2kCfhP5kHXl1xbcqJDmot/XzenURPSnc5
	 5jhFMHAfb3GvMsltUgarbJJu4hvq5UaTE82XJOsngwGffbnHYv2S4P0QisNH6mLSVb
	 P/kBGorLb+t8qoM3amZzoNWPvmuKaMuYTFtyR+ovZuaZ363HyFKZUGY6mY8VvGCdn5
	 bjgsNqYFwR1EtmLyzutJGOwlJ+6W1WE9plpEebsR5tGYxYCz7JKkLfkym2m3fhf+SU
	 u/in52DWhehzR2iHE7Cm/JGLSp7KQgGR/9MwZFmT+8bXXmpZVeT74uSgZ70p+AR+CQ
	 U6PkEi6MthLKg==
Message-ID: <2bee53783a2372b8dc715350b6f6d2ad5d8770ff.camel@kernel.org>
Subject: Re: [PATCH v5 2/6] mm: expose WB_DONTCACHE_DIRTY in bdi debugfs
 stats
From: Jeff Layton <jlayton@kernel.org>
To: Mike Snitzer <snitzer@kernel.org>, Chuck Lever <cel@kernel.org>
Cc: linux-nfs@vger.kernel.org, NeilBrown <neil@brown.name>, Olga
 Kornievskaia	 <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom
 Talpey <tom@talpey.com>,  Christoph Hellwig	 <hch@lst.de>, Jens Axboe
 <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Date: Mon, 19 Oct 2026 12:57:26 -0400
In-Reply-To: <20261019150725.1507-3-snitzer@kernel.org>
References: <20261019150725.1507-1-snitzer@kernel.org>
	 <20261019150725.1507-3-snitzer@kernel.org>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 26208160002
X-Stat-Signature: czbb6fwgthwsn9cnw15mr9mfm5z7uah3
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792429049-270548
X-HE-Meta: U2FsdGVkX1+pP88cJVoVBeeHhiAWMoHgZ90HRcPscmt7k96oMiYhRcyICoJf2wryVRqlukjvrEKONWBbaQGLoHeSiCHTpY2PscsERC94lMGA8iB1+cFBpfmAydqc6OR5kRFoooZR9yavmtMA0p3SHP05hKRyvHG6ECchmFaly6SWvcBuUQRbauJgK+S7gEUYIZ2vepZ5vASXUg3AUGqSEfR4sIJg+lNoPh0to0ffSM12PSJMsfbICFcEFtpQzofZUtZNjAIf6cVOIgaQhPdwJFSde4DCXDOSkiIDI9tSgFShrC2tTRIYd2qw5WKnBrNJnt+E23SdTRyo5oQ+KaF0QokZ8nmlB7jfj5bCmepSTCqkFzNUl1/w1fQQfM6QaYjIGItzQ5okZpEGtVkA4yAT1n57Kl1hQSdCnvdc94s2fyUdHQ40JZVgnHuBdpf8UWP+kFIdibZXQEp16IvJwBmqFeqTultzzJGAR5Bds6k2hyyl5Z540hKPAp8Kd/MsKX6ZDaN+5Z3Brlfu4tI1rjlKsKXdC90nv0cyt3VueW22rTnDC2kXqwIaIzMmhgFgChcEFO+iG5Cij1xOlrv7kQaS/tFYEYQaiWDKDlIriCv93BE7OeV/S4+hEILIGVfvWSS4JJASUr43CZd2IB1a4kd7XDcuYPLkqpXsLlO14Y8cuAO5lPU39tHCztOT42cwwE/IRpklN7sRMQ5wVVCQ2txs2MEnxooFNiEhPRwoWP5KdzghU3dBROyU7sq7Wcz3TBLu914k/UWC1AR7E1o7kVfdoF8i+nudM/4z39rRdqHxTSuLifg+ErK6JZFF2Ke25Bba1OrACHtX7nXxsa9c9qgKiSrDG3W3GUBB7MK1MfwvYyZ4vqs6uPqJ4D3N0Whqummw96uruXF3NIM6id19jUC6omPuldFVPTMmsuN8RnWR8FHVONmpouRlzqliHMSyQSCevomABEMxzAOzbplpGiQ
 BiboMzKb
 v0+W7bsWUZTXRaJU6O/Z+yFRSPEeOSsFqXM6nEhasSN0qTX4axFp4704kUmluspX+EdMN19WC55XjYK+hG+Bqb7EPDO4jHZvSnSv1hTnaXFVXs0W0o8LreUMv3ngsP+nPwmvPfxxcyQxwek5iZdB+XGPg00/bMJqkdZchq5yn/oV1PUHcyp94dFZbGKBoD9dhiG6B9hPrdpahkAQ05CTuhekRl/xzQ/qW11MQWVJmFGH6RtuQdoAZOlerFc54A7ZFsOJR+ORtSSu09VCtKlQ2OtaCT4y8k1cCffEutX3D4YF0pkBKa9MoyWLu1wjnG+Ney33OdYDRqIhRtyKxHz3JHKXBGTDZL88YbDPXHgwbOfP7XwszyTjzbAnVjQJf94rEUcaAkpW4vmTA4wBFuZoTEfxQh9/j3zUcxFtu8lFa6G3xMDnpyltuJ5K4I3oRnpKvv9kKrC1xlDzh69JWScifOnxnnu9yQ5E+PZ45EzyruNrTdlc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-10-19 at 11:07 -0400, Mike Snitzer wrote:
> The per-bdi_writeback WB_DONTCACHE_DIRTY counter drives how much the
> flusher writes back in response to an IOCB_DONTCACHE kick, but it is
> not reported anywhere, so the DONTCACHE dirty backlog can only be
> inferred from MemFree/Cached movement.
>=20
> Report it as BdiDontcacheDirty in /sys/kernel/debug/bdi/<dev>/stats
> and as WbDontcacheDirty in the per-wb stats, next to the
> Reclaimable line.  Use wb_stat_sum() rather than wb_stat() to fold in
> the per-cpu batches: the flusher targets the summed value and small
> backlogs would otherwise read as zero.
>=20
> Fixes: 88d6f128d06d ("mm: track DONTCACHE dirty pages per bdi_writeback")
> Cc: Jeff Layton <jlayton@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: linux-mm@kvack.org
> Assisted-by: LLM
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> ---
>  mm/backing-dev.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
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
> =20
>  	stats->nr_writeback +=3D wb_stat(wb, WB_WRITEBACK);
>  	stats->nr_reclaimable +=3D wb_stat(wb, WB_RECLAIMABLE);
> +	/*
> +	 * Sum the per-cpu batches: the dontcache flusher targets this
> +	 * counter via wb_stat_sum() and small backlogs would otherwise
> +	 * read as zero here.
> +	 */
> +	stats->nr_dontcache_dirty +=3D wb_stat_sum(wb, WB_DONTCACHE_DIRTY);
>  	stats->nr_dirtied +=3D wb_stat(wb, WB_DIRTIED);
>  	stats->nr_written +=3D wb_stat(wb, WB_WRITTEN);
>  	stats->wb_thresh +=3D wb_calc_thresh(wb, stats->dirty_thresh);
> @@ -125,6 +132,7 @@ static int bdi_debug_stats_show(struct seq_file *m, v=
oid *v)
>  	seq_printf(m,
>  		   "BdiWriteback:       %10lu kB\n"
>  		   "BdiReclaimable:     %10lu kB\n"
> +		   "BdiDontcacheDirty:  %10lu kB\n"
>  		   "BdiDirtyThresh:     %10lu kB\n"
>  		   "DirtyThresh:        %10lu kB\n"
>  		   "BackgroundThresh:   %10lu kB\n"
> @@ -139,6 +147,7 @@ static int bdi_debug_stats_show(struct seq_file *m, v=
oid *v)
>  		   "state:              %10lx\n",
>  		   K(stats.nr_writeback),
>  		   K(stats.nr_reclaimable),
> +		   K(stats.nr_dontcache_dirty),
>  		   K(stats.wb_thresh),
>  		   K(dirty_thresh),
>  		   K(background_thresh),
> @@ -163,6 +172,7 @@ static void wb_stats_show(struct seq_file *m, struct =
bdi_writeback *wb,
>  		   "WbCgIno:           %10lu\n"
>  		   "WbWriteback:       %10lu kB\n"
>  		   "WbReclaimable:     %10lu kB\n"
> +		   "WbDontcacheDirty:  %10lu kB\n"
>  		   "WbDirtyThresh:     %10lu kB\n"
>  		   "WbDirtied:         %10lu kB\n"
>  		   "WbWritten:         %10lu kB\n"
> @@ -179,6 +189,7 @@ static void wb_stats_show(struct seq_file *m, struct =
bdi_writeback *wb,
>  #endif
>  		   K(stats->nr_writeback),
>  		   K(stats->nr_reclaimable),
> +		   K(stats->nr_dontcache_dirty),
>  		   K(stats->wb_thresh),
>  		   K(stats->nr_dirtied),
>  		   K(stats->nr_written),

Since this is for debugfs, I guess we don't have to worry about ABI.

Reviewed-by: Jeff Layton <jlayton@kernel.org>

