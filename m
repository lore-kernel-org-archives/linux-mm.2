Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBB60C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0008B6B009B; Mon, 31 Aug 2026 05:01:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1A5F6B009E; Mon, 31 Aug 2026 05:01:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E585A6B009F; Mon, 31 Aug 2026 05:01:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE0556B009B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:01:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3402A403F4
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:01:20 +0000 (UTC)
X-FDA: 85160970720.05.C4DCE40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 99000C000E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:01:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l+hhR8ol;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788166878;
	b=MelAUc1r1BHQ1yiBtIFoxEgqvPHdMhf/nA1GWi1SDbE6T2/p0tick4LMMMsoHixZxhE9j5
	Vo+3pUIe7AR/vl3W1OuT7zJsaxe7/2q0HWzurYXGlUZbtN3w4Rxtaf8CpV95nm3iuRqH5i
	VH6DKXywk+FopUt6qTzeOVxIeBdOLfQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l+hhR8ol;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788166878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nL2SfDvHl/slp/Vs9+nqgca0UCvmmLb4F8E84cwkblI=;
	b=YvSRn3LCrziqqScZXO66EAADf2joamOY9KGct+h4QXXd0jwT/tUuQGK8RwgLNW2DIe3g+8
	hrIKHuBWB3jmLwFB2c5K0qTVv0YT4gO0U67aB/qkSGuhTAh0i+RCjKbp+7bdhHgQkhDLrs
	u3/GKt50H/O6ObyKlqt0NaLZUkezoVw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F897601DB;
	Mon, 31 Aug 2026 09:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3AE1F00A3E;
	Mon, 31 Aug 2026 09:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788166877;
	bh=nL2SfDvHl/slp/Vs9+nqgca0UCvmmLb4F8E84cwkblI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l+hhR8olxSIbnDE85Bd4JLj/P5abWeVEP0QZ8Xh6djK7acwsYipHrnxOgEoYD3mgj
	 0qKMEQ60bSg3exhb8tftJUa0sAuv7vaqzStuKZo03ofWi6+TV9pLVqgF0AEw8ZBY0o
	 nsgUZ0I2cDcptI0LOtsfWvTePiR8c74JIk0RqyDY8zheqrIW3FG0H9rcZuALJ0zmdg
	 wkYq0A8ZOYSOj14zI4BWqTe5VG9h/1i0LZRQ1qhbuS98QT/Peuw2YvMAG09k4z5jKg
	 ED2GGr3C1pUtGydZoc+mH+qeSp3ctnruMhjqGEBwMvyhXLrjY+l3+15wmVMXknnR4O
	 eTE1RyWqjE88A==
Date: Mon, 31 Aug 2026 12:01:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Guillaume Morin <guillaume@morinfr.org>
Cc: linux-mm@kvack.org, leitao@debian.org
Subject: Re: [PATCH v2] selftests/mm: hugetlb_madv_vs_map: add underflow test
Message-ID: <apVC2D11bMz-QHic@kernel.org>
References: <apGbO2QM35VZ8d7a@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apGbO2QM35VZ8d7a@bender.morinfr.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 99000C000E
X-Stat-Signature: zr5jgcnrwauth19jcijmqe6fnrhzk4us
X-HE-Tag: 1788166878-51008
X-HE-Meta: U2FsdGVkX18XY9mYOOLF++uKq/SLO02UG514aNDR3J/bmwOoJCxwsqkQf6VBGsscvKvEHfSAfji//wQkAivBkTcAfCLYowGsh2BoFi3UfBLdyC4fq41OV9TJJ+RVY1i2QX4VWH4qjWZTcUfZVW46Z2w7Pb7J3JtJE9Y5efgh0UUO8pLoo3cFK8AAEY583zf6WJsGVvOyA5Dt72Tja/7BrTJzzlh9MeNnW83F7Ms24WlUwAam1B3zrW4NUXXzTJOjb33AqJwTaHAiD5sVZ5iiJLLtlIEEf6FUKQFJTqerl4FhTiw45zl7uvTTGruYN8ZaUF6ssEg3QIAqE8SCqqwiQZLOfhSqPS4900H6xi9z2a6FelZ2cLQ0Z+Z1CwNQeoWn6KThE4k0reTZ77qz3dWPm7aJ38rZ+Dqju8LY4Pz77B+NyChxhWKXXCDZ2VCUGNRgXdQrZB2UHNb0ecvgyqbg9Ky7nkucyd+8JEdx7CL1Ak1IRgqz08MPmeym8Gq6RQboehJmeC3lJR0y9SYUh8nMzYj9Xgzep7OOH/nT92hoboHBv2bmwBH7sXnehiKzLwXLmMNxpQr4dv7QYtUUI2KjsOTJzHid5T/KA1gerivq4MkJ5io3Birey2EgzAWLThy2fw4duoRW4apS3h6OvdgztaEdn/CYU5AfEXua/5DSQgBhny/apr+k5gJK3+Gbb9bKIeMfH9SvOejAMgvmPvCmSMsMsaeSuZKSmmsdwd6QBvzf6NTTcCW50JZtWm8X8DIq4htg8lVK8idpRb0uoe8jpGouNDuJwAUVr+E1l7kJkWhITN05f6qWMX6e4drR/V83Ls/x4/slk8ityt7aDyJXqOQcLIo6yXLLvUf8hZrFx9PQMSw8tKc11MgMYdH1zlemjotcQ9fWd1ZRcZoqLzbbqSl+14MB+26yefWzViiD0UTVw9XeReShaDDPGVTNv3nt+Wz9TxzH82CTExDvG3c
 OJZt5KAc
 NTiUBT5ixz+Gwz8KaSvmccpGNjjYtHs95lkJvWPALr+ew2531iLeJGZPPuMl+K1AYfO2ZjOb/1/m6TFpv+Mnz3mDMGVteWPQMiZs+EBvGu93bj0Ypw6Mq/H0r91bQBNuMgNLm/Oio2m1meagjDsnHAcO18DFvLreL7Dny9pykpsRGJYxh3DSbVzpEAfKge7B44Dk1zbMzep70r42xMaBzvq6KjE1nXJFSK3BjnlVEQg/DlCM1tegDLGlZJHi+G0mIiNayFPlCDYrvKvxQWcDzKSqIdgLMwWusahPFbM6E0QrhWuk1mFy6qGEzPg243VJj7DM41zxYRfIvQG8Q3PCwUK7J87TAJOvVrFyMM5sl9NL2HvkGtrNW0ZkTAMQmFDI6NJWY1pE1jvWAVkX3NuiCucRNkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 04:29:15PM +0200, Guillaume Morin wrote:
