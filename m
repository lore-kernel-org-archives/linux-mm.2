Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B3B61062868
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 11:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 498756B008A; Wed, 11 Mar 2026 07:25:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4431B6B008C; Wed, 11 Mar 2026 07:25:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386086B0092; Wed, 11 Mar 2026 07:25:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1607C6B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:25:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1DF387456
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:25:38 +0000 (UTC)
X-FDA: 84533551956.02.6147373
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1EB4DC0009
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:25:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OLWyz3wL;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773228337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pn67ISwRgfM/OxPq5DgWNy6SqvqrfQpKI3MEziuo1j8=;
	b=if/qDBXsy2EwmPspLM/5wd3Be75eCqg8EHHVSzvTBv96hS+Abc2/R2BqO1YDEPph4Wp4HI
	HKUpWGHeNc/bKQhskQtn6LohGn95Hs6vR/HeScdvNVCayic3c2q75B+823MwWamRLcxdiY
	pHYBVLQ2lPqpZNkOHOjv4Y5EH/GjkdM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773228337; a=rsa-sha256;
	cv=none;
	b=nWO7mfXDF5Ecc4W0kw1HH9ooiGHQER+dG9K1hska81xsNeMB4JRf90P7TL+gghwI1utOck
	gYt051BeYHVsEAbwjh9NhU4Afu3HsW4cyJ8op5aHMCMAB/Gcox1rHK+Jb/3OfQ3q0yEm8r
	RGkXgSDQw4qdiuASJ2If0A7HiNtgAWw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OLWyz3wL;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 674A060145;
	Wed, 11 Mar 2026 11:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BA3C2BC86;
	Wed, 11 Mar 2026 11:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773228336;
	bh=g2Y9MMMbhifyD8xLlvkjBkRE67yfHE5Dqvk7AeX9N9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OLWyz3wL7cjrXH3nCYFFOCr6iBlPMoNfNKuHBkEz9i9TuXzLeg51ZAzTrQu/IqSN8
	 7wfMjDnru52+BTWs5gMNyWzcHWvW9yt4WnxGvGye9oFDTy3ZQeUEYt7WAiI1c5hNN3
	 bp/fhfoY2U0wSt4a1+z0iV1aJ5Q+1fPSTRP7uPyvRnRqi6D3OQWX1kkRb3hWyuzeiN
	 TVLwxtL1hiZgkuXCs/ofSIfFSLHf5Aa1kq67BoqxaLLsJJEZ1b+7pZ+d6CsmaKl1O6
	 XMgI3i4yJloFaaemM9iBUiPo72GHO6foAkw7xbjShZjFd/MKLRgWmbcPtB2/+umUEA
	 uzPjNC4TqgD2A==
Date: Wed, 11 Mar 2026 11:25:30 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com, 
	shuah@kernel.org
Subject: Re: [PATCH v2 2/2] selftests/mm: verify droppable mappings cannot be
 locked
Message-ID: <55662200-c212-4146-bc23-7f3d210de3ee@lucifer.local>
References: <20260310155821.17869-1-anthony.yznaga@oracle.com>
 <20260310155821.17869-2-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310155821.17869-2-anthony.yznaga@oracle.com>
