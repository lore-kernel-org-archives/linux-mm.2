Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AD9ACCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 23:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81AD28E0098; Wed, 15 Oct 2025 19:18:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F2A28E000C; Wed, 15 Oct 2025 19:18:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72F6C8E0098; Wed, 15 Oct 2025 19:18:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 613868E000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 19:18:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6886136246
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 23:18:14 +0000 (UTC)
X-FDA: 84001914108.30.9BA278D
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id B04D018000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 23:18:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W38opNAC;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760570293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0uBjbFB8TPeE1gahyDYnX1z/Z4HIYIQ/tWnWdhuezaM=;
	b=ApCcWoK6hj4ycvghiS/bUVUwpzHKZ5t4b3TWT+HyDOEDxNPtnsePxvrz+E8r0uM4b9bekw
	XOQ2VRSZIbSEI36M9QOCYm1ZiFiwIwsYLNS5miQG8znsE0BwnrYzeZ9HqhOdSm9ENkT3/j
	c3KI48LoP/v4GprFA6IsU6NC2uY5tJ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760570293; a=rsa-sha256;
	cv=none;
	b=kU+f/NbdfigKRzb7ywi7LVvz5rpTKEDZrUdtVJNR2Y3IqpOIRbg8yQetIqPgm1Erie1pQT
	+j8jPlfnTg04GeExule+nWPlR9s9cxYaVvCl3503DCAQHXNWj0KnrpGj7ze8JdKFA57nYJ
	vkPPOqfLVpnbVYWoHMJrbSs8/Vn4jJQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W38opNAC;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 15 Oct 2025 16:17:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760570287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0uBjbFB8TPeE1gahyDYnX1z/Z4HIYIQ/tWnWdhuezaM=;
	b=W38opNACFB8YHAPsyJLA+361VAldOqeOmEf4d1uSLMK8ck0qLB3TyQP1pkt54brWK1S5x4
	X2FawelaGsALDLREBoxrMz8KTm1+BIle9V6op6NJYEtYyIwPj7czciZDzafnmcVBx5CaL4
	Da+iDlZwjWZl5uPjlZCU5ZVOrkLoUYk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: JP Kobryn <inwardvessel@gmail.com>
Cc: andrii@kernel.org, ast@kernel.org, mkoutny@suse.com, 
	yosryahmed@google.com, hannes@cmpxchg.org, tj@kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] memcg: selftests for memcg stat kfuncs
Message-ID: <3lhd7qnv425xhj6ivbjxeecybkzid3tfjegnk77kdydmkldnzw@6r4lj7jmpupc>
References: <20251015190813.80163-1-inwardvessel@gmail.com>
 <20251015190813.80163-3-inwardvessel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015190813.80163-3-inwardvessel@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: dt4e51utgf3ws7morybb7qiohk5yshb7
