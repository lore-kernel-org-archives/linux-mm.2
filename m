Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE686C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 10:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4B2B6B0099; Thu, 27 Aug 2026 06:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D44D6B009B; Thu, 27 Aug 2026 06:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A0256B009D; Thu, 27 Aug 2026 06:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51E616B0099
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:44:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3ED78403A9
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:44:27 +0000 (UTC)
X-FDA: 85146715374.10.DA79832
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 120B540005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:44:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qcAJA9oz;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787827465;
	b=myewrdcIYylzFKvfbDavtOV+rHBPsADaEJ8A4VBygE5RlBaIEXxvUjmJrJKRTBlIpWNs4+
	DtiJ04U6kvS3iv2VLPR1OXl3vdsg/TytWyx+6mkU3cQyse6k3YcGw5QPjK1NvYgHrH3UFV
	l93ZsgC0jrVqNh1v+XZAelorL5B7iGU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787827465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iVLMebYBYb8VEzI2EU9mkFoD8SzUn6lD0/yadmkbsdI=;
	b=1Hy0MFg0ZihLR84FXykU/eZeHaXrYwv8+UgfV9RkRrjk9DaKfdIQQ7Z/Lf2KmLzOmsnsX+
	R04Bh5JKkhcboBPIgYGaA4lJBwc3kJsmiqh5mfCiBCfcVBYJo/R18kfjQ7q9moyzIEi67p
	/oEU6Ym5yxPEXFloPxuC7+48yB4Cl/0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qcAJA9oz;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 155FD1688;
	Thu, 27 Aug 2026 03:44:20 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C621B3F85F;
	Thu, 27 Aug 2026 03:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787827463; bh=CdLu2KUFUsEkRIIPJNlBxOqx2DafOnqj7hAjt/hce0g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qcAJA9ozo2cE518o8/55ljeNZVRnj89P77su+lYVZo7nwGiX/uIc4M+9ctfSvHg2Z
	 qiC/yKQhBEl6314tempnyM+pcjzQjBtyEZ0ZoBvJ4UCq4DC1+XScwCp/DAd8rRiBDu
	 TFUjilcY1kJzP7K1v0kCgMHuz5KeXiuIT4eQT/a8=
Date: Thu, 27 Aug 2026 11:44:18 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
Message-ID: <apAVAvfxZSeEvf50@e129823.arm.com>
References: <20260826-fix_split-v2-0-71153c7f579a@arm.com>
 <20260826-fix_split-v2-2-71153c7f579a@arm.com>
 <0107447a-7c1f-44f8-94fb-109b0f850677@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0107447a-7c1f-44f8-94fb-109b0f850677@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 120B540005
X-Stat-Signature: ngbpa9rzadoanm9k7rmwcpp9oawcoxrm
X-HE-Tag: 1787827464-878228
X-HE-Meta: U2FsdGVkX19HPV2oYPpWgqaTsWZoIyZz72xm2Bc3s1AWKBcw9AHZhA10E96yi/YHUp6VlF6nzb70pph/6UFyS47jhlFTdhzKNMdY/Kj2psEDfHuNxh1J/RTy0eDA22U+qEzqzf2d4mUeYnBWeUcjOmVwRi2a4iY1cdIYKH7Gvi7IT/3T7tHQ2u7sKoyv7aS4fiztGFQSMry+j28NNfTPJzxAGz3+ljR0M+e6zVl6i0YFY6luCcHxR+Y3qnV76r+3Kk3RGW5VgQDp2K/24rFNPY9d0mKTdqZLLkXtXumMWq7UDZSvbKzJE0mtYlGqCx2gVy2J985yjXlaGOucRHfkUcdhl31M85BajNU14ijNRpc0DbchJt0V5lWk3DmzDCIFAtLBeKRwxzpQ5BtnVLPk21x6o/SYac5s9v1Z/auE2Qeh2Jo9cRPbt/ji/zVvuT4Y3dzOTkTv7gaYF+woddOJ9+3euBWmgy59utLP/LNv+IcJlgkkt20abSkekYZR4Pu7cFb39O0qTTb3f+IZdSzs58RGaX6YIVaci9SLQrCeZPHhSP3ikWbkXYfQmJP4h9WBIHH3JAKr+uVusQeZ4IwRMd2JPLnopYJ8epJuGeDKxc1YB+gh6Q6iOqs8hQ7ullKAwDQ1fy5jy7bGxH5LctQ6joiGnH7O7ua5nYXioXQIlwf5vkBNLs89rSas9odhLJul5Adi2xMYB3GAjn9wzcEhtskcm7U7q8GGXI5UfWRkBpcsZxX7aum4urBa1tXACEjvct4x9gfSGw8c5GSJ4ViIh7nO4RNkL3A5NLGGATW9vzD/sXc0bgnQ4Jsyeua8MgDnMrRyCxbNnzeUkYD5mHOx6aSJbVlj50JvvOzu4i893dMjhpqd4mLQYUcgqF7u38GrXquhPVzEuYy+0xNPCQtpdslnQ9G2i/HDq6V0smTvsXWWyePyTNjILmJ3cH7i/xX6NAFp9vkQT1KRBrv9zvd
 sIxiaYcR
 GrunHIbV+Tzs9kf1QSulgyZtY/f1djuHP+XOf/VrPkHDGoG9Rx8LxdV2vjr99WXxABZ/ifJ0F47J4ch30iKyWsi5MVPVvEbTsOQyFpiRd3xlA24UWXUzWFkjyTP+qLoRVRAafvXq/Ic+5pHd+UpEGla8txpfrYh1dV2hhLm2NW3DmBJgR/SzhwF0hh9t6Wq4s9aTlfvkbEG+hWIJdMPe6y2BPB9u4jYgy84hfrCS5AnLUlbz4knEvPdKJXJeMfgRw+P2Ti/VqrCG9rHWacOfHlIqolAmRoFEloezwQcm9Ugj8VFSP8SZ1gblnALZqBS/uduY7Ud0Fm8K+h0P0qdBWw+enaJ70KxjvYYHH2KEgma8tshlhRK2nzfDzHJfzJCZC44eS6MQikba664I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baolin,

