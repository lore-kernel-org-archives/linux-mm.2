Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA380D637B2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 03:56:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D55E06B0088; Fri, 19 Dec 2025 22:56:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD9B96B0089; Fri, 19 Dec 2025 22:56:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE5226B008A; Fri, 19 Dec 2025 22:56:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE46C6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 22:56:36 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 50F6E13ADEC
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 03:56:36 +0000 (UTC)
X-FDA: 84238487592.10.30E549C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id B541520002
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 03:56:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LaIl2kAr;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766202994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=975gcM7VaENBbW8+sscLr6RUSlbeSAv5QO9rb0RLkJE=;
	b=CTedoapagNSqO9uPWTnTzodNbAPEY8db4ESbgdh2aWNElih62JcDZQ90znos/0M5RUN1mm
	VR5Pq/4eDztm5oBkPOvTOTVZ6BEJAlnY+3SaF/PhtCgnx9mQEdeAx+IhK5paNr+znUqdvs
	8WCI6w8xg2vApj8q6jewfTx2EY6fsgE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766202994; a=rsa-sha256;
	cv=none;
	b=vWzJ3xISqv4+V5SaxRbPhw3a6O535chF3MvwHYvybli8zw3WCpNykRUq4V6tt24XmGZizK
	DwZsSncM3e/9ZSTsBOOLzOd34e3AUYSA04GuP4ZNPKtNyN15A9gCdMdzoya+dedzfj9dNt
	04OizVddjrbaIEU23p39diuH7xt+c4o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LaIl2kAr;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ACA0960008;
	Sat, 20 Dec 2025 03:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C220C4CEF5;
	Sat, 20 Dec 2025 03:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766202993;
	bh=oG2cgaVTel3t5jIQfUWZeyuo3/UdgT5HKmaEXMQCWYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LaIl2kArlF77GP+jgPiN+nX6JLXC0iriyPbwCGGzaCpAL66tZaMVJTQWn3IE5A6c8
	 AojAJHXshASx/Rkrn3+PReDavG+UV9A7JDqN+QPZME16UT47xb0rLy7iBE0OWnJRuK
	 pGxY6wEdkjhCbwvnqAYm7fbnv+BA/u6N/OY8WdKSrPBNhsIOd9s6jqZWAbkP01eYb9
	 KZdAGZGBj9lJFSBwNAI3jXIlclY0pHQxLTegfMf5UQfmvMwsKodIbUfa1WPjLzPIkF
	 9y/nULVMh70++uL8nTM9v8BaQgBTHglgs88PJKEmrsZY0IE5sRJDHaJozA6wVc1car
	 A0dAsWV/nhYrA==
From: SeongJae Park <sj@kernel.org>
To: Kevin Lourenco <klourencodev@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org
Subject: Re: [PATCH] mm: fix minor spelling mistakes in comments
Date: Fri, 19 Dec 2025 19:56:25 -0800
Message-ID: <20251220035626.44647-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAFveykMG1Qg=kG27y82PfH_prC5Jp=CTa_6Wttxu1cPkfzv9=A@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bxh3rd5j7yzy3zyrs5t83tqyax8xkcft
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B541520002
X-Rspam-User: 
X-HE-Tag: 1766202994-987048
X-HE-Meta: U2FsdGVkX19AWw3M6WQwunxOQe3vK4vu8Pkoo/d9V+/1V4FRot02E5/uGvAhfN2iUh9dS9o3OI+D5Bsd473LOXhrGZ0NtOz0hqQY1Q01JmULzVykeh9gfF1fT7vKPsySFjnupH79D8RsqG9oDXSgHYxt/N46/R6XZjSUUmxobVCj/nIk4+rfXR0fZkCkCFTuKlkjlh7viijocwOxL0aBqsEnSpAqBUtL28DMBYdYgl+c72ht9iDZjxAzWwLOotLoT/B2jSgq8exjeEgGyz1i9l8HNlhRs/6nqIjOIRE7cl80uOzM9m0sSGFKUjmI+guBxdR/1cnS/r0oz4qRe+N6EdP0W+Hh3B74zCVXVeVxLXMc51V0rA5FkWEAiXPZaiaoQ8jF0jnoNyEh3rHADA68w5kPTOmM9XEM5WcFLrQI696Vu6FT+3IEnHi6qRDjtCvtxHdnfrXH28oZl8uty68/23rhRzhKteLB0D8rD2V14Dmbj2APJbfuGjoFyUFCHFffbtHFbYJ6jSKxCpK74gGQK89LvxT6a+KJxv8Q2dda/SN6LZELI8EAnzENBUVZGeeQylY5Oha860CfdK8+zxOVpdNQ95cHohKtqnDNNyFlEcNCb3gPcqG5jPsOzWT6Y93gcSCJOq60mPPvxLodOdE9GNbWCOzPpgfcr4pdl7JDwQaSB3hVmAmec1nopMTtOSOs3KH060kE2Q+64LG0GAjDuqVOp2wGLPKI59Ur8os0Z9OEOQFI1/zcAHHqnOgXR1KXklvEFepzJkmvuA8vLZKSqNPf7uygfgxLpE+L/MNCfmAcG9/VCvcCGFLWoS8OgoRzcO7pk8fVC1JbILYJMIZnRDYizAmCSLi0tL4lBTsbv3oRF9EyaAkr3q9z00IlBlJVCrAHTwYylYyoam7kK1dtJ1Pb/MoY9bNLd2X4h4U7KDBX/NGn61c2iHPrGHeWAyDqmf6fmRSe4xisyGjaro6
 JFGDEA/1
 jnznF59qn4mhL7iHW3nSA93WK+nt7UF7sfHcOonCGFKRrTpq9PWUtWZ6SxwlD/n1mRl4Fe6BDUXXlylw0ierjiV8pDhY5RoHARajfMqgLGGPlbn+GW8KNxzACc4/5vIegVWOPJ7YLFqGJ47sB+5o8daZNtkX7Hz03H791nw/cObcv3tUOe2Dtr39L4jOFPSR0y38mBirgVG4QgiNyqjDiHCvke1PS3l5FdKcPOsGfXFZCUja1bVqGwV4X/GGlmLDM8ig/oTTsnFZ6pmc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 20 Dec 2025 04:49:27 +0100 Kevin Lourenco <klourencodev@gmail.com> wrote:

> Hi SJ,
> 
> I think you’re right — the wording there is probably not correct. If
> anything, I would be more inclined to use “the next step is”
> (singular), since there is only one alignment step following the start
> gap adjustment.
> 
> That said, I intentionally limited this patch to clear typos. While
> going through mm/, I did notice a number of grammatical issues in
> comments, but I chose to ignore them to keep the scope focused cause
> some typos actually made me wonder whether they were kernel-specific
> terminology or just misspellings (e.g. “sinze boot”).
> 
> So I’d prefer to keep this patch dedicated to obvious typos only, and
> leave grammar cleanups for future patches.

That makes sense to me :)

> 
> Thanks a lot for the review!

My pleasure!


Thanks,
SJ

[...]

