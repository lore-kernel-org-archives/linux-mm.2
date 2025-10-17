Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79788CCD183
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 01:09:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C53338E0030; Thu, 16 Oct 2025 21:09:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C03DA8E0002; Thu, 16 Oct 2025 21:09:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2E78E0030; Thu, 16 Oct 2025 21:09:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 993BB8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:09:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1155EC0480
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:09:47 +0000 (UTC)
X-FDA: 84005824014.17.88435B4
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf15.hostedemail.com (Postfix) with ESMTP id EED9EA0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:09:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=qbcQPSRg;
	spf=pass (imf15.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760663385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dg9UrmyeMX3l+vmZbebYqb6LMNHNQPPuGCglxcVhywk=;
	b=wx0+qPzDyH2aUm9yNXqvZKT8VkpIJngHQEr5GbIwRy6lt1Rm0Lh4okBjBsY8vSXPW8hp5t
	GwaA0KsBws/OZn0vaTvW+wVcQNA2Z+PfdNeIgKr0pRlnGjrO8w/b9hcAmW8pQix7lZ6tqO
	oJjW80ZrC/IAiUwIgU7nOHpXGTLNSeU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=qbcQPSRg;
	spf=pass (imf15.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760663385; a=rsa-sha256;
	cv=none;
	b=HvGivR9eEM/3Y246uVw5ACz9CoyDOO8OVUnewlCGfEADTU8ujJNQNzpSb4043FeuPiQwfg
	097LHg9PDYK60ylk5StT2QkQG0yerLoEVuN1GCNmgquGiZSaQpKcJsn+zfEAkSAFAyeE5l
	sov/mg9EpEQ/aohBr4WW9mOG5hhOkvU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=dg9UrmyeMX3l+vmZbebYqb6LMNHNQPPuGCglxcVhywk=; 
	b=qbcQPSRginp3zT2ooRQz3ELG230xVO5RMIK+33anIhQR+2nchY8murdgvYBLZ0V633tXYE2i1m3
	samNW1mzPP3Ti+htL4q1rZ/VmrY43UFU7womf5MhHRJ/JaaW7V0ZrNd58SJW34CRg0EyHLdq40Vnm
	TyhpFsHOAmpbgdSlRC9azpuUzh0msbI8egLKuQxVj7kuPlEhbIPUK2W6w5Im6/4ExkXb1DzV+uquX
	QjdbnVDbGWbcN0oXNuq4JZR9DU/HeT3MQigmcijBQ1NxjqKM+5WQNdOkm49AM2SfU2Yr41e9uIZ0P
	9UAOgF6YIc4DKNefHbYdTcFD1N10kUg/ckcA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v9YyR-00DI4R-1l;
	Fri, 17 Oct 2025 09:09:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Oct 2025 09:09:39 +0800
Date: Fri, 17 Oct 2025 09:09:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com
Subject: Re: [PATCH v12 14/23] crypto: iaa - IAA Batching for parallel
 compressions/decompressions.
Message-ID: <aPGXUxRZeYLO_CUo@gondor.apana.org.au>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-15-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926033502.7486-15-kanchana.p.sridhar@intel.com>
X-Stat-Signature: d8b7w1hquz8pwnnixrj4ghpe74c81dej
X-Rspamd-Queue-Id: EED9EA0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760663384-345467
X-HE-Meta: U2FsdGVkX19kMDP+1HYfAk9w3UJh7YROy7tQuI81Y+kEH0kmviWgk4x4NaPqQCyb+MkDvOzs8Z1lt2lrTzty3ZXZ+q0Tp2diQ4S6LCIH0ZP2F5NAinXhr6BSavtQPacLXdGGepY5ZNFGofaIUhMxeVHKXWp4EcmuT28NC+obKtlgNoG/rz2itYa4N2oOX0naM7mDNx+ohIyfjowc59z/FsbExuiEg1gQs48SMlW1aC0axc7IppE4JJNX5H+0EBNHsOfMVR/nv2vMWEhnOYxsmT6z5g77bZ/CGqWImfoKNBJRCMgfA9nNwKnWkLqPLexUHwT/UERsrOnjPOUSVUYdyHKctiOm4vQ/f7ljBzQoj0tw+3fZncJnLI8E8QswT8f9CWQqnq6/cTVMUkK3hljLrElt77NGmuK8uVLNdBgnx8o6Wb+SQZKoK/aecDS1JkAzyqHaEVLI+l1ONx2tdjpbgGsBTC6OaYbfV7SuR75i2vLKdPCDK+zPoL9S7dFGd+8lTwzMy/Rqkp4kpT4826Z4WJaUmud10t9Y4/WiPh41DRlNtts27JQYREzeBh0sUhkdpeeRNJTtR2vLKF09bjM+UFuH/DQs9LC+Xo8QbpKc/lVLY+8UJ0oGDhJYotx1txlrIBOPYqDndC/Ho4kySVEzbft2iekmk6QkrJ9K52/k0BCsM0DnADidEBVvPoQQf0ch5PbV8V0JmEKhAgFWHTvslqRpSO0agNWmEXdlM6HzkPEPK3RYTbXMmUoPE6UldqwP3HmDKZz0ZtceX0c4zVAs90aVX4UGhD04wnxjbZs5eq0rimYM2mUcYPWjLs3Jzp+SGbaKzAXMy5o4xrYWzGy3vBB8e7ZLEmDaXA2d3Uhvn7lInma/8JL5rN35Vulmdv/15XcRMPdd5lmQNM53seYGIsjBoyy9KKYXlh8L3ZNSIFn75S6Egtpykx/aUdbET8d4gl6R7p3ZQ2M4wGEJKrl
 tn2jDzZK
 IJ4H2GwES53AmbgZMCEC2GDTynEAxgEIJh448MqKaYfY+s2J4Yfu8Eo4QeQ19+/Ucz5M+vQqR1CoTPMCGXOyfXtrGtpJ1Igswst7693NXAg96ibHtrhEFOFlCZ0ntpzRIqqHJRJdZDtq7fkpiUOfjqwmP18KoTf5KJSYBRf2DkbFAygjUEtNsTDPUzytFkrDy+WizgYqMdhzR7nMET8gYQmRzJKW+EwQadpG5dVt3N92FZlKBaxxvAS9vCvgadVkX1sO9Bsbfrft77CZvXdZV+rJMm4cR2BJkjRfP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 08:34:53PM -0700, Kanchana P Sridhar wrote:
>
> +__always_inline int iaa_comp_compress_batch(
> +	enum iaa_mode mode,
> +	struct iaa_req *parent_req,
> +	unsigned int unit_size)
> +{
> +	return iaa_comp_acompress_batch(iaa_ctx[mode], parent_req, unit_size);
> +}
> +EXPORT_SYMBOL_GPL(iaa_comp_compress_batch);
> +
> +__always_inline int iaa_comp_decompress_batch(
> +	enum iaa_mode mode,
> +	struct iaa_req *parent_req,
> +	unsigned int unit_size)
> +{
> +	return iaa_comp_adecompress_batch(iaa_ctx[mode], parent_req, unit_size);
> +}
> +EXPORT_SYMBOL_GPL(iaa_comp_decompress_batch);

What are these for?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

