Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE90AF99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 412876B0266; Sat, 18 Apr 2026 06:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C1EF6B026A; Sat, 18 Apr 2026 06:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B14F6B026B; Sat, 18 Apr 2026 06:58:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 127446B0266
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:58:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D0D188BA04
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:58:30 +0000 (UTC)
X-FDA: 84671377980.30.4BF1896
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4D7EF120005
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:58:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CTHaf11z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509909; a=rsa-sha256;
	cv=none;
	b=f/E0+5AWnRpC+udGv0IUIeGUP38Lhtyf9AmcFCLbJYWEqv1jzm068MFXZqOvxPXVWDztah
	wLUXrqEgBQEOk/gOmrYqXODmxz5lkiN6ZD9GVUmWI4FM6+TJih534FC0u0aPaYKUQbvQ2C
	MdC/5k+km2Hodt/N9u8EjgSVPwTmdjg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CTHaf11z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/NswGzSzBSeD5r4b0rMvjx+30uVeeIp+Did4GPLPTuM=;
	b=6oNkCawa6XVr8Wwes5Vgdxl/Z7vwKrxacz4gw4vrq1l+2y+ai+sHuw87M8ye3910r5l38s
	9C0rwgBP1jdn4LvJnVLCdaM2ZpiSV96Nftkm1P6D/OQqbU7ZaYkNFl3YfIBg7V227D4u7w
	/+S331i6qsT5S2dpCa/DWFkdauWqmA8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D54E86013B;
	Sat, 18 Apr 2026 10:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E470AC2BCB3;
	Sat, 18 Apr 2026 10:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509908;
	bh=uOk/wAXtSYozRkV6PC7dCLvIk2f3cksuzUZUEbVUqsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTHaf11zYz9E7Jx6vTiinE/A+ebxJHoPOu4Soxf95CGagZWPACKWhkb54hLJwDv+B
	 acDcpd4ZqTc/KYlLOFB2hqB3xFtF0XYtd3P4MQGAgl/GH78E7tGtMbWPZge14q50k5
	 8WmPVIU8y30NWMs8pTLui34BQ0VTTk6qk8Q1a+Il1cxbVe36cCe+7qhecvl6SnDvZQ
	 rMy+GdHsoeWjJl9/KF4DQ1Rppjhb/IIpN1aXyc8qsonI7M5xIRI1RO2kwqV88aKpHW
	 Nl+jxvJi9gSd8SrIgEyjE6k4wpZD91dOq5b1sUwKmyVDDHFW40QSLJHZC8M5r3WEKt
	 QwJ3eVhrZa/ow==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 26/53] selftests/mm: hugepage_settings: add APIs for HugeTLB setup and teardown
Date: Sat, 18 Apr 2026 13:55:11 +0300
Message-ID: <20260418105539.1261536-27-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4D7EF120005
X-Rspamd-Server: rspam12
X-Stat-Signature: 7e63y64m6cpx3mcxyo37e6p59tsdapwa
X-Rspam-User: 
X-HE-Tag: 1776509909-151084
X-HE-Meta: U2FsdGVkX1/+chKgm0vE7z8L7bzzQnc/DxBQPCySIdNsGPDzQgHEQitCOKb9AFYu8Qq7P2g9JMMe4tWfVP+NB4fvKmr4boj90DmZKpbOVQsXmekQR2XJ1mtekncMn1Jrs5SHtoFUuiGxmMtECN/TT7GssTy6a0p8bJ/p+/AQt9vUtkTBtpEc07d56hbOzzyCNNse3QJHNdQ8aUaPFHxfnmzkrqETnpuarmAnQq2mKtEghhD75DZ4kyb+d+P9MYd4tvot1scQdKwuFwsuC5nVoKoodhaTP6rhHlfwF772c9RwA3akjt/4+q820YqM86y3pLJx3sW92IoM8uWhrzVLtbX2VUqz2pl/s0fBzmt3uclcD1kjSt0ueBFMOSN+k1fy7mibxLb7nR6EUFkPyWlMnpzmeojDF4xoJWZl6zAnH1YpG+EmVUUd4lrHWwZcl2nxYUmmMEheQix0V0520fzHJMPogsMqYOc24ofMjIu7U5DsiVUY90kg47X4E1CBv+SbTlxR3EhmJoH4zUV2DCuZ0qRkvrjk8ure1H0mbjkyr2lCLJ6dD+382EAWTw4ZSZb5BtAh3jmoiKQVu+3fIIfXOtxqSE0WP+mBhMFvI/tYKzVK4jEwc3QGuLpMFLwtiQ7+JaHUDV8yIn3m0wqfnml2D/1DqdJJ4/UzHFGu++05LrFuxKe8fx/s+SGshHlQd4yfo2QTC3bMUGBPy7RFIq1jFnWE84/IOAAzAS+2lhWYOZSFDc/SoQqA3g1zcjoD9NdQHjetrIoPZ02EgM7jLnd8f+tWTyDGOEQeouU6KvZGcAeIVYKi6J7klMg+0TSau9yhMmoKF60BX1BpWBeKZQAt4bDv7E2Xvqw+7AmVhfitBCf5P5Py/D0B98OjwuyPlHjfBkZNOT8FAhfG+11EObA35E3QuiXVgYIwBK+do4EvAnwUCc+NBhZC3/5Wsw0O4x7A9bzlpPF4tqoVFVJLnhM
 AKVIgtMX
 tfMsd2NX3t6jzYWeAhyMEDxsMU8QLxTHPD2jFbJ6G5EEJcLXBtx5GyXIBd+/O5oXHTgjJU88PKRLrwkWayWiD7uAq3pJV5nP07vkDvF7rI1kh0D48nxs4BrsYOxNAMv4uV/tkEVSBpMtT0sFSViitr6dLBeKCyGF/SjcLodsm1rey3s3Z7zyp06+xor8dZGKF/SfuX6uZtsUFq8c/+1lNKj4FiMvsqdBjwGX01ZeSqMWvQZ8i+cfwJOTIArdMLhXLT6roIiCmkB51ni4Bk4LDYaKEnsbB25nsln0c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

A lot of tests require free HugeTLB pages. Some need just a few default
huge pages, some need a certain amount of memory available as HugeTLB, and
some just skip lots of tests if huge pages of all supported sizes are not
available.

This all resulted in a huge mess in run_vmtests.sh that sets up some huge
pages, adjusts them later and restores some of the settings if the stars
align.

Add APIs that allow saving the state of HugeTLB and setting up the desired
amount of HugeTLB pages.

Saving the state also registers atexit() callback and signal handler that
will ensure restoration of HugeTLB state.

Since many tests use both HugeTLB and THP, the atexit() callbacks and
signal handler are restoring both.

For kselftest_harness tests that run fixture setups and test in child
processes add a constructor that will save and restore settings in the main
process.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../testing/selftests/mm/hugepage_settings.c  | 176 +++++++++++++++---
 .../testing/selftests/mm/hugepage_settings.h  |  30 ++-
 2 files changed, 181 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index 4ae7332b5e1b..3eef87e812ba 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -306,31 +306,12 @@ void thp_restore_settings(void)
 		thp_write_settings(&saved_settings);
 }
 
-static void thp_restore_settings_atexit(void)
+static void __thp_save_settings(void)
 {
-	thp_restore_settings();
-}
-
-static void thp_restore_settings_sighandler(int sig)
-{
-	/* exit() will invoke the thp_restore_settings_atexit handler. */
-	exit(KSFT_FAIL);
-}
+	if (!thp_available())
+		return;
 
-void thp_save_settings(void)
-{
 	thp_read_settings(&saved_settings);
-
-	/*
-	 * setup exit hooks to make sure THP settings are restored on graceful
-	 * and error exits and signals
-	 */
-	atexit(thp_restore_settings_atexit);
-	signal(SIGTERM, thp_restore_settings_sighandler);
-	signal(SIGINT, thp_restore_settings_sighandler);
-	signal(SIGHUP, thp_restore_settings_sighandler);
-	signal(SIGQUIT, thp_restore_settings_sighandler);
-
 	thp_settings_saved = true;
 }
 
