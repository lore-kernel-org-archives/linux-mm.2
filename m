Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47D4ECD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 09:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4969A6B0005; Wed, 10 Jun 2026 05:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4473B6B0088; Wed, 10 Jun 2026 05:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35D226B008A; Wed, 10 Jun 2026 05:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 24D216B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 05:34:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54839A08F7
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:34:13 +0000 (UTC)
X-FDA: 84863491986.30.788B0DA
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2302E180006
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:34:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cjbT4HkY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781084051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dk7BqETwt1DrvYbxUKuqhVVwlZI00/HTv1khPS2seEc=;
	b=2qTFwnkqaAvKCcJWvHhEIhpUlbqfwZk2BnYCf03Q8JFWUav8ujGxO8tD3g4YdirHRLVPxb
	J8wS7Pc4HVTjeeZ4lvWalgozyPoTOQ9mb/6A+UyTZADhPKcjHjjhzeI+EKVGk0FHx+UX2Z
	ojezRwhnicgYb8lkKjUCu3aLLUwsERg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cjbT4HkY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781084051;
	b=UPbEbC0QSHUErCGUNqdWCAm1i3GBRYYWJCI9ZpUJPwP3OkktgKwQF8wvQe01T3AL/3Ekgo
	0rhLaplPmICKYAuToS9XBHfvHBpvFhxF3OPlvx0/WhcivcOPTSzyuHuZqJWfng9NfFNfO4
	nJRWRAA3Oj/F2w3DxqoXhjpZgQ/HAdM=
Message-ID: <c7ae2aa9-a1fb-4965-a213-f9cfb2aa101e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781084049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dk7BqETwt1DrvYbxUKuqhVVwlZI00/HTv1khPS2seEc=;
	b=cjbT4HkYBQVsl+bCiuvR2WfEUswGc3O0wL7S3NyuhEiVMtplPo4vtl1IuBW1YId1HFRhkQ
	vklsXeFT8lAWzpM/j3nl/JgjhJ4AYbEcRGmCqUUcXOTaTdBn2DVgQz+Mr1E/N2VfY5Q9Rk
	sPhTmFzZFQGCYRjtwjyaXNb5cmh+6oM=
Date: Wed, 10 Jun 2026 17:33:33 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 6/6] kselftest: alloc_tag: extend the allocinfo ioctl
 kselftest
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>, Suren Baghdasaryan
 <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
References: <cover.1781042698.git.abhishekbapat@google.com>
 <d0a8308b4d0799876d24461a8ed9b5a71d3e1e89.1781042698.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <d0a8308b4d0799876d24461a8ed9b5a71d3e1e89.1781042698.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 968o7hf8erqosqd5ihp8poigo5to5gp7
X-Rspamd-Queue-Id: 2302E180006
X-HE-Tag: 1781084050-47159
X-HE-Meta: U2FsdGVkX1+6KMKq1on3p/xEKmmPfUkdTRjbHOLVK8Fwovvyyfz+LrEP9i4s+d9LP+AEAV7TnAsoZU+E2hoatDJbcAOqsgiwOPNGDCyAQET9h7tD8g1axcgoQJ30Qv8cXB2JXRja7TmxIBbWoRTP6+U4y/tRQH/JNCfniW7ISRjvqk/ppYEnECCo8GGyqqRCWiAdOdtVAG0M7HgAgYVX0CFSk/aCFuT4Tz8SwD54XreunqA4UavzDfLR5EHzr9k/C963MpHyxZRtOa8X6CYKGXib1/lK6Q0GuqsLOFj9ny1ZtKso5QqG9cFTf8oBgdEpIDu17UmpiPfOgqVGOVPDe0L2B7mptqRV4tToOS6VCiFlSLV7puZmtyoty/KCAjRl3xFcwf1/CijFDVF0UEY7pUoXfMIy8S7IADBXS/zY5h/SvI+pVyhtKgKhmWtO1mWGlsnzqXO0hzUuXiQAPHHBRZwSTy31C7f1Q+6s7JsjbuCQ7vfqiTOXoP3eOwI6IPZXfM8/PpJ3ojsWDg+ZvlHyPUaoRY+rW9bn+RmWI81EamwGFdJbINVJkgHdJN+jPaHHb/tLA0gf7yp7+zdprBLicF9hpXcDJz3XTFtVxhNVnou3+KWxDXv9fLT/VCeMIdxwarUF1ZoIXfJuZAOF3v+xsdiBxN4trXVxK2EeKxDZ+UobrYcrDsI5BUyLmq51uDOceHUkvnfRzppBPqDuIZ+b3BnJBICakmgc9v74aNAbTArXHbrNKtqkxCC6BkdrU75MheCHUgvxf1Di4zcw8JT6JvT/1N+zy4sxQJ8s++KkFORZ2g6zy8VaJ09eAvRLS3RazQa/1/y+0Jtov+Zms9/7N+n6nlWa+ekPqb1oZDtrqrunkUcPl97TMs1DS8iWu+CC55Rk6uJh6o1cKF/hTBxkM8FFfuG1m3paqFUJcotW398V509xfOwdtG14DvyE5wyknUpug3aKImPLd2Jdg4+
 ckbus4uj
 RE2jamb4/63so96rwZ+dqyENWugLkV92H9KvvJBQCM+VTBW+nJy4qt3DUz+o2fNff/Lqtz9QhunmPHBw1L+jCIvOEAl4juk7Q2ePVQeoN3G5/PB4OFzWf2dypjSjOecZDpK3uqtCPSDgjq56HLre/mea/E6ODGm6oHaQH5RR51wouECapxK3Qf6juuxb2dcRkmptc0AbEi3hPt1Uyt994amTGgzSONU+hk4Lcm4KsLoTA0uVbMsL062Ypjzg66rJLqqzuMeQsSwxTIPui2yqwAXxBfrs3xLRNXajS4Xdv1FM6jdywM1XSvbK8Cp5Bgkn4yJyrKnyOtOL06krZwIzsP5Z3UA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek


