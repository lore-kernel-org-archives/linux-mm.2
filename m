Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C308C43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 18:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43E386B00BB; Mon,  6 Jul 2026 14:26:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 413B16B00BC; Mon,  6 Jul 2026 14:26:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 268DA6B00BD; Mon,  6 Jul 2026 14:26:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCD1E6B00BB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:26:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57AA21680DC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:26:02 +0000 (UTC)
X-FDA: 84959180964.17.E724F90
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9E05520009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:26:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sPBfWv2s;
	spf=pass (imf13.hostedemail.com: domain of 3N_NLag0KCKYGHNOYNKQHGVGZMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--abhishekbapat.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3N_NLag0KCKYGHNOYNKQHGVGZMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783362360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ebmkLDICYIqxaCrg+8iTMuP4BfhYuBwhF0kMyFUSvM=;
	b=QlJETZ0uyqroh/72CHvrviq32xQsrEJQ866ocUUH5Tan2vjt+5QZEGAcQkjOTDnlpy4GFj
	qH08QF2JCgORcOxQC2g7xtrNcqgn07NI7drgFajpumX7dw1xi0FvUPQPKIt3/9+EIHNvte
	BPYhx3LlnbO3Y7ZL1s7xY4vyKULNzcE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783362360;
	b=AZ7iSArVJz9xqr57O/W0ayv7MWvoHtwNqa9ijzzSt2nEbz+5hi4EubqpqFPkvOCgRzvCNp
	DxYLS35OeTW1bPa20ODPmKmKD93D4GCkys7BfaokmG6eX7B+qgeijEuQiavd4sRhjEWcOc
	Ge+4HW1SxwifKmpdmA6ePE1vcjuAT8I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sPBfWv2s;
	spf=pass (imf13.hostedemail.com: domain of 3N_NLag0KCKYGHNOYNKQHGVGZMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--abhishekbapat.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3N_NLag0KCKYGHNOYNKQHGVGZMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c88d7a75507so5507464a12.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 11:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783362359; x=1783967159; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5ebmkLDICYIqxaCrg+8iTMuP4BfhYuBwhF0kMyFUSvM=;
        b=sPBfWv2sjKRGlxK5MX1831jtv+PntWV5fL1EJ7NWlMe+j1rWLs7hfT/HHKNgCEBc40
         kTPV7+pEQLivjF8CulgephK6wXY5EBPtP7tOqfm0NeVkvurgWuIPxdGcOgG8QO9+h5Jb
         uU6vwhj/SAlzzWTvXvDyOCIQPE2T2FUGW0H7bM1koRBZ/lAVfsE9pYFZGu1a/kEWtDNB
         b4M5v4aLLksotGrKn2PvZu84lGBS6k3pfhuywJwpuGbh90JjV3c341PffiNcDBHREgwn
         /CWn04nQtuv146zs8Ztiw1Lf2jEwp1HG9mewNFcZyzuvUA+esw+qebd5fz5SIgb5Tl8s
         yJag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783362359; x=1783967159;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5ebmkLDICYIqxaCrg+8iTMuP4BfhYuBwhF0kMyFUSvM=;
        b=lxjxajRSC1VwKyLxv3ohR6ZmB+Ko8O4DR2K+NINH5/rYmjhLDj6aHMRRZouaxQ1fEy
         9PzB1WK+KogLUClufwJoJcj0Q6aIgLW9hixRhCFb4TC52nhdPnArjzlVIwCa5P0lUlVU
         kTxzWPIO8GIVuluV7W8TBAnjkErGyJ8MjvBbiegn8saMrh9pJEZUxNPhgPzuMCWOI1PS
         qRAAlaIxcKTu2g6f8eZyILdu40MnWIM81Y6P/WPqOG1A45noLpCT4Y4Z1Fbds3kQKg3/
         Aieh8rGdzE6mPnAx1dxeWLNjqPemMdQayigPcx3MzKgUFHary7a8gOnROLOgwlRh0FMP
         DyFw==
X-Forwarded-Encrypted: i=1; AHgh+RoLbsVfOD6xEZt2bRgxXFyXu4J09kT5K0WnUyvpoyiWxHhlI2aNjvqioGwOTC9rdjNlqWpgTOFsjg==@kvack.org
X-Gm-Message-State: AOJu0YyRt7nQOX8rJY8nTIu3PtUSiL7WdlD+sZSXkxvz68eDSa4SBqKl
	yzAB1Rc9WvQZF5icYQFJTNevFkissGcyPuNOuEfuls+RImGhertC6E1nbEUkUC6ITudaBuK3b7g
	TLCXHcx/0y8V7b6TBaqJTn+2hgGfJxLJ3wQ==
X-Received: from dleb18-n2.prod.google.com ([2002:a05:701b:4252:20b0:13b:4702:ac79])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:2d43:b0:3bf:6c08:fba7 with SMTP id adf61e73a8af0-3c08f032c79mr2143625637.59.1783362359350;
 Mon, 06 Jul 2026 11:25:59 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:25:49 +0000
In-Reply-To: <cover.1783361692.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1783361692.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <f6bd1ff0257987dbb7512f93595eaa6962c6153b.1783361692.git.abhishekbapat@google.com>
Subject: [PATCH v7 6/6] kselftest: alloc_tag: extend the allocinfo ioctl kselftest
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9E05520009
X-Stat-Signature: spndpwhg3pjb1ryjx731bd7qcqp4qffw
X-HE-Tag: 1783362360-326038
X-HE-Meta: U2FsdGVkX18Q/o3Ej+zke7BEM61e9BKReIo4JKD0dYYl58nkTo5QWYOSLnxc+PmZyrTPldnB96u9y0X94HjdsyX4RePXjMIiBpRBycC3YnnMclGVd6iBo8XDGJ4ggkkAXYiHCsT41mCRpB2RQG9f6sMEkoCaE/cA+AZKkA3CiXqUVKkptsxGn6HMnEyaZpoK6EDlTN538/eazPgV5knCCj+IGIlSuh9K0PMd91C+FnNFJRjTcot9UFpsOd2pI4NQ2X3LQYE8e0Ghy5UxSB8OpNH89p1qteAl6V5kaKjy4PzbS16OOCy73g87BtxpYRqDM80QqGIOlzs3GeZI3j6jKmiP3WdAkl/gnXV4cjVyQOoJNAJQ2Ova+P9iNy91dBP7MsYBjrqlwUMEAIXoCRlmGizQJ9TuUOvXr37cZN+qVUTMSNC3LWDp6awSqw0mG2FwYc6DrXjzXrA4A7GZW8eFVuxMjQX4PIkgaKcJ2b6ntcaaxVdtrunuxJV7sNdSUmBEY5XfZc0SkmIO8LiD8oJi7rIi2Kjk+2xyExp7kNjzO9iN+0JRe0nBQa/m7rpOVhKempWB8nwyCs0BNxgOn8HTnzb0XwDDgF6uI9rteZzEl8zow+R6NefV7LfkXfHYt5ozm47UeBQnctywCuIwV750vn+GjS00Z+4dp5TtXX01JMqR3Hzvqr+vrPqDQ92/sa2U+8osM/qZEVEUUsh9fYBQ2h4dMfQi6AuYXT7TwFdD6fX/6gu9JxLI3wVU99Wa0/1ve2P4nUMM9y/S0Vj/4vE2nCZuMYFw8/4hYTuh16nnNmhfXjipPaT+Z2udRBacmVQ9DGBhxjVrgm+L0aQxFCADqSL++wx2inZtYqboh8yxnVOkEhjWPG9Pzu/JLroasGSEumvDh59XjtJFxxHs0X68Gq9mfXCFlSDLjnOnMw+znb81wy4YaZ19OKT5SPAaSuU4V9tagRQ6CGav4wve4+F
 6k5j9zXk
 hsQlaxVyWWQpSVX1VvmEWksPFWDbNxZWqn1FjF0vIeYUcH1ZClCKcnnvUMFp4nPsVwFweG6oldMmBS99PZgaYyiw/LPxcSWltBAABSgp0J4iD/44cwT2pquyHvLiwbQ2JyI7jb1Vp2Pe3pm2+JbCkEZ/O9ph9cfDsHdW4dY88C/d/LUvWbPuvorqGZ+jkRkhwDEiN0/9jauRoe5j+g87dof2depXE3vQUGlyiyZKYOBY3QGPMSBC2SWViiw6rzDqCN6nvzC8ZQW7TKRnvVhw6gQ3EIpz4BQFt7m+MLHfv8VUPPiHY7Rz2QSt3iPTvl8t7h4MfIl2gq0gJrdIyF8gplcPxTuoPzpq+mALp7c0PDzLj+XaGqE+6X2/tNMIg/Lluvlx4Il9UOp0s7r6UNJH0WOsx9xKWcX5f5M1WhW/lMP04e+hEoqSNR6hgxH58PcDx+DBpMf5FyiVQM+86IMjSA/lggzxAP9UBgTH7EOKwx7O5Bm899OYzt7uQEkeum+D+VrksF+RTOcaCVO3AEpDduz/b4O5toF0vB0nvdYoYASAoI5z6dgOtBY5gjkD43M1Z4O7Q9UEPy8aJjMA0VhW6G8lpRBCKYGACBqbeOODoAZIWIBNjJAH8VPZ4D5qr0vgsh/EDX+KtwKU2VRAm+X32M9QEZV4GrBWtfnYMANTaaPihbmRNOjewWWWNMQ==
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
 .../alloc_tag/allocinfo_ioctl_test.c          | 216 +++++++++++++++++-
 1 file changed, 215 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
index 9ce7b53078b1..092348097204 100644
--- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
+++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2026 Google, Inc.
  */
 
+#include <errno.h>
 #include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -312,11 +313,212 @@ static int test_function_filter(void)
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
+	struct allocinfo_tag_data *found_tag = NULL;
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
+		found_tag = NULL;
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
+					found_tag = &tags->tag[i];
+					break;
+				}
+			}
+
+			if (found_tag || tags->count < VEC_MAX_ENTRIES)
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
+	if (start_cont_id.id == end_cont_id.id && !found_tag) {
+		ksft_print_msg("Entry with function %s not found in IOCTL results\n",
+			       target_function);
+		ret = KSFT_FAIL;
+	} else if (start_cont_id.id != end_cont_id.id) {
+		ksft_print_msg("Failed to match content_ids for procfs and IOCTL, skipping...\n");
+		ret = KSFT_SKIP;
+	} else if (found_tag && found_tag->counter.bytes != target_size) {
+		ksft_print_msg("IOCTL entry size %llu does not match target size %llu\n",
+			       found_tag->counter.bytes, target_size);
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
+	struct allocinfo_tag_data_vec *tags = malloc(sizeof(*tags));
+	struct allocinfo_tag_data_vec *procfs_entries = malloc(sizeof(*procfs_entries));
+	struct allocinfo_filter filter;
+	enum ioctl_ret ioctl_status;
+	int ret = KSFT_PASS;
+	__u64 target_lineno, i;
+	struct allocinfo_tag_data *target_tag;
+	bool found = false;
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
+	 * We depend on the procfs results to determine the line number for the filter before
+	 * making the ioctl query. Hence, we cannot reuse run_filter_test here.
+	 */
+	target_tag = &procfs_entries->tag[0];
+	target_lineno = target_tag->tag.lineno;
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
+
+		if (strncmp(tags->tag[i].tag.function, target_tag->tag.function,
+			    ALLOCINFO_STR_SIZE) == 0 &&
+		    strncmp(tags->tag[i].tag.filename, target_tag->tag.filename,
+			    ALLOCINFO_STR_SIZE) == 0)
+			found = true;
+	}
+
+	if (!found) {
+		ksft_print_msg("Original procfs entry not found in IOCTL lineno filter results.\n");
+		ret = KSFT_FAIL;
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
@@ -330,5 +532,17 @@ int main(int argc, char *argv[])
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
2.55.0.rc2.803.g1fd1e6609c-goog


