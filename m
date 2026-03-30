Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 911FAFF4947
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 05:39:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17066B0092; Mon, 30 Mar 2026 01:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEFF46B0095; Mon, 30 Mar 2026 01:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C055D6B0096; Mon, 30 Mar 2026 01:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ADCB06B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 01:39:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3BB1813B93A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:39:34 +0000 (UTC)
X-FDA: 84601627068.28.E56875E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8417540008
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:39:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hJncB3CH;
	spf=pass (imf11.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774849172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=g8MpXSBjxcDbsCgL0NjDYzsay2G5UIPAPIPiGXT17zc=;
	b=1eyFRTExv5mDrwlEKGhZEs0T95/WpmY3mobCeamGgKuC369HW+Zf8D0mA/DdSWQn7/+ytP
	QlDNI1WaV7eP6SjYh3N+x2cYqNI2sOfzLvldMPHSbHgUcWpcU4ILrsQQLwwToOk8LHakbO
	g5nTPtZB+t/u+9bc+rHhFosq+4DlErY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hJncB3CH;
	spf=pass (imf11.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774849172; a=rsa-sha256;
	cv=none;
	b=taY9mosB4+TzW+QjyQVxm3SSuccAHs9ZmDVuzQziurCM7DWSvGa1UPkRK2BhqLJm7NxNws
	3FefXY2+35GGFGlOhbnBzOCGCd4GulEbXsu3gAtOmBjOIwGTgXHtEXC4bX1LO6P2aOpmmq
	EuiPDJRjSSKtMwjPgVGgMQq/3t8yx30=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774849171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=g8MpXSBjxcDbsCgL0NjDYzsay2G5UIPAPIPiGXT17zc=;
	b=hJncB3CHwgTRKcIuZFlpuf7of4DIsKlVHVS7lFqFT1z4VFw4yebqkiK+sqYHq56o1QUk17
	u+COZUgYZbA/pIlAKn9Bt/CfFyMnOEc2f3SMDaSn0GBuPD+Vm+t+gGW+p9QA1ubJOytRt8
	8JEKQC1c+60snLOGZ/S+Yq4DZcqZhO4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605-JrK4ZgNOO2yHfjrVqeG6yw-1; Mon,
 30 Mar 2026 01:39:28 -0400
X-MC-Unique: JrK4ZgNOO2yHfjrVqeG6yw-1
X-Mimecast-MFC-AGG-ID: JrK4ZgNOO2yHfjrVqeG6yw_1774849166
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4FAF71956094;
	Mon, 30 Mar 2026 05:39:26 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.53])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58F9B18001FE;
	Mon, 30 Mar 2026 05:39:19 +0000 (UTC)
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
Subject: [PATCH v3] selftests/mm: skip hugetlb_dio tests when DIO alignment is incompatible
Date: Mon, 30 Mar 2026 13:39:15 +0800
Message-ID: <20260330053915.75442-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: rBI8Ed1ftOqOBJM3yY5BywpJsC2Dcrv6mRWwRgTvFr0_1774849166
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8417540008
X-Stat-Signature: 48cwwa9xgfebh1zu41n89z9wpnzujpn1
X-Rspam-User: 
X-HE-Tag: 1774849172-57023
X-HE-Meta: U2FsdGVkX1/iTnyZTct6UbvRGaO44GdgWzP3BqbC83lB78It98BmHnREmTisETHXI51xbf3KmrHFxK6Tm7Buda+81JGRMOBmTBBME95xH/0h8a7kX3FdSHWpwkmyhP5Vl6yrsqnEhD/82aeQJS8kw69g1xIBJA1IEJC+8rzYOK8PnnQDkA8emxyn4SQLtzIZbeopzJVhcrHF+Bw6oLS8c1Ht+FYNiHRI8cQCjJgKsEkXtDmjqQlbYAq9cZbLIwL5yUKGCnMZeCjJsVeujUXf0XLl5BQakCDBIQ+vS+n8twwxCvhxG8i/TBuTYtNRozTfD6FX7wqT2EUIIekn3jhMEGksMxzQ+v+MWnN9Di1vMyMx0x9s1gHk41zuUbq2WCoi1cDZDhnB8B9vrUF2pJ8da4rlJDUUS0FtjAdAx+Q/m38hk7S2d5unTANxCx3IqOGAU0F4anVJvAdAqkNiOdVYaCRQv/scymuTYV8udx+mIO3wFAboHkDihtrR2wUliIB54/9tGc9q7+YAjUeowxuzVIyBZMRX8yqXsdcT5jMhgrBCHI7+gFNUniw0W7+CEy/mwWXqeNC7Qb+QdllEuy0U2yp5MbY6Dq+USdWW9D+vOPOn0bh/m+jQhQc0NWY9nW+q+o6Ie3UnxPnX1JZkp/vlUIg9o0F69b/c7+18q9FJCf4TEvGod8F7rAq6JNiHnKDboFtlFaJeTMh+paYjpIZXJnjDJwqOe/OsOqGiJ+ZOYM3beg8z3YKt/JKgXNbUiuAd6LRkf7h8Xn/P9tsMBPpZ8Oaw9sqWhWPUQWkeHtGONU6flzhm7wDzRiWPtnarDSvd+3Bji3zT3jfV7Ejcqfmb+2EvMGpW4oHHtz2WJSEJARRPf0Ix2Jg9zdZu4uQkI4Ldfh55cBbt81fAafdS2hn1Iprtvk7beJCh3F7KyWA7O/V7bIM/H+008I112NhWqRfMrx5N+DQ8ThIU1X0Rf6j
 NZWF7kZj
 GHvW2yA9xb9F8+ahyLrdQ4pX6T5Z7MUg8+LcpOCPuIXPjyDmnASLBNr14KuhX6+srV8Br
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
via statx(STATX_DIOALIGN) and pass it to run_dio_using_hugetlb(). Skip
individual test cases whose writesize/buf-offset is not a multiple of the
alignment, so that aligned cases are still tested.

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
---

