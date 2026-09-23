Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E99E9C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 14:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0755E6B0093; Wed, 23 Sep 2026 10:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 025D66B0095; Wed, 23 Sep 2026 10:26:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E306D6B0096; Wed, 23 Sep 2026 10:26:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B53E26B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:26:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4275EA6C51
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:26:15 +0000 (UTC)
X-FDA: 85245251910.27.AB7B1DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 86DB6100009
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:26:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hXVJrT0H;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790173573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7bfQKGBVRp+Kvg//l3oRWHMHkGwpoO6mCLlsey6WE+I=;
	b=7lJL+Gp/apxujvumG4OiqgKLlPMNeMKCUJZ/YZOHGeqJKDS1QwrUs1gkxACYRrfketeo67
	G/0CfzwpH342DNE6S7e026Ijb2Kcp61ytcz4N/z97IT5YcM0r/XaNMjF3zI6eWmXVjYrLN
	8J77DF4UKBzE39jeGUMegC3O0qIgIjU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790173573;
	b=ymgGELocsxMLNLFPBR+faQMYGfBZINlENC5RvU7vMhw89QVSF2xTkgzdmt5s3hohDe3Vtz
	O6PFku2m2rKMJsMTbnzFlVo9PFFJz609+5xWNpZG7NsSZS0Xf/RjGa9rQH1pkgtSsrLyXG
	vustTEDOS95t6ROMOYujEPlv5Hitknc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hXVJrT0H;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A6B7060210;
	Wed, 23 Sep 2026 14:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C981F000FF;
	Wed, 23 Sep 2026 14:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790173572;
	bh=7bfQKGBVRp+Kvg//l3oRWHMHkGwpoO6mCLlsey6WE+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hXVJrT0HJfuqUrb65DzbVQzRBaJaFuZIHrxRlciBc2RfN/XiXdKHV+q0SObKF8IZ7
	 x3mJMLwvH1smwpMGUQPRD172uwdSyfe6zosJlpG3gf+b+UL44vuxyQyhSXAFqrYDVp
	 DuCCIlsNTJggzKFGmLNOb0oEIWF3peWl35W4rjN7vdrJ0o+LTmMHrggxTKrITzE7hK
	 8oYKBiRpbug6wfCutu8q6gAiHkNwhaNoLooislXRNHyTqwIaJ/6ZfS7ZTzf4P44BKp
	 ZAKffJqfrrEp2EnxJ7hLrFs9Su4EHgbaLP9JhIA3rGd4f7gBZwyQoe0RfZGQDn3B0+
	 TU8EG7pQxXMLw==
Date: Wed, 23 Sep 2026 15:26:05 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	liam@infradead.org, david@kernel.org, vbabka@kernel.org, jannh@google.com, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Subject: Re: [PATCH 01/10] selftests/mm: exercise MADV_COLD and MADV_PAGEOUT
Message-ID: <arPgwegm8XgbEUrO@gremlin>
References: <20260922235830.2350770-1-gourry@gourry.net>
 <20260922235830.2350770-2-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922235830.2350770-2-gourry@gourry.net>
X-Rspam-User: 
X-Stat-Signature: mkn18qshe3ioun6f8amup1w776zkcsho
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 86DB6100009
X-HE-Tag: 1790173573-123908
X-HE-Meta: U2FsdGVkX19y3G/sZ/QVmPnFyhCxxx9PD5YfYK3LeHHGK74wvbmSofpasvPtHItH4KPV+yKM08wwfgm8TDqpyGkyazO/EXPO8D5bBMH12isAWwZENoSkS2eNYXHFUdD/rL42jpegffVqS27ZUgZqKOklSsRjUu29/Tv8N2xZChkRsZworQNZMT3VujsowHFRT3NYqjJmes/ff559x7b3gFS7eE+JGqjY3O/skkc2VooQk8j6RcFYuCiqePzCdft+7dHsZMX/wxCKUOrnwqLI/xUnlwU3SZEANqEbyL3Ftj2o73jAGzWv/5wmzIxUvj5UsuEUImHbbZmhQz/8TnFvvMOQ9DcIJ0qgpWbOUUaOV+IpRlSxnoHgfo1SRu++Av0r7o6pYvIjshHhz2oLCCnbebulPSVct84UKypxc3paK153nTkISLAJfXkmT+/+8gn0mAoYV0C1A2aR7YFaAd8wXeGk9z7AztWg3V3gx8mDuySiBzrjYbDTgRVQDT+Oc4FsQRpJYC3u5E5F7yxwXjg5o31tHKngiZiXoM8liau4xwHt1r5NAJIozdgF0cGftBlAjHpVmnfpSKV1rS9XKmsR9wbs+Uy0BNy38XVLyPdXUbH31qToqNYdXnae+r6BZWAIomPzruGsWd2iEcE1XY7n1QHELzlUdqii4dznUvHPTtJPG5ZozunrvLUPsQdvtoeY+ESMs6Xy5MXEwSOHKTDnqTgex648gJqVuF/tPzjcXZ+G8hwYeh0MMvlU2Vd5gjrKN4fR8UYsVkQVV1Yz1MDc0RF6vR+QuWS8KxThlMH9TjVUE96WHHcD+5MCCqW3ljmZ2/LBBWAu7DYvFbdicsn/wT6MYvMCAV2O7DYWFS773528JgFgoKNFcEl0jdDHhXYEd2DIrd9+9TP9hsmzzm3HPSAVDJU+Ga93+FC+xT1Je+AEGwNZhTXD5xaDfs623WO5t161Ikhg4nVAImHrFBA
 CZLahnrw
 iKiTZ6O8xMD2eBxZgwx7iKiU7N5t1AXtpS2VOdugcONgxfUUpbGR3bhDuNaSu9AmSTK4X3LdpXmGWTYTsXg/l/VdVHbUudZkiOrKzbXW5Rm4ypqbW72yUhVOtKzwEWqelNPZfSwuTSKcmDy6LhCLeMBdTGgNZSe7vHvel/ptEoAG2xB0z0tumJNAAwHHC9D2e4L0G1alGaYVqHch/3mnqJjuul3RhC1pbNJYzLu9EaYQkOzm3kQ5ctcDAbKh9D4595Lc1n4EGF2HIFHULaz4r4xmEzlyocojo3yGX97SXhf15Z9490Vsd09HDgmiV2auiLp1J7SUd+c618JJ/lswmtFmfrIPVGtfX6XJJhEHtMrczVEQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 07:58:21PM -0400, Gregory Price wrote:
> MADV_COLD and MADV_PAGEOUT share a page-table walker covering ordinary
> PTEs, PTE-mapped large folios and huge PMDs. Existing selftests provide
> little coverage of its range, folio-state and permission decisions.
>
> Add 28 cases ahead of a planned walker refactor. All cases check syscall
> results and mapping contents, but they deliberately have different review
> contracts.

Yikes that's a lot! :)

>
> This commit was originally 28 individual commits, but was squashed for
> the initial RFC to limit noise during initial review. The question is
> what set of self-tests should retain.
>
> The eight user-visible contract tests verify:
>
>   - MADV_COLD does not populate a PTE hole;
>   - COLD and PAGEOUT reject a locked VMA;
>   - full-range PAGEOUT swaps a PMD-mapped THP without corrupting it;
>   - MADV_COLD does not fault in a swapped PTE;
>   - PAGEOUT preserves an unevictable base page;
>   - authorized file PAGEOUT evicts a clean file page;
>   - unauthorized shared-file PAGEOUT leaves the page resident; and
>   - private-file PAGEOUT reclaims a COW page but preserves a file page.
>
> The eighteen implementation-detail tests record the current folio and
> page-table behavior:
>
>   - full and partial MADV_COLD on a PTE-mapped THP;
>   - full, repeated and partial MADV_COLD on PMD-mapped THPs;
>   - MADV_COLD on the shared zero page and huge zero page;
>   - partial MADV_COLD on a shared PMD-mapped THP;
>   - partial MADV_COLD on pinned PMD- and PTE-mapped THPs;
>   - parallel partial MADV_COLD split attempts;
>   - PAGEOUT on an unevictable THP;
>   - MADV_COLD on active base-page and huge-PMD folios;
>   - partial PAGEOUT on PMD- and PTE-mapped THPs;
>   - partial and full MADV_COLD on shared PTE-mapped THPs; and
>   - PAGEOUT filtering of a PMD-sized protected file folio.
>
> These tests intentionally assert splitting, PMD/PTE mapping shape, folio
> flags or folio sharing. They may need adjustment after a valid kernel
> implementation change. Their purpose here is to detect unintended changes
> during the refactor.
>
> Two additional stress tests use implementation-specific setup while keeping
> contract-level assertions:
>
>   - MADV_COLD on a folio still queued in another CPU's LRU batch
>   - MADV_PAGEOUT during NUMA migration of unevictable shmem THPs.
>
> The stress tests require only successful calls and preserved contents.
> They do not assert which internal path won. Tests requiring root, swap,
> THP allocation, multiple CPUs or NUMA nodes report a skip when their
> prerequisites are unavailable.

I think in general we want to avoid putting stress tests as part of the
selftests in general? Or at least if they might take a long time to run or
excessive memory usage, etc.

Though that might be benchmarks, as we have the THP stress tests so maybe it's
OK?

>
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

In any case I really do think this should be split out into smaller parts, this
is a _gigantic_ change :)

Since you list a whole bunch of different test areas and you're exercising
different things you should be able to split this out logically across those I
think?

I like the idea of establishing some sort of invariants first before
implementing changes though in general.

