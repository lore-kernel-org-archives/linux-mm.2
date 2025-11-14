Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F1E1CD98C3
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 00:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 503AA8E000F; Thu, 13 Nov 2025 19:32:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DAF18E0002; Thu, 13 Nov 2025 19:32:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 417EF8E000F; Thu, 13 Nov 2025 19:32:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8508E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:32:07 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C912D56F94
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:32:06 +0000 (UTC)
X-FDA: 84107335452.16.F0136CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 083C0C000D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:32:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KP0qAHiU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763080325; a=rsa-sha256;
	cv=none;
	b=3+FCGdX/dywDwBQauVN3irGQRuz3vDKrGgX6U/M9gO2Z31Fr90gc++Hy5wYXj3qCjEawl8
	h9OXwL3q6aByYZdj297myVcWgLXAEdk/n4izIAVlwZJ7/lT/SVVTg844U0+8LUTKTPmR4I
	Bc0HaBhRE2TOhz3XVrBLQGr6SN1R6U0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KP0qAHiU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763080325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f46rRjObQ2ocCrtweLQC+sXzIOafuapd1t69L9LqSxE=;
	b=2SXUnoMjXyFfgDjlSPvKg8eiOgJbHjH3R9Zr0L9YQdwOe4ENM8ibq+IWl4ukGzBZ4WHjlp
	ymekiv1T9MW9YMYP1LyLHW6u4KeZaXS8UGZU8LquphbPCFCyk4vdbwbju5DlkMPuBYoAg1
	Tv2xS1MagoVECnXXaaoBbG1XCuM9+Yc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 636906015D;
	Fri, 14 Nov 2025 00:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B98AC113D0;
	Fri, 14 Nov 2025 00:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763080324;
	bh=vemPluv3EUqZUNat690foFoJUo/d3oWc4vaEnI0MUEA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KP0qAHiUTfvg82EUnli/odRGIciIEcjFYmZUzQexNdVA/5gAIohyW6j/AzMB9zrmj
	 117jmLDggBYNn8zEE+BaK4vo6rs6OyAjzjHJHBZx/IAVkZFY5MYkSvGEu+hLvpohsw
	 gwPcLNnhPyctAy2m3vNOhAcnvEjeRPsJQ7vDTk8epfrFeDrnYezTvbJfZgEBRHLMjk
	 N5JgyKdrArKKBx5924sGy4qw5H4xQ6d/h8G/kKEWFXp2ZCHBhJ4A5iyY5BQR6EzLHE
	 Lj3ey+F+QJARs5elpbplC/IXhGXjzcEO955WmprLLox+kOZfAcu8XcOQ2Vu5wBzNjO
	 bFkaxs/VDo7iA==
Date: Thu, 13 Nov 2025 16:32:00 -0800
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
Message-ID: <20251114003200.GB30712@quark>
References: <20251031093517.1603379-1-hch@lst.de>
 <20251031093517.1603379-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031093517.1603379-9-hch@lst.de>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 083C0C000D
