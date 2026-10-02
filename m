Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77AB5CA5FD9
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 08:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80D2F6B008C; Fri,  2 Oct 2026 04:44:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E59C6B0092; Fri,  2 Oct 2026 04:44:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D68A6B0093; Fri,  2 Oct 2026 04:44:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4862F6B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 04:44:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B97541C3765
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:44:04 +0000 (UTC)
X-FDA: 85277048808.14.CC94669
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 24CC540005
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:44:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vwe8P+39;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790930643;
	b=1epvcl+pQGqtMeqy5FJCfnFe8Wn7S95uigAKr2PCrZ9GSAeB/Mz+/S6C+Y7J5hnmZEkcys
	29szPKGXfi/fSJkHnIANTKDcTo7HDU2TiK3mOv1k/AIsHkt8KvqH8vWwM1m5I0XEWYQW9D
	DN3T1iUj0cs5jPeket250h10vG8lyis=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vwe8P+39;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790930643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QaW3NvlDbie2nX8q04QLao6HBP5b6PgxRU/jNxrvHlo=;
	b=eSEEn9sbS8G5KOeWHdH1umvIqSS+osEWe4HhgDXIJgCctoIxmya5DGeCyHwqwdoC2n/5Wz
	zNGhd9CvJ4ZPQGGdzkksWLqh435AAqQnd+O+LwR+M6x0uW4FcBECBUkVNnnPMxBRovAWYi
	N1+fGWOpl/IMeKL1QSOhuK7f93tL6Ps=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A699F60A6A;
	Fri,  2 Oct 2026 08:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858461F000FF;
	Fri,  2 Oct 2026 08:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790930642;
	bh=QaW3NvlDbie2nX8q04QLao6HBP5b6PgxRU/jNxrvHlo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vwe8P+39JCuHBizogmo2GNh1ALOKZtDQnio60+ojHg0sgpeiqScLp79z3mbw02V8F
	 EYxN83kKfoU1dBWiYlTSNvqPO1sv2qLGQOHtGQ88RqyFySjslidqooaKnggLK/gJKG
	 IWC5bqdlh9R7rDJ83vR8KTnnawGa9boU4Lb7HKydbTNBsoXeXWf2WMnkMILp6bICUN
	 iHO/PMicuO4lycVHpnBubmnWdEzmOyVRE765syr056W+9jA4+6LnbRxAw4zEa6ohWa
	 6CAE+VUsdlJvbi6bS41ZcL7w0M7FG61svR56MHeK92o8dhMmvZCsTExm2N2AYdnoxH
	 W1EwRBuRDq0NQ==
Date: Fri, 2 Oct 2026 09:43:55 +0100
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
	linux-kernel@vger.kernel.org, Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v9 2/4] kselftest: mm: replace usage of /proc/self/smaps
 for __check_pmd_huge()
Message-ID: <ar9utGn5OEWjZUd9@gremlin>
References: <20261001-fix_split-v9-0-0f4ba8bbdbdf@arm.com>
 <20261001-fix_split-v9-2-0f4ba8bbdbdf@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261001-fix_split-v9-2-0f4ba8bbdbdf@arm.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: qaajsydgcth4cfuqsxsso6a18mm3yjbt
