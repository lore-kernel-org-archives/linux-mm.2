Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82BA5CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA7328E0045; Wed, 20 Aug 2025 05:07:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D59658E003E; Wed, 20 Aug 2025 05:07:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C20548E0045; Wed, 20 Aug 2025 05:07:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AA4F88E003E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:07:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFCF2C043F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:53 +0000 (UTC)
X-FDA: 83796558426.10.5D6F95C
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9B206C000D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wOsWGyd6;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755680872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0BMZl4FO1A/3YqzLq6Cu8hUlXulJA4evFI5qXofcb4=;
	b=nJPf769dBW7mrfKUh8bEo4tHpTeJkENmgZOy4QgAYxx3awnhM3aws4bE7e+bXZJO7x/53/
	VmdKVqlYABGvtVHTzSL03YAF8kdg2KHQzgM90rXPQtb4HZNmTDxPlcR1UfpxKGIKdtTkQW
	f4fdrcGrJ3PCaoWaT7vvIPLYN1duIGs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wOsWGyd6;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755680872; a=rsa-sha256;
	cv=none;
	b=xw2tiAs82AuAXseW7jqQe5FAzPw9UKn4F6sfLUtfmOB2HdxkUSc+BRAlSQ+vKQvoGNc4rX
	PmHPXJHfwYcEingvMNooIUMxXGT1d1SDIDIQg8vNb81Sf0C26pNhlQjTarLmhHA9BEywHv
	BvEHC3zdLnEKYgaZNZKa5ufsMW1wsn8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755680868; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=k0BMZl4FO1A/3YqzLq6Cu8hUlXulJA4evFI5qXofcb4=;
	b=wOsWGyd6QZWizqVuegyAB1WlZSzg4niiTb6reiLkUuP90XHa+qdOQlCCZREue3kIIPmlQ8YdbxOc+HRErlRfdRXpU+gvCwopGdtA0nEpLTxMJwzvD5IermL70t1i+6aWp7f+V2G9rMjPujbPU+0bdojvbuC5jHHwwtGTFi2HQcA=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmBYU.i_1755680866 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 Aug 2025 17:07:47 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 10/11] selftests: mm: implement the mTHP hugepage check helper
Date: Wed, 20 Aug 2025 17:07:21 +0800
Message-ID: <85ad632e5ac5844a4e8a6266bcd647932e4d0b11.1755677674.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
References: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9B206C000D
X-Rspam-User: 
X-Stat-Signature: kri1otcgm5ftmb13yp5b5d8wxhgk58k6
X-Rspamd-Server: rspam09
X-HE-Tag: 1755680871-203328
X-HE-Meta: U2FsdGVkX19F54pP8pmnZKIpmfS6RDutihUHmiAaSit8XrbE6fgeBHg7uogG+xLNMUtgXQEAnquIEk3NXQTz+Oa6tihoazf0Pt5O99SGJ+mC5TRYkRwylWpuaBAHwT07zxxAL3z4TonDHYtf28KXWFW5I8WSUznqm0Ea3kcxdwmhVRQUXf3x8zED2DSiqUdQk6+P4Z4LLxqzH+WEdjg6YUsp6iGxmhf17Wh9DtFxiadHBnWzQdGnqDi50kOorF30Kdmm+bwp/UiwD8LKcmu9Xv3N/fv76xW8srO0B8LVI97fRqkEWleN5sbN2PoJnumPRIHXdR3QvyujUne7Lw7rm/GBHq3wDSQ0doBfh8jzffZAKha6hvvoC8RWn8yWkS8GDXe81vVGcI7yrsjPwJWS6XM+i+t0tDtqmJIR6VU2gqJb/e7tm1UDQoh2tGE5MSVXFx/GDy7Dv5I/vgqgAjGwzLTBf5AvoGoSJZhpB7L/FWb73PGnvbvgyjUZDZ2uWXjg0KI9WVmOVzkGLyLqEN3xL3Lz146RUtutjVs8Ay3f82ZvaL9d4mCAoJZ2SNOvSQbw2I1nq9CFLrY4TGg2aiEA09o2fcZgOEuH4FBp912GPRobMbL46mzHanhnU3LdgrZxQKT1QRPeWp5lqQCLFoUjV5P/KjHBUeMNB9I2shReeyv7GVUiE+jkpfQOR7xxGEmqj2+a29nTrQ2HvdNpySLnpr6qW5Q8DPjj+aVmqIE4US7yJsHdcw1suiNwgP+CP5Gduul0TQXPrHrPH2lrSIxqcdLUZai8ZzSCSEo59zFQvr95VUdDGWwOW3/7fBRrz24SkY2GLC41IIhrtQ0ZzD0pencAwNkucZGNdjVN1//PxKXLUhVk0wjJ5n/YOtPWshpxdq61sXwz1RLzp8LfJQjRyZMBjwGDDTqVLc/MgLWv2Ru8DEVY3Am4oLUTSR7BBC3AgTIufP7fXsLmkRkZMng
 l8AxB/Nm
 dkYH95MYoqJWhK+IwrbZmc+A/dJyJxmI+rAWqY009fFz989UsYjxFV+5bovldPB+gzYPjtYKKgoZpjnlQwVMpJMJL9ScCNYKp9eD6G7kXln6EpqTQEgUJk+NMBMwGvPloeWWW2AzVX3T2BB6bb5AAfuHornk5sFHdn02ct0PNRNBI2KbAtnwXT1HmhYvkwVsGO2YuAobkJ8h/F2Kb6PiSIhYr9e+bhF3rBwlcRbe19SeHYCGRUvyawVpcwYXxVFxCiJ/Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the mTHP hugepage check helper.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 tools/testing/selftests/mm/vm_util.c | 52 +++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 853c8a4caa1d..d0f8aa66b988 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -16,6 +16,10 @@
 #define SMAP_FILE_PATH "/proc/self/smaps"
 #define STATUS_FILE_PATH "/proc/self/status"
 #define MAX_LINE_LENGTH 500
