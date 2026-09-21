Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79D7CC982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:28:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BE296B00C7; Mon, 21 Sep 2026 11:28:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 548916B00DF; Mon, 21 Sep 2026 11:28:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410D96B00E1; Mon, 21 Sep 2026 11:28:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E4F06B00C7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:28:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 865EEC020A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:28:08 +0000 (UTC)
X-FDA: 85238150256.20.737AE80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id CEBC620002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:28:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M1Z45Td6;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790004486;
	b=g63dvKgWGDli41JpyJBP5J+wjZDXIj6wXljRuAe3Ai4iWpfybazucuY9iJx5chE0y/FerP
	Zn6THcxyBzdejvxPUAfkNZToL1Bp3Dj1ijoWwP6/nToF2IrIn67+sGhiMYSzKNiTV70eti
	1ABMFVDk9DF4LjN4X6fGg7aCIRaVHyk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M1Z45Td6;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790004486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K4q7WmwkmO/q0BFtHU/zrt3tXIDQ4weBhrVpkbB/RkE=;
	b=b1kOBFD5yvnVB8VVYXpNlaKKeQL6WkTY62U2QO9XuH6DyBj21IoNLaFUmWhrd8bw0vbXJr
	f+2s5ZBdKlMKc9z1e0sWIkb6tWS0s58beAlAd7Vhhw+wamcgKUzbhK0ghkFcfDaiahE8aG
	AR1KL72bb8+RJUxhrH0Zm7abvpGVyr4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F06460142;
	Mon, 21 Sep 2026 15:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFB01F000FF;
	Mon, 21 Sep 2026 15:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790004486;
	bh=K4q7WmwkmO/q0BFtHU/zrt3tXIDQ4weBhrVpkbB/RkE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=M1Z45Td6Tsh1UwdFQJQMCJDOqWa6eXAKciGI2YgR3f73yvEJiD+6J4LC4AfW8T+1b
	 BVE4Vb8wgQqa2fHEJ9DQ/x7C6EIoJT06OMAnS4SV8MMLSGFJS6kaIxrXLB4wyA5bnN
	 qlDTR3nxeErnD0JLgwR7rDjJj+7fN3XO038JQUb6SHa5daq2pKuzbeixgVGJGxHOCv
	 foWqrBVJhuG1edKQyHB3xiUqD+1il/pa2s/rAgcD8yciMhGDC+8eQe8Cj55O7r82bK
	 jpLAp3KlXx5/tptjqDeGXD39QLrL8YCrL66kM4jjPb7zpdeuqwk7L0aaN3EVMHCDBc
	 JA0klpWeovUTg==
Message-ID: <36465f31-59e2-43a5-8cd8-f8bb1844da3c@kernel.org>
Date: Mon, 21 Sep 2026 17:27:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/3] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
To: Yeoreum Yun <yeoreum.yun@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260921-fix_split-v7-0-d25ec991159f@arm.com>
 <20260921-fix_split-v7-2-d25ec991159f@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260921-fix_split-v7-2-d25ec991159f@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CEBC620002
