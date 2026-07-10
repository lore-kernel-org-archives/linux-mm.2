Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAE77C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E0516B0088; Fri, 10 Jul 2026 05:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 390C16B008A; Fri, 10 Jul 2026 05:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 280286B0093; Fri, 10 Jul 2026 05:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E92856B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:24:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6CA051C8979
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:24:38 +0000 (UTC)
X-FDA: 84972331836.03.D3EEF96
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id 36490140002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:24:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=I0ZcMQEJ;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783675476;
	b=QHGJA3DwdpxRN9hI3jNKrrk+1MGnY3JUwaeo0xKi6FlUPm7P6dNPYZaHzO/Fiv2L3IMCMQ
	lzNE8Uc7HYh37D1Jmx5aWGoWC+U7+iePkUULS490m0yV4hQkmkIjmQE4C1W3YIrjvUcJ83
	W9vddO89rEFzwtIo4YSzADyM1HSP0ME=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=I0ZcMQEJ;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783675476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dgywglFUIwjru+wdRX3rW0UAMsUidjYqKDAc3zGlpNk=;
	b=WPF3R633ujwFfKa9U89lfT3LJbyecHcfkmiZBuXGWrysSOW4o2GEvOZKB8ILkzNLQ6Q2/E
	LC74xaVJJqdfFvJZ1MSfA8s0lkyKPe8kg8WVqiW/gSvHrIqoSa80HIG7Kav0TAE8wpInEr
	Vr3UAYnCnqvKaga1zL6CNNnddlw+yXc=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cc6ae3e7f1so4123695ad.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1783675475; x=1784280275; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dgywglFUIwjru+wdRX3rW0UAMsUidjYqKDAc3zGlpNk=;
        b=I0ZcMQEJK7JWgJCrk5A/AeHWUjq6Uqg37IHJ36W2SswNUBCcXHnmEqeSMPUDo8Vqem
         FH18B3pqyORuq1hx2QsPM4OyAl6uReYvybHEwoRzojqaTbLdUdfSFNVj0nw6wDuBvUNX
         HgUnJ9sX3MBGdy4+j2QdG0PvEXWmsvU4rWHIedV4bb77ojuYKxic1ifm5Fw+j7YBnyb9
         kCp33jpv9pnVkrLahMcq07+0cgp/9s3KjBnMlpLeNAXGjwULJF6Wjt8Dfc1oPsQs/E1E
         IyCLMcKEHpddvGyxeyerJFsYvKdcKlGOYnd4IXUfsDXLdAdcN8SrzyGs2khrfS2u3SbB
         ibmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783675475; x=1784280275;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dgywglFUIwjru+wdRX3rW0UAMsUidjYqKDAc3zGlpNk=;
        b=XflTXnOC07JwPM9L2gmTBKxJ9JL4/1H5OaJqiTUa4Sf7glmo5sNm4cvHAT9pmIyOJf
         1ug6clQxv2W2Nu2qlAD7Dyabfd4OjkWdv+F+qX2j5TBY1zvN6wgQxgHPp7RPlIgaz1FH
         NWWqqgaMnweRIiaPwuYx4QE4d2PIjc1SKqJVQTmbx9oiKO/No0fFTsGfgkDJMdxQte0E
         7PwQiDAi7j9oXR6ql1maX8y9ooEReH8N96oYMugYfYsaOVlm/OGDmOXpkktfXNabBRB9
         ErEOgng7TRFxd+k+U3VvOWzmUZDTpa6Hdxtwas74rpiRUtGS8QIt4PgX0+Or83/O8Wm3
         /9NA==
X-Forwarded-Encrypted: i=1; AHgh+RpN5bh4lo/Yy7/dUEpCfFynjEKzvQf++h6425YxYcqc9UftlLFpMnisXIbll64rUHhoPoC+xfQq8w==@kvack.org
X-Gm-Message-State: AOJu0YwIqyHjX0WscV2lXBt0WCB04xIXOMHGY4bMoU4aD0miol3XvWmq
	29/nofXPlCGlKPXZUD3SkRDdnLWyqlb6uHfgBSmLzeL4WIuZOz3Hns+zxn3m58wytvs=
X-Gm-Gg: AfdE7cmwePJyKuLft7Gs5vhHD4kymUWggC8q9m2/Nm196SFHaqZTFX2GM1eLzU262lt
	9mVg3xh01sqi0lPgAuVBpJ0fw6zsrR6itmh3LI1xlGcBossWPB8rDLYPrfYAIGq1AOW9Xj/g4PJ
	PDUK3AGXdAH1JmFop0Ah60hiXK4tLt5a7NWTMK2S9dRDNiwCDJnnaG9XxNheCfOetTLEYLYgYb8
	t8DMx3NE9nlXWuucYVF2jDqSga1p+sSEvPDaZQ9ZYz2JlCnM8TFHKBWtK/NZ59V4PRiEUz6yOBJ
	DofhlY7r8Id74EypZsTdG6Mbyo2CGdbhMq/eDT3CggcipaA2xo4qCP1LNj0ofdi4e8AW4hDdkbJ
	ztCqqXFHSjAYIq64YHwsJwdcxg/DoM4D2aqJmqGSgA7mXvR/Q976B6fURBnNFUftbptMafs/xqm
	6iLoxCP2WL5vdsX3DuUfqhnJjKBoGj3ibg
X-Received: by 2002:a17:902:fc8e:b0:2ca:ddbd:a19b with SMTP id d9443c01a7336-2ccea40b65emr107793175ad.28.1783675474937;
        Fri, 10 Jul 2026 02:24:34 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb72fsm56827995ad.6.2026.07.10.02.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 02:24:33 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH] selftests/mm: remove obsolete hugetlb vmemmap test
Date: Fri, 10 Jul 2026 17:24:27 +0800
Message-ID: <20260710092427.3459121-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 36490140002
X-Stat-Signature: khr71nes6f7thha6h5o1rqysojtshs85
X-HE-Tag: 1783675476-655680
X-HE-Meta: U2FsdGVkX1+4a71GqRXxx+Pd1dGSys8/QUzL2jiuDO7EhQY7/ufdwTUK6vr0676rTdkF/m8WPi4hnPCU5iyKwTjjGyRRjH/3hf6BVe3mu9IAC8LDNKcCTcphQexFsMUmIwAUdmTrSisG4JnSSm4fNXw5t84pXXg1dZmOulIxK92ARXGAdw8tgzJqeSsAKW8+cHp7xwhqAEDJTbP7KkIPII+61uvYGyvxo77HOF4k7LGhwUJPydatd4zK+xxTK1vdVubdSsdnxjErmTHyB+8B+RiTYrTpqnR1kT/nyJSVbLVCUuRtGI39LkLWXnmXvX4sbYgf6K+Rz2W6kf0pCg8MM1RKtPNMyTqktsewtWMl13NQGYNQk4ljAQdnvyBnO+BN9o2gzBui4REsMbOQLzeCYO5WSQ2DZRCQ7EFw4xeQm00ztWsb38hHKxP8Gkjocop0+MGihhvtXU0YrtYCn0tHYL+xDtuPyOSqea14aHM5Q4pZv+fcqUH6aZzGU6NRySLHwQx8JkbxpqAU8/LAoqc2vUzkJnBdN39LrbqUvfoVvjKIvdmva6v6m/p2y40XK7eBfhzEe+dtvN/AEpko/Ldf43+c7AycEoPDnpLgzdPTt5SkQf/RkTV3v1FRwWQAIaMddNvcugQAlFj4TT5CUi+8xlSKfvtcH7brn6KD4gHBDKmoVqbB/Dc/7oCIELHYjBwuj+YM/K3a1SVR2mcACi3Dldt1WACYhdjNvGXR9yIV2WMh7xSsSDN6tRq+muMCwJoYsr4UWZh4OwBmhknJQxXT+X9n4r4gR9W3tMezLIoQVZjMcyytYkI+NILWeO1HhOyDrYHRCIkyGxZRQ+578X+LQuByYrXSTiOb+oWuJdK8sIsMm76CvL43+DiPfHi4nw8EDx42ZCKwRUI3vlEDBJulUQSxMynp2pYG7yXQM60xH0cGlSH/YSQphgVYULdfVAexyh5hat1e0ePrHWvi/aZ
 SpaUkF5N
 1wQnewPp+T1UCYwApFw4WJiYoIr1OzkTaBihfIwHrZGPuObpqIc3wt/R6CGxNV9eD/AgAiFMCGJZHGqqFkOeEZsbPlywuhNCdu/tTfB3vUs1+YWVynDpJc11y5/ZCN5bKfcTXq7rTWyem/DzZIVIiVY+XKkf0Dbkt9+eTgJXuLKskErbl8vkv3mQvh7QVMjlUShccyAiAGBrJuCWbL1yLAJtATybp3cADNlcAO79U7jIECpFeaaE/ZoxnSVv9UJqCFjPaPJb40mdPGK23TNlCtoZT2nKg1YfrDzydI9a4RoJ/7n0kEjCMq2ekEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hugetlb vmemmap selftest was added to check the old HVO
layout where tail vmemmap pages reused the head page.  That
assumption no longer matches the current HVO mapping layout.

HVO now keeps a private backing page for the head vmemmap page
and remaps redundant tail vmemmap pages to a shared read-only
backing page.  The old page flag check is therefore testing an
obsolete implementation detail rather than the current ABI or
behavior.

Remove the stale test and its build, run, and ignore entries.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 tools/testing/selftests/mm/.gitignore        |   2 -
 tools/testing/selftests/mm/Makefile          |   1 -
 tools/testing/selftests/mm/hugetlb-vmemmap.c | 132 -------------------
 tools/testing/selftests/mm/run_vmtests.sh    |   1 -
 4 files changed, 136 deletions(-)
 delete mode 100644 tools/testing/selftests/mm/hugetlb-vmemmap.c

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index 9ccd9e1447e6..227476d8ff1f 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -3,11 +3,9 @@ cow
 hugepage-mmap
 hugepage-mremap
 hugepage-shm
-hugepage-vmemmap
 hugetlb-mmap
 hugetlb-mremap
 hugetlb-shm
-hugetlb-vmemmap
 hugetlb-madvise
 hugetlb-read-hwpoison
 hugetlb-soft-offline
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index ed321ae709da..ee8def9b4c31 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -66,7 +66,6 @@ TEST_GEN_FILES += hugetlb-mremap
 TEST_GEN_FILES += hugetlb-read-hwpoison
 TEST_GEN_FILES += hugetlb-shm
 TEST_GEN_FILES += hugetlb-soft-offline
-TEST_GEN_FILES += hugetlb-vmemmap
 TEST_GEN_FILES += khugepaged
 TEST_GEN_FILES += madv_populate
 TEST_GEN_FILES += map_fixed_noreplace
