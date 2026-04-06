Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 141E2F46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:20:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C2426B00C7; Mon,  6 Apr 2026 10:20:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7732A6B00C9; Mon,  6 Apr 2026 10:20:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0A16B00CA; Mon,  6 Apr 2026 10:20:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 58D6E6B00C7
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:20:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 28A621A0471
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:20 +0000 (UTC)
X-FDA: 84628341000.14.2E4684D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2AC7B2000B
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DunkWWd2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485218; a=rsa-sha256;
	cv=none;
	b=rkMVMoyjVTiGnvX2G3Tn89f4MiUzwGZpDSfnVWx5JihFKWVKD1iEPuFopJHeEZusbbMiG9
	uwzyX58/AHkvqAxJ1ePmQvU+4ffgmXlRkQFypL8PmdA6tVRtI6fs1boGXLQCzDWVD7+UOf
	ZEZbFj+voF1Z0QSfAF04E8TGJS6Rxik=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DunkWWd2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/NswGzSzBSeD5r4b0rMvjx+30uVeeIp+Did4GPLPTuM=;
	b=UqRsUzA+epKK5rbORibTnHPxGs9eNAwYDB4ZwJcx3gj3y/Cf/vVtnwiI4Gt4YdW+zT+gFX
	qyxILYULNgkeydh6j/jvgUIpuhhcdU6YG+6xcpk4ZdN59jNpis1sJDbDyGr1kqNTumXjkP
	PZivMv2XIAFc/a5UEgU52zeQLRKCZ1c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2963043D6B;
	Mon,  6 Apr 2026 14:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8F9C4CEF7;
	Mon,  6 Apr 2026 14:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485217;
	bh=uOk/wAXtSYozRkV6PC7dCLvIk2f3cksuzUZUEbVUqsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DunkWWd2ts2IPlOOfFbg/CuY+qeprPXKT7cKrxJoIq0GnNayggZlB6z+6r1vEtJ0Y
	 i5K8GZwJctvEYhOSIetlR9m0/SK0js9RWFXgUnBNLKDqRKIMHPyInL3g/a6bWkCnYm
	 v4oVV/XjXOjMA+sxpbMZEJOac7tZGlu+3lE/yCFhEuDQ2IbQVQVUMXWD1y47HDW/Ip
	 n7fMBVKeEOJ0C/RVd3Qk5w5AzQjD/nQ3ANGDoVGnAaPAzWz/oqRXw++Dm1rvUKHUo+
	 T4SnPD9RHof37EjSqtiPVXVqhVrYXCpyWTEuVZZYlxsS3i8rFAiOGku7fQdOrsyIui
	 1dTsiErU0oEHA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
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
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 26/53] selftests/mm: hugepage_settings: add APIs for HugeTLB setup and teardown
Date: Mon,  6 Apr 2026 17:17:08 +0300
Message-ID: <20260406141735.2179309-27-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7j3se3sdiu34e3upgmy14b66gpiz8cct
X-Rspamd-Queue-Id: 2AC7B2000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775485217-486630
X-HE-Meta: U2FsdGVkX1+OEaVxY1IU/alBVyPl4SsqgYeV1uSupYwNFbyjpzZwq2+oxs3sWAUHS0MmHSULi5g+Gqx2TPADpwPO5b5xHPQZG6FEvytdell/mPJm06fMyizlCR45zon8Z3ii2XaNdCNG0J/zCv+GKTE8r5bt6XDK3i9bVfOaXQkt2o6IZRZMRBVw2gPbCrYzGmZXQuKmCNIWjZBiebWHQ1nmixXzfJQJU74c+gOf7J6S0ziTTXKh+VytQoNjpNKJ7s5gRO2BAdsTmHiefK+cCZV6WO9gm+hFFODhmlB8qPosm59i++5UJVEVOWiHnJ1y6lk6lJB35xggLS/aRBxIlz4TF6TVj/sSf+PsbAe8ADUKFI9ywsFLtZ28Ay6KWGT6cmS/Sfyw5WScu6OScWp2pbMxcQsKoMS0DGXr2u3twnPOnQzBn1zpFaxtei9B/7kDyqcgLs/NgM7n8cZyfVpvCHZHNJvB3Ggx3QqwjTrsJnDApOLq6pHQqFKMNl3VZOBnLi8lS6RJ+SiKk0bXwrE5hbOQARD29/bTdmmakPi60m7OgZcwrtgLsDIdDgVmCWLMCoowoGWQvi0/sVlu79A0RboHD9lMoeFWLe03eUFg+DWNstDOi1vmvCTGzBeQQKVhRVJlkWMKqP5hyPBJJFpl8m8o9NMK1h6edqY9qhuMOecB87SM1D0EAbMIbwHYmAQfEz90LLt+TtuDdAxEjJfyJXurT30jIOzQ+N4DoParMKcNBAcjc/gx3qMfueb2iHF3QtWANeyR5aPuMqi0nGYCas/Dj8P/uOYsG1yyoicz8UOuM4nurhc2MDh4ELLaMV7A2auieR8chdsZyM7ZFxExzMyKtuD8yPTNq6MUQ687nWiZWNPkWh1rrGDVRuKCO0rm6JbS2zoJ3nxJvxTy4Drpcm2Ej7rkiRZLyc6gLK5u1YTbAFA+qaano9aBTdA21LwNOUrADjhDMDcRaYQd8dh
 7K/wbasu
 aF3Aq6uUPcmPKrDPj1FR/31Y3QWeqTM61qsieN7AbfA+zVoouCAlS0vuuh8CTXAhRKcRcubtR99nxAMp8SOSjP5/UvXK3ddVjgUmOQ5+wF0RVeH4jAtZ3qE+GOeHv4u7S5ZPRVmZyUhANZ0xDK9qdBw3Ig9RxB9BCUBHB9bIuHLFDjqLONJZYM0ICltTct5hfRXl2cwPYIWNxZWwx632lrP9A1dF61EGgPjT2cmQ/H5Zc4bcVQifuDcHo/BZROUwDSWeXjWdEfRNeEK9Z6TvRI+j+LPnMgWSAN9bd
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


