Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBC3E606A320
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 20:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=j+CudbQs
Received: by kanga.kvack.org (Postfix)
	id 7A32E6B0364; Mon, 19 Oct 2026 16:00:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 754686B0366; Mon, 19 Oct 2026 16:00:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 669156B0367; Mon, 19 Oct 2026 16:00:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 221306B0364
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:00:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E42C1A0887
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:00:37 +0000 (UTC)
X-FDA: 85340443314.28.C0823E7
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by imf06.hostedemail.com (Postfix) with ESMTP id B4C2A180003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:00:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j+CudbQs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 34XbWag0KCIYklrs2roulkzk3qyyqvo.mywvsx47-wwu5kmu.y1q@flex--abhishekbapat.bounces.google.com designates 74.125.82.69 as permitted sender) smtp.mailfrom=34XbWag0KCIYklrs2roulkzk3qyyqvo.mywvsx47-wwu5kmu.y1q@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792440035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SBnUl1ocqF3UAQpeER9AJDXEwbZWvYBxgk+LZjJZJiE=;
	b=yloXa0yB/kI0t3UhUmSLxThd+r9NvsDaEnDImVZmQJlQqbcRVqvQWldQF4p3t4gEBRQYP4
	EaqKIJl6pQBKMhZfcRyXEL1NbeLDSmAmLiceP32buUlPNr1QRtEWA80ojbCiEZ3O2pswBN
	UuZKhFPc7IZe9m1H5YVsnxVvM+nyucQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j+CudbQs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 34XbWag0KCIYklrs2roulkzk3qyyqvo.mywvsx47-wwu5kmu.y1q@flex--abhishekbapat.bounces.google.com designates 74.125.82.69 as permitted sender) smtp.mailfrom=34XbWag0KCIYklrs2roulkzk3qyyqvo.mywvsx47-wwu5kmu.y1q@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792440035;
	b=KfSLj22suYC601XMLoJrx2542LjEQYTTfyKqMs3f9JSZrai9ot31HGNt9WkDs+GrQ/9Xmk
	KJNk3Jc1LMHZ3MR5vb6i2QzF4YeogrotCTTadaheAnoeJ5wU27m/TrI0HvruYnOS/xUiYV
	X9g91HP8j0LpKpVjNXi3Lhxy2gSaHbQ=
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-154e9d2d94fso3875141c88.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792440034; x=1793044834; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SBnUl1ocqF3UAQpeER9AJDXEwbZWvYBxgk+LZjJZJiE=;
        b=j+CudbQsEKZ3uQ401ZuUZHCfh+NVo+XxdaKWUjfwavn3qlGSzvlfJFc3cavrTm6k2+
         6/sFWVLb2RXc+Fgez3DUg7LQKFma0g8JmDg+OIMXB8Iy6egw/PMi0cmwttdm4tqfClHt
         2eJT1ihUjxFiwzzu9VtmZX7H0yrFk/SbJDNKZluSd5mTjekX/Ka2ECm6ZBmKMl+08IFe
         xLTjkTKGtw3Our9QhWbfrEef6pinIvbpiyNgj2FKDPdjptCo/dIO5WQm8LDjKNEkGuPl
         ddZzYu49Isl/YlcpGEHlqbgwvB40337wD4qoM4/ylquCHVKsBr8TH0jDuk2NgScN093B
         Iwpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792440034; x=1793044834;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SBnUl1ocqF3UAQpeER9AJDXEwbZWvYBxgk+LZjJZJiE=;
        b=adSJf/J56R39Pbc3bX1/NyUE4ii4ju/N+M7EqR4YBelOj3DWwm8xyJz/BL5RHGzoOS
         Q2i/qMpqkyIRR3BG5QZ7Et/N2+FezqBKxrgc/bGyrS9alVSlHxJyFBXIVwqAbjyFuBO/
         PJmSRQ+eJlBJcsd3FFwQxJ64x75xXCqG4oJaIZ8CEpf1HQS1VGZ+XUxGaiaLUgzkui5x
         yKwVcm6CGV27tUep3xToV0AmlyE4pH5uk1ehEzw63qumfOMOaPAL4GbKgIEwaNTWsjGN
         SxRJbXkiRDAUCvAlwwyk92W5XS5u9j4HLj3BX7eJgjjyZdpai1SvorZQFCPaQrKwlSxZ
         6QIA==
X-Forwarded-Encrypted: i=1; AKwUvBzd6gwln8EdyJmJ+fe2nuaJIj+L51V1LDlchE/tYgJ1y2oxY2Gu0MY1UiXPr6ylVCJ0KPnn/jgkwQ==@kvack.org
X-Gm-Message-State: AFq9FYKGUyr3p246XxSmR+5pqAIOySs6grTSvS29U5iVd6CexgYELDhD
	xJNQ25EBiZhbygrdqgYyJooyX3YVPjs1O8Q141M0v1vDrp2OnDdS1BxQNyHal96lfaPBefGtRzw
	9lyJ9SvGcKVVkR19GaHk15yiEG/64Us5xkg==
