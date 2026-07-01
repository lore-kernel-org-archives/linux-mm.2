Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4210C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 20:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622F96B00A8; Wed,  1 Jul 2026 16:01:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FA7C6B00A9; Wed,  1 Jul 2026 16:01:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8F86B00AB; Wed,  1 Jul 2026 16:01:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 286A76B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:01:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 85DE68D611
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 20:01:52 +0000 (UTC)
X-FDA: 84941278464.19.B04F343
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 08CDAC0011
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 20:01:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BJsV/rpY";
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782936111;
	b=0oSd0NOEw2OYlHRtbEkyUIXmH1vuQH4iqsYRntVR7hQWZmisju3WOp08BvxPS5SJgWj5SX
	fVaXjp3yWOIx0iFmWLYYiT8/YHAwDrr2tyYPOeLbIGOlxCKD0rqzYGl25XPQfAiA+AJIKZ
	4uP53xMQyIm5kJAdTSNNg9uwf/qgOf0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782936111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TvSshaYaWYRW+SwJgWNvjOVVLpEc9oved1ALiTQdTMw=;
	b=EajGZxnF/bIE2wvkjLg169wIPZagzclP9mLQeAOa/5Ymy/nnZSNnA+eIUpA1CwLoZ25rSL
	1kzjkHX7/9VslVUYtUFYn8ja6wMs4WtFweQEcAPNDmXbCsAlCx3TBTNEAA7ENLA8avjNzj
	MHtr1HQZt9b405QJenOMk+K9ZS6ip64=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BJsV/rpY";
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E7C4443A80;
	Wed,  1 Jul 2026 20:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB881F000E9;
	Wed,  1 Jul 2026 20:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782936109;
	bh=TvSshaYaWYRW+SwJgWNvjOVVLpEc9oved1ALiTQdTMw=;
	h=From:To:Cc:Subject:Date;
	b=BJsV/rpYN3/oOqsrMhJz1343YzEzPMHR27/2V0TQjFe9hc3zIc9JLgIxIlY2C/KEP
	 iTxCkBJFygaLbVRj0erQ5ybf7DqFpALF+UrmJDx//C/h4mWich5eGhOZy/Vq/bHwmT
	 +gs3YilM4KQybhjdSdx43ilEL2U5PKBlBtYOl2hmkXl3efW4dqqpeqsHIIj0NOYIAi
	 hEVIaub6QNxzp8VXkOBt4SgqrG4MlJFZI3H25qurJ6E8W0AQuxnrr3feEctLtA8mHn
	 LNwmJXAd34CyUj2KJ/p3fnU+Yb7W7Lq9B3h2Qw/VqDo4HTYk2NgtfpZmJPKA0qZJAc
	 7+27+9FBYJRgQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] dev: selftests/mm/uffd: don't treat UFFDIO_COPY -ENOENT as a failure