> ---
>  tools/testing/selftests/mm/Makefile        |    2 +
>  tools/testing/selftests/mm/ksft_madvise.sh |    4 +
>  tools/testing/selftests/mm/madvise.c       | 1673 ++++++++++++++++++++
>  tools/testing/selftests/mm/run_vmtests.sh  |    5 +
>  tools/testing/selftests/mm/vm_util.c       |    4 +-
>  tools/testing/selftests/mm/vm_util.h       |    6 +
>  6 files changed, 1692 insertions(+), 2 deletions(-)
>  create mode 100755 tools/testing/selftests/mm/ksft_madvise.sh
>  create mode 100644 tools/testing/selftests/mm/madvise.c
>
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index beacc0f873049..8912aa85ca273 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -69,6 +69,7 @@ TEST_GEN_FILES += hugetlb-shm
>  TEST_GEN_FILES += hugetlb-soft-offline
>  TEST_GEN_FILES += khugepaged
>  TEST_GEN_FILES += madv_populate
> +TEST_GEN_FILES += madvise
>  TEST_GEN_FILES += map_fixed_noreplace
>  TEST_GEN_FILES += map_populate
>  ifneq (,$(filter $(ARCH),arm64 riscv riscv64 x86 x86_64 loongarch32 loongarch64))
> @@ -155,6 +156,7 @@ TEST_PROGS += ksft_kmemleak_dedup.sh
>  TEST_PROGS += ksft_ksm.sh
>  TEST_PROGS += ksft_ksm_numa.sh
>  TEST_PROGS += ksft_madv_guard.sh
> +TEST_PROGS += ksft_madvise.sh
>  TEST_PROGS += ksft_madv_populate.sh
>  TEST_PROGS += ksft_memfd_secret.sh
>  TEST_PROGS += ksft_memory_failure.sh
> diff --git a/tools/testing/selftests/mm/ksft_madvise.sh b/tools/testing/selftests/mm/ksft_madvise.sh
> new file mode 100755
> index 0000000000000..29cbbca800f2c
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_madvise.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t madvise
> diff --git a/tools/testing/selftests/mm/madvise.c b/tools/testing/selftests/mm/madvise.c
> new file mode 100644
> index 0000000000000..abde0b1c8a42e
> --- /dev/null
> +++ b/tools/testing/selftests/mm/madvise.c
> @@ -0,0 +1,1673 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <pthread.h>
> +#include <sched.h>
> +#include <stdbool.h>
> +#include <stdatomic.h>
> +#include <stdint.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <linux/mman.h>
> +#include <linux/mempolicy.h>
> +#include <sys/ipc.h>
> +#include <sys/mman.h>
> +#include <sys/shm.h>
> +#include <sys/stat.h>
> +#include <sys/syscall.h>
> +#include <sys/uio.h>
> +#include <sys/wait.h>
> +#include <unistd.h>
> +
> +#include "kselftest.h"
> +#include "vm_util.h"
> +
> +#ifndef MADV_COLLAPSE
> +#define MADV_COLLAPSE 25
> +#endif
> +
> +#define NR_CONCURRENT_THREADS 8
> +#define NR_CONCURRENT_THPS 8
> +#define NR_CONCURRENT_ROUNDS 400
> +#define NR_MIGRATION_RACE_THPS 16
> +#define NR_MIGRATION_RACE_ROUNDS 20
> +#define NUMA_MASK_BITS 1024
> +#define NUMA_MASK_LONGS (NUMA_MASK_BITS / (8 * sizeof(unsigned long)))
> +
> +static pthread_barrier_t concurrent_start_barrier;
> +static pthread_barrier_t concurrent_done_barrier;
> +static atomic_int concurrent_worker_errno;
> +static char *concurrent_area;
> +static size_t pmd_size;
> +
> +#if defined(SYS_get_mempolicy) && defined(SYS_mbind) && \
> +	defined(SYS_migrate_pages)
> +struct migration_pageout_data {
> +	pthread_barrier_t start_barrier;
> +	atomic_bool stop;
> +	atomic_int calls;
> +	atomic_int error;
> +	char *mapping;
> +	size_t size;
> +};
> +
> +static bool find_two_memory_nodes(unsigned long *mask, int *node1, int *node2)
> +{
> +	int node;
> +
> +	if (syscall(SYS_get_mempolicy, NULL, mask, NUMA_MASK_BITS + 1, NULL,
> +		    MPOL_F_MEMS_ALLOWED))
> +		return false;
> +
> +	*node1 = *node2 = -1;
> +	for (node = 0; node < NUMA_MASK_BITS; node++) {
> +		if (!(mask[node / (8 * sizeof(*mask))] &
> +		      (1UL << (node % (8 * sizeof(*mask))))))
> +			continue;
> +		if (*node1 < 0) {
> +			*node1 = node;
> +		} else {
> +			*node2 = node;
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
> +static void numa_mask_set(unsigned long *mask, int node)
> +{
> +	mask[node / (8 * sizeof(*mask))] |=
> +		1UL << (node % (8 * sizeof(*mask)));
> +}
> +
> +static void *madvise_pageout_worker(void *arg)
> +{
> +	struct migration_pageout_data *data = arg;
> +
> +	pthread_barrier_wait(&data->start_barrier);
> +	while (!atomic_load_explicit(&data->stop, memory_order_relaxed)) {
> +		if (madvise(data->mapping, data->size, MADV_PAGEOUT) &&
> +		    errno != EAGAIN) {
> +			atomic_store(&data->error, errno);
> +			break;
> +		}
> +		atomic_fetch_add(&data->calls, 1);
> +	}
> +
> +	return NULL;
> +}
> +
> +static int migrate_between_nodes(unsigned long *old_nodes,
> +				 unsigned long *new_nodes)
> +{
> +	int i;
> +
> +	for (i = 0; i < NR_MIGRATION_RACE_ROUNDS; i++) {
> +		unsigned long *tmp;
> +
> +		if (syscall(SYS_migrate_pages, 0, NUMA_MASK_BITS + 1,
> +			    old_nodes, new_nodes) < 0)
> +			return errno;
> +		tmp = old_nodes;
> +		old_nodes = new_nodes;
> +		new_nodes = tmp;
> +	}
> +
> +	return 0;
> +}
> +
> +static int race_pageout_with_migration(char *mapping, size_t size,
> +				       unsigned long *mask1,
> +				       unsigned long *mask2)
> +{
> +	struct migration_pageout_data data = {
> +		.mapping = mapping,
> +		.size = size,
> +	};
> +	pthread_t thread;
> +	int ret;
> +
> +	ret = pthread_barrier_init(&data.start_barrier, NULL, 2);
> +	if (ret)
> +		return ret;
> +	ret = pthread_create(&thread, NULL, madvise_pageout_worker, &data);
> +	if (ret) {
> +		pthread_barrier_destroy(&data.start_barrier);
> +		return ret;
> +	}
> +	pthread_barrier_wait(&data.start_barrier);
> +
> +	ret = migrate_between_nodes(mask1, mask2);
> +	atomic_store(&data.stop, true);
> +	pthread_join(thread, NULL);
> +	pthread_barrier_destroy(&data.start_barrier);
> +
> +	if (ret)
> +		return ret;
> +	if (atomic_load(&data.error))
> +		return atomic_load(&data.error);
> +	return atomic_load(&data.calls) ? 0 : EIO;
> +}
> +#endif
> +
> +static char *map_aligned_pages(size_t size)
> +{
> +	char *mapping, *aligned;
> +
> +	mapping = mmap(NULL, size + pmd_size, PROT_READ | PROT_WRITE,
> +		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	if (mapping == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
> +
> +	aligned = (char *)(((uintptr_t)mapping + pmd_size - 1) &
> +			   ~(pmd_size - 1));
> +	if (aligned != mapping)
> +		munmap(mapping, aligned - mapping);
> +	if (aligned + size < mapping + size + pmd_size)
> +		munmap(aligned + size,
> +		       mapping + size + pmd_size - (aligned + size));
> +
> +	memset(aligned, 1, size);
> +	return aligned;
> +}
> +
> +/* MADV_COLLAPSE may fail transiently with EAGAIN. */
> +static bool collapse_all(char *mapping, size_t size, int nr_hpages)
> +{
> +	int ret, retry;
> +
> +	for (retry = 0; retry < 10; retry++) {
> +		ret = madvise(mapping, size, MADV_COLLAPSE);
> +		if (!ret) {
> +			if (check_huge_anon(mapping, size, nr_hpages, pmd_size))
> +				return true;
> +		} else if (errno != EAGAIN) {
> +			return false;
> +		}
> +		usleep(10000);
> +	}
> +
> +	return false;
> +}
> +
> +static bool collapse_shmem(char *mapping, size_t size, int nr_hpages)
> +{
> +	int ret, retry;
> +
> +	for (retry = 0; retry < 10; retry++) {
> +		ret = madvise(mapping, size, MADV_COLLAPSE);
> +		if (!ret) {
> +			if (check_huge_shmem(mapping, size, nr_hpages, pmd_size))
> +				return true;
> +		} else if (errno != EAGAIN) {
> +			return false;
> +		}
> +		usleep(10000);
> +	}
> +
> +	return false;
> +}
> +
> +static char *map_unevictable_shmem(size_t size, int *shmid)
> +{
> +	char *reservation, *mapping, *aligned;
> +
> +	reservation = mmap(NULL, size + pmd_size, PROT_NONE,
> +			   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	if (reservation == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap reservation");
> +	aligned = (char *)(((uintptr_t)reservation + pmd_size - 1) &
> +			   ~(pmd_size - 1));
> +	munmap(reservation, size + pmd_size);
> +
> +	*shmid = shmget(IPC_PRIVATE, size, IPC_CREAT | 0600);
> +	if (*shmid < 0)
> +		ksft_exit_fail_perror("shmget");
> +	if (shmctl(*shmid, SHM_LOCK, NULL)) {
> +		shmctl(*shmid, IPC_RMID, NULL);
> +		ksft_test_result_skip("could not lock a shmem segment\n");
> +		return MAP_FAILED;
> +	}
> +	mapping = shmat(*shmid, aligned, 0);
> +	if (mapping == (void *)-1)
> +		ksft_exit_fail_perror("shmat");
> +	if (mapping != aligned)
> +		ksft_exit_fail_msg("shmat did not honor the aligned address\n");
> +
> +	return mapping;
> +}
> +
> +static void unmap_unevictable_shmem(char *mapping, int shmid)
> +{
> +	shmctl(shmid, SHM_UNLOCK, NULL);
> +	shmdt(mapping);
> +	shmctl(shmid, IPC_RMID, NULL);
> +}
> +
> +static char *map_aligned_file(int fd, size_t size, int flags)
> +{
> +	char *mapping, *aligned;
> +
> +	mapping = mmap(NULL, size + pmd_size, PROT_NONE,
> +		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	if (mapping == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap reservation");
> +	aligned = (char *)(((uintptr_t)mapping + pmd_size - 1) &
> +			   ~(pmd_size - 1));
> +	if (mmap(aligned, size, PROT_READ | PROT_WRITE, flags | MAP_FIXED,
> +		 fd, 0) == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap file");
> +	if (aligned != mapping)
> +		munmap(mapping, aligned - mapping);
> +	if (aligned + size < mapping + size + pmd_size)
> +		munmap(aligned + size,
> +		       mapping + size + pmd_size - (aligned + size));
> +
> +	return aligned;
> +}
> +
> +static void split_pmd_mapping(char *mapping)
> +{
> +	const size_t page_size = getpagesize();
> +
> +	if (mprotect(mapping + page_size, page_size, PROT_READ) ||
> +	    mprotect(mapping + page_size, page_size, PROT_READ | PROT_WRITE))
> +		ksft_exit_fail_perror("mprotect");
> +	if (!check_large_folios(mapping, pmd_size, 1, pmd_size))
> +		ksft_exit_fail_msg("mprotect split the physical THP\n");
> +}
> +
> +static void check_memory(char *mapping, size_t size)
> +{
> +	size_t offset;
> +
> +	for (offset = 0; offset < size; offset += getpagesize())
> +		if (mapping[offset] != 1)
> +			ksft_exit_fail_msg("memory changed at offset %zu\n", offset);
> +}
> +
> +/*
> + * MADV_COLD on a full PTE-mapped THP must preserve the folio, while an
> + * operation on only half of it must split the folio. Neither operation may
> + * alter the mapping contents.
> + */
> +static void test_pte_mapped_madvise_cold(void)
> +{
> +	char *mapping = map_aligned_pages(pmd_size);
> +
> +	if (!collapse_all(mapping, pmd_size, 1)) {
> +		munmap(mapping, pmd_size);
> +		ksft_test_result_skip("could not allocate a PMD-sized THP\n");
> +		return;
> +	}
> +
> +	split_pmd_mapping(mapping);
> +	if (madvise(mapping, pmd_size, MADV_COLD))
> +		ksft_exit_fail_perror("MADV_COLD");
> +	if (!check_large_folios(mapping, pmd_size, 1, pmd_size))
> +		ksft_exit_fail_msg("full MADV_COLD split a large folio\n");
> +
> +	if (madvise(mapping, pmd_size / 2, MADV_COLD))
> +		ksft_exit_fail_perror("MADV_COLD");
> +	if (!check_large_folios(mapping, pmd_size, 0, pmd_size))
> +		ksft_exit_fail_msg("partial MADV_COLD left a large folio\n");
> +	check_memory(mapping, pmd_size);
> +
> +	munmap(mapping, pmd_size);
> +	ksft_test_result_pass("MADV_COLD handles a PTE-mapped THP\n");
> +}
> +
> +/*
> + * A PTE walk must skip holes without populating them or overlooking the
> + * present pages on either side.
> + */
> +static void test_madvise_cold_pte_hole(void)
> +{
> +	const size_t page_size = getpagesize();
> +	const size_t size = 3 * page_size;
> +	char *mapping;
> +	int pagemap_fd;
> +
> +	mapping = mmap(NULL, size, PROT_READ | PROT_WRITE,
> +		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	if (mapping == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
> +	mapping[0] = 1;
> +	mapping[2 * page_size] = 1;
> +
> +	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +	if (pagemap_fd < 0)
> +		ksft_exit_fail_perror("open pagemap");
> +	if (pagemap_is_populated(pagemap_fd, mapping + page_size))
> +		ksft_exit_fail_msg("PTE hole was populated before MADV_COLD\n");
> +
> +	if (madvise(mapping, size, MADV_COLD))
> +		ksft_exit_fail_perror("MADV_COLD");
> +	if (mapping[0] != 1 || mapping[2 * page_size] != 1)
> +		ksft_exit_fail_msg("MADV_COLD changed populated pages\n");
> +	if (pagemap_is_populated(pagemap_fd, mapping + page_size))
> +		ksft_exit_fail_msg("MADV_COLD populated a PTE hole\n");
> +
> +	close(pagemap_fd);
> +	munmap(mapping, size);
> +	ksft_test_result_pass("MADV_COLD skips PTE holes\n");
> +}
> +
> +/*
> + * A read fault on private anonymous memory may install the shared zero page.
> + * MADV_COLD must ignore that special PTE without replacing it or changing the
> + * mapping contents.
> + */
> +static void test_madvise_cold_zero_page(void)
> +{
> +	const size_t page_size = getpagesize();
> +	char *mapping;
> +	int pagemap_fd;
> +
> +	mapping = mmap(NULL, page_size, PROT_READ,
> +		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	if (mapping == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
> +	if (mapping[0])
> +		ksft_exit_fail_msg("anonymous mapping is not zero-filled\n");
> +
> +	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +	if (pagemap_fd < 0)
> +		ksft_exit_fail_perror("open pagemap");
> +	if (!pagemap_is_populated(pagemap_fd, mapping))
> +		ksft_exit_fail_msg("zero page is not populated\n");
> +
> +	if (madvise(mapping, page_size, MADV_COLD))
> +		ksft_exit_fail_perror("MADV_COLD");
> +	if (mapping[0] || !pagemap_is_populated(pagemap_fd, mapping))
> +		ksft_exit_fail_msg("MADV_COLD changed the zero-page mapping\n");
> +
> +	close(pagemap_fd);
> +	munmap(mapping, page_size);
> +	ksft_test_result_pass("MADV_COLD skips the shared zero page\n");
> +}
> +
> +/*
> + * A read fault may map the shared huge zero page with a PMD. MADV_COLD must
> + * ignore that special PMD without replacing it or changing the mapping.
> + */
> +static void test_madvise_cold_huge_zero_page(void)
> +{
> +	char *reservation, *mapping;
> +	unsigned long pfn;
> +	uint64_t flags;
> +	int pagemap_fd, kpageflags_fd;
> +
> +	if (geteuid()) {
> +		ksft_test_result_skip("requires root to read page flags\n");
> +		return;
> +	}
> +	reservation = mmap(NULL, 2 * pmd_size, PROT_NONE,
> +			   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	if (reservation == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap reservation");
> +	mapping = (char *)(((uintptr_t)reservation + pmd_size - 1) &
> +			   ~(pmd_size - 1));
> +	if (mmap(mapping, pmd_size, PROT_READ,
> +		 MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0) == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap huge zero page");
> +	if (mapping != reservation)
> +		munmap(reservation, mapping - reservation);
> +	if (mapping + pmd_size < reservation + 2 * pmd_size)
> +		munmap(mapping + pmd_size,
> +		       reservation + 2 * pmd_size - (mapping + pmd_size));
> +	if (madvise(mapping, pmd_size, MADV_HUGEPAGE))
> +		ksft_exit_fail_perror("MADV_HUGEPAGE");
> +	if (mapping[0])
> +		ksft_exit_fail_msg("anonymous mapping is not zero-filled\n");
> +
> +	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +	kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
> +	if (pagemap_fd < 0 || kpageflags_fd < 0)
> +		ksft_exit_fail_perror("open page flags");
> +	pfn = pagemap_get_pfn(pagemap_fd, mapping);
> +	if (pfn == -1ul || pageflags_get(pfn, kpageflags_fd, &flags) ||
> +	    !(flags & KPF_ZERO_PAGE)) {
> +		close(kpageflags_fd);
> +		close(pagemap_fd);
> +		munmap(mapping, pmd_size);
> +		ksft_test_result_skip("huge zero page is not available\n");
> +		return;
> +	}
> +
> +	if (madvise(mapping, pmd_size, MADV_COLD))
> +		ksft_exit_fail_perror("MADV_COLD");
> +	if (mapping[0] || pagemap_get_pfn(pagemap_fd, mapping) != pfn)
> +		ksft_exit_fail_msg("MADV_COLD changed the huge-zero-page mapping\n");
> +
> +	close(kpageflags_fd);
> +	close(pagemap_fd);
> +	munmap(mapping, pmd_size);
> +	ksft_test_result_pass("MADV_COLD skips the huge zero page\n");
> +}
> +
> +/*
> + * Neither hint is valid for a locked VMA: reclaiming it would violate the
> + * mlock contract, and merely aging it would serve no purpose.
> + */
> +static void test_madvise_lru_locked_vma(void)
> +{
> +	const size_t page_size = getpagesize();
> +	char *mapping;
> +
> +	mapping = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
> +		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	if (mapping == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
> +	mapping[0] = 1;
> +	if (mlock(mapping, page_size)) {
> +		munmap(mapping, page_size);
> +		ksft_test_result_skip("could not lock a page\n");
> +		return;
> +	}
> +
> +	errno = 0;
> +	if (!madvise(mapping, page_size, MADV_COLD) || errno != EINVAL)
> +		ksft_exit_fail_msg("MADV_COLD accepted a locked VMA\n");
> +	errno = 0;
> +	if (!madvise(mapping, page_size, MADV_PAGEOUT) || errno != EINVAL)
> +		ksft_exit_fail_msg("MADV_PAGEOUT accepted a locked VMA\n");
> +	if (mapping[0] != 1)
> +		ksft_exit_fail_msg("madvise changed locked memory\n");
> +
> +	munlock(mapping, page_size);
> +	munmap(mapping, page_size);
> +	ksft_test_result_pass("COLD and PAGEOUT reject a locked VMA\n");
> +}
> +
> +/*
> + * A full-range MADV_COLD operates directly on a huge PMD. Assert that aging
> + * the mapping preserves both the physical THP and its contents.
> + */
> +static void test_full_pmd_madvise_cold(void)
> +{
> +	char *mapping = map_aligned_pages(pmd_size);
> +
> +	if (!collapse_all(mapping, pmd_size, 1)) {
> +		munmap(mapping, pmd_size);
> +		ksft_test_result_skip("could not allocate a PMD-sized THP\n");
> +		return;
> +	}
> +	if (madvise(mapping, pmd_size, MADV_COLD))
> +		ksft_exit_fail_perror("MADV_COLD");
> +	if (!check_large_folios(mapping, pmd_size, 1, pmd_size))
> +		ksft_exit_fail_msg("full MADV_COLD split a PMD-mapped THP\n");
> +	check_memory(mapping, pmd_size);
> +
> +	munmap(mapping, pmd_size);
> +	ksft_test_result_pass("full MADV_COLD preserves a PMD-mapped THP\n");
> +}
> +
> +/*
> + * MADV_COLD is idempotent. A second request must handle an already-old huge
> + * PMD without splitting the THP or changing its contents.
> + */
> +static void test_repeated_pmd_madvise_cold(void)
> +{
> +	char *mapping = map_aligned_pages(pmd_size);
> +
> +	if (!collapse_all(mapping, pmd_size, 1)) {
> +		munmap(mapping, pmd_size);
> +		ksft_test_result_skip("could not allocate a PMD-sized THP\n");
> +		return;
> +	}
> +	if (madvise(mapping, pmd_size, MADV_COLD) ||
> +	    madvise(mapping, pmd_size, MADV_COLD))
> +		ksft_exit_fail_perror("MADV_COLD");
> +	if (!check_large_folios(mapping, pmd_size, 1, pmd_size))
> +		ksft_exit_fail_msg("repeated MADV_COLD split a PMD-mapped THP\n");
> +	check_memory(mapping, pmd_size);
> +
> +	munmap(mapping, pmd_size);
> +	ksft_test_result_pass("repeated MADV_COLD preserves a PMD-mapped THP\n");
> +}
> +
> +/*
> + * MADV_COLD on half of a PMD-mapped THP must split the folio so the
> + * unadvised half is not aged as part of the THP.
> + */
> +static void test_partial_pmd_madvise_cold(void)
> +{
> +	char *mapping = map_aligned_pages(pmd_size);
> +
> +	if (!collapse_all(mapping, pmd_size, 1)) {
> +		munmap(mapping, pmd_size);
> +		ksft_test_result_skip("could not allocate a PMD-sized THP\n");
> +		return;
> +	}
> +	if (madvise(mapping, pmd_size / 2, MADV_COLD))
> +		ksft_exit_fail_perror("MADV_COLD");
> +	if (!check_large_folios(mapping, pmd_size, 0, pmd_size))
> +		ksft_exit_fail_msg("partial MADV_COLD left a PMD-mapped THP\n");
> +	check_memory(mapping, pmd_size);
> +
> +	munmap(mapping, pmd_size);
> +	ksft_test_result_pass("partial MADV_COLD splits a PMD-mapped THP\n");
> +}
> +
> +static void pageout_half_thp(char *mapping)
> +{
> +	if (madvise(mapping, pmd_size / 2, MADV_PAGEOUT))
> +		ksft_exit_fail_perror("MADV_PAGEOUT");
> +	if (!check_large_folios(mapping, pmd_size, 0, pmd_size))
> +		ksft_exit_fail_msg("partial MADV_PAGEOUT left a large folio\n");
> +	check_memory(mapping, pmd_size);
> +}
> +
> +/*
> + * Full-range MADV_PAGEOUT can reclaim a PMD-mapped THP directly. Assert that
> + * the mapping is swapped without corrupting the folio contents.
> + */
> +static void test_full_pmd_madvise_pageout(void)
> +{
> +	char *mapping = map_aligned_pages(pmd_size);
> +	int pagemap_fd, retry;
> +	bool swapped = false;
> +
> +	if (!collapse_all(mapping, pmd_size, 1)) {
> +		munmap(mapping, pmd_size);
> +		ksft_test_result_skip("could not allocate a PMD-sized THP\n");
> +		return;
> +	}
> +	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +	if (pagemap_fd < 0)
> +		ksft_exit_fail_perror("open pagemap");
> +
> +	for (retry = 0; retry < 100; retry++) {
> +		if (madvise(mapping, pmd_size, MADV_PAGEOUT))
> +			ksft_exit_fail_perror("MADV_PAGEOUT");
> +		if (pagemap_is_swapped(pagemap_fd, mapping)) {
> +			swapped = true;
> +			break;
> +		}
> +		usleep(10000);
> +	}
> +	if (swapped)
> +		check_memory(mapping, pmd_size);
> +
> +	close(pagemap_fd);
> +	munmap(mapping, pmd_size);
> +	if (!swapped) {
> +		ksft_test_result_skip("MADV_PAGEOUT did not swap the THP\n");
> +		return;
> +	}
> +	ksft_test_result_pass("full MADV_PAGEOUT swaps a PMD-mapped THP\n");
> +}
> +
> +/*
> + * A swapped PTE is non-present but not empty. MADV_COLD must skip the entry
> + * without faulting the page back in or changing its contents.
> + */
> +static void test_madvise_cold_swapped_pte(void)
> +{
> +	const size_t page_size = getpagesize();
> +	char *mapping = map_aligned_pages(page_size);
> +	int pagemap_fd, retry;
> +	bool swapped = false;
> +
> +	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +	if (pagemap_fd < 0)
> +		ksft_exit_fail_perror("open pagemap");
> +	for (retry = 0; retry < 100; retry++) {
> +		if (madvise(mapping, page_size, MADV_PAGEOUT))
> +			ksft_exit_fail_perror("MADV_PAGEOUT");
> +		if (pagemap_is_swapped(pagemap_fd, mapping)) {
> +			swapped = true;
> +			break;
> +		}
> +		usleep(10000);
> +	}
> +	if (!swapped) {
> +		close(pagemap_fd);
> +		munmap(mapping, page_size);
> +		ksft_test_result_skip("MADV_PAGEOUT did not swap the page\n");
> +		return;
> +	}
> +
> +	if (madvise(mapping, page_size, MADV_COLD))
> +		ksft_exit_fail_perror("MADV_COLD");
> +	if (!pagemap_is_swapped(pagemap_fd, mapping))
> +		ksft_exit_fail_msg("MADV_COLD faulted in a swapped PTE\n");
> +	if (mapping[0] != 1)
> +		ksft_exit_fail_msg("swapped page contents changed\n");
> +
> +	close(pagemap_fd);
> +	munmap(mapping, page_size);
> +	ksft_test_result_pass("MADV_COLD skips a swapped PTE\n");
> +}
> +
> +/*
> + * vmsplice() retains a reference to a THP in a pipe, preventing a partial
> + * MADV_COLD from splitting it. The advice must leave the folio intact while
> + * pinned, then split it normally after the pipe releases the reference.
> + */
> +static void test_partial_pinned_madvise_cold(bool pte_mapped)
> +{
> +	const size_t page_size = getpagesize();
> +	char *mapping = map_aligned_pages(pmd_size);
> +	struct iovec iov = {
> +		.iov_base = mapping,
> +		.iov_len = page_size,
> +	};
> +	char *buffer;
> +	int pipefd[2];
> +	int retry;
> +
> +	if (!collapse_all(mapping, pmd_size, 1)) {
> +		munmap(mapping, pmd_size);
> +		ksft_test_result_skip("could not allocate a PMD-sized THP\n");
> +		return;
> +	}
> +	if (pte_mapped)
> +		split_pmd_mapping(mapping);
> +	if (pipe(pipefd))
> +		ksft_exit_fail_perror("pipe");
> +	if (vmsplice(pipefd[1], &iov, 1, SPLICE_F_GIFT) != page_size) {
> +		close(pipefd[0]);
> +		close(pipefd[1]);
> +		munmap(mapping, pmd_size);
> +		ksft_test_result_skip("vmsplice could not retain a THP page\n");
> +		return;
> +	}
> +
> +	if (madvise(mapping, pmd_size / 2, MADV_COLD))
> +		ksft_exit_fail_perror("MADV_COLD");
> +	if (!check_large_folios(mapping, pmd_size, 1, pmd_size))
> +		ksft_exit_fail_msg("MADV_COLD split a pinned THP\n");
> +
> +	buffer = malloc(page_size);
> +	if (!buffer)
> +		ksft_exit_fail_perror("malloc");
> +	if (read(pipefd[0], buffer, page_size) != page_size)
> +		ksft_exit_fail_perror("read pipe");
> +	free(buffer);
> +	close(pipefd[0]);
> +	close(pipefd[1]);
> +
> +	for (retry = 0; retry < 10; retry++) {
> +		if (madvise(mapping, pmd_size / 2, MADV_COLD))
> +			ksft_exit_fail_perror("MADV_COLD");
> +		if (check_large_folios(mapping, pmd_size, 0, pmd_size))
> +			break;
> +		usleep(10000);
> +	}
> +	if (retry == 10)
> +		ksft_exit_fail_msg("MADV_COLD did not split an unpinned THP\n");
> +	check_memory(mapping, pmd_size);
> +
> +	munmap(mapping, pmd_size);
> +	ksft_test_result_pass("partial MADV_COLD skips a pinned %s THP\n",
> +			      pte_mapped ? "PTE-mapped" : "PMD-mapped");
> +}
> +
> +static void test_partial_pinned_pmd_madvise_cold(void)
> +{
> +	test_partial_pinned_madvise_cold(false);
> +}
> +
> +/*
> + * Pinning a PTE-mapped THP also prevents a partial MADV_COLD from splitting
> + * it. Once the pipe releases the reference, a serial retry must split it.
> + */
> +static void test_partial_pinned_pte_madvise_cold(void)
> +{
> +	test_partial_pinned_madvise_cold(true);
> +}
> +
> +static void *madvise_cold_worker(void *unused)
> +{
> +	int round, i;
> +
> +	(void)unused;
> +	for (round = 0; round < NR_CONCURRENT_ROUNDS; round++) {
> +		pthread_barrier_wait(&concurrent_start_barrier);
> +		for (i = 0; i < NR_CONCURRENT_THPS; i++) {
> +			if (madvise(concurrent_area + i * pmd_size,
> +				    pmd_size / 2, MADV_COLD))
> +				atomic_store(&concurrent_worker_errno, errno);
> +		}
> +		pthread_barrier_wait(&concurrent_done_barrier);
> +	}
> +
> +	return NULL;
> +}
> +
> +/*
> + * Concurrent partial MADV_COLD calls deliberately contend for each THP lock.
> + * Alternate PMD- and PTE-mapped rounds to exercise both split paths. A caller
> + * that loses the trylock race may skip that folio, so retry serially before
> + * asserting the stable interface: all calls succeed, the THPs remain
> + * splittable, and their contents are unchanged.
> + */
> +static void test_concurrent_partial_madvise_cold(void)
> +{
> +	const size_t size = NR_CONCURRENT_THPS * pmd_size;
> +	pthread_t threads[NR_CONCURRENT_THREADS];
> +	int round, i;
> +
> +	concurrent_area = map_aligned_pages(size);
> +	if (!collapse_all(concurrent_area, size, NR_CONCURRENT_THPS)) {
> +		munmap(concurrent_area, size);
> +		ksft_test_result_skip("could not allocate PMD-sized THPs\n");
> +		return;
> +	}
> +	if (pthread_barrier_init(&concurrent_start_barrier, NULL,
> +				 NR_CONCURRENT_THREADS + 1) ||
> +	    pthread_barrier_init(&concurrent_done_barrier, NULL,
> +				 NR_CONCURRENT_THREADS + 1))
> +		ksft_exit_fail_msg("pthread_barrier_init failed\n");
> +	for (i = 0; i < NR_CONCURRENT_THREADS; i++)
> +		if (pthread_create(&threads[i], NULL, madvise_cold_worker, NULL))
> +			ksft_exit_fail_msg("pthread_create failed\n");
> +
> +	for (round = 0; round < NR_CONCURRENT_ROUNDS; round++) {
> +		if (!collapse_all(concurrent_area, size, NR_CONCURRENT_THPS))
> +			ksft_exit_fail_msg("round %d: failed to form PMD THPs\n",
> +					   round);
> +		if (round & 1)
> +			for (i = 0; i < NR_CONCURRENT_THPS; i++)
> +				split_pmd_mapping(concurrent_area + i * pmd_size);
> +		pthread_barrier_wait(&concurrent_start_barrier);
> +		pthread_barrier_wait(&concurrent_done_barrier);
> +
> +		if (atomic_load(&concurrent_worker_errno)) {
> +			errno = atomic_load(&concurrent_worker_errno);
> +			ksft_exit_fail_perror("MADV_COLD");
> +		}
> +		for (i = 0; i < NR_CONCURRENT_THPS; i++) {
> +			if (madvise(concurrent_area + i * pmd_size,
> +				    pmd_size / 2, MADV_COLD))
> +				ksft_exit_fail_perror("MADV_COLD retry");
> +		}
> +		if (!check_large_folios(concurrent_area, size, 0, pmd_size))
> +			ksft_exit_fail_msg("round %d: PMD THP remained\n", round);
> +	}
> +	check_memory(concurrent_area, size);
> +
> +	for (i = 0; i < NR_CONCURRENT_THREADS; i++)
> +		pthread_join(threads[i], NULL);
> +	pthread_barrier_destroy(&concurrent_done_barrier);
> +	pthread_barrier_destroy(&concurrent_start_barrier);
> +	munmap(concurrent_area, size);
> +	ksft_test_result_pass("concurrent partial MADV_COLD preserves memory\n");
> +}
> +
> +/*
> + * SHM_LOCK makes a shmem folio unevictable without setting VM_LOCKED on this
> + * VMA. MADV_PAGEOUT must put an isolated folio back on its LRU rather than
> + * reclaiming it.
> + */
> +static void test_madvise_pageout_unevictable(void)
> +{
> +	const size_t page_size = getpagesize();
> +	unsigned long pfn;
> +	uint64_t flags;
> +	char *mapping;
> +	int pagemap_fd, kpageflags_fd;
> +	int shmid;
> +
> +	if (geteuid()) {
> +		ksft_test_result_skip("requires root to read page flags\n");
> +		return;
> +	}
> +	shmid = shmget(IPC_PRIVATE, page_size, IPC_CREAT | 0600);
> +	if (shmid < 0)
> +		ksft_exit_fail_perror("shmget");
> +	if (shmctl(shmid, SHM_LOCK, NULL)) {
> +		shmctl(shmid, IPC_RMID, NULL);
> +		ksft_test_result_skip("could not lock a shmem segment\n");
> +		return;
> +	}
> +	mapping = shmat(shmid, NULL, 0);
> +	if (mapping == (void *)-1)
> +		ksft_exit_fail_perror("shmat");
> +	mapping[0] = 1;
> +
> +	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +	kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
> +	if (pagemap_fd < 0 || kpageflags_fd < 0)
> +		ksft_exit_fail_perror("open page flags");
> +
> +	/* Drain the LRU add batch so the locked mapping becomes unevictable. */
> +	if (madvise(mapping, page_size, MADV_COLD))
> +		ksft_exit_fail_perror("MADV_COLD");
> +	pfn = pagemap_get_pfn(pagemap_fd, mapping);
> +	if (pfn == -1ul || pageflags_get(pfn, kpageflags_fd, &flags) ||
> +	    !(flags & KPF_UNEVICTABLE))
> +		ksft_exit_fail_msg("SHM_LOCK page is not unevictable\n");
> +
> +	if (madvise(mapping, page_size, MADV_PAGEOUT))
> +		ksft_exit_fail_perror("MADV_PAGEOUT");
> +	if (!pagemap_is_populated(pagemap_fd, mapping) || mapping[0] != 1)
> +		ksft_exit_fail_msg("MADV_PAGEOUT reclaimed an unevictable page\n");
> +
> +	close(kpageflags_fd);
> +	close(pagemap_fd);
> +	shmctl(shmid, SHM_UNLOCK, NULL);
> +	shmdt(mapping);
> +	shmctl(shmid, IPC_RMID, NULL);
> +	ksft_test_result_pass("MADV_PAGEOUT preserves an unevictable page\n");
> +}
> +
> +/*
> + * Exercise the unevictable PAGEOUT path at PMD granularity. SHM_LOCK keeps
> + * the shmem THP resident without marking its VMA VM_LOCKED.
> + */
> +static void test_madvise_pageout_unevictable_thp(void)
> +{
> +	char *mapping;
> +	int pagemap_fd, shmid;
> +
> +	if (geteuid()) {
> +		ksft_test_result_skip("requires root to lock a shmem segment\n");
> +		return;
> +	}
> +	mapping = map_unevictable_shmem(pmd_size, &shmid);
> +	if (mapping == MAP_FAILED)
> +		return;
> +	memset(mapping, 1, pmd_size);
> +	if (!collapse_shmem(mapping, pmd_size, 1)) {
> +		unmap_unevictable_shmem(mapping, shmid);
> +		ksft_test_result_skip("could not allocate an unevictable THP\n");
> +		return;
> +	}
> +	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +	if (pagemap_fd < 0)
> +		ksft_exit_fail_perror("open pagemap");
> +
> +	if (madvise(mapping, pmd_size, MADV_PAGEOUT))
> +		ksft_exit_fail_perror("MADV_PAGEOUT");
> +	if (!pagemap_is_populated(pagemap_fd, mapping) ||
> +	    !check_huge_shmem(mapping, pmd_size, 1, pmd_size))
> +		ksft_exit_fail_msg("MADV_PAGEOUT reclaimed an unevictable THP\n");
> +	check_memory(mapping, pmd_size);
> +
> +	close(pagemap_fd);
> +	unmap_unevictable_shmem(mapping, shmid);
> +	ksft_test_result_pass("MADV_PAGEOUT preserves an unevictable THP\n");
> +}
> +
> +/*
> + * migrate_pages() isolates folios from the LRU before replacing their page
> + * table entries. Race that interval against MADV_PAGEOUT on PMD-mapped THPs.
> + * Either operation may skip a folio owned by the other, but repeated calls
> + * must not report an error or corrupt the mapping.
> + */
> +static void test_madvise_pageout_migration(void)
> +{
> +#if defined(SYS_get_mempolicy) && defined(SYS_mbind) && \
> +	defined(SYS_migrate_pages)
> +	unsigned long allowed[NUMA_MASK_LONGS] = {};
> +	unsigned long mask1[NUMA_MASK_LONGS] = {};
> +	unsigned long mask2[NUMA_MASK_LONGS] = {};
> +	const size_t size = NR_MIGRATION_RACE_THPS * pmd_size;
> +	char *mapping;
> +	int node1, node2;
> +	int error;
> +	int shmid;
> +
> +	if (geteuid()) {
> +		ksft_test_result_skip("requires root to lock a shmem segment\n");
> +		return;
> +	}
> +	if (!find_two_memory_nodes(allowed, &node1, &node2)) {
> +		ksft_test_result_skip("requires two allowed NUMA memory nodes\n");
> +		return;
> +	}
> +
> +	numa_mask_set(mask1, node1);
> +	numa_mask_set(mask2, node2);
> +	mapping = map_unevictable_shmem(size, &shmid);
> +	if (mapping == MAP_FAILED)
> +		return;
> +	if (syscall(SYS_mbind, mapping, size, MPOL_BIND, mask1,
> +		    NUMA_MASK_BITS + 1, 0)) {
> +		unmap_unevictable_shmem(mapping, shmid);
> +		ksft_test_result_skip("could not bind shmem to a NUMA node\n");
> +		return;
> +	}
> +	memset(mapping, 1, size);
> +	if (!collapse_shmem(mapping, size, NR_MIGRATION_RACE_THPS)) {
> +		unmap_unevictable_shmem(mapping, shmid);
> +		ksft_test_result_skip("could not allocate unevictable shmem THPs\n");
> +		return;
> +	}
> +
> +	error = race_pageout_with_migration(mapping, size, mask1, mask2);
> +	if (error == ENOSYS) {
> +		unmap_unevictable_shmem(mapping, shmid);
> +		ksft_test_result_skip("NUMA migration is unavailable\n");
> +		return;
> +	}
> +	if (error) {
> +		errno = error;
> +		ksft_exit_fail_perror("MADV_PAGEOUT/migrate_pages race");
> +	}
> +	check_memory(mapping, size);
> +
> +	unmap_unevictable_shmem(mapping, shmid);
> +	ksft_test_result_pass("MADV_PAGEOUT races NUMA migration safely\n");
> +#else
> +	ksft_test_result_skip("NUMA migration system calls are unavailable\n");
> +#endif
> +}
> +
> +static bool activate_folio(char *mapping, char *drain, unsigned long pfn,
> +			   int kpageflags_fd)
> +{
> +	struct iovec local = { .iov_base = drain, .iov_len = 1 };
> +	struct iovec remote = { .iov_base = mapping, .iov_len = 1 };
> +	uint64_t flags;
> +	int retry;
> +
> +	for (retry = 0; retry < 10; retry++) {
> +		if (process_vm_readv(getpid(), &local, 1, &remote, 1, 0) != 1)
> +			ksft_exit_fail_perror("process_vm_readv");
> +		/* Drain the activation batch without advising the target folio. */
> +		if (madvise(drain, getpagesize(), MADV_COLD))
> +			ksft_exit_fail_perror("MADV_COLD");
> +		if (pageflags_get(pfn, kpageflags_fd, &flags))
> +			ksft_exit_fail_perror("read kpageflags");
> +		if (flags & KPF_ACTIVE)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Repeated GUP accesses promote an inactive folio on the traditional LRU.
> + * MADV_COLD must deactivate that folio while preserving its contents.
> + */
> +static void test_madvise_cold_active_folio(void)
> +{
> +	const size_t page_size = getpagesize();
> +	char *mapping = map_aligned_pages(page_size);
> +	char *drain = map_aligned_pages(page_size);
> +	cpu_set_t old_mask, mask;
> +	int pagemap_fd, kpageflags_fd;
> +	unsigned long pfn;
> +	uint64_t flags;
> +	int cpu;
> +
> +	if (geteuid()) {
> +		munmap(drain, page_size);
> +		munmap(mapping, page_size);
> +		ksft_test_result_skip("requires root to read page flags\n");
> +		return;
> +	}
> +	if (sched_getaffinity(0, sizeof(old_mask), &old_mask))
> +		ksft_exit_fail_perror("sched_getaffinity");
> +	cpu = sched_getcpu();
> +	if (cpu < 0)
> +		ksft_exit_fail_perror("sched_getcpu");
> +	CPU_ZERO(&mask);
> +	CPU_SET(cpu, &mask);
> +	if (sched_setaffinity(0, sizeof(mask), &mask))
> +		ksft_exit_fail_perror("sched_setaffinity");
> +
> +	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +	kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
> +	if (pagemap_fd < 0 || kpageflags_fd < 0)
> +		ksft_exit_fail_perror("open page flags");
> +	pfn = pagemap_get_pfn(pagemap_fd, mapping);
> +	if (pfn == -1ul)
> +		ksft_exit_fail_msg("could not read page PFN\n");
> +
> +	if (!activate_folio(mapping, drain, pfn, kpageflags_fd)) {
> +		close(kpageflags_fd);
> +		close(pagemap_fd);
> +		sched_setaffinity(0, sizeof(old_mask), &old_mask);
> +		munmap(drain, page_size);
> +		munmap(mapping, page_size);
> +		ksft_test_result_skip("could not activate a folio\n");
> +		return;
> +	}
> +
> +	if (madvise(mapping, page_size, MADV_COLD) ||
> +	    madvise(drain, page_size, MADV_COLD))
> +		ksft_exit_fail_perror("MADV_COLD");
> +	if (pageflags_get(pfn, kpageflags_fd, &flags))
> +		ksft_exit_fail_perror("read kpageflags");
> +	if ((flags & KPF_ACTIVE) || mapping[0] != 1)
> +		ksft_exit_fail_msg("MADV_COLD did not deactivate the folio\n");
> +
> +	close(kpageflags_fd);
> +	close(pagemap_fd);
> +	if (sched_setaffinity(0, sizeof(old_mask), &old_mask))
> +		ksft_exit_fail_perror("restore affinity");
> +	munmap(drain, page_size);
> +	munmap(mapping, page_size);
> +	ksft_test_result_pass("MADV_COLD deactivates an active folio\n");
> +}
> +
> +struct remote_fault_data {
> +	char *mapping;
> +	pthread_barrier_t barrier;
> +	int cpu;
> +	int error;
> +};
> +
> +static void *remote_fault_worker(void *arg)
> +{
> +	struct remote_fault_data *data = arg;
> +	cpu_set_t mask;
> +
> +	CPU_ZERO(&mask);
> +	CPU_SET(data->cpu, &mask);
> +	if (sched_setaffinity(0, sizeof(mask), &mask))
> +		data->error = errno;
> +	else
> +		data->mapping[0] = 1;
> +	pthread_barrier_wait(&data->barrier);
> +	pthread_barrier_wait(&data->barrier);
> +	return NULL;
> +}
> +
> +/*
> + * A folio faulted on another CPU can remain in that CPU's pending LRU batch.
> + * MADV_COLD drains only the calling CPU and must safely skip the non-LRU
> + * folio without changing the mapping.
> + */
> +static void test_madvise_cold_remote_lru_batch(void)
> +{
> +	const size_t page_size = getpagesize();
> +	struct remote_fault_data data = { .cpu = -1 };
> +	char *mapping;
> +	cpu_set_t old_mask, mask;
> +	pthread_t thread;
> +	unsigned long pfn;
> +	uint64_t flags;
> +	int pagemap_fd, kpageflags_fd;
> +	int cpu, main_cpu = -1;
> +
> +	if (geteuid()) {
> +		ksft_test_result_skip("requires root to read page flags\n");
> +		return;
> +	}
> +	if (sched_getaffinity(0, sizeof(old_mask), &old_mask))
> +		ksft_exit_fail_perror("sched_getaffinity");
> +	for (cpu = 0; cpu < CPU_SETSIZE; cpu++) {
> +		if (!CPU_ISSET(cpu, &old_mask))
> +			continue;
> +		if (main_cpu < 0) {
> +			main_cpu = cpu;
> +		} else {
> +			data.cpu = cpu;
> +			break;
> +		}
> +	}
> +	if (main_cpu < 0 || data.cpu < 0) {
> +		ksft_test_result_skip("requires two CPUs\n");
> +		return;
> +	}
> +	CPU_ZERO(&mask);
> +	CPU_SET(main_cpu, &mask);
> +	if (sched_setaffinity(0, sizeof(mask), &mask))
> +		ksft_exit_fail_perror("sched_setaffinity");
> +
> +	mapping = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
> +		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	if (mapping == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
> +	data.mapping = mapping;
> +	if (pthread_barrier_init(&data.barrier, NULL, 2) ||
> +	    pthread_create(&thread, NULL, remote_fault_worker, &data))
> +		ksft_exit_fail_msg("could not start fault worker\n");
> +	pthread_barrier_wait(&data.barrier);
> +	if (data.error) {
> +		errno = data.error;
> +		ksft_exit_fail_perror("worker sched_setaffinity");
> +	}
> +
> +	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +	kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
> +	if (pagemap_fd < 0 || kpageflags_fd < 0)
> +		ksft_exit_fail_perror("open page flags");
> +	pfn = pagemap_get_pfn(pagemap_fd, mapping);
> +	if (pfn == -1ul || pageflags_get(pfn, kpageflags_fd, &flags))
> +		ksft_exit_fail_msg("could not read page flags\n");
> +	if (flags & KPF_LRU) {
> +		pthread_barrier_wait(&data.barrier);
> +		pthread_join(thread, NULL);
> +		pthread_barrier_destroy(&data.barrier);
> +		close(kpageflags_fd);
> +		close(pagemap_fd);
> +		sched_setaffinity(0, sizeof(old_mask), &old_mask);
> +		munmap(mapping, page_size);
> +		ksft_test_result_skip("remote LRU batch was already drained\n");
> +		return;
> +	}
> +
> +	if (madvise(mapping, page_size, MADV_COLD))
> +		ksft_exit_fail_perror("MADV_COLD");
> +	if (mapping[0] != 1 || !pagemap_is_populated(pagemap_fd, mapping))
> +		ksft_exit_fail_msg("MADV_COLD changed a pending-LRU page\n");
> +
> +	pthread_barrier_wait(&data.barrier);
> +	pthread_join(thread, NULL);
> +	pthread_barrier_destroy(&data.barrier);
> +	close(kpageflags_fd);
> +	close(pagemap_fd);
> +	if (sched_setaffinity(0, sizeof(old_mask), &old_mask))
> +		ksft_exit_fail_perror("restore affinity");
> +	munmap(mapping, page_size);
> +	ksft_test_result_pass("MADV_COLD skips a remote pending-LRU page\n");
> +}
> +
> +/*
> + * Exercise the same active-folio transition through a huge PMD, where the
> + * page-table aging operation differs from the PTE implementation.
> + */
> +static void test_pmd_madvise_cold_active_folio(void)
> +{
> +	const size_t page_size = getpagesize();
> +	char *mapping;
> +	char *drain = map_aligned_pages(page_size);
> +	cpu_set_t old_mask, mask;
> +	int pagemap_fd, kpageflags_fd;
> +	unsigned long pfn;
> +	uint64_t flags;
> +	int cpu, fd, retry;
> +	bool active = false;
> +
> +	if (geteuid()) {
> +		munmap(drain, page_size);
> +		ksft_test_result_skip("requires root to read page flags\n");
> +		return;
> +	}
> +	fd = memfd_create("madvise-active-thp", 0);
> +	if (fd < 0)
> +		ksft_exit_fail_perror("memfd_create");
> +	if (ftruncate(fd, pmd_size))
> +		ksft_exit_fail_perror("ftruncate");
> +	mapping = map_aligned_file(fd, pmd_size, MAP_SHARED);
> +	memset(mapping, 1, pmd_size);
> +	if (msync(mapping, pmd_size, MS_SYNC) ||
> +	    !collapse_shmem(mapping, pmd_size, 1)) {
> +		munmap(drain, page_size);
> +		munmap(mapping, pmd_size);
> +		close(fd);
> +		ksft_test_result_skip("could not allocate a PMD-sized shmem THP\n");
> +		return;
> +	}
> +	if (sched_getaffinity(0, sizeof(old_mask), &old_mask))
> +		ksft_exit_fail_perror("sched_getaffinity");
> +	cpu = sched_getcpu();
> +	if (cpu < 0)
> +		ksft_exit_fail_perror("sched_getcpu");
> +	CPU_ZERO(&mask);
> +	CPU_SET(cpu, &mask);
> +	if (sched_setaffinity(0, sizeof(mask), &mask))
> +		ksft_exit_fail_perror("sched_setaffinity");
> +
> +	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +	kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
> +	if (pagemap_fd < 0 || kpageflags_fd < 0)
> +		ksft_exit_fail_perror("open page flags");
> +	pfn = pagemap_get_pfn(pagemap_fd, mapping);
> +	if (pfn == -1ul)
> +		ksft_exit_fail_msg("could not read THP PFN\n");
> +
> +	for (retry = 0; retry < 10; retry++) {
> +		if (pread(fd, drain, 1, 0) != 1)
> +			ksft_exit_fail_perror("pread");
> +		if (madvise(drain, page_size, MADV_COLD))
> +			ksft_exit_fail_perror("MADV_COLD");
> +		if (pageflags_get(pfn, kpageflags_fd, &flags))
> +			ksft_exit_fail_perror("read kpageflags");
> +		if (flags & KPF_ACTIVE) {
> +			active = true;
> +			break;
> +		}
> +	}
> +	if (!active) {
> +		close(kpageflags_fd);
> +		close(pagemap_fd);
> +		sched_setaffinity(0, sizeof(old_mask), &old_mask);
> +		munmap(drain, page_size);
> +		munmap(mapping, pmd_size);
> +		close(fd);
> +		ksft_test_result_skip("could not activate a THP\n");
> +		return;
> +	}
> +
> +	if (madvise(mapping, pmd_size, MADV_COLD) ||
> +	    madvise(drain, page_size, MADV_COLD))
> +		ksft_exit_fail_perror("MADV_COLD");
> +	if (pageflags_get(pfn, kpageflags_fd, &flags))
> +		ksft_exit_fail_perror("read kpageflags");
> +	if (flags & KPF_ACTIVE)
> +		ksft_exit_fail_msg("MADV_COLD did not deactivate the THP\n");
> +	if (!check_huge_shmem(mapping, pmd_size, 1, pmd_size))
> +		ksft_exit_fail_msg("MADV_COLD split an active THP\n");
> +	check_memory(mapping, pmd_size);
> +
> +	close(kpageflags_fd);
> +	close(pagemap_fd);
> +	if (sched_setaffinity(0, sizeof(old_mask), &old_mask))
> +		ksft_exit_fail_perror("restore affinity");
> +	munmap(drain, page_size);
> +	munmap(mapping, pmd_size);
> +	close(fd);
> +	ksft_test_result_pass("MADV_COLD deactivates an active THP\n");
> +}
> +
> +/*
> + * MADV_PAGEOUT on half of a PMD-mapped THP must split the folio before
> + * reclaim so the unadvised half is not reclaimed as part of the THP.
> + */
> +static void test_partial_pmd_madvise_pageout(void)
> +{
> +	char *mapping = map_aligned_pages(pmd_size);
> +
> +	if (!collapse_all(mapping, pmd_size, 1)) {
> +		munmap(mapping, pmd_size);
> +		ksft_test_result_skip("could not allocate a PMD-sized THP\n");
> +		return;
> +	}
> +	pageout_half_thp(mapping);
> +
> +	munmap(mapping, pmd_size);
> +	ksft_test_result_pass("partial MADV_PAGEOUT splits a PMD-mapped THP\n");
> +}
> +
> +/*
> + * mprotect() replaces the huge PMD with PTEs without splitting the physical
> + * THP. MADV_PAGEOUT on half of that PTE-mapped THP must split the folio.
> + */
> +static void test_partial_pte_madvise_pageout(void)
> +{
> +	char *mapping = map_aligned_pages(pmd_size);
> +
> +	if (!collapse_all(mapping, pmd_size, 1)) {
> +		munmap(mapping, pmd_size);
> +		ksft_test_result_skip("could not allocate a PMD-sized THP\n");
> +		return;
> +	}
> +	split_pmd_mapping(mapping);
> +	pageout_half_thp(mapping);
> +
> +	munmap(mapping, pmd_size);
> +	ksft_test_result_pass("partial MADV_PAGEOUT splits a PTE-mapped THP\n");
> +}
> +
> +static pid_t fork_waiting_child(int pipefd[2])
> +{
> +	pid_t pid;
> +
> +	if (pipe(pipefd))
> +		ksft_exit_fail_perror("pipe");
> +	pid = fork();
> +	if (pid < 0)
> +		ksft_exit_fail_perror("fork");
> +	if (!pid) {
> +		char byte;
> +
> +		close(pipefd[1]);
> +		while (read(pipefd[0], &byte, 1) < 0 && errno == EINTR)
> +			;
> +		_exit(0);
> +	}
> +	close(pipefd[0]);
> +	return pid;
> +}
> +
> +/*
> + * fork() gives the THP another mapping, then mprotect() PTE-maps it in the
> + * parent. Assert that partial MADV_COLD leaves the shared physical THP and
> + * its contents intact.
> + */
> +static void test_shared_pte_mapped_madvise_cold(void)
> +{
> +	char *mapping = map_aligned_pages(pmd_size);
> +	int pipefd[2], status;
> +	pid_t pid;
> +
> +	if (!collapse_all(mapping, pmd_size, 1)) {
> +		munmap(mapping, pmd_size);
> +		ksft_test_result_skip("could not allocate a PMD-sized THP\n");
> +		return;
> +	}
> +	pid = fork_waiting_child(pipefd);
> +
> +	split_pmd_mapping(mapping);
> +	if (madvise(mapping, pmd_size / 2, MADV_COLD))
> +		ksft_exit_fail_perror("MADV_COLD");
> +	if (!check_large_folios(mapping, pmd_size, 1, pmd_size))
> +		ksft_exit_fail_msg("MADV_COLD split a shared large folio\n");
> +	check_memory(mapping, pmd_size);
> +
> +	close(pipefd[1]);
> +	if (waitpid(pid, &status, 0) != pid || !WIFEXITED(status) ||
> +	    WEXITSTATUS(status))
> +		ksft_exit_fail_msg("child process failed\n");
> +	munmap(mapping, pmd_size);
> +	ksft_test_result_pass("MADV_COLD skips a shared PTE-mapped THP\n");
> +}
> +
> +/*
> + * A full-range PTE walk reaches the mapcount check rather than the partial
> + * folio split check. A second mapping must still prevent MADV_COLD from
> + * operating on the shared physical THP.
> + */
> +static void test_full_shared_pte_mapped_madvise_cold(void)
> +{
> +	char *mapping = map_aligned_pages(pmd_size);
> +	int pipefd[2], status;
> +	pid_t pid;
> +
> +	if (!collapse_all(mapping, pmd_size, 1)) {
> +		munmap(mapping, pmd_size);
> +		ksft_test_result_skip("could not allocate a PMD-sized THP\n");
> +		return;
> +	}
> +	pid = fork_waiting_child(pipefd);
> +
> +	split_pmd_mapping(mapping);
> +	if (madvise(mapping, pmd_size, MADV_COLD))
> +		ksft_exit_fail_perror("MADV_COLD");
> +	if (!check_large_folios(mapping, pmd_size, 1, pmd_size))
> +		ksft_exit_fail_msg("MADV_COLD split a shared large folio\n");
> +	check_memory(mapping, pmd_size);
> +
> +	close(pipefd[1]);
> +	if (waitpid(pid, &status, 0) != pid || !WIFEXITED(status) ||
> +	    WEXITSTATUS(status))
> +		ksft_exit_fail_msg("child process failed\n");
> +	munmap(mapping, pmd_size);
> +	ksft_test_result_pass("full MADV_COLD skips a shared PTE-mapped THP\n");
> +}
> +
> +/*
> + * fork() gives a PMD-mapped THP another mapping. Assert that partial
> + * MADV_COLD leaves the shared physical THP and its contents intact.
> + */
> +static void test_shared_pmd_madvise_cold(void)
> +{
> +	char *mapping = map_aligned_pages(pmd_size);
> +	int pipefd[2], status;
> +	pid_t pid;
> +
> +	if (!collapse_all(mapping, pmd_size, 1)) {
> +		munmap(mapping, pmd_size);
> +		ksft_test_result_skip("could not allocate a PMD-sized THP\n");
> +		return;
> +	}
> +	pid = fork_waiting_child(pipefd);
> +
> +	if (madvise(mapping, pmd_size / 2, MADV_COLD))
> +		ksft_exit_fail_perror("MADV_COLD");
> +	if (!check_large_folios(mapping, pmd_size, 1, pmd_size))
> +		ksft_exit_fail_msg("MADV_COLD split a shared PMD-mapped THP\n");
> +	check_memory(mapping, pmd_size);
> +
> +	close(pipefd[1]);
> +	if (waitpid(pid, &status, 0) != pid || !WIFEXITED(status) ||
> +	    WEXITSTATUS(status))
> +		ksft_exit_fail_msg("child process failed\n");
> +	munmap(mapping, pmd_size);
> +	ksft_test_result_pass("MADV_COLD skips a shared PMD-mapped THP\n");
> +}
> +
> +static char *map_readonly_file(size_t size, int flags, int *fd)
> +{
> +	char template[] = "/tmp/madvise-pageout-XXXXXX";
> +	char *mapping;
> +
> +	*fd = mkstemp(template);
> +	if (*fd < 0)
> +		ksft_exit_fail_perror("mkstemp");
> +	if (unlink(template) || ftruncate(*fd, size) || fchmod(*fd, 0400))
> +		ksft_exit_fail_perror("prepare file");
> +	mapping = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, *fd, 0);
> +	if (mapping == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap");
> +
> +	return mapping;
> +}
> +
> +static bool pageout_until_evicted(char *mapping, size_t size, int pagemap_fd)
> +{
> +	int retry;
> +
> +	for (retry = 0; retry < 100; retry++) {
> +		if (madvise(mapping, size, MADV_PAGEOUT))
> +			ksft_exit_fail_perror("MADV_PAGEOUT");
> +		if (!pagemap_is_populated(pagemap_fd, mapping))
> +			return true;
> +		usleep(10000);
> +	}
> +	return false;
> +}
> +
> +/*
> + * The owner of a file may page out its clean page-cache pages. Assert that
> + * MADV_PAGEOUT removes the populated PTE and preserves the file contents.
> + */
> +static void test_pageout_file(void)
> +{
> +	const size_t page_size = getpagesize();
> +	char *mapping;
> +	int pagemap_fd;
> +	bool evicted;
> +	int fd;
> +
> +	mapping = map_readonly_file(page_size, MAP_PRIVATE, &fd);
> +	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +	if (pagemap_fd < 0)
> +		ksft_exit_fail_perror("open pagemap");
> +	if (mapping[0])
> +		ksft_exit_fail_msg("new file is not zero-filled\n");
> +
> +	evicted = pageout_until_evicted(mapping, page_size, pagemap_fd);
> +	if (mapping[0])
> +		ksft_exit_fail_msg("file mapping contents changed\n");
> +
> +	close(pagemap_fd);
> +	munmap(mapping, page_size);
> +	close(fd);
> +	if (!evicted) {
> +		ksft_test_result_skip("MADV_PAGEOUT did not evict the file page\n");
> +		return;
> +	}
> +	ksft_test_result_pass("MADV_PAGEOUT evicts an authorized file page\n");
> +}
> +
> +static int pageout_shared_file_without_permission(char *mapping,
> +						  size_t page_size)
> +{
> +	int pagemap_fd;
> +
> +	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +	if (pagemap_fd < 0)
> +		return KSFT_FAIL;
> +	if (setgid(65534) || setuid(65534))
> +		return KSFT_FAIL;
> +	if (mapping[0] || !pagemap_is_populated(pagemap_fd, mapping))
> +		return KSFT_FAIL;
> +	if (madvise(mapping, page_size, MADV_PAGEOUT))
> +		return KSFT_FAIL;
> +	if (!pagemap_is_populated(pagemap_fd, mapping) || mapping[0])
> +		return KSFT_FAIL;
> +	return KSFT_PASS;
> +}
> +
> +/*
> + * A caller without file write permission may not page out a shared file
> + * mapping. Assert that MADV_PAGEOUT succeeds without evicting its file page.
> + */
> +static void test_pageout_unauthorized_shared_file(void)
> +{
> +	const size_t page_size = getpagesize();
> +	char *mapping;
> +	int fd, status;
> +	pid_t pid;
> +
> +	if (geteuid()) {
> +		ksft_test_result_skip("requires root to change credentials\n");
> +		return;
> +	}
> +
> +	mapping = map_readonly_file(page_size, MAP_SHARED, &fd);
> +
> +	pid = fork();
> +	if (pid < 0)
> +		ksft_exit_fail_perror("fork");
> +	if (!pid)
> +		_exit(pageout_shared_file_without_permission(mapping, page_size));
> +
> +	if (waitpid(pid, &status, 0) != pid || !WIFEXITED(status) ||
> +	    WEXITSTATUS(status) != KSFT_PASS)
> +		ksft_exit_fail_msg("unauthorized child evicted a shared file page\n");
> +	munmap(mapping, page_size);
> +	close(fd);
> +	ksft_test_result_pass("MADV_PAGEOUT skips an unauthorized shared file\n");
> +}
> +
> +/*
> + * An unauthorized private mapping may page out anonymous COW pages, but not
> + * its file folios. Assert that partial MADV_PAGEOUT filters a large shmem
> + * folio before attempting to split or reclaim it.
> + */
> +static void test_pageout_anon_only_large_folio(void)
> +{
> +	char *mapping, *shared;
> +	gid_t old_egid;
> +	int fd;
> +
> +	if (geteuid()) {
> +		ksft_test_result_skip("requires root to change credentials\n");
> +		return;
> +	}
> +	fd = memfd_create("madvise-pageout-large", 0);
> +	if (fd < 0)
> +		ksft_exit_fail_perror("memfd_create");
> +	if (ftruncate(fd, pmd_size))
> +		ksft_exit_fail_perror("ftruncate");
> +	shared = map_aligned_file(fd, pmd_size, MAP_SHARED);
> +	memset(shared, 1, pmd_size);
> +	if (msync(shared, pmd_size, MS_SYNC))
> +		ksft_exit_fail_perror("msync");
> +	munmap(shared, pmd_size);
> +
> +	mapping = map_aligned_file(fd, pmd_size, MAP_PRIVATE);
> +	if (!collapse_shmem(mapping, pmd_size, 1)) {
> +		munmap(mapping, pmd_size);
> +		close(fd);
> +		ksft_test_result_skip("could not allocate a PMD-sized shmem THP\n");
> +		return;
> +	}
> +	if (fchmod(fd, 0400))
> +		ksft_exit_fail_perror("fchmod");
> +
> +	/* Retain saved uid 0 so this process can restore its credentials. */
> +	old_egid = getegid();
> +	if (setegid(65534) || seteuid(65534))
> +		ksft_exit_fail_perror("drop privileges");
> +	if (madvise(mapping, pmd_size / 2, MADV_PAGEOUT))
> +		ksft_exit_fail_perror("MADV_PAGEOUT");
> +	if (seteuid(0) || setegid(old_egid))
> +		ksft_exit_fail_perror("restore privileges");
> +
> +	if (!check_huge_shmem(mapping, pmd_size, 1, pmd_size) ||
> +	    mapping[0] != 1 || mapping[pmd_size - 1] != 1)
> +		ksft_exit_fail_msg("MADV_PAGEOUT changed a protected large folio\n");
> +	munmap(mapping, pmd_size);
> +	close(fd);
> +	ksft_test_result_pass("MADV_PAGEOUT filters a protected large folio\n");
> +}
> +
> +/*
> + * A private file mapping can contain both anonymous COW and file-backed
> + * pages. As a caller without file write permission, assert that PAGEOUT swaps
> + * the COW page but leaves the file-backed page resident.
> + */
> +static void test_pageout_anon_only(void)
> +{
> +	const size_t page_size = getpagesize();
> +	char *mapping;
> +	int pagemap_fd;
> +	bool swapped;
> +	int fd;
> +
> +	if (geteuid()) {
> +		ksft_test_result_skip("requires root to change credentials\n");
> +		return;
> +	}
> +
> +	mapping = map_readonly_file(2 * page_size, MAP_PRIVATE, &fd);
> +	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +	if (pagemap_fd < 0)
> +		ksft_exit_fail_perror("open pagemap");
> +
> +	if (setgid(65534) || setuid(65534))
> +		ksft_exit_fail_perror("drop privileges");
> +	if (mapping[0] || mapping[page_size])
> +		ksft_exit_fail_msg("new file is not zero-filled\n");
> +	mapping[0] = 1;
> +	if (madvise(mapping, 2 * page_size, MADV_PAGEOUT))
> +		ksft_exit_fail_perror("MADV_PAGEOUT");
> +	if (!pagemap_is_populated(pagemap_fd, mapping + page_size))
> +		ksft_exit_fail_msg("MADV_PAGEOUT evicted a protected file page\n");
> +	swapped = pagemap_is_swapped(pagemap_fd, mapping);
> +	if (mapping[0] != 1 || mapping[page_size])
> +		ksft_exit_fail_msg("private file mapping contents changed\n");
> +
> +	close(pagemap_fd);
> +	munmap(mapping, 2 * page_size);
> +	close(fd);
> +	if (!swapped) {
> +		ksft_test_result_skip("MADV_PAGEOUT did not swap the COW page\n");
> +		return;
> +	}
> +	ksft_test_result_pass("MADV_PAGEOUT filters private file pages\n");
> +}
> +
> +int main(void)
> +{
> +	pmd_size = read_pmd_pagesize();
> +
> +	ksft_print_header();
> +	ksft_set_plan(28);
> +	if (!pmd_size)
> +		ksft_exit_skip("PMD-sized THPs are not supported\n");
> +
> +	test_full_pmd_madvise_cold();
> +	test_repeated_pmd_madvise_cold();
> +	test_partial_pmd_madvise_cold();
> +	test_pte_mapped_madvise_cold();
> +	test_madvise_cold_pte_hole();
> +	test_madvise_cold_zero_page();
> +	test_madvise_cold_huge_zero_page();
> +	test_madvise_lru_locked_vma();
> +	test_shared_pmd_madvise_cold();
> +	test_full_pmd_madvise_pageout();
> +	test_madvise_cold_swapped_pte();
> +	test_partial_pinned_pmd_madvise_cold();
> +	test_partial_pinned_pte_madvise_cold();
> +	test_concurrent_partial_madvise_cold();
> +	test_madvise_pageout_unevictable();
> +	test_madvise_pageout_unevictable_thp();
> +	test_madvise_pageout_migration();
> +	test_madvise_cold_active_folio();
> +	test_madvise_cold_remote_lru_batch();
> +	test_pmd_madvise_cold_active_folio();
> +	test_partial_pmd_madvise_pageout();
> +	test_partial_pte_madvise_pageout();
> +	test_shared_pte_mapped_madvise_cold();
> +	test_full_shared_pte_mapped_madvise_cold();
> +	test_pageout_file();
> +	test_pageout_unauthorized_shared_file();
> +	test_pageout_anon_only_large_folio();
> +	test_pageout_anon_only();
> +	ksft_finished();
> +}
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index 6990485b1a9da..bc136ead10f91 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -51,6 +51,8 @@ separated by spaces:
>  	hmm smoke tests
>  - madv_guard
>  	test madvise(2) MADV_GUARD_INSTALL and MADV_GUARD_REMOVE options
> +- madvise
> +	test MADV_COLD and MADV_PAGEOUT
>  - madv_populate
>  	test memadvise(2) MADV_POPULATE_{READ,WRITE} options
>  - memfd_secret
> @@ -327,6 +329,9 @@ CATEGORY="hmm" run_test bash ./test_hmm.sh smoke
>  # MADV_GUARD_INSTALL and MADV_GUARD_REMOVE tests
>  CATEGORY="madv_guard" run_test ./guard-regions
>
> +# MADV_COLD and MADV_PAGEOUT tests
> +CATEGORY="madvise" run_test ./madvise
> +
>  # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
>  CATEGORY="madv_populate" run_test ./madv_populate
>
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 31d331c1c4521..af0a7f65bfd9f 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -373,8 +373,8 @@ static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
>  	return thp == (nr_hpages * (hpage_size >> 10));
>  }
>
> -static bool check_large_folios(void *addr, size_t len, int nr_hpages,
> -		uint64_t hpage_size)
> +bool check_large_folios(void *addr, size_t len, int nr_hpages,
> +			uint64_t hpage_size)
>  {
>  	int order = 0, pagesize = getpagesize();
>  	unsigned int nr_pages = hpage_size / pagesize;
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index 072a6c756c517..33ae68d721df9 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -22,10 +22,14 @@
>  #define PM_SWAP                       BIT_ULL(62)
>  #define PM_PRESENT                    BIT_ULL(63)
>
> +#define KPF_LRU                       BIT_ULL(5)
> +#define KPF_ACTIVE                    BIT_ULL(6)
>  #define KPF_COMPOUND_HEAD             BIT_ULL(15)
>  #define KPF_COMPOUND_TAIL             BIT_ULL(16)
> +#define KPF_UNEVICTABLE               BIT_ULL(18)
>  #define KPF_HWPOISON                  BIT_ULL(19)
>  #define KPF_THP                       BIT_ULL(22)
> +#define KPF_ZERO_PAGE                 BIT_ULL(24)
>  /*
>   * Ignore the checkpatch warning, we must read from x but don't want to do
>   * anything with it in order to trigger a read page fault. We therefore must use
> @@ -97,6 +101,8 @@ unsigned long rss_anon(void);
>  bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
>  bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
>  bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
> +bool check_large_folios(void *addr, size_t len, int nr_hpages,
> +			uint64_t hpage_size);
>  int64_t allocate_transhuge(void *ptr, int pagemap_fd);
>  int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
>  int gather_folio_orders(char *vaddr_start, size_t len,
> --
> 2.53.0-Meta
>

--
Cheers, Lorenzo