X-Rspam-User: 
X-Stat-Signature: h1yxiwwojz84csab7k9fx1j374ha1f97
X-HE-Tag: 1790004486-884566
X-HE-Meta: U2FsdGVkX18zneKIJSFW0R3dpKUxWwBHzHJpQ4J1LX/iTahkzJ97foOcKZsP84e3fKoVujjc139vLMmQDWrBciTSyLSQMNo58QV6OfzaQuBToikiFfoBqia+1LNDkORO9evCqyaW9JUoUHeIYzc87pRQssukIyB+G8a4xcbErBuX3689ObRwXMCs9zlvKYEZQ7OkqjXxZbIIvQzyaW9MID1lNNn1ADMNxI/P3CCzC8l6UlpgQsHezkMqoUouVA8kgR+36Q8vay87YUQ4AvNBNO8a74tbqyzMTphuLcDx1rmKHFwXKwf2BAXUoVVGU5QLM9Md1a72iPnCUTxak9fa3e7bpSCXxEprSsY6C4X389Kc/H36y7K9QMC+tFikZC7wvBVt3QYeNgZlDaPRct5wHZ4WipIHHoq/2H/Jar7q2a906EJ8mLx+9zXvpxQ51KDipnGgHxsZQsJqlbV8A8GJ45IuBBiP2/PrhVf9c8iYYvU/JTVld45SzFTW6PwJk1fXeWqb2CUc6SYWDk+VEZVasRu8mTF0cYCPDGzQmK1iHT4b1GdPHIC8iC+tQU0JOcPCueKPB7H4vbyhkGCHPQkwaLqgoxxIVM8ncPkHN3Rd0zLLTN7VY7xU8z3rAcA+oParMuj1lSCniDAfJbjZe1gS/0zbRPfcze1+wspHjlmpB8TcHkUp6tlgs3z3t7jiVZSjre3SO8+7ZNOEJA5c2XkBbAAX6vTUGdV8+KCLbKAk9u+/LLU+vEKheQsecIpOqSHeTgYz+NI2maYZx76lgLC4rpN9zMuAFFoPELrvBWdO8lgVizok+IjLA/ySbkklgpKkSLFpArvXa1rscPR5JUaPYaP1TaZ+yNdnrRjRJmjT8gj5gqj/E/PVfh85CM2oFqH8Hw/pljnv5ihCa3aj4DIT6LXHBlQRT0tU07Fr/cpJuyvFTP/BgeD6UD9XyxRfHTA5OogPTwUBLPn9K9Q5HcM
 pqV8IQwY
 47F04TAU0N84sa+b2n0OQCC1asQwXZGeU3QqT/WccvQ6Dr+Eqc0kn7ay5Oy55FRLtp2pVjIXuyhT0qtX9m2XWLRDvnC/HnK+0rG+02aW7I4V2MX5DCmuM46rYbK2hhOM7azARzVGZusXsSqaBqYrf2qakwXr4YMi58ekd6LWR5Yr/DKlNG8JxGHL7NhvM/WqNj+FcaDgKjwiFsUMAbA8zss1OXlx03/QRdOFa4el2Yp7ZrYqcq1I4Xmw406uLs+KvSQbPHATAscxkISCZYelFg4Emcd6i3YrEQ89G8oevYVfsEphCXN+WE6XwU17fM7Zw8E/SBmlH6fp+dhL4WMkGWzfTH5chEXaghDjKKXcow+Bqpr1GOcCDkeA6MaxltWxC1cijSaWonqPxtKtMM4aFgBsFZbvkAZ8KqMhFLW23Zky0h5sPBVQ2HxdgFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 12:40, Yeoreum Yun wrote:
> Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> made by memalign().
> 
> The underlying VMA may start at a different address from the aligned
> address returned by memalign(). Furthermore, a subsequent
> madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> already set.
> 
> This causes split_huge_page_test to fail because the check_huge_xxx()
> helpers incorrectly require the address returned by memalign() to
> match the VMA start address reported in /proc/self/smaps.
> 
> Instead of relying on /proc/self/smaps, use /proc/self/pagemap and
> /proc/kpageflags to detect huge-page mappings and large folios:
> 
>   1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of
>      using check_large_folios(), since only the mapping type matters.
>      This identifies PMD-mapped huge pages.
>   2. Otherwise, use check_large_folios() to detect large folios. This
>      covers mTHP cases.
>   3. Check the folio flags according to the type of huge page.
> 
> Since shmem pages are also file-backed, simply check whether the page
> is file-backed.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Suggested-by: Zi Yan <ziy@nvidia.com>

Do we need a Fixes: tag?

> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/vm_util.c | 137 +++++++++++++++++++++--------------
>  1 file changed, 84 insertions(+), 53 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 4821a35630363..a7c5caf6925e0 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -351,31 +351,13 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
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
> -static bool check_large_folios(void *addr, size_t len, int nr_hpages,
> -		uint64_t hpage_size)
> +static bool check_large_folios(int pagemap_fd, int kpageflags_fd,
> +			       void *addr, size_t len, int nr_hpages,
> +			       uint64_t hpage_size)

The function used two tab indent for a reason ;)

Use two tabs also in the functions you change below.

[...]

>  
> -bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> +static bool __check_huge(void *addr, size_t len, int nr_hpages,
> +			 uint64_t hpage_size, enum check_huge_type type)


