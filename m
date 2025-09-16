Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD1EACAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 10:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1EB68E0002; Tue, 16 Sep 2025 06:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF5EF8E0001; Tue, 16 Sep 2025 06:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0C008E0002; Tue, 16 Sep 2025 06:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BC78A8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 06:12:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7B581160958
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:12:21 +0000 (UTC)
X-FDA: 83894698482.01.193489A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 83641C0005
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:12:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758017539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bqKk3+vg3iMTdEjCjBbA/XZ1Ztbps0qiERc+EgOiUmo=;
	b=AO5no9W1scsN6R/ngNR2xB4Y4ymps1/bP7Wyonuhc3oRie7CsO4ApUnYylrB/tlXcntwpj
	/cZ1ECHarSjP3KK5x8sC6AM1D4D7xVC1ne6flOaroPjl9gONtMzYWjSDff9swtLAgVzwW0
	rQqGZ4X/0+quJr8zqits35gB7jzK55g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758017539; a=rsa-sha256;
	cv=none;
	b=AqU1MQk7fmtirjSIuQX3mx7fg0zPiOnPI3rQRz91KVLSqcPvRB3I+j2cxegS2rhBiVGc3S
	pZAWmDjrD5aKupsFYu4d6dl88W5bHV4fwx6RzBJycaAvwTbeTwpx5dEaimRQnqfPsSaBY+
	IJZmwf/is6352Yk2xT38yhAixiTi6dA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35CE912FC;
	Tue, 16 Sep 2025 03:12:10 -0700 (PDT)
Received: from [10.163.42.157] (unknown [10.163.42.157])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA3FE3F673;
	Tue, 16 Sep 2025 03:12:09 -0700 (PDT)
Message-ID: <a99eb11f-a7ac-48a3-a671-c5f0f6b5b491@arm.com>
Date: Tue, 16 Sep 2025 15:42:07 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
To: Kyle Meyer <kyle.meyer@hpe.com>, akpm@linux-foundation.org,
 corbet@lwn.net, david@redhat.com, linmiaohe@huawei.com, shuah@kernel.org,
 tony.luck@intel.com, jane.chu@oracle.com, jiaqiyan@google.com
Cc: Liam.Howlett@oracle.com, bp@alien8.de, hannes@cmpxchg.org, jack@suse.cz,
 joel.granados@kernel.org, laoar.shao@gmail.com, lorenzo.stoakes@oracle.com,
 mclapinski@google.com, mhocko@suse.com, nao.horiguchi@gmail.com,
 osalvador@suse.de, rafael.j.wysocki@intel.com, rppt@kernel.org,
 russ.anderson@hpe.com, shawn.fan@intel.com, surenb@google.com,
 vbabka@suse.cz, linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <aMiu_Uku6Y5ZbuhM@hpe.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <aMiu_Uku6Y5ZbuhM@hpe.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: topxms6x7u95u1un1diwr6gkkrxfyhs8
