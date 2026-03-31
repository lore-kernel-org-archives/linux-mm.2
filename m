Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF15DFF60D9
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03F746B008C; Tue, 31 Mar 2026 03:36:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0170F6B0095; Tue, 31 Mar 2026 03:36:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E96356B0096; Tue, 31 Mar 2026 03:36:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D48A06B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:36:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8A4AC377C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:36:37 +0000 (UTC)
X-FDA: 84605550834.30.EED9D6A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 42428100014
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:36:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IUbcizkl;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774942596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4qd9bBncq+mwyJAdo9H+gUXwc1gSi8XeDX+38FltmqE=;
	b=77RhDtLgCX1csrR1YmuXb+Kk+J8Npv5/LYMd9hGIoZUXy9aZlzOma6VZhxa90MI33xXV8E
	u68Z0muZDgDIMrYsI2+zF4qd+6rb6nueh9LLZPvLT2AhDbYts6sIFKAHGFPF4qdyJMYVcA
	2UUjnkw7wLwjgwCpYwfrkMtfA495YFE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IUbcizkl;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774942596; a=rsa-sha256;
	cv=none;
	b=dOtw0WbI4wvb0GxPUrlV0U4q6SK66iO7FBL8w54W2Iv2V7xL4DYjxPNeIZfNUzfjOwSyZF
	V8tPCxPU4SeHuXCEbpmliVBQPqPgjzMS3ch7YXmNK4IO7GRkYTZbVTVrzT18rtQ2Py+26s
	ihr415Hx52g0OuWejJttQPMaTBUTq8A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DCD543B1A;
	Tue, 31 Mar 2026 07:36:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF981C19424;
	Tue, 31 Mar 2026 07:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774942595;
	bh=1aLP5pU2VJqnqi+qS5pxWmVzBh4A4EESl8jLJtYmit4=;
	h=From:To:Cc:Subject:Date:From;
	b=IUbcizklv/BBBOz7QZr8ip9oeUH9fmeVbVP77kIC/XiINHE/wIJPiyCYWApJojsyp
	 0y48Q6C6hrxVB0RQ8XYNdO1AjV/wHfDJpbAYEm3KdUicAKDKh1XX9snBBx747UpUzA
	 mFDHk7nW2vEx45Wh9PTZkKjpETba79IXYswvPA5sasQ3sueNbYDBs5X4a9kmAYgTE0
	 9Aq5c4x3G9dme/KTMoh2IQ2tnbW5HhhVQCRVOX8QZzqMXbcPd0ve62ZRN3HitJygMd
	 +/ksdGYNrlpLzLXVr97cJUS3qOjUaL2V9a2QT0EJX7tBDoGwanmo6G0xl0m5adom2K
	 1XBheC7M8Ki8Q==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] tools/testing/selftests: add merge test for partial msealed range
Date: Tue, 31 Mar 2026 08:36:27 +0100
Message-ID: <20260331073627.50010-1-ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 42428100014
X-Stat-Signature: 5de9ktdwu5jbxbonb8yxtuukd6kea8hh
X-Rspamd-Server: rspam06
X-HE-Tag: 1774942596-686577
X-HE-Meta: U2FsdGVkX1/EDrWiWaA9HO9u5Ddw0jg11zRtjbUJ1Rqauynv14APbQC6H5+AQ/Q8lPF3h17rXpHazECA2VZ0hxvp8R7LRoWkyjhW8ZxRxag5xLMTNtBavnojD+qBlSms+TgA6Wf8EGFWT7aOuU7VUGsrCN8g2/7LgZwu7oTdcEk7OquvvJIUI4AmsRWQ/crIB9wuFfOgw0ii61qrtgnnAE+EX9xcQwSfiLnmGVxKwg0C/joCBV/JdKf0M7EcgMVZd+Hg7akf4Gm2WfW8VC5I0n3DdmhPcwOkXRuX/9OX8D4FVm/boAo7JO+AlZYkv6aalOshrrQWRYMzzhlbF5cAc5obFu6DjTq8iO/ccQ3Y65kentgDnQ9+YzV53OMLuap8NCD4M+3q56Oex8wSOopXzlo7Z6ZZJ7KjbYyT+UzEs3sXnuPL0xaaPcgZcfsetp4z7xtXjh2m9nDG6r0LsT/KJEAxl5mBrfodIZAerVrQAVsc69VxOwpMkdLfmvGU2dlx1RiNXwIzY0KdkBbYsnCCi/dgnJgC34RDnFcdoMGFPlB94Q6Q6yd4sMUw3IyqFWL2NAPLvPvIxGj0zEDCfnEDjy+U/ghzJoE0/K3zyuzgzdGR9fFoosVW1UfDbDZxcWA+vcgyN6PajiQjE9sP/lHX9i+9aWNwaXP75rpAqOMuQbHTG6h6EN3BRQ8zwIM8nKk+fnV9JJE/iHhHsS8RrXb8PsMBpBx0tOuIy56tcO3VZ+CovSxXAqNnKHN2nrZHJfrvcEfeTiclOxNGCKSMJlfDlLb37cOfQfrVvnUEJlXXC66EM8zSWPFbMfBq3JuaxFJO/n0YxZfMXlZP4e3jE8ooZsc8mDo66bUKDkHrOPLzieCyeuBiALqjWFdmad0uBjJr4TvBnx9XUtq2z3QeNTq/V1CPMbRgOWqqAEFXQXocwercCNwz30STqn7UZbmuLTf1TNUPa1CgyoJU/OksiOK
 jQyKCxJs
 kK4tObl7cdnjWxj88PxoQcgizGLduunCoZmbaPUyCTVcCrBsBiqJK+iDJWusGIXfb3LL7BmKR8CjI9OzZ7KrpcQEnbHwh8tQg+yedzB9dAF+9cG8VL4V+Y57XNEukzoCgIa3S4b4Zl9RVTWBVJST2mYsM9PnBVmQZjgZGYJoAEa3Sw6egOyqUKLU6R7C+Fj8lZsy4hFxxmCzrPbksg6fmmcsR37TedW2sU2Ldlxa9IpL5l00=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 2697dd8ae721 ("mm/mseal: update VMA end correctly on merge") fixed
