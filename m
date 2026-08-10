Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98E27C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 12:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D75D6B007B; Mon, 10 Aug 2026 08:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 688D86B008A; Mon, 10 Aug 2026 08:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59D926B008C; Mon, 10 Aug 2026 08:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 348D66B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:51:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A3C114013F
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:51:06 +0000 (UTC)
X-FDA: 85085344932.30.367EBDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id F0F56100002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:51:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z3tCqdG1;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786366265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pYvBLcmZ5TB8B2HwmMEA7avd8sv7PgL7yrFAtoQ9v5k=;
	b=t4aStCjAA59gCJxKvwnAVCSxeiDbIhD9/aIYai80gqU7FhQOnKEm07D5hnt5nDn54zx7ny
	vmix4UPhafOG3x8cUe8DZ+1eRgOftehoPJarQAuS8J0o7SXWdZcHP3wWaJu4X1vivtiOW/
	ZdBD62J8KyyD5texCRilzGegSSSqlEU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786366265;
	b=N0gybzHub4hpoqoAGiLZb79yoZfCx3RIFIISxFcVniZDEm2E69Abp2VB2iGlax+hK2JNZM
	4rF6upm2q7TPBtbOy91L7a2CPzHfkLGvaoN1Rb0UpyuE7oRLB28MMxL3PPpmErvVMHiiRy
	hJUndIQoGWeLcr+ew0CRvX72FDHg340=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z3tCqdG1;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CAF5740991;
	Mon, 10 Aug 2026 12:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3711F000E9;
	Mon, 10 Aug 2026 12:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786366263;
	bh=pYvBLcmZ5TB8B2HwmMEA7avd8sv7PgL7yrFAtoQ9v5k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z3tCqdG1gTmj5SeDm+uqtFa68CLPgzNb561oUaQ2/m1Zg6lwhm9xGuZBOqR+k0mlx
	 QMw+PKqBPe9IoqTYmc7fORVOR6PfccnvLWskSK1yEQEIIFJjbet0wd5c1XgKKkPFy6
	 XeGfKVM/47Hcfdy5+fhu5o1blgs/vPsp+pe2wbXY2aR+37OTXhKQTi0Ew6JiShC+dU
	 10mDX1u19+katUD1OmPV9XavPpNGeD6MBb85mIO3z3SFM7acoWfCd463RjFjrbra8k
	 n8JYtUMFdMOhS27y5QWg7vSKFw6pZIsOhjUR2b4OZzAUNndyd8vXsjPE83goKV6whK
	 6xPblJ24d7wrA==
Date: Mon, 10 Aug 2026 13:50:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] mm/page_io: convert write completion handlers to
 folios