X-Rspam-User: 
X-Rspamd-Queue-Id: B04D018000A
X-HE-Tag: 1760570292-832245
X-HE-Meta: U2FsdGVkX18fC47EuA6jDtw+1wUVI9LGj4F14LasRo37bmehmIHwwdylpF/JA4oxvkLPVGw1YwZcPuvJG4HMR8X6lOcq381vaG4sII/q6xvuUndFeCnZNpyhnXmuf5Xqpfq1/EBrdiDwpCi8+fmuO3Wzo5dOQZzx6AmcgntMrtRjvyFVneNPCLiPxNoZwa08AJqK3YJbFxO1LD3InWGVLDRX511hBbgiS8yBkNAtzbpJVQk0Dlr8P4cvjOfVh4koNJOXxPgqI08wMnrpbMsw/sgB+4+4W3hN1svpUh23bmYDU35UxNk8UNul+PHbK9mEFhoWeJLQhCRNGME9wpkRUW+IOQlnV/Dz1yWs3ykd08WvOBtqtLehJa/GY2EiOC737SAC6c7g5g8Y2Credx5O/uZa7aJyvC7+SJUKxGLYL+H1xWO7d83hMfHrnuqpgEPKHXqDtx9ndJNVT+3Cwlat2E/INHtT/9ULZhxE61XJsays3a8ibcEoUq4zk5mlY4XmrTclP1Kb1TMoKSX1Rxgpobvy7B44uIq9o2ohEdfNwis4/wojGgVoCWzi5TgIrN3O+UcWj8ExxMq42fW7N87BJ9SWfJ7jpPr4fzXtZ9XdEYUTFY01E74pSzw5+O5UxuE5D4T6bde3Avvk2s51pH7P5IQ4xE0+0Sl+2vJ4UWx0beUInDPonbNP/GgkkJUgfkqA5lGuNA9Xl0+Ua94qH5WmVm7+nh27EkKoin9jNIfSgCmT40flDYMawjAww2CCfeLXv5x0aVR2JxYzya79kZcbsun8pGR8butlCXw+rJDmdTZfzzX1bGorazFkomDbBVoCwCOzGBuiIqVuA5PPFb0kVVoSCHuVUYckeMqVtvQ1kAnHK+LaiuK7Ssj2dOjH3KRnIz+g08HGuZ1nw1sAWXoi6TTzlxelZ1P6QZqQRiufZr9MFXlfoPRZz7jWHrpab2VwngfCwNOeZIxFVcDx+Bf
 j9OFg1kn
 IQ7PnG5L/XtsJxxF0CAqzYAGids2hUcVqZEGggMe1Np/A1hFy3wKWF/o5UZhgqUdEE9qDZd+YgUeMF156Wz8QsGPHnPb31A/ikptudG5dGtFYLdLaSs1UToQJAJN8AvUFNO5a6PYYv7M0hKe2amsR5CJahl3UfdHScmh33ueCcCyziFYcFXVupCciJkuZYRkUWZIolYCKPLOMYxStrO/hFwx8DSvqTEWdOsaudwHj8NR7UE65a5ahi87oB66jkk8tIhRNWEVJqpqwmvA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 12:08:13PM -0700, JP Kobryn wrote:
> Add test coverage for the kfuncs that fetch memcg stats. Using some common
> stats, test before and after scenarios ensuring that the given stat
> increases by some arbitrary amount. The stats selected cover the three
> categories represented by the enums: node_stat_item, memcg_stat_item,
> vm_event_item.
> 
> Since only a subset of all stats are queried, use a static struct made up
> of fields for each stat. Write to the struct with the fetched values when
> the bpf program is invoked and read the fields in the user mode program for
> verification.
> 
> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
> ---
>  .../testing/selftests/bpf/cgroup_iter_memcg.h |  18 ++
>  .../bpf/prog_tests/cgroup_iter_memcg.c        | 295 ++++++++++++++++++
>  .../selftests/bpf/progs/cgroup_iter_memcg.c   |  61 ++++
>  3 files changed, 374 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/cgroup_iter_memcg.h
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
>  create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c
> 
> diff --git a/tools/testing/selftests/bpf/cgroup_iter_memcg.h b/tools/testing/selftests/bpf/cgroup_iter_memcg.h
> new file mode 100644
> index 000000000000..5f4c6502d9f1
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/cgroup_iter_memcg.h
> @@ -0,0 +1,18 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
> +#ifndef __CGROUP_ITER_MEMCG_H
> +#define __CGROUP_ITER_MEMCG_H
> +
> +struct memcg_query {
> +	/* some node_stat_item's */
> +	long nr_anon_mapped;
> +	long nr_shmem;
> +	long nr_file_pages;
> +	long nr_file_mapped;
> +	/* some memcg_stat_item */
> +	long memcg_kmem;
> +	/* some vm_event_item */
> +	long pgfault;
> +};
> +
> +#endif /* __CGROUP_ITER_MEMCG_H */
> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
> new file mode 100644
> index 000000000000..264dc3c9ec30
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
> @@ -0,0 +1,295 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
> +#include <test_progs.h>
> +#include <bpf/libbpf.h>
> +#include <bpf/btf.h>
> +#include <fcntl.h>
> +#include <sys/mman.h>
> +#include <unistd.h>
> +#include "cgroup_helpers.h"
> +#include "cgroup_iter_memcg.h"
> +#include "cgroup_iter_memcg.skel.h"
> +
> +int read_stats(struct bpf_link *link)
> +{
> +	int fd, ret = 0;
> +	ssize_t bytes;
> +
> +	fd = bpf_iter_create(bpf_link__fd(link));

Do we need to create a new fd for every new stat read? Is there lseek()
like approach possible here?

> +	if (!ASSERT_OK_FD(fd, "bpf_iter_create"))
> +		return 1;
> +
> +	/*
> +	 * Invoke iter program by reading from its fd. We're not expecting any
> +	 * data to be written by the bpf program so the result should be zero.
> +	 * Results will be read directly through the custom data section
> +	 * accessible through skel->data_query.memcg_query.
> +	 */
> +	bytes = read(fd, NULL, 0);
> +	if (!ASSERT_EQ(bytes, 0, "read fd"))
> +		ret = 1;
> +
> +	close(fd);
> +	return ret;
> +}
> +

