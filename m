Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA5DECD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 423216B0101; Mon, 11 May 2026 12:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D4A06B0102; Mon, 11 May 2026 12:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 311776B0103; Mon, 11 May 2026 12:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 24D946B0101
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:31:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E72F01C01DC
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:31:35 +0000 (UTC)
X-FDA: 84755679750.19.9E08702
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5065E1C0010
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:31:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oOt6xw4y;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96q10FUC8IxAKg6rS4EJei8KomMGhDZrShYdmWHFqs4=;
	b=zu5M6LK9cbjkxLwe8e26Ar98QM3xY74yYF+5ioNQib3u1glq+Zsr6TrJmsNTlhHMbm9jJT
	a67JgeArhPwYjZwEKwN7cqbQaa5dhIbi5X9PASz1n1SsjrcT2KG8dG1UTi7hwVFM4ub6yo
	3hkVNQMoL++R1FT+HDSopsOORmV4+vY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oOt6xw4y;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517094; a=rsa-sha256;
	cv=none;
	b=Y5iLUXVdfu/3B91o96LDGcjDKezClXZK91Do7XjqyFlOtwd2ZC74jn9u0l+5bs7qpvsDYk
	DjglrHoiAyMr+UKOtVvW9mhiuIHdkxG0XDkde8S6J1dTMGSMy9p/bbxmmAn8C4qAoAME/Y
	N121sdAcld+Krw4sVUCZ41nl1CzQOjg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C7616600CB;
	Mon, 11 May 2026 16:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B53CC2BCB0;
	Mon, 11 May 2026 16:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517093;
	bh=siynKJJiNzHCisWCUvercIcpwfP0ofNm0Gk9TEdW0mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oOt6xw4yUlrEKWcf+ajWEIEYByypVJ1Tf/KQvQugPn1VRbXqqjOuZSSnRfoU1PAxE
	 0nhAzxPaQnxHgRVAOA/gTe2p0+vAUoVdGBcr2aU3WBoBMMZmRr7VA4KpGfFC9szAMx
	 Sk1g3/x8WaHDImzZyE7bLmEJhcFWKe7nuZro0NmjkhdZunIyFrc5DLtwyWjFaElL1U
	 agYcWvMiteOROCnE1HSTD6dPsAeXQIbTPk2Dp6WlTkzqfUA/UBet2umh5raXijM5kx
	 edNzevDMa40cEcndJcKirRfxTCDpkR8MIByrNo/4M1/RaB+IMxpZbmzD76nWZGt/83
	 WIfQBJI2H5vDw==
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
Subject: [PATCH v4 25/55] selftests/mm: hugepage_settings: use unsigned long in detect_hugetlb_page_size
Date: Mon, 11 May 2026 19:28:09 +0300
Message-ID: <20260511162840.375890-26-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9jhptwrrd83juwykitpdk66wmubbk1it
X-Rspamd-Queue-Id: 5065E1C0010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778517094-715101
X-HE-Meta: U2FsdGVkX189VhjtZgsoUEe3upCh9dFqWzcWrWhZavr/YnyZniIq9+tjqoRQV32WDYBsYe6fKhv9R3d3nAbVapcKs3tpBaIymgvRyH+0Qx/3A37oqpoQaux4BbqGovHdtpWL9FE7eGUwSLty1auuMpdeKQK+WkDaTi0rkuSmRsdjbeRZmzsTV2BaUYnH7S5hIikqtIzYSaO4wGdaEZDWfum1zq1AwGv3JOtevOHPADsKSdLr26QQfDSE67+d8RP/RA0vmGb+pbCk0YqAfBOrDDxw2WBPjJ6FlLNcDwlEVa/1P7GJl6PMIisMhLWUTxCXNQZC8IhEUT/Be7rey6iJB4t3A/uRX7uEMufB1nEejHUNg8aEhSOtXqfUnGZE9XHAr0FEslgaEbulk6lOt5KsccluDJVJbHp49WFlCobM0IUBSSWmXKJQZkHWJowwZIzjW229IN6prhSm1hhFcFISapUfF0O0gCyzagTZVy70bHBB4NUvfqKIGRdqf+59l7cX3jDAMgh0UKNAIDuaIp9yCZjx2QbRXSYsQyIaZQWp6KVsM+/EVPbXBj307YaEFt4DmExLeE0ue1IAx3IZt0wonh6bFO9O8f6fnvbIyedFU3cgT8z0a8lh7tEXby65lnE4UwHp8BoRakUnLKJJ98PBZNJHMbTyItLmGC+xMOXOH/I6blyIOddGeSR3e8W3uimtrL8HbcmnyBcwPKVkkOD0ms+Lolv81xn7RxYZ2uDeaLd+yAnd5+Ywmxc2IjqVU3SdCpNQ21UY6ZndSo4how/MAZKA9R4fsQcBiKT2ZOoj9RzifH8fwOznPNkQUMQa/mu/eNowNUFEVyXiwEYxuylXRadaq8qrVrUDBP+8YJQO/xCFxYzKmK6m8hho+522pNwBacvaeC20MS0WJLtSbTwZeOW0N/rXi5h7bQE2UMII56sH99z5cA9IqoXar5B8VAr8aMpTzQvJB99vpV+1KWG
 zA0y8ksl
 Z15ADB6ORsF66oD92hlIuQFeS0zltPX29L023Ww35y+xwqUxCcsJt69YRywu/pf5HmpbCRNYjwEQKas7eSRMHiros9cQi6CXKgaasBvBXGbcdmLitZI4qOsBazc1fcqCjCx4n+2iN0Gc/VB7yY0JmoR4GsFwVcCPzhUukaWxFEy6VBqvMKiV2SNZg6DvWrO0Im6xfo0V59unz2bLLUs6s2ROSIXZzVxMXlCkK+FaEPa71xnamf6pmuGKLKXXUNB/vV7eshAFitNpj7Q685BYb7aHks2UgeNjN0uKvjM4HvNzAoZFabqg2n3RwopFgboceIzDiD2Fp3U9JUuijWymaXwyEkTWa/MtSj8DHrpYanlLSxRI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

