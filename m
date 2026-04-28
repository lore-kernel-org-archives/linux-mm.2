Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 470FBFF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE2516B00ED; Tue, 28 Apr 2026 16:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8F06B00EF; Tue, 28 Apr 2026 16:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6406B00F0; Tue, 28 Apr 2026 16:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8DFD86B00ED
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:47:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 57A5C120200
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:47:50 +0000 (UTC)
X-FDA: 84709151100.18.EFC44AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 98F8840012
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:47:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=leaz1n2j;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W9WG+XyXROzP7f1nJPp9WS73n1yvU7tqVlusyYg+bLU=;
	b=X0MqE3zxs5BQE/TSQzZxPJMausq47B6kiEsOcdZ7viKAeNLbqX3OafltBnRZ5vynrR4EuP
	+DtAg5bQDnttiYcWI1mN/fYwG1xYwxJqcGwXU5GADcY/AIfcEXtwtKkei7q2WjVujaBvYC
	XnFDnWQMP39IasOJBQh0Ce+VxK5Z/as=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=leaz1n2j;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409268; a=rsa-sha256;
	cv=none;
	b=kC/t86c7s8grF2oeJfZdFfpuTvYZyGZ7pKNuK/CZyTvUjDMcW6eoKKiakIJ7vhw7eZQzbH
	xO7kUD8jpW6unB8Kk9imLq0bFHCHz/fODNYf5XgfAjiqL6W3TyX0gNKnb6Ju4b/tVF5Dxk
	ssyFqzSMWDnSZPoR0Kvs97ZyiySZiB0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C408A40771;
	Tue, 28 Apr 2026 20:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97916C2BCAF;
	Tue, 28 Apr 2026 20:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409267;
	bh=6G+HupLEy7RoQW/oaRMLwy3Q9S37tIjtSZCXvkrmYmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=leaz1n2j9oxuyVx2ozTbKXqtg3ssJzMfcWnwRTkdJgKalVNCITrankiRbk1qObVTL
	 5D4eUTcQ+JJ/YIdTqU8lTIafIPSwMm2FvQFs13DEhFMVJCjn5Ojb9B3fPL6ocQhKHr
	 t8VFA6JEq5pxq1H1Lia2cVmdUITLPxnocai0m9yL8/77MS0BIr5tJht43Cl95MK7H3
	 Qfm2NPNzaeQf7Jw+90+MFcqCs6SL4cD+vk3p7fCRt/A5KwCujpld0nUs069qpmXbkl
	 jbgqft2eCGSHlqe2svy1Mjk03A4Qb9Xu88vmby11PwS3N0otO5cFD8aNdFPI5MAnrN
	 rPsi4UNt6tGYQ==
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
Subject: [PATCH v3 45/54] selftests/mm: pagemap_ioctl: add setup of HugeTLB pages
Date: Tue, 28 Apr 2026 23:42:31 +0300
Message-ID: <20260428204240.1924129-46-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mdhh69xomwjxi451nymrhbr7f7uy9761
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 98F8840012
X-Rspam-User: 
X-HE-Tag: 1777409268-752476
X-HE-Meta: U2FsdGVkX1++Rh5x0YMkLkg3rECXJJrMHo+w6c7RzPMzryRQ8bh2J1Ph5K1Oc1FvxtPAO8BNLl49X/4oxJXPST2VryuxphogKX9li+lm/Zm4v2Kj+8nzqedXRSLuBHsI/KfQaImETcH7A2UKGOkfbzWeHmGx3UvL9hlU6FZCbEt8ZlCt00H2xrko9UBs0N9sySQqXvZHOvjT2tZnGL5LOuERp7kSvdTGfXygqhzQioKTx8wsh7hw3KntSFM+UFCnHX4KphJPQhex+DXWgQAOXddWZcTqwN4iwJIDex4Zu6/aqJ4XXYn0zY09qd9sWdfAAMoGXkZAC6+arF54dK0TenJ45fyGMpzM9/kiF5g1EuT18qf7c2ko7op6gCinyeLYCCkR8UTlesTMQZ+SImZa2c2uup2EiUAAHnKgY+hrEgZIYhFd8Q/O6EheS2ybWgVZgF6rJKMsnj877SDvSduo7fpID6+XRCFecD82sv168U06/FPgLEwUenwu8JIASYJMzsgechvZIJm0+4Vlyd3Jas/CWcOzxEIDcOBFTf8TOjXWZ6F7eFrCDTfkQUQ5xckC2EIOLoNbNG5EMjM0FC277r+VxnsGZbZzhwecrriR5GLZtlDAtp3j85ivuA8ThGwiXI8XzljUHxb89hHzgvO6G8UmJPeiX4dwD7cPax2g0RZHTeu+TUv2EvSyj6FAt9qJxC70K8SYWsAiHOa1d1nENd72qp2ckmUF911EYmDpXHJEyKMYkZSijEk5UyvwQHkA0Clc0Zh59wNaT1hr//9quDowV9KnDWfuf8zkNzsDPdZeVxTnjt0iEdq08ukkmg3VgQuk5LFKj10pOPzKGxQbeR1fG9WJzSPpgkXHJ4MlQNTiENDiJtu62w1kAoOcBT7g7OE66qYAnEPtqLL/EBPOUwHnFZEn/2uqYGg4YkR/FsoU7DIzjjoRfdhbOgv6Rjxry6gj91SkM/zBHCvXPip
 4DcJcbXw
 GolYF7sr84ueVBZrVZB+yCcQZnKvZdOUA9X3pLwASB3uW2912a5nnuQ6bJzI/kN5Hm+ziDmunnedhiGBbgKwvDzkcsiHe/0vsuiS1d6I7J1vfgHyFstdih9kv5jjsXRr6CI44br0q65jGUSQIQMRiW7ne7Yd6gICx29XuEsT/0nB+GhxnCSVaXcil7JvreYtR1TzUclVy2dIvFXeBH4epqKlsmivF0GfRJfYcNFC3abV7jHzaWdSeD0CZ9ckza5rg9+L6tSGynZifV07gLSNMLdVmDAvCrBHiwRnP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

