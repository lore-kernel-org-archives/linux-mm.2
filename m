Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B20FCA6002
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 22:40:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 146016B0096; Wed,  7 Oct 2026 18:40:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05AE56B0098; Wed,  7 Oct 2026 18:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED9CB6B0099; Wed,  7 Oct 2026 18:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC9826B0096
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 18:40:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 292701203BF
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 22:40:18 +0000 (UTC)
X-FDA: 85297300116.17.14D2B4C
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5E76940003
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 22:40:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g6qDpbw9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3S8rGag0KCFg0178I74A10F0J6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--abhishekbapat.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3S8rGag0KCFg0178I74A10F0J6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791412816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jel1GtKvrryvSIBAQ3atkvcxRH+gBV+jXFIXOBoXOeg=;
	b=NmNAMzICut7iNY9x1bofAcyXjUZT7xv/ZHZupLeP+BqOale4gZI0g/OZA3m9Erl1+0oM2X
	XLVrw/ejs/my7jIKWxBO4O66SCiQljsA3r6KcXv4xJUTu/C05TV5LMmSS+1ot+ZDqBvPgn
	kMzy19cEXeybjI9OO7QM60TnVeK8X2M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g6qDpbw9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3S8rGag0KCFg0178I74A10F0J6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--abhishekbapat.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3S8rGag0KCFg0178I74A10F0J6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791412816;
	b=0ogmNyqECtFjwu8NbyZykpuVAqzfrBCsP+me5qjzAPUYf87VEDcHpFsvw86nNM8ussPfs1
	c2LBg3ZYjpJwc/TEoA8Ety1DYRs0GFubeYa0Q7C82TRLGZez2KKwspdcU5/Xfi0uKWLpeA
	moVkwTD902jnBULMppZeB887Uq+wYiE=
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-351788121cfso578141eec.0
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 15:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791412815; x=1792017615; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jel1GtKvrryvSIBAQ3atkvcxRH+gBV+jXFIXOBoXOeg=;
        b=g6qDpbw9pyWbKmI1gii5cHQJlSGARmfUYqXqHcwkujuFFqPIJpr+I2YjMjlHWzuu9v
         HRuHQkcEBeKJgXF2oUssMnp9Ng3r5sf701nSitM4ByzmYLtcvHrCJtHAjPdGg1dNJ1mk
         x/xPPt73qXkdA1jU9QwT5ASzy/ylPHkJanhfZ6IulrHKbnpfWn0nixlLCP0EwGCN4WAo
         5pMkT8xiuNx/XM5uJUnPUelRACO2GsaB19UgNQ2y8aIXNJi9wL8hf+fmlqVH/dh/OCz5
         8b96+u0PZtEPWQQEMvvlVvMjCzZBxN5muEtJGnoCKOZucf/beYyphfLLMwzQrz1CoYf9
         uijg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791412815; x=1792017615;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jel1GtKvrryvSIBAQ3atkvcxRH+gBV+jXFIXOBoXOeg=;
        b=SInkj4LuZk0gc9poV3fpzsjuJ3YLNt/Y/flQ4C8SfCLOOq0BQyDyMMmGW3MdSlW9gc
         K4u0eZ7X9P758XWKc6yIRhKiKgW4PLbxpVx3lpPnT2xhc1ybA6fMH4Pkcpd3HRu53fIY
         q2w6iAao4jbMNEx90cd7u2qFWt05LVCb72p+n9BOWgUUdN11WUJUtXIYI4fa5CROudjE
         jqMJ6F0Jaii5PYPowd/ezQoPkTUjGvz1ruFalQrRXnj96sIMtJ7W6DhOmkG6zwl9fNf0
         N6gEIF/GYfjXQcBBfA1uhZ6ad4GOUo2fPTtab48CVcGur/dIPYzGW2rgm3uq8DJjnAmG
         4Tjg==
X-Forwarded-Encrypted: i=1; AKwUvByVlHDIkZQ6Kk0/u3OwAiq4sZ1F9ycviZgtLLrO7X5ud1lRSDG3lg/i5HT8Ka8UaY7gczl/DBk1Fg==@kvack.org
X-Gm-Message-State: AFuF++k+FUDzK6CU2u4itKtcy7e8YSQENWHUtzvMH5H4nHtfT/6pSkU3
	yz/HnwV660oyzQcfMKAk6y6SJR/4BeB6oBXJc4Yys+GnEx1hTBXNYxDqbQaZJtjUY+ByctANJD/
	EATOziifkNAyhC0dbnk+jWPZhZAvu5zbrag==
X-Received: from dygf10.prod.google.com ([2002:a05:7300:134a:b0:351:21f1:20ca])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:1e84:b0:34b:c18d:c28e with SMTP id 5a478bee46e88-3515dd837bemr5875331eec.7.1791412811980;
 Wed, 07 Oct 2026 15:40:11 -0700 (PDT)
