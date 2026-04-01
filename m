Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C32FD35160
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 09:05:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69CD46B0005; Wed,  1 Apr 2026 05:05:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674376B0088; Wed,  1 Apr 2026 05:05:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589A16B0089; Wed,  1 Apr 2026 05:05:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 485C06B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 05:05:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F0B0FE0E4D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:05:40 +0000 (UTC)
X-FDA: 84609404040.21.8B249CA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1266B12000F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:05:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JM6gh827;
	spf=pass (imf29.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775034339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=G1mkLUm4prh4qAYbnuC/D7JWciihmbxYUROMBFnTIno=;
	b=tOasG2osFCchOoQbZCGvKU3v/OceNh8Vdx0P2N1pviimtxlEaIYmI/lvIl0JRv/C1V/bIX
	CZX3hvZMP6X3CqC+tSIcVTvYdfUoFmi+lDQeQoLftPQvBSfxHsj71ZFNZpGDDs3Jxe2N2I
	OHkKDCgY/WUB9UUyoc1Ewzq5NsRINw8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JM6gh827;
	spf=pass (imf29.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775034339; a=rsa-sha256;
	cv=none;
	b=sEDWgwIGp3AsrV8UikPmqLDipZHSogx70FAqf9LXolBKr8A9Lbcfc8i+jXgVuNZK5IHdoS
	q6NGpyFHyS6uv4PWQYwXYDnGHRv4WMuDCmn57GJ8WH8Ul/B4FtlDBgIqIT5yCDaUrChujH
	59/cJzPWER1C7FP1rViIksZxV4SDVDY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775034338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=G1mkLUm4prh4qAYbnuC/D7JWciihmbxYUROMBFnTIno=;
	b=JM6gh827XY4Qwu0ofDdjXQNTayj8tcP/VR1BY7zCvfglFXsWJ30Vv1iZKhIpB9rMrdHt0F
	toHBhdF8LMjIoX3lnLHk8SHJ+or66aqujboGQS3QP7ZSk9ALzDncb89VkHT6NIQR/gmKb9
	MxlybFksbl337OrxsMUfgO4aVIhJQHk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-376-hcwD6IBlMGiPpYHhKxqwfA-1; Wed,
 01 Apr 2026 05:05:33 -0400
X-MC-Unique: hcwD6IBlMGiPpYHhKxqwfA-1
X-Mimecast-MFC-AGG-ID: hcwD6IBlMGiPpYHhKxqwfA_1775034331
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 98F30195C25F;
	Wed,  1 Apr 2026 09:05:31 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.195])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 331541800107;
	Wed,  1 Apr 2026 09:05:24 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: aubaker@redhat.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v5] selftests/mm: skip hugetlb_dio tests when DIO alignment is incompatible
Date: Wed,  1 Apr 2026 17:05:20 +0800
Message-ID: <20260401090520.24018-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: B4IaODO7_cQ2Cae_xS3J1_MIdOTcfVZd-5ehEUWw0W0_1775034331
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 1266B12000F
X-Stat-Signature: 47nca8snh87ebiio4p1oeshs7354pfxa
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775034338-587316
X-HE-Meta: U2FsdGVkX19VIAyZvpAjaLUnrZ+0zuWUSkG/hCObtbC5Cb3u9TA+ZISG7G6hWnFACDlN+mCFkqyLNrN4WlXyH+xGZ557/CbTzisJse7F94HEXwHWYEQoQuwkn4FxVv/Q1Xe3I62ORSgbaAut2ndvEp4BX0p9V5EJd3UO6VnXLgHLpO/kklDqCFIOmJHVba2hNtbdtClfBZNP4TgaCW0LmhDb7ByWgV2HAie3mm2lLfqTreTcqRReXj+vB7QZaD1lwe0a7qOdlxFusILDWeJF1zpPxqN99KymhLHWJ5nl+m3fBLfNL4CYuHrck43JpYtE3JNMRURncRk72yo2yW5fvkeSjztmqDH+edLPv2aVG8g6YXedUzBrAkUC53WZboBYQf4jffyjqheryao3UYmy3QUADaquxLD61CnEwARkUpEuPVPT1rJio/H7uOEifo/P//mmrp/erHIprAcYBIbsY2XzzfET7HZar68wq5B4LgWe/FB3XMJ32cqeSs60aT2GviYnC5Bld81HC8Y2GBGqotgVe0JNuBg7AtNyOqP7hSY7b/e8EGrmFtmRE+9gJ3L9h3PTxJFDtsBFNjcWSRu/lF1DgcOXrfcl9a6FP3EXsN2XK84+gjVHU4W1RFPg1KUgehfeT/tIQoOOhlmWP5izS7AzcV1PjyY716yWcpIfixZuTnqxi2dAfqXqeMtheeg90Y7lNMwMXN3l941a0EPkWPRarc9dDDIJbdn6m4NYX/VC0qgyKDrhs+D8x6FRdMz+0Jh87eFDbQ6HIxW3q4uL77NIfcOcKZLsiXJeERW43oCKF+yK2yeCNh86rNxtQRsS6DWQ2XM5V6e2wL3oD/Xs8iQ3dDzoR5jVPtcUZ18VM/RIFpalApRXaw7aTCetHgWR3uIz5j5EDz75KKZqeiOYZ7lnKloEFFfCQYFESEnod0csoGbdtGpo+btjA859vrUlRj5FC9EPQyUPT66Bvap
 XVN4XCm3
 YimJ+Z3reXAwrV7TYceHmHwQFs4KANHhScsozt/EI52SUHQ50xzvE7xc8FluswS/+Tt+K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_dio test uses sub-page offsets (pagesize / 2) to verify that
