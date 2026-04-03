Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F800D6AB1B
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 00:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87AF96B0005; Thu,  2 Apr 2026 20:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82BEC6B0089; Thu,  2 Apr 2026 20:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 741C16B008A; Thu,  2 Apr 2026 20:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 612BC6B0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 20:17:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 998EE1401CE
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 00:17:02 +0000 (UTC)
X-FDA: 84615329484.29.3FC7381
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 02DD3C0008
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 00:17:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ELVrL166;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775175421; a=rsa-sha256;
	cv=none;
	b=C+GRnrxLxg0bv9R/SjYm3JGVLaebbxn7oZ6QEicYCO4yKFENH+0NKuRv49Z9x1Q2jI0HH3
	KRxa5l1gOQrFpB5ZXG0z72YJMICOGNBs92udAVjvyjULIgjoxzWI9is5udbmakoKXX8eFi
	IKTOx9xgZynnRvZENJpqTyt3fSWyKz0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ELVrL166;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775175421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/k+UW+KcNpXrUvxHRMECXLW5E6ljNh2I/FB3F3JcE88=;
	b=sGtvd2jfAe5ry4jHuBWRSTdibJFutYshCQbLpI8SOFfG1oumLxdfqx03HIA2sYmgu3m+3X
	4S9E0hHYB8NI4e+Yf0BtKBzjyTTk54skJxv1SfJ5XeynIoa7BIED7o3ZphBhc1ykoY7f8H
	bYBODXxo5+KEONLMVmTUVO9MPHqvY2E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B6CE60121;
	Fri,  3 Apr 2026 00:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767C8C19423;
	Fri,  3 Apr 2026 00:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775175419;
	bh=G6deAPR3LX44+jdQ75wNRcyM0FcG1HTaX0DBHFp77B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELVrL166n9hqhE3T/Pu9JB47LFzgNwWbtM+heqapekFShmlxAhZDkFKYf0uQEd0GD
	 GY/OaKlRXMY/ncvggFCAio7fkpQrriF2IPx+sXyFLPDFXxRSp/6FzEKAKubJ9RxGN8
	 a5KVmtcc67tgBN6mx+gJ1I6nAhANxl96GkpU7ImxSX+kHb+PuQBi9hytRWRysT72Wn
	 qCxCHOTl6NQKxm/4dSVL2OefVZgcdAymeEef9/iCZow+QjT11DlLg807UBtDoEmgBQ
	 QNtdkilNaCBs3c+Rl6mzwedevJ5cAuWRam2n9IxW9kwo/SyvnPnj7jmAaj00vaOQXI
	 rQqUe6tAQTsnw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH 1/3] mm/damon/ops-common: optimize damon_hot_score() using ilog2()
