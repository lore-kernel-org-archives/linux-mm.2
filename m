Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF79CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DA3E6B009E; Wed, 14 Oct 2026 13:58:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986266B009F; Wed, 14 Oct 2026 13:58:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D9E06B00A0; Wed, 14 Oct 2026 13:58:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 528EB6B009E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:58:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D67FE120719
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:58:15 +0000 (UTC)
X-FDA: 85321990950.17.AAC55A5
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0367710000B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:58:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FgeH0PZq;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792000694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pm6pPP6fM8ccbz50yd0Il8w295cC/To3qr6UZeKC5WE=;
	b=mt0ul0qccD60LSDSCKBngt4EKmwvqYF5+xK/pwZHJwEv69H4OkCEpvpYBGRMjS+kIjvkGL
	0ItSE7BwQcSQRBlxtQrkSnbnovJmgsh9w+xrCV0m3ui6KXtR2FqYRXQIfxeH5jU5b0PDAx
	3rTlVk2SwpzrKqyED+xSqDxf0bUQFOs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FgeH0PZq;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792000694;
	b=CIbffspXOwGDcB3wiD59olhX69VEXrFoxFZOJmby6ic0aOXQoz+ctW3bIEeTwB1/l6qdFH
	EnA58zKvUP3a51sHJvaLfo7LCBmG/yIa0taEf1sMX9hzk0qakZgg2/xBWkmFLnWPpfxPGY
	rk1QBhuyXSAU1V7WBXkihyW4doUM5w0=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-917b78dfe30so71377176d6.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792000693; x=1792605493; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pm6pPP6fM8ccbz50yd0Il8w295cC/To3qr6UZeKC5WE=;
        b=FgeH0PZqDKFu7waMDIaoSNM3HMcefzKkHuY26PutxyRL82emzgCmUK31RuxOxc/vxU
         YzHIVw2hlhl7dGgT1ZNpXznADPWoXmW8uazQdvwujFuU1Ki2yx4VRVfBubkqv3t7Z8wx
         38W2KgOsfpJw+PGnedVMvmldEMcCngYBbQ8/qtPFLnZfVJ+SbVt8iRe9oD5X1j1/ZGg2
         GNyGmg2ab8rtzJdM9hDEJyhsNCgONwW7pLF1ZAR+2fbJr1UIXzzOc0ZMdg9+Cj6Pu/O2
         gSIkZzc5x40tgTqiz7B7tS3vEDGYz/ourP8mljPwM7VGh6u14KgJK06CzenBs16GkcNj
         Zymg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792000693; x=1792605493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pm6pPP6fM8ccbz50yd0Il8w295cC/To3qr6UZeKC5WE=;
        b=Pv9nw5j53xdv4zoKf7kKI0q6vcs2KPNGUFKdLXgD2is0q+RpbJ0Gm+bCqK4m0rZK6z
         pADmlWPrMXBvMTSjzBtXVQ7P33bJIn8j76Jj8JXvxyKOaTZDLKiJrNUvUbXCrL+k03iY
         YaVsv11YHs1YBC4amNfVcwn4ovg1AuwQ9sr0KUoCViwy8Tg6bSsASrwEB8JibJdb2uhP
         LSq6pklEFiXlcnDHkGKrpd/q1fA88stnHWAtyz4+I2vw32lRKILB4Qk6j1Hkw0QF0+rl
         g6F9zOciPnlIaiqgZ9sQvQHiif8Hj+2z+R/nagbw2DrfIXV2rsDVPCUggAaldYzRSn7M
         9NFg==
X-Forwarded-Encrypted: i=1; AKwUvBzHVT++GQCP2dnS20dzRDGdlTWUoHlxA4fY3ENo0vNo1NdiyhJPH5KrNtFKfCin5osqybVw0UgkvA==@kvack.org
X-Gm-Message-State: AFq9FYJlK9AQEE7aUTer8B08L6bN0Axa4LMtCuddOPxAhfjT7rVHP0q/
	xP7epNAeDOYKsdl2tpwg2QNCJg8QaU25LATLeOX8EtUwPuguEZYHaQo+6+01YHyL+sA=
