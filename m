Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20BA4CD3427
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 23:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A0B06B0099; Mon,  4 May 2026 19:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82A426B009B; Mon,  4 May 2026 19:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73F176B009D; Mon,  4 May 2026 19:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 605F26B0099
	for <linux-mm@kvack.org>; Mon,  4 May 2026 19:36:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1ECEC40303
	for <linux-mm@kvack.org>; Mon,  4 May 2026 23:36:46 +0000 (UTC)
X-FDA: 84731349612.09.1E3F797
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5CC1A40005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 23:36:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VZIXpsXs;
	spf=pass (imf07.hostedemail.com: domain of 3ii35aQ0KCCE78EFPEBH87M7QDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3ii35aQ0KCCE78EFPEBH87M7QDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777937804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G+hEq3xcQpeNbVKkmlLzQ0aZOXZlDNVaIlQ1vlmIpXk=;
	b=1E2v+UKDXSTvCMz+vJxtDn0FjhrYC/dcOdqgC1/fwZsS3d8XhYz8mYIpx0cjQCqCgkXoo2
	1usFRaN6Wq323bfioVcryJWTgO9KeU/BlzTAn8FnM9lq3EbekLbeI88XBNWiqCie12cVv2
	18X0gwyTPQDwgJonKxKWHBNieAPdNYo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777937804; a=rsa-sha256;
	cv=none;
	b=VVKd8e8VBb3bffx99LEzWkZS4F1dhjzWxlDNCNFwLNs9YgTJY9zgDfwroROexWTZeBYFgZ
	ykPIsRxU9gpD4EXo1SZ+LudOiC3s7qy+0YE3MqZU5ppTzN4KuH2ldb8TPCrc9S6efUmrEK
	XUcVmaBDwSwhMw24ggiZSMvxiqhEPsQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VZIXpsXs;
	spf=pass (imf07.hostedemail.com: domain of 3ii35aQ0KCCE78EFPEBH87M7QDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3ii35aQ0KCCE78EFPEBH87M7QDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2ee1da7a13fso4469569eec.1
        for <linux-mm@kvack.org>; Mon, 04 May 2026 16:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777937803; x=1778542603; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G+hEq3xcQpeNbVKkmlLzQ0aZOXZlDNVaIlQ1vlmIpXk=;
        b=VZIXpsXsyaXUtXWsaJUad2I3cCbuWrFOw3mKznKCuc5vbusriEJcZSGSgRnkjY7wet
         /wvZP7jOzR7RkCsu+wL2CGAOXSY8VJD0By+SSSL26xIr9vranglpEgA7chDEQg7hbXKE
         kk6C5OKRyz5rzZeeApeTNmbl25pZV9zdKua1zr9kYbP647xKn9Y2JGePoMTfZQ6nP8/s
         2/fABiGnz1Jd/0XNt9PlSfGJ2odDTJEVHvRwhiV7Cy0wYx0bb5D2NMAlaEegW/m36jsd
         uxuFvCRsTMa4LXmcJXrtBwWYUaIZxvhgNlwuDeVQgVibjlZD7+Irpcj6n5cwatw3xhSQ
         B+EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777937803; x=1778542603;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G+hEq3xcQpeNbVKkmlLzQ0aZOXZlDNVaIlQ1vlmIpXk=;
        b=SKa5xe53udbEOqcljHnm3ONQ3o36R2GvTHY45upjZ4aOpLpb+2pbEXiI8HFQA+KbC3
         AMBttYVbs9mKzEtCaD2VJfOLo8iBAW+212QRj48DfnJVUntJOalg+dyr+aOviYq2GQLv
         fcAT4+dk5kWMXU7Vah6f1wa6ju3XaHLJoBKD0FmJkadzZXtF7K/vypdk1F6puGgHlDjy
         k3a8vmK9df7tVmrAZdsHR2JHNxHxUSa6SEsgnz1J2ccTnQvovF83QR+ptncs7iF0aW/F
         nE817u0R5XcQf089NTquVlfXhm8rfWoTeljQr0VdwfOzTsvG3vAbaq7PYlhMbkCOU/tO
         ZoWg==
X-Forwarded-Encrypted: i=1; AFNElJ9BiFr/MXrMaVtGPmHEkmqo0tDxMxbABvcyW42MESYwKLacU1dQhyUTJmJLesxZa1/B/6zJuKQw3g==@kvack.org
X-Gm-Message-State: AOJu0Yxf7mcaZrd7fOc97456QvfBIXTQco56QPUGg9aReOTBCPGNcdld
	Adyd+LU1qq+Hvs5tTVOMinvR5xTvr95EgLgXXlIZXdapWUW+/Pq8fg3YDsDaVj/8yJTaqzjk9JQ
	tTpg+sSfxLVK56SI03BGuc8YI4ksIqK29Uw==
X-Received: from dyclh13.prod.google.com ([2002:a05:7301:6d0d:b0:2f3:f2a4:6ea3])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:cd8e:b0:2d2:96e8:1bf5 with SMTP id 5a478bee46e88-2efb7bdc5bamr5234886eec.3.1777937802855;
 Mon, 04 May 2026 16:36:42 -0700 (PDT)
Date: Mon,  4 May 2026 23:36:24 +0000
In-Reply-To: <cover.1777936301.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1777936301.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <26468cbbff1760513043fd3589f9c106dfbbf5bc.1777936301.git.abhishekbapat@google.com>
Subject: [PATCH 6/6] kselftest: alloc_tag: extend the allocinfo ioctl kselftest
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5CC1A40005
X-Rspam-User: 
X-Stat-Signature: 1b1bgsss8p5sge18kf7rqxf4r1n6imqo
X-HE-Tag: 1777937804-110374
X-HE-Meta: U2FsdGVkX1+39zQf1napK7hHalZLjp+BVJ1X/Rb5eSBMQbJv7Fzq8XcBkK87UyFNIIFzagBgJBovSgwDO6gc+fHXBaoNl2Ggk+coWIxn+r6AOmbQI0TKr184KdeDOLAqlS8a6c+AyQkS/h3bJZGcLKqRhtRxJm2nTC75Vi/Rx3y2iaU6vnvstclIrG/fX7piPDDwfHUKJhWxV1RNPMGNjZ6283X3IeRNdcSU0GlqPfeDirTK9jU/hd8wfxYfS4L3j+CuABVWuMIkl9NtDzs5fy/zg2JxzblLEsx8gaHXdDHWZWjhmVCSjsPuJ/rzs8dBzPoaUwoREmFW2lEjbtRISta8hC1moT6BKMR505mDGx0EMSoUY4nrdU8ImMi7sBZrsgTuPi+TSGwIlr/IHe5pAV0x9YVm0LIhBB8ta9Op3A7wEl8yRUTZvrLZ7lMg7LrFDcQEv0e+6L3uRKkfUhM2J2nnO0HFPLWaBatCq3Xf9B02DeKCK6o7zIdD15SmmrhYW1avF+sXU7d2UGQPQPuQgNQDivAns/JhMSWik84XjJIL6v6xzMLAZ8O7/exmRSUNCH62nkmdXgJQo7DO/rf0mH2qUh7FhaNO6lDqMr0FBVU80Fpyf7pCEfPkM5CEe7H21k4v8eMCIXz7L6aoZSRt2QY5/gstNojCV7TU8Bnd95uyOgevq0dI+nGSHEd4xv+Wx7b7mtYppNhs3e+m0WZjDtqmk6EEGs17+4ojEksz7ILaPDIcLdaBv6GKaM7a32z5U5achQhiFHGH1aSDazEEGmCI6loOWT8gTcfwl9McQRi9lVYQgCLdkB7YZrS8eQsxuhNMWrLfB83e1nP6zvQob/vt/iY50N7ZtDzGSJTxDFJ43c3w0DiOpiqcpXnO589p5pme8M4gRuSVh7o9Oqb+5EEOY6FmInx1ykBIqXGNXSaYePGUqxoQCcYKnCcOeq1gF4ii+0KG8eY7yaiJ0//
 FkUlQS2K
 gOJyJ9u9PNSuj782f2X0qFeIvfvAJp6hjUM1EfpDlP10KpofMUkZrs7RWNfxXz5bURPE0AmSWMyN+YouGcGuOHmHZAAiEYVqT7xhQwcUgz2++HWvrYvN6EyrYBVQZJ8cFAIBhNkwXl64eHBAqArW9W6xeEv4S+IwoDDpvz8e6U8wsZgFOsZ+8o97hvsdJjfRbqxPzTo2H3kzxGFxw/AbULz2Z+4MoSTUJgROLs95JOZ7pR9zY8O6u9j6aYuUNNkYeR80r9q5GdFdLIBizzrydtRRRGAe7EU8Ibcn8G5W+KnWNk/wQeg9oJIZRb6s3xT6/z8+obybPPqLOgx/QBB/eBeT47LwRSMOBJj0qpI9VxcVMZR4K2h0QzHQ7fvY0RstzJO2Gh20BfNE09P0TZqB+TIxQvyihXXzQonwWqBkMCwMl9K5IO5PQo4cCKVp8Fjjt01WB1vJHrJfXW5n/xUc0jTMIFKPlrhXV2+o4YXP6zGOraXNVkXrGkkCYtEPjzGEOzgW0LKWD+mfvt/7jskZUFqMkDWhzzIEYdfapbW+m0GgYjUJRjYS48oW8KbgmuIEUIa+JpuIo+9i8uJAqtgL9HlVO5zU7dEEMqidqa8SSkBwV26X9iyloTTFgTC7cm6ZdHb4qO8gAJ5sF1oIDv/mfA+HV2a3r1Io3POoz6wnCrcWntnmWFZeSDD3Fw3U7z0cuwcF6SjzigWqLHK1Q7cYihU3PkNrH41fG99C9
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
 .../alloc_tag/allocinfo_ioctl_test.c          | 194 +++++++++++++++++-
 1 file changed, 193 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
index 543023ca3d27..573d84a3619a 100644
--- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
+++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
@@ -294,11 +294,191 @@ static int test_function_filter(void)
 	return run_filter_test(&filter);
 }
 
+static int test_size_filter(void)
+{
+	int fd;
+	struct allocinfo_tag_data_vec *tags = malloc(sizeof(*tags));
+	struct allocinfo_tag_data_vec *procfs_entries = malloc(sizeof(*procfs_entries));
+	struct allocinfo_filter filter;
+	int ret = KSFT_PASS;
+	__u64 target_size, i;
+	bool found = false;
+	const char *target_function = "do_init_module";
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
+	filter.mask |= ALLOCINFO_FILTER_MASK_FUNCTION;
+	strncpy(filter.fields.function, target_function, ALLOCINFO_STR_SIZE);
+
+	if (get_filtered_procfs_entries(procfs_entries, &filter, fd)) {
+		ksft_print_msg("Error retrieving entries from " ALLOCINFO_PROC "\n");
+		ret = KSFT_FAIL;
+		goto exit;
+	}
+
+	if (procfs_entries->count == 0) {
+		ksft_print_msg("Function %s not found in procfs\n", target_function);
+		ret = KSFT_SKIP;
+		goto exit;
+	}
+
+	/*
+	 * We depend on the result of procfs entries to create the ioctl_filter. Hence we
+	 * cannot recycle the run_filter_test function here.
+	 */
+	target_size = procfs_entries->tag[0].counter.bytes;
+
+	memset(&filter, 0, sizeof(filter));
+	filter.mask |= ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE;
+	filter.fields.min_size = target_size;
+	filter.fields.max_size = target_size;
+
+	__u64 pos = 0;
+	enum ioctl_ret ioctl_status;
+
+	/*
+	 * This loop is required because the first 32 entries fetched by the IOCTL based on
+	 * the size parameter might not contain the exact entry that was used from procfs.
+	 * If that happens, we must update pos and fetch again until we find the exact entry.
+	 */
+	while (1) {
+		ioctl_status = get_filtered_ioctl_entries(tags, &filter, fd, pos);
+		if (ioctl_status == IOCTL_INVALID_DATA) {
+			ksft_print_msg("Trouble retrieving valid IOCTL entries, skipping.\n");
+			ret = KSFT_SKIP;
+			goto exit;
+		}
+		if (ioctl_status == IOCTL_FAILURE) {
+			ksft_print_msg("Error retrieving IOCTL entries.\n");
+			ret = KSFT_FAIL;
+			goto exit;
+		}
+
+		for (i = 0; i < tags->count; i++) {
+			if (strcmp(tags->tag[i].tag.function, target_function) == 0) {
+				found = true;
+				break;
+			}
+		}
+
+		if (found)
+			break;
+
+		if (tags->count < VEC_MAX_ENTRIES)
+			break;
+
+		pos += tags->count;
+	}
+
+	if (!found) {
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
+	if (tags->count == 0) {
+		ksft_print_msg("IOCTL returned 0 matches for target lineno %llu.\n", target_lineno);
+		ret = KSFT_FAIL;
+		goto exit;
+	}
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
@@ -312,5 +492,17 @@ int main(int argc, char *argv[])
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
2.54.0.545.g6539524ca2-goog


