Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 003C4F364B8
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 20:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65CD26B0005; Thu,  9 Apr 2026 16:19:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6340B6B0089; Thu,  9 Apr 2026 16:19:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5710B6B008A; Thu,  9 Apr 2026 16:19:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 467C46B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:19:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E56571B703F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:19:11 +0000 (UTC)
X-FDA: 84640131702.09.2BFEB18
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id F366F16000F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:19:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=da5CPd+0;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775765950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uetQL92ALql1aKqdvIjrKtP93zELYzZBGItlkQMM8q0=;
	b=I8x8oVgv+5rhAG1jL9i8XWMIn1+AezipoYE3e/IaBMxQYL3MdI1b60h7+NKG2Va/LZfIAR
	ocjEb3g+X9nobkXtWPtMQ5iQ6ClRUy8mmbyOBN92ItVgifGynGugSV28KmOveU+nj6LqJA
	VQHFZYxElEIpXIqiv1vHZQP9rq/0dak=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775765950; a=rsa-sha256;
	cv=none;
	b=vsAFQMP4Xt2M64P3hivqNZKVgWHtZEHdBe0MtTgCRtw1v1Psk0QVvwUkDmmjJ6KgYZYLxw
	I5phoK0xeaWl3SpPgNPpBb6F48y9NVwY+rchugHatVUg3z3kE1SJiVIc/9MoSZ/PXOhzX1
	JiuqNDyWdLJaZ7q0u2F3SSLpZ86ImFw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=da5CPd+0;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uetQL92ALql1aKqdvIjrKtP93zELYzZBGItlkQMM8q0=; b=da5CPd+0XDSMYqKszRNM05yMDp
	slyFGyXYQ4qS5VvbFKW9pH1T+F7f7qUF5dR6SBorhUUFg4t7CKPAHZbGeWKPtkhLOvgYqkrBGD7Wb
	0Uqn9hq60w5Dgd/eGpnPtMKgcFvpA9S2GF1GnBiFJak3RHWGBKOaeZPzGeQq3bJ4rudY+Z2rBCvA7
	3PfWgPiNHKMs5gOtp/AXMCFTA9OcVofN++n6Cd+D4jorjQnho5xk5dRLWnCQSiaaoibI8aRV1kY3v
	xXU/CmmHVxlH24eA73XP5E4Jg9VO7PodiJ+h+iN2CUnWteCePR8IAnNtI+ZKHkfGajyCf/uF+ZtNm
	eM3pCHCg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAvpy-00000007Vb9-3Sf6;
	Thu, 09 Apr 2026 20:18:50 +0000
Date: Thu, 9 Apr 2026 21:18:50 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/8] FOLD: block: change the defer in task context
 interface to be procedural
Message-ID: <adgJqiA0vivaW7NA@casper.infradead.org>
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409160243.1008358-5-hch@lst.de>
X-Rspamd-Queue-Id: F366F16000F
X-Stat-Signature: aaa9ui6sbh4wegwwrfsden91n7t4b75n
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775765948-427399
X-HE-Meta: U2FsdGVkX1+Qed5w3c9PMRgF95te+I+MeyS/eIWyH5ecJctrqmSzuoS7mBZf7GRK2O+3nZn/A7BjA/nHBYNUglAF0c75D+hFl3Py924qfrbHBTh1krGTRuqWNmctZKqiEhmAh88y5+qZhPim4xP8LSmifChC1vYpw1WS4K0gYYsj3WnSGoTVxPYaImXlokPeYur4+JEClmDhaHIICVLzJjr21HfPyNY2gFpa1IFFxC6FU8vNPUEtxeZJmJATwCY4Hmxe2rwZ0071p4uO0JCoKJoBWtfGFKc8Znkm4OQT7jhl9zDXp11cL1bhAsU9LcYDSyilHZyO9rTl5Ii3hXBRzB45chmlEs1v/uvVkqM5HgJIBLYtMZ7CcKGqMObC/dcx7xRCAid0QF7pY46FbV0jcm/H9SYCK5A2e2uIZ7R5IxHBJVKQv4PtEMeiGmn7BeNPAg5r5NE1IWygsd6pIsxPZF1UOgYY0AiVAS0J78KHw6AgD90jVGvl/9VvrCO5jTXFpWANB1VPAUAbiw8HqnoVZbmIVrUBPEZqSxSoWVH72MsDbPZTVfNDPkDUlIoyBSw8nQFr5rjx4Aw7fKEDmM73LbQIvK80MKmHbRgLwnjC/cyaefJTNVFLfNsL2zbcD4quHs59G8bIaTZRw8wy/IdaVrYtOLUHvRjT1BId3LIcS4ydIbdHpRWENpmzL2S1BtuEmhLAc34yxBjEWMeg8jzZKxUP6T/FLPLLyHV7srkJVSLVTOXVSCAKKkvldKBiCVWNl/ZVlKEviAXI6Xm2vvHSg0RFf4KhGgKeGz1l3eUmc6PZugoPTMzuyMnjMlxUQXfZzZi0zJBDr1y9GO35//B+4pZdB2xGoNq3Z/XqpHuSB0esLrGQX45ucpvheVToMSrwnORSRBHGchI1neOgtVOzUHtf+7I2DFuwUfd2YrYa6WBeQriK74hRFpab8KwvAKGBjBALlTg4OUgjeHXJ2vq
 2Rlcvxc7
 X+7HNXFSX+O14CXIEiWrakRRBoUUXG4B0c0VvAnYGXnuN34L+24VmKLjMqEcwYpPzLfcsX5rGo8qXPuTIEiwzft2Sf44TTurFO3GFzV/nvSoIZ0QgKC5rAvP3/DoHf7vTxiM2UERyD9JdjGUxjZc+pki/shjKycB+piaPoWN/golwUw5CEOCNuKN3DjEdkYjSeoK32b4bPS9Bhr8fgmpAqDBwM7jCcynqTBun9p7eX+ClGiy2anbkxr3LVN3yM/cOCGMD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 06:02:17PM +0200, Christoph Hellwig wrote:
> @@ -1836,9 +1837,7 @@ void bio_endio(struct bio *bio)
>  	}
>  #endif
>  
> -	if (!in_task() && bio_flagged(bio, BIO_COMPLETE_IN_TASK))
> -		bio_queue_completion(bio);
> -	else if (bio->bi_end_io)
> +	if (bio->bi_end_io)
>  		bio->bi_end_io(bio);

What I liked about this before is that we had one central place that
needed to be changed.  This change means that every bi_end_io now needs
to check whether the BIO can be completed in its context.

> +++ b/fs/buffer.c
> @@ -2673,6 +2673,9 @@ static void end_bio_bh_io_sync(struct bio *bio)
>  {
>  	struct buffer_head *bh = bio->bi_private;
>  
> +	if (buffer_dropbehind(bh) && bio_complete_in_task(bio))
> +		return;

I really don't like this.  It assumes there's only one reason to
complete in task context -- whether the buffer belongs to a dropbehind
folio.  I want there to be other reasons.  Why would you introduce the
new BH_dropbehind flag instead of checking BIO_COMPLETE_IN_TASK?

>  	struct iomap_ioend *ioend = iomap_ioend_from_bio(bio);
>  
> +	/* Page cache invalidation cannot be done in irq context. */
> +	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE) {
> +		if (bio_complete_in_task(bio))
> +			return;
> +	}

I thought we agreed to kill off IOMAP_IOEND_DONTCACHE?