X-Gm-Gg: AYBFou1SWgyhvOMBYrM7nKqyIPGm8nbx6NXD5o/7+1K03LxZJ6pTM9dISD2++rhaZRh
	06gwqm0bnj5aaviNnRcfHu/4KtEgwj54VS9PPraHfCh7aHcdSpy4NNVzh5eQxS91IL7aAWStwuS
	VPzaJlArSlanTEHHB614nn0j7R6YDtVuPAgc/wfNvjnr2QpdYAb5ZB6t66mPrBm+rToD0XUg6Up
	UZhytceCLkB+y2MzkcnoOKSOqw39uWK+XEDczAEEMigKrSzWjI9es1zGRyAzF9EL6Clq6G/mqdI
	l0ahQXsPwNBWCwaW06hNeR3lUJqgeUOvqUiJT05SZQUT1Up6hp8vTjDglBFU73ZKQmK6Ak717r4
	7NfpdCLnkYKY5lTSvxTv0/DBCrRXAKp8PfdjYDnhM34rkfnLQCs2EGFd/nPgFYqV28Tbv90prc/
	6+c9qwVuKkOqjEUdbIUm+5ICodpOIwsySp7Vme11WzULfb2PCNL9TfZmpr7wRzU7q6KcM2KcOu/
	c9GNJaaYlTiBj+Qd6jePjUihF3FYqnnYRFry1wzdNqoYOMOOP5s7OHMIhHI
X-Received: by 2002:a05:620a:3910:b0:93e:f9ba:690f with SMTP id af79cd13be357-93ef9ba7a6emr917103285a.73.1792000693012;
        Wed, 14 Oct 2026 10:58:13 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b95847sm58498006d6.32.2026.10.14.10.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 10:58:12 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Subject: [PATCH 6/8] selftests/mm: check MADV_COLD and MADV_PAGEOUT on partly advised THPs
Date: Wed, 14 Oct 2026 13:57:54 -0400
Message-ID: <20261014175756.2035176-7-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014175756.2035176-1-gourry@gourry.net>
References: <20261014175756.2035176-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0367710000B
X-Rspam-User: 
X-Stat-Signature: phgxo74rnmwxhbatkygy1pbopsuge9wa
X-HE-Tag: 1792000693-103049
X-HE-Meta: U2FsdGVkX1/15f3gudkPlLiEbNMTAIUd/lVuSPyMr4YGhhnC98D8upZy/HyfxKPDewLIy8GDz6anRFEhefFF1kmYKFz+ACrHC9ek00E5GcWaDgKgPdV3DEiiPs1OLVvwq3/w/ywmxFiMNWLq1+fOUIkdVe75XlYttywwkDjie3Tac+VbQmdV8a0Dv2J+kxZQsee0mTuyH5ScVQnCSA+bK8Ogilgx25u/S5/bByYdAykzxoNpGfTW/Tdl62VHvQhuDxjVqa/gzOxI8R8TgVpMr4RZExDl/dIRuHeDD0q2Fhv2CGkOJPHNuoJZRFPzwxxHqxSxb1N7BB4AZziLJXEJhvNp6ljB5JKSkh+TTDBylsoS6pQRTalwHVZZstDWNZdzPwWvdsQSihu7ChQ0Ag9NuVpbZrp9cIvwJ2UN5mz2dafId5t1Eq3cqCfS1hAUaRADUihlXQiRSOIoUFCiWOhfyjb/YMCG2BldAtsF6nkaIxNEYSyzYuviJcHi9wZDyOw7oxeaeQIdHXbDuoaCt5IC8Jr0LYRUMiSTqsf7i2FgimFNUB/DcsaPPT5gRP9LlIoXLBo8bmgGxsi1cb6Zr1BcNmr6YFn9VIVo5D5eU77hP4+2e9pg+0dju5+Tf49nr7Ehx5c0yICfZxl0hbWYpxRsKxl/LzTnIUcSpSDOWYLjZXS5Ja0dS35+89rtgbQpdX5oa1ONmm6oyRnnGm1u+4XoTCz0/98W9tSQhZYLC6xk1JLKGYPfuQ3JfnWDSM25VF/hSPXz94+L/VAJd6X9KGDbp7qVbIPsRcmuBtvssnBrblTh7fRlNHO0uMqUG6vPbJ5bjveYGfz9noDtuDqBguelOuRiv0VPfLaDmtNoM2sBM1L/prvJmPD2ANbOQSNGYekK3fWvaTUY5O7z5dT53Luoa2P2tWN7y+yX8C1it2lZORjLNisnGOlr4WmMgZ61F1kULCYU3uZBelF20PlB0DS
 OCm014a/
 tTkv7t1Xf2zX0iRWnQsQFDb9WEpVMz7nEV/w+YwCPkGUZAGoynWulqCSlT8OjU/jKiLcU12RIcvaXJdYxFwA5Fmdlsj10Yp0AT6iNDZHbIA5sHx/kUanqyYM0CakBwTltPeotkv3muo5C6WDuBa1CVF7644GuD0Qh9B/hNuyjE6NY+joTAcAxFEOUbZbIWzdPdcOAgOkk8jfJsILdbqLsBS3POxc2fPPZJn701c0RMC31NkjUuRUnQP2j7ExaYVHJbeIaqjj/1JgMWE0MsL7m5CTUTUIci/Os2vvRpNAIME0q6K+48PmgUjJ4v1gY4tVLSM50LWh7PlCqbIKbKmWYAvM8XsuJ5OEclvpT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Paging out a THP that the advised range fully covers must not corrupt it.