Date: Wed,  7 Oct 2026 22:40:02 +0000
In-Reply-To: <cover.1791410885.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1791410885.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <ed2e9cb670af7d013aaf6585aea551587647f070.1791410886.git.abhishekbapat@google.com>
Subject: [PATCH v2 4/4] alloc_tag: Add a test for trace state toggle and filtering
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: giybubjnzqzzspjwstpoa6zzhzhw54fj
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E76940003
X-Rspamd-Server: rspam08
X-HE-Tag: 1791412816-906461
X-HE-Meta: U2FsdGVkX1+2VCbngBoFWwO1wFVosc488rYxzXWZyxSZy7Wfrg1uG+pV3tJeC/VbVbhlx6RpZitHta/6fHZbKpBLbrCRCmRWQDE/k9tkY4W+XGSOJO5qvVTtEhoWegqSm0AdqXKc7+jDI5CCo9ekrHaVVMKyXKau5M8SJ87RCKzP/lncssHq7Bplc/BH0quw+idNQMgTih3lW39tzpwEQAAaK6B2RKzXZJiXAWAFkpHGZj9ASnrTTACSAZKG4BDlGc4GDMiqUzzs62AOxDxlNKdtKIjHOmiuQiUfTbyGHbx/6/t0bZKLkp/X2gGP9y08+x2Zbl2n+o5bgvdHnRFY17CVqR0w3+bkgZDDgwd6xuu8ytx+uEbwctALaCGfRoAZnbcAnqoFU4gNAXK9NovlA7pqlV7YU07qizlob9UJCHQTDYayR3q/vmk29pHDKEs/gNACW8a67Ba1RPQedPAVImpG5X1oPo3mJK7XuvGH0+ab3XbEoBHSmGPj0Z/A1ityNoveiqa01gHAQT2da4bj3F512B1wa3yu15pPDeU6lI9Wf0nsv33oyzKDef5atccWyTviow86498xTIDKgsiaTdEAWPeyxDrVFSEugmUkJh/tpj2GdrAoVzKHeHEpt8/03+QplK3Jofr6qjDORVr0PjI6KXbVaqIeHzdQqqxsjsRPSNWagqMvxmK5NbDYQVM4qBIiKkqHwW8fH5kJDwzPug5rbEFuV5ffiU8QC6V6lx5NgLC84Flg5/lODCj8b2o1kllq/BqdSuh9HBJZvJ7EDtu4Pvm/BaM7/HXhP8vrN6cXQMWy4foF/HBI5ME4txHe1OJ4KbyS17y6oO076p/tR1WiOAFDPn6Ur2VCqnp/sy57ugF+boBXipBgilXvIV/ZuzFieYrYDMZ8rcnIgQbHaPRAHoURf41XaTSED7jbf/N4Es1mx/cOrywBS5sgufEoJ0XrxcmcWxV0EFV7dw5
 Ak3ILwSF
 Ri29/kHV/dunNEgoCNqWeslJhOJKvzuUopucNTTv8vrAXaPvNcVFS68+DyZTKuxal5EEtj0hXiJVf0Go3bT+/lTHV6GndWg0XA1mLWnSOm6poF2ML2rECQ2KQd6bN96ePrSqOV6A3tYFvKdpFr5caHvkBqHPA+LZjlvnI0qaJokgXMFDCiGgbPxx/+BhpdcUNn0otd0rvPE9D78bd0bGaVdF7ODsnbQylsNvQrVHkVhV15Bn0vv0zVLykK42ufFluXzjUrDn9C+ob2X+OMiSsAZeXjbUCnlwmfGrpCQFzY1foJCJxhDNUdbefq46wk5ZfP+aBOCqRiDhs9lOtsB2gDMGlxMojwLjlMmeb/UO+ie/Wubsv2s425w2IFJmxNtKxjF+d+Sd5y7Yj6pFl+7+/EP3BXZfg0kRQivCqBGijpj9fWGLsGfNJRxNGzYZR4cJfRDyAExhB+JCUnIwakQAvyZbvXdT4zEhMekiLP8pNBnPJY8BcYWiDUng1GodnBsUidXUQfYuWfDLQUnXTc5JGJg8tU/RXCYyu0zMi692HBFZpo+wdoeBcf9/0l8GzTYCFeUbflQ09dH358ni2h3Pg9kzeuvWhz+ThO5yM3BUoiUGuSo3WMtt73OM2GN2gCMvLlt9XKaWeb8j7czfRJ7qSWkH5UfAnAaMkyPWDF+VbWrRbzuo=
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
1. Dynamically flipping trace execution state for a designated allocation.
2. Query the same tag again, and check that the returned tag reports the
   new state in its `trace_on` field.
3. Restore the tag's original trace state, also on failure, so the test
   does not leave tracing changed on the system.

The test uses `dup_mm()` function name with the function filter in the
IOCTL to run the above steps. If the `dup_mm()` tag is not found, the
test is skipped.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
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
2.56.0.385.gd3acb90ef8-goog