Date: Wed,  1 Jul 2026 23:01:43 +0300
Message-ID: <20260701200143.1470229-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 08CDAC0011
X-Rspam-User: 
X-Stat-Signature: 46fuiu7qg4dozem49c1qkpbhm8bxb13g
X-HE-Tag: 1782936110-137427
X-HE-Meta: U2FsdGVkX18N5lyiWMx737RvZpnnaDynR8gUg40OZehvk7Kv4tBHzQdviD2Hkxn3QDWTmRzFNcG0vfIZutFWL6sIZce7zAZtAdhblm8y/kDkqFR7KQ0HEnw3iLeZlvJsHJbvQwZccsNsonNNqXP5JOxTF8OyEZqpxIM8+tHR4lGK4va2x0TeQBTXfWTUbkLN51RHfrtEGyEiBslUJqCK4YSGzcF5mrN07wrd6QZGTCe2iJFuka7fk8TLB9bMOZ8RdEo9UHNghmP6KslTRXnEgFt/VtmJbh8+O4V7HfJ2TcCVSloW/ZD0uW2Jx/V3iRdEsYzEGm5wHEU5NR3V4dNsNWE9DqP1Hpa0OE6WqA7mD2Z7DODO08WuYHvpivWKftQ3TS6IkILo7Lyu29xNIWL7lkRpjDO8/kNK5I+zAb6T4lviE/nfldgSLBOqtIB4qeBanu0uS615BuG7G5ii4nRpb6sIcmDLnsfPjeqpSH+oI6SXttU2wBmJCTOXal2rDDRnTyuBjz2fAG0OvdIwJmkkeipk+TzJiteCssa7WlG+54sY9896kke9iKteR3t9awO89ImKJ5QPnPL3tby31aHRkMsJcwZw2WHn017/IGeJ1tXsIn7aPrzX6T+1tyKhxVBjqWtRblgU12kiOpzUsLX1gDCQcKSsuhnLHlYfYn+AX5TZlLyZ+YzpFsgZQaMry2gXueoP8M01MWd8qFAd3VXbZ0Sw+PuyARqRwAQyd32z8rhbjy2JYeVXcrQp5yB/5ph31TCQR+EfFMx94CL8AZnHFag4FDaxpqT9gCxRGqwZKmB7ZvVSq6S6S+X9vG1MR5zYOqUHh4tVGAseZywa1Slr+uckxgseV2nDOnBIMBwBM1lW9wP0JEJhe+QrYeXsq3dieIqTeVfBO5M9QuedjXfG8vxpXmfiop3Q9ZPSaj9nKqv1/osjCmnwXJlzR2+2zvG6gYdLkKmavb8AFX8Zu+E
 2C8Kpo+2
 N4cLqcAAZ8p/qXvmx7vTH6QN3q3a1bIo47X3tKZ8coWD+HkBmzjOo1ylhnJQoJfB6gkT1NojelJh0hIMOHfWE3V4O8ugXBnZJOqrYFnRnEs4zSSzBA8n2BKragONu2/VfsWP7VbwORtk7SjZFs9x++AAZtmeOd9/E7xRv+H0Ua+pqsA+NF0yttkb3GofrTiNWaFzWkATGV97P29OCrv5gC6UVOCZIccZ4kZmS/uALYlP/57yi/6pVL4T8HPjrAWuuC/WsrQCiPwpkwYHT36BVsC82wui9yurj+W9nFC80mYR2FD+6N0WNAAUkXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Non-cooperarive uffd events are inherently racy and can happen in
parallel with other userfaultfd operations.

During event tests in uffd-unit-tests, the uffd monitor calls
UFFDIO_UNREGISTER upon receiving UFFD_EVENT_REMOVE.

In parallel, the faulting_process() verifies that the removed memory is
actually zeroed.

If a verification read wins the race with UFFDIO_UNREGISTER, it causes a
missing fault that uffd monitor would receive after UFFDIO_UNREGISTER is
complete. The monitor resolves the fault using UFFDIO_COPY that fails
with -ENOENT which means that VMA has been changed (see commit
27d02568f529 ("userfaultfd: mcopy_atomic: return -ENOENT when no
compatible VMA found")).

Treat -ENOENT returned by UFFDIO_COPY as non-fatal, the same way
-EEXIST is treated for concurrent faults, and don't fail the test.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
I've noticed transient faults of uffd-unit-tests in the CI runs [1]
and found this issue with uffd-unit-tests.

The issue is longstanding and it's not related to or exposed by the
recent uffd refactoring.

I didn't even look for a Fixes: commit, as this is a selftest only and I
don't see a reason to backport it.

[1] https://github.com/linux-mm/linux-mm/actions

 tools/testing/selftests/mm/uffd-common.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-common.c b/tools/testing/selftests/mm/uffd-common.c
index edd02328f77b..f48f5d4594ab 100644
--- a/tools/testing/selftests/mm/uffd-common.c
+++ b/tools/testing/selftests/mm/uffd-common.c
@@ -639,8 +639,13 @@ int __copy_page(uffd_global_test_opts_t *gopts, unsigned long offset, bool retry
 		uffdio_copy.mode = 0;
 	uffdio_copy.copy = 0;
 	if (ioctl(gopts->uffd, UFFDIO_COPY, &uffdio_copy)) {
-		/* real retval in ufdio_copy.copy */
-		if (uffdio_copy.copy != -EEXIST)
+		/*
+		 * real retval in uffdio_copy.copy
+		 *
+		 * -EEXIST: the page was faulted in concurrently
+		 * -ENOENT: the destination range was concurrently removed
+		 */
+		if (uffdio_copy.copy != -EEXIST && uffdio_copy.copy != -ENOENT)
 			err("UFFDIO_COPY error: %"PRId64,
 			    (int64_t)uffdio_copy.copy);
 		wake_range(gopts->uffd, uffdio_copy.dst, gopts->page_size);

base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
-- 
2.53.0