A THP that the range only partly covers must be split before reclaim, or
skipped, so that no page outside the range is reclaimed. MADV_COLD takes
the same split path.

Check that a whole PMD-mapped THP is swapped intact, that pages outside
the range stay resident after paging out a base page or half of a PMD- or
PTE-mapped THP, and that MADV_COLD on half of either THP preserves its
contents. Tests skip when PMD-sized THPs cannot be allocated, and with
/proc/kpageflags the PTE-mapped cases also confirm the folio stayed large.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 tools/testing/selftests/mm/madvise.c | 234 +++++++++++++++++++++++++++
 1 file changed, 234 insertions(+)

diff --git a/tools/testing/selftests/mm/madvise.c b/tools/testing/selftests/mm/madvise.c
index 0851f5428e3d..8822991eae4a 100644
--- a/tools/testing/selftests/mm/madvise.c
+++ b/tools/testing/selftests/mm/madvise.c
@@ -8,6 +8,7 @@
 #include <sched.h>
 #include <stdbool.h>
 #include <stdint.h>
+#include <string.h>
 #include <sys/ipc.h>
 #include <sys/mman.h>
 #include <sys/shm.h>
@@ -16,10 +17,15 @@
 #include "kselftest_harness.h"
 #include "vm_util.h"
 
+#ifndef MADV_COLLAPSE
+#define MADV_COLLAPSE 25
+#endif
+
 /* Reclaim can fail transiently, so retry for up to a second. */
 #define PAGEOUT_RETRIES 100
 
 static size_t page_size;
