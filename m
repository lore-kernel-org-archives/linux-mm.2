Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B3E606A327
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NoYPn26D
Received: by kanga.kvack.org (Postfix)
	id 44D2B6B00EF; Tue,  3 Nov 2026 11:03:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FE4C6B05B1; Tue,  3 Nov 2026 11:03:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314AC6B05B5; Tue,  3 Nov 2026 11:03:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3C156B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:03:24 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 796DC80488
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:03:24 +0000 (UTC)
X-FDA: 85394277528.11.953F52A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id ADB7E120009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:03:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NoYPn26D;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793721802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LqiZBukabC/Spv3pdRBRSpF1gRozSstXD+PcI6qYPVQ=;
	b=KrBYInbcACTuM5CDFHcVjGQ/kkh7JPVnG5MB6A+EYlHUF80yzh9YxHXe4vtZTPxZF06kqm
	EsH+L2njv0/1NV11iA3dDQabhfM3tnxXguRjKawqL/v83HdUFPjYY5gJzzth9ej6sY60Xm
	6a0iiokVvdA1uEc77PtYoszsYDDyp08=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NoYPn26D;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793721802;
	b=cIpjjDl0okU5Jx5jBf7hJlRFOlg5JCbxbCjaDLwa4BcSlauFWM5zzw16bJzgY5UXQgT32K
	hL5Qk7EFs0DOLLkAuIipz6NRwLqXAoXGk/3qXIyhjyXjaHAHpZavSaNpuKblik/GWq7KIO
	7uS5Nconf0BsXGfwSfkX/2nsAVvzG0A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DFD2443290;
	Tue,  3 Nov 2026 16:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D741F000C1;
	Tue,  3 Nov 2026 16:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793721801;
	bh=LqiZBukabC/Spv3pdRBRSpF1gRozSstXD+PcI6qYPVQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NoYPn26DtPseW3G8SiDuJRzt84DlJ541AQ36BDmBoGn6oi52A0qsrlv/JGTmb0y3L
	 JEyR00+ZLGR96maWW/AZR/QWcqeHvu0d5qLYx9qpuwOLKUSyWq3wUkrgKAbywrpzks
	 ZWMKNCD4TYm8ljfz27X7SjtFo32/eiWB/yoXMhWQvyThRmIwT8FV4KkdEwlMUSfDdY
	 PJyRJFj8Gbh2BzDHU5Pnh8dO3gXC0wEbgAvcU1CtVXIHk2xMs7RTTLWn5J7XwyhwLo
	 H4Tt0680KkZnsWdc4/xt5pbibZY+O+61OUikn5LonqLPhALYcD2hGSc92ygO5Y0bh7
	 yrefJaaJdejnQ==
Date: Tue, 3 Nov 2026 16:03:14 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: fix format warnings on 32-bit architectures
Message-ID: <auoFpa-tuJhQMzVn@gremlin>
References: <20261103155451.534587-1-sashal@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103155451.534587-1-sashal@kernel.org>
X-Stat-Signature: 7utgt8nc8xu9hq9faiut3huskztsnhnt
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: ADB7E120009
X-HE-Tag: 1793721802-11550
X-HE-Meta: U2FsdGVkX1/ZqGJDJeZWNzxQ71aBExCovAMpfD6ldZnUg1tdJp/cDaHflKtbChgQc2X0HRbxnL6HaHyiB/gl2x2/p4sLafTDfvzW/gZA5Sqqdrq1x5onKaaUHNmXYcrGQq1J/9GkzNY/RuEkqdmSZVZPVOl1M047+hJJTDreLVIqe2HrXB6RIZCyJCcismsfXmrNWjwsGw5CUYXE/RRvJTqQ2dG8MDx70V9JkhYX2y3vMcgc1Q2rZa3mw3e1SVDOdBseg0EH/khAdtY8ZtoNT76KyxwAqSO1fSec1N1Bg38SBm0DVBFdPbzds3EMOdlZdsYTdZGU0QCPJ3Y1z9Ylyi/C0j9SB0riSkbg3COwHgoWWsdsFbwRRa+f2IaNGWIJ4qzTXOSgk7X8o81AnCe/7iKUWjY9OIt2OM9keE39AopuhtwSn1bQ3z3QpvUqHyUA1Wr9kVs4zM3iyLDMB1vjaS+RL0ukXUTWH1Kn31r+cKX6e7YhrBDYEV4YE88PfivAwJxe2IyNPrzkBKSSzjF61BQU9xFvrZON6zan79DJRbotlj+MdpTPZ2WKhY/3Fs6wAZ1K3RfF5trLqIwyp7Bqy374oXAyM9vP1Z7DEIu2VSQN2CPi5IKh15uSLYDaSxp9EkHN6bYQDkbscmWxkqVG1fLEUbhdLx+cXVkAD8Ud0p9X0VbpFpbomeheudiZatE6Im0Oc1kuTpN0pAyx5O56EApbX+XMqaq/kG47TzVd4NUHuKtV9VFtb7+BHZ50KmGR2fNmzHewE9vkGmoogv/TxNV0XBN3YhWRPVGEsvjjlHTkFbnYBJbBNrHHmZ6U69ICqU4q3RRCQp4adqKVRDPSUYK5m/9jTe2sjwsiIiGdMA9+6D/eKQ4+LcR+uFGEyA48EuNKE9JJeiWY99pN3ka/By5DIOjGh0pNBNMuZGqJcBoXYd2j52zoa0VKnLqTyav8BI4grwx3y3f0s1iL4dO
 9TtKDpnK
 L3wNbVDUNIMgPlyoJS6HGfMIA6ZuRRoFX+R3D4CadYiwbQa3n2NG1pKqQmq1QevcNcfncW5Pc+xDDsj/ucIrpaMaxulE/xt2SwgSgN3k/8I/AZsPOQG+GhLXsVwLxMsWGyAeFkmM9cq+la+9kiJ88gWDDQqXpmK57wwQZYZXDFDSCz2mp5PucULMBeTTRoZBXAn2m8ftPQBEMpFM6/dmrDuK/jMNxKt81Dmq5nSULSo3WBQj6Pq+gIdBiatTM4PegApqh6S0jCwqgc0Ems2aKGjHA+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 10:54:51AM -0500, Sasha Levin wrote:
