Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FCDFC98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 12:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96BF36B0092; Fri, 25 Sep 2026 08:10:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 944046B0093; Fri, 25 Sep 2026 08:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85A1B6B0095; Fri, 25 Sep 2026 08:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62D896B0092
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:10:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE25C805E1
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:10:52 +0000 (UTC)
X-FDA: 85252168344.13.A9E51C9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id D214E4000D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:10:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Er6Bps5u;
	spf=pass (imf04.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790338251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mg3HEQa8NIKTXdpXPGnm06+R+w4VsRqksh/FZxtXdKQ=;
	b=MXywqUS7MGhdqYfDpyH78ao3LTBiCT1v50cEG6ShqBwzpg3g2PqWShC25PXq7FqW3oLgxj
	f04oCpbEVVn0WOsnD6Xj6DTjFE2MCIaqyvKNdmYfwLmQhPP35aH92RGwmMPqA+oSNPfJfQ
	Y+XRu+dpthDB1X7Sy+qZ9mFArn+mDCE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Er6Bps5u;
	spf=pass (imf04.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790338251;
	b=q0xUmJSB6HHebG/+WWWNWcXB7l6DnilpebVQiW31/2vJzFiOrjPDMsdnR5ZHmP6ZV1k0vl
	8C2CAR72oHJyJby6kTQ/nTOrdn+u80p+pmKCSly0z+DbadzbMFa1JGI+bV0hriIpqI2GEb
	QDSSD0fDujTcYiQDJ5Jcp9+/LbOljAs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44A1D1688;
	Fri, 25 Sep 2026 05:10:46 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E67F3F86C;
	Fri, 25 Sep 2026 05:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790338249; bh=NEYUebGz1uDI7Npr1A5moQGPlxhm/IrhMht840u7NQc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Er6Bps5u28i6dwAxosn/pPKCYRMfwt73pA1zVb2TfE6fj8cf/A5kmRyUPZv2+ciQ2
	 j1TBYB48z5UXdNCINevu8QF8PkZUhtuiQ5Pn2Ro5HP7OJI2hN54ESlSYvVJvlz7uGi
	 wFpSLMRb/mEw4Rs/Nt2uP+2z8wwx6+vbNNgTL11g=
Message-ID: <07f94688-55ed-407a-a11a-78a4feedf5e2@arm.com>
Date: Fri, 25 Sep 2026 17:40:41 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/4] kselftest: mm: prevent random failure of huge page
 split for khugepaged
To: Yeoreum Yun <yeoreum.yun@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
 <20260924-fix_split-v8-1-cba7359d882a@arm.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20260924-fix_split-v8-1-cba7359d882a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D214E4000D
X-Rspam-User: 
X-Stat-Signature: 8zmrky1znztu1fr4cttwanoj3apb3pbs
X-HE-Tag: 1790338250-993646
X-HE-Meta: U2FsdGVkX1+0yu7AhR0B8XPApXdobWhO86ROQKSMdr602T0/wC0GfBb2o/arLbqV6ddCozKV4nASDgjyY0UF2P7DOGw8OtdUH7HbBu5Jk3vHaIALOJ3ACa8YcaJShIa8oQZQhEOpKQ2ZhEBvU8Z/rnUuf6pRG+YJWKTi27W4ipIUSEUJWDr+xrLyMEkv4DjOMDQ/jht94E9QQSCHmTxfFR6DKc+ySR8EcNA61z/pfvjlEJ1qHVpVVR8HdhIoVh8rH2u4ismd5aKCUp+gqiIbyPI6no0rc/fuZmc9XX6H+9PtXnOZ5cBz9hvuOBpgwH+1Z3VqLIqbxQthL4k3Tqfdff83OwDIBdezHkErH+r0PL1t5y53KZ56eY6bhCrNQysrGSjT3Grlz9D2tqoypTtK7qHk18/hwffFM8k7cp5ZJ94qFYu7I0LC54nvc2Rc9G8hcppuBwNI+ysKXlHSSiFlIXQWwXkjdJgIp5k/9/GSGiVZ9X15uFrJc0Ix9xVx7ed5tXHFtXSR7rPlUWArDjjKHDTBpAomkKfGMcBpdsWIiBoinC5TiBCve9RKQCQO+Uxy3Lz18UZC+yoe2WfbVfIXdyYKw92KftzdMJ18gPI0lnoGHZ+ZdQTvH3kikRFvHD3Oh7u2JeWVPRQ3UYJXKbsWZREQwqsgArsmrp+heX5KxYlKzKZGeBASeapDniT4KDVXa7hXGJ3cSKZMpWPfZgEcUbsEKu5n7kOY2WFN9U6SGHbtMTaxMLuU6Z3q7SpCsLp7QYkOBozn9fgobIgGbXmWkjWe+TxSetkZ2u9J3wW2yW8pFtSG5Bw6Ss7pV1LDUBATNuL5mJl1Qwv6ZErrtEq3+2rJLXDFl6ZrhT0Y1Hfw1QCC8m1bMURUS2zSLv5vkZlKMEyJsGT8YtzSbp3ThdCP3BdG0fF2woZJWSTIVuGNVSHHBDcodWZbzHgel5hgIyv99xfMmBDKqznvA6ttNRW
 RHQ1wNx8
 rcWCuW3tRHrH1ESNnBki3fZ9tTC4A8xPchPsck7HYtN+P33ujDYQ/5vQxJNddqlmW+LMgQRC+qWKixie7K2jd6VZF7CpmRP52XWV8pFekI+eH5fjFDTxfwmDsRUyievc+jhGFczI3904wqD01sszUDFgJLa/mNxHD57Tn1Z1RyMnCGuub6vxd8uwUPAswW7ZOvdM/lnckVQ8XJsQKRjrmA1ixCRxyGb8FRB93U4EAnwq/HQWRWC1TVxozl7ZuAc7UF7/zTj/+gnsJb+zeXJ7q07UU3joDWuVWZDVpMX2YwV0p2NK1LwPSsEuyPEVxaQMeEKNtF1ziliXB8jkoYwUrPUgYjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/25/26 12:41 AM, Yeoreum Yun wrote:
> There're some random failure for split_huge_page_test when khugepaged
> collapses pages into pmd again which had split by the test.
> 
> Prevent the khugepaged's collapses for split page by setting the
> mapped pmd-huge-page with MADV_NOHUGEPAGE before split.
> 
> Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/split_huge_page_test.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index c5d96a4b1db3..ef4058662b91 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -108,6 +108,18 @@ static char *allocate_zero_filled_hugepage(size_t len)
>  	return result;
>  }
>  
> +static void disable_khugepaged(void *addr, size_t len)
> +{
> +	/*
> +	 * Disables khugepaged from collapsing THPs in range, existing THP

Should it be "collapsing pages in range into THPs" instead?

> +	 * pages remain.
> +	 */
> +	if (!madvise(addr, len, MADV_NOHUGEPAGE))
> +		return;
> +
> +	ksft_exit_fail_msg("MADV_NOHUGEPAGE failed, err=%d\n", errno);

I feel a ksft_exit_fail_perror() would be better here, since it will
automatically print strerror(errno) as well. Still, it is not something
that should require a respin of its own, so if you plan to respin for
some other changes, you might fold these changes in as well.

Rest looks good, so:

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

> +}
> +
>  static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hpages, size_t len)
>  {
>  	unsigned long rss_anon_before, rss_anon_after;
> @@ -120,6 +132,8 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
>  	if (!rss_anon_before)
>  		ksft_exit_fail_msg("No RssAnon is allocated before split\n");
>  
> +	disable_khugepaged(one_page, len);
> +
>  	/* split all THPs */
>  	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
>  		      (uint64_t)one_page + len, 0);
> @@ -167,6 +181,8 @@ static void split_pmd_thp_to_order(int order)
>  	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 4, pmd_pagesize))
>  		ksft_exit_fail_msg("No THP is allocated\n");
>  
> +	disable_khugepaged(one_page, len);
> +
>  	/* split all THPs */
>  	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
>  		(uint64_t)one_page + len, order);
> @@ -215,6 +231,8 @@ static void split_pte_mapped_thp(void)
>  		goto out;
>  	}
>  
> +	disable_khugepaged(thp_area, thp_area_size);
> +
>  	/*
>  	 * To challenge spitting code, we will mremap a single page of each
>  	 * THP (page[i] of thp[i]) in the thp_area into page_area. This will
> @@ -482,6 +500,7 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
>  		ksft_test_result_skip("Pagecache folio split skipped\n");
>  		return -2;
>  	}
> +	disable_khugepaged(*addr, fd_size);
>  	return 0;
>  err_out_close:
>  	close(*fd);
> 


