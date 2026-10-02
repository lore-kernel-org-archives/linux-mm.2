Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8473CA5FCE
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 00:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 949676B0088; Thu,  1 Oct 2026 20:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 920CE6B008A; Thu,  1 Oct 2026 20:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8374D6B008C; Thu,  1 Oct 2026 20:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 56B046B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 20:37:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DDB95A05AE
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 00:37:24 +0000 (UTC)
X-FDA: 85275822408.14.8D06D99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 239AD1A0005
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 00:37:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GVlSQ124;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790901443;
	b=BVmV1bS8qXQfA2J6RQx0z6sFvSMxGbSPYWrTq/0+wvdqTQEx+vWllr0ph4q375vm8x6RLV
	f3CEf0lGTus+eVi534QCeIQ3XYpELdbq9CdQjIT1Rx8CyF8iDbktQRJQCJjHqVzjmRHFnR
	Bb0WiYr1EUo516ULUxyV+Gpn/7DI17Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GVlSQ124;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790901443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+zMNrQy79S8jiwTixNRGevmf9I6kVLq4clIk41vBdh8=;
	b=ClD7fmxqPmkx0zJIagdQ41guzVHLWeLymoyRuFll8RlUvjoqJm21Hk61OoRBG3lDzx+Za5
	NdfzwUkQFXFZFrjm+heJ0DsMk4ZvxD9sstACbtKoJ8r1YvuNmqTmQvWimrwolz+1ghrPpg
	heqTGRomaPXX0Pu64XSxU6GkSJgu1wM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D3C6601FA;
	Fri,  2 Oct 2026 00:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521EB1F000FF;
	Fri,  2 Oct 2026 00:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790901442;
	bh=+zMNrQy79S8jiwTixNRGevmf9I6kVLq4clIk41vBdh8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GVlSQ124B9GthRDqN7KmNNSLrui9jD7Eq/JZy6V8VPtvUcv3fyAEDGKA0nGh4OSxN
	 IJGoPfmeUQ1txCrRwh6GokYBVsi8xWsy7AM4CK4Is7fo3sKO6PNCOgshDJYhmoH9d/
	 /y626u1VPooUrPbv5V59O46wXX0NgO2ThMOmSwtQ=
Date: Thu, 1 Oct 2026 17:37:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Kevin Brodsky
 <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, Sarthak
 Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v9 0/4] kselftest: mm: fix some failure of
 split_huge_page_test
Message-Id: <20261001173720.d5a48ec93c865346f16da417@linux-foundation.org>
In-Reply-To: <20261001-fix_split-v9-0-0f4ba8bbdbdf@arm.com>
References: <20261001-fix_split-v9-0-0f4ba8bbdbdf@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: skfa796h1eez1o74f8a6qjyy4z6ju9ak
X-Rspam-User: 
X-Rspamd-Queue-Id: 239AD1A0005
X-HE-Tag: 1790901443-191160
X-HE-Meta: U2FsdGVkX1/hDyZxOWXYIFrYCudWMK5D2w2+mauikjoPMa8Kez6oumiehvfvflUdcqGONQ2osf5tGx504Rj3SCNo3hFOUfkjl+drqBMnn6vhf171MKP4nkMMGeaNBQHOnWwcoqq8iNlroUa4BNLsZg0TD+FwNdJB7mQ2KQdH30pLzi42IOi3bQ3O2oC5YGPJTuSqB2zAf+cI0DfehKoeVNdmFBSpRSHIy8hefoT1noJel12EMpK4aUECZ7OS/g2VwzgbWZj+fjllk/q/fV2hKYJrsAYo+kC8BvuFGk3CNEUq70a6882cO/1K2KzKqo6ERPG+c404BZwHBUBt+1cDEAEXmoX70YHD1CMypFH51m+R4N48/CMAShR3Bg/x8SGBS9UWRiD++Bxn+4zoeT3kom1ULBPyCaFOc3Y1HGnrh5g2d1k9qtzOHJNX5hWv8WA/SdC6shg50DNdqgh14bR2HgD+auvYcTtE0kp3LzcVALRPuvtq72CqNv4Z7VoQZGDjjbLJiBnG1yl7ToEuimfQHDpIZktMsF70dozVaT9xpKtRco4j/IH5SbzPqQuAsnQ7GDsItZKHf0K1EILuddUj51ezsDZ56V/pk8hxRPes1zPGGk2PBWYozx+Y+nCzKBsJmJ2Np2VkBYusLNRdwG83+8enEfiIsHehfNjrX94K5Npk88ccS+AW3jLK4OLs/3OqtN4LrL9GMcFxDDPZWSsN7c1D6K9jO31p2W7XoY3LdNwZHD3pIsOEZ8ibUefVQ0p+m1XQfLUzA6+agGSubrQn1z2dBZfEqpEWCGwPD2vObP7OcRaTmliJinZc8nrSN4oDuIbZMC7t8z1ufPPhgkxvzakGRnsi8P4UkbVo2o1xnsW2Z82TrIvxEIk0dOhh60HSNcX3MWn/xEbW5RQkaTJLYC60+aBdJNIWRCjz/x3Du8bNKr5ZhLMscIABD85I/kkpEA/Xfub9RNgaERRpOjF
 dipEVsUj
 suWxQvWM82Uy6RF9z4QZPgjLJeISQDF6mUqgY2NXKTEcB3PUuc4xj2HZif4o4Xeez3uH/FnXlea1DGXUwpF21GQtcJzHlS0o23E1RcNgX/J63u2f3SqqZVnttEJKhZoxwytt0aa2CHliTeJz4HCXwgDsebKc6b3C3vKPUUveQzCyPVBPdMkENAaB2bzB+9sq4Nvl2RGtUx9FajMPTvcaH9LgXhPhx7KewD1QLKGuCZBIEiXL5NhvdXaPZDvHGGU8CVAQ0Gy92xJrrwH0Otca80IaMoQGbfBemQWzsvrFjHLDy8N02Q1VP2N7KdeQbc7mlDNEVmHkuSbvLqauYUhWOqQPBCOzdlROaDgeqTJkltS01KpVTeHM+ktdhMCVZ1CyUVdfe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 01 Oct 2026 22:17:50 +0100 Yeoreum Yun <yeoreum.yun@arm.com> wrote:

> split_huge_page_test can fail for the following reasons:
> 
>   1. During the test, khugepaged may collapse previously split pages again,
>      causing intermittent failures.
> 
>   2. Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
>      glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
>      made by memalign(). The underlying VMA may start at a different address
>      from the aligned address returned by memalign(). Moreover, a subsequent
>      madvise(MADV_HUGEPAGE) call does not split the VMA because it already
>      has the same advice.
> 
>      This causes the test to fail because the check_huge_xxx() helpers
>      incorrectly require the address returned by memalign() to match the
>      VMA start address reported in /proc/self/smaps.
> 
> Address these issues by applying MADV_NOHUGEPAGE after faulting in the
> huge page, preventing khugepaged from collapsing it again, and instead of
> relying on /proc/self/smaps, use /proc/self/pagemap and
> /proc/kpageflags to detect huge-page mappings and large folios:

Thanks, I've updated mm.git's mm-unstable branch to this version.

> Changes in v9:
>   - fix some typos in comment and Fixes tag.
>   - separating huge and type checking.
>   - add r-b tags.

Here's how v9 altered mm.git:


 tools/testing/selftests/mm/split_huge_page_test.c |    7 
 tools/testing/selftests/mm/vm_util.c              |  108 ++++++------
 2 files changed, 64 insertions(+), 51 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~b
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -110,14 +110,11 @@ static char *allocate_zero_filled_hugepa
 
 static void disable_khugepaged(void *addr, size_t len)
 {
-	/*
-	 * Disables khugepaged from collapsing THPs in range, existing THP
-	 * pages remain.
-	 */
+	/* Disables khugepaged from collapsing pages in range into THPs */
 	if (!madvise(addr, len, MADV_NOHUGEPAGE))
 		return;
 
-	ksft_exit_fail_msg("MADV_NOHUGEPAGE failed, err=%d\n", errno);
+	ksft_exit_fail_perror("MADV_NOHUGEPAGE failed");
 }
 
 static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hpages, size_t len)
--- a/tools/testing/selftests/mm/vm_util.c~b
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -351,13 +351,13 @@ err_out:
 	return entry;
 }
 
