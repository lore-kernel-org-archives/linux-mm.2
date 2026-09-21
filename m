Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A26CDC982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 21:27:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C77C86B00AA; Mon, 21 Sep 2026 17:27:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C024D6B00AB; Mon, 21 Sep 2026 17:27:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7AFA6B00AC; Mon, 21 Sep 2026 17:27:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F00E6B00AA
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:27:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA7BA1C2047
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:27:01 +0000 (UTC)
X-FDA: 85239054642.12.8C0BBEA
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3235E40007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:27:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hN02AVPL;
	spf=pass (imf12.hostedemail.com: domain of 3IqGxag0KCIclmst3spvml0l4rzzrwp.nzxwty58-xxv6lnv.z2r@flex--abhishekbapat.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3IqGxag0KCIclmst3spvml0l4rzzrwp.nzxwty58-xxv6lnv.z2r@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790026020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4svBVXpzXDnEEaPp2iHW0GefZCmj3wqJ5HrNnYa0oV0=;
	b=FzOUgiQq1FUevuFlDDtIutdFPLZz2xqRBR1dv9SoZkuR1HcboN9P3ENfX4HV7OBmYloBSS
	PTsInUxqTHjy7UqtkcahRS5u7l0a4R68APuXr7Egr42ZpEXZtj7v+9k7x0rDvQ3iegGuPz
	CU94Ub81uH8tMrVst3/uWCFzrD3iWr8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790026020;
	b=Y43lxiUxaW6wmgKJzwUwYJ3DXm+/HLQpQ4A/8R59TdpcgFH78PmPIuVNTaS4RND4OMuwDg
	xkQHX999SGQfR2m7EPXMAyHPGIqkK8JGXDHz3vv4eXAoQoPz9c85eZgCz2rAjUfYvNPufU
	b4TI77MLg44MII/k7Vhjaydqey5NbyE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hN02AVPL;
	spf=pass (imf12.hostedemail.com: domain of 3IqGxag0KCIclmst3spvml0l4rzzrwp.nzxwty58-xxv6lnv.z2r@flex--abhishekbapat.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3IqGxag0KCIclmst3spvml0l4rzzrwp.nzxwty58-xxv6lnv.z2r@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc1b8088203so2983248a12.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790026019; x=1790630819; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4svBVXpzXDnEEaPp2iHW0GefZCmj3wqJ5HrNnYa0oV0=;
        b=hN02AVPLEqf8VTtLHH1gYj/+Vx+1LGOL8Y476f2BPAiLEIim25ETcVZCKXlYIOyhcN
         a/mIoj4sslcMwr04x6/MAzGd4guZTxSBgcWJeRo+c/LayPvkKAoVnHDUONgE1m+251CC
         XWjjP1exTjTmSBTqmGab9PyWTMlO2haNU2kp23/rOVHzMQz9z/6mzwOLMhlQ8VF9jQS8
         cXVHD/Tp5oREAVOnO5EbBbBBRr5bzT+0Ypl/KwXbfEwQNVwH+zZgcYawZhmTtDyQadZT
         jhen8ntFW8Oo6akCfHnyfylNH6Xp4XpGZGRv8A1wa1CeBBr93PDsSDy2+oEGBCiuTWxH
         4l9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790026019; x=1790630819;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4svBVXpzXDnEEaPp2iHW0GefZCmj3wqJ5HrNnYa0oV0=;
        b=SSwtT4f6QLKRwVrpUN5o9zSTihgU6VEbJv4A3BqVTUxgyW0L1DdbTZ1RvwLbjZTpjX
         dmbc1udm4HiILI8IlisZOLv2syWdq2p/uq/EjtQFm3w3Gb8Wt2a7R9AdwJarbIwSsjXZ
         4eIRpdN6hYY8l5B8J7MhGq0pXWfSpjOhKY+ZiXNkZcCL/qjjJAqC8NP+LJ8Y0vpQdkLI
         3YP8RsjwklyGtGuGBU9PqrsfG/8wLX02EJ8DvArFAFM0Wovr8QlCRHNFRdiw91IRh2V+
         ABT5HgAmBAzJX7BdaBr7qk3yeMTgZqmoYh9V6L4jajNwVYWMGErn4VIW1tw6wlNzczAc
         0NOg==
X-Forwarded-Encrypted: i=1; AKwUvBzMIFBYOlEnDplPSxzUQTQ1TNG1hpjbrrNOr14Q+pjBC3aDLQWHlnRwWkOLQG4TiMETtIXBa0TAbg==@kvack.org
X-Gm-Message-State: AFuF++mvjNA8YxXoJcEVdp8AujOeIzrySuZaCLugVL/hRwb27rqg/YzX
	Sb8PAiPiAjVTpTZWVtHu1i6M8gesSKchIU0RU0PafnCo3e9DSmd1fNO4SfiamXZbRKiEjuMcP0c
	6DuyJGMIpLoacl9F6MPseaU4+GGoP5n0mQQ==
X-Received: from dyng28.prod.google.com ([2002:a05:7300:7f1c:b0:339:c3e:449b])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:1393:b0:3dd:a195:dd61 with SMTP id adf61e73a8af0-3dda195e47amr11865501637.67.1790026018871;
 Mon, 21 Sep 2026 14:26:58 -0700 (PDT)
Date: Mon, 21 Sep 2026 21:26:41 +0000
In-Reply-To: <cover.1790025465.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1790025465.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <988dddb203416668a10bc9c5e6157a78615d2ed2.1790025465.git.abhishekbapat@google.com>
Subject: [PATCH 4/4] alloc_tag: add a test for trace state toggle and filtering
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	Shuah Khan <shuah@kernel.org>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: dfuykz5c5f9ieuytszzn5rur6e4bs6oq
X-Rspamd-Queue-Id: 3235E40007
X-HE-Tag: 1790026020-573173
X-HE-Meta: U2FsdGVkX1+9TZxCNAWEqACyrQOc95eQkGgcmSJS78vxOLQiAZ4wQ0bkp7s7tCgdcyEgjJaou5kGG20AwQY4vGh9vwqBTaxR01MM23LZoqTUiIR8j48soNFjHkk/2f1n/0QPbKbWbvM4YYsvOIhG371fXAFJBGLKEUfFTqC5XJeJILK8DnMKBU+xZiW1K1dUvluyh8m1WeOBW8iTfpFm92Mgy1lnImLvzMXVnRyktsE2YbgVxbKd5SuibNcTqreQZcEECxSwpDuSVjpkBQp/3+eW4f0BcIFmuLnzfcvLOilqT657rcTGnG4E3LePJ8zISC+B0fHEj3QHQYITaxUJc/JL5yeSmCekk1shMaC1ttELrq/Otk/vnaFiwE5QSq0oWyu++lxo27dJf7NquwqlTwh7wMcEf18V5N6tW8Szx8V/Mb6qgreYuve8jilIqmjGxR9XSH1DbDRyijqwHtg62ZG6Z3SaU0l4LTKUWQrxgc+xXGA5xb5chkjbZ35HIQ8IZdP9yjvjdk7y3Di0cr6ZfLOakgmLEzwtUolF1raXsDO1jUd7xto5w4mglsr37gVMS1XDO36KyBsuraRP764EnIXcC99ezl/uHa5JG79Q+DtDRvgj+Rr47Qfnpf8hLUF7BCLCQryswJGGgMHRmJ7XHKdBngHQxhm3pD2xFKhMiVk03djNSviHwyjnGPDsXgsS+cS9Wv8G5t8zCnHGC64zyq+BFYktNLwZj4bD5NRZSwRSVq65M0ATtxV3P4IlUC+TNBYAgz2BLFm6ooraWbo5Ar9+e6OVAGfVuqVfVuKrq3KLWXYgg9VIS78zV4SD4e0sVIw3yknafUY2HZ+hhXeVMcypy/cXjkb2uTPHfLNM9KLZvB91r4mHq1/bMIBBf8noGvrYngMePYPiQsHzfbqSVhwWbkr44ZWTTTtK9qiRY240R9nPDuJOla0QoGmcsCQfFjiOfxxUUFwF5hkaiLT
 iIuzbwmh
 JACiOJrSr8q0fXavJ+soJmblnLX1Q9K2VgTHeYvGIq9Vr68Ga/l3NdL/H6avagy0J0iTEtyEe4w7D72rjEssbwB7ZnQ3jx1xqnNivijYVLybq34SOuJfRGyYPpcxJJlazhQ4sS8MZZ7L2lh2hlcLWb/t4wO5LiCvhbRaNZXNQbYNX1Zay+p8P3NpeeV6s5PNsMKRd9mZPo6Tsv2yrm6LDeA2R4vKT3u3OFAn0vQ4+OJKWB9bbeRkfHc5bjpV2nphne1p26pD+7bEFQHqQ3XB/WcEaXTOZMd+KjchLeNrfDFODvSgqf3Ja78U0G5dT4MK9fwo+RRwibZ6y8xUJSpXrqm7/OfjUHBldXVFKW6HKt1weCRYPM0VJjImoQp2YZkoCoyqRVhJ48iDLy+ti22wi33LFekPkE0LjeN2UlYuIdFlxgTgRwTHlu56YVBbjAuZS+fTMpuchrVm4ayTXnYFXn892N8mFGKVqjRzgu5NkrU2Y7BWu9tHcqclJPAFEb3hi/MIf2XpyYGh6uRw5qUhJRcCBhyTmwA5QB25pppUIlE/5TLvIec+T9Glrkkqq2+nf0ksTvdDqo8DsEPEuqOOS3V9Eqc7PyTnwiX/6NFyNowOVC9DLp1DrTYoB04mKkQFaVevlPK92S/3Kex2cRK6ef6zdwjaQ0lpUgE2RWsz0//9zi2jquv1eDCBJ7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Following the introduction of the ALLOCINFO_IOC_TOGGLE_TRACE IOCTL and
ALLOCINFO_FILTER_MASK_TRACE_ON filters for selective memory allocation
tracing, update the kselftests to validate this behaviour.

Introduce `test_tracing_toggle_and_filter`, which validates the
architecture by:
1. Dynamically toggling trace execution ON for a designated allocation.
2. Evaluating that the TRACE_ON filter precisely isolates the active
   target across the IOCTL API.
3. Verifying that the targeted allocation correctly reports its
   `trace_on` metadata state as 1.
4. Toggling trace execution OFF for the same allocation.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 .../alloc_tag/allocinfo_ioctl_test.c          | 111 +++++++++++++++++-
 1 file changed, 108 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
index 74fd64b2370c..3ef7a12fe35b 100644
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
@@ -514,11 +520,104 @@ static int test_lineno_filter(void)
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
+	toggle_params.fields = *target_tag;
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
@@ -526,6 +625,12 @@ int main(int argc, char *argv[])
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
2.55.0.1082.g2b9226bbc0-goog


