Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A8D4CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:33:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E18906B012D; Mon, 11 May 2026 12:33:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCA6A6B012F; Mon, 11 May 2026 12:33:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1806B0130; Mon, 11 May 2026 12:33:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B38826B012D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:33:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 72AFA8AA7F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:33:53 +0000 (UTC)
X-FDA: 84755685546.07.18FCFA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B71961C0010
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:33:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cfFAD4hM;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FvJ+/v/bbWN24kzztdaj4gKOoXShzzP4fKDRvCmX3G0=;
	b=U9cnsDOklvtF1szubeVRpaHXtICl2W0kGDQUKq8PMafm7ZGmQr9h0JF1TlIO518lAFtyj6
	ewgY0K6UfmyiOeegDhW0YkvLfwAs50DRYEyKI4rndZ79j2v6dmnOzlKEE85sbgG3NRAPk1
	QfRqIbQQZVV5Yt77Hyyrb1QyVllfS5E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cfFAD4hM;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517231; a=rsa-sha256;
	cv=none;
	b=jcFKkyLDNhpbbO3d9WhxPFqgWzjR9csDklo0LUK0El8s3X5sCEXKp1LsbdR1py/yQzQavq
	5Us9IA17HaJN8yQ+fZiLqFV4JBNW9aipaRpETeEaZGBkN8gal7oP18LIQyUorR28IUlU9w
	iuDnspCGoFwTRSeLMMVvxV3ctrEWPpM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E054F43489;
	Mon, 11 May 2026 16:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3260C2BCB0;
	Mon, 11 May 2026 16:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517230;
	bh=ZtJCv5IRER4B8Vs4oQYJn67vjZ/oDJLOHUNZ2jEz10o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cfFAD4hMH3MJwLPZ82a4+kqHjOwmZuBLX/5jqDbqhdoX7PuNTfj2op3dw2DfZr+jH
	 VueBYld0bGo07ZxTIQoRxzoPdpsRR5/HchACsHRT9V0LdUrCSg0nnpU8Jrgq9OdmoS
	 cDODRjQA6pYVSNKGSkDA7RH5UrXiUULEisVAS8BwEzTzYvRuukZRrNTCCqBWSkHRz+
	 gs+WZnywBJKNDLUfuTOBc9TdAiWyWFUN6ON9PQiQe9K8MiJ5ww4ahhMQmMSc5fOyyG
	 PO98SE0nQ+maPIVaeIXVReetCZ5/z5Y/s1FshFUARVPPark4edDhLUvR8unMhNyY5M
	 mZIkM8OhurG9Q==
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
Subject: [PATCH v4 46/55] selftests/mm: pagemap_ioctl: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:30 +0300
Message-ID: <20260511162840.375890-47-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B71961C0010
X-Rspamd-Server: rspam06
X-Stat-Signature: hskyw7rnse35wppzwws3crkkcy9bubtu
X-HE-Tag: 1778517231-898311
X-HE-Meta: U2FsdGVkX1+rGqE9dNnQ+wg64eNpiq/MD/t2lwgU6/bGR5J//EGF7EKL+7ER6TLzHxC3leojvrp1Z+KuclVvMvNUznRYORGrXy5en6VC2pkfwE/CxWVqP+CydYzKAdg13axAuuP4JXRZWx6T7XNze94dibiDaWS6BwvwQII5krv6tRZbEJyw0jg70GUXmNJ05LqjDxVyys2MHiGlR9ePC5W0DAjO9OyVXMuzAgaFeUykjbIMNWVozQc62d7ZkPwZ+vheiED8jOH6jDQGknBIQ6Ijllba051Zn/KCbNMBn4qHupo3BEH5+jktTXJYkj9sfjgb4FOW19kasm4m8vq8viBN0d0nWY/sLfIkAJgnB253YGw5GDkdFiT+2SX5A94zykEcrpx1B4Z/9EndKQtwpHLZFq0kMF0jwQ3EPi2mCAsXpcQ4UWdnCjMVcYxr0tPqkPd8Zg8vMrbs4r5PPIX34gr7MYuVRHa1xzdefFHusN+rvaa3Pc4imENQfgnC0sRswSkofXIAqY1/z8NLnjD35aWIWl06ycIZMj8yLIAO4MOEwLO7HrbuCuTG96PKeUxysYoINq19Fm4EHEbCRhmzqz/rClVGsENvueh5pAS+TujNgoFBknVgENN1VIqCVxFEjRdpE/Xo90C8tz4vEUJHe8AouDRWP2NOBId493pviabc59vSMmZja+8Z3xnQbCCcb8pBi/Utxf8X/U/9e1oJFzpo/bALcf9sl3QT/e2kjSQU7Tprx8DhYCqYqDw2HrqK5tQsy9s+1gSTFJ831PhQNH3r3lStTuLiiArL8HkTnx7RgXmsZwcNcryIXc758LvrtpFQtBKmy/6jFe0Ofnq3kdA1otGRYFEA9O/hMgI/f86onJ9l1bcSJoUIxbyMdOY3H8oni9WXcL8jz3nyweLZcL2ekIJHY8RYDn/eAhWZL9IlKhen6b/NgjKD+G7Brm0Ci0+NmRI4x4CgymmS218
 Dx65bOAJ
 ockiD8wNAwJoLuWchjzeUeQFosvhVqjfuXPqYd3DU1nQxzhO9UlakI8u1MI28t9CwtBfFIR7w0fX+DA/ydFt/Nwmn2idc5Hi18T8tSYFlQjN9O01MrUukI+yxuU1BT7OOS1Wyq8eIVK+B6LTS+V/TAsqETbSsKb07FXNNlncfVsAPVMVkbqR93/MoKFpdQLdbI0Ymrpv18WPUIGHXvwDN/sq51khtNGWiNwObja6RLZNcJ+3e+c3WppJfzS8QBjiw1o00vtvxuQWNFfHjzku7/6SLxrxj7iUchWIhRaWF6aneX3z3YX/4muwRMcZqjaSh6KBx/8fIJWn7aa/5L4oM+XQb9/aDFvoP7PZrtB374zamAII=
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

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 7f9428d6062c..762306177ad8 100644
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
+		ksft_print_msg("HugeTLB test will be skipped\n");
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


