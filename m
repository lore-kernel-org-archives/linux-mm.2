Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17347CD8CB9
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 06:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E7AE6B008C; Thu, 11 Jun 2026 02:19:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BF226B0092; Thu, 11 Jun 2026 02:19:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3DCB6B0093; Thu, 11 Jun 2026 02:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD4B76B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:19:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B20D1C1B89
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:19:13 +0000 (UTC)
X-FDA: 84866629386.27.9A3ADAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B25934000C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:19:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PhLzDqo5;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781158751;
	b=rvfLcYU06LQWDK1rF6ddiSXsa9cLBdS42jxAfIB9L8AoH/HmDKysa7Ka6KhjiRqo1oItDi
	0iHhK4gDbuDb+vhXO7e7XH6c3X4IaADW2uARYrCfCayprPpsDr83ZC++XkgxNF5acwsGlH
	0F//z7kyX4YG1wv+AXKPk8tG0M2msq4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PhLzDqo5;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781158751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6aSwxGmpETKMO5gOuGeJq7TjqE4KH6CoAq7LEyPtOgA=;
	b=GzdJAqnBznj5340vJz9BaoRQZn+hCb4d7LJustOb4Blnta1saufmLn49RFNqbiO6hDRtn9
	ZkuIap6z/EJMOeqzCvbpQN3h4vhRAdTXZre0Uw0aXoy1K/nzDqmrUkY7gBF/NLouLM8F4R
	RABt9CCJxH2O7fur/9IdrlnXuswdBTM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 93DCC40860;
	Thu, 11 Jun 2026 06:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB3B1F00893;
	Thu, 11 Jun 2026 06:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781158750;
	bh=6aSwxGmpETKMO5gOuGeJq7TjqE4KH6CoAq7LEyPtOgA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PhLzDqo5Cvrc1JYXyvEiz6ZvyzPSZs0EJwhq36Uf6vxl5qrM08p7VaOaG0m1oep+w
	 n9B1+3LdImwuDTcMKpJzcT30v77sbUKgMEXEWBSatXHD1IKWvCIDFbu4+cm5DWqU+A
	 jpokZDBR1qS4saVx83JIZ8PCml2r8hsFEgCusas/Wwjby17a08Z2WGqJ8euYVUkwnU
	 UXSqgZYrHb8ijTXvOuIfKlLcqxnEZre/RTMh0cauC5r4tQCUK0niR6sZu5ntaBFXqs
	 4oaA9r182MOJMtSMYnwKz97Sc3M3621e/hask6ityxPBJQsoe9UM5BU8SsU9KLp+iw
	 jOgzrQ3ToKvrw==
Date: Thu, 11 Jun 2026 07:18:55 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, hughd@google.com, 
	willy@infradead.org, ziy@nvidia.com, liam@infradead.org, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/11] add shmem mTHP collapse support
Message-ID: <aipSe9Snx5x0esQx@lucifer>
References: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B25934000C
X-Rspam-User: 
X-Stat-Signature: 1x3dbud699uiwa7eb6mao44yc7gk5g3d
X-HE-Tag: 1781158751-24710
X-HE-Meta: U2FsdGVkX1/xv3OIpZr0oQxAmTcY2wDSzopBC9CL9jxyNPBWRoOLsQWARZhlLa2dMce9skIvHMUFcUuJrvsuXUDSGJf8tcaoIosqcE17hk6eXa39CM/Q+6FDor6bqv9kRv28T9SlRZ01MaiZYFeK5lpoZpQNZl7o/FcAB97wolBAg/jlhrkpPWfim4f3pEN6/StNt8fTEV5n4togT5yDVUo1idl7zKWgsg1bznL5yJvl5SUwBmVlItjdqJvucoqQol2a4XiOZoys3OIyCq75j6eLEaQuW6j+rIq8A/fLnfc7k5wiWI36eJpdzP1cV3NusDrjvMmut0w/sKR2IH9o/fWO1A+Ch5gAJ2UhVBtks6UGzyo/1vMMLtvFg57B4Bn6MTcYQPUqhsZfZKEmdlqtjKiN5pz8fwFgiw3n23lrlPBG+bsDT5oCThFxt6YC/vj01HxnOPuhOHO/rwPe3LygyfIdWVskshoBN+I78DzXf9CWudL+DJzcO6jN8rRAOlAqerTxN7ku5srhBaEvabNvv7x7RnKUiUng/Kxw/63UHxAVhR/cjxRFkcbSznbG75m7KsJSXLSDMoesERcS+TFrZuXX5DFZIiofxzBarBNYeTVGwCcsFFBr3XBFJMB8XpsUyep4xVjoH7veesrUkl+9CPCuBG5HlSkGUuHM6C8ZMcvzesuuRdWrhRN7ryN3VgFAhAAeEaFZpB/o5f7Ibg6jPZv6Zh9YdnHfqxnGJnmE3CVqOBfq00H26/G6RWarw061+FW2ym9nh1Qnn6Esg6iuZNgOLtg6F0wKcefCIfMmMDFPPhbBPZ2hJjYM0y3le3RamTVZTG4TBDa9TnPmIBrK3MB3+NtlrQ+0n2EZl/e1S+4bXevNjVqaC2O4eWoVK6dlOnc4nCMJOQ62YTBrujx08/6VpKiTcUWryUT5iAx9lzhQS83f+Yj416NZaNSITiZ+VGkbJrlpJsRW4UkVuL2
 80z2Y7wc
 i1f/SuIfc1K/72GsjN+Is1EFE7xHN2nJQjNhz0/o09+LIfrMPLFScpWsW77GOAnAajYtJICezVWtpIPR6PfYkfM0yozabV5OK3+9IQJP5gf6Ufb5hYdXGJZq6cXxdVTjJWgffZA9S1QieNeB8xKH/JrkSMMF6aMJQ3ICYHLpi5uEsh3DGciYLtasKwFcamZRh12MAgHnjM5/n/6knjg+ehHsXGd075ku0kyBomNwG+OYQ509tGKNcVUbsWj9Zr86vKbH/x4p8LZHOdK7qUQGIBa0fIG7pYzKZJnRtdD9s/gKicb4xQ66XA5rY5bzgJuh3WYvh1mTsz/A01A0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 06:29:08PM +0800, Baolin Wang wrote:
