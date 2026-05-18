Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BBAACD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 10:45:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10DC86B0005; Mon, 18 May 2026 06:45:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BE296B0088; Mon, 18 May 2026 06:45:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F166E6B008C; Mon, 18 May 2026 06:45:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E2F606B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:45:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3FC861A08D0
	for <linux-mm@kvack.org>; Mon, 18 May 2026 10:45:34 +0000 (UTC)
X-FDA: 84780209388.22.1254BAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 74A50A000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 10:45:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CfzoxB+P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779101132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jb+/RPODm6sY0l9iP3FsnfWQZcDW2BclnstKee5C+tw=;
	b=48ZGsSfVszyKjPlFgH/UQRTI3RV8cv65730WqYFtwusHWeTcco6AwCyAxpAPZcl/6JJ+x9
	Ed5FbLNGNBsKAv78pZ7k+47QfKAqSQeMQP4SbhqG0w/5NZZHISTe7V3VpJSM6FKHHmdLsv
	MQxtirEaVkyM3aQBjlUzWczBZWmwpIQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779101132; a=rsa-sha256;
	cv=none;
	b=3qkVYTywHnwAYi0qMDuggVuUNoi97r9xzyOTDSjgUrBQUbJoSfgMcrMg/Dj8Ll+cA4AcWs
	5P60ZglDWRda/BNcbftGWVvTf4mT9oQaKQ9cR1nUuLCjkyP7JkD0psLbtMPvT25wCIMSUt
	K/c2AewxIrgLry8tfweU33pW2IBGz3A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CfzoxB+P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C90F56001A;
	Mon, 18 May 2026 10:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0FAC2BCB7;
	Mon, 18 May 2026 10:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779101131;
	bh=LpK5PBAbXOh54FapZmUdMQXTHQuvbKcipo4+4fbRVkM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CfzoxB+PTe9Vhy4Q3RWjZ6nDr0bipMjQX7KLb/KTwHdcFZNy/GrQWfjOC/RAVrO2y
	 MS3RK9Um2YgMmG1BsEydMZh3SILuOPvoRtmSUFY6mPqJDBRbRZ4ZNwVRSZdHkhgvAu
	 r9mayV4zKRHMeMq4B7t9Hs6GrY6eca29N1THiuXUbYsxCQJyh0DWiAZIZnY77Wi8lE
	 6BYsZew48hmKuLgryfLLNCinyQZw4oLuipzfWq77jXwGUJGCMr7uiWj49odxNpgM6k
	 lqbRkY4kEy/t/dYegItNkpKGESbUgc0PUkjNdFXcaGAk9IjctSj94S/P5B5JiScKHq
	 QKd1RRARK4MNw==
Date: Mon, 18 May 2026 11:45:25 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: add missing mmap() return checks in pkey
 tests
Message-ID: <agrrp5fRWWuMSoYB@lucifer>
References: <20260518082120.3890552-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518082120.3890552-1-lihongfu@kylinos.cn>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 74A50A000A
X-Stat-Signature: 7ob35s4wwgt13jcm6hnj4zo9mctyh5u8
X-Rspam-User: 
X-HE-Tag: 1779101132-48934
X-HE-Meta: U2FsdGVkX18O4yPm/XyoSJU5nW0aA5MQ5QI1bAz3ijfcdity7yoik2ELacclTQRmb8is8MGUcWi+XOaNnVmS17XYeFOAQnE22uWStXu4Pi+X4iqaocIiZ8Z/zwtOmqYklH2ZTKkqQlqxhDxwzodxJBS7dvVjXAJZq3EdRLCY8HlNDYic9CNnEYk9rbn2ELVQBbrkMQ81aA2WV2GukbcuJ3OONxRyaVkkj/zYU36uAzHOHGCVBFEC9VNmYFMP1TmRVlxEg1nNIQJZd73gQOBqdcZo1j4hurO1ORMNc1HFm5KpubwnPKmVhclJgwDSYgcVug2w7u4vqguTt1mXNlGwZSgV1oPf5evSx+H6WYhueZ0itSpt2kPW9RIEwEFkyYXxjVgkAf9GJrwPRAZbyb1F7P/ftq+4gRNvdTcr/Bvs2y8DedHSHV5a7K5QoIgmpCf+fJpHkYVyHM092oYCOANumYnB4xbZafXgyn/PcsyiEKqcZINZrU3eSb3y/CvlxGntA0YFQLGyl2W0rGERCK/m08BwTL0iWy9fgHj3gWwZi9jEeoWXg1cmz3c3pBSl5HPpvuXsX6kKIZoGjhc4X6qFoK1PUC5RhXAAPqHK7L8i9fyHedXwDhkER63Q2X1kG1paC/aUjY3YlirnbzdElz4boPN+CYCTcGHGEUDqPpZrWBERFVcoWzYxC+pVjTPCIFbTvnQd0FKfyw8HT/d7bWszlKQI4o5YDfP5cexvFf+Qbj8Mdkowbd8De3AWZ48P2wuhuMf3+trsE7+IN/+KL16qgOD1SpmGppAFcDnYD9n9xvMlppE9qiYSH8Cg+r0z4pGfYfA/rmrieDXiT5pZM9ZE6QE770OsCk15EbhGxZLSYRJQPbjtUqGsPHl4njVzdzP42md1GGjNmDp275pTaWpdy4gRsDeFlsOA+5UrBwLbWUlAQbzgwYdc7wvhXYxVzcQuEonn0F2xivZ3MYDZ1fQ
 dqEldMSh
 Wi1CsgOCARLlHSbMapXOkbdmbtjmnK0n13d17YiShzIU6WtSaU/0I2htIfYEkHP7+aSiK331s++/JPqF9TqxujgVXnvfJdcT9bIvvlUg02pKRr2o+OcaaYDsX83KwF+CFNo8IVThvOwqcAV48lLk5PRO4H1gQ8XVXk7eYZ5UsVH9fR5at/KtyN9OEyqYFBxfFz0M5Y9NF6wK8KdX4yU4EsU2ubVF+Q/7W/yclhsIM8R2MxK+0yo7t3AV/glWorUtEunM6frxAEdCXLFBPd0hu+ghuoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hmm you're sending this separete from the other MAP_FAILED checks, and not
