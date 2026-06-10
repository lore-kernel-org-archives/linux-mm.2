Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DF17CD8CAD
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 00:13:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14CF96B00A1; Tue,  9 Jun 2026 20:13:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B02A6B00A2; Tue,  9 Jun 2026 20:13:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E91C56B00A3; Tue,  9 Jun 2026 20:13:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3AE26B00A1
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:13:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 90DD21C29B6
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:13:17 +0000 (UTC)
X-FDA: 84862078434.25.168033D
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf11.hostedemail.com (Postfix) with ESMTP id C094C40006
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:13:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lhnaCvlP;
	spf=pass (imf11.hostedemail.com: domain of 3Gqwoag0KCG0LMSTdSPVMLaLeRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3Gqwoag0KCG0LMSTdSPVMLaLeRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781050395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UqbNILcH5wHHhr41jH351ypxsRzTCj5EvG750gJRyes=;
	b=hJV4ZyLVXu3mZI+9fsBj5zKsPv3cB/NNrxL9j2Q//y8STu2k33aWIywf8in+RMfnCwUqFy
	KcYylGXzVkelgPXfE/Cd0wCzguvMKjGndia50ZbE8CHb8DgjvSDBmjfWbdB1e75bENPfxt
	rSmLPqYZU/Z+mC8G/B4mdr9aHS31huM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781050395;
	b=y5PWLpEbFBoVXVNLyImsYfLfC25Np4n9C/Z5YYPmQhFve1H/U9OaQem78vvsh1m8Rtq0a9
	6vOaBu0stHfg4W+swOwjSaonNxh2hGFwTcYwwB4TVGEagg6f5wTOYZUPi9HiL8h2beQS5W
	06MGAZHI73BjNvpExJOkSVHk9QlIhdI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lhnaCvlP;
	spf=pass (imf11.hostedemail.com: domain of 3Gqwoag0KCG0LMSTdSPVMLaLeRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3Gqwoag0KCG0LMSTdSPVMLaLeRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-30761ab3483so531178eec.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 17:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781050395; x=1781655195; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UqbNILcH5wHHhr41jH351ypxsRzTCj5EvG750gJRyes=;
        b=lhnaCvlP4QnvteVm43MlrzjUKjuXPrO3U//GQoUikb1Cj5kVqV/OiSheKObAqPthhK
         HreE8N/0wdWwejY7FjXHGghKhlq9to89uqtls6f7qfOc+UBXHjCx1ZxChzyd9N30l5UF
         5wtKEVL1ZmFirmebzLQyMGpSq9fEK8k1tIUkV1TFQ+kpo26rXjlvh4ETOeJiUPT2Iuk4
         fwA82nDM3TsUyUPIgQr3dGpQVQtS7+ICUwOoCMFceOIufTTAklEm8F4jcq8h/FSn3fVp
         ES54Bcf2Ay1GGh879ZoQbh0vzY3Cb42/LX/nW9O9oIjL4f4lXJPjAmwXYQuSyidYQNxr
         KC9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781050395; x=1781655195;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UqbNILcH5wHHhr41jH351ypxsRzTCj5EvG750gJRyes=;
        b=Tvf4DulNZjRE2d+Qrx24DHAgdfFWHAtDu4yLM8k16vBxv1PLQKugcryfFRaELvjt5H
         E/GYwExG3Eg48pGuCDj/Gho7JqJnvlDmmxSoUigb413nNx481LSJojn8revA6hC23Arx
         B8aEEnRQxau6WO/SapfdxtiqXcVa5/um0RtV0N00u2i8CAG/syti0amd/4fBIG2epW/8
         Irk/5uf7LhwdsX4zewoWFYjUOyCZbFUZTTeItVpRquyRHYqLcMBea0+zvDmZY4eNdJTl
         oXFKCFibZKDOUzqnJiEcPgs6pRhoUeQa0ZH8W+Fs/tb1WMgLmKo7LQC4zKhOhBF2uN30
         vdzA==
X-Forwarded-Encrypted: i=1; AFNElJ+RsZgKcJ6KtbSkSWGUoSTZsvXAmPHvaYH1GBZo+lscqmnZARqBSQ8lt0dSUgbPdcnEhfVZxkMj+w==@kvack.org
X-Gm-Message-State: AOJu0Yx58am7gcUwwtdFkWKtzKRv8QyZ3U3nbnF2o8smHsFj0gTAWdE6
	vIvXa6/ODl6g456ehar7cFjtTk7vncY326N/c02P4L8ePY8VWxoSe4E9b+4563yMrWrGxFMlAsy
	/HTmqXF4/VAoHV2WkWBvwyN/87BDxfdEd2g==
X-Received: from dyev5.prod.google.com ([2002:a05:7300:4305:b0:307:a303:44ea])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:534f:b0:304:c520:4e0c with SMTP id 5a478bee46e88-307d5fc2817mr4420578eec.6.1781050394482;
 Tue, 09 Jun 2026 17:13:14 -0700 (PDT)
Date: Wed, 10 Jun 2026 00:12:59 +0000
In-Reply-To: <cover.1781042698.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1781042698.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <d0a8308b4d0799876d24461a8ed9b5a71d3e1e89.1781042698.git.abhishekbapat@google.com>
Subject: [PATCH v4 6/6] kselftest: alloc_tag: extend the allocinfo ioctl kselftest
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C094C40006
X-Rspam-User: 
X-Stat-Signature: yqdhp6u4wzwe1uibxjhbobb43jfhruba
X-Rspamd-Server: rspam08
X-HE-Tag: 1781050395-15488
X-HE-Meta: U2FsdGVkX19Pv+yzvq2fQZDRbogmXlr1ZyrlSqa6U+y3L54fjLOu8djzJGPjJdUR94Sv62v26+1draBmg/GBvZGrPvPq1QOla2FkbNdKgAZEJzyTLxbh98TwsDdL4kqo0Q8KurVqWixyI6rqH+t/CbRq2s7/g0qkzEBr2RcZklNdx5uskPnMHoNH/xu39Ox16JVoVONbmfFpwPOaZlieXGtZDy6po7MGkN+q3BAX9vgBA0eIzpWTuCa+MmkZ9GUeTszAszvmjA2q4eNN6WtQ26AWodeeYRpP+dmiOENoqnaT23O1O1ud1AGYTILKARd3Te7TDAV0buogQXEhAl1oVh8X2xUqbv6K3pSdsacC4oy+VxW5hQBioL02rg+3VBB5FrCXwkkY0xQ9vssM+ul6FVZPr0cFmL6h+BFHsPboqvSk2NU9wkJtK/XqBPmPf5W0akgLG3WZMsOo3fZU30AlVpiHBT9DAw/HK/Pmi8nph+6ldCDFyAvJUpWCyA4O+aZSN4PZNvtDTiak3Q/bVcjY14/1WcZCQaLRKJCnlrVBGJ3P4Ik+sFRVVfG7r0wB8/A+h/oj7BMi73SO9ejO7xUKD1xk772OD5+YxBpIxcByWuLAqmMUIXZvP3PNXe9iW8NI/G2FiACv4WY8MWWdCU1p3D2zE/fkYbQarfX8BYMPmk0UQxRBOlIcKN4XJm9H/K2IU0QzM6x/7NWv1gYSGPni3p10QJ/WrWRag00vj+tiwRRUy4vr/Ad4ZqIFOnYkqZZ9a6AI6ByaHDAlbIULNFCMX6C/K2QsYzAVGmHH32s4gl898/osY8ILw8LZUpqbgxXyGhjhpGshIm07rRkGiylt6KbVn3DdmB6+SD4Wx3O82+SRRlecjVjoTev9100cq/nEpGVyW7hXeij4IVHrE3fIpUNKoQr22zZl2cUCOlccLCvSZ2v44O1oMiRo7KNMSOTzgNFuLqKp2Q7swpQ7ww0
 V3j6GaPT
 oTlGqe/FbvrSBihoRZwXjwx5uPMN091jZaUbZFiYyF0ftTcYSkNRewy+OzvuX+t+8FkWGOtdiCAdupTWs79Ellf4oB/AdVNf08tzMfpwgZcSAmDCzp49wW3SEzi+JgfabnxPQE9OQKm6StT1w2J1YUQhWinGhmQ2EvNLnAm0spuq2jZw6zvmbSrZ5dfd7vHmdnz/VrxRWdmTPVFdVvBOLSqemivfcLUPt+gFhNaPFKjNwDGd5wVZknSgBF6X6m2N3CZNggtcaa7MamRvThyFqGnNXF3wU/vhv6OH6sUzgKxdKfQwNW3iydXoNPn/ZpaRd7ePervxyMkcurSGi+SWFeSsK/k8HNEUHY1k77/ThbvCNPrmkRlJyQ1LvqNevH2Dh0vVUiLWQ2HojwFkdy6rWImdRujAuuBRDXJWjuqKFJLS16fmWgoXwn6yTt7gFAtiqq4J+P8bRaV3wzpfBqxM/w0PRlpIzY8GBmHd8xrZ0fPTLt2h+4aljRnNB4KuQV1cPDb2WgLr8LJeEtrWyQEbqOXYMpbEgFDRKGLJBDHTC1tIlD4MUPYnju6PsmMeZm6kIbBz+2uLgYk2NLJutu6YbC5JrfWDoDHF0W4co9VbAiUhgDF1ErOSbABE8b4VNdjRDZKmqUO9cGXp4/HM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the following 2 scenarios to the allocinfo ioctl kselftest:
1. Validate size based filtering
2. Validate lineno based filtering

The first test uses "do_init_module" as the candidate function for the
test. This is because the associated site will only allocate memory when
a kernel module is loaded. The return value of get_content_id() changes
every time modules are loaded or unloaded. Hence, as long as
get_content_id() values at the start and the end of the test are the
same, the memory allocated by the do_init_module call site should also
remain the same. Consequently, the test can assume consistency between
the value returned by the ioctl and the procfs resulting in less
flakiness.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 .../alloc_tag/allocinfo_ioctl_test.c          | 204 +++++++++++++++++-
 1 file changed, 203 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
index cd9cf229ae1f..5d2f13900a47 100644
--- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
+++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
@@ -311,11 +311,201 @@ static int test_function_filter(void)
 	return run_filter_test(&filter);
 }
 
+static int test_size_filter(void)
+{
+	int fd;
+	struct allocinfo_tag_data_vec *tags = malloc(sizeof(*tags));
+	struct allocinfo_tag_data_vec *procfs_entries = malloc(sizeof(*procfs_entries));
+	struct allocinfo_filter filter;
+	int ret = KSFT_PASS;
+	__u64 target_size, i, pos;
+	bool found;
+	const char *target_function = "do_init_module";
+	struct allocinfo_content_id start_cont_id, end_cont_id;
+	int retry = 0;
+	const int max_retries = 10;
+
+	if (!tags || !procfs_entries) {
+		ksft_print_msg("Memory allocation failed.\n");
+		ret = KSFT_FAIL;
+		goto freemem;
+	}
+
+	fd = open(ALLOCINFO_PROC, O_RDONLY);
+	if (fd < 0) {
+		ksft_exit_skip("Failed to open " ALLOCINFO_PROC ": %s\n", strerror(errno));
+		ret = KSFT_FAIL;
+		goto freemem;
+	}
+
+	do {
+		found = false;
+		pos = 0;
+
+		if (__allocinfo_get_content_id(fd, &start_cont_id)) {
+			ksft_print_msg("allocinfo_get_content_id failed\n");
+			ret = KSFT_FAIL;
+			goto exit;
+		}
+
+		memset(&filter, 0, sizeof(filter));
+		filter.mask |= ALLOCINFO_FILTER_MASK_FUNCTION;
+		strncpy(filter.fields.function, target_function, ALLOCINFO_STR_SIZE);
+
+		if (get_filtered_procfs_entries(procfs_entries, &filter, fd)) {
+			ksft_print_msg("Error retrieving entries from " ALLOCINFO_PROC "\n");
+			ret = KSFT_FAIL;
+			goto exit;
+		}
+
+		if (procfs_entries->count == 0) {
+			ksft_print_msg("Function %s not found in procfs\n", target_function);
+			ret = KSFT_SKIP;
+			goto exit;
+		}
+
+		target_size = procfs_entries->tag[0].counter.bytes;
+
+		memset(&filter, 0, sizeof(filter));
+		filter.mask |= ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE;
+		filter.min_size = target_size;
+		filter.max_size = target_size;
+
+		while (1) {
+			struct allocinfo_get_at get_at_params;
+
+			memset(&get_at_params, 0, sizeof(get_at_params));
+			memcpy(&get_at_params.filter, &filter, sizeof(filter));
+			get_at_params.pos = pos;
+
+			if (__allocinfo_get_at(fd, &get_at_params))
+				break;
+
+			tags->count = 0;
+			memcpy(&tags->tag[tags->count++], &get_at_params.data,
+			       sizeof(get_at_params.data));
+
+			while (tags->count < VEC_MAX_ENTRIES &&
+			       __allocinfo_get_next(fd, &tags->tag[tags->count]) == 0)
+				tags->count++;
+
+			for (i = 0; i < tags->count; i++) {
+				if (strcmp(tags->tag[i].tag.function, target_function) == 0) {
+					found = true;
+					break;
+				}
+			}
+
+			if (found || tags->count < VEC_MAX_ENTRIES)
+				break;
+
+			pos += tags->count;
+		}
+
+		if (__allocinfo_get_content_id(fd, &end_cont_id)) {
+			ksft_print_msg("allocinfo_get_content_id failed\n");
+			ret = KSFT_FAIL;
+			goto exit;
+		}
+
+		if (start_cont_id.id == end_cont_id.id)
+			break;
+
+		ksft_print_msg("Module load detected during size verification, retrying...\n");
+	} while (retry++ < max_retries);
+
+	if (start_cont_id.id == end_cont_id.id && !found) {
+		ksft_print_msg("Entry with function %s not found in IOCTL results\n",
+			       target_function);
+		ret = KSFT_FAIL;
+	}
+
+exit:
+	close(fd);
+freemem:
+	free(tags);
+	free(procfs_entries);
+	return ret;
+}
+
+static int test_lineno_filter(void)
+{
+	int fd;
+	struct allocinfo_tag_data_vec *tags = malloc(sizeof(*tags));
+	struct allocinfo_tag_data_vec *procfs_entries = malloc(sizeof(*procfs_entries));
+	struct allocinfo_filter filter;
+	enum ioctl_ret ioctl_status;
+	int ret = KSFT_PASS;
+	__u64 target_lineno, i;
+
+	if (!tags || !procfs_entries) {
+		ksft_print_msg("Memory allocation failed.\n");
+		ret = KSFT_FAIL;
+		goto freemem;
+	}
+
+	fd = open(ALLOCINFO_PROC, O_RDONLY);
+	if (fd < 0) {
+		ksft_exit_skip("Failed to open " ALLOCINFO_PROC ": %s\n", strerror(errno));
+		ret = KSFT_FAIL;
+		goto freemem;
+	}
+
+	memset(&filter, 0, sizeof(filter));
+
+	if (get_filtered_procfs_entries(procfs_entries, &filter, fd)) {
+		ksft_print_msg("Error retrieving entries from " ALLOCINFO_PROC "\n");
+		ret = KSFT_FAIL;
+		goto exit;
+	}
+	if (procfs_entries->count == 0) {
+		ksft_print_msg("Could not retrieve procfs entries\n");
+		ret = KSFT_SKIP;
+		goto exit;
+	}
+	/*
+	 * We depend on the result of procfs entries to create the ioctl_filter. Hence we
+	 * cannot recycle the run_filter_test function here.
+	 */
+	target_lineno = procfs_entries->tag[0].tag.lineno;
+
+	filter.mask |= ALLOCINFO_FILTER_MASK_LINENO;
+	filter.fields.lineno = target_lineno;
+
+	ioctl_status = get_filtered_ioctl_entries(tags, &filter, fd, 0);
+	if (ioctl_status == IOCTL_INVALID_DATA) {
+		ksft_print_msg("Trouble retrieving valid IOCTL entries, skipping.\n");
+		ret = KSFT_SKIP;
+		goto exit;
+	}
+	if (ioctl_status == IOCTL_FAILURE) {
+		ksft_print_msg("Error retrieving IOCTL entries.\n");
+		ret = KSFT_FAIL;
+		goto exit;
+	}
+
+	for (i = 0; i < tags->count; i++) {
+		if (tags->tag[i].tag.lineno != target_lineno) {
+			ksft_print_msg("IOCTL entry %llu has incorrect lineno %llu.\n",
+				       i, tags->tag[i].tag.lineno);
+			ret = KSFT_FAIL;
+			goto exit;
+		}
+	}
+
+exit:
+	close(fd);
+freemem:
+	free(tags);
+	free(procfs_entries);
+	return ret;
+}
+
 int main(int argc, char *argv[])
 {
 	int ret;
 
-	ksft_set_plan(2);
+	ksft_set_plan(4);
 
 	ret = test_filename_filter();
 	if (ret == KSFT_SKIP)
@@ -329,5 +519,17 @@ int main(int argc, char *argv[])
 	else
 		ksft_test_result(ret == KSFT_PASS, "test_function_filter\n");
 
+	ret = test_size_filter();
+	if (ret == KSFT_SKIP)
+		ksft_test_result_skip("Skipping test_size_filter\n");
+	else
+		ksft_test_result(ret == KSFT_PASS, "test_size_filter\n");
+
+	ret = test_lineno_filter();
+	if (ret == KSFT_SKIP)
+		ksft_test_result_skip("Skipping test_lineno_filter\n");
+	else
+		ksft_test_result(ret == KSFT_PASS, "test_lineno_filter\n");
+
 	ksft_finished();
 }
-- 
2.54.0.1099.g489fc7bff1-goog


