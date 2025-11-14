Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E56DCDB462
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 00:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9F028E000F; Thu, 13 Nov 2025 19:38:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76A68E0002; Thu, 13 Nov 2025 19:38:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3C18E000F; Thu, 13 Nov 2025 19:38:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB5B88E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:38:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D0B4140224
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:38:35 +0000 (UTC)
X-FDA: 84107351790.30.9C18EA5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A7C2D14000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:38:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XUAnNNjJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763080713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DEhuBllf1OvtcL3mYVT8Xouoh2nwMfU2UUWBP2Huj3Y=;
	b=WimFD5XMJwvMAwsepjgugFhRArcT+emqzluE9uihZLGGAqpFd5xAmipqUtUNvwptM5kXYu
	TBxia0jmFgxTfqravZwdQ9iQBEWU5WT0qfHOuUg3qZxqRbrERN2fgMpTeh4p5iFxwGVrra
	+JVnPJWMU5ynKuQr0Ge6bc35sGV19Xk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763080713; a=rsa-sha256;
	cv=none;
	b=pMI+uvYA42G+ZNcMpg/kKcAf5Tw6h9+3t2ZA6re0VQatLnXlqinz5d4sjcmLF3iz8ZQ96u
	Vtu4J30TnNQ22BmxFGjYOqjgCXb0mUh1j3QzCQqy6Y7jp47UGdpBNE7Cm3v4zJy7/B64oj
	7HQT8PAZTLhI8SSy26WxGCrf/6IHOhA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XUAnNNjJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 69C9F417A5;
	Fri, 14 Nov 2025 00:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08769C4CEF8;
	Fri, 14 Nov 2025 00:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763080712;
	bh=VnC/Cpeb7QXhyfiqkSDO4UcZXLs/noIUYMjxye6egB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XUAnNNjJ+3nSCgOJ3PR8vZDu67EvX/FawQM01PvWo/ci8bnmP2rNvE/WsnHqZ6L6S
	 YKJx52A01ibfJBY+6aDXkc9edSsf4tVWTFBLbBPjeEaaFT4ks/H/cxNgYKplSvAVm/
	 mF0mzwsc2B7Od1fIZWgDi/uuCqoQhcL7Xc0bIvMf88v59R1GUTwcom7oHYlUEAD2WH
	 H+ShHpfNNlDzA60Z/AqHCux1aFzH0HUcNYhbKHYBsyiJqZJQR9LHP42oOokHTgpgo5
	 U7AsaeRG2b0CFIMRJEJZBCZ/D+eV2pKlMQjeWCnkd0ktHmQtIc3FdQZxZiMjn/m2aI
	 iSJdeGllV5Oaw==
Date: Thu, 13 Nov 2025 16:37:38 -0800
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
Subject: Re: [PATCH 7/9] blk-crypto: handle the fallback above the block layer
Message-ID: <20251114003738.GC30712@quark>
References: <20251031093517.1603379-1-hch@lst.de>
 <20251031093517.1603379-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031093517.1603379-8-hch@lst.de>