> (Note: this patchset is not targeting v7.2, but posted for early feedback.)

Hi Baolin,

Speaking broadly, and to repeat what I said to Nico - I'd like to
re-emphasise my _strong_ desire for us to pay down technical debt in THP
code before adding any further major features.

Really I'd have liked to see us do this _before_ khugepaged mTHP, but I
didn't want to put Nico through more than he already endured with that
series :)

So I'd really like to see some action on that before we embark on any
further significant changes.

This is no comment on your changes, just something that we really need to
address in THP generally.

Will try to give some detailed commentary on the actual changes when I have
time also :)

Cheers, Lorenzo

>
> This is a follow-up patchset for mTHP collapse to support shmem mTHP collapse,
> which is based on Nico's patchset[1].
>
> The shmem mTHP collapse strategy follows the anonymous mTHP collapse approach:
> track present pages via a bitmap while scanning PMD ranges for collapse candidates,
> then use the bitmap after the scan completes to determine the most efficient
> mTHP order to collapse to. Built on the basic framework added for anonymous
> mTHP collapse, the shmem mTHP collapse implementation is straightforward
> (Thanks for Nico's work).
>
> In addition, I have added some anon/shmem mTHP collapse selftests, and now all
> khugepaged test cases can pass.
>
> Note: I have not yet enabled large order collapse for file folios (file folios
> currently only support PMD-sized large folio collapse). Although file large order
> collapse would be more straightforward to implement after shmem mTHP collapse
> support is added (requiring some changes to file_thp_enabled()), I think this
> still need some discussion on whether it is necessary to support other large
> orders collapse for file folios.
>
> Comments are welcome. Thanks.
>
> Changes from RFC v1:
> https://lore.kernel.org/all/cover.1755677674.git.baolin.wang@linux.alibaba.com/
>  - Rebase on the new code, and update to use the new functions.
>  - Add more test cases.
>
> [1] https://lore.kernel.org/all/20260605161422.213817-1-npache@redhat.com/
>
> Baolin Wang (11):
>   mm: khugepaged: add max_ptes_none check in collapse_file()
>   mm: khugepaged: generalize collapse_file() for shmem mTHP support
>   mm: khugepaged: add an order check for PMD-sized THP statistics
>   mm: khugepaged: add shmem mTHP collapse support
>   mm: shmem: run khugepaged for all shmem mTHP orders
>   mm: khugepaged: allow khugepaged to check all shmem mTHP-sized orders
>   mm: khugepaged: skip large folios that don't need to be collapsed
>   selftests: mm: extend the check_huge() to support mTHP check
>   selftests: mm: move gather_after_split_folio_orders() into vm_util.c
>     file
>   selftests: mm: implement the mTHP-sized hugepage check helpers
>   selftests: mm: add mTHP collapse test cases
>
>  include/linux/shmem_fs.h                      |   4 +-
>  mm/khugepaged.c                               | 174 ++++++++++++----
>  mm/shmem.c                                    |  10 +-
>  .../selftests/mm/folio_split_race_test.c      |   2 +-
>  tools/testing/selftests/mm/khugepaged.c       | 195 +++++++++++++-----
>  .../testing/selftests/mm/prctl_thp_disable.c  |   2 +-
>  tools/testing/selftests/mm/run_vmtests.sh     |   4 +
>  tools/testing/selftests/mm/soft-dirty.c       |   2 +-
>  .../selftests/mm/split_huge_page_test.c       | 139 +------------
>  tools/testing/selftests/mm/uffd-common.c      |   4 +-
>  tools/testing/selftests/mm/vm_util.c          | 184 ++++++++++++++++-
>  tools/testing/selftests/mm/vm_util.h          |   8 +-
>  12 files changed, 492 insertions(+), 236 deletions(-)
>
> --
> 2.47.3
>

