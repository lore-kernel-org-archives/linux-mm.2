Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C08B8606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 15:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PlAfkGF/
Received: by kanga.kvack.org (Postfix)
	id D13536B00EF; Wed,  4 Nov 2026 10:47:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC4186B05B1; Wed,  4 Nov 2026 10:47:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD99B6B05B2; Wed,  4 Nov 2026 10:47:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BFEA6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:47:56 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 260A1A83FE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:47:56 +0000 (UTC)
X-FDA: 85397867352.03.6293394
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 76DDC8000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:47:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PlAfkGF/";
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793807274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=utyyihQu8TN6QRESsH/hf81T3MrNdClL6kRbHxBQQsM=;
	b=JS3A4OshZAoIe4l5hTaZKwWEmDcxV6iBXYzQ1FbSPrYH77B/z/rRO1YbUTLNNMK08qgUX9
	eM9WMECTFqNA74lMvvTw7ts+PFERAGaHnrEf/OFJq5XsYvpNkNSiuKrCNoHmgt6+OxY9P+
	7yQzMWLpbvYzZPzVsCfc2DGpadAf7XY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PlAfkGF/";
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793807274;
	b=w/TFnCu4H841d+T6ZNeeplPZSrdZr2eWXF+zxCGj2oj4nwA3bpaPKgrMrToWI/eB4ns0bW
	bk+LnxNwmuw8aFM14XLuNbb7mwNljlkQ9bKYntKU3Oa5memFTTsuIpRfUVK60wpqP401hL
	fmRb+LPeKN/Nh//Wjuuawcv48CLZPr4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E702D6021D;
	Wed,  4 Nov 2026 15:47:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743B81F000C1;
	Wed,  4 Nov 2026 15:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793807273;
	bh=utyyihQu8TN6QRESsH/hf81T3MrNdClL6kRbHxBQQsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PlAfkGF/BxL9SxJ5WXeUsapSWT8XAwemDgaP8uhuj5rZ8V88IT6OMtRmCK8VxMdsK
	 qVRxEPQ02tahFQsLb/e6YG6jf3cT3JC0mkaODuA1XWfOHOfeUOtTpLZnYYI033j/aX
	 VGJ0KcEtpQnTLhz+wEZr1nD3Ud47QBRUMTBA3CtqGo6H19+7VaGrTOQAbCGd25RDQj
	 fpkW70zoWzdXiZLJEZD6aCy9F+GGFW28YFPrzyVhnH8gdyWGxiRu6yZTvgW2/yPIJL
	 SPkMtZUkWjDai2500OB8XxglIMc6KlfYz+Whu+IFqey+Oc97Zwlf4YNZfuj1aBY14f
	 vAEQ7KpGTYkTw==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 1/4] mm/damon/core: add DAMOS_FILTER_TYPE_AGE_MS
