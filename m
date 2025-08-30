Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 459D8CA0FF9
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 03:09:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 364848E0002; Fri, 29 Aug 2025 23:09:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313F58E0001; Fri, 29 Aug 2025 23:09:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 277738E0002; Fri, 29 Aug 2025 23:09:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19D3C8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:09:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AFA1F140A20
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 03:09:57 +0000 (UTC)
X-FDA: 83831944434.06.7680900
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1BD081C0003
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 03:09:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jn+8Bxza;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756523396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=frCJM0RKIRDpj0pPH8w4hI97IP8Tq6Wj+ikhgIDH8hM=;
	b=lHKguX4pt497G5ZH+VO4m3LseDaN4E7+QT6Z33uX0pZ5Ai07bb0ioTYPdo8GlHpinr74cf
	j13KxizEguYr6Qz8ON+ls4opl4gTmTkY53HZg/P/5G7Lc8K9FHl4Ku1xktfMOeItJtHuhQ
	H4zMjacsCjIv1ixzAnUKKWNNBJWxmbg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jn+8Bxza;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756523396; a=rsa-sha256;
	cv=none;
	b=hE/DfX1oL1j8doC+n1XVvANSGplbXAENL9sU8RgY5LPNvljgyCRVzKKTXRIrGFdTejIJdS
	2d1HIycjruAcibnOfkK26NirXsVzwHmTgJEzpIOmWSMYsdLAtMOqn1W4l9wKzY5pzeAbZE
	MaqDmvgplfglaQ8HbwV433PtKf/lx8Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4712260146;
	Sat, 30 Aug 2025 03:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760B9C4CEF0;
	Sat, 30 Aug 2025 03:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756523394;
	bh=Tp4tGe1T7bM1Qt609fKwvvBO2X7Aa609nyAbj8siVC4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jn+8BxzapCfSwVMpqOVrLOZ4g/NyDmvoTdeW4qGt57C25b14nnqtxoeXURRwx3aLi
	 syf1X+hLjQeFHHz8CBIS3julLE64HitmPcnC7fcC8W96wgM8Og4XkvNNHpk/0rU5LC
	 XYeyPOqBxn1cqTYKph9J38q7eccnOjgorbo3lvl4=
Date: Fri, 29 Aug 2025 20:09:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: directly add pagesize instead of increase
 until page size
Message-Id: <20250829200953.1757e85542b1126c4881d600@linux-foundation.org>
In-Reply-To: <20250830023102.14981-1-richard.weiyang@gmail.com>
References: <20250830023102.14981-1-richard.weiyang@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1BD081C0003
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: kwdj6seu5k1xkkq368qies39oczgrwah
X-HE-Tag: 1756523395-327618
X-HE-Meta: U2FsdGVkX1/gQMSbWhkFGgvncxMV+KUDkBImT12RxHn+ygVfwNNQEbTzU/6gfETKEUz8x6jJApZTZc+F2jIwfnnOm/29a6ppb2tebJchcW/N1Foe940J/J1d1K+rBQp1tzFexp1ycm25xoIbYh23zfXwJuY7GPbvyby+FAEKoI3CvQO94TnI5sfbf/iJTYPFQ5e4G+7MfR89VjAofpUFfzD+3NcCYFClq4erOHs3RUL0e1bwq4g8VClGzKCXbCbz2x1KD/50lWJ6rTxhW9I/q1SXC8q9ruzOZ8S1gsbMk+j7Tzo3kHbHjgXbJdX308m1g8MBOSbM6Bxa7nqiVxLD85+QH4i5cYtrXBM/uo4psIszjhQVLBgy2F7yRlz6afZEd3hNzU29uS6wG9Zkpf0MnVKuszoJ39slUfZyw2Dt3yQVY/MLG1Gt1vye4eNMbMc2Qhk8HJmX9fXm66/hM39EKCOWMHiUtIhuvjz1UK8KdHgjwHxlvpG7Jb8UsYOtIjIo3JiC4llO1UjQUzfmZ+25c5g02kJxQhpR8rbufpOfMfm8XiiIBbkYvQYX5oelb/50N/cDDpxi+qqmm34Rh6rIu1sVUTq26VBgWxcX2/NY2Y3vmF4UizzSAue6qw/Xo4CHMvYJX/u1WUPVL98DNch7BvBDFmtnkGUMy/J7FkBCSMRJ5h7NvgXyMzemWXJ8y9S26Vi3znfzToCNCdT0nVWeq0SRIRUdTOAxGJ8VA3yuF7u2OinXs5Ay5xVfqBFGYhCOWokq41WzoGPlpgQ3QCeOw96c+o7LUwI2UoKeU5nXPPRjAhVq0iLntUYvbxiNOTaWKs9ZQGpAKnIijIv2118fk9NS++FEfVkosHTtng8tbHJEtYRJdyAboyfIEDPn8e73LMU7HCTaDrz+Utyh3gizCSSQnGuH3Jd3DkftNWXRF7GSx7DRtGEtAiWZ/7OCgvWdbpr6/J4gm4rf+KQvIDJ
 IjLmtNnR
 n0q+T/c5sLtIbekJqjXf7WO/hkl9HsrRaUk0CZaRozmYlKbcPi8XvE8H65q38cDDelZX4BQ5Xcr8IgPyd+X0N69y7YsuB7uyaLWkZFiDi40MGpCcuIs/ns0foTVzITPp+LDHs8GHc7ygoiLaz1YgY/fuYq1TsC1RBhG+a5M1wV97mp7CeGGf0YhmD6NDtETVPnG4pm3ojom9uRABlnnn2//ROkzPP3EZluH1TclSSWwdkeKXfF3/uvSpyfq6C/tSh4bNQ1LEpddhAHuI2Ato8Oq+iAX7WYJRHSFj73/oCO5cj+umFbWFac+VIWRJja5+H3MbuM1bsHnB4tmo/DDxyC9tXeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 30 Aug 2025 02:31:02 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> The check of is_backed_by_folio() is done on each page.
> 
> Directly move pointer to next page instead of increase one and check if
> it is page size aligned.

Why?

> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -423,9 +423,8 @@ static void split_pte_mapped_thp(void)
>  
>  	/* smap does not show THPs after mremap, use kpageflags instead */
>  	thp_size = 0;
> -	for (i = 0; i < pagesize * 4; i++)
> -		if (i % pagesize == 0 &&
> -		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
> +	for (i = 0; i < pagesize * 4; i += pagesize)
> +		if (is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
>  			thp_size++;

Looks like we're doing more work.  Is there something wrong with the
existing code?