+static size_t pmd_size;
 
 FIXTURE(madvise)
 {
@@ -31,6 +37,7 @@ FIXTURE(madvise)
 FIXTURE_SETUP(madvise)
 {
 	page_size = getpagesize();
+	pmd_size = read_pmd_pagesize();
 
 	self->pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	ASSERT_GE(self->pagemap_fd, 0);
@@ -44,6 +51,111 @@ FIXTURE_TEARDOWN(madvise)
 	close(self->pagemap_fd);
 }
 
+/*
+ * Reserve a PMD-aligned range, so that memory mapped over it with MAP_FIXED
+ * can be backed by PMD-mapped THPs.
+ */
+static char *reserve_aligned(struct __test_metadata *_metadata, size_t size)
+{
+	char *reservation, *aligned;
+
+	reservation = mmap(NULL, size + pmd_size, PROT_NONE,
+			   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(reservation, MAP_FAILED);
+
+	aligned = (char *)(((uintptr_t)reservation + pmd_size - 1) &
+			   ~(pmd_size - 1));
+	if (aligned != reservation)
+		ASSERT_EQ(munmap(reservation, aligned - reservation), 0);
+	ASSERT_EQ(munmap(aligned + size, reservation + pmd_size - aligned), 0);
+
+	return aligned;
+}
+
+/* Map PMD-aligned anonymous memory filled with 1s. */
+static char *map_aligned_pages(struct __test_metadata *_metadata, size_t size)
+{
+	char *mapping = reserve_aligned(_metadata, size);
+
+	ASSERT_EQ(mmap(mapping, size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  mapping);
+	memset(mapping, 1, size);
+
+	return mapping;
+}
+
+/*
+ * Collapse a PMD-aligned range into PMD-mapped anonymous THPs. MADV_COLLAPSE
+ * may fail transiently with EAGAIN.
+ */
+static bool collapse(char *mapping, size_t size)
+{
+	int nr_hpages = size / pmd_size;
+	int retry;
+
+	for (retry = 0; retry < 10; retry++) {
+		if (madvise(mapping, size, MADV_COLLAPSE)) {
+			if (errno != EAGAIN)
+				return false;
+		} else if (check_huge_anon(mapping, size, nr_hpages,
+					   pmd_size)) {
+			return true;
+		}
+		usleep(10000);
+	}
+
+	return false;
+}
+
+/* Map a PMD-mapped anonymous THP filled with 1s, or return NULL. */
+static char *map_thp(struct __test_metadata *_metadata)
+{
+	char *mapping;
+
+	if (!pmd_size)
+		return NULL;
+	mapping = map_aligned_pages(_metadata, pmd_size);
+	if (collapse(mapping, pmd_size))
+		return mapping;
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+	return NULL;
+}
+
+/*
+ * Changing the protection of one page PTE-maps a THP. When /proc/kpageflags
+ * is readable, also check that the folio is still large.
+ */
+static void pte_map_thp(struct __test_metadata *_metadata, char *mapping,
+			int pagemap_fd, int kpageflags_fd)
+{
+	unsigned long pfn;
+	uint64_t flags;
+
+	ASSERT_EQ(mprotect(mapping + page_size, page_size, PROT_READ), 0);
+	ASSERT_EQ(mprotect(mapping + page_size, page_size,
+			   PROT_READ | PROT_WRITE), 0);
+	ASSERT_TRUE(check_huge_anon(mapping, pmd_size, 0, pmd_size));
+	if (kpageflags_fd < 0)
+		return;
+
+	pfn = pagemap_get_pfn(pagemap_fd, mapping);
+	ASSERT_NE(pfn, -1UL);
+	ASSERT_EQ(pageflags_get(pfn, kpageflags_fd, &flags), 0);
+	ASSERT_TRUE(flags & KPF_COMPOUND_HEAD);
+}
+
+static void assert_filled(struct __test_metadata *_metadata,
+			  const char *mapping, size_t size)
+{
+	size_t offset;
+
+	for (offset = 0; offset < size; offset += page_size) {
+		ASSERT_EQ(mapping[offset], 1)
+			TH_LOG("memory changed at offset %zu", offset);
+	}
+}
+
 /* Page out the range until its first page is swapped. */
 static bool pageout_until_swapped(struct __test_metadata *_metadata,
 				  char *mapping, size_t size, int pagemap_fd)
@@ -91,6 +203,11 @@ static void pin_to_current_cpu(struct __test_metadata *_metadata)
 	ASSERT_EQ(sched_setaffinity(0, sizeof(mask), &mask), 0);
 }
 
+static bool page_is_present(int pagemap_fd, char *addr)
+{
+	return pagemap_get_entry(pagemap_fd, addr) & PM_PRESENT;
+}
+
 /* Map a shared mapping of an unlinked, zero-filled temporary file. */
 static char *map_temp_file(struct __test_metadata *_metadata, size_t size)
 {
@@ -405,4 +522,121 @@ TEST_F(madvise, pageout_skips_unevictable_page)
 	ASSERT_EQ(shmdt(mapping), 0);
 }
 
+/* MADV_PAGEOUT of a whole THP must swap it without corrupting it. */
+TEST_F(madvise, pageout_swaps_thp)
+{
+	char *mapping;
+
+	mapping = map_thp(_metadata);
+	if (!mapping)
+		SKIP(return, "could not allocate a PMD-sized THP");
+
+	if (!pageout_until_swapped(_metadata, mapping, pmd_size,
+				   self->pagemap_fd))
+		SKIP(return, "MADV_PAGEOUT did not swap the THP");
+	assert_filled(_metadata, mapping, pmd_size);
+
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+}
+
+/*
+ * MADV_PAGEOUT must not reclaim pages outside the advised range. kswapd or
+ * page migration could also unmap them, but neither should happen when the
+ * selftests run by themselves.
+ */
+TEST_F(madvise, pageout_stays_within_range)
+{
+	char *mapping;
+
+	mapping = mmap(NULL, 3 * page_size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	memset(mapping, 1, 3 * page_size);
+	if (!pageout_until_swapped(_metadata, mapping + page_size, page_size,
+				   self->pagemap_fd))
+		SKIP(return, "MADV_PAGEOUT did not swap the page");
+
+	ASSERT_TRUE(page_is_present(self->pagemap_fd, mapping));
+	ASSERT_TRUE(page_is_present(self->pagemap_fd, mapping + 2 * page_size));
+	assert_filled(_metadata, mapping, 3 * page_size);
+
+	ASSERT_EQ(munmap(mapping, 3 * page_size), 0);
+}
+
+/*
+ * MADV_PAGEOUT must not reclaim the unadvised half of a THP: the THP must be
+ * split before reclaim, or skipped. See pageout_stays_within_range about
+ * other unmapping.
+ */
+static void pageout_half_thp(struct __test_metadata *_metadata, char *mapping,
+			     int pagemap_fd)
+{
+	size_t offset;
+
+	if (!pageout_until_swapped(_metadata, mapping, pmd_size / 2,
+				   pagemap_fd))
+		SKIP(return, "MADV_PAGEOUT did not swap the advised half");
+
+	for (offset = pmd_size / 2; offset < pmd_size; offset += page_size)
+		ASSERT_TRUE(page_is_present(pagemap_fd, mapping + offset));
+	assert_filled(_metadata, mapping, pmd_size);
+}
+
+TEST_F(madvise, pageout_stays_within_pmd_mapped_thp)
+{
+	char *mapping;
+
+	mapping = map_thp(_metadata);
+	if (!mapping)
+		SKIP(return, "could not allocate a PMD-sized THP");
+
+	pageout_half_thp(_metadata, mapping, self->pagemap_fd);
+
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+}
+
+TEST_F(madvise, pageout_stays_within_pte_mapped_thp)
+{
+	char *mapping;
+
+	mapping = map_thp(_metadata);
+	if (!mapping)
+		SKIP(return, "could not allocate a PMD-sized THP");
+	pte_map_thp(_metadata, mapping, self->pagemap_fd, self->kpageflags_fd);
+
+	pageout_half_thp(_metadata, mapping, self->pagemap_fd);
+
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+}
+
+/* MADV_COLD on part of a THP may split it, but must not change it. */
+TEST_F(madvise, cold_preserves_half_of_pmd_mapped_thp)
+{
+	char *mapping;
+
+	mapping = map_thp(_metadata);
+	if (!mapping)
+		SKIP(return, "could not allocate a PMD-sized THP");
+
+	ASSERT_EQ(madvise(mapping, pmd_size / 2, MADV_COLD), 0);
+	assert_filled(_metadata, mapping, pmd_size);
+
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+}
+
+TEST_F(madvise, cold_preserves_half_of_pte_mapped_thp)
+{
+	char *mapping;
+
+	mapping = map_thp(_metadata);
+	if (!mapping)
+		SKIP(return, "could not allocate a PMD-sized THP");
+	pte_map_thp(_metadata, mapping, self->pagemap_fd, self->kpageflags_fd);
+
+	ASSERT_EQ(madvise(mapping, pmd_size / 2, MADV_COLD), 0);
+	assert_filled(_metadata, mapping, pmd_size);
+
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.56.0