> On 32-bit architectures size_t and uintptr_t are unsigned int and
> ssize_t is int, and with _FILE_OFFSET_BITS=64 off_t is long long, so
> printing them with %ld, %lu or %lx, or scanning /proc/self/maps into
> uintptr_t variables with %lx, warns:
>
>   hugetlb-read-hwpoison.c:32:58: warning: format '%lx' expects argument of type 'long unsigned int', but argument 3 has type 'size_t' {aka 'unsigned int'} [-Wformat=]
>
> Print size_t with %zu and %zx, casting the nonnegative ssize_t read
> totals to size_t, print off_t as unsigned long long, and scan the
> addresses into unsigned long variables.
>
> split_huge_page_test also builds its debugfs commands from uint64_t
> addresses with %lx. write_debugfs() has no format attribute, so nothing
> warned, but on 32-bit the commands get the wrong addresses. Print them
> with PRIx64, add the attribute, and cast the pointers through uintptr_t,
> as casting them straight to uint64_t warns on 32-bit too.
>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

All looks reasonable so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> Found with a 32-bit build of the selftests with a 64-bit time_t (gcc 16
> and clang 21 with -m32 -D_TIME_BITS=64 -D_FILE_OFFSET_BITS=64);
> KernelCI's 32-bit arm builds show the same warnings. The changed files
> build without format warnings there now, and the x86_64 builds don't
> change. The other selftests get the same kind of fix in separate
> patches.
>
>  .../selftests/mm/hugetlb-read-hwpoison.c      | 25 +++++++-------
>  .../selftests/mm/hugetlb-soft-offline.c       |  2 +-
>  tools/testing/selftests/mm/mseal_test.c       |  2 +-
>  .../selftests/mm/split_huge_page_test.c       | 34 +++++++++----------
>  4 files changed, 32 insertions(+), 31 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
> index 31748a24448f8..91b954a078483 100644
> --- a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
> +++ b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
> @@ -29,15 +29,15 @@ static void report_status(enum test_status status, const char *test_name,
>  {
>  	switch (status) {
>  	case TEST_PASSED:
> -		ksft_test_result_pass("%s chunk_size=0x%lx\n",
> +		ksft_test_result_pass("%s chunk_size=0x%zx\n",
>  				      test_name, chunk_size);
>  		break;
>  	case TEST_FAILED:
> -		ksft_test_result_fail("%s chunk_size=0x%lx\n",
> +		ksft_test_result_fail("%s chunk_size=0x%zx\n",
>  				      test_name, chunk_size);
>  		break;
>  	case TEST_SKIPPED:
> -		ksft_test_result_skip("%s chunk_size=0x%lx\n",
> +		ksft_test_result_skip("%s chunk_size=0x%zx\n",
>  				      test_name, chunk_size);
>  		break;
>  	}
> @@ -62,7 +62,7 @@ static bool verify_chunk(char *buf, size_t len, char val)
>
>  	for (i = 0; i < len; ++i) {
>  		if (buf[i] != val) {
> -			ksft_print_msg("check fail: buf[%lu] = %u != %u\n",
> +			ksft_print_msg("check fail: buf[%zu] = %u != %u\n",
>  				       i, buf[i], val);
>  			return false;
>  		}
> @@ -79,8 +79,9 @@ static bool seek_read_hugepage_filemap(int fd, size_t len, size_t wr_chunk_size,
>  	ssize_t total_ret_count = 0;
>  	char val = offset / wr_chunk_size + offset % wr_chunk_size;
>
> -	ksft_print_msg("init val=%u with offset=0x%lx\n", val, offset);
> -	ksft_print_msg("expect to read 0x%lx bytes of data in total\n",
> +	ksft_print_msg("init val=%u with offset=0x%llx\n", val,
> +		       (unsigned long long)offset);
> +	ksft_print_msg("expect to read 0x%zx bytes of data in total\n",
>  		       expected);
>  	if (lseek(fd, offset, SEEK_SET) < 0) {
>  		ksft_perror("seek failed");
> @@ -102,8 +103,8 @@ static bool seek_read_hugepage_filemap(int fd, size_t len, size_t wr_chunk_size,
>
>  		total_ret_count += ret_count;
>  	}
> -	ksft_print_msg("actually read 0x%lx bytes of data in total\n",
> -		       total_ret_count);
> +	ksft_print_msg("actually read 0x%zx bytes of data in total\n",
> +		       (size_t)total_ret_count);
>
>  	return total_ret_count == expected;
>  }
> @@ -116,7 +117,7 @@ static bool read_hugepage_filemap(int fd, size_t len,
>  	ssize_t total_ret_count = 0;
>  	char val = 0;
>
> -	ksft_print_msg("expect to read 0x%lx bytes of data in total\n",
> +	ksft_print_msg("expect to read 0x%zx bytes of data in total\n",
>  		       expected);
>  	while (total_ret_count < len) {
>  		ret_count = read(fd, buf, wr_chunk_size);
> @@ -133,8 +134,8 @@ static bool read_hugepage_filemap(int fd, size_t len,
>
>  		total_ret_count += ret_count;
>  	}
> -	ksft_print_msg("actually read 0x%lx bytes of data in total\n",
> -		       total_ret_count);
> +	ksft_print_msg("actually read 0x%zx bytes of data in total\n",
> +		       (size_t)total_ret_count);
>
>  	return total_ret_count == expected;
>  }
> @@ -293,7 +294,7 @@ int main(void)
>
>  	signal(SIGBUS, sigbus_handler);
>  	for (i = 0; i < ARRAY_SIZE(wr_chunk_sizes); ++i) {
> -		ksft_print_msg("Write/read chunk size=0x%lx\n",
> +		ksft_print_msg("Write/read chunk size=0x%zx\n",
>  			       wr_chunk_sizes[i]);
>
>  		fd = create_hugetlbfs_file(&file_stat);
> diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tools/testing/selftests/mm/hugetlb-soft-offline.c
> index d9565219378aa..9bdd78636dc2a 100644
> --- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
> +++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
> @@ -56,7 +56,7 @@ static int do_soft_offline(int fd, size_t len, int expect_errno)
>  	}
>
>  	memset(filemap, 0xab, len);
> -	ksft_print_msg("Allocated %#lx bytes of hugetlb pages\n", len);
> +	ksft_print_msg("Allocated %#zx bytes of hugetlb pages\n", len);
>
>  	hwp_addr = filemap + len / 2;
>  	ret = madvise(hwp_addr, pagesize, MADV_SOFT_OFFLINE);
> diff --git a/tools/testing/selftests/mm/mseal_test.c b/tools/testing/selftests/mm/mseal_test.c
> index 1a05e6921fed7..cea6c47cf5091 100644
> --- a/tools/testing/selftests/mm/mseal_test.c
> +++ b/tools/testing/selftests/mm/mseal_test.c
> @@ -24,7 +24,7 @@ static unsigned long get_vma_size(void *addr, int *prot)
>  	FILE *maps;
>  	char line[256];
>  	int size = 0;
> -	uintptr_t  addr_start, addr_end;
> +	unsigned long addr_start, addr_end;
>  	char protstr[5];
>  	*prot = 0;
>
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 36a6719ff09a8..f8744b5dbf990 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -32,9 +32,9 @@ int *expected_orders;
>  #define SMAP_PATH "/proc/self/smaps"
>  #define INPUT_MAX 80
>
> -#define PID_FMT "%d,0x%lx,0x%lx,%d"
> -#define PID_FMT_OFFSET "%d,0x%lx,0x%lx,%d,%d"
> -#define PATH_FMT "%s,0x%lx,0x%lx,%d"
> +#define PID_FMT "%d,0x%" PRIx64 ",0x%" PRIx64 ",%d"
> +#define PID_FMT_OFFSET "%d,0x%" PRIx64 ",0x%" PRIx64 ",%d,%d"
> +#define PATH_FMT "%s,0x%" PRIx64 ",0x%" PRIx64 ",%d"
>
>  const char *pagemap_proc = "/proc/self/pagemap";
>  const char *kpageflags_proc = "/proc/kpageflags";
> @@ -70,7 +70,7 @@ static int check_after_split_folio_orders(char *vaddr_start, size_t len,
>  	return status;
>  }
>
> -static void write_debugfs(const char *fmt, ...)
> +static __printf(1, 2) void write_debugfs(const char *fmt, ...)
>  {
>  	char input[INPUT_MAX];
>  	int ret;
> @@ -132,12 +132,12 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
>  	disable_khugepaged(one_page, len);
>
>  	/* split all THPs */
> -	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
> -		      (uint64_t)one_page + len, 0);
> +	write_debugfs(PID_FMT, getpid(), (uint64_t)(uintptr_t)one_page,
> +		      (uint64_t)(uintptr_t)one_page + len, 0);
>
>  	for (i = 0; i < len; i++)
>  		if (one_page[i] != (char)0)
> -			ksft_exit_fail_msg("%ld byte corrupted\n", i);
> +			ksft_exit_fail_msg("%zu byte corrupted\n", i);
>
>  	if (!check_huge_anon(one_page, nr_hpages * pmd_pagesize, 0, pmd_pagesize))
>  		ksft_exit_fail_msg("Still AnonHugePages not split\n");
> @@ -181,12 +181,12 @@ static void split_pmd_thp_to_order(int order)
>  	disable_khugepaged(one_page, len);
>
>  	/* split all THPs */
> -	write_debugfs(PID_FMT, getpid(), (uint64_t)one_page,
> -		(uint64_t)one_page + len, order);
> +	write_debugfs(PID_FMT, getpid(), (uint64_t)(uintptr_t)one_page,
> +		(uint64_t)(uintptr_t)one_page + len, order);
>
>  	for (i = 0; i < len; i++)
>  		if (one_page[i] != (char)i)
> -			ksft_exit_fail_msg("%ld byte corrupted\n", i);
> +			ksft_exit_fail_msg("%zu byte corrupted\n", i);
>
>  	memset(expected_orders, 0, sizeof(int) * (pmd_order + 1));
>  	expected_orders[order] = 4 << (pmd_order - order);
> @@ -269,8 +269,8 @@ static void split_pte_mapped_thp(void)
>  	}
>
>  	/* Split all THPs through the remapped pages. */
> -	write_debugfs(PID_FMT, getpid(), (uint64_t)page_area,
> -		      (uint64_t)page_area + page_area_size, 0);
> +	write_debugfs(PID_FMT, getpid(), (uint64_t)(uintptr_t)page_area,
> +		      (uint64_t)(uintptr_t)page_area + page_area_size, 0);
>
>  	/* Corruption during mremap or split? */
>  	for (i = 0; i < page_area_size; i++) {
> @@ -536,16 +536,16 @@ static void split_thp_in_pagecache_to_order_at(size_t fd_size,
>  	 */
>  	if (offset == -1) {
>  		for (split_addr = addr; split_addr < addr + fd_size; split_addr += pmd_pagesize)
> -			write_debugfs(PID_FMT, getpid(), (uint64_t)split_addr,
> -				      (uint64_t)split_addr + pagesize, order);
> +			write_debugfs(PID_FMT, getpid(), (uint64_t)(uintptr_t)split_addr,
> +				      (uint64_t)(uintptr_t)split_addr + pagesize, order);
>
>  		expected_orders[order] = fd_size / (pagesize << order);
>  	} else {
>  		int times = fd_size / pmd_pagesize;
>
>  		for (split_addr = addr; split_addr < addr + fd_size; split_addr += pmd_pagesize)
> -			write_debugfs(PID_FMT_OFFSET, getpid(), (uint64_t)split_addr,
> -				      (uint64_t)split_addr + pagesize, order, offset);
> +			write_debugfs(PID_FMT_OFFSET, getpid(), (uint64_t)(uintptr_t)split_addr,
> +				      (uint64_t)(uintptr_t)split_addr + pagesize, order, offset);
>
>  		for (i = order + 1; i < pmd_order; i++)
>  			expected_orders[i] = times;
> @@ -554,7 +554,7 @@ static void split_thp_in_pagecache_to_order_at(size_t fd_size,
>
>  	for (i = 0; i < fd_size; i++)
>  		if (*(addr + i) != (char)i) {
> -			ksft_print_msg("%lu byte corrupted in the file\n", i);
> +			ksft_print_msg("%zu byte corrupted in the file\n", i);
>  			err = EXIT_FAILURE;
>  			goto out;
>  		}
> --
> 2.53.0
>

--
Cheers, Lorenzo

