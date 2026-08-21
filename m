Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD75C5DF93
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 14:12:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 632A36B009B; Fri, 21 Aug 2026 10:12:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3B56B009D; Fri, 21 Aug 2026 10:12:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9B86B00A0; Fri, 21 Aug 2026 10:12:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30B6F6B009B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:12:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C53951C01AC
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:12:04 +0000 (UTC)
X-FDA: 85125465768.15.475904E
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id 303AA1C000C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:12:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=fsH1sn0f;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787321523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eb7xA0CZoUY2QWL9JJY5cm27fWnsNVXdbEb3sAd4rNw=;
	b=NVVLKTpeOU4a+wVOvDo7slhiLUmSFZld2b32ETHafbvaFKEMknlFuMXVbwFlT1nuzHXYi5
	b0ie54sNNlGfsxsqVymXZaALPHiu+VqN9AGyOoFGx0wHje+g9VI054rsjaGh46f+gOIEr8
	p5OTP/3VcfAELELErwfeYdPt0WCFNkg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=fsH1sn0f;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787321523;
	b=wmFOcY1vP+OCmlQPSTa+8X4UQpeVF7Wn09X0+LydyTAaIxh7O8Oxy0sisFYJwqkWOvZWEK
	j3vFkilrAbpXN1RoUH9lYi+8xsWkaXwwzZjXwiAOjNavGMOuSFv7pix9SO/cAWykfDmtb/
	ZP+MjrhcsZH7DvCya65JLptIvcWJ7+w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eb7xA0CZoUY2QWL9JJY5cm27fWnsNVXdbEb3sAd4rNw=; b=fsH1sn0fhWE8VQ6z44pz/Lqc0a
	aCuIa4UarAIbljORKpZoWr5R+6hCDAZCFRXWhw03ztEtOLQEAiso10RmuGAuvbUom2dZRqwfOts8T
	DflDsj6s87G8SrgSKJetC2hOs7bkiC5VmU2tr2ONT1PGzK6UZUTOEQHT6mVos88136eN0KHVzSi5K
	kEArKhSiS0hL+otnGvynq3ETl9EJ1kxDAJqglojE0UsKQfqDM+QahbRafrvAGQQlQLrRwQjQDLIKt
	JNqShfQBu8zJgRuB1Ydjc2ADFaEYuvhsRvRcFilDMT7zEAi5QYlXu1ebTL23bI1fh9M1+lAqt8HI+
	Fi8v6Zug==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxPyJ-00BOWn-2i;
	Fri, 21 Aug 2026 14:11:52 +0000
Date: Fri, 21 Aug 2026 07:11:47 -0700
From: Breno Leitao <leitao@debian.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kexec@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/6] efi: add the LINUX_EFI_POISONED_MEMORY
 configuration table
Message-ID: <aohbRisiQ9Mn-ldY@gmail.com>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-2-5743791e48e6@debian.org>
 <aog7bwfMVpSy9LcY@thinkstation>
 <2vxz5x13znn1.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxz5x13znn1.fsf@kernel.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 303AA1C000C