Date: Wed,  4 Nov 2026 07:47:45 -0800
Message-ID: <20261104154746.83311-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-197530@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: scggt6d41egthnpy7wpoxcxskpr6fhzb
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 76DDC8000C
X-HE-Tag: 1793807274-918357
X-HE-Meta: U2FsdGVkX18s4D8HAp5JcMoCOvs29WXrnbvr253zUO5qs95n2ivj5PVIiIaT+XbFYJXuUKuZcJZV0SxZ5CcXMRi9uo9VFQweFpoMSSHT3l/ocCpejOG3da2EUgEeZG/npNfDi1RWu7GKIpMBu9dpsQUytzjSeqSTedttspUL4qfuoLdHF8S939FWs0h77HZ5lYPJMwyza75p/9Wp+7hwCNhPcJvrC5GL3JmQGo1/K+VqA7wZUDjPDyrcjhvkKgiqmNemi+IwhSs0kcuCgrwjm8iPeSu7c790tpDFrsdjCcJRBQZ0BKcm2+bxYazpJQJv+1Eor1qi67mxw7tPeszO62GJuL1z3KkP4JZ+rniUynrmu93Ps/kO2RzJzXiiH313vDRDYrwlojt41SRaax9nR14CASy3DCgwYhC8E5V4oX+ndDznETT0ZMqI6qKsAlsYfFr/EKyOb0rVKGXDJpFaGY24dWQ6D54Jn1kFMXV8qGd2duoElgAa+4aKkFdS1WVjLYxmMRvyNPsc1ScccKLjCtWSAOV6NFsClKFNjJ5swewY764bAEKcTqhWd99h1cPV+3L5xX7ecGxT2G+b+DRczSyi7vR3IVrgw/t29DY8+xEQrgV0q55qM0SAMlK1hYhh7dBJmdqovoXo1fxZWX6MV9O8V24B585QKzNFXxbuCWn6O5Z7YAMzQvwwm9JNxPkB+XmuJG/UGLn4gPb7W2Cx/v5p9UhMJs6v8XzYPNCoHH7KXMMRViV3I69aBSwyO+0hTGiXAH1ZFRPbp22EemsgdHFMrvSnkoELmD/PRz4dU2oWZKVHiv2cz4ViTYEh/qU2oIbg3YX+6GTwYHnwVI3uMgH54KicA8sfVqo6CDUk+GzOciCnGlvfKHb5y7lFQoSh0ROZJEAgtEiVErNZUubJHfzlL8eu6M2aotqbyp/ps+VYVqAsH3whJGe0f+/zTKuA3/nvifLr4hquffOYN/w
 F1BOHl57
 FHS09xdWEMyEgrFhEDA07sEUAKcPOsT4vmSY3UhtEwMPk7f6TgUoNMo8n1sKwCuKdyoX5hD1sYZkpaVQ5GqiON103W4cYTOetFvMFNHBZWvdpMvFmEBpykffgcSmPfMD0f7FYDmdgZ3hl2Gd7/FVMNxTaO0p1wf3wgiVOAHCG+Q7W1CUmObOatJkv936+0qlOGZI5q7auZazJmdomxDOkJMaAnjY7y5N6mHvi9rmRHGvIRFC/M/tDotHE4SSBUOoq1g5vgtnzuFsTE+dYQEd7FvQurJcTWWHKz5++OF+vetLkAv66ogtr+i1UgREJDgaVlzxrOGoq239hOqZby4j9EEaRqkz5XrRc3u4LqTN3zDDF/6AHKu4NkbKnMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 04 Nov 2026 15:44:08 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] mm/damon/core: 32-bit overflow calculating age_ms in damos_filter_match()
> --
> 
> commit 8785e74923668744015c21ff7266b94722501bbc
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: add DAMOS_FILTER_TYPE_AGE_MS
> 
> This commit adds a new DAMOS core filter type, DAMOS_FILTER_TYPE_AGE_MS,
> allowing schemes to filter target regions by age in milliseconds using
> damos_filter->range_min and damos_filter->range_max.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index d36823f4d0928..d631863b034db 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> 
> [ ... ]
> 
> > @@ -2552,7 +2554,7 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
> >  	bool matched = false;
> >  	struct damon_target *ti;
> >  	int target_idx = 0;
> > -	unsigned long start, end, wsum;
> > +	unsigned long start, end, wsum, age_ms;
> >  
> >  	*err = 0;
> >  	switch (filter->type) {
> > @@ -2594,6 +2596,11 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
> >  		matched = filter->range_min <= wsum &&
> >  			wsum <= filter->range_max;
> >  		break;
> > +	case DAMOS_FILTER_TYPE_AGE_MS:
> > +		age_ms = r->age * ctx->attrs.aggr_interval / USEC_PER_MSEC;
> > +		matched = filter->range_min <= age_ms &&
> > +			age_ms <= filter->range_max;
> > +		break;
> 
> [Severity: Medium]
> Can the multiplication r->age * ctx->attrs.aggr_interval in
> damos_filter_match() overflow on 32-bit architectures?
> 
> Since r->age is unsigned int and ctx->attrs.aggr_interval is unsigned long
> (in microseconds), the multiplication is evaluated in 32-bit unsigned long
> on 32-bit platforms before dividing by USEC_PER_MSEC. Once a region's age
> exceeds ULONG_MAX microseconds (about 4,295 seconds, or r->age >= 42,950 at
> the default 100,000 us aggr_interval), the intermediate product wraps around
> and misclassifies old regions with a small age_ms value.
> 
> By comparison, damon_hot_score() in mm/damon/ops-common.c casts r->age to
> u64 and uses div_u64() to avoid this 32-bit overflow:
> 
> 	age_in_sec = div_u64((u64)r->age * c->attrs.aggr_interval,
> 			     USEC_PER_SEC);
> 
> Should damos_filter_match() similarly use div_u64((u64)r->age *
> ctx->attrs.aggr_interval, USEC_PER_MSEC)?

Good finding.  I will do so in the next spin.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261104153645.82945-1-sj@kernel.org?part=1
> 


Thanks,
SJ

