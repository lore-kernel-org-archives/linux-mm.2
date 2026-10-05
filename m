Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C706DCA5FE2
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 06:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8DF16B0098; Mon,  5 Oct 2026 02:53:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B18066B0099; Mon,  5 Oct 2026 02:53:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2E116B009B; Mon,  5 Oct 2026 02:53:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D24A6B0098
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 02:53:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE1271C0170
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:53:11 +0000 (UTC)
X-FDA: 85287655782.12.A9CA891
Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2CA3340006
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:53:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P9IXFL+p;
	spf=pass (imf11.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.98 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791183190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0yZt/yuxaSBTnRC+PSxXs89gpI+W86bHXS3Qdtmgzpc=;
	b=6Y2MmtmjOcionIHOpTXPpFmCDsI1VZZ37Ix/hEkzL3v2SnS5NgNTOpucpF025nLdWZgV1E
	/7+DlH8XiKl9NCFDzIPywg7eaStTqgAuXwdL6dOWu/HmFqQ4h2kL076MCU5nQP0cLb3DSu
	EDkNimPZkvmxgW6JgTfUgAZ63u1ECDY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791183190;
	b=FlRFYY0qXL1M8JW3ECCh8r3mpi5sMMwTzYS+SSxSO/TTeJc827tc9NSh4oV7It6tTp5zJp
	3/nt/h0FNmJQ64/a6eh8iQmYIpMiTxA0VEnNeIvjOcWJA9DTfV7hMyj1scvIuAvUHunf0H
	Vwx0PePIlI+okDS9qFoV96QYsGIRfO4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P9IXFL+p;
	spf=pass (imf11.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.98 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48aff58e6abso683965f8f.3
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 23:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791183189; x=1791787989; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0yZt/yuxaSBTnRC+PSxXs89gpI+W86bHXS3Qdtmgzpc=;
        b=P9IXFL+pBrKYkC3NmdqiC+yT98+HBkGS0AVZAfDIkzGdQ5geZnGQ8wStwMYFAM5Zir
         OPORQv//vyEbWEFjllPTfqk3UZeaUM0ylGpTalq/KFDakqWZ+53NcVxSaE7bJCFz5CAV
         ixgaqbbib6rVIdClBsmsQYPw59FWYv1CciMwk9Hhy+pPcY61nWfp8opZtOTUDS/ULquM
         T06usUb+rCm8nnrhymqcFqHMFTsm3Fx5KhZeJXnp4dgDNMo9gYjDOyQErHWTty1TXqhK
         wSZuI+NSNdHfGiJsUSjtzMxeP1vRjjxyTPlJXgdMVw6daX40lcB+3x1frYCy3srblvSx
         wHCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791183189; x=1791787989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0yZt/yuxaSBTnRC+PSxXs89gpI+W86bHXS3Qdtmgzpc=;
        b=pemfzDB7Poeqo5mF8H+c93uiu02C0++DlixxHoyzJyt7M42r3SNEAZDtx3/4cDu4Md
         0EmIbx645WXx7HgqOdfYwWdWWGOopcitCyvX0WT5Rc436GSlgpwvdKDw0E+OGvVEOauJ
         W78++v+W6ma3qavmT+IfiiRZr4GoqsB0OMD/hcbG+UqRx7XxwhbAhApkAHtrIXg96vUq
         OZBxXYIX0MZdK2fb4t1of8gayDSwTuXvCcdTtUdr9CoxPDplLD1z4JT8trzZXOKo8Z5C
         ErdXW+R6qxsr4U1t28V02v9cLj9eJH7eQei3yWgSaAhUDrYDWHinLX9O9+CF3jwJ5LIL
         nWpg==
X-Forwarded-Encrypted: i=1; AKwUvBye2GAWiUu/FxTCSvipnhVrrAeNue0x3cs09H9t9oMxNVc5porCtbWEAbMAQ+U1UgwcnT7i1w+kkw==@kvack.org
X-Gm-Message-State: AFq9FYLk7g+mIy5pURbnuzjG3dxEH92YbKdLBHIXj+tkLNB/bn4Evfi7
	muTfuXs2VoL2AXWwUOQl8SIwhZFVgegMDKTh7NUQZ5hAonIL+ypCV8eR
X-Gm-Gg: AYBFou3CN5L1XKJ4KuG5SYWQmw2ovVT1+MtWpfXTZRw7wrqwTWEMHj3my4ziuEtdS5r
	yhtTGVa7Hs5mGCS+m1+yU2j+CJzl/PvegrNgyb8cXASL5vukoYWbljmUPw4B8cLz0fB3RqKGQSI
	iOoezV1a/lLrhA7bF36B5mlHJblWYI7z5NcvxUr9pMBPKnuOaM0SNKMAXG//Z6iSgMpRPVWY81N
	rzZvQBgWrvZ/ERVghJmFeWSx+P2VNaIkwTAAN5CNeBYMnkLF2huni/WX1hO83zhFlb2BTW3o/BD
	rCbhh79j6p0o7I2EknMOdnzurV65A2rbBMr8CEZzlWRJFYSxqs7MPNgQJkKK8pPBOZOKv63TGvs
	bg1/Hrwc/QhHt9znjQ7dg6I+5fAFSDepnCtmET2mw58iD9S4d95aLBwV3oUCkJgBZrBZUCGP8pQ
	sVbv4mAePdUD5zeD7o8ET/e6kR404UFJIyB6D0DO6bBwD49BgOnE7DMps=
X-Received: by 2002:a05:6000:40de:b0:48b:d2d:2fcc with SMTP id ffacd0b85a97d-48b1272d0c6mr16209245f8f.9.1791183188499;
        Sun, 04 Oct 2026 23:53:08 -0700 (PDT)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c6308481dsm1247436f8f.3.2026.10.04.23.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 23:53:08 -0700 (PDT)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [PATCH 3/3] selftests/mm: test mlock() and munlock() range normalisation
Date: Mon,  5 Oct 2026 08:46:31 +0200
Message-ID: <20261005065244.6935-4-azpijr@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005065244.6935-1-azpijr@gmail.com>
References: <20261005065244.6935-1-azpijr@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: m4bcjnxbk4ghprkrysfar77bkxm5neud
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2CA3340006
X-HE-Tag: 1791183190-302165
X-HE-Meta: U2FsdGVkX18KfyHKTaNrlp8sj6iNzcrlCFhxO7kcCFrIfDuRz+5Ga697YE8o3KzFLD7P2gPCjHil5auX7tIeP/JhrljL4RNXLYuicFDAX5eV4eTGICuduTY91ejmTgX6QhzI1XP9rbS2UBBxcxjY2qp5RIL/2+A/2RlFeISD2C2h5SYuXdqXI8K6t4b1PNORi4qCQt8eia6jW6mfOYXNZe3CbZbJqAr0wg3zymfy58KzAu8YmMujoaDLZsficbh76/xERCgem7bbFtYZpE3lB9r6YLmBitHGZgV4WBitraZqNq1rH1iZ3GrLmXURjU5tq7zwlGXB8PIbx/f8K+R50gwFpYFG9Ew3+uUpzir+bnens5MGiwn2P8Hm1VpVtvp4QX6eTDyZHAfpAAse6irpPF3tu3TTu1HwGEd61NdBF5FoMd2Kz3E98mQoCZgYGWp1ix5YrzlWbmWDjh8HgS7kxyPpjk61sU8lybSrTaDQDZ//fl6iJ6gqG5+Is5UvxSohS2CGPk41M1sSaJFAH8ovFfZAZPL8RBmoRrxPBIwPcDO2XIyF0eOl4yw7Pq2ZOe4uNK8Nn2rEM6zLx0LBEXoMBT3Z0UjDqk+TcvXXSKpBwn2uaZCo7DbZiqit5pPV2OkbvI+ArsvA5J4VBL9DmtbgU9tt4McUITIXq/Bzxgk9Q9MSbmJhrlV4L5Ty6eUunou6ku17mVW3Eo89VEVzsMj5bikGlWcDJl6KGuQYwFGprlyDC9Rc946cgQB6JSdUxSC5W4ti1kDyWwyC30+latiOVT/zAAs8lh1Ll5CZZMwD9ifyszVbPRUpPyuQJT9hAFtwN8048bdZlsLVLVS8aq20F1n8dyxw7BcaRGuNhgCfmvt5ufCa5DyFzSE/+iqjCJt7Q9s8OcBB/MP5bmtQVN3AdRwQAjyR11pfAfrSW7sHeDxYXm6HJp+enSglz8aUWofHm0PG5P56uCzFp9bdGN9
 81ZA0Za6
 kRG1CgyZfIfVroa+yWCsnFRyVpRwXgmljqoo5YOwuF1tFizSl1mAo+wslHBklZtGxh0zVswpV7ildQVw4PWJlbKadN6FG+6H6OcMDHuLV4GgsEXTBm80HOCk864NDWnddqvDUO+1KZjhcHX/sVBC0BUYKt+QZ2kxXnqXeOhK6pA8JaDBB5uIGy//lzkGps5sclc3gR8kB2tRq5gnVYKtQvj7DMUm6P7JPaQgdNn/PSeMx5Gm9mb65x1DpbNQhfltJZoqmY2Za1UybcwKs9E0SaDv+W6B6UCBIR8yMrL9YFiO9/JxblyGP5swQuJHJ5apWO2DV/Oj7InVIdoJR+yzhHTD3oORPRz92wRE/JbW0RP009MVsbJN5G/9r/H2XjesEaTDIEogB9+3doBNIvAztlRoLCoX9z9dPJULLeOwZaE7LdYWzE/31R0Ldyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add mlock2-tests cases for a zero length at aligned and unaligned
addresses, for a length that wraps when rounded to pages, and for an
overflowing start + len, checking the return value and VmLck. The
overflow cases expect -EINVAL with and without CAP_IPC_LOCK, so running
the test unprivileged also covers the errno that used to depend on it.

The wrapping cases assume the test is built for the kernel's word size: a
32-bit binary on a 64-bit kernel cannot pass a range that wraps.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 tools/testing/selftests/mm/mlock2-tests.c | 191 +++++++++++++++++++++-
 1 file changed, 190 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mlock2-tests.c b/tools/testing/selftests/mm/mlock2-tests.c
index 144b550813a6..3dca349c4738 100644
--- a/tools/testing/selftests/mm/mlock2-tests.c
+++ b/tools/testing/selftests/mm/mlock2-tests.c
@@ -2,6 +2,7 @@
 #define _GNU_SOURCE
 #include <sys/mman.h>
 #include <linux/mman.h>
+#include <limits.h>
 #include <stdint.h>
 #include <unistd.h>
 #include <string.h>
@@ -91,6 +92,7 @@ static bool is_vmflag_set(unsigned long addr, const char *vmflag)
 #define SIZE "Size:"
 #define RSS  "Rss:"
 #define LOCKED "lo"
+#define VMLCK "VmLck:"

 static unsigned long get_value_for_name(unsigned long addr, const char *name)
 {
@@ -177,6 +179,27 @@ static int unlock_lock_check(char *map, bool mlock_supported)
 	return 1;
 }

+static unsigned long get_vmlck(void)
+{
+	unsigned long vmlck;
+	char line[1024];
+	FILE *file;
+
+	file = fopen("/proc/self/status", "r");
+	if (!file)
+		ksft_exit_fail_msg("fopen: %s\n", strerror(errno));
+
+	while (fgets(line, sizeof(line), file)) {
+		if (sscanf(line, VMLCK "\t%lu kB", &vmlck) == 1) {
+			fclose(file);
+			return vmlck << 10;
+		}
+	}
+
+	fclose(file);
+	ksft_exit_fail_msg("cannot parse VmLck in /proc/self/status\n");
+}
+
 static void test_mlock_lock(void)
 {
 	char *map;
@@ -204,6 +227,167 @@ static void test_mlock_lock(void)
 	munmap(map, 2 * page_size);
 }

+static void test_mlock_zero_length(void)
+{
+	unsigned long page_size = getpagesize();
+	unsigned long vmlck_before, vmlck_after;
+	char *map;
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
+
+	vmlck_before = get_vmlck();
+	ksft_test_result(!mlock(map, 0),
+			 "%s: zero length mlock() at an aligned address\n", __func__);
+	vmlck_after = get_vmlck();
+	ksft_test_result(vmlck_before == vmlck_after,
+			 "%s: zero length mlock() at an aligned address locked nothing\n",
+			 __func__);
+
+	vmlck_before = get_vmlck();
+	ksft_test_result(!mlock(map + 5, 0),
+			 "%s: zero length mlock() at an unaligned address\n", __func__);
+	vmlck_after = get_vmlck();
+	ksft_test_result(vmlck_before == vmlck_after,
+			 "%s: zero length mlock() at an unaligned address locked nothing\n",
+			 __func__);
+
+	munmap(map, 2 * page_size);
+}
+
+static void test_munlock_zero_length(void)
+{
+	unsigned long page_size = getpagesize();
+	unsigned long vmlck_before, vmlck_after;
+	char *map;
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
+
+	if (mlock(map, 2 * page_size)) {
+		munmap(map, 2 * page_size);
+		ksft_exit_fail_msg("mlock(): %s\n", strerror(errno));
+	}
+
+	vmlck_before = get_vmlck();
+	ksft_test_result(vmlck_before > 0,
+			 "%s: the range to release is accounted as locked\n",
+			 __func__);
+	ksft_test_result(!munlock(map + 5, 0),
+			 "%s: zero length munlock() at an unaligned address\n", __func__);
+	vmlck_after = get_vmlck();
+	ksft_test_result(vmlck_before == vmlck_after,
+			 "%s: zero length munlock() at an unaligned address released nothing\n",
+			 __func__);
+
+	munmap(map, 2 * page_size);
+}
+
+static void test_mlock_length_wrap(void)
+{
+	unsigned long page_size = getpagesize();
+	unsigned long vmlck_before, vmlck_after;
+	char *map;
+	int ret;
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
+
+	vmlck_before = get_vmlck();
+	errno = 0;
+	ret = mlock(map, ULONG_MAX);
+	ksft_test_result(ret == -1 && errno == EINVAL,
+			 "%s: mlock() with a wrapping length is rejected\n",
+			 __func__);
+
+	vmlck_after = get_vmlck();
+	ksft_test_result(vmlck_before == vmlck_after,
+			 "%s: mlock() with a wrapping length locked nothing\n",
+			 __func__);
+
+	vmlck_before = get_vmlck();
+	errno = 0;
+	ret = mlock(map + 5, ULONG_MAX);
+	ksft_test_result(ret == -1 && errno == EINVAL,
+			 "%s: unaligned mlock() with a wrapping length is rejected\n",
+			 __func__);
+
+	vmlck_after = get_vmlck();
+	ksft_test_result(vmlck_before == vmlck_after,
+			 "%s: unaligned mlock() with a wrapping length locked nothing\n",
+			 __func__);
+
+	munmap(map, 2 * page_size);
+}
+
+static void test_mlock_addr_overflow(void)
+{
+	unsigned long page_size = getpagesize();
+	unsigned long vmlck_before, vmlck_after;
+	size_t len;
+	char *map;
+	int ret;
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
+
+	/* addr + len wraps to 0 */
+	len = (size_t)(0UL - (unsigned long)map);
+
+	/* -EINVAL with or without CAP_IPC_LOCK */
+	vmlck_before = get_vmlck();
+	errno = 0;
+	ret = mlock(map, len);
+	ksft_test_result(ret == -1 && errno == EINVAL,
+			 "%s: mlock() with an overflowing addr + len is rejected\n",
+			 __func__);
+
+	vmlck_after = get_vmlck();
+	ksft_test_result(vmlck_before == vmlck_after,
+			 "%s: mlock() with an overflowing addr + len locked nothing\n",
+			 __func__);
+
+	munmap(map, 2 * page_size);
+}
+
+static void test_munlock_range_overflow(void)
+{
+	unsigned long page_size = getpagesize();
+	size_t len;
+	char *map;
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
+
+	errno = 0;
+	ksft_test_result(munlock(map, ULONG_MAX) == -1 && errno == EINVAL,
+			 "%s: munlock() with a wrapping length is rejected\n",
+			 __func__);
+
+	errno = 0;
+	ksft_test_result(munlock(map + 5, ULONG_MAX) == -1 && errno == EINVAL,
+			 "%s: unaligned munlock() with a wrapping length is rejected\n",
+			 __func__);
+
+	len = (size_t)(0UL - (unsigned long)map);
+	errno = 0;
+	ksft_test_result(munlock(map, len) == -1 && errno == EINVAL,
+			 "%s: munlock() with an overflowing addr + len is rejected\n",
+			 __func__);
+
+	munmap(map, 2 * page_size);
+}
+
 static int onfault_check(char *map)
 {
 	*map = 'a';
@@ -506,9 +690,14 @@ int main(int argc, char **argv)

 	munmap(map, size);

-	ksft_set_plan(15);
+	ksft_set_plan(31);

 	test_mlock_lock();
+	test_mlock_zero_length();
+	test_munlock_zero_length();
+	test_mlock_length_wrap();
+	test_mlock_addr_overflow();
+	test_munlock_range_overflow();
 	test_mlock_onfault();
 	test_munlockall0();
 	test_munlockall1();
--
2.55.0