X-Rspam-User: 
X-Rspamd-Queue-Id: 83641C0005
X-Rspamd-Server: rspam04
X-HE-Tag: 1758017539-495657
X-HE-Meta: U2FsdGVkX1+Sa6YzLazEEw0+B79Bn908CTxtPxQmo42Td05JPhNuR0P/Ya3AIkXNQ6DQ8C7O2H7txDVNbJc2kzaFB1W1eJovxWhqA7IUmHsqRHjC5h8eVopdccauuUUGeCzhD3lyESme0lFssUQhJBLaD2DChDY1T9rBNVRDmh+f6Xl1ccsQ1zF6c7Zw33Pkfm5RDuROhxAQbe0BvPn9bSj/PI/+KkbZ++JvZFmqoWTlwtF7GkTP0yWzVoPUd22bNMV/eDadtVrdhP83IIcmpEK6Xoc75nnFJqvk+S01Oo6HvTJV1ZbTfUUVqftQ5tuQWqPlZtxP1up9Uv2aBZaqcXeuKgW/R5UEYqM9y4HVLpYcjQ9HrVdbsbSaGxYBQp6Jmgjfs8JjcsPRtZsRqPLHKxKEQMjJpd0zr8NTAtfc59+29171B6sbpyLVAcUfQjr9ts+nFHiFFdeVB/tKXvgVhYgbpf83LL7FnLbWZHO31mDE02lBNZOQnktSqMV11rEKnSxfDY9NEezctNkdIoRQByTpCCo7Uz42jKZiZiNCMz0xqDnEadMVZRIhIiNoZXvjyPIkl8Zwir0U9Y/dSao1cW/VCVYojlfu8zLQrb/cMRYL15kp56PzZJWLJCS8BwQ2wTWjqQyZmhv9iPXUz5VH1Ccg1AmOjigegtq7DAERjw3ocz9+ZxfQQ3Xk5u0fuGdVBLEzH3s1KwxCjFOk4glt9jCmFh3UJ3U+OlzH3x/aiU/oCFZlRHxvFVAhKOt+4oWCOjWctkJRnZOW/3aiwmIuKJ+KPbwe8Wh4Ttjgkb0hBQCDG3P+2ngHqZZuba2xvL9fUNVLo8N75kMdTzXpmJk6j8xrySIdQQQU2abZqgsifV1HyXYf1OFLxQdoakP0uDXiNTrovzLdv3AEt4xfu+Y4W+0jgFFQGfbUCxEEkyGEIdILWY5cKIKPbkx45qDPp7ldAuUXjvTP3CKo7eGSH0p
 o50STcRB
 Y17M0YA3clpqyranAIn3LDPTSCteG+SRrOpNj8kxEC+Or+Vc4Z0s4f5p7m3FatvNpiRmVUnmVEPDi/I8dITKwYADX6j4hyVeaFqrkCy5SmkcI/C2Vwz6C8TuJdlrp06GG3vxzNRMpatXwTy8slAAy9CWC0ET5aD/ZM0HeCF3kv0ZB5d/s7wVYpfzpcUsyXiGck3xizzfRchK4H/iww//aU5tB8QWNgdm4AZpeFTuXAreGa8on9tTPJwNyw5kqVaG1r3HGduwJLSMO39uUorDrvgVkCCEwKHD6FQ+B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16/09/25 5:57 AM, Kyle Meyer wrote:
> Soft offlining a HugeTLB page reduces the HugeTLB page pool.
> 
> Commit 56374430c5dfc ("mm/memory-failure: userspace controls soft-offlining pages")
> introduced the following sysctl interface to control soft offline:
> 
> /proc/sys/vm/enable_soft_offline
> 
> The interface does not distinguish between page types:
> 
>     0 - Soft offline is disabled
>     1 - Soft offline is enabled
> 
> Convert enable_soft_offline to a bitmask and support disabling soft
> offline for HugeTLB pages:
> 
> Bits:
> 
>     0 - Enable soft offline
>     1 - Disable soft offline for HugeTLB pages
> 
> Supported values:
> 
>     0 - Soft offline is disabled
>     1 - Soft offline is enabled
>     3 - Soft offline is enabled (disabled for HugeTLB pages)
> 
> Existing behavior is preserved.
> 
> Update documentation and HugeTLB soft offline self tests.
> 
> Reported-by: Shawn Fan <shawn.fan@intel.com>
> Suggested-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
> ---
> 
> Tony's patch:
> * https://lore.kernel.org/all/20250904155720.22149-1-tony.luck@intel.com
> 
> v1:
> * https://lore.kernel.org/all/aMGkAI3zKlVsO0S2@hpe.com
> 
> v1 -> v2:
> * Make the interface extensible, as suggested by David.
> * Preserve existing behavior, as suggested by Jiaqi and David.
> 
> Why clear errno in self tests?
> 
> madvise() does not set errno when it's successful and errno is set by madvise()
> during test_soft_offline_common(3) causing test_soft_offline_common(1) to fail:
> 
> # Test soft-offline when enabled_soft_offline=1
> # Hugepagesize is 1048576kB
> # enable_soft_offline => 1
> # Before MADV_SOFT_OFFLINE nr_hugepages=7
> # Allocated 0x80000000 bytes of hugetlb pages
> # MADV_SOFT_OFFLINE 0x7fd600000000 ret=0, errno=95
> # MADV_SOFT_OFFLINE should ret 0
> # After MADV_SOFT_OFFLINE nr_hugepages=6
> not ok 2 Test soft-offline when enabled_soft_offline=1
> 
> ---
>  .../ABI/testing/sysfs-memory-page-offline     |  3 ++
>  Documentation/admin-guide/sysctl/vm.rst       | 28 ++++++++++++++++---
>  mm/memory-failure.c                           | 17 +++++++++--
>  .../selftests/mm/hugetlb-soft-offline.c       | 19 ++++++++++---
>  4 files changed, 56 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-memory-page-offline b/Documentation/ABI/testing/sysfs-memory-page-offline
> index 00f4e35f916f..d3f05ed6605e 100644
> --- a/Documentation/ABI/testing/sysfs-memory-page-offline
> +++ b/Documentation/ABI/testing/sysfs-memory-page-offline
> @@ -20,6 +20,9 @@ Description:
>  		number, or a error when the offlining failed.  Reading
>  		the file is not allowed.
>  
> +		Soft-offline can be controlled via sysctl, see:
> +		Documentation/admin-guide/sysctl/vm.rst
> +

