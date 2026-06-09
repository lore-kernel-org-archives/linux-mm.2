Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04A8CCD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 06:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E7F86B0005; Tue,  9 Jun 2026 02:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 171A66B0088; Tue,  9 Jun 2026 02:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088466B008C; Tue,  9 Jun 2026 02:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAF156B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 02:27:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8CB314044C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:27:09 +0000 (UTC)
X-FDA: 84859391778.06.427D96B
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id C8F51180009
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:27:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="xxiA/5vh";
	spf=pass (imf06.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780986427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9aeRdnbV388LSlN6uNHjyjk1cLTLhCFQsgwS8nSvgHI=;
	b=kaO/IhGFjjLQO+7eJPZ2MVW6Qhbmky9xmLtoI1wpPAD7yEpG4RDcOpgj2zgi2Up3pkQfYR
	pPDqweY5+YT2xqvfbxARFXX1d3lvYRCYX+PwdnDk0O1wNAjh2l8oK6uJkj9/ULwV5qnrL6
	Sj4ABfpCsKT56yuq9LSARhbxpoLR7i0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="xxiA/5vh";
	spf=pass (imf06.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780986427;
	b=LSxIEyjuZ7rL6RkNxpxbKZk7qNEwfWrEDODnn6fxswwnvwZqFIDi6ZcESmIuvVqTfTaRyc
	jUYLCwQPEQOur976AmD5H2ZFFSHEI0njCmozYJRqnDgOrNOtVi8yL9UnhCRr/O4emKPJEf
	jAF/Z7yK102iRI2NW7CW7kCZArPb3EY=
Message-ID: <26193499-e9dd-45e7-afc2-365685d6a749@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780986420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9aeRdnbV388LSlN6uNHjyjk1cLTLhCFQsgwS8nSvgHI=;
	b=xxiA/5vhR21obZU6/4xpAT1A1XzAqFMNny2GqfToJVEUSj2o54nzF6tKpQuRtg5/G5hZeA
	Bjfd8LRrBY1r7PGhJC6z1mesfJEbtDsazTBMvhOXnylDYcTTzwFhlqVVtuxAw0lrCL7pFq
	y5qK0GgSzpzhBserGbnkcLWETpYGxM4=
Date: Tue, 9 Jun 2026 14:26:04 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 5/6] kselftest: alloc_tag: add kselftest for ioctl
 interface
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>, Suren Baghdasaryan
 <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
References: <cover.1780701922.git.abhishekbapat@google.com>
 <2e55b3b1388a4f7a59f670a83f222ba6c836ac4e.1780701922.git.abhishekbapat@google.com>
 <49f725a7-577d-4036-bd5a-5a33fc9e17c3@linux.dev>
Content-Language: en-US
In-Reply-To: <49f725a7-577d-4036-bd5a-5a33fc9e17c3@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C8F51180009
X-Stat-Signature: zfbiup56jan1e1a3nim81xs3uszboonx
X-Rspam-User: 
X-HE-Tag: 1780986425-442701
X-HE-Meta: U2FsdGVkX1+DB0ngr50f4yHbp3oOdk1dgdF8dBKJV6DuV4XSVniqgTK3LwejcEjg0VoOjHfTzyt/Wb4h56haR8ZfX6OHdwKU4ZdeeUTxkSgNFlnzezpN5DuzswpYVEj//O39WOXvNczDXB9OWG7hqrfz2kA9nBWGkEp9aBI02q9ayc33Lz6nxXOhKX00b/JfmA1+ZRIP49UNySflNCPrTS4z5Bk2kga7eQ+YxfKexbiAH53qPQ2XZQ3NNnIJ/dqo8vy2eeXqHAPoq10/aqwaEkHJ/KX45koLmhuVD9GaFavtiU32Yfa3BnyyHyTE/acgxCuJkCP6hjmMnv/hteV7khOWfSF83QkCsTxC6Tkvjf9hWGWKpsjnhYa3Jc76MdX2dN438gSCOBN1VCR+BP8Yd5wBHz4bBnM3WNDD1gwX2cT7mYInLFvtAiHfZ9KnKBEtEnAlBt5Samvu+4MqdR9wiHqr2VYpYQR2jVYXVXZNV6lXJsgeUrE6V8shYsahCtcdelnOkz0NE2Ei7hsmRJKeMJONQQDsRrhPIO0xuU7SPM6xh6Blhjm0+j16HJ4Jb2F+5NhD7WwXK++WU0L1yrVQ1JHF7lFtmmgbtxxDjLWw7gttqNuXCwQRvuzdCqcVkbUqV7GLkY4LEUd5qTQxD5Nppe587fsHt0/59iBPYa31TxVsTz8eTEJcDe3S3VEIAVbnuL84wzpIsko1Hn7LTU2aSotEb8y++pv78CYBxo/PprntIq7CfhMbjKrZogi61IX4vTmdfB1h+XxDZxwxkebJC6651m1ooQppuJ7W2RKaLv5WAKEjdxfmo056OI8uy52/8/DKPy+rvwg2e3M4Y0lvaHsmJnUeYg1PoKz7I/auUcbV1C/c4xAcncmk+4+idYE8z38r8Eor/j3xXzBq32DfTDyBj8ZiY8ifq85rp/11w1kThLud2HOlOHuREs+0QhngA57HKD9fx58I20NOf5O
 sSSOdjlC
 +WTV99iE8lh5W/mOQ+3f1KrLy4oKmNHIZEv5nNB7IbRtolUu8OaTkdgVSmAaotivoybKDoML2AdTDIrSDkhWY1AOPGfOIgEwENWTe7C5EkmMiSYb2Bb8fksamj/NrUEVX2PXpvBMG9zh+Zf2BOmFAuNLB6NsnZfJu8rxr4JAZKp3ok6UGngXxswUchzK6rZ+FjOCbqsXU520GA0z4BZFli3amIaqqYk0pqT1TWAvncKEyvl/AfRaJ31wgvFzyM5FREY0gR/Prf9cOy4grmURzKoG0/HrC0hA5LQZDDhthN2zDZX3iKxdALT3FjNvvV08L7JkjtuUgtWJ5W9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/6/9 14:09, Hao Ge wrote:
> Hi Abhishek
>
>
> On 2026/6/6 07:36, Abhishek Bapat wrote:
>> Introduce a kselftest to verify the new IOCTL-based interface for
>> /proc/allocinfo. The test covers:
>>
>> 1. Validation of the filename filter.
>> 2. Validation of the function filter.
>>
>> The first test validates the functionality of the filename filter. Using
>> "mm/memory.c" as the candidate filename filter, it retrieves filtered
>> entries from both procfs and ioctl and matches the first VEC_MAX_ENTRIES
>> entries.
>>
>> The second test validates the functionality of the function filter.
>> It uses "dup_mm" as the candidate function as we do not expect this
>> function name to change frequently and hence won't be needing to modify
>> this test often.
>>
>> Note that both the tests match line no, function name and file name
>> fields. Bytes allocated and calls are not matched as those values may
>> change in the time when the data is being read from procfs and ioctl and
>> hence can lead to false negatives.
>>
>> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
>> ---
>>   MAINTAINERS                                   |   1 +
>>   tools/testing/selftests/alloc_tag/Makefile    |   9 +
>>   .../alloc_tag/allocinfo_ioctl_test.c          | 313 ++++++++++++++++++
>>   3 files changed, 323 insertions(+)
>>   create mode 100644 tools/testing/selftests/alloc_tag/Makefile
>>   create mode 100644 
>> tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 77f3fc487691..80560f5f1292 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -16713,6 +16713,7 @@ F:    include/linux/alloc_tag.h
>>   F:    include/linux/pgalloc_tag.h
>>   F:    include/uapi/linux/alloc_tag.h
>>   F:    lib/alloc_tag.c
>> +F:    tools/testing/selftests/alloc_tag/
>>     MEMORY CONTROLLER DRIVERS
>>   M:    Krzysztof Kozlowski <krzk@kernel.org>
>> diff --git a/tools/testing/selftests/alloc_tag/Makefile 
>> b/tools/testing/selftests/alloc_tag/Makefile
>> new file mode 100644
>> index 000000000000..f2b8fc022c3b
>> --- /dev/null
>> +++ b/tools/testing/selftests/alloc_tag/Makefile
>> @@ -0,0 +1,9 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +
>> +TEST_GEN_PROGS := allocinfo_ioctl_test
>> +
>> +CFLAGS += -Wall
>> +CFLAGS += -I../../../../usr/include
>> +
>> +include ../lib.mk
>> +
>> diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c 
>> b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
>> new file mode 100644
>> index 000000000000..5c3c16e86c23
>> --- /dev/null
>> +++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
>> @@ -0,0 +1,313 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +
>> +/* kselftest for allocinfo ioctl
>> + * allocinfo ioctl retrives allocinfo data through ioctl
>
>
> nit: s/retrives/retrieves/
>
>
> I've applied the full patch series locally and ran the kselftest, all 
> 4 tests pass:
>
> [root@localhost alloc_tag]# ./allocinfo_ioctl_test
> 1..4
> ok 1 test_filename_filter
> ok 2 test_function_filter
> ok 3 test_size_filter
> ok 4 test_lineno_filter
> # Totals: pass:4 fail:0 xfail:0 xpass:0 skip:0 error:0
>
> But there are no tests for ALLOCINFO_FILTER_MASK_MODNAME and
>
> ALLOCINFO_FILTER_MASK_INACCURATE.


Sorry, please disregard my suggestion about adding tests for

ALLOCINFO_FILTER_MASK_MODNAME and ALLOCINFO_FILTER_MASK_INACCURATE.

ALLOCINFO_FILTER_MASK_MODNAME depends on kernel config and also requires

the module to be loaded. ALLOCINFO_FILTER_MASK_INACCURATE entries may not

be common, unless we can find a stable way to produce them.


>
>
> Thanks
>
> Best Regards
>
> Hao
>
>> + * Copyright (C) 2026 Google, Inc.
>> + */
>> +
>> +#include <errno.h>
>> +#include <fcntl.h>
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <string.h>
>> +#include <stdbool.h>
>> +#include <unistd.h>
>> +#include <sys/ioctl.h>
>> +#include <linux/types.h>
>> +#include <linux/alloc_tag.h>
>> +#include "../kselftest.h"
>> +
>> +#define MAX_LINE_LEN        512
>> +#define ALLOCINFO_PROC        "/proc/allocinfo"
>> +
>> +enum ioctl_ret {
>> +    IOCTL_SUCCESS = 0,
>> +    IOCTL_FAILURE = 1,
>> +    IOCTL_INVALID_DATA = 2,
>> +};
>> +
>> +#define VEC_MAX_ENTRIES 32
>> +
>> +struct allocinfo_tag_data_vec {
>> +    struct allocinfo_tag_data tag[VEC_MAX_ENTRIES];
>> +    __u64 count;
>> +};
>> +
>> +static inline int __allocinfo_get_content_id(int dev_fd, struct 
>> allocinfo_content_id *params)
>> +{
>> +    return ioctl(dev_fd, ALLOCINFO_IOC_CONTENT_ID, params);
>> +}
>> +
>> +static inline int __allocinfo_get_at(int dev_fd, struct 
>> allocinfo_get_at *params)
>> +{
>> +    return ioctl(dev_fd, ALLOCINFO_IOC_GET_AT, params);
>> +}
>> +
>> +static inline int __allocinfo_get_next(int dev_fd, struct 
>> allocinfo_tag_data *params)
>> +{
>> +    return ioctl(dev_fd, ALLOCINFO_IOC_GET_NEXT, params);
>> +}
>> +
>> +static bool match_entry(const struct allocinfo_tag_data *procfs_entry,
>> +            const struct allocinfo_tag_data *tag_data,
>> +            bool match_bytes, bool match_calls, bool match_lineno,
>> +            bool match_function, bool match_filename)
>> +{
>> +    if (match_bytes && tag_data->counter.bytes != 
>> procfs_entry->counter.bytes) {
>> +        ksft_print_msg("size retrieved through ioctl does not match 
>> procfs\n");
>> +        return false;
>> +    }
>> +
>> +    if (match_calls && tag_data->counter.calls != 
>> procfs_entry->counter.calls) {
>> +        ksft_print_msg("call count retrieved through ioctl does not 
>> match procfs\n");
>> +        return false;
>> +    }
>> +
>> +    if (match_lineno && tag_data->tag.lineno != 
>> procfs_entry->tag.lineno) {
>> +        ksft_print_msg("lineno retrieved through ioctl does not 
>> match procfs\n");
>> +        return false;
>> +    }
>> +
>> +    if (match_function &&
>> +        strncmp(tag_data->tag.function, procfs_entry->tag.function, 
>> ALLOCINFO_STR_SIZE)) {
>> +        ksft_print_msg("function retrieved through ioctl does not 
>> match procfs\n");
>> +        return false;
>> +    }
>> +
>> +    if (match_filename &&
>> +        strncmp(tag_data->tag.filename, procfs_entry->tag.filename, 
>> ALLOCINFO_STR_SIZE)) {
>> +        ksft_print_msg("filename retrieved through ioctl does not 
>> match procfs\n");
>> +        return false;
>> +    }
>> +    return true;
>> +}
>> +
>> +static bool match_entries(const struct allocinfo_tag_data_vec 
>> *procfs_entries,
>> +              const struct allocinfo_tag_data_vec *tags,
>> +              bool match_bytes, bool match_calls, bool match_lineno,
>> +              bool match_function, bool match_filename)
>> +{
>> +    __u64 i;
>> +
>> +    if (procfs_entries->count != tags->count) {
>> +        ksft_print_msg("Entry count mismatch. ioctl entries: %llu, 
>> proc entries: %llu\n",
>> +                   tags->count, procfs_entries->count);
>> +        return false;
>> +    }
>> +    for (i = 0; i < procfs_entries->count; i++) {
>> +        if (!match_entry(&procfs_entries->tag[i], &tags->tag[i],
>> +                 match_bytes, match_calls, match_lineno,
>> +                 match_function, match_filename)) {
>> +            ksft_print_msg("%lluth entry does not match.\n", i);
>> +            return false;
>> +        }
>> +    }
>> +    return true;
>> +}
>> +
>> +static int get_filtered_procfs_entries(struct allocinfo_tag_data_vec 
>> *procfs_entries,
>> +                       const struct allocinfo_filter *filter, int fd)
>> +{
>> +    FILE *fp = fdopen(fd, "r");
>> +    char line[MAX_LINE_LEN];
>> +    int matches;
>> +    struct allocinfo_tag_data procfs_entry;
>> +
>> +    if (!fp) {
>> +        ksft_print_msg("Failed to open " ALLOCINFO_PROC " for 
>> reading\n");
>> +        return 1;
>> +    }
>> +    memset(procfs_entries, 0, sizeof(*procfs_entries));
>> +    while (fgets(line, sizeof(line), fp) && procfs_entries->count < 
>> VEC_MAX_ENTRIES) {
>> +
>> +        memset(&procfs_entry, 0, sizeof(procfs_entry));
>> +        matches = sscanf(line, "%llu %llu %[^:]:%llu func:%s",
>> +                 &procfs_entry.counter.bytes,
>> +                 &procfs_entry.counter.calls,
>> +                 procfs_entry.tag.filename,
>> +                 &procfs_entry.tag.lineno,
>> +                 procfs_entry.tag.function);
>> +
>> +        if (matches != 5)
>> +            continue;
>> +
>> +        if (filter->mask & ALLOCINFO_FILTER_MASK_FILENAME) {
>> +            if (strncmp(procfs_entry.tag.filename,
>> +                    filter->fields.filename, ALLOCINFO_STR_SIZE))
>> +                continue;
>> +        }
>> +        if (filter->mask & ALLOCINFO_FILTER_MASK_FUNCTION) {
>> +            if (strncmp(procfs_entry.tag.function,
>> +                    filter->fields.function, ALLOCINFO_STR_SIZE))
>> +                continue;
>> +        }
>> +        if (filter->mask & ALLOCINFO_FILTER_MASK_LINENO) {
>> +            if (procfs_entry.tag.lineno != filter->fields.lineno)
>> +                continue;
>> +        }
>> +        if (filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) {
>> +            if (procfs_entry.counter.bytes < filter->min_size)
>> +                continue;
>> +        }
>> +        if (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) {
>> +            if (procfs_entry.counter.bytes > filter->max_size)
>> +                continue;
>> +        }
>> +
>> + memcpy(&procfs_entries->tag[procfs_entries->count++], &procfs_entry,
>> +               sizeof(procfs_entry));
>> +    }
>> +    return 0;
>> +}
>> +
>> +static enum ioctl_ret get_filtered_ioctl_entries(struct 
>> allocinfo_tag_data_vec *tags,
>> +                         const struct allocinfo_filter *filter, int fd,
>> +                         __u64 start_pos)
>> +{
>> +    struct allocinfo_content_id start_cont_id, end_cont_id;
>> +    struct allocinfo_get_at get_at_params;
>> +    const int max_retries = 10;
>> +    int retry_count = 0;
>> +    int status;
>> +
>> +    /*
>> +     * __allocinfo_get_content_id may return different values if a 
>> kernel module was loaded
>> +     * between the two calls. If that happens, the data gathered 
>> cannot be considered consistent
>> +     * and hence needs to be fetched again to avoid flakiness.
>> +     */
>> +    do {
>> +        if (__allocinfo_get_content_id(fd, &start_cont_id)) {
>> +            ksft_print_msg("allocinfo_get_content_id failed\n");
>> +            return IOCTL_FAILURE;
>> +        }
>> +
>> +        memset(tags, 0, sizeof(*tags));
>> +        memset(&get_at_params, 0, sizeof(get_at_params));
>> +        memcpy(&get_at_params.filter, filter, sizeof(*filter));
>> +        get_at_params.pos = start_pos;
>> +        if (__allocinfo_get_at(fd, &get_at_params)) {
>> +            ksft_print_msg("allocinfo_get_at failed\n");
>> +            return IOCTL_FAILURE;
>> +        }
>> +        memcpy(&tags->tag[tags->count++], &get_at_params.data, 
>> sizeof(get_at_params.data));
>> +
>> +        while (tags->count < VEC_MAX_ENTRIES &&
>> +               __allocinfo_get_next(fd, &tags->tag[tags->count]) == 0)
>> +            tags->count++;
>> +
>> +        if (__allocinfo_get_content_id(fd, &end_cont_id)) {
>> +            ksft_print_msg("allocinfo_get_content_id failed\n");
>> +            return IOCTL_FAILURE;
>> +        }
>> +
>> +        if (start_cont_id.id == end_cont_id.id) {
>> +            status = IOCTL_SUCCESS;
>> +        } else {
>> +            ksft_print_msg("allocinfo_get_content_id mismatch, 
>> retrying...\n");
>> +            status = IOCTL_INVALID_DATA;
>> +        }
>> +    } while (status == IOCTL_INVALID_DATA && retry_count++ < 
>> max_retries);
>> +
>> +    return status;
>> +}
>> +
>> +static int run_filter_test(const struct allocinfo_filter *filter)
>> +{
>> +    int fd;
>> +    struct allocinfo_tag_data_vec *tags = malloc(sizeof(*tags));
>> +    struct allocinfo_tag_data_vec *procfs_entries = 
>> malloc(sizeof(*procfs_entries));
>> +    int ioctl_status;
>> +    int ret = KSFT_PASS;
>> +
>> +    if (!tags || !procfs_entries) {
>> +        ksft_print_msg("Memory allocation failed.\n");
>> +        ret = KSFT_FAIL;
>> +        goto freemem;
>> +    }
>> +
>> +    fd = open(ALLOCINFO_PROC, O_RDONLY);
>> +    if (fd < 0) {
>> +        ksft_exit_skip("Failed to open " ALLOCINFO_PROC ": %s\n", 
>> strerror(errno));
>> +        ret = KSFT_FAIL;
>> +        goto freemem;
>> +    }
>> +
>> +    if (get_filtered_procfs_entries(procfs_entries, filter, fd)) {
>> +        ksft_print_msg("Error retrieving entries from " 
>> ALLOCINFO_PROC "\n");
>> +        ret = KSFT_FAIL;
>> +        goto exit;
>> +    }
>> +
>> +    if (procfs_entries->count == 0) {
>> +        ksft_print_msg("No entries found in " ALLOCINFO_PROC ", 
>> skipping test\n");
>> +        ret = KSFT_SKIP;
>> +        goto exit;
>> +    }
>> +
>> +    ioctl_status = get_filtered_ioctl_entries(tags, filter, fd, 0);
>> +    if (ioctl_status == IOCTL_INVALID_DATA) {
>> +        ksft_print_msg("Trouble retrieving valid IOCTL entries, 
>> skipping.\n");
>> +        ret = KSFT_SKIP;
>> +        goto exit;
>> +    }
>> +    if (ioctl_status == IOCTL_FAILURE) {
>> +        ksft_print_msg("Error retrieving IOCTL entries.\n");
>> +        ret = KSFT_FAIL;
>> +        goto exit;
>> +    }
>> +
>> +    if (!match_entries(procfs_entries, tags, false, false, true, 
>> true, true))
>> +        ret = KSFT_FAIL;
>> +
>> +exit:
>> +    close(fd);
>> +freemem:
>> +    free(tags);
>> +    free(procfs_entries);
>> +    return ret;
>> +}
>> +
>> +static int test_filename_filter(void)
>> +{
>> +    struct allocinfo_filter filter;
>> +    const char *target_filename = "mm/memory.c";
>> +
>> +    memset(&filter, 0, sizeof(filter));
>> +    filter.mask |= ALLOCINFO_FILTER_MASK_FILENAME;
>> +    strncpy(filter.fields.filename, target_filename, 
>> ALLOCINFO_STR_SIZE);
>> +
>> +    return run_filter_test(&filter);
>> +}
>> +
>> +static int test_function_filter(void)
>> +{
>> +    struct allocinfo_filter filter;
>> +    const char *target_function = "dup_mm";
>> +
>> +    memset(&filter, 0, sizeof(filter));
>> +    filter.mask |= ALLOCINFO_FILTER_MASK_FUNCTION;
>> +    strncpy(filter.fields.function, target_function, 
>> ALLOCINFO_STR_SIZE);
>> +
>> +    return run_filter_test(&filter);
>> +}
>> +
>> +int main(int argc, char *argv[])
>> +{
>> +    int ret;
>> +
>> +    ksft_set_plan(2);
>> +
>> +    ret = test_filename_filter();
>> +    if (ret == KSFT_SKIP)
>> +        ksft_test_result_skip("Skipping test_filename_filter\n");
>> +    else
>> +        ksft_test_result(ret == KSFT_PASS, "test_filename_filter\n");
>> +
>> +    ret = test_function_filter();
>> +    if (ret == KSFT_SKIP)
>> +        ksft_test_result_skip("Skipping test_function_filter\n");
>> +    else
>> +        ksft_test_result(ret == KSFT_PASS, "test_function_filter\n");
>> +
>> +    ksft_finished();
>> +}

