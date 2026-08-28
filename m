Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A308BC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 09:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6F516B008A; Fri, 28 Aug 2026 05:39:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A478D6B0092; Fri, 28 Aug 2026 05:39:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987146B0095; Fri, 28 Aug 2026 05:39:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71B006B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:39:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0806E1A02AD
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:39:28 +0000 (UTC)
X-FDA: 85150180416.11.108E62D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5D9F540007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:39:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sto3diAR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787909966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LcwtPFDsGrgdCaDCg66fqoG97Ouh7ZMZoj1sJOxY13o=;
	b=PxbBZS7BTb3ivcTGHzwtdjxFkN/mHWVnBaxzxx23WCKRyZZ9XVdqBGt0t2dDU+mn3LuqwY
	Rm1JxbqwZZ7UJZV6de57P1hMDQ95l6zBY1K1AbrSteRPKL0i0joEJbD4xhUzL5iFAFr/9t
	xbVeIt0xC4A03Qu34AXwLk4P+vO+WB4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787909966;
	b=bTtwETFEoD5HE2F9kP0xRrdzuTLml7LC72I+SzfhFMRXiY3TpLANGuwag+Z+MscNTuopZy
	HMmcFzBCxTyz/D3u8wpnHtewAFxjP0C6K5//3LTwSuONTUgDV8QjA8TRlQphl2JdDW8mpv
	8ownFdSyqZZTjvb/5/X24p/Ejh4YISc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sto3diAR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BA4E409EF;
	Fri, 28 Aug 2026 09:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35EF1F000E9;
	Fri, 28 Aug 2026 09:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787909965;
	bh=LcwtPFDsGrgdCaDCg66fqoG97Ouh7ZMZoj1sJOxY13o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Sto3diARgnSgihsBVkQyf2L4hleE9pUpjugWfj7HFQbJ7nIWicQiyg9kl6aXmpQ8B
	 kJhrfTXxUAN2JAtxD2Ng4Bn72SdgEXPHNledJdxXAA8W0TT14DgOOkI8zSdLeLvUV9
	 czM4iTcmnePZcdrsk1ttZE70YEqa8Qs0oVnjsje2siEQ7nKXk2Bh6gyyr03U4YNTeQ
	 RZSUIvXrf6bCrhIqHpzBiYxdnBXq+9YFYvdVhKeGs9pxX4ubGbe8f96RdSVKJmx86q
	 qLvqHIBzlxmljjNRS2z56YiQ4n3YVKsN0uNnmOm6TdT29XosbKvCeQ90sqqPLXOXlK
	 cIruOBdDZE5Zw==
Date: Fri, 28 Aug 2026 10:39:18 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] kselftest: mm: prevent random failure of huge
 page split for khugepaged
Message-ID: <apFWAppcVKt4xhIT@gremlin>
References: <20260828-fix_split-v3-0-374022586a4b@arm.com>
 <20260828-fix_split-v3-1-374022586a4b@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828-fix_split-v3-1-374022586a4b@arm.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5D9F540007
