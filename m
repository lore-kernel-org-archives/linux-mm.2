Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D841CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 04:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98FA8E0010; Thu,  6 Nov 2025 23:08:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB598E0002; Thu,  6 Nov 2025 23:08:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A379A8E0010; Thu,  6 Nov 2025 23:08:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 933898E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 23:08:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E9E0884B6
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 04:08:03 +0000 (UTC)
X-FDA: 84082478046.16.E9CF29A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id BCB0720007
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 04:08:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HpYpUgEt;
	spf=pass (imf13.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762488481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CinPNCSYG48W4ErHgl/AxhRtph+5RNe27Gm8quQqoPk=;
	b=04gn/BjfJAc10GZk+YrkldsrH5zoXHpID5CsEjK2Rrhmp1Pf32mUWHMygG3dbOS7l/uION
	iDfk6PPDV4znqzxg0wdhwmLwuLZJbkmxHZulKd9CybPO+ebSa1S3bc6LX8Bi+Vd726IW/a
	JKnGsD2VVljcsHx7r66lT3gG0kr4oLc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HpYpUgEt;
	spf=pass (imf13.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762488481; a=rsa-sha256;
	cv=none;
	b=DWnvpLMORf71yjs6tXhd5k50r9DSzRJz+s9i2u1vKW9KM4WFrByeH3wD6Sk0IaLnsq5CZc
	9x79xFGZh/skp/Gs98V+Xxzt5IixPclxnyr5NsLZk6fdxrQsGJbStmEaZEVqvMxGxUKdqV
	OuKBpfYd6gWoVGfHDHk6dgtqHNf0bdc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 93D0942E28;
	Fri,  7 Nov 2025 04:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CA7C116C6;
	Fri,  7 Nov 2025 04:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762488480;
	bh=7R612qBUPvSWvCwpdWHa4cwpfUnAwNhOskr7iKaQgSs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HpYpUgEtsszxOvLdFNToRe2bHvEuDrJFWRXKOTWQGtEjhVgxH85oRQ2qbpBV+AK85
	 Cim/1w4+e3AfDCVYhUWQii6U7F6+Tm69/EkXTjnG+YpS3BU2o5CHAdeDU3MhzqcrqA
	 cHuKAO91oUjZ/DaFFFnNhDOy/sdYwKUsL/CG5Bbn9lf+VlcVWFj2D0ZdhNujjnmp+S
	 e8rsgfO3ETObBv9oO/PRtKTMoYIoYTyTYfYg9tBbD6TTFJNW+FLfSBLPzxQS0WXmyg
	 7O3XiVyup0QcPwElB0a2whqgj4KPcExfyp+9Y2pSn9y90ylVN2O5/8Yv6merKBLglS
	 ZOSLRD5E52c+w==
Date: Thu, 6 Nov 2025 20:06:19 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 5/9] fscrypt: keep multiple bios in flight in
 fscrypt_zeroout_range_inline_crypt
Message-ID: <20251107040619.GC47797@sol>
References: <20251031093517.1603379-1-hch@lst.de>
 <20251031093517.1603379-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031093517.1603379-6-hch@lst.de>
X-Rspamd-Queue-Id: BCB0720007
X-Stat-Signature: uhmzzy8uw1ayuoosmxrjx3ai3idt3xip
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762488481-699596
X-HE-Meta: U2FsdGVkX18bpP7UUPy6cHRaazgmDkdIEyH8RON2xjtK6MblVF/LV1pwQLhPAjEoAqro24PLt9BjsVbNgnaxBEiOs3ZeFIOgr8IbobH2zoEkQf9w3Vz3xhxIXggWInpsT5MOGPDI1/Jt7eseIopborcvVzXcwcJoQdkrGyJvNglozIHe3d9eKBHB+QFCp5QNFJ0Is8GWx/MgqN7T9E1NxgagBchlE40TxFKwSUHVa2vlrvdNRtQR+zNM4Ch8jFb1qRL59EEBCyT1HHageV01dp/sJhHMsySBlQnQ6HYHg5oopi7YjgqI5sc8zGQ5JldoTFawmMgAkqV150vEleYUDXRZrA1W3Xq1lFvNlNLEsmrFTQ0ERkyFWuFYDU2sBScs8BULIbGXvlFOHYfx0RPaowzX8crOdn6XiWHwgQUJtff8DVvZZRB6ZumBQepxYPFPYduUpz99GzcXYsnQk0kM6llLA1rT3t171MOxKQWO+8PzTci3YfERSg2OoLGTz9nGiZx5nzuSvji4lVqM4bPAVL5+SQXr74qw/AEWLPD25Ti55a7spCBBLxnwO4lnZ4FnZVbXyotGU6fDSZ/Ii+1SE2jPQywe/any2eAYtGyNeVVjCNvvI9S4pQ2u+Myk/RG02pypoF5276YnYnkmo0rKvZdlCSVXIFJlsd5MDqw1KLnE86IrqoWPzFCTz4t0Atsw9aFRZAXSD9a0bAxtTk0nAJdS+DdQCUa7q0Z83RMiDh/o8u6zm0blxuWwCSiPWNIHJB9B9mY5jWbJioPilgRANd8T/9Mwyfesmc5W1ko1ZqIMUOlKguAYbqclOHEJINMQJG8t5uJWswhEpt9BfxA0re9PfRc/jLswinp7f6lwJuz7QKFtAEa7clSrQMiDiGx1MrnQhLseeCi7EGuaPMnxx7Uwdi01HdZmxrEEtyKwd81fM+nC8z/168O7HGmJYHFd0TLvFN+3o+pQUWGNLuT
 PfG2atRk
 lK9ei
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 10:34:35AM +0100, Christoph Hellwig wrote:
> This should slightly improve performance for large zeroing operations,
> but more importantly prepares for blk-crypto refactoring that requires
> all fscrypt users to call submit_bio directly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/crypto/bio.c | 84 +++++++++++++++++++++++++++++++------------------
>  1 file changed, 53 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
> index 68b0424d879a..e59d342b4240 100644
> --- a/fs/crypto/bio.c
> +++ b/fs/crypto/bio.c
> @@ -47,49 +47,71 @@ bool fscrypt_decrypt_bio(struct bio *bio)
>  }
>  EXPORT_SYMBOL(fscrypt_decrypt_bio);
>  
> +struct fscrypt_zero_done {
> +	atomic_t		pending;
> +	blk_status_t		status;
> +	struct completion	done;
> +};
> +
> +static void fscrypt_zeroout_range_done(struct fscrypt_zero_done *done)
> +{
> +	if (atomic_dec_and_test(&done->pending))
> +		complete(&done->done);
> +}
> +
> +static void fscrypt_zeroout_range_end_io(struct bio *bio)
> +{
> +	struct fscrypt_zero_done *done = bio->bi_private;
> +
> +	if (bio->bi_status)
> +		cmpxchg(&done->status, 0, bio->bi_status);
> +	fscrypt_zeroout_range_done(done);
> +	bio_put(bio);
> +}
> +
>  static int fscrypt_zeroout_range_inline_crypt(const struct inode *inode,
>  					      pgoff_t lblk, sector_t sector,
>  					      unsigned int len)
>  {
>  	const unsigned int blockbits = inode->i_blkbits;
>  	const unsigned int blocks_per_page = 1 << (PAGE_SHIFT - blockbits);
> -	struct bio *bio;
> -	int ret, err = 0;
> -	int num_pages = 0;
> +	struct fscrypt_zero_done done = {};
>  
> -	/* This always succeeds since __GFP_DIRECT_RECLAIM is set. */
> -	bio = bio_alloc(inode->i_sb->s_bdev, BIO_MAX_VECS, REQ_OP_WRITE,
> -			GFP_NOFS);
> +	atomic_set(&done.pending, 1);
> +	init_completion(&done.done);

This could use:

	struct fscrypt_zero_done done = {
		.pending = ATOMIC_INIT(1),
		.done = COMPLETION_INITIALIZER_ONSTACK(done.done),
	};

Either way:

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric

