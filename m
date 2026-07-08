Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2345BC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 18:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F267D6B0096; Wed,  8 Jul 2026 14:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED6DC6B0098; Wed,  8 Jul 2026 14:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D77AB6B0099; Wed,  8 Jul 2026 14:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1C346B0096
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:01:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B632168B03
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:01:38 +0000 (UTC)
X-FDA: 84966377076.13.A82794B
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5716A120013
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:01:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rDWUAIpV;
	spf=pass (imf29.hostedemail.com: domain of 3fpBOag0KCDMPQWXhWTZQPePiVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--abhishekbapat.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3fpBOag0KCDMPQWXhWTZQPePiVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783533696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7UKXB2WhHPZfBUr+7nlWpVJ1Kl8ZwGizFgFGzwoYUY=;
	b=xCvdYSMWWyalLg2GGRDnAbUMiRPEqldJuOsvpiOSvAmONZFjuTnj0D/LFPsMDXRIPbDeQh
	gQtfbc0MgBtTICYgqqhyKRI+6nTHOi3qLX0VNOVByyrOXy2JONKPen8CrnLv2C5lVviKHG
	7JUuDkxs947+uSDnxqnN26O8+0GkPjw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783533696;
	b=UrGAxLSE1ghTLqCznt0NknQOxJOEaahXOAm4uquVPGL1iWX9ewfaXYn+CDCQejPNUWK9RV
	sq6/qcm/WxX3St2A4zJUujYL8K3QU7DmiH7JdROm1vXcRqKQVu3W0EUEkMn1AiCqbzeD0k
	4FXSB9rtfs/GZcgsCnduy4jjIrWTlRk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rDWUAIpV;
	spf=pass (imf29.hostedemail.com: domain of 3fpBOag0KCDMPQWXhWTZQPePiVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--abhishekbapat.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3fpBOag0KCDMPQWXhWTZQPePiVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-388b404eaa4so1448388a91.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 11:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783533695; x=1784138495; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T7UKXB2WhHPZfBUr+7nlWpVJ1Kl8ZwGizFgFGzwoYUY=;
        b=rDWUAIpVLrfQP2D6puMmu+3MPFXBgxezPAKfAImkNmmCRhiL5HjfyMaY4DyEVc5QXp
         +R6BZCujYi4IxtzR0vEX+m4iBulZ2woCbQhuGN5l0/thlqkyE6IjVGynGN7qBRvT+PCU
         mnaOnptBtQZzwtUCt2b3KUUSqC7edfOZb0+SQrUG2sAT9i1uJox/8NOKXJJnndL4ezyw
         sJLQfzfEctkNP4NGvRFJ6hYSZX5qfW1KZbaUH7luqUZvQ0XQLpzFVYq+2SbkQdtYL+Zv
         cBtMpKRFtWC8+eW4fTQKYB5ICSkEI8daQc45Y0fxlP8Mf1MjUv7BtYoRy9+dA9D8l0wg
         kYiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783533695; x=1784138495;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T7UKXB2WhHPZfBUr+7nlWpVJ1Kl8ZwGizFgFGzwoYUY=;
        b=OvE5z4ljSAKXpTxTk4xlzSjQCEUcZG1z6ChtPZc01CMWyGxoXa+8EOVW9ndXdUaOE1
         MpdvmbubbCfm+TRexKY6w8E/7E8n/yVMlUiTN0aEJ1k1G6YyeEK/jMkzPgGHtIxfAvPt
         MxPtwPiezkTA9WpzlsCIJ4QAix1W7M19OdE9zVrTRC+KX2zRW3en/nxyxjKd4EJFdu53
         gwfx/2btj4tYSdlcW8gC/MZaJNTJ+RL+mQEEMDRVNSB2KZee7y6UoSqh48AtOvF4RGKB
         YqZPQt9Lw5iyFHumA7WhBAxB4+ZHCLNYAdu/pzEtU8ZmutuC+D4xxZWj0OyTgmwJeWST
         gEMA==
X-Forwarded-Encrypted: i=1; AHgh+RpjHh7V7ql+Z4aGZczTe8oZu/DHsMtepsnsP9k2Kaz3Jxfz2Sq0aNBmlSiAzJRONIq0ZiBkQRkmlg==@kvack.org
X-Gm-Message-State: AOJu0YzEhbDRzpBXM3jgixz5U11zDwTLseCR85dxpk0uI5p6TCk4pidE
	9pAzLuG2Sh96ZFlU0SNQn5G8FgFkMr1yp9AumU/CvxJ38JGBMlrR3tKSiyugDsNITI0tl0ms2NT
	pwS63XveI4QOc5XICK0TjlJ9A7kaw34vCog==
X-Received: from dycme2.prod.google.com ([2002:a05:693c:2402:b0:30c:2df8:2138])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:28c3:b0:37f:db06:2299 with SMTP id 98e67ed59e1d1-38942f70dfbmr3593771a91.21.1783533694942;
 Wed, 08 Jul 2026 11:01:34 -0700 (PDT)
Date: Wed,  8 Jul 2026 18:01:28 +0000
In-Reply-To: <cover.1783532853.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1783532853.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <e5171926b48802531284c1cb5f04734017141341.1783532853.git.abhishekbapat@google.com>
Subject: [PATCH v8 6/6] kselftest: alloc_tag: extend the allocinfo ioctl kselftest
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5716A120013
X-Stat-Signature: 36roo3g7dmzria5hyayfrw35ohieh4ey
X-HE-Tag: 1783533696-588891
X-HE-Meta: U2FsdGVkX1/kNPY1lKH0vlfM4qMZIOpl1T+ytECMFk/y3fTU5jowf1E2C2iqARzZ32oh8iIu8wIhSJ8zkr3RlR3qhgeM+dbN0iExKBxAfI0WcKnddB3WwisPqRsj7490U9pcwwHr73FUp+cl3eAVFnaOlmHtHi5NAnOuSJsgO/eicYYdxvZ4HL6IQpSlrJ1u5A5qtZyKZqY9zwJ8yVDkjqByN/zDndexiVb6swSXLGkGsldDwpM3mAkQz2D1HqZUdKKs3TtEtb1zw2Mq5bWbiY+H0PQnRKJKx1BA8PgFR8HmvL4WICZOrIWGFHMZhcEtkus1cdTTUO+yWN+ovAgwAq1tX+Kwer79ApFU8VYMsqjONJV6X5sP0N/tJFxC2MhCgfQBpfrA3iDG8KtVqPc61ypzHcBWCIs9DCIUOD+xABJfYcwzo+kBzzXCfmcIhL/WRHwGVYifY6z/UAYhrqeBdWjDw6bcoWMj0KUZwGGni6KugSzUkOBpUtbPj0ahwGI/0ipEiWP4gwwHQr6NJ7wkVKH3JNOf55Fdsl6vUkWKlXblu28cNssxo2L1EXRD29X877DSg4G9zszMls1AqcmcpvN8RZyjzIxWxx2uWaGjiMNWZoHOCXg89BfNxzH9r7r8iReAnqjRumHgmUV+MTwBrIa2Ixw8sBx/QtF6+AXvgdCVboloWI28QJ7TNzAdOcwKqXP2iqa0PGr3iooBbBYe/dq1VLTe9EWECyl/g5gSBgbbQ0D6Y3KDJTzhbSdRXA0AvezKVHhIweg09ZJ+kJiKZ66u2qzNfzO/AHf6M4GZAyWV2YJAqto0TTfrERz0nei9PVZbNZH7tFZQdQnYUm2uEj1Co2UEgJ6Ru2kv+399ZrN5FbvnwTFQXcTbcudsRFH9WiZZ/b97Ff7Nn4pEFZorEM21o/jGD8UZBVQb9LFMHOxa7X9LA9dWmq1LeqgIptzKLN6bSz1wIGYKf/YbtoY
 ZUx0VJE1
 xcFZZwiIC2r/rq5VHvTiovqz+3n0dQlnzHizSO+J9b5NGAF5Wz3/IhJoLdGnXhLbrevdsfUODS5cMXFyWKN1bRKe/11isBG3w83M3jLA3OWYz0fSjEinUIIyB1hxzOIsU/5DB1I3s5cLvdsld3fuy0ZxAr0vq+opL7obUtvw3eEV1hJrbBIr/XqENXRNtmmyKFTwAU20Uq/Uk1qncywdYf44Ec0lUo0Yut++iUtEstVhNxFUPZ4f+wNaKHSRrSGm2e+fe4NTDInw8I+lUeRe9Xaf+9tgcRI4jRjQ2d3W0hdZdiPc8S6bLKW589LJkG4l+gjTnpv2M/XEq2ubhGkXwY+IbUaLBodjwb/+L5Vbi0M0EcN+jjLTwCWUqxID1/azVI1zU7Jox4f7Fs2rWUlQmZLRS6Gnt6W4qzLL+UmQuNi8reKBJmbT/0ZEXyKKYxYfgEUajJvdixQtwBjaBGzXBamb+P9qHO20bUo0ce21JmHlqgY4830xVyonRJuNk2ia+U+uXwzPsVi4LSUlH13oiNRhEPABJxGQwn6utE0Hrlwy9ZiNUkzHnPAL08YEPjet8MG/laM4FFaxuVm6sGBUqaaWf7vQzVkFhRLd2rBanaCS5ItHM0CQfPn/+Yf/dDO1wrf/OyV4iG1azJ0Ofi1lscfX1FNACpbZWTrBlM3jxuy3zJvb1wZ+6oAhDmg==
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
index 9ce7b53078b1..7d94abb785a1 100644
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
+		ret = KSFT_SKIP;
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
+			ret = KSFT_SKIP;
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
+		ret = KSFT_SKIP;
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
2.55.0.795.g602f6c329a-goog