Notes:
    v3:
    	- Adopt statx raw syscall to build on older glibc.
    	- add buf offset alignment check as well
    v2:
    	- Pass dio_align as a parameter to run_dio_using_hugetlb()
    	  instead of generally page_size/2 alignment check.
    	- Add O_DIRECT flag back to the first open().
    	- Add stx_dio_offset_align zero check.

 tools/testing/selftests/mm/hugetlb_dio.c | 62 +++++++++++++++++-------
 1 file changed, 45 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
index 9ac62eb4c97d..b125092fc6c1 100644
--- a/tools/testing/selftests/mm/hugetlb_dio.c
+++ b/tools/testing/selftests/mm/hugetlb_dio.c
@@ -17,10 +17,41 @@
 #include <unistd.h>
 #include <string.h>
 #include <sys/mman.h>
+#include <sys/syscall.h>
 #include "vm_util.h"
 #include "kselftest.h"
 
-void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
+#define HP_DIO_TMPDIR "/tmp"
+
+#ifndef STATX_DIOALIGN
+#define STATX_DIOALIGN		0x00002000U
+#endif
+
+unsigned int get_dio_alignment(void)
+{
+	int fd, ret;
+	struct statx stx;
+	unsigned int dio_align = 1;
+
+	fd = open(HP_DIO_TMPDIR, O_TMPFILE | O_RDWR | O_DIRECT, 0664);
+	if (fd < 0)
+		ksft_exit_skip("Unable to allocate file: %s\n", strerror(errno));
+
+	ret = syscall(__NR_statx, fd, "", AT_EMPTY_PATH, STATX_DIOALIGN, &stx);
+	if (ret < 0) {
+		ksft_perror("statx() failed");
+	} else if ((stx.stx_mask & STATX_DIOALIGN) &&
+			stx.stx_dio_offset_align) {
+		dio_align = stx.stx_dio_offset_align;
+	}
+
+	close(fd);
+
+	return dio_align;
+}
+
+void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off,
+			unsigned int dio_align)
 {
 	int fd;
 	char *buffer =  NULL;
@@ -33,6 +64,12 @@ void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
 	const int mmap_prot  = PROT_READ | PROT_WRITE;
 
 	writesize = end_off - start_off;
+	if (start_off % dio_align != 0 || writesize % dio_align != 0) {
+		ksft_test_result_skip("DIO alignment (%u) incompatible with "
+				"buf offset %u and writesize %zu\n",
+				dio_align, start_off, writesize);
+		return;
+	}
 
 	/* Get the default huge page size */
 	h_pagesize = default_huge_page_size();
@@ -40,7 +77,7 @@ void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
 		ksft_exit_fail_msg("Unable to determine huge page size\n");
 
 	/* Open the file to DIO */
-	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
+	fd = open(HP_DIO_TMPDIR, O_TMPFILE | O_RDWR | O_DIRECT, 0664);
 	if (fd < 0)
 		ksft_exit_fail_perror("Error opening file\n");
 
@@ -89,37 +126,28 @@ void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
 
 int main(void)
 {
-	size_t pagesize = 0;
-	int fd;
+	size_t pagesize = psize();
+	unsigned int dio_align = get_dio_alignment();
 
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
 
 	ksft_set_plan(4);
 
-	/* Get base page size */
-	pagesize  = psize();
-
 	/* start and end is aligned to pagesize */
-	run_dio_using_hugetlb(0, (pagesize * 3));
+	run_dio_using_hugetlb(0, (pagesize * 3), dio_align);
 
 	/* start is aligned but end is not aligned */
-	run_dio_using_hugetlb(0, (pagesize * 3) - (pagesize / 2));
+	run_dio_using_hugetlb(0, (pagesize * 3) - (pagesize / 2), dio_align);
 
 	/* start is unaligned and end is aligned */
-	run_dio_using_hugetlb(pagesize / 2, (pagesize * 3));
+	run_dio_using_hugetlb(pagesize / 2, (pagesize * 3), dio_align);
 
 	/* both start and end are unaligned */
-	run_dio_using_hugetlb(pagesize / 2, (pagesize * 3) + (pagesize / 2));
+	run_dio_using_hugetlb(pagesize / 2, (pagesize * 3) + (pagesize / 2), dio_align);
 
 	ksft_finished();
 }
-- 
2.53.0


