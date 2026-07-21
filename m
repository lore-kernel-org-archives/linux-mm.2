Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1C2BC44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 13:52:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8486B0096; Tue, 21 Jul 2026 09:52:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC54E6B0098; Tue, 21 Jul 2026 09:52:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7EE6B0099; Tue, 21 Jul 2026 09:52:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77ADD6B0096
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:52:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F3D9E40147
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:52:24 +0000 (UTC)
X-FDA: 85012923450.16.52BCC98
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2F52580008
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:52:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="d/72xT/o";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784641943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RaZK4/uxB2KhVDJNW2ZeJFh2hP5pmFvK0FffjAu88PI=;
	b=A5Rn9gpdaCR+aBkEwmGpZf9w9AX8eJKlDo+fbc41xadjcg2HAHxFX46Gq+u61ITOnq1gRq
	/wL8Mp7BI418cpMFlYlTVw9WaU/LrzAP2TSEiTLW/X2Jtk3LT3yUulNHx/xA/tYtuEMm4L
	cFFMAaXo2gXXL0WPcS6Q8jZljP8SnCQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784641943;
	b=vYqEqUOXL4Rue1x0LsydXtk1Deqw12vw1tzXC4GwNqf0zYwcVaAwzKMi43xEBx4Sezc5mn
	7dQehCeZbE/F3f62nN+m4sbqcTTEvQ0FHSuUdERPwBpODf5EjdUL4fMmrjDmp0wlpgeloV
	ljHrTvMEjN4uVRANkLecK5BzvMBcjQQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="d/72xT/o";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 65CE4406C2;
	Tue, 21 Jul 2026 13:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8189F1F000E9;
	Tue, 21 Jul 2026 13:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784641942;
	bh=RaZK4/uxB2KhVDJNW2ZeJFh2hP5pmFvK0FffjAu88PI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=d/72xT/oXv/TB6QjoTEzJixPbZfa8WBCinpxoRj4KHF56so2jsmgMi8UlSszLchc0
	 VmskP0UPL1HE86D25Kh+6Lua1r3cjU0OtNgLwH1H9W3vDBmUJ3S7UVpKCVEqvpxu7r
	 Y4YbBGRXNN/QTS7O4KBaRJqJzhLYpxYQ8w8Xfx/zypYYHx5755R9ue2ACdp4ZqUJer
	 s0cRbIdimcIzS9AYa9sEtnKdf2M3O91OOzbFHdn0ZI2CXYp1fAXOaFLGYZ5Y4Jh6HH
	 eBfjBl3m7rKa+a8pMQkz63klyqx2kDKQCkSmOyIXJaMbQXWiP11Cc0F6P+Qpx+6Sw7
	 BM+ElcTn9HISA==
Message-ID: <4665dd2d-99c8-492c-a4cf-b72028317d0b@kernel.org>
Date: Tue, 21 Jul 2026 15:52:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] tools/mm: add a standalone GUP microbenchmark
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Jonathan Corbet <corbet@lwn.net>, Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260716123226.197736-1-sarthak.sharma@arm.com>
 <20260716123226.197736-5-sarthak.sharma@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260716123226.197736-5-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2F52580008
