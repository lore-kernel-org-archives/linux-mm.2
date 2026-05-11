Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7A26CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:31:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29DE26B0109; Mon, 11 May 2026 12:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24E806B010A; Mon, 11 May 2026 12:31:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B906B010B; Mon, 11 May 2026 12:31:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0C18D6B0109
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:31:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BD22B140139
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:31:55 +0000 (UTC)
X-FDA: 84755680590.21.E7FEF5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0562AA000D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:31:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HqEENZyA;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O167ewbT9OQ2fTY9gEywxARAqSPqWLURomMJP4Ng0h8=;
	b=TmmW0Ltap3JCzwOBXh/L/ujcbjQz1+zj6boMEzwz/lO09FLR7wFOlvzz58hh0HjfSIj0k9
	KJrr8mdeg+XryKgrBcRRvbTdIci9h00pgSNySEsuXgyy2yRZR87Cnn4kYia+A2+W1Wfr1G
	vYy8rJC8zzKRXhWlGPzAUJInWhMvX08=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HqEENZyA;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517114; a=rsa-sha256;
	cv=none;
	b=6j/mgmtZyVb7ikGdNPQ2CiTfZM/oncwfkrdGHJCvBuYFer/Em04E02LW+ZWZJ2Jg+fOLbw
	XD0G2fsavjjXsKjI9PeVRCdOa4wxMZhm/ticqP7i6xVBjpB+AKRKYD+DyAXwHOoO8PTv16
	Q6sOb6tkPUg6efYf/eLvPHHQsp2kJsA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 360494076C;
	Mon, 11 May 2026 16:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D03C2BCC9;
	Mon, 11 May 2026 16:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517113;
	bh=CnmardlqPvE7LgOIfn5JKBi/nFUBjeb2JAZaSRqTuWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HqEENZyAuLwkRNYG0uKKcfP95/KqKl/OvoZJjFYv/qO+8Vj94jOMRDKwKOfwZBTOR
	 1BTOHLU8dN/u5/OdyBX5vIeCMBGi1sKx9fMQaLX1olSBXpaVWg9vK9bCDxuIA87PQo
	 7lIO8lvY1C85jyNM582acvHchRDopt0mOu0pAcaKV3Yg75Sw09Q6BUfK+hd4sz6fOv
	 PVnGyflETzXNBHvxsW3eEGd4rW1RqK3VawCGDO/BMC4/XY9p3I8P9C6mBvSgXHSF/n
	 /E9q6BLDQ7iLM6WlD18dyGm8PJRCYosJNYg2sqRzAZYbjv1yyviZqwGwAQkZNGDQ2l
	 UL3vbrnnOv04w==
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
	Li Wang <li.wang@linux.dev>,
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
Subject: [PATCH v4 28/55] selftests/mm: hugepage_settings: add APIs for HugeTLB setup and teardown
Date: Mon, 11 May 2026 19:28:12 +0300
Message-ID: <20260511162840.375890-29-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 977e331tjm7sdwbuuazz7zm3669zzdef
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0562AA000D
X-Rspam-User: 
X-HE-Tag: 1778517113-226700
X-HE-Meta: U2FsdGVkX19egQ5OMcJDhyGeXlfNAJgy+GM2b3wEE8AqH8BURVjzm/ZdMt68XHqH9n3d402TCSBYg3SO+NzuhSGW5wr9TZEBCP48bj+13q9J4bWh02xORmYePbop5u088w5Wy4ZTA3q+baS4WP6oIcewpXx/L7SZDH4QW4wS+B/JNWt53XvN4yp088ondEWFAqzQDiq8xfMLhn/rloIvqR26kg6tbusHrAZHVnPynLO35ZVcuW7RdJHhIBNEZ7mIE3eBK8/gg19+5aKI0I3rjqOc4UeRL8HF/53jk9gar9CXR6aIBCf3wuL5f/jlYUDero2CjklKtn48gs/erd461nzIQwDJMuWfJ7DI9jZqeoO3tHifD43YUyZF1UWYR8luEGENAj42IcELo0Z1DXcSmpZwQqiqo3aQ69azyy6POyQI1Bzt8R18LpIHsO7bep/k1sOdNl1AQMLwYw7ZqrPagl4+G5qPvkyxMBvqJ3Red3ETWzR96zsHtQe00A1UWyju5dVO75KyZwYiL1Ex+mQ3ezDFipHcz2ZgD+5Cr5nv6iOUUlBBVKajh/Hr31GtfAYbpOSVDijEMK/2aUWBomNV21ncF2D4eRE96No/JHyZm8DEhpTiHJeeCgTfj36QM084b7YUA1NpxLRf28XCf04ar86uhrldRUlM50iIL4E9sibUduiSmAIwiwfJnnHZH/CeomTR58Y1C35MqRd8xpfb/LTDQlk3xDO+1Oyn1eZwBulYl7rwLO4ge6abf1s3IuBVaXGJcKvXtDh4HsEoIPQeJlpoRmPfqeTOQ39/+88WnwXYsZn+DcfiOPH42mxaCY5yrq7cEZJAeHfTeVTdz0DuyVHeLUZ0sJpsVPjia/YEVzYXj4aHPqREBhbIoRVZzq9NyDf2uC44/xlHQvR73S2KotZjFjkq5SnzbKS1gp3BcVxHq6H/VM09Ra1xrXkvbTYL+M6zr/FrzoxetMreWIU
 Ia/a4bR5
 rsECAtezey5xhA/48m8FoN8FEz/I85u2lixEb5gn9wCZFtzQRyAFAit/f0NGWVuZ6gEm0pXvA+qsysG8m+lcxfU3r5i7aGIw0iEbWjsBwdSIaJgOtyFMOlKBhpRtFQV2SPDXPfzLdT1GqXpRjCOWMuEecWrcaGi1Icxegh+wLOo5Z7s5Wv84nPApcyhLUcyj9w4e0PEceOUoCdlyLdKNnLcGDfkzyPiLt4m6+BEwh1/vwMEXRmNQ93O3aYvoFUN295UYjVzrzLXf6yQrJ8mV28Xc2gfni0R9b4chP+G5g9hitVbgvTS+ZoXXBAplyrRux0iUI3ooE+lAVeItXAxDOBqosgN3NJvmm5yPcrK1YoY9j8hE=
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

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../testing/selftests/mm/hugepage_settings.c  | 205 ++++++++++++++++--
 .../testing/selftests/mm/hugepage_settings.h  |  31 ++-
 2 files changed, 213 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index 3c944d28d14a..01a557f372d1 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -306,31 +306,16 @@ void thp_restore_settings(void)
 		thp_write_settings(&saved_settings);
 }
 
