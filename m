Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43B2BCD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 06:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79CDB6B0088; Tue,  9 Jun 2026 02:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74DDC6B008A; Tue,  9 Jun 2026 02:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68ADB6B008C; Tue,  9 Jun 2026 02:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59D826B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 02:11:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 266F21C253C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:11:05 +0000 (UTC)
X-FDA: 84859351290.17.A313982
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id EF1CF4000D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:11:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="U3iJP/gI";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780985463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jziv3ux6x+zDnqGW2bd2fd18cv46HbROMXcIzVSTge0=;
	b=hS7PHzFjfmZYdcef5gqt9+Mm3z0jgXa4fOhZofX2a3fUH258lMwKjUmRNBA3b8ZFZnFUTS
	sKW0Tuzd2kyUIcQKuK6Rx9jg+T5QK0poOFBvBKeVHGHb9U29aS6Vn9ktAjy/zvGt93ng3j
	zBBrEPbIYyl0FWHNG6hSojjlvwihfDM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="U3iJP/gI";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780985463;
	b=rkipi0m48waQIWfx+27E4wvb9aCQzk22JOlNWQM+0p3+NOfV9i8/pL6Pr4sRhL4ns2dZaw
	f73OqbMO91DVATaJcrkd2FxdWwE6OB7SUq74Ch6APIqxRQMiEsdEzXKcxH9VzV/Scx1Wym
	HQEI/QycGWozh4sI1INu9fe9geujutY=
Message-ID: <49f725a7-577d-4036-bd5a-5a33fc9e17c3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780985460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jziv3ux6x+zDnqGW2bd2fd18cv46HbROMXcIzVSTge0=;
	b=U3iJP/gIVAM30g5c/BU4BtY4h3aVryQGhCoookRklrRqIrs+85zkpuvT6jZ6oAyOlsT0ND
	bA2t9QvKGk7/6mFNBqI13oUoqq35ZidVPutOT3vqdzrpzHpFDAV/fDfHyDkI1Rah+sAMgi
	oicJVmbtbiMC4ZscR+wDNgUc0Ay1d0M=
Date: Tue, 9 Jun 2026 14:09:36 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 5/6] kselftest: alloc_tag: add kselftest for ioctl
 interface
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>, Suren Baghdasaryan
 <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
References: <cover.1780701922.git.abhishekbapat@google.com>
 <2e55b3b1388a4f7a59f670a83f222ba6c836ac4e.1780701922.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <2e55b3b1388a4f7a59f670a83f222ba6c836ac4e.1780701922.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EF1CF4000D
