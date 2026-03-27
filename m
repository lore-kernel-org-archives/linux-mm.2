Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 316B410ED64A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 12:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 524626B0096; Fri, 27 Mar 2026 08:03:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FBCC6B0098; Fri, 27 Mar 2026 08:03:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C3B56B0099; Fri, 27 Mar 2026 08:03:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BC8D6B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:03:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C5B8D1410EE
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:03:24 +0000 (UTC)
X-FDA: 84591707928.20.5C26A3C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 82FCB180005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:03:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aFsY2WyG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774613002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=m7nefQy6MzFPaVFBX4vR9wqZM8EfsR8dpshxHtPRdhI=;
	b=QjLJ5ltv+Yb2BJNKJJHgBvyvbWD2YUz0YlJ9DQ9a4uw/8its3lkN8L8kn/ZaWlJteFblIH
	dyXF4nkNbVN/Esiy4WzC3uB/OGu107t/gcH89mRAJcSNbK9Vu9RqSKLp58/sZkHOIU3s0P
	ES4vEV339mydbQwPm9Cw2sour0P6DHA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774613002; a=rsa-sha256;
	cv=none;
	b=iCe7QTXd1KYaTNAhOBvtO2puDCGZTmaqAEAh2+CdoGyH6mtYZkjVWNIYjyEj0ZS6ZrHCLc
	mcy8N8mpUpWZ+tVOvIMckhY2muyY71MkNC9aCkN7OUMJQpNLs1dtjloJOB13JfoWhoYS2U
	g/X+byJw0qHI1fPTqtnzoOcpM/jqUIA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aFsY2WyG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774613001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=m7nefQy6MzFPaVFBX4vR9wqZM8EfsR8dpshxHtPRdhI=;
	b=aFsY2WyGwKSTPyOwbCVMPFwcpSe05/WYRX8+BP0JO3e92+SFSaH2lBkAuADtHJVFMaif5t
	BsHna6Bq5ViDyWGZyycvbTpkMs4bZsC/vBEy3Obl4dujfZlxoYcWFqDvbUDBZ+CWOnigzq
	8Z5AYsx15d6+GT+NtrD8VW68bOswfFY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-dgl2yJLpOAahmfcCskk-Zw-1; Fri,
 27 Mar 2026 08:03:18 -0400
X-MC-Unique: dgl2yJLpOAahmfcCskk-Zw-1
X-Mimecast-MFC-AGG-ID: dgl2yJLpOAahmfcCskk-Zw_1774612997
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95A5B18005B6;
	Fri, 27 Mar 2026 12:03:16 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.57])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 13F051955D71;
	Fri, 27 Mar 2026 12:03:09 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: aubaker@redhat.com,
	liwang@redhat.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] selftests/mm: skip hugetlb_dio tests when DIO alignment is incompatible