X-Stat-Signature: ycwt8qmt858srtzwknqtonzsxc1zz379
X-Rspam-User: 
X-Rspamd-Queue-Id: A7C2D14000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1763080713-172253
X-HE-Meta: U2FsdGVkX1/K2el8lbYhca2K8u+vqK0+4eXfkRNSEuaKG5hhFlTx8bDGAMyX3wWab2ZddTQ72SJsHZWhNdfUDivr8OQXaNfhKlAzidwW8j6nwepdER3ueayMhmZFJA6bkAdkpKyKMa7LXlTTlRdBqJe0siiNk5WWsecwqRIRABg+h2RAnyMAX3rMzLhlU5Ajtr/PGyvImZARDBXgfPCrUXFYh50aYPy4QEXc/qs9tR/Y9rEmLeJG8/IvrLBNeEN+I6MqQ9cRJejhl1uDoOfUaLbSkfNUuO5nf9RkGmu8MyUeTvYnqa59TRbg9DDTqM4I+YRe+Yef5ygs+1U1EyTgp9z+y0sQOF4BRaNVftDTQmePwLlaBI3Q2EdUy0oZNYJ71+cflFLEj4lBteVSEWqeDVRxP8R5vNDYIulOvgsxq+SkHtjlrtHfC6+zupjXGzsmj5MTi3zNf/K8Frb/M/DnXUoTse3phqrslNiVMkA32kFtCaq6k7+k+8BzB9Ripf+Npj9XiDvCKimeiSbza3KWN0g5PsvmpLZSKcoge5d4Eyi5Fo00Cx3hQV+HNN/QxSLrFdCMO672qdEhScxJF/DKE1KgkaXeFTXYwVbcxhUcLvwLzNb8SXt45tivW7Dk3S3sycoHIEoensJ15C1iCX/oZ9qa2J5V76bbbIVg9bNmvVTnrAi2X12Yy/G+4Z75Dz8Ik6419D2ocnrSUQJlU+lYo7qgDvo1UAXDqWUeGlviDHQCVzSxVYf5uumZ1sTDBx6w0Y8zy88xmLC1YWN900JxNjXARyXOxqyFxVrabfvd078A4GvK0PR11P966b+dNQDUHgeNk5Qxk5kc6OVxTljarbzFwMQTJO4a/exUGS1hTH87VstLsvqtKBFATxpuF7N7xV7/LJ09gNR4vaH/buAOPuDMy7/3CuKVOvE+qznRQtJZ2sQTxsakZkxJo2LZBOq/RTWUynB7Af0izf316yb
 oHtwFqNs
 NY3VSKl/tipfUAsXSTFa4ZJYBuogQCiftmyQtkkvVhYWTNK/q5HYZb8+Ra8NmSKiMdmw1smeTac2HFsblznknOInxYPa3WDD95yZAskVjvRDAEEobTIzgL7OlNhtBhkj2pVAUcfHHtjW+Feh7hsGjbZkM9SdJZ0xSX4toZ76EhOTvvino2fhnEznrs3XanJS1Qr9YpsUKgSYXLnvijDBQsvuZX7fwmUN8AD4aqU1R7ctY5xxWbOiD5m3SMKJ2oko8aZJ0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 10:34:37AM +0100, Christoph Hellwig wrote:
> -/**
> - * blk_crypto_fallback_bio_prep - Prepare a bio to use fallback en/decryption
> - *
> - * @bio_ptr: pointer to the bio to prepare
> - *
> - * If bio is doing a WRITE operation, this splits the bio into two parts if it's
> - * too big (see blk_crypto_fallback_split_bio_if_needed()). It then allocates a
> - * bounce bio for the first part, encrypts it, and updates bio_ptr to point to
> - * the bounce bio.
> - *
> - * For a READ operation, we mark the bio for decryption by using bi_private and
> - * bi_end_io.
> - *
> - * In either case, this function will make the bio look like a regular bio (i.e.
> - * as if no encryption context was ever specified) for the purposes of the rest
> - * of the stack except for blk-integrity (blk-integrity and blk-crypto are not
> - * currently supported together).
> - *
> - * Return: true on success. Sets bio->bi_status and returns false on error.
> +/*
> + * bio READ case: Set up a f_ctx in the bio's bi_private and set the bi_end_io
> + * appropriately to trigger decryption when the bio is ended.
>   */
> -bool blk_crypto_fallback_bio_prep(struct bio **bio_ptr)
> +bool blk_crypto_fallback_prep_decrypt_bio(struct bio *bio)

This omits some important details.  Maybe:

/*
 * bio READ case: Set up a fallback crypt context in the bio's bi_private, clear
 * the bio's original crypt context, and set bi_end_io appropriately to trigger
 * decryption when the bio is ended.  Returns true if bio submission should
 * continue, or false if aborted with bio_endio already called.
 */

> -/**
> - * __blk_crypto_bio_prep - Prepare bio for inline encryption
> - *
> - * @bio_ptr: pointer to original bio pointer
> - *
> - * If the bio crypt context provided for the bio is supported by the underlying
> - * device's inline encryption hardware, do nothing.
> - *
> - * Otherwise, try to perform en/decryption for this bio by falling back to the
> - * kernel crypto API. When the crypto API fallback is used for encryption,
> - * blk-crypto may choose to split the bio into 2 - the first one that will
> - * continue to be processed and the second one that will be resubmitted via
> - * submit_bio_noacct. A bounce bio will be allocated to encrypt the contents
> - * of the aforementioned "first one", and *bio_ptr will be updated to this
> - * bounce bio.
> - *
> - * Caller must ensure bio has bio_crypt_ctx.
> - *
> - * Return: true on success; false on error (and bio->bi_status will be set
> - *	   appropriately, and bio_endio() will have been called so bio
> - *	   submission should abort).
> - */
> -bool __blk_crypto_bio_prep(struct bio **bio_ptr)
> +bool __blk_crypto_submit_bio(struct bio *bio)

Similarly, this could at least use a comment about what the return value
means.  It's true if the caller should continue with submission, or
false if blk-crypto took ownership of the bio (either by completing the
bio right away or by arranging for it to be completed later).

- Eric

