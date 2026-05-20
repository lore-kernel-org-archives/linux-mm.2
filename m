Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A885ECD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:56:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D916B0005; Wed, 20 May 2026 04:56:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDEC66B0088; Wed, 20 May 2026 04:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF4396B008A; Wed, 20 May 2026 04:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD4BF6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:56:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4CC2740229
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:56:05 +0000 (UTC)
X-FDA: 84787191090.26.6F06D5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 854FA40003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:56:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CeXrUcx2;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779267363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M67gQ2b5PjMLRqfJkCPbykmhRVGUYihUqRBcMGeSNZQ=;
	b=AR+LukeupoD4F1AG/Cr613gAi9yPPfhfjkQF3i1xpDVwbjWBVxHvZDAj6AQeQwBBUKt4aU
	l6jtSeDu0Jy5M+Vz8hfUWBnFfnTrvDu6bwXg2h+U1+J7QnScA1xR24g/kWcJGcvI+FePzz
	t9iRoGVX9oVryCEvloI2mp3YxevOAA0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CeXrUcx2;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779267363; a=rsa-sha256;
	cv=none;
	b=A875F5BWfHW6tss11o/xIuMTbkNvVxb/Slg7Ae3DkZrhoNsJm1XiVcaXmg4qhz3r8EJZ12
	kZyFfb0MGNNCDrst5Um1q1JeuDuuvDcURZro5C4xhAh0fPeoTz3gf+cRpT7iUKEjgZVdvq
	6Qtrpkdlk/78zIMlI4RqIS+jBh8Rw5M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9BD7043C19;
	Wed, 20 May 2026 08:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DA51F00893;
	Wed, 20 May 2026 08:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779267362;
	bh=M67gQ2b5PjMLRqfJkCPbykmhRVGUYihUqRBcMGeSNZQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CeXrUcx2NOPTLF6tZf/gMUiuOZwHUDe75lwssrGyfd66X4OcDNz08Pfv1UHZagElP
	 A8lqbt5XVP7uyJ1dN2EfUffGy7cG8k1jgBG7vDToskH1m04IT8Ji1SS7XStiZHgFcx
	 TyI6Lg61rY43fLSAnKYE8w7LFTvOmnw6h8PBCsqemDuEQhP4bdHbOuLKmNsWJ3qQ9C
	 2bQaMpbbyZelonnNlWluGQQRNpAcC+q3kFUEK2qeCfCRDFPrhWkeI0WX4ioNFFFU5Z
	 AhCfLo6rAwgzcGSLS2WFmE/ZEiO+QvRJNgW4lQCov5OWOHb8Cf8r8WODVDFT8StkP/
	 7YKie4t/+wQUw==
Date: Wed, 20 May 2026 11:55:53 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 1/2] tools/mm: add a standalone GUP microbenchmark
Message-ID: <ag13GbKcLMIoHOHj@kernel.org>
References: <20260519120506.184512-1-sarthak.sharma@arm.com>
 <20260519120506.184512-2-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519120506.184512-2-sarthak.sharma@arm.com>
X-Stat-Signature: cociay4itdqw1wahtgykp4868n7oxatm
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 854FA40003
X-Rspam-User: 
X-HE-Tag: 1779267363-595947
X-HE-Meta: U2FsdGVkX1/Wc6vrFwPvmH2wp74DDcNO1/nrcSK0/ENmQxkctIp+nTrhhGhEDMA5oyRvVxLnJZOnJG/kOQQbUwo/2CXMZROQiut4pb+XX/hiewJnAzd0YVEhrg03i4jTOilv+v7hCvUfGEm5v6GES9OPjRZCqjZIEOYNKrilzE793hcxRwacYqDyLQpw4yiwVE6u3kDUdfZu9s+YPkB3SAutXZ3Cw8rRgoDGv+kdB0KbM4C/6pEGExdT3xRW4yVjmvszuldy5GEnu2FPQRhabkFo4qs6x/RmPAv+LI6p9vqqTBgT5GGzqnDe9M6xVOiQc5o+NuDwPZyNcAH4U9T4z0sbkFrYh4TCcmDQWCXUlJT0Qo1d4tELLMCo2iCdFvcVd7z6GXlSraBicA/8M88FDSpItQHOkqQVXaxCo0kzEfMApVWFtelbvOeZeYWHDPramSoj6LYSZzlHi+a1k7M5+xU//Vqq/jnnI0Lr/Lm723oPn7YkBJ/iTLfuC3qRA67DwXSLwF5ztnKn/o3z9gP1lLQMLExIR8aRjoi1FKIwvNC/nG274argVm4T0V3nszfst3DhvCZOQp8TIgtP+Lg1GcF6ANB0r44LoEx+spIrzgfniqKcs7jAzSYXcIYiWlKYHLrExLEsknFFqw05rj4xQ5VJY96vxrYMHgGzk4w1L3xQaRNNjE7zAp4GllXcSiFSTrMuDi2xD5RudYzDqz1skGbJmRUn/CuPOWte1QlsanRlOmLPJaRc2/bsdtVq3SOaAHBJOIUWEArr9WNRZJ/F9ZJVE+cwA9HF+JoQmmr0vcjg7wx7VbSP2kjN1rRWn8U206ZdrVBZH2Ej2Z1ZC0FXHAv3MUoJNZS4LsIjNoZpil35C4Uv/lRI9US5niUqnfUV1hAEhtK57YkEpLF5um+O38gLTtt+ZuxJiBXRVy4Zr8J+jrGlnfwrMRLlEvCjQ+LoK/vRmlwC9GyGA/szpG/
 Hu1zVrnE
 41LtbNXr+4In5PIJc5PCQkVIUKJjebxzIHgwKc2a2lLUibcknfiVKgceoEDSXBX7P/xWk7KgRwZb2WI0CCxH/ziHSzcFNB12fZbzsbwvUrsGnJ59rGxuPnw8CZ3qEFO960hQ2pW1pYkAMdkGKqKxtDl2FiPfwRRISnHZ32GTD6NMsMZQJmaKgKer1N9WpNzU50T8s87U7ZuL8nksNWVSFy1na/6h+P5ZAq+m9Luv5G8VuEoFesZH/+slLU8JH2zr3uq0Zyl9QLXGh8/OKblz3o57JTASsI84FpjWFISBq0gWIWTFrU6sAb1/qDAnUNM0sQ1CKzEjyC4HedBxzvgYqiXpROw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(added broonie)