This update is applicable right away without other changes proposed.
Probably can be moved into a separate patch in itself ?
>  What:		/sys/devices/system/memory/hard_offline_page
>  Date:		Sep 2009
>  KernelVersion:	2.6.33
> diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
> index 4d71211fdad8..ace73480eb9d 100644
> --- a/Documentation/admin-guide/sysctl/vm.rst
> +++ b/Documentation/admin-guide/sysctl/vm.rst
> @@ -309,19 +309,39 @@ physical memory) vs performance / capacity implications in transparent and
>  HugeTLB cases.
>  
>  For all architectures, enable_soft_offline controls whether to soft offline
> -memory pages.  When set to 1, kernel attempts to soft offline the pages
> -whenever it thinks needed.  When set to 0, kernel returns EOPNOTSUPP to
> -the request to soft offline the pages.  Its default value is 1.
> +memory pages.
> +
> +enable_soft_offline is a bitmask:
> +
> +Bits::
> +
> +	0 - Enable soft offline
> +	1 - Disable soft offline for HugeTLB pages
> +
> +Supported values::
> +
> +	0 - Soft offline is disabled
> +	1 - Soft offline is enabled
> +	3 - Soft offline is enabled (disabled for HugeTLB pages)

This looks very adhoc even though existing behavior is preserved.

- Are HugeTLB pages the only page types to be considered ?
- How the remaining bits here are going to be used later ?

