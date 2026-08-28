Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAAFDC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 07:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 943E16B008C; Fri, 28 Aug 2026 03:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CEE36B0092; Fri, 28 Aug 2026 03:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796996B0095; Fri, 28 Aug 2026 03:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6F46B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:44:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D0D4C1A028E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:44:47 +0000 (UTC)
X-FDA: 85149891414.20.D64C74B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id D1AB520002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:44:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lOH2zMsB;
	spf=pass (imf13.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787903086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=piVS6DmwDVpnpGwN9dLObb6KcErxgYvksN2/SB2Yy4Q=;
	b=klGwT/DdHYGrqQ3NDpCVHl/YfySsrnApj8SoKyCpzGw8QgBsaA4Q68uFyuQeqad+eNq2XW
	6c6asiYfYFdP6nCdubdGSWeFrqV2HayxOHL6QeNqk4hlVtlll0fK6jDOLQL4MqmrNJg9Ua
	yzOMQKzHPrZquGEyYwKGAyeoLb1jpq8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787903086;
	b=PIcpiO2KhkOi4uLecW6TFtlfcg9w8UD1F2SlXaM4S8o3LYXgvIwt+IsnLu1Ja8tpkN/9wM
	LC279QMXiW/39ZGQf74r021wO7rI4RDJDVXY+5wA5x1yMPcKeJcYZV8V5Co3GP8bOWNID0
	XXI6Ytg6CnbsIeqX0o/iTXHbu8u0KuA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lOH2zMsB;
	spf=pass (imf13.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ABA051516;
	Fri, 28 Aug 2026 00:44:40 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 669BC3F7D8;
	Fri, 28 Aug 2026 00:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787903084; bh=Sb6T7e6Dpmin6+afUWtu00w2dT67ioqJumAh7UkldEg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lOH2zMsBPdKLvwthSEKVLB7tyKS/ksiXb6naox4kJHfi0M23aMS3r2Z/ij76/zoOM
	 jNTyqyynRrsf1MnRS9au654KSYWCj7b7va736HBoCMXHsfbzyx4b/2UhOp1jcXHr34
	 UJxtYx+9r9c/fulAtfAXaUiLZXOChRRKLH7GD4yc=
Date: Fri, 28 Aug 2026 08:44:38 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
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
Message-ID: <apE8ZvWg219b9aW_@e129823.arm.com>
References: <20260826-fix_split-v2-0-71153c7f579a@arm.com>
 <20260826-fix_split-v2-2-71153c7f579a@arm.com>
 <0107447a-7c1f-44f8-94fb-109b0f850677@linux.alibaba.com>
 <apAVAvfxZSeEvf50@e129823.arm.com>
 <DKZTG6MI4EI2.35PCXKS36M1DY@nvidia.com>
 <apBruUeQoCgP_Mhh@e129823.arm.com>
 <31e649d3-7653-49c0-b73e-933ba2a86f4a@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <31e649d3-7653-49c0-b73e-933ba2a86f4a@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D1AB520002
X-Stat-Signature: gkxfqjbbj7jb1zqjmmjmc586zabeqxcc
X-HE-Tag: 1787903085-54541
X-HE-Meta: U2FsdGVkX18U4y0Q1gwHXCB7xFNHW7cyMgD7Tr0gAmE2UsbKGaApaVndmQW6FPDMLLj/fyJUPs/zbXxEdu/aeNXwQdv0d5D7jaZ5BMTNgNM5o//hKEd5dcc58HH/oeXVdPMpqq667gcWSEBQVfyf1WY0Bz9mkNzqP0LaeDuB7mCOFMnyXc9SiyoQODHqu9sGZd1GbucWymuNuGqg2vAGKwiNDaCYwMGKUYlvTtOya4qa4tJD9j15pkKlWH8GrM7m6DlHIecGxQsnGT1cl8Q+WxsppZxC6/oXaYy2n69GPF5zr+0C4eimql47wMpUY08lRvAYOUKoEtYC+HZ1tLQ/zZvHzWTDVoJVvH2hmuehqcGcs8E+g0J1pRan29vPy2MLbTe/eiBUFMwZ3ZYZGz4dSL222m+dbKcQ+NM0hZUv+Pg6X2jdv0Dfx3Zw2QnvJeiH4hbjLjePvbd0xEuhnTrIrt8hSMscx6FzrSxzaGSHyIudI/8DV/2NlpTRPesgXU5hqn+iJSPbpmBAYcQszrA3hDFE9Y8HLhimhCDCtj9NBOMFC8RSdYA+kb7pYJiXYlgbfa/s4fAptkl5941Jv8Vt5ZWPO7r4pFO6zFsrKvsBys/n/KfNcmE/FN3JuSBwr3LXIgHIOmsCKf0Yb9avA888upyK6QqABPSNnU1YDDOGhNKc93s5WyjqODEh42/GRYtAr3RnagL23rwyxC21plEtQaS4mRFErxrQ8nF2TQ/aprbmnstAYaG0jtdhAokGoHstuQRCfs4iuCKhu0Gm4B2GaEzUPO4K5ss7CzCk02hOJBjB8B+X4hguPjKmcaE0TDadRM5zwCxyLcAzQN5D/afYUVq1foTOfCLHYAB/Vq/gQBGl0YdfA/rTG6jyIDPZRw+v8hn5+vdfjEF5wFYyddCUWbNW7v/8OnH0rTHxBzJ1Dsh17WZBcmNvwuyuJGXUqM1mserODYPxLo3de1TgjW1
 4L0x+ef3
 CflXMn6qoXK6Kw42FK0z2JYDI0Dk/PnlTIpoyq2yLyimmU0GABQ+tr2Gf99+G6u9CMiZKjtegcuZjKls5bf2S6VZPz7Daw/fTFGbhuhwILxrVzdP4E2C4D1tEYDJgUqZIcUIW3WiUCS2iL9aZnXOWYMoScwCU6M9kNz4W+nRfo4tZaTTyMJRMvnf9PgswoWjlyGTfepMaRogvJa39XedQ2O1fvMqgZvJeyq7E4YZ0y+eyBgK6WZjrnFsaifEGdH/k02p63E2EK9M4yN3IicMTp9EgBc5tNiDcHrTtt/znl1C99Ylw7vpx1d+h7VNHZeuFP4G75HyYCqdLFcUSsdgANyELY1+qlrW9ERZbosWFSwuQhO5M9Q6qSjiM72YVv4pRt131yL6kzi2DR6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> 
> On 8/28/26 12:54 AM, Yeoreum Yun wrote:
> > On Thu, Aug 27, 2026 at 11:03:17AM -0400, Zi Yan wrote:
> > > On Thu Aug 27, 2026 at 6:44 AM EDT, Yeoreum Yun wrote:
> > > > Hi Baolin,
> > > > 
> > > > > 
> > > > > 
> > > > > On 8/26/26 8:24 PM, Yeoreum Yun wrote:
> > > > > > Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> > > > > > glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> > > > > > made by memalign().
> > > > > > 
> > > > > > The underlying VMA may start at a different address from the aligned
> > > > > > address returned by memalign(). Furthermore, a subsequent
> > > > > > madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> > > > > > already set.
> > > > > > 
> > > > > > This causes split_huge_page_test to fail because the check_huge_xxx()
> > > > > > helpers incorrectly require the address returned by memalign() to
> > > > > > match the VMA start address reported in /proc/self/smaps.
> > > > > > 
> > > > > > Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
> > > > > > /proc/self/smaps to detect huge pages.
> > > > > > 
> > > > > > Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> > > > > > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > > > > > ---
> > > > > >    tools/testing/selftests/mm/vm_util.c | 130 ++++++++++++++++++++---------------
> > > > > >    tools/testing/selftests/mm/vm_util.h |   1 +
> > > > > >    2 files changed, 77 insertions(+), 54 deletions(-)
> > > > > > 
> > > > > > diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> > > > > > index 4821a3563036..1d0959b3b9e8 100644
> > > > > > --- a/tools/testing/selftests/mm/vm_util.c
> > > > > > +++ b/tools/testing/selftests/mm/vm_util.c
> > > > > > @@ -351,31 +351,13 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
> > > > > >    	return entry;
> > > > > >    }
> > > > > > -static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
> > > > > > -		  uint64_t hpage_size)
> > > > > > -{
> > > > > > -	char buffer[MAX_LINE_LENGTH];
> > > > > > -	uint64_t thp = -1;
> > > > > > -	char *entry;
> > > > > > -
> > > > > > -	entry = __get_smap_entry(addr, pattern, buffer, sizeof(buffer));
> > > > > > -	if (!entry)
> > > > > > -		goto err_out;
> > > > > > -
> > > > > > -	if (sscanf(entry, "%9" SCNu64 " kB", &thp) != 1)
> > > > > > -		ksft_exit_fail_msg("Reading smap error\n");
> > > > > > -
> > > > > > -err_out:
> > > > > > -	return thp == (nr_hpages * (hpage_size >> 10));
> > > > > > -}
> > > > > > -
> > > > > > -static bool check_large_folios(void *addr, size_t len, int nr_hpages,
> > > > > > -		uint64_t hpage_size)
> > > > > > +static bool check_large_folios(int pagemap_fd, int kpageflags_fd,
> > > > > > +			       void *addr, size_t len, int nr_hpages,
> > > > > > +			       uint64_t hpage_size)
> > > > > >    {
> > > > > >    	int order = 0, pagesize = getpagesize();
> > > > > >    	unsigned int nr_pages = hpage_size / pagesize;
> > > > > >    	int orders[MAX_NR_ORDERS], status;
> > > > > > -	int pagemap_fd, kpageflags_fd;
> > > > > >    	bool ret = false;
> > > > > >    	if (!nr_pages)
> > > > > > @@ -386,15 +368,6 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
> > > > > >    		ksft_exit_fail_msg("invalid order\n");
> > > > > >    	memset(orders, 0, sizeof(int) * MAX_NR_ORDERS);
> > > > > > -	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
> > > > > > -	if (pagemap_fd == -1)
> > > > > > -		ksft_exit_fail_msg("read pagemap fail\n");
> > > > > > -
> > > > > > -	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
> > > > > > -	if (kpageflags_fd == -1) {
> > > > > > -		close(pagemap_fd);
> > > > > > -		ksft_exit_fail_msg("read kpageflags fail\n");
> > > > > > -	}
> > > > > >    	status = gather_folio_orders(addr, len, pagemap_fd,
> > > > > >    			kpageflags_fd, orders, MAX_NR_ORDERS);
> > > > > > @@ -405,48 +378,97 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
> > > > > >    		ret = true;
> > > > > >    out:
> > > > > > -	close(pagemap_fd);
> > > > > > -	close(kpageflags_fd);
> > > > > >    	return ret;
> > > > > >    }
> > > > > > -bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> > > > > > +enum check_huge_type {
> > > > > > +	CHECK_HUGE_ANON,
> > > > > > +	CHECK_HUGE_FILE,
> > > > > > +	CHECK_HUGE_SHMEM,
> > > > > > +};
> > > > > > +
> > > > > > +static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
> > > > > > +			     uint64_t hpage_size, enum check_huge_type type)
> > > > > 
> > > > > The original __check_pmd_huge() is only for PMD-sized large folios, but now
> > > > > it not only checks PMD-sized large folios but also mTHP large folios, which
> > > > > I find confusing. Please keep its original semantics, and only check
> > > > > PMD-sized large folios.
> > > > 
> > > > But, It seems to valuable to check other page-flags than checking
> > > > the large-folio only.
> > > > 
> > > > > 
> > > > > >    {
> > > > > > -	uint64_t pmd_pagesize = read_pmd_pagesize();
> > > > > > +	int pagemap_fd, kpageflags_fd;
> > > > > > +	uint64_t pmd_pagesize, granule;
> > > > > > +	uint64_t categories, kpf;
> > > > > > +	unsigned long pfn;
> > > > > > +	bool check_large, huge_mapped;
> > > > > > +	char *start = addr;
> > > > > > +	char *end = start + len;
> > > > > > +	pmd_pagesize = read_pmd_pagesize();
> > > > > >    	if (!pmd_pagesize)
> > > > > >    		ksft_exit_fail_msg("reading PMD pagesize failed\n");
> > > > > > -	if (hpage_size == pmd_pagesize)
> > > > > > -		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
> > > > > > +	if (nr_hpages > 0) {
> > > > > > +		check_large = true;
> > > > > > +		granule = hpage_size;
> > > > > > +	} else {
> > > > > > +		check_large = false;
> > > > > > +		granule = psize();
> > > > > > +	}
> > > > > 
> > > > > This is incorrect for the mTHP large folio check. I already hit a selftest
> > > > > failure. Please test your patches before sending them out.
> > > > 
> > > > Since for a split case, large folio can be as-is but only remove
> > > > the PMD mapping only, skipping the large_folio checking seems valid
> > > > when nr_hpage is 0.
> > > 
> > > What split care are you referring to? split_huge_page_test() always
> > > splits the folio.
> > 
> > Not for split_huge_page_test case but for khugepage testcase like
> > collapse_full_of_compound() test.
> > 
> > > 
> > > > 
> > > > And the failure of test seems because of unmapped area after
> > > > changinng the collapse-order. Therefore, it seems to fine with below
> > > > patch:
> > > > 
> > > > ---------------&<----------------------
> > > > 
> > > > diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> > > > index 1d0959b3b9e8..f174a76d2310 100644
> > > > --- a/tools/testing/selftests/mm/vm_util.c
> > > > +++ b/tools/testing/selftests/mm/vm_util.c
> > > > @@ -387,14 +387,14 @@ enum check_huge_type {
> > > >          CHECK_HUGE_SHMEM,
> > > >   };
> > > > 
> > > > -static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
> > > > -                            uint64_t hpage_size, enum check_huge_type type)
> > > > +static bool __check_huge(void *addr, size_t len, int nr_hpages,
> > > > +                        uint64_t hpage_size, enum check_huge_type type)
> > > >   {
> > > >          int pagemap_fd, kpageflags_fd;
> > > >          uint64_t pmd_pagesize, granule;
> > > >          uint64_t categories, kpf;
> > > >          unsigned long pfn;
> > > > -       bool check_large, huge_mapped;
> > > > +       bool check_large, check_huge_mapped, allow_nomap;
> > > >          char *start = addr;
> > > >          char *end = start + len;
> > > > 
> > > > @@ -405,11 +405,20 @@ static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
> > > >          if (nr_hpages > 0) {
> > > >                  check_large = true;
> > > >                  granule = hpage_size;
> > > > +               if (granule == pmd_pagesize)
> > > > +                       check_huge_mapped = true;
> > > > +               else
> > > > +                       check_huge_mapped = false;
> > > >          } else {
> > > >                  check_large = false;
> > > >                  granule = psize();
> > > >          }
> > > 
> > > The else is for nr_hpages == 0? But it looks like we allow negative
> > > nr_hpages. Maybe add a bool expect_huge = nr_hpages > 0 to make it
> > > explicit.
> > 
> > Fair enough. I'll change.
> > 
> > > 
> > > granule is an optimization for PAGE_IS_HUGE scanning? When we expect a
> > > PMD mapping, we just scan at pmd_pagesize granularity, otherwise we
> > > check every single page?
> > > 
> > > At the high level, the function looks good to me, the rules are:
> > > 
> > > 1. if hpage_size == pmd_pagesize, we need to check PAGE_IS_HUGE and
> > > check_large_folio() can be skipped, since we only care about mappings.
> > > This checks for PMD mappings.
> > > 
> > > 2. in other cases, check_large_folios() is always needed. This is for
> > > mTHP checks.
> 
> Yes, this is also what I thought. And the following code looks good to me.
> Thanks.
> 
> > Exactly, but for some testcase where use this function, doesn't
> > trigger split of large _folio but only check the HUGE MAP is removed
> > (nr_hpage == 0), it skips the chekc_large_folio().
> > 
> > > 
> > > I think the ifs at the beginning is confusing. Can we do something like
> > > below to get rid of the ifs? I also moved KPF_* checks in a separate
> > > function. Feel free to make changes if you find any issue there.
> > > 
> > > static bool check_huge_type(uint64_t categories, uint64_t kpageflags,
> > > 			    enum check_huge_type type)
> > > {
> > > 	bool file = categories & PAGE_IS_FILE;
> > > 	bool swapbacked = kpageflags & KPF_SWAPBACKED;
> > > 
> > > 	switch (type) {
> > > 	case CHECK_HUGE_ANON:
> > > 		return !file;
> > > 	case CHECK_HUGE_FILE:
> > > 		return file && !swapbacked;
> > > 	case CHECK_HUGE_SHMEM:
> > > 		return file && swapbacked;
> > > 	}
> > > 
> > > 	return false;
> > > }
> > > 
> > > static bool __check_huge(void *addr, size_t len, int nr_hpages,
> > > 			 uint64_t hpage_size, enum check_huge_type type)
> > > {
> > > 	int pagemap_fd, kpageflags_fd;
> > > 	int nr_pmd_mappings = 0;
> > > 	uint64_t pmd_pagesize, scan_mapping_size;
> > > 	uint64_t categories, kpf;
> > > 	unsigned long pfn;
> > > 	bool check_pmd_mapping;
> > > 	bool allow_nonpresent;
> > > 	bool ret = false;
> > > 	char *start = addr;
> > > 	char *end = start + len;
> > > 
> > > 	pmd_pagesize = read_pmd_pagesize();
> > > 	if (!pmd_pagesize)
> > > 		ksft_exit_fail_msg("reading PMD pagesize failed\n");
> > > 
> > > 	check_pmd_mapping = hpage_size == pmd_pagesize;
> > > 	scan_mapping_size = nr_hpages > 0 ? hpage_size : psize();
> > > 	/* Some mTHP tests check a partially populated PMD-sized range. */
> > > 	allow_nonpresent = (uint64_t)nr_hpages * hpage_size < len;
> > > 
> > > 	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
> > > 	if (pagemap_fd < 0)
> > > 		ksft_exit_fail_msg("open pagemap fail\n");
> > > 
> > > 	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
> > > 	if (kpageflags_fd < 0) {
> > > 		close(pagemap_fd);
> > > 		ksft_exit_fail_msg("open kpageflags fail\n");
> > > 	}
> > > 
> > > 	/* PTE-mapped large folios cannot be identified by PAGE_IS_HUGE. */
> > > 	if (!check_pmd_mapping &&
> > > 	    !check_large_folios(pagemap_fd, kpageflags_fd, addr, len,
> > > 				 nr_hpages, hpage_size))
> > > 		goto out;
> > > 
> > > 	for (; start < end; start += scan_mapping_size) {
> > > 		categories = pagemap_scan_get_categories(pagemap_fd, start);
> > > 		pfn = pagemap_get_pfn(pagemap_fd, start);
> > > 		if (pfn == -1UL) {
> > > 			if (!allow_nonpresent)
> > > 				goto out;
> > > 			continue;
> > > 		}
> > > 		if (pageflags_get(pfn, kpageflags_fd, &kpf))
> > > 			ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
> > > 		if (check_pmd_mapping && (categories & PAGE_IS_HUGE))
> > > 			nr_pmd_mappings++;
> > > 		if (kpf & KPF_COMPOUND_TAIL)
> > > 			continue;
> > > 		if (!check_huge_type(categories, kpf, type))
> > > 			goto out;
> > > 	}
> > > 	if (check_pmd_mapping && nr_pmd_mappings != nr_hpages)
> > > 		goto out;
> > 
> > Again, because of collapse_full_of_compound() testcase,
> > it would be failed for this. so, it would better to skip
> > check_large_folioes() when nr_hpages is 0.
> 
> IIUC, when nr_hpages is 0, we should also call check_large_folios() to
> verify that there are no large folios within this address range, which is
> also what the previous code did.
> 
> Also, I tried Zi's code, and it passed all my khugepaged selftests. I'm not
> sure why you saw the collapse_full_of_compound() test case fail.

Ah, Sorry to my misunderstding I've misread the code on condition :(.
(!check_pmd_mapping as check_pmd_mapping)...

Yeap. it seems fine to check PAGE_IS_HUGE instead of large folio for
pmd_hugepage case.

Sorry to make noise.

-- 
Sincerely,
Yeoreum Yun

