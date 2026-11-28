Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE779606A326
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 06:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tOktkm0z
Received: by kanga.kvack.org (Postfix)
	id 4B21D6B05B2; Sat, 28 Nov 2026 01:52:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462046B05B3; Sat, 28 Nov 2026 01:52:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3515E6B05B4; Sat, 28 Nov 2026 01:52:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0498E6B05B2
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:52:00 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 47B95160186
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:51:59 +0000 (UTC)
X-FDA: 85483607958.30.3742F18
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C1BAB20004
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:51:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tOktkm0z;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795848718;
	b=6q8+cScHupQW27b+7Snw4NmXXCJlzWLdeiX69PDCATMpCBn18VrmwAolqwsYPBcnNaroI1
	nnNi+fl9q9bPlqFrMBOWlNcpjYY2HGSZDqPKge0yJ/AjWb41hwDqt4NqVM4FVj1aN0b3p5
	s7Y8vyv2k8/mxY97JkgzrzS9gDL6JTo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795848718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=WcLWvYb3QXJ4yKM0gPpmep5gEOh7j1U3DkXAEa56+KI=;
	b=6cFC7ETlVOgYgF1kILIDH9JBLCXY2nex6Vi2EsEf5blWk5UBnpzMzzeMc0OpsoXhYtqWpI
	mHSoULI4g2PCQLMyfIMTO6ks36u56Ra9mB46wSi8xFrm514il56l+o/XWqdu6mvl4wU0ik
	IpvjNv8FMsSJaGoZ5fmmO3nQgLEAzlc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tOktkm0z;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 086F6448E9;
	Sat, 28 Nov 2026 06:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BFD1F00893;
	Sat, 28 Nov 2026 06:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795848716;
	bh=WcLWvYb3QXJ4yKM0gPpmep5gEOh7j1U3DkXAEa56+KI=;
	h=Date:To:Cc:From:Subject;
	b=tOktkm0zvUHLApMO4YHsst6hhGxaxOYwyxgGOPXF0U+Yb/rrMBW0PqfObLHagn5Uo
	 orJ6NdDbc8fb/m90o3SuD58ehtD4oNH+8FnxE2t3+Iqdtg93NTPZJjp38W20SCcHNp
	 Rpy3EtgkAyd2NspTyx/LxvB13ScHXO3WuG8lpul4=
Date: Fri, 27 Nov 2026 22:51:56 -0800
To: Kurt Lin <lylin1023@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 Amir Goldstein <amir73il@gmail.com>,
 Eugenio =?utf-8?q?P=C3=A9rez?= <eperezma@redhat.com>,
 German Maglione <gmaglione@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <1c93b263b19d4465899bb81efd62bcb3.1@linux-foundation.org>
