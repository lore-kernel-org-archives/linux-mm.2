Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1985CDE00A
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 05:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59CF78E0007; Fri, 14 Nov 2025 00:57:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 526CC8E0002; Fri, 14 Nov 2025 00:57:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43CAD8E0007; Fri, 14 Nov 2025 00:57:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9288E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:57:31 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE55B4C716
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 05:57:30 +0000 (UTC)
X-FDA: 84108155460.21.99F351E
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4F2B11A0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 05:57:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf19.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763099849; a=rsa-sha256;
	cv=none;
	b=WYk163Tm/KCZdelN/wYYoabPE5CQ+MYhHdfdII/UZyUT4iZ847BKejQCcNw5atMQj0oA28
	46g0DN2Vy3KhdIOamrXUflDNWQsDljfVz/0oZiXhDD/UlaoNynz+l/fwthVNoe9D2kVpuI
	Qyt6/vey22UC2LDLTLmoSlM63qPOqM4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf19.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763099849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GeSeawVoEyDjeKYLy5k0PiYyph3mzj31KD17+d+zDNo=;
	b=sYVqy77zsQlR+bRIzC+aiOXjr2Sh/RXPqRKFK/prqlV1vy42MJfHVq2SJtdL5MGcFTZYrS
	XAiG4+X3cqMGMpUpGs2jr/Tv4NfE/59tASl9Z2L3rNxfp/CyLNG36Fz68J9NtVCdoXLzpG
	DsFoqdg87cVVUTmWkhIf+kbeLXTU4sU=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6DD2B227A88; Fri, 14 Nov 2025 06:57:25 +0100 (CET)
Date: Fri, 14 Nov 2025 06:57:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 8/9] blk-crypto: use on-stack skciphers for fallback
 en/decryption
Message-ID: <20251114055725.GC27241@lst.de>
References: <20251031093517.1603379-1-hch@lst.de> <20251031093517.1603379-9-hch@lst.de> <20251114003200.GB30712@quark>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114003200.GB30712@quark>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: 4F2B11A0002
X-Rspamd-Server: rspam07
X-Stat-Signature: pyrkrwid749h88fxh1tz5bk3qf7bmfnc
X-Rspam-User: 
X-HE-Tag: 1763099849-390264
X-HE-Meta: U2FsdGVkX1/k60Wx1b0XB3t2KEKOs/SNplaBq3OxGe2vsHk+8Du07sdSuqGqpgd2E724zzAq7gbPuYD8kVzJazWVuopKzRLUgUAnethaSYwA+h/RjLx3yr3Ikm6K3cRooyeN3lUG7nAhVwNnnSXn7qeUFu+OUx/Cpa90/rsMgYEoXQB+BML2F5F1qsOkm/uymSj6qgLZfkucagY+sxz6yPQoCqSqKaVBALX18DHo3EggJRivw/BWRHuLJvgLOuvHHumNNcWUxR2AaE5YFqHQVAkWdDA7YU9pBOGKbua/B7AjT/bI0enGxZrlpOqwugjvh1/P/mDYPojXjgnlGmuw7DyD2jK0WBk2+WH29AHJ4Sj7Ea8i71g+vfFsMvpEo5304KFikkDJXbNjluBDrr1jzyjbCZoWijkQMixHrfmBX2cxTPgZbrD4XXcNJRvk8Ed0iSHj9AHcvKxgefs8Jqz0Bak7hbVx+1Uci3oXpw8jDK2MtV9y4Hg8aIYKHfsG03tjc3/qKFaAe+oBc+lBJcxkT0+LlJ2wzlZyVu4vx4w8h/siNog2serGmGzgxixS3C8dEMFycKh+9jQ0xZNe6zutQr7hST2V0DKaU09T9AbYAHzFXbbHtHZu80xRxReCKueNxKRNFbzeuBxKqmBju9eD+zsXJgEjfSBBBWeYu/Hx6bXVvI7QzScb8dUH95yYGHfLIUitG/wa7s0DGAvgoE0P1VvtOK6VvusSONqM0aEI8XZ1Q/3scxEgXaklfwX0QNVVoqQPX9dG7YDko9kdcPR01MCSCts+Z+jfhPcqLXwuZJHd34/GSEXQu/c4lDwTrfuuSgpe13mNh+rG5B05WrVZn7pXbj/rZqC1B6BtjXmurZbeEBk+xxuRr6g79DuaBbmbBHZyyBjxD2KsibBeBnJqzj7M6k4RnuBU/lYRkb9C+SFxZlwfRGTquvqhVc23U7YHKVQybF+MBQYraQenYkh
 yKKYkiDZ
 XlsqoWHkVt1j0dFZTvsT0UPeqGtD68RIxDRPALmYB0O7ZwZO4VE8GXT8/pDqsqzy0PPBjB/klx8eYEpi/mzuHlNCT54jHDJKj7bQB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 04:32:00PM -0800, Eric Biggers wrote:
> >   */
> > -void blk_crypto_fallback_encrypt_bio(struct bio *src_bio)
> 
> The above comment needs to be updated too.  Maybe leave the static
> function __blk_crypto_fallback_encrypt_bio() uncommented, and write an
> updated comment for the global function
> blk_crypto_fallback_encrypt_bio().  Maybe something like this:

Make sense.

> > +	struct bio *bio = f_ctx->bio;
> > +	struct bio_crypt_ctx *bc = &f_ctx->crypt_ctx;
> > +	struct blk_crypto_keyslot *slot;
> > +	blk_status_t status;
> > +
> > +	status = blk_crypto_get_keyslot(blk_crypto_fallback_profile,
> > +					bc->bc_key, &slot);
> > +	if (status == BLK_STS_OK) {
> > +		status = __blk_crypto_fallback_decrypt_bio(f_ctx->bio,
> > +				&f_ctx->crypt_ctx, f_ctx->crypt_iter,
> > +				blk_crypto_fallback_tfm(slot));
> > +		blk_crypto_put_keyslot(slot);
> > +	}
> 
> This is referencing f_ctx->bio and f_ctx->crypt_ctx when they were
> already loaded into local variables.  Either the local variables should
> be used, or they should be removed and the fields always used.

Yeah, I actually noticed that myself after sending out the series.


