Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D37DC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC1C16B0088; Thu,  3 Sep 2026 05:57:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72566B008A; Thu,  3 Sep 2026 05:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B88A46B008C; Thu,  3 Sep 2026 05:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 855C46B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:57:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED06AA04CB
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:57:02 +0000 (UTC)
X-FDA: 85171997484.23.77A8207
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3B6D0C0007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:57:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LeapCbn7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788429421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lGOFCuE01N6hrukNH/ycOIy+tfIDW0sJvXY0njN6o/s=;
	b=NRIK7HFe7CCRxOIIySXNqPzXjVaY5QjJAGOniVovAJ1QpGOfxUaORWCAaxzgQwgeSk1DMd
	Xq0caAQiukdPtFGs4BKRb9/1noAhcZbsEbPIJcZF5Z54nALdU1DiB7snCADsyBQeb278eT
	7GtSgirW3gBfaMQpeU+iQJJ8ljVdtJI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LeapCbn7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788429421;
	b=OJoY/e3zM7OMa8No3LFxexiHktJpP4KjwEP05PO4yBCO5hQNw8REEpzVlA/oVE7a1nbNAJ
	E9E7fmXshsPglaHGXIutMV0ktRYHRGYn7oTcxOcO3pDHyHhAKSbWv0suZR+xwBFlZacGsn
	Ohz3x0ksBE+FvXZgDWoLtqeJ6u01zto=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2CF4B43D19;
	Thu,  3 Sep 2026 09:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5111F000E9;
	Thu,  3 Sep 2026 09:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788429420;
	bh=lGOFCuE01N6hrukNH/ycOIy+tfIDW0sJvXY0njN6o/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LeapCbn72GbW7mWZfM+jgoORd8E0ud6TOXyPAh0ycXHhadqFmMRhDO2PbryuTnl2H
	 S9bGt/NwNVYtUn1ceShRbQ1lUHQjCi2CwSVlwTvWnxKNGMpA1aBIPyf3sIxhPwpM+A
	 BGMdnDDzMasV3tmBoh7/eBJvhgf5nlszC47oF/E/EcDHZEgM41UftdhAj7N6DmoJaF
	 9mBq+pgVnSvV1Bby4EkhwZ1Sfh/H9Ek+wHM4DZZU4uPABLqVyWk4cFyaaVah6yZ8ws
	 NU4u3o+govyKcKLj1Z/wD3t1hRiPxAbD6xeiK+cgH67bI08kskXR8ib0XILyK1Eymd
	 6jFG5nd6qUktQ==
