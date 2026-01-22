Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 195F7D46977
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F16A6B02DD; Thu, 22 Jan 2026 12:39:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CF946B02DE; Thu, 22 Jan 2026 12:39:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F60D6B02DF; Thu, 22 Jan 2026 12:39:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E0AC36B02DD
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:39:32 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8DDC1D2AF1
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:39:32 +0000 (UTC)
X-FDA: 84360311784.11.5C96181
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id E281240014
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:39:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769103571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=laCGWIoqjjsZRe+gHdM0Cql/2tn/LCKRdK5w6uw3Fxo=;
	b=wztVd4q60V7orRpiiv659FGyLIJRJy0NBo0AgMxU7bHb3HuQHpJk2QXe+BmLB1X6pNcCFi
	M7WsJAwuhqwnGu7omCqu0RbzpLR952q2ENDl/R+4vYWF9otxjIXwiqzRSmPlayxDYrg3ol
	PV8rYvVQc7Y88osEV7nFcElevqiW67Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769103571; a=rsa-sha256;
	cv=none;
	b=J+4duAwPE8JLZ0gLnH+bR/tD6HjLLJko/2eJlf9BiNnIWQKeDXwfVWSUfuK3Mpm0cUXGFJ
	PHQULxMANI+vk9N9nhPCFOThRDlZZBk5ZvFeIUHxxS224/j9j6jV9qr1BZtJEGOelzmECY
	/KX7eRPk96wuGvTaOCLtNdhNBV/9spw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 72BA81476;
	Thu, 22 Jan 2026 09:39:23 -0800 (PST)
Received: from [10.1.194.63] (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE0063F632;
	Thu, 22 Jan 2026 09:39:28 -0800 (PST)
Message-ID: <29fc7fb9-ec07-48f1-9883-82a44e637338@arm.com>
Date: Thu, 22 Jan 2026 17:39:27 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v3 6/9] selftests/mm: introduce helper to read every page
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260122170224.4056513-1-kevin.brodsky@arm.com>
 <20260122170224.4056513-7-kevin.brodsky@arm.com>