Also without a bit-wise usage roadmap, is not changing a procfs
interface (ABI) bit problematic ?
> +
> +The default value is 1.
> +
> +If soft offline is disabled for the requested page type, EOPNOTSUPP is returned.
>  
>  It is worth mentioning that after setting enable_soft_offline to 0, the
>  following requests to soft offline pages will not be performed:
>  
> +- Request to soft offline from sysfs (soft_offline_page).
> +
>  - Request to soft offline pages from RAS Correctable Errors Collector.
>  
> -- On ARM, the request to soft offline pages from GHES driver.
> +- On ARM and X86, the request to soft offline pages from GHES driver.
>  
>  - On PARISC, the request to soft offline pages from Page Deallocation Table.
>  
> +Note:
> +	Soft offlining a HugeTLB page reduces the HugeTLB page pool.
> +
>  extfrag_threshold
>  =================
>  
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index fc30ca4804bf..0ad9ae11d9e8 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -64,11 +64,14 @@
>  #include "internal.h"
>  #include "ras/ras_event.h"
>  
> +#define SOFT_OFFLINE_ENABLED		BIT(0)
> +#define SOFT_OFFLINE_SKIP_HUGETLB	BIT(1)
> +
>  static int sysctl_memory_failure_early_kill __read_mostly;
>  
>  static int sysctl_memory_failure_recovery __read_mostly = 1;
>  
> -static int sysctl_enable_soft_offline __read_mostly = 1;
> +static int sysctl_enable_soft_offline __read_mostly = SOFT_OFFLINE_ENABLED;
>  
>  atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
>  
> @@ -150,7 +153,7 @@ static const struct ctl_table memory_failure_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec_minmax,
>  		.extra1		= SYSCTL_ZERO,
> -		.extra2		= SYSCTL_ONE,
> +		.extra2		= SYSCTL_THREE,
>  	}
>  };
>  
> @@ -2799,12 +2802,20 @@ int soft_offline_page(unsigned long pfn, int flags)
>  		return -EIO;
>  	}
>  
> -	if (!sysctl_enable_soft_offline) {
> +	if (!(sysctl_enable_soft_offline & SOFT_OFFLINE_ENABLED)) {
>  		pr_info_once("disabled by /proc/sys/vm/enable_soft_offline\n");
>  		put_ref_page(pfn, flags);
>  		return -EOPNOTSUPP;
>  	}
>  
> +	if (sysctl_enable_soft_offline & SOFT_OFFLINE_SKIP_HUGETLB) {
> +		if (folio_test_hugetlb(pfn_folio(pfn))) {
> +			pr_info_once("disabled for HugeTLB pages by /proc/sys/vm/enable_soft_offline\n");
> +			put_ref_page(pfn, flags);
> +			return -EOPNOTSUPP;
> +		}
> +	}
> +
>  	mutex_lock(&mf_mutex);
>  
>  	if (PageHWPoison(page)) {
> diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tools/testing/selftests/mm/hugetlb-soft-offline.c
> index f086f0e04756..b87c8778cadf 100644
> --- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
> +++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
> @@ -5,6 +5,8 @@
>   *   offlining failed with EOPNOTSUPP.
>   * - if enable_soft_offline = 1, a hugepage should be dissolved and
>   *   nr_hugepages/free_hugepages should be reduced by 1.
> + * - if enable_soft_offline = 3, hugepages should stay intact and soft
> + *   offlining failed with EOPNOTSUPP.
>   *
>   * Before running, make sure more than 2 hugepages of default_hugepagesz
>   * are allocated. For example, if /proc/meminfo/Hugepagesize is 2048kB:
> @@ -32,6 +34,9 @@
>  
>  #define EPREFIX " !!! "
>  
> +#define SOFT_OFFLINE_ENABLED		(1 << 0)
> +#define SOFT_OFFLINE_SKIP_HUGETLB	(1 << 1)
> +
>  static int do_soft_offline(int fd, size_t len, int expect_errno)
>  {
>  	char *filemap = NULL;
> @@ -56,6 +61,7 @@ static int do_soft_offline(int fd, size_t len, int expect_errno)
>  	ksft_print_msg("Allocated %#lx bytes of hugetlb pages\n", len);
>  
>  	hwp_addr = filemap + len / 2;
> +	errno = 0;
>  	ret = madvise(hwp_addr, pagesize, MADV_SOFT_OFFLINE);
>  	ksft_print_msg("MADV_SOFT_OFFLINE %p ret=%d, errno=%d\n",
>  		       hwp_addr, ret, errno);
> @@ -83,7 +89,7 @@ static int set_enable_soft_offline(int value)
>  	char cmd[256] = {0};
>  	FILE *cmdfile = NULL;
>  
> -	if (value != 0 && value != 1)
> +	if (value < 0 || value > 3)
>  		return -EINVAL;
>  
>  	sprintf(cmd, "echo %d > /proc/sys/vm/enable_soft_offline", value);
> @@ -155,13 +161,17 @@ static int create_hugetlbfs_file(struct statfs *file_stat)
>  static void test_soft_offline_common(int enable_soft_offline)
>  {
>  	int fd;
> -	int expect_errno = enable_soft_offline ? 0 : EOPNOTSUPP;
> +	int expect_errno = 0;
>  	struct statfs file_stat;
>  	unsigned long hugepagesize_kb = 0;
>  	unsigned long nr_hugepages_before = 0;
>  	unsigned long nr_hugepages_after = 0;
>  	int ret;
>  
> +	if (!(enable_soft_offline & SOFT_OFFLINE_ENABLED) ||
> +	     (enable_soft_offline & SOFT_OFFLINE_SKIP_HUGETLB))
> +		expect_errno = EOPNOTSUPP;
> +
>  	ksft_print_msg("Test soft-offline when enabled_soft_offline=%d\n",
>  		       enable_soft_offline);
>  
> @@ -198,7 +208,7 @@ static void test_soft_offline_common(int enable_soft_offline)
>  	// No need for the hugetlbfs file from now on.
>  	close(fd);
>  
> -	if (enable_soft_offline) {
> +	if (expect_errno == 0) {
>  		if (nr_hugepages_before != nr_hugepages_after + 1) {
>  			ksft_test_result_fail("MADV_SOFT_OFFLINE should reduced 1 hugepage\n");
>  			return;
> @@ -219,8 +229,9 @@ static void test_soft_offline_common(int enable_soft_offline)
>  int main(int argc, char **argv)
>  {
>  	ksft_print_header();
> -	ksft_set_plan(2);
> +	ksft_set_plan(3);
>  
> +	test_soft_offline_common(3);
>  	test_soft_offline_common(1);
>  	test_soft_offline_common(0);
>  


