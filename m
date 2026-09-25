Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A088C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 12:38:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CD446B0088; Fri, 25 Sep 2026 08:38:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 757606B008A; Fri, 25 Sep 2026 08:38:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621D86B008C; Fri, 25 Sep 2026 08:38:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D8B26B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:38:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B4B7FC062A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:38:55 +0000 (UTC)
X-FDA: 85252239030.10.D95F0B8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id D137A180008
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:38:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="qD5/3Mtz";
	spf=pass (imf24.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790339934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lh5V/ptxapRIR+WqaKkNIGTXXO3FUTlIWTIAMYKtU/A=;
	b=sEqT5gQ1SwhRhjt1lJ14GmYyU8LxBayOFTuFd+WFggI6Ahf3nLpYLS6K4LitVpZquD4MiZ
	zLmGA/2sMpREu0rjtJPlSg3nWzUqnaCqxEiVmzlEYStY5gHAzYMM1A65cKW2XR0NM6yASx
	Q+pWmLRlYus3aMOUQ4vtT2QHXmme6ds=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="qD5/3Mtz";
	spf=pass (imf24.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790339934;
	b=s7rzJAaxwux98QlpXzwBXrPNA9SU/tKvX88dJe4m6/m9JjIisPRxOCW5NcQPhxusP9fYCl
	oPnr5HmpuX5QZZr8Aj2MS1xgRGxjMSVut7yCf0nanVjOW81+TDAtmO7X7lqTIEaaqneYTD
	PmaxGuljWYp4+q8htNhiCP1SesfzYI8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D167169C;
	Fri, 25 Sep 2026 05:38:49 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C6A63F86C;
	Fri, 25 Sep 2026 05:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790339932; bh=3/sJDh2CYvX6ndhu9fW7GGXj1GgDR/glEJ6XbWJ6Eoc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qD5/3MtzVreV8Bh2VupUQ9nnBRZ5lh5KiqEmCUzeVaGdjdtAk42kWUtSv2TLHK3yx
	 Gh8O6SM+8wgPCCeJEYjSksYixaZjd1X8spXfAjIn8kpc20AZ705kPC2zhifkAqAhx/
	 nXUt2bt5rOx/fCLPrpb1Y+xpq1Vieba3A9Z8bc0Y=
Message-ID: <bde32459-31ce-4b15-a129-4641ef1c6337@arm.com>
Date: Fri, 25 Sep 2026 18:08:44 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/4] kselftest: mm: replace usage of /proc/self/smaps
 for __check_pmd_huge()
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
 <20260924-fix_split-v8-2-cba7359d882a@arm.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20260924-fix_split-v8-2-cba7359d882a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5g7csy6raztzdtmj1r3ktdkjmca8zaky
X-Rspamd-Queue-Id: D137A180008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790339933-863269
X-HE-Meta: U2FsdGVkX19jMm1/ELpr9eDUvsU1kbwYhU3UOwcDzhWDAF2NkKmG3ko9Zlmk95jzI+vkMPheke4WJ2EvrxXy9J/e17X29n66h2pNdb76iIoDTvYOaRmqVeAnECye7TBqCb3Rgene77pVxFqSBmBUjAWMoWsXI82xp3N4kh0ebi6Z9T024UJZU/Yj03zFB0PihDLUQPEdUv94L/Mm4PAX8wYM/5nvXfL0hpq2UshY4q64f8G55xRsR/YUSCsXTVY+EdzO3Ge1bqrJdLNL78bMXrVoQIbri9uG8aBsxnUxShUg7WlIbT3e+zucpNqrde+xeueXpeEWf+DH5ufFIjzdNRXGDraXkkJpP3HdZF+m/72j5lGNhzT1vZIz3IZWHTyvU2fd9/Ql1z+PgoftkrzQYUETwI5LQa+yLTGudcKGyPtJpyEXtjHtE/ZuSpb2byzfqGgN3Ua3z0jtM61/3C0le4UDQt4/CvMH2foKzorGQOWnZBa3Ecmw9dYy+18uVMIffr4uuBWbJY/FCzrjVCUF4EQ9x3TIoJT6o/bAHciB78maPWCuQfbJsLEhcK2rU6QzSFLux9yoexoA4VPwUkWNT8goEZ3yifhPY/x3i89FT9GormAENLqyCk5HCG+gJzhkuMXjzM4osdI/QEO3gkK2TjyCxFdRVwQCLBpMoPpql8Zzq8gXJd8yCiAtxrN57PgPIBrKB3tPNNqQag/FsN6pGl/zmsVmJ+RWGQzktYcuglImd3T3P2B/9Fm6w9eb+xXPkk622I1n+1AjLDMuIevcEAZZgQ2N33aMRHP+CjlN7SMshzE/Mk1KEnB83oYNJdSQL3HgMZQT3x8soQ0jWwpSq2Co0/h5nmESt+JO3Xc20qfNziFb58OqRzH1Sg1UpdGy/HvLRezUpV9LK2mwvaGFqcBvGDOLYona0O7NU5QJmRIEYFGawmpUQR3uDWLBendia41OJIAjqcMd1m1IIIQ
 YzC8qE8d
 pWp4wCxgMfjGnvmavR5JFyBr1qZNwv6SvDk7CQ0zu8JDzP9kkrHx2TpchPHwB4KGwvOqRRBnzrct71I8QAoILJJuKmHmNu3Xrao4YSVz83RMAuZ6lFcToSmJQgIXK+0fBkqquh786pwYdJYSMNpVP/kv+j/uh+4OoZ8qhlgLj1nwOvA4WoOrv+fM2wbWJCY6haE5AFMK63BlJmWDJh56cmGKeKQ94WCGpTGVu18kt0zxHzCM1l5OlAUsaw8JobUq/x2vJm1m8NunGuejHpoaqdvtiRnL3CLHNPB+DcFAa7IgT2Nr1o1oWojcTNMC7lsp9aT4KzxP7zwhlxvDYpo0g1pSOvXmqahjzM4Lzd+8rnD0ywoylYLNDcjfdYiVdrD8X3x+hqzWi6hW9kfE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/25/26 12:41 AM, Yeoreum Yun wrote:
> Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> made by memalign().
> 
> The underlying VMA may start at a different address from the aligned
> address returned by memalign(). Furthermore, a subsequent
> madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> already set.
> 
> This causes split_huge_page_test to fail because the check_pmd_huge()
> helpers incorrectly require the address returned by memalign() to
> match the VMA start address reported in /proc/self/smaps.
> 
> Instead of relying on /proc/self/smaps, use /proc/self/pagemap and
> /proc/kpageflags to detect huge-page mappings checking PAGE_IS_HUGE
> and PAGE_IS_FILE accroding to type of huge page.

s/accroding/according

> 
> Since shmem pages are also file-backed, simply check whether the page
> is file-backed.
> 
> Fixes: 642bc52aed9 ("selftests: vm: bring common functions to a new file")

Checkpatch gives a warning saying it requires atleast 12 characters of
commit SHA.

> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

[...]

> +static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
> +		  uint64_t hpage_size, enum check_huge_type type)
> +{
> +	int pagemap_fd;
> +	int nr_pmd_mappings = 0;
> +	uint64_t categories;
> +	char *start = addr;
> +	char *end = start + len;
> +
> +	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
> +	if (pagemap_fd < 0)
> +		ksft_exit_fail_msg("open pagemap fail\n");

Can we use ksft_exit_fail_perror("open pagemap") here? Will help in
diagnosing failures as well.

Apart from these nits, rest looks good.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

