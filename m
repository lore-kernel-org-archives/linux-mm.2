Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D569606D809
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xeRQDtml
Received: by kanga.kvack.org (Postfix)
	id 12FD76B05B2; Wed,  4 Nov 2026 08:22:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1094C6B05B3; Wed,  4 Nov 2026 08:22:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 047D76B05B5; Wed,  4 Nov 2026 08:22:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE71E6B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:22:41 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6176D1406F4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:22:41 +0000 (UTC)
X-FDA: 85397501322.27.DCB6F0A
Received: from mta0.migadu.com (out-203.mta0.migadu.com [91.218.175.203])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3858E4000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:22:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xeRQDtml;
	spf=pass (imf07.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.203 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793798559;
	b=6uk1yLwU72o7Zwx1dSixSAVzHjGWjfXDfHJnmVw25ldq3RVrPl97VaEUB+9nMTPqWuzHGu
	xjqSl3cA/PSUwHagDP9vYtP3Er9DaJqD3GytcRQt/YXDSfMPxB8xNsxSt4eNOeZlxAREag
	XyfLHCKt3eCZxcw1FBas4w9Q/13dz68=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xeRQDtml;
	spf=pass (imf07.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.203 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793798559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJLp1C61ZMTzYyDI1094DXPw0QeoLZ9TuClqgP3WcCo=;
	b=vmqpWb/YmJHg/zhLoFue9YwMmXrsEt0tF2WoBq/EwoFRGFhzgwSD+455sRXNoaImmOVKr4
	uwq0T/L3PLoX65zOKNwkwU9MB32X8FbR81+Ikp9EoShNGYA7Fhsg3rSW+Qtx0EgsN596MP
	HOi8/uRb09Clqf0wU3YrTwyjvgdnlCs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jUJDOuWPwhfc5ioY6VwjRsiAmlQlmYoBB1u+kPlxRXw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793798558; v=1; x=1794403358;
 b=xeRQDtmlQWyfLPfmAyq2/c/j715HB5HtOQHH6h5RFPtHbrR8D0QfolUIf44z8+J3bDxFyI3T
 4dnoLaxH7QfmLRz4MGMW7fxYxTjnzAO08EI9+BEsLlRcwLBXJ/ANQ2SMSaQZ6TawAdQf8Na0oeP
 8acjarK+F8KL/3s31DQu6e3A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9af1b8cea7f251b8;
	Wed, 04 Nov 2026 13:22:37 +0000
X-Mizu-Trace-ID: 9af1b8cea7f251b8
X-Migadu-Flow: FLOW_OUT
Message-ID: <0fd8f5aa-2636-4171-9300-3e04ab98d393@linux.dev>
Date: Wed, 4 Nov 2026 21:22:31 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, Chengming Zhou <chengming.zhou@linux.dev>,
 Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: test_zswap: use the total RAM in bytes
To: Sasha Levin <sashal@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
 Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
References: <20261103163919.641249-1-sashal@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20261103163919.641249-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3858E4000A
X-Stat-Signature: o79topugumu5uaatjj7az1j8mhtfoxrk
X-Rspam-User: 
X-HE-Tag: 1793798559-182677
X-HE-Meta: U2FsdGVkX1+6h9SP1T2amwMmR7eU6qcYP4kQOgGhw6LOWQuL7ZCC8jZajqXqSPjSfnRKhRdTb0SkemOJhw3qqnlxOxLWPxec3oZh/fovsKlU89TDLjWR6Dlxn35NB+2ndOwZL3RWolzZraCXnjJuqxCLImpXbU30w7ANHFIUC9Dee162zjr8ZdXRW0VHFFgVGVBk990tpsiW7yP3Bbqng3ng3voqOLWZ2dKNosIJKrbKofRDckRh0cgoCR1/3gMNeZMopiPdWoWYMBJ82rdhYzDRdvNer2gX91xI2ZkJIFzf6S2W159preA4a97OlP2SBx6vwkfAxElUEKszrB70rdAgaily/2ODKqKCj0zFkclPJ48D6Es7/eKFWvvytEadB3HDQQ2HSg1d9M2lQmsowLU4MSAYWvVqRxRtT7E7qV/Jy38qEoRGZtgD8L+3J0FR1wIux7mdaGmZF5cPNClICt4SeUwvR8MR3p7XqfwordgmW/rNKYOuCiuUbUi+eAHts8KkndUMlL4wKcTa+EnDJiaIodP4TaGJ/yb6bjenuWBXh4Yj5cYFGezd1YrnkuAWYInpFSCxnhPopgagRWU90LhaupDTPw705+Xn9v82JKuT8qvZKvhcBqoyMZ4rVqfGY+dGPqcJd0qEaEhYAgttBGCQblFEB+hgXeV8IgJgYGGpsXXF5SsDuNvI0ZZjClypvb2wcYUlb7+gpeagKkr1ivgdOnJGYUGrr+qOJNgRFv6f2njXSAfyTe3fJ5lkHKsM4AO3cbVBF4WsSAZsBaZ3kml5Pl8h2IZG7Tzs11fKunIxRzzRNKt5uts4UB0X9tRTgCkb63jfwhvF0dTn59WzDSRaOZ27hBDduTjfxvsK6tNQdTlf5XvPoyXVeBX4eA75AQjnT+gmJ4mVw5gdUJxXeC+cearZV95LBFfFmnXEB2J8mX8fHBTVEKi/uyCMkIlcSwuCo8y3ENmtZPFYkaA
 VoVGoXjt
 A4JvfJNCyLjFgr79ZyOsAyG2SmMpr3u1+9VPomeW9Dtg9lSMuhtomboR0JsQB13AXQr8HwWyZ28rdzedqcQkSw53jyuETQeqt8tFmc9dfxeKCWMrDTClnUjJ1fFk9MvkSWAo4JQlpsU6OECkd4HppUeOw8LlJXSRtwDHBRQUBaKTVU0Rlo2dRmTNOrxTicTS0YTxG4OSP9+vDOudXgEEWqB6ZyowVoaR1rXmGwMfzt3acsN+/fVBtZ92zTL7rVRnboXP24As4Y7KbVmto/Q8hvnAoTqhS/5QV0JlVCoxvMKcyAJvgY6aZ/mTKr3nTwi/QZWAhm504/yAJ1CDZ1y4Vz9I/sbh5A9tx6ndveKX/+ElwjAzuaHpLTTcTWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Sasha,

在 2026/11/4 00:39, Sasha Levin 写道:
> test_no_kmem_bypass() uses the totalram field of struct sysinfo as a
> byte count, but it is in units of mem_unit, which can be larger than 1
> on 32-bit architectures. There totalram also can't exceed GB(4), so the
> size check never triggers:
> 
>   test_zswap.c:609:24: warning: result of comparison of constant 4294967296 with expression of type '__kernel_ulong_t' (aka 'unsigned long') is always false [-Wtautological-constant-out-of-range-compare]
> 
> Multiply totalram by mem_unit as an unsigned long long and use that for
> the check and the values derived from it. Nothing changes on 64-bit,
> where mem_unit is 1.
> 
Built test_zswap before and after on next-20261103 and ran both on a 4G
VM, identical results, no change on 64-bit as claimed.

One small thing: could you add a Fixes tag? The issue seems to date
back to a549f9f31561a ("selftests: cgroup: add test_zswap with no kmem
bypass test"), which introduced the sysinfo block, and 6f615890b848
later reshaped it into the current GB(4) comparison with the warning.

Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Tested-by: Tao Cui <cuitao@kylinos.cn>

Thanks,
Tao
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> Found with 32-bit builds of the selftests (gcc 16 and clang 21 with
> -m32, with and without -D_TIME_BITS=64 -D_FILE_OFFSET_BITS=64);
> KernelCI's 32-bit arm builds show the same warnings. The changed files
> build without them now, and the x86_64 builds don't change.
> 
>  tools/testing/selftests/cgroup/test_zswap.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
> index d50acc1b83ac8..223e2eb1329ab 100644
> --- a/tools/testing/selftests/cgroup/test_zswap.c
> +++ b/tools/testing/selftests/cgroup/test_zswap.c
> @@ -597,6 +597,7 @@ static int test_no_kmem_bypass(const char *root)
>  	size_t trigger_allocation_size;
>  	int wait_child_iteration = 0;
>  	long stored_pages_threshold;
> +	unsigned long long totalram;
>  	struct sysinfo sys_info;
>  	int ret = KSFT_FAIL;
>  	int child_status;
> @@ -606,10 +607,11 @@ static int test_no_kmem_bypass(const char *root)
>  	/* Read sys info and compute test values accordingly */
>  	if (sysinfo(&sys_info) != 0)
>  		return KSFT_FAIL;
> -	if (sys_info.totalram > GB(4)) {
> +	totalram = (unsigned long long)sys_info.totalram * sys_info.mem_unit;
> +	if (totalram > GB(4)) {
>  		ksft_print_msg(
> -			"requires less than 4GB total ram, sys_info.totalram: %.1fGB\n",
> -			(double)sys_info.totalram / GB(1));
> +			"requires less than 4GB total ram, total ram: %.1fGB\n",
> +			(double)totalram / GB(1));
>  		return KSFT_SKIP;
>  	}
>  	if (access(PATH_ZSWAP_STORED_PAGES, R_OK)) {
> @@ -622,12 +624,12 @@ static int test_no_kmem_bypass(const char *root)
>  		return KSFT_FAIL;
>  	if (read_min_free_kb(&min_free_kb_original))
>  		return KSFT_FAIL;
> -	min_free_kb_high = sys_info.totalram / 2000;
> -	min_free_kb_low = sys_info.totalram / 500000;
> -	values->target_alloc_bytes = (sys_info.totalram - min_free_kb_high * 1000) +
> -		sys_info.totalram * 5 / 100;
> -	stored_pages_threshold = sys_info.totalram / 5 / page_size;
> -	trigger_allocation_size = sys_info.totalram / 20;
> +	min_free_kb_high = totalram / 2000;
> +	min_free_kb_low = totalram / 500000;
> +	values->target_alloc_bytes = (totalram - min_free_kb_high * 1000) +
> +		totalram * 5 / 100;
> +	stored_pages_threshold = totalram / 5 / page_size;
> +	trigger_allocation_size = totalram / 20;
>  
>  	/* Set up test memcg */
>  	test_group = cg_name(root, "kmem_bypass_test");