referencing that in any way? (original patch at [0]).

Please just send this as a 2 patch series _with a cover letter_ and both patches
in-reply-to the cover letter.

Also make sure to propagate tags correctly.

[0]:https://lore.kernel.org/all/20260513095609.789935-1-lihongfu@kylinos.cn/

On Mon, May 18, 2026 at 04:21:20PM +0800, Hongfu Li wrote:
> Several mmap() calls lack error checks and would crash on failure.
> Add the missing checks. Also replace bare (void *)-1 with the

Well you're assert()'ing so you're causing a crash on failure anyway?

I'd just say that you are adding missing checks against the mmap() return value,
as well as improving readability and consistency by replacing (void *)-1 with
MAP_FAILED in instances where that was used rather than MAP_FAILED.

> standard MAP_FAILED macro in protection_keys.c for consistency.
>
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Some comments below.

> ---
>  tools/testing/selftests/mm/pkey_sighandler_tests.c | 2 ++
>  tools/testing/selftests/mm/protection_keys.c       | 9 +++++----
>  2 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> index 302fef54049c..4637809192f9 100644
> --- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
> +++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> @@ -317,6 +317,7 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
>  	/* Set up alternate signal stack that will use the default MPK */
>  	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
>  			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	assert(sigstack.ss_sp != MAP_FAILED);

Why not pkey_assert()?

>  	sigstack.ss_flags = 0;
>  	sigstack.ss_size = STACK_SIZE;
>
> @@ -490,6 +491,7 @@ static void test_pkru_sigreturn(void)
>  	/* Set up alternate signal stack that will use the default MPK */
>  	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
>  			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	assert(sigstack.ss_sp != MAP_FAILED);

Why not pkey_assert()?

>  	sigstack.ss_flags = 0;
>  	sigstack.ss_size = STACK_SIZE;
>
> diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
> index 2085982dba69..d53bdc540a74 100644
> --- a/tools/testing/selftests/mm/protection_keys.c
> +++ b/tools/testing/selftests/mm/protection_keys.c
> @@ -667,7 +667,7 @@ static void *malloc_pkey_with_mprotect(long size, int prot, u16 pkey)
>  			size, prot, pkey);
>  	pkey_assert(pkey < NR_PKEYS);
>  	ptr = mmap(NULL, size, prot, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> -	pkey_assert(ptr != (void *)-1);
> +	pkey_assert(ptr != MAP_FAILED);
>  	ret = mprotect_pkey((void *)ptr, PAGE_SIZE, prot, pkey);
>  	pkey_assert(!ret);
>  	record_pkey_malloc(ptr, size, prot);
> @@ -690,7 +690,7 @@ static void *malloc_pkey_anon_huge(long size, int prot, u16 pkey)
>  	 */
>  	size = ALIGN_UP(size, HPAGE_SIZE * 2);
>  	ptr = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> -	pkey_assert(ptr != (void *)-1);
> +	pkey_assert(ptr != MAP_FAILED);
>  	record_pkey_malloc(ptr, size, prot);
>  	mprotect_pkey(ptr, size, prot, pkey);
>
> @@ -770,7 +770,7 @@ static void *malloc_pkey_hugetlb(long size, int prot, u16 pkey)
>  	size = ALIGN_UP(size, HPAGE_SIZE * 2);
>  	pkey_assert(pkey < NR_PKEYS);
>  	ptr = mmap(NULL, size, PROT_NONE, flags, -1, 0);
> -	pkey_assert(ptr != (void *)-1);
> +	pkey_assert(ptr != MAP_FAILED);
>  	mprotect_pkey(ptr, size, prot, pkey);
>
>  	record_pkey_malloc(ptr, size, prot);
> @@ -1217,6 +1217,7 @@ static void arch_force_pkey_reg_init(void)
>  	 * doing the XSAVE size enumeration dance.
>  	 */
>  	buf = mmap(NULL, 1*MB, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> +	pkey_assert(buf != MAP_FAILED);
>
>  	/* These __builtins require compiling with -mxsave */
>
> @@ -1775,7 +1776,7 @@ int main(void)
>  		printf("running PKEY tests for unsupported CPU/OS\n");
>
>  		ptr  = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> -		assert(ptr != (void *)-1);
> +		assert(ptr != MAP_FAILED);

Probably best to convert to pkey_assert() at the same time?

>  		test_mprotect_pkey_on_unsupported_cpu(ptr, 1);
>  		exit(0);
>  	}
> --
> 2.25.1
>

Cheers, Lorenzo