>  {
> -	uint64_t pmd_pagesize = read_pmd_pagesize();
> +	bool ret = false;
> +	int pagemap_fd, kpageflags_fd;
> +	int nr_pmd_mappings = 0;
> +	uint64_t pmd_pagesize, scan_mapping_size;
> +	uint64_t categories, kpf;
> +	unsigned long pfn;
> +	bool check_pmd_mapping, allow_nonpresent;
> +	char *start = addr;
> +	char *end = start + len;
>  
> +	pmd_pagesize = read_pmd_pagesize();
>  	if (!pmd_pagesize)
>  		ksft_exit_fail_msg("reading PMD pagesize failed\n");
>  
> -	if (hpage_size == pmd_pagesize)
> -		return __check_pmd_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
> +	check_pmd_mapping = (hpage_size == pmd_pagesize);

No need for ()

> +	scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
> +	/* Some mTHP tests check a partially populated PMD-sized range. */
> +	allow_nonpresent = (uint64_t)nr_hpages * hpage_size < len;
>  
> -	return check_large_folios(addr, len, nr_hpages, hpage_size);
> +	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
> +	if (pagemap_fd < 0)
> +		ksft_exit_fail_msg("open pagemap fail\n");
> +
> +	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
> +	if (kpageflags_fd < 0)
> +		ksft_exit_fail_msg("open kpageflags fail\n");
> +
> +	if (!check_pmd_mapping &&
> +	    !check_large_folios(pagemap_fd, kpageflags_fd,
> +				addr, len, nr_hpages, hpage_size))
> +		goto out;
> +
> +	for (; start < end; start += scan_mapping_size) {
> +		categories = pagemap_scan_get_categories(pagemap_fd, start);
> +		pfn = pagemap_get_pfn(pagemap_fd, start);
> +		if (pfn == -1UL) {
> +			if (!allow_nonpresent)
> +				goto out;
> +			else
> +				continue;
> +		}
> +		if (pageflags_get(pfn, kpageflags_fd, &kpf))
> +			ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
> +		if (check_pmd_mapping && (categories & PAGE_IS_HUGE))
> +			nr_pmd_mappings++;
> +		if (kpf & KPF_COMPOUND_TAIL)
> +			continue;
> +		if (!check_huge_type(categories, kpf, type))
> +			goto out;
> +	}
> +
> +	if (check_pmd_mapping && (nr_pmd_mappings != nr_hpages))
> +		goto out;


There is way too much happening here, which makes this rather hard to review.

Why can't we just focus on the smaps change for now?

I.e., something like the following (untested)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 4821a35630363..5d348d6985026 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -351,24 +351,6 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
 	return entry;
 }
 
-static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
-		  uint64_t hpage_size)
-{
-	char buffer[MAX_LINE_LENGTH];
-	uint64_t thp = -1;
-	char *entry;
-
-	entry = __get_smap_entry(addr, pattern, buffer, sizeof(buffer));
-	if (!entry)
-		goto err_out;
-
-	if (sscanf(entry, "%9" SCNu64 " kB", &thp) != 1)
-		ksft_exit_fail_msg("Reading smap error\n");
-
-err_out:
-	return thp == (nr_hpages * (hpage_size >> 10));
-}
-
 static bool check_large_folios(void *addr, size_t len, int nr_hpages,
 		uint64_t hpage_size)
 {
@@ -410,20 +392,34 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
 	return ret;
 }
 
-bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+static bool __check_pmds(void *start, size_t len, int expected_file_pmds,
+		int expected_anon_pmds, uint64_t pmd_pagesize)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
+	int found_anon_pmds = 0, found_file_pmds = 0;
+	int pagemap_fd;
+	void *addr;
 
-	if (!pmd_pagesize)
-		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_msg("open pagemap fail\n");
 
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
+	for (addr = start; addr < start + len; addr += pmd_pagesize) {
+		const uint64_t categories = pagemap_scan_get_categories(pagemap_fd, addr);
 
-	return check_large_folios(addr, len, nr_hpages, hpage_size);
+		if (!(categories & PAGE_IS_HUGE))
+			continue;
+		if (categories & PAGE_IS_FILE)
+			found_file_pmds++;
+		else
+			found_anon_pmds++;
+	}
+
+	close(pagemap_fd);
+	return found_anon_pmds == expected_anon_pmds &&
+	       found_file_pmds == expected_file_pmds;
 }
 
-bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
 	uint64_t pmd_pagesize = read_pmd_pagesize();
 
@@ -431,12 +427,12 @@ bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 		ksft_exit_fail_msg("reading PMD pagesize failed\n");
 
 	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
+		return __check_pmds(addr, len, 0, nr_hpages, pmd_pagesize);
 
 	return check_large_folios(addr, len, nr_hpages, hpage_size);
 }
 
-bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
 	uint64_t pmd_pagesize = read_pmd_pagesize();
 
@@ -444,11 +440,16 @@ bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size
 		ksft_exit_fail_msg("reading PMD pagesize failed\n");
 
 	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
+		return __check_pmds(addr, len, nr_hpages, 0, pmd_pagesize);
 
 	return check_large_folios(addr, len, nr_hpages, hpage_size);
 }
 
+bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
+{
+	return check_huge_file(addr, len, nr_hpages, hpage_size);
+}
+
 int64_t allocate_transhuge(void *ptr, int pagemap_fd)
 {
 	uint64_t ent[2];
-- 
2.43.0
-- 
Cheers,

David

