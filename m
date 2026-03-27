Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A26A10BA422
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9B956B00A5; Thu, 26 Mar 2026 23:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72C96B00A8; Thu, 26 Mar 2026 23:13:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAF5F6B00A9; Thu, 26 Mar 2026 23:13:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BE4956B00A5
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:13:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A2F05DB0A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:13:02 +0000 (UTC)
X-FDA: 84590371404.22.E8F11AD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 427D54000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:13:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M9J2kgQ8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774581180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2gMVERs5nD4fs9GE1Z+JDM+DqMotyc35OUdJ51PD49o=;
	b=2lSVlIZUa4hK6U9Rg3ulp8DiaOXw2nU/6LBJUI6kglnKhxOOyADTCHG8Po+VCIqgNEj8o2
	iYW6D+ZFJDglT6NnkBZCF+Uqt4gwxv+jSEZP946pWslhC7bFHYqQy6RT1cCDBm9WjZPpF/
	ZTGcTk7q2yMWQ8BKWOlbMlkovBvveMg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774581180; a=rsa-sha256;
	cv=none;
	b=W7JYiG33cGFw+sdp4BLSOm5xRV6xd2+RyzRehT+efgCsHfh9n13SFcOnbaIpJ8QyZ+tOaG
	pJ7f70qjrm9thkZL+Ap3a7tVqbIetfolxotg1ddr4fhKNhLned0zTkhanVfHdv3OqtdcMf
	RaK3GjmoDsKH818GhT7uRhw+AQ6jCsA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M9J2kgQ8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774581179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2gMVERs5nD4fs9GE1Z+JDM+DqMotyc35OUdJ51PD49o=;
	b=M9J2kgQ8x1+L4m3p4yY3IdrgB5u5bg2spXvdkwJTg5Efr5C+LWYDrDdxX/1EBH5ljm7OB0
	P6/rhN4R9uyVrAtX8MuDBq4kNQSYHSYhd/8VA74uPhvaHvE60niekwxSb4smrUbZejrGl8
	U2Y8q7H7BKzcWyklQ60SwZS3JyK46nQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-280-Of6-ZzLLOnOsTZgr9Cn7ew-1; Thu,
 26 Mar 2026 23:12:55 -0400
X-MC-Unique: Of6-ZzLLOnOsTZgr9Cn7ew-1
X-Mimecast-MFC-AGG-ID: Of6-ZzLLOnOsTZgr9Cn7ew_1774581173
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A5C6C18005B9;
	Fri, 27 Mar 2026 03:12:53 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.150])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D7A1D30001A1;
	Fri, 27 Mar 2026 03:12:47 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: aubaker@redhat.com,
	liwang@redhat.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/mm: skip hugetlb_dio tests when DIO alignment is incompatible
