Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAD10CD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 23:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DD6D6B0096; Fri,  5 Jun 2026 19:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 469116B0098; Fri,  5 Jun 2026 19:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26CE96B0099; Fri,  5 Jun 2026 19:37:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0DFDF6B0096
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 19:37:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7BA9A0344
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:37:03 +0000 (UTC)
X-FDA: 84847471926.05.E92547F
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf11.hostedemail.com (Postfix) with ESMTP id DE5A340008
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:37:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DOf1pwLb;
	spf=pass (imf11.hostedemail.com: domain of 3nF0jag0KCD0ZaghrgdjaZoZsfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3nF0jag0KCD0ZaghrgdjaZoZsfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780702622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4NFxVZN6hRoyN4q6+cvZk4sgGHzCYBtGGyUkSu34A8=;
	b=AXCfQxiToNhxxzkKBIyg86OZahyQ2vWbB2Hn/7pRv1DV9s61lCiRsa7PD2W3/FaMNme8iP
	hHrUl5sEwCtDAdIWehUWBLFwjI4+0HB0KgFBWhxMhy3TT9x/1lBGmM+HiAMhyIsuC+kh/+
	HJ5W930D5nVWiQ2zsAZC1+30Glu4Fug=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780702622;
	b=NN1r3qir11AI9fAzNVnP98XvDZx+Vka/Ux2nehpLR6W1Vji80FUmku/pg7krkbrohPr9AQ
	gN1Y1EHQKrWkUrWudPw6efP3XYZJuNDEoiFvIV9TDtgTpYl6zH/6vOGQ450v8pkNM5yKhK
	m3NGDGIlsTZTJrJorflBPvHEqlP0S6w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DOf1pwLb;
	spf=pass (imf11.hostedemail.com: domain of 3nF0jag0KCD0ZaghrgdjaZoZsfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3nF0jag0KCD0ZaghrgdjaZoZsfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-3074797dfa9so3480553eec.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 16:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780702621; x=1781307421; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v4NFxVZN6hRoyN4q6+cvZk4sgGHzCYBtGGyUkSu34A8=;
        b=DOf1pwLboLCFQzRhgYlW8uIqv1NVy71z5khESWo82rDRB24+Zr0kk+u4zZqbx4WMWx
         bcj7pVTDEX5LRSSjKdm0exjFuLoAgmJg9V2sn41Qf13eKG1JfEqcl7TyDGUV3Uc5uLC0
         l9ONHpQ+V2AxNNhEFbxQCAyqHsZavqG/2llfzIy34vHnSfFRwMz3KyTlv+7NykpNPLvz
         mneGfoMZmVDDkCgzqrhjZZVsAL3Bqmad+4JbebOPkl87SbGlejqlMbxjImgfs0Xeiijr
         bCWGFPjsh62s2s84wTf9aCtIhSvI4MLRlpewn8slBxK9CbFimn6hy3TxjaBNqEeM5IKM
         zIoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780702621; x=1781307421;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v4NFxVZN6hRoyN4q6+cvZk4sgGHzCYBtGGyUkSu34A8=;
        b=d917+HP04O4uL7GAZb/z7ydYNn/xfwTqLqkzp2z/E3ltkqDxYel0nqMzVSEKSduML1
         mHrU0WcTmH9Y75JYFGGAxlYxnjjGj49myG/4zCETbC/QRf7lgEuou2XymKCd5NO7y6ht
         vP0sa4DtNaawx7c6fdeN0pyrvb7eBK7iXCJ/FImCrNqyXkqNIrL947Vz+xg0GbZLd2s7
         ORA/CbWvsBYw09OjnGu8sl678oRX7UwKM3HNE5FM17aCCsMyj3Tuwiavf70JD0VJzLjo
         9lbXF3rKGBcoCB8sdroENa1P8J7wsuwr+PFcdKQwfx/r70UVcmnl3AT+ZAvA1S7L0SW5
         V8Og==
X-Forwarded-Encrypted: i=1; AFNElJ/FuzHW71WDoZUsmb7Wjxn2bRdpm5nMxdGoukwTJt7xsYls+5KGKIiRsiRsgdYbtBC0I5TnFAb9Rw==@kvack.org
X-Gm-Message-State: AOJu0YwUvf0ZhBZYj3AnWJiClPHYIiLShvtlBXGCQbbdi1HQm9cKNz0t
	ny3AIMvRfMA8+r7uGU5Q/glchdKhp+Rg13LrqQhgr3bpScqrxjuzcCeVyWJ1JhzAKGnV2M1HMy2
	jAmGC15ODKlt/BxGG35zyKTvRYoZnd4JCiw==
X-Received: from dyvt1.prod.google.com ([2002:a05:7301:d801:b0:304:d771:74aa])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:4347:b0:304:d388:c33e with SMTP id 5a478bee46e88-3077ae8681cmr3200526eec.1.1780702620573;
 Fri, 05 Jun 2026 16:37:00 -0700 (PDT)
Date: Fri,  5 Jun 2026 23:36:51 +0000
In-Reply-To: <cover.1780701922.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1780701922.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <c78c82e490c0effb7e013e18de3e0519cec0e9a6.1780701922.git.abhishekbapat@google.com>
Subject: [PATCH v3 6/6] kselftest: alloc_tag: extend the allocinfo ioctl kselftest
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DE5A340008
X-Stat-Signature: sbkjkw1f4ikfr3p9opormo83uj9ec9y4
X-HE-Tag: 1780702621-484780
X-HE-Meta: U2FsdGVkX1/iipH/aXsppM5Gn7vgaDOQ3NI+F/6mNAKpxQEEndwfKsEkLx4e5le/uM78/m66sReAiS0sLElgu/g4+abmOIAQdySW5PElHSG7OTp1Ipqz1oQEThTljNfIllbR6HAKuQNOMMzv2seEiG+jEvpZE74rj74FgnyarU0NRzu5AHuwlLAsdkCbRHsjgdCwQ3FcJA/+oMSY0WoQ6orKNOrmiZeWzwBmh0vWqwuT4RMDp1b3zSqheJnbvNW2CqFNpBy2Z0wWt+pPH2+bp3SF9xemP5lICFvRpaxYyS9Ai6+1HwgVKZCQfbBgwKoLjgq+DWygiGbL31LwkzUi7tduOdNCxQM8yzN0C3kn6tWUUlizfNISpi/JcR1Rah8Av6JcUefIJs3Drv2uT+QM8KnRPX943MYevgxcUwuKvOaLIuSukrMYRW4sDAbRmkztMn2NFEkrZ0v1J8GN6Lf2iuWmuSic3HOAWooR2lzqx6EaJ+UYZzfJNP/SXmN0Rnm+xoClO2BMfKgeShQtWU2HIu3O+i1vHMpTFywg6ikRcKDQ9f/yFyEBMLNSqcfwyMBWbxDYViE7IQpilIdCg9VFEhuUGucu6aLVBnFStEqwsANYb7mt+NqoQY3j9kQRCmf8Hg30mYeNCXrwGGiRHXbnxa4lYnqOgNK05KFszr9Do4ZywJsSvhENJB6BFdsc4YtpDRhQKYpuwq9B3DmF8cCIpkP7Vrkt/Cbqzk1ZueJK9Dc6Vj1Sy0orrx9Mf6/zvan3C70dSFkiqqQPijQxS4RNU1GmFOTFXr059Ki4OuXBnQ7067AfW/ZFraeHVQttv8MV6aKpERZolEz+gXGwlxR2tWvQjCuxJCweUDEgQl160rFgzvgMh4X9OaInu9jGXqqZUB4iy+INrsZDUvuvTjdHUmEBXaq+PAZO9cNX4siMP+lII64mceKQtztAXqClkpFJkWoNeMGNjAkSuHQE5AE
 gzdjhfFF
 faB9n5C13+cKSkPqoN46iDNT7we/lH7PeScqx8XtI1Gt/7D/ErBepwaiK9ISbjWOTaZBt3W+nCCUJrjWOPRLin1fK+gqCSU5iD6u5eMCTBI06tVxFGbh/mpX52n6hKLLaDQfNxRv9IImNSxLabndz2UAAaQusyrCnGYqMxUq6K0Z5CR93OcrzoeFHxCpFdBR7KuuPItJf6DbFs4cEDGBylSZcEVYJRnUH8j75/uT3O7u4tKYWv6bZ3s7T7JlMrhhcTNMMUjmGItOY4cb0tMWPw+f3F7ypHQq/XlyFItQhyXzYiRFbkusyFNJENKTf0JcWVpbkAFUahL9ReUStAf+ZjsDYv7TFQnnJCAR2ALbGqPt90sWzhYGp1sXm6aa8KOpMGFWNs+MeaaKeUiQB03n+aqFBMz5ly3K0x0ele+RdD8OqPz4xwLa2Aarhd6uAmXjgG5FgnIiCvmVhoSiwDsIodIXvDRCWQZ/CGxfQv68jekrAp6dZH24NI0TgIyh55F72EVFF9Us6gW/+oItRkYf3P2UvW0BWvDhbjv+eLitLvq8GsPahE70Gl4t8PO58Yrb5jPbsLta2N+uQg0OqxCLjfiKz58MAcbLbBpPZk16kr2ZAiAwkAhW88jEFC2YhTLgkCe9vVghfFipUzvo=
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
2.54.0.1032.g2f8565e1d1-goog