> 
> 
> On 8/26/26 8:24 PM, Yeoreum Yun wrote:
> > Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> > glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> > made by memalign().
> > 
> > The underlying VMA may start at a different address from the aligned
> > address returned by memalign(). Furthermore, a subsequent
> > madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> > already set.
> > 
> > This causes split_huge_page_test to fail because the check_huge_xxx()
> > helpers incorrectly require the address returned by memalign() to
> > match the VMA start address reported in /proc/self/smaps.
> > 
> > Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
> > /proc/self/smaps to detect huge pages.
> > 
> > Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >   tools/testing/selftests/mm/vm_util.c | 130 ++++++++++++++++++++---------------
> >   tools/testing/selftests/mm/vm_util.h |   1 +
> >   2 files changed, 77 insertions(+), 54 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> > index 4821a3563036..1d0959b3b9e8 100644
> > --- a/tools/testing/selftests/mm/vm_util.c
> > +++ b/tools/testing/selftests/mm/vm_util.c
> > @@ -351,31 +351,13 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
> >   	return entry;
> >   }
> > -static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
> > -		  uint64_t hpage_size)
> > -{
> > -	char buffer[MAX_LINE_LENGTH];
> > -	uint64_t thp = -1;
> > -	char *entry;
> > -
> > -	entry = __get_smap_entry(addr, pattern, buffer, sizeof(buffer));
> > -	if (!entry)
> > -		goto err_out;
> > -
> > -	if (sscanf(entry, "%9" SCNu64 " kB", &thp) != 1)
> > -		ksft_exit_fail_msg("Reading smap error\n");
> > -
> > -err_out:
> > -	return thp == (nr_hpages * (hpage_size >> 10));
> > -}
> > -
> > -static bool check_large_folios(void *addr, size_t len, int nr_hpages,
> > -		uint64_t hpage_size)
> > +static bool check_large_folios(int pagemap_fd, int kpageflags_fd,
> > +			       void *addr, size_t len, int nr_hpages,
> > +			       uint64_t hpage_size)
> >   {
> >   	int order = 0, pagesize = getpagesize();
> >   	unsigned int nr_pages = hpage_size / pagesize;
> >   	int orders[MAX_NR_ORDERS], status;
> > -	int pagemap_fd, kpageflags_fd;
> >   	bool ret = false;
> >   	if (!nr_pages)
> > @@ -386,15 +368,6 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
> >   		ksft_exit_fail_msg("invalid order\n");
> >   	memset(orders, 0, sizeof(int) * MAX_NR_ORDERS);
> > -	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
> > -	if (pagemap_fd == -1)
> > -		ksft_exit_fail_msg("read pagemap fail\n");
> > -
> > -	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
> > -	if (kpageflags_fd == -1) {
> > -		close(pagemap_fd);
> > -		ksft_exit_fail_msg("read kpageflags fail\n");
> > -	}
> >   	status = gather_folio_orders(addr, len, pagemap_fd,
> >   			kpageflags_fd, orders, MAX_NR_ORDERS);
> > @@ -405,48 +378,97 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
> >   		ret = true;
> >   out:
> > -	close(pagemap_fd);
> > -	close(kpageflags_fd);
> >   	return ret;
> >   }
> > -bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> > +enum check_huge_type {
> > +	CHECK_HUGE_ANON,
> > +	CHECK_HUGE_FILE,
> > +	CHECK_HUGE_SHMEM,
> > +};
> > +
> > +static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
> > +			     uint64_t hpage_size, enum check_huge_type type)
> 
> The original __check_pmd_huge() is only for PMD-sized large folios, but now
> it not only checks PMD-sized large folios but also mTHP large folios, which
> I find confusing. Please keep its original semantics, and only check
> PMD-sized large folios.