-static bool check_large_folios(int pagemap_fd, int kpageflags_fd,
-		void *addr, size_t len, int nr_hpages,
+static bool check_large_folios(void *addr, size_t len, int nr_hpages,
 		uint64_t hpage_size)
 {
 	int order = 0, pagesize = getpagesize();
 	unsigned int nr_pages = hpage_size / pagesize;
 	int orders[MAX_NR_ORDERS], status;
+	int pagemap_fd, kpageflags_fd;
 	bool ret = false;
 
 	if (!nr_pages)
@@ -368,6 +368,15 @@ static bool check_large_folios(int pagem
 		ksft_exit_fail_msg("invalid order\n");
 
 	memset(orders, 0, sizeof(int) * MAX_NR_ORDERS);
+	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
+	if (pagemap_fd == -1)
+		ksft_exit_fail_msg("read pagemap fail\n");
+
+	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
+	if (kpageflags_fd == -1) {
+		close(pagemap_fd);
+		ksft_exit_fail_msg("read kpageflags fail\n");
+	}
 
 	status = gather_folio_orders(addr, len, pagemap_fd,
 			kpageflags_fd, orders, MAX_NR_ORDERS);
@@ -378,38 +387,53 @@ static bool check_large_folios(int pagem
 		ret = true;
 
 out:
+	close(pagemap_fd);
+	close(kpageflags_fd);
 	return ret;
 }
 
-enum check_huge_type {
-	CHECK_HUGE_ANON,
-	CHECK_HUGE_FILE,
+enum check_type {
+	CHECK_TYPE_ANON,
+	CHECK_TYPE_FILE,
 };
 
-static bool check_huge_type(uint64_t categories, enum check_huge_type type)
+static bool __check_type(void *addr, size_t len, uint64_t page_size,
+		enum check_type type)
 {
-	const bool file = categories & PAGE_IS_FILE;
+	bool ret = false;
+	int pagemap_fd;
+	char *start = addr;
+	char *end = start + len;
+	uint64_t categories;
+
+	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_perror("open pagemap");
 
-	switch (type) {
-	case CHECK_HUGE_ANON:
-		return !file;
-	case CHECK_HUGE_FILE:
-		return file;
+	for (; start < end; start += page_size) {
+		categories = pagemap_scan_get_categories(pagemap_fd, start);
+		if ((categories & PAGE_IS_PRESENT) != PAGE_IS_PRESENT)
+			continue;
+
+		if ((type == CHECK_TYPE_FILE) != !!(categories & PAGE_IS_FILE))
+			goto out;
 	}
 
-	return false;
+	ret = true;
+
+out:
+	close(pagemap_fd);
+	return ret;
 }
 
 static bool __check_huge(void *addr, size_t len, int nr_hpages,
-		uint64_t hpage_size, enum check_huge_type type)
+		uint64_t hpage_size)
 {
 	bool ret = false;
-	int pagemap_fd, kpageflags_fd;
+	int pagemap_fd;
 	int nr_pmd_mappings = 0;
-	uint64_t pmd_pagesize, scan_mapping_size;
+	uint64_t pmd_pagesize;
 	uint64_t categories;
-	unsigned long pfn;
-	bool check_pmd_mapping, allow_nonpresent;
 	char *start = addr;
 	char *end = start + len;
 
@@ -417,57 +441,49 @@ static bool __check_huge(void *addr, siz
 	if (!pmd_pagesize)
 		ksft_exit_fail_msg("reading PMD pagesize failed\n");
 
-	check_pmd_mapping = hpage_size == pmd_pagesize;
-	scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
-	/* Some mTHP tests check a partially populated PMD-sized range. */
-	allow_nonpresent = (uint64_t)nr_hpages * hpage_size < len;
-
 	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
 	if (pagemap_fd < 0)
-		ksft_exit_fail_msg("open pagemap fail\n");
-
-	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
-	if (kpageflags_fd < 0)
-		ksft_exit_fail_msg("open kpageflags fail\n");
+		ksft_exit_fail_perror("open pagemap");
 
-	if (!check_pmd_mapping &&
-	    !check_large_folios(pagemap_fd, kpageflags_fd,
-				addr, len, nr_hpages, hpage_size))
+	if (hpage_size != pmd_pagesize) {
+		ret = check_large_folios(addr, len, nr_hpages, hpage_size);
 		goto out;
+	}
 
-	for (; start < end; start += scan_mapping_size) {
+	for (; start < end; start += hpage_size) {
 		categories = pagemap_scan_get_categories(pagemap_fd, start);
-		pfn = pagemap_get_pfn(pagemap_fd, start);
-		if (pfn == -1UL) {
-			if (!allow_nonpresent)
-				goto out;
-			else
-				continue;
-		}
-		if (check_pmd_mapping && (categories & PAGE_IS_HUGE))
+		if (categories & PAGE_IS_HUGE)
 			nr_pmd_mappings++;
-		if (!check_huge_type(categories, type))
-			goto out;
 	}
 
-	if (check_pmd_mapping && (nr_pmd_mappings != nr_hpages))
+	if (nr_pmd_mappings != nr_hpages)
 		goto out;
+
 	ret = true;
 
 out:
 	close(pagemap_fd);
-	close(kpageflags_fd);
 	return ret;
 }
 
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_ANON);
+	const uint64_t scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
+
+	if (!__check_huge(addr, len, nr_hpages, hpage_size))
+		return false;
+
+	return __check_type(addr, len, scan_mapping_size, CHECK_TYPE_ANON);
 }
 
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_FILE);
+	const uint64_t scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
+
+	if (!__check_huge(addr, len, nr_hpages, hpage_size))
+		return false;
+
+	return __check_type(addr, len, scan_mapping_size, CHECK_TYPE_FILE);
 }
 
 int64_t allocate_transhuge(void *ptr, int pagemap_fd)
_


