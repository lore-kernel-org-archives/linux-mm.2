Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DDCBC624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:15:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A83AF6B00A1; Wed,  2 Sep 2026 11:15:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5B716B00A2; Wed,  2 Sep 2026 11:15:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 971DB6B00A4; Wed,  2 Sep 2026 11:15:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F8486B00A1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:15:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0804F1A0257
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:15:27 +0000 (UTC)
X-FDA: 85169171094.08.7E20D22
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6E2E720008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:15:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jA50Z6Fg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788362125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=geLLc9OYOHH6RJHOH7p2OvUwcIlLmy1uLQiXbiK2XfE=;
	b=qmdO+UJM0HKvSEdx4VCNUYlweIi4jMy/4LdoNsGYoKVeJp2PDz5BvAO7l0cFLOMA5Qc/B6
	Tk0fFsuDVodfrPfZV+Td0Z58fqNAVcaRMd6O0bFSJzg8UVpwdFvXyKih4rKwcazZul8EUc
	dyMb5RKXtjwJ9n4N1CaO4qTuf+JxEJ8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jA50Z6Fg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788362125;
	b=Lg03JSkZAM/AY9FInUAvKqn9AEyYaX0TUS952h6w+J4j23xMXzcpLNgdn588LJ6Dd8dAhB
	LW8jZqofmVoJfElZYPuNZ8YAPq+PdXMW+UpFb0YzQKu2b7HpC7p6RsgTiBadosMrQ+hYRa
	hsIY+ZsrqaSFV8ckxSLl7jELeW0qY+M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E71B7600C8;
	Wed,  2 Sep 2026 15:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DDD1F000E9;
	Wed,  2 Sep 2026 15:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788362124;
	bh=geLLc9OYOHH6RJHOH7p2OvUwcIlLmy1uLQiXbiK2XfE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jA50Z6FgFOKtz4B3l8//fub6qKXdyUdDE5W7bOPXPB7K0hAdVjfJB9790JMkQ9tS0
	 FDb6SW92xBK/9UzaF6r3H4sJuvwp9xV0MD2h+NTDnYxfa7Hdpbabz+EVeWqOlGmd/I
	 jFRgtyJRex0uZ1/JRBfaPwFMHjhjrGOWdqfcAKDr7wicaGosAExmxJT6oiFzMq6Cx6
	 3dzI6+V8Mavdpm7AMMKbVvTAHZZ11ZDao34wA/BNAYROpvuhRvQ8rcxHVM4aJ5BhzL
	 MHjwtCXqXTccM8A+7FPNSejUlzocVjb9VS1FPSP77GrAIMZud9fCDgB+rhEznmQ6D2
	 jWr6+PZrV5toQ==
Date: Wed, 2 Sep 2026 16:15:17 +0100
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
Subject: Re: [PATCH v4 1/3] kselftest: mm: prevent random failure of huge
 page split for khugepaged
Message-ID: <apg7FNLtFO3Ea5qC@gremlin>
References: <20260902-fix_split-v4-0-85f03905f7b1@arm.com>
 <20260902-fix_split-v4-1-85f03905f7b1@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902-fix_split-v4-1-85f03905f7b1@arm.com>