X-Received: from dlbuy10.prod.google.com ([2002:a05:7022:1e0a:b0:183:f9d:1eaa])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:7e8c:b0:149:1feb:6d9d with SMTP id a92af1059eb24-18512f1ca43mr13500938c88.19.1792440033889;
 Mon, 19 Oct 2026 13:00:33 -0700 (PDT)
Date: Mon, 19 Oct 2026 20:00:27 +0000
In-Reply-To: <cover.1792439751.git.abhishekbapat@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <cover.1792439751.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <902ec60f33dc7bd4136100322565615dd9d2e61f.1792439751.git.abhishekbapat@google.com>
Subject: [PATCH v3 4/4] alloc_tag: Add a test for trace state toggle and filtering
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B4C2A180003
X-Stat-Signature: qqmdxgbc3abaokaui6xggenajsawk8is
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792440035-639929
X-HE-Meta: U2FsdGVkX1/TKVlKPMBJjYqDwpcXyRIiJOUNtawEBz2Pt1K+OdDKPfi6XC6OadP6qLMGBfOx9L6GN1ZuxFFQCIR0af5PkBTYhfMtrgHBvYHGFi2FIjtsi6bD0LA4Lc15EF9Zkud+LgQhmyuBeBo3wi9Nz62kO4VG8YbczizkY20WW8QMD/N7npiwF9WxyZ94lVzvtiz/aKDjrVP1fTAeXkORxSFYnBuS+0NL7F18AUjrwiUCij+s/e/dAeAUMVOM3Vgy+rijZSCxlVwH5AS7/TiHMOjRyWDsMDalPON5IqL6gApl/PP7Mkjp10yg4W6dR3klmesNMY4kqnr+0zLA6dMQbjTcbOfLhkCnkB2IDmKj+GvmRrsOgnXsKH2H2VgUhewrKgusQ3DpOqImEkhjdKIjWTJXYVa1EIuK6iOUFEudDy2KzEs61LeW/JD3NXsSpoiZmwsIFBRGFeNN0bYB0zC8rBRP+pyiGwuU8vOHxPlhq1/mIilUyNt78mRhD4J2JC6BJSWkxCqg7YVNR4G4jplYb7KcSR2ID/LA/NfCJL3AHFCFqhIAsLkn9AC7bTq7TWHzLT5zXinfeePMoAK1taEDFNz2zOjYvTonaXIT0o+dxSdlFsdtGx/FfU1N/rzeS1R6YXN6vIEX1Gp3TqSTupY4m4/PA6s8C2jrVyPez/rEek52R/Nr0E9PULjIfbmM6iR1WCx4XBEB9WuY677sDePBeXql52shVKd6e04IZv0yBZ9rHFsVgGoNe+CC7l357XyV+gqyTRio8PJRD3Uo72dHdWfI7WmdpiRfmLCQKknkdb01Ma3WI7O6pp+u9eJtgFVp2abnt9YvaLJc95+IYG9e1wGZiWK+pI1VL7Py9dcqFuhzMLIEWp1inYlWmcBi2/2GaGIiKLeGn6kLC+ydJ94zMtSB9SrM7nXVa57x9ZGru1kbhWgbGuw0z3BVcbPA0BqCyYhUxfdWSvTcAxt
 QQQEzkAv
 r3merMyJN0nzaSj9YRBUesT5unGA1lXe7a/fWpPMI0laKbDL2BJhEq637v15X2RPX2yxe8p8ynF3X1HWlRJENd4KAB+qW6CdAr2q6dXs5f4hsnfUCGuqt9GZYoY/FI9Fg9SbCm45g6x19I+47z9sgyXy4Mijjd/s/l3KFZkm1u2Rx5Eu90NcmSwsZ6477A2odKCmaDqyo8XEF4qyDG06uro//zR2KwNnaY61rVcobRsf6woK/zc3GnrY2UPw4QBnluiBde65OGUaj3mkqmGacEKNtV6/Jdhjg70YhdueQ6RagxBYaD85bGLDbJNyco9kRnA88S7nS1PuRSCFDlslD/jH1pTy1lUw4IFjbBvTLw8y5NAr01+AIVbtwkrFhLqzb404NUMztjx7pfppiJ24RvTQHLRGGcGtRaJmDMnLXUcdAJ1xPwB1CZOqm8cfUCDXiOnSrGvs1JJ/nQ0xIFGGF0EJSIQlrzm3rMl9gUB0IqEMzV8VZUnyiqKe8geWokcwsdHQpUU09CQXMiQcfur0J0kEyacXg7ziqP9vfVRg6Z8aOhqhhkhTk+oF6kdk4/F4UP3zuW1sWxAhGK2VrL0ug+Pfeo9DHUECXKrx6Y95u9b6JLD4tkgo1G7l7cC28/vjlZjSuD5VHz9lYuOND7NI+xxBpDOP++rAJXMoYfugKQr5VnBg=
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
 .../alloc_tag/allocinfo_ioctl_test.c          | 113 +++++++++++++++++-
 1 file changed, 110 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
index 74fd64b2370c..eb52ca1a1dc4 100644
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
@@ -514,11 +520,106 @@ static int test_lineno_filter(void)
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
+	filter.tracing = target_state;
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
@@ -526,6 +627,12 @@ int main(int argc, char *argv[])
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
2.56.0.218.g1ec904b173-goog