X-Stat-Signature: yfwb6474eb746bgoq5enhptfbi9yn77b
X-Rspam-User: 
X-HE-Tag: 1787909966-320261
X-HE-Meta: U2FsdGVkX1+6ZfYAc/TNYb1wYYVV/rwolyfkSRJqhuPoLLBgHPy5d/M60Xf5pkIbNiWOTK/apdkLYmHahi4CDg+WT/elhiMzB19iVpL9o+63J0+gcXmZLo5JB+YRfvJb7Lri9NOFMNymbmmXzbxovtNX8K1IOZmU44e/SVI2Pes/qCpydx/qndQKhTH5ez+7NMXo9GJ8SM0dXvsfcQrBIJLo9DynD7bhEiC4hsPnPGzBu7PJPS1kzxlJLP7wM4WvI+1/43JEOnzo2IiisNsoDXvusY+6DX1gR8OzdylZ4I3A676ion4EsbPfv3HpbcKRqB3ZzN7/B/yOwu44EwYAf5+S2kNrZ+8KuOI8s/+JnXjLnQLwHSP3S7bEEF9DxwYyS6ncIxIx9Lm4ZoWQb1COUyvqLEBd1UCTApMxHPfkAl1zgXaON5K92nzhn78xT1aHU7r0YT8/obZZcv94N+0w+ubw9S4X/HHm1C3suDlIm6Ad+2OV9d316F0YM73mSBO8hWgq/zQ39PZAMLwsBLVk7UpvLtQGvlqtPOoxG0ulqeFisOgvpKZLHSCVChOxgHnWZ+vQpM30c8B/w4BzeWlojbvPrWJwmlR4KT1Omp5mtjMq066FB3baeJfi+f1PLCOttxpvL+VImUHbtY/6SqjmyyauHkBXRt1zkWLS478CH8EJzX7TJhISJhaOxZhP7VSTGAb7cGUIuV8KeOj1ZdAmqPLpSDvSJu7g2FA60tk2Ux5mRRXij5twHjk+3HENITUlBvwcGFpOCrr6Bg6GgNcDG2b7q8kw56gIEQf6UDsWbt24ov2OkwUgdN/HtR361Gb0yE7xJyK53AJ4VTgLmK93eLeCBKmIUGzrmjfvN86q2n8xQ+Ia8lg8sXWRY1zty7nzyYbdQsawryBtdzHRVcqbuyBOHZHovDILd7vnzBjI00RrwfhN7i0KT8PBF5LsVLaQG1xlOQMH3C1Xam/a7ax
 aJQwdqib
 O5PaXY/wre+2jYM1rzzpU3LWFYwbvZ4P3olCKQPRMGUomzCQod1tqHwU+lX52CjJzR5NJv2mK7ZBeh7vOF3CeS5Cn8CuAGTIjh8c5N89NI+vT7jUFN+MVSB7fuGUFShTpSkZ2vPIe6J1Z8h6us/u6YrAmQdS7LsIYkAk1Nz9Mm8oPU+qcxLPrqzwL1d30okYksq8cWg7FqpUDnmk70UwKkFkHwV1AjYVqWGMqX3tjH7Ael9si8FuOKIpU70SMC0dkqpwZ/+rGec9IXe2E/24sYaxr4YrEdKOJvsCDAt4N4xCEm80vwnX9BTEXKtuRjdLdtAN0Zpv5pmVzlQ3owOrYJMchWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 09:11:33AM +0100, Yeoreum Yun wrote:
> There're some random failure for split_huge_page_test when khugepaged
> collapses pages into pmd again which had split by the test.
>
> Prevent the khugepaged's collapses for split page by setting the
> mapped pmd-huge-page with MADV_NOHUGEPAGE before split.
>
> Reported-by: Kevin Brodsky <kevin.brodsky@arm.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/split_huge_page_test.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 86a603692826..c718269a291f 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -180,6 +180,10 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
>  	if (!rss_anon_before)
>  		ksft_exit_fail_msg("No RssAnon is allocated before split\n");
>
> +	/* Prevent khugepaged from collapsing the pages. */
> +	if (madvise(one_page, len, MADV_NOHUGEPAGE))
> +		ksft_print_msg("madvise(MADV_NOHUGEPAGE) failed\n");

This should probably terminate the test no? There's no reason to expect this to
fail and it's better to fail then to risk a flake :)

> +
>  	/* split all THPs */
>  	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
>  		      (uint64_t)one_page + len, 0);
> @@ -227,6 +231,10 @@ static void split_pmd_thp_to_order(int order)
>  	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 4, pmd_pagesize))
>  		ksft_exit_fail_msg("No THP is allocated\n");
>
> +	/* Prevent khugepaged from collapsing the pages. */
> +	if (madvise(one_page, len, MADV_NOHUGEPAGE))
> +		ksft_print_msg("madvise(MADV_NOHUGEPAGE) failed\n");
> +

Same comment as above, also since this is a repeated pattern, I think it's worth
abstracting it like:

	static void madv_nohuge(char *ptr, size_t len)
	{
		if (!madvise(ptr, len, MADV_NOHUGEPAGE))
			return;

		ksft_exit_fail_msg("MADV_NOHUGEPAGE failed, err=%d\n", errno);
	}

>  	/* split all THPs */
>  	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
>  		(uint64_t)one_page + len, order);
> @@ -313,6 +321,10 @@ static void split_pte_mapped_thp(void)
>  		goto out;
>  	}
>
> +	/* Prevent khugepaged from collapsing the pages. */
> +	if (madvise(thp_area, thp_area_size, MADV_NOHUGEPAGE))
> +		ksft_print_msg("madvise(MADV_NOHUGEPAGE) failed\n");
> +
>  	/* Split all THPs through the remapped pages. */
>  	write_debugfs(PID_FMT, getpid(), (uint64_t)page_area,
>  		      (uint64_t)page_area + page_area_size, 0);
> @@ -542,6 +554,9 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
>  		ksft_test_result_skip("Pagecache folio split skipped\n");
>  		return -2;
>  	}
> +	/* Prevent khugepaged from collapsing the pages. */
> +	if (madvise(*addr, fd_size, MADV_NOHUGEPAGE))
> +		ksft_print_msg("madvise(MADV_NOHUGEPAGE) failed\n");

Obviously same comments re: this and above

>  	return 0;
>  err_out_close:
>  	close(*fd);
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