Date: Thu,  2 Apr 2026 17:16:57 -0700
Message-ID: <20260403001658.46229-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260402155733.77050-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ib5tfmrkxxiigegchfey9zoz9kpuit1f
X-Rspamd-Queue-Id: 02DD3C0008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775175420-123377
X-HE-Meta: U2FsdGVkX19gVua8MWzo5Ho3js+uWIqFl6sdgvkntlCgJJ/tU1uFF2PSBvMz20DlwVEuqQ8UC97UomqwxIka1SC111uwGc3ioECTUvazrqtDFrB1do+pdH4+0TCTP4Jf6vteB+sB6v8n2ULjvTNtkDKkakGNi+hQMxryyOsvXtd8FcfA8IB2k9ci0f53PtMBcQQJbFYkOxl+w90y/zwLfXdA42dK+2xO7tuViQOqKFV6kl4p/Um3stpKtlXVSuf/IhwqN710VuIwssfvqIpFn2OQzdTewhQ5nSdHrHdqKFP84n1To+7WYWWp63Q8M6A1pmNBD7O6dM8j0CXG1VDqcu9/XyR9Ci7gfz/WjruvjegRRFjneibJCTZ7TBK3Nvfon3lyPk20ITI7aV8oSC/kN/2d7qDUmA8Sdnk61VKbchfijdJsApDnIrxpTD0rc1wCG0SCRoukEf800GvtmVIM1KgXB5GkSHHsUFuaPUj3OT2lRKsFJedxZ2fF8A/s+pkJEcaeObJsoQDdktB+VXtg2Tq8qyFCijMSoQiTAX3/aAvLtzhOSO+uRd+NTQHm0kZcI/GBcsa0smqo+7xNmtuN4GSnPIDtgxUX5x7+2X6k4zDMh3QNW0t+p21RkVAhv6zw4N3rm2QpX1bVL0tjX3g3uWGC7RWBzwNWjSyKeRy2SqY2KedPUnahBhoBHl3oARvedKW6O5MyQwYn7TdpcpWFymQhWeh/K47o8XfsYn2ZxOaiFo2SX1uejkT3bwktWKBwuP578/t18zkyW4jtleLcd7TjwwN8/uOc/W2p1jdrnsskSzYs2x1ViRcTwLZSlKrSQQC28poO1YhtqjbLPCs8Uo6Fp7giPfcW2bJs4n6zV75nkyMBvU4KQpR+8FofTqDoI7BAQF3Cnblku4+9cms1dTna99rngtW+i2iF+OhHFV0qB2MGNJ/1B5py3xv887ILaDhF3jMEwIocTtWR6U1
 LrzfMTsE
 cvhjtNBaza7F9NTBrRSRLvmBFCgkmuww4QqF2F1c1BNgLezYkC8ypGst7ZRPW952ELT0B5I19yeV1052AUgG/OJxkOJmg3JOFIMMk3mHwzQU0WYgAwcAeH+S7KAu6rJyM4eCcAjTaoioMbrcEsS0SDrHcilMw0+5YfNPoRR0XmJ5icDbPIuppZu7qiLR/jhftBncrlVS2umRYgSBwQE8WKUggLkXFmp1ehp/YXO4xvvmiLkNN8GWr2HJm+5FmlOmRFSlF/l64te4UC54NQ5msegZyofUb37dznm1x5Hv7zP7Ed8UFZGLNL30LgLPP/cfz49kl9/D9TtTkKIxohEinaqS9ppBNLURsO9WT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: sashiko didn't find a blocker for this patch.

Forwarding Sashiko review in a review format with my inline comment, for
sharing more details of my view and doing more discussions via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260402155733.77050-2-sj@kernel.org
> # start of sashiko.dev inline review
> commit 3d1d9600685998aeba66926091d5a11897567bd0
> Author: Liew Rui Yan <aethernet65535@gmail.com>
> 
> mm/damon/ops-common: optimize damon_hot_score() using ilog2()
> 
> This commit replaces a manual for-loop with an ilog2() based calculation
> to optimize the derivation of age_in_log in damon_hot_score(), improving
> latency during performance tests.
> 
> > diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> > --- a/mm/damon/ops-common.c
> > +++ b/mm/damon/ops-common.c
> [ ... ]
> > @@ -117,9 +117,12 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
> >  		damon_max_nr_accesses(&c->attrs);
> >  
> >  	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
> > -	for (age_in_log = 0; age_in_log < DAMON_MAX_AGE_IN_LOG && age_in_sec;
> > -			age_in_log++, age_in_sec >>= 1)
> > -		;
> > +	if (age_in_sec)
> > +		age_in_log = min_t(int, ilog2(age_in_sec) + 1,
> > +				DAMON_MAX_AGE_IN_LOG);
> > +	else
> > +		age_in_log = 0;
> 
> This isn't a bug, but could this logic be simplified and the branch avoided
> by using fls() instead of ilog2()?
> 
> For non-constant variable arguments, ilog2(x) internally resolves to
> fls(x) - 1. By evaluating ilog2(age_in_sec) + 1, this code essentially
> calculates fls(age_in_sec) - 1 + 1.
> 
> Since fls() natively returns 0 when the input is 0, using fls(age_in_sec)
> directly would remove the need for the conditional branch entirely and
> reduce the block to a single expression.

We decided to use ilog2() since it makes the code easier to read in my taste.
So, this is not a blocker for this patch.

> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260402155733.77050-2-sj@kernel.org


Thanks,
SJ

[...]

