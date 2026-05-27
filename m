Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CB9ACD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4E0A6B009B; Wed, 27 May 2026 07:36:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFE9E6B00A0; Wed, 27 May 2026 07:36:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B12416B00A1; Wed, 27 May 2026 07:36:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E8246B009B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:36:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61BBAC1F9F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:36:56 +0000 (UTC)
X-FDA: 84812998032.03.AB8738E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B1C2B40006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:36:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EL6n3kFf;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779881814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cWyAXfxkJ0OK1+aWG2AROwswRdbTKVGE9pihFAZOTCs=;
	b=KHvj/nsRvEEEou+D0t4T2tcHIBauUwE7WfRGklpWFfKvL3c+pmVJvVk3k7reywUiEjAGq2
	pIFcEPt9A5gwKiCJsCtgPdcH/bUyRARPr3VI6YYf+BufaDMK3AgcvdiQkh3XUl3/oRpNT2
	RmlSD28EpwT86lTTpwaAz8N9nVnVPro=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EL6n3kFf;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779881814; a=rsa-sha256;
	cv=none;
	b=Kv2Y8X3bPXhD8sP/657XnR8mKhTt01bdYENvF9I5H+ydW2pW9muohabSRyLkXO7i6rGifF
	H8viousWXiPazGGS1ACg8LBaXAT5kkxrvaOft96OqkP4JLgJckDJYkwDIFiVFZ3fZplmz4
	iwxIHGjZ6pDKS9+q47/YXQzyRdQSkx8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B5E3342DFD;
	Wed, 27 May 2026 11:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F4D1F000E9;
	Wed, 27 May 2026 11:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779881813;
	bh=cWyAXfxkJ0OK1+aWG2AROwswRdbTKVGE9pihFAZOTCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EL6n3kFfdtIfCsJ9lWwI/tSIgLOF+l8Rj8FjYOpyiP8WTfOe5RswzNNJDMiVP3UQy
	 WMWAeB/75WeuoflS2JUxgfMHw2e2ZeqqLe11x5RZUJQWjvtq8OyRF5Ekxf7As1RV4R
	 L3WR8T1nTK5gPb/92U9M6tM1a/q+KKLBqGoqBMAe0UXlzLGuCS6+tsOYL2zZHDAxfP
	 PjuIgFguXEOUuYxlvzsh5N1Kr/1BrKripB5HQen1yZfJ/m/E3JWb0Li7sAD8WLVh05
	 JBn1gxiHgUk/8HRx5ad4y0mutfnoe0hprHYd6JKi8u0DX0zSeYE7QOnn1BasvNLy2Q
	 /lZjI2AazqKTA==
Date: Wed, 27 May 2026 14:36:46 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] selftests/mm: add missing mmap() return checks in
 pkey tests
Message-ID: <ahbXTqLLLcYmeTp2@kernel.org>
References: <20260527013825.1134225-1-lihongfu@kylinos.cn>
 <20260527013825.1134225-3-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527013825.1134225-3-lihongfu@kylinos.cn>
