Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E855CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 04:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F7618E0006; Thu,  6 Nov 2025 23:43:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CF418E0002; Thu,  6 Nov 2025 23:43:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80BE48E0006; Thu,  6 Nov 2025 23:43:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD9B8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 23:43:57 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F13D088475
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 04:43:56 +0000 (UTC)
X-FDA: 84082568472.13.0F7862D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 73C6A40005
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 04:43:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fiIRMAXA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762490635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bk/XkyWuPutaISN8KsDCkvvTmoPOfzs4yGZqbVvQFNI=;
	b=o6GwvgsMYwzXWRC41YpkCyrMzKss0sI6mN4aqa/m2uQKIY4tB5hSd6AGneJ5tsWXk/iXQ+
	cXiriKqrVVUKUtiR/lvDZ5mmcgljEgHq/H0GN13IWDU4ocOmcwL/h9mnZL5TJZ3u5jQsdq
	sV9X8IsfQXq2SNkyC5OTXljOsFIGE0I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762490635; a=rsa-sha256;
	cv=none;
	b=dS8AILgm1NLqBL2CE2ALez4jSjoZUWhMd/Spl0o/tVdiIEFv35wZ9q1eE8lApwXWIIzSsE
	SloOeLKB2ou/u4VIXlarSD6KM8UIzPAB1GTV2MS/Ks1p7bpL4jHdCOI483o6ZySmwUQdXb
	ZsqaNMQY+bkLxCbdl7xMqms65NPiLYY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fiIRMAXA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B319660229;
	Fri,  7 Nov 2025 04:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F145C4CEF5;
	Fri,  7 Nov 2025 04:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762490634;
	bh=48FJJQWCuZyY3WICX2hMykSPN/WEL8zhwGPI/xLv9B4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fiIRMAXAvqw6pJKQ2vhbLQ4u1cx2Pn2MW+mXefXZoqHYT60ATo9zx1lwht6WzqWey
	 a6ElQq4pQmDSvrK8l7DHBcSmgGuUbsvhBaOM8TYqXnXhmuGg3oiPIzFBW9YQ2MnMMK
	 1KMoXNSjjJEoiHo92g2ZjFejMm/2E4GLOJnC5106DNdIpjjZgB9+p0HNs3gLdIPNCV
	 /Ry6f6QtwCbsyYCA9p97Z6DMtBR3qlzplgyFZa9NOV40yRtbEWCk/2AmvHLMhWPXfW
	 ciLTSJtvevAq8S0gqy2Z+HUWfFIveOemVYTUr08UNMCucCtt2y0rn735qRb+z9mm1E
	 y6VE0ioo4c3rw==
Date: Thu, 6 Nov 2025 20:42:13 -0800
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
Message-ID: <20251107044213.GE47797@sol>
References: <20251031093517.1603379-1-hch@lst.de>
 <20251031093517.1603379-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031093517.1603379-8-hch@lst.de>
