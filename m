Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D3FACC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 09:56:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B1BE6B0096; Tue, 13 Oct 2026 05:56:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715096B0099; Tue, 13 Oct 2026 05:56:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62B466B009E; Tue, 13 Oct 2026 05:56:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0936B0096
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:56:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D2F2FA899E
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:56:51 +0000 (UTC)
X-FDA: 85317149022.12.5D78F12
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id E296A80005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:56:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EFfKnIxB;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791885410;
	b=hxS3KmZR42/V6nHIm9jFRu2osdXVyvWRfG8LMIgE1uRydb5Z1ZVC6O5zTc4dwxnX6JYUuK
	LqeGoibv1XLw+680CPKce5ldl626LlJPle+x7dlO2KzCl+kt+wPh8Sue6iqTSOSWNzYVxb
	siu8sG30CNpxC78FFMXTCDBvmvjr8kQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EFfKnIxB;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791885410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mj3i05OrxJ6YWx+f3AUX5Vb6XQi1UeOMbjkLstyxMQ8=;
	b=UquuJ3Uf0odRCiAZRU241dK64yDLAAvA79wPQJylztHm6puMDZvJ3vjy1J1gdjt83FrfOa
	qWstd4FNgxbz8JVchMj+hMKWVEnYfC2H8BvLNjEZEx9UNL8OqcTaLVZg06u7fh0U/sUX3S
	GJ7Xh3XTTmZFw1HvTDgosdfwoDjc4R0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A88B7169C;
	Tue, 13 Oct 2026 02:56:45 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B7BFA3F7B4;
	Tue, 13 Oct 2026 02:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791885409; bh=2YBI+HNExmRWYOZipFDby651m/YqSXmPK4RnpA+3yK8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EFfKnIxBAePjQOmGwBCkTqFItC93LDqs/Ft5OLc1jDoCy03l/oyZ3xq3p/rErMXXf
	 0VdGLyhM7eOk7ZyJTtVs8aIFAsg/9wEyCHieUebxsFY1M8DIyJVDY6i6nuZECOaCSS
	 X1pb39YTxXfeN8zlu5iZYlhP9/6/v3k+kFfc4om4=
Message-ID: <40f95078-4d3c-48da-9262-afadf231014f@arm.com>
Date: Tue, 13 Oct 2026 15:26:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/3] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT
 macro
To: Yeoreum Yun <yeoreum.yun@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
References: <20261013-fix_hpage_macro-v6-0-2c52d0484de3@arm.com>
 <20261013-fix_hpage_macro-v6-2-2c52d0484de3@arm.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20261013-fix_hpage_macro-v6-2-2c52d0484de3@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n38cadzu138z3infuf3ny6khgccdk6yr
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E296A80005
X-HE-Tag: 1791885409-745103
X-HE-Meta: U2FsdGVkX1+CWnAbe5HX0LF8BMOUeqQ/1x/5f39aCqwCT8ToYHfG64UpompdcromASofwp/2XbdI/kKHWRWB7hHqzKoBRilagH07O8yBu3wyhJkLNmINJCeohuhBDI+uTKshzySVMapMIY7OYyS6twXHKQufeqavBLLYQhQqqpCKo95hDNeblubssLw9TbQJlo0LjC+U/WnaYHj7zPwrrcOVxsEuJV2gTMLuT92nMcrf/FgwI9p1nwaPwXtfPkXHMLP5nIxU7CcZbwUVBCdIZ5Ashn4RYuhI8nuw+t2MOrHwoKY0dDOEnqE1BL8NBJQyhFIkeJZ9s6XbqBN2BU6HOv/uGHr3ZK9SteppEvIgCzyd3v57KGdiL6TUbUMO+IJp+M/S9t4QhqddO8V+tjM9j3vdCFh1Ivop5nr/UVzIwJqykwIAfRQ6zWTB+32dJUfZ9KK9uFqD4HAPCrOtAwew40yUhFQAlsWEmor6fkkLjwJsXUVJbtMQ30ZzT5DIbdkDjCbIh23aoeiMwQruMToay0aPY1rGo2fCbwohJRYYxzo1r1a9zZj7b/icMGQuQ91iLeeh5OOoUOItG4BFnmUFkB0y9fvd/hraHqgV1FMmI/gx/43BE+Y4EioBoI1jG0Qgv2dsuKGgls3XEeLBt1EPIr9jKntSxnPhV+4y2+VQZ6AlagOeegyLT5i8+dEg7C6TqpxU7a0KauGN95s74DzTLcO7H78AQ9qjV9bMZWXCGYeHFTTJK/iNRAzQpBVTPBIchdeM2JXaL4bRQ/Ouu8nCM7KKXK26Z5tH7C8UM1/UxegbH1dKF57E5rv2QUb02YGObD0g2jKsASo+jjFtMWdC5Wbhbcdsok+jUF30BIDd3tL70ox2M4HLzzqTdOa6/zZfNLVWFjkGciYHrkwM/t3dd+7nlFYzLumibAg9YB3EVNkH0vyKUVicTeuXsSgWi4x9tlFhxmKSilxbOHz5hB5
 rqxrC27V
 3zGcNSTnJ+d9KcOk3watN2StCWvda0s2sSSSIo2y/gE/L3qVg/amXEOphRxuQZtENt7mBV87AKAaSzW5dqNAv+7kV9vm5a7fSj2X/aZbS+7GhWRrIXnjTrimyyxfKqnYimbjxGuLS5Z75VwR0IDoC3rt4G5O+O06szmbfq1VsdhUJn8458a1GEBZJVkyoNnoPrXdvO2s0aXyJckg3CFffAE3bU/H+VYj+6Kht0L3QVVSC2tgcU+blqAYl+SvYjLtUhKcFRW/0YOjXX1EwHWgm7K1yyWXINkwSd+gI/cZTPNHJs6H6ylmaO7Bz1YKxmYEmmFw6Ky5un5c5yrt5GxF/ZxfG2sLqCZZ0WFTiqBQZYpUskf/gVTN3QO4iyVgzSab6EqXUeCyBjwf3s5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yeoreum!