X-Stat-Signature: xnbrpcdas7nnaxa93umxj6rzi1mj7e8j
X-Rspam-User: 
X-HE-Tag: 1787321523-806771
X-HE-Meta: U2FsdGVkX1+M72EK3LKV/qvXcI9Z9tRFcE+MVY6xMVfqW79ORyOr6CODBrOe8yFe0w592wjRU+vVP6mlAI22p+rDTWGBC1Np5Cwnib4fiRcQXQLr8rV4yB3l7L5nmYPDwMuG+KtpZ0cWO9cYFg1WGhul6gpCa69xP0SeZP+iXbQmpgd2urUk0N2Yx3WOl1j1ZGJADqbRYZIgaIfNjNYhWQ1/5ONCYOEFOEKsAD+q0+8TxCjMDDnTPNbcdBzmYJ8EskBEyiGp+eTv4j8gYWgDIbMCYS7/Z4xHceKioD4R/77Wj1sSDjANuu69b4+uoypy+n5vmYK5MLLX1QMbV8hZeHBDTLMEW+lp9ZHkk1cIia6TS9AkBy4ejvQE6sBPeGERq7lhLV/fRdbSPiIePEKvT/4XxcplRJrfDLSn4h824opbwAPoNdVEUYut5l3kG8XAAJrynqBmikFRY0vCms0CcDlx/LVnOk0AHSm9ge8GNGf6o4t6LVANcXRwYXB3nblI93yy1eUYzt7PXBetEyWUIEdIepCX+cYH0lcaWrv9Ml0X1HVN9di+52NZoY4JSrCMpuPQrcz1tJIQYjnSEqhJhPVUGk+KuTaxaj1pi3JJCFjLxDhCjBF+uEMSCuCDsn3OUsBHInnifWf3jWLJgeT6ebYO5KhG8b7SXJOOHJ1uRbW6K7L/bD/EbZJu4NbV3ASly1fZTwCFcscL9SsG7XAh9iiSL2T3r6Z6s1H7vJyIhlIWPj9AqSF3mN4mn0rcDRcpclJcaQGAlHyJPf5ogzBxsJBv5uyGk32aLR1YNt+IortzQsOQFdfwBDu2uktuk0oulyiCOUxo92G+EvqP6ixtJ2PtaKBnXz9OYJNUsSfDsm6H3tT9K+LPROZz1vh/8w8Eh8ZXqCrnvbvSzEaAfyZI5l6L0AGZnlGzteAVrExa6h0ePo5TL2mQHggvnLq0i+kjN8t7TIoWQGM0zufx9Jm
 UoqTUFxr
 g/LHUsWhW4BefSvuvpN6ECLAUmPGOQLQ1CBdvG+1If+F/MgenboxyWP3/4ecfqHMp/qMJ7C+qWbczqAjME8kxdWnwKG7/RnIy9PE8lYCZtVZCPgmZeHsl8JLMtMFLwnC8euJkZVIRlEHE+9A/Z/KHsvojMxSINLKxgl7r8I9FM7sDcBoFLNTkHIHj7tcPokN7OjqmIYlPlAyeNap5c2ysRqh5Cg1OXHN2jcv+1snFggGa5utI4uoID6xdakXKltkuVXWAIb/UPCYudmOeaMiREgPYlJECGzGFgABbB3BbBZO9lMTHT+0uAzF0cZ8JSHHVugICbGa1YERKBNI4hOjZ2nAGBwtJqm7ePam+H1JTbF4U+mArjPhn2FQBl5+F/5saDKJQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Pratyush,

On Fri, Aug 21, 2026 at 02:03:30PM +0200, Pratyush Yadav wrote:
> >> +config EFI_POISONED_MEMORY
> >> +	bool "Carry hardware-poisoned pages across kexec"
> >> +	depends on EFI_STUB && MEMORY_FAILURE && 64BIT
> >> +	help
> >> +	  Record page frames that are hardware-poisoned while this kernel runs
> >> +	  into an EFI configuration table, and honor that table early on the
> >> +	  next kernel so a kexec does not hand known-bad RAM back out.
> >> +
> >> +	  If unsure, say N.
> >> +
> >
> > Do we want to make it conditional? Maybe just for everyone with EFI_STUB
> > && MEMORY_FAILURE?
>
> +1. Each config we add is a decision someone has to make when compiling
> the kernel. If they rely on the default, they will miss out on this
> fairly useful feature.
>
> So, is there any downside to just doing this by default without any
> config?

The only downside I see is that this extra config table gets carved
out of main memory for every MEMORY_FAILURE user.

That is roughly 64 KiB per TiB of RAM, though, so maybe it is small
enough to just enable by default?!

Thanks for the review,
--breno