Message-ID: <annIJC0TtWS74rAw@lucifer>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-1-0899bac3b826@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806-b4-page_io-folios-v1-1-0899bac3b826@columbia.edu>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F0F56100002
X-Stat-Signature: 8hb1bf9795e8od3753qaf9s4t5yggfmj
X-HE-Tag: 1786366264-907553
X-HE-Meta: U2FsdGVkX1/vv9RBdSap6Z+n90817vwiPM6xZROuCD4qf8buRilUAy9xizbomQFFTglK8FQt3AVQ0k2C2dthny9W0VmvYyRWmIuPiLN8WsLWbYx6pH+jHO2cFz2j4FTu7yqlFJw/SdxGNmMHwdh8Edf49PPBzJMnXGC7U45wmafj2X38rRXrp59ubELm5EPX34yoQPJT7KAsCKEdyt14YTGFrLVou5BWMxwU6TpJwhjzwPSIyOBvobBvEptt5Ost3phoud7CHDIjBa0ETuin1p7ZloRkEk31E5C7oXHQPu7+RJA3OHKF1CP3BizwkAPNNFD/NzEQ0ox3j29cB9aflbI6Htsh9v5hxXqSGLbvagz66uEd8BKba8mUjrEOu4X7p0HXXLw4UjBG3f1aHbhUtvb3Oj8dhujdMONGnJYowGprMrAnvyPKSI6kmUs6IC2qZiirDtaTJoZKRglDP0YhchGJYorPb+4fkLkFzRTqGAA3xe3DE2+kLLw6ifcJDusWem1TwqjyYCyn9H+wEUQn5Zs+Ntqw7TfNDNo14IfqN6nlU+hWWHJ/ty0iUekKMU/wjcIcovnTyFAx9Umok/CZOBG6eZqAPjUK1ya+xap7hxGSZZlQvTvKvzN1y5Ldv6tK3DoMTwCoBeFV/IIkASTZjwnSGGi3J1OKJkERF2Ejviumnrta/iLW3K3zLfqWSJXbr3vrQ/E6/0DJu1fwZaWvzvG6lVi2IQM4Lk6TJyvm1Jjj3LXomLAd/Oo2yYyOmhvBSTbkMHFe+dIxUflksuGAuwkpGtSmMgITaTe5oyDoIxUCT6tfQawknW3pXZB0UyXjzH0pKUepj12c2Pca8m6gXEMnfo3/DMG/cNt4y85zzXDZmXqJ36tCQnzIrUKrPuUvkRKJA/dCdxhZFW72q0FySDMH0H+xO6MZNlYA0dCEnlS6agMkj87Z+SOTEip+1hzKVNH9I3aQqYNnH4g3qGj
 S1big9Dd
 BfGLv8EFIhBB23HETjpB+vPe723TNcWJvvz9JO/BTlLPK0sSLIq0ggGBBrNJwPsxfT2GsL19seWglqh0Gp1nkWGRfY3AUgAipHz+WufJOndy+lIX4NBseM/eIaEQzLIMXRhM9JJz85asVDfz8pI4LCcgZ4WiCoFTJjJBcseU2tytYtW4K7BhHepBiMLQPZFGdTosOqSQOb2tDI139qW1swb3K9u4xRABuTgiWs0B1itlXGDnAxOSqo7AB8fPZ3qAwOnyWi9cZXwy7nJ8OlNgZmjQb6zzXoFBwCVEBlaL/76G3ruxIqqESKAAzzbnqlpHo6k/B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 06:55:33PM -0400, Tal Zussman wrote:
> Convert swap_write_end() and swap_fs_write_complete() to operate on
> folios directly instead of going through the folio-compat page APIs.
> This removes calls to end_page_writeback() and set_page_dirty(), and the
> last caller of ClearPageReclaim(), saving two calls to compound_head()
> per folio on the write error path.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Very lovely, thanks! :)

I see you remove PageReclaim in the subsequent commit which makes sense as a
follow-up.

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/page_io.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index e4fa7ffffe8b..43b4383a4729 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -496,13 +496,13 @@ static void swap_write_end(struct swap_iocb *sio, bool failed)
>  	int p;
>
>  	for (p = 0; p < sio->nr_bvecs; p++) {
> -		struct page *page = sio->bvecs[p].bv_page;
> +		struct folio *folio = bvec_folio(&sio->bvecs[p]);
>
>  		if (failed) {
> -			set_page_dirty(page);
> -			ClearPageReclaim(page);
> +			folio_mark_dirty(folio);
> +			folio_clear_reclaim(folio);
>  		}
> -		end_page_writeback(page);
> +		folio_end_writeback(folio);
>  	}
>  	mempool_free(sio, sio_pool);
>  }
> @@ -513,16 +513,16 @@ static void swap_fs_write_complete(struct kiocb *iocb, long ret)
>  	bool failed = ret != sio->len;
>
>  	if (failed) {
> -		struct page *page = sio->bvecs[0].bv_page;
> +		struct folio *folio = bvec_folio(&sio->bvecs[0]);
>
>  		/*
>  		 * In the case of swap-over-nfs, this can be a temporary failure
>  		 * if the system has limited memory for allocating transmit
> -		 * buffers.  Mark the page dirty and avoid
> +		 * buffers.  Mark the folio dirty and avoid
>  		 * folio_rotate_reclaimable but rate-limit the messages.
>  		 */
>  		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
> -				   ret, swap_dev_pos(page_swap_entry(page)));
> +				   ret, swap_dev_pos(folio->swap));
>  	}
>
>  	swap_write_end(sio, failed);
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

