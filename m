Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 845E8CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 17:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B592E6B0096; Thu, 18 Jun 2026 13:36:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0A9E6B0098; Thu, 18 Jun 2026 13:36:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A200D6B0099; Thu, 18 Jun 2026 13:36:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B4676B0096
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:36:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2A73165931
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:36:47 +0000 (UTC)
X-FDA: 84893738454.23.AEE7384
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2736B14000B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:36:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ahqKB5nP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3rCw0ag0KCC8LMSTdSPVMLaLeRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--abhishekbapat.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3rCw0ag0KCC8LMSTdSPVMLaLeRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781804206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/r4FYf30y6HeoEJoxw8dAX2UIKuxqRqzUodrZTJeu7U=;
	b=EiRXBWDDeIdcedKXe0/emAejA2Qt8BF8+bVmulL78o+OSWioYuFJVOLs26D1SeskvZSCKa
	gGWpC5tkrdzAGF6KdhsifSA7NuxDKQyGa07rokhLAhtA7mfmoUXNanM4K1fFgmt+gHsJK0
	sZu5m7LgtLg2DGtVqCxAiOgaLRgyXSA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ahqKB5nP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3rCw0ag0KCC8LMSTdSPVMLaLeRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--abhishekbapat.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3rCw0ag0KCC8LMSTdSPVMLaLeRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781804206;
	b=VWW9Cf1w1oskkJNi7gdl8MpiQnAlIiB+TvxyFnTweIokb6T221e0N+PBuoLhdzTfWALoZ5
	CCi//BGEAYJ3t4pADPD9XX9OMhBz1GJPEQdIW+IBsTpK1gkyW+YxP7BEEIRjaJPLf9yjPF
	PoS1HE2CJ5qKiVW/xXnJfS0YQXz9RJE=
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-137f3465368so1912942c88.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781804205; x=1782409005; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/r4FYf30y6HeoEJoxw8dAX2UIKuxqRqzUodrZTJeu7U=;
        b=ahqKB5nPhtlstDm6zZ0e1CdOrVekqgDGwfiQnuZUvb/013XOUpGNtX7hzNn4G7aIWO
         viktYutuy2Ky0L7dniWJUYjc6f2zGM5P4VTPIJoER8/wVFNb7Gmblof2BM6/PKyJUbI9
         YBHeJ8oMlo+QI9FSiMgIketz0SOu2LGGjM390/wHaCPxiFwoDhoM9YQHVmAHxRzgSjPC
         9H2GO1VyrBVPu4/LobzvgGghbO5l5AGkVdV4PZ/YPWxi0R182mmNhGuTSN2HZbXkSFQN
         BwlKlRguyrx1ClGmSGu1CZvIhwhH2FqwR2jiF6h0gXmgqhufz5W24K78BoGFA/Nl+Gwu
         Cm0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781804205; x=1782409005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/r4FYf30y6HeoEJoxw8dAX2UIKuxqRqzUodrZTJeu7U=;
        b=U48NFYwUzufQinrjVuH4feja+v8Rgm4vzSlNw5rpAe7rAmUC1QgKRNjMic20HiF1JY
         0P/RoiUzWWIi7rhUsf6L2hEizwV9uDhvprLk4AdbV8xVaIcYYYfrzGjkwTo793nc2asC
         Yq8GcoGu3EhQmR7AzSsDii1ek20AojIzDaUaMrN4iDndYcn8FfcklVa7VyvtwyQ17bXW
         sySUiqjxohz8PnnNHjg+BG1R9UEAVJtvvKlAATXqeTPrz8rUd9668Sum1mFEqyrhPhcD
         v5pVtOH8efu+hSxWMSL/A+8gMze+BD6Sszd2Dx8w8iw2jeHsa2/yHOeVLmtdnjr3JYgx
         oK3Q==
X-Forwarded-Encrypted: i=1; AFNElJ/oamZJVHNIIOhl7hbcfCEftJC4n1H5wHAcFX+3+vqwAe5Ig4zwRYfHW42V9SQQna3wKYhATw/VwA==@kvack.org
X-Gm-Message-State: AOJu0YzP6i5+HVaCQP4H/PX6vmk2BUuy4EMOSAILUeQDFuAiVTZCOvJ4
	FkkRHBYcMCHpElw9hD5RkQ4kmLlQIkRC9b0SbR6w85Fa9OmPGOaSM7vK/NELtfWC3yYwns0+rRw
	xs3hh/F4+8dqIeOtjv2Og6bgTxntHESUNvg==
X-Received: from dlbvv27.prod.google.com ([2002:a05:7022:5f1b:b0:137:ee55:b187])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:488:b0:139:879c:dba1 with SMTP id a92af1059eb24-139a202ec4amr496602c88.5.1781804204535;
 Thu, 18 Jun 2026 10:36:44 -0700 (PDT)
