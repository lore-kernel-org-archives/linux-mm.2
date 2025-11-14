Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9787ECD98F7
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 00:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB7358E000A; Thu, 13 Nov 2025 19:22:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67DB8E0002; Thu, 13 Nov 2025 19:22:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956C98E000A; Thu, 13 Nov 2025 19:22:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 80B688E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:22:17 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 27170139C5C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:22:17 +0000 (UTC)
X-FDA: 84107310714.24.5DCA801
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7006214000B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:22:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fdpqz+vm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763079735; a=rsa-sha256;
	cv=none;
	b=StTI4511K3xNcPt7TLbfSrGYU0HAu7IrhRuML+JP1ZBYoQUt009hGx7Q/Ns8nkb2N9GbRO
	9h8dVFDKJaFDsiLptxEiGEYjEt+PRkwwjUL/lyhgTByLnrvWb+DCVdkot80N5N7njfOh79
	pkA4rqmttObNvFe54bkDilYe2TJIP70=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fdpqz+vm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763079735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RIjbNkqoNulLzLlyHXCny7IABL+fWWscqRaEPpqQAw8=;
	b=hRgk5KdjttPKnE+V9ceeMfJBl8hN8q9EUrk/aqGhBXEiWrfT0sYL8aa/HiaL9XkoMz5vOt
	0W21aJB/woo8HZj/evrEl9bCDqkNif/jZDpLXkocCDjyvhwH0IiERs5htMSknOFayurg7S
	uSv2Aq3xZVKNdfA5rcYs76/10Z55EEs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4387B43CAF;
	Fri, 14 Nov 2025 00:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF29BC4CEF8;
	Fri, 14 Nov 2025 00:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763079734;
	bh=0GfV0jqFwQWzRF/XGv+/zcvWfkWUsWtCyGdJidvbTgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fdpqz+vm7c42sbFTFZOC0iJiffZCDm0CNHUPMw2JPCQbGZNWweg9q00gVnvRjR9ve
	 hnahG3aUd1TZZUohCvCHsjxX4tOBaqlc6iSkso8rmdk3JwDU3KZoShKyR6KFWj6qIM
	 H4KTYacBo9upHTkvzMGyARULRDWWZKXaK3Qxl0zxAt/oz1kFd7Fp+GUN8hLe7a/+P8
	 o9WbUwuRpmePsRMBGakAjGW6fTHJMmJeNu/iRHsFnUIWEMxZT2xSEsgiIDhsyKSRzV
	 rrC/ofvQ9F631xkB8ik0K0j5Oi7/JC7bBbfXfbSy+iX0GHoT5a8ed0PL06sQRznIrj
	 Q9e+qVxD0A6Xw==
Date: Thu, 13 Nov 2025 16:22:10 -0800
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
Subject: Re: [PATCH 6/9] blk-crypto: optimize bio splitting in
 blk_crypto_fallback_encrypt_bio
Message-ID: <20251114002210.GA30712@quark>
References: <20251031093517.1603379-1-hch@lst.de>
 <20251031093517.1603379-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031093517.1603379-7-hch@lst.de>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7006214000B
X-Stat-Signature: ipbwqcru83zyackfb9z1at54t78m8q3k
X-HE-Tag: 1763079735-967921
X-HE-Meta: U2FsdGVkX1/VZRjtKQShjEAaIF30I9fVotcyIHNzm9MqTAjxOTBEIZlH9rVSBYffBWSgZAjb1DPXksZKxWPLiOokxV4ygSO4MlFbDJmLSskTSFrTQh6BhMlFCbwTeLp3byBZODIbcb1Z+HBhlDxH8gLXyTsAVns7+qsfqEuf/K1BuApT9plXp6PKagIB5CXK5xNvYKtOwEy8um10ncmwkfBFhICwlA6jaqGRMHI6LC1RNRoo9MTk9ivN7hwRTOGNESwbe7ub/nFQxiysdXGEWK5bNXvk9N3Jr+K7nMpzQREO/lyxNFQIXaSN1LJrc0fkTEgt9xaIiSTGSR4u5wwjVcCodAVR14eXsNV4WyXqlI3ivcVVKVmnrWWg1KHs9qPWZrKeYoc9je1MZMSkSRlmxYK07poJJyeieN35ZtZJnqsOc9nPNSu0Fqow/AP+A9TkLpfbmppyEbxHIPoTxGcwH2u2p/WRAKYH8a4ZMWoA+00eMXK5uggqPm4cfPI6Sg6i2lV0jryQfre3eq3LwD+uGStT5RajKr2JiHlu3w3+dTh6u3iJpVaEaMBJ04dzhWLUmhX+XTpjIH/mRfwyh9msWHGc1uLD3tAlyksZucRxkx7yKzvEXWEchhhfhc8PMt4fF2lJjMIdNe4TqBCZAXG9kOhp4H1REWPXY1Tp89xG7NbM67/8YGW3Xox3BNMmywqKTftfwfp0VdDQWDcZOaJG2ghMNxJWQ72lU9jRYHVWnxwXtulJy8BUkyTlFWP+pm42/0SiDnhOS/B7cnZHv4qFdW2UkrLMlhyGfz4jumQMEaHHeq88eMeMrhvsla0sk1ociuegecAQSzvMMVsUNE60IrPLCvZwfx+E52p/3j1hX0RLWEM3JqkOZ6VQEyY8v2+yFnzSMVakO/aUOOTb7bfqdtT1vvEsKLBPfj3m4gUv5XDZMj5XhvmLA8dRlB9rq5UlDqELDngUsMI6c/FfKmJ
 uZHri1I6
 1FcZIIij6wHByjHiIqFkHe6LLoqH2fugEMD4GXYz62matyH99gd5Vpm8s0axGLxDCDSXbFsRPxDh+w6xixD7/sq1XNEZ7XHLZ8rWrh1ZESyJKk69NVhILx/P1g87xDxFQEX1+JpbKuzI8IwSOjfrIXe8NAXcPVdtXnBh98uO50ZMAiVrlQ0dcJfLI6UZYLUD9OvRLxtaVIhI7eaqRpmfBgQUxkfjVh8PSvEsZ5jeRVWLwoAmLi7dNf/SJPP7OjUmFbVoJ2rQ3LmmYKbLSp0i8pXvmCnTG3vDPHXHvgTv+9BQzx9M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 10:34:36AM +0100, Christoph Hellwig wrote:
> The current code in blk_crypto_fallback_encrypt_bio is inefficient and
> prone to deadlocks under memory pressure: It first walks to pass in
> plaintext bio to see how much of it can fit into a single encrypted
> bio using up to BIO_MAX_VEC PAGE_SIZE segments, and then allocates a
> plaintext clone that fits the size, only to allocate another bio for
> the ciphertext later.  While the plaintext clone uses a bioset to avoid
> deadlocks when allocations could fail, the ciphertex one uses bio_kmalloc
> which is a no-go in the file system I/O path.
> 
> Switch blk_crypto_fallback_encrypt_bio to walk the source plaintext bio
> while consuming bi_iter without cloning it, and instead allocate a
> ciphertext bio at the beginning and whenever we fille up the previous
> one.  The existing bio_set for the plaintext clones is reused for the
> ciphertext bios to remove the deadlock risk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-crypto-fallback.c | 162 ++++++++++++++----------------------
>  1 file changed, 63 insertions(+), 99 deletions(-)
> 
> diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
> index 86b27f96051a..1f58010fb437 100644
> --- a/block/blk-crypto-fallback.c
> +++ b/block/blk-crypto-fallback.c
> @@ -152,35 +152,26 @@ static void blk_crypto_fallback_encrypt_endio(struct bio *enc_bio)
>  
>  	src_bio->bi_status = enc_bio->bi_status;

There can now be multiple enc_bios completing for the same src_bio, so
this needs something like:

	if (enc_bio->bi_status)
		cmpxchg(&src_bio->bi_status, 0, enc_bio->bi_status);

> -static struct bio *blk_crypto_fallback_clone_bio(struct bio *bio_src)
> +static struct bio *blk_crypto_alloc_enc_bio(struct bio *bio_src,
> +		unsigned int nr_segs)
>  {
> -	unsigned int nr_segs = bio_segments(bio_src);
> -	struct bvec_iter iter;
> -	struct bio_vec bv;
>  	struct bio *bio;
>  
> -	bio = bio_kmalloc(nr_segs, GFP_NOIO);
> -	if (!bio)
> -		return NULL;
> -	bio_init_inline(bio, bio_src->bi_bdev, nr_segs, bio_src->bi_opf);
> +	bio = bio_alloc_bioset(bio_src->bi_bdev, nr_segs, bio_src->bi_opf,
> +			GFP_NOIO, &crypto_bio_split);

Rename crypto_bio_split => enc_bio_set?

> @@ -257,34 +222,22 @@ static void blk_crypto_dun_to_iv(const u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
>   */
>  static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
>  {

I don't think this patch makes sense by itself, since it leaves the
bio_ptr argument that is used to return a single enc_bio.  It does get
updated later in the series, but it seems that additional change to how
this function is called should go earlier in the series.

> +	/* Encrypt each page in the origin bio */

Maybe origin => source, so that consistent terminology is used.

> +		if (++enc_idx == enc_bio->bi_max_vecs) {
> +			/*
> +			 * Each encrypted bio will call bio_endio in the
> +			 * completion handler, so ensure the remaining count
> +			 * matches the number of submitted bios.
> +			 */
> +			bio_inc_remaining(src_bio);
> +			submit_bio(enc_bio);

The above comment is a bit confusing and could be made clearer.  When we
get here for the first time for example, we increment remaining from 1
to 2.  It doesn't match the number of bios submitted so far, but rather
is one more than it.  The extra one pairs with the submit_bio() outside
the loop.  Maybe consider the following:

			/*
			 * For each additional encrypted bio submitted,
			 * increment the source bio's remaining count.  Each
			 * encrypted bio's completion handler calls bio_endio on
			 * the source bio, so this keeps the source bio from
			 * completing until the last encrypted bio does.
			 */

> +out_ioerror:
> +	while (enc_idx > 0)
> +		mempool_free(enc_bio->bi_io_vec[enc_idx--].bv_page,
> +			     blk_crypto_bounce_page_pool);
> +	bio_put(enc_bio);
> +	src_bio->bi_status = BLK_STS_IOERR;

This error path doesn't seem correct at all.  It would need to free the
full set of pages in enc_bio, not just the ones initialized so far.  It
would also need to use cmpxchg() to correctly set an error on the
src_bio considering that blk_crypto_fallback_encrypt_endio() be trying
to do it concurrently too, and then call bio_endio() on it.

(It's annoying that encryption errors need to be handled at all.  When I
eventually convert this to use lib/crypto/, the encryption functions are
just going to return void.  But for now this is using the traditional
API, which can fail, so technically errors need to be handled...)

- Eric