Date: Thu, 3 Sep 2026 12:56:54 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Guillaume Morin <guillaume@morinfr.org>
Cc: linux-mm@kvack.org, leitao@debian.org
Subject: Re: [PATCH v3] selftests/mm: hugetlb_madv_vs_map: add underflow test
Message-ID: <aplEZqG7SFqYw22h@kernel.org>
References: <aphPTJ4LK-Ag1C1m@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aphPTJ4LK-Ag1C1m@bender.morinfr.org>
X-Stat-Signature: bmocoobkg7513mayzjud1dtj8kfycaub
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3B6D0C0007
X-Rspam-User: 
X-HE-Tag: 1788429421-828593
X-HE-Meta: U2FsdGVkX19Hi/RcymNLJkiFRtx7LFuWhhq2yDbh6EfOC2+hWfiTP6ADMoXpw4l556Jq7xJd8361Q4KZccixQyP5YpkfDcxTpfL9hA6aeg4pikVzSOm/+a4a4Osf3anehBaCkQHxj31rQkNPBB0kdTlBjlzcPbQTpBztaIV0hbGpY6jSV1j5fTOhIMm2grIXe3D/AGFMmvsvE88iJ9sqvkvHGyWlezguOkCQ0kFIzhGWSnCuxRtsjevxhAZi2J/pdMpsPbx1lOPp7kfnscrSlQ5iZp0RHQJIqdX2WjzTGx+TmjcA+rhH6iE3nWK/rQ/Q+DrkJjyxgEd8Eutrno7+HzTF63ctYhZV99QjW3jHlo5hNOEziuQ7ppGC08stKGopFaqZIotMnGqRVRcWT6d6xUlc4rZHL2lEi2YHTZrrV5Hy7f+LIFTaCsJeE1t4Gg5Cl+jUeXz2fM4/am/ijN2pDd3cQIlKQraCUxlT63cpNcoEF0W7/fueLhYPUK+1KGZhDZAUHf8P5awYXTuK1E08wCxuzUxdI/ON9HpuFIK6IFyPpQglbNYdQkUV0UgeveTWQ2cAkplrfr07fQZO7S6zuDWhFW2yizHHBRGCItAusGaFr3teNMPSNXnUajihNPi9OxsBvKoZjUjR8Jut30823I46tsOH6+eyc/rEUqtpBqE0i4asfE7NX00u2Rn/b4XMtFru4pSOMIiteaPqtNmFky5U0dSBU1yhmnYSWKT1YEl5T64e8uZ/Bb3zF3HUFwLOLbH/DWH6G2JgoV+wna3AYK/R35kcKimneuFh3kKXEoC82hmxdRn6pkeSDou+4XhAH4xgX077BvpoOY5evoFmTaViLz7j/sih4s1iQu0/75aoDfF/u+mgfNDHotiPJ+AL0FlZq2X7kECFPscq8N8lA/hwnURS/8wo32XigQm+l2yPkM2OOlispbeEJCYVWZgHXnvHskipVbZP7aBw7A5
 41dlqATY
 NLHoKwmWiwQu+SkMP3s9326pwkmAP/GLW90htW9APPXrTYGtwfMp1cGAmoat+a/pjEkrEMJoVzd/xh0ps9kgl8G6rFcVBPrH7Vt1V59lwX+xPHtfuqKYeGh1TRkb/Z5zU7VeKuxlmbbHafGHHe4KVR4qYCZCntiAl7EeLxGOCQZluUhAXjYaDEOxoxAqme86qiZQY2XM6MjlCIqnT/YukKi+xtZEjTghTtes6Zq14Yguegl+luls1p6yROEgy0Xr4GYHf+a94T+UrP9lNij2Hc2QwKnRc+DWVngbt5J1keZmq6F2FUzsII0taEy9yhu5WNxufbNe2fMlvr9gaN3TlU8Ubd3wAcnQDvNYeh1i6JiBjlMo18RATRHm9qWKRW3Rl4cl+pQFcUdG4GGygk+1gsk2h0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 06:31:08PM +0200, Guillaume Morin wrote:
> Add a test that checks for underflows when a parent unmaps the page
> first. Also check that when the child exits the reserve count is
> correct.
> 
> Link: https://lore.kernel.org/all/alEJkwn5VlTTH_ZX@bender.morinfr.org/
> Signed-off-by: Guillaume Morin <guillaume@morinfr.org
> Cc: Breno Leitao <leitao@debian.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> ---
> v3: address Mike's comments
> v2: refactor tests into 2 functions
> 
>  .../testing/selftests/mm/hugepage_settings.c  |   9 ++
>  .../testing/selftests/mm/hugepage_settings.h  |   1 +
>  .../selftests/mm/hugetlb_madv_vs_map.c        | 149 +++++++++++++++---
>  3 files changed, 138 insertions(+), 21 deletions(-)
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
> index f94549efcc6f..c944d99d5523 100644
> --- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> +++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> @@ -3,25 +3,16 @@
>   * A test case that must run on a system with one and only one huge page available.
>   *	# echo 1 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
>   *
> - * During setup, the test allocates the only available page, and starts three threads:
> - *  - thread1:
> - *	* madvise(MADV_DONTNEED) on the allocated huge page
> - *  - thread 2:
> - *	* Write to the allocated huge page
> - *  - thread 3:
> - *	* Try to allocated an extra huge page (which must not available)
> - *
> - *  The test fails if thread3 is able to allocate a page.
> - *
> - *  Touching the first page after thread3's allocation will raise a SIGBUS
> - *
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
> @@ -74,7 +65,22 @@ void *map_extra(void *unused)
>  	return NULL;
>  }
>  
> -int main(void)
> +/* During setup in main, the only available page was allocated. This test then
> + * starts three threads:
> + *
> + * - thread1:
> + *	* madvise(MADV_DONTNEED) on the allocated huge page
> + *  - thread 2:
> + *	* Write to the allocated huge page
> + *  - thread 3:
> + *	* Try to allocated an extra huge page (which must not available)
> + *
> + *  The test fails if thread3 is able to allocate a page.
> + *
> + *  Touching the first page after thread3's allocation will raise a SIGBUS
> + */
> +

