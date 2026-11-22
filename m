Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 892D0606A684
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 16:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Br567cU7
Received: by kanga.kvack.org (Postfix)
	id 95F5A6B05B9; Sun, 22 Nov 2026 11:52:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 936CD6B05BA; Sun, 22 Nov 2026 11:52:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84D156B05BB; Sun, 22 Nov 2026 11:52:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 57B6C6B05B9
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 11:52:44 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB6191206F2
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:52:43 +0000 (UTC)
X-FDA: 85463349006.29.56CC4B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id DD2F9140007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:52:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Br567cU7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795366362;
	b=OBbLwThu/0u5Z8i5VLJaQXlu0HIzcqdupBWstBbexOPw1ku4Xxn78aZkYcGJAUXTLSArTz
	+rPIqK7mRmkzH6VY91ceflkRs6Q6QzGKh42DjibTUpM6D61bw7p7yHW1hMO6Xz56kJgZDx
	fCGCUpRp1lV96Hnp7U1L9OR9BScSmWc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795366362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1NKjBPa3Mm7e007sBCfL+8iXNhsADEsxbBCKLGqTb2o=;
	b=ipo5u0TX8qS0o4Pia+yePJO4XHYxOZ8SC1eaBWQ/sOTCo1dY+pPVSwv5E4iMz1ufb3tSx7
	KKINjPCmGARHCgRnj8148biULiDSYUuPs/u8QdF+3459Bd9oWV8oqgF4KxZVRvN8oL5dzK
	yf6ol9MRyEljoVLoAtNdDAIzxyiCQ/g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Br567cU7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 196F440B87;
	Sun, 22 Nov 2026 16:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2961F000C4;
	Sun, 22 Nov 2026 16:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795366360;
	bh=1NKjBPa3Mm7e007sBCfL+8iXNhsADEsxbBCKLGqTb2o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Br567cU7i2EIc01fZQxF9CCJuMpkTBy7lv8Y7WoZ/xz5Kzw1Fh1Dnig7L+ZGOxarG
	 BsleFmUduEVXp9CJsQgZhFbg00Dm4y5+2K5JpSuX8VYVuXXtQauNeRx8ZKnUwl+n+o
	 13xquQXDfYAijo3MRpGVTssouCha+sDjPFYn6tSDEpP5u/p/Qno5mgwLW3SlfRA7J4
	 z3bH2DtD/MRyZG8/ZmaK9xu+EBfyabZUt5eLs6DVg+Sgm2TuzcmJaQ6Emr+JC3D0Dd
	 6rhnRwcQiNIrkdXBySVgEVNwV3/zbXJ2FlwcFJyzZY5ZQ8n+JBby2ZUoz0HtE09nfg
	 9VTxaELeRQ0Dg==
Message-ID: <c02a4f0a-7790-4949-9037-b346ffbe3921@kernel.org>
Date: Sun, 22 Nov 2026 17:52:32 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/4] selftests/mm: test fork of PMD-mapped shmem THPs
To: Konstantin Khorenko <khorenko@virtuozzo.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
 =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
References: <20261119-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v6-0-efa7817a2bb3@virtuozzo.com>
 <20261119-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v6-4-efa7817a2bb3@virtuozzo.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261119-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v6-4-efa7817a2bb3@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DD2F9140007