Subject: [PATCH 1/9] selftests/mm/memory-failure: check that fsync() reports hard-poisoned dirty page-cache
X-Rspamd-Queue-Id: C1BAB20004
X-Stat-Signature: q7huncgtsz1ycar4wq9z7nouxqn6iiqc
X-Rspam-User:
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PP_MIME_FAKE_ASCII_TEXT,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795848717-75058
X-HE-Meta: U2FsdGVkX19wgDecGlhlp73YXuuAZLajwMqgsCDiEXPg420IiR8qrYXQaKNp8NIVQrzTlTReXjE/RLi/1lhLBdqh4P6CejMlUIsGUvMhTM6XyFZLp0a3ZpYJvdJ+RgKXJ56ZY3V5dEbXgAswXDzM/k2WvdJKlE4SCBZ7XMRSuS8FPW9Dh4pFIPZKIHv0WPXbKwVW/j+DYim9TQOBZoM/WxzjZ9AFwexjmkwlWybECkxgv6dz7qI9gXvoSg8xCvKAHACi+HT0/Fyc8BiPhTo+aVGmH/gpaUHNLfhgeHcnu6/upOF9SiM+Z3WWyRRt+SKAq16cmmafmXWdqMlNd7MkAOAX7r37xDLTztYhPROCS25s9E2WtpVna6Zszojz1ywJwBSu18PfPZtWp36m+6evZ7c0ytFac2P1r4jz4iNMLVrttW58mreNzjkniz7XiEBG/JOVvNM2L1jBqlBe70mZUu+hu4l2P2wyJl+H32LmK5D+K6HOKWmp3/PtMStg/lc0j79W+/+E2sSc7s4UNxGB/8HJhUPuuAPW+GqX1FWdN7FIqyIDoX3tnDCq9Jvs4tmvchjUK4DMLkvjFLeBkyyPMNFGLrmBowgIq+TzvANAb+h0PuwrYUwZMlBF5P5Hv4hN7+lrZYcs+0zMrQv8BM+y6VHriSDG+3UgxvqYbEOb4MQWiBixZJZQ2g0ZIaKrUXYiytakr+48At6nzjGqgDDS5bqDkWdq1fYQKpDQC0yKBy9WiX+5QILxMbAsvdOFZxJDoXH/dhcFoz9Z+ZKZu8fZrfcDeRzp9M4SbxqW1GENoM3Yso8dsWBsqEMZ67OMHrAWdpguEYClYz3koBD0LemqTeEHUNUs7WPsvZh/eIx3Wfz1ucWqsgMPZj42z5nGgzaNs0jq/9cblKrwZq3MH+pLsOO7CTD9JElPFT9oqpXrjmgQk3agQ/mcYSsfpOq/bcnAvrrU/4c5gWSzWjQWK5O
 cgtAOyP1
 KMfg0WWu4B1ZbU0zfNsVfCjIpfmoPd2MoLrNvjsHE5hN0ic7oXdmG8NNCbPrLDc0iIKTt0NaXRQ9CXxGlSzpxVB7zqOnF26QzaXU0+WksCWO4K8fpvKMgMZP5GHwC9dZMa1ptPq+xKboHYecQmv2dRRKhMWPWnhJAp1dCtwLxU5jkO6LNMz/EORJpm099bFE2KKg45uEsxDBHG95vQf0Ja6hngP6dI8b3hN5yL/39JBOdHutxVg1bOKV7bZuLF3KK0LWZcEEjZCbjvz9xAniYr3ZnU0uBZtA5T6Cm9tydLXDy+XbhmAExRxI0Y+AQEsI76uZo52+5nyKsAni5zQwtJ0+S+xjYeQxXTo+K7G7fxp1kzlJXQqCKHK7XzbytOYZNBphGw0Obe5xzv3yi7EhFovBgsQzNwFDTvLesOYLjYXDy0z7RrsBEfckCEi8SGsXj1YK3eeJ49hsltOnGUIDRnBy18hZiIqjQZcp/IMjKOxVvH4vWtDJyMu6OBx+CZGOyVNDw+D8npOtuLKggCw/kQ9dpcdSVH4MYKDfZkO/XoLxjMoyJXd1wGQ5W2eR8dp70o96GTcXocN8l1KDB4pCdPVTPPNEQ86M8qPGddA+MUwuMm6oeflRclfyl1nOwucgqkt9R1AVqT0rlul72NXmdQH2rfYlhxt+U3d9tb7+bmnAz8AAlZRDtFsCELxVuUFpcLuQqFug19KC9uH/X14gh7Yg8arvgugUKV0/kF8epaduhw552ylfCfZy1AlTCYlUox9zZitx/FZ5+ZzcS4OarC3MGWix9qN0Ee0IaCexkADnlEq3neKqx95jmFlCKyFF6nRY8w9JP8gOaWR2zfjWSJ2R1WUeGCjH/gGjwQIk5G25j9RSHES+o2bg1YvE5ctBqixpRDMVD+3DFFyrh0EyaDzWfOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests/mm/memory-failure: check that fsync() reports hard-poisoned dirty page-cache