Date: Fri, 27 Mar 2026 20:03:05 +0800
Message-ID: <20260327120305.58653-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: 23jkp0FEue7go4ZQoJ5wjH_h5z3j_GU36AF0QU2JgA8_1774612997
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 82FCB180005
X-Stat-Signature: cfyhp9kbp8roqqwhcetgs4kazq6o3su3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774613002-332
X-HE-Meta: U2FsdGVkX18JIMxZhUz9xaHB+oxDy/ei20zyCZd6ggEUky1dK9b+G/WRa3liNWqTEiSfXX1dHDqF8xCiGBcBvHMza3Kh4GgQrh13mtbYuHYd1Vvqt4aqcr9rPNDwanga1dy42hPzsYtqRkz3axxH2VUWJPElMAioka+GBC/y28AQrn72JzP4np41LHKztRH200LA/yhL1v4jjJ37yAPKBXLxYUcK8j+/pB5cJwb4XvM3NW6j6By6ae5/6HvhGTpZJCjVBjnWTgDNNlVJtYvkFPFszXU6ujFIvP+xDwAKgO2jdW5FdkT/4/ComEpk4UFH62NMMbQti2QxQx9U9Mwhqk8vdG+adMsBFIg1CgytxCTKi/2luz6MiZSKbtXpZQAi+BDGVLuT0suzXZDUDCVITGzSp3nKL+tNxtYKmnMi1nn+GyJlpXltX0zZJQUUGGS9viSbzprDYx9aZ/aBOcKqF8I5hlG+RZdsOFNYGrryTXqVOGiSwGYZeRhogqyDvuBidGTKj7kWjtWkBbl/UQVb2tERezpobpUzuE4QD9rHC4F+t0ZBv8FnK9xZOfYdwVe0VC/RHxjtqNIISKs2/4IUL8yt6jHCbLCvQneTp/ykVPHBpnUlnHyiQ7blmAU2asu4DcUQUtfEh8nCzyp44B2yJqhkW7tEiw+mIRZm/mZqVtL+wtJjqPoBaydZGkCis5Jj6fecNj7MbZqpVBtFeAi2xATYY0N8fi1Vv0sNFTJsxevkVxK0hTz5WisoH6wr+yNU/+ixpxWzoqSBqE8Y+SxAIBXDGdWkOXA98G3/Eq6jkcPKzfftEe2GCz2QzqPR06Llzi/7hnupvSfYOnEhW5a7Pp/RFsxIDoj+WAHakb3o1a5653itc29mvTS80YSZ/vTxf5j/0gI65j52iCZfw+yS5kH/T1eOAxKbm6eDNziSaXaxvRkr0Oy7t3Eaycu53zzWgPiBBKJ4h4Gbb/WR7x8
 3KPX+EgX
 xnHNYffSSwWd1kN8lBA45FYFe7jN/KMshvi2pjyesG1xDkdpbj7eDmAOTb0FEFWntg6oJscDs5gKvUB2xVwo3chLrGDICUaOh2Z/Cg2S4N9DAIkCLbNJnwAOjIdSlNoWdgOa04VEfpzmX2JiBI9Bjdg+OGEq47Fwvi74z6LWLRfWzV1MKCXRq8oxQhj2k9oYTT94b83o8kh8ROATZUIlRG/y9JWBFKpkGIeLWiPcwmyJqwLFXOv55/Kka9DDsl+lTJ1vLT5yNu+cHLohTocqTeHb5FNMSIVfmCvTL39gqtGX/4dvf+mI1rZs65ZF/Tx+dkIS39m9XHGQBEAsezvecJifcZYKOUwZuxDr0r+tfWXFZCNsE8+j4asDrA4M1aWpYCT3IdNSObe2AJd0=
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
individual test cases whose write length is not a multiple of the
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
    v2:
    	- Pass dio_align as a parameter to run_dio_using_hugetlb()
    	  instead of generally page_size/2 alignment check.

 tools/testing/selftests/mm/hugetlb_dio.c | 56 +++++++++++++++++-------
 1 file changed, 40 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
index 9ac62eb4c97d..638a8abe3ae2 100644
--- a/tools/testing/selftests/mm/hugetlb_dio.c
+++ b/tools/testing/selftests/mm/hugetlb_dio.c
@@ -20,7 +20,35 @@
 #include "vm_util.h"
 #include "kselftest.h"
 
-void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
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
+	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
+	if (fd < 0)
+		ksft_exit_skip("Unable to allocate file: %s\n", strerror(errno));
+
+	ret = statx(fd, "", AT_EMPTY_PATH, STATX_DIOALIGN, &stx);
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
@@ -33,6 +61,11 @@ void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
 	const int mmap_prot  = PROT_READ | PROT_WRITE;
 
 	writesize = end_off - start_off;
+	if (writesize % dio_align != 0) {
+		ksft_test_result_skip("DIO alignment (%u) incompatible with offset %zu\n",
+				dio_align, writesize);
+		return;
+	}
 
 	/* Get the default huge page size */
 	h_pagesize = default_huge_page_size();
@@ -89,37 +122,28 @@ void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
 
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


