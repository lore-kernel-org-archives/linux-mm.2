Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F901FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED5506B00C8; Tue, 28 Apr 2026 16:45:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAD416B00C9; Tue, 28 Apr 2026 16:45:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3046B00CA; Tue, 28 Apr 2026 16:45:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB0536B00C8
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:45:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8ECBA120225
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:45:51 +0000 (UTC)
X-FDA: 84709146102.21.57CBAC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id E5EE640012
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:45:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="k/UGjFeJ";
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnQrYKU3Du6ejL6ywJU34b6HWQf1zjpejgfdjDoZVqA=;
	b=Fyg+IkDvsvGV0KONG7lpquLu5e9cuOmFRB1n04YXPYSG9Kymf/EbwEpl2tjTb2XyWdK2m5
	pf+Yl6NVNldZ9zGeDvk517Ts+OmZ7H7Ib9ZplWJztqSySbfCEm5sok/Fy8thiLBXOG/UMe
	Quy0e/hqnQMP+OaE6p8zonk3cccrdo0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="k/UGjFeJ";
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409149; a=rsa-sha256;
	cv=none;
	b=8kOu1l/3AzLnlHfeEWGoJpTIV0Rx5WLwvmkSFccu6TYGQ82afQ2wzwx9Z/DfVKIxYcPr2x
	slD9AZqfUeLMuCh+EeWT9G4H7+LRjyfLPizft6w0kSEU26johLMOESTNNElVYibcDvOZas
	ZTGIS0Eg3WPjdb/Zs/x1KMd+7B/vEUY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C65D6111B;
	Tue, 28 Apr 2026 20:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21992C2BCAF;
	Tue, 28 Apr 2026 20:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409149;
	bh=OlIUBzF1pm75Atj7loyFKXAz39qc33UiLBzlYum8j8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/UGjFeJw0dt9uKzNCvUdtfovqatLZx9o4OUbHhk/quGTcjQhiWZi1jFcvGCJ/vOH
	 HE7VV1znvB9Y9XYTnwqK5FbyW8sFx2HP1PN+pSWrVLTtr9yZXkKYrj4k1/N1/bH5gj
	 kIYZNJvZo3oM8GMOt0tkI20KiJM44eNfDbsehM6yjiw7QSe2ooisV59hkLJwFvSW1J
	 ciReWNIL4cMrnh7Q2J3f2dquu5mbc/OoGHYnVEZkeHEuOFJdeUpOAUwc58YC9MFTtA
	 8rP1bSO8ITo+SgVpwdyuREMBBBMoNFl3n5Q1GzfgRnHlSuBr0C4uDUTHvuAs2/y5V6
	 pdau8Y2vkJh1g==
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
	Luiz Capitulino <luizcap@redhat.com>,
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
Subject: [PATCH v3 27/54] selftests/mm: hugepage_settings: add APIs for HugeTLB setup and teardown
Date: Tue, 28 Apr 2026 23:42:13 +0300
Message-ID: <20260428204240.1924129-28-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3oi9wx4g6a39bi37d3fpsybhy3hqhkt6
X-Rspamd-Queue-Id: E5EE640012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777409149-485092
X-HE-Meta: U2FsdGVkX18f7HyLh3EMuhckOd5LmEoUR/fqWyc0N+V4T1MN4YCWu10BcjWSgOs9BM1zkUoZtClYt1MXkDBMIq8FJWeVT2eseOlH6gv9hPBsHoVBBDhFgd4MgWfK2k2j+YX9mo65HA4NTm4cxEFU6CgGxxgzFsedqe6rSUtcn4Ti2IncB0BPezhLKdO5xDq2P1bVM4L7Tq4R68UFEhCcDMXi8pugpXNxpAuohOx8mp6sKdGS72i9b52pb01+DxPWwX/uxpnYiqkdl2/4lPR25QQNi1aA7PlzJK0HYN3sdQCk3XFGlcVi3o+6ZO3eSm1uPrGZo+kGR7ShCM11YwLptu3eMTV6LyAIop8hAazlp4pWxdMDkwisvRA1y5+gULmPDhJexEYZB//GyhjPCQvxjW2uSdWeTzkfgxowYv5XjinvhrAekPLqDx2fPyVvK0mDcaJDQWoMvrpoJBXxiVqr/ko2i61ByZ/FjqFKXDK4MxwTkPOo+dAt/iF9EMEoyR9xGeanInozm8Zj7tStEDhdDO/L4N5b+S+2Owwxeiw6YVdFAfgvy2WKcaRQ6S8st1wy1T0f+6LNh0FNzQcO/p1l7qZe/+JckqPsL1RQSfB+okNSDb5Xgki4flMwu6zJ687wJ9Atf5heCYQI6gGt2XyUC2SkFpxjbqZaQ1zEio/tnQKnhyYsxcrtwgodHQaFJh9uc1zEUucfQG8fxI/lJ7jfSrjFvqSNh9LfIClVDVvuqiS+6IzxuPGql6KCR/UcsJlc9aLrm+y8t6BGGrvB0nyy27pGgkheLozDhNSGLgq4m0xa/u1eKiyrZAQetOneGFoTa/dd94/otSzR1FOlqDtJlvgbsZJLoNdzFmfW8xWT//K9uih0U1UWivEIhX8Lldueh+NZawSxsjbWpRXIhu88iTCvj7k539DdrQOQ4veIPph377vG2KhMR+glGkXY0NmcMFli/+L/v7mCyb3ATaU
 Y/RxrpPN
 z2Hu20XBUVuLE1bD0YSpR+L2csbJaVuhfGDkTPYg25WBTJJSJhNkE5HC/BAGq1bFWa2m9Y3VwHfmO/6ddHWrqd7WkwPSKV+2xRdSty8h0wMs6/0EiY/zWkkNJLy1tMKVxqmyODrybg7cU4AzY8A9w9zSEXTN0NwXzWdLGLH3tYIYG7NeHh5rf1AfzvAlminrwrWC1F2JPZwiWUxYM8uvxrn/n1Qhg8saOqqijTPIjNGVcHd1HabAi4J1FjfXS7OKPInpYeNij1VC5I+pNsLFFaw9GQvYvSy7AqaLy
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
 .../testing/selftests/mm/hugepage_settings.c  | 178 +++++++++++++++---
 .../testing/selftests/mm/hugepage_settings.h  |  30 ++-
 2 files changed, 183 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index 4ae7332b5e1b..9d31b53dbc67 100644
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
 
+	if (settings->default_size)
+		return settings->default_size;
+
+	f = fopen("/proc/meminfo", "r");
 	if (!f)
 		return 0;
 	while (getline(&line, &linelen, f) > 0) {
@@ -479,3 +485,127 @@ unsigned long hugetlb_free_pages(unsigned long size)
 
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
+	hugetlb_save_settings();
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


