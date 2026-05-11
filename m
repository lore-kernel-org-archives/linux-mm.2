Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68D98CD37B2
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 00:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 458A36B0088; Sun, 10 May 2026 20:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 408C56B008A; Sun, 10 May 2026 20:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F1D6B008C; Sun, 10 May 2026 20:35:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 20A716B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 20:35:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 99CBD40533
	for <linux-mm@kvack.org>; Mon, 11 May 2026 00:35:36 +0000 (UTC)
X-FDA: 84753270672.06.299A49A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 08CB1100007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 00:35:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Fopj/VR9";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778459734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OMdeEy4hX3fqbsGPFdDTO2HoExU0SOR+91WL5kluGUU=;
	b=nB3rOh2XsHH8MeBOTJ6Xf/Tf+GSzToPL6vLcmJ2QGrQNLCzwetIrlWgvZyLbt3dNJfQb4z
	lmTL+ovsq3zxVYIOaZngiwoi276yaKY44m5OHbhZR7MF6Bu2SfVgUfwszjUaIQWamL6S5a
	Gq22met+7U7uCBcF7ictLsFoalRt+9g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778459734; a=rsa-sha256;
	cv=none;
	b=idC9ytFaWOSXtVaEFuWEsPuswPHaxXpka5wzk7T3Nbb/K1g4svySdMLuqAKqmm4x3+4eZ3
	gKlEJnzuy1y7psCb8cW3juPdf9wnDQF3tCxbPWBRPAMU02ZUOmOc5mGWz78AKpf0v+q8oB
	FKkupjaSabGWtf6fovlWFMyf/qzhaUU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Fopj/VR9";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BAF76001A;
	Mon, 11 May 2026 00:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBEF2C2BCB8;
	Mon, 11 May 2026 00:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778459733;
	bh=hhM9AGOB1FqTGF4XS1kUrjzVkjTnG35yYkXRJVptY5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fopj/VR9NcRqixzFA6VIBiisfD4SgFhiUyw2Z94dCIKxzISj5EpRRIWOHBfEfpL+6
	 ga12i5J0D2WhRPaSVbc4GfCx7zq+i2bilem0jk1rSOFX9+rSMKc5Cy6dCUY6JpD9VN
	 P7PJP8h90U0uUnFbC2bKjM5YgI3dNfYJ5+EEMt383S5EJYi4q8bPJZOedMlb5mBB91
	 1NKNif4USPNNil2M3ZsgGMX3AaTHWpQxi9kNPltbuPpGvmLz6+UuvB/BB0o86StFVY
	 dZtDYKqhfERYgtZJuY3n3yHQ1KEO8L9GoSyil+MN93DpsYi3HCSYRcT2gIVAtwCwps
	 qM9zJRVwFG8mg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 08/19] mm/damon/paddr: support data attributes monitoring
Date: Sun, 10 May 2026 17:35:25 -0700
Message-ID: <20260511003525.81099-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-9-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 08CB1100007
X-Stat-Signature: 1kz57ej6zb78izmjh5no5ho8n5zrgwnc
X-Rspam-User: 
X-HE-Tag: 1778459733-843742
X-HE-Meta: U2FsdGVkX19NZMoomPMQSnmMDdvemRypPzMo6GvZdDFLyeWOkFG1uA8Ll5hvITsD5MHUSh27qzpcjXwbdbFQgCsvJY26ZUzrm3PLWi3MIFHlikxbLEGTllHFF9Qrqv50EsX6VzlLPp7uaq1IKSIvAw3wOe5rJ1+pRStFX9cdK0uwv/4EYxdNOQlHawIoAcYr76fGPwiK9A025MRMHmLM6IyaKSPaWS1yCeM9nVwCNBgep/XWa9mhzABYYqnNQzZa+Kk0iwifr9YB1T6Q00TfW0wgC6zRUx8dQ737sC4cxdQ5KU0vCpS7gP94/7C8Nlp5dreFrSyMV1lZGnwf2xzeM33ASMeQVUtPTuPuszQIObgwIlxZbZr80uG7UpglYCRBkZm2LGmRQzipO1I0HZHN+GuKLR9aGzwGpbFZV6huCFlfkMc/qqJOVAdxhrmexdm6Js1e7i742OGrI2t5xZR01cg4KS3yepjF1YaZS7EqqE4EnoxvJeW5iWLnglE0Snlpreq+D60th+v/8gjxFmNaqS0NKtJRBngLJWRg8R7q96Q6JqNAsHJDUtotpthLN6VdhF6GciKfaEuoyaqJi72iIizB3wtJKuWKnQh/5MWlG4wngEiOSue92F7W5GL5jP7T6c+GMZbQQKZoqtIsR+hw1pMd16dkvySjbW8J3m0jnQa+DMWJQXe864luam93GAlhlz+NIqZBWc+XTlvF3V4uKW9TUPQSCec/Ti3tlBunK1BoMT+/m7vDXNB0xVJr5Oi6ImNfCAN1UmFq6pEycQ4DpwNxmORXQNm1nnLlAKY+g6ybPcS/MhOIogyhuclUyaZ0SvCJfp8HCzvaFMoOScnnclv2SDa+mquoRz2k0mCJAnU/2VvS5VuUKSZK1tDhhYFxqwtN0Rl+K1osYFrQI0Lzswvj2sLQgAQoYMr4Tsc6FAmW0uHzg6zwYIt/8enya6H2eNEpNk0UwfzW1233MXH
 F1nTxwJ6
 Dsz66r+s+OBXA4/cWqTpwIYEDqIYPBW8oiWMsRNDJb5cgBx77AZFved8m+PBibs/tJaKiVH41T6ccDY3Kci/mdpQsb6KeKfgVfjd5pWACyyycuJXB6Y3ByeK6BWZETp2E6/PJR97ugTT/AOIgvmzKdelnTxobNIold5g7a/O/iiZ1bu5aBdndBlp1+lMAYGpAItNh+zdFEjvVFbaRudevS+WTLrpxfO6JxQLl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Apr 2026 13:52:09 -0700 SeongJae Park <sj@kernel.org> wrote:

> Implement and register damon_operations->apply_probes() callback to
> support data attributes monitoring.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/paddr.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index 5cdcc5037cbc1..cacfbf774ca4f 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -120,6 +120,50 @@ static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
>  	return max_nr_accesses;
>  }
>  
> +static bool damon_pa_filter_pass(phys_addr_t pa, struct damon_probe *p)
> +{
> +	struct damon_filter *f;
> +	bool default_pass = true;
> +
> +	damon_for_each_filter(f, p) {
> +		bool matched = false;
> +
> +		if (f->type == DAMON_TEST_TYPE_ANON) {
> +			struct folio *folio = damon_get_folio(PHYS_PFN(pa));
> +
> +			if (folio)
> +				matched = folio_test_anon(folio);
> +		}
> +		if (matched)
> +			return f->allow;
> +		default_pass = !f->allow;
> +	}
> +	return default_pass;
> +}

This code is not respecting damon_filter->matching.  I will fix this in the
next version.


Thanks,
SJ

[...]