Date: Thu, 18 Jun 2026 17:36:35 +0000
In-Reply-To: <cover.1781803482.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1781803482.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <5a485adaa95f8bdce7d29ddab30238b34e949f28.1781803482.git.abhishekbapat@google.com>
Subject: [PATCH v6 6/6] kselftest: alloc_tag: extend the allocinfo ioctl kselftest
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2736B14000B
X-Stat-Signature: b88dsr1zp9y4qdxuymmbg5c4hjfwtgmr
X-Rspam-User: 
X-HE-Tag: 1781804205-913831
X-HE-Meta: U2FsdGVkX1/RZ6P4lXsRSikXr2qazfeM2QR0wUdwFOoz9nljdFMz+ZEM+cu3Pih9KZOmeriLCsDQSJsaNPVC5mfyJUBDpUDw7SN0djO9zTpD1ewSlIcp+zC1IYcOx0q+KUatbugHkslyS3VpLGEn0NGPXJ/mX9HDzzZM0m11BovT4hxBBm4ADUZp3caCK7iEOSYI/z6Ybg9xxtCSPnRgLQfDxlJE1kfD0lMFzrGSCNeBbP2QPnFcljfsawHn77AnU6FGRyZBGxrjdPBTzVZk9UNILLs/6kpxhh6dPZP6tiYet8GAek2oBjVbqQSLrHr4B+bYAGlkCpEjbKmyOhFKAbYkYVmt6s6QNAQbbDu4oK4k2vGIFvDGL8i1Y12oqYcKCTK8GlbPBpvfZMs/1yfFYZ2eH1wSTe4cP8bczdqNk20vprLaUxEu9yNyP03YxFS+zXfowK9GufhrWCFv7Nn+Fih5+idVKs9s/wWngP55mACN5IABB3z1nOlcvG2dvjpKlRrefEVF9wgPe8DdlFvy6yRAF1QS8nKVWcqKjkUj80XpxVPFhGD5qwOSMX+3HZQqOo06jMFq65kJOSyAkIcC4Rm3io592qKTVC9gu5SvAUw7O/6apL3+XjygcC0PmzKEE041uZl8A5o5dlu1v1MbtqRSfAiqslunYzBjaxUd9fo1gNrFqvVXPExQ49Go0M6wDJqyBru73Aa++ToF9xWqNPJdytnQPyoY3fYrwfqZpg/JSprrilWFdSBxUDsCnWJ0SHl89+6VUQdLx+cQEMESWBpiRm2QDuDpQyVZZ/XerXm/TkbfOH69mz9lQ4ltJavShODNt7y26n4yh3mo3+h/CqVKpn+N62JMX73ZS57H7xzFX0gfGJ6ulB5tlZnplY4vQDqjOSah5XJ623HyHKDYUAdNXoepQa4rxazkm45Qh6XiVlEes/DgZPl3gwr9TlpJEvG0u/RbTFSUhFCkByX
 GC0QyIH+
 OcNbg5t2rFLaxFtw4gAqd0Z9ZtQD1J/fGqs8spn/ufBYMR+1cH7K0DPV+HDtiba9n6T4rZl6bBt0vsZN0VlBKjsZCGqc2j1PxWSZvtkjXnzB4ieVJkrBz21EfZ/p/oNjOZ9UHJY360FSA+6Js+YLio2PKpLl4av7QkKzS+byrfXYf8U8Bcypv583MvgwLo2nKMg9c5OG9Hs15zBfFp21NlAfNuciz2hb4tb0oNP6vxIBvNeRmqTgkOdV7OUUCseZJCMrRoN2IewcK8NYZ/pOO/B0jaHYB1mm4fuj3lg+EOTddcKGH+rYMdTPp9AVtRqny4FPnZkN2NW5rfhVkZSmnUqSYyn2PiI2Gybw78TmvSM0KNJGePWvmUqaZwoBRW/hgkE4vBHdpL6gRFYzzVOM2yr2WLUWWDQ1aTtxyNPgq7VOUMwGIcdQJFeLusTn6U1Xvz21HCxtdshbQE1xqh/ZoXuBrRCB/EDmosYt6sz6JrAG5j4H0wuUwasNK713ZKfuH+Ekt71kppIU0UsGP2bKClxtypZpF0ZDQ44/n7cgLiljJzpAp69PRJFxbdVI0tTv1pqisRC++TiIPh7oQ2Ln18coiTWWfym1RJdsPJx12jatqeihyW6EGuwR2K2BurhNIzMLBUw2glmb/1p8=
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
 .../alloc_tag/allocinfo_ioctl_test.c          | 198 +++++++++++++++++-
 1 file changed, 197 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
index 1ae0291f2245..50755a45d3fe 100644
--- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
+++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2026 Google, Inc.
  */
 
+#include <errno.h>
 #include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -313,11 +314,194 @@ static int test_function_filter(void)
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
+		ksft_print_msg("Failed to open " ALLOCINFO_PROC ": %s\n", strerror(errno));
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
+		if (get_filtered_procfs_entries(procfs_entries, &filter)) {
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
+	} else if (start_cont_id.id != end_cont_id.id) {
+		ksft_print_msg("Failed to match content_ids for procfs and IOCTL, skipping...\n");
+		ret = KSFT_SKIP;
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
+		goto exit;
+	}
+
+	memset(&filter, 0, sizeof(filter));
+
+	if (get_filtered_procfs_entries(procfs_entries, &filter)) {
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
+	ioctl_status = get_filtered_ioctl_entries(tags, &filter, 0);
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
@@ -331,5 +515,17 @@ int main(int argc, char *argv[])
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
2.55.0.rc0.786.g65d90a0328-goog


