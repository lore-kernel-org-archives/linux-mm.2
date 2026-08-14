Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B34EC5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 19:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3DA86B0321; Fri, 14 Aug 2026 15:45:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEFD56B070F; Fri, 14 Aug 2026 15:45:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0A8C6B0710; Fri, 14 Aug 2026 15:45:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3066B0321
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:45:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4216B14021B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 19:45:11 +0000 (UTC)
X-FDA: 85100903622.28.9EDB53D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A0D5640004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 19:45:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RKju9zwC;
	spf=pass (imf17.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786736709;
	b=B7bJChBJ33GHr1Y80wPVBrVt9TxM4qORq03dCRk9iE+NYuJEBKaLON6JtMlFdGUKvukMzC
	ocw9cKUZ5P3th0RtL3N+d1g2gseWlx19zmq1AK5+9MiQYX9Mny7L1lPX50YgxrsOdDft2t
	r42rpaZrVzSD9acl84g0VRtuZutW8xo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RKju9zwC;
	spf=pass (imf17.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786736709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=npc598iUFDBk93SNBYPj3uUy6PeDDfOU+Bj+owwxRcU=;
	b=qZaiDB0QDw/diCx3xUhdpZU8s/Q6/5ZVlCBeOyTktVNvo/NxQB7Z69ogkYOjnccX/USItf
	lUkw0jIY+Wd2yumyW9cwau8N+DS4JIs/JbPrqoBYsCto4UGLvNvqnF84XEI5DUdITGVIpx
	lAXJ7ebf9ane+ogh+LqaCE4ApW5/Yq4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1750C600AF;
	Fri, 14 Aug 2026 19:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902581F000E9;
	Fri, 14 Aug 2026 19:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786736708;
	bh=npc598iUFDBk93SNBYPj3uUy6PeDDfOU+Bj+owwxRcU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RKju9zwCpBAX9U5ddZN10ApU6++sqkdd2H6la+dMXd/w2Y522GVlW4PBzOYS7iLDq
	 qqVgGANoTplV4VyI2cGUKnr+4xU2iqWuZd4WOtMeybrGohiqYrbXPr9vuE/0IU8neU
	 YZ2iyZKCtjex+fCzXVIVengd6M95Qm/HzZ7KQRLjEynS2tuEUWd7p/0HIoVhszYjx9
	 7hduW0b5W1vE/ut/oR09dFHsEJbaaVzKoCFonMa6PJpLtruFXpQiWVgtJHDtFaLrDZ
	 uBepRCOv3bVcW/lvQoLRp6HBj7E+ZORdZTpXxQltAnEhDtrjvg+SUMS+vgap+BBOYw
	 N1eQsc+aRn3mA==
Date: Fri, 14 Aug 2026 19:45:07 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] blk-crypto-fallback: Fix deadlock when encrypting
 large bio in dm layer
Message-ID: <20260814194507.GA2644249@google.com>
References: <20260811220318.58331-1-ebiggers@kernel.org>
 <an63CV2_cS3VqPE-@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an63CV2_cS3VqPE-@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A0D5640004
X-Stat-Signature: x3kwrnqirobjrgig3jzjdahxms9fd1tg
X-HE-Tag: 1786736709-450776
X-HE-Meta: U2FsdGVkX18vzkHDxBk9KeslSRnt5XTW6kspZ7Gd+bCeB4ohICbYbXYdycLvK1kdmtXQ7C+S0bPowmTBAJVbxUE/pYFEfEpvbmyblpTgeX5MEimVqwDbXVvnH31BEz+zPJKLVLGRTkU2bwBQlEU8oJATST5n0Fi6hJLAWXn/8eqMYHU83DbImzGaDAM0ig0UDcry1LPTx7P9Q1xk4wu1YJ/AveQhd+y+xy0ss8/OZ4/fKfLAWejdfhUhQoPwC5LvDCx6TCffHpDBwvo/StIZG7VSgfrcVH4c5H5zTD8kXdPzQLAOlQTvj6lTNy0/+M5dD+zmb+18oSdz5pJHL7wXlGtxktpvfC6RoJTVikSkLtwPM7H3QraZng095SDnWvHbxrNvHunsgmSWb7wWZ7b+MAdpF+szRsUj8odwcD8R/uvcY/U3hNhNekuG8P05XoTMixA0AWRoiPb1lVTEvfNpRzMadTk6bSugGrD3pXWb1jroodFshy2WHxKViczqOk1PWT5Pcadz99d0KuVOSch+25chrb5us8VdwdYG0UOoe3RFzntD+LsI2BH3XnGeRQ/nULKEJQnjav0pc226Fg/9xcmTQxKsRL0MonhbsLqoF9nkUGM3mV+rKEaGm/8yK4cS3/TFD52zQwNTrSpfkh8SJXCXL/+dXkA5YZkAIOMhYOZ1cNowGN5weC0x11LeT3PRg1k4lDoa9W4kKkClBvNvfYRkhNGlB7pn2Cp/Uf4D+wdYtLd5ZSQIMVmJFuH5Leku/72GOmn0Qw/XU1jsBNsR8pRuaCW5xeqwH2/GQcHov620AQXKIMHj+xdoZ7yaLwMC8F+kQfsmY189lFP9GpDZe67wT8ysNT00/8biPGfW303DXGIIOCFrOZ5GrAmJtRe3x4S8XS+oCv5OeAFtyum1OZUtBEKp2cveAS+sNIMpV9rF/jtI53N0NfUzVYeDOk9vIGwrbx1DuXzz5OUjz+L
 0WvZVOCl
 aKZrdm+pLoS5Eus6hYF7K4KXwtsAgWp0E1czb/DMoH7wdLs6v+Vzgf1L79wKab850PAmozge8wdWo2x20b4t59KDpsdeKKqPr+1EkSd5MOZ00EV252xL4iktRSbzVFVPBhtf64pKpZ5WJ/jP4wYFz3nnAZolQHggVw1YFGxnSwgmWUGkDHatChYUgoQJGXISABuHpuNmL0cIQUhdHuLHzRqvmlByFgozRxfYM6CBhdAPub1oIx4Nw141FlhWquQSqCkKRrQkHkXQ5a0I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 11:34:49PM -0700, Christoph Hellwig wrote:
> On Tue, Aug 11, 2026 at 03:03:18PM -0700, Eric Biggers wrote:
> > Encrypting a large bio with more than BIO_MAX_VECS pages can still
> > deadlock, even after it was attempted to be fixed by
> > commit b37fbce460ad ("blk-crypto: optimize bio splitting in
> > blk_crypto_fallback_encrypt_bio") and commit 3d939695e682 ("blk-crypto:
> > use mempool_alloc_bulk for encrypted bio page allocation").
> > 
> > This is because __blk_crypto_fallback_encrypt_bio() assumes that the
> > bounce bios that it submits will eventually complete, unblocking it from
> > allocating additional bounce bios and pages.  However, dm-inlinecrypt.c
> > calls __blk_crypto_submit_bio() from within submit_bio() itself.  In
> > this case, the recursive submit_bio() simply adds the bounce bio to
> > current->bio_list without actually submitting it yet.  That breaks the
> > guarantee that forward progress is being made.
> > 
> > To fix this, allocate the bio and bounce pages with GFP_NOWAIT if
> > current->bio_list is set.  If it fails, punt the encryption of the
> > remaining part of the bio to a kworker.
> > 
> > Fixes: 488f6682c832 ("block: blk-crypto-fallback for Inline Encryption")
> 
> No, it dos not fix that commit.  I "fixes" the misguided attempt to use
> this from inside stackable drivers.  Let's drop the dm-inlinecrypt
> target instead as this just shows up one more reason why that is a
> broken idea.
> 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> > 
> > Changed in v2:
> > - Switched to the less efficient approach preferred by Christoph
> 
> This is in no way the approach I prefer or even advocated for.

It is what you asked for on v1 and you've now changed your position, as
far as I can tell.  I can change the Fixes commit to e7f57d2c47e2.
dm-inlinecrypt is useful and it does not make sense to drop it.

- Eric