But, It seems to valuable to check other page-flags than checking
the large-folio only.

> 
> >   {
> > -	uint64_t pmd_pagesize = read_pmd_pagesize();
> > +	int pagemap_fd, kpageflags_fd;
> > +	uint64_t pmd_pagesize, granule;
> > +	uint64_t categories, kpf;
> > +	unsigned long pfn;
> > +	bool check_large, huge_mapped;
> > +	char *start = addr;
> > +	char *end = start + len;
> > +	pmd_pagesize = read_pmd_pagesize();
> >   	if (!pmd_pagesize)
> >   		ksft_exit_fail_msg("reading PMD pagesize failed\n");
> > -	if (hpage_size == pmd_pagesize)
> > -		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
> > +	if (nr_hpages > 0) {
> > +		check_large = true;
> > +		granule = hpage_size;
> > +	} else {
> > +		check_large = false;
> > +		granule = psize();
> > +	}
> 
> This is incorrect for the mTHP large folio check. I already hit a selftest
> failure. Please test your patches before sending them out.

Since for a split case, large folio can be as-is but only remove
the PMD mapping only, skipping the large_folio checking seems valid
when nr_hpage is 0.

And the failure of test seems because of unmapped area after
changinng the collapse-order. Therefore, it seems to fine with below
patch:

---------------&<----------------------

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 1d0959b3b9e8..f174a76d2310 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -387,14 +387,14 @@ enum check_huge_type {
        CHECK_HUGE_SHMEM,
 };

-static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
-                            uint64_t hpage_size, enum check_huge_type type)
+static bool __check_huge(void *addr, size_t len, int nr_hpages,
+                        uint64_t hpage_size, enum check_huge_type type)
 {
        int pagemap_fd, kpageflags_fd;
        uint64_t pmd_pagesize, granule;
        uint64_t categories, kpf;
        unsigned long pfn;
-       bool check_large, huge_mapped;
+       bool check_large, check_huge_mapped, allow_nomap;
        char *start = addr;
        char *end = start + len;

@@ -405,11 +405,20 @@ static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
        if (nr_hpages > 0) {
                check_large = true;
                granule = hpage_size;
+               if (granule == pmd_pagesize)
+                       check_huge_mapped = true;
+               else
+                       check_huge_mapped = false;
        } else {
                check_large = false;
                granule = psize();
        }

+       if (nr_hpages * hpage_size < len)
+               allow_nomap = true;
+       else
+               allow_nomap = false;
+
        pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
        if (pagemap_fd < 0)
                ksft_exit_fail_msg("open pagemap fail\n");
@@ -428,18 +437,15 @@ static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
                categories = pagemap_scan_get_categories(pagemap_fd, start);
                pfn = pagemap_get_pfn(pagemap_fd, start);
                if (pfn == -1UL) {
-                       if (check_large)
+                       if (!allow_nomap)
                                goto out;
                        else
                                continue;
                }
                if (pageflags_get(pfn, kpageflags_fd, &kpf))
                        ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
-               huge_mapped = categories & PAGE_IS_HUGE;
-               if (check_large != huge_mapped) {
-                       if (!check_large || granule == pmd_pagesize)
+               if (check_huge_mapped != !!(categories & PAGE_IS_HUGE))
                                goto out;
-               }
                if (kpf & KPF_COMPOUND_TAIL)
                        continue;
                if (!!(categories & PAGE_IS_FILE) != (type != CHECK_HUGE_ANON))
@@ -458,17 +464,17 @@ static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,

 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-       return __check_pmd_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_ANON);
+       return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_ANON);
 }

 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-       return __check_pmd_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_FILE);
+       return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_FILE);
 }

 bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-       return __check_pmd_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_SHMEM);
+       return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_SHMEM);
 }


If it's good for you, I'll repost again.

Thanks!

-- 
Sincerely,
Yeoreum Yun

