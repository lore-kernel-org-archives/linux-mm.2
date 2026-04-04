Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9519E63FE5
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 17:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A48116B0088; Sat,  4 Apr 2026 13:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F89C6B0089; Sat,  4 Apr 2026 13:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90E776B008A; Sat,  4 Apr 2026 13:53:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 840756B0088
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 13:53:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D9B42BBA39
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 17:53:56 +0000 (UTC)
X-FDA: 84621621672.05.937E4E9
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id DD25C180007
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 17:53:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mN8FEh5q;
	spf=pass (imf16.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775325235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D9/n0xOrVIg4JzXNz87bIfUmI/ls7SmA5Keb0MGw30A=;
	b=NcgL4/vKgeiC0n7p1duShti2liTbSW6Lhw/7zqTKGyBmdJ+WnHvcNwA/yycav2TlntjmPR
	audSQx6h+Esn36TdpAluzGpphHF1CNivCPX2cvylTGKMNpoWCSlJYRfMpxoRwca6ZSafww
	3EGbSA+g03pJTvp24Y6d5myp4YaErM0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mN8FEh5q;
	spf=pass (imf16.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775325235; a=rsa-sha256;
	cv=none;
	b=twc2yPCC15PV2A+FzcEmYLKCFSAkkwqAX/WYJrMijZzXw+O7ULgPU9hbMg11eW7rbQbAku
	WJSVQaBHfJQS9RByGPUhnuUNBFTcwnsU9xX6HDVSc7zAGELsdWG+S4WY1jcykWb709jzHd
	5zflm0aT2RsDp65raLovkk7AH6zrx4o=
Message-ID: <c783bc1b-3327-422f-9191-11550513b13c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775325232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D9/n0xOrVIg4JzXNz87bIfUmI/ls7SmA5Keb0MGw30A=;
	b=mN8FEh5qtk/m7/N1JG0dCSTSUfbBYtfsGQLC016NC56eKf8FDTo54FA5xQa6vXB7CU6IIE
	+/5t19o4gpNyK3Ns7deKkwEODR7xY81tgJM09f5N8YduC8lZjx73YRa/uKDjaQUGxB5pl0
	ahysqUd6FYgcWlEVpEanB9b76mME9ZI=
Date: Sat, 4 Apr 2026 10:53:47 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v3 2/6] selftests/liveupdate: add helper functions for
 memfd tests
To: Pratyush Yadav <pratyush@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>,
 Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <20260404102452.4091740-1-pratyush@kernel.org>
 <20260404102452.4091740-3-pratyush@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260404102452.4091740-3-pratyush@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: zfp9tc71xzuhw3z453963p7ziwyfdi65
X-Rspamd-Queue-Id: DD25C180007
X-Rspamd-Server: rspam09
X-HE-Tag: 1775325234-496766
X-HE-Meta: U2FsdGVkX1/+1K6OBilbvccFJ/3QjD3Cuu/7hwNyGa6ICWWMmQ5HSlLhMcVicJoHRx6JbhH+ZijVM4pRXIUhLdXnQ7SuPa4EuUTLAGJoPKC72uvLE9DQFodlcUe+C3JA1/UAs8qSmmCXpb2os/r7JrfP782/8apic73ViNIDTl3RZP92x2m4a6eJ5ub7hWHYhA56mNhxB4U2zJ5tJzr9ABbPgacNQC/DpT0CAyWwQN84VXTnJOrs5I4L3r4dgsHT1UNP0bHX0Yb/hVztbUVP5RhnVpsNVtE84Iz/pg51uiVOFwLYJRTbNrVxspPIXf3bF8poGV0nR6sO6TMMUY5qGmr9JYOCFgTBhnp6WrCu6DqRQA3cutB+cxtYjAgEqNw5DPaiUb0ZRfbtWXGRfFc6+vxNpYuchR1Jo+g0kdv4OeN0/muAOyvB4kknJ8ldThbHqddFcagN81LeffVe5v0KLgxsHcUhbZ3G5KvhFWA/UnqujZNSxE4i3omIuObF8Gw4hD7qSuSO0DJWDLlv8cDyHHuOOxflSl2RwlZQBTrOhHhwIXpZFd4v6JQ1oPoaUqmjIYvZPV7kdJfg7GlvqcVuE/3vbeN283Gwfe65RyRt7VV3KH3XQF/eIhWrj6lfdT084sPXrldsgo6bLk26v2h2E6ZBSRf+wWJo0d+wGL12bm8zdCHY14XCzdPZ/cKfwSgfW5hDdwP8DqGn4flr7x+g6VOjftQ4XFM7FKz81dGR/ZrEmDTpZXC0EprloPhogB/lFFs3UYeIpm/YhAWW6t1KfyspMSK/sa89Gp+ly7eoUT95KotQHHPGeQNO/W9gO1Ts+H/6e9ERM+A/fmmi8VkrAuTiXhM5e2zwFboQ65VGemXkUHuTKBA35Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/4/4 3:24, Pratyush Yadav 写道:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Add some helper functions that will be used by memfd tests. This moves
> some of the complexity out of the test itself, which results in better
> test readability and less code duplication.
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>   .../selftests/liveupdate/luo_test_utils.c     | 191 +++++++++++++++++-
>   .../selftests/liveupdate/luo_test_utils.h     |  10 +
>   2 files changed, 200 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/luo_test_utils.c
> index 3c8721c505df..ceb918ef9813 100644
> --- a/tools/testing/selftests/liveupdate/luo_test_utils.c
> +++ b/tools/testing/selftests/liveupdate/luo_test_utils.c
> @@ -1,8 +1,12 @@
>   // SPDX-License-Identifier: GPL-2.0-only
>   
>   /*
> - * Copyright (c) 2025, Google LLC.
> + * Copyright (c) 2025-2026, Google LLC.
>    * Pasha Tatashin <pasha.tatashin@soleen.com>
> + * Pratyush Yadav (Google) <pratyush@kernel.org>
> + *
> + * Copyright (C) 2025 Amazon.com Inc. or its affiliates.
> + * Pratyush Yadav <ptyadav@amazon.de>
>    */
>   
>   #define _GNU_SOURCE
> @@ -20,9 +24,194 @@
>   #include <sys/stat.h>
>   #include <errno.h>
>   #include <stdarg.h>
> +#include <sys/vfs.h>
> +#include <linux/magic.h>
>   
>   #include "luo_test_utils.h"
>   
> +int cwd_is_tmpfs(void)
> +{
> +	struct statfs buf;
> +
> +	if (statfs(".", &buf) < 0)
> +		return -errno;
> +
> +	return buf.f_type == TMPFS_MAGIC;
> +}
> +
> +/* Read exactly specified size from fd. Any less results in error. */
> +int read_size(int fd, char *buffer, size_t size)
> +{
> +	size_t remain = size;
> +	ssize_t bytes_read;
> +
> +	while (remain) {

while (remain > 0) ?

> +		bytes_read = read(fd, buffer, remain);
> +		if (bytes_read == 0)
> +			return -ENODATA;
> +		if (bytes_read < 0) {
> +			if (errno == EINTR)
> +				continue;
> +			else
> +				return -errno;
> +		}
> +
> +		remain -= bytes_read;
> +		buffer += bytes_read;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Write exactly specified size from fd. Any less results in error. */
> +int write_size(int fd, const char *buffer, size_t size)
> +{
> +	size_t remain = size;
> +	ssize_t written;
> +
> +	while (remain) {

while (remain>0) is better?

Zhu Yanjun

> +		written = write(fd, buffer, remain);
> +		if (written == 0)
> +			return -EIO;
> +		if (written < 0) {
> +			if (errno == EINTR)
> +				continue;
> +			else
> +				return -errno;
> +		}
> +
> +		remain -= written;
> +		buffer += written;
> +	}
> +
> +	return 0;
> +}
> +
> +int generate_random_data(char *buffer, size_t size)
> +{
> +	int fd, ret;
> +
> +	fd = open("/dev/urandom", O_RDONLY);
> +	if (fd < 0)
> +		return -errno;
> +
> +	ret = read_size(fd, buffer, size);
> +	close(fd);
> +	return ret;
> +}
> +
> +int save_test_data(const char *filename, const char *buffer, size_t size)
> +{
> +	int fd, ret;
> +
> +	fd = open(filename, O_RDWR | O_CREAT | O_TRUNC, 0666);
> +	if (fd < 0)
> +		return -errno;
> +
> +	ret = write_size(fd, buffer, size);
> +	fsync(fd);
> +	close(fd);
> +	return ret;
> +}
> +
> +int load_test_data(const char *filename, char *buffer, size_t size)
> +{
> +	int fd, ret;
> +
> +	fd = open(filename, O_RDONLY);
> +	if (fd < 0)
> +		return -errno;
> +
> +	ret = read_size(fd, buffer, size);
> +	close(fd);
> +	return ret;
> +}
> +
> +/* Create and initialize a memfd with random data. */
> +int create_random_memfd(const char *memfd_name, char *buffer, size_t size)
> +{
> +	int fd;
> +	int ret;
> +
> +	fd = memfd_create(memfd_name, 0);
> +	if (fd < 0)
> +		return -errno;
> +
> +	ret = generate_random_data(buffer, size);
> +	if (ret < 0) {
> +		close(fd);
> +		return ret;
> +	}
> +
> +	ret = write_size(fd, buffer, size);
> +	if (ret < 0) {
> +		close(fd);
> +		return ret;
> +	}
> +
> +	/* Reset file position to beginning */
> +	if (lseek(fd, 0, SEEK_SET) < 0) {
> +		ret = -errno;
> +		close(fd);
> +		return ret;
> +	}
> +
> +	return fd;
> +}
> +
> +/*
> + * Make sure fd contains expected data up to size. Returns 0 on success, 1 on
> + * data mismatch, -errno on error.
> + */
> +int verify_fd_content_read(int fd, const char *expected_data, size_t size)
> +{
> +	char *buffer;
> +	int ret;
> +
> +	buffer = malloc(size);
> +	if (!buffer)
> +		return -ENOMEM;
> +
> +	/* Reset file position to beginning */
> +	if (lseek(fd, 0, SEEK_SET) < 0) {
> +		ret = -errno;
> +		goto out;
> +	}
> +
> +	ret = read_size(fd, buffer, size);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (memcmp(buffer, expected_data, size) != 0) {
> +		ret = 1;
> +		goto out;
> +	}
> +
> +	ret = 0;
> +
> +out:
> +	free(buffer);
> +	return ret;
> +}
> +
> +/*
> + * Verify fd content using mmap. Returns 0 on success, 1 on data mismatch,
> + * -errno on error.
> + */
> +int verify_fd_content_mmap(int fd, const char *expected_data, size_t size)
> +{
> +	char *mapped_mem;
> +	int ret;
> +
> +	mapped_mem = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, 0);
> +	if (mapped_mem == MAP_FAILED)
> +		return -errno;
> +
> +	ret = memcmp(mapped_mem, expected_data, size) ? 1 : 0;
> +	munmap(mapped_mem, size);
> +	return ret;
> +}
> +
>   int luo_open_device(void)
>   {
>   	return open(LUO_DEVICE, O_RDWR);
> diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.h b/tools/testing/selftests/liveupdate/luo_test_utils.h
> index 90099bf49577..a69dce2649b0 100644
> --- a/tools/testing/selftests/liveupdate/luo_test_utils.h
> +++ b/tools/testing/selftests/liveupdate/luo_test_utils.h
> @@ -35,6 +35,16 @@ void restore_and_read_stage(int state_session_fd, int token, int *stage);
>   
>   void daemonize_and_wait(void);
>   
> +int cwd_is_tmpfs(void);
> +int read_size(int fd, char *buffer, size_t size);
> +int write_size(int fd, const char *buffer, size_t size);
> +int generate_random_data(char *buffer, size_t size);
> +int save_test_data(const char *filename, const char *buffer, size_t size);
> +int load_test_data(const char *filename, char *buffer, size_t size);
> +int create_random_memfd(const char *memfd_name, char *buffer, size_t size);
> +int verify_fd_content_read(int fd, const char *expected_data, size_t size);
> +int verify_fd_content_mmap(int fd, const char *expected_data, size_t size);
> +
>   typedef void (*luo_test_stage1_fn)(int luo_fd);
>   typedef void (*luo_test_stage2_fn)(int luo_fd, int state_session_fd);
>   