Date: Mon, 23 Nov 2026 23:18:44 -0800

MADV_HWPOISON on a dirty page-cache page records -EIO in the mapping.  The
test currently requires close() to succeed but never checks whether the
error was reported.  Filesystems with ->flush() may return EIO from
close(), while those without it can leave the error unnoticed.

Require fsync() to return EIO after hard poisoning.  It consumes the
mapping error before close(), allowing the NFS skip to go.  The clean and
dirty page-cache cases also skip tmpfs, ramfs and hugetlbfs because they
have no backing store from which to reread a poisoned clean page.

With the complete selftest patch stack under x86_64 QEMU, ext4, FUSE and
NFSv4.2 reported 10 passes; NILFS2 reported 9 passes and 1 skip.  The FUSE
server used for this test was a minimal server, not virtiofs.

Fixes: d51b5076c746 ("selftests/mm: add memory failure dirty pagecache test")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Kurt Lin <lylin1023@gmail.com>
Closes: https://lore.kernel.org/20261123-memory-failure-fuse-skip-v1-1-19dcbda6e2e8@gmail.com
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: German Maglione <gmaglione@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>

 tools/testing/selftests/mm/memory-failure.c |   38 ++++++++++++++----
 1 file changed, 30 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/memory-failure.c~selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -300,6 +300,29 @@ static int get_fs_type(int fd)
 	return ret ? 0 : (int)fs.f_type;
 }
 
+/*
+ * The page-cache tests need a filesystem which keeps its data on backing
+ * store.  When a clean page is poisoned the kernel drops it and the data is
+ * read back in.  When a dirty page is poisoned the data is lost, and the
+ * kernel records -EIO in the mapping for fsync() to report.
+ *
+ * tmpfs and ramfs keep their data only in the page cache.  The poisoned
+ * page cannot be dropped and read back, and their fsync() does nothing, so
+ * neither expectation holds.  hugetlbfs is the same, and it also poisons a
+ * whole huge page.  shmem has its own tests below.
+ */
+static bool fs_has_backing_store(int fs_type)
+{
+	switch ((unsigned int)fs_type) {
+	case 0:
+	case TMPFS_MAGIC:
+	case RAMFS_MAGIC:
+	case HUGETLBFS_MAGIC:
+		return false;
+	}
+	return true;
+}
+
 TEST_F(memory_failure, clean_pagecache)
 {
 	int fd;
@@ -311,7 +334,7 @@ TEST_F(memory_failure, clean_pagecache)
 	if (fd < 0)
 		SKIP(return, "failed to open test file.\n");
 	fs_type = get_fs_type(fd);
-	if (!fs_type || fs_type == TMPFS_MAGIC) {
+	if (!fs_has_backing_store(fs_type)) {
 		close(fd);
 		SKIP(return, "unsupported filesystem :%x\n", fs_type);
 	}
@@ -353,13 +376,7 @@ TEST_F(memory_failure, dirty_pagecache)
 	if (fd < 0)
 		SKIP(return, "failed to open test file.\n");
 	fs_type = get_fs_type(fd);
-	/*
-	 * MADV_HARD poisoning of dirty page-cache data records an expected
-	 * -EIO in the file mapping. NFS reports this error on close(), so
-	 * skip this variant.
-	 */
-	if (!fs_type || fs_type == TMPFS_MAGIC ||
-	    (fs_type == NFS_SUPER_MAGIC && variant->type == MADV_HARD)) {
+	if (!fs_has_backing_store(fs_type)) {
 		close(fd);
 		SKIP(return, "unsupported filesystem :%x\n", fs_type);
 	}
@@ -386,6 +403,11 @@ TEST_F(memory_failure, dirty_pagecache)
 
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 
+	if (variant->type == MADV_HARD) {
+		ASSERT_EQ(fsync(fd), -1);
+		ASSERT_EQ(errno, EIO);
+	}
+
 	ASSERT_EQ(close(fd), 0);
 }
 
_

