Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 164D1C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 03:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10DD26B009E; Mon,  6 Jul 2026 23:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BEC36B009F; Mon,  6 Jul 2026 23:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16BB6B00A0; Mon,  6 Jul 2026 23:28:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8A326B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 23:28:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D2E71C7C8D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:28:18 +0000 (UTC)
X-FDA: 84960547476.20.05379F8
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id 383C2C0009
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:28:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DIjvS958;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783394896;
	b=mHzw2ifdKJ+xviFExWpqSybwkbdblOheZzWs9P0l27j4gbPEBRRW3mQ65TTzDfn2zyuPF4
	32L+aXSg40N49Xpz1AR5EJHfkPn9F8qwgofQr4isITmBR/jSMJXraAFuj40s8UYlLceqQ4
	jJTKlbiuklpNhDEe72/pPdZ3sjUjIEA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DIjvS958;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783394896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JEiA+pwtCXC1ZAr5AF0iwJd+evuAzVicLVb++73QmaU=;
	b=MvCdnTzMUaVvgxKhwlSea1vWtYBuUtAqoclPRdV/DA6ixqmbnNWa7YY46eE00DPgcUILJd
	riGNqXvbnXXpvWuaB3/QHrjm2ZKZUPRJ5LCT0Y76+heK82hgN6AM//InPj3HOg/D4+WdII
	hv87WQbJDCrI3J8/hTcZRBFFEmSws0w=
Message-ID: <4cc47988-49b3-4b73-90ed-a0a16a56a8dc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783394892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JEiA+pwtCXC1ZAr5AF0iwJd+evuAzVicLVb++73QmaU=;
	b=DIjvS958UCpmND1SKSWGn1h43DDuuBX48YGsON2jaSu/xihXISVbmmUZExTKUFXMVaHGIf
	CKSWLDC2J/coQlARTg6IV8eU96X6u6mWb3trdHEg5gVj3hf9QzqMNCFUrVdS/RcO/MTe78
	csk7cnTtb+mNxTbCgLtAL9tbBkOh0ls=
Date: Tue, 7 Jul 2026 11:27:40 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v7 6/6] kselftest: alloc_tag: extend the allocinfo ioctl
 kselftest
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>, Suren Baghdasaryan
 <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
References: <cover.1783361692.git.abhishekbapat@google.com>
 <f6bd1ff0257987dbb7512f93595eaa6962c6153b.1783361692.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <f6bd1ff0257987dbb7512f93595eaa6962c6153b.1783361692.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 383C2C0009
X-Stat-Signature: xoeraj5xtqwottwjgue367asikk7675h
X-HE-Tag: 1783394896-446186
X-HE-Meta: U2FsdGVkX18fasvD53N2wIqe6GTThJzFGnK1d1mTB0XiGWnI21xpZ7b/mKkI20mxA7ibvzO6rXyTz00+5R21fD0rWw5UEH6ukO7Ky8xGNdaWneVgQk6/823NECng+/ogUGBeNKKmfUpkY41IAR88yxTCN92fIhN70w3h7rN+Z88hipdu2UrVe7s3tYof9NvsYfsaK9EHw1KoHblOb6JOo30mvjnlxIPixhrStJMTOjUG7lQJcPmjdtmP376ry2zjCBJER9kkOFUHoxQrbZo2koZ1q3pZXAKFcRP23EvHTlO4vGz4Hjshg1rEJhK1ze59AeuATA//UMvyoEwsFF8KpGDRz4WiQ8i2gCj5SlHTr1okVV0B6LNFcdcP2hGfG0HKIblHPrexHkVTk4GfqAqeF0plwRUelFuc4oA8TO7FHhwVQG+sfLN5CyUHTmzXL8VrwaveZMOtVHzNjT/EbTq1Ps7OSDKHSm23FUg4+Hsm4DtzkSqvAzOcUlVIXxdjNieBjzOJ9yfshD7HgwSMPOZcM/spP3sDkfc4hiXdPw/gkXBjTsV0ZOFSjnTd7WYPr0/m8OqJeiwMLomymaDs1nc0EmWDpT0zmp187Ncr0WU5mGjQgo7m0D4+iGC3K/zSSlYyS2BWci/APy0K/e0noAesiw3cFsKaAGO8CpN7D9I6jXe+IwoOVzBN8gsFrOCsZ+IXas1cbjexQ67CCovH1GN1o7/nHUAlD5dXJJ+18trcNBXlcfEVwH4P86K94RaHZ1k/N0UZqHcGdRhtYSy+Z++zDIWiyKQwOL1ol+vZorK9q6tzHmwqDPzkNwz/5UYpgrDsNP860OmmUPxVj3+Wzq4iudju6bBgim2eS3DgC1ocUc31Bu09k8lV2r7Hn2hOq3eHQpQ4Qlo8zRBRC7DyzHNUtckzfZ2ci/WM+Lb0GljYXkn5HZsr8X+i0cDIlvEn2W8tlLWJFrMFbKf8HBf2Lex
 Xjpl2jpW
 kIEHqwQHz3tCku7XyTPeBkHxy5OVHWv4hoqJ2qxXclOYa25GbYl0pSewqLjwJ4f7rpdxdDBFuBhahL6+DVvY/aTszMAxBCUv8Ct9W2B/U7hWV/b56PvshLhoGdGWc0+0TT/KhUNAyQCmCliQxfdxwJhYWfet3HI+DWrppM8tpsAkR1o03kfBjvV2n/8emKkzY4Ch2oJQUgywmkeSGVyUl0j664h49qkhyZrtTdHW3XJbvmbfcxt01KJ8RwYyB5txmDzeKPvO1aqxBHSkUmADm0DMZGnx7DoaUW5U6L4mEvsmE82q0/LnmWZvqHYcNWbMX2RKJtsvH1s0e2W/0N+T6NWzz5HHYBttHRYPawfRcVtAuJIRnF/s2GBglwHhLXbznEBQ8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek


On 2026/7/7 02:25, Abhishek Bapat wrote:
> Add the following 2 scenarios to the allocinfo ioctl kselftest:
> 1. Validate size based filtering
> 2. Validate lineno based filtering
>
> The first test uses "do_init_module" as the candidate function for the
> test. This is because the associated site will only allocate memory when
> a kernel module is loaded. The return value of get_content_id() changes
> every time modules are loaded or unloaded. Hence, as long as
> get_content_id() values at the start and the end of the test are the
> same, the memory allocated by the do_init_module call site should also
> remain the same. Consequently, the test can assume consistency between
> the value returned by the ioctl and the procfs resulting in less
> flakiness.
>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> ---
>   .../alloc_tag/allocinfo_ioctl_test.c          | 216 +++++++++++++++++-
>   1 file changed, 215 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> index 9ce7b53078b1..092348097204 100644
> --- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> +++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> @@ -5,6 +5,7 @@
>    * Copyright (C) 2026 Google, Inc.
>    */
>   
> +#include <errno.h>
>   #include <fcntl.h>
>   #include <stdio.h>
>   #include <stdlib.h>
> @@ -312,11 +313,212 @@ static int test_function_filter(void)
>   	return run_filter_test(&filter);
>   }
>   
> +static int test_size_filter(void)
> +{
> +	int fd;
> +	struct allocinfo_tag_data_vec *tags = malloc(sizeof(*tags));
> +	struct allocinfo_tag_data_vec *procfs_entries = malloc(sizeof(*procfs_entries));
> +	struct allocinfo_filter filter;
> +	int ret = KSFT_PASS;
> +	__u64 target_size, i, pos;
> +	struct allocinfo_tag_data *found_tag = NULL;
> +	const char *target_function = "do_init_module";
> +	struct allocinfo_content_id start_cont_id, end_cont_id;
> +	int retry = 0;
> +	const int max_retries = 10;
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
> +		ret = KSFT_FAIL;
> +		goto freemem;
> +	}
> +
> +	do {
> +		found_tag = NULL;
> +		pos = 0;
> +
> +		if (__allocinfo_get_content_id(fd, &start_cont_id)) {
> +			ksft_print_msg("allocinfo_get_content_id failed\n");
> +			ret = KSFT_FAIL;
> +			goto exit;
> +		}
> +
> +		memset(&filter, 0, sizeof(filter));
> +		filter.mask |= ALLOCINFO_FILTER_MASK_FUNCTION;
> +		strncpy(filter.fields.function, target_function, ALLOCINFO_STR_SIZE);
> +
> +		if (get_filtered_procfs_entries(procfs_entries, &filter)) {
> +			ksft_print_msg("Error retrieving entries from " ALLOCINFO_PROC "\n");
> +			ret = KSFT_FAIL;
> +			goto exit;
> +		}
> +
> +		if (procfs_entries->count == 0) {
> +			ksft_print_msg("Function %s not found in procfs\n", target_function);
> +			ret = KSFT_SKIP;
> +			goto exit;
> +		}
> +
> +		target_size = procfs_entries->tag[0].counter.bytes;
> +
> +		memset(&filter, 0, sizeof(filter));
> +		filter.mask |= ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE;
> +		filter.min_size = target_size;
> +		filter.max_size = target_size;
> +
> +		while (1) {
> +			struct allocinfo_get_at get_at_params;
> +
> +			memset(&get_at_params, 0, sizeof(get_at_params));
> +			memcpy(&get_at_params.filter, &filter, sizeof(filter));
> +			get_at_params.pos = pos;
> +
> +			if (__allocinfo_get_at(fd, &get_at_params))
> +				break;
> +
> +			tags->count = 0;
> +			memcpy(&tags->tag[tags->count++], &get_at_params.data,
> +			       sizeof(get_at_params.data));
> +
> +			while (tags->count < VEC_MAX_ENTRIES &&
> +			       __allocinfo_get_next(fd, &tags->tag[tags->count]) == 0)
> +				tags->count++;
> +
> +			for (i = 0; i < tags->count; i++) {
> +				if (strcmp(tags->tag[i].tag.function, target_function) == 0) {
> +					found_tag = &tags->tag[i];
> +					break;
> +				}
> +			}
> +
> +			if (found_tag || tags->count < VEC_MAX_ENTRIES)
> +				break;
> +
> +			pos += tags->count;
> +		}
> +
> +		if (__allocinfo_get_content_id(fd, &end_cont_id)) {
> +			ksft_print_msg("allocinfo_get_content_id failed\n");
> +			ret = KSFT_FAIL;
> +			goto exit;
> +		}
> +
> +		if (start_cont_id.id == end_cont_id.id)
> +			break;
> +
> +		ksft_print_msg("Module load detected during size verification, retrying...\n");
> +	} while (retry++ < max_retries);
> +
> +	if (start_cont_id.id == end_cont_id.id && !found_tag) {
> +		ksft_print_msg("Entry with function %s not found in IOCTL results\n",
> +			       target_function);
> +		ret = KSFT_FAIL;
> +	} else if (start_cont_id.id != end_cont_id.id) {
> +		ksft_print_msg("Failed to match content_ids for procfs and IOCTL, skipping...\n");
> +		ret = KSFT_SKIP;
> +	} else if (found_tag && found_tag->counter.bytes != target_size) {
> +		ksft_print_msg("IOCTL entry size %llu does not match target size %llu\n",
> +			       found_tag->counter.bytes, target_size);
> +		ret = KSFT_FAIL;
> +	}
> +
> +exit:
> +	close(fd);
> +freemem:
> +	free(tags);
> +	free(procfs_entries);
> +	return ret;
> +}
> +
> +static int test_lineno_filter(void)
> +{
> +	struct allocinfo_tag_data_vec *tags = malloc(sizeof(*tags));
> +	struct allocinfo_tag_data_vec *procfs_entries = malloc(sizeof(*procfs_entries));
> +	struct allocinfo_filter filter;
> +	enum ioctl_ret ioctl_status;
> +	int ret = KSFT_PASS;
> +	__u64 target_lineno, i;
> +	struct allocinfo_tag_data *target_tag;
> +	bool found = false;
> +
> +	if (!tags || !procfs_entries) {
> +		ksft_print_msg("Memory allocation failed.\n");
> +		ret = KSFT_FAIL;
> +		goto exit;
> +	}
> +
> +	memset(&filter, 0, sizeof(filter));
> +
> +	if (get_filtered_procfs_entries(procfs_entries, &filter)) {
> +		ksft_print_msg("Error retrieving entries from " ALLOCINFO_PROC "\n");
> +		ret = KSFT_FAIL;
> +		goto exit;
> +	}
> +	if (procfs_entries->count == 0) {
> +		ksft_print_msg("Could not retrieve procfs entries\n");
> +		ret = KSFT_SKIP;
> +		goto exit;
> +	}
> +	/*
> +	 * We depend on the procfs results to determine the line number for the filter before
> +	 * making the ioctl query. Hence, we cannot reuse run_filter_test here.
> +	 */
> +	target_tag = &procfs_entries->tag[0];
> +	target_lineno = target_tag->tag.lineno;
> +
> +	filter.mask |= ALLOCINFO_FILTER_MASK_LINENO;
> +	filter.fields.lineno = target_lineno;
> +
> +	ioctl_status = get_filtered_ioctl_entries(tags, &filter, 0);
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
> +	for (i = 0; i < tags->count; i++) {
> +		if (tags->tag[i].tag.lineno != target_lineno) {
> +			ksft_print_msg("IOCTL entry %llu has incorrect lineno %llu.\n",
> +				       i, tags->tag[i].tag.lineno);
> +			ret = KSFT_FAIL;
> +			goto exit;
> +		}
> +
> +		if (strncmp(tags->tag[i].tag.function, target_tag->tag.function,
> +			    ALLOCINFO_STR_SIZE) == 0 &&
> +		    strncmp(tags->tag[i].tag.filename, target_tag->tag.filename,
> +			    ALLOCINFO_STR_SIZE) == 0)
> +			found = true;
> +	}
> +
> +	if (!found) {
> +		ksft_print_msg("Original procfs entry not found in IOCTL lineno filter results.\n");
> +		ret = KSFT_FAIL;
> +	}
> +
> +exit:
> +	free(tags);
> +	free(procfs_entries);
> +	return ret;
> +}
> +
>   int main(int argc, char *argv[])
>   {
>   	int ret;
>   
> -	ksft_set_plan(2);
> +	ksft_set_plan(4);
>   
>   	ret = test_filename_filter();
>   	if (ret == KSFT_SKIP)
> @@ -330,5 +532,17 @@ int main(int argc, char *argv[])
>   	else
>   		ksft_test_result(ret == KSFT_PASS, "test_function_filter\n");
>   
> +	ret = test_size_filter();
> +	if (ret == KSFT_SKIP)
> +		ksft_test_result_skip("Skipping test_size_filter\n");
> +	else
> +		ksft_test_result(ret == KSFT_PASS, "test_size_filter\n");
> +
> +	ret = test_lineno_filter();
> +	if (ret == KSFT_SKIP)
> +		ksft_test_result_skip("Skipping test_lineno_filter\n");
> +	else
> +		ksft_test_result(ret == KSFT_PASS, "test_lineno_filter\n");
> +
>   	ksft_finished();
>   }