@@ -399,11 +380,31 @@ bool thp_is_enabled(void)
 	return mode == 1 || mode == 3;
 }
 
+#define HUGETLB_MAX_NR_PAGESIZES 10
+struct hugetlb_settings {
+	unsigned long free_hugepages[HUGETLB_MAX_NR_PAGESIZES];
+	unsigned long nr_hugepages[HUGETLB_MAX_NR_PAGESIZES];
+	unsigned long sizes[HUGETLB_MAX_NR_PAGESIZES];
+	unsigned long default_size;
+	int nr_sizes;
+};
+
+static struct hugetlb_settings hugetlb_saved_settings;
+bool hugetlb_settings_saved;
+
 int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
 {
-	DIR *dir = opendir("/sys/kernel/mm/hugepages/");
+	static struct hugetlb_settings *settings = &hugetlb_saved_settings;
+	DIR *dir;
 	int count = 0;
 
+	if (settings->nr_sizes) {
+		for (count = 0; count < settings->nr_sizes; count++)
+			sizes[count] = settings->sizes[count];
+		return settings->nr_sizes;
+	}
+
+	dir = opendir("/sys/kernel/mm/hugepages/");
 	if (!dir)
 		return 0;
 
@@ -427,11 +428,16 @@ int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
 
 unsigned long default_huge_page_size(void)
 {
+	static struct hugetlb_settings *settings = &hugetlb_saved_settings;
 	unsigned long hps = 0;
 	char *line = NULL;
 	size_t linelen = 0;
-	FILE *f = fopen("/proc/meminfo", "r");
+	FILE *f;
+
+	if (settings->default_size)
+		return settings->default_size;
 
+	f = fopen("/proc/meminfo", "r");
 	if (!f)
 		return 0;
 	while (getline(&line, &linelen, f) > 0) {
@@ -479,3 +485,125 @@ unsigned long hugetlb_free_pages(unsigned long size)
 
 	return read_num(path);
 }
+
+bool hugetlb_setup_default(unsigned long nr)
+{
+	unsigned long size;
+
+	hugetlb_save_settings();
+
+	size = default_huge_page_size();
+	hugetlb_set_nr_pages(size, nr);
+
+	return hugetlb_free_pages(size) == nr;
+}
+
+unsigned long hugetlb_setup(unsigned long nr, unsigned long sizes[],
+			    int max)
+{
+	unsigned long enabled[10];
+	int nr_sizes = 0;
+	int nr_enabled;
+
+	nr_enabled = detect_hugetlb_page_sizes(enabled, ARRAY_SIZE(enabled));
+	if (!nr_enabled)
+		return 0;
+
+	if (nr_enabled > max) {
+		ksft_print_msg("detected %d huge page sizes, will only test %d\n", nr_enabled, max);
+		nr_enabled = max;
+	}
+
+	/* If HugeTLB is supported, request 2 HugeTLB pages of every size. */
+	for (int i = 0; i < nr_enabled; i++) {
+		hugetlb_set_nr_pages(enabled[i], nr);
+		if (hugetlb_free_pages(enabled[i]) < nr)
+			continue;
+
+		sizes[nr_sizes++] = enabled[i];
+	}
+
+	return nr_sizes;
+}
+
+static void __hugetlb_save_settings(void)
+{
+	struct hugetlb_settings *settings = &hugetlb_saved_settings;
+	int nr_sizes;
+
+	settings->default_size = default_huge_page_size();
+	if (!settings->default_size)
+		return;
+
+	nr_sizes = detect_hugetlb_page_sizes(settings->sizes,
+					     HUGETLB_MAX_NR_PAGESIZES);
+	if (!nr_sizes) {
+		settings->default_size = 0;
+		return;
+	}
+
+	for (int i = 0; i < nr_sizes; i++) {
+		unsigned long sz = settings->sizes[i];
+
+		if (!sz)
+			continue;
+
+		settings->free_hugepages[i] = hugetlb_free_pages(sz);
+		settings->nr_hugepages[i] = hugetlb_nr_pages(sz);
+	}
+
+	settings->nr_sizes = nr_sizes;
+	hugetlb_settings_saved = true;
+}
+
+void hugetlb_restore_settings(void)
+{
+	struct hugetlb_settings *settings = &hugetlb_saved_settings;
+
+	if (!hugetlb_settings_saved || !settings->default_size)
+		return;
+
+	for (int i = 0; i < HUGETLB_MAX_NR_PAGESIZES; i++) {
+		unsigned long sz = settings->sizes[i];
+
+		if (!sz)
+			continue;
+
+		hugetlb_set_nr_pages(sz, settings->nr_hugepages[i]);
+	}
+}
+
+static void hugepage_restore_settings_atexit(void)
+{
+	if (thp_settings_saved)
+		thp_restore_settings();
+	if (hugetlb_settings_saved)
+		hugetlb_restore_settings();
+}
+
+static void hugepage_restore_settings_sighandler(int sig)
+{
+	/* exit() will invoke the hugetlb_restore_settings_atexit handler. */
+	exit(KSFT_FAIL);
+}
+
+void hugepage_save_settings(bool thp, bool hugetlb)
+{
+	if (!thp && !hugetlb)
+		return;
+
+	if (thp)
+		__thp_save_settings();
+	if (hugetlb)
+		__hugetlb_save_settings();
+
+	/*
+	 * setup exit hooks to make sure THP settings are restored on graceful
+	 * and error exits and signals
+	 */
+	atexit(hugepage_restore_settings_atexit);
+	signal(SIGTERM, hugepage_restore_settings_sighandler);
+	signal(SIGINT, hugepage_restore_settings_sighandler);
+	signal(SIGHUP, hugepage_restore_settings_sighandler);
+	signal(SIGQUIT, hugepage_restore_settings_sighandler);
+}
diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
index 57fbf2f57e13..d6a1b4e5f734 100644
--- a/tools/testing/selftests/mm/hugepage_settings.h
+++ b/tools/testing/selftests/mm/hugepage_settings.h
@@ -6,6 +6,8 @@
 #include <stddef.h>
 #include <stdint.h>
 
+void hugepage_save_settings(bool thp, bool hugetlb);
+
 /* Transparent Huge Pages (THP) */
 
 enum thp_enabled {
@@ -79,7 +81,11 @@ struct thp_settings *thp_current_settings(void);
 void thp_push_settings(struct thp_settings *settings);
 void thp_pop_settings(void);
 void thp_restore_settings(void);
-void thp_save_settings(void);
+
+static inline void thp_save_settings(void)
+{
+	hugepage_save_settings(/* thp = */ true, /* hugetlb = */ false);
+}
 
 void thp_set_read_ahead_path(char *path);
 unsigned long thp_supported_orders(void);
@@ -97,6 +103,13 @@ unsigned long hugetlb_nr_pages(unsigned long size);
 void hugetlb_set_nr_pages(unsigned long size, unsigned long nr);
 unsigned long hugetlb_free_pages(unsigned long size);
 
+static inline void hugetlb_save_settings(void)
+{
+	hugepage_save_settings(/* thp = */ false, /* hugetlb = */ true);
+}
+
+void hugetlb_restore_settings(void);
+
 static inline unsigned long hugetlb_nr_default_pages(void)
 {
 	unsigned long size = default_huge_page_size();
@@ -127,4 +140,19 @@ static inline unsigned long hugetlb_free_default_pages(void)
 	return hugetlb_free_pages(size);
 }
 
+static inline bool hugetlb_available(void)
+{
+	return default_huge_page_size() != 0;
+}
+
+bool hugetlb_setup_default(unsigned long nr);
+unsigned long hugetlb_setup(unsigned long nr, unsigned long sizes[],
+			    int max);
+
+#define HUGETLB_SETUP_DEFAULT_PAGES(nr_pages) \
+static void __attribute__((constructor)) __hugetlb_setup_default(void)	\
+{									\
+	hugetlb_setup_default((nr_pages));				\
+}
+
 #endif /* __THP_SETTINGS_H__ */
-- 
2.53.0


