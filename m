Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6C0ECD98C8
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 03:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D36026B0005; Tue,  9 Jun 2026 23:17:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC01A6B0088; Tue,  9 Jun 2026 23:17:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B87856B008A; Tue,  9 Jun 2026 23:17:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A11D26B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 23:17:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3428791D6B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 03:17:58 +0000 (UTC)
X-FDA: 84862543836.01.B08DB00
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf01.hostedemail.com (Postfix) with ESMTP id F357C40011
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 03:17:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PuANXqGq;
	spf=pass (imf01.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781061476;
	b=zUHv8MQHD382SElq74eY9oUa6ELZk9IGaJPt1zRzai6tMLUvjpi4KvejD8cC0VnSyeU9lF
	EQLks6NeK9ZLJE17XzQU+iONAoMfWI+JDVyvlDYOOFfxCzQ0EpooErBXZZo0pCC9EfH5WE
	HhqroPUWiCuM3DaxY9lpQ6ryz1LRNEI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PuANXqGq;
	spf=pass (imf01.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781061476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kLvNepM+fvnGmRz5Lyy+2TnRQiiRa5y+SkT2rn0uJ4Y=;
	b=lGqJCwbztGNgIJoZjqPiY2pw74fvsRKDu/sYe97cWnrO7asZ/VMK3JBjDtvT4CdCUnpwEu
	h8Q0hfYOJX8y+mWh9MxRXpZxfrxKGJl/zIw/ZrarFzBfp1C2Uq280tyssgJLiC6sQTfPFx
	vz4jqqNxCH9Bi7xe/+ks1dGA+sV02bI=
Message-ID: <8bcb0d28-46ad-43ab-adc3-bb1995976d95@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781061473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kLvNepM+fvnGmRz5Lyy+2TnRQiiRa5y+SkT2rn0uJ4Y=;
	b=PuANXqGqHjOwEkDpFAKAj9bAJizWNfHsb8c1RZEYbJzRPCaQITaSZvDdcF/kxM0xLes1x2
	RmfujFocFzr+F+YKp8KHt+7h/Q5YAOTpJBnD3AFTKkWRuxy8PGkOW50nE3sqSOlNmbBCxA
	awPQ6rdI6Mzx6LLYtVh9I85YjVDsrpE=
Date: Wed, 10 Jun 2026 11:17:09 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 5/6] kselftest: alloc_tag: add kselftest for ioctl
 interface
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>, Suren Baghdasaryan
 <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
References: <cover.1781042698.git.abhishekbapat@google.com>
 <dfc472e9d999318cfd74a9b753a563d225b3bc02.1781042698.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <dfc472e9d999318cfd74a9b753a563d225b3bc02.1781042698.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F357C40011
X-Rspam-User: 
X-Stat-Signature: hegnxqjh17u4ddby9np73w5mi9a84uqw
X-HE-Tag: 1781061475-428773
X-HE-Meta: U2FsdGVkX19JmxmaWPcuDXGbBhnHAaQdoaBZ5iFE3OSDK2Dtf7TTyaE+uulDI+PbywDua7QGf7fHYt+GAzz/oRrgvsThgZi0IJwM0i58Lo9zX19itKqx3gD5wSC+73tcJB0v6RRHqvXwzq2mLSfxdGzv0VkhZJc0cHquO6tveD6Cdlv51UiztYQCOm0zP5ndE+UFqUW8xW0yGmH+e9d0o/cACNn0QjoBJIZhRVQotMSMECmrcvMMTVRFD8i9Ceox20+GDjdV6IR0J/xAVqpxaQWOZ1Jhxv5jDdWNCR5kALp5m4hzyvBmBmjB4QiGlqJPjWnE63OLsDwF1JYUp4W2/Yxhdsy+/318jxC5ldB0KDlGPyjPTtVxhB60U2coBO2ameH+Iskc7FK4wgLC3Q39V0mCyHtH9Vm5WwyNZmC++mAie0/Uy2WFVq5GmApwhK6o5MB/M+s6xOM76Wy2ei9O5FzfDdjxbxQDLNCJEY0cPR84ATlbU8aYn/KeIKRcQTAX9LDkBHn6kJntx/ZAolSU1RR98JY5N0+ZwMsiKYI60iyqd0SZq+fqcjgiQIHfyoRyGtUM41rJKZhszlXimXziu0GS4tnDTiOhdSojREOOcr+4+v16xzjt/Q48tgyZ8VQAXsmfcpFSXE//8B4RbWAKBZ4hf2I4m0zt9bX90Q+by8Obeum7VPcyP4Bx5V/LhxQts1CHqblaO28e4FO48WSqP8CNbME47+Ua++2D9fl34hkaSwus5HujvY2NoMcauiCOrwZ/YQ0KJZu6sXCF7as6fuQ0/ugrv9XhM3lCQCzOwKUpZcE3WRSqUi2vn9zbeYW/VNBQeQkNeN2agIm02vlc60sINNGsb6zhxIRn+6/Zt4CIEjA+6Npzxg93C6YfD02VySQjiq0DoOG754T1Kylh6dxZ+KhIOL3qwOzBcioOysj95hWJ39evIWoyInJcMwMHCqrdbO+xY2/BdZLbkcj
 DNk4FNlZ
 d7kA77O1toPPpmPDnBAYtCwmteboQXjG1SJXpGOTHBi6GYMBY/q3AUEmf2x4eVWQe6NQZTIb32a0/PTqZXVHk98tlQONRBlinTbVrUOzsgMHCfT1ZTZsSuOkCwGRFMUHVeeTxJzDev/Je9idChC1WMyympEfZGsU1VSOIXEIVb0vCfdNm3fsIy8Vka5EDQB69cWyCW3sVAIkTcOqBrnZ42V+mhXehD5LX7AwNIziTb4qIJAXjJkbAfHGwsS0GQLsypPU5CuGgt4Si1psmzDV9kQFxXTw8er3Vf5SWchRGUOOdaOWSu+0Nc+sLxIJJ10BMV9C9Qtz1JgshKGvquuEPDPHeV7/K+r5FSjp2IoOf/qiPz38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek


On 2026/6/10 08:12, Abhishek Bapat wrote:
> Introduce a kselftest to verify the new IOCTL-based interface for
> /proc/allocinfo. The test covers:
>
> 1. Validation of the filename filter.
> 2. Validation of the function filter.
>
> The first test validates the functionality of the filename filter. Using
> "mm/memory.c" as the candidate filename filter, it retrieves filtered
> entries from both procfs and ioctl and matches the first VEC_MAX_ENTRIES
> entries.
>
> The second test validates the functionality of the function filter.
> It uses "dup_mm" as the candidate function as we do not expect this
> function name to change frequently and hence won't be needing to modify
> this test often.
>
> Note that both the tests match line no, function name and file name
> fields. Bytes allocated and calls are not matched as those values may
> change in the time when the data is being read from procfs and ioctl and
> hence can lead to false negatives.
>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>


For this patch, I see two issues reported by sashiko.

(https://sashiko.dev/#/patchset/cover.1781042698.git.abhishekbapat%40google.com)

The second one (sscanf dropping module entries) can be ignored since

we are not testing anything related to modname.

For the first one, for the leak aspect, I don't think it matters because the

OS will reclaim the memory when the process exits. However, the fd

offset issue is indeed a real problem, and this issue does not exist in 
this patch.

It only appears in test_size_filter of the next patch.


So for this patch, LGTM.


Acked-by: Hao Ge <hao.ge@linux.dev>




> ---
>   MAINTAINERS                                   |   1 +
>   tools/testing/selftests/alloc_tag/Makefile    |   9 +
>   .../alloc_tag/allocinfo_ioctl_test.c          | 333 ++++++++++++++++++
>   3 files changed, 343 insertions(+)
>   create mode 100644 tools/testing/selftests/alloc_tag/Makefile
>   create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 019cc4c285a3..6610dd42e484 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16715,6 +16715,7 @@ F:	include/linux/alloc_tag.h
>   F:	include/linux/pgalloc_tag.h
>   F:	include/uapi/linux/alloc_tag.h
>   F:	lib/alloc_tag.c
> +F:	tools/testing/selftests/alloc_tag/
>   
>   MEMORY CONTROLLER DRIVERS
>   M:	Krzysztof Kozlowski <krzk@kernel.org>
> diff --git a/tools/testing/selftests/alloc_tag/Makefile b/tools/testing/selftests/alloc_tag/Makefile
> new file mode 100644
> index 000000000000..f2b8fc022c3b
> --- /dev/null
> +++ b/tools/testing/selftests/alloc_tag/Makefile
> @@ -0,0 +1,9 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +TEST_GEN_PROGS := allocinfo_ioctl_test
> +
> +CFLAGS += -Wall
> +CFLAGS += -I../../../../usr/include
> +
> +include ../lib.mk
> +
> diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> new file mode 100644
> index 000000000000..cd9cf229ae1f
> --- /dev/null
> +++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> @@ -0,0 +1,333 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +/* kselftest for allocinfo ioctl
> + * allocinfo ioctl retrives allocinfo data through ioctl
> + * Copyright (C) 2026 Google, Inc.
> + */
> +
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <stdbool.h>
> +#include <unistd.h>
> +#include <sys/ioctl.h>
> +#include <linux/types.h>
> +#include <linux/alloc_tag.h>
> +#include "../kselftest.h"
> +
> +#define MAX_LINE_LEN		512
> +#define ALLOCINFO_PROC		"/proc/allocinfo"
> +
> +enum ioctl_ret {
> +	IOCTL_SUCCESS = 0,
> +	IOCTL_FAILURE = 1,
> +	IOCTL_INVALID_DATA = 2,
> +};
> +
> +#define VEC_MAX_ENTRIES 32
> +
> +struct allocinfo_tag_data_vec {
> +	struct allocinfo_tag_data tag[VEC_MAX_ENTRIES];
> +	__u64 count;
> +};
> +
> +static inline int __allocinfo_get_content_id(int dev_fd, struct allocinfo_content_id *params)
> +{
> +	return ioctl(dev_fd, ALLOCINFO_IOC_CONTENT_ID, params);
> +}
> +
> +static inline int __allocinfo_get_at(int dev_fd, struct allocinfo_get_at *params)
> +{
> +	return ioctl(dev_fd, ALLOCINFO_IOC_GET_AT, params);
> +}
> +
> +static inline int __allocinfo_get_next(int dev_fd, struct allocinfo_tag_data *params)
> +{
> +	return ioctl(dev_fd, ALLOCINFO_IOC_GET_NEXT, params);
> +}
> +
> +static bool match_entry(const struct allocinfo_tag_data *procfs_entry,
> +			const struct allocinfo_tag_data *tag_data,
> +			bool match_bytes, bool match_calls, bool match_lineno,
> +			bool match_function, bool match_filename)
> +{
> +	if (match_bytes && tag_data->counter.bytes != procfs_entry->counter.bytes) {
> +		ksft_print_msg("size retrieved through ioctl does not match procfs\n");
> +		return false;
> +	}
> +
> +	if (match_calls && tag_data->counter.calls != procfs_entry->counter.calls) {
> +		ksft_print_msg("call count retrieved through ioctl does not match procfs\n");
> +		return false;
> +	}
> +
> +	if (match_lineno && tag_data->tag.lineno != procfs_entry->tag.lineno) {
> +		ksft_print_msg("lineno retrieved through ioctl does not match procfs\n");
> +		return false;
> +	}
> +
> +	if (match_function &&
> +	    strncmp(tag_data->tag.function, procfs_entry->tag.function, ALLOCINFO_STR_SIZE)) {
> +		ksft_print_msg("function retrieved through ioctl does not match procfs\n");
> +		return false;
> +	}
> +
> +	if (match_filename &&
> +	    strncmp(tag_data->tag.filename, procfs_entry->tag.filename, ALLOCINFO_STR_SIZE)) {
> +		ksft_print_msg("filename retrieved through ioctl does not match procfs\n");
> +		return false;
> +	}
> +	return true;
> +}
> +
> +static bool match_entries(const struct allocinfo_tag_data_vec *procfs_entries,
> +			  const struct allocinfo_tag_data_vec *tags,
> +			  bool match_bytes, bool match_calls, bool match_lineno,
> +			  bool match_function, bool match_filename)
> +{
> +	__u64 i;
> +
> +	if (procfs_entries->count != tags->count) {
> +		ksft_print_msg("Entry count mismatch. ioctl entries: %llu, proc entries: %llu\n",
> +			       tags->count, procfs_entries->count);
> +		return false;
> +	}
> +	for (i = 0; i < procfs_entries->count; i++) {
> +		if (!match_entry(&procfs_entries->tag[i], &tags->tag[i],
> +				 match_bytes, match_calls, match_lineno,
> +				 match_function, match_filename)) {
> +			ksft_print_msg("%lluth entry does not match.\n", i);
> +			return false;
> +		}
> +	}
> +	return true;
> +}
> +
> +static const char *allocinfo_str(const char *str)
> +{
> +	size_t len = strlen(str);
> +
> +	if (len >= ALLOCINFO_STR_SIZE)
> +		str += (len - ALLOCINFO_STR_SIZE) + 1;
> +	return str;
> +}
> +
> +static void allocinfo_copy_str(char *dest, const char *src)
> +{
> +	strncpy(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE - 1);
> +	dest[ALLOCINFO_STR_SIZE - 1] = '\0';
> +}
> +
> +static int get_filtered_procfs_entries(struct allocinfo_tag_data_vec *procfs_entries,
> +				       const struct allocinfo_filter *filter, int fd)
> +{
> +	FILE *fp = fdopen(fd, "r");
> +	char line[MAX_LINE_LEN];
> +	int matches;
> +	struct allocinfo_tag_data procfs_entry;
> +
> +	if (!fp) {
> +		ksft_print_msg("Failed to open " ALLOCINFO_PROC " for reading\n");
> +		return 1;
> +	}
> +	memset(procfs_entries, 0, sizeof(*procfs_entries));
> +	while (fgets(line, sizeof(line), fp) && procfs_entries->count < VEC_MAX_ENTRIES) {
> +		char filename[MAX_LINE_LEN];
> +		char function[MAX_LINE_LEN];
> +
> +		memset(&procfs_entry, 0, sizeof(procfs_entry));
> +		matches = sscanf(line, "%llu %llu %[^:]:%llu func:%s",
> +				 &procfs_entry.counter.bytes,
> +				 &procfs_entry.counter.calls,
> +				 filename,
> +				 &procfs_entry.tag.lineno,
> +				 function);
> +
> +		if (matches != 5)
> +			continue;
> +
> +		allocinfo_copy_str(procfs_entry.tag.filename, filename);
> +		allocinfo_copy_str(procfs_entry.tag.function, function);
> +
> +		if (filter->mask & ALLOCINFO_FILTER_MASK_FILENAME) {
> +			if (strncmp(procfs_entry.tag.filename,
> +				    filter->fields.filename, ALLOCINFO_STR_SIZE))
> +				continue;
> +		}
> +		if (filter->mask & ALLOCINFO_FILTER_MASK_FUNCTION) {
> +			if (strncmp(procfs_entry.tag.function,
> +				    filter->fields.function, ALLOCINFO_STR_SIZE))
> +				continue;
> +		}
> +		if (filter->mask & ALLOCINFO_FILTER_MASK_LINENO) {
> +			if (procfs_entry.tag.lineno != filter->fields.lineno)
> +				continue;
> +		}
> +		if (filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) {
> +			if (procfs_entry.counter.bytes < filter->min_size)
> +				continue;
> +		}
> +		if (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) {
> +			if (procfs_entry.counter.bytes > filter->max_size)
> +				continue;
> +		}
> +
> +		memcpy(&procfs_entries->tag[procfs_entries->count++], &procfs_entry,
> +		       sizeof(procfs_entry));
> +	}
> +	return 0;
> +}
> +
> +static enum ioctl_ret get_filtered_ioctl_entries(struct allocinfo_tag_data_vec *tags,
> +						 const struct allocinfo_filter *filter, int fd,
> +						 __u64 start_pos)
> +{
> +	struct allocinfo_content_id start_cont_id, end_cont_id;
> +	struct allocinfo_get_at get_at_params;
> +	const int max_retries = 10;
> +	int retry_count = 0;
> +	int status;
> +
> +	/*
> +	 * __allocinfo_get_content_id may return different values if a kernel module was loaded
> +	 * between the two calls. If that happens, the data gathered cannot be considered consistent
> +	 * and hence needs to be fetched again to avoid flakiness.
> +	 */
> +	do {
> +		if (__allocinfo_get_content_id(fd, &start_cont_id)) {
> +			ksft_print_msg("allocinfo_get_content_id failed\n");
> +			return IOCTL_FAILURE;
> +		}
> +
> +		memset(tags, 0, sizeof(*tags));
> +		memset(&get_at_params, 0, sizeof(get_at_params));
> +		memcpy(&get_at_params.filter, filter, sizeof(*filter));
> +		get_at_params.pos = start_pos;
> +		if (__allocinfo_get_at(fd, &get_at_params)) {
> +			ksft_print_msg("allocinfo_get_at failed\n");
> +			return IOCTL_FAILURE;
> +		}
> +		memcpy(&tags->tag[tags->count++], &get_at_params.data, sizeof(get_at_params.data));
> +
> +		while (tags->count < VEC_MAX_ENTRIES &&
> +		       __allocinfo_get_next(fd, &tags->tag[tags->count]) == 0)
> +			tags->count++;
> +
> +		if (__allocinfo_get_content_id(fd, &end_cont_id)) {
> +			ksft_print_msg("allocinfo_get_content_id failed\n");
> +			return IOCTL_FAILURE;
> +		}
> +
> +		if (start_cont_id.id == end_cont_id.id) {
> +			status = IOCTL_SUCCESS;
> +		} else {
> +			ksft_print_msg("allocinfo_get_content_id mismatch, retrying...\n");
> +			status = IOCTL_INVALID_DATA;
> +		}
> +	} while (status == IOCTL_INVALID_DATA && retry_count++ < max_retries);
> +
> +	return status;
> +}
> +
> +static int run_filter_test(const struct allocinfo_filter *filter)
> +{
> +	int fd;
> +	struct allocinfo_tag_data_vec *tags = malloc(sizeof(*tags));
> +	struct allocinfo_tag_data_vec *procfs_entries = malloc(sizeof(*procfs_entries));
> +	int ioctl_status;
> +	int ret = KSFT_PASS;
> +
> +	if (!tags || !procfs_entries) {
> +		ksft_print_msg("Memory allocation failed.\n");
> +		ret = KSFT_FAIL;
> +		goto freemem;
> +	}
> +
> +	fd = open(ALLOCINFO_PROC, O_RDONLY);
> +	if (fd < 0) {
> +		ksft_print_msg("Failed to open " ALLOCINFO_PROC ": %s\n", strerror(errno));
> +		ret = KSFT_SKIP;
> +		goto freemem;
> +	}
> +
> +	if (get_filtered_procfs_entries(procfs_entries, filter, fd)) {
> +		ksft_print_msg("Error retrieving entries from " ALLOCINFO_PROC "\n");
> +		ret = KSFT_FAIL;
> +		goto exit;
> +	}
> +
> +	if (procfs_entries->count == 0) {
> +		ksft_print_msg("No entries found in " ALLOCINFO_PROC ", skipping test\n");
> +		ret = KSFT_SKIP;
> +		goto exit;
> +	}
> +
> +	ioctl_status = get_filtered_ioctl_entries(tags, filter, fd, 0);
> +	if (ioctl_status == IOCTL_INVALID_DATA) {
> +		ksft_print_msg("Trouble retrieving valid IOCTL entries, skipping.\n");
> +		ret = KSFT_SKIP;
> +		goto exit;
> +	}
> +	if (ioctl_status == IOCTL_FAILURE) {
> +		ksft_print_msg("Error retrieving IOCTL entries.\n");
> +		ret = KSFT_FAIL;
> +		goto exit;
> +	}
> +
> +	if (!match_entries(procfs_entries, tags, false, false, true, true, true))
> +		ret = KSFT_FAIL;
> +
> +exit:
> +	close(fd);
> +freemem:
> +	free(tags);
> +	free(procfs_entries);
> +	return ret;
> +}
> +
> +static int test_filename_filter(void)
> +{
> +	struct allocinfo_filter filter;
> +	const char *target_filename = "mm/memory.c";
> +
> +	memset(&filter, 0, sizeof(filter));
> +	filter.mask |= ALLOCINFO_FILTER_MASK_FILENAME;
> +	strncpy(filter.fields.filename, target_filename, ALLOCINFO_STR_SIZE);
> +
> +	return run_filter_test(&filter);
> +}
> +
> +static int test_function_filter(void)
> +{
> +	struct allocinfo_filter filter;
> +	const char *target_function = "dup_mm";
> +
> +	memset(&filter, 0, sizeof(filter));
> +	filter.mask |= ALLOCINFO_FILTER_MASK_FUNCTION;
> +	strncpy(filter.fields.function, target_function, ALLOCINFO_STR_SIZE);
> +
> +	return run_filter_test(&filter);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	int ret;
> +
> +	ksft_set_plan(2);
> +
> +	ret = test_filename_filter();
> +	if (ret == KSFT_SKIP)
> +		ksft_test_result_skip("Skipping test_filename_filter\n");
> +	else
> +		ksft_test_result(ret == KSFT_PASS, "test_filename_filter\n");
> +
> +	ret = test_function_filter();
> +	if (ret == KSFT_SKIP)
> +		ksft_test_result_skip("Skipping test_function_filter\n");
> +	else
> +		ksft_test_result(ret == KSFT_PASS, "test_function_filter\n");
> +
> +	ksft_finished();
> +}