X-Stat-Signature: ofy7rt61p68c6n9hwma6azfgsj1yudxy
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795366361-846139
X-HE-Meta: U2FsdGVkX1/S+m4UMcUy46wmsKse1FoDq0DuxaV5OF5mDUwgPYwG6NaBcOkAkbjoghqlSRj3XfF0NlHrBPYzNfq6nTtbO7VAZi+/MQ3CzeV5u09I41iLKT07c2xjI5Fo/liPwMW1ErjAkZ4PKcueK0nItRwuMpWi8niC1IspemH9pPQJ6FHux2i3VvBjdO4st31CRQF5D8m38imqZfvL5WT4R8sA8YvuW45f0bkwn4KQBW4G5h0psVzFinXT65GUwnq99mDgVZ8YK3rR1ROYYNEncJ3PkoGpfofsyVCmnTowflIwODlSjIlttCUmo1snaQrgME+nhfJIz/VXlOMJRVxmQ0zNMmo92IxrtkZc07E8q8QwQLf1uayAcvCalfmV4EjtURoQx3qYZLlpG8V4awWszPxfd3fLHgqVpW65/bFNaDtpJm9qvNC6xnif4DptmhF/xOExwktj0IVvC90p/KsBAnVWzExTV4vu2N6HCRlYuBt2cq/c6cy+tRE61DJ/S3aWD6rQPscsAJnaicUbRlJiZKcoVd6vCzTCXJQgj5mPKGcLGVzY7ASqIwHbcBqqN3Ue4iPWpea/AHTLtMenHehGkUkWSMZcyInNeY/XECHBaEsic36c4MXUftw+gxraGa+qOY3fQrYB/c9Z7QMenV9kAHrjuk7M7GG9a04cc750mx6HfC/JrJRLalPGVx9Dho7NAVH7CeYJqZUXEtjwP3rwnEhARRaQDQWhmn5CoDXWNm/Mu0ez5f0lqajBWB0ejEpKUEIJHn6FVquj6CEt3hKwBn5Cb8eVPaYrrWEm3yXi8Di6HEFOy24szLNNXYgOEGIZOifGkVj1drgWXDT8VMFKO8t3uTdgP146uFPesxkBgwW0NuQJoOV1ZJQvZyAkGMu8HBwRIVRIxOZVk0KRm+DYu2dGXxF1guhkP/OQtYDGO2O1Tsdeeg97c2wMqxxK2NkBvF3MzcVwReaYT09
 3tht41gl
 FRDq5jNCWfORsSbKRkUboKi7XCxIrZLQb1c20At1JY41+GTfoxKVqprEaNmk/qj1cDFlwdPTjd8PyzAnv+L7QHrwcixVCDM7ptSvvj5h2yWky6Nvr2n4lJ1728EO9bmy+yIeH58Lto+7JaNx650FB6/dK7gwrif8VNp3Mt0ykd7+ErBDmOinuVi8tNI1PYWXcw4OJqztyxFfL+dIbtNOdq1US6j9lIyWA29YjmAY7zSSxNbjpxcEi/RXfBfku/AH8spY3555QcRwD/azFB88JS6Q8OYYAhPEWdNHAUBbblrYIa+QnYJ7qV9fO76mlPZHSSbX8FzFPaS1BSut3jKuo+uh+rI8ON5CzP2zT6EowBR9CJI4PHnsv4N0kw8IP4fUXPwLtfygzCM+7xUx1tKSHAjbEIQAdpnau41wrpukQFYM+yz8ID+Y7ggRndI1orrOPCsmGHF34Mm3ODVVkagSR4t86DLj3RYIlVgsLsVBAURWoLbYcb6X3NRyIgABeW7FZnLMhTHcIXarzQNugETmSL+Ra4itOCOIVSExBnszM0TpAsfbLSxBkKEx87Q7+ex67HsI6SbOtgBjiTbQmCJ9a9AoiIBIpPKixEQbpG3YMlGyX37AyClkvsUpzWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 14:44, Konstantin Khorenko wrote:
