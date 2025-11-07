Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94968CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 04:20:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52AA8E0008; Thu,  6 Nov 2025 23:20:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A29DF8E0002; Thu,  6 Nov 2025 23:20:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 966AB8E0008; Thu,  6 Nov 2025 23:20:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 82E2E8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 23:20:43 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 26F291A0343
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 04:20:43 +0000 (UTC)
X-FDA: 84082509966.23.4F0E731
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 662A910000F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 04:20:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Eh147owS;
	spf=pass (imf14.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762489241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YzONbdifdKN6Ryn/Bw2gPyVvJr8UpT/by5KOCRw+vn0=;
	b=YtSEoyDI3rru/AloTUVkUwryqmiLLhyooStuGR/cXT2664+CtgdC/DOY6C7/rrw1f55Obo
	C2l0O89IXeOy0BwZOuHNzvEt8pDfB09WJu4xmJGZiSyqSWKh0EdXMrAg3NzbW6oddVJ/iJ
	o5sfsl60KzqqWHbjz8Hf+qsjDRAHC4Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762489241; a=rsa-sha256;
	cv=none;
	b=t97mVJq6dzLyS0EWk11MIxuuIJH6rlfQQdaT3zXqoecxEl+bccagl1zccODvVmx9anrb7H
	+/NcRqe6MLHswFyxc0Kvsb+aXS5eQiXBvZU+GG6HLQ8H3pSrxkr4Vv1wANg6O2qCoXbcGY
	e8BJsiQRCecyET8MyGK8jthlGApHB1g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Eh147owS;
	spf=pass (imf14.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 766F842B85;
	Fri,  7 Nov 2025 04:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7DEC116C6;
	Fri,  7 Nov 2025 04:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762489240;
	bh=ClMjTuO8m+qGYTF99gai8zRYpEMz8d+n7I8+JWoo4OU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Eh147owSGuUYobLskWyhN6dPCJwsy93T7T3CqmwDglhaVzkdcBqwjvABAUi4GWT34
	 LCsdr2EwD4Hz7OGm5BhzvIzkY/Ztu8iGDgg1GBjXz7cmJ7IaRjYapmNF+XFYcHAjzg
	 fq3MQUhxWiCS36Grsaib78l/HmEuJ7TY/M/7/2s64RNQgaSE2FeTViriZjbhu/u2qv
	 vM/I3gY4UOisNIK1o41lVSOlaiYt7Fq8+C55qohB/n1mpm5ph5JNly2Hoain/OimHo
	 2Q82NczM3L5K1Uk2ENnChEfObr+zfOg3S7ib/MQmZOWyUInaPo2tp1Ocw6B1LDGvWh
	 OG+QBocATan6Q==
Date: Thu, 6 Nov 2025 20:18:59 -0800
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
Subject: Re: [PATCH 8/9] blk-crypto: use on-stack skciphers for fallback
 en/decryption
Message-ID: <20251107041859.GD47797@sol>
References: <20251031093517.1603379-1-hch@lst.de>
 <20251031093517.1603379-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031093517.1603379-9-hch@lst.de>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 662A910000F
X-Stat-Signature: cagorb49qg53m13e76rgczdse1nceyb1
X-Rspam-User: 
X-HE-Tag: 1762489241-329386
X-HE-Meta: U2FsdGVkX1+iogdB0H63f0fcui3aAasYDjbadNWNjI0h20w7zyslfhvQ/HTpkJcPjS3WLwghKRKmz7ilgJI7KaqRIL0/Q52UNzYCDRyp0FHe5RZQVyomM7eVjJmhEbLPs7lUFbheRoFuihm4Zmx+tFevLhOAH3FuwJwqink+lR4qPbC2QUxBPMgpkdQo1+r5bkxZQ75QsYU8MdUOJRtKhYB1u8jP1Gb8dBhRND8M0DYewfrTszCEUWYCNQwODatRFfsTOgqoig77zu4M7HuDmz8bndGlhl/MaNvOmUkFcsWDJh+4992WEyH5nGRqwUgnbrZIMndFvryDiMAYfHQmKIPjPXc8i0URBqSbpXXpc2mDeukqjNIEMcQymUEM1jMuxm21CpZnHhzq2QwtH7COQtO0TwEKqjOMBKkStCAZ7spJzsk0+YJjnXTW+g2AqBQY3pR0OqK0Y4OYQ09ArNzG6hy8NQRkb2A5p0ZhU1ZOCFkCrCTBSZ1YcZGUJ7eASzYH2wf2cjaFl7ietv2UhvpFijoESyuudhW9Q9CTsFXgvjcAL1JHxx7lH48hbGyBCyM+udSnq2esyP4hb0vcO4bzOrdCiyxHZuCaaWLxU1KaFY/ihWwyyeKkB4woFo5FRFXu6UN3ZEIDCatygaPxxscMDFblmxIFsYiRlv1qQ8p21B6+KZQeFXzoPw9j6RDTP9RWvbLuW9y6sLpWQ+hxYXxE30fpQAm3jKQ9uDDaN0k0ypYt28LiRahV5sU2ms+dIpfxV4emuJXjbJxRZG4IVGE6GipagehsmJxtU0Frqj4/zZ2QRhuBe7oOYxyGdr2yRS+2o2qlooxVyHRRHKm0byuoVI7FlT8/IIzYx+i06lrroPP8QikwCVKKj8BwcuWbu6rf8s/9vwXH+nQNotoZUxQjuEk5y6+jlCLKK0FvRRIIGVpQjirZkXTtO7+OBXJ1diwG1Xc+NinrXfCPe1m/O9U
 4pFDJ/va
 mFmbQh8PospDK8j3g9f6WiKLzXzJvGRPzXU8X1ZlJ7+h9MKhzYLRfqx7tfz3AiaBNQDeNmm+8TJD8m6VRIa+V3e88E5H0z6XQAQKORtOy7uovDXrZUrTLqDdfAm2e7fa25xRJkCCLF/lCqj4YTLmQ31s+gnpetE6qpupcnLRT7yrItEm5/Jw66xakKUoznY07HKTBgHP9SzDMflkMU3+EMtNpbg1JwykTknQ6Swt8u4P0OykrWAls3BR33atHjQa8NI/P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 10:34:38AM +0100, Christoph Hellwig wrote:
> Allocating a skcipher dynamically can deadlock or cause unexpected
> I/O failures when called from writeback context.  Sidestep the
> allocation by using on-stack skciphers, similar to what the non
> blk-crypto fscrypt already does.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

It might be worth leaving a note in the commit message that this also
drops the incomplete support for asynchronous algorithms.  ("Incomplete"
in the sense that they could be used, but only synchronously.)

Also note that with asynchronous algorithms no being longer supported,
the code can actually be simplified further because the
DECLARE_CRYPTO_WAIT(wait) objects are no longer necessary.  The sequence
of crypto_sync_skcipher calls that is used should be similar to what
fscrypt_crypt_data_unit() does.

That could be done in a separate patch if you want, though.

> +void blk_crypto_fallback_encrypt_bio(struct bio *src_bio)
> +{
> +	struct bio_crypt_ctx *bc = src_bio->bi_crypt_context;
> +	struct blk_crypto_keyslot *slot;
> +	blk_status_t status;
> +
> +	if (!blk_crypto_fallback_bio_valid(src_bio))
> +		return;
> +
> +	status = blk_crypto_get_keyslot(blk_crypto_fallback_profile,
> +					bc->bc_key, &slot);
> +	if (status == BLK_STS_OK) {
> +		status = __blk_crypto_fallback_encrypt_bio(src_bio,
> +			blk_crypto_fallback_tfm(slot));
> +		blk_crypto_put_keyslot(slot);
> +	}
> +	if (status != BLK_STS_OK) {
> +		src_bio->bi_status = status;
> +		bio_endio(src_bio);
> +		return;
> +	}

Unnecessary return statement above.

>  /*
>   * The crypto API fallback's main decryption routine.
>   * Decrypts input bio in place, and calls bio_endio on the bio.
>   */
> -static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
> +static blk_status_t __blk_crypto_fallback_decrypt_bio(struct bio *bio,
> +		struct bio_crypt_ctx *bc, struct bvec_iter iter,
> +		struct crypto_sync_skcipher *tfm)

Comment above needs to be updated, since this function no longer calls
bio_endio().

- Eric