[...]

> +static void test_shmem(struct bpf_link *link,
> +		struct memcg_query *memcg_query)
> +{
> +	size_t len;
> +	int fd;
> +	void *map;
> +	long val;
> +
> +	len = sysconf(_SC_PAGESIZE) * 1024;
> +
> +	if (!ASSERT_OK(read_stats(link), "read stats"))
> +		return;
> +
> +	val = memcg_query->nr_shmem;
> +	if (!ASSERT_GE(val, 0, "init shmem val"))
> +		return;
> +
> +	/*
> +	 * Increase memcg shmem usage by creating and writing
> +	 * to a shmem object.
> +	 */
> +	fd = shm_open("/tmp_shmem", O_CREAT | O_RDWR, 0644);
> +	if (!ASSERT_OK_FD(fd, "shm_open"))
> +		return;
> +
> +	if (!ASSERT_OK(ftruncate(fd, len), "ftruncate"))
> +		goto cleanup_fd;
> +
> +	map = mmap(NULL, len, PROT_READ | PROT_WRITE,
> +			MAP_SHARED, fd, 0);

You don't need to mmap(), you can just fallocate() or simply write to
increase shmem stats.

> +	if (!ASSERT_NEQ(map, MAP_FAILED, "mmap shmem"))
> +		goto cleanup_fd;
> +
> +	memset(map, 1, len);
> +
> +	if (!ASSERT_OK(read_stats(link), "read stats"))
> +		goto cleanup_map;
> +
> +	ASSERT_GT(memcg_query->nr_shmem, val, "final shmem value");
> +
> +cleanup_map:
> +	munmap(map, len);
> +cleanup_fd:
> +	close(fd);
> +	shm_unlink("/tmp_shmem");
> +}
> +
> +static void test_kmem(struct bpf_link *link,
> +		struct memcg_query *memcg_query)
> +{
> +	int fds[2];
> +	int err;
> +	ssize_t bytes;
> +	size_t len;
> +	char *buf;
> +	long val;
> +
> +	len = sysconf(_SC_PAGESIZE) * 1024;
> +
> +	if (!ASSERT_OK(read_stats(link), "read stats"))
> +		return;
> +
> +	val = memcg_query->memcg_kmem;
> +	if (!ASSERT_GE(val, 0, "initial kmem val"))
> +		return;
> +
> +	err = pipe2(fds, O_NONBLOCK);

You will need to create a bit more of these cause the kernel memory
stats to be updated due to per-cpu memcg stock caching kmem stats.

> +	if (!ASSERT_OK(err, "pipe"))
> +		return;
> +
> +	buf = malloc(len);
> +	memset(buf, 1, len);
> +	bytes = write(fds[1], buf, len);
> +	if (!ASSERT_GT(bytes, 0, "write"))
> +		goto cleanup;
> +
> +	if (!ASSERT_OK(read_stats(link), "read stats"))
> +		goto cleanup;
> +
> +	ASSERT_GT(memcg_query->memcg_kmem, val, "kmem value");
> +
> +cleanup:
> +	free(buf);
> +	close(fds[0]);
> +	close(fds[1]);
> +}
> +

