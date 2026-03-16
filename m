Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E02A5F53D67
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 15:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EEA46B02D2; Mon, 16 Mar 2026 11:06:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C2596B02D4; Mon, 16 Mar 2026 11:06:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F2AC6B02D5; Mon, 16 Mar 2026 11:06:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D9216B02D2
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:06:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DF0EB7125
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:06:37 +0000 (UTC)
X-FDA: 84552252834.28.63BD3E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id E1A971A0010
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:06:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MHmz72Ic;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773673596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BNTLBCX/7krc1AxsjLcJKSMe12jLis/nSn59mHBCLKk=;
	b=UOfHakU7xOCiMwyP4nt5Uzyt4+Ozsd3KJLzHsIhBgExMUkFN0wQc1cPJU60E5uASKdFal8
	hOBWdVxjrDSyNkvN6OBObtyCnQDQElgq9nCSSPsZE2kAp+cXSyohlxenp3XScqJs9misTA
	ouBlOGOvy1sGig5HvZqnbWsbSqd5m+c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MHmz72Ic;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773673596; a=rsa-sha256;
	cv=none;
	b=jGxjwJ4UP963JBYl5e9Hu8PiUnNFZTO42cgEqXlQUA2WITosCIRQ65hzNcr5dvazF+Vh/c
	VD5wqf/C3ZZWz/RB1kfHge671+kx5pO3LwfI3WW6BqbshnJuySPbr/maFPcf1x6BaRRWV9
	Dnhb3hcb0+NKhTRbmSbrf0pq6XX7ze8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E74260018;
	Mon, 16 Mar 2026 15:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F594C19421;
	Mon, 16 Mar 2026 15:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773673594;
	bh=VUwHVs+S9Dc4lePhODG97FdAbzEBNXby5kox35Y5M+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MHmz72IcPyhBPK1xiztRGGigxvKxQXzHFT+c+fBoNMuKIRSPimSmliZjLewO7U+qp
	 Nl6SRrf/G9V5T5UOfp+72suPDjCMpoP7MfOIA1YNKgGTh7CTxXvr1KmWM55zGJWHf7
	 lGBmzyuLYlALfVmJczNKUvdCPo0mBQ+b8eodOX+qyZTlNH2EliwNzP1uUJ+FNnLXvJ
	 dkXSc24LXROuoykfnzGbhvrTfDu8Fwk1n4Bplj1bHzxKdO2EcCyPYiTz5QWmnKMst2
	 bxnO4cjcB5YjvAqguH2kPgKQSS8Qd+Q3oBreHxYmAoBHe/b1CcXjlCGKOmbqNVhzpG
	 +dNTHIA7Czbuw==
Date: Mon, 16 Mar 2026 15:06:32 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au, senozhatsky@chromium.org
Subject: Re: [PATCH 0/2] zswap pool per-CPU acomp_ctx simplifications
Message-ID: <abgbx0YXbxu2mAHU@google.com>
References: <20260314051632.17931-1-kanchanapsridhar2026@gmail.com>
 <20260314171150.fd6a80a8f51a5390144d20d6@linux-foundation.org>
 <CACpmpodjsMELCrJ-QX066CYiGgraysr_ZhFMvU5N-6nr2HsRsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACpmpodjsMELCrJ-QX066CYiGgraysr_ZhFMvU5N-6nr2HsRsw@mail.gmail.com>