X-Stat-Signature: nhx7n3qwehx5uac4159ahdnofsscmrmm
X-Rspamd-Queue-Id: B1C2B40006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779881814-253920
X-HE-Meta: U2FsdGVkX18exmJSSNLg73D6NPAad86lyAAF6NUHv/7/+5vDF6aiCd8N/Db+XISj5wLC9UBWv0H43J2u9bVLNncmW/EawMHOtq6CCcMgnO4DBcppbbRP2XO4GRTBcoG9tszAvRvvF3IBZVVl0VR77THdvKux/NEHelxqnv788rBvi32nc9OzeMPWGWf92Hy69NStHank9FKMXdHMI5nmeqoYGjLfxBL8d+VJklBB/kzPDa+xTaQrzIXCw7Mc03cynthU0xWfcskfHM0jOWvJxMZT4Kl7rNChM6fOzmz/MSC17ZXQenMjoaMMUNbwogJkMCk6cS508xCKUjbwqmFx3f5bHtgSfODz4jwzXdJrbeMJr/tVSnQBNYhq1OxJCKEEpzIBB0RrW/tOis1c6oKxRVj++BzXyV2uZj/ap7piATfFIStYLXq/7ycSXI+Vr3VIHoUlzVFyH/OcYuouPos5j0vLE1yb+0340IWcQLLTxqizx4zsT5SJaGzI/G3uS5hVDauwSg5Lqgy3PvWBFmCYYTXoWCY9xQhY6MC9ZgjmzY9DhCLce4EpxwRavjaGT/NUImhC/xSPmSTxsYd6L2tcaTQnLK1rXnjx8hGpgmd0J54k5nnwhbvemKiI5m7IfyChJT+jH3d9M6j2lz75FgPTYEIiS29jWfDQCQgzfRKfljBLVQ/CYdGtjOlhlBvL4NxV/I0kzi0Q6WQ9kJIY/ko+loPND8BceCC0u6hA7SQqt51GPFrnKtNNOs80HvmQ2tc0XMONIcyXdRFx/qkLiBJ4FKANqSzR2gn2Y9J7JdbEL7jB7mkAb1UAJHIA+YlMoP+BPKnWna3O9JaR6vu1ToGFxqI/Mf6ddnstbLBBs7vdlHihHLpxbTkdHj6crlsld4jA8XNEXFaESbTwVEdz+TBbCxgsn28Pm5C4xaeoJDx1oI7NLpeo8beCi+QNE7g0ikWMaQrQqk6YE8QeuxGLiE8
 exSYGlZ/
 uSndPiyeLdSVIWhbACGT8wL8hS1ah3dhVanwCRzjpIKNCIKpz/ieO25EAbTIWN5OaJRpVnmkAAdCFQoY33FGSRve8/8Mx8xRHabVQ/7bIbR6az0On/3mcf/oE7nfMG+/rl8rp804yOdYpn9hL9qApzaq/p2AP+I2g4p6PIVaUUfpBQpSjsrORK/+q2S1Mf8ZOjr/7wgNyXgvAO0Sp1D1+aYa+HIY/HhtQiAJX5BiVMN+q9J4KDwPFT8VX3RNlft/tDV66
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 09:38:25AM +0800, Hongfu Li wrote:
> Add missing checks against mmap() return value, replace (void *)-1
> with MAP_FAILED for better readability and consistency.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
>  tools/testing/selftests/mm/pkey-powerpc.h        |  2 +-
>  .../testing/selftests/mm/pkey_sighandler_tests.c |  2 ++
>  tools/testing/selftests/mm/protection_keys.c     | 16 ++++++++++------
>  3 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/pkey-powerpc.h b/tools/testing/selftests/mm/pkey-powerpc.h
> index 17bf2d1b0192..f482b1abcf55 100644
> --- a/tools/testing/selftests/mm/pkey-powerpc.h
> +++ b/tools/testing/selftests/mm/pkey-powerpc.h
> @@ -126,7 +126,7 @@ static inline void *malloc_pkey_with_mprotect_subpage(long size, int prot, u16 p
>  			size, prot, pkey);
>  	pkey_assert(pkey < NR_PKEYS);
>  	ptr = mmap(NULL, size, prot, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> -	pkey_assert(ptr != (void *)-1);
> +	pkey_assert(ptr != (void *)MAP_FAILED);
>  
>  	ret = syscall(__NR_subpage_prot, ptr, size, NULL);
>  	if (ret) {
> diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> index 231dfb079075..475aa3e3208a 100644
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
> @@ -486,6 +487,7 @@ static void test_pkru_sigreturn(void)
>  	/* Set up alternate signal stack that will use the default MPK */
>  	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
>  			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	pkey_assert(sigstack.ss_sp != MAP_FAILED);
>  	sigstack.ss_flags = 0;
>  	sigstack.ss_size = STACK_SIZE;
>  
> diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
> index 3c0cbf8f3eaa..ae474e65f3aa 100644
> --- a/tools/testing/selftests/mm/protection_keys.c
> +++ b/tools/testing/selftests/mm/protection_keys.c
> @@ -585,7 +585,7 @@ static void *malloc_pkey_with_mprotect(long size, int prot, u16 pkey)
>  			size, prot, pkey);
>  	pkey_assert(pkey < NR_PKEYS);
>  	ptr = mmap(NULL, size, prot, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> -	pkey_assert(ptr != (void *)-1);
> +	pkey_assert(ptr != MAP_FAILED);
>  	ret = mprotect_pkey((void *)ptr, PAGE_SIZE, prot, pkey);
>  	pkey_assert(!ret);
>  	record_pkey_malloc(ptr, size, prot);
> @@ -608,7 +608,7 @@ static void *malloc_pkey_anon_huge(long size, int prot, u16 pkey)
>  	 */
>  	size = ALIGN_UP(size, HPAGE_SIZE * 2);
>  	ptr = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> -	pkey_assert(ptr != (void *)-1);
> +	pkey_assert(ptr != MAP_FAILED);
>  	record_pkey_malloc(ptr, size, prot);
>  	mprotect_pkey(ptr, size, prot, pkey);
>  
> @@ -688,7 +688,7 @@ static void *malloc_pkey_hugetlb(long size, int prot, u16 pkey)
>  	size = ALIGN_UP(size, HPAGE_SIZE * 2);
>  	pkey_assert(pkey < NR_PKEYS);
>  	ptr = mmap(NULL, size, PROT_NONE, flags, -1, 0);
> -	pkey_assert(ptr != (void *)-1);
> +	pkey_assert(ptr != MAP_FAILED);
>  	mprotect_pkey(ptr, size, prot, pkey);
>  
>  	record_pkey_malloc(ptr, size, prot);
> @@ -717,7 +717,7 @@ static void *malloc_pkey(long size, int prot, u16 pkey)
>  		pkey_assert(malloc_type < nr_malloc_types);
>  
>  		ret = pkey_malloc[malloc_type](size, prot, pkey);
> -		pkey_assert(ret != (void *)-1);
> +		pkey_assert(ret != MAP_FAILED);
>  
>  		malloc_type++;
>  		if (malloc_type >= nr_malloc_types)
> @@ -1135,6 +1135,7 @@ static void arch_force_pkey_reg_init(void)
>  	 * doing the XSAVE size enumeration dance.
>  	 */
>  	buf = mmap(NULL, 1*MB, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> +	pkey_assert(buf != MAP_FAILED);
>  
>  	/* These __builtins require compiling with -mxsave */
>  
> @@ -1693,7 +1694,10 @@ int main(void)
>  		printf("running PKEY tests for unsupported CPU/OS\n");
>  
>  		ptr  = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> -		assert(ptr != (void *)-1);
> +		if (ptr == MAP_FAILED) {
> +			perror("mmap");
> +			return EXIT_FAILURE;
> +		}

Just stick to pkey_assert() everywhere, it already prints errno and exits.

>  		test_mprotect_pkey_on_unsupported_cpu(ptr, 1);
>  		exit(0);
>  	}
> @@ -1706,5 +1710,5 @@ int main(void)
>  		run_tests_once();
>  
>  	printf("done (all tests OK)\n");
> -	return 0;
> +	return EXIT_SUCCESS;

Completely unrelated and not needed.

And you may want to base your work on mm-unstable to get up to date version
of protection_keys tests.

>  }
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

