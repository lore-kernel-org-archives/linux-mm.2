Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC821CA0EE9
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 02:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91E9A6B00AB; Sun, 17 Aug 2025 22:29:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6A16B00AC; Sun, 17 Aug 2025 22:29:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80CF76B00AD; Sun, 17 Aug 2025 22:29:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69B006B00AB
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:29:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 29C701A07F8
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:29:27 +0000 (UTC)
X-FDA: 83788296774.18.6D6B342
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id 55175A0009
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:29:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="B/JGWgPR";
	spf=pass (imf25.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755484165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=e3xlfyKJcyV3WSNhwZBAllw4fH3HPPCNY5TOIpc671E=;
	b=KZQz6+Rmx5h2JJglXmqSm9PhjAaLg0b7QfGIcGcTLK3UEtyKSO6wMfVJeCM4eZOTiUY+NY
	PdjFLos4aKO1YtdlDUF3Afujr1d3n8Okmd6sU4T10oXtns+ChpmmJvHSMKaITyorduN8bF
	oUDaA/rVs47nszq3dbjvVggLpNksis0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="B/JGWgPR";
	spf=pass (imf25.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755484165; a=rsa-sha256;
	cv=none;
	b=Hgzq1MP2NAKpeS1kEa/VC0CCz86W7Zy63X32na7WXLkOFQn1BumeFsRDV47mvJ5tTuAe2b
	ajqC6ymNdgknMnTL9B9yiN/Y9GqwVaPUwg/Bc4dCEjjY4aKeqDTnBxG4T9olYqzRd7FXtC
	8sWdbwaK27Y3CKVLWuvpPdET6Xv9Des=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-61a1c6a5338so1129581a12.1
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 19:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755484164; x=1756088964; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e3xlfyKJcyV3WSNhwZBAllw4fH3HPPCNY5TOIpc671E=;
        b=B/JGWgPRx+YW3LcUsqSdzGGGzI2N7P8zz7IH/1KEOsfVDiqDVqSiBrEKSQfeF5VTDF
         Y42iC2s82S//WGV/aiGyNq+ZeT7zASC4zNSYZoq4ppIpPJFRlLOhfD32uH3JgsbnnZS2
         IM60LuoeZ/QSd/RscsbYwMYEMJqmiN1qxYFz4Oa2A/Dkp/BsBSN9ajAsveY0kDwoxae3
         WXkYek+9RDXp7ZqTZelL0kCStivg1+PKQm8/N9xWHGT3Ie7f6NeCQwTQCnB/HJTtM7pF
         J9NPGEP1ieEvK02M6FaA2TnJRWod+9uHKDcEIcjLyDzh/mwsAu7DcNuixKtA376MREi5
         uH6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755484164; x=1756088964;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e3xlfyKJcyV3WSNhwZBAllw4fH3HPPCNY5TOIpc671E=;
        b=w1sBqP7X4qTt5huNS0763TlSTD/3dNLrsUqwA2gowT5d19AzZpkTWBgpldfRv+piQN
         tNLVgFgHgKVrIfCnjSjjavVazNks7gpnzPU7GrlaJ4Hfr5YjgqXq0nlnIBj2WMJBUBdV
         a1jK+2cqVdz/J2PU64jyTjeq90y2NeMb8zBUNiEMBRN/njkjsxRFj/sf0eSEJXs6GlmF
         BioN8sKoFk9tQjkUzM3vbxUP/8mo9Fbu5dMGArZKF1hXPCHa5EEqHFAZov5XAO16lAeB
         aj+zcoBhlSNzJUkTPoBWdww7jrFEAzWOeITaLBSWzlO10rOmKij2KsX9eQmshluUBFTl
         vsWw==
X-Gm-Message-State: AOJu0Yx6pDh07Uvuax/2T2t1n4peVhj+X15ynZOQ3MQmuXvjVJzV3sUO
	90OFRp/hkSgNq0NKyUexyCTt12XQ26+BynBGEO0EvNReiMY8Ux8YTHqVIxcohNr0
X-Gm-Gg: ASbGncuLmBtcWivWEh6xgNx4gBLL64R+EmVHXioqJ+tgPt9tKYJ0rB0xabGrGdjfN51
	NOin9tZrNNM/FJsfLSHJQ7HZYebn9dh7Y9SMEY4jdvADk7VXylESon4bE4p+UjEa0lR4XT8MsB9
	LrtTtJqNtQWWxJu7E1Im3H2xJXKuVwFihyjbzrdGHn4D+DHwQqVZFRVdETcrlkzwsNJTC/kHcsU
	uusgPWdlj1qnNW5ngznfJz2i9t2wkKLwL7idNIV7BtA1X8LmQK64HgEA1bAN9c4NrLfMVpXlZnS
	3MqUCMQUfB40XTeFKgcyAUhaa5CFDgSc5gV145azFlHjOAulcmRu7gTlW4P/hWZiS495il0drMf
	DGuIBp8lIG0uccV8o4b+Aog==
X-Google-Smtp-Source: AGHT+IHyKwpVMlbsT8+N13YDxkeY56zYwPHjJgQXAA7mQ3KzOeipYWnXqSGupzP6puuOzTSU/7seQg==
X-Received: by 2002:a05:6402:3508:b0:615:5dbd:ccba with SMTP id 4fb4d7f45d1cf-618b051714bmr8374038a12.11.1755484163628;
        Sun, 17 Aug 2025 19:29:23 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-618b01ae5casm6347486a12.36.2025.08.17.19.29.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 17 Aug 2025 19:29:22 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	riel@surriel.com,
	harry.yoo@oracle.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v3 1/2] selftests/mm: put general ksm operation into vm_util
Date: Mon, 18 Aug 2025 02:29:04 +0000
Message-Id: <20250818022905.15428-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250818022905.15428-1-richard.weiyang@gmail.com>
References: <20250818022905.15428-1-richard.weiyang@gmail.com>
X-Stat-Signature: p9ukyw9ksq8r6e4nurop3mf6gcpnwkwa
X-Rspam-User: 
X-Rspamd-Queue-Id: 55175A0009
X-Rspamd-Server: rspam05
X-HE-Tag: 1755484165-769027
X-HE-Meta: U2FsdGVkX1+n5zU7sLq0g5CLZOhWnekvk7xzUkFGeak53e47TgarvytU7DwXw4u3lzJ8+reIG5wx5XVYrGKqWLiBj6kv2ZWy2N65OW7iU7hmrgyzHk1Nez0WNEjDtff0w4JvPkfmcKCmX9BK++VkfDM+LCDDf058UAbQYuAFdBiBhDctJgTumnMI8kKomq1jdtrSaU/PWN1CFIGxeriIfxps0iDBxGlB5ZoY+dutJnEnVYlUfj4KyVh5SxwVVX/TpMkHcUzbEcbUAs7rNqAgKxs413n7xa2nw+CHydLsjs2LlZJ1qGYWYaHHUK1CxQEw2Lky0/Ip3GruZRv9uKX0eMFu32eA1P77+CRcK8DfMHHwYTVzxbXcJXD2LtrQ8OEf5QfaPMIHEaCPga9cvJJPbKruYAReO6A1Fk4B01K3z6GamXBSmXi9izfOJ5Z7R45426kfxv5kSKUxJKsTDGCf4Fw8qiBo42cqyK1/tGXtZzMo5ZWxy2B7gfIFzlsKLMJRIHtSyFbHaBS/D6Igv1gk5ttaFWzQbvn1VaquuTUyG+EOtmBtPfg7fA7HTcw5EHfZ8HJUtbRVrXv7Ukd0zd5U6Ys3Wr7Ibsz5YwqUyl9GS4siHI/979iGc+6WqjmKhLGtOfXV6yfWbxcNFzGVuUIQhYsK/ToRcgNvjzFZcrG328xcsxYecrRupcSPjri0qaiFLA4FBBVjDqkoWGaDnaGrqACo0ACO9wptBqxUb1bxGWSYEluV39DeCWHEOrC2nOF/Ph7oEnYIr4lUMxwGNNQcMBplSTrfJ0yVF9NW2q74C8bTN//PmvYc1rirRNbfJb3W3ipdg+WCtBGJfiKfpcfwImAUaSc9GDlSwosLxV9WB76XvmjvhKxT+hfP36IKwpvcbSvHB82d5L6DH8K36RNp7ZSdLGI1/pHt4B25ECZCkU92IqIXVzYg/fXB5KnGa6vx46O+7q/1xgDcT/rYxnz
 8xmf9v2b
 W4Zu0vZO3PrRdbI1zNyLmegWwH5OI0DWTsvF8epzavivXgCAOv7a0PbMVdQT+PKCNL7VgGCvhMgx8DxbDbpd09gWmrKANxddZyDJXHtq57uMoAD8YOdJn+aUzITIjk2jHvxL4FWNntuRQI1nvu7BaVVchhj3nDEpy+EnJ+cxDO7t8GBFogLUaVs7NZGsrqO6wRrXOuU5d7fs3t1wsi8EIndhmxBXUYQbUWaPAN7LgAsVwgtPj7lJHj+EJ/JZw8Z6HvE/xBtPAz/SsAOvtUrjstKC7F36WkWoCdcM0j4JIKEFEz8+47f4OnRiBunhFVbgP5SvN8okFBAE+YJ/9Oz7Rowi56riBOcRYXErjRV5U0SPGPjPY4EkFvSLmoPLdNvEcqSlOFjcE4j4h8qjhjb6AGIoyvy2mdyHBeZ9Jm2yIImDGHuZUqA4nrsd8QqqpU7p6IAVIT648S02t5xKo/ecJ4z6Nm+ii5hDckWmuTUUZnVdhkJx8sNpRFXci+sE1/x2mvgYpgr/7rRON2K2caOKY8elg6XID1rzS3s/keoMQyLPEozUVen3Jw7p4XFXdHaIpMBCF0uFNv3TpfElWhlD7GEloj/bfPuQTu3nEbVXzOcZdx0XlgHdykzo0jrNnrfLxC65mzU/7ukKcKqi4rEg9uXaagyjuWdb9LiXNHKnRjm5Bj3w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are some general ksm operations could be used by other related
test cases. Put them into vm_util for common use.

This is a preparation patch for later use.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>

---
v3:
  * rebase on latest mm-unstable
v2:
  * do check on file opening in init_global_file_handlers()
  * factor out ksm_merge() and ksm_unmerge() instead of partial of it
  * align the return value of helpers: 0 on success, -errno on error
v1: open/close fd in function itself instead of pass as parameter
---
 .../selftests/mm/ksm_functional_tests.c       | 134 +++---------------
 tools/testing/selftests/mm/vm_util.c          | 123 ++++++++++++++++
 tools/testing/selftests/mm/vm_util.h          |   7 +
 3 files changed, 153 insertions(+), 111 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index d8bd1911dfc0..c9d72daa3138 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -38,11 +38,6 @@ enum ksm_merge_mode {
 };
 
 static int mem_fd;
-static int ksm_fd;
-static int ksm_full_scans_fd;
-static int proc_self_ksm_stat_fd;
-static int proc_self_ksm_merging_pages_fd;
-static int ksm_use_zero_pages_fd;
 static int pagemap_fd;
 static size_t pagesize;
 
@@ -73,88 +68,6 @@ static bool range_maps_duplicates(char *addr, unsigned long size)
 	return false;
 }
 
