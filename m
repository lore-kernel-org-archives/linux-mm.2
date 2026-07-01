Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D2AAC44500
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:49:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36FF26B00AD; Wed,  1 Jul 2026 04:49:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FA276B00AE; Wed,  1 Jul 2026 04:49:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C2026B00AF; Wed,  1 Jul 2026 04:49:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E62A56B00AD
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:49:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6DDCEA02AC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:49:07 +0000 (UTC)
X-FDA: 84939583134.17.53880BE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6524D40003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:49:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DCF8E1hK;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782895745;
	b=MPjUN2VJzu6fsiazDy/GZgC/CkxnyicZPlBbI5WGbnTjCRPDNi9jNMwuuKq+nRfHDD+Y5C
	FVRCsrDRAFaoHS/1IJ9Bk6esuTeLvFP2wjVDrOLRkFnthRWT7AsZHef3DinZeRyFXgsVvC
	/0kyQyJzdG9qybHIjP8dtpoa8Xnk+NY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782895745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/gfVZ0tbN522JSQK9ZU9tFZBIS6aya25eaac0FCp5qE=;
	b=GH6tqMhl4jR70Q374anoHdCn4pyNhrH0KattAUpo5/oiofQYOoIZR8mVkdm6xERFZB3D4m
	B4d4diBONlZGU/ArvwUBjQP0arLZzQ/r9FK50aYe2lBkiUi2lKmasfwoC/uWw6ph/7WsMM
	KaDc9BCJI0oTV+R6p5LGQ6PjFVIEjUE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DCF8E1hK;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E50981691;
	Wed,  1 Jul 2026 01:48:59 -0700 (PDT)
