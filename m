Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5522CD6E55
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 05:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FC276B00FE; Sun, 31 May 2026 01:58:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7936B0100; Sun, 31 May 2026 01:58:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525206B0101; Sun, 31 May 2026 01:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A07F6B00FE
	for <linux-mm@kvack.org>; Sun, 31 May 2026 01:58:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D77E9C1BAB
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:58:38 +0000 (UTC)
X-FDA: 84826660716.22.7C74672
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf05.hostedemail.com (Postfix) with ESMTP id 151CF100003
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:58:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fPmIaQgA;
	spf=pass (imf05.hostedemail.com: domain of 3C84baggKCG4VUMcUkMZSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3C84baggKCG4VUMcUkMZSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780207117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nv+dqUY9M7caT19LqyoDWfIhP+5KrZo4lI6j0vjgDSg=;
	b=F2PSuIX7yAB8snBgxgUIC8HR2H7vHoHS+nReLq71FGhAJjklr2Q8sWKnFGfzqtYxLxe/hd
	kU5nkvZ2B6bP19pekPf7ggwAQt+2RXaLQ2zGnSYLA0FFnu/z2lcc3JRChqBYzRuDAFLhLc
	/G7lXk4s7zgdBGv7dr7Hsntiy5DYJ9c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fPmIaQgA;
	spf=pass (imf05.hostedemail.com: domain of 3C84baggKCG4VUMcUkMZSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3C84baggKCG4VUMcUkMZSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780207117; a=rsa-sha256;
	cv=none;
	b=YFkWxPfI/mDq/xpWnkJXHHjFrGk4BLq7DyV1l04LuRPuLevZvHisgtycrxPmJNRWGQ3NRb
	pZlCJUrhZSxHcYRt/GeU42N0KHJEsLnDw+el1svyOjFUPX3B0Kbnu76BY/FS8ITfHD94L6
	v9o9lnUvdqxpnU6pXbEb3KYVH/jfQ0U=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c0532a6588so8754115ad.0
        for <linux-mm@kvack.org>; Sat, 30 May 2026 22:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780207116; x=1780811916; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nv+dqUY9M7caT19LqyoDWfIhP+5KrZo4lI6j0vjgDSg=;
        b=fPmIaQgAOiCyjF0OAVZuy0f2WaTvvbQIiWWVBL+ctxTWYIAobYiyiVkNQR321JuQ7A
         gvYSRXKM6GMXd4XbAuoUIWhDDqX76vdqXRW/L1EGfS2Fp0tASo6JAvM0K2IHUcoq5+Ic
         MckhWYLz7yrWyQGKUB3lyfK2Mt0UL2/7N5gYveMdxJaKdncQtJTrk3PyQjvLXtdsfDmz
         v6YpNfMAjMUlDoITtC0LwBzts3tXjqf2KryMkx5ncHHKYOAi5eUVq0LelrTZsjnLk3ty
         zncZnHLVQLz8UDCQERRRZ9QnBhdjg8nDJqcwjll80jS1ogDSH/ahbGV9HAuo5nuzbu38
         L1gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780207116; x=1780811916;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nv+dqUY9M7caT19LqyoDWfIhP+5KrZo4lI6j0vjgDSg=;
        b=Y8rROL8C75X6aCoLXWvvXca3zugsqLAwzpHadfbUStJlRhwVeAK6nIvtFkfgyOPI+1
         TpDEbDYsVRPBtvAtuEV2gmg9BogQwG/ewS84VZCPiZUxXfzfXdXmT4vkO3PXUnCDl9ys
         0yM9RHjvHTUgooa0J2SWVbfpck3a181Nncs1Wowe11PG5J0yTBXxf6nnAu4D8Jr+vUWb
         HfcJjQ/+lUpO0CF+xs0I/bfH8+FQCbR/omf8C01jC/ULSiZ7LDd9fIHRvJWaeXulRmtn
         3wTFfInHAH5bs1ZbqLv3Y4zI6o088bkX3/BNBLs4+CPLcTRXjpei55Z+XUnHGBvLE/xo
         96tQ==
X-Forwarded-Encrypted: i=1; AFNElJ+tZGM1tQWBvk7tlNgpAMQc1h8X84D2YcsHNHU9UGFavsTvgNNX8x3u6axW5nyxyAMtVueFYSNs3g==@kvack.org
X-Gm-Message-State: AOJu0Yz/SEy8QEHnAgAHr5lsmuQ+aCcajtRha6m7UNfhvDZ+ozXL6ckt
	pnjtx+canMJ1tDoYW39K08k+JhTQVXf/ls6WC5N8es/OXFR7mDo8HWzxY+ouKUzL3X5ZIqWES07
	MTndfq5+G/GhcPw==
X-Received: from pghu10.prod.google.com ([2002:a63:ef0a:0:b0:c79:81bb:79df])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5848:b0:36b:afa0:c676 with SMTP id 98e67ed59e1d1-36c68476da9mr5562659a91.22.1780207115665;
 Sat, 30 May 2026 22:58:35 -0700 (PDT)
Date: Sun, 31 May 2026 05:58:29 +0000
In-Reply-To: <20260531055829.3636554-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20260531055829.3636554-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260531055829.3636554-5-jiaqiyan@google.com>
Subject: [PATCH v5 4/4] selftests/mm: add hard memory failure anonymous 1G
 HugeTLB page test
From: Jiaqi Yan <jiaqiyan@google.com>
To: ljs@kernel.org, linmiaohe@huawei.com, osalvador@kernel.org, ziy@nvidia.com, 
	harry.yoo@oracle.com, willy@infradead.org
Cc: osalvador@suse.de, lorenzo.stoakes@oracle.com, jackmanb@google.com, 
	hannes@cmpxchg.org, nao.horiguchi@gmail.com, david@kernel.org, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	liam@infradead.org, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 151CF100003
X-Stat-Signature: zt5s7hojc9o3jrghtr181md7ppmq4zop
X-HE-Tag: 1780207116-152967
X-HE-Meta: U2FsdGVkX18lX24nqsuhgQru31DogJYy/Nh4IcAwZlhXTppYD5AHjkoWUI01onqr3iVm352TSIEjg2h1c6WtzEnXZiG7zL1GMMtSVzdWaaKtVxQ1WPD+W4kAZBSeCA0yFd3AAwh3lo5VS5K+1CuE+3Xjsphb39CcN8SnuAz6BoXl20nfTWcmB3aqf8a2GKvqBJefWO5dC3w6yUdQcQPHe5fyG9GmpeKID5UQZ1Goi2pnbO0RoJZe6m1pNhAVxWvd+o1MD6Dkt9QTKZwz4MQTvJiAF2gIYRFaH6L6wu1XuQHZ0Tsw9ev4n1CZbFzAT3pcrbdxV+TQ1TvmCN9tBmtihgfEMKzh9Oe4KgNq0ObaOWhbUz/rlQLa+DgqjV8tyx3uxMMdlzfgXa6aaRFieKcFMmupYwf4eWNKcJZNIdMRKIpJV7ylgT308uJQS6uQE8xAViNOv7aRMe4m5SxBrtVeygWDj825sPJ7IqjDLRp/y9j1k8zfrPl4hjLNbRiD+aPxu2Oz4z3xMilwn8r2CrxQALXtHye8r49F70ehHtsdOeHELzxFiLOdjCa0roeR5JZSFWPm50BDdbt+s+TmoNfovT5U4IQdUbgpv1B++A7Ra8pjMvGGA6WpPOGhGzzp9y00ugCle6OjRzwospg9y0Ag4/X7j8JrMZ/NyFmfR8HuYj3EYoK6XPUaLCv7Qjp/KdvrokihF7u6rnPLQCK4FyO2di0+OBTnwPa8SaFQTlQURaEkC6uY8Nct+xF4AHTWk/ywEy0ghYYEO7cnrs9hDJZrMYOahKvblwgAxdI3aTNi3HqFec2pWHQeJ7uO1sTauBjs7OnUVes2be8Nz+ckt6qLEQT8evlBuMODR6NMqAaabzobXDY3JF+5TiEHj1bRB0x+hpIrCUuhZR4H3f2vJv8wx4/gvIFXJWm8XHN2B61tzZspqzlwewHM+ikDh0jg38eHwZuCRYGdN6DXpCul7ZW
 8+JwIzvB
 EVx9xR5ESQ0FHHMEa1V7RnIcJ5R6Uq2wRzhISrTUQnwrtMVUABKs+2U0pyMZLzskoLb/lcPx0k8ZBysHU4RmiekrmXsyGfgHTsFS/6Jk5KSD6DxAr/HuA3x0MD7CGGeg9cteuAKskvR208qkoAcYC/RqdCpKfx/cWI4KjsT9LGADQbzGyWMZACZZ6Fqdl1DcUBA/HUzTXdRrnmU6Q9e2gT/VNm5+TC+ADZPQz0V62NMquh03A6l0DLGfeMJJK0zeUurZBliWyRpb5dHsebPs8c7NYLP0Zwfaojl0OuBiY2DmlhAmTocbs++qztaaZryj2qEjoqt1bycSo1kijLqgwR14P6PsCj86XFroHir8vyqs/G2bCXT0SWj1lp+Qbu32TN3zVSc+OMHNE/EJAKkHCvIVL475eYwrZ/gVJ4izNDp0PFcSF7yd572Uw/SE1hGc7U3+9J0TVc6/R71/XM3e09hScapwBuO2SDMk2cNUNBhQLqEgCwQ0XpS0L10fRxEJCsyPcwqsm2GrtqagRIdNKNKAGqwhuYe9GrfwlkayjuvMfRqREzNYwo3/cFFMsmIla5Y1TpTbL9ng6g4qH0d+631I0WhkjVkdnjW63EhfE8XuDfK6WrRBWOFpF7AcVsSVhJN0O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new testcase to validate memory failure recovery for HWPoison
anonymous 1G HugeTLB page, including proper SIGBUS delivery,
releasing a 1G HugeTLB page containing one HWPoison page to buddy
allocator, and isolation of the raw HWPoison page.

Although can be added in future, this patch does not support testing
the MADV_SOFT variant.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 tools/testing/selftests/mm/memory-failure.c | 73 +++++++++++++++++++--
 1 file changed, 68 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
index 032ed952057c..ea43b2877c81 100644
--- a/tools/testing/selftests/mm/memory-failure.c
+++ b/tools/testing/selftests/mm/memory-failure.c
@@ -18,6 +18,7 @@
 #include <linux/magic.h>
 #include <errno.h>
 
+#include "hugepage_settings.h"
 #include "vm_util.h"
 
 enum inject_type {
@@ -27,6 +28,7 @@ enum inject_type {
 
 enum result_type {
 	MADV_HARD_ANON,
+	MADV_HARD_ANON_HUGETLB,
 	MADV_HARD_CLEAN_PAGECACHE,
 	MADV_HARD_DIRTY_PAGECACHE,
 	MADV_SOFT_ANON,
@@ -47,6 +49,8 @@ FIXTURE(memory_failure)
 	int pagemap_fd;
 	int kpageflags_fd;
 	bool triggered;
+	/* Number of initial HugeTLB pages with default page size. */
+	unsigned long nr_hugetlb_pages;
 };
 
 FIXTURE_VARIANT(memory_failure)
@@ -157,11 +161,11 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 		  void *vaddr, enum result_type type, int setjmp)
 {
 	unsigned long size;
+	unsigned long nr_hugetlb_pages;
 	uint64_t pfn_flags;
 
 	switch (type) {
 	case MADV_SOFT_ANON:
-	case MADV_HARD_CLEAN_PAGECACHE:
 	case MADV_SOFT_CLEAN_PAGECACHE:
 	case MADV_SOFT_DIRTY_PAGECACHE:
 		/* It is not expected to receive a SIGBUS signal. */
@@ -174,6 +178,7 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 		ASSERT_NE(pagemap_get_pfn(self->pagemap_fd, vaddr), self->pfn);
 		break;
 	case MADV_HARD_ANON:
+	case MADV_HARD_ANON_HUGETLB:
 	case MADV_HARD_DIRTY_PAGECACHE:
 		/* The SIGBUS signal should have been received. */
 		ASSERT_EQ(setjmp, 1);
@@ -183,17 +188,36 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 		ASSERT_EQ(siginfo.si_code, BUS_MCEERR_AR);
 		ASSERT_EQ(1UL << siginfo.si_addr_lsb, self->page_size);
 		ASSERT_EQ(siginfo.si_addr, vaddr);
-
-		/* XXX Check backing pte is hwpoison entry when supported. */
-		ASSERT_TRUE(pagemap_is_swapped(self->pagemap_fd, vaddr));
 		break;
 	default:
 		SKIP(return, "unexpected inject type %d.\n", type);
 	}
 
+	if (type == MADV_HARD_ANON || type == MADV_HARD_DIRTY_PAGECACHE) {
+		/*
+		 * Check backing pte is hwpoison entry when supported.
+		 * Although try_to_unmap_one() also installs hwpoison entry
+		 * for HugeTLB, pagemap_hugetlb_range() doesn't parse
+		 * swap entries at all.
+		 */
+		ASSERT_TRUE(pagemap_is_swapped(self->pagemap_fd, vaddr));
+	}
+
 	/* Check if the value of HardwareCorrupted has increased. */
 	ASSERT_EQ(get_hardware_corrupted_size(&size), 0);
-	ASSERT_EQ(size, self->corrupted_size + self->page_size / 1024);
+
+	if (type == MADV_HARD_ANON_HUGETLB) {
+		/*
+		 * Only one page is hardware corrupted; the rest should all be
+		 * released to buddy allocator.
+		 */
+		ASSERT_EQ(size, self->corrupted_size + getpagesize() / 1024);
+		/* HugeTLB should have lost the HWPoison HugeTLB page. */
+		nr_hugetlb_pages = hugetlb_nr_default_pages();
+		ASSERT_EQ(nr_hugetlb_pages + 1, self->nr_hugetlb_pages);
+	} else {
+		ASSERT_EQ(size, self->corrupted_size + self->page_size / 1024);
+	}
 
 	/* Check if HWPoison flag is set. */
 	ASSERT_EQ(pageflags_get(self->pfn, self->kpageflags_fd, &pfn_flags), 0);
@@ -247,6 +271,45 @@ TEST_F(memory_failure, anon)
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 }
 
+TEST_F(memory_failure, anon_hugetlb)
+{
+	char *addr;
+	int ret;
+	const unsigned long nr_alloc_hugetlb_pages = 4;
+	unsigned long alloc_size;
+
+	if (variant->type == MADV_SOFT)
+		SKIP(return, "Soft offline test is not implemented");
+
+	/* HugeTLB settings will be automatically restored when test exits. */
+	hugetlb_setup_default(nr_alloc_hugetlb_pages);
+
+	alloc_size = default_huge_page_size() * nr_alloc_hugetlb_pages;
+	self->page_size = default_huge_page_size();
+	self->nr_hugetlb_pages = hugetlb_nr_default_pages();
+
+	addr = mmap(0, alloc_size, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE | MAP_HUGETLB, -1, 0);
+	if (addr == MAP_FAILED)
+		SKIP(return, "mmap failed, not enough memory or 1G hugetlb not supported.\n");
+	memset(addr, 0xce, alloc_size);
+
+	prepare(_metadata, self, addr);
+
+	ret = sigsetjmp(signal_jmp_buf, 1);
+	if (!self->triggered) {
+		self->triggered = true;
+		ASSERT_EQ(variant->inject(self, addr), 0);
+		FORCE_READ(*addr);
+	}
+
+	check(_metadata, self, addr, MADV_HARD_ANON_HUGETLB, ret);
+
+	cleanup(_metadata, self, addr);
+
+	ASSERT_EQ(munmap(addr, alloc_size), 0);
+}
+
 static int prepare_file(const char *fname, unsigned long size)
 {
 	int fd;
-- 
2.54.0.823.g6e5bcc1fc9-goog