X-Rspam-User: 
X-Rspamd-Queue-Id: 24CC540005
X-HE-Tag: 1790930643-263123
X-HE-Meta: U2FsdGVkX19y2AslTXPRTa/o6D49vy8kiROrB4NjlTvuGTcv0ixtE5EKW0fW7Zd7hAQiOItFDTEmL/NIN+8aV+24Jylusq/VpEuPuWjgFzKDBuDSXvFn6DqN52ChhbK7GC9tqshXrptH0ybFZICTWdJepUuFfpiem1ITT1Jd2KI3GJzmTfylDxRMEn69DOuLHy+PU8kGwfrme3GQI/XvG5sWH8NZ1O2NanJvWDu0fieZvhWw9LLOqrjEVsYK6FzUBn8FYduYY4DYgkW0TfE1OFREiEGcC4+dRnO5dWAWxG+h7V8Zm/r1aylcCjhlozzMnqe1AbT1rgBhpd1h/3ISrG5HPh43kJynrAhTzXG+pqXyyXop0Bu/cel6iQHFgBBp8dZv44IkyHqiUhPRDYhnalaLtkqkHsg5pGXUELzFC6T59QFC9N8K5UkACckoNJ4LOmZxAj0AF/eeYUpo7DTm28NPTo0aqzBVEka2cEv0YF59e2+lczrbQ4fW7CH9iPQtx9h/LnIjNRCKs9fvrwW0JLsxoI9qaTP8RZPSUQxtAWIKFnCU6KkvaIjs5Y2UXpLzILuemtYMrcM7k5Zn+hlzE3jicgJDlbqFA3spFt7t5iwTJ9pURz/i/X5hJttNxv7AKS9sZh203TADmRe0NO9BZGl2pxpoTl5bGeosQ98QUUqBMYjhld5J9F1/uZCm8hBp5cfYyM7ZJC3aScaAWER146/SEMLStUKuYSleZYihl5d9pb3HsN3JU0vUauLcHOVvxaXx8Mr2SI2/GXAyzdeEPogcGX4/v86C1VTE20gv+dvMzPWOM0f0yJbG+cW3DZWBEb+Jm4PcUudChKAa1HTmqudl9I8wnDWVxobo1IN84lKOk8Ydtmss+K0AmJKNIIymTZ23bMMKQrwCY9MGeEz9mhB6bp+91gjPn+NQEhSJT/hRvhn3b+BUDPsVpyo4C1afcxTZRHz9W9/L8mzrIqc
 TgehYJtq
 EpyfF16a7YEU0x+Btu3TepsREhzdqzbMmrYyDp+y0upVLnUaxvk3BvLR0diy8sC/nMo42BxRbcFrlMh9maDx9EFQ/vof5I/DEeeMBxSh2Ad+eqzkD8zJHW6hZxV/sTTu8fGzTSAIMW4Zcbv5v6WyJe32dFm8M+T+M8pFDaE1LlbHXez8lMa7nZLqGSzzZlO6ssU/7NSJtjqwKklmcqO0sRIdZ9hWBoJnSg9R+iFRGSzXCe6iGW4pCclD85rc7Fpgh/2/2f3lzJZaoXymSvXobD15ccgxU2nmaF1Oc5Rb3hRSaGqDqU6FS7a41fyV4xng2QYrb2Rw29Vyeyn27k2gQdJQjlL/i64AFUZ++h7MUhMd3LxKFQ5jUspqXGede46jHbBe5GrzXvSenhQH6gn7vGNatGe8PMZWrAcjujj6RfT8+0CwFV4IroDKRhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 10:17:52PM +0100, Yeoreum Yun wrote:
> Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> made by memalign().
>
> The underlying VMA may start at a different address from the aligned
> address returned by memalign(). Furthermore, a subsequent
> madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> already set.
>
> This causes split_huge_page_test to fail because the check_pmd_huge()
> helpers incorrectly require the address returned by memalign() to
> match the VMA start address reported in /proc/self/smaps.
>
> Instead of relying on /proc/self/smaps, use /proc/self/pagemap and
> /proc/kpageflags to detect huge-page mappings checking PAGE_IS_HUGE
> and PAGE_IS_FILE according to type of huge page.
>
> Since shmem pages are also file-backed, simply check whether the page
> is file-backed.
>
> Fixes: 642bc52aed9c ("selftests: vm: bring common functions to a new file")
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>

LGTM so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Thanks for doing this! :)

