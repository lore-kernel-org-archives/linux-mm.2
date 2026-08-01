Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39970C54FCD
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 06:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 586446B008A; Sat,  1 Aug 2026 02:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F1676B0092; Sat,  1 Aug 2026 02:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38B3F6B0093; Sat,  1 Aug 2026 02:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09C906B008A
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 02:27:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 675F3C0252
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 06:27:00 +0000 (UTC)
X-FDA: 85051717800.20.A0ECEF1
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8AF12120007
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 06:26:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="l8i/PYxx";
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785565618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N8stx6QvPfTkiuk/kES36f5Gwycdy/i4pO9WmWrwrHc=;
	b=YjDMCkN6WK+9lrCDPvBDiNkn1DacElt5IvaA+Ii4zTk8lB2w2tHZiGP5gucvlR9Pl6j7GZ
	5oCC/ihFxPJdyJw/1egUtw7A/r2znLn2HYMnOxeHO53g6L8zMSOZ/wanIf9QgGGwvBGlj2
	3RkFBXfeOsFGbAbGgsKQrjv3cC23SaE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785565618;
	b=AP1CfglCOPkxg8OnVsYVLis2lTx66i9F3po9aS0UJiYSuAMYg3wH9DNQMt4dK+lFqCcYTX
	xITs2IrTia2PVycw6eCgo3yQxxXxJmiI5zymk8tIFPUiGqp+cp+9RLOAWc7dY3B5FfuwXe
	LaCocNK5K2ANWyt3WoNNK3+Ht2BA81s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="l8i/PYxx";
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785565614; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=N8stx6QvPfTkiuk/kES36f5Gwycdy/i4pO9WmWrwrHc=;
	b=l8i/PYxxj2BbqFKGHf1HqYEq55LDpZ2AnFNzrCapEdT5Co5X9WyVFYcR6IVkX/R4DLGvjwNlZA4rHIhkMq6CCWlLn1MjGwGAGF9XkLfIYqQgW53UggnPdXmoLZAlK0vjr7slZzLgE4goQPZ8RMGXCmf7B6ZpxwOVJ2O3Z8yO/xk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X89cw8M_1785565611;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X89cw8M_1785565611 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 01 Aug 2026 14:26:51 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] selftests: mm: implement the mTHP-sized hugepage check helpers
Date: Sat,  1 Aug 2026 14:26:37 +0800
Message-ID: <eb75f6d510fb48f14e25fde85e5a5e2b67cef394.1785564857.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8AF12120007
X-Stat-Signature: ypia5eap7bar3uaanmudjac9d1rrq6eh
X-HE-Tag: 1785565617-730065
X-HE-Meta: U2FsdGVkX19W0jaltKLKIqdvdTn5StTDDogFi1dVqkBl05uEZJ2u6vpYILEFRQz5bU3cNmQb+JAWWAzOEbNqrpEJ/v7LthgapuCnPBENhsfS+KStrC496rvIh2Gy6F6VNqdc+TsgwUkhiOhN9YoA/Sb6Vo3Jd3L0FkvjUx6aeZBPWFU061zIK2OC7QVEoM5TVHPkToVG00Udg7/sHf1sN2dBLnv7NhISDck/IX6oag26J83YJ5zDsjbySMVR2KWhySOqYw84mvkBTUTpaOxYrzRHE6ho97m0wqlfLva3K/0Cvf7Suf8MteUtrC0o1SgktQhaEUYU+AZmsUXQGviD721dpiJiTqaqzZt4HZ67ziJQAYOttddFBm/quHVrhpADV8hH/RSAlK3OvHi0vg4ZX/SbIjSL5kprLL0P+LuW32V2Ar5M1Tzf+vFfYFvB5vetXPqzZ8xGX25/WzCtpJlXdNlZWPfHdE4s9iehQFnXFOXOXdJOwDjXcAwS6dCq9SnPi1L/gHgmY9y4gar33ayOBa7Bonj1ilrc7pPhsvBsC+LmV6106q0cQUg4C5ZAwi/RK8fHgTXCPiJyjPc+ErsDOW3eAWNPNU72cqDGwdwEXahaNaEN5dNyrS+y1im7/kwvwaKE5qFA9/LNfOJiIfC8fqnDmTmeu5QRc3w+ihWcliubEb8vH4FUjCCNYl2HmkixBmC6SBZG9dUsavhqsE2SrqYoJ2CsdoAowEHqfo6HB3zx4XnmTqingniQnEbXJbC3KKLIl+X1DCLtbqANovFERe3tKLiQHMjBTwrm6fva+SgEQ97ASzmMKmvLKhdTuv2vkGe2pyfNoCz2gPrHxuN6JEMw1yJRAKOSdM5JVaNJ5ueyXQEYe6A6SoEqIAX8pXH+ZE/eHYzeANmkmNnvsmzTvTDRf0HA96diWFJSQpvMV2NaSneoSEmmjOgLdirtvYe+SHrooBqOxH/2ZLbDOGJ
 68XcTrQd
 DXJ5CT3Pritp3oarEdX//PYrAt6LmMHv6AHHYH0FIdxhx1cRjpugr9Rx/6DibGfi/JI+Fg/S5TGznsuxMDaKoSgfc9wtqG24+zLO6tr6NogXDqKIJguRsQNsCB0EzWQispDjbDXM7UJnbGi6Z4Oei8uP8WJq/50NBbIfUaC9TSKgy0hs9Ac9GfWtPdAR/dvCUBDGrd/f/IpwDF3qgl9Oxd4FaVKMc7L0C+jlWR+w4GS9vYlNfZw9nCgVind4xo24yLSKo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement mTHP-sized hugepage checking helpers using gather_folio_orders().
Also rename the existing PMD-sized huge page check function to
__check_pmd_huge() for clarity.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 tools/testing/selftests/mm/vm_util.c | 60 ++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 09e5d5cabe21..1240d783669c 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -15,6 +15,10 @@
 #define SMAP_FILE_PATH "/proc/self/smaps"
 #define STATUS_FILE_PATH "/proc/self/status"
 #define MAX_LINE_LENGTH 500
+#define PAGEMAP_PATH "/proc/self/pagemap"
+#define KPAGEFLAGS_PATH "/proc/kpageflags"
+#define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
+#define NR_ORDERS 20
 
 unsigned int __page_size;
 unsigned int __page_shift;
@@ -348,7 +352,7 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
 	return entry;
 }
 
-bool __check_huge(void *addr, char *pattern, int nr_hpages,
+static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
 		  uint64_t hpage_size)
 {
 	char buffer[MAX_LINE_LENGTH];
@@ -366,19 +370,67 @@ bool __check_huge(void *addr, char *pattern, int nr_hpages,
 	return thp == (nr_hpages * (hpage_size >> 10));
 }
 
+static bool check_large_folios(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
+{
+	int order = 0, pagesize = getpagesize();
+	int nr_pages = hpage_size / pagesize;
+	int pagemap_fd, kpageflags_fd;
+	int orders[NR_ORDERS], status;
+	bool ret = false;
+
+	if (nr_pages > 0)
+		order = GET_ORDER(nr_pages);
+
+	if (!order || order >= NR_ORDERS)
+		ksft_exit_fail_msg("invalid order\n");
+
+	memset(orders, 0, sizeof(int) * NR_ORDERS);
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
+			kpageflags_fd, orders, NR_ORDERS);
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
 
 bool check_huge_file(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
 {
-	return __check_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
+	if (hpage_size == read_pmd_pagesize())
+		return __check_pmd_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
+
+	return check_large_folios(addr, size, nr_hpages, hpage_size);
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
2.47.3


