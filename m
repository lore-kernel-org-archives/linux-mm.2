Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDD42C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C819A6B00D2; Thu, 16 Jul 2026 11:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C318E6B00D4; Thu, 16 Jul 2026 11:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6EB96B00E0; Thu, 16 Jul 2026 11:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E9C36B00D2
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:54:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0038C0125
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:09:14 +0000 (UTC)
X-FDA: 84994368228.16.C6050BA
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id D67F81C0003
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:09:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fxANyK4w;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784200153;
	b=7A5ztcX2Msss7bqiw0i97WVGVAp21UHvtAYIUA+IYsJg9NwidFPgh7eG1m1ZCFIWsb6C43
	0o8FIXIrCk1fohBPL9+uq++gkWrdr9fGzOZQ3d+wkkRfsH2AxjgvbGj0Cye5EhKjkn/ijF
	AQ968WUPNqoXorYFBt+F3RMFVvzM7tk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fxANyK4w;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784200153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h1yTsx3ls+YvjdQeWS/jX2QyHQfYxjd+D9il0/AQ1vs=;
	b=cYATCB5K+dIFz/gNb4lID3UQLRwNmZHpudLnJZvaCel20LLCk0WNg2m8JHE3JyVqyjWwdS
	wB5BRFXmnkF1xSyxGRznHC88ygHFn6/lkjBfSbg5knDbmfD0Vr8wKpji4+BwvojKlltqDd
	TXouhLOwDe01akF1h6JsRFTBBJwu6Mw=
Message-ID: <4e5c8434-8b2f-481a-844d-a853da280d0c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784200150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h1yTsx3ls+YvjdQeWS/jX2QyHQfYxjd+D9il0/AQ1vs=;
	b=fxANyK4wgyTGyrYQ0x6CggvirMY4ps1TU+K/5JNpbA45lDQQ2b8sfx2wlQjKcANwJCzolM
	mM/tWpMJHbeDxtF848ynXR7Nk4jqduhcA/GFTbEQYNLvxPwYM4sPHA06C7/dCGqcYSD9qL
	EN9MlVGF5OxW6UKC2wxaHB2wRzXYn3Q=
Date: Thu, 16 Jul 2026 12:08:43 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] mm/huge_memory: remove unused can_split_folio()
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20260716100345.473473-1-kirill@shutemov.name>
 <20260716100345.473473-2-kirill@shutemov.name>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260716100345.473473-2-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D67F81C0003
X-Rspam-User: 
X-Stat-Signature: hgsg3o5shjbseefqh6hcmd8jtmw5b38s
X-Rspamd-Server: rspam03
X-HE-Tag: 1784200152-718549
X-HE-Meta: U2FsdGVkX19Ka0u2QCa5v4hA2y/MzWCeg/BRWBh15fIfuLjjrU/OtXEsI3aRmRArmL12gPUbnblrUgRCW05bDfH9R1OxXemtVzZMNSZSmmiMVBSO5ZUY6m3RrMrDse5/GzGOAEl30YQ/xBm2GLHh7JzprG2iA5ikkgO5UUrBEjd5x/1vPOKQjwOCUqEZvoHKRpjnW+oU/ZLsDw+C4suyeMcC6xowjwiWKevQm14dApMdwJthyVqJDVd7fAixSKAPyG+CpVQAQ4OYZ6QS82Mu6lxOQ0zWzCZA9Vm9CWUzrH19YOg8qOO/E7ESU3rGQBn4H0PU3/TqZEyCY66pk85hJCS12bTQWU9NN/dFsOjDvEfVufIcGybyfcmq7gbIuDHFFaaOHIrZhmo+VYwNpjjYHsRI02fsiTikQBla4Y5kqDU7VyUOhUAOWVdzg8WabrMBS+a0PxITkebH1rOyc2st04oJdOCI1+tRDfXHjSFh5QXpDtiVzFuPp/Vj5CJVHq2y7QyNdOQmuvenCC216xl3tlynYVcW6R9DT7AJb29B/10O1rBf66dQe92zh51Z4obczU79QmXyE6sKvADiHw6xM27GTUWSlzqfXPBG1oOGzR79Uk5xOpKoKMoujbixaNMeK4ciBpKy4H3dfOAuC3wFhjkxjuQ+L9NTbIEq+R8w/BGUwrIXDLO5Li/vPpC7GcfFmLc9YztBSikEmH+nv20EAdpoC4lsZRiMyszXj6DR5dOisL6LYMkDe2na+kQc472I3ojPl07WTscTv2jl+ZAml0u/MntBdwdVX2hvtEa1sRzrl3DmwLuxtjMQ+F+7bISg5LwNQu3z1UmeEu7m+1WgWZBupg7+1jsSEZ9waFZ7VdZxLM+xPlpZXU6DLcz6Wnh3rT6SI8DV2ttwPWX3RSOeg/JtfB18d/bBhAV7opV0JmiIxuHq1FrQK+P5pIHL15RGfDC0HEu8E/6h/SLr5mX
 ldLkd/0B
 EX12XCuKLyLQDhfwLNBZ1Uard8NZQcGZ9Uq6JgGWLgJ25Tj5+252pB9kDFicw72pXp7JRU0bZVwvUgYXhRYNa0Gukakp8M2M2t1qQUsW5btxdFbIvnmiSEgzD4HVIPgllGbunuP07rQJAq4bzi2+f2QlZH8c85zi17WglfY9NOAp9mw6oUKhYsR6Tv6xpFVo92LrWU/07RAQp3Pp6V0mr+kyIyK+iyV1x511ma7/d+5IdwQLXgM7DV278qBkBNbmTqnOr2FzFv+8pKPWi0JU9VWVjUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 16/07/2026 11:03, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> can_split_folio() has no callers and no definition under
> CONFIG_TRANSPARENT_HUGEPAGE; only the !THP stub remains, left behind by an
> earlier cleanup.  Remove it.
> 
> No functional change.
> 
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  include/linux/huge_mm.h | 5 -----
>  1 file changed, 5 deletions(-)
> 
Acked-by: Usama Arif <usama.arif@linux.dev>