X-Stat-Signature: p6twgi8cx8zig5am7sw5hu9hezwfs4b6
X-Rspam-User: 
X-HE-Tag: 1780985462-403594
X-HE-Meta: U2FsdGVkX19ijxzl6QcqtusJoknx9yLXELM3Lm+TWuN5B8CwG8THD/jhTOYbf1xaq1+dy63Q1Yj46gD8s+MltFleEwht4gMltSxgvBXx6O6tQo8uOdU5F50lvWUY9iP7oU/3e9IwDYnIujGHxCblRiNNT2MsrDeU5GfH7wsfwR7bwAXpqAQ36YyDi05llb9Hm9ZahnbulmusoOxlhWq1sg5+nFcJoxTILeLib4PsmSKRYWmIfyyxqoPzdjPCf4BUipKWGHJhOWqQAb6VS5X8IpNG4KTI2S2kk66nmA6EwgckxLsz1xNSCvUlmJbONVFRG6nqQkY/Ys2KVecpR2X+39a/BXkn39dzU9kjUr2NplS1tZOL5xUWm8nS95jgcmjv4YN8nt6T6MJR04wFd/OXgbxKqpXCDICOnkcUtJLLn8Sf5UfnWYOZsFY9fyKDr7ACHP2OiTgJ2gZH9ZDcXKtSzpXkykZoCHuI73YxJyf9imoffLH7LAv+mGjNxZhKzPTfz9De8ZKUi7zwHFxoePD3nPmN/6tqRIAO9EbbrKQa3FkRtl8izOZYJ/1BACpJwWvEuorB6CCFyhsmAQzQ44FFTNr8XjL1RuFGHyhVL93CNQ3CCzPNAQGUFTvbXbWLhjz7RP9JM+RCEBv1JCrEIcXN7Rm9TABPTQ666IbdaFD8gtAeAOssxPH0S3cq157MjdfP/Z5y2Ju+szE1yj+daMvgIzFyZpbfhSQ1/p6Qf/kFgxIgP0dTRgrwe24trleTpjlgiJYKbBF3WvDTIE04MSUHEnPfR51UFyOsluOpDY8ydVMw+cfNNitBH3h5K0GFkyTOw0k8O3yc0e8PKGTpc7gtX64fVLgWmgAnUvf96EYYxNgYdjL+sSPikwOxGPHfq9wGXZlW56oPT9mSYiDAMXLNegFybJgp7LWod+Aa3YVQ77jn4fculZ7fauMl7r3z9g2zulOyjo5N7MybZzuChiS
 WlftmyxD
 xaBcOxMZ9m8iAZRRYYgIBL2LU5HakTgxstvfXP/FNxAbVrxMqGn12D39FqQ6HvgNpqxHBYXiyFRVFnuxkGf87O+RTakLPSAYlGlDt9OQYq00l49cI8t3ViNzNdVb3k+okApC60aQzbX6Lu4pZ9LWoxvgwvCxIdwy0VcTlKYDQEuNwfLFupGEzZDY1RfeKSt8+LD1KfHndTZukag+/gtm595YAwF42Hwd+r4edr8UBSFkQiB84PE3zd4mNDuVCy6Gc335QbZgjcFbCrSSxyD5vNg/ErzF+QQRE/akX8AAL7t5xmpo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek


On 2026/6/6 07:36, Abhishek Bapat wrote:
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
> ---
>   MAINTAINERS                                   |   1 +
>   tools/testing/selftests/alloc_tag/Makefile    |   9 +
>   .../alloc_tag/allocinfo_ioctl_test.c          | 313 ++++++++++++++++++
>   3 files changed, 323 insertions(+)
>   create mode 100644 tools/testing/selftests/alloc_tag/Makefile
>   create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 77f3fc487691..80560f5f1292 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16713,6 +16713,7 @@ F:	include/linux/alloc_tag.h
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
> index 000000000000..5c3c16e86c23
> --- /dev/null
> +++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> @@ -0,0 +1,313 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +/* kselftest for allocinfo ioctl
> + * allocinfo ioctl retrives allocinfo data through ioctl


nit: s/retrives/retrieves/


I've applied the full patch series locally and ran the kselftest, all 4 
tests pass:

[root@localhost alloc_tag]# ./allocinfo_ioctl_test
1..4
ok 1 test_filename_filter
ok 2 test_function_filter
ok 3 test_size_filter
ok 4 test_lineno_filter
# Totals: pass:4 fail:0 xfail:0 xpass:0 skip:0 error:0

But there are no tests for ALLOCINFO_FILTER_MASK_MODNAME and

ALLOCINFO_FILTER_MASK_INACCURATE.


Thanks

Best Regards

Hao

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
> +
> +		memset(&procfs_entry, 0, sizeof(procfs_entry));
> +		matches = sscanf(line, "%llu %llu %[^:]:%llu func:%s",
> +				 &procfs_entry.counter.bytes,
> +				 &procfs_entry.counter.calls,
> +				 procfs_entry.tag.filename,
> +				 &procfs_entry.tag.lineno,
> +				 procfs_entry.tag.function);
> +
> +		if (matches != 5)
> +			continue;
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
> +		ksft_exit_skip("Failed to open " ALLOCINFO_PROC ": %s\n", strerror(errno));
> +		ret = KSFT_FAIL;
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