Nit: no need for an empty line here

> +void test_madv_vs_map(void)
>  {
>  	pthread_t thread1, thread2, thread3;
>  	void *ret;
> @@ -85,13 +91,6 @@ int main(void)
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
> @@ -100,7 +99,7 @@ int main(void)
>  				-1, 0);
>  
>  		if ((unsigned long)huge_ptr == -1)
> -			ksft_exit_fail_msg("Failed to allocate huge page\n");
> +			ksft_exit_fail_perror("Failed to allocate huge page\n");
>  
>  		pthread_create(&thread1, NULL, madv, NULL);
>  		pthread_create(&thread2, NULL, touch, NULL);
> @@ -120,5 +119,113 @@ int main(void)
>  	}
>  
>  	ksft_test_result_pass("No unexpected huge page allocations\n");
> +}
> +
> +/*  We create a child process, then unmap the page in the parent while the child
> + *  waits and verify that there is no underflow of the reserved count.
> + */
> +

And here

Please add a sentence about the second test this function implements.

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
> +		ksft_exit_fail_perror("Failed to allocate huge page\n");
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
> +		ksft_exit_fail_perror("pipe failed");
> +
> +	pid = fork();
> +	if (pid < 0)
> +		ksft_exit_fail_perror("fork failed");
> +
> +	if (pid == 0) {
> +		/* Child: Simply wait for the parent */
> +		char b;
> +
> +		close(pipe_fds[1]);
> +		if (read(pipe_fds[0], &b, 1) < 0)
> +			ksft_perror("child read failed");
> +		/* Let the parent do the cleanup */
> +		_exit(0);
> +	}
> +
> +	/* Parent */
> +	close(pipe_fds[0]);
> +
> +	/* First unmap, this will close the vma */
> +	if (munmap(huge_ptr, mmap_size) != 0) {
> +		ksft_perror("munmap failed");
> +		goto err_cleanup;

This will perror(), return and print that there's a mismatch between the
plan and the tests.
Maybe add a ksft_exit_fail() in the end of err_cleanup?

> +	}
> +
> +	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
> +	if (nr_reserved == ULONG_MAX) {
> +		ksft_test_result_fail("After the munmap, HugePages_Rsvd underflowed!\n");
> +		goto err_cleanup;
> +	}
> +	if (nr_reserved == 0) {
> +		ksft_test_result_pass("Underflow not present!\n");
> +	} else {
> +		ksft_test_result_fail("Unexpected HugePages_Rsvd=%ld after munmap, should be 0 or -1.  Repeat the test\n",
> +				      nr_reserved);
> +		goto err_cleanup;
> +	}
> +	/* Make the child exit, this should restore HugePages_Rsvd to 0 */
> +	if (write(pipe_fds[1], &nr_reserved, 1) < 0) {
> +		/* If write failed, the child is likely already gone */
> +		ksft_exit_fail_perror("write failed");
> +	}
> +	close(pipe_fds[1]);
> +	if (waitpid(pid, NULL, 0) <= 0) {
> +		ksft_exit_fail_msg("waitpid failed");

Unlike _perror(), ksft_exit_fail_msg does not add '\n'. The same for
occurrences below.

> +	}
> +
> +	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
> +	if (nr_reserved == 0) {
> +		ksft_test_result_pass("After the child dies, HugePages_Rsvd is properly set to 0\n");
> +	} else {
> +		ksft_exit_fail_msg("Unexpected HugePages_Rsvd=%ld after the child termination munmap, should be 0 or -1.  Repeat the test\n",

Here we expect 0 reserved pages, I think.

Not sure if "repeat the test" adds anything, I'd simply drop it.

> +				   nr_reserved);
> +	}
> +	return;

And here I'd put an empty line :)

> +err_cleanup:
> +	if (write(pipe_fds[1], &nr_reserved, 1) < 0) {
> +		ksft_exit_fail_perror("write failed");
> +	}
> +	if (waitpid(pid, NULL, 0) <= 0) {
> +		ksft_exit_fail_perror("waitpid failed");
> +	}
> +}
> +
> +int main(void)
> +{
> +	ksft_print_header();
> +	ksft_set_plan(3);
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
> -- 
> Guillaume Morin <guillaume@morinfr.org>
> 

-- 
Sincerely yours,
Mike.