On 10/13/26 3:16 PM, Yeoreum Yun wrote:
> HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
> When this macro is used in some test, test result would be strange in
> the system where PAGE_SIZE is more then 4KB.
> 
> Here is the example with transhuge-stress test with 16KB PAGE_SIZE:
> 
>   transhuge-stress: allocate 61073 transhuge pages, using 122146 MiB virtual memory and 1908 MiB of ram
>     3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s	2566 succeed, 58507 failed, 2566 different pages
>     0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231839.704 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.528 s/loop, 0.009 ms/page, 231544.782 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.528 s/loop, 0.009 ms/page, 231462.074 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231770.300 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     ...
>   ok 1 Completed
> 
> Remove the HPAGE_SIZE and HPAGE_SHIFT macro and introduce pmd_pshift()
> helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-existing
> helper, pmd_psize().
> 
> Also, run the KSM_MERGE_TIME_HUGE_PAGES test with a size of 512 MiB,
> which is the least common multiple of the PMD sizes for 4 KiB, 16 KiB,
> and 64 KiB base pages. Since allocate_transhuge() allocates mappings in
> PMD-sized units, the test may fail with the previous size of 100 MiB,
> which is not a multiple of the PMD size when the base page size is
> 16 KiB or 64 KiB.
> 
> After this patch, output of transhuge-stress:
> 
>   transhuge-stress: allocate 3817 transhuge pages, using 122146 MiB virtual memory and 119 MiB of ram
>     2.558 s/loop, 0.670 ms/page,  47755.759 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>     2.640 s/loop, 0.692 ms/page,  46268.432 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>     2.635 s/loop, 0.690 ms/page,  46360.298 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>     2.782 s/loop, 0.729 ms/page,  43899.795 MiB/s	2616 succeed, 1201 failed, 2616 different pages
>     2.692 s/loop, 0.705 ms/page,  45380.876 MiB/s	2627 succeed, 1190 failed, 2627 different pages
>     2.612 s/loop, 0.684 ms/page,  46765.812 MiB/s	2628 succeed, 1189 failed, 2628 different pages
>     2.683 s/loop, 0.703 ms/page,  45520.990 MiB/s	2630 succeed, 1187 failed, 2630 different pages
>     2.727 s/loop, 0.714 ms/page,  44789.321 MiB/s	2631 succeed, 1186 failed, 2631 different pages
>     ...
>   ok 1 Completed
> 
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

[...]

> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 5f2fb5b819c4a..efd99298be135 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -21,6 +21,8 @@
>  
>  unsigned int __page_size;
>  unsigned int __page_shift;
> +uint64_t __pmd_psize = -1ull;
> +uint64_t __pmd_pshift = -1ull;
>  
>  uint64_t pagemap_get_entry(int fd, char *start)
>  {
> @@ -161,19 +163,40 @@ uint64_t pmd_psize(void)
>  	char buf[20];
>  	ssize_t num_read;
>  
> +	if (__pmd_psize != -1ull)
> +		return __pmd_psize;
> +
>  	fd = open(PMD_SIZE_FILE_PATH, O_RDONLY);
> -	if (fd == -1)
> +	if (fd == -1) {
> +		__pmd_psize = 0;
>  		return 0;
> +	}
>  
>  	num_read = read(fd, buf, 19);
>  	if (num_read < 1) {
> +		__pmd_psize = 0;
>  		close(fd);
>  		return 0;
>  	}
>  	buf[num_read] = '\0';
>  	close(fd);
>  
> -	return strtoul(buf, NULL, 10);
> +	__pmd_psize = strtoul(buf, NULL, 10);
> +
> +	return __pmd_psize;
> +}
> +
> +uint64_t pmd_pshift(void)
> +{
> +	if (__pmd_pshift != -1ull)
> +		return __pmd_pshift;
> +
> +	if (__pmd_psize != -1ull)
> +		__pmd_psize = pmd_psize();

Kiryl pointed this out in v5 [1], you might have missed it. This check
seems to be inverted.

[1] https://lore.kernel.org/all/asj4dT2Q__SlKhgr@thinkstation/


