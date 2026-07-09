Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CCC5C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 07:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 296836B0088; Thu,  9 Jul 2026 03:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247DA6B008A; Thu,  9 Jul 2026 03:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15EEC6B008C; Thu,  9 Jul 2026 03:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDA806B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:33:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6655314040E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:33:00 +0000 (UTC)
X-FDA: 84968421720.23.29202CD
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf10.hostedemail.com (Postfix) with ESMTP id 29EC3C0003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:32:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ANe3sxa4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783582378;
	b=Sp7BdeNB464ReV3pksqErHvYhau/Zadp+lWrIibJcjF/35P6ETI4TgrjrDQadfap5rDq+u
	xu4bUPmNxs5k/qmu1NdtqhwuWEf5UJWsHQFrD3brohMPHH9LN4UHIp+vYr0g6gjw/MMx7D
	bIPkFgZKiXz5VjjvGPGIdSy/1l00v0o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ANe3sxa4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783582378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TOOMe6IpaFT02HH9/Qn4PU6aCKChtMhWhozxlWqpN/A=;
	b=nh6NV/bXGct6qnEHHpytm15Xo/t+ck+iPQi6kZ38teY1krKxI/qcTi3nYMz4ranSM+4Iqy
	1tZgoq2WJvZ96SEt9KHg8vbCsmHEGqytVNaNsxyE4SWb9JyiMO7KvdSo3iQB1lMApFznBQ
	NhS/TSJFhc59dQWYP7paphUK7bO+UdU=
Message-ID: <05bb3890-b73d-4a27-af93-cca21d2858f0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783582375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TOOMe6IpaFT02HH9/Qn4PU6aCKChtMhWhozxlWqpN/A=;
	b=ANe3sxa4KGL8Vlg1uLrN582e19xfxk8qJ6TMHafU4aD/SpqUVOXr5nEToOoMk7E5N9xAs3
	nho/A0aJ+XmSRS/h8PgPxR01C33DBU2bDir1atKZmXpS2skRRn/8P6rZ1xZcDT+f+McRn3
	5EinY5SieB3T2aD5XSWuDqGNaRuNEbc=
Date: Thu, 9 Jul 2026 15:32:24 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v8 5/6] kselftest: alloc_tag: add kselftest for ioctl
 interface
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>, Suren Baghdasaryan
 <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
References: <cover.1783532853.git.abhishekbapat@google.com>
 <e2a3795677a14aeab249758ba570cd5e98402032.1783532853.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <e2a3795677a14aeab249758ba570cd5e98402032.1783532853.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 29EC3C0003
X-Rspam-User: 
X-Stat-Signature: hxfiaog76qmmyykkqk1sond3zugmn1rj
X-Rspamd-Server: rspam03
X-HE-Tag: 1783582377-477188
X-HE-Meta: U2FsdGVkX18cfNxFhXmR3RIiF/XQg5JdPF72qIYD4YY5+Ve9ITxc5UIIs0awugIk9YmMEvUq9ObtxXUqOLbLda7TpB1pWzfbFIfpZlu7GaBYs56PjjMfdvV4Dpou2hIWO4af/Yk+zlrlhnTH1iNUitfI2JilhAqRcLQGQls93B8EdKXULIDk7l2hJyw4jJiIpAdS44jGe0c9Rsh/uPt5C1GLTiOLfvIQz79pf2pIdDDaOmz31ctQpwLHdcnkDI2gSRBoZJO4A9gw3w73IhqZlUFB/tM+zQ1/GeW52E2YtsQhvTlycRATjzpuDgDZQCvWnDaYvSGTfjqZ3usA3yfv+EiK1XYYJu1ln+c5EYnW4ivMHIv6ckNHKn7XWhFuzdTPvQbDbi9bUsmhOPtZdkO3+XokA+/fs74IPdGyAXHzFkAI6q2mfoKPLPEHoJ7PSenxT4VUebIiKaN1W/Ab/wazQHx+P/QIF3wRXcBtzHkQjf99gmTsXIgIMquHBxFFYtOmQbVzSaKOxWWxNnQisiKnp2SHYghwU/8OOrhnqmP1QCXlWBJPS4oJO9xJDK4mK4hg5NIlAclC/BHyhYgjnoumC24Y0+0681+e6jZoeoY4gRDXRaNsTbaD7aq9toUQbDExa+fQAHwylSiTr5f4tTZvHld5D6URQji7nis8IgLI4o5RQg/IiXBRNjHHlNcGm4vlHsV2SsfZrglnkplPc3F2tJQmvw3QAE+W8AL5uQwB6QvTQTfKfSWju7VDLRYhQ6eyOi8y3teFbiqfr3R60K4/rp2VVND9L3LAidXWxlTWI209rjQil4uV25LadXL06sxMXPz6l9VIMYrIKRoFuk2dFk5E5xHMC/E2wnPOxe/88MPek3M6AdrfGoZoDBXlIcwWMpZaWsNlBWMTEwHUaSUwKbCEkP3CT6PJLydAdQtirIvDY9fZ+gXhuRdfXCP+an5rD/gN9+14NkiGEziMKmL
 Z/g6eHfm
 5erlHXWMvdP1qIOKMpjCajNo1oHI1Gv7mUHBJZWdSoBnG3qslwKjoywvlX+8VBJM2Ld506Vr/TaA4WGosg6CNPkjyFdedluhPQGDoOfeQbWNLQFyN/TZAd2uASIo4QO8o2r3hs0H5X6hBXxyeVa9WDW7qBpeIvAFXh/aaiATr98CAUBLPdu4MQ7CAAjV0ebUZGwk9Nbcw5kj5QCHQ7nvolR5GUOaNqvzo68hn9u0v/wChW8olgCaqOGDlKE51WgNXg6JvvGyEWALYiU14m78tN4CvfPmRZrz7p1WaUavwxtPCQxGQbMuATHWtTEE/9eqQogswV9yYKA7SmaxjqAvQq1jvGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek


