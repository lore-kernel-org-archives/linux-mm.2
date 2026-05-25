Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B97ECD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 06:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A5E96B0093; Mon, 25 May 2026 02:06:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D5F6B0095; Mon, 25 May 2026 02:06:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B9C96B0096; Mon, 25 May 2026 02:06:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0871A6B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:06:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 95F3D1C1E8F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:06:29 +0000 (UTC)
X-FDA: 84804907698.20.BB22842
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id CC926140006
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:06:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=UnVWwF+l;
	spf=none (imf23.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779689188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=986yaGrKoJSOJhdlfpUSauWqpRksnsFf/VS0QhNcKHk=;
	b=IJVU2qP1xjGw8yR1nv2M9MLMKRqNoCazCkHZkiB4AF1lZ+g0B8ozruzdcPU3b5JmHIIrJ7
	5Iv1CUHATEfykgYpexpWQtSO2wHxvMjAZBnRlt5vmS6fKuhAKlxjybyabh58orQCftEf4i
	5LXcPINKY1fORCUUl6xBmU6xHqhZbRs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=UnVWwF+l;
	spf=none (imf23.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779689188; a=rsa-sha256;
	cv=none;
	b=PhNMjqIrWJIJVSBbbf2YWop1tMrdix1IMO3q0Ia+ydvoT6SPXeuBvNF1DgLLlybdCVzvBF
	hXy6K169ysB220ssjIf0XFN/M5pOZZMWSMJD2NrZSO2nj1Y4Lf0w/PpwDbUmRsP7cMQEYO
	SuBj56sJQ3pGPJZ7QF7ABYp6v4v6l3o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=986yaGrKoJSOJhdlfpUSauWqpRksnsFf/VS0QhNcKHk=; b=UnVWwF+l8iuhC/sPfP0CfMEYA1
	L4l7nNP/OKmuR+fWUIaFrGmQcCGlC012IWTFMMdkNwUpX4VL1d5wy4ChhYsV+B26mLd5szFH148cG
	pSfpEZHaH4BaeBnujdXMTk8KrywUoPc1Ar8+zdlp3gvbdW2BZ/wO/oLBrTdyCsJWLqKb+slRiFYhF
	S64MODfMQP3Qe9FsJPvVVoc80V0SC2Z1uOcu/kAM95dPNL15SAxo/YZQVcRtNGJ7CH8l1vejoXVuX
	sy5h2DhsfaM62ooZAUaBqCu53lQakPVca6mBMVlPO+zDFGuXS4zbR7FoSmc1+c8qtpyamIg0ors8X
	GlfNjeKw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wROSI-0000000GNoL-39ro;
	Mon, 25 May 2026 06:06:26 +0000
Date: Sun, 24 May 2026 23:06:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-mm@kvack.org, Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] block: Add bvec_folio()
Message-ID: <ahPm4h2gKgyEEuvV@infradead.org>
References: <20260522182122.2489391-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522182122.2489391-1-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CC926140006
X-Stat-Signature: pgzbbci3km7rf69pn1ptigcsacfrrh4x
X-HE-Tag: 1779689187-263156
X-HE-Meta: U2FsdGVkX19Q+euGeC14EkkoCxPVO0i2VeJCmEFIsRkXBL2aaE9LJ5W6E8z5EC3F1mcRhcYAoBIWnvnwzbd5MVUiBKT6r4SmzwGLh+xaALZnr2SppCYoh3zqAvAPqD5Vm+T/LPi9Xl1CavWPHHUfoCDRjTTuoS/0g5DBKsIzXDq2lEWYSwPosZWrC0pNHpVhQBFlH1KjTLWIoDRNhi+hb4uY0xnsRchHTPPqPl1GMqPOLeA2Q3FocASiqWxeI4uzaYLFV+vRw8EX9+s9h0eQPASKhFOoI3fh00kkR+htyb39bZEURAjSoDeWdtZtRGIeXAkIjr3z8CVy2OHsrpA0ReJ2ATkJr/Vbtef0bnGoyrZ23YJBWDmO6hbHE+5CPOcJFGi9kO2VHpQJ96DJeK/Pvqv2nzsTg9W85kuOUao+10TDcbzoyU1Cw04YKSXI7CwtKl9AwxfKR0FaMMlEg5TTnMALbr+OMQyS0b8qCg9Z2M3gdYMby2whlqsPb163LOwnfFS3clD6Fu1JzSs5K59fzRKx/k+pHMqJRaYIvELjcCMBtvG3QyyZOWZ1EUSLyaFLR2c4y4DTwDaSiz7rbuGV+itMYEH4scvgV5KTs6zuvkyWsLb4YfdUF1RjaLSvOA0ZNTPrxwXtjJ+2jayw7pRXiMD3cvgCWSzWkoTi2bnL24YqCMYlqIeyO86l3QmE6yUUZRLlLOqX5dLhS0Ois+UKY2YisqPzrazwANWqa3WBIctI6t0gdEFPXGiAmiYdZh4Wn5gKrUq7Pplyt3oqrCwFqpuCMbHOxU/WyGCoCEuBTcxCL27Dw20lgeo4iXmO/b1XgAjyGQx8Il6tcQjQ7z0qLgHEUK4184mXpuHr2bVpDu01htR8l+6+rYv+O7O8TLlvddRZH/TCPP8gSPC7WMUPjyO73QMF7rkaJI7dixD/Rk9kfEs3NpGSuq1BW3J7CAFfcUqgY0j+u+XCcn5WDdt
 +8LN1shB
 W3Eua6j3pOLp2Lk4+YDLFC1pWvFQtjpSk7MaNhBlrHuZswEmXwANq10ClLEUEiA98i5zxvph0BGDiIsN1/YgUlAHcrRgN2Zkf2sQwuu36r45HVonDyRsSa7yi6kkwwyi48SdntpGPaWAx55gZQ/pdu9azcAzcEWEM8D+MWvljL857tpgNnduGepoQw02XcMFWzumjr2FHcOezFy8rxuRmb0DV2p22KnVJK34RCiufc1avrx0a6cNYjYDbqag6uoAf9tWutC0HDXtvgtuHDGxRt1PdyTCU2LvEF6Qxysc2bHBTpu5EEaELaMVO6qYsayySyDjVNstFbkNcsmsHS38pR13PO2yH/Fgw+itSfFIjdzRXfNxT/SGbKemhBhza3KA29MQNEcP0qyGuyC576pP5XNhrKA+wiyR0ufodHZim2JL+xzwsqo0tqfBs5ZVA0uGVdkK4V7UmWE01t8Ja0gzvV8qMcoOAozQ5tA+6qqDNaRyV+5U4mZ83PCKssjiaAWUDnWsr8uY862JN4zeMftAOikfaqB+NpuXw2VJyM8uAVHgu29j7/xe7wp5lUy/7HwYq1WBz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +/**
> + * bvec_folio - Return the first folio referenced by this bvec
> + * @bv: bvec to access
> + *
> + * bvecs can span multiple folios.  Unless you know that this
> + * bvec does not, you may be better off using something like
> + * bio_for_each_folio_all() which iterates over all folios.
> + */
> +static inline struct folio *bvec_folio(const struct bio_vec *bv)
> +{
> +	return page_folio(bv->bv_page);
> +}

The comment here is confusing.  bio_for_each_folio_all is a helper that
only works in the submitter side, and not for anything using the
bvec_iter required for drivers or anything else sitting below a
potential bio clone/split or using bvecs from an upper layer (like
ITER_BVEC direct I/O).  Additionally bv_page can be a different
page than the fist page due to large bv_offset on split bios.

So I'm not against the function per se, but the documentation must
explain the minefields it is stepping into a bit better.