-static void thp_restore_settings_atexit(void)
+static void __thp_save_settings(void)
 {
-	thp_restore_settings();
-}
+	if (!thp_available())
+		return;
 
-static void thp_restore_settings_sighandler(int sig)
-{
-	/* exit() will invoke the thp_restore_settings_atexit handler. */
-	exit(KSFT_FAIL);
-}
+	if (thp_settings_saved)
+		return;
 
-void thp_save_settings(void)
-{
 	thp_read_settings(&saved_settings);
 	thp_settings_saved = true;
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
 }
 
 void thp_set_read_ahead_path(char *path)
@@ -398,11 +383,32 @@ bool thp_is_enabled(void)
 	return mode == 1 || mode == 3;
 }
 
+#define HUGETLB_MAX_NR_PAGESIZES 10
+struct hugetlb_settings {
+	unsigned long nr_hugepages[HUGETLB_MAX_NR_PAGESIZES];
+	unsigned long sizes[HUGETLB_MAX_NR_PAGESIZES];
+	unsigned long default_size;
+	int nr_sizes;
+};
+
+static struct hugetlb_settings hugetlb_saved_settings;
+static bool hugetlb_settings_saved;
+
 int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
 {
-	DIR *dir = opendir("/sys/kernel/mm/hugepages/");
+	static struct hugetlb_settings *settings = &hugetlb_saved_settings;
+	DIR *dir;
 	int count = 0;
 
+	if (settings->nr_sizes) {
+		if (settings->nr_sizes < max)
+			max = settings->nr_sizes;
+		for (count = 0; count < max; count++)
+			sizes[count] = settings->sizes[count];
+		return count;
+	}
+
+	dir = opendir("/sys/kernel/mm/hugepages/");
 	if (!dir)
 		return 0;
 
@@ -426,11 +432,16 @@ int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
 
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
@@ -478,3 +489,153 @@ unsigned long hugetlb_free_pages(unsigned long size)
 
 	return read_num(path);
 }
+
+static bool __hugetlb_setup(unsigned long size, unsigned long nr)
+{
+	unsigned long free = hugetlb_free_pages(size);
+	unsigned long total = hugetlb_nr_pages(size);
+
+	if (free >= nr)
+		return true;
+
+	hugetlb_set_nr_pages(size, total + (nr - free));
+
+	return hugetlb_free_pages(size) >= nr;
+}
+
+bool hugetlb_setup_default(unsigned long nr)
+{
+	unsigned long size;
+
+	hugetlb_save_settings();
+	size = default_huge_page_size();
+	if (!size)
+		return false;
+
+	return __hugetlb_setup(size, nr);
+}
+
+bool hugetlb_setup_default_exact(unsigned long nr)
+{
+	unsigned long size;
+
+	hugetlb_save_settings();
+	size = default_huge_page_size();
+	if (!size)
+		return false;
+
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
+	/* request nr HugeTLB pages of every size. */
+	for (int i = 0; i < nr_enabled; i++) {
+		if (!__hugetlb_setup(enabled[i], nr))
+			continue;
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
+	if (hugetlb_settings_saved)
+		return;
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
+	/* exit() will invoke the hugepage_restore_settings_atexit handler. */
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
+	 * setup exit hooks to make sure THP and HugeTLB settings are
+	 * restored on graceful and error exits and signals
+	 */
+	atexit(hugepage_restore_settings_atexit);
+	signal(SIGTERM, hugepage_restore_settings_sighandler);
+	signal(SIGINT, hugepage_restore_settings_sighandler);
+	signal(SIGHUP, hugepage_restore_settings_sighandler);
+	signal(SIGQUIT, hugepage_restore_settings_sighandler);
+}
diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
index 436f4ce02984..c07722b7f102 100644
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
@@ -127,4 +140,20 @@ static inline unsigned long hugetlb_free_default_pages(void)
 	return hugetlb_free_pages(size);
 }
 
+static inline bool hugetlb_available(void)
+{
+	return default_huge_page_size() != 0;
+}
+
+bool hugetlb_setup_default(unsigned long nr);
+bool hugetlb_setup_default_exact(unsigned long nr);
+unsigned long hugetlb_setup(unsigned long nr, unsigned long sizes[],
+			    int max);
+
+#define HUGETLB_SETUP_DEFAULT_PAGES(nr_pages) \
+static void __attribute__((constructor)) __hugetlb_setup_default(void)	\
+{									\
+	hugetlb_setup_default((nr_pages));				\
+}
+
 #endif /* __HUGEPAGE_SETTINGS_H__ */
-- 
2.53.0