hugepages used as DIO user buffers are correctly unpinned at completion.

However, on filesystems with a logical block size larger than half the
page size (e.g., 4K-sector block devices), these unaligned DIO writes
are rejected with -EINVAL, causing the test to fail unexpectedly.

Add get_dio_alignment() to query the filesystem's required DIO alignment
via statx(STATX_DIOALIGN) and skip individual test cases whose file
offset or write size is not a multiple of that alignment. Aligned cases
continue to run so the core coverage is preserved.

While here, open the temporary file once in main() and share the fd
across all test cases instead of reopening it in each invocation.

=== Reproduce Steps ===

  # dd if=/dev/zero of=/tmp/test.img bs=1M count=512
  # losetup --sector-size 4096 /dev/loop0 /tmp/test.img
  # mkfs.xfs /dev/loop0
  # mkdir -p /mnt/dio_test
  # mount /dev/loop0 /mnt/dio_test

  // Modify test to open /mnt/dio_test and rebuild it:
  -       fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
  +       fd = open("/mnt/dio_test", O_TMPFILE | O_RDWR | O_DIRECT, 0664);

  # getconf PAGESIZE
  4096

  # echo 100 >/proc/sys/vm/nr_hugepages

  # ./hugetlb_dio
  TAP version 13
  1..4
  # No. Free pages before allocation : 100
  # No. Free pages after munmap : 100
  ok 1 free huge pages from 0-12288
  Bail out! Error writing to file
  : Invalid argument (22)
  # Planned tests != run tests (4 != 1)
  # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

Signed-off-by: Li Wang <liwang@redhat.com>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---

Notes:
    v5:
    	- Perform that align checks at the beginning of run_dio_using_hugetlb()
    	  but not addinital run_test().
    v4:
    	- Open the file once and pass the fd to functions.
    	- Add check_dio_alignment dedicated to alignment checking.
    v3:
    	- Adopt statx raw syscall to build on older glibc.
    	- add buf offset alignment check as well.
    v2:
    	- Pass dio_align as a parameter to run_dio_using_hugetlb().
    	  instead of generally page_size/2 alignment check.
    	- Add O_DIRECT flag back to the first open().
    	- Add stx_dio_offset_align zero check.

 tools/testing/selftests/mm/hugetlb_dio.c | 91 ++++++++++++++++++------
 1 file changed, 69 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
index 9ac62eb4c97d..31a054fa8134 100644
--- a/tools/testing/selftests/mm/hugetlb_dio.c
+++ b/tools/testing/selftests/mm/hugetlb_dio.c
@@ -17,12 +17,57 @@
 #include <unistd.h>
 #include <string.h>
 #include <sys/mman.h>
+#include <sys/syscall.h>
 #include "vm_util.h"
 #include "kselftest.h"
 