an issue in the loop which iterates through VMAs applying mseal, which was
triggered by mseal()'ing a range of VMAs where the second was mseal()'d and
the first mergeable with it, once mseal()'d.

Add a regression test to assert that this behaviour is correct. We place it
in the merge selftests as this is strictly an issue with merging (via a
vma_modify() invocation).

It also assert that mseal()'d ranges are correctly merged as you'd expect.

The test is implemented such that it is skipped if mseal() is not
available on the system.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
v2:
* Added tools/ based header so __NR_mseal should always be available.
* However, for completeness, also check to see if defined, and assume ENOSYS if
  not.
* Thanks to Mike for reporting issues in his build on this test!

v1:
https://lore.kernel.org/all/20260330135011.107036-1-ljs@kernel.org/

 tools/testing/selftests/mm/merge.c | 89 ++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
index 10b686102b79..f73803b3679a 100644
--- a/tools/testing/selftests/mm/merge.c
+++ b/tools/testing/selftests/mm/merge.c
@@ -2,6 +2,7 @@

 #define _GNU_SOURCE
 #include "kselftest_harness.h"
+#include <asm-generic/unistd.h>
 #include <linux/prctl.h>
 #include <fcntl.h>
 #include <stdio.h>
@@ -48,6 +49,19 @@ static pid_t do_fork(struct procmap_fd *procmap)
 	return 0;
 }

+#ifdef __NR_mseal
+static int sys_mseal(void *ptr, size_t len, unsigned long flags)
+{
+	return syscall(__NR_mseal, (unsigned long)ptr, len, flags);
+}
+#else
+static int sys_mseal(void *ptr, size_t len, unsigned long flags)
+{
+	errno = ENOSYS;
+	return -1;
+}
+#endif
+
 FIXTURE_SETUP(merge)
 {
 	self->page_size = psize();
@@ -1217,6 +1231,81 @@ TEST_F(merge, mremap_correct_placed_faulted)
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
 }

+TEST_F(merge, merge_vmas_with_mseal)
+{
+	unsigned int page_size = self->page_size;
+	struct procmap_fd *procmap = &self->procmap;
+	char *ptr, *ptr2, *ptr3;
+	/* We need our own as cannot munmap() once sealed. */
+	char *carveout;
+
+	/* Invalid mseal() call to see if implemented. */
+	ASSERT_EQ(sys_mseal(NULL, 0, ~0UL), -1);
+	if (errno == ENOSYS)
+		SKIP(return, "mseal not supported, skipping.");
+
+	/* Map carveout. */
+	carveout = mmap(NULL, 17 * page_size, PROT_NONE,
+			MAP_PRIVATE | MAP_ANON, -1, 0);
+	ASSERT_NE(carveout, MAP_FAILED);
+
+	/*
+	 * Map 3 separate VMAs:
+	 *
+	 * |-----------|-----------|-----------|
+	 * |    RW     |    RWE    |    RO     |
+	 * |-----------|-----------|-----------|
+	 *      ptr         ptr2        ptr3
+	 */
+	ptr = mmap(&carveout[page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	ptr2 = mmap(&carveout[page_size * 6], 5 * page_size,
+		    PROT_READ | PROT_WRITE | PROT_EXEC,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr2, MAP_FAILED);
+	ptr3 = mmap(&carveout[page_size * 11], 5 * page_size, PROT_READ,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr3, MAP_FAILED);
+
+	/*
+	 * mseal the second VMA:
+	 *
+	 * |-----------|-----------|-----------|
+	 * |    RW     |    RWES   |    RO     |
+	 * |-----------|-----------|-----------|
+	 *      ptr         ptr2        ptr3
+	 */
+	ASSERT_EQ(sys_mseal(ptr2, 5 * page_size, 0), 0);
+
+	/* Make first VMA mergeable upon mseal. */
+	ASSERT_EQ(mprotect(ptr, 5 * page_size,
+			   PROT_READ | PROT_WRITE | PROT_EXEC), 0);
+	/*
+	 * At this point we have:
+	 *
+	 * |-----------|-----------|-----------|
+	 * |    RWE    |    RWES   |    RO     |
+	 * |-----------|-----------|-----------|
+	 *      ptr         ptr2        ptr3
+	 *
+	 * Now mseal all of the VMAs.
+	 */
+	ASSERT_EQ(sys_mseal(ptr, 15 * page_size, 0), 0);
+
+	/*
+	 * We should end up with:
+	 *
+	 * |-----------------------|-----------|
+	 * |          RWES         |    ROS    |
+	 * |-----------------------|-----------|
+	 *            ptr               ptr3
+	 */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
+}
+
 TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
 {
 	struct procmap_fd *procmap = &self->procmap;
--
2.53.0