https://sashiko.dev/#/patchset/cover.1783361692.git.abhishekbapat%40google.com

Sashiko is really strict, but its warnings are legitimate. I ran the 
test program on a kernel built without

CONFIG_MEM_ALLOC_PROFILING, and here are the results:


[root@localhost alloc_tag]# ./allocinfo_ioctl_test
1..4
# Failed to open /proc/allocinfo for reading
# Error retrieving entries from /proc/allocinfo
ok 1 # SKIP Skipping test_filename_filter
# Failed to open /proc/allocinfo for reading
# Error retrieving entries from /proc/allocinfo
ok 2 # SKIP Skipping test_function_filter
# Failed to open /proc/allocinfo: No such file or directory
not ok 3 test_size_filter
# Failed to open /proc/allocinfo for reading
# Error retrieving entries from /proc/allocinfo
not ok 4 test_lineno_filter
# 2 skipped test(s) detected. Consider enabling relevant config options 
to improve coverage.
# Totals: pass:0 fail:2 xfail:0 xpass:0 skip:2 error:0
[root@localhost alloc_tag]#


Looking at the test log above, some tests that ought to be skipped are 
flagged as failures.

Would it make sense for us to go through all relevant test cases in the 
codebase,

and check if we've missed any logic to skip tests when /proc/allocinfo 
is missing

due to CONFIG_MEM_ALLOC_PROFILING being disabled?


BTW,  when merging this series into the latest mm-new branch, there will 
be a minor header file conflict.

This is because the series at 
https://lore.kernel.org/all/20260703-alloc-trylock-v5-15-c87b714e19d3@google.com 
was merged ahead of this change.

We might want to consider rebasing this series to resolve the header 
conflict.


Thanks

Best Regards

Hao