-void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
+#ifndef STATX_DIOALIGN
+#define STATX_DIOALIGN		0x00002000U
+#endif
+
+static int get_dio_alignment(int fd)
+{
+	struct statx stx;
+	int ret;
+
+	ret = syscall(__NR_statx, fd, "", AT_EMPTY_PATH, STATX_DIOALIGN, &stx);
+	if (ret < 0)
+		return -1;
+
+	/*
+	 * If STATX_DIOALIGN is unsupported, assume no alignment
+	 * constraint and let the test proceed.
+	 */
+	if (!(stx.stx_mask & STATX_DIOALIGN) || !stx.stx_dio_offset_align)
+		return 1;
+
+	return stx.stx_dio_offset_align;
+}
+
+static bool check_dio_alignment(unsigned int start_off,
+				unsigned int end_off, unsigned int align)
+{
+	unsigned int writesize = end_off - start_off;
+
+	/*
+	 * The kernel's DIO path checks that file offset, length, and
+	 * buffer address are all multiples of dio_offset_align.  When
+	 * this test case's parameters don't satisfy that, the write
+	 * would fail with -EINVAL before exercising the hugetlb unpin
+	 * path, so skip.
+	 */
+	if (start_off % align != 0 || writesize % align != 0) {
+		ksft_test_result_skip("DIO align=%u incompatible with offset %u writesize %u\n",
+				align, start_off, writesize);
+		return false;
+	}
+
+	return true;
+}
+
+static void run_dio_using_hugetlb(int fd, unsigned int start_off,
+				unsigned int end_off, unsigned int align)
 {
-	int fd;
 	char *buffer =  NULL;
 	char *orig_buffer = NULL;
 	size_t h_pagesize = 0;
@@ -32,6 +77,9 @@ void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
 	const int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
 	const int mmap_prot  = PROT_READ | PROT_WRITE;
 
+	if (!check_dio_alignment(start_off, end_off, align))
+		return;
+
 	writesize = end_off - start_off;
 
 	/* Get the default huge page size */
@@ -39,10 +87,9 @@ void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
 	if (!h_pagesize)
 		ksft_exit_fail_msg("Unable to determine huge page size\n");
 
-	/* Open the file to DIO */
-	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
-	if (fd < 0)
-		ksft_exit_fail_perror("Error opening file\n");
+	/* Reset file position since fd is shared across tests */
+	if (lseek(fd, 0, SEEK_SET) < 0)
+		ksft_exit_fail_perror("lseek failed\n");
 
 	/* Get the free huge pages before allocation */
 	free_hpage_b = get_free_hugepages();
@@ -71,7 +118,6 @@ void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
 
 	/* unmap the huge page */
 	munmap(orig_buffer, h_pagesize);
-	close(fd);
 
 	/* Get the free huge pages after unmap*/
 	free_hpage_a = get_free_hugepages();
@@ -89,37 +135,38 @@ void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
 
 int main(void)
 {
-	size_t pagesize = 0;
-	int fd;
+	int fd, align;
+	const size_t pagesize = psize();
 
 	ksft_print_header();
 
-	/* Open the file to DIO */
-	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
-	if (fd < 0)
-		ksft_exit_skip("Unable to allocate file: %s\n", strerror(errno));
-	close(fd);
-
 	/* Check if huge pages are free */
 	if (!get_free_hugepages())
 		ksft_exit_skip("No free hugepage, exiting\n");
 
-	ksft_set_plan(4);
+	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
+	if (fd < 0)
+		ksft_exit_skip("Unable to allocate file: %s\n", strerror(errno));
 
-	/* Get base page size */
-	pagesize  = psize();
+	align = get_dio_alignment(fd);
+	if (align < 0)
+		ksft_exit_skip("Unable to obtain DIO alignment: %s\n",
+				strerror(errno));
+	ksft_set_plan(4);
 
 	/* start and end is aligned to pagesize */
-	run_dio_using_hugetlb(0, (pagesize * 3));
+	run_dio_using_hugetlb(fd, 0, (pagesize * 3), align);
 
 	/* start is aligned but end is not aligned */
-	run_dio_using_hugetlb(0, (pagesize * 3) - (pagesize / 2));
+	run_dio_using_hugetlb(fd, 0, (pagesize * 3) - (pagesize / 2), align);
 
 	/* start is unaligned and end is aligned */
-	run_dio_using_hugetlb(pagesize / 2, (pagesize * 3));
+	run_dio_using_hugetlb(fd, pagesize / 2, (pagesize * 3), align);
 
 	/* both start and end are unaligned */
-	run_dio_using_hugetlb(pagesize / 2, (pagesize * 3) + (pagesize / 2));
+	run_dio_using_hugetlb(fd, pagesize / 2, (pagesize * 3) + (pagesize / 2), align);
+
+	close(fd);
 
 	ksft_finished();
 }
-- 
2.53.0