X-Rspamd-Queue-Id: E1A971A0010
X-Rspamd-Server: rspam07
X-Stat-Signature: zs53m7qk6r9o6mie8q43g4c5uriymnf9
X-Rspam-User: 
X-HE-Tag: 1773673595-667090
X-HE-Meta: U2FsdGVkX196JAS4rWUhkBhfPNj481tBiBrAzNcYYP1oSYGMxMFH33a5AY8fdpBfBaUqJYlGKNLRIJBvFbNs94XjDsnUUp2oNOqRpFJvuC0VwIfRiv9aAC/Eh+WPgjtG1tHmvueJ5Xic7tI0vWladCCzJSh3rBYTHfw7K4GhMrKsizpbDbTHZXYGe1Wf6wpD/CJwdQmuDI6sj6Fv7webUFRD5/3oCfsXUNF6Ftgl7yDARDbxZYtOF8Paa88KOxATHZ4Gz1C6JzmiD1r7jHgDv0uB7x6eh34EkPWsjGOr3u+pkR6sVqndZlyEDI3YlTWou31P5XtcYrbc4Yrl4cbP6t0bFmd0NUwH9jj0bQlLVJFJTT0Jws/vH/LcFt8Nv030SQG7FN6E2CXy1oQBf3EPv7K9TiMCjhnsLbiqrsIIUZ726MvQOAEoa5Ih8ZsgMgiPPRDI/7hwmDAgjyRXcA0jqYhxUdC/bZWAbERbDFAy/8by682JqnHmxIS/J14vUxDlOgPI6Hl1jBWpgJHaYjb0LKrGITCw/049DF1uiZpoMc9fw0ryp1Wm2LCtOc0QWjrVxLgZ4MC9lr7UqyXnj8uyaIOVcRsyYPItkiey20O4LqLe2s7OEtCAITFIMs53dDZg7rcI64edtavqEd52+osxcHGi1IR32VU/oiCTf0LAQbBEeV0lnMJpv0HJUYDKxiH2fh9vswozV/dxH+FIo4GwVsoqZ9Of3lig9ywV0qiXSIwarNDgRjmrz1hOUjuteptPKAqBNP7yfiy3Pi49B+SJRNXsxvn4Wtr5iCqJ/deOzuEUjN37Uf2pFLhyHfrcKKUYdwYUXFeHEMzA2FKAMNqmI1m+/qiSlEDw51yVso5JtnCxOVsdpCRbeO7CpaXy1yUj8LzpEkMrCtpUr/XxKVAe5OrIzIGYDidi90MiooOjz3iKBptZVXIIBdQVp2YYWgDRb/4ojs+i84koby9Lu3/
 SzuZbnf8
 oDzJvH+J7LRcxgSUExMaNAIIGp958A27fYEpteqxBXRRSPZzikaUUQ2LkjNFtRrlwnrSRUcvEow1+ayPypUx4DYD7vCW08kYuuIucwjooi+3AgoN+NamGO5EXYl/1s0E4kwTpaTd/n2xv+9VwpkNgAM9ql8y18KGyjks2bMOFKzb7yVIdFv/p+hBxBkeDOkV+9mLXr8H4JXh16Q7+WQcGbBDuWp9CBTf3wRuqhMZvFJMNmAFJERQQVb9SSrE2ayZtFHBx9iUQb+MWQeEmDbvz+49eQOxXdPZDMadn9XqtMbwpUi1kIlalGycInXtOR8lF/5Or
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > @@ -786,7 +786,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
> > > return ret;
> > >
> > > acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
> > > - if (IS_ERR(acomp_ctx->acomp)) {
> > > + if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
> > Does crypto_alloc_acomp_node() ever return NULL?
> > Looking at the error handling just below this check, if this were to
> > actually return NULL, PTR_ERR(NULL) evaluates to 0. This would cause
> > the function to incorrectly return 0 (success) instead of an error code,
> > hiding the allocation failure.
> 
> This is a good catch. Just to provide context, this patch was
> introduced based on Yosry's earlier comments in [1].
> 
> [1]: https://patchwork.kernel.org/comment/26282128/
> 
> crypto_alloc_acomp_node() currently does not return NULL. However, it
> could, in future.
> Since the rest of zswap_cpu_comp_prepare() dereferences
> acomp_ctx->acomp, it depends on whether we want to future-proof the
> code to handle a possible eventuality of crypto_alloc_acomp_node()
> returning NULL.

Hmm upon revisiting this, I think keeping this as IS_ERR() here is a
better documentation for the API, and the incossitency between this code
and acomp_ctx_dealloc() is arguably documenting that the function can
only return an ERR, but it can also be NULL-initialized by zswap.

> 
> If the maintainers think future-proofing is beneficial, I would need
> to handle the PTR_ERR(NULL) which would send a false success status.
> If we don't think we need to handle a future NULL return from
> crypto_alloc_acomp_node(), then I don't think this change is needed.
> We could leave it as IS_ERR(acomp_ctx->acomp). I would like to get the
> maintainers' inputs on how to proceed.
> 
> > > acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
> > > - if (!acomp_ctx->req) {
> > > + if (IS_ERR_OR_NULL(acomp_ctx->req)) {
> > Is this change necessary for acomp_request_alloc()?
> > This function strictly returns NULL on allocation failure, not an error
> > pointer. Changing this to IS_ERR_OR_NULL() obscures the actual API contract
> > without providing a functional benefit.
> 
> As of now, acomp_request_alloc() returns a valid "req" or NULL in case
> of an error. Same question as above. The only benefit would be making
> the code more robust to handle changes in the acomp API in future.

For this one, do we need to do IS_ERR_OR_NULL() in acomp_ctx_dealloc()
to begin with? If acomp_request_alloc() only returns NULL, maybe that
should also be a NULL check?

In this case, we don't really need to make any changes here, and I think
this patch can just be dropped.

