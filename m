Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2589CD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 05:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1AEA6B0093; Mon, 25 May 2026 01:17:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF28F6B0095; Mon, 25 May 2026 01:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2FCD6B0096; Mon, 25 May 2026 01:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C165B6B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 01:17:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 73AE7161120
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:17:41 +0000 (UTC)
X-FDA: 84804784722.20.8986967
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id C8E6720009
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:17:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=GLm05S0P;
	spf=none (imf13.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779686259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WGFWPzw6+sfQbAaiqeC7ZcWGmRnj56UaqVBKUeVEioE=;
	b=Ks1Ig3NswTVchR9dWgFCwsNLcR3aeIn+I6HnU7N3ItcisvTOsTdGm5fi6MiHoZTvLtPP/q
	e+283OIBJU2NINFdxdqQOqt2gZZ9d+hL9s0CoOJUSbbSXFkxZOK/2utwsUmknAI/GGNj68
	wo8R7iRd8j3rMmOnmPvEXO0wLv5rYqM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779686259; a=rsa-sha256;
	cv=none;
	b=d2XFyKQm1tjspqMKNvXVRK3JmcFKnL/gVaOx70Dh2fszFHADRXRSZt8Tv3ApPcIDUluWys
	GG4mCJazU11dGFbjyjCr864SZqxgiIJ5244F+VCwU5QVT7tLwiNPx1wYiSnFokPGlXPKdy
	r08jOG1VtDuTmAUkD/4GWNpNZgzFhMA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=GLm05S0P;
	spf=none (imf13.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WGFWPzw6+sfQbAaiqeC7ZcWGmRnj56UaqVBKUeVEioE=; b=GLm05S0PC4mGsmC79PM1H00V2a
	bZDM/XiGMekJuKe97X9xAfLAxDV/rMnkNBSDLgOZ3/ylKMgBZdwvLnffl2mFwdPae5Q+832q8eqiB
	BSRO5uuokBeK+XKYCbNp2TAradZX7/IYOlyE2dUKOSNqab98xY6Qdaud8IsLYU27ATb/gdS6t78Bu
	tCIHrhr/FJoo0DS5knx1zdVXph3SrOTV2LEGGQrLXgMbCMJFJKwVz1EnNw+cWVNuw/i6fzUb4u8d4
	tUUzJS7eFimHgrCaY6/KE+eBembed6MlM4geLu5MhUeKky4EYQEtS8jSmHMbMFXhxsTUE5249dP2i
	niEzrsPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRNgv-0000000GJGp-3yPC;
	Mon, 25 May 2026 05:17:29 +0000
Date: Sun, 24 May 2026 22:17:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
Message-ID: <ahPbaSEoNA755Nt3@infradead.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
 <agq2KRd8RkP1TAf5@infradead.org>
 <ea1fa305-3ba2-4cfd-b7cb-86875032a300@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea1fa305-3ba2-4cfd-b7cb-86875032a300@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: C8E6720009
X-Stat-Signature: agq9p1bsoza1fks8x4pm9hpc579zqpmr
X-Rspamd-Server: rspam06
X-HE-Tag: 1779686258-123008
X-HE-Meta: U2FsdGVkX18RYymwB7ZMC6dheUqO45xN0iI5fNfXMbfYMinlbO4vxwdLHfe6hhU5dEKjWl1MPhPsPEvNKejcgei3I5wZHzO6tXxJCPv8PUDIWMCnWLZVdtK7cPO5mOrWifGkJ+k2DwQwZ7ZTCqukoF0DpX6fi8Mum/Rzfy4zLQ+OatfvW6DyLiQvy55g+B12YuF0Q/tzcNmmCUFCoQdX2P5YyDzfjaBWtYg2G7g7bzaoTCZdbzTFp8mAOG/pauz2O7iiZ+lHqfP6dCq6tMsJCgrImQP4bbElA7JyNYN5upxFCHOC0Bxwhavnaz3O/LzuJUMaNl35VR6JBYlf616xTHmkWTY4ptvrL86woHuNsq4dJauI2HUAVCEraFk8wxF6VuPVAleNQBWNXiZ3VDcA0zyjLLmt9QWZ2O4IqzOgkKSFcduWroQ3dpNY2Tqv3GsaP7qqvsB1GM9660ml+FJ74RA+t6ytnXmW0iBg3qQKpGqZNpE7L/EKNjbdpFOMWqSoLriNWpCeFmCbHZiYN1dqiDv8qXfZP3fpCG/41Uo7iOY2Ieqr7CZRjpe4AResgwxnikv+HxVDt5x/ZNghcXF1Hj2TZxLEJwryI7SHW4nqr/zXO2d9jOtfzoZiRe9t59gRaaCO2L1HTqLgUsm0BLvAvxg1T50QjlcCvA2KjvVAsxamfdf3JwygX1hYGmmGWRPDmRz84UplN7NDW0i3Dg8ARkxk79U3VOO3u21087hIJ1T9uXL8pVxoLxlomkaPKPAK7nt6twAPggGS5VGy7ubxzbEv1JJcMjq14a0Vd6t6VolHh7pGtlBrLGHwovk3AFgC/xGNwZiP9+ElqQ27iRIl5Re9UiIMqmsEqY404c7WeKEfAJN8oRV2jkrWXb+6MmNyVlEGXLWhHonIklNCNKNBVQbAQPM/1+vWRwYbf3rLREY8rJU9eXnvrvYGcmISd9wUSXJgV+ztNjY4rxBnWrq
 lGV24aYr
 FYY53ZTNkkS48R4Jm93rgwqgT4ojhnljzlPCZI1MRDLfcl9pml45SIfslxobKnWeHgXxb8frSY1avvieLb7BCem5zOlpRtVYfe5GvggQWCQV9WlH+D/dZ8ukDEzsx4yilW0cVzjle6P/XmRthrk8NlgSZv+h2JQZGVkQeuc16OMbFVZ2j3ga0wMWmif1lXQj/fEaGoG4NfBdKD1URWqedqSTSGRSIxdEdmuje2M8GuL+Bwc1yPuDnvQlKUhwc1sMHVu6rxDrJaC4Mp2hj4fDWxpZnV36g5siWKBgGUZHbaMQcGVipK2jdV4mPTXZ4uBdj51f8VBCZxwF7Rh3ZeqFB6D9aXNDPSnqqG89QsrfGPmh0sR16y4lMSeBSj98d8kKEl9Fy5gZR7/P2fKywG14uPRVckzTHaTzz/w+4vjt96styNR0OEEyUZD6u9TNnldEzTE+Nq2qHdhS9brby2h/8rrNZ5jrJKr8jKU26+erKFL0ruhTHbOOWzQGRJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 06:47:43PM -0400, Tal Zussman wrote:
> > But this 1-jiffie delay also means we unconditionally increase
> > completion latency, which feels like a bad idea.  Do you have any
> > measurements that show where it does benefit?  Note that queing work
> > already often has very measurable latency on it's own.  This also
> > directly contradics the erofs experience that even went to a RT
> > thread to reduce the latency.
> 
> I added this per Dave's feedback on v4, where he noted that XFS inodegc
> uses a delayed work item to avoid context switch storms. There's only a
> delay for the first bio in a batch to complete, as we only delay when the
> list is empty. I'll run some experiments and measure context switches,
> completion latency, etc. to see if this is necessary.

The difference is that XFS inodegc is not latency bound.  Most of the
time no one cares if it is delayed a bit, in the cases where someone
cares we explicitly flush the queues.  I/O completion on the other hand
is something where users very much care about latency.


