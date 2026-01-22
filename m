Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70559D6CFA5
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 21:28:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC59C6B035B; Thu, 22 Jan 2026 16:28:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A72BB6B035C; Thu, 22 Jan 2026 16:28:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980986B035D; Thu, 22 Jan 2026 16:28:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8386A6B035B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:28:11 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2BC7ABFCB3
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 21:28:11 +0000 (UTC)
X-FDA: 84360887982.04.88268EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 82DD7A0006
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 21:28:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=13YXjGm8;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769117289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jXbW001NWHVmr4NBsgDBPDDfTotCacShd5C0Czq65W8=;
	b=5SMfa3tNrLCXKOGTPqU2adEGNea+rEV1OAV25g+jo665TVGgzSQvInPtOEOC/64ioprAGm
	juVbbLDQGkACAxNdxdQ//s0fm9UBldYeEFf32hbqESjw6C50rrGMspri4mTIFiprb+OpSZ
	GqJ0gbHx2UIcZ7UQtSaz2Qfr0SSY+fo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769117289; a=rsa-sha256;
	cv=none;
	b=pTfXuu6qQzAkO35P9EMq1JmodaI+1+v2ZpdibxgL1HpQD5ifWn8DHH1Owa33a1JPyS15Z5
	v4O6RLak9K2Hdz3LNV5aCyHh0SY8AmIwLG7KkOHt1VszyYDs1TqwMU1vOMwKty84Vrj64V
	uOb5gdznssw5Y+sqLlvuuKnl758s/Hg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=13YXjGm8;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C06CD601D2;
	Thu, 22 Jan 2026 21:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36606C116C6;
	Thu, 22 Jan 2026 21:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769117288;
	bh=knqv3YaYhXLjzVaLE6iKL0LxzIm/k75UNIsgiKoIlIU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=13YXjGm8umxmJamt0Zl1nKi6FNc3yziP/vjSEGG91+vsNi4OogHLRxY7Os18riT6j
	 xSB1wtQTgLsp2E+D4CjtXNYBRWoJb6FbDoLA75BqLwuEZ73BxJni5ECzExUPT4C57K
	 NjFDS57rLQ2ZgcD+FsaZEXwed9MX9I3E9DrRSicA=
Date: Thu, 22 Jan 2026 13:28:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cui Chao <cuichao1753@phytium.com.cn>
Cc: dan.j.williams@intel.com, Jonathan Cameron
 <Jonathan.Cameron@huawei.com>, Mike Rapoport <rppt@kernel.org>, Wang
 Yinfeng <wangyinfeng@phytium.com.cn>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID
 of CFMW
Message-Id: <20260122132807.7204b83e97e33290f6eb7d82@linux-foundation.org>
In-Reply-To: <2d1e23ad-7ec1-483b-88b3-70ce19b69106@phytium.com.cn>
References: <20260106031042.1606729-1-cuichao1753@phytium.com.cn>
	<20260106031042.1606729-2-cuichao1753@phytium.com.cn>
	<20260108094812.8757ce3ad8370668eaafb29c@linux-foundation.org>
	<9132054c-3017-4af0-84e0-e4359b0794a6@phytium.com.cn>
	<20260115101858.85fd7b8e837c1c92a4fdc5f0@linux-foundation.org>
	<696944eca1837_34d2a10056@dwillia2-mobl4.notmuch>
	<2d1e23ad-7ec1-483b-88b3-70ce19b69106@phytium.com.cn>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 82DD7A0006