Content-Language: en-US
From: Muhammad Usama Anjum <usama.anjum@arm.com>
In-Reply-To: <20260122170224.4056513-7-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E281240014
X-Rspamd-Server: rspam07
X-Stat-Signature: wy97ccko4z6pm1jwyn9ysxap8m68365s
X-HE-Tag: 1769103570-202153
X-HE-Meta: U2FsdGVkX18OHHHmat4G/FFwc7MQNSIi4Vx5WFJJdL7L4r17puPRP7xbB9l5qYNhmU4CFRrpmf7cp6ZqXP6l/mV81VvzsxCAWli3BtWW3xZt2EfjppvqRYGG1R+0nyx7tOVmGOb9JBWAs+iGwLiN2252f+bZSKfqtnn7VJd4UX/a6/VWx2SIvecV36z3JiClBfDbAWeH3VYbbFCqXruv/I4+M+elCo4MiipzUVSY52FE68QxwJZa3YzrGfZiijAmu5H76RWKGl6H4yTgbW8of9BIW9eEnsNxQ364bMnju7r/izhjIb7XDktpbM/T8nX0cOUR7lCUJ+Gx1yuvzwhJ0n/2tAqUElAqChxnxU4oeFUTLq7P5LgR7T7ORzjR9V1s20yxSpIbH1IWQCepKvx8SaY3N2E3VMAmWtxGnfGrEUsmd33/0IwLCxsi26KCs9ST+5+iHM+qoGfAsA7O5P5baOvQnhmkwg1UNWytSApt4YAye8sfBWZuJNrWTHBGRsLjDC3tAotCCF/8woBMdhaVcZsvJG6OCNvm7LsfISOTWo3HwlC1PqSuWVYprmnC7svw99ROoFB3Y7hGXUrAVnAPikcl+AQl+tvAONQq2/EtPbWLw0M+pWWyyEhoTu/s2E9a1yfermONicBAAH+xp4Gus95zNUKUBn8I3ilBwN4f8PcSHoNzG4ExoIvVWfJQmoQGV1kmAKKzpmBaf2wXlDndfCLdWEmpp6Dv1eoTOZj6FzzVWPgQzxM8yb8LtenfFHr+1Tje4E3qjMxTsbAzCB2qTDY1mV6mlNp2fDFy9Ra+28VntPh+81vNd5VUntbHA4JQqM+rxwaNiUon1zaLs0+uGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/01/2026 5:02 pm, Kevin Brodsky wrote:
> FORCE_READ(*addr) ensures that the compiler will emit a load from
> addr. Several tests need to trigger such a load for a range of
> pages, ensuring that every page is faulted in, if it wasn't already.
> 
> Introduce a new helper force_read_pages() that does exactly that and
> replace existing loops with a call to it.
> 
> The step size (regular/huge page size) is preserved for all loops,
> except in split_huge_page_test. Reading every byte is unnecessary;
> we now read every huge page, matching the following call to
> check_huge_file().
> 
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>   tools/testing/selftests/mm/hugetlb-madvise.c      | 9 +--------
>   tools/testing/selftests/mm/pfnmap.c               | 9 +++------
>   tools/testing/selftests/mm/split_huge_page_test.c | 6 +-----
>   tools/testing/selftests/mm/vm_util.h              | 7 +++++++
>   4 files changed, 12 insertions(+), 19 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
> index 05d9d2805ae4..5b12041fa310 100644
> --- a/tools/testing/selftests/mm/hugetlb-madvise.c
> +++ b/tools/testing/selftests/mm/hugetlb-madvise.c
> @@ -47,14 +47,7 @@ void write_fault_pages(void *addr, unsigned long nr_pages)
>   
>   void read_fault_pages(void *addr, unsigned long nr_pages)
>   {
> -	unsigned long i;
> -
> -	for (i = 0; i < nr_pages; i++) {
> -		unsigned long *addr2 =
> -			((unsigned long *)(addr + (i * huge_page_size)));
> -		/* Prevent the compiler from optimizing out the entire loop: */
> -		FORCE_READ(*addr2);
> -	}
> +	force_read_pages(addr, nr_pages, huge_page_size);
>   }
>   
>   int main(int argc, char **argv)
> diff --git a/tools/testing/selftests/mm/pfnmap.c b/tools/testing/selftests/mm/pfnmap.c
> index f546dfb10cae..45b5f1cf6019 100644
> --- a/tools/testing/selftests/mm/pfnmap.c
> +++ b/tools/testing/selftests/mm/pfnmap.c
> @@ -35,18 +35,15 @@ static void signal_handler(int sig)
>   
>   static int test_read_access(char *addr, size_t size, size_t pagesize)
>   {
> -	size_t offs;
>   	int ret;
>   
>   	if (signal(SIGSEGV, signal_handler) == SIG_ERR)
>   		return -EINVAL;
>   
>   	ret = sigsetjmp(sigjmp_buf_env, 1);
> -	if (!ret) {
> -		for (offs = 0; offs < size; offs += pagesize)
> -			/* Force a read that the compiler cannot optimize out. */
> -			*((volatile char *)(addr + offs));
> -	}
> +	if (!ret)
> +		force_read_pages(addr, size/pagesize, pagesize);
> +
>   	if (signal(SIGSEGV, SIG_DFL) == SIG_ERR)
>   		return -EINVAL;
>   
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 40799f3f0213..e0167111bdd1 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -652,11 +652,7 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
>   	}
>   	madvise(*addr, fd_size, MADV_HUGEPAGE);
>   
> -	for (size_t i = 0; i < fd_size; i++) {
> -		char *addr2 = *addr + i;
> -
> -		FORCE_READ(*addr2);
> -	}
> +	force_read_pages(*addr, fd_size / pmd_pagesize, pmd_pagesize);
>   
>   	if (!check_huge_file(*addr, fd_size / pmd_pagesize, pmd_pagesize)) {
>   		ksft_print_msg("No large pagecache folio generated, please provide a filesystem supporting large folio\n");
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index 6ad32b1830f1..522f7f9050f5 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -54,6 +54,13 @@ static inline unsigned int pshift(void)
>   	return __page_shift;
>   }
>   
> +static inline void force_read_pages(char *addr, unsigned int nr_pages,
> +				    size_t pagesize)
> +{
> +	for (unsigned int i = 0; i < nr_pages; i++)
> +		FORCE_READ(addr[i * pagesize]);
> +}
Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>

> +
>   bool detect_huge_zeropage(void);
>   
>   /*


