Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2582CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 17:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCC7D6B00BC; Fri, 22 May 2026 13:45:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7F736B00C0; Fri, 22 May 2026 13:45:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0D76B00C1; Fri, 22 May 2026 13:45:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 832F56B00BC
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:45:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4B2D9161236
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:45:55 +0000 (UTC)
X-FDA: 84795783870.04.061E661
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8A5AF1C000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:45:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ePYEJq2o;
	spf=pass (imf21.hostedemail.com: domain of 3T5YQag0KCBYwx34E306xwBwF2AA270.yA8749GJ-886Hwy6.AD2@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3T5YQag0KCBYwx34E306xwBwF2AA270.yA8749GJ-886Hwy6.AD2@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779471953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZTL5FG6+Kr2BWUUPWPXeiSAcbi1S62N6S7m7CP+BgJA=;
	b=Y5nn7xGaER53pp/R0u/MjdfBP6M2xBmO2OW581iRrsTQ2OCGvFQBeQFYiS5vpcul69o+P3
	nAjCOl+Ys+opCb1oAf+JrTf9q7tM3Zro5TUQSURLzwfcjZ9csHuCic0ZOcIU78bc/xDWV1
	kJ/Bg3ZhUZYyOZmR4tM69FOXTzV6IEs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ePYEJq2o;
	spf=pass (imf21.hostedemail.com: domain of 3T5YQag0KCBYwx34E306xwBwF2AA270.yA8749GJ-886Hwy6.AD2@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3T5YQag0KCBYwx34E306xwBwF2AA270.yA8749GJ-886Hwy6.AD2@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779471953; a=rsa-sha256;
	cv=none;
	b=qDkdEHHI3h8DDH+7bC4ycl49CZNkMduPzgfFbJmCY+am6QRyjc+IzuIvqesI8rIS0V0xcC
	SYC8K/P9iu6pM5U5II1QJBAfqIM7iZ5yrLqdFm2n1tvgo+0+c4lBc5MqTXLzfrzyIYicrk
	4P94W2RZfZQIMD0rEwIUtP1+bpvPV6A=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2f5943ca81aso28034273eec.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 10:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779471952; x=1780076752; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTL5FG6+Kr2BWUUPWPXeiSAcbi1S62N6S7m7CP+BgJA=;
        b=ePYEJq2o9H9ey3qk+IQUR4B2mKxLoC2f1bKqod+xzg4GNzjTTtLk+br2+5oJMd2YSP
         r7xLHeacZmhd/HAZSaWGjA4t7lfd1t1Voi3NkeJK8XggaIUuk8KyppjEBXWaGPW2+8O+
         sbgVCJ3NwUtKxP053dNggpWmS46sSQ1wS0JV5cDuFd9TjyJq+MduHWmROgLElV9zOd39
         maHACzZ/5cOSiqueB4ecYuNYqFZeRUteitTUc1FMIALTJ1TtqmcXesYEYmlOvFNQkDvV
         4d8zeacnQ3gdntKGeJGGICqqw4Uq0Vm2mhI8/3H2asxRCB0yWZNd4HXEXvBNFhtzwG9O
         X0Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779471952; x=1780076752;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTL5FG6+Kr2BWUUPWPXeiSAcbi1S62N6S7m7CP+BgJA=;
        b=s+skuERdHdpz8MFG6adHQShNNDAt3vAMiQnCmlZLUxsS/izIkUdCv8T2jIudQGSFRC
         eAgc2ElngFZvGoJRH2wihLaF36koOux0Nn4AIydMiQxQyHAJzoWOYD+Au09PjR8MoTdz
         6MZ6oBmPWRnYEXah5YzzFQH31eCL2jnwUkB8djPZ1TBdFNCPiVP7NEHSomzCqWufVLuV
         wNywG0NoXTsEPzOKHx/trjrNR1xGT+pSLfnVup9/IQpmwqKTMrx0dGRBrAG+Z0fEDufc
         qhQ5FMI1q4l4HQ02nzPUub+iXh4Ocq6H8oiwbVaD8gKVYYGSJSgEQe/qUzYVkrz7YwhU
         NJzA==
X-Forwarded-Encrypted: i=1; AFNElJ8+v83i3i+xvYJSZO5TQrUJDwW1a4QGVFnR3gDQVlEWFdUtYaYMlvIfNYHQV6TLESnYQPAy4YSkSQ==@kvack.org
X-Gm-Message-State: AOJu0Yy32+yaPGqaPKOPX2D+R7VsckaA7ynACt4F4XXH97tBlYgaURiP
	rvKsQ5KKe4n7XXtFUTGzvmeB/IiC9sYKvaMVWgXWlCJ3gm9mqBx5VKjOZ1rnqm0btRY4RnzcFEB
	H+w7JNgP+PmIq7p8Do/3c8fSLvpB1GFqyug==
X-Received: from dybgh3.prod.google.com ([2002:a05:7301:3:b0:303:521c:29a5])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:1922:b0:2ef:8b91:212 with SMTP id 5a478bee46e88-30449063389mr2564519eec.14.1779471951995;
 Fri, 22 May 2026 10:45:51 -0700 (PDT)
Date: Fri, 22 May 2026 17:45:38 +0000
In-Reply-To: <cover.1779471082.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1779471082.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <fb8b2eff38746510eb415624b5f5846be57a0a26.1779471082.git.abhishekbapat@google.com>
Subject: [PATCH v2 6/6] kselftest: alloc_tag: extend the allocinfo ioctl kselftest
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8A5AF1C000B
X-Stat-Signature: h8cj55g7n53wkbw5dou1bo95ufa8j5ro
X-HE-Tag: 1779471953-14353
X-HE-Meta: U2FsdGVkX19GvIhRTtqWAj7YT+YYhb2UhcWLutyfFBvYO/lCA3ZnVrC3nRGRVXhSzSnFb1P0PTv+aFyzVlegXWgXssHc5CZWbk3Lc8NN+ktE+g27ZYCHYIcZOz+HSAxSgb2+vlIvc1I7gw5x3HwSqyjjoL+a+xIxWETObJc9vE4gD9lAxuCKlckqs1yp9veKrCgUOJY0iGakdtGxvHookZGAzZkLqyyXYEuYV8NzLkdxs5QOMxw34mqTHJpdN+lxFZbOsY+Zi9YQCSSdU0aL/fb7bPHthGjKYOZlbaWZGdamkDW/4mSGYsQhxqj/Dqc6CdHUDDPkZhDOAQBIYINWgVhPbuUcu29VsLMps+oHu3hvtI3/EesJjsvxeFLLRfUuxmOxmMCa+VRcoPLCNWpruBagfp0MT9kSB4ju1teI5mXkKU7LI4HVxs8JOM3cKk0BoyUq/nLUiLqGzWcE+Bk8Uv2XQNtwGn40o5f37OrBKO2MfE4ajWjjzEsyil6ZZLjfkjJtk8omrr7xLNHeaBvg82UctDQpTZp4Nqkjua5i0bdl/dDzOhtPsCBcbLjsM4ELms621UTalkNynAypsZW+EacBtfa3owaoJo/zXa4G0wH6R2WyXxqBfxvIifFpwluLp42IDQkWVL2o4KApuXS8FoD8LIOWg/mnyw9LLS110+bkoTIaIwkYUGBROuSpAAYPEAiKpcBZBFY8mVF8g5XIBkr0w+rpeMUG/wxy8drtjrDjRK0aNKpim8M2WXUrCCy6+zWEhzz2xQGifR91U/HN4XWLfsWjcEehcv/XKZ2YMb1TnZp6+nvVA11rWV2XWhb3rxl+bbW1a4iBIJp8eZuhSEnjUxpBEEtgtCTcitHEGcozXg3dBw3kVtKChT15RvDsCTRelQ2I0Zcb3vwP+aJPYIV/T0FtcZ/ounoN/1/W7xVnMO+cKtn1aQHBYFrkq6ySx+jgifa+Uf9nRJxMEdz
 Bz1LWuYS
 VAE23uHvpH8TjW0N8Z+CcXvH6g+bnF+UnDFc+rScE564nfHcZKfghlcNRj4NoTLFvA2tOZFQ+hxqOOaC9RNYNkhSdH83Oeuo6KVafHkYwgktL2H+vIzm6HdIY+oWfeQ6NhRm03wUyvi9EPmrfzl9GAgUTCwLaO12ZQIVVr0rlsBDIsLlIM1s1kF30/4hwgbUMuMbOnB/xCE4pgsTx2XOiC1w7pz9fr10F6YR56YuAF+OdjGIiW2AKSaV7/qiGS7lxxInV4hignZMc4npxo2vlA5Lw58zTUR9F0c2PJA9ZG+7IgBfpzz2rLl0MYWZblSSAmY/BuBzYZGDlhyHd4pJmsf22MTeBeWvzBVkX2in/VpYiS5uu6ixm4dYAUdVQU+imNPOAzI7AEPM5EM/eO9x/oexyGvEmCSZsOavpBFYi3D8g4q8GxsEvmfhwGUjXwz/acWZ4AXoqKNWQGuwXMpfTxF426Lh7YdK1yfzESxzosUzuv5/1d7xJvUxzWZIqWgXfS3gkXOe/1VQ2kf5HM/v+4SjvohH4orynV5M1Gi5VBOmG5T3osqvUhoxAO1WeyDGeLwE6vhVrSCVCRALkwDg+5j+g/jzDm2PssFdDeCxlPBq/ezi6QSukBxq9hz/wg2MB8sTgBLpCGqOf/n4=
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
index 5c3c16e86c23..ce3576e3cd9b 100644
--- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
+++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
@@ -291,11 +291,191 @@ static int test_function_filter(void)
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
+	filter.min_size = target_size;
+	filter.max_size = target_size;
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
@@ -309,5 +489,17 @@ int main(int argc, char *argv[])
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
2.54.0.746.g67dd491aae-goog