On 2026/7/9 02:01, Abhishek Bapat wrote:
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
>   tools/testing/selftests/Makefile              |   1 +
>   tools/testing/selftests/alloc_tag/Makefile    |   9 +
>   .../alloc_tag/allocinfo_ioctl_test.c          | 334 ++++++++++++++++++
>   4 files changed, 345 insertions(+)
>   create mode 100644 tools/testing/selftests/alloc_tag/Makefile
>   create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8e316eba7b4c..3d54fd8d69c1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16938,6 +16938,7 @@ F:	include/linux/alloc_tag.h
>   F:	include/linux/pgalloc_tag.h
>   F:	include/uapi/linux/alloc_tag.h
>   F:	mm/alloc_tag.c
> +F:	tools/testing/selftests/alloc_tag/
>   
>   MEMORY MANAGEMENT - BALLOON
>   M:	Andrew Morton <akpm@linux-foundation.org>
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index 8d4db2241cc2..12941d68a7f8 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -1,5 +1,6 @@
>   # SPDX-License-Identifier: GPL-2.0
>   TARGETS += acct
> +TARGETS += alloc_tag
>   TARGETS += alsa
>   TARGETS += amd-pstate
>   TARGETS += arm64
> diff --git a/tools/testing/selftests/alloc_tag/Makefile b/tools/testing/selftests/alloc_tag/Makefile
> new file mode 100644
> index 000000000000..f41d92d06b18
> --- /dev/null
> +++ b/tools/testing/selftests/alloc_tag/Makefile
> @@ -0,0 +1,9 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +TEST_GEN_PROGS := allocinfo_ioctl_test
> +
> +CFLAGS += -Wall
> +CFLAGS += $(KHDR_INCLUDES)
> +
> +include ../lib.mk
> +
> diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> new file mode 100644
> index 000000000000..9ce7b53078b1
> --- /dev/null
> +++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> @@ -0,0 +1,334 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +/* kselftest for allocinfo ioctl
> + * allocinfo ioctl retrives allocinfo data through ioctl
> + * Copyright (C) 2026 Google, Inc.
> + */
> +


I recall we discussed the "retrives" typo previously.

nit: s/retrives/retrieves/


I've verified this selftest on kernels both with and without 
CONFIG_MEM_ALLOC_PROFILING enabled,

and it works as expected.


Tested-by: Hao Ge <hao.ge@linux.dev>

Acked-by: Hao Ge <hao.ge@linux.dev>


Thanks

Best Regards

Hao


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
> +				       const struct allocinfo_filter *filter)
> +{
> +	FILE *fp = fopen(ALLOCINFO_PROC, "r");
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
> +	fclose(fp);
> +	return 0;
> +}
> +
> +static enum ioctl_ret get_filtered_ioctl_entries(struct allocinfo_tag_data_vec *tags,
> +						 const struct allocinfo_filter *filter,
> +						 __u64 start_pos)
> +{
> +	int fd = open(ALLOCINFO_PROC, O_RDONLY);
> +
> +	if (fd < 0) {
> +		ksft_print_msg("Failed to open " ALLOCINFO_PROC " for IOCTL\n");
> +		return IOCTL_FAILURE;
> +	}
> +
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
> +			status = IOCTL_FAILURE;
> +			break;
> +		}
> +
> +		memset(tags, 0, sizeof(*tags));
> +		memset(&get_at_params, 0, sizeof(get_at_params));
> +		memcpy(&get_at_params.filter, filter, sizeof(*filter));
> +		get_at_params.pos = start_pos;
> +		if (__allocinfo_get_at(fd, &get_at_params)) {
> +			ksft_print_msg("allocinfo_get_at failed\n");
> +			status = IOCTL_FAILURE;
> +			break;
> +		}
> +		memcpy(&tags->tag[tags->count++], &get_at_params.data, sizeof(get_at_params.data));
> +
> +		while (tags->count < VEC_MAX_ENTRIES &&
> +		       __allocinfo_get_next(fd, &tags->tag[tags->count]) == 0)
> +			tags->count++;
> +
> +		if (__allocinfo_get_content_id(fd, &end_cont_id)) {
> +			ksft_print_msg("allocinfo_get_content_id failed\n");
> +			status = IOCTL_FAILURE;
> +			break;
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
> +	close(fd);
> +	return status;
> +}
> +
> +static int run_filter_test(const struct allocinfo_filter *filter)
> +{
> +	struct allocinfo_tag_data_vec *tags = malloc(sizeof(*tags));
> +	struct allocinfo_tag_data_vec *procfs_entries = malloc(sizeof(*procfs_entries));
> +	int ioctl_status;
> +	int ret = KSFT_PASS;
> +
> +	if (!tags || !procfs_entries) {
> +		ksft_print_msg("Memory allocation failed.\n");
> +		ret = KSFT_FAIL;
> +		goto exit;
> +	}
> +
> +	if (get_filtered_procfs_entries(procfs_entries, filter)) {
> +		ksft_print_msg("Error retrieving entries from " ALLOCINFO_PROC "\n");
> +		ret = KSFT_SKIP;
> +		goto exit;
> +	}
> +
> +	if (procfs_entries->count == 0) {
> +		ksft_print_msg("No entries found in " ALLOCINFO_PROC ", skipping test\n");
> +		ret = KSFT_SKIP;
> +		goto exit;
> +	}
> +
> +	ioctl_status = get_filtered_ioctl_entries(tags, filter, 0);
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