Date: Fri, 27 Mar 2026 11:12:43 +0800
Message-ID: <20260327031243.15903-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: J1LWn18xSGv-sHbMAtxLHzwj3MCGjXb9mBqrK4WevbE_1774581173
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 427D54000A
X-Stat-Signature: ixdpamg8c553quo9cwmkgjd416gcbmrm
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774581180-3069
X-HE-Meta: U2FsdGVkX18IDLQilTIyCbs1Q3FxEDB5qYWJ85Vpi+HenwgaeTyPC2efEb23/rH+DefXBYhW41JgK3mgnb+KgrtI7pSBzYJW/mkyg7atsIIoAeSW3BcryWLX6TPV0n1mrR+CqIdFpTaA/z1uExs/FJjzHSxXbl8eoQHqdDC5yBnh0lWk7XRcF/86XXRToa0fUv+SLmT1uUSL0EHN9YoSylhat++7xhZDsAri0q5mKTT+GcQEF4jFsujXagkobbRjzSIiTkCX2tHFJjn+6hoRgoYsggLz19j86GMDzKIcPZXTgN9Z4BA4TqTtdWuD4W4AGr8TemOC+io6vYyOJa4vDpGX8hkRtv0viQR+WIWb2v8KkDWSycqUt3ZA8uCAxoW2kCRxssG1m/edGx3yiXZTf3nSWujWUxpn+Xy3TIv+YXYJBZSluFtjTQAZmqjNxd2XMG8sehoSqDhLXMoW6QUSjvH0/lhGxm7hjdfnHcAAIQ+RXDDOx6wPq967naENyHKqPfHEgK+5DsdZ5QpjSBFrMq23tYVYvyq8m3NdAVO+KO7KVArHREjczF+wjS815KT6Ty2I91tEO2eGXMf5ECvlqN7ivEWn79FASebMxbQ0ySRo+S73BcE8fmBHI2xt74Nr57Xs4SzMUr1IGijJ2e0tl7IwMIahgXypUS798MrUESe04dpcs11Wl6Axp1jCoa/lwi9459nD9N8Umbz9pIWklBpOBb1hDgaHdtCoKNdOOoU5uX4IHmeMj89RoUkdTs8d28pcSLtb9tXSMENAWOrqGmpH5/6fQOVXsQA+T9hKDVg+gfA5IS2rJ0hnXBeT/r4MHGwBAtYZ5B+rQX7cA5nZ/4e2JujtuFjw8XK2tyQ+nyBzm0EOgE+ZmqBZSeO2rA8HLP6YIZ0IHjet9+tWFjGPftoJbBQOMjfhC5zNgX5nWcFEsfHWfkr29CLMErBePnUyYhFrW7OIqBqu5pjtiXl
 BjauJjiv
 oRu9u21pSWQAqAvstE/5wOyZFH+bLqePehiKdL2NS883/IHEK6/j5C491ah7w3hoQ28uJd9ro4+skLJWX36nSl5M09/5sRRgn5c2FbVPkLkPjlRHIRZdunHt14895pxt7Bo4oeYm81nc5u6fOuaGXj4I2Vf0TqMWu8FUFxRz64cslh5OUocC2V905Dv2ME2QVtdF3yIzap0dKq9fpPcZKqqxvMzSVq6i6t08ohjuq9+2DdirBQCmQ1/yQ3wLAXd07dFhnjWYL1j2GVg/7ZnoWGly5TDIqUsahMTi2mbyFm5Ag0EREwmKHK/ZY/RdP05GDjK99X82H1+fqyvCCHzGCelckSzcfQWa3TymURBSZcJ6pud7lU2vgRW8Dr5TQSf5Ft9c0k8G4qtSPlIs=
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

Add check_dio_alignment() which queries the filesystem's DIO alignment
requirement via statx(STATX_DIOALIGN) and skips the test early if the
sub-page offset used by the test is not compatible with the alignment
constraint.

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
 tools/testing/selftests/mm/hugetlb_dio.c | 37 +++++++++++++++++-------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
index 9ac62eb4c97d..afcca50d190e 100644
--- a/tools/testing/selftests/mm/hugetlb_dio.c
+++ b/tools/testing/selftests/mm/hugetlb_dio.c
@@ -20,6 +20,31 @@
 #include "vm_util.h"
 #include "kselftest.h"
 
+#ifndef STATX_DIOALIGN
+#define STATX_DIOALIGN		0x00002000U
+#endif
+
+void check_dio_alignment(size_t pagesize)
+{
+	int fd;
+	struct statx stx;
+	unsigned int dio_align = 1;
+
+	fd = open("/tmp", O_TMPFILE | O_RDWR, 0664);
+	if (fd < 0)
+		ksft_exit_skip("Unable to allocate file: %s\n", strerror(errno));
+
+	if (statx(fd, "", AT_EMPTY_PATH, STATX_DIOALIGN, &stx) == 0 &&
+				(stx.stx_mask & STATX_DIOALIGN))
+		dio_align = stx.stx_dio_offset_align;
+
+	close(fd);
+
+	if ((pagesize / 2) % dio_align != 0)
+		ksft_exit_skip("DIO alignment (%u) incompatible with sub-page offset %lu\n",
+				dio_align, pagesize / 2);
+}
+
 void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
 {
 	int fd;
@@ -89,16 +114,11 @@ void run_dio_using_hugetlb(unsigned int start_off, unsigned int end_off)
 
 int main(void)
 {
-	size_t pagesize = 0;
-	int fd;
+	size_t pagesize = psize();
 
 	ksft_print_header();
 
-	/* Open the file to DIO */
-	fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
-	if (fd < 0)
-		ksft_exit_skip("Unable to allocate file: %s\n", strerror(errno));
-	close(fd);
+	check_dio_alignment(pagesize);
 
 	/* Check if huge pages are free */
 	if (!get_free_hugepages())
@@ -106,9 +126,6 @@ int main(void)
 
 	ksft_set_plan(4);
 
-	/* Get base page size */
-	pagesize  = psize();
-
 	/* start and end is aligned to pagesize */
 	run_dio_using_hugetlb(0, (pagesize * 3));
 
-- 
2.53.0


