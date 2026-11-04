Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32C5C606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=n1gpPrVD
Received: by kanga.kvack.org (Postfix)
	id 0A3346B05C2; Wed,  4 Nov 2026 14:03:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1B406B05C3; Wed,  4 Nov 2026 14:03:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09B16B05C4; Wed,  4 Nov 2026 14:03:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFB9D6B05C2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:03:53 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E40514082D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:03:53 +0000 (UTC)
X-FDA: 85398361146.08.E759020
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by imf16.hostedemail.com (Postfix) with ESMTP id 78F8818000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:03:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=n1gpPrVD;
	spf=pass (imf16.hostedemail.com: domain of 3lYHrag0KCKQEFLMWLIOFETEXKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--abhishekbapat.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3lYHrag0KCKQEFLMWLIOFETEXKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7OmYkeQjJlaMAhfwUdrmcvladMFZs0EhQUj92Kic0fE=;
	b=ybv0c9v4cRJ/2zTkD0BreQ4orlV4ghHb+LHFiD0GtDQTYdRza5oG3scqN+khzfsXVr9rpU
	5dqp8J66qyIDH19uvGN6H7PzLqMTz/1VCTQbxr+ve/HR12b/uBucK9dW9bZgMunku0HEyj
	9kq40GTeFK8wYDA7YO86Q9iao9LvcnY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819031;
	b=4Q6Kwj5sRKash/ew2WIAzHBpG+uCt2aFIV1oYXoCMdNGa3nwoMWqRIhwlLQxMlefLV4gla
	lIg/HcuDYL0UUMotGZMts3AS4NjIhybZsZdtqJ8Yfgt2paeDDoXwsaOrNOwmTiDDEtUsqq
	tG/7zp4aAk9Xr4SR2XJOqvV/dlbVyLE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=n1gpPrVD;
	spf=pass (imf16.hostedemail.com: domain of 3lYHrag0KCKQEFLMWLIOFETEXKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--abhishekbapat.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3lYHrag0KCKQEFLMWLIOFETEXKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-3692c5b061bso2608677eec.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 11:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793819030; x=1794423830; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7OmYkeQjJlaMAhfwUdrmcvladMFZs0EhQUj92Kic0fE=;
        b=n1gpPrVDGmUy+0weM8dMpwp+/pFCaZJgK8+QffISmpk6w0EPMpZzWU/H89BYvhOY4l
         v6WftUf0AEcBivuRmgbv51Wcovk82g2oOsYuQNuE93MYu8zkHpIp0b+o2cabV7+iVVuu
         h2feCjRMINHnn2Q1UfwG/cCzR8rYtxPmTnkc/zWyuivq7xEjWBTZGfQVOa+d4yWOT3ME
         SZAe7a/DlepSVKtnmztFXwrPCT7Oh6ii+0o/KQSjREI33HlWlSz4RTfF5rrz4FPnEFMk
         U1QvrL1c5/WE88Euk0dg2XNaHdoATtWp6R2Rxtf/aKYOj6blRGF+bcAtffn7/LkN50st
         yjaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793819030; x=1794423830;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7OmYkeQjJlaMAhfwUdrmcvladMFZs0EhQUj92Kic0fE=;
        b=I+LHG4Hr3axVa0jEtblF2zdjPdPpwrQsteiHPHk6ZIvPf8OnBtmbhLGzf3CgNNgYmT
         SRfDXfnHxSCvD44/k89VcIZb2P6IqW6ZJ0w7fl073pQ9+TC5KMieot2SE+FQ3Gu3eLUD
         nE0QCya1QFz6VLQ67NsVxuscUBIKcWCxpurCSoB6nZpA4IExH3GiABlUv79y2BWuqmrA
         YJh8WH9gHFWXVEXq+/8lh+gcHksil1OFz363ZLopNbT71rhT4qnMSsKK0RBuKKnacFYs
         r0wLkv/4jaLzW3UKauWrg2lMxf8v/G9sq7d/80OLTm80Nm2NlA5sQLBROzaqXWiYXVo8
         mAJg==
X-Forwarded-Encrypted: i=1; AKwUvBxW+l9O+tV+LD63hP5WXH3Wqora01bljZHjsyO1fP1c8P6f7EBGnav3bV2oTEw0dBjnl2xYpBJuwQ==@kvack.org
X-Gm-Message-State: APuU4Z9IZp3mbcFk6owI8RMhEtM/CGL1Af5zWH08k9i0DCBuj9X/t6MP
	JadfLYV8vRRgOEt9JYZ9OV3cEUUMhiWw/0BfUiHbZgkoJKRq9lywoRaYAom0sFfbP/amNQWH9wu
	VY+BumNEoffa61t2Wwtvsku07JhsGRl1xSQ==
X-Received: from dykb32.prod.google.com ([2002:a05:7300:8420:b0:353:41aa:1e9d])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:f3c7:b0:36b:d3dd:2e9d with SMTP id 5a478bee46e88-36bd3dd3294mr7405560eec.19.1793819029200;
 Wed, 04 Nov 2026 11:03:49 -0800 (PST)
Date: Wed,  4 Nov 2026 19:03:40 +0000
In-Reply-To: <cover.1793818636.git.abhishekbapat@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <cover.1793818636.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <14ace814ca8c05196ebecb150cf710399a040b59.1793818636.git.abhishekbapat@google.com>
Subject: [PATCH v5 5/5] alloc_tag: Add a test for trace state toggle and filtering
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Stat-Signature: g6ff7cnswpj8n56511iu8ehzeuudkj5j
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 78F8818000B
X-Rspam-User: 
X-HE-Tag: 1793819031-28839
X-HE-Meta: U2FsdGVkX18sSxjJ0XKp0I8MntDFQkBYgtOB95gZjjFEcgIWLzKsmDdrk0cp4mdbQ3/ZR2Z3Koi6WNYLytvIwKM4Rp0mpSZ8Zj/qFmerU7ZD04+hCt/lb+7NYiorUKqLHdc2+hFp6yD7T8yIhY6Zy2VDVvsC7WVtUYiUxNJEN0hBPLC1uZA1ZvPP8Vl5+TMENOEWnhyF4nQ970l02AmcYJsXjsVyPlMvH3W+plBGGTa5N9iwK36casKoevQkAB+GI38WMl78qV1az6D078VL0JiZ6s8p2pbf1zcIgiY/wFVxM0hxHRT2OOGx/4ly1mfwC2BmGbVIA0Ngh0mpcD+O1V3QsNaRKFD78odNkaL6YOC0i4ttM9DTSBTmVw+v13B0dEGi07mkGhekF9IHXp8Ykh9AQS3vhbz+3Pby+lDVm2WmxAihisxmJcbwyArmN2spNtqXye7AJfhVMmCIy4bwaFjcYZNY3o3BBkKp/uYWxDW0EvyaOT9zXC4Y8UOr6v2cXEShpXQQH05x3StD0+gPUd8MEc8D6srZKcmAkKxTq+D91dSzEAr8LmH6sSADnvtQvpgvi3rRBP0ZDE2Px5TsroySG56HuA9eFYSukG4X7CRq+5y6Yjxv3/F+2HQd9wTVfd9IFEw9oF399Ffb8UeecyDOGcw3H+HwZqDgdy69/epeWbuBQy2OBTN3em8etN16DhNG4uDvJNNNEdJD2K4E7tnsXw+g1tpD2kHpsOt36M0Ju1mxItw6N/stEgZuAsgAZa5sNl4P6eXXWkmXmTUXOAsqwmM4LibogKO7oLl7kuxXWb+IhIkq6rvUTnvbECKbKBbnfHUFTj8BBghUBXWLtGUMsPkxxP8rmrMzVr8AZnUWvdzTHpXf9J7/WDjOSx1OckteYKR+1n/3wKMI0Si+EPKiKrJQsOiqOHJaH3ZcQIPkOjsvqAGdSIco+O2fS9cyiVAvvu0n518uuFvJRZu
 LwGyOGn4
 PIYXj9uEuVO8egvGWVNXLJwaN6Vwqz4LvJiAQxzb6KPqss+zS6z86HsvqKzHfLCrBu9+jQwDtOumiczL9weLBTNXOAoWX8JggaoXQIljUIcV8jKnQXjqNm6pSptwGNHWxFEJnGa8rE4FxRk9pBHzYUXpQhNCO35ZewMB3ZuRkuOWOc7ioSvDjFJ8cBabaB7xwuaWbUZeJiWzGRirH+/7PxCXNU3VrwFlnMbJzHkyuOnQ/O++egiUCRkE3wnFYBrlTjnx7kpyjCi7k7E8cXSYjMAa6UO2uXzLsk4/jTtOjz+bEm6aJ2t00Ws5bSf3Uf8IGBU4PJiK1hi2nF+uynMbrSIiZjL26OLf+pTdNtXLtOoCYU3oAX/Fu9svCpoSlJqBYFVrxjcV9fxwhvrjkRH1jGLpIJrWo+Etn4CSTNl7e1ltASUwSCgTtDXpihKyCC3/6mmAnSG6ZWutSZ3ZnhWzgdWvYOYD2YUan6hr3idIJbdbZdiQl+iJpe80954+NMgJW7FpfTSYKSxPjhMK+NsGLcYIJ4SFAVBGyIBXPY9Ue5eEegmds/36Hjp+uEK0f30khfUp1161P616VB+zk52/cbfvhMYJueE2GnW4ddsWzflIuYmknh1JX5DN82XyH4aOuJyEqCvGvjSqioHYc8ha5LJ4MRIwPuroPA/WP8MvuHSe851U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Following the introduction of the ALLOCINFO_IOC_TOGGLE_TRACE IOCTL and
ALLOCINFO_FILTER_MASK_TRACE_ON filters for selective memory allocation
tracing, update the kselftests to validate this behaviour.

Introduce `test_tracing_toggle_and_filter`, which validates the
architecture by:
1. Dynamically flipping trace execution state for a designated allocation.
2. Query the same tag again, and check that the returned tag reports the
   new state in its `trace_on` field.
3. Restore the tag's original trace state, also on failure, so the test
   does not leave tracing changed on the system.

The test uses `dup_mm()` function name with the function filter in the
IOCTL to run the above steps. If the `dup_mm()` tag is not found, the
test is skipped.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
---
 .../alloc_tag/allocinfo_ioctl_test.c          | 114 +++++++++++++++++-
 1 file changed, 111 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
index 74fd64b2370c..300460084d9f 100644
--- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
+++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
@@ -48,6 +48,11 @@ static inline int __allocinfo_get_next(int dev_fd, struct allocinfo_tag_data *pa
 	return ioctl(dev_fd, ALLOCINFO_IOC_GET_NEXT, params);
 }
 
+static inline int __allocinfo_toggle_trace(int dev_fd, struct allocinfo_toggle_traces *params)
+{
+	return ioctl(dev_fd, ALLOCINFO_IOC_TOGGLE_TRACE, params);
+}
+
 static bool match_entry(const struct allocinfo_tag_data *procfs_entry,
 			const struct allocinfo_tag_data *tag_data,
 			bool match_bytes, bool match_calls, bool match_lineno,
@@ -289,6 +294,8 @@ static int run_filter_test(const struct allocinfo_filter *filter)
 	return ret;
 }
 
+static const char *target_test_function = "dup_mm";
+
 static int test_filename_filter(void)
 {
 	struct allocinfo_filter filter;
@@ -304,11 +311,10 @@ static int test_filename_filter(void)
 static int test_function_filter(void)
 {
 	struct allocinfo_filter filter;
-	const char *target_function = "dup_mm";
 
 	memset(&filter, 0, sizeof(filter));
 	filter.mask |= ALLOCINFO_FILTER_MASK_FUNCTION;
-	strncpy(filter.fields.function, target_function, ALLOCINFO_STR_SIZE);
+	strncpy(filter.fields.function, target_test_function, ALLOCINFO_STR_SIZE);
 
 	return run_filter_test(&filter);
 }
@@ -514,11 +520,107 @@ static int test_lineno_filter(void)
 	return ret;
 }
 
+static enum ioctl_ret toggle_trace(struct allocinfo_tag *target_tag,
+				   bool enable)
+{
+	int fd;
+	struct allocinfo_toggle_traces toggle_params;
+
+	fd = open(ALLOCINFO_PROC, O_RDONLY);
+	if (fd < 0) {
+		ksft_print_msg("Failed to open " ALLOCINFO_PROC ": %s\n", strerror(errno));
+		return IOCTL_FAILURE;
+	}
+
+	memset(&toggle_params, 0, sizeof(toggle_params));
+	toggle_params.filter.mask = ALLOCINFO_FILTER_MASK_MODNAME | ALLOCINFO_FILTER_MASK_FUNCTION |
+				    ALLOCINFO_FILTER_MASK_FILENAME | ALLOCINFO_FILTER_MASK_LINENO;
+	toggle_params.filter.fields = *target_tag;
+	toggle_params.enable = enable;
+
+	if (__allocinfo_toggle_trace(fd, &toggle_params)) {
+		close(fd);
+		return IOCTL_FAILURE;
+	}
+
+	close(fd);
+	return IOCTL_SUCCESS;
+}
+
+static int test_tracing_toggle_and_filter(void)
+{
+	struct allocinfo_filter filter = { 0 };
+	enum ioctl_ret ioctl_status;
+	int ret = KSFT_PASS;
+	bool initial_state, target_state;
+	struct allocinfo_tag target_tag;
+	struct allocinfo_tag_data_vec *tags = calloc(1, sizeof(*tags));
+
+	if (!tags) {
+		ksft_print_msg("Memory allocation failed.\n");
+		return KSFT_FAIL;
+	}
+
+	filter.mask |= ALLOCINFO_FILTER_MASK_FUNCTION;
+	strncpy(filter.fields.function, target_test_function, ALLOCINFO_STR_SIZE);
+
+	ioctl_status = get_filtered_ioctl_entries(tags, &filter, 0);
+	if (ioctl_status != IOCTL_SUCCESS || tags->count == 0) {
+		ksft_print_msg("Could not retrieve IOCTL entries for %s\n", target_test_function);
+		ret = KSFT_SKIP;
+		goto exit;
+	}
+
+	target_tag = tags->tag[0].tag;
+	initial_state = tags->tag[0].counter.trace_on;
+	target_state = !initial_state;
+
+	ioctl_status = toggle_trace(&target_tag, target_state);
+	if (ioctl_status != IOCTL_SUCCESS) {
+		ksft_print_msg("Failed to toggle tracing\n");
+		ret = KSFT_FAIL;
+		goto exit;
+	}
+
+	filter.mask |= ALLOCINFO_FILTER_MASK_TRACE_ON;
+	if (target_state)
+		filter.flags |= ALLOCINFO_FILTER_FLAG_TRACE_ON;
+
+	ioctl_status = get_filtered_ioctl_entries(tags, &filter, 0);
+	if (ioctl_status != IOCTL_SUCCESS) {
+		ksft_print_msg("Error retrieving IOCTL entries with trace filter.\n");
+		ret = KSFT_FAIL;
+		goto exit_revert;
+	}
+
+	if (tags->count != 1) {
+		ksft_print_msg("Expected exactly 1 entry, but got %llu\n", tags->count);
+		ret = KSFT_FAIL;
+		goto exit_revert;
+	}
+
+	if (tags->tag[0].counter.trace_on != target_state) {
+		ksft_print_msg("Entry returned by trace filter does not match target state\n");
+		ret = KSFT_FAIL;
+	}
+
+exit_revert:
+	ioctl_status = toggle_trace(&target_tag, initial_state);
+	if (ioctl_status != IOCTL_SUCCESS) {
+		ksft_print_msg("Failed to revert tracing to initial state\n");
+		ret = KSFT_FAIL;
+	}
+
+exit:
+	free(tags);
+	return ret;
+}
+
 int main(int argc, char *argv[])
 {
 	int ret;
 
-	ksft_set_plan(4);
+	ksft_set_plan(5);
 
 	ret = test_filename_filter();
 	if (ret == KSFT_SKIP)
@@ -526,6 +628,12 @@ int main(int argc, char *argv[])
 	else
 		ksft_test_result(ret == KSFT_PASS, "test_filename_filter\n");
 
+	ret = test_tracing_toggle_and_filter();
+	if (ret == KSFT_SKIP)
+		ksft_test_result_skip("Skipping test_tracing_toggle_and_filter\n");
+	else
+		ksft_test_result(ret == KSFT_PASS, "test_tracing_toggle_and_filter\n");
+
 	ret = test_function_filter();
 	if (ret == KSFT_SKIP)
 		ksft_test_result_skip("Skipping test_function_filter\n");
-- 
2.56.0.506.g506a7eabc5-goog