... instead of size_t to avoid type mismatch in 32 and 64 bit builds.

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/cow.c               | 2 +-
 tools/testing/selftests/mm/gup_longterm.c      | 2 +-
 tools/testing/selftests/mm/hugepage_settings.c | 2 +-
 tools/testing/selftests/mm/hugepage_settings.h | 2 +-
 tools/testing/selftests/mm/uffd-wp-mremap.c    | 6 +++---
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 4321f4208fe3..5e571216b8d2 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -37,7 +37,7 @@ static size_t pmdsize;
 static int nr_thpsizes;
 static size_t thpsizes[20];
 static int nr_hugetlbsizes;
-static size_t hugetlbsizes[10];
+static unsigned long hugetlbsizes[10];
 static int gup_fd;
 static bool has_huge_zeropage;
 
diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
index ab4eaf4feb7c..96dae0acd11a 100644
--- a/tools/testing/selftests/mm/gup_longterm.c
+++ b/tools/testing/selftests/mm/gup_longterm.c
@@ -33,7 +33,7 @@
 
 static size_t pagesize;
 static int nr_hugetlbsizes;
-static size_t hugetlbsizes[10];
+static unsigned long hugetlbsizes[10];
 static int gup_fd;
 
 static __fsword_t get_fs_type(int fd)
diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index 3d6e4376de06..fa635667aabb 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -398,7 +398,7 @@ bool thp_is_enabled(void)
 	return mode == 1 || mode == 3;
 }
 
-int detect_hugetlb_page_sizes(size_t sizes[], int max)
+int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
 {
 	DIR *dir = opendir("/sys/kernel/mm/hugepages/");
 	int count = 0;
diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
index 4c51e9219f6a..f49bd7fba512 100644
--- a/tools/testing/selftests/mm/hugepage_settings.h
+++ b/tools/testing/selftests/mm/hugepage_settings.h
@@ -90,7 +90,7 @@ bool thp_is_enabled(void);
 
 /* HugeTLB */
 
-int detect_hugetlb_page_sizes(size_t sizes[], int max);
+int detect_hugetlb_page_sizes(unsigned long sizes[], int max);
 unsigned long default_huge_page_size(void);
 unsigned long get_free_hugepages(void);
 
diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index 9d67b11c2f28..b44e02840a5e 100644
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c
+++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -12,12 +12,12 @@
 #include "uffd-common.h"
 
 static int pagemap_fd;
-static size_t pagesize;
 static int nr_pagesizes = 1;
+static unsigned long pagesize;
 static int nr_thpsizes;
 static size_t thpsizes[20];
 static int nr_hugetlbsizes;
-static size_t hugetlbsizes[10];
+static unsigned long hugetlbsizes[10];
 
 static int detect_thp_sizes(size_t sizes[], int max)
 {
@@ -245,7 +245,7 @@ static void test_one_folio(uffd_global_test_opts_t *gopts, size_t size, bool pri
 }
 
 struct testcase {
-	size_t *sizes;
+	unsigned long *sizes;
 	int *nr_sizes;
 	bool private;
 	bool swapout;
-- 
2.53.0