pagemap-ioctl skips HugeTLB tests if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 7f9428d6062c..e2c62cb6978f 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -7,8 +7,6 @@
 #include <sys/mman.h>
 #include <errno.h>
 #include <malloc.h>
-#include "vm_util.h"
-#include "kselftest.h"
 #include <linux/types.h>
 #include <linux/memfd.h>
 #include <linux/userfaultfd.h>
@@ -23,6 +21,10 @@
 #include <sys/ipc.h>
 #include <sys/shm.h>
 
+#include "vm_util.h"
+#include "kselftest.h"
+#include "hugepage_settings.h"
+
 #define PAGEMAP_BITS_ALL		(PAGE_IS_WPALLOWED | PAGE_IS_WRITTEN |	\
 					 PAGE_IS_FILE | PAGE_IS_PRESENT |	\
 					 PAGE_IS_SWAPPED | PAGE_IS_PFNZERO |	\
@@ -1554,6 +1556,9 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	if (init_uffd())
 		ksft_exit_skip("Failed to initialize userfaultfd\n");
 
+	if (!hugetlb_setup_default(4))
+		ksft_exit_skip("Not enough huge pages\n");
+
 	ksft_set_plan(117);
 
 	page_size = getpagesize();
@@ -1605,7 +1610,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	}
 
 	/* 5. SHM Hugetlb page testing */
-	mem_size = 2*1024*1024;
+	mem_size = default_huge_page_size();
 	mem = gethugetlb_mem(mem_size, &shmid);
 	if (mem) {
 		wp_init(mem, mem_size);
@@ -1633,7 +1638,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	}
 
 	/* 7. File Hugetlb testing */
-	mem_size = 2*1024*1024;
+	mem_size = default_huge_page_size();
 	fd = memfd_create("uffd-test", MFD_HUGETLB | MFD_NOEXEC_SEAL);
 	if (fd < 0)
 		ksft_exit_fail_msg("uffd-test creation failed %d %s\n", errno, strerror(errno));
-- 
2.53.0