X-Stat-Signature: xwso491ussd5r5kfsihy1bcxdbx7f1s5
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EB4DC0009
X-Rspamd-Server: rspam12
X-HE-Tag: 1773228336-437078
X-HE-Meta: U2FsdGVkX18FrDPBwZiOyW4Jkq+zh44jmRPgpfk9+oikoO4fcNnNVCRJ+O/b0NtlBLvqGpiSM3btf3n7Yqs+6K39o7wDWxt2hQwLSEi+DcoidCWk2SmUoqLkKcuDLivWLEd264+3wjJgPdMDpP11q7QvWPVmcijT1qNKazI3oz+oCcVA1agMHUEQ2oUnAQGNUmtt8xuUW/3h61eV5xeQMU6/sinDzq/pN+dT7qQ9Jk+Hc7xZpr/SJKm7HEEcGHhW3/yM8XBvLIqhpm4epwEcCRgbXd2fXzYFENxkCFrL3lDWGU0PcHNdIXBBt93BPQxL9UPO99qSFB3mkw7KzvzUaOi8W/3vF0iVtQbijwRQs8XdMlkhfsu+Q87Q8WbEoTPUpVJBGG/T29QKEkLCdOQ4oCajU90bo3tkuWMJMUgDCm8Re8B1iwU9BfVM3Pp56lXe1wCWL6kPk9mTLQCJ80kjEtKT32BM4GDy+GJnd+8rHbHkUcf0WeKzD8JFDU4W9+QmCCJ597RRQnhCnU7LBX6z+R3/9fHLrLuJtwPQ3pUZsJeBqVI0mvoFsHyUmCtbm/2UxiVBn1PcVHkfGVa0A6R49Y5GAenJcnS8mQdVirONLik0Y/MUYJ67UnfxqXK21pfDVuMwd6NTiHwyPKwV43kUJOviOE99SriXtMTnHdE3SFeSEpDs6viW2qHqDdKJ8E1WHbBGR7e3BA04mGEtpElBZc4EgDPNCTAoZsoPCREEqzPO/TgeBLjkBGrgVXm+Y8PUb9Y0IutpiVwPeQqac24C7Bslsl93Y0Z1r3683jI/vEXA+zi42e3r2fAQzbH6BErbA8xY9Y8S+z/nFYkE9DfVa9aVubuOEz7WbrlPxKxaj0/AoB26T47pOQYAfsJqXA7IDGmEh4z83b727cLw0PyRgSIE4L5biGnBwxJNlwYe+/Clrzu/+prK2ZNz8ETsteo3bDPr59kTeUNq6dRaSna
 mWYwTtYi
 MxU9Tp2YzzF4xvG3iukYTCTsrnCfKJT5FKKp6G54cg0W8ERFTNe3XYfxqrbCXNsSDFmc1mvDqaM/FrJGYVdAtocUxGigwYJ7JhhedQl6l1J6UMy2ZogSLYbKqI8vFjktEllS2sNI5MOYzaEQGL1DALDoLMkp5NzAAXDEPmPKH5Yj8bZIzqTgbPV/rwF3WUXaY8vLfKTEjcVJoqx0y2q5s5UHeyJmC4sJV1SYeCNHr8dBcBRPCc/nqSpfvKSFgimbzIfgU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 08:58:21AM -0700, Anthony Yznaga wrote:
> Verify that a mapping created with MAP_DROPPABLE cannot be locked
> via mlock(), and that it will not be locked if it's created after
> mlockall(MCL_FUTURE).
>
> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>