> Fork a process that maps shmem THPs with PMDs, in a VMA whose page
> tables fork copies: a private mapping with an anon_vma, and a shared
> one with a guard region. The child must find the PMDs before it
> touches the mapping, and its exit must leave the parent's mapping and
> the system-wide ShmemPmdMapped counter as they were.
> 
> With folio_dup_file_rmap_pmd() adding PTE mappings, the child's exit
> takes the parent's share off ShmemPmdMapped while the parent still maps
> the folios. Unmapping them drops it once more, so every mapping stays
> until exit, where the kernel reports "Bad page cache", or hits a
> VM_BUG_ON with CONFIG_DEBUG_VM. A kernel that leaves file THPs to a
> refault in the child skips the test.
> 
> ShmemPmdMapped is system-wide, and reclaim or NUMA balancing can take a
> PMD from the parent while the test runs. So the test makes up to three
> attempts, each on a fresh file, and fails only if all of them see the
> counter drop by exactly the parent's share: the bug does that on every
> fork, other processes only by chance. It passes on the first clean
> attempt and skips when none is clean.
> 
> The test mounts a tmpfs with huge=always over /tmp in a private mount
> namespace, so it leaves the THP settings and the host's mounts and
> files alone.
> 
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---
>  MAINTAINERS                                |   1 +
>  tools/testing/selftests/mm/Makefile        |   1 +
>  tools/testing/selftests/mm/fork_file_thp.c | 256 +++++++++++++++++++++++++++++
>  tools/testing/selftests/mm/run_vmtests.sh  |   1 +
>  4 files changed, 259 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d738990161bd0..7ade132e3d3ab 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17941,6 +17941,7 @@ F:	mm/huge_memory.c
>  F:	mm/khugepaged.c
>  F:	mm/mm_slot.h
>  F:	tools/mm/thpmaps
> +F:	tools/testing/selftests/mm/fork_file_thp.c
>  F:	tools/testing/selftests/mm/khugepaged.c
>  F:	tools/testing/selftests/mm/split_huge_page_test.c
>  F:	tools/testing/selftests/mm/transhuge-stress.c
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index 0ea72e9979347..2489027b2a36b 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -108,6 +108,7 @@ TEST_GEN_FILES += folio_split_race_test
>  TEST_GEN_FILES += folio_order_check
>  TEST_GEN_FILES += khugepaged_sync_check
>  TEST_GEN_FILES += khugepaged_race
> +TEST_GEN_FILES += fork_file_thp
>  TEST_GEN_FILES += soft-dirty
>  
>  ifeq ($(ARCH),x86_64)
> diff --git a/tools/testing/selftests/mm/fork_file_thp.c b/tools/testing/selftests/mm/fork_file_thp.c
> new file mode 100644
> index 0000000000000..aaecf7ba6f406
> --- /dev/null
> +++ b/tools/testing/selftests/mm/fork_file_thp.c
> @@ -0,0 +1,256 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * fork() of a process that maps shmem THPs with PMDs, in a VMA whose page
> + * tables fork copies: a private mapping with an anon_vma, and a shared
> + * mapping with a guard region.
> + *
> + * The child must get the PMDs without faulting, and its exit must leave the
> + * parent's mapping and the system-wide ShmemPmdMapped counter as they were.
> + * Kernels that leave file THPs to a refault in the child skip the test.
> + */
> +#define _GNU_SOURCE
> +#include <asm-generic/mman.h> /* Force the import of the tools version. */
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <stdbool.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <sched.h>
> +#include <sys/mman.h>
> +#include <sys/mount.h>
> +#include <sys/wait.h>
> +
> +#include "kselftest.h"
> +#include "vm_util.h"
> +
> +#define NR_PMDS		4
> +#define MAX_PMDSIZE	(32UL << 20)
> +/* Other processes, reclaim and NUMA balancing can disturb an attempt. */
> +#define ATTEMPTS	3
> +
> +static size_t pagesize, pmdsize, size;
> +
> +static long meminfo_kb(const char *key)
> +{
> +	char line[256];
> +	long kb = -1;
> +	FILE *f = fopen("/proc/meminfo", "r");
> +
> +	if (!f)
> +		return -1;
> +	while (fgets(line, sizeof(line), f))
> +		if (!strncmp(line, key, strlen(key))) {
> +			kb = strtol(line + strlen(key), NULL, 10);
> +			break;
> +		}
> +	fclose(f);
> +	return kb;
> +}
> +
> +/* Skips the last page, which may be a guard page, and @skip. */
> +static bool data_ok(const char *mem, size_t skip)
> +{
> +	size_t off;
> +
> +	for (off = 0; off < size - pagesize; off += pagesize)
> +		if (off != skip && mem[off] != (char)(off / pmdsize + 1))
> +			return false;
> +	return true;
> +}
> +
> +/* The last PMD is zapped by the setup, the others must be PMD-mapped. */
> +static bool pmds_ok(char *mem)
> +{
> +	return check_huge_file(mem, size - pmdsize, NR_PMDS - 1, pmdsize);
> +}
> +
> +/* Maps a fresh shmem file of NR_PMDS PMDs, PMD-aligned, until exit. */
> +static char *map_file(bool shared)
> +{
> +	char *area, *buf, *mem;
> +	size_t off;
> +	int fd;
> +
> +	fd = open("/tmp/fork_file_thp", O_RDWR | O_CREAT | O_TRUNC, 0600);
> +	if (fd < 0)
> +		ksft_exit_fail_perror("open");
> +	unlink("/tmp/fork_file_thp");
> +	buf = malloc(pmdsize);
> +	if (!buf)
> +		ksft_exit_fail_msg("malloc failed\n");
> +	for (off = 0; off < size; off += pmdsize) {
> +		memset(buf, off / pmdsize + 1, pmdsize);
> +		if (pwrite(fd, buf, pmdsize, off) != (ssize_t)pmdsize)
> +			ksft_exit_fail_perror("pwrite");
> +	}
> +	free(buf);
> +
> +	area = mmap(NULL, size + pmdsize, PROT_NONE,
> +		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	if (area == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
> +	mem = (char *)(((unsigned long)area + pmdsize - 1) & ~(pmdsize - 1));
> +	mem = mmap(mem, size, PROT_READ | PROT_WRITE,
> +		   (shared ? MAP_SHARED : MAP_PRIVATE) | MAP_FIXED, fd, 0);
> +	if (mem == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
> +	close(fd);
> +	for (off = 0; off < size; off += pmdsize)
> +		FORCE_READ(mem[off]);
> +	return mem;
> +}
> +
> +/* Child exit codes, apart from what kselftest helpers exit with. */
> +enum result { PASS, NO_PMDS = 10, FAIL_DATA, FAIL_COUNTER, FAIL_PARENT,
> +	      FAIL_KILLED, COUNTER_OFF, CHANGED, LOST_PMDS, NO_THP };
> +
> +static enum result fork_once(char *mem, bool shared, long *before, long *after)
> +{
> +	/* The parent alone maps this much with PMDs. */
> +	long own = (NR_PMDS - 1) * (pmdsize >> 10);
> +	bool parent_pmds;
> +	int status;
> +	pid_t pid;
> +
> +	*before = *after = meminfo_kb("ShmemPmdMapped:");

That's not how we test for PMD mappings from other code.

We have check_huge_file() etc helpers in vm_util.c for that.


Further, some things look a bit odd, like:

+static void test_fork(bool shared)
+{
+	const char *desc = shared ? "shared mapping with a guard region" :
+				    "private mapping with an anon_vma";

Why guard regions? Why boolean parameters?

This selftest should probably be written using the kselftest harness instead.

BUT I am not convinced the selftest as is is worth it. It check for too too
detailed corner cases.

I think we'd want something fairly simple, nothing the does detailed accounting
checks.

I'll queue 1-3 for now, thanks!

-- 
Cheers,

David