Received: from [10.57.81.2] (unknown [10.57.81.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F3343F85F;
	Wed,  1 Jul 2026 01:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782895744; bh=Z4DMcLKWNEYBuHOrNSOaBA8OkObvEM97eR0cmiDbrSE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DCF8E1hKCX/we4jcQFdCXBz1KdtORPITdZo51MlCPaSJZwsdEwfn/OMwrVmIClW08
	 Fj5iilMuHRihIExwCZU5voiOTqw4AROJqmKAAPIkpS9DgVw5SArlhsu56Cicpiaw5i
	 CGISkScX2vqKL5phTgG+z5jzzaC/gNgui67syTBc=
Message-ID: <8cb49784-9083-4595-8be8-6c64d5d4dfd4@arm.com>
Date: Wed, 1 Jul 2026 10:48:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 4/5] selftests/mm: add missing mmap() return checks in
 pkey tests
To: Hongfu Li <lihongfu@kylinos.cn>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, keith.lucas@oracle.com, maddy@linux.ibm.com,
 usama.anjum@collabora.com, yury.khrustalev@arm.com, jhubbard@nvidia.com,
 joey.gouly@arm.com, zwisler@google.com, hongfu.li@linux.dev
References: <20260630073235.3802271-1-lihongfu@kylinos.cn>
 <20260630073235.3802271-5-lihongfu@kylinos.cn>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260630073235.3802271-5-lihongfu@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6524D40003
X-Stat-Signature: uw53sbigekj9qu6jjhpwhwftf4y7bhcc
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782895745-790935
X-HE-Meta: U2FsdGVkX1+5DUR77sPeEvgic0Ye51HsXuErdb692kXV04Fnwni6J5ZGkpj2Ey6WonNiCId7Av94DQnHDE2QVzilt+pkq5+tOF0VLzYAM3OlJJ/jdgYsOlpps8Oj8/ktHurz8KG+g5Hy9/4eHKYgB8x0hCf/u6jhlQgQVtRo1OaLm19fvnm2YkndLdNGOl4yJNDtC8MLBkO84z50rctY99lTnMuDcciczi2OGP3VEvZpWwZyzMkx/DjIfJ9nL38E/+fQIwVs1mBH3+HWjxAOYx0mnZ9lFuYM14+rd7OGg4XztxyhMAVsbV4zlUz+RR4Eo5BzDYmf3jTo0dewGyqB8lQNkk8SycjgeAmg3Vl5OOXS+rs2LAK14vd2kkQp8SflSByCrp61NbqNs2rjL51JOABSfk7M5CRAwub3bt4SSfoYOVqk62DQtF5KFZ0U9WQQdL+sBp+9vsS5/CAEL+wNL/99UQuJeO0aEvaOdDRcNmxwU3v19XoFXRQkpEdeU4Hz33jnLcqhaYhEVdbwsZHj9YSmvNfDPpz0dYOwAV4bbff0V9cHTF4N9rSubtrfsh3hnfwYW+BCEKmUnSHIFvjqD1VRXj9XZriQeeLNDH8Q5pkn0EBNzCOd3lLXTx3EiV5Jo9Oorsug12uTTMECconz7fGdb0gX0W1JqPhlE0igXuLiQ9pPiQ29x6FPpxxL54dvBI7iD5gKxjyztCZch3joQhMmAJK9vvsrVLM9f8OJZWwD6VashE7OAosFTO6Os25pzKJdJtOBmRJ3J32VhF/diOT79pTBYZxfIEDNsvCOTt+7mBWZElwaUlCzhzqKLdUlkv/YgweWC70iNKTaRZRz2C5BE5JcuJD9GxlvixxOMidsl6ynkY3NWY1EiqGb2f2VNkLT+mvaOofUOzSxiyUKu9miEFyEzDL9LOiw5bVP8C8MSO0s4HYFkgPIwnbm0qZIpujbQHJYtnksc+hWMUY
 HrkugkOv
 HI9JxFajUOcT8DEWKsBrQE5Hppl4yinZIl+VgJBNqe8ynBpzLB5gnstmS8KZxvo5RQfKjkAZb63gnCfTHet7LZYZAGBR962iiZT3ubRS+Oqw9Ny7Ft0w9vvU/AeH1AWLvm+hewYZTBipswn73Sp0u0BEGxcGW00U5WOx403sT9i6kR6MnGMF9+Fri/hvH2Ymv//vLvPP3oadNlFDQwp3NIfBPRZ3PiyttSweoINdwZMDOD52gJ1Xkm497J4g1z5b5ickyW4j2Znrt5JqxMvl04a7JiiidnleZRT7eQPjt5IbEMqFG2NnE3ahPhKRsnmCo7rKxDBRECiITj9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/06/2026 09:32, Hongfu Li wrote:
> Add missing checks against mmap() return value, replace (void *)-1
> with MAP_FAILED for better readability and consistency.
>
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

> ---
>  tools/testing/selftests/mm/pkey-powerpc.h          |  2 +-
>  tools/testing/selftests/mm/pkey_sighandler_tests.c |  2 ++
>  tools/testing/selftests/mm/protection_keys.c       | 12 +++++++-----
>  3 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/pkey-powerpc.h b/tools/testing/selftests/mm/pkey-powerpc.h
> index 17bf2d1b0192..2ce85580b404 100644
> --- a/tools/testing/selftests/mm/pkey-powerpc.h
> +++ b/tools/testing/selftests/mm/pkey-powerpc.h
> @@ -126,7 +126,7 @@ static inline void *malloc_pkey_with_mprotect_subpage(long size, int prot, u16 p
>  			size, prot, pkey);
>  	pkey_assert(pkey < NR_PKEYS);
>  	ptr = mmap(NULL, size, prot, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> -	pkey_assert(ptr != (void *)-1);
> +	pkey_assert(ptr != MAP_FAILED);
>  
>  	ret = syscall(__NR_subpage_prot, ptr, size, NULL);
>  	if (ret) {
> diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> index 882928f2912b..d185d3da26cf 100644
> --- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
> +++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> @@ -317,6 +317,7 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
>  	/* Set up alternate signal stack that will use the default MPK */
>  	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
>  			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	pkey_assert(sigstack.ss_sp != MAP_FAILED);
>  	sigstack.ss_flags = 0;
>  	sigstack.ss_size = STACK_SIZE;
>  
> @@ -492,6 +493,7 @@ static void test_pkru_sigreturn(void)
>  	/* Set up alternate signal stack that will use the default MPK */
>  	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
>  			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	pkey_assert(sigstack.ss_sp != MAP_FAILED);
>  	sigstack.ss_flags = 0;
>  	sigstack.ss_size = STACK_SIZE;
>  
> diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
> index e504544e2197..96a4eb26f326 100644
> --- a/tools/testing/selftests/mm/protection_keys.c
> +++ b/tools/testing/selftests/mm/protection_keys.c
> @@ -586,7 +586,7 @@ static void *malloc_pkey_with_mprotect(long size, int prot, u16 pkey)
>  			size, prot, pkey);
>  	pkey_assert(pkey < NR_PKEYS);
>  	ptr = mmap(NULL, size, prot, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> -	pkey_assert(ptr != (void *)-1);
> +	pkey_assert(ptr != MAP_FAILED);
>  	ret = mprotect_pkey((void *)ptr, PAGE_SIZE, prot, pkey);
>  	pkey_assert(!ret);
>  	record_pkey_malloc(ptr, size, prot);
> @@ -609,7 +609,7 @@ static void *malloc_pkey_anon_huge(long size, int prot, u16 pkey)
>  	 */
>  	size = ALIGN_UP(size, HPAGE_SIZE * 2);
>  	ptr = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> -	pkey_assert(ptr != (void *)-1);
> +	pkey_assert(ptr != MAP_FAILED);
>  	record_pkey_malloc(ptr, size, prot);
>  	mprotect_pkey(ptr, size, prot, pkey);
>  
> @@ -667,7 +667,7 @@ static void *malloc_pkey_hugetlb(long size, int prot, u16 pkey)
>  	size = ALIGN_UP(size, HPAGE_SIZE * 2);
>  	pkey_assert(pkey < NR_PKEYS);
>  	ptr = mmap(NULL, size, PROT_NONE, flags, -1, 0);
> -	pkey_assert(ptr != (void *)-1);
> +	pkey_assert(ptr != MAP_FAILED);
>  	mprotect_pkey(ptr, size, prot, pkey);
>  
>  	record_pkey_malloc(ptr, size, prot);
> @@ -696,7 +696,7 @@ static void *malloc_pkey(long size, int prot, u16 pkey)
>  		pkey_assert(malloc_type < nr_malloc_types);
>  
>  		ret = pkey_malloc[malloc_type](size, prot, pkey);
> -		pkey_assert(ret != (void *)-1);
> +		pkey_assert(ret != MAP_FAILED);
>  
>  		malloc_type++;
>  		if (malloc_type >= nr_malloc_types)
> @@ -1114,6 +1114,7 @@ static void arch_force_pkey_reg_init(void)
>  	 * doing the XSAVE size enumeration dance.
>  	 */
>  	buf = mmap(NULL, 1*MB, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> +	pkey_assert(buf != MAP_FAILED);
>  
>  	/* These __builtins require compiling with -mxsave */
>  
> @@ -1680,7 +1681,8 @@ int main(void)
>  		ksft_print_msg("running PKEY tests for unsupported CPU/OS\n");
>  
>  		ptr  = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> -		assert(ptr != (void *)-1);
> +		if (ptr == MAP_FAILED)
> +			ksft_exit_fail_perror("mmap");
>  		test_mprotect_pkey_on_unsupported_cpu(ptr, 1);
>  		ksft_test_result_pass("pkey on unsupported CPU/OS\n");
>  		ksft_finished();