X-Stat-Signature: pxcyfr5mdkwjfb94fge3nzdkynoqni4o
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769117289-300045
X-HE-Meta: U2FsdGVkX1/dOFxNwiZCqN70lvuSYxOx2/blrTD7T4gToze4OtfzLikfR48phVx2WerNtwl7+1SHHXxPw3+ne93HGtwEps+jqFJVwqoWguVVOFOKZvW+slRx24B6gG4UDBX4bFYspgp+Kw1QePVdNFd0DKmgTwkSsCFyyWg8dH3N4KEVJMz3Y87jzKK19wZz0MzNbfCsA0NAhOTJb9U3r/qq9P9eFQiiPxEHmj1lwAybIziOCcpHE3AyOdWvDuExXrDKiBppe29EXqCIjiR/E9s7AdgSpAiYaeP0fBRAtaT24N+zZmLrFS5yarc0Nk8EtBJWKpuBWHVHZj2vf6w2F2tTahxeoSkruC1V3JTrXuFGxQiyvBH6PznvKP3Rvz0U9qofvCldyHUtrsizjPuDvE4efqTpAlIZsHqQ1CuP5C/EjvT3ck6hYNByoFkbe/BIFlvRW+x7SO+pNXv4XiTt4YDSvPxsYq46NNxBIZfvWEs6frEPRwd25A92LPa3i3Ca+OxC0PO7vJfGZvDCvoPGJ0onBkx+Fks6Lol7tH3Rn+QIwGA/ig0k8kORIoBXNKVIl43WSuK7UGmCFKnfqR991ZbVkWNTr+4KkI5VEa+RMgo1khOCKAmjwNPPvlM7LgO3l4c+3UlOG++jadq07zSQYpXNU9w8ZdQLC0iUYCd7o+R+ZOLBF8tmLHqpbt190d1805wXqg/+s/ymsURZOgjK7FMzchca4ee6Qs2Rl92YOtWb2k2wSfzz3jGrTPztKPkoFzzCMxwU6hRrhjCjC/Bojbhw8RK4RVqkULXgOJ4Fu3ruwZ48GnFBuiy2FhszMSmFmFnAbwKxyqbNJTjKycsARMUaCspgpZJGNXQ50BzvBO8puX85jzxolfkG0acEx936wrz3bP+33OAkqVgIP62mGaSuEWeiwentvmhAszy3cYmADv9ZtbLQLPIBT1hB28N9bnhaLvYip7XopQO20Dc
 Qfm9Jbc0
 KG1of4ZPx7D9iKFUTq1et0VO9G4gQ+EHOf9LuAQFvdY0QIPABneyconMFdxek1oDpGoARKvfFECmxZx0CdmgdQeCRBIFhqiPjDNWWrH9oQB5Cq9CmuhHIe0dJWe5avbICNA93mUU75R8foIeFkQ3ilyUpHA98Pc7jF8c4xxSmPoF6bEGAGlzjEVOOV1h/WWLq3UXwGv3Y2rahxMcgSuLX/fCRB+c7I0SDm+AOwLt4Ye8Kj0X2HIxVkbzq9EE29x/Y2bFny8Sm39tfjCGD67FsasEOSmGmickv+uVIozfelzpQy5cesYvX6X9UrtZYx9uJ+BRh/FKE+wOtQeOQ0vyKQQO9Yy3Fpp1Jpn3r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 16:03:49 +0800 Cui Chao <cuichao1753@phytium.com.cn> wrote:

> 
> >> So please, tell us how much our users are hurting from this and please
> >> make a recommendation on the backporting decision.
> >>
> > To add on here, Cui, please describe which shipping hardware platforms
> > in the wild create physical address maps like this. For example, if this
> > is something that only occurs in QEMU configurations or similar, then
> > the urgency is low and it is debatable if Linux should even worry about
> > fixing it.
> >
> > I know that x86 platforms typically do not do this. It is also
> > within the realm of possibility for platform firmware to fix. So in
> > addition to platform impact please also clarify why folks can not just
> > ask for a firmware update to get this fixed without updating their
> > kernel.
> 
> Andrew, Dan, thank you for your review.
> 
> 1.Issue Impact and Backport Recommendation:
>
> ...
>
> Thus, I believe a kernel fix is necessary.

Thanks, I posted all that into the changelog.

> Therefore, I recommend backporting this patch to all stable kernel 
> series that support dynamic CXL region creation.

It's helpful if we can tell -stable maintainers which kernel versions
"support dynamic CXL region creation".  We communicate that by
providing a Fixes: tag in the changelog.  Are you able to help identify
a suitable commit for this?