X-Stat-Signature: rkzycdgei8kpyjh1y1a6ytq9tkohhidb
X-HE-Tag: 1784641943-850257
X-HE-Meta: U2FsdGVkX1/vvXEB1TE/0MOKcnLQDsTFTLrkW9I1qaOcJLIRzfBjOQWlou3ybK0VbeQwETEEJWQRGwtssY9MuLl35e4Oavkzi9ziv5PBCfW2yIwoGyDaHveCdpJ2KrQuU80w1EWcGPFDMbhJ01u2KKxz9X7dmOZrdHtpyslpiObCwZIWKXkZHQnDXI2BdvTQ98XnVMqZ5rSK9SQsVWTddhmRw3fGU82ZhbYjyoEvPXq9wmkJU7PQ8OzREmlIO2rLgccsmv98L7vf5FT4HZzH2OiJ9yAMM7Qs+LZIhaCj770NfNphRvuGo6shsZHZrasFeQs+K6D1lbslRBBXc/0r3es51yH8NYEQOpKuXt4OxOqAwAA+ErZ9DfghkhkiqopOQoVwkgFKty8pkJnLPfjP41DWnMJS519S3pSrcMZcox4nnaEB8m3/PhpNiKEWu6Z0pvstWvCy19rffjPCBf5OnLMOY7p5UZ8pyRPZqtMx8mkqRG7QDkVkQhi3SVF6ujqdawDGXq0h/37AYlXXtDOTIQISOijj8ELPq5l34ynh72x5CqthajKFTQmQvqTMSH+xJJW4DlzZWIDzWTqGwlivPjpTR2HynUm2JQ5MZhymtzwTQW+JMe9jM28uOHP50sU80yj6bYF3koh+c8ksn5QQSeYKdI6tuiPIwz6ywld3csOa9+l7Nr+IoaoISOKlqFdKZlgJ7f7BByyRyaLveQS7SwznSa8dycrIrJ3/7fPwkpdOVH54+DSTGQstj03568tJ67vehwzx2+LVypAVLOVISdOFZfFFVDf5N51d2O+u9Bkj3jQFW7hInPm9Y2lSYTDiIRQ9RmA3GMIV8b1R65sstuXGDmpJfelh5814pcDtXcSi8xHEbZ4fb0Qk4uX9gqCbigPYLqoyHgP9n8BAQKJLjAnCVx6bl3tvBqFbbuzJZC6qkoITvHo/mRlFZ2amoBokNKAMh7fm6mrM3YiatnC
 4VQDZDU4
 U4DwzrCHunGX2InUV2gxK7xbVfBosqD0MiERz3n2KroWJAicU4vB1sGJW++lRe6HcOqV7auUS8BVGW6BeDVS0FkyCsrHzxSp05Ck+lZdaEcqfYQw4GPW8AnMh7NhYPe2yoYn/9fzTjNJat9IyKRW2M8ufkbwPBLzmiM3QA1jcMDQx+5rIG9De/KkKJXYbbbS1EzDGNrvuvfCroTs0cxnqAU6FeGtyxGrjKv6qrrVNMFDL9HoVxEvoee0vwXGV0u982nVdx7vOa6EDlGfESRzFcm7es4qozjq5x9a69qPR5U86wjyYkdIhLwt/gDtlSqyPitbHEUVDYTBeNvdORGY4+/OhYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/16/26 14:32, Sarthak Sharma wrote:
> Add a command-line tool for benchmarking get_user_pages fast-path
> (GUP_FAST), pin_user_pages fast-path (PIN_FAST), and pin_user_pages
> longterm (PIN_LONGTERM) via the CONFIG_GUP_TEST debugfs interface.
> 
> When invoked without arguments, gup_bench runs the benchmark subset
> of configurations covered by run_gup_matrix() in run_vmtests.sh: all

To we really need the matrix in there? The matrix was good for selftests, but
not when using it as a benchmarking tool, no?

> three GUP commands across read/write, private/shared mappings, and a
> range of page counts, with THP on/off for regular mappings and hugetlb
> for huge page mappings. Restore HugeTLB settings after each hugetlb
> benchmark run. Validate numeric command-line arguments instead of
> relying on atoi().
> 
> This tool is a mix of reused and new logic. The mapping/setup path comes
> from selftests/mm/gup_test.c, while the default benchmark matrix matches
> the benchmark subset of run_gup_matrix() in run_vmtests.sh. The standalone
> CLI and tools/mm integration are added here and the HugeTLB setup code is
> shared via tools/lib/mm.
> 
> Add gup_bench to BUILD_TARGETS and INSTALL_TARGETS in tools/mm/Makefile,
> link it against the shared tools/lib/mm hugepage helpers, and ignore the
> resulting binary in tools/mm/.gitignore. While here, also add the
> missing thp_swap_allocator_test entry to .gitignore.
> 
> Add tools/mm/gup_bench.c to the GUP entry in MAINTAINERS.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---
>  MAINTAINERS          |   1 +
>  tools/mm/.gitignore  |   2 +
>  tools/mm/Makefile    |  10 +-
>  tools/mm/gup_bench.c | 482 +++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 492 insertions(+), 3 deletions(-)
>  create mode 100644 tools/mm/gup_bench.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 26b06d80ab45..7d121dee9f0f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17024,6 +17024,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>  F:	mm/gup.c
>  F:	mm/gup_test.c
>  F:	mm/gup_test.h
> +F:	tools/mm/gup_bench.c
>  F:	tools/testing/selftests/mm/gup_longterm.c
>  F:	tools/testing/selftests/mm/gup_test.c
>  
> diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
> index 922879f93fc8..154d740be02e 100644
> --- a/tools/mm/.gitignore
> +++ b/tools/mm/.gitignore
> @@ -2,3 +2,5 @@
>  slabinfo
>  page-types
>  page_owner_sort
> +thp_swap_allocator_test

^ Does that belong into this patch?

> +gup_bench

I wonder if it makes sense to "git mv" the existing tool (only slightly fixing
header inclusion to make it compile), essentially removing the old benchmark.

So it would be

1) Move tools, fixing up includes and removing the gup testing logic+matrix to
   make it compile

2) Extend tool by XYZ

3) Add completely new selftest

Because looking at patch #5, there is not really any code reuse there, but I
suspect there should be some in this patch here when moving instead of copying.

That would make this a lot easier to review.

-- 
Cheers,

David

