Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 021D5CDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E243E6B008A; Wed, 24 Jun 2026 10:46:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3E86B0092; Wed, 24 Jun 2026 10:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E906B0099; Wed, 24 Jun 2026 10:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E17B6B008A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:46:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2671E1C2525
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:46:08 +0000 (UTC)
X-FDA: 84915081216.28.36201B0
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2C82C4000A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:46:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L89uQ0t2;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782312366;
	b=W1p5UWTBXTRxDFi+tzipJlhkoglIXPKKPBGeQTg34A8r3hPg400acp5qgq2SfcqX8Q9Af5
	NtnS8ZHLX+jlh5it5YGLFGgRUBPl+YBCXj6UmThGrM5DvwqK2LurvT4WsT2d+ocbghAMYH
	lRiaQU4OSp1C8ztUfwBnRrppBXP3fdI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782312366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2EmFMQXAF3SH9IkfCy6nxtG5X9ixsa1T9bDbcNcEkCM=;
	b=l04x9kihVPuL4AcsPKQXs14ggrV6AhZunrCRMUA5DC25dCAxHs8YRnBMT+yntKSJdBILTQ
	N5QAefgbgcy/jwdoGV9hJ5srHAob8dG4NQPX3BiNyqEphdWiJPDHY0qGOeSMNPftVLCgjA
	uqQ8xSlIZoE3mWeyjF579Ffx9Ybr+9Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L89uQ0t2;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782312364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2EmFMQXAF3SH9IkfCy6nxtG5X9ixsa1T9bDbcNcEkCM=;
	b=L89uQ0t2nnlmFg1NV2qtm6TZKMMlL/Ff7Gx1S+eoeAaHQmAvU2nEsTwRv8TIw1yHiqee+Z
	rte6zxLKn0GIOmnR9ztXpJegX996e9n58/C1fJnSP/mRgbAISSRb/NgKfo/q1W5ClSHuVA
	316i/+sAa7ra5Y0iazo4kVW5aALm/yA=
From: Usama Arif <usama.arif@linux.dev>
To: Charles Haithcock <chaithco@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	david@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	arozansk@redhat.com
Subject: Re: [PATCH v2] Respect mempolicy when calculating surplus huge pages.
Date: Wed, 24 Jun 2026 07:45:59 -0700
Message-ID: <20260624144600.8159-1-usama.arif@linux.dev>
In-Reply-To: <20260623184548.1245488-1-chaithco@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2C82C4000A
X-Rspam-User: 
X-Stat-Signature: row4yqg3f96u58zgimb7ousae5uqnp5y
X-HE-Tag: 1782312366-353106
X-HE-Meta: U2FsdGVkX1/XVp63TVEA+NcJ9gFrYOxlhYN04YIKiSC2V08V2BkT0PaPRGLAR9ypdvIAeDChRXy/eP67EsXEMQv7e8kXWjVrbPdrhMwyp3bdXY+ZwtfEFvF5HZbtuEAQ/iY4PJ8OihpCq//8A4Jdbw6CuO9QEXXqtgMmNKBJC7E3QE4SwlkxlltR2V7CpV0Wy1bMMQBj720j/X313qUPGphAvm/WriXacDhX7qEdPFSYMjazbxwLpgMHRE9a/bHZrJ5qINHBPisT7RvJzZeKXRPITYWh5j/Rz+Qu9D58DK1z3AIlENoINv2nfA3D2pS//hcuKDyG1bZvEjDXUDQnwlte+MWOFd446yrW9As1MZCVaiP2/vPh0FJie4s17tLkVLK1uv/eZ5JNMKfFVAwYZY4e3SUbwCdZk//XpKjJXH6gan/bLZNBgCELV1sRSU4SXMnPi0fuPcyr+crdsaf0AfPiqBXo0kU6qeyz0/0hOSCjS7ZXW90hRsYMV1rfJBGaJs3Z843gWMfmn+3jywZ2Lo7IcQk+v9bQmGY9VgHrKwooeuAli0sbHUWG7Jp0kRYDVTiY8pyK0rOUiP6q0ICS4DGL5YAtf5qi4jOC0ceagnzdh6aZp8KppwIihZHI7hUGxwMkzRbzdk6cGCAXelzedHvlM/cBTYCMlRlUH3GXdE/pJz1mGL/3HTb4LGm+vOy5HQxeqNDCLWMfT1LnqikVF+h6b3wrPU7TmTYEyGIweaPuZlD6R0YsG23kLLk+exgDUGZ09CA50IftpDwkjCE76LS810zj2m5CRpjTaw6hXkKfvQdeL3o67yHJEQO891o1U4dCIA5QLZRLL1VwVZHNZnG5b8JxCtyOiKUZfNuWRGhtE1Vr67KE06MfMxXCnPp6vNN/rzHUQwu9OM4wDaha1xi2aZkYXFgnhLDkaoD4i9dLAQMd9KRbYJ52W9NCZpNpgrTq/t0ivJOj+WvcMfA
 j3wZ+fPH
 1OcN8yQvw9fIR9wi4t2G84llmKBg8C7ed2k3+GD2VTehkJy1OyLDrC4oCyLCU0/nG1cTnlQuYnHzePH5YFOZoK9ZMIFshe7xK6SUUIsidzwEK9iKeWMYZiiN3aLrvYZgkJ8f+3WDrsxPy5y0iX0gAxb+aIYymKj0/7iSvHurRhqHir6Xh1LTmXTaznOTVqfbtwhrS+Z6B1dDFHhTcAZSNi5nNyrXnCVbwX3x+Z8xDQ+c42x1LeNzMNv760rIJpT286HevzNRPz45f9gE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 12:45:42 -0600 Charles Haithcock <chaithco@redhat.com> wrote:

> Presently, when calculating how many huge pages are needed when
> reserving surplus huge pages, the global count of free huge pages
> are used. When reserving with a mempolicy, the global count of free huge
> pages is used even if some/all of those free huge pages are on numa
> nodes outside of the mempolicy.
> 
> Reserving surplus huge pages is ultimately best effort even without a
> mempolicy. Restrictions from cpusets and mempolicies further complicate
> calculating correct numbers of surplus huge pages to reserve and
> maintaining which nodes those reservations belong to (see the comment in
> `hugetlb_acct_memory`).
> 
> However, we can do a little better when reserving surplus huge pages
> with a mempolicy. This patch changes how to calculate the necessary
> amount of surplus huge pages to reserve by considering the max of either
> the amount of free huge pages on nodes in the mempolicy or the global
> amount of free huge pages. We may still attempt to reserve huge pages
> outside the mempolicy, however, we end up being more likely to reserve
> from nodes in the mempolicy.
> 
> Signed-off-by: Charles Haithcock <chaithco@redhat.com>
> ---
> 
> - v1: Modified `needed` calculation to use `allowed_mems_nr(h)` in order
>   to consider free hugetlb pages in our mempolicy.
> - v2: Folded in Joshua Hahn's recommendation [1] to further modify 
>   `needed` calculation to take the max of either the available hugetlb 
>   pages in the mempolicy or the globally available hugetlb pages. Allows
>   allocations to prioritize nodes in the mempolicy but can still fall
>   back to offnode allocations. Also added selftests to check only for
>   the edgecase which caused this to initially be reported and sanity
>   checks.
> 
> [1] https://lore.kernel.org/all/20260602152022.2673803-1-joshua.hahnjy@gmail.com/
> 
>  mm/hugetlb.c                                  |  42 +-
>  tools/testing/selftests/mm/Makefile           |   3 +
>  .../selftests/mm/hugetlb_surplus_mempolicy.c  | 472 ++++++++++++++++++
>  tools/testing/selftests/mm/run_vmtests.sh     |   1 +
>  4 files changed, 498 insertions(+), 20 deletions(-)
>  create mode 100644 tools/testing/selftests/mm/hugetlb_surplus_mempolicy.c
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index f24bf49be0..bd97f0f434 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2255,6 +2255,23 @@ static nodemask_t *policy_mbind_nodemask(gfp_t gfp)
>  	return NULL;
>  }
>  
> +static unsigned int allowed_mems_nr(struct hstate *h)
> +{
> +	int node;
> +	unsigned int nr = 0;
> +	nodemask_t *mbind_nodemask;
> +	unsigned int *array = h->free_huge_pages_node;
> +	gfp_t gfp_mask = htlb_alloc_mask(h);
> +
> +	mbind_nodemask = policy_mbind_nodemask(gfp_mask);
> +	for_each_node_mask(node, cpuset_current_mems_allowed) {
> +		if (!mbind_nodemask || node_isset(node, *mbind_nodemask))
> +			nr += array[node];
> +	}
> +
> +	return nr;
> +}
> +
>  /*
>   * Increase the hugetlb pool such that it can accommodate a reservation
>   * of size 'delta'.
> @@ -2277,7 +2294,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
>  		alloc_nodemask = cpuset_current_mems_allowed;
>  
>  	lockdep_assert_held(&hugetlb_lock);
> -	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
> +	needed = max((long) (delta - allowed_mems_nr(h)),
> +		(long) ((h->resv_huge_pages + delta) - h->free_huge_pages));
>  	if (needed <= 0) {
>  		h->resv_huge_pages += delta;
>  		return 0;
> @@ -2311,8 +2329,9 @@ static int gather_surplus_pages(struct hstate *h, long delta)
>  	 * because either resv_huge_pages or free_huge_pages may have changed.
>  	 */
>  	spin_lock_irq(&hugetlb_lock);
> -	needed = (h->resv_huge_pages + delta) -
> -			(h->free_huge_pages + allocated);
> +	needed = max((long) ((delta - allowed_mems_nr(h)) - allocated),
> +			(long) ((h->resv_huge_pages + delta) -
> +				(h->free_huge_pages + allocated)));
>  	if (needed > 0) {
>  		if (alloc_ok)
>  			goto retry;
> @@ -4513,23 +4532,6 @@ static int __init hugepage_alloc_threads_setup(char *s)
>  }
>  __setup("hugepage_alloc_threads=", hugepage_alloc_threads_setup);
>  
> -static unsigned int allowed_mems_nr(struct hstate *h)
> -{
> -	int node;
> -	unsigned int nr = 0;
> -	nodemask_t *mbind_nodemask;
> -	unsigned int *array = h->free_huge_pages_node;
> -	gfp_t gfp_mask = htlb_alloc_mask(h);
> -
> -	mbind_nodemask = policy_mbind_nodemask(gfp_mask);
> -	for_each_node_mask(node, cpuset_current_mems_allowed) {
> -		if (!mbind_nodemask || node_isset(node, *mbind_nodemask))
> -			nr += array[node];
> -	}
> -
> -	return nr;
> -}
> -
>  void hugetlb_report_meminfo(struct seq_file *m)
>  {
>  	struct hstate *h;
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index cd24596cdd..40de0938f3 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -106,6 +106,7 @@ TEST_GEN_FILES += guard-regions
>  TEST_GEN_FILES += merge
>  TEST_GEN_FILES += rmap
>  TEST_GEN_FILES += folio_split_race_test
> +TEST_GEN_FILES += hugetlb_surplus_mempolicy
>  
>  ifneq ($(ARCH),arm64)
>  TEST_GEN_FILES += soft-dirty
> @@ -260,6 +261,8 @@ $(OUTPUT)/migration: LDLIBS += -lnuma
>  
>  $(OUTPUT)/rmap: LDLIBS += -lnuma
>  
> +$(OUTPUT)/hugetlb_surplus_mempolicy: LDLIBS += -lnuma
> +
>  local_config.mk local_config.h: check_config.sh
>  	CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
>  
> diff --git a/tools/testing/selftests/mm/hugetlb_surplus_mempolicy.c b/tools/testing/selftests/mm/hugetlb_surplus_mempolicy.c
> new file mode 100644
> index 0000000000..0a77b01693
> --- /dev/null
> +++ b/tools/testing/selftests/mm/hugetlb_surplus_mempolicy.c
> @@ -0,0 +1,472 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * hugetlb_surplus_mempolicy
> + *
> + * Reserving surplus hugepages within mempolicies is quite tricky due to
> + * the transient nature of cpusets and mempolicies. As such, these tests
> + * do not cover all edge cases, but rather focus on what the kernel can
> + * currently do to reserve surplus hugepages in the presence of cpusets
> + * and mempolicies to help check for regressions in this behavior.
> + */
> +
> +#define _GNU_SOURCE
> +#include <errno.h>
> +#include <numa.h>
> +#include <pthread.h>
> +#include <stdlib.h>
> +#include <stdio.h>
> +#include <unistd.h>
> +
> +#include "vm_util.h"
> +#include "kselftest.h"
> +
> +#define HPSIZE_BYTES default_huge_page_size()
> +#define HPSIZE_KB default_huge_page_size() >> 10
> +#define GLOBAL_SYS_HP_PATH "/sys/kernel/mm/hugepages/hugepages-%lukB/%s"
> +#define NODE_SYS_HP_PATH "/sys/devices/system/node/node%u/hugepages/hugepages-%lukB/%s"
> +
> +struct bitmask **nodemasks;
> +int *nodeids;
> +
> +pthread_t *threads;
> +struct thread_args {
> +	struct bitmask *my_nodemask;
> +	int to_reserve;
> +};
> +struct thread_args* per_thread_args;
> +pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
> +pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
> +int wake_cond = 0;
> +
> +char *nr_overcommit_hugepages_path;
> +char *g_free_hugepages_path;
> +char *g_nr_hugepages_path;
> +char *g_resv_hugepages_path;
> +char *g_surplus_hugepages_path;
> +char *n0_free_hugepages_path;
> +char *n0_nr_hugepages_path;
> +char *n0_surplus_hugepages_path;
> +char *n1_free_hugepages_path;
> +char *n1_nr_hugepages_path;
> +char *n1_surplus_hugepages_path;
> +
> +unsigned long g_free_hugepages, g_nr_hugepages;
> +unsigned long g_resv_hugepages, g_surplus_hugepages;
> +unsigned long n0_free_hugepages, n0_nr_hugepages, n0_surplus_hugepages;
> +unsigned long int n1_free_hugepages, n1_nr_hugepages, n1_surplus_hugepages;
> +unsigned long int orig_n0_nr_hugepages, orig_n1_nr_hugepages;
> +unsigned long int orig_nr_overcommit_hugepages;
> +
> +
> +/* setup_paths
> + *
> + * Helper function to create strings for the various hugetlb page sysfs
> + * paths. The strings are used to read from and write to the sysfs files.
> + */
> +static void setup_paths(void) {
> +	asprintf(&nr_overcommit_hugepages_path,
> +			"/proc/sys/vm/nr_overcommit_hugepages");
> +	asprintf(&g_free_hugepages_path, GLOBAL_SYS_HP_PATH,
> +			HPSIZE_KB, "free_hugepages");
> +	asprintf(&g_nr_hugepages_path, GLOBAL_SYS_HP_PATH,
> +			HPSIZE_KB, "nr_hugepages");
> +	asprintf(&g_resv_hugepages_path, GLOBAL_SYS_HP_PATH,
> +			HPSIZE_KB, "resv_hugepages");
> +	asprintf(&g_surplus_hugepages_path, GLOBAL_SYS_HP_PATH,
> +			HPSIZE_KB, "surplus_hugepages");
> +	asprintf(&n0_free_hugepages_path, NODE_SYS_HP_PATH, nodeids[0],
> +			HPSIZE_KB, "free_hugepages");
> +	asprintf(&n0_nr_hugepages_path, NODE_SYS_HP_PATH, nodeids[0],
> +			HPSIZE_KB, "nr_hugepages");
> +	asprintf(&n0_surplus_hugepages_path, NODE_SYS_HP_PATH, nodeids[0],
> +			HPSIZE_KB, "surplus_hugepages");
> +	asprintf(&n1_free_hugepages_path, NODE_SYS_HP_PATH, nodeids[1],
> +			HPSIZE_KB, "free_hugepages");
> +	asprintf(&n1_nr_hugepages_path, NODE_SYS_HP_PATH, nodeids[1],
> +			HPSIZE_KB, "nr_hugepages");
> +	asprintf(&n1_surplus_hugepages_path, NODE_SYS_HP_PATH, nodeids[1],
> +			HPSIZE_KB, "surplus_hugepages");
> +}
> +
> +/* get_hugepage_stats
> + *
> + * Helper function to simply grab a bunch of the hugetlb page metrics in sysfs
> + */
> +static void get_hugepage_stats(void) {
> +	read_sysfs(g_free_hugepages_path, &g_free_hugepages);
> +	read_sysfs(g_nr_hugepages_path, &g_nr_hugepages);
> +	read_sysfs(g_resv_hugepages_path, &g_resv_hugepages);
> +	read_sysfs(g_surplus_hugepages_path, &g_surplus_hugepages);
> +	read_sysfs(n0_free_hugepages_path, &n0_free_hugepages);
> +	read_sysfs(n0_nr_hugepages_path, &n0_nr_hugepages);
> +	read_sysfs(n0_surplus_hugepages_path, &n0_surplus_hugepages);
> +	read_sysfs(n1_free_hugepages_path, &n1_free_hugepages);
> +	read_sysfs(n1_nr_hugepages_path, &n1_nr_hugepages);
> +	read_sysfs(n1_surplus_hugepages_path, &n1_surplus_hugepages);
> +}
> +
> +/* save_hugepage_configs
> + *
> + * Helper function to save the current state of the hugepage configs so this
> + * test suite doesn't clobber configs needed for other tests.
> + */
> +static void save_hugepage_configs(void) {
> +	read_sysfs(n0_nr_hugepages_path, &orig_n0_nr_hugepages);
> +	read_sysfs(n1_nr_hugepages_path, &orig_n1_nr_hugepages);
> +	read_sysfs(nr_overcommit_hugepages_path, &orig_nr_overcommit_hugepages);
> +}
> +
> +/* restore_hugepage_configs
> + *
> + * Helper function to restore the state of hugepage configs before this test
> + * was ran.
> + */
> +static void restore_hugepage_configs(void) {
> +	write_sysfs(n0_nr_hugepages_path, orig_n0_nr_hugepages);
> +	write_sysfs(n1_nr_hugepages_path, orig_n1_nr_hugepages);
> +	write_sysfs(nr_overcommit_hugepages_path, orig_nr_overcommit_hugepages);
> +}
> +
> +/* reset_hugepages
> + *
> + * Helper function to reset static hugetlb page reservations to 0.
> + * Used to get back to a clear state between tests.
> + */
> +static void reset_hugepages(void) {
> +	write_sysfs(nr_overcommit_hugepages_path, 0);
> +	write_sysfs(g_nr_hugepages_path, 0);
> +	write_sysfs(n0_nr_hugepages_path, 0);
> +	write_sysfs(n1_nr_hugepages_path, 0);
> +}
> +
> +/* can_run
> + *
> + * Does sanity checking first to make sure the tests can even run.
> + */
> +static void check_requirements(void) {
> +        if (geteuid() != 0)
> +                ksft_exit_skip("Please run the test as root.\n");
> +
> +	if (numa_available() == -1)
> +		ksft_exit_skip("Numa is unavailable.\n");
> +
> +	if (numa_num_configured_nodes() < 2)
> +		ksft_exit_skip("Not enough nodes to test.\n");
> +
> +	if (numa_num_task_nodes() < 2)
> +		ksft_exit_skip("Current mempolicy is too restrictive.\n");
> +}
> +
> +static void cleanup(char* err_msg) {
> +	free(per_thread_args);
> +	free(threads);
> +	free(nodeids);
> +	free(nodemasks);
> +	free(nr_overcommit_hugepages_path);
> +	free(g_free_hugepages_path);
> +	free(g_nr_hugepages_path);
> +	free(g_resv_hugepages_path);
> +	free(g_surplus_hugepages_path);
> +	free(n0_free_hugepages_path);
> +	free(n0_nr_hugepages_path);
> +	free(n0_surplus_hugepages_path);
> +	free(n1_free_hugepages_path);
> +	free(n1_nr_hugepages_path);
> +	free(n1_surplus_hugepages_path);
> +	if (err_msg)
> +		ksft_exit_fail_msg(err_msg);
> +}
> +
> +/* setup_node_info
> + *
> + * Creates the bitmasks used to isolate test runners and their hugetlb page
> + * reservations.
> + */
> +static void setup_node_info(void) {
> +	int i;
> +	int ith_nodemask = 0;
> +
> +	nodeids = calloc(2, sizeof(int));
> +	nodemasks = calloc(2, sizeof(struct bitmask *));
> +
> +	if (!nodemasks || !nodeids)
> +		cleanup("setup_node_info: calloc.");
> +
> +	/* Walk the nodes available to us. Create two bitmasks, one of the
> +	 * index of the first node available to us, and the second of the next
> +	 * node available to us. */
> +	for (i = 0; i < numa_num_task_nodes(); i++) {
> +		if (numa_bitmask_isbitset(numa_get_mems_allowed(), i)) {
> +			nodeids[ith_nodemask] = i;
> +			nodemasks[ith_nodemask++] = numa_bitmask_setbit(
> +					numa_allocate_nodemask(), i);
> +		}
> +	}
> +	if (ith_nodemask != 2 || !nodemasks[0] || !nodemasks[1])
> +		cleanup("Failed to create nodemasks.");
> +}
> +
> +/* setup_threads
> + *
> + * Helper function to setup space for threads.
> + */
> +static void setup_threads(void) {
> +	per_thread_args = calloc(2, sizeof(per_thread_args));

Should we do calloc(2, sizeof(*per_thread_args)) here?

> +	if (!per_thread_args)
> +		cleanup("calloc thread args.");
> +
> +	threads = calloc(2, sizeof(pthread_t));
> +	if (!threads) {
> +		cleanup("calloc threads.");
> +	}
> +}
> +
> +/* reserve_hugepage
> + *
> + * Helper function to reserve a hugetlb page
> + */
> +static unsigned long* reserve_hugepage(void) {
> +	return (unsigned long *) mmap(NULL, HPSIZE_BYTES, PROT_READ | PROT_WRITE,
> +		MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
> +}
> +
> +/* thread_work
> + *
> + * Test runners. Performs the work of reserving and freeing hugetlb pages.
> + */
> +static void *thread_work(void *arg) {
> +	struct thread_args* t_args = (struct thread_args*) arg;
> +	unsigned long **hugepages;
> +	int i;
> +
> +	hugepages = (unsigned long **) calloc(t_args->to_reserve,
> +						sizeof(unsigned long **));
> +
> +	/* Reserve hugetlb pages on my node */
> +	if (t_args->my_nodemask)
> +		numa_bind(t_args->my_nodemask);
> +	for (i = 0; i < t_args->to_reserve; i++) {
> +		hugepages[i] = reserve_hugepage();
> +		/* Tests may purposefully try to overallocate, so just
> +		 * fall through rather than error out*/
> +		if (hugepages[i] == MAP_FAILED) {
> +			t_args->to_reserve = i;
> +			break;
> +		}
> +	}
> +
> +	/* Go to sleep until main thread wakes us up */
> +	pthread_mutex_lock(&mutex);
> +	while(!wake_cond) {
> +		pthread_cond_wait(&cond, &mutex);
> +	}
> +	pthread_mutex_unlock(&mutex);
> +
> +	/* Try to free those hugetlb pages */
> +	for (i = 0; i < t_args->to_reserve; i++) {
> +		if (munmap(hugepages[i], HPSIZE_BYTES) < 0)
> +			ksft_perror("munmap() failed! Check for leaked hugetlb pages!\n");
> +	}
> +	free(hugepages);
> +	return NULL;
> +}
> +
> +/* wake_children
> + *
> + * Helper function to wake children threads.
> + */
> +static void wake_children(void) {
> +	pthread_mutex_lock(&mutex);
> +	wake_cond = 1;
> +	pthread_cond_broadcast(&cond);
> +	pthread_mutex_unlock(&mutex);
> +}
> +
> +/* test1
> + *
> + * Sanity checking, attempt to reserve a surplus hugetlb page anywhere.
> + */
> +static void test1(void) {
> +	reset_hugepages();
> +
> +	write_sysfs(nr_overcommit_hugepages_path, 1);
> +	per_thread_args[0].my_nodemask = NULL;
> +	per_thread_args[0].to_reserve = 1;
> +
> +	pthread_create(&threads[0], NULL, thread_work, &per_thread_args[0]);
> +
> +	usleep(500000);
> +
> +	get_hugepage_stats();
> +	ksft_test_result((g_free_hugepages == 1 && g_nr_hugepages == 1 &&
> +			 g_resv_hugepages == 1 && g_surplus_hugepages == 1) &&
> +			 ((n0_free_hugepages == 1 && n0_nr_hugepages == 1 &&
> +			 n0_surplus_hugepages == 1 && n1_free_hugepages == 0 &&
> +			 n1_nr_hugepages == 0 && n1_surplus_hugepages == 0) ||
> +			 (n0_free_hugepages == 0 && n0_nr_hugepages == 0 &&
> +			 n0_surplus_hugepages == 0 && n1_free_hugepages == 1 &&
> +			 n1_nr_hugepages == 1 && n1_surplus_hugepages == 1)),
> +			 "Reserve 1 surplus hugepage anywhere\n");
> +
> +	wake_children();
> +	pthread_join(threads[0], NULL);
> +	wake_cond = 0;
> +	reset_hugepages();
> +}
> +
> +/* test2
> + *
> + * Sanity checking, attempt to reserve a surplus hugetlb page with
> + * a mempolicy.
> + */
> +static void test2(void) {
> +	reset_hugepages();
> +
> +	write_sysfs(nr_overcommit_hugepages_path, 1);
> +	per_thread_args[0].my_nodemask = nodemasks[0];
> +	per_thread_args[0].to_reserve = 1;
> +
> +	pthread_create(&threads[0], NULL, thread_work, &per_thread_args[0]);
> +
> +	usleep(500000);
> +
> +	get_hugepage_stats();
> +	ksft_test_result(g_free_hugepages == 1 && g_nr_hugepages == 1 &&
> +			 g_resv_hugepages == 1 && g_surplus_hugepages == 1 &&
> +			 n0_free_hugepages == 1 && n0_nr_hugepages == 1 &&
> +			 n0_surplus_hugepages == 1 && n1_free_hugepages == 0 &&
> +			 n1_nr_hugepages == 0 && n1_surplus_hugepages == 0,
> +			 "Reserve 1 surplus hugepage on node0\n");
> +
> +	wake_children();
> +	pthread_join(threads[0], NULL);
> +	wake_cond = 0;
> +	reset_hugepages();
> +}
> +
> +/* test3
> + *
> + * Set a static hugepage and reserve off node
> + */
> +static void test3(void) {
> +	reset_hugepages();
> +
> +	write_sysfs(nr_overcommit_hugepages_path, 1);
> +	write_sysfs(n0_nr_hugepages_path, 1);
> +
> +	per_thread_args[0].my_nodemask = nodemasks[0];
> +	per_thread_args[0].to_reserve = 0;
> +	per_thread_args[1].my_nodemask = nodemasks[1];
> +	per_thread_args[1].to_reserve = 1;
> +
> +	pthread_create(&threads[0], NULL, thread_work, &per_thread_args[0]);
> +	pthread_create(&threads[1], NULL, thread_work, &per_thread_args[1]);
> +
> +	usleep(500000);
> +
> +	get_hugepage_stats();
> +	ksft_test_result(g_free_hugepages == 2 && g_nr_hugepages == 2 &&
> +			 g_resv_hugepages == 1 && g_surplus_hugepages == 1 &&
> +			 n0_free_hugepages == 1 && n0_nr_hugepages == 1 &&
> +			 n0_surplus_hugepages == 0 && n1_free_hugepages == 1 &&
> +			 n1_nr_hugepages == 1 && n1_surplus_hugepages == 1,
> +			 "Set 1 static hugepage on node0, reserve surplus hugepage on node 1\n");
> +
> +	wake_children();
> +	pthread_join(threads[0], NULL);
> +	pthread_join(threads[1], NULL);
> +	wake_cond = 0;
> +	reset_hugepages();
> +}
> +
> +/* test4
> + *
> + * Reserve static hugepage on node0, reserve surplus hugepage on node1
> + */
> +static void test4(void) {
> +	reset_hugepages();
> +
> +	write_sysfs(nr_overcommit_hugepages_path, 1);
> +	write_sysfs(n0_nr_hugepages_path, 1);
> +
> +	per_thread_args[0].my_nodemask = nodemasks[0];
> +	per_thread_args[0].to_reserve = 1;
> +	per_thread_args[1].my_nodemask = nodemasks[1];
> +	per_thread_args[1].to_reserve = 1;
> +
> +	pthread_create(&threads[0], NULL, thread_work, &per_thread_args[0]);
> +	pthread_create(&threads[1], NULL, thread_work, &per_thread_args[1]);
> +
> +	usleep(500000);
> +
> +	get_hugepage_stats();
> +	ksft_test_result(g_free_hugepages == 2 && g_nr_hugepages == 2 &&
> +			 g_resv_hugepages == 2 && g_surplus_hugepages == 1 &&
> +			 n0_free_hugepages == 1 && n0_nr_hugepages == 1 &&
> +			 n0_surplus_hugepages == 0 && n1_free_hugepages == 1 &&
> +			 n1_nr_hugepages == 1 && n1_surplus_hugepages == 1,
> +			 "Reserve 1 static hugepage on node0, reserve surplus hugepage on node 1\n");
> +
> +	wake_children();
> +	pthread_join(threads[0], NULL);
> +	pthread_join(threads[1], NULL);
> +	wake_cond = 0;
> +	reset_hugepages();
> +}
> +
> +/* test5
> + *
> + * Reserve static hugepage on node0, reserve surplus hugepage on node1 and
> + * fail to over allocate another.
> + */
> +static void test5(void) {
> +	reset_hugepages();
> +
> +	write_sysfs(nr_overcommit_hugepages_path, 1);
> +	write_sysfs(n0_nr_hugepages_path, 1);
> +
> +	per_thread_args[0].my_nodemask = nodemasks[0];
> +	per_thread_args[0].to_reserve = 1;
> +	per_thread_args[1].my_nodemask = nodemasks[1];
> +	per_thread_args[1].to_reserve = 2;
> +
> +	pthread_create(&threads[0], NULL, thread_work, &per_thread_args[0]);
> +	pthread_create(&threads[1], NULL, thread_work, &per_thread_args[1]);
> +
> +	usleep(500000);
> +
> +	get_hugepage_stats();
> +	ksft_test_result(g_free_hugepages == 2 && g_nr_hugepages == 2 &&
> +			 g_resv_hugepages == 2 && g_surplus_hugepages == 1 &&
> +			 n0_free_hugepages == 1 && n0_nr_hugepages == 1 &&
> +			 n0_surplus_hugepages == 0 && n1_free_hugepages == 1 &&
> +			 n1_nr_hugepages == 1 && n1_surplus_hugepages == 1,
> +			 "Intentionally overallocate and fail due to nr_overcommit_hugepages limit.\n");
> +
> +	wake_children();
> +	pthread_join(threads[0], NULL);
> +	pthread_join(threads[1], NULL);
> +	wake_cond = 0;
> +	reset_hugepages();
> +
> +}
> +
> +int main(void) {
> +	ksft_print_header();
> +	ksft_set_plan(5);
> +
> +	check_requirements();
> +	setup_threads();
> +	setup_node_info();
> +	setup_paths();
> +	save_hugepage_configs();
> +
> +	test1();
> +	test2();
> +	test3();
> +	test4();
> +	test5();
> +
> +	restore_hugepage_configs();
> +	ksft_finished();
> +}
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index c17b133a81..cd368ce590 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -297,6 +297,7 @@ CATEGORY="hugetlb" run_test ./hugepage-mremap
>  CATEGORY="hugetlb" run_test ./hugepage-vmemmap
>  CATEGORY="hugetlb" run_test ./hugetlb-madvise
>  CATEGORY="hugetlb" run_test ./hugetlb_dio
> +CATEGORY="hugetlb" run_test ./hugetlb_surplus_mempolicy
>  
>  if [ "${HAVE_HUGEPAGES}" = "1" ]; then
>  	nr_hugepages_tmp=$(cat /proc/sys/vm/nr_hugepages)
> -- 
> 2.54.0
> 
> 