On 2026/6/10 08:12, Abhishek Bapat wrote:
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
>   .../alloc_tag/allocinfo_ioctl_test.c          | 204 +++++++++++++++++-
>   1 file changed, 203 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> index cd9cf229ae1f..5d2f13900a47 100644
> --- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> +++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> @@ -311,11 +311,201 @@ static int test_function_filter(void)
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
> +	bool found;
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
> +		ksft_exit_skip("Failed to open " ALLOCINFO_PROC ": %s\n", strerror(errno));
> +		ret = KSFT_FAIL;
> +		goto freemem;
> +	}
> +
> +	do {
> +		found = false;
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
> +		if (get_filtered_procfs_entries(procfs_entries, &filter, fd)) {
> +			ksft_print_msg("Error retrieving entries from " ALLOCINFO_PROC "\n");
> +			ret = KSFT_FAIL;
> +			goto exit;
> +		}
> +


As I mentioned for patch 5, the retry loop in test_size_filter calls

get_filtered_procfs_entries() which reads fd to EOF via fdopen/fgets.

If a module load triggers a retry, the second call to 
get_filtered_procfs_entries() gets EOF

immediately.

And Sashiko has also reported several minor issues.


Thanks

Best Regards

Hao

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
> +					found = true;
> +					break;
> +				}
> +			}
> +
> +			if (found || tags->count < VEC_MAX_ENTRIES)
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
> +	if (start_cont_id.id == end_cont_id.id && !found) {
> +		ksft_print_msg("Entry with function %s not found in IOCTL results\n",
> +			       target_function);
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
> +	int fd;
> +	struct allocinfo_tag_data_vec *tags = malloc(sizeof(*tags));
> +	struct allocinfo_tag_data_vec *procfs_entries = malloc(sizeof(*procfs_entries));
> +	struct allocinfo_filter filter;
> +	enum ioctl_ret ioctl_status;
> +	int ret = KSFT_PASS;
> +	__u64 target_lineno, i;
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
> +	memset(&filter, 0, sizeof(filter));
> +
> +	if (get_filtered_procfs_entries(procfs_entries, &filter, fd)) {
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
> +	 * We depend on the result of procfs entries to create the ioctl_filter. Hence we
> +	 * cannot recycle the run_filter_test function here.
> +	 */
> +	target_lineno = procfs_entries->tag[0].tag.lineno;
> +
> +	filter.mask |= ALLOCINFO_FILTER_MASK_LINENO;
> +	filter.fields.lineno = target_lineno;
> +
> +	ioctl_status = get_filtered_ioctl_entries(tags, &filter, fd, 0);
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
>   int main(int argc, char *argv[])
>   {
>   	int ret;
>   
> -	ksft_set_plan(2);
> +	ksft_set_plan(4);
>   
>   	ret = test_filename_filter();
>   	if (ret == KSFT_SKIP)
> @@ -329,5 +519,17 @@ int main(int argc, char *argv[])
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

