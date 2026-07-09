Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3904AC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 07:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 047066B008A; Thu,  9 Jul 2026 03:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3A236B008C; Thu,  9 Jul 2026 03:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2C486B0092; Thu,  9 Jul 2026 03:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4A526B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:47:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A59B8DD84
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:47:37 +0000 (UTC)
X-FDA: 84968458554.22.C93B464
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 19B78140005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:47:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wr5hOQzO;
	spf=pass (imf09.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783583255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3fogsgOQM4/1FaO0lwHcVAgzkNI1hP1CHJlr2Huc2Ho=;
	b=16KNSalvsndWo9UFAa3eR827qvkRIMAmMTaMQ/dDuNIm9jiZTHZKCVtNCau+NZfpxx0/u9
	bxFBcP4rHYjXhHbXb8teTIsGSi46XKISNekX+s/ah1akQfUvyRM82tXB0bRrTu4a3yz0Zh
	R2evNFTYRBvqrz+PecV+t4AfQJINYO4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wr5hOQzO;
	spf=pass (imf09.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783583255;
	b=E9QSaX13CLTIkkT4c4By4zfWDQSljl7E5bt4atfci8dEA+3ljB4KFieR9+Ly1ouVNC15IF
	UOXtEyblHlPmjGrT2OGWxSAqh6+ZOPMZ9auHJlDUNFL7IVcbvonBq5SM+/eneLzhCtWGng
	wWZDTB6eY37Ls+2qYOHLdLRFNCm9efQ=
Message-ID: <9d92b421-b4f5-40b1-9f17-6039cd0571e9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783583253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3fogsgOQM4/1FaO0lwHcVAgzkNI1hP1CHJlr2Huc2Ho=;
	b=Wr5hOQzOAZwYbqdAfD+ha91JJThOskL3Wd29Jp8NP3LWd34/wDhhHoGH0IKQ4K+EZV3cZp
	nwIGVoWYsRtQ9VkiVz0Uzk4aULh2rHSwVXvmGQRHELGHWdDYkOQ/ncbD/+xbn9ERjL8cg1
	Db1PAOipOStXFv7uRUJmqH14Sw4izmg=
Date: Thu, 9 Jul 2026 15:47:28 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v8 6/6] kselftest: alloc_tag: extend the allocinfo ioctl
 kselftest
To: Abhishek Bapat <abhishekbapat@google.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>
References: <cover.1783532853.git.abhishekbapat@google.com>
 <e5171926b48802531284c1cb5f04734017141341.1783532853.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <e5171926b48802531284c1cb5f04734017141341.1783532853.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 19B78140005
X-Stat-Signature: c6n6r1ueihowp4ionwe8c8fsp9fs4hrt
X-HE-Tag: 1783583254-672747
X-HE-Meta: U2FsdGVkX18qjFFzWa/mEuUWgR/RRi06jTsjqYokzUb0xvbGZTrUnnworOA2Hdwanaq4DlMcqYCN0HeCKFxi3vOUklrnIlpFZl0yeqTjw7mMGMmkPVeEP6o11VW1RTwOZ5XtXVYhqhpVxjgvQMq6ntkfwH2sAahBUjkIw3L6KSVyOfB59MsfXPt1LcHDl71sUOxwF7vpsQFUD2tytOQs7rU8w0BA1EF+674RChkY0dkuaekQI/KI1Tc0jlmfkcklHfOtp1sFPu6MWLm+Z+5yhA5YYI7qqclSHjXuIHsYtEL0F39qQrZUM5x011iZuqD/Vq6SjlMtrVlWfNk33OFX8VkIU1quYybDY4W0GecKUuMJd1Hr1O52Nmb2ETdBm745OOhQufH+bAZMOBbybpipjW3y6MqAemwkn3GoZcWjoTCUA7K/LdaLOzb0YTVnbbOhwEaYEjq4cy1vsoLoDs7fN3QD8zj7nC7wd3vXNST4Mnm324cpz0u59/oFzaTfzWhivZfpHWGGH3BN4mRyB56+K3ktXjAZktAWs7uihXXiSPGJW20vAAC7rib5/f16FLthBctNpmPM8cprt0gkT2FTWmCJH7NidOv+OQHkyFHovdhXCyPIIROEDpe7HnbcOvRfrSrVPvrpm3o5tfopgvC+cijq7uP2syFstjcuEgYM4i3qfX8bHFTK+95WxmHfAwWhtjfF1/bFjgx2YtbMfST4clkR+UVaDClA7ZUR/wcLg94U1UeZ9iN1Ui/zqVyMVfnCZfF8qmhtrPkOK93Nbe99B125KbugvepL5sPCB7E3mI8Ch9uQF+A7Sdn88nuc7X/srXigde48aIa26495zVtTaeMwJGJLTLzws1rJUCuVaUa36N3s20C02GTQcOmWrjASRZxNtfS/b7y4CtRNq/u7su2Q5BqU0lDEqNtv/kQPllQVVIEHqYLVvSHiBZVRNjgQpDg1jEd91neMrqCo1l9
 qajU1hFr
 vT8oF2HqasKiku9hC5n6PQrj9X5P4pQo/5B31EYhcaK1BQFWo4UW7N6hk/GMvZRRl2QTLLzibMpWB12xOEGgCY6lxO67ot7IejkBoNfsxTwQ6fi/SgjAyqOuo7w/tBn53lxKepDTX4XrzsFNlTOBIswlFkvmPTx6q/vSpp5Yj1GdOYDRU8cHcDRK8lV13jGf5G3z1Xh3VpyDTpraFT6mJpEfqt2+MOQuYvSdSYtN3R+1+tsOk8R643Bg4OFtU5IoECvz4zdzwy0HiGxsYNJPwj7cDKtk4QlC0UDCiDGfC0EVUSrpwfdKOgfzvB9IwC03U8Jxm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek


On 2026/7/9 02:01, Abhishek Bapat wrote:
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


Tested-by: Hao Ge <hao.ge@linux.dev>

Acked-by: Hao Ge <hao.ge@linux.dev>


> ---
>   .../alloc_tag/allocinfo_ioctl_test.c          | 216 +++++++++++++++++-
>   1 file changed, 215 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> index 9ce7b53078b1..7d94abb785a1 100644
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
> +		ret = KSFT_SKIP;
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
> +			ret = KSFT_SKIP;
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
> +		ret = KSFT_SKIP;
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

