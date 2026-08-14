Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7312C5DF69
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 13:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B97F6B030A; Fri, 14 Aug 2026 09:29:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870BB6B030B; Fri, 14 Aug 2026 09:29:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75A1D6B030C; Fri, 14 Aug 2026 09:29:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2446B030A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:29:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3060F1A00E9
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:29:15 +0000 (UTC)
X-FDA: 85099956270.15.1DC4E8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 76684180004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:29:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OFKuPhXH;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786714153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxIgny8KYLFo6HA6lan7Df4fdpnIeC/XPvUXrzUku2c=;
	b=gm/tuG12OINPeWkKb2HoJ/S+88SxvAln2pYqgq8GBlp2PW+ngh8UTS/iIA/pURRra2c85F
	iz/VyllFWsmlag4zXTzrKk6THz1TbN8KJf/gVD8UvHq2afKxGSoc/aJs3uMr7sy6ZsfQux
	gHrJz013F3FHt+9pzz8BZR5UpZhNzDI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786714153;
	b=4vWjQIPxTqw9VjkX4YhK08pTpD4RMPlQZ+lx4bwmXVQa+LttWw0XIEqT76FeZQaEYOiV5V
	YT9gSt9d91zaCtDBYdnPWf2RjVMXjjwaZlF4KCgVaz4dMOQ4T5xd014mGG9u2UQWeQ+6rG
	yE9q1WH2AAiBnHAX/ICBUgbsCW0vFBc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OFKuPhXH;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F504403F0;
	Fri, 14 Aug 2026 13:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E8D1F000E9;
	Fri, 14 Aug 2026 13:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786714152;
	bh=kxIgny8KYLFo6HA6lan7Df4fdpnIeC/XPvUXrzUku2c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OFKuPhXH1ENZFQcJ3h2fK4HuQJ5vwaj48tytDvbSMItfDhjPZy3eu+K6OdBx60wjC
	 +3JpVH+15z7w+LkqOkuqj9PDmPLgmgFxqQjlI+OCKwPGZhEQJZLU4gY/j+EXq/92+6
	 qTutyQxJ5mlKlqT/srbS2HqSK2DTWHWc4phbLUH7RV1ZY1JPMWPL9tRPIRy3Qdv/VT
	 k2pK7Gk4bCAQCrQbIXUlof1Vs+l+QYb6NGtcNaS/bRrEhGZldXroK6J28jaf04bInV
	 mD0k/FjoJ0lWV7HjmjLRjgpw82MCG6kTYv45E+ea+DJFsdOTNXIeH+hWQojGJHU8XM
	 3YqNOaiLqchPQ==
Date: Fri, 14 Aug 2026 14:28:53 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: linux-mm@kvack.org, geert@linux-m68k.org, daniel@thingy.jp, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, 
	linux-um@lists.infradead.org
Subject: Re: [RFC PATCH 6/6] selftests/mm: add nommu mmap and mremap behavior
 tests
Message-ID: <an8SvW3jv3JuAFc8@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
 <20260813063401.1786548-7-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813063401.1786548-7-thehajime@gmail.com>
X-Rspam-User: 
X-Stat-Signature: a6wucjrofacoyz3nz89xtwg454h7qqso
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 76684180004
X-HE-Tag: 1786714153-154842
X-HE-Meta: U2FsdGVkX19jOAvKAE4CxI12XuGsnXta/+UAao3UlIKuuwYJTEaVdD8DMpXQCLLquo4cRnuquy42T1xKENPOa0J6JmRw+oSXt8nW5mJR9+RQU/BQbP0jp7maslmsgSELAZDHAHUrNJioZ+tjaPytiSh7MXr1qF8mTTwprahy2YLswqmluQJ3TEAgCc5I7HlmuVUWLbiPRVwMjQwXAt1jsmEJ1e//Ucuf+w83CzdgvCAgPJAa0dhYYCz3esWcl3vvFjALIDQY4ZEeRF2hvCmqQOqSRFeGh+VbnkU1I4yx84frO8mF55CcJVFnF6h6FM8W+QtWidpMnnGtM8SfC12Yh4M1IQCWETYCcqVbG1kDRYv59thfoqunZunni3Hf+3TEInzBcAOGnaVf5fbHrHCD8Au3mksNWHEurCC4C1NrBTVmxJAx9RBmL3MMF79OJDXad6rkTrSSzcPHh6X++Sl1nFUL21E8GneKT9qCWSOBoxkuuvcULNAvMWG8B9wuybugOtG5an1fJ0SPuE8hKg8zKqRsfReCkJzhiQKBvIpKXaw6M6vEvw7NSIc1wJs03RJKop0emLjMfDwcGh2k4umRhfBBUGxWHJrWs9jygde606EXbJE4IMux2KJOJKDJzNjY6f/FWq7g0Ua7mmskxsRKaBOE6JKck7olrFluSqoMdFzvWLLlp93FBjobxP0HKl6lv0q6D2IEF0RsgYcJ2rtW7Yec6iVw4DGhaN9i4OTHQD5BcmxFHjZuFVL3hdvciEdUjFDm3O9MVoRPvmN2na8vMLeyH3hLwgb/8Jnj+Evo4lzlUsYFkGQBM19O4+9t96/x/IgsZikD/8tBbOg8bUb4vdWp+e3MiQG+21973OpIFJ1oWg5gAi6szxiuerlnM6DDHjD5ASXO/GX95xg0sDTy7jMZZJ6k0K/TMeiwxLcsCD4I9nFUM/ZKhvslW6HOmc9HLZfB5pMTvcbubZO2ILg
 0IYwylLf
 KGiDquSlVrjKu7YmrTqbvoSf06kDgiwLQxFv3LBCHowuI10dydEpU60xxUcp7Ka9f2OXEnWHQ4uwUxScfuLH0DXyL4ONugrfdoKDwnp8rE9zzd+bObTpKHdbzjcYtXjX73q0lu703LCKLPsRXa69BXig+gl0E3082BVD593WLAaoY0ngqAMVw8oVeE5GK7wcGdSCPhf5WIBwHbl4lIx03KuKRNLGjC8mzY1Tu4ihhIW/UWE4LH5z4hlsN+Fpe3g7Pbp2OMrvYF3dA0KVEuoQKxuH0gxj+K+f556MSPU1kasw8A4aeVf4InS6+ko2rBD1fuF3ZL7NBAvX5W+FhIDmn/RRNtVQI+cyB7B/9ySOPPAVAvsCWPYlb6btpbTKheHnvQ9j05/lwzuq7YnRKfw3frMU7m/T8HWv2lP2Hw5hk+5hNdLafeCHYRgv1o84EFJVVMbjZJahGvqsDJGGU+mbhjOG9IsvTxn+IPb/ZDMrHxZdIvotMk9q4Ae+qC/F6RIUYlPlSNRv+4CHIyInRqKGayuvZbBLJdUxKPTW5pGv3d7pn+pUUwtyabSqwyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 03:34:01PM +0900, Hajime Tazaki wrote:
> Introduce a kselftest utility to validate memory mapping capabilities
> under nommu kernels, aligned with
> Documentation/admin-guide/mm/nommu-mmap.rst.
>
> The test implements basic checks into a generic architecture-agnostic
> test matrix applicable across nommu targets. It evaluates:
>
> 1. MAP_FIXED allocation rejections.
> 2. Standard MAP_PRIVATE and MAP_ANONYMOUS allocation resilience.
> 3. MAP_UNINITIALIZED allocations via optional kernel configurations.
> 4. Regular file mappings via standard filesystem storage.
> 5. Memory-backed file mapping with /dev/zero
> 6. Block device subsystem mappings (gracefully skipping if node is
>    missing).
> 7. Shared vs Private backing discrepancies under nommu conditions.
> 8. mremap limits, ensuring non-expandable restrictions behave properly.

Thanks for adding these.

It's horrible to not have the kselftest harness for these, but as established,
fork() doesn't work for nommu (!)

A lot of these tests seem to relate to functionality I'm not really happy with
in the rest of the series so let's see how things pan out with the series
overall I guess!

>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: linux-kselftest@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-um@lists.infradead.org
> Assisted-by: Gemini:Pro [AI_Reviewer] [Sashiko_Linter]
> Assisted-by: cubic.dev:unspecified
> Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
> ---
>  tools/testing/selftests/mm/Makefile           |   3 +
>  tools/testing/selftests/mm/nommu_mmap_test.c  | 294 +++++++++
>  .../testing/selftests/mm/nommu_mremap_test.c  | 583 ++++++++++++++++++
>  3 files changed, 880 insertions(+)
>  create mode 100644 tools/testing/selftests/mm/nommu_mmap_test.c
>  create mode 100644 tools/testing/selftests/mm/nommu_mremap_test.c
>
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index e6df968f0971..3986ae7d75bc 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -185,6 +185,9 @@ TEST_FILES += run_vmtests.sh
>  # required by charge_reserved_hugetlb.sh
>  TEST_FILES += write_hugetlb_memory.sh
>
> +TEST_GEN_PROGS += nommu_mmap_test
> +TEST_GEN_PROGS += nommu_mremap_test
> +
>  include ../lib.mk
>
>  $(TEST_GEN_PROGS): vm_util.c hugepage_settings.c
> diff --git a/tools/testing/selftests/mm/nommu_mmap_test.c b/tools/testing/selftests/mm/nommu_mmap_test.c
> new file mode 100644
> index 000000000000..50ce385967f4
> --- /dev/null
> +++ b/tools/testing/selftests/mm/nommu_mmap_test.c
> @@ -0,0 +1,294 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <sys/mman.h>
> +#include <unistd.h>
> +#include <fcntl.h>
> +#include <errno.h>
> +#include <string.h>
> +#include <limits.h>
> +#include "../kselftest.h"
> +
> +#include <sys/vfs.h>
> +#ifndef RAMFS_MAGIC
> +#define RAMFS_MAGIC 0x858458f6
> +#endif
> +
> +#ifndef MAP_UNINITIALIZED
> +#define MAP_UNINITIALIZED 0x4000000
> +#endif
> +
> +static size_t ps;
> +
> +struct test_case_t {
> +	const char *name;
> +	const char *pathname;
> +	int open_flags;
> +	int mmap_prot;
> +	int mmap_flags;
> +	int exp_err;
> +	int (*resolve_exp_err)(const char *path);
> +};
> +
> +static int get_shm_expected_error(const char *path)
> +{
> +	struct statfs fs;
> +
> +	if (statfs(path, &fs) == 0) {
> +		if (fs.f_type == RAMFS_MAGIC)
> +			return 0; /* ramfs succeed with contiguous memory */
> +	}
> +	 /* hostfs, etc returns ENODEV due to lack of contiguous allocation */
> +	return ENODEV;
> +}
> +
> +static struct test_case_t test_cases[] = {
> +	{
> +		"Anonymous private allocation",
> +		NULL,
> +		O_CREAT | O_RDWR | O_EXCL,
> +		PROT_READ | PROT_WRITE,
> +		MAP_ANONYMOUS | MAP_PRIVATE,
> +		0,
> +		NULL,
> +	},
> +	{
> +		"Non-anonymous private file mapping (rw-)",
> +		"/tmp/ksft.nommu-reg-XXXXXX",
> +		O_CREAT | O_RDWR | O_EXCL,
> +		PROT_READ | PROT_WRITE,
> +		MAP_PRIVATE,
> +		0,
> +		0,
> +	},
> +	{
> +		"Non-anonymous private file mapping (r--)",
> +		"/tmp/ksft.nommu-reg-XXXXXX",
> +		O_CREAT | O_RDWR | O_EXCL,
> +		PROT_READ,
> +		MAP_PRIVATE,
> +		0,
> +		0,
> +	},
> +	{
> +		"Non-anonymous shared file mapping (rw-)",
> +		"/tmp/ksft.nommu-shm-XXXXXX",
> +		O_CREAT | O_RDWR | O_EXCL,
> +		PROT_READ | PROT_WRITE,
> +		MAP_SHARED,
> +		0,
> +#ifdef CONFIG_NOMMU
> +		get_shm_expected_error,
> +#else
> +		0,
> +#endif
> +	},
> +	{
> +		"Non-anonymous shared file mapping (r--)",
> +		"/tmp/ksft.nommu-shm-XXXXXX",
> +		O_CREAT | O_RDWR | O_EXCL,
> +		PROT_READ,
> +		MAP_SHARED,
> +		0,
> +#ifdef CONFIG_NOMMU
> +		get_shm_expected_error,
> +#else
> +		0,
> +#endif
> +	},
> +	{
> +		"Memory-backed private storage via /dev/zero",
> +		"/dev/zero",
> +		O_RDONLY,
> +		PROT_READ,
> +		MAP_PRIVATE,
> +		0,
> +		NULL,
> +	},
> +	{
> +		"Memory-backed storage via /dev/zero (MAP_SHARED)",
> +		"/dev/zero",
> +		O_RDONLY,
> +		PROT_READ,
> +		MAP_SHARED,
> +#ifdef CONFIG_NOMMU
> +		ENODEV,
> +#else
> +		0,
> +#endif
> +		NULL,
> +	},
> +	{
> +		"Block device volatile node mapping",
> +		"/dev/loop0",
> +		O_RDWR,
> +		PROT_READ | PROT_WRITE,
> +		MAP_PRIVATE,
> +		0,
> +		NULL,
> +	}
> +};
> +
> +static int run_mapping_matrix_test(struct test_case_t *tcase)
> +{
> +	int fd;
> +	void *ptr;
> +	char path_buf[PATH_MAX];
> +	int rc = KSFT_PASS;
> +	int expected_error;
> +
> +	ksft_print_msg("[RUN] Testing: %s\n", tcase->name);
> +
> +	if (tcase->pathname == NULL) {
> +		fd = -1;
> +	} else if (strstr(tcase->pathname, "XXXXXX")) {
> +		strncpy(path_buf, tcase->pathname, sizeof(path_buf) - 1);
> +		path_buf[sizeof(path_buf) - 1] = '\0';
> +		fd = mkstemp(path_buf);
> +		if (fd < 0) {
> +			ksft_test_result_skip("Failed to setup temp node: %s\n",
> +					      tcase->pathname);
> +			return KSFT_SKIP;
> +		}
> +		if (ftruncate(fd, ps) != 0) {
> +			ksft_test_result_fail("ftruncate failed for: %s\n",
> +					      tcase->pathname);
> +			close(fd);
> +			unlink(path_buf);
> +			return KSFT_FAIL;
> +		}
> +	} else {
> +		fd = open(tcase->pathname, tcase->open_flags, 0600);
> +		if (fd < 0) {
> +			ksft_test_result_skip("Device node not accessible: %s\n",
> +				       tcase->pathname);
> +			return KSFT_SKIP;
> +		}
> +	}
> +
> +	expected_error = tcase->exp_err;
> +	if (tcase->resolve_exp_err && fd >= 0)
> +		expected_error = tcase->resolve_exp_err(path_buf);
> +
> +	ptr = mmap(NULL, ps, tcase->mmap_prot, tcase->mmap_flags, fd, 0);
> +
> +	if (expected_error != 0) {
> +		if (ptr != MAP_FAILED) {
> +			ksft_test_result_fail("%s: mmap unexpectedly succeeded (exp error %d)\n",
> +					      tcase->name, expected_error);
> +			munmap(ptr, ps);
> +			rc = KSFT_FAIL;
> +			goto cleanup;
> +		}
> +		if (errno != expected_error) {
> +			ksft_test_result_fail("%s: mmap failed with %d (%s), but expected %d\n",
> +					      tcase->name, errno, strerror(errno), expected_error);
> +			rc = KSFT_FAIL;
> +			goto cleanup;
> +		}
> +		ksft_test_result_pass("%s: Correctly rejected with expected error %s(%d)\n",
> +				      tcase->name, strerror(expected_error), expected_error);
> +		rc = KSFT_PASS;
> +		goto cleanup;
> +	}
> +
> +	if (ptr == MAP_FAILED) {
> +		ksft_test_result_fail("%s: mmap failed unexpectedly: %s\n",
> +				      tcase->name, strerror(errno));
> +		rc = KSFT_FAIL;
> +		goto cleanup;
> +	}
> +
> +	ksft_test_result_pass("%s: mmap validation successfully passed\n", tcase->name);
> +	munmap(ptr, ps);
> +
> +cleanup:
> +	if (fd >= 0) {
> +		close(fd);
> +		if (tcase->pathname && strstr(tcase->pathname, "XXXXXX"))
> +			unlink(path_buf);
> +	}
> +	return rc;
> +}
> +
> +static int test_map_fixed(void)
> +{
> +	void *ptr = mmap((void *)(ps * 100), ps, PROT_READ | PROT_WRITE,
> +			 MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
> +
> +	ksft_print_msg("[RUN] Testing MAP_FIXED behavior\n");
> +
> +#ifdef CONFIG_NOMMU
> +	if (ptr == MAP_FAILED && (errno == ENODEV || errno == EINVAL)) {
> +		ksft_test_result_pass("MAP_FIXED correctly rejected under nommu\n");
> +		return KSFT_PASS;
> +	}
> +	if (ptr != MAP_FAILED) {
> +		ksft_test_result_fail("MAP_FIXED unexpectedly allowed under nommu\n");
> +		munmap(ptr, ps);
> +		return KSFT_FAIL;
> +	}
> +	ksft_test_result_fail("MAP_FIXED failed under NOMMU: %s\n",
> +			      strerror(errno));
> +	return KSFT_FAIL;
> +#else
> +	if (ptr != MAP_FAILED) {
> +		ksft_test_result_pass("MAP_FIXED successfully allocated under MMU\n");
> +		munmap(ptr, ps);
> +		return KSFT_PASS;
> +	}
> +	ksft_test_result_fail("MAP_FIXED failed allocation under MMU\n");
> +	return KSFT_FAIL;
> +#endif
> +}
> +
> +static int test_uninit(void)
> +{
> +	void *ptr = mmap(NULL, ps, PROT_READ | PROT_WRITE,
> +			 MAP_PRIVATE | MAP_ANONYMOUS | MAP_UNINITIALIZED, -1, 0);
> +
> +	ksft_print_msg("[RUN] Testing MAP_UNINITIALIZED behavior\n");
> +
> +	if (ptr == MAP_FAILED) {
> +		ksft_test_result_skip("MAP_UNINITIALIZED not supported by kernel config\n");
> +		return KSFT_SKIP;
> +	}
> +
> +	ksft_test_result_pass("MAP_UNINITIALIZED allocation successful\n");
> +	munmap(ptr, ps);
> +	return KSFT_PASS;
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	int result = KSFT_PASS;
> +	int i, rc;
> +
> +	ps = sysconf(_SC_PAGESIZE);
> +	ksft_print_header();
> +	ksft_set_plan(ARRAY_SIZE(test_cases) + 2);
> +
> +#ifdef CONFIG_NOMMU
> +	ksft_print_msg("Running strict MMAP test criteria under nommu architecture\n");
> +#else
> +	ksft_print_msg("Running MMAP test criteria under MMU architecture\n");
> +#endif
> +
> +	if (test_map_fixed() == KSFT_FAIL)
> +		result = KSFT_FAIL;
> +
> +	if (test_uninit() == KSFT_FAIL)
> +		result = KSFT_FAIL;
> +
> +	for (i = 0; i < (int)ARRAY_SIZE(test_cases); i++) {
> +		rc = run_mapping_matrix_test(&test_cases[i]);
> +		if (rc == KSFT_FAIL)
> +			result = KSFT_FAIL;
> +	}
> +
> +	if (result == KSFT_PASS)
> +		ksft_finished();
> +
> +	ksft_exit_fail();
> +}
> diff --git a/tools/testing/selftests/mm/nommu_mremap_test.c b/tools/testing/selftests/mm/nommu_mremap_test.c
> new file mode 100644
> index 000000000000..b1b8a4e64b55
> --- /dev/null
> +++ b/tools/testing/selftests/mm/nommu_mremap_test.c
> @@ -0,0 +1,583 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <sys/mman.h>
> +#include <unistd.h>
> +#include <fcntl.h>
> +#include <errno.h>
> +#include <string.h>
> +#include <limits.h>
> +#include "../kselftest.h"
> +
> +#include <sys/vfs.h>
> +#ifndef RAMFS_MAGIC
> +#define RAMFS_MAGIC 0x858458f6
> +#endif
> +
> +static size_t ps;
> +
> +static long get_fs_type(const char *path)
> +{
> +	struct statfs fs;
> +
> +	if (statfs(path, &fs) == 0)
> +		return fs.f_type;
> +
> +	return 0;
> +}
> +
> +/* return original value if succeed */
> +static int set_nr_trim_pages(const char *value)
> +{
> +	int fd, orig_value;
> +	ssize_t len, written, read_len;
> +	char orig_buf[32];
> +
> +	fd = open("/proc/sys/vm/nr_trim_pages", O_RDWR);
> +	if (fd < 0)
> +		return -errno;
> +
> +	read_len = read(fd, orig_buf, sizeof(orig_buf) - 1);
> +	if (read_len < 0) {
> +		close(fd);
> +		return -errno;
> +	}
> +	if (read_len == 0) {
> +		close(fd);
> +		return -EIO;
> +	}
> +
> +	orig_buf[read_len] = '\0';
> +	orig_value = atoi(orig_buf);
> +
> +	if (lseek(fd, 0, SEEK_SET) < 0) {
> +		close(fd);
> +		return -errno;
> +	}
> +
> +	len = strlen(value);
> +	written = write(fd, value, len);
> +	close(fd);
> +
> +	if (written != len)
> +		return written < 0 ? -errno : -EIO;
> +
> +	return orig_value >= 0 ? orig_value : -EINVAL;
> +}
> +
> +static void munmap_shrink_test(void)
> +{
> +	void *addr;
> +
> +	/* munmap shrink test */
> +	for (int i = 0; i < 4; i++) {
> +		addr = mmap(NULL, ps * 4, PROT_READ | PROT_WRITE,
> +			    MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> +		if (addr == MAP_FAILED) {
> +			ksft_test_result_fail("mmap failed: %s(%d)\n", strerror(errno), errno);
> +			return;
> +		}
> +		if (munmap(addr + ps * i, ps) != 0) {
> +			ksft_test_result_fail("memory %p isn't unmapped at %p\n",
> +					      addr, addr + ps * i);
> +			for (int j = 0; j < 4; j++)
> +				munmap((char *)addr + j * ps, ps);
> +			return;
> +		}
> +
> +		if (i == 0) {
> +			if (munmap(addr +  ps, ps * 3))
> +				goto error;
> +		} else if (i == 1) {
> +			if (munmap(addr, ps) || munmap(addr + (ps * 2), ps * 2))
> +				goto error;
> +		} else if (i == 2) {
> +			if (munmap(addr, ps * 2) || munmap(addr + (ps * 3), ps))
> +				goto error;
> +		} else if (i == 3) {
> +			if (munmap(addr, ps * 3))
> +				goto error;
> +		}
> +	}
> +
> +	ksft_test_result_pass("%s success\n", __func__);
> +	return;
> +error:
> +	for (int j = 0; j < 4; j++)
> +		munmap((char *)addr + j * ps, ps);
> +	ksft_test_result_fail("%s clean up failures\n", __func__);
> +}
> +
> +static size_t page_align(size_t len)
> +{
> +	return (len + ps - 1) / ps * ps;
> +}
> +
> +static void mremap_shrink_test(void)
> +{
> +	void *addr, *addr2;
> +	size_t current_len;
> +	size_t old_len, new_len;
> +	struct param {
> +		size_t old;
> +		size_t new;
> +	} params[] = {
> +		/* should not happen any shrink */
> +		{ .old = ps * 4 - 1, .new = ps * 4 - 2 },
> +		/* should not happen any shrink */
> +		{ .old = ps * 4 - 1, .new = ps * 4 },
> +		{ .old = ps * 4, .new = ps * 2 },
> +		/* should not happen any shrink */
> +		{ .old = ps * 2, .new = ps * 2 - 2 },
> +		{ .old = ps * 2 - 2, .new = ps * 1 },
> +	};
> +
> +	/* mremap shrink test */
> +	current_len = page_align(ps * 4 - 1);
> +	addr = mmap(NULL, ps * 4 - 1, PROT_READ | PROT_WRITE,
> +		    MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> +	if (addr == MAP_FAILED) {
> +		ksft_test_result_fail("mmap failed: %s(%d)\n", strerror(errno), errno);
> +		return;
> +	}
> +
> +	for (int i = 0; i < ARRAY_SIZE(params); i++) {
> +		old_len = page_align(params[i].old);
> +		new_len = page_align(params[i].new);
> +		addr2 = mremap(addr, old_len, new_len, MREMAP_MAYMOVE);
> +		if (addr2 == MAP_FAILED) {
> +			ksft_test_result_fail("memory %p isn't remapped at %p\n", addr, addr2);
> +			munmap(addr, old_len);
> +			return;
> +		}
> +
> +		addr = addr2;
> +		current_len = new_len;
> +	}
> +
> +	if (munmap(addr, current_len)) {
> +		ksft_test_result_fail("%s cleanup failed: %s\n",
> +				      __func__, strerror(errno));
> +		return;
> +	}
> +	ksft_test_result_pass("%s success\n", __func__);
> +}
> +
> +static void zero_middle_munmap_test(void)
> +{
> +	int fd = -1;
> +	void *addr = MAP_FAILED;
> +	void *addr2 = MAP_FAILED;
> +	int left_mapped = 0;
> +	int right_mapped = 0;
> +	int ret;
> +	bool addr2_middle_unmapped = false;
> +
> +	ksft_print_msg("[RUN] Testing middle munmap of private /dev/zero mappings\n");
> +
> +	fd = open("/dev/zero", O_RDONLY);
> +	if (fd < 0) {
> +		ksft_test_result_skip("Unable to open /dev/zero: %s\n",
> +				      strerror(errno));
> +		return;
> +	}
> +
> +	addr = mmap(NULL, ps * 3, PROT_READ | PROT_WRITE,
> +		    MAP_PRIVATE, fd, 0);
> +	close(fd);
> +	fd = -1;
> +	if (addr == MAP_FAILED) {
> +		ksft_test_result_fail("Initial /dev/zero mmap failed: %s\n",
> +				      strerror(errno));
> +		return;
> +	}
> +
> +	left_mapped = 1;
> +	right_mapped = 1;
> +
> +	/*
> +	 * Split one private /dev/zero VMA in the middle. On nommu, the
> +	 * VMA still has vm_file set even though it is semantically
> +	 * anonymous.
> +	 */
> +	ret = munmap((char *)addr + ps, ps);
> +	if (ret) {
> +		ksft_test_result_fail("Middle munmap failed: %s\n",
> +				      strerror(errno));
> +		munmap(addr, ps * 3);
> +		left_mapped = 0;
> +		right_mapped = 0;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Access both remaining VMAs so a stale VMA interval cannot remain
> +	 * hidden behind the unmapped hole.
> +	 */
> +	((volatile unsigned char *)addr)[0] = 0x5a;
> +	((volatile unsigned char *)addr + 2 * ps)[0] = 0xa5;
> +
> +	/*
> +	 * Repeat the operation on another mapping of the same inode. This
> +	 * exercises insertion and removal in /dev/zero's i_mmap interval
> +	 * tree after the first split.
> +	 */
> +	fd = open("/dev/zero", O_RDONLY);
> +	if (fd < 0) {
> +		ksft_test_result_fail("Reopening /dev/zero failed: %s\n",
> +				      strerror(errno));
> +		goto out;
> +	}
> +
> +	addr2 = mmap(NULL, ps * 3, PROT_READ | PROT_WRITE,
> +		     MAP_PRIVATE, fd, 0);
> +	close(fd);
> +	fd = -1;
> +	if (addr2 == MAP_FAILED) {
> +		ksft_test_result_fail("Second /dev/zero mmap failed: %s\n",
> +				      strerror(errno));
> +		goto out;
> +	}
> +
> +	ret = munmap((char *)addr2 + ps, ps);
> +	if (ret) {
> +		ksft_test_result_fail("Second middle munmap failed: %s\n",
> +				      strerror(errno));
> +		goto out;
> +	}
> +	addr2_middle_unmapped = true;
> +
> +	if (munmap(addr, ps)) {
> +		ksft_test_result_fail("Left VMA munmap failed: %s\n",
> +				      strerror(errno));
> +		goto out;
> +	}
> +	left_mapped = 0;
> +
> +	if (munmap((char *)addr + 2 * ps, ps)) {
> +		ksft_test_result_fail("Right VMA munmap failed: %s\n",
> +				      strerror(errno));
> +		goto out;
> +	}
> +	right_mapped = 0;
> +
> +	if (munmap(addr2, ps)) {
> +		ksft_test_result_fail("Second left VMA munmap failed: %s\n",
> +				      strerror(errno));
> +		goto out;
> +	}
> +
> +	if (munmap((char *)addr2 + 2 * ps, ps)) {
> +		ksft_test_result_fail("Second right VMA munmap failed: %s\n",
> +				      strerror(errno));
> +		goto out;
> +	}
> +	addr2 = MAP_FAILED;
> +
> +	ksft_test_result_pass("%s success\n", __func__);
> +
> +out:
> +	if (fd >= 0)
> +		close(fd);
> +	if (left_mapped)
> +		munmap(addr, ps);
> +	if (right_mapped)
> +		munmap((char *)addr + 2 * ps, ps);
> +	if (addr2 != MAP_FAILED) {
> +		if (addr2_middle_unmapped) {
> +			munmap(addr2, ps);
> +			munmap((char *)addr2 + 2 * ps, ps);
> +		} else {
> +			/* The middle munmap failed, so all three pages remain mapped. */
> +			munmap(addr2, ps * 3);
> +		}
> +	}
> +}
> +
> +static int get_shared_writable_file_expected_error(const char *path)
> +{
> +	if (get_fs_type(path) == RAMFS_MAGIC)
> +		return EPERM; /* ramfs failed */
> +
> +	return 0;
> +}
> +
> +static int pre_conf_trim_page(void)
> +{
> +	return set_nr_trim_pages("0\n");
> +}
> +
> +static int post_conf_trim_page(int value)
> +{
> +	char buf[32];
> +
> +	if (snprintf(buf, sizeof(buf), "%d\n", value) < 0)
> +		return -EIO;
> +
> +	return set_nr_trim_pages(buf);
> +}
> +
> +struct mremap_case_t {
> +	const char *name;
> +	const char *pathname;
> +	int open_flags;
> +	int mmap_prot;
> +	int mmap_flags;
> +	int exp_err;
> +	int (*resolve_exp_err)(const char *path);
> +	unsigned int old_pages;
> +	unsigned int new_pages;
> +	int (*pre_hook)(void);
> +	int (*post_hook)(int value);
> +};
> +
> +static struct mremap_case_t mremap_cases[] = {
> +	{
> +		.name = "anonymous shrink (r--)",
> +		.pathname = NULL,
> +		.open_flags = O_CREAT | O_RDWR | O_EXCL,
> +		.mmap_prot = PROT_READ,
> +		.mmap_flags = MAP_ANONYMOUS | MAP_PRIVATE,
> +		.exp_err = 0,
> +		.resolve_exp_err = 0,
> +	},
> +	{
> +		.name = "shared file shrink (r--)",
> +		.pathname = "/tmp/ksft.nommu-remap-XXXXXX",
> +		.open_flags = O_CREAT | O_RDWR | O_EXCL,
> +		.mmap_prot = PROT_READ,
> +		.mmap_flags = MAP_SHARED,
> +		.exp_err = 0,
> +#ifdef CONFIG_NOMMU
> +		.resolve_exp_err = get_shared_writable_file_expected_error,
> +#else

Hmm aren't these all nommu tests anyway?

> +		.resolve_exp_err = 0,
> +#endif
> +	},
> +	{
> +		.name = "zero device shrink (r--)",
> +		.pathname = "/dev/zero",
> +		.open_flags = O_RDONLY,
> +		.mmap_prot = PROT_READ,
> +		.mmap_flags = MAP_PRIVATE,
> +		.exp_err = 0,
> +		.resolve_exp_err = 0,
> +	},
> +	{
> +		.name = "private file unchanged length (r-)",
> +		.pathname = "/tmp/ksft.nommu-remap-XXXXXX",
> +		.open_flags = O_CREAT | O_RDWR | O_EXCL,
> +		.mmap_prot = PROT_READ,
> +		.mmap_flags = MAP_PRIVATE,
> +#ifdef CONFIG_NOMMU
> +		.exp_err = EPERM,
> +#else
> +		.exp_err = 0,
> +#endif
> +		.resolve_exp_err = 0,
> +		.old_pages = 4,
> +		.new_pages = 4,
> +	},
> +	{
> +		.name = "private file unchanged length (rw-)",
> +		.pathname = "/tmp/ksft.nommu-remap-XXXXXX",
> +		.open_flags = O_CREAT | O_RDWR | O_EXCL,
> +		.mmap_prot = PROT_READ | PROT_WRITE,
> +		.mmap_flags = MAP_PRIVATE,
> +		.exp_err = 0,
> +		.resolve_exp_err = 0,
> +		.old_pages = 4,
> +		.new_pages = 4,
> +	},
> +	{
> +		.name = "private file growth (r-)",
> +		.pathname = "/tmp/ksft.nommu-remap-XXXXXX",
> +		.open_flags = O_CREAT | O_RDWR | O_EXCL,
> +		.mmap_prot = PROT_READ,
> +		.mmap_flags = MAP_PRIVATE,
> +#ifdef CONFIG_NOMMU
> +		.exp_err = EPERM,
> +#else
> +		.exp_err = 0,
> +#endif
> +		.resolve_exp_err = 0,
> +		.old_pages = 4,
> +		.new_pages = 8,
> +	},
> +	{
> +		.name = "private file growth with reserved capacity (rw-)",
> +		.pathname = "/tmp/ksft.nommu-remap-XXXXXX",
> +		.open_flags = O_CREAT | O_RDWR | O_EXCL,
> +		.mmap_prot = PROT_READ | PROT_WRITE,
> +		.mmap_flags = MAP_PRIVATE,
> +		.exp_err = 0,
> +		.resolve_exp_err = 0,
> +		.old_pages = 3,
> +		.new_pages = 4,
> +#ifdef CONFIG_NOMMU
> +		.pre_hook = pre_conf_trim_page,
> +		.post_hook = post_conf_trim_page,
> +#endif
> +	},
> +	{
> +		.name = "private file growth (rw-)",
> +		.pathname = "/tmp/ksft.nommu-remap-XXXXXX",
> +		.open_flags = O_CREAT | O_RDWR | O_EXCL,
> +		.mmap_prot = PROT_READ | PROT_WRITE,
> +		.mmap_flags = MAP_PRIVATE,
> +#ifdef CONFIG_NOMMU
> +		.exp_err = ENOMEM,
> +#else
> +		.exp_err = 0,
> +#endif
> +		.resolve_exp_err = 0,
> +		.old_pages = 4,
> +		.new_pages = 8,
> +	},
> +};
> +
> +static int run_mremap_test(struct mremap_case_t *tcase)
> +{
> +	int fd = -1;
> +	void *addr, *addr2;
> +	char pb[PATH_MAX];
> +	int rc = KSFT_PASS;
> +	int expected_error;
> +	unsigned int old_pages = tcase->old_pages ?: 4;
> +	unsigned int new_pages = tcase->new_pages ?: 2;
> +	unsigned int file_pages = old_pages > new_pages ?
> +				  old_pages : new_pages;
> +	int orig_nr_trip_pages = -1;
> +
> +	ksft_print_msg("[RUN] Testing mremap: %s\n", tcase->name);
> +
> +	if (tcase->pathname && strstr(tcase->pathname, "XXXXXX")) {
> +		strncpy(pb, tcase->pathname, sizeof(pb) - 1);
> +		pb[sizeof(pb) - 1] = '\0';
> +		fd = mkstemp(pb);
> +		if (fd < 0) {
> +			ksft_test_result_skip("Failed to setup file backing\n");
> +			return KSFT_SKIP;
> +		}
> +		if (ftruncate(fd, ps * file_pages) != 0) {
> +			ksft_test_result_fail("Failed to setup file backing\n");
> +			close(fd);
> +			unlink(pb);
> +			return KSFT_FAIL;
> +		}
> +
> +		if ((tcase->mmap_flags & MAP_SHARED) && get_fs_type(pb) != RAMFS_MAGIC) {
> +			ksft_test_result_skip("Skip the test under non-ramfs filesystem (%s)\n",
> +					      pb);
> +			close(fd);
> +			unlink(pb);
> +			return KSFT_SKIP;
> +		}
> +	} else if (tcase->pathname) {
> +		fd = open(tcase->pathname, tcase->open_flags, 0600);
> +		if (fd < 0) {
> +			ksft_test_result_skip("Backing node not accessible\n");
> +			return KSFT_SKIP;
> +		}
> +
> +		if ((tcase->mmap_flags & MAP_SHARED) &&
> +		    get_fs_type(tcase->pathname) != RAMFS_MAGIC) {
> +			ksft_test_result_skip("Skip the test under non-ramfs filesystem (%s)\n",
> +					      tcase->pathname);
> +			close(fd);
> +			return KSFT_SKIP;
> +		}
> +	}
> +
> +	if (tcase->pre_hook) {
> +		orig_nr_trip_pages = tcase->pre_hook();
> +		if (orig_nr_trip_pages < 0) {
> +			ksft_print_msg("pre-hook failed %s(%d)\n",
> +					    strerror(errno), errno);
> +			rc = KSFT_FAIL;
> +			goto out;
> +		}
> +	}
> +
> +	addr = mmap(NULL, ps * old_pages, tcase->mmap_prot,
> +		    tcase->mmap_flags, fd, 0);
> +	if (addr == MAP_FAILED) {
> +		ksft_print_msg("mmap mapping failed %s(%d)\n", strerror(errno), errno);
> +		rc = KSFT_FAIL;
> +		goto out;
> +	}
> +
> +	expected_error = tcase->exp_err;
> +	if (tcase->resolve_exp_err && fd >= 0)
> +		expected_error = tcase->resolve_exp_err(pb);
> +
> +	addr2 = mremap(addr, ps * old_pages, ps * new_pages,
> +		       MREMAP_MAYMOVE);
> +
> +	if (expected_error != 0) {
> +		if (addr2 != MAP_FAILED || errno != expected_error) {
> +			ksft_print_msg("Expected error %d, got %s(%d)\n",
> +				       expected_error, strerror(errno), errno);
> +			rc = KSFT_FAIL;
> +		} else {
> +			ksft_print_msg("%s/%s: Handled expected error path (errno=%d)\n",
> +				       __func__, tcase->name, expected_error);
> +		}
> +	} else if (addr2 == MAP_FAILED) {
> +		ksft_print_msg("mremap shrink failed unexpectedly: %s\n",
> +			       strerror(errno));
> +		rc = KSFT_FAIL;
> +	} else {
> +		ksft_print_msg("%s/%s step successful\n", __func__, tcase->name);
> +	}
> +
> +	/* clean up */
> +	if (munmap(addr2 == MAP_FAILED ? addr : addr2,
> +		   addr2 == MAP_FAILED ? ps * old_pages : ps * new_pages)) {
> +		ksft_print_msg("munmap failed: %s\n", strerror(errno));
> +		rc = KSFT_FAIL;
> +	}
> +
> +out:
> +	if (fd >= 0) {
> +		close(fd);
> +		if (tcase->pathname && strstr(tcase->pathname, "XXXXXX"))
> +			unlink(pb);
> +	}
> +
> +	if (tcase->post_hook) {
> +		if (tcase->post_hook(orig_nr_trip_pages) < 0) {
> +			ksft_print_msg("post-hook failed %s(%d)\n",
> +				       strerror(errno), errno);
> +			rc = KSFT_FAIL;
> +		}
> +	}
> +
> +	ksft_test_result_report(rc, "%s:%s\n", __func__, tcase->name);
> +	return rc;
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	int res = KSFT_PASS;
> +	int i;
> +
> +	ps = sysconf(_SC_PAGESIZE);
> +	ksft_print_header();
> +	ksft_set_plan(ARRAY_SIZE(mremap_cases) + 3);
> +
> +	munmap_shrink_test();
> +	mremap_shrink_test();
> +	zero_middle_munmap_test();
> +
> +	for (i = 0; i < (int)ARRAY_SIZE(mremap_cases); i++) {
> +		if (run_mremap_test(&mremap_cases[i]) == KSFT_FAIL)
> +			res = KSFT_FAIL;
> +	}
> +
> +	if (res == KSFT_PASS)
> +		ksft_finished();
> +
> +	ksft_exit_fail();
> +}
> --
> 2.43.0
>

--
Cheers, Lorenzo

