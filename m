Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CDF9C55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 05:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5345D6B0088; Mon,  3 Aug 2026 01:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E4226B008A; Mon,  3 Aug 2026 01:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D36A6B0092; Mon,  3 Aug 2026 01:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1794E6B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 01:34:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F8ADA0615
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 05:34:07 +0000 (UTC)
X-FDA: 85058842134.06.E018F80
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 75808A0007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 05:34:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VxNAtEJW;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785735246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mF2nNofqE/1aZcEINmVMZXFzL7fXY93UAMZ3+IRnNek=;
	b=PJ47qvGfEWgQClAtu5fTGHegkLkVg/9KGpUpcL3x18O3sXigzq+nNzFhkfcsqHWI7QOFXW
	LImX4M2wig82xA4FnQlkJPXNS+sTVGWOPnN+xvQoOyO/rPBPzXKa0zOROSvQCjlKzM+OFw
	E5z3e7M2BXjGXWAS/jyuVSf5RF4nXVQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785735246;
	b=oZCLDJMmM/2u2xRKCDA+kNce5VRdgn12aXPtBLreyV29xHcv9c+z9lu1D6mo0NDKJnesDP
	eWL04HFwlFP+X6WZLKc8gaYCqHpEh+IrOqpLMx3msaj7FC61ioAgbNuA9VhHg8EIYqewQ5
	HkU3tvC6uy+6Km8ywNZrq9wgw+ldObA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VxNAtEJW;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F694143D;
	Sun,  2 Aug 2026 22:34:00 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 89BAC3F66F;
	Sun,  2 Aug 2026 22:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785735244; bh=OwvH7HKnExVk5bb7qHumfOLl0QVPjZFJ5VQ9gIp1z5k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VxNAtEJWUmeEkUu0EcMEiqUWEttW+gczS/NRlAcK6sWKaWYF9ykm3T/BhVjzcpbBj
	 NjCaqMnPz+IoO4jJhnysZOTs0UuPEcAdOjYiDA3VpgoqFQ6DsE1IceoFpn0jBQBwDO
	 PythhqLRSOxyedcYTeQgQGxcgk4meMgDYf02n8F8=
Date: Mon, 3 Aug 2026 11:04:00 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: test_zswap: skip test_no_kmem_bypass
 if debugfs is unavailable
Message-ID: <47ho7uhwnbtjmqrdr5hzxuy2dcfb2dal7so6ztt7obmqepeuri@e7bc5dfit4tm>
References: <20260801041255.752039-1-wfelipe@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260801041255.752039-1-wfelipe@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 75808A0007
X-Stat-Signature: 69qq668f5zfwppqm7wga54drdoecmux1
X-Rspam-User: 
X-HE-Tag: 1785735245-127217
X-HE-Meta: U2FsdGVkX19Dzqlt2FZWJ3X8FGz3C7SYDc9V2Re57CoxoZ72IiOBH8fcB1NZmAkYkRaJpVY5fjpsnxw/fJjBd1LCQtD7VxJxhCC21p0a73/4Vzg/27LHEtljwCwqgx16p5n1qJG2L29a9iLzHlvdSVKSziIhSiqhXoal5aiT/FFK9Y2YDO0qX7a3resG0xgMYr8lH2fe9blXXgVYcpWw/DhnOPK3m0MvZf44szL4x52IpjC56+NrQqmoqgYeOHMe42eRHECBQ0hlQpmWpOJdIJXvgAkWBdRGFmLzlNVCMwstc7gf0fiGXNE0mU2RwPPmt/SDVnkW7znw+NtrKa6ZUgkUL4oq7seJe4hDzZvSXe7ftv3ra6nv0i2PlM5ntGGESOs1yLrmqxIOZGJn1fV2LjcXEfmvOPPa1zObhzcUfubJyJtA04gfUE10BoAV6ZFGqodIGzdFPechD8BXXdbNUbxRy3Dx8fp8fO3jD7DYYD1Wn47ffaqUc7q1Iqf1TGlosIEeevSn3aCJkj9J1zETGFbGe/AfB0+ZyAIMs20yimDoMx+0sR0jv1a5tNAC0O7bAVtjcrT6zsU1lvD4qXJreYel8oEYBMYj4kHMkQ8zOwr27lesRO6StAYaUjH03QlGOXI4+wcnwmo1ni6ZeFvnAGg7ndYVZsF4Mz2CH6bZcD1YgP24vBV8X96UNNKMt1gF6bMFM4GwHY9s8ERhigb6VZNshCi6uEZ+dkdWpIdQCBLRzjGIDFRXPa5j/uFO9+V2Ui1pXOHJU6SBaGQ6wG5OtmAImyIr385FH4pqqq31pAC6gp1U5xMLlfzJ+H/ug4PEjWMujJUJ1w4B00AoqIG45pnTCDnuIqeloG7p6GzwNiSDPbKuHkQRcd/Q03UU7xYrV361mXRpvm3m3ZxCUs9u5IEDCggsdXIgi+12P0I0r6yTWXFjIR/mfWdHiPNvWdMHChYxX5L7X6sRlXc76ku
 s2syjI2A
 pgIR4k+XCFtCStlcoLMJ39i7zjPbnzTflvXvK3BtHQIJHGNNYXABgjAu+s9tWk4ICGtTfvjFYX72KYHaCSSr5S9FiVGVsUF5ZbFY2rVlzyx6K48o3d8/uDJAMYRe8CSna6IR71E3wcHW4ONmed34r9izs94sFexMff3oDXu8FzsLAanjA58fdAVwArjylbqrfaw4hncwAAL/lMH//3C/F0RhiDh/YuCJE33jeSWrKjQNpC5X9lT33pbgyAyq/6Jy1RU2NT7/tY0vaadtW7ptS4AMNuUaapPfsYLm3I56GnFj1zseVFe1lVHipBz4ydDVFPjfKVv8eb6TnosypkB7QkjyWFHVMo71j4/64IDHzO+tNnNSB8yhmTgR5f9JBVEMVfulRwRwGrbge6EoEHMDIiNP2PA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 01, 2026 at 04:12:46AM +0000, Wilson Felipe Pereira wrote:
> test_no_kmem_bypass() needs to read
> /sys/kernel/debug/zswap/stored_pages via get_zswap_stored_pages() to
> verify that compressed pages are charged to the memcg.
> 
> When running in an environment where debugfs is not mounted or
> CONFIG_DEBUG_FS is disabled, get_zswap_stored_pages() fails, causing the
> loop to terminate early and report a false negative (KSFT_FAIL).
> 
> Selftests should not fail when if debugfs is unavailable, and it
> should print a message when it is skipped.

Agreed.

> 
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
> ---
>  tools/testing/selftests/cgroup/test_zswap.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
> index 49b36ee791606..c4f7b66f1b206 100644
> --- a/tools/testing/selftests/cgroup/test_zswap.c
> +++ b/tools/testing/selftests/cgroup/test_zswap.c
> @@ -566,12 +566,19 @@ static int test_no_kmem_bypass(const char *root)
>  	int child_status;
>  	char *test_group = NULL;
>  	pid_t child_pid;
> +	size_t stored_pages;
>  
>  	/* Read sys info and compute test values accordingly */
>  	if (sysinfo(&sys_info) != 0)
>  		return KSFT_FAIL;
> -	if (sys_info.totalram > 5000000000)
> +	if (sys_info.totalram > 5000000000) {
> +		ksft_print_msg("requires less than 5000000000 total ram\n");

Agreed - should not silently just skip the test.

>  		return KSFT_SKIP;
> +	}
> +	if (get_zswap_stored_pages(&stored_pages)) {
> +		ksft_print_msg("debugfs at /sys/kernel/debug is required\n");

Could the error message here match that in gup_test.c for consistency
and probably later on these could be factored out in a macro constant

ksft_print_msg("mount debugfs at /sys/kernel/debug\n");

> +		return KSFT_SKIP;
> +	}
>  	values = mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT_READ |
>  			PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
>  	if (values == MAP_FAILED)
> @@ -604,7 +611,6 @@ static int test_no_kmem_bypass(const char *root)
>  	/* Try to wakeup kswapd and let it push child memory to zswap */
>  	set_min_free_kb(min_free_kb_high);
>  	for (int i = 0; i < 20; i++) {
> -		size_t stored_pages;
>  		char *trigger_allocation = malloc(trigger_allocation_size);
>  
>  		if (!trigger_allocation)
> -- 
> 2.55.0.508.g3f0d502094-goog
> 

Otherwise LGTM.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

