Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77B90C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51F0C6B00A9; Mon, 21 Sep 2026 11:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A9186B00C3; Mon, 21 Sep 2026 11:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3991B6B00C5; Mon, 21 Sep 2026 11:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B8146B00A9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:47:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 91BD1A515A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:47:44 +0000 (UTC)
X-FDA: 85238199648.11.19E8724
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id CDFFAA000B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:47:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iNLZtwqq;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790005662;
	b=djNCFMG3zdP/ujgf+WaE/JLtIMlOSJIHFQ+YGkyLudJ614po0oHJFpxkz/MzgNVLr006YI
	+bo7tRMQN3vy2aiDuLA07xXzrC9uN4bRl5Fu2glVKbYq8Hq1KhApeLszij6uCiiDpltXkl
	tS5ApW1n0ccvn7wzMDvt587EfyKtW8g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iNLZtwqq;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790005662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xt/v9cPkBOq2fPAKYQmZiznySUYlaobjHi7Tql7AMps=;
	b=j3al9tuisLbeb7O5WZfcaQtzs9W1f8wjgDwO5F7Ox/Xvs3A9Ea2jT/zqzs7ndSOkrIbIcZ
	3YU2F9JO7g443ePTxlOx+S3ueNCUgJwirG9p1Jbfp4OYZH1F249i6yoyDoijHLaaHPKib3
	ATfvHIjAi9/ZgzcTOuI5Lo5GQhdvHo8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 111A24078A;
	Mon, 21 Sep 2026 15:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BEE1F000FF;
	Mon, 21 Sep 2026 15:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790005661;
	bh=xt/v9cPkBOq2fPAKYQmZiznySUYlaobjHi7Tql7AMps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iNLZtwqqu4XESWw915pxWASPi2s5Je91G5+Mc7sftgwG1U9PiDAboIINWM6oYe8/X
	 EB2WueoTzy0T7U53fp4NQjWShbXlhgcnuGC6ll5Pf6hKWzkHrx/4u0SpS/VzuGumgo
	 uzXqzDIgq3Ag5wUfNl06Xfi+VrNStO5ZRXGAXxgWZ9MzCtm7AiI+Oee+vVY1KI6I8k
	 +4MLvZhyzkIZbDfBc77JiTReV0zWCIA90WO+lh7VNiFzMYfs8C78/O0zHug2cyMAjw
	 xVmsPoOQ5y24TbkKj5axWSvD45emrO9XpRnd11im7Agj0Sb4AO60D/+kW824l64ZHX
	 QTCj/kPwe8z6A==
Date: Mon, 21 Sep 2026 16:47:36 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 3/3] kselftest: mm: remove check_huge_shmem()
Message-ID: <arFRjU2_g0tYVghn@gremlin>
References: <20260921-fix_split-v7-0-d25ec991159f@arm.com>
 <20260921-fix_split-v7-3-d25ec991159f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260921-fix_split-v7-3-d25ec991159f@arm.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CDFFAA000B
X-Stat-Signature: fp91b3mmcixbdz7tf8ho9ampouu6jwpm
X-Rspam-User: 
X-HE-Tag: 1790005662-513140
X-HE-Meta: U2FsdGVkX1+Q+uuMzxz7/kGJgCPmSNPmXUGrLmoo5SgiIliJq7nCsLtkMbWAeI0fBZ3K/xKm4JTEbDtW9CNWLBRdrxDxrann14Fvr/0F43oZEZE/ejtgpRbFLYoJXtXJCCdjvaBi1c8LE2dUySeznM28KpIqlYsjjkJJpPkmB961jlKknGS53sX9JqL2a/ZIgBXKM3vvDkDc3OSUCmfOaplGmehWe3aAYSpC3NFnz77d2nzHHvDwPW9N60ZPNMQBoeqS9vlYw6EqVz+GEKhdSho/5cC1KeFPzXnB3pJ9ttK4e5rcpgwp2C9eVNuHbAdyGnCpeFf6/fNz8URI+vwZcmy8ew0HEsOfX03cgHPHO+A9WRTGML6nA7E7JQSEXGWw0gAdUwwjWo1uohM2NE1Ys41PWYV9ebFMn3UFqszZnxZqiXm56uWnRajPlAjzkINdFiDT5cJSjoTx5IgrnviDngF5x3jPjJ3ZCabTb22W9uotEIxLhZzur2VO0h21cVQTKmdjFSLI40I6B7dTeYbJYinXoOKgmybklo4hOqClTSfW/TdY+Z1RxbxjkxL+02LnrwVF5gwcmXpLzTiQxsetoiefYFtIDnEJsowsX9vVS9yayODnB1y9ird4fmwEtXrXtmAaZIvGQvG0mtTUtzYV5Ea0LwJVagTzx8MZ3YcJX6nK4CXAmU5oyJqzA62D9UgzHtqWhrysj4MHpdbfFrSkfKYBSIISXMx82uYp7CD0xbTR+rt0Pu2ieSKID1zrshc7zxUlSxxv1uo/zfU4NmDPVIx48e9N7FbLIL0wE4ODafBEJvLtb2NC/ubGhSs7UaEgW3CTLURAChaTG2FanIl/0XkQnl+NgPV/QVfBnZlXoBMPpLsrYMqRy+iI/HELumIQh0WR6XI7DOMW34Ufd0hApWhByc/BWEVHfVjA46oEcI/wEwNxK+Dw4ljcuQclj8n1n/NxFWAxuFvGqkpTBgc
 Tfo/UfIU
 jzCHoEf7yJSyYpKi4K5c/VYSyg/EfPflo49xDg72YP0pJL6HGlizDznHvz+2UjSuU54w4j28Z9dHQ9ZmZhG6xlmiNO+YxcxoWKkOaLox1r9+lX8kOUUgJqFXEheu/co+UKVXW0gBA4HAsQt4eg9M8Umva2r2ySw3u71knwMx/XPTf12iOBEe5a3bbliyc78FKpYFYqoZoip8KuCHja3YN9t6knPmngXxVJwMMXkEUplAEdRVdK17BBedug9/m9XDnFQB8jTNiok//mw2E+HYhTWXbGYis20dyppodIL0vUdujc4JpUVjyfkiPjs9/n2ToGyVAll9ewWjQem/y4QvgHZe+ftFG32g3tE0wmhTOnTM2ouV4b6XsACQhNdJc+QY6b2sADE7xPKiC68p/rDzg6s2pAjJ8LU3dd+1I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 11:40:09AM +0100, Yeoreum Yun wrote:
> check_huge_shmem() was required to distinguish shmem huge pages because
> /proc/self/smaps reports them using a dedicated “ShmemPmdMapped” entry,
> as opposed to “FilePmdMapped” for file-backed huge pages.
>
> Now that /proc/self/smaps is no longer used to detect huge pages and
> /proc/kpageflags is used instead, it is sufficient to distinguish
> between file-backed and anonymous pages since the ShmemPmdMapped is also
> kind of file-backed.
>
> Therefore, remove check_huge_shmem() and use check_huge_file() instead
> and cleanup khugepaged's check_huge operation in mem_ops.
>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>

LGTM so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/folio_split_race_test.c |  2 +-
>  tools/testing/selftests/mm/khugepaged.c            | 38 ++++------------------
>  tools/testing/selftests/mm/uffd-common.c           |  4 +--
>  tools/testing/selftests/mm/vm_util.c               |  5 ---
>  tools/testing/selftests/mm/vm_util.h               |  1 -
>  5 files changed, 9 insertions(+), 41 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools/testing/selftests/mm/folio_split_race_test.c
> index 1960635a953eb..4c0d3b6a411b8 100644
> --- a/tools/testing/selftests/mm/folio_split_race_test.c
> +++ b/tools/testing/selftests/mm/folio_split_race_test.c
> @@ -182,7 +182,7 @@ static uint64_t run_iteration(void)
>  	for (i = 0; i < TOTAL_PAGES; i++)
>  		fill_page(mmap_base, i);
>
> -	if (!check_huge_shmem(mmap_base, FILE_SIZE, NR_PMD_PAGE, pmd_pagesize))
> +	if (!check_huge_file(mmap_base, FILE_SIZE, NR_PMD_PAGE, pmd_pagesize))
>  		ksft_exit_fail_msg("No shmem THP is allocated\n");
>
>  	if (pthread_barrier_init(&ctl.barrier, NULL, NUM_READER_THREADS + 1) != 0)
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index f82673f5f6b47..f448278823678 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -53,7 +53,7 @@ struct mem_ops {
>  	void *(*setup_area)(int nr_hpages);
>  	void (*cleanup_area)(void *p, unsigned long size);
>  	void (*fault)(void *p, unsigned long start, unsigned long end);
> -	bool (*check_huge)(void *addr, size_t len, int nr_hpages, unsigned long hpage_size);
> +	bool (*check_huge)(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
>  	const char *name;
>  };
>
> @@ -314,12 +314,6 @@ static void anon_fault(void *p, unsigned long start, unsigned long end)
>  	fill_memory(p, start, end);
>  }
>
> -static bool anon_check_huge(void *addr, size_t len, int nr_hpages,
> -		unsigned long hpage_size)
> -{
> -	return check_huge_anon(addr, len, nr_hpages, hpage_size);
> -}
> -
>  static void *file_setup_area_common(int nr_hpages, enum file_setup_ops setup)
>  {
>  	const int open_opt = setup == FILE_SETUP_READ_ONLY_FS ? O_RDONLY : O_RDWR;
> @@ -411,20 +405,6 @@ static void file_fault_write(void *p, unsigned long start, unsigned long end)
>  		ksft_exit_fail_perror("madvise(MADV_POPULATE_WRITE)");
>  }
>
> -static bool file_check_huge(void *addr, size_t len, int nr_hpages,
> -		unsigned long hpage_size)
> -{
> -	switch (finfo.type) {
> -	case VMA_FILE:
> -		return check_huge_file(addr, len, nr_hpages, hpage_size);
> -	case VMA_SHMEM:
> -		return check_huge_shmem(addr, len, nr_hpages, hpage_size);
> -	default:
> -		ksft_exit_fail_msg("Unknown VMA type\n");
> -		return false;
> -	}
> -}
> -
>  static void *shmem_setup_area(int nr_hpages)
>  {
>  	void *p;
> @@ -448,17 +428,11 @@ static void shmem_cleanup_area(void *p, unsigned long size)
>  	close(finfo.fd);
>  }
>
> -static bool shmem_check_huge(void *addr, size_t len, int nr_hpages,
> -		unsigned long hpage_size)
> -{
> -	return check_huge_shmem(addr, len, nr_hpages, hpage_size);
> -}
> -
>  static struct mem_ops __anon_ops = {
>  	.setup_area = &anon_setup_area,
>  	.cleanup_area = &anon_cleanup_area,
>  	.fault = &anon_fault,
> -	.check_huge = &anon_check_huge,
> +	.check_huge = &check_huge_anon,
>  	.name = "anon",
>  };
>
> @@ -466,7 +440,7 @@ static struct mem_ops __read_only_file_ops = {
>  	.setup_area = &file_setup_read_only_area,
>  	.cleanup_area = &file_cleanup_area,
>  	.fault = &file_fault_read,
> -	.check_huge = &file_check_huge,
> +	.check_huge = &check_huge_file,
>  	.name = "file",
>  };
>
> @@ -474,7 +448,7 @@ static struct mem_ops __read_write_file_read_ops = {
>  	.setup_area = &file_setup_read_write_fs_read_area,
>  	.cleanup_area = &file_cleanup_area,
>  	.fault = &file_fault_read_and_flush,
> -	.check_huge = &file_check_huge,
> +	.check_huge = &check_huge_file,
>  	.name = "file",
>  };
>
> @@ -482,7 +456,7 @@ static struct mem_ops __read_write_file_write_ops = {
>  	.setup_area = &file_setup_read_write_fs_write_area,
>  	.cleanup_area = &file_cleanup_area,
>  	.fault = &file_fault_write,
> -	.check_huge = &file_check_huge,
> +	.check_huge = &check_huge_file,
>  	.name = "file",
>  };
>
> @@ -490,7 +464,7 @@ static struct mem_ops __shmem_ops = {
>  	.setup_area = &shmem_setup_area,
>  	.cleanup_area = &shmem_cleanup_area,
>  	.fault = &anon_fault,
> -	.check_huge = &shmem_check_huge,
> +	.check_huge = &check_huge_file,
>  	.name = "shmem",
>  };
>
> diff --git a/tools/testing/selftests/mm/uffd-common.c b/tools/testing/selftests/mm/uffd-common.c
> index 1fb967ef49854..a76851aced4d0 100644
> --- a/tools/testing/selftests/mm/uffd-common.c
> +++ b/tools/testing/selftests/mm/uffd-common.c
> @@ -196,8 +196,8 @@ static void shmem_check_pmd_mapping(uffd_global_test_opts_t *gopts, void *p, int
>  {
>  	size_t len = expect_nr_hpages * read_pmd_pagesize();
>
> -	if (!check_huge_shmem(gopts->area_dst_alias, len, expect_nr_hpages,
> -			      read_pmd_pagesize()))
> +	if (!check_huge_file(gopts->area_dst_alias, len, expect_nr_hpages,
> +			     read_pmd_pagesize()))
>  		err("Did not find expected %d number of hugepages",
>  		    expect_nr_hpages);
>  }
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index a7c5caf6925e0..e31e88d5af76d 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -475,11 +475,6 @@ bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
>  	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_FILE);
>  }
>
> -bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> -{
> -	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_FILE);
> -}
> -
>  int64_t allocate_transhuge(void *ptr, int pagemap_fd)
>  {
>  	uint64_t ent[2];
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index 9a49af88702e4..fc9c93235f6fa 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -92,7 +92,6 @@ uint64_t read_pmd_pagesize(void);
>  unsigned long rss_anon(void);
>  bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
>  bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
> -bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
>  int64_t allocate_transhuge(void *ptr, int pagemap_fd);
>  int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
>  int gather_folio_orders(char *vaddr_start, size_t len,
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

