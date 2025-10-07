Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54FFFCCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 22:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 836C78E000B; Tue,  7 Oct 2025 18:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80DB58E0002; Tue,  7 Oct 2025 18:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772758E000B; Tue,  7 Oct 2025 18:24:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 67D678E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 18:24:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 166601DF37B
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:24:33 +0000 (UTC)
X-FDA: 83972748426.27.F9E8CE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 50B95180009
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:24:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ukVAcROf;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759875871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LQm/B6eRdvax88uUNBIPNHfsZhMqnMGJMaJzqQjY+jI=;
	b=C2wLsxZMq6fPcZazz5IP55PXYzTN3qyqD067UaT7eQhfGDf1kwqASBK34q/I/QnO9cto++
	Hmh1y0QOVFBtPGml5+qVVbS37Cp89WePmVYoFYLqDMOStgxTTA9JM2unJTBE6HCsz/ViUr
	mqELm7/2vtsrOIykGJbN9+IUAht4qNc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ukVAcROf;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759875871; a=rsa-sha256;
	cv=none;
	b=0hx7i/YT4YpZR/F8Ea5ekmD7ONzGyczh5hA3TzYr9xq8LRLWus5rfljT5fBnxvlC6PayBh
	cgDxPI8lATP++06f9TbNrrwfu6oJ6E9HSkwifFpzNogsoDG2E5RXRcFSD83YFixY+6KAaA
	iMJ5Ud1SOW31b3Lskh0yh4k/NbhUh3g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A38C361CE8;
	Tue,  7 Oct 2025 22:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B19C4CEF1;
	Tue,  7 Oct 2025 22:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759875870;
	bh=Ml84U/0i9HzLrJRmaMZo5f7luB6RAPc/Szfx7x8g9tc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ukVAcROf2a+EK00QUVF/+Th7XtbBmcf75QzTUS5DkMOhQeTmhSUDaHWOcQeDG5qPl
	 tiq6f7AjnoSWOaECe6PHNsHURztv/YQJbCdKcJY74XphlttG9dYewY7jaeO2D1evAE
	 bS1dBJJBf2QspWIlOKXJqpeU/Aato4K68DMlAZGs=
Date: Tue, 7 Oct 2025 15:24:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@redhat.com,
 linux-mm@kvack.org, hannes@cmpxchg.org, riel@surriel.com, kas@kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/hugetlb: allow overcommitting gigantic hugepages
Message-Id: <20251007152429.4c28fb85205635703229b027@linux-foundation.org>
In-Reply-To: <20251006185607.3257340-1-usamaarif642@gmail.com>
References: <20251006185607.3257340-1-usamaarif642@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 50B95180009
X-Stat-Signature: njkkff5rfmckmwakpwsodx4ush7xc4qc
X-Rspam-User: 
X-HE-Tag: 1759875871-775445
X-HE-Meta: U2FsdGVkX19410Lut+30JMAAZuds0hFi7PwIqpv5Nz21DzpeFW9BhGAm0M7LpQ5e6c/xdcNEnXIPkcqMHhtaJmKG/9cYl8kT8S8cZ8OUwTOZ9WmGhZjdW4MfmdoqBYbyuU1f9yr6dI00zv45P+mpJV1pCWtO2V6Ei05f+ljVKEgOmjZbTP0jdLk0XGF6dhmInWokKBiNLQWYFXqJ4GhT0MxiqpWQfhSc5xBND3UA3S1bPTFaKmb7mJPz0SzYyoiZA91cQYOCKOnwUVju8tfjts+oRvPaGfIpmmw2IjHHzuAj7jX+bBvw53bEKeqCfolU2ofSJ65g+1GSPvvbLd+86Bu7iTWBGOhjtCrmPNubcmKTZ1hbPcn3qG7783s27ujtfnAm0X2gCne2DGMEP9WP+sd2tbmN8KRUO9DWFBcXpUvFDywP+uskh4qHHMLSsaE4g1CgolNOdE693eGkdeP/NlS6vRK2xxB0yzLFlAsbTItQpNZAEH/V9yU34YBMgdPTaSfPPRN4F9itZWuVneIdu1U0rnzWlunTsySUQ5RRqx11Q/gVwDpH9OkskyWmyn54cErGnrf1X8D6AWmkZvnAG2GmUw+kKqTgdjTeoo9WmGEUdZo9QLUn64qLnp9CB5KcughmfiLJM9bEFow2xZZYxKFDSs03LzL03HWzfJxk3o55yAvZ+/875qMEUEa1DhXIjko3YiFEUUJAYbXlFMV/wYuzHJ9farTGIomO8TyajxKSoHIb7FyyzNNm6UtrEg60QLqby+qBaqOZD/VqUUv20FQ0NjG23nbwt1CGMu1vib9D8OSdxfwoh86qlMKdUk6ygXXd2IocVSnRk36eSZj55DAqEDE1upthndmUyY2nxshYN78l4K9K/iDIgXv1OzrXcIFNzrPpZJ7xfYQjU7WO/yAKod9BxYTbaAlVQof0Kdzz5SxRvQGOmUZ9ugthj/yGSuSDkm82MCp8SPLzcK5
 MvEXTUQa
 2aBwdcVVft8BItFsrxNDpj0ZMBfQ5AJPXfqoUqVfzkvQBF40VLhFHsxqpwXMA/c4B9ykVVG8Qt3/tKfjHm2q1Xek0armnrvWmcW9CXsbDcWrnIa9Mfz4tWyh2Cix0Qsam4oa2n1LHKGsQfmNXPBKXFp6Mb9a9SaYLR7od0Wf8HhZ5bRQHXGdFWFXtr3l0LI38ebc8cgmYXaJb8jyfsiWlNGaIY52x99Xq09KmKOa5RawHuUl2bLIVWiEgPJ3yNU92wFtLm8z+GfImgGc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Oct 2025 19:56:07 +0100 Usama Arif <usamaarif642@gmail.com> wrote:

> Currently, gigantic hugepages cannot use the overcommit mechanism
> (nr_overcommit_hugepages), forcing users to permanently reserve memory via
> nr_hugepages even when pages might not be actively used.
> 

Why did we do that?  Just an oversight?

> -	if (hstate_is_gigantic(h))
> +	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())

> -	if (hstate_is_gigantic(h))
> +	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())

> -	if (write && hstate_is_gigantic(h))
> +	if (write && hstate_is_gigantic(h) && !gigantic_page_runtime_supported())

Maybe a little helper for this?

(Little helpers are nice sites for code comments!)

