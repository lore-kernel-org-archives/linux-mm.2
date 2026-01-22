Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B93CC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 06:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADC696B00E7; Thu, 22 Jan 2026 01:05:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A89936B00E9; Thu, 22 Jan 2026 01:05:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B5F56B00EA; Thu, 22 Jan 2026 01:05:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C87D6B00E7
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 01:05:35 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C7F81A0101
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:05:35 +0000 (UTC)
X-FDA: 84358563030.01.6DCE1D9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 59630C0004
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:05:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769061933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=drfYYX7A84fDUd/t8oAiVvC9+i2w6N2zYGh+NUyJgYA=;
	b=saM6qQs779ItrWfl215Eb+qlMZqIGSLwpu1QHAzwWpfQK1vaxZwdJQitezEW+rRVdkq2u2
	kpy23J3pEIo/vap1n4SNgDYPIXDfMC9HiSOhQVATeTte7QP2XbJXhBkjbO8GLys9reBJTt
	03EJpRZb4chEMIu6z+p1oxwQ+hUddd4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769061933; a=rsa-sha256;
	cv=none;
	b=nlAs/I1hPWGTvMoyK0oXDVhqDKedi1o3MftUnMUe8hH/PDgnlvzOx8CDT/ir9l2nGIcWSO
	5Rqf0qZ7cv3BvgyerehRb4oIon5sqao1cEHGJ+8L5DkCtUPgPNUsrfVhgWpp4HKVPYsK3E
	n7yyk4j04l0WsNY/5cFBV/1n93Mz+SY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 01F691476;
	Wed, 21 Jan 2026 22:05:26 -0800 (PST)