Hi,

On Tue, May 19, 2026 at 05:35:05PM +0530, Sarthak Sharma wrote:
> Add a command-line tool for benchmarking get_user_pages fast-path
> (GUP_FAST), pin_user_pages fast-path (PIN_FAST), and pin_user_pages
> longterm (PIN_LONGTERM) via the CONFIG_GUP_TEST debugfs interface.
> 
> When invoked without arguments, gup_bench runs the same matrix of
> configurations as run_gup_matrix() in run_vmtests.sh: all three GUP
> commands across read/write, private/shared mappings, and a range of
> page counts, with THP on/off for regular mappings and hugetlb for huge
> page mappings.
> 
> This tool is a mix of reused and new logic. The mapping/setup path comes
> from selftests/mm/gup_test.c, while the default benchmark matrix matches
> run_gup_matrix() in run_vmtests.sh. The standalone CLI and tools/mm
> integration are added here so tools/mm does not depend on kselftest.
> 
> Add gup_bench to BUILD_TARGETS and INSTALL_TARGETS in tools/mm/Makefile,
> and ignore the resulting binary in tools/mm/.gitignore. While here, also
> add the missing thp_swap_allocator_test entry to .gitignore.
> 
> Add tools/mm/gup_bench.c to the GUP entry in MAINTAINERS.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---
>  MAINTAINERS          |   1 +
>  tools/mm/.gitignore  |   2 +
>  tools/mm/Makefile    |   6 +-
>  tools/mm/gup_bench.c | 491 +++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 497 insertions(+), 3 deletions(-)
>  create mode 100644 tools/mm/gup_bench.c

...
 
> +/*
> + * Local HugeTLB setup helpers for gup_bench.
> + *
> + * These helpers were copied from tools/testing/selftests/mm/ and adjusted to
> + * remove the ksft formatting. Keep this copy local so tools/mm does not
> + * depend on ksft output behavior.
> + */

It looks like self tests of at least 5 subsystems beside mm use hugetlb:

$ git grep -l "Hugepagesize:" tools/testing/selftests/ | grep -v "selftests/mm"
tools/testing/selftests/arm64/mte/check_hugetlb_options.c
tools/testing/selftests/cgroup/test_hugetlb_memcg.c
tools/testing/selftests/kvm/lib/test_util.c
tools/testing/selftests/memfd/common.c
tools/testing/selftests/net/tcp_mmap.c

It seems that we need to better share the common code in
tools/testing/selftest.

And adding another copy of the hugetlb detection and setup code does not
seem like a great idea.

> +
> +static unsigned int psize(void)
> +{
> +	static unsigned int __page_size;
> +
> +	if (!__page_size)
> +		__page_size = sysconf(_SC_PAGESIZE);
> +	return __page_size;
> +}
> +
> +static unsigned long default_huge_page_size(void)
> +{
> +	FILE *f = fopen("/proc/meminfo", "r");
> +	unsigned long hpage_size = 0;
> +	char buf[256];
> +
> +	if (!f)
> +		return 0;
> +	while (fgets(buf, sizeof(buf), f)) {
> +		if (sscanf(buf, "Hugepagesize:       %lu kB", &hpage_size) == 1)
> +			break;
> +	}
> +	fclose(f);
> +	hpage_size <<= 10;
> +	return hpage_size;
> +}

-- 
Sincerely yours,
Mike.

