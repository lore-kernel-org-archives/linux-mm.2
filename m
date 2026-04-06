Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DD6EF46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88D0F6B00EB; Mon,  6 Apr 2026 10:22:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85FD96B00ED; Mon,  6 Apr 2026 10:22:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79C9A6B00EE; Mon,  6 Apr 2026 10:22:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6938C6B00EB
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:22:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2391BC1C81
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:22:03 +0000 (UTC)
X-FDA: 84628345326.26.C92F156
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A1E25140010
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:22:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uEBwcr3x;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W9WG+XyXROzP7f1nJPp9WS73n1yvU7tqVlusyYg+bLU=;
	b=imD4qEQ0gMSgCK6NYsZvxPSizUesWvSe2INKQkmqe5/smR6XV9FKNsIEq4ZlddZ6XDqQuO
	/iAyHx+nOLFG4QI8ydc4L9w3ZVYFxD+l+vIX71RD7YDgPDraH3E6Kx/5LHOORV1uiFpCQU
	9byuhae2NfGAL61cNOJaNvp8qAOU3tI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uEBwcr3x;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485321; a=rsa-sha256;
	cv=none;
	b=y01WszScboFz4kS0per/eSUwI5wOHXtZeMYL41Biojob26zkyekqr1PUNJzebUj91qzSeN
	HgcOy3U3n5gsO+ArnQmvl3DRRkybOSYfrAVMiibhRV/OBGzW3M6e7SCRrHcwG9vGXCc0e/
	kO3BbkIBsnrS7aTDsoVoVofvATwEii8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E01B60123;
	Mon,  6 Apr 2026 14:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A22C4CEF7;
	Mon,  6 Apr 2026 14:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485320;
	bh=6G+HupLEy7RoQW/oaRMLwy3Q9S37tIjtSZCXvkrmYmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uEBwcr3xgDc101sXyUZmyP2HhdQ2KQG9tsXjusdOpcbtmZLvj9MLAB/0pXk0e9jip
	 PrVEKcvGkpCWy9XXk9iaPxn1R3IRmM2kHhgKGA107uoEjhAqAostjiZpyOLJm3/YpO
	 QnwMU/h9n+6lScb8OOZaaHBgf8fj9XILjYSqBZtH2l/M1xOKTrNL7HKMZ207hEowW4
	 qQukBKGXWtSru0slOUHskG4PdNFLW+gsvdAPVaHA3YtBQCo5+FaiCb/cm9OcQDDx16
	 LJ0MHkHDrBsifBcUnrjMef386h7Y6GIVCZ7unFeYwpURpbCcditAAyJYwnHO0W2ee/
	 f05Yxc2GfTcTQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 44/53] selftests/mm: pagemap_ioctl: add setup of HugeTLB pages
Date: Mon,  6 Apr 2026 17:17:26 +0300
Message-ID: <20260406141735.2179309-45-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A1E25140010
X-Stat-Signature: rbacfh5oicuk1jetfbrw76th7myi14dw
X-Rspamd-Server: rspam06
X-HE-Tag: 1775485321-839864
X-HE-Meta: U2FsdGVkX1/4poLw3w/yF+bSTID9C/h7eooVZ+jImHyI0OYKHgkTinu0W4H3hks4txAYvYFTsl3PVXNKnkkuInVRLEQ0jVrMZws6Ja10Txw7r7xH5wQXEVQSFZFGMdshtdoK9g6PLXWi5EW++eeVDogDZJ62wObSx9fZdMMXKU8kCAkizMEPSN2/dfMHPAGYVQx9O2d79Bcn4FS5sE15vuGprF/G3gwiO1A5BIS+K542n+qQU3n3UDHDkhNlnyMpahdnLP6Bg7O5mGEJuudVjIxvmZuYn25eWR+HjlCFyjfz9LZngeBSCdiTa6QEhoG9baD/SUbJ/CQUYD77L5l+KZFUxLnIBehf4ohSZIZS2N8vSSA/oawPv8D4KLs//iR3Nff2xKGE09+n7azS7DVO/X6atGCasJpXAkizQUcmzCrLqal57iXp7h7rdMVGiyrfl31dcIdAA+LLjeHNl/VKU9tATd+fLDDBkkmoj5VapI/XYnZvLsUbun9ED+zMLZ/kzCZCenC8wK70RfzYzpycPkOD9ifQoIIJDT/jhm/4OWNiqBZIQyCIVtgMHpiKGguwNPdUPhHSNOCyjHxo1lGmhISiB/pjoh8oQb7UMzcNfaL/xKu/xXY0Tsz5YYqP22cJ3zKUCS0yHgmNjefIEcTKHIz/fWYlQxhh1MprMMktOf7FKPH3+ujpWBcB87blIIiVS6wMXhf1FyxcQcUEVvu3/CNxJHy4Dt5/XTfoZixllU1e//CIH3s5Ob2I+Lsdz6FTxpzyAYoC2k7d4G7uLSOjz4cTB1NM9OC2Lcw6OxH4oTGvNcYD9wNftgJeYObaJa+laF22XoNvNxoeYuSjnX6TqbYJb5C3m5EXMMaOOEJZfwwwM3Aj4cduDa5IgaxsWbSP4C+DH2wKK7q5OkXb6GOX+c9eMTU7ozIYAMQlrxi49VWYTqCvONschLNFDpICh4PAxtLvVP8L0Ols9oz7A4k
 MUVGVGl3
 PQmfBjldWtvQJLag=
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