Received: from [10.164.18.63] (MacBook-Pro.blr.arm.com [10.164.18.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CCEF93F740;
	Wed, 21 Jan 2026 22:05:29 -0800 (PST)
Message-ID: <a2549671-da39-4827-a534-32f128f233a1@arm.com>
Date: Thu, 22 Jan 2026 11:35:27 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] selftests/mm: introduce helper to read every page
 in range
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
 <20260107164842.3289559-6-kevin.brodsky@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260107164842.3289559-6-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 59630C0004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: szrm4ab9p9yye86ch8k3a9tm9dcmtd8e
X-HE-Tag: 1769061933-867006
X-HE-Meta: U2FsdGVkX1+ssB3uDzBnQAOO8HrwZASw0uOJMVIaHUB74VdjVKiJcRc2HqU7xqv6GKRVwipepuJvk1tdf30qrVTp7oVJEf84GOQ675eDc0ElgucR+rtzOfXj6CSUfiikhtSTO6CAKXVpSysmlhZ0EiB1FZVJgidTiFEg1j/I39b8l50ZM1i2j1k/ZY2f4P1I8JV7KAP0+fxCjTrqEQQeji+5tsr6qAjUba4PMlAMvc6hVywQDG3Rpa4MrNjwTomyc68RE+xtojoEtjioDSI592A1uIVwWa0rKziUVIUh5NioHRBSVpWdYMnsaRWZAy+z/owgXv5e13VeC1x97ALoom/m4J4LDf0OT+b+tK6C9QSXNzauy8HVsWEW4Zumww0/OwE/UPXat8zvSBc//v70Ed2lfJQ9lXEEhtVOHVoG38pcOu+GLpD44PHMLFRd7J6UhhhO2wW+NYLN2Xd9QAx6q+bVSZHZ82ISzhTUCzWF6CflfXaf1AcQN9rxYlU0ru3idS0HEyI0QhtW852xHXb1yMCYwq3uLZkaN9YeEEpjNcsA0F15Afz6G6JIGJhaIUVYIJGATJgDpYcvDUOU/sP5gjNSxJZgAtDfVG2SD6QXXlZGVBF8ziEForN/egZycEJvojDKFvwOQ9qUFiBLsqFEClFZgHSHYKWAgdyk5btl2x/Ox5Qr/q4152UVKbHJOiHrGdOYn14ztmasw/qDxlqL52CLocCWg00QOzrT7OAeoUofCgRM1KqmunXjPwSaWLrE1nVptpAQcBtWOq4buydiM00eneWAYQuT6qm6H6jWqZ6J1qCv2qcQ1Wb4s5mJy2Ru3opFtN1owpQvmp9lweLNkZS+x4P2rQwpWB+6JS37+3hpRa9NbKzdYAGZ5zLeqAn53RzzYYEDHC9uShryz9zXyuKkZREzwug/Ukne15BkMMzTC2kv7cvNiC88JHE631VDhfAPFmcu+vb1jD4Vkc+
 qfOJ4mMb
 D10ulWck7GLL0bb8Ijs5IZoPahVC5kxdJZ41jiLWbcIlxDm6jWnGx88PUhv/GvFSOcI/XPbt0ccRwpHdrlU5SxYrHu1bS4taNuXHayvl/+0PItIAhm20k+IUU5vnDzvee0mbx2xRtj11/xzWFQj036C6rv1/NsuevIBqpRPLjzyCwpfc9uy0xMVQ2ZqoHDrHf60oE2Jz3Y7425zUq3M2VJ2+pBm7CMhvZM+t+MWSrSvLGDDI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 07/01/26 10:18 pm, Kevin Brodsky wrote:
> FORCE_READ(*addr) ensures that the compiler will emit a load from
> addr. Several tests need to trigger such a load for every page in
> the range [addr, addr + len), ensuring that every page is faulted
> in, if it wasn't already.
>
> Introduce a new helper force_read_pages_in_range() that does exactly
> that and replace existing loops with a call to it. Some of those
> loops have a different step size, but reading from every page is
> appropriate in all cases.
>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  tools/testing/selftests/mm/hugetlb-madvise.c     |  9 +--------
>  tools/testing/selftests/mm/pfnmap.c              | 16 ++++++----------
>  .../testing/selftests/mm/split_huge_page_test.c  |  6 +-----
>  tools/testing/selftests/mm/vm_util.h             |  6 ++++++
>  4 files changed, 14 insertions(+), 23 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
> index 05d9d2805ae4..1f82568ae262 100644
> --- a/tools/testing/selftests/mm/hugetlb-madvise.c
> +++ b/tools/testing/selftests/mm/hugetlb-madvise.c
> @@ -47,14 +47,7 @@ void write_fault_pages(void *addr, unsigned long nr_pages)
>  
>  void read_fault_pages(void *addr, unsigned long nr_pages)
>  {
> -	unsigned long i;
> -
> -	for (i = 0; i < nr_pages; i++) {
> -		unsigned long *addr2 =
> -			((unsigned long *)(addr + (i * huge_page_size)));
> -		/* Prevent the compiler from optimizing out the entire loop: */
> -		FORCE_READ(*addr2);
> -	}
> +	force_read_pages_in_range(addr, nr_pages * huge_page_size);
>  }

Yeah this should be fine to do.

>  
>  int main(int argc, char **argv)
> diff --git a/tools/testing/selftests/mm/pfnmap.c b/tools/testing/selftests/mm/pfnmap.c
> index f546dfb10cae..35b0e3ed54cd 100644
> --- a/tools/testing/selftests/mm/pfnmap.c
> +++ b/tools/testing/selftests/mm/pfnmap.c
> @@ -33,20 +33,17 @@ static void signal_handler(int sig)
>  	siglongjmp(sigjmp_buf_env, -EFAULT);
>  }
>  
> -static int test_read_access(char *addr, size_t size, size_t pagesize)
> +static int test_read_access(char *addr, size_t size)
>  {
> -	size_t offs;
>  	int ret;
>  
>  	if (signal(SIGSEGV, signal_handler) == SIG_ERR)
>  		return -EINVAL;
>  
>  	ret = sigsetjmp(sigjmp_buf_env, 1);
> -	if (!ret) {
> -		for (offs = 0; offs < size; offs += pagesize)
> -			/* Force a read that the compiler cannot optimize out. */
> -			*((volatile char *)(addr + offs));
> -	}
> +	if (!ret)
> +		force_read_pages_in_range(addr, size);
> +

LGTM

>  	if (signal(SIGSEGV, SIG_DFL) == SIG_ERR)
>  		return -EINVAL;
>  
> @@ -138,7 +135,7 @@ FIXTURE_SETUP(pfnmap)
>  		SKIP(return, "Invalid file: '%s'. Not pfnmap'ed\n", file);
>  
>  	/* ... and want to be able to read from them. */
> -	if (test_read_access(self->addr1, self->size1, self->pagesize))
> +	if (test_read_access(self->addr1, self->size1))
>  		SKIP(return, "Cannot read-access mmap'ed '%s'\n", file);
>  
>  	self->size2 = 0;
> @@ -243,8 +240,7 @@ TEST_F(pfnmap, fork)
>  	ASSERT_GE(pid, 0);
>  
>  	if (!pid) {
> -		EXPECT_EQ(test_read_access(self->addr1, self->size1,
> -					   self->pagesize), 0);
> +		EXPECT_EQ(test_read_access(self->addr1, self->size1), 0);
>  		exit(0);
>  	}
>  
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 40799f3f0213..65a89ceca4a5 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -652,11 +652,7 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
>  	}
>  	madvise(*addr, fd_size, MADV_HUGEPAGE);
>  
> -	for (size_t i = 0; i < fd_size; i++) {
> -		char *addr2 = *addr + i;
> -
> -		FORCE_READ(*addr2);
> -	}
> +	force_read_pages_in_range(*addr, fd_size);

LGTM

>  
>  	if (!check_huge_file(*addr, fd_size / pmd_pagesize, pmd_pagesize)) {
>  		ksft_print_msg("No large pagecache folio generated, please provide a filesystem supporting large folio\n");
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index 6ad32b1830f1..74bdf96161d7 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -54,6 +54,12 @@ static inline unsigned int pshift(void)
>  	return __page_shift;
>  }
>  
> +static inline void force_read_pages_in_range(char *addr, size_t len)
> +{
> +	for (size_t i = 0; i < len; i += psize())
> +		FORCE_READ(addr[i]);
> +}
> +

Reviewed-by: Dev Jain <dev.jain@arm.com>

>  bool detect_huge_zeropage(void);
>  
>  /*