+#define PAGEMAP_PATH "/proc/self/pagemap"
+#define KPAGEFLAGS_PATH "/proc/kpageflags"
+#define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
+#define NR_ORDERS 20
 
 unsigned int __page_size;
 unsigned int __page_shift;
@@ -353,7 +357,7 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
 	return entry;
 }
 
-bool __check_huge(void *addr, char *pattern, int nr_hpages,
+static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
 		  uint64_t hpage_size)
 {
 	char buffer[MAX_LINE_LENGTH];
@@ -371,19 +375,59 @@ bool __check_huge(void *addr, char *pattern, int nr_hpages,
 	return thp == (nr_hpages * (hpage_size >> 10));
 }
 
+static bool check_large_folios(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
+{
+	int pagesize = getpagesize();
+	int order = GET_ORDER(hpage_size / pagesize);
+	int pagemap_fd, kpageflags_fd;
+	int orders[NR_ORDERS], status;
+	bool ret = false;
+
+	memset(orders, 0, sizeof(int) * NR_ORDERS);
+
+	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
+	if (pagemap_fd == -1)
+		ksft_exit_fail_msg("read pagemap fail\n");
+
+	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
+	if (kpageflags_fd == -1) {
+		close(pagemap_fd);
+		ksft_exit_fail_msg("read kpageflags fail\n");
+	}
+
+	status = gather_folio_orders(addr, size, pagemap_fd,
+				kpageflags_fd, orders, NR_ORDERS);
+	if (status)
+		goto out;
+
+	if (orders[order] == nr_hpages)
+		ret = true;
+
+out:
+	close(pagemap_fd);
+	close(kpageflags_fd);
+	return ret;
+}
+
 bool check_huge_anon(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
 {
-	return __check_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
+	if (hpage_size == read_pmd_pagesize())
+		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
+
+	return check_large_folios(addr, size, nr_hpages, hpage_size);
 }
 
 bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size)
 {
-	return __check_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
+	return __check_pmd_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
 }
 
 bool check_huge_shmem(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
 {
-	return __check_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
+	if (hpage_size == read_pmd_pagesize())
+		return __check_pmd_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
+
+	return check_large_folios(addr, size, nr_hpages, hpage_size);
 }
 
 int64_t allocate_transhuge(void *ptr, int pagemap_fd)
-- 
2.43.5


