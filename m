Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B84ECCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 14:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B1668E0015; Thu,  6 Nov 2025 09:48:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262588E0002; Thu,  6 Nov 2025 09:48:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19E6E8E0015; Thu,  6 Nov 2025 09:48:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0A37E8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:48:55 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A8D681359C3
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:48:54 +0000 (UTC)
X-FDA: 84080464188.30.8688B87
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf30.hostedemail.com (Postfix) with ESMTP id D288F80016
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:48:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf30.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762440533; a=rsa-sha256;
	cv=none;
	b=evVC552AMGehJ4dmqieu7ftRWXwa+3OS/kzHQTDWSc5IKUmRWaeYNJxm6m62WIa1wk0dlN
	F+Pb5MTh1zpreuPQCosx8lddv4MKZwWwEvxE+IeZXEDUGi+15aLSsE9rns3ezsVqtpFxU/
	F2OkObgzCiC96lALbnwX+RaZkL1GuT8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf30.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762440533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9WsvwP2UxAVEANOsRYuCWUnQptivABPJOh0btu2TUds=;
	b=M9pVpSt6b00scLxT/5Wfp/twrvYMV+nLm4MwZ+6f4BBaWwhlauvIyivJ8j3gufaiJ18oN2
	uyWSPDm9F3F94wOJrvmb0fsW3RQ/6s4Bx0xXmDXGDl79VByMbpZJiaFSpJwZjYOQw4WdoC
	gzf+7jcUGvxWTr7yTP1qXrtHbW9ttIQ=
Received: by verein.lst.de (Postfix, from userid 2407)
	id F02EA227AAE; Thu,  6 Nov 2025 15:48:46 +0100 (CET)
Date: Thu, 6 Nov 2025 15:48:46 +0100
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/9] mempool: add mempool_{alloc,free}_bulk
Message-ID: <20251106144846.GA15119@lst.de>
References: <20251031093517.1603379-1-hch@lst.de> <20251031093517.1603379-4-hch@lst.de> <1fff522d-1987-4dcc-a6a2-4406a22d3ec2@suse.cz> <20251106141306.GA12043@lst.de> <b950d1a9-3686-4adc-ac2d-795b598ff1a5@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b950d1a9-3686-4adc-ac2d-795b598ff1a5@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D288F80016
X-Stat-Signature: x1entoy1zetyhq51q4spkshtu3bzmx77
X-HE-Tag: 1762440532-541168
X-HE-Meta: U2FsdGVkX1/+FygtAfUivvopip1i+UdGFyFZnniY4M94Bly/VCMNhTh9Wj/nUpXYTi/6r9OLacHyBHsGi50dqTTR5amcYpF8WeyNsBuYYZJpcafPn4vnYUvzvmTbGbYEiXWF3ZXYMVjX9wYMNMVcX5Q6ZzhpMQkd5iRVVAdIBnYEXKT9N81jY75rpGk6aGjsiJ+4/SM60h0CrSkjFLAi4m7jTxdTJaZ/orlMs2N4bQr4lpxiU7/pAVC9NCilF28bNNkpmTxWn3Z2ToQZ8qGDx9f6Pg1as31O5OCql4kulR0VIXCsZi4s0U/cz9piFhxGVZc5hOg9IZTpW0mvSPT6Rh4YebpNTVPC4iAR87LbJGrXVpyO3KC0sd+29CxwDUie8Sn1zIXTnBmLcAj3B4Pul7zCDEe4690PKHcgHlNoA/fBCUdBqkVU3c3sgUMjDITJwhRHZQLQJrTcWBkOphh58SGNf7D1Dk5FeaSeB8LwmlXhBzLh6zjR+gJaoLSTBUynMAXUb7j6RyarB4SgtWA4h6ifO7EhROBSKj7tNWariyDMlXTKJ8V7FSpTihdTsKJEAbNaL6eYhat4LP5ghdYo8leLSLTB19XWIoMYyFpdLcF5Osq5L9R56B3Y74VzU0U4l8tZuPJ1Z03Gmxjhk1kjRahZkK4MUmhinkwfoOlFtc9FF2ycdFR60SD1qz2qtNcL/wwrZiYc0cc17BNzXPEPQ+BqxpuYUQ5cwO/DEzk1ZhXThc4sFYb06ruJ3DoIRD+F9bHr/b3fYdVn0tk98zpKJZeNnyn0Mpt7b77Ss7OLbh2AOGArSQTi21WfDSlmPkFMZjGnKocGUQVnAW8uh4dbUvDqC7hfqVksy5udEcpRKYGhDGQvvoNhBunZwvCGgXBux+Ucf/9wJg5GucpZKEqJP9Tu7q/4Vyqi8Qn3av6JXOE3p1Ey/4wr2QVo6jJca6SaNdKdQnK9NkjydjW+6gu
 RAluz/2f
 Ml3X/XRMsoEQt8f+RoAiXW746aC7+ELsaDUNP8hlEZMMBi+vCYHrVSdRA24A1ft22LL6qn1bSGUhLZ6bGXzRgb3NLWR1olJqG+UeTc//o+mIg8zVdchXjAXUEsBa/U9G9wCqnCFFTz29S6HI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 03:27:35PM +0100, Vlastimil Babka wrote:
> >> Would it be enough to do this failure injection attempt once and not in
> >> every iteration?
> > 
> > Well, that would only test failure handling for the first element. Or
> > you mean don't call it again if called once?
> 
> I mean since this is (due to the semantics of mempools) not really causing a
> failure to the caller (unlike the typical failure injection usage), but
> forcing preallocated objecs use, I'm not sure we get much benefit (in terms
> of testing caller's error paths) from the fine grained selection of the
> first element where we inject fail, and failing immediately or never should
> be sufficient.

I guess. OTOH testing multiple failures could be useful?

> > Yes, this looks like broken copy and paste.  The again I'm not even
> > sure who calls into mempool without __GFP_DIRECT_RECLAIM reset, as
> > that's kinda pointless.
> 
> Hm yeah would have to be some special case where something limits how many
> such outstanding allocations can there be, otherwise it's just a cache to
> make success more likely but not guaranteed.

I think the only reason mempool_alloc even allows !__GFP_DIRECT_RECLAIM
is to avoid special casing that in callers that have a non-constant
gfp mask.  So maybe the best thing would be to never actually go to
the pool for them and just give up if alloc_fn fails?

> >> >   * This function only sleeps if the free_fn callback sleeps.
> >> 
> >> This part now only applies to mempool_free() ?
> > 
> > Both mempool_free and mempool_free_bulk.
> 
> But mempool_free_bulk() doesn't use the callback, it's up to the caller to
> free anything the mempool didn't use for its refill.

You're right.  So mempool_free_bulk itself will indeed never sleep and
I'll fix that up.

