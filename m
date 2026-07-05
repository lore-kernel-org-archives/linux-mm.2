Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17D8DC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 18:07:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F2646B00A6; Sun,  5 Jul 2026 14:07:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CAD96B00A7; Sun,  5 Jul 2026 14:07:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED30D6B00A9; Sun,  5 Jul 2026 14:07:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2D836B00A6
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 14:07:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F5AC1C0E75
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 18:07:24 +0000 (UTC)
X-FDA: 84955505208.04.01E7E1C
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf31.hostedemail.com (Postfix) with ESMTP id 81ED720006
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 18:07:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aM31XWHY;
	spf=pass (imf31.hostedemail.com: domain of 3WZ1KaggKCBg76yE6MyB4CC492.0CA96BIL-AA8Jy08.CF4@flex--jiaqiyan.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3WZ1KaggKCBg76yE6MyB4CC492.0CA96BIL-AA8Jy08.CF4@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783274842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rKIWvJIJG94eUvc0OXWaFW4RSMlfE+I0cCCIFWwNnGw=;
	b=k/A2wShdbH1OD3IcxomMHF4JlhwsH6PTpY94ES8VCj+LpKtUNvtmQiXQtvhiKIcjqSqJQQ
	jbNx3JmtRPhPzAi57zPvpnI5WKb0VXywbHwPlETc3TZkKoqyp4jiZUQ6jZGu8ebjPoGaI3
	5TC2ZWwPSc0e3nTvFCMZO3HjPFIXpek=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aM31XWHY;
	spf=pass (imf31.hostedemail.com: domain of 3WZ1KaggKCBg76yE6MyB4CC492.0CA96BIL-AA8Jy08.CF4@flex--jiaqiyan.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3WZ1KaggKCBg76yE6MyB4CC492.0CA96BIL-AA8Jy08.CF4@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783274842;
	b=4LwaYdwotktB0+MXFp7L8DoMOUlHQ7hibsWlJ76EnTeO/CRweAogCMNN1Zn/KGsKHODamo
	hGD9rUo/Z9O7zNJ/LwZbvAstdiPb1Hue4mdWOhxG1NSpFYBBe7sT1UAePYmnIm70y13Au7
	INnwWhFNBgQ2e6PJetHhN1yqmxE25Qc=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8479b45ad08so3782459b3a.3
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 11:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783274841; x=1783879641; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rKIWvJIJG94eUvc0OXWaFW4RSMlfE+I0cCCIFWwNnGw=;
        b=aM31XWHYHK75j2VeZ4Yg2mhjC73auKeNNSQ55ZGb3Kbr+F6Y0esy7sZYNEPjywPSH+
         +lynp7LMNMRUpIHuUt8479YacK5bxRuOZJywMiglnuTowpdpQUw2Kuu6lD5iAtD8n0Ub
         SQwdwUI2Igebsltc6x2QLtTGU+nCditJvxOuOOAfvBvNaYtAC/TJ3igZsHfldoFtyxBy
         oXuOpRXl0QDNYTgnI6bzFqoHbmfUdWgx9aW2nRgdQ10rtoG/me38PpIrVpkEMT+LJKvI
         vEt0jOecvMpMr5oOcgHjuIKuhi17b+CPh013NcZDklXPrNlCJPRN+7gRXez98D8QQY7W
         xyMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783274841; x=1783879641;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rKIWvJIJG94eUvc0OXWaFW4RSMlfE+I0cCCIFWwNnGw=;
        b=dKLYn732nI5F4Siggl9LvHv9J65Ed/7JzFugbrA7N43KJQOzqIHRJsFXiOEplGbE8t
         /eSwoub+elGEhTl3Ui70AX18d701Z/HW23BuJuNt1EMRnPcbQAgh1lscfbUVFQoAV/Gx
         0ZfC6PAI8OaHmHkE0YPsFz2Z0mQPzWhyPxBI2DVh1zG0iFFH1VsbxA3/dJk5He8mu9AJ
         hB75mlHdoj7uPh/lNh7EUCDObF1AtjniNoX4/x7dDkzFlctazE/OdoeRSwjLtalSgyH/
         /6L3Xh0w5F/yOoEkeieHSgtNwGJ0Jp11OKsmbXxPliRaZ0/Gi3851N3qDWNYS15ZKdxf
         ylRQ==
X-Forwarded-Encrypted: i=1; AHgh+RrpwWdxEDWjgcHS81gFb0M0ZjRJtCh8dZEgkMBKgP+ZNfMt8fqj3MArhO55JFGP3/zUDGKCIA0oPQ==@kvack.org
X-Gm-Message-State: AOJu0YwaXslqqZ+i8zpnRY+g4gPuiYlG2NjHhQvhIU1UT4NKPlJYSmOZ
	PBNdKQbFIUNZfgBVpHqOFhGZJc6X8b1VWHZwxbsrI25QxX4w4UKFIlIrNMt2PK0eG2x7nuaRsO0
	fmyaFey5i/RVhvQ==
X-Received: from pfjq21.prod.google.com ([2002:a05:6a00:895:b0:845:38af:5fa5])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:440c:b0:847:9e62:251 with SMTP id d2e1a72fcca58-847f6f73d82mr6633462b3a.54.1783274841203;
 Sun, 05 Jul 2026 11:07:21 -0700 (PDT)
Date: Sun,  5 Jul 2026 18:07:14 +0000
In-Reply-To: <20260705180714.3708947-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20260705180714.3708947-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260705180714.3708947-6-jiaqiyan@google.com>
Subject: [PATCH v6 5/5] selftests/mm: add hard memory failure anonymous
 HugeTLB test
From: Jiaqi Yan <jiaqiyan@google.com>
To: linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com, vbabka@kernel.org
Cc: osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org, 
	osalvador@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	nao.horiguchi@gmail.com, david@kernel.org, william.roche@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
	akpm@linux-foundation.org, muchun.song@linux.dev, liam@infradead.org, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@suse.cz, 
	rppt@kernel.org, shuah@kernel.org, surenb@google.com, mhocko@suse.com, 
	boudewijn@delta-utec.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 81ED720006
X-Stat-Signature: 4bnh33ksrteqs37z5rk4tdjff1wzgpfe
X-HE-Tag: 1783274842-209104
X-HE-Meta: U2FsdGVkX1+XujWlXNQgJtYCGEn0zypWWjK93EK8CoDHzv8MmA0NaKYFu8RY6apeTZrYsRAuTtca3YocfHTxF8L8GnYUono4nJhir15Vj+5L8OPnzUaWD7t5c3uK3pN1t90rB4uk9Q72mdyIO2BUWvNafCcJMq0RXQeJCM3+EkdqRL7hiBA6Txpgdz9mzVL5784eadNouy+lI5Pa61Y0RfCtqlFr1cDk9CQISvBaesp4BtflNNl626A2MHqNh+O+UR1Zi6zV/4TNyTLf7q5aNdMlR6qq5NHmM5vX53dihBTE3UflieQ/RZwaBI1t4vvLbbnGoGqozSK83IL2uh8lnnM75NWlNeO431YKnJOb90VoU/1hKvHInIhAK8E1FdS1fUe1B4bwloRl9SdVS1VQ1JG53yc+yvvyvKf8obRYxkkfoomjRE5nTCFk86TkaIAWiVUF5SCtAgakDFc1/9GR7DaeruV/YPEK+stujuSXFcixN4b8I+mZA6awMm2j+fxClmwkpNntNSQfYbpsD1d0XmlNkrdCnG41olKm74vMgUFshiiOA5sQgkmc/pYWmhaD59TqOVa1r6kMdL1+F77h1eh8XbfKcjBmO/jgz02C/ZYknUHI9C16IL1wPFUzH8yCCoBGdZ/lcEY1qju5b3F1shJ6wW2st7yGU72mNM2aoR9aGPOXqZfd7UtBFKlhKELGNFnL1qT4JeZdsjjcZ8qVRvO8CMThvPXoo2K7GYCSPRfd+SbrQ3CEq9C9iprEiTZCJjsvojiRoUMw2Uj92871oj/yZq8Yx0cj2xhPp73ZBzB5u0XGUwJZoWBoXXb94q1qzgjidmMNAHERxhM8W3+F5k3DRsHhtWGHe524yROv0rbAz/osgkiahEz/AqKDiXUp118UrWceR4PUoIk5tkfbJ74tsfosb0YhBuL6Wmcl/YTtCyElIYVbLGJOG/4irya7HujnA0r5ORd47qtEs3s
 RRbO3KkP
 TKc2rVLru6za/x2WKuehT3Av4xUOwSMhXiNLl0Qdm7kFCPaJEQST4ucI4knNq9bDFWo0QWs4TQzqlA/rpfiF7SAcUDIhDZ0/fqtOxQwr3UqmrqcY8SRgjFQGxcWlSCp2SmVg6ZdzRHhcLqHboymnlh4iJJk2YhRmZjjDK3/1vxt1thcLh0YMq61fPFsZsd9D89Ai+RG/njhi1xnmHqR/jmF/8HJc9SJhyFYW4L+Tk5qg7NxG1C4WEtw0iSVi5aA3G479fJJTyEspDmUmI9oJKT5YiW5/RbkksfcnymdjgOjL2ctWWVd0T0hkWKq0ivvoORnc0W6AOnCf0RodHZOLeebzHg36gR5BfJeWXp/7FogBmpXjiqsWvfCkCJDWavK7YBFAFUv8oPgAGNam5Ob/1IUpSf+ZFzwzWqOqX+DfPL0L9pfLwnPGM6uBxkP8pgMl+14W/LfYTrEfC00GQdWa5OK3HeRWz9vReivFpcgJzToHqMpEYemc4aUG/DKts0hfNDBL0gIna03fibOIITGDF3mwMUPKlBcAV374SN3EOVBww8Kga8fRsTGVd9WM/JqDf2686HM1IiwY8VURosnNHby+GA0K4alyfKGaeud1loTUaGwf6CXBKJrGXuZXuY1tfw1hk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new testcase to validate memory failure recovery for HWPoison
anonymous HugeTLB page, including proper SIGBUS delivery, releasing
a HugeTLB page containing one HWPoison page to buddy allocator, and
isolation of the raw HWPoison page.

The test uses HugeTLB's default hugesize.

Although can be added in future, this patch does not support testing
the MADV_SOFT variant.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 tools/testing/selftests/mm/memory-failure.c | 70 ++++++++++++++++++++-
 1 file changed, 67 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
index 032ed952057c..78c105ce2af1 100644
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
@@ -157,6 +161,7 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 		  void *vaddr, enum result_type type, int setjmp)
 {
 	unsigned long size;
+	unsigned long nr_hugetlb_pages;
 	uint64_t pfn_flags;
 
 	switch (type) {
@@ -174,6 +179,7 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 		ASSERT_NE(pagemap_get_pfn(self->pagemap_fd, vaddr), self->pfn);
 		break;
 	case MADV_HARD_ANON:
+	case MADV_HARD_ANON_HUGETLB:
 	case MADV_HARD_DIRTY_PAGECACHE:
 		/* The SIGBUS signal should have been received. */
 		ASSERT_EQ(setjmp, 1);
@@ -184,8 +190,15 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 		ASSERT_EQ(1UL << siginfo.si_addr_lsb, self->page_size);
 		ASSERT_EQ(siginfo.si_addr, vaddr);
 
-		/* XXX Check backing pte is hwpoison entry when supported. */
-		ASSERT_TRUE(pagemap_is_swapped(self->pagemap_fd, vaddr));
+		if (type != MADV_HARD_ANON_HUGETLB)
+			/*
+			 * Check backing pte is hwpoison entry when supported.
+			 * Although try_to_unmap_one() also installs hwpoison
+			 * entry for HugeTLB, pagemap_hugetlb_range() doesn't
+			 * parse swap entries at all.
+			 */
+			ASSERT_TRUE(pagemap_is_swapped(self->pagemap_fd, vaddr));
+
 		break;
 	default:
 		SKIP(return, "unexpected inject type %d.\n", type);
@@ -193,7 +206,19 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 
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
@@ -247,6 +272,45 @@ TEST_F(memory_failure, anon)
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
+		SKIP(return, "mmap failed, not enough memory or hugetlb not supported.\n");
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
2.55.0.rc0.799.gd6f94ed593-goog