X-Stat-Signature: ur1wo37dey5hek3gnx3thezaswnb3k5o
X-HE-Tag: 1763080324-622371
X-HE-Meta: U2FsdGVkX1+vIvJjFOzvp/7k5FLaKP81Pvvn3ua0+cVNgyyJGB5TXkdIQFwI5VjthHcyRof1fVXHmHCUfoOlgHbO4BYtjnNfQnUaj+7zNQywDTPNx77q2+im4pf5YMjmz24lE+QvNPAsxxXGcy/Pc8vdFO4DfHCNYOdPFKlhpK4cY7K6eRPd52x/SzKMiZDn4f0H5WjtajdYOx13+1lH/skXxKpNXkABgEvvk8r/NaTZLKsBYa/b6RW48tOuh7WLyY0L4xejOswgtjuAbSO3+pS88vA8y44aACumaYgY0VsKobJIV2SvXCf5n5DCl83Cdt0ltGXHkKtA9qa00EkNsYeKOKoekztAqcCGLzcZOCbn4Ov501mV+4sCHfknIKgDENPm5/koMNNOfDULNQUwZs9XxASR1OKblYjqznblvA6dKcdTQQxC2asNK8xe8FBo17ud2ARfz06GsMZ/oHKZksggOLSw5xZdXf0wYFXNtx4gRiQKraGn91OGa8tJsxAAOhv8BMkJ+MNUpbNcCJMz6nlbkJDiz5FWqIlztEpTYLHa5yhflmZju4cSS/RNWU+8Vokb+DBuWCraF0Ht7vKoVToikPuEnqdoBazr5O+iEg3jig2plhLc3GoFf1sDt6TZM90HA30ifnEbrxwAPg6bCOx4ftkILV2n1aItJ4VhGiJRO+uXQzk/c+sCpoUrioA43YCD2BoQctCOo49cTZ8peS8NsbS4N6iHwagdvplQUcFc2lj6iqCK0CMz2M4m5yHx7vDW2hMrW3rkNWFZ6jz5gtDQ9HuyP3ssouMzOETaFTIhDfLQraHg9egcOaqHdt1bkIUoH67E7nfWZsIOMJgmtHhEYwMoB0NqAyluQ24D6xxKmoqDx73NccU14KxB+e7NeMYTs2lYrjgs7wmD0BYCmfo/oll/5iiZAtDUwUrxQADfEbDFJUbmN5RfL6AzJJ9AhgkNKvookCMG8YJMkyc
 ml4/GBQQ
 bB9ETGnrmtqZcT0dMTjPAMOggDKP1VIBWitRr2QQAttibS8F9332sPSGN9Bam1ivv9+8FSoFNfw0xYifFT7ZOmd9LJBqe6XNt089gkxdun6T0ffQC9f1gPp19HrBDovzNQ8IqhY2a4FqBJYqT5GGnwbvzgjeudGxLD0dhVVTfTTqy0LxC0K04QccOmRmVWcFUkJEEcHTDTkgxQKNJRjpsO4Lk6/DW3/CMzZA5VTyAolT6Q6JkiCs+8TVzIzSRY37FBOHo
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

skcipher => skcipher request

> @@ -238,12 +223,12 @@ static void blk_crypto_dun_to_iv(const u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
>   * encryption, encrypts the input bio using crypto API and submits the bounce
>   * bio.
>   */
> -void blk_crypto_fallback_encrypt_bio(struct bio *src_bio)

The above comment needs to be updated too.  Maybe leave the static
function __blk_crypto_fallback_encrypt_bio() uncommented, and write an
updated comment for the global function
blk_crypto_fallback_encrypt_bio().  Maybe something like this:

/*
 * blk-crypto-fallback's encryption routine.  Encrypts the source bio's data
 * into a sequence of bounce bios (usually 1, but there can be multiple if there
 * are more than BIO_MAX_VECS pages).  Submits the bounce bios, then completes
 * the source bio once all the bounce bios are done.  This takes ownership of
 * the source bio, i.e. the caller mustn't continue with submission.
 */

But really that ought to go in the previous commit, not this one.

> +static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
> +{
> +	struct bio_fallback_crypt_ctx *f_ctx =
> +		container_of(work, struct bio_fallback_crypt_ctx, work);
> +	struct bio *bio = f_ctx->bio;
> +	struct bio_crypt_ctx *bc = &f_ctx->crypt_ctx;
> +	struct blk_crypto_keyslot *slot;
> +	blk_status_t status;
> +
> +	status = blk_crypto_get_keyslot(blk_crypto_fallback_profile,
> +					bc->bc_key, &slot);
> +	if (status == BLK_STS_OK) {
> +		status = __blk_crypto_fallback_decrypt_bio(f_ctx->bio,
> +				&f_ctx->crypt_ctx, f_ctx->crypt_iter,
> +				blk_crypto_fallback_tfm(slot));
> +		blk_crypto_put_keyslot(slot);
> +	}

This is referencing f_ctx->bio and f_ctx->crypt_ctx when they were
already loaded into local variables.  Either the local variables should
be used, or they should be removed and the fields always used.

- Eric