diff --git a/tools/testing/selftests/mm/hugetlb-vmemmap.c b/tools/testing/selftests/mm/hugetlb-vmemmap.c
deleted file mode 100644
index 507df78a158d..000000000000
--- a/tools/testing/selftests/mm/hugetlb-vmemmap.c
+++ /dev/null
@@ -1,132 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * A test case of using hugepage memory in a user application using the
- * mmap system call with MAP_HUGETLB flag.  Before running this program
- * make sure the administrator has allocated enough default sized huge
- * pages to cover the 2 MB allocation.
- */
-#include <stdlib.h>
-#include <stdio.h>
-#include <unistd.h>
-#include <sys/mman.h>
-#include <fcntl.h>
-#include "vm_util.h"
-#include "hugepage_settings.h"
-
-#define PAGE_COMPOUND_HEAD	(1UL << 15)
-#define PAGE_COMPOUND_TAIL	(1UL << 16)
-#define PAGE_HUGE		(1UL << 17)
-
-#define HEAD_PAGE_FLAGS		(PAGE_COMPOUND_HEAD | PAGE_HUGE)
-#define TAIL_PAGE_FLAGS		(PAGE_COMPOUND_TAIL | PAGE_HUGE)
-
-#define PM_PFRAME_BITS		55
-#define PM_PFRAME_MASK		~((1UL << PM_PFRAME_BITS) - 1)
-
-static size_t pagesize;
-static size_t maplength;
-
-static void write_bytes(char *addr, size_t length)
-{
-	unsigned long i;
-
-	for (i = 0; i < length; i++)
-		*(addr + i) = (char)i;
-}
-
-static unsigned long virt_to_pfn(void *addr)
-{
-	int fd;
-	unsigned long pagemap;
-
-	fd = open("/proc/self/pagemap", O_RDONLY);
-	if (fd < 0)
-		return -1UL;
-
-	lseek(fd, (unsigned long)addr / pagesize * sizeof(pagemap), SEEK_SET);
-	read(fd, &pagemap, sizeof(pagemap));
-	close(fd);
-
-	return pagemap & ~PM_PFRAME_MASK;
-}
-
-static int check_page_flags(unsigned long pfn)
-{
-	int fd, i;
-	unsigned long pageflags;
-
-	fd = open("/proc/kpageflags", O_RDONLY);
-	if (fd < 0)
-		return -1;
-
-	lseek(fd, pfn * sizeof(pageflags), SEEK_SET);
-
-	read(fd, &pageflags, sizeof(pageflags));
-	if ((pageflags & HEAD_PAGE_FLAGS) != HEAD_PAGE_FLAGS) {
-		close(fd);
-		ksft_print_msg("Head page flags (%lx) is invalid\n", pageflags);
-		return -1;
-	}
-
-	/*
-	 * pages other than the first page must be tail and shouldn't be head;
-	 * this also verifies kernel has correctly set the fake page_head to tail
-	 * while hugetlb_free_vmemmap is enabled.
-	 */
-	for (i = 1; i < maplength / pagesize; i++) {
-		read(fd, &pageflags, sizeof(pageflags));
-		if ((pageflags & TAIL_PAGE_FLAGS) != TAIL_PAGE_FLAGS ||
-		    (pageflags & HEAD_PAGE_FLAGS) == HEAD_PAGE_FLAGS) {
-			close(fd);
-			ksft_print_msg("Tail page flags (%lx) is invalid\n", pageflags);
-			return -1;
-		}
-	}
-
-	close(fd);
-
-	return 0;
-}
-
-int main(int argc, char **argv)
-{
-	void *addr;
-	unsigned long pfn;
-	int ret;
-
-	ksft_print_header();
-	ksft_set_plan(1);
-
-	if (!hugetlb_setup_default(1))
-		ksft_exit_skip("Not enough free huge pages\n");
-
-	pagesize  = psize();
-	maplength = default_huge_page_size();
-	if (!maplength)
-		ksft_exit_skip("Unable to determine huge page size\n");
-
-	addr = mmap(NULL, maplength, PROT_READ | PROT_WRITE,
-			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
-	if (addr == MAP_FAILED)
-		ksft_exit_fail_perror("mmap");
-
-	/* Trigger allocation of HugeTLB page. */
-	write_bytes(addr, maplength);
-
-	pfn = virt_to_pfn(addr);
-	if (pfn == -1UL) {
-		ksft_perror("virt_to_pfn");
-		munmap(addr, maplength);
-		ksft_exit_fail();
-	}
-
-	ksft_print_msg("Returned address is %p whose pfn is %lx\n", addr, pfn);
-
-	ret = check_page_flags(pfn);
-
-	if (munmap(addr, maplength))
-		ksft_exit_fail_perror("munmap");
-
-	ksft_test_result(!ret, "HugeTLB vmemmap page flags\n");
-	ksft_finished();
-}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 8c296dedf047..a60b9f9f16e7 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -262,7 +262,6 @@ echo "TAP version 13" | tap_output
 CATEGORY="hugetlb" run_test ./hugetlb-mmap
 CATEGORY="hugetlb" run_test ./hugetlb-shm
 CATEGORY="hugetlb" run_test ./hugetlb-mremap
-CATEGORY="hugetlb" run_test ./hugetlb-vmemmap
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
 CATEGORY="hugetlb" run_test ./hugetlb_dio
 CATEGORY="hugetlb" run_test ./hugetlb_fault_after_madv

base-commit: 4f441960e691d37c880d2cc004de06bb5b6bd5e4
-- 
2.54.0