Can confirm this test fails before your patch and passes after, so LGTM :)

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Tested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/mlock2-tests.c | 78 ++++++++++++++++++++---
>  1 file changed, 69 insertions(+), 9 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/mlock2-tests.c b/tools/testing/selftests/mm/mlock2-tests.c
> index b474f2b20def..b5790e717dd6 100644
> --- a/tools/testing/selftests/mm/mlock2-tests.c
> +++ b/tools/testing/selftests/mm/mlock2-tests.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #define _GNU_SOURCE
>  #include <sys/mman.h>
> +#include <linux/mman.h>
>  #include <stdint.h>
>  #include <unistd.h>
>  #include <string.h>
> @@ -163,14 +164,17 @@ static int lock_check(unsigned long addr)
>  	return (vma_rss == vma_size);
>  }
>
> -static int unlock_lock_check(char *map)
> +static int unlock_lock_check(char *map, bool mlock_supported)
>  {
> -	if (is_vmflag_set((unsigned long)map, LOCKED)) {
> +	if (!is_vmflag_set((unsigned long)map, LOCKED))
> +		return 0;
> +
> +	if (mlock_supported)
>  		ksft_print_msg("VMA flag %s is present on page 1 after unlock\n", LOCKED);
> -		return 1;
> -	}
> +	else
> +		ksft_print_msg("VMA flag %s is present on an unsupported VMA\n", LOCKED);
>
> -	return 0;
> +	return 1;
>  }
>
>  static void test_mlock_lock(void)
> @@ -196,7 +200,7 @@ static void test_mlock_lock(void)
>  		ksft_exit_fail_msg("munlock(): %s\n", strerror(errno));
>  	}
>
> -	ksft_test_result(!unlock_lock_check(map), "%s: Unlocked\n", __func__);
> +	ksft_test_result(!unlock_lock_check(map, true), "%s: Unlocked\n", __func__);
>  	munmap(map, 2 * page_size);
>  }
>
> @@ -296,7 +300,7 @@ static void test_munlockall0(void)
>  		ksft_exit_fail_msg("munlockall(): %s\n", strerror(errno));
>  	}
>
> -	ksft_test_result(!unlock_lock_check(map), "%s: No locked memory\n", __func__);
> +	ksft_test_result(!unlock_lock_check(map, true), "%s: No locked memory\n", __func__);
>  	munmap(map, 2 * page_size);
>  }
>
> @@ -336,7 +340,61 @@ static void test_munlockall1(void)
>  		ksft_exit_fail_msg("munlockall() %s\n", strerror(errno));
>  	}
>
> -	ksft_test_result(!unlock_lock_check(map), "%s: No locked memory\n", __func__);
> +	ksft_test_result(!unlock_lock_check(map, true), "%s: No locked memory\n", __func__);
> +	munmap(map, 2 * page_size);
> +}
> +
> +/*
> + * Droppable memory should not be lockable.
> + */
> +static void test_mlock_droppable(void)
> +{
> +	char *map;
> +	unsigned long page_size = getpagesize();
> +
> +	/*
> +	 * Ensure MCL_FUTURE is not set.
> +	 */
> +	if (mlockall(MCL_CURRENT))
> +		ksft_exit_fail_msg("mlockall(MCL_CURRENT): %s\n", strerror(errno));
> +	if (munlockall())
> +		ksft_exit_fail_msg("munlockall() %s\n", strerror(errno));
> +
> +	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
> +		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
> +	if (map == MAP_FAILED)
> +		ksft_exit_fail_msg("mmap error: %s", strerror(errno));
> +
> +	if (mlock2_(map, 2 * page_size, 0)) {
> +		munmap(map, 2 * page_size);
> +		ksft_exit_fail_msg("mlock2(0): %s\n", strerror(errno));
> +	}
> +
> +	ksft_test_result(!unlock_lock_check(map, false), "%s: droppable memory not locked\n",
> +			__func__);
> +
> +	munmap(map, 2 * page_size);
> +}
> +
> +static void test_mlockall_future_droppable(void)
> +{
> +	char *map;
> +	unsigned long page_size = getpagesize();
> +
> +	if (mlockall(MCL_CURRENT | MCL_FUTURE))
> +		ksft_exit_fail_msg("mlockall(MCL_CURRENT | MCL_FUTURE): %s\n", strerror(errno));
> +
> +	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
> +		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
> +
> +	ksft_test_result(!unlock_lock_check(map, false), "%s: droppable memory not locked\n",
> +			__func__);
> +
> +	if (munlockall()) {
> +		munmap(map, 2 * page_size);
> +		ksft_exit_fail_msg("munlockall() %s\n", strerror(errno));
> +	}
> +
>  	munmap(map, 2 * page_size);
>  }
>
> @@ -442,7 +500,7 @@ int main(int argc, char **argv)
>
>  	munmap(map, size);
>
> -	ksft_set_plan(13);
> +	ksft_set_plan(15);
>
>  	test_mlock_lock();
>  	test_mlock_onfault();
> @@ -451,6 +509,8 @@ int main(int argc, char **argv)
>  	test_lock_onfault_of_present();
>  	test_vma_management(true);
>  	test_mlockall();
> +	test_mlock_droppable();
> +	test_mlockall_future_droppable();
>
>  	ksft_finished();
>  }
> --
> 2.47.3
>