> Add a test that checks for underflows when a parent unmaps the page
> first. Also check that when the child exits the reserve count is
> correct.
> 
> Link: https://lore.kernel.org/all/alEJkwn5VlTTH_ZX@bender.morinfr.org/
> Signed-off-by: Guillaume Morin <guillaume@morinfr.org
> Cc: Breno Leitao <leitao@debian.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> ---
> v2: factor out tests
> 
>  .../testing/selftests/mm/hugepage_settings.c  |   9 ++
>  .../testing/selftests/mm/hugepage_settings.h  |   1 +
>  .../selftests/mm/hugetlb_madv_vs_map.c        | 107 ++++++++++++++++--
>  3 files changed, 109 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
> index d7917dce3aba..584054736ce9 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.c
> +++ b/tools/testing/selftests/mm/hugepage_settings.c
> @@ -449,6 +449,15 @@ unsigned long hugetlb_free_pages(unsigned long size)
>  	return read_num(path);
>  }
>  
> +unsigned long hugetlb_nr_resv_pages(unsigned long size)
> +{
> +	char path[PATH_MAX];
> +
> +	hugetlb_sysfs_path(path, sizeof(path), size, "resv_hugepages");
> +
> +	return read_num(path);
> +}
> +
>  static bool __hugetlb_setup(unsigned long size, unsigned long nr)
>  {
>  	unsigned long free = hugetlb_free_pages(size);
> diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
> index 726c73c43c05..548e9d288d1d 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.h
> +++ b/tools/testing/selftests/mm/hugepage_settings.h
> @@ -98,6 +98,7 @@ unsigned long default_huge_page_size(void);
>  unsigned long hugetlb_nr_pages(unsigned long size);
>  void hugetlb_set_nr_pages(unsigned long size, unsigned long nr);
>  unsigned long hugetlb_free_pages(unsigned long size);
> +unsigned long hugetlb_nr_resv_pages(unsigned long size);
>  
>  static inline void hugetlb_save_settings(void)
>  {
> diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> index f94549efcc6f..d1f568fed4aa 100644
> --- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> +++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> @@ -15,13 +15,20 @@
>   *
>   *  Touching the first page after thread3's allocation will raise a SIGBUS

The comment above is now the description of test_madv_vs_map()

>   *
> + *  We setup a 2nd test where we create a child process, then unmap the page in
> + *  the parent while the child waits and verify that there is no underflow
> + *  of the reserved count.

And this one is a description of test_underflow()

> + *
>   *  Author: Breno Leitao <leitao@debian.org>
>   */
> +#include <limits.h>
>  #include <pthread.h>
> +#include <signal.h>
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <sys/mman.h>
>  #include <sys/types.h>
> +#include <sys/wait.h>
>  #include <unistd.h>
>  
>  #include "vm_util.h"
> @@ -74,7 +81,7 @@ void *map_extra(void *unused)
>  	return NULL;
>  }
>  
> -int main(void)
> +void test_madv_vs_map(void)
>  {
>  	pthread_t thread1, thread2, thread3;
>  	void *ret;
> @@ -85,13 +92,6 @@ int main(void)
>  	 */
>  	int max = 10;
>  
> -	ksft_print_header();
> -	ksft_set_plan(1);
> -
> -	if (!hugetlb_setup_default_exact(1))
> -		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
> -			       hugetlb_free_default_pages());
> -
>  	mmap_size = default_huge_page_size();
>  
>  	while (max--) {
> @@ -120,5 +120,96 @@ int main(void)
>  	}
>  
>  	ksft_test_result_pass("No unexpected huge page allocations\n");
> +}
> +
> +void test_underflow(void)
> +{
> +	pid_t pid;
> +	int pipe_fds[2];
> +	unsigned long nr_reserved = 0;
> +
> +	huge_ptr = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
> +			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
> +
> +	if ((unsigned long)huge_ptr == -1)
> +		ksft_exit_fail_msg("Failed to allocate huge page\n");

ksft_exit_fail_perror()
> +
> +	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
> +	if (nr_reserved != 1)
> +		ksft_exit_fail_msg("Unexpected number of reserved pages: %lu, expected 1\n",
> +				   nr_reserved);
> +
> +	/* Force the fault to ensure the reservation is consumed */
> +	*huge_ptr = 0;
> +	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
> +	if (nr_reserved != 0)
> +		ksft_exit_fail_msg("Unexpected number of reserved pages: %lu, expected 0\n",
> +				   nr_reserved);
> +
> +	if (pipe(pipe_fds) != 0)
> +		ksft_exit_fail_msg("pipe failed");

ksft_exit_fail_perror()

> +
> +	pid = fork();
> +	if (pid < 0)
> +		ksft_exit_fail_msg("fork failed");
> +
> +	if (pid == 0) {
> +		/* Child: Simply wait for the parent */
> +		char b;
> +
> +		close(pipe_fds[1]);
> +		if (read(pipe_fds[0], &b, 1) < 0)
> +			ksft_exit_fail_msg("child read failed");

ksft_exit_fail_perror()

> +		return;
> +	}
> +
> +	/* Parent */
> +	close(pipe_fds[0]);
> +
> +	/* First unmap, this will close the vma */
> +	if (munmap(huge_ptr, mmap_size) != 0) {
> +		kill(pid, SIGKILL);
> +		ksft_exit_fail_msg("munmap failed");

Won't this leave the child as a zombie?

> +	}
> +
> +	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
> +	if (nr_reserved == ULONG_MAX) {
> +		ksft_test_result_fail("After the munmap, HugePages_Rsvd underflowed!\n");
> +	} else if (nr_reserved == 0) {
> +		ksft_test_result_pass("Underflow not present!\n");
> +	} else {
> +		ksft_exit_fail_msg("Unexpected HugePages_Rsvd=%ld after munmap, should be 0 or -1.  Repeat the test\n",
> +				   nr_reserved);
> +	}
> +	/* Make the child exit, this should restore HugePages_Rsvd to 0 */
> +	if (write(pipe_fds[1], &nr_reserved, 1) < 0) {
> +		kill(pid, SIGKILL);
> +		ksft_exit_fail_msg("write failed");

Same here.

> +	}
> +	close(pipe_fds[1]);
> +	if (waitpid(pid, NULL, 0) <= 0)
> +		ksft_exit_fail_msg("write failed");
> +
> +	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
> +	if (nr_reserved == 0) {
> +		ksft_test_result_pass("After the child dies, HugePages_Rsvd is properly set to 0\n");

This makes this count the test as two, right? 
And do you need to re-check what happens after the child exits if you
already detected the underflow?

> +	} else {
> +		ksft_exit_fail_msg("Unexpected HugePages_Rsvd=%ld after the child termination munmap, should be 0 or -1.  Repeat the test\n",
> +				   nr_reserved);
> +	}
> +}
> +
> +int main(void)
> +{
> +	ksft_print_header();
> +	ksft_set_plan(3);

The comment at the header implies we've added the second test, so they plan
should be bumped to 2.

> +
> +	if (!hugetlb_setup_default_exact(1))
> +		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
> +			       hugetlb_free_default_pages());
> +
> +	test_madv_vs_map();
> +	test_underflow();
> +
>  	ksft_finished();
>  }
> -- 
> 2.39.1
> 

-- 
Sincerely yours,
Mike.