X-Stat-Signature: mc8fp6gtxpfzbzezkonsc3ha5gmkfwyj
X-Rspam-User: 
X-Rspamd-Queue-Id: 73C6A40005
X-Rspamd-Server: rspam10
X-HE-Tag: 1762490635-870738
X-HE-Meta: U2FsdGVkX1/GJBAFt4WgIvbZtTQewKbN/zJnUdtlLvJ2hHFjOXE71MNmntY8jmTyqorPteGp122REqrzQAouKhXhNVhmjyHkazushC+QGnGUUKjoBMhtb4VJp23tNp3lKxXxaJYnjL7O+mYud4ZGcG1qZMPyJwxsuwDkp4hwR+CQwoqk9MnXd78eVjICK+J12G8eiNid7Boi9X7wqesJp2+cyXtZgFH6A+RoD1RZfOGYjf98GIlYgq78MDk+rHYqpN/8gP3tBgpLW5Cb6Z7MaLlQp5Fpbq92YHUUEj8sBKedC6vf6Uqfz4DaeG3j7FBCNjX5nWR1b2rIRNyriOM59HRb4THnf2azZ5bEUddJWu6ARyVJuwrbVey6F/D7gfosmWqI9F5ClrkM3lJDlJv8hXt2FYDhavi2mbu7khbfAQyQdyDGEil+lBEuQwWmMMQ2FqQDHS0GJRihCerMytyFscvW8oicYdp0wQqTnmv0tSVxHsuWXPMCv8hdsorQq3flz40NNiMPrQRbKY3IGLZiCMU4+4ypx5Z79dpfJef4b6DCqBhLzI4/UiPlXBuvOASx3569DQfMldwHhHN5RY25XiDWZilANrmVWKtqtQIN7+lfcro1QjNzmDgwNpyhXBSOl/0Kxl4kFmFF0WYo4Et0T/k8OHow7iFO0F2mtMU+cYOueyomCZDikMJMIcWBg/hLXXpmhzHzPr12rUW4e0LZezzBFWO67++rfRcRTR0tOLGAQD6P5wLz4nKj6jm12SLIbSGsx/jRusmgze9kBo97/suHpUf71xJHcMwJI7H003qNt8q/ygO2/Fsx9qRV3xTd0t1pzIwHOZlCN1NlqA+EkhBF4/IhepIUKOS/oHFrk+8oPN8dI5PMnQfMaBsDkZ2SYvSoDRMJlo3dWC7rCFgN3Ou9b2jR/wYFPECMJg8PANM2h0yH/46c0mT3XIPYKgtq+4IfKSv+wl86FnydG3/
 naalJKw1
 UWWKm/EhZgChhpJymG55zuy7urNrWlmBGozYgkF7wmNVwL7LsdF0ycpjsxd3r/5r1/aiVym71lcDd3ZFsFhvUuhNw0ET40Jna+7Asdw1YdQyBNJaVHTKKm1wx2FbTsJ3jQGkuiP5OZR1hUOGjPLYxVG28rHDR0hXDb8L6bm+/K5tciOmlOKKIlLtAb+HGQcT37xOsFhOcI0WeDci71A5OJtHAckUPtZoFIA5w3HOf6JpA6Mgg7LnzOoRHn0OOlWG6gtHc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 10:34:37AM +0100, Christoph Hellwig wrote:
> diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
> index 58b0c5254a67..ffe815c09696 100644
> --- a/include/linux/blk-crypto.h
> +++ b/include/linux/blk-crypto.h
> @@ -171,6 +171,22 @@ static inline bool bio_has_crypt_ctx(struct bio *bio)
>  
>  #endif /* CONFIG_BLK_INLINE_ENCRYPTION */
>  
> +bool __blk_crypto_submit_bio(struct bio *bio);
> +
> +/**
> + * blk_crypto_submit_bio - Submit a bio using inline encryption
> + * @bio: bio to submit
> + *
> + * If the bio crypt context attached to @bio is supported by the underlying
> + * device's inline encryption hardware, just submit @bio.  Otherwise, try to
> + * perform en/decryption for this bio by falling back to the kernel crypto API.
> + */
> +static inline void blk_crypto_submit_bio(struct bio *bio)
> +{
> +	if (!bio_has_crypt_ctx(bio) || __blk_crypto_submit_bio(bio))
> +		submit_bio(bio);
> +}

So, the new model is that if you have a bio that might have a
bio_crypt_ctx, you always have to use blk_crypto_submit_bio() instead of
submit_bio()?

It looks like usually yes, but not always, because submit_bio() still
works with hardware inline encryption.  However, it also skips the
bio_crypt_check_alignment() check that was done before; now it happens
only in __blk_crypto_submit_bio().  So that creates an ambiguity about
whether that usage is allowed (if, hypothetically, a caller doesn't need
blk-crypto-fallback support).

Maybe the alignment check should be done both in submit_bio_noacct()
after verifying blk_crypto_config_supported_natively(), and in
__blk_crypto_submit_bio() after deciding to use the fallback?  Those
cases are exclusive, so the check would still happen just once per bio.

Either way, the kerneldoc needs to be improved to accurately document
what blk_crypto_submit_bio() does, when it should be called, and how it
differs from submit_bio().  This also deserves a mention in the "API
presented to users of the block layer" section of
Documentation/block/inline-encryption.rst.

(I'll take a closer look at this patch later.  It will take a bit more
time to go through the blk-crypto-fallback implementation.)

- Eric