-static long get_my_ksm_zero_pages(void)
-{
-	char buf[200];
-	char *substr_ksm_zero;
-	size_t value_pos;
-	ssize_t read_size;
-	unsigned long my_ksm_zero_pages;
-
-	if (!proc_self_ksm_stat_fd)
-		return 0;
-
-	read_size = pread(proc_self_ksm_stat_fd, buf, sizeof(buf) - 1, 0);
-	if (read_size < 0)
-		return -errno;
-
-	buf[read_size] = 0;
-
-	substr_ksm_zero = strstr(buf, "ksm_zero_pages");
-	if (!substr_ksm_zero)
-		return 0;
-
-	value_pos = strcspn(substr_ksm_zero, "0123456789");
-	my_ksm_zero_pages = strtol(substr_ksm_zero + value_pos, NULL, 10);
-
-	return my_ksm_zero_pages;
-}
-
-static long get_my_merging_pages(void)
-{
-	char buf[10];
-	ssize_t ret;
-
-	if (proc_self_ksm_merging_pages_fd < 0)
-		return proc_self_ksm_merging_pages_fd;
-
-	ret = pread(proc_self_ksm_merging_pages_fd, buf, sizeof(buf) - 1, 0);
-	if (ret <= 0)
-		return -errno;
-	buf[ret] = 0;
-
-	return strtol(buf, NULL, 10);
-}
-
-static long ksm_get_full_scans(void)
-{
-	char buf[10];
-	ssize_t ret;
-
-	ret = pread(ksm_full_scans_fd, buf, sizeof(buf) - 1, 0);
-	if (ret <= 0)
-		return -errno;
-	buf[ret] = 0;
-
-	return strtol(buf, NULL, 10);
-}
-
-static int ksm_merge(void)
-{
-	long start_scans, end_scans;
-
-	/* Wait for two full scans such that any possible merging happened. */
-	start_scans = ksm_get_full_scans();
-	if (start_scans < 0)
-		return start_scans;
-	if (write(ksm_fd, "1", 1) != 1)
-		return -errno;
-	do {
-		end_scans = ksm_get_full_scans();
-		if (end_scans < 0)
-			return end_scans;
-	} while (end_scans < start_scans + 2);
-
-	return 0;
-}
-
-static int ksm_unmerge(void)
-{
-	if (write(ksm_fd, "2", 1) != 1)
-		return -errno;
-	return 0;
-}
-
 static char *__mmap_and_merge_range(char val, unsigned long size, int prot,
 				  enum ksm_merge_mode mode)
 {
@@ -163,12 +76,12 @@ static char *__mmap_and_merge_range(char val, unsigned long size, int prot,
 	int ret;
 
 	/* Stabilize accounting by disabling KSM completely. */
-	if (ksm_unmerge()) {
+	if (ksm_stop() < 0) {
 		ksft_print_msg("Disabling (unmerging) KSM failed\n");
 		return err_map;
 	}
 
-	if (get_my_merging_pages() > 0) {
+	if (ksm_get_self_merging_pages() > 0) {
 		ksft_print_msg("Still pages merged\n");
 		return err_map;
 	}
@@ -218,7 +131,7 @@ static char *__mmap_and_merge_range(char val, unsigned long size, int prot,
 	}
 
 	/* Run KSM to trigger merging and wait. */
-	if (ksm_merge()) {
+	if (ksm_start() < 0) {
 		ksft_print_msg("Running KSM failed\n");
 		goto unmap;
 	}
@@ -227,7 +140,7 @@ static char *__mmap_and_merge_range(char val, unsigned long size, int prot,
 	 * Check if anything was merged at all. Ignore the zero page that is
 	 * accounted differently (depending on kernel support).
 	 */
-	if (val && !get_my_merging_pages()) {
+	if (val && !ksm_get_self_merging_pages()) {
 		ksft_print_msg("No pages got merged\n");
 		goto unmap;
 	}
@@ -274,6 +187,7 @@ static void test_unmerge(void)
 	ksft_test_result(!range_maps_duplicates(map, size),
 			 "Pages were unmerged\n");
 unmap:
+	ksm_stop();
 	munmap(map, size);
 }
 
@@ -286,15 +200,12 @@ static void test_unmerge_zero_pages(void)
 
 	ksft_print_msg("[RUN] %s\n", __func__);
 
-	if (proc_self_ksm_stat_fd < 0) {
-		ksft_test_result_skip("open(\"/proc/self/ksm_stat\") failed\n");
-		return;
-	}
-	if (ksm_use_zero_pages_fd < 0) {
-		ksft_test_result_skip("open \"/sys/kernel/mm/ksm/use_zero_pages\" failed\n");
+	if (ksm_get_self_zero_pages() < 0) {
+		ksft_test_result_skip("accessing \"/proc/self/ksm_stat\" failed\n");
 		return;
 	}
-	if (write(ksm_use_zero_pages_fd, "1", 1) != 1) {
+
+	if (ksm_use_zero_pages() < 0) {
 		ksft_test_result_skip("write \"/sys/kernel/mm/ksm/use_zero_pages\" failed\n");
 		return;
 	}
@@ -306,7 +217,7 @@ static void test_unmerge_zero_pages(void)
 
 	/* Check if ksm_zero_pages is updated correctly after KSM merging */
 	pages_expected = size / pagesize;
-	if (pages_expected != get_my_ksm_zero_pages()) {
+	if (pages_expected != ksm_get_self_zero_pages()) {
 		ksft_test_result_fail("'ksm_zero_pages' updated after merging\n");
 		goto unmap;
 	}
@@ -319,7 +230,7 @@ static void test_unmerge_zero_pages(void)
 
 	/* Check if ksm_zero_pages is updated correctly after unmerging */
 	pages_expected /= 2;
-	if (pages_expected != get_my_ksm_zero_pages()) {
+	if (pages_expected != ksm_get_self_zero_pages()) {
 		ksft_test_result_fail("'ksm_zero_pages' updated after unmerging\n");
 		goto unmap;
 	}
@@ -329,7 +240,7 @@ static void test_unmerge_zero_pages(void)
 		*((unsigned int *)&map[offs]) = offs;
 
 	/* Now we should have no zeropages remaining. */
-	if (get_my_ksm_zero_pages()) {
+	if (ksm_get_self_zero_pages()) {
 		ksft_test_result_fail("'ksm_zero_pages' updated after write fault\n");
 		goto unmap;
 	}
@@ -338,6 +249,7 @@ static void test_unmerge_zero_pages(void)
 	ksft_test_result(!range_maps_duplicates(map, size),
 			"KSM zero pages were unmerged\n");
 unmap:
+	ksm_stop();
 	munmap(map, size);
 }
 
@@ -366,6 +278,7 @@ static void test_unmerge_discarded(void)
 	ksft_test_result(!range_maps_duplicates(map, size),
 			 "Pages were unmerged\n");
 unmap:
+	ksm_stop();
 	munmap(map, size);
 }
 
@@ -452,6 +365,7 @@ static void test_unmerge_uffd_wp(void)
 close_uffd:
 	close(uffd);
 unmap:
+	ksm_stop();
 	munmap(map, size);
 }
 #endif
@@ -515,6 +429,7 @@ static int test_child_ksm(void)
 	else if (map == MAP_MERGE_SKIP)
 		return -3;
 
+	ksm_stop();
 	munmap(map, size);
 	return 0;
 }
@@ -644,6 +559,7 @@ static void test_prctl_unmerge(void)
 	ksft_test_result(!range_maps_duplicates(map, size),
 			 "Pages were unmerged\n");
 unmap:
+	ksm_stop();
 	munmap(map, size);
 }
 
@@ -685,19 +601,15 @@ static void init_global_file_handles(void)
 	mem_fd = open("/proc/self/mem", O_RDWR);
 	if (mem_fd < 0)
 		ksft_exit_fail_msg("opening /proc/self/mem failed\n");
-	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
-	if (ksm_fd < 0)
-		ksft_exit_skip("open(\"/sys/kernel/mm/ksm/run\") failed\n");
-	ksm_full_scans_fd = open("/sys/kernel/mm/ksm/full_scans", O_RDONLY);
-	if (ksm_full_scans_fd < 0)
-		ksft_exit_skip("open(\"/sys/kernel/mm/ksm/full_scans\") failed\n");
+	if (ksm_stop() < 0)
+		ksft_exit_skip("accessing \"/sys/kernel/mm/ksm/run\") failed\n");
+	if (ksm_get_full_scans() < 0)
+		ksft_exit_skip("accessing \"/sys/kernel/mm/ksm/full_scans\") failed\n");
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_skip("open(\"/proc/self/pagemap\") failed\n");
-	proc_self_ksm_stat_fd = open("/proc/self/ksm_stat", O_RDONLY);
-	proc_self_ksm_merging_pages_fd = open("/proc/self/ksm_merging_pages",
-						O_RDONLY);
-	ksm_use_zero_pages_fd = open("/sys/kernel/mm/ksm/use_zero_pages", O_RDWR);
+	if (ksm_get_self_merging_pages() < 0)
+		ksft_exit_skip("accessing \"/proc/self/ksm_merging_pages\") failed\n");
 }
 
 int main(int argc, char **argv)
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 6a239aa413e2..ab7271ed5ff3 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -565,3 +565,126 @@ bool detect_huge_zeropage(void)
 	close(fd);
 	return enabled;
 }
+
+long ksm_get_self_zero_pages(void)
+{
+	int proc_self_ksm_stat_fd;
+	char buf[200];
+	char *substr_ksm_zero;
+	size_t value_pos;
+	ssize_t read_size;
+
+	proc_self_ksm_stat_fd = open("/proc/self/ksm_stat", O_RDONLY);
+	if (proc_self_ksm_stat_fd < 0)
+		return -errno;
+
+	read_size = pread(proc_self_ksm_stat_fd, buf, sizeof(buf) - 1, 0);
+	close(proc_self_ksm_stat_fd);
+	if (read_size < 0)
+		return -errno;
+
+	buf[read_size] = 0;
+
+	substr_ksm_zero = strstr(buf, "ksm_zero_pages");
+	if (!substr_ksm_zero)
+		return 0;
+
+	value_pos = strcspn(substr_ksm_zero, "0123456789");
+	return strtol(substr_ksm_zero + value_pos, NULL, 10);
+}
+
+long ksm_get_self_merging_pages(void)
+{
+	int proc_self_ksm_merging_pages_fd;
+	char buf[10];
+	ssize_t ret;
+
+	proc_self_ksm_merging_pages_fd = open("/proc/self/ksm_merging_pages",
+						O_RDONLY);
+	if (proc_self_ksm_merging_pages_fd < 0)
+		return -errno;
+
+	ret = pread(proc_self_ksm_merging_pages_fd, buf, sizeof(buf) - 1, 0);
+	close(proc_self_ksm_merging_pages_fd);
+	if (ret <= 0)
+		return -errno;
+	buf[ret] = 0;
+
+	return strtol(buf, NULL, 10);
+}
+
+long ksm_get_full_scans(void)
+{
+	int ksm_full_scans_fd;
+	char buf[10];
+	ssize_t ret;
+
+	ksm_full_scans_fd = open("/sys/kernel/mm/ksm/full_scans", O_RDONLY);
+	if (ksm_full_scans_fd < 0)
+		return -errno;
+
+	ret = pread(ksm_full_scans_fd, buf, sizeof(buf) - 1, 0);
+	close(ksm_full_scans_fd);
+	if (ret <= 0)
+		return -errno;
+	buf[ret] = 0;
+
+	return strtol(buf, NULL, 10);
+}
+
+int ksm_use_zero_pages(void)
+{
+	int ksm_use_zero_pages_fd;
+	ssize_t ret;
+
+	ksm_use_zero_pages_fd = open("/sys/kernel/mm/ksm/use_zero_pages", O_RDWR);
+	if (ksm_use_zero_pages_fd < 0)
+		return -errno;
+
+	ret = write(ksm_use_zero_pages_fd, "1", 1);
+	close(ksm_use_zero_pages_fd);
+	return ret == 1 ? 0 : -errno;
+}
+
+int ksm_start(void)
+{
+	int ksm_fd;
+	ssize_t ret;
+	long start_scans, end_scans;
+
+	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
+	if (ksm_fd < 0)
+		return -errno;
+
+	/* Wait for two full scans such that any possible merging happened. */
+	start_scans = ksm_get_full_scans();
+	if (start_scans < 0) {
+		close(ksm_fd);
+		return start_scans;
+	}
+	ret = write(ksm_fd, "1", 1);
+	close(ksm_fd);
+	if (ret != 1)
+		return -errno;
+	do {
+		end_scans = ksm_get_full_scans();
+		if (end_scans < 0)
+			return end_scans;
+	} while (end_scans < start_scans + 2);
+
+	return 0;
+}
+
+int ksm_stop(void)
+{
+	int ksm_fd;
+	ssize_t ret;
+
+	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
+	if (ksm_fd < 0)
+		return -errno;
+
+	ret = write(ksm_fd, "2", 1);
+	close(ksm_fd);
+	return ret == 1 ? 0 : -errno;
+}
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 1843ad48d32b..ba4d9fa44a7d 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -130,6 +130,13 @@ static inline void log_test_result(int result)
 void *sys_mremap(void *old_address, unsigned long old_size,
 		 unsigned long new_size, int flags, void *new_address);
 
+long ksm_get_self_zero_pages(void);
+long ksm_get_self_merging_pages(void);
+long ksm_get_full_scans(void);
+int ksm_use_zero_pages(void);
+int ksm_start(void);
+int ksm_stop(void);
+
 /*
  * On ppc64 this will only work with radix 2M hugepage size
  */
-- 
2.34.1