X-Stat-Signature: ikeaysi94tkb7q8dazxf4kosn31r6xyg
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6E2E720008
X-Rspam-User: 
X-HE-Tag: 1788362125-94840
X-HE-Meta: U2FsdGVkX1/d+ALqT9BjPUm2DK5HtjJ7OI+Dr10s+omPPaNi8HdTNxZQUHO7k+wkG06GHoTu5DNuK5dxiJYAL7rMS0qLk/1p26Qk+AVRqcV8IWyxScT1jKJvAax0wkQxW1CxI0wiJbONSGA/CAhjtrssxzSy6g4NBFgFcmplffVMHG5E3aJGE2Qw0eIcX9QNR0C+gSuQyEXcdm8e7liGNKC0ZC9bpDd0oDXPT5qOczUJqOY3lRMw7EyW4LnKx9W0qOtCYHAmSLp68JKntaPYrqtgnZLNJGbtK00mrZyeDXWph6dWzAVT9DjHSAWC+kG6AVN8xAgYPS4J3aKqRfyUphQnFWmUnnVy/wjimMCxsvA6CYCPzkPoMEIi0k6PSe8IAiGyqtw5f74IxgVZ6SWyG/ZOE3hIVt51ZEOh8WbAPGoBbqBDA3w2OCwaHCt9zp5dHqcM13wQu8DbgnePO8cuoF3RUaJqA8LVcrq2adpfWkKoOOjHCMXEclMxuyxcTzdEfrvbDaJES2z94kzbf2BDR3s1xBAQIGx3ILdn0M8KPd1gVJzbiGE/e+Z8Vgb3GWWzbQn6RiNA1pwV9+fE5QzU7hQpbmKfdAKuQwiD8UnXqoR8f0pPX1VwO/DKy+9NpNfi+ECvPSsfET4gvP2254FzJW/GJ/Ye+j54wMag/wZpCInn2BM3RYCsJyv1vxQFlEL/CGtZFGSdRhrhe42FX7D0RpXNhuPCkX7wXCZko4iFEsxQVP+5gBqA/diUNdVzCGWoCTkLDtjT1yuGtnihebfsgVqwBlGivQTg1OGu42CQ2x417pq7g5aHluzXg/j/HPMrPLVSl1nRWG0tIODj/AzfZYsq41B9Lkp3SAs4Sx0CzsHehnCWCjvGlYK6jRcX9sWiuiCf58S2ryqh5nlE6L7YS/eN3NMKDUA3hBr5EzZbe10SlnJsZoozY3+nuzFdJXBLOH4ddZdJHlxzk+mUpiT
 exOLi388
 EdBEcRpbqigXbUp1QKVQiL9cpnqTak5oekAq12wWRlZw+OqZSi+Kz9VpSxPEVeo9lQO/g/9VpBC0LRzBRQui1wlJVra3b0MAmEvshgyE70DwTJWsC4QjrLsVhWoUbJymbjvn4AKrNCzKarSuTB26RDS9Y5yhexmKhtj2TGWnQw+N6wic7M7tzRbRsmx98W14ycgxzk/K1C//wpeSu5LpylseJ9b5A5lcfEoxW8VKJF5WIiDvCIy1vIMZgxIyX7ihTBMCeWWmFjJXkvHNjbu/owy1Heg/d+QUbDCOW1gRBSjy2i7f62KGuvNpq//CVyBRVefinn+GiZf/xWv8Ct/UKXk3eMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 01:09:35PM +0100, Yeoreum Yun wrote:
> There're some random failure for split_huge_page_test when khugepaged
> collapses pages into pmd again which had split by the test.
>
> Prevent the khugepaged's collapses for split page by setting the
> mapped pmd-huge-page with MADV_NOHUGEPAGE before split.

Maybe worth saying that MADV_NOHUGEPAGE doesn't immediately split anything, just
prevents future khugepaged collapses?

>
> Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>

LGTM, thanks, with a few nits above/below (sorry! :P)

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/split_huge_page_test.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 86a603692826..4bbad892bc57 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -168,6 +168,14 @@ static char *allocate_zero_filled_hugepage(size_t len)
>  	return result;
>  }
>
> +static void madv_nohuge(void *addr, size_t len)

Maybe call it disable_khugepaged() to make it explicit that's what this is doing
rather than eliminating any THP pages in the range?

> +{

Maybe a comment here like:

	/*
	 * Disables khugepaged from collapsing THPs in range, existing THP
	 * pages remain.
	 */

> +	if (!madvise(addr, len, MADV_NOHUGEPAGE))
> +		return;
> +
> +	ksft_exit_fail_msg("MADV_NOHUGEPAGE failed, err=%d\n", errno);
> +}
> +
>  static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hpages, size_t len)
>  {
>  	unsigned long rss_anon_before, rss_anon_after;
> @@ -180,6 +188,9 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
>  	if (!rss_anon_before)
>  		ksft_exit_fail_msg("No RssAnon is allocated before split\n");
>
> +	/* Prevent khugepaged from collapsing the pages. */
> +	madv_nohuge(one_page, len);
> +
>  	/* split all THPs */
>  	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
>  		      (uint64_t)one_page + len, 0);
> @@ -227,6 +238,9 @@ static void split_pmd_thp_to_order(int order)
>  	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 4, pmd_pagesize))
>  		ksft_exit_fail_msg("No THP is allocated\n");
>
> +	/* Prevent khugepaged from collapsing the pages. */
> +	madv_nohuge(one_page, len);
> +
>  	/* split all THPs */
>  	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
>  		(uint64_t)one_page + len, order);
> @@ -275,6 +289,9 @@ static void split_pte_mapped_thp(void)
>  		goto out;
>  	}
>
> +	/* Prevent khugepaged from collapsing the pages. */
> +	madv_nohuge(thp_area, thp_area_size);
> +
>  	/*
>  	 * To challenge spitting code, we will mremap a single page of each
>  	 * THP (page[i] of thp[i]) in the thp_area into page_area. This will
> @@ -542,6 +559,8 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
>  		ksft_test_result_skip("Pagecache folio split skipped\n");
>  		return -2;
>  	}
> +	/* Prevent khugepaged from collapsing the pages. */
> +	madv_nohuge(*addr, fd_size);
>  	return 0;
>  err_out_close:
>  	close(*fd);
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