> ---
>  tools/testing/selftests/mm/vm_util.c | 78 ++++++++++++++++++++++--------------
>  1 file changed, 49 insertions(+), 29 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index a0ab78ceedb1..a3c3a2706c22 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -351,24 +351,6 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
>  	return entry;
>  }
>
> -static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
> -		  uint64_t hpage_size)
> -{
> -	char buffer[MAX_LINE_LENGTH];
> -	uint64_t thp = -1;
> -	char *entry;
> -
> -	entry = __get_smap_entry(addr, pattern, buffer, sizeof(buffer));
> -	if (!entry)
> -		goto err_out;
> -
> -	if (sscanf(entry, "%9" SCNu64 " kB", &thp) != 1)
> -		ksft_exit_fail_msg("Reading smap error\n");
> -
> -err_out:
> -	return thp == (nr_hpages * (hpage_size >> 10));
> -}
> -
>  static bool check_large_folios(void *addr, size_t len, int nr_hpages,
>  		uint64_t hpage_size)
>  {
> @@ -410,20 +392,51 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
>  	return ret;
>  }
>
> -bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> +enum check_huge_type {
> +	CHECK_HUGE_ANON,
> +	CHECK_HUGE_FILE,
> +};
> +
> +static bool check_huge_type(uint64_t categories, enum check_huge_type type)
>  {
> -	uint64_t pmd_pagesize = read_pmd_pagesize();
> +	const bool file = categories & PAGE_IS_FILE;
>
> -	if (!pmd_pagesize)
> -		ksft_exit_fail_msg("reading PMD pagesize failed\n");
> +	switch (type) {
> +	case CHECK_HUGE_ANON:
> +		return !file;
> +	case CHECK_HUGE_FILE:
> +		return file;
> +	}
>
> -	if (hpage_size == pmd_pagesize)
> -		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
> +	return false;
> +}
>
> -	return check_large_folios(addr, len, nr_hpages, hpage_size);
> +static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
> +		  uint64_t hpage_size, enum check_huge_type type)
> +{
> +	int pagemap_fd;
> +	int nr_pmd_mappings = 0;
> +	uint64_t categories;
> +	char *start = addr;
> +	char *end = start + len;
> +
> +	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
> +	if (pagemap_fd < 0)
> +		ksft_exit_fail_perror("open pagemap");
> +
> +	for (; start < end; start += hpage_size) {
> +		categories = pagemap_scan_get_categories(pagemap_fd, start);
> +		if (!(categories & PAGE_IS_HUGE))
> +			continue;
> +		if (check_huge_type(categories, type))
> +			nr_pmd_mappings++;
> +	}
> +	close(pagemap_fd);
> +
> +	return nr_hpages == nr_pmd_mappings;
>  }
>
> -bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> +bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
>  {
>  	uint64_t pmd_pagesize = read_pmd_pagesize();
>
> @@ -431,12 +444,13 @@ bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
>  		ksft_exit_fail_msg("reading PMD pagesize failed\n");
>
>  	if (hpage_size == pmd_pagesize)
> -		return __check_pmd_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
> +		return __check_pmd_huge(addr, len, nr_hpages, hpage_size,
> +					CHECK_HUGE_ANON);
>
>  	return check_large_folios(addr, len, nr_hpages, hpage_size);
>  }
>
> -bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> +bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
>  {
>  	uint64_t pmd_pagesize = read_pmd_pagesize();
>
> @@ -444,11 +458,17 @@ bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size
>  		ksft_exit_fail_msg("reading PMD pagesize failed\n");
>
>  	if (hpage_size == pmd_pagesize)
> -		return __check_pmd_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
> +		return __check_pmd_huge(addr, len, nr_hpages, hpage_size,
> +					CHECK_HUGE_FILE);
>
>  	return check_large_folios(addr, len, nr_hpages, hpage_size);
>  }
>
> +bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> +{
> +	return check_huge_file(addr, len, nr_hpages, hpage_size);
> +}
> +
>  int64_t allocate_transhuge(void *ptr, int pagemap_fd)
>  {
>  	uint64_t ent[2];
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

