Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 336CACA0EC6
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 11:17:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 955336B00E8; Mon, 18 Aug 2025 07:17:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92CB66B00E9; Mon, 18 Aug 2025 07:17:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 842B46B00EA; Mon, 18 Aug 2025 07:17:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6BF366B00E8
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:17:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 192DB1A0908
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 11:17:24 +0000 (UTC)
X-FDA: 83789627208.10.CFDF5A6
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3CA7F140002
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 11:17:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gWNgzXFv;
	spf=pass (imf23.hostedemail.com: domain of kent.overstreet@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755515842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m7eARwxjHrjiUlBOiogcNArJCMPY65GQtpA9M3yDfEg=;
	b=M/qnTSWjH9DfTVg6U7g9ezPuymP1tGmjtQ0POcPoNlUnYLuyUVHJb8/GOz/hcXLt1PG733
	xf+3dEtcIZ/qVjqzyvkmMLcfcUaacl0QaTW8mZSXr62R543pXCYSGD5nRt4uRFgNgaZ5zr
	FnZt7dNQjp0c8VoRQ70iFMoEtyJ6QPA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gWNgzXFv;
	spf=pass (imf23.hostedemail.com: domain of kent.overstreet@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755515842; a=rsa-sha256;
	cv=none;
	b=5hCspgquUoe5Cid1NU9LGIiey2I8AdcdNRg2MN9N6mhXp9R36ziklWE3O8nBlHggFNKPzu
	ik/oCB0Loj2C8+MstcHCujphRsJgWX39gQtmwW+ya/LfSOXxwSpBxShqUV8qjhxdhYWh40
	hrXciGYvczU+RHi+5zyfZESkWgVAz3U=
Date: Mon, 18 Aug 2025 07:17:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755515839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m7eARwxjHrjiUlBOiogcNArJCMPY65GQtpA9M3yDfEg=;
	b=gWNgzXFvM2QaqbmFBRvkjWKcwPYU1DAMKzIajtoC5k/zXPy73UOBOMiOt7CHhgObe/sVRc
	oJHt9snDy24PGD8frtEgFgwK122zorE+Ab22ALq5Qpw/bYsQa9alBQNERUDIRSXwKD90Cz
	R/c+5G3y4tj3D8DnaLGniWIm3XOhof8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	linux-bcachefs@vger.kernel.org, ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 2/3] bcachefs: stop using write_cache_pages
Message-ID: <3zji6rc56egwqvy2gy63aj2wjfo5pyeuq2iikhgudcttdcif2m@dphqqiozruka>
References: <20250818061017.1526853-1-hch@lst.de>
 <20250818061017.1526853-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818061017.1526853-3-hch@lst.de>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zgzdkdckgxzhj5mphhhunpm3rcacbe88
X-Rspam-User: 
X-Rspamd-Queue-Id: 3CA7F140002
X-Rspamd-Server: rspam01
X-HE-Tag: 1755515841-247376
X-HE-Meta: U2FsdGVkX19axVrE3kcoQ4NOvbpPWB9W0b6/FTeR8qrhKTHb6sSxAyWHJRaJAAww0pIW/EwAStrew5s1E2hEKwz5hEY/yl0I9EQzeko0bjv3foHH1QN2aAH8tJbsOBE1sd6WapbKNlwisljzroZU8HyDjku5AKZiRHb8UPNDfyBmjcZXKMmVAR1k1F+a0LVAL/NJuuevOfqmOFgvl+ZU6lOoM1mPHzpPKQg7IfQ/XVJuXtMKa/sP+vNAQlrpe5tEOzfvvl9JYewHIS+eWKryW+oFl5yTFChG29EwvYb28SR+ybatfTIzJOiuF94xZ7Wmmm+8TDlsFAkbb+n14B5bq2HoeQeO5pLhdolsxkjivEO3q3o8+rfpNSx5uM+qlBM+uEFLjAmrFfyZKoJbMyAy4u8oDvTm8xkzFTCRHoemQw9iOw+wl/oCpP+1AK0kjzgVQkIGTAD1r+iuF8I/amV1RVHb+/p9GjhQ7j6JURpaTVurOMjx1hqXqu2hwSSSB71RKvDWNhsb/7iwqmzP4A4Zjv2E4NM1V1rNuu9dYGkw/lcIViVILeKCN8eL4oInrqWnAWzZTz37EEZkACW8hLOuMq8pHZBans1Z+Nq/BC6II7ENi5kINdtYEa80kClI7rpKTHbJMtOe8vVY8ahucTtww80vQ3iaPFNRvSzkfjCzbCFeZfXfmwLJyRJNxNtOYWamcfrChWulXcrUwj0MXcBb4FP+F/Kd2XwlNR/XErYxJeejAoWISFYXBst3P1eueBOl2P2BtEPvyxHI2T80/OklRZbjQH1Z1NSKNo/FbX1HCDoUxMStMJkXpJi6peNgn+am95iG/PIvGF74rVCMw5k8FqN4xFERxnwZetmaYnlM+DvstLtBPb5PPCr4sD3Y/BU9rbd2sSWXsnN4vuyF3P1dWjYReP2H7Me5UeCQfLMC6vwO9Nb3u9nxa8x8Hc0s0LIVDt7CKUkOvuHhLDWqqn2
 8spzIHCo
 Jk+uQS/XbbfwtyiCwxx4n6+ZWPRTTy6HCc6w4V8haPvhkLL16nVxH/WQXoLmwqOAHpqQVQGeyEeGR2FXfykLohqboBRO2MxJR7IPgq8lvly5u46gfjEg6e15T2vkQX/D9lhqQTH5i/AJ3DMvvv4yxiT2Fn0fisfQYMuluL84JRrLwxhe5KV7DA6C0v7PGi12GCftudNp3aQDMC+nsMrGLTh6GyKTjydExFu7/SXZJj8rgMzQkw8r103InfFgb3mQcZcCl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 08:10:09AM +0200, Christoph Hellwig wrote:
> Stop using the obsolete write_cache_pages and use writeback_iter
> directly.  This basically just open codes write_cache_pages
> without the indirect call, but there's probably ways to structure
> the code even nicer as a follow on.

Wouldn't inlining write_cache_pages() achieve the same thing?

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/bcachefs/fs-io-buffered.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
> index 1c54b9b5bd69..fdeaa25189f2 100644
> --- a/fs/bcachefs/fs-io-buffered.c
> +++ b/fs/bcachefs/fs-io-buffered.c
> @@ -655,6 +655,17 @@ static int __bch2_writepage(struct folio *folio,
>  	return 0;
>  }
>  
> +static int bch2_write_cache_pages(struct address_space *mapping,
> +		      struct writeback_control *wbc, void *data)
> +{
> +	struct folio *folio = NULL;
> +	int error;
> +
> +	while ((folio = writeback_iter(mapping, wbc, folio, &error)))
> +		error = __bch2_writepage(folio, wbc, data);
> +	return error;
> +}
> +
>  int bch2_writepages(struct address_space *mapping, struct writeback_control *wbc)
>  {
>  	struct bch_fs *c = mapping->host->i_sb->s_fs_info;
> @@ -663,7 +674,7 @@ int bch2_writepages(struct address_space *mapping, struct writeback_control *wbc
>  	bch2_inode_opts_get(&w->opts, c, &to_bch_ei(mapping->host)->ei_inode);
>  
>  	blk_start_plug(&w->plug);
> -	int ret = write_cache_pages(mapping, wbc, __bch2_writepage, w);
> +	int ret = bch2_write_cache_pages(mapping, wbc, w);
>  	if (w->io)
>  		bch2_writepage_do_io(w);
>  	blk_finish_plug(&w->plug);
> -- 
> 2.47.2
> 

